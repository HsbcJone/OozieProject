## 对其进行按照(P0-P1 阶段分组整体进行统计) P0(JWTH-Friday)  P1(CMD-reflux) P2(邮件发送-目前无) 进行统计
with demo as(
select
    db_name,
    count(distinct table_name) c1,
    case
        when db_name = 'maxhub' then 'jwth'
        when db_name = 'seewo_test' then 'jwth'
        when db_name = 'seewo' then 'jwth'
        when db_name = 'maxhub_test' then 'jwth'
        when db_name = 'seewo_dev' then 'jwth'
        when db_name = 'seewo_protect' then 'jwth'
        when db_name = 'maxhub_dev' then 'jwth'

        when db_name = 'seewo_dws' then 'cmd'
        when db_name = 'seewo_cdm' then 'cmd'
        when db_name = 'seewo_cdm_dev' then 'cmd'
        when db_name = 'seewo_cdm_test' then 'cmd'
        --下面是调度2.0的回流
        when db_name = 'data_warehouse_new' then 'cmd-reflux'
        when db_name = 'data_warehouse' then 'cmd-reflux'
        when db_name = 'mindlinker_statistics_pro' then 'cmd-reflux'
        when db_name = 'mindlinker_statistics_fat' then 'cmd-reflux'

        when db_name = 'friday' then 'friday'
        else 'unknown'
    end as label
from
    seewo_dev.etl_ds_t_table_scheduled t
where
    t.biz_date = '2020-05-20'
group by
    t.db_name
),demo2 as(
select d.label,sum(d.c1) as c2 from demo d
group by d.label
)