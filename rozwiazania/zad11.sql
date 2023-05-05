--1
DECLARE
    a  NUMBER := 21;
    b  CONSTANT VARCHAR2(25) := 'Jakub Zajac';
    c  DATE := TO_DATE('02-06-2021', 'DD-MM-YYYY');
BEGIN
    dbms_output.put_line(a);
    dbms_output.put_line(b);
    dbms_output.put_line(c);
END;
/

--2
DECLARE
    a  DATE := TO_DATE('26/11/1997', 'DD/MM/YYYY');
    b  DATE := sysdate;
BEGIN
    dbms_output.put_line(to_char(floor(b - a))
                         || ' DAYS');
    dbms_output.put_line(to_char(floor((b - a) / 7))
                         || ' WEEKS');

    dbms_output.put_line(to_char(floor((b - a) / 365))
                         || ' YEARS');

END;
/
--3
DECLARE
    name       emp.first_name%TYPE;
    last_name  emp.last_name%TYPE;
BEGIN
    SELECT
        first_name,
        last_name
    INTO
        name,
        last_name
    FROM
        emp
    WHERE
        salary = (
            SELECT
                MAX(salary)
            FROM
                emp
        );

    dbms_output.put_line('MAX: '
                         || name
                         || ' '
                         || last_name);
    SELECT
        first_name,
        last_name
    INTO
        name,
        last_name
    FROM
        emp
    WHERE
        salary = (
            SELECT
                MIN(salary)
            FROM
                emp
        );

    dbms_output.put_line('MIN: '
                         || name
                         || ' '
                         || last_name);
EXCEPTION
    WHEN too_many_rows THEN
        dbms_output.put_line('Wiecej niz jedna osoba zarabia najmniej/najwiecej');
END;
/

--4a
DECLARE
    name       VARCHAR2(25);
    last_name  VARCHAR2(25);
    CURSOR c IS
    SELECT
        first_name,
        last_name
    FROM
        emp;

BEGIN
    OPEN c;
    LOOP
        FETCH c INTO
            name,
            last_name;
        EXIT WHEN c%notfound;
        dbms_output.put_line(c%rowcount
                             || ' '
                             || name
                             || ' '
                             || last_name);

    END LOOP;

    CLOSE c;
END;
/

--4b
DECLARE
    name       VARCHAR2(25);
    last_name  VARCHAR2(25);
BEGIN
    FOR c IN(
        SELECT 
            id, first_name, last_name
        FROM
            emp
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(c.id||' '||c.first_name||' '||c.last_name);
    END LOOP;
END;
/

--5
DECLARE
    date_from                 DATE := TO_DATE('13/08/1992', 'DD/MM/YYYY');
    date_to                   DATE := TO_DATE('15/10/1992', 'DD/MM/YYYY');
    o_id                   ord.id%TYPE;
    o_customer_id          ord.customer_id%TYPE;
    o_sales_rep_id         ord.sales_rep_id%TYPE;
    o_date_ordered         ord.date_ordered%TYPE;
    o_date_shipped         ord.date_shipped%TYPE;
    o_total                ord.total%TYPE;
    o_customer_name        customer.name%TYPE;
    o_sales_rep_name       emp.first_name%TYPE;
    o_sales_rep_last_name  emp.last_name%TYPE;
    CURSOR i IS
    SELECT
        id,
        customer_id,
        sales_rep_id,
        date_ordered,
        date_shipped,
        total
    FROM
        ord
    WHERE
            date_ordered > date_from
        AND date_ordered < date_to
    ORDER BY
        id;

BEGIN
    OPEN i;
    LOOP
        FETCH i INTO
            o_id,
            o_customer_id,
            o_sales_rep_id,
            o_date_ordered,
            o_date_shipped,
            o_total;
        EXIT WHEN i%notfound;
        SELECT
            first_name,
            last_name
        INTO
            o_sales_rep_name,
            o_sales_rep_last_name
        FROM
            emp
        WHERE
            id = o_sales_rep_id;

        SELECT
            name
        INTO o_customer_name
        FROM
            customer
        WHERE
            id = o_customer_id;

        dbms_output.put_line(i%rowcount
                             || ' id: '
                             || o_id
                             || '  imie: '
                             || o_customer_name
                             || ' data zamowienia:'
                             || o_date_ordered
                             || ' data dostarczenia'
                             || o_date_shipped
                             || ' reprezentant: '
                             || o_sales_rep_name
                             || ' '
                             || o_sales_rep_last_name
                             || ' koszt zamowienia: '
                             || o_total);

    END LOOP;

    CLOSE i;
END;
/

--6
DECLARE
    srednia NUMBER;
BEGIN
    SELECT
        AVG(salary)
    INTO srednia
    FROM
        emp;

    FOR i IN (
        SELECT
            *
        FROM
            emp_new
        ORDER BY
            salary
    ) LOOP
        IF ( i.salary < srednia / 2 ) THEN
            UPDATE emp_new
            SET
                salary = ( salary * 1.2 )
            WHERE
                id = i.id;

        ELSIF (
            i.salary <= srednia / 2
            AND i.salary > srednia * ( 5 / 6 )
        ) THEN
            UPDATE emp_new
            SET
                salary = ( salary * 1.1 )
            WHERE
                id = i.id;

        ELSE
            UPDATE emp_new
            SET
                salary = ( salary * 1.05 )
            WHERE
                id = i.id;

        END IF;
    END LOOP;

END;
/