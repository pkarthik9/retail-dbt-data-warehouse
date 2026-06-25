# Retail Data Warehouse (dbt + DuckDB) with BI-Ready Marts

A dimensional data warehouse built with dbt: raw sales/customer/product data is
modeled into a star schema (fact + dimensions) and rolled up into BI-ready
marts that can be plugged directly into Power BI or Looker Studio.

## Architecture

```
 ┌──────────────┐   ┌────────────────────┐   ┌───────────────────────────┐   ┌─────────────────┐
 │  Seed CSVs    │ -> │  staging models     │ -> │  marts (star schema)        │ -> │  BI dashboard    │
 │  (raw_*)      │   │  (cleaning, typing)  │   │  dim_customer, dim_product,  │   │  (Power BI /     │
 │               │   │                      │   │  fact_sales, + revenue/LTV   │   │  Looker Studio)  │
 │               │   │                      │   │  aggregate marts             │   │                   │
 └──────────────┘   └────────────────────┘   └───────────────────────────┘   └─────────────────┘
```

## Tech Stack
dbt-core · DuckDB (local warehouse, swappable for Snowflake/BigQuery) · SQL · dbt tests

## Project Structure
```
retail-dw-dbt/
├── seeds/
│   ├── raw_customers.csv
│   ├── raw_products.csv
│   ├── raw_sales.csv
│   └── schema.yml             # seed-level tests (uniqueness, relationships)
├── models/
│   ├── staging/
│   │   ├── stg_customers.sql
│   │   ├── stg_products.sql
│   │   └── stg_sales.sql
│   └── marts/
│       ├── dim_customer.sql
│       ├── dim_product.sql
│       ├── dim_date.sql
│       ├── fact_sales.sql
│       ├── mart_monthly_revenue.sql
│       ├── mart_customer_ltv.sql
│       └── schema.yml          # mart-level tests
├── tests/
│   └── assert_line_total_is_correct.sql   # custom singular test
├── dbt_project.yml
├── packages.yml                  # dbt_utils (date spine)
└── profiles.yml.example
```

## Setup

```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt

# Point dbt at the example profile (or copy it to ~/.dbt/profiles.yml)
export DBT_PROFILES_DIR=$(pwd)
cp profiles.yml.example profiles.yml

dbt deps        # installs dbt_utils
dbt seed        # loads the raw CSVs into DuckDB
dbt run         # builds staging views + mart tables
dbt test        # runs uniqueness/not-null/relationship + custom tests
```

This creates a local `retail_dw.duckdb` file containing the full warehouse —
no cloud account needed to explore the project.

## Exploring the warehouse

```bash
dbt docs generate && dbt docs serve   # interactive lineage graph + column docs
```

Or query directly:

```bash
python -c "
import duckdb
con = duckdb.connect('retail_dw.duckdb')
print(con.execute('select * from mart_monthly_revenue limit 10').df())
"
```

## Connecting a BI dashboard

`mart_monthly_revenue` and `mart_customer_ltv` are denormalized, pre-aggregated
tables designed to be the direct source for a dashboard:

- **Power BI**: use the DuckDB ODBC driver, or export the marts to CSV/Parquet
  and load via Power Query for a quick local demo.
- **Looker Studio**: easiest path is loading the DuckDB marts into a small
  Postgres/BigQuery instance (free tier) since Looker Studio doesn't connect
  to DuckDB directly — or screenshot a local exploration (e.g. via Metabase)
  for the portfolio writeup.

## Migrating to a real cloud warehouse

Only `profiles.yml` changes — add a `snowflake_prod` (or `bigquery_prod`)
output block (commented example included in `profiles.yml.example`) and run
`dbt run --target snowflake_prod`. No model SQL changes required; this is the
core benefit of dbt's adapter pattern.

## Possible Extensions
- Add incremental models for `fact_sales` once data volume grows
- Add `dbt_utils.generate_surrogate_key` for composite natural keys
- Add exposures.yml to formally document the BI dashboard as a downstream consumer
