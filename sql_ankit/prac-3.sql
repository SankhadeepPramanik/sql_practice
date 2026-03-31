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


select a.segment,count( distinct a.user_id) as total_user,count( distinct case when extract(year from booking_date)=2022  and extract(month from booking_date)=4 and b.Line_of_business='Flight'  then a.user_id  end) as user_who_book_flight_2022_04 from user_table a left join booking_table b on a.user_id=b.user_id 
group by a.segment ;

with cte as (select *,row_number() over(partition by user_id order by booking_date) rnk from booking_table) 
select * from cte where LINE_OF_BUSINESS='Hotel' and rnk=1;
with cte as (select *,first_value(line_of_business) over(partition by user_id order by booking_date) business from booking_table) 
select distinct user_id from cte where BUSINESS='Hotel' ;

with cte as (select *,first_value(line_of_business) over(partition by user_id order by booking_date desc) last_book,first_value(line_of_business) over(partition by user_id order by booking_date ) first_book from booking_table) 
select  user_id,max(last_book) as last_book,max(first_book) as first_book from cte group by user_id ;

SELECT User_id,max(Booking_date),min(Booking_date),
DATEDIFF(DAY,min(Booking_date),max(Booking_date)) AS No_of_days
FROM booking_table
GROUP BY User_id;

SELECT Segment,
SUM(CASE WHEN Line_of_business='Flight' THEN 1 ELSE 0 END)AS No_of_Flights ,
SUM(CASE WHEN Line_of_business='Hotel' THEN 1 ELSE 0 END)AS No_of_Hotels
FROM booking_table a
INNER JOIN User_table b ON a.User_id=b.User_id
GROUP BY Segment

----------------------------------------------------------------------------------------------------------------------------------------

52 is recursive
-----------------------------------------------------------------------------------------------------------------
drop table if exists emp;
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
values (3, 'Vikas', 100, 10000,4,37);
insert into emp
values (4, 'Rohit', 100, 5000, 2, 16);
insert into emp
values (5, 'Mudit', 200, 12000, 6,55);
insert into emp
values (6, 'Agam', 200, 12000,2, 14);
insert into emp
values (7, 'Sanjay', 200, 9000, 2,13);
insert into emp
values (8, 'Ashish', 200,5000,2,12);
insert into emp
values (9, 'Mukesh',300,6000,6,51);
insert into emp
values (10, 'Rakesh',300,7000,6,50);


with cte as
(select distinct department_id, avg(salary) as dpt_avg from emp
group by department_id),
cte2 as
(select distinct a.department_id, a.dpt_avg, avg(b.salary) over(partition by a.department_id) as average
from cte a join emp b
on a.department_id<>b.department_id)
select distinct department_id from cte2
where dpt_avg<average;

WITH CTE as(
SELECT *,avg(salary)OVER(PARTITION BY department_id)AS avg_dept_salary,
count(emp_id)OVER(PARTITION BY department_id) AS emp_dept_count,
avg(salary)OVER() AS total_avg_salary,
count(emp_id)OVER() AS emp_overall_count
FROM emp),
cte_2 AS(
SELECT *,((total_avg_salary*emp_overall_count)-(emp_dept_count*avg_dept_salary))/(emp_overall_count-emp_dept_count) AS avg_desired
FROM CTE)
SELECT * FROM cte_2
WHERE avg_dept_salary<avg_desired;

------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE employee_checkin_details (
    employeeid INT,
    entry_details VARCHAR(10),
    timestamp_details DATETIME(2)
);

CREATE TABLE employee_details (
    employeeid INT,
    phone_number VARCHAR(10),
    isdefault BOOLEAN
);

-- employee_checkin_details
INSERT INTO employee_checkin_details (employeeid, entry_details, timestamp_details) VALUES
(1000, 'login', '2023-06-16 01:00:15.34'),
(1000, 'login', '2023-06-16 02:00:15.34'),
(1000, 'login', '2023-06-16 03:00:15.34'),
(1000, 'logout', '2023-06-16 12:00:15.34'),
(1001, 'login', '2023-06-16 01:00:15.34'),
(1001, 'login', '2023-06-16 02:00:15.34'),
(1001, 'login', '2023-06-16 03:00:15.34'),
(1001, 'logout', '2023-06-16 12:00:15.34');

-- employee_details
INSERT INTO employee_details (employeeid, phone_number, isdefault) VALUES
(1001, '9999', FALSE),
(1001, '1111', FALSE),
(1001, '2222', TRUE),
(1003, '3333', FALSE);

select * from employee_details;

with login as (select employeeid,count(*) as total_login,max(timestamp_details) as latest_login from employee_checkin_details where entry_details='login' group by employeeid),
logout as (select employeeid,count(*) as total_logout,max(timestamp_details)as latest_logout from employee_checkin_details where entry_details='logout' group by employeeid)
select a.employeeid,latest_login,total_login,latest_logout,total_logout,total_login +total_logout as total_entry,isdefault from login a join logout b on a.employeeid=b.employeeid left join employee_details c on a.employeeid=c.employeeid and c.isdefault='True';


with cte as (select c.employeeid,count(c.employeeid) as total_entry,
count(case when entry_details = 'login' then 1 else null end ) as total_login,
count(case when entry_details = 'logout' then 1 else null end ) as total_logout,
max(case when entry_details = 'login' then timestamp_details end) as latest_login,
max(case when entry_details = 'logout' then timestamp_details end) as latest_logout
from  
employee_checkin_details c
group by c.employeeid)
select a.*,c.isdefault from cte a left join employee_details c on a.employeeid=c.employeeid and c.isdefault='True';
------------------------------------------------------------------------------------------------------------------------------------------
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

 select * from job_positions;
 select * from job_employees;
with recursive cte as(
select id,title,groups,levels,payscale,totalpost ,1 as tt from job_positions
union all 
select id,title,groups,levels,payscale,totalpost , tt+1 as tt from cte
where tt+1<=totalpost)
,cte1 as (select *, ROW_NUMBER() over(partition by position_id order by position_id) as rn 
from job_employees)

select cte.id,title,groups,levels,payscale,totalpost,coalesce(name,'vacant') as name
from cte left join cte1 e on cte.id=e.position_id and tt=rn
order by title
--------------------------------------------------------------------------------------------------------------------------------------
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

with cte as (select o.city,o.sales, r.* 
from namaste_orders o left join namaste_returns r on o.order_id = r.order_id),
cte2 as (select city ,count(order_id)as count
from cte
group by city)
select city from cte2 where count=0
---------------------------------------------------------------------------------------------------------------------------------

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

    with cte as (
    select customer,start_loc as loc,'start_loc' as flag from travel_data
    union all
    select customer,end_loc as loc,'end_loc' as flag from travel_data
    ),cte1 as (
    select customer, loc,flag,count(*) over(partition by customer,loc order by customer) cnt from cte)
    select customer,max(case when flag='start_loc' then loc end)  as start_loc,max(case when flag='end_loc' then loc end) as end_loc from cte1 where cnt=1 group by customer order by customer;

with cet  as(
	select t1.customer , 
	case when t3.customer is null then t1.start_loc  end as  St ,
	case when t2.customer is null then t1.end_loc  end as  end_loc 
	
	from travel_data t1
	left join travel_data t2 on t1.end_loc = t2.start_loc
	left join travel_data t3 on t1.start_loc = t3.end_loc
	-- where t3.start_loc is null or t2.end_loc is null
	)
	 select customer , max(st) , max (end_loc)from cet 
	 group by customer

----------------------------------------------------------------------------------------------------------------------------------

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
,(1,'2023-04-06',20)
;
with cte as (
select sku_id,price_date,price, ROW_NUMBER() OVER(PARTITION BY year(price_date),month(price_date) 
order by price_date desc) AS rnk FROM sku order by price_date),

cte2 as(
SELECT sku_id,DATE_TRUNC(month,DATEADD(month,1,price_date)) AS next_month,price FROM cte WHERE
rnk=1
UNION ALL
SELECT * FROM sku WHERE DATE_PART(day,price_date)=1
)

SELECT *,coalesce(price-LAG(price) OVER ( ORDER BY next_month),0) AS price_diff FROM cte2 ORDER BY next_month;

with recursive cte as (
select min(price_date)  as all_dates from sku
union all
select all_dates + interval '1 day'
from cte
where 1=1
and all_dates <=  (select max(price_date) from sku)
),
cte1 as (
select sku_id, price, price_date, dateadd('day',-1,lead(price_date, 1, price_date)over(partition by sku_id order by price_date)) as next_price_date
from sku
),
cte2 as (
select sku_id, price, all_dates
from cte c
join
cte1 c1
on
all_dates between price_date and next_price_date
),
cte3 as (
select sku_id, price, all_dates
from cte2
where true
and day(all_dates) = 1
)
select sku_id, all_dates, price - lag(price, 1, price)over(partition by sku_id order by all_dates) as difference
from cte3;

-------------------------------------------------------------------------------------------------------------------------------------

create table customers  (customer_name varchar(30));
insert into customers values ('Ankit Bansal')
,('Vishal Pratap Singh')
,('Michael'); 

select customer_name, 
split_part(customer_name, ' ', 1) as first_name,
split_part(customer_name, ' ', 2) as scn_name,
split_part(customer_name, ' ', 3) third_name
from customers;

with cte as (
select *,
LEN(customer_name)-
len(REPLACE(customer_name,' ','')) as spaces,
CHARINDEX(' ',customer_name) as space_position,
CHARINDEX(' ',customer_name,CHARINDEX(' ',customer_name)+1) as space_position_2
from customers)

select *,
case when spaces=0 then customer_name
when spaces!=0 then left(customer_name,space_position-1) end as first_name
,
case when spaces>1
then SUBSTRING(customer_name,space_position+1,space_position_2-space_position-1) end as middle_name
,
case when spaces=1
then right(customer_name,len(customer_name)-space_position)
when spaces>1
then right(customer_name,len(customer_name)-space_position_2)
end as last_name

from cte;

----------------------------------------------------------------------------------------------------------------

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
	case when count(interaction_type)=0 then 'no social interaction'
	 when count(distinct case when interaction_type is not null then user_id else NULL end)=1 then 'one sided interaction' 
	 when count(case when interaction_type='custom_typed' then 1 else NULL end)>=1 then 'both sidedinteraction with custom messagd'
	 else 'both sided  interaction without custom message' end
	as game_type 
	from user_interactions
	group by game_id)
select game_type, count(1)*100/(count(1) over ()) as percentage  
from cte
group by game_type
order by game_type;
------------------------------------------------------------------------------------------------------------------


 