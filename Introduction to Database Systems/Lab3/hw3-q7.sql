-- The query took 4s
-- The result of the query is 4 rows
-- The outputs are:
-- Alaska Airlines Inc.
-- SkyWest Airlines Inc.
-- United Air Lines Inc.
-- Virgin America

SELECT DISTINCT C.name as carrier
FROM CARRIERS as C, Flights as F
WHERE F.origin_city = 'Seattle WA' AND F.dest_city = 'San Francisco CA' AND C.cid = F.carrier_id
ORDER BY C.name ASC;