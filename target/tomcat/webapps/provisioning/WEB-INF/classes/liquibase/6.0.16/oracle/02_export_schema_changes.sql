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