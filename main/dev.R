library(CORE)
library(tidyverse)
library(kableExtra)
library(rmarkdown)
library(DT)

# config_generate(project_name = "cr_transcript",config_path = "./inst/config/config.yml")

staticValues <- get("staticValues", envir = asNamespace("CORE"))

setup_and_source(
  district = staticValues$district_names$Alpaugh,
  period = staticValues$periods$annual,
  acad_yr = 2024,
  dev = staticValues$dev
)

setup_and_source(
  district = staticValues$district_names$Chawanakee,
  period = staticValues$periods$annual,
  acad_yr = 2024,
  dev = staticValues$dev
)

setup_and_source(
  district = staticValues$district_names$LosBanos,
  period = staticValues$periods$annual,
  acad_yr = 2024,
  dev = staticValues$dev
)

setup_and_source(
  district = staticValues$district_names$Visalia,
  period = staticValues$periods$annual,
  acad_yr = 2024,
  dev = staticValues$dev
)
