# This should not be updated. Instead use this time before generating all
# of the other tests. Also use this date when running tests.
test_time <- lubridate::make_datetime(year = 2026,
                                      month = 9,
                                      day = 9,
                                      hour = 3,
                                      min = 30,
                                      sec = 30,
                                      tz = "UTC")
save(test_time,
     file = testthat::test_path("testdata", "0_test_time.rda"))
