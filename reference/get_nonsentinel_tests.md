# Get ERVISS non-sentinel tests/detections data

Retrieves and filters non-sentinel virological testing data (tests and
detections) from the ERVISS (European Respiratory Virus Surveillance
Summary) for a specified date range, pathogen(s), indicator(s), age
group(s), and country(ies).

## Usage

``` r
get_nonsentinel_tests(
  csv_file = NULL,
  date_min,
  date_max,
  pathogen = "",
  indicator = "",
  age = "",
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

  Character vector of indicators to filter: "detections", "tests", or
  both. Use "" (default) to include all indicators.

- age:

  Character vector of age groups to filter (e.g., "total"). Use ""
  (default) to include all age groups.

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

A data.table containing the filtered non-sentinel tests data with
columns: survtype, countryname, date, pathogen, pathogentype,
pathogensubtype, indicator, age, value.

## Examples

``` r
# \donttest{
# Get non-sentinel detections for Influenza in France
data <- get_nonsentinel_tests(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  pathogen = "Influenza",
  indicator = "detections",
  countries = "France"
)

# Get all non-sentinel test data
data <- get_nonsentinel_tests(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31")
)
# }
```
