select b.rider_id,b.id as sfx_id,first_name,last_name,c.city,version,cluster_name, case b.status when 1 then 'active' 
 when 0 then 'Inactive'end as status  ,allotted_phone 
from coreengine_riderprofile a
 inner join coreengine_sfxrider b on a.id=b.rider_id
 inner join coreengine_cluster c on b.cluster_id=c.id 
where c.city="BOM" and b.status=1 and
 cluster_name not like '%Test%'


