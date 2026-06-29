# Data Quality Assessment Pipeline for Tabular Datasets

## Overview

This project provides a structured workflow for an initial assessment of the quality of tabular datasets. The script is designed to take as input a generic dataset and perform a systematic evaluation of its structure, completeness, consistency, and variable-level properties.

The main goal of the project is to support exploratory data quality analysis before any statistical modelling or downstream analysis is conducted. The workflow is implemented in R and organized within a reproducible Quarto document.

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

Each stage progressively improves data consistency and prepares the dataset for quality assessment and association analysis.

---

## Reproducibility

To run the workflow with a different dataset, the following modifications are required:

- Update **Chunk 8**, which handles dataset import
- Update the **Data Dictionary** to reflect variable names, types, and descriptions of the new dataset
- Update the **title, subtitle, author(s), and abstract** in the Quarto (`.qmd`) file to reflect the new project context
- Set the correct **working directory** by replacing the commented line:

  ```r
  # setwd("C:/Users/Bianconiglio/Desktop/Quarto_Template") # set the working directory
  ```
  
  with the appropriate local path for the user’s system
- Replace the author signature section:

  ```html
  <em>**Thank you for your attention from**</em> <br> <em>**Luigi Piccirillo**</em>
  ```

  with the correct name(s) of the author(s)

No further modifications are required in the script structure.

---

## Software Requirements

This project was developed using:

- R (see official R license and citation)
- RStudio (Posit IDE)
- Quarto (for reproducible reporting)

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