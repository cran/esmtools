#' Calculate Week Number
#'
#' This function calculates the week number for a given date, based on the specified week start day.
#'
#' @param timevar A vector of date-time values for which week numbers will be calculated.
#' @param week_start A character string specifying the starting day of the week. Default is 'Sunday.'
#'
#' @return A numeric vector representing the week numbers for each date in 'timevar'.
#'
#' @details The function computes the week number by considering the specified week start day and the date provided
#' in 'timevar' argument. It returns the week number as a numeric vector.
#'
#' @noRd
week_number <- function(timevar, week_start) {
  (5 + day(timevar) + wday(floor_date(timevar, "month"), week_start = week_start)) %/% 7
}



#' Compute Weights for Plotting Calendar
#'
#' This function calculates weights for data frames to be used in plotting. The weights are
#' based on the maximum week number within a specified time range and are normalized to assist
#' in plotting data.
#'
#' @param plot_data A list of data frames containing the data to be plotted.
#' @param min_date The minimum date in the data range.
#' @param max_date The maximum date in the data range.
#' @param type A character string specifying the type of weight computation. Options are "halfyear" (default) and "year."
#' @param increment A numeric value specifying the increment used in weight computation. Default is 0.1.
#'
#' @return A vector of normalized weights for each data frame in 'plot_data'.
#'
#' @details The function calculates weights for each data frame in 'plot_data' based on the maximum week number
#' within a specified time range. The weights are normalized to ensure consistent scaling for plotting purposes.
#'
#' @noRd
get_weights_plot <- function(plot_data, min_date, max_date, type = "halfyear", increment = .1) {
  years <- seq(year(min_date), year(max_date))

  # Get number of panel
  if (type == "halfyear") {
    nb_panel <- ifelse(years == year(min_date) & month(min_date) > 6 |
      years == year(max_date) & month(max_date) < 7, 1, 2)
  } else if (type == "year") {
    nb_panel <- rep(2, length(years))
  }

  # Compute weight in function of max week per panel
  get_weights <- function(.df) {
    month_split <- split(.df, month(.df$.timevar) <= 6)
    unlist(lapply(month_split, function(x) max(as.numeric(x$week_no))))
  }
  max_weeks <- lapply(plot_data, get_weights)
  min_max <- min(do.call(pmin, max_weeks))

  # Normalize and compute final weights
  normalize <- function(vec, min, increment = .1) {
    vec <- 1 + (vec - min) * increment
    return(vec)
  }
  norm_weeks <- lapply(max_weeks, normalize, min = min_max, increment = increment)
  sum_norm_weeks <- unlist(lapply(norm_weeks, sum))

  return(sum_norm_weeks)
}




#' Calculate Minimum and Maximum Values
#'
#' This function calculates the minimum and maximum values from a list of numerical vectors.
#'
#' @param x A list containing numerical vectors.
#'
#' @return A numeric vector containing the minimum and maximum values.
#'
#' @examples
#' x <- list(vec1 = c(1, 2, 3), vec2 = c(4, 5, 6), vec3 = c(7, 8, 9))
#' min_max(x)
#'
#' @noRd
min_max <- function(x, select = NULL) {
  if (!is.null(select)) x <- lapply(x, function(.) .[[select]])

  max_value <- max(unlist(x), na.rm = TRUE)
  min_value <- min(unlist(x), na.rm = TRUE)
  c(min_value, max_value)
}
