-- ============================================================
-- AtliQ Hardware - Top N Analysis
-- Task: Region-wise Customer Net Sales Share
-- ============================================================
--
-- Business Requirement:
-- As a Product Owner, I want to see region-wise (APAC, EU,
-- LTAM, etc.) percentage Net Sales breakdown by customers
-- within their respective region so that I can perform
-- regional analysis on the financial performance of the company.
--
-- Fiscal Year:
--   2021
--
-- Output:
--   - Customer
--   - Region
--   - Revenue (in millions)
--   - Market Share %
--
-- Key Calculation:
--   Market Share % =
--       Customer Revenue
--       / Total Regional Revenue
--       * 100
--
-- Window Function:
--   SUM(revenue_mln) OVER (PARTITION BY region)
--   is used to calculate the total revenue within each region.
-- ============================================================


-- ============================================================
-- Step 1: Calculate customer-level Net Sales by region
-- ============================================================

WITH customer_revenue AS (

    SELECT
        c.customer,
        c.region,

        ROUND(
            SUM(n.net_sales) / 1000000,
            2
        ) AS revenue_mln

    FROM net_sales AS n

    JOIN dim_customer AS c
        ON n.customer_code = c.customer_code

    WHERE n.fiscal_year = 2021

    GROUP BY
        c.customer,
        c.region

)


-- ============================================================
-- Step 2: Calculate each customer's percentage contribution
--         within their respective region
-- ============================================================

SELECT
    customer,
    region,
    revenue_mln,

    revenue_mln * 100
    / SUM(revenue_mln) OVER (
        PARTITION BY region
    ) AS market_share_pct

FROM customer_revenue

ORDER BY
    region;
