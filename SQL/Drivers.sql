CREATE TABLE `auto_test`.`drivers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) CHARACTER SET 'cp1251' COLLATE 'cp1251_general_ci' NOT NULL,
  `patronymic` VARCHAR(45) CHARACTER SET 'cp1251' COLLATE 'cp1251_general_ci' NOT NULL,
  `surname` VARCHAR(45) CHARACTER SET 'cp1251' COLLATE 'cp1251_general_ci' NOT NULL,
  `birthdate` DATE NOT NULL,
  `deleted` TINYINT(1) ZEROFILL NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = cp1251;

ALTER TABLE `auto_test`.`drivers` 
CHANGE COLUMN `deleted` `deleted` TINYINT(1) UNSIGNED ZEROFILL NOT NULL , COMMENT = 'Таблица водителей' ;