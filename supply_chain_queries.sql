-- =================================================================
--  GLOBAL SUPPLY CHAIN RISK ANALYSIS -- SQL QUERIES
--  Table: shipments | Compatible: PostgreSQL / MySQL / SQLite
-- =================================================================

-- SETUP: Create table
CREATE TABLE IF NOT EXISTS shipments (
    shipment_id               VARCHAR(20)  PRIMARY KEY,
    shipment_date             DATE,
    origin_port               VARCHAR(50),
    destination_port          VARCHAR(50),
    transport_mode            VARCHAR(20),
    product_category          VARCHAR(50),
    distance_km               DECIMAL(10,2),
    weight_mt                 DECIMAL(10,2),
    fuel_price_index          DECIMAL(5,2),
    geopolitical_risk_score   DECIMAL(4,1),
    weather_condition         VARCHAR(20),
    carrier_reliability_score DECIMAL(4,3),
    lead_time_days            DECIMAL(8,2),
    disruption_occurred       SMALLINT
);
-- PostgreSQL load: COPY shipments FROM '/path/to/file.csv' CSV HEADER;

-- =================================================================
-- Q1: Overall disruption rate
-- =================================================================
SELECT
    COUNT(*)                                        AS total_shipments,
    SUM(disruption_occurred)                        AS total_disrupted,
    ROUND(AVG(disruption_occurred) * 100, 2)        AS disruption_rate_pct,
    ROUND((1 - AVG(disruption_occurred)) * 100, 2)  AS on_time_rate_pct
FROM shipments;

-- =================================================================
-- Q2: Weather condition vs disruption
-- =================================================================
SELECT
    weather_condition,
    COUNT(*)                                        AS shipments,
    SUM(disruption_occurred)                        AS disrupted,
    ROUND(AVG(disruption_occurred) * 100, 1)        AS disruption_rate_pct
FROM shipments
GROUP BY weather_condition
ORDER BY disruption_rate_pct DESC;

-- =================================================================
-- Q3: Geopolitical risk bands vs disruption
-- =================================================================
SELECT
    CASE
        WHEN geopolitical_risk_score <= 2 THEN '0-2  (Low)'
        WHEN geopolitical_risk_score <= 4 THEN '2-4  (Moderate-Low)'
        WHEN geopolitical_risk_score <= 6 THEN '4-6  (Moderate)'
        WHEN geopolitical_risk_score <= 8 THEN '6-8  (High)'
        ELSE                                   '8-10 (Critical)'
    END                                             AS geo_risk_band,
    COUNT(*)                                        AS shipments,
    ROUND(AVG(disruption_occurred) * 100, 1)        AS disruption_rate_pct
FROM shipments
GROUP BY geo_risk_band
ORDER BY MIN(geopolitical_risk_score);

-- =================================================================
-- Q4: Transport mode -- disruption rate AND lead time
-- =================================================================
SELECT
    transport_mode,
    COUNT(*)                                        AS shipments,
    ROUND(AVG(disruption_occurred) * 100, 1)        AS disruption_rate_pct,
    ROUND(AVG(lead_time_days), 2)                   AS avg_lead_time_days,
    ROUND(MIN(lead_time_days), 2)                   AS min_lead_days,
    ROUND(MAX(lead_time_days), 2)                   AS max_lead_days
FROM shipments
GROUP BY transport_mode
ORDER BY avg_lead_time_days;

-- =================================================================
-- Q5: Product category risk
-- =================================================================
SELECT
    product_category,
    COUNT(*)                                        AS shipments,
    ROUND(AVG(disruption_occurred) * 100, 1)        AS disruption_rate_pct,
    ROUND(AVG(lead_time_days), 1)                   AS avg_lead_days,
    ROUND(AVG(geopolitical_risk_score), 2)          AS avg_geo_risk
FROM shipments
GROUP BY product_category
ORDER BY disruption_rate_pct DESC;

-- =================================================================
-- Q6: Route heatmap -- origin x destination
-- =================================================================
SELECT
    origin_port,
    destination_port,
    COUNT(*)                                        AS shipments,
    ROUND(AVG(disruption_occurred) * 100, 1)        AS disruption_rate_pct,
    ROUND(AVG(lead_time_days), 1)                   AS avg_lead_days
FROM shipments
GROUP BY origin_port, destination_port
ORDER BY disruption_rate_pct DESC;

-- Top 10 riskiest routes
SELECT
    origin_port,
    destination_port,
    COUNT(*)                                        AS shipments,
    ROUND(AVG(disruption_occurred) * 100, 1)        AS disruption_rate_pct
FROM shipments
GROUP BY origin_port, destination_port
HAVING COUNT(*) >= 5
ORDER BY disruption_rate_pct DESC
LIMIT 10;

-- =================================================================
-- Q7: Lead time -- disrupted vs on-time
-- =================================================================
SELECT
    CASE WHEN disruption_occurred = 1 THEN 'Disrupted' ELSE 'Not Disrupted' END AS status,
    COUNT(*)                                        AS shipments,
    ROUND(AVG(lead_time_days), 2)                   AS avg_lead_days,
    ROUND(MIN(lead_time_days), 2)                   AS min_days,
    ROUND(MAX(lead_time_days), 2)                   AS max_days,
    ROUND(STDDEV(lead_time_days), 2)                AS stddev_days
FROM shipments
GROUP BY disruption_occurred
ORDER BY disruption_occurred DESC;

-- Lead time multiplier
SELECT
    ROUND(AVG(CASE WHEN disruption_occurred=1 THEN lead_time_days END), 2) AS avg_disrupted,
    ROUND(AVG(CASE WHEN disruption_occurred=0 THEN lead_time_days END), 2) AS avg_ok,
    ROUND(
        AVG(CASE WHEN disruption_occurred=1 THEN lead_time_days END) /
        AVG(CASE WHEN disruption_occurred=0 THEN lead_time_days END), 2
    ) AS multiplier
FROM shipments;

-- =================================================================
-- Q8: Carrier reliability bands vs disruption
-- =================================================================
SELECT
    CASE
        WHEN carrier_reliability_score < 0.6 THEN '< 0.60 (Poor)'
        WHEN carrier_reliability_score < 0.7 THEN '0.60-0.70'
        WHEN carrier_reliability_score < 0.8 THEN '0.70-0.80'
        WHEN carrier_reliability_score < 0.9 THEN '0.80-0.90'
        ELSE                                      '>= 0.90 (Excellent)'
    END                                             AS carrier_band,
    COUNT(*)                                        AS shipments,
    ROUND(AVG(disruption_occurred) * 100, 1)        AS disruption_rate_pct
FROM shipments
GROUP BY carrier_band
ORDER BY carrier_band;

-- =================================================================
-- Q9: Monthly trend
-- =================================================================
SELECT
    EXTRACT(YEAR  FROM shipment_date)               AS year,
    EXTRACT(MONTH FROM shipment_date)               AS month,
    COUNT(*)                                        AS shipments,
    ROUND(AVG(disruption_occurred) * 100, 1)        AS disruption_rate_pct
FROM shipments
GROUP BY year, month
ORDER BY year, month;

-- =================================================================
-- Q10: Rule-based risk scoring (pre-shipment)
-- =================================================================
SELECT
    shipment_id,
    origin_port,
    destination_port,
    weather_condition,
    geopolitical_risk_score,
    lead_time_days,
    carrier_reliability_score,
    disruption_occurred,
    -- Composite risk score (0-100)
    ROUND(
        (CASE weather_condition
            WHEN 'Hurricane' THEN 40
            WHEN 'Storm'     THEN 28
            WHEN 'Fog'       THEN 12
            WHEN 'Rain'      THEN 10
            ELSE 5
         END)
        + (geopolitical_risk_score * 3)
        + (CASE
            WHEN lead_time_days > 50 THEN 15
            WHEN lead_time_days > 20 THEN 10
            WHEN lead_time_days > 5  THEN 5
            ELSE 2
           END)
        + (CASE
            WHEN carrier_reliability_score < 0.6 THEN 10
            WHEN carrier_reliability_score < 0.7 THEN 7
            WHEN carrier_reliability_score < 0.8 THEN 4
            ELSE 1
           END)
    , 0) AS risk_score
FROM shipments
ORDER BY risk_score DESC
LIMIT 50;

-- =================================================================
-- BONUS: KPI Dashboard Summary
-- =================================================================
SELECT 'Total Shipments'         AS metric, CAST(COUNT(*) AS TEXT) AS value FROM shipments
UNION ALL
SELECT 'Disruption Rate',         CAST(ROUND(AVG(disruption_occurred)*100,1) AS TEXT)||'%' FROM shipments
UNION ALL
SELECT 'Avg Lead (All)',           CAST(ROUND(AVG(lead_time_days),1) AS TEXT)||' days' FROM shipments
UNION ALL
SELECT 'Avg Lead (Disrupted)',     CAST(ROUND(AVG(CASE WHEN disruption_occurred=1 THEN lead_time_days END),1) AS TEXT)||' days' FROM shipments
UNION ALL
SELECT 'Avg Lead (On-Time)',       CAST(ROUND(AVG(CASE WHEN disruption_occurred=0 THEN lead_time_days END),1) AS TEXT)||' days' FROM shipments;
