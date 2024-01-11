#' Generate a calendar plot
#'
#' @description
#' The 'calendar_plot()' function creates a calendar visualization that displays the number of occurrences of beeps over one or more years in a calendar format.
#' The function utilizes the 'ggplot2' package to create the calendar plot.
#'
#' @param .data A dataframe that contains the time variable
#' @param timevar The time variable name
#' @param interval Specifies the time interval over which to group and display data in the calendar plot, with options "halfyear" (default) or "year."
#' @param week_start When set to 1 (by default), the week starts on Monday, when set to 7, the week starts on Sunday following USA calendar.
#' @param weight_heights A list of weights for adjusting the height of individual plots in the output. Default is NULL.
#'
#' @return A ggplot object, a calendar plot.
#' @details The 'calendar_plot()' function generates a calendar plot where each cell represents a day of the year,
#' and the color intensity of the cell (and the occurence number if text_count=TRUE) reflects the number of beep occurrences on that day.
#' This allows for easy identification of patterns and trends in beep occurrences over time.
#' @examples
#' if (interactive()) {
#'   esmdata_sim$sent <- as.POSIXct(esmdata_sim$sent)
#'   calendar_plot(esmdata_sim, timevar = "sent", interval = "halfyear")
#'   calendar_plot(esmdata_sim, timevar = "sent", interval = "year")
#' }
#' 
#' @import dplyr
#' @import lubridate
#' @import tidyr
#' @import ggplot2
#' @import stringr
#' @importFrom ggpubr ggarrange
#' @export

calendar_plot <- function(.data, timevar = NULL, interval = "halfyear", week_start = getOption("lubridate.week.start", 1), weight_heights = NULL) {
  # Check if `timevar` is a POSIXt or Date object
  # Do not try to convert, as this may also convert numerical values (incorrectly).
  if (is.null(timevar)) stop("timevar must be specified.")
  timevar_col <- pull(.data, {{ timevar }})
  if (!is.Date(timevar_col) && !inherits(timevar_col, "POSIXt")) {
    stop(
      paste0("Column '", names(select(.data, {{ timevar }})), "' must be a date format."),
      call. = FALSE
    )
  }

  # Rename and select only the necessary data
  .data <- as.data.frame(.data)
  .data$.timevar <- date(.data[, timevar])
  .data <- .data[, ".timevar", drop = FALSE]

  # Calculate number of observations for each day
  # .data <- count(.data, .timevar)
  .data = as.data.frame(table(.data$.timevar))
  colnames(.data) <- c(".timevar", "n")
  .data$.timevar = as.Date(.data$.timevar)

  # Make sure there are no gaps in the timeline by filling in implicit missing values
  if (!interval %in% c("halfyear", "year")) stop("interval argument must be either 'halfyear' or 'year'")
  min_date <- min(floor_date(.data$.timevar, unit = interval))
  max_date <- max(ceiling_date(.data$.timevar, unit = interval)) - 1
  .data <- .data %>%
    drop_na() %>%
    complete(
      .timevar = seq(
        from = min_date,
        to = max_date,
        by = "day"
      ),
      fill = list(n = 0)
    )

  # Extract time relevant information
  # .data <- .data %>%
  #   mutate(year = year(.timevar)) %>%
  #   mutate(month = month(.timevar, label = TRUE)) %>%
  #   mutate(week_no = as.factor(week_number(.timevar, week_start = week_start))) %>%
  #   mutate(wday_no = wday(.timevar, week_start = week_start)) %>%
  #   mutate(wday_abbr = wday(.timevar, label = TRUE, week_start = week_start))
  .data$year <- year(.data$.timevar)
  .data$month <- month(.data$.timevar, label = TRUE)
  .data$week_no <- as.factor(week_number(.data$.timevar, week_start = week_start))
  .data$wday_no <- wday(.data$.timevar, week_start = week_start)
  .data$wday_abbr <- wday(.data$.timevar, label = TRUE, week_start = week_start)
  # .data$n <- ifelse(.data$n == 0, NA, .data$n)


  # Split .data according to year
  .data <- split(.data, .data$year)

  # Compute complete half
  increment <- -.05
  if (is.null(weight_heights)) weight_heights <- get_weights_plot(.data, min_date, max_date, type = "halfyear", increment = increment)

  # Function for plotting one year of data
  plot_year <- function(.data, min_max, wday_abbr="wday_abbr", week_no="week_no") {
    .data %>%
      ggplot(aes(x = wday_abbr, y = week_no, fill = n)) +
      geom_raster() +
      geom_text(aes(label = n), size = 3) +
      facet_wrap(vars(month), ncol = 6) +
      scale_fill_gradient(name = "nb_answer", low = "#ffffff", high = "#1c631c", limits = min_max) +
      scale_y_discrete(limits = rev) +
      labs(x = "", y = "", title = unique(.data$year)) +
      theme_bw() +
      theme(
        axis.text.y = element_blank(), axis.ticks.y = element_blank(),
        axis.text.x = element_text(angle = 90, hjust = 1)
      )
  }

  # Merge the plots
  min_max <- min_max(.data, "n")
  plot_list <- lapply(.data, plot_year, min_max = min_max)
  ggarrange(
    plotlist = plot_list,
    ncol = 1,
    common.legend = TRUE,
    heights = weight_heights
  )
}
