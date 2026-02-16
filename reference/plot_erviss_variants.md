# Plot ERVISS variants data

Creates a ggplot2 visualization of variant data, with facets by country
and colored by variant. The y-axis shows percentage of all variants.

## Usage

``` r
plot_erviss_variants(data, date_breaks = "1 month", date_format = "%b %Y")
```

## Arguments

- data:

  A data.table or data.frame containing variant data, typically output
  from [`get_erviss_variants`](get_erviss_variants.md). Must contain
  columns: date, value, variant, countryname.

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
# \donttest{
data <- get_erviss_variants(
  date_min = as.Date("2024-06-01"),
  date_max = as.Date("2024-12-31"),
  variant = c("XFG", "LP.8.1")
)
plot_erviss_variants(data, date_breaks = "1 month")

# }
```
