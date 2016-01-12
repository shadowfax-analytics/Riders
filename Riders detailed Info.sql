select a.*,  b.status,b.date_of_join, cluster_name ,a.city
from coreengine_riderprofile as a 
inner join coreengine_sfxrider as b
on a.id= b.rider_id
inner join coreengine_cluster as c
on b.cluster_id= c.id
where b.status= 0 and c.cluster_name <> 'gurgaon'
and c.cluster_name <> 'TestCluster'
and a.city <> 'BOM' and a.city <> 'BLR'
