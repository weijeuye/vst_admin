/*
 */
package com.lvmama.vst.back.utils.excel;
/**
 * excel的sheet对象
 *
 * @version 2011-8-10 上午10:00:50
 * @since JDK1.6
 */
public interface Sheet {
    /**
     * 获得sheet中最后一行的行数
     * @return 行数
     */
    Integer getLastRowNum();

    /**
     * 获得行数
     * @return 行数
     */
    Integer getPhysicalNumberOfRows();

    /**
     * 获得行对象
     * @param r 行数
     * @return 行对象
     */
    Row getRow(Integer r);

    /**
     * 创建行
     * @param r 行数
     * @return 行对象
     */
    Row createRow(Integer r);

	/**
	 * 得到当前行
	 * @return the currentRowNum
	 */
    Integer getCurrentRowNum();

	/**
	 * 设置当前行
	 * @param currentRowNum the currentRowNum to set
	 */
	void setCurrentRowNum(Integer currentRowNum);

	/**
	 * 设置宽度
	 * @param col col
	 * @param width width
	 */
	void setColumnWidth(Integer col, Integer width);
}
