SELECT C.name as name,
    F1.flight_num as f1_flight_num,
    F1.origin_city as f1_origin_city,
    F1.dest_city as f1_dest_city,
    F1.actual_time as f1_actual_time,
    F2.flight_num as f2_flight_num,
    F2.origin_city as f2_origin_city,
    F2.dest_city as f2_dest_city,
    F2.actual_time as f2_actual_time,
    (F1.actual_time + F2.actual_time) as actual_time
FROM FLIGHTS as F1, FLIGHTS as F2, CARRIERS as C
WHERE F1.origin_city = 'Seattle WA'
    AND F2.dest_city = 'Boston MA'
    AND F1.dest_city = F2.origin_city
    AND F1.month_id = 7
    AND F1.day_of_month = 15
    AND F2.month_id = F1.month_id
    AND F2.day_of_month = F1.day_of_month
    AND F2.carrier_id = C.cid
    AND F1.carrier_id = C.cid
    AND (F1.actual_time + F2.actual_time) < 420;