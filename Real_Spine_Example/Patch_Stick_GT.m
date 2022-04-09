function [Gt_L] = Patch_Stick_GT(NNN_x,N_x,N_y,N_z,GT_CNN)

nn_z=round((NNN_x/N_x)); % number of patters generated for each cell
Gt_L=zeros(NNN_x,NNN_x,N_z,'single');
n1_tem=round(N_x/2);

for nn=1:nn_z  % loop for y-axis generate random patterns
    for mm=1:nn_z % loop for x-axis generate random patterns
        NN_n=(nn-1)*(round(NNN_x/N_x))+mm;  
        Ind_x=n1_tem+(mm-1)*N_x;
        Ind_y=n1_tem+(nn-1)*N_x;
        Ind_xr=Ind_x-round(N_x/2)+1:Ind_x-round(N_x/2)+N_x;  % Inx range
        Ind_yr=Ind_y-round(N_y/2)+1:Ind_y-round(N_y/2)+N_y;
        Gt_L(Ind_xr,Ind_yr,:)=(GT_CNN(NN_n,:,:,:));
        
    end
end
