-- =========================================================
-- Task 3 - 02_run_quality_profiling.sql
-- Purpose:
--   Profile missing values and obvious anomalies on standardized views.
--   We do NOT change data here; we measure & report.
-- =========================================================

-- ---------- Leads: Missingness ----------
SELECT 'leads' AS dataset, 'email_missing' AS issue, COUNT(*) AS cnt
FROM vw_leads_standardized
WHERE email IS NULL OR email = ''
UNION ALL
SELECT 'leads','company_missing', COUNT(*) FROM vw_leads_standardized WHERE company_name IS NULL OR company_name = ''
UNION ALL
SELECT 'leads','lead_source_missing', COUNT(*) FROM vw_leads_standardized WHERE lead_source IS NULL OR lead_source = ''
UNION ALL
SELECT 'leads','industry_missing', COUNT(*) FROM vw_leads_standardized WHERE industry IS NULL OR industry = ''
UNION ALL
SELECT 'leads','country_missing', COUNT(*) FROM vw_leads_standardized WHERE country_code IS NULL OR country_code = ''
ORDER BY dataset, issue;

-- ---------- Opportunities: Missingness ----------
SELECT 'opportunities' AS dataset, 'stage_missing' AS issue, COUNT(*) AS cnt
FROM vw_opportunities_standardized
WHERE stage IS NULL OR stage = ''
UNION ALL
SELECT 'opportunities','amount_missing', COUNT(*) FROM vw_opportunities_standardized WHERE amount_usd IS NULL
UNION ALL
SELECT 'opportunities','prob_missing', COUNT(*) FROM vw_opportunities_standardized WHERE probability IS NULL
ORDER BY dataset, issue;

-- ---------- Invalid probabilities ----------
SELECT source_system, COUNT(*) AS prob_out_of_range
FROM vw_opportunities_standardized
WHERE probability IS NOT NULL AND (probability < 0 OR probability > 100)
GROUP BY source_system
ORDER BY source_system;

-- ---------- Invalid date logic ----------
-- Opportunity expected close before created (bad)
SELECT source_system, COUNT(*) AS expected_close_before_created
FROM vw_opportunities_standardized
WHERE expected_close_at IS NOT NULL AND created_at IS NOT NULL
  AND expected_close_at < created_at
GROUP BY source_system;

-- Lead converted before created (bad)
SELECT source_system, COUNT(*) AS lead_converted_before_created
FROM vw_leads_standardized
WHERE converted_at IS NOT NULL AND created_at IS NOT NULL
  AND converted_at < created_at
GROUP BY source_system;


-- =========================================================
-- Leads missingness (key columns)
-- =========================================================
SELECT 'leads' AS dataset, 'lead_id_missing' AS issue, COUNT(*) AS cnt
FROM vw_leads_standardized
WHERE lead_id IS NULL OR lead_id = ''

UNION ALL
SELECT 'leads', 'first_name_missing', COUNT(*)
FROM vw_leads_standardized
WHERE first_name IS NULL OR first_name = ''

UNION ALL
SELECT 'leads', 'last_name_missing', COUNT(*)
FROM vw_leads_standardized
WHERE last_name IS NULL OR last_name = ''

UNION ALL
SELECT 'leads', 'email_missing', COUNT(*)
FROM vw_leads_standardized
WHERE email IS NULL OR email = ''

UNION ALL
SELECT 'leads', 'phone_missing', COUNT(*)
FROM vw_leads_standardized
WHERE phone IS NULL OR phone = ''

UNION ALL
SELECT 'leads', 'company_missing', COUNT(*)
FROM vw_leads_standardized
WHERE company_name IS NULL OR company_name = ''

UNION ALL
SELECT 'leads', 'job_title_missing', COUNT(*)
FROM vw_leads_standardized
WHERE job_title IS NULL OR job_title = ''

UNION ALL
SELECT 'leads', 'lead_source_missing', COUNT(*)
FROM vw_leads_standardized
WHERE lead_source IS NULL OR lead_source = ''

UNION ALL
SELECT 'leads', 'industry_missing', COUNT(*)
FROM vw_leads_standardized
WHERE industry IS NULL OR industry = ''

UNION ALL
SELECT 'leads', 'company_size_missing', COUNT(*)
FROM vw_leads_standardized
WHERE company_size IS NULL OR company_size = ''

UNION ALL
SELECT 'leads', 'lead_rating_missing', COUNT(*)
FROM vw_leads_standardized
WHERE lead_rating IS NULL OR lead_rating = ''

UNION ALL
SELECT 'leads', 'lead_status_missing', COUNT(*)
FROM vw_leads_standardized
WHERE lead_status IS NULL OR lead_status = ''

UNION ALL
SELECT 'leads', 'country_missing', COUNT(*)
FROM vw_leads_standardized
WHERE country_code IS NULL OR country_code = ''

UNION ALL
SELECT 'leads', 'product_interest_missing', COUNT(*)
FROM vw_leads_standardized
WHERE product_interest IS NULL OR product_interest = ''

UNION ALL
SELECT 'leads', 'created_at_missing', COUNT(*)
FROM vw_leads_standardized
WHERE created_at IS NULL

UNION ALL
SELECT 'leads', 'region_missing', COUNT(*)
FROM vw_leads_standardized
WHERE region IS NULL OR region = ''

UNION ALL
SELECT 'leads', 'source_system_missing', COUNT(*)
FROM vw_leads_standardized
WHERE source_system IS NULL OR source_system = ''

ORDER BY issue;


