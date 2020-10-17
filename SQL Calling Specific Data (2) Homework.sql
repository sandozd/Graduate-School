-- Create view is a DDL command (True or False). 
		-- TRUE
-- A view is a permanent structure of a schema until dropped (True or False).
		-- TRUE
-- A view stores data (True or False).
		-- FALSE

-- 15/15

-- 4 Find the total dollar amount ordered per customer for all customers.  
-- Display the customer name and the total dollar amount ordered.  
-- Order by total amount in descending order.  (10pts)
select
	customers.customerName as 'Customer', 
    Round (sum(orderdetails.quantityOrdered * orderdetails.priceEach),2 )as 'Total Ordered'
from customers 
left join orders
on orders.customerNumber = customers.customerNumber
join orderdetails
on orders.orderNumber = orderdetails.orderNumber
group by customers.customerName 
order by sum(orderdetails.quantityOrdered * orderdetails.priceEach) DESC;

-- not returning all customers 8/10
-- 5 Using subquery, find what employees report directly to the VP Sales?  
-- List their name and their job title.  (10pts)

Select 
concat(e.lastName,', ',e.firstName) as 'Employee Name',
e.jobtitle as 'Job Title'
from employees e
where e.reportsto =
	(select x.employeenumber
	from employees x 
    where x.jobtitle = 'VP Sales');
	
-- 10/10    
    
-- 6 Assuming a sales commission of 5% on every order, 
-- calculate the sales commission due for all employees.  
-- List the employee name and the sales commission they’re due. (15pts)
select
concat(firstName, ' ',lastName) AS 'Employee Name',
round(sum(quantityOrdered * priceEach)* .05, 2) AS 'Order Total'
from orderdetails od
left join orders o
on o.orderNumber = od.orderNumber
left join customers c
on c.customerNumber = o.customerNumber
left join employees e
on e.employeeNumber = c.salesRepEmployeeNumber
group by e.employeeNumber;

-- 15/15







-- 7 Create a list of customers and the amount they currently owe us.  
-- List the customer name and the amount due.  
-- Create views to track the total amount ordered and the total amount paid.  
-- Use these views to create your final query. (20pts) 
-- Important – do not format interim numeric results.  
-- If you need to round numbers use the round function.  
-- Don’t format your numbers until your final query.  
-- Having imbedded commas in numeric fields can cause math problems.

create view AmountDS AS
select
c.customerName,
sum(od.quantityOrdered*od.priceEach) as 'Amount On Order'
from orders o
left join orderdetails od
on o.orderNumber = od.orderNumber
left join customers c
on o.customerNumber = c.customerNumber
group by c.customerName;

create view paymentDS as
select
c.customerName,
p.amount as 'Amount Paid'
from customers c
left join payments p
on c.customerNumber = p.customerNumber
left join orders o
on o.customerNumber = c.customerNumber
group by c.customerName;

-- you're not aggregating payments if a customer has made more than one.
create table AmountOwedDS (
CustomerName varchar(255),
AmountOwed int,
Primary Key (CustomerName)
);

insert into AmountOwedDS (CustomerName, AmountOwed)
select
AmountDS.customerName,
AmountOnOrder - AmountPaid
from AmountDS
left join paymentDS
on AmountDS.customerName = paymentDS.customerName;

-- Syntax error on the above. Your column names don't exist (have spaces in the underlying views)
select
AmountDS.customerName,
format (AmountOnOrder - AmountPaid, 2) AS 'AmountDue'
from AmountDS
left join paymentDS
ON AmountDS.customerName = paymentDS.customerName;

-- couple of syntax errors and incorrect amounts calculated for the amount due.
-- also does not return all customers.
-- 10/20