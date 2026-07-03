-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jul 03, 2026 at 02:03 PM
-- Server version: 8.0.30
-- PHP Version: 8.2.30

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
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `solution` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `danger_level` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `life_cycle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `spread_rate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `main_characteristics` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `maintenance_advice` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
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
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `guides`
--

CREATE TABLE `guides` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `views` int NOT NULL DEFAULT '0',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `guides`
--

INSERT INTO `guides` (`id`, `title`, `content`, `views`, `image`, `created_at`, `updated_at`) VALUES
(1, 'Cara Mengatasi Hama Wereng Secara Alami', 'Gunakan daun sirsak dan tembakau untuk mencegah wereng...', 2431, 'https://via.placeholder.com/60', '2026-05-25 03:09:27', '2026-05-25 03:09:27'),
(2, 'Pemupukan Padi yang Benar di Musim Hujan', 'Pada musim hujan, pemupukan harus dikurangi kadar nitrogennya...', 1890, 'https://via.placeholder.com/60', '2026-05-25 03:09:27', '2026-05-25 03:09:27'),
(3, 'Dummy Farming Guide Title Edited', 'This is a dummy guide content created for verifying farming guide features.', 0, NULL, '2026-06-15 08:06:06', '2026-06-15 08:07:06'),
(4, 'Automation Guide Edited', 'Verification guide content', 0, NULL, '2026-06-15 08:19:43', '2026-06-15 08:21:46');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
(16, '2026_05_28_064239_add_details_to_diseases_table', 8),
(17, '2026_06_06_161009_add_notification_settings_to_users_table', 9),
(18, '2026_06_06_164437_create_notifications_table', 10),
(19, '2026_07_02_173612_create_otps_table', 11);

-- --------------------------------------------------------

--
-- Table structure for table `news`
--

CREATE TABLE `news` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notifiable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notifiable_id` bigint UNSIGNED NOT NULL,
  `data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `type`, `notifiable_type`, `notifiable_id`, `data`, `read_at`, `created_at`, `updated_at`) VALUES
('029b5464-eab9-4634-98c0-60d3e97bcb0f', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 7, '{\"title\":\"Berita Pertanian\",\"message\":\"Petani di Karawang Gunakan Drone Basmi Hama Wereng, Kini Butuh Mesin Tanam Modern\",\"type\":\"news\"}', NULL, '2026-06-07 19:50:38', '2026-06-07 19:50:38'),
('02c23672-76fd-4b5b-bbb5-9281728ab995', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 7, '{\"title\":\"Berita Pertanian\",\"message\":\"Petani di Karawang Gunakan Drone Basmi Hama Wereng, Kini Butuh Mesin Tanam Modern\",\"type\":\"news\"}', NULL, '2026-06-07 19:37:13', '2026-06-07 19:37:13'),
('035d6fc6-fbd5-4730-8e9c-771492017b9b', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 1, '{\"title\":\"Berita Pertanian\",\"message\":\"Bidik Swasembada Pangan, Luas Lahan Padi Perhatian Kementan\",\"type\":\"news\"}', NULL, '2026-06-06 07:45:45', '2026-06-06 09:45:45'),
('03bc3923-e1f9-4bdc-98a0-499b099a57a0', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 7, '{\"title\":\"Berita Pertanian\",\"message\":\"Petani di Karawang Gunakan Drone Basmi Hama Wereng, Kini Butuh Mesin Tanam Modern\",\"type\":\"news\"}', NULL, '2026-06-07 19:38:17', '2026-06-07 19:38:17'),
('088439cb-37cc-448d-afbd-c495c007730e', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 8, '{\"title\":\"Prakiraan Cuaca Hari Ini\",\"message\":\"Cuaca di Karawang hari ini diperkirakan Sedikit Berawan dengan suhu 35\\u00b0C.\",\"type\":\"weather\"}', NULL, '2026-06-13 23:27:59', '2026-06-13 23:27:59'),
('0c3c2a9d-70cd-49e6-a1d1-83f4b2d32460', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 7, '{\"title\":\"Prakiraan Cuaca Hari Ini\",\"message\":\"Cuaca di Karawang hari ini diperkirakan Awan Pecah dengan suhu 33\\u00b0C.\",\"type\":\"weather\"}', NULL, '2026-06-07 19:38:17', '2026-06-07 19:38:17'),
('1512fc0e-1cfc-4801-8af3-d6316cb286b3', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 6, '{\"title\":\"Berita Pertanian\",\"message\":\"Antisipasi Kemarau 2026: Pemkab Karawang Mitigasi Lahan Pertanian Rawan Kekeringan\",\"type\":\"news\"}', NULL, '2026-06-09 08:28:40', '2026-06-09 08:28:40'),
('159bf2a0-4652-4f8c-b199-d8a54b7a7c5d', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 6, '{\"title\":\"Prakiraan Cuaca Hari Ini\",\"message\":\"Cuaca di Karawang hari ini diperkirakan Sedikit Berawan dengan suhu 31\\u00b0C.\",\"type\":\"weather\"}', NULL, '2026-06-08 04:46:54', '2026-06-08 04:46:54'),
('1774b24f-4b94-4ec5-ad32-82ec140f1df3', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 7, '{\"title\":\"Berita Pertanian\",\"message\":\"Petani di Karawang Gunakan Drone Basmi Hama Wereng, Kini Butuh Mesin Tanam Modern\",\"type\":\"news\"}', NULL, '2026-06-07 19:30:09', '2026-06-07 19:30:09'),
('1e16b05e-9299-4722-a863-b21f334bf568', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 1, '{\"title\":\"Peringatan Cuaca\",\"message\":\"Hujan lebat diprediksi terjadi di wilayah Karawang besok siang.\",\"type\":\"weather\"}', '2026-06-06 09:45:45', '2026-06-05 09:45:45', '2026-06-06 09:45:45'),
('22022fb1-8265-4864-9200-5902ec3f861f', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 6, '{\"title\":\"Prakiraan Cuaca Hari Ini\",\"message\":\"Cuaca di Karawang hari ini diperkirakan Awan Pecah dengan suhu 33\\u00b0C.\",\"type\":\"weather\"}', NULL, '2026-06-07 19:38:17', '2026-06-07 19:38:17'),
('2c6c3bae-ec90-4b38-a678-5fba234ca10d', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 7, '{\"title\":\"Prakiraan Cuaca Hari Ini\",\"message\":\"Cuaca di Karawang hari ini diperkirakan Awan Pecah dengan suhu 31\\u00b0C.\",\"type\":\"weather\"}', NULL, '2026-06-09 08:28:40', '2026-06-09 08:28:40'),
('2e1cc8f3-2fdb-4321-bb25-826c5cb62806', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 6, '{\"title\":\"Berita Pertanian\",\"message\":\"Dukung Asta Cita, Polres Karawang dan Petani Panen 28 Ton Jagung\",\"type\":\"news\"}', NULL, '2026-06-13 23:27:59', '2026-06-13 23:27:59'),
('3abb7ef6-960a-4b5c-9a01-c0c3618923f9', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 6, '{\"title\":\"Peringatan Cuaca\",\"message\":\"Hujan lebat diprediksi terjadi di wilayah Karawang besok siang.\",\"type\":\"weather\"}', NULL, '2026-06-06 09:43:45', '2026-06-06 09:45:45'),
('3f2cd3e5-95a1-4254-8617-80e770a034be', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 6, '{\"title\":\"Prakiraan Cuaca Hari Ini\",\"message\":\"Cuaca di Karawang hari ini diperkirakan Awan Pecah dengan suhu 31\\u00b0C.\",\"type\":\"weather\"}', NULL, '2026-06-09 08:28:40', '2026-06-09 08:28:40'),
('402409a1-5862-4cee-8563-bad15e4a3e12', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 8, '{\"title\":\"Berita Pertanian\",\"message\":\"Dukung Asta Cita, Polres Karawang dan Petani Panen 28 Ton Jagung\",\"type\":\"news\"}', NULL, '2026-06-13 23:27:59', '2026-06-13 23:27:59'),
('4317a263-811d-4216-80d9-ca1c372eaaa7', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 7, '{\"title\":\"Promo Toko\",\"message\":\"Diskon 10% untuk pembelian Pupuk Urea 50kg hari ini!\",\"type\":\"shop\"}', NULL, '2026-06-06 09:43:45', '2026-06-06 09:45:45'),
('4e556849-3fd6-4303-8209-f6818c31f9d7', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 6, '{\"title\":\"Berita Pertanian\",\"message\":\"Petani di Karawang Gunakan Drone Basmi Hama Wereng, Kini Butuh Mesin Tanam Modern\",\"type\":\"news\"}', NULL, '2026-06-07 19:30:09', '2026-06-07 19:30:09'),
('4f2886e2-1ff9-4f8f-b93e-663858b98c0a', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 6, '{\"title\":\"Berita Pertanian\",\"message\":\"Petani di Karawang Gunakan Drone Basmi Hama Wereng, Kini Butuh Mesin Tanam Modern\",\"type\":\"news\"}', NULL, '2026-06-08 04:46:54', '2026-06-08 04:46:54'),
('5084beb7-05ea-48f3-b91b-0da0f8eace9c', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 8, '{\"title\":\"Sistem\",\"message\":\"Data profil Anda berhasil diperbarui.\",\"type\":\"system\"}', NULL, '2026-06-13 23:36:56', '2026-06-13 23:36:56'),
('52146534-2964-41c0-97a0-2077b4684b19', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 1, '{\"title\":\"Prakiraan Cuaca Hari Ini\",\"message\":\"Cuaca di Karawang hari ini diperkirakan Awan Tersebar dengan suhu 33\\u00b0C.\",\"type\":\"weather\"}', NULL, '2026-06-07 19:30:09', '2026-06-07 19:30:09'),
('72d7e8f5-a0c9-4f2b-8992-83e2e023062b', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 7, '{\"title\":\"Berita Pertanian\",\"message\":\"Petani di Karawang Gunakan Drone Basmi Hama Wereng, Kini Butuh Mesin Tanam Modern\",\"type\":\"news\"}', NULL, '2026-06-08 04:46:54', '2026-06-08 04:46:54'),
('79a211e2-fe2b-460d-943b-68bbe5217000', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 6, '{\"title\":\"Prakiraan Cuaca Hari Ini\",\"message\":\"Cuaca di Karawang hari ini diperkirakan Awan Tersebar dengan suhu 33\\u00b0C.\",\"type\":\"weather\"}', NULL, '2026-06-07 19:30:09', '2026-06-07 19:30:09'),
('83605be8-d7c5-4dc2-9f54-2ebfabb2516d', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 6, '{\"title\":\"Berita Pertanian\",\"message\":\"Petani di Karawang Gunakan Drone Basmi Hama Wereng, Kini Butuh Mesin Tanam Modern\",\"type\":\"news\"}', NULL, '2026-06-07 19:38:17', '2026-06-07 19:38:17'),
('83e1d262-7bdb-4bd9-a025-b45a72b78f58', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 6, '{\"title\":\"Berita Pertanian\",\"message\":\"Petani di Karawang Gunakan Drone Basmi Hama Wereng, Kini Butuh Mesin Tanam Modern\",\"type\":\"news\"}', NULL, '2026-06-07 19:37:13', '2026-06-07 19:37:13'),
('8457790b-dc14-4852-97c6-2a1dac858b25', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 7, '{\"title\":\"Prakiraan Cuaca Hari Ini\",\"message\":\"Cuaca di Karawang hari ini diperkirakan Sedikit Berawan dengan suhu 31\\u00b0C.\",\"type\":\"weather\"}', NULL, '2026-06-08 04:46:54', '2026-06-08 04:46:54'),
('84a27edf-fe9f-4400-bcb7-523eefcf2e62', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 6, '{\"title\":\"Berita Pertanian\",\"message\":\"Bidik Swasembada Pangan, Luas Lahan Padi Perhatian Kementan\",\"type\":\"news\"}', NULL, '2026-06-06 07:45:45', '2026-06-06 09:45:45'),
('858671c8-3e97-46a1-8a02-688ecd0cfc77', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 6, '{\"title\":\"Prakiraan Cuaca Hari Ini\",\"message\":\"Cuaca di Karawang hari ini diperkirakan Sedikit Berawan dengan suhu 35\\u00b0C.\",\"type\":\"weather\"}', NULL, '2026-06-13 23:27:59', '2026-06-13 23:27:59'),
('8cde5d6f-14fe-449f-b64d-57fa92ae07d2', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 6, '{\"title\":\"Promo Toko\",\"message\":\"Diskon 10% untuk pembelian Pupuk Urea 50kg hari ini!\",\"type\":\"shop\"}', '2026-06-06 09:45:45', '2026-06-05 09:45:45', '2026-06-06 09:45:45'),
('8db1fb2f-91f4-4602-8ef1-4b98059c0cd6', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 7, '{\"title\":\"Peringatan Cuaca\",\"message\":\"Hujan lebat diprediksi terjadi di wilayah Karawang besok siang.\",\"type\":\"weather\"}', NULL, '2026-06-06 07:45:45', '2026-06-06 09:45:45'),
('9c83ff85-daf0-4769-a85e-bcaa9eeafeeb', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 6, '{\"title\":\"Berita Pertanian\",\"message\":\"Petani di Karawang Gunakan Drone Basmi Hama Wereng, Kini Butuh Mesin Tanam Modern\",\"type\":\"news\"}', NULL, '2026-06-07 19:50:38', '2026-06-07 19:50:38'),
('bb3982aa-527a-4bf9-a9d5-ae489299813f', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 7, '{\"title\":\"Prakiraan Cuaca Hari Ini\",\"message\":\"Cuaca di Karawang hari ini diperkirakan Awan Tersebar dengan suhu 33\\u00b0C.\",\"type\":\"weather\"}', NULL, '2026-06-07 19:30:09', '2026-06-07 19:30:09'),
('bf4b8580-4fdd-4dc9-8e79-53d838f40dbe', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 8, '{\"title\":\"Sistem\",\"message\":\"Data profil Anda berhasil diperbarui.\",\"type\":\"system\"}', NULL, '2026-06-15 07:11:09', '2026-06-15 07:11:09'),
('c5b68b07-0811-46bd-91cd-9a7d2e149b4a', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 7, '{\"title\":\"Berita Pertanian\",\"message\":\"Bidik Swasembada Pangan, Luas Lahan Padi Perhatian Kementan\",\"type\":\"news\"}', '2026-06-06 09:45:45', '2026-06-05 09:45:45', '2026-06-06 09:45:45'),
('dbe96434-0baa-4ca6-b8d7-2df0bc12500b', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 7, '{\"title\":\"Prakiraan Cuaca Hari Ini\",\"message\":\"Cuaca di Karawang hari ini diperkirakan Awan Pecah dengan suhu 33\\u00b0C.\",\"type\":\"weather\"}', NULL, '2026-06-07 19:50:38', '2026-06-07 19:50:38'),
('e2653377-0e7e-4f19-a1a1-5b77e28a0e75', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 7, '{\"title\":\"Berita Pertanian\",\"message\":\"Antisipasi Kemarau 2026: Pemkab Karawang Mitigasi Lahan Pertanian Rawan Kekeringan\",\"type\":\"news\"}', NULL, '2026-06-09 08:28:40', '2026-06-09 08:28:40'),
('e5e40c7b-b62f-4ed7-8cde-85c0fb2d6b2d', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 6, '{\"title\":\"Prakiraan Cuaca Hari Ini\",\"message\":\"Cuaca di Karawang hari ini diperkirakan Awan Pecah dengan suhu 33\\u00b0C.\",\"type\":\"weather\"}', NULL, '2026-06-07 19:50:38', '2026-06-07 19:50:38'),
('e93bbc01-510f-4c55-a537-6d6043dbbc22', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 7, '{\"title\":\"Prakiraan Cuaca Hari Ini\",\"message\":\"Cuaca di Karawang hari ini diperkirakan Sedikit Berawan dengan suhu 35\\u00b0C.\",\"type\":\"weather\"}', NULL, '2026-06-13 23:27:59', '2026-06-13 23:27:59'),
('e9f0b3ad-a407-4a84-9290-7a8ba6417e60', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 1, '{\"title\":\"Promo Toko\",\"message\":\"Diskon 10% untuk pembelian Pupuk Urea 50kg hari ini!\",\"type\":\"shop\"}', NULL, '2026-06-06 09:43:45', '2026-06-06 09:45:45'),
('ec4deb32-b228-4a3f-bec2-214780e5ae2d', 'App\\Notifications\\GeneralNotification', 'App\\Models\\User', 7, '{\"title\":\"Berita Pertanian\",\"message\":\"Dukung Asta Cita, Polres Karawang dan Petani Panen 28 Ton Jagung\",\"type\":\"news\"}', NULL, '2026-06-13 23:27:59', '2026-06-13 23:27:59');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint UNSIGNED NOT NULL,
  `order_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `total_amount` decimal(12,2) NOT NULL,
  `status` enum('pending','processing','shipped','completed','cancelled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `order_number`, `user_id`, `total_amount`, `status`, `created_at`, `updated_at`) VALUES
(1, 'ORD-090', 7, '50000.00', 'completed', '2026-06-13 23:27:27', '2026-06-15 08:30:07'),
(2, 'ORD-091', 8, '65000.00', 'completed', '2026-06-12 23:27:27', '2026-06-15 08:30:55'),
(3, 'ORD-092', 6, '80000.00', 'shipped', '2026-06-11 23:27:27', '2026-06-13 23:27:27');

-- --------------------------------------------------------

--
-- Table structure for table `otps`
--

CREATE TABLE `otps` (
  `id` bigint UNSIGNED NOT NULL,
  `identifier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expires_at` timestamp NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `otps`
--

INSERT INTO `otps` (`id`, `identifier`, `token`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'aldimuhamadriskiriski9954@gmail.com', '402576', '2026-07-02 10:53:37', '2026-07-02 10:40:37', '2026-07-02 10:43:37');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `password_reset_tokens`
--

INSERT INTO `password_reset_tokens` (`email`, `token`, `created_at`) VALUES
('aldimuhamadriskiriski9954@gmail.com', '$2y$12$40vkDKZeOB3LEArfWVwnme54oLQJfjToTddWmyfIFKhKeMZJdV.aC', '2026-06-09 08:49:11'),
('raihanyasykur9.1@gmail.com', '$2y$12$IEoO051tqWCPUag1juQ8SelZQk4GXbvU4eW5cCKpziE6ILKjRzgZW', '2026-06-09 08:52:44');

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
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
(3, 'App\\Models\\User', 6, 'mobile-app', 'a9031d8842686d454652deb34c353bfb8fd1f5d60b5b16f4a87e494946801cdb', '[\"*\"]', '2026-05-28 01:20:35', NULL, '2026-05-28 00:36:36', '2026-05-28 01:20:35'),
(4, 'App\\Models\\User', 7, 'mobile-app', 'd7ae96235b067b1ff3cea050ab9672eae5169fb2c6f5d8d1f4b9714473905824', '[\"*\"]', '2026-05-29 03:19:27', NULL, '2026-05-29 03:02:50', '2026-05-29 03:19:27'),
(5, 'App\\Models\\User', 8, 'mobile-app', '67d12cd311730a4b6533558dc3859a743535b5e0b1e812e8f8239fba594ec661', '[\"*\"]', '2026-06-02 07:11:46', NULL, '2026-06-02 07:11:33', '2026-06-02 07:11:46'),
(6, 'App\\Models\\User', 8, 'mobile-app', '188643abe027b99499bace285871ce6c1123794912aeae31ac01ac5e6565871b', '[\"*\"]', '2026-06-03 20:31:42', NULL, '2026-06-03 20:31:32', '2026-06-03 20:31:42'),
(7, 'App\\Models\\User', 8, 'mobile-app', '1ea6b02cf28d241f5d566a0f3ca67baa3a1213771b8f7b4743e0e50a0a88c5bd', '[\"*\"]', '2026-06-03 20:50:13', NULL, '2026-06-03 20:50:07', '2026-06-03 20:50:13'),
(8, 'App\\Models\\User', 8, 'mobile-app', 'e87034afe8ec6fe7fb9b9bf530aa4963d1d58d274c65afacda6a6dc1ccf9e138', '[\"*\"]', NULL, NULL, '2026-06-03 20:59:19', '2026-06-03 20:59:19'),
(9, 'App\\Models\\User', 8, 'mobile-app', '0b794a23bbd54d80c975337165b7c92d206ac8e3690beeec464a9ee214d45e7e', '[\"*\"]', '2026-06-03 21:01:05', NULL, '2026-06-03 20:59:20', '2026-06-03 21:01:05'),
(10, 'App\\Models\\User', 8, 'mobile-app', 'b8cbb82adac1c9907b7c7a32f4d3e8440efa258c0f9bc532569c0baed9480b82', '[\"*\"]', '2026-06-04 08:54:13', NULL, '2026-06-04 08:15:27', '2026-06-04 08:54:13'),
(11, 'App\\Models\\User', 8, 'mobile-app', '9c59ef3553bab5befae6115a5e905a21b937431309792a5d80b69c0bef344aa0', '[\"*\"]', NULL, NULL, '2026-06-06 09:07:01', '2026-06-06 09:07:01'),
(12, 'App\\Models\\User', 8, 'mobile-app', '224f5693b8c5410c0ed729567627de2d82094dc7e2a4a506aba4d320f8192242', '[\"*\"]', '2026-06-09 08:38:11', NULL, '2026-06-06 09:07:02', '2026-06-09 08:38:11'),
(13, 'App\\Models\\User', 8, 'mobile-app', '5240fd0f4eac78e1b4c9c1459112401edb3bd2c319a2f2df053a32a58ddb5024', '[\"*\"]', '2026-06-06 09:54:49', NULL, '2026-06-06 09:41:53', '2026-06-06 09:54:49'),
(14, 'App\\Models\\User', 8, 'mobile-app', '28141f0331130d212a89cd4e49bc9f447111e9fe02517f9e986784760d1c339f', '[\"*\"]', '2026-06-06 09:55:48', NULL, '2026-06-06 09:55:26', '2026-06-06 09:55:48'),
(15, 'App\\Models\\User', 8, 'mobile-app', '8544bfbd1a6c8bc8aaace5ee76dbe9cadfcd6e9b1e81edce3911730c41e250a8', '[\"*\"]', '2026-06-06 09:59:23', NULL, '2026-06-06 09:59:11', '2026-06-06 09:59:23'),
(16, 'App\\Models\\User', 8, 'mobile-app', '3439200f1d582bb3604d8745138f68fa83efc815b9da7f0e4749f96fdec5484a', '[\"*\"]', '2026-06-06 10:10:22', NULL, '2026-06-06 10:02:34', '2026-06-06 10:10:22'),
(17, 'App\\Models\\User', 8, 'mobile-app', 'a0ff89d1221747c05e01a39c63f2f51114e69162c5d5ec20f348f84c6852d3f0', '[\"*\"]', '2026-06-07 19:52:09', NULL, '2026-06-07 19:21:48', '2026-06-07 19:52:09'),
(18, 'App\\Models\\User', 8, 'mobile-app', 'a72da77d33935a6249125e9415c570817cefa3bde9721415eeebc6ba761bf75d', '[\"*\"]', NULL, NULL, '2026-06-09 08:14:14', '2026-06-09 08:14:14'),
(19, 'App\\Models\\User', 8, 'mobile-app', '55d2e181fe6b52adecdaf13b8c588ab6c99f630bb6afe345ed7c8e8213126411', '[\"*\"]', '2026-06-09 08:26:08', NULL, '2026-06-09 08:14:16', '2026-06-09 08:26:08'),
(20, 'App\\Models\\User', 8, 'mobile-app', '03f714e0ba93211f7ed89b9e950447936838211fa3a298fe05d72e557263d50c', '[\"*\"]', '2026-06-09 08:45:55', NULL, '2026-06-09 08:39:50', '2026-06-09 08:45:55'),
(21, 'App\\Models\\User', 8, 'mobile-app', '047f743d89f6ffe815a36ac4c15355987cd8d715ecdc35e75b607ac46d40bfb0', '[\"*\"]', '2026-07-02 10:31:27', NULL, '2026-06-13 06:53:27', '2026-07-02 10:31:27'),
(22, 'App\\Models\\User', 8, 'mobile-app', '5e2873edf0250635ca012411862ba71b717b7b39f9b547e098567a53a9e8af38', '[\"*\"]', '2026-06-15 07:11:06', NULL, '2026-06-13 23:36:40', '2026-06-15 07:11:06');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `price` decimal(10,2) NOT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `description`, `price`, `stock`, `image`, `created_at`, `updated_at`) VALUES
(1, 'Pupuk Urea 50kg', 'Pupuk Urea berkualitas tinggi untuk tanaman padi, mempercepat pertumbuhan dan menghijaukan daun.', '120000.00', 50, 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400&q=80', '2026-05-25 03:09:27', '2026-06-13 23:34:57'),
(2, 'Benih Padi Ciherang 5kg', 'Benih padi varietas Ciherang yang tahan wereng dan hasil panen melimpah.', '85000.00', 100, 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=400&q=80', '2026-05-25 03:09:27', '2026-06-13 23:34:57'),
(3, 'Pestisida Pembasmi Wereng 500ml', 'Ampuh membasmi hama wereng coklat dan hijau dalam 24 jam.', '45000.00', 30, 'https://images.unsplash.com/photo-1595974482597-4b8da8879bc5?w=400&q=80', '2026-05-25 03:09:27', '2026-06-13 23:34:57'),
(4, 'Automation Seed<script>window.confirm = () => true;</script>', 'Verification seed', '60000.00', 48, NULL, '2026-06-15 08:11:31', '2026-06-15 08:17:02');

-- --------------------------------------------------------

--
-- Table structure for table `rice_varieties`
--

CREATE TABLE `rice_varieties` (
  `id` bigint UNSIGNED NOT NULL,
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `group` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ecosystem` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `yield_potential` decimal(4,1) NOT NULL,
  `plant_age` int NOT NULL,
  `texture` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `pest_resistance` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `region_recommendation` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `notification_settings` json DEFAULT NULL,
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bio` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `profile_picture` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `longitude` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `status`, `notification_settings`, `remember_token`, `created_at`, `updated_at`, `phone`, `location`, `bio`, `profile_picture`, `latitude`, `longitude`) VALUES
(1, 'Admin Padiku', 'admin@padiku.com', NULL, '$2y$12$HGviuefVeSFbSVaWqYd.tOV7.WNPl272FnVQpD1olhPn7TB/eMKZ2', 'approved', '{\"news\": false, \"shop\": false, \"system\": true, \"weather\": true, \"pause_all\": true}', 'vhj5glyhgXdBaiOe4qCHug7kg3ZU1EI4XtuustgiVWVpWNMJ3cwKjgbpjKVt', '2026-05-25 03:09:27', '2026-06-06 09:24:56', NULL, NULL, NULL, NULL, NULL, NULL),
(6, 'Raihan yasykur', 'raihanyasykur9.1@gmail.com', NULL, '$2y$12$/dGCcbyngvIdJC1GZBVRF.EJYYb1C6OwuAdVjMu0oS6LhHgFxGRDy', 'approved', NULL, NULL, '2026-05-25 04:26:30', '2026-05-28 01:20:35', '0851-5720-4233', 'P7J6+7WR, Kedungwaringin, Kecamatan Kedungwaringin, Bekasi, Jawa Barat', 'Info mesin bubut', '1779954689_6.jpg', '-6.2692087', '107.2622587'),
(7, 'Aldi', 'aldi@gmail.com', NULL, '$2y$12$ReljvFaSscIjl/WMXPwgKuhF/R/TLbGHatgu6Kasex0KgAOsJf8Uq', 'approved', NULL, NULL, '2026-05-29 03:01:51', '2026-05-29 03:02:34', '0848909533', NULL, NULL, NULL, NULL, NULL),
(8, 'Budrin', 'aldimuhamadriskiriski9954@gmail.com', NULL, '$2y$12$bvnmOH/ySxv2oflJdfZjVuqgzXPMqBb58gfOFak6px5FNrrDcYa8C', 'approved', '{\"news\": true, \"shop\": true, \"system\": true, \"weather\": true, \"pause_all\": false}', NULL, '2026-06-01 23:14:22', '2026-06-15 07:11:06', '083817513461', 'P79V+2P9, Tanjungpura, Kecamatan Karawang Barat, Karawang, Jawa Barat', NULL, '1780919240_8.jpg', '-6.2824412', '107.2943089');

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
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_notifiable_type_notifiable_id_index` (`notifiable_type`,`notifiable_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `orders_order_number_unique` (`order_number`),
  ADD KEY `orders_user_id_foreign` (`user_id`);

--
-- Indexes for table `otps`
--
ALTER TABLE `otps`
  ADD PRIMARY KEY (`id`);

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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

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
-- AUTO_INCREMENT for table `otps`
--
ALTER TABLE `otps`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `rice_varieties`
--
ALTER TABLE `rice_varieties`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

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
