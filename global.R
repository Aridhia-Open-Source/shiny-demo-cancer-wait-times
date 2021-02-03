####################
###### GLOBAL ######
####################


# Load libraries
library(shiny)
library(tidyverse)
library(DT)
library(tidyxl)
library(readxl)
library(rgdal)
library(leaflet)
library(sf)
library(rmapshaper)

# source help tab
source("./help_tab.R")

# List of the excel files and all its sheets
xl_sheets <- list.files("datafiles/") %>%
  map(~paste0("datafiles/", .x)) %>%
  map(~excel_sheets(.x))

map_gsdf <- readOGR( 
  dsn = "map_data/Strategic_Clinical_Networks_December_2016_Full_Clipped_Boundaries_in_England(simplified).shp", 
  layer = "Strategic_Clinical_Networks_December_2016_Full_Clipped_Boundaries_in_England(simplified)",
  GDAL1_integer64_policy = TRUE
) %>% 
  spTransform(., CRS("+proj=longlat +datum=WGS84 +no_defs"))

get_row_ranges <- function(file, sheet) {
  col <- read_excel(file, sheet, col_names = FALSE) %>% pull(2)
  starts <- grep("ODS CODE", col)
  possible_ends <- which(is.na(col))
  
  ends <- starts %>% map_dbl(~possible_ends[which(possible_ends > .)[1]])
  
  return(list(starts = starts, ends = ends - 1))
}

get_col_ranges <- function(file, sheet) {
  start <- "A"
  
  sheet_head <- read_excel(file, sheet, n_max = 100)
  
  end <- LETTERS[ncol(sheet_head)]
  return(c(start, end))
}

get_table_ranges <- function(file, sheet) {
  row_ranges <- get_row_ranges(file, sheet)
  col_ranges <- get_col_ranges(file, sheet)
  
  row_starts <- row_ranges$starts
  row_ends <- row_ranges$ends
  
  lapply(1:length(row_starts), function(i) paste0(col_ranges[1], row_starts[i], ":", col_ranges[2], row_ends[i]))
}

find_identical_cols <- function(df) {
  for(i in 1:(ncol(df) - 1)) {
    for(j in (i+1):ncol(df)) {
      if(identical(df[[i]], df[[j]])) {
        return(c(i, j))
      }
    }
  }
}

sanitise_names_rm <- function(x) {
  x <- tolower(x)
  x <- sub("[ ]?\\([0-9]\\)", "", x)
  x <- gsub(" ", "_", x)
  x <- sub("[\\.]?\\.\\.[0-9]+", "", x)
  return(x)
}

sanitise_table_names <- function(x) {
  x <- tolower(x)
  x <- gsub("-", "_", x)
  x <- gsub(" ", "_", x)
  x <- gsub("\\(", "", x)
  x <- gsub("\\)", "", x)
  return(x)
}

replace_na <- function(x, strings = "N/A") {
  x$ons_area_id[x$ons_area_id %in% strings] <- NA
  return(x)
}

add_ons_id <- function(x) {
  nms <- names(x)
  if (!"ons_area_id" %in% nms){
    
    x <- x %>% left_join(ons_area_id_lookup, by = "ods_code")
    return(x[, c("ons_area_id", nms)])
  }
  else{
    return(x)
  }
}

read_rm_sheet <- function(file, sheet) {
  ranges <- get_table_ranges(file, sheet)
  starts <- get_row_ranges(file, sheet)$starts
  
  # Read all table ranges and combine
  df <- ranges %>% map(~read_excel(file, sheet, range = .)) %>%
    bind_rows()
  
  # remove empty columns
  df <- df[, sapply(df, function(x) !all(is.na(x)))]
  
  # remove identical_columns
  id_cols <- find_identical_cols(df)
  if(!is.null(id_cols)) {
    df[[id_cols[2]]] <- NULL
  }
  
  # identify percentage column
  unnamed_col <- grep("^[\\.]?\\.\\.[0-9]+$", names(df))
  
  extra_names <- c(read_excel(file, sheet, skip = starts[1] - 2, n_max = 1, col_names = FALSE))
  perc_name <- extra_names[!is.na(extra_names)][[2]]
  # typo in one of the sheets
  if(sheet == "31-DAY FIRST TREAT (BY CANCER)") {
    perc_name <- "PERCENTAGE TREATED WITHIN 31 DAYS"
  }
  
  names(df)[unnamed_col] <- perc_name
  df[[perc_name]] <- df[[perc_name]] * 100
  
  df$source_file <- substr(file, 13, nchar(file))
  df$time_period <- substr(file, 13, 24)
  
  # sanitise names
  names(df) <- sanitise_names_rm(names(df))
  
  return(df)
}

plots <- function(tmp, name, nat_avg){
  percentage_name <- names(tmp)[[match('total',names(tmp)) + 3]]
  
  # nat_avg <- (sum(tmp[[which(names(tmp)=='total')+1]]) / sum(tmp$total)) * 100
  
  average_diff <- tmp %>%
    group_by(ods_code) %>%
    summarise(average_time = mean(.data[[percentage_name]])) %>%
    mutate (difference = average_time - nat_avg)
  
  p <- ggplot(data = average_diff, aes(x = ods_code , y =difference)) + 
    geom_col(aes(fill = difference)) +
    scale_fill_gradient2(low = "red",
                         high = "green",
                         midpoint = median(average_diff$difference)) +
    ggtitle(paste("Difference of ", name, "between\nnational average and regional providers")) + 
    theme(plot.title = element_text(lineheight=.8, hjust = 0.5, face="bold"))
  
  return(p)
}

q1_file <- "datafiles/Q1-2015-2016-CANCER-WAITING-TIMES-PROVIDER-WORKBOOK.xlsx"
q1_sheets <- tidyxl::xlsx_sheet_names(q1_file)[-1]

q1_tables <- q1_sheets %>% map(~read_rm_sheet(q1_file, .))

ons_area_id_lookup <- q1_tables %>% map(~ .[, 1:2]) %>% map(`names<-`, c("ons_area_id", "ods_code")) %>%
 bind_rows() %>% unique()
