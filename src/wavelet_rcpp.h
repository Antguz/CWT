#ifndef CWT_H
#define CWT_H

#include <RcppArmadillo.h>

arma::cube CWT(arma::mat t, arma::vec scales, double variance, int threads);

#endif
