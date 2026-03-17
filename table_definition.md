# PostgreSQL data warehouse V1 — table definitions

## Schemas
- `raw`: Landing zone for inbound feeds (ASIN metadata, reviews, sales events).
- `ods`: Cleaned/standardized staging area for downstream analytics. Includes light dimension tables (`products`) and fact tables (`sales`, `reviews`, `sif_calibration`).
- `dwd`, `ads`: Reserved for future data warehouse modeling (not yet populated in V1).

## Tables

### raw.raw_asin_market
- **Purpose**: Capture unprocessed ASIN-level metadata coming from marketplaces and suppliers.
- **Key columns**: `asin`, `sku`, `platform`, `title`, `category`, `price`, `scrape_time`, `metadata` (JSONB to store raw payloads).
- **Indexes**: `idx_raw_asin_market_asin` on `asin`.

### raw.raw_reviews
- **Purpose**: Ingest raw review streams before cleansing.
- **Key columns**: `asin`, `sku`, `reviewer_id`, `rating`, `review_date`, `review_text`, `language`, `raw_payload`.
- **Indexes**: `idx_raw_reviews_asin`, `idx_raw_reviews_sku`, `idx_raw_reviews_review_date`.

### raw.raw_sales
- **Purpose**: Landing table for transaction-level sales data (units/revenue) per platform.
- **Key columns**: `asin`, `sku`, `platform`, `sales_date`, `units`, `revenue`, `currency`, `raw_payload`.
- **Indexes**: `idx_raw_sales_asin`, `idx_raw_sales_sku`, `idx_raw_sales_sales_date`.

### ods.products
- **Purpose**: Standardized product dimension used by analytics & AI models.
- **Key columns**: `asin`, `sku`, `title`, `brand`, `category`, `platform`, `last_update`.
- **Indexes**: `idx_ods_products_asin`, `idx_ods_products_sku`.

### ods.reviews
- **Purpose**: Processed reviews with sentiment scores ready for reporting.
- **Key columns**: `asin`, `sku`, `reviewer_id`, `rating`, `review_date`, `sentiment_score`, `platform`.

### ods.sales
- **Purpose**: Clean fact table storing daily sales per ASIN/SKU/platform.
- **Key columns**: `date`, `asin`, `sku`, `platform`, `units`, `revenue`, `currency`, `updated_at`.
- **Indexes**: `idx_ods_sales_date`, `idx_ods_sales_asin`, `idx_ods_sales_sku`.
- **Constraints**: Unique constraint on `(date, asin, sku, platform)` to avoid duplicate daily records.

### ods.sif_calibration
- **Purpose**: Store daily signal calibration metrics for the Sales Influence Framework (SIF).
- **Key columns**: `asin`, `sku`, `platform`, `calibration_date`, `score`, `status`, `updated_at`.
- **Indexes**: `idx_ods_sif_calibration_asin`, `idx_ods_sif_calibration_date`.
