ALTER TABLE import_items DROP FOREIGN KEY FK_item_data_id;

ALTER TABLE import_packages ADD (
 creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
 status enum('UPLOADED', 'PROCESSING', 'PROVISIONED', 'FAILED')
);

ALTER TABLE import_item_data RENAME TO item_data;

ALTER TABLE import_packages RENAME TO import_package;

ALTER TABLE import_items RENAME TO import_item;

ALTER TABLE import_item ADD CONSTRAINT fk_import_item2item_data FOREIGN KEY (item_data_id) REFERENCES item_data (id);

UPDATE import_package, import_item SET import_package.creation_date = import_item.creation_date WHERE import_package.id = import_item.package_id;

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

ALTER TABLE import_package MODIFY COLUMN status enum('UPLOADED', 'PROCESSING', 'PROVISIONED', 'FAILED') NOT NULL;