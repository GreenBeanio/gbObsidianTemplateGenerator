temp_dir <- file.path(tempdir(), "Ouput")
dir.create(temp_dir)
output_path <- createWeek(input_date = test_time,
                         output_dir = temp_dir,
                         unique_timestamp = test_time,
                         author = "Test User")
loaded_file <- readr::read_file(output_path[[1]])
saveRDS(loaded_file,
        file = testthat::test_path("testdata", "create_week.rda"))
unlink(temp_dir, recursive = TRUE, force = TRUE)
