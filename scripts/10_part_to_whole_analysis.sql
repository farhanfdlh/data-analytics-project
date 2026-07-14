/*
===============================================================================
Analisis Part-to-Whole (Bagian terhadap Keseluruhan)
===============================================================================
Tujuan:
    - Untuk membandingkan performa atau metrik antar dimensi atau periode waktu.
    - Untuk mengevaluasi perbedaan antar kategori.
    - Berguna untuk pengujian A/B atau perbandingan regional.
Fungsi SQL yang Digunakan:
    - SUM(), AVG(): Mengagregasi nilai untuk perbandingan.
    - Window Functions: SUM() OVER() untuk perhitungan total.
===============================================================================
*/

-- Which categories contribute the most to overall sales?
WITH category_sales AS (
	SELECT 
		p.category, 
		SUM(f.sales_amount) AS total_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
	GROUP BY p.category
)
SELECT 
	category, 
	total_sales,
	SUM(total_sales) OVER () AS overall_sales,
	CAST(
		total_sales * 100.0
		/ SUM(total_sales) OVER ()
	AS DECIMAL(5,2)
	) AS percentage_of_total -- can use concat to add percentage (%)
FROM category_sales
ORDER BY total_sales DESC;