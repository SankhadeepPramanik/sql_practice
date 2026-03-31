-- create database sql_practice comment="its use for sql practice ";
-- show databases;
-- create schema sql_world comment="use for sql practice schema"; 
-- show schemas;
-- use sql_practice.sql_world;

prob-1

create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

select * from icc_world_cup;
-- solution:
with win_loss as (
select team_1 as team,case when team_1=winner then 1 else 0 end as win_flag from icc_world_cup
union all
select team_2 as team, case when team_2=winner then 1 else 0 end as win_flag from icc_world_cup
)
select team, count(*) as total_match, sum(win_flag) as win , count(*)-sum(win_flag) as loss from win_loss group by team order by sum(win_flag) desc;

__________________________________________________________________________________________________
prob-2

create table customer_orders (
order_id integer,
customer_id integer,   
order_date date,
order_amount integer
);
insert into customer_orders values(1,100,cast('2022-01-01' as date),2000),(2,200,cast('2022-01-01' as date),2500),(3,300,cast('2022-01-01' as date),2100)
,(4,100,cast('2022-01-02' as date),2000),(5,400,cast('2022-01-02' as date),2200),(6,500,cast('2022-01-02' as date),2700)
,(7,100,cast('2022-01-03' as date),3000),(8,400,cast('2022-01-03' as date),1000),(9,600,cast('2022-01-03' as date),3000)
;
select * from customer_orders;

with min_date as (
select *, min(order_date) over(partition by customer_id order by order_date) as min_date from 
customer_orders)
,flag as (
select *,case when min_date=order_date then 1 else 0 end as new_flag ,case when min_date!=order_date then 1 else 0 end as old_flag from min_date
)
select order_date,sum(new_flag) as new_customer,sum(old_flag) as old_customer from flag group by order_date order by order_date

-------------------------------------------------------------------------------------------------

create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries 
values ('A','Bangalore','A@gmail.com',1,'CPU'),('A','Bangalore','A1@gmail.com',1,'CPU'),('A','Bangalore','A2@gmail.com',2,'DESKTOP')
,('B','Bangalore','B@gmail.com',2,'DESKTOP'),('B','Bangalore','B1@gmail.com',2,'DESKTOP'),('B','Bangalore','B2@gmail.com',1,'MONITOR');

select * from entries;
with total_info as (select name,count(1) total_visit,listagg(distinct resources,', ') as resources
from entries group by name),
floor_count as (select name,floor ,count(*) as count_floor from entries group by name,floor),
most_visited as (select name,floor as most_visied from floor_count qualify dense_rank() over(partition by name order by count_floor desc)=1)
select a.name,resources,total_visit,most_visied from total_info a join most_visited b on a.name=b.name 
------------------------------------------------------------------------
CREATE OR REPLACE TABLE product_sales (
    product_id INT,
    product_name STRING,
    sales_amount DECIMAL(10, 2)
);

INSERT INTO product_sales VALUES
(101, 'Product C', 520.00),
(102, 'Product D', 600.00),
(103, 'Product A', 900.00),
(104, 'Product B', 300.00),
(105, 'Product q', 550.00),
(106, 'Product F', 200.00),
(107, 'Product G', 150.00),
(108, 'Product H', 100.00),
(109, 'Product I', 80.50),
(110, 'Product J', 70.00);

with product_sale_info as 
(select product_id,sum(sales_amount) as sales_amount from product_sales group by product_id)
,running_sales as ( select product_id, sales_amount,0.8*sum(sales_amount) over() as "80%_sales",sum(sales_amount) over(order by (sales_amount) desc rows between unbounded preceding and current row) as running_sale from product_sale_info)
select * from running_sales where running_sale<="80%_sales";
-----------------------------------------------------------------------------------------------

Create table friend (pid int, fid int);
insert into friend (pid , fid ) values ('1','2');
insert into friend (pid , fid ) values ('1','3');
insert into friend (pid , fid ) values ('2','1');
insert into friend (pid , fid ) values ('2','3');
insert into friend (pid , fid ) values ('3','5');
insert into friend (pid , fid ) values ('4','2');
insert into friend (pid , fid ) values ('4','3');
insert into friend (pid , fid ) values ('4','5');

create table person (PersonID int,	Name varchar(50),	Score int);
insert into person(PersonID,Name ,Score) values('1','Alice','88');
insert into person(PersonID,Name ,Score) values('2','Bob','11');
insert into person(PersonID,Name ,Score) values('3','Devis','27');
insert into person(PersonID,Name ,Score) values('4','Tara','45');
insert into person(PersonID,Name ,Score) values('5','John','63');
select * from person;
select * from friend;

with cte as(select a.pid,a.fid,b.score from friend a join person b on a.fid=b.personid)
,person_info as (select pid,count(*) as total_friend,sum(score) total_score from cte group by pid having (sum(score)>100))
select a.pid,b.name,total_friend,total_score from person_info a join person b on a.pid=b.personid

-------------------------------------------------------------------------------------------------------

Create table  Trips (id int, client_id int, driver_id int, city_id int, status varchar(50), request_at varchar(50));
Create table Users (users_id int, banned varchar(50), role varchar(50));
Truncate table Trips;
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('1', '1', '10', '1', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('3', '3', '12', '6', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('5', '1', '10', '1', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('6', '2', '11', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('7', '3', '12', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('8', '2', '12', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('9', '3', '10', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03');
Truncate table Users;
insert into Users (users_id, banned, role) values ('1', 'No', 'client');
insert into Users (users_id, banned, role) values ('2', 'Yes', 'client');
insert into Users (users_id, banned, role) values ('3', 'No', 'client');
insert into Users (users_id, banned, role) values ('4', 'No', 'client');
insert into Users (users_id, banned, role) values ('10', 'No', 'driver');
insert into Users (users_id, banned, role) values ('11', 'No', 'driver');
insert into Users (users_id, banned, role) values ('12', 'No', 'driver');
insert into Users (users_id, banned, role) values ('13', 'No', 'driver');

select * from users;
select * from trips;
with active_user as(
select * from Users where banned='No'
),day_wise_cancel as (
select REQUEST_AT,sum(case when status='cancelled_by_driver' or status='cancelled_by_client' then 1 else 0 end ) as cancel_status,count(1) as total_status  from trips a join active_user b on a.client_id=b.users_id 
join active_user c on a.driver_id=c.users_id group by request_at)
select request_at,round((cancel_status*1.0/total_status)*100,2)  as cancel_percent from day_wise_cancel;
;
--------------------------------------------------------------------------------------------------------

create table players
(player_id int,
group_id int);

insert into players values (15,1);
insert into players values (25,1);
insert into players values (30,1);
insert into players values (45,1);
insert into players values (10,2);
insert into players values (35,2);
insert into players values (50,2);
insert into players values (20,3);
insert into players values (40,3);

create table matches
(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int);

insert into matches values (1,15,45,3,0);
insert into matches values (2,30,25,1,2);
insert into matches values (3,30,15,2,0);
insert into matches values (4,40,20,5,2);
insert into matches values (5,35,50,1,1);

select * from matches;
select * from players;

with cte as(
select first_player as player, first_score as score from matches
union all
select second_player as player , second_score as score from matches)
,score_sum as(
select player,sum(score) as score from cte group by player ),rank_of_player as (
select player_id,group_id,score,dense_rank() over(partition by group_id order by score desc, player_id) as rnk from players a join score_sum b on a.player_id=b.player)

select player_id,group_id,score from rank_of_player where rnk=1
-----------------------------------------------------------------------------------------------------


drop table  if exists users;
create table users (
user_id         int     ,
 join_date       date    ,
 favorite_brand  varchar(50));

 drop table  if exists orders;
 create table orders (
 order_id       int     ,
 order_date     date    ,
 item_id        int     ,
 buyer_id       int     ,
 seller_id      int 
 );
 
drop table  if exists items;
 create table items
 (
 item_id        int     ,
 item_brand     varchar(50)
 );


 insert into users values (1,'2019-01-01','Lenovo'),(2,'2019-02-09','Samsung'),(3,'2019-01-19','LG'),(4,'2019-05-21','HP');

 insert into items values (1,'Samsung'),(2,'Lenovo'),(3,'LG'),(4,'HP');

 insert into orders values (1,'2019-08-01',4,1,2),(2,'2019-08-02',2,1,3),(3,'2019-08-03',3,2,3),(4,'2019-08-04',1,4,2)
 ,(5,'2019-08-04',1,3,4),(6,'2019-08-05',2,2,4);

 with rnk_sell_item as (select seller_id,item_id,order_date,dense_rank() over(partition by seller_id order  by order_date asc) as rnk from orders ),secord_sell_item as ( select * exclude rnk  from rnk_sell_item  where rnk=2)
select  user_id,c.item_brand as selleing_brand,a.favorite_brand,(case when c.item_brand=a.favorite_brand then 'yes' else 'no' end) as is_favourite from users a left join secord_sell_item b on a.user_id=b.seller_id
left join items c on b.item_id=c.item_id



----------------------------------------------------------------------------------------------------

create table tasks (
date_value date,
state varchar(10)
);

insert into tasks  values ('2019-01-01','success'),('2019-01-02','success'),('2019-01-03','success'),('2019-01-04','fail')
,('2019-01-05','fail'),('2019-01-06','success');

with cte as (select *,row_number() over( order by date_value) rnk1,row_number() over(partition by state order by date_value) rnk2 from tasks),group_id as (
select date_value,state,rnk1-rnk2 as group_id from cte)
select state,min(date_value) as min_date, max(date_value) as max_date  from group_id group by state , group_id;
with ct1 as 
(Select *,
dateadd(day,-1*row_number() over(partition by state order by date_value), date_value) as group_date 
From tasks order by date_value)

Select min(date_value) as start_date, max(date_value) as end_date, state
from ct1
group by group_date, state
order by start_date
-----------------------------------------------------------------------------------------------------


create table spending 
(
user_id int,
spend_date date,
platform varchar(10),
amount int
);

insert into spending values(1,'2019-07-01','mobile',100),(1,'2019-07-01','desktop',100),(2,'2019-07-01','mobile',100)
,(2,'2019-07-02','mobile',100),(3,'2019-07-01','desktop',100),(3,'2019-07-02','desktop',100);

with union_cte as (select user_id,spend_date,max(platform) platform ,sum(amount) amount from spending group by user_id,spend_date having(count(distinct platform))=1
union all
select user_id,spend_date,'both' as platform,sum(amount) amount from spending group by user_id,spend_date having(count(distinct platform))=2
union all
select NULL as user_id,spend_date,'both' as platform,0 as amount from spending )
select spend_date,max(platform) as platform,sum(amount),count(distinct user_id) as user_id from union_cte group by spend_date,platform ;



with cte as(
 select case when listagg(platform,',')='mobile,desktop' then 'both' else listagg(platform,',') end
 as pf,spend_date,user_id,sum(amount) Total
 from spending group by spend_date,user_id 
 ),
 cte2 as (
 select * from cte 
 union all
 select distinct 'both' as pf,spend_date,null as user_id, 0 as total
 from spending )

 select pf,spend_date, sum(total)totalamount,count(distinct user_id)totalusers from cte2 
 group by spend_date,pf 
 order by 1 desc


 -------------------------------------------------------------------------------------------------------
 drop table if exists orders;
 create table orders
(
order_id int,
customer_id int,
product_id int
);

insert into orders VALUES 
(1, 1, 1),
(1, 1, 2),
(1, 1, 3),
(2, 2, 1),
(2, 2, 2),
(2, 2, 4),
(3, 1, 5);

create table products (
id int,
name varchar(10)
);
insert into products VALUES 
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E');

with product_info as(select a.order_id,a.product_id,b.name from orders a join products b on  a.product_id=b.id), combination as (
select a.order_id,a.name as name1,b.name as name2 from product_info a join product_info b on a.order_id=b.order_id where a.product_id>b.product_id )
select concat(name2,',',name1) as pair,count(*) as count from combination group by name1,name2;

-----------------------------------------------------------------------------------------------------
drop table if exists users;
create table users
(
user_id integer,
name varchar(20),
join_date date
);
insert into users
values (1, 'Jon', CAST('02/04/2025' AS date)), 
(2, 'Jane', CAST('02/14/2025' AS date)), 
(3, 'Jill', CAST('02/15/2025' AS date)), 
(4, 'Josh', CAST('02/15/2025' AS date)), 
(5, 'Jean', CAST('02/16/2025' AS date)), 
(6, 'Justin', CAST('02/17/2025' AS date)),
(7, 'Jeremy', CAST('02/18/2025' AS date));

create table events
(
user_id integer,
type varchar(10),
access_date date
);

insert into events values
(1, 'Pay', CAST('03/1/2025' AS date)), 
(2, 'Music', CAST('03/02/2025' AS date)), 
(2, 'P', CAST('03/12/2025' AS date)),
(3, 'Music', CAST('03/15/2025' AS date)), 
(4, 'Music', CAST('03/15/2025' AS date)), 
(1, 'P', CAST('03/16/2025' AS date)), 
(3, 'P', CAST('03/22/2025' AS date));


With CTE as
(Select 
        count(case 
	           when (e.type = 'P' and datediff(day, u.join_date, e.access_date)<=30) then 1 
			   else null 
			end) as  prime_users
     ,  count(case when e.type = 'Music' then 1 else null end) as total_users
from users u join events e
on u.user_id = e.user_id)

Select *, (1.0*prime_users/total_users)*100 from CTE;

with cte1 as (
select
u.user_id, u.join_date, count(1) over() as total_musicusers
from users u
where user_id in (select user_id from events where type = 'Music')
),
cte2 as (
select 
cte1.total_musicusers,
count(distinct case when DATEDIFF(day, join_date, e.access_date)<=30 then cte1.user_id  end ) 
 as total_mp_users from cte1
left join events e on e.user_id = cte1.user_id and e.type = 'P' group by cte1.total_musicusers
) 
select total_musicusers as total_users,total_mp_users, (total_mp_users*1.0/total_musicusers)*100 as fraction 
from cte2 
--------------------------------------------------------------------------------------------------

create table transactions(
order_id int,
cust_id int,
order_date date,
amount int
);
delete from transactions;
insert into transactions values 
(1,1,'2020-01-15',150)
,(2,1,'2020-02-10',250)
,(3,2,'2020-01-16',950)
,(11,2,'2020-02-16',980)
,(4,2,'2020-02-25',850)
,(5,3,'2020-01-10',550)
,(6,3,'2020-02-20',150)
,(7,4,'2020-01-20',1750)
,(8,5,'2020-02-20',850);

select * from transactions;
--customer retention
with a as (select *,
extract(month from order_date) as month_name,
lag(order_date,1,order_date) over(partition by cust_id order by order_date) as previous_month
from transactions )

select a.month_name,
 sum(case when datediff(month,a.previous_month,a.order_date) =1 then 1 else 0 end) as no_of_retention_customers
 from a
 group by a.month_name;

 --or 
 select month , count (distinct diff) from (
  select cust_id , month(order_date) month , lag(month) over (partition by cust_id order by month ) prev_month , case when month - prev_month  = 1 then cust_id  end diff from transactions 
    ) 
    group by month;
    
----cutomer churn

with a as (select *,
extract(month from order_date) as month_name,
lead(order_date) over(partition by cust_id order by order_date) as next_month
from transactions)

select a.month_name ,
sum(case when datediff(month,a.order_date,a.next_month)=1 then 0 else 1 end) as no_of_churn_customers
from a
group by a.month_name;

---------------------------------------------------------------------------------------------------

create table UserActivity
(
username      varchar(20) ,
activity      varchar(20),
startDate     Date   ,
endDate      Date
);

insert into UserActivity values 
('Alice','Travel','2020-02-12','2020-02-20')
,('Alice','Dancing','2020-02-21','2020-02-23')
,('Alice','Travel','2020-02-24','2020-02-28')
,('Bob','Travel','2020-02-11','2020-02-18');


with cte as (
select *,row_number() over(partition by username order by startdate desc) rnk,
count(*) over(partition by username) cnt
from useractivity )
SELECT * EXCLUDE (rnk, cnt)
FROM cte
WHERE rnk = 2 OR cnt = 1;


-----------------------------------------------------------------------------------------------------

create table billings 
(
emp_name varchar(10),
bill_date date,
bill_rate int
);
delete from billings;
insert into billings values
('Sachin','01-JAN-1990',25)
,('Sehwag' ,'01-JAN-1992', 15)
,('Sehwag' ,'01-JAN-1990', 16)
,('Sehwag' ,'01-JAN-1991', 17)
,('Dhoni' ,'01-JAN-1989', 20)
,('Sachin' ,'05-Feb-1991', 30)
;

create table HoursWorked 
(
emp_name varchar(20),
work_date date,
bill_hrs int
);
delete from HoursWorked;
insert into HoursWorked values
('Sachin', '01-JUL-1990' ,3)
,('Sachin', '01-AUG-1990', 5)
,('Sehwag','01-JUL-1990', 2)
,('Sehwag','01-JUL-1991', 5)
,('Sehwag','01-SEP-1992', 4)
,('Sachin','01-JUL-1991', 4);
select * from billings;

with cte as (
select *,dateadd(day,-1,lead(bill_date,1,'9999-12-12') over(partition by emp_name order by bill_date)) as next_date from billings
)
select c.emp_name,sum(c.bill_rate * h.bill_hrs) as total_billing  from  cte c
inner join HoursWorked h on c.emp_name=h.emp_name and h.work_date between c.bill_date and c.next_date 
group by c.emp_name

------------------------------------------------------------------------------------------------------

CREATE table activity
(
user_id varchar(20),
event_name varchar(20),
event_date date,
country varchar(20)
);
delete from activity;
insert into activity values (1,'app-installed','2022-01-01','India')
,(1,'app-purchase','2022-01-02','India')
,(2,'app-installed','2022-01-01','USA')
,(3,'app-installed','2022-01-01','USA')
,(3,'app-purchase','2022-01-03','USA')
,(4,'app-installed','2022-01-03','India')
,(4,'app-purchase','2022-01-03','India')
,(5,'app-installed','2022-01-03','SL')
,(5,'app-purchase','2022-01-03','SL')
,(6,'app-installed','2022-01-04','Pakistan')
,(6,'app-purchase','2022-01-04','Pakistan');


select * from activity;
--Daily active users
select count(distinct user_id), event_date from activity group by event_date;
--Weekly active users
select count(distinct user_id),extract(week from event_date)from activity group by extract(week from event_date);
--same day install and purchase
select event_date, count(distinct user_id) as count from (
select user_id, count(distinct event_name) cnt,event_date from activity group by user_id,event_date having count(distinct event_name)=2)
 group by event_date ;

select event_date, count(case when cnt=2 then user_id else  NULL end) as count from (
select user_id, count(distinct event_name) cnt,event_date from activity group by user_id,event_date )
 group by event_date ;
--country wise paid users
with cte1 as (select distinct case when country in ('India','USA') then  country else 'others' end as country, user_id from activity where event_name='app-purchase' ),cte as(select country,count(user_id) as count from cte1 group by country),total_user as (select count(*) as total from cte1)
select (count*1.0/total)*100 as percent_user from cte,total_user;

with prev_data as
(select *,
lag(event_date,1) over(partition by user_id order by event_date) as prev_event_date,
lag(event_name,1) over(partition by user_id order by event_date) as prev_event_name 
from activity)
select event_date,
count(case when event_name='app-purchase' and prev_event_name='app-installed' and datediff(day,prev_event_date,event_date)=1 then user_id else null end) as user_cnt
from prev_data
group by event_date;

 --------------------------------------------------------------------------------------------------
create table bms (seat_no int ,is_empty varchar(10));
insert into bms values
(1,'N')
,(2,'Y')
,(3,'N')
,(4,'Y')
,(5,'Y')
,(6,'Y')
,(7,'N')
,(8,'Y')
,(9,'Y')
,(10,'Y')
,(11,'Y')
,(12,'N')
,(13,'Y')
,(14,'Y');

-- ===== Method 2 ==========

with method2 as (
Select * ,
sum( case when is_empty='Y' then 1 else 0 end) over ( order by seat_no rows between 2 preceding and current row) as prev_row2,
sum( case when is_empty='Y' then 1 else 0 end) over ( order by seat_no rows between current row and 2 following ) as next_row2,
sum( case when is_empty='Y' then 1 else 0 end) over ( order by seat_no rows between 1 preceding and 1 following ) as current_row
from bms)

Select seat_no from method2 where 3 in ( prev_row2,current_row,next_row2);
---method3
with seat_group as (select * , row_number() over(order by seat_no)as rnk, seat_no-row_number() over(order by seat_no) as grouping from bms where is_empty='Y'),grouping_count as (
select grouping,count(*) as cnt from seat_group group by grouping having count(*)>=3)
select  * exclude(is_empty,rnk,grouping) from seat_group where grouping in (select grouping from grouping_count);
---method 4
with seat_group as (select * , row_number() over(order by seat_no)as rnk, seat_no-row_number() over(order by seat_no) as grouping from bms where is_empty='Y'),count_group as (
select *, count(grouping) over(partition by grouping) as cnt from seat_group)
select seat_no from count_group where cnt>=3;

------------------------------------------------------------------------------------------------------
CREATE TABLE STORES (
Store varchar(10),
Quarter varchar(10),
Amount int);
delete from STORES;
INSERT INTO STORES (Store, Quarter, Amount)
VALUES ('S1', 'Q1', 200),
--('S1', 'Q2', 300),
('S1', 'Q4', 400),
('S2', 'Q1', 500),
('S2', 'Q3', 600),
('S2', 'Q4', 700),
('S3', 'Q1', 800),
('S3', 'Q2', 750),
('S3', 'Q3', 900);
select store,concat('Q',(10-sum(cast(right(quarter,1) as int)))) from stores group by store;
with cte as 
(
select  distinct s1.Store,s2.quarter from stores s1,stores s2 order by s2.quarter
) 
select q.*from cte q left join Stores s on q.Store = s.Store and q.quarter = s.quarter where S.quarter is null


---------------------------------------------------------------------------------------
create table exams (student_id int, subject varchar(20), marks int);
delete from exams;
insert into exams values (1,'Chemistry',91),(1,'Physics',91)
,(2,'Chemistry',80),(2,'Physics',90)
,(3,'Chemistry',80)
,(4,'Chemistry',71),(4,'Physics',54);

--same mark in chemistry physics
SELECT student_id
FROM exams
WHERE SUBJECT IN ('Physics' , 'Chemistry')
GROUP BY student_id
HAVING count(distinct subject)=2 and count(distinct marks)=1;

with cte as(
select student_id, sum(case when subject ='Chemistry' then marks end)c,sum(case when subject='Physics' then marks end)p from exams group by student_id)

select student_id,p,c from cte where c=p;

-----------------------------------------------------------------------------------------
create table covid(city varchar(50),days date,cases int);
delete from covid;
insert into covid values('DELHI','2022-01-01',100);
insert into covid values('DELHI','2022-01-02',200);
insert into covid values('DELHI','2022-01-03',300);

insert into covid values('MUMBAI','2022-01-01',100);
insert into covid values('MUMBAI','2022-01-02',100);
insert into covid values('MUMBAI','2022-01-03',300);

insert into covid values('CHENNAI','2022-01-01',100);
insert into covid values('CHENNAI','2022-01-02',200);
insert into covid values('CHENNAI','2022-01-03',150);

insert into covid values('BANGALORE','2022-01-01',100);
insert into covid values('BANGALORE','2022-01-02',300);
insert into covid values('BANGALORE','2022-01-03',200);
insert into covid values('BANGALORE','2022-01-04',400);



With cte as
(
Select *,lag(cases,1,0) over(partition by city order by days asc) as previous_cases from covid
),diff as (
Select *, case when cases>previous_cases then 0 else 1 end as cnt from cte
)
Select city as cnt from diff
group by city
having sum(cnt)=0;

with cte as(select *
,lag(cases,1,0) over(partition by city order by days) as prev_cases
,cases-lag(cases,1,0) over(partition by city order by days) as cases_diff
from covid)
select city
from cte
group by city
having count(case when cases_diff<=0 then cases_diff end)=0;

with cte as
(
select *,dense_rank() over(partition by city order by days)  as date_rnk,dense_rank() over(partition by city order by cases) case_rnk,
(dense_rank() over(partition by city order by days) -dense_rank() over(partition by city order by cases)) diff
 from covid
 )
 
 select  city from cte group by city having (count(distinct city)=1 and max(diff)=0);
 -----------------------------------------------------------------------------------------------------

 create table company_users 
(
company_id int,
user_id int,
language varchar(20)
);

insert into company_users values (1,1,'English')
,(1,1,'German')
,(1,2,'English')
,(1,3,'German')
,(1,3,'English')
,(1,4,'English')
,(2,5,'English')
,(2,5,'German')
,(2,5,'Spanish')
,(2,6,'German')
,(2,6,'Spanish')
,(2,7,'English');
select company_id,count(*) as count_user from (select company_id,user_id,count(*) from company_users where language in ('English','German') group by company_id,user_id having(count(distinct language)=2)) group by company_id having(count(1)=2);

with cte as (
select company_id,user_id,language
,case when language='English' then 1
      when language='German' then 2
	  else 0 end as flag
from company_users)
,cte2 as (
select company_id,user_id,sum(flag)sflag from cte 
group by company_id,user_id
having  sum(flag)=3)
select company_id companyId from cte2
group by company_id
having count(1)>1;

with CTE as (
	select company_id,user_id, ROW_NUMBER() over(partition by company_id,user_id order by company_id) as RN
	from company_users
	where language in ('English','German')
)
select company_id,COUNT(user_id) from CTE 
	where RN=2
	group by company_id
	having COUNT(user_id)>=2;
----------------------------------------------------------------------------------------------------
drop table if exists products;
create table products
(
product_id varchar(20) ,
cost int
);
insert into products values ('P1',200),('P2',300),('P3',500),('P4',800);

create table customer_budget
(
customer_id int,
budget int
);

insert into customer_budget values (100,400),(200,800),(300,1500);    

with runnin_cost as (select *, sum(cost) over(order by cost ) as running_cost from products)
select customer_id,budget,count(1),listagg(product_id,',') from customer_budget a join runnin_cost b on a.budget>b.running_cost group by customer_id,budget
---------------------------------------------------------------------------------------------------

CREATE TABLE subscriber (
 sms_date date ,
 sender varchar(20) ,
 receiver varchar(20) ,
 sms_no int
);
-- insert some values
INSERT INTO subscriber VALUES ('2020-4-1', 'Avinash', 'Vibhor',10);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Avinash',20);
INSERT INTO subscriber VALUES ('2020-4-1', 'Avinash', 'Pawan',30);
INSERT INTO subscriber VALUES ('2020-4-1', 'Pawan', 'Avinash',20);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Pawan',5);
INSERT INTO subscriber VALUES ('2020-4-1', 'Pawan', 'Vibhor',8);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Deepak',50);

with cte as(select * , case when sender< receiver then sender else receiver end as p1,case when sender> receiver then sender else receiver end as p2 from subscriber)
select sms_date,p1,p2,sum(sms_no) as total_sms from cte group by sms_date,p1,p2;

with cte as (
Select sms_date, sender, receiver, sms_no 
from subscriber 
where sender<receiver 
union all 
Select sms_date, receiver,sender, sms_no 
from subscriber 
where sender>receiver 
)
Select sender, receiver, sum(sms_no) as total_sms, sms_date
from cte 
group by sender,receiver,sms_date;

