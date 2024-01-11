sample_df <- data.frame(
  Group = c("A", "B", "A", "B", "A", "C"),
  Var1 = c(1, 2, 1, 3, 4, 2),
  Var2 = c("X", "Y", "X", "Z", "X", "Y"),
  stringsAsFactors = FALSE
)

test_that("Function returns ok", {
  result <- vars_consist(sample_df, "Group", c("Var1", "Var2"))

  # Test case 1: Check if the function correctly returns a list/dataframe
  expect_type(result, "list")

  # Test case 2: Check if the function correctly computes unique values within groups
  expect_equal(result$Group, c("A", "B", "C"))
  expect_equal(result$Var1, c("(1, 4)", "(2, 3)", "2"))
  expect_equal(result$Var2, c("X", "(Y, Z)", "Y"))
})

# Test case 3: Check if the function handles multiple group variables correctly
test_that("Function handles multiple group variables", {
  expect_error(
    vars_consist(sample_df, c("Group", "Var1"), c("Var1", "Var2")),
    "Only one group variable should be used."
  )
})

# Test case 4: Check if the function correctly handles NA values
test_that("Function handle NA in output ", {
  sample_df$Group[2] <- NA
  result <- vars_consist(sample_df, "Group", c("Var1", "Var2"))
  expect_equal(result$Group, c("A", "NA", "B", "C"))
  expect_equal(result$Var1, c("(1, 4)", "2", "3", "2"))
  expect_equal(result$Var2, c("X", "Y", "Z", "Y"))
})
