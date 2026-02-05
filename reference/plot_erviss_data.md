# Plot ERVISS data

Creates a ggplot2 visualization of ERVISS data, with facets by country.
This is a generic function that can plot either positivity or variants
data.

## Usage

``` r
plot_erviss_data(
  data,
  type = NULL,
  date_breaks = NULL,
  date_format = "%b %Y"
)
```

## Arguments

- data:

  A data.table or data.frame containing ERVISS data, typically output
  from [`get_erviss_data`](get_erviss_data.md). Must contain columns:
  date, value, countryname, and either pathogen or variant.

- type:

  Type of data: "positivity" or "variants". If NULL (default), the
  function will attempt to detect the type based on column names.

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
# Plot positivity data
data <- get_erviss_data(
  type = "positivity",
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-06-30"),
  pathogen = "SARS-CoV-2"
)
plot_erviss_data(data)

# Plot variants data
data <- get_erviss_data(
  type = "variants",
  date_min = as.Date("2024-06-01"),
  date_max = as.Date("2024-12-31"),
  variant = c("XFG", "LP.8.1")
)
plot_erviss_data(data)
} # }
```
