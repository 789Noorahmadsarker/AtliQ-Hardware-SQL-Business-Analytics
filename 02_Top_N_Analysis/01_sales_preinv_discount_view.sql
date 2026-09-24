-- ============================================================
-- AtliQ Hardware - Top N Analysis
-- View: Sales Before Post-Invoice Deductions
-- ============================================================
--
-- Purpose:
-- Create a reusable view that calculates sales values after
-- applying pre-invoice discounts.
--
-- This view combines:
--   1. Monthly sales data
--   2. Product information
--   3. Customer information
--   4. Gross price
--   5. Pre-invoice deductions
--
-- Key Calculation:
--   Net Invoice Sales =
--   (1 - Pre-Invoice Discount %) * Total Gross Price
--
-- Output includes:
--   - Date and Fiscal Year
--   - Product and Variant
--   - Customer and Market
--   - Sold Quantity
--   - Gross Price
--   - Total Gross Price
--   - Pre-Invoice Discount %
--   - Net Invoice Sales
-- ============================================================


-- ============================================================
-- View Definition
-- ============================================================

DROP VIEW IF EXISTS sales_preinv;

CREATE VIEW sales_preinv AS

SELECT
    fsm.date,
    fsm.fiscal_year,
    fsm.product_code,

    p.product,
    p.variant,

    fsm.customer_code,
    c.customer,
    c.market,

    fsm.sold_quantity,

    ROUND(gp.gross_price, 2) AS gross_price,

    -- Total sales value before deductions
    ROUND(
        fsm.sold_quantity * gp.gross_price,
        2
    ) AS total_gross_price,

    -- Pre-invoice discount percentage
    pid.pre_invoice_discount_pct,

    -- Sales value after applying pre-invoice discount
    ROUND(
        (1 - pid.pre_invoice_discount_pct)
        * (fsm.sold_quantity * gp.gross_price),
        2
    ) AS net_invoice_sales

FROM fact_sales_monthly AS fsm

-- Product information
JOIN dim_product AS p
    ON fsm.product_code = p.product_code

-- Customer and market information
JOIN dim_customer AS c
    ON fsm.customer_code = c.customer_code

-- Gross price based on product and fiscal year
JOIN fact_gross_price AS gp
    ON fsm.product_code = gp.product_code
    AND fsm.fiscal_year = gp.fiscal_year

-- Pre-invoice deduction based on customer and fiscal year
JOIN fact_pre_invoice_deductions AS pid
    ON fsm.fiscal_year = pid.fiscal_year
    AND fsm.customer_code = pid.customer_code;


-- ============================================================
-- Example Usage
-- ============================================================
--
SELECT *
FROM sales_preinv
LIMIT 10;

