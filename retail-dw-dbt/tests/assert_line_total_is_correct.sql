-- Custom test: line_total in fact_sales must always equal quantity * unit_price.
-- dbt test convention: this query should return ZERO rows to pass.

select
    sale_id,
    quantity,
    unit_price,
    line_total
from {{ ref('fact_sales') }}
where round(quantity * unit_price, 2) != round(line_total, 2)
