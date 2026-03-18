/*
PROBLEM STATEMENT: Given tables represent the marks scored by engineering students.
Create a report to display the following results for each student.
  - Student_id, Student name
  - Total Percentage of all marks
  - Failed subjects (must be comma seperated values in case of multiple failed subjects)
  - Result (if percentage >= 70% then 'First Class', if >= 50% & <=70% then 'Second class', if <=50% then 'Third class' else 'Fail'.
  			The result should be Fail if a students fails in any subject irrespective of the percentage marks)
	
	*** The sequence of subjects in student_marks table match with the sequential id from subjects table.
	*** Students have the option to choose either 4 or 5 subjects only.
*/

drop table if exists student_marks;
drop table if exists students;
drop table if exists subjects;

create table students
(
	roll_no		varchar(20) primary key,
	name		varchar(30)		
);
insert into students values('2GR5CS011', 'Maryam');
insert into students values('2GR5CS012', 'Rose');
insert into students values('2GR5CS013', 'Alice');
insert into students values('2GR5CS014', 'Lilly');
insert into students values('2GR5CS015', 'Anna');
insert into students values('2GR5CS016', 'Zoya');


create table student_marks
(
	student_id		varchar(20) primary key references students(roll_no),
	subject1		int,
	subject2		int,
	subject3		int,
	subject4		int,
	subject5		int,
	subject6		int
);
insert into student_marks values('2GR5CS011', 75, NULL, 56, 69, 82, NULL);
insert into student_marks values('2GR5CS012', 57, 46, 32, 30, NULL, NULL);
insert into student_marks values('2GR5CS013', 40, 52, 56, NULL, 31, 40);
insert into student_marks values('2GR5CS014', 65, 73, NULL, 81, 33, 41);
insert into student_marks values('2GR5CS015', 98, NULL, 94, NULL, 90, 20);
insert into student_marks values('2GR5CS016', NULL, 98, 98, 81, 84, 89);


create table subjects
(
	id				varchar(20) primary key,
	name			varchar(30),
	pass_marks  	int  
);
insert into subjects values('S1', 'Mathematics', 40);
insert into subjects values('S2', 'Algorithms', 35);
insert into subjects values('S3', 'Computer Networks', 35);
insert into subjects values('S4', 'Data Structure', 40);
insert into subjects values('S5', 'Artificial Intelligence', 30);
insert into subjects values('S6', 'Object Oriented Programming', 35);


select * from students;
select * from student_marks;
select * from subjects;

with cte as(
select * from student_marks
unpivot(
marks for subject in ("SUBJECT1" as "S1","SUBJECT2" as "S2" ,"SUBJECT3" as "S3","SUBJECT4" as "S4","SUBJECT5" as "S5","SUBJECT6" as "S6")
))
,cte1 as (
select s.name,c.*,sub.name as subject_name,sub.pass_marks from cte c 
join students s on c.STUDENT_ID=s.ROLL_NO
join subjects sub on c.subject =sub.id)
,flag as(
select *, case when marks>=pass_marks then marks end pass_flag , case when marks<pass_marks then subject_name end fail_flag from cte1)
select student_id,name,round(avg(marks),2) as percent_of_marks, listagg(fail_flag,','),(case when max(fail_flag) is not NULL then 'fail' when avg(marks)>70 then 'first'when avg(marks)<=70 and avg(marks)>=50 then 'second' when avg(marks)<50 then 'third'  else 'fail' end) from flag group by student_id,name order by student_id




EXPECTED OUTPUT											
STUDENT_ID		NAME	PERCENTAGE_MARKS		FAILED_SUBJECTS				RESULT		
2GR5CS011		Maryam	70.5		-				First Class		
2GR5CS012		Rose	41.25		Computer Networks, Data Structure				Fail		
2GR5CS013		Alice	43.8		-				Third Class		
2GR5CS014		Lilly	58.6		-				Second Class		
2GR5CS015		Anna	75.5		Object Oriented Programming				Fail		
2GR5CS016		Zoya	90		-				First Class		
