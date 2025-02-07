USE Bank_loan;
SELECT * FROM Finance_1;
SELECT * FROM Finance_2;


#KPI 1 Total Loan amount per Year
SELECT year(issue_d) as Years,FORMAT(sum(loan_amnt),0) as 'Total Amount'
FROM Finance_1
GROUP BY Years
ORDER BY Years;

#KPI 2 Number of Loans per Year
SELECT year(issue_d) as Years,count(loan_amnt) as 'Total Loans'
FROM Finance_1
GROUP BY Years
ORDER BY Years;

# KPI 3 Grade and sub-grade
SELECT grade,sub_grade,FORMAT(sum(revol_bal),0) FROM Finance_1 
INNER JOIN Finance_2 
ON (Finance_1.id = Finance_2.id)
GROUP BY grade, sub_grade
ORDER BY grade, sub_grade;


#KPI 5 Verification vs Total Payment
SELECT verification_status,concat("$",Format(sum(total_pymnt)/1000000,0),"M") as 'Total Payment'
FROM Finance_1 
INNER JOIN Finance_2 
ON (Finance_1.id = Finance_2.id)
GROUP BY verification_status;

#KPI 6 Average Interest rate
SELECT year(issue_d),int_rate/(SELECT count(*) FROM Finance_1)*100 as 'Average Interest'
FROM Finance_1
GROUP BY issue_d ;

