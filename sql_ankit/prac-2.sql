CREATE TABLE students (
    studentid INT NULL,
    studentname NVARCHAR(255) NULL,
    subject NVARCHAR(255) NULL,
    marks INT NULL,
    testid INT NULL,
    testdate DATE NULL
);
INSERT INTO students (studentid, studentname, subject, marks, testid, testdate) VALUES
(2, 'Max Ruin', 'Subject1', 63, 1, '2022-01-02'),
(3, 'Arnold', 'Subject1', 95, 1, '2022-01-02'),
(4, 'Krish Star', 'Subject1', 61, 1, '2022-01-02'),
(5, 'John Mike', 'Subject1', 91, 1, '2022-01-02'),
(4, 'Krish Star', 'Subject2', 71, 1, '2022-01-02'),
(3, 'Arnold', 'Subject2', 32, 1, '2022-01-02'),
(5, 'John Mike', 'Subject2', 61, 2, '2022-11-02'),
(1, 'John Deo', 'Subject2', 60, 1, '2022-01-02'),
(2, 'Max Ruin', 'Subject2', 84, 1, '2022-01-02'),
(2, 'Max Ruin', 'Subject3', 29, 3, '2022-01-03'),
(5, 'John Mike', 'Subject3', 98, 2, '2022-11-02');

--problem1
with cte as (select *,avg(marks) over(partition by  subject)avg from students)
select * from cte where marks>avg;
--problem2
select (count(distinct case when  marks>90 then studentid end)*1.0/count(distinct studentid))*100  as marks90student_percent from students;
--problem3
with cte as(select *,
rank() over(partition by subject order by marks desc) as sec_highest,
rank() over(partition by subject order by marks) as sec_lowest
from students
order by subject)
select subject,
max(case when sec_highest=2 then marks end) as second_highest_marks,
max(case when sec_lowest=2 then marks end) as second_lowest_marks
from cte 
group by 1;
--problem 4
select *, case when marks>prev_marks then 'INC' when marks<prev_marks then 'DEC' else null end as 
flag
from (select *,
lag(marks) over (partition by studentid order by testdate,subject) as prev_marks
from students
order by studentid, testdate, subject) a
-----------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE int_orders(
 order_number int NOT NULL,
 order_date date NOT NULL,
 cust_id int NOT NULL,
 salesperson_id int NOT NULL,
 amount float NOT NULL
);

INSERT INTO int_orders (order_number, order_date, cust_id, salesperson_id, amount) VALUES (30, CAST('1995-07-14' AS Date), 9, 1, 460);

INSERT into int_orders (order_number, order_date, cust_id, salesperson_id, amount) VALUES (10, CAST('1996-08-02' AS Date), 4, 2, 540);

INSERT INTO int_orders (order_number, order_date, cust_id, salesperson_id, amount) VALUES (40, CAST('1998-01-29' AS Date), 7, 2, 2400);

INSERT INTO int_orders (order_number, order_date, cust_id, salesperson_id, amount) VALUES (50, CAST('1998-02-03' AS Date), 6, 7, 600);

INSERT into int_orders (order_number, order_date, cust_id, salesperson_id, amount) VALUES (60, CAST('1998-03-02' AS Date), 6, 7, 720);

INSERT into int_orders (order_number, order_date, cust_id, salesperson_id, amount) VALUES (70, CAST('1998-05-06' AS Date), 9, 7, 150);

INSERT into int_orders (order_number, order_date, cust_id, salesperson_id, amount) VALUES (20, CAST('1999-01-30' AS Date), 4, 8, 1800);
--without window,sql function
select a.order_number,a.order_date,a.cust_id,a.salesperson_id,a.amount from int_orders a join int_orders b  on a.salesperson_id=b.salesperson_id
group by a.order_number,a.order_date,a.cust_id,a.salesperson_id,a.amount
having a.amount>=max(b.amount);

select a.* from int_orders a 
left join int_orders b 
on a.salesperson_id = b.salesperson_id and  a.amount< b.amount 
where b.amount is  null ;

select o1.* from int_orders as o1 inner join (
select salesperson_id,max(amount) as amount
from int_orders 
group by salesperson_id) as o2
on o1.salesperson_id = o2.salesperson_id and 
o1.amount = o2.amount
order by o1.salesperson_id asc;

-------------------------------------------------------------------------------------------------------------------------------------------
create table event_status
(
event_time varchar(10),
status varchar(10)
);
delete from event_status;
insert into event_status 
values
('10:01','on'),('10:02','on'),('10:03','on'),('10:04','off'),('10:05','on'),('10:06','off'),('10:07','on'),('10:08','on'),('10:09','off')
,('10:11','on'),('10:12','off');
select * from event_status;
with cte as(
select *, lag(status,1,status) over(order by event_time) as previous_status
from event_status),cte1 as(
select *,sum(case when status='on' and previous_status='off' then 1 else 0 end) over(order by event_time) as flag from cte
)
select min(event_time) as login,max(event_time)as logout,count(status)-1 from cte1 group by flag;

with cte as(
select *, sum(case when status='on' then 0 else 1 end) over(order by event_time desc) grp_key 
from event_status )
select min(event_time) login, max(event_time) logout, count(*)-1 count
from cte 
group by grp_key
order by grp_key desc;

-------------------------------------------------------------------------------------------------------------------------------------

create table players_location
(
name varchar(20),
city varchar(20)
);
delete from players_location;
insert into players_location
values ('Sachin','Mumbai'),('Virat','Delhi') , ('Rahul','Bangalore'),('Rohit','Mumbai'),('Mayank','Bangalore');
select * from players_location;
select
max(case when city = 'Bangalore' then name end) as Bangalore,
max(case when city = 'Mumbai' then name end) as Mumbai ,
max(case when city = 'Delhi' then name end) as Delhi
from
(select *, row_number() over (partition by city order by name) as player_groups from
players_location)a
group by player_groups
order by player_groups;

select * from ( select *, row_number() over (partition by city order by name) as rnk from
players_location)
    PIVOT(min(name) FOR city IN (ANY ORDER BY city))
  ORDER BY rnk;
--------------------------------------------------------------------------------------------------------------------------------------
drop table if exists employee;
create table employee 
(
emp_id int,
company varchar(10),
salary int
);

insert into employee values (1,'A',2341);
insert into employee values (2,'A',341);
insert into employee values (3,'A',15);
insert into employee values (4,'A',15314);
insert into employee values (5,'A',451);
insert into employee values (6,'A',513);
insert into employee values (7,'B',15);
insert into employee values (8,'B',13);
insert into employee values (9,'B',1154);
insert into employee values (10,'B',1345);
insert into employee values (11,'B',1221);
insert into employee values (12,'B',234);
insert into employee values (13,'C',2345);
insert into employee values (14,'C',2645);
insert into employee values (15,'C',2645);
insert into employee values (16,'C',2652);
insert into employee values (17,'C',65);

with cte as(select *,row_number() over(partition by company order by salary) as rnk, count(1) over(partition by company) as cnt from employee order by company, salary)
select round(avg(salary),0) as avg,company from cte  where rnk between cnt*1.0/2 and (cnt*1.0/2)+1 group by company;

with cte as (
select *, row_number() over (partition by company order by salary asc)rnk ,cast( count(1) over (partition by company) as float )/2 as cnt
, row_number() over (partition by company order by salary asc) - 
cast( count(1) over (partition by company) as float )/2 as mid_level
from employee order by company,salary),
cte2 as (
select Company, Salary from cte
where mid_level = 0 or mid_level = 0.5 or mid_level = 1 )
select Company, 
avg(salary) as median 
from cte2
group by Company
---------------------------------------------------------------------------------------------------------------------------------------------

drop table if exists emp;
CREATE TABLE emp (
    emp_id INT NULL,
    emp_name VARCHAR(50) NULL,
    salary INT NULL,
    manager_id INT NULL,
    emp_age INT NULL,
    dep_id INT NULL,
    dep_name VARCHAR(20) NULL,
    gender VARCHAR(10) NULL
);
INSERT INTO emp VALUES (1, 'Ankit', 14300, 4, 39, 100, 'Analytics', 'Female');
INSERT INTO emp VALUES (2, 'Mohit', 14000, 5, 48, 200, 'IT', 'Male');
INSERT INTO emp VALUES (3, 'Vikas', 12100, 4, 37, 100, 'Analytics', 'Female');
INSERT INTO emp VALUES (4, 'Rohit', 7260, 2, 16, 100, 'Analytics', 'Female');
INSERT INTO emp VALUES (5, 'Mudit', 15000, 6, 55, 200, 'IT', 'Male');
INSERT INTO emp VALUES (6, 'Agam', 15600, 2, 14, 200, 'IT', 'Male');
INSERT INTO emp VALUES (7, 'Sanjay', 12000, 2, 13, 200, 'IT', 'Male');
INSERT INTO emp VALUES (8, 'Ashish', 7200, 2, 12, 200, 'IT', 'Male');
INSERT INTO emp VALUES (9, 'Mukesh', 7000, 6, 51, 300, 'HR', 'Male');
INSERT INTO emp VALUES (10, 'Rakesh', 8000, 6, 50, 300, 'HR', 'Male');
INSERT INTO emp VALUES (11, 'Akhil', 4000, 1, 31, 500, 'Ops', 'Male');

with cte as 
(select *,RANK() over(partition by dep_id order by salary desc) as rnk,
 count(*) over(partition by dep_id ) as cnt from emp)
 select * from cte where rnk=3 or (rnk<3 and cnt=rnk)
 -----------------------------------------------------------------------------------------------------------------------------------------

 create table stadium (
id int,
visit_date date,
no_of_people int
);

insert into stadium
values (1,'2017-07-01',10)
,(2,'2017-07-02',109)
,(3,'2017-07-03',150)
,(4,'2017-07-04',99)
,(5,'2017-07-05',145)
,(6,'2017-07-06',1455)
,(7,'2017-07-07',199)
,(8,'2017-07-08',188);


with cte as (select *, row_number() over(order by visit_date) rnk from stadium  where NO_OF_PEOPLE>100),
cte1 as (select *,dateadd('day',-1*rnk,visit_date) flag from cte ) 
select * from cte1 qualify (count(1) over(partition by flag) )>3

---------------------------------------------------------------------------------------------------------------------------------------
create table business_city (
business_date date,
city_id int
);
delete from business_city;
insert into business_city
values(cast('2020-01-02' as date),3),(cast('2020-07-01' as date),7),(cast('2021-01-01' as date),3),(cast('2021-02-03' as date),19)
,(cast('2022-12-01' as date),3),(cast('2022-12-15' as date),3),(cast('2022-02-28' as date),12);

with cte as (select * , min(business_date) over(partition by city_id ) as min_date from business_city)
select extract(year from business_date),count(case when business_date=min_date then 1 end) as count from cte group by extract(year from business_date);

with cte as(
select business_date,city_id,rank() over(partition by city_id order by business_date ) as rn
from business_city order by business_date,city_id)
select year(business_date) as year , count(distinct city_id) as new_cities
from cte
where rn=1
group by year(business_date)


---------------------------------------------------------------------------------------------------------------------------------------------
create table movie(
seat varchar(50),occupancy int
);
insert into movie values('a1',1),('a2',1),('a3',0),('a4',0),('a5',0),('a6',0),('a7',1),('a8',1),('a9',0),('a10',0),
('b1',0),('b2',0),('b3',0),('b4',1),('b5',1),('b6',1),('b7',1),('b8',0),('b9',0),('b10',0),
('c1',0),('c2',1),('c3',0),('c4',1),('c5',1),('c6',0),('c7',1),('c8',0),('c9',0),('c10',1);

;with cte as (
select *,LEFT(seat,1) as row_id,cast(SUBSTRING(seat,2,2)as int) as seat_no
from movie)
,final as (
select *,row_number()over(partition by row_id order by seat_no) as rn ,
abs(seat_no-row_number()over(partition by row_id order by seat_no)) as diff
from cte 
where occupancy =0)
select seat from (
select *,
count(1)over(partition by row_id,diff) as cnt
from final)a where cnt=4

----------------------------------------------------------------------------------------------------------------------

create table call_details  (
call_type varchar(10),
call_number varchar(12),
call_duration int
);

insert into call_details
values ('OUT','181868',13),('OUT','2159010',8)
,('OUT','2159010',178),('SMS','4153810',1),('OUT','2159010',152),('OUT','9140152',18),('SMS','4162672',1)
,('SMS','9168204',1),('OUT','9168204',576),('INC','2159010',5),('INC','2159010',4),('SMS','2159010',1)
,('SMS','4535614',1),('OUT','181868',20),('INC','181868',54),('INC','218748',20),('INC','2159010',9)
,('INC','197432',66),('SMS','2159010',1),('SMS','4535614',1);

select * from call_details;

with cte as(select call_number,sum(case when call_type='OUT' then call_duration end)as out_call,sum(case when call_type='INC' then call_duration end)as INC_call,sum(case when call_type='OUT' then 1 end)as out_call_count,sum(case when call_type='INC' then 1 end)as INC_call_count
from call_details group by call_number )
select * from cte where out_call is not NULL and inc_call is not NULL and out_call>inc_call;
-------------------------------------------------------------------------------------------------------------------
--36
with cte1 as (
select *,sum(Runs)
over(order by Match rows between
unbounded preceding and current row) as totalruns from sachin_scores)
,cte2 as(
select top 1  *,1000 as milestone_runs from cte1 where totalruns > 1000
union
select top 1  *,5000 as milestone_runs from cte1 where totalruns > 5000
union
select top 1  *,10000 as milestone_runs from cte1 where totalruns > 10000)

select ROW_NUMBER()over(order by Match) as milestone_number,
milestone_runs,Innings as miliestone_Innings,
Match as milestone_match_number from cte2


----------------------------------------------------------------------------------------------------------

create table brands 
(
category varchar(20),
brand_name varchar(20)
);
insert into brands values
('chocolates','5-star')
,(null,'dairy milk')
,(null,'perk')
,(null,'eclair')
,('Biscuits','britannia')
,(null,'good day')
,(null,'boost');

with cte as(select *,row_number() over (order by (select null )) as rnk from brands)
select last_value(category) ignore nulls over(order by rnk rows between unbounded preceding and current row) last_not_null,* from cte;


with cte1 as (
select * , 
row_number() over(order by (select null)) rn  
from brands
)
	select min(category) over(order by rn rows between unbounded preceding and current row) category, 
	brand_name
	from cte1;
    --------------------------------------------------------------------------------------------------------------
drop table if exists students;
create table students
(
student_id int,
student_name varchar(20)
);
insert into students values
(1,'Daniel'),(2,'Jade'),(3,'Stella'),(4,'Jonathan'),(5,'Will');
drop table if exists exams;
create table exams
(
exam_id int,
student_id int,
score int);

insert into exams values
(10,1,70),(10,2,80),(10,3,90),(20,1,80),(30,1,70),(30,3,80),(30,4,90),(40,1,60)
,(40,2,70),(40,4,80);

select * from exams;
select * from students;
with cte as(select *,max(score) over(partition by exam_id) as max_score,min(score) over (partition by exam_id) as min_score  from exams),cte2 as (
select student_id, max(case when  score =min_score or score=max_score then 1 else 0 end ) flag from cte group by student_id )
select student_id,flag from cte2 where flag=0; 

----------------------------------------------------------------------------------------------------------------------------------------

create table phonelog(
    Callerid int, 
    Recipientid int,
    Datecalled datetime
);

insert into phonelog(Callerid, Recipientid, Datecalled)
values(1, 2, '2019-01-01 09:00:00.000'),
       (1, 3, '2019-01-01 17:00:00.000'),
       (1, 4, '2019-01-01 23:00:00.000'),
       (2, 5, '2019-07-05 09:00:00.000'),
       (2, 3, '2019-07-05 17:00:00.000'),
       (2, 3, '2019-07-05 17:20:00.000'),
       (2, 5, '2019-07-05 23:00:00.000'),
       (2, 3, '2019-08-01 09:00:00.000'),
       (2, 3, '2019-08-01 17:00:00.000'),
       (2, 5, '2019-08-01 19:30:00.000'),
       (2, 4, '2019-08-02 09:00:00.000'),
       (2, 5, '2019-08-02 10:00:00.000'),
       (2, 5, '2019-08-02 10:45:00.000'),
       (2, 4, '2019-08-02 11:00:00.000');

with cte as (select *,
cast(Datecalled as date) as dated
from phonelog),
cte2 as (select *,
case when first_value(Recipientid) over(partition by Callerid,dated order by Datecalled) =
first_value(Recipientid) over(partition by Callerid,dated order by Datecalled desc) then 0 else 1 end as flg
from cte)
select  Callerid,dated from cte2
group by Callerid,dated
having max(flg)=0;
--------------------------------------------------------------------------------------------------------------------------------------
create table candidates (
emp_id int,
experience varchar(20),
salary int
);
delete from candidates;
insert into candidates values
(1,'Junior',10000),(2,'Junior',15000),(3,'Junior',40000),(4,'Senior',16000),(5,'Senior',20000),(6,'Senior',50000);
select * from candidates;


with cte as(
select *, sum(salary) over(partition by experience order by experience desc,salary asc)
as running_sal from candidates
),
senior_hired as
(select * from cte where experience='Senior' and running_sal<=70000)
,juinior_hired as(
select * from cte where experience='Junior' and 
running_sal<=(70000-(select sum(running_sal) from senior_hired))
)
select * from senior_hired union all
select * from juinior_hired order by emp_id;
-----------------------------------------------------------------------------------------------------------------------------------------
drop table emp;
create table emp(
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
emp_age int);

insert into emp
values
(1, 'Ankit', 100,10000, 4, 39);
insert into emp
values (2, 'Mohit', 100, 15000, 5, 48);
insert into emp
values (3, 'Vikas', 100, 12000,4,37);
insert into emp
values (4, 'Rohit', 100, 14000, 2, 16);
insert into emp
values (5, 'Mudit', 200, 20000, 6,55);
insert into emp
values (6, 'Agam', 200, 12000,2, 14);
insert into emp
values (7, 'Sanjay', 200, 9000, 2,13);
insert into emp
values (8, 'Ashish', 200,5000,2,12);
insert into emp
values (9, 'Mukesh',300,6000,6,51);
insert into emp
values (10, 'Rakesh',500,7000,6,50);

with manager_info as (
select e.emp_id,e.emp_name,e.manager_id, m.emp_name as manager_name,m.manager_id as s_manager_id from emp e left join emp m on e.manager_id=m.emp_id)
select m.*,sm.emp_name from manager_info m join manager_info sm on m.s_manager_id=sm.emp_id order by emp_id;

-------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE sensor_logs (
    sensor_id INT,
    log_date DATE,
    status VARCHAR(50)
);

INSERT INTO sensor_logs (sensor_id, log_date, status) VALUES
(101, '2025-08-01', 'start'),
(101, '2025-08-02', 'start'),
(101, '2025-08-03', 'start'),
(101, '2025-08-04', 'fail'),
(101, '2025-08-05', 'fail'),
(101, '2025-08-06', 'start'),
(101, '2025-08-07', 'start'),
(102, '2025-08-01', 'start'),
(102, '2025-08-03', 'fail'),
(103, '2025-08-01', NULL),
(103, '2025-08-04', 'start');

with cte as (select *,row_number() over(partition by sensor_id,status order by log_date)rnk from sensor_logs)
,cte2 as(select *,dateadd('day',-1*rnk,log_date) flag  from cte)
select sensor_id,status,min(log_date),max(log_date) from cte2 group by sensor_id,status,flag order by sensor_id;
-------------------------------------------------------------------------------------------------------------------------------------------
drop table if exists transactions;
CREATE TABLE transactions (
    transaction_id INT,
    type VARCHAR(20), -- 'deposit' or 'withdrawal'
    amount DECIMAL(10,2),
    transaction_date TIMESTAMP
);

INSERT INTO transactions (transaction_id, type, amount, transaction_date) VALUES
(771342, 'deposit', 32.60, '2022-08-10 10:00:00'),
(771664, 'deposit', 320.60, '2022-08-10 09:00:00'),
(771224, 'withdrawal', 32.60, '2022-08-12 10:00:00'),
(191223, 'deposit', 65.90, '2022-07-13 10:00:00'),
(53151, 'deposit', 178.55, '2022-07-08 10:00:00'),
(29776, 'withdrawal', 25.90, '2022-07-08 10:00:00'),
(16461, 'withdrawal', 45.99, '2022-07-08 10:00:00'),
(77134, 'deposit', 32.60, '2022-07-10 10:00:00');

with cte as (select cast(transaction_date as date) as transaction_date,sum(case when type='withdrawal' then -1*amount else amount end) as amount from transactions group by cast(transaction_date as date))
select *,sum(amount) over(partition by extract(month from transaction_date) ,extract(year from transaction_date) order by transaction_date rows between unbounded preceding and current row) from cte 
;

-----------------------------------------------------------------------------------------------------------------------------------------
create table hotel(
rental_id int ,
amenities nvarchar(20)
);
---------
insert into hotel values (123, 'Pool'),
(123, 'Kitchen'),
(234, 'Hot Tub'),
(234, 'Fireplace'),
(345, 'Kitchen'),
(345, 'Pool'),
(456, 'Pool');

with cte as(select rental_id,listagg(amenities,',') WITHIN GROUP (order by amenities asc ) as aminities from hotel group by rental_id)
select count (c1.rental_id) as matching_airbnb from cte c1
inner join cte c2
on c1.aminities=c2.aminities and c1.rental_id >c2.rental_id;

----------------------------------------------------------------------------------------------------------------------------------------
create table drivers(id varchar(10), start_time time, end_time time, start_loc varchar(10), end_loc varchar(10));
insert into drivers values('dri_1', '09:00', '09:30', 'a','b'),('dri_1', '09:30', '10:30', 'b','c'),('dri_1','11:00','11:30', 'd','e');
insert into drivers values('dri_1', '12:00', '12:30', 'f','g'),('dri_1', '13:30', '14:30', 'c','h');
insert into drivers values('dri_2', '12:15', '12:30', 'f','g'),('dri_2', '13:30', '14:30', 'c','h');

select * from drivers;
select id, count(1) as total_rides,sum(case when end_loc=next_start_loc then  1 else 0 end) as profit_rides
from
(
select * , lead(start_loc,1) over( partition by  id order by start_time) as next_start_loc
from drivers) a
group by id;

with cte as (select *,rank() over(partition by id order by start_time) rnk from drivers)
select a.id,count(*) as tota_ride,count(b.id) as profit_ride from cte a left join cte as b on a.id=b.id and a.end_loc=b.start_loc and a.rnk=b.rnk-1 group by a.id


----------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE purchase_history (
    userid INT,
    productid INT,
    purchasedate DATE
);

INSERT INTO purchase_history VALUES
(1, 1, '2012-01-23'),
(1, 2, '2012-01-23'),
(1, 3, '2012-01-25'),
(2, 1, '2012-01-23'),
(2, 2, '2012-01-23'),
(2, 2, '2012-01-25'),
(2, 4, '2012-01-25'),
(3, 4, '2012-01-23'),
(3, 1, '2012-01-23'),
(4, 1, '2012-01-23'),
(4, 2, '2012-01-25');

select * from purchase_history;


WITH all_data AS(
SELECT *,DENSE_RANK()OVER(PARTITION BY userid,productid ORDER BY purchasedate ASC) AS rn
FROM purchase_history)
SELECT userid
FROM all_data
GROUP BY userid
HAVING max(rn)=1 AND count(distinct purchasedate)>1;

with cte as (select userid,count(distinct purchasedate) as distinct_date, count(productid) as total_product, count(distinct productid) distinct_product from purchase_history group by userid)
select * from cte where total_product=distinct_product and distinct_date>1;

--------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE marketing_campaign (
    user_id INT NULL,
    created_at DATE NULL,
    product_id INT NULL
    ,
    quantity INT NULL,
    price INT NULL
);

INSERT INTO marketing_campaign VALUES 
(10, '2019-01-01', 101, 3, 55),
(10, '2019-01-02', 119, 5, 29),
(10, '2019-03-31', 111, 2, 149),
(11, '2019-01-02', 105, 3, 234),
(11, '2019-03-31', 120, 3, 99),
(12, '2019-01-02', 112, 2, 200),
(12, '2019-03-31', 110, 2, 299),
(13, '2019-01-05', 113, 1, 67),
(13, '2019-03-31', 118, 3, 35),
(14, '2019-01-06', 109, 5, 199),
(14, '2019-01-06', 107, 2, 27),
(14, '2019-03-31', 112, 3, 200),
(15, '2019-01-08', 105, 4, 234),
(15, '2019-01-09', 110, 4, 299),
(15, '2019-03-31', 116, 2, 499),
(16, '2019-01-10', 113, 2, 67),
(16, '2019-03-31', 107, 4, 27),
(17, '2019-01-11', 116, 2, 499),
(17, '2019-03-31', 104, 1, 154),
(18, '2019-01-12', 114, 2, 248),
(18, '2019-01-12', 113, 4, 67),
(19, '2019-01-12', 114, 3, 248),
(20, '2019-01-15', 117, 2, 999),
(21, '2019-01-16', 105, 3, 234),
(21, '2019-01-17', 114, 4, 248),
(22, '2019-01-18', 113, 3, 67),
(22, '2019-01-19', 118, 4, 35),
(23, '2019-01-20', 119, 3, 29),
(24, '2019-01-21', 114, 2, 248),
(25, '2019-01-22', 114, 2, 248),
(25, '2019-01-22', 115, 2, 72),
(25, '2019-01-24', 114, 5, 248),
(25, '2019-01-27', 115, 1, 72),
(26, '2019-01-25', 115, 1, 72),
(27, '2019-01-26', 104, 3, 154),
(28, '2019-01-27', 101, 4, 55),
(29, '2019-01-27', 111, 3, 149),
(30, '2019-01-29', 111, 1, 149),
(31, '2019-01-30', 104, 3, 154),
(32, '2019-01-31', 117, 1, 999),
(33, '2019-01-31', 117, 2, 999),
(34, '2019-01-31', 110, 3, 299),
(35, '2019-02-03', 117, 2, 999),
(36, '2019-02-04', 102, 4, 82),
(37, '2019-02-05', 102, 2, 82),
(38, '2019-02-06', 113, 2, 67),
(39, '2019-02-07', 120, 5, 99),
(40, '2019-02-08', 115, 2, 72),
(41, '2019-02-08', 114, 1, 248),
(42, '2019-02-10', 105, 5, 234),
(43, '2019-02-11', 102, 1, 82),
(43, '2019-03-05', 104, 3, 154),
(44, '2019-02-12', 105, 3, 234),
(44, '2019-03-05', 102, 4, 82),
(45, '2019-02-13', 119, 5, 29),
(45, '2019-03-05', 105, 3, 234),
(46, '2019-02-14', 102, 4, 82),
(46, '2019-02-14', 102, 5, 29),
(46, '2019-03-09', 102, 2, 35),
(46, '2019-03-10', 103, 1, 199),
(46, '2019-03-11', 103, 1, 199),
(47, '2019-02-14', 110, 2, 299),
(47, '2019-03-11', 105, 5, 234),
(48, '2019-02-14', 115, 4, 72),
(48, '2019-03-12', 105, 3, 234),
(49, '2019-02-18', 106, 2, 123),
(49, '2019-02-18', 114, 1, 248),
(49, '2019-02-18', 112, 4, 200),
(49, '2019-02-18', 116, 1, 499),
(50, '2019-02-20', 118, 4, 35),
(50, '2019-02-21', 118, 4, 29),
(50, '2019-03-13', 118, 5, 299),
(50, '2019-03-14', 118, 2, 199),
(51, '2019-02-21', 120, 2, 99),
(51, '2019-03-13', 108, 4, 120),
(52, '2019-02-23', 117, 2, 999),
(52, '2019-03-18', 112, 5, 200),
(53, '2019-02-24', 120, 4, 99),
(53, '2019-03-19', 105, 5, 234),
(54, '2019-02-25', 119, 4, 29),
(54, '2019-03-20', 110, 1, 299),
(55, '2019-02-26', 117, 2, 999),
(55, '2019-03-20', 117, 5, 999),
(56, '2019-02-27', 115, 2, 72),
(56, '2019-03-20', 116, 2, 499),
(57, '2019-02-28', 105, 4, 234),
(57, '2019-02-28', 106, 1, 123),
(57, '2019-03-20', 108, 1, 120),
(57, '2019-03-20', 103, 1, 79),
(58, '2019-02-28', 104, 1, 154),
(58, '2019-03-01', 101, 3, 55),
(58, '2019-03-02', 119, 2, 29),
(58, '2019-03-25', 102, 2, 82),
(59, '2019-03-04', 117, 4, 999),
(60, '2019-03-05', 114, 3, 248),
(61, '2019-03-26', 120, 2, 99),
(62, '2019-03-27', 106, 1, 123),
(63, '2019-03-27', 120, 5, 99),
(64, '2019-03-27', 105, 3, 234),
(65, '2019-03-27', 103, 4, 79),
(66, '2019-03-31', 107, 2, 27),
(67, '2019-03-31', 102, 5, 82);

select distinct user_id from
(select * from marketing_campaign where user_id in
 (select user_id from marketing_campaign 
group by user_id
having count(distinct created_at) > 1 and count(user_id) = count(distinct product_id)))p
--------------------------------------------------------------------------------------------------------------------------

Create Table Trade_tbl(
TRADE_ID varchar(20),
Trade_Timestamp time,
Trade_Stock varchar(20),
Quantity int,
Price Float
);

Insert into Trade_tbl Values('TRADE1','10:01:05','ITJunction4All',100,20);
Insert into Trade_tbl Values('TRADE2','10:01:06','ITJunction4All',20,15);
Insert into Trade_tbl Values('TRADE3','10:01:08','ITJunction4All',150,30);
Insert into Trade_tbl Values('TRADE4','10:01:09','ITJunction4All',300,32);
Insert into Trade_tbl Values('TRADE5','10:10:00','ITJunction4All',-100,19);
Insert into Trade_tbl Values('TRADE6','10:10:01','ITJunction4All',-300,19);


select A.Trade_Stock as Trade_name,A.TRADE_ID,B.TRADE_ID as B_TRADE_ID,
(datediff('second', a.Trade_Timestamp, b.Trade_Timestamp)) as time_dif,
round((abs(a.price - b.price)/a.price)*100 ,2) as percent_dif
from 
Trade_tbl  A inner join Trade_tbl B
on a.trade_stock=b.trade_stock
where  A.Trade_Timestamp < B.Trade_Timestamp 
and (datediff('second', a.Trade_Timestamp, b.Trade_Timestamp))<=10
and (abs(a.price - b.price)*1.0/a.price)*100 >=10
order by 1,

----------------------------------------------------------------------------------------------------------------------------------------------
create table section_data
(
section varchar(5),
number integer
);
insert into section_data
values ('A',5),('A',7),('A',10) ,('B',7),('B',9),('B',10) ,('C',9),('C',7),('C',9) ,('D',10),('D',3),('D',8);

with cte as( select *,
row_number() over(partition by section order by number desc) as rn
from section_data),cte1 as(
select *,
sum(number) over(partition by section) as s_sum,
max(number) over(partition by section) as n_max
from cte A
where rn<=2)
select section,number from (Select *,dense_rank() over(order by s_sum desc,n_max desc)as highest from cte1 ) where highest<=2;