SELECT * FROM departments;
SELECT  *FROM categories;
SELECT  *FROM products;
SELECT  *FROM orders;
SELECT  *FROM order_items;
SELECT *FROM customers;
select count(*) from customers
select count(distinct order_customer_id) from orders

-- ### Exercise 1 - Customer order count

-- Get order count per customer for the month of 2014 January.
-- * Tables - `orders` and `customers`
-- * Data should be sorted in descending order by count and ascending order by customer id.
-- * Output should contain `customer_id`, `customer_fname`, `customer_lname` and `customer_order_count`.

-- order is child table to customers. 1 customer can have many orders. 
-- Review the count of customers:
SELECT count(*) FROM customers;

--Review the orders count for 2014 Jan:
SELECT count(*) FROM orders  where to_char(order_date, 'yyyy-MM') = '2014-01'

-- Review the orders for 2014 Jan:
select count(distinct order_customer_id) from orders where to_char(order_date, 'yyyy-MM') = '2014-01'

--Creating a CTAS:
create table testing123 as
select c.customer_id, c.customer_fname,c.customer_lname, count(*) as customer_order_count
from orders as o  join customers as c on o.order_customer_id = c.customer_id
where to_char(o.order_date::timestamp, 'yyyy-MM') = '2014-01'
group by c.customer_id, c.customer_fname,c.customer_lname
order by 1, 4 desc

--Total orders placed
select sum(customer_order_count) from testing123
--Total customers placing the order
select count(distinct customer_id) from testing123

-- ### Exercise 2 - Dormant Customers

-- Get the customer details who have not placed any order for the month of 2014 January.
-- * Tables - `orders` and `customers`
-- * Output Columns - **All columns from customers as is**
-- * Data should be sorted in ascending order by `customer_id`
-- * Output should contain all the fields from `customers`
-- * Make sure to run below provided validation queries and validate the output.

-- Look for distinct customer ID:
select count(distinct customer_id) from customers

-- Look for distinct customer ID who placed an order in 2014 Jan:
select count(distinct order_customer_id)  from orders where to_char(order_date::timestamp, 'yyyy-MM') = '2014-01'

--combine the order and customer table based on customer Id:
--customers who have never placed an order
select c.*,o.*
from customers as c left outer join orders as o on c.customer_id = o.order_customer_id 
and to_char(order_date::timestamp, 'yyyy-MM') = '2014-01'
where order_customer_id is null
order by customer_id
-- Get the difference:
select count(*) from customers

select count (distinct order_customer_id) 
from orders 
where to_char(order_date, 'yyyy-MM') = '2014-01'

-- difference = 7739 - total number of records who did not place an order in 2014 jan.



-- ### Exercise 3 - Revenue Per Customer

-- Get the revenue generated by each customer for the month of 2014 January
-- * Tables - `orders`, `order_items` and `customers`
-- * Data should be sorted in descending order by revenue and then ascending order by `customer_id`
-- * Output should contain `customer_id`, `customer_fname`, `customer_lname`, `customer_revenue`.
-- * If there are no orders placed by customer, then the corresponding revenue for a given customer should be 0.
-- * Consider only `COMPLETE` and `CLOSED` orders

create table customer_order3 as 
select c.customer_id, c.customer_fname, c.customer_lname, o.order_id, order_date, order_status
from orders as o left outer join customers as c on o.order_customer_id = c.customer_id and to_char(order_date, 'yyyy-MM') = '2014-01' 
and order_status in ('COMPLETE','CLOSED')

select * from customer_order3
select * from order_items

select co.*, round(sum(order_item_subtotal)::numeric,2) as customer_revenue
from customer_order3 as co left outer join order_items as oi on co.order_id = oi.order_item_order_id
where to_char(co.order_date::timestamp, 'yyyy-MM') = '2014-01'
group by customer_id, co.customer_fname, co.customer_lname, co.order_id, co.order_date, order_status 
having order_status in ('COMPLETE','CLOSED')
order by customer_revenue desc, customer_id 


select c.*
from orders as o join customers as c on o.order_customer_id = c.customer_id 
and to_char(order_date::timestamp, 'yyyy-MM') = '2014-01'
and o.order_status in ('COMPLETE','CLOSED')


select count(*) from customers


select c.*
from customers as c
     left outer join orders as o 
	      on o.order_customer_id = c.customer_id
		     and to_char(order_date,'yyy-MM') = '2014-01'
			 and o.order_status in ('COMPLETE','CLOSED')
order by 1

select c.customer_id


-----------------------------------------------------------------------------------------------------------

SELECT count(*) FROM customers;
SELECT count(order_customer_id) FROM orders;


SELECT c.*, o.*
FROM customers AS c
    left outer JOIN orders AS o
        ON o.order_customer_id = c.customer_id
            AND to_char(order_date, 'yyyy-MM') = '2014-01'
            AND o.order_status IN ('COMPLETE', 'CLOSED')
ORDER BY 1
LIMIT 10;

SELECT count(*)
FROM customers AS c
    LEFT OUTER JOIN orders AS o
        ON o.order_customer_id = c.customer_id
            AND to_char(order_date, 'yyyy-MM') = '2014-01'
            AND o.order_status IN ('COMPLETE', 'CLOSED')
ORDER BY 1
LIMIT 10;

SELECT count(DISTINCT c.customer_id)
FROM customers AS c
    LEFT OUTER JOIN orders AS o
        ON o.order_customer_id = c.customer_id
            AND to_char(order_date, 'yyyy-MM') = '2014-01'
            AND o.order_status IN ('COMPLETE', 'CLOSED')
ORDER BY 1
LIMIT 10;

SELECT c.customer_id,
    c.customer_fname,
    c.customer_lname,
    round(sum(oi.order_item_subtotal)::numeric, 2) AS customer_revenue
FROM customers AS c
    LEFT OUTER JOIN orders AS o
        ON o.order_customer_id = c.customer_id
            AND to_char(order_date, 'yyyy-MM') = '2014-01'
            AND o.order_status IN ('COMPLETE', 'CLOSED')
    LEFT OUTER JOIN order_items AS oi
        ON o.order_id = oi.order_item_order_id
GROUP BY 1, 2, 3
ORDER BY 4 DESC, 1
LIMIT 10;

SELECT count(*) FROM (
    SELECT c.customer_id,
        c.customer_fname,
        c.customer_lname,
        round(sum(oi.order_item_subtotal)::numeric, 2) AS customer_revenue
    FROM customers AS c
        LEFT OUTER JOIN orders AS o
            ON o.order_customer_id = c.customer_id
                AND to_char(order_date, 'yyyy-MM') = '2014-01'
                AND o.order_status IN ('COMPLETE', 'CLOSED')
        LEFT OUTER JOIN order_items AS oi
            ON o.order_id = oi.order_item_order_id
    GROUP BY 1, 2, 3
) AS q;

SELECT c.customer_id,
    c.customer_fname,
    c.customer_lname,
    coalesce(round(sum(oi.order_item_subtotal)::numeric, 2), 0) AS customer_revenue
FROM customers AS c
    LEFT OUTER JOIN orders AS o
        ON o.order_customer_id = c.customer_id
            AND to_char(order_date, 'yyyy-MM') = '2014-01'
            AND o.order_status IN ('COMPLETE', 'CLOSED')
    LEFT OUTER JOIN order_items AS oi
        ON o.order_id = oi.order_item_order_id
GROUP BY 1, 2, 3
ORDER BY 4 DESC, 1
LIMIT 10;

SELECT count(*) FROM (
    SELECT c.customer_id,
        c.customer_fname,
        c.customer_lname,
        coalesce(round(sum(oi.order_item_subtotal)::numeric, 2), 0) AS customer_revenue
    FROM customers AS c
        LEFT OUTER JOIN orders AS o
            ON o.order_customer_id = c.customer_id
                AND to_char(order_date, 'yyyy-MM') = '2014-01'
                AND o.order_status IN ('COMPLETE', 'CLOSED')
        LEFT OUTER JOIN order_items AS oi
            ON o.order_id = oi.order_item_order_id
    GROUP BY 1, 2, 3
) AS q;



-- ### Exercise 4 - Revenue Per Category

-- Get the revenue generated for each category for the month of 2014 January
-- * Tables - `orders`, `order_items`, `products` and `categories`
-- * Data should be sorted in ascending order by `category_id`.
-- * Output should contain all the fields from `categories` along with the revenue as `category_revenue`.
-- * Consider only `COMPLETE` and `CLOSED` orders



select count(distinct category_id) from categories


select category_id, category_department_id, category_name, round(sum(oi.order_item_subtotal)::numeric, 2) AS category_revenue
from categories as c inner join products as p on c.category_id = p.product_category_id
JOIN order_items AS oi ON p.product_id = oi.order_item_product_id
JOIN orders AS o ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
    AND to_char(o.order_date, 'yyyy-MM') = '2014-01' 
group by category_id, category_department_id, category_name
order by category_id



create table order_items_order as
select o.*,oi.*
from orders as o inner join order_items as oi on o.order_id = oi.order_item_order_id 
and 

create table  product_category as
select p.*,c.*
from products as p join categories as c on p.product_category_id = c.category_id


select * from order_items_order
select * from product_category

select category_id, category_department_id, category_name,round(sum(oio.order_item_subtotal)::numeric,2) as category_revenue
from product_category as pc join order_items_order as oio on pc.product_id = oio.order_item_product_id
where to_char(oio.order_date::timestamp, 'yyyy-MM') = '2014-01'
group by category_id, oio.order_status, pc.category_department_id, category_name
having order_status in ('COMPLETE','CLOSED')

-- ### Exercise 5 - Product Count Per Department

-- Get the count of products for each department.
-- * Tables - `departments`, `categories`, `products`
-- * Data should be sorted in ascending order by `department_id`
-- * Output should contain all the fields from `departments` and the product count as `product_count`

SELECT * FROM departments;
SELECT  *FROM categories;
SELECT  *FROM products;

select count (distinct category_id) from categories

--select count(distinct department_id)
select d.*,c.*
from departments as d inner join categories as c on d.department_id = c.category_department_id

-- validation: 10 categories missing. 
select *
from departments as d inner join categories as c on d.department_id = c.category_department_id



select d.department_id,
    d.department_name,
    count(*) AS department_count
from departments as d inner join categories as c on d.department_id = c.category_department_id
                      inner join products as p on c.category_id  = p.product_category_id
group by d.department_id, d.department_name
order by 3 desc
