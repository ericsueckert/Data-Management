/*
	Eric Eckert
	Homework 6
	CSE 414 Spring 16
	Suciu
*/

--2a)

create table Vehicle (
	year varchar(4),
	licensePlate varchar(10),
	primary key(licensePlate)
	);
	
create table InsuranceCo (
	name varchar(100),
	phone varchar(20),
	primary key(name)
	);
	
create table Person (
	ssn varchar(20),
	name varchar(50),
	primary key(ssn)
	);
	
create table Driver (
	ssn varchar(20) references Person(ssn),
	licenceNo varchar(20),
	primary key(licenceNo)
	);
	
create table nonProfessionalDriver (
	licenseNo varchar(20) references Driver(licenceNo),
	primary key(licenseNo)
	);
	
create table ProfessionalDriver (
	medicalHistory varchar(255),
	licenceNo varchar(20) references Driver(licenseNo),
	primary key(licenseNo)
	);
	
create table Car (
	licensePlate varchar(10) references Vehicle(licensePlate),
	make varchar(50),
	primary key(licensePlate)
	);
	
create table Truck (
	licensePlate varchar(10) references Vehicle(licensePlate),
	capacity int,
	primary key(licensePlate)
	);
	
create table insures (
	maxLiability real,
	maxLossDamage real,
	insuranceName varchar(100) references InsuranceCo(name),
	licensePlate varchar(10) references Vehicle(licensePlate),
	primary key(licensePlate)
	);
	
create table owns (
	licensePlate varchar(10) references Vehicle(licensePlate),
	ssn varchar(20) references Person(ssn),
	primary key(licensePlate)
	);
	
create table drives (
	licenseNo varchar(20) references nonProfessionalDriver(licenseNo),
	licensePlate varchar(10) references Car(licensePlate),
	primaryKey(licenseNo, licensePlate)
	);
	
create table operates (
	licenseNo varchar(20) references ProfessionalDriver(licenseNo),
	licensePlate varchar(10) references Truck(licensePlate),
	primaryKey(licensePlate)
	);
	
/*
b) The relation that represents the relationship "insures" is the insures table. The relation
has the attributes of maxLiability and maxLossDamage, and references Vehicle on licensePlate,
and InsuranceCo on name, which means that each for each relationship, there is one Insurance company
for every vehicle. Additionally the primary key is on licencePlate, which ensures that there is
only one relationship for each vehicle, because each vehicle may only be insured by one company,
though a single company may insure many vehicles.

c) The relations "drives" and "operates" are similar in that they both reference a licenseNo 
which represents a driver of some sort, and they both reference a licensePlate that represents
some sort of Vehicle. They are different because "operates" references a ProfessionalDriver
directly, which is unique from "drives" referencing a nonProfessionalDriver directly.
"operates" also references Truck while "drives" references "Car". Lastly, "drives" is keyed on
licencesNo and licensPlate together because each car and driver relationship is unique. However
since a ProfessionalDriver will operate multiple trucks, "operates" is keyed only on licensePlate.

*/

/*
4
a) A set with no functional dependencies satisfies this closed attribute set. If any FD
exists where an element references an element other than itself, then there will exist 
some sets that are not closed.

b) If the only closed sets are {} and {A,B,C,D}, then each subset of the element set must 
reference an element outside that set. This can be achieved with the set of FDs: A->B, B->C,
C->D, D->A, or any FD set that implies the same thing. This guarantees that unless all elements
are X+ then it will not be closed.

c) For {A,B}, adding the FDs A->B and B->A and no other FD where A or B points to anything
other than A or B ensures that {A,B} is a guaranteed closed set. Then adding C->D and D->A
and DAB->C guarantee that if C or D is included then the set will not be closed, unless every
element was selected.

*/

/*
5
i)
create table sales(
	name varchar(50),
	discount varchar(10),
	month varchar(10),
	price int
	
	);

ii)

select distinct price,name
from sales
order by name;

After trying to query based on name and price, it is shown that each product is associated
with one price. Thus name->price.

select month,discount
from sales
order by month;

This query revealed that each month was associated with a single discount. Thus month -> discount

iii)

sales(name, discount, month, price)

FDs: name->price, month->discount

decomp on name->price = two tables
name+ = name, price

sales(name, price), sales(name, discount, month)

decomp on month->discount = 2 tables
month+ = month,discount

sales(discount,month), sales(name,month)

The final tables would be

sales1(name, price)
sales2(discount,month)
sales3(name, month)

create table item(
	name varchar(50),
	price int
	primary key(name)
	);
	
create table monthlyDiscount(
	month varchar(10),
	discount real
	primary key(month)
	);

create table saleMonth(
	name varchar(50) references item(name),
	month varchar(10) references monthlyDiscount(month)
	);
	
iv)

insert into item(name,price)
select distinct name,price
from sales
order by name;

insert into monthlyDiscount(month, discount)
select distinct month, discount
from sales
order by month;

insert into saleMonth(name,month)
select distinct name,month
from sales
order by name;

contents of item:
bar1	19
bar2	59
bar3	59
bar4	29
bar5	89
bar6	99
bar7	29
bar8	19
bar9	39
click1	39
click2	39
click3	39
click4	49
click5	99
click6	89
click7	29
click8	39
click9	49
gizmo1	49
gizmo2	99
gizmo3	19
gizmo4	29
gizmo5	79
gizmo6	29
gizmo7	19
gizmo8	89
gizmo9	79
mouse1	19
mouse2	49
mouse3	29
mouse4	69
mouse5	89
mouse6	99
mouse7	29
mouse8	59
mouse9	69

contents of monthlyDiscount:
apr	15%
aug	15%
dec	33%
feb	10%
jan	33%
jul	33%
jun	10%
mar	15%
may	10%
nov	15%
oct	10%
sep	15%

contents of saleMonth:
bar1	apr
bar1	aug
bar1	dec
bar1	feb
bar1	jan
bar1	jul
bar1	jun
bar1	mar
bar1	may
bar1	nov
bar1	oct
bar1	sep
bar2	aug
bar2	apr
bar2	dec
bar2	feb
bar2	jan
bar2	jul
bar2	jun
bar2	may
bar2	mar
bar2	nov
bar2	oct
bar2	sep
bar3	aug
bar3	apr
bar3	dec
bar3	feb
bar3	jan
bar3	jul
bar3	jun
bar3	may
bar3	mar
bar3	nov
bar3	oct
bar3	sep
bar4	sep
bar4	oct
bar4	nov
bar4	may
bar4	mar
bar4	jun
bar4	jul
bar4	jan
bar4	dec
bar4	aug
bar4	apr
bar5	sep
bar5	nov
bar5	oct
bar5	may
bar5	mar
bar5	jun
bar5	jul
bar5	jan
bar5	feb
bar5	dec
bar5	apr
bar5	aug
bar6	aug
bar6	apr
bar6	dec
bar6	feb
bar6	jan
bar6	jul
bar6	jun
bar6	mar
bar6	may
bar6	oct
bar6	nov
bar6	sep
bar7	sep
bar7	oct
bar7	nov
bar7	may
bar7	mar
bar7	jun
bar7	jul
bar7	jan
bar7	feb
bar7	dec
bar7	aug
bar7	apr
bar8	apr
bar8	aug
bar8	dec
bar8	feb
bar8	jan
bar8	jul
bar8	jun
bar8	mar
bar8	may
bar8	nov
bar8	oct
bar8	sep
bar9	apr
bar9	aug
bar9	dec
bar9	feb
bar9	jan
bar9	jul
bar9	jun
bar9	mar
bar9	may
bar9	nov
bar9	oct
bar9	sep
click1	apr
click1	dec
click1	feb
click1	jan
click1	jul
click1	jun
click1	mar
click1	may
click1	nov
click1	oct
click1	sep
click2	apr
click2	aug
click2	dec
click2	feb
click2	jan
click2	jul
click2	jun
click2	mar
click2	may
click2	nov
click2	oct
click2	sep
click3	apr
click3	aug
click3	dec
click3	feb
click3	jan
click3	jun
click3	mar
click3	may
click3	nov
click3	oct
click3	sep
click4	sep
click4	oct
click4	nov
click4	may
click4	mar
click4	jun
click4	jul
click4	jan
click4	feb
click4	dec
click4	aug
click4	apr
click5	apr
click5	dec
click5	aug
click5	feb
click5	jan
click5	jul
click5	jun
click5	mar
click5	nov
click5	may
click5	oct
click5	sep
click6	sep
click6	nov
click6	oct
click6	may
click6	mar
click6	jun
click6	jul
click6	jan
click6	feb
click6	dec
click6	aug
click6	apr
click7	sep
click7	oct
click7	nov
click7	may
click7	mar
click7	jun
click7	jul
click7	jan
click7	feb
click7	dec
click7	aug
click7	apr
click8	apr
click8	aug
click8	dec
click8	feb
click8	jan
click8	jul
click8	jun
click8	mar
click8	may
click8	nov
click8	oct
click8	sep
click9	sep
click9	oct
click9	nov
click9	may
click9	mar
click9	jun
click9	jul
click9	jan
click9	feb
click9	dec
click9	aug
gizmo1	sep
gizmo1	oct
gizmo1	nov
gizmo1	may
gizmo1	mar
gizmo1	jun
gizmo1	jul
gizmo1	jan
gizmo1	feb
gizmo1	dec
gizmo1	aug
gizmo1	apr
gizmo2	apr
gizmo2	aug
gizmo2	dec
gizmo2	feb
gizmo2	jan
gizmo2	jul
gizmo2	jun
gizmo2	mar
gizmo2	may
gizmo2	nov
gizmo2	sep
gizmo2	oct
gizmo3	apr
gizmo3	aug
gizmo3	dec
gizmo3	feb
gizmo3	jan
gizmo3	jul
gizmo3	jun
gizmo3	mar
gizmo3	may
gizmo3	nov
gizmo3	oct
gizmo3	sep
gizmo4	sep
gizmo4	oct
gizmo4	nov
gizmo4	may
gizmo4	mar
gizmo4	jun
gizmo4	jul
gizmo4	jan
gizmo4	feb
gizmo4	dec
gizmo4	aug
gizmo4	apr
gizmo5	apr
gizmo5	aug
gizmo5	feb
gizmo5	jan
gizmo5	jul
gizmo5	jun
gizmo5	mar
gizmo5	may
gizmo5	sep
gizmo5	nov
gizmo5	oct
gizmo6	sep
gizmo6	oct
gizmo6	nov
gizmo6	may
gizmo6	mar
gizmo6	jun
gizmo6	jul
gizmo6	jan
gizmo6	feb
gizmo6	dec
gizmo6	aug
gizmo6	apr
gizmo7	apr
gizmo7	aug
gizmo7	dec
gizmo7	feb
gizmo7	jan
gizmo7	jul
gizmo7	jun
gizmo7	mar
gizmo7	may
gizmo7	nov
gizmo7	oct
gizmo7	sep
gizmo8	oct
gizmo8	nov
gizmo8	sep
gizmo8	may
gizmo8	mar
gizmo8	jun
gizmo8	jul
gizmo8	jan
gizmo8	feb
gizmo8	dec
gizmo8	aug
gizmo8	apr
gizmo9	apr
gizmo9	aug
gizmo9	dec
gizmo9	feb
gizmo9	jan
gizmo9	jul
gizmo9	jun
gizmo9	mar
gizmo9	may
gizmo9	sep
gizmo9	nov
gizmo9	oct
mouse1	apr
mouse1	aug
mouse1	dec
mouse1	feb
mouse1	jul
mouse1	jun
mouse1	mar
mouse1	may
mouse1	nov
mouse1	oct
mouse1	sep
mouse2	oct
mouse2	nov
mouse2	sep
mouse2	may
mouse2	mar
mouse2	jun
mouse2	jul
mouse2	jan
mouse2	feb
mouse2	dec
mouse2	aug
mouse2	apr
mouse3	sep
mouse3	oct
mouse3	nov
mouse3	may
mouse3	mar
mouse3	jun
mouse3	jul
mouse3	jan
mouse3	feb
mouse3	dec
mouse3	aug
mouse3	apr
mouse4	oct
mouse4	nov
mouse4	sep
mouse4	may
mouse4	mar
mouse4	jul
mouse4	jun
mouse4	jan
mouse4	feb
mouse4	dec
mouse4	aug
mouse4	apr
mouse5	oct
mouse5	nov
mouse5	sep
mouse5	may
mouse5	mar
mouse5	jun
mouse5	jul
mouse5	jan
mouse5	feb
mouse5	dec
mouse5	aug
mouse5	apr
mouse6	apr
mouse6	aug
mouse6	dec
mouse6	feb
mouse6	jan
mouse6	jul
mouse6	jun
mouse6	mar
mouse6	may
mouse6	sep
mouse6	nov
mouse6	oct
mouse7	sep
mouse7	oct
mouse7	nov
mouse7	may
mouse7	mar
mouse7	jun
mouse7	jul
mouse7	jan
mouse7	feb
mouse7	dec
mouse7	aug
mouse7	apr
mouse8	apr
mouse8	aug
mouse8	dec
mouse8	feb
mouse8	jan
mouse8	jul
mouse8	mar
mouse8	jun
mouse8	may
mouse8	sep
mouse8	nov
mouse8	oct
mouse9	oct
mouse9	nov
mouse9	sep
mouse9	may
mouse9	jun
mouse9	mar
mouse9	jul
mouse9	jan
mouse9	feb
mouse9	dec
mouse9	aug
mouse9	apr

*/