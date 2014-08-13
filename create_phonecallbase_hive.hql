DROP TABLE phonecallbase;
CREATE EXTERNAL TABLE phonecallbase
(
ActivityId string ,
mbs_phonestatus int ,
mbs_gsxactivityid string ,
mcs_dialstarttime timestamp ,
mcs_Duration string ,
mcs_HoldTime string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\001'
LOCATION 'wasb://crmhivecluster@crmhivestorage.blob.core.windows.net/PhoneCallBaseData';
