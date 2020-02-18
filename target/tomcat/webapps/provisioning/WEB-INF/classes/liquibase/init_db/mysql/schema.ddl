CREATE TABLE import_item_data (
  id              BIGINT   NOT NULL AUTO_INCREMENT,
  compressed_item LONGBLOB NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE import_packages (
  id           BIGINT       NOT NULL AUTO_INCREMENT,
  package_name VARCHAR(255) NOT NULL,
  package_uuid VARCHAR(255) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT UK_package_uuid UNIQUE (package_uuid)
);

CREATE TABLE import_items (
  id            BIGINT       NOT NULL AUTO_INCREMENT,
  creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  item_name     VARCHAR(255) NOT NULL,
  item_type     VARCHAR(255) NOT NULL,
  item_uuid     VARCHAR(255) NOT NULL,
  item_status   VARCHAR(255) NOT NULL,
  item_message  VARCHAR(512),
  package_id    BIGINT       NOT NULL,
  item_data_id  BIGINT       NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT UK_item_uuid UNIQUE (item_uuid),
  CONSTRAINT FK_package_id FOREIGN KEY (package_id) REFERENCES import_packages (id),
  CONSTRAINT FK_item_data_id FOREIGN KEY (item_data_id) REFERENCES import_item_data (id)
);