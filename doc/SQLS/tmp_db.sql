 ## 1.利用tmp_db对数仓的dim_auth_acnt表的建模进行测试
 use tmp_db;
        drop table if exists tmp_db.dim_auth_acnt;
        create table tmp_db.dim_auth_acnt
        (
            id                                string,
            batch                             int comment '批次',
            form                              tinyint comment '开通形式',
            form_name                         string comment '开通形式名称',
            level                             tinyint comment '开通level',
            level_name                        string comment '开通level名称',
            auth_type                         string comment '权限类型 通用权限、资源权限',
            expire_time                       timestamp comment '期满时间',
            create_time                       timestamp comment '创建时间',
            update_time                       timestamp comment '更新时间',
            unused_num_update_time            timestamp comment '未使用数更新时间',
            deleted                           tinyint  comment '是否删除',
            school_id                         string comment '学校Id',
            school_name                       string comment '学校名称',
            school_ss_status                  tinyint comment '学校状态枚举值',
            school_ss_status_name             string comment '学校状态名',
            school_province_id                string comment '学校所在省份Id',
            school_province_name              string comment '学校所在省名称',
            school_city_id                    string comment '学校城市Id',
            school_city_name                  string comment '学校城市名称',
            school_district_id                string comment '学校行政区Id',
            school_district_name              string comment '学校行政区名',
            school_easiclass_procu_model      tinyint comment '易课堂采购模式名称',
            school_easiclass_procu_model_name string comment '易课堂采购模式名称',
            school_auth_easiclass_first       tinyint comment '首次开通易课堂形式名称',
            school_auth_easiclass_first_name  string comment '首次开通易课堂形式名称'
        ) stored as parquet;

SELECT * from  tmp_db.dim_auth_acnt

SELECT count(*) from  tmp_db.dim_auth_acnt


use tmp_db;
--特殊逻辑，正式账号没有结束日期
insert
    overwrite table dim_auth_acnt
select
    auth.authorize_id,
    auth.batch,
    auth.is_formal,
    case
        when auth.is_formal is null then '未开通'
        when auth.is_formal = 0 then '试用'
        when auth.is_formal = 1 then '正式'
        else ''
    end as form_name,
    auth.authorize_level,
    case
        when auth.authorize_level is null then '未开通'
        when cast(auth.authorize_level as string) = '1' then '互动'
        when auth.authorize_level = 2 then '互动+空间'
        when auth.authorize_level = 3 then '互动+空间+资源'
        else ''
    end as level_name,
    auth.authorize_type as auth_type,
    case
        when auth.is_formal = 0 then coalesce(auth.expire_time, '2070-12-31 23:59:59')
        when auth.is_formal = 1 then '2070-12-31 23:59:59'
        else coalesce(auth.expire_time, '2070-12-31 23:59:59')
    end as expire_time,
    auth.create_time,
    auth.update_time,
    auth.unused_num_update_time,
    auth.is_deleted,
    school.id,
    school.name,
    school.ss_status,
    school.ss_status_name,
    school.province_id,
    school.province_name,
    school.city_id,
    school.city_name,
    school.district_id,
    school.district_name,
    school.easiclass_procu_model,
    school.easiclass_procu_model_name,
    school.auth_easiclass_first,
    school.auth_easiclass_first_name
from
    seewo.seewo_easi_class_t_account_authorize auth
    left join seewo_cdm.dim_school school on auth.school_id = school.id;