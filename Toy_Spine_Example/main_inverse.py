from model import *
from tensorflow.keras.utils import plot_model
import h5py
import matplotlib.pyplot as plt
import scipy.io as sio 
from Generator_data_function import DataGenerator
H=64   # replace the x dimension of your own data
W=64   # replace the y dimension of your own data
D=64   # replace the z dimension of your own data

matfn = './Training_SpineN_in.mat'
data= h5py.File(matfn)
trainX = data['I_in']
trainX=np.reshape(trainX,trainX.shape + (1,)) 
data=None

matfn1 = './Training_SpineN_out.mat'
data1= h5py.File(matfn1)
trainY = data1['I_out']
trainY=np.reshape(trainY,trainY.shape + (1,))
data1=None

print(np.isnan(trainX).any())
print(np.isnan(trainY).any()) 
portion=0.9  # 90% portion for training purpose and 10 for validation purpose
tem=np.size(trainX,0)
Train=np.floor(tem*portion)
a_train=np.arange(0, Train, 1, int)
a_val=np.arange(Train,tem, 1, int)

#######  Generator
# Parameters
params = {'dim': (H,W,D),
          'batch_size': 3,
          'n_channels': 1,
          'shuffle': True}

# Generators
training_generator      = DataGenerator(a_train, trainX, trainY, **params)
validation_generator    = DataGenerator(a_val, trainX, trainY, **params)

# Model
model = unet(input_size = (H,W,D,1), learning_rate = 1e-4)
#plot_model(model, to_file='model_fig.png')
filepath="Trained-Model-{epoch:02d}-{val_loss:.2f}.hdf5"
model_checkpoint = ModelCheckpoint(filepath, monitor='val_loss',verbose=1, save_best_only=True, period=1)

############ train
history =model.fit_generator(training_generator,steps_per_epoch=60,epochs=2,callbacks=[model_checkpoint],validation_data=validation_generator, validation_steps=3)

dataNew = './Results/loss_history.mat'    # save data
Results_CNN=history.history
sio.savemat(dataNew, history.history) 
