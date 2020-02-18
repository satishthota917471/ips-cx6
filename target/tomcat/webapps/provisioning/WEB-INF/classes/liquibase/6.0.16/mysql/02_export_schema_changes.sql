CREATE TABLE export_package (
  id              BIGINT       NOT NULL AUTO_INCREMENT,
  name            VARCHAR(255) NOT NULL,
  portal_name     VARCHAR(255) NOT NULL,
  uuid            VARCHAR(255) NOT NULL,
  creation_date   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP NOT NULL,
  completion_date TIMESTAMP    NULL DEFAULT NULL,
  status          enum('CREATING', 'PROCESSING', 'CREATED', 'FAILED') NOT NULL,
  message         VARCHAR(512),
  CONSTRAINT pk_export_package PRIMARY KEY (id),
  CONSTRAINT uk_export_package_uuid UNIQUE (uuid)
);

CREATE TABLE export_item (
  id           BIGINT       NOT NULL AUTO_INCREMENT,
  name         VARCHAR(255) NOT NULL,
  type         VARCHAR(255) NOT NULL,
  uuid         VARCHAR(255) NOT NULL,
  status       enum('WAITING', 'RECEIVED', 'FAILED') NOT NULL,
  message      VARCHAR(512),
  package_id   BIGINT       NOT NULL,
  item_data_id BIGINT,
  CONSTRAINT pk_export_item PRIMARY KEY (id),
  CONSTRAINT uk_export_item_uuid UNIQUE (uuid),
  CONSTRAINT fk_export_item2export_package FOREIGN KEY (package_id) REFERENCES export_package (id),
  CONSTRAINT fk_export_item2item_data FOREIGN KEY (item_data_id) REFERENCES item_data (id)
);