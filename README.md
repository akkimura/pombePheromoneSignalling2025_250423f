# pombePheromoneSignalling2025_250423f
The MATLAB codes are used to simulate MAPK signaling in S. pombe. </br>
The codes are used in the submitted research titled “Constitutively active RAS prolongs Cdc42 signalling while attenuating MAPK signalling during fission yeast mating”. The authors are: </br>
Emma J. Kelsall, Akatsuki Kimura*, Ábel Vértesy, Kornelis R. Straatman, Mishal Tariq, Raquel Gadea, Chandni Parmar, Gabriele Schreiber, Shubhchintan Randhawa, Takashi Y. Ida, Cyril Dominguez, Edda Klipp* and Kayoko Tanaka* </br>
*Correspondence: kt96@le.ac.uk (K.T.), edda.klipp@rz.hu-berlin.de (E.K.), akkimura@nig.ac.jp (A.K.) </br>
 </br>
  </br>
<B>A.	Optimization of the parameters of models A, B and C (Figs. 8, S12-S14): The directories ‘ModelA _optimization’, ‘ModelB_optimisation’, ‘ModelC_optimisation’ and ‘common’.</B> </br>
 </br>
Step A-1: initial guess using MATLAB’s optimization toolbox </br>
Run ‘OptimizationModelXX.m’ (XX corresponds to CG for Model A, CF for Model B, and CE for Model C) </br>
This code requires the files ‘RtoODE_ModelXX.m’, ‘expvalueCDC42.mat’(in the ‘common’ directory), and ‘plotrangeCDC42.mat’(in the ‘common’directory). </br>
This code’s output is stored in ‘Output.mat’ file. </br>
 </br>
Step A-2: Optimization of the parameters using an MCMC method. The code uses MATLAB’s parallel computing toolbox
Run ‘TanakaMCMC_ModelXX_s001.m’. </br>
This code required the files ‘Output.mat’, ‘diffunModel_XXYY.m’, as well as all the 10 files in the ‘common’ directory. (YY corresponds to 25 for Model A, 26 for Model B, and 29 for Model C) </br>
This code’s output is stored in ‘MCMC_outputPreZ.mat’ and ‘MCMC_outputPostZ.mat’ files. (Z corresponds to the number of parallel trial, 1 to 6 in this case.) </br>
 </br>
Step A-3: Analyze and plot the results of the optimization </br>
Run ‘TanakaAnalysesMCMC_ModelXX.m’ </br>
This code requires ‘MCMC_outputPostZ.mat’ files as well as ‘Output.mat’, ‘RtoODE_ModelXX.m’, ‘expvalueCDC42.mat’, and ‘plotrangeCDC42.mat’. </br>
This code’s output is stored in ‘OutputExtZ.mat’, ‘OutputZ_Fig1.fig’, ‘OutputZ_Fig2.fig’, ‘OutputZ_Fig3.fig’, and ‘OutputZ_Fig4.fig’. </br>
 </br>
Step A-4: Visualize how each parameter changes </br>
Run ‘VisualizeResultsMCMC_XX.m’ </br>
This code requires ‘OutputExtZ.mat’ files, as well as ‘diffunModel_XXYY.m’, ‘expvalueCDC42.mat’, and ‘plotrangeCDC42.mat’. </br>
 </br>
  </br>
<B>B.	Prediction of the experimental results that are not used for the optimization of the parameters (Fig. S15): The directories ‘ModelB/C_prediction’</B> </br>
The conditions are shown in the directory names such as ‘ModelB/C_byr1D’, ‘ModelB/C_byr2D’ etc. </br>
Run the code such as ‘VisualizeResultsCEnp1.m’.  </br>
This code requires ‘input.mat’ file, as well as ‘diffunModel_XXYY.m’, ‘expvalueCDC42.mat’, and ‘plotrangeCDC42.mat’. The ‘input.mat’ files are one of the ‘OutputExtZ.mat’ file that gave the most optimal set of the parameters. </br>
