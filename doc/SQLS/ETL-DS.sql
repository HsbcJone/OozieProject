## 统计来源表
### 1.ODS层所有表详细信息
CREATE TABLE seewo_cdm_dev.dwd_model_from_ods_ready_tx (
    from_db STRING COMMENT '来源数据库',
    from_table STRING COMMENT '来源表',
    priority STRING COMMENT '依赖该表的消费表等级',
    begin_time STRING COMMENT '依赖该表的消费表启动事件',
    complete_time STRING COMMENT '导入完成时间',
    complete_detail STRING COMMENT '导入具体完成时间',
    is_ready BIGINT COMMENT '当日是否及时：0:未及时，1:及时',
    load_time TIMESTAMP COMMENT '记录加载的时间'
) COMMENT '建模依赖ods表每日及时明细' PARTITIONED BY (dt_d STRING COMMENT '事务日期') WITH SERDEPROPERTIES ('serialization.format' = '1') STORED AS PARQUET LOCATION 'hdfs://psd-hadoop/user/hive/warehouse/seewo_cdm_dev.db/dwd_model_from_ods_ready_tx' TBLPROPERTIES ('transient_lastDdlTime' = '1589778836')
### 2.建模生成的表
SELECTCREATE TABLE seewo_cdm_dev.dim_model_table (
    project_id STRING COMMENT '项目ID',
    project_title STRING COMMENT '项目简介',
    db_name STRING COMMENT '数据库名',
    table_name STRING COMMENT '表名',
    priority STRING COMMENT '表资产等级，如果表有取表的，没有取项目的',
    begin_time STRING COMMENT '表的调度截止时间，取建模项目的截止时间',
    ready_time STRING COMMENT '表的调度截止时间，取建模项目的截止时间',
    load_time TIMESTAMP COMMENT '记录加载的时间'
) COMMENT '建模生成的表' STORED AS PARQUET LOCATION 'hdfs://psd-hadoop/user/hive/warehouse/seewo_cdm_dev.db/dim_model_table' TBLPROPERTIES ('transient_lastDdlTime' = '1589886098')
### 3.
CREATE TABLE seewo_cdm_dev.dwd_dw_un_ready_table (unready_table_ele STRING, dt_d STRING) WITH SERDEPROPERTIES ('serialization.format' = '1') STORED AS TEXTFILE LOCATION 'hdfs://psd-hadoop/user/hive/warehouse/seewo_cdm_dev.db/dwd_dw_un_ready_table' TBLPROPERTIES (
    'totalSize' = '84',
    'numRows' = '1',
    'rawDataSize' = '83',
    'COLUMN_STATS_ACCURATE' = 'true',
    'numFiles' = '1',
    'transient_lastDdlTime' = '1589884686'
)

### 4.etl_ds_t_table_scheduled 表的调度数据
CREATE TABLE seewo_dev.etl_ds_t_table_scheduled (
    id BIGINT,
    db_url STRING COMMENT '数据库url',
    db_port INT COMMENT '数据库端口',
    db_type TINYINT COMMENT '数据库类型（0：mysql, 1：hive）',
    db_name STRING COMMENT '数据库名',
    table_name STRING COMMENT '表名',
    biz_date STRING COMMENT '业务日期',
    ready_date STRING COMMENT '就绪时间',
    create_time STRING COMMENT '创建时间',
    update_time STRING COMMENT '更新时间'
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\u0001' LINES TERMINATED BY '\n' WITH SERDEPROPERTIES (
    'serialization.format' = '\u0001',
    'line.delim' = '\n',
    'field.delim' = '\u0001'
) STORED AS PARQUET LOCATION 'hdfs://psd-hadoop/user/hive/warehouse/seewo_dev.db/etl_ds_t_table_scheduled' TBLPROPERTIES (
    'last_modified_time' = '1589882618',
    'totalSize' = '24739377',
    'numRows' = '-1',
    'rawDataSize' = '-1',
    'COLUMN_STATS_ACCURATE' = 'false',
    'numFiles' = '1',
    'transient_lastDdlTime' = '1589882618',
    'last_modified_by' = 'cloudera-scm'
)

### 5.按照天记录A1表的及时率 -->进行按照月进行统计
CREATE TABLE seewo_cdm_dev.dwd_dw_table_ready_cd_d_cbd (
    ready_pr DOUBLE COMMENT '及时率',
    un_ready_table_cnt INT COMMENT '未及时的表数量',
    un_ready_table ARRAY < STRING > COMMENT '今日刷新但未及时的表',
    un_flush_table ARRAY < STRING > COMMENT '今日未刷新的表',
    table_total INT COMMENT '总表数',
    load_time TIMESTAMP COMMENT '记录加载的时间',
    dt_d STRING COMMENT '统计时间',
    a1_ready_pr DOUBLE COMMENT 'A1及时率',
    a1_un_ready_table_cnt INT COMMENT 'A1未及时的表数量',
    a1_un_ready_table ARRAY < STRING > COMMENT 'A1今日刷新但未及时的表'
) COMMENT '每日及时率日报' WITH SERDEPROPERTIES ('serialization.format' = '1') STORED AS PARQUET LOCATION 'hdfs://psd-hadoop/user/hive/warehouse/seewo_cdm_dev.db/dwd_dw_table_ready_cd_d_cbd' TBLPROPERTIES (
    'last_modified_time' = '1587897129',
    'totalSize' = '1096868',
    'numRows' = '101',
    'rawDataSize' = '1010',
    'COLUMN_STATS_ACCURATE' = 'true',
    'numFiles' = '1',
    'transient_lastDdlTime' = '1589884525',
    'last_modified_by' = 'cloudera-scm'
)

### 6.当天未就绪的表
CREATE TABLE seewo_cdm_dev.dwd_dw_un_flush_table (unflush_table_ele STRING, dt_d STRING) WITH SERDEPROPERTIES ('serialization.format' = '1') STORED AS TEXTFILE LOCATION 'hdfs://psd-hadoop/user/hive/warehouse/seewo_cdm_dev.db/dwd_dw_un_flush_table' TBLPROPERTIES (
    'totalSize' = '314067',
    'numRows' = '3438',
    'rawDataSize' = '310629',
    'COLUMN_STATS_ACCURATE' = 'true',
    'numFiles' = '1',
    'transient_lastDdlTime' = '1589884690'
)
### 7.邮件发送日志
CREATE TABLE seewo_dev.seewo_report_email_send_logs (
    id BIGINT COMMENT '自增主键',
    subject STRING COMMENT '邮件主题',
    create_time STRING COMMENT '创建时间',
    update_time STRING COMMENT '更新时间'
) COMMENT '邮件发送日志' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\u0001' LINES TERMINATED BY '\n' WITH SERDEPROPERTIES (
    'serialization.format' = '\u0001',
    'line.delim' = '\n',
    'field.delim' = '\u0001'
) STORED AS PARQUET LOCATION 'hdfs://psd-hadoop/user/hive/warehouse/seewo_dev.db/seewo_report_email_send_logs' TBLPROPERTIES (
    'last_modified_time' = '1589928176',
    'totalSize' = '17254',
    'numRows' = '-1',
    'rawDataSize' = '-1',
    'COLUMN_STATS_ACCURATE' = 'false',
    'numFiles' = '1',
    'transient_lastDdlTime' = '1589928176',
    'last_modified_by' = 'cloudera-scm'
)

### 7
CREATE TABLE seewo_dev.seewo_report_check_email_subject (id BIGINT, subject STRING COMMENT '邮件主题') ROW FORMAT DELIMITED FIELDS TERMINATED BY '\u0001' LINES TERMINATED BY '\n' WITH SERDEPROPERTIES (
    'serialization.format' = '\u0001',
    'line.delim' = '\n',
    'field.delim' = '\u0001'
) STORED AS PARQUET LOCATION 'hdfs://psd-hadoop/user/hive/warehouse/seewo_dev.db/seewo_report_check_email_subject' TBLPROPERTIES (
    'last_modified_time' = '1589882837',
    'totalSize' = '612',
    'numRows' = '-1',
    'rawDataSize' = '-1',
    'COLUMN_STATS_ACCURATE' = 'false',
    'numFiles' = '1',
    'transient_lastDdlTime' = '1589882837',
    'last_modified_by' = 'cloudera-scm'
)

### 8.精卫填海导入日志明细表
CREATE TABLE seewo_cdm_dev.dwd_jwth_import_log_tx (
    id BIGINT COMMENT '日志id',
    job_id BIGINT COMMENT '任务id',
    sink_db STRING COMMENT '表名',
    sink_tb STRING COMMENT '实例名',
    import_type STRING COMMENT '数据库名',
    start_time STRING COMMENT '就绪时间刷新时间点',
    end_time STRING COMMENT '就绪日期',
    duration_sec BIGINT COMMENT '导入耗时（秒）',
    load_time TIMESTAMP COMMENT '记录加载的时间'
) COMMENT '精卫填海导入日志明细表' PARTITIONED BY (dt_d STRING COMMENT '事务日期') STORED AS PARQUET LOCATION 'hdfs://psd-hadoop/user/hive/warehouse/seewo_cdm_dev.db/dwd_jwth_import_log_tx' TBLPROPERTIES ('transient_lastDdlTime' = '1587883432')

## ODS层项目库表的整体统计
## 1.select 同级别的字段里如果进行多次运算 采用子查询和with关键字 巧妙采用窗口函数进行groupby后总数的统计)
## 2.cast(dbcount/allc as decimal(10,2))进行四舍五入转化保留2位数
## 3.concat字符串拼接
with demo as (
select s.db,s.dbcount,sum(s.dbcount) over() as allc
from
(select from_db as db,count(1) as dbcount from seewo_cdm_dev.dwd_model_from_ods_ready_tx t
 where t.from_db is not null
 group by t.from_db
)s)
select  * , concat(cast(cast(dbcount/allc as decimal(10,2))*100 as string),'%') as rate from demo



## 指定A1优先级进行ODS表的统计
select from_db as '库名',
	from_table as '表名',
    begin_time as '期待完成时间',
    complete_detail as '实际完成时间',
    case when is_ready=0 then '未及'
        else '及时' end as  '及时性',
        is_ready
from seewo_cdm_dev.dwd_model_from_ods_ready_tx WHERE  dt_d ='${dt_d}' and priority='A1'

## count+if组合 用于统计比例
SELECT count(if(from_db='seewo' OR from_db='seewo_protect' OR from_db='maxhub' ,1,null))/count(1) AS from_seewo, count(if(from_db='friday',1,null))/count(1) AS from_friday
FROM dwd_model_from_ods_ready_tx
WHERE priority='A1'
        AND dt_d='2020-05-17'