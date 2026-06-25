with source as (
    select * from {{ ref('raw_sales') }}
),

cleaned as (
    select
        sale_id,
        customer_id,
        product_id,
        cast(sale_date as date) as sale_date,
        quantity,
        cast(unit_price as decimal(10,2)) as unit_price,
        quantity * unit_price as line_total,
        channel
    from source
    where quantity > 0
)

select * from cleaned
