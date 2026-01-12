-- =========================================================
-- Task 2 - 02_seed_mapping_tables.sql
-- Purpose:
--   Seed mapping tables using OBSERVED raw values from your dataset.
--   We store raw_key in normalized form: lower(trim(raw_value)).
--   Standardization is applied later via views (raw data stays untouched).
-- =========================================================


-- =========================
-- A) Lead Source
-- Map to: Website, Referral, Cold Call, LinkedIn, Trade Show,
--         Email Marketing, Partner, Paid Ads, Other
-- =========================
INSERT INTO map_lead_source (raw_key, standard) VALUES
('referral',         'Referral'),
('cold call',        'Cold Call'),
('linkedin',         'LinkedIn'),
('web form',         'Website'),
('trade show',       'Trade Show'),
('email marketing',  'Email Marketing'),
('partner',          'Partner'),
('paid ads',         'Paid Ads'),
('website',          'Website'),
('advertisement',    'Paid Ads')
ON CONFLICT (raw_key) DO UPDATE
SET standard = EXCLUDED.standard;


-- =========================
-- B) Industry
-- Map to: Technology, Financial Services, Healthcare, Retail,
--         Manufacturing, Education, Other
-- =========================
INSERT INTO map_industry (raw_key, standard) VALUES
('education',           'Education'),
('healthcare',          'Healthcare'),
('health care',         'Healthcare'),
('health',              'Healthcare'),
('financial services',  'Financial Services'),
('finance',             'Financial Services'),
('tech',                'Technology'),
('technology',          'Technology'),
('retail',              'Retail'),
('retail & consumer',   'Retail'),
('consumer goods',      'Retail'),
('manufacturing',       'Manufacturing')
ON CONFLICT (raw_key) DO UPDATE
SET standard = EXCLUDED.standard;


-- =========================
-- C) Company Size
-- Map to: 1-10 employees, 11-50 employees, 51-200 employees,
--         201-1000 employees, 1000+ employees
-- =========================
INSERT INTO map_company_size (raw_key, standard) VALUES
('small',       '1-10 employees'),
('1-10',        '1-10 employees'),
('1 to 10',     '1-10 employees'),

('11-50',       '11-50 employees'),

('51-200',      '51-200 employees'),

('medium',      '201-1000 employees'),
('201-1000',    '201-1000 employees'),

('large',       '1000+ employees'),
('1000+',       '1000+ employees'),
('enterprise',  '1000+ employees')
ON CONFLICT (raw_key) DO UPDATE
SET standard = EXCLUDED.standard;


-- =========================
-- D) Lead Rating
-- Map to: Hot, Warm, Cold
-- =========================
INSERT INTO map_lead_rating (raw_key, standard) VALUES
('hot',   'Hot'),
('h',     'Hot'),
('a',     'Hot'),

('warm',  'Warm'),
('w',     'Warm'),
('b',     'Warm'),

('cold',  'Cold'),
('c',     'Cold')
ON CONFLICT (raw_key) DO UPDATE
SET standard = EXCLUDED.standard;


-- =========================
-- E) Lead Status
-- Map to: New, Contacted, Qualified, Nurturing, Disqualified, Converted
-- =========================
INSERT INTO map_lead_status (raw_key, standard) VALUES
('new',          'New'),
('contacted',    'Contacted'),
('qualified',    'Qualified'),
('nurturing',    'Nurturing'),
('disqualified', 'Disqualified'),
('converted',    'Converted')
ON CONFLICT (raw_key) DO UPDATE
SET standard = EXCLUDED.standard;


-- =========================
-- F) Country Codes
-- Map to ISO 3166-1 alpha-2: US, CA, MX, BR, AR, CL, CO, PE
-- =========================
INSERT INTO map_country_code (raw_key, standard) VALUES
('united states', 'US'),
('usa',           'US'),
('us',            'US'),

('canada',        'CA'),
('ca',            'CA'),

('mexico',        'MX'),
('mx',            'MX'),

('brazil',        'BR'),
('brasil',        'BR'),
('br',            'BR'),

('argentina',     'AR'),
('ar',            'AR'),

('chile',         'CL'),
('cl',            'CL'),

('colombia',      'CO'),
('co',            'CO'),

('peru',          'PE'),
('pe',            'PE')
ON CONFLICT (raw_key) DO UPDATE
SET standard = EXCLUDED.standard;


-- =========================
-- G) Product Interest (Lead-level)
-- Map to: Cloud Platform, Analytics Platform, Security Suite, Integration Tools
-- =========================
INSERT INTO map_product_line (raw_key, standard) VALUES
('cloud',             'Cloud Platform'),
('cloud suite',       'Cloud Platform'),

('analytics',          'Analytics Platform'),
('analytics platform', 'Analytics Platform'),

('security suite',     'Security Suite'),

('integration tools',  'Integration Tools')
ON CONFLICT (raw_key) DO UPDATE
SET standard = EXCLUDED.standard;


-- =========================
-- H) Opportunity Stage
-- Map to: Prospecting, Qualification, Needs Analysis, Proposal,
--         Negotiation, Closed Won, Closed Lost
-- =========================
INSERT INTO map_opp_stage (raw_key, standard) VALUES
('prospecting',    'Prospecting'),
('qualification',  'Qualification'),
('needs analysis', 'Needs Analysis'),
('proposal',       'Proposal'),
('negotiation',    'Negotiation'),
('closed won',     'Closed Won'),
('closed lost',    'Closed Lost')
ON CONFLICT (raw_key) DO UPDATE
SET standard = EXCLUDED.standard;


-- =========================
-- I) Sales Type
-- Map to: New Business, Upsell, Cross-sell, Renewal
-- =========================
INSERT INTO map_sales_type (raw_key, standard) VALUES
('new',          'New Business'),
('new business', 'New Business'),
('upsell',       'Upsell'),
('cross-sell',   'Cross-sell'),
('renewal',      'Renewal')
ON CONFLICT (raw_key) DO UPDATE
SET standard = EXCLUDED.standard;


-- =========================
-- J) Opportunity Product Line
-- Map to: Cloud Platform, Analytics Platform, Security Suite, Integration Tools
-- (same corporate catalog as Product Interest)
-- =========================
-- Already covered by map_product_line above:
-- 'cloud', 'cloud suite', 'analytics', 'analytics platform', 'security suite', 'integration tools'
-- so nothing extra needed.
