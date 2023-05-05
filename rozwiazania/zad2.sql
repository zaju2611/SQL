--1
SELECT 
    LOWER(FIRST_NAME),
    LOWER(LAST_NAME),
    INITCAP(USERID),
    UPPER(TITLE)
FROM
    emp
WHERE
    TITLE like 'VP%';

--2
SELECT
    FIRST_NAME, LAST_NAME
FROM 
    emp
WHERE
    LAST_NAME like INITCAP('PATEL');

--3
SELECT
    NAME ||' - '||COUNTRY "NAZWA i PAŃSTWO"
FROM
    customer
WHERE
    CREDIT_RATING LIKE 'GOOD';

--4
SELECT 
   NAME "NAZWA", LENGTH(NAME)"LICZBA ZNAKÓW"
FROM
    product
WHERE
    NAME like 'Ace%';

--5
SELECT 
    41.58 "SETNE",
    ROUND(41.58) "CAŁKOWITE",
    41.58-MOD(41.58,10) "DZIESIATKI"
FROM
    dual;

--6
SELECT 
    41.58 "SETNE",
    TRUNC(41.58) "CAŁKOWITE",
    41.58-MOD(41.58,10) "DZIESIATKI"
FROM
    dual;

--7
SELECT 
   LAST_NAME "NAZWISKO",
   MOD(SALARY/COMMISSION_PCT,2) "RESZTA"
FROM
    emp
WHERE
    SALARY>1380;

--7a
SELECT 
   LAST_NAME "NAZWISKO",
   MOD(SALARY/COMMISSION_PCT,2) "RESZTA"
FROM
    emp
WHERE
    SALARY>1380 
AND
    MOD(SALARY/COMMISSION_PCT,2) IS NOT NULL;

--8
SELECT 
   SYSDATE "AKTUALNA DATA"
FROM
    dual;

--9
SELECT 
   LAST_NAME "NAZWISKO",
   ROUND(MONTHS_BETWEEN(SYSDATE,START_DATE)*(52/12)) "ILOSC TYGODNI"
FROM
    emp
WHERE
  DEPT_ID=43;

--10
SELECT 
   ID,
   ROUND(MONTHS_BETWEEN(SYSDATE, START_DATE)) "LICZBA MIESIĘCY",
   ADD_MONTHS(START_DATE,3) "DATA KOŃCA OKRESU PRÓBNEGO"
FROM
    emp
WHERE
  MONTHS_BETWEEN(SYSDATE, TO_DATE(START_DATE))<356;

--12
SELECT 
    ID,
    START_DATE,
    EXTRACT(MONTH FROM START_DATE)
FROM
    emp
    WHERE
    EXTRACT(YEAR FROM START_DATE)=1991;

--13
SELECT 
    ID,
    TO_CHAR(DATE_ORDERED,'MM/YY')
FROM
    ord
    WHERE
    SALES_REP_ID =11;

--14
SELECT 
    LAST_NAME "NAZWISKO",
    TO_CHAR(START_DATE,'DD Month YYYY "roku"') "DATA"
FROM
    emp
    WHERE
    START_DATE>=TO_DATE('1991-01-01','YYYY-MM-DD');
