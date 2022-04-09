function [temp_1, temp_2] = Patch_Gen_Spine(x_inx_rand,y_inx_rand,I_temp,J_temp,NN_x,NN_y,nn)
len=length(x_inx_rand)-1;                               % Avoid zero indx
rand('state', nn);
Ind_x=x_inx_rand(round(len*rand)+1);
rand('state', nn);
Ind_y=y_inx_rand(round(len*rand)+1);
Ind_xr=Ind_x-round(NN_x/2):Ind_x-round(NN_x/2)+NN_x-1;  % Inx range
Ind_yr=Ind_y-round(NN_y/2):Ind_y-round(NN_y/2)+NN_y-1;
temp_1=I_temp(Ind_xr,Ind_yr);
temp_2=J_temp(Ind_xr,Ind_yr);
end