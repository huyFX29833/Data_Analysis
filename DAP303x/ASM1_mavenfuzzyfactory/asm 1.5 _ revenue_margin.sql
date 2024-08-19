use mavenfuzzyfactory;

-- 5. Viết truy vấn để thể hiện doanh thu và lợi nhuận
-- theo sản phẩm, tổng doanh thu, tổng lợi nhuận của tất cả các sản phẩm
/* select * from products; */
select
	year(created_at) as yr,
    month(created_at) as mo,
    sum(case when product_id = 1 then price_usd else null end) as mrFuzzy_rev,
    sum(case when product_id = 1 then price_usd else null end) - sum(case when product_id = 1 then cogs_usd else null end) as mrfuzzy_marg,
    sum(case when product_id = 2 then price_usd else null end) as loveBear_rev,
    sum(case when product_id = 2 then price_usd else null end) - sum(case when product_id = 2 then cogs_usd else null end) as loveBear_marg,
    sum(case when product_id = 3 then price_usd else null end) as bdayPanda_rev,
    sum(case when product_id = 3 then price_usd else null end) - sum(case when product_id = 3 then cogs_usd else null end) as bdayPanda_marg,
    sum(case when product_id = 4 then price_usd else null end) as miniBear_rev,
    sum(case when product_id = 4 then price_usd else null end) - sum(case when product_id = 4 then cogs_usd else null end) as miniBear_marg,
    sum(price_usd) as total_revenue,
    sum(price_usd) - sum(cogs_usd) as total_margin
from order_items
group by 1,2
;