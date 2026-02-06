# Get ERVISS SARI rates data URL

Builds the URL to download ERVISS SARI rates data, either the latest
batch or a specific snapshot.

## Usage

``` r
get_sari_rates_url(use_snapshot = FALSE, snapshot_date = NULL)
```

## Arguments

- use_snapshot:

  Logical. If TRUE, returns a snapshot URL; if FALSE (default), returns
  the URL for the latest data.

- snapshot_date:

  Date of the snapshot to retrieve (required if use_snapshot = TRUE).
  Must be a Date object.

## Value

A character string containing the URL

## Examples

``` r
# Get latest data URL
get_sari_rates_url()
#> [1] "https://raw.githubusercontent.com/EU-ECDC/Respiratory_viruses_weekly_data/refs/heads/main/data/SARIRates.csv"

# Get snapshot URL
get_sari_rates_url(use_snapshot = TRUE, snapshot_date = as.Date("2023-11-24"))
#> [1] "https://raw.githubusercontent.com/EU-ECDC/Respiratory_viruses_weekly_data/refs/heads/main/data/snapshots/2023-11-24_SARIRates.csv"
```
