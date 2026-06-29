#!/usr/bin/env Rscript

# =============================================================================
# render.R
# -----------------------------------------------------------------------------
# Render the data-quality report (Quarto_Script.qmd) for a dataset placed in
# the project folder.
#
# By default the script AUTO-DETECTS a single data file inside the project
# directory, so you can simply drop your dataset in the folder and run the
# script with no arguments. The column separator is guessed from the file
# extension (comma for .csv, tab for .tsv/.txt/.dat).
#
# You may still pass an explicit path to override the auto-detection.
#
# Usage:
#   Rscript render.R                                  # auto-detect the dataset
#   Rscript render.R <path-to-dataset> [output.html] [delimiter]   # explicit
#
# Examples:
#   Rscript render.R
#   Rscript render.R data/my_survey.csv
#   Rscript render.R data/my_survey.csv report.html ,
# =============================================================================

# ----- Locate the project directory (the folder where this script lives) -----
script_arg  <- grep("^--file=", commandArgs(FALSE), value = TRUE)
project_dir <- if (length(script_arg) == 1) {
  dirname(normalizePath(sub("^--file=", "", script_arg)))
} else {
  getwd()
}

# ----- Helpers ---------------------------------------------------------------
guess_delim <- function(path) {
  switch(tolower(tools::file_ext(path)),
    csv = ",",
    tsv = "\t",
    "\t"  # default for .txt / .dat / unknown: tab-separated
  )
}

find_dataset <- function(dir) {
  files <- list.files(
    dir,
    pattern    = "\\.(csv|tsv|txt|dat)$",
    recursive  = TRUE,
    full.names = TRUE,
    ignore.case = TRUE
  )
  # Exclude tooling / output directories that may contain unrelated text files.
  files[!grepl("(^|/)(\\.git|\\.quarto|_site|renv|packrat)(/|$)", files)]
}

# ----- Resolve arguments -----------------------------------------------------
args <- commandArgs(trailingOnly = TRUE)

if (length(args) >= 1 && args[[1]] %in% c("-h", "--help")) {
  cat("Usage: Rscript render.R [<path-to-dataset>] [output.html] [delimiter]\n")
  cat("With no path, the dataset is auto-detected in the project folder.\n")
  quit(status = 0)
}

if (length(args) >= 1) {
  # Explicit path provided: use it as-is.
  data_path <- args[[1]]
  if (!file.exists(data_path)) {
    stop(sprintf("Dataset not found: '%s'", data_path), call. = FALSE)
  }
} else {
  # No path: auto-detect a single dataset in the project folder.
  candidates <- find_dataset(project_dir)

  if (length(candidates) == 0) {
    stop(
      "No dataset (.csv/.tsv/.txt/.dat) found in the project folder:\n  ",
      project_dir,
      "\nDrop your data file in the folder, or pass a path explicitly.",
      call. = FALSE
    )
  }
  if (length(candidates) > 1) {
    stop(
      "Multiple candidate datasets found; pass the one to use explicitly.\nFound:\n  ",
      paste(candidates, collapse = "\n  "),
      call. = FALSE
    )
  }
  data_path <- candidates[[1]]
  message(sprintf("Auto-detected dataset: %s", data_path))
}

output <- if (length(args) >= 2) args[[2]] else "Quarto_Script.html"
delim  <- if (length(args) >= 3) args[[3]] else guess_delim(data_path)

# Absolute, OS-normalised path (forward slashes) so the document can load the
# dataset regardless of the directory Quarto renders from.
data_path <- normalizePath(data_path, winslash = "/", mustWork = TRUE)

if (!requireNamespace("quarto", quietly = TRUE)) {
  install.packages("quarto")
}

message(sprintf("Rendering report for: %s (delimiter: %s)",
                data_path, if (delim == "\t") "tab" else sprintf("'%s'", delim)))

quarto::quarto_render(
  input          = file.path(project_dir, "Quarto_Script.qmd"),
  output_file    = output,
  execute_params = list(
    data_path  = data_path,
    data_delim = delim
  )
)

message(sprintf("Done. Report written to: %s", output))
