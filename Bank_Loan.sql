USE Bank_loan;
SELECT * FROM Finance_1;
SELECT * FROM Finance_2;


#KPI 1.1 Total Loan amount per Year
SELECT YEAR(issue_d) as Years,Loan_Status,CONCAT("$",(FORMAT(sum(loan_amnt)/1000000,1),"M") as 'Total Amount'
FROM Finance_1
GROUP BY YEAR(issue_d),Loan_Status
ORDER BY Years;

#KPI 1.2 Number of Loans per Year
SELECT YEAR(issue_d) as Years,count(loan_amnt) as 'Total Loans'
FROM Finance_1
GROUP BY YEAR(issue_d)
ORDER BY Years;


#KPI 2 Grade and sub-grade
SELECT grade,sub_grade,CONCAT("$",FORMAT(sum(revol_bal)/1000000,1),"M")
FROM Finance_1 
INNER JOIN Finance_2 
ON (Finance_1.id = Finance_2.id)
GROUP BY grade, sub_grade
ORDER BY grade, sub_grade;


#KPI 3.1 Verification vs Total Payment
SELECT verification_status,concat("$",Format(sum(total_pymnt)/1000000,0),"M") as 'Total Payment'
FROM Finance_1 
INNER JOIN Finance_2 
ON (Finance_1.id = Finance_2.id)
GROUP BY verification_status;

#KPI 3.2 Verification vs Total Payment
SELECT verification_status,
       CONCAT(ROUND(SUM(total_pymnt) / (SELECT SUM(total_pymnt)
                                        FROM Finance_1
                                        INNER JOIN Finance_2 
                                        ON Finance_1.id = Finance_2.id
                                        WHERE verification_status != 'Source Verified') * 100, 0), '%') AS 'Total Payment as % of Total'
FROM Finance_1
INNER JOIN Finance_2 
ON Finance_1.id = Finance_2.id
WHERE verification_status != 'Source Verified'
GROUP BY verification_status
ORDER BY verification_status;


#KPI 4 Average Interest rate
SELECT YEAR(issue_d) AS 'Year Issued',
	CONCAT(FORMAT(AVG(int_rate),0),' %') AS 'Average Interest %'
FROM Finance_1
GROUP BY YEAR(issue_d)
ORDER BY 'Year Issued';

#KPI 5 Loan Reason
SELECT Purpose AS 'Loan Reason', concat("$",FORMAT(sum(loan_amnt)/1000000,1),"M") AS 'Loan Amount'
FROM Finance_1
GROUP BY Purpose
ORDER BY 'Loan Amount';

#KPI 5.2 Top Loan Reason
WITH ranked_loans AS (
    SELECT YEAR(issue_d) AS loan_year,
           Purpose AS loan_reason,
           SUM(loan_amnt) AS total_loan,
           ROW_NUMBER() OVER (PARTITION BY YEAR(issue_d) ORDER BY SUM(loan_amnt) DESC) AS rn
    FROM Finance_1
    GROUP BY YEAR(issue_d), Purpose
)
SELECT loan_year AS 'Loan Year',
       loan_reason AS 'Top reason',
       CONCAT("$", FORMAT(total_loan / 1000000, 1), "M") AS 'Loan Amount'
FROM ranked_loans
WHERE rn = 1
ORDER BY loan_year;

#KPI 6 Top 10
SELECT ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS rank_num,
       addr_state,
       COUNT(*) AS state_count
FROM Finance_1
INNER JOIN Finance_2 
ON Finance_1.id = Finance_2.id
GROUP BY addr_state
ORDER BY rank_num
LIMIT 10;



