# mysql-layoffs-project
# Global Layoffs (the post-COVID era): Data Cleaning & Exploratory Analysis

## Project Overview
This project provides a comprehensive analysis of global layoff data. It is divided into two main phases: 
1. **Data Cleaning:** Transforming raw, "dirty" data into a structured format for analysis.
2. **Data Validation:** Leveraging my background in **Clinical Trial Data**, I implemented a validation layer to check for logical outliers, range violations, and data integrity issues. This ensures the analysis is built on a "Source-Verified" foundation.
3. **Exploratory Data Analysis (EDA):** Uncovering trends, identifying the hardest-hit industries, and calculating rolling totals of layoffs globally.
4. **Business Views:** Created a **Semantic Layer** using MySQL Views. This prepares the data for immediate consumption by Business Intelligence tools like Tableau or Power BI.
---

## Skills & Tools Used
- **Database:** MySQL
- **Data Cleaning:** CTEs, Window Functions (`ROW_NUMBER`), Self-Joins, String Formatting, Date Conversions.
- **Advanced Analysis:** Rolling Totals, Multi-level Ranking with `DENSE_RANK`, Time-series grouping.

---

##  Phase 1: Data Cleaning
In this stage, I focused on data integrity and standardization:
- **Duplicate Removal:** Used `ROW_NUMBER()` to identify and delete redundant records.
- **Standardization:** Fixed inconsistencies in industry names (e.g., merging all 'Crypto' variants) and trimmed whitespace.
- **Date Formatting:** Converted the text-based date column into a proper SQL `DATE` format.
- **Null Management:** Populated missing industry values using a **Self-Join** based on matching company names.

---

##  Phase 2: Clinical-Grade Validation & QC 
I implemented a rigorous Quality Control layer:
- **Logical Constraint Checks:** Verified that percentages and layoff totals adhered to realistic bounds (e.g., ensuring percentages did not exceed 100%).
- **Temporal Integrity:** Scanned for chronological outliers and future-dated entries to ensure dataset reliability.
- **Anomaly Detection:** Identified records with extreme funding-to-layoff ratios for further manual audit.

---

## Phase 3: Exploratory Data Analysis (EDA)
With a clean dataset, I explored the data to answer key business questions:

## High-Level Metrics
- Identified the maximum layoffs and percentages to find the scale of impact.
- Filtered for companies that went completely under (100% layoffs) and ranked them by their funding.

## Trends by Industry and Geography
- **Hardest Hit:** Aggregated total layoffs by **Company**, **Industry**, and **Country**.
- **Yearly View:** Grouped data by year to see which years had the highest volume of workforce reductions.

## Advanced Time-Series Analysis
- **Rolling Totals:** Created a monthly rolling sum of layoffs using a Window Function to visualize the progression of layoffs over time.
- **Yearly Rankings:** Developed a complex query using **Nested CTEs** to rank the **Top 5 Companies** with the most layoffs for each year.

## Velocity Metrics: 
- Engineered a Month-over-Month (MoM) Growth view to track the rate of change in layoffs, providing deeper insights than static reporting.
---

## Phase 4: Business Intelligence Layers
Data Architecture: Developed a series of SQL Views to serve as a "clean" consumption layer for stakeholders or visualization tools (Tableau/Power BI).

---

## Key Insights
- **Top Industries:** The Consumer and Retail sectors experienced the highest volume of layoffs after the pandemic.
- **Global Trends:** Layoffs peaked significantly in 2022 and 2023.
- **Company Impact:** Large-scale tech giants like Amazon, Google, and Meta consistently ranked in the top 5 for total layoffs per year, though smaller startups often saw a higher percentage of their workforce impacted (many reaching 100%).

---

## 📂 Project Structure
- `MySQL_Data_Cleaning_layoffs.sql`: Script for cleaning and standardizing the raw data.
- `data_validation_qc.sql`: Script for ensuring data integrity.
- `MySQL_EDA_layoffs.sql`: Script containing the EDA and advanced ranking queries.
- `Business_Views.sql`:Script for building a scalable "Semantic Layer" for downstream stakeholder.
- `layoffs.csv`: The initial dataset (before cleaning).
