-- Data Cleaning--
-- World layoff Project --

select * from layoffs;

-- 1. Remove Duplicates
-- 2. Standarlize the Data
-- 3. Null values or blank values
-- 4. Remove any Columns

Create table layoffs_staging 
like layoffs;


select * from layoffs_staging;

Insert layoffs_staging
select *
from layoffs;


SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company,industry, total_laid_off, percentage_laid_off, `date`) AS row_num
from layoffs_staging;


WITH duplicate_cte AS
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions) AS row_num
from layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT * 
FROM layoffs_staging
WHERE company = 'Casper';


WITH duplicate_cte AS
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions) AS row_num
from layoffs_staging
)
DELETE
FROM duplicate_cte
WHERE row_num > 1;


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
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;




INSERT INTO layoffs_staging2
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions) AS row_num
from layoffs_staging;


Select *
FROM layoffs_staging2;

-- Standardizing data


SELECT company, trim(company)
FROM layoffs_staging2;


Update layoffs_staging2
SET company = TRIM(company);

-- triming . from country

SELECT Distinct industry
FROM layoffs_staging2;


SELECT Distinct country, trim(TRAILING '.' from country)
FROM layoffs_staging2
order by 1;


Update layoffs_staging2
set country = trim(TRAILING '.' from country)
where country like 'United States%';


-- modifying date 

SELECT `date`
FROM layoffs_staging2;

Update layoffs_staging2
set `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
modify column `date` DATE;



-- Working on Null and blank values

SELECT *
FROM layoffs_staging2
where total_laid_off IS NULL
AND percentage_laid_off is null; 


SELECT *
FROM layoffs_staging2
where industry is null
or industry = '';

-- Joining the same table for working on null's

Select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

-- updating the airbnb industry

update layoffs_staging2
set industry = 'travel'
where company like 'Airbnb';

-- Deleting row where total_laif_off and percentage_laid_off is null.
Delete
FROM layoffs_staging2
where total_laid_off IS NULL
AND percentage_laid_off is null; 

-- Removed row_num column

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

select *
from layoffs_staging2;



