/*
 * Cell.java 2011-8-10
 */
package com.lvmama.vst.back.utils.excel;
import java.util.Date;
/**
 * excel中cell的对象
 *
 * @version 2011-8-10 上午10:01:24
 * @since JDK1.6
 */
public interface Cell {
    /**
     * 获得单元类型
     * @return 单元类型
     */
    int getCellType();

    /**
     * 返回字符串
     * @return 字符串
     */
    String toString();

    /**
     * 获得日期型
     * @return 日期对象
     */
    Date getDateCellValue();

    /**
     * 获得数值型
     * @return 数值对象
     */
    Double getNumericCellValue();
    
    /**
     * 获得字符串值型
     * @return 字符串对象
     */
    String getStringCellValue();

    /**
     * 设置单元只
     * @param s 字符串
     */
    void setCellValue(String s);

    /**
     * 是否为空
     * @return true 空 false 非空
     */
    boolean isNull();
}
