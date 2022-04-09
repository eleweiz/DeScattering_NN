clc;clear all;close all;format short;

%% Section 1: parameters definition
lambra = 606;% [nm]                         % the peak emission wavelength of mScarlet-I
%     lambra =540;                          % [nm] % the peak emission wavelength of EYFP

a=29.11*10^(-3); b=3.28;                    % costant coeficient for brain tissue: Ref: EUNJUNG MIN et al, BIOMEDICAL OPTICS EXPRESS,Vol. 8, No. 3, 2017.
sl_em=1/(a*(lambra/500)^(-b));              % Scattering Length compuation

NA = 0.95;                                  % numerical aperture
r_ex =  1.22*lambra*1e-3/NA;                % excitaion resolution

exp_t_factor = 3;                           % The constant power coeficient to make sure that the synthetic TFM images are in the same power level as experiments
dataPath_root = './_data/20190317_SOM mice/';            % data root
files = dir([dataPath_root '**/*.tif*']);   % data files are tif
z_start=14;                                 % The start depth in PSTPM image [um]
z_end=z_start+63;                           % The end depth in PSTPM image [um]
NN_x=128;NN_y=128;                          % The synthetic TFM images in x and y dimension; changed to 128*128 in the manuscript
NN_z=z_end-z_start+1;                       % The total number of depths
NN_p=round(250/217*800);                    % total number of pixels in TFM if pixel size is 217.
dx = (0.25*800)/NN_p;                       % [um] TF image's pixel size
NNN_x=512;
nn_z=round((NNN_x/NN_x));                   % number of patterns generated for each cell   
Count_nn_tem=1;
np=100;                                     % the maximum photon value used for normarlization
n1_tem=round((NN_p-NNN_x)/2)+round(NN_x/2); % the starting index for the test data
%% Section 2: Loop PSTPM files to generate training data.
for i=length(files)   % Use last file for test
    fname = fullfile(files(i).folder,files(i).name);
    info = imfinfo(fname);
    Nz = numel(info);
    kk=1;                                        % the z dimension
    z=z_start                                    % The initialization of z
    for mm=64:-1:1 
        j=(mm-1)*3+1; % loop for depth
        sPSF = sim_get_modeled_sPSF(z,sl_em,dx,round(0.5*NN_p),r_ex);   % [um] simulated PSF

        %Generate Trainng data I_temp (i.e., Groung truth), J_temp(i.e., Input). 
        [I_temp,J_temp,x_inx_rand,y_inx_rand] = Data_Gen_Spine(fname,j,NN_p,exp_t_factor,sPSF,np); 

        for nnn=1:nn_z                             % loop for y-axis generate patterns with size of NN_x*NN_y*NN_z
            for mmm=1:nn_z                         % loop for x-axis generate patterns with size of NN_x*NN_y*NN_z
                Ind_x=n1_tem+(mmm-1)*NN_x;
                Ind_y=n1_tem+(nnn-1)*NN_x;
                Ind_xr=Ind_x-round(NN_x/2):Ind_x-round(NN_x/2)+NN_x-1;  % Inx range
                Ind_yr=Ind_y-round(NN_y/2):Ind_y-round(NN_y/2)+NN_y-1;
                temp_1=I_temp(Ind_xr,Ind_yr);
                temp_2=J_temp(Ind_xr,Ind_yr);
                I_out(kk,:,:,Count_nn_tem)=single((temp_1).'); % for h5py loading in python
                I_in(kk,:,:,Count_nn_tem)=single((temp_2).');  % for h5py loading in python
                Count_nn_tem=Count_nn_tem+1;
            end
        end
        kk=kk+1;
        Count_nn_tem=1; 
        z = z+1
    end
end
%% Section 3: Save mat data for the training purpose
clearvars -except I_out I_in;
save('Testing_Numerical.mat')














