# MATLAB code associated with the published article

This repository contains the MATLAB code used in the published article associated with the following work:

**Gaona, À., Guisasola, A., and Baeza, J. A.**  
**An integrated TOPSIS framework with Full-Range Weight Sensitivity Analysis for robust decision analysis**  
*Decision Analytics Journal*, **17** (December 2025), 100642.  
https://doi.org/10.1016/j.dajour.2025.100642

If you use this repository, please cite the original article above.

## Authors

- Àlex Gaona Soler (Alex.Gaona@uab.cat)
- Albert Guisasola Canudas
- Juan Antonio Baeza Labat (JuanAntonio.Baeza@uab.cat)

GENOCOV Research Group, Department of Chemical, Biological and Environmental Engineering, School of Engineering, Universitat Autònoma de Barcelona

## Contents of the repository

The code implements the proposed **Full Range Weight Sensitivity Analysis (FRWSA)** approach and compares it with conventional **Weight Sensitivity Analysis (WSA)** for different multi-criteria decision-making (MCDM) methods.

Two case studies are included:
- a **general car selection example**, involving five candidate car models evaluated using seven different criteria,
- and the **wastewater treatment plant (WWTP) case study** presented in the paper.

The repository also includes additional Monte Carlo-based analyses to compare FRWSA-type graphical representations using different sampling strategies.

## Example included in this repository

In addition to the scripts directly related to the article, this repository contains a general illustrative example based on the selection of one car among five candidate models using seven different characteristics. This example is intended to help users understand how the methodology can be applied to a broader multi-criteria decision-making problem.

Supporting PDF slides are also provided to explain the methodology, the example, and the implementation details step by step.

## Software

All programs are written in **MATLAB**.

## How to run

Run one of the following main scripts depending on the desired case study or method:

- `main_TOPSIS_cars.m`
- `main_TOPSIS_WWTPs.m`
- `main_VIKOR_WWTPs.m`
- `main_MC_WWTPs.m`
- `main_dirichlet_MC_WWTPs.m`

## Terms of use

This code is made freely available for research, teaching, and general academic or technical use.

If this repository, or any part of its code or methodology, is used in a scientific article, book, thesis, report, or other scholarly work, please cite the following publication:

**Gaona, À., Guisasola, A., and Baeza, J. A.**  
**An integrated TOPSIS framework with Full-Range Weight Sensitivity Analysis for robust decision analysis**  
*Decision Analytics Journal*, **17** (December 2025), 100642.  
https://doi.org/10.1016/j.dajour.2025.100642

## Disclaimer

To the best of our knowledge, the code provided in this repository is free of errors. However, the authors make no warranty, express or implied, regarding the correctness, reliability, or suitability of the code for any purpose.

The authors cannot accept responsibility for incorrect results, errors in interpretation, or any consequences derived from the use of this software. Users are fully responsible for verifying the correctness of the results obtained with the code in their own specific applications.

If any error is detected, please report it so that a corrected version can be prepared and released.

## Derived versions and adaptations

If you develop a modified version of this code, or an implementation in another programming language based on these files, please let us know. We would appreciate being informed of derived versions and improvements.

## File description

### TOPSIS-based files

- `main_TOPSIS_cars.m` – main script that runs the car-selection example, calling TOPSIS, WSA, and FRWSA.
- `fun_TOPSIS.m` – function implementing the TOPSIS method.
- `WSA_TOPSIS.m` – function implementing conventional Weight Sensitivity Analysis (WSA) applied to TOPSIS.
- `FRWSA_TOPSIS.m` – function implementing the proposed Full Range Weight Sensitivity Analysis (FRWSA) method for TOPSIS.
- `main_TOPSIS_WWTPs.m` – main script that runs TOPSIS, WSA, and FRWSA for the WWTP example presented in the paper.

### VIKOR-based files

In the paper, the proposed FRWSA method is also applied to another MCDM method, namely **VIKOR**. The following files are the VIKOR counterparts of the TOPSIS-based implementation:

- `main_VIKOR_WWTPs.m` – main script that runs VIKOR, WSA, and FRWSA for the WWTP example presented in the paper.
- `fun_VIKOR.m` – function implementing the VIKOR method.
- `WSA_VIKOR.m` – function implementing conventional Weight Sensitivity Analysis (WSA) applied to VIKOR.
- `FRWSA_VIKOR.m` – function implementing the proposed Full Range Weight Sensitivity Analysis (FRWSA) method for VIKOR.

### Monte Carlo comparison files

Monte Carlo (MC) approaches were also tested to compare how FRWSA-type graphical results look under random sampling strategies. Two alternatives were explored: normal-distribution-based sampling and Dirichlet-distribution-based sampling.

- `main_MC_WWTPs.m` – main script that runs the Monte Carlo approach and generates FRWSA-type plots for the WWTP example presented in the paper.
- `MC.m` – function implementing the Monte Carlo method and generating FRWSA-type graphical outputs.
- `main_dirichlet_MC_WWTPs.m` – main script that runs the Monte Carlo approach using a Dirichlet distribution and generates FRWSA-type plots for the WWTP example presented in the paper.
- `dirichlet_MC.m` – function implementing the Dirichlet-based Monte Carlo method and generating FRWSA-type graphical outputs.

## Notes

The PDF slides included in this repository provide a detailed explanation of the methodology, the structure of the code, and the illustrative car-selection example.

Users are encouraged to review the slides before running the scripts, especially if they are not familiar with the proposed FRWSA framework.
