-- =========================================================
-- Task 3 - 04_orphan_and_logic_checks.sql
-- Purpose:
--   Detect:
--     - orphan opportunities (should be 0 in the current pipeline, but we check)
--     - converted leads with no opportunities (business logic issue)
-- =========================================================

-- ---------- Orphan opportunities ----------
SELECT
  o.source_system,
  COUNT(*) AS orphan_opportunities
FROM unified_opportunities o
LEFT JOIN unified_leads l
  ON l.lead_id = o.lead_id
WHERE l.lead_id IS NULL
GROUP BY o.source_system
ORDER BY o.source_system;

-- ---------- Converted leads with no opportunities ----------
-- Definition: lead_status_std='Converted' but no related opportunity in unified_opportunities
SELECT
  l.source_system,
  COUNT(*) AS converted_leads_without_opps
FROM vw_leads_standardized l
LEFT JOIN unified_opportunities o
  ON o.lead_id = l.lead_id
WHERE l.lead_status_std = 'Converted'
  AND o.lead_id IS NULL
GROUP BY l.source_system
ORDER BY l.source_system;

-- Optional: drill down sample
SELECT
  l.lead_id, l.email, l.company_name, l.lead_status, l.lead_status_std, l.source_system
FROM vw_leads_standardized l
LEFT JOIN unified_opportunities o ON o.lead_id = l.lead_id
WHERE l.lead_status_std = 'Converted'
  AND o.lead_id IS NULL
ORDER BY l.source_system, l.lead_id
LIMIT 50;
