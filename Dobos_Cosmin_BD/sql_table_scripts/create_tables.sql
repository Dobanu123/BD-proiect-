@ delete_tables.sql

CREATE TABLE addresses(
    address_id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    street_address VARCHAR2(50) NOT NULL,
	street_number VARCHAR2(20) NOT NULL,
    city VARCHAR2(30) NOT NULL,
    country VARCHAR2(30) NOT NULL,
    CONSTRAINT address_id_pk PRIMARY KEY (address_id),
    CONSTRAINT address_id_uk UNIQUE (street_address, street_number, city, country));

CREATE TABLE pharmacies(
    pharmacy_id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    pharmacy_name VARCHAR2(20) NOT NULL,
    address_id NUMBER(4) NOT NULL,
    CONSTRAINT pharmacy_id_pk PRIMARY KEY(pharmacy_id),
    CONSTRAINT pharmacy_address_id_fk FOREIGN KEY (address_id) REFERENCES addresses,
    CONSTRAINT pharmacy_uk UNIQUE (address_id));
    
CREATE TABLE producers(
    producer_id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    producer_name VARCHAR2(20) NOT NULL,
    address_id NUMBER(4) NOT NULL,
    CONSTRAINT producer_id_pk PRIMARY KEY(producer_id),
    CONSTRAINT producer_address_id_fk FOREIGN KEY (address_id) REFERENCES addresses,
    CONSTRAINT producer_uk UNIQUE (address_id));
	
CREATE TABLE drugs(
    drug_id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    drug_name VARCHAR2(20) NOT NULL,
    producer_id NUMBER NOT NULL,
    description VARCHAR2(100),
    CONSTRAINT drug_id_pk PRIMARY KEY(drug_id),
    CONSTRAINT drug_producer_id_fk FOREIGN KEY(producer_id) REFERENCES producers,
    CONSTRAINT drug_uk UNIQUE (drug_name, producer_id, description));
    

CREATE TABLE local_drugs(
	local_drug_id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	pharmacy_id NUMBER NOT NULL,
	drug_id NUMBER NOT NULL,
	price NUMBER(6, 2) NOT NULL,
	expiration_date DATE NOT NULL,
	quantity NUMBER(4) NOT NULL,
	CONSTRAINT local_drug_id_pk PRIMARY KEY(local_drug_id),
	CONSTRAINT local_drug_producer_id_fk FOREIGN KEY(pharmacy_id) REFERENCES pharmacies,
    CONSTRAINT local_drug_drug_id_fk FOREIGN KEY(drug_id) REFERENCES drugs,
    CONSTRAINT price_range_ch CHECK (price > 0 and price < 1000000),
    CONSTRAINT local_drugs_quantity_range_ch CHECK (quantity > 0 and quantity < 1000000),
	CONSTRAINT local_drug_uk UNIQUE (drug_id, pharmacy_id, price, expiration_date, quantity));
   
   
CREATE TABLE bills(
	bill_id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	issue_date DATE DEFAULT sysdate NOT NULL,
	CONSTRAINT bill_id_pk PRIMARY KEY(bill_id),
    CONSTRAINT bills_uk UNIQUE (bill_id, issue_date));

   
CREATE TABLE orders(
    bill_id NUMBER NOT NULL,
    local_drug_id NUMBER NOT NULL,
    quantity NUMBER(4) NOT NULL,
    CONSTRAINT bill_id_fk FOREIGN KEY(bill_id) REFERENCES bills,
	CONSTRAINT local_drug_id_fk FOREIGN KEY(local_drug_id) REFERENCES local_drugs,
    CONSTRAINT quantity_range_ch CHECK (quantity > 0 and quantity < 10000)
);


