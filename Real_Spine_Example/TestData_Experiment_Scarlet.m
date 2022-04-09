clc;clear all;close all;format short;

%% Section 1: parameters definition for input
exp_t_factor = 1;                                         % The constant power coeficient is 1, which means keep data unchanged.
dataPath_root = './_data/TFM/TF_cellfill_pixelsize217nm'; % data root
files = dir([dataPath_root '/*.tif*']);
z_temp1=161;                                              % Start point of z in experimental tif
z_temp2=161-63;                                           % End point of z  in experimental tif
NN_z=z_temp1-z_temp2+1;                                   % The z dimension;
NN_x=128;NN_y=128;                                        % The x and y dimension; 
NNN_x=512*2;                                              % total number of pixels used in our tests
NN_p=1200;                                                % total number of pixels in experimental tif
nn_z=round((NNN_x/NN_x));                                 % number of patters generated for each cell
I_in=zeros(NN_z,NN_y,NN_x,nn_z^2,'single');               % Initialization
Count_nn_tem=1;                                               % Count for number of data
n1_tem=round((NN_p-NNN_x)/2)+round(NN_x/2);               % the starting index for the test data
np=100;                                                   % the maximum photon value used for normarlization
%% Section 2: Generate input data 
for i=1:length(files)
    fname = fullfile(files(i).folder,files(i).name);
    info = imfinfo(fname);
    Nz = numel(info);
    kk=1;                                                  % the z dimension
    for j=z_temp1:-1:z_temp2                               % loop for depth PS  % loop for depth TF
        I_temp = exp_t_factor*single(imread(fname,j));     % Red channel
        M = mode(I_temp,'all');                            % the number shown most frequently in I_temp
        I_temp=I_temp-M;
        I_temp(I_temp<0)=0;
        I_temp(I_temp>np)=np;
        for nn=1:nn_z                                       % loop for y-axis generate patterns
            for mm=1:nn_z                                   % loop for x-axis generate patterns
                Ind_x=n1_tem+(mm-1)*NN_x;
                Ind_y=n1_tem+(nn-1)*NN_x;
                Ind_xr=Ind_x-round(NN_x/2):Ind_x-round(NN_x/2)+NN_x-1; 
                Ind_yr=Ind_y-round(NN_y/2):Ind_y-round(NN_y/2)+NN_y-1;
                temp_1=I_temp(Ind_xr,Ind_yr);
                I_in(kk,:,:,Count_nn_tem)=(temp_1).';          
                Count_nn_tem=Count_nn_tem+1;      
            end
        end
        kk=kk+1;
        Count_nn_tem=1;
    end
end
%% Section 3: Save Input data
M_in=min(min(min(min(I_in))));
I_in=I_in-M_in;
save('Testing_Experiments_In_Scarlet','I_in')


