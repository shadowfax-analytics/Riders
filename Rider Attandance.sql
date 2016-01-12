
select b.rider_id, c.first_name, c.last_name, c.city,d.cluster_name, a.attendancedate, a.actual_intime ,a.actual_outtime ,a.attendance_record, a.status,order_count, kilometer ,c.role
from  coreengine_riderattendance as a, coreengine_sfxrider as b, coreengine_riderprofile as c, coreengine_cluster as d
where a.rider_id=b.id and b.rider_id=c.id and b.cluster_id=d.id and a.attendancedate >= "20151101" and  a.attendancedate <= "20151110"  and c.city="BLR"
group by b.id, attendancedate
