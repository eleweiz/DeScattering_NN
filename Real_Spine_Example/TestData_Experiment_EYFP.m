clc;clear all;
close all;
format short;

%% Section 1: parameters definition for input
exp_t_factor = 1;                                         % The constant power coeficient is 1, which means keep data unchanged.
dataPath_root = './_data/MouseID_CTG001_Cell1/TFM'; % data root
files = dir([dataPath_root '/*.tif*']);
z_temp1=134;                                             % Start point of z in experimental tif
z_temp2=134-63;                                           % End point of z  in experimental tif
NN_z=z_temp1-z_temp2+1;                                   % The z dimension;
NN_x=128;NN_y=128;                                        % The x and y dimension; 
NNN_x=512*2;                                              % total number of pixels used in our tests
NN_px=582*2;                                              %total number of pixels in experimental tif
NN_py=631*2;                                              %total number of pixels in experimental tif
nn_z=round((NNN_x/NN_x));                                 % number of patters generated for each cell
I_in=zeros(NN_z,NN_y,NN_x,nn_z^2,'single');               % Initialization
Count_nn=1; % Count for number of data
n1_temx=round((NN_px-NNN_x)/2)+round(NN_x/2);             % the starting index for the test data x dimension
n1_temy=round((NN_py-NNN_x)/2)+round(NN_x/2);             % the starting index for the test data y dimension
np=200;                                                   % the maximum photon value used for normarlization

%% Section 2: Generate input data 
for i=1:length(files)
    fname = fullfile(files(i).folder,files(i).name);
    info = imfinfo(fname);
    Nz = numel(info);
    kk=1;                                                  % the z dimension
    for j=z_temp1:-1:z_temp2                               % loop for depth TF
        I_temp = exp_t_factor*single(imread(fname,j));     % Red channel
        M = mode(I_temp,'all');                             % the number shown most frequently in I_temp
        I_temp=I_temp-M;
        I_temp = imresize(I_temp,[NN_px NN_py]);
        I_temp=round(I_temp);
        I_temp(I_temp<0)=0;
        I_temp(I_temp>np)=np;
        for nn=1:nn_z                                       % loop for y-axis generate random patterns
            for mm=1:nn_z                                   % loop for x-axis generate random patterns
                Ind_x=n1_temx+(mm-1)*NN_x;
                Ind_y=n1_temy+(nn-1)*NN_x;
                Ind_xr=Ind_x-round(NN_x/2):Ind_x-round(NN_x/2)+NN_x-1;  % Inx range
                Ind_yr=Ind_y-round(NN_y/2):Ind_y-round(NN_y/2)+NN_y-1;
                temp_1=I_temp(Ind_xr,Ind_yr);
                I_in(kk,:,:,Count_nn)=(temp_1).'; % for h5py loading in python
                Count_nn=Count_nn+1;
            end
        end
        kk=kk+1;
        Count_nn=1;
    end
end
M_in=min(min(min(min(I_in))));
I_in=I_in-M_in;
save('Testing_Experiments_In_EYFP','I_in')



