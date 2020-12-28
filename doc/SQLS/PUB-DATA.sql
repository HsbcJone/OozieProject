## 1.0 采用tmp_db建学校维度表
use tmp_db;
        drop table if exists dim_school;
        CREATE TABLE dim_school
        (
            id                         STRING COMMENT '学校Id',
            name                       STRING COMMENT '学校名称',
            province_id                STRING COMMENT '省份id',
            province_name              STRING COMMENT '省份名称',
            city_id                    STRING COMMENT '城市id',
            city_name                  STRING COMMENT '城市名称',
            district_id                STRING COMMENT '行政区id',
            district_name              STRING COMMENT '行政区名称',
            ss_status                  TINYINT COMMENT '学校状态枚举值',
            ss_status_name             STRING COMMENT '学校状态名称',
            deleted                    TINYINT COMMENT '是否删除',
            create_time                TIMESTAMP COMMENT '创建时间',
            update_time                TIMESTAMP COMMENT '更新时间',
            load_time                  TIMESTAMP COMMENT '加载时间',
            easiclass_procu_model      TINYINT COMMENT '易课堂采购模式名称',
            easiclass_procu_model_name STRING COMMENT '易课堂采购模式名称',
            auth_easiclass_first       TINYINT COMMENT '首次开通易课堂形式名称',
            auth_easiclass_first_name  STRING COMMENT '首次开通易课堂形式名称',
            city_simple_name           string comment '城市简称',
            province_simple_name       string comment '省份简称',
            ss.sp_school_state         tinyint comment '机构版信鸽开通情况',
            ss_sp_school_state_name    string comment '机构版信鸽开通情况名称',
            ss_sp_open_datetime        string comment '机构版信鸽最早开通时间',
            yunban_school_open_time    string comment '云班学校开通时间'
        ) comment '学校维度表' stored as parquet;
## 知识点补充
1.case when语句+end as 'myname'
SELECT
   case
   when 2 = 2 then '已归档'
   else ''
end as myname
2.select coalesce(null, '22') coalesce是如果是空 结果就是22
3.current_timestamp() 当前的时间戳
4.(distribute by + sort by)=(partition by + order by)
这两者就是等同的 在impala里面 不支持 distribute by
count等聚合函数的数据集 来源于over开窗函数给定的数据集
select from_db,count(*) over(distribute by from_db sort by from_table) as cnt
这句话的含义:针对每一行t数据(这里只选取了from_db字段) cnt字段值计算的数据集是根据from_db分组后 from_table 字段小于当前行t.from_table的集合
这里cnt的字段值的数据集是动态变化的。假设10条数据不重复 from_table字段也不重复 经过排序后。
10行的数据集分别从1到10

select from_db,count(*) over(distribute by from_db sort by from_table)
from seewo_cdm_dev.dwd_model_from_ods_ready_tx t
where t.from_db is not null and t.from_db='maxhub'

select from_db,count(*) over(partition by from_db order by from_table)
from seewo_cdm_dev.dwd_model_from_ods_ready_tx t
where t.from_db is not null and t.from_db='maxhub'

5.NTILE()分组  对over的排序数据集进行NTILE的分组 分成5分 每一行的数据增加了一个group_id 代表组号
 select from_db,NTILE(5) over(ORDER BY orderdate) group_id
 from seewo_cdm_dev.dwd_model_from_ods_ready_tx t
 where t.from_db is not null and t.from_db='maxhub'

6.针对每个分组from_db 增加字段r 从1开始直到组的最大数
SELECT row_number() over (partition by from_db order by from_table) r, from_db
from seewo_cdm_dev.dwd_model_from_ods_ready_tx