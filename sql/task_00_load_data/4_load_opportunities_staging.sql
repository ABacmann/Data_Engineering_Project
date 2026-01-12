-- =========================================================
-- 4_load_opportunities_staging.sql
-- Purpose:
--   Load opportunity CSVs into staging tables WITHOUT FK constraints.
--   This allows us to handle orphan opportunities (missing leads) cleanly.
-- =========================================================

-- Recreate staging tables (safe to re-run)
DROP TABLE IF EXISTS na_opportunity_stg;
CREATE TABLE na_opportunity_stg (
  "OpportunityID"     TEXT,
  "LeadID"            TEXT,
  "OpportunityName"   TEXT,
  "Amount"            NUMERIC(18,2),
  "Stage"             TEXT,
  "Probability"       NUMERIC(5,2),
  "ExpectedCloseDate" TIMESTAMPTZ,
  "CreatedDate"       TIMESTAMPTZ,
  "AccountOwner"      TEXT,
  "SalesType"         TEXT,
  "LeadSourceOpp"     TEXT,
  "ProductLine"       TEXT,
  "ForecastCategory"  TEXT,
  "NextStep"          TEXT,
  "CompetitorInfo"    TEXT,
  "LossReason"        TEXT,
  "Region"            TEXT
);

DROP TABLE IF EXISTS latam_opportunity_stg;
CREATE TABLE latam_opportunity_stg (
  opportunity_id      TEXT,
  lead_id             TEXT,
  opportunity_name    TEXT,
  deal_amount         NUMERIC(18,2),
  sales_stage         TEXT,
  win_probability     NUMERIC(5,2),
  expected_close      TIMESTAMPTZ,
  date_created        TIMESTAMPTZ,
  account_manager     TEXT,
  type                TEXT,
  lead_source         TEXT,
  product             TEXT,
  forecast_category   TEXT,
  next_steps          TEXT,
  competitor          TEXT,
  loss_reason         TEXT,
  region              TEXT
);

-- Load raw opportunities into staging (no FK checks here)
\copy na_opportunity_stg ("OpportunityID","LeadID","OpportunityName","Amount","Stage","Probability","ExpectedCloseDate","CreatedDate","AccountOwner","SalesType","LeadSourceOpp","ProductLine","ForecastCategory","NextStep","CompetitorInfo","LossReason","Region") FROM '/Users/alexandrebacmann/Documents/[01] Alexandre/Developer/Projects/Sika_Case_Study/Sika_Project/csv_file/na_opportunity.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy latam_opportunity_stg (opportunity_id,lead_id,opportunity_name,deal_amount,sales_stage,win_probability,expected_close,date_created,account_manager,type,lead_source,product,forecast_category,next_steps,competitor,loss_reason,region) FROM '/Users/alexandrebacmann/Documents/[01] Alexandre/Developer/Projects/Sika_Case_Study/Sika_Project/csv_file/latam_opportunity.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
