select a.id as Order_id,a.order_date as Order_Date,
a.seller_id as Seller_id,b.store_name as Store_Name,
case c.city
when 'GGN' then 'Gurgaon'
when 'BOM' then 'Mumbai'
when 'DEL' then 'Delhi'
when 'BLR' then 'Bangalore'
when 'NOIDA' then 'Noida' end as City,
a.cluster_id as Cluster_id,c.cluster_name as Cluster_Name,
a.rider_id as Rider_id,d.version as Version,
convert_tz(a.order_time,"UTC","Asia/Kolkata") as Order_time,
convert_tz(a.allot_time,"UTC","Asia/Kolkata") as Allot_time,
convert_tz(a.accept_time,"UTC","Asia/Kolkata") as Accept_time,
convert_tz(a.pickup_time,"UTC","Asia/Kolkata") as Pickup_time,
convert_tz(a.delivered_time,"UTC","Asia/Kolkata") as Delivered_time,
case a.issue
when 0 then 'Delivery boy not allotted'
when 1 then 'Delivery Boy not reached'
when 2 then 'Delivery Boy misbehaved'
when 3 then 'Cash amount not returned'
when 4 then 'Delivery delayed'
when 5 then 'Others'
when -1 then 'No issue' end as Issue,
case a.status
when 1 then 'Allotted'
when 2 then 'Message Received'
when 3 then 'Accepted By Rider'
when 4 then 'Collected'
when 5 then 'Delivered'
when 302 then 'Cancelled'
when 403 then 'Rider Deleted Order'
when 503 then 'Rider Rejected Order'
when 404 then 'No Rider Found' end as Current_Status,
case a.cancel_reason
when 0 then 'Order cancelled by Consumer'
when 1 then 'No rider assigned'
when 2 then 'Rider late for pickup'
when 3 then 'Double order punched'
when 4 then 'No reason specified'
when -1 then 'Not cancelled' end as Cancelled_reason,
case a.accepted_flag
when 0 then 'Manager'
when 1 then 'Rider' end as accepted_status_changed_by,
case a.pickup_flag
when 0 then 'Manager'
when 1 then 'Rider' end as Pickedup_status_changed_by,
case a.delivered_flag
when 0 then 'Manager'
when 1 then 'Rider' end as Delivered_status_changed_by
from coreengine_order a 
join coreengine_sellerprofile b on a.seller_id = b.id
join coreengine_cluster c on a.cluster_id = c.id 
join coreengine_sfxrider d on a.rider_id = d.rider_id
where a.order_date = curdate()-1