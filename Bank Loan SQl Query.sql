create database bank_loan_db;
use bank_loan_db;
CREATE TABLE bank_loan_data (
    id INT,
    address_state VARCHAR(10),
    application_type VARCHAR(50),
    emp_length VARCHAR(50),
    emp_title VARCHAR(100),
    grade VARCHAR(5),
    home_ownership VARCHAR(20),
    issue_date DATE,
    last_credit_pull_date DATE,
    last_payment_date DATE,
    loan_status VARCHAR(50),
    next_payment_date DATE,
    member_id BIGINT,
    purpose VARCHAR(50),
    sub_grade VARCHAR(50),
    term VARCHAR(50),
    verification_status VARCHAR(50),
    annual_income FLOAT,
    dti FLOAT,
    installment FLOAT,
    int_rate FLOAT,
    loan_amount INT,
    total_acc TINYINT,
    total_payment INT
);


LOAD DATA INFILE "D:\financial loan data.csv"
INTO TABLE bank_loan_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select* from bank_loan_data;


                                        -- KEY PERFORMANCE INDICATORS (KPIs)

-- 1.Total Loan Applications: We need to calculate the total number of loan applications received during a specified period.  
-- Additionally, it is essential to monitor the Month-to-Date (MTD) Loan Applications and track changes Month-over-Month (MoM).

select count(id) as Total_Loan_Applications
from bank_loan_data;

select count(id) as MTD_Total_Loan_Applications
from bank_loan_data
where month(issue_date) = 12 and year (issue_date) = 2021;

select count(id) as PMTD_Total_Loan_Applications
from bank_loan_data
where month(issue_date) = 11 and year (issue_date) = 2021;

-- (MTD-PMTD)/PMTD


-- 2.	2.	Total Funded Amount: Understanding the total amount of funds disbursed as loans is crucial.
--  We also want to keep an eye on the MTD Total Funded Amount and analyse the Month-over-Month (MoM) changes in this metric.

select sum(loan_amount) as Total_Funded_Amount
from bank_loan_data;

select sum(loan_amount) as MTD_Total_Funded_Amount
from bank_loan_data
where month(issue_date) = 12 and year (issue_date) = 2021;

select sum(loan_amount) as PMTD_Total_Funded_Amount
from bank_loan_data
where month(issue_date) = 11 and year (issue_date) = 2021;

-- (MTD-PMTD)/PMTD


-- 3.Total Amount Received: Tracking the total amount received from borrowers is essential for assessing the bank's cash flow and loan repayment.
--  We should analyse the Month-to-Date (MTD) Total Amount Received and observe the Month-over-Month (MoM) changes.

select sum(total_payment) as Total_Amount_Received
from bank_loan_data;

select sum(total_payment) as MTD_Total_Amount_Received
from bank_loan_data
where month(issue_date) = 12 and year (issue_date) = 2021;

select sum(total_payment) as PMTD_Total_Amount_Received
from bank_loan_data
where month(issue_date) = 11 and year (issue_date) = 2021;

-- (MTD-PMTD)/PMTD


-- 4.Average Interest Rate: Calculating the average interest rate across all loans, MTD, 
-- and monitoring the Month-over-Month (MoM) variations in interest rates will provide insights into our lending portfolio's overall cost.

select ROUND(AVG(int_rate), 5)*100 as Average_Interest_Rate
from bank_loan_data;

select ROUND(AVG(int_rate), 5)*100 as MTD_Average_Interest_Rate
from bank_loan_data
where month(issue_date) = 12 and year (issue_date) = 2021;

select ROUND(AVG(int_rate), 5)*100 as PMTD_Average_Interest_Rate
from bank_loan_data
where month(issue_date) = 11 and year (issue_date) = 2021;

-- (MTD-PMTD)/PMTD


-- 5.Average Debt-to-Income Ratio (DTI): Evaluating the average DTI for our borrowers helps us gauge their financial health.
-- We need to compute the average DTI for all loans, MTD, and track Month-over-Month (MoM) fluctuations.

select ROUND(AVG(dti), 5)* 100 as Average_DTI
from bank_loan_data;

select ROUND(AVG(dti), 5)* 100 as MTD_Average_DTI
from bank_loan_data
where month(issue_date) = 12 and year (issue_date) = 2021;

select ROUND(AVG(dti), 5)* 100 as PMTD_Average_DTI
from bank_loan_data
where month(issue_date) = 11 and year (issue_date) = 2021;


                                                           -- GOOD LOAN vs BAD LOAN KPI’s
                                                           
																-- GOOD LOAN KPI’s
																													
-- 1.Good Loan Application Percentage: We need to calculate the percentage of loan applications classified as 'Good Loans.' 
-- This category includes loans with a loan status of 'Fully Paid' and 'Current.'

SELECT 
    (SUM(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN 1 ELSE 0 END) * 100.0) / 
    COUNT(id) AS Good_Loan_Application_Percentage
FROM bank_loan_data;


-- 2.	Good Loan Applications: Identifying the total number of loan applications falling under the 'Good Loan' category, 
-- which consists of loans with a loan status of 'Fully Paid' and 'Current.'

select count(id) as Good_Loan_Application
from bank_loan_data
where loan_status = 'Fully Paid' or loan_status = 'Current';


-- 3.	Good Loan Funded Amount: Determining the total amount of funds disbursed as 'Good Loans.' 
-- This includes the principal amounts of loans with a loan status of 'Fully Paid' and 'Current.'

select SUM(loan_amount) as Good_Loan_Funded_Amount
from bank_loan_data
where loan_status = 'Fully Paid' or loan_status = 'Current';


-- 4.	Good Loan Total Received Amount: Tracking the total amount received from borrowers for 'Good Loans,' 
-- which encompasses all payments made on loans with a loan status of 'Fully Paid' and 'Current.

select SUM(total_payment) as Good_Loan_Total_Received_Amount
from bank_loan_data
where loan_status = 'Fully Paid' or loan_status = 'Current';


                                                                    -- BAD LOAN KPIs:
                                                                    
-- 1.	Bad Loan Application Percentage: Calculating the percentage of loan applications categorized as 'Bad Loans.' 
-- This category specifically includes loans with a loan status of 'Charged Off.'

SELECT 
    (SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0) / 
    COUNT(id) AS Bad_Loan_Application_Percentage
FROM bank_loan_data;


-- 2.	Bad Loan Applications: Identifying the total number of loan applications categorized as 'Bad Loans,' 
-- which consists of loans with a loan status of 'Charged Off.'

select count(id) as Bad_Loan_Application
from bank_loan_data
where loan_status = 'Charged Off';

-- 3.	Bad Loan Funded Amount: Determining the total amount of funds disbursed as 'Bad Loans.' 
-- This comprises the principal amounts of loans with a loan status of 'Charged Off.'

select SUM(loan_amount) as Bad_Loan_Funded_Amount
from bank_loan_data
where loan_status = 'Charged Off';

-- 4.	Bad Loan Total Received Amount: Tracking the total amount received from borrowers for 'Bad Loans,' 
-- which includes all payments made on loans with a loan status of 'Charged Off.'

select SUM(total_payment) as Bad_Loan_Total_Received_Amount
from bank_loan_data
where loan_status = 'Charged Off';


                                                            -- LOAN STATUS

SELECT 
loan_status,
	COUNT(id) as Loan_Count,
	SUM(total_payment) AS Total_Amount_Received,
	SUM(loan_amount) AS Total_Funded_Amount,
	AVG(int_rate * 100) AS Interest_Rate,
	AVG(dti * 100) AS DTI
from bank_loan_data
GROUP BY loan_Status;


SELECT 
	loan_status, 
    SUM(total_payment) AS MTD_Total_Amount_Received, 
	SUM(loan_amount) AS MTD_Total_Funded_Amount 
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 
GROUP BY loan_status;


                                                   -- B.	BANK LOAN REPORT | OVERVIEW
                                                   
																-- MONTH
SELECT 
    MONTH(issue_date) AS Month_Number, 
    MONTHNAME(issue_date) AS Month_name, 
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY MONTH(issue_date), MONTHNAME(issue_date)
ORDER BY MONTH(issue_date);
                                                   
																			--  STATE
SELECT 
	address_state AS State, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY address_state
ORDER BY COUNT(id) desc;

                                                                   --  Loan Term
                                                                   
SELECT 
	term as loan_term, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY term
ORDER BY term;

                                                                -- EMPLOYEE LENGTH                                                                 
SELECT 
	emp_length as Employee_Length, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY emp_length
ORDER BY emp_length;
                                                                 
                                                                  -- PURPOSE
SELECT 
	purpose as PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY purpose
ORDER BY purpose;

                                                               --  HOME OWNERSHIP   
                                                               
SELECT 
	home_ownership as Home_Ownership, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY home_ownership
ORDER BY home_ownership;                                      
                                                                    
                                                                    

-- filters
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
WHERE grade = 'A'
GROUP BY purpose
ORDER BY purpose
                         