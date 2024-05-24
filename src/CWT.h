#ifndef CWT_RCPP_H
#define CWT_RCPP_H

#include <RcppArmadillo.h>

arma::cube cwt_rcpp(arma::mat t, arma::vec scales, double variance = 1L, int threads = 1L);

#endif