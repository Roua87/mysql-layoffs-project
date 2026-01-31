-- ############################################################
-- BUSINESS INTELLIGENCE VIEWS
-- Objective: Create reusable data layers for stakeholders
-- ############################################################

-- 1. Create a View for Yearly Layoff Trends
-- Useful for high-level executive reporting
CREATE OR REPLACE VIEW v_yearly_layoff_summary AS
SELECT 
    YEAR(`date`) AS layoff_year, 
    SUM(total_laid_off) AS total_impacted,
    COUNT(company) AS number_of_companies
FROM layoffs2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY YEAR(`date`)
ORDER BY layoff_year DESC;

-- 2. Create a View for Industry Analysis
-- Useful for sector-specific research
CREATE OR REPLACE VIEW v_industry_impact_report AS
SELECT 
    industry, 
    SUM(total_laid_off) AS total_layoffs,
    AVG(percentage_laid_off) AS avg_percentage_impact
FROM layoffs2
GROUP BY industry;

-- 3. Create a View for the MoM Growth (The "Science" View)
-- This encapsulates the complex LAG logic we just built
CREATE OR REPLACE VIEW v_monthly_velocity AS
WITH Monthly_Totals AS (
    SELECT 
        SUBSTRING(`date`, 1, 7) AS `Month`, 
        SUM(total_laid_off) AS total_off
    FROM layoffs2
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
    GROUP BY `Month`
)
SELECT 
    `Month`, 
    total_off,
    LAG(total_off) OVER (ORDER BY `Month`) AS prev_month_total,
    ROUND(((total_off - LAG(total_off) OVER (ORDER BY `Month`)) / LAG(total_off) OVER (ORDER BY `Month`)) * 100, 2) AS pct_growth
FROM Monthly_Totals;