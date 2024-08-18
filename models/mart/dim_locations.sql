-- dim_locations
-- Details not provided of location description, so just populate with location_id as placeholder

SELECT
  DISTINCT location_id,
  CAST(location_id AS STRING) AS location_description    
FROM
  {{ ref('intm_pricing__prices') }}
