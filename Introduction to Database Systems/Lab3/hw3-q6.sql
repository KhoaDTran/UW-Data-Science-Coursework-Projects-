-- The query took 7s
-- The result of the query is 4 rows
-- The outputs are:
-- Alaska Airlines Inc.
-- SkyWest Airlines Inc.
-- United Air Lines Inc.
-- Virgin America

SELECT DISTINCT C.name as carrier
FROM CARRIERS as C
WHERE EXISTS (SELECT F.carrier_id
              FROM FLIGHTS as F
              WHERE C.cid = F.carrier_id AND F.origin_city = 'Seattle WA' AND F.dest_city = 'San Francisco CA')
ORDER BY C.name ASC;