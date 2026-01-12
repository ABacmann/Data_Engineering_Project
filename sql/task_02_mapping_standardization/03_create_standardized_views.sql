-- =========================================================
-- Task 2 - 03_create_standardized_views.sql
-- Purpose: Apply corporate mappings to unified tables.
-- Output: standardized views for analytics.
-- =========================================================

DROP VIEW IF EXISTS vw_leads_standardized;
CREATE VIEW vw_leads_standardized AS
SELECT
  l.*,

  -- standard values (fallback to 'Other'/'Unknown' when not mapped)
  COALESCE(ls.standard, 'Other')        AS lead_source_std,
  COALESCE(ind.standard, 'Other')       AS industry_std,
  COALESCE(cs.standard, 'Other')        AS company_size_std,
  COALESCE(lr.standard, 'Other')        AS lead_rating_std,
  COALESCE(lst.standard, 'Other')       AS lead_status_std,
  COALESCE(cc.standard, 'Other')        AS country_code_std,
  COALESCE(pl.standard, 'Other')        AS product_interest_std

FROM unified_leads l
LEFT JOIN map_lead_source ls
  ON ls.raw_key = lower(trim(COALESCE(l.lead_source, '')))
LEFT JOIN map_industry ind
  ON ind.raw_key = lower(trim(COALESCE(l.industry, '')))
LEFT JOIN map_company_size cs
  ON cs.raw_key = lower(trim(COALESCE(l.company_size, '')))
LEFT JOIN map_lead_rating lr
  ON lr.raw_key = lower(trim(COALESCE(l.lead_rating, '')))
LEFT JOIN map_lead_status lst
  ON lst.raw_key = lower(trim(COALESCE(l.lead_status, '')))
LEFT JOIN map_country_code cc
  ON cc.raw_key = lower(trim(COALESCE(l.country_code, '')))
LEFT JOIN map_product_line pl
  ON pl.raw_key = lower(trim(COALESCE(l.product_interest, '')));


DROP VIEW IF EXISTS vw_opportunities_standardized;
CREATE VIEW vw_opportunities_standardized AS
SELECT
  o.*,

  COALESCE(st.standard, 'Other')  AS stage_std,
  COALESCE(sty.standard, 'Other') AS sales_type_std,
  COALESCE(pl.standard, 'Other')  AS product_line_std

FROM unified_opportunities o
LEFT JOIN map_opp_stage st
  ON st.raw_key = lower(trim(COALESCE(o.stage, '')))
LEFT JOIN map_sales_type sty
  ON sty.raw_key = lower(trim(COALESCE(o.sales_type, '')))
LEFT JOIN map_product_line pl
  ON pl.raw_key = lower(trim(COALESCE(o.product_line, '')));
