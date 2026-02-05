#' Get ERVISS data URL
#'
#' Builds the URL to download ERVISS data, either the latest batch
#' or a specific snapshot.
#'
#' @param type Type of data: "positivity" or "variants"
#' @param use_snapshot Logical. If TRUE, returns a snapshot URL; if FALSE (default),
#'   returns the URL for the latest data.
#' @param snapshot_date Date of the snapshot to retrieve (required if use_snapshot = TRUE).
#'   Must be a Date object.
#'
#' @return A character string containing the URL
#'
#' @export
#' @examples
#' # Get latest positivity data URL
#' get_erviss_url("positivity")
#'
#' # Get latest variants data URL
#' get_erviss_url("variants")
#'
#' # Get snapshot URL
#' get_erviss_url("variants", use_snapshot = TRUE, snapshot_date = as.Date("2023-11-24"))
get_erviss_url <- function(
  type = c("positivity", "variants"),
  use_snapshot = FALSE,
  snapshot_date = NULL
) {
  type <- match.arg(type)

  if (type == "positivity") {
    get_sentineltests_positivity_url(use_snapshot, snapshot_date)
  } else {
    get_erviss_variants_url(use_snapshot, snapshot_date)
  }
}

#' Get ERVISS data
#'
#' Retrieves and filters data from the ERVISS (European Respiratory
#' Virus Surveillance Summary) for a specified date range, pathogen/variant(s),
#' and country(ies). This is a generic function that can retrieve either
#' positivity or variants data.
#'
#' @param type Type of data: "positivity" or "variants"
#' @param csv_file Path to a local CSV file or URL containing the ERVISS data.
#'   If NULL (default), data is fetched from the official ERVISS repository.
#' @param date_min Start date of the period (Date object)
#' @param date_max End date of the period (Date object)
#' @param pathogen Character vector of pathogen names to filter (for type = "positivity").
#'   Use "" (default) to include all pathogens. Ignored if type = "variants".
#' @param variant Character vector of variant names to filter (for type = "variants").
#'   Use "" (default) to include all variants. Ignored if type = "positivity".
#' @param countries Character vector of country names to filter.
#'   Use "" (default) to include all countries.
#' @param min_value Minimum value threshold to include in the results (default: 0).
#'   Only used for type = "variants".
#' @param indicator Type of indicator for variants: "proportion" (default) or "detections".
#'   Only used for type = "variants".
#' @param use_snapshot Logical. If TRUE, fetches a historical snapshot; if FALSE (default),
#'   fetches the latest data. Ignored if csv_file is provided.
#' @param snapshot_date Date of the snapshot to retrieve.
#'   Required if use_snapshot = TRUE and csv_file is NULL.
#'
#' @return A data.table containing the filtered data with columns including:
#'   date, value, countryname, and other ERVISS fields.
#'
#' @export
#' @examples
#' \dontrun{
#' # Get positivity data
#' data <- get_erviss_data(
#'   type = "positivity",
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-12-31"),
#'   pathogen = "SARS-CoV-2",
#'   countries = "France"
#' )
#'
#' # Get variants data
#' data <- get_erviss_data(
#'   type = "variants",
#'   date_min = as.Date("2024-06-01"),
#'   date_max = as.Date("2024-12-31"),
#'   variant = c("XFG", "LP.8.1"),
#'   min_value = 5
#' )
#' }
get_erviss_data <- function(
  type = c("positivity", "variants"),
  csv_file = NULL,
  date_min,
  date_max,
  pathogen = "",
  variant = "",
  countries = "",
  min_value = 0,
  indicator = "proportion",
  use_snapshot = FALSE,
  snapshot_date = NULL
) {
  type <- match.arg(type)

  if (type == "positivity") {
    get_sentineltests_positivity(
      csv_file = csv_file,
      date_min = date_min,
      date_max = date_max,
      pathogen = pathogen,
      countries = countries,
      use_snapshot = use_snapshot,
      snapshot_date = snapshot_date
    )
  } else {
    get_erviss_variants(
      csv_file = csv_file,
      date_min = date_min,
      date_max = date_max,
      variant = variant,
      countries = countries,
      min_value = min_value,
      indicator = indicator,
      use_snapshot = use_snapshot,
      snapshot_date = snapshot_date
    )
  }
}

#' Plot ERVISS data
#'
#' Creates a ggplot2 visualization of ERVISS data, with facets by country.
#' This is a generic function that can plot either positivity or variants data.
#'
#' @param data A data.table or data.frame containing ERVISS data, typically output from
#'   \code{\link{get_erviss_data}}. Must contain columns: date, value, countryname,
#'   and either pathogen or variant.
#' @param type Type of data: "positivity" or "variants". If NULL (default),
#'   the function will attempt to detect the type based on column names.
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
#' # Plot positivity data
#' data <- get_erviss_data(
#'   type = "positivity",
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-06-30"),
#'   pathogen = "SARS-CoV-2"
#' )
#' plot_erviss_data(data)
#'
#' # Plot variants data
#' data <- get_erviss_data(
#'   type = "variants",
#'   date_min = as.Date("2024-06-01"),
#'   date_max = as.Date("2024-12-31"),
#'   variant = c("XFG", "LP.8.1")
#' )
#' plot_erviss_data(data)
#' }
plot_erviss_data <- function(
  data,
  type = NULL,
  date_breaks = NULL,
  date_format = "%b %Y"
) {
  # Auto-detect type if not provided
 if (is.null(type)) {
    if ("pathogen" %in% names(data)) {
      type <- "positivity"
    } else if ("variant" %in% names(data)) {
      type <- "variants"
    } else {
      stop("Cannot auto-detect data type. Please specify 'type' parameter.")
    }
  }

  type <- match.arg(type, c("positivity", "variants"))

  # Set default date_breaks based on type
  if (is.null(date_breaks)) {
    date_breaks <- if (type == "positivity") "2 weeks" else "1 month"
  }

  if (type == "positivity") {
    plot_erviss_positivity(
      data = data,
      date_breaks = date_breaks,
      date_format = date_format
    )
  } else {
    plot_erviss_variants(
      data = data,
      date_breaks = date_breaks,
      date_format = date_format
    )
  }
}

#' Quick plot of ERVISS data
#'
#' Convenience function that fetches and plots ERVISS data in one step.
#' This is a generic function that can handle either positivity or variants data.
#' For more control, use \code{\link{get_erviss_data}} followed by
#' \code{\link{plot_erviss_data}}.
#'
#' @inheritParams get_erviss_data
#' @param date_breaks A string specifying the date breaks for the x-axis
#'   (e.g., "1 month", "2 weeks"). If NULL, defaults to "2 weeks" for positivity
#'   and "1 month" for variants.
#' @param date_format A string specifying the date format for x-axis labels
#'   (e.g., `"%b %Y"` for "Jan 2024")
#'
#' @return A ggplot2 object showing the data over time by country
#'
#' @import ggplot2
#' @import data.table
#' @export
#' @examples
#' \dontrun{
#' # Quick visualization of positivity data
#' quick_plot_erviss_data(
#'   type = "positivity",
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-12-31"),
#'   pathogen = "SARS-CoV-2",
#'   date_breaks = "1 month"
#' )
#'
#' # Quick visualization of variants data
#' quick_plot_erviss_data(
#'   type = "variants",
#'   date_min = as.Date("2024-06-01"),
#'   date_max = as.Date("2024-12-31"),
#'   variant = c("XFG", "LP.8.1")
#' )
#' }
quick_plot_erviss_data <- function(
  type = c("positivity", "variants"),
  csv_file = NULL,
  date_min,
  date_max,
  pathogen = "",
  variant = "",
  countries = "",
  min_value = 0,
  indicator = "proportion",
  date_breaks = NULL,
  date_format = "%b %Y",
  use_snapshot = FALSE,
  snapshot_date = NULL
) {
  type <- match.arg(type)

  data <- get_erviss_data(
    type = type,
    csv_file = csv_file,
    date_min = date_min,
    date_max = date_max,
    pathogen = pathogen,
    variant = variant,
    countries = countries,
    min_value = min_value,
    indicator = indicator,
    use_snapshot = use_snapshot,
    snapshot_date = snapshot_date
  )

  plot_erviss_data(
    data = data,
    type = type,
    date_breaks = date_breaks,
    date_format = date_format
  )
}
