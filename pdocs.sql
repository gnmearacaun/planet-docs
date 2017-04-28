-- phpMyAdmin SQL Dump
-- version 4.6.5.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Apr 30, 1999 at 04:04 AM
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

DROP PROCEDURE IF EXISTS `getMyClaimedTasks`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getMyClaimedTasks` ()  READS SQL DATA
BEGIN
	
	select c.`id`,c.`publisher_id`,c.`title`,c.`description`,c.`published_date`,c.`expiry_date` 
		from claimed_tasks c 
		where date(c.`expiry_date`) >= curdate() 
			and c.`id` not in (select si.`task_id` from claimed_tasks si)
			order by c.`published_date` desc;


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
-- Table structure for table `claimed_tasks`
--

DROP TABLE IF EXISTS `claimed_tasks`;
CREATE TABLE IF NOT EXISTS `claimed_tasks` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `task_id` int(11) UNSIGNED NOT NULL,
  `user_id` int(11) UNSIGNED NOT NULL,
  `date_claimed` datetime NOT NULL,
  `published_date` datetime NOT NULL,
  `expiry_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tasks` (`task_id`,`user_id`),
  UNIQUE KEY `fk_claimed_task` (`task_id`),
  KEY `fk_task_claimer` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tags`
--

CREATE TABLE IF NOT EXISTS tags (
  `tag_id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `tag` VARCHAR(45) DEFAULT NULL,
PRIMARY KEY (tag_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`; 
CREATE TABLE IF NOT EXISTS `tasks` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `publisher_id` INT(11) UNSIGNED NOT NULL,
  `title` varchar(128) NOT NULL,
  `description` varchar(4096) DEFAULT NULL,
  `published_date` datetime NOT NULL,
  `expiry_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_title_creator` (`title`,`publisher_id`),
  FOREIGN KEY `fk_tasks_users` (`publisher_id`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tasks`
--

INSERT INTO `tasks` (`id`, `publisher_id`, `title`, `description`, `published_date`, `expiry_date`) VALUES
(8, 5, 'thesis', 'task description', '2017-04-18 21:15:11', '2017-05-03 21:15:11'),
(9, 5, 'dissertation', 'a paper about penguin etiquette', '2017-04-18 21:27:29', '2017-05-03 21:27:29'),
(10, 5, 'article', 'global warming and the the benefits of fossil fuel reduction', '2017-04-18 21:28:37', '2017-05-03 21:28:37'),
(11, 6, 'book', 'creative commons developed on and about github', '2017-04-18 22:01:35', '2017-05-03 22:01:35');

-- --------------------------------------------------------

--
-- Table structure for table `task_clicks`
--

CREATE TABLE `task_clicks` (
  `user_id` int(11) UNSIGNED NOT NULL,
  `tag_id` int(11) UNSIGNED NOT NULL,
  `clicks` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `task_tags`
--

CREATE TABLE `task_tags` (
  `task_id` int(11) UNSIGNED NOT NULL,
  `tag_id` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` varchar(128) NOT NULL,
  `first_name` varchar(128) NOT NULL,
  `last_name` varchar(128) DEFAULT NULL,
  `password` char(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;


--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `first_name`, `last_name`, `password`) VALUES
(5, 'a', 'A', 'A', '6655fb2f5eac6d590b81a02feb4d14b4f7bff0bf7640b582a6088508032def81'),
(6, 'b', 'B', 'B', 'bdb41bde7329173cacbd3d74e5323ae5726aa7af2c7f3446e2fdb95ff9bbd543');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `task_clicks`
--
ALTER TABLE `task_clicks`
  ADD PRIMARY KEY (`user_id`,`tag_id`);

--
-- Indexes for table `task_tags`
--
ALTER TABLE `task_tags`
  ADD PRIMARY KEY (`task_id`,`tag_id`),
  ADD KEY `fk_tags_table` (`tag_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `claimed_tasks`
--
ALTER TABLE `claimed_tasks`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tags`
--
ALTER TABLE `tags`
  MODIFY `tag_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tasks`
--
ALTER TABLE `tasks`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `claimed_tasks`
--
ALTER TABLE `claimed_tasks`
  ADD CONSTRAINT `fk_task_claimer` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  /* ADD CONSTRAINT `fk_claimed_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE; */ 

--
-- Constraints for table `tasks`
--
ALTER TABLE `tasks`
  ADD CONSTRAINT `fk_tasks_users` FOREIGN KEY (`publisher_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `task_tags`
--
ALTER TABLE `task_tags`
  ADD CONSTRAINT `fk_tags_table` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`tag_id`),
  /* ADD CONSTRAINT `fk_tasks_table` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`); */

SET GLOBAL FOREIGN_KEY_CHECKS=0;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
