# Information ----

## This script reproduces all examples from Chapter 2 of the paper
## "Efficient PCA-exploration of high-dimensional datasets — A tutorial"
## by Oxana Rodionova, Sergey Kucheryavskiy, Alexey Pomerantsev
## URL:

## In order to run the script make sure that:
## 1. You have Data.xlsx file in the same folder
## 2. You have set this folder as working directory


# Helper functions ----

## Load necessary packages and source files
library(readxl)
library(mdatools)
source("pcv.R")

## This function loads data from Excel file based on the noise level
## specified by user. It returns a list with two matrices - calibration and test sets
getData <- function(noise.level = 0, filename = "Data.xlsx") {

   ## make sheet name as a text
   sheet.name <- sprintf("%.3f", noise.level)

   ## get all data from the sheet
   data <- read_excel(filename, sheet.name)

   ## get wavenumbers by taking column names and converting them to numeric values
   wavenumbers <- as.numeric(colnames(data)[3:ncol(data)])

   ## split the data to separate sets using column "Set"
   sets <- split(data, as.factor(data$Set))

   ## for each set, extract spectral values, make it a matrix, assign names and attributes
   sets <- lapply(sets, function(x) {
      names <- x$Name

      spectra <- as.matrix(x[, 3:ncol(x)])
      rownames(spectra) <- names
      colnames(spectra) <- wavenumbers
      attr(spectra, "xaxis.name") <- expression("Wavenumber, cm"^-1)
      attr(spectra, "xaxis.values") <- wavenumbers
      spectra
   })

   ## return the spectra for each set as a list
   return(sets)
}


# Figure 1 ----

## load data with noise level 0
s <- getData(0)

## make PCA model using calibration set
m <- pca(s$Cal, 6, center = TRUE)

## apply PCA model to the test set
r <- predict(m, s$Test)

## show the plots
par(mfrow = c(1, 2))

## scores plot for model (calibration set)
p <- plotScores(m, res = list(cal = m$res$cal, test = r), comp = c(1, 2),
   pch = c(16, 1), xlim = c(-2, 2), ylim = c(-2, 2))
plotHotellingEllipse(p[[1]])

## add points for the test set
mdaplot(r$scores, pch = 1, col = "red", show.axes = FALSE)

## distance plot only for calibration set to be able to show the categories
plotResiduals(m, ncomp = 2, cgroup = "categories")

## and add points for test set separately
plotResiduals(r, ncomp = 2, norm = TRUE, show.axes = FALSE, pch = 1, col = "red")


# Figure 2 ----

## add outliers to calibration set and create two PCA models - with robust and classic limits

## load data with noise level 0.005
s <- getData(0.005)

## combine calibration set and rows with outliers
X <- mda.rbind(s$Cal, s$Outlier)

## create two PCA models - with classic and robust limits 
m1 <- pca(X, 6, lim.type = "ddmoments")
m2 <- pca(X, 6, lim.type = "ddrobust")

## show the four plots as in the Figure 2
par(mfrow = c(2, 2))
plotResiduals(m1, ncomp = 4, cgroup = "categories", main = "Classic")
plotResiduals(m2, ncomp = 4, cgroup = "categories", main = "Robust")
plotResiduals(m1, ncomp = 4, cgroup = "categories", main = "Classic", log = TRUE)
plotResiduals(m2, ncomp = 4, cgroup = "categories", main = "Robust", log = TRUE)


# Figure 3 ----

## make PCA model for each dataset, save Nq and TRV values
A <- 6
noise <- c(0, 0.005, 0.010, 0.025, 0.050)
TRV <- matrix(0, length(noise), A)
Nq <- matrix(0, length(noise), A)

for (i in seq_along(noise)) {
   s <- getData(noise[i])
   m <- pca(mda.rbind(s$Cal, s$Test), A)
   TRV[i, ] <- 100 - m$res$cal$cumexpvar
   Nq[i, ] <- m$Qlim[4, ]
}

## assign row names for better legend
rownames(TRV) <- rownames(Nq) <- sprintf("%.3f", noise)

## show the values
par(mfrow = c(1, 2))
mdaplotg(Nq, type = "b", legend.position = "topleft")
mdaplotg(TRV, type = "b")


# Figure 4 ----

## load data with noise level 0.005
s <- getData(0.005)

## we need to make 4 PCA models - 2 for clean data
m11 <- pca(s$Cal, 7, lim.type = "ddmoments")
m12 <- pca(mda.rbind(s$Cal, s$Outlier), 7, lim.type = "ddmoments")

## to change the limits we actually do not need to create new PCA models
m21 <- setDistanceLimits(m11, lim.type = "ddrobust")
m22 <- setDistanceLimits(m12, lim.type = "ddrobust")

## we just use models we crated for Figure 2
Nq.clean <- rbind(m11$Qlim[4, ], m21$Qlim[4, ])
Nq.outliers <- rbind(m12$Qlim[4, ], m22$Qlim[4, ])
rownames(Nq.clean) <- rownames(Nq.outliers) <- c("classic", "robust")

par(mfrow = c(1, 2))
mdaplotg(Nq.clean, type = "b", main = "DoF: clean spectra")
mdaplotg(Nq.outliers, type = "b", ylim = c(0, 30), main = "DoF: with outliers")

# Figure 5 ----

## load data with noise level 0.005
s <- getData(0.005)

## make a PCA model using calibration set
m <- pca(s$Cal, 6)

## apply the model to test set
r <- predict(m, s$Test)

## show the plots
par(mfrow = c(2, 2))
plotExtreme(m, comp = 4, res = m$res$cal)
plotExtreme(m, comp = 4, res = r)
plotExtreme(m, comp = 5, res = m$res$cal)
plotExtreme(m, comp = 5, res = r)

# Figure 6 ----

## generate pseudo-validation set 
pcv <- pcv(s$Cal, 6, nseg = 4)

## apply model to the pseudo-validation set
rpcv <- predict(m, pcv)

## show the plots
par(mfrow = c(1, 2))
plotExtreme(m, comp = 4, res = rpcv, main = "Pseudo-validation set")
plotExtreme(m, comp = 5, res = rpcv, main = "Pseudo-validation set")

