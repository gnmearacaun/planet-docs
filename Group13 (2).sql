-- phpMyAdmin SQL Dump
-- version 4.6.5.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 10, 2017 at 02:00 PM
-- Server version: 10.1.21-MariaDB
-- PHP Version: 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `group13`
--

-- --------------------------------------------------------

--
-- Table structure for table `completedtasks`
--

CREATE TABLE `completedtasks` (
  `Task_ID` smallint(6) NOT NULL,
  `User_ID` bigint(20) NOT NULL,
  `Completed` tinyint(1) NOT NULL,
  `Date_Completed` date NOT NULL,
  `Completed_By` bigint(20) NOT NULL,
  `Comments` text NOT NULL,
  `Sent` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `disciplines`
--

CREATE TABLE `disciplines` (
  `Discipline` varchar(40) NOT NULL,
  `Faculty` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `disciplines`
--

INSERT INTO `disciplines` (`Discipline`, `Faculty`) VALUES
('Midwifery', 'Education and Health Sciences'),
('Nursing (Intellectual Disability)', 'Education and Health Sciences'),
('Nursing (Mental Health)', 'Education and Health Sciences'),
('Psychology and Sociology', 'Education and Health Sciences'),
('Sport and Exercise Sciences', 'Education and Health Sciences'),
('Business Administration Executive', 'Kemmy Business School'),
('Business Studies', 'Kemmy Business School'),
('Computational Finance', 'Kemmy Business School'),
('Financial Mathematics', 'Kemmy Business School'),
('International Business', 'Kemmy Business School'),
('Law and Accounting', 'Kemmy Business School'),
('Technology Management', 'Kemmy Business School'),
('Biological and Chemical Sciences', 'Science and Engineering'),
('Chemical and Biochemical Engineering', 'Science and Engineering'),
('Computing Technologies', 'Science and Engineering'),
('Electronic and Computer Engineering', 'Science and Engineering'),
('Equine Science', 'Science and Engineering'),
('Food Science and Health', 'Science and Engineering'),
('Product Design and Technology', 'Science and Engineering'),
('Software Engineering', 'Science and Engineering');

-- --------------------------------------------------------

--
-- Table structure for table `expiredtasks`
--

CREATE TABLE `expiredtasks` (
  `Task_ID` smallint(6) NOT NULL,
  `User_ID` bigint(20) NOT NULL,
  `Date` date NOT NULL,
  `Expiry_Date` date NOT NULL,
  `Level` varchar(10) NOT NULL,
  `Task_Type` varchar(15) NOT NULL,
  `Discipline` varchar(40) NOT NULL,
  `Title` tinytext NOT NULL COMMENT 'Max 255 Characters',
  `Req_Words` smallint(6) NOT NULL,
  `Word_Count` smallint(6) NOT NULL,
  `Total_Pages` smallint(6) NOT NULL,
  `File_Format` varchar(12) NOT NULL,
  `Due_Date` date NOT NULL,
  `Due_Time` time NOT NULL,
  `Description` text NOT NULL,
  `Tag` text NOT NULL,
  `Claimed_By` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `faculties`
--

CREATE TABLE `faculties` (
  `Faculty` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `faculties`
--

INSERT INTO `faculties` (`Faculty`) VALUES
('Arts, Humanities and Social Sciences'),
('Education and Health Sciences'),
('Irish World Academy of Music and Dance'),
('Kemmy Business School'),
('Science and Engineering');

-- --------------------------------------------------------

--
-- Table structure for table `fileformats`
--

CREATE TABLE `fileformats` (
  `Format` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `fileformats`
--

INSERT INTO `fileformats` (`Format`) VALUES
('doc'),
('docx'),
('html'),
('Open Office'),
('pdf'),
('tex');

-- --------------------------------------------------------

--
-- Table structure for table `flaggedtasks`
--

CREATE TABLE `flaggedtasks` (
  `Task_ID` smallint(6) NOT NULL,
  `User_ID` bigint(20) NOT NULL,
  `Date` date NOT NULL,
  `Expiry_Date` date NOT NULL,
  `Level` varchar(10) NOT NULL,
  `Discipline` varchar(40) NOT NULL,
  `Task_Type` varchar(15) NOT NULL,
  `Title` tinytext NOT NULL COMMENT 'Max 255 Characters',
  `Req_Words` smallint(6) NOT NULL,
  `Word_Count` smallint(6) NOT NULL,
  `Total_Pages` smallint(6) NOT NULL,
  `File_Format` varchar(12) NOT NULL,
  `Due_Date` date NOT NULL,
  `Due_Time` time NOT NULL,
  `Description` text NOT NULL,
  `Tag` text NOT NULL,
  `Claimed_By` bigint(20) NOT NULL,
  `Flagged` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `levels`
--

CREATE TABLE `levels` (
  `Level` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `levels`
--

INSERT INTO `levels` (`Level`) VALUES
('BA'),
('BSc'),
('MA'),
('MSc'),
('PhD');

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `Staff_ID` mediumint(6) NOT NULL,
  `Surname` varchar(25) NOT NULL,
  `Forename` varchar(30) NOT NULL,
  `Faculty` varchar(40) NOT NULL,
  `Discipline` varchar(40) NOT NULL,
  `Email` varchar(40) NOT NULL,
  `Tel_No` varchar(16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`Staff_ID`, `Surname`, `Forename`, `Faculty`, `Discipline`, `Email`, `Tel_No`) VALUES
(5540867, 'Coughlan', 'Sonia', 'Science and Engineering', 'Software Engineering', 'sonia.coughlan@ul.ie', '086-666-8862'),
(5540982, 'Fell', 'Jason', 'Science and Engineering', 'Electronic and Computer Engineering', 'jason.fell@ul.ie', '087-229-8421'),
(5541765, 'O\'Driscoll', 'Briain', 'Kemmy Business School', 'Financial Mathematics', 'briain.odriscoll@ul.ie', '087-224-3799'),
(5542326, 'Noone', 'Niall', 'Kemmy Business School', 'Law and Accounting', 'niall.noone@ul.ie', '085-441-6628');

-- --------------------------------------------------------

--
-- Table structure for table `tasks`
--

CREATE TABLE `tasks` (
  `Task_ID` smallint(6) NOT NULL,
  `User_ID` bigint(20) NOT NULL,
  `Date` date NOT NULL,
  `Expiry_Date` date NOT NULL,
  `Task_Type` varchar(15) NOT NULL,
  `Title` tinytext NOT NULL COMMENT 'Max 255 Characters',
  `Req_Words` smallint(6) NOT NULL,
  `Word_Count` smallint(6) NOT NULL,
  `Total_Pages` smallint(6) NOT NULL,
  `File_Format` varchar(12) NOT NULL,
  `Due_Date` date NOT NULL,
  `Due_Time` time NOT NULL,
  `Description` text NOT NULL,
  `Tag` text NOT NULL,
  `Claimed_By` bigint(20) NOT NULL,
  `Flagged` tinyint(1) NOT NULL,
  `Completed` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tasks`
--

INSERT INTO `tasks` (`Task_ID`, `User_ID`, `Date`, `Expiry_Date`, `Task_Type`, `Title`, `Req_Words`, `Word_Count`, `Total_Pages`, `File_Format`, `Due_Date`, `Due_Time`, `Description`, `Tag`, `Claimed_By`, `Flagged`, `Completed`) VALUES
(1, 15183796, '2017-03-03', '0000-00-00', 'Assignment', 'Managing A Legal Accounts System', 2500, 2459, 6, 'doc', '2017-04-14', '17:30:00', 'Assignment looking at how legal accounts are managed - therefore contributing to calculating legal fees etc', 'Legal Fees\r\nManaging Accounts', 0, 0, 0),
(2, 16115224, '2017-03-03', '0000-00-00', 'Assignment', 'Implications of using Epidural during labour', 2500, 2573, 6, 'pdf', '2017-04-07', '14:00:00', 'Assignment looking at the use of Epidural and the implications of using it during labour', 'Epidural\r\nLabour', 0, 0, 0),
(3, 15181596, '2017-03-06', '0000-00-00', 'Research Paper', 'Comparison of different technologies used in the product design industry', 3000, 2792, 8, 'docx', '2017-04-21', '00:00:00', 'Research paper - researching the differences in technologies used in Ireland in different product design companies', 'Research paper\r\nTechnologies\r\nProduct design', 0, 0, 0),
(4, 15171798, '2017-03-06', '0000-00-00', 'Assignment', 'Restrictions encountered by computer users for people with dyslexia ', 3000, 2965, 9, 'docx', '2017-04-07', '17:00:00', 'This assignment looks at what tools can be made available to assist those with dyslexia, when using a computer or surfing the internet', 'Computers\r\nDisabilities\r\n', 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tasktypes`
--

CREATE TABLE `tasktypes` (
  `Task_Type` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `tasktypes`
--

INSERT INTO `tasktypes` (`Task_Type`) VALUES
('Assignment'),
('Dissertation'),
('Research Paper'),
('Thesis');

-- --------------------------------------------------------

--
-- Table structure for table `userinfo`
--

CREATE TABLE `userinfo` (
  `User_ID` bigint(20) NOT NULL,
  `User_Type` varchar(15) NOT NULL,
  `Surname` varchar(25) NOT NULL,
  `Forename` varchar(30) NOT NULL,
  `Discipline` varchar(40) NOT NULL,
  `Level` varchar(10) NOT NULL,
  `Current` tinyint(1) NOT NULL,
  `Email` varchar(35) NOT NULL,
  `Password1` varchar(45) NOT NULL,
  `Reputation` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `userinfo`
--

INSERT INTO `userinfo` (`User_ID`, `User_Type`, `Surname`, `Forename`, `Discipline`, `Level`, `Current`, `Email`, `Password1`, `Reputation`) VALUES
(15168841, 'Moderator', 'Carr', 'Shane', 'Electronic and Computer Engineering', 'MSc', 1, '15168841@stumail.ul.ie', '', 0),
(15171798, 'Student', 'Fitzpatrick', 'John', 'Computing Technologies', 'BSc', 1, '15171798stumail@ul.ie', '', 0),
(15181596, 'Student', 'O\'Callaghan', 'Michael', 'Product Design and Technology', 'BSc', 1, '15181896@stumail.ul.ie', '', 0),
(15183796, 'Student', 'Sexton', 'Thomas', 'Law and Accounting', 'BA', 1, '15183769stumail@ul.ie', '', 0),
(15186185, 'Student', 'O\'Mahoney', 'Geraldine', 'Nursing (Intellectual Disability)', 'BSc', 1, '15186185@stumail.ul.ie', '', 0),
(15196623, 'Moderator', 'Daly', 'Ciara', 'Nursing (Mental Health)', 'BSc', 1, '15196623stumail@ul.ie', '', 0),
(16113232, 'Moderator', 'Li', 'Nan', 'Chemical and Biochemical Engineering', 'MSc', 1, '16113232', '', 0),
(16115224, 'Student', 'Bartkowski', 'Katarzyna', 'Midwifery', 'BA', 1, '16115224@stumail.ul.ie', '', 0),
(16121516, 'Moderator', 'Matthews', 'George', 'Sport and Exercise Sciences', 'BSc', 1, '16121516@stumail.ul.ie', '', 0),
(16123234, 'Student', 'Michael', 'O\'Leary', 'Software Engineering', 'MSc', 1, '16123234@stumail.ul.ie', '', 0),
(16123555, 'Student', 'Moneke', 'Zviko', 'Psychology and Sociology', 'BSc', 1, '16123555@stumail.ul.ie', '', 0),
(16127959, 'Student', 'O\'Callaghan', 'Michael', 'Equine Science', 'BSc', 1, '16127959@stumail.ul.ie', '', 0),
(16131657, 'Student', 'Walters', 'David', 'Food Science and Health', 'BSc', 1, '16131657@stumail.ul.ie', '', 0),
(16142511, 'Student', 'Frawley', 'Cathal', 'Equine Science', 'BSc', 1, '16142511@stumail.ul.ie', '', 0),
(16144556, 'Moderator', 'Browne', 'Martin', 'Law and Accounting', 'MA', 1, '16144556@stumail.ul.ie', '', 0),
(16168941, 'Student', 'White', 'Mary', 'International Business', 'BA', 1, '16168941@stumail.ul.ie', '', 0),
(16172526, 'Student', 'Czech', 'Tomasz', 'International Business', 'BSc', 1, '16172526@stumail.ul.ie', '', 0),
(16172845, 'Student', 'O\'Donnell', 'Siobhan', 'Business Studies', 'BA', 1, '16172845@stumail.ul.ie', '', 0),
(16173145, 'Student', 'McCarthy', 'Daniel', 'Computing Technologies', 'BSc', 1, '16173145@stumail.ul.ie', '', 0),
(16181654, 'Student', 'O\'Gorman', 'Thomas', 'Law and Accounting', 'MA', 1, '16181654@stumail.ul.ie', '', 0),
(16186149, 'Student', 'Manley', 'Shannon', 'Nursing (Mental Health)', 'BSc', 1, '16186149@stumail.ul.ie', '', 0),
(16194543, 'Student', 'McCarthy', 'Shauna', 'Nursing (Mental Health)', 'BA', 1, '16194543@stumail.ul.ie', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `usertypes`
--

CREATE TABLE `usertypes` (
  `User_Type` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `usertypes`
--

INSERT INTO `usertypes` (`User_Type`) VALUES
('Moderator'),
('Student');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `completedtasks`
--
ALTER TABLE `completedtasks`
  ADD PRIMARY KEY (`Task_ID`,`User_ID`,`Completed`),
  ADD KEY `CompTID` (`Task_ID`),
  ADD KEY `CompTUID` (`User_ID`),
  ADD KEY `CompBy` (`Completed_By`);

--
-- Indexes for table `disciplines`
--
ALTER TABLE `disciplines`
  ADD PRIMARY KEY (`Discipline`),
  ADD KEY `Discipline` (`Discipline`),
  ADD KEY `FAC` (`Faculty`);

--
-- Indexes for table `expiredtasks`
--
ALTER TABLE `expiredtasks`
  ADD PRIMARY KEY (`Task_ID`),
  ADD KEY `UserId` (`User_ID`),
  ADD KEY `Level2` (`Level`),
  ADD KEY `TaskType` (`Task_Type`),
  ADD KEY `Discipline3` (`Discipline`),
  ADD KEY `FFormat` (`File_Format`),
  ADD KEY `Claimed_By` (`Claimed_By`),
  ADD KEY `Task_ID` (`Task_ID`);

--
-- Indexes for table `faculties`
--
ALTER TABLE `faculties`
  ADD PRIMARY KEY (`Faculty`);

--
-- Indexes for table `fileformats`
--
ALTER TABLE `fileformats`
  ADD PRIMARY KEY (`Format`);

--
-- Indexes for table `flaggedtasks`
--
ALTER TABLE `flaggedtasks`
  ADD PRIMARY KEY (`Task_ID`),
  ADD KEY `UserId` (`User_ID`),
  ADD KEY `Level2` (`Level`),
  ADD KEY `TaskType` (`Task_Type`),
  ADD KEY `Discipline3` (`Discipline`),
  ADD KEY `FFormat` (`File_Format`),
  ADD KEY `Claimed_By` (`Claimed_By`);

--
-- Indexes for table `levels`
--
ALTER TABLE `levels`
  ADD PRIMARY KEY (`Level`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`Staff_ID`),
  ADD KEY `Discipline` (`Discipline`),
  ADD KEY `Faculty` (`Faculty`);

--
-- Indexes for table `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`Task_ID`),
  ADD KEY `UserId` (`User_ID`),
  ADD KEY `TaskType` (`Task_Type`),
  ADD KEY `FFormat` (`File_Format`),
  ADD KEY `Claimed_By` (`Claimed_By`);

--
-- Indexes for table `tasktypes`
--
ALTER TABLE `tasktypes`
  ADD PRIMARY KEY (`Task_Type`);

--
-- Indexes for table `userinfo`
--
ALTER TABLE `userinfo`
  ADD PRIMARY KEY (`User_ID`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD KEY `Discipline2` (`Discipline`),
  ADD KEY `Level` (`Level`),
  ADD KEY `User_Type` (`User_Type`);

--
-- Indexes for table `usertypes`
--
ALTER TABLE `usertypes`
  ADD PRIMARY KEY (`User_Type`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `flaggedtasks`
--
ALTER TABLE `flaggedtasks`
  MODIFY `Task_ID` smallint(6) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tasks`
--
ALTER TABLE `tasks`
  MODIFY `Task_ID` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `disciplines`
--
ALTER TABLE `disciplines`
  ADD CONSTRAINT `disciplines_ibfk_1` FOREIGN KEY (`Faculty`) REFERENCES `faculties` (`Faculty`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `expiredtasks`
--
ALTER TABLE `expiredtasks`
  ADD CONSTRAINT `expiredtasks_ibfk_1` FOREIGN KEY (`Task_ID`) REFERENCES `tasks` (`Task_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `staff`
--
ALTER TABLE `staff`
  ADD CONSTRAINT `staff_ibfk_1` FOREIGN KEY (`Discipline`) REFERENCES `disciplines` (`Discipline`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `staff_ibfk_2` FOREIGN KEY (`Faculty`) REFERENCES `faculties` (`Faculty`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tasks`
--
ALTER TABLE `tasks`
  ADD CONSTRAINT `tasks_ibfk_1` FOREIGN KEY (`Task_Type`) REFERENCES `tasktypes` (`Task_Type`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tasks_ibfk_2` FOREIGN KEY (`File_Format`) REFERENCES `fileformats` (`Format`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `userinfo`
--
ALTER TABLE `userinfo`
  ADD CONSTRAINT `userinfo_ibfk_1` FOREIGN KEY (`Discipline`) REFERENCES `disciplines` (`Discipline`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `userinfo_ibfk_2` FOREIGN KEY (`User_Type`) REFERENCES `usertypes` (`User_Type`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `userinfo_ibfk_3` FOREIGN KEY (`Level`) REFERENCES `levels` (`Level`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
