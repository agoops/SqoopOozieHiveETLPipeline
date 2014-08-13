set hive.execution.engine=tez;
INSERT OVERWRITE DIRECTORY '/ActivityPointerBaseQuery'
SELECT  *
FROM activitypointerbase;