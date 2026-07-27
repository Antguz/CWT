# CWT 0.2.3 (2026-07-27)

* Fix: `cwt()` incorrectly flattened `matrix`/`data.table` input into a single
  row because `is.numeric()` also returns `TRUE` for numeric matrices, causing
  the result to be returned as a plain vector instead of a `data.table`.
* Fix: `cwt()` with `summed_wavelet = TRUE` collapsed the result to a plain
  vector whenever the input had a single row or a single scale, even when the
  input was a genuine `matrix`/`data.table`, due to `apply()` silently
  dropping dimensions.
* Fix: `cwt()` accepted `scales = 0` and `variance = 0`, which silently
  produced `Inf`/`NaN` values instead of raising the documented error.
* Fix: `resampling_FWHM()` silently returned `0` for new bands whose FWHM
  window fell outside the range of `wavelengths`, indistinguishable from a
  real zero reading. These bands are now returned as `NA`.

# CWT 0.2. (2024-06-26)

* Fix: Magnitude of response by variance in cwt.
* Add a function for fast resampling using FWHM.

# CWT 0.1.1 (2024-05-28)

* First submission to CRAN