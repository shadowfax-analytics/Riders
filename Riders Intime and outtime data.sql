select b.id,concat(c.first_name," ",c.last_name)as Name,b.allotted_phone,c.role,
(case when b.status =1 then'active' else'inactive' end ) Status,a.attendancedate,
d.cluster_name,a.actual_intime,a.actual_outtime
from coreengine_riderattendance a
join coreengine_sfxrider b on a.rider_id = b.id
join coreengine_riderprofile c on c.id = b.rider_id
join coreengine_cluster d on d.id = b.cluster_id
where a.status = 0 and b.status = 1  and c.city <>'BLR' and c.city <>'BOM'
and a.attendancedate >= '2015-09-01'
