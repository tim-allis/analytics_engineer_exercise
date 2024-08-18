-- base_pricing__prices.sql
-- select required columns 

SELECT
    price_id,
    location_id,
    pricing_mode,
    created_at,
    deleted_at,
    rule_id
FROM
    {{ source('pricing', 'prices') }}
