ALTER TABLE import_package
	ADD template_uuid NVARCHAR2(255);

ALTER TABLE import_package
	ADD CONSTRAINT fk_import_pkg2export_pkg
		FOREIGN KEY (template_uuid) REFERENCES export_package (uuid);