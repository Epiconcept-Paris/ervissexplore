fixture_path <- test_path("fixtures", "sentinel_positivity.csv")

test_that("get_sentineltests_positivity reads data and returns data.table", {
  result <- get_sentineltests_positivity(
    csv_file = fixture_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31")
  )
  expect_s3_class(result, "data.table")
  expect_true(nrow(result) > 0)
  expect_true("date" %in% names(result))
  expect_true("value" %in% names(result))
  expect_true("pathogen" %in% names(result))
  expect_true("countryname" %in% names(result))
  expect_true("indicator" %in% names(result))
})

test_that("get_sentineltests_positivity filters by pathogen", {
  result <- get_sentineltests_positivity(
    csv_file = fixture_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    pathogen = "SARS-CoV-2"
  )
  expect_true(all(result$pathogen == "SARS-CoV-2"))
})

test_that("get_sentineltests_positivity filters by multiple pathogens", {
  result <- get_sentineltests_positivity(
    csv_file = fixture_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    pathogen = c("SARS-CoV-2", "RSV")
  )
  expect_true(all(result$pathogen %in% c("SARS-CoV-2", "RSV")))
})

test_that("get_sentineltests_positivity filters by indicator", {
  result <- get_sentineltests_positivity(
    csv_file = fixture_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    indicator = "detections"
  )
  expect_true(all(result$indicator == "detections"))
})

test_that("get_sentineltests_positivity filters by countries", {
  result <- get_sentineltests_positivity(
    csv_file = fixture_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    countries = "France"
  )
  expect_true(all(result$countryname == "France"))
})

test_that("get_sentineltests_positivity filters by date range", {
  result <- get_sentineltests_positivity(
    csv_file = fixture_path,
    date_min = as.Date("2024-01-08"),
    date_max = as.Date("2024-01-14")
  )
  expect_true(all(result$date >= as.Date("2024-01-08")))
  expect_true(all(result$date <= as.Date("2024-01-14")))
})

test_that("get_sentineltests_positivity returns empty for out-of-range dates", {
  expect_message(
    result <- get_sentineltests_positivity(
      csv_file = fixture_path,
      date_min = as.Date("2020-01-01"),
      date_max = as.Date("2020-12-31")
    ),
    "No data found"
  )
  expect_equal(nrow(result), 0)
})

test_that("get_sentineltests_positivity combines filters", {
  result <- get_sentineltests_positivity(
    csv_file = fixture_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    pathogen = "SARS-CoV-2",
    indicator = "positivity",
    countries = "France"
  )
  expect_true(all(result$pathogen == "SARS-CoV-2"))
  expect_true(all(result$indicator == "positivity"))
  expect_true(all(result$countryname == "France"))
})

test_that("get_sentineltests_positivity rejects invalid indicator", {
  expect_error(
    get_sentineltests_positivity(
      csv_file = fixture_path,
      date_min = as.Date("2024-01-01"),
      date_max = as.Date("2024-12-31"),
      indicator = "invalid_indicator"
    ),
    "Invalid value"
  )
})

test_that("get_sentineltests_positivity rejects non-Date date_min", {
  expect_error(
    get_sentineltests_positivity(
      csv_file = fixture_path,
      date_min = "2024-01-01",
      date_max = as.Date("2024-12-31")
    ),
    "must be a Date object"
  )
})

test_that("get_sentineltests_positivity rejects non-Date date_max", {
  expect_error(
    get_sentineltests_positivity(
      csv_file = fixture_path,
      date_min = as.Date("2024-01-01"),
      date_max = "2024-12-31"
    ),
    "must be a Date object"
  )
})

test_that("get_sentineltests_positivity converts yearweek to date correctly", {
  result <- get_sentineltests_positivity(
    csv_file = fixture_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31")
  )
  expect_s3_class(result$date, "Date")
  # All dates should be Mondays
  weekdays_num <- as.numeric(format(result$date, "%u"))
  expect_true(all(weekdays_num == 1))
})

test_that("get_sentineltests_positivity default pathogen includes all", {
  all_data <- get_sentineltests_positivity(
    csv_file = fixture_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31")
  )
  expect_true(length(unique(all_data$pathogen)) > 1)
})
