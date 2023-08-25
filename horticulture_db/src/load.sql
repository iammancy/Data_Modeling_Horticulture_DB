INSERT INTO license_info (license_num, owner_name, trade_name)
SELECT lid,  owner_name, trade_name FROM horticulture_master


INSERT   INTO   opid_lid (opid, lid )
SELECT   op.opid, horti.lid
FROM horticulture_master horti
JOIN operation_info op ON horti.operation_name = op.operation_name

INSERT INTO contact (lid, business_phone, street_number, adressline_2, adressline_3, zip_code, city_id, state_id)
SELECT m.licensenumber, m.businessphone, m.streetnumber, m.addressline2, m.addressline3, m.zipcode, c.city_id, s.state_id
FROM horticulture_master m
JOIN city_info c ON m.city = c.city_name
JOIN state_info s ON m.state = s.state;