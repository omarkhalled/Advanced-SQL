
--                       SQLServer Lab2

--1.	Create the following schema and transfer the following tables to it 
--a.	Company Schema 
--i.		Department table (Programmatically)
--ii.		Project table (visually)
--b.	Human Resource Schema
--i.	    Employee table (Programmatically)



use Company_SD


create schema Company

alter schema Company transfer Departments

create schema Hr
alter schema Hr transfer Employee

-- Part 1:     Use ITI DB
use ITI

--  1.	Create a view tt displays student full name, 
--      course name if the hastudent has a grade more than 50.

create view clever_students
as
		select (Student.St_Fname + ' ' + Student.St_Lname) As Full_name ,Course.Crs_Name 
		from Student
		join Stud_Course
		on Stud_Course.St_Id = Student.St_Id
		join Course
		on Course.Crs_Id = Stud_Course.Crs_Id
		where Stud_Course.Grade > 50


select * from clever_students

Sp_helptext 'clever_students'

-- 2.	Create an Encrypted view that displays 
--      manager names and the topics they teach.

create view inscourse
as 

	select Instructor.Ins_Name , Course.Crs_Name
	from Instructor
	join Ins_Course
	on Instructor.Ins_Id = Ins_Course.Ins_Id
	join Course
	on Course.Crs_Id = Ins_Course.Crs_Id


alter view inscourse 
WITH ENCRYPTION
as
	select Instructor.Ins_Name , Course.Crs_Name
	from Instructor
	join Ins_Course
	on Instructor.Ins_Id = Ins_Course.Ins_Id
	join Course
	on Course.Crs_Id = Ins_Course.Crs_Id

select * from inscourse

-- 3.	Create a view that will display Instructor Name, Department Name 
--      for the ‘SD’ or ‘Java’ Department “use Schema binding” 
--      and describe what is the meaning of Schema Binding

create view sdjava 
WITH SCHEMABINDING
as
select Ins_Name,Dept_Name
from dbo.Instructor
join dbo.Department
on dbo.Instructor.Dept_Id = dbo.Department.Dept_Id
where Dept_Name = 'SD' OR Dept_Name = 'Java'


select * from Instructor

alter table Instructor alter column Ins_Name varchar(50)
-- We use SCHEMABINDING when we dont need 
-- any changes to be made for a table inside the view agains the schema definition



-- 4.	Create a view “V1” that displays student data for student 
--      who lives in Alex or Cairo.

--      Note: Prevent the users to run the following query
--      
--      Update V1 set st_address=’tanta’ Where st_address=’alex’.
create view v1 as
select * 
from Student
where St_Address = 'Alex' or St_Address = 'Cairo'
with check option

update v1 set St_Address = 'pp'
where St_Address = 'Alex'

create view v2 as
select * 
from Student
where St_Address = 'Alex'
with check option

update v2 set St_Address = 'tanta'
where St_Address = 'Cairo'

-- 6.	Create temporary table [Session based] on Company DB 
--      to save employee name and his today task.

use ITI
create table #temp_table
(
emp_name varchar(10),
day_task varchar(10)
)
--     Part 3: Use Company DB

-- 1.	Create a view that will display the project name 
--      and the number of employees work on it
use Company_SD

create view emp_per__pro
as
select Pname  , count(Employee.SSN) as num_emps
from Works_for
join Employee
on Works_for.ESSn = Employee.SSN
join Project
on Project.Pnumber = Works_for.Pno
group by Pname

select * from emp_per__pro

-- 2.	Create a view named  “v_count “ that will display
--      the project name and the number of hours for each one

create view  v_count
as
select Pname , sum(Hours) num_hours
from Works_for
join Employee
on Works_for.ESSn = Employee.SSN
join Project
on Project.Pnumber = Works_for.Pno
group by Pname 

select * from v_count

-- 3.	Create a view named   “v_D30” that will display employee number, 
--      project number, hours of the projects in department 30. updated

alter  view  v_D30
as
select Employee.SSN ,  Project.Pnumber , Works_for.Hours
from Works_for
join Employee
on Works_for.ESSn = Employee.SSN
join Project
on Project.Pnumber = Works_for.Pno
where Project.Dnum = 30


select * from v_D30


-- 4.	Create a view named ” v_project_500” that will display the emp no.
--     for the project 500,
--      use the previously created view  “v_D30”

create view v_project_500
as
select SSN , Pnumber
from v_D30
where Pnumber = 500

select * from v_project_500

-- 5.	Delete the views  “v_D30” and “v_count”

drop view v_D30 , v_count

-- 6.	Display the project name that contains 
--      the letter “c” Use the previous view created in Q#1

select *
from emp_per__pro
where  lower(Pname) like '%c%'

-- 7.	add new column Enter_Date in Works_for table and 
--      insert data in it then create view name “v_2021_check” 
--      that will display employee no., 
--      which must be from the first of January 
--      and the last of December 2021.
--      this view will be used to insert data so make sure 
--      that the coming new data matchs the condition
use Company_SD

alter table Works_for
add Enter_Date date

select * from Works_for

create view v_2021_check
as
select ESSn , Enter_Date
from Works_for
where Enter_Date between '2021-1-1' and '2021-12-31'

insert into v_2021_check
values (201,'2021-12-5')

-- Cannot insert the value NULL into column 'Pno', 
-- table 'Company_SD.dbo.Works_for'; column does not allow nulls.
-- INSERT fails.


-- 8.	Create Rule for Salary that is less than 2000 using rule.

create rule r1 as @x < 2000

sp_bindrule r1 , 'Employee.Salary'


-- 9.	Create a new user defined data type named
--      loc with the following Criteria:
--      •	nchar(2) 
--      •	default: NY 
--      •	create a rule for this Data type :values in 
--          (NY,DS,KW)) and associate it to the location column


sp_addtype loc , 'varchar(2)'

create rule r2 as @x in ('NY','DS','KW')
create default df as 'NY'
sp_bindrule r2 , loc
sp_bindefault df , loc

ALTER TABLE dbo.Employee
ADD Locations loc;

insert into  dbo.Employee
values ('d','s',554,null,null,null,null,null,null,'p')


