# Getting Started with ervissexplore

## Introduction

The `ervissexplore` package makes it easy to retrieve ERVISS (European
Respiratory Virus Surveillance Summary) data from the EU-ECDC. It
provides functions to fetch and filter data, plus optional visualization
tools.

The package works with two data sources from the [EU-ECDC Respiratory
Viruses Weekly
Data](https://github.com/EU-ECDC/Respiratory_viruses_weekly_data)
repository:

- **Positivity data** (`sentinelTestsDetectionsPositivity.csv`): Test
  positivity rates by pathogen and country
- **Variants data** (`variants.csv`): SARS-CoV-2 variant proportions by
  country

``` r
library(ervissexplore)
```

## Retrieving Positivity Data

Positivity data comes from the `sentinelTestsDetectionsPositivity.csv`
file.

### Basic usage

Use
[`get_sentineltests_positivity()`](../reference/get_sentineltests_positivity.md)
to fetch positivity data:

``` r
# Get SARS-CoV-2 positivity data for specific countries
data <- get_sentineltests_positivity(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  pathogen = "SARS-CoV-2",
  countries = c("France", "Germany", "Italy", "Spain")
)

# Explore the data
head(data)
str(data)
```

### Using a historical snapshot

For reproducible analyses, you can fetch data from a specific snapshot:

``` r
data <- get_sentineltests_positivity(
  date_min = as.Date("2023-01-01"),
  date_max = as.Date("2023-12-31"),
  pathogen = "Influenza",
  use_snapshot = TRUE,
  snapshot_date = as.Date("2024-02-23")
)
```

## Retrieving Variant Data

Variant data comes from the `variants.csv` file.

### Basic usage

Use [`get_erviss_variants()`](../reference/get_erviss_variants.md) to
fetch SARS-CoV-2 variant data:

``` r
# Get specific variants
data <- get_erviss_variants(
  date_min = as.Date("2024-06-01"),
  date_max = as.Date("2024-12-31"),
  variant = c("XFG", "LP.8.1", "BA.2.86"),
  countries = c("Belgium", "Denmark", "France")
)

# Get all variants with minimum proportion threshold
data <- get_erviss_variants(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  min_value = 5 # Only variants with >= 5% proportion
)
```

## Analyzing the Data

The data is returned as a `data.table`, which you can analyze with
data.table syntax:

``` r
# Get positivity data (returns a data.table)
data <- get_sentineltests_positivity(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-06-30"),
  pathogen = "SARS-CoV-2"
)

# Calculate summary statistics by country
data[,
  .(
    mean_positivity = mean(value, na.rm = TRUE),
    max_positivity = max(value, na.rm = TRUE),
    n_weeks = .N
  ),
  by = countryname
]
```

## Visualization (Optional)

The package provides optional visualization functions for quick
exploration.

### Using plot functions

``` r
# Get data first
data <- get_sentineltests_positivity(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-06-30"),
  pathogen = "SARS-CoV-2",
  countries = c("France", "Germany")
)

# Then plot
plot_erviss_positivity(data, date_breaks = "1 month")
```

### Quick plotting

For a quick visualization without saving the data:

``` r
quick_plot_erviss_positivity(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  pathogen = "SARS-CoV-2",
  countries = c("France", "Germany", "Italy"),
  date_breaks = "1 month",
  date_format = "%b %Y"
)

quick_plot_erviss_variants(
  date_min = as.Date("2025-06-01"),
  date_max = as.Date("2025-12-31"),
  variant = c("XFG", "LP.8.1"),
  date_breaks = "1 month",
  countries = c("Belgium", "Denmark", "France")
)
```

### Custom ggplot2 visualizations

You can also create your own visualizations:

``` r
library(ggplot2)

data <- get_sentineltests_positivity(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-06-30"),
  pathogen = "SARS-CoV-2"
)

ggplot(data, aes(x = date, y = value, color = countryname)) +
  geom_line(linewidth = 1) +
  labs(
    title = "SARS-CoV-2 Positivity Rates",
    x = "Date",
    y = "Positivity (%)",
    color = "Country"
  ) +
  theme_minimal()
```

## URL Helpers

You can retrieve the data URLs directly if you prefer to download files
manually:

``` r
# Latest data URLs
get_sentineltests_positivity_url()
#> [1] "https://raw.githubusercontent.com/EU-ECDC/Respiratory_viruses_weekly_data/refs/heads/main/data/sentinelTestsDetectionsPositivity.csv"
get_erviss_variants_url()
#> [1] "https://raw.githubusercontent.com/EU-ECDC/Respiratory_viruses_weekly_data/refs/heads/main/data/variants.csv"

# Snapshot URLs
get_sentineltests_positivity_url(
  use_snapshot = TRUE,
  snapshot_date = as.Date("2023-11-24")
)
#> [1] "https://raw.githubusercontent.com/EU-ECDC/Respiratory_viruses_weekly_data/refs/heads/main/data/snapshots/2023-11-24_sentinelTestsDetectionsPositivity.csv"
get_erviss_variants_url(
  use_snapshot = TRUE,
  snapshot_date = as.Date("2023-11-24")
)
#> [1] "https://raw.githubusercontent.com/EU-ECDC/Respiratory_viruses_weekly_data/refs/heads/main/data/snapshots/2023-11-24_variants.csv"
```

## Complete Example

Here’s a complete workflow for analyzing variant data:

``` r
library(ervissexplore)

# 1. Define parameters
countries <- c("France", "Germany", "Italy", "Spain", "Belgium")
start_date <- as.Date("2024-06-01")
end_date <- as.Date("2024-12-31")

# 2. Retrieve data
variant_data <- get_erviss_variants(
  date_min = start_date,
  date_max = end_date,
  countries = countries,
  min_value = 1
)

# 3. Explore the data
cat("Number of observations:", nrow(variant_data), "\n")
cat("Countries:", unique(variant_data$countryname), "\n")
cat("Variants:", unique(variant_data$variant), "\n")

# 4. Find the dominant variants (data.table syntax)
dominant <- variant_data[, .(mean_proportion = mean(value)), by = variant][
  order(-mean_proportion)
][1:5]

print(dominant)

# 5. Visualize top variants
top_variants <- dominant$variant

quick_plot_erviss_variants(
  date_min = start_date,
  date_max = end_date,
  variant = top_variants,
  countries = countries,
  date_breaks = "1 month",
  min_value = 1
)
```

## Session Info

``` r
sessionInfo()
#> R version 4.5.2 (2025-10-31)
#> Platform: x86_64-pc-linux-gnu
#> Running under: Ubuntu 24.04.3 LTS
#> 
#> Matrix products: default
#> BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
#> LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0
#> 
#> locale:
#>  [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
#>  [4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
#>  [7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
#> [10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   
#> 
#> time zone: UTC
#> tzcode source: system (glibc)
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#> [1] ervissexplore_0.0.0.9000
#> 
#> loaded via a namespace (and not attached):
#>  [1] vctrs_0.7.1         cli_3.6.5           knitr_1.51         
#>  [4] rlang_1.1.7         xfun_0.56           S7_0.2.1           
#>  [7] textshaping_1.0.4   jsonlite_2.0.0      data.table_1.18.2.1
#> [10] glue_1.8.0          htmltools_0.5.9     ragg_1.5.0         
#> [13] sass_0.4.10         scales_1.4.0        rmarkdown_2.30     
#> [16] grid_4.5.2          evaluate_1.0.5      jquerylib_0.1.4    
#> [19] fastmap_1.2.0       yaml_2.3.12         lifecycle_1.0.5    
#> [22] compiler_4.5.2      RColorBrewer_1.1-3  fs_1.6.6           
#> [25] farver_2.1.2        systemfonts_1.3.1   digest_0.6.39      
#> [28] R6_2.6.1            bslib_0.10.0        tools_4.5.2        
#> [31] gtable_0.3.6        pkgdown_2.2.0       ggplot2_4.0.2      
#> [34] cachem_1.1.0        desc_1.4.3
```
