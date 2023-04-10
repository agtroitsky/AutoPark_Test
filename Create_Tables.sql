CREATE TABLE `disps` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `patronymic` varchar(45) NOT NULL,
  `surname` varchar(45) NOT NULL,
  `deleted` tinyint(1) unsigned zerofill NOT NULL,
  PRIMARY KEY (`id`))
ENGINE=InnoDB
DEFAULT CHARSET=cp1251
COMMENT='Таблица диспетчеров';

CREATE TABLE `drivers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL,
  `patronymic` varchar(45) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL,
  `surname` varchar(45) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL,
  `birthdate` date NOT NULL,
  `deleted` tinyint(1) unsigned zerofill NOT NULL,
  PRIMARY KEY (`id`))
ENGINE=InnoDB
DEFAULT CHARSET=cp1251
COMMENT='Таблица водителей';

CREATE TABLE `carmodels` (
  `id` int NOT NULL AUTO_INCREMENT,
  `firm` varchar(45) NOT NULL,
  `model` varchar(45) NOT NULL,
  `deleted` tinyint(1) unsigned zerofill NOT NULL,
  PRIMARY KEY (`id`))
ENGINE=InnoDB
DEFAULT CHARSET=cp1251
COMMENT='Таблица моделей автомобилей';

CREATE TABLE `cars` (
  `id` int NOT NULL AUTO_INCREMENT,
  `number` varchar(10) NOT NULL,
  `model_id` int NOT NULL,
  `year` year NOT NULL,
  `last_to` date NOT NULL,
  `path` double NOT NULL,
  `deleted` tinyint(1) unsigned zerofill NOT NULL,
  PRIMARY KEY (`id`))
ENGINE=InnoDB
DEFAULT CHARSET=cp1251
COMMENT='Таблица автомобилей';

CREATE TABLE `pathlists` (
  `id` int NOT NULL AUTO_INCREMENT,
  `timeout` datetime DEFAULT NULL,
  `timein` datetime DEFAULT NULL,
  `driver_id` int NOT NULL,
  `car_id` int NOT NULL,
  `disp_id` int NOT NULL,
  `fuel` double DEFAULT NULL,
  `path` double DEFAULT NULL,
  `deleted` tinyint(1) unsigned zerofill NOT NULL,
  PRIMARY KEY (`id`))
ENGINE=InnoDB
DEFAULT CHARSET=cp1251
COMMENT='Таблица путевых листов';
