use classicmodels;

DROP PROCEDURE IF EXISTS GetAllProducts;

DELIMITER //
CREATE PROCEDURE GetAllProducts()
BEGIN
	SELECT *  FROM products;
    select * from office;
END //
DELIMITER ;

call GetAllProducts;
# ---
DROP PROCEDURE IF EXISTS GetOfficeByCountry;

DELIMITER //
# It's always a good practice to name the variable different from the column name.
CREATE PROCEDURE GetOfficeByCountry(
	IN countryName VARCHAR(255), CityName varchar(255)
)
BEGIN
	SELECT * 
 		FROM offices
			WHERE country = countryName and city = cityname;
END //
DELIMITER ;

select distinct country from offices;


call GetOfficeByCountry('USA');

#---
# Assignment 1
# Create a stored procedure which displays the first X entries of payment table. X is IN parameter for the procedure.

Drop Procedure if Exists XEntries;

Delimiter //

create procedure XEntries(
	in XEntries integer
 )
 Begin
	Select * from payments limit XEntries;
End //

Delimiter ;

call XEntries('5');

# ---

DROP PROCEDURE IF EXISTS GetOrderCountByStatus;

DELIMITER $$

CREATE PROCEDURE GetOrderCountByStatus (
	IN  orderStatus VARCHAR(25),
	OUT total INT
)
BEGIN
	SELECT COUNT(orderNumber)
	INTO total
	FROM orders
	WHERE status = orderStatus;
END$$
DELIMITER ;

call GetOrderCountByStatus('Shipped',@totalx);

Select @totalx;

---
# Assigment 2

Drop procedure if exists XEntry;

delimiter //

create procedure XEntry(
	in X int,
    OUT amountout decimal(10,2)
)
Begin
	set X = X - 1;
	Select amount into amountout from payments limit X,1;
End //

Delimiter ;

call XEntry(5,@A);

select @A;

# ---

DROP PROCEDURE IF EXISTS GetCustomerLevel;

DELIMITER $$

CREATE PROCEDURE GetCustomerLevel(
    	IN  pCustomerNumber INT, 
    	OUT pCustomerLevel  VARCHAR(20)
)
BEGIN
	DECLARE credit DECIMAL DEFAULT 0;

	SELECT creditLimit 
		INTO credit
			FROM customers
				WHERE customerNumber = pCustomerNumber;

	IF credit > 50000 THEN
		SET pCustomerLevel = 'PLATINUM';
	ELSE
		SET pCustomerLevel = 'NOT PLATINUM';
	END IF;
END$$
DELIMITER ;

# Assignment 3
# Create a stored procedure which returns category of a given row. Row number is IN parameter, 
# while category is OUT parameter. Display the returned category. CAT1 - amount > 100.000, CAT2 - amount > 10.000, CAT3 - amount <= 10.000

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

call categoryx(18,@category);
select @category;
    


# ASSIGNMENT 2 QUESTION: HOW DO WE PULL MORE COLUMNS SUCH AS 
# customerNumber,checkNumber ALONGSIDE THE @AMOUNT IN OUR FINAL OUTPUT?

# Iterating Loops

DROP PROCEDURE IF EXISTS LoopDemo;

DELIMITER $$
CREATE PROCEDURE LoopDemo()
BEGIN
      
	ceuloop: LOOP
		SELECT * FROM offices;
		IF TRUE THEN
			LEAVE ceuloop;
		END IF;
	END LOOP ceuloop;
END$$
DELIMITER ;

CALL LoopDemo();

# -------
# Assignment 4

# Create a loop which counts to 5 and displays the actual count in each step as SELECT (eg. SELECT count)

DROP PROCEDURE IF EXISTS CounterLoop;

DELIMITER $$

CREATE PROCEDURE CounterLoop()

BEGIN
	Declare x int default 0;
	ThisLoop : Loop
    SET x = x + 1;
    select x;
    if (x=5) then
		leave ThisLoop;
	End if;
End Loop;
        
END$$
DELIMITER ;

call CounterLoop();

# Create a table to insert the results of the loop select

create table if not exists messages (message varchar(100) not null);

DROP PROCEDURE IF EXISTS LoopCounter;

DELIMITER $$

CREATE PROCEDURE LoopCounter()

BEGIN
	Declare x int default 0;
	
    Truncate messages;
    myloop : loop
		set x = x + 1;
        insert into messages select concat('x:',x);
        
		if (x=5) then
			leave myLoop;
		End if;
End Loop;
        
END$$
DELIMITER ;

call LoopCounter();
select * from messages;

# ----
# Creating a cursor to alter table data

DROP PROCEDURE IF EXISTS CursorDemo;

DELIMITER $$
CREATE PROCEDURE CursorDemo()
BEGIN
	DECLARE phone varchar(50);
	DECLARE finished INTEGER DEFAULT 0;
	-- DECLARE CURSOR
	DECLARE curPhone CURSOR FOR SELECT customers.phone FROM classicmodels.customers;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
	-- OPEN CURSOR
	OPEN curPhone;
	TRUNCATE messages;
	myloop: LOOP
		-- FETCH CURSOR
		FETCH curPhone INTO phone;
		INSERT INTO messages SELECT CONCAT('phone:',phone);
		IF finished = 1 THEN LEAVE myloop;
		END IF;
	END LOOP myloop;
	-- CLOSE CURSOR
	CLOSE curPhone;
END$$
DELIMITER ;


CALL CursorDemo();

SELECT * FROM messages;

# Assignemnt 5

create table if not exists messages1 (ordernumber int, shippeddate date);

DROP PROCEDURE IF EXISTS CursorDemo;

DELIMITER $$
CREATE PROCEDURE CursorDemo()
BEGIN
	DECLARE ordernumber varchar(50);
    declare shippeddate date;
	DECLARE finished INTEGER DEFAULT 0;
	-- DECLARE CURSOR
	DECLARE curOrder CURSOR FOR SELECT orders.ordernumber, orders.shippeddate FROM classicmodels.orders;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
	-- OPEN CURSOR
	OPEN curOrder;
	TRUNCATE messages1;
	myloop: LOOP
		-- FETCH CURSOR
		FETCH curOrder INTO ordernumber, shippeddate;
		INSERT INTO messages1 SELECT ordernumber, shippeddate;
		IF finished = 1 THEN LEAVE myloop;
		END IF;
	END LOOP myloop;
	-- CLOSE CURSOR
	CLOSE curOrder;
END$$
DELIMITER ;


CALL CursorDemo();

SELECT * FROM messages1;