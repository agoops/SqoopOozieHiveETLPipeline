set hive.execution.engine=tez;
INSERT OVERWRITE DIRECTORY '/ActivityPhoneJoinQuery' 
select pcb.*, apb.RegardingObjectIdName, apb.OwnerId, apb.PhoneSubcategory, apb.PhoneCategory, apb.PhoneNumber  
from (select * from phonecallbase) pcb join (select * from activitypointerbase) apb  on pcb.activityid = apb.activityid;

