from model import *
from tensorflow.keras.utils import plot_model

import matplotlib.pyplot as plt
import scipy.io as sio 
import h5py
import time
H=64
W=64
D=64
                
matfn = './Training_SpineN_in.mat'  # replace this file with the input of your own test example
data= h5py.File(matfn)
trainX = data['I_in']

matfn = './Training_SpineN_out.mat' # replace this file with the Ground truth of your own test example
data= h5py.File(matfn)
trainY = data['I_out']
trainX=np.reshape(trainX,trainX.shape + (1,)) 
trainY=np.reshape(trainY,trainY.shape + (1,)) 

tem=np.size(trainX,0)
D_tem=np.size(trainX,3)
D_loop=np.int_(np.floor(D_tem/D))
Train=0
a_val=np.arange(Train,tem, 1, int)

model = unet(input_size = (H,W,D,1), learning_rate = 1e-4)

############ test
# '''
model.load_weights("Trained-Model-02-16.86.hdf5")  # use the trained model file to replace this file
Inx_N=np.int_(np.floor(tem-Train))
I_CNN = np.empty((Inx_N, H, W, D_tem))
O_CNN = np.empty((Inx_N, H, W, D_tem))
Results_CNN={}


start = time.clock()
for inx1 in range(Inx_N):                         # loop for patch
    inx=a_val[inx1]
    for inx_D in range(D_loop):                   # loop for set of Depths
        inx_D_tem=(inx_D)*D
        test_inp=trainX[inx,:,:,inx_D_tem:inx_D_tem+D]
        test_inp=np.reshape(test_inp, (1,)+test_inp.shape) 
        results = model.predict(test_inp,batch_size=1)
        for test_inx_tem in range(D):             # loop for  Depths
            results_m=np.squeeze(results[0,:,:,test_inx_tem])
            test_inx=inx_D_tem+test_inx_tem
            I_CNN[inx1,:,:,test_inx]=np.squeeze(trainX[inx,:,:,test_inx,:])
            O_CNN[inx1,:,:,test_inx]=np.squeeze(results_m)

elapsed = (time.clock() - start)
print("Time used:",elapsed)
dataNew = './Results/Results.mat'                 # save data
Results_CNN={'I_CNN':I_CNN, 'O_CNN':O_CNN}
sio.savemat(dataNew, Results_CNN) 








