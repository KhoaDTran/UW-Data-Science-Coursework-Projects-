SELECT DISTINCT flight_num
FROM FLIGHTS as F
WHERE F.origin_city = 'Seattle WA' AND F.dest_city = 'Boston MA' AND F.carrier_id = 'AS' AND F.day_of_week_id = 1;

