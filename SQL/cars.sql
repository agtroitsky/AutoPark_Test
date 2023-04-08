CREATE TABLE `auto_test`.`cars` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `number` VARCHAR(10) NOT NULL,
  `model_id` INT NOT NULL,
  `year` INT NOT NULL,
  `last_to` DATE NOT NULL,
  `path` DOUBLE NOT NULL,
  `deleted` TINYINT(1) ZEROFILL NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = cp1251
COMMENT = 'Таблица автомобилей';

ALTER TABLE `auto_test`.`cars` 
CHANGE COLUMN `year` `year` YEAR(4) NOT NULL ;