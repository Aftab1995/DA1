use birdstrikes;

select state from birdstrikes limit 144,1;

select count(*) from( select distinct cost from birdstrikes) as CountOfCost;

select count(cost) from birdstrikes where cost = 0;

select count(*) from birdstrikes where cost = 0;

select distinct flight_date from birdstrikes order by flight_date desc limit 1;

select distinct cost from birdstrikes order by cost desc limit 49,1; 

select count(*) 
from (select * from birdstrikes where state = 'Alabama' and bird_size = "small") as count;

select distinct state 
from birdstrikes 
where state is not null and state != '' order by state;

select count(distinct state) from birdstrikes;

select count(*) from
(select id from birdstrikes where state in ('Alabama')) as count;

select count(id) from birdstrikes where state in('Alabama');

select distinct state from birdstrikes where state like 'A_____';

select count(state) from birdstrikes where state like 'A%';

select count(*) from
(select distinct state from birdstrikes where state like 'A%') as count;

select distinct state from birdstrikes where length(state) = 5;

SELECT ROUND(SQRT(speed/2) * 10) AS synthetic_speed 
FROM birdstrikes 
where ROUND(SQRT(speed/2) * 10) is not null and ROUND(SQRT(speed/2) * 10) != 0;

select state, bird_size 
from birdstrikes 
where state is not null and state != '' 
and bird_size is not null and bird_size !=''
limit 1,1;

select datediff(now(), 
(select flight_date from birdstrikes 
where state = 'colorado' and weekofyear(flight_date) = 52));

select aircraft, airline, cost,
	case 
		when cost = 0
			then 'No Cost'
		when cost > 0 and cost < 100000
			then 'Medium cost'
		else 
			'High Cost'
	End
	As Cost_Category
From birdstrikes
order by Cost_Category;

select speed, aircraft, damage,
	if( speed < 100, 'Low Speed',"High Speed")
	as speed_category
From Birdstrikes
where speed is not null and speed != ''
order by speed_category;

select count(*) from birdstrikes;

select count(reported_date) from birdstrikes;

select count(distinct state) from birdstrikes where state like 'A%';

select count(distinct aircraft) from birdstrikes;

use classicmodels;

select *
from customers c
inner join payments p
on c.CustomerNumber = p.CustomerNumber;

select *
from payments p
inner join customers c
on p.CustomerNUmber = c.CustomerNumber;

select *
from offices o
inner join employees e
on o.OfficeCode = e.OfficeCode
order by o.officecode;

select *
from employees e
inner join offices o
on o.OfficeCode = e.OfficeCode
order by reportsto;

select count(distinct productcode) from Products;

select *
from ProductLines
inner join products
using(productline)
order by ProductLine;

select *
from orders o
inner join orderdetails d
using(OrderNumber);

select OrderNumber, Status, (quantityordered * PriceEach) as SumTotalSales
from orders o
inner join OrderDetails d
using(OrderNumber)
group by OrderNumber
order by SumTotalSales desc;

select OrderDate, Firstname, Lastname,  
count(OrderDate) as performance
from customers c
inner join orders o
using(CustomerNumber)
inner join employees e
on c.SalesRepEmployeeNumber = e.EmployeeNumber
group by Firstname
order by performance desc;

select 
concat(m.LastName, ',', m.FirstName) as Manager,
m.Jobtitle,
concat(e.Lastname, ',', e.Firstname) as 'Direct Report',
e.jobTitle
from employees e
inner join employees m
on m.employeeNumber = e.reportsTo
order by m.jobtitle;

select c.customerNumber, CustomerName, OrderNumber, Status, count(CustomerNumber)
from Customers C
left Join Orders O
using(CustomerNumber)
where OrderNumber is not Null;

select c.customerNumber, CustomerName, OrderNumber, Status
from Customers C
Inner Join Orders O
using(CustomerNumber);

SELECT 
    o.orderNumber, 
    d.ordernumber,
    customerNumber, 
    productCode
FROM
    orders o
LEFT JOIN orderDetails d
    USING (orderNumber)
WHERE
    d.orderNumber = 10123;
    
SELECT 
    o.orderNumber, 
    d.ordernumber,
    customerNumber, 
    productCode,
    count(o.ordernumber) as countO
FROM
    orders o
LEFT JOIN orderDetails d 
    ON o.orderNumber = d.orderNumber AND 
       o.ordernumber = 10123
group by o.ordernumber
order by countO desc;

select 
o.ordernumber, priceEach, quantityOrdered, Productname, ProductLine, City, Country, OrderDate
from 
	customers c
inner join 
	orders o
using 
	(CustomerNumber)
inner join 
	orderdetails d
using 
	(OrderNumber)
inner join 
	Products p
using 
	(productCode);
    
Drop procedure if exists GetAllProducts;

Delimiter //

Create Procedure GetAllProducts()
Begin
	Select * From Products;
End //

Delimiter ;

call GetAllProducts;

drop procedure if exists GetOfficeByCountry;

Delimiter //

Create Procedure GetOfficeByCountry(
	In CountryName Varchar(255)
)
Begin
	select * From Offices
		Where country = CountryName;
End //

Delimiter ;

call GetOfficeByCountry('USA');



Drop Procedure If Exists Xentries;

Delimiter //

Create Procedure Xentries(
	In X int
)
Begin
	select * from payments
		limit x;
End //

Delimiter ;

Call Xentries(5);

Drop Procedure if exists GetOrderByStatus;

Delimiter //

Create Procedure GetOrderByStatus(
	In OrderStatus varchar(25),
    out total int
)
Begin
	Select count(OrderNumber)
    into total
    from orders
    where status = orderstatus;
End //
Delimiter ;

select distinct status from orders;

call GetOrderByStatus('On Hold',@total);

select @total;

drop procedure if exists XEntryAmount;

delimiter //

Create Procedure XEntryAmount(
	in x int,
    out EntryAmount double(10,2)
)
Begin
	set x = x-1;
    select Amount
    INTO EntryAmount
    From Payments
    limit x,1;
End //
Delimiter ;

call XEntryAmount(5,@amount);

Select @amount;

drop procedure if exists SetCounter;

Delimiter //

Create Procedure SetCounter(
	INOUT Counter INT,
    In INC int
)
Begin
	set counter = counter + inc;
End //

Delimiter ;

set @counter = 2;
Call SetCounter(@counter,2);
Select @Counter;

Drop Procedure If Exists GetCustomerLevel;

Delimiter //

Create Procedure GetCustomerLevel(
	In pCustomerNumber INT,
    Out PCustomerLevel Varchar(20)
)
Begin
	Declare Credit Decimal Default 0;
    
    Select CreditLimit
		Into Credit
			From Customers
				Where CustomerNumber = pCustomerNumber
                order by credit desc;
	If Credit > 50000 Then
		Set pCustomerLevel = 'Platinum';
	elseif Credit < 50000 and credit > 30000 Then
		Set pCustomerLevel = 'Gold';
	else
		Set pCustomerLevel = 'Not Standard';
	End If;
End //

Delimiter ;

Call GetCustomerLevel(364,@Credit);

Select @Credit;

Select CustomerNumber, CreditLImit from Customers;

 
# --------
Drop Procedure If Exists CreditCategory;

Delimiter //

Create Procedure CreditCategory(
	In pCustomerNumber INT,
    Out pCreditCategory Varchar(20)
)
Begin
	Declare Credit Decimal Default 0;
			
			Select creditLimit
				into credit
				from customers
				WHERE customerNumber = pCustomerNumber;
			Case
				When credit < 30000
					Then 
						set pcreditCategory = 'Not Standard';
				When credit >=30000 and credit < 50000
					Then  
						set pcreditCategory = 'Gold';
				Else
						set pcreditCategory = 'Platinum';
			End Case;
End //
Delimiter ;


Call CreditCategory(112,@credit);
Select @credit;

# ---------

drop procedure if exists PaymentCategory;

Delimiter //

Create Procedure PaymentCategory(
	In X int,
    Out Category varchar(20)
)
Begin
	Declare payment decimal(10,2) default 0;
    set X = X -1;
    Select Amount
		into payment
			from Payments
                limit X,1 ;
	If payment > 100000 then
		set category = 'Cat1';
	Elseif payment > 10000 then
		set category = 'Cat2';
	Elseif
		payment < 10000 then
		set category = 'cat3';
	End if;
End //
Delimiter ;

Call PaymentCategory(398,@category);

Select @category;

select customernumber, amount from payments order by amount asc;

# ----------
drop procedure if exists categoryX;

Delimiter //

create procedure categoryX(
	in x int,
    out Category varchar(10)
    )
Begin
	declare amount_limit decimal(10,2) default 0;
    set x = x-1;
    select amount
		into amount_limit
			from payments
				limit x,1;
	if amount_limit > 100000 then
		set category = 'CAT1';
	Elseif amount_limit > 10000 then
		set category = 'CAT2';
	Else
		set category = 'CAT3';
	End if;
End //
Delimiter ;

call categoryx(141,@category);
select @category;

Drop Procedure if Exists LoopDemo;

Delimiter //

Create Procedure LoopDemo()
Begin
	CeuLoop: Loop
		Select * from Offices;
        if true then 
			leave ceuloop;
		end if;
	End loop ceuloop;
End //
Delimiter ;

Call LoopDemo();

# To make sure the results in below procedure appear in 1 table, we should first 
# create a table and store the counter data into that table.

Create Table counts (counter varchar(20) not null);

Drop Procedure if Exists LoopCounter;
Delimiter //
Create Procedure LoopCounter(
	in x int,
    in inc int
)
Begin
	declare counter int default 0;
		# The following line will delete the previous entries of the table
		truncate counts;
		LoopCounter: Loop
			SET x = x + inc;
            # instead of select x; we use the following line
			insert into counts select concat('x:',x);
			if (x>=5) then
				leave LoopCounter;
			End if;
		End LOOP LoopCounter;
End //
Delimiter ;

call loopcounter(-4,3);

select counter from counts;








