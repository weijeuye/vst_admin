package com.lvmama.vst.back.prod.huaXiaAir;

import java.io.File;

import com.lvmama.comm.pet.fs.client.FSClient;
import com.lvmama.comm.pet.po.perm.PermUser;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;
import com.lvmama.vst.prod.query.huaXiaAir.LineProductAirCorpPriorityService;
import com.lvmama.vst.prod.query.huaXiaAir.ProdProductDescriptionService;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.prod.po.LineProductAirCorpPriority.AirCorpPriority;
import com.lvmama.vst.back.prod.po.LineProductAirCorpPriority.AirProName;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.comm.pet.vo.Page;
import com.lvmama.comm.sync.util.BizEnum;
import com.lvmama.dest.comm.po.biz.BizCategory;
import com.lvmama.vst.back.biz.po.BizDistrictSign;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.dujia.comm.prod.po.ProdProductDescription;
import com.lvmama.vst.back.goods.vo.ProdProductParam;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.utils.excel.ExcelUtil;
import com.lvmama.vst.back.utils.excel.Sheet;
import com.lvmama.vst.back.utils.excel.Workbook;
import com.lvmama.vst.comm.utils.WineSplitConstants;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.vo.ResultMessage;

/**
 * 华夏航空查询页面
 */
@Controller
@RequestMapping("/airlineQuery")
public class AirLineQueryAction extends BaseActionSupport {
	
	private static final Log LOG = LogFactory.getLog(AirLineQueryAction.class);

	@Autowired
	ProdProductService prodProductService;
	@Autowired
	private ComLogClientService comLogService;
	@Autowired
	private PermUserServiceAdapter permUserServiceAdapter;
	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;
	@Autowired
	private LineProductAirCorpPriorityService lineProductAirCorpPriorityService;
	@Autowired
	private ProdProductDescriptionService  productDescriptionService;
	@Autowired
	private FSClient vstFSClient;
	
	@RequestMapping(value = "/findCAirLine")
	public String findCAirLine(Model model, Integer page, BizDistrictSign districtSign, HttpServletRequest req, Long productManagerId,String productManagerName,String districtName, String longitudeNullFlag, String flag, ProdProduct prodProduct) {

		List<BizCategory> bizCategoryList = new ArrayList<BizCategory>();//暂时写死 酒店和酒套餐两个品类
		BizCategory travelGroup = new BizCategory();
		BizCategory travelFreedom = new BizCategory();
		
		travelGroup.setCategoryId(BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCategoryId());//跟团游
		travelGroup.setCategoryName(BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCnName());
		travelFreedom.setCategoryId(BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCategoryId());//自由游
		travelFreedom.setCategoryName(BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCnName());
		bizCategoryList.add(travelGroup);
		bizCategoryList.add(travelFreedom);
		List<Long> bizCategoryIdLst = new ArrayList<Long>();
		bizCategoryIdLst.add(bizCategoryList.get(0).getCategoryId());
		bizCategoryIdLst.add(bizCategoryList.get(1).getCategoryId());

		// 查询自由行子品类
		List<com.lvmama.vst.back.biz.po.BizCategory> subCategoryList = bizCategoryQueryService.getBizCategorysByParentCategoryId(WineSplitConstants.ROUTE_FREEDOM);
		model.addAttribute("subCategoryList", subCategoryList);
		Map<String, Object> paramProdProduct = new HashMap<String, Object>();
		if("%".equals(prodProduct.getProductName()))
		{
			paramProdProduct.put("productName","\\%"); // 产品名称
		}
		else
		{
		   paramProdProduct.put("productName", prodProduct.getProductName()); // 产品名称
		}
		paramProdProduct.put("productId", prodProduct.getProductId()); // 产品ID
		paramProdProduct.put("cancelFlag", prodProduct.getCancelFlag()); // 产品状态
		paramProdProduct.put("saleFlag", prodProduct.getSaleFlag()); // 是否可售
		paramProdProduct.put("abandonFlag", prodProduct.getAbandonFlag()); // 废弃标识
		paramProdProduct.put("subCategoryId", prodProduct.getSubCategoryId()); // 子分类id
		
		if (!"".equalsIgnoreCase(prodProduct.getAuditStatus())) {
			paramProdProduct.put("auditStatus", prodProduct.getAuditStatus()); // 审核状态
		}
		
		if(prodProduct.getBizCategory()==null)
		{
			paramProdProduct.put("bizCategoryIdLst", bizCategoryIdLst); // 品类
		}
		if(prodProduct.getBizCategory()!=null)
		{
			if (prodProduct.getBizCategory().getCategoryId()== null) 
			{
				paramProdProduct.put("bizCategoryIdLst", bizCategoryIdLst); // 品类	
			}
			if(prodProduct.getBizCategory().getCategoryId()!=null)
			{
				paramProdProduct.put("bizCategoryId", prodProduct.getBizCategory().getCategoryId());
			}
		}
		
		paramProdProduct.put("productManagerId", productManagerId); // 产品经理
		paramProdProduct.put("suppProductName", prodProduct.getSuppProductName()); // 供应商产品名称
		
		int count = prodProductService.findProdProductAirCount(paramProdProduct);
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		paramProdProduct.put("_start", pageParam.getStartRows());
		paramProdProduct.put("_end", pageParam.getEndRows());
		paramProdProduct.put("_orderby", "PRODUCT_ID");
		paramProdProduct.put("_order", "DESC");
		paramProdProduct.put("isneedmanager", "false");
		ProdProductParam productParam = new ProdProductParam();
		productParam.setBizCategory(true);
		productParam.setBizDistrict(true);
		productParam.setTraffic(true);
		int airFlag=1;
		List<ProdProduct> list = prodProductService.findProdProductAirList(prodProduct,paramProdProduct, productParam,airFlag);
		//设置产品经理
        Map<String, Object> params = new HashMap<String, Object>();
        Set<Long> manageIds = new HashSet<Long>();

        for (ProdProduct pro : list) 
        {
        	manageIds.add(pro.getManagerId());
        }
        params.put("userIds", manageIds.toArray());
        params.put("maxResults", 100);
        params.put("skipResults", 0);

        List<PermUser> permUserList = permUserServiceAdapter.queryPermUserByParam(params);
        for (ProdProduct pro : list) {
        	
        	for (PermUser permUser : permUserList) {
                if (pro.getManagerId()!=null&&pro.getManagerId().equals(permUser.getUserId())) {
                	pro.setManagerName(permUser.getRealName());
                }
            }
        }
        
		pageParam.setItems(list);
		model.addAttribute("auditStatus", prodProduct.getAuditStatus());
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("prodProduct", prodProduct);
		model.addAttribute("bizCategory", prodProduct.getBizCategory());
		model.addAttribute("bizCategoryList", bizCategoryList); // 自由行
		//model.addAttribute("goodsId", goodsId);
		model.addAttribute("productManagerId", productManagerId);
		model.addAttribute("productManagerName", productManagerName);
		model.addAttribute("abandonFlag", prodProduct.getAbandonFlag());
		//演出票
		model.addAttribute("showTicket", BizEnum.BIZ_CATEGORY_TYPE.category_show_ticket);
		return "/prod/airline/CAirline";
	}
	
	@RequestMapping(value = "/findCAirLineAdd")
	public String findCAirLineAdd(Model model, Integer page, BizDistrictSign districtSign, HttpServletRequest req, Long productManagerId,String productManagerName,String districtName, String longitudeNullFlag, String flag, ProdProduct prodProduct) {
		int airFlag=2;
		List<BizCategory> bizCategoryList = new ArrayList<BizCategory>();//暂时写死 酒店和酒套餐两个品类
		BizCategory travelGroup = new BizCategory();
		BizCategory travelFreedom = new BizCategory();
		travelGroup.setCategoryId(BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCategoryId());//跟团游
		travelGroup.setCategoryName(BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCnName());
		travelFreedom.setCategoryId(BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCategoryId());//自由游
		travelFreedom.setCategoryName(BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCnName());
		
		bizCategoryList.add(travelGroup);
		bizCategoryList.add(travelFreedom);
		List<Long> bizCategoryIdLst = new ArrayList<Long>();
		bizCategoryIdLst.add(bizCategoryList.get(0).getCategoryId());
		bizCategoryIdLst.add(bizCategoryList.get(1).getCategoryId());
		int count=0;
		// 查询自由行子品类
		List<com.lvmama.vst.back.biz.po.BizCategory> subCategoryList = bizCategoryQueryService.getBizCategorysByParentCategoryId(WineSplitConstants.ROUTE_FREEDOM);
		model.addAttribute("subCategoryList", subCategoryList);
		Map<String, Object> paramProdProduct = new HashMap<String, Object>();
		
		//process id list
		int pagenum = page == null ? 1 : page;
		if("%".equals(prodProduct.getProductName()))
		{
			paramProdProduct.put("productName","\\%"); // 产品名称
		}
		else
		{
		   paramProdProduct.put("productName", prodProduct.getProductName()); // 产品名称
		}
		paramProdProduct.put("productId", prodProduct.getProductId()); // 产品ID
		paramProdProduct.put("cancelFlag",prodProduct.getCancelFlag()); // 产品状态
		paramProdProduct.put("saleFlag", prodProduct.getSaleFlag()); // 是否可售
		paramProdProduct.put("abandonFlag", "N"); // 废弃标识
		paramProdProduct.put("subCategoryId", prodProduct.getSubCategoryId()); // 子分类id
		
		if (!"".equalsIgnoreCase(prodProduct.getAuditStatus())) {
			paramProdProduct.put("auditStatus", prodProduct.getAuditStatus()); // 审核状态
		}
		
		
		if(prodProduct.getBizCategory()!=null)
		{
			if(prodProduct.getBizCategory().getCategoryId()!=null)
			{
				if("15".equals(prodProduct.getBizCategory().getCategoryId().toString()))
				{
				  paramProdProduct.put("bizCategoryId", prodProduct.getBizCategory().getCategoryId());
				}
				else
				{
				  paramProdProduct.put("bizCategoryId", prodProduct.getBizCategory().getCategoryId());
				  paramProdProduct.put("subCategoryId", "182");
				}
			}
		}	

		paramProdProduct.put("productManagerId", productManagerId); // 产品经理
		paramProdProduct.put("suppProductName", prodProduct.getSuppProductName()); // 供应商产品名称
		
		Map<String, Object> paramAir = new HashMap<String, Object>();
		String  productIdsStr= req.getParameter("productIdsStr");
		if(productIdsStr == null||"".equals(productIdsStr)) {
			
			if(prodProduct.getBizCategory()==null)
			{
				 count = prodProductService.findAirPartProdProductCount(paramProdProduct);
			}
			if(prodProduct.getBizCategory()!=null)
			{
				if (prodProduct.getBizCategory().getCategoryId()== null) 
				{
				  count = prodProductService.findAirPartProdProductCount(paramProdProduct);	
				}
				if (prodProduct.getBizCategory().getCategoryId()!= null) 
				{
				  count = prodProductService.findAirPartProdProductCount(paramProdProduct);
				}
			}
		} else {
			airFlag=3;
			Map<String, Object> paramProd = new HashMap<String, Object>();
			String arr[] = productIdsStr.split("\\*");
			List<Long> productIds = new ArrayList<Long>();
			for(String id : arr) {
				if("f".equals(id)){
					return "/prod/airline/addSettingPage";
				}
				else{
					productIds.add(Long.valueOf(id));
				}
			}
			if(!productIds.isEmpty()) {
				paramProdProduct.put("productIdLst", productIds);
				paramProd.put("productIdLst", productIds);
				if(productIds.size()>100)
				{
				   model.addAttribute("abandonFlag", prodProduct.getAbandonFlag());
				   return "/prod/airline/importShow";
				}
			}
			count = prodProductService.findAirAllProdProductCount(paramProd);
		}
		
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		paramProdProduct.put("_start", pageParam.getStartRows());
		paramProdProduct.put("_end", pageParam.getEndRows());
		paramProdProduct.put("_orderby", "PRODUCT_ID");
		paramProdProduct.put("_order", "DESC");
		paramProdProduct.put("isneedmanager", "false");
		ProdProductParam productParam = new ProdProductParam();
		productParam.setBizCategory(true);
		productParam.setBizDistrict(true);
		productParam.setTraffic(true);
		
		List<ProdProduct> list = prodProductService.findProdProductAirList(prodProduct,paramProdProduct, productParam, airFlag);
		
		pageParam.setItems(list);
		model.addAttribute("auditStatus", prodProduct.getAuditStatus());
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("prodProduct", prodProduct);
		model.addAttribute("bizCategory", prodProduct.getBizCategory());
		model.addAttribute("bizCategoryList", bizCategoryList); // 自由行
		//model.addAttribute("goodsId", goodsId);
		model.addAttribute("productManagerId", productManagerId);
		model.addAttribute("productManagerName", productManagerName);
		model.addAttribute("abandonFlag", prodProduct.getAbandonFlag());
		
		//演出票
		model.addAttribute("showTicket", BizEnum.BIZ_CATEGORY_TYPE.category_show_ticket);
		return "/prod/airline/addSettingPage";
	}

	@RequestMapping(value = "/batchImport")
	@ResponseBody
	public List<String> batchImport(@RequestParam("myfile") CommonsMultipartFile file, HttpServletRequest req) 
	{
		int count = -1;
		int totalNum=-1;
		String NoUsedIds="";
		List<String> list = new ArrayList<String>();
		List<String> dataList=new ArrayList<String>();
		char errorMark='t';
		try {
	        File tempFile = null;
		    if (!file.isEmpty()) {
	            // 获得原始文件名
	            String fileName = file.getOriginalFilename();
	            // 重命名文件
	            String newfileName = new Date().getTime() + String.valueOf(fileName);
	            //获得物理路径webapp所在路径
	            /**
	             * request.getSession().getServletContext().getRealPath("/")表示当前项目的根路径，如
	             * D:\Workspaces\eclipse_luna\.metadata\.plugins\org.eclipse.wst.server.core\tmp3\wtpwebapps\sky\
	             */
	            String pathRoot = req.getSession().getServletContext().getRealPath("");
	            // 项目下相对路径
	            String path = "\\" + newfileName;
	            // 创建文件实例
	             tempFile = new File(pathRoot + path);
	            // 判断父级目录是否存在，不存在则创建
	            if (!tempFile.getParentFile().exists()) {
	                tempFile.getParentFile().mkdir();
	            }
	            // 判断文件是否存在，否则创建文件（夹）
	            if (!tempFile.exists()) {
	                tempFile.mkdir();
	            }
	                // 将接收的文件保存到指定文件中
	                file.transferTo(tempFile);
		 	// TODO Auto-generated method stub
				Workbook wb = null;
				wb = ExcelUtil.readExcel(tempFile);
				tempFile.delete();
				System.out.println(tempFile);
				Sheet sheet = wb.getSheetAt(0);
				for (int i = 0; i <=sheet.getLastRowNum(); i++) 
				{
				   if(sheet.getRow(i).getLastCellNum()>1)
				   {
					   errorMark='f';
					   break;
				   }
				   else
				   {
					   list.add(sheet.getRow(i).getCell(0).getStringCellValue());
				   }
				}
				//LOG.info("batchImport.start fileName="+filename);
		    }
			
		StringBuilder sb = new StringBuilder();
		for(int i = 0; i< list.size(); i++) {
			if(i != list.size() -1) {
				sb.append(list.get(i)).append('*');
			} else {
				sb.append(list.get(i));
			}
		}
		List<BizCategory> bizCategoryList = new ArrayList<BizCategory>();//暂时写死 酒店和酒套餐两个品类
		BizCategory travelGroup = new BizCategory();
		BizCategory travelFreedom = new BizCategory();
		
		travelGroup.setCategoryId(BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCategoryId());//跟团游
		travelGroup.setCategoryName(BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCnName());
		travelFreedom.setCategoryId(BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCategoryId());//自由游
		travelFreedom.setCategoryName(BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCnName());
		bizCategoryList.add(travelGroup);
		bizCategoryList.add(travelFreedom);
		List<Long> bizCategoryIdLst = new ArrayList<Long>();
		bizCategoryIdLst.add(bizCategoryList.get(0).getCategoryId());
		bizCategoryIdLst.add(bizCategoryList.get(1).getCategoryId());
		List<Long> productIds = new ArrayList<Long>();
		String arr[] =sb.toString().split("\\*");
		Map<String, Object> paramAir = new HashMap<String, Object>();
		for(String id : arr) {
			productIds.add(Long.valueOf(id));
			paramAir.put("productId", Long.valueOf(id));
			paramAir.put("abandonFlag", "N"); // 废弃标识
			int a=prodProductService.findAirPartProdProductCount(paramAir);
			if(a==0)
			{
				NoUsedIds=NoUsedIds+id+",";
			}
		}
		
		Map<String, Object> paramProdProduct = new HashMap<String, Object>();
		paramProdProduct.put("productIdLst", productIds);
		paramProdProduct.put("abandonFlag", "N"); // 废弃标识
		count = prodProductService.findAirAllProdProductCount(paramProdProduct);
		totalNum=productIds.size();
		dataList.add(sb.toString());
		dataList.add(totalNum+"");
		dataList.add(count+"");
		dataList.add(NoUsedIds+"");
		} catch (Exception e) {
			errorMark='f';
			 e.printStackTrace();
		}
		dataList.add(errorMark+"");
		return dataList;
	}
	
	
	@RequestMapping(value = "/findAddCAirLine")
	public String findAddCAirLine(Model model, Integer page, BizDistrictSign districtSign, HttpServletRequest req,
			String districtName, String longitudeNullFlag, String flag, ProdProduct prodProduct) {
		Map<String, Object> paramProdProduct = new HashMap<String, Object>();
		paramProdProduct.put("productName", prodProduct.getProductName()); // 产品名称
		paramProdProduct.put("productId", prodProduct.getProductId()); // 产品ID
		paramProdProduct.put("cancelFlag", "Y"); // 产品状态
		paramProdProduct.put("saleFlag", prodProduct.getSaleFlag()); // 是否可售
		paramProdProduct.put("abandonFlag", prodProduct.getAbandonFlag()); // 废弃标识
		paramProdProduct.put("subCategoryId", prodProduct.getSubCategoryId()); // 子分类id

		if (!"".equalsIgnoreCase(prodProduct.getAuditStatus())) {
			paramProdProduct.put("auditStatus", prodProduct.getAuditStatus()); // 审核状态
		}
		paramProdProduct.put("suppProductName", prodProduct.getSuppProductName()); // 供应商产品名称
		
		int count = prodProductService.findProdProductCount(paramProdProduct);
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		paramProdProduct.put("_start", pageParam.getStartRows());
		paramProdProduct.put("_end", pageParam.getEndRows());
		paramProdProduct.put("_orderby", "PRODUCT_ID");
		paramProdProduct.put("_order", "DESC");
		paramProdProduct.put("isneedmanager", "false");
		ProdProductParam productParam = new ProdProductParam();
		productParam.setBizCategory(true);
		productParam.setBizDistrict(true);
		List<ProdProduct> list = prodProductService.findProdProductList(paramProdProduct, productParam);
	
		pageParam.setItems(list);
		model.addAttribute("auditStatus", prodProduct.getAuditStatus());
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("prodProduct", prodProduct);
	
		model.addAttribute("abandonFlag", prodProduct.getAbandonFlag());
		//演出票 
		model.addAttribute("showTicket", BizEnum.BIZ_CATEGORY_TYPE.category_show_ticket);
		return "/prod/airline/addSettingPage";
	}
	
	@RequestMapping(value = "/findSetting")
	public String findSetting(Model model, Long productId,String noticeType, Integer page, HttpServletRequest req)  {
		
		List<AirCorpPriority> result = null;
		List<AirProName> airNameChecked=new ArrayList<AirProName>();
		List<String> allResult = null;
		List<String> markedList=new ArrayList<String>();
		List<AirProName> airNameNotChecked=new ArrayList<AirProName>();
		List<AirCorpPriority> tempResult = new ArrayList<AirCorpPriority>();

		try{
			result = lineProductAirCorpPriorityService.getAirCorpPriorityByProductId(productId);
			allResult=lineProductAirCorpPriorityService.getAllAirCorpPriorityByProductId(productId);
			for(int i=0;i<result.size();i++)
			{
				int isWork=1;
				for(int j=0;j<allResult.size();j++)
				{
					if(allResult.get(j).equals(result.get(i).getAirCode()))
					{
						isWork=2;
					}
				}
				if(isWork==1)
				{
					tempResult.add(result.get(i));
				}
			}
			result.removeAll(tempResult);
			for(int i=0;i<result.size();i++)
			{
				markedList.add(result.get(i).getAirCode());
				String airName="";
				List<String> tmpL=productDescriptionService.findDict_name(result.get(i).getAirCode());
				if(tmpL!=null&&tmpL.size()>0)
				airName=tmpL.get(0);
				AirProName airChecked=new AirProName();
				airChecked.setAirName(airName);
				airChecked.setAirCorpPriority(result.get(i));
				airNameChecked.add(airChecked);
			}
			allResult.removeAll(markedList);
			for(int i=0;i<allResult.size();i++)
			{
				String airName="";
				List<String> tmpL=productDescriptionService.findDict_name(allResult.get(i));
				if(tmpL!=null&&tmpL.size()>0)
				airName=tmpL.get(0);
				AirProName airNotChecked=new AirProName();
				airNotChecked.setAirName(airName);
				AirCorpPriority airPr=new AirCorpPriority();
				airPr.setAirCode(allResult.get(i));
				airNotChecked.setAirCorpPriority(airPr);
				airNameNotChecked.add(airNotChecked);
			}
			
		}catch(Exception e) {
			LOG.error(e.getMessage(), e);
		}
		model.addAttribute("airNameChecked", airNameChecked);
		model.addAttribute("airNameNotChecked", airNameNotChecked);
		model.addAttribute("result", result);
		model.addAttribute("allResult", allResult);
		model.addAttribute("productId", productId);
		return "/prod/airline/findSetting";
	}
	
	@RequestMapping(value = "/addSave")
	public String addSave(Model model, Long productId,String noticeType, Integer page, HttpServletRequest req,String []arr)  {
		
		ProdProductDescription productDesc=new ProdProductDescription();
		if(lineProductAirCorpPriorityService.queryProdDescId(productId)!=null&&(lineProductAirCorpPriorityService.queryProdDescId(productId).size()!=0))
		{
			productDesc.setProdDescId(Long.parseLong(lineProductAirCorpPriorityService.queryProdDescId(productId).get(0)));
		}
		productDesc.setProductId(productId);
		
		List<AirCorpPriority> priorities=new ArrayList<AirCorpPriority>();
		String logContent="";
		String tripMark="";
		for(int i=0;i<arr.length;i++)
		{
			AirCorpPriority apri=new AirCorpPriority();
			String []mpri=arr[i].split("\\*");
			apri.setAirCode(mpri[0]);
			String airName = "";
			List<String> tmpL=productDescriptionService.findDict_name(mpri[0]);
			if(tmpL!=null&&tmpL.size()>0)
			{
				airName= tmpL.get(0);

			}
			if(mpri[1].length()==1)
			{
			apri.setPriority(mpri[1].charAt(0));
			}
			if(mpri[1].length()==2)
			{
			apri.setPriority('A');
			}
			apri.setTripFlag(mpri[2]);
			if("BACK".equals(mpri[2]))
			{
				tripMark="返程";
			}	
			if("TO".equals(mpri[2]))
			{
				 tripMark="去程";
			}
			if("TOBACK".equals(mpri[2]))
			{
				 tripMark="往返程";
			}
			logContent=logContent+airName+"("+tripMark+",优先级:"+mpri[1]+")";
			if(i<arr.length-1)
			{
			 logContent=logContent+"、";
			}
			priorities.add(apri);
		}
		try{
			lineProductAirCorpPriorityService.savePriority(productDesc, priorities);
			
			comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_AIRLINE, 
					productId, productId,
					this.getLoginUser().getUserName(), 
					"新增设置为："+logContent, 
					COM_LOG_LOG_TYPE.PROD_AIRLINE_CHANGE.name(), 
					"新增设置",null);
		
		}catch(Exception e) {
			LOG.error(e.getMessage(), e);
		}
		return "/prod/airline/findSetting";
	}
	
	@RequestMapping(value = "/saveSetting")
	@ResponseBody
	public Long saveSetting(Long productId, String []arr,HttpServletRequest req)  {
		
		ProdProductDescription productDesc=new ProdProductDescription();
		if(lineProductAirCorpPriorityService.queryProdDescId(productId)!=null&&(lineProductAirCorpPriorityService.queryProdDescId(productId).size()!=0))
		{
			productDesc.setProdDescId(Long.parseLong(lineProductAirCorpPriorityService.queryProdDescId(productId).get(0)));
		}
		productDesc.setProductId(productId);
		
		List<AirCorpPriority> priorities=new ArrayList<AirCorpPriority>();
		String logContent="";
		String tripMark="";
		for(int i=0;i<arr.length;i++)
		{
			AirCorpPriority apri=new AirCorpPriority();
			String []mpri=arr[i].split("\\*");
			apri.setAirCode(mpri[0]);
			String airName = "";
			List<String> tmpL=productDescriptionService.findDict_name(mpri[0]);
			if(tmpL!=null&&tmpL.size()>0)
			{
				airName= tmpL.get(0);
			}
			if(mpri[1].length()==1)
			{
			apri.setPriority(mpri[1].charAt(0));
			}
			if(mpri[1].length()==2)
			{
			apri.setPriority('A');
			}
			apri.setTripFlag(mpri[2]);
			if("BACK".equals(mpri[2]))
			{
				tripMark="返程";
			}	
			if("TO".equals(mpri[2]))
			{
				 tripMark="去程";
			}
			if("TOBACK".equals(mpri[2]))
			{
				 tripMark="往返程";
			}
			logContent=logContent+airName+"("+tripMark+",优先级:"+mpri[1]+")";
			if(i<arr.length-1)
			{
			 logContent=logContent+"、";
			}
			priorities.add(apri);
		}
		try{
			lineProductAirCorpPriorityService.savePriority(productDesc, priorities);
			
			comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_AIRLINE, 
					productId, productId,
					this.getLoginUser().getUserName(), 
					"修改设置为："+logContent, 
					COM_LOG_LOG_TYPE.PROD_AIRLINE_CHANGE.name(), 
					"修改设置",null);
		
		}catch(Exception e) {
			LOG.error(e.getMessage(), e);
		}
		return productId;
	}
	
	@RequestMapping(value = "/repealSetting")
	@ResponseBody
	public Object repealSetting(Model model, Long productId,String noticeType, Integer page, HttpServletRequest req, ProdProduct prodProduct, Long productManagerId,String productManagerName)  {
		ProdProductDescription productDesc=new ProdProductDescription();
		if(lineProductAirCorpPriorityService.queryProdDescId(productId)!=null&&(lineProductAirCorpPriorityService.queryProdDescId(productId).size()!=0))
		{
			productDesc.setProdDescId(Long.parseLong(lineProductAirCorpPriorityService.queryProdDescId(productId).get(0)));
		}
		
		productDesc.setProductId(productId);
		List<AirCorpPriority> priorities=new ArrayList<AirCorpPriority>();
		
		try{
			lineProductAirCorpPriorityService.deletePriority(productDesc, priorities);
			
		 	comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_AIRLINE, 
					productId, productId,
					this.getLoginUser().getUserName(), 
					"删除设置", 
					COM_LOG_LOG_TYPE.PROD_AIRLINE_CHANGE.name(), 
					"删除设置",null);
			
		}catch(Exception e) {
			LOG.error(e.getMessage(), e);
		}
		
		ResultMessage meg=new ResultMessage("success", "保存成功");
		return meg;
		
	}
	@RequestMapping(value = "/addSavePage")
	public String addSavePage(Model model, Long productId,String noticeType, Integer page, HttpServletRequest req)  {
		List<AirCorpPriority> result = null;
		List<AirProName> airNameChecked=new ArrayList<AirProName>();
		List<String> allResult = null;
		List<String> markedList=new ArrayList<String>();
		List<AirProName> airNameNotChecked=new ArrayList<AirProName>();
		List<AirCorpPriority> tempResult = new ArrayList<AirCorpPriority>();

		int checkFlag=0;
		try{
			result = lineProductAirCorpPriorityService.getAirCorpPriorityByProductId(productId);
			allResult=lineProductAirCorpPriorityService.getAllAirCorpPriorityByProductId(productId);
			for(int i=0;i<result.size();i++)
			{
				int isWork=1;
				for(int j=0;j<allResult.size();j++)
				{
					if(allResult.get(j).equals(result.get(i).getAirCode()))
					{
						isWork=2;
					}
				}
				if(isWork==1)
				{
					tempResult.add(result.get(i));
				}
			}
			result.removeAll(tempResult);
			for(int i=0;i<result.size();i++)
			{
				checkFlag=1;
				markedList.add(result.get(i).getAirCode());
				String airName="";
				List<String> tmpL=productDescriptionService.findDict_name(result.get(i).getAirCode());
				if(tmpL!=null&&tmpL.size()>0)
				airName=tmpL.get(0);
				AirProName airChecked=new AirProName();
				airChecked.setAirName(airName);
				airChecked.setAirCorpPriority(result.get(i));
				airNameChecked.add(airChecked);
			}
			allResult.removeAll(markedList);
			for(int i=0;i<allResult.size();i++)
			{
				String airName="";
				List<String> tmpL=productDescriptionService.findDict_name(allResult.get(i));
				if(tmpL!=null&&tmpL.size()>0)
				airName=tmpL.get(0);
				AirProName airNotChecked=new AirProName();
				airNotChecked.setAirName(airName);
				AirCorpPriority airPr=new AirCorpPriority();
				airPr.setAirCode(allResult.get(i));
				airNotChecked.setAirCorpPriority(airPr);
				airNameNotChecked.add(airNotChecked);
			}
			
		}catch(Exception e) {
			LOG.error(e.getMessage(), e);
		}
		model.addAttribute("airNameChecked", airNameChecked);
		model.addAttribute("airNameNotChecked", airNameNotChecked);
		model.addAttribute("result", result);
		model.addAttribute("allResult", allResult);
		model.addAttribute("productId", productId);
		model.addAttribute("checkFlag", checkFlag);
		return "/prod/airline/addSetting";
	}
	@RequestMapping(value = "/addSetting")
	public String addSetting(Model model, Long productId,String noticeType, Integer page, HttpServletRequest req)  {
		List<BizCategory> bizCategoryList = new ArrayList<BizCategory>();//暂时写死 酒店和酒套餐两个品类
		BizCategory travelGroup = new BizCategory();
		BizCategory travelFreedom = new BizCategory();
		
		travelGroup.setCategoryId(BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCategoryId());//跟团游
		travelGroup.setCategoryName(BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCnName());
		travelFreedom.setCategoryId(BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCategoryId());//自由游
		travelFreedom.setCategoryName(BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCnName());
		bizCategoryList.add(travelGroup);
		bizCategoryList.add(travelFreedom);
		model.addAttribute("bizCategoryList", bizCategoryList); // 自由行

		return "/prod/airline/addSettingPage";
	}
	
	 private void uploadFile(MultipartFile file, String serverType, String string) throws IOException,Exception {
		 LOG.debug("start upload file.");
		 String fileName = file.getOriginalFilename();
		 if (file.getSize() > 18874368L) {
		     throw new IllegalArgumentException("文件不可以大于18M");
		 }
		 Long pid = vstFSClient.uploadFile(fileName, file.getBytes(), serverType);
		 if (pid == 0) {
		     throw new IllegalArgumentException("上传文件失败");
		 }
	
	 }

}
