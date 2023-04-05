CREATE TABLE `auto_test`.`armodels` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `firm` VARCHAR(45) NOT NULL,
  `model` VARCHAR(45) NOT NULL,
  `deleted` TINYINT(1) ZEROFILL NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = cp1251
COMMENT = 'Таблица моделей автомобилей';

ALTER TABLE `auto_test`.`armodels` 
RENAME TO  `auto_test`.`carmodels` ;