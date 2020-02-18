CREATE TABLE item_data (
  id              NUMBER GENERATED ALWAYS as IDENTITY,
  compressed_item BLOB NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE export_package (
  id              NUMBER GENERATED ALWAYS as IDENTITY,
  name            NVARCHAR2(255) NOT NULL,
  portal_name     NVARCHAR2(255),
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
  id                NUMBER GENERATED ALWAYS as IDENTITY,
  name              NVARCHAR2(255)    NOT NULL,
  type              NVARCHAR2(255)    NOT NULL,
  uuid              NVARCHAR2(255)    NOT NULL,
  status            NVARCHAR2(20)     NOT NULL,
  message           NVARCHAR2(512),
  package_id        NUMBER(19)        NOT NULL,
  item_data_id      NUMBER(19),
  manifest_position INTEGER DEFAULT 1 NOT NULL,
  CONSTRAINT pk_export_item PRIMARY KEY (id),
  CONSTRAINT uk_export_item_uuid UNIQUE (uuid),
  CONSTRAINT fk_export_item2export_package FOREIGN KEY (package_id) REFERENCES export_package (id),
  CONSTRAINT fk_export_item2item_data FOREIGN KEY (item_data_id) REFERENCES item_data (id),
  CONSTRAINT ck_export_item_status CHECK (status in ('WAITING', 'RECEIVED', 'FAILED'))
);

CREATE TABLE import_package (
  id            NUMBER GENERATED ALWAYS as IDENTITY,
  package_name  NVARCHAR2(255) NOT NULL,
  package_uuid  NVARCHAR2(255) NOT NULL,
  template_uuid NVARCHAR2(255),
  creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  status        NVARCHAR2(20)  NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT ck_import_package_status CHECK (status in ('UPLOADED', 'PROCESSING', 'PROVISIONED', 'FAILED')),
  CONSTRAINT UK_package_uuid UNIQUE (package_uuid),
  CONSTRAINT fk_import_pkg2export_pkg FOREIGN KEY (template_uuid) REFERENCES export_package (uuid)
);

CREATE TABLE import_item (
  id            NUMBER GENERATED ALWAYS as IDENTITY,
  item_name     NVARCHAR2(255) NOT NULL,
  item_type     NVARCHAR2(255) NOT NULL,
  item_uuid     NVARCHAR2(255) NOT NULL,
  item_status   NVARCHAR2(255) NOT NULL,
  item_message  NVARCHAR2(512),
  package_id    NUMBER(19)     NOT NULL,
  item_data_id  NUMBER(19)     NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT UK_item_uuid UNIQUE (item_uuid),
  CONSTRAINT FK_package_id FOREIGN KEY (package_id) REFERENCES import_package (id),
  CONSTRAINT fk_import_item2item_data FOREIGN KEY (item_data_id) REFERENCES item_data (id)
);
