# DeScattering_NN
## Configurations: 
**Suggested Environment**: Matlab+Visual Studio Code +Python 3.6.4 +  Tensorflow 2.5；

**Data format**: Set mat version in MATLAB to be 7.3 or higher (On the Home tab, in the Environment section, click Preferences. Select MATLAB > General > MAT-Files.) ；

We offer three examples for demonstration purpose: Toy MNIST, Toy Spine, and Real Spine (same as our paper). 

## Toy example (MNIST Digit):

![image](https://user-images.githubusercontent.com/47460581/122369265-9cedc300-cf90-11eb-924b-44d95bd7830f.png)

**Figure 1**: The Ground truth is 3D rotated MNIST digit. The input is TFM images generated with the forward solver from Ground truth. Output is the reconstruction from the proposed method.

There are 3 steps in total in this shared code：

**Step 1**. Generate training data with **main_forward.m**: 

**Step 2**. Train the network with **main_inverse.py**：

**Step 3**. Display your results with **Display_Results.py**: Remember to replace the trained model name at Line 25. 


## Toy example (Spine):

![image](https://user-images.githubusercontent.com/47460581/122369422-c1499f80-cf90-11eb-86bd-cbf624ab1008.png)

**Figure 2**: The Ground truth is 3D mScarlet-I experimental PSTPM stack. The input is mScarlet-I experimental TFM images. Output is the reconstruction from the proposed method.

**Data downloading**: Download the data from Zenodo: http://doi.org/10.5281/zenodo.4972170 .
Put the two folders, i.e., "PSTPM_data" and "Results", under the path *./Spine_Example*.

To display the results, use **Results_Demo.m**, where we have also offered mScarlet-I experimental results as an example.

There are 3 steps in total in this shared code to train and test the model:

**Step 1**. Generate training data with **main_forward.m**: The PSTPM stack are contained in the "PSTPM_data" folder, where others can put their own PSTPM data in the folder to generate training data.

**Step 2**. Train the network with **main_inverse.py**.

**Step 3**. Test and Save the test results with the file **Save_data.py**: Remember to replace the trained model name at Line 32.


## Real example (Spine): The real data used in the paper

**Data downloading**: Download the data from Zenodo:XXXXX. Put the _data under the current path.

There are 4 steps in total in this shared code to train and test the model:

**Step 1**. Generate training data with **main_forward_Scarlet.m**: If you want to train a EYFP model, please use **main_forward_EYFP.m** instead.

**Step 2**. Train the network with **main_inverse.py**: Remember to change the training data file names in Lines 10 and 16 if you train a EYFP model.

**Step 3**. Generate testing data with **TestData_Experiment_Scarlet.m**: If you want to generate a EYFP test data, please use **TestData_Experiment_EYFP.m** instead.

**Step 4**. Test and save the test results with the file **Save_data_Experiment_Scarlet.py**: If you want to save a EYFP results, please use **TestData_Experiment_EYFP.py** instead. Remember to replace the trained model name in Line 25. 

**To display the results**: Use Matlab files in folder **Results** with **Results_Demo_Numerical.m**, **Results_Demo_Experiments_Scarlet.m**, and **Results_Demo_Experiments_EYFP.m** being numerical results, experiments for Scarlet, and experiments for EYFP, respectively.
