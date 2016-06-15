/*
	Eric Eckert
	Homework 2
	CSE 414 Spring 16
	Suciu
*/

--Allow foreign keys
PRAGMA foreign_keys=ON;

--Create tables

--Carrier table	
CREATE TABLE CARRIERS (
	cid varchar,
	name varchar,
	primary key(cid)
	);
	
--Months table
CREATE TABLE MONTHS (
	mid integer,
	month varchar,
	primary key(mid)
	); 
	
--Weekdays table
CREATE TABLE WEEKDAYS (
	did integer,
	day_of_week varchar,
	primary key(did)
	);

--Flights table
CREATE TABLE FLIGHTS (
	fid integer PRIMARY KEY, 
	year integer, 
	month_id integer, 
	day_of_month integer,
	day_of_week_id integer,
	carrier_id varchar,
	flight_num integer,
	origin_city varchar,
	origin_state varchar,
	dest_city varchar,
	dest_state varchar,
	departure_delay integer,
	taxi_out integer,
	arrival_delay integer,
	canceled integer,
	actual_time integer,
	distance integer,
	--Create foreign keys
	FOREIGN KEY(carrier_id) REFERENCES CARRIERS(cid),
	FOREIGN KEY(month_id) REFERENCES MONTHS(mid),
	FOREIGN KEY(day_of_week_id) REFERENCES WEEKDAYS(did)
	);

--Import all data
.mode csv
.import carriers.csv CARRIERS
.import months.csv MONTHS
.import weekdays.csv WEEKDAYS
.import flights-small.csv FLIGHTS

