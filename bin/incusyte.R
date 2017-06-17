#!/usr/bin/env Rscript
source("./R/incusyte.R")
silent_library(optparse)

#' @title Command line parser for incusyte
#' @description Optparse configuration
command_line_parser <- function() {
  option_list = list(
    make_option(c("-f", "--file"), type = "character", default = NULL,
                help = "filename to process", metavar = "character"),
    make_option(c("-v", "--verbose"), action = "store_true", default = FALSE,
                help = "Print extra output [default %default]"),
    make_option(c("-o", "--output"), type = "character", default = NULL,
                help = "output file name", metavar = "character")
  )
  return(optparse::OptionParser(option_list=option_list))
}

if (interactive()) {
  file <- "fixtures/plate_example.txt"
  output <- "~/Desktop/plate_example.csv"
} else {
  opt_parser <- command_line_parser()
  opt <- parse_args(opt_parser)
  file <- opt$file
  output <- opt$output
  if (is.null(file)){
    print_help(opt_parser)
    exit(1, "A file must be provided (file name of the incusyte plate)")
  }
  if (is.null(output)){
    print_help(opt_parser)
    exit(1, "At least one argument must be supplied (output file)")
  }
}

df <- load_plate(file)
averages <- averages(df)
write.csv(averages, output, na = "")
