-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 01, 2025 at 05:27 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rumah_sepatu_kulit`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `HitungTotalPembayaran` (IN `no_pesanan_param` VARCHAR(10))   BEGIN
    SELECT 
        SUM(jumlah_bayar) AS total_terbayar
    FROM 
        transaksi
    WHERE 
        no_pesanan = no_pesanan_param AND status = 'Lunas';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TampilkanDetailPesanan` (IN `kode_pesanan_param` VARCHAR(10))   BEGIN
    SELECT dp.id_detail,
           dp.no_pesanan,
           dp.kode_model_sepatu,
           dp.warna,
           dp.ukuran,
           dp.quantity,
           pr.harga,
           (dp.quantity * pr.harga) AS sub_total
    FROM detail_pesanan dp
    JOIN produk pr ON dp.kode_model_sepatu = pr.kode_model_sepatu
    WHERE dp.no_pesanan = kode_pesanan_param;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TampilkanPesananDenganTotal` (IN `kode_pesanan_param` VARCHAR(10))   BEGIN
    SELECT p.no_pesanan,
           p.id_pelanggan,
           pel.nama_pelanggan,
           p.tanggal_pesanan,
           p.status_produksi,
           p.status_pengiriman,
           (SELECT SUM(dp.quantity * pr.harga)
            FROM detail_pesanan dp
            JOIN produk pr ON dp.kode_model_sepatu = pr.kode_model_sepatu
            WHERE dp.no_pesanan = kode_pesanan_param) AS total_harga
    FROM pesanan p
    JOIN pelanggan pel ON p.id_pelanggan = pel.id_pelanggan
    WHERE p.no_pesanan = kode_pesanan_param;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `detail_pesanan`
--

CREATE TABLE `detail_pesanan` (
  `id_detail` int(11) NOT NULL,
  `no_pesanan` varchar(10) DEFAULT NULL,
  `kode_model_sepatu` int(11) DEFAULT NULL,
  `warna` varchar(50) DEFAULT NULL,
  `ukuran` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detail_pesanan`
--

INSERT INTO `detail_pesanan` (`id_detail`, `no_pesanan`, `kode_model_sepatu`, `warna`, `ukuran`, `quantity`) VALUES
(1, '056', 600, 'Cream-Hitam', 37, 3),
(2, '056', 600, 'Cream-Hitam', 38, 5),
(3, '056', 600, 'Cream-Hitam', 39, 4),
(4, '056', 600, 'Cream-Hitam', 40, 4),
(5, '056', 600, 'Navy-Putih', 38, 3),
(6, '056', 600, 'Navy-Putih', 39, 1),
(7, '056', 600, 'Navy-Putih', 40, 1),
(8, '056', 600, 'Hitam-Gold', 36, 2),
(9, '056', 600, 'Hitam-Gold', 38, 2),
(10, '056', 600, 'Hitam-Gold', 39, 1),
(11, '056', 600, 'Putih-Silver', 37, 1),
(12, '056', 600, 'Putih-Silver', 38, 2),
(13, '056', 600, 'Putih-Silver', 39, 2),
(14, '056', 600, 'Putih-Silver', 40, 1),
(15, '056', 600, 'Putih-Gold', 36, 1),
(16, '056', 600, 'Putih-Gold', 37, 2),
(17, '056', 600, 'Putih-Gold', 38, 3),
(18, '056', 600, 'Putih-Gold', 39, 3),
(19, '056', 600, 'Putih-Gold', 40, 3),
(20, '056', 600, 'Cream-Navy', 37, 2),
(21, '056', 600, 'Cream-Navy', 38, 3),
(22, '056', 600, 'Cream-Navy', 39, 3),
(23, '056', 600, 'Cream-Navy', 40, 3),
(24, '056', 600, 'Cream-Hijau', 37, 2),
(25, '056', 600, 'Cream-Hijau', 38, 3),
(26, '056', 600, 'Cream-Hijau', 39, 2),
(27, '056', 600, 'Cream-Hijau', 40, 1);

-- --------------------------------------------------------

--
-- Table structure for table `kasir`
--

CREATE TABLE `kasir` (
  `id_kasir` int(11) NOT NULL,
  `nama_kasir` varchar(100) NOT NULL,
  `no_hp_kasir` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kasir`
--

INSERT INTO `kasir` (`id_kasir`, `nama_kasir`, `no_hp_kasir`) VALUES
(1, 'Siti', '081234567891');

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `id_pelanggan` varchar(10) NOT NULL,
  `nama_pelanggan` varchar(100) DEFAULT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `alamat` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pelanggan`
--

INSERT INTO `pelanggan` (`id_pelanggan`, `nama_pelanggan`, `no_hp`, `alamat`) VALUES
('C023', 'Arjuna', '085238243623', 'Cibunut, Kec. Karangpawitan-Garut');

-- --------------------------------------------------------

--
-- Table structure for table `pesanan`
--

CREATE TABLE `pesanan` (
  `no_pesanan` varchar(10) NOT NULL,
  `id_pelanggan` varchar(10) DEFAULT NULL,
  `id_kasir` int(11) DEFAULT NULL,
  `status_produksi` varchar(50) DEFAULT NULL,
  `tanggal_pesanan` date DEFAULT NULL,
  `status_pengiriman` enum('Dikemas','Dikirim','Diterima') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pesanan`
--

INSERT INTO `pesanan` (`no_pesanan`, `id_pelanggan`, `id_kasir`, `status_produksi`, `tanggal_pesanan`, `status_pengiriman`) VALUES
('056', 'C023', 1, 'Selesai', '2025-01-31', 'Dikirim');

-- --------------------------------------------------------

--
-- Table structure for table `produk`
--

CREATE TABLE `produk` (
  `kode_model_sepatu` int(11) NOT NULL,
  `model_sepatu` varchar(100) DEFAULT NULL,
  `harga` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `produk`
--

INSERT INTO `produk` (`kode_model_sepatu`, `model_sepatu`, `harga`) VALUES
(600, 'Onit', 150000);

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `id_transaksi` int(11) NOT NULL,
  `no_pesanan` varchar(10) NOT NULL,
  `tanggal_transaksi` timestamp NOT NULL DEFAULT current_timestamp(),
  `metode_pembayaran` varchar(50) DEFAULT NULL,
  `jumlah_bayar` decimal(12,2) NOT NULL,
  `status` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaksi`
--

INSERT INTO `transaksi` (`id_transaksi`, `no_pesanan`, `tanggal_transaksi`, `metode_pembayaran`, `jumlah_bayar`, `status`) VALUES
(3, '056', '2025-01-30 17:00:00', 'Tunai', 9450000.00, 'Lunas');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  ADD PRIMARY KEY (`id_detail`),
  ADD KEY `no_pesanan` (`no_pesanan`),
  ADD KEY `kode_model_sepatu` (`kode_model_sepatu`);

--
-- Indexes for table `kasir`
--
ALTER TABLE `kasir`
  ADD PRIMARY KEY (`id_kasir`);

--
-- Indexes for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`id_pelanggan`);

--
-- Indexes for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD PRIMARY KEY (`no_pesanan`),
  ADD KEY `id_pelanggan` (`id_pelanggan`),
  ADD KEY `id_kasir` (`id_kasir`);

--
-- Indexes for table `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`kode_model_sepatu`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `no_pesanan` (`no_pesanan`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  MODIFY `id_detail` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `kasir`
--
ALTER TABLE `kasir`
  MODIFY `id_kasir` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id_transaksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  ADD CONSTRAINT `detail_pesanan_ibfk_1` FOREIGN KEY (`no_pesanan`) REFERENCES `pesanan` (`no_pesanan`),
  ADD CONSTRAINT `detail_pesanan_ibfk_2` FOREIGN KEY (`kode_model_sepatu`) REFERENCES `produk` (`kode_model_sepatu`);

--
-- Constraints for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD CONSTRAINT `pesanan_ibfk_1` FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id_pelanggan`),
  ADD CONSTRAINT `pesanan_ibfk_2` FOREIGN KEY (`id_kasir`) REFERENCES `kasir` (`id_kasir`);

--
-- Constraints for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_1` FOREIGN KEY (`no_pesanan`) REFERENCES `pesanan` (`no_pesanan`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
