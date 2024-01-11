# Sample data for testing
test_data <- data.frame(matrix(rnorm(100), ncol = 4))  # A 5x4 matrix

# Test 1: Basic functionality with row numbers
test_that("Basic functionality with row numbers", {
  result <- controws(test_data, c(2, 5), 1, "both")
  expect_equal(nrow(result), 6)  # Should return 6 rows (3 for each target row)
  expect_equal(result$.RowType[2], "->")
})

# Test 2: Functionality with boolean vector
test_that("Functionality with boolean vector", {
  bool_vector <- rep(FALSE, nrow(test_data))
  bool_vector[c(2, 5)] <- TRUE
  result <- controws(test_data, bool_vector, 1, "both")
  expect_equal(nrow(result), 6)
  expect_equal(result$.RowType[2], "->")
})

# Test 3: Context limited to 'up' direction
test_that("Context limited to 'up' direction", {
  result <- controws(test_data, c(2), 1, "up")
  expect_equal(nrow(result), 2)  # Should return 2 rows
  expect_equal(result$.RowType[2], "")
})

# Test 4: Context limited to 'down' direction
test_that("Context limited to 'down' direction", {
  result <- controws(test_data, c(2), 1, "down")
  expect_equal(nrow(result), 2)  # Should return 2 rows
  expect_equal(result$.RowType[1], "")
})

# Test 5: Edge case - target row at the beginning of the data frame
test_that("Edge case - target row at beginning", {
  result <- controws(test_data, c(1), 1, "both")
  expect_equal(nrow(result), 2)  # Should return 2 rows
  expect_equal(result$.RowType[1], "->")
})

# Test 6: Edge case - target row at the end of the data frame
test_that("Edge case - target row at end", {
  result <- controws(test_data, nrow(test_data), 1, "both")
  expect_equal(nrow(result), 2)  # Should return 2 rows
  expect_equal(result$.RowType[2], "->")
})

# Test 7: Invalid input - negative context
test_that("Invalid input - negative context", {
  expect_error(controws(test_data, c(2), -1, "both"))
})

# Test 8: Invalid input - row number out of range
test_that("Invalid input - row number out of range", {
  expect_error(controws(test_data, c(1000), 1, "both"))
})
