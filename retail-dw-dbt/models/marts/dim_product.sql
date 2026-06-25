select
    product_id,
    product_name,
    category,
    unit_price,
    case
        when unit_price < 25 then 'budget'
        when unit_price < 100 then 'mid-range'
        else 'premium'
    end as price_tier
from {{ ref('stg_products') }}
