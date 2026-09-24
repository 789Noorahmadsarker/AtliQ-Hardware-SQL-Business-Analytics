-- ============================================================
-- AtliQ Hardware - Top N Analysis
-- Task: Top N Customers by Net Sales
-- ============================================================
--
-- Business Requirement:
-- Generate a report showing the Top N customers based on
-- Net Sales for a selected fiscal year and market.
--
-- Inputs:
--   n   : Number of top customers required
--   FY  : Selected fiscal year
--   mrk : Selected market
--
-- Output:
--   - Customer
--   - Net Sales (in millions)
--
-- Data Source:
--   net_sales view
-- ============================================================


-- ============================================================
-- Procedure Definition
-- ============================================================

DROP PROCEDURE IF EXISTS top_n_customers;

DELIMITER $$

CREATE PROCEDURE top_n_customers(
    IN n INT,
    IN FY INT,
    IN mrk VARCHAR(50)
)
BEGIN

    SELECT
        customer,

        -- Convert Net Sales into millions
        ROUND(
            SUM(net_sales) / 1000000,
            2
        ) AS net_sales_mln

    FROM net_sales

    -- Filter for the selected fiscal year and market
    WHERE fiscal_year = FY
        AND market = mrk

    -- Aggregate Net Sales by customer
    GROUP BY customer

    -- Highest Net Sales first
    ORDER BY net_sales_mln DESC

    -- Return only the requested number of customers
    LIMIT n;

END $$

DELIMITER ;


-- ============================================================
-- Example Execution
-- ============================================================
--
-- Top 5 customers in India for Fiscal Year 2021

CALL top_n_customers(5, 2021, 'India');
