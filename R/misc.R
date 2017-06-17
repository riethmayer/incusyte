#' @title Make calls to \code{library} extra silent
#'
#' @description Command line tools don’t want to clutter their output with unnecessary noise.
#'   This replaces the default \code{library} arguments to ensure this silence. It
#'   additionally wraps all calls in \code{suppressMessages} to be extra silent.
#'   This is mainly necessary because not all packages play nicely and use
#'   \code{message} inappropriately instead of \code{packageStartupMessage}.
#' @param library_name library to load, silencing all warnings
#' @export
silent_library = function (package, help, pos = 2, lib.loc = NULL,
                           character.only = FALSE, logical.return = FALSE,
                           warn.conflicts = FALSE, quietly = TRUE,
                           verbose = FALSE) {
  call = match.call()
  call[[1]] = quote(base::library)
  wrap = if (quietly && ! warn.conflicts)
           suppressMessages
         else
           identity
  wrap(eval.parent(call))
}

silent_library(tidyverse)
silent_library(reshape2)
