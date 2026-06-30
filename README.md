# Data Quality Assessment Pipeline for Tabular Datasets

## Overview

This project provides a structured workflow for an initial assessment of the quality of tabular datasets. The script is designed to take as input a generic dataset and perform a systematic evaluation of its structure, completeness, consistency, and variable-level properties.

The main goal of the project is to support exploratory data quality analysis before any statistical modelling or downstream analysis is conducted. The workflow is implemented in R and organized within a reproducible Quarto document.

---

## Live HTML Report

A rendered example of the report is available online:

https://lpiccirillo.github.io/tabular-data-quality-report/

The example report is automatically built using GitHub Actions and published to GitHub Pages after each update of the main branch.

Puoi aggiungere una sezione al **README** come questa, scritta in inglese e con uno stile tipico di GitHub.

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
- ask whether to overwrite the existing folder if it has already been downloaded;
- automatically open the **`Quarto_Script.qmd`** template in the RStudio editor.

```r
getwd() #display the current working directory

#URL of the repository ZIP file
url <- "https://github.com/LPiccirillo/tabular-data-quality-report/archive/refs/heads/main.zip"

#local ZIP file name
zip_file <- "tabular-data-quality-report.zip"

#folder created after extraction
repo_dir <- "tabular-data-quality-report-main"

if (dir.exists(repo_dir)) {
  answer <- readline(paste0("The folder '", repo_dir, "' already exists. Do you want to download and overwrite it? (y/n): "))
  if (tolower(answer) != "y") {message("Download cancelled. Using the existing folder.")
    } else {unlink(repo_dir, recursive = TRUE)
      #download the file
      download.file(url, destfile = zip_file, mode = "wb")
      #extract the contents into the current directory
      unzip(zip_file)
      #delete the ZIP file
      file.remove(zip_file)
      message("Repository re-downloaded successfully. The previous version has been overwritten.")}
  } else {
    #download the file
    download.file(url, destfile = zip_file, mode = "wb")
    #extract the contents into the current directory
    unzip(zip_file)
    #delete the ZIP file
    file.remove(zip_file)
    message("Repository downloaded successfully.")}

#name of the Quarto template saved in the working directory
destfile <- "tabular-data-quality-report-main/Quarto_Script.qmd"

#open the Quarto file in the RStudio editor
file.edit(destfile)
```

> **Note:** The repository will be downloaded into your current working directory (displayed by `getwd()`). If you want to save it elsewhere, change the working directory before running the script (e.g., using `setwd()` or by creating an RStudio Project).

---

## The Dataset

For demonstration and rendering purposes, the script has been applied to a real-world dataset provided by the Open Psychometrics Project (n.d.), which can be downloaded at the following link:

http://openpsychometrics.org/_rawdata/BIG5.zip

This dataset contains responses from a Big Five personality questionnaire and is used solely as an example to validate the workflow.

---

## Project Structure

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
  
Each stage progressively prepares the dataset for subsequent analyses, such as variable transformations, recoding, missing-data handling, exploratory data analysis, data visualization, statistical modelling, and other advanced analytical workflows.

---

## Rendering the report

The dataset to analyse is controlled by the `data_path` document parameter (declared in the YAML header of `Quarto_Script.qmd`), so **no manual editing of the `.qmd` is required** to run the workflow on a new file.

Paths are resolved relative to the project directory, ensuring portability across machines and operating systems. The dataset is imported using `readr::read_delim()` with the column separator specified via the `data_delim` parameter. This makes the workflow suitable for standard delimited files such as CSV, TSV, or similar text-based formats.

If the input dataset is not compatible with `read_delim()` (e.g. Excel, SPSS, Stata, SAS, RDS, Parquet, database files, or other non-delimited formats), it must be converted to a supported format or imported using an appropriate loader before being passed to the pipeline.

There are three ways to render:

1. **Helper script (recommended).** `render.R` can be executed either by sourcing it in R (e.g. `source("render.R")`) or by running it from the command line (e.g. `Rscript render.R`). The script safely handles rendering by first checking that the required Quarto document exists and exiting gracefully if it does not. It can also optionally accept a dataset path and a column delimiter, allowing flexible execution across different environments.

2. **Quarto CLI.** Pass the parameter directly:

   ```bash
   quarto render Quarto_Script.qmd -P data_path:data/my_survey.csv -P data_delim:,
   ```

3. **RStudio.** Edit the `params:` block at the top of `Quarto_Script.qmd` and click *Render*
   (or press *Ctrl + Shift + K*).

### Adapting the report to a new dataset

Beyond the input file, you will typically also want to:

- Update the **Data Dictionary** to reflect the variable names, types, and descriptions of the new dataset
- Update the **title, subtitle, author(s), and abstract** in the YAML header of the `.qmd`
- Update the `data_path` and, if necessary, the `data_delim` parameters in the YAML header.
- Replace the **author signature** section near the end of the document with the correct name(s)

The remainder of the workflow can usually be reused without modification.

---

## Requirements

The workflow requires:

- **R** (see the official R license and citation)
- **Quarto** (for reproducible reporting), and optionally **RStudio / Posit IDE**

### R packages

The script installs any missing packages automatically on first run. To install them up front:

```r
install.packages(c(
  "furrr",       # parallel iteration (with the parallel base package)
  "readr",       # import delimited files
  "tidyverse",   # data manipulation, analysis, and visualization
  "janitor",     # clean and standardize column names
  "psych",       # descriptive statistics
  "skimr",       # compact summary statistics (skim())
  "rcompanion",  # association measures (Cramer's V)
  "knitr",       # dynamic reporting
  "kableExtra",  # HTML tables
  "here",        # project-relative paths
  "quarto"       # render the document from R (used by render.R)
))
```

All software is used under their respective licenses. See the Citations section of the report for full bibliographic details.

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
