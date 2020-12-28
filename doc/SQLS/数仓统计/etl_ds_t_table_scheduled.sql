## etl_ds_t_table_scheduled 是etl_ds里面的一张表 是整个ETL-DS 2.0的所有调度的表
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
)

## 每天调度的表4000+
select count(*) from seewo_dev.etl_ds_t_table_scheduled t where t.biz_date='2020-05-20'


    test	24
	seewo_cdm	1299
	seewo_test	178
	maxhub_dev	1
	seewo_cdm_dev	155
	seewo_cdm_test	132
	seewo_business	12
	data_warehouse	144
    mindlinker_statistics_pro	9
    seewo_dws	131
	data_warehouse_new	19
	seewo	744
	maxhub	37
	seewo_dev	153
    seewo_dm	8
	mindlinker_statistics_fat	9
	maxhub_test	18
	friday	1180
	seewo_protect	2