select b.rider_id, concat(first_name ," ", last_name) as Rider_name, cluster_name,c.city, attendancedate ,convert_tz(a.actual_intime,"UTC","Asia/Kolkata") as Actual_Intime , convert_tz(a.actual_outtime,"UTC","Asia/Kolkata") as Actual_Outime ,time(timediff(convert_tz(a.actual_outtime,"UTC","Asia/Kolkata"),convert_tz(a.actual_intime,"UTC","Asia/Kolkata"))) as Hour  
, case a.attendance_record 
when 0 then 'Not recorded'
when 1 then 'Intime recorded'
when 2 then 'both intime and outtime recorded' end as attendance_record ,
case a.status
when -1 then 'Not Marked'
 when 0 then 'Present'
 when 1 then 'LWA'
 when 2 then 'LWOP'
 when 5 then 'Weekly off' end as status ,
order_count, kilometer ,(kilometer/order_count) as km_per_order,a.SOP_adherence ,c.role from  coreengine_riderattendance as a, coreengine_sfxrider as b, coreengine_riderprofile as c, coreengine_cluster as d where a.rider_id=b.id and b.rider_id=c.id and b.cluster_id=d.id and c.city ='BLR' and cluster_name not like "%test%" and attendancedate >='20151221' and attendancedate <='20151227' group by a.attendancedate , b.rider_id







