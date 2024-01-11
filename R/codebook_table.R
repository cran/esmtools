#' Create Codebook Table
#'
#' The `codebook_table()` function generates a codebook table for a given dataframe,
#' providing descriptive statistics and visualizations for each variable.
#' See an example here: <https://preprocess.esmtools.com/pages/90_Codebook_table_esmtools.html>.
#'
#' @param df The dataframe for which the codebook table is generated.
#' @param origin_cbook A dataframe of a hand-maid codebook table that is stored in an csv of xlsx file.
#'                     The file must be first imported in the R session.
#'                     If the variable containing the basis codebook, the resulting codebook table will include
#'                     the original codebook information.
#'                     This allows merging and incorporating a hand-made codebook into the output.
#'                     Default is `NULL`.
#' @param origin_vars A character string specifying the name of the variable column in the `origin_cbook`.
#'                    Default is "Variable".
#' @param n_unique_thres The threshold for the number of unique values to consider a variable as categorical.
#'                       Default is 6.
#' @param include_txt Logical indicating whether to include text variable statistics in the codebook table.
#'                    Default is `FALSE`.
#' @param include_date Logical indicating whether to include date variable statistics in the codebook table.
#'                     Default is `TRUE`.
#' @param histograms Logical indicating whether to include histograms in the codebook table.
#'                   Default is `TRUE`.
#' @param boxplots Logical indicating whether to include boxplots in the codebook table.
#'                 Default is `TRUE`.
#' @param html_output Define a file name (e.g., "path/to/codebook_table.html") to create an html output version of the codebook table.
#' @param kable_out When TRUE, output is in kable version. If FALSE, use DT package.
#'
#' @return A a codebook table generated using kable or the DT package.
#'
#' @examples
#' if (interactive()) {
#'  # Load library 
#'  library(esmtools)
#'  library(readxl) 
#' 
#'  # Load the hand-made codebook
#'  path_original <- system.file("extdata", "cbook_part1.xlsx", package = "esmtools")
#'  original_codebook <- read_excel(path_original)
#' 
#'  # Create codebook table based on the hand-made codebook and the dataset
#'  \donttest{codebook_table(df = esmdata_sim, origin_cbook = original_codebook)}
#' }
#' @importFrom kableExtra kbl kable_paper column_spec save_kable
#' @import dplyr
#' @import ggplot2
#' @importFrom DT datatable
#' @export


codebook_table <- function(df, origin_cbook = NULL, origin_vars = "Variable",
                           n_unique_thres = 6,
                           include_txt = FALSE, include_date = TRUE,
                           histograms = TRUE, boxplots = TRUE,
                           html_output = NULL, kable_out = TRUE) {
  ################
  ######## Descriptive statistics
  ################

  # Transform to data.frame format
  df = as.data.frame(df)

  # Compute missing
  missing <- colSums(is.na(df))

  # Compute descriptive statistics
  df_type <- data.frame(
    Variable = names(df),
    R_type = unlist(sapply(sapply(df, class), function(x) x[1])),
    missing = paste0(missing, " (", base::round(missing / nrow(df), 2) * 100, "%)")
  )

  dfs <- list()
  dfs[["origin_cbook"]] <- origin_cbook
  dfs[["df_cont"]] <- cont_desc_stats(df, n_unique_thres = n_unique_thres) # , range_thres=range_thres)
  dfs[["df_cat"]] <- cat_desc_stats(df, n_unique_thres = n_unique_thres) # , range_thres=range_thres)
  # if (include_txt) dfs[["df_txt"]] = txt_desc_stats(df, n_unique_thres=range_thres)
  if (include_date) dfs[["df_date"]] <- date_desc_stats(df) # , n_unique_thres=range_thres)

  for (i in 1:length(dfs)) {
    if (!exists(".cbook")) {
      .cbook <- left_join(dfs[[i]], df_type, by = c(origin_vars))
    } else {
      .cbook <- left_join(.cbook, dfs[[i]], by = c(origin_vars))
    }
  }
  cbook <- .cbook

  # Replace NA by " "
  cbook[is.na(cbook)] <- " "

  # Merge columns values
  # cbook$stats = paste(cbook$stats, cbook$Freq, cbook$Date_stats)
  # cbook = cbook[,!(names(cbook) %in% c("Freq", "Date_stats"))]

  # Rename variable column
  names(cbook)[names(cbook) == origin_vars] <- "Variable"

  # Rearrange based on original variable order
  order_vars <- match(cbook$Variable, names(df), nomatch = ncol(df) + 1)
  cbook <- cbook[order(order_vars), ]
  cbook <- cbook %>% dplyr::select("Variable", everything())



  ################
  ######## Visualization using DT package
  ################

  # Extract order in which df variables are in cbook + exclude if value not matching
  df_vars_order <- match(names(df), cbook$Variable)
  df_vars_order <- df_vars_order[!is.na(df_vars_order)]

  list_df <- list()
  for (i in 1:length(df_vars_order)) { # Using for-loop to add columns to list
    df_select_ <- df[, df_vars_order[i]]
    if (typeof(df_select_) %in% c("logical", "character", "logical", "POSIXct", "POSIXt", "double")) df_select_ <- 0
    list_df[[i]] <- data.frame(val = df_select_)
  }

  size_plot <- 150
  # Create histograms
  if (histograms) hists <- plot_64(list_df, type="histogram", size_plot = size_plot, kable_out = kable_out, min_max_regularize = FALSE)
  # Create boxplots
  if (boxplots) boxs <- plot_64(list_df, type="boxplot", size_plot = size_plot, kable_out = kable_out, min_max_regularize = FALSE)




  ################
  ######## Prepare output kable or DT
  ################

  if (kable_out) {
    # Create histograms & boxplots columns
    if (histograms) cbook[df_vars_order, "Hist"] <- hists
    if (boxplots) cbook[df_vars_order, "Boxplot"] <- boxs

    # Create kable
    cbook_out <- cbook %>%
      kbl(escape = FALSE, booktabs = F) %>%
      kable_paper(full_width = F)

    # Adapt size
    length_col <- as.data.frame(sapply(cbook, count_characters))
    for (i in 1:ncol(length_col)) {
      name_ <- names(length_col)[i]
      width <- as.numeric(length_col[2, i]) * .9
      if (width > 10) width <- 13
      if (name_ %in% c("stats", "Stats") & width < 9) width <- 9
      if (name_ %in% c("Freq") & width < 8) width <- 8
      cbook_out <- cbook_out %>%
        column_spec(i, width_min = paste0(width, "em"))
    }

    # Add images
    # if(histograms) cbook_out = cbook_out %>%
    #   column_spec(which(names(cbook) == "Hist"), image = spec_image(out, 150, 150))
    # if(boxplots) cbook_out = cbook_out %>%
    #   column_spec(which(names(cbook) == "Boxplot"), image = spec_image(boxs, 150, 150))

    # Create html output
    if (!is.null(html_output)) {
      if (!endsWith(html_output, "html")) html_output <- paste0(html_output, ".html")
      cbook_out %>% save_kable(html_output)
    }


  # Create DT table
  } else {
    if (!requireNamespace("DT", quietly = TRUE)) {
      stop("Package 'DT' is not available.")
    }
    button <- TRUE

    # Create histograms & boxplots
    if (histograms) cbook[df_vars_order, "hist"] <- hists
    if (boxplots) cbook[df_vars_order, "boxplot"] <- boxs

    # Size columns
    column_size <- list( # list(width = '10px', targets = which(names(cbook) %in% c("Number"))),
      list(width = "100px", targets = (ncol(cbook) - 1):(ncol(cbook))),
      list(width = "100px", targets = which(names(cbook) %in% c("stats", "Word_stats", "Freq", "Date_stats", "Label_value"))),
      list(width = "150px", targets = which(names(cbook) %in% c("Description")))
    )

    # Button
    if (button) {
      button_list <- list("copy", "print", list(
        extend = "collection",
        buttons = c("csv", "excel", "pdf"),
        text = "Download"
      ))
    } else {
      button_list <- list()
    }

    # Create the output
    cbook_out <- cbook %>% DT::datatable(
      escape = FALSE,
      extensions = "Buttons",
      options = list(
        scrollX = TRUE, # required for manipulating width of collumns
        autoWidth = TRUE, # required for manipulating width of collumns
        columnDefs = column_size,
        dom = "Bfrtip",
        buttons = button_list
      )
    )
  }
  return(cbook_out)
}





#' Characters length within "<br>" tags in a variable
#'
#' The count_characters function takes a dataframe and a variable name as input.
#' It counts the number of characters in each cell of the specified variable, divides it by
#' the number of occurrences of the "<br>" tag within the cell, and then computes the
#' maximum and average values. The function is useful when you want to analyze the
#' average and maximum character count per "<br>" in a given variable.
#'
#' @param data The input dataframe containing the data to be analyzed.
#' @param variable The name of the variable within the dataframe for which character count
#' is to be computed.
#' @return A list containing maximum and average values of character length within <br> tags in the variable.
#' @noRd
count_characters <- function(vec) {
  # Extract character count and "<br>" count
  character_count <- nchar(vec)
  br_count <- str_count(vec, "<br>")

  # Compute character count per "<br>"
  character_per_br <- (character_count - br_count * 3) / (br_count + 1)

  # Compute maximum and average values
  max_value <- max(character_per_br, na.rm = TRUE)
  avg_value <- base::mean(character_per_br, na.rm = TRUE)

  # Return results
  return(list(maximum = max_value, average = avg_value))
}
