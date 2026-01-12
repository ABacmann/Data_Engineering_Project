-- =========================================================
-- 3_load_leads.sql
-- Purpose:
--   Load lead CSVs directly into lead tables (parent tables).
--   This must run before loading opportunities (FK dependency).
-- =========================================================

\copy na_lead ("LeadID","FirstName","LastName","EmailAddress","PhoneNumber","CompanyName","JobTitle","Industry","LeadStatus","LeadSource","Country","State_Province","PostalCode","AnnualRevenue","NumberOfEmployees","CompanySize","LeadRating","LeadScore","CampaignID","ProductInterest","CreatedDate","ConvertedDate","LastActivityDate","Description","Website","Region") FROM '/Users/alexandrebacmann/Documents/[01] Alexandre/Developer/Projects/Sika_Case_Study/Sika_Project/csv_file/na_lead.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy latam_lead (lead_id,first_name,last_name,email_address,phone,company,job_title,industry_sector,status,source,country_code,state,zip_code,annual_revenue_usd,employee_count,size,rating,score,campaign_code,product_interest,date_created,date_converted,last_activity,notes,web_site,region) FROM '/Users/alexandrebacmann/Documents/[01] Alexandre/Developer/Projects/Sika_Case_Study/Sika_Project/csv_file/latam_lead.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
