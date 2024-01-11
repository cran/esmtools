#' Generate Descriptive Statistics for Continuous Variables
#'
#' This function generates descriptive statistics for continuous variables in a data frame.
#'
#' @param df The input data frame.
#' @param select_vars A character vector specifying the continuous variables to analyze. If NULL, the function will automatically select variables of type "integer" and "numeric" based on specified thresholds.
#' @param n_unique_thres The threshold for considering a variable based on the number of unique values. Default is 6.
#' @param range_thres The threshold for considering a variable based on its range. Default is 6.
#'
#' @return A dataframe with variable names and their corresponding descriptive statistics.
#'
#' @examples
#' df <- data.frame(var1 = c(1, 2, 3), var2 = c(4, 5, 6))
#' cont_desc_stats(df)
#'
#' @import dplyr
#' @import tidyr
#' @importFrom stats quantile median sd
#' @noRd

cont_desc_stats <- function(df, select_vars = NULL, n_unique_thres = 6, range_thres = 6) {
  if (is.null(select_vars)) {
    select_vars <- select_variables(df,
      type = c("integer", "numeric"),
      n_unique_thres = n_unique_thres
    ) # , range_thres=range_thres)
  }

  if (length(select_vars) == 0) {
    return(NULL)
  }

    # Summarize across select_vars
  df_sum <- as.data.frame(
    t(
      sapply(select_vars, function(var) {
        data <- df[[var]]
        list(
          n_uni = length(unique(data)),
          min = min(data, na.rm = TRUE),
          q25 = quantile(data, 0.25, na.rm = TRUE),
          median = median(data, na.rm = TRUE),
          q75 = quantile(data, 0.75, na.rm = TRUE),
          max = max(data, na.rm = TRUE),
          mean = mean(data, na.rm = TRUE),
          sd = sd(data, na.rm = TRUE)
        )
      })
    )
  )

  # Apply rounding and conversion to character for numeric columns
  df_sum <- lapply(df_sum, function(x) {
    format(round(as.numeric(x), 2), nsmall = 2)
  })
  df_sum = do.call(cbind, df_sum)
  df_sum = as.data.frame(df_sum)


  # Paste col names
  # df_sum2 = as.character(df_sum2)
  min_pos <- which(names(df_sum) == "n_uni")
  max_pos <- which(names(df_sum) == "sd")
  for (i in min_pos:max_pos) {
    name_ <- names(df_sum)[i]
    df_sum[, i] <- paste0(name_, " = ", df_sum[, i])
  }

  df_sum = df_sum %>% unite("stats", "n_uni":"sd", sep = " <br> ", remove = TRUE)

  # Names
  df_sum$Variable = select_vars

  return(df_sum)
}
