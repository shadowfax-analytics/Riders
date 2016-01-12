select  count(a.rider_id) as order_count,b.first_name,b.last_name,
a.rider_id, c.date_of_join,d.cluster_name ,d.city
from ebdb.coreengine_riderattendance a 
join ebdb.coreengine_riderprofile b on a.rider_id = b.id
join ebdb.coreengine_sfxrider c on c.rider_id = b.id
join ebdb.coreengine_cluster  d on d.id = c.cluster_id
where a.attendancedate <='2015-08-23' and a.attendance_record = 2
and a.status = 0
and a.order_count <= 2
group by a.rider_id
having count(a.rider_id) > 2
