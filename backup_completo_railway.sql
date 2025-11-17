-- MySQL dump 10.13  Distrib 8.0.43, for Linux (x86_64)
--
-- Host: localhost    Database: db_pousada
-- ------------------------------------------------------
-- Server version	8.0.43-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `hospedes`
--

DROP TABLE IF EXISTS `hospedes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hospedes` (
  `id_hospede` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `senha` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_hospede`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hospedes`
--

LOCK TABLES `hospedes` WRITE;
/*!40000 ALTER TABLE `hospedes` DISABLE KEYS */;
INSERT INTO `hospedes` VALUES (1,'Administrador Principal','(47) 99999-0000','admin@pousada.com','$2a$10$lY4VR84uk9mFsF8Bfoj9ve3HhIW/alV/zyf1PM3S6fb1/ARcOZArS'),(4,'cris','(47) 9345-6789','Cris@pousada.com','$2a$10$s0zCLuRY0CxAhga.8lY.Kupnr7XkCz4ByfHG0CS.Cv7ax0ATUokP.'),(5,'larissa','(47)991688881','larisa@gmail.com','$2a$10$tuagoMdz.52BfcRQily8Kuwu954oz6Ai0ANMoQFtw0OD.0KtxFON2');
/*!40000 ALTER TABLE `hospedes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagamentos`
--

DROP TABLE IF EXISTS `pagamentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagamentos` (
  `id_pagamento` int NOT NULL AUTO_INCREMENT,
  `id_reserva` int NOT NULL,
  `valor_pago` decimal(10,2) NOT NULL,
  `metodo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `data_pagamento` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pagamento`),
  KEY `id_reserva` (`id_reserva`),
  CONSTRAINT `pagamentos_ibfk_1` FOREIGN KEY (`id_reserva`) REFERENCES `reservas` (`id_reserva`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagamentos`
--

LOCK TABLES `pagamentos` WRITE;
/*!40000 ALTER TABLE `pagamentos` DISABLE KEYS */;
INSERT INTO `pagamentos` VALUES (1,4,180.00,'PIX','2025-11-12 03:00:00'),(2,5,1120.00,'PIX','2025-11-12 03:00:00');
/*!40000 ALTER TABLE `pagamentos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quartos`
--

DROP TABLE IF EXISTS `quartos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quartos` (
  `id_quarto` int NOT NULL AUTO_INCREMENT,
  `numero` int NOT NULL,
  `tipo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descricao` text COLLATE utf8mb4_unicode_ci,
  `preco_diaria` decimal(10,2) NOT NULL,
  `capacidade_maxima` int NOT NULL,
  `disponivel` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_quarto`),
  UNIQUE KEY `numero` (`numero`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quartos`
--

LOCK TABLES `quartos` WRITE;
/*!40000 ALTER TABLE `quartos` DISABLE KEYS */;
INSERT INTO `quartos` VALUES (1,101,'Quarto Vista Mar','Quarto com vista para o oceano.',280.00,4,1),(2,102,'Quarto Standard','Quarto confortável e aconchegante\r\n\r\nUm quarto confortável e acolhedor\r\n\r\nQuarto aconchegante e bem confortável',180.00,3,1),(4,103,'Suíte Família','Suíte ampla com dois quartos interligados, ideal para famílias. Acomoda até 6 pessoas.\r\n\r\n',450.00,6,1);
/*!40000 ALTER TABLE `quartos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservas`
--

DROP TABLE IF EXISTS `reservas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservas` (
  `id_reserva` int NOT NULL AUTO_INCREMENT,
  `id_hospede` int NOT NULL,
  `id_quarto` int NOT NULL,
  `data_checkin` date NOT NULL,
  `data_checkout` date NOT NULL,
  `num_adultos` int NOT NULL,
  `num_criancas` int NOT NULL DEFAULT '0',
  `valor_total` decimal(10,2) NOT NULL,
  `status` enum('PENDENTE','CONFIRMADA','CANCELADA') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDENTE',
  `data_reserva` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_reserva`),
  KEY `id_hospede` (`id_hospede`),
  KEY `id_quarto` (`id_quarto`),
  CONSTRAINT `reservas_ibfk_1` FOREIGN KEY (`id_hospede`) REFERENCES `hospedes` (`id_hospede`) ON DELETE CASCADE,
  CONSTRAINT `reservas_ibfk_2` FOREIGN KEY (`id_quarto`) REFERENCES `quartos` (`id_quarto`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservas`
--

LOCK TABLES `reservas` WRITE;
/*!40000 ALTER TABLE `reservas` DISABLE KEYS */;
INSERT INTO `reservas` VALUES (1,4,1,'2025-11-13','2025-11-17',1,0,1120.00,'PENDENTE','2025-11-12 05:01:54'),(2,4,2,'2025-11-13','2025-11-20',1,0,1260.00,'PENDENTE','2025-11-12 05:15:12'),(3,5,1,'2025-11-27','2025-11-29',1,1,560.00,'PENDENTE','2025-11-12 05:49:25'),(4,5,2,'2025-11-29','2025-11-30',1,0,180.00,'CONFIRMADA','2025-11-12 06:06:36'),(5,4,1,'2025-12-12','2025-12-16',1,1,1120.00,'CONFIRMADA','2025-11-12 13:15:23');
/*!40000 ALTER TABLE `reservas` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-16 22:20:06
