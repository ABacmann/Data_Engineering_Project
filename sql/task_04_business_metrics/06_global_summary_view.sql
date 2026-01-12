-- =========================================================
-- Lead Source ROI Proxy
-- Combines conversion efficiency with deal size.
-- Helps Marketing reallocate budget.
-- =========================================================

SELECT
  l.region,
  l.lead_source,
  COUNT(DISTINCT l.lead_id)                 AS total_leads,
  COUNT(DISTINCT o.lead_id)                 AS converted_leads,
  ROUND(
    COUNT(DISTINCT o.lead_id)::NUMERIC
    / COUNT(DISTINCT l.lead_id) * 100, 2
  )                                         AS conversion_rate_pct,
  ROUND(AVG(o.amount_usd), 2)               AS avg_deal_size_usd
FROM leads_curated l
LEFT JOIN opportunities_curated o
  ON o.lead_id = l.lead_id
GROUP BY l.region, l.lead_source
ORDER BY avg_deal_size_usd DESC;


-- =========================================================
-- Product–Region Fit
-- Identifies regional strengths per product line.
-- =========================================================

SELECT
  region,
  product_line,
  COUNT(*)                      AS closed_won_deals,
  ROUND(SUM(amount_usd), 2)     AS total_revenue_usd
FROM opportunities_curated
WHERE stage = 'Closed Won'
GROUP BY region, product_line
ORDER BY total_revenue_usd DESC;


-- =========================================================
-- Sales Efficiency
-- Win ratio per region.
-- =========================================================

SELECT
  region,
  COUNT(*) FILTER (WHERE stage = 'Closed Won')  AS wins,
  COUNT(*) FILTER (WHERE stage = 'Closed Lost') AS losses,
  ROUND(
    COUNT(*) FILTER (WHERE stage = 'Closed Won')::NUMERIC
    / NULLIF(COUNT(*), 0) * 100,
    2
  ) AS win_rate_pct
FROM opportunities_curated
GROUP BY region;


-- =========================================================
-- Biggest Competitor
-- =========================================================
SELECT 
  competitor,
  COUNT(*) AS frequency
FROM opportunities_curated
GROUP BY
  competitor
ORDER BY frequency DESC