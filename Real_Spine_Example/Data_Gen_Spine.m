function [I_temp, J_temp,x_inx_rand,y_inx_rand] = Data_Gen_Spine(fname,j,NN_p,exp_t_factor,sPSF,np)
inx_tem1=100;                           % Avoid use boundary pixels of the tif PSTPM images;
I_temp1 = single(imread(fname,j));      % Red channel
I_temp2 = imresize(I_temp1,[NN_p NN_p]);
I_temp=exp_t_factor*round(I_temp2);     % match power in exp

I_temp3=I_temp;

J_temp = conv2(I_temp3,sPSF,'same');    % scale magnification
J_temp(J_temp<0)=0;

J_temp = poissrnd(J_temp);
J_temp= J_temp;
J_temp=round(J_temp);

I_temp(I_temp<0)=0;
I_temp(I_temp>np)=np;

J_temp(J_temp<0)=0;
J_temp(J_temp>np)=np;

[x_inx,y_inx]=find(I_temp>0.2*np);
Inx_tem=(x_inx>inx_tem1).*(y_inx>inx_tem1).*(x_inx<NN_p-inx_tem1).*(y_inx<NN_p-inx_tem1);
AA=find(Inx_tem>0.1);
x_inx_rand=x_inx(AA);
y_inx_rand=y_inx(AA);

end
