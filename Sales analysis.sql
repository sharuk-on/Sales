create table sales(
					sales_id int primary key auto_increment,
					Order_ID int,	
					Product varchar(45),
                    Quantity_Ordered int,
					Price_Each double,
					Total_Price double,
					Order_Date datetime,
					Month varchar(12),
					Purchase_Address varchar(45) 
);

-- Adding new columns to the table
alter table sales
add column City varchar(25), 
add column State varchar(25);

-- Populating City (see what i did there)
update sales
set city = substring_index(substring_index(purchase_address,',',2), ',', -1);

-- Populating State 
update sales
set state = case substring(substring_index(purchase_address,',',-1),2,2) 
					when 'CA' then  'California'
                    when 'GA' then  'Georgia'
                    when 'ME' then  'Maine'
                    when 'MA' then  'Massachusetts'
                    when 'NY' then  'New York'
                    when 'OR' then  'Oregon'
                    when 'TX' then  'Texas'
                    when 'WA' then  'Washington'
                    end;


/*
Q1: What was the best month of sales? How much was earned that month?
Q2: Which city has the highest number of sales?
Q3: What time should we display advertisement to maximize the likelihood of customers buying the product?
Q4: What products are most often sold together?
Q5: What product sold the most? And why do you think it sold the most?
*/

-- Q1: What was the best month of sales? How much was earned that month?
select month, round(sum(total_price),2) total_sales 
from sales
group by month
order by total_sales desc;

/*
Result and Interpretation:
December by far the best month of sales
Why it was best month in terms of sales, it's not hard to answer especially when know from the dataset that all the shops are in America.
It's the month of Christmas. In terms of sale Christmas is not a day it's an entire month leading up to it. 
American Christmas traditions are structured in the way to consume everything from wide range of products to entertainment.
*/

-- Q2: Which city has the highest number of sales?
select city, round(sum(total_price),2) total_sales , state
from sales
group by city
order by total_sales desc;

/*
Result and Interpretation:
The city with most sales by far is San Francisco, California.
As to why San Francisco, the city which homes Silicon Valley has the most sales from shops which sells solely tech products is indeed puzzling question. 
Quips apart, the major demographic of people who are dependent in these kinds products are people who works in tech related industry. High end Laptops, monitors, smartphones these are vital part of their jobs.
When you have a tech shop in tech hub of the world you'll get the same result as this one.
*/

-- Q3: What time should we display advertisement to maximize the likelihood of customers buying the product?
with cte as (
	select total_price, hour(order_date) time 
	from sales)
select time, round(sum(total_price),2) total_sales 
from cte
group by time
order by total_sales desc;

/*
Result and Interpretation:
Most of the sales happen around 19:00, 12:00, 11:00 and 20:00 
If we were to interpret from top 4 values alone, we get two windows to display advertisements one in the morning and the other in the evening.
To maximize the likelihood of customers buying the products in the morning we can display advertisement from 11:00 to 1:00 and for the evening 19:00 to 21:00.
Four hours of advertising per day to maximize the sales.
*/

-- Q4: What products are most often sold together?
with cte as
			(select one.order_id, one.order_date, one.product
			from sales one
			join sales two on one.order_id = two.order_id and one.product <> two.product and one.Order_Date = one.Order_Date
			order by order_id, Order_Date),
	cte2 as
			(select order_id, concat(product,', ', lead(product) over(partition by order_id order by order_id,product)) products
			from cte)
select products , count(products) bought_together from cte2
where products is not null
group by products
order by bought_together desc;

/*
Interpretation:
From the result, it's apparent that whenever a customer buys a new smartphone they are also most likely to buy a smartphone accessory with it.
And most of the times those accessories being charging cables and headphones
*/

-- Q5: What product sold the most? And why do you think it sold the most?
select product, sum(Quantity_Ordered) Total_quantity_sold
from sales
group by product
order by total_quantity_sold desc;

/*
Result and Interpretation:
AAA Batteries (4-pack), AA Batteries (4-pack) are the top most sold items. 
The reason being 
1. These batteries are used in wide range of products from remote control to wall clocks which means they are never out of demand
2. They are basically single use and they have relatively short lifespan, which means they are bought frequently than any other products

Next category in top most sold items are charging cables
The reason being
1. Phones became indispensable part of people's life, so do necessary smartphone accessories like charger and to some extend headphones. This inadvertently makes charger as indispensable as smartphones itself.
2. They don't usually last as long as smartphone itself, so they will be replaced frequently.
*/




































































