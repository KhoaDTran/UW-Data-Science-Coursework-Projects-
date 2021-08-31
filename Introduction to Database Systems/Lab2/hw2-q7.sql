SELECT sum(F.capacity) as capacity
FROM FLIGHTS as F, MONTHS as M
WHERE F.day_of_month = 10
    AND M.mid = 7
    AND F.month_id = M.mid
    AND ((F.origin_city = 'Seattle WA' AND F.dest_city = 'San Francisco CA') OR (F.origin_city = 'San Francisco CA' AND F.dest_city = 'Seattle WA'));
