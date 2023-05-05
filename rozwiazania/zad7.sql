--1
COMMIT oznacza zatwierdzenie dokonanych zmian
ROLLBACK oznacza anulowanie dokonanych zmian
SAVEPOINT tworzy kopię bazy danych do odpowiedniego momentu

--2
--WYKONANE

--3
INSERT INTO emp (
    id,
    first_name,
    last_name
) VALUES (
    26,
    'Jakub',
    'Zajac'
);

COMMIT;

--4
INSERT INTO emp (
    id,
    first_name,
    last_name,
    start_date,
    salary
) VALUES (
    27,
    'Jakub',
    'Zajac',
    TO_DATE('12/06/2012','DD/MM/YYYY'),
    13000
);
SELECT * FROM emp; --Dane dodane do tabeli
ROLLBACK;
SELECT * FROM emp; --Brak wcześniej dodanych danych w tabeli

--5
INSERT INTO emp (
    id,
    first_name,
    last_name,
    start_date,
    salary
) VALUES (
    27,
    'Jakub',
    'Zajac',
    TO_DATE('12/06/2012','DD/MM/YYYY'),
    13000
);
COMMIT;

--6

--a
UPDATE item
SET
    price = price * 1.15;

--b
SAVEPOINT S1;

--c
SELECT
    SUM(price)
FROM
    item;

--d
UPDATE item
SET
    price = price * 1.1;
-12018
--e
SAVEPOINT S2;

--f
SELECT
    SUM(price)
FROM
    item; 
--13219,92

--g
UPDATE item
SET
    price = price * 1.6;

--h
SELECT
    SUM(price)
FROM
    item; 
--21151,85

--i
ROLLBACK TO SAVEPOINT S2;

--j
SELECT
    SUM(price)
FROM
    item; 
--13219,92

--k
ROLLBACK TO SAVEPOINT S1;

--l
SELECT
    SUM(price)
FROM
    item; 
--12018

--m
COMMIT;

--7
SET AUTOCOMMIT ON; 

--8
CREATE TABLE region_copy
    AS
        SELECT
            *
        FROM
            region;

--9
INSERT INTO dept
    SELECT
        id + 100,
        substr(name, 0, 4),
        region_id
    FROM
        dept;

--10
INSERT INTO region_copy
    SELECT
        customer_id,
        name
    FROM
        customer,
        ord
    WHERE
        ord.customer_id = customer.id
    GROUP BY
        customer_id,
        name
    HAVING
        MAX(total) > 1000;

--11
UPDATE emp
SET
    salary = salary * 3,
    start_date = TO_DATE('31-12-2001', 'dd-mm-yyyy')
WHERE
    id = 27;

--12a
UPDATE product
SET
    suggested_whlsl_price = suggested_whlsl_price * 0.9
WHERE
    id IN (
        SELECT
            product_id
        FROM
            item
        GROUP BY
            product_id
        HAVING
            SUM(quantity) < 30
    );

--12b
UPDATE product
SET
    suggested_whlsl_price = suggested_whlsl_price * 1.08
WHERE
    id IN (
        SELECT
            product_id
        FROM
            (
                SELECT
                    product_id, SUM(quantity)
                FROM
                    item
                GROUP BY
                    product_id
                ORDER BY
                    SUM(quantity) DESC
            )
        WHERE
            ROWNUM <= 5
    );

--13
UPDATE emp
SET
    salary = salary * 1.3
WHERE
    title LIKE 'VP%';

--14
DELETE FROM emp
WHERE
    id = 27
    OR id = 26;

--15
DROP TABLE REGION_COPY;











