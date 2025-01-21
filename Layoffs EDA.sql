-- Exploratory Data Analysis

select *
from layoffs_staging2;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

select *
from layoffs_staging2
where percentage_laid_off = 1;

select count(company)
from layoffs_staging2
where percentage_laid_off = 1;

select *
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;

select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select MIN(`date`), MAX(`date`)
from layoffs_staging2;

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

select `date`, sum(total_laid_off)
from layoffs_staging2
group by `date`
order by 2 desc;


select `date`, sum(total_laid_off)
from layoffs_staging2
group by `date`
order by 1 desc;

select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;

select stage,  sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;


select company, AVG(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc;


-- To select month from date

select month(`date`)
from layoffs_staging2;

select substring(`date`, 6,2) AS `Month` 
from layoffs_staging2;

select substring(`date`, 1,7) AS `Month` , sum(total_laid_off)
from layoffs_staging2
where substring(`date`, 1,7) is not null
group by `Month`
order by 1 ASC;

-- Total Layoffs by each month
with Rolling_Total AS
(
select substring(`date`, 1,7) AS `Month` , sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`, 1,7) is not null
group by `Month`
order by 1 ASC
)
select `Month`, total_off, sum(total_off) OVER( order by `Month`) AS rollingtotal
from Rolling_Total;

-- Company laidoff by year
select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select company,year( `date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 1 asc;

-- Rank company 
select company,year( `date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc;


with Company_Year(company, years, total_laid_off)  as
(
select company,year( `date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
)
select *, dense_rank() over( partition by years order by total_laid_off desc)  as ranking
from Company_Year
where years is not null
order by ranking asc;


with Company_Year(company, years, total_laid_off)  as
(
select company,year( `date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
), Company_Year_Rank as
(
select *, dense_rank() over( partition by years order by total_laid_off desc)  as ranking
from Company_Year
where years is not null
)
select *
from Company_Year_Rank
where ranking <= 5;











