create  table date_dim as (
with recursive cte as (
SELECT 1 as id,to_date('01-01-1990','dd-mm-yyyy') as dt
union ALL
select id+1,dateadd(day,1,dt) from cte 
where dt<=to_date('31-12-2050','dd-mm-yyyy')
)
select  
dt as cal_date
,extract(year from dt) as cal_year
,DAYOFYEAR(dt)	as cal_year_day
,extract(quarter from dt) as cal_quarter
,extract(month from dt) as cal_month
,MONTHNAME(dt) as cal_month_name
,extract(day from dt) as cal_mon_day
,DAYNAME(dt) as cal_day_name
,DAYOFWEEK(dt)	cal_week_day
,WEEK(dt)	as cal_week
from cte);

create view timeframe_ymq as(
with cte as(
select  * from date_dim where cal_date=date_trunc(day,current_date())
)
,cal_dim as (
select c.*,t.cal_year as current_year
 from date_dim c cross join cte t  where c.cal_year between t.cal_year-5 and t.cal_year
 )
 select 
 'FY' as type_cal, current_year as timeframe
,min(case when cal_year=current_year then cal_date end) as ty_start_date
,max(case when cal_year=current_year then cal_date end) as ty_end_date
,min(case when cal_year=current_year-1 then cal_date end) as ly_start_date
,max(case when cal_year=current_year-1 then cal_date end) as ly_end_date
from cal_dim group by current_year
union all
 select 
 'QTR' as type_cal,cal_quarter 
,min(case when cal_year=current_year then cal_date end) as ty_start_date
,max(case when cal_year=current_year then cal_date end) as ty_end_date
,min(case when cal_year=current_year-1 then cal_date end) as ly_start_date
,max(case when cal_year=current_year-1 then cal_date end) as ly_end_date
from cal_dim group by cal_quarter
union all
 select 
 'MONTH' as type_cal,cal_month 
,min(case when cal_year=current_year then cal_date end) as ty_start_date
,max(case when cal_year=current_year then cal_date end) as ty_end_date
,min(case when cal_year=current_year-1 then cal_date end) as ly_start_date
,max(case when cal_year=current_year-1 then cal_date end) as ly_end_date
from cal_dim group by cal_month);

select * from timeframe_ymq;

---cuurrent quarter till todays date date
with cte as(
select  * from date_dim where cal_date=date_trunc(day,current_date())
)
,cal_dim as (
select c.*,t.cal_year as current_year, t.cal_quarter as current_quarter,t.cal_month as current_month,t.cal_year_day as current_day
 from date_dim c cross join cte t  where c.cal_year between t.cal_year-5 and t.cal_year
 )
 select 
 'FY' as type_cal, current_year as timeframe
,min(case when cal_year=current_year then cal_date end) as ty_start_date
,max(case when cal_year=current_year then cal_date end) as ty_end_date
,min(case when cal_year=current_year-1 then cal_date end) as ly_start_date
,max(case when cal_year=current_year-1 then cal_date end) as ly_end_date
from cal_dim group by current_year
union all
 select 
 'QTR' as type_cal,cal_quarter 
,min(case when cal_year=current_year then cal_date end) as ty_start_date
,max(case when cal_year=current_year then cal_date end) as ty_end_date
,min(case when cal_year=current_year-1 then cal_date end) as ly_start_date
,max(case when cal_year=current_year-1 then cal_date end) as ly_end_date
from cal_dim 
where cal_quarter=current_quarter 
group by cal_quarter
 