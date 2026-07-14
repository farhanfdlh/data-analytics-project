/*
===============================================================================
Analisis Performa (Year-over-Year, Month-over-Month)
===============================================================================
Tujuan:
    - Untuk mengukur performa produk, pelanggan, atau wilayah dari waktu ke waktu.
    - Untuk benchmarking dan mengidentifikasi entitas dengan performa tinggi.
    - Untuk melacak tren dan pertumbuhan tahunan.
Fungsi SQL yang Digunakan:
    - LAG(): Mengakses data dari baris sebelumnya.
    - AVG() OVER(): Menghitung nilai rata-rata dalam suatu partisi.
    - CASE: Mendefinisikan logika kondisional untuk analisis tren.
===============================================================================
*/

/* Analyze the yearly performance of products by comparing their sales
to both the average sales performance of the products and the previous year's sales */

-- Subquery (Yearly Performance Analysis)
SELECT
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS product_avg_sales, -- average of all years per product
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS sales_diff_from_avg,
	CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
	     WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
		 ELSE 'Avg' 
	END AS avg_change,
	-- Year-over-year Analysis
	LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS previous_year_sales,
	current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS sales_diff_from_previous_year,
	CASE WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
		 WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
		 ELSE 'No Change' 
	END AS previous_year_change
FROM 
	(
	SELECT
		YEAR(f.order_date) AS order_year,
		p.product_name,
		SUM(f.sales_amount) AS current_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products  p
		ON f.product_key = p.product_key
	WHERE f.order_date IS NOT NULL
	GROUP BY YEAR(f.order_date), p.product_name
	) t
ORDER BY product_name, order_year;


-- CTE (Monthly Performance Analysis)
WITH monthly_product_sales AS (
	SELECT
		YEAR(f.order_date) AS order_year,
		MONTH(f.order_date) AS order_month,
		p.product_name,
		SUM(f.sales_amount) AS current_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products  p
		ON f.product_key = p.product_key
	WHERE f.order_date IS NOT NULL
	GROUP BY YEAR(f.order_date), MONTH(f.order_date), p.product_name
)
SELECT
	order_year,
	order_month,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS product_avg_sales, -- average of all month per product
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS sales_diff_from_avg,
	CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
		 WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
		 ELSE 'Avg' 
	END AS avg_change,
	-- Month-over-month Analysis
	LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year, order_month) AS previous_month_sales,
	current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year, order_month) AS sales_diff_from_previous_month,
	CASE WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year, order_month) > 0 THEN 'Increase'
		 WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year, order_month) < 0 THEN 'Decrease'
		 ELSE 'No Change' 
	END AS previous_month_change
FROM monthly_product_sales
ORDER BY product_name, order_year, order_month;