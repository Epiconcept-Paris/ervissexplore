# Get ERVISS ILI/ARI consultation rates data

Retrieves and filters ILI (Influenza-Like Illness) and ARI (Acute
Respiratory Infection) consultation rates from the ERVISS (European
Respiratory Virus Surveillance Summary) for a specified date range,
indicator(s), age group(s), and country(ies).

## Usage

``` r
get_ili_ari_rates(
  csv_file = NULL,
  date_min,
  date_max,
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

- indicator:

  Character vector of indicators to filter: "ILIconsultationrate",
  "ARIconsultationrate", or both. Use "" (default) to include all
  indicators.

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

A data.table containing the filtered ILI/ARI rates data with columns:
survtype, countryname, date, indicator, age, value.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get ILI consultation rates for France
data <- get_ili_ari_rates(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  indicator = "ILIconsultationrate",
  countries = "France"
)

# Get both ILI and ARI rates for all countries
data <- get_ili_ari_rates(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31")
)
} # }
```
