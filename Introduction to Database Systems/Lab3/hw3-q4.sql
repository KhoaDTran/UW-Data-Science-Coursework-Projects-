-- The query took 23s
-- The result of the query is 256 rows
-- The first 20 output rows:
-- Aberdeen SD
-- Abilene TX
-- Adak Island AK
-- Aguadilla PR
-- Akron OH
-- Albany GA
-- Albany NY
-- Alexandria LA
-- Allentown/Bethlehem/Easton PA
-- Alpena MI
-- Amarillo TX
-- Appleton WI
-- Arcata/Eureka CA
-- Asheville NC
-- Ashland WV
-- Aspen CO
-- Atlantic City NJ
-- Augusta GA
-- Bakersfield CA
-- Bangor ME

SELECT DISTINCT F1.dest_city as city
FROM FLIGHTS as F, FLIGHTS as F1
WHERE F.dest_city = F1.origin_city AND F.origin_city = 'Seattle WA' AND F.dest_city != 'Seattle WA'
      AND F1.origin_city != 'Seattle WA' AND F1.dest_city != 'Seattle WA'
      AND F1.dest_city NOT IN (SELECT F2.dest_city
                               FROM FLIGHTS as F2
                               WHERE F2.origin_city = 'Seattle WA')
ORDER BY F1.dest_city ASC;