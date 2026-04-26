# CFS2025_LORO

R code accompanying the paper:

> Okhrimenko, M., Castilla, G., and Hopkinson, C. (2026).  
> **A framework for developing spatially transferable models of boreal forest biomass from airborne lidar.**  
> *Forestry: An International Journal of Forest Research*, 99(2), cpag003.  
> https://doi.org/10.1093/forestry/cpag003

## Overview

This repository contains the R scripts used to develop and evaluate airborne lidar models of boreal forest aboveground biomass (AGB) using **leave-one-region-out cross-validation (LORO-CV)**.

The main purpose of the project is to test whether empirical area-based lidar models can be made more spatially transferable across forest regions. Rather than selecting models only by in-sample fit or random cross-validation accuracy, the workflow evaluates each candidate model by omitting one region at a time, fitting the model on the remaining regions, and testing prediction accuracy and regional bias in the omitted region.

The code supports the modelling framework described in the paper, including:

- generation and updating of lidar metric tables;
- best-subset model selection from candidate lidar metrics;
- comparison of linear, square-root, and log-log model forms;
- leave-one-region-out validation by forest region;
- calculation of RMSE, bias, regional bias, VIF, and related diagnostics;
- preparation of model tables and workflow figures used in the manuscript.

## Scientific context

The study focuses on airborne laser scanning (ALS / lidar) models for estimating aboveground biomass in boreal forest inventory applications. The modelling problem is not only to obtain a low overall RMSE, but to identify models that remain approximately unbiased when transferred to regions that were not used for model calibration.

The published analysis used multispectral ALS metrics and forest inventory plots from four regions in the southern Taiga Plains of the Northwest Territories, Canada. Candidate models were screened using best-subset selection, multicollinearity diagnostics, LORO-CV performance, and regional bias criteria.

## Repository structure

```text
CFS2025_LORO/
│
├── Figure_workflow.R
├── Figure_workflow_v2.R
│   Scripts for preparing workflow and manuscript figures.
│
├── LiveLarge_update.R
│   Updates and reformats previously generated model tables.
│   Includes conversion from earlier LOOV naming to LORO terminology,
│   recalculation of regional percentage RMSE and bias, and model ranking.
│
├── UpdateMainDF.R
│   Updates the main modelling data frame after correcting or replacing
│   lidar metric columns.
│
├── Model1_metrics_range.R
│   Computes summary ranges for selected lidar metrics used in one of the
│   reported models.
│
├── TestInput.R
├── Test_C3.R
│   Small test and diagnostic scripts.
│
├── LOOV/
│   Main model-selection and validation scripts.
│   Historical filenames use "LOOV", but the validation design corresponds
│   to leave-one-region-out cross-validation, referred to in the paper as LORO-CV.
│
│   Examples:
│   ├── LOOV_validation_v*_Linear.R
│   ├── LOOV_validation_v*_LogLog.R
│   ├── LOOV_validation_v*_SQRT.R
│   ├── QAVintoSQRT_v2.R
│   ├── Test_C3*.R
│   └── Results/
│
└── X/
    Supporting scripts for lidar metric generation, merging, and data assembly.
    
    Examples:
    ├── Metrics_*.R
    ├── Metrics_Intensities_*.R
    ├── Metrics_Rasters_*.R
    ├── Metrics_Voxels_*.R
    ├── Merge_*.R
    └── Rbind_*.R
```

## Terminology note: LOOV vs LORO

Some script names use the older internal term **LOOV**. In the paper and in this README, the method is referred to as **LORO-CV**: leave-one-region-out cross-validation.

In this workflow, each region is omitted in turn, the model is fitted using plots from the remaining regions, and predictions are evaluated on the omitted region. This is used to assess spatial transferability and regional bias.

## Model forms

The repository includes scripts for several model forms considered in the analysis:

1. **Linear models**

   ```text
   AGB ~ lidar metrics
   ```

2. **Square-root response models**

   ```text
   sqrt(AGB) ~ lidar metrics
   ```

3. **Log-log / power-form models**

   ```text
   log(AGB) ~ log(lidar metrics)
   ```

Candidate models are evaluated using in-sample statistics, random validation in some scripts, and LORO-CV by region.

## Data availability

Large input datasets, lidar point clouds, intermediate model tables, and generated outputs are not included in this repository.

To run the full workflow, users need access to the input forest inventory and lidar metric tables described in the paper. File paths in the scripts reflect the original local Windows research environment and may need to be edited before running the code on another machine.

## Requirements

The scripts are written in R. Depending on the script, required packages may include:

```r
dplyr
tidyr
purrr
tidyverse
leaps
caret
car
lmtest
tictoc
ggplot2
```

Install missing packages in R, for example:

```r
install.packages(c(
  "dplyr", "tidyr", "purrr", "tidyverse",
  "leaps", "caret", "car", "lmtest", "tictoc", "ggplot2"
))
```

## General workflow

The repository is organized as research code rather than as a single automated R package. A typical workflow is:

1. Prepare or obtain the forest inventory and lidar metric tables.
2. Update local file paths in the scripts.
3. Use scripts in `X/` if lidar metric generation or table assembly is required.
4. Use `UpdateMainDF.R` and related scripts to update the modelling data frame.
5. Run the model-selection and validation scripts in `LOOV/`.
6. Summarize candidate models by in-sample fit, VIF, LORO-CV RMSE, and regional bias.
7. Use the figure scripts to reproduce workflow diagrams and manuscript-supporting graphics.

## Important limitations

This repository is intended to document and share the code used for the published analysis. It is not a turn-key reproducibility package.

In particular:

- the original large data files are not included;
- several scripts contain local file paths from the original analysis environment;
- some filenames preserve historical naming conventions;
- scripts were developed as part of an active research workflow and may require path or object-name updates before reuse.

## Citation

If you use this code or adapt the LORO-CV framework, please cite:

```bibtex
@article{Okhrimenko2026LORO,
  author  = {Okhrimenko, Maxim and Castilla, Guillermo and Hopkinson, Chris},
  title   = {A framework for developing spatially transferable models of boreal forest biomass from airborne lidar},
  journal = {Forestry: An International Journal of Forest Research},
  volume  = {99},
  number  = {2},
  pages   = {cpag003},
  year    = {2026},
  doi     = {10.1093/forestry/cpag003}
}
```

## Contact

For questions about the paper or code, please contact the corresponding author listed in the published article.
