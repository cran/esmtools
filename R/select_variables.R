#' Select Variables Based on Type, Unique Values, and Range
#'
#' This function selects variables from a data frame based on their type, number of unique values, and range.
#'
#' @param .df The input data frame.
#' @param type A character vector specifying the types of variables to select. Default is "integer" and "numeric".
#' @param n_unique_thres The threshold for considering a variable based on the number of unique values. Default is NULL.
#' @param range_thres The threshold for considering a variable based on its range. Default is NULL.
#' @param inf. A logical value indicating whether to select variables below the n_unique threshold. Default is FALSE.
#'
#' @return A character vector containing the selected variable names.
#'
#' @noRd

select_variables <- function(.df, type = c("integer", "numeric"),
                             n_unique_thres = NULL, range_thres = NULL, inf. = FALSE) {
  names_ <- names(.df)

  # Select based on type
  types_ <- sapply(.df, class)
  types_ <- unlist(lapply(types_, function(x) x[1]))# to avoid issue with "POSIXct" "POSIXt"
  # if (length(dim(types_)) > 1) 
  types_names <- names(types_)[types_ %in% type]

  # Select based on unique values
  if (!is.null(n_unique_thres)) {
    n_unique <- sapply(.df, function(x) length(unique(x)))
    n_unique_names <- names(n_unique)[n_unique >= n_unique_thres]
    if (inf.) n_unique_names <- names(n_unique)[n_unique < n_unique_thres]
  } else {
    n_unique_names <- names_
  }

  # Select based on range
  # if (!is.null(range_thres)){
  #   range = sapply(.df[,types_=="integer" | types_=="numeric"], function(x) max(x, na.rm=TRUE) - min(x, na.rm=TRUE))
  #   range_names = names(range)[range >= range_thres]
  #   if (inf.) range_names = names(range)[range < range_thres]
  # } else {range_names = names_}

  names_[names_ %in% types_names & (names_ %in% n_unique_names)] # | names_ %in% range_names
}
