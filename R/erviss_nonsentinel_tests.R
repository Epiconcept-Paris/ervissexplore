#' Get ERVISS non-sentinel tests/detections data
#'
#' Retrieves and filters non-sentinel virological testing data (tests and
#' detections) from the ERVISS (European Respiratory Virus Surveillance Summary)
#' for a specified date range, pathogen(s), indicator(s), age group(s), and
#' country(ies).
#'
#' @param csv_file Path to a local CSV file or URL containing the ERVISS data.
#'   If NULL (default), data is fetched from the official ERVISS repository.
#' @param date_min Start date of the period (Date object)
#' @param date_max End date of the period (Date object)
#' @param pathogen Character vector of pathogen names to filter.
#'   Use "" (default) to include all pathogens.
#' @param indicator Character vector of indicators to filter:
#'   "detections", "tests", or both.
#'   Use "" (default) to include all indicators.
#' @param age Character vector of age groups to filter (e.g., "total").
#'   Use "" (default) to include all age groups.
#' @param countries Character vector of country names to filter.
#'   Use "" (default) to include all countries.
#' @param use_snapshot Logical. If TRUE, fetches a historical snapshot; if FALSE (default),
#'   fetches the latest data. Ignored if csv_file is provided.
#' @param snapshot_date Date of the snapshot to retrieve.
#'   Required if use_snapshot = TRUE and csv_file is NULL.
#'
#' @return A data.table containing the filtered non-sentinel tests data with columns:
#'   survtype, countryname, date, pathogen, pathogentype, pathogensubtype,
#'   indicator, age, value.
#'
#' @export
#' @examples
#' \dontrun{
#' # Get non-sentinel detections for Influenza in France
#' data <- get_nonsentinel_tests(
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-12-31"),
#'   pathogen = "Influenza",
#'   indicator = "detections",
#'   countries = "France"
#' )
#'
#' # Get all non-sentinel test data
#' data <- get_nonsentinel_tests(
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-12-31")
#' )
#' }
get_nonsentinel_tests <- function(
  csv_file = NULL,
  date_min,
  date_max,
  pathogen = "",
  indicator = "",
  age = "",
  countries = "",
  use_snapshot = FALSE,
  snapshot_date = NULL
) {
  if (is.null(csv_file)) {
    csv_file <- get_nonsentinel_tests_url(use_snapshot, snapshot_date)
  }
  assert_file_or_url(csv_file, "csv_file")
  assert_date(date_min, "date_min")
  assert_date(date_max, "date_max")

  dt <- data.table::fread(csv_file)
  dt[, date := yearweek_to_date(yearweek)]

  if (any(pathogen != "")) {
    pathogen_filter <- pathogen
    dt <- dt[pathogen %chin% pathogen_filter]
  }

  if (any(indicator != "")) {
    indicator_filter <- indicator
    dt <- dt[indicator %chin% indicator_filter]
  }

  if (any(age != "")) {
    age_filter <- age
    dt <- dt[age %chin% age_filter]
  }

  if (any(countries != "")) {
    dt <- dt[countryname %chin% countries]
  }

  dt[date >= date_min & date <= date_max]
}

#' Plot ERVISS non-sentinel tests/detections data
#'
#' Creates a ggplot2 visualization of non-sentinel tests/detections data,
#' with facets by country and colored by pathogen.
#'
#' @param data A data.table or data.frame containing non-sentinel tests data,
#'   typically output from \code{\link{get_nonsentinel_tests}}. Must contain
#'   columns: date, value, pathogen, countryname.
#' @param date_breaks A string specifying the date breaks for the x-axis
#'   (e.g., "1 month", "2 weeks")
#' @param date_format A string specifying the date format for x-axis labels
#'   (e.g., `"%b %Y"` for "Jan 2024")
#'
#' @return A ggplot2 object
#'
#' @export
#' @examples
#' \dontrun{
#' data <- get_nonsentinel_tests(
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-06-30"),
#'   pathogen = "Influenza",
#'   indicator = "detections"
#' )
#' plot_nonsentinel_tests(data, date_breaks = "1 month")
#' }
plot_nonsentinel_tests <- function(
  data,
  date_breaks = "1 month",
  date_format = "%b %Y"
) {
  ggplot(data, aes(x = date, y = value, color = pathogen)) +
    geom_line() +
    xlab("") +
    ylab("Count") +
    facet_wrap(~countryname, scales = "free", ncol = 3) +
    scale_x_date(date_breaks = date_breaks, date_labels = date_format) +
    scale_colour_viridis_d(name = "Pathogen") +
    theme_erviss()
}

#' Quick plot of ERVISS non-sentinel tests/detections data
#'
#' Convenience function that fetches and plots ERVISS non-sentinel tests/detections
#' data in one step.
#' For more control, use \code{\link{get_nonsentinel_tests}} followed by
#' \code{\link{plot_nonsentinel_tests}}.
#'
#' @inheritParams get_nonsentinel_tests
#' @inheritParams plot_nonsentinel_tests
#'
#' @return A ggplot2 object showing non-sentinel tests/detections over time
#'   by country and pathogen
#'
#' @import ggplot2
#' @import data.table
#' @export
#' @examples
#' \dontrun{
#' # Quick visualization of non-sentinel detections
#' quick_plot_nonsentinel_tests(
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-12-31"),
#'   pathogen = "Influenza",
#'   indicator = "detections",
#'   date_breaks = "1 month"
#' )
#' }
quick_plot_nonsentinel_tests <- function(
  csv_file = NULL,
  date_min,
  date_max,
  pathogen = "",
  indicator = "",
  age = "",
  countries = "",
  date_breaks = "1 month",
  date_format = "%b %Y",
  use_snapshot = FALSE,
  snapshot_date = NULL
) {
  data <- get_nonsentinel_tests(
    csv_file,
    date_min,
    date_max,
    pathogen,
    indicator,
    age,
    countries,
    use_snapshot,
    snapshot_date
  )

  plot_nonsentinel_tests(data, date_breaks, date_format)
}
