#' Create Unique Values Dataframe
#'
#' This function takes a dataframe, a group variable, and a vector of variables. It creates a new dataframe that contains unique values for each variable within each group modality.
#' Only one group variable should be used, otherwise, an error will be thrown.
#' The resulting dataframe has the group variable as the first column and each variable's unique values as subsequent columns.
#' The `merge_val` function is applied to merge the unique values within each group.
#'
#' @param .df A dataframe containing the data.
#' @param group The name of the group variable.
#' @param vars A vector of variable names to consider.
#' @param max_length The maximum length of the merged values. If the length of the merged values exceeds this value, the values are truncated and an ellipsis is added at the end. Default is 4.
#'
#' @return A dataframe with unique values for each variable within each group modality.
#'
#' @examples
#' vars_consist(esmdata_sim, group = "id", vars = c("age", "cond_dyad"))
#' @export
#'
vars_consist <- function(.df, group, vars, max_length=4) {
  if (length(group) > 1) stop("Only one group variable should be used.")

  # Check if dataframe, transform to dataframe if possible
  if (!is.data.frame(.df)) {
    if (is.list(.df)) {
      .df <- as.data.frame(.df)
    } else {
      stop("The input must be a dataframe.")
    }
  }

  .df[, group] <- as.character(.df[, group])
  .df[, group] <- ifelse(is.na(.df[, group]), "NA", .df[, group])

  # Create output dataframe
  df_unique <- as.data.frame(matrix(NA, length(unique(.df[, group])), length(vars) + 1))
  df_unique[, 1] <- unique(.df[, group])

  # Gather unique values for each variables within each group modality
  for (i in 1:length(vars)) {
    grouped_values <- split(.df[, vars[i]], .df[, group])
    merged_values <- lapply(grouped_values, function(x) merge_val(unique(x), max_length=max_length))
    ordered_values <- unlist(merged_values)[order(match(names(merged_values), df_unique[, 1]))]
    df_unique[, 1 + i] <- unlist(ordered_values)
    # df_unique[, 1 + i] = ave(df[,vars[i]], df[,group], FUN = function(x) merge_val(unique(x)))
  }

  # Rename
  names(df_unique) <- c(group, vars)

  return(df_unique)
}


#' Merge Values in a Vector
#'
#' This function takes a vector and merges its values into a single string. If the vector has only one element, that element is returned as a character.
#' If the vector has more than one element, the values are concatenated with commas and enclosed in parentheses.
#'
#' @param vec A vector of values to be merged.
#'
#' @return A merged string representation of the input vector.
#'
#' @import stringr
#' @noRd

merge_val <- function(vec, max_length=4) {
  if (length(vec) <= 1) {
    as.character(vec)
  } else if (length(vec) > 1) {
    vec[is.na(vec)] = "NA"
    if (length(vec) > max_length) {
      vec = c(vec[1:max_length], "...")
    }
    paste0("(", str_c(as.character(vec), collapse = ", "), ")")
  }
}
