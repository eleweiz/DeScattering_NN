from model import *
from tensorflow.keras.utils import plot_model

import matplotlib.pyplot as plt
import scipy.io as sio 
import h5py
import time
H=32
W=32
D=32
                
matfn = './Testing_Toy_in.mat'  # replace this file with the input of your own test example
data= h5py.File(matfn)
trainX = data['I_in_test']

matfn = './Testing_Toy_out.mat' # replace this file with the Ground truth of your own test example
data= h5py.File(matfn)
trainY = data['I_out_test']
trainX=np.reshape(trainX,trainX.shape + (1,)) 
trainY=np.reshape(trainY,trainY.shape + (1,)) 

model = unet(input_size = (H,W,D,1), learning_rate = 1e-4)

############ test
model.load_weights("Trained-Model-05-0.75.hdf5")  # use the trained model file to replace this file
Inx_N=2  # show two examples


for inx in range(Inx_N):   # loop for patch
    test_inp=trainX[inx,:,:,:]
    test_inp=np.reshape(test_inp, (1,)+test_inp.shape) 
    results = model.predict(test_inp,batch_size=1)
    
    GT_CNN=np.squeeze(trainY[inx,:,:,:])
    I_CNN=np.squeeze(trainX[inx,:,:,:])
    O_CNN=np.squeeze(results)

# display z=16
    plt.figure(figsize=[18, 30])
    h1 = plt.subplot(2, 3, 1)
    h1.set_title('Ground truth (PSTPM) z=16')
    plt.imshow(np.squeeze(GT_CNN[:,:,15]))
    plt.colorbar()

    h1 = plt.subplot(2, 3, 2)
    h1.set_title('Input (TFM) z=16')
    plt.imshow(np.squeeze(I_CNN[:,:,15]))
    plt.colorbar()

    h1 = plt.subplot(2, 3, 3)
    h1.set_title('NN Output z=16')
    plt.imshow(np.squeeze(O_CNN[:,:,15]))
    plt.colorbar()

# display maximum projection
    h1 = plt.subplot(2, 3, 4)
    h1.set_title('Ground truth (PSTPM) Max Projection')
    plt.imshow(np.squeeze(np.max(GT_CNN, axis=-1)))
    plt.colorbar()

    h1 = plt.subplot(2, 3, 5)
    h1.set_title('Input (TFM) Max Projection')
    plt.imshow(np.squeeze(np.max(I_CNN, axis=-1)))
    plt.colorbar()

    h1 = plt.subplot(2, 3, 6)
    h1.set_title('NN Output Max Projection')
    plt.imshow(np.squeeze(np.max(O_CNN, axis=-1)))
    plt.colorbar()

    plt.show()