select a.rider_id,a.attendancedate,
(case when a.attendance_record = 0 
then '6' else a.status end) as Attendence_Record,b.status as Active_status,b.date_of_join,
concat(c.first_name," ",c.last_name) as Name,c.role,d.cluster_name,a.attendance_record
from coreengine_riderattendance a 
join coreengine_sfxrider b on a.rider_id = b.id
join coreengine_riderprofile c on c.id = b.rider_id
join coreengine_cluster d on d.id = b.cluster_id
where c.city='BLR' and a.attendancedate>="20151101" and a.attendancedate<="20151111"
