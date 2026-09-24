-- ============================================================
-- AtliQ Hardware - Finance Analytics
-- Requirement: Croma India Monthly Product Sales Report
-- ============================================================
--
-- Business Requirement:
-- As a Product Owner, generate a monthly product-level sales
-- report for Croma India for a given fiscal year.
--
-- Required fields:
-- 1. Month
-- 2. Product Name
-- 3. Variant
-- 4. Sold Quantity
-- 5. Gross Price Per Item
-- 6. Gross Price Total
--
-- Customer: Croma India
-- Customer Code: 90002002
-- Fiscal Year: 2021
--
-- Note:
-- The custom `fiscal_year()` function is used to determine
-- the fiscal year from the calendar date.
-- ============================================================


-- ============================================================
-- Main Query
-- ============================================================

SELECT
    fsm.date,
    gp.fiscal_year,
    p.product,
    p.variant,
    fsm.sold_quantity,
    gp.gross_price,
    (gp.gross_price * fsm.sold_quantity) AS gross_price_total

FROM fact_sales_monthly AS fsm

-- Get product name and variant
LEFT JOIN dim_product AS p
    ON fsm.product_code = p.product_code

-- Get gross price based on product and fiscal year
LEFT JOIN fact_gross_price AS gp
    ON fsm.product_code = gp.product_code
    AND fiscal_year(fsm.date) = gp.fiscal_year

-- Filter for Croma India and Fiscal Year 2021
WHERE fsm.customer_code = 90002002
    AND fiscal_year(fsm.date) = 2021

-- Display the latest month first
ORDER BY fsm.date DESC;
