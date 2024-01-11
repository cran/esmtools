# Create a sample data frame for testing
sample_data <- data.frame(
  ID = 1:10,
  Name = c("Alice", "Bob", "Charlie", "David", "Eve", "Frank", "Grace", "Hannah", "Ivy", "Jack")
)

# Test case 1: Custom number of rows (e.g., 3)
test_that("Custom number of rows (e.g., 3)", {
  result <- randrows(sample_data, n = 3)
  expect_true(nrow(result) == 3)
})

# Test case 2: Ensure n is not bigger than the actual number of rows
test_that("Ensure n is not bigger than the actual number of rows", {
  expect_error(randrows(sample_data, n = 11))
})
