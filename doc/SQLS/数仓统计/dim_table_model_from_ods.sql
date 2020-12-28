## dim_model_from_ods_table 建模引用的ods层的表 有186张表
## explode 结合 table_id 和 t_project 将优先级下发到所有的ods的表中
## 下发的规则  已定义的表的优先级>项目的优先级 赋予ods的表的优先级
select tb.name, pj.begin_time,
                 case when tb.priority < pj.priority then tb.priority else pj.priority end as priority
                 from seewo_dev.dw_data_steam_beta_table_id tb
                          left join seewo_dev.dw_data_steam_beta_t_project pj on tb.project_id = pj.c_identifier

2. lateral view explode 将一行变多行 hive支持explode impala不支持
select tb_id.name  as sink_tb,
                   source_table,
                   trim(source_tables) as source_tbl
                   from seewo_dev.dw_data_steam_table_id tb_id
                    lateral view explode(split(tb_id.source_table, ',')) source_table_split_result as source_tables