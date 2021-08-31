FLIGHTS (fid int,
         month_id int,        -- 1-12
         day_of_month int,    -- 1-31
         day_of_week_id int,  -- 1-7, 1 = Monday, 2 = Tuesday, etc
         carrier_id varchar(7),
         flight_num int,
         origin_city varchar(34),
         origin_state varchar(47),
         dest_city varchar(34),
         dest_state varchar(46),
         departure_delay int, -- in mins
         taxi_out int,        -- in mins
         arrival_delay int,   -- in mins
         canceled int,        -- 1 means canceled
         actual_time int,     -- in mins
         distance int,        -- in miles
         capacity int,
         price int,            -- in $
        )

CREATE TABLE USERS (
	username varchar(20) PRIMARY KEY,
	password varchar(20),
	account_balance int
)

CREATE TABLE RESERVATIONS (
	reservation_id int PRIMARY KEY ,
	username varchar(20) REFERENCES USERS,
	day_of_month int,
	fid1 int references FLIGHTS,
	fid2 int references FLIGHTS DEFAULT(0),
	paid int DEFAULT(0),
	total_price int,
	canceled int DEFAULT(0)
)
