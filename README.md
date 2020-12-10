# New tools for PCA-exploration of high dimensional datasets

This repository contains datasets (as Excel file, `Data.xlsx`) as well as an R script which reproduces all examples from chapter 2 of paper "Efficient PCA-exploration of high-dimensional datasets — A tutorial" by Oxana Rodionova, Sergey Kucheryavskiy, Alexey Pomerantsev. The pre-print of the paper is [available](https://chemrxiv.org/articles/preprint/Efficient_PCA-Exploration_of_High-Dimensional_Datasets/13340711) in ChemRxiv. Link to official published version will be added later.

In order to run the script make sure that:

1. You have packages `mdatools` and `readxl` installed.
2. You have all three files (`Data.xlsx`, `pcv.R` and `script.R`) in the same folder.
3. You have set this folder as working directory.

Additional information about `mdatools` package is available [here](https://mdatools.com). Information about Procrustes cross-validation, used in one of the examples and implemented in `pcv.R` is available in [this repository](https://github.com/svkucheryavski/pcv) and in [this paper](https://doi.org/10.1021/acs.analchem.0c02175).

If you have any questions, fee free to write to [svkucheryavski@gmail.com](mailto:svkucheryavski@gmail.com) or just [create an issue](https://github.com/svkucheryavski/newpcatools/issues) in this repo.
