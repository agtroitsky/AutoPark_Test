ALTER TABLE `auto_test`.`disps` 
ADD COLUMN `patronymic` VARCHAR(45) NOT NULL AFTER `name`,
ADD COLUMN `surname` VARCHAR(45) NOT NULL AFTER `patronymic`,
ADD COLUMN `deleted` TINYINT(1) ZEROFILL NULL AFTER `surname`;

ALTER TABLE `auto_test`.`disps` 
CHANGE COLUMN `deleted` `deleted` TINYINT(1) UNSIGNED ZEROFILL NOT NULL ;

ALTER TABLE `auto_test`.`disps` 
COMMENT = 'Таблица диспетчеров' ;
