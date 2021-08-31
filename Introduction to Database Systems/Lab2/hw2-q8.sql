SELECT C.name as name, sum(F.departure_delay) as delay
FROM FLIGHTS as F, CARRIERS as C
WHERE F.carrier_id = C.cid
GROUP BY C.cid;