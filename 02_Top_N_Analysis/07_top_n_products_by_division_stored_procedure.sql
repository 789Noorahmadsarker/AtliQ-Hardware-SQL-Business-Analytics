-- ============================================================
-- AtliQ Hardware - Top N Analysis
-- Task: Top N Products in Each Division
-- ============================================================
--
-- Business Requirement:
-- Get the Top N products in each division for a selected
-- fiscal year based on total quantity sold.
--
-- Inputs:
--   in_FY : Selected fiscal year
--   in_n  : Number of top products required per division
--
-- Output:
--   - Product
--   - Division
--   - Total Quantity Sold
--   - Rank within Division
--
-- Ranking Method:
--   DENSE_RANK() is used to rank products within each division.
-- ============================================================


-- ============================================================
-- Procedure Definition
-- ============================================================

DROP PROCEDURE IF EXISTS get_top_n_product_each_division_selected_fy;

DELIMITER $$

CREATE PROCEDURE get_top_n_product_each_division_selected_fy(
    IN in_FY INT,
    IN in_n INT
)
BEGIN

    -- ========================================================
    -- Step 1: Calculate total quantity sold for each product
    -- within each division for the selected fiscal year.
    -- ========================================================

    WITH cte1 AS (

        SELECT
            product,
            division,
            SUM(sold_quantity) AS total_qty_sold

        FROM fact_sales_monthly

        JOIN dim_product
            USING (product_code)

        WHERE fiscal_year = in_FY

        GROUP BY
            product,
            division
    ),

    -- ========================================================
    -- Step 2: Rank products within each division based on
    -- total quantity sold.
    -- ========================================================

    cte2 AS (

        SELECT
            *,
            DENSE_RANK() OVER (
                PARTITION BY division
                ORDER BY total_qty_sold DESC
            ) AS drnk

        FROM cte1
    )

    -- ========================================================
    -- Step 3: Return the Top N products from each division.
    -- ========================================================

    SELECT *
    FROM cte2
    WHERE drnk <= in_n;

END $$

DELIMITER ;


-- ============================================================
-- Example Execution
-- ============================================================
--
-- Top 3 products in each division for Fiscal Year 2021

CALL get_top_n_product_each_division_selected_fy(2021, 3);
