select * from (select a.rider_id,b.first_name,b.last_name,
sum(a.kilometer) as km_travelled,b.ifsc,b.account_number,
sum(a.order_count) as order_delivered
,d.allotted_phone,c.cluster_name,count(a.status) as days_present
from ebdb.coreengine_riderprofile b
join ebdb.coreengine_sfxrider d on d.rider_id = b.id
join ebdb.coreengine_riderattendance a on a.rider_id=d.id
join ebdb.coreengine_cluster c on c.id = d.cluster_id
where a.attendancedate <= '2015-08-30' and
a.attendancedate >= '2015-08-24' and a.status != 2 and a.status = 0
group by a.rider_id
order by sum(a.order_count)) aa where aa.order_delivered >= 20
