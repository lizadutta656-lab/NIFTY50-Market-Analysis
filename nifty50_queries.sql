-- =============================================
-- NIFTY 50 Capital Markets Analysis (2020-2024)
-- Author: Liza Dutta
-- Tool: PostgreSQL
-- =============================================

-- STEP 1: Create Table
CREATE TABLE nifty50 (
    index_name VARCHAR(50),
    date TEXT,
    open NUMERIC,
    high NUMERIC,
    low NUMERIC,
    close NUMERIC
);

-- STEP 2: Convert Date Format
ALTER TABLE nifty50 ADD COLUMN proper_date DATE;

UPDATE nifty50
SET proper_date = TO_DATE(date, 'DD-Mon-YY');

-- =============================================
-- DATA QUALITY CHECKS
-- =============================================

-- Check for NULL values
SELECT 
    COUNT(*) AS total_rows,
    COUNT(close) AS non_null_close,
    COUNT(proper_date) AS non_null_dates
FROM nifty50;

-- Check for duplicate dates
SELECT proper_date, COUNT(*) 
FROM nifty50
GROUP BY proper_date
HAVING COUNT(*) > 1;

-- Check for invalid prices
SELECT * FROM nifty50
WHERE close <= 0;

-- =============================================
-- ANALYSIS QUERIES
-- =============================================

-- Q1: Yearly Returns
CREATE VIEW yearly_returns AS
SELECT 
    EXTRACT(YEAR FROM proper_date) AS year,
    MIN(close) AS lowest_price,
    MAX(close) AS highest_price,
    ROUND(((MAX(close)-MIN(close))/ MIN(close)) * 100::NUMERIC, 2) AS return_pct
FROM nifty50
GROUP BY year
ORDER BY year;

-- Q2: Monthly Patterns
CREATE VIEW monthly_patterns AS
SELECT
    EXTRACT(MONTH FROM proper_date) AS month,
    ROUND(AVG(close)::NUMERIC, 2) AS avg_close
FROM nifty50
GROUP BY month
ORDER BY month;

-- Q4: Overall Market Trend
CREATE VIEW market_trend AS
SELECT proper_date, close
FROM nifty50
ORDER BY proper_date;
