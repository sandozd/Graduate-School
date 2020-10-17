-- SQL project 1 
-- 1 Char(length)- fixed string of LENGTH characters: 0-225
-- 2 Varchar (length)- A variable length string of LENGTH characters: 0-65,535
-- 3 Int- 4 byte positive integer (-2,147,483,648 – 2,147,483,647)
-- 4 Unsigned Int – A 4 byte positive integer (0 – 4,294,967,295)
-- 5 Float (m,d)- floating point number. M is total digits, D is digits to the right of the decimal point field, rounded values
-- NOT NULL would be the entry following 
-- Write a query to select all of the columns and rows from the departments table.
Select * from departments ;
-- Write a query to select employee number, first name, and last name.
Select emp_no as 'Employee Number',
	last_name as 'Last Name',
    first_name as 'First Name'
	from employees;
-- Write a query to select employee’s names and ages.  Age should be calculated in years.
Select emp_no as 'Employee ID' ,
	concat(last_name,',',first_name) as 'Employee Name' ,
    timestampdiff(year,birth_date,curdate()) as 'Age in Years'
    from employees;
-- Write a query to return the current date in the format mm/dd/yyyy.
Select date_format(curdate(),'%d of %M, %Y') ;
-- Write a query that returns the number of days since July 4th, 2016.
Select datediff(curdate(),'2016-07-04') as 'Days elapsed since July 4th, 2016';

--
-- For the queries below, remember that a “current” record is defined as one having ‘9999-01-01’ in the to_date field. 
-- Write a query that shows the number of rows in the employees table. (10pts)
desc employees ;
-- Write a query that shows all of the salary history of employee # 10911  Casley Shay.  
	-- Columns should include salary (##,###.##), effective date (Month dd, Year) and end date (Month dd, Year). (10pts)
select emp_no as 'Employee Number',
       format(salary,2) as 'Annual Salary',
       format(salary/52,2) as 'Weekly Salary',
       from_date as 'Effective Date',
       to_date as 'End Date',
  from salaries
  where emp_no = 10911;	
-- Write a query that shows the current salary of employee #10607 Rosalyn Hambrick.  
	-- Columns should include salary (##,###) and effective date (mm/dd/yy). (10pts)
select emp_no as 'Employee Number',
       format(salary,2) as 'Annual Salary',
       format(salary/52,2) as 'Weekly Salary',
       from_date as 'Effective Date',
       to_date as 'End Date'
  from salaries;
  where emp_no = 10607 ,
  and to_date = 9999;
-- Write a query that returns the 1st 4 characters of an employee’s last name in all upper case 
	-- for any employees whose last name starts with A through H. (15pts)
select upper(substring_index(last_name,',',-1)) as 'First Four Characters' ,
  from employees
  where last_name = 'A-H' ;
