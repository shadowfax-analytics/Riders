select b.rider_id, concat(first_name ," ", last_name) as Rider_name, 
case b.status
when 0 then 'Inactive'
when 1 then 'Active' end as Status,
case c.role
when 'PRT' then 'Part Time'
when 'FT' then 'Full Time' end as Rider_Role,
d.cluster_name as Cluster,
b.version as 'Rider App Version',
case c.city
when 'GGN' then 'Gurgaon'
when 'BOM' then 'Mumbai'
when 'DEL' then 'Delhi'
when 'BLR' then 'Bangalore'
when 'NOIDA' then 'Noida' end as City,
a.attendancedate as Attendance_Date,
convert_tz(a.expected_intime,"UTC","Asia/Kolkata") as Schedule_Intime,
convert_tz(a.expected_outtime,"UTC","Asia/Kolkata") as Schedule_Outtime,
case a.attendance_record 
when 0 then 'Not recorded'
when 1 then 'Intime recorded'
when 2 then 'both intime and outtime recorded' end as attendance_record ,
case a.status
when -1 then 'Not Marked'
when 0 then 'Present'
when 1 then 'LWA'
when 2 then 'LWOP'
when 5 then 'Weekly off' end as Is_Present,

b.id as Sfx_ID
from  coreengine_riderattendance a 
join coreengine_sfxrider b  on a.rider_id=b.id  
join coreengine_riderprofile c on b.rider_id=c.id
join coreengine_cluster  d on b.cluster_id=d.id
where d.cluster_name not like "%test%" and attendancedate>='20151207' and attendancedate='20151213'

