# Plots made in the tests go to a null device. In the console of an IDE they
# would otherwise be sent to the plot pane, which can stall the test run
# (several test files draw hundreds of plots).
# testthat runs setup*.R files automatically before the tests (not with
# devtools::load_all()) and teardown*.R files after all tests; the device is
# closed again in teardown-graphics.R. (A single setup file with
# withr::defer(..., teardown_env()) would need withr as a declared dependency.)
grDevices::pdf(NULL)
test_graphics_device <- grDevices::dev.cur()
