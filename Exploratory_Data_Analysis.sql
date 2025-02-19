-- Exploratory Data Analysis -- 

select *
from layoffs_staging2;


select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

-- Dates of the layoffs
select min(`date`), max(`date`)
from layoffs_staging2;


select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

-- year of layoffs
select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;


select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;


select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;


-- per month data using substring
SELECT substring(`date`,1,7) as `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc;

-- rolling total of the layoffs per every month using sub string

WITH Rolling_total AS
(
SELECT substring(`date`,1,7) as `month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
)
select `month`, total_off
,sum(total_off) over(order by `month`) as rolling_total
from Rolling_total;




select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;



select company, year(`date`),  sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc;

-- Top 5 Rank of each company layoffs per year and therir ranking using multiple CTE
with company_year (company, years, total_laid_off) as
(
select company, year(`date`),  sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
), Company_Year_Rank as
(select *, dense_rank() over (partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
select * 
from Company_Year_Rank
where Ranking <= 5;





