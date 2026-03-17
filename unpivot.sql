
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




SELECT brand,count(*) as total,sum(case when winner=brand then 1 else 0 end) as win,count(*)-sum(case when winner=brand then 1 else 0 end)as  loss
FROM Delievry_partner
UNPIVOT (
    brand FOR brand_col IN (Brand_1, Brand_2, Brand_3)
)
group by brand order by brand;

BRAND	TOTAL	WIN	LOSS
A	      3	  1	  2
B	      3  	1  	2
C	      4  	0  	4
D	      2  	1  	1
E	      2  	1  	1
F	      1  	1  	0
