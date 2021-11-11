use classicmodels;

select *
from Orders
inner join orderdetails
using(ordernumber);

select 
	orders.ordernumber as SalesId,
    orderdetails.priceEach as Price,
    orderdetails.quantityOrdered as Unit,
    orders.orderdate as Date,
    week(orders.orderdate) as Weekofyear,
    products.productname as Product,
    products.productline as Brand,
    customers.city as City,
    customers.country as Country
from 
	orders
Inner join
	orderdetails using(ordernumber)
inner join 
	products using (productcode)
inner join
	customers using (customernumber);
    
# -----
# this creates an empty table similar to the above.
Create Table new_order like orders;

# To copy a table with all content we use the following.

Create Table new_order as select * from orders;

# To copy the joined columns into a new column, we use the following.

Drop procedure if exists CreateProductSalesStore;

delimiter //

Create Procedure CreateProductSalesStore()
Begin

	Drop Table if exists Product_Sales; 
    
    Create Table Product_Sales as
		select 
		orders.ordernumber as SalesId,
		orderdetails.priceEach as Price,
		orderdetails.quantityOrdered as Unit,
		orders.orderdate as Date,
		week(orders.orderdate) as Weekofyear,
		products.productname as Product,
		products.productline as Brand,
		customers.city as City,
		customers.country as Country
		from 
			orders
		Inner join
			orderdetails using(ordernumber)
		inner join 
			products using (productcode)
		inner join
			customers using (customernumber)
		order by ordernumber,
        orderlinenumber;
End//

Delimiter ;

Show Variables like "event_scheduler";

call CreateProductSalesStore();

# To refresh the table - Method 1
Truncate messages;

Delimiter //
Create Event CreateProductSalesStoreEvent
on schedule every 1 minute
starts current_timestamp()
ends current_timestamp + interval 1 hour
Do
	begin
    INSERT INTO messages SELECT CONCAT('event:',NOW());
	CALL CreateProductSalesStore();
	END //
DELIMITER ;

show events;

Select * from messages;

drop event if exists CreateProductSalesStoreEvent;

# To refresh the table - Method 2

			DELIMITER $$
			CREATE TRIGGER trigger_namex
				AFTER INSERT ON table_namex FOR EACH ROW
			BEGIN
				-- statements
				-- NEW.orderNumber, NEW.productCode etc
			END$$    
			DELIMITER ;


DROP TRIGGER IF EXISTS after_order_insert; 

DELIMITER $$
CREATE TRIGGER after_order_insert
AFTER INSERT
ON orderdetails FOR EACH ROW
BEGIN
	
	-- log the order number of the newley inserted order
    	INSERT INTO messages SELECT CONCAT('new orderNumber: ', NEW.orderNumber);

	-- archive the order and assosiated table entries to product_sales
  	INSERT INTO product_sales
	SELECT 
	   orders.orderNumber AS SalesId, 
	   orderdetails.priceEach AS Price, 
	   orderdetails.quantityOrdered AS Unit,
		orders.orderDate AS Date,
		WEEK(orders.orderDate) as WeekOfYear,
		products.productName AS Product,
	   products.productLine As Brand,
	   customers.city As City,
	   customers.country As Country

	FROM
		orders
	INNER JOIN
		orderdetails USING (orderNumber)
	INNER JOIN
		products USING (productCode)
	INNER JOIN
		customers USING (customerNumber)
	WHERE orderNumber = NEW.orderNumber
	ORDER BY 
		orderNumber, 
		orderLineNumber;
        
END $$

DELIMITER ;

Show Triggers;

select * from product_sales;
Select count(*) from product_sales;

truncate messages;

INSERT INTO orders  VALUES(16,'2020-10-01','2020-10-01','2020-10-01','Done','',131);

INSERT INTO orderdetails VALUES(16,'S18_1749','1','10',1);

SELECT * FROM ORDERDetails;

SELECT * FROM MESSAGES;

# to dice and cut

DROP VIEW IF EXISTS Vintage_Cars;

CREATE VIEW `Vintage_Cars` AS
SELECT * FROM product_sales WHERE product_sales.Brand = 'Vintage Cars';

select * from vintage_cars;

Create view `sales_USA` as
select * from product_sales where product_sales.country = 'USA';

select * from sales_USA;