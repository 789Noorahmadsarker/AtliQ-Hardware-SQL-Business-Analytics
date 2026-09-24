-- ============================================================
-- AtliQ Hardware - Top N Analysis
-- View: Final Net Sales
-- ============================================================
--
-- Purpose:
-- Create the final Net Sales view by applying post-invoice
-- deductions to Net Invoice Sales.
--
-- Calculation:
--
--   Net Sales =
--   (1 - Post-Invoice Discount %)
--   * Net Invoice Sales
--
-- This view acts as the final sales layer and can be reused
-- by subsequent Top N Customer, Product and Market analyses.
-- ============================================================


-- ============================================================
-- View Definition
-- ============================================================

DROP VIEW IF EXISTS net_sales;

CREATE VIEW net_sales AS

SELECT
    spi.date,
    spi.fiscal_year,
    spi.product_code,

    spi.product,
    spi.variant,

    spi.customer_code,
    spi.customer,
    spi.market,

    spi.sold_quantity,
    spi.gross_price,
    spi.total_gross_price,

    spi.pre_invoice_discount_pct,
    spi.net_invoice_sales,
    spi.post_invoice_discount_pct,

    -- Final Net Sales after post-invoice deductions
    ROUND(
        (1 - spi.post_invoice_discount_pct)
        * spi.net_invoice_sales,
        2
    ) AS net_sales

FROM sales_postinv AS spi;


-- ============================================================
-- Example Usage
-- ============================================================
--

SELECT *
FROM net_sales
LIMIT 10;
