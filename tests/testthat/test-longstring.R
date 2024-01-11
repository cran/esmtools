# Test case 1: vector
test_that("Test with no tolerance", {
  x <- c(1, 1, 2, 2, 2, 3, 3, 3, 3)

  result <- longstring(x)

  expect_type(result, "list")
  expect_equal(result[1, 1], "3")
  expect_equal(result[1, 2], "4")
  expect_equal(result[1, 3], "3")
})


# Test case 2: Test with no tolerance
test_that("Test with no tolerance", {
  df <- data.frame(
    rbind(
      c(1, 1, 2, 2, 2, 3, 3, 3, 3),
      c(1, 2, 3, 4, 4, 4, 4, 5, 6)
    )
  )

  result <- longstring(df)

  expect_type(result, "list")
  expect_equal(result[1, 1], "3")
  expect_equal(result[1, 2], "4")
  expect_equal(result[1, 3], "3")
  expect_equal(result[2, 1], "4")
  expect_equal(result[2, 2], "4")
  expect_equal(result[2, 3], "1.5")
})

# Test case 3: Test with tolerance
test_that("Test with tolerance", {
  df <- data.frame(
    rbind(
      c(1, 1, 2, 2, 2, 3, 3, 3, 3),
      c(1, 2, 3, 4, 4, 4, 4, 5, 6)
    )
  )

  result <- longstring(df, tolerance = 1)

  expect_type(result, "list")
  expect_equal(result[1, 1], "2")
  expect_equal(result[1, 2], "7")
  expect_equal(result[1, 3], "4.11")
  expect_equal(result[2, 1], "3_4")
  expect_equal(result[2, 2], "5")
  expect_equal(result[2, 3], "2.89")
})
