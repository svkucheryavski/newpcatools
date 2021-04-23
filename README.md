# New tools for PCA-exploration of high dimensional datasets

This repository contains datasets (as Excel file, `Data.xlsx`) as well as an R script which reproduces all examples from chapter 2 of paper
Rodionova O., Kucheryavskiy S., Pomerantsev A., [Efficient tools for principal component analysis of complex data — a tutorial](
https://doi.org/10.1016/j.chemolab.2021.104304). Chemometrics and Intelligent Laboratory Systems, 213, 2021. The paper has open access and available publicly without fee.

In order to run the script make sure that:

1. You have packages `mdatools` and `readxl` installed.
2. You have all three files (`Data.xlsx`, `pcv.R` and `script.R`) in the same folder.
3. You have set this folder as working directory.

Additional information about `mdatools` package is available [here](https://mdatools.com). Information about Procrustes cross-validation, used in one of the examples and implemented in `pcv.R` is available in [this repository](https://github.com/svkucheryavski/pcv) and in [this paper](https://doi.org/10.1021/acs.analchem.0c02175).

If you have any questions, fee free to write to [svkucheryavski@gmail.com](mailto:svkucheryavski@gmail.com) or just [create an issue](https://github.com/svkucheryavski/newpcatools/issues) in this repo.
