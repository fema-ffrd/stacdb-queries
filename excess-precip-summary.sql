-- NOTE: This query is the same logic as the STAC Model Data Results Notebook


SELECT 
    model_id
  , collection
  , AVG(precip_excess_inches::DECIMAL(18, 5)) AS mean_precip_excess_inches
  , PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY precip_excess_inches::DECIMAL(18, 5)) AS median_precip_excess_inches
  , MIN(precip_excess_inches::DECIMAL(18, 5)) AS min_precip_excess_inches
  , MAX(precip_excess_inches::DECIMAL(18, 5)) AS max_precip_excess_inches
FROM (
  SELECT 
      id
    , split_part(id, '-', 1) AS model_id
    , split_part(id, '-', 3) AS simulation
    , collection
    , content
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
