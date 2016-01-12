#Leakage Point 1
#% of orders coming through manager portal - old
#% of orders coming through manager portal - new
select (sum(case when a.source=2 then 1 else 0 end)*100/count(*))PercManagerOld,
(sum(case when a.source=1 then 1 else 0 end)*100/count(*))PercManagerNew
from coreengine_order a
where date(order_time)="20151117" and status !=302;

#% of old merchants placing < 10% of orders through portal              (old merchant: date_active > 30 days)
#% of old merchants placing > 50% of orders through portal
#% of old merchants placing > 90% of orders through portal
#% of new merchants placing < 10% of orders through portal            (new merchant: date_active <= 30 days)
#% of new merchants placing > 50% of orders through portal
#% of new merchants placing > 90% of orders through portal
select (sum(case when a.PercOrders<10 then 1 else 0 end)*100/count(*))LessThan10PercOrdersOld,
(sum(case when a.PercOrders between 50 and 90 then 1 else 0 end)*100/count(*))Btw50and90PercOrdersOld,
(sum(case when a.PercOrders>90 then 1 else 0 end)*100/count(*))Greater90PercOrdersOld,
(sum(case when b.PercOrders<10 then 1 else 0 end)*100/count(*))LessThan10PercOrdersNew,
 (sum(case when b.PercOrders between 50 and 90 then 1 else 0 end)*100/count(*))Btw50and90PercOrdersNew,
(sum(case when b.PercOrders>90 then 1 else 0 end)*100/count(*))Greater90PercOrdersNew
from
(select a.seller_id as SellerId, (sum(case when source in (0,3,4,5,6,7,8) then 1 else 0 end)*100/count(*))PercOrders
from coreengine_order a
inner join
coreengine_sfxseller b
on a.seller_id=b.id
where curdate()-date_active>30 and date(order_time)="20151117" and a.status !=302
group by 1)a,
(select a.seller_id as SellerId, (sum(case when source in (0,3,4,5,6,7,8) then 1 else 0 end)*100/count(*))PercOrders
from coreengine_order a
inner join
coreengine_sfxseller b
on a.seller_id=b.id
where curdate()-date_active<=30 and date(order_time)="20151117" and a.status !=302
group by 1)b;

#% of merchant assigned to each portal type
select description,count(*)*100/(select count(*)TotalSellers from coreengine_sfxseller_features)PercSellers
from
coreengine_sfxseller_features a
inner join coreengine_feature b
on a.feature_id=b.id
group by 1;


#Leakage Point 2
#% of orders with allot time > 5 mins 
#% of orders with allot time > 10 mins 
#% of orders with delivered status marked by manager within 10 mins post allotment (allot time < 10 mins)
#% of orders with delivered status marked by manager within 10 mins post allotment (allot time >= 10 mins)
#% of orders with delivered status marked by manager after 60 mins post allotment (allot time < 10 mins)
#% of orders with delivered status marked by manager after 60 mins post allotment (allot time >= 10 mins)
select sum(case when timestampdiff(minute,order_time,allot_time) between 5 and 10 then 1 else 0 end)*100/count(*)PercOrderAllot5_10,
sum(case when timestampdiff(minute,order_time,allot_time)>=10 then 1 else 0 end)*100/count(*)PercOrderAllotMoreThan10Min,
sum(case when delivered_flag='2' and  timestampdiff(minute,order_time,allot_time) < 10 and 
timestampdiff(minute,allot_time,delivered_time) < 10 then 1 else 0 end)*100/count(*)PercOrderDelByMan_Within10_AllottedWihtin10Min,
sum(case when delivered_flag='2' and  timestampdiff(minute,order_time,allot_time) >= 10 and 
timestampdiff(minute,allot_time,delivered_time) < 10 then 1 else 0 end)*100/count(*)PercOrderDelByMan_Within10_AllottedMore10Min,
sum(case when delivered_flag='2' and  timestampdiff(minute,order_time,allot_time) < 10 and 
timestampdiff(minute,allot_time,delivered_time) > 60 then 1 else 0 end)*100/count(*)PercOrderDelByMan_After60_AllottedWithin10Min,
sum(case when delivered_flag='2' and  timestampdiff(minute,order_time,allot_time) >= 10 and 
timestampdiff(minute,allot_time,delivered_time) >60 then 1 else 0 end)*100/count(*)PercOrderDelByMan_After60_AllottedMore10Min
from
coreengine_order
where source in (0,3,4,5,6,7,8) and date(order_time)="20151117" and status !=302;

/*% of managers with allot time > 10 mins for < 10% of orders 
% of managers with allot time > 10 mins for > 50% of orders 
% of managers with allot time > 10 mins for > 90% of orders 
% of managers with < 10% orders with delivered status marked by manager within 10 mins post allotment (allot time < 10 mins)
% of managers with > 50% orders with delivered status marked by manager within 10 mins post allotment (allot time < 10 mins)*/
select sum(case when k.PercOrder >90 then 1 else 0 end)*100/count(*)ordermorethan90_lessthan10min,
sum(case when k.PercOrder between 50 and 90 then 1 else 0 end)*100/count(*)orderbetween50_90_lessthan10min,
sum(case when k.PercOrder <10 then 1 else 0 end)*100/count(*)orderlessthan10_lessthan10min,
sum(case when k.Percorderten <10 then 1 else 0 end)*100/count(*)managermarked_orderwithin10min_lessthan10perorder,
sum(case when k.Percorderten >50 then 1 else 0 end)*100/count(*)managermarked_orderwithin10min_morethan50perorder
from
(select cluster_id,
sum(case when timestampdiff(minute,order_time,allot_time)>10 then 1 else 0 end)*100/count(*)PercOrder,
sum(case when delivered_flag='2' and timestampdiff(minute,order_time,allot_time)<10 then 1 else 0 end)*100/count(*)Percorderten
from coreengine_order
where source in (0,3,4,5,6,7,8) and date(order_time) and status !=302
group by 1)k;

#LeakagePoint 3
/*% of orders delivered by rider on app within 10 mins post pick-up (orders with allot time < 10 mins)
% of orders delivered by rider on app after 60 mins post pick-up (orders with allot time < 10 mins)*/
select 
sum(case when delivered_flag=1 and timestampdiff(minute,pickUp_time,delivered_time)<10 
and timestampdiff(minute,order_time,allot_time)<10 then 1 else 0 end)*100/count(*)PercOrdersDelBy_RiderWithin10Min_AllottedWithin10,
sum(case when delivered_flag=1 and timestampdiff(minute,pickUp_time,delivered_time)>60 
and timestampdiff(minute,order_time,allot_time)<10 then 1 else 0 end)*100/count(*)PercOrdersDelBy_RiderAfter60Min_AllottedWithin10
from
coreengine_order
where date(order_time)="20151117" and status !=302;

/*% of riders with < 50% orders delivered by rider on app within 10 mins post pick-up (orders with allot time < 10 mins)
% of riders with < 90% orders delivered by rider on app within 10 mins post pick-up (orders with allot time < 10 mins)
% of riders with < 50% orders delivered by rider on app after 60 mins post pick-up (orders with allot time < 10 mins)
% of riders with < 90% orders delivered by rider on app after 60 mins post pick-up (orders with allot time < 10 mins)*/

select sum(case when k.PercOrdersDelBy_RiderWithin10Min_AllottedWithin10 <50 then 1 else 0 end)*100/count(*)PercRiderWithin50_DelWithin10Min,
sum(case when k.PercOrdersDelBy_RiderWithin10Min_AllottedWithin10 between 50 and 90 then 1 else 0 end)*100/count(*)PercRider50_90_DelWithin10Min,
sum(case when k.PercOrdersDelBy_RiderAfter60Min_AllottedWithin10 <50 then 1 else 0 end)*100/count(*)PercRider50_DelAfter60Min,
sum(case when k.PercOrdersDelBy_RiderAfter60Min_AllottedWithin10 between 50 and 90 then 1 else 0 end)*100/count(*)PercRider50_90_DelAfter60Min
from
(select rider_id,
sum(case when delivered_flag=1 and timestampdiff(minute,pickUp_time,delivered_time)<10 
and timestampdiff(minute,order_time,allot_time)<10 then 1 else 0 end)*100/count(*)PercOrdersDelBy_RiderWithin10Min_AllottedWithin10,
sum(case when delivered_flag=1 and timestampdiff(minute,pickUp_time,delivered_time)>60 
and timestampdiff(minute,order_time,allot_time)<10 then 1 else 0 end)*100/count(*)PercOrdersDelBy_RiderAfter60Min_AllottedWithin10
from coreengine_order
where date(order_time)="20151117" and status !=302
group by 1)k;
