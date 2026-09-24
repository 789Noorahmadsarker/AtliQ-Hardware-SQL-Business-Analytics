-- ============================================================
-- AtliQ Hardware - Top N Analysis
-- Task: Top N Markets by Net Sales
-- ============================================================
--
-- Business Requirement:
-- Generate a report showing the Top N markets based on
-- Net Sales for a selected fiscal year.
--
-- Inputs:
--   in_fiscal_year : Selected fiscal year
--   in_top_n       : Number of top markets required
--
-- Output:
--   - Market
--   - Net Sales (in millions)
--
-- Data Source:
--   net_sales view
-- ============================================================


-- ============================================================
-- Procedure Definition
-- ============================================================

DROP PROCEDURE IF EXISTS get_top_n_markets_by_net_sales;

DELIMITER $$

CREATE PROCEDURE get_top_n_markets_by_net_sales(
    IN in_fiscal_year INT,
    IN in_top_n INT
)
BEGIN

    SELECT
        market,

        -- Convert Net Sales into millions
        ROUND(
            SUM(net_sales) / 1000000,
            2
        ) AS net_sales_mln

    FROM net_sales

    -- Filter for the selected fiscal year
    WHERE fiscal_year = in_fiscal_year

    -- Aggregate Net Sales by market
    GROUP BY market

    -- Highest Net Sales first
    ORDER BY net_sales_mln DESC

    -- Return only the requested number of markets
    LIMIT in_top_n;

END $$

DELIMITER ;


-- ============================================================
-- Example Execution
-- ============================================================
--
-- Top 5 markets for Fiscal Year 2021

CALL get_top_n_markets_by_net_sales(2021, 5);
