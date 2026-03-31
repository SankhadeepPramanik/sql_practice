Create Table Club (
Club_Id int,
Member_Id int,
EDU varchar(30));

Insert into Club Values (1001,210,Null);
Insert into Club Values (1001,211,'MM:CI');
Insert into Club Values (1002,215,'CD:CI:CM');
Insert into Club Values (1002,216,'CL:CM');
Insert into Club Values (1002,217,'MM:CM');
Insert into Club Values (1003,255,Null);
Insert into Club Values (1001,216,'CO:CD:CL:MM');
Insert into Club Values (1002,210,Null);
--lateral split_to_table(edu,':') same as outer applt string_split()

select * from club;

with cte as (select 
club_id,member_id,edu,value 
 from club cross join lateral split_to_table(edu,':')
union all 
select *,NULL from club where edu is NULL)
,cte1 as (select *,case when value in ('CO','CI','MM') then 0.5 when value in ('CD','CL','CM') then 1 else 0 end as edu_value from cte
) 
select club_id,sum(edu_value) as edu_value from cte1 group by club_id order by club_id;
---------------------------------------------------------------------------------------------------------------------------
CREATE TABLE brands 
(
    brand1      VARCHAR(20),
    brand2      VARCHAR(20),
    year        INT,
    custom1     INT,
    custom2     INT,
    custom3     INT,
    custom4     INT
);
INSERT INTO brands VALUES ('apple', 'samsung', 2020, 1, 2, 1, 2);
INSERT INTO brands VALUES ('samsung', 'apple', 2020, 1, 2, 1, 2);
INSERT INTO brands VALUES ('apple', 'samsung', 2021, 1, 2, 5, 3);
INSERT INTO brands VALUES ('samsung', 'apple', 2021, 5, 3, 1, 2);
INSERT INTO brands VALUES ('google', NULL, 2020, 5, 9, NULL, NULL);
INSERT INTO brands VALUES ('oneplus', 'nothing', 2020, 5, 9, 6, 3);

SELECT * FROM brands;


with cte as (select *,case when brand1<brand2 then concat_ws(',',brand1,brand2,year) else concat_ws(',',brand2,brand1,year) end as pair_id from brands
),
cte_rn as
(select * 
, row_number() over(partition by pair_id order by pair_id) as rn
from cte)

select brand1, brand2, year, custom1, custom2, custom3, custom4
from cte_rn
where rn = 1 
or (custom1 <> custom3 and custom2 <> custom4);

----------------------------------------------------------------------------------------------------------------

drop table if exists mountain_huts;
create table mountain_huts 
(
	id 			integer not null unique,
	name 		varchar(40) not null unique,
	altitude 	integer not null
);
insert into mountain_huts values (1, 'Dakonat', 1900);
insert into mountain_huts values (2, 'Natisa', 2100);
insert into mountain_huts values (3, 'Gajantut', 1600);
insert into mountain_huts values (4, 'Rifat', 782);
insert into mountain_huts values (5, 'Tupur', 1370);

drop table if exists trails;
create table trails 
(
	hut1 		integer not null,
	hut2 		integer not null
);
insert into trails values (1, 3);
insert into trails values (3, 2);
insert into trails values (3, 5);
insert into trails values (4, 5);
insert into trails values (1, 5);

select * from mountain_huts;
select * from trails;

with cte as(
select a.hut1 as start_hut,b.name as start_hut_name,b.altitude as start_hut_alt,a.hut2 as end_hut from trails a join mountain_huts b on a.hut1=b.id )
, cte1 as(
select a.* ,b.name as end_hut_name,b.altitude as end_hut_alt, case when a.start_hut_alt>b.altitude  then 1 else 0 end altitude_flag from cte a join mountain_huts b on a.end_hut=b.id ),
-- (select start_hut,start_hut_name,end_hut,end_hut_name,flag   from  cte1 where flag!=0
-- union all
-- select end_hut as start_hut,end_hut_name as start_hut_name,start_hut as end_hut,start_hut_name end_hut_name,flag   from  cte1 where flag=0)
cte_final as
(select case when altitude_flag = 1 then start_hut else end_hut end as start_hut
, case when altitude_flag = 1 then start_hut_name else end_hut_name end as start_hut_name
, case when altitude_flag = 1 then end_hut else start_hut end as end_hut
, case when altitude_flag = 1 then end_hut_name else start_hut_name end as end_hut_name
from cte1)
select a.start_hut_name,a.end_hut_name as middle_hut_name,b.end_hut_name as end_hut_name from cte_final a join cte_final b on a.end_hut=b.start_hut


-----------------------------------------------------------------------------------------------------------------------
--tq-3
DROP TABLE IF EXISTS FOOTER;
CREATE TABLE FOOTER 
(
	id 			INT PRIMARY KEY,
	car 		VARCHAR(20), 
	length 		INT, 
	width 		INT, 
	height 		INT
);

INSERT INTO FOOTER VALUES (1, 'Hyundai Tucson', NULL, 6, NULL);
INSERT INTO FOOTER VALUES (2, NULL, 15, NULL, 20);
INSERT INTO FOOTER VALUES (3, NULL, 12, 8, 15);
INSERT INTO FOOTER VALUES (4, 'Toyota Rav4', NULL, 15, NULL);
INSERT INTO FOOTER VALUES (5, 'Kia Sportage', NULL, NULL, 18); 

SELECT * FROM FOOTER;

SELECT id,last_value(car) ignore nulls over(order by id rows between unbounded preceding and current row),last_value(length) ignore nulls over(order by id rows between unbounded preceding and current row),last_value(width) ignore nulls over(order by id rows between unbounded preceding and current row),last_value(height) ignore nulls over(order by id rows between unbounded preceding and current row) FROM FOOTER;

SELECT id,
first_value(car) OVER (PARTITION BY value_partition_car ORDER BY id) AS first_car,
first_value(length) OVER (PARTITION BY value_partition_length ORDER BY id) AS first_length,
first_value(width) OVER (PARTITION BY value_partition_width ORDER BY id) AS first_width,
first_value(height) OVER (PARTITION BY value_partition_height ORDER BY id) AS first_height
FROM (SELECT id,
car,
length,
width,
height,
SUM(CASE WHEN car IS NULL THEN 0 ELSE 1 END) OVER (ORDER BY id) AS value_partition_car,
SUM(CASE WHEN length IS NULL THEN 0 ELSE 1 END) OVER (ORDER BY id) AS value_partition_length,
SUM(CASE WHEN width IS NULL THEN 0 ELSE 1 END) OVER (ORDER BY id) AS value_partition_width,
SUM(CASE WHEN height IS NULL THEN 0 ELSE 1 END) OVER (ORDER BY id) AS value_partition_height
FROM FOOTER) AS q
ORDER BY id desc;


SELECT id,last_value(car) ignore nulls over(order by id rows between unbounded preceding and current row),last_value(length) ignore nulls over(order by id desc  rows between unbounded preceding and current row),last_value(width) ignore nulls over(order by id rows between unbounded preceding and current row),last_value(height) ignore nulls over(order by id rows between unbounded preceding and current row) FROM FOOTER;

----------------------------------------------------------------------------------------------------


drop table if exists salary;
create table salary
(
	emp_id		int,
	emp_name	varchar(30),
	base_salary	int
);
insert into salary values(1, 'Rohan', 5000);
insert into salary values(2, 'Alex', 6000);
insert into salary values(3, 'Maryam', 7000);


drop table if exists income;
create table income
(
	id			int,
	income		varchar(20),
	percentage	int
);
insert into income values(1,'Basic', 100);
insert into income values(2,'Allowance', 4);
insert into income values(3,'Others', 6);


drop table if exists deduction;
create table deduction
(
	id			int,
	deduction	varchar(20),
	percentage	int
);
insert into deduction values(1,'Insurance', 5);
insert into deduction values(2,'Health', 6);
insert into deduction values(3,'House', 4);


drop table if exists emp_transaction;
create table emp_transaction
(
	emp_id		int,
	emp_name	varchar(50),
	trns_type	varchar(20),
	amount		decimal(38,2)
);
insert into emp_transaction
select s.emp_id, s.emp_name, x.trns_type
, case when x.trns_type = 'Basic' then round(base_salary * (cast(x.percentage as decimal)/100),2)
	   when x.trns_type = 'Allowance' then round(base_salary * (cast(x.percentage as decimal)/100),2)
	   when x.trns_type = 'Others' then round(base_salary * (cast(x.percentage as decimal)/100),2)
	   when x.trns_type = 'Insurance' then round(base_salary * (cast(x.percentage as decimal)/100),2)
	   when x.trns_type = 'Health' then round(base_salary * (cast(x.percentage as decimal)/100),2)
	   when x.trns_type = 'House' then round(base_salary * (cast(x.percentage as decimal)/100),2) end as amount	   
from salary s
cross join (select income as trns_type, percentage from income
			union
			select deduction as trns_type, percentage from deduction) x;


select * from salary;
select * from income;
select * from deduction;
select * from emp_transaction order by emp_id;

with cte as (select * from emp_transaction 
pivot (sum(amount) for trns_type in (any order by trns_type))
)
select * from cte ;
--------------------------------------------------------------------------------------------

-- PostgreSQL
drop table if exists Day_Indicator;
create table Day_Indicator
(
	Product_ID 		varchar(10),	
	Day_Indicator 	varchar(7),
	Dates			date
);
insert into Day_Indicator values ('AP755', '1010101', to_date('04-Mar-2024','dd-mon-yyyy'));
insert into Day_Indicator values ('AP755', '1010101', to_date('05-Mar-2024','dd-mon-yyyy'));
insert into Day_Indicator values ('AP755', '1010101', to_date('06-Mar-2024','dd-mon-yyyy'));
insert into Day_Indicator values ('AP755', '1010101', to_date('07-Mar-2024','dd-mon-yyyy'));
insert into Day_Indicator values ('AP755', '1010101', to_date('08-Mar-2024','dd-mon-yyyy'));
insert into Day_Indicator values ('AP755', '1010101', to_date('09-Mar-2024','dd-mon-yyyy'));
insert into Day_Indicator values ('AP755', '1010101', to_date('10-Mar-2024','dd-mon-yyyy'));
insert into Day_Indicator values ('XQ802', '1000110', to_date('04-Mar-2024','dd-mon-yyyy'));
insert into Day_Indicator values ('XQ802', '1000110', to_date('05-Mar-2024','dd-mon-yyyy'));
insert into Day_Indicator values ('XQ802', '1000110', to_date('06-Mar-2024','dd-mon-yyyy'));
insert into Day_Indicator values ('XQ802', '1000110', to_date('07-Mar-2024','dd-mon-yyyy'));
insert into Day_Indicator values ('XQ802', '1000110', to_date('08-Mar-2024','dd-mon-yyyy'));
insert into Day_Indicator values ('XQ802', '1000110', to_date('09-Mar-2024','dd-mon-yyyy'));
insert into Day_Indicator values ('XQ802', '1000110', to_date('10-Mar-2024','dd-mon-yyyy'));

select * from Day_Indicator;

with cte as (select *,extract(dayofweek_iso from dates) as dow from Day_Indicator
)
select *,case when substring(day_indicator,extract(dayofweek_iso from dates),1)= '1' 
				then 'Include' else 'Exlcude' end as flag
from cte
--------------------------------------------------------------------------------------------------------------


CREATE TABLE toll_transactions (
 txn_id INT,
 vehicle_no VARCHAR(20),
 vehicle_type VARCHAR(20),
 crossing_time TIMESTAMP
);

INSERT INTO toll_transactions (txn_id, vehicle_no, vehicle_type, crossing_time) VALUES
(1, 'DL01AA1111', 'car', '2026-01-10 08:00:00'),
(2, 'DL01AA1111', 'car', '2026-01-10 11:00:00'),
(3, 'DL02BB2222', 'truck', '2026-01-10 09:00:00'),
(4, 'DL02BB2222', 'truck', '2026-01-10 16:00:00'),
(5, 'DL03CC3333', 'bus', '2026-01-10 10:00:00'),
(6, 'DL03CC3333', 'bus', '2026-01-10 12:00:00'),
(7, 'DL04DD4444', 'motorcycle', '2026-01-10 11:00:00'),
(8, 'DL05EE5555', 'car', '2026-01-10 14:00:00');

-- Toll rules
-- Motorcycle → free (0)
-- Car → 40
-- Bus → 70
-- Truck → 80
-- If the same vehicle returns within 4 hours:
-- Car → 20
-- Bus → 30
-- Truck → 40
-- Otherwise → charge full toll again
-- Goal: Total toll collected per day

with cte as(select *,lag(crossing_time) over(partition by vehicle_no order by crossing_time) prev_time , datediff(hour,lag(crossing_time) over(partition by vehicle_no order by crossing_time),crossing_time) as diff_hour, CASE WHEN VEHICLE_TYPE = 'car' then 40 When VEHICLE_TYPE = 'bus' then 70 when VEHICLE_TYPE = 'truck' then 80 else 0 end as tax_veh from toll_transactions)
,cte1 as (
select *,case when diff_hour<=4 then (CASE WHEN VEHICLE_TYPE = 'car' then 20 When VEHICLE_TYPE = 'bus' then 30 when VEHICLE_TYPE = 'truck' then 40 else 0 END) else tax_veh  end as tax_amt from cte)
select sum(tax_amt) from cte1;
-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE CombinationSides (
 CombinationID INT,
 SideID CHAR(1),
 SideLength INT
);

INSERT INTO CombinationSides (CombinationID, SideID, SideLength) VALUES
(1, 'A', 3),
(1, 'B', 4),
(1, 'C', 5),
(2, 'A', 2),
(2, 'B', 3),
(2, 'C', 6),
(3, 'A', 6),
(3, 'B', 7),
(3, 'C', 10);

select * from combinationsides;
with cte as (select * from combinationsides
pivot
(max(sidelength) for sideid in  ('A' as A,'B' as B,'C' as C)))--(any order by sideid)))
SELECT CombinationID
FROM cte
WHERE (A + B > C) AND (A + B > C) AND (B + C > A);

-------------------------------------------------------------------------------------------



CREATE TABLE user (
 UserID INT PRIMARY KEY,
 FirstName VARCHAR(50),
 LastName VARCHAR(50)
);

INSERT INTO user (UserID, FirstName, LastName) VALUES
(1, 'Aarav', 'Sharma'),
(2, 'Sophia', 'Johnson'),
(3, 'Rahul', 'Verma'),
(4, 'Emily', 'Williams'),
(5, 'Kunal', 'Mehta');

with cte as (select *,row_number() over(order by userid desc ) as rev_rnk from user)

select a.userid,a.firstname,b.lastname from cte a join cte b on a.userid=b.rev_rnk

------------------------------------------------------------------

CREATE TABLE Delievry_Partner (
 Brand_1 VARCHAR(512),
 Brand_2 VARCHAR(512),
 Brand_3 VARCHAR(512),
 Winner VARCHAR(512)
);

INSERT INTO Delievry_Partner (Brand_1, Brand_2, Brand_3, Winner) VALUES
 ('A', 'B', 'C', 'B'),
 ('B', 'C', 'E', 'E'),
 ('C', 'A', 'D', 'D'),
 ('D', 'E', 'A', 'A'),
 ('F', 'B', 'C', 'F');



 select * from Delievry_partner;
 select brand,winner from Delievry_partner 
 unpivot (winner for brand in ( Brand1,Brand2,Brand3));

SELECT brand,count(*) as total,sum(case when winner=brand then 1 else 0 end) as win,count(*)-sum(case when winner=brand then 1 else 0 end)as  loss
FROM Delievry_partner
UNPIVOT (
    brand FOR brand_col IN (Brand_1, Brand_2, Brand_3)
)
group by brand order by brand