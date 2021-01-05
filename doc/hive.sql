set mxp=1;
drop table if exists  seewo_cdm_dev.ooziehive;
create table if not exists seewo_cdm_dev.ooziehive
            as select * from seewo_cdm_dev.table_id_mm;

--create table  if not exists seewo_cdm_dev.ooziehive2 like  seewo_cdm_dev.ooziehive;
INSERT INTO TABLE seewo_cdm_dev.ooziehive  SELECT * FROM seewo_cdm_dev.table_id_mm limit 10;