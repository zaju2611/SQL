--1
SELECT  id, total 
FROM ord
WHERE total =
(SELECT MAX(total) FROM ord);

--2
SELECT  *
FROM ord
WHERE total =
(SELECT MAX(total) 
FROM ord
WHERE payment_type ='CASH');

--3
SELECT  *
FROM ord
WHERE total >
(SELECT AVG(total) 
FROM ord);

--4
SELECT  name"NAZWA", suggested_whlsl_price"CENA"
FROM product
WHERE suggested_whlsl_price<
(SELECT AVG(suggested_whlsl_price) 
FROM product
WHERE name like 'Prostar%');

--5
SELECT warehouse_id"NR_MAGAZYNU",product_id"NR_PRODUKTU",amount_in_stock"ILOSC PRODUKTOW"
FROM inventory
WHERE (warehouse_id, amount_in_stock) IN
(SELECT warehouse_id, MAX(amount_in_stock) 
FROM inventory
GROUP BY warehouse_id);

--Magazyn 301 występuje dwukrotnie, gdyż Ilość Produktów(AMOUNT_IN_STOCK) dwukrotnie przyjmuje wartość 102

--6
SELECT warehouse_id"NR_MAGAZYNU",product_id"NR_PRODUKTU",amount_in_stock"ILOSC PRODUKTOW"
FROM inventory E1
WHERE amount_in_stock =
(SELECT MAX(amount_in_stock) 
FROM inventory E2
WHERE E2.warehouse_id= E1.warehouse_id
GROUP BY warehouse_id);

--7
SELECT W.city"MIASTO",P.name"NAZWA_PRODUKTU",I1.amount_in_stock"ILOSC PRODUKTOW"
FROM warehouse W, inventory I1, product P
WHERE amount_in_stock =
(SELECT MAX(amount_in_stock) 
FROM inventory I2
WHERE I2.warehouse_id= I1.warehouse_id AND W.id=I1.warehouse_id AND P.id=I1.product_id);

--8
SELECT name
FROM customer 
WHERE NOT EXISTS 
(SELECT *
FROM ord
WHERE ord.customer_id=customer.id);


--9
SELECT customer.id"NR_KLIENTA",customer.name"NAZWA_KLIENTA",ord.id"NUMER_ZAMOWIENIA"
FROM customer, ord 
WHERE EXISTS 
(SELECT *
FROM ord
WHERE ord.customer_id=customer.id) AND customer.id=ord.customer_id
ORDER BY customer.id;

--10
SELECT customer_id"NUMER_KLIENTA", id"NUMER_ZAMOWIENIA"
FROM ord
ORDER BY customer_id;

--11
SELECT last_name"NAZWISKO"
FROM emp
WHERE last_name IN
(SELECT last_name
FROM emp,ord
WHERE ord.id<100 AND emp.id=ord.sales_rep_id);

--12
SELECT emp.last_name"NAZWISKO"
FROM emp, ord
WHERE emp.id=ord.sales_rep_id AND ord.id<100;

--Należy użyć SELECT DISTINCT, aby uniknąć dwukrotnego wystąpienia.

--13
SELECT emp.first_name||' '||emp.last_name"IMIE I NAZWISKO"
FROM emp
WHERE 
(SELECT COUNT(ord.id) 
FROM ord
WHERE ord.sales_rep_id=emp.id)>=4;






