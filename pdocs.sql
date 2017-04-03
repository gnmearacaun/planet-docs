-- phpMyAdmin SQL Dump
-- version 4.6.5.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 10, 2017 at 04:41 PM
-- Server version: 10.1.21-MariaDB
-- PHP Version: 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pdocs`
--
CREATE DATABASE IF NOT EXISTS `pdocs` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `pdocs`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `addTask`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `addTask` (IN `publisher_id` INT, IN `title` VARCHAR(128), IN `description` VARCHAR(4096))  READS SQL DATA
BEGIN
	INSERT INTO `tasks` (`id`, `publisher_id`, `title`, `description`, `published_date`, `expiry_date`) VALUES (NULL, `publisher_id`, `title`, `description` , NOW(), DATE_ADD(NOW(), INTERVAL 15 DAY) );
	call getTask(LAST_INSERT_ID());
END$$

DROP PROCEDURE IF EXISTS `addUser`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `addUser` (IN `email` VARCHAR(128), IN `first_name` VARCHAR(128), IN `last_name` VARCHAR(128), IN `password` CHAR(128))  READS SQL DATA
BEGIN
	INSERT INTO `users` (`id`, `email`, `first_name`, `last_name`, `password`) VALUES (NULL, `email`, `first_name`, `last_name`, `password`);
	call getUser(LAST_INSERT_ID(),'');

END$$

DROP PROCEDURE IF EXISTS `getUnclaimedTasks`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getUnclaimedTasks` ()  READS SQL DATA
BEGIN
	
	select t.`id`,t.`publisher_id`,t.`title`,t.`description`,t.`published_date`,t.`expiry_date` 
		from tasks t 
		where date(t.`expiry_date`) >= curdate() 
			and t.`id` not in (select si.`task_id` from claimed_tasks si)
			order by t.`published_date` desc;


END$$

DROP PROCEDURE IF EXISTS `getTask`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getTask` (IN `id` INT)  READS SQL DATA
BEGIN
	if id='' then set id=null;end if;
	
	select t.`id`,t.`publisher_id`,t.`title`,t.`description`,t.`published_date`,t.`expiry_date` 
		from tasks t 
		where   (id is null or t.id = id);

END$$

DROP PROCEDURE IF EXISTS `getUser`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getUser` (IN `id` INT, IN `email` VARCHAR(128))  READS SQL DATA
BEGIN
	if id='' then set id=null;end if;
	if email='' then set email=null;end if;
	
	select u.id, u.email, u.`first_name`, u.`last_name`, u.password  
        from users u  
        where   (id is null or u.id = id)
            and (email is null or (LOWER(u.email) = LOWER(email)));

END$$

DROP PROCEDURE IF EXISTS `markTaskAsClaimed`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `markTaskAsClaimed` (IN `task_id` INT, IN `user_id` INT)  READS SQL DATA
BEGIN
	INSERT INTO `claimed_tasks` (`id`, `task_id`, `user_id`, `date_claimed`) VALUES (NULL, `task_id`, `user_id`, NOW());
	select 1 as "result";
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
CREATE TABLE IF NOT EXISTS `tasks` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `publisher_id` int(10) UNSIGNED NOT NULL,
  `title` varchar(128) NOT NULL,
  `description` varchar(4096) DEFAULT NULL,
  `published_date` datetime NOT NULL,
  `expiry_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_title_creator` (`title`,`publisher_id`),
  KEY `fk_tasks_users` (`publisher_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `claimed_tasks`
--

DROP TABLE IF EXISTS `claimed_tasks`;
CREATE TABLE IF NOT EXISTS `claimed_tasks` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `task_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `date_claimed` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tasks` (`task_id`,`user_id`),
  UNIQUE KEY `fk_sold_item` (`task_id`),
  KEY `fk_item_buyer` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` varchar(128) NOT NULL,
  `first_name` varchar(128) NOT NULL,
  `last_name` varchar(128) DEFAULT NULL,
  `password` char(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tasks`
--
ALTER TABLE `tasks`
  ADD CONSTRAINT `fk_tasks_users` FOREIGN KEY (`publisher_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `claimed_tasks`
--
ALTER TABLE `claimed_tasks`
  ADD CONSTRAINT `fk_item_buyer` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sold_item` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
