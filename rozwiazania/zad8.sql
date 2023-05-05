--1
SET ECHO OFF

ALTER SESSION SET nls_date_language = 'american';

ALTER SESSION SET nls_date_format = 'dd-mon-yyyy';

ALTER SESSION SET nls_numeric_characters = '.,';

Rem Drop tables.
DROP TABLE klient CASCADE CONSTRAINTS;

DROP TABLE zamowienia CASCADE CONSTRAINTS;

DROP TABLE pozycja CASCADE CONSTRAINTS;

DROP TABLE produkt CASCADE CONSTRAINTS;

Rem Create and populate tables.

CREATE TABLE klient (
    customerid   INTEGER
        CONSTRAINT klient_pesel NOT NULL,
    name         VARCHAR(25)
        CONSTRAINT klient_name NOT NULL,
    surnamer     VARCHAR(35)
        CONSTRAINT klient_surname NOT NULL,
    addr_street  VARCHAR(45),
    addr_zip     VARCHAR(5),
    addr_city    VARCHAR(45),
    login        VARCHAR(14)
        CONSTRAINT klient_login NOT NULL,
    passwd       VARCHAR(12)
        CONSTRAINT klient_passwd NOT NULL,
    CONSTRAINT klient_customerid_pk PRIMARY KEY ( customerid )
);

CREATE TABLE zamowienia (
    orderid     INTEGER
        CONSTRAINT zamowienia_orderid NOT NULL,
    idcustomer  INTEGER
        CONSTRAINT zamowienia_idcustomer NOT NULL,
    ordate      DATE,
    CONSTRAINT zamowienia_id_kat_pk PRIMARY KEY ( orderid )
);

CREATE TABLE pozycja (
    idproduct  INTEGER
        CONSTRAINT pozycja_idproduct NOT NULL,
    idorder    INTEGER
        CONSTRAINT pozycja_idorder NOT NULL,
    quantity   INTEGER,
    CONSTRAINT pozycja_double_pk PRIMARY KEY ( idproduct,
                                               idorder )
);

CREATE TABLE produkt (
    productid    INTEGER
        CONSTRAINT produkt_productid NOT NULL,
    name         VARCHAR2(35)
        CONSTRAINT produkt_pesel NOT NULL,
    price_net    FLOAT,
    price_gross  FLOAT,
    description  CLOB,
    CONSTRAINT produkt_productid_pk PRIMARY KEY ( productid )
);

Rem Add foreign key constraints.

ALTER TABLE zamowienia
    ADD CONSTRAINT zamowienia_klient_id_fk FOREIGN KEY ( idcustomer )
        REFERENCES klient ( customerid );

ALTER TABLE pozycja
    ADD CONSTRAINT pozycja_ord_id_fk FOREIGN KEY ( idorder )
        REFERENCES zamowienia ( orderid );

ALTER TABLE pozycja
    ADD CONSTRAINT pozycja_produkt_id_fk FOREIGN KEY ( idproduct )
        REFERENCES produkt ( productid );

SET ECHO ON

--2
--1 
ALTER TABLE klient ADD email VARCHAR2(20)
    CONSTRAINT klient_email NOT NULL;

--2
ALTER TABLE klient RENAME COLUMN addr_zip TO addr_postalcode;

ALTER TABLE klient MODIFY
    addr_postalcode CHAR(7);

--3
ALTER TABLE zamowienia ADD order_in_progress VARCHAR2(3);

ALTER TABLE zamowienia
    ADD CONSTRAINT ord_order_in_progress_ck CHECK ( order_in_progress IN ( 'YES', 'NO' ) );

--4
ALTER TABLE zamowienia ADD date_shipped DATE;

--5
ALTER TABLE zamowienia RENAME COLUMN order_in_progress TO order_status;

ALTER TABLE zamowienia MODIFY
    order_status VARCHAR2(25);

ALTER TABLE zamowienia DROP CONSTRAINT zam_order_in_progress_ck;

ALTER TABLE zamowienia
    ADD CONSTRAINT zam_order_status_ck CHECK ( order_status IN ( 'Nowe zamówienie', 'Realizowane', 'Przesyłka wysłana', 'Realizacja zakończona' ) );
--6
ALTER TABLE produkt ADD tax INTEGER;

ALTER TABLE produkt DROP COLUMN price_gross;

ALTER TABLE produkt ADD price_gross FLOAT AS ( PRICE_NET + PRICE_NET * TAX * 0 . 01 );

--7
CREATE INDEX customer_index ON
    klient (
        surnamer,
        login,
        email
    );

--8
ALTER TABLE klient ADD CONSTRAINT login_unique UNIQUE ( login );