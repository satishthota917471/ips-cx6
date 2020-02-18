CREATE TABLE item_data (
  id              BIGINT         NOT NULL IDENTITY (1, 1),
  compressed_item VARBINARY(MAX) NOT NULL,
  PRIMARY KEY (id)
);
GO

CREATE TABLE export_package (
  id              BIGINT        NOT NULL IDENTITY (1, 1),
  name            NVARCHAR(255) NOT NULL,
  portal_name     NVARCHAR(255),
  uuid            NVARCHAR(255) NOT NULL,
  creation_date   DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
  completion_date DATETIME,
  status          NVARCHAR(20)  NOT NULL CONSTRAINT ck_export_package_status CHECK (status in ('CREATING', 'PROCESSING', 'CREATED', 'FAILED')),
  message         NVARCHAR(512),
  CONSTRAINT pk_export_package PRIMARY KEY (id),
  CONSTRAINT uk_export_package_uuid UNIQUE (uuid)
);
GO

CREATE TABLE export_item (
  id                BIGINT        NOT NULL IDENTITY (1, 1),
  name              NVARCHAR(255) NOT NULL,
  type              NVARCHAR(255) NOT NULL,
  uuid              NVARCHAR(255) NOT NULL,
  status            NVARCHAR(20)  NOT NULL CONSTRAINT ck_export_item_status CHECK (status in ('WAITING', 'RECEIVED', 'FAILED')),
  message           NVARCHAR(512),
  package_id        BIGINT        NOT NULL,
  item_data_id      BIGINT,
  manifest_position INT DEFAULT 1 NOT NULL,
  CONSTRAINT pk_export_item PRIMARY KEY (id),
  CONSTRAINT uk_export_item_uuid UNIQUE (uuid),
  CONSTRAINT fk_export_item2export_package FOREIGN KEY (package_id) REFERENCES export_package (id),
  CONSTRAINT fk_export_item2export_data FOREIGN KEY (item_data_id) REFERENCES item_data (id)
);
GO

CREATE TABLE import_package (
  id            BIGINT        NOT NULL IDENTITY (1, 1),
  package_name  NVARCHAR(255) NOT NULL,
  package_uuid  NVARCHAR(255) NOT NULL,
  template_uuid NVARCHAR(255),
  creation_date DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
  status        NVARCHAR(20)  NOT NULL CONSTRAINT check_status CHECK (status in ('UPLOADED', 'PROCESSING', 'PROVISIONED', 'FAILED')),
  PRIMARY KEY (id),
  CONSTRAINT uk_package_uuid UNIQUE (package_uuid),
  CONSTRAINT fk_import_pkg2export_pkg FOREIGN KEY (template_uuid) REFERENCES export_package (uuid)
);
GO

CREATE TABLE import_item (
  id            BIGINT        NOT NULL IDENTITY (1, 1),
  item_name     NVARCHAR(255) NOT NULL,
  item_type     NVARCHAR(255) NOT NULL,
  item_uuid     NVARCHAR(255) NOT NULL,
  item_status   NVARCHAR(255) NOT NULL,
  item_message  NVARCHAR(512),
  package_id    BIGINT        NOT NULL,
  item_data_id  BIGINT        NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT uk_item_uuid UNIQUE (item_uuid),
  CONSTRAINT fk_package_id FOREIGN KEY (package_id) REFERENCES import_package (id),
  CONSTRAINT fk_import_item2item_data FOREIGN KEY (item_data_id) REFERENCES item_data (id)
);
GO