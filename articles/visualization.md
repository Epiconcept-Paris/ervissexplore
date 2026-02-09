# Visualization

## Plotting is a bonus, not the core feature

The primary goal of `ervissexplore` is to make it easy to **retrieve and
filter** ERVISS data. The plotting functions are provided as a
convenience for quick exploration, not as a full-featured visualization
framework.

Since the data is returned as a standard `data.table`, you are free to
build any visualization you want using `ggplot2` or any other plotting
library.

``` r
library(ervissexplore)
library(ggplot2)
```

## Built-in plot functions

Each data source has a dedicated `plot_*()` function and a
`quick_plot_*()` shortcut.

### Sentinel test positivity

``` r
data <- get_sentineltests_positivity(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-06-30"),
  pathogen = "SARS-CoV-2",
  countries = c("France", "Germany")
)

plot_erviss_positivity(data, date_breaks = "1 month")
```

### SARS-CoV-2 variants

``` r
data <- get_erviss_variants(
  date_min = as.Date("2025-06-01"),
  date_max = as.Date("2025-12-31"),
  variant = c("XFG"),
  countries = c("France", "Belgium")
)

plot_erviss_variants(data, date_breaks = "1 month")
```

### ILI/ARI consultation rates

``` r
data <- get_ili_ari_rates(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  indicator = "ILIconsultationrate",
  countries = c("France")
)

plot_ili_ari_rates(data, date_breaks = "1 month")
```

### SARI rates

``` r
data <- get_sari_rates(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  countries = c("Belgium")
)

plot_sari_rates(data, date_breaks = "1 month")
```

### SARI virological data

``` r
data <- get_sari_positivity(
  date_min = as.Date("2025-01-01"),
  date_max = as.Date("2025-12-31"),
  pathogen = "Influenza",
  indicator = "positivity",
  countries = c("Belgium")
)

plot_sari_positivity(data, date_breaks = "1 month")
```

### Non-sentinel severity

``` r
data <- get_nonsentinel_severity(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  pathogen = "SARS-CoV-2",
  indicator = "hospitaladmissions",
  countries = c("EU/EEA"),
  age = "total"
)

plot_nonsentinel_severity(data, date_breaks = "1 month")
```

### Non-sentinel tests/detections

``` r
data <- get_nonsentinel_tests(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  pathogen = "Influenza",
  indicator = "detections",
  countries = c("France", "Germany")
)

plot_nonsentinel_tests(data, date_breaks = "1 month")
```

## Quick plot shortcuts

The `quick_plot_*()` functions combine data fetching and plotting in a
single call:

``` r
# One-liner for ILI rates
quick_plot_ili_ari_rates(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  indicator = "ILIconsultationrate",
  countries = c("France"),
  date_breaks = "1 month"
)
```

You can also use the generic
[`quick_plot_erviss_data()`](../reference/quick_plot_erviss_data.md):

``` r
quick_plot_erviss_data(
  type = "nonsentinel_severity",
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  pathogen = "SARS-CoV-2",
  indicator = "hospitaladmissions",
  countries = c("France", "Spain"),
  date_breaks = "1 month"
)
```

## Using the generic `plot_erviss_data()`

The generic function dispatches to the right plot function based on the
`type` parameter:

``` r
data <- get_erviss_data(
  type = "sari_rates",
  date_min = as.Date("2025-01-01"),
  date_max = as.Date("2025-12-31"),
  countries = "Spain"
)

plot_erviss_data(data, type = "sari_rates", date_breaks = "1 month")
```

``` r
data <- get_erviss_data(
  type = "positivity",
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-06-30"),
  pathogen = "SARS-CoV-2",
  countries = "EU/EEA",
  indicator = "positivity"
)

plot_erviss_data(data, type = "positivity")
```

## Customizing plots

All `plot_*()` functions return standard `ggplot2` objects. You can
modify them freely with any `ggplot2` function.

### Changing the theme

``` r
data <- get_sentineltests_positivity(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-06-30"),
  pathogen = "SARS-CoV-2",
  countries = c("France", "Germany")
)

plot_erviss_positivity(data) +
  theme_bw() +
  theme(
    legend.position = "top",
    strip.background = element_rect(fill = "steelblue"),
    strip.text = element_text(color = "white", face = "bold")
  )
```

### Modifying axes

``` r
plot_erviss_positivity(data) +
  scale_x_date(
    date_breaks = "1 month",
    date_labels = "%d/%m/%Y"
  ) +
  scale_y_continuous(
    limits = c(0, 50),
    breaks = seq(0, 50, 10)
  ) +
  ylab("Positivity (%)")
```

### Adding titles and annotations

``` r
plot_erviss_positivity(data) +
  labs(
    title = "My custom title",
    subtitle = "SARS-CoV-2 positivity in France and Germany",
    caption = "Source: ERVISS / EU-ECDC"
  )
```

### Changing colours

``` r
data <- get_ili_ari_rates(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  indicator = "ILIconsultationrate",
  countries = "France"
)

plot_ili_ari_rates(data) +
  scale_colour_brewer(palette = "Set1", name = "Age group")
```

## Building your own plots from scratch

Since the data is a `data.table`, you can bypass the built-in plot
functions entirely and create exactly the visualization you need:

``` r
data <- get_nonsentinel_severity(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  pathogen = "SARS-CoV-2",
  indicator = c("hospitaladmissions", "ICUadmissions"),
  age = "total",
  countries = c("France", "Spain")
)

ggplot(data, aes(x = date, y = value, fill = indicator)) +
  geom_col(position = "dodge") +
  facet_wrap(~countryname, scales = "free_y") +
  scale_fill_manual(
    values = c("hospitaladmissions" = "#E69F00", "ICUadmissions" = "#D55E00"),
    labels = c("Hospital admissions", "ICU admissions"),
    name = ""
  ) +
  labs(
    title = "SARS-CoV-2 severity indicators",
    x = NULL,
    y = "Count",
    caption = "Source: ERVISS / EU-ECDC"
  ) +
  theme_minimal() +
  theme(legend.position = "top")
```

``` r
data <- get_ili_ari_rates(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  indicator = "ILIconsultationrate",
  age = "total",
  countries = c("Spain", "Austria", "Greece")
)

ggplot(data, aes(x = date, y = countryname, fill = value)) +
  geom_tile() +
  scale_fill_viridis_c(name = "ILI rate") +
  scale_x_date(date_breaks = "1 month", date_labels = "%b") +
  labs(title = "ILI consultation rates across Europe", x = NULL, y = NULL) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
```
