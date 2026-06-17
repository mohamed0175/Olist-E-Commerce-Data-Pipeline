use Ecommerce_OLTP

select p.product_id,
	   p.product_category_name,
	   p.product_category_name_english,
	   p.product_weight_g,
	   p.product_length_cm,
	   p.product_height_cm,
	   p.product_width_cm
from products p

select c.customer_id,
	   c.zip_code_prefix,
	   c.lat,
	   c.lng,
	   c.city,
	   c.[state]
from customers c

select s.seller_id,
	   s.zip_code_prefix,
	   s.lat,
	   s.lng,
	   s.city,
	   s.[state]
from sellers s

select o.review_id,
	   o.review_score,
	   o.review_creation_date
from order_reviews o


use EcommerceDWH

select o.order_review_SK, o.review_id
from dim_order_review o

use Ecommerce_OLTP

select oi.order_id,
	   oi.order_item_id,
	   oi.product_id,
	   oi.seller_id,
	   o.customer_id,
	   oo.review_id,
	   o.order_purchase_timestamp,
	   oi.price,
	   oi.freight_value,
	   o.order_status
from order_items oi
inner join orders o
on oi.order_id = o.order_id
left join order_reviews oo
on o.order_id = oo.order_id

use EcommerceDWH

SELECT COUNT(*) AS new_count
FROM Ecommerce_OLTP.dbo.order_reviews
WHERE review_id NOT IN (
    SELECT review_id FROM EcommerceDWH.dbo.dim_order_review
)


use EcommerceDWH

select * from fact_orders


SELECT COUNT(*)
FROM Ecommerce_OLTP.dbo.orders o
JOIN Ecommerce_OLTP.dbo.order_items oi
    ON o.order_id = oi.order_id
WHERE NOT EXISTS (
    SELECT 1
    FROM EcommerceDWH.dbo.fact_orders f
    WHERE f.order_id   = o.order_id
      AND f.item_id    = oi.order_item_id
)

