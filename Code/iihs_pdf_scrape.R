library(stringr)
library(dplyr)
library(tidyr)
library(pdftools)
library(readr)
library(tidytext)
library(tabulizer)
library(purrr)

pdf_file <- "https://www.iihs.org/api/datastoredocument/status-report/pdf/55/2"
  
pdf <- extract_tables("https://www.iihs.org/api/datastoredocument/status-report/pdf/55/2", pages = 4, method = "stream") %>% 
  purrr::map(as_tibble)

pdf2 <- extract_tables("https://www.iihs.org/api/datastoredocument/status-report/pdf/55/2", pages = 5, method = "stream") %>% 
  purrr::map(as_tibble)

table_1 <- pdf[[1]][,1:6] %>% 
  dplyr::mutate(V7 = str_extract(V2, "\\d{1,2}$"),
                V2 = str_sub(V2, start = 1, end = -3)) %>% 
  dplyr::select(1,2,7,3:6) 
colnames(table_1) <- c("vehicle", "death_overall", "death_mv", "death_sv", "sv_roll", "years", "exposure")

table_2 <- pdf[[1]][,7:13]
colnames(table_2) <- c("vehicle", "death_overall", "death_mv", "death_sv", "sv_roll", "years", "exposure")


table_3 <- pdf2[[1]][,1:7]
colnames(table_3) <- c("vehicle", "death_overall", "death_mv", "death_sv", "sv_roll", "years", "exposure")




crash_raw <- table_1 %>% 
  dplyr::bind_rows(table_2, table_3) %>% 
  dplyr::mutate(exposure = gsub(",", "", exposure))

crash_df <- as.data.frame(lapply(crash_raw, function(y) gsub("\\s{2,}", "", y))) %>% 
  dplyr::mutate(death_overall = str_extract(death_mv, "\\d{1,2}"),
                across(c("death_overall", "death_mv", "death_sv", "sv_roll", "exposure"), as.numeric),
                make = str_extract(vehicle, "\\w*"),
                model = sub("(\\w*)\\s", "", vehicle)) %>% 
  dplyr::filter(!is.na(death_mv),
                death_overall != "",
                make != "ALL")
