-- =========================================================
-- Task 3 - 00_standardize_contact_fields.sql
-- Purpose:
--   Standardize contact fields (email, phone) for reliable
--   deduplication, joins, and analytics.
--
-- Design principles:
--   - Preserve raw values
--   - Add deterministic, reproducible "clean" fields
--   - Centralize formatting logic
-- =========================================================


-- =========================================================
-- Leads: standardized contact fields
-- =========================================================
DROP VIEW IF EXISTS vw_leads_contact_clean;

CREATE VIEW vw_leads_contact_clean AS
SELECT
  l.*,

  -- ---------------------------------------------------------
  -- Email standardization
  --  - lowercase
  --  - trim spaces
  --  - empty string → NULL
  -- ---------------------------------------------------------
  NULLIF(lower(trim(l.email)), '') AS email_clean,

  -- ---------------------------------------------------------
  -- Phone standardization
  --  - keep digits and leading +
  --  - remove spaces, dashes, parentheses, dots
  --  - empty string → NULL
  -- ---------------------------------------------------------
  NULLIF(
    regexp_replace(l.phone, '[^0-9+]', '', 'g'),
    ''
  ) AS phone_clean

FROM vw_leads_standardized l;


-- =========================================================
-- Opportunities: passthrough (kept for symmetry)
-- =========================================================
DROP VIEW IF EXISTS vw_opportunities_contact_clean;

CREATE VIEW vw_opportunities_contact_clean AS
SELECT
  o.*
FROM vw_opportunities_standardized o;
