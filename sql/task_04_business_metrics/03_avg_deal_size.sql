-- =========================================================
-- Average Deal Size (USD)
-- =========================================================

SELECT
  region,
  product_line,
  COUNT(*)                        AS deals,
  ROUND(AVG(amount_usd), 2)       AS avg_deal_size_usd
FROM opportunities_curated
WHERE amount_usd IS NOT NULL
GROUP BY region, product_line
ORDER BY region, avg_deal_size_usd DESC;


-- =========================================================
-- Avg deal size by region & product line (sanity check)
-- =========================================================
SELECT
  region,
  product_line,
  COUNT(*)                    AS deals,
  ROUND(AVG(amount_usd), 2)   AS avg_deal_usd,
  ROUND(SUM(amount_usd), 2)   AS total_revenue_usd
FROM opportunities_curated
WHERE stage = 'Closed Won'
GROUP BY region, product_line
ORDER BY region, avg_deal_usd DESC;

SELECT *
FROM opportunities_curated


SELECT *
FROM opportunities_curated
