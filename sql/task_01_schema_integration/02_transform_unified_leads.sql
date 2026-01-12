TRUNCATE TABLE unified_leads;

-- NA → unified
INSERT INTO unified_leads (
  lead_id, first_name, last_name, email, phone, company_name, job_title,
  industry, lead_status, lead_source, lead_rating, company_size,
  product_interest, campaign_id, country_code, created_at, converted_at,
  last_activity_at, website, description_or_notes, region, source_system
)
SELECT
  "LeadID"                                      AS lead_id,
  "FirstName"                                   AS first_name,
  "LastName"                                    AS last_name,
  LOWER(NULLIF("EmailAddress", ''))             AS email,
  NULLIF("PhoneNumber", '')                     AS phone,
  NULLIF("CompanyName", '')                     AS company_name,
  NULLIF("JobTitle", '')                        AS job_title,
  NULLIF("Industry", '')                        AS industry,
  NULLIF("LeadStatus", '')                      AS lead_status,
  NULLIF("LeadSource", '')                      AS lead_source,
  NULLIF("LeadRating", '')                      AS lead_rating,
  NULLIF("CompanySize", '')                     AS company_size,
  NULLIF("ProductInterest", '')                 AS product_interest,
  NULLIF("CampaignID", '')                      AS campaign_id,
  NULLIF("Country", '')                         AS country_code,   -- standardized later (Task 2)
  "CreatedDate"                                 AS created_at,
  "ConvertedDate"                               AS converted_at,
  "LastActivityDate"                            AS last_activity_at,
  NULLIF("Website", '')                         AS website,
  NULLIF("Description", '')                     AS description_or_notes,
  COALESCE(NULLIF("Region", ''), 'North America') AS region,          -- keep as in source or normalize later
  'na'                                          AS source_system
FROM na_lead;

-- LATAM → unified
INSERT INTO unified_leads (
  lead_id, first_name, last_name, email, phone, company_name, job_title,
  industry, lead_status, lead_source, lead_rating, company_size,
  product_interest, campaign_id, country_code, created_at, converted_at,
  last_activity_at, website, description_or_notes, region, source_system
)
SELECT
  lead_id                                       AS lead_id,
  first_name                                    AS first_name,
  last_name                                     AS last_name,
  LOWER(NULLIF(email_address, ''))              AS email,
  NULLIF(phone, '')                             AS phone,
  NULLIF(company, '')                           AS company_name,
  NULLIF(job_title, '')                         AS job_title,
  NULLIF(industry_sector, '')                   AS industry,
  NULLIF(status, '')                            AS lead_status,
  NULLIF(source, '')                            AS lead_source,
  NULLIF(rating, '')                            AS lead_rating,
  NULLIF(size, '')                              AS company_size,
  NULLIF(product_interest, '')                  AS product_interest,
  NULLIF(campaign_code, '')                     AS campaign_id,
  NULLIF(country_code, '')                      AS country_code,
  date_created                                  AS created_at,
  date_converted                                AS converted_at,
  last_activity                                 AS last_activity_at,
  NULLIF(web_site, '')                          AS website,
  NULLIF(notes, '')                             AS description_or_notes,
  COALESCE(NULLIF(region, ''), 'LATAM')         AS region,
  'latam'                                       AS source_system
FROM latam_lead;
