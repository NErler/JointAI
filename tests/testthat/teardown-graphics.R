# Close the null device opened in setup-graphics.R. testthat runs teardown*.R
# files automatically after all tests.
if (test_graphics_device %in% grDevices::dev.list()) {
  grDevices::dev.off(test_graphics_device)
}
