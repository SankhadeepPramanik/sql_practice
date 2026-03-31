--prob-80
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    amount INT,
    tran_Date datetime
);

delete from Transactions;
INSERT INTO Transactions VALUES (1, 101, 500, '2025-01-01 10:00:01');
INSERT INTO Transactions VALUES (2, 201, 500, '2025-01-01 10:00:01');
INSERT INTO Transactions VALUES (3, 102, 300, '2025-01-02 00:50:01');
INSERT INTO Transactions VALUES (4, 202, 300, '2025-01-02 00:50:01');
INSERT INTO Transactions VALUES (5, 101, 700, '2025-01-03 06:00:01');
INSERT INTO Transactions VALUES (6, 202, 700, '2025-01-03 06:00:01');
INSERT INTO Transactions VALUES (7, 103, 200, '2025-01-04 03:00:01');
INSERT INTO Transactions VALUES (8, 203, 200, '2025-01-04 03:00:01');
INSERT INTO Transactions VALUES (9, 101, 400, '2025-01-05 00:10:01');
INSERT INTO Transactions VALUES (10, 201, 400, '2025-01-05 00:10:01');
INSERT INTO Transactions VALUES (11, 101, 500, '2025-01-07 10:10:01');
INSERT INTO Transactions VALUES (12, 201, 500, '2025-01-07 10:10:01');
INSERT INTO Transactions VALUES (13, 102, 200, '2025-01-03 10:50:01');
INSERT INTO Transactions VALUES (14, 202, 200, '2025-01-03 10:50:01');
INSERT INTO Transactions VALUES (15, 103, 500, '2025-01-01 11:00:01');
INSERT INTO Transactions VALUES (16, 101, 500, '2025-01-01 11:00:01');
INSERT INTO Transactions VALUES (17, 203, 200, '2025-11-01 11:00:01');
INSERT INTO Transactions VALUES (18, 201, 200, '2025-11-01 11:00:01');


select * from transactions;


with cte as (
select transaction_id,customer_id as Seller ,lead(customer_id) over (order by transaction_id) as Buyer
,Amount, tran_date from transactions)

,cte2 as (
select seller, buyer,count(transaction_id) as total_transaction from cte where transaction_id%2<>0 
group by seller, buyer)

select * from cte2 where seller not in (select buyer from cte2) and buyer not in (select seller from cte2)
;
-------------------------------------------------------------------------------------------------------------------------

--prob-79

create table assessments
(
id int,
experience int,
sql int,
algo int,
bug_fixing int
);
delete from assessments;
insert into assessments values 
(1,3,100,null,50),
(2,5,null,100,100),
(3,1,100,100,100),
(4,5,100,50,null),
(5,5,100,100,100);

delete from assessments;
insert into assessments values 
(1,2,null,null,null),
(2,20,null,null,20),
(3,7,100,null,100),
(4,3,100,50,null),
(5,2,40,100,100);

select 
	experience,
    sum(
    case when (sql is null or sql = 100) and 
    (algo is null or algo = 100) and 
    (bug_fixing is null or bug_fixing = 100) then 1 else 0 end) as max_score_students,
     count(id) as total_students
from 
	assessments 
group by experience
order by experience;


--------------------------------------------------------------------------------------------------------------------
--prob-78
create table cricket_match(
matchid integer,
ballnumber integer,
inningno integer,
overs float,
outcome varchar(100),
batter varchar(100),
bowler varchar(100),
score float
);
INSERT INTO cricket_match VALUES(1,1,1,0.1,'0','Mohammed Shami','Devon Conway',0),(1,2,1,0.2,'1lb','Mohammed Shami','Devon Conway',1),(1,3,1,0.3,'0','Mohammed Shami','Ruturaj Gaikwad',0),(1,4,1,0.4,'1','Mohammed Shami','Ruturaj Gaikwad',1),(1,5,1,0.5,'0','Mohammed Shami','Devon Conway',0),(1,6,1,0.6,'0','Mohammed Shami','Devon Conway',0),(1,7,1,1.1,'4','Hardik Pandya','Ruturaj Gaikwad',4),(1,8,1,1.2,'0','Hardik Pandya','Ruturaj Gaikwad',0),(1,9,1,1.3,'4','Hardik Pandya','Ruturaj Gaikwad',4),(1,10,1,1.4,'1','Hardik Pandya','Ruturaj Gaikwad',1),(1,11,1,1.5,'1','Hardik Pandya','Devon Conway',1),(1,12,1,1.6,'1','Hardik Pandya','Ruturaj Gaikwad',1),(1,13,2,2.1,'1','Ruturaj Gaikwad','Mohammed Shami',1),(1,14,2,2.2,'w','Devon Conway','Mohammed Shami',0),(1,15,2,2.3,'0','Moeen Ali','Mohammed Shami',0),(1,16,2,2.4,'0','Moeen Ali','Mohammed Shami',0),(1,17,2,2.5,'0','Moeen Ali','Mohammed Shami',0),(1,18,2,2.6,'0','Moeen Ali','Mohammed Shami',0),(1,19,2,3.1,'6','Ruturaj Gaikwad','Josh Little',6),(1,20,2,3.2,'4','Ruturaj Gaikwad','Josh Little',4),(1,21,2,3.3,'1','Ruturaj Gaikwad','Josh Little',1),(1,22,2,3.4,'0','Moeen Ali','Josh Little',0),(1,23,2,3.5,'4','Moeen Ali','Josh Little',4),(1,24,2,3.6,'0','Moeen Ali','Josh Little',0),(2,1,1,4.1,'0','Mohammed Shami','Ruturaj Gaikwad',0),(2,2,1,4.2,'1','Mohammed Shami','Ruturaj Gaikwad',1),(2,3,1,4.3,'4','Mohammed Shami','Moeen Ali',4),(2,4,1,4.4,'1nb','Mohammed Shami','Moeen Ali',1),(2,5,1,4.4,'6','Mohammed Shami','Moeen Ali',6),(2,6,1,4.5,'4','Mohammed Shami','Moeen Ali',4),(2,7,1,4.6,'1','Mohammed Shami','Moeen Ali',1),(2,8,1,5.1,'0','Rashid Khan','Moeen Ali',0),(2,9,1,5.2,'0','Rashid Khan','Moeen Ali',0),(2,10,1,5.3,'0','Rashid Khan','Moeen Ali',0),(2,11,1,5.4,'4','Rashid Khan','Moeen Ali',4),(2,12,1,5.5,'w','Rashid Khan','Moeen Ali',0),(2,13,1,5.6,'1','Rashid Khan','Ben S',1),(2,14,2,6.1,'0','Ben S','Hardik Pandya',0),(2,15,2,6.2,'1','Ben S','Hardik Pandya',1),(2,16,2,6.3,'6','Ruturaj Gaikwad','Hardik Pandya',6),(2,17,2,6.4,'6','Ruturaj Gaikwad','Hardik Pandya',6),(2,18,2,6.5,'0','Ruturaj Gaikwad','Hardik Pandya',0),(2,19,2,6.6,'0','Ruturaj Gaikwad','Hardik Pandya',0),(2,20,2,7.1,'1','Ben S','Rashid Khan',1),(2,21,2,7.2,'1','Ruturaj Gaikwad','Rashid Khan',1),(2,22,2,7.3,'4','Ben S','Rashid Khan',4),(2,23,2,7.4,'w','Ben S','Rashid Khan',0),(2,24,2,7.5,'1','Ambati Rayudu','Rashid Khan',1),(2,25,2,7.6,'1','Ruturaj Gaikwad','Rashid Khan',1),(3,1,1,8.1,'6','Alzarri Joseph','Ruturaj Gaikwad',6),(3,2,1,8.2,'0','Alzarri Joseph','Ruturaj Gaikwad',0),(3,3,1,8.3,'0','Alzarri Joseph','Ruturaj Gaikwad',0),(3,4,1,8.4,'6','Alzarri Joseph','Ruturaj Gaikwad',6),(3,5,1,8.5,'0','Alzarri Joseph','Ruturaj Gaikwad',0),(3,6,1,8.6,'6','Alzarri Joseph','Ruturaj Gaikwad',6),(3,7,1,9.1,'0','Rashid Khan','Brett Lee',0),(3,8,1,9.2,'1','Rashid Khan','Brett Lee',1),(3,9,1,9.3,'1','Rashid Khan','Ruturaj Gaikwad',1),(3,10,1,9.4,'1','Rashid Khan','Brett Lee',1),(3,11,1,9.5,'0','Rashid Khan','Ruturaj Gaikwad',0),(3,12,1,9.6,'0','Rashid Khan','Ruturaj Gaikwad',0),(3,13,2,10.1,'0','Ambati Rayudu','Josh Little',0),(3,14,2,10.2,'0','Ambati Rayudu','Josh Little',0),(3,15,2,10.3,'0','Ambati Rayudu','Josh Little',0),(3,16,2,10.4,'1','Ambati Rayudu','Josh Little',1),(3,17,2,10.5,'0','Ruturaj Gaikwad','Josh Little',0),(3,18,2,10.6,'6','Ruturaj Gaikwad','Josh Little',6),(3,19,2,11.1,'1','Ambati Rayudu','Yash Dayal',1),(3,20,2,11.2,'0','Ruturaj Gaikwad','Yash Dayal',0),(3,21,2,11.3,'6','Ruturaj Gaikwad','Yash Dayal',6),(3,22,2,11.4,'0','Ruturaj Gaikwad','Yash Dayal',0),(3,23,2,11.5,'1','Ruturaj Gaikwad','Yash Dayal',1),(3,24,2,11.6,'6','Ambati Rayudu','Yash Dayal',6),(4,1,1,12.1,'1','Josh Little','Ruturaj Gaikwad',1),(4,2,1,12.2,'1','Josh Little','Brett Lee',1),(4,3,1,12.3,'4','Josh Little','Ruturaj Gaikwad',4),(4,4,1,12.4,'1','Josh Little','Ruturaj Gaikwad',1),(4,5,1,12.5,'w','Josh Little','Brett Lee',0),(4,6,1,12.6,'0','Josh Little','Shivam Dube',0),(4,7,1,13.1,'1','Alzarri Joseph','Ruturaj Gaikwad',1),(4,8,1,13.2,'1','Alzarri Joseph','Shivam Dube',1),(4,9,1,13.3,'1','Alzarri Joseph','Ruturaj Gaikwad',1),(4,10,1,13.4,'0','Alzarri Joseph','Shivam Dube',0),(4,11,1,13.5,'0','Alzarri Joseph','Shivam Dube',0),(4,12,1,13.6,'1','Alzarri Joseph','Shivam Dube',1),(4,13,2,14.1,'1','Shivam Dube','Hardik Pandya',1),(4,14,2,14.2,'1','Ruturaj Gaikwad','Hardik Pandya',1),(4,15,2,14.3,'4lb','Shivam Dube','Hardik Pandya',4),(4,16,2,14.4,'1','Shivam Dube','Hardik Pandya',1),(4,17,2,14.5,'0','Ruturaj Gaikwad','Hardik Pandya',0),(4,18,2,14.6,'1','Ruturaj Gaikwad','Hardik Pandya',1),(4,19,2,15.1,'1','Ruturaj Gaikwad','Alzarri Joseph',1),(4,20,2,15.2,'0','Shivam Dube','Alzarri Joseph',0),(4,21,2,15.3,'1','Shivam Dube','Alzarri Joseph',1),(4,22,2,15.4,'1','Ruturaj Gaikwad','Alzarri Joseph',1),(4,23,2,15.5,'2','Shivam Dube','Alzarri Joseph',2),(4,24,2,15.6,'2','Shivam Dube','Alzarri Joseph',2);

select * from cricket_match;

with cte as (select  matchid,batter as player , 'batter' as type from cricket_match
union 
select  matchid,bowler as player, 'bowler' as type from cricket_match  order by player)
select player,count(distinct matchid) as total_match,sum(case when type='batter' then 1 else 0 end) as batter ,sum(case when type='bowler' then 1 else 0 end) as bowler from cte group by player order by player;
-------------------------------------------------------------------------------------------------------------------
--prob-77
create table events 
(userid int , 
event_type varchar(20),
event_time datetime);

insert into events VALUES (1, 'click', '2023-09-10 09:00:00');
insert into events VALUES (1, 'click', '2023-09-10 10:00:00');
insert into events VALUES (1, 'scroll', '2023-09-10 10:20:00');
insert into events VALUES (1, 'click', '2023-09-10 10:50:00');
insert into events VALUES (1, 'scroll', '2023-09-10 11:40:00');
insert into events VALUES (1, 'click', '2023-09-10 12:40:00');
insert into events VALUES (1, 'scroll', '2023-09-10 12:50:00');
insert into events VALUES (2, 'click', '2023-09-10 09:00:00');
insert into events VALUES (2, 'scroll', '2023-09-10 09:20:00');
insert into events VALUES (2, 'click', '2023-09-10 10:30:00');

select * from events;

with cte as (
select *,lag(event_time,1,event_time) over(partition by userid order by event_time) as next_time, datediff('minute',lag(event_time,1,event_time) over(partition by userid order by event_time),event_time) as diff from events), cte1 as(
select *,case when diff>30  then 1 else 0 end as s_diff,sum(case when diff>30  then 1 else 0 end) over(partition by userid order by event_time) as g_id from cte order by userid,g_id)
select userid,g_id+1 as session_id,min(event_time) as min_time, max(event_time) as max_time, count( event_type) as count_type,datediff(minute,min(event_time),max(event_time)) as duration from cte1 group by userid,g_id order by userid,g_id;
------------------------------------------------------------------------------------------------------------------------
--prob-76
create table phone_numbers (num varchar(20));
insert into phone_numbers values
('1234567780'),
('2234578996'),
('+1-12244567780'),
('+32-2233567889'),
('+2-23456987312'),
('+91-9087654123'),
('+23-9085761324'),
('+11-8091013345');

select * from phone_numbers;
select *,split_part(num,'-',2)  from phone_numbers;
select *,substr(num,position('-' in num)+1,length(num))  from phone_numbers;
select *,position('-' in num)  from phone_numbers;
select a.* from table(SPLIT_TO_TABLE('a-b-c','-')) a;


with cte as (SELECT *,
       position('-' in num) AS pos,
       CASE 
           WHEN position('-' in num) = 0 THEN num
           ELSE split_part(num, '-', 2)
       END AS value
FROM phone_numbers)
select * from cte 
;
--------------------------------------------------------------------------------------------------
--prob-75
create table polls
(
user_id varchar(4),
poll_id varchar(3),
poll_option_id varchar(3),
amount int,
created_date date
);
-- Insert sample data into the investments table
INSERT INTO polls (user_id, poll_id, poll_option_id, amount, created_date) VALUES
('id1', 'p1', 'A', 200, '2021-12-01'),
('id2', 'p1', 'C', 250, '2021-12-01'),
('id3', 'p1', 'A', 200, '2021-12-01'),
('id4', 'p1', 'B', 500, '2021-12-01'),
('id5', 'p1', 'C', 50, '2021-12-01'),
('id6', 'p1', 'D', 500, '2021-12-01'),
('id7', 'p1', 'C', 200, '2021-12-01'),
('id8', 'p1', 'A', 100, '2021-12-01'),
('id9', 'p2', 'A', 300, '2023-01-10'),
('id10', 'p2', 'C', 400, '2023-01-11'),
('id11', 'p2', 'B', 250, '2023-01-12'),
('id12', 'p2', 'D', 600, '2023-01-13'),
('id13', 'p2', 'C', 150, '2023-01-14'),
('id14', 'p2', 'A', 100, '2023-01-15'),
('id15', 'p2', 'C', 200, '2023-01-16');

create table poll_answers
(
poll_id varchar(3),
correct_option_id varchar(3)
);
INSERT INTO poll_answers (poll_id, correct_option_id) VALUES
('p1', 'C'),('p2', 'A');
select * from poll_answers;
select * from polls
;

with cte as (
select p.*,a.correct_option_id as correct,
case when poll_option_id!=correct then 'looser' else 'winner' end as status 
from polls p join poll_answers a  on p.poll_id=a.poll_id)
,looser as (select poll_id,sum(amount) as looser_amount from cte where status='looser' group by poll_id)
,winner as (select poll_id,user_id,amount,sum(amount) over(partition by poll_id) total_by_pollid,amount/sum(amount) over(partition by poll_id) as propotion  from cte where status='winner' ) 
select winner.*,looser_amount, round(propotion*looser_amount,2) as winner_got from winner join looser on looser.poll_id=winner.poll_id;
;
----------------------------------------------------------------------------------------
--prob-74
create table numbers (n int);
insert into numbers values (1),(2),(3),(4),(5);
insert into numbers values (9);
select * from numbers;

with cte as ( 
select n,1 as total from numbers
union all
select cte.n,total+1 from cte where  total+1<=n
)
select * from cte order by n;

-- 1 1
-- 1 2
-- 2 2
-- 3 2 --wrong
select n1.n,n2.n from numbers n1 join numbers n2 on n1.n>=n2.n order by n1.n,n2.n;

--Missing element
with cte as (
select max(n) as max1,min(n) as min1,min(n) as num from numbers
union all
select max1,min1,num+1 from cte where num+1<=max1
)
select num from cte left join numbers on cte.num=numbers.n where numbers.n is NULL;


----------------------------------------------------------------------------------------------
--prob-73
CREATE TABLE subscription_history (
    customer_id INT,
    marketplace VARCHAR(10),
    event_date DATE,
    event CHAR(1),
    subscription_period INT
);

INSERT INTO subscription_history VALUES (1, 'India', '2020-01-05', 'S', 6);
INSERT INTO subscription_history VALUES (1, 'India', '2020-12-05', 'R', 1);
INSERT INTO subscription_history VALUES (1, 'India', '2021-02-05', 'C', null);
INSERT INTO subscription_history VALUES (2, 'India', '2020-02-15', 'S', 12);
INSERT INTO subscription_history VALUES (2, 'India', '2020-11-20', 'C', null);
INSERT INTO subscription_history VALUES (3, 'USA', '2019-12-01', 'S', 12);
INSERT INTO subscription_history VALUES (3, 'USA', '2020-12-01', 'R', 12);
INSERT INTO subscription_history VALUES (4, 'USA', '2020-01-10', 'S', 6);
INSERT INTO subscription_history VALUES (4, 'USA', '2020-09-10', 'R', 3);
INSERT INTO subscription_history VALUES (4, 'USA', '2020-12-25', 'C', null);
INSERT INTO subscription_history VALUES (5, 'UK', '2020-06-20', 'S', 12);
INSERT INTO subscription_history VALUES (5, 'UK', '2020-11-20', 'C', null);
INSERT INTO subscription_history VALUES (6, 'UK', '2020-07-05', 'S', 6);
INSERT INTO subscription_history VALUES (6, 'UK', '2021-03-05', 'R', 6);
INSERT INTO subscription_history VALUES (7, 'Canada', '2020-08-15', 'S', 12);
INSERT INTO subscription_history VALUES (8, 'Canada', '2020-09-10', 'S', 12);
INSERT INTO subscription_history VALUES (8, 'Canada', '2020-12-10', 'C', null);
INSERT INTO subscription_history VALUES (9, 'Canada', '2020-11-10', 'S', 1);

select * from subscription_history;

with cte as (select *,row_number() over(partition by customer_id order by  event_date desc) as rnk from subscription_history where event_date<=cast('2020-12-31' as date))
select customer_id,dateadd('month',cast(subscription_period as int),event_date) from cte where rnk=1 and event!='C' and dateadd('month',cast(subscription_period as int),event_date)>cast('2020-12-31' as date);
----------------------------------------------------------------------------------------------

--prob-72
CREATE TABLE swipe (
    employee_id INT,
    activity_type VARCHAR(10),
    activity_time datetime
);

-- Insert sample data
INSERT INTO swipe (employee_id, activity_type, activity_time) VALUES
(1, 'login', '2024-07-23 08:00:00'),
(1, 'logout', '2024-07-23 12:00:00'),
(1, 'login', '2024-07-23 13:00:00'),
(1, 'logout', '2024-07-23 17:00:00'),
(2, 'login', '2024-07-23 09:00:00'),
(2, 'logout', '2024-07-23 11:00:00'),
(2, 'login', '2024-07-23 12:00:00'),
(2, 'logout', '2024-07-23 15:00:00'),
(1, 'login', '2024-07-24 08:30:00'),
(1, 'logout', '2024-07-24 12:30:00'),
(2, 'login', '2024-07-24 09:30:00'),
(2, 'logout', '2024-07-24 10:30:00');

select * from swipe;

with cte as (select *,cast(activity_time as date)  as activity_date,
lead(activity_time,1,activity_time) over(partition by employee_id, cast(activity_time as date) order by activity_time) log_out_time
from swipe ),productive_hour as (
select employee_id,activity_date,(activity_time) as login,(log_out_time) as logout,datediff(hour,activity_time,log_out_time) as productive_hour from cte where activity_type='login' 
)
select employee_id,activity_date,min(activity_time) as login,max(log_out_time) as logout,sum(datediff(hour,activity_time,log_out_time)) productive_hour,datediff(hour,min(activity_time),max(log_out_time)) as total_office_hour 
from cte
where activity_type='login' group by employee_id,activity_date

------------------------------------------------------------------------------------------

--prob-71

CREATE TABLE friends (
    user_id INT,
    friend_id INT
);

-- Insert data into friends table
INSERT INTO friends VALUES
(1, 2),
(1, 3),
(1, 4),
(2, 1),
(3, 1),
(3, 4),
(4, 1),
(4, 3);

-- Create likes table
CREATE TABLE likes (
    user_id INT,
    page_id CHAR(1)
);

-- Insert data into likes table
INSERT INTO likes VALUES
(1, 'A'),
(1, 'B'),
(1, 'C'),
(2, 'A'),
(3, 'B'),
(3, 'C'),
(4, 'B');


select * from friends;
select * from likes;

with friends_page as (select distinct f.*,l.page_id as friend_page from friends f join likes l on f.friend_id=l.user_id),
user_page as (select distinct f.user_id,l.page_id as user_page from friends f join likes l on f.user_id=l.user_id)

select distinct f.user_id,f.friend_page from  friends_page f left join  user_page u on f.user_id=u.user_id and f.friend_page=u.user_page where u.user_id is NULL order by f.user_id ;


--sol-2
select distinct f.*,fl.page_id as friend_page,ul.page_id as user_id from friends f 
join likes fl on f.friend_id=fl.user_id 
left join likes ul on f.user_id=ul.user_id and fl.page_id=ul.page_id where ul.page_id is null;

--sol3
with cte as (select f.user_id, l.page_id from likes l
join friends f on f.friend_id = l.user_id)
select user_id,page_id from cte except (select * from likes)
order by 1,2

--------------------------------------------------------------------------------------------------------------------

--prob-70
CREATE TABLE cinema (
    seat_id INT PRIMARY KEY,
    free int
);
delete from cinema;
INSERT INTO cinema (seat_id, free) VALUES (1, 1);
INSERT INTO cinema (seat_id, free) VALUES (2, 0);
INSERT INTO cinema (seat_id, free) VALUES (3, 1);
INSERT INTO cinema (seat_id, free) VALUES (4, 1);
INSERT INTO cinema (seat_id, free) VALUES (5, 1);
INSERT INTO cinema (seat_id, free) VALUES (6, 0);
INSERT INTO cinema (seat_id, free) VALUES (7, 1);
INSERT INTO cinema (seat_id, free) VALUES (8, 1);
INSERT INTO cinema (seat_id, free) VALUES (9, 0);
INSERT INTO cinema (seat_id, free) VALUES (10, 1);
INSERT INTO cinema (seat_id, free) VALUES (11, 0);
INSERT INTO cinema (seat_id, free) VALUES (12, 1);
INSERT INTO cinema (seat_id, free) VALUES (13, 0);
INSERT INTO cinema (seat_id, free) VALUES (14, 1);
INSERT INTO cinema (seat_id, free) VALUES (15, 1);
INSERT INTO cinema (seat_id, free) VALUES (16, 0);
INSERT INTO cinema (seat_id, free) VALUES (17, 1);
INSERT INTO cinema (seat_id, free) VALUES (18, 1);
INSERT INTO cinema (seat_id, free) VALUES (19, 1);
INSERT INTO cinema (seat_id, free) VALUES (20, 1);


select * from cinema;
with cte as (select *,row_number() over (order by seat_id) as rnk,seat_id-row_number() over (order by seat_id) as group_id from cinema where free=1)
select seat_id,count(*) over(partition by group_id) as cnt from cte qualify count(*) over(partition by group_id)> 1;


------------------------------------------------------------------------------------------------------------------------
--prob-69
CREATE TABLE users (
    USER_ID INT PRIMARY KEY,
    USER_NAME VARCHAR(20) NOT NULL,
    USER_STATUS VARCHAR(20) NOT NULL
);

CREATE TABLE logins (
    USER_ID INT,
    LOGIN_TIMESTAMP DATETIME NOT NULL,
    SESSION_ID INT PRIMARY KEY,
    SESSION_SCORE INT,
    FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID)
);

-- Users Table
INSERT INTO USERS VALUES (1, 'Alice', 'Active');
INSERT INTO USERS VALUES (2, 'Bob', 'Inactive');
INSERT INTO USERS VALUES (3, 'Charlie', 'Active');
INSERT INTO USERS  VALUES (4, 'David', 'Active');
INSERT INTO USERS  VALUES (5, 'Eve', 'Inactive');
INSERT INTO USERS  VALUES (6, 'Frank', 'Active');
INSERT INTO USERS  VALUES (7, 'Grace', 'Inactive');
INSERT INTO USERS  VALUES (8, 'Heidi', 'Active');
INSERT INTO USERS VALUES (9, 'Ivan', 'Inactive');
INSERT INTO USERS VALUES (10, 'Judy', 'Active');

-- Logins Table 

INSERT INTO LOGINS  VALUES (1, '2023-07-15 09:30:00', 1001, 85);
INSERT INTO LOGINS VALUES (2, '2023-07-22 10:00:00', 1002, 90);
INSERT INTO LOGINS VALUES (3, '2023-08-10 11:15:00', 1003, 75);
INSERT INTO LOGINS VALUES (4, '2023-08-20 14:00:00', 1004, 88);
INSERT INTO LOGINS  VALUES (5, '2023-09-05 16:45:00', 1005, 82);

INSERT INTO LOGINS  VALUES (6, '2023-10-12 08:30:00', 1006, 77);
INSERT INTO LOGINS  VALUES (7, '2023-11-18 09:00:00', 1007, 81);
INSERT INTO LOGINS VALUES (8, '2023-12-01 10:30:00', 1008, 84);
INSERT INTO LOGINS  VALUES (9, '2023-12-15 13:15:00', 1009, 79);


-- 2024 Q1
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (1, '2024-01-10 07:45:00', 1011, 86);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (2, '2024-01-25 09:30:00', 1012, 89);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (3, '2024-02-05 11:00:00', 1013, 78);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (4, '2024-03-01 14:30:00', 1014, 91);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (5, '2024-03-15 16:00:00', 1015, 83);

INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (6, '2024-04-12 08:00:00', 1016, 80);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (7, '2024-05-18 09:15:00', 1017, 82);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (8, '2024-05-28 10:45:00', 1018, 87);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (9, '2024-06-15 13:30:00', 1019, 76);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-25 15:00:00', 1010, 92);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-26 15:45:00', 1020, 93);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-27 15:00:00', 1021, 92);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-28 15:45:00', 1022, 93);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (1, '2024-01-10 07:45:00', 1101, 86);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (3, '2024-01-25 09:30:00', 1102, 89);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (5, '2024-01-15 11:00:00', 1103, 78);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (2, '2023-11-10 07:45:00', 1201, 82);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (4, '2023-11-25 09:30:00', 1202, 84);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (6, '2023-11-15 11:00:00', 1203, 80);


select * from logins;
select * from users;

----user who not login last 5 months
select user_id,max(login_timestamp) from logins  group by user_id having max(login_timestamp)<dateadd(month,-5,current_date())order by user_id;


------
select user_id from logins where user_id not in (
select user_id from logins where login_timestamp>dateadd(month,-5,current_date())
);

----------------------------------------------


--find how many user and how many session were each quarter....order by quarter new to old

select extract(quarter from login_timestamp) as quarter , count(distinct user_id),count(distinct SESSION_ID),min(login_timestamp) as quarter_first_login,date_trunc(quarter,min(login_timestamp)) as quarter_start
 from logins group by  extract(quarter from login_timestamp) order by  extract(quarter from login_timestamp)
;

--user who login january but not login novemeber


select * from logins where extract(month from login_timestamp) =1 and user_id not in (select user_id from logins where extract(month from login_timestamp) =11);
-----------------

-- highest session score of each day

with cte as (select user_id,cast(login_timestamp as date) as session_date,sum(session_score) as score from logins group by user_id,cast(login_timestamp as date))
select *,row_number() over(partition by session_date order by score desc  ) rnk from cte --order by session_date 
qualify  row_number() over(partition by session_date order by score desc  )=1 order by session_date 

;
-------
with cte as (
select cast(min(login_timestamp) as date) as dates , cast(max(login_timestamp) as date)  max_dates from logins
union all 
select dateadd(day,1,dates) as dates,max_dates from cte where  dateadd(day,1,dates)<=max_dates 
)
select dates from cte where dates not in ( select distinct cast(login_timestamp as date) as dates from logins);


---------------------------------------------------------------------------------

--prob-68
-- Create the 'king' table
CREATE TABLE king (
    k_no INT PRIMARY KEY,
    king VARCHAR(50),
    house VARCHAR(50)
);

-- Create the 'battle' table
CREATE TABLE battle (
    battle_number INT PRIMARY KEY,
    name VARCHAR(100),
    attacker_king INT,
    defender_king INT,
    attacker_outcome INT,
    region VARCHAR(50),
    FOREIGN KEY (attacker_king) REFERENCES king(k_no),
    FOREIGN KEY (defender_king) REFERENCES king(k_no)
);

delete from king;
INSERT INTO king (k_no, king, house) VALUES
(1, 'Robb Stark', 'House Stark'),
(2, 'Joffrey Baratheon', 'House Lannister'),
(3, 'Stannis Baratheon', 'House Baratheon'),
(4, 'Balon Greyjoy', 'House Greyjoy'),
(5, 'Mace Tyrell', 'House Tyrell'),
(6, 'Doran Martell', 'House Martell');

delete from battle;
-- Insert data into the 'battle' table
INSERT INTO battle (battle_number, name, attacker_king, defender_king, attacker_outcome, region) VALUES
(1, 'Battle of Oxcross', 1, 2, 1, 'The North'),
(2, 'Battle of Blackwater', 3, 4, 0, 'The North'),
(3, 'Battle of the Fords', 1, 5, 1, 'The Reach'),
(4, 'Battle of the Green Fork', 2, 6, 0, 'The Reach'),
(5, 'Battle of the Ruby Ford', 1, 3, 1, 'The Riverlands'),
(6, 'Battle of the Golden Tooth', 2, 1, 0, 'The North'),
(7, 'Battle of Riverrun', 3, 4, 1, 'The Riverlands'),
(8, 'Battle of Riverrun', 1, 3, 0, 'The Riverlands');
--for each region find house which has won maximum no of battles. display region, house and no of wins
select * from battle;
select * from king;

with cte  as (select attacker_king as k_no,region from battle where attacker_outcome=1
union all
select defender_king,region from battle where attacker_outcome=0
), cte1 as (
select region ,house,count(*) as wins, rank() over(partition by region order by count(*) desc) as rnk from cte c join king k on c.k_no=k.k_no  group by region,house)
select * from cte1 where rnk =1
;

---
with cte1 as (
select region ,house,count(*) as wins, rank() over(partition by region order by count(*) desc) as rnk from battle b join king k on k.k_no=case when attacker_outcome=1 then attacker_king else defender_king end  group by region,house)
select * from cte1 where rnk =1
;


-------------------------------------------------------------------------------------------------------------

--prob-67




CREATE TABLE Submissions (
    submission_date DATE,
    submission_id INT PRIMARY KEY,
    hacker_id INT,
    score INT
);

INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES
('2016-03-01', 8494, 20703, 0),
('2016-03-01', 22403, 53473, 15),
('2016-03-01', 23965, 79722, 60),
('2016-03-01', 30173, 36396, 70),
('2016-03-02', 34928, 20703, 0),
('2016-03-02', 38740, 15758, 60),
('2016-03-02', 42769, 79722, 25),
('2016-03-02', 44364, 79722, 60),
('2016-03-03', 45440, 20703, 0),
('2016-03-03', 49050, 36396, 70),
('2016-03-03', 50273, 79722, 5),
('2016-03-04', 50344, 20703, 0),
('2016-03-04', 51360, 44065, 90),
('2016-03-04', 54404, 53473, 65),
('2016-03-04', 61533, 79722, 15),
('2016-03-05', 72852, 20703, 0),
('2016-03-05', 74546, 38289, 0),
('2016-03-05', 76487, 62529, 0),
('2016-03-05', 82439, 36396, 10),
('2016-03-05', 90006, 36396, 40),
('2016-03-06', 90404, 20703, 0);


with cte as (
select submission_date, hacker_id, count(*) as total_submission
,dense_rank() over (order by submission_date) as day_number
 from submissions
 group by submission_date, hacker_id
 )
 ,cte2 as (
 select * , count(*) over (partition by hacker_id order by submission_date) as cnt_till_date,
 case when day_number = count(*) over (partition by hacker_id order by submission_date) then 1 else 0 end as unique_cnt
 from cte
 order by submission_date
 )
 ,cte3 as (
 select submission_date, total_unique_cnt, hacker_id from 
 
 (select *, sum(unique_cnt) over (partition by submission_date) as total_unique_cnt,
 rank() over (partition by submission_date order by total_submission desc, hacker_id) as rnk
 from cte2 ) as x
 
 where rnk = 1
 )
 select * from cte3
;
------------------------------------------------------------------------------------------------------------

SELECT LAST_DAY(cast('1997-02-10' as date), 'MONTH') AS last_day_of_month;