#ifdef _OPENMP
#include <omp.h>
#endif
// [[Rcpp::plugins(openmp)]]
// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>

using namespace arma;

// Some section of code was inspired by the package prospectr: Antoine Stevens 
// and Leornardo Ramirez-Lopez (2024). An introduction to the prospectr package. 
// R package Vignette R package version 0.2.7.

// Resampling using full width half maximum
// [[Rcpp::export]]
arma::mat resampling_FWHM(arma::mat spectra, 
                          arma::vec wav, 
                          arma::vec new_wav,
                          arma::vec fwhm,
                          int threads = 1) {
  
  int samples = spectra.n_rows;
  int nbands = new_wav.size();
  arma::mat resampled(samples, nbands);
  
  //Set threads
#ifdef _OPENMP
  if(threads >= 1) {
    omp_set_num_threads(threads);
  }    
#endif
  
  for(int j = 0; j < nbands; j++) {
    
    double sdx = fwhm[j] / (2 * sqrt(2 * log(2.0)));
    
    if(new_wav[j] - (3 * sdx) >= wav.min() && new_wav[j] + (3 * sdx) <= wav.max()) {
      
      double sdx2 = 2 * std::pow(sdx, 2);
      arma::vec dn = exp(-pow(wav - new_wav[j], 2) / sdx2);
      double sumdn = sum(dn);
      
#pragma omp parallel for 
      for(int i = 0; i < samples; i++) {
        resampled(i, j) = sum(dn % spectra.row(i).t()) / sumdn;
      }
    }
  } 
  
  return resampled;
  
}