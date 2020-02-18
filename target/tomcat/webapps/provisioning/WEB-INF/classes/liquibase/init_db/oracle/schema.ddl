CREATE TABLE import_item_data (
  id           NUMBER GENERATED ALWAYS as IDENTITY,
  compressed_item BLOB NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE import_packages (
  id           NUMBER GENERATED ALWAYS as IDENTITY,
  package_name NVARCHAR2(255) NOT NULL,
  package_uuid NVARCHAR2(255) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT UK_package_uuid UNIQUE (package_uuid)
);

CREATE TABLE import_items (
  id            NUMBER GENERATED ALWAYS as IDENTITY,
  creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  item_name     NVARCHAR2(255) NOT NULL,
  item_type     NVARCHAR2(255) NOT NULL,
  item_uuid     NVARCHAR2(255) NOT NULL,
  item_status   NVARCHAR2(255) NOT NULL,
  item_message  NVARCHAR2(512),
  package_id    NUMBER(19)   NOT NULL,
  item_data_id  NUMBER(19) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT UK_item_uuid UNIQUE (item_uuid),
  CONSTRAINT FK_package_id FOREIGN KEY (package_id) REFERENCES import_packages (id),
  CONSTRAINT FK_item_data_id FOREIGN KEY (item_data_id) REFERENCES import_item_data (id)
);
