#' Get ERVISS non-sentinel severity data
#'
#' Retrieves and filters non-sentinel severity data (deaths, hospital admissions,
#' ICU admissions, etc.) from the ERVISS (European Respiratory Virus Surveillance
#' Summary) for a specified date range, pathogen(s), indicator(s), age group(s),
#' and country(ies).
#'
#' @param csv_file Path to a local CSV file or URL containing the ERVISS data.
#'   If NULL (default), data is fetched from the official ERVISS repository.
#' @param date_min Start date of the period (Date object)
#' @param date_max End date of the period (Date object)
#' @param pathogen Character vector of pathogen names to filter.
#'   Use "" (default) to include all pathogens.
#' @param indicator Character vector of indicators to filter:
#'   "deaths", "hospitaladmissions", "ICUadmissions", "ICUinpatients",
#'   "hospitalinpatients", or any combination.
#'   Use "" (default) to include all indicators.
#' @param age Character vector of age groups to filter (e.g., "0-4", "5-14",
#'   "15-64", "65+", "total").
#'   Use "" (default) to include all age groups.
#' @param countries Character vector of country names to filter.
#'   Use "" (default) to include all countries.
#' @param use_snapshot Logical. If TRUE, fetches a historical snapshot; if FALSE (default),
#'   fetches the latest data. Ignored if csv_file is provided.
#' @param snapshot_date Date of the snapshot to retrieve.
#'   Required if use_snapshot = TRUE and csv_file is NULL.
#'
#' @return A data.table containing the filtered severity data with columns:
#'   survtype, countryname, date, pathogen, pathogentype, indicator, age, value.
#'
#' @export
#' @examples
#' \dontrun{
#' # Get hospital admissions for SARS-CoV-2 in France
#' data <- get_nonsentinel_severity(
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-12-31"),
#'   pathogen = "SARS-CoV-2",
#'   indicator = "hospitaladmissions",
#'   countries = "France"
#' )
#'
#' # Get all severity indicators
#' data <- get_nonsentinel_severity(
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-12-31"),
#'   pathogen = "SARS-CoV-2"
#' )
#' }
get_nonsentinel_severity <- function(
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
    csv_file <- get_nonsentinel_severity_url(use_snapshot, snapshot_date)
  }
  assert_file_or_url(csv_file, "csv_file")
  assert_date(date_min, "date_min")
  assert_date(date_max, "date_max")

  if (any(indicator != "")) {
    assert_indicator(
      indicator,
      c(
        "deaths",
        "hospitaladmissions",
        "ICUadmissions",
        "ICUinpatients",
        "hospitalinpatients"
      )
    )
  }

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

  result <- dt[date >= date_min & date <= date_max]

  warn_if_empty(result)
}

#' Plot ERVISS non-sentinel severity data
#'
#' Creates a ggplot2 visualization of non-sentinel severity data, with facets
#' by country and colored by pathogen.
#'
#' @param data A data.table or data.frame containing severity data, typically
#'   output from \code{\link{get_nonsentinel_severity}}. Must contain columns:
#'   date, value, pathogen, countryname.
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
#' data <- get_nonsentinel_severity(
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-06-30"),
#'   pathogen = "SARS-CoV-2",
#'   indicator = "hospitaladmissions"
#' )
#' plot_nonsentinel_severity(data, date_breaks = "1 month")
#' }
plot_nonsentinel_severity <- function(
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

#' Quick plot of ERVISS non-sentinel severity data
#'
#' Convenience function that fetches and plots ERVISS non-sentinel severity
#' data in one step.
#' For more control, use \code{\link{get_nonsentinel_severity}} followed by
#' \code{\link{plot_nonsentinel_severity}}.
#'
#' @inheritParams get_nonsentinel_severity
#' @inheritParams plot_nonsentinel_severity
#'
#' @return A ggplot2 object showing severity data over time by country
#'   and pathogen
#'
#' @import ggplot2
#' @import data.table
#' @export
#' @examples
#' \dontrun{
#' # Quick visualization of hospital admissions
#' quick_plot_nonsentinel_severity(
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-12-31"),
#'   pathogen = "SARS-CoV-2",
#'   indicator = "hospitaladmissions",
#'   date_breaks = "1 month"
#' )
#' }
quick_plot_nonsentinel_severity <- function(
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
  data <- get_nonsentinel_severity(
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

  plot_nonsentinel_severity(data, date_breaks, date_format)
}
