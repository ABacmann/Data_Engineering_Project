-- =========================================================
-- Task 3 - 03_duplicate_detection.sql
-- Purpose:
--   Identify duplicates within/across regions for leads.
--   Output: dq_lead_duplicates (pairs/groups to review or auto-resolve).
--
-- Strategy:
--   1) Exact email duplicates (case-insensitive already in unified)
--   2) Fallback: same company + first+last (normalized)
-- =========================================================

DROP TABLE IF EXISTS dq_lead_dupes_email;
CREATE TABLE dq_lead_dupes_email AS
SELECT
  email,
  COUNT(*) AS cnt,
  ARRAY_AGG(lead_id ORDER BY created_at NULLS LAST) AS lead_ids
FROM vw_leads_standardized
WHERE email IS NOT NULL AND email <> ''
GROUP BY email
HAVING COUNT(*) > 1;

DROP TABLE IF EXISTS dq_lead_dupes_name_company;
CREATE TABLE dq_lead_dupes_name_company AS
SELECT
  lower(trim(coalesce(company_name,''))) AS company_key,
  lower(trim(coalesce(first_name,'')))   AS first_key,
  lower(trim(coalesce(last_name,'')))    AS last_key,
  COUNT(*) AS cnt,
  ARRAY_AGG(lead_id ORDER BY created_at NULLS LAST) AS lead_ids
FROM vw_leads_standardized
WHERE (email IS NULL OR email = '')  -- only use this fallback when email missing
  AND COALESCE(company_name,'') <> ''
  AND COALESCE(first_name,'') <> ''
  AND COALESCE(last_name,'') <> ''
GROUP BY 1,2,3
HAVING COUNT(*) > 1;

-- Quick summaries
SELECT 'email_dupes' AS dup_type, COUNT(*) AS groups FROM dq_lead_dupes_email
UNION ALL
SELECT 'name_company_dupes', COUNT(*) FROM dq_lead_dupes_name_company;
