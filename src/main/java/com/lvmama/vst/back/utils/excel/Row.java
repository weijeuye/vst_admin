/*
 */
package com.lvmama.vst.back.utils.excel;
/**
 * excel中行对象
 * @version 2011-8-10 上午10:01:09
 * @since JDK1.6
 */
public interface Row {
    /**
     * 创建单元格
     *
     * @param c 列号
     * @return 创建列
     */
    Cell createCell(Integer c);

    /**
     * 获得单元格
     *
     * @param c 列号
     * @return 列对象
     */
    Cell getCell(Integer c);

    /**
     * 获得最后单元格数
     *
     * @return 单元格数
     */
    Integer getLastCellNum();
}
