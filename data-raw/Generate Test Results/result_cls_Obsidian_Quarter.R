temp_dir <- file.path(tempdir(), "Ouput")
dir.create(temp_dir)
output_path <- ObsidianQuarter$new(
  input_date = lubridate::date(test_time),
  output_dir = temp_dir,
  unique_timestamp = test_time,
  author = "Test User")$process()[[1]]
loaded_file <- readr::read_file(output_path)
loaded_file <- loaded_file |> stringr::str_replace_all("/r", "")
saveRDS(loaded_file,
        file = testthat::test_path("testdata", "ObsidianQuarter.rds"))
unlink(temp_dir, recursive = TRUE, force = TRUE)
