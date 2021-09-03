--IDS projekt 1. SQL skript
-- David Spavor xspavo00
--Vojtech Jurka xjurka08
--DROPS
DROP TABLE costume_recommended_accessory;
DROP TABLE rental_has_item;
DROP TABLE reservation_reserves_item;
DROP TABLE fine;
DROP TABLE accessory;
DROP TABLE costume;
DROP TABLE item;
DROP TABLE reservation;
DROP TABLE rental;
DROP TABLE employee;
DROP TABLE customer_card;
DROP TABLE customer;
DROP TABLE person;

CREATE TABLE person (
    birth_number INTEGER,
    CHECK (REGEXP_LIKE(birth_number, '^[0-9][0-9](([0][0-9])|([1][0-2]))(([0][1-9])|([1-2][0-9])|([3])[0-1])[0-9][0-9][0-9][0-9]?$')),
    CHECK (MOD(birth_number,11)=0),
    name VARCHAR(50),
    surname VARCHAR(50),
    birth_date DATE,
    house_number INTEGER,
    city VARCHAR(50),
    state VARCHAR(50),
    mobile_number INTEGER,

    CONSTRAINT PK_birth_number PRIMARY KEY (birth_number)
);

CREATE TABLE employee(
     id INTEGER DEFAULT NULL,
     birth_number INTEGER,
    CHECK (REGEXP_LIKE(birth_number, '^[0-9][0-9](([0][0-9])|([1][0-2]))(([0][1-9])|([1-2][0-9])|([3])[0-1])[0-9][0-9][0-9][0-9]?$')),
     CHECK (MOD(birth_number,11)=0),

     CONSTRAINT PK_employee PRIMARY KEY (id),
     CONSTRAINT FK_employee FOREIGN KEY (birth_number) REFERENCES person (birth_number)
);

CREATE TABLE customer(
     id INTEGER,
     birth_number INTEGER,
     CHECK (REGEXP_LIKE(birth_number, '^[0-9][0-9](([0][0-9])|([1][0-2]))(([0][1-9])|([1-2][0-9])|([3])[0-1])[0-9][0-9][0-9][0-9]?$')),
     CHECK (MOD(birth_number,11)=0),
     card VARCHAR(8), CHECK ( length(id) = 8 ), CHECK (REGEXP_LIKE(id, '^[[:digit:]]{8}$')),

     CONSTRAINT PK_customer PRIMARY KEY (id),
     CONSTRAINT FK_customer FOREIGN KEY (birth_number) REFERENCES person (birth_number)
);

CREATE TABLE item (
    id INTEGER,
    manufacturer VARCHAR(50),
    material VARCHAR(50),
    description VARCHAR(500),
    category VARCHAR(50),
    date_made DATE,
    color VARCHAR(50),
    defects VARCHAR(500),
    id_employee INTEGER,

    CONSTRAINT PK_item PRIMARY KEY (id),
    CONSTRAINT  FK_item FOREIGN KEY  (id_employee)
        REFERENCES employee (id)
);



CREATE TABLE costume (
    id INTEGER,
    "size" VARCHAR(50),

    CONSTRAINT PK_costume PRIMARY KEY (id),
    CONSTRAINT FK_costume FOREIGN KEY (id)
        REFERENCES item (id)
);


CREATE TABLE accessory (
    id INTEGER,
    usage VARCHAR(50),

    CONSTRAINT PK_accessory PRIMARY KEY (id),
    CONSTRAINT FK_accessory FOREIGN KEY (id)
        REFERENCES item (id)
);



CREATE TABLE reservation (
    id INTEGER,
    date_from DATE,
    date_to DATE,
    id_customer INTEGER,

    CONSTRAINT PK_reservation PRIMARY KEY (id),
    CONSTRAINT FK_reservation FOREIGN KEY (id_customer)
        REFERENCES customer(id)
);

CREATE TABLE rental (
    id INTEGER,
    date_from DATE,
    date_to DATE,
    price INTEGER,
    event VARCHAR(50),
    id_employee INTEGER,
    id_customer INTEGER,

    CONSTRAINT PK_rental PRIMARY KEY (id),
    CONSTRAINT FK_rental_employee FOREIGN KEY (id_employee)
        REFERENCES employee(id),
    CONSTRAINT FK_rental_customer FOREIGN KEY (id_customer)
        REFERENCES customer(id)
);

CREATE TABLE fine (
    pid INTEGER,
    id INTEGER,
    price INTEGER,
    event VARCHAR(50),

    CONSTRAINT PK_fine PRIMARY KEY (pid),
    CONSTRAINT FK_fine FOREIGN KEY (id)
        REFERENCES rental (id)
);

CREATE TABLE costume_recommended_accessory (
    cid INTEGER,
    aid INTEGER,


    CONSTRAINT PK_costume_recommended_accessory PRIMARY KEY (cid, aid),
    CONSTRAINT FK_costume_recommended_accessory1 FOREIGN KEY (cid)
        REFERENCES costume (id),
    CONSTRAINT FK_costume_recommended_accessory2 FOREIGN KEY (aid)
        REFERENCES accessory (id)
);

CREATE TABLE rental_has_item (
    rid INTEGER,
    iid INTEGER,


    CONSTRAINT PK_rental_has_item PRIMARY KEY (rid, iid),
    CONSTRAINT RFK_rental_has_item FOREIGN KEY (rid)
        REFERENCES rental (id),
    CONSTRAINT IFK_rental_has_item FOREIGN KEY (iid)
        REFERENCES item (id)
);

CREATE TABLE reservation_reserves_item (
    rid INTEGER,
    iid INTEGER,


    CONSTRAINT PK_reservation_reserves_item PRIMARY KEY (rid, iid),
    CONSTRAINT RFK_reservation_reserves_item FOREIGN KEY (rid)
        REFERENCES reservation (id),
    CONSTRAINT IFK_reservation_reserves_item FOREIGN KEY (iid)
        REFERENCES item (id)
);

CREATE TABLE customer_card(
    id INTEGER,
    validity DATE,
    discount INTEGER, CHECK ( discount > 0 and discount <=100 ),
    type CHAR(50),
    id_customer INTEGER,

    CONSTRAINT PK_customer_card PRIMARY KEY (id),
    CONSTRAINT FK_customer_card FOREIGN KEY (id_customer) REFERENCES customer (id)

);

--INSERTS
INSERT INTO person          VALUES(9905208654, 'Jan', 'Mrkvicka', TO_DATE('18/05/1999', 'DD/MM/YYYY'), '61200', 'Brno','Czech Republic','421905123456');
INSERT INTO person          VALUES(9508150663, 'Jozef', 'Tenky', TO_DATE('28/03/1997', 'DD/MM/YYYY'), '120', 'Bratislava','Slovak Republic','421905121456');
INSERT INTO person          VALUES(9912222320, 'Barbora', 'Gulata', TO_DATE('12/01/1989', 'DD/MM/YYYY'), '61230', 'Brno','Czech Republic','421905123756');
INSERT INTO employee        VALUES(1 ,9905208654);
INSERT INTO employee        VALUES(2 ,9912222320);
INSERT INTO customer        VALUES(1 ,9508150663,'12345677');
INSERT INTO customer_card   VALUES(1, TO_DATE('28/09/2032', 'DD/MM/YYYY'),50,'gold card',1);
INSERT INTO customer_card   VALUES(2 , TO_DATE('08/09/2032', 'DD/MM/YYYY'),50,'gold card',1);
INSERT INTO customer_card   VALUES(3 , TO_DATE('28/11/2032', 'DD/MM/YYYY'),30,'silver card',1);
INSERT INTO customer_card   VALUES(4 , TO_DATE('28/09/2032', 'DD/MM/YYYY'),30,'silver card',1);
INSERT INTO customer_card   VALUES(5 , TO_DATE('18/02/2032', 'DD/MM/YYYY'),30,'silver card',1);
INSERT INTO customer_card   VALUES(6 , TO_DATE('10/01/2032', 'DD/MM/YYYY'),15,'bronze card',1);
INSERT INTO reservation     VALUES(1, TO_DATE('28/03/2020', 'DD/MM/YYYY'), TO_DATE('18/12/2020', 'DD/MM/YYYY'),1);
INSERT INTO reservation     VALUES(2, TO_DATE('08/07/2020', 'DD/MM/YYYY'), TO_DATE('15/2/2021', 'DD/MM/YYYY'),1);
INSERT INTO reservation     VALUES(3, TO_DATE('10/01/2020', 'DD/MM/YYYY'), TO_DATE('26/1/2021', 'DD/MM/YYYY'),1);
INSERT INTO reservation     VALUES(4, TO_DATE('31/08/2020', 'DD/MM/YYYY'), TO_DATE('28/9/2021', 'DD/MM/YYYY'),1);
INSERT INTO rental          VALUES(1,TO_DATE('28/04/2020', 'DD/MM/YYYY'), TO_DATE('15/5/2020', 'DD/MM/YYYY'),42, 'Karneval',1,1);
INSERT INTO rental          VALUES(2,TO_DATE('18/06/2020', 'DD/MM/YYYY'), TO_DATE('13/7/2020', 'DD/MM/YYYY'),34, 'Party',1,1);
INSERT INTO rental          VALUES(3,TO_DATE('04/02/2020', 'DD/MM/YYYY'), TO_DATE('05/3/2020', 'DD/MM/YYYY'),58, 'Karneval',1,1);
INSERT INTO rental          VALUES(4,TO_DATE('07/03/2020', 'DD/MM/YYYY'), TO_DATE('01/8/2020', 'DD/MM/YYYY'),60, 'Skola',2,1);
INSERT INTO rental          VALUES(5,TO_DATE('08/03/2020', 'DD/MM/YYYY'), TO_DATE('01/9/2020', 'DD/MM/YYYY'),60, 'Skola',2,1);
INSERT INTO fine            VALUES(1,1, 10,'neskore vratenie');
INSERT INTO fine            VALUES(2,1, 20,'neskore vratenie');
INSERT INTO fine            VALUES(3,1, 30,'neskore vratenie');
INSERT INTO item            VALUES (1, 'Costume s.r.o.', 'silk', 'blue and black', 'party costumes', TO_DATE('25/03/2003', 'DD/MM/YYYY'), 'blue', 'none',2);
INSERT INTO costume         VALUES (1, 'XL');
INSERT INTO item            VALUES (2, 'Costume s.r.o.', 'cotton', 'blue and white', 'hat', TO_DATE('25/03/2003', 'DD/MM/YYYY'), 'blue', 'none',2);
INSERT INTO accessory       VALUES (2, 'attach to a tie');
INSERT INTO costume_recommended_accessory   VALUES (1, 2);
INSERT INTO reservation_reserves_item       VALUES (1, 1);

--SELECTS
--ziskaj vsetkych zamestnacov spojenim dvoch tabuliek
SELECT * FROM employee NATURAL JOIN person;

--ziskaj vsetkych zakaznikov spojenim dvoch tabuliek
SELECT * FROM customer NATURAL JOIN person;

--zobraz vsechny rezervace a jejich predmety
SELECT reservation.id, reservation.date_from, reservation.date_to, item.id, item.manufacturer, item.material, item.description, item.category, item.date_made, item.color, item.defects
FROM reservation JOIN reservation_reserves_item ON reservation.id = reservation_reserves_item.rid JOIN item ON reservation_reserves_item.iid = item.id;

--ziskaj pocet typov kariet, ktore vlastni clovek
SELECT COUNT(customer_card.id),type FROM customer_card GROUP BY type;

--zobraz celkovou vysi vsech pokut kazde vypujcky
SELECT rental.id, SUM(fine.price)
FROM fine JOIN rental ON fine.id = rental.id
GROUP BY rental.id;

--zobraz vsechny zakazniky, kteri maji zapsanou pokutu
SELECT person.name, person.surname
FROM person NATURAL JOIN customer
WHERE EXISTS(SELECT * FROM customer JOIN rental on customer.id = rental.id_customer JOIN fine f on rental.id = f.id);

--ziskaj zamestnancov, ktorí zprostredkovali vypujcky, kde udalost zapujcenia bola 'Karneval' alebo 'Party'
SELECT * FROM employee NATURAL JOIN person WHERE id IN(SELECT id_employee FROM rental WHERE event IN('Karneval','Party')) ;

