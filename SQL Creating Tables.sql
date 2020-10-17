Create Table Employee_Detail_1 (
	Emp_ID Integer Not Null PRIMARY key,
	FirstNameEmp Varchar(30) Not Null  ,
	LastNameEmp Varchar(30) Not Null 
);

Create Table Employee_Detail_2 (
	Emp_Id Integer NOT Null,
	LastNameEmp Varchar(30) Not Null Primary key,
	Prefix Varchar(4) Not Null,
	Suffix Varchar(4) Not Null,
    Gender enum ('M','F') ,
	foreign key (Emp_Id) references Employee_Detail_1 (Emp_Id) ON DELETE CASCADE
);

Create Table Employee_Address_1 (
	Emp_Id Integer NOT Null,
    EmpAddressLine1 Varchar(30) Not Null primary key,
    foreign key (Emp_Id) references Employee_Detail_1 (Emp_ID) ON DELETE CASCADE
); 
	
    Create Table Employee_Address_2 (
    Emp_ID Integer NOT null Primary key, 
    EmpAddressLine1 Varchar(30) Not Null,
    EmpAddressLine2 Varchar(30),
	City char(30) Not Null,
	State char(2) Not Null,
    Zip Integer (10) Not Null,
	foreign key (EmpAddressLine1)
);
	EmpAddressLine1 Varchar(30) Not Null Primary key, 
	EmpAddressLine2 Varchar(30) , 
	EmpAddressType enum ('House', 'Work', 'Other') NOT null, 
	City Varchar (30) Not Null,
    State Varchar (30) Not null, 
    Zip Integer (10)
	foreign key (Emp_Id) references Employee_Detail_1 (Emp_ID) ON DELETE CASCADE
);


Create Table Employee_Contact_1 (
    Emp_ID Integer (10) Not null Primary Key, 
    TelephoneType enum('Home', 'Work', 'Cell') Not Null,
    AreaCode Integer(3) Not Null,
	PhoneNumber Integer (7) Not Null,
	Extention Integer (4),
	foreign key (Contact_ID, PhoneNumber)
); 

Create table Employee_Contact_2 (
	Emp_ID Integer (10) Not null Primary Key,
    EmpEmailType enum('Home', 'Work', 'Other') Not Null, 
    EmpEmail Varchar (50) Not Null, 
    foreign key (Emp_ID, EmpEmail) 
); 
    
Create Table Employee_Emergency_Contact_Detail1 (
	Emp_ID Integer (10) Not null Primary Key,
	Contact_ID Integer (10) Not null,
    foreign key (Emp_ID, Contact_ID)
); 

Create Table Employee_Emergency_Contact_Detail2 (
	Contact_ID Integer (10) Not Null Primary Key,
    FirstNameContact Varchar(30) Not Null,
    LastNameContact Varchar (30) Not Null,
    Rel_Type enum ('Sibiling', 'Spouse', 'Guardian', 'Other'),
    foreign key (Contact_ID, FirstNameContact)
);

Create Table Employee_Emergency_Contact_Info (
	Contact_ID Integer (10) Not Null Primary Key,
	ContactAddressLine1 Varchar(30) Not Null, 
    ContactAddressLine2 Varchar (30),
    ContactCity Varchar (30) Not null,
    ContactState Varchar (30) Not Null, 
    ContactZip Integer (10) Not Null,
	Foreign Key (Contact_ID, ContactAddressLine1) 
); 

Create Table Employee_Emergency_Contact_Address (
	Contact_ID Integer (10) Not Null Primary Key,
	EcontactTelephoneType enum('Home', 'Work', 'Cell') Not Null,
	EcontactAreaCode Integer(3) Not Null,
	EcontactPhoneNumber Integer (7) Not Null,
	Extention Integer (4),
	foreign key (Contact_ID, EcontactTelephoneNumber)
); 

select count (emp_no) as 'Older than 55'
		from employees
        where timestampdiff(year,birth_date,curdate())>55;

select count(*) as 'Hired in 1994'
	from employees
	where hire_date = year(1994);
	
select count(*) as 'Hired per year'
	from employees
    group by (hire_date) = year ;
    
    


    
    