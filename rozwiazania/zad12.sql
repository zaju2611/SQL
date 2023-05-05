-- 0
CREATE SEQUENCE sequence_emp START WITH 26 INCREMENT BY 1;

CREATE TABLE top_n_emp
    AS
        SELECT
            id,
            last_name,
            first_name,
            salary
        FROM
            emp;

CREATE OR REPLACE PACKAGE BODY pracownicy AS
-- 1
    PROCEDURE add_emp (
        in_last_name       emp.last_name%TYPE,
        in_first_name      emp.first_name%TYPE,
        in_userid          emp.userid%TYPE,
        in_start_date      emp.start_date%TYPE,
        in_manager_id      emp.manager_id%TYPE,
        in_title           emp.title%TYPE,
        in_dept_id         emp.dept_id%TYPE,
        in_salary          emp.salary%TYPE,
        in_commission_pct  emp.commission_pct%TYPE
    ) IS
        uv_last_name_null EXCEPTION;
    BEGIN
        IF in_last_name IS NULL THEN
            RAISE uv_last_name_null;
        END IF;
        INSERT INTO emp (
            id,
            last_name,
            first_name,
            userid,
            start_date,
            manager_id,
            title,
            dept_id,
            salary,
            commission_pct
        )
            SELECT
                emp_id_seq.NEXTVAL,
                in_last_name,
                in_first_name,
                in_userid,
                in_start_date,
                in_manager_id,
                in_title,
                in_dept_id,
                in_salary,
                in_commission_pct
            FROM
                emp;

    EXCEPTION
        WHEN uv_last_name_null THEN
            dbms_output.put_line('last_name nie moze byc null');
        WHEN value_error THEN
            dbms_output.put_line('Zly format danych');
    END add_emp;

-- 2
    PROCEDURE change_emp (
        in_id              emp.id%TYPE,
        in_last_name       emp.last_name%TYPE,
        in_first_name      emp.first_name%TYPE,
        in_userid          emp.userid%TYPE,
        in_start_date      emp.start_date%TYPE,
        in_manager_id      emp.manager_id%TYPE,
        in_title           emp.title%TYPE,
        in_dept_id         emp.dept_id%TYPE,
        in_salary          emp.salary%TYPE,
        in_commission_pct  emp.commission_pct%TYPE
    ) IS
        uv_last_name_null EXCEPTION;
    BEGIN
        IF in_last_name IS NULL THEN
            RAISE uv_last_name_null;
        END IF;
        UPDATE emp
        SET
            last_name = in_last_name,
            first_name = in_first_name,
            userid = in_userid,
            start_date = in_start_date,
            manager_id = in_manager_id,
            title = in_title,
            dept_id = in_dept_id,
            salary = in_salary,
            commission_pct = in_commission_pct
        WHERE
            id = in_id;

    EXCEPTION
        WHEN uv_last_name_null THEN
            dbms_output.put_line('last_name nie moze byc null');
        WHEN value_error THEN
            dbms_output.put_line('Zly format danych');
    END change_emp;

-- 3
    PROCEDURE delete_emp (
        in_id emp.id%TYPE
    ) IS
    BEGIN
        DELETE FROM emp
        WHERE
            id = in_id;

    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('Nie znaleziono danych');
    END delete_emp;

-- 4
    PROCEDURE change_salary (
        in_id       emp.id%TYPE,
        in_percent  NUMBER
    ) IS
    BEGIN
        UPDATE emp
        SET
            salary = ( salary + ( ( in_percent / 100 ) * salary ) )
        WHERE
            id = in_id;

    END change_salary;

-- 5
    PROCEDURE top_n_emp (
        in_n NUMBER
    ) IS

        uv_last_name   emp.last_name%TYPE;
        uv_first_name  emp.first_name%TYPE;
        uv_salary      emp.salary%TYPE;
        CURSOR ctopn IS
        SELECT
            last_name,
            first_name,
            salary
        FROM
            (
                SELECT
                    last_name,
                    first_name,
                    salary
                FROM
                    emp
                ORDER BY
                    salary DESC
            )
        WHERE
            ROWNUM <= in_n;

    BEGIN
        OPEN ctopn;
        LOOP
            FETCH ctopn INTO
                uv_last_name,
                uv_first_name,
                uv_salary;
            EXIT WHEN ctopn%notfound;
            dbms_output.put_line(uv_last_name
                                 || ' '
                                 || uv_first_name
                                 || ' '
                                 || uv_salary);

            INSERT INTO emptopn (
                last_name,
                first_name,
                salary
            )
                SELECT
                    uv_last_name,
                    uv_first_name,
                    uv_salary
                FROM
                    top_n_emp;

        END LOOP;

        CLOSE ctopn;
    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('Nie znaleziono danych');
    END top_n_emp;

-- 6
    PROCEDURE change_dept (
        in_id       emp.id%TYPE,
        in_dept_id  emp.dept_id%TYPE
    ) IS
    BEGIN
        UPDATE emp
        SET
            dept_id = in_dept_id
        WHERE
            id = in_id;

    EXCEPTION
        WHEN uv_deptid_not_exist THEN
            dbms_output.put_line('brak dept_id/nie istnieje');
    END change_dept;

-- 7
    FUNCTION stat_emp (
        in_parameter VARCHAR2
    ) RETURN NUMBER AS
        uv_value emp.salary%TYPE;
    BEGIN
        IF in_parameter = 'MAX' THEN
            SELECT
                MAX(salary)
            INTO uv_value
            FROM
                emp;

        ELSIF in_parameter = 'MIN' THEN
            SELECT
                MIN(salary)
            INTO uv_value
            FROM
                emp;

        ELSIF in_parameter = 'SUM' THEN
            SELECT
                SUM(salary)
            INTO uv_value
            FROM
                emp;

        ELSIF in_parameter = 'AVG' THEN
            SELECT
                AVG(salary)
            INTO uv_value
            FROM
                emp;

        ELSE
            dbms_output.put_line('zły parametr');
            uv_value := NULL;
        END IF;

        RETURN uv_value;
    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('nie odnaleziono danych');
    END stat_emp;

END pracownicy;
/