# Get ERVISS non-sentinel severity data

Retrieves and filters non-sentinel severity data (deaths, hospital
admissions, ICU admissions, etc.) from the ERVISS (European Respiratory
Virus Surveillance Summary) for a specified date range, pathogen(s),
indicator(s), age group(s), and country(ies).

## Usage

``` r
get_nonsentinel_severity(
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

  Character vector of indicators to filter: "deaths",
  "hospitaladmissions", "ICUadmissions", "ICUinpatients",
  "hospitalinpatients", or any combination. Use "" (default) to include
  all indicators.

- age:

  Character vector of age groups to filter (e.g., "0-4", "5-14",
  "15-64", "65+", "total"). Use "" (default) to include all age groups.

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

A data.table containing the filtered severity data with columns:
survtype, countryname, date, pathogen, pathogentype, indicator, age,
value.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get hospital admissions for SARS-CoV-2 in France
data <- get_nonsentinel_severity(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  pathogen = "SARS-CoV-2",
  indicator = "hospitaladmissions",
  countries = "France"
)

# Get all severity indicators
data <- get_nonsentinel_severity(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  pathogen = "SARS-CoV-2"
)
} # }
```
