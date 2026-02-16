# Get ERVISS SARI rates data

Retrieves and filters SARI (Severe Acute Respiratory Infection) rates
from the ERVISS (European Respiratory Virus Surveillance Summary) for a
specified date range, age group(s), and country(ies).

## Usage

``` r
get_sari_rates(
  csv_file = NULL,
  date_min,
  date_max,
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

A data.table containing the filtered SARI rates data with columns:
survtype, countryname, date, indicator, age, value.

## Examples

``` r
# \donttest{
# Get SARI rates for Spain
data <- get_sari_rates(
  date_min = as.Date("2025-01-01"),
  date_max = as.Date("2025-12-31"),
  countries = "Spain"
)

# Get SARI rates for specific age groups
data <- get_sari_rates(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  age = c("0-4", "65+")
)
# }
```
