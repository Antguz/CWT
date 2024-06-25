#ifdef _OPENMP
#include <omp.h>
#endif
// [[Rcpp::plugins(openmp)]]
// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>

using namespace arma;

arma::mat resampling_FWHM(arma::mat X, 
                          arma::vec wav, 
                          arma::vec new_wav,
                          arma::vec fwhm,
                          int threads) {
  int nX = X.n_rows;
  int np = new_wav.n_elem;
  arma::mat resampled(nX, np, arma::fill::zeros);
  
  //Set threads
#ifdef _OPENMP
  if(threads > 1) {
    omp_set_num_threads(threads);
  }   
#endif
  
#pragma omp parallel
  for (int j = 0; j < np; j++) {
    
    double sdx = fwhm[j] / (2 * sqrt(2 * log(2.0)));
    
    if(new_wav[j] - (3 * sdx) >= wav.min() && new_wav[j] + (3 * sdx) <= wav.max()) { // Bad interpolation
      
      double sdx2 = 2 * std::pow(sdx, 2);
      arma::vec dn = exp(-arma::square(wav - new_wav[j]) / sdx2);  // Gaussian density
      double sumdn = arma::sum(dn);
      
      for (int i = 0; i < nX; i++) {
        resampled(i, j) = arma::dot(dn, X.row(i).t()) / sumdn;
      }
    }
  }
  
  return resampled;
  
} 