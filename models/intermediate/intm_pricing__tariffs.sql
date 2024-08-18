-- intm_pricing__tariffs
-- extract tariff_valid_from and tariff_valid_to to check if current date is within range
-- extract applies_on_day out into a row for each day to allow for easy joining to days of the week

WITH extract_fields AS (
  SELECT
    rule_id,        
    tariff->>'$.price' AS price,        
    tariff->>'$.size' AS duration,        
    tariff->>'$.applies_on_days[*]' AS applies_on_days,
    tariff->>'$.applies_from' AS applies_from,  
    tariff->>'$.applies_to' AS applies_to,
    tariff->>'$.interval' AS interval,
    tariff->>'$.repeat' AS repeat,
    tariff->>'$.applies_between' AS applies_between
  FROM
    {{ ref('base_pricing__rules') }}
),

add_valid_from_to AS (
  SELECT 
    * EXCLUDE (applies_between, duration),
    TRY_CAST(duration AS INTEGER) AS duration, 
    CAST(SUBSTRING(applies_between, 4, 10) AS DATE) AS tariff_valid_from,
    CAST(SUBSTRING(applies_between, 17, 10) AS DATE) AS tariff_valid_to        
  FROM 
    extract_fields
),

extract_applies_on_days AS (
  SELECT
    *,            
  FROM  
    add_valid_from_to, UNNEST(applies_on_days) AS rule_applies_on
)

SELECT 
  p.* EXCLUDE (applies_on_days_1), 
  applies_on_days_1 AS applies_on_day,
  day_of_week_name AS applies_on_day_name
FROM   
  extract_applies_on_days AS p
  INNER JOIN {{ ref('day_of_week_map') }} AS s
  ON p.applies_on_days_1 = s.day_of_week_index
