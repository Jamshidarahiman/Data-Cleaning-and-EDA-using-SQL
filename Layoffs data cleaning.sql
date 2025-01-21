select * 
from layoffs;

-- create staging table

create table layoffs_staging
like layoffs;

select * 
from layoffs_staging;

insert layoffs_staging
select *
from layoffs;

select * 
from layoffs_staging;

-- Removing duplicates

-- partition by different coloumns to get row number
select * , 
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, 'date' ) AS row_num
from layoffs_staging;

-- create a CTE for finding duplicates

with duplicate_cte as
(
select * , 
row_number() over(
partition by company,location, industry, total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions ) AS row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num > 1;

-- checking whether the selected rows have duplicates
select * 
from layoffs_staging
where company = 'Casper';

-- Deleting duplicates
with duplicate_cte as
(
select * , 
row_number() over(
partition by company,location, industry, total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions ) AS row_num
from layoffs_staging
)
delete
from duplicate_cte
where row_num > 1;

-- deleting the actual column

-- creating table with row_num column
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

select * 
from layoffs_staging2;

insert into layoffs_staging2
select * , 
row_number() over(
partition by company,location, industry, total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions ) AS row_num
from layoffs_staging;

select * 
from layoffs_staging2;

select * 
from layoffs_staging2
where row_num >1;

delete 
from layoffs_staging2
where row_num >1;

select * 
from layoffs_staging2
where row_num >1;

select * 
from layoffs_staging2;

-- Standardising Data

select distinct(TRIM(company))
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select distinct(industry)
from layoffs_staging2
order by 1;

select *
from layoffs_staging2
where industry LIKE 'Crypto%';

update layoffs_staging2
set industry = 'crypto'
where industry LIKE 'Crypto%';

select distinct location
from layoffs_staging2
order by 1;

select distinct country
from layoffs_staging2
order by 1;

select *
from layoffs_staging2
where country like 'United States%';

select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country LIKE 'United States%';

select * 
from layoffs_staging2;

-- Changing date type

select `date`,
str_to_date(`date`,'%m/%d/%Y') 
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`,'%m/%d/%Y') ;

select `date`
from layoffs_staging2;

-- to change to a date column
alter table layoffs_staging2
modify column `date` date;

select *
from layoffs_staging2;

-- Handling null Values
select *
from layoffs_staging2
where total_laid_off is NULL;

select *
from layoffs_staging2
where total_laid_off is NULL and percentage_laid_off is NULL;

select distinct industry
from layoffs_staging2;

select *
from layoffs_staging2
where industry is NULL or industry = '';

select *
from layoffs_staging2
where company = 'Airbnb';

select*
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
where (t1.industry is NULL or t1.industry = '')
and t2.industry is NOT NULL;

-- changing blanks to null
update layoffs_staging2
set industry = null
where industry = '';


update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is NULL and t2.industry is NOT NULL;

select *
from layoffs_staging2
where industry is NULL or industry = '';

select *
from layoffs_staging2
where company like 'Bally%';

select *
from layoffs_staging2;

-- checking with nulls in total_laid_off and percentage_laid_off
select *
from layoffs_staging2
where total_laid_off is NULL and percentage_laid_off is NULL;

delete
from layoffs_staging2
where total_laid_off is NULL and percentage_laid_off is NULL;

select *
from layoffs_staging2;

-- deleting a column
alter table layoffs_staging2
drop column row_num;

