/*
* ExcelUtil.java    2010-11-16
*/
package com.lvmama.vst.back.utils.excel;
import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import com.lvmama.vst.back.utils.excel.Cell;
import com.lvmama.vst.back.utils.excel.Row;
import com.lvmama.vst.back.utils.excel.Sheet;
import com.lvmama.vst.back.utils.excel.Workbook;
import com.lvmama.vst.back.utils.excel.poi.PoiWorkbook;
/**
*  操作excel相关功能
*
* @author 
* @version 2010-11-16 下午04:08:38
* @since   JDK1.6
*/
public final class ExcelUtil {
    /** excel类型  */
    public static final int EXCEL_TYPE_XLS = 1;
    /** excel类型  */
    public static final int EXCEL_TYPE_XLSX = 2;
    /** jar类型  */
    private static final String EXCEL_JAR = "poi";

    /**
     * 构造函数
     */
    private ExcelUtil() { }

    /**
     * 新建一份WorkBook
     * @param excelType excel类型
     * @return Workbook
     */
    public static Workbook newWorkbook(int excelType) {
        if (EXCEL_JAR.equals("poi")) {
             if (EXCEL_TYPE_XLS == excelType) {
                  return new PoiWorkbook(new HSSFWorkbook());
             } else if (EXCEL_TYPE_XLSX == excelType) {
                  return new PoiWorkbook(new XSSFWorkbook());
             }
        }
        return null;
    }

    /**
     * 读取Excel
     * @param file 文件
     * @return Workbook对象
     */
    public static Workbook readExcel(File file) {
        Workbook workbook = null;
        if (EXCEL_JAR.equals("poi")) {
             workbook = new PoiWorkbook(file);
        }
        return workbook;
    }

    /**
     * 从工作表中获取每个sheet都指定行
     * @param workbook 工作表
     * @param rowNum 行数
     * @return HSSFRow列表
     */
    public static List<Row> getRowList(Workbook workbook, int rowNum) {
        List<Row> rowList = new ArrayList<Row>();
        int num = workbook.getNumberOfSheets();
        for (int i = 0; i < num; i++) {
            rowList.add(workbook.getSheetAt(i).getRow(rowNum));
        }
        return rowList;
    }

    /**
     * 得到所有的行数
     * @param workbook workbook对象
     * @return 行数
     */
    public static int getTotalRows(Workbook workbook) {
        int totalRows = 0;
        int num = workbook.getNumberOfSheets();
        for (int i = 0; i < num; i++) {
            totalRows += workbook.getSheetAt(i).getLastRowNum();
        }
        return totalRows;

    }

    /**
     * 取得指定行
     * @param workbook Excel
     * @param sheetNum 页
     * @param rowNum 行
     * @return HSSFRow对象
     */
    public static Row getRow(Workbook workbook, int sheetNum, int rowNum) {
        return workbook.getSheetAt(sheetNum).getRow(rowNum);
    }

    /**
     * 保存文件
     * @param file 文件
     * @param workbook Workbook
     */
    public static void saveFile(File file, Workbook workbook) {
         try {
            FileOutputStream out = new FileOutputStream(file);
            workbook.write(out);
            out.close();
          } catch (Exception e) {
               e.printStackTrace();
          }
    }

    /**
     * 将值添加到单元格中
     * @param row       行
     * @param cellNumber 单元格列号
     * @param cellValue  单元格值
     * @return 行
     */
    public static Row createCell(Row row, int cellNumber, String cellValue) {
        Cell cell = row.createCell(cellNumber); // 创建单元格
        cell.setCellValue(cellValue); // 设置单元格内容
        return row;
    }

    /**
     * 创建行
     * @param sheet Sheet
     * @param rowNumber 行号
     * @return 行
     */
    public static Row createRow(Sheet sheet, int rowNumber) {
        return sheet.createRow(rowNumber);
    }

    /**
     * 创建sheet
     * @param workbook workbook
     * @param sheetName sheetName
     * @return Sheet
     */
    public static Sheet createSheet(Workbook workbook, String sheetName) {
        // 在Excel工作簿中建一工作表，指定Sheet名称
        return workbook.createSheet(sheetName);
    }

    /**
     * cell是否为空
     * @param cell 单元格
     * @return true 为空 false 不为空
     */
    public static boolean isCellEmpty(Cell cell) {
        return cell == null || cell.isNull() || cell.toString().trim().equals("");
    }
}
