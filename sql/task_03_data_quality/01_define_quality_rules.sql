-- =========================================================
-- Task 3 - 01_define_quality_rules.sql
-- Purpose:
--   Define helper functions and a simple table for rule thresholds.
--   Keeps your quality logic centralized and easy to adjust.
-- =========================================================

-- Optional: extension for fuzzy matching later (bonus)
-- CREATE EXTENSION IF NOT EXISTS pg_trgm;

DROP TABLE IF EXISTS dq_params;
CREATE TABLE dq_params (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);

-- Basic thresholds / assumptions (adjust if needed)
INSERT INTO dq_params (key, value) VALUES
('min_email_length', '5'),
('prob_min', '0'),
('prob_max', '100')
ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;
