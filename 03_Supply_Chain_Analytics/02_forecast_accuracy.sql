-- ============================================================
-- AtliQ Hardware - Supply Chain Analytics
-- Task: Forecast Accuracy Analysis
-- ============================================================
--
-- Business Requirement:
-- As a Product Owner, generate an aggregate forecast accuracy
-- report for all customers for a given fiscal year.
--
-- Purpose:
-- Track how accurately the company forecasts demand for
-- different customers.
--
-- Report Includes:
--   1. Customer Code
--   2. Customer Name
--   3. Market
--   4. Total Sold Quantity
--   5. Total Forecast Quantity
--   6. Net Error
--   7. Net Error %
--   8. Absolute Error
--   9. Absolute Error %
--  10. Forecast Accuracy %
--
-- Fiscal Year:
--   2021
--
-- Key Calculations:
--   Net Error =
--       Forecast Quantity - Sold Quantity
--
--   Net Error % =
--       Net Error / Total Forecast Quantity * 100
--
--   Absolute Error =
--       ABS(Forecast Quantity - Sold Quantity)
--
--   Absolute Error % =
--       Absolute Error / Total Forecast Quantity * 100
--
--   Forecast Accuracy =
--       100 - Absolute Error %
--
--   If Absolute Error % > 100,
--   Forecast Accuracy is set to 0.
-- ============================================================


-- ============================================================
-- Step 1: Create a temporary table containing
--         customer-level forecast accuracy metrics
-- ============================================================

DROP TEMPORARY TABLE IF EXISTS forecast_accuracy_table;

CREATE TEMPORARY TABLE forecast_accuracy_table AS

SELECT
    s.customer_code,

    -- Total actual quantity sold
    SUM(s.sold_quantity) AS total_sold_qty,

    -- Total forecast quantity
    SUM(s.forecast_quantity) AS total_forecast_qty,

    -- Net Error
    SUM(
        s.forecast_quantity - s.sold_quantity
    ) AS net_err,

    -- Net Error %
    SUM(
        s.forecast_quantity - s.sold_quantity
    ) * 100
    / SUM(s.forecast_quantity) AS net_err_pct,

    -- Absolute Error
    SUM(
        ABS(s.forecast_quantity - s.sold_quantity)
    ) AS abs_err,

    -- Absolute Error %
    SUM(
        ABS(s.forecast_quantity - s.sold_quantity)
    ) * 100
    / SUM(s.forecast_quantity) AS abs_err_pct

FROM fact_act_est AS s

WHERE s.fiscal_year = 2021

GROUP BY
    s.customer_code;


-- ============================================================
-- Step 2: Generate the final Forecast Accuracy report
-- ============================================================

SELECT
    e.customer_code,
    c.customer,
    c.market,

    e.total_sold_qty,
    e.total_forecast_qty,

    e.net_err,
    e.net_err_pct,

    e.abs_err,
    e.abs_err_pct,

    -- Forecast Accuracy
    IF(
        e.abs_err_pct > 100,
        0,
        100 - e.abs_err_pct
    ) AS forecast_accuracy

FROM forecast_accuracy_table AS e

JOIN dim_customer AS c
    USING (customer_code)

ORDER BY
    forecast_accuracy DESC;


-- ============================================================
-- End of Forecast Accuracy Analysis
-- ============================================================
