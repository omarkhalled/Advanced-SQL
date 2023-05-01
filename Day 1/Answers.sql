-- Advanced SQL Server Lab1 
/* Notes:
•	Attach ITI and adventureworks2012 DBs to Server
*/
-- Part-1: Use ITI DB

-- 1.	Display instructor Name and Department Name 
--      Note: display all the instructors if they are attached to a department or not

select Instructor.Ins_Name , Department.Dept_Name
from Instructor
left join Department
on Department.Dept_Id = Instructor.Dept_Id


--- 2.	Display student full name and the name of the course he is taking
--      For only courses which have a grade  

select Student.St_Fname + ' ' + Student.St_Lname as fullName , Course.Crs_Name
from Student
JOIN Stud_Course
on Stud_Course.St_Id = Student.St_Id
JOIN Course
on Course.Crs_Id = Stud_Course.Crs_Id
where Stud_Course.Grade IS NOT NULL

-- 3.	Display number of courses for each topic name

select Topic.Top_Name , count(*) as NumOfCourses
from Topic
join Course
on Topic.Top_Id = Course.Top_Id
group by Topic.Top_Name


-- 4.	Display max and min salary for instructors

select min(Instructor.Salary) as min_salary, max(Instructor.Salary) as max_salary
from Instructor

-- 5.	Display instructors who have salaries less than the average salary of all instructors.

select *
from Instructor
where Instructor.Salary < (select avg(Instructor.Salary) from Instructor )
order by Instructor.Salary

-- 6.	Display the Department name that contains the instructor who receives the minimum salary.

select Department.Dept_Id , Department.Dept_Name
from Instructor
join Department
on Department.Dept_Id = Instructor.Dept_Id
where Instructor.Salary = (select min(Instructor.Salary) from Instructor )


-- Part-2: Use AdventureWorks DB


-- 1.	Display the SalesOrderID, ShipDate of the SalesOrderHearder table (Sales schema) to designate SalesOrders that occurred within the period
--      ‘7/28/2008’ and ‘7/29/2014’


select SalesOrderID , ShipDate
from AdventureWorks2012.Sales.SalesOrderHeader
where ShipDate between '2008-07-28' and '2014-07-29'

-- 2.	Display only Products with a StandardCost below $110.00 (show ProductID, Name only)


select Product.ProductID , Product.Name
from AdventureWorks2012.Production.Product
where StandardCost < 110.00

-- 3.	Display ProductID, Name if its weight is unknown

select ProductID
from AdventureWorks2012.Production.Product
where Weight is null

-- 4.	 Display all Products with a Silver, Black, or Red Color

select *
from AdventureWorks2012.Production.Product
where Color = 'Black' or Color = 'Silver' or Color = 'Red'

-- 5. Display any Product with a Name starting with the letter B

select *
from AdventureWorks2012.Production.Product
where Name like 'B%'

-- 6.	 Transfer the rowguid ,FirstName, SalesPerson from Customer table in a newly created table named [customer_Archive]

SELECT * INTO  AdventureWorks2012.Sales.Custome_archieve
from AdventureWorks2012.Sales.Customer


--Part-3:  Use Company_SD DB


-- 1.	Display the Department id, name and SSN and the name of its manager.


select Departments.Dnum , Departments.Dname , Employee.SSN ,  Employee.Fname as manager 
from Company_SD.dbo.Departments 
join Company_SD.dbo.Employee 
on Departments.MGRSSN = Employee.SSN

-- 2. Display the name of the departments and the name of the projects under its control.
select Departments.Dname , Project.Pname
from Company_SD.dbo.Departments
join Company_SD.dbo.Project
on Company_SD.dbo.Project.Dnum = Company_SD.dbo.Departments.Dnum

-- 3. display all the employees in department 30 whose salary from 1000 to 2000 LE monthly.
select *
from Company_SD.dbo.Employee
where Dno = 30 and salary between 1000 and 2000


-- 4.	Retrieve the names of all employees in department 10 who works more than or equal10 hours per week 
--		on "AL Rabwah" project.

select Fname , dno , Hours , Pname
from Company_SD.dbo.Employee
join Company_SD.dbo.Works_for
on Company_SD.dbo.Works_for.ESSn = Company_SD.dbo.Employee.SSN
join Company_SD.dbo.Project
on Company_SD.dbo.Project.Pname = 'AL Rabwah'
where Hours >= 10 and Dno = 10

-- 5.	Find the names of the employees who directly supervised with Kamel Mohamed.
select Fname +' '+ Lname as full_name
from Company_SD.dbo.Employee 
where Employee.Superssn = (
select b.SSN
from Company_SD.dbo.Employee a , Company_SD.dbo.Employee b
where a.SSN = b.Superssn and b.Fname = 'Kamel' and b.Lname = 'Mohamed')


-- 6.	Retrieve the names of all employees and the names of the projects
--		they are working on, sorted by the project name.


select Fname +' '+ Lname as full_name , Pname as project_name
from Company_SD.dbo.Employee
join Company_SD.dbo.Works_for
on Employee.SSN = Works_for.ESSn
join Company_SD.dbo.Project
on Company_SD.dbo.Project.Pnumber = Company_SD.dbo.Works_for.Pno
order by project_name


-- 7.	For each project located in Cairo City , 
--      find the project number, the controlling department name ,
--      the department manager last name ,address and birthdate

select Project.Pnumber , Project.Dnum , Lname , Bdate , Address
from Company_SD.dbo.Project
join Company_SD.dbo.Departments
on Project.Dnum = Departments.Dnum
join Company_SD.dbo.Employee 
on Employee.SSN = Departments.MGRSSN


--8.	Display All Data of the mangers
select * from Company_SD.dbo.Employee
where Company_SD.dbo.Employee.SSN in
(select a.SSN
from Company_SD.dbo.Employee a , Company_SD.dbo.Employee b
where a.SSN = b.Superssn)

select *
from  Company_SD.dbo.Employee
left join  Company_SD.dbo.Dependent
on Company_SD.dbo.Employee.SSN = Company_SD.dbo.Dependent.ESSN

--9.	Display All Employees data and the data of their dependents 
--      even if they have no dependents

select @@VERSION
select @@SERVERNAME
