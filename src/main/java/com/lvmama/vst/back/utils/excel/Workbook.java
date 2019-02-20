/*
 */
package com.lvmama.vst.back.utils.excel;
import java.io.IOException;
import java.io.OutputStream;
/**
 * Excel对象
 *
 * @version 2011-8-10 上午09:56:20
 * @since JDK1.6
 */
public abstract class Workbook implements java.io.Serializable {
    /**
     * 1代表POI
     */
    private static final int POI = 1;
    /**
     * 当前使用的是POI
     */
    private static final int CURRENT_EXCEL = 1;

    /**
     * 获得Sheet的个数
     *
     * @return sheet的个数
     */
    public abstract Integer getNumberOfSheets();

    /**
     * 获得sheet
     *
     * @param i 第几页
     * @return sheet
     */
    public abstract Sheet getSheetAt(Integer i);

    /**
     * 创建sheet
     *
     * @param name 页名
     * @return sheet
     */
    public abstract Sheet createSheet(String name);

    /**
     * 写入文件
     *
     * @param out 数据流
     * @throws IOException IOException
     */
    public abstract void write(OutputStream out) throws IOException;
    
}
