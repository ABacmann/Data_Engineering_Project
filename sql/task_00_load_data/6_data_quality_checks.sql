-- =========================================================
-- 6_data_quality_checks.sql
-- Purpose:
--   Quick validation for:
--   - successful loads (counts)
--   - orphan opportunities (missing leads)
--   - duplicates on primary keys (should be none)
--   - basic sanity checks for probabilities
-- =========================================================

-- -------------------------
-- 1) Counts: raw lead tables
-- -------------------------
SELECT COUNT(*) AS na_leads FROM na_lead;
SELECT COUNT(*) AS latam_leads FROM latam_lead;

-- -------------------------
-- 2) Counts: staging opportunities
-- -------------------------
SELECT COUNT(*) AS na_opps_stg FROM na_opportunity_stg;
SELECT COUNT(*) AS latam_opps_stg FROM latam_opportunity_stg;

-- -------------------------
-- 3) Counts: final opportunities (after filtering invalid rows)
-- -------------------------
SELECT COUNT(*) AS na_opps_loaded FROM na_opportunity;
SELECT COUNT(*) AS latam_opps_loaded FROM latam_opportunity;

-- -------------------------
-- 4) Orphans: how many staging rows were rejected due to missing lead?
-- -------------------------
SELECT COUNT(*) AS na_opps_missing_lead
FROM na_opportunity_stg s
LEFT JOIN na_lead l ON l."LeadID" = s."LeadID"
WHERE l."LeadID" IS NULL;

SELECT COUNT(*) AS latam_opps_missing_lead
FROM latam_opportunity_stg s
LEFT JOIN latam_lead l ON l.lead_id = s.lead_id
WHERE l.lead_id IS NULL;

-- Drill-down: which missing LeadIDs cause the most rejections?
SELECT s."LeadID", COUNT(*) AS opps
FROM na_opportunity_stg s
LEFT JOIN na_lead l ON l."LeadID" = s."LeadID"
WHERE l."LeadID" IS NULL
GROUP BY s."LeadID"
ORDER BY opps DESC;

SELECT s.lead_id, COUNT(*) AS opps
FROM latam_opportunity_stg s
LEFT JOIN latam_lead l ON l.lead_id = s.lead_id
WHERE l.lead_id IS NULL
GROUP BY s.lead_id
ORDER BY opps DESC;

-- -------------------------
-- 5) Duplicate checks (should be 0 because of primary keys)
-- -------------------------
SELECT COUNT(*) - COUNT(DISTINCT "LeadID") AS na_lead_pk_dupes FROM na_lead;
SELECT COUNT(*) - COUNT(DISTINCT lead_id)  AS latam_lead_pk_dupes FROM latam_lead;

SELECT COUNT(*) - COUNT(DISTINCT "OpportunityID") AS na_opp_pk_dupes FROM na_opportunity_stg;
SELECT COUNT(*) - COUNT(DISTINCT opportunity_id)  AS latam_opp_pk_dupes FROM latam_opportunity_stg;

-- -------------------------
-- 6) Basic probability sanity checks (identify out-of-range values)
-- -------------------------
SELECT COUNT(*) AS na_prob_out_of_range
FROM na_opportunity_stg
WHERE "Probability" IS NOT NULL AND ("Probability" < 0 OR "Probability" > 100);

SELECT COUNT(*) AS latam_prob_out_of_range
FROM latam_opportunity_stg
WHERE win_probability IS NOT NULL AND (win_probability < 0 OR win_probability > 100);
