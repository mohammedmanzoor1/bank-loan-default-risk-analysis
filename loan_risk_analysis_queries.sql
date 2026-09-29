--select * from Loan_default_cleanset

--1Q.What is the overall default rate across the loan portfolio,
SELECT COUNT(*) AS total_loans,
COUNT(CASE WHEN loan_default = 1 THEN 1 END) AS default_loans,
CAST(ROUND( 100.0 * COUNT(CASE WHEN loan_default = 1 THEN 1 END) / COUNT(*),2)AS DECIMAL(5,2)) AS default_rate
FROM Loan_default_cleanset;

--2Q. How does it vary by loan purpose?
SELECT loan_purpose,
COUNT(*) AS total_loans,
COUNT(CASE WHEN loan_default = 1 THEN 1 END) AS default_loans,
CAST( ROUND(100.0 * COUNT(CASE WHEN loan_default = 1 THEN 1 END) / COUNT(*), 2 )AS DECIMAL(5,2)) AS default_rate
FROM Loan_default_cleanset
GROUP BY loan_purpose
ORDER BY default_rate DESC;


--3Q.  How does the Debt-to-Income (DTI) ratio impact default risk?
SELECT dti_band,
COUNT(*) AS total_loans,
COUNT(CASE WHEN loan_default = 1 THEN 1 END) AS default_loans,
CAST(ROUND(100.0 * COUNT(CASE WHEN loan_default = 1 THEN 1 END) / COUNT(*), 2 ) AS DECIMAL(5,2)) AS default_rate
FROM Loan_default_cleanset
GROUP BY dti_band
ORDER BY default_rate DESC;

--4Q.  What is the relationship between credit score bands and default rates?
SELECT credit_score_band,
COUNT(*) AS total_loans,
COUNT(CASE WHEN loan_default = 1 THEN 1 END) AS default_loans,
CAST(ROUND( 100.0 * COUNT(CASE WHEN loan_default = 1 THEN 1 END) / COUNT(*), 2 )AS DECIMAL(5,2)) AS default_rate
FROM Loan_default_cleanset
GROUP BY credit_score_band
ORDER BY default_rate DESC;

--5Q.  How does EMI burden (EMI as a percentage of income) affect loan default?
SELECT CASE
WHEN emi_to_income < 20 THEN 'Low'
WHEN emi_to_income < 40 THEN 'Medium'
ELSE 'High'
END AS emi_burden,
COUNT(*) AS total_loans,
COUNT(CASE WHEN loan_default = 1 THEN 1 END) AS default_loans,
CAST(ROUND(100.0 * COUNT(CASE WHEN loan_default = 1 THEN 1 END) / COUNT(*), 2)AS DECIMAL(5,2)) AS default_rate
FROM Loan_default_cleanset
GROUP BY
CASE
WHEN emi_to_income < 20 THEN 'Low'
WHEN emi_to_income < 40 THEN 'Medium'
ELSE 'High'
END
ORDER BY default_rate DESC;


--6Q.  Does employment tenure (months employed) influence default probability?
SELECT tenure_stability,
COUNT(*) AS total_loans,
COUNT(CASE WHEN loan_default = 1 THEN 1 END) AS default_loans,
CAST(ROUND(100.0 * COUNT(CASE WHEN loan_default = 1 THEN 1 END) / COUNT(*),2)
AS DECIMAL(5,2)) AS default_rate
FROM Loan_default_cleanset
GROUP BY tenure_stability
ORDER BY default_rate DESC;


--7Q. Is there a significant difference in default rates between borrowers with and without a co-signer or mortgage?
SELECT has_co_signer,
COUNT(*) AS total_loans,
COUNT(CASE WHEN loan_default = 1 THEN 1 END) AS default_loans,
CAST(ROUND(100.0 * COUNT(CASE WHEN loan_default = 1 THEN 1 END) / COUNT(*),2)AS DECIMAL(5,2)) AS default_rate
FROM Loan_default_cleanset
GROUP BY has_co_signer
ORDER BY default_rate DESC;

--Mortgage
SELECT has_mortgage,
COUNT(*) AS total_loans,
COUNT(CASE WHEN loan_default = 1 THEN 1 END) AS default_loans,
CAST(ROUND(100.0 * COUNT(CASE WHEN loan_default = 1 THEN 1 END) / COUNT(*), 2 )AS DECIMAL(5,2)) AS default_rate
FROM Loan_default_cleanset
GROUP BY has_mortgage
ORDER BY default_rate DESC;

--8Q.  Which combination of factors creates the highest-risk borrower segment?
SELECT TOP 10 credit_score_band,dti_band,tenure_stability,
COUNT(*) AS total_loans,
COUNT(CASE WHEN loan_default = 1 THEN 1 END) AS default_loans,
CAST(ROUND( 100.0 * COUNT(CASE WHEN loan_default = 1 THEN 1 END) / COUNT(*),2 )
AS DECIMAL(5,2)) AS default_rate
FROM Loan_default_cleanset
GROUP BY
credit_score_band,
dti_band,
tenure_stability
HAVING COUNT(*) >= 20
ORDER BY default_rate DESC;