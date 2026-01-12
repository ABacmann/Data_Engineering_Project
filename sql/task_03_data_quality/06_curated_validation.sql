-- =========================================================
-- Task 3 - 06_curated_validation.sql
-- Purpose:
--   Validate curated tables are consistent and analytics-ready.
-- =========================================================

-- Row counts
SELECT COUNT(*) AS leads_curated_cnt FROM leads_curated;
SELECT COUNT(*) AS opps_curated_cnt FROM opportunities_curated;

SELECT COUNT(*) AS leads_cnt FROM na_lead
-- Orphans should now be zero (opps join leads_curated)
SELECT COUNT(*) AS orphan_opps_in_curated
FROM opportunities_curated o
LEFT JOIN leads_curated l ON l.lead_id = o.lead_id
WHERE l.lead_id IS NULL;

-- Duplicate emails should be zero (by design)
SELECT COUNT(*) AS duplicate_email_groups
FROM (
  SELECT email
  FROM leads_curated
  WHERE email IS NOT NULL AND email <> ''
  GROUP BY email
  HAVING COUNT(*) > 1
) t;

-- Probabilities out of range should be zero
SELECT COUNT(*) AS prob_out_of_range
FROM opportunities_curated
WHERE probability IS NOT NULL AND (probability < 0 OR probability > 100);

-- Standardization sanity: any 'Other' buckets (not necessarily bad, but track)
SELECT 'lead_source' AS field, lead_source, COUNT(*) FROM leads_curated GROUP BY lead_source
UNION ALL
SELECT 'industry', industry, COUNT(*) FROM leads_curated GROUP BY industry
UNION ALL
SELECT 'stage', stage, COUNT(*) FROM opportunities_curated GROUP BY stage
ORDER BY 1,3 DESC;
