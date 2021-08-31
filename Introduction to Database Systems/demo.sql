
.mode column
.header ON

CREATE TABLE Faculty (
  UserID INT PRIMARY KEY,
  Name VARCHAR(256),
  Job VARCHAR(256));


INSERT INTO Faculty
VALUES (1, 'Jack', 'TA');


INSERT INTO Faculty
VALUES (2, 'Allison', 'TA'),
       (3, 'Magda', 'Prof'),
       (4, 'Dan', 'Prof'),
       (5, 'Alvin', 'A. Prof');


SELECT F.Name, F.Job
  FROM Faculty AS F
 WHERE F.Job = 'TA';



DELETE FROM Faculty
      WHERE UserID = 1;


UPDATE Faculty
   SET Job = 'Prof'
 WHERE UserID = 5;


CREATE TABLE Regist (
  UserID INT REFERENCES Faculty,
  Car VARCHAR(256));

INSERT INTO Regist
VALUES (3, 'Charger'),
       (4, 'Civic'),
       (4, 'Pinto');

-- inner join
SELECT F.Name,
       R.Car
  FROM Faculty AS F
  JOIN Regist AS R
    ON F.UserID = R.UserID;

-- left (outer) join
SELECT F.Name,
       R.Car
  FROM Faculty AS F
  LEFT JOIN Regist AS R
    ON F.UserID = R.UserID;

.nullvalue 'NULL'
-- try the same query again

-- right/full join not supported in my version of sqlite3
