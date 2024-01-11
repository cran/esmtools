#' Generate a heatmap calendar plot
#'
#' @description
#' The 'heatcalendar_plot()' function creates a heatmap-style calendar visualization that represents the density of events over time.
#' Each cell in the heatmap represents a specific day, and its color intensity reflects the number of events that occurred on that day.
#' This function utilizes the 'ggplot2' R package to create the heatmap calendar plot.
#'
#' @inheritParams calendar_plot
#' @return A heatmap calendar plot
#' @details The 'heatcalendar_plot()' function generates a heatmap-style calendar plot where each cell corresponds to a day of the year. The color intensity of each cell represents the event density, allowing for the identification of patterns and trends in event occurrences over time.
#' @import ggplot2
#' @import dplyr
#' @import lubridate
#' @import tidyr
#' @examples
#' if (interactive()) {
#'   esmdata_sim$sent <- as.POSIXct(as.character(esmdata_sim$sent))
#'   heatcalendar_plot(esmdata_sim, timevar = "sent")
#' }
#' @export

heatcalendar_plot <- function(.data, timevar = NULL, week_start = getOption("lubridate.week.start", 1)) {
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
  interval <- "year"
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
  # plot_data <- .data %>%
  #   mutate(year = year(.timevar)) %>%
  #   mutate() %>%
  #   mutate(week_no = as.factor(week_number(.timevar, week_start = week_start))) %>%
  #   mutate(wday_no = wday(.timevar, week_start = week_start)) %>%
  #   mutate(wday_abbr = wday(.timevar, label = TRUE, week_start = week_start)) %>%
  #   mutate(n = ifelse(n == 0, NA, n))

  .data$year <- year(.data$.timevar)
  .data$month <- month(.data$.timevar, label = TRUE)
  .data$week_no <- as.factor(week_number(.data$.timevar, week_start = week_start))
  .data$wday_no <- wday(.data$.timevar, week_start = week_start)
  .data$wday_abbr <- wday(.data$.timevar, label = TRUE, week_start = week_start)
  # .data$n <- ifelse(.data$n == 0, NA, .data$n)
  

  # Create the heatmap plot
  plot_heat <- function(.data, week_no="week_no", wday_abbr="wday_abbr"){
    ggplot(.data, aes(week_no, wday_abbr, fill = n)) +
      geom_tile(colour = "white") +
      facet_grid(year ~ month) +
      scale_fill_gradient(low = "red", high = "yellow", na.value = "transparent") + # limits = c(1,max(plot_data$n))
      labs(x = "\nWeek number of Month", y = "Day number") +
      theme_bw() +
      theme(
        panel.grid.major = element_line(linewidth = .05),
        plot.margin = unit(c(0.35, 0.2, 0.3, 0.35), "cm"),
        legend.position = "top"
      )
  }

  plot_heat(.data)
}
