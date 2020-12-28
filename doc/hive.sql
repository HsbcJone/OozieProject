drop table if exists  seewo_cdm_dev.ooziehive;
create table if not exists seewo_cdm_dev.ooziehive as select * from seewo_cdm_dev.table_id_text_;
create table  if not exists seewo_cdm_dev.ooziehive2 like  seewo_cdm_dev.ooziehive;
INSERT INTO TABLE seewo_cdm_dev.ooziehive2  SELECT * FROM seewo_cdm_dev.ooziehive limit 10;