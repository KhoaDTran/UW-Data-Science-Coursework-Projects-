SELECT C.name as carrier, MAX(F.price) as max_price
FROM FLIGHTS as F, CARRIERS as C
WHERE F.carrier_id = C.cid
    AND ((F.origin_city ='Seattle WA' AND F.dest_city = 'New York NY') OR (F.origin_city ='New York NY' AND F.dest_city = 'Seattle WA'))
GROUP BY C.cid;
