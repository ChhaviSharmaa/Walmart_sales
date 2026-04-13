# 🛒 Walmart Sales Analysis — MySQL Project

![SQL](https://img.shields.io/badge/Tool-MySQL-blue) ![Dataset](https://img.shields.io/badge/Records-10%2C051-green) ![Branches](https://img.shields.io/badge/Branches-100-orange) ![Years](https://img.shields.io/badge/Years-2019--2023-yellow)

## 📌 Project Overview

This project analyzes Walmart sales data across **100 branches** from **2019 to 2023** using **MySQL**. The goal is to uncover actionable business insights around revenue, customer behavior, payment preferences, product performance, and branch-level trends.

---

## 🗂️ Dataset

| Field | Details |
|---|---|
| **Source** | Walmart Sales Dataset |
| **Records** | 10,051 transactions |
| **Branches** | 100 (WALM001 – WALM100) |
| **Time Period** | 2019 – 2023 |
| **Key Columns** | `branch`, `city`, `category`, `unit_price`, `quantity`, `date`, `time`, `payment_method`, `rating`, `profit_margin` |

---

## 🔑 Key Findings

1. **Home & Lifestyle + Fashion Accessories = 81% of total revenue** — these are the two revenue pillars of the business
2. **Health & Beauty is the highest-rated category** across many branches but contributes only **3.86% of revenue** — a major pricing/visibility gap
3. **WALM045 lost 62.62% of revenue** from 2022 to 2023 — the steepest decline across all branches
4. **Credit Card dominates transactions** (4,260) while Cash is the least used (1,880)
5. **Afternoon shift (12PM–5PM) drives peak sales** across most branches — Morning is consistently the slowest

---

## 📊 Business Questions Answered

| # | Question | SQL Concepts Used |
|---|---|---|
| Q1 | Payment methods, transaction count & quantity sold | GROUP BY, SUM, COUNT |
| Q2 | Highest-rated category per branch | Subquery, AVG, RANK() |
| Q3 | Busiest day per branch | DAYNAME, STR_TO_DATE, RANK() |
| Q4 | Total quantity sold per payment method | GROUP BY, SUM |
| Q5 | Avg/Min/Max ratings by city & category | GROUP BY, MIN, MAX, AVG |
| Q6 | Total profit per category | Calculated column, ORDER BY |
| Q7 | Most common payment method per branch | CTE, RANK(), PARTITION BY |
| Q8 | Sales categorized by Morning/Afternoon/Evening shift | CASE WHEN, HOUR, TIME |
| Q9 | Top 5 branches with highest revenue decline (2022→2023) | CTE, JOIN, Revenue ratio |
| Q10 | High-value customers segmented by spend | NTILE(), Window Function |
| Q11 | Revenue contribution % by category | SUM OVER(), percentage calc |
| Q12 | Running revenue total by branch | SUM OVER(), ORDER BY date |

---

## 💡 Insights & Recommendations

### Q1 — Payment Methods
- **Insight:** Credit Card leads with 4,260 transactions and 9,573 units sold. Digital payments (Credit Card + Ewallet) account for over 81% of all transactions.
- **Recommendation:** Invest in seamless digital payment infrastructure and offer Ewallet cashback to reduce cash dependency.

### Q2 — Highest Rated Category per Branch
- **Insight:** Food & Beverages and Health & Beauty consistently top ratings across branches. Highest recorded rating: **9.8** (Health & Beauty, WALM098).
- **Recommendation:** Use top-rated categories as anchor departments to drive footfall and cross-sell lower-rated ones.

### Q3 — Busiest Day per Branch
- **Insight:** Peak days vary by branch — Thursday, Tuesday, Sunday, and Wednesday all appear as top days. No single day dominates chain-wide.
- **Recommendation:** Each branch should plan staffing and restocking independently based on its own peak day.

### Q4 — Quantity Sold per Payment Method
- **Insight:** Credit Card customers buy the most units (9,573), suggesting larger basket sizes. Cash customers buy the least (5,077).
- **Recommendation:** Target Credit Card users with bulk-buy deals and bundle offers to maximize basket size.

### Q5 — Ratings by City & Category
- **Insight:** Large rating variance even within the same city. Health & Beauty in Abilene scores 9.7 while Home & Lifestyle scores as low as 4.0 in the same city.
- **Recommendation:** Conduct product quality audits in city-category combinations with average ratings below 5.0.

### Q6 — Profit by Category
- **Insight:** Home & Lifestyle (₹193,251) and Fashion Accessories (₹193,244) together drive over 80% of profits. Health & Beauty is the least profitable (₹18,671) despite high ratings.
- **Recommendation:** Increase marketing on top-profit categories. Review Health & Beauty pricing to close the gap between satisfaction and profitability.

### Q7 — Preferred Payment per Branch
- **Insight:** Ewallet is preferred in the majority of branches. Credit Card dominates in WALM003 (115 transactions) and WALM099 (83 transactions).
- **Recommendation:** Roll out Ewallet loyalty points chain-wide; prioritize Credit Card terminals in high-card-usage branches.

### Q8 — Sales by Shift
- **Insight:** Afternoon (12PM–5PM) is the busiest shift across most branches. Morning consistently records the fewest transactions.
- **Recommendation:** Schedule maximum staff during Afternoon shifts; run Morning flash sales to improve slow-hour performance.

### Q9 — Revenue Decline (2022 → 2023)
- **Insight:** WALM045 saw the steepest decline at **62.62%** (₹1,731 → ₹647). All top 5 declining branches lost over 50% of revenue year-over-year.
- **Recommendation:** Urgently audit WALM045, WALM047, and WALM098 for operational issues, local competition, or demand shifts.

### Q10 — High Value Customers
- **Insight:** Top quartile transactions represent the highest single-purchase values. Since each invoice is unique, this segments high-value individual purchases.
- **Recommendation:** Introduce a loyalty/membership program targeting high-spend customers to encourage repeat visits.

### Q11 — Revenue % by Category
- **Insight:** Home & Lifestyle (40.50%) and Fashion Accessories (40.49%) are the revenue backbone. Health & Beauty contributes only 3.86% despite high customer satisfaction.
- **Recommendation:** Bundle Health & Beauty products with top-selling categories to increase its visibility and revenue share.

### Q12 — Running Revenue by Branch
- **Insight:** Running totals reveal which branches hit revenue milestones fastest — steep early curves indicate consistent demand; flat curves signal seasonal dependency.
- **Recommendation:** Use running totals to set monthly revenue targets per branch and flag underperformers early in the year.

---

## 🛠️ Tools & Concepts Used

- **Database:** MySQL 8.0
- **Window Functions:** `RANK()`, `NTILE()`, `SUM() OVER()`, `LAG()`
- **CTEs:** Common Table Expressions for multi-step logic
- **Date Functions:** `STR_TO_DATE`, `DAYNAME`, `YEAR`, `HOUR`
- **Aggregations:** `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`
- **Conditional Logic:** `CASE WHEN` for shift categorization

---

## 📁 File Structure

```
walmart-sales-analysis/
│
├── walmart_queries.sql     # All queries with inline insights
├── Walmart.csv             # Raw dataset
└── README.md               # Project documentation
```

---

## 🚀 How to Run

1. Import `Walmart.csv` into MySQL as a table named `walmart`
2. Create a schema: `CREATE DATABASE walmart_sales;`
3. Run `walmart_queries.sql` query by query in MySQL Workbench
4. Review inline comments after each query for insights

---

## 👤 Author

**[Chhavi Sharma]**
- LinkedIn: [https://www.linkedin.com/in/chhavi-sharma-88032723b?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app]
