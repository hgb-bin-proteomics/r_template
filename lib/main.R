#!/usr/bin/env Rscript

library(checkmate)
library(optparse)
library(glue)

# jarl-ignore-start unused_object: documentation variables
version <- "1.0.0"
date <- "2026-07-20"
# jarl-ignore-end unused_object

source("lib/battle.R")
source("lib/shiny.R")

#' Main function
#'
#' @param cli_args Arguments passed to the parser (type: character vector).
#'   Defaults to `NULL`.
#' @returns Exit status (type: numeric, zero is success).
#' @examples
#' source("lib/main.R")
#' main(c("-f", "data/characters.csv"))
main <- function(cli_args = NULL) {
  # parser
  parser <- optparse::OptionParser(
    usage = "usage: %prog [-h] [-s] -f FILE [-a CHARACTER_1] [-b CHARACTER_2] [-p HEALTH]",
    prog = "run.R",
    description = "Battles two characters.",
    epilogue = glue("v{version} (c) Micha Birklbauer, 2026")
  ) |>
    optparse::add_option(
      c("-s", "--shiny"),
      action = "store_true",
      dest = "shiny",
      default = FALSE,
      help = "Run the script as a Shiny application"
    ) |>
    optparse::add_option(
      c("-f", "--file"),
      action = "store",
      type = "character",
      dest = "file",
      metavar = "FILE",
      default = NULL,
      help = "Character file to read characters from (str)",
      required = FALSE
    ) |>
    optparse::add_option(
      c("-a", "--character-1"),
      action = "store",
      type = "integer",
      dest = "c1",
      metavar = "CHARACTER_1",
      default = 1,
      help = "Index of the first character to use (int) [default %default]"
    ) |>
    optparse::add_option(
      c("-b", "--character-2"),
      action = "store",
      type = "integer",
      dest = "c2",
      metavar = "CHARACTER_2",
      default = 2,
      help = "Index of the second character to use (int) [default %default]"
    ) |>
    optparse::add_option(
      c("-p", "--hit-points"),
      action = "store",
      type = "integer",
      dest = "health",
      metavar = "HEALTH",
      default = 130,
      help = "Health of all characters (int) [default %default]"
    )

  # check if script
  is_script <- is.null(cli_args)

  # read arguments
  if (is_script) {
    cli_args <- optparse::parse_args(parser)
  } else {
    checkmate::assert_atomic_vector(
      cli_args,
      any.missing = FALSE,
      all.missing = FALSE
    )
    checkmate::assert_character(cli_args)

    cli_args <- optparse::parse_args(parser, args = cli_args)
  }

  # launch Shiny if -s or --shiny was given
  if (cli_args$shiny) {
    logger$info("Starting Shiny application...")
    shiny::runApp(app, port = 8501, host = "0.0.0.0")
    logger$info("Exited Shiny application.")
    if (is_script) {
      q(status = 0)
    }
    return(0)
  }

  # main
  exit_status <- tryCatch(
    {
      if (is.null(cli_args$file)) {
        stop(
          "Argument -f / --file is required when -s / --shiny is not given!",
          call. = FALSE
        )
      }

      characters <- character_factory(cli_args$file)
      character_1 <- as.integer(cli_args$c1)
      character_2 <- as.integer(cli_args$c2)
      health <- as.integer(cli_args$health)

      if (character_1 < 1 || character_1 > length(characters)) {
        stop(
          "Character 1 is not a valid index in the character file!",
          call. = FALSE
        )
      }
      if (character_2 < 1 || character_2 > length(characters)) {
        stop(
          "Character 2 is not a valid index in the character file!",
          call. = FALSE
        )
      }

      # jarl-ignore unused_object: dummy return variable
      winner <- battle(
        characters[[character_1]],
        characters[[character_2]],
        health = health
      )
      # jarl-ignore unused_object: exit status
      exit_status <- 0
    },
    error = function(cond) {
      logger$error(conditionMessage(cond))
      logger$fatal("An error occurred while running the script!")
      return(1)
    },
    warning = function(cond) {
      logger$warn(conditionMessage(cond))
      logger$warn("A warning occurred while running the script!")
      return(1)
    },
    finally = {}
  )

  # exit
  logger$info("Script finished with exit code {exit_status}.")
  if (is_script) {
    q(status = exit_status)
  }
  return(exit_status)
}
