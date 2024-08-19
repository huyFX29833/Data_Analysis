use mavenfuzzyfactory;

-- 7. Viết truy vấn thể hiện mức độ hiệu quả của các cặp sản phẩm được bán kèm
/* và đưa ra Nhận xét
- p4 là sản phẩm bán kèm có tỷ lệ cao nhất (~20%), đây cũng là sản phẩm có tỷ trọng bán chính thức thấp nhất
- độ tốt của các sặp sản phẩm bán kèm theo mức độ lần lượt từ cao xuống thấp là p1_p4, p1_p3 và p1_p2, p2_p4, p3_p4
*/
select
	orders.primary_product_id,
    count(distinct orders.order_id) as total_order,
    count(distinct case when order_items.product_id =1 and order_items.is_primary_item = 0 then orders.order_id else null end) as xsold_p1,
	count(distinct case when order_items.product_id =2 and order_items.is_primary_item = 0 then orders.order_id else null end) as xsold_p2,
    count(distinct case when order_items.product_id =3 and order_items.is_primary_item = 0 then orders.order_id else null end) as xsold_p3,
	count(distinct case when order_items.product_id =4 and order_items.is_primary_item = 0 then orders.order_id else null end) as xsold_p4,
    count(distinct case when order_items.product_id =1 and order_items.is_primary_item = 0 then orders.order_id else null end)
		/ count(distinct orders.order_id) as p1_sell_rt,
	count(distinct case when order_items.product_id =2 and order_items.is_primary_item = 0 then orders.order_id else null end)
		/ count(distinct orders.order_id) as p2_sell_rt,
    count(distinct case when order_items.product_id =3 and order_items.is_primary_item = 0 then orders.order_id else null end)
		/ count(distinct orders.order_id) as p3_sell_rt,
	count(distinct case when order_items.product_id =4 and order_items.is_primary_item = 0 then orders.order_id else null end)
		/ count(distinct orders.order_id) as p4_sell_rt
from orders
	left join order_items
		on orders.order_id = order_items.order_id
where orders.created_at > '2014-12-05'
group by 1
;