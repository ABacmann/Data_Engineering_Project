-- =========================================================
-- 5_insert_valid_opportunities.sql
-- Purpose:
--   Insert opportunities into the final opportunity tables ONLY when
--   the referenced lead exists (FK-safe).
--
-- Why:
--   Raw data can contain orphan opportunities. We explicitly filter them
--   instead of failing the entire load.
-- =========================================================

-- Optional: start fresh if you re-run loads
TRUNCATE TABLE na_opportunity;
TRUNCATE TABLE latam_opportunity;

-- Insert NA opportunities where LeadID exists in na_lead
INSERT INTO na_opportunity (
  "OpportunityID","LeadID","OpportunityName","Amount","Stage","Probability","ExpectedCloseDate","CreatedDate",
  "AccountOwner","SalesType","LeadSourceOpp","ProductLine","ForecastCategory","NextStep","CompetitorInfo","LossReason","Region"
)
SELECT
  s."OpportunityID", s."LeadID", s."OpportunityName", s."Amount", s."Stage", s."Probability", s."ExpectedCloseDate", s."CreatedDate",
  s."AccountOwner", s."SalesType", s."LeadSourceOpp", s."ProductLine", s."ForecastCategory", s."NextStep", s."CompetitorInfo", s."LossReason", s."Region"
FROM na_opportunity_stg s
JOIN na_lead l
  ON l."LeadID" = s."LeadID";

-- Insert LATAM opportunities where lead_id exists in latam_lead
INSERT INTO latam_opportunity (
  opportunity_id,lead_id,opportunity_name,deal_amount,sales_stage,win_probability,expected_close,date_created,
  account_manager,type,lead_source,product,forecast_category,next_steps,competitor,loss_reason,region
)
SELECT
  s.opportunity_id, s.lead_id, s.opportunity_name, s.deal_amount, s.sales_stage, s.win_probability, s.expected_close, s.date_created,
  s.account_manager, s.type, s.lead_source, s.product, s.forecast_category, s.next_steps, s.competitor, s.loss_reason, s.region
FROM latam_opportunity_stg s
JOIN latam_lead l
  ON l.lead_id = s.lead_id;
