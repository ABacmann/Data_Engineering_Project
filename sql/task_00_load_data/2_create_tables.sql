-- =========================================================
-- 2_create_tables.sql
-- Purpose:
--   Create the raw source tables (NA + LATAM) with full CSV schemas
--   + foreign keys + basic indexes.
--
-- Notes:
--   - Drop child tables first because of FK dependencies.
--   - These are "raw" tables (close to the CSV sources).
-- =========================================================

-- Drop child tables first (FK dependencies)
DROP TABLE IF EXISTS na_opportunity;
DROP TABLE IF EXISTS latam_opportunity;

-- Drop parent tables
DROP TABLE IF EXISTS na_lead;
DROP TABLE IF EXISTS latam_lead;

-- =========================
-- 1) North America: lead (FULL CSV schema)
-- =========================
CREATE TABLE na_lead (
  "LeadID"            TEXT PRIMARY KEY,
  "FirstName"         TEXT,
  "LastName"          TEXT,
  "EmailAddress"      TEXT,
  "PhoneNumber"       TEXT,
  "CompanyName"       TEXT,
  "JobTitle"          TEXT,
  "Industry"          TEXT,
  "LeadStatus"        TEXT,
  "LeadSource"        TEXT,
  "Country"           TEXT,
  "State_Province"    TEXT,
  "PostalCode"        TEXT,
  "AnnualRevenue"     NUMERIC,
  "NumberOfEmployees" NUMERIC,
  "CompanySize"       TEXT,
  "LeadRating"        TEXT,
  "LeadScore"         NUMERIC,
  "CampaignID"        TEXT,
  "ProductInterest"   TEXT,
  "CreatedDate"       TIMESTAMPTZ,
  "ConvertedDate"     TIMESTAMPTZ,
  "LastActivityDate"  TIMESTAMPTZ,
  "Description"       TEXT,
  "Website"           TEXT,
  "Region"            TEXT
);

-- Helpful index for dedupe/join work later
CREATE INDEX IF NOT EXISTS idx_na_lead_email ON na_lead ("EmailAddress");

-- =========================
-- 2) LATAM: lead (FULL CSV schema, snake_case)
-- =========================
CREATE TABLE latam_lead (
  lead_id             TEXT PRIMARY KEY,
  first_name          TEXT,
  last_name           TEXT,
  email_address       TEXT,
  phone               TEXT,
  company             TEXT,
  job_title           TEXT,
  industry_sector     TEXT,
  status              TEXT,
  source              TEXT,
  country_code        TEXT,
  state               TEXT,
  zip_code            TEXT,
  annual_revenue_usd  NUMERIC,
  employee_count      NUMERIC,
  size                TEXT,
  rating              TEXT,
  score               NUMERIC,
  campaign_code       TEXT,
  product_interest    TEXT,
  date_created        TIMESTAMPTZ,
  date_converted      TIMESTAMPTZ,
  last_activity       TIMESTAMPTZ,
  notes               TEXT,
  web_site            TEXT,
  region              TEXT
);

CREATE INDEX IF NOT EXISTS idx_latam_lead_email ON latam_lead (email_address);

-- =========================
-- 3) North America: opportunity (FULL CSV schema)
-- =========================
CREATE TABLE na_opportunity (
  "OpportunityID"     TEXT PRIMARY KEY,
  "LeadID"            TEXT NOT NULL,
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
  "Region"            TEXT,

  -- Enforce that opportunities reference existing leads
  CONSTRAINT fk_na_opp_lead
    FOREIGN KEY ("LeadID") REFERENCES na_lead("LeadID")
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_na_opp_leadid ON na_opportunity ("LeadID");

-- =========================
-- 4) LATAM: opportunity (FULL CSV schema)
-- =========================
CREATE TABLE latam_opportunity (
  opportunity_id      TEXT PRIMARY KEY,
  lead_id             TEXT NOT NULL,
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
  region              TEXT,

  CONSTRAINT fk_latam_opp_lead
    FOREIGN KEY (lead_id) REFERENCES latam_lead(lead_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_latam_opp_leadid ON latam_opportunity (lead_id);
