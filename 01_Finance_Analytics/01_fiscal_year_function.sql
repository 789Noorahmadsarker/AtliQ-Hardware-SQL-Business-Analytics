-- =====================================================
-- Function: fiscal_year
-- Purpose : Calculate fiscal year from a calendar date
-- =====================================================

DROP FUNCTION IF EXISTS fiscal_year;

DELIMITER $$

CREATE FUNCTION fiscal_year(x DATE)
RETURNS YEAR
DETERMINISTIC
BEGIN

    DECLARE Y YEAR;

    SET Y = YEAR(DATE_ADD(x, INTERVAL 4 MONTH));

    RETURN Y;

END $$

DELIMITER ;


-- =====================================================
-- Example Usage
-- =====================================================

SELECT fiscal_year('2021-09-01') AS fiscal_year;
SELECT fiscal_year('2022-08-01') AS fiscal_year;
