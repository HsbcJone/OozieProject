package com.cvte.oozie

import org.apache.oozie.client.OozieClient
import org.apache.oozie.client.WorkflowJob
import org.junit.Test
import scala.collection.JavaConverters._
import org.apache.oozie._


/**
 * @Author mengxp 
 * @Date 2020/5/15 5:02 下午 
 * @Version 1.0 
 */
class OozieDemo {

  /**
   * 通过oozie代码的方式提交Job到Yarn
   */
  @Test
  def submit(): Unit = {
    val wc:OozieClient = new OozieClient("http://psd-hadoop006:11000/oozie/")
    val conf = wc.createConfiguration()
    conf.setProperty("nameNode", "hdfs://psd-hadoop")
    conf.setProperty("jobTracker", "yarnRM")
    conf.setProperty("queueName", "default")
    conf.setProperty("oozie.use.system.libpath", "true")
    conf.setProperty("oozie.wf.rerun.failnodes", "true")
    conf.setProperty(OozieClient.APP_PATH, "hdfs://psd-hadoop/user/hue/oozie/deployments/_mengxiaopeng_-oozie-36276-1589640872.96")
    conf.setProperty("security_enabled", false+"")
    wc.getJobsInfo(OozieClient.FILTER_NAME)
    val jobId = wc.run(conf)
    System.out.println("Workflow job, " + jobId + " submitted")

    while ({wc.getJobInfo(jobId).getStatus eq WorkflowJob.Status.RUNNING}){
      System.out.println("Workflow job running ...")
      Thread.sleep(10 * 1000)
    }
    System.out.println("Workflow job completed ...")
    System.out.println(wc.getJobInfo(jobId))
  }


  @Test
  def launcherLocalOzzie(): Unit ={
    val wc:OozieClient = new OozieClient("http://psd-hadoop006:11000/oozie/")
    val var1=wc.getAvailableOozieServers
    val var2=wc.getJobLog("0053360-200506171128647-oozie-clou-W")
    val var3=wc.getHeaderNames
    println(var1,var2)
    println(var3)
    while (var3.hasNext){
      val data=var3.next()
      println(data)
    }
  }



  @Test
  def queryOzzie(): Unit ={
    val wc:OozieClient = new OozieClient("http://psd-hadoop006:11000/oozie/")
    val var1=wc.getAvailableOozieServers
    val var2=wc.getJobLog("0053360-200506171128647-oozie-clou-W")
    val var3=wc.getHeaderNames
    println(var1,var2)
    println(var3)
    while (var3.hasNext){
      val data=var3.next()
      println(data)
    }
  }

}
