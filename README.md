# pombePheromoneSignalling2025_250423f

MATLAB code for simulating MAPK signaling in *Schizosaccharomyces pombe* mating.

This repository accompanies the study:
"Constitutively active RAS prolongs Cdc42 signalling while attenuating MAPK signalling during fission yeast mating"

Authors:
Emma J. Kelsall, Akatsuki Kimura, Abel Vertesy, Kornelis R. Straatman, Mishal Tariq, Raquel Gadea, Chandni Parmar, Gabriele Schreiber, Shubhchintan Randhawa, Takashi Y. Ida, Cyril Dominguez, Edda Klipp, and Kayoko Tanaka

Correspondence:
- Kayoko Tanaka: `kt96@le.ac.uk`
- Edda Klipp: `edda.klipp@rz.hu-berlin.de`
- Akatsuki Kimura: `akkimura@nig.ac.jp`

## Repository overview

This repository contains MATLAB scripts for two purposes:

1. Parameter optimization for Models A, B, and C.
2. Prediction / simulation of perturbation conditions using optimized parameter sets.

Top-level directories:

- `ModelA_optimization/`: parameter optimization workflow for Model A
- `ModelB_optimization/`: parameter optimization workflow for Model B
- `ModelC_optimization/`: parameter optimization workflow for Model C
- `ModelB_prediction/`: prediction scripts for Model B under multiple perturbation conditions
- `ModelC_prediction/`: prediction scripts for Model C under multiple perturbation conditions
- `common/`: shared helper functions and experimental reference data

## Requirements

- MATLAB
- Optimization Toolbox
- Parallel Computing Toolbox

The optimization scripts use `optimvar`, `optimproblem`, `fcn2optimexpr`, and `solve`.
The MCMC scripts use `parfor`.

## Before running any script

Many scripts expect files in `common/` to be available on the MATLAB path.
Before running the workflows, open MATLAB in the repository root and add `common/` to the path:

```matlab
addpath('common')
```

If you run scripts from inside a model directory, either keep `common/` on the MATLAB path or run:

```matlab
addpath(fullfile(pwd, '..', 'common'))
```

The scripts also assume that required `.mat` input files are present in the current working directory of each model folder.

## Workflow A: parameter optimization for Models A, B, and C

Use the following directories:

- `ModelA_optimization/`
- `ModelB_optimization/`
- `ModelC_optimization/`

The naming convention is:

- Model A: `CG`, `25`
- Model B: `CF`, `26`
- Model C: `CE`, `29`

### Step A-1: initial parameter estimation

Run:

- `OptimizationModelCG.m` for Model A
- `OptimizationModelCF.m` for Model B
- `OptimizationModelCE.m` for Model C

Required files:

- `RtoODE_ModelXX.m`
- `common/expvalueCDC42.mat`
- `common/plotrangeCDC42.mat`

Output:

- `Output.mat`

### Step A-2: MCMC-based parameter optimization

Run:

- `TanakaMCMC_ModelCG_s001.m` for Model A
- `TanakaMCMC_ModelCF_s001.m` for Model B
- `TanakaMCMC_ModelCE_s001.m` for Model C

Required files:

- `Output.mat`
- `diffunModel_XXYY.m`
- shared helper functions in `common/`
- `common/expvalueCDC42.mat`

Main outputs:

- `MCMC_outputPreZ.mat`
- `MCMC_outputPostZ.mat`

Here `Z` is the parallel worker index. In the current scripts, `NP = 6`.

### Step A-3: analysis of MCMC results

Run:

- `TanakaAnalysesMCMC_ModelCG.m` for Model A
- `TanakaAnalysesMCMC_ModelCF.m` for Model B
- `TanakaAnalysesMCMC_ModelCE.m` for Model C

Required files:

- `MCMC_outputPostZ.mat`
- `Output.mat`
- `RtoODE_ModelXX.m`
- `common/expvalueCDC42.mat`
- `common/plotrangeCDC42.mat`

Outputs:

- `OutputExtZ.mat`
- `OutputZ_Fig1.fig`
- `OutputZ_Fig2.fig`
- `OutputZ_Fig3.fig`
- `OutputZ_Fig4.fig`

### Step A-4: visualization of optimized parameter behavior

Run:

- `VisualizeResultsMCMC_CG.m` for Model A
- `VisualizeResultsMCMC_CF.m` for Model B
- `VisualizeResultsMCMC_CE.m` for Model C

Required files:

- `OutputExtZ.mat`
- `diffunModel_XXYY.m`
- `common/expvalueCDC42.mat`
- `common/plotrangeCDC42.mat`

## Workflow B: prediction for conditions not used in parameter fitting

Use:

- `ModelB_prediction/`
- `ModelC_prediction/`

Each condition-specific subdirectory contains a visualization script and a corresponding ODE model function.
Examples include:

- `ModelB_control/`
- `ModelB_byr1D/`
- `ModelB_byr2D/`
- `ModelB_gpa1D/`
- `ModelB_ras1D/`
- `ModelB_ste6D/`
- `ModelC_control/`
- `ModelC_byr1D/`
- `ModelC_byr2D/`
- `ModelC_gpa1D/`
- `ModelC_ras1D/`
- `ModelC_ste6D/`

Run the visualization script for the condition of interest, for example:

- `ModelB_prediction/ModelB_control/VisualizeResultsMCMC_CFnp6.m`
- `ModelC_prediction/ModelC_control/VisualizeResultsCEnp1.m`

Required files:

- the corresponding `input*.mat` file in `ModelB_prediction/` or `ModelC_prediction/`
- the corresponding `diffunModel_*.m`
- `common/expvalueCDC42.mat`
- `common/plotrangeCDC42.mat`

Notes:

- The `input*.mat` files store selected optimized parameter sets used for prediction.
- Different condition folders may use different `input*.mat` files depending on the perturbation being simulated.

## Recommended way to run the code

One practical workflow is:

1. Open MATLAB in the repository root.
2. Run `addpath('common')`.
3. Change into one optimization directory, for example `ModelB_optimization/`.
4. Run `OptimizationModelCF.m`.
5. Run `TanakaMCMC_ModelCF_s001.m`.
6. Run `TanakaAnalysesMCMC_ModelCF.m`.
7. Run `VisualizeResultsMCMC_CF.m`.
8. For prediction, move to `ModelB_prediction/` or `ModelC_prediction/`, then run the condition-specific visualization script.

## Notes on outputs

- Some result files such as `Output.mat` are included in this repository for reproducibility.
- MCMC runs can generate additional large `.mat` files depending on the number of iterations and workers.
- Figure outputs are generated as MATLAB `.fig` files, and some workflows may also generate `.png` files.

## Limitations

- The scripts are organized as analysis scripts rather than a packaged MATLAB toolbox.
- They rely on the current working directory and MATLAB path being set appropriately.
- No automated test suite is included.

## Citation

If you use this repository, please cite the associated paper when available.
