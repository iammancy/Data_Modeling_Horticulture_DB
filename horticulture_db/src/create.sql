CREATE TABLE city_info (
  city_id SERIAL ,
  city_name VARCHAR(255)
);

ALTER TABLE operation_info 
ADD PRIMARY KEY (city_id);


CREATE TABLE state_info (
  state_id SERIAL .
  state_name VARCHAR(255)
);

ALTER TABLE state_info 
ADD PRIMARY KEY (
  state_id);


CREATE TABLE contact (
lid PRIMARY KEY REFERENCES license_info(lid),
  business_phone VARCHAR(255),
  street_address VARCHAR(255),
  zipcode VARCHAR(255),
  city_id BIGINT,
  state_id BIGINT,
  FOREIGN KEY (city_id) REFERENCES city_info(city_id),
  FOREIGN KEY (state_id) REFERENCES state_info(state_id)
);



CREATE TABLE license_info (
license_num PRIMARY KEY,
  owner_name VARCHAR(255),
  trade_name VARCHAR(255),

);



CREATE   TABLE operation_info AS
SELECT ROW_NUMBER() OVER () AS opid,  operation_type
FROM horticulture_master;



CREATE   TABLE   opid_lid (
  lid bigint,
    opid bigint,
  FOREIGN KEY (opid) REFERENCES operation_info(opid)
  FOREIGN KEY (lid) REFERENCES license_info(lid)
);
ALTER TABLE operation_info 
ADD PRIMARY KEY (opid, lid);