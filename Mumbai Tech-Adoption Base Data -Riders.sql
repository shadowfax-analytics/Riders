select tab1.rider_id as Rider_ID,tab1.Rider_name as 'RiderName',tab1.Cluster as 'Cluster',
tab1.Attendance_Date as 'Date',tab1.Weekly_off as 'Weekly_off',tab1.Attendance as 'Attendance',
tab1.Schedule_Intime as 'Schedule_Intime',tab1.Schedule_Outtime as 'Schedule_Outtime',
tab2.In_Time1 as 'Actual_Intime',tab2.Out_Time1 as 'Actual_Outtime' from
(select b.rider_id, concat(first_name ," ", last_name) as Rider_name, 
case c.role
when 'PRT' then 'Part Time'
when 'FT' then 'Full Time' end as Rider_Role,
d.cluster_name as Cluster,
a.attendancedate as Attendance_Date,
case a.attendance_record 
when 0 then 'Not recorded'
when 1 then 'Intime recorded'
when 2 then 'both intime and outtime recorded' end as attendance_record ,
case a.status
when 5 then 'Yes'
else 'No' end as 'Weekly_off',
case a.status
when -1 then 'Not Marked'
when 0 then 'Present'
when 1 then 'LWA'
when 2 then 'LWOP'
when 5 then 'Weekly off' end as Attendance,
convert_tz(a.expected_intime,"UTC","Asia/Kolkata") as Schedule_Intime,
convert_tz(a.expected_outtime,"UTC","Asia/Kolkata") as Schedule_Outtime,
b.id as Sfx_ID
from  coreengine_riderattendance a 
join coreengine_sfxrider b  on a.rider_id=b.id  
join coreengine_riderprofile c on b.rider_id=c.id
join coreengine_cluster  d on b.cluster_id=d.id
where d.cluster_name not like "%test%" and attendancedate = '2015-12-25' and b.status = 1 and d.city = 'BOM') as tab1 left outer join
(select intt.rider_id as Rider_ID,convert_tz(intt.in_time,"UTC","Asia/Kolkata") as In_Time1,convert_tz(outt.out_time,"UTC","Asia/Kolkata") as Out_Time1,intt.in_time,outt.out_time from (
select * from coreengine_ridersession where id in (select a.id as id from coreengine_ridersession a,coreengine_riderattendance b where a.rider_id = b.rider_id and date(convert_tz(a.in_time,"UTC","Asia/Kolkata")) = '2015-12-25' and date(convert_tz(b.attendancedate,"UTC","Asia/Kolkata")) = '2015-12-25' order by a.rider_id,abs(convert_tz(a.in_time,"UTC","Asia/Kolkata") - convert_tz(b.expected_intime,"UTC","Asia/kolkata"))) group by rider_id) as intt inner join 
(select * from coreengine_ridersession where id in (select a.id as id from coreengine_ridersession a,coreengine_riderattendance b where a.rider_id = b.rider_id and date(convert_tz(a.in_time,"UTC","Asia/Kolkata")) = '2015-12-25' and date(convert_tz(b.attendancedate,"UTC","Asia/Kolkata")) = '2015-12-25' order by a.rider_id,abs(convert_tz(a.out_time,"UTC","Asia/Kolkata") - convert_tz(b.expected_outtime,"UTC","Asia/kolkata"))) group by rider_id) as outt on intt.rider_id = outt.rider_id) 
as tab2 on tab1.Sfx_ID = tab2.Rider_ID
