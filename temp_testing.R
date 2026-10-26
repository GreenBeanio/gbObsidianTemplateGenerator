templat_dir <- here::here("inst", "extdata", "Templates")
output_dir <- here::here("testing")

createDay(input_date = lubridate::ymd("2025-1-1"),
          template_dir = templat_dir,
          output_dir = output_dir)

createWeek(input_date = lubridate::ymd("2025-1-1"),
           template_dir = templat_dir,
           output_dir = output_dir)

createMonth(input_date = lubridate::ymd("2025-1-1"),
           template_dir = templat_dir,
           output_dir = output_dir)

createQuarter(input_date = lubridate::ymd("2025-1-1"),
            template_dir = templat_dir,
            output_dir = output_dir)

createYear(input_date = lubridate::ymd("2025-1-1"),
              template_dir = templat_dir,
              output_dir = output_dir)
