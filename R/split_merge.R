#' Compare x to 1
#'
#' This function takes a dataframe and splits it into multiple dataframes based on the specified number of columns.
#' Each resulting dataframe will have a column named "number" containing the sequence numbers from 1 to the number of rows in that dataframe.
#' The resulting dataframes are then merged based on the "number" column.
#' Missing values are replaced with empty strings in the merged dataframe.
#'
#' @param .data A dataframe to be split and merged
#' @param ncol A number indicating the number of columns in the output dataframe. Default is 3.
#'
#' @return A merged dataframe with missing values replaced by empty strings.
#'
#' @noRd
split_merge <- function(.data, ncol = 3) {
  df_list <- list()
  nrow <- nrow(.data)
  # if (nrow < ncol) ncol = nrow
  for (i in 1:ncol) {
    if (nrow < i) {
      df_list[[i]] <- as.data.frame(matrix(NA, 1, 2))
      df_list[[i]]$number <- 1
      names(df_list[[i]]) <- c("Package", "Version", "number")
    } else {
      df_list[[i]] <- .data[seq(i, nrow(.data), by = ncol), ]
      df_list[[i]]$number <- c(1:nrow(df_list[[i]]))
    }
  }
  df_merged <- Reduce(function(x, y) merge(x, y, by = "number", all = TRUE), df_list)
  df_merged[is.na(df_merged)] <- ""
  df_merged
}
