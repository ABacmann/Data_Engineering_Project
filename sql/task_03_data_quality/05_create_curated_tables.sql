-- =========================================================
-- Task 3 - 05_create_curated_tables.sql
-- Purpose:
--   Create trusted, analytics-ready tables:
--     - leads_curated
--     - opportunities_curated
--
-- Notes:
--   This materializes standardization + cleaning decisions into tables.
-- =========================================================

DROP TABLE IF EXISTS leads_curated;
DROP TABLE IF EXISTS opportunities_curated;

-- ---------- Leads curated ----------
-- Dedup rule: if email present, keep the earliest created_at per email
CREATE TABLE leads_curated AS
WITH ranked AS (
  SELECT
    l.*,
    ROW_NUMBER() OVER (
      PARTITION BY CASE WHEN l.email IS NOT NULL AND l.email <> '' THEN l.email ELSE l.lead_id END
      ORDER BY l.created_at NULLS LAST, l.lead_id
    ) AS rn
  FROM vw_leads_standardized l
)
SELECT
  lead_id,
  first_name,
  last_name,
  email,
  phone,
  company_name,
  job_title,

  -- use standardized values for analytics
  industry_std          AS industry,
  lead_status_std       AS lead_status,
  lead_source_std       AS lead_source,
  lead_rating_std       AS lead_rating,
  company_size_std      AS company_size,
  product_interest_std  AS product_interest,
  country_code_std      AS country_code,

  created_at,
  converted_at,
  last_activity_at,
  website,
  description_or_notes,
  region,
  source_system
FROM ranked
WHERE rn = 1;

CREATE INDEX IF NOT EXISTS idx_leads_curated_email ON leads_curated (email);
CREATE INDEX IF NOT EXISTS idx_leads_curated_company ON leads_curated (company_name);

-- ---------- Opportunities curated ----------
-- Clean rule: keep only valid probabilities and valid dates
-- Also ensure lead exists in leads_curated to avoid broken analytics joins
CREATE TABLE opportunities_curated AS
SELECT
  o.opportunity_id,
  o.lead_id,
  o.opportunity_name,
  o.amount_usd,

  -- standardized
  o.stage_std       AS stage,
  o.sales_type_std  AS sales_type,
  o.product_line_std AS product_line,

  o.probability,
  o.expected_close_at,
  o.created_at,
  o.forecast_category,
  o.next_step,
  o.competitor,
  o.loss_reason,
  o.region,
  o.source_system
FROM vw_opportunities_standardized o
JOIN leads_curated l
  ON l.lead_id = o.lead_id
WHERE o.probability IS NULL OR (o.probability >= 0 AND o.probability <= 100)
  AND NOT (o.expected_close_at IS NOT NULL AND o.created_at IS NOT NULL AND o.expected_close_at < o.created_at);

CREATE INDEX IF NOT EXISTS idx_opps_curated_lead ON opportunities_curated (lead_id);
CREATE INDEX IF NOT EXISTS idx_opps_curated_stage ON opportunities_curated (stage);


