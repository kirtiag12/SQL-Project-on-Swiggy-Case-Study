create database swiggy;
use swiggy;

select*from delivery_partner;
select*from restaurants;
select*from food;
select*from menu;
select*from users;
select*from orders;
select*from order_details;

## Q-1 Find Customers who have never ordered.

select u.user_id, u.name , u.email, o.order_id
from users u
left join orders o
on u.user_id = o.user_id
where o.user_id is null;

## or
select user_id, name from users where user_id not in (select user_id from orders) ; 

## Q-2 Average price/dish.

select f.f_name,avg(m.price) as Avg_Price
from food f
inner join menu m
on f.f_id = m.f_id
group by f.f_name;

## Q-3 Find top restaurants in terms of numbers of orders for a given month.

select r.r_name , monthname(o.date) as month_name , count(o.order_id) as total_no_of_orders
from restaurants r
inner join orders o
on r.r_id = o.r_id
where monthname(o.date) like 'July'
group by r.r_name, month_name
order by total_no_of_orders desc
limit 1;

### Q-4 Restaurants with monthly sales > x.

select r.r_name, monthname(o.date) as month, sum(amount) as Revenue 
from restaurants r
inner join orders o
on r.r_id = o.r_id
where monthname(o.date) like 'June'
group by r.r_name, month 
having Revenue > 500;

## Q-5 Show all orders with order details for a particular customer in a particular date range.

select u.user_id , u.name , o.order_id , o.amount,o.date ,r.r_name, m.f_id , f.f_name
from users u
inner join orders o
on  u.user_id = o.user_id
inner join restaurants r
on o.r_id = r.r_id
inner join menu m
on r.r_id = m.r_id
inner join food f
on m.f_id = f.f_id
where o.date between '2022-06-25' and '2022-07-15' ;

## Q-6 Find restaurants with max repeated customers;

select r.r_name , o.user_id ,count(o.order_id) as no_of_orders
from orders o
inner join restaurants r
on o.r_id = r.r_id
group by r.r_name, o.user_id
having no_of_orders>1 
order by no_of_orders desc;

## Q-7 Month over month revenue growth of swiggy.

select* , monthname(date) as 'Month' from orders;

select month, ((revenue -prev)/prev)*100 as month_on_month_revenue_perc from (
with sales as(
select monthname(date) as month , sum(amount) as Revenue from orders group by month)
select month, revenue, lag(revenue,1)  over (order by revenue)  as prev from sales) t ;

## Q-8 Customer favourite food.

select u.name as name , f.f_name as dish ,count(f.f_id) as No_of_times
from users u
inner join orders o
on u.user_id = o.user_id
inner join restaurants r
on o.r_id = r.r_id
inner join menu m
on r.r_id = m.r_id
inner join food f
on m.f_id = f.f_id
group by u.name,f.f_name;

