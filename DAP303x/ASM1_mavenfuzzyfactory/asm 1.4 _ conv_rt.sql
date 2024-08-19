use mavenfuzzyfactory;

-- 4.Viết truy vấn để hiển thị tỷ lệ chuyển đổi phiên thành đơn đặt hàng cho các đối tượng đã viết ở yêu cầu 3
/* và đưa ra Nhận xét:
- Tỷ lệ chuyển đổi phiên thành đơn đặt hàng tương đương nhau (~8,5%) ở cả tìm kiếm không phải trả tiền và quảng cáo có trả phí
- Các phiên truy cập trực tiếp có tỷ lệ chuyển đổi phiên thành đơn hàng thấp nhất (~7,75%)
- gsearch_nonbrand là kênh có tỷ lệ chuyển đổi cao nhất (~8,61%)
*/
select
	year(website_sessions.created_at) as yr,
    quarter(website_sessions.created_at) as mo,
	count(distinct case when utm_source = 'gsearch' and utm_campaign = 'nonbrand' then orders.website_session_id else null end)
		/ count(distinct case when utm_source = 'gsearch' and utm_campaign = 'nonbrand' then website_sessions.website_session_id else null end) as gsearch_nonbrand_conv_rt,
	count(distinct case when utm_source = 'bsearch' and utm_campaign = 'nonbrand' then orders.website_session_id else null end)
		/ count(distinct case when utm_source = 'bsearch' and utm_campaign = 'nonbrand' then website_sessions.website_session_id else null end) as bsearch_nonbrand_conv_rt,
	count(distinct case when utm_campaign = 'brand' then orders.website_session_id else null end) 
		/ count(distinct case when utm_campaign = 'brand' then website_sessions.website_session_id else null end) as brand_search_conv_rt,
	count(distinct case when utm_source is null and http_referer is not null then orders.website_session_id else null end) 
		/ count(distinct case when utm_source is null and http_referer is not null then website_sessions.website_session_id else null end) as organic_type_in_conv_rt,
	count(distinct case when utm_source is null and http_referer is null then orders.website_session_id else null end) 
		/ count(distinct case when utm_source is null and http_referer is null then website_sessions.website_session_id else null end) as direct_type_in_conv_rt
from website_sessions
	left join orders
		on website_sessions.website_session_id = orders.website_session_id
group by 1,2
;