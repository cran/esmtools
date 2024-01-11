# Create a sample dataframe for testing
sample_data <- data.frame(
  Var1 = c(1, 2, 3, 4, NA, 6, 7, 8, 9),
  Var2 = c(10, 20, 30, 40, NA, 60, 70, 80, 90)
)

# Test case 1: Check if the function calculates summary statistics correctly
test_that("Calculate summary statistics for numeric variables", {
  result <- cont_desc_stats(sample_data)

  # Check if the result is a dataframe
  expect_type(result, "list")

  # Check if the dataframe contains the expected columns
  expect_true("Variable" %in% colnames(result))

  # Check if all stats names are here
  all_stats <- c("n_uni", "min", "max", "q25", "median", "max", "mean", "sd")
  expect_true(all(sapply(all_stats, function(x) grepl(x, result$stats))))

  # Check if the summary statistics are calculated correctly
  expect_true(sum(c("n_uni = 9.00 <br> min =  1.00 <br> q25 =  2.75 <br> median =  5.00 <br> q75 =  7.25 <br> max =  9.00 <br> mean =  5.00 <br> sd =  2.93", 
                    "n_uni = 9.00 <br> min = 10.00 <br> q25 = 27.50 <br> median = 50.00 <br> q75 = 72.50 <br> max = 90.00 <br> mean = 50.00 <br> sd = 29.28") 
                  == result$stats)==2)
  expect_true(sum(c("Var1", "Var2") == result$Variable)==2)
})

# Test case 2: Check if the function handles custom variable selection
test_that("Handle custom variable selection", {
  result <- cont_desc_stats(sample_data, select_vars = "Var1")

  # Check if the result is a dataframe
  expect_type(result, "list")

  # Check if the dataframe contains only one variable
  expect_equal(nrow(result), 1)

  # Check if the variable name matches the selected variable
  expect_equal(result$Variable, "Var1")
})

# Test case 3: Check if the function handles n_unique_thres argument
test_that("Handle n_unique_thres argument", {
  result <- cont_desc_stats(sample_data, n_unique_thres = 10)
  expect_null(result)
})

# Test case 4: Check if the function handles empty dataframe correctly
test_that("Handle empty dataframe", {
  empty_data <- data.frame()
  result <- cont_desc_stats(empty_data)
  expect_null(result)
})

