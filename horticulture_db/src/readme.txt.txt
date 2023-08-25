#################################################################################################################################################
	####################################	CSE 4/560 Data Models and Query Language Semester Project #########################################


Submitted By : 
Jon Kick (UBIT : jonkick)
Mancy Saxena (UBIT : mancysax)
			#######################################################################################################################
Data Source
In this project we are building horticulture database. The data can be found on :
https://data.ny.gov/Economic-Development/Nursery-Growers-and-Greenhouse/qke7-n4w8
			#######################################################################################################################


Master Table
The master table that imports the csv generated from above source is called : 
horticulture_master. From this table, following tables were populated

city_info 
contact
license_info
operation_info
opid_lid_info
state_info


#######################################################################################################################


Table Info

--Table customer_info was generated via python api faker.py:

    order_id = i
    cust_name = fake.name()
    items_purchased = random.randint(1, 100)
    cust_email = fake.email()
    cust_address = fake.address().replace(",", " ")
    cust_address = cust_address.replace("\n", " ")
    cust_phone = format_phone_number(fake.phone_number())
    employees_needed = random.randint(1, 100)

--city_info consists of the city names along with city id  which we got as row number
names of city was fetched from the master table, horticulture_master

CREATE TABLE city_info (
  city_id SERIAL ,
  city_name VARCHAR(255)
);

ALTER TABLE operation_info 
ADD PRIMARY KEY (city_id);


INSERT INTO state_info (city_name)
SELECT DISTINCT city
FROM horticulture_master;


state_info consists of the state names along with state id which we got as row number
names of state was fetched from the master table, horticulture_master


CREATE TABLE state_info (
  state_id SERIAL .
  state_name VARCHAR(255)
);

ALTER TABLE state_info 
ADD PRIMARY KEY (
  state_id);

INSERT INTO state_info (state_name)
SELECT DISTINCT state
FROM horticulture_master;


-- contact consists of business phone number, street addreess, zipcode, city id, state id of all the nursery growers / greenhouse owners
all information was fetched from the master table, horticulture_master. city_id and state_id was fecteched as a foreign key from city and state tables respectively

CREATE TABLE contact (
  lid VARCHAR PRIMARY KEY,
  business_phone VARCHAR(255),
  street_number VARCHAR(255),
	street_name VARCHAR(255),
	adressline_2 VARCHAR(255),
	adressline_3 VARCHAR(255),
	zip_code VARCHAR(255),
	city_id bigint,
	state_id bigint,
	FOREIGN KEY (city_id) REFERENCES city_info(city_id),
	FOREIGN KEY (state_id) REFERENCES state_info(state_id)
);

INSERT INTO contact (lid, business_phone, street_number, adressline_2, adressline_3, zip_code, city_id, state_id)
SELECT m.licensenumber, m.businessphone, m.streetnumber, m.addressline2, m.addressline3, m.zipcode, c.city_id, s.state_id
FROM horticulture_master m
JOIN city_info c ON m.city = c.city_name
JOIN state_info s ON m.state = s.state;


-- license_info consists of owner_name, license_number and trade name
all information was fetched from the master table, horticulture_master.


CREATE TABLE license_info (
license_num PRIMARY KEY,
  owner_name VARCHAR(255),
  trade_name VARCHAR(255),

);


INSERT INTO license_info (license_num, owner_name, trade_name)
SELECT lid,  owner_name, trade_name FROM horticulture_master


-- operation_info was created using the distinct values that were present horticulture_master.

CREATE   TABLE operation_info AS
SELECT ROW_NUMBER() OVER () AS opid,  operation_type
FROM horticulture_master;

-- opid_lid_info was a table that was contact decomposed into contact_info and opid_lid_info

CREATE   TABLE   opid_lid (
  lid bigint,
    opid bigint,
  FOREIGN KEY (opid) REFERENCES operation_info(opid)
  FOREIGN KEY (lid) REFERENCES license_info(lid)
);
ALTER TABLE operation_info 
ADD PRIMARY KEY (opid, lid);

INSERT   INTO   opid_lid (opid, lid )
SELECT   op.opid, horti.lid
FROM horticulture_master horti
JOIN operation_info op ON horti.operation_name = op.operation_name


########################################################################################################################################################


