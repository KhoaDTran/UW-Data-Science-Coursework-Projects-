-- Number 2: Check dependencies

-- name -> price
SELECT *
FROM frumble as A, frumble as B
WHERE A.name = B.name AND B.price != A.price;

-- month -> discount
SELECT *
FROM frumble as A, frumble as B
WHERE A.month = B.month AND A.discount != B.discount;

-- name, month -> price, discount
SELECT *
FROM frumble as A, frumble as B
WHERE A.name = B.name AND A.month = B.month AND
      A.price != B.price AND A.discount != B.discount;

-- month, price -> discount, name
SELECT *
FROM frumble as A, frumble as B
WHERE A.price = B.price AND A.month = B.month AND
      A.discount != B.discount AND A.name != B.name;

-- name, discount -> price, month
SELECT *
FROM frumble as A, frumble as B
WHERE A.name = B.name AND A.discount = B.discount AND
      A.price != B.price AND A.month != B.month;

/* FDs:
name -> price
month -> discount
name, month -> price, discount
month, price -> discount, name
name, discount -> price, month
 */

/* Number 3: BNCF tables
R(name, discount, month, price)
{name}+ = (name, price)

decomposed R1(name, price) and R2(name, discount, month)
    For R2:
{month}+ = (month, discount)
decomposed into R21(month, discount) and R22(month, name)
Result: R1(name, price), R21(month, discount) and R22(month, name)
 */

CREATE TABLE namePrice (
    name varchar(256) PRIMARY KEY,
    price int
);

CREATE TABLE monthDiscount(
    month varchar(10) PRIMARY KEY,
    discount int
);

CREATE TABLE monthName(
    month varchar(10) references monthDiscount,
    name varchar(256) references namePrice
);

-- Number 4: Populate data
INSERT INTO namePrice
SELECT DISTINCT name, price
FROM frumble;
SELECT COUNT(*) FROM namePrice;
-- 36 rows

INSERT INTO monthDiscount
SELECT DISTINCT month, discount
FROM frumble;
SELECT COUNT(*) FROM monthDiscount;
-- 12 rows

INSERT INTO monthName
SELECT DISTINCT month, name
FROM frumble;
SELECT COUNT(*) FROM monthName;
-- 426 rows

