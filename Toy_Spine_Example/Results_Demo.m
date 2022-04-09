%% The code is to stick mutliple patches;
clc;clear all;close all;
%% Section 1: Ground truth load
load ('Results/Results_GroundTruth.mat');
[NN_GT, N_x, N_y, N_z]=size(GT_CNN);    % The dimensions of the patches
NNN_x=512;                              % The Nx dimensions of the whole image
[Gt_L] = Patch_Stick_GT(NNN_x,N_x,N_y,N_z,GT_CNN);

%% Section 2:Neural Network Input and Output
load ('Results/Results_InputOutput.mat');
[NN_O, N_x, N_y, N_z]=size(O_CNN);      % The dimensions of the patches
NNN_x=512*2;                            % The Nx dimensions of the whole image
[In_L] = Patch_Stick_GT(NNN_x,N_x,N_y,N_z,I_CNN);
[Out_L] = Patch_Stick_GT(NNN_x,N_x,N_y,N_z,O_CNN);

%% Section 3: display Maximum projection of 3D spine
In_Lm=max(In_L,[],3);
Out_Lm=(max(Out_L,[],3));
GT_Lm=max(Gt_L,[],3);
figure; nn_p=100;

subplot(1,3,1);
imshow(GT_Lm,[1,nn_p]); title('GroundTruth (Max Projection)');
colormap gray
subplot(1,3,2);
imshow(In_Lm,[1,nn_p]); title('Input (Max Projection)');
colormap gray
subplot(1,3,3);
imshow(Out_Lm,[1,nn_p]); title('Output (Max Projection)');
colormap gray

%% Section 4: display spine at a specific depth (z=52 um)
In_x=1:1024; In_y=1:1024;nz=52;
In_t1=In_L(In_x,In_y,nz); Out_t1=Out_L(In_x,In_y,nz); GT_t1=Gt_L(:,:,nz); 
figure;
nn_p=85;nn_p1=1;
subplot(1,3,1);
imshow(squeeze(GT_t1),[0,20]);colormap gray; title('GroundTruth (z=52)');
subplot(1,3,2);
imshow(squeeze(In_t1),[nn_p1,nn_p]);colormap gray; title('Input (z=52)');
subplot(1,3,3);
imshow(squeeze(Out_t1),[nn_p1,nn_p]);colormap gray; title('Output (z=52)');








