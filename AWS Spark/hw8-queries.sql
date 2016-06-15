/*
	Eric Eckert
	Homework 8
	CSE 414 Spring 16
	Suciu
*/

/*
1) What is the total number of RDF rows in the data?
*/
select count(*) 
from fbFacts

/*
Result: 
563,980,447
*/

/*
2) What is the number of distinct predicates in the data? 
*/
select count(*) 
from (
	select distinct predicate 
	from fbFacts) t

/*
Result: 
18,944
*/

/*
3) What are all the tuples with the subject of mid /m/0284r5q?
*/
select * 
from fbFacts 
where subject = "/m/0284r5q"

/*
Result: 

/m/0284r5q	/type/object/key	/wikipedia/en_id	9,327,603
/m/0284r5q	/type/object/key	/wikipedia/en	Flyte_$0028chocolate_bar$0029
/m/0284r5q	/type/object/key	/wikipedia/en_title	Flyte_$0028chocolate_bar$0029
/m/0284r5q	/common/topic/article	/m/0284r5t	
/m/0284r5q	/type/object/type	/common/topic	
/m/0284r5q	/type/object/type	/food/candy_bar	
/m/0284r5q	/type/object/type	/business/brand	
/m/0284r5q	/type/object/type	/base/tagit/concept	
/m/0284r5q	/food/candy_bar/manufacturer	/m/01kh5q	
/m/0284r5q	/common/topic/notable_types	/business/brand	
/m/0284r5q	/common/topic/notable_types	/food/candy_bar	
/m/0284r5q	/food/candy_bar/sold_in	/m/09c7w0	
/m/0284r5q	/common/topic/notable_for		{"types":[], "id":"/food/candy_bar", "property":"/type/object/type", "name":"Candy bar"}
/m/0284r5q	/type/object/name	/lang/en	Flyte
/m/0284r5q	/common/topic/image	/m/04v6jtv
*/

/*
4) How many travel destinations does Freebase have?
*/
select count(*) 
from (
	select * 
	from fbFacts 
	where obj  = "/travel/travel_destination" 
	and predicate = "/type/object/type") t

/*
Result: 
295
*/

/*
5) Building off the previous query, what 20 travel destination have the most tourist attractions? 
Return the location name and count. Sort your result by the number of tourist attractions 
from largest to smallest and then on the destination name alphabetically and only return the top 20. 
*/
select f.context, t.count
from (
	select  f1.subject, count(*) count
	from fbFacts f1, fbFacts f2
	where f1.obj = "/travel/travel_destination" 
	and f1.predicate = "/type/object/type"
	and f1.subject = f2.subject
	and f2.predicate = "/travel/travel_destination/tourist_attractions"
	group by f1.subject
	) t, fbFacts f
where f.subject = t.subject
and f.predicate = "/type/object/name"
and f.obj = "/lang/en"
order by t.count desc
limit 20

/*
Result:

London	108
Norway	74
Finland	59
Burlington	41
Rome	40
Toronto	36
Beijing	32
Buenos Aires	28
San Francisco	26
Bangkok	20
Vienna	19
Sierra Leone	19
Munich	19
Montpelier	18
Tanzania	17
Athens	17
Atlanta	17
Berlin	16
Laos	16
Portland	15
*/

/*
6) Generate a histogram of the number of distinct predicates per subject.
*/
select t.subject, count(*)
from (
	select distinct subject, predicate 
	from fbFacts) t
group by t.subject

/*
Multiple choice

1)c
2)b
3)b
4)c

5:
a)false
b)false
c)false
d)true

*/