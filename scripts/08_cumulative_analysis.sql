/*
===============================================================================
Analisis Kumulatif
===============================================================================
Tujuan:
    - Untuk menghitung total berjalan (running total) atau rata-rata bergerak (moving average) untuk metrik utama.
    - Untuk melacak performa secara kumulatif dari waktu ke waktu.
    - Berguna untuk analisis pertumbuhan atau mengidentifikasi tren jangka panjang.
Fungsi SQL yang Digunakan:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Calculate the total sales per month
-- and the running total of sales over time
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER (
		PARTITION BY YEAR(order_date) -- Reset the running total at the start of each year
		ORDER BY order_date
		) AS running_total_sales,	-- Running total of sales over time
	avg_price,
	AVG(avg_price) OVER (
		PARTITION BY YEAR(order_date) 
		ORDER BY order_date
		) AS running_avg_price,		-- Running average price over time
	AVG(avg_price) OVER (
		PARTITION BY YEAR(order_date) 
		ORDER BY order_date
		ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
		) AS moving_avg_price		-- Moving average price over the last 3 months
FROM
	(
	SELECT
		DATETRUNC(MONTH, order_date) AS order_date,
		SUM(sales_amount) AS total_sales,
		AVG(price) AS avg_price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(MONTH, order_date)
	) t;
