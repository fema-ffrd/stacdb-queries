-- NOTE: This query is the same logic as the STAC Model Data Results Notebook


SELECT 
    model_id
  , collection
  , AVG(volume_error_pct::DECIMAL(18, 5)) AS mean_volume_error_pct
  , PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY volume_error_pct::DECIMAL(18, 5)) AS median_volume_error_pct
  , MIN(volume_error_pct::DECIMAL(18, 5)) AS min_volume_error_pct
  , MAX(volume_error_pct::DECIMAL(18, 5)) AS max_volume_error_pct
FROM (
  SELECT id
    , split_part(id, '-', 1) AS model_id
    , split_part(id, '-', 3) AS simulation
    , collection
    , content
    , content -> 'properties' ->> 'volume_accounting:error_percent' AS volume_error_pct
  FROM pgstac.items
  WHERE collection LIKE '%-simulations%'
  ) AS simulations
GROUP BY 
   model_id
  ,collection
ORDER BY model_id
