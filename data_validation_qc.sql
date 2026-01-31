-- ############################################################
-- DATA VALIDATION & QUALITY CONTROL (QC) REPORT
-- Purpose: Identifying data anomalies and logical inconsistencies 
-- ############################################################

-- 1. Check for Logical Range Violations 
-- (Percentage should never be > 1 or < 0)
SELECT company, percentage_laid_off
FROM layoffs2
WHERE percentage_laid_off > 1 OR percentage_laid_off < 0;

-- 2. Check for Chronological Outliers 
-- (Dates in the future or significantly before COVID-19 era)
SELECT *
FROM layoffs2
WHERE `date` > CURRENT_DATE() 
   OR `date` < '2019-01-01';

-- 3. Industry Null-Check Post-Cleaning 
-- (Verifying the self-join worked and no blanks remain)
SELECT COUNT(*) as remaining_null_industries
FROM layoffs2
WHERE industry IS NULL OR industry = '';

-- 4. Funding vs. Layoff Correlation Check (Outlier Detection)
-- Finding companies with high funding but massive layoffs (Potential Data Entry Errors)
SELECT company, funds_raised_millions, total_laid_off
FROM layoffs2
WHERE total_laid_off > 10000 
AND funds_raised_millions < 100; -- High layoffs with low funding is an anomaly