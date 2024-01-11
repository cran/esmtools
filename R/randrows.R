#' Randomly Sample Rows from a Dataframe
#'
#' The `randrows()` function randomly samples a specified number of rows from a dataframe.
#'
#' @param .data The dataframe from which rows are to be sampled.
#' @param n The number of rows to be randomly sampled. Default is 5.
#'
#' @return A dataframe containing the randomly sampled rows.
#'
#' @examples
#' # Randomly sample 3 rows from the dataset
#' randrows(esmdata_sim, n = 3)
#' @export

randrows <- function(.data, n = 5) {
  if (n > nrow(.data)) stop("n is higher than the actual number of rows")
  rand_pos <- sample(1:nrow(.data), n) # Randomly sample n rows
  .data[rand_pos, ]
}
