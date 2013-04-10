DROP SCHEMA IF EXISTS finance;
CREATE SCHEMA IF NOT EXISTS finance;
USE finance;

CREATE TABLE IF NOT EXISTS finance.user(
	id_user INT UNSIGNED NOT NULL AUTO_INCREMENT,
	name VARCHAR(20) NOT NULL,
	login VARCHAR(20) NOT NULL,
	password CHAR(40) NOT NULL,
	PRIMARY KEY (id_user),
	UNIQUE uk__user(login)
) ENGINE=InnoDB CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS finance.currency(
	id_currency SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	code CHAR(3) NOT NULL,
	description VARCHAR(40) NOT NULL,
	symbol VARCHAR(5) NOT NULL,
	PRIMARY KEY(id_currency)
) ENGINE=InnoDB CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS finance.category(
	id_category INT UNSIGNED NOT NULL,
	id_user INT UNSIGNED NOT NULL,
	description VARCHAR(40) NOT NULL,
	id_parent INT UNSIGNED,

	PRIMARY KEY(id_category),
	UNIQUE uk__category__user(id_category, id_user),
	INDEX idx__category__parent(id_parent),
	CONSTRAINT fk__category__user 
		FOREIGN KEY (id_user) REFERENCES finance.user(id_user) 
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk__category__parent 
		FOREIGN KEY (id_parent) REFERENCES finance.category(id_category) 
		ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS finance.project(
	id_project INT UNSIGNED NOT NULL AUTO_INCREMENT,
	id_user INT UNSIGNED NOT NULL,
	id_currency SMALLINT UNSIGNED NOT NULL,
	name VARCHAR(25) NOT NULL,
	PRIMARY KEY(id_project),
	UNIQUE uk__project__user(id_project, id_user),
	INDEX idx__project__user(id_user),
	INDEX idx__project__currency(id_currency),
	CONSTRAINT idx__project__user
		FOREIGN KEY (id_user) REFERENCES finance.user(id_user)
		ON UPDATE RESTRICT ON DELETE CASCADE,
	CONSTRAINT idx__project__currency
		FOREIGN KEY (id_currency) REFERENCES finance.currency(id_currency)
		ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS finance.transaction(
	id_transaction INT UNSIGNED NOT NULL AUTO_INCREMENT,
	id_project INT UNSIGNED NOT NULL,
	id_category INT UNSIGNED NOT NULL,
	id_user INT UNSIGNED NOT NULL,
	id_transfer INT UNSIGNED NULL,
	description VARCHAR(100) NOT NULL,
	amount DECIMAL(12,4) NOT NULL,
	date_transaction DATE,
	
	PRIMARY KEY(id_transaction),
	UNIQUE uk__transaction__user(id_transaction, id_user),
	CONSTRAINT fk__transaction__project
		FOREIGN KEY (id_project, id_user)
		REFERENCES finance.project(id_project, id_user)
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk__transaction__category
		FOREIGN KEY (id_category, id_user)
		REFERENCES finance.category(id_category, id_user)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT fk__transaction__user
		FOREIGN KEY (id_user)
		REFERENCES finance.user (id_user)
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk__transaction__transfer
		FOREIGN KEY (id_transfer) REFERENCES finance.transaction(id_transaction)
		ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS finance.tag(
	id_tag INT UNSIGNED NOT NULL AUTO_INCREMENT,
	id_user INT UNSIGNED NOT NULL,
	description VARCHAR(50),
	PRIMARY KEY (id_tag, id_user),
	INDEX idx__tag__user(id_user),
	CONSTRAINT fk__tag__user
		FOREIGN KEY (id_user)
		REFERENCES finance.user(id_user)
		ON UPDATE CASCADE ON DELETE CASCADE	
) ENGINE=InnoDB CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS finance.transaction_tag( 
	id_transaction INT UNSIGNED NOT NULL,
	id_tag INT UNSIGNED NOT NULL,
	id_user INT UNSIGNED NOT NULL,
	PRIMARY KEY(id_transaction, id_tag),
	INDEX idx__transaction_tag__transaction(id_transaction, id_user),
	INDEX idx__transaction_tag__tag(id_tag, id_user),
	CONSTRAINT fk__transaction_tag__transaction
		FOREIGN KEY(id_transaction, id_user)
		REFERENCES finance.transaction(id_transaction, id_user)
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk__transaction_tag__tag
		FOREIGN KEY(id_tag, id_user)
		REFERENCES finance.tag(id_tag, id_user)
) ENGINE=InnoDB CHARACTER SET=utf8;


CREATE TABLE IF NOT EXISTS finance.threshold(
	id_threshold INT UNSIGNED NOT NULL,
	id_tag INT UNSIGNED NULL,
	id_category INT UNSIGNED NULL,
	id_user INT UNSIGNED NOT NULL,
	amount DECIMAL(12,4) NOT NULL,
	PRIMARY KEY(id_threshold),
	UNIQUE uk__threshold__user(id_threshold, id_user),
	INDEX idx__threshold__user(id_user),
	INDEX idx__threshold__tag(id_tag),
	INDEX idx__threshold__category(id_category),
	CONSTRAINT fk__threshold__user
		FOREIGN KEY (id_user) REFERENCES finance.user(id_user)
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk__threshold__tag
		FOREIGN KEY (id_tag, id_user) REFERENCES finance.tag(id_tag, id_user)
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk__threshold__category
		FOREIGN KEY (id_category, id_user) REFERENCES finance.category(id_category, id_user)
		ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS finance.threshold_project(
	id_threshold INT UNSIGNED NOT NULL,
	id_project INT UNSIGNED NOT NULL,
	id_user INT UNSIGNED NOT NULL,
	PRIMARY KEY(id_threshold, id_project),
	INDEX idx__threshold_project__threshold(id_threshold, id_user),
	INDEX idx__threshold_project__project(id_project, id_user),
	CONSTRAINT fk__threshold_project__threshold
		FOREIGN KEY(id_threshold, id_user) REFERENCES finance.threshold(id_threshold, id_user)
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk__threshold_project__project
		FOREIGN KEY(id_project, id_user) REFERENCES finance.project(id_project, id_user)
		ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB CHARACTER SET=utf8;

CREATE TABLE IF NOT EXISTS finance.balance_cache(
	id_project INT UNSIGNED NOT NULL,
	id_user INT UNSIGNED NOT NULL,
	month TINYINT UNSIGNED NOT NULL,
	year SMALLINT UNSIGNED NOT NULL,
	amount DECIMAL(12, 4) NOT NULL DEFAULT 0,
	PRIMARY KEY(id_project, id_user, month, year),
	INDEX idx__balance_cache__project(id_project, id_user),
	INDEX idx__balance_cache__date(month, year),
	CONSTRAINT fk__balance_cache__project
		FOREIGN KEY (id_project, id_user) REFERENCES finance.project(id_project, id_user)
		ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS finance.tag_cache(
	id_tag INT UNSIGNED NOT NULL,
	id_user INT UNSIGNED NOT NULL,
	month TINYINT UNSIGNED NOT NULL,
	year SMALLINT UNSIGNED NOT NULL,
	amount DECIMAL(12, 4) NOT NULL DEFAULT 0,
	PRIMARY KEY(id_tag, id_user, month, year),
	INDEX idx__tag_cache__tag(id_tag, id_user),
	INDEX idx__tag_cache__date(month, year),
	CONSTRAINT fk__tag_cache__tag
		FOREIGN KEY (id_tag, id_user) REFERENCES finance.tag(id_tag, id_user)
		ON UPDATE CASCADE ON DELETE CASCADE
);