# Data Quality Assessment Pipeline for Tabular Datasets

## Overview

This project provides a structured workflow for an initial assessment of the quality of tabular datasets. The script is designed to take as input a generic dataset and perform a systematic evaluation of its structure, completeness, consistency, and variable-level properties.

The main goal of the project is to support exploratory data quality analysis before any statistical modelling or downstream analysis is conducted. The workflow is implemented in R and organized within a reproducible Quarto document.

---

## Live HTML Report

A rendered example of the report is available online:

https://lpiccirillo.github.io/tabular-data-quality-report/

The example report is automatically built using GitHub Actions and published to GitHub Pages after each update of the main branch.

---

## Download the Quarto template

To download and open the Quarto template in **RStudio**, follow these steps:

1. Open **RStudio**.
2. Create a new **R Script** (`File` → `New File` → `R Script`).
3. Copy and paste the following code into the script.
4. Run the entire script.

The script will:

- download the latest version of this repository as a ZIP archive;
- extract it into your current working directory;
- ask whether to overwrite the existing file if it has already been downloaded;
- automatically open the **`Quarto_Script.qmd`** template in the RStudio editor.

```r
getwd() #display the current working directory, i.e. the location where the downloaded files will be saved

url <- "https://github.com/LPiccirillo/tabular-data-quality-report/archive/refs/heads/main.zip" #URL of the ZIP file containing the GitHub repository

zip_file <- "tabular-data-quality-report.zip" #name assigned locally to the downloaded ZIP file

repo_dir <- "tabular-data-quality-report-main" #name of the folder that will be automatically created after extracting the ZIP file

file_name <- "Quarto_Script.qmd" #name of the file to check in the working directory

#check whether the Quarto file already exists in the working directory
if (file.exists(file_name)) {
  #ask the user whether the existing file should be replaced
  answer <- readline(paste0("The file '", file_name, "' already exists. Do you want to download a new version and overwrite it? (y/n): "))
  #if the answer is different from "y", stop the operation
  if (tolower(answer) != "y") {message("Operation cancelled. The existing file in the working directory will be used.")
    } else {
      #delete the existing Quarto file
      file.remove(file_name)
      #download the GitHub repository as a ZIP file
      download.file(url, destfile = zip_file, mode = "wb")
      #extract the contents of the ZIP file into the working directory
      unzip(zip_file)
      #delete the ZIP file after extraction
      file.remove(zip_file)
      #display a confirmation message
      message("The new version of the Quarto template has been downloaded successfully.")}
  } else {
    #if the file does not exist, download the repository
    download.file(url, destfile = zip_file, mode = "wb")
    #extract the contents of the ZIP file
    unzip(zip_file)
    #delete the ZIP file after extraction
    file.remove(zip_file)
    #display a confirmation message
    message("The Quarto template has been downloaded successfully.")}

#copy the Quarto file from the extracted repository folder directly into the working directory
file.copy(from = file.path(repo_dir, "Quarto_Script.qmd"),
          to = "Quarto_Script.qmd",
          overwrite = TRUE) #if the file already exists, it will be overwritten

unlink(repo_dir, recursive = TRUE) #delete the extracted repository folder since it is no longer needed

file.edit("Quarto_Script.qmd") #open the Quarto file in the working directory using the RStudio editor
```

> **Note:** The repository will be downloaded into your current working directory (displayed by `getwd()`). If you want to save it elsewhere, change the working directory before running the script (e.g., using `setwd()` or by creating an RStudio Project).

---

## The Dataset

For demonstration and rendering purposes, the script has been applied to a real-world dataset provided by the Open Psychometrics Project (n.d.), which can be downloaded at the following link:

http://openpsychometrics.org/_rawdata/BIG5.zip

This dataset contains responses from a Big Five personality questionnaire and is used solely as an example to validate the workflow.

---

## Project Structure

```
.
├── .github/
│   └── workflows/
│       └── publish.yml                   # GitHub Actions workflow for automatic Quarto rendering and publication
│
├── .gitattributes                        # Git attributes configuration
│
├── .gitignore                            # Ignored files (Quarto outputs, temporary files)
│
├── Quarto_Script.qmd                     # Main Quarto template for automated data quality assessment and exploratory analysis
│
├── render.R                              # Helper script for rendering the Quarto report
│
├── Quarto_Template.Rproj                 # RStudio Project file
│
├── LICENSE_GPLv3                         # GNU General Public License v3.0
│
└── README.md                             # Documentation, installation instructions, and usage guide
```

---

## Script Structure

The script is organized into the following sections:

- Table of contents  
- Packages & Setup  
- The dataset  
  - Data Dictionary  
  - First exploration of the dataset  
    - Data import and dataset dimensions  
      - Renaming variables  
    - Dataset overview  
    - Missing or invalid values  
      - Check by variable  
      - Check by observation  
    - Non-informative variables  
      - Removal of degenerate (constant) variables  
    - Type of variables  
    - Summary statistics by variable  
- Associations between variables  
- Citations  
  - Bibliography  
  - Webliography  
  - R Packages  

---

## Data Workflow

The dataset is processed through three main stages:

- `data_0`: raw imported dataset  
- `data_1`: dataset with variables renamed in snake_case format  
- `data_2`: cleaned dataset after removal of degenerate (constant) variables

Each stage progressively prepares the dataset for subsequent analyses, such as exploratory data analysis, data visualization, descriptive summaries, and statistical assessments of variable relationships.

---

## Rendering the report

The dataset to analyse is controlled by the parameters declared in the YAML header of `Quarto_Script.qmd`, so **no manual editing of the `.qmd` is required** to run the workflow on a new file.

The dataset import is configured through the following parameters:

- `data_path`: location of the dataset
- `data_type`: input file format (`csv` or `excel`)
- `data_delim`: column separator used for delimited text files
- `data_sheet`: worksheet name or index used for Excel files

Paths are resolved relative to the project directory, ensuring portability across machines and operating systems.

The workflow supports both delimited text files (e.g. CSV, TSV) and Excel workbooks.

For delimited text files, the import relies on `readr::read_delim()` and the column separator is controlled through the `data_delim` parameter.

For Excel files, the import relies on `readxl::read_excel()` and the worksheet is selected through the `data_sheet` parameter.

There are three ways to render:

1. **Helper script (recommended).** `render.R` can be executed either by sourcing it in R (e.g. `source("render.R")`) or by running it from the command line (e.g. `Rscript render.R`). The script safely handles rendering by first checking that the required Quarto document exists and exiting gracefully if it does not. It can also optionally accept dataset path, file type, delimiter, and Excel sheet parameters.

2. **Quarto CLI.** Pass the parameters directly:

   CSV example:

   ```bash
   quarto render Quarto_Script.qmd \
   -P data_path:data/my_survey.csv \
   -P data_type:csv \
   -P data_delim:,
   ```

   Excel example:

   ```bash
   quarto render Quarto_Script.qmd \
   -P data_path:data/my_survey.xlsx \
   -P data_type:excel \
   -P data_sheet:Sheet1
   ```

3. **RStudio.** Edit the `params:` block at the top of `Quarto_Script.qmd` and click *Render*
   (or press *Ctrl + Shift + K*).

---

## Adapting the report to a new dataset

Beyond the input file, you will typically also want to:

- Update the **title, subtitle, author(s), and abstract** in the YAML header of the `.qmd`
- Update the dataset import parameters in the YAML header:
  - `data_path` to specify the location of the new dataset
  - `data_type` to indicate the file format (`csv` or `excel`)
  - `data_delim` when importing delimited text files (`csv`, `tsv`, etc.) to specify the column separator
  - `data_sheet` when importing Excel files to specify the worksheet name or index
- Update the **Data Dictionary** to reflect the variable names, types, and descriptions of the new dataset
- Replace the **author signature** section near the end of the document with the correct name(s)

The remainder of the workflow can usually be reused without modification.

---

## Requirements

The workflow requires:

- **R** (see the official R license and citation)
- **Quarto** (for reproducible reporting), and optionally **RStudio / Posit IDE**

### R packages

The workflow automatically checks for and installs missing R packages during the first execution. No manual installation is required in most cases.

The main dependencies used by the report are:

```r
c(
  "furrr",       # parallel execution with future-based workflows
  "readr",       # import of delimited text files
  "readxl",      # import of Excel files
  "tidyverse",   # data manipulation, analysis, and visualization
  "janitor",     # clean and standardize column names
  "psych",       # descriptive statistics
  "skimr",       # compact summary statistics
  "rcompanion",  # association measures (e.g., Cramér's V)
  "knitr",       # dynamic reporting
  "kableExtra",  # formatted HTML tables
  "here",        # project-relative file paths
  "quarto"       # rendering the document from R
)
```

All software is used under their respective licenses. See the **Citations** section of the report for full bibliographic details.

---

## License

The script and all original code in this repository are released under the **GNU General Public License v3.0 (GPLv3)**.

This ensures that the code remains open, reusable, and modifiable under the same licensing terms.

---

## Contact

In case of any malfunction, unexpected behavior, or reproducibility issues, users are encouraged to contact the author. Feedback is highly appreciated in order to investigate potential causes and improve or fix the workflow.

---

## Citations

Please refer to the bibliography section of the Quarto report for full references to:

- Data sources
- R packages
- Software (R, RStudio, Quarto)

---

## Notes

This project is intended for exploratory data quality assessment and is not a substitute for domain-specific data validation procedures.
