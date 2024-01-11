test_that("Check tags and importation of styles/scripts", {
  result <- add_script_to_rmd()
  expect_true(grepl("<script>", result))
  expect_true(grepl("</script>", result))
  expect_true(grepl("<style>", result))
  expect_true(grepl("</style>", result))

  expect_true(grepl(".esm-issue", result))
  expect_true(grepl(".esm-inspect", result))
  expect_true(grepl(".esm-mod", result))
  expect_true(grepl(".warning_hide", result))
  expect_true(grepl(".esmtools-btn", result))
  expect_true(grepl("toggleContent", result))
})
