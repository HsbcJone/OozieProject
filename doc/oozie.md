# oozie作为调度器多种场景的使用时注意的问题
oozie作为调度使用时 在Yarn上的Job个数会是action个数的n+1 (里面的action是一个个具体的Job 最开始的action作为整个workflow的监听)
oozie的执行日志 当oozie调度任务失败的时候 需要看具体每个action的日志 而不是开始启动的job的容器日志。这个容器job一般都是成功的，就是
在yarn上是sucessful 但是实际的job失败了
开始启动的job的日志打印 怪异而且不全。

默认的oozie.wf.application.path 下的文件名就是workflow.xml

默认可以采用hue进行验证后 拿到oozie的xml进行代码提交 非常管用

查看方式：通过hue->workflow->action ->具体日志
## hive-->mysql
1.namenode jobTracker user.name
  <property>
    <name>dfs.nameservices</name>
    <value>cdhtest</value>
  </property>
  
   <property>
      <name>yarn.resourcemanager.cluster-id</name>
      <value>yarnRM</value>
    </property>
    user.name 是能够有权限操作hive的用户
2.hive的参数设置    
    conf.setProperty("catalogDatabase","seewo_cdm_dev")
    conf.setProperty("catalogTable","test_1")
    //hcatlog是CDH上hiveMetaStoreUri的地址 仅仅是指meta的thrifyserver 不是hive-server2的地址(重要)
    conf.setProperty("hiveMetaStoreUri","thrift://cdh-10-21-17-95:9083")
    //hcatlog是CDH上hive-hcatlog的操作地址
    conf.setProperty("catalogHome","/opt/cloudera/parcels/CDH/lib/hive-hcatalog")   
3.通用的 workflower的配置模版参数  针对一类的Job 比如sqoop导入mysql都可以定义一个通用的模版
   conf.setProperty("oozie.wf.application.path","hdfs://cdhtest/user/jwth/etl_ds/reflux/partition/")
   
4.导入的时候可以使用分区等参数

5.hive导入mysql之前 mysql的表必须建立。不然报错

## mysql ->hive
1.mysqlUrl url需要包含database的名字
2.conf.setProperty("oozie.wf.application.path","hdfs://cdhtest/user/mengxp/mysqlToHive/")
这个路径下的文件名以workflow.xml为主


## oozie-java

## oozie-hiveETL
1. <jdbc-url>${hiveServer2Url}</jdbc-url> 是hiveserver2的url
2. <password>${hivePassword}</password> 是提交账号的密码 测试账号是 hive/123456
3. hive.sql 里面sql可以存在换行

## oozie-coodinate
采用定时调度的方式来调度Job

## oozie-bundles
采用bundles管理多个coodinates

## oozie-shell
采用oozie调度执行shell脚本
    