-- =========================================================
-- Opportunity Win Rate
-- Definition:
--   % of opportunities that are Closed Won
-- =========================================================

SELECT
  region,
  COUNT(*)                               AS total_opportunities,
  COUNT(*) FILTER (WHERE stage = 'Closed Won') AS won_opportunities,
  ROUND(
    COUNT(*) FILTER (WHERE stage = 'Closed Won')::NUMERIC
    / NULLIF(COUNT(*), 0) * 100,
    2
  ) AS win_rate_pct
FROM opportunities_curated
GROUP BY region
ORDER BY win_rate_pct DESC;