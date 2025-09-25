-- QUERY 1: ROW_NUMBER() - Top Customers by Total Revenue
--Screenshot 3
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
--Screenshot 4
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
-- Screenshot 5
SELECT 
    customer_id,
    name,
    province,
    total_revenue,
    -- PERCENT_RANK(): Shows percentile position (0 = lowest, 1 = highest)
    ROUND(PERCENT_RANK() OVER (ORDER BY total_revenue DESC), 3) as percent_rank,
    ROUND(PERCENT_RANK() OVER (ORDER BY total_revenue DESC) * 100, 1) as percentile,
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

-- QUERY 4: Top customers per province using PARTITION BY
-- Screenshot 6
SELECT 
    customer_id,
    name,
    province,
    total_revenue,
    RANK() OVER (PARTITION BY province ORDER BY total_revenue DESC) as province_rank,
    RANK() OVER (ORDER BY total_revenue DESC) as overall_rank
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
ORDER BY province, total_revenue DESC;

-- QUERY 5: Running totals by transaction date
-- Shows cumulative revenue growth over time
-- Screenshot 7
SELECT 
    transaction_date,
    customer_id,
    transaction_type,
    amount_rwf,
    -- Running total of all transactions
    SUM(amount_rwf) OVER (ORDER BY transaction_date) as running_total,
    SUM(amount_rwf) OVER (PARTITION BY customer_id ORDER BY transaction_date) as customer_running_total
FROM transactions
ORDER BY transaction_date, customer_id;

-- QUERY 6: 3-transaction moving average comparison (ROWS vs RANGE)
-- Shows difference between physical rows and logical ranges
--Screenshot 8
SELECT 
    transaction_date,
    customer_id,
    amount_rwf,
    ROUND(AVG(amount_rwf) OVER (
        ORDER BY transaction_date 
        ROWS 2 PRECEDING
    ), 2) as moving_avg_rows,
    ROUND(AVG(amount_rwf) OVER (
        ORDER BY transaction_date 
        RANGE UNBOUNDED PRECEDING
    ), 2) as cumulative_avg_range,
    COUNT(*) OVER (
        ORDER BY transaction_date 
        ROWS 2 PRECEDING
    ) as window_size
FROM transactions
ORDER BY transaction_date;

-- QUERY 7: Month-over-month revenue growth using LAG/LEAD
-- Shows previous and next month comparisons
-- Screenshot 9
SELECT 
    revenue_month,
    monthly_revenue,
    LAG(monthly_revenue, 1) OVER (ORDER BY revenue_month) as prev_month_revenue,
    LEAD(monthly_revenue, 1) OVER (ORDER BY revenue_month) as next_month_revenue,
    ROUND(
        ((monthly_revenue - LAG(monthly_revenue, 1) OVER (ORDER BY revenue_month)) / 
         NULLIF(LAG(monthly_revenue, 1) OVER (ORDER BY revenue_month), 0)) * 100, 2
    ) as mom_growth_pct
FROM (
    SELECT 
        TO_CHAR(transaction_date, 'YYYY-MM') as revenue_month,
        SUM(amount_rwf) as monthly_revenue
    FROM transactions
    GROUP BY TO_CHAR(transaction_date, 'YYYY-MM')
) monthly_data
ORDER BY revenue_month;

-- QUERY 8: Customer transaction frequency analysis
-- Shows gaps between customer transactions
-- Screenshot 10
SELECT 
    customer_id,
    transaction_date,
    amount_rwf,
    transaction_type,
    LAG(transaction_date, 1) OVER (PARTITION BY customer_id ORDER BY transaction_date) as prev_transaction_date,
    transaction_date - LAG(transaction_date, 1) OVER (PARTITION BY customer_id ORDER BY transaction_date) as days_between_transactions,
    LAG(amount_rwf, 1) OVER (PARTITION BY customer_id ORDER BY transaction_date) as prev_amount
FROM transactions
ORDER BY customer_id, transaction_date;

-- QUERY 9: Customer segmentation using NTILE(4)
-- Divides customers into 4 equal groups based on revenue
-- Screenshot 11
SELECT 
    customer_id,
    name,
    province,
    total_revenue,
    -- Divide into 4 quartiles
    NTILE(4) OVER (ORDER BY total_revenue DESC) as revenue_quartile,
    CASE NTILE(4) OVER (ORDER BY total_revenue DESC)
        WHEN 1 THEN 'Premium (Q1)'
        WHEN 2 THEN 'High Value (Q2)'
        WHEN 3 THEN 'Medium Value (Q3)'
        WHEN 4 THEN 'Basic (Q4)'
    END as customer_segment
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

-- QUERY 10: Cumulative distribution of customer revenue
-- Shows what percentage of customers fall below each revenue level
--Screenshot 12
SELECT 
    customer_id,
    name,
    province,
    total_revenue,
    -- Cumulative distribution (0-1)
    ROUND(CUME_DIST() OVER (ORDER BY total_revenue), 3) as cume_dist,
    -- Convert to percentage
    ROUND(CUME_DIST() OVER (ORDER BY total_revenue) * 100, 1) as cumulative_pct,
    -- Market position description
    CASE 
        WHEN CUME_DIST() OVER (ORDER BY total_revenue) >= 0.9 THEN 'Top 10%'
        WHEN CUME_DIST() OVER (ORDER BY total_revenue) >= 0.75 THEN 'Top 25%'
        WHEN CUME_DIST() OVER (ORDER BY total_revenue) >= 0.5 THEN 'Above Average'
        ELSE 'Below Average'
    END as market_position
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

-- QUERY 11: Running totals by province and transaction type
-- Shows cumulative revenue by different business segments
--Screenshot 13
SELECT 
    transaction_date,
    c.province,
    t.transaction_type,
    t.amount_rwf,
    -- Running total by province
    SUM(t.amount_rwf) OVER (
        PARTITION BY c.province 
        ORDER BY t.transaction_date
    ) as province_running_total,
    -- Running total by transaction type
    SUM(t.amount_rwf) OVER (
        PARTITION BY t.transaction_type 
        ORDER BY t.transaction_date
    ) as type_running_total,
    -- Overall running total
    SUM(t.amount_rwf) OVER (ORDER BY t.transaction_date) as overall_running_total
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
ORDER BY t.transaction_date;

-- QUERY 12: Multiple moving averages for trend analysis
-- Compares 3-day, 7-day, and overall averages
--Screenshot 14
SELECT 
    transaction_date,
    daily_revenue,
    -- 3-transaction moving average
    ROUND(AVG(daily_revenue) OVER (
        ORDER BY transaction_date 
        ROWS 2 PRECEDING
    ), 2) as ma_3_days,
    -- 5-transaction moving average  
    ROUND(AVG(daily_revenue) OVER (
        ORDER BY transaction_date 
        ROWS 4 PRECEDING
    ), 2) as ma_5_days,
    -- Overall cumulative average
    ROUND(AVG(daily_revenue) OVER (
        ORDER BY transaction_date 
        RANGE UNBOUNDED PRECEDING
    ), 2) as cumulative_avg,
    -- Min and Max in 3-day window
    MIN(daily_revenue) OVER (
        ORDER BY transaction_date 
        ROWS 2 PRECEDING
    ) as min_3_days,
    MAX(daily_revenue) OVER (
        ORDER BY transaction_date 
        ROWS 2 PRECEDING
    ) as max_3_days
FROM (
    SELECT 
        transaction_date,
        SUM(amount_rwf) as daily_revenue
    FROM transactions
    GROUP BY transaction_date
) daily_totals
ORDER BY transaction_date;

-- QUERY 13: Customer transaction patterns with LAG/LEAD
-- Analyzes transaction timing and amount changes
-- Screenshot 15
SELECT 
    c.name,
    c.province,
    t.transaction_date,
    t.amount_rwf,
    t.transaction_type,
    -- Previous transaction details
    LAG(t.amount_rwf, 1) OVER (
        PARTITION BY c.customer_id 
        ORDER BY t.transaction_date
    ) as prev_amount,
    LAG(t.transaction_type, 1) OVER (
        PARTITION BY c.customer_id 
        ORDER BY t.transaction_date
    ) as prev_type,
    -- Next transaction amount
    LEAD(t.amount_rwf, 1) OVER (
        PARTITION BY c.customer_id 
        ORDER BY t.transaction_date
    ) as next_amount,
    -- Amount change from previous transaction
    t.amount_rwf - LAG(t.amount_rwf, 1) OVER (
        PARTITION BY c.customer_id 
        ORDER BY t.transaction_date
    ) as amount_change,
    -- Days between transactions
    t.transaction_date - LAG(t.transaction_date, 1) OVER (
        PARTITION BY c.customer_id 
        ORDER BY t.transaction_date
    ) as days_gap
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
ORDER BY c.name, t.transaction_date;

-- QUERY 14: Month-over-month growth by province
-- Shows regional performance trends
--Screenshot 16
SELECT 
    revenue_month,
    province,
    monthly_revenue,
    -- Previous month revenue for same province
    LAG(monthly_revenue, 1) OVER (
        PARTITION BY province 
        ORDER BY revenue_month
    ) as prev_month_revenue,
    -- Growth amount
    monthly_revenue - LAG(monthly_revenue, 1) OVER (
        PARTITION BY province 
        ORDER BY revenue_month
    ) as growth_amount,
    -- Growth percentage
    ROUND(
        ((monthly_revenue - LAG(monthly_revenue, 1) OVER (
            PARTITION BY province ORDER BY revenue_month
        )) / NULLIF(LAG(monthly_revenue, 1) OVER (
            PARTITION BY province ORDER BY revenue_month
        ), 0)) * 100, 2
    ) as growth_pct,
    -- Year-over-year comparison (if available)
    LAG(monthly_revenue, 12) OVER (
        PARTITION BY province 
        ORDER BY revenue_month
    ) as same_month_last_year
FROM (
    SELECT 
        TO_CHAR(t.transaction_date, 'YYYY-MM') as revenue_month,
        c.province,
        SUM(t.amount_rwf) as monthly_revenue
    FROM transactions t
    JOIN customers c ON t.customer_id = c.customer_id
    GROUP BY TO_CHAR(t.transaction_date, 'YYYY-MM'), c.province
) monthly_data
ORDER BY province, revenue_month;

-- QUERY 15: Customer quartiles within each province
-- Shows top performers in each regional market
--Screenshot 17
SELECT 
    customer_id,
    name,
    province,
    total_revenue,
    -- Global quartile (across all customers)
    NTILE(4) OVER (ORDER BY total_revenue DESC) as global_quartile,
    -- Province-specific quartile
    NTILE(4) OVER (
        PARTITION BY province 
        ORDER BY total_revenue DESC
    ) as province_quartile,
    -- Segment labels
    CASE NTILE(4) OVER (ORDER BY total_revenue DESC)
        WHEN 1 THEN 'Global Premium'
        WHEN 2 THEN 'Global High'
        WHEN 3 THEN 'Global Medium' 
        WHEN 4 THEN 'Global Basic'
    END as global_segment,
    CASE NTILE(4) OVER (PARTITION BY province ORDER BY total_revenue DESC)
        WHEN 1 THEN 'Regional Leader'
        WHEN 2 THEN 'Regional High'
        WHEN 3 THEN 'Regional Medium'
        WHEN 4 THEN 'Regional Basic'
    END as regional_segment
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
ORDER BY province, total_revenue DESC;

-- QUERY 16: Customer revenue distribution analysis
-- Shows market share and customer concentration
--Screenshot 18
SELECT 
    customer_id,
    name,
    province,
    total_revenue,
    -- Cumulative distribution
    ROUND(CUME_DIST() OVER (ORDER BY total_revenue DESC), 3) as cume_dist,
    -- Percentile rank (opposite of CUME_DIST)
    ROUND(PERCENT_RANK() OVER (ORDER BY total_revenue DESC), 3) as percent_rank,
    -- Revenue percentile
    ROUND((1 - CUME_DIST() OVER (ORDER BY total_revenue DESC)) * 100, 1) as revenue_percentile,
    -- Market share percentage
    ROUND((total_revenue / SUM(total_revenue) OVER()) * 100, 2) as market_share_pct,
    -- Customer classification
    CASE 
        WHEN PERCENT_RANK() OVER (ORDER BY total_revenue DESC) <= 0.1 THEN 'VIP (Top 10%)'
        WHEN PERCENT_RANK() OVER (ORDER BY total_revenue DESC) <= 0.2 THEN 'Premium (Top 20%)'
        WHEN PERCENT_RANK() OVER (ORDER BY total_revenue DESC) <= 0.5 THEN 'Standard (Top 50%)'
        ELSE 'Basic (Bottom 50%)'
    END as customer_class
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

-- QUERY 17: Advanced frame specifications (ROWS vs RANGE)
-- Shows different windowing approaches for analysis
--Screenshot 19
SELECT 
    transaction_date,
    amount_rwf,
    -- ROWS: Physical row-based window
    SUM(amount_rwf) OVER (
        ORDER BY transaction_date 
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) as sum_rows_3,
    -- RANGE: Logical value-based window  
    SUM(amount_rwf) OVER (
        ORDER BY transaction_date 
        RANGE BETWEEN INTERVAL '1' DAY PRECEDING 
        AND INTERVAL '1' DAY FOLLOWING
    ) as sum_range_3days,
    -- Moving window statistics
    AVG(amount_rwf) OVER (
        ORDER BY transaction_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as avg_last_3,
    COUNT(*) OVER (
        ORDER BY transaction_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as count_window,
    -- First and last values in window
    FIRST_VALUE(amount_rwf) OVER (
        ORDER BY transaction_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as first_in_window,
    LAST_VALUE(amount_rwf) OVER (
        ORDER BY transaction_date 
        ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
    ) as last_in_window
FROM transactions
ORDER BY transaction_date;

-- QUERY 18: Service plan ranking and performance metrics
-- Analyzes which plans generate most revenue
--Screenshot 20
SELECT 
    sp.plan_name,
    sp.plan_type,
    sp.monthly_fee,
    customer_count,
    total_revenue,
    avg_revenue_per_customer,
    -- Plan ranking by total revenue
    RANK() OVER (ORDER BY total_revenue DESC) as revenue_rank,
    -- Plan ranking by customer count
    RANK() OVER (ORDER BY customer_count DESC) as popularity_rank,
    -- Plan ranking by average revenue per customer
    RANK() OVER (ORDER BY avg_revenue_per_customer DESC) as arpu_rank,
    -- Market share of each plan
    ROUND((total_revenue / SUM(total_revenue) OVER()) * 100, 2) as market_share_pct
FROM (
    SELECT 
        sp.plan_id,
        sp.plan_name,
        sp.plan_type,
        sp.monthly_fee,
        COUNT(DISTINCT s.customer_id) as customer_count,
        SUM(t.amount_rwf) as total_revenue,
        ROUND(SUM(t.amount_rwf) / COUNT(DISTINCT s.customer_id), 2) as avg_revenue_per_customer
    FROM service_plans sp
    JOIN subscriptions s ON sp.plan_id = s.plan_id
    JOIN transactions t ON s.customer_id = t.customer_id
    WHERE s.status = 'Active'
    GROUP BY sp.plan_id, sp.plan_name, sp.plan_type, sp.monthly_fee
) plan_metrics
ORDER BY total_revenue DESC;