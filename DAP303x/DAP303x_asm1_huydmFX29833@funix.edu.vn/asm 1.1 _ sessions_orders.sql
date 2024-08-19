use mavenfuzzyfactory;

-- 1. Viết các truy vấn để cho thấy sự tăng trưởng về mặt số lượng trong website
/* và đưa ra Nhận xét:
- Q2.2012 có số lượng truy cập và đơn hàng tăng cao hơn nhiều so với Q1.2012 => có thể dữ liệu Q1 chưa đầy đủ, cần kiểm tra lại bộ dữ liệu trước khi đưa ra kết luận về sự tăng trưởng
- Trong Q3.2012 số đơn hàng đã tăng gấp đôi so với Q2.2012, lượng truy cập chỉ tăng gấp rưỡi
- Số lượng truy cập bắt đầu tăng mạnh từ Q4.2013 và liên tục tăng tới Q1.2015 mới giảm nhẹ
- Lượng truy cập và đơn hàng cao nhất vào Q4.2014
*/
select
	year(website_sessions.created_at) as yr,
    quarter(website_sessions.created_at) as qrt,
    count(distinct website_sessions.website_session_id) as sessions,
    count(distinct orders.website_session_id) as orders
from website_sessions
	left join orders
		on website_sessions.website_session_id = orders.website_session_id
group by 1,2
;
