---
title: "README"
output: html_document
---


## Working with environments

```
# initialize environment
install.packages("renv")
renv::init()

# install required dependencies
install.packages(
  c("devtools", "tidysynth", "tidyr", "dplyr", "readxl"),
  dependencies = TRUE
)

devtools::install_github("vdeminstitute/vdemdata")

# save the state of the package environment
renv::snapshot()

# [Optional] restore the R environment on a new machine
renv::restore()
```


## Code Linting and Formatting

+ [`stylr`](https://styler.r-lib.org/articles/styler.html): formats code according to the tidyverse style guide
+ [`lintr`](https://lintr.r-lib.org/articles/lintr.html): provides static code analysis for R; checks for adherence to a given style, identify syntax errors and possible semantic issues


```
# format code according to tidyverse guidelines
install.packages("styler")

styler::style_file("R/analysis.R")
styler::style_file("R/plotting.R")


# check formatted file for further syntax errors
install.packages("lintr")

lintr::lint("R/analysis.R")
lintr::lint("R/plotting.R")
```

