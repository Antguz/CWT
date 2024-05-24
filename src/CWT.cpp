#ifdef _OPENMP
#include <omp.h>
#endif
// [[Rcpp::plugins(openmp)]]
// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>

using namespace arma;

// Mexican Hat wavelet function
arma::rowvec gaussian2(arma::rowvec t, int scale, double variance) {

  int n = t.n_elem;
  arma::rowvec wavelet(n);
  double norm_factor = 2 / (sqrt(3 * variance) * pow(M_PI, 0.25));

  for(int i = 0; i < n; i++) {
    double t_scaled = t[i] / scale;
    wavelet[i] = norm_factor * (1 - pow((t_scaled / variance), 2.0)) * exp(-pow(t_scaled, 2.0) / (2 * pow(variance, 2.0)));
  }

  return wavelet;
}

// Timepoints function
arma::rowvec timepointsArma(int x) {

  arma::rowvec time_points(x);

  for(int i = 0; i < x; i++) {
    time_points[i] = i - x / 2;
  }

  return time_points;

}

// Normalize time series
// Function to normalize a wavelet
arma::rowvec normalizeArma(arma::rowvec wavelet) {
  double sum_of_squares = arma::sum(arma::square(wavelet));
  double norm_factor = std::sqrt(sum_of_squares);
  return wavelet / norm_factor;
}

// Convolve
// This convolve function is from https://github.com/eddelbuettel/rcpp_comparison_convolution
// Thanks Dirk Eddelbuettel! (Credits to him)
arma::rowvec convolveArma(const arma::rowvec & xa, const arma::rowvec & xb) {

  int n_xa = xa.n_elem;
  int n_xb = xb.n_elem;

  arma::rowvec xab(n_xa + n_xb - 1, arma::fill::zeros);

  for (int i = 0; i < n_xa; i++) {
    xab.subvec(i, i + n_xb - 1) += xa[i] * xb;
  }

  return xab;
}

// Wavelet function
// [[Rcpp::export]]
arma::cube cwt_rcpp(arma::mat t,
                    arma::vec scales,
                    double variance = 1L,
                    int threads = 1L) {

  // Define size of object to export
  int nrows = t.n_rows;
  int ncols = t.n_cols;
  int nscales = scales.n_elem;

  arma::cube array(nrows, ncols, nscales);

  // Normalize time points for the wavelet function
  arma::rowvec time_points = timepointsArma(ncols);
  int start = ceil(ncols/2);
  int end = start + ncols;

  //Set threads
#ifdef _OPENMP
  if ( threads > 1 ) {
    omp_set_num_threads( threads );
    REprintf("Number of threads=%i\n", omp_get_max_threads());
  }
#endif

  // Perform for loops

  for (int i = 0; i < nscales; i++) { // loop by scale

    int scale = scales[i];
    arma::rowvec wavelet = gaussian2(time_points, scale, variance);

#pragma omp parallel
    for (int j = 0; j < nrows; j++) { // loop by row

      arma::rowvec time_series = t.row(j);
      arma::rowvec apply = convolveArma(time_series, wavelet);

      for (int k = 0; k < ncols; k++) { // loop by cols

        array(j,k,i) = apply[(start + k)];

      }
    }
  }

  return array;

}
