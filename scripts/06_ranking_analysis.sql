/*
===============================================================================
Analisis Peringkat (Ranking)
===============================================================================
Tujuan:
    - Untuk meranking item (misalnya, produk, pelanggan) berdasarkan performa atau metrik lainnya.
    - Untuk mengidentifikasi item dengan performa terbaik atau terburuk.
Fungsi SQL yang Digunakan:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Klausa: GROUP BY, ORDER BY
===============================================================================
*/

-- Change the dimensions to see different insights about the sales data. For example, you can analyze sales by customer demographics, product categories, or time periods.
-- Which 5 products generate the highest revenue?
SELECT TOP 5 
	p.product_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
JOIN gold.dim_products p 
	ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC

SELECT * 
FROM (
	SELECT
		p.product_name,
		SUM(f.sales_amount) AS total_revenue,
		ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
	FROM gold.fact_sales f
	JOIN gold.dim_products p 
		ON f.product_key = p.product_key
	GROUP BY p.product_name
	) t
WHERE rank_products <= 5

-- What are the 5 worst-performing products in terms of sales?
SELECT TOP 5 
	p.product_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
JOIN gold.dim_products p 
	ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC

-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
JOIN gold.dim_customers c 
	ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_revenue DESC

-- The 3 custoners with the fewest orders placed
SELECT TOP 3
	c.customer_key,
	c.first_name,
	c.last_name,
	COUNT(DISTINCT f.order_number) AS total_order_placed
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c 
	ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_order_placed ASC