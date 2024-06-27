#' Continuous Wavelet Transformation for Spectroscopy
#'
#' Fast application of Continuous Wavelet Transformation on time
#' series with special attention to spectroscopy. It is written using 
#' 'data.table' and 'C++' language and in some functions it is possible to 
#' use parallel processing to speed-up the computation over samples.

#' @import data.table
"_PACKAGE"

## usethis namespace: start
#' @importFrom Rcpp sourceCpp
#' @useDynLib CWT
## usethis namespace: end
NULL
