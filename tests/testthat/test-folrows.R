# Create a sample data frame for testing
sample_data <- data.frame(
  ID = rep(c(1:20), each = 2),
  Name = c(
    "Alice", "Alice", "Charlie", "Charlie", "Eve", "Eve", "Grace", "Grace", "Ivy", "Ivy",
    "Karen", "Karen", "Mia", "Mia", "Olivia", "Olivia", "William", "William", "Michael", "Michael"
  )
)


# Test case 1: Default behavior with 5 rows, 1 sample
test_that("Default behavior with 5 rows, 1 sample", {
  result <- folrows(sample_data)
  expect_true(nrow(result) == 5)
})

# Test case 2: Custom number of rows (e.g., 3), 2 samples
test_that("Custom number of rows (e.g., 3), 2 samples", {
  result <- folrows(sample_data, n = 3, nb_sample = 2)
  expect_true(nrow(result) == 6) # 3 rows per sample x 2 samples
})

# Test case 3: Ensure selected rows are within the original data range
test_that("Ensure selected rows are within the original data range", {
  expect_error(folrows(sample_data, n = 100, nb_sample = 3))
})
