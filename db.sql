CREATE TABLE `warning` (
	`staffmember` VARCHAR(50) NULL DEFAULT NULL,
	`personwarned` VARCHAR(50) NULL DEFAULT NULL,
	`message` VARCHAR(255) NULL DEFAULT NULL
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;