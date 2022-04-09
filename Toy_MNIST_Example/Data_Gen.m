function [I_out, I_in] = Data_Gen(I_temp1_train,sPSF,np,N_train,z)

for nn=1:N_train
    I_temp=round(squeeze(I_temp1_train(:,:,z,nn)));
    J_temp = conv2(I_temp,sPSF,'same');  % scale magnification
    J_temp(J_temp<0)=0;
    J_temp = poissrnd(J_temp);
    J_temp=round(J_temp);
    
    I_temp(I_temp<0)=0;
    I_temp(I_temp>np)=np;
    
    J_temp(J_temp<0)=0;
    J_temp(J_temp>np)=np;
    
    
    I_out(:,:,nn)=single((I_temp).'); % for h5py loading in python
    I_in(:,:,nn)=single((J_temp).');  % for h5py loading in python
    
end
end