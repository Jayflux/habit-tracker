-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 19, 2025 at 05:07 PM
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
(193, 10, 'Read', 0, '2025-06-19'),
(194, 10, 'Run', 0, '2025-06-19'),
(321, 12, 'Read', 1, '2025-06-19'),
(322, 12, 'Run', 1, '2025-06-19'),
(323, 12, 'Swim', 1, '2025-06-19'),
(324, 12, 'Listening Music', 1, '2025-06-19'),
(325, 12, 'Dzikir', 1, '2025-06-19');

-- --------------------------------------------------------

--
-- Table structure for table `percentage_summary`
--

CREATE TABLE `percentage_summary` (
  `ID` int(11) NOT NULL,
  `DATE` varchar(255) DEFAULT NULL,
  `PERCENTAGE` varchar(10) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `percentage_summary`
--

INSERT INTO `percentage_summary` (`ID`, `DATE`, `PERCENTAGE`, `user_id`) VALUES
(1, '20250418', '1.0', 1),
(3, '20250418', '1.0', 2),
(4, '20250619', '0.0', 1),
(5, '20250619', '0.0', 10),
(6, '20250619', '1.0', 12);

-- --------------------------------------------------------

--
-- Table structure for table `start_date`
--

CREATE TABLE `start_date` (
  `ID` int(11) NOT NULL,
  `DATE` varchar(255) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `start_date`
--

INSERT INTO `start_date` (`ID`, `DATE`, `user_id`) VALUES
(1, '20250418', 1),
(2, '20250418', 2),
(3, '20250619', 10),
(4, '20250619', 12);

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
  `full_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `active_flag`, `phone_number`, `full_name`) VALUES
(3, 'admin', 'admin@gmail.com', 'admin123', 1, NULL, NULL),
(10, 'abidar', 'abidar@gmail.com', 'abidar123', 1, '0873462838', 'abidar jajana'),
(12, 'test', 'test@gmail.com', 'test123', 0, '08181234578', 'testing');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `habits`
--
ALTER TABLE `habits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `percentage_summary`
--
ALTER TABLE `percentage_summary`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `start_date`
--
ALTER TABLE `start_date`
  ADD PRIMARY KEY (`ID`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=326;

--
-- AUTO_INCREMENT for table `percentage_summary`
--
ALTER TABLE `percentage_summary`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `start_date`
--
ALTER TABLE `start_date`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `habits`
--
ALTER TABLE `habits`
  ADD CONSTRAINT `habits_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
