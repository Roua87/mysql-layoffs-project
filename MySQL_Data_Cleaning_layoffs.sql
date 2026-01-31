-- -- -- -- -- -- -- Cleaning Data -- -- -- -- -- --

SELECT *
FROM  layoffs1;

-- -- Removing duplicates --
WITH dup AS
(SELECT *, row_number () OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs1)
SELECT *
FROM dup
WHERE row_num>1;

CREATE TABLE layoffs2
SELECT *, row_number () OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs1;

DELETE 
FROM layoffs2
WHERE row_num>1;

-- --  Standardizing data -- --

-- Removing extra spaces 

UPDATE layoffs2
SET company=TRIM(company),
		location=TRIM(location),
		industry=TRIM(industry),
		stage=TRIM(stage),
		country=TRIM(country);

-- Standardizing date format
UPDATE layoffs2
SET `date`=str_to_date(`date`,'%m/%d/%Y');

ALTER TABLE layoffs2
MODIFY COLUMN `date` DATE;

-- Correcting the misspelling
UPDATE layoffs2
SET industry="Crypto"
where industry like "Crypto%";

UPDATE layoffs2
SET country=TRIM(TRAILING '.' FROM country)
where country like "United States%";

-- -- Null/Blancks values --
UPDATE layoffs2
SET industry=NULL
WHERE industry='';

-- Populate industry data
UPDATE layoffs2 t1
JOIN layoffs2 t2
ON t1.company=t2.company
SET t1.industry=t2.industry
WHERE t1.industry IS NULL and t2.industry IS NOT NULL;

DELETE 
FROM layoffs2 
WHERE total_laid_off IS NULL and percentage_laid_off IS NULL and funds_raised_millions IS NULL;

ALTER TABLE layoffs2
DROP COLUMN row_num;



