select a.rider_id,a.attendancedate,concat(c.first_name," ",c.last_name) as Name,

b.allotted_phone,b.status as activity_status,

(case when b.status = 0 then 'InActive' when b.status = 1 then 'Active' end) as Active_Status,

d.cluster_name,c.role,a.actual_intime,a.actual_outtime,

(case when hour(timediff(a.actual_outtime,a.actual_intime))> 15 and c.role = 'FT'

then 100 when hour(timediff(a.actual_outtime,a.actual_intime))> 9 and c.role = 'FT'

then (hour(timediff(a.actual_outtime,a.actual_intime)) - 9)

when hour(timediff(a.actual_outtime,a.actual_intime)) > 10 and c.role = 'PRT'

then 100 when hour(timediff(a.actual_outtime,a.actual_intime)) > 4 and c.role = 'PRT'

then (hour(timediff(a.actual_outtime,a.actual_intime)) - 4 ) end) as Overtime

from coreengine_riderattendance a 

join coreengine_sfxrider b on a.rider_id = b.id

join coreengine_riderprofile c on c.id = b.rider_id

join coreengine_cluster d on d.id = b.cluster_id

where d.city <> 'BOM' and d.city <> 'BLR' and d.cluster_name <> 'TestCluster'

and b.status = 1 and a.attendance_record =2

and date(a.actual_intime) >= curdate() - interval 1 day and date(a.actual_intime)< curdate()

and a.actual_intime < a.actual_outtime

order by 1,2