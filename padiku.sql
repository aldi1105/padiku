-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: May 28, 2026 at 08:26 AM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `padiku`
--

-- --------------------------------------------------------

--
-- Table structure for table `diseases`
--

CREATE TABLE `diseases` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `solution` text COLLATE utf8mb4_unicode_ci,
  `danger_level` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `life_cycle` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `spread_rate` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `main_characteristics` text COLLATE utf8mb4_unicode_ci,
  `maintenance_advice` text COLLATE utf8mb4_unicode_ci,
  `scan_count` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `diseases`
--

INSERT INTO `diseases` (`id`, `name`, `image`, `description`, `solution`, `danger_level`, `life_cycle`, `spread_rate`, `main_characteristics`, `maintenance_advice`, `scan_count`, `created_at`, `updated_at`) VALUES
(1, 'Penyakit Tungro', 'diseases/vmJQyCQEeHSgGO2tfZQ2sH0KkvHF8QXO52ab6iQi.jpg', 'Disebabkan oleh virus yang dibawa wereng hijau, daun menguning.', 'Gunakan varietas tahan virus, semprot wereng hijau.', 'Tinggi', 'Virus ditularkan wereng hijau', 'Sangat Cepat (Vektor Serangga)', 'Tanaman kerdil, daun berwarna kuning oranye mulai dari pucuk ke bawah.', 'Kendalikan vektor (wereng hijau), tanam serempak, cabut dan musnahkan tanaman yang terinfeksi.', 1250, '2026-05-25 03:09:27', '2026-05-27 23:49:40'),
(3, 'Wereng Coklat', 'diseases/onb2IZ7RjGiIwcXPuU2xK6qrZbTuMbJHBS9vUEh8.jpg', 'Hama wereng coklat menyerap cairan pada batang padi. Gejala serangan berupa daun menguning dan mengering (hopperburn).', 'Gunakan varietas tahan wereng, atur jarak tanam, dan aplikasikan insektisida berbahan aktif buprofezin jika diperlukan.', 'Tinggi', '21-30 hari', 'Sangat Cepat (Angin & Migrasi)', 'Serangga kecil berwarna coklat, menghisap cairan batang padi, menyebabkan hopperburn.', 'Gunakan varietas tahan, atur jarak tanam, hindari penggunaan pestisida berspektrum luas secara berlebihan.', 0, '2026-05-25 20:23:12', '2026-05-27 23:49:40'),
(4, 'Ulat Grayak', 'diseases/sPdYoJvqndE7KpNJtGUIsIggkg1eQ1HYU9UxuaED.jpg', 'Ulat grayak memakan daun padi dari pinggir hingga hanya menyisakan tulang daun.', 'Bersihkan gulma, genangi lahan, dan gunakan insektisida biologis (Beauveria bassiana).', NULL, NULL, NULL, NULL, NULL, 0, '2026-05-25 20:23:12', '2026-05-27 23:22:12'),
(5, 'Walang Sangit (Leptocorisa oratorius)', 'diseases/m2dHsVYvZo4LYMQT4VQoshxSmnxr6kEqNylZRQXd.jpg', 'Hama tanaman padi berbentuk kepik ramping yang sangat aktif pada pagi dan sore hari. Hama ini merusak tanaman dengan cara menusuk dan menghisap cairan pada bulir padi yang sedang berada dalam fase masak susu (berisi cairan putih seperti susu), sehingga menyebabkan bulir padi menjadi hampa, berbercak cokelat, atau berkualitas buruk.', 'Pengendalian walang sangit dilakukan secara terpadu melalui kombinasi kultur teknis (tanam padi serempak dan pembersihan gulma lahan), pemanfaatan agen biologi (pemasangan umpan bangkai binatang seperti ketam/keong untuk memancing hama lalu memusnahkannya atau penyemprotan jamur Beauveria bassiana), serta aplikasi insektisida kimia berbahan aktif seperti fipronil atau metomil secara selektif pada pagi sekali atau sore hari ketika hama sedang aktif di permukaan tanaman.', 'Tinggi', '35 hingga 50 hari', 'Cepat', '• Mengeluarkan bau menyengat yang sangat busuk khas \"walang sangit\" saat merasa terancam atau disentuh.\r\n\r\n• Memiliki tubuh yang ramping, memanjang (sekitar 15–30 mm), berwarna cokelat zaitun atau hijau kecokelatan dengan kaki dan antena yang panjang.\r\n\r\n• Menyerang berkelompok di area bulir padi pada pagi hari yang sejuk dan menjelang senja.', 'Lakukan pengamatan secara berkala (monitoring) sejak tanaman padi mulai memasuki fase keluar malai (berbunga). Jika ditemukan populasi walang sangit rata-rata lebih dari 6 ekor per meter persegi, segera lakukan tindakan pengendalian (pemasangan umpan atau penyemprotan). Hindari pemupukan Nitrogen (Urea) yang berlebihan karena dapat membuat tanaman terlalu sukulen (lunak) dan disukai oleh hama ini.', 0, '2026-05-25 20:23:12', '2026-05-28 00:34:45'),
(6, 'Penggerek Batang', 'diseases/XS4tFBEoflOj4YXNJPbRexdI28TVIFHje9AQzgKe.jpg', 'Larva menggerek batang padi, menyebabkan pucuk layu (sundep) atau malai hampa putih (beluk).', 'Cabut dan musnahkan tanaman terserang, pasang perangkap lampu untuk ngengat, gunakan insektisida butiran di tanah.', 'Tinggi', '30-45 hari', 'Cepat (Melalui Ngengat)', 'Ulat yang menggerek ke dalam batang padi, menyebabkan sundep (fase vegetatif) dan beluk (fase generatif).', 'Pengumpulan kelompok telur, pemanfaatan musuh alami, penyemprotan insektisida sistemik jika ambang batas terlampaui.', 0, '2026-05-25 20:23:12', '2026-05-27 23:49:40');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `guides`
--

CREATE TABLE `guides` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `views` int NOT NULL DEFAULT '0',
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `guides`
--

INSERT INTO `guides` (`id`, `title`, `content`, `views`, `image`, `created_at`, `updated_at`) VALUES
(1, 'Cara Mengatasi Hama Wereng Secara Alami', 'Gunakan daun sirsak dan tembakau untuk mencegah wereng...', 2431, 'https://via.placeholder.com/60', '2026-05-25 03:09:27', '2026-05-25 03:09:27'),
(2, 'Pemupukan Padi yang Benar di Musim Hujan', 'Pada musim hujan, pemupukan harus dikurangi kadar nitrogennya...', 1890, 'https://via.placeholder.com/60', '2026-05-25 03:09:27', '2026-05-25 03:09:27');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_reset_tokens_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(5, '2026_05_25_095939_create_products_table', 1),
(6, '2026_05_25_095940_create_guides_table', 1),
(7, '2026_05_25_095940_create_orders_table', 1),
(8, '2026_05_25_095941_create_diseases_table', 1),
(9, '2026_05_25_095941_create_news_table', 1),
(10, '2026_05_25_105758_add_status_to_users_table', 2),
(11, '2026_05_25_171741_add_profile_fields_to_users_table', 3),
(12, '2026_05_26_015259_add_lat_long_to_users_table', 4),
(13, '2026_05_26_031432_add_image_to_diseases_table', 5),
(14, '2026_05_26_061353_create_rice_varieties_table', 6),
(15, '2026_05_26_063834_add_image_to_rice_varieties_table', 7),
(16, '2026_05_28_064239_add_details_to_diseases_table', 8);

-- --------------------------------------------------------

--
-- Table structure for table `news`
--

CREATE TABLE `news` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint UNSIGNED NOT NULL,
  `order_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `total_amount` decimal(12,2) NOT NULL,
  `status` enum('pending','processing','shipped','completed','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 6, 'mobile-app', 'd5d4ecf5e66f24050d1576ccd3437e84e34dccfe0dd3f3648740eb9999cf60c5', '[\"*\"]', '2026-05-25 10:16:42', NULL, '2026-05-25 04:28:09', '2026-05-25 10:16:42'),
(2, 'App\\Models\\User', 6, 'mobile-app', 'e8ee5b320e0ba209516d995d5717bc4f9e75d77762b73ec9d5e278df98e1172f', '[\"*\"]', '2026-05-28 00:31:48', NULL, '2026-05-25 10:18:26', '2026-05-28 00:31:48'),
(3, 'App\\Models\\User', 6, 'mobile-app', 'a9031d8842686d454652deb34c353bfb8fd1f5d60b5b16f4a87e494946801cdb', '[\"*\"]', '2026-05-28 01:20:35', NULL, '2026-05-28 00:36:36', '2026-05-28 01:20:35');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `price` decimal(10,2) NOT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `description`, `price`, `stock`, `image`, `created_at`, `updated_at`) VALUES
(1, 'Pupuk Urea 50kg', 'Pupuk Urea berkualitas tinggi untuk tanaman padi, mempercepat pertumbuhan dan menghijaukan daun.', '120000.00', 50, 'https://via.placeholder.com/150', '2026-05-25 03:09:27', '2026-05-25 03:09:27'),
(2, 'Benih Padi Ciherang 5kg', 'Benih padi varietas Ciherang yang tahan wereng dan hasil panen melimpah.', '85000.00', 100, 'https://via.placeholder.com/150', '2026-05-25 03:09:27', '2026-05-25 03:09:27'),
(3, 'Pestisida Pembasmi Wereng 500ml', 'Ampuh membasmi hama wereng coklat dan hijau dalam 24 jam.', '45000.00', 30, 'https://via.placeholder.com/150', '2026-05-25 03:09:27', '2026-05-25 03:09:27');

-- --------------------------------------------------------

--
-- Table structure for table `rice_varieties`
--

CREATE TABLE `rice_varieties` (
  `id` bigint UNSIGNED NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `group` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ecosystem` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `yield_potential` decimal(4,1) NOT NULL,
  `plant_age` int NOT NULL,
  `texture` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pest_resistance` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `region_recommendation` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `rice_varieties`
--

INSERT INTO `rice_varieties` (`id`, `code`, `name`, `image`, `group`, `ecosystem`, `yield_potential`, `plant_age`, `texture`, `pest_resistance`, `region_recommendation`, `created_at`, `updated_at`) VALUES
(1, 'V001', 'Inpari 32', 'varieties/inpari32.jpg', 'Inbrida', 'Sawah Irigasi', '10.5', 120, 'Pulen', 'Tahan Wereng', 'Dataran Rendah', '2026-05-25 23:15:11', '2026-05-25 23:39:33'),
(2, 'V002', 'Inpari 42', 'varieties/inpari42.jpg', 'Inbrida', 'Sawah Irigasi', '10.6', 112, 'Pulen', 'Tahan Blas', 'Dataran Rendah', '2026-05-25 23:15:11', '2026-05-25 23:42:25'),
(3, 'V003', 'Ciherang', 'varieties/ciherang.jpg', 'Inbrida', 'Sawah Irigasi', '8.5', 116, 'Pulen', 'Rentan Wereng', 'Dataran Rendah', '2026-05-25 23:15:11', '2026-05-25 23:43:46'),
(4, 'V004', 'IR 64', 'varieties/ir_64.jpg', 'Inbrida', 'Sawah Irigasi', '6.0', 115, 'Pulen', 'Rentan', 'Dataran Rendah', '2026-05-25 23:15:11', '2026-05-25 23:47:44'),
(5, 'V005', 'MAPAN P-05', 'varieties/mapan_p05.jpg', 'Hibrida', 'Sawah Irigasi', '12.0', 115, 'Sangat Pulen', 'Tahan Wereng', 'Dataran Rendah-Medium', '2026-05-25 23:15:11', '2026-05-25 23:46:36'),
(6, 'V006', 'Intani 602', 'varieties/intani_602.jpg', 'Hibrida', 'Sawah Irigasi', '11.5', 110, 'Pulen', 'Tahan HDB', 'Dataran Rendah', '2026-05-25 23:15:11', '2026-05-25 23:46:36'),
(7, 'V007', 'Pandan Wangi', 'varieties/pandan_wangi.jpg', 'Lokal', 'Sawah Irigasi', '6.5', 155, 'Sangat Pulen', 'Rentan', 'Dataran Tinggi', '2026-05-25 23:15:11', '2026-05-25 23:49:18'),
(8, 'V008', 'Rojolele', 'varieties/rojolele.jpg', 'Lokal', 'Sawah Irigasi', '7.0', 145, 'Sangat Pulen', 'Rentan', 'Dataran Rendah', '2026-05-25 23:15:11', '2026-05-25 23:50:57'),
(9, 'V009', 'Anak Daro', 'varieties/anak_daro.jpg', 'Lokal', 'Sawah Irigasi', '7.5', 140, 'Pera', 'Tahan Wereng', 'Dataran Tinggi', '2026-05-25 23:15:11', '2026-05-25 23:51:28'),
(10, 'V010', 'Inpago 8', 'varieties/inpago_8.jpg', 'Gogo', 'Lahan Kering', '6.8', 119, 'Pulen', 'Tahan Blas', 'Lahan Kering / Tadah Hujan', '2026-05-25 23:15:11', '2026-05-25 23:51:57'),
(11, 'V011', 'Inpago 12', 'varieties/inpago_12.jpg', 'Gogo', 'Lahan Kering', '8.4', 111, 'Pera', 'Tahan Kekeringan', 'Lahan Kering / Tadah Hujan', '2026-05-25 23:15:11', '2026-05-25 23:52:29'),
(12, 'V012', 'Inpara 3', 'varieties/inpara_3.jpg', 'Rawa', 'Lahan Lebak', '5.6', 125, 'Pera', 'Tahan Alami', 'Rawa / Lahan Pasang Surut', '2026-05-25 23:15:11', '2026-05-25 23:53:40'),
(13, 'V013', 'Inpara 7', 'varieties/inpara_7.jpg', 'Rawa', 'Lahan Pasang Surut', '6.4', 115, 'Pulen', 'Tahan Rendaman', 'Rawa / Lahan Pasang Surut', '2026-05-25 23:15:11', '2026-05-25 23:54:33'),
(14, 'V014', 'Inpari 24', 'varieties/inpari_24.jpg', 'Khusus (Merah)', 'Sawah Irigasi', '7.3', 115, 'Pulen', 'Sedang', 'Dataran Rendah', '2026-05-25 23:15:11', '2026-05-25 23:55:20'),
(15, 'V015', 'Cempo Ireng', 'varieties/cempo_ireng.jpg', 'Khusus (Hitam)', 'Sawah Irigasi', '5.0', 150, 'Ketan', 'Tahan Alami', 'Dataran Rendah', '2026-05-25 23:15:11', '2026-05-25 23:56:41');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bio` text COLLATE utf8mb4_unicode_ci,
  `profile_picture` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `longitude` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `status`, `remember_token`, `created_at`, `updated_at`, `phone`, `location`, `bio`, `profile_picture`, `latitude`, `longitude`) VALUES
(1, 'Admin Padiku', 'admin@padiku.com', NULL, '$2y$12$HGviuefVeSFbSVaWqYd.tOV7.WNPl272FnVQpD1olhPn7TB/eMKZ2', 'approved', 'vhj5glyhgXdBaiOe4qCHug7kg3ZU1EI4XtuustgiVWVpWNMJ3cwKjgbpjKVt', '2026-05-25 03:09:27', '2026-05-25 03:58:24', NULL, NULL, NULL, NULL, NULL, NULL),
(6, 'Raihan yasykur', 'raihanyasykur9.1@gmail.com', NULL, '$2y$12$/dGCcbyngvIdJC1GZBVRF.EJYYb1C6OwuAdVjMu0oS6LhHgFxGRDy', 'approved', NULL, '2026-05-25 04:26:30', '2026-05-28 01:20:35', '0851-5720-4233', 'P7J6+7WR, Kedungwaringin, Kecamatan Kedungwaringin, Bekasi, Jawa Barat', 'Info mesin bubut', '1779954689_6.jpg', '-6.2692087', '107.2622587');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `diseases`
--
ALTER TABLE `diseases`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `guides`
--
ALTER TABLE `guides`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `orders_order_number_unique` (`order_number`),
  ADD KEY `orders_user_id_foreign` (`user_id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `rice_varieties`
--
ALTER TABLE `rice_varieties`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `rice_varieties_code_unique` (`code`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `diseases`
--
ALTER TABLE `diseases`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `guides`
--
ALTER TABLE `guides`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `news`
--
ALTER TABLE `news`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `rice_varieties`
--
ALTER TABLE `rice_varieties`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
