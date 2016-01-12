select b.rider_id, concat(first_name ," ", last_name) as Rider_name, 
case b.status
when 0 then 'Inactive'
when 1 then 'Active' end as Status,
case c.role
when 'PRT' then 'Part Time'
when 'FT' then 'Full Time' end as Rider_Role,
cluster_name as Cluster,
case c.city
when 'GGN' then 'Gurgaon'
when 'BOM' then 'Mumbai'
when 'DEL' then 'Delhi'
when 'BLR' then 'Bangalore'
when 'NOIDA' then 'Noida' end as City,
attendancedate as Attendance_Date,
convert_tz(a.expected_intime,"UTC","Asia/Kolkata") as Schedule_Intime,
convert_tz(a.expected_outtime,"UTC","Asia/Kolkata") as Schedule_Outtime,
convert_tz(a.actual_intime,"UTC","Asia/Kolkata") as Actual_Intime, 
convert_tz(a.actual_outtime,"UTC","Asia/Kolkata") as Actual_Outime,
case e.event_type
when 0 then 'logged out'
when 1 then 'logged in' end as 'login status',
case a.attendance_record 
when 0 then 'Not recorded'
when 1 then 'Intime recorded'
when 2 then 'both intime and outtime recorded' end as attendance_record ,
case a.status
when -1 then 'Not Marked'
 when 0 then 'Present'
 when 1 then 'LWA'
 when 2 then 'LWOP'
 when 5 then 'Weekly off' end as Is_Present 
 from  coreengine_riderattendance as a, 
 coreengine_sfxrider as b, 
 coreengine_riderprofile as c, 
 coreengine_cluster as d,
 coreengine_riderlogin as e
 where a.rider_id=b.id and b.rider_id=c.id and b.cluster_id=d.id and a.rider_id = e.rider_id and cluster_name not like "%test%" and attendancedate = curdate()