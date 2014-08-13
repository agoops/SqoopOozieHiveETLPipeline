INSERT OVERWRITE DIRECTORY '/PhoneCallBaseQuery'
SELECT  ActivityId  ,
mbs_phonestatus  ,
mbs_gsxactivityid  ,
mcs_dialstarttime  ,
mcs_Duration  ,
mcs_HoldTime 
FROM phonecallbase