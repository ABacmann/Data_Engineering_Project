-- =========================================================
-- Task 5 - create_analysis_views.sql
-- Purpose:
--   Provide notebook-friendly views (clean, aggregated, fast).
--   Uses curated tables as the source of truth.
-- =========================================================

-- -----------------------------
-- A) Region KPI summary
-- -----------------------------
DROP VIEW IF EXISTS vw_kpi_region;
CREATE VIEW vw_kpi_region AS
WITH lead_with_opp AS (
  SELECT DISTINCT lead_id
  FROM opportunities_curated
),
lead_with_win AS (
  SELECT DISTINCT lead_id
  FROM opportunities_curated
  WHERE stage = 'Closed Won'
)
SELECT
  l.region,
  COUNT(*) AS total_leads,
  COUNT(lwo.lead_id) AS leads_with_opportunity,
  ROUND(COUNT(lwo.lead_id)::NUMERIC / NULLIF(COUNT(*),0) * 100, 2) AS lead_to_opp_pct,
  COUNT(lww.lead_id) AS leads_with_closed_won,
  ROUND(COUNT(lww.lead_id)::NUMERIC / NULLIF(COUNT(*),0) * 100, 2) AS lead_to_win_pct
FROM leads_curated l
LEFT JOIN lead_with_opp lwo ON lwo.lead_id = l.lead_id
LEFT JOIN lead_with_win lww ON lww.lead_id = l.lead_id
GROUP BY l.region;

-- -----------------------------
-- B) Opportunity funnel KPIs by region
-- -----------------------------
DROP VIEW IF EXISTS vw_kpi_opps_region;
CREATE VIEW vw_kpi_opps_region AS
SELECT
  region,
  COUNT(*) AS total_opportunities,
  COUNT(*) FILTER (WHERE stage = 'Closed Won')  AS won_opportunities,
  COUNT(*) FILTER (WHERE stage = 'Closed Lost') AS lost_opportunities,
  ROUND(
    COUNT(*) FILTER (WHERE stage = 'Closed Won')::NUMERIC
    / NULLIF(COUNT(*),0) * 100, 2
  ) AS opp_win_rate_pct,
  ROUND(AVG(amount_usd) FILTER (WHERE stage = 'Closed Won'), 2) AS avg_deal_usd_won,
  ROUND(SUM(amount_usd) FILTER (WHERE stage = 'Closed Won'), 2) AS revenue_usd_won
FROM opportunities_curated
GROUP BY region;

-- -----------------------------
-- C) Lead source "ROI proxy"
--   (Conversion + deal size) by region
-- -----------------------------
DROP VIEW IF EXISTS vw_kpi_lead_source;
CREATE VIEW vw_kpi_lead_source AS
WITH lead_base AS (
  SELECT lead_id, region, lead_source
  FROM leads_curated
),
opp_base AS (
  SELECT lead_id, region, amount_usd, stage
  FROM opportunities_curated
)
SELECT
  l.region,
  l.lead_source,
  COUNT(DISTINCT l.lead_id) AS total_leads,
  COUNT(DISTINCT o.lead_id) AS leads_with_opportunity,
  ROUND(
    COUNT(DISTINCT o.lead_id)::NUMERIC
    / NULLIF(COUNT(DISTINCT l.lead_id),0) * 100, 2
  ) AS lead_to_opp_pct,
  ROUND(AVG(o.amount_usd) FILTER (WHERE o.stage = 'Closed Won'), 2) AS avg_deal_usd_won,
  ROUND(SUM(o.amount_usd) FILTER (WHERE o.stage = 'Closed Won'), 2) AS revenue_usd_won
FROM lead_base l
LEFT JOIN opp_base o
  ON o.lead_id = l.lead_id
GROUP BY l.region, l.lead_source;

-- -----------------------------
-- D) Product-market fit (won deals)
-- -----------------------------
DROP VIEW IF EXISTS vw_kpi_product_region;
CREATE VIEW vw_kpi_product_region AS
SELECT
  region,
  product_line,
  COUNT(*) FILTER (WHERE stage = 'Closed Won') AS won_deals,
  ROUND(AVG(amount_usd) FILTER (WHERE stage = 'Closed Won'), 2) AS avg_deal_usd_won,
  ROUND(SUM(amount_usd) FILTER (WHERE stage = 'Closed Won'), 2) AS revenue_usd_won
FROM opportunities_curated
GROUP BY region, product_line;

-- -----------------------------
-- E) Pipeline value (open deals)
-- -----------------------------
DROP VIEW IF EXISTS vw_kpi_pipeline_region;
CREATE VIEW vw_kpi_pipeline_region AS
SELECT
  region,
  ROUND(SUM(amount_usd), 2) AS total_pipeline_usd,
  ROUND(SUM(amount_usd * COALESCE(probability,0) / 100), 2) AS weighted_pipeline_usd
FROM opportunities_curated
WHERE stage NOT IN ('Closed Won','Closed Lost')
  AND amount_usd IS NOT NULL
GROUP BY region;

-- -----------------------------
-- F) Sales cycle proxy (Closed Won):
--    lead_created_at -> expected_close_at
-- -----------------------------
DROP VIEW IF EXISTS vw_kpi_sales_cycle_region;
CREATE VIEW vw_kpi_sales_cycle_region AS
SELECT
  o.region,
  COUNT(*) AS closed_won_deals,
  ROUND(
    AVG(EXTRACT(EPOCH FROM (o.expected_close_at - l.created_at)) / 86400)::NUMERIC,
    2
  ) AS avg_sales_cycle_days,
  ROUND(
    (
      PERCENTILE_CONT(0.5)
      WITHIN GROUP (ORDER BY EXTRACT(EPOCH FROM (o.expected_close_at - l.created_at)) / 86400)
    )::NUMERIC,
    2
  ) AS median_sales_cycle_days
FROM opportunities_curated o
JOIN leads_curated l
  ON l.lead_id = o.lead_id
WHERE o.stage = 'Closed Won'
  AND o.expected_close_at IS NOT NULL
  AND l.created_at IS NOT NULL
  AND o.expected_close_at >= l.created_at
GROUP BY o.region;


SELECT *
FROM opportunities_curated
WHERE product_line = 'Other'
  AND stage = 'Closed Won'
ORDER BY amount_usd DESC
