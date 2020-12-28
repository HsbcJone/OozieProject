## hive结果动态增加一列的两类写法
### 第一类 无group等分组字段
with demo as(
select count(*) as ac from seewo_cdm_dev.dwd_jwth_import_log_tx
)
#### 1.1 如下两种写法等同
select * from seewo_cdm_dev.dwd_jwth_import_log_tx
cross join demo
#### 1.2 如下两种写法等同
select * from seewo_cdm_dev.dwd_jwth_import_log_tx,demo

select * from seewo_cdm_dev.dwd_jwth_import_log_tx
cross join demo

## 第二类 存在group by等分组字段
with demo as(
select count(*) as ac from seewo_cdm_dev.dwd_jwth_import_log_tx
)

select y.*,demo.ac from
(select sink_db,count(*) from seewo_cdm_dev.dwd_jwth_import_log_tx t
where t.dt_d='2020-05-20'
group by t.sink_db) y
cross join demo


## 第三类 需要定义多个with 中间态来执行变量
with demo as(
select sink_db,count(*) as ac from seewo_cdm_dev.dwd_jwth_import_log_tx t
where t.dt_d='2020-05-20'
group by t.sink_db
),demo2 as(
select sum(ac) as ac2 from demo
)

select * from demo cross join demo2





