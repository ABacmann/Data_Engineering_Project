TRUNCATE TABLE unified_opportunities;

-- NA → unified
INSERT INTO unified_opportunities (
  opportunity_id, lead_id, opportunity_name, amount_usd, stage, probability,
  sales_type, product_line, expected_close_at, created_at, forecast_category,
  next_step, competitor, loss_reason, region, source_system
)
SELECT
  "OpportunityID"                    AS opportunity_id,
  "LeadID"                           AS lead_id,
  NULLIF("OpportunityName", '')      AS opportunity_name,
  "Amount"                           AS amount_usd,
  "Stage"                            AS stage,
  "Probability"                      AS probability,
  NULLIF("SalesType", '')            AS sales_type,
  NULLIF("ProductLine", '')          AS product_line,
  "ExpectedCloseDate"                AS expected_close_at,
  "CreatedDate"                      AS created_at,
  NULLIF("ForecastCategory", '')     AS forecast_category,
  NULLIF("NextStep", '')             AS next_step,
  NULLIF("CompetitorInfo", '')       AS competitor,
  NULLIF("LossReason", '')           AS loss_reason,
  COALESCE(NULLIF("Region", ''), 'North America') AS region,
  'na'                               AS source_system
FROM na_opportunity;

-- LATAM → unified
INSERT INTO unified_opportunities (
  opportunity_id, lead_id, opportunity_name, amount_usd, stage, probability,
  sales_type, product_line, expected_close_at, created_at, forecast_category,
  next_step, competitor, loss_reason, region, source_system
)
SELECT
  opportunity_id                     AS opportunity_id,
  lead_id                            AS lead_id,
  NULLIF(opportunity_name, '')       AS opportunity_name,
  deal_amount                        AS amount_usd,
  sales_stage                        AS stage,
  win_probability                    AS probability,
  NULLIF(type, '')                   AS sales_type,
  NULLIF(product, '')                AS product_line,
  expected_close                     AS expected_close_at,
  date_created                       AS created_at,
  NULLIF(forecast_category, '')      AS forecast_category,
  NULLIF(next_steps, '')             AS next_step,
  NULLIF(competitor, '')             AS competitor,
  NULLIF(loss_reason, '')            AS loss_reason,
  COALESCE(NULLIF(region, ''), 'LATAM') AS region,
  'latam'                            AS source_system
FROM latam_opportunity;
