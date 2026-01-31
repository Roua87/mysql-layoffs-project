-- -- -- -- -- -- -- Exploratory Data Analysis -- -- -- -- -- -- --

-- Here we are jsut going to explore the data and find trends or patterns or anything interesting like outliers

-- Looking at Percentage to see how big these layoffs were
SELECT MAX(percentage_laid_off), MAX(percentage_laid_off)
FROM layoffs2;

-- Which companies had 1 which is basically 100 percent of they company laid off
select *
from layoffs2 
where percentage_laid_off=1;

-- if we order by funcs_raised_millions we can see how big some of these companies were
SELECT *
FROM layoffs2
WHERE percentage_laid_off=1
ORDER BY funds_raised_millions DESC;

-- Companies with the biggest single Layoff
select company, total_laid_off
from layoffs2
order by total_laid_off desc
limit 5;

-- Companies with the most Total Layoffs
SELECT Company, industry, SUM(total_laid_off)
FROM layoffs2
GROUP BY company, industry
ORDER BY 3 DESC;

-- by industry
SELECT industry, SUM(total_laid_off)
FROM layoffs2
GROUP BY industry
ORDER BY 2 DESC;

-- by country
SELECT country, SUM(total_laid_off)
FROM layoffs2
GROUP BY country
ORDER BY 2 DESC;

-- by years
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Rolling Total of Layoffs Per Month
WITH Rolling_total AS
(
SELECT SUBSTRING(`date`, 1, 7) as `Month`, sum(total_laid_off) as total_off
FROM layoffs2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC
)
SELECT `Month`, total_off, SUM(total_off) OVER(ORDER BY `Month`) as rolling_total
FROM rolling_total;


-- Companies with the most Layoffs per year.
WITH company_year AS
(
SELECT Company, YEAR(`date`) as year1, SUM(total_laid_off) as total
FROM layoffs2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DEsc
), RANKCOMP AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY year1 ORDER BY YEAR1 ASC, TOTAL DESC) as rank1
FROM company_year
WHERE year1 IS NOT NULL
)
SELECT *
FROM RANKCOMP
WHERE rank1<5;

-- Analyzing the Velocity of Layoffs (Month-over-Month)
-- This helps identify if the layoff trend is accelerating or slowing down
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
