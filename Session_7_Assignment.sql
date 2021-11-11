# Assignment 1

use birdstrikes;

create table birdstrikes2 like birdstrikes;

insert into birdstrikes2 
select * from birdstrikes
where id = 10;

# or use the following query 

create table birdstrikes2 as
select * from birdstrikes
where id = 10;

select * from birdstrikes2;

# Assignment 2

drop view if exists `Sales-2003-2005`;
create view `Sales-2003-2005` as
	select * from product_sales where product_sales.Date like '2003%' or product_sales.Date like '2005%';
    
Select * from `Sales-2003-2005`;

select count(*) from `Sales-2003-2005`;