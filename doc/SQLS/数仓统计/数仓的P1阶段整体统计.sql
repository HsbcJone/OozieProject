## 统计现在整体P2阶段的调度的表和分类



#数仓P1调度2.0阶段的整体情况

show create table seewo_dev.etl_ds_t_task

## delete=0 是最新版本 旧的版本全部被删除
select * from etl_ds_t_task t where t.is_delete=0

select count(*) from etl_ds_t_task t where t.is_delete=0


select count(*) from etl_ds_t_task t where t.is_delete=0

## type区分调度的是回流还是建模
select  t.type from etl_ds_t_task t where t.is_delete=0 limit 1

### 这条统计的sql是根据t_task来进行统计的 会存在部分的误差 因为开发测试的过程中存在部分脏数据任务  （如删除workflow id后不一定删除了具体的task）
SELECT
    count(
        if(
            type = 1,
            1,
            null
        )
    ) AS "reflux_count 回流统计",
    count(
        if(
            type = 0,
            1,
            null
        )
    ) AS "cmd_count 建模统计",
    count(1) AS "p2_task_total task总和",
    count(
        if(
            type = 1,
            1,
            null
        )
    ) / count(1) AS  "reflux_per 回流比率",
    count(
        if(
            type = 0,
            1,
            null
        )
    ) / count(1) AS  "cmd_per 建模比率"
from
    seewo_dev.etl_ds_t_task t
where
    t.is_delete = 0

## 这条sql 统计的是t_task_instace 会更加准确一些 按照实际的time进行执行统计
select count(distinct s.name) from seewo_dev.etl_ds_t_task_instance s
WHERE substring(s.end_time, 1, 10)='2020-05-20'