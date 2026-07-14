/*
===============================================================================
Eksplorasi Rentang Tanggal 
===============================================================================
Tujuan:
    - Untuk menentukan batasan waktu dari titik-titik data utama.
    - Untuk memahami rentang data historis.
Fungsi SQL yang Digunakan:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Find the date of the first, last order, and how many years of sales are available in the fact_sales table
SELECT 
	MIN(order_date) AS first_orrder_date,
	MAX(order_date) AS last_order_date,
	DATEDIFF(year, MIN(order_date), MAX(order_date)) AS order_range_years
FROM gold.fact_sales

-- Find the youngest and oldest customer
SELECT 
	MIN(birthdate) AS oldest_customer_birthdate,
	DATEDIFF(year, MIN(birthdate), GETDATE()) AS age_oldest_customer,
	MAX(birthdate) AS youngest_customer_birthdate,
	DATEDIFF(year, MAX(birthdate), GETDATE()) AS age_youngest_customer
FROM gold.dim_customers