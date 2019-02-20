/*
 */
package com.lvmama.vst.back.utils.excel.poi;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.lvmama.vst.back.utils.excel.Sheet;
import com.lvmama.vst.back.utils.excel.Workbook;
/**
 * Excel对象
 *
 * @version 2011-8-10 上午10:49:40
 * @since JDK1.6
 */
public class PoiWorkbook extends Workbook implements java.io.Serializable {
    /** workbook对象 */
    private org.apache.poi.ss.usermodel.Workbook poiWorkbook = null;

    /**
     * 构造方法
     * @param poiWorkbook Workbook
     */
    public PoiWorkbook(org.apache.poi.ss.usermodel.Workbook poiWorkbook) {
    	this.poiWorkbook = poiWorkbook;
    }

    /**
     * 构造方法
     * @param file 文件
     */
    public PoiWorkbook(File file) {
    	try {
    		InputStream is = new FileInputStream(file);
    		poiWorkbook = new XSSFWorkbook(is);
        } catch (Exception eXSSF) {
        	eXSSF.printStackTrace();
        	try {
        		InputStream is = new FileInputStream(file);
        		poiWorkbook = new HSSFWorkbook(is);
			} catch (Exception eHSSF) {
				eHSSF.printStackTrace();
			}
        }
    }

    @Override
    public Integer getNumberOfSheets() {
        return poiWorkbook.getNumberOfSheets();
    }

    @Override
    public Sheet getSheetAt(Integer i) {
        return new PoiSheet(poiWorkbook.getSheetAt(i));
    }

    @Override
    public Sheet createSheet(String name) {
        return new PoiSheet(poiWorkbook.createSheet(name));
    }

    @Override
    public void write(OutputStream out) throws IOException {
    	poiWorkbook.write(out);
    }
}
