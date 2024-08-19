use mavenfuzzyfactory;

-- 6. Viết truy vấn để tìm hiểu tác động của sản phẩm mới
/* và đưa ra Nhận xét:
- lưu lượng truy cập, đơn hàng tăng dần qua các năm
- lượng truy cập và tỷ lệ truy cập thành đơn hàng tăng dần trong năm => khách hàng có xu hướng truy cập và đặt đơn hàng vào dịp cuối năm
*/
create temporary table ss_flag
select
	ss_pd.website_session_id,
	ss_pd.created_at,
    ss_pd.website_pageview_id,
    case when max(website_pageviews.website_pageview_id) > ss_pd.website_pageview_id then 1 else 0 end as flag
from(
select
	website_pageviews.website_pageview_id,
    website_pageviews.created_at,
    website_pageviews.website_session_id
from website_pageviews
where pageview_url = '/products'
) as ss_pd
	left join website_pageviews
		on ss_pd.website_session_id = website_pageviews.website_session_id
		and website_pageviews.website_pageview_id >= ss_pd.website_pageview_id
group by 1,2,3;
select
	year(ss_flag.created_at) as yr, month(ss_flag.created_at) as mo,
    count(distinct ss_flag.website_session_id) as sessions_to_product_page,
    count(distinct case when ss_flag.flag = 1 then ss_flag.website_session_id else null end) as click_to_next,
    count(distinct case when ss_flag.flag = 1 then ss_flag.website_session_id else null end) / count(distinct ss_flag.website_session_id) as clickthrough_rt,
    count(distinct case when orders.order_id is not null then ss_flag.website_session_id else null end) as orders,
    count(distinct case when orders.order_id is not null then ss_flag.website_session_id else null end) / count(distinct ss_flag.website_session_id) as products_to_order_rt
from ss_flag
	left join orders
		on ss_flag.website_session_id = orders.website_session_id
group by 1,2;