%% The code is to stick mutliple patches;
%% Written by Zhun Wei at Harvard on 26/07/2019;

%% Section 1: Parameters
clc;clear all;close all;
load ('Results_Numerical.mat');
[NN, N_x, N_y, N_z]=size(O_CNN);  % The dimensions of the patches
NNN_x=512;  % The Nx dimensions of the whole image
nn_z=round((NNN_x/N_x)); % number of patters generated for each cell
Gt_L=zeros(NNN_x,NNN_x,N_z,'single');
In_L=zeros(NNN_x,NNN_x,N_z,'single');
Out_L=zeros(NNN_x,NNN_x,N_z,'single');
n1_tem=round(N_x/2);
D=64;
D_loop=N_z/D;
inx_nn=1;

%% Section 2: Stick patterns 
for nn=1:nn_z  % loop for y-axis generate random patterns
    for mm=1:nn_z % loop for x-axis generate random patterns
        NN_n=(nn-1)*4+mm;
        Ind_x=n1_tem+(mm-1)*N_x;
        Ind_y=n1_tem+(nn-1)*N_x;
        Ind_xr=Ind_x-round(N_x/2)+1:Ind_x-round(N_x/2)+N_x;  % Inx range
        Ind_yr=Ind_y-round(N_y/2)+1:Ind_y-round(N_y/2)+N_y;
        Gt_L(Ind_xr,Ind_yr,:)=(GT_CNN(NN_n,:,:,:));
        In_L(Ind_xr,Ind_yr,:)=(I_CNN(NN_n,:,:,:));
        Out_L(Ind_xr,Ind_yr,:)=(O_CNN(NN_n,:,:,:));
        
    end
end

%% Section 3: Display Results
GT_Lm=max(Gt_L,[],3);
In_Lm=max(In_L,[],3);
Out_Lm=(max(Out_L,[],3));

% Display Max Projection
figure; nn_p=100;
subplot(1,3,1);
imshow(GT_Lm,[0,nn_p]); 
title('GT');
colormap gray
subplot(1,3,2);
imshow(In_Lm,[0,nn_p]); title('In');
colormap gray
subplot(1,3,3);
imshow(Out_Lm,[0,nn_p]); title('Out');
colormap gray

% Display One Depth
In_x=1:512; In_y=1:512;nz=34;
GT_t1=Gt_L(In_x,In_y,nz); In_t1=In_L(In_x,In_y,nz); Out_t1=Out_L(In_x,In_y,nz); 
nz=13;
figure 
nn_p=50;
subplot(1,3,1);
imshow(squeeze(GT_t1),[0,nn_p]);colormap gray; 
 title('GT');
subplot(1,3,2);
imshow(squeeze(In_t1),[0,nn_p]);colormap gray; title('In');
subplot(1,3,3);
imshow(squeeze(Out_t1),[0,nn_p]);colormap gray; title('Out');

%% Section 4:  Save results as tif 
%Save tif images in seperate file from 1-64
for i=1:64
    J=uint16(Out_L(:,:,i));                                  
    nn=i;  % The name of the tif figure
    imwrite(J,[num2str(nn,'%04d'),'.tif']);
end

%Save tif images in a single stack file from 1-64
outputFileName = '000_total_stack.tif'  % The name of the tif figure
img=uint16(Out_L(:,:,1:64));
for K=1:64
   imwrite(img(:, :, K), outputFileName, 'WriteMode', 'append',  'Compression','none');
end






