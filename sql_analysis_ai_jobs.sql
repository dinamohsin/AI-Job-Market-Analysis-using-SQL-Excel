-- General Job Info --
-- How many unique job titles are there in the dataset?
SELECT count(DISTINCT (job_title)) AS count_Job_Titles
FROM AI_Job;

-- What are the top 5 most frequent job titles?
SELECT TOP 5 job_title,count(job_title) AS job_count
FROM AI_Job
GROUP BY job_title
ORDER BY job_count DESC;


-- What is the total number of jobs by employment type?
SELECT  employment_type ,COUNT(employment_type) AS count_employment_type
FROM AI_Job
GROUP BY employment_type
ORDER BY COUNT_employment_type DESC;



-- Salary Analysis --
-- What is the average salary for each experience level?
SELECT experience_level ,AVG(salary_usd) AS AVG_Salary 
FROM AI_Job
GROUP BY experience_level
ORDER BY AVG_Salary DESC;

-- What are the top 5 job titles with the highest average salary?
SELECT TOP 5 job_title ,AVG(salary_usd)AS TOP_AVG_SALARY
FROM AI_Job
GROUP BY job_title
ORDER BY TOP_AVG_SALARY DESC;

/* Do employees who live in the same country 
   as their company earn higher salaries than those who 
   live in different countries?*/

-- Without using a CTE query involves repetition
/*SELECT
  (SELECT AVG(salary_usd)
   FROM AI_Job
   WHERE company_location = employee_residence) AS avg_salary_same_country,

  (SELECT AVG(salary_usd)
   FROM AI_Job
   WHERE company_location <> employee_residence) AS avg_salary_different_country,

  (SELECT AVG(salary_usd)
   FROM AI_Job
   WHERE company_location = employee_residence) -
  (SELECT AVG(salary_usd)
   FROM AI_Job
   WHERE company_location <> employee_residence) AS salary_difference;*/

WITH SalaryAvgs AS (
  SELECT
    (SELECT AVG(salary_usd)
     FROM AI_Job
     WHERE company_location = employee_residence) AS avg_salary_same_country,
  
    (SELECT AVG(salary_usd)
     FROM AI_Job
     WHERE company_location <> employee_residence) AS avg_salary_different_country
)
SELECT 
  avg_salary_same_country,
  avg_salary_different_country,
  avg_salary_same_country - avg_salary_different_country AS salary_difference
FROM SalaryAvgs;



-- Skills Analysis --
-- What is the difference in average salaries between employees who work fully remotely and those who work from the office?
SELECT remote_ratio, AVG(salary_usd) AS avg_salary
FROM AI_Job
WHERE remote_ratio IN ('Fully_remote', 'No_remote')
GROUP BY remote_ratio
ORDER BY avg_salary DESC;

-- What are the most common required skills in the dataset?
SELECT skill, COUNT(job_id) AS skill_count 
FROM (
  SELECT job_id, LTRIM(RTRIM(value)) AS skill
  FROM AI_Job
  CROSS APPLY STRING_SPLIT(required_skills, ',')   --gives us id an skill 
) AS cleaned_skills
GROUP BY skill
ORDER BY skill_count DESC;


-- What is the average salary for jobs that require Python?
SELECT AVG(salary_usd) AS avg_salary_python
FROM AI_Job
WHERE required_skills LIKE '%Python%';



-- Education --
-- What is the distribution of education levels required?
SELECT education_required, COUNT(job_id) AS job_count
FROM AI_Job
GROUP BY education_required
ORDER BY job_count DESC;