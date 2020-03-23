-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Oct 27, 2017 at 09:02 PM
-- Server version: 5.6.34-log
-- PHP Version: 7.1.5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `petz`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `crearZombie` (IN `nom` VARCHAR(50), IN `apeP` VARCHAR(50), IN `apeM` VARCHAR(50), IN `idE` INT(8))  BEGIN
	DECLARE nombre VARCHAR(50) DEFAULT 'nombre';
	DECLARE apellidoP VARCHAR(50) DEFAULT 'apellido paterno';
	DECLARE apellidoM VARCHAR(50) DEFAULT 'apellido materno';
	DECLARE idEstado NUMERIC(8) DEFAULT 0;
	DECLARE idZombie NUMERIC(8) DEFAULT 0;
	SET nombre = nom;
	SET apellidoP = apeP;
	SET apellidoM = apeM;
	SET idEstado = idE;
    INSERT INTO zombie (nombre, apellidoP, apellidoM) VALUES(nombre, apellidoP, apellidoM);
	SET idZombie = (SELECT MAX(idZombie) FROM zombie);
	INSERT INTO tiene (idZombie, idEstado) VALUES(idZombie, idEstado);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `estado`
--

CREATE TABLE `estado` (
  `idEstado` int(8) NOT NULL,
  `nombreEstado` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `estado`
--

INSERT INTO `estado` (`idEstado`, `nombreEstado`) VALUES
(1, 'Infección'),
(2, 'Coma'),
(3, 'Transformación'),
(4, 'Completamente muerto');

-- --------------------------------------------------------

--
-- Table structure for table `tiene`
--

CREATE TABLE `tiene` (
  `idZombie` int(8) NOT NULL,
  `idEstado` int(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tiene`
--

INSERT INTO `tiene` (`idZombie`, `idEstado`) VALUES
(1, 2),
(2, 3),
(3, 3),
(4, 1),
(5, 2),
(6, 4),
(7, 4),
(8, 2),
(9, 4),
(10, 2);

-- --------------------------------------------------------

--
-- Table structure for table `zombie`
--

CREATE TABLE `zombie` (
  `idZombie` int(8) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellidoP` varchar(50) NOT NULL,
  `apellidoM` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `zombie`
--

INSERT INTO `zombie` (`idZombie`, `nombre`, `apellidoP`, `apellidoM`) VALUES
(1, 'Barb', 'Perez', 'Sosa'),
(2, 'asdf', 'fdsa', 'fdsa'),
(3, 'sdakjfdsj', 'nfsdljfsd', 'fdsaf'),
(4, 'boi', 'loi', 'toi'),
(5, 'oiunb', 'lskdoi', 'jdifnañ'),
(6, 'Ricardo', 'Estrada', 'Cardón'),
(7, 'Rodrigo', 'Torres', 'Torres'),
(8, 'asdf', 'asdfga', 'sadgfweva'),
(9, 'asñjdfñljnshdf', 'poijojknlksdjnf', 'asdñoiavasdv'),
(10, 'ñkljandfñvakjsdfnv', 'asodigfjalksjvn', 'asodvijaosdnvañosidvna');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `estado`
--
ALTER TABLE `estado`
  ADD PRIMARY KEY (`idEstado`);

--
-- Indexes for table `tiene`
--
ALTER TABLE `tiene`
  ADD KEY `fk_idZombie` (`idZombie`),
  ADD KEY `fk_idEstado` (`idEstado`);

--
-- Indexes for table `zombie`
--
ALTER TABLE `zombie`
  ADD PRIMARY KEY (`idZombie`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `estado`
--
ALTER TABLE `estado`
  MODIFY `idEstado` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `zombie`
--
ALTER TABLE `zombie`
  MODIFY `idZombie` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `tiene`
--
ALTER TABLE `tiene`
  ADD CONSTRAINT `fk_idEstado` FOREIGN KEY (`idEstado`) REFERENCES `estado` (`idEstado`),
  ADD CONSTRAINT `fk_idZombie` FOREIGN KEY (`idZombie`) REFERENCES `zombie` (`idZombie`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
