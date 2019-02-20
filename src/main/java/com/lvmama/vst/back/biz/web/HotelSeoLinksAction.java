package com.lvmama.vst.back.biz.web;

import java.io.File;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.jxls.transformer.XLSTransformer;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.lvmama.vst.back.biz.po.BizDistrict;
import com.lvmama.vst.back.biz.po.BizDistrictSign;
import com.lvmama.vst.back.biz.po.BizSeoFriendLink;
import com.lvmama.vst.back.client.biz.service.BizSeoFriendLinkClientService;
import com.lvmama.vst.back.client.biz.service.DistrictClientService;
import com.lvmama.vst.back.client.biz.service.DistrictSignClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.DateUtil;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.ResourceUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * seo-酒店友情链接
 * 包含三部分：
 * @author 
 */
@Controller
@RequestMapping("/biz/seoLink")
public class HotelSeoLinksAction extends BaseActionSupport {
    
    private static final Log LOG = LogFactory.getLog(HotelSeoLinksAction.class);

	@Autowired
	private BizSeoFriendLinkClientService bizSeoFriendLinkService;
	
	
	@Autowired
	private DistrictSignClientService districtSignService;
	
	
	@Autowired
	private DistrictClientService districtService;
	
	
	@Autowired
	private ProdProductClientService prodProductService;
	
	
	/**
	 * 导入excel配置文件地址
	 */
	public static final String SEO_LINKS_CONFIG_PATH = "/WEB-INF/resources/seoLinks/seoLinksExcel.xml";
	/**
	 * 导出excel对应模板文件地址
	 */
	public static final String SEO_TEMPLATE_PATH = "/WEB-INF/resources/seoLinks/seoLinksTemplate.xlsx";
	
	//根据查询条件和分页显示数据
    public void initSeoListPage(Model model, Integer page, Map<String, Object> parameters, HttpServletRequest req)
    		throws BusinessException {
    	
		int count = MiscUtils.autoUnboxing(bizSeoFriendLinkService.querySeoFriendLinkTotalCount(parameters));

		// 分页
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 20, pagenum);
		pageParam.buildUrl(req);
		parameters.put("_start", pageParam.getStartRows());
		parameters.put("_end", pageParam.getEndRows());
		
		List<BizSeoFriendLink> seoLinkList = MiscUtils.autoUnboxing(bizSeoFriendLinkService.selectPageListByParams(parameters));

		// 页面赋值
		pageParam.setItems(seoLinkList);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("page", pageParam.getPage().toString());
    }
    
	 /**
     * 默认页127.0.0.1:81/vst_admin/biz/seoLink/findSeoLinkList.do?seoType=DISTRICT
     * @return
     * @throws Exception
     */
	@RequestMapping(value = "/findSeoLinkList")
	public String findSeoList(Model model, Integer page, String seoType, String objectName, String linkUrl, 
			String linkName, HttpServletRequest req) throws BusinessException {

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("linkName", linkName);
		parameters.put("linkUrl", linkUrl);
		parameters.put("seoType", seoType);
		parameters.put("objectName", objectName);
		parameters.put("_orderby", " OBJECT_ID, BIZ_SEO_FRIEND_LINK_ID DESC");
		
		initSeoListPage(model, page, parameters, req);
		
		model.addAttribute("seoTypeName", BizSeoFriendLink.SEO_TYPE.getCnName(seoType));
		model.addAttribute("objectName", objectName);
		model.addAttribute("linkName", linkName);
		model.addAttribute("linkUrl", linkUrl);
		model.addAttribute("seoType", seoType);
		return "/biz/seoLink/seoLinkList";
	}
    
    
    /**
     * 编辑页面开始页
     * @return
     * @throws Exception
     * @author 
     */
	@RequestMapping(value = "/toSeoLinkUpdate")
	public String toSeoHotelEdit(Model model, Long bizSeoFriendLinkId, HttpServletRequest req)
			throws BusinessException {
		BizSeoFriendLink bizSeoFriendLink = MiscUtils.autoUnboxing(bizSeoFriendLinkService.findSeoFriendLinkById(bizSeoFriendLinkId));
		model.addAttribute("bizSeoFriendLink", bizSeoFriendLink);
    	return "/biz/seoLink/showUpdateSeoLink";
    }
    
	 /**
     * 新增页面开始页
     * @return
     * @throws Exception
     * @author 
     */
	@RequestMapping(value = "/toSeoLinkAdd")
	public String toSeoLinkAdd(Model model, HttpServletRequest req, String seoType)
			throws BusinessException {
			model.addAttribute("seoType", seoType);
    	return "/biz/seoLink/showAddSeoLink";
    }
	 
	 /**
     * 新增和修改
     * @return
     * @throws Exception
     * @author 
     */
	@RequestMapping(value = "/doAddUpdateSeoLink")
	@ResponseBody
	public Object doAddUpdateSeoLink(Long bizSeoFriendLinkId, String seoType, Long objectId, 
			String linkUrl, String linkName, String remark) throws BusinessException {
	 
		String objectName = getObjectName(objectId, seoType);
		if(StringUtil.isEmptyString(objectName)){
			return ResultMessage.ID_UNEXITE_RESULT;
		}
		
		if( bizSeoFriendLinkId != null ){
			BizSeoFriendLink bizSeoFriendLink = MiscUtils.autoUnboxing(bizSeoFriendLinkService.findSeoFriendLinkById(bizSeoFriendLinkId));
			if(bizSeoFriendLink != null){
				bizSeoFriendLink.setSeoType(seoType);
				bizSeoFriendLink.setObjectId(objectId);
				bizSeoFriendLink.setObjectName(objectName);
				bizSeoFriendLink.setLinkName(linkName);
				bizSeoFriendLink.setLinkUrl(linkUrl);
				bizSeoFriendLink.setRemark(remark);
				int num = MiscUtils.autoUnboxing(bizSeoFriendLinkService.updateSeoFriendLink(bizSeoFriendLink));  
				if(num > 0){
					return ResultMessage.UPDATE_SUCCESS_RESULT;
				}else{
					return ResultMessage.ID_HAVED_DATA_RESULT;
				}
			}else{
				return ResultMessage.ERROR;
			}
		}else{
			BizSeoFriendLink bizSeoFriendLink = new BizSeoFriendLink();
			bizSeoFriendLink.setSeoType(seoType);
			bizSeoFriendLink.setObjectId(objectId);
			bizSeoFriendLink.setObjectName(objectName);
			bizSeoFriendLink.setLinkName(linkName);
			bizSeoFriendLink.setLinkUrl(linkUrl);
			bizSeoFriendLink.setRemark(remark);
			int num = MiscUtils.autoUnboxing(bizSeoFriendLinkService.addSeoFriendLink(bizSeoFriendLink));  
			if(num > 0){
				return ResultMessage.ADD_SUCCESS_RESULT;
			}else{
				return ResultMessage.ID_HAVED_DATA_RESULT;
			}
		}
	}
		
	private String getObjectName(Long objectId, String seoType){
		String ObjectName = "";
		if(BizSeoFriendLink.SEO_TYPE.DISTRICT.getCode().equalsIgnoreCase(seoType)){
			BizDistrict bizDistrict = MiscUtils.autoUnboxing(districtService.findDistrictById(objectId));
			if(bizDistrict != null ){
				ObjectName = bizDistrict.getDistrictName();
			}
		}else if(BizSeoFriendLink.SEO_TYPE.HOTELDETAIL.getCode().equalsIgnoreCase(seoType)){
			ProdProduct prodProduct = MiscUtils.autoUnboxing(prodProductService.getProdProductBy(objectId));
			if(prodProduct != null ){
				ObjectName = prodProduct.getProductName();
			}
		}else if(BizSeoFriendLink.SEO_TYPE.AREA.getCode().equalsIgnoreCase(seoType)){
			BizDistrictSign bizDistrictSign = MiscUtils.autoUnboxing(districtSignService.findDistrictSignById(objectId));
			if(bizDistrictSign != null ){
				ObjectName = bizDistrictSign.getSignName();
			}
		} 
		return ObjectName;
	}
	
	 /**
     * 删除(可以单条或批量删除bizSeoFriendLinkIdList：454,356,89)
     * @return
     * @throws Exception
     * @author 
     */
	@RequestMapping(value = "/doDeleteSeoLink")
	@ResponseBody
	public Object doDeleteSeoLink(String bizSeoFriendLinkIdList) throws BusinessException {
	 
		if(StringUtil.isNotEmptyString(bizSeoFriendLinkIdList)){
			for(String bizSeoFriendLinkId : bizSeoFriendLinkIdList.split(",")){
				BizSeoFriendLink bizSeoFriendLink = new BizSeoFriendLink();
				bizSeoFriendLink.setBizSeoFriendLinkId(Long.parseLong(bizSeoFriendLinkId));
				bizSeoFriendLinkService.deleteSeoFriendLink(bizSeoFriendLink);
			}
			return ResultMessage.DELETE_SUCCESS_RESULT;
		}else{
			return ResultMessage.ERROR;
		}
	}
    
    /**
     * 导入excel初始化页面
     * @return
     */
	@RequestMapping(value = "/toShowUploadExecl")
	public String importExcel(Model model, String seoType, HttpServletRequest req) throws BusinessException {
		model.addAttribute("seoType", seoType);
		return "/biz/seoLink/showUploadExecl";
    }
 
    /**
     * 导入文件数据
   */
	@RequestMapping(value = "/importExcelData")
	@ResponseBody
	public Object importExcelData(Model model, String seoType, String fileName, HttpServletRequest request, 
			HttpServletResponse response) throws BusinessException {

		List<BizSeoFriendLink> seoLinkList = null;
		if (StringUtil.isEmptyString(seoType)) {
			this.sendAjaxMsg("seoType为空！", request, response);
			return null;
		}
		
		String message = "";
		String errorObjectIdList = "";
		MultipartHttpServletRequest mulRequest = (MultipartHttpServletRequest) request;  
        MultipartFile file = mulRequest.getFile("excel");  
        String filename = file.getOriginalFilename();  
		if (filename == null || "".equals(filename)) {
			return null;
		} 
        try  
        {  
			InputStream input = file.getInputStream();
			XSSFWorkbook workBook = new XSSFWorkbook(input);
			XSSFSheet sheet = workBook.getSheetAt(0);
			if (sheet != null) {
				seoLinkList = new ArrayList<BizSeoFriendLink>();
				Map<String, Object> parameters = new HashMap<String, Object>();
				
				// 查看行
				for (int i = 1; i < sheet.getPhysicalNumberOfRows(); i++) {
					XSSFRow row = sheet.getRow(i);
					BizSeoFriendLink bizSeoFriendLink = new BizSeoFriendLink();
					Long objectId;
					if(row.getCell(0) == null && row.getCell(2) == null &&  row.getCell(3) == null){
						continue;
					}
					if(row.getCell(0) != null && StringUtil.isNotEmptyString(row.getCell(0).toString().trim())){
						if(StringUtil.isNumber(row.getCell(0).toString().trim())){
							objectId = Long.parseLong(row.getCell(0).toString().trim());
							bizSeoFriendLink.setObjectId(objectId);
						}else{
							errorObjectIdList = errorObjectIdList + ", 编号ID错误 ——行号：" + (i + 1);
							continue;
						}
					}else{
						if(row.getCell(2) != null && StringUtil.isEmptyString(row.getCell(2).toString().trim())){
							if(row.getCell(3) != null && StringUtil.isEmptyString(row.getCell(3).toString().trim())){
								continue;
							}
						}else{
							errorObjectIdList = errorObjectIdList + ", 必填项缺失 ——行号：" + (i + 1);
							continue;
						}
					}
					if(row.getCell(2) != null && StringUtil.isNotEmptyString(row.getCell(2).toString().trim())){
						bizSeoFriendLink.setLinkName(row.getCell(2).toString().trim());
					}else{
						if(row.getCell(3) != null && StringUtil.isEmptyString(row.getCell(3).toString().trim())){
							continue;
						}else{
							errorObjectIdList = errorObjectIdList + ", 必填项缺失 ——行号：" + (i + 1);
							continue;
						}
					}
					if(row.getCell(3) != null && StringUtil.isNotEmptyString(row.getCell(3).toString().trim())){
						bizSeoFriendLink.setLinkUrl(row.getCell(3).toString().trim());
					}else{
						errorObjectIdList = errorObjectIdList + ", 必填项缺失——行号：" + (i + 1);
						continue;
					}
					if(row.getCell(4) != null && StringUtil.isNotEmptyString(row.getCell(4).toString())){
						bizSeoFriendLink.setRemark(row.getCell(4).toString().trim());
					}
					bizSeoFriendLink.setSeoType(seoType);
					String objectName = getObjectName(bizSeoFriendLink.getObjectId(), seoType);
					if(StringUtil.isNotEmptyString(objectName)){
						bizSeoFriendLink.setObjectName(objectName);
					}else{
						errorObjectIdList = errorObjectIdList + ", 对象不存在 ——行号：" + (i + 1);
						continue;
					}
					//查询是否已存在
					parameters.clear();
					parameters.put("objectId", bizSeoFriendLink.getObjectId());
					parameters.put("linkUrl", bizSeoFriendLink.getLinkUrl());
					parameters.put("seoType", bizSeoFriendLink.getSeoType());
					int count = MiscUtils.autoUnboxing(bizSeoFriendLinkService.querySeoFriendLinkTotalCount(parameters));
					// 判断此对象是否是已有的
					if (count > 0) {
						errorObjectIdList = errorObjectIdList + ", 重复URL ——行号：" + (i + 1);
						continue;
					}
					seoLinkList.add(bizSeoFriendLink);
				}
			}
        }  
        catch (Exception e)  
        {  
        	LOG.error(ExceptionFormatUtil.getTrace(e)); 
            this.sendAjaxMsg(e.getMessage(), request, response);
			return null;
        }  
        if (StringUtil.isNotEmptyString(errorObjectIdList)) {
			message = "请修正完以下问题再提交：" + errorObjectIdList;
			this.sendAjaxMsg(message, request, response);
			return null;
		}
		if (null != seoLinkList && (!seoLinkList.isEmpty())) {
			if (seoLinkList.size() > 1000) {
				this.sendAjaxMsg("数据条数超过1000条，请缩减条数!", request, response);
				return null;
			}
			// 数据插入
			int num = MiscUtils.autoUnboxing(bizSeoFriendLinkService.batchInsert(seoLinkList));
			if(num == 1){
			    message = "success";
			}
		} else {
			message = "插入数据为空,解析excel没有得到数据！";
		}
		this.sendAjaxMsg(message, request, response);
		return null;
	}
     
    /**
     * 导出excel数据
     * @author yuzhizeng
     */ 
	@RequestMapping(value = "/exportExcelData")
	public void exportExcelData(Model model, String seoType, String linkUrl, String objectName, 
			HttpServletRequest request, HttpServletResponse response) throws BusinessException {
			
		if (StringUtil.isEmptyString(seoType)) {
			this.sendAjaxMsg("seoType为空", request, response);
			return ;
		}
		
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("linkUrl", linkUrl);
		parameters.put("seoType", seoType);
		parameters.put("objectName", objectName);
		parameters.put("_orderby", " BIZ_SEO_FRIEND_LINK_ID DESC");
		List<BizSeoFriendLink> seoLinkList = MiscUtils.autoUnboxing(bizSeoFriendLinkService.selectPageListByParams(parameters));
		
		if (null != seoLinkList) {
			Map<String, Object> beans = new HashMap<String, Object>();
			beans.put("seoLinkList", seoLinkList);
			beans.put("seoTypeName", BizSeoFriendLink.SEO_TYPE.getCnName(seoType));
			
			String destFileName = writeExcelByjXls(beans, SEO_TEMPLATE_PATH);
			writeAttachment(destFileName, "seoLinksExcel" + DateUtil.formatDate(new Date(), "yyyy MM dd"), response);
		}
	}
	 
	
	/**
	 * 解析excel
	 * @param excelfile  导入 excel文件的地址
	 * @param xmlConfig 数据映射文件地址
	 * @return
  public static List<BizSeoFriendLink> parseExcelByjXls(String excelfile,String xmlConfig){
		try {
			InputStream inputXML = new BufferedInputStream(new FileInputStream(xmlConfig));
			XLSReader mainReader = ReaderBuilder.buildFromXML(inputXML);
			InputStream inputXLS = new BufferedInputStream(new FileInputStream(excelfile));
			BizSeoFriendLink seoLinks = new BizSeoFriendLink();
			List<BizSeoFriendLink> seoLinksList = new ArrayList<BizSeoFriendLink>();

			Map beans = new HashMap();
			beans.put("seoLinks", seoLinks);
			beans.put("seoLinksList", seoLinksList);
			mainReader.read(inputXLS, beans);
			return seoLinksList;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
     return null;
  }
 */
  	/**
  	 * 写excel通过模板 bean
  	 * @param beans
  	 * @param template
  	 * @return
  	 * @throws Exception
  	 */
	public static String writeExcelByjXls(Map<String,Object> beans, String template){
		try {
			File templateResource = ResourceUtil.getResourceFile(template);
			XLSTransformer transformer = new XLSTransformer();
			String destFileName = getTempDir() + "/excel" + new Date().getTime()+".xls";
			transformer.transformXLS(templateResource.getAbsolutePath(), beans, destFileName);
			return destFileName;
		}catch(Exception e){
			LOG.error(e.getMessage());
		}
		return null;
	}
	
	public static String getTempDir() {
		return System.getProperty("java.io.tmpdir");
	}
	
}
