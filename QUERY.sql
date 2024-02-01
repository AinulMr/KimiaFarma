select * from penjualan;
select * from produk;
select * from customer;
select * from penjualan_ds;
select * from produk_ds;
select * from customer_ds;
select * from penjualan_update_ds;
select * from penjualan_update_fix_ds;


#UPDATE DATA PENYESUAI HARGA YANG RANCU DAN KEMASAN
SELECT
    J.id_distributor,	
    J.id_cabang,	
    J.id_invoice,	
    J.tanggal,	
    J.id_customer,	
    J.id_barang,	
    J.jumlah_barang,	
    J.mata_uang,	
    J.brand_id,	
    J.lini,
    Ps.harga,
    Ps.kemasan
FROM
    penjualan J
INNER JOIN	
    produk_ds Ps ON J.id_barang = Ps.kode_barang;

# export csv sbg penjualan_update_ds

SELECT
	id_distributor,	
    id_cabang,	
    id_invoice,	
    tanggal,	
    id_customer,	
    id_barang,	
    jumlah_barang,	
    mata_uang,	
    brand_id,	
    lini,
    harga,
    kemasan,
    SUM(harga*jumlah_barang) as total_penjualan
FROM
	penjualan_update_ds
GROUP BY
	id_distributor,	
    id_cabang,	
    id_invoice,	
    tanggal,	
    id_customer,	
    id_barang,	
    jumlah_barang,	
    mata_uang,	
    brand_id,	
    lini,
    harga,
    kemasan;
# export csv sbg penjualan_update_fix_ds


#penjualan berdasarkan bulan
UPDATE penjualan_update_ds
SET tanggal = STR_TO_DATE(tanggal, '%d/%m/%Y');

SELECT
    DATE_FORMAT(tanggal, '%M') AS bulan,
    SUM(jumlah_barang) AS total_unit_terjual,
    SUM(total_penjualan) AS total_penjualan
FROM
    penjualan_update_fix_ds
GROUP BY
    DATE_FORMAT(tanggal, '%M');


#Jumlah Barang terjual berdasarkan barang
SELECT
    J.id_barang,
    P.nama_barang,
    SUM(J.jumlah_barang) AS total_barang
FROM
    penjualan_update_fix_ds J
INNER JOIN
    produk P ON J.id_barang = P.kode_barang
GROUP BY
    J.id_barang, P.nama_barang;

#Rata rata penjualan masing-masing lini
SELECT
	lini,
    AVG(total_penjualan) AS rata_rata_penjualan
FROM
	penjualan_update_fix_ds
GROUP BY
	lini;
    
#Penjualan berdasarkan wilayah
SELECT
    C.cabang_sales,
    SUM(total_penjualan) as total_penjualan,
	AVG(total_penjualan) as rata_rata_penjualan
FROM
	penjualan_update_fix_ds J
INNER JOIN
	customer C on J.id_customer = C.id_customer
GROUP BY
    C.cabang_sales;

#Apotek vs Klinik
SELECT
    C.group,
    SUM(J.jumlah_barang) as total_jumlah_barang,
    AVG(J.jumlah_barang * J.harga) as rata_rata_penjualan
FROM
	penjualan_update_ds J
INNER JOIN
	customer C on J.id_customer = C.id_customer
GROUP BY
	C.group;
    
#total penjualan per barang
SELECT
    J.id_barang,
    P.nama_barang,
    SUM(J.total_penjualan) as total_penjualan,
    SUM(J.jumlah_barang) as Total_unit
FROM
	penjualan_update_fix_ds J
INNER JOIN
	produk P ON J.id_barang = P.kode_barang
GROUP BY
	P.nama_barang,
    J.id_barang;

SELECT
    id_invoice,
    J.id_barang,
    P.nama_barang,
    J.harga,
    J.jumlah_barang,
    SUM(J.total_penjualan) as total_penjualan
FROM
	penjualan_update_fix_ds J
INNER JOIN
	produk P ON J.id_barang = P.kode_barang
GROUP BY
	id_invoice,
	P.nama_barang,
    J.harga,
    J.jumlah_barang,
    J.id_barang;





