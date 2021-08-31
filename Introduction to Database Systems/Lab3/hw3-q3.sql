-- The query took 15s
-- The result of the query is 327 rows
-- The first 20 output rows:
-- Guam TT <null>
-- Pago Pago TT <null>
-- Aguadilla PR |29.4339622641509
-- Anchorage AK |32.1460373998219
-- San Juan PR |33.890360709191
-- Charlotte Amalie VI |40.0
-- Ponce PR |41.9354838709677
-- Fairbanks AK |50.6912442396313
-- Kahului HI |53.664998528113
-- Honolulu HI |54.9088086922778
-- San Francisco CA |56.3076568265683
-- Los Angeles CA |56.6041076487252
-- Seattle WA |57.7554165533496
-- Long Beach CA |62.4541164132145
-- Kona HI |63.2821075740944
-- New York NY|63.481519772551
-- Las Vegas NV |65.163009288384
-- Christiansted VI |65.3333333333333
-- Newark NJ |67.1373555840822
-- Worcester MA |67.741935483871

SELECT F2.origin_city as origin_city, CAST(F2.three_num as FLOAT)/ F4.total_sum * 100  as percentage
FROM (SELECT F1.origin_city as origin_city, COUNT(*) as three_num
      FROM FLIGHTS as F1
      WHERE F1.actual_time < 180
      GROUP BY F1.origin_city) as F2
      RIGHT OUTER JOIN
     (SELECT F3.origin_city as origin_city, COUNT(*) as total_sum
      FROM FLIGHTS as F3
      GROUP BY F3.origin_city) as F4
     ON F2.origin_city = F4.origin_city
ORDER BY percentage ASC;