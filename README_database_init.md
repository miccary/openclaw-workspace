# PostgreSQL Data Warehouse Initialization — Crossborder DW V1

## Goal
Stand up the `crossborder_dw` PostgreSQL database with key schemas (`raw`, `ods`, `dwd`, `ads`) and the MVP tables required for the cross-border AI data stack (ASIN metadata, reviews, sales, and the first SIF calibration table).

## Steps
1. **Create the database** (if not already present):
   ```sql
   CREATE DATABASE crossborder_dw;
   ```
2. **Connect to the new database**:
   ```sh
   psql -U postgres -h 127.0.0.1 -d crossborder_dw
   ```
3. **Execute the schema script**:
   ```sh
   \\i /path/to/schema.sql
   ```
   The script builds the schemas, tables, indexes, and the `ods.sales` unique constraint.
4. **Seed sample data** (optional MVP flow): use ETL tooling to move `sample_data.csv` through `raw` → `ods` and verify `ods.sales` upserts honor the `(date, asin, sku, platform)` constraint.
5. **Document the process**: keep `table_definition.md` synced, and mention the new DW architecture in `system_health_dashboard` or Notion updates that track cross-border AI infrastructure.

## Notes
- All SQL is PostgreSQL-compatible; avoid using other dialect's features.
- Indexes on `asin`, `sku`, and `date` accelerate analytics queries and should remain even as schema evolves.
- The `dwd`/`ads` schemas are present for future layers (data mart / analytical datasets) and are left empty in V1.
- After initial setup, capture the schema version and data quality checkpoints in Notion or the project's dashboard so we can trace subsequent pipeline builds.
