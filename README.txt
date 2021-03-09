Data simulation and analysis for Tucker et al. 2021. Effective sampling area is a major driver of power to detect long-term trends in multispecies occupancy monitoring. Ecosphere.

Programs needed to run code:
R
MARK

Support files needed to run code:
grid.txt 
UniformLandscape.tif 

AnalysisFun.R
buildUseLayers.R 
createGrid.R 
sample_ind.R 
Test_Samples.R
use_surface.R 
WeaselFun.R
WeaselerFun.R
predictPower.R

R Code for processing. Run in this order:
1) RunFile_createReplicates.R
2) RunFile_testReplicates.R

*More detailed descriptions of the createReplicates and testReplicates functions as well as parameters 
definitions in the code and model output can be found in Ellis et al. 2015, from which this simulation code was adapted:

Ellis, M.M., Ivan, J.S., Tucker, J.M. and Schwartz, M.K., 2015. rSPACE: Spatially based power analysis 
	for conservation and ecology. Methods in Ecology and Evolution, 6(5), pp.621-625.

For each of the two RunFiles must edit the following in code to run: 
working directory
nRuns (# replicates of each simulation)
scenarios_to_test

*Note run times for simulation replicates can be lengthy, especially for large landscapes and/or large initial poppulation sizes.
For the example code nRuns=1 to minimize run time

When running RunFile_createReplicates.R the console will show the phrase "# fit at start'
This represents the initial population size of each type of individual (male, female) created on the landscape
For example for an intial population size of n=150 and a 60%:40% Male:Female ratio (MFratio=c(0.6:0.4) the console would show:
'90 fit at start'  (# males)
'60 fit at start'  (# females)