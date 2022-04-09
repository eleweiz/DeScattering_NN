clc;clear all;close all;format short;

%% Section 1: parameters definition
lambra = 606;% [nm]                         % the peak emission wavelength of mScarlet-I
%     lambra =540;                          % [nm] % the peak emission wavelength of EYFP

a=29.11*10^(-3); b=3.28;                    % costant coeficient for brain tissue: Ref: EUNJUNG MIN et al, BIOMEDICAL OPTICS EXPRESS,Vol. 8, No. 3, 2017.
sl_em=1/(a*(lambra/500)^(-b));              % Scattering Length compuation

NA = 0.95;                                  % numerical aperture
r_ex =  1.22*lambra*1e-3/NA;                % excitaion resolution

exp_t_factor = 3;                           % The constant power coeficient to make sure that the synthetic TFM images are in the same power level as experiments
dataPath_root = './PSTPM_data/';            % data root
files = dir([dataPath_root '**/*.tif*']);   % data files are tif
z_start=1;                                  % The start depth in PSTPM image
z_end=64;                                   % The end depth in PSTPM image
NN_x=64;NN_y=64;                            % The synthetic TFM images in x and y dimension; changed to 128*128 in the manuscript
NN_z=z_end-z_start+1;                       % The total number of depths
NN_t=round(length(files)*200);              % total number of data.
NN_p=round(250/170*800);                    % total number of pixels in TFM：the pixel size of PSTPM and TFM are 250nm and 170nm, respectively.
dx = (0.25*800)/NN_p;                       % [um] TF image's pixel size
nn_z=round(NN_t/(length(files)));           % number of patters generated from each tif: should be integer
Count_nn_tem=1;
np=100;                                     % the maximum photon value used for normarlization

%% Section 2: Loop PSTPM files to generate training data.
for i=1:length(files)
    fname = fullfile(files(i).folder,files(i).name);
    info = imfinfo(fname);
    Nz = numel(info);
    kk=1;                                        % the z dimension
    z=z_start                                    % The initialization of z
    for mm=64:-1:1
        j=mm;                                    % loop for depth：Red Channel image
        sPSF = sim_get_modeled_sPSF(z,sl_em,dx,round(0.5*NN_p),r_ex);   % [um] simulated PSF

        %Generate Trainng data I_temp (i.e., Groung truth), J_temp(i.e., Input). 
        [I_temp,J_temp,x_inx_rand,y_inx_rand] = Data_Gen_Spine(fname,j,NN_p,exp_t_factor,sPSF,np); 
        
        for nn=Count_nn_tem:Count_nn_tem+nn_z-1  % loop to randomly select NN_x*NN_y small patterns from NN_p*NN_p large pattern      
            [temp_1, temp_2] = Patch_Gen_Spine(x_inx_rand,y_inx_rand,I_temp,J_temp,NN_x,NN_y,nn);
            I_out(kk,:,:,nn)=single((temp_1).'); % save for ground truth of training data
            I_in(kk,:,:,nn)=single((temp_2).');  % save for input of training data
        end
        
        kk=kk+1;
        if kk>NN_z
            Count_nn_tem=nn+1;                   % if all z direction has counted, then start count at maximum point
        end
        z = z+1
    end
end

%% Section 3: display one example of Ground truth and input
figure; imagesc(squeeze((I_out(1,:,:,1)))); colormap hot; colorbar;title('Ground Truth')
figure; imagesc(squeeze((I_in(1,:,:,1)))); colormap hot; colorbar;title('Input')

%% Section 4: Save mat data for the training purpose
save('Training_SpineN_in','I_in')
save('Training_SpineN_out','I_out')














