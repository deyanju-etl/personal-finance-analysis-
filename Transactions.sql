

SELECT *
FROM [Transactions ]
;

SELECT *
FROM Budget
;





-- Total Income 

SELECT ROUND(SUM(Amount),2) AS Total_Income 
FROM [Transactions ]
WHERE Transaction_Type = 'credit'
;


-- Total Expenses 

SELECT ROUND(SUM(Amount),2) AS Total_Income 
FROM [Transactions ]
WHERE Transaction_Type = 'debit'
;


-- Total Net-Flow 

SELECT ROUND(SUM(Net_Flow), 2) AS total_netflow
FROM [Transactions ]
;


-- Sum of variance 

SELECT ROUND(SUM(Variance), 2) AS sum_of_variance 
FROM [Transactions ]
;


-- Total Budget vs Actual Spending by Category

SELECT 
    b.Category,
    b.Budget AS Budgeted_Amount,
    ROUND(SUM(t.Amount),2) AS Actual_Spending,
    (b.Budget - SUM(t.Amount)) AS Variance
FROM Budget b
LEFT JOIN [Transactions ] t
    ON b.Category = t.Category
WHERE t.Transaction_Type = 'debit'
GROUP BY b.Category, b.Budget
ORDER BY SUM(t.Amount) DESC
;


-- Monthly netflow over time 

SELECT 
    Month,
    ROUND(SUM(Net_Flow),2) AS Monthly_Net_Flow
FROM [Transactions ]
GROUP BY Month
ORDER BY 
    CASE 
        WHEN Month = 'January' THEN 1 WHEN Month = 'February' THEN 2 WHEN Month = 'March' THEN 3
        WHEN Month = 'April' THEN 4 WHEN Month = 'May' THEN 5 WHEN Month = 'June' THEN 6
        WHEN Month = 'July' THEN 7 WHEN Month = 'August' THEN 8 WHEN Month = 'September' THEN 9
        WHEN Month = 'October' THEN 10 WHEN Month = 'November' THEN 11 WHEN Month = 'December' THEN 12
    END
 ;


 -- Account breakdown by both debit and credit 

 SELECT 
    Account_Name,
    ROUND(SUM(CASE WHEN Transaction_Type = 'debit' THEN Amount ELSE 0 END),2) AS Total_Spent,
    ROUND(SUM(CASE WHEN Transaction_Type = 'credit' THEN Amount ELSE 0 END),2) AS Total_Received
FROM [Transactions ]
GROUP BY Account_Name
ORDER BY Total_Spent DESC
;


-- Top 5 Spending Categpries 

SELECT TOP 5
    Category,
    ROUND(SUM(Amount),2) AS Total_Spent
FROM [Transactions ]
WHERE Transaction_Type = 'debit'
GROUP BY Category
ORDER BY Total_Spent DESC
;


-- Identifying Overspent Categories 

SELECT 
    t.Category,
    SUM(t.Amount) AS Actual_Spending,
    b.Budget AS Budgeted_Amount,
    (SUM(t.Amount) - b.Budget) AS Over_Budget_Amount
FROM [Transactions ] t
JOIN Budget b ON t.Category = b.Category
WHERE t.Transaction_Type = 'debit'
GROUP BY t.Category, b.Budget
HAVING SUM(t.Amount) > b.Budget
;


-- Average Monthly Income vs Average Monthly Expense 

SELECT 
    Month,
    ROUND(SUM(CASE WHEN Transaction_Type = 'credit' THEN Amount END),2) AS Monthly_Income,
    ROUND(SUM(CASE WHEN Transaction_Type = 'debit' THEN Amount END),2) AS Monthly_Expense
FROM [Transactions ]
GROUP BY Month
ORDER BY Monthly_Income DESC



