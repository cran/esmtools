#' Generate Descriptive Statistics for Date Variables
#'
#' This function generates descriptive statistics for date variables in a data frame.
#'
#' @param .df The input data frame.
#' @param select_vars A character vector specifying the date variables to analyze. If NULL, the function will automatically select variables of type "POSIXct" or "POSIXt".
#' @param n_unique_thres The threshold for considering a variable as categorical based on the number of unique values. Default is 6.
#'
#' @return A data frame with variable names and their corresponding date statistics.
#'
#' @examples
#' df <- data.frame(date1 = as.POSIXct("2023-09-08 12:30:00"), date2 = as.POSIXct("2023-09-09 13:45:00"))
#' date_desc_stats(df)
#'
#' @noRd

date_desc_stats <- function(.df, select_vars = NULL, n_unique_thres = 6) {
  if (is.null(select_vars)) {
    select_vars <- select_variables(.df, type = c("POSIXct", "POSIXt"))
  }

  if (length(select_vars) == 0) {
    return(NULL)
  }

  df_temp <- .df[, select_vars, drop = FALSE]
  df_date <- data.frame(Variable = names(df_temp), Date_stats = " ")
  for (i in 1:ncol(df_temp)) {
    name_ <- names(df_temp)[i]

    date_min <- paste0("min=", min(df_temp[, i], na.rm = TRUE))
    date_max <- paste0("max=", max(df_temp[, i], na.rm = TRUE))

    # df_range = data.frame(id=df$id, date=df_temp[,i]) %>%
    #   group_by(id) %>%
    #   summarize(min_date = min(date), max_date=max(date)) %>%
    #   mutate(range = difftime(max_date, min_date, units="days"))

    # min_range_id = paste0("min_range_id = ", base::round(as.numeric(min(df_range$range)),2), " days")
    # max_range_id = paste0("max_range_id = ", base::round(as.numeric(max(df_range$range)),2), " days")

    df_date[df_date$Variable == name_, "Date_stats"] <- paste(date_min, date_max, sep = " <br> ")
  }

  return(df_date)
}
