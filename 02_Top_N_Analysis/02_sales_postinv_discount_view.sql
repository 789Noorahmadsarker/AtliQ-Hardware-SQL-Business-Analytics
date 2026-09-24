-- ============================================================
-- AtliQ Hardware - Top N Analysis
-- View: Sales After Post-Invoice Deductions
-- ============================================================
--
-- Purpose:
-- Extend the `sales_preinv` view by adding post-invoice
-- deductions.
--
-- Post-Invoice Discount % consists of:
--
--   Discounts % + Other Deductions %
--
-- This view carries forward the pre-invoice calculations
-- and adds the combined post-invoice deduction percentage.
-- ============================================================


-- ============================================================
-- View Definition
-- ============================================================

DROP VIEW IF EXISTS sales_postinv;

CREATE VIEW sales_postinv AS

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

    -- Combine discounts and other post-invoice deductions
    (
        pid.discounts_pct
        + pid.other_deductions_pct
    ) AS post_invoice_discount_pct

FROM sales_preinv AS spi

-- Post-invoice deductions based on
-- date, product and customer
JOIN fact_post_invoice_deductions AS pid
    ON spi.date = pid.date
    AND spi.product_code = pid.product_code
    AND spi.customer_code = pid.customer_code;


-- ============================================================
-- Example Usage
-- ============================================================
--
SELECT *
FROM sales_postinv
LIMIT 10;
