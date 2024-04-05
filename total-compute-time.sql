-- NOTE: This query is the same logic as the STAC Model Data Results Notebook


SELECT 
    model_id
  , collection
  , AVG(computation_time_minutes::interval) AS mean_compute_time_minutes
  , PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY computation_time_minutes::interval) AS median_compute_time_minutes
  , MIN(computation_time_minutes::interval) AS min_compute_time_minutes
  , MAX(computation_time_minutes::interval) AS max_compute_time_minutes
FROM (
  SELECT 
      id
    , split_part(id, '-', 1) AS model_id
    , split_part(id, '-', 3) AS simulation
    , collection
    , content
    , content -> 'properties' ->> 'results_summary:computation_time_total' AS computation_time_minutes
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
