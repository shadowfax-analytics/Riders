select a.id ,a.order_date ,a.seller_id , b.store_name as Store_Name,
b.store_type , b.industry, a.order_time , a.cancel_reason ,a.source ,
d.cluster_name as Cluster_Name,a.order_date,c.id as Sellerid
from coreengine_order a
join coreengine_sfxseller c on c.id = a.seller_id
join coreengine_sellerprofile b on b.id = c.seller_id
join coreengine_cluster d on d.id = c.cluster_id
where a.order_date>='20151001' and a.order_date<='20151031'

