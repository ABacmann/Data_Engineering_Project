-- =========================================================
-- Lead-to-Opportunity Conversion Rate
-- Definition:
--   % of leads that have at least one opportunity
-- =========================================================

-- Build a reusable “lead has opportunity” flag once
DROP VIEW IF EXISTS vw_leads_with_opp;
CREATE VIEW vw_leads_with_opp AS
SELECT
  l.*,
  CASE WHEN o.lead_id IS NULL THEN 0 ELSE 1 END AS has_opportunity
FROM leads_curated l
LEFT JOIN (
  SELECT DISTINCT lead_id
  FROM opportunities_curated
) o
  ON o.lead_id = l.lead_id;

-- Query 1: conversion by region + lead_source
SELECT
  region,
  lead_source,
  COUNT(*) AS total_leads,
  SUM(has_opportunity) AS converted_leads,
  ROUND(SUM(has_opportunity)::NUMERIC / NULLIF(COUNT(*),0) * 100, 2) AS conversion_rate_pct
FROM vw_leads_with_opp
GROUP BY region, lead_source
ORDER BY conversion_rate_pct DESC;

-- Query 2: conversion by region only
SELECT
  region,
  COUNT(*) AS total_leads,
  SUM(has_opportunity) AS converted_leads,
  ROUND(SUM(has_opportunity)::NUMERIC / NULLIF(COUNT(*),0) * 100, 2) AS conversion_rate_pct
FROM vw_leads_with_opp
GROUP BY region
ORDER BY conversion_rate_pct DESC;

