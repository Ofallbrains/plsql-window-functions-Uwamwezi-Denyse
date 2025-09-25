-- QUERY 1: ROW_NUMBER() - Top Customers by Total Revenue
--Screenshot 1
SELECT 
    customer_id,
    name,
    province,
    total_revenue,
    ROW_NUMBER() OVER (ORDER BY total_revenue DESC) as row_num
FROM (
    SELECT 
        c.customer_id, 
        c.name, 
        c.province,
        SUM(t.amount_rwf) as total_revenue
    FROM customers c
    JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.name, c.province
) customer_revenue
ORDER BY total_revenue DESC;

-- QUERY 2: RANK() vs DENSE_RANK() - Comparing ranking with ties
--Screenshot 2
SELECT 
    customer_id,
    name,
    province,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) as rank_pos,
    DENSE_RANK() OVER (ORDER BY total_revenue DESC) as dense_rank_pos,
    ROW_NUMBER() OVER (ORDER BY total_revenue DESC) as row_num
FROM (
    SELECT 
        c.customer_id, 
        c.name, 
        c.province,
        SUM(t.amount_rwf) as total_revenue
    FROM customers c
    JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.name, c.province
) customer_revenue
ORDER BY total_revenue DESC;

-- QUERY 3: PERCENT_RANK() - Percentile ranking for customer segmentation
-- Screenshot 3
SELECT 
    customer_id,
    name,
    province,
    total_revenue,
    -- PERCENT_RANK(): Shows percentile position (0 = lowest, 1 = highest)
    ROUND(PERCENT_RANK() OVER (ORDER BY total_revenue DESC), 3) as percent_rank,
    -- Convert to percentage for easier interpretation
    ROUND(PERCENT_RANK() OVER (ORDER BY total_revenue DESC) * 100, 1) as percentile,
    -- Customer tier based on percentile
    CASE 
        WHEN PERCENT_RANK() OVER (ORDER BY total_revenue DESC) >= 0.8 THEN 'TOP 20%'
        WHEN PERCENT_RANK() OVER (ORDER BY total_revenue DESC) >= 0.6 THEN 'TOP 40%'
        WHEN PERCENT_RANK() OVER (ORDER BY total_revenue DESC) >= 0.4 THEN 'MIDDLE 40%'
        WHEN PERCENT_RANK() OVER (ORDER BY total_revenue DESC) >= 0.2 THEN 'LOWER 40%'
        ELSE 'BOTTOM 20%'
    END as customer_tier
FROM (
    SELECT 
        c.customer_id, 
        c.name, 
        c.province,
        SUM(t.amount_rwf) as total_revenue
    FROM customers c
    JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.name, c.province
) customer_revenue
ORDER BY total_revenue DESC;