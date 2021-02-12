Name: Dinh Nguyen
CS 383
Homework 2 part 2

************************************

To run the code, open up the hw2.m matlab script and click the run button. 

The diabetes.csv or any data file should be in the same current working 
directory with the matlab script.

The script will parse through the data file, analyze it and then build 3 
videos K_2.avi, K_3.avi and K_4.avi matching with the number of clusters
k=2,3 and 4 in the same working directory.

To play the video, open the current directory with file browser and double 
click on the *.avi videos.

Implement Info:
1 <= k <= N
D > 1
Using L2 distance (Euclidean)
Terminate when the sum of magnitude of change of the cluster centers (from
the previous iteration to the current one) is less than e = 2^-23.
