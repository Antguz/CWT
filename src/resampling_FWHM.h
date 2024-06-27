#ifndef FWHM_RCPP_H
#define FWHM_RCPP_H

#include <RcppArmadillo.h>

arma::mat resampling_FWHM_rcpp(arma::mat spectra, arma::vec wav, arma::vec new_wav, arma::vec fwhm, int threads = 1);

#endif