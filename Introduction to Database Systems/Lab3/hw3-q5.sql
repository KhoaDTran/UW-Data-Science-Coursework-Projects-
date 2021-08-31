-- The query took 148s
-- The result of the query is 4 rows
-- The outputs are:
-- Devils Lake ND
-- Hattiesburg/Laurel MS
-- Seattle WA
-- St. Augustine FL

SELECT DISTINCT F.dest_city as city
FROM FLIGHTS as F
WHERE F.dest_city NOT IN (SELECT DISTINCT F2.dest_city
                          FROM FLIGHTS as F1, FLIGHTS as F2
                          WHERE F1.dest_city = F2.origin_city AND F1.origin_city = 'Seattle WA' AND F1.dest_city != 'Seattle WA'
                          AND F2.origin_city != 'Seattle WA' AND F2.dest_city != 'Seattle WA'
                          AND F2.dest_city NOT IN (SELECT F3.dest_city
                                                   FROM FLIGHTS as F3
                                                   WHERE F3.origin_city = 'Seattle WA'))
                          AND F.dest_city NOT IN (SELECT DISTINCT F4.dest_city
                                                   FROM FLIGHTS as F4
                                                   WHERE F4.origin_city = 'Seattle WA')
ORDER BY F.dest_city ASC;