-- fact_prices_tariffs
-- join prices to tariffs as the base fact table

SELECT
  location_id,  
  p.rule_id,
  applies_on_day_name,
  duration,
  tariff_valid_from,
  tariff_valid_to,
  created_at,
  deleted_at,
  price        
FROM
   {{ ref('intm_pricing__prices') }} AS p
  INNER JOIN  {{ ref('intm_pricing__tariffs') }} AS t
  ON p.rule_id = t.rule_id        
