-- ============================================================
-- AtliQ Hardware - Finance Analytics
-- Task: Monthly Sales Report by Customer
-- ============================================================
--
-- Business Requirement:
-- Create a reusable stored procedure that generates a
-- monthly sales report based on a customer name.
--
-- Input:
--   c_name : Customer name
--
-- Output:
--   1. Date
--   2. Customer
--   3. Market
--   4. Monthly Sales
--
-- Note:
-- The custom `fiscal_year()` function is used to match the
-- sales date with the corresponding fiscal year in the
-- gross price table.
-- ============================================================


-- ============================================================
-- Procedure Definition
-- ============================================================

DROP PROCEDURE IF EXISTS get_monthly_sales_by_customer;

DELIMITER $$

CREATE PROCEDURE get_monthly_sales_by_customer(
    IN c_name VARCHAR(50)
)
BEGIN

    SELECT
        s.date,
        c.customer,
        c.market,
        SUM(ROUND(s.sold_quantity * g.gross_price, 2))
            AS monthly_sales

    FROM fact_sales_monthly AS s

    -- Match gross price using product code and fiscal year
    JOIN fact_gross_price AS g
        ON g.fiscal_year = fiscal_year(s.date)
        AND g.product_code = s.product_code

    -- Get customer name and market
    JOIN dim_customer AS c
        ON s.customer_code = c.customer_code

    -- Filter for the requested customer in the India market
    WHERE c.customer = c_name
        AND c.market = 'India'

    -- Aggregate sales at monthly level
    GROUP BY
        s.date,
        c.customer

    -- Display results chronologically
    ORDER BY s.date;

END $$

DELIMITER ;


-- ============================================================
-- Example Execution
-- ============================================================
--
-- Replace the customer name with any valid customer name.
--
-- Example:
-- CALL get_monthly_sales_by_customer('Croma');

CALL get_monthly_sales_by_customer('Croma');
