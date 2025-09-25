-- Insert sample data
-- Insert into customers
INSERT INTO customers VALUES (1001, '+250788123456', 'Uwimana Jean', 'Kigali', 'Postpaid', DATE '2023-03-15');
INSERT INTO customers VALUES (1002, '+250788234567', 'Mukamana Alice', 'Northern', 'Prepaid', DATE '2023-05-20');
INSERT INTO customers VALUES (1003, '+250788345678', 'Niyonzima Paul', 'Southern', 'Postpaid', DATE '2023-01-10');
INSERT INTO customers VALUES (1004, '+250788456789', 'Uwase Grace', 'Eastern', 'Prepaid', DATE '2023-07-12');
INSERT INTO customers VALUES (1005, '+250788567890', 'Hakizimana Eric', 'Western', 'Postpaid', DATE '2023-02-28');
INSERT INTO customers VALUES (1006, '+250788678901', 'Nyiramana Rose', 'Kigali', 'Prepaid', DATE '2023-06-05');
INSERT INTO customers VALUES (1007, '+250788789012', 'Bizimana John', 'Northern', 'Postpaid', DATE '2023-04-18');
INSERT INTO customers VALUES (1008, '+250788890123', 'Mukantagara Mary', 'Southern', 'Prepaid', DATE '2023-08-22');
INSERT INTO customers VALUES (1009, '+250788901234', 'Ndayambaje Pierre', 'Eastern', 'Postpaid', DATE '2023-09-10');
INSERT INTO customers VALUES (1010, '+250789012345', 'Uwineza Sarah', 'Western', 'Prepaid', DATE '2023-11-15');
INSERT INTO customers VALUES (1011, '+250789123456', 'Kagame David', 'Kigali', 'Postpaid', DATE '2023-12-01');
INSERT INTO customers VALUES (1012, '+250789234567', 'Mutoni Claire', 'Northern', 'Prepaid', DATE '2024-01-20');

-- Insert into service_plans
INSERT INTO service_plans VALUES (2001, 'MTN Smart Plus', 'Data', 15000, 10);
INSERT INTO service_plans VALUES (2002, 'MTN Smart Basic', 'Data', 8000, 5);
INSERT INTO service_plans VALUES (2003, 'MTN Voice Premium', 'Voice', 12000, 0);
INSERT INTO service_plans VALUES (2004, 'MTN MoMo Package', 'Mobile Money', 5000, 2);
INSERT INTO service_plans VALUES (2005, 'MTN Unlimited', 'Data', 25000, 50);
INSERT INTO service_plans VALUES (2006, 'MTN Student Plan', 'Data', 6000, 3);

-- Insert into subscriptions table
INSERT INTO subscriptions VALUES (3001, 1001, 2001, DATE '2024-01-15', 'Active');
INSERT INTO subscriptions VALUES (3002, 1002, 2002, DATE '2024-02-01', 'Active');
INSERT INTO subscriptions VALUES (3003, 1003, 2005, DATE '2024-01-20', 'Active');
INSERT INTO subscriptions VALUES (3004, 1004, 2004, DATE '2024-03-10', 'Active');
INSERT INTO subscriptions VALUES (3005, 1005, 2003, DATE '2024-02-15', 'Active');
INSERT INTO subscriptions VALUES (3006, 1006, 2006, DATE '2024-04-01', 'Active');
INSERT INTO subscriptions VALUES (3007, 1007, 2001, DATE '2024-03-20', 'Active');
INSERT INTO subscriptions VALUES (3008, 1008, 2002, DATE '2024-05-10', 'Active');
INSERT INTO subscriptions VALUES (3009, 1009, 2005, DATE '2024-04-15', 'Active');
INSERT INTO subscriptions VALUES (3010, 1010, 2004, DATE '2024-06-01', 'Active');

--Insert into usage_records
INSERT INTO usage_records VALUES (4001, 1001, DATE '2024-09-20', 45, 1024, 12);
INSERT INTO usage_records VALUES (4002, 1001, DATE '2024-09-19', 38, 2048, 8);
INSERT INTO usage_records VALUES (4003, 1001, DATE '2024-09-18', 52, 1536, 15);
INSERT INTO usage_records VALUES (4004, 1002, DATE '2024-09-20', 22, 512, 25);
INSERT INTO usage_records VALUES (4005, 1002, DATE '2024-09-19', 18, 768, 30);
INSERT INTO usage_records VALUES (4006, 1003, DATE '2024-09-20', 67, 3072, 5);
INSERT INTO usage_records VALUES (4007, 1003, DATE '2024-09-19', 71, 4096, 3);
INSERT INTO usage_records VALUES (4008, 1004, DATE '2024-09-20', 15, 256, 45);
INSERT INTO usage_records VALUES (4009, 1005, DATE '2024-09-20', 89, 0, 2);
INSERT INTO usage_records VALUES (4010, 1006, DATE '2024-09-20', 33, 896, 18);

--Insert into transactions
INSERT INTO transactions VALUES (5001, 1001, DATE '2024-09-20', 'Monthly_Subscription', 15000);
INSERT INTO transactions VALUES (5002, 1001, DATE '2024-09-15', 'MoMo_Transfer', 25000);
INSERT INTO transactions VALUES (5003, 1002, DATE '2024-09-20', 'Monthly_Subscription', 8000);
INSERT INTO transactions VALUES (5004, 1003, DATE '2024-09-18', 'Monthly_Subscription', 25000);
INSERT INTO transactions VALUES (5005, 1004, DATE '2024-09-19', 'MoMo_Transfer', 15000);
INSERT INTO transactions VALUES (5006, 1005, DATE '2024-09-17', 'Monthly_Subscription', 12000);
INSERT INTO transactions VALUES (5007, 1006, DATE '2024-09-25', 'Monthly_Subscription', 6000);
INSERT INTO transactions VALUES (5008, 1001, DATE '2024-08-20', 'Monthly_Subscription', 15000);
INSERT INTO transactions VALUES (5009, 1002, DATE '2024-08-20', 'Monthly_Subscription', 8000);
INSERT INTO transactions VALUES (5010, 1003, DATE '2024-08-18', 'Monthly_Subscription', 25000);
INSERT INTO transactions VALUES (5011, 1004, DATE '2024-08-19', 'MoMo_Transfer', 20000);
INSERT INTO transactions VALUES (5012, 1005, DATE '2024-08-17', 'Monthly_Subscription', 12000);
INSERT INTO transactions VALUES (5013, 1001, DATE '2024-07-20', 'Monthly_Subscription', 15000);
INSERT INTO transactions VALUES (5014, 1001, DATE '2024-07-10', 'MoMo_Transfer', 35000);
INSERT INTO transactions VALUES (5015, 1002, DATE '2024-07-20', 'Monthly_Subscription', 8000);
INSERT INTO transactions VALUES (5016, 1003, DATE '2024-07-18', 'Monthly_Subscription', 25000);
INSERT INTO transactions VALUES (5017, 1007, DATE '2024-06-20', 'Monthly_Subscription', 15000);
INSERT INTO transactions VALUES (5018, 1008, DATE '2024-06-15', 'Monthly_Subscription', 8000);
INSERT INTO transactions VALUES (5019, 1009, DATE '2024-06-10', 'Monthly_Subscription', 25000);
INSERT INTO transactions VALUES (5020, 1010, DATE '2024-05-25', 'MoMo_Transfer', 18000);
INSERT INTO transactions VALUES (5021, 1011, DATE '2024-05-20', 'Monthly_Subscription', 15000);
INSERT INTO transactions VALUES (5022, 1012, DATE '2024-05-15', 'Monthly_Subscription', 8000);

COMMIT;

--Verify if the data is inserted
SELECT 'CUSTOMERS' as table_name, COUNT(*) as row_count FROM customers
UNION ALL
SELECT 'SERVICE_PLANS', COUNT(*) FROM service_plans  
UNION ALL
SELECT 'SUBSCRIPTIONS', COUNT(*) FROM subscriptions
UNION ALL
SELECT 'USAGE_RECORDS', COUNT(*) FROM usage_records
UNION ALL
SELECT 'TRANSACTIONS', COUNT(*) FROM transactions;