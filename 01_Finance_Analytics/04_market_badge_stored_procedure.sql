-- ============================================================
-- AtliQ Hardware - Finance Analytics
-- Task: Market Badge Classification
-- ============================================================
--
-- Business Requirement:
-- Create a stored procedure that determines the market badge
-- based on total sold quantity for a given market and fiscal year.
--
-- Business Logic:
--   Total Sold Quantity > 5,000,000  -> Gold
--   Otherwise                        -> Silver
--
-- Inputs:
--   m_name : Market name
--   fy     : Fiscal year
-- ============================================================


-- ============================================================
-- Procedure Definition
-- ============================================================

DROP PROCEDURE IF EXISTS get_market_badge;

DELIMITER $$

CREATE PROCEDURE get_market_badge(
    IN m_name VARCHAR(50),
    IN fy INT
)
BEGIN

    SELECT
        CASE
            WHEN SUM(sold_quantity) > 5000000 THEN 'Gold'
            ELSE 'Silver'
        END AS market_badge

    FROM fact_sales_monthly AS f

    -- Get market information from the customer dimension
    JOIN dim_customer AS c
        USING (customer_code)

    -- Filter for the requested market and fiscal year
    WHERE market = m_name
        AND fiscal_year(date) = fy

    -- Aggregate sold quantity for the market and fiscal year
    GROUP BY
        market,
        fiscal_year(date)

    ORDER BY market;

END $$

DELIMITER ;


-- ============================================================
-- Example Execution
-- ============================================================
--
-- Example:
-- Market = India
-- Fiscal Year = 2021
--
-- Expected output:
-- Gold / Silver
--
CALL get_market_badge('India', 2021);
