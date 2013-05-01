CREATE DATABASE openmrs
DEFAULT CHARACTER SET utf8
DEFAULT COLLATE utf8_general_ci;

use openmrs;

CREATE TABLE `liquibasechangelog` (
			  `ID` varchar(63) NOT NULL,
			  `AUTHOR` varchar(63) NOT NULL,
			  `FILENAME` varchar(200) NOT NULL,
			  `DATEEXECUTED` datetime NOT NULL,
			  `MD5SUM` varchar(32) DEFAULT NULL,
			  `DESCRIPTION` varchar(255) DEFAULT NULL,
			  `COMMENTS` varchar(255) DEFAULT NULL,
			  `TAG` varchar(255) DEFAULT NULL,
			  `LIQUIBASE` varchar(10) DEFAULT NULL,
			  `EXECTYPE` varchar(20) DEFAULT NULL,
			  `ORDEREXECUTED` varchar(20) DEFAULT NULL,
			  PRIMARY KEY (`ID`,`AUTHOR`,`FILENAME`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;