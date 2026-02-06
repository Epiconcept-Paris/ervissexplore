# Get ERVISS sentinel tests data

Retrieves and filters sentinel surveillance data (positivity,
detections, tests) from the ERVISS (European Respiratory Virus
Surveillance Summary) for a specified date range, pathogen(s),
indicator(s), and country(ies).

## Usage

``` r
get_sentineltests_positivity(
  csv_file = NULL,
  date_min,
  date_max,
  pathogen = "",
  indicator = "",
  countries = "",
  use_snapshot = FALSE,
  snapshot_date = NULL
)
```

## Arguments

- csv_file:

  Path to a local CSV file or URL containing the ERVISS data. If NULL
  (default), data is fetched from the official ERVISS repository.

- date_min:

  Start date of the period (Date object)

- date_max:

  End date of the period (Date object)

- pathogen:

  Character vector of pathogen names to filter. Use "" (default) to
  include all pathogens.

- indicator:

  Character vector of indicators to filter: "positivity", "detections",
  "tests", or any combination. Use "" (default) to include all
  indicators.

- countries:

  Character vector of country names to filter. Use "" (default) to
  include all countries.

- use_snapshot:

  Logical. If TRUE, fetches a historical snapshot; if FALSE (default),
  fetches the latest data. Ignored if csv_file is provided.

- snapshot_date:

  Date of the snapshot to retrieve. Required if use_snapshot = TRUE and
  csv_file is NULL.

## Value

A data.table containing the filtered data with columns: date, value,
pathogen, countryname, indicator, and other ERVISS fields.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get latest SARS-CoV-2 positivity data for France
data <- get_sentineltests_positivity(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  pathogen = "SARS-CoV-2",
  countries = "France"
)

# Get detections and tests
data <- get_sentineltests_positivity(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  pathogen = "Influenza",
  indicator = c("detections", "tests")
)

# Get historical data from a specific snapshot
data <- get_sentineltests_positivity(
  date_min = as.Date("2023-01-01"),
  date_max = as.Date("2023-12-31"),
  use_snapshot = TRUE,
  snapshot_date = as.Date("2024-02-23")
)
} # }
```
