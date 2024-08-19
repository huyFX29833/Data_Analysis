use mavenfuzzyfactory;

-- 2. Viết các truy vấn để thể hiện hiện được hiệu quả hoạt động của công ty
/* và đưa ra Nhận xét:
- Tỷ lệ đơn hàng trên lượt truy cập tăng dần qua các Quý, đặc biệt có sự tăng nhanh trong Q1.2013
- Doanh thu trung bình trên mỗi đơn đặt hàng nhìn chung có tăng nhẹ, tăng mạnh nhất trong Q1.2014
nhưng đang có xu hướng giảm nhẹ từ Q4.2014 tới nay (Q1.2015)
- Doanh thu trung bình theo phiên truy cập nhìn chung có xu hướng tăng dần
*/
select
	year(website_sessions.created_at) as yr,
    quarter(website_sessions.created_at) as qrt,
    count(distinct orders.website_session_id)
		/ count(distinct website_sessions.website_session_id) as session_to_order_conv_rate,
	sum(orders.price_usd)
		/ count(distinct orders.website_session_id) as revenue_per_order,
	sum(orders.price_usd)
		/ count(distinct website_sessions.website_session_id) as revenue_per_session
from website_sessions
	left join orders
		on website_sessions.website_session_id = orders.website_session_id
group by 1,2
;
