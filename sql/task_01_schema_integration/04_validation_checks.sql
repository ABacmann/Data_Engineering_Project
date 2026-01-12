-- Row counts by source system
SELECT source_system, COUNT(*) AS leads
FROM unified_leads
GROUP BY source_system;

SELECT source_system, COUNT(*) AS opportunities
FROM unified_opportunities
GROUP BY source_system;

-- Orphan opportunities (expected; Task 3 will define the policy)
SELECT
  o.source_system,
  COUNT(*) FILTER (WHERE l.lead_id IS NULL) AS orphan_opportunities,
  COUNT(*) AS total_opportunities
FROM unified_opportunities o
LEFT JOIN unified_leads l
  ON l.lead_id = o.lead_id
GROUP BY o.source_system
ORDER BY o.source_system;

-- Basic uniqueness check
SELECT COUNT(*) AS total_opps, COUNT(DISTINCT opportunity_id) AS distinct_opps
FROM unified_opportunities;
