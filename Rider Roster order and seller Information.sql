select a.id  ,a.seller_id , b.store_name as Store_Name, date(convert_tz(a.order_time,"UTC","Asia/Kolkata")) as order_date  ,
b.store_type , b.industry,time(convert_tz(a.order_time,"UTC","Asia/Kolkata") )as order_time ,


case a.cancel_reason 
when 0 then'Order Cancelled by Consumer'
when 1 then 'No Rider Assigned'
when 2 then 'Rider late for pickup'
when 3 then 'Double Order Punched'
when 4 then  'No reason specified'
when -1 then  'Not Cancelled' end as cancel_reason ,

case a.source 
when 0 then'seller_Portal' 
when 1 then 'manager_new'
when 2 then 'manager_old'
when 3 then'bulk_upload'
when 4 then 'API_Integration'
when 5 then 'OneClick'
when 6 then 'RequestRider'
when 7 then 'PickupDrop'
when 8 then 'PickupDropApis' 
end as source 
,
d.cluster_name as Cluster_Name,a.order_date,c.id as Sellerid
from coreengine_order a
join coreengine_sfxseller c on c.id = a.seller_id
join coreengine_sellerprofile b on b.id = c.seller_id
join coreengine_cluster d on d.id = c.cluster_id 
where a.order_date>=subdate(curdate(),interval 7 day) and a.order_date<=curdate() and d.city="BLR"
order by a.order_date, seller_id