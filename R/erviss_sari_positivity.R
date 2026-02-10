#' Get ERVISS SARI tests/detections/positivity data
#'
#' Retrieves and filters SARI (Severe Acute Respiratory Infection) virological
#' data (tests, detections, positivity) from the ERVISS (European Respiratory
#' Virus Surveillance Summary) for a specified date range, pathogen(s),
#' indicator(s), age group(s), and country(ies).
#'
#' @param csv_file Path to a local CSV file or URL containing the ERVISS data.
#'   If NULL (default), data is fetched from the official ERVISS repository.
#' @param date_min Start date of the period (Date object)
#' @param date_max End date of the period (Date object)
#' @param pathogen Character vector of pathogen names to filter.
#'   Use "" (default) to include all pathogens.
#' @param indicator Character vector of indicators to filter:
#'   "positivity", "detections", "tests", or any combination.
#'   Use "" (default) to include all indicators.
#' @param age Character vector of age groups to filter (e.g., "total", "0-4",
#'   "5-14", "15-64", "65+").
#'   Use "" (default) to include all age groups.
#' @param countries Character vector of country names to filter.
#'   Use "" (default) to include all countries.
#' @param use_snapshot Logical. If TRUE, fetches a historical snapshot; if FALSE (default),
#'   fetches the latest data. Ignored if csv_file is provided.
#' @param snapshot_date Date of the snapshot to retrieve.
#'   Required if use_snapshot = TRUE and csv_file is NULL.
#'
#' @return A data.table containing the filtered SARI data with columns:
#'   survtype, countryname, date, pathogen, pathogentype, pathogensubtype,
#'   indicator, age, value.
#'
#' @export
#' @examples
#' \dontrun{
#' # Get SARI positivity data for Influenza in France
#' data <- get_sari_positivity(
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-12-31"),
#'   pathogen = "Influenza",
#'   indicator = "positivity",
#'   countries = "France"
#' )
#'
#' # Get all SARI indicators for SARS-CoV-2
#' data <- get_sari_positivity(
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-12-31"),
#'   pathogen = "SARS-CoV-2"
#' )
#' }
get_sari_positivity <- function(
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
    csv_file <- get_sari_positivity_url(use_snapshot, snapshot_date)
  }
  assert_file_or_url(csv_file, "csv_file")
  assert_date(date_min, "date_min")
  assert_date(date_max, "date_max")

  if (any(indicator != "")) {
    assert_indicator(indicator, c("detections", "positivity", "tests"))
  }

  dt <- safe_download_csv(csv_file)
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

#' Plot ERVISS SARI positivity data
#'
#' Creates a ggplot2 visualization of SARI positivity data, with facets
#' by country and colored by pathogen.
#'
#' @param data A data.table or data.frame containing SARI positivity data, typically
#'   output from \code{\link{get_sari_positivity}}. Must contain columns: date, value,
#'   pathogen, countryname.
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
#' data <- get_sari_positivity(
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-06-30"),
#'   pathogen = "Influenza",
#'   indicator = "positivity"
#' )
#' plot_sari_positivity(data, date_breaks = "1 month")
#' }
plot_sari_positivity <- function(
  data,
  date_breaks = "2 weeks",
  date_format = "%b %Y"
) {
  mean_value <- mean(data$value, na.rm = TRUE)
  min_value <- min(data$value, na.rm = TRUE)
  max_value <- max(data$value, na.rm = TRUE)

  ggplot(data, aes(x = date, y = value, color = pathogen)) +
    geom_line() +
    xlab("") +
    ylab("Value") +
    facet_wrap(~countryname, scales = "free", ncol = 3) +
    scale_x_date(date_breaks = date_breaks, date_labels = date_format) +
    scale_colour_viridis_d(name = "Pathogen") +
    theme_erviss() +
    labs(
      title = sprintf(
        "Mean: %.2f (Min %.2f - Max %.2f)",
        mean_value,
        min_value,
        max_value
      )
    )
}

#' Quick plot of ERVISS SARI positivity data
#'
#' Convenience function that fetches and plots ERVISS SARI positivity data
#' in one step.
#' For more control, use \code{\link{get_sari_positivity}} followed by
#' \code{\link{plot_sari_positivity}}.
#'
#' @inheritParams get_sari_positivity
#' @inheritParams plot_sari_positivity
#'
#' @return A ggplot2 object showing SARI positivity over time by country
#'   and pathogen
#'
#' @import ggplot2
#' @import data.table
#' @export
#' @examples
#' \dontrun{
#' # Quick visualization of SARI positivity
#' quick_plot_sari_positivity(
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-12-31"),
#'   pathogen = "Influenza",
#'   indicator = "positivity",
#'   date_breaks = "1 month"
#' )
#' }
quick_plot_sari_positivity <- function(
  csv_file = NULL,
  date_min,
  date_max,
  pathogen = "",
  indicator = "",
  age = "",
  countries = "",
  date_breaks = "2 weeks",
  date_format = "%b %Y",
  use_snapshot = FALSE,
  snapshot_date = NULL
) {
  data <- get_sari_positivity(
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

  plot_sari_positivity(data, date_breaks, date_format)
}
