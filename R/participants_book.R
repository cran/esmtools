#' Generate a participants' book
#'
#' The 'participants_book()' function creates a participants' book, which provides a concise summary of participants' data
#' from an intensive longitudinal study, such as Experience Sampling Method (ESM).
#' The book is generated using the DT package, and each participant is represented by a row in the table.
#' The participants' book displays various information about participants' response behaviors, including compliance rate,
#' study duration, and start time. Additionally, it provides descriptive statistics and time series plots for the variables of interest.
#' See an example here: <https://preprocess.esmtools.com/pages/90_Participant_book.html>.
#'
#' @param df A dataframe containing the participant data
#' @param idvar The name of the column in the dataframe that represents the participant identifier
#' @param obsnovar The name of the column in the dataframe that represents the beep number
#' @param focusvar A vector of variable names representing the variables of interest in the dataframe
#' @param timevar The name of the column in the dataframe that represents the timestamp
#' @param validvar The name of the column in the dataframe that represents the validity of responses
#' @param compliancevar The name of the column in the dataframe that represents the compliance rate (alternatively, if NULL, the compliance score is computed as the number of rows divided by obsno_max)
#' @param obsno_max The maximum number of beeps for computing the compliance score (only used if compliancevar is NULL)
#' @param list_behaviors A vector indicating the types of participants' response behavior information to display. Valid options are "min_date", "max_date", "nb_answer", and "compliance".
#' @param list_stats A vector indicating the types of descriptive statistics to display. Valid options are "mean", "sd", "range", "n_length", and "n_unique".
#' @param viz A vector indicating the visualization type to display for each focusvar variable. Valid options are "ts" (time series plot) and "hist" (histogram).
#' @param html_output Define a file name (e.g., "path/to/participant_book.html") to create an html output version of the participant book.
#' @param kable_out When TRUE, output is in kable version. If FALSE, use DT package.
#' @param min_max_regularize Whether to regularize the y-axis or x-axis limits across plots based on the global minimum and maximum values. Default is TRUE.
#' @return A kable or datatable object (from the DT package), representing the participants' book.
#' @examples
#' \donttest{
#'  participants_book(esmdata_preprocessed,
#'    idvar = "id",
#'    obsnovar = "obsno",
#'    focusvar = c("pos_aff", "neg_aff"),
#'    timevar = "start",
#'    validvar = "valid",
#'    obsno_max = 70,
#'    list_behaviors = c("min_date", "max_date", "nb_answer", "compliance"),
#'    list_stats = c("mean", "sd", "range", "n_length", "n_unique"),
#'    viz = list(c("ts", "hist"), c("ts", "hist"))
#'  )
#' }
#' 
#' @importFrom kableExtra kbl kable_paper column_spec save_kable
#' @import dplyr
#' @import ggplot2
#' @export


participants_book <- function(df, idvar = "id", obsnovar = "obsno",
                              focusvar = NULL, timevar = NULL,
                              validvar = NULL,
                              compliancevar = NULL,
                              obsno_max = NULL,
                              list_behaviors = c("min_date", "max_date", "nb_answer", "compliance"),
                              list_stats = c("mean", "sd", "n_length", "n_unique"),
                              viz = list(c("ts", "hist")),
                              html_output = NULL,
                              kable_out = TRUE,
                              min_max_regularize = TRUE) {
  df <- as.data.frame(df)

  ####################
  ##### Initial error detection
  ####################
  # Test if each variable name not NULL are in the dataframe
  if (("min_date" %in% list_behaviors | "max_date" %in% list_behaviors) & !is.null(timevar)) {
    if (!any(is.POSIXct(df[, timevar]), !is.POSIXlt(df[, timevar]))) stop("The time variable is not in POSIXct or POSIXlt format")
  }

  # If valid not provided then it is computed based on missing valid on the timevar
  if (is.null(validvar)) {
    validvar <- "valid"
    if (is.null(timevar)) stop("You should either fulfill the timevar argument or the validvar argument")
    df[, validvar] <- as.numeric(df[, timevar])
  }
  if (sum(!df[, validvar] %in% c(0, 1) | is.na(df[, validvar])) > 0) stop("The valid variable has values different from 0 and 1")


  # Rename
  # Function to replace elements
  replace_elements <- function(vec, replace=c("ts" = "timeseries")) {
    for (i in 1:length(replace)){
      vec <- gsub(paste0("\\b", names(replace)[i],"\\b"), replace[i], vec)
    }
    return(vec)
  }
  # Define the replacement rules
  replacement <- c("ts" = "timeseries", "hist" = "histogram")
  viz <- lapply(viz, replace_elements, replace=replacement)

  ####################
  ##### Compute descriptive participants' response behaviors
  ####################
  df_describ <- data.frame(Participant = unique(df[, idvar]))

  # Compute min time
  if ("min_date" %in% list_behaviors) {
    min_date <- tapply(df[, timevar], df[, idvar], FUN = function(x) min(x, na.rm = TRUE))
    df_describ[, "min_date"] <- as.POSIXct(min_date, origin = "1970-01-01") # TODO: test
  }
  # Compute max time
  if ("max_date" %in% list_behaviors) {
    max_date <- tapply(df[, timevar], df[, idvar], FUN = function(x) max(x, na.rm = TRUE))
    df_describ[, "max_date"] <- as.POSIXct(max_date, origin = "1970-01-01")
  }
  # Compute number of responses
  if ("nb_answer" %in% list_behaviors) {
    df_describ[, "nb_answer"] <- tapply(df[, validvar], df[, idvar],
      FUN = function(x) sum(x, na.rm = TRUE)
    )
  }

  # Compute compliance
  if (!is.null(compliancevar)) {
    # Test if compliance is numeric
    if (!is.numeric(df[, compliancevar])) stop("Compliance variable is not numeric")

    # Test if a unique value per participant
    n <- tapply(df[, compliancevar], df[, idvar], FUN = function(x) length(unique(x, na.rm = TRUE)))
    if (sum(n > 1) > 0) stop("Not an unique value of compliance per grouping variable")

    comp_scores <- tapply(df[, compliancevar], df[, idvar], FUN = function(x) unique(x, na.rm = TRUE))
    df_describ[, "compliance"] <- base::round(comp_scores, 3)
  } else if ("compliance" %in% list_behaviors) {
    if (is.null(obsno_max)) stop("You must provide obsno_max argument or specify the compliancevar argument")
    df_describ[, "compliance"] <- tapply(df[, validvar], df[, idvar], FUN = function(x) base::round(sum(x, na.rm = TRUE) / obsno_max, 2))
  }

  # Convert to POSIXct and character
  df_describ$Participant <- as.character(df_describ$Participant)
  df_describ <- apply(df_describ, 2, as.character)
  df_describ <- as.data.frame(df_describ)


  ####################
  ##### Stats descriptive of variable of interest
  ####################
  if (!is.null(focusvar)) {
    if (is.null(viz)) {
      varstats_names <- paste0(focusvar, "stats")
    } else {
      varstats_names <- c()
      for (i in 1:length(viz)) {
        names <- paste(focusvar[i], c("stats", viz[[i]]), sep = ".")
        varstats_names <- c(varstats_names, names)
      }
    }

    ## Compute descriptive statistics
    # df_sum <- df %>%
    #   rename(Participant = id) %>%
    #   group_by(Participant) %>%
    #   summarise(across(all_of(focusvar), list(
    #     mean = ~ paste0("mean = ", base::round(base::mean(.x, na.rm = TRUE), 2)),
    #     sd = ~ paste0("sd = ", base::round(sd(.x, na.rm = TRUE), 2)),
    #     range = ~ paste0("range = ", base::round(min(.x, na.rm = TRUE), 2), " - ", base::round(max(.x, na.rm = TRUE), 2)),
    #     n_length = ~ paste0("n_length = ", sum(!is.na(.x))),
    #     n_unique = ~ paste0("n_unique = ", length(unique(.x)))
    #   ),
    #   .names = "{.col}_{.fn}"
    #   ))

    ### Compute descriptive statistics
    # df$Participant <- df[,idvar]
    # df[,idvar] <- NULL  # Remove the 'id' column if it's no longer needed
    # Initialize an empty list to store results
    summary_stats <- list()

    # Function to calculate summary statistics for a given vector
    calculate_stats <- function(x) {
      list(
        mean = paste0("mean = ", round(mean(x, na.rm = TRUE), 2)),
        sd = paste0("sd = ", round(sd(x, na.rm = TRUE), 2)),
        range = paste0("range = ", round(min(x, na.rm = TRUE), 2), " - ", round(max(x, na.rm = TRUE), 2)),
        n_length = paste0("n_length = ", sum(!is.na(x))),
        n_unique = paste0("n_unique = ", length(unique(x)))
      )
    }

    # Loop through unique Participants and calculate statistics for each variable in focusvar
    for (participant in unique(df[,idvar])) {
      participant_data <- df[df[,idvar] == participant, focusvar]
      for (var in names(participant_data)) {
        participant_stats <- calculate_stats(participant_data[[var]])
        summary_stats[[as.character(participant)]] <- c(summary_stats[[as.character(participant)]], participant_stats)
      }
    }

    # Convert the list of lists to a data frame
    participant_ids <- names(summary_stats)
    df_summary <- data.frame(matrix(unlist(summary_stats), ncol = length(summary_stats[[participant_ids[1]]]), byrow = TRUE))
    stats_name = c("mean", "sd", "range", "n_length", "n_unique")
    names(df_summary) <- paste(rep(focusvar, each = length(stats_name)), rep(stats_name, length(focusvar)), sep = "_")
    df_sum <- cbind(data.frame(Participant=unique(df[,idvar])), df_summary)



    # Select descriptive based on user input
    select_vars <- apply(sapply(list_stats, grepl, df_sum), 1, any)
    select_vars[1] <- TRUE
    df_sum <- df_sum[, select_vars]

    # Merging in one cell all the descriptive analysis
    for (var in focusvar) {
      name_ <- names(df_sum)[grep(var, names(df_sum))]
      # df_sum <- unite(df_sum, "merged", c(name_), remove = TRUE, sep = " <br> ")
      df_sum$merged <- do.call(paste, c(df_sum[name_], sep = " <br> "))
      df_sum <- df_sum[, !(names(df_sum) %in% name_)]
      names(df_sum)[names(df_sum) == "merged"] <- paste0(var, ".stats")
    }

    # Merge descriptive stats from the same variable
    nrow_ <- nrow(df_describ)
    pp_book <- data.frame(matrix(NA, nrow_, length(varstats_names) + 1))
    names(pp_book) <- c("Participant", varstats_names)
    pp_book[, names(df_sum)] <- df_sum
    select_num <- names(pp_book)[sapply(pp_book, class) %in% c("numeric", "integer", "double")]
    pp_book <- pp_book %>% mutate(across(all_of(select_num), as.character))

    # Suppress NA values
    pp_book[is.na(pp_book)] <- " "

    # Transform Participant in character variable
    pp_book$Participant <- as.character(pp_book$Participant)

    # Merge main and statistics parts
    pp_book <- left_join(df_describ, pp_book, by = c("Participant"))



    ####################
    ##### Create plots
    ####################
    plots <- list()
    if (!is.null(viz)) {
      size_plot <- 150
      for (i in 1:length(focusvar)) {
        var <- focusvar[i]
        plot <- viz[[i]]

        # Split data by participant
        df_split <- split(df[, var], df[, idvar])
        df_split <- lapply(df_split, function(x) data.frame(val = x, beepnr = 1:length(x)))
        df_split <- df_split[match(pp_book$Participant, names(df_split))] # Ordering based on pp_book participant

        # Time series plot per participant
        if ("timeseries" %in% plot) {
          pp_book[, paste0(var, ".timeseries")] <- ""
          plots[[paste0(var, ".timeseries")]] <- plot_64(df_split, type="line", size_plot = size_plot, kable_out = kable_out, min_max_regularize=min_max_regularize)
        }
        # Histogram plot per participant
        if ("histogram" %in% plot) {
          pp_book[, paste0(var, ".histogram")] <- ""
          plots[[paste0(var, ".histogram")]] <- plot_64(df_split, type="histogram", size_plot = size_plot, kable_out = kable_out, min_max_regularize=FALSE)
        }

      }
    }
  }


  ####################
  ##### Custom the output
  ####################
  if (kable_out) {
    for (i in names(plots)) {
      pp_book[, i] <- plots[[i]]
    }

    # Centering first columns
    col_center <- c("Participant","min_date","max_date","nb_answer","compliance")
    align <- rep("l", ncol(pp_book))
    align[names(pp_book) %in% col_center] <- "c"

    # Create kable
    pp_book_out <- pp_book %>%
      kbl(escape = FALSE, booktabs = F, align = align) %>%
      kable_paper(full_width = F)

    # Adapt size
    length_col <- as.data.frame(sapply(pp_book, count_characters))
    for (i in 1:ncol(length_col)) {
      name_ <- names(length_col)[i]
      width <- as.numeric(length_col[2, i]) * .9
      if (width > 10) width <- 10
      if (name_ %in% c("stats", "Stats") & width < 9) width <- 9
      if (name_ %in% c("max_date", "min_date")) width <- 6.5
      if (name_ %in% c("Freq") & width < 8) width <- 8
      pp_book_out <- pp_book_out %>%
        column_spec(i, width_min = paste0(width, "em"))
    }


    # Create html output
    if (!is.null(html_output)) {
      if (!endsWith(html_output, "html")) html_output <- paste0(html_output, ".html")
      pp_book_out %>% save_kable(html_output)
    }

  ### DT version
  } else {
    if (!requireNamespace("DT", quietly = TRUE)) {
      stop("Package 'DT' is not available.")
    }
    pp_book_out <- pp_book %>%
      datatable(
        escape = FALSE,
        extensions = "Buttons",
        options = list(
          scrollX = FALSE, # requirede for manipulating width of collumns
          autoWidth = TRUE, # requirede for manipulating width of collumns
          columnDefs = list(list(width = "150px", targets = names(pp_book)[grepl("timeseries", names(pp_book)) | grepl("histogram", names(pp_book))])),
          dom = "Bfrtip",
          buttons = list("copy", "print", list(
            extend = "collection",
            buttons = c("csv", "excel", "pdf"),
            text = "Download"
          ))
        )
      )
  }

  return(pp_book_out)
}

