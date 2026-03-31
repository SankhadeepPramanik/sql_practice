CREATE TABLE my_table (
 p_Key INT,
 Value VARCHAR(5)
);

INSERT INTO my_table (p_Key, Value) VALUES
(1, 'A'),
(1, 'B'),
(1, 'B'),
(1, 'A'),
(2, 'C'),
(2, 'B'),
(2, 'B'),
(3, 'D'),
(3, 'A'),
(3, 'D');

select * from my_table;
-- from pyspark.sql import functions as F

-- # Assuming df is your input DataFrame with columns: p_key, value

-- # Step 1: aggregate values per key
-- df_agg = (
--     df
--     .groupBy("p_key")
--     .agg(
--         F.concat_ws(",", F.collect_list("value")).alias("aggr")
--     )
-- )

-- # Step 2: reverse the aggregated string
-- df_palindrome = (
--     df_agg
--     .withColumn("rev_aggr", F.reverse(F.col("aggr")))
--     .filter(F.col("aggr") == F.col("rev_aggr"))
--     .select(F.col("p_key").alias("Palindrome_keys"))
-- )

-- df_palindrome.show(truncate=False)

with cte1 as (
select p_key, listagg(value, ',') as aggr, reverse(listagg(value, ',')) as rev_aggr from my_table group by p_key order by p_key
)
select p_key as Palindrome_keys from cte1 where aggr = rev_aggr;

WITH cte AS (
    SELECT
        p_key,
        value,
        ROW_NUMBER() OVER (order by (select null)) AS rn
    FROM my_table
),
cte2 AS (
    SELECT
        p_key,
        value,
        rn,
        ROW_NUMBER() OVER (PARTITION BY p_key ORDER BY rn ASC)  AS rn_asc,
        ROW_NUMBER() OVER (PARTITION BY p_key ORDER BY rn DESC) AS rn_desc,
        COUNT(*) OVER (PARTITION BY p_key) AS cnt
    FROM cte
)
SELECT
    a.p_key
FROM cte2 a
JOIN cte2 b
    ON a.rn_asc = b.rn_desc
   AND a.p_key = b.p_key
   AND a.value = b.value
GROUP BY a.p_key
HAVING COUNT(a.value) = MAX(a.cnt);


-------------------------------------------------------------------------------------------------------------------------------
--q2

-- Create table
CREATE TABLE elements (
 element VARCHAR(1)
);

-- Insert data
INSERT INTO elements (element) VALUES
('A'),
('B'),
('B'),
('A'),
('A'),
('A'),
('B'),
('C'),
('D'),
('C'),
('C'),
('C'),
('C');
select * from elements;

with cte as (select *,row_number() over(order by (select null)) as rnk from elements)
,cte1 as(select *,row_number() over(partition by element order by rnk) rnk1,rnk-row_number() over(partition by element order by rnk) as flag from cte)
select element from cte1 group by element,flag having count(flag)>=3 ;


----------------------------------------------------------------------------------------------------------------------------------
--q3
CREATE TABLE toppings (
 topping_name VARCHAR(50),
 ingredient_cost DECIMAL(5,2)
);

INSERT INTO toppings (topping_name, ingredient_cost) VALUES
('Pepperoni', 0.50),
('Sausage', 0.70),
('Chicken', 0.55),
('Extra Cheese', 0.40);
--Generate all possible 3-topping pizza combinations

-- Calculate the total cost of each combination

-- Sort the results

-- Highest total cost first

-- If costs are equal, toppings should be listed in alphabetical order

select * from toppings;

SELECT CONCAT(T1.TOPPING_NAME,',',T2.TOPPING_NAME,',',T3.TOPPING_NAME) AS PIZZA,(T1.INGREDIENT_COST+T2.INGREDIENT_COST+T3.INGREDIENT_COST) AS TOTAL_COST FROM TOPPINGS T1 
INNER JOIN TOPPINGS T2
ON T1.TOPPING_NAME < T2.TOPPING_NAME
INNER JOIN TOPPINGS T3
ON T2.TOPPING_NAME < T3.TOPPING_NAME
ORDER BY TOTAL_COST DESC;



------------------------------------------------------------------------------------------------------------------------

--q4
CREATE TABLE Trips (
 rider_id VARCHAR(5),
 pickup_ts TIMESTAMP,
 city VARCHAR(10)
);

INSERT INTO Trips (rider_id, pickup_ts, city) VALUES
('R1', '2025-01-02 10:00:00', 'NYC'),
('R1', '2025-01-03 09:15:00', 'NYC'),
('R2', '2025-01-04 14:20:00', 'SF'),
('R2', '2025-01-05 08:45:00', 'SF'),
('R3', '2025-01-06 11:10:00', 'BOS'),
('R3', '2025-01-07 13:30:00', 'NYC'),
('R4', '2025-01-03 07:40:00', 'NYC'),
('R4', '2025-01-04 18:20:00', 'SF'),
('R5', '2025-01-05 10:10:00', 'BOS'),
('R5', '2025-01-06 16:50:00', 'NYC');

CREATE TABLE Verification (
 rider_id VARCHAR(5),
 verification_date DATE
);

INSERT INTO Verification (rider_id, verification_date) VALUES
('R1', '2025-01-01'),
('R2', '2025-01-02'),
('R3', '2025-01-03'),
('R4', '2025-01-02'),
('R5', '2025-01-04');

--For each rider, find their first trip after verification
WITH trips_after_verification AS (
    SELECT
        t.rider_id,
        t.pickup_ts,
        ROW_NUMBER() OVER (
            PARTITION BY t.rider_id
            ORDER BY t.pickup_ts
        ) AS rn
    FROM trips t
    JOIN verification v
        ON t.rider_id = v.rider_id
       AND t.pickup_ts >= v.verification_date
)
SELECT
    rider_id,
    pickup_ts AS first_trip_after_verification
FROM trips_after_verification
WHERE rn = 1;

--Find the rider(s) with the second-highest number of trips in each city
WITH city_trip_counts AS (
    SELECT
        city,
        rider_id,
        COUNT(*) AS trip_count
    FROM trips
    GROUP BY city, rider_id
),
ranked AS (
    SELECT *,
           DENSE_RANK() OVER (
               PARTITION BY city
               ORDER BY trip_count DESC
           ) AS rnk
    FROM city_trip_counts
)
SELECT
    city,
    rider_id,
    trip_count
FROM ranked
WHERE rnk = 2;

-----Classify riders based on time to first trip after verification

-- Buckets

-- Fast adopter → within 24 hours

-- Normal adopter → within 7 days

-- Slow adopter → after 7 days

-- No trip → no trip after verification
WITH first_trip AS (
    SELECT
        v.rider_id,
        v.verification_date,
        MIN(cast(t.pickup_ts as date)) AS first_trip_ts
    FROM verification v
    LEFT JOIN trips t
        ON v.rider_id = t.rider_id
       AND t.pickup_ts >= v.verification_date
    GROUP BY v.rider_id, v.verification_date
)
SELECT
    rider_id,
    CASE
        WHEN first_trip_ts IS NULL THEN 'No trip'
        WHEN first_trip_ts <= verification_date + INTERVAL '1 DAY'
            THEN 'Fast adopter'
        WHEN first_trip_ts <= verification_date + INTERVAL '7 DAY'
            THEN 'Normal adopter'
        ELSE 'Slow adopter'
    END AS adopter_type
FROM first_trip;







-------------------------------------------------------------------------------------------------------------------------------------------q5
CREATE TABLE employee_sales (
 EmployeeID INT,
 EmployeeName VARCHAR(50),
 Department VARCHAR(50),
 ManagerID INT,
 HireDate DATE,
 MonthlySalary INT,
 SalesAmount INT,
 Month DATE
 );
 INSERT INTO employee_sales (EmployeeID, EmployeeName, Department, ManagerID, HireDate, MonthlySalary, SalesAmount, Month) VALUES
 (1, 'Alice', 'Sales', 101, '2020-01-01', 90000, 150000, '2025-01-01'),
 (1, 'Alice', 'Sales', 101, '2020-01-01', 90000, 200000, '2025-02-01'),
 (2, 'Bob', 'Sales', 101, '2021-03-15', 85000, 100000, '2025-01-01'),
 (2, 'Bob', 'Sales', 101, '2021-03-15', 85000, 120000, '2025-02-01'),
 (3, 'Carol', 'HR', 102, '2019-07-10', 95000, 0, '2025-01-01'),
 (4, 'David', 'HR', 102, '2020-06-25', 87000, 0, '2025-02-01'),
 (5, 'Evan', 'IT', 103, '2022-05-05', 80000, 60000, '2025-01-01'),
 (5, 'Evan', 'IT', 103, '2022-05-05', 80000, 75000, '2025-02-01');

 select * from employee_sales;
-- Total Sales & Average Monthly Sales (per employee)
SELECT
    EmployeeID,
    EmployeeName,
    Department,
    SUM(SalesAmount) AS TotalSales,
    AVG(SalesAmount) AS AvgMonthlySales
FROM Employee_Sales
GROUP BY EmployeeID, EmployeeName, Department;
--Rank Employees Within Each Department (by Total Sales)
WITH EmpSales AS (
    SELECT
        EmployeeID,
        EmployeeName,
        Department,
        SUM(SalesAmount) AS TotalSales
    FROM Employee_Sales
    GROUP BY EmployeeID, EmployeeName, Department
)
SELECT *,
       RANK() OVER (PARTITION BY Department ORDER BY TotalSales DESC) AS DeptRank
FROM EmpSales;
--Running Total of Sales per Department (Ordered by Total Sales)
WITH DeptEmpSales AS (
    SELECT
        Department,
        EmployeeName,
        SUM(SalesAmount) AS TotalSales
    FROM Employee_Sales
    GROUP BY Department, EmployeeName
)
SELECT
    Department,
    EmployeeName,
    TotalSales,
    SUM(TotalSales) OVER (
        PARTITION BY Department
        ORDER BY TotalSales DESC
        ROWS between UNBOUNDED PRECEDING and CURRENT Row
    ) AS RunningDeptSales
FROM DeptEmpSales;
--4️ Month-Over-Month (MoM) Sales Comparison

SELECT
*,
    LAG(SalesAmount,1,salesamount) OVER (
        PARTITION BY EmployeeID
        ORDER BY Month
    ) AS PreviousMonthSales,
    SalesAmount -
    LAG(SalesAmount,1,salesamount) OVER (
        PARTITION BY EmployeeID
        ORDER BY Month
    ) AS SalesDifference
FROM employee_sales;

--5) Show only those departments whose total sales exceed ₹100,000. Classify employees as:
-- Top Performer total sales > department average
-- - Below Average
WITH emp_sales AS (
    SELECT
        EmployeeID,
        EmployeeName,
        Department,
        SUM(SalesAmount) AS TotalSales
    FROM employee_sales
    GROUP BY EmployeeID, EmployeeName, Department
),
dept_avg AS (
    SELECT
        Department,
        AVG(TotalSales) AS DeptAvgSales,
        SUM(TotalSales) AS DeptTotalSales
    FROM emp_sales
    GROUP BY Department
)
SELECT
    e.EmployeeID,
    e.EmployeeName,
    e.Department,
    e.TotalSales,
    d.DeptAvgSales,
    CASE
        WHEN e.TotalSales > d.DeptAvgSales THEN 'Top Performer'
        ELSE 'Below Average'
    END AS Performance
FROM emp_sales e
JOIN dept_avg d
    ON e.Department = d.Department
WHERE d.DeptTotalSales > 100000;

-----------------------------------------------------------------------------------------------------------------------------
--q6
CREATE TABLE Users (
    users_id INT PRIMARY KEY,
    banned VARCHAR(3),
    role VARCHAR(10)
);

CREATE TABLE u_Trips (
    id INT PRIMARY KEY,
    client_id INT,
    driver_id INT,
    city_id INT,
    status VARCHAR(30),
    request_at DATE,
    FOREIGN KEY (client_id) REFERENCES Users(users_id),
    FOREIGN KEY (driver_id) REFERENCES Users(users_id)
);
INSERT INTO Users (users_id, banned, role) VALUES
(1, 'No', 'client'),
(2, 'Yes', 'client'),
(3, 'No', 'client'),
(4, 'No', 'client'),
(10, 'No', 'driver'),
(11, 'No', 'driver'),
(12, 'No', 'driver'),
(13, 'No', 'driver');

INSERT INTO u_trips (id, client_id, driver_id, city_id, status, request_at) VALUES
(1, 1, 10, 1, 'completed', '2013-10-01'),
(2, 2, 11, 1, 'cancelled_by_driver', '2013-10-01'),
(3, 3, 12, 6, 'completed', '2013-10-01'),
(4, 4, 13, 6, 'cancelled_by_client', '2013-10-01'),
(5, 1, 10, 1, 'completed', '2013-10-02'),
(6, 2, 11, 6, 'completed', '2013-10-02'),
(7, 3, 12, 6, 'completed', '2013-10-02'),
(8, 2, 12, 12, 'completed', '2013-10-03'),
(9, 3, 10, 12, 'completed', '2013-10-03'),
(10, 4, 13, 12, 'cancelled_by_driver', '2013-10-03'),
(11, 4, 13, 12, 'cancelled_by_driver', '2013-10-04');

select * from users;
select * from u_trips;

with cte as (select * from u_trips where client_id not in (select users_id from users where banned='Yes' and role='client') and driver_id not in  (select users_id from users where banned='Yes' and role='client')
)
select request_at,count(*),sum(case when status!='completed' then 1 else 0 end) as cancel_rate,sum(case when status!='completed' then 1 else 0 end)*1.0/count(*) as rate from cte 
WHERE request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY request_at;

SELECT
    t.request_at AS Day,
    ROUND(
        SUM(
            CASE 
                WHEN t.status IN ('cancelled_by_client', 'cancelled_by_driver')
                THEN 1 ELSE 0
            END
        ) * 1.0 / COUNT(*),
        2
    ) AS "Cancellation Rate"
FROM u_Trips t
JOIN Users c
    ON t.client_id = c.users_id
    AND c.banned = 'No'
    AND c.role = 'client'
JOIN Users d
    ON t.driver_id = d.users_id
    AND d.banned = 'No'
    AND d.role = 'driver'
WHERE t.request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY t.request_at
ORDER BY t.request_at;
--------------------------------------------------------------------------------------------------------------------------
--q7
--find the number of return calls that were done by cust care (1800) within 30 minutes of the missed call.
CREATE TABLE Calls (
    from_number INT,
    to_number INT,
    starttime TIMESTAMP,
    endtime TIMESTAMP
);
INSERT INTO Calls VALUES
(100, 1800, '2019-08-11 18:40:56', '2019-08-11 18:40:56'),
(1800, 100, '2019-08-11 18:55:56', '2019-08-11 18:57:56'),

(200, 1800, '2019-08-11 19:30:56', '2019-08-11 19:30:56'),
(1800, 200, '2019-08-11 20:05:56', '2019-08-11 20:10:56'),

(300, 1800, '2019-08-11 21:00:56', '2019-08-11 21:00:56'),
(1800, 300, '2019-08-11 21:20:56', '2019-08-11 21:25:56'),

(400, 1800, '2019-08-12 07:00:56', '2019-08-12 07:00:56'),
(500, 1800, '2019-08-12 08:00:56', '2019-08-12 08:05:56');

with missed_call as (
select * from calls where to_number=1800 and starttime=endtime
),return_call as (
select * from calls where from_number=1800 and starttime<>endtime

)
select * from return_call c join missed_call m on c.to_number=m.from_number and  datediff('minutes',m.endtime,c.starttime) <= 30;

;
SELECT
    r.from_number,
    r.to_number,
    r.starttime,
    r.endtime,m.*
FROM Calls m
JOIN Calls r
    ON r.from_number = 1800
   AND r.to_number = m.from_number
   AND r.starttime BETWEEN m.starttime
                       AND m.starttime + INTERVAL '30 minute'
WHERE m.to_number = 1800
  AND m.starttime = m.endtime;
  
select c2.*,c1.*
from Calls c1
inner join Calls c2
on c1.starttime = c1.endtime
and c1.from_number = c2.to_number and c1.to_number = c2.from_number
and datediff('minutes',c1.endtime,c2.starttime) <= 30;

---------------------------------------------------------------------------------------------------------------------------------------
--q8
CREATE TABLE attendance (
 student_id INT,
 attendance_date DATE,
 status VARCHAR(10)
);
INSERT INTO attendance (student_id, attendance_date, status) VALUES
(101, '2025-01-01', 'Absent'),
(101, '2025-01-02', 'Absent'),
(101, '2025-01-03', 'Present'),
(101, '2025-01-04', 'Absent'),
(101, '2025-01-05', 'Absent'),
(101, '2025-01-06', 'Absent'),
(101, '2025-01-07', 'Present'),
(102, '2025-01-01', 'Present'),
(102, '2025-01-02', 'Absent'),
(102, '2025-01-03', 'Absent'),
(102, '2025-01-04', 'Present');
with cte as(select *,row_number() over(partition by student_id order by attendance_date) as rnk,dateadd(day,-row_number() over(partition by student_id order by attendance_date),attendance_date) flag from attendance where status='Absent')
select student_id,count(flag) as consecutive_ab from cte group by student_id,flag order by student_id;
--------------------------------------------------------------------------------------------------------------------------------
--q9
CREATE TABLE bookings (
 Booking_ID INT,
 User_ID INT,
 Booking_Date DATE,
 Booking_Type VARCHAR(20)
);

INSERT INTO bookings VALUES
(101, 1, '2024-01-05', 'Flight'),
(102, 1, '2024-02-10', 'Hotel'),
(111, 1, '2024-03-07', 'Flight'),
(103, 2, '2024-01-02', 'Hotel'),
(104, 2, '2024-03-01', 'Cab'),
(140, 2, '2024-03-02', 'Cab'),
(105, 3, '2024-01-15', 'Cab'),
(106, 3, '2024-02-20', 'Hotel'),
(107, 4, '2024-01-01', 'Hotel'),
(108, 4, '2024-05-01', 'Flight');

with cte  as (select user_id,booking_type,count(*) as cnt  from bookings group by user_id,booking_type)
,cte1 as (select * from cte qualify dense_rank() over(partition by user_id order by cnt desc)=1 order by user_id)
select user_id,listagg(booking_type,' | ') within group(order by booking_type) from cte1 group by user_id
;
with cte as (select *,min(booking_date) over(partition by user_id) as min_date from bookings)
select * from cte where booking_date=min_date and booking_type='Hotel';

-----------------------------------------------------------------------------------------------------------------------------
--q10
CREATE TABLE user_events (
 User_ID VARCHAR(10),
 Event_Time TIMESTAMP
);

INSERT INTO user_events (User_ID, Event_Time) VALUES
('A', '2024-01-01 10:00'),
('A', '2024-01-01 10:20'),
('A', '2024-01-01 11:05'),
('A', '2024-01-01 11:25'),
('A', '2024-01-01 12:10'),
('B', '2024-01-02 09:00'),
('B', '2024-01-02 09:15'),
('B', '2024-01-02 10:10'),
('B', '2024-01-02 10:20'),
('B', '2024-01-02 11:00');

WITH ordered_events AS (
    SELECT
        user_id,
        event_time,
        LAG(event_time) OVER (
            PARTITION BY user_id
            ORDER BY event_time
        ) AS prev_event_time
    FROM user_events
)
 ,session_flags AS (
    SELECT
        user_id,
        event_time,prev_event_time,
        CASE
            WHEN prev_event_time IS NULL THEN 1
            WHEN event_time > prev_event_time + INTERVAL '30 minute' THEN 1
            ELSE 0
        END AS is_new_session
    FROM ordered_events
)
SELECT
    user_id,
    event_time,
    SUM(is_new_session) OVER (
        PARTITION BY user_id
        ORDER BY event_time
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS session_id
FROM session_flags
ORDER BY user_id, event_time;
---------------------------------------------------------------------------------------------------------------------
--q11

CREATE TABLE Products (
 User_ID INT,
 Prod_Name VARCHAR(50)
);

INSERT INTO Products (User_ID, Prod_Name) VALUES
(111, 'Apple'),
(111, 'Banana'),
(112, 'Apple'),
(113, 'Apple'),
(113, 'Orange'),
(114, 'Apple'),
(114, 'Banana'),
(114, 'Orange');


--Return users who:

-- Bought Apple
-- Bought Banana
-- ❌ Bought nothing else
-- So the set of products per user = {Apple, Banana}
SELECT
 user_Id
FROM products
WHERE prod_name IN ('Apple', 'Banana')
GROUP BY user_Id
HAVING COUNT(DISTINCT prod_name) = 2; --not correct 

with cte1 as (
select User_ID, listagg(Prod_Name, '|') as agg from Products group by User_ID
)
select distinct user_id from cte1 where agg in ('Apple|Banana', 'Banana|Apple');


(SELECT USER_ID FROM Products WHERE PROD_NAME = 'Banana'
intersect 
SELECT USER_ID FROM Products WHERE PROD_NAME = 'Apple')
EXCEPT
SELECT USER_ID FROM Products WHERE PROD_NAME NOT IN('Apple','Banana');
------------------------------------------------------------------------------------------------------------------------
--q12
CREATE TABLE sample_data (
 Row_ID INT,
 A VARCHAR(10),
 B VARCHAR(10),
 C VARCHAR(10),
 D VARCHAR(10)
);

INSERT INTO sample_data (Row_ID, A, B, C, D) VALUES
(1, NULL, 'b', 'c', NULL),
(2, 'a', NULL, 'c', 'd'),
(3, 'a', NULL, NULL, 'd'),
(4, 'a', NULL, NULL, 'd'),
(5, 'a', 'b', 'c', 'd');
--Return row_id where ANY TWO columns are NULL

WITH CTE AS 
(
SELECT ROW_ID,COLUMN_NAME,VALUE FROM SAMPLE_DATA
UNPIVOT INCLUDE NULLS
(
 VALUE FOR COLUMN_NAME IN(A,B,C,D)
)
)
SELECT ROW_ID FROM CTE
WHERE VALUE IS NULL
GROUP BY ROW_ID
HAVING COUNT(ROW_ID) = 2
;
--pyspark
cols_to_check = [c for c in df.columns if c != "Row_ID"]

df_with_nulls = (
 df.withColumn(
 "null_count",
 sum(F.when(F.col(c).isNull(), 1).otherwise(0) for c in cols_to_check)
 )
 .filter(F.col("null_count") == 2)
 .select("Row_ID") 
)

cols = ["A", "B", "C", "D"]  # can be programmatically generated

result = (
    df
    .withColumn("col_values", F.array(*cols))
    .withColumn(
        "null_count",
        F.size(F.expr("filter(col_values, x -> x IS NULL)"))
    )
    .filter(F.col("null_count") == 2)
    .select("row_id")
)


-----------------------------------------------------------------------------------------------------------------------------
--q13

CREATE TABLE Friends (
 PersonName VARCHAR(50),
 FriendName VARCHAR(50)
);
INSERT INTO Friends (PersonName, FriendName) VALUES
('Alice', 'John'),
('John', 'Emma'),
('Emma', 'Alice'),
('David', 'Sarah'),
('Sarah', 'Alice');

--Task: Write a SQL query to find the person having three or more friends.

SELECT name AS PersonName
FROM (
 SELECT PersonName AS name, FriendName AS friend FROM Friends
 UNION
 SELECT FriendName AS name, PersonName AS friend FROM Friends
) AS AllConnections
GROUP BY name
HAVING COUNT(DISTINCT friend) >= 3;



---------------------------------------------------------------------------------------------------------------------------

--q14

CREATE TABLE subscriptions (
 customer_id INT,
 subscription_id INT,
 start_date DATE,
 end_date DATE
);

INSERT INTO subscriptions VALUES
(1, 101, '2024-01-01', '2024-03-31'),
(1, 102, '2024-03-15', '2024-05-30'),
(1, 103, '2024-06-01', '2024-08-01'),
(2, 201, '2024-01-10', '2024-02-10'),
(2, 202, '2024-02-11', '2024-03-10');

with cte as (select *,lead(start_date) over(partition by customer_id order by start_date) as next_start,lead(subscription_id) over(partition by customer_id order by start_date) as next_sub_id from subscriptions)
select * from cte where next_start between start_date and end_date;

SELECT
    s1.customer_id,
    s1.subscription_id AS subscription_a,
    s2.subscription_id AS subscription_b
FROM subscriptions s1
JOIN subscriptions s2
    ON s1.customer_id = s2.customer_id
   AND s1.subscription_id < s2.subscription_id  -- avoid duplicates and self-join
   AND s1.start_date <= s2.end_date
   AND s1.end_date >= s2.start_date
ORDER BY s1.customer_id, s1.subscription_id;

---------------------------------------------------------------------------------------------------------------------------------------
--q15
CREATE TABLE numbers (
    num INT
);
INSERT INTO numbers (num) VALUES
(23421),
(1023),
(42),
(9);


WITH RECURSIVE cte AS (
 
 SELECT 
 num,
 num % 10 AS digit,
 round(num / 10,0) AS rest
 FROM numbers

 UNION ALL

 SELECT
 num,
 rest % 10,
 round(rest / 10,0)
 FROM cte
 WHERE rest > 0
)
SELECT num,
 sum(digit) AS sum_of_digit
FROM cte
GROUP BY num
ORDER BY num;

WITH cte AS (
 SELECT num as numbers, 1 AS n
 FROM numbers
)
,r_cte as(
SELECT
 numbers,
 substr(numbers, n, 1) AS digits,n from cte
union all 
SELECT numbers,substr(numbers, n+1, 1) AS digits,n+1
FROM r_cte
where n+1 <= LENGTH(numbers)
)
Select numbers, sum(digits) as sum_of_digits
from r_cte 
group by numbers
order by numbers desc;

-------------------------------------------------------------------------------------------------------------------------
--q16
CREATE TABLE A (
    FruitID INT,
    Fruit VARCHAR(50)
);

CREATE TABLE B (
    FruitID INT,
    Fruit VARCHAR(50)
);

INSERT INTO A VALUES (1, 'Apple'), (2, 'Mango'), (3, 'Orange');
INSERT INTO B VALUES (2, 'Mango'), (3, 'Orange'), (4, 'Guava');

SELECT
    CASE 
        WHEN A.FruitID IS NULL THEN 'tab2' 
        ELSE 'tab1' 
    END AS tabl,
    COALESCE(A.FruitID, B.FruitID) AS FruitID,
    COALESCE(A.Fruit, B.Fruit) AS Fruit
FROM A
FULL OUTER JOIN B
    ON A.FruitID = B.FruitID
WHERE A.FruitID IS NULL OR B.FruitID IS NULL;
=---------------------------------------------------------------------------------------------------------------------------

--q17
CREATE TABLE sales (
    store_id INT,
    sale_date DATE,
    total_sales INT
);

INSERT INTO sales VALUES
(102, '2024-01-01', 5000),
(102, '2024-01-02', NULL),
(102, '2024-01-03', 100),
(102, '2024-01-04', 3000),
(102, '2024-01-05', NULL);


With cte as
(
Select store_id,sale_date,total_sales,
sum(case when total_sales is not null then 1 else 0 end) over(partition by store_id order by sale_date range between unbounded preceding and current row) as bucket
From sales
)
Select store_id,sale_date,first_value(total_sales) over(partition by store_id ,bucket order by sale_date) as filled_sales from cte;




 ------------------------------------------------------------------------------------------

 CREATE TABLE sample_data1 (
    id VARCHAR,
    values_str VARCHAR
);

INSERT INTO sample_data1 VALUES
('A', '1;2'),
('B', '3;4');

select id,value from sample_data1, lateral split_to_table(values_str,';')

-------------------------------------------------------------------------------------------------------------------

CREATE TABLE sample_data_2 (
    Name VARCHAR(10),
    ID INT
);

INSERT INTO sample_data_2 VALUES
('A', 1),
('B', 2),
('C', 3),
('D', 4),
('E', 5);

with cte as (
select *,lag(id,1,id) over(order by id  )as prev,lead(id,1,id) over(order by id  )as next from sample_data_2
)
select *,case when id%2=1 then next else prev end new_val from cte;
------------------------------------------------------------------------------------------------------------------

CREATE TABLE baskets (
    Person VARCHAR(10),
    Basket VARCHAR(100)
);

INSERT INTO baskets VALUES
('A', 'Apple, Mango, Orange'),
('B', 'Apple'),
('C', 'Guava, Cherry'),
('D', 'Mango, Cherry, Orange');

WITH
fruit_from_basket AS (
SELECT 
 f.person,
 b.seq,
 b.VALUE AS fruit,
 'Yes' AS availability 
FROM
 baskets f,
 LATERAL SPLIT_TO_TABLE(F.basket ,',') b
)
,pivot_fruit_data AS (
SELECT
 *
FROM
 fruit_from_basket
PIVOT (MAX(availability) FOR fruit IN (ANY ORDER BY seq) DEFAULT ON NULL('No') )
)
SELECT * EXCLUDE seq
FROM pivot_fruit_data
ORDER BY person;


---------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE transactions (
    trans_id INT,
    merch_id INT,
    card_id INT,
    amount DECIMAL(10,2),
    timestamp TIMESTAMP
);

INSERT INTO transactions VALUES
(1, 101, 1, 100, '2024-01-01 12:00:00'),
(2, 101, 1, 100, '2024-01-01 12:08:00'),
(3, 101, 1, 100, '2024-01-01 12:28:00'),
(4, 102, 2, 300, '2024-01-01 12:00:00'),
(6, 102, 2, 400, '2024-01-01 14:00:00');
--We want to flag payments at the same merchant, with the same card and amount, within 10 minutes of a previous payment, but only count the repeated payments once.
WITH ranked AS (
    SELECT
        *,
        LAG(timestamp) OVER (PARTITION BY merch_id, card_id, amount ORDER BY timestamp) AS prev_ts
    FROM transactions
)
SELECT
    trans_id,
    merch_id,
    card_id,
    amount,
    timestamp,
    SUM(CASE 
            WHEN prev_ts IS NULL THEN 1
            WHEN TIMESTAMPDIFF(MINUTE, prev_ts, timestamp) > 10 THEN 1
            ELSE 0
        END
    ) OVER (PARTITION BY merch_id, card_id, amount ORDER BY timestamp ROWS UNBOUNDED PRECEDING) AS payment_count
FROM ranked
ORDER BY trans_id;



----------------------------------------------------------------------------------------------------------------------------
-- task is to find reactivated users per month: users who logged in in a month but did not log in in the previous month.

CREATE TABLE user_logins (
    UserID INT,
    LoginDate DATE
);

INSERT INTO user_logins VALUES
(123, '2022-02-22'),
(112, '2022-03-15'),
(245, '2022-03-28'),
(123, '2022-05-01'),
(725, '2022-05-25');

WITH logins AS (
SELECT
UserID,
EXTRACT (MONTH FROM LoginDate) AS month,
LoginDate
FROM user_logins
),
user_logins_ranked AS (
SELECT
UserID,
month,
LoginDate,
LAG(month) OVER (PARTITION BY UserID ORDER BY LoginDate) as prev_month
FROM logins
)
SELECT
month,
COUNT (UserID) as ReactivatedUsers
FROM user_logins_ranked
WHERE
(prev_month IS NULL OR prev_month <> month- 1)
GROUP BY month
ORDER BY month;