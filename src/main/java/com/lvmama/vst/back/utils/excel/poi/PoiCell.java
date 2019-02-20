/*
 * PoiCell.java    2011-8-10
 * 使用者必须经过许可
 */
package com.lvmama.vst.back.utils.excel.poi;
import java.text.DecimalFormat;
import java.util.Date;

import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.ss.usermodel.RichTextString;
import org.apache.poi.xssf.usermodel.XSSFRichTextString;

import com.lvmama.vst.back.utils.excel.Cell;
/**
 *  excel中cell的对象
 *
 * @version 2011-8-10 上午10:30:56
 * @since   JDK1.6
 */
public class PoiCell implements Cell {
    /** poiCell对象 */
    private org.apache.poi.ss.usermodel.Cell poiCell = null;

    /**
     * 构造方法
     * @param poiCell Cell
     */
    public PoiCell(org.apache.poi.ss.usermodel.Cell poiCell) {
    	this.poiCell = poiCell;
    }

    @Override
    public int getCellType() {
        return poiCell.getCellType();
    }

    @Override
    public Date getDateCellValue() {
        return poiCell.getDateCellValue();
    }

	@Override
	public Double getNumericCellValue() {
		try {
			return new Double(poiCell.getNumericCellValue());
		} catch (Exception e) {
			return null;
		}
	}

	@Override
	public String getStringCellValue() {
		try {
			String value = poiCell.toString();
			if (org.apache.poi.ss.usermodel.Cell.CELL_TYPE_NUMERIC == poiCell.getCellType()
					&& value.contains("E")) {
				int eIndex = value.indexOf("E");
				int times = Integer.parseInt(value.substring(eIndex + 1));
				double cardinal = Double.parseDouble(value.substring(0, eIndex));
				double result = cardinal * Math.pow(10, times);
				DecimalFormat df = new DecimalFormat("0");
				value = df.format(result);
			}
			if (value.endsWith(".0")) {
				value = value.substring(0, value.length() - 2);
	    	}
			return value;
		} catch (Exception e) {
			return "";
		}
	}

    @Override
    public void setCellValue(String s) {
    	try {
    		RichTextString richStr = new XSSFRichTextString(s);
            poiCell.setCellValue(richStr);
		} catch (Exception e) {
			RichTextString richStr = new HSSFRichTextString(s);
            poiCell.setCellValue(richStr);
		}
    }

    @Override
    public boolean isNull() {
        return poiCell == null;
    }

}
