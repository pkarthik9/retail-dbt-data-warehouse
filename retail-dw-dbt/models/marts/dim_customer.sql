select
    customer_id,
    first_name,
    last_name,
    first_name || ' ' || last_name as full_name,
    email,
    country,
    signup_date,
    date_diff('day', signup_date, current_date) as days_since_signup
from {{ ref('stg_customers') }}
