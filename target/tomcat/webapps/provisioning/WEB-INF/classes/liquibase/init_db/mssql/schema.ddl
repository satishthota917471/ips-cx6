CREATE TABLE import_item_data (
  id              BIGINT         NOT NULL IDENTITY (1, 1),
  compressed_item VARBINARY(MAX) NOT NULL,
  PRIMARY KEY (id)
);
GO

CREATE TABLE import_packages (
  id           BIGINT        NOT NULL IDENTITY (1, 1),
  package_name NVARCHAR(255) NOT NULL,
  package_uuid NVARCHAR(255) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT uk_package_uuid UNIQUE (package_uuid)
);
GO

CREATE TABLE import_items (
  id            BIGINT        NOT NULL IDENTITY (1, 1),
  creation_date DATETIME      DEFAULT CURRENT_TIMESTAMP NOT NULL,
  item_name     NVARCHAR(255) NOT NULL,
  item_type     NVARCHAR(255) NOT NULL,
  item_uuid     NVARCHAR(255) NOT NULL,
  item_status   NVARCHAR(255) NOT NULL,
  item_message  NVARCHAR(512),
  package_id    BIGINT        NOT NULL,
  item_data_id  BIGINT        NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT uk_item_uuid UNIQUE (item_uuid),
  CONSTRAINT fk_package_id FOREIGN KEY (package_id) REFERENCES import_packages (id)
);
GO