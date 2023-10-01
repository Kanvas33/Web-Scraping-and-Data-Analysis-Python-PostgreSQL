create table companies_revenue(
rank_ int primary key,
name_ varchar(50),
industry varchar(50),
revenue_usd_millions int,
revenue_growth_percent numeric(5,3),
employees int,
headquarters varchar(100)
);

select * from companies_revenue;

--Company rank, name and revenue from top 100 companies in USA
select rank_,  name_ , revenue_usd_millions
from companies_revenue;

--Create two separate columns for headquarters, one for the city and another for the state
--Add new columns for city and state
ALTER TABLE companies_revenue
ADD COLUMN headquarters_city text,
ADD COLUMN headquarters_state text;
--Update the new columns with city and state information
UPDATE companies_revenue
SET
headquarters_city = SUBSTRING(headquarters FROM 1 FOR POSITION(',' IN headquarters) - 1),
headquarters_state = SUBSTRING(headquarters FROM POSITION(',' IN headquarters) + 2);

--Company rank, name, industry, and headuquarters in New York City.
SELECT rank_,  name_ AS company_name, industry, headquarters
FROM companies_revenue
WHERE headquarters = 'New York City, New York'
GROUP BY rank_, name_, industry, headquarters
order by rank_;

--Total number of companies per city
SELECT headquarters, COUNT(*) AS total_companies
FROM companies_revenue
GROUP BY headquarters
order by total_companies desc;

--Total number of companies and name where the revenue is between 300.000.000 and 600.000.000 with the headquarters located in Washington.
--revenue order: descending
SELECT rank_, name_, headquarters, COUNT(*) AS total_companies, revenue_usd_millions
FROM companies_revenue
where revenue_usd_millions between 300000 and 600000 and  headquarters ilike '%Washington%'
GROUP BY rank_, name_, headquarters, revenue_usd_millions
order by revenue_usd_millions desc;

--Company rank, name, revenue in millions(usd) from all the headquarters in California, ordered from the highest to the lowest.
--ilike is not case sensitive operator
select rank_, name_, revenue_usd_millions
from companies_revenue
where headquarters ilike '%California%'
group by revenue_usd_millions, name_, rank_
order by revenue_usd_millions desc;

--Company rank,  name, headquarters and industry(healthcare industry only)
select rank_, industry, name_, headquarters from companies_revenue
where industry = 'Healthcare';

--Company rank,  name, industry and employee where revenue growth is bigger than 30%
--revenue order: descending
select rank_, name_, industry, employees, revenue_growth_percent *100 as growth_percent from companies_revenue
where revenue_growth_percent > 0.300
order by revenue_growth_percent desc ;

--Average revenue in millions from top 100 companies in USA.
select avg(revenue_usd_millions) as sum_total_companies_revenue 
from companies_revenue;

--Top 10 Companies with the highest revenue per employee.
SELECT rank_, name_, industry, revenue_usd_millions, employees,
       revenue_usd_millions / employees AS revenue_per_employee
FROM companies_revenue
ORDER BY revenue_per_employee DESC
LIMIT 10;

--Company name, indsutry with more than 1000.000 employees on descending order
select rank_ ,name_, industry, employees from companies_revenue
where employees >= 100000
order by employees desc;

--Top 10 companies with the fewest number of employees.
SELECT rank_, name_, employees
FROM companies_revenue
ORDER BY employees
LIMIT 10;

--Counting how many companies have more than 100.000 employees
SELECT COUNT(*) AS number_of_companies
FROM companies_revenue
WHERE employees > 100000;

--Headquarters where the revenue growth were superior to 50% and its rank
select rank_, headquarters, revenue_growth_percent * 100 as percentage_revenue_growth from companies_revenue
where revenue_growth_percent > 0.500
order by revenue_growth_percent desc;

--Counting how many companies have revenue growth superior to 50%
select count(*) as headquarters_number_growth_superior_50_percent 
from companies_revenue
where revenue_growth_percent > 0.500;

--Top 10 companies with the highest revenue growth percentage.
SELECT rank_, name_, revenue_growth_percent *100
FROM companies_revenue
ORDER BY revenue_growth_percent DESC
LIMIT 10;

--Top 10 Companies with the lowest revenue growth percentage.
SELECT rank_, name_, revenue_growth_percent *100
FROM companies_revenue
ORDER BY revenue_growth_percent
LIMIT 10;

--Retrieve the top industries by total revenue, ordered from highest to lowest.
SELECT industry, SUM(revenue_usd_millions) AS total_revenue
FROM companies_revenue
GROUP BY industry
ORDER BY total_revenue DESC;

--The average revenue (in millions of USD) for each industry represented in the companies_revenue 
--avg_revenue descending order based on the calculated average revenue
SELECT industry, AVG(revenue_usd_millions) AS avg_revenue
FROM companies_revenue
GROUP BY industry
order by avg_revenue desc;

--Companies in "Technology" industry along with their revenue and rank.
SELECT rank_, name_, revenue_usd_millions
FROM companies_revenue
WHERE industry = 'Technology'
ORDER BY rank_;

--Companies with negative revenue growth.
SELECT rank_, name_, industry, revenue_growth_percent
FROM companies_revenue
WHERE revenue_growth_percent < 0;

--Average number of employees for each industry.
SELECT industry, AVG(employees) AS avg_employees
FROM companies_revenue
GROUP BY industry
ORDER BY avg_employees DESC;


-- To drop the table(if needed)
drop table companies_revenue;
