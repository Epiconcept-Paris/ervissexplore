base_url <- "https://raw.githubusercontent.com/EU-ECDC/Respiratory_viruses_weekly_data/refs/heads/main/data"

# --- Latest URLs ---

test_that("get_sentineltests_positivity_url returns correct latest URL", {
  url <- get_sentineltests_positivity_url()
  expect_equal(url, paste0(base_url, "/sentinelTestsDetectionsPositivity.csv"))
})

test_that("get_erviss_variants_url returns correct latest URL", {
  url <- get_erviss_variants_url()
  expect_equal(url, paste0(base_url, "/variants.csv"))
})

test_that("get_ili_ari_rates_url returns correct latest URL", {
  url <- get_ili_ari_rates_url()
  expect_equal(url, paste0(base_url, "/ILIARIRates.csv"))
})

test_that("get_sari_rates_url returns correct latest URL", {
  url <- get_sari_rates_url()
  expect_equal(url, paste0(base_url, "/SARIRates.csv"))
})

test_that("get_sari_positivity_url returns correct latest URL", {
  url <- get_sari_positivity_url()
  expect_equal(url, paste0(base_url, "/SARITestsDetectionsPositivity.csv"))
})

test_that("get_nonsentinel_severity_url returns correct latest URL", {
  url <- get_nonsentinel_severity_url()
  expect_equal(url, paste0(base_url, "/nonSentinelSeverity.csv"))
})

test_that("get_nonsentinel_tests_url returns correct latest URL", {
  url <- get_nonsentinel_tests_url()
  expect_equal(url, paste0(base_url, "/nonSentinelTestsDetections.csv"))
})

# --- Snapshot URLs ---

test_that("get_sentineltests_positivity_url returns correct snapshot URL", {
  url <- get_sentineltests_positivity_url(
    use_snapshot = TRUE,
    snapshot_date = as.Date("2023-11-24")
  )
  expect_equal(
    url,
    paste0(base_url, "/snapshots/2023-11-24_sentinelTestsDetectionsPositivity.csv")
  )
})

test_that("get_erviss_variants_url returns correct snapshot URL", {
  url <- get_erviss_variants_url(
    use_snapshot = TRUE,
    snapshot_date = as.Date("2024-06-15")
  )
  expect_equal(
    url,
    paste0(base_url, "/snapshots/2024-06-15_variants.csv")
  )
})

test_that("get_ili_ari_rates_url returns correct snapshot URL", {
  url <- get_ili_ari_rates_url(
    use_snapshot = TRUE,
    snapshot_date = as.Date("2024-01-01")
  )
  expect_equal(
    url,
    paste0(base_url, "/snapshots/2024-01-01_ILIARIRates.csv")
  )
})

test_that("get_sari_rates_url returns correct snapshot URL", {
  url <- get_sari_rates_url(
    use_snapshot = TRUE,
    snapshot_date = as.Date("2024-03-15")
  )
  expect_equal(
    url,
    paste0(base_url, "/snapshots/2024-03-15_SARIRates.csv")
  )
})

test_that("get_sari_positivity_url returns correct snapshot URL", {
  url <- get_sari_positivity_url(
    use_snapshot = TRUE,
    snapshot_date = as.Date("2024-02-28")
  )
  expect_equal(
    url,
    paste0(base_url, "/snapshots/2024-02-28_SARITestsDetectionsPositivity.csv")
  )
})

test_that("get_nonsentinel_severity_url returns correct snapshot URL", {
  url <- get_nonsentinel_severity_url(
    use_snapshot = TRUE,
    snapshot_date = as.Date("2024-07-01")
  )
  expect_equal(
    url,
    paste0(base_url, "/snapshots/2024-07-01_nonSentinelSeverity.csv")
  )
})

test_that("get_nonsentinel_tests_url returns correct snapshot URL", {
  url <- get_nonsentinel_tests_url(
    use_snapshot = TRUE,
    snapshot_date = as.Date("2024-12-31")
  )
  expect_equal(
    url,
    paste0(base_url, "/snapshots/2024-12-31_nonSentinelTestsDetections.csv")
  )
})

# --- Snapshot error handling ---

test_that("URL builders error when use_snapshot = TRUE without snapshot_date", {
  expect_error(
    get_sentineltests_positivity_url(use_snapshot = TRUE),
    "snapshot_date.*required"
  )
  expect_error(
    get_erviss_variants_url(use_snapshot = TRUE),
    "snapshot_date.*required"
  )
  expect_error(
    get_ili_ari_rates_url(use_snapshot = TRUE),
    "snapshot_date.*required"
  )
  expect_error(
    get_sari_rates_url(use_snapshot = TRUE),
    "snapshot_date.*required"
  )
  expect_error(
    get_sari_positivity_url(use_snapshot = TRUE),
    "snapshot_date.*required"
  )
  expect_error(
    get_nonsentinel_severity_url(use_snapshot = TRUE),
    "snapshot_date.*required"
  )
  expect_error(
    get_nonsentinel_tests_url(use_snapshot = TRUE),
    "snapshot_date.*required"
  )
})

test_that("URL builders error when snapshot_date is not a Date", {
  expect_error(
    get_erviss_variants_url(use_snapshot = TRUE, snapshot_date = "2024-01-01"),
    "must be a Date object"
  )
  expect_error(
    get_sentineltests_positivity_url(use_snapshot = TRUE, snapshot_date = 20240101),
    "must be a Date object"
  )
})

# --- Generic URL dispatcher ---

test_that("get_erviss_url dispatches to correct URL builders", {
  expect_equal(
    get_erviss_url("positivity"),
    get_sentineltests_positivity_url()
  )
  expect_equal(
    get_erviss_url("variants"),
    get_erviss_variants_url()
  )
  expect_equal(
    get_erviss_url("ili_ari_rates"),
    get_ili_ari_rates_url()
  )
  expect_equal(
    get_erviss_url("sari_rates"),
    get_sari_rates_url()
  )
  expect_equal(
    get_erviss_url("sari_positivity"),
    get_sari_positivity_url()
  )
  expect_equal(
    get_erviss_url("nonsentinel_severity"),
    get_nonsentinel_severity_url()
  )
  expect_equal(
    get_erviss_url("nonsentinel_tests"),
    get_nonsentinel_tests_url()
  )
})

test_that("get_erviss_url errors on invalid type", {
  expect_error(get_erviss_url("invalid_type"), "arg")
})

test_that("get_erviss_url passes snapshot params correctly", {
  snapshot_d <- as.Date("2024-05-01")
  expect_equal(
    get_erviss_url("variants", use_snapshot = TRUE, snapshot_date = snapshot_d),
    get_erviss_variants_url(use_snapshot = TRUE, snapshot_date = snapshot_d)
  )
})
