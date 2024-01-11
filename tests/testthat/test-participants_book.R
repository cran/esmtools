
# Test case 1: Check if the function return correct table (kable)
# save_kable_fun <- function(code, width = 400, height = 400) {
#   path <- tempfile(fileext = ".png")
#   code %>% kableExtra::save_kable(path)
#   path
# }

test_that("Right kable output", {
  esmdata_sim$valid = rep(rep(c(0,1), each=35), each=length(unique(esmdata_sim$id)))

  expect_no_error(
    participants_book(
      df=esmdata_sim,
      idvar = "id",
      obsnovar = "obsno",
      focusvar = c("PA1", "PA2"),
      timevar = "start",
      validvar = "valid",
      obsno_max = 70,
      list_behaviors = c("min_date", "max_date", "nb_answer", "compliance"),
      list_stats = c("mean", "sd", "n_length", "n_unique"),
      viz = list(c("ts", "hist"), c("ts", "hist"))
    )
  )

  # result <- participants_book(esmdata_sim,
  #   idvar = "id",
  #   obsnovar = "obsno",
  #   focusvar = c("PA1", "PA2"),
  #   timevar = "start",
  #   validvar = "valid",
  #   obsno_max = 70,
  #   list_behaviors = c("min_date", "max_date", "nb_answer", "compliance"),
  #   list_stats = c("mean", "sd", "n_length", "n_unique"),
  #   viz = list(c("ts", "hist"), c("ts", "hist"))
  # )
  # # Check if the output
  # announce_snapshot_file(name = "kable.png")
  # expect_snapshot_file(save_kable_fun(result), "kable.png")
})




# Test case 2: Check if the function return correct table (DT)
# save_DT_fun <- function(code, width = 400, height = 400) {
#   path <- tempfile(fileext = ".html")
#   code %>% DT::saveWidget(path)
#   path
# }

test_that("Right DT table output", {
  esmdata_sim$valid = rep(rep(c(0,1), each=35), each=length(unique(esmdata_sim$id)))

  expect_no_error(
    participants_book(
      df=esmdata_sim,
      idvar = "id",
      obsnovar = "obsno",
      focusvar = c("PA1", "PA2"),
      timevar = "start",
      validvar = "valid",
      obsno_max = 70,
      list_behaviors = c("min_date", "max_date", "nb_answer", "compliance"),
      list_stats = c("mean", "sd", "n_length", "n_unique"),
      viz = list(c("ts", "hist"), c("ts", "hist")),
      kable_out = FALSE
    )
  )
  # result <- participants_book(esmdata_sim,
  #   idvar = "id",
  #   obsnovar = "obsno",
  #   focusvar = c("PA1", "PA2"),
  #   timevar = "start",
  #   validvar = "valid",
  #   obsno_max = 70,
  #   list_behaviors = c("min_date", "max_date", "nb_answer", "compliance"),
  #   list_stats = c("mean", "sd", "n_length", "n_unique"),
  #   viz = list(c("ts", "hist"), c("ts", "hist")),
  #   kable_out = FALSE
  # )
  # # Check if the output
  # announce_snapshot_file(name = "dtable.html")
  # expect_snapshot_file(save_DT_fun(result), "dtable.html")
})
