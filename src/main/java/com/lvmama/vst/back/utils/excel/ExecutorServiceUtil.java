package com.lvmama.vst.back.utils.excel;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class ExecutorServiceUtil {

	private static final String fileName=System.getProperty("java.io.tmpdir")+"/hotel_"+new SimpleDateFormat ("yyyy-MM-dd").format(Calendar.getInstance().getTime())+".xls";
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

	private static final Integer DEFAULT_COUNT = 4;
	/**
	 * 使用线程池进行线程管理。
	 */
	//private static ExecutorService es = Executors.newCachedThreadPool();
	private static Workbook wb = null;

	/**
	 * 使用计数栅栏
	 */
	//private static CountDownLatch doneSignal = new CountDownLatch(DEFAULT_COUNT);
	
	private static ExecutorServiceUtil util = null;
	
	private void init() {
		try {
//			File file = new File(fileName);
//			if (!file.exists()) {
//				file.createNewFile();
//			}
			wb = ExcelUtil.newWorkbook(1);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	/**
	 * 私有化构造参数
	 */
	private ExecutorServiceUtil() {
		init();
	}
	
	public static ExecutorServiceUtil getInstance() {
		if (util == null) {
			util = new ExecutorServiceUtil();
		}
		return util;
	}
	
	public Workbook getWorkbook() {
		return wb;
	}
}
