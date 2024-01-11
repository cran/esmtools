# Create a sample dataframe for testing
sample_data <- data.frame(
  Var1 = c(1, 2, 3, 3, NA),
  Var2 = c(10, 20, 30, 30, NA)
)

# Test case 1: Check if the function calculates summary statistics correctly
test_that("Calculate summary statistics for numeric variables", {
  result <- cat_desc_stats(sample_data)

  # Check if the result is a dataframe
  expect_type(result, "list")

  # Check if the dataframe contains the expected columns
  expect_true("Variable" %in% colnames(result))
  expect_true("Values" %in% colnames(result))
  expect_true("Freq" %in% colnames(result))

  # Check if the summary statistics are calculated correctly
  expect_true(sum(c("1 <br> 2 <br> 3", "10 <br> 20 <br> 30") == result$Values)==2)
  expect_true(sum(c("1 (20%) <br> 1 (20%) <br> 2 (40%)", "1 (20%) <br> 1 (20%) <br> 2 (40%)") == result$Freq)==2)
})

# Test case 2: Check if the function handles custom variable selection
test_that("Handle custom variable selection", {
  result <- cat_desc_stats(sample_data, select_vars = "Var1")

  # Check if the result is a dataframe
  expect_type(result, "list")

  # Check if the dataframe contains only one variable
  expect_equal(nrow(result), 1)

  # Check if the variable name matches the selected variable
  expect_equal(result$Variable, "Var1")
})

# Test case 3: Check if the function handles n_unique_thres argument
test_that("Handle n_unique_thres argument", {
  result <- cat_desc_stats(sample_data, n_unique_thres = 2)
  expect_null(result)
})

# Test case 4: Check if the function handles empty dataframe correctly
test_that("Handle empty dataframe", {
  empty_data <- data.frame()
  result <- cat_desc_stats(empty_data)
  expect_null(result)
})
