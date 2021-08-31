-- The query took 19s
-- The result of the query is 109 rows
-- The first 20 output rows:
-- Aberdeen SD
-- Abilene TX
-- Alpena MI
-- Ashland WV
-- Augusta GA
-- Barrow AK
-- Beaumont/Port Arthur TX
-- Bemidji MN
-- Bethel AK
-- Binghamton NY
-- Brainerd MN
-- Bristol/Johnson City/Kingsport TN
-- Butte MT
-- Carlsbad CA
-- Casper WY
-- Cedar City UT
-- Chico CA
-- College Station/Bryan TX
-- Columbia MO
-- Columbus GA

SELECT DISTINCT F.origin_city as city
FROM FLIGHTS as F
WHERE NOT EXISTS (SELECT * FROM Flights as F1
                  WHERE F1.actual_time >= 180 AND F.origin_city = F1.origin_city)
ORDER BY F.origin_city;


