select b.rider_id, c.first_name, c.last_name, c.city,d.cluster_name, a.attendancedate ,a.attendance_record, a.status,c.role
from  coreengine_riderattendance as a, coreengine_sfxrider as b, coreengine_riderprofile as c, coreengine_cluster as d
where a.rider_id=b.id and b.rider_id=c.id and b.cluster_id=d.id and a.attendancedate >= (curdate()-30) and  a.attendancedate <= curdate()
group by b.id, attendancedate



