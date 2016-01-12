select sfr.id as sfx_id,rp.id as 'Rider_ID',concat(rp.first_name,' ',rp.last_name) as 'Rider_Name',
sfr.cluster_id,c.cluster_name,c.city,c.operational_city,sfr.manager_id,concat(m.first_name,' ',m.last_name)
as 'Manager Name',sfr.date_of_join as 'DOJ',rp.date_of_birth as 'DOB'
from coreengine_sfxrider sfr,coreengine_riderprofile rp,coreengine_cluster c,auth_user as m
where sfr.rider_id = rp.id and sfr.manager_id = m.id and sfr.cluster_id = c.id
and sfr.status = 1 and c.cluster_name not like "%test%";
