### cwt test

test_that("Whether cwt works (no summed_wavelet)", {
  
  time_series <- sin(seq(0, 20 * pi, length.out = 100))
  
  #Example using a numeric vector
  transformation <- cwt(t = time_series,
                        scales = c(1, 2, 3, 4, 5),
                        summed_wavelet = FALSE)
  
  dim_results <- dim(transformation)
  
  expect_equal("array", class(transformation), info = "Class")
  expect_equal(c(1, 100, 5), dim_results, info = "Dim results")
  
})

test_that("Whether cwt works (summed_wavelet)", {
  
  time_series <- sin(seq(0, 20 * pi, length.out = 100))
  
  #Example using a numeric vector
  transformation <- cwt(t = time_series,
                        scales = c(1, 2, 3, 4, 5),
                        summed_wavelet = TRUE)
  
  expect_equal("numeric", class(transformation), info = "Class")
  expect_equal(100, length(transformation), info = "Length")
  
})

