source("./R/misc.R")

#' @title loads a plate
#' @description  loads a tab seperated file with specific format
#' @param filename name of the plate file
load_plate <- function(filename) {
  plate = read.table(filename, skip = 6, header = TRUE)
  as.data.frame.matrix(plate)
}

#' @title formats a group
#' @description Given a plate which is labeled A to H, when
#'     referring to a group we mean either A to D or E to H.
#'     A1 to H1 represents WHAT. Where A1 to D1 represents
#'     one WHAT.
#' @param df loaded plate
#' @param letters either c("A", "B", "C", "D") or c("E", "F", "G", "H")
#' @param i representing the number plates as a list. Default = 1:12
format_group <- function(df, letters, i = 1:12) {
  f <- dplyr::first(letters)
  l <- dplyr::last(letters)
  group <- paste0(f,l)
  observations = list()
  numbers_and_letters <- sapply(letters, function(x) paste0(x, i))
  obs <- rep(c("Date", "Time", "Elapsed"), 12) %>% matrix(nrow = 12, byrow = TRUE)
  selectors <- cbind(obs, numbers_and_letters)
  for(row in i) {
    observations[[row]] <- df %>%
      select_(.dots = selectors[row,]) %>%
      mutate(N = row, Group = group)
  }
  plyr::rbind.fill(observations)
}

#' @title Formats the wide format to a long format
#' @description Renames A-D and E-H to X1 - X4 to simplify the calculation
#'     and keeps the Group information as a separate column.
#' @param df data frame with all observations
format <- function(df, formatter = format_group) {
  ad <- formatter(df, c("A", "B", "C", "D"))
  eh <- formatter(df, c("E", "F", "G", "H"))
  naming <- c("Date", "Time", "Elapsed", "X1", "X2", "X3", "X4", "N", "Group")
  names(ad) <- naming
  names(eh) <- naming
  rbind(ad, eh)
}

#' @title Calculates the averages for all observations
#' @title Given an incusyte plate, it will reformat the plate to calculate normalized
#'     means for each observation in a given elapsed time frame.
#' @param df data frame with all observations
averages <- function(df) {
  format(df)%>%
    mutate(AVRG = rowMeans(.[,c("X1","X2","X3","X4")]),
           X1.norm = X1 / AVRG,
           X2.norm = X2 / AVRG,
           X3.norm = X3 / AVRG,
           X4.norm = X4 / AVRG)
}
