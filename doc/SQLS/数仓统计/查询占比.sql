with demo1 as(
select * from  seewo_dev.dw_data_steam_beta_warn_query_log_detail
      where start_time > ${startTime}  and start_time < ${endTime}
       and q_str is not null
  and db_type = 'IMPALA'
  and tablename not like '%_test'
  and tablename not like '%_dev'
  and tablename not like '%_kudu'
  and username != 'friday-loader'
),demo2 as(
select * from  seewo_dev.dw_data_steam_beta_warn_query_log_detail
      where start_time > ${startTime}  and start_time < ${endTime}
      and q_str is not null
   and db_type = 'HIVE'
  and tablename not like '%_test'
  and tablename not like '%_dev'
  and username != 'friday-loader'
),demo3 as(
SELECT * from demo1
union
SELECT * from demo2
)

select count(if(tablename rlike 'dim.*|bri.*|dwd.*|dws.*', 1, NULL)) as '查询数仓',
        count(1) as '查询总数',
        (count(if(tablename rlike 'dim.*|bri.*|dwd.*|dws.*', 1, NULL)) / (count(1)))
        as '占比',
       (count(if(tablename rlike 'dim.*|bri.*|dwd.*|dws.*', 1, NULL))+
        count(if(tablename in  ('seewo_class_seewo_sys_users','seewo_class_seewo_sys_user_type'), 1, NULL)) ) / (count(1))
        as 'Include占比'
from demo3



select d.db_type,count(*) from demo3 d group by d.db_type

select t.db_type,count(*) from dw_data_steam_beta_warn_query_log_detail t group by t.db_type
