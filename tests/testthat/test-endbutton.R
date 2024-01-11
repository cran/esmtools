# Test case 1: Default behavior in Rmd
test_that("Default behavior in Rmd", {
  # Set the knitr.in.progress option to simulate being in an R Markdown document
  options(knitr.in.progress = TRUE)
  result <- endbutton()
  expected <- "<p>\n</div>\n</div>\n</p>\n"
  expect_equal(result, expected)
  # Reset the knitr.in.progress option
  options(knitr.in.progress = NULL)
})

# Test case 2: Default behavior outside Rmd
test_that("Default behavior outside Rmd", {
  result <- endbutton()
  expected <- "\n:::\n\n"
  expect_equal(result, expected)
})
