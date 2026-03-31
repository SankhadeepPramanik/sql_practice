--#prob-91
CREATE TABLE matches (
    match_id INT PRIMARY KEY,
    winning_team_id INT,
    losing_team_id INT,
    goals_won INT
);
delete from
    matches;
INSERT INTO
    matches (
        match_id,
        winning_team_id,
        losing_team_id,
        goals_won
    )
VALUES
    (1, 1001, 1007, 1),
    (2, 1007, 1001, 2),
    (3, 1006, 1003, 3),
    (4, 1001, 1003, 1),
    (5, 1007, 1001, 1),
    (6, 1006, 1003, 2),
    (7, 1006, 1001, 3),
    (8, 1007, 1003, 5),
    (9, 1001, 1003, 1),
    (10, 1007, 1006, 2),
    (11, 1006, 1003, 3),
    (12, 1001, 1003, 4),
    (13, 1001, 1006, 2),
    (14, 1007, 1001, 4),
    (15, 1006, 1007, 3),
    (16, 1001, 1003, 3),
    (17, 1001, 1007, 3),
    (18, 1006, 1007, 2),
    (19, 1003, 1001, 1),
    (20, 1001, 1007, 3),
    (21, 1001, 1003, 3);
CREATE TABLE teaminfo (team_id INT, team_name STRING);
INSERT INTO
    teaminfo (team_id, team_name)
VALUES
    (1001, 'Nickmiesters'),
    (1003, 'sunrisers'),
    (1006, 'Philipines prates'),
    (1007, 'Smashers');

select * from matches;
select * from teaminfo;

with cte as(select winning_team_id as team_id, 1 as point, goals_won as goals from matches 
union all
select losing_team_id as team_id, -1 as point, 0 as goals  from matches )
select team_id, sum(point) as point, sum(goals) as goals from cte  group by team_id order by point desc, goals desc;
---------------------------------------------------------------------------------------------------
--#prob-90

CREATE TABLE department (
    dep_id INT,
    dep_name VARCHAR(50)
);

CREATE TABLE empdetails (
    emp_id INT,
    first_name VARCHAR(50),
    gender VARCHAR(1),
    dep_id INT
);

CREATE TABLE client (
    client_id INT,
    client_name VARCHAR(50)
);

CREATE TABLE empsales (
    emp_id INT,
    client_id INT,
    sales INT
);

-- Insert data
INSERT INTO department (dep_id, dep_name) VALUES
(1, 'Electronics'),
(2, 'Furniture'),
(3, 'Clothing');

INSERT INTO empdetails (emp_id, first_name, gender, dep_id) VALUES
(101, 'Alice', 'F', 1),
(102, 'Bob', 'M', 1),
(103, 'Charlie', 'M', 2),
(104, 'Diana', 'F', 2),
(105, 'Ethan', 'M', 3),
(106, 'Fiona', 'F', 3);

INSERT INTO client (client_id, client_name) VALUES
(1, 'Amazon'),
(2, 'Walmart'),
(3, 'Costco'),
(4, 'Target'),
(5, 'BestBuy');

INSERT INTO empsales (emp_id, client_id, sales) VALUES
(101, 1, 5000),
(101, 2, 3000),
(102, 1, 7000),
(102, 3, 2000),
(103, 2, 4000),
(103, 4, 3000),
(104, 4, 6000),
(105, 5, 8000),
(106, 3, 5000),
(106, 5, 2000);

select * from client;
select * from empsales;
select * from empdetails;
select * from department;

with cte as (select e.emp_id, e.first_name,e.dep_id,s.client_id,s.sales from empdetails e left join empsales s on e.emp_id=s.emp_id),emp as (select emp_id,dep_id,sum(sales) as sales from cte group by emp_id,dep_id),client as (select client_id,dep_id,sum(sales) as sales from cte group by client_id,dep_id),
b_emp as (select emp.*,dense_rank() over(partition by dep_id order by sales desc) as e_rnk from emp qualify dense_rank() over(partition by dep_id order by sales desc)=1),b_client as (
select *,dense_rank() over(partition by dep_id order by sales desc) as c_rnk from client qualify dense_rank() over(partition by dep_id order by sales desc)=1)
select e.dep_id,e.emp_id,c.client_id from b_emp e join b_client c on e.dep_id=c.dep_id order by dep_id

-------------------------------------------------------------------------------------------------------------------------

--prob-89
CREATE TABLE orders (
    customer_id INT,
    order_date DATE,
    coupon_code VARCHAR(50)
);

TRUNCATE TABLE Orders;

-- ✅ Customer 1: First order in Jan, valid pattern
INSERT INTO Orders VALUES (1, '2025-01-10', NULL);
INSERT INTO Orders VALUES (1, '2025-02-05', NULL);
INSERT INTO Orders VALUES (1, '2025-02-20', NULL);
INSERT INTO Orders VALUES (1, '2025-03-01', NULL);
INSERT INTO Orders VALUES (1, '2025-03-10', NULL);
INSERT INTO Orders VALUES (1, '2025-03-15', 'DISC10'); -- last order with coupon ✅

-- ✅ Customer 2: First order in Feb, valid pattern
INSERT INTO Orders VALUES (2, '2025-02-02', NULL);   -- Month1 = 1
INSERT INTO Orders VALUES (2, '2025-02-05', NULL);   -- Month1 = 1
INSERT INTO Orders VALUES (2, '2025-03-05', NULL);   -- Month2 = 2
INSERT INTO Orders VALUES (2, '2025-03-18', NULL);
INSERT INTO Orders VALUES (2, '2025-03-20', NULL);   -- Month2 = 2
INSERT INTO Orders VALUES (2, '2025-03-22', NULL);
INSERT INTO Orders VALUES (2, '2025-04-02', NULL);   -- Month3 = 3
INSERT INTO Orders VALUES (2, '2025-04-10', NULL);
INSERT INTO Orders VALUES (2, '2025-04-15', 'DISC20'); -- last order with coupon ✅
INSERT INTO Orders VALUES (2, '2025-04-16', NULL);   -- Month3 = 3
INSERT INTO Orders VALUES (2, '2025-04-18', NULL);
INSERT INTO Orders VALUES (2, '2025-04-20', 'DISC20'); -- last order with coupon ✅

-- ❌ Customer 3: First order in March but wrong multiples
INSERT INTO Orders VALUES (3, '2025-03-05', NULL);  -- Month1 = 1
INSERT INTO Orders VALUES (3, '2025-04-10', NULL);  -- Month2 should have 2, but only 1 ❌
INSERT INTO Orders VALUES (3, '2025-05-15', 'DISC30');

-- ❌ Customer 4: First order in Feb but missing March (gap)
INSERT INTO Orders VALUES (4, '2025-02-01', NULL);  -- Month1
INSERT INTO Orders VALUES (4, '2025-04-05', 'DISC40'); -- Skipped March ❌

-- ❌ Customer 5: Valid multiples but last order has no coupon
INSERT INTO Orders VALUES (5, '2025-01-03', NULL);  -- M1 = 1
INSERT INTO Orders VALUES (5, '2025-02-05', NULL);  -- M2 = 2
INSERT INTO Orders VALUES (5, '2025-02-15', NULL);
INSERT INTO Orders VALUES (5, '2025-03-01', NULL);  -- M3 = 3
INSERT INTO Orders VALUES (5, '2025-03-08', 'DISC50'); -- coupon mid
INSERT INTO Orders VALUES (5, '2025-03-20', NULL);     -- last order no coupon ❌

-- ❌ Customer 6: Skips month 2, should be excluded
INSERT INTO Orders VALUES (6, '2025-01-05', NULL);     -- Month1 = 1 order
-- (no orders in Feb, so Month2 is missing ❌)
INSERT INTO Orders VALUES (6, '2025-03-02', NULL);     -- Month3 = 1st order
INSERT INTO Orders VALUES (6, '2025-03-15', NULL);     -- Month3 = 2nd order
-- Jump to May (Month5 relative to Jan)
INSERT INTO Orders VALUES (6, '2025-05-05', NULL);     
INSERT INTO Orders VALUES (6, '2025-05-10', NULL);     
INSERT INTO Orders VALUES (6, '2025-05-25', 'DISC60'); -- Last order with coupon


select * from orders;
with cte as 
(select customer_id,coupon_code,date_trunc(month,order_date) as order_date,order_date as order_date1 from orders)
,cte1 as (
select *,datediff(month,min(order_date) over(partition by customer_id order by order_date),order_date)+1 as diff,count(*) over(partition by customer_id,order_date order by order_date )as count ,last_value(coupon_code) over(partition by customer_id order by order_date1  rows between unbounded preceding and unbounded following) last_coupon from cte)
,cte2 as (
select customer_id,max(case when diff=1 then count else (0) end ) as first_mon,max(case when diff=2 then count else (0) end ) as second_mon,max(case when diff=3 then count else (0) end ) as third_mon,max(last_coupon) as last_coupon
 from cte1 where diff in (1,2,3) group by customer_id)
select * from cte2 where second_mon
=2*first_mon and third_mon=first_mon*3 and last_coupon is not null;

--------------------------------------------------------------------------------------------------------------------------
--prob-88

DROP TABLE IF EXISTS portal;

CREATE TABLE portal (
    portal_id INT PRIMARY KEY,
    portal_code VARCHAR(10),
    portal_name VARCHAR(50)
);

INSERT INTO portal (portal_id, portal_code, portal_name) VALUES
(1, 'MPR', 'My Perfect Resume'),
(2, 'RN',  'Resume Now'),
(3, 'ZETY','Zety'),
(4, 'LC',  'Live Career'),
(5, 'GEN', 'Resume Genius'),
(6, 'HELP','Resume Help');

DROP TABLE IF EXISTS user_registration;

CREATE TABLE user_registration (
    user_id BIGINT,
    portal_id INT,
    registration_datetime DATETIME,
    subscription_flag CHAR(1),
    subscription_datetime DATETIME NULL
);
delete from user_registration;
INSERT INTO user_registration VALUES
-- User 1001 registers on 2 portals, subscribes only on RN
(1001, 2, '2024-01-05 09:27:44', 'Y', '2024-01-06 10:00:00'),
-- User 1002 registers on ZETY and GEN, subscribes on both
(1002, 3, '2024-02-15 14:07:11', 'Y', '2024-02-15 15:30:00'),


-- User 1003 registers on RN and MPR, no subscriptions
(1003, 2, '2024-03-10 08:00:00', 'N', NULL),

-- User 1004 registers only once, subscribed
(1004, 4, '2024-05-19 09:45:00', 'Y', '2024-05-20 10:00:00'),

-- User 1005 registers only once, no subscription
(1005, 3, '2024-12-10 12:00:00', 'Y', '2024-12-15 12:00:00'),

-- User 1006 registers on 3 portals, mixed subscription
(1006, 1, '2024-07-01 11:00:00', 'Y', '2024-07-02 09:00:00'),


-- User 1007 registers on RN in Dec 2024, subscribes in Jan 2025 (boundary case)
(1007, 2, '2024-12-31 23:59:59', 'Y', '2025-01-01 00:15:00');

insert into user_registration values 
(1008, 4, '2024-03-15 23:59:59', 'N', NULL),
(1009, 2, '2025-01-15 23:59:59', 'Y', '2025-02-01 00:15:00');


insert into user_registration values
(1010, 3, '2024-02-10 14:00:00', 'N', NULL),
(1011, 5, '2024-03-01 00:00:00', 'Y', '2024-03-02 09:00:00'),
(1012, 1, '2024-04-01 09:30:00', 'N', NULL),
(1013, 2, '2024-07-05 14:00:00', 'N', NULL),
(1014, 5, '2024-08-10 18:00:00', 'Y', '2024-08-11 08:00:00'),
(1015, 2, '2024-01-20 23:59:59', 'Y', '2025-01-01 00:15:00');


DROP TABLE IF EXISTS resume_doc;

CREATE TABLE resume_doc (
    resume_id INT PRIMARY KEY,
    user_id BIGINT,
    date_created DATETIME,
    experience_years INT
);

INSERT INTO resume_doc VALUES
-- User 1001: Multiple resumes across portals
(2001, 1001, '2024-01-07 11:00:00', 2),
(2002, 1001, '2024-02-12 12:00:00', 3),

-- User 1002: Multiple resumes, high exp
(2003, 1002, '2024-02-16 10:00:00', 5),
(2004, 1002, '2024-03-05 12:00:00', 7),

-- User 1003: No resumes (edge case)

-- User 1004: Single resume, big experience
(2005, 1004, '2024-05-21 11:00:00', 12),

-- User 1005: Has resumes but no subscription
(2006, 1005, '2024-06-15 09:00:00', 0),
(2007, 1005, '2024-06-20 10:00:00', 1),

-- User 1006: Resumes before and after subscription
(2008, 1006, '2024-07-01 15:00:00', 8),
(2009, 1006, '2024-08-12 19:00:00', 9),

-- User 1007: Future-year resume
(2010, 1007, '2025-01-02 10:00:00', 20);

INSERT INTO resume_doc VALUES
-- User 1001: Multiple resumes across portals
(2011, 1001, '2025-01-07 11:00:00', 3),
(2012, 1001, '2025-01-08 11:00:00', 3);

select * from resume_doc;
select * from user_registration;
select * from portal;
--count of registration in every month in resume portal
select extract(month from registration_datetime) as month , count(*) as count from user_registration u join portal p on u.portal_id=p.portal_id where p.portal_name='Resume Now' group by extract(month from registration_datetime);
-- which portal haveing highest subscription rate for user_registtration 30 days.
select portal_id,count(*) as total_reg, count(subscription_datetime) as total_sub,count(subscription_datetime)/count(*) as rate   from user_registration 
--where registration_datetime>=dateadd(day,-30,current_date())
group by portal_id order by rate desc;
----how many user create resume less than 3 
with cte as (select user_id,count(*) as count from resume_doc group by user_id having count(*)<3)
select c.* from cte c join user_registration u on c.user_id=u.user_id;

----create a list of user who subscribed  2024 in zetty and get the experience year first resume
with cte as (select p.portal_name,u.*,r.*, row_number() over(partition by r.user_id order by date_created) as rnk from user_registration u join portal p on  u.portal_id=p.portal_id join resume_doc r on u.user_id=r.user_id where extract(year from subscription_datetime)=2024 and p.portal_name='Zety')
select * from cte where rnk=1 and experience_years>0;

------------------------------------------------------------------------------------------------------------------------
--prob-87

CREATE TABLE emp_details (
    emp_name VARCHAR(10),
    city VARCHAR(15)
);

-- Insert sample data
INSERT INTO emp_details (emp_name, city) VALUES
('Sam', 'New York'),
('David', 'New York'),
('Peter', 'New York'),
('Chris', 'New York'),
('John', 'New York'),
('Steve', 'San Francisco'),
('Rachel', 'San Francisco'),
('Robert', 'Los Angeles');

with cte as (select *,row_number() over (partition by city  order by city) as rnk,ceil(row_number() over (partition by city  order by city)/3) as team_group from emp_details)
select city ,concat('team',team_group), listagg(emp_name,',') within group(order by emp_name) from cte group by city,team_group order by city,team_grou;

-----------------------------------------------------------------------------------------------------------

--prob-85

CREATE TABLE airports (
    port_code VARCHAR(10) PRIMARY KEY,
    city_name VARCHAR(100)
);

CREATE TABLE flights (
    flight_id varchar (10),
    start_port VARCHAR(10),
    end_port VARCHAR(10),
    start_time datetime,
    end_time datetime
);

delete from airports;
INSERT INTO airports (port_code, city_name) VALUES
('JFK', 'New York'),
('LGA', 'New York'),
('EWR', 'New York'),
('LAX', 'Los Angeles'),
('ORD', 'Chicago'),
('SFO', 'San Francisco'),
('HND', 'Tokyo'),
('NRT', 'Tokyo'),
('KIX', 'Osaka');

delete from flights;
INSERT INTO flights VALUES
(1, 'JFK', 'HND', '2025-06-15 06:00', '2025-06-15 18:00'),
(2, 'JFK', 'LAX', '2025-06-15 07:00', '2025-06-15 10:00'),
(3, 'LAX', 'NRT', '2025-06-15 10:00', '2025-06-15 22:00'),
(4, 'JFK', 'LAX', '2025-06-15 08:00', '2025-06-15 11:00'),
(5, 'LAX', 'KIX', '2025-06-15 11:30', '2025-06-15 22:00'),
(6, 'LGA', 'ORD', '2025-06-15 09:00', '2025-06-15 12:00'),
(7, 'ORD', 'HND', '2025-06-15 11:30', '2025-06-15 23:30'),
(8, 'EWR', 'SFO', '2025-06-15 09:00', '2025-06-15 12:00'),
(9, 'LAX', 'HND', '2025-06-15 13:00', '2025-06-15 23:00'),
(10, 'KIX', 'NRT', '2025-06-15 08:00', '2025-06-15 10:00');


select * from flights;
select * from airports;
with cte as (select a.city_name as start_city ,a1.city_name as end_city ,f.start_time,f.end_time,f.flight_id from flights as f join airports as a on 
f.start_port=a.port_code join airports as a1 on f.end_port = a1.port_code),
drct_flight as (select start_city,null as Middle_state,end_city,timestampdiff(minute,start_time,end_time) as time_diff ,flight_id
from cte where start_city='New York' and end_city='Tokyo' order by time_diff)
,cte3 as (
select c1.start_city,c1.end_city as middle_state,c2.end_city,timestampdiff(minute,c1.start_time,c2.end_time) as time_diff,concat(c1.flight_id,';',c2.flight_id)
from cte as c1 
join cte as c2 on c1.end_city=c2.start_city 
where c1.start_city='New York' and 
c2.end_city='Tokyo' and c1.end_time <=c2.start_time order by time_diff)
select * from drct_flight union select * from cte3 order by time_diff;

--another sol
with flight_routes AS(
    SELECT
        a.*,
        b.city_name AS start_city,
        c.city_name AS end_city
    FROM
        flights a
        INNER JOIN airports b ON a.start_port = b.port_code
        INNER JOIN airports c ON a.end_port = c.port_code
)
SELECT
    a.start_city,
    b.start_city AS middle_city,
    coalesce(b.end_city,a.end_city) AS destination_city,
    DATEDIFF(
        minute,
        a.start_time,
        COALESCE(b.end_time, a.end_time)
    ) AS time_taken,
    CASE
        WHEN b.start_city IS NULL THEN a.flight_id
        ELSE CONCAT(a.flight_id, ',', b.flight_id)
    END as flight_id
FROM
    flight_routes a
    LEFT JOIN flight_routes b ON a.end_city = b.start_city
    AND b.start_time >= a.end_time
WHERE
    a.start_city = 'New York'
    AND (
        b.end_city = 'Tokyo'
        OR a.end_city = 'Tokyo'
    );


--------------------------------------------------------------------------------------------------
--prob-84

CREATE TABLE input_table_1 (
    Market VARCHAR(50),
    Sales INT
);

INSERT INTO input_table_1 (Market, Sales) VALUES
('India', 100),
('Maharashtra', 20),
('Telangana', 18),
('Karnataka', 22),
('Gujarat', 25),
('Delhi', 12),
('Nagpur', 8),
('Mumbai', 10),
('Agra', 5),
('Hyderabad', 9),
('Bengaluru', 12),
('Hubli', 12),
('Bhopal', 5);

CREATE TABLE input_table_2 (
    Country VARCHAR(50),
    State VARCHAR(50),
    City VARCHAR(50)
);
delete from input_table_2;
INSERT INTO input_table_2 (Country, State, City) VALUES
('India', 'Maharashtra', 'Nagpur'),
('India', 'Maharashtra', 'Mumbai'),
('India', 'Maharashtra', 'Akola'),
('India', 'Telangana', 'Hyderabad'),
('India', 'Karnataka', 'Bengaluru'),
('India', 'Karnataka', 'Hubli'),
('India', 'Gujarat', 'Ahmedabad'),
('India', 'Gujarat', 'Vadodara'),
('India', 'UP', 'Agra'),
('India', 'UP', 'Mirzapur'),
('India', 'Delhi', NULL), 
('India', 'Orissa', NULL); 

select * from input_table_1;
select * from input_table_2;


with city_sales as (select t2.*,t1.sales from input_table_1 t1  join input_table_2 t2 on t1.market=t2.city )
,city_level_state_sales as (
select country,state,sum(sales) as sales from city_sales group by country,state
),state_level as (
select distinct t2.country,t2.state,coalesce(t1.sales,0)as sales from input_table_2 t2 left join input_table_1 t1 on t1.market=t2.state 
),state_extra_slas as (
select s.country,s.state,(s.sales-coalesce(c.sales,0))as sales from state_level s left join city_level_state_sales c on s.state=c.state --where s.sales!=coalesce(c.sales,0) 
),state_city_sales as (
select country,state,city ,sales from city_sales 
union all 
select country,state, null,sales from state_extra_slas order by country,state
),country_sales   as (select distinct t2.country,t1.sales from input_table_1 t1  join input_table_2 t2 on t1.market=t2.country )
,country_extra_sales as (
select c.country,c.sales-s.sales as sales from country_sales c join (select country,sum(sales) as sales from  state_city_sales group by country) s on c.country=s.country)
select country,NULL as state,NULL as city , sales from country_extra_sales union select * from state_city_sales order by country,state,city;

--------------------------------------------------------------------------------------------------------------------
--prob-83

-- Create employees table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(10) NOT NULL,
    join_date DATE NOT NULL,
    department VARCHAR(10) NOT NULL
);

-- Insert sample data
INSERT INTO employees (employee_id, name, join_date, department)
VALUES
    (1, 'Alice', '2018-06-15', 'IT'),
    (2, 'Bob', '2019-02-10', 'Finance'),
    (3, 'Charlie', '2017-09-20', 'HR'),
    (4, 'David', '2020-01-05', 'IT'),
    (5, 'Eve', '2016-07-30', 'Finance'),
    (6, 'Sumit', '2016-06-30', 'Finance');
 
-- Create salary_history table
CREATE TABLE salary_history (
    employee_id INT,
    change_date DATE NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    promotion VARCHAR(3)
);

-- Insert sample data
INSERT INTO salary_history (employee_id, change_date, salary, promotion)
VALUES
    (1, '2018-06-15', 50000, 'No'),
    (1, '2019-08-20', 55000, 'No'),
    (1, '2021-02-10', 70000, 'Yes'),
    (2, '2019-02-10', 48000, 'No'),
    (2, '2020-05-15', 52000, 'Yes'),
    (2, '2023-01-25', 68000, 'Yes'),
    (3, '2017-09-20', 60000, 'No'),
    (3, '2019-12-10', 65000, 'No'),
    (3, '2022-06-30', 72000, 'Yes'),
    (4, '2020-01-05', 45000, 'No'),
    (4, '2021-07-18', 49000, 'No'),
    (5, '2016-07-30', 55000, 'No'),
    (5, '2018-11-22', 62000, 'Yes'),
    (5, '2021-09-10', 75000, 'Yes'),
    (6, '2016-06-30', 55000, 'No'),
    (6, '2017-11-22', 50000, 'No'),
    (6, '2018-11-22', 40000, 'No'),
    (6, '2021-09-10', 75000, 'Yes');

    select * from employees;
    select * from salary_history;


    with cte as(
    select e.name,e.join_date,s.*,row_number() over(partition by s.employee_id order by change_date desc) as latest_sal,
    row_number() over(partition by s.employee_id order by change_date ) as base_sal,sum(case when promotion='Yes' then 1 else      0 end) over(partition by s.employee_id ) as count_promotion
    from salary_history s join employees e on s.employee_id=e.employee_id
    )
    ,cte2 as (
    select *,lag(salary,1,salary) over(partition by employee_id order by change_date)   previous_sal,
    lag(change_date,1,change_date) over(partition by employee_id order by change_date) previous_date,
    abs(datediff(month,lag(change_date,1) over(partition by employee_id order by change_date),change_date)) as diff_date,
    (max(case when latest_sal=1  then salary end) over(partition by employee_id))/(max(case when base_sal=1 then salary end) over (partition by employee_id)) as sal_grow
    from cte),
    cte3 as (
    select * ,
        cast(((salary-previous_sal)*100.0/previous_sal) as decimal(38,2)) as hike,
        (salary-previous_sal) as sal_diff,
        max(case when (salary-previous_sal)<0 then 1 else 0 end) over(partition by employee_id) as diff_flag,
        avg(diff_date) over(partition by employee_id) as datediff,
        dense_rank() over( order by sal_grow desc,join_date ) as rnk
        from cte2
    )
    select  employee_id,
    max(case when latest_sal=1 then salary end) as latest_salary,
    max(count_promotion) as promotion, 
    max(hike) as hike,max(case when diff_flag=0 then 'Yes' else 'No' end)  Never_decrease,
    avg(datediff) as month_change,
    max(rnk) as sal_grow_rnk from cte3 group by employee_id order by employee_id;

-------------------------------------------------------------------------------------------------------------------

--prob-82

CREATE TABLE Politician (
    pname VARCHAR(10) PRIMARY KEY,
    party CHAR(1)
);

CREATE TABLE Company (
    cname VARCHAR(10) PRIMARY KEY,
    revenue INT
);

CREATE TABLE Invested (
    pname VARCHAR(10),
    cname VARCHAR(10)
);

CREATE TABLE Subsidiary (
    parent VARCHAR(10),
    child VARCHAR(10)
);

-- Politicians
INSERT INTO Politician (pname, party) VALUES
('Don', 'R'),
('Ron', 'R'),
('Hil', 'D'),
('Bill', 'D');

-- Companies
INSERT INTO Company (cname, revenue) VALUES
('C1', 110),
('C2', 30),
('C3', 50),
('C4', 250),
('C5', 75),
('C6', 15);

-- Investments
INSERT INTO Invested (pname, cname) VALUES
('Don', 'C1'),
('Don', 'C4'),
('Ron', 'C1'),
('Hil', 'C3');

-- Subsidiary relationships
INSERT INTO Subsidiary (parent, child) VALUES
('C1', 'C2'),
('C2', 'C3'),
('C2', 'C5'),
('C4', 'C6');

select * from subsidiary;
with  cte as (
select parent,child from subsidiary
union all
select c.parent,s.child from cte c join subsidiary s on c.child=s.parent 
)
select i.pname,u.pname , c.* from cte c join invested i on c.parent=i.cname join invested u on c.child=u.cname;
select * from invested;


----------------------------------------------------------------------------------------------------

--prob-81
-- 07:37 - Rank top restaurants by cuisine using SQL partitioning.
-- 10:25 - Analyzing daily new customer acquisition from first order data.
-- 15:42 - Filtering and analyzing customer orders for January 2025.
-- 18:12 - Identifying customers with orders only in January.
-- 23:09 - Joining tables to filter customers with promo code information.
-- 26:01 - Identify customers based on conditional SQL queries.
-- 30:50 - Retrieve customers with orders as multiples of three.
-- 33:10 - Querying customers based on their order milestones and promotions.
-- 37:32 - Analyzing organically acquired customers' first orders in January.
-- 40:17 - Analyzing customer acquisition data for January.