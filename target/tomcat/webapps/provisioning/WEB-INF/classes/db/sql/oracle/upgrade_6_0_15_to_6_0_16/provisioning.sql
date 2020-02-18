ALTER TABLE import_items DROP CONSTRAINT FK_item_data_id;

ALTER TABLE import_packages ADD (
 creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
 status        NVARCHAR2(20)
);

ALTER TABLE import_item_data RENAME TO item_data;

ALTER TABLE import_packages RENAME TO import_package;

ALTER TABLE import_items RENAME TO import_item;

ALTER TABLE import_item ADD CONSTRAINT fk_import_item2item_data FOREIGN KEY (item_data_id) REFERENCES item_data (id);

UPDATE import_package SET import_package.creation_date = (SELECT import_item.creation_date FROM import_item WHERE import_package.id = import_item.package_id AND ROWNUM = 1);

UPDATE import_package SET import_package.status = 'UPLOADED' WHERE import_package.id
NOT IN (SELECT import_item.package_id FROM import_item WHERE import_item.item_status IN ('PROCESSING', 'FAILED', 'PROVISIONED')
AND import_item.package_id = import_package.id);

UPDATE import_package SET import_package.status = 'PROCESSING' WHERE import_package.id
IN (SELECT import_item.package_id FROM import_item WHERE import_item.item_status NOT IN ('FAILED', 'PROVISIONED') AND import_item.item_status IN ('PROCESSING', 'UPLOADED')
AND import_item.package_id = import_package.id);

UPDATE import_package SET import_package.status = 'PROVISIONED' WHERE import_package.id
NOT IN (SELECT import_item.package_id FROM import_item WHERE import_item.item_status IN ('UPLOADED', 'PROCESSING', 'FAILED')
AND import_item.package_id = import_package.id);

UPDATE import_package SET import_package.status = 'FAILED' WHERE import_package.id
IN (SELECT import_item.package_id FROM import_item WHERE import_item.item_status = 'FAILED'
AND import_item.package_id = import_package.id);

ALTER TABLE import_item DROP COLUMN creation_date;

ALTER TABLE import_package MODIFY status NVARCHAR2(20) NOT NULL;

ALTER TABLE import_package ADD CONSTRAINT ck_import_package_status CHECK (status in ('UPLOADED', 'PROCESSING', 'PROVISIONED', 'FAILED'));

CREATE TABLE export_package (
  id              NUMBER GENERATED ALWAYS as IDENTITY,
  name            NVARCHAR2(255) NOT NULL,
  portal_name     NVARCHAR2(255) NOT NULL,
  uuid            NVARCHAR2(255) NOT NULL,
  creation_date   TIMESTAMP      DEFAULT CURRENT_TIMESTAMP NOT NULL,
  completion_date TIMESTAMP,
  status          NVARCHAR2(20)  NOT NULL,
  message         NVARCHAR2(512),
  CONSTRAINT pk_export_package PRIMARY KEY (id),
  CONSTRAINT uk_export_package_uuid UNIQUE (uuid),
  CONSTRAINT ck_export_package_status CHECK (status in ('CREATING', 'PROCESSING', 'CREATED', 'FAILED'))
);

CREATE TABLE export_item (
  id           NUMBER GENERATED ALWAYS as IDENTITY,
  name         NVARCHAR2(255) NOT NULL,
  type         NVARCHAR2(255) NOT NULL,
  uuid         NVARCHAR2(255) NOT NULL,
  status       NVARCHAR2(20)  NOT NULL,
  message      NVARCHAR2(512),
  package_id   NUMBER(19)     NOT NULL,
  item_data_id NUMBER(19),
  CONSTRAINT pk_export_item PRIMARY KEY (id),
  CONSTRAINT uk_export_item_uuid UNIQUE (uuid),
  CONSTRAINT fk_export_item2export_package FOREIGN KEY (package_id) REFERENCES export_package (id),
  CONSTRAINT fk_export_item2item_data FOREIGN KEY (item_data_id) REFERENCES item_data (id),
  CONSTRAINT ck_export_item_status CHECK (status in ('WAITING', 'RECEIVED', 'FAILED'))
);