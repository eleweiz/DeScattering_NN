function [I_out_tr, I_out_tst] = MINIST_3D_Rotate(NN_x,NN_y,NN_z,N_train,N_test,np)

% Nx x dimension
% Ny y dimension
% Nz z dimension
% N_train training data size
% N_val validation data size
% N_test testing data size

Images_tem=loadMNISTImages('./MNIST/t10k-images.idx3-ubyte');  % Load MNIST data
Images_tem=reshape(Images_tem,28,28,[]);
Images_tem   = np*imresize(Images_tem,[NN_x NN_y]);
Images_tem(Images_tem(:)<0) = 0;

%% training +validation dataset
% generate 3D PSTPM like volumes from XVal
O_3d                = zeros(NN_y,NN_x,NN_z,N_train);
O_3d(:,:,round(NN_z/2),:)    = Images_tem(:,:,1:N_train);
for i=1:size(O_3d,4)
    O_3d_rot(:,:,:,i) = imrotate3(O_3d(:,:,:,i),randi([30 90]),rand(1,3),'crop');
end
I_out_tr           = O_3d_rot;

%% testing dataset
% preprocess XTest
% generate 3D PSTPM like volumes from XVal
O_3d                = zeros(NN_y,NN_x,NN_z,N_test);
O_3d(:,:,round(NN_z/2),:)    = Images_tem(:,:,N_train+1:N_train+N_test);
for i=1:size(O_3d,4)
    O_3d_rot(:,:,:,i) = imrotate3(O_3d(:,:,:,i),randi([30 90]),rand(1,3),'crop');
end
I_out_tst           = O_3d_rot;

%% display a random I_out_tst volume
% ind       = randi(100);
% O_3d      = O_3d(:,:,:,ind);
% O_3d_rot  = O_3d_rot(:,:,:,ind);
% figure;imagesc([mean(O_3d,3) mean(O_3d_rot,3)]);axis image;colorbar;title('Top-view (left:original, right:rotated)')
% figure;imagesc([max(O_3d,[],3) max(O_3d_rot,[],3)]);axis image;colorbar;title('Top-view (left:original, right:rotated)')
% figure;volshow(O_3d,    'CameraViewAngle',0,'CameraPosition',[4 4 0]);title('original')
% figure;volshow(O_3d_rot,'CameraViewAngle',0,'CameraPosition',[4 4 0]);title('rotated')

end
