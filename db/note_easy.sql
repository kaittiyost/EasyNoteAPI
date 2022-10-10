-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Oct 10, 2022 at 10:19 AM
-- Server version: 10.4.14-MariaDB
-- PHP Version: 7.2.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `note_easy`
--

-- --------------------------------------------------------

--
-- Table structure for table `category_note`
--

CREATE TABLE `category_note` (
  `id` int(11) NOT NULL,
  `category_name` varchar(255) NOT NULL,
  `note_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `category_note`
--

INSERT INTO `category_note` (`id`, `category_name`, `note_id`) VALUES
(46, '#EdVISORY', 40),
(47, '#EdVISORY', 41),
(49, '#24hour', 43),
(50, '#haha', 44);

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `surname` varchar(100) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `time_reg` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`id`, `name`, `surname`, `username`, `password`, `time_reg`) VALUES
(1, 'Alan', 'Super', 'alan', '202cb962ac59075b964b07152d234b70', '2022-10-10 08:15:31'),
(2, 'test', 'test', 'test', '555', '2022-10-09 07:44:51'),
(3, 'lnwza', 'wow', 'test', 'e807f1fcf82d132f9bb018ca6738a19f', '2022-10-10 08:13:38');

-- --------------------------------------------------------

--
-- Table structure for table `history_note`
--

CREATE TABLE `history_note` (
  `id` int(11) NOT NULL,
  `note_id` int(11) NOT NULL,
  `detail` text NOT NULL,
  `time_reg` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `history_note`
--

INSERT INTO `history_note` (`id`, `note_id`, `detail`, `time_reg`) VALUES
(36, 40, 'Tuesday Oct 11, 2022 ⋅ 5:30pm – 6pm (Indochina Time - Bangkok)\n Meeting link : meet.google.com/dxm-hfou-ajd ', '2022-10-10 07:52:10'),
(37, 41, 'อ 11 ต.ค. 2565 ก่อนเวลา 12.00 น.', '2022-10-10 07:55:57'),
(39, 43, 'Email : kiattiyost22.sihawong@gmail.com Tel:061 170 0796', '2022-10-10 08:12:12'),
(40, 44, 'test', '2022-10-10 08:15:06');

-- --------------------------------------------------------

--
-- Table structure for table `note`
--

CREATE TABLE `note` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `note_name` varchar(255) NOT NULL,
  `time_reg` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `note`
--

INSERT INTO `note` (`id`, `customer_id`, `note_name`, `time_reg`) VALUES
(28, 1, 'Intern Advisory', '2022-10-10 03:58:01'),
(40, 1, '[HR] Intern BE Interview', '2022-10-10 07:52:10'),
(41, 1, 'Deadline NoteEasy', '2022-10-10 07:55:57'),
(43, 1, 'Contact Me', '2022-10-10 08:12:12'),
(44, 3, 'Wowza', '2022-10-10 08:15:06');

--
-- Triggers `note`
--
DELIMITER $$
CREATE TRIGGER `tg_bf_del_cate` BEFORE DELETE ON `note` FOR EACH ROW BEGIN
	DELETE FROM category_note WHERE note_id = old.id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_bf_del_history` BEFORE DELETE ON `note` FOR EACH ROW BEGIN
	DELETE FROM history_note WHERE note_id = old.id;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `category_note`
--
ALTER TABLE `category_note`
  ADD PRIMARY KEY (`id`),
  ADD KEY `note_id` (`note_id`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `history_note`
--
ALTER TABLE `history_note`
  ADD PRIMARY KEY (`id`),
  ADD KEY `note_id` (`note_id`);

--
-- Indexes for table `note`
--
ALTER TABLE `note`
  ADD PRIMARY KEY (`id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `category_note`
--
ALTER TABLE `category_note`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `history_note`
--
ALTER TABLE `history_note`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `note`
--
ALTER TABLE `note`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `category_note`
--
ALTER TABLE `category_note`
  ADD CONSTRAINT `category_note_ibfk_1` FOREIGN KEY (`note_id`) REFERENCES `note` (`id`);

--
-- Constraints for table `history_note`
--
ALTER TABLE `history_note`
  ADD CONSTRAINT `history_note_ibfk_1` FOREIGN KEY (`note_id`) REFERENCES `note` (`id`);

--
-- Constraints for table `note`
--
ALTER TABLE `note`
  ADD CONSTRAINT `note_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
