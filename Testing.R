# for(sf in dir(file.path(here::here(), "R"), ".R", full.names = T)) {
#   source(sf)
# }
devtools::load_all()

input_dir <- here::here()
output_dir <- file.path(input_dir, "Output")
template_dir <- file.path(input_dir, "inst", "extdata", "Templates")

unlink(file.path(output_dir, "*"), recursive = T, force = T)

test_date <- Sys.Date()

createYear(input_date = test_date,
           template_dir = template_dir,
           output_dir = output_dir,
           author = "Garrett Johnson")
#
# createQuarter(input_date = test_date,
#            template_dir = template_dir,
#            output_dir = output_dir)
#
# createMonth(input_date = test_date,
#            template_dir = template_dir,
#            output_dir = output_dir)
#
# createWeek(input_date = test_date,
#            template_dir = template_dir,
#            output_dir = output_dir)
#
# createDay(input_date = test_date,
#            template_dir = template_dir,
#           output_dir = output_dir)
