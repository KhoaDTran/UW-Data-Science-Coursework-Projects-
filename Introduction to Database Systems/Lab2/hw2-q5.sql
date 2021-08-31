SELECT C.name as name, (avg(F.canceled) * 100) as percent
FROM FLIGHTS as F, CARRIERS as C
WHERE F.origin_city = 'Seattle WA' AND F.carrier_id = C.cid
GROUP BY C.cid
HAVING percent > 0.5
ORDER BY percent ASC;
