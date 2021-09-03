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

DROP MATERIALIZED VIEW Customer_count_materialized_view;

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


--trigger
-- ked sa vymaze vypujcka,ktora obsahuje pokuty, tak sa automaticky vymazu aj vsetky pokuty, ak nejake obsahuje
CREATE OR REPLACE TRIGGER trigger_fine_delete
BEFORE DELETE ON rental
FOR EACH ROW
BEGIN
    DELETE fine where fine.id = :old.id;

END;

--INSERTS
INSERT INTO person          VALUES(9905208654, 'Jan', 'Mrkvicka', TO_DATE('18/05/1999', 'DD/MM/YYYY'), '61200', 'Brno','Czech Republic','421905123456');
INSERT INTO person          VALUES(9508150663, 'Jozef', 'Tenky', TO_DATE('28/03/1997', 'DD/MM/YYYY'), '120', 'Bratislava','Slovak Republic','421905121456');
INSERT INTO person          VALUES(9912222320, 'Barbora', 'Gulata', TO_DATE('12/01/1989', 'DD/MM/YYYY'), '61230', 'Brno','Czech Republic','421905123756');
INSERT INTO person          VALUES(9508035933, 'Mirko', 'Lahky', TO_DATE('12/01/1987', 'DD/MM/YYYY'), '1245', 'Brno','Czech Republic','421905123759');
INSERT INTO employee        VALUES(1 ,9905208654);
INSERT INTO employee        VALUES(2 ,9912222320);
INSERT INTO customer        VALUES(1 ,9508150663);
INSERT INTO customer        VALUES(2 ,9508035933);
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
INSERT INTO rental          VALUES(1,TO_DATE('28/04/2020', 'DD/MM/YYYY'), TO_DATE('15/5/2020', 'DD/MM/YYYY'),42, 'Karneval',1,2);
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

-- ukazka triggeru pri delete - ked sa vymaze rental musia sa vymazat aj vsetky fines ktoré obsahuje
DELETE FROM rental where id=2;

-- procedura s exception
CREATE OR REPLACE PROCEDURE rental_summary
AS
    rental_count NUMBER;
	rental_price_sum NUMBER;
    fines_count NUMBER;
    fines_price_sum NUMBER;
    avg_rental_on_fines NUMBER;
BEGIN

    SELECT COUNT(*) INTO rental_count FROM rental;
    SELECT COUNT(*) INTO fines_count FROM fine;
    SELECT SUM(price) INTO rental_price_sum FROM rental;
    SELECT SUM(price) INTO fines_price_sum FROM fine;
    avg_rental_on_fines := rental_count / fines_count;
	DBMS_OUTPUT.put_line(
		'Number of all rentals: ' || rental_count ||
		    ' ,Number of all fines: ' || fines_count ||
	        ' ,Sum of all rental prices: ' || rental_price_sum||
		    ' ,Sum of all fines prices: ' || fines_price_sum||
	        ' ,Avg rental on fines: ' || avg_rental_on_fines);

    EXCEPTION WHEN ZERO_DIVIDE THEN
	BEGIN
		IF fines_count = 0 THEN
			DBMS_OUTPUT.put_line('Error! There is 0 fines, therefore zero division occurred!');
		END IF;

	END;

END;
-- zavolanie a ukazka procedury rental_summary
BEGIN rental_summary; END;


-- materializovany pohlad na vsetkych zakaznikov s vybranymi datami a pocet ich vypujcek s poctom pokut

CREATE MATERIALIZED VIEW Customer_count_materialized_view AS
    SELECT customer.id,
           person.name,
           person.surname,
           COUNT(rental.id) AS rentals_count
    FROM customer LEFT JOIN person ON customer.birth_number = person.birth_number
    LEFT JOIN rental ON customer.id = rental.id_customer
    GROUP BY customer.id, person.name, person.surname ;

-- zobrazenie materializovaneho pohladu
SELECT * FROM Customer_count_materialized_view;

-- pridanie privilegii
GRANT ALL ON costume_recommended_accessory TO xjurka08;
GRANT ALL ON rental_has_item TO xjurka08;
GRANT ALL ON reservation_reserves_item TO xjurka08;
GRANT ALL ON fine TO xjurka08;
GRANT ALL ON accessory TO xjurka08;
GRANT ALL ON costume TO xjurka08;
GRANT ALL ON item TO xjurka08;
GRANT ALL ON reservation TO xjurka08;
GRANT ALL ON rental TO xjurka08;
GRANT ALL ON employee TO xjurka08;
GRANT ALL ON customer_card TO xjurka08;
GRANT ALL ON customer TO xjurka08;
GRANT ALL ON person TO xjurka08;
GRANT ALL ON Customer_count_materialized_view TO xjurka08;
GRANT EXECUTE ON rental_summary TO xjurka08;

