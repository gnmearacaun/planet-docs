-- phpMyAdmin SQL Dump
-- version 4.6.5.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Apr 27, 2017 at 11:48 AM
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

DROP PROCEDURE IF EXISTS `getUnclaimedTasks`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getUnclaimedTasks` ()  READS SQL DATA
BEGIN
	
	select t.`id`,t.`publisher_id`,t.`title`,t.`description`,t.`published_date`,t.`expiry_date` 
		from tasks t 
		where date(t.`expiry_date`) >= curdate() 
			and t.`id` not in (select si.`task_id` from claimed_tasks si)
			order by t.`published_date` desc;


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
CREATE TABLE `claimed_tasks` (
  `id` int(11) UNSIGNED NOT NULL,
  `task_id` int(11) UNSIGNED NOT NULL,
  `user_id` int(11) UNSIGNED NOT NULL,
  `date_claimed` datetime NOT NULL,
  `published_date` datetime NOT NULL,
  `expiry_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
CREATE TABLE `tags` (
  `tag_id` int(11) UNSIGNED NOT NULL,
  `tag` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
CREATE TABLE `tasks` (
  `id` int(11) UNSIGNED NOT NULL,
  `publisher_id` int(11) UNSIGNED NOT NULL,
  `title` varchar(128) NOT NULL,
  `description` varchar(4096) DEFAULT NULL,
  `published_date` datetime NOT NULL,
  `expiry_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tasks`
--

INSERT INTO `tasks` (`id`, `publisher_id`, `title`, `description`, `published_date`, `expiry_date`) VALUES
(7, 7, 'fringilla mi lacinia mattis. Integer', 'ipsum non arcu. Vivamus sit amet risus. Donec egestas. Aliquam nec enim. Nunc ut erat. Sed nunc est, mollis non, cursus non, egestas a, dui. Cras pellentesque. Sed dictum. Proin eget odio. Aliquam vulputate ullamcorper magna. Sed eu eros. Nam consequat dolor vitae dolor. Donec fringilla. Donec feugiat metus sit', '2017-04-27 19:30:10', '2017-08-10 09:48:43'),
(8, 5, 'thesis', 'task description', '2017-04-18 21:15:11', '2017-05-03 21:15:11'),
(9, 5, 'dissertation', 'a paper about penguin etiquette', '2017-04-18 21:27:29', '2017-05-03 21:27:29'),
(10, 5, 'article', 'global warming and the the benefits of fossil fuel reduction', '2017-04-18 21:28:37', '2017-05-03 21:28:37'),
(11, 6, 'book', 'creative commons developed on and about github', '2017-04-18 22:01:35', '2017-05-03 22:01:35'),
(12, 5, 'essay', 'The Balinese Tourism sector is experiencing a steady incline since the recent reports of global warming slowdown', '2017-04-25 18:41:11', '2017-05-10 18:41:11'),
(13, 8, 'Nam ligula elit, pretium et,', 'tincidunt dui augue eu tellus. Phasellus elit pede, malesuada vel, venenatis vel, faucibus id, libero. Donec consectetuer mauris id sapien. Cras dolor dolor, tempus non, lacinia at, iaculis quis, pede. Praesent eu dui. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean eget magna. Suspendisse tristique', '2017-09-14 00:43:09', '2017-10-16 05:09:00'),
(14, 9, 'tempus eu, ligula. Aenean euismod', 'montes, nascetur ridiculus mus. Proin vel nisl. Quisque fringilla euismod enim. Etiam gravida molestie arcu. Sed eu nibh vulputate mauris sagittis placerat. Cras dictum ultricies ligula. Nullam enim. Sed nulla ante, iaculis nec, eleifend non, dapibus rutrum, justo. Praesent luctus. Curabitur egestas nunc sed libero. Proin sed turpis nec mauris', '2017-10-16 04:56:41', '2018-03-25 00:20:36'),
(15, 10, 'magna. Duis dignissim tempor arcu.', 'arcu. Vivamus sit amet risus. Donec egestas. Aliquam nec enim. Nunc ut erat. Sed nunc est, mollis non, cursus non, egestas a, dui. Cras pellentesque. Sed dictum. Proin eget odio. Aliquam vulputate ullamcorper magna. Sed eu eros. Nam consequat dolor vitae dolor. Donec fringilla. Donec feugiat metus sit amet ante.', '2017-11-16 21:07:17', '2017-12-20 07:24:44'),
(16, 11, 'eu eros. Nam consequat dolor', 'aliquam iaculis, lacus pede sagittis augue, eu tempor erat neque non quam. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aliquam fringilla cursus purus. Nullam scelerisque neque sed sem egestas blandit. Nam nulla magna, malesuada vel, convallis in, cursus et, eros. Proin ultrices. Duis volutpat', '2017-08-03 19:52:16', '2018-01-27 08:37:46'),
(17, 12, 'vitae nibh. Donec est mauris,', 'nisi dictum augue malesuada malesuada. Integer id magna et ipsum cursus vestibulum. Mauris magna. Duis dignissim tempor arcu. Vestibulum ut eros non enim commodo hendrerit. Donec porttitor tellus non magna. Nam ligula elit, pretium et, rutrum non, hendrerit id, ante. Nunc mauris sapien, cursus in, hendrerit consectetuer, cursus et, magna.', '2017-08-24 15:05:26', '2017-07-24 02:33:13'),
(18, 13, 'eleifend vitae, erat. Vivamus nisi.', 'posuere vulputate, lacus. Cras interdum. Nunc sollicitudin commodo ipsum. Suspendisse non leo. Vivamus nibh dolor, nonummy ac, feugiat non, lobortis quis, pede. Suspendisse dui. Fusce diam nunc, ullamcorper eu, euismod ac, fermentum vel, mauris. Integer sem elit, pharetra ut, pharetra sed, hendrerit a, arcu. Sed et libero. Proin mi. Aliquam', '2017-10-22 13:37:46', '2017-06-24 23:03:46'),
(19, 14, 'dolor vitae dolor. Donec fringilla.', 'adipiscing lacus. Ut nec urna et arcu imperdiet ullamcorper. Duis at lacus. Quisque purus sapien, gravida non, sollicitudin a, malesuada id, erat. Etiam vestibulum massa rutrum magna. Cras convallis convallis dolor. Quisque tincidunt pede ac urna. Ut tincidunt vehicula risus. Nulla eget metus eu erat semper rutrum. Fusce dolor quam,', '2017-12-04 22:31:19', '2017-11-17 00:43:36'),
(20, 15, 'quis accumsan convallis, ante lectus', 'magna, malesuada vel, convallis in, cursus et, eros. Proin ultrices. Duis volutpat nunc sit amet metus. Aliquam erat volutpat. Nulla facilisis. Suspendisse commodo tincidunt nibh. Phasellus nulla. Integer vulputate, risus a ultricies adipiscing, enim mi tempor lorem, eget mollis lectus pede et risus. Quisque libero lacus, varius et, euismod et,', '2017-12-18 18:05:12', '2017-09-20 15:34:34'),
(21, 16, 'ut, sem. Nulla interdum. Curabitur', 'Fusce mollis. Duis sit amet diam eu dolor egestas rhoncus. Proin nisl sem, consequat nec, mollis vitae, posuere at, velit. Cras lorem lorem, luctus ut, pellentesque eget, dictum placerat, augue. Sed molestie. Sed id risus quis diam luctus lobortis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per', '2017-04-27 02:31:52', '2017-11-01 13:04:05'),
(22, 17, 'risus quis diam luctus lobortis.', 'amet risus. Donec egestas. Aliquam nec enim. Nunc ut erat. Sed nunc est, mollis non, cursus non, egestas a, dui. Cras pellentesque. Sed dictum. Proin eget odio. Aliquam vulputate ullamcorper magna. Sed eu eros. Nam consequat dolor vitae dolor. Donec fringilla. Donec feugiat metus sit amet ante. Vivamus non lorem', '2018-01-13 06:57:57', '2017-12-12 01:14:50'),
(23, 18, 'dictum magna. Ut tincidunt orci', 'laoreet lectus quis massa. Mauris vestibulum, neque sed dictum eleifend, nunc risus varius orci, in consequat enim diam vel arcu. Curabitur ut odio vel est tempor bibendum. Donec felis orci, adipiscing non, luctus sit amet, faucibus ut, nulla. Cras eu tellus eu augue porttitor interdum. Sed auctor odio a purus.', '2018-04-01 10:19:39', '2017-05-15 13:03:36'),
(24, 19, 'mus. Aenean eget magna. Suspendisse', 'Morbi non sapien molestie orci tincidunt adipiscing. Mauris molestie pharetra nibh. Aliquam ornare, libero at auctor ullamcorper, nisl arcu iaculis enim, sit amet ornare lectus justo eu arcu. Morbi sit amet massa. Quisque porttitor eros nec tellus. Nunc lectus pede, ultrices a, auctor non, feugiat nec, diam. Duis mi enim,', '2017-11-20 14:44:19', '2017-10-19 11:24:46'),
(25, 20, 'dolor, nonummy ac, feugiat non,', 'et, commodo at, libero. Morbi accumsan laoreet ipsum. Curabitur consequat, lectus sit amet luctus vulputate, nisi sem semper erat, in consectetuer ipsum nunc id enim. Curabitur massa. Vestibulum accumsan neque et nunc. Quisque ornare tortor at risus. Nunc ac sem ut dolor dapibus gravida. Aliquam tincidunt, nunc ac mattis ornare,', '2017-12-06 05:47:34', '2017-05-22 18:49:29'),
(26, 21, 'non, lobortis quis, pede. Suspendisse', 'elit sed consequat auctor, nunc nulla vulputate dui, nec tempus mauris erat eget ipsum. Suspendisse sagittis. Nullam vitae diam. Proin dolor. Nulla semper tellus id nunc interdum feugiat. Sed nec metus facilisis lorem tristique aliquet. Phasellus fermentum convallis ligula. Donec luctus aliquet odio. Etiam ligula tortor, dictum eu, placerat eget,', '2017-09-21 10:56:29', '2017-09-04 05:33:09'),
(27, 22, 'semper tellus id nunc interdum', 'sem ut cursus luctus, ipsum leo elementum sem, vitae aliquam eros turpis non enim. Mauris quis turpis vitae purus gravida sagittis. Duis gravida. Praesent eu nulla at sem molestie sodales. Mauris blandit enim consequat purus. Maecenas libero est, congue a, aliquet vel, vulputate eu, odio. Phasellus at augue id ante', '2017-11-14 19:45:48', '2018-04-08 14:38:36'),
(28, 23, 'malesuada id, erat. Etiam vestibulum', 'urna, nec luctus felis purus ac tellus. Suspendisse sed dolor. Fusce mi lorem, vehicula et, rutrum eu, ultrices sit amet, risus. Donec nibh enim, gravida sit amet, dapibus id, blandit at, nisi. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Proin vel nisl. Quisque fringilla euismod', '2017-11-26 05:13:35', '2018-03-19 16:13:36'),
(29, 24, 'amet, faucibus ut, nulla. Cras', 'vel quam dignissim pharetra. Nam ac nulla. In tincidunt congue turpis. In condimentum. Donec at arcu. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec tincidunt. Donec vitae erat vel pede blandit congue. In scelerisque scelerisque dui. Suspendisse ac metus vitae velit egestas lacinia. Sed', '2017-10-07 14:18:19', '2018-02-14 12:22:19'),
(30, 25, 'lacus. Nulla tincidunt, neque vitae', 'Vivamus sit amet risus. Donec egestas. Aliquam nec enim. Nunc ut erat. Sed nunc est, mollis non, cursus non, egestas a, dui. Cras pellentesque. Sed dictum. Proin eget odio. Aliquam vulputate ullamcorper magna. Sed eu eros. Nam consequat dolor vitae dolor. Donec fringilla. Donec feugiat metus sit amet ante. Vivamus', '2018-03-13 13:30:59', '2018-02-28 23:57:25'),
(31, 26, 'nisl. Maecenas malesuada fringilla est.', 'ante dictum mi, ac mattis velit justo nec ante. Maecenas mi felis, adipiscing fringilla, porttitor vulputate, posuere vulputate, lacus. Cras interdum. Nunc sollicitudin commodo ipsum. Suspendisse non leo. Vivamus nibh dolor, nonummy ac, feugiat non, lobortis quis, pede. Suspendisse dui. Fusce diam nunc, ullamcorper eu, euismod ac, fermentum vel, mauris.', '2017-06-06 05:25:39', '2017-12-31 19:06:48'),
(32, 27, 'at pretium aliquet, metus urna', 'non leo. Vivamus nibh dolor, nonummy ac, feugiat non, lobortis quis, pede. Suspendisse dui. Fusce diam nunc, ullamcorper eu, euismod ac, fermentum vel, mauris. Integer sem elit, pharetra ut, pharetra sed, hendrerit a, arcu. Sed et libero. Proin mi. Aliquam gravida mauris ut mi. Duis risus odio, auctor vitae, aliquet', '2017-11-23 13:44:16', '2017-06-05 02:33:40'),
(33, 28, 'egestas a, scelerisque sed, sapien.', 'penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec dignissim magna a tortor. Nunc commodo auctor velit. Aliquam nisl. Nulla eu neque pellentesque massa lobortis ultrices. Vivamus rhoncus. Donec est. Nunc ullamcorper, velit in aliquet lobortis, nisi nibh lacinia orci, consectetuer euismod est arcu ac orci. Ut semper pretium', '2017-04-27 10:37:04', '2017-07-31 06:51:06'),
(34, 29, 'leo, in lobortis tellus justo', 'risus quis diam luctus lobortis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Mauris ut quam vel sapien imperdiet ornare. In faucibus. Morbi vehicula. Pellentesque tincidunt tempus risus. Donec egestas. Duis ac arcu. Nunc mauris. Morbi non sapien molestie orci tincidunt adipiscing. Mauris molestie pharetra', '2017-11-27 19:42:09', '2017-08-22 23:03:55'),
(35, 30, 'ac nulla. In tincidunt congue', 'Donec feugiat metus sit amet ante. Vivamus non lorem vitae odio sagittis semper. Nam tempor diam dictum sapien. Aenean massa. Integer vitae nibh. Donec est mauris, rhoncus id, mollis nec, cursus a, enim. Suspendisse aliquet, sem ut cursus luctus, ipsum leo elementum sem, vitae aliquam eros turpis non enim. Mauris', '2017-07-18 00:09:54', '2017-10-30 06:23:11'),
(36, 31, 'Mauris ut quam vel sapien', 'convallis dolor. Quisque tincidunt pede ac urna. Ut tincidunt vehicula risus. Nulla eget metus eu erat semper rutrum. Fusce dolor quam, elementum at, egestas a, scelerisque sed, sapien. Nunc pulvinar arcu et pede. Nunc sed orci lobortis augue scelerisque mollis. Phasellus libero mauris, aliquam eu, accumsan sed, facilisis vitae, orci.', '2018-01-01 04:09:14', '2017-07-25 22:33:42'),
(37, 32, 'libero. Integer in magna. Phasellus', 'enim. Sed nulla ante, iaculis nec, eleifend non, dapibus rutrum, justo. Praesent luctus. Curabitur egestas nunc sed libero. Proin sed turpis nec mauris blandit mattis. Cras eget nisi dictum augue malesuada malesuada. Integer id magna et ipsum cursus vestibulum. Mauris magna. Duis dignissim tempor arcu. Vestibulum ut eros non enim', '2017-12-31 00:31:13', '2017-08-24 07:38:18'),
(38, 33, 'est arcu ac orci. Ut', 'varius ultrices, mauris ipsum porta elit, a feugiat tellus lorem eu metus. In lorem. Donec elementum, lorem ut aliquam iaculis, lacus pede sagittis augue, eu tempor erat neque non quam. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aliquam fringilla cursus purus. Nullam scelerisque neque', '2018-01-12 23:28:25', '2018-01-02 05:26:25'),
(39, 34, 'dictum ultricies ligula. Nullam enim.', 'vitae odio sagittis semper. Nam tempor diam dictum sapien. Aenean massa. Integer vitae nibh. Donec est mauris, rhoncus id, mollis nec, cursus a, enim. Suspendisse aliquet, sem ut cursus luctus, ipsum leo elementum sem, vitae aliquam eros turpis non enim. Mauris quis turpis vitae purus gravida sagittis. Duis gravida. Praesent', '2017-09-23 03:54:38', '2017-11-21 06:35:10'),
(40, 35, 'placerat, orci lacus vestibulum lorem,', 'vitae purus gravida sagittis. Duis gravida. Praesent eu nulla at sem molestie sodales. Mauris blandit enim consequat purus. Maecenas libero est, congue a, aliquet vel, vulputate eu, odio. Phasellus at augue id ante dictum cursus. Nunc mauris elit, dictum eu, eleifend nec, malesuada ut, sem. Nulla interdum. Curabitur dictum. Phasellus', '2018-01-09 23:47:38', '2017-08-02 10:47:51'),
(41, 36, 'in aliquet lobortis, nisi nibh', 'aliquam arcu. Aliquam ultrices iaculis odio. Nam interdum enim non nisi. Aenean eget metus. In nec orci. Donec nibh. Quisque nonummy ipsum non arcu. Vivamus sit amet risus. Donec egestas. Aliquam nec enim. Nunc ut erat. Sed nunc est, mollis non, cursus non, egestas a, dui. Cras pellentesque. Sed dictum.', '2018-04-07 10:32:04', '2017-07-30 21:56:41'),
(42, 37, 'lorem ut aliquam iaculis, lacus', 'posuere cubilia Curae; Phasellus ornare. Fusce mollis. Duis sit amet diam eu dolor egestas rhoncus. Proin nisl sem, consequat nec, mollis vitae, posuere at, velit. Cras lorem lorem, luctus ut, pellentesque eget, dictum placerat, augue. Sed molestie. Sed id risus quis diam luctus lobortis. Class aptent taciti sociosqu ad litora', '2018-01-06 07:01:22', '2018-03-03 16:29:44'),
(43, 38, 'tincidunt dui augue eu tellus.', 'sem elit, pharetra ut, pharetra sed, hendrerit a, arcu. Sed et libero. Proin mi. Aliquam gravida mauris ut mi. Duis risus odio, auctor vitae, aliquet nec, imperdiet nec, leo. Morbi neque tellus, imperdiet non, vestibulum nec, euismod in, dolor. Fusce feugiat. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aliquam', '2017-12-31 15:14:00', '2017-12-05 02:08:47'),
(44, 39, 'Nunc mauris sapien, cursus in,', 'egestas nunc sed libero. Proin sed turpis nec mauris blandit mattis. Cras eget nisi dictum augue malesuada malesuada. Integer id magna et ipsum cursus vestibulum. Mauris magna. Duis dignissim tempor arcu. Vestibulum ut eros non enim commodo hendrerit. Donec porttitor tellus non magna. Nam ligula elit, pretium et, rutrum non,', '2018-01-26 04:00:40', '2017-08-18 11:31:41'),
(45, 40, 'enim mi tempor lorem, eget', 'luctus aliquet odio. Etiam ligula tortor, dictum eu, placerat eget, venenatis a, magna. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Etiam laoreet, libero et tristique pellentesque, tellus sem mollis dui, in sodales elit erat vitae risus. Duis a mi fringilla mi lacinia mattis. Integer eu lacus. Quisque imperdiet, erat', '2017-12-01 02:10:03', '2018-02-13 08:23:55'),
(46, 41, 'eu, placerat eget, venenatis a,', 'magnis dis parturient montes, nascetur ridiculus mus. Aenean eget magna. Suspendisse tristique neque venenatis lacus. Etiam bibendum fermentum metus. Aenean sed pede nec ante blandit viverra. Donec tempus, lorem fringilla ornare placerat, orci lacus vestibulum lorem, sit amet ultricies sem magna nec quam. Curabitur vel lectus. Cum sociis natoque penatibus', '2017-08-09 00:48:02', '2017-06-06 04:31:48'),
(47, 42, 'Aenean eget magna. Suspendisse tristique', 'Cras interdum. Nunc sollicitudin commodo ipsum. Suspendisse non leo. Vivamus nibh dolor, nonummy ac, feugiat non, lobortis quis, pede. Suspendisse dui. Fusce diam nunc, ullamcorper eu, euismod ac, fermentum vel, mauris. Integer sem elit, pharetra ut, pharetra sed, hendrerit a, arcu. Sed et libero. Proin mi. Aliquam gravida mauris ut', '2017-10-25 04:32:02', '2018-03-28 12:20:17'),
(48, 43, 'ante ipsum primis in faucibus', 'mi lacinia mattis. Integer eu lacus. Quisque imperdiet, erat nonummy ultricies ornare, elit elit fermentum risus, at fringilla purus mauris a nunc. In at pede. Cras vulputate velit eu sem. Pellentesque ut ipsum ac mi eleifend egestas. Sed pharetra, felis eget varius ultrices, mauris ipsum porta elit, a feugiat tellus', '2017-07-01 11:24:16', '2017-07-30 19:06:34'),
(49, 44, 'elit. Curabitur sed tortor. Integer', 'erat semper rutrum. Fusce dolor quam, elementum at, egestas a, scelerisque sed, sapien. Nunc pulvinar arcu et pede. Nunc sed orci lobortis augue scelerisque mollis. Phasellus libero mauris, aliquam eu, accumsan sed, facilisis vitae, orci. Phasellus dapibus quam quis diam. Pellentesque habitant morbi tristique senectus et netus et malesuada fames', '2017-09-02 22:00:35', '2017-05-29 14:38:17'),
(50, 45, 'Sed dictum. Proin eget odio.', 'tellus id nunc interdum feugiat. Sed nec metus facilisis lorem tristique aliquet. Phasellus fermentum convallis ligula. Donec luctus aliquet odio. Etiam ligula tortor, dictum eu, placerat eget, venenatis a, magna. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Etiam laoreet, libero et tristique pellentesque, tellus sem mollis dui, in sodales', '2017-04-27 17:08:51', '2017-12-11 15:00:26'),
(51, 46, 'Sed pharetra, felis eget varius', 'lorem ac risus. Morbi metus. Vivamus euismod urna. Nullam lobortis quam a felis ullamcorper viverra. Maecenas iaculis aliquet diam. Sed diam lorem, auctor quis, tristique ac, eleifend vitae, erat. Vivamus nisi. Mauris nulla. Integer urna. Vivamus molestie dapibus ligula. Aliquam erat volutpat. Nulla dignissim. Maecenas ornare egestas ligula. Nullam feugiat', '2017-12-21 02:09:01', '2018-01-31 14:34:35'),
(52, 47, 'non, lobortis quis, pede. Suspendisse', 'neque. Sed eget lacus. Mauris non dui nec urna suscipit nonummy. Fusce fermentum fermentum arcu. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Phasellus ornare. Fusce mollis. Duis sit amet diam eu dolor egestas rhoncus. Proin nisl sem, consequat nec, mollis vitae, posuere at, velit.', '2017-06-24 21:10:53', '2017-05-30 20:48:07'),
(53, 48, 'id, ante. Nunc mauris sapien,', 'Nullam ut nisi a odio semper cursus. Integer mollis. Integer tincidunt aliquam arcu. Aliquam ultrices iaculis odio. Nam interdum enim non nisi. Aenean eget metus. In nec orci. Donec nibh. Quisque nonummy ipsum non arcu. Vivamus sit amet risus. Donec egestas. Aliquam nec enim. Nunc ut erat. Sed nunc est,', '2017-05-25 20:36:04', '2017-09-30 08:31:52'),
(54, 49, 'Cras pellentesque. Sed dictum. Proin', 'venenatis a, magna. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Etiam laoreet, libero et tristique pellentesque, tellus sem mollis dui, in sodales elit erat vitae risus. Duis a mi fringilla mi lacinia mattis. Integer eu lacus. Quisque imperdiet, erat nonummy ultricies ornare, elit elit fermentum risus, at fringilla purus', '2018-04-25 11:41:44', '2017-08-14 14:54:21'),
(55, 50, 'Morbi vehicula. Pellentesque tincidunt tempus', 'lorem. Donec elementum, lorem ut aliquam iaculis, lacus pede sagittis augue, eu tempor erat neque non quam. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aliquam fringilla cursus purus. Nullam scelerisque neque sed sem egestas blandit. Nam nulla magna, malesuada vel, convallis in, cursus et,', '2018-03-22 18:36:08', '2017-06-02 18:36:13'),
(56, 51, 'eget massa. Suspendisse eleifend. Cras', 'ut, molestie in, tempus eu, ligula. Aenean euismod mauris eu elit. Nulla facilisi. Sed neque. Sed eget lacus. Mauris non dui nec urna suscipit nonummy. Fusce fermentum fermentum arcu. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Phasellus ornare. Fusce mollis. Duis sit amet diam', '2017-05-06 23:31:56', '2017-06-27 17:42:28'),
(57, 52, 'Sed auctor odio a purus.', 'orci, consectetuer euismod est arcu ac orci. Ut semper pretium neque. Morbi quis urna. Nunc quis arcu vel quam dignissim pharetra. Nam ac nulla. In tincidunt congue turpis. In condimentum. Donec at arcu. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec tincidunt. Donec vitae', '2018-04-10 08:53:51', '2018-02-03 02:55:11'),
(58, 53, 'rutrum lorem ac risus. Morbi', 'tellus eu augue porttitor interdum. Sed auctor odio a purus. Duis elementum, dui quis accumsan convallis, ante lectus convallis est, vitae sodales nisi magna sed dui. Fusce aliquam, enim nec tempus scelerisque, lorem ipsum sodales purus, in molestie tortor nibh sit amet orci. Ut sagittis lobortis mauris. Suspendisse aliquet molestie', '2017-06-19 09:43:34', '2017-11-10 02:43:21'),
(59, 54, 'lorem, auctor quis, tristique ac,', 'lectus sit amet luctus vulputate, nisi sem semper erat, in consectetuer ipsum nunc id enim. Curabitur massa. Vestibulum accumsan neque et nunc. Quisque ornare tortor at risus. Nunc ac sem ut dolor dapibus gravida. Aliquam tincidunt, nunc ac mattis ornare, lectus ante dictum mi, ac mattis velit justo nec ante.', '2017-06-16 12:18:22', '2017-07-09 22:51:13'),
(60, 55, 'at pede. Cras vulputate velit', 'tincidunt adipiscing. Mauris molestie pharetra nibh. Aliquam ornare, libero at auctor ullamcorper, nisl arcu iaculis enim, sit amet ornare lectus justo eu arcu. Morbi sit amet massa. Quisque porttitor eros nec tellus. Nunc lectus pede, ultrices a, auctor non, feugiat nec, diam. Duis mi enim, condimentum eget, volutpat ornare, facilisis', '2017-05-16 06:53:45', '2017-07-30 05:41:05'),
(61, 56, 'dolor. Quisque tincidunt pede ac', 'tellus eu augue porttitor interdum. Sed auctor odio a purus. Duis elementum, dui quis accumsan convallis, ante lectus convallis est, vitae sodales nisi magna sed dui. Fusce aliquam, enim nec tempus scelerisque, lorem ipsum sodales purus, in molestie tortor nibh sit amet orci. Ut sagittis lobortis mauris. Suspendisse aliquet molestie', '2017-11-01 06:34:36', '2017-12-19 10:56:04'),
(62, 57, 'urna. Vivamus molestie dapibus ligula.', 'odio. Nam interdum enim non nisi. Aenean eget metus. In nec orci. Donec nibh. Quisque nonummy ipsum non arcu. Vivamus sit amet risus. Donec egestas. Aliquam nec enim. Nunc ut erat. Sed nunc est, mollis non, cursus non, egestas a, dui. Cras pellentesque. Sed dictum. Proin eget odio. Aliquam vulputate', '2017-08-13 06:44:45', '2018-03-14 12:10:51'),
(63, 58, 'egestas, urna justo faucibus lectus,', 'tempor diam dictum sapien. Aenean massa. Integer vitae nibh. Donec est mauris, rhoncus id, mollis nec, cursus a, enim. Suspendisse aliquet, sem ut cursus luctus, ipsum leo elementum sem, vitae aliquam eros turpis non enim. Mauris quis turpis vitae purus gravida sagittis. Duis gravida. Praesent eu nulla at sem molestie', '2017-12-16 23:33:05', '2018-03-06 06:05:57'),
(64, 59, 'Cras dolor dolor, tempus non,', 'pellentesque a, facilisis non, bibendum sed, est. Nunc laoreet lectus quis massa. Mauris vestibulum, neque sed dictum eleifend, nunc risus varius orci, in consequat enim diam vel arcu. Curabitur ut odio vel est tempor bibendum. Donec felis orci, adipiscing non, luctus sit amet, faucibus ut, nulla. Cras eu tellus eu', '2017-10-24 05:27:58', '2018-02-26 17:01:55'),
(65, 60, 'lorem eu metus. In lorem.', 'bibendum fermentum metus. Aenean sed pede nec ante blandit viverra. Donec tempus, lorem fringilla ornare placerat, orci lacus vestibulum lorem, sit amet ultricies sem magna nec quam. Curabitur vel lectus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec dignissim magna a tortor. Nunc commodo auctor', '2017-09-23 10:00:24', '2018-03-14 01:19:52'),
(66, 61, 'egestas. Duis ac arcu. Nunc', 'magna a tortor. Nunc commodo auctor velit. Aliquam nisl. Nulla eu neque pellentesque massa lobortis ultrices. Vivamus rhoncus. Donec est. Nunc ullamcorper, velit in aliquet lobortis, nisi nibh lacinia orci, consectetuer euismod est arcu ac orci. Ut semper pretium neque. Morbi quis urna. Nunc quis arcu vel quam dignissim pharetra.', '2017-10-24 03:12:37', '2018-04-09 14:22:39'),
(67, 62, 'metus. Vivamus euismod urna. Nullam', 'sodales at, velit. Pellentesque ultricies dignissim lacus. Aliquam rutrum lorem ac risus. Morbi metus. Vivamus euismod urna. Nullam lobortis quam a felis ullamcorper viverra. Maecenas iaculis aliquet diam. Sed diam lorem, auctor quis, tristique ac, eleifend vitae, erat. Vivamus nisi. Mauris nulla. Integer urna. Vivamus molestie dapibus ligula. Aliquam erat', '2017-10-07 02:07:26', '2018-03-13 02:26:33'),
(68, 63, 'in consequat enim diam vel', 'magna, malesuada vel, convallis in, cursus et, eros. Proin ultrices. Duis volutpat nunc sit amet metus. Aliquam erat volutpat. Nulla facilisis. Suspendisse commodo tincidunt nibh. Phasellus nulla. Integer vulputate, risus a ultricies adipiscing, enim mi tempor lorem, eget mollis lectus pede et risus. Quisque libero lacus, varius et, euismod et,', '2017-07-03 21:54:54', '2017-07-19 12:56:48'),
(69, 64, 'amet luctus vulputate, nisi sem', 'ac arcu. Nunc mauris. Morbi non sapien molestie orci tincidunt adipiscing. Mauris molestie pharetra nibh. Aliquam ornare, libero at auctor ullamcorper, nisl arcu iaculis enim, sit amet ornare lectus justo eu arcu. Morbi sit amet massa. Quisque porttitor eros nec tellus. Nunc lectus pede, ultrices a, auctor non, feugiat nec,', '2018-04-20 14:44:33', '2017-07-15 22:18:02'),
(70, 65, 'eget, dictum placerat, augue. Sed', 'varius et, euismod et, commodo at, libero. Morbi accumsan laoreet ipsum. Curabitur consequat, lectus sit amet luctus vulputate, nisi sem semper erat, in consectetuer ipsum nunc id enim. Curabitur massa. Vestibulum accumsan neque et nunc. Quisque ornare tortor at risus. Nunc ac sem ut dolor dapibus gravida. Aliquam tincidunt, nunc', '2017-12-27 23:26:09', '2018-04-07 17:01:56'),
(71, 66, 'Sed eu nibh vulputate mauris', 'sit amet diam eu dolor egestas rhoncus. Proin nisl sem, consequat nec, mollis vitae, posuere at, velit. Cras lorem lorem, luctus ut, pellentesque eget, dictum placerat, augue. Sed molestie. Sed id risus quis diam luctus lobortis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Mauris', '2017-09-09 02:01:35', '2017-11-01 22:38:49'),
(72, 67, 'Phasellus dapibus quam quis diam.', 'nostra, per inceptos hymenaeos. Mauris ut quam vel sapien imperdiet ornare. In faucibus. Morbi vehicula. Pellentesque tincidunt tempus risus. Donec egestas. Duis ac arcu. Nunc mauris. Morbi non sapien molestie orci tincidunt adipiscing. Mauris molestie pharetra nibh. Aliquam ornare, libero at auctor ullamcorper, nisl arcu iaculis enim, sit amet ornare', '2018-01-12 21:13:47', '2017-12-23 11:29:39'),
(73, 68, 'a, malesuada id, erat. Etiam', 'eleifend egestas. Sed pharetra, felis eget varius ultrices, mauris ipsum porta elit, a feugiat tellus lorem eu metus. In lorem. Donec elementum, lorem ut aliquam iaculis, lacus pede sagittis augue, eu tempor erat neque non quam. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aliquam', '2017-12-04 02:15:03', '2018-02-03 17:07:57'),
(74, 69, 'Integer urna. Vivamus molestie dapibus', 'eget, dictum placerat, augue. Sed molestie. Sed id risus quis diam luctus lobortis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Mauris ut quam vel sapien imperdiet ornare. In faucibus. Morbi vehicula. Pellentesque tincidunt tempus risus. Donec egestas. Duis ac arcu. Nunc mauris. Morbi non', '2018-04-12 16:29:43', '2017-12-06 17:06:42'),
(75, 70, 'blandit viverra. Donec tempus, lorem', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean eget magna. Suspendisse tristique neque venenatis lacus. Etiam bibendum fermentum metus. Aenean sed pede nec ante blandit viverra. Donec tempus, lorem fringilla ornare placerat, orci lacus vestibulum lorem, sit amet ultricies sem magna nec quam. Curabitur vel', '2017-09-19 11:13:55', '2017-09-19 18:53:05'),
(76, 71, 'ad litora torquent per conubia', 'Aliquam erat volutpat. Nulla facilisis. Suspendisse commodo tincidunt nibh. Phasellus nulla. Integer vulputate, risus a ultricies adipiscing, enim mi tempor lorem, eget mollis lectus pede et risus. Quisque libero lacus, varius et, euismod et, commodo at, libero. Morbi accumsan laoreet ipsum. Curabitur consequat, lectus sit amet luctus vulputate, nisi sem', '2018-03-03 23:57:16', '2017-11-14 18:14:51'),
(77, 72, 'ipsum primis in faucibus orci', 'Sed nunc est, mollis non, cursus non, egestas a, dui. Cras pellentesque. Sed dictum. Proin eget odio. Aliquam vulputate ullamcorper magna. Sed eu eros. Nam consequat dolor vitae dolor. Donec fringilla. Donec feugiat metus sit amet ante. Vivamus non lorem vitae odio sagittis semper. Nam tempor diam dictum sapien. Aenean', '2017-10-09 13:34:14', '2017-07-22 02:50:23'),
(78, 73, 'eu nulla at sem molestie', 'Vivamus nibh dolor, nonummy ac, feugiat non, lobortis quis, pede. Suspendisse dui. Fusce diam nunc, ullamcorper eu, euismod ac, fermentum vel, mauris. Integer sem elit, pharetra ut, pharetra sed, hendrerit a, arcu. Sed et libero. Proin mi. Aliquam gravida mauris ut mi. Duis risus odio, auctor vitae, aliquet nec, imperdiet', '2018-01-12 04:21:39', '2017-06-17 15:23:33'),
(79, 74, 'Aliquam tincidunt, nunc ac mattis', 'parturient montes, nascetur ridiculus mus. Donec dignissim magna a tortor. Nunc commodo auctor velit. Aliquam nisl. Nulla eu neque pellentesque massa lobortis ultrices. Vivamus rhoncus. Donec est. Nunc ullamcorper, velit in aliquet lobortis, nisi nibh lacinia orci, consectetuer euismod est arcu ac orci. Ut semper pretium neque. Morbi quis urna.', '2018-02-14 03:12:11', '2018-02-13 04:31:59'),
(80, 75, 'Proin vel arcu eu odio', 'tristique ac, eleifend vitae, erat. Vivamus nisi. Mauris nulla. Integer urna. Vivamus molestie dapibus ligula. Aliquam erat volutpat. Nulla dignissim. Maecenas ornare egestas ligula. Nullam feugiat placerat velit. Quisque varius. Nam porttitor scelerisque neque. Nullam nisl. Maecenas malesuada fringilla est. Mauris eu turpis. Nulla aliquet. Proin velit. Sed malesuada augue', '2017-10-06 00:04:26', '2017-07-07 07:50:49'),
(81, 76, 'nunc interdum feugiat. Sed nec', 'sem egestas blandit. Nam nulla magna, malesuada vel, convallis in, cursus et, eros. Proin ultrices. Duis volutpat nunc sit amet metus. Aliquam erat volutpat. Nulla facilisis. Suspendisse commodo tincidunt nibh. Phasellus nulla. Integer vulputate, risus a ultricies adipiscing, enim mi tempor lorem, eget mollis lectus pede et risus. Quisque libero', '2017-08-06 16:19:14', '2018-01-01 12:09:39'),
(82, 77, 'nec ante blandit viverra. Donec', 'erat, eget tincidunt dui augue eu tellus. Phasellus elit pede, malesuada vel, venenatis vel, faucibus id, libero. Donec consectetuer mauris id sapien. Cras dolor dolor, tempus non, lacinia at, iaculis quis, pede. Praesent eu dui. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean eget magna.', '2017-05-13 04:12:46', '2017-12-13 02:10:47'),
(83, 78, 'in, tempus eu, ligula. Aenean', 'tempus risus. Donec egestas. Duis ac arcu. Nunc mauris. Morbi non sapien molestie orci tincidunt adipiscing. Mauris molestie pharetra nibh. Aliquam ornare, libero at auctor ullamcorper, nisl arcu iaculis enim, sit amet ornare lectus justo eu arcu. Morbi sit amet massa. Quisque porttitor eros nec tellus. Nunc lectus pede, ultrices', '2017-12-23 19:27:30', '2017-07-26 08:01:10'),
(84, 79, 'ac sem ut dolor dapibus', 'in sodales elit erat vitae risus. Duis a mi fringilla mi lacinia mattis. Integer eu lacus. Quisque imperdiet, erat nonummy ultricies ornare, elit elit fermentum risus, at fringilla purus mauris a nunc. In at pede. Cras vulputate velit eu sem. Pellentesque ut ipsum ac mi eleifend egestas. Sed pharetra, felis', '2018-01-11 06:34:03', '2018-01-27 19:59:18'),
(85, 80, 'aliquam iaculis, lacus pede sagittis', 'at arcu. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec tincidunt. Donec vitae erat vel pede blandit congue. In scelerisque scelerisque dui. Suspendisse ac metus vitae velit egestas lacinia. Sed congue, elit sed consequat auctor, nunc nulla vulputate dui, nec tempus mauris erat eget', '2017-12-06 07:59:27', '2017-11-17 20:55:36'),
(86, 81, 'Integer tincidunt aliquam arcu. Aliquam', 'gravida sagittis. Duis gravida. Praesent eu nulla at sem molestie sodales. Mauris blandit enim consequat purus. Maecenas libero est, congue a, aliquet vel, vulputate eu, odio. Phasellus at augue id ante dictum cursus. Nunc mauris elit, dictum eu, eleifend nec, malesuada ut, sem. Nulla interdum. Curabitur dictum. Phasellus in felis.', '2017-08-28 15:17:49', '2017-05-22 16:15:49'),
(87, 82, 'metus vitae velit egestas lacinia.', 'eget varius ultrices, mauris ipsum porta elit, a feugiat tellus lorem eu metus. In lorem. Donec elementum, lorem ut aliquam iaculis, lacus pede sagittis augue, eu tempor erat neque non quam. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aliquam fringilla cursus purus. Nullam scelerisque', '2017-10-12 06:32:02', '2017-12-08 01:14:32'),
(88, 83, 'porttitor scelerisque neque. Nullam nisl.', 'tempor, est ac mattis semper, dui lectus rutrum urna, nec luctus felis purus ac tellus. Suspendisse sed dolor. Fusce mi lorem, vehicula et, rutrum eu, ultrices sit amet, risus. Donec nibh enim, gravida sit amet, dapibus id, blandit at, nisi. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur', '2017-11-17 04:59:41', '2018-01-22 12:59:46'),
(89, 84, 'metus urna convallis erat, eget', 'Curabitur consequat, lectus sit amet luctus vulputate, nisi sem semper erat, in consectetuer ipsum nunc id enim. Curabitur massa. Vestibulum accumsan neque et nunc. Quisque ornare tortor at risus. Nunc ac sem ut dolor dapibus gravida. Aliquam tincidunt, nunc ac mattis ornare, lectus ante dictum mi, ac mattis velit justo', '2017-12-02 17:49:47', '2017-11-20 16:11:44'),
(90, 85, 'sodales elit erat vitae risus.', 'nunc sit amet metus. Aliquam erat volutpat. Nulla facilisis. Suspendisse commodo tincidunt nibh. Phasellus nulla. Integer vulputate, risus a ultricies adipiscing, enim mi tempor lorem, eget mollis lectus pede et risus. Quisque libero lacus, varius et, euismod et, commodo at, libero. Morbi accumsan laoreet ipsum. Curabitur consequat, lectus sit amet', '2018-01-23 03:55:54', '2018-03-12 07:25:50'),
(91, 86, 'est ac mattis semper, dui', 'Nullam suscipit, est ac facilisis facilisis, magna tellus faucibus leo, in lobortis tellus justo sit amet nulla. Donec non justo. Proin non massa non ante bibendum ullamcorper. Duis cursus, diam at pretium aliquet, metus urna convallis erat, eget tincidunt dui augue eu tellus. Phasellus elit pede, malesuada vel, venenatis vel,', '2017-10-20 15:45:05', '2017-05-19 02:56:07'),
(92, 87, 'tincidunt, neque vitae semper egestas,', 'eu elit. Nulla facilisi. Sed neque. Sed eget lacus. Mauris non dui nec urna suscipit nonummy. Fusce fermentum fermentum arcu. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Phasellus ornare. Fusce mollis. Duis sit amet diam eu dolor egestas rhoncus. Proin nisl sem, consequat nec,', '2018-03-01 21:50:20', '2017-05-18 02:28:55'),
(93, 88, 'Lorem ipsum dolor sit amet,', 'quis massa. Mauris vestibulum, neque sed dictum eleifend, nunc risus varius orci, in consequat enim diam vel arcu. Curabitur ut odio vel est tempor bibendum. Donec felis orci, adipiscing non, luctus sit amet, faucibus ut, nulla. Cras eu tellus eu augue porttitor interdum. Sed auctor odio a purus. Duis elementum,', '2018-03-06 12:48:05', '2017-06-14 07:48:17'),
(94, 89, 'libero. Integer in magna. Phasellus', 'augue. Sed molestie. Sed id risus quis diam luctus lobortis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Mauris ut quam vel sapien imperdiet ornare. In faucibus. Morbi vehicula. Pellentesque tincidunt tempus risus. Donec egestas. Duis ac arcu. Nunc mauris. Morbi non sapien molestie orci', '2017-05-25 15:12:43', '2017-11-05 14:57:23'),
(95, 90, 'Cras lorem lorem, luctus ut,', 'ante. Maecenas mi felis, adipiscing fringilla, porttitor vulputate, posuere vulputate, lacus. Cras interdum. Nunc sollicitudin commodo ipsum. Suspendisse non leo. Vivamus nibh dolor, nonummy ac, feugiat non, lobortis quis, pede. Suspendisse dui. Fusce diam nunc, ullamcorper eu, euismod ac, fermentum vel, mauris. Integer sem elit, pharetra ut, pharetra sed, hendrerit', '2017-09-19 12:26:37', '2018-01-09 01:59:46'),
(96, 91, 'semper auctor. Mauris vel turpis.', 'hendrerit neque. In ornare sagittis felis. Donec tempor, est ac mattis semper, dui lectus rutrum urna, nec luctus felis purus ac tellus. Suspendisse sed dolor. Fusce mi lorem, vehicula et, rutrum eu, ultrices sit amet, risus. Donec nibh enim, gravida sit amet, dapibus id, blandit at, nisi. Cum sociis natoque', '2017-05-17 16:14:14', '2018-02-28 02:20:33'),
(97, 92, 'eget metus. In nec orci.', 'nunc interdum feugiat. Sed nec metus facilisis lorem tristique aliquet. Phasellus fermentum convallis ligula. Donec luctus aliquet odio. Etiam ligula tortor, dictum eu, placerat eget, venenatis a, magna. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Etiam laoreet, libero et tristique pellentesque, tellus sem mollis dui, in sodales elit erat', '2018-02-15 16:30:34', '2017-05-03 18:35:26'),
(98, 93, 'amet luctus vulputate, nisi sem', 'Curabitur egestas nunc sed libero. Proin sed turpis nec mauris blandit mattis. Cras eget nisi dictum augue malesuada malesuada. Integer id magna et ipsum cursus vestibulum. Mauris magna. Duis dignissim tempor arcu. Vestibulum ut eros non enim commodo hendrerit. Donec porttitor tellus non magna. Nam ligula elit, pretium et, rutrum', '2018-02-27 11:45:09', '2018-04-07 00:00:08'),
(99, 94, 'Mauris vestibulum, neque sed dictum', 'ac sem ut dolor dapibus gravida. Aliquam tincidunt, nunc ac mattis ornare, lectus ante dictum mi, ac mattis velit justo nec ante. Maecenas mi felis, adipiscing fringilla, porttitor vulputate, posuere vulputate, lacus. Cras interdum. Nunc sollicitudin commodo ipsum. Suspendisse non leo. Vivamus nibh dolor, nonummy ac, feugiat non, lobortis quis,', '2018-03-13 05:16:45', '2017-08-30 16:48:54'),
(100, 95, 'Donec fringilla. Donec feugiat metus', 'consequat auctor, nunc nulla vulputate dui, nec tempus mauris erat eget ipsum. Suspendisse sagittis. Nullam vitae diam. Proin dolor. Nulla semper tellus id nunc interdum feugiat. Sed nec metus facilisis lorem tristique aliquet. Phasellus fermentum convallis ligula. Donec luctus aliquet odio. Etiam ligula tortor, dictum eu, placerat eget, venenatis a,', '2018-02-15 18:16:50', '2018-02-14 18:55:47'),
(101, 96, 'mauris blandit mattis. Cras eget', 'ipsum. Curabitur consequat, lectus sit amet luctus vulputate, nisi sem semper erat, in consectetuer ipsum nunc id enim. Curabitur massa. Vestibulum accumsan neque et nunc. Quisque ornare tortor at risus. Nunc ac sem ut dolor dapibus gravida. Aliquam tincidunt, nunc ac mattis ornare, lectus ante dictum mi, ac mattis velit', '2017-11-12 20:14:16', '2017-10-03 04:09:00'),
(102, 97, 'faucibus orci luctus et ultrices', 'massa. Integer vitae nibh. Donec est mauris, rhoncus id, mollis nec, cursus a, enim. Suspendisse aliquet, sem ut cursus luctus, ipsum leo elementum sem, vitae aliquam eros turpis non enim. Mauris quis turpis vitae purus gravida sagittis. Duis gravida. Praesent eu nulla at sem molestie sodales. Mauris blandit enim consequat', '2017-11-24 20:11:54', '2017-09-16 15:39:58'),
(103, 98, 'feugiat. Sed nec metus facilisis', 'eu dui. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean eget magna. Suspendisse tristique neque venenatis lacus. Etiam bibendum fermentum metus. Aenean sed pede nec ante blandit viverra. Donec tempus, lorem fringilla ornare placerat, orci lacus vestibulum lorem, sit amet ultricies sem magna nec quam.', '2017-07-06 19:11:27', '2017-09-26 14:50:19'),
(104, 99, 'dapibus gravida. Aliquam tincidunt, nunc', 'nibh. Phasellus nulla. Integer vulputate, risus a ultricies adipiscing, enim mi tempor lorem, eget mollis lectus pede et risus. Quisque libero lacus, varius et, euismod et, commodo at, libero. Morbi accumsan laoreet ipsum. Curabitur consequat, lectus sit amet luctus vulputate, nisi sem semper erat, in consectetuer ipsum nunc id enim.', '2017-06-30 03:22:47', '2018-03-30 02:11:25'),
(105, 100, 'ut, sem. Nulla interdum. Curabitur', 'ligula. Aenean gravida nunc sed pede. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Proin vel arcu eu odio tristique pharetra. Quisque ac libero nec ligula consectetuer rhoncus. Nullam velit dui, semper et, lacinia vitae, sodales at, velit. Pellentesque ultricies dignissim lacus. Aliquam rutrum lorem ac', '2017-09-10 20:02:16', '2017-10-02 02:28:40'),
(106, 101, 'luctus felis purus ac tellus.', 'a odio semper cursus. Integer mollis. Integer tincidunt aliquam arcu. Aliquam ultrices iaculis odio. Nam interdum enim non nisi. Aenean eget metus. In nec orci. Donec nibh. Quisque nonummy ipsum non arcu. Vivamus sit amet risus. Donec egestas. Aliquam nec enim. Nunc ut erat. Sed nunc est, mollis non, cursus', '2017-05-27 03:15:59', '2017-07-06 14:32:48'),
(107, 102, 'leo. Morbi neque tellus, imperdiet', 'lobortis tellus justo sit amet nulla. Donec non justo. Proin non massa non ante bibendum ullamcorper. Duis cursus, diam at pretium aliquet, metus urna convallis erat, eget tincidunt dui augue eu tellus. Phasellus elit pede, malesuada vel, venenatis vel, faucibus id, libero. Donec consectetuer mauris id sapien. Cras dolor dolor,', '2017-12-22 13:28:25', '2017-08-16 22:15:00'),
(108, 103, 'ipsum primis in faucibus orci', 'at, iaculis quis, pede. Praesent eu dui. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean eget magna. Suspendisse tristique neque venenatis lacus. Etiam bibendum fermentum metus. Aenean sed pede nec ante blandit viverra. Donec tempus, lorem fringilla ornare placerat, orci lacus vestibulum lorem, sit amet', '2017-09-09 06:54:27', '2017-08-25 05:36:17'),
(109, 104, 'mattis velit justo nec ante.', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Proin vel nisl. Quisque fringilla euismod enim. Etiam gravida molestie arcu. Sed eu nibh vulputate mauris sagittis placerat. Cras dictum ultricies ligula. Nullam enim. Sed nulla ante, iaculis nec, eleifend non, dapibus rutrum, justo. Praesent luctus. Curabitur egestas', '2018-04-25 04:37:19', '2017-10-24 22:39:14'),
(110, 105, 'ultrices sit amet, risus. Donec', 'turpis. In condimentum. Donec at arcu. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec tincidunt. Donec vitae erat vel pede blandit congue. In scelerisque scelerisque dui. Suspendisse ac metus vitae velit egestas lacinia. Sed congue, elit sed consequat auctor, nunc nulla vulputate dui, nec', '2017-07-13 13:33:57', '2017-07-23 02:56:58'),
(111, 106, 'vitae purus gravida sagittis. Duis', 'et magnis dis parturient montes, nascetur ridiculus mus. Aenean eget magna. Suspendisse tristique neque venenatis lacus. Etiam bibendum fermentum metus. Aenean sed pede nec ante blandit viverra. Donec tempus, lorem fringilla ornare placerat, orci lacus vestibulum lorem, sit amet ultricies sem magna nec quam. Curabitur vel lectus. Cum sociis natoque', '2017-12-29 11:08:43', '2017-06-30 14:41:22'),
(112, 110, 'test', 'test desc', '2017-04-27 08:46:14', '2017-05-12 08:46:14'),
(114, 110, 'test1', 'test3', '2017-04-27 08:46:43', '2017-05-12 08:46:43');

-- --------------------------------------------------------

--
-- Table structure for table `task_clicks`
--

DROP TABLE IF EXISTS `task_clicks`;
CREATE TABLE `task_clicks` (
  `user_id` int(11) UNSIGNED NOT NULL,
  `tag_id` int(11) UNSIGNED NOT NULL,
  `clicks` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `task_tags`
--

DROP TABLE IF EXISTS `task_tags`;
CREATE TABLE `task_tags` (
  `task_id` int(11) UNSIGNED NOT NULL,
  `tag_id` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) UNSIGNED NOT NULL,
  `email` varchar(128) NOT NULL,
  `first_name` varchar(128) NOT NULL,
  `last_name` varchar(128) DEFAULT NULL,
  `password` char(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `first_name`, `last_name`, `password`) VALUES
(5, 'a', 'A', 'A', '6655fb2f5eac6d590b81a02feb4d14b4f7bff0bf7640b582a6088508032def81'),
(6, 'b', 'B', 'B', 'bdb41bde7329173cacbd3d74e5323ae5726aa7af2c7f3446e2fdb95ff9bbd543'),
(62, 'ante.dictum.mi@QuisquevariusNam.net', 'Kasper', 'Anthony', 'PVX68EYN2WO'),
(63, 'quam.Curabitur@egetipsumDonec.co.uk', 'Merrill', 'Pruitt', 'APF55SNO9YI'),
(64, 'Integer@posuere.co.uk', 'Darius', 'Cash', 'LUB50TPA1II'),
(65, 'nisi.Aenean.eget@atlacusQuisque.co.uk', 'Kim', 'Pickett', 'JBC97IUZ0SL'),
(66, 'amet.ultricies.sem@iaculis.ca', 'Graham', 'Ramsey', 'SQA14HNL1LL'),
(67, 'dignissim.pharetra.Nam@et.com', 'Bell', 'Perkins', 'EOC68VTU3RG'),
(68, 'semper@euaugueporttitor.org', 'Ulysses', 'Mcfadden', 'CXX25DKS3QT'),
(69, 'et@Sed.edu', 'Aristotle', 'Molina', 'ONH98YHD5PT'),
(70, 'mollis.dui.in@libero.co.uk', 'Rhea', 'Maxwell', 'AHB51RDN5KQ'),
(71, 'Donec.nibh@Nullamscelerisque.com', 'Travis', 'Murphy', 'NHT54LJY7BP'),
(72, 'Nullam@bibendumsed.edu', 'Devin', 'Kerr', 'CGP18CEZ9AW'),
(73, 'sed.dui@nequeet.net', 'Yoko', 'Hines', 'GIE90VEG9OZ'),
(74, 'mauris.Suspendisse.aliquet@Nam.ca', 'Jaime', 'Graham', 'YHO69IRS7RV'),
(75, 'at@Innecorci.com', 'Marny', 'Glenn', 'AIQ07WNF7CZ'),
(76, 'id.blandit@fermentumfermentum.co.uk', 'Yolanda', 'Kaufman', 'NIX97EBJ6CQ'),
(77, 'libero@augueeu.edu', 'Gavin', 'Griffin', 'IEI69FSR9JI'),
(78, 'tortor@est.org', 'Felicia', 'Gibbs', 'UZU56UHP1JS'),
(79, 'mi.felis@doloregestas.com', 'Wyatt', 'Coleman', 'TEX77FHB6DJ'),
(80, 'amet.luctus.vulputate@iderat.edu', 'Ruby', 'Kim', 'SKE99OJB8YK'),
(81, 'in.sodales.elit@tempus.edu', 'Daniel', 'Downs', 'NQZ34COS6JL'),
(82, 'blandit.at.nisi@morbitristiquesenectus.com', 'Abigail', 'Hendricks', 'NPE89PSC4DY'),
(83, 'dictum.eu.eleifend@loremDonec.edu', 'Basia', 'Leonard', 'CLZ83PII9PW'),
(84, 'Cras.vehicula@nonlacinia.co.uk', 'Hu', 'Roman', 'VPP64WHL0DK'),
(85, 'mollis@nonenim.net', 'Roth', 'Castro', 'QSJ36OLL5HR'),
(86, 'mi.tempor.lorem@mattisornare.ca', 'Emma', 'Douglas', 'VOG75MCI8HW'),
(87, 'posuere.cubilia@Fuscemi.org', 'Stuart', 'Pate', 'KQN78IDO7RG'),
(88, 'mollis.lectus@molestie.net', 'Kasper', 'Blackburn', 'JCW04UXD6XK'),
(89, 'sed.tortor@adipiscingMaurismolestie.edu', 'Guinevere', 'Fox', 'DCY04FIF7YY'),
(90, 'Proin.nisl.sem@quama.net', 'Lenore', 'Greene', 'SIN39IRI1FU'),
(91, 'metus@faucibusorciluctus.com', 'Aubrey', 'Nielsen', 'YAY47PJD6VB'),
(92, 'mauris.id.sapien@leoinlobortis.co.uk', 'Lunea', 'Bailey', 'ZXC92JCE3JH'),
(93, 'scelerisque.dui@dictum.net', 'Velma', 'Gonzalez', 'ERX51AQF8BE'),
(94, 'convallis.dolor@risusMorbimetus.net', 'Rajah', 'Ware', 'BOF96SVY7DT'),
(95, 'egestas.ligula.Nullam@nectempusscelerisque.com', 'Wilma', 'Rice', 'WLL22TYL3HK'),
(96, 'euismod@congue.com', 'Philip', 'Frye', 'YDG52MSE1AP'),
(97, 'in.dolor@fermentumconvallisligula.com', 'Garrett', 'Farley', 'JKG34ASI0NH'),
(98, 'massa.Quisque@Vivamus.edu', 'Ezekiel', 'Duncan', 'KMX21GEA5KD'),
(99, 'quis.pede.Suspendisse@Duisdignissimtempor.org', 'Randall', 'Weber', 'LBM44YBL1LO'),
(100, 'Sed.eget.lacus@orciluctuset.org', 'Maya', 'Garner', 'QTG86MWI9YH'),
(101, 'vitae.aliquam@tincidunt.co.uk', 'Jessamine', 'Johnson', 'HOE51MJP5CX'),
(102, 'nibh.Aliquam.ornare@turpisNulla.ca', 'Gillian', 'Noel', 'BSQ96RQI9WO'),
(103, 'Morbi.sit.amet@tempordiamdictum.com', 'Noah', 'Terrell', 'SBS21VQS2LO'),
(104, 'Nam.nulla@sollicitudinorcisem.co.uk', 'Amela', 'Pollard', 'DOC02JSF9QS'),
(105, 'Phasellus.elit.pede@congueInscelerisque.ca', 'Aphrodite', 'Emerson', 'PAC15UYL7CA'),
(106, 'quis.diam@ut.org', 'Dustin', 'Mercado', 'UAX22GOS3VW'),
(107, 'test@dot.org', 'Jams', 'Odonnell', 'ac761cb4a9743524adc19e4767e188b9f7b08f439d4fa8db1143d65ecbdd3640'),
(108, 'j', 'J', 'J', '8a36c942939cddb7c48382ff038ced6c82898fccc3f98ffddca1921cb32e5495'),
(109, 'c', 'C', 'C', '612cc5b96e15ffcdc4ca47c3ef63806434e875015cea852863d2e7bf8dc5267e'),
(110, 'd', 'D', 'D', '066402182348c4b95e95e7d9e5be35d0989a0caa0f688af35cef982065b53caf'),
(111, 'e', 'E', 'E', 'd54d6c61f3ad603d3802a7fc3f9c6e11e8085c66c8b29311af58f2ac418d94fe');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `claimed_tasks`
--
ALTER TABLE `claimed_tasks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_tasks` (`task_id`,`user_id`),
  ADD UNIQUE KEY `fk_claimed_task` (`task_id`),
  ADD KEY `fk_task_claimer` (`user_id`);

--
-- Indexes for table `tags`
--
ALTER TABLE `tags`
  ADD PRIMARY KEY (`tag_id`);

--
-- Indexes for table `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_title_creator` (`title`,`publisher_id`),
  ADD KEY `fk_tasks_users` (`publisher_id`);

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
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_email` (`email`);

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
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=115;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=112;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `task_tags`
--
ALTER TABLE `task_tags`
  ADD CONSTRAINT `fk_tags_table` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`tag_id`),
  ADD CONSTRAINT `fk_tasks_table` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
