--1
SELECT 
CREDIT_RATING "ZDOLNOŚĆ KREDYTOWA", COUNT(CREDIT_RATING)"LICZBA KLIENTÓW"
FROM
customer
GROUP BY CREDIT_RATING;

--2
SELECT TITLE "STANOWISKO", SUM(salary) "ZAROBKI"
FROM emp
WHERE TITLE NOT LIKE 'VP%'
GROUP BY TITLE
ORDER BY SUM(SALARY);

--3
SELECT TITLE "STANOWISKO", MAX(salary) "ZAROBKI"
FROM emp
GROUP BY TITLE;

--4
SELECT DEPT.NAME "NAZWA DEPARTAMENTU", AVG(EMP.SALARY) "ŚREDNIE ZAROBKI"
FROM DEPT, EMP
WHERE DEPT.ID= EMP.DEPT_ID
HAVING AVG(EMP.SALARY)>1499
GROUP BY DEPT.NAME;

--5
SELECT ORD.ID "NR", CUSTOMER.NAME "KLIENT",PRODUCT.NAME "PRODUKT",
ORD.PAYMENT_TYPE"PLATNOŚĆ", TO_DATE(ORD.DATE_ORDERED,'YYYY-MM-DD')"DATA ZAMOWIENIA",
ITEM.PRICE"CENA", ORD.TOTAL"LICZBA"
FROM ORD, CUSTOMER,ITEM,PRODUCT
WHERE ORD.ID = ITEM.ORD_ID AND CUSTOMER.ID=ORD.CUSTOMER_ID
AND ITEM.PRODUCT_ID=PRODUCT.ID AND ORD.PAYMENT_TYPE='CASH' 
AND ORD.DATE_ORDERED BETWEEN '1992/09/01' AND '1992/09/30'
ORDER BY ORD.ID, PRODUCT.NAME;

--6
SELECT ORD.ID, CUSTOMER.NAME "KLIENT", ORD.PAYMENT_TYPE "PLATNOSC", SUM(ITEM.PRICE*ITEM.QUANTITY_SHIPPED) "WYSOKOSC_ZAMOWIENIA" 
FROM ORD, CUSTOMER, PRODUCT, ITEM
WHERE ORD.ID = ITEM.ORD_ID AND CUSTOMER.ID = ORD.CUSTOMER_ID AND ITEM.PRODUCT_ID = PRODUCT.ID AND ORD.PAYMENT_TYPE='CASH' AND ORD.DATE_ORDERED BETWEEN '1992/09/01' AND '1992/09/30' 
GROUP BY ORD.ID, CUSTOMER.NAME, ORD.PAYMENT_TYPE
ORDER BY SUM(ITEM.PRICE*ITEM.QUANTITY_SHIPPED);

--7
SELECT LAST_NAME
FROM EMP
GROUP BY LAST_NAME
HAVING COUNT(LAST_NAME)>1;

--8
SELECT FIRST_NAME "IMIĘ", LAST_NAME "NAZWISKO", TITLE "STANOWISKO", MANAGER_ID "ZWIERZCHNIK", LEVEL POZIOM
FROM EMP
START WITH MANAGER_ID IS NULL
CONNECT BY PRIOR ID = MANAGER_ID
ORDER BY LEVEL;

--9
SELECT FIRST_NAME "IMIĘ", LAST_NAME "NAZWISKO", TITLE "STANOWISKO", MANAGER_ID "ZWIERZCHNIK", LEVEL POZIOM
FROM EMP
START WITH TITLE= 'VP, Operations'
CONNECT BY PRIOR ID = MANAGER_ID
ORDER BY LEVEL;

--10
SELECT DEPT.REGION_ID, DEPT.NAME
FROM DEPT
UNION 
SELECT REGION.ID, REGION.NAME 
FROM REGION
ORDER BY name ASC;

--11
SELECT DEPT.NAME
FROM DEPT
UNION 
SELECT REGION.NAME 
FROM REGION
ORDER BY name ASC;

--12
SELECT DEPT.NAME
FROM DEPT
UNION ALL
SELECT REGION.NAME 
FROM REGION
ORDER BY name ASC;

--13
SELECT EMP.DEPT_ID, EMP.LAST_NAME
FROM EMP
UNION 
SELECT REGION.ID, REGION.NAME 
FROM REGION
ORDER BY LAST_NAME;

--14
SELECT CUSTOMER_ID
FROM ORD
INTERSECT
SELECT ID FROM CUSTOMER;

--15
SELECT ID FROM CUSTOMER
MINUS
SELECT CUSTOMER_ID FROM ORD;

