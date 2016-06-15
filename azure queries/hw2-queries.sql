/*
	Eric Eckert
	Homework 2
	CSE 414 Spring 16
	Suciu
*/

--Run queries

--Query 1: Finds distinct flight numbers from Seattle to Boston on Mondays by Alaska Airlines Inc.
--Returns 3 rows, 1 col (flight number)
select distinct f.flight_num
from FLIGHTS f, WEEKDAYS w, CARRIERS c
where f.origin_city = 'Seattle WA'
and f.dest_city = 'Boston MA'
and w.day_of_week = 'Monday'
and f.carrier_id = c.cid
and f.day_of_week_id = w.did
and c.name = 'Alaska Airlines Inc.';


--Query 2: Finds various data for all flights from Seattle to Boston with one stop on July 15
--2015 and a total flight time of less than 7 hours and the same carrier for both legs
--Returns 488 rows, 10 cols (Carrier name, Both flight numbers, both flight origin and 
--destination cities, both flight times, total flight time)
select c.name, f1.flight_num, f1.origin_city, f1.dest_city, f1.actual_time, 
	f2.flight_num, f2.origin_city, f2.dest_city, f2.actual_time, f1.actual_time + f2.actual_time

from CARRIERS c, FLIGHTS f1, FLIGHTS f2
--First flight starts in Seattle, second flight ends in Boston
where f1.origin_city = 'Seattle WA'
and f2.dest_city = 'Boston MA'
--Transfer city must be the same
and f1.dest_city = f2.origin_city

--July
and f1.month_id = 7
and f2.month_id = 7
--15th
and f1.day_of_month = 15
and f2.day_of_month = 15
--2015
and f1.year = 2015
and f2.year = 2015

--same carrier
and f1.carrier_id = f2.carrier_id
--Flight time less than 7 hours
and f1.actual_time + f2.actual_time < 420

and f1.carrier_id = c.cid
and f2.carrier_id = c.cid;

/*
First 20 lines of results:

"American Airlines Inc.",42,"Seattle WA","Chicago IL",228,26,"Chicago IL","Boston MA",150,378
"American Airlines Inc.",42,"Seattle WA","Chicago IL",228,186,"Chicago IL","Boston MA",137,365
"American Airlines Inc.",42,"Seattle WA","Chicago IL",228,288,"Chicago IL","Boston MA",137,365
"American Airlines Inc.",42,"Seattle WA","Chicago IL",228,366,"Chicago IL","Boston MA",150,378
"American Airlines Inc.",42,"Seattle WA","Chicago IL",228,1205,"Chicago IL","Boston MA",128,356
"American Airlines Inc.",42,"Seattle WA","Chicago IL",228,1240,"Chicago IL","Boston MA",130,358
"American Airlines Inc.",42,"Seattle WA","Chicago IL",228,1299,"Chicago IL","Boston MA",133,361
"American Airlines Inc.",42,"Seattle WA","Chicago IL",228,1435,"Chicago IL","Boston MA",133,361
"American Airlines Inc.",42,"Seattle WA","Chicago IL",228,1557,"Chicago IL","Boston MA",122,350
"American Airlines Inc.",42,"Seattle WA","Chicago IL",228,2503,"Chicago IL","Boston MA",127,355
"American Airlines Inc.",44,"Seattle WA","New York NY",322,84,"New York NY","Boston MA",74,396
"American Airlines Inc.",44,"Seattle WA","New York NY",322,199,"New York NY","Boston MA",80,402
"American Airlines Inc.",44,"Seattle WA","New York NY",322,235,"New York NY","Boston MA",91,413
"American Airlines Inc.",44,"Seattle WA","New York NY",322,1443,"New York NY","Boston MA",80,402
"American Airlines Inc.",44,"Seattle WA","New York NY",322,2118,"New York NY","Boston MA","",322
"American Airlines Inc.",44,"Seattle WA","New York NY",322,2121,"New York NY","Boston MA",74,396
"American Airlines Inc.",44,"Seattle WA","New York NY",322,2122,"New York NY","Boston MA",65,387
"American Airlines Inc.",44,"Seattle WA","New York NY",322,2126,"New York NY","Boston MA",60,382
"American Airlines Inc.",44,"Seattle WA","New York NY",322,2128,"New York NY","Boston MA",83,405
"American Airlines Inc.",44,"Seattle WA","New York NY",322,2131,"New York NY","Boston MA",70,392
*/


--Query 3: Finds the day of the week with the largest average arrival delay
--Returns 1 row, 2 cols (Day of week, average arrival delay for that day of week)
select w.day_of_week, avg(f.arrival_delay)
from FLIGHTS f, WEEKDAYS w
where f.day_of_week_id = w.did
group by w.day_of_week
order by avg(arrival_delay) desc
limit 1;

--Query 4: Finds all distinct airlines that flew more than 1000 flights in 1 day.
--Returns 11 rows 1 col (Name of carriers)
select distinct c.name
from FLIGHTS f, CARRIERS c
where f.carrier_id = c.cid
group by c.name, f.year, f.month_id, f.day_of_month
having count(*) > 1000;

--Query 5: All airlines that had more than 0.5 percent cancel rate flying out of Seattle
--Returns 6 rows, 2 cols (Name of carriers, percent cancel rate out of Seattle)
select c.name, (sum(canceled) * 1.0) / count(*)
from FLIGHTS f, CARRIERS c
where f.carrier_id = c.cid
and f.origin_city = 'Seattle WA'
group by c.name
having (sum(canceled) * 1.0) / count(*) > 0.005
order by (sum(canceled) * 1.0) / count(*);