-- =========================================================
-- Task 2 - 04_mapping_coverage_checks.sql
-- Purpose: Find unmapped raw values so mappings can be completed.
-- =========================================================

-- Leads: unmapped lead_source values
SELECT lower(trim(lead_source)) AS raw_value, COUNT(*) AS cnt
FROM unified_leads
WHERE COALESCE(lead_source,'') <> ''
  AND lower(trim(lead_source)) NOT IN (SELECT raw_key FROM map_lead_source)
GROUP BY 1
ORDER BY cnt DESC;

-- Leads: unmapped industry values
SELECT lower(trim(industry)) AS raw_value, COUNT(*) AS cnt
FROM unified_leads
WHERE COALESCE(industry,'') <> ''
  AND lower(trim(industry)) NOT IN (SELECT raw_key FROM map_industry)
GROUP BY 1
ORDER BY cnt DESC;

-- Leads: unmapped company_size values
SELECT lower(trim(company_size)) AS raw_value, COUNT(*) AS cnt
FROM unified_leads
WHERE COALESCE(company_size,'') <> ''
  AND lower(trim(company_size)) NOT IN (SELECT raw_key FROM map_company_size)
GROUP BY 1
ORDER BY cnt DESC;

-- Leads: unmapped lead_rating values
SELECT lower(trim(lead_rating)) AS raw_value, COUNT(*) AS cnt
FROM unified_leads
WHERE COALESCE(lead_rating,'') <> ''
  AND lower(trim(lead_rating)) NOT IN (SELECT raw_key FROM map_lead_rating)
GROUP BY 1
ORDER BY cnt DESC;

-- Leads: unmapped lead_status values
SELECT lower(trim(lead_status)) AS raw_value, COUNT(*) AS cnt
FROM unified_leads
WHERE COALESCE(lead_status,'') <> ''
  AND lower(trim(lead_status)) NOT IN (SELECT raw_key FROM map_lead_status)
GROUP BY 1
ORDER BY cnt DESC;

-- Leads: unmapped country_code values
SELECT lower(trim(country_code)) AS raw_value, COUNT(*) AS cnt
FROM unified_leads
WHERE COALESCE(country_code,'') <> ''
  AND lower(trim(country_code)) NOT IN (SELECT raw_key FROM map_country_code)
GROUP BY 1
ORDER BY cnt DESC;

-- Opportunities: unmapped stage values
SELECT lower(trim(stage)) AS raw_value, COUNT(*) AS cnt
FROM unified_opportunities
WHERE COALESCE(stage,'') <> ''
  AND lower(trim(stage)) NOT IN (SELECT raw_key FROM map_opp_stage)
GROUP BY 1
ORDER BY cnt DESC;

-- Opportunities: unmapped sales_type values
SELECT lower(trim(sales_type)) AS raw_value, COUNT(*) AS cnt
FROM unified_opportunities
WHERE COALESCE(sales_type,'') <> ''
  AND lower(trim(sales_type)) NOT IN (SELECT raw_key FROM map_sales_type)
GROUP BY 1
ORDER BY cnt DESC;

-- Opportunities: unmapped product_line values
SELECT lower(trim(product_line)) AS raw_value, COUNT(*) AS cnt
FROM unified_opportunities
WHERE COALESCE(product_line,'') <> ''
  AND lower(trim(product_line)) NOT IN (SELECT raw_key FROM map_product_line)
GROUP BY 1
ORDER BY cnt DESC;


SELECT lead_source_std, COUNT(*) AS cnt
FROM vw_leads_standardized
GROUP BY lead_source_std
ORDER BY cnt DESC;
