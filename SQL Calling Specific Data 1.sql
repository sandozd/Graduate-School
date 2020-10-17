-- These queries use the Employees database.

-- Write a query that returns all of the female employees 
-- currently making less than 50,000 in the Customer Service department.  
-- Columns should include name, salary, and salary effective date (mm/dd/yyyy).; 
select 
    concat(employees.last_Name,', ',employees.first_Name) as 'Name',
    salaries.salary,
	date_format (salaries.from_date, '%m/%e/%Y') as 'Salary Effective Date'
    from salaries  
    left join employees 
    on employees.emp_no = salaries.emp_no
    left join dept_emp
    on employees.emp_no = dept_emp.emp_no
    where gender = 'F' and salaries.salary < 50000 and dept_emp.dept_no = 'd009';
    
		

-- write a query to return the maximum current salary in each department.  
-- Columns should include department name and salary.
select
	departments.dept_name as 'Department Name',
    format(max(salaries.salary),2) as 'Max Salary' 
    from salaries 
    left join  employees
    on employees.emp_no = salaries.emp_no
    left join dept_emp
    on dept_emp.emp_no = employees.emp_no
    left join departments
    on departments.dept_no = dept_emp.dept_no
		where salaries.to_date = '9999-01-01'
	group by departments.dept_name;
	

-- Write a query that shows the current head count in each department.  
-- The only columns should be department name and the head count. 

select 
	departments.dept_name as 'Department Name', 
    count(dept_emp.dept_no) as 'Head Count'
    from dept_emp
    left join departments
    on departments.dept_no = dept_emp.dept_no
	where dept_emp.to_date = '9999-01-01'
    group by dept_emp.dept_no;
    
    
-- Write a query that shows the current average salary in each department.  
-- Sort in Descending order by average salary.  Include the department and the average salary.  
select
	departments.dept_name as 'Department' ,
    format(avg(salaries.salary),2) as 'Average Salary' 
    from salaries
    left join  employees
    on employees.emp_no = salaries.emp_no
    left join dept_emp
    on dept_emp.emp_no = employees.emp_no
    left  join departments
    on departments.dept_no = dept_emp.dept_no
		where salaries.to_date = '9999-01-01'
    group by departments.dept_name
    order by salaries.salary DESC;
    

		

-- This query uses the Classic Models database

-- Find the total dollar amount ordered per customer for all customers.  
-- Display the customer name and the total dollar amount ordered. 
	-- Order by total amount in descending order. 

select
	customers.customerName as 'Customer', 
    sum(orderdetails.quantityOrdered * orderdetails.priceEach) as 'Total Ordered'
from customers 
left join orders
on orders.customerNumber = customers.customerNumber
join orderdetails
on orders.orderNumber = orderdetails.orderNumber
group by customers.customerName
order by sum(orderdetails.quantityOrdered * orderdetails.priceEach) DESC;


