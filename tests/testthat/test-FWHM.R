### cwt test

test_that("Whether FWHM works", {
  
  mean <- 50
  sd1 <- 5
  sd2 <- 10
  n <- 100
   
  test <- matrix(c(dnorm(1:n, mean = mean, sd = sd1),
                   dnorm(1:n, mean = mean, sd = sd2)),
                 nrow = 2,
                 byrow = TRUE)
  current_bands <- 1:n
  new_bands <- seq(5, 100, by = 5)
  FHWM <- rep(5, length(new_bands))
  
  resampled <- resampling_FWHM(spectra = test,
                               wavelengths = current_bands,
                               new_wavelengths = new_bands,
                               FWHM = FHWM)
  
  dim_results <- dim(resampled)
  
  expect_equal("data.table", class(resampled)[1], info = "Class")
  expect_equal(c(2, length(new_bands)), dim_results, info = "Dim results")
  
})