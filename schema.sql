-- PostgreSQL data warehouse V1 initialization for Cross-border Data Decision Platform
-- Run as CREATE DATABASE crossborder_dw; then connect with \c crossborder_dw before executing the rest.

CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS ods;
CREATE SCHEMA IF NOT EXISTS dwd;
CREATE SCHEMA IF NOT EXISTS ads;

-- raw tables (ingestion landing zone)
CREATE TABLE IF NOT EXISTS raw.raw_asin_market (
    event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    asin TEXT NOT NULL,
    sku TEXT,
    platform TEXT,
    title TEXT,
    category TEXT,
    price NUMERIC(12,2),
    currency TEXT,
    scrape_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    metadata JSONB
);

CREATE TABLE IF NOT EXISTS raw.raw_reviews (
    event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    asin TEXT NOT NULL,
    sku TEXT,
    reviewer_id TEXT,
    review_text TEXT,
    rating NUMERIC(3,2),
    review_date DATE,
    language TEXT,
    raw_payload JSONB,
    ingest_time TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS raw.raw_sales (
    event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    asin TEXT NOT NULL,
    sku TEXT,
    platform TEXT,
    sales_date DATE,
    units INTEGER,
    revenue NUMERIC(14,2),
    currency TEXT,
    raw_payload JSONB,
    ingest_time TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ods tables (cleaned dimensional/loading-ready level)
CREATE TABLE IF NOT EXISTS ods.products (
    product_key BIGSERIAL PRIMARY KEY,
    asin TEXT NOT NULL,
    sku TEXT,
    title TEXT,
    brand TEXT,
    category TEXT,
    platform TEXT,
    last_update TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ods.reviews (
    review_key BIGSERIAL PRIMARY KEY,
    asin TEXT NOT NULL,
    sku TEXT,
    reviewer_id TEXT,
    rating NUMERIC(3,2),
    review_date DATE,
    sentiment_score NUMERIC(5,4),
    platform TEXT,
    processed_time TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ods.sales (
    sales_key BIGSERIAL PRIMARY KEY,
    asin TEXT NOT NULL,
    sku TEXT,
    platform TEXT NOT NULL,
    date DATE NOT NULL,
    units INTEGER,
    revenue NUMERIC(14,2),
    currency TEXT,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT ods_sales_unique UNIQUE (date, asin, sku, platform)
);

CREATE TABLE IF NOT EXISTS ods.sif_calibration (
    calibration_key BIGSERIAL PRIMARY KEY,
    asin TEXT NOT NULL,
    sku TEXT,
    platform TEXT,
    calibration_date DATE NOT NULL,
    score NUMERIC(5,4),
    status TEXT,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- indexes for common query patterns
CREATE INDEX IF NOT EXISTS idx_raw_asin_market_asin ON raw.raw_asin_market (asin);
CREATE INDEX IF NOT EXISTS idx_raw_reviews_asin ON raw.raw_reviews (asin);
CREATE INDEX IF NOT EXISTS idx_raw_reviews_sku ON raw.raw_reviews (sku);
CREATE INDEX IF NOT EXISTS idx_raw_reviews_review_date ON raw.raw_reviews (review_date);
CREATE INDEX IF NOT EXISTS idx_raw_sales_asin ON raw.raw_sales (asin);
CREATE INDEX IF NOT EXISTS idx_raw_sales_sku ON raw.raw_sales (sku);
CREATE INDEX IF NOT EXISTS idx_raw_sales_sales_date ON raw.raw_sales (sales_date);
CREATE INDEX IF NOT EXISTS idx_ods_products_asin ON ods.products (asin);
CREATE INDEX IF NOT EXISTS idx_ods_products_sku ON ods.products (sku);
CREATE INDEX IF NOT EXISTS idx_ods_sales_date ON ods.sales (date);
CREATE INDEX IF NOT EXISTS idx_ods_sales_asin ON ods.sales (asin);
CREATE INDEX IF NOT EXISTS idx_ods_sales_sku ON ods.sales (sku);
CREATE INDEX IF NOT EXISTS idx_ods_sif_calibration_asin ON ods.sif_calibration (asin);
CREATE INDEX IF NOT EXISTS idx_ods_sif_calibration_date ON ods.sif_calibration (calibration_date);
