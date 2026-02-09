severity_path <- test_path("fixtures", "nonsentinel_severity.csv")
tests_path <- test_path("fixtures", "nonsentinel_tests.csv")

# --- Non-sentinel severity ---

test_that("get_nonsentinel_severity reads data and returns data.table", {
  result <- get_nonsentinel_severity(
    csv_file = severity_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31")
  )
  expect_s3_class(result, "data.table")
  expect_true(nrow(result) > 0)
  expect_true("pathogen" %in% names(result))
  expect_true("indicator" %in% names(result))
  expect_true("age" %in% names(result))
})

test_that("get_nonsentinel_severity filters by pathogen", {
  result <- get_nonsentinel_severity(
    csv_file = severity_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    pathogen = "Influenza"
  )
  expect_true(all(result$pathogen == "Influenza"))
})

test_that("get_nonsentinel_severity filters by indicator", {
  result <- get_nonsentinel_severity(
    csv_file = severity_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    indicator = "hospitaladmissions"
  )
  expect_true(all(result$indicator == "hospitaladmissions"))
})

test_that("get_nonsentinel_severity filters by age", {
  result <- get_nonsentinel_severity(
    csv_file = severity_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    age = "65+"
  )
  expect_true(all(result$age == "65+"))
})

test_that("get_nonsentinel_severity filters by countries", {
  result <- get_nonsentinel_severity(
    csv_file = severity_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    countries = "Germany"
  )
  expect_true(all(result$countryname == "Germany"))
})

test_that("get_nonsentinel_severity accepts all valid indicators", {
  for (ind in c("deaths", "hospitaladmissions", "ICUadmissions",
                "ICUinpatients", "hospitalinpatients")) {
    expect_no_error(
      get_nonsentinel_severity(
        csv_file = severity_path,
        date_min = as.Date("2024-01-01"),
        date_max = as.Date("2024-12-31"),
        indicator = ind
      )
    )
  }
})

test_that("get_nonsentinel_severity rejects invalid indicator", {
  expect_error(
    get_nonsentinel_severity(
      csv_file = severity_path,
      date_min = as.Date("2024-01-01"),
      date_max = as.Date("2024-12-31"),
      indicator = "positivity"
    ),
    "Invalid value"
  )
})

test_that("get_nonsentinel_severity combines all filters", {
  result <- get_nonsentinel_severity(
    csv_file = severity_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    pathogen = "SARS-CoV-2",
    indicator = "hospitaladmissions",
    age = "total",
    countries = "France"
  )
  expect_true(all(result$pathogen == "SARS-CoV-2"))
  expect_true(all(result$indicator == "hospitaladmissions"))
  expect_true(all(result$age == "total"))
  expect_true(all(result$countryname == "France"))
})

# --- Non-sentinel tests ---

test_that("get_nonsentinel_tests reads data and returns data.table", {
  result <- get_nonsentinel_tests(
    csv_file = tests_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31")
  )
  expect_s3_class(result, "data.table")
  expect_true(nrow(result) > 0)
  expect_true("pathogen" %in% names(result))
  expect_true("indicator" %in% names(result))
})

test_that("get_nonsentinel_tests filters by pathogen", {
  result <- get_nonsentinel_tests(
    csv_file = tests_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    pathogen = "SARS-CoV-2"
  )
  expect_true(all(result$pathogen == "SARS-CoV-2"))
})

test_that("get_nonsentinel_tests filters by indicator", {
  result <- get_nonsentinel_tests(
    csv_file = tests_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    indicator = "detections"
  )
  expect_true(all(result$indicator == "detections"))
})

test_that("get_nonsentinel_tests filters by age", {
  result <- get_nonsentinel_tests(
    csv_file = tests_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    age = "0-4"
  )
  expect_true(all(result$age == "0-4"))
})

test_that("get_nonsentinel_tests filters by countries", {
  result <- get_nonsentinel_tests(
    csv_file = tests_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    countries = "France"
  )
  expect_true(all(result$countryname == "France"))
})

test_that("get_nonsentinel_tests rejects invalid indicator", {
  expect_error(
    get_nonsentinel_tests(
      csv_file = tests_path,
      date_min = as.Date("2024-01-01"),
      date_max = as.Date("2024-12-31"),
      indicator = "positivity"
    ),
    "Invalid value"
  )
})

test_that("get_nonsentinel_tests returns empty for out-of-range dates", {
  expect_message(
    result <- get_nonsentinel_tests(
      csv_file = tests_path,
      date_min = as.Date("2020-01-01"),
      date_max = as.Date("2020-12-31")
    ),
    "No data found"
  )
  expect_equal(nrow(result), 0)
})
