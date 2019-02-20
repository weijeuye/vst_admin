/*
 * PoiRow.java    2011-8-10
 */
package com.lvmama.vst.back.utils.excel.poi;
import com.lvmama.vst.back.utils.excel.Cell;
import com.lvmama.vst.back.utils.excel.Row;
/**
 *  excel中行对象
 *
 * @version 2011-8-10 上午10:49:20
 * @since   JDK1.6
 */
public class PoiRow implements Row {
    /** poiRow对象 */
    private org.apache.poi.ss.usermodel.Row poiRow = null;

    /**
     * 构造方法
     * @param poiRow Row
     */
    public PoiRow(org.apache.poi.ss.usermodel.Row poiRow) {
    	this.poiRow = poiRow;
    }

    @Override
    public Cell createCell(Integer c) {
    	try {
    		return new PoiCell(poiRow.createCell(c));
		} catch (Exception e) {
			return null;
		}
    }

    @Override
    public Cell getCell(Integer c) {
    	try {
    		return new PoiCell(poiRow.getCell(c));
		} catch (Exception e) {
			return null;
		}
    }

    @Override
    public Integer getLastCellNum() {
        return (int) poiRow.getLastCellNum();
    }
}
