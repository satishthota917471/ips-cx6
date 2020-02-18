DECLARE @default_name NVARCHAR(255)
SELECT @default_name = [name] FROM sys.default_constraints
  WHERE parent_object_id = object_id('import_items')
  AND col_name(parent_object_id, parent_column_id) = 'creation_date';

EXEC ('ALTER TABLE import_items DROP CONSTRAINT ' + @default_name);
GO

ALTER TABLE import_packages ADD
 creation_date DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
 status NVARCHAR(20) CONSTRAINT check_status CHECK (status in ('UPLOADED', 'PROCESSING', 'PROVISIONED', 'FAILED'));
GO

EXEC sp_rename 'import_item_data', 'item_data';
GO

EXEC sp_rename 'import_packages', 'import_package';
GO

EXEC sp_rename 'import_items', 'import_item';
GO

ALTER TABLE import_item ADD CONSTRAINT fk_import_item2item_data FOREIGN KEY (item_data_id) REFERENCES item_data (id);
GO

UPDATE import_package SET import_package.creation_date = (SELECT TOP (1) import_item.creation_date FROM import_item WHERE import_package.id = import_item.package_id);
GO

UPDATE import_package SET import_package.status = 'UPLOADED' WHERE import_package.id
NOT IN (SELECT import_item.package_id FROM import_item WHERE import_item.item_status IN ('PROCESSING', 'FAILED', 'PROVISIONED')
AND import_item.package_id = import_package.id);
GO

UPDATE import_package SET import_package.status = 'PROCESSING' WHERE import_package.id
IN (SELECT import_item.package_id FROM import_item WHERE import_item.item_status NOT IN ('FAILED', 'PROVISIONED') AND import_item.item_status IN ('PROCESSING', 'UPLOADED')
AND import_item.package_id = import_package.id);
GO

UPDATE import_package SET import_package.status = 'PROVISIONED' WHERE import_package.id
NOT IN (SELECT import_item.package_id FROM import_item WHERE import_item.item_status IN ('UPLOADED', 'PROCESSING', 'FAILED')
AND import_item.package_id = import_package.id);
GO

UPDATE import_package SET import_package.status = 'FAILED' WHERE import_package.id
IN (SELECT import_item.package_id FROM import_item WHERE import_item.item_status = 'FAILED'
AND import_item.package_id = import_package.id);
GO

ALTER TABLE import_item DROP COLUMN creation_date;
GO

ALTER TABLE import_package ALTER COLUMN status NVARCHAR(20) NOT NULL;
GO

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