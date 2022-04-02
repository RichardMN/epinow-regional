#
# OSP regional data analysis
#
# Uses EpiNow2 to analyse data downloaded using covidregionaldata
# One script which can be run for multicore (parallel) or single track
# computation
#


library(tidyverse)
library(lubridate)
library(EpiNow2)
library(covidregionaldata)
library(future)
library(unix)

print(startDate)
print(countryName)
print(countryLevel)

# Parameters
#
#

#startDate <- "2022-01-01"
setNumberOfCores <- 8

runInParallel <- TRUE # whether to run in parallel
narrowRegions <- FALSE # whether to operate on a narrowed set of regions
runShortTimeFrame <- FALSE

if (runShortTimeFrame) {
  startDate <- "2022-03-01"
  shortRunStub <- "-SHORTRUN"
} else {
  shortRunStub <- ""
}

folderStub <- "/output"

work_folder <- paste0(getwd(), folderStub, shortRunStub)

stubStamp <- stamp_date("20210915")
dashStamp <- stamp_date("2021-09-15")
dateStub <- stubStamp(today())
dashEndDate <- dashStamp(today())
dateEndStub <- stubStamp(today())

regional_incidence_confirmed <- get_regional_data(country = countryName,
                                                  totals=FALSE,
                                                  localise=FALSE,
                                                  level = countryLevel) %>%
  rename(region=level_1_region, incidence=cases_new) %>%
  filter(date > "2020-01-01", date<=dashEndDate) %>%
  select(date, region, incidence)

last_date <- regional_incidence_confirmed %>%
  filter(!is.na(incidence), !is.na(date)) %>%
  select(date) %>%
  arrange(desc(date)) %>%
  slice(1)
region_summaries <-
  regional_incidence_confirmed%>%
  group_by(region) %>%
  summarise(min_i=min(incidence), max_i=max(incidence), median_i=median(incidence),mean_i=mean(incidence))

unnarrowed_regions <- pull(region_summaries %>%select(region))

if (narrowRegions) {
  narrowed_regions <- pull(region_summaries %>%slice_max(max_i, n=12) %>%select(region))
} else {
  narrowed_regions <- pull(region_summaries %>%filter(region != "", region!= "Unknown") %>%select(region))
}

reporting_delay <- estimate_delay(rlnorm(1000,  log(3), 1),
                                  max_value = 15, bootstraps = 1)
generation_time <- get_generation_time(disease = "SARS-CoV-2",
source = "ganyani")
incubation_period <- get_incubation_period(disease = "SARS-CoV-2",
source = "lauer")

# Now work for regional versions

narrowed_incidence <- regional_incidence_confirmed %>%
  filter(region%in%narrowed_regions) %>%
  ungroup() %>%
  rename(confirm=incidence)%>%
  mutate(date=as_date(date)) %>%
  mutate(region=region) %>%
  select(date,confirm,region) %>%
  complete(date=seq.Date(min(as.Date(regional_incidence_confirmed$date)),
                         max(as.Date(regional_incidence_confirmed$date)),by="day")
  ) %>%
  filter(date>= as.Date(startDate, "%Y-%m-%d"), date<= Sys.Date()) %>%
  as.data.frame()

options(mc.cores=setNumberOfCores)

setup_future_retval <-
  setup_future(reported_cases = narrowed_incidence,
    strategies = c("multisession", "multisession"),
    min_cores_per_worker = 4)

print(paste0("setup_future_retval: ", setup_future_retval))

regional_estimates <- regional_epinow(
  reported_cases = narrowed_incidence,
  generation_time = generation_time,
  target_folder = work_folder,
  logs=work_folder,
  return_output = TRUE,
  delays = delay_opts(incubation_period, reporting_delay),
  rt = rt_opts(prior = list(mean = 2, sd = 0.2)),
  stan = stan_opts(cores = setup_future_retval, future=TRUE),
  verbose=TRUE
)

regional_summary(regional_output = regional_estimates$regional,
                 reported_cases = narrowed_incidence,
                 summary_dir= paste0(getwd(),"/epinow2-multicore-regions/summary-",dateEndStub, shortRunStub),
                 region_scale = "Region",
                 all_regions = TRUE)


write.csv(last_date,
          paste0(
            getwd(),
            "/epinow2-multicore-regions/summary-",
            dateEndStub,
            shortRunStub,
            "/latest_date.csv"),
          row.names = FALSE)
