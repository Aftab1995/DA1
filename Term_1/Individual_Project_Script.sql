# Creating the new Schema
Drop Schema if exists Brazillian_OList;
create schema Brazillian_OList;
use Brazillian_OList;

# Checking the path of the secure_file_priv to make sure it's not null
# and turning on the local_infile option.
show variables like "secure_file_priv";
show variables like "local_infile";
set global local_infile = ON;

######################################
# Creating the tables and Loading them.


# Creating the 1st table Customers.
drop table if exists Customers;
create table Customers
(Customer_Id varchar(50) not null,
Customer_Unique_Id varchar(50),
Customer_ZipCode int,
Customer_City varchar(50),
Customer_State varchar(2),
primary key (Customer_Id));


# Loading data
# Converted the zip codes into integers in Excel as it was initially stored as a string.

Load Data Infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Brazillian_Olist_Data\\olist_customers_dataset.csv'
Into Table Customers
Fields  Terminated By ','
optionally Enclosed by '"'
Lines Terminated By '\n'
Ignore 1 Lines
(customer_id, customer_unique_id, Customer_ZipCode, customer_city, customer_state);

SHOW COLUMNS FROM customers;

SELECT `COLUMN_NAME` 
FROM `INFORMATION_SCHEMA`.`COLUMNS` 
WHERE `TABLE_SCHEMA`='brazillian_olist' 
    AND `TABLE_NAME`='customers';

# Creating the 2nd table GeoLocation.
# Deleted duplicate values using Excel. Since the file is supposed to give unique zipcodes for Brazil. The data was collected from multiple sources, hence contained duplicate
# values for zipcodes with slight variations in lat and long which signified the different centroid considered by each data provider.

drop table if exists GeoLocation;
create table GeoLocation
(ZipCode int not null,
Latitude double,
Longitude double,
City varchar(50),
State varchar(2),
primary key(Zipcode));

# Loading data
# Cleaned the data before loading because some entries in column 'city' included state 
# and country name with commas to separate it, even though the column only needed city name.
# So, I split the column using Excel based on the comma in the same column and deleted the 
# city and country name mentioned in the column as state was already given in the state column.
# Also, converted the zip codes into integers in Excel as it was initially stored as a string.
Load Data Infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Brazillian_Olist_Data\\olist_geolocation_dataset.csv'
Into Table GeoLocation
Fields  Terminated By ','
Lines Terminated By '\r\n'
Ignore 1 Lines
(Zipcode, Latitude, Longitude, City, State);

# Creating the 3rd table Olist_Order_Items.
drop table if exists Order_Items;
create table Order_Items
(Id int not null auto_increment,
Order_Id varchar(50),
Num_of_Items_Ordered int,
Product_Id varchar(100),
Seller_Id varchar(50),
Shipping_Limit_Date datetime,
Price double,
Freight_Value double,
primary key(Id));


# Loading data
Load Data Infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Brazillian_Olist_Data\\olist_order_items_dataset.csv'
Into Table Order_Items
Fields  Terminated By ','
OPTIONALLY ENCLOSED BY '"'
Lines Terminated By '\n'
Ignore 1 Lines
(Order_Id, Num_of_Items_Ordered, Product_Id, Seller_Id, Shipping_Limit_Date, Price, Freight_Value);

#Creating the 4th table order_payments
drop table if exists order_payments;
create table order_payments
(Id int not null auto_increment,
order_id varchar(50),
payment_sequential int,
payment_type varchar(30),
payment_installments int,
payment_value double,
primary key(Id));

#Loading data 
Load Data Infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Brazillian_Olist_Data\\olist_order_payments_dataset.csv'
Into Table order_payments
Fields Terminated By ','
OPTIONALLY ENCLOSED BY '"'
Lines Terminated By '\n'
Ignore 1 Lines
(order_id, payment_sequential, payment_type, payment_installments, payment_value);

#Creating the 5th table order_reviews
Drop Table If Exists Order_Reviews;
Create Table Order_Reviews
(Id int not null auto_increment,
review_id varchar(50),
order_id varchar(50),
review_score double,
review_creation_date date,
review_filled_date date,
primary key(Id));

# Loading the data
#Deleted the Review_Comment & Review_Title column since I won't be doing sentiment analysis based on the wordings
Load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Brazillian_Olist_Data\\olist_order_reviews_dataset.csv'
Into Table Order_Reviews
Fields Terminated By ','
Lines Terminated By '\r\n'
Ignore 1 Lines
(review_id, order_id, review_score, review_creation_date, review_filled_date);

#Creating the 6th table Orders_Main

Drop Table If Exists Orders_Main;
Create Table Orders_Main
(Order_Id varchar(50) not null,
Customer_Id varchar(50),
Order_Status varchar(25),
Order_Purchase_Date datetime,
Order_Approved_Date datetime,
Order_Delivered_Carrier_Date datetime,
Order_Delivered_Customer_Date datetime,
Order_Delivered_Estimated_Date datetime,
primary key(Order_Id));

# Loading the data

Load Data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Brazillian_Olist_Data\\olist_orders_dataset.csv'
Into Table Orders_Main
Fields Terminated By ','
Lines Terminated By '\r\n'
Ignore 1 Lines
(Order_Id, Customer_Id, Order_Status, Order_Purchase_Date, @O_Order_Approved_Date, @O_Order_Delivered_Carrier_Date, 
@O_Order_Delivered_Customer_Date, @O_Order_Delivered_Estimated_Date)
Set
Order_Approved_Date = nullif(@O_Order_Approved_Date, ''),
Order_Delivered_Carrier_Date =nullif(@O_order_delivered_carrier_date, ''),
Order_Delivered_Customer_Date =nullif(@O_order_delivered_customer_date, ''), 
Order_Delivered_Estimated_Date = nullif(@O_order_delivered_estimated_date, '');

# Creating the 7th table products
Drop Table If exists Products;
Create Table Products
(product_id varchar(100) not null,
Product_Category varchar(150),
product_name_length int,
product_desc_length int,
product_photos_qty int,
product_weight double,
product_length double,
product_height double,
product_width double,
primary key(Product_Id));

# Loading the data
Load Data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Brazillian_Olist_Data\\olist_products_dataset.csv'
Into Table Products
Fields Terminated By ','
OPTIONALLY ENCLOSED BY '"'
Lines Terminated By '\n'
Ignore 1 Lines
(Product_id, @p_Product_category, @p_product_name_length, @p_product_desc_length, 
@p_product_photos_qty, @p_product_weight, @p_product_length, @p_product_height, @p_product_width)
Set
Product_Category = nullif(@p_Product_category, ''),
product_name_length = nullif(@p_product_name_length, ''), 
product_desc_length = nullif(@p_product_desc_length, ''), 
product_photos_qty = nullif(@p_product_photos_qty, ''), 
product_weight = nullif(@p_product_weight, ''), 
product_length = nullif(@p_product_length, ''), 
product_height = nullif(@p_product_height, ''),
product_width = nullif(@p_product_width, '');

#Creating the 8th table Seller
Drop Table If Exists Sellers;
Create Table Sellers
(Seller_Id varchar(50) not null,
Seller_ZipCode int,
Seller_City varchar(100),
Seller_State varchar(2),
primary key(Seller_Id));

# Loading the data
Load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Brazillian_Olist_Data\\olist_sellers_dataset.csv'
Into Table Sellers
Fields Terminated By ','
Optionally Enclosed By '"'
Lines Terminated By '\n'
Ignore 1 Lines
(Seller_Id, Seller_ZipCode, Seller_City, Seller_State);

# Creating the 9th Table Categories
Drop Table If Exists Categories;
Create Table Categories
(Category_Por varchar(150) not null,
Category_Eng varchar(150),
primary key(Category_Por));

# Loading the data
Load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Brazillian_Olist_Data\\product_category_name_translation.csv'
Into Table Categories
Fields Terminated By ','
Optionally Enclosed By '"'
Lines Terminated By '\r\n'
Ignore 1 Lines
(Category_Por, Category_Eng);
###############################

###############################
# Creating the procedure 'Olist_DW' to create the data warehouse.

# The procedure uses 3 steps to create the data warehouse
# 1- It first creates a table Customer_Order_Main where it joins the tables Orders_Main, Customers, geolocation, and Order_Reviews and stores these.
# 2- The procedure then uses the Customer_Order_Main table and joins it with Payments, Order_Items, sellers, and products to create the final Olist_DW datawarehouse.
# 3- It then drops the Customer_Order_Main table to decrease the load on the server.

DROP PROCEDURE IF EXISTS Olist_DW;

DELIMITER //

CREATE PROCEDURE Olist_DW()
BEGIN

	DROP TABLE IF EXISTS Olist_DW;
    
    DROP TABLE IF EXISTS Customer_Orders_Main;
    
    # Joining Orders_Main, Customers, geolocation, and Order_Reviews into Customer_Orders_Main to optimize time to join multiple tables ahead
	Create Table Customer_Orders_Main as
	select m.order_id, order_status, order_purchase_date, order_approved_date, order_delivered_carrier_date, order_delivered_customer_date, order_delivered_estimated_date,

	Customer_Id, Customer_Unique_Id, Customer_ZipCode, Customer_City,

	latitude, longitude,

	review_id, review_score, review_creation_date, review_filled_date

	from orders_main m
	left join customers c
	using (customer_id)
	left join geolocation g
	on g.zipcode=c.customer_zipcode
	right join order_reviews r
	using (order_id);
    
   # Joining Customer_Orders_Main with Payments, Order_Items, sellers, and products to create the final data warehouse as olist_dw 
    CREATE TABLE olist_dw as
	select 
	order_id, order_status, order_purchase_date, order_approved_date, order_delivered_carrier_date, order_delivered_customer_date, order_delivered_estimated_date,

	Customer_Id, Customer_Unique_Id, Customer_ZipCode, Customer_City,

	latitude, longitude,

	review_id, review_score, review_creation_date, review_filled_date,

	payment_sequential, payment_type, payment_installments, payment_value,

	num_of_items_ordered, product_id, seller_id, shipping_limit_date, Price,

	Seller_Zipcode, Seller_City, Seller_State,

	product_name_length, product_desc_length, product_photos_qty, product_weight, product_height, product_width,

	category_eng as product_category

	from Customer_orders_main
	right join order_payments
	using (order_id)
	right join order_items
	using (order_id)
	left join sellers
	using (seller_id)
	left join products
	using (product_id)
	left join categories
	on products.product_category = categories.category_por;
	
    # Deleting the rows where order_status, order_purchase_date, order_approved_date is null as we do not need these rows.
    Delete from olist_dw
	where order_status is null and order_purchase_date is null and order_approved_date is null;
    
    DROP TABLE IF EXISTS customer_orders_main;
    
End //
Delimiter ;

# Running the procedure Olist_DW
Call Olist_DW();
###############################

# Creating data mart views to enable analysts answer certain questions

# Questions: 
#1 Top 5 categories in terms of sales by year? (order_status, order_id, product_category, order_purchase_date)

drop view if exists `categories_by_Year`;
create view categories_by_year as
select order_id, product_category, order_purchase_date, year(order_purchase_date) as order_purchase_year, order_status
from olist_dw
where order_status = 'Delivered' and product_category is not null
order by order_purchase_year;

Drop procedure if exists categories_by_year;

Delimiter ??

Create Procedure categories_by_year(
	in order_year year
)
Begin
    
    select count(order_id) as number_of_orders, product_category, order_purchase_year from categories_by_year 
    where order_purchase_year = order_year
    group by product_category
    order by number_of_orders desc
    limit 5;

End ??
Delimiter ;

call categories_by_year(2016);


#2 Top 5 sellers by year? (order_id, order_purchase_date, seller_id)

drop view if exists `Sellers_by_Year`;
create view Sellers_by_year as
select order_id, seller_id, order_purchase_date, year(order_purchase_date) as order_purchase_year
from olist_dw
where order_status = 'Delivered' 
order by order_purchase_year;
    

Drop procedure if exists sellers_by_year;

Delimiter ??

Create Procedure sellers_by_year(
	in order_year year
)
Begin
    
    select count(order_id) as number_of_orders, seller_id, order_purchase_year from sellers_by_year 
    where order_purchase_year = order_year
    group by seller_id
    order by number_of_orders desc
    limit 5;

End ??
Delimiter ;

call sellers_by_year(2018);

#3 Top 5 sellers by average review score by year? (order_id, seller_id, review_filled_date, review_score)

drop view if exists `Sellers_by_Review`;
create view Sellers_by_Review as
select order_id, seller_id, year(review_filled_date) as review_filled_year , review_score, review_id
from olist_dw
order by review_filled_year;

Drop procedure if exists sellers_by_review;

Delimiter ??

Create Procedure sellers_by_review(
	in review_year year
)
Begin
    
    select avg(review_score) as average_review_score, seller_id, review_filled_year from sellers_by_review 
    where review_filled_year = review_year
    group by seller_id
    order by average_review_score desc
    limit 5;

End ??
Delimiter ;

call sellers_by_review(2017);


#4 Most famous payment type by year? (order_id, order_purchase_date, payment_type)

drop view if exists `payment_by_year`;
create view payment_by_year as
select order_id, year(order_purchase_date) as payment_year , payment_type
from olist_dw
order by payment_year;

Drop procedure if exists payment_type_year;

Delimiter ??

Create Procedure payment_type_year(
	in payment_year_ year
)
Begin
    
    select payment_type,count(payment_type) as total_payment_type
    from payment_by_year 
    where payment_year = payment_year_
    group by payment_type
    order by total_payment_type desc
    limit 5;

End ??
Delimiter ;

call payment_type_year(2017);



 











