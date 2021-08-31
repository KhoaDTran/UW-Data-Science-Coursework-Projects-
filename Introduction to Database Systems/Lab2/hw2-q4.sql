SELECT DISTINCT C.name as name
FROM CARRIERS as C, FLIGHTS as F
WHERE F.carrier_id = C.cid
GROUP BY C.name, F.month_id, F.day_of_month
HAVING Count(*) > 1000;