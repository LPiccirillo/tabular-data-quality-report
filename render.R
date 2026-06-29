#!/usr/bin/env Rscript

#=============================================================================
#render.R
#-----------------------------------------------------------------------------
#This script renders the Quarto report (Quarto_Script.qmd).
#If the .qmd file is not found, it simply prints a message and exits safely.
#The design is intentionally fail-safe to avoid interruptions of the R session or cryptic errors from the Quarto CLI.
#=============================================================================

#-------------------------------------------------------------
#SCRIPT LOCATION DETECTION
#-------------------------------------------------------------

#extract the "--file=" argument automatically passed by Rscript when executing a script from the command line. This contains the full path of the currently running script
script_arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)

#Determine the project directory:
#- If the script is executed via Rscript, use the directory where this file resides (this makes execution independent from the current working directory).
#- Otherwise (e.g. interactive execution in RStudio), fall back to getwd().
project_dir <- if (length(script_arg) == 1) {dirname(normalizePath(sub("^--file=", "", script_arg)))
  } else {getwd()}

#-------------------------------------------------------------
#DEFINE QMD PATH
#-------------------------------------------------------------

#Construct the full path to the expected Quarto source file.
#file.path() ensures OS-independent path construction (Windows/Linux/macOS safe).
qmd_file <- file.path(project_dir, "Quarto_Script.qmd")

#-------------------------------------------------------------
#MAIN LOGIC (IF / ELSE)
#-------------------------------------------------------------

#Check whether the required Quarto input file exists before attempting rendering.
#This prevents passing invalid input to Quarto CLI and avoids runtime errors.
if (file.exists(qmd_file)) {
  #-----------------------------------------------------------
  #PACKAGE CHECK (Quarto)
  #-----------------------------------------------------------
  #Ensure the 'quarto' R package is installed.
  #requireNamespace() checks availability without attaching the package.
  #If missing, it is installed from the default CRAN repository.
  if (!requireNamespace("quarto", quietly = TRUE)) {install.packages("quarto")}
  library(quarto) #load the package into the current session so that quarto_render() is available
  #-----------------------------------------------------------
  #RENDER PROCESS
  #-----------------------------------------------------------
  #Define output file name for the rendered HTML report.
  #The output is written in the current working directory unless otherwise specified.
  output_file <- "Quarto_Script.html"
  #Inform the user that rendering is starting and show the resolved input path.
  message("Rendering report from: ", qmd_file)
  #Execute Quarto rendering:
  #- input: path to the .qmd file
  #- output_file: name of the generated HTML file
  #This call invokes the Quarto CLI under the hood.
  quarto::quarto_render(input = qmd_file,
                        output_file = output_file)
  #Confirmation message printed after successful rendering.
  message("Report created successfully.")
  } else {
    #-----------------------------------------------------------
    #FILE NOT FOUND HANDLING
    #-----------------------------------------------------------
    #If the expected Quarto document is not found in the project directory,
    #the script does NOT throw an error or stop execution.
    #Instead, it prints informative messages and exits gracefully.
    message("No Quarto_Script.qmd file found in project directory.")
    message("Nothing to render. Please add the file or check the path:")
    message(project_dir)}
