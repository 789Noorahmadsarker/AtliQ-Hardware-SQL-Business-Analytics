-- ============================================================
-- AtliQ Hardware - Supply Chain Analytics
-- Task: Create Combined Actual vs Forecast Dataset
-- ============================================================
--
-- Business Requirement:
-- Create a combined dataset containing actual sales quantity
-- and forecast quantity for each date, product and customer.
--
-- Purpose:
-- This table will serve as the base dataset for subsequent
-- forecast accuracy analysis.
--
-- Data Sources:
--   1. fact_sales_monthly
--   2. fact_forecast_monthly
--
-- Output Columns:
--   - Date
--   - Product Code
--   - Customer Code
--   - Sold Quantity
--   - Forecast Quantity
--
-- Approach:
-- A UNION of two LEFT JOIN queries is used to ensure that
-- records existing in either the actual sales dataset or the
-- forecast dataset are included.
--
-- Missing Values:
--   - Missing Sold Quantity     -> 0
--   - Missing Forecast Quantity -> 0
-- ============================================================


-- ============================================================
-- Step 1: Remove the existing table
-- ============================================================

DROP TABLE IF EXISTS fact_act_est;


-- ============================================================
-- Step 2: Create the combined Actual vs Forecast dataset
-- ============================================================

CREATE TABLE fact_act_est AS

(
    SELECT
        s.date AS date,
        s.product_code AS product_code,
        s.customer_code AS customer_code,
        s.sold_quantity AS sold_quantity,
        f.forecast_quantity AS forecast_quantity
    FROM fact_sales_monthly AS s
    LEFT JOIN fact_forecast_monthly AS f
        USING (date, product_code, customer_code)
)

UNION

(
    SELECT
        f.date AS date,
        f.product_code AS product_code,
        f.customer_code AS customer_code,
        s.sold_quantity AS sold_quantity,
        f.forecast_quantity AS forecast_quantity
    FROM fact_forecast_monthly AS f
    LEFT JOIN fact_sales_monthly AS s
        USING (date, product_code, customer_code)
);


-- ============================================================
-- Step 3: Replace missing Sold Quantity with 0
-- ============================================================

UPDATE fact_act_est
SET sold_quantity = 0
WHERE sold_quantity IS NULL;


-- ============================================================
-- Step 4: Replace missing Forecast Quantity with 0
-- ============================================================

UPDATE fact_act_est
SET forecast_quantity = 0
WHERE forecast_quantity IS NULL;


-- ============================================================
-- Optional: Verify the created dataset
-- ============================================================

SELECT *
FROM fact_act_est
LIMIT 10;
