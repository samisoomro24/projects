-- Exploratory Data Analysis

SELECT *
from layoffs_staging2;

SELECT max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

SELECT *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;


SELECT company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

SELECT min(date), max(date)
from layoffs_staging2;

SELECT industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

SELECT country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

SELECT year(date), sum(total_laid_off)
from layoffs_staging2
group by year(date)
order by 1 desc;

SELECT stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

SELECT company, avg(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select *
from layoffs_staging2;

select substring(date,1,7) as Month, sum(total_laid_off)
from layoffs_staging2
where substring(date,1,7) is NOT NULL
group by Month
order by 1 asc;

WITH Rolling_Total AS
(
select substring(date,1,7) as Month, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(date,1,7) is NOT NULL
group by Month
order by 1 asc
)
SELECT Month, total_off, sum(total_off) OVER(ORDER BY Month) as rolling_total
from Rolling_Total;

SELECT company, YEAR(date), sum(total_laid_off)
from layoffs_staging2
group by company, YEAR(date)
order by 3 desc;


WITH company_year (company, years, total_laid_off) AS
(
SELECT company, YEAR(date), sum(total_laid_off)
from layoffs_staging2
group by company, YEAR(date)
), 
company_year_rank as
(
select *, 
dense_rank() over(partition by years order by total_laid_off desc) as Ranking
from company_year
where years IS NOT NULL
)
select *
from company_year_rank
where ranking <=5