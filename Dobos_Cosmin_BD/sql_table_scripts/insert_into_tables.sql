@ create_tables.sql

/* addresses */
INSERT INTO addresses (address_id, street_address, street_number, city, country) VALUES (10, 'Str. Mihai Eminescu', '23 B', 'Iasi', 'Romania');
INSERT INTO addresses (street_address, street_number, city, country) VALUES ('Str. Nationala', '34/ 17', 'Bucuresti', 'Romania');
INSERT INTO addresses (street_address, street_number, city, country) VALUES ('Str. Romana', '43', 'Cluj', 'Romania');
INSERT INTO addresses (street_address, street_number, city, country) VALUES ('Str. Unirii', '34 C', 'Kiev', 'Ucraina');
INSERT INTO addresses (street_address, street_number, city, country) VALUES ('Str. Vadim Tudor', '23 A', 'Budapesta', 'Ungaria');
INSERT INTO addresses (street_address, street_number, city, country) VALUES ('Bulevardul Timisoara', '1', 'Chisinau', 'Republica Moldova');
INSERT INTO addresses (street_address, street_number, city, country) VALUES ('Str. Plopilor', '44', 'Cluj-Napoca', 'Romania');
INSERT INTO addresses (street_address, street_number, city, country) VALUES ('Champs Elysees Street', '34', 'Paris', 'France');
INSERT INTO addresses (street_address, street_number, city, country) VALUES ('Champs Elysees Street', '12', 'Paris', 'France');


/* pharmacies */
INSERT INTO pharmacies (pharmacy_name, address_id) VALUES ('Catena', (select address_id from addresses where street_address = 'Str. Mihai Eminescu' and street_number = '23 B' and city = 'Iasi' and country='Romania'));
INSERT INTO pharmacies (pharmacy_name, address_id) VALUES ('Catena', (select address_id from addresses where street_address = 'Str. Nationala' and street_number = '34/ 17' and city = 'Bucuresti' and country='Romania'));
INSERT INTO pharmacies (pharmacy_name, address_id) VALUES ('Helpnet', 2);
INSERT INTO pharmacies (pharmacy_name, address_id) VALUES ('Orient', 3);


/* producers */
INSERT INTO producers (producer_name, address_id) VALUES ('Novartis', (select address_id from addresses where street_address = 'Champs Elysees Street' 
    and street_number = '34' and city = 'Paris' and country='France'));
INSERT INTO producers (producer_name, address_id) VALUES ('France Pharmacy', 8);

/* drugs */
INSERT INTO drugs (drug_name, producer_id) VALUES ('Crema de maini',
    (SELECT producer_id FROM producers p, addresses adr WHERE p.address_id = adr.address_id AND p.producer_name = 'Novartis' AND adr.street_address = 'Champs Elysees Street' 
        AND adr.street_number = '34' AND adr.city = 'Paris' AND adr.country='France'));

INSERT INTO drugs (drug_name, producer_id) VALUES ('Pasta de dinti',
    (SELECT producer_id FROM producers p, addresses adr WHERE p.address_id = adr.address_id AND p.producer_name = 'Novartis' AND adr.street_address = 'Champs Elysees Street' 
        AND adr.street_number = '34' AND adr.city = 'Paris' AND adr.country='France'));
INSERT INTO drugs (drug_name, producer_id, description) VALUES ('Complex vitamina B', 2, 'Ajuta mult la memorie ');
INSERT INTO drugs (drug_name, producer_id, description) VALUES ('Complex vitamina C', 2,'Ajuta la raceala');
INSERT INTO drugs (drug_name, producer_id, description) VALUES ('Paracetamol', 1,'Ajuta la dureri');




/* local drugs */
INSERT INTO local_drugs (pharmacy_id, drug_id, price, expiration_date, quantity) VALUES (
(SELECT pharmacy_id FROM pharmacies f, addresses adr WHERE f.address_id = adr.address_id AND f.pharmacy_name = 'Catena' AND adr.street_address = 'Str. Mihai Eminescu' 
        AND adr.street_number = '23 B' AND adr.city = 'Iasi' AND adr.country='Romania'),
(SELECT drug_id FROM drugs d, producers p, addresses adr WHERE d.drug_name = 'Crema de maini' and d.producer_id = p.producer_id AND p.address_id = adr.address_id 
        AND p.producer_name = 'Novartis' AND adr.street_address = 'Champs Elysees Street' AND adr.street_number = '34' AND adr.city = 'Paris' AND adr.country='France'),
100, to_date('2020-08-29', 'YYYY-MM-DD'), 100);

INSERT INTO local_drugs (pharmacy_id, drug_id, price, expiration_date, quantity) VALUES (
(SELECT pharmacy_id FROM pharmacies f, addresses adr WHERE f.address_id = adr.address_id AND f.pharmacy_name = 'Catena' AND adr.street_address = 'Str. Mihai Eminescu' AND adr.street_number = '23 B' AND adr.city = 'Iasi' AND adr.country='Romania'),
(SELECT drug_id FROM drugs d, producers p, addresses adr WHERE d.drug_name = 'Pasta de dinti' and d.producer_id = p.producer_id AND p.address_id = adr.address_id AND p.producer_name = 'Novartis' AND adr.street_address = 'Champs Elysees Street' AND adr.street_number = '34' AND adr.city = 'Paris' AND adr.country='France'),
50, to_date('2020-08-29', 'YYYY-MM-DD'), 20);

INSERT INTO local_drugs (pharmacy_id, drug_id, price, expiration_date, quantity) VALUES (4, 3, 15.75, to_date('2020-10-29', 'YYYY-MM-DD'), 100);
INSERT INTO local_drugs (pharmacy_id, drug_id, price, expiration_date, quantity) VALUES (4, 4, 18, to_date('2020-10-29', 'YYYY-MM-DD'), 100);
INSERT INTO local_drugs (pharmacy_id, drug_id, price, expiration_date, quantity) VALUES (2, 5, 40, to_date('2020-10-29', 'YYYY-MM-DD'), 100);

/* local bills */
INSERT INTO bills (issue_date) VALUES (DEFAULT);
INSERT INTO bills (issue_date) VALUES (DEFAULT);
INSERT INTO bills (issue_date) VALUES (to_date('2020-08-29', 'YYYY-MM-DD'));
INSERT INTO bills (issue_date) VALUES (to_date('2020-08-28', 'YYYY-MM-DD'));

/* local orders */
/* PRIMA FACTURA */
INSERT INTO orders (bill_id, local_drug_id, quantity) VALUES (1, 1, 100);
INSERT INTO orders (bill_id, local_drug_id, quantity) VALUES (1, 2, 10);
/* A DOUA FACTURA */
INSERT INTO orders (bill_id, local_drug_id, quantity) VALUES (2, 3, 10);
INSERT INTO orders (bill_id, local_drug_id, quantity) VALUES (2, 4, 2);
INSERT INTO orders (bill_id, local_drug_id, quantity) VALUES (2, 5, 2);

SELECT * FROM local_drugs;

/* AFISARE */
/* afisare adrese*/
SELECT * FROM addresses;

/* afisare farmacii*/
SELECT * FROM pharmacies p, addresses adr where p.address_id = adr.address_id;

/* afisare producatori*/
SELECT * FROM producers p, addresses adr where p.address_id = adr.address_id;

/* afisare medicamente*/
SELECT d.drug_id, d.drug_name, COALESCE(d.description, 'No Description') as description, p.producer_name, adr.city, adr.country FROM drugs d, producers p, addresses adr 
    where p.address_id = adr.address_id and d.producer_id = p.producer_id;

/* afisare medicamente prezente la farmacii specifice (medicamente locale)*/
SELECT l.LOCAL_DRUG_ID, d.DRUG_NAME, ph.PHARMACY_NAME, adr.COUNTRY, adr.CITY, l.PRICE, l.EXPIRATION_DATE, l.QUANTITY, prod.PRODUCER_NAME, COALESCE(DESCRIPTION, 'Not Description') as description
    from local_drugs l inner join drugs d on l.drug_id = d.drug_id inner join pharmacies ph on l.pharmacy_id = ph.pharmacy_id inner join addresses adr on ph.address_id = adr.address_id 
        inner join producers prod on prod.producer_id = d.producer_id;

/* afisare produse prezente in fiecare factura*/
SELECT b.bill_id,  d.drug_name, o.quantity, b.issue_date, ld.price, ld.expiration_date, (o.quantity * ld.price) TOTAL FROM orders o, bills b, local_drugs ld, drugs d, pharmacies ph 
    where o.bill_id = b.bill_id and o.local_drug_id = ld.local_drug_id and ld.pharmacy_id = ph.pharmacy_id and d.drug_id = ld.drug_id ORDER BY o.bill_id ASC;

/* afisare facturi cu pretul total achitat*/
SELECT b.bill_id, MAX(b.issue_date) AS issue_date, SUM(o.quantity * ld.price) TOTAL FROM bills b, orders o, local_drugs ld
    where o.bill_id = b.bill_id and ld.local_drug_id = o.local_drug_id GROUP BY b.bill_id;


COMMIT;

