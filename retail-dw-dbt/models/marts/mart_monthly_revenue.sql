select
    date_trunc('month', sale_date) as sale_month,
    category,
    channel,
    sum(line_total) as total_revenue,
    sum(quantity) as units_sold,
    count(distinct sale_id) as num_sales,
    round(avg(line_total), 2) as avg_sale_value
from {{ ref('fact_sales') }}
group by 1, 2, 3
order by 1
