SET search_path TO classicmodels, public;

--1
SELECT customernumber, SUM(amount) as "Total akumulasi",
	COUNT(checknumber) as "Frekuensi transaksi", 
	MAX(amount) as "Nilai setoran tunai terbesar"
FROM payments
GROUP BY customernumber
HAVING COUNT(DISTINCT amount) > 4 AND ROUND(AVG(amount), 3) > 20000;

--2 
SELECT customernumber, SUM(amount) as "Total setoran"
FROM payments
GROUP BY customernumber
HAVING SUM(amount) > 80000
ORDER BY "Total setoran" DESC;

--3 
SELECT * FROM products;
SELECT productline as "Kategori barang",
	COUNT(productline) as "Jumlah produk", 
	ROUND(AVG(msrp), 2) as "Rata rata harga jual ritel",
	STRING_AGG(DISTINCT productname, ', ' ORDER BY productname) AS "Daftar produk"
FROM products
GROUP BY productline
HAVING COUNT(productcode) > 10;

--4
SELECT reportsto
FROM employees
WHERE reportsto IS NOT NULL
EXCEPT
SELECT employeenumber
FROM employees
WHERE jobtitle LIKE '%VP%' OR jobtitle LIKE '%President%';

--5
SELECT productcode AS "Kode produk",
    SUM(quantityordered) AS "Total unit terjual",
    ROUND(AVG(priceeach), 2) AS "Rata rata harga rill"
FROM orderdetails
WHERE priceeach > 100
GROUP BY productcode
HAVING SUM(quantityordered) > 50
ORDER BY "Total unit terjual" DESC;

--6
SELECT productcode as "Kode produk",
	 SUM(quantityordered) as "Total keseluruhan unit",
	 SUM(quantityordered * priceeach) as "Pendapatan kotor",
	 ROUND(AVG(priceeach), 2) AS "Rata rata harga rill",
	 (MAX(priceeach) - MIN(priceeach)) as "Rentang volatilitas"
FROM orderdetails
WHERE quantityordered > 20
GROUP BY productcode
HAVING SUM(quantityordered * priceeach) > 50000
ORDER BY "Pendapatan kotor" DESC;

--7
SELECT customernumber 
FROM customers 
WHERE creditlimit > 80000
INTERSECT
SELECT customernumber 
FROM orders 
WHERE status IN ('Cancelled', 'On Hold')
EXCEPT
SELECT customernumber 
FROM payments 
GROUP BY customernumber 
HAVING SUM(amount) > 100000;

--soal tambahan
--1
SELECT ordernumber as "nomor pesanan", count(ordernumber) as "jumlah jenis produk", 
	SUM(quantityordered * priceeach) as "total nilai pesanan"
FROM orderdetails
WHERE quantityordered > 30
GROUP BY ordernumber
HAVING SUM(quantityordered * priceeach) > 15000
ORDER BY "total nilai pesanan" DESC;

--2
SELECT customernumber 
FROM customers
WHERE creditlimit > 70000
INTERSECT 
SELECT customernumber
FROM orders
WHERE status IN ('Cancelled', 'Disputed')
EXCEPT
SELECT customernumber 
FROM payments 
GROUP BY customernumber 
HAVING SUM(amount) > 150000;