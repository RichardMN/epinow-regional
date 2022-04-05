---
title: "COVID19 R(t) estimates - data download"
self_contained: false
---
  

The data has been processed using the [EpiNow2](https://epiforecasts.io/EpiNow2/dev/index.html) R package to estimate the time-varying reproduction number, rate of spread, and doubling time. EpiNow2 uses a range of open-source tools ([Abbott et al.](https://doi.org/10.12688/wellcomeopenres.16006.1)), and current best practices ([Gostic et al.](https://doi.org/10.1101/2020.06.18.20134858)). 

|File             | Contents            |
|:----------------|:--------------------|
| [cases_by_infection.csv](epinow/cases_by_infection.csv) | Cases by infection date |
| [cases_by_report.csv](epinow/cases_by_report.csv) |Cases by report date |
| [growth_rate.csv](epinow/growth_rate.csv) | Growth rate estimates |
| [reported_cases.csv](epinow/reported_cases.csv) | Reported cases (incidence, based on confirmed date)|
| [rt.csv](epinow/rt.csv) | Rt estimates |
| [summary_data.csv](epinow/summary_data.csv) | Summary data (with confidence values) |
| [summary_table.csv](epinow/summary_table.csv) | Summary table (human-readable) |
