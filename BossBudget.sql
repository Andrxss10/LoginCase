-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: bossbudget
-- ------------------------------------------------------
-- Server version	8.0.34

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `creditos`
--

DROP TABLE IF EXISTS `creditos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `creditos` (
  `idCreditos` int NOT NULL,
  `idPresupuesto` int NOT NULL,
  `RangoInicial` date DEFAULT NULL,
  `RangoFinal` date DEFAULT NULL,
  `MontoTotal` decimal(10,0) DEFAULT NULL,
  `idTipoDeCredito` int NOT NULL,
  PRIMARY KEY (`idCreditos`),
  KEY `idPresupuesto` (`idPresupuesto`),
  KEY `idTipoDeCredito` (`idTipoDeCredito`),
  CONSTRAINT `creditos_ibfk_1` FOREIGN KEY (`idPresupuesto`) REFERENCES `presupuesto` (`idPresupuesto`),
  CONSTRAINT `creditos_ibfk_2` FOREIGN KEY (`idTipoDeCredito`) REFERENCES `tipodecredito` (`idTipoDeCredito`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `creditos`
--

LOCK TABLES `creditos` WRITE;
/*!40000 ALTER TABLE `creditos` DISABLE KEYS */;
INSERT INTO `creditos` VALUES (1,1,'2021-03-07','2025-01-01',5000,1),(2,2,'2020-12-06','2026-02-01',10000,2),(3,3,'2023-08-05','2027-03-01',7500,3),(4,4,'2018-09-04','2028-04-01',12500,4),(5,5,'2003-07-03','2029-05-01',15000,5),(6,6,'2021-05-02','2030-06-01',17500,6),(7,7,'2019-01-01','2031-07-01',20000,7);
/*!40000 ALTER TABLE `creditos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cuentas`
--

DROP TABLE IF EXISTS `cuentas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cuentas` (
  `idCuentas` int NOT NULL,
  `Banco` text,
  `Monto` decimal(10,0) DEFAULT NULL,
  `idPresupuesto` int NOT NULL,
  PRIMARY KEY (`idCuentas`),
  KEY `idPresupuesto` (`idPresupuesto`),
  CONSTRAINT `cuentas_ibfk_1` FOREIGN KEY (`idPresupuesto`) REFERENCES `presupuesto` (`idPresupuesto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cuentas`
--

LOCK TABLES `cuentas` WRITE;
/*!40000 ALTER TABLE `cuentas` DISABLE KEYS */;
INSERT INTO `cuentas` VALUES (1,'Banco A',5000,1),(2,'Banco B',10000,2),(3,'Banco C',15000,3),(4,'Banco D',20000,4),(5,'Banco E',25000,5),(6,'Banco F',30000,6),(7,'Banco G',35000,7);
/*!40000 ALTER TABLE `cuentas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detallepresupuesto`
--

DROP TABLE IF EXISTS `detallepresupuesto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detallepresupuesto` (
  `idPresupuesto` int DEFAULT NULL,
  `idDetalle` int NOT NULL AUTO_INCREMENT,
  `categoria` varchar(50) DEFAULT NULL,
  `tipo_movimiento` enum('Ingreso','Gasto') NOT NULL,
  `destino` enum('presupuestado','real') NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`idDetalle`),
  KEY `idPresupuesto` (`idPresupuesto`),
  CONSTRAINT `fk_detallepresupuesto_presupuesto` FOREIGN KEY (`idPresupuesto`) REFERENCES `presupuesto` (`idPresupuesto`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detallepresupuesto`
--

LOCK TABLES `detallepresupuesto` WRITE;
/*!40000 ALTER TABLE `detallepresupuesto` DISABLE KEYS */;
INSERT INTO `detallepresupuesto` VALUES (NULL,1,'Casa','Ingreso','presupuestado',4545454.00,'2025-06-30','2025-08-07','Soplete'),(NULL,2,'Casa','Ingreso','presupuestado',444444.00,'2025-06-26','2025-06-26','_0hDream'),(NULL,3,'Casa','Ingreso','presupuestado',0.05,'2025-06-18','2025-07-06','_0hDream'),(9,4,'Casa','Ingreso','presupuestado',484752.00,'2025-06-24','2025-07-06','Tuki tuki'),(10,5,'Casa','Ingreso','presupuestado',55555.00,'2025-06-25','2025-08-15','Soplete'),(11,6,'Trabajo','Ingreso','presupuestado',487888.00,'2025-06-03','2025-06-24','Soplete'),(12,7,'CHUPETICO','Ingreso','presupuestado',100000.00,'2025-06-17','2025-06-10','sirve porfavor :c'),(13,8,'Comida','Ingreso','presupuestado',8888888.00,'2025-06-09','2025-06-22','Tuki tuki'),(14,9,'Casa','Ingreso','presupuestado',1500.00,'2025-06-24','2025-06-28','Prueba'),(15,10,'Casa','Ingreso','presupuestado',4444444.00,'2025-07-02','2025-07-05','nice'),(16,11,'Comida','Ingreso','presupuestado',99999999.00,'2025-06-04','2025-06-30','sirve porfavor :c'),(17,12,'Casa','Ingreso','presupuestado',658714.00,'2025-06-11','2025-06-27','pruebuki'),(18,13,'Casa','Ingreso','presupuestado',540000.00,'2025-06-12','2025-06-15','EJ: VIAJE A CARTAGENa'),(19,14,'Viaje','Ingreso','presupuestado',600000.00,'2025-06-20','2025-06-24','Viaje de tres días'),(20,15,'Casa','Ingreso','presupuestado',412001.00,'2025-06-19','2025-06-18','Tuki tuki'),(22,16,'Casa','Ingreso','presupuestado',7777.00,'2025-06-20','2025-06-28','Soplete'),(23,17,'Casa','Ingreso','presupuestado',570000.00,'2025-06-19','2025-07-06','prueba porfavor'),(24,18,'Casa','Ingreso','presupuestado',210000.00,'2025-06-11','2025-07-06','Tuki tuki LuLu'),(25,19,'Casa','Ingreso','presupuestado',1000000.00,'2004-09-06','2025-06-06','vamos?'),(26,20,'Casa','Ingreso','presupuestado',100000.00,'2025-06-24','2025-07-01','prueba'),(27,21,'Trabajo','Ingreso','presupuestado',4444.00,'2025-06-22','2025-07-01','Soplete'),(28,22,'Casa','Ingreso','presupuestado',320000.00,'2025-06-18','2025-06-27','sirve porfavor :c'),(29,23,'Casa','Ingreso','presupuestado',15000.00,'2025-06-11','2025-06-26','ya casi :D'),(30,24,'Casa','Ingreso','presupuestado',15000.00,'2025-07-02','2025-07-05','viajesito'),(31,25,'Casa','Ingreso','presupuestado',1500.00,'2025-06-18','2025-07-05','viaje a cartagena'),(32,26,'Trabajo','Ingreso','presupuestado',150000.00,'2025-06-26','2025-06-29','ej: viaje a cartagenA'),(33,27,'Trabajo','Ingreso','presupuestado',1500.00,'2025-06-26','2025-07-06','Soplete'),(34,28,'Comida','Ingreso','presupuestado',1500.00,'2025-06-09','2025-07-03','prueba navideña'),(35,29,'Casa','Ingreso','presupuestado',1010.00,'2025-06-02','2025-06-02','almojabanas'),(36,30,'Comida','Ingreso','presupuestado',4444.00,'2025-07-02','2025-07-05','_0hDream'),(37,31,'Trabajo','Ingreso','presupuestado',758021.00,'2025-07-11','2025-07-26','Tuki tuki lululito'),(42,35,'Casa','Ingreso','presupuestado',1500.00,'2025-07-22','2025-08-09','vamosh'),(44,37,'Casa','Ingreso','presupuestado',15000000.20,'2025-07-20','2025-07-03','viaje a medellin');
/*!40000 ALTER TABLE `detallepresupuesto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gastos`
--

DROP TABLE IF EXISTS `gastos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gastos` (
  `idGastos` int NOT NULL AUTO_INCREMENT,
  `idPresupuesto` int NOT NULL,
  `FechaDeRegistro` date DEFAULT NULL,
  `Monto` decimal(10,0) DEFAULT NULL,
  `TipoDeMonto` enum('Efectivo','Tarjeta Debito','Tarjeta credito','Cheque','Billeteras virtuales') DEFAULT NULL,
  `Descripcion` text,
  `TipoDeMontoDetalle` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`idGastos`),
  KEY `idPresupuesto` (`idPresupuesto`),
  CONSTRAINT `fk_gastos_presupuesto` FOREIGN KEY (`idPresupuesto`) REFERENCES `presupuesto` (`idPresupuesto`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gastos`
--

LOCK TABLES `gastos` WRITE;
/*!40000 ALTER TABLE `gastos` DISABLE KEYS */;
INSERT INTO `gastos` VALUES (1,1,'2021-01-02',8441,'Efectivo',NULL,NULL),(2,2,'2022-02-04',98754,'Tarjeta credito',NULL,NULL),(3,3,'2023-03-06',56487,'Cheque',NULL,NULL),(4,4,'2024-04-08',454874,'Cheque',NULL,NULL),(5,5,'2025-05-10',198783,'Efectivo',NULL,NULL),(6,6,'2026-06-12',457774,'Billeteras virtuales',NULL,NULL),(7,7,'2027-07-14',56330,'Cheque',NULL,NULL),(8,32,'2025-06-22',47850,'Billeteras virtuales','gasolina',NULL),(9,33,'2025-06-22',888888,'Efectivo','galocha',NULL),(10,35,'2025-05-27',100,'Efectivo','supermarket',NULL),(24,44,'2025-07-18',15000,'Efectivo','ddddddddd',NULL),(26,44,'2025-07-18',1300000,'Efectivo','dads',NULL),(38,44,'2025-07-21',185000,'Efectivo','diez porciento',NULL);
/*!40000 ALTER TABLE `gastos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ingresos`
--

DROP TABLE IF EXISTS `ingresos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ingresos` (
  `idIngresos` int NOT NULL AUTO_INCREMENT,
  `idPresupuesto` int NOT NULL,
  `FechaDeRegistro` date DEFAULT NULL,
  `Monto` decimal(10,0) DEFAULT NULL,
  `TipoDeMonto` enum('Efectivo','Tarjeta Debito','Tarjeta credito','Cheque','Billeteras virtuales') DEFAULT NULL,
  `Descripcion` text,
  `TipoDeMontoDetalle` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`idIngresos`),
  KEY `idPresupuesto` (`idPresupuesto`),
  CONSTRAINT `fk_ingresos_presupuesto` FOREIGN KEY (`idPresupuesto`) REFERENCES `presupuesto` (`idPresupuesto`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingresos`
--

LOCK TABLES `ingresos` WRITE;
/*!40000 ALTER TABLE `ingresos` DISABLE KEYS */;
INSERT INTO `ingresos` VALUES (1,1,'2021-01-02',465451,'Efectivo',NULL,NULL),(2,2,'2022-02-04',8971,'Tarjeta credito',NULL,NULL),(3,3,'2023-03-06',5477,'Cheque',NULL,NULL),(4,4,'2024-04-08',97000,'Efectivo',NULL,NULL),(5,5,'2025-05-10',14547,'Cheque',NULL,NULL),(6,6,'2026-06-12',99700,'Billeteras virtuales',NULL,NULL),(7,7,'2027-07-14',3421,'Tarjeta credito',NULL,NULL),(8,31,'2025-06-22',5700,'Efectivo','pago de cliente',NULL),(9,32,'2025-06-22',4870,'Tarjeta credito','EJ: pago de cliente',NULL),(11,33,'2025-06-22',978700,'Billeteras virtuales','venticas',NULL),(12,34,'2025-06-22',458710,'Tarjeta credito','ventitis',NULL),(13,34,'2025-05-27',5678712,'Billeteras virtuales','tuti tuki lulu',NULL),(15,35,'2025-07-06',500,'Billeteras virtuales','tuki tuki',NULL),(16,42,'2025-07-11',4000,'Efectivo','sopletico',NULL),(17,44,'2026-07-18',5000000,'Cheque','Venta de producto inicial',NULL),(18,44,'2025-07-18',4444,'Efectivo','Probemos',NULL),(19,44,'2025-07-18',4444,'Efectivo','asd',NULL);
/*!40000 ALTER TABLE `ingresos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagodecredito`
--

DROP TABLE IF EXISTS `pagodecredito`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagodecredito` (
  `idPagoDeCredito` int NOT NULL,
  `TipoDePago` varchar(50) DEFAULT NULL,
  `idCreditos` int NOT NULL,
  `AccionRealizada` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idPagoDeCredito`),
  KEY `idCreditos` (`idCreditos`),
  CONSTRAINT `pagodecredito_ibfk_1` FOREIGN KEY (`idCreditos`) REFERENCES `creditos` (`idCreditos`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagodecredito`
--

LOCK TABLES `pagodecredito` WRITE;
/*!40000 ALTER TABLE `pagodecredito` DISABLE KEYS */;
INSERT INTO `pagodecredito` VALUES (1,'Efectivo',1,NULL),(2,'Tarjeta débito',2,NULL),(3,'Efectivo',3,NULL),(4,'Tarjeta crédito',4,NULL),(5,'Cheque',5,NULL),(6,'Cheque',6,NULL),(7,'Tarjeta crédito',7,NULL);
/*!40000 ALTER TABLE `pagodecredito` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `NombreUsuario` varchar(50) NOT NULL,
  `token` varchar(255) NOT NULL,
  `expires_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `NombreUsuario` (`NombreUsuario`),
  CONSTRAINT `password_reset_tokens_ibfk_1` FOREIGN KEY (`NombreUsuario`) REFERENCES `usuario` (`NombreUsuario`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
INSERT INTO `password_reset_tokens` VALUES (1,'Pitersito123','09e8af24b3cc8b841e1309215d9f9612e2af4a938777bfc080156d13224557c9','2025-07-22 17:39:49'),(2,'Pitersito123','10115ed89327a202e76b5bfa3d455fcf59d78bc97f92b33a891f983c3cf82e8c','2025-07-22 17:57:44'),(3,'Pitersito123','8faff2b6318e6dab761bffec1c8c1140e1f0671ef99dba1a5c245ad60e69a3aa','2025-07-22 18:07:03');
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `presupuesto`
--

DROP TABLE IF EXISTS `presupuesto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `presupuesto` (
  `idPresupuesto` int NOT NULL AUTO_INCREMENT,
  `Fecha` date DEFAULT NULL,
  `idTipoPresupuesto` int DEFAULT NULL,
  `Dinero` decimal(10,0) DEFAULT NULL,
  `Ahorros` decimal(10,0) DEFAULT NULL,
  `NombreUsuario` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idPresupuesto`),
  KEY `idTipoPresupuesto` (`idTipoPresupuesto`),
  KEY `NombreUsuario` (`NombreUsuario`),
  CONSTRAINT `presupuesto_ibfk_2` FOREIGN KEY (`idTipoPresupuesto`) REFERENCES `tipopresupuesto` (`idTipoPresupuesto`),
  CONSTRAINT `presupuesto_ibfk_3` FOREIGN KEY (`NombreUsuario`) REFERENCES `usuario` (`NombreUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `presupuesto`
--

LOCK TABLES `presupuesto` WRITE;
/*!40000 ALTER TABLE `presupuesto` DISABLE KEYS */;
INSERT INTO `presupuesto` VALUES (1,'2024-01-01',1,10000,5000,'jpérez1010101'),(2,'2024-02-01',2,20000,10000,'agarcía2020202'),(3,'2024-03-01',3,15000,7500,'lmartínez3030303'),(4,'2024-04-01',4,25000,12500,'mrodríguez4040404'),(5,'2024-05-01',5,30000,15000,'phernández5050505'),(6,'2024-06-01',6,35000,17500,'llópez6060606'),(7,'2024-07-01',7,40000,20000,'csánchez7070707'),(8,'2025-05-21',3,NULL,NULL,'dani'),(9,NULL,NULL,NULL,NULL,NULL),(10,NULL,NULL,NULL,NULL,NULL),(11,NULL,NULL,NULL,NULL,NULL),(12,NULL,NULL,NULL,NULL,NULL),(13,NULL,NULL,NULL,NULL,NULL),(14,NULL,NULL,NULL,NULL,NULL),(15,NULL,NULL,NULL,NULL,NULL),(16,NULL,NULL,NULL,NULL,NULL),(17,NULL,NULL,NULL,NULL,NULL),(18,NULL,NULL,NULL,NULL,NULL),(19,NULL,NULL,NULL,NULL,NULL),(20,NULL,NULL,NULL,NULL,NULL),(21,NULL,NULL,NULL,NULL,NULL),(22,NULL,NULL,NULL,NULL,NULL),(23,NULL,NULL,NULL,NULL,NULL),(24,NULL,NULL,NULL,NULL,NULL),(25,NULL,NULL,NULL,NULL,NULL),(26,NULL,NULL,NULL,NULL,NULL),(27,NULL,NULL,NULL,NULL,NULL),(28,NULL,NULL,NULL,NULL,NULL),(29,NULL,NULL,NULL,NULL,NULL),(30,NULL,NULL,NULL,NULL,NULL),(31,NULL,NULL,NULL,NULL,NULL),(32,NULL,NULL,NULL,NULL,NULL),(33,NULL,NULL,NULL,NULL,NULL),(34,NULL,NULL,NULL,NULL,NULL),(35,NULL,NULL,NULL,NULL,NULL),(36,NULL,NULL,NULL,NULL,NULL),(37,NULL,NULL,NULL,NULL,NULL),(42,NULL,NULL,NULL,NULL,'andy'),(44,NULL,NULL,NULL,NULL,'dani');
/*!40000 ALTER TABLE `presupuesto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recordatorios`
--

DROP TABLE IF EXISTS `recordatorios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recordatorios` (
  `idRecordatorios` int NOT NULL,
  `Comentario` varchar(120) DEFAULT NULL,
  `NombreUsuario` varchar(50) NOT NULL,
  PRIMARY KEY (`idRecordatorios`),
  KEY `NombreUsuario` (`NombreUsuario`),
  CONSTRAINT `recordatorios_ibfk_1` FOREIGN KEY (`NombreUsuario`) REFERENCES `usuario` (`NombreUsuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recordatorios`
--

LOCK TABLES `recordatorios` WRITE;
/*!40000 ALTER TABLE `recordatorios` DISABLE KEYS */;
INSERT INTO `recordatorios` VALUES (1,'Pagar tarjeta de crédito','jpérez1010101'),(2,'Renovar seguro de vida','agarcía2020202'),(3,'Agendar cita médica','lmartínez3030303'),(4,'Revisar estado de cuenta','mrodríguez4040404'),(5,'Comprar regalos de cumpleaños','phernández5050505'),(6,'Preparar documentos de impuestos','llópez6060606'),(7,'Renovar licencia de conducir','csánchez7070707');
/*!40000 ALTER TABLE `recordatorios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `telefonos`
--

DROP TABLE IF EXISTS `telefonos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `telefonos` (
  `idTelefono` int NOT NULL,
  `Numero` varchar(15) DEFAULT NULL,
  `NombreUsuario` varchar(50) NOT NULL,
  PRIMARY KEY (`idTelefono`),
  KEY `NombreUsuario` (`NombreUsuario`),
  CONSTRAINT `telefonos_ibfk_1` FOREIGN KEY (`NombreUsuario`) REFERENCES `usuario` (`NombreUsuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `telefonos`
--

LOCK TABLES `telefonos` WRITE;
/*!40000 ALTER TABLE `telefonos` DISABLE KEYS */;
INSERT INTO `telefonos` VALUES (1,'3278945610','jpérez1010101'),(2,'3105478798','agarcía2020202'),(3,'3011554879','lmartínez3030303'),(4,'3099889784','mrodríguez4040404'),(5,'3009745221','phernández5050505'),(6,'3053041187','llópez6060606'),(7,'3105449284','csánchez7070707');
/*!40000 ALTER TABLE `telefonos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipodecredito`
--

DROP TABLE IF EXISTS `tipodecredito`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipodecredito` (
  `idTipoDeCredito` int NOT NULL,
  `TipoDeCredito` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idTipoDeCredito`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipodecredito`
--

LOCK TABLES `tipodecredito` WRITE;
/*!40000 ALTER TABLE `tipodecredito` DISABLE KEYS */;
INSERT INTO `tipodecredito` VALUES (1,'Hipotecario'),(2,'Automotriz'),(3,'Personal'),(4,'Educativo'),(5,'Comercial'),(6,'Agrícola'),(7,'Turístico');
/*!40000 ALTER TABLE `tipodecredito` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipopresupuesto`
--

DROP TABLE IF EXISTS `tipopresupuesto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipopresupuesto` (
  `idTipoPresupuesto` int NOT NULL,
  `TipoDePresupuesto` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idTipoPresupuesto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipopresupuesto`
--

LOCK TABLES `tipopresupuesto` WRITE;
/*!40000 ALTER TABLE `tipopresupuesto` DISABLE KEYS */;
INSERT INTO `tipopresupuesto` VALUES (1,'Anual'),(2,'Mensual'),(3,'Quincenal'),(4,'Semanal'),(5,'Diario'),(6,'Proyecto'),(7,'Emergencia');
/*!40000 ALTER TABLE `tipopresupuesto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tiposderecordatorios`
--

DROP TABLE IF EXISTS `tiposderecordatorios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tiposderecordatorios` (
  `idTiposDeRecordatorios` int NOT NULL,
  `TipoDeRecordatorio` varchar(50) DEFAULT NULL,
  `idRecordatorios` int NOT NULL,
  PRIMARY KEY (`idTiposDeRecordatorios`),
  KEY `idRecordatorios` (`idRecordatorios`),
  CONSTRAINT `tiposderecordatorios_ibfk_1` FOREIGN KEY (`idRecordatorios`) REFERENCES `recordatorios` (`idRecordatorios`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tiposderecordatorios`
--

LOCK TABLES `tiposderecordatorios` WRITE;
/*!40000 ALTER TABLE `tiposderecordatorios` DISABLE KEYS */;
INSERT INTO `tiposderecordatorios` VALUES (1,'Pago',1),(2,'Renovación',2),(3,'Salud',3),(4,'Revisión',4),(5,'Compra',5),(6,'Documentación',6),(7,'Licencia',7);
/*!40000 ALTER TABLE `tiposderecordatorios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `Correo` varchar(120) NOT NULL,
  `Nombres` varchar(70) DEFAULT NULL,
  `Apellidos` varchar(70) DEFAULT NULL,
  `Contraseña` varchar(60) NOT NULL,
  `Profesion` varchar(40) DEFAULT NULL,
  `FechaDeNacimiento` date DEFAULT NULL,
  `Expectativas` text,
  `NombreUsuario` varchar(50) NOT NULL,
  `Foto` varchar(255) DEFAULT NULL,
  `rol` enum('admi','userN') NOT NULL DEFAULT 'userN',
  PRIMARY KEY (`Correo`),
  UNIQUE KEY `NombreUsuario` (`NombreUsuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES ('44444527@gmail.com','JORGE ANDRÉS','BALLEN RAMÍREZ','$2b$10$aYXlEZdyCwfvw7klxdDeh.S9R.rFwWRdRwsmYyDHt03R.3iolc2tS','sadasdasd',NULL,'dsdsdas','ss_smileejjjjjjj',NULL,'userN'),('aaaaaaaaan527@gmail.com','JORGE ANDRÉS','BALLEN RAMÍREZ','$2b$10$JnmY9BkK32oPxx1ur0nMb.AFySFKR2XJZ1dh.9Peh4Sqpn702Rg2W','d',NULL,'ass','1014658356aasdd',NULL,'userN'),('aballen@gmail.com','andres','ballen','$2b$10$PY.nUfagYn56Awvg3EAKHuigTsUOdEY3Uf8O29vn4oUfp5MAeEQdq','fumon',NULL,'Ninguna','andresitow','1747594014098-8e6b1d3204facc690d79a8a2afe4045d.jpg','userN'),('alen527@gmail.com','JORGE ANDRÉS','BALLEN RAMÍREZ','$2b$10$KTm6SCpXsd1Yd2uXA.YKIuIYk3dn9mouCDCP3BAAdLLEYp39GpSbS','fumon',NULL,'gg','almejitas',NULL,'userN'),('ana.garcia@mail.com','Ana','García','abcdef','Abogada','1985-07-22','Crecimiento profesional','agarcía2020202',NULL,'userN'),('andasdasdasdresballen527@gmail.com','JORGE ANDRÉS','BALLEN RAMÍREZ','$2b$10$S8jzDeLpe7P72YB695Ke6O4pL0S3m0Q3CxaTZfQHdKBs.H2c95.Va','asds',NULL,'ddddd','ss_smileessss',NULL,'userN'),('andasdasdsad527@gmail.com','JORGE ANDRÉS','BALLEN RAMÍREZ','$2b$10$pee7ajJEiVUhYyVZYAvxfOpE5Mv2YBRdg/v254pyvv0YDcKmcgXRq','fumon',NULL,'asdasd','adswwwwwww',NULL,'userN'),('andresballen527@gmail.com','JORGE ANDRÉS','BALLEN RAMÍREZ','$2b$10$fSME9PKdSCTkvOW2XoL0yuSTMk8dqcnx9.LfZnlnXMJbTGhVkdAPW','sadasdasd',NULL,'sadasdsadsa','dsadsadasd',NULL,'userN'),('andrs527@gmail.com','JORGE ANDRÉS','BALLEN RAMÍREZ','$2b$10$ZlDc9asxdUrfH77y1UqHDecHfmuRLpbx1PRbfniwWa/05a6xzZQVm','sadasdasd',NULL,'dsd','1014658356',NULL,'userN'),('andy123@gmail.com','Andrés','Torres Gomez','$2b$10$KyV..K82u4DjOGT95PCjM.enDrGoR00VmhRdkE4mzY8J25y3cVrZu','Ingeniero',NULL,'Ser millonario','andy',NULL,'userN'),('arnulfito123@outlook.com','Arnulfo','Tercero Cuarto','$2b$10$/.yv2QrpE/p.vL.Cdo3N7eDSxSNXKRdzkcqtstuNT.BSlUgEFkjzG','Gestor de paz',NULL,'Salir de pobre','Arnulfi','1753741550654-1000051102.jpg','userN'),('aws27@gmail.com','JORGE ANDRÉS','BALLEN RAMÍREZ','$2b$10$tuvDTvCQpw.EmQP8FDNP/O2CjURD7VRTCFoqQtwOUM8SkCMUwAqZe','asds',NULL,'sssss','hello',NULL,'userN'),('carlos.sanchez@mail.com','Carlos','Sánchez','654321','Profesor','1988-12-25','Educación continua','csánchez7070707',NULL,'userN'),('daaaaaaa@gmail.com','JORGE ANDRÉS','BALLEN RAMÍREZ','$2b$10$iQvkBihaKZoYhhNwOrJmE.1ak4GmiD3RzRxjnn2JjgsdgOfkFIMKu','fasfadds',NULL,'ddsadsadasd','MrNebularGuy',NULL,'userN'),('daaaaaasssssa@gmail.com','JORGE ANDRÉS','BALLEN RAMÍREZ','$2b$10$MO6lU0CBKrCbr9R3Unq8POfFc7l9BHT/afDbrVwKsIsnMaUucGZhm','dasd',NULL,'s','adadaaaaaaaaaaaaaaaa',NULL,'userN'),('dani@gmail.com','Daniel','Ramirez','$2b$10$gAWH8M/RdVUJ1sh0PUMG4.51hLQNKREiiBAI5RfD9cS/1rjrIVLPi','fumon',NULL,'dasdasd','dani',NULL,'userN'),('hekjjjjj527@gmail.com','JORGE ANDRÉS','BALLEN RAMÍREZ','$2b$10$9EkdtyFEwO37HWpqy/BAJ.ZX4QTWNvNt0TU3zsEFC/10Nnv0THGP.','fumon',NULL,'','awwawawawaw',NULL,'userN'),('jaballenr@academia.usbbog.edu.co','asdasd','dasdsa','$2b$10$./girHqwxjP9P1.d/9hwLu7yDH0g/o4438MIdgVKCk/m4aSGYprGq','fumon',NULL,'dsadasd','ss_smilee',NULL,'userN'),('jalberto@outlook.com','juan','alberto','$2b$10$20e1qrFF7D9Xw0dzhkGjF.vQOAyuj29ufY1TOm1e7mokyJp2y3sPi','Profesor',NULL,'Manejar correctamente mis finanzas para evitar el estrés.','juanito','1747593211693-8e6b1d3204facc690d79a8a2afe4045d.jpg','userN'),('juan.perez@mail.com','Juan','Pérez','123456','Ingeniero','1980-05-10','Superación personal','jpérez1010101',NULL,'userN'),('lucia.lopez@mail.com','Lucía','López','pass123','Diseñadora','1982-09-09','Desarrollo personal','llópez6060606',NULL,'admi'),('luis.martinez@mail.com','Luis','Martínez','password','Doctor','1978-03-15','Estabilidad económica','lmartínez3030303',NULL,'userN'),('marta.rodriguez@mail.com','Marta','Rodríguez','qwerty','Contadora','1990-01-05','Viajar por el mundo','mrodríguez4040404',NULL,'admi'),('omaigat@gmail.com','JORGE ANDRÉS','BALLEN RAMÍREZ','$2b$10$0RBoYaN0.K47O3lJZjOIYOst2Ki.R4AGt.oRqbOgVzUtVcKhyjrBm','fumon',NULL,'ssss','uwuwuwuw',NULL,'userN'),('pedro.hernandez@mail.com','Pedro','Hernández','123abc','Arquitecto','1975-11-30','Innovación en su campo','phernández5050505',NULL,'userN'),('piteranguila725@gmail.com','Piter Albeiro','Anguila Gomez','$2b$10$.jeiAOecpPSjkFAPW4PnHOnDLXK8BRjQfLYpm63fSEo9PpJ.V1Qju','Prófugo de la justicia',NULL,'Salir con muchas diablas','Pitersito123',NULL,'userN');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'bossbudget'
--

--
-- Dumping routines for database 'bossbudget'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-12 21:49:44
