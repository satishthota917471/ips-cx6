CREATE TABLE export_package (
  id              BIGINT        NOT NULL IDENTITY (1, 1),
  name            NVARCHAR(255) NOT NULL,
  portal_name     NVARCHAR(255) NOT NULL,
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
  id            BIGINT        NOT NULL IDENTITY (1, 1),
  name          NVARCHAR(255) NOT NULL,
  type          NVARCHAR(255) NOT NULL,
  uuid          NVARCHAR(255) NOT NULL,
  status        NVARCHAR(20)  NOT NULL CONSTRAINT ck_export_item_status CHECK (status in ('WAITING', 'RECEIVED', 'FAILED')),
  message       NVARCHAR(512),
  package_id    BIGINT        NOT NULL,
  item_data_id  BIGINT,
  CONSTRAINT pk_export_item PRIMARY KEY (id),
  CONSTRAINT uk_export_item_uuid UNIQUE (uuid),
  CONSTRAINT fk_export_item2export_package FOREIGN KEY (package_id) REFERENCES export_package (id),
  CONSTRAINT fk_export_item2export_data FOREIGN KEY (item_data_id) REFERENCES item_data (id)
);
GO