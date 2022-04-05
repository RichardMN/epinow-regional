# epinow-regional
 Framework for calculating R using epinow2 and covidregionaldata

This is a set of R scripts, bash scripts, HTML and included JavaScript to
put together a web page which presents R(t) values calculated using
the [EpiNow2](https://epiforecasts.io/EpiNow2) package using data drawn
from the [covidregionaldata](https://epiforecasts.io/covidregionaldata)
package.

It uses the [rt_vis](https://github.com/hamishgibbs/rt_vis)
package by [Hamish Gibbs](https://www.lshtm.ac.uk/aboutus/people/gibbs.hamish).

This should be considered comparable to a cake mix. There is no one button
to press or script to run. It is not a Makefile. You will have to add
an egg and some milk and make adjustments in the code.

## Instructions

1. Choose a country, check that 
[covidregionaldata](https://epiforecasts.io/covidregionaldata) provides
regional data for it. (If it doesn't it may soon be able to through
wrapping data from other sources.)
2. Edit `daily-epinow-run`:
  - You will need to change the following lines:
```{sh}
countryName="Canada"
countryLevel="1"
startDate="2022-02-01"
```
3. Try running the `daily-epinow-run`. It
runs  `epinow2-regional-covidregionaldata.R`, and touches files to provide
a rough indicator of how long the run takes. (If the two files have the 
same time, you have a very fast computer or something is wrong.)
4. Edit `docs/COVID19-Rt-regional.Rmd`
  - You will need to adjust the following lines:
```{r}
countryName <- "Canada"
activeArea <- "Ontario"
```
  - The `activeArea` is the first region which has its data 
displayed in the graphs. Even if the map doesn't work 
you will be able to choose regions through drop-down menu.
5. Knit `docs/COVID19-Rt-regional.Rmd` and examine the output. You may wish to
move it or rename it.
6. Currently `daily-epinow-run` puts the output into docs, 
which could be used for github pages publication. My
workflow puts the output into a parallel directory,
runs [jekyll](https://jekyllrb.com/), and uses [s3cmd](https://github.com/s3tools/s3cmd) to upload the output to
a static AWS S3-hosted website.
7. Check the output.
8. If you're happy with the process, look into running it
daily (or less frequently).

On my five year-old Mac mini I can generate R(t) estimates
for sixty regions (Lithuania has 60 municipalities) for 
two months of data in a few hours.
