## dim_model_table 这张表是针对t_project和t_tableid 进行得到的项目对应的所有的表记录
use seewo_cdm_dev;
        insert overwrite table dim_model_table
        select project_id                                                                as project_id,
               c_title                                                                   as project_title,
               NULL                                                                      as db_name,
               tb.name                                                                   as table_name,
               case when tb.priority < pj.priority then tb.priority else pj.priority end as priority,
               pj.begin_time                                                             as begin_time,
               if(instr(pj.ready_time, "-") != 0, substr(pj.ready_time, 1, instr(pj.ready_time, "-") - 1),
                  pj.ready_time)                                                         as ready_time,
               current_timestamp()
        from seewo_dev.dw_data_steam_beta_table_id tb
                 left join seewo_dev.dw_data_steam_beta_t_project pj on tb.project_id = pj.c_identifier
where tb.deleted = 0


## instr函数
instr(string str, string substr)
查找字符串str中子字符串substr出现的位置，如果查找失败将返回0，如果任一参数为Null将返回null，注意位置为从1开始的
查找project_id 中的'-'字符的位置
select t.project_id,instr(t.project_id,'-') from  dim_model_table t

