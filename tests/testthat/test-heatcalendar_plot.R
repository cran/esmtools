# Define a sample dataframe for testing
sample_data <- data.frame(
  date_col = as.Date(c("2023-01-01", "2023-01-02", "2023-01-04", "2023-01-05", "2023-01-06")),
  value_col = c(10, 15, 5, 8, 12)
)

# Test case 1: Check if the function runs without errors with valid input
test_that("Function runs without errors with valid input", {
  expect_no_error(heatcalendar_plot(sample_data, "date_col"))
})

# Test case 2: Check if the function throws an error for non-date column
test_that("Function throws an error for non-date column", {
  non_date_data <- data.frame(
    non_date_col = c("2023-01-01", "2023-01-02", "2023-01-04", "2023-01-05", "2023-01-06"),
    value_col = c(10, 15, 5, 8, 12)
  )
  expect_error(heatcalendar_plot(non_date_data, "non_date_col"), "Column 'non_date_col' must be a date format.")
})

# Test case 3: Check if the function throws an error for missing timevar argument
test_that("Function throws an error for missing timevar argument", {
  expect_error(heatcalendar_plot(sample_data), "timevar must be specified.")
})

# # Test case 3: Check plot output similar
# save_png <- function(code, width = 400, height = 400) {
#   path <- tempfile(fileext = ".png")
#   png(path, width = width, height = height)
#   print(code)
#   on.exit(dev.off())

#   path
# }

# test_that("Snapshot test for generated plot", {
#   announce_snapshot_file(name = "plot.png")
#   expect_snapshot_file(save_png(heatcalendar_plot(sample_data, "date_col")), "plot.png")
# })
