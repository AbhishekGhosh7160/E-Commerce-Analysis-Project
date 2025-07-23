
#KPI1 : Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics
select * from olist_store_project.olist_orders_dataset;
select * from olist_store_project.olist_order_payments_dataset;

select
kpi1.day_end,
concat(kpi1.total_payment/(select sum(payment_value) from olist_order_payments_dataset)*100,2),'%' as percentage_values

from 
(select ord.day_end, sum(pmt.payment_values) as total_payments
from olist_order_payments_dataset as pmt
join
(select distinct order_id,
case
when weekday(order_purchase_timestamp) in (5,6) then "weekend"
else "weekday"
end as Day_end
from olist_orders_dataset) as ord
on ord.order_id = pmt.order_id
group by ord.day_end)as kpi1;

 select 
 case when dayofweek(STR_TO_DATE(o.order_purchase_timestamp,'%y.%a.%d'))
 IN (1,7) then 'weekend' else 'weekday' end as daytype,
 count(distinct o.order_id)as totalorders,
 round(sum(p.payment_value)) as totalpayments,
 round(avg(p.payment_value)) as averagepayment
 from
 orders_dataset o 
 join
 payments_dataset p on o.orders_id = p.order_id
 group by
 daytype;
 
 #KPI2 Number of Orders with review score 5 and payment type as credit card.
 
select 
count(pmt.order_id) as total_orders
from 
olist_order_payments_dataset pmt
inner join olist_order_reviews_dataset rev on pmt.order_id = rev.order_id
where
rev. review_score =5
and pmt.payment_type ='credit_card';

  #Average number of days taken for order_delivered_customer_date for pet_shop
 select 
 prod.product_category_name,
 round(Avg(datediff(ord.order_delivered_customer_date, ord.order_purchase_timestamp)),0) as Avg_delievry_days
 from olist_orders_dataset ord
 join
 (select product_id, order_id, product_category_name
 from olist_products_dataset
 join olist_order_items_dataset using (product_id)) as prod
 on ord.order_id= prod.order_id
where prod.product_category_name ="pet_shop"
group by prod.product_category_name;
 
 
  #kpi4 
  with orderitemavg as (
  select round(avg(item.price)) as avg_order_item_price
  from olist_order_items_dataset item
  join olist_orders_dataset ord
  on item.order_id = ord.order_id
  join olist_customers_dataset cust on ord.customer_id = cust.customer_id
  where cust.customer_city ="sao paulo"
  )
  select
  (select avg_order_item_price from orderitemavg ) as avg_order_item_price,
  round(avg(pmt.payment_value)) as avg_payment_values
  from olist_order_payments_dataset pmt
  join olist_orders_dataset ord on pmt.order_id = ord.order_id
  join olist_customers_dataset cust on ord.customer_id = cust.customer_id
  where cust.customer_city ="sao paulo";
  
 #KPI 5  Relationship between shipping days 
 #(order_delivered_customer_date -order_purchase_timestamp) Vs review scores.
 
 select 
 rew.review_score,
 round(avg(datediff(ord.order_delivered_customer_date , order_purchase_timestamp)),0) as "Avg shpping days"
 from olist_orders_dataset as ord
 join olist_order_reviews_dataset as rew on rew.order_id = ord.order_id
 group by rew.review_score
 order by rew.review_score;
 
 
  
 
 