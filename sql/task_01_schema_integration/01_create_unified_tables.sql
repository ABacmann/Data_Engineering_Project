DROP TABLE IF EXISTS unified_opportunities;
DROP TABLE IF EXISTS unified_leads;

CREATE TABLE unified_leads (
  lead_id               TEXT PRIMARY KEY,
  first_name            TEXT,
  last_name             TEXT,
  email                 TEXT,
  phone                 TEXT,
  company_name          TEXT,
  job_title             TEXT,
  industry              TEXT,
  lead_status           TEXT,
  lead_source           TEXT,
  lead_rating           TEXT,
  company_size          TEXT,
  product_interest      TEXT,
  campaign_id           TEXT,
  country_code          TEXT,
  created_at            TIMESTAMPTZ,
  converted_at          TIMESTAMPTZ,
  last_activity_at      TIMESTAMPTZ,
  website               TEXT,
  description_or_notes  TEXT,
  region                TEXT,
  source_system         TEXT
);

CREATE INDEX IF NOT EXISTS idx_unified_leads_email ON unified_leads (email);
CREATE INDEX IF NOT EXISTS idx_unified_leads_company ON unified_leads (company_name);

CREATE TABLE unified_opportunities (
  opportunity_id     TEXT PRIMARY KEY,
  lead_id            TEXT NOT NULL,
  opportunity_name   TEXT,
  amount_usd         NUMERIC(18,2),
  stage              TEXT,
  probability        NUMERIC(5,2),
  sales_type         TEXT,
  product_line       TEXT,
  expected_close_at  TIMESTAMPTZ,
  created_at         TIMESTAMPTZ,
  forecast_category  TEXT,
  next_step          TEXT,
  competitor         TEXT,
  loss_reason        TEXT,
  region             TEXT,
  source_system      TEXT
);

CREATE INDEX IF NOT EXISTS idx_unified_opps_lead_id ON unified_opportunities (lead_id);
CREATE INDEX IF NOT EXISTS idx_unified_opps_stage ON unified_opportunities (stage);

-- Optional FK once you are sure lead IDs will match (Task 3 decides how to handle orphans)
-- ALTER TABLE unified_opportunities
--   ADD CONSTRAINT fk_unified_opps_lead FOREIGN KEY (lead_id)
--   REFERENCES unified_leads(lead_id);
