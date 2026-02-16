#' Get ERVISS SARI rates data
#'
#' Retrieves and filters SARI (Severe Acute Respiratory Infection) rates from the
#' ERVISS (European Respiratory Virus Surveillance Summary) for a specified date
#' range, age group(s), and country(ies).
#'
#' @param csv_file Path to a local CSV file or URL containing the ERVISS data.
#'   If NULL (default), data is fetched from the official ERVISS repository.
#' @param date_min Start date of the period (Date object)
#' @param date_max End date of the period (Date object)
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
#' @return A data.table containing the filtered SARI rates data with columns:
#'   survtype, countryname, date, indicator, age, value.
#'
#' @export
#' @examples
#' \donttest{
#' # Get SARI rates for Spain
#' data <- get_sari_rates(
#'   date_min = as.Date("2025-01-01"),
#'   date_max = as.Date("2025-12-31"),
#'   countries = "Spain"
#' )
#'
#' # Get SARI rates for specific age groups
#' data <- get_sari_rates(
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-12-31"),
#'   age = c("0-4", "65+")
#' )
#' }
get_sari_rates <- function(
  csv_file = NULL,
  date_min,
  date_max,
  age = "",
  countries = "",
  use_snapshot = FALSE,
  snapshot_date = NULL
) {
  if (is.null(csv_file)) {
    csv_file <- get_sari_rates_url(use_snapshot, snapshot_date)
  }
  assert_file_or_url(csv_file, "csv_file")
  assert_date(date_min, "date_min")
  assert_date(date_max, "date_max")

  dt <- safe_download_csv(csv_file)
  dt[, date := yearweek_to_date(yearweek)]

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

#' Plot ERVISS SARI rates data
#'
#' Creates a ggplot2 visualization of SARI rates, with facets by country
#' and colored by age group.
#'
#' @param data A data.table or data.frame containing SARI rates data, typically
#'   output from \code{\link{get_sari_rates}}. Must contain columns: date, value,
#'   age, countryname.
#' @param date_breaks A string specifying the date breaks for the x-axis
#'   (e.g., "1 month", "2 weeks")
#' @param date_format A string specifying the date format for x-axis labels
#'   (e.g., `"%b %Y"` for "Jan 2024")
#'
#' @return A ggplot2 object
#'
#' @export
#' @examples
#' \donttest{
#' data <- get_sari_rates(
#'   date_min = as.Date("2025-01-01"),
#'   date_max = as.Date("2025-06-30"),
#'   countries = "Spain"
#' )
#' plot_sari_rates(data, date_breaks = "1 month")
#' }
plot_sari_rates <- function(
  data,
  date_breaks = "2 weeks",
  date_format = "%b %Y"
) {
  ggplot(data, aes(x = date, y = value, color = age)) +
    geom_line() +
    xlab("") +
    ylab("SARI rate") +
    facet_wrap(~countryname, scales = "free", ncol = 3) +
    scale_x_date(date_breaks = date_breaks, date_labels = date_format) +
    scale_colour_viridis_d(name = "Age group") +
    theme_erviss()
}

#' Quick plot of ERVISS SARI rates data
#'
#' Convenience function that fetches and plots ERVISS SARI rates data in one step.
#' For more control, use \code{\link{get_sari_rates}} followed by
#' \code{\link{plot_sari_rates}}.
#'
#' @inheritParams get_sari_rates
#' @inheritParams plot_sari_rates
#'
#' @return A ggplot2 object showing SARI rates over time by country and age group
#'
#' @import ggplot2
#' @import data.table
#' @export
#' @examples
#' \donttest{
#' # Quick visualization of SARI rates
#' quick_plot_sari_rates(
#'   date_min = as.Date("2025-01-01"),
#'   date_max = as.Date("2025-12-31"),
#'   countries = "Spain",
#'   date_breaks = "1 month"
#' )
#' }
quick_plot_sari_rates <- function(
  csv_file = NULL,
  date_min,
  date_max,
  age = "",
  countries = "",
  date_breaks = "2 weeks",
  date_format = "%b %Y",
  use_snapshot = FALSE,
  snapshot_date = NULL
) {
  data <- get_sari_rates(
    csv_file,
    date_min,
    date_max,
    age,
    countries,
    use_snapshot,
    snapshot_date
  )

  plot_sari_rates(data, date_breaks, date_format)
}
