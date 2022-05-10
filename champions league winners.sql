-- --------------------------------------------------------
-- Host:                         hopper.wlu.ca
-- Server version:               8.0.29 - MySQL Community Server - GPL
-- Server OS:                    Linux
-- HeidiSQL Version:             11.2.0.6213
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for dann4440
CREATE DATABASE IF NOT EXISTS `dann4440` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `dann4440`;

-- Dumping structure for function dann4440.average_minutes_per_goal
DELIMITER //
CREATE FUNCTION `average_minutes_per_goal`(minutes_played int, goals int) RETURNS int
BEGIN
    DECLARE mpg DECIMAL(10,2);
    SET mpg = minutes_played/goals;
RETURN mpg;
END//
DELIMITER ;

-- Dumping structure for table dann4440.champions_league_winner
CREATE TABLE IF NOT EXISTS `champions_league_winner` (
  `game_year` datetime NOT NULL,
  `location` varchar(45) NOT NULL,
  `winning_team_id` int NOT NULL,
  PRIMARY KEY (`game_year`,`location`),
  KEY `winning_team_id_idx` (`winning_team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for view dann4440.champions_league_winning_players
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `champions_league_winning_players` (
	`first_name` VARCHAR(45) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`last_name` VARCHAR(45) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`goals_in_season` INT(10) NULL,
	`team_name` VARCHAR(45) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`game_year` DATETIME NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for procedure dann4440.insert_champions_league_winner
DELIMITER //
CREATE PROCEDURE `insert_champions_league_winner`(IN game_time DATETIME,  IN location VARCHAR(45), IN winning_id INT)
BEGIN
	INSERT INTO champions_league_winner VALUES (game_time,location,winning_id);
END//
DELIMITER ;

-- Dumping structure for table dann4440.league
CREATE TABLE IF NOT EXISTS `league` (
  `league_name` varchar(45) NOT NULL,
  `league_location` varchar(45) NOT NULL,
  `date_established` date NOT NULL,
  `team_count` int NOT NULL,
  PRIMARY KEY (`league_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table dann4440.manager
CREATE TABLE IF NOT EXISTS `manager` (
  `manager_id` int NOT NULL AUTO_INCREMENT,
  `last_name` varchar(45) NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `team_id` int NOT NULL,
  `nationality` varchar(45) NOT NULL,
  PRIMARY KEY (`manager_id`),
  KEY `team_id_idx` (`team_id`),
  CONSTRAINT `manager_team_id` FOREIGN KEY (`team_id`) REFERENCES `team` (`team_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table dann4440.player
CREATE TABLE IF NOT EXISTS `player` (
  `player_id` int NOT NULL AUTO_INCREMENT,
  `last_name` varchar(45) NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `position` char(2) NOT NULL,
  `goals_in_season` int DEFAULT '0',
  `minutes_played` int DEFAULT NULL,
  `height` decimal(10,2) DEFAULT NULL,
  `dob` date NOT NULL,
  `date_signed` datetime NOT NULL,
  `address` longtext,
  `nationality` varchar(45) NOT NULL,
  `team_id` int NOT NULL,
  `played_until` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`player_id`),
  KEY `team_id_idx` (`team_id`),
  KEY `index_full_name` (`last_name`,`first_name`),
  CONSTRAINT `team_id` FOREIGN KEY (`team_id`) REFERENCES `team` (`team_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table dann4440.stadium
CREATE TABLE IF NOT EXISTS `stadium` (
  `stadium_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `location` varchar(45) NOT NULL,
  `capacity` int NOT NULL DEFAULT '37559',
  `owner` varchar(45) NOT NULL,
  PRIMARY KEY (`stadium_id`),
  UNIQUE KEY `index_owner` (`owner`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table dann4440.team
CREATE TABLE IF NOT EXISTS `team` (
  `team_id` int NOT NULL AUTO_INCREMENT,
  `team_name` varchar(45) NOT NULL,
  `league_name` varchar(45) NOT NULL,
  `date_established` date NOT NULL,
  `stadium_id` int NOT NULL,
  PRIMARY KEY (`team_id`),
  KEY `league_name_idx` (`league_name`),
  KEY `stadium_id_idx` (`stadium_id`),
  CONSTRAINT `league_name` FOREIGN KEY (`league_name`) REFERENCES `league` (`league_name`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `stadium_id` FOREIGN KEY (`stadium_id`) REFERENCES `stadium` (`stadium_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for view dann4440.team_league
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `team_league` (
	`team_name` VARCHAR(45) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`date_team_established` DATE NOT NULL,
	`league_name` VARCHAR(45) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`date_league_established` DATE NULL
) ENGINE=MyISAM;

-- Dumping structure for trigger dann4440.player_BEFORE_INSERT
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `player_BEFORE_INSERT` BEFORE INSERT ON `player` FOR EACH ROW BEGIN
	IF NEW.goals_in_season<0 THEN 
    SIGNAL SQLSTATE '45000'
    SET message_text = 'Goals cannot be negative';
    END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for view dann4440.champions_league_winning_players
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `champions_league_winning_players`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `champions_league_winning_players` AS select `P`.`first_name` AS `first_name`,`P`.`last_name` AS `last_name`,`P`.`goals_in_season` AS `goals_in_season`,`T`.`team_name` AS `team_name`,`C`.`game_year` AS `game_year` from ((`player` `P` join `team` `T` on((`P`.`team_id` = `T`.`team_id`))) join `champions_league_winner` `C` on((`T`.`team_id` = `C`.`winning_team_id`))) where (`C`.`game_year` between `P`.`date_signed` and `P`.`played_until`);

-- Dumping structure for view dann4440.team_league
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `team_league`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `team_league` AS select `T`.`team_name` AS `team_name`,`T`.`date_established` AS `date_team_established`,`L`.`league_name` AS `league_name`,`L`.`date_established` AS `date_league_established` from (`team` `T` left join `league` `L` on((`T`.`league_name` = `L`.`league_name`)));


-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema

-- Dumping database structure for information_schema
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
