SET search_path TO "classicmodels";

-- 1
SELECT c.contactfirstname, c.customername,
	of.city, CONCAT(e.firstname, ' ', e.lastname) AS sales_rep_name
FROM customers AS c
JOIN employees AS e
	ON e.employeenumber = c.salesrepemployeenumber
JOIN offices AS of
	ON of.officecode = e.officecode
WHERE c.contactfirstname ILIKE 'A%' AND of.city != 'NYC'
ORDER BY c.customername ASC;

-- 2
SELECT c.customername, SUM(p.amount) AS total_payment,
	MAX(p.amount) AS max_single_payment
FROM customers AS c
JOIN payments AS p
	ON c.customernumber = p.customernumber
GROUP BY c.customername
HAVING SUM(p.amount) > 50000
ORDER BY SUM(p.amount) DESC;

-- 3
SELECT c.customername, COUNT(DISTINCT o.ordernumber) AS total_order,
	ROUND(AVG(od.quantityordered), 2) AS avg_quantity_per_order
FROM customers AS c
JOIN orders AS o
	ON c.customernumber = o.customernumber
JOIN orderdetails AS od
	ON o.ordernumber = od.ordernumber
GROUP BY c.customername
HAVING COUNT(DISTINCT o.ordernumber) > 3 AND ROUND(AVG(od.quantityordered), 2) > 35
ORDER BY total_order DESC, avg_quantity_per_order DESC;

-- 4
SELECT pr.productline, SUM(od.quantityordered) AS total_terjual,
    ROUND(AVG(od.priceeach), 2) AS rata_rata_harga,
    ROUND(AVG((pr.MSRP - od.priceeach)/pr.MSRP * 100), 2) AS avg_discount_percentage
FROM products AS pr
JOIN orderdetails AS od
    ON pr.productcode = od.productcode
GROUP BY pr.productline
HAVING SUM(od.quantityordered) > 3000 AND AVG(od.priceeach) > 80
ORDER BY total_terjual DESC;
-- potongan harga: diskon, rumus diskon: ((harga awal - harga akhir) / harga awal)* 100

-- 5
SELECT c.customername, SUM(od.quantityordered * od.priceeach) AS total_transaksi,
    COUNT(DISTINCT (o.status = 'Shipped', o.ordernumber)) AS total_shipped_orders,
    ROUND(SUM(od.quantityordered * od.priceeach) / COUNT(DISTINCT o.ordernumber), 2) AS avg_transaction_per_order
FROM customers AS c
JOIN orders AS o
    ON c.customernumber = o.customernumber
JOIN orderdetails AS od
    ON o.ordernumber = od.ordernumber
GROUP BY c.customername
HAVING COUNT(DISTINCT EXTRACT(YEAR FROM o.orderdate)) > 1
ORDER BY total_transaksi DESC
LIMIT 5;

-- 6
SELECT c.customername, c.city AS customer_city, of.city AS office_city,
    SUM(od.quantityordered) AS total_unit_terjual,
    ROUND(SUM(od.quantityordered * od.priceeach) / COUNT(DISTINCT o.ordernumber), 2) AS avg_nilai_per_order
FROM customers AS c
JOIN employees AS e
    ON c.salesrepemployeenumber = e.employeenumber
JOIN offices AS of
    ON e.officecode = of.officecode
JOIN orders AS o
    ON c.customernumber = o.customernumber
JOIN orderdetails AS od
    ON o.ordernumber = od.ordernumber
WHERE of.territory = 'EMEA'
GROUP BY c.customername, c.city, of.city
HAVING COUNT(DISTINCT EXTRACT(YEAR FROM o.orderdate)) > 2
    AND SUM(od.quantityordered) > 1000
    AND SUM(od.quantityordered * od.priceeach) / COUNT(DISTINCT o.ordernumber) > 10000
ORDER BY avg_nilai_per_order DESC;

-- study case
--1
SELECT c.customername as nama_perusahaan, c.country as negara_asal,
	CONCAT(e.firstname, ' ', e.lastname) AS nama_lengkap_karyawan,
	COUNT(p.amount) as frekuensi_pembayaran, SUM(p.amount) as total_pembayaran
FROM customers as c
JOIN employees as e
	ON c.salesrepemployeenumber = e.employeenumber
JOIN payments p
	ON c.customernumber = p.customernumber
WHERE c.contactfirstname ILIKE '%A%' AND c.country != 'USA' 
GROUP BY c.customername, c.country, nama_lengkap_karyawan
HAVING COUNT(p.amount) >=  2 AND SUM(p.amount) > 50000
ORDER BY total_pembayaran DESC;

-- 2
SELECT pd.productline as lini_produk, COUNT(DISTINCT o.ordernumber) as jumlah_nota_unik,
	SUM(od.quantityordered) as total_unit_terjual, ROUND(AVG(od.priceeach), 2) as rata_rata_harga, 
	SUM(od.quantityordered * od.priceeach) as total_omzet
FROM products as pd
JOIN orderdetails as od
	ON pd.productcode = od.productcode
JOIN orders as o
	ON od.ordernumber = o.ordernumber
JOIN payments as py
	ON o.customernumber = py.customernumber
WHERE pd.buyprice > 30 AND o.status = 'Shipped'
GROUP BY pd.productline
HAVING SUM(od.quantityordered) > 2000 AND ROUND(AVG(od.priceeach), 2) > 85
ORDER BY total_omzet DESC
LIMIT 3;




