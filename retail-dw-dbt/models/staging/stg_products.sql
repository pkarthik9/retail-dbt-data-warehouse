with source as (
    select * from {{ ref('raw_products') }}
),

cleaned as (
    select
        product_id,
        product_name,
        category,
        cast(unit_price as decimal(10,2)) as unit_price
    from source
    where unit_price > 0
)

select * from cleaned
