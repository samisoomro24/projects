-- Data Cleaning in MYSQL
-- In this process we fix raw data into useful form

SELECT *
from layoffs;

-- 1. Remove Duplicates
-- 2. Standarize the Data e.g. Spelling Mistakes
-- 3. Null or Blank Values
-- 4. Remove Columns or row if necessary


CREATE TABLE layoffs_staging
LIKE layoffs; -- This will create table like layoffs 

SELECT *
from layoffs_staging;

INSERT layoffs_staging
SELECT *
from layoffs;  -- This will insert the data same as mentioned table

select *
from layoffs;

select *
from layoffs_staging;
-- 1. Remove Duplicates
WITH duplicate_cte as
(
select *,
ROW_NUMBER() 
OVER(partition by company, location,
industry, total_laid_off, percentage_laid_off, 'date', stage,
country, funds_raised_millions) as row_num
from layoffs_staging
)
SELECT *
from duplicate_cte
where row_num > 1;

-- To delete this we need to create another table 

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num`int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT into layoffs_staging2
select *,
ROW_NUMBER() 
OVER(partition by company, location,
industry, total_laid_off, percentage_laid_off, 'date', stage,
country, funds_raised_millions) as row_num
from layoffs_staging;

delete 
from layoffs_staging2
where row_num > 1;

select *
from layoffs_staging2;

-- 2. Standarize the Data e.g. Spelling Mistakes
select company, trim(company)
from layoffs_staging2;

UPDATE layoffs_staging2
SET company = trim(company);

select distinct industry
from layoffs_staging2
order by 1;  -- It will order by 1 so that we can check if there is null value

select *
from layoffs_staging2
where industry LIKE 'crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
where industry like 'Crypto%';

select *
from layoffs_staging2
where industry LIKE 'crypto%';

select distinct location
from layoffs_staging2
order by 1; -- It will order by 1 so that we can check if there is null value

select distinct country
from layoffs_staging2
order by 1; -- It will order by 1 so that we can check if there is null value

select distinct country
from layoffs_staging2
where country like 'United States%'
order by 1;

-- So there is dot in the end of united states
UPDATE layoffs_staging2
set country = Trim(Trailing '.' from country)
where country like 'United States%';

-- Update date column to standarize 
update layoffs_staging2
SET date = str_to_date(date, '%m/%d/%Y');

select date
from layoffs_staging2;

-- change into date column
ALTER TABLE layoffs_staging2
MODIFY COLUMN date date;

-- -- 3. Null or Blank Values
select *
from layoffs_staging2
where total_laid_off IS NULL
AND percentage_laid_off IS NULL;

select *
from layoffs_staging2
where industry is NULL
OR industry = '';

select *
from layoffs_staging2
where company = 'Airbnb';

UPDATE layoffs_staging2
set industry = NULL
where industry = '';

SELECT t1.industry, t2.industry
from layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL; 

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2. industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL; 

select *
from layoffs_staging2;

select *
from layoffs_staging2
where total_laid_off IS NULL
AND percentage_laid_off IS NULL;  

delete  -- we don't need these null values so we are deleting 
from layoffs_staging2
where total_laid_off IS NULL
AND percentage_laid_off IS NULL;

select *
from layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num; -- drop row_num b/c we don't need it anymore 

select *
from layoffs_staging2;