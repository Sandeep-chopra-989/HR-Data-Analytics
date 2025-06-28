
--  Step 1: Create Table 


-- Create the HR data table
CREATE TABLE hrdata (
    emp_no BIGINT PRIMARY KEY,
    gender VARCHAR(50) NOT NULL,
    marital_status VARCHAR(50),
    age_band VARCHAR(50),
    age INT,
    department VARCHAR(50),
    education VARCHAR(50),
    education_field VARCHAR(50),
    job_role VARCHAR(50),
    business_travel VARCHAR(50),
    employee_count INT,
    attrition VARCHAR(50),
    attrition_label VARCHAR(50),
    job_satisfaction INT,
    active_employee INT
);


--  Step 2: Import Data 


-- Load data from a CSV file (adjust path as needed)
COPY hrdata FROM 'C:/Users/тс/Desktop/Projects/Complete Project/SQL/hrdata.csv' 
DELIMITER ',' 
CSV HEADER;



--  Step 3: Key Metrics with Queries 



--  1. Total Number of Employees


-- Total employee count (active + attrited)
SELECT SUM(employee_count) AS employee_count 
FROM hrdata;




--  2. Total Attritions


-- Total number of employees who left (Attrition = 'Yes')
SELECT COUNT(*) AS attrition_count 
FROM hrdata 
WHERE attrition = 'Yes';




--  3. Attrition Rate (%)


-- Attrition rate = (Attrited Employees / Total Employees) * 100
SELECT 
    ROUND(
        (SELECT COUNT(*) FROM hrdata WHERE attrition = 'Yes')::NUMERIC 
        / SUM(employee_count) * 100, 2
    ) AS attrition_rate
FROM hrdata;

--  4. Active Employees (Still Working)


-- Active = Total Employees - Attrited Employees
SELECT 
    SUM(employee_count) - (SELECT COUNT(*) FROM hrdata WHERE attrition = 'Yes') 
    AS active_employees
FROM hrdata;


--  5. Average Employee Age

-- Calculate the average age of employees
SELECT ROUND(AVG(age), 0) AS average_age 
FROM hrdata;



--  6. Attrition Count by Gender


-- Attrition grouped by gender
SELECT gender, COUNT(*) AS attrition_count 
FROM hrdata
WHERE attrition = 'Yes'
GROUP BY gender
ORDER BY attrition_count DESC;




--  7. Department-wise Attrition %

-- Department-wise attrition and % of total attrition
SELECT 
    department, 
    COUNT(*) AS attrition_count,
    ROUND((COUNT(*)::NUMERIC / 
        (SELECT COUNT(*) FROM hrdata WHERE attrition = 'Yes')) * 100, 2) AS attrition_pct
FROM hrdata
WHERE attrition = 'Yes'
GROUP BY department
ORDER BY attrition_count DESC;



--  8. No. of Employees by Age


-- Count employees by exact age
SELECT age, SUM(employee_count) AS total_employees
FROM hrdata
GROUP BY age
ORDER BY age;


--  9. Attrition by Education Field

-- Which education field shows the most attrition?
SELECT education_field, COUNT(*) AS attrition_count
FROM hrdata
WHERE attrition = 'Yes'
GROUP BY education_field
ORDER BY attrition_count DESC;


--- 10. Attrition by Age Band & Gender


-- Gender-wise attrition in each age band
SELECT 
    age_band, 
    gender, 
    COUNT(*) AS attrition,
    ROUND(
        COUNT(*)::NUMERIC / (SELECT COUNT(*) FROM hrdata WHERE attrition = 'Yes') * 100, 2
    ) AS attrition_pct
FROM hrdata
WHERE attrition = 'Yes'
GROUP BY age_band, gender
ORDER BY age_band, gender DESC;


