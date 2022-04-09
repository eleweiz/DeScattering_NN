clc;
clear all;
close all;

format short;

%% parameters definition
lambra = 606;                           % [nm] % the peak emission wavelength of mScarlet-I
%     lambra =540;                      % [nm] % the peak emission wavelength of EYFP
a=29.11*10^(-3); b=3.28;                % costant coeficient for brain tissue: Ref: EUNJUNG MIN et al, BIOMEDICAL OPTICS EXPRESS,Vol. 8, No. 3, 2017.
sl_em=1/(a*(lambra/500)^(-b));          % Scattering Length

NA = 0.95;                              % numerical aperture
r_ex =  1.22*lambra*1e-3/NA;            % excitaion resolution
z_start=1;                              % The start depth in PSTPM image
z_end=32;                               % The end depth in PSTPM image
NN_x=32;NN_y=32;                        % The synthetic TFM images in x and y dimension; changed to 128*128 in the manuscript
NN_z=z_end-z_start+1;                   % The total number of depths
N_train=2000;                           % Number of training data.
N_test=500;                             % Number of test data.
dx = 0.25;                              % [um] image's pixel size
np=100;                                 % the maximum photon value used for normarlization

I_out=zeros(NN_z,NN_y,NN_x,N_train,'single');
I_in=zeros(NN_z,NN_y,NN_x,N_train,'single');
I_out_test=zeros(NN_z,NN_y,NN_x,N_test,'single');
I_in_test=zeros(NN_z,NN_y,NN_x,N_test,'single');

%% Loop PSTPM files to generate training data.
[I_temp1_train, I_temp1_test] = MINIST_3D_Rotate(NN_x,NN_y,NN_z,N_train,N_test,np);  % MNIST data
for z=z_start:1:z_end
    sPSF = sim_get_modeled_sPSF(z,sl_em,dx,round(0.5*NN_x),r_ex);                    % [um] simulated PSF
    [I_out(z,:,:,:), I_in(z,:,:,:)] = Data_Gen(I_temp1_train,sPSF,np,N_train,z);
    [I_out_test(z,:,:,:), I_in_test(z,:,:,:)] = Data_Gen(I_temp1_test,sPSF,np,N_test,z);
end

%% display one example
figure; imagesc(squeeze((I_out(round(NN_z/2),:,:,1)))); colormap hot; colorbar;title('GT')
figure; imagesc(squeeze((I_in(round(NN_z/2),:,:,1)))); colormap hot; colorbar;title('In')
figure; imagesc(squeeze((I_out_test(round(NN_z/2),:,:,1)))); colormap hot; colorbar;title('GT')
figure; imagesc(squeeze((I_in_test(round(NN_z/2),:,:,1)))); colormap hot; colorbar;title('In')

%% Save mat data for training purpose
save('Training_Toy_in','I_in')
save('Training_Toy_out','I_out')
save('Testing_Toy_in','I_in_test')
save('Testing_Toy_out','I_out_test')
% clear all;













