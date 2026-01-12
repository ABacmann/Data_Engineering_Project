-- =========================================================
-- Pipeline Value
-- Definition:
--   Total and probability-weighted value of all open opportunities
--   (i.e. excluding Closed Won and Closed Lost).
-- =========================================================

SELECT
  region,

  -- Total pipeline assuming all open deals close
  ROUND(SUM(amount_usd), 2) AS total_pipeline_usd,

  -- Expected pipeline value weighted by win probability
  ROUND(
    SUM(amount_usd * COALESCE(probability, 0) / 100),
    2
  ) AS weighted_pipeline_usd

FROM opportunities_curated
WHERE stage NOT IN ('Closed Won', 'Closed Lost')
  AND amount_usd IS NOT NULL
GROUP BY region
ORDER BY region;


-- =========================================================
-- Global Pipeline Summary
-- =========================================================

SELECT
  'Global' AS scope,
  ROUND(SUM(amount_usd), 2) AS total_pipeline_usd,
  ROUND(
    SUM(amount_usd * COALESCE(probability, 0) / 100),
    2
  ) AS weighted_pipeline_usd
FROM opportunities_curated
WHERE stage NOT IN ('Closed Won', 'Closed Lost')
  AND amount_usd IS NOT NULL;