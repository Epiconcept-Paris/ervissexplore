sari_rates_path <- test_path("fixtures", "sari_rates.csv")
sari_positivity_path <- test_path("fixtures", "sari_positivity.csv")

# --- SARI rates ---

test_that("get_sari_rates reads data and returns data.table", {
  result <- get_sari_rates(
    csv_file = sari_rates_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31")
  )
  expect_s3_class(result, "data.table")
  expect_true(nrow(result) > 0)
  expect_true("date" %in% names(result))
  expect_true("age" %in% names(result))
  expect_true("value" %in% names(result))
})

test_that("get_sari_rates filters by age group", {
  result <- get_sari_rates(
    csv_file = sari_rates_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    age = "65+"
  )
  expect_true(all(result$age == "65+"))
})

test_that("get_sari_rates filters by multiple age groups", {
  result <- get_sari_rates(
    csv_file = sari_rates_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    age = c("total", "0-4")
  )
  expect_true(all(result$age %in% c("total", "0-4")))
})

test_that("get_sari_rates filters by countries", {
  result <- get_sari_rates(
    csv_file = sari_rates_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    countries = "France"
  )
  expect_true(all(result$countryname == "France"))
})

test_that("get_sari_rates filters by date range", {
  result <- get_sari_rates(
    csv_file = sari_rates_path,
    date_min = as.Date("2024-01-08"),
    date_max = as.Date("2024-01-14")
  )
  expect_true(all(result$date >= as.Date("2024-01-08")))
  expect_true(all(result$date <= as.Date("2024-01-14")))
})

test_that("get_sari_rates returns empty for out-of-range dates", {
  expect_message(
    result <- get_sari_rates(
      csv_file = sari_rates_path,
      date_min = as.Date("2020-01-01"),
      date_max = as.Date("2020-12-31")
    ),
    "No data found"
  )
  expect_equal(nrow(result), 0)
})

# --- SARI positivity ---

test_that("get_sari_positivity reads data and returns data.table", {
  result <- get_sari_positivity(
    csv_file = sari_positivity_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31")
  )
  expect_s3_class(result, "data.table")
  expect_true(nrow(result) > 0)
  expect_true("pathogen" %in% names(result))
  expect_true("indicator" %in% names(result))
  expect_true("age" %in% names(result))
})

test_that("get_sari_positivity filters by pathogen", {
  result <- get_sari_positivity(
    csv_file = sari_positivity_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    pathogen = "SARS-CoV-2"
  )
  expect_true(all(result$pathogen == "SARS-CoV-2"))
})

test_that("get_sari_positivity filters by indicator", {
  result <- get_sari_positivity(
    csv_file = sari_positivity_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    indicator = "detections"
  )
  expect_true(all(result$indicator == "detections"))
})

test_that("get_sari_positivity filters by age", {
  result <- get_sari_positivity(
    csv_file = sari_positivity_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    age = "0-4"
  )
  expect_true(all(result$age == "0-4"))
})

test_that("get_sari_positivity filters by countries", {
  result <- get_sari_positivity(
    csv_file = sari_positivity_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    countries = "Germany"
  )
  expect_true(all(result$countryname == "Germany"))
})

test_that("get_sari_positivity rejects invalid indicator", {
  expect_error(
    get_sari_positivity(
      csv_file = sari_positivity_path,
      date_min = as.Date("2024-01-01"),
      date_max = as.Date("2024-12-31"),
      indicator = "proportion"
    ),
    "Invalid value"
  )
})

test_that("get_sari_positivity combines all filters", {
  result <- get_sari_positivity(
    csv_file = sari_positivity_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    pathogen = "Influenza",
    indicator = "positivity",
    age = "total",
    countries = "France"
  )
  expect_true(all(result$pathogen == "Influenza"))
  expect_true(all(result$indicator == "positivity"))
  expect_true(all(result$age == "total"))
  expect_true(all(result$countryname == "France"))
})
