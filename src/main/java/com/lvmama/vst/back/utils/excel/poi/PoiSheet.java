/*
 */
package com.lvmama.vst.back.utils.excel.poi;
import com.lvmama.vst.back.utils.excel.Row;
import com.lvmama.vst.back.utils.excel.Sheet;
/**
 * excel的sheet对象
 *
 * @author 黄心砚
 * @version 2011-8-10 上午10:49:30
 * @since JDK1.6
 */
public class PoiSheet implements Sheet {
    /** poiSheet对象 */
    private org.apache.poi.ss.usermodel.Sheet poiSheet = null;
    /** 记录当前操作的行数 */
    private int currentRowNum;

    /**
     * 构造方法
     * @param poiSheet Sheet
     */
    public PoiSheet(org.apache.poi.ss.usermodel.Sheet poiSheet) {
        this.poiSheet = poiSheet;
    }

    @Override
    public Integer getLastRowNum() {
        return poiSheet.getLastRowNum();
    }

    @Override
    public Integer getPhysicalNumberOfRows() {
        return poiSheet.getPhysicalNumberOfRows();
    }

    @Override
    public Row getRow(Integer r) {
    	try {
    		return new PoiRow(poiSheet.getRow(r));
		} catch (Exception e) {
			return null;
		}
    }

    @Override
    public Row createRow(Integer r) {
    	try {
    		return new PoiRow(poiSheet.createRow(r));
		} catch (Exception e) {
			return null;
		}
    }

    @Override
	public Integer getCurrentRowNum() {
		return currentRowNum;
	}

    @Override
	public void setCurrentRowNum(Integer currentRowNum) {
		this.currentRowNum = currentRowNum;
	}

    @Override
	public void setColumnWidth(Integer col, Integer width) {
    	poiSheet.setColumnWidth(col, width);
	}
}
