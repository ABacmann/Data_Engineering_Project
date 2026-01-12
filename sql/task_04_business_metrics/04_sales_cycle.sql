-- =========================================================
-- Sales Cycle Length (days)
-- Definition:
--   Average time (in days) from lead creation to
--   expected close date for Closed Won opportunities.
--
-- Rationale:
--   - Opportunity creation happens same-day as lead creation
--   - expected_close_at is the best available proxy for deal closure
--   - only Closed Won deals represent completed sales cycles
-- =========================================================

SELECT
  o.region,

  COUNT(*) AS closed_won_deals,

  ROUND(
    AVG(
      EXTRACT(EPOCH FROM (o.expected_close_at - l.created_at)) / 86400
    ),
    2
  ) AS avg_sales_cycle_days_from_lead,
    ROUND(
    AVG(
      EXTRACT(EPOCH FROM (o.expected_close_at - o.created_at)) / 86400
    ),
    2
  ) AS avg_sales_cycle_days_from_opp


FROM opportunities_curated o
JOIN leads_curated l
  ON l.lead_id = o.lead_id

WHERE
  o.stage = 'Closed Won'                  -- only completed deals
  AND o.expected_close_at IS NOT NULL     -- must have close proxy
  AND l.created_at IS NOT NULL            -- must have lead start
  AND o.expected_close_at >= l.created_at -- guard against bad data
GROUP BY o.region
ORDER BY o.region;

