PRAGMA foreign_keys = ON;
.mode csv

CREATE TABLE FLIGHTS(fid int primary key,
                     month_id int references MONTHS(mid), -- 1-12
                     day_of_month int, -- 1-31
                     day_of_week_id int references WEEKDAYS(did), -- 1-7, 1 = Monday, 2 = Tuesday, etc
                     carrier_id varchar(7) references CARRIERS(cid),
                     flight_num int,
                     origin_city varchar(34),
                     origin_state varchar(47),
                     dest_city varchar(34),
                     dest_state varchar(46),
                     departure_delay int, -- in mins
                     taxi_out int,        -- in mins
                     arrival_delay int,   -- in mins\
                     canceled int,        -- 1 means canceled
                     actual_time int,     -- in mins
                     distance int,        -- in miles
                     capacity int,
                     price int);          -- in $

CREATE TABLE CARRIERS(cid varchar(7) primary key,
                      name varchar(83));

CREATE TABLE MONTHS(mid int primary key,
                    month varchar(9));

CREATE TABLE WEEKDAYS(did int primary key,
                      day_of_week varchar(9));

.import /Users/tynou/dropbox/College/Sophomore/Fall/CSE_414/hw/Assignment_2/flight-dataset/carriers.csv CARRIERS
.import /Users/tynou/dropbox/College/Sophomore/Fall/CSE_414/hw/Assignment_2/flight-dataset/months.csv MONTHS
.import /Users/tynou/dropbox/College/Sophomore/Fall/CSE_414/hw/Assignment_2/flight-dataset/weekdays.csv WEEKDAYS
.import /Users/tynou/dropbox/College/Sophomore/Fall/CSE_414/hw/Assignment_2/flight-dataset/flights-small.csv FLIGHTS

