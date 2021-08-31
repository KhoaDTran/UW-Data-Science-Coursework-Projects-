SELECT W.day_of_week as day_of_week, avg(F.arrival_delay) as delay
FROM FLIGHTS as F, WEEKDAYS as W
WHERE F.day_of_week_id = W.did
GROUP BY W.day_of_week
ORDER BY delay DESC
Limit 1;
