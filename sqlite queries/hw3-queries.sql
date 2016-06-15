/*
 Eric Eckert
 Homework 2
 CSE 414 Spring 16
 Suciu
*/

--Section C: SQL Queries

--Query 1: returns 333 rows, 3 columns
--CPU time = 1484 ms,  elapsed time = 1649 ms.
/*
Aberdeen SD	Minneapolis MN	106
Abilene TX	Dallas/Fort Worth TX	111
Adak Island AK	Anchorage AK	165
Aguadilla PR	Newark NJ	272
Akron OH	Denver CO	224
Albany GA	Atlanta GA	111
Albany NY	Las Vegas NV	360
Albuquerque NM	Baltimore MD	297
Alexandria LA	Atlanta GA	179
Allentown/Bethlehem/Easton PA	Atlanta GA	199
Alpena MI	Detroit MI	80
Amarillo TX	Houston TX	176
Anchorage AK	Houston TX	448
Appleton WI	Atlanta GA	180
Arcata/Eureka CA	San Francisco CA	136
Asheville NC	Newark NJ	189
Ashland WV	Cincinnati OH	84
Aspen CO	Chicago IL	183
Atlanta GA	Honolulu HI	649
Atlantic City NJ	Fort Lauderdale FL	212
*/
select distinct f1.origin_city, f1.dest_city, f1.actual_time
from FLIGHTS f1
where actual_time = (
	select max(actual_time) 
	from FLIGHTS f2 
	where f1.origin_city = f2.origin_city)
order by f1.origin_city, f1.dest_city;


--Query 2: returns 147 rows, 1 column
--CPU time = 3109 ms,  elapsed time = 3320 ms.
/*
Aberdeen SD
Abilene TX
Adak Island AK
Albany GA
Alexandria LA
Alpena MI
Amarillo TX
Arcata/Eureka CA
Ashland WV
Augusta GA
Barrow AK
Beaumont/Port Arthur TX
Bemidji MN
Bethel AK
Binghamton NY
Bloomington/Normal IL
Brainerd MN
Bristol/Johnson City/Kingsport TN
Brownsville TX
Brunswick GA
*/
select distinct f1.origin_city
from FLIGHTS f1
where f1.origin_city not in (
	select f2.origin_city 
	from FLIGHTS f2 
	where f2.actual_time >= 180);
	

--Query 3: returns 327 rows, 2 columns
--CPU time = 1844 ms,  elapsed time = 2015 ms.
/*
Dothan AL	100.000000000000
Toledo OH	100.000000000000
Peoria IL	100.000000000000
Yuma AZ	100.000000000000
Laramie WY	100.000000000000
Victoria TX	100.000000000000
North Bend/Coos Bay OR	100.000000000000
Erie PA	100.000000000000
Columbus GA	100.000000000000
Wichita Falls TX	100.000000000000
Hattiesburg/Laurel MS	100.000000000000
Arcata/Eureka CA	100.000000000000
Kotzebue AK	100.000000000000
Medford OR	100.000000000000
Green Bay WI	100.000000000000
Santa Maria CA	100.000000000000
Muskegon MI	100.000000000000
Elko NV	100.000000000000
Laredo TX	100.000000000000
Sioux City IA	100.000000000000
*/
select f1.origin_city, ((
  select count(*)
  from FLIGHTS f2 
  where f2.fid not in (
    select f3.fid 
    from FLIGHTS f3 
    where f3.actual_time >= 180) 
  and f1.origin_city = f2.origin_city) * 100.0 / count(*)) as percentage
from FLIGHTS f1
group by f1.origin_city
order by percentage desc;


--Query 4: returns 256 rows, 1 column
--CPU time = 1687 ms,  elapsed time = 1855 ms.
/*
Aberdeen SD
Abilene TX
Adak Island AK
Aguadilla PR
Akron OH
Albany GA
Albany NY
Alexandria LA
Allentown/Bethlehem/Easton PA
Alpena MI
Amarillo TX
Appleton WI
Arcata/Eureka CA
Asheville NC
Ashland WV
Aspen CO
Atlantic City NJ
Augusta GA
Bakersfield CA
Bangor ME
*/


select distinct f2.dest_city
from FLIGHTS f1, FLIGHTS f2
where f2.dest_city != 'Seattle WA'
and f1.origin_city = 'Seattle WA'
and f2.dest_city not in (
   select dest_city
   from FLIGHTS
   where origin_city = 'Seattle WA')
and f1.dest_city = f2.origin_city;
 
  	
--Query 5: returns 3 rows, 1 column
--CPU time = 2657 ms,  elapsed time = 5349 ms.
/*
Devils Lake ND
Hattiesburg/Laurel MS
St. Augustine FL
*/
select distinct final.dest_city
from FLIGHTS final
where final.origin_city != 'Seattle WA'
and final.dest_city != 'Seattle WA'
and final.dest_city not in (
  	select f2.dest_city
  	from FLIGHTS f1, FLIGHTS f2 
  	where f1.origin_city = 'Seattle WA' 
  	and f1.dest_city = f2. origin_city)
order by final.dest_city;


--Section D: Physical Tuning

/*
1)

i
  SELECT DISTINCT carrier_id
  FROM Flights
  WHERE origin_city = 'Seattle WA' AND actual_time <= 180;
  
ii
  SELECT DISTINCT carrier_id
  FROM Flights
  WHERE origin_city = 'Gunnison CO' AND actual_time <= 180;
  
iii
  SELECT DISTINCT carrier_id
  FROM Flights
  WHERE origin_city = 'Seattle WA' AND actual_time <= 30;
*/
create index origin_index on FLIGHTS(origin_city);
/*
	a) A simple index that would be most likely to speed up all three queries is an index on
origin_city. All of the queries filter by origin_city and actual_time. Indexing by time 
would not have been a good choice. This is because all of the time comparisons are less than
comparisons. It works for case iii because the actual_time comparison is a very small value, 
so finding all values that satisfy the comparison is quick, it turns out to be only around 
2000 values. But in the case of <= 180, there may be hundreds and thousands of values to
consider, so the time complexity is closer to O(n). Indexing by city is generally a better
idea for these queries because that will allow the query to narrow down the city more quickly,
since we are checking for equivalency, and because there are less count values of cities
than there are of actual times.

	b) The indexing worked for case ii, but not for case i or iii. This is because Gunnison, CO
is a small city, with very few flights going out. Indexing was very advantageous here because
using the index narrowed the number of flights down to 50 from over 1 million total flights.
However, Seattle had around 22,000 flights going out, so it wasn't as advantageous to use.

2) In this case we would want to index on time. The time comparison is a very low value as
previously discussed, and there are very few values in the range of comparison. So having 
an index on actual_time will quickly narrow down the possible query results to around 2000
values. Another choice would have been to index on dest_city, since the first WHERE command
is an inner join on dest_city. Indexing on dest_city would have made this join much less
expensive, but does not help speed up the rest of the filtering. An index on origin city would
have been even more optimal than indexing actual_time, because there are far fewer flights
out of Gunnison CO than there are flights <= 30 min. But we already have an index on
origin_city.
*/
create index time_index on FLIGHTS(actual_time);
/*

3) Azure does not use the index of actual_time when both indexes are present. This is because
the index of origin_city is much more effective, negating the need for the use of the
index on actual_time.

4)
Query 1: 
	No index: CPU time = 1484 ms,  elapsed time = 1649 ms.
	Indexes: CPU time = 5062 ms,  elapsed time = 8189 ms.
	
Query 2:
	No index: CPU time = 3109 ms,  elapsed time = 3320 ms.
	Indexes: CPU time = 2797 ms,  elapsed time = 5108 ms.
	
Query 3:
	No index: CPU time = 1844 ms,  elapsed time = 2015 ms.
	Indexes: CPU time = 2265 ms,  elapsed time = 2943 ms.
	
Query 4:
	No index: CPU time = 2750 ms,  elapsed time = 3394 ms.
	Indexes: CPU time = 2844 ms,  elapsed time = 3678 ms.
	
Query 5:
	No index: CPU time = 2657 ms,  elapsed time = 5349 ms.
	Indexes: CPU time = 3890 ms,  elapsed time = 7487 ms.
	
	
--Section E:

Initially I had to get used to the interface, since this was my first time using a DBMS.
It was a little annoying that the service had to run on a plugin, and that it wasn't
compatible with Google chrome, so I used Safari. The interface was a little buggy. One
notable bug was that I could not copy and paste text into Azure. Copying and pasting within
Azure and copying text out of Azure worked though. Aside from that I got used to the interface
and I've come to realize how powerful Azure is as a tool. I look forward to using other
DBMS in the future.

*/