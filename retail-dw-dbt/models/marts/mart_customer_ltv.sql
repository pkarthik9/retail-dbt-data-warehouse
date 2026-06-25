select
    c.customer_id,
    c.full_name,
    c.country,
    c.signup_date,
    count(distinct f.sale_id) as total_orders,
    coalesce(sum(f.line_total), 0) as lifetime_value,
    max(f.sale_date) as last_purchase_date
from {{ ref('dim_customer') }} c
left join {{ ref('fact_sales') }} f
    on c.customer_id = f.customer_id
group by 1, 2, 3, 4
order by lifetime_value desc
