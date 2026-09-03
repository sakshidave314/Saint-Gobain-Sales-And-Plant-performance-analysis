SELECT * FROM "order" limit 10;
-- SOLUTION TO BUSINESS QUESTIONS --

-- 1. What is total revenue, total cost, and average margin % by month/quarter — is margin actually declining over time? --
SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(unit_price_inr) AS total_revenue,
    SUM(unit_cost_inr) AS total_cost,
    ROUND(
        (
            (SUM(unit_price_inr) - SUM(unit_cost_inr)) * 100.0
            / SUM(unit_price_inr)
        )::numeric,
        2
    ) AS margin_percentage
FROM "order"
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY DATE_TRUNC('month', order_date);





-- 2. Which product_type has the worst margin trend, and is it getting worse or better? --


	SELECT
    product_type,
    ROUND(
        AVG(
            (
                (unit_price_inr - unit_cost_inr) * 100.0
                / unit_price_inr
            )::numeric
        ),
        2
    ) AS avg_margin
FROM "order"
GROUP BY product_type
ORDER BY avg_margin ASC;

-- 3. Is the margin decline explained more by rising unit_cost_inr or by unit_price_inr not keeping pace? --

SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(unit_price_inr) AS total_revenue,
    SUM(unit_cost_inr) AS total_cost,

    SUM(unit_price_inr)
      - LAG(SUM(unit_price_inr))
        OVER (ORDER BY DATE_TRUNC('month', order_date)) AS revenue_change,

    SUM(unit_cost_inr)
      - LAG(SUM(unit_cost_inr))
        OVER (ORDER BY DATE_TRUNC('month', order_date)) AS cost_change
FROM "order"
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;

-- 4. What is the average defect_rate_pct by plant and shift? Is Night shift at any plant significantly worse? --

SELECT
    plant,
    shift,
    ROUND(AVG(defect_rate_pct)::numeric, 2) AS avg_defect_rate
FROM "order"
GROUP BY
    plant,
    shift
ORDER BY
    plant,
    avg_defect_rate DESC;

-- 5. Does product_type interact with plant/shift to make defects worse? --

SELECT
    product_type,
    plant,
    shift,
    ROUND(AVG(defect_rate_pct)::numeric, 2) AS avg_defect_rate
FROM "order"
GROUP BY
    product_type,
    plant,
    shift
ORDER BY
    avg_defect_rate DESC;

-- 6. How has defect rate trended over the last 12 months per plant — improving, stable, or worsening? --
SELECT
    DATE_TRUNC('month', order_date) AS month,
    plant,
    ROUND(AVG(defect_rate_pct)::numeric, 2) AS avg_defect_rate
FROM "order"
WHERE order_date >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY
    DATE_TRUNC('month', order_date),
    plant
ORDER BY
    plant,
    month;

-- 7. What % of orders have customer_complaint = true, broken down by region, plant, and product_type? --
SELECT
    region,
    plant,
    product_type,
    COUNT(*) AS total_orders,
    SUM(
        CASE
            WHEN customer_complaint = 'Yes' THEN 1
            ELSE 0
        END
    ) AS complaint_orders,
    ROUND(
        (
            SUM(
                CASE
                    WHEN customer_complaint = 'Yes' THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*)
        )::numeric,
        2
    ) AS complaint_percentage
FROM "order"
GROUP BY
    region,
    plant,
    product_type
ORDER BY
    complaint_percentage DESC;

-- 8. Is there a correlation between delivery_delay_days and complaint rate? At what delay threshold do complaints spike?--

SELECT
    delivery_delay_days,
    COUNT(*) AS total_orders,
    SUM(
        CASE
            WHEN customer_complaint = 'Yes' THEN 1
            ELSE 0
        END
    ) AS complaint_orders,
    ROUND(
        (
            SUM(
                CASE
                    WHEN customer_complaint = 'Yes' THEN 1
                    ELSE 0
                END
            ) * 100.0
            / COUNT(*)
        )::numeric,
        2
    ) AS complaint_rate
FROM "order"
GROUP BY delivery_delay_days
ORDER BY delivery_delay_days;

-- 9. 