CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name NVARCHAR(100),
    DepartmentID INT,
    HireDate DATE,
    Salary DECIMAL(10, 2)
);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(100)
);

CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName NVARCHAR(100),
    StartDate DATE,
    EndDate DATE
);

CREATE TABLE EmployeeProjects (
    EmployeeID INT,
    ProjectID INT,
    HoursWorked INT,
    PRIMARY KEY (EmployeeID, ProjectID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance');

INSERT INTO Employees (EmployeeID, Name, DepartmentID, HireDate, Salary) VALUES
(101, 'Alice', 1, '2022-01-15', 60000.00),
(102, 'Bob', 2, '2021-06-20', 75000.00),
(103, 'Charlie', 3, '2020-03-01', 50000.00),
(104, 'Diana', 2, '2019-07-10', 80000.00),
(105, 'Eve', 1, '2023-02-25', 55000.00);

INSERT INTO Projects (ProjectID, ProjectName, StartDate, EndDate) VALUES
(201, 'Project Alpha', '2023-01-01', '2023-12-31'),
(202, 'Project Beta', '2022-05-15', NULL),
(203, 'Project Gamma', '2021-09-01', '2022-12-31');

INSERT INTO EmployeeProjects (EmployeeID, ProjectID, HoursWorked) VALUES
(101, 201, 120),
(102, 202, 200),
(103, 203, 150),
(104, 201, 100),
(105, 202, 180);

--Task 1
create table #RecentHires(
	EmployeeID INT,
	Name NVARCHAR(100),
	DepartmentName NVARCHAR(100),
	HireDate Date
);
insert into #RecentHires(EmployeeID,Name,DepartmentName,HireDate)
select
	e.EmployeeID,
	e.Name,
	d.DepartmentName,
	e.HireDate
from Employees e
join Departments d
on e.DepartmentID=d.DepartmentID
where e.HireDate >=DATEADD(Year,-2,GETDATE())
--last year da bittayam ishchi olinmaganligi uchun 2 yil oldingini oldim

select * from #RecentHires
drop table #RecentHires

--Task 2
create proc AssignEmployeeToProject
	@EmployeeID INT,
	@ProjectID INT,
	@HoursWorked INT
as
begin
	--Checking for Employee
	if not exists(select 1 from Employees where EmployeeID=@EmployeeID)
	begin
		print 'Employee does not exists';
		return;
	end
	--Checking for Project
	if not exists(select 1 from Projects where ProjectID=@ProjectID)
	begin
		print 'Project does not exists';
		return;
	end
	--Insert values into table
	insert into EmployeeProjects(EmployeeID,ProjectID,HoursWorked)
	values(@EmployeeID,@ProjectID,@HoursWorked);

	print 'Success'
end;

exec AssignEmployeeToProject 104,203,100

create view
ActiveProjects as
select 
	p.ProjectID,
	p.ProjectName,
	p.StartDate,
	count(ep.EmployeeID) as numOfEmp
from Projects p
left join EmployeeProjects ep
on p.ProjectID=ep.ProjectID
where p.EndDate is null
group by p.ProjectID, p.ProjectName, p.StartDate

select * from ActiveProjects

--Task 4
create proc CheckPerfectNumer
	@Num INT
as
begin
	declare @SumOfDivisors INT =0;
	with Divisors as(
		select num=1
		union all
		select num+1
		from divisors 
		where num+1<=@Num/2
	)
	select @SumOfDivisors=sum(num)
	from Divisors
	where @Num%num=0;

	if @SumOfDivisors=@Num
		print 'Perfect number'
	else
		print 'Not perfect number'
end;

exec CheckPerfectNumer 6
exec CheckPerfectNumer 28