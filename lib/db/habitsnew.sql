-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 25, 2025 at 06:33 PM
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
-- Database: `habits`
--

-- --------------------------------------------------------

--
-- Stand-in structure for view `daily_habit_percentage`
-- (See below for the actual view)
--
CREATE TABLE `daily_habit_percentage` (
`user_id` int(11)
,`date` date
,`percentage` decimal(28,2)
);

-- --------------------------------------------------------

--
-- Table structure for table `habits`
--

CREATE TABLE `habits` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `completed` tinyint(1) DEFAULT 0,
  `date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `habits`
--

INSERT INTO `habits` (`id`, `user_id`, `name`, `completed`, `date`) VALUES
(624, 21, 'Read', 0, '2025-06-24'),
(625, 21, 'Run', 1, '2025-06-24'),
(626, 21, 'Ngaji', 1, '2025-06-24'),
(627, 21, 'Mukbang', 1, '2025-06-24'),
(686, 34, 'Read', 0, '2025-06-25'),
(687, 34, 'Run', 0, '2025-06-25'),
(688, 21, 'Read', 1, '2025-06-25'),
(689, 21, 'Run', 0, '2025-06-25'),
(690, 21, 'Ngaji', 1, '2025-06-25'),
(691, 21, 'Mukbang', 1, '2025-06-25');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `active_flag` tinyint(1) DEFAULT 1,
  `phone_number` varchar(20) DEFAULT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `start_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `active_flag`, `phone_number`, `full_name`, `start_date`) VALUES
(3, 'admin', 'admin@gmail.com', 'admin123', 1, NULL, NULL, NULL),
(21, 'juan', 'juan@gmail.com', 'juan123', 1, '081808927665', 'juan', '2025-06-24'),
(34, 'alex', 'alex@mahasiswa.upnvj.ac.id', 'alex123', 1, '081808881234', 'Alex Iyowau', '2025-06-25');

-- --------------------------------------------------------

--
-- Structure for view `daily_habit_percentage`
--
DROP TABLE IF EXISTS `daily_habit_percentage`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `daily_habit_percentage`  AS SELECT `user_id` AS `user_id`, `date` AS `date`, round(sum(`completed`) / count(0),2) AS `percentage` FROM `habits` GROUP BY `user_id`, `date` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `habits`
--
ALTER TABLE `habits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_user_id_date` (`user_id`,`date`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `habits`
--
ALTER TABLE `habits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=692;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `habits`
--
ALTER TABLE `habits`
  ADD CONSTRAINT `fk_habits_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `habits_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
