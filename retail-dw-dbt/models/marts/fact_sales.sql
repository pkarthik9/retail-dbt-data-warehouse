select
    s.sale_id,
    s.customer_id,
    s.product_id,
    s.sale_date,
    s.quantity,
    s.unit_price,
    s.line_total,
    s.channel,
    p.category,
    p.price_tier
from {{ ref('stg_sales') }} s
left join {{ ref('dim_product') }} p
    on s.product_id = p.product_id
