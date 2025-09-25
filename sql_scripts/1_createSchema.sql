-- MTN DB schema creation
-- Create Customers Table
CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    phone_number VARCHAR2(15) UNIQUE,
    name VARCHAR2(100) NOT NULL,
    province VARCHAR2(50) NOT NULL,
    customer_type VARCHAR2(20) CHECK (customer_type IN ('Prepaid', 'Postpaid')),
    registration_date DATE NOT NULL
);

-- Create Service Plans Table
CREATE TABLE service_plans (
    plan_id NUMBER PRIMARY KEY,
    plan_name VARCHAR2(100) NOT NULL,
    plan_type VARCHAR2(50) NOT NULL,
    monthly_fee NUMBER NOT NULL,
    data_allowance_gb NUMBER
);

-- Create Subscriptions Table
CREATE TABLE subscriptions (
    subscription_id NUMBER PRIMARY KEY,
    customer_id NUMBER REFERENCES customers(customer_id),
    plan_id NUMBER REFERENCES service_plans(plan_id),
    start_date DATE NOT NULL,
    status VARCHAR2(20) CHECK (status IN ('Active', 'Inactive', 'Suspended'))
);

-- Create Usage Records Table
CREATE TABLE usage_records (
    usage_id NUMBER PRIMARY KEY,
    customer_id NUMBER REFERENCES customers(customer_id),
    usage_date DATE NOT NULL,
    voice_minutes NUMBER DEFAULT 0,
    data_mb NUMBER DEFAULT 0,
    sms_count NUMBER DEFAULT 0
);

-- Create Transactions table
CREATE TABLE transactions (
    transaction_id NUMBER PRIMARY KEY,
    customer_id NUMBER REFERENCES customers(customer_id),
    transaction_date DATE NOT NULL,
    transaction_type VARCHAR2(50) NOT NULL,
    amount_rwf NUMBER NOT NULL
);

--Verify your tables Query
SELECT table_name 
FROM user_tables 
WHERE table_name IN ('CUSTOMERS', 'SERVICE_PLANS', 'SUBSCRIPTIONS', 'USAGE_RECORDS', 'TRANSACTIONS')
ORDER BY table_name;