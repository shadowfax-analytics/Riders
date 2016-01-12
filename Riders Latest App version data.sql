select b.rider_id,b.id as sfx_id,first_name,last_name,c.city,version,latest_app_version,cluster_name,b.status,allotted_phone 

from coreengine_riderprofile a inner join coreengine_sfxrider b on a.id=b.rider_id inner join coreengine_cluster c on b.cluster_id=c.id 

