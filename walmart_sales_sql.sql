-- ================================================================
-- PROJECT: Walmart Sales Analysis
-- Tool: MySQL
-- Dataset: 10,051 transactions | 100 Branches | 2019–2023
-- ================================================================
-- KEY FINDINGS:
-- 1. Home & Lifestyle + Fashion = 81% of total revenue
-- 2. Health & Beauty is highest rated but lowest in revenue (3.86%)
-- 3. WALM045 lost 62.62% revenue from 2022 to 2023 — needs urgent audit
-- 4. Credit Card leads in transactions; Morning shift is consistently slowest
-- 5. Afternoon shift drives peak sales across most branches
-- ================================================================



-- Walmart Project Queries - MySQL
use walmart_sales;
SELECT * FROM walmart;

-- DROP TABLE walmart;

-- DROP TABLE walmart;

-- Count total records
SELECT COUNT(*) FROM walmart;

-- Count payment methods and number of transactions by payment method
SELECT 
    payment_method, COUNT(*) AS no_payments
FROM
    walmart
GROUP BY payment_method;

-- Count distinct branches
SELECT 
    COUNT(DISTINCT branch)
FROM
    walmart;

-- Find the minimum quantity sold
SELECT MIN(quantity) FROM walmart;

--  Q1: Find different payment methods, number of transactions, and quantity sold by payment method
SELECT 
    payment_method,
    COUNT(*) AS no_payments,
    SUM(quantity) AS no_qty_sold
FROM
    walmart
GROUP BY payment_method;          #INSIGHT: Credit Card is the dominant payment method with 4,260 transactions
--                                  and 9,573 units sold, followed by Ewallet (3,911 transactions, 8,932 units)
--                                    and Cash being the least used (1,880 transactions, 5,077 units).
--                                   Recommendation: Since digital payments (Credit Card + Ewallet) account for
--                                   over 81% of all transactions, Walmart should invest in seamless digital
--                                   payment infrastructure and offer cashback offers on Ewallet to reduce cash dependency.


-- Project Question #2: Identify the highest-rated category in each branch
-- Display the branch, category, and avg rating
SELECT branch, category, avg_rating
FROM (
    SELECT 
        branch,
        category,
        AVG(rating) AS avg_rating,
        RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rnk
    FROM walmart
    GROUP BY branch, category
) AS ranked
WHERE rnk = 1;                             -- INSIGHT: Across 100 branches, Food and Beverages and Health & Beauty
--                                            consistently appear as the highest-rated categories.
--                                             The highest individual rating recorded is 9.8 (Health & Beauty, WALM098).
--                                             Recommendation: Maintain product quality in top-rated categories
--                                              and use them as anchor departments to drive footfall.


-- Q3: Identify the busiest day for each branch based on the number of transactions
SELECT branch, day_name, no_transactions
FROM (
    SELECT 
        branch,
        DAYNAME(STR_TO_DATE(date, '%d/%m/%Y')) AS day_name,
        COUNT(*) AS no_transactions,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rnk
    FROM walmart
    GROUP BY branch, day_name
) AS ranked
WHERE rnk = 1;  -- INSIGHT: No single day dominates across all branches — peak days vary
--                 (Thursday, Tuesday, Sunday, Wednesday all appear as busiest days).
--                  This suggests customer behavior is branch-specific, not chain-wide.
--                   Recommendation: Each branch should plan staffing and restocking
--                   independently based on their own peak day rather than a uniform policy.

-- Q4: Calculate the total quantity of items sold per payment method
SELECT 
    payment_method, SUM(quantity) AS no_qty_sold
FROM
    walmart
GROUP BY payment_method;  -- INSIGHT: Credit Card customers purchase the highest quantity (9,573 units),
--                           suggesting they tend to make larger basket purchases.
--                           Cash customers buy the fewest units (5,077), indicating smaller, essential purchases.
--                            Recommendation: Target Credit Card users with bulk-buy offers and bundle 

-- Q5: Determine the average, minimum, and maximum rating of categories for each city
SELECT 
    city,
    category,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating,
    AVG(rating) AS avg_rating
FROM
    walmart
GROUP BY city , category;      -- INSIGHT: Rating quality varies significantly even within the same city.
--                                For example, Health & Beauty in Abilene scores a perfect 9.7, while
--                                Home & Lifestyle in the same city scores as low as 4.0.
--                                 Recommendation: Conduct product quality audits in city-category combinations
--                                 with average ratings below 5.0 to identify and fix service or product issues.


-- Q6: Calculate the total profit for each category
SELECT 
    category,
    SUM(unit_price * quantity * profit_margin) AS total_profit
FROM
    walmart
GROUP BY category
ORDER BY total_profit DESC;   -- INSIGHT: Home and Lifestyle (₹193,251) and Fashion Accessories (₹193,244)
--                               together contribute over 80% of total profits.
--                                Electronic Accessories (₹30,772) is a distant third.
--                                Health & Beauty, despite being highly rated, is the LEAST profitable (₹18,671).
--                               Recommendation: Increase marketing spend on Home & Lifestyle and Fashion.
--                                Review pricing strategy for Health & Beauty to improve its profit contribution.

-- Q7: Determine the most common payment method for each branch
WITH cte AS (
    SELECT 
        branch,
        payment_method,
        COUNT(*) AS total_trans,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rnk
    FROM walmart
    GROUP BY branch, payment_method
)
SELECT branch, payment_method AS preferred_payment_method
FROM cte
WHERE rnk = 1;  -- INSIGHT: Ewallet is the preferred payment method in the majority of branches,
--                 with Credit Card dominating in select branches like WALM003 (115 transactions)
--                 and WALM099 (83 transactions).
--                 Recommendation: Roll out Ewallet-specific loyalty points chain-wide,
--                 while ensuring Credit Card terminals are prioritized in high-card-usage branches.


-- Q8: Categorize sales into Morning, Afternoon, and Evening shifts
SELECT 
    branch,
    CASE
        WHEN HOUR(TIME(time)) < 12 THEN 'Morning'
        WHEN HOUR(TIME(time)) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS num_invoices
FROM
    walmart
GROUP BY branch , shift
ORDER BY branch , num_invoices DESC;    -- INSIGHT: Afternoon shift (12PM–5PM) is the busiest period across most branches,
--                                          followed by Evening. Morning shift consistently records the fewest transactions.
--                                          Recommendation: Schedule maximum staff during Afternoon shifts,
--                                          run Morning flash sales to drive footfall during slow hours.

-- Q9: Identify the 5 branches with the highest revenue decrease ratio from last year to current year (e.g., 2022 to 2023)
WITH revenue_2022 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2022
    GROUP BY branch
),
revenue_2023 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2023
    GROUP BY branch
)
SELECT 
    r2022.branch,
    r2022.revenue AS last_year_revenue,
    r2023.revenue AS current_year_revenue,
    ROUND(((r2022.revenue - r2023.revenue) / r2022.revenue) * 100, 2) AS revenue_decrease_ratio
FROM revenue_2022 AS r2022
JOIN revenue_2023 AS r2023 ON r2022.branch = r2023.branch
WHERE r2022.revenue > r2023.revenue
ORDER BY revenue_decrease_ratio DESC
LIMIT 5;                                   -- INSIGHT: WALM045 saw the steepest revenue decline of 62.62%
--                                             (from ₹1,731 in 2022 to ₹647 in 2023), followed by WALM047 (58.58% drop)
--                                              and WALM098 (57.89% drop).
--                                              All top 5 declining branches lost over 50% of their revenue year-over-year.
--                                               Recommendation: Urgently audit WALM045, WALM047, and WALM098 for
--                                              operational issues, local competition, or demand shifts in their cities

-- 10 Who are the high-value customers by spend?
SELECT 
    invoice_id,
    SUM(total) AS total_spend,
    COUNT(*) AS visit_frequency,
    NTILE(4) OVER (ORDER BY SUM(total) DESC) AS spend_quartile
FROM walmart
GROUP BY invoice_id;                               -- INSIGHT: Each invoice_id is unique per transaction in this dataset,
--                                                    so spend quartiles reflect single transaction values.
--                                                    Top quartile transactions are high-value single purchases.
--                                                     Recommendation: Introduce a membership/loyalty program to encourage
--                                                      repeat visits from high-spend customers.


-- 11 Revenue contribution percentage by category 
SELECT 
    category,
    SUM(total) AS revenue,
    ROUND(SUM(total) * 100.0 / SUM(SUM(total)) OVER(), 2) AS revenue_pct
FROM walmart
GROUP BY category
ORDER BY revenue DESC;                                  -- INSIGHT: Home and Lifestyle (40.50%) and Fashion Accessories (40.49%)
--                                                        together contribute ~81% of total revenue, making them the two
--                                                         revenue pillars of the business.
--                                                         Health & Beauty contributes only 3.86% despite high customer ratings —
--                                                         indicating a low price point or low transaction volume issue.
--                                                          Recommendation: Bundle Health & Beauty products with top-selling categories
--                                                         to increase its revenue share.

-- 12  Running total by branch
SELECT 
    branch,
    date,
    total,
    SUM(total) OVER (PARTITION BY branch ORDER BY STR_TO_DATE(date, '%d/%m/%Y')) AS running_revenue
FROM walmart;                                              -- INSIGHT: Running revenue totals allow us to track which branches
--                                                            hit revenue milestones fastest throughout the year.
--                                                            Branches with steep early curves indicate strong consistent demand,
--                                                            while flat curves in early months signal seasonal dependency.
--                                                            Recommendation: Use running totals to set monthly revenue targets
--                                                            per branch and flag underperformers early.