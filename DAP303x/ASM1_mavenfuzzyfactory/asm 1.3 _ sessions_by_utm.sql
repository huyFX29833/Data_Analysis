use mavenfuzzyfactory;

-- 3. Viết truy vấn để hiển thị sự phát triển của các đối tượng khác nhau
/* và đưa ra Nhận xét:
- Các đơn hàng chủ yếu đến từ quảng cáo gsearch_nonbrand (tỷ trọng cao nhất)
- Các đơn hàng đến từ tìm kiếm không phải trả tiền cao hơn các đơn hàng từ truy cập trực tiếp
*/
select
	year(website_sessions.created_at) as yr,
    quarter(website_sessions.created_at) as mo,
	count(distinct
		case when utm_source = 'gsearch' and utm_campaign = 'nonbrand' then orders.website_session_id else null end) as gsearch_nonbrand_orders,
	count(distinct
		case when utm_source = 'bsearch' and utm_campaign = 'nonbrand' then orders.website_session_id else null end) as bsearch_nonbrand_orders,
	count(distinct
		case when utm_campaign = 'brand' then orders.website_session_id else null end) as brand_search_orders,
	count(distinct
		case when utm_source is null and http_referer is not null then orders.website_session_id else null end) as organic_type_in_orders,
	count(distinct
		case when utm_source is null and http_referer is null then orders.website_session_id else null end) as direct_type_in_orders
from website_sessions
	left join orders
		on website_sessions.website_session_id = orders.website_session_id
group by 1,2
;