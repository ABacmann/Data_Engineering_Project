-- =========================================================
-- Task 2 - 00_Raw_Value Discovery
-- Purpose:
--   Inspect exact values as entered by users/systems.
--   No normalization, no transformation.
--   Used to design explicit mapping tables.
-- =========================================================


-- =========================
-- LEADS
-- =========================

-- Lead Source
SELECT
  lead_source,
  COUNT(*) AS cnt
FROM unified_leads
GROUP BY lead_source
ORDER BY cnt DESC;


-- Industry
SELECT
  industry,
  COUNT(*) AS cnt
FROM unified_leads
GROUP BY industry
ORDER BY cnt DESC;


-- Company Size
SELECT
  company_size,
  COUNT(*) AS cnt
FROM unified_leads
GROUP BY company_size
ORDER BY cnt DESC;


-- Lead Rating
SELECT
  lead_rating,
  COUNT(*) AS cnt
FROM unified_leads
GROUP BY lead_rating
ORDER BY cnt DESC;


-- Lead Status
SELECT
  lead_status,
  COUNT(*) AS cnt
FROM unified_leads
GROUP BY lead_status
ORDER BY cnt DESC;


-- Country / Country Code
SELECT
  country_code,
  COUNT(*) AS cnt
FROM unified_leads
GROUP BY country_code
ORDER BY cnt DESC;


-- Product Interest
SELECT
  product_interest,
  COUNT(*) AS cnt
FROM unified_leads
GROUP BY product_interest
ORDER BY cnt DESC;


-- =========================
-- OPPORTUNITIES
-- =========================

-- Opportunity Stage
SELECT
  stage,
  COUNT(*) AS cnt
FROM unified_opportunities
GROUP BY stage
ORDER BY cnt DESC;


-- Sales Type
SELECT
  sales_type,
  COUNT(*) AS cnt
FROM unified_opportunities
GROUP BY sales_type
ORDER BY cnt DESC;


-- Product Line
SELECT
  product_line,
  COUNT(*) AS cnt
FROM unified_opportunities
GROUP BY product_line
ORDER BY cnt DESC;