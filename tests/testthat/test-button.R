# Test case 1: Default behavior in Rmd
test_that("Default behavior in Rmd", {
  # Set the knitr.in.progress option to simulate being in an R Markdown document
  options(knitr.in.progress = TRUE)
  result <- button()
  expected <- "\n<div class='esmtools-container'>\n<button class='esmtools-btn' onclick='esmtools_toggleContent(this)'>Description</button>\n<p>\n<div style='display:none;'>\n"
  expect_equal(result, expected)
  # Reset the knitr.in.progress option
  options(knitr.in.progress = NULL)
})

# Test case 2: Default behavior outside Rmd
test_that("Default behavior outside Rmd", {
  result <- button()
  expected <- "\n::: {.callout-note collapse='true'}\n<p>## Description</p>\n\n"
  expect_equal(result, expected)
})

# Test case 3: Custom text
test_that("Custom text", {
  result <- button(text = "Custom Text")
  expected <- "\n::: {.callout-note collapse='true'}\n<p>## Custom Text</p>\n\n"
  expect_equal(result, expected)
})
