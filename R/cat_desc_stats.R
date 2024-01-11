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
#' @importFrom stats aggregate
#' @noRd

cat_desc_stats <- function(df, select_vars = NULL, n_unique_thres = 6, range_thres = 6, inf. = TRUE) {
  if (is.null(select_vars)) {
    select_vars <- select_variables(df,
      type = c("character", "factor", "integer", "numeric", "logical"),
      n_unique_thres = n_unique_thres, range_thres = range_thres, inf. = inf.
    )
  }

  if (length(select_vars) == 0) {
    return(NULL)
  }

  df_cat <- df[, select_vars, drop = FALSE]
  df_freq <- data.frame(Variable = names(df_cat), Values = " ", Freq = " ")
  for (i in 1:ncol(df_cat)) {
    name_ <- names(df_cat)[i]
    # df_freq_ <- data.frame(table(unlist(df_cat[, i]))) %>%
    #   #     unite("Freq", Var1:Freq, sep=" = ", remove=TRUE) %>%
    #   mutate(Freq = paste0(Freq, " (", base::round(Freq / nrow(df_cat) * 100, 3), "%)")) %>%
    #   summarise(
    #     Var1 = paste0(Var1, collapse = " <br> "),
    #     Freq = paste0(Freq, collapse = " <br> ")
    #   )
    # df_freq[df_freq$Variable == name_, c("Values", "Freq")] <- df_freq_[1, 1:2]
    df_freq_ <- as.data.frame(table(unlist(df_cat[, i])))
    df_freq_$Freq <- paste0(df_freq_$Freq, " (", base::round(df_freq_$Freq / nrow(df_cat) * 100, 3), "%)")
    # df_freq_ <- aggregate(Var1 ~ Freq, data = df_freq_, function(x) paste(x, collapse = " <br> "))
    df_freq[df_freq$Variable == name_, c("Values", "Freq")] <- c(paste(df_freq_[,1], collapse = " <br> "), paste(df_freq_$Freq, collapse = " <br> "))
  }

  return(df_freq)
}
