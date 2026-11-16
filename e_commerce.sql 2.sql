create table details(
	Order_ID Varchar(20),
	Amount numeric,
	Profit numeric,
	Quantity numeric,
	Category varchar(20),
	Sub_Category  varchar(20),
	PaymentMode  varchar(20)

)

create table orders(
	Order_ID varchar(20),
	Order_Date date,
	CustomerName varchar(50),
	State varchar(30),
	City varchar(30)

)
 select * from orders
 select * from details

--question 1--
select o.state,
sum(d.amount) as total_sale,
sum(d.profit) as total_profit,
sum(d.quantity) as total_quantity,
rank() over(order by sum(d.amount) desc) as ranks
from orders o
join details d
on o.order_id=d.order_id
group by o.state
order by total_sale desc

-- question 2--
with ranked_category as (
 select category,sub_category,
 sum(profit) as total_profit,
 rank() over(partition by category order by sum(profit) desc) as ranks
 from details
 group by category,sub_category
)
select * from ranked_category
where ranks <=3

-- question 3--
with state_wise_performance as (
 select o.state,o.customername,
 count(d.order_id) as total_order,
 rank() over(partition by o.state order by count(o.order_id) desc) as ranks
 from orders o
 join details d
 on o.order_id=d.order_id
 group by o.state,o.customername
)
select * from state_wise_performance
where ranks <=5

--question 4--
with customer_performance as(
	select o.customername,
	sum(d.amount) as total_sale
	from orders o
	join details d
	on o.order_id=d.order_id
	group by o.customername
	
)
select * from customer_performance
where total_sale> (select avg(total_sale) from customer_performance)

-- question 5--
with state_wise_customer as (
 select o.state,o.customername,
 sum(d.amount) as total_sale,
 rank() over(partition by o.state order by sum(d.amount) desc) as ranks
 from orders o
 join details d
 on o.order_id=d.order_id
 group by o.state,o.customername
)
select * from state_wise_customer
where ranks <=3

--question 6--
with city_performance as (
 select o.state,o.city,
 sum(d.amount) as total_sale,
 rank() over(partition by o.state order by sum(d.amount) desc) as ranks
 from orders o
 join details d
 on o.order_id=d.order_id
 group by o.state,o.city
)
select * from city_performance
where ranks =2

-- question 7--
with paymentmode_performance as (
 select o.state,d.PaymentMode,
 sum(d.amount) as total_sale,
 rank() over(partition by o.state order by sum(d.amount) desc) as ranks
 from orders o
 join details d
 on o.order_id=d.order_id
 group by o.state,d.PaymentMode
)
select * from paymentmode_performance
where ranks <=2

-- question 8--
with state_performance as (
select o.state,
sum(d.amount) as total_amount,
sum(d.profit) as total_profit
from orders o
join details d
on o.order_id=d.order_id
group by o.state
)
select * from state_performance
where total_amount > (select avg(total_amount) from state_performance) and
total_profit < (select avg(total_profit) from state_performance)
order by total_amount desc

-- question 9--
with state_sales as(
 select o.state,
 sum(d.amount) as total_amount
 from orders o
 join details d
 on o.order_id=d.order_id
 group by o.state
)
select *,
total_amount * 100 / sum(total_amount) over() as total_sales_contribution
from state_sales







 

 


 