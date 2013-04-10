USE finance;

DROP TRIGGER IF EXISTS finance.tr__insert__transaction;
DROP TRIGGER IF EXISTS finance.tr__update__transaction;
DROP TRIGGER IF EXISTS finance.tr__delete__transaction;

DROP PROCEDURE IF EXISTS finance.update_balance_cache;
DROP PROCEDURE IF EXISTS finance.update_tag_cache;

delimiter //

CREATE PROCEDURE finance.update_balance_cache(
	$ID_PROJECT INT UNSIGNED,
	$ID_USER INT UNSIGNED,
	$DATE_TRANSACTION DATE,
	$AMOUNT DECIMAL(12,4)
)
BEGIN
	DECLARE $BALANCE DECIMAL(12, 4);
	SET $BALANCE = 0;

	SELECT COALESCE(amount, 0)
	INTO $BALANCE
	FROM balance_cache 
	WHERE id_project = $ID_PROJECT AND id_user = $ID_USER 
	AND DATE(CONCAT(year,'-', month, '-01')) <= $DATE_TRANSACTION
	ORDER BY DATE(CONCAT(year,'-', month, '-01')) DESC
	LIMIT 1	;
	
	INSERT INTO finance.balance_cache(id_project, id_user, `month`, `year`, amount)
	VALUES($ID_PROJECT, $ID_USER, month($DATE_TRANSACTION), year($DATE_TRANSACTION), $BALANCE+$AMOUNT)
	ON DUPLICATE KEY UPDATE
		`amount` = `amount` + ($AMOUNT);
	
	UPDATE finance.balance_cache
	SET amount = amount + ($AMOUNT)
	WHERE id_project = $ID_PROJECT AND id_user = $ID_USER AND DATE(CONCAT(year,'-', month, '-01')) > $DATE_TRANSACTION ;
END//


CREATE TRIGGER finance.tr__insert__transaction AFTER INSERT ON finance.transaction
FOR EACH ROW BEGIN
	CALL finance.update_balance_cache(NEW.id_project, NEW.id_user, NEW.date_transaction, NEW.amount);
END;
//

CREATE TRIGGER finance.tr__update__transaction AFTER UPDATE ON finance.transaction
FOR EACH ROW BEGIN
	-- Se a data for diferente
	IF( OLD.date_transaction <> NEW.date_transaction ) THEN
		CALL finance.update_balance_cache(OLD.id_project, OLD.id_user, OLD.date_transaction, OLD.amount*-1);
		CALL finance.update_balance_cache(NEW.id_project, NEW.id_user, NEW.date_transaction, NEW.amount);
	ELSE
		CALL finance.update_balance_cache(NEW.id_project, NEW.id_user, NEW.date_transaction, NEW.amount - OLD.amount);
	END IF;
END;
//

CREATE TRIGGER finance.tr__delete__transaction AFTER DELETE ON finance.transaction
FOR EACH ROW BEGIN
	CALL finance.update_balance_cache(OLD.id_project, OLD.id_user, OLD.date_transaction, OLD.amount*-1);
END;
//

CREATE PROCEDURE finance.update_tag_cache(
	$ID_TAG INT UNSIGNED,
	$ID_USER INT UNSIGNED,
	$DATE_TRANSACTION DATE,
	$AMOUNT DECIMAL(12,4)
)
BEGIN
	INSERT INTO finance.tag_cache(id_tag, id_user, `month`, `year`, amount)
	VALUES($ID_TAG, $ID_USER, month($DATE_TRANSACTION), year($DATE_TRANSACTION), $AMOUNT)
	ON DUPLICATE KEY UPDATE
		`amount` = `amount` + ($AMOUNT);
	
	UPDATE finance.tag_cache
	SET amount = amount + ($AMOUNT)
	WHERE id_tag = $ID_TAG AND id_user = $ID_USER AND DATE(CONCAT(year,'-', month, '-01')) > $DATE_TRANSACTION ;
END//

delimiter ;

