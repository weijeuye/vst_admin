package com.lvmama.vst.back.utils;

import org.apache.commons.logging.Log;

/**
 * 记录时间消耗日志
 */
public class TimeLog {
	private StringBuilder bulder = new StringBuilder(248);
	private Log log;//日志
	private Long millis;//初始化时间
	public TimeLog(Log log){
		afreshMillis();
		this.log = log;
	}
	/**
	 * 写日志
	 */
	public void logWrite(String method, Object msg){
		clear();
		bulder.append(method).append(" userTime :").append(userTime());
		if(msg != null)
			bulder.append(",").append(msg);
		logWrite(bulder.toString());
	}
	public void logWrite(Object msg){
		log.info(msg);
	}
	public StringBuilder append(Object msg){
		bulder.append(msg);
		return bulder;
	}
	public StringBuilder clear(){
		bulder.delete(0, bulder.length());
		return bulder;
	}
	
	public StringBuilder getBulder() {
		return bulder;
	}
	/**
	 * 重新刷新当前时间
	 */
	public void afreshMillis(){
		this.millis = getCurrentTimeMillis();
	}
	
	/**
	 * 消耗时间
	 * @param millis
	 * @return
	 */
	private Long userTime(){
		return (getCurrentTimeMillis() - millis)/1000;//s
	}
	private Long getCurrentTimeMillis(){
		return System.currentTimeMillis();
	}
}
