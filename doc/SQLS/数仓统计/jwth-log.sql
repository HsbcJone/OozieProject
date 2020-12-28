##  dwd_jwth_import_log_tx  精卫填海从业务库导入正式 测试等环境数据表的log明细
dwd_jwth_import_log_tx  来源于如下seewo_dev 两张源表(seewo_jingwei_t_job和seewo_jingwei_t_job_log)
seewo_dev.seewo_jingwei_t_job_log 命名存在规范的从seewoo_jingwei的FAT库的t_job_log表同步过来的

1.jwth的Job表任务表不记录明细 比如从业务mysql的数据库-->sqoop导入数据到hive
CREATE TABLE seewo_dev.seewo_jingwei_t_job (
    id BIGINT COMMENT '主键，自增ID',
    source_db STRING COMMENT '数据源库名',
    source_tb STRING COMMENT '数据源表名',
    sink_db STRING COMMENT '数据池库名',
    sink_tb STRING COMMENT '数据池表',
    incremental STRING COMMENT '增量导入模式（append，lastmodified）',
    last_value STRING COMMENT '最后一次增量的值',
    pk STRING COMMENT '增量导入的主键（用于增量导入去重',
    uk STRING COMMENT '增量导入对比字段',
    ptn STRING COMMENT '分区名字',
    ptk STRING COMMENT '分区字段（2018-01-03 20:08:31.0）',
    extra STRING COMMENT '额外导入参数',
    map INT COMMENT '导入并行度',
    parent_id BIGINT COMMENT '父级id（若无父级依赖则为0）',
    priority TINYINT COMMENT '优先级：（0：低，3：中，7：高）',
    status TINYINT COMMENT '任务状态（0：上架，1：下架）',
    deadline STRING COMMENT '定时任务截止时间（06:00:00）',
    source_id BIGINT COMMENT '数据源id，关联t_db表的id',
    sink_id BIGINT COMMENT '目标数据源id，关联t_db表的id',
    project_id BIGINT COMMENT '项目id，关联t_project表的id',
    crontab_id BIGINT COMMENT '调度定时器id，关联t_crontab表的id',
    workflow_id BIGINT COMMENT '工作流id，关联t_workflow表的id',
    approved TINYINT COMMENT '是否审核通过（0：不通过； 1：通过）',
    create_time STRING COMMENT '创建时间',
    update_time STRING COMMENT '更新时间'
)
1.1 统计jwth调度的表总数 1070张表
select count(*) from seewo_dev.seewo_jingwei_t_job t where t.status=0

1.2 统计jwth调度的表进行分类
SELECT sink_db,count(DISTINCT sink_tb) from seewo_dev.seewo_jingwei_t_job t
WHERE t.status=0
   group by t.sink_db
----------------------------------------
sink_db	        count(distinct sink_tb)
seewo_protect	2
seewo_dev	    140
maxhub	        37
seewo	        713
seewo_test	    158
maxhub_test	    18
maxhub_dev	    1
----------------------------------------
2.seewo_dev.seewo_jingwei_t_job_log 记录Job的任务明细表
 CREATE TABLE seewo_dev.seewo_jingwei_t_job_log (
    id BIGINT COMMENT '主键，自增ID',
    type TINYINT COMMENT '任务日志类型（11：手动普通日志，12：手动重跑日志，21：定时普通日志，22：定时重跑日志）',
    source_db STRING COMMENT '数据源库名',
    source_tb STRING COMMENT '数据源表名',
    sink_db STRING COMMENT '数据池库名',
    sink_tb STRING COMMENT '数据池表名',
    status STRING COMMENT '任务状态（PENDING，KILLED，SUCCESS，FAILED）',
    job_id BIGINT COMMENT '任务id（关联t_job表的id）',
    oozie_id STRING COMMENT 'oozie 任务id（oozie 生成）',
    log STRING COMMENT '任务执行日志',
    start_time STRING COMMENT '任务启动时间',
    end_time STRING COMMENT '任务结束时间'
)

3.JWTH用到的mysql和mongodb的配置信息 用于在jwth调度中使用 后面查询某个库的账号密码直接查这里
CREATE TABLE seewo_dev.seewo_jingwei_t_db (
    id BIGINT COMMENT '主键，自增ID',
    name STRING COMMENT '数据源名称',
    type TINYINT COMMENT '数据源类型（0：mysql, 1：hive,3: mongodb）',
    env STRING,
    url STRING COMMENT 'jdbc连接url',
    port INT COMMENT '端口',
    username STRING COMMENT '用户名',
    extra TINYINT COMMENT '额外定义（0：不监控延迟；1：监控延迟）',
    create_time STRING COMMENT '创建时间',
    update_time STRING COMMENT '更新时间'
)