CREATE TABLE item_data (
  id              BIGINT   NOT NULL AUTO_INCREMENT,
  compressed_item LONGBLOB NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE export_package (
  id              BIGINT       NOT NULL AUTO_INCREMENT,
  name            VARCHAR(255) NOT NULL,
  portal_name     VARCHAR(255),
  uuid            VARCHAR(255) NOT NULL,
  creation_date   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP NOT NULL,
  completion_date TIMESTAMP    NULL DEFAULT NULL,
  status          enum('CREATING', 'PROCESSING', 'CREATED', 'FAILED') NOT NULL,
  message         VARCHAR(512),
  CONSTRAINT pk_export_package PRIMARY KEY (id),
  CONSTRAINT uk_export_package_uuid UNIQUE (uuid)
);

CREATE TABLE export_item (
  id                BIGINT        NOT NULL AUTO_INCREMENT,
  name              VARCHAR(255)  NOT NULL,
  type              VARCHAR(255)  NOT NULL,
  uuid              VARCHAR(255)  NOT NULL,
  status            enum('WAITING', 'RECEIVED', 'FAILED') NOT NULL,
  message           VARCHAR(512),
  package_id        BIGINT        NOT NULL,
  item_data_id      BIGINT,
  manifest_position INT DEFAULT 1 NOT NULL,
  CONSTRAINT pk_export_item PRIMARY KEY (id),
  CONSTRAINT uk_export_item_uuid UNIQUE (uuid),
  CONSTRAINT fk_export_item2export_package FOREIGN KEY (package_id) REFERENCES export_package (id),
  CONSTRAINT fk_export_item2item_data FOREIGN KEY (item_data_id) REFERENCES item_data (id)
);

CREATE TABLE import_package (
  id           BIGINT       NOT NULL AUTO_INCREMENT,
  package_name VARCHAR(255) NOT NULL,
  package_uuid VARCHAR(255) NOT NULL,
  template_uuid VARCHAR(255),
  creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  status enum('UPLOADED', 'PROCESSING', 'PROVISIONED', 'FAILED') NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT UK_package_uuid UNIQUE (package_uuid),
  CONSTRAINT fk_import_pkg2export_pkg FOREIGN KEY (template_uuid) REFERENCES export_package (uuid)
);

CREATE TABLE import_item (
  id            BIGINT       NOT NULL AUTO_INCREMENT,
  item_name     VARCHAR(255) NOT NULL,
  item_type     VARCHAR(255) NOT NULL,
  item_uuid     VARCHAR(255) NOT NULL,
  item_status   VARCHAR(255) NOT NULL,
  item_message  VARCHAR(512),
  package_id    BIGINT       NOT NULL,
  item_data_id  BIGINT       NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT UK_item_uuid UNIQUE (item_uuid),
  CONSTRAINT FK_package_id FOREIGN KEY (package_id) REFERENCES import_package (id),
  CONSTRAINT fk_import_item2item_data FOREIGN KEY (item_data_id) REFERENCES item_data (id)
);