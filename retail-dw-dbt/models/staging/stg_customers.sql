with source as (
    select * from {{ ref('raw_customers') }}
),

cleaned as (
    select
        customer_id,
        initcap(first_name) as first_name,
        initcap(last_name) as last_name,
        lower(trim(email)) as email,
        country,
        cast(signup_date as date) as signup_date
    from source
    where customer_id is not null
)

select * from cleaned
