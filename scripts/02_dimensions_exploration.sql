/*
===============================================================================
Eksplorasi Dimensi
===============================================================================
Tujuan:
    - Untuk menjelajahi struktur tabel dimensi.
	
Fungsi SQL yang Digunakan:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Explore All countries our customers come from
SELECT DISTINCT country
FROM gold.dim_customers

-- Explroe All cotegories "the major divisions"
SELECT DISTINCT category, subcategory, product_name
FROM gold.dim_products
ORDER BY category, subcategory, product_name

