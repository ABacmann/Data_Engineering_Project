-- =========================================================
-- Task 2 - 01_create_mapping_tables.sql
-- Purpose: Create corporate mapping tables.
-- Design: map_key = normalized raw string (lower/trim).
-- Extensibility: add rows, don't change code.
-- =========================================================

DROP TABLE IF EXISTS map_lead_source;
CREATE TABLE map_lead_source (
  raw_key      TEXT PRIMARY KEY,   -- e.g., 'web form', 'website', 'linkedin'
  standard     TEXT NOT NULL        -- e.g., 'Website', 'LinkedIn'
);

DROP TABLE IF EXISTS map_industry;
CREATE TABLE map_industry (
  raw_key      TEXT PRIMARY KEY,
  standard     TEXT NOT NULL
);

DROP TABLE IF EXISTS map_company_size;
CREATE TABLE map_company_size (
  raw_key      TEXT PRIMARY KEY,
  standard     TEXT NOT NULL
);

DROP TABLE IF EXISTS map_lead_rating;
CREATE TABLE map_lead_rating (
  raw_key      TEXT PRIMARY KEY,
  standard     TEXT NOT NULL
);

DROP TABLE IF EXISTS map_lead_status;
CREATE TABLE map_lead_status (
  raw_key      TEXT PRIMARY KEY,
  standard     TEXT NOT NULL
);

DROP TABLE IF EXISTS map_opp_stage;
CREATE TABLE map_opp_stage (
  raw_key      TEXT PRIMARY KEY,
  standard     TEXT NOT NULL
);

DROP TABLE IF EXISTS map_sales_type;
CREATE TABLE map_sales_type (
  raw_key      TEXT PRIMARY KEY,
  standard     TEXT NOT NULL
);

DROP TABLE IF EXISTS map_product_line;
CREATE TABLE map_product_line (
  raw_key      TEXT PRIMARY KEY,
  standard     TEXT NOT NULL
);

DROP TABLE IF EXISTS map_country_code;
CREATE TABLE map_country_code (
  raw_key      TEXT PRIMARY KEY,
  standard     TEXT NOT NULL        -- ISO 3166-1 alpha-2
);
