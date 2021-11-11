use classicmodels;
describe customers;

-- inner join - combines the products that are matching in both tables. Intersection of both table. 
select *
from products
inner join productlines
on products.productline = productlines.productline;

-- we can write aliases for tables, such as t1 is the products. This alias is carried forward
-- we can say from products as t1 or products t1

select *
from products t1
inner join prodcutlines t2
on t1.productLine = t2.productline;

-- we can do the same thing by USING but we have to make sure the columns are named the same on both tables
select *
from products
inner join productlines
using(productline);

-- left join - where the products of first table are all added and only the matching products are added from the second table. When there isn't a match in the second table,
-- there will be null values.

-- right join - where the products of second table are all added and only the matching products are added from the first table. When there isn't a match in the first table,
-- there will be null values.

-- full join - where every product is added from both the tables. 