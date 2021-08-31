CREATE TABLE Edges (
    Source INT,
    Destination INT);

INSERT INTO Edges
VALUES (10,5),
       (6,25),
       (1,3),
       (4,4);

SELECT * FROM Edges;

SELECT Source FROM Edges;

SELECT * FROM Edges AS E
WHERE E.Source > E.Destination;

/* No errors with type affinity support converting
string '-1' and '2000' into integers -1 and 2000 */
INSERT INTO Edges
VALUES ('-1','2000');







