--1
SELECT
last_name||' '||first_name"NAZWISKO I IMIE"
FROM
emp
WHERE salary<1300
ORDER BY last_name ASC;

/* Wybieram imię oraz nazwisko z tabeli EMP, których pensja nie przekracza 1300 oraz sortuję klauzulą ORDER BY po nazwisku, słowem kluczowym ASC które sortuje w porządku wzrastającym.
Wykorzystuję tutaj konkatenację w celu złączenia imienia i nazwiska w jedną kolumnę */
--2
SELECT
date_ordered ||' '|| total"DATA_ZAMOWIENIA I WARTOSC"
FROM ord;

-- Wybieram datę zamówienia oraz ich wartość z tabeli ORD, i przy pomocy konkatenacji łączę te dwie wartości do jednej kolumny;

--3
SELECT
first_name||' '||last_name"IMIE I NAZWISKO"
FROM emp
WHERE salary>
(SELECT AVG(salary)
FROM emp
WHERE title ='Warehouse Manager')
AND title='Stock Clerk';

/* Wybieram imię i nazwisko z tabeli EMP, pracujących na stanowisku STOCK CLERK dla których pensja jest większa od średniej zarobków(wykorzystuję funckję AVG) pracowników na stanowisku WAREHOUSE MANAGER.
 Korzystam w tym przykładzie z podzapytań w celu wybrania średniej zarobków na stanowisku WAREHOUSE MANAGER, i porównania jej do zarobków na stanowisku STOCK CLERC. */

--4
SELECT
COUNT(*)"ILOSC PRACOWNIKOW"
FROM emp
WHERE salary<
(SELECT AVG(SALARY)
FROM emp);

/* Zliczam ilość pracowników za pomocą funckji agregującej COUNT, dla których pensja jest mniejsza od średniej zarobków
(wykorzystuję do tego funkcję agregującą AVG w celu wyciągnięcia średniej zarobków oraz podzapytań w celu porówania jej do zarobków poszczególnych pracowników. */

--5
SELECT
first_name||' '||last_name"IMIĘ I NAZWISKO"
FROM emp
WHERE (MONTHS_BETWEEN(TO_DATE('01-03-2021','dd-mm-yyyy'),start_date))/12>30
ORDER BY start_date;

/* Wybieram imię i nazwisko z tabeli EMP, łącze je w jedną kolumnę przy pomocy konkatenacji, dla których staż pracy jest większy niż 30. Staż pracy liczę używając funkcji MONTHS_BETWEEN
w której podaję datę początku pracy i skonwertowanej daty 1 marca 2021 (Konwertuję przy pomocy funckji konwertującej TO_DATE). Obliczoną ilość miesięcy dziele przez 12 w celu uzyskania lat.
Następnie porównują to do liczby 30 w celu sprawdzenia czy pracują dłużej niż 30 lat. Otrzymane wyniki sortuję względem daty zatrudnienia przy pomocy ORDER BY . */

--6
SELECT
emp.id, SUM(ord.total)
FROM emp, ord
WHERE emp.id=ord.sales_rep_id
GROUP BY emp.id;

/* Wybieram ID sprzedawcy z tabeli EMP oraz sumę zamównień przez nich zrealizowanych z tabeli ORD(sumę zliczam przy pomocy funkcji SUM i grupuję po ID sprzedawcy. Łączę w tym przykładzie dwie tabele,
przy pomocy kolumny wiążącej ( ID z tabeli EMP oraz SALES_REP_ID z tabeli ORD) */

--7
SELECT *
FROM 
(SELECT emp.id, SUM(ord.total)
FROM emp, ord
WHERE emp.id = ord.sales_rep_id 
GROUP BY emp.id
ORDER BY SUM(ord.total) DESC)
WHERE rownum = 1;

/* W tym zadaniu wykorzystuję podzapytanie, tyle że nie do klauzuli WHERE, a do klauzuli FROM, aby wyswielić numer ID oraz łączną sumę zamówień. Łączę dwie tabele przy pomocy ID z tabeli EMP
oraz SALES_REP_ID z tabeli ORD. CAŁOŚĆ grupuję po ID sprzedawcy oraz sortuję wyniki malejąco. Przy pomocy pseudokolumny ROWNUM wyświetlam rekord z najwiekszą łączną wartością zamówień */

--8
SELECT last_name
FROM 
(SELECT emp.last_name, emp.id, SUM(ord.total)
FROM emp, ord
WHERE emp.id = ord.sales_rep_id 
GROUP BY emp.id, emp.last_name
ORDER BY SUM(ord.total) DESC)
WHERE rownum =1;

-- Wyświetlam nazwisko do wyników wyświetlania z poprzedniego zadania oraz dodaję do grupowania, aby grupowało się również po nazwisku, w celu określenia nazwiska sprzedawcy.

--9
SELECT
start_date"DATA", count(start_date)"ILOSC PRZYJETYCH OSOB"
FROM emp
GROUP BY start_date
ORDER BY start_date ASC;

/* Wybieram datę przyjęcia do pracy oraz zaliczam liczbę przyjętych osób przy pomocy funkcji COUNT która zlicza ilość wystąpień daty przyjęcia do pracy. Wyniki grupuje po dacie przyjęcia
do pracy oraz sortuję od daty najstarszej rosnąco. */

--10
SELECT
product.name"NAZWA"
FROM inventory, product
WHERE product.id=inventory.product_id AND inventory.amount_in_stock =0 AND inventory.out_of_stock_explanation IS NOT NULL;

/* Wybieram  nazwę produktu z tabeli PRODUCT, z tabeli INVENTORY sprawdzam czy jest pozostawiony komentarz dlaczego jest brak na magazynie. Jeżeli komentarz jest pusty 
co sprawdzam poleceniem IS NOT NUll, nazwa produktu nie zostanie wyświetlona */

--11
SELECT
product.name"NAZWA"
FROM inventory, product
WHERE product.id=inventory.product_id
GROUP BY inventory.product_id, product.name
HAVING SUM(inventory.amount_in_stock)<500;

/* Wybieram nazwę produktu z tabeli PRODUCT, łączę tabele INVENTORY I PRODUCT przez ID produktu, grupuje je po nazwie i ID, filtruje wyniki poleceniem HAVING jeśli suma
produktów znajdujących się na magazynie jest mniejsza od 500*/

--12
SELECT name
FROM product
WHERE name LIKE '% % %' AND name NOT LIKE'% % % %';

/* Wybieram nazwę produktu z tabeli PRODUCT, i za pomocą operatora LIKE wybieram nazwy składające się z 3 wyrazów;
