--prob-66
CREATE TABLE covid_cases (
    record_date DATE PRIMARY KEY,
    cases_count int
);



INSERT INTO covid_cases (record_date, cases_count) VALUES
('2021-01-01',66),('2021-01-02',41),('2021-01-03',54),('2021-01-04',68),('2021-01-05',16),('2021-01-06',90),('2021-01-07',34),('2021-01-08',84),('2021-01-09',71),('2021-01-10',14),('2021-01-11',48),('2021-01-12',72),('2021-01-13',55),
('2021-02-01',38),('2021-02-02',57),('2021-02-03',42),('2021-02-04',61),('2021-02-05',25),('2021-02-06',78),('2021-02-07',33),('2021-02-08',93),('2021-02-09',62),('2021-02-10',15),('2021-02-11',52),('2021-02-12',76),('2021-02-13',45),
('2021-03-01',27),('2021-03-02',47),('2021-03-03',36),('2021-03-04',64),('2021-03-05',29),('2021-03-06',81),('2021-03-07',32),('2021-03-08',89),('2021-03-09',63),('2021-03-10',19),('2021-03-11',53),('2021-03-12',78),('2021-03-13',49),
('2021-04-01',39),('2021-04-02',58),('2021-04-03',44),('2021-04-04',65),('2021-04-05',30),('2021-04-06',87),('2021-04-07',37),('2021-04-08',95),('2021-04-09',60),('2021-04-10',13),('2021-04-11',50),('2021-04-12',74),('2021-04-13',46),
('2021-05-01',28),('2021-05-02',49),('2021-05-03',35),('2021-05-04',67),('2021-05-05',26),('2021-05-06',82),('2021-05-07',31),('2021-05-08',92),('2021-05-09',61),('2021-05-10',18),('2021-05-11',54),('2021-05-12',79),('2021-05-13',51),
('2021-06-01',40),('2021-06-02',59),('2021-06-03',43),('2021-06-04',66),('2021-06-05',27),('2021-06-06',85),('2021-06-07',38),('2021-06-08',94),('2021-06-09',64),('2021-06-10',17),('2021-06-11',55),('2021-06-12',77),('2021-06-13',48),
('2021-07-01',34),('2021-07-02',50),('2021-07-03',37),('2021-07-04',69),('2021-07-05',32),('2021-07-06',80),('2021-07-07',33),('2021-07-08',88),('2021-07-09',57),('2021-07-10',21),('2021-07-11',56),('2021-07-12',73),('2021-07-13',42),
('2021-08-01',41),('2021-08-02',53),('2021-08-03',39),('2021-08-04',62),('2021-08-05',23),('2021-08-06',83),('2021-08-07',29),('2021-08-08',91),('2021-08-09',59),('2021-08-10',22),('2021-08-11',51),('2021-08-12',75),('2021-08-13',44),
('2021-09-01',36),('2021-09-02',45),('2021-09-03',40),('2021-09-04',68),('2021-09-05',28),('2021-09-06',84),('2021-09-07',30),('2021-09-08',90),('2021-09-09',61),('2021-09-10',20),('2021-09-11',52),('2021-09-12',71),('2021-09-13',43),
('2021-10-01',46),('2021-10-02',58),('2021-10-03',41),('2021-10-04',63),('2021-10-05',24),('2021-10-06',82),('2021-10-07',34),('2021-10-08',86),('2021-10-09',56),('2021-10-10',14),('2021-10-11',57),('2021-10-12',70),('2021-10-13',47),
('2021-11-01',31),('2021-11-02',44),('2021-11-03',38),('2021-11-04',67),('2021-11-05',22),('2021-11-06',79),('2021-11-07',32),('2021-11-08',94),('2021-11-09',60),('2021-11-10',15),('2021-11-11',54),('2021-11-12',73),('2021-11-13',46),
('2021-12-01',29),('2021-12-02',50),('2021-12-03',42),('2021-12-04',65),('2021-12-05',25),('2021-12-06',83),('2021-12-07',30),('2021-12-08',93),('2021-12-09',58),('2021-12-10',19),('2021-12-11',52),('2021-12-12',75),('2021-12-13',48);

select * from covid_cases;

WITH month_cases AS(
SELECT extract(month from record_date) AS month_no,
sum(cases_count) as month_cases
FROM covid_cases
GROUP BY extract(month from record_date))
,cte1 as (
SELECT a.month_no as current_month,b.month_no as previous_month,a.month_cases as current_cases,b.month_cases as previous_cases
FROM month_cases a
left join month_cases b
ON a.month_no>b.month_no order by a.month_no
)
select current_month,current_cases,
sum((previous_cases)) AS prior_month_cases,
round(current_cases*100.0/sum((previous_cases)),2) AS mom_increase
from cte1 group by current_month,current_cases order by current_month
;

--sol2
WITH month_cases AS(
SELECT extract(month from record_date) AS month_no,
sum(cases_count) as month_cases
FROM covid_cases
GROUP BY extract(month from record_date))
select *,sum(month_cases) over(order by month_no rows between unbounded preceding and 1 preceding) as prior_month from month_cases;


-----------------------------------------------------------------------------------------

--prob-65
CREATE TABLE city_distance
(
    distance INT,
    source VARCHAR(512),
    destination VARCHAR(512)
);

delete from city_distance;
INSERT INTO city_distance(distance, source, destination) VALUES ('100', 'New Delhi', 'Panipat');
INSERT INTO city_distance(distance, source, destination) VALUES ('200', 'Ambala', 'New Delhi');
INSERT INTO city_distance(distance, source, destination) VALUES ('150', 'Bangalore', 'Mysore');
INSERT INTO city_distance(distance, source, destination) VALUES ('150', 'Mysore', 'Bangalore');
INSERT INTO city_distance(distance, source, destination) VALUES ('250', 'Mumbai', 'Pune');
INSERT INTO city_distance(distance, source, destination) VALUES ('250', 'Pune', 'Mumbai');
INSERT INTO city_distance(distance, source, destination) VALUES ('2500', 'Chennai', 'Bhopal');
INSERT INTO city_distance(distance, source, destination) VALUES ('2500', 'Bhopal', 'Chennai');
INSERT INTO city_distance(distance, source, destination) VALUES ('60', 'Tirupati', 'Tirumala');
INSERT INTO city_distance(distance, source, destination) VALUES ('80', 'Tirumala', 'Tirupati');



with cte as (select case when source<destination then source else destination end as city1
,case when source>destination then source else destination end as city2,*
from city_distance order by city1)
,cte1 as( select *,count(*) over(partition by city1,city2,distance order by distance) cnt from cte order by source)
select * from cte1 where cnt=1 or (source<destination);


----sol2
with cte as (select *,row_number() over(order by (select null)) as rnk from city_distance)
select c1.* from cte c1 left join cte c2 on c1.source=c2.destination and c2.source=c1.destination 
where c2.distance is NULL or c1.distance!=c2.distance or c1.rnk<c2.rnk
order by c1.source

----------------------------------------------------------------------------------------------
--prob-64

-- Create the table
CREATE TABLE stock (
    supplier_id INT,
    product_id INT,
    stock_quantity INT,
    record_date DATE
);

-- Insert the data
delete from stock;
INSERT INTO stock (supplier_id, product_id, stock_quantity, record_date)
VALUES
    (1, 1, 60, '2022-01-01'),
    (1, 1, 40, '2022-01-02'),
    (1, 1, 35, '2022-01-03'),
    (1, 1, 45, '2022-01-04'),
 (1, 1, 51, '2022-01-06'),
 (1, 1, 55, '2022-01-09'),
 (1, 1, 25, '2022-01-10'),
    (1, 1, 48, '2022-01-11'),
 (1, 1, 45, '2022-01-15'),
    (1, 1, 38, '2022-01-16'),
    (1, 2, 45, '2022-01-08'),
    (1, 2, 40, '2022-01-09'),
    (2, 1, 45, '2022-01-06'),
    (2, 1, 55, '2022-01-07'),
    (2, 2, 45, '2022-01-08'),
    (2, 2, 48, '2022-01-09'),
    (2, 2, 35, '2022-01-10'),
    (2, 2, 52, '2022-01-15'),
    (2, 2, 23, '2022-01-16');


select * from stock;

with cte as (select *,row_number() over(partition by supplier_id,product_id order by record_date) as rnk,dateadd(day,-row_number() over(partition by supplier_id,product_id order by record_date),record_date) as g_flg from stock where stock_quantity<50 order by supplier_id,product_id
)
select supplier_id,product_id,count(*),min(record_date) from cte
group by supplier_id,product_id,g_flg  having count(*)>=2order by supplier_id,product_id
;
------------------------------------------------------------------------------------------------------------

--prob-62
CREATE TABLE user_interactions (
    user_id varchar(10),
    event varchar(15),
    event_date DATE,
    interaction_type varchar(15),
    game_id varchar(10),
    event_time TIME
);

-- Insert the data
INSERT INTO user_interactions 
VALUES
('abc', 'game_start', '2024-01-01', null, 'ab0000', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab0000', '10:00:00'),
('def', 'send_emoji', '2024-01-01', 'emoji1', 'ab0000', '10:03:20'),
('def', 'send_message', '2024-01-01', 'preloaded_quick', 'ab0000', '10:03:49'),
('abc', 'send_gift', '2024-01-01', 'gift1', 'ab0000', '10:04:40'),
('abc', 'game_end', '2024-01-01', NULL, 'ab0000', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab0000', '10:10:00'),
('abc', 'game_start', '2024-01-01', null, 'ab9999', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab9999', '10:00:00'),
('abc', 'send_message', '2024-01-01', 'custom_typed', 'ab9999', '10:02:43'),
('abc', 'send_gift', '2024-01-01', 'gift1', 'ab9999', '10:04:40'),
('abc', 'game_end', '2024-01-01', NULL, 'ab9999', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab9999', '10:10:00'),
('abc', 'game_start', '2024-01-01', null, 'ab1111', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab1111', '10:00:00'),
('abc', 'game_end', '2024-01-01', NULL, 'ab1111', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab1111', '10:10:00'),
('abc', 'game_start', '2024-01-01', null, 'ab1234', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab1234', '10:00:00'),
('abc', 'send_message', '2024-01-01', 'custom_typed', 'ab1234', '10:02:43'),
('def', 'send_emoji', '2024-01-01', 'emoji1', 'ab1234', '10:03:20'),
('def', 'send_message', '2024-01-01', 'preloaded_quick', 'ab1234', '10:03:49'),
('abc', 'send_gift', '2024-01-01', 'gift1', 'ab1234', '10:04:40'),
('abc', 'game_end', '2024-01-01', NULL, 'ab1234', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab1234', '10:10:00');


with cte as
(
	select game_id, 
	case when count(interaction_type)=0 then 'No Social Interaction'
	 when count(distinct case when interaction_type is not null then user_id else NULL end)=1 then 'One Sided Interaction' 
	 when count(distinct case when interaction_type='custom_typed' then user_id else NULL end)>=1 then 'Both sided with custom from one side'
	 else 'Both sided interaction without custom' end
	as game_type 
	from user_interactions
	group by game_id)
select game_type, count(1)*100/(count(1) over ()) as percentage  
from cte
group by game_type
order by game_type;


select game_id,interaction_type,case when interaction_type is not null then user_id  end from user_interactions


--------------------------------------------------------------------------------------------------------------

--prob-61

create table customers  (customer_name varchar(30));
insert into customers values ('Ankit Bansal')
,('Vishal Pratap Singh')
,('Michael'); 

select  *,length((customer_name))-length(replace(customer_name,' ','')) as no_of_space,position(' ' in customer_name) as first_space,position(' ' in substring(customer_name,position(' ' in customer_name)+1)) from customers
;

with cte as(
	select customer_name, value 
	,row_number() over (partition by customer_name order by customer_name) as rnk
	,count(value) over(partition by customer_name order by customer_name) as cnt
	from customers ,
	lateral SPLIT_TO_TABLE(customer_name ,  ' ')
)
,cte2 as (
	select customer_name 
	,case when rnk =  1  then value end as first_name
	,case when rnk = 2 and cnt = 3 then value end as  middle_name
	,case when (rnk = 2 and cnt = 2)  or (rnk = 3 or cnt = 3) then value end as  last_name,rnk,cnt
	from cte 
)
select customer_name 
, max(first_name) as first_name 
, max(middle_name) as middle_name 
, max(last_name) as last_name 
from cte2 group by customer_name;

with cte as (select *,LEN(customer_name)-len(REPLACE(customer_name,' ','')) as l
,CHARINDEX(' ',customer_name) as f,
CHARINDEX(' ',customer_name,CHARINDEX(' ',customer_name)+1) as s from Customers)
select *,case when l=0 then customer_name else substring(customer_name,1,f-1) end as firstn,
case when l<=1 then null else  substring(customer_name,f+1,s-f-1) end as secnd,
case when l<1 then null
when l=1 then  substring(customer_name,f+1,len(customer_name)-1)
when l=2 then substring(customer_name,s+1,len(customer_name)-2) end as lastgg
from cte
;


---------------------------------------------------------------------------------------------------------

--prob-59
--here is the script:
create table sku 
(
sku_id int,
price_date date ,
price int
);
delete from sku;
insert into sku values 
(1,'2023-01-01',10)
,(1,'2023-02-15',15)
,(1,'2023-03-03',18)
,(1,'2023-03-27',15)
,(1,'2023-04-06',20);

select * from sku;


with cte as(select *,row_number() over(partition by sku_id,extract(year from price_date) ,extract(month from price_date) order by price_date) rnk from sku)
,cte1 as (
select sku_id,price_date,price from sku where date_part(day,price_date)=1 
union all
select sku_id,date_trunc(month,dateadd(month,1,PRICE_DATE)) next_month,price from cte where rnk=1 and date_trunc(month,dateadd(month,1,PRICE_DATE)) not in (select price_date from sku where date_part(day,price_date)=1 )
)
select * from cte1
;

WITH CTE AS(
select MIN(PRICE_DATE)  dt, 1 as cnt,  
date_part(month,max(PRICE_DATE)) CNTDT
from SKU
union all
select DATEADD(MONTH,1, dt) dt, cnt+1 cnt, CNTDT
FROM CTE where CNTDT>=CNT
)
, skct as(
select PRICE_DATE, dateadd(day,-1,(lead(price_date,1, DATEADD(month,1,price_date))
over(ORDER BY price_date))) NXTDT,
 price
FROM sku
) 
select *, price,lag(price,1, price)
over(ORDER BY price_date) as previous_price, ABS(PRICE- 
lag(price,1, price)
over(ORDER BY price_date))
FROM cte left join skct
on 1=1 and dt between price_date and nxtdt


-------------------------------------------------------------------------------------------------------------------

--prob-58
CREATE TABLE travel_data (
    customer VARCHAR(10),
    start_loc VARCHAR(50),
    end_loc VARCHAR(50)
);

INSERT INTO travel_data (customer, start_loc, end_loc) VALUES
    ('c1', 'New York', 'Lima'),
    ('c1', 'London', 'New York'),
    ('c1', 'Lima', 'Sao Paulo'),
    ('c1', 'Sao Paulo', 'New Delhi'),
    ('c2', 'Mumbai', 'Hyderabad'),
    ('c2', 'Surat', 'Pune'),
    ('c2', 'Hyderabad', 'Surat'),
    ('c3', 'Kochi', 'Kurnool'),
    ('c3', 'Lucknow', 'Agra'),
    ('c3', 'Agra', 'Jaipur'),
    ('c3', 'Jaipur', 'Kochi');


 select A.customer, start_loc,end_loc from 
 (select customer ,start_loc from travel_data 
	except
 select customer ,end_loc from travel_data 
 )A,
 (
 select customer ,end_loc from travel_data 
	except
 select customer ,start_loc from travel_data 
 )B
 where A.customer = B.customer;

 --sol2
with cte as(
 select customer,start_loc as loc,'start' as d_type from travel_data
 union all
 select customer,end_loc,'end' as d_type from travel_data)
 ,cte1 as (
select *,count(*) over(partition by customer,loc order by loc ) as cnt from cte )
select customer,min(case when d_type='start' then loc end) as start_loc , min(case when d_type='end' then loc end) as end_loc from cte1  where cnt=1 group by customer;

--sol3
select coalesce(a.customer,b.customer),max(a.start_loc),max(b.end_loc) from 
travel_data a full join 
travel_data b  on a.customer=b.customer and a.start_loc=b.end_loc where a.start_loc is null or b.end_loc is null
group by coalesce(a.customer,b.customer)
;


----------------------------------------------------------------------------------------------------------------------


--prob-57

create table namaste_orders
(
order_id int,
city varchar(10),
sales int
);

create table namaste_returns
(
order_id int,
return_reason varchar(20)
);

insert into namaste_orders
values(1, 'Mysore' , 100),(2, 'Mysore' , 200),(3, 'Bangalore' , 250),(4, 'Bangalore' , 150)
,(5, 'Mumbai' , 300),(6, 'Mumbai' , 500),(7, 'Mumbai' , 800)
;
insert into namaste_returns values
(3,'wrong item'),(6,'bad quality'),(7,'wrong item');


select * from namaste_orders;
select * from namaste_returns;

select * from namaste_orders where city not in (select distinct city from namaste_orders o left join 
 namaste_returns r on o.order_id=r.order_id where r.order_id is not NULL);

 select o.city,count(r.order_id) from namaste_orders o left join 
 namaste_returns r on o.order_id=r.order_id group by o.city having count(r.order_id)=0  ;


 ---------------------------------------------------------------------------------------------------------------------

 --prob-56
 create table job_positions (id  int,
                                             title varchar(100),
                                              groups varchar(10),
                                              levels varchar(10),     
                                               payscale int, 
                                               totalpost int );
 insert into job_positions values (1, 'General manager', 'A', 'l-15', 10000, 1); 
insert into job_positions values (2, 'Manager', 'B', 'l-14', 9000, 5); 
insert into job_positions values (3, 'Asst. Manager', 'C', 'l-13', 8000, 10);  

  create table job_employees ( id  int, 
                                                 name   varchar(100),     
                                                  position_id  int 
                                                );  
  insert into job_employees values (1, 'John Smith', 1); 
insert into job_employees values (2, 'Jane Doe', 2);
 insert into job_employees values (3, 'Michael Brown', 2);
 insert into job_employees values (4, 'Emily Johnson', 2); 
insert into job_employees values (5, 'William Lee', 3); 
insert into job_employees values (6, 'Jessica Clark', 3); 
insert into job_employees values (7, 'Christopher Harris', 3);
 insert into job_employees values (8, 'Olivia Wilson', 3);
 insert into job_employees values (9, 'Daniel Martinez', 3);
 insert into job_employees values (10, 'Sophia Miller', 3);



with cte as (
select id,title, payscale,totalpost,1 as t from job_positions 
union all
select id,title, payscale,totalpost, t+1 as t from cte where t<totalpost)
,c as (select * ,ROW_NUMBER()over(partition by position_id order by position_id) as r
from job_employees )

select cte.*,coalesce(name,'v') as name  from cte left join c  on 
position_id=cte.id and r=t


------------------------------------------------------------------------------------------------------

--prob-55
Create table candidates(
id int primary key,
positions varchar(10) not null,
salary int not null);

-- test case 1:
insert into candidates values(1,'junior',5000);
insert into candidates values(2,'junior',7000);
insert into candidates values(3,'junior',7000);
insert into candidates values(4,'senior',10000);
insert into candidates values(5,'senior',30000);
insert into candidates values(6,'senior',20000);

--test case 2:
insert into candidates values(20,'junior',10000);
insert into candidates values(30,'senior',15000);
insert into candidates values(40,'senior',30000);

--test case 3:
insert into candidates values(1,'junior',15000);
insert into candidates values(2,'junior',15000);
insert into candidates values(3,'junior',20000);
insert into candidates values(4,'senior',60000);

--test case 4:
insert into candidates values(10,'junior',10000);
insert into candidates values(40,'junior',10000);
insert into candidates values(20,'senior',15000);
insert into candidates values(30,'senior',30000);
insert into candidates values(50,'senior',15000);



select * from candidates;

with cte as(select *,sum(salary) over(partition by positions order by salary,id ) as c_sal from candidates)
,seniors as (select * from cte where positions='senior' and c_sal<=50000)
select * from cte where positions='junior' and c_sal<=50000-(select sum(salary) from seniors)
union all
select * from seniors;

-------------------------------------------------------------------------------------------------------------------

--prob-54

CREATE TABLE entry_details (
    employeeid INT,
    entry_details VARCHAR(50),
    timestamp_details DATETIME
);

INSERT INTO entry_details (employeeid, entry_details, timestamp_details) VALUES
(1000, 'login', '2023-06-16 01:00:15.34'),
(1000, 'login', '2023-06-16 02:00:15.34'),
(1000, 'login', '2023-06-16 03:00:15.34'),
(1000, 'logout', '2023-06-16 12:00:15.34'),
(1001, 'login', '2023-06-16 01:00:15.34'),
(1001, 'login', '2023-06-16 02:00:15.34'),
(1001, 'login', '2023-06-16 03:00:15.34');


CREATE TABLE employee_details (
    employeeid INT,
    phone_number VARCHAR(20),
    isdefault BOOLEAN
);

INSERT INTO employee_details (employeeid, phone_number, isdefault) VALUES
(1001, '9999', FALSE),
(1001, '1111', FALSE),
(1001, '2222', TRUE),
(1003, '3333', FALSE);

select * from employee_details;
select * from entry_details;



with cte as(
select employeeid,
count(entry_details) Total_enters ,
max(case when entry_details = 'login'then timestamp_details end)MaxLogin,
max(case when entry_details = 'logout'then timestamp_details end)MaxLogout,
sum(case when entry_details = 'login' then 1 end) Totallogins,
sum(case when entry_details = 'logout' then 1 end) Totallogouts
from entry_details
group by employeeid )
select * 
from cte c 
left join employee_details e on c.employeeid=e.employeeid and isdefault = 'true';

--another sol
with cte as(
select employeeid,
count(entry_details) Total_enters ,
max(case when entry_details = 'login'then timestamp_details end)MaxLogin,
max(case when entry_details = 'logout'then timestamp_details end)MaxLogout,
sum(case when entry_details = 'login' then 1 end) Totallogins,
sum(case when entry_details = 'logout' then 1 end) Totallogouts
from employee_checkin_details
group by employeeid )
select * 
from cte c 
left join employee_details e on c.employeeid=e.employeeid and isdefault = 'true'


-----------------------------------------------------------------------------------------------------------------

--prob-53

create table emp_53(
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
emp_age int);

insert into emp_53
values
(1, 'Ankit', 100,10000, 4, 39);
insert into emp_53
values (2, 'Mohit', 100, 15000, 5, 48);
insert into emp_53
values (3, 'Vikas', 100, 10000,4,37);
insert into emp_53
values (4, 'Rohit', 100, 5000, 2, 16);
insert into emp_53
values (5, 'Mudit', 200, 12000, 6,55);
insert into emp_53
values (6, 'Agam', 200, 12000,2, 14);
insert into emp_53
values (7, 'Sanjay', 200, 9000, 2,13);
insert into emp_53
values (8, 'Ashish', 200,5000,2,12);
insert into emp_53
values (9, 'Mukesh',300,6000,6,51);
insert into emp_53
values (10, 'Rakesh',300,7000,6,50);




 WITH CTE as(
SELECT *,avg(salary)OVER(PARTITION BY department_id)AS avg_dept_salary,
count(emp_id)OVER(PARTITION BY department_id) AS emp_dept_count,
avg(salary)OVER() AS total_avg_salary,
count(emp_id)OVER() AS emp_overall_count
FROM emp_53),
cte_2 AS(
SELECT *,((total_avg_salary*emp_overall_count)-(emp_dept_count*avg_dept_salary))/(emp_overall_count-emp_dept_count) AS avg_desired
FROM CTE)
SELECT * FROM cte_2
WHERE avg_dept_salary<avg_desired;



--sol2

select e.department_id,avg(e.salary) as avg_sal,avg(case when e.department_id!=e2.department_id then e2.salary else 0 end) 
from emp e join emp e2 on e.department_id!=e2.department_id
group by e.department_id
having avg(e.salary)<avg(case when e.department_id!=e2.department_id then e2.salary else 0 end)
;
select *,case when e.department_id!=e2.department_id then e2.salary else 0 end from emp e join emp e2 on e.department_id!=e2.department_id order by e.department_id;


---------------------------------------------------------------------------------------------------------------------

--prob-52
create table hall_events
(
hall_id integer,
start_date date,
end_date date
);
delete from hall_events;
insert into hall_events values 
(1,'2023-01-13','2023-01-14')
,(1,'2023-01-14','2023-01-17')
,(1,'2023-01-15','2023-01-17')
,(1,'2023-01-18','2023-01-25')
,(2,'2022-12-09','2022-12-23')
,(2,'2022-12-13','2022-12-17')
,(3,'2022-12-01','2023-01-30');



with cte as (
select 
* 
,lag(end_date,1) over(partition by hall_id order by start_date) as prev_end_date,
case when start_date <=lag(end_date,1) over(partition by hall_id order by start_date) then 0 else 1 end as flg
from hall_events
)
, cte2 as (
select
*
,sum(flg) over(partition by hall_id order by start_date) as grp_id
from cte
)

select
hall_id,
min(start_date) as start_date,
max(end_date) as end_date
from cte2
group by hall_id,grp_id
order by hall_id;

--sol2


with cte as (

select *,case when  coalesce(rnk,end_date) between start_date and end_date then 1 else 0 end 
as overlapping from (
select *,LAG(end_date,1) over (partition by hall_id order by end_date) as rnk
from hall_events
)a
)

select hall_id, MIN(start_date) as start_date , max(end_date) as end_date from cte where overlapping=1 group by hall_id
union 
select hall_id,start_date,end_date 
from cte where overlapping=0;

------------------------------------------------------------------------------------------------------------------

--prob-51
CREATE TABLE booking_table(
   Booking_id       VARCHAR(3) NOT NULL 
  ,Booking_date     date NOT NULL
  ,User_id          VARCHAR(2) NOT NULL
  ,Line_of_business VARCHAR(6) NOT NULL
);
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b1','2022-03-23','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b2','2022-03-27','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b3','2022-03-28','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b4','2022-03-31','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b5','2022-04-02','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b6','2022-04-02','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b7','2022-04-06','u5','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b8','2022-04-06','u6','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b9','2022-04-06','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b10','2022-04-10','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b11','2022-04-12','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b12','2022-04-16','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b13','2022-04-19','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b14','2022-04-20','u5','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b15','2022-04-22','u6','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b16','2022-04-26','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b17','2022-04-28','u2','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b18','2022-04-30','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b19','2022-05-04','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b20','2022-05-06','u1','Flight');
;
CREATE TABLE user_table(
   User_id VARCHAR(3) NOT NULL
  ,Segment VARCHAR(2) NOT NULL
);
INSERT INTO user_table(User_id,Segment) VALUES ('u1','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u2','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u3','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u4','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u5','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u6','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u7','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u8','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u9','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u10','s3');