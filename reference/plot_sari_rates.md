# Plot ERVISS SARI rates data

Creates a ggplot2 visualization of SARI rates, with facets by country
and colored by age group.

## Usage

``` r
plot_sari_rates(data, date_breaks = "2 weeks", date_format = "%b %Y")
```

## Arguments

- data:

  A data.table or data.frame containing SARI rates data, typically
  output from [`get_sari_rates`](get_sari_rates.md). Must contain
  columns: date, value, age, countryname.

- date_breaks:

  A string specifying the date breaks for the x-axis (e.g., "1 month",
  "2 weeks")

- date_format:

  A string specifying the date format for x-axis labels (e.g., `"%b %Y"`
  for "Jan 2024")

## Value

A ggplot2 object

## Examples

``` r
if (FALSE) { # \dontrun{
data <- get_sari_rates(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-06-30"),
  countries = "France"
)
plot_sari_rates(data, date_breaks = "1 month")
} # }
```
