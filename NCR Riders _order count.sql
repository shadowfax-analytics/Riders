select  c.city  ,d.rider_id,d.id as sfx_id ,concat(f.first_name,' ',f.last_name) as 'Rider_Name', f.trainee_id,f.personal_phone,d.allotted_phone, c.cluster_name,d.date_of_join ,a.id as Order_id,a.order_date as Order_Date,
 c.city
from coreengine_order a
join coreengine_sfxseller e on a.seller_id = e.id
join coreengine_sellerprofile b on e.seller_id = b.id
join coreengine_cluster c on a.cluster_id = c.id
join coreengine_sfxrider d on a.rider_id = d.id
join coreengine_riderprofile f on d.rider_id = f.id
where d.rider_id!=1 and date(a.order_time)>='2015-12-15' and date(a.order_time)<='2015-12-31' and c.city!='BOM'  and c.city!='BLR' and c.cluster_name not like "%test%" and a.status!= 302 order by c.city, rider_id ,Order_Date