-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 22, 2025 at 12:34 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_perpuss`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `DaftarSeluruhBuku` ()   BEGIN
    SELECT b.id_buku, b.judul_buku, b.penulis, b.kategori, b.stok, 
           IFNULL(COUNT(p.id_peminjaman), 0) AS total_dipinjam
    FROM buku b
    LEFT JOIN peminjaman p ON b.id_buku = p.id_buku
    GROUP BY b.id_buku, b.judul_buku, b.penulis, b.kategori, b.stok;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteBuku` (IN `Id_BukuBaru` INT)   BEGIN 
DELETE FROM buku WHERE id_buku = Id_BukuBaru; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeletePeminjaman` (IN `p_id_peminjaman` INT)   BEGIN
    DELETE FROM peminjaman WHERE id_peminjaman = p_id_peminjaman;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteSiswa` (IN `p_id_siswa` INT)   BEGIN
    DELETE FROM siswa WHERE id_siswa = p_id_siswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllBuku` ()   BEGIN
    SELECT * FROM buku;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllPeminjaman` ()   BEGIN
    SELECT * FROM peminjaman;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllSiswa` ()   BEGIN
    SELECT * FROM siswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertBuku` ()   BEGIN 
INSERT INTO buku (judul_buku, penulis, kategori, stok) VALUES 
('Sistem Operasi', 'Dian Kurniawan', 'Teknologi', 6), 
('Jaringan Komputer', 'Ahmad Fauzi', 'Teknologi', 5), 
('Cerita Rakyat Nusantara', 'Lestari Dewi', 'Sastra', 9), 
('Bahasa Inggris untuk Pemula', 'Jane Doe', 'Bahasa', 10), 
('Biologi Dasar', 'Budi Rahman', 'Sains', 7), 
('Kimia Organik', 'Siti Aminah', 'Sains', 5), 
('Teknik Elektro', 'Ridwan Hakim', 'Teknik', 6), 
('Fisika Modern', 'Albert Einstein', 'Sains', 4), 
('Manajemen Waktu', 'Steven Covey', 'Pengembangan', 8), 
('Strategi Belajar Efektif', 'Tony Buzan', 'Pendidikan', 6); 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `INSERTpeminjaman` ()   BEGIN
    INSERT INTO peminjaman (id_siswa, id_buku, tanggal_pinjam, tanggal_kembali, status) VALUES
    (11, 2, '2025-02-01', '2025-02-08', 'Dipinjam'),
    (2, 5, '2025-01-28', '2025-02-04', 'Dikembalikan'),
    (3, 8, '2025-02-02', '2025-02-09', 'Dipinjam'),
    (4, 10, '2025-01-30', '2025-02-06', 'Dikembalikan'),
    (5, 3, '2025-01-25', '2025-02-01', 'Dikembalikan'),
    (15, 7, '2025-02-01', '2025-02-08', 'Dipinjam'),
    (7, 1, '2025-01-29', '2025-02-05', 'Dikembalikan'),
    (8, 9, '2025-02-03', '2025-02-10', 'Dipinjam'),
    (13, 4, '2025-01-27', '2025-02-03', 'Dikembalikan'),
    (10, 11, '2025-02-01', '2025-02-08', 'Dipinjam');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `INSERTsiswa` ()   BEGIN
    INSERT INTO siswa (nama_siswa, kelas) VALUES
    ('Farhan Maulana', 'XII-TKJ'),
    ('Gita Permata', 'X-RPL'),
    ('Hadi Sucipto', 'X-TKJ'),
    ('Intan Permadi', 'XI-RPL'),
    ('Joko Santoso', 'XI-TKJ'),
    ('Kartika Sari', 'XII-RPL'),
    ('Lintang Putri', 'XII-TKJ'),
    ('Muhammad Rizky', 'X-RPL'),
    ('Novi Andriana', 'X-TKJ'),
    ('Olivia Hernanda', 'XI-RPL');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `KembalikanBuku` (IN `p_id_peminjaman` INT)   BEGIN
    -- Update status peminjaman menjadi 'Dikembalikan' dengan tanggal kembali = CURRENT_DATE
    UPDATE peminjaman 
    SET status = 'Dikembalikan',
        tanggal_kembali = CURRENT_DATE
    WHERE id_peminjaman = p_id_peminjaman;
    
    -- Tambah stok buku kembali
    UPDATE buku 
    SET stok = stok + 1
    WHERE id_buku = (SELECT id_buku FROM peminjaman WHERE id_peminjaman = p_id_peminjaman);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_daftar_siswa_peminjam` ()   BEGIN
    SELECT DISTINCT s.id_siswa, s.nama, s.kelas
    FROM siswa s
    JOIN peminjaman p ON s.id_siswa = p.id_siswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_kembalikan_buku` (IN `p_id_peminjaman` INT)   BEGIN
    -- Perbarui status peminjaman dan isi tanggal kembali dengan CURRENT_DATE
    UPDATE peminjaman
    SET tanggal_kembali = CURRENT_DATE, status = 'Dikembalikan'
    WHERE id_peminjaman = p_id_peminjaman;

    -- Tambahkan stok buku kembali setelah dikembalikan
    UPDATE buku
    SET stok = stok + 1
    WHERE id_buku = (SELECT id_buku FROM peminjaman WHERE id_peminjaman = p_id_peminjaman);
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_semua_buku` ()   BEGIN
    SELECT b.id_buku, b.judul_buku, b.penulis, b.kategori, b.stok,
           IFNULL(COUNT(p.id_peminjaman), 0) AS jumlah_dipinjam
    FROM buku b
    LEFT JOIN peminjaman p ON b.id_buku = p.id_buku
    GROUP BY b.id_buku, b.judul_buku, b.penulis, b.kategori, b.stok;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_semua_siswa` ()   BEGIN
    SELECT s.id_siswa, s.nama, s.kelas,
           IFNULL(COUNT(p.id_peminjaman), 0) AS jumlah_peminjaman
    FROM siswa s
    LEFT JOIN peminjaman p ON s.id_siswa = p.id_siswa
    GROUP BY s.id_siswa, s.nama, s.kelas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateBuku` (IN `Id_BukuBaru` INT, IN `JudulBukuBaru` VARCHAR(50), IN `PenulisBaru` VARCHAR(20), IN `KategoriBaru` VARCHAR(20), IN `StokBaru` INT)   BEGIN 
UPDATE buku 
SET judul_buku = JudulBukuBaru, 
penulis = PenulisBaru, 
kategori = KategoriBaru, 
stok = StokBaru 
WHERE id_buku = Id_BukuBaru; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdatePeminjaman` (IN `p_id_peminjaman` INT, IN `p_id_siswa` INT, IN `p_id_buku` INT, IN `p_tanggal_pinjam` DATE, IN `p_tanggal_kembali` DATE, IN `p_status` VARCHAR(15))   BEGIN
    UPDATE peminjaman 
    SET id_siswa = p_id_siswa, 
        id_buku = p_id_buku, 
        tanggal_pinjam = p_tanggal_pinjam,
        tanggal_kembali = p_tanggal_kembali, 
        status = p_status 
    WHERE id_peminjaman = p_id_peminjaman;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateSiswa` (IN `p_id_siswa` INT, IN `p_nama_siswa` VARCHAR(100), IN `p_kelas` VARCHAR(20))   BEGIN
    UPDATE siswa 
    SET nama_siswa = p_nama_siswa, 
        kelas = p_kelas
    WHERE id_siswa = p_id_siswa;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `buku`
--

CREATE TABLE `buku` (
  `id_buku` int(11) NOT NULL,
  `judul_buku` varchar(255) NOT NULL,
  `penulis` varchar(100) NOT NULL,
  `kategori` varchar(50) NOT NULL,
  `stok` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `buku`
--

INSERT INTO `buku` (`id_buku`, `judul_buku`, `penulis`, `kategori`, `stok`) VALUES
(1, 'Algoritma dan Pemrograman', 'Andi Wijaya', 'Teknologi', 5),
(2, 'Dasar-dasar Database', 'Budi Santoso', 'Teknologi', 9),
(3, 'Matematika Diskrit', 'Rina Sari', 'Matematika', 4),
(4, 'Sejarah Dunia', 'John Smith', 'Sejarah', 3),
(5, 'Pemrograman Web dengan PHP', 'Eko Prasetyo', 'Teknologi', 8);

-- --------------------------------------------------------

--
-- Table structure for table `peminjaman`
--

CREATE TABLE `peminjaman` (
  `id_peminjaman` int(11) NOT NULL,
  `id_siswa` int(11) DEFAULT NULL,
  `id_buku` int(11) DEFAULT NULL,
  `tanggal_pinjam` date DEFAULT NULL,
  `tanggal_kembali` date DEFAULT NULL,
  `status` enum('Dipinjam','Dikembalikan') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `peminjaman`
--

INSERT INTO `peminjaman` (`id_peminjaman`, `id_siswa`, `id_buku`, `tanggal_pinjam`, `tanggal_kembali`, `status`) VALUES
(1, 11, 2, '2025-02-01', '2025-02-20', 'Dikembalikan'),
(2, 2, 5, '2025-01-28', '2025-02-04', 'Dikembalikan'),
(3, 3, 8, '2025-02-02', '2025-02-09', 'Dipinjam'),
(4, 4, 10, '2025-01-30', '2025-02-06', 'Dikembalikan'),
(5, 5, 3, '2025-01-25', '2025-02-01', 'Dikembalikan');

--
-- Triggers `peminjaman`
--
DELIMITER $$
CREATE TRIGGER `KurangiStokBuku` AFTER INSERT ON `peminjaman` FOR EACH ROW BEGIN
    UPDATE buku
    SET stok = stok - 1
    WHERE id_buku = NEW.id_buku;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `TambahStokBuku` AFTER UPDATE ON `peminjaman` FOR EACH ROW BEGIN
    IF NEW.status = 'Dikembalikan' AND OLD.status != 'Dikembalikan' THEN
        UPDATE buku
        SET stok = stok + 1
        WHERE id_buku = NEW.id_buku;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `siswa`
--

CREATE TABLE `siswa` (
  `id_siswa` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `kelas` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `siswa`
--

INSERT INTO `siswa` (`id_siswa`, `nama`, `kelas`) VALUES
(1, 'Andi Saputra', 'X-RPL'),
(2, 'Budi Wijaya', 'X-TKJ'),
(3, 'Citra Lestari', 'XI-RPL'),
(4, 'Dewi Kurniawan', 'XI-TKJ'),
(5, 'Eko Prasetyo', 'XII-RPL');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`id_buku`);

--
-- Indexes for table `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD PRIMARY KEY (`id_peminjaman`);

--
-- Indexes for table `siswa`
--
ALTER TABLE `siswa`
  ADD PRIMARY KEY (`id_siswa`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `buku`
--
ALTER TABLE `buku`
  MODIFY `id_buku` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `siswa`
--
ALTER TABLE `siswa`
  MODIFY `id_siswa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
