select a.id RiderProfileId,b.id as SFXRiderId,attendancedate,concat(a.first_name,' ',a.last_name)NameOfRider,b.allotted_phone as AllottedPhone,
          a.personal_phone as PersonalPhone,a.date_of_birth as DateOfBirth,b.date_of_join as DateOfJoin,a.father_name as FatherName,
          b.status as Status,c.city as City,c.cluster_name as ClusterName,a.bank as BankName,a.IFSC as IFSC_Code,a.account_number as AccountNumber,
          a.role as Role,
          a.fixed_salary as FixedSalary,e.status as RiderAttendanceStatus,(case when hour(timediff(e.actual_outtime,e.actual_intime))> 9 and 
          a.role = "FT" then (hour(timediff(e.actual_outtime,e.actual_intime)) - 9) end)FT_Overtime,
          (case when hour(timediff(e.actual_outtime,e.actual_intime)) > 4 and a.role = "PRT" then (hour(timediff(e.actual_outtime,e.actual_intime)) - 4) end)PRT_Overtime,e.attendance_record
          from coreengine_riderprofile a inner join coreengine_sfxrider b on a.id=b.rider_id inner join coreengine_cluster c on 
          b.cluster_id=c.id inner join coreengine_riderattendance e on b.id=e.rider_id 
          where attendancedate between "20151201" and curdate() and cluster_name not like "%Test%"