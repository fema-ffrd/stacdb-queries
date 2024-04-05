-- NOTE: This query is the same logic as the STAC Model Data Results Notebook

SELECT 
    model_id
  , collection
  , AVG(computation_time_minutes::interval) AS avg_compute_time_minutes
  , AVG(volume_error_pct::DECIMAL(18, 5)) AS avg_volume_accounting_error
  , AVG(precip_excess_inches::DECIMAL(18, 5)) AS avg_precip_excess_inches
  , MAX(precip_excess_inches::DECIMAL(18, 5)) AS max_precip_excess_inches
  , MIN(precip_excess_inches::DECIMAL(18, 5)) AS min_precip_excess_inches
FROM (
  SELECT 
      id
    , split_part(id, '-', 1) AS model_id
    , split_part(id, '-', 3) AS simulation
    , collection
    , content
    , content -> 'properties' ->> 'results_summary:computation_time_total' AS computation_time_minutes
    , content -> 'properties' ->> 'volume_accounting:error_percent' AS volume_error_pct
    , content -> 'properties' ->> 'volume_accounting:precipitation_excess_inches' AS precip_excess_inches
  FROM 
    pgstac.items
  WHERE 
    collection LIKE '%-simulations%'
  ) AS simulations
GROUP BY 
    model_id
  , collection
ORDER BY 
  model_id
