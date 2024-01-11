#' Extract Following Rows from a Dataframe
#'
#' The `folrows()` function extracts a specified number of consecutive rows,
#' including the starting row, from a dataframe.
#' Rows are selected consecutively from randomly chosen starting positions.
#' The function ensures that the selected rows fall within the valid row range of the dataframe.
#'
#' @param .data The dataframe from which rows are to be extracted.
#' @param n The number of consecutive rows to be extracted, including the starting row.
#'           Default is 5.
#' @param nb_sample The number of random starting positions to be sampled.
#'                  Default is 1.
#'
#' @return A dataframe containing the consecutive rows extracted from the randomly chosen starting positions.
#'
#' @examples
#' # Extract 3 consecutive rows starting from a random position in the dataset
#' folrows(esmdata_sim, n = 3)
#'
#' # Extract 4 consecutive rows starting from 2 random positions in a custom dataframe
#' folrows(esmdata_sim, n = 4, nb_sample = 2)
#'
#' @export

folrows <- function(.data, n = 5, nb_sample = 1) {
  if (n * nb_sample > nrow(.data)) stop("n and/or nb_sample are to high")
  out_sample <- TRUE
  while (out_sample) {
    rand_pos <- sample(1:nrow(.data), nb_sample) # Randomly choose starting positions
    fol_rand_pos <- unlist(lapply(rand_pos, function(x) c(x + c(0:(n - 1)))))
    out_sample <- sum(fol_rand_pos < 1 | fol_rand_pos > nrow(.data)) > 0
  }
  .data[fol_rand_pos, ]
}
