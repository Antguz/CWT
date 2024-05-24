#' @title Continuous Wavelet Transform
#'
#' @description Compute a 1D continuous wavelet transformation using 2st order
#' derivative Gaussian wavelet.
#'
#' @param t A \code{data.table}, \code{matrix}, or \code{numeric} vector where
#'  columns or values represent time (i.e., bands) and rows samples (i.e., pixels).
#' @param scales A positive \code{numeric} vector describing the scales to
#' compute. The minimum scale (i.e., scales = 1) is equal to sampling interval
#' between columns.
#' @param variance A positive \code{numerber} describing the variance of the
#' Gaussian PDF used to scale. Default \code{variance = 1}.
#' @param summed_wavelet If \code{TRUE}, it returns the sum of scales.
#' If \code{FALSE}, each scale is returned.
#' @param threads An \code{integer} specifying the number of threads to use.
#' Experiment to see what works best for your data on your hardware.
#'
#' @return If \code{summed_wavelet = TRUE}, it returns a \code{data.table} where
#' columns are the sum of wavelet scales. If \code{summed_wavelet = FALSE}, it
#' returns an \code{array} (i.e., time, samples, and scales).
#'
#' @author J. Antonio Guzmán Q.
#'
#' @examples
#'
#' time_series <- sin(seq(0, 20 * pi, length.out = 100))
#'
#' # Example using a numeric vector
#'
#' CWT(t = time_series,
#'     scales = c(1, 2, 3, 4, 5),
#'     summed_wavelet = FALSE)
#'
#' CWT(t = time_series,
#'     scales = c(1, 2, 3, 4, 5),
#'     summed_wavelet = TRUE)
#'
#' Example using a data.table
#'
#' times <- 100
#' frame <- matrix(rep(time_series, times),
#'                 nrow = times,
#'                 byrow = TRUE)
#'
#' CWT(t = frame,
#'     scales = c(1, 2, 3, 4, 5),
#'     summed_wavelet = FALSE)
#'
#' CWT(t = frame,
#'     scales = c(1, 2, 3, 4, 5),
#'     summed_wavelet = TRUE)
#'
#' @export
cwt <- function(t,
                scales,
                variance = 1,
                summed_wavelet = FALSE,
                threads = 1L) {

  # Check input argument types and lengths
  if(class(t) == "numeric") {
    frame <- matrix(t, nrow = 1, byrow = TRUE)
    colnames(frame) <- names(t)
  } else {
    frame <- as.matrix(t)
  }

  if(min(scales) < 0) {
    stop("scales must be positive numbers")
  }

  if(min(variance) < 0) {
    stop("variance must be a positive number")
  }

  if(min(threads) < 1) {
    stop("threads must be a positive interger higher than 1")
  }

  # Apply CWT_rcpp
  transformation <- CWT(t = frame,
                        scales = scales,
                        variance = variance,
                        threads = threads)

  # Apply summed wavelet
  if(summed_wavelet == TRUE) {
    transformation <- rowSums(transformation, dims = 3)
    transformation <- as.data.table(transformation)
    colnames(transformation) <- colnames(t)
  }

  return(transformation)

}
