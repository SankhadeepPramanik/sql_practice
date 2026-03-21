
CREATE TABLE transactions (
 Col1 VARCHAR(10),
 Col2 VARCHAR(10),
 Amount INT
);

INSERT INTO transactions (Col1, Col2, Amount) VALUES
('A', 'B', 100),
('B', 'A', 40),
('A', 'C', 30),
(NULL, 'A', 25),
('A', NULL, 30),
('C', 'A', 15);

-- Combine rows where (Col1, Col2) and (Col2, Col1) represent the same pair, summing their Amount.

-- ⚠ 𝐈𝐦𝐩𝐨𝐫𝐭𝐚𝐧𝐭 𝐑𝐮𝐥𝐞:
-- If NULL appears, treat it as unknown. NULL = NULL → UNKNOWN, so do not group NULLs together.

SELECT 
 CASE WHEN col1 < col2 THEN col1 ELSE col2 END AS col1,
 CASE WHEN col1 > col2 THEN col1 ELSE col2 END AS col2,
 SUM(amount) AS amount
FROM transactions
WHERE col1 IS NOT NULL AND col2 IS NOT NULL
GROUP BY 
 CASE WHEN col1 < col2 THEN col1 ELSE col2 END,
 CASE WHEN col1 > col2 THEN col1 ELSE col2 END
UNION ALL
SELECT 
 NULL AS col1,
 CASE 
 WHEN col1 IS NULL THEN col2 
 ELSE col1 
 END AS col2,
 amount
FROM transactions
WHERE col1 IS NULL OR col2 IS NULL;

output:
COL1	COL2	AMOUNT
A    	C	    45
A    	B	    140
NULL	A	    25
NULL	A	    30


CREATE TABLE Orders (
 UserID INT,
 ParentItem VARCHAR(50),
 ChildItem VARCHAR(50),
 UnitPrice INT,
 Quantity INT
);

INSERT INTO Orders (UserID, ParentItem, ChildItem, UnitPrice, Quantity) VALUES
(1, 'Computer', 'Monitor', 15000, 1),
(1, 'Computer', 'Keyboard', 2000, 1),
(1, 'Computer', 'Mouse', 1000, 1),
(1, 'Computer', 'CPU', 35000, 1),
(1, 'Computer', 'Speakers', 3000, 1),
(2, 'Mobile Phone', 'Charger', 1200, 1),
(2, 'Mobile Phone', 'Earphones', 2500, 1),
(2, 'Mobile Phone', 'Phone Case', 800, 1),
(1, NULL, 'Refrigerator', 45000, 1),
(3, NULL, 'Washing Machine', 38000, 1),
(2, NULL, 'Television', 55000, 1);


select * from Orders;


select userid, parentitem, sum(unitprice*quantity), MAX(Quantity) from orders where parentitem is not NULL  group by userid,parentitem 
union all
select userid, coalesce(parentitem,childitem), sum(unitprice*quantity), MAX(Quantity) from orders where parentitem is  NULL  group by userid, coalesce(parentitem,childitem) order by userid

output:
USERID	PARENTITEM	total_price	QUANTITY
1	Computer	56000	1
1	Refrigerator	45000	1
2	Mobile Phone	4500	1
2	Television	55000	1
3	Washing Machine	38000	1
