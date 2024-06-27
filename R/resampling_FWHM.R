#' @title Full Width Half Maximum Resampling
#'
#' @description It resample spectra data using Full Width Half Maximum (FWHM).
#'
#' @param spectra A \code{data.table}, \code{data.frame}, or \code{matrix} where
#'  columns represent bands and rows samples (i.e., pixels).
#' @param wavelengths A \code{numeric} vector describing the current positioning 
#' of the spectral bands within \code{spectra}.
#' @param new_wavelengths A \code{numeric} vector describing positioning of the 
#' new spectral bands to resample.
#' @param FWHM A \code{numeric} vector describing the Full Width Half Maximums of
#' the new spectral bands. The length of this vector should be equal than the length
#' of \code{new_wavelengths}.
#' @param threads An \code{integer} specifying the number of threads to use.
#' Experiment to see what works best for your data on your hardware.
#'
#' @return It returns a \code{data.table} with the resampled spectra, where columns
#' are the new bands and rows are samples.
#'
#' @author J. Antonio Guzmán Q.
#' 
#' @importFrom data.table as.data.table
#' @importFrom data.table data.table
#'
#' @examples
#'
#' mean <- 50
#' sd1 <- 5
#' sd2 <- 10
#' n <- 100
#' 
#' test <- matrix(c(dnorm(1:n, mean = mean, sd = sd1),
#'                dnorm(1:n, mean = mean, sd = sd2)),
#'                nrow = 2,
#'                byrow = TRUE)
#' 
#' current_bands <- 1:n
#' new_bands <- seq(10, 90, by = 5)
#' FHWM <- rep(5, length(new_bands))
#' 
#' resampling_FWHM(spectra = test,
#'                 wavelengths = current_bands,
#'                 new_wavelengths = new_bands,
#'                 FWHM = FHWM)
#'
#' @export
resampling_FWHM <- function(spectra,
                            wavelengths,
                            new_wavelengths,
                            FWHM,
                            threads = 1L) {
  
  # Check input argument types and lengths
  if(ncol(spectra) != length(wavelengths)) {
    stop("There is not correspondence between wavelengths and columns in spectra")
  }
  
  if(length(new_wavelengths) != length(FWHM)) {
    stop("There is not correspondence between new_wavelengths and FWHM")
  }
  
  if(min(threads) < 1) {
    stop("threads must be a positive interger higher than 1")
  }
  
  # Apply resampling
  resampled <- resampling_FWHM_rcpp(as.matrix(spectra), 
                                    wavelengths, 
                                    new_wavelengths,
                                    FWHM,
                                    threads)
  
  resampled <- as.data.table(resampled)
  colnames(resampled) <- as.character(new_wavelengths)
  
  return(resampled)
  
}
