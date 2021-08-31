-- print in comma-separated form with headers
.mode csv
.header on
select * from RestaurantsVisited;

-- print in list form with headers
.mode list
.header on
select * from RestaurantsVisited;

-- print in column form with 15 width and headers
.mode column
.width 15 15 15 15 15
.header on
select * from RestaurantsVisited;

-- print in comma-separated form without headers
.header off
.mode csv
select * from RestaurantsVisited;

-- print in list from without headers
.mode list
select * from RestaurantsVisited;

-- print in column form with 15 width without headers
.mode column
.width 15 15 15 15 15
select * from RestaurantsVisited;

