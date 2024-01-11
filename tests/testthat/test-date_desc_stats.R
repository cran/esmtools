# Sample data frame with date variables
df <- data.frame(
  Date1 = seq(as.POSIXct("2023-09-05 12:00:00"), by = "days", length.out = 10),
  Date2 = seq(as.POSIXct("2023-01-05 12:00:00"), by = "days", length.out = 10),
  Date3 = seq(as.POSIXct("2023-01-10 12:00:00"), by = "days", length.out = 10),
  id = rep(1:5, each = 2)
)
# Test the function with default arguments
result <- date_desc_stats(df)

test_that("return dataframe/list", {
  # Check if the result is a data frame
  expect_type(result, "list")
})

test_that("return as many ", {
  # Check if the result has the correct number of rows (should be 3, one for each date variable)
  expect_equal(nrow(result), 3)
})

test_that("Return right name for variables", {
  # Check if the "Variable" column contains the correct variable names
  expect_equal(result$Variable, c("Date1", "Date2", "Date3"))
})

test_that("Output ok", {
  # Check if the "Date_stats" column contains the expected date statistics
  expect_equal(result$Date_stats[1], "min=2023-09-05 12:00:00 <br> max=2023-09-14 12:00:00")
  expect_equal(result$Date_stats[2], "min=2023-01-05 12:00:00 <br> max=2023-01-14 12:00:00")
  expect_equal(result$Date_stats[3], "min=2023-01-10 12:00:00 <br> max=2023-01-19 12:00:00")
})
