CREATE TABLE `auto_test`.`pathlists` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `timeout` DATETIME NOT NULL,
  `timein` DATETIME NOT NULL,
  `driver_id` INT NOT NULL,
  `car_id` INT NOT NULL,
  `disp_id` INT NOT NULL,
  `fuel` DOUBLE NOT NULL,
  `path` DOUBLE NOT NULL,
  `deleted` TINYINT(1) ZEROFILL NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = cp1251
COMMENT = 'Таблица путевых листов';

ALTER TABLE `auto_test`.`pathlists` 
CHANGE COLUMN `timeout` `timeout` DATETIME NULL ,
CHANGE COLUMN `timein` `timein` DATETIME NULL ,
CHANGE COLUMN `fuel` `fuel` DOUBLE NULL ,
CHANGE COLUMN `path` `path` DOUBLE NULL ;