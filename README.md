[![](https://www.r-pkg.org/badges/version/CWT)](https://cran.r-project.org/package=CWT)
[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/license)
[![](http://cranlogs.r-pkg.org/badges/grand-total/CWT)](https://cran.r-project.org/package=CWT)


##  Continuous Wavelet Transformation for Spectroscopy

This is an R package is focused on the fast application of 1D - Continuous Wavelet 
Transformation (CWT) on time series with special attention to signals from 
spectroscopy. The current code has been enhanced using C++ language through `Rcpp` 
and `RcppArmadillo` packages, and run in parallel over samples using `OpenMP`. 
It was develop by [J. Antonio Guzman Q.](https://www.jaguzmanq.com/) (<antguz06@gmail.com>) 
at the University of Minnesota.

<br />
<br />

### Installation

You can install the `CWT` using the CRAN platform following

```
# Pending
install.packages("CWT")
```

or using the development version in github following (recommended)

```
remotes::install_github("Antguz/CWT")
```

if you have problems also try 

```
devtools::install_github("Antguz/CWT", INSTALL_opts= c("--no-multiarch"))
```

<br />
<br />

### Citation

If you use this package in your research, please cite [Zenodo
record](https://doi.org/10.5281/zenodo.4465150):

```
@software{makecite,
  author       = {Guzmán, J.A.},
  title        = {Continuous Wavelet Transformation for Spectroscopy},
  month        = May,
  year         = 2024,
  publisher    = {Zenodo},
  version      = {v0.1.0},
  doi          = {10.5281/zenodo.4465 150},
  url          = {https://doi.org/10.5281/zenodo.4465150}
}
```
