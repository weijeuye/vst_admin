package com.lvmama.vst.back.prod.web;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizBranch;
import com.lvmama.vst.back.biz.po.BizBranchProp;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.service.BizBranchQueryService;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.biz.service.BranchPropService;
import com.lvmama.vst.back.client.biz.service.BranchClientService;
import com.lvmama.vst.back.biz.service.DictService;
import com.lvmama.vst.back.customized.po.CustomizedProduct;
import com.lvmama.vst.back.client.customized.service.CustomizedProductClientService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.goods.vo.ProdProductParam;
import com.lvmama.vst.back.newHotelcomb.po.ProdHotelcombBranch;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductBranch;
import com.lvmama.vst.back.prod.po.ProdProductBranchProp;
import com.lvmama.vst.back.prod.po.ProdProductProp;
import com.lvmama.vst.back.prod.service.ProdProductBranchAdapterService;
import com.lvmama.vst.back.client.prod.service.ProdProductBranchPropClientService;
import com.lvmama.vst.back.prod.service.ProdProductBranchService;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.prod.service.newHotelcomb.IHotelcombBranchService;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.pub.service.ComPushClientService;
import com.lvmama.vst.back.router.adapter.ProdProductHotelAdapterService;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.vo.Constant.PROPERTY_INPUT_TYPE_ENUM;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.pet.goods.PetProdGoodsAdapter;
import com.lvmama.vst.back.utils.MiscUtils;

/**
 * 产品规格管理Action
 * 
 * @author qiujiehong
 * @date 2013-10-11
 */

@Controller
@RequestMapping("/prod/prodbranch")
public class ProdProductBranchAction extends BaseActionSupport {
	/**
	 * 获得产品规格列表
	 * 
	 * @return
	 */
	@Autowired
	private ProdProductBranchService prodProductBranchService;
	@Autowired
	private ProdProductBranchAdapterService prodProductBranchAdapterService;
	@Autowired
	private ProdProductHotelAdapterService prodProductHotelAdapterService;

	@Autowired
	private BranchPropService branchPropService;

	@Autowired
	private DictService dictService;

	@Autowired
	private ProdProductBranchPropClientService prodProductBranchPropService;

	@Autowired
	private BranchClientService branchService;

	@Autowired
	private ProdProductService prodProductService;

	@Autowired
	private ComLogClientService comLogService;

	@Autowired
	private PetProdGoodsAdapter petProdGoodsAdapter;
	
	@Autowired
	private ComPushClientService comPushService;
	
	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;
	
	@Autowired
	private BizBranchQueryService bizBranchQueryService;
	
	@Autowired
	private CustomizedProductClientService customizedProductService;
	
	@Autowired
	private IHotelcombBranchService iHotelcombBranchService;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/findProductBranchList.do")
	public String findProductBranchList(Model model, Integer page, ProdProductBranch prodProductBranch, Long productId, Long categoryId, HttpServletRequest req) throws BusinessException {
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("productBranchId", prodProductBranch.getProductBranchId());
		parameters.put("productId", productId);
		parameters.put("_orderby", "RECOMMEND_LEVEL");
		parameters.put("_order", "DESC");
		List<ProdProductBranch> prodProductBranchList = prodProductBranchService.findProdProductBranchList(parameters);
		TreeMap branchIdMap = new TreeMap<String, List>(new Comparator() {
			@Override
			public int compare(Object o1, Object o2) {
				// 如果有空值，直接返回0
				if ((o1 == null) || (o2 == null)) {
					return 0;
				}
				String ck1 = String.valueOf(o1);
				String ck2 = String.valueOf(o2);
				return ck1.compareTo(ck2);
			}
		});
		for (ProdProductBranch prodProductBranch2 : prodProductBranchList) {
			String prodProductBranchKey = "";
			prodProductBranch2.setBizBranch(bizBranchQueryService.selectBranchByPrimaryKey(prodProductBranch2.getBranchId()));
			if ("Y".equals(prodProductBranch2.getBizBranch().getAttachFlag())) {
				prodProductBranchKey = "1<h2 class='fl'>" + prodProductBranch2.getBizBranch().getBranchName() + "</h2> (主规格)";
			} else {
				prodProductBranchKey = "2<h2 class='fl'>" + prodProductBranch2.getBizBranch().getBranchName() + "</h2> (次规格)";
			}
			if (branchIdMap.containsKey(prodProductBranchKey)) {
				((List) branchIdMap.get(prodProductBranchKey)).add(prodProductBranch2);
			} else {
				List prodProductBranchListArray = new ArrayList<ProdProductBranch>();
				prodProductBranchListArray.add(prodProductBranch2);
				branchIdMap.put(prodProductBranchKey, prodProductBranchListArray);
			}
		}

		
		List<BizBranch> branchList = bizBranchQueryService.findBranchListByCategoryId(categoryId);
		model.addAttribute("branchList", branchList);
		model.addAttribute("productId", productId);
		BizCategory bizCategory = bizCategoryQueryService.getCategoryById(categoryId);
		model.addAttribute("bizCategory", bizCategory);
		model.addAttribute("prodProductBranchMap", branchIdMap);
		return "/prod/prodbranch/findProductBranchList";
	}

	/**
	 * 查看产品规格
	 */
	public String showProductBranch() {

		return "";
	}

	/**
	 * 跳转到修改产品规格页面
	 */
	@RequestMapping(value = "/showUpdateBranch.do")
	public String showUpdateProductBranch(Model model, Long productBranchId, Long branchId) throws BusinessException {

		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("branchId", branchId);
		params.put("_orderby", "SEQ");
		params.put("productBranchId",productBranchId);
		//查询该规格下面所有的产品规格（包括无效的）
		List<BizBranchProp> branchPropList = branchPropService.findBranchPropsByParams(params);
		List<BizBranchProp> branchPropList2 = new ArrayList<BizBranchProp>();
		//设置产品规格属性
		if(branchPropList!=null){
			for(BizBranchProp branchProp : branchPropList){
				params.clear();
				params.put("productBranchId", productBranchId);
				params.put("propId", branchProp.getPropId());
				List<ProdProductBranchProp> prodProductBranchPropList =  prodProductBranchAdapterService.findProdProductBranchPropList(params);
				if(prodProductBranchPropList!=null&&prodProductBranchPropList.size()>0){
					branchProp.setProdProductBranchProp(prodProductBranchPropList.get(0));
				}
				//该处过滤掉无效的规格（如果该规格无效但是已经设置了对应的产品规格，则保留）
				if("Y".equals(branchProp.getCancelFlag())||branchProp.getProdProductBranchProp()!=null){
					branchPropList2.add(branchProp);
				}
			}
		}
		model.addAttribute("addValueTitle", ProdProductProp.PROP_ADD_VALUE_SPLIT);
		model.addAttribute("branchPropList", branchPropList);
		ProdProductBranch prodProductBranch = prodProductBranchAdapterService.findProdProductBranchById(productBranchId, Boolean.TRUE, Boolean.TRUE);
		model.addAttribute("productBranch", prodProductBranch);
		ProdProduct product = prodProductHotelAdapterService.findProdProductByIdAndParam(prodProductBranch.getProductId(), new ProdProductParam());
		model.addAttribute("productType", product.getProductType());
		return "/prod/prodbranch/showUpdateBranch";
	}

	/**
	 * 跳转到选择有效规格
	 */
	@RequestMapping(value = "/showBranchs.do")
	public String showBranchs(Model model, Long productId, Long categoryId) throws BusinessException {
		List<BizBranch> branchList = bizBranchQueryService.findBranchListByCategoryId(categoryId);
		model.addAttribute("branchList", branchList);
		model.addAttribute("productId", productId);
		return "/prod/prodbranch/showBranchs";
	}

	/**
	 * 跳转到添加产品规格
	 */
	@RequestMapping(value = "/showAddProductBranch.do")
	public String showAddProductBranch(Model model, Long productId, Long branchId) throws BusinessException {
		// Long branchId = Long.valueOf(request.getParameter("branchId"));
		if (branchId != null) {
			BizBranch bizBranch = bizBranchQueryService.selectBranchByPrimaryKey(branchId);
			model.addAttribute("bizBranch", bizBranch);
			List<BizBranchProp> list = bizBranchQueryService.findBranchPropListByBranchId(branchId);
			model.addAttribute("branchPropList", list);
		}
		model.addAttribute("addValueTitle", ProdProductProp.PROP_ADD_VALUE_SPLIT);
		model.addAttribute("productId", productId);
		ProdProduct product = prodProductService.findProdProductById(productId, new ProdProductParam());
		model.addAttribute("productType", product.getProductType());
		return "/prod/prodbranch/showAddProductBranch";
	}


	/**
	 * 校验酒店下规格名称是否重名
	 * Created by yangzhenzhong
	 * @return
	 */
	@RequestMapping(value = "/checkDuplicateBranchName.do")
	@ResponseBody
	public Object checkDuplicateBranchName(Long productId,String branchName) {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productId", productId);
		params.put("branchName", branchName.trim());
		int count = prodProductBranchService.checkDuplicateBranchName(params);

		if(count==0){
			return ResultMessage.ADD_SUCCESS_RESULT;
		}else {
			return ResultMessage.ADD_FAIL_RESULT;
		}
	}

	/**
	 * 更新产品规格
	 */
	@RequestMapping(value = "/updateProductBranch.do")
	@ResponseBody
	public Object updateProductBranch(ProdProductBranch prodProductBranch) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<updateProductBranch>");
		}
		//获取原来的规格
		ProdProductBranch oldProdProductBranch = prodProductBranchService.findProdProductBranchById(prodProductBranch.getProductBranchId());
		//填充产品规格属性列表
		prodProductBranchService.findPropValueOfProdBranch(oldProdProductBranch,true,true);
		prodProductBranchService.updateProdProductBranch(prodProductBranch);

		//获取操作日志
		try {
			String logContent = getProductBranchChangeLog(oldProdProductBranch,prodProductBranch);
			if(null!=logContent && !"".equals(logContent)) {
				//添加操作日志
				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_BRANCH, 
						prodProductBranch.getProductId(), prodProductBranch.getProductBranchId(),
						this.getLoginUser().getUserName(), 
						"修改了产品规格："+prodProductBranch.getBranchName()+"。修改内容："+logContent, 
						COM_LOG_LOG_TYPE.PROD_PRODUCT_BRANCH_CHANGE.name(), 
						"修改产品规格",null);
			}} catch (Exception e) {
				// TODO Auto-generated catch block
				log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_BRANCH_CHANGE.name());
				log.error(e.getMessage());

			}
			
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

	/**
	 * 新增产品规格
	 */
	@RequestMapping(value = "/addProductBranch.do")
	@ResponseBody
	public Object addProductBranch(ProdProductBranch prodProductBranch) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<addProductBranch>");
		}
		
		Long productId = 0L;
		if(prodProductBranch!=null){
			prodProductBranch.setSaleFlag("N");			
			productId = prodProductBranch.getProductId();
			prodProductBranch.setCancelFlag("Y");
		}
		int id =prodProductBranchService.addProdProductBranch(prodProductBranch);
		//添加操作日志
		try {
			comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_BRANCH, 
					productId, (long) id, 
					this.getLoginUser().getUserName(), 
					"添加了产品编号为：【"+productId+"】的产品规格：【"+id+"】"+"规格名称：【"+prodProductBranch.getBranchName()+"】", 
					COM_LOG_LOG_TYPE.PROD_PRODUCT_BRANCH_CHANGE.name(), 
					"添加产品规格",null);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_BRANCH_CHANGE.name());
			log.error(e.getMessage());
		}
		
		return ResultMessage.ADD_SUCCESS_RESULT;
	}

	@RequestMapping(value = "/showProductBranchCheck")
	@ResponseBody
	public Object showSuppGoodsListCheck(HttpServletRequest req) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<showSuppGoodsListCheck>");
		}
		ResultMessage message = null;
		if (req.getParameter("productId") != null) {
			Map<String, Object> parameters = new HashMap<String, Object>();
			parameters.put("productId", req.getParameter("productId"));
			ProdProduct prodProduct = prodProductService.findProdProduct4FrontById(Long.valueOf(req.getParameter("productId")), Boolean.TRUE, Boolean.TRUE);
			new HashMap<String, Object>();
			// 商品维护前，产品基本信息check
			message = new ResultMessage("success", "success");
			if ((prodProduct == null) || (prodProduct.getProductId() == null)) {
				message = new ResultMessage("error", "该产品不存在，请先维护产品！");
			} else {
//取消产品不可用的检查				
//				if ("N".equals(prodProduct.getCancelFlag())) {
//					message = new ResultMessage("error", "该产品不可用，请先修改产品状态！");
//				}
			}
		}
		return message;
	}
	
	@RequestMapping(value = "/showProductBranchCheckForCustomizedProduct")
	@ResponseBody
	public Object showSuppGoodsListCheckForCustomizedProduct(HttpServletRequest req) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<showSuppGoodsListCheck>");
		}
		ResultMessage message = null;
		if (req.getParameter("productId") != null) {
			Long productId = Long.parseLong(req.getParameter("productId"));
			CustomizedProduct customizedProduct = MiscUtils.autoUnboxing(customizedProductService.findCustomizedProductByCustomizedProdId(productId));
			new HashMap<String, Object>();
			// 商品维护前，产品基本信息check
			message = new ResultMessage("success", "success");
			if ((customizedProduct == null) || (customizedProduct.getCustomizedProdId() == null)) {
				message = new ResultMessage("error", "该产品不存在，请先维护产品！");
			} else {
//取消产品不可用的检查				
//				if ("N".equals(prodProduct.getCancelFlag())) {
//					message = new ResultMessage("error", "该产品不可用，请先修改产品状态！");
//				}
			}
		}
		return message;
	}

	/**
	 * 设置是否有效
	 */
	@RequestMapping(value = "/editFlag.do")
	@ResponseBody
	public Object editFlag(Long productBranchId, String cancelFlag) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<editFlag>");
		}
		
		//查询相关联的 productBranchId
		List<Long> updateList = new ArrayList<Long>();
		updateList.add(productBranchId);
		if("N".equals(cancelFlag)){
			
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("hotelBranchId", productBranchId);
			List<ProdHotelcombBranch> listForProductBranchIds = iHotelcombBranchService.findProdHotelcombBranchByParams(params);
			
			for(ProdHotelcombBranch prodHotelcombBranch : listForProductBranchIds){
				updateList.add(prodHotelcombBranch.getHotelcombBranchId());			
			}
		}

		
		prodProductBranchService.editFlag(productBranchId, cancelFlag);
			
		// 去Super操作
//		petProdGoodsAdapter.updatePetProductBranchCancel(productBranchId);
		
		//添加操作日志，并增加对应关联branch id和的日志记录
		for(int i=0;i<updateList.size();i++){
			productBranchId = updateList.get(i);	
			ProdProductBranch prodProductBranch = prodProductBranchService.findProdProductBranchById(productBranchId, Boolean.FALSE, Boolean.FALSE);
			
			
			try {
				String key ="";
				if("Y".equals(cancelFlag))
				{
					key = "有效";
				}
				else
				{
					key = "无效";
				}
				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_BRANCH, 
						prodProductBranch.getProductId(), productBranchId, 
						this.getLoginUser().getUserName(), 
						"修改编号为：【"+productBranchId+"】的产品规格的状态为："+key, 
						COM_LOG_LOG_TYPE.PROD_PRODUCT_BRANCH_STATUS.name(), 
						"修改产品规格有效性",null);
				} catch (Exception e) {
						// TODO Auto-generated catch block
					log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_BRANCH_STATUS.name());
					log.error(e.getMessage());
				}
		}
		return ResultMessage.SET_SUCCESS_RESULT;
	}
	
	
	 private String getProductBranchChangeLog(ProdProductBranch oldProductBranch,ProdProductBranch newProductBranch){
		 StringBuffer logStr = new StringBuffer("");
		 if(null!= newProductBranch)
		 {
			 logStr.append(ComLogUtil.getLogTxt("规格名称",newProductBranch.getBranchName(),oldProductBranch.getBranchName()));
			 logStr.append(ComLogUtil.getLogTxt("出发车站",newProductBranch.getDepartureStation(),oldProductBranch.getDepartureStation()));
			 logStr.append(ComLogUtil.getLogTxt("到达车站",newProductBranch.getArrivalStation(),oldProductBranch.getArrivalStation()));
			 logStr.append(ComLogUtil.getLogTxt("是否有效","Y".equals(newProductBranch.getCancelFlag())?"是":"否","Y".equals(oldProductBranch.getCancelFlag())?"是":"否"));
			 logStr.append(ComLogUtil.getLogTxt("最大入住人数",newProductBranch.getMaxVisitor()+"",oldProductBranch.getMaxVisitor()+""));
			 logStr.append(ComLogUtil.getLogTxt("推荐级别",newProductBranch.getRecommendLevel()+"",oldProductBranch.getRecommendLevel()+""));

		     if(newProductBranch.getProductBranchPropList() != null && oldProductBranch.getProductBranchPropList() != null 
		    		 && !newProductBranch.getProductBranchPropList().equals(oldProductBranch.getProductBranchPropList())){
		 		Map<Long,ProdProductBranchProp> oldProductBranchPropMap = new HashMap<Long, ProdProductBranchProp>();
				Map<Long,ProdProductBranchProp> prodProductBranchPropMap = new HashMap<Long, ProdProductBranchProp>();
				Map<Long,Map<String,String>> resultMap = new HashMap<Long, Map<String,String>>();
				
				ComLogUtil.setProdProductBranchProp2Map(oldProductBranch.getProductBranchPropList(),oldProductBranchPropMap);
				ComLogUtil.setProdProductBranchProp2Map(newProductBranch.getProductBranchPropList(),prodProductBranchPropMap);
				ComLogUtil.diffProdProductBranchPropMap(oldProductBranchPropMap, prodProductBranchPropMap, resultMap);
				
				Map<Long,BizBranchProp> bizBranchPropMap = new HashMap<Long,BizBranchProp>();
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("branchId", newProductBranch.getBranchId());
				params.put("_orderby", "SEQ");
				params.put("productBranchId",newProductBranch.getProductBranchId());
				//查询该规格下面所有的产品规格（包括无效的）
				List<BizBranchProp> branchPropList = branchPropService.findBranchPropsByParams(params);
				if ((branchPropList != null) && (branchPropList.size() > 0)) {
					for (BizBranchProp bizBranchProp : branchPropList) {
						ComLogUtil.setBizBranchProp2Map(branchPropList, bizBranchPropMap);
				     }
					
				}
				
				//获取产品规格动态属性列表变更日志
				for (Map.Entry<Long,Map<String,String>> entry : resultMap.entrySet()) {
					if(PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_YESNO.name().equals(bizBranchPropMap.get(entry.getKey()).getInputType()))
					{
						String oldValue = ("Y".equals(resultMap.get(entry.getKey()).get("oldValue"))?"是":"否");
						String newValue = ("Y".equals(resultMap.get(entry.getKey()).get("newvalue"))?"是":"否");
						logStr.append(ComLogUtil.getLogTxt(bizBranchPropMap.get(entry.getKey()).getPropName(),newValue,oldValue));
					}
					else if(PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_RADIO.name().equals(bizBranchPropMap.get(entry.getKey()).getInputType())){
						String newValue = resultMap.get(entry.getKey()).get("newValue");
						String[] dictIdArray = newValue.split(",");
						String oldValue = resultMap.get(entry.getKey()).get("oldValue");
						String[] dictIdArray2 = oldValue.split(",");
						if(dictIdArray.length != 0)
						{
							newValue = prodProductService.getDictCnValue(dictIdArray);
						}else{
							newValue = "";
						}
						if(dictIdArray2.length != 0)
						{
							oldValue = prodProductService.getDictCnValue(dictIdArray2);
						}else{
							oldValue = "";
						}
						logStr.append(ComLogUtil.getLogTxt(bizBranchPropMap.get(entry.getKey()).getPropName(),newValue,oldValue));
					}else if(PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_SELECT.name().equals(bizBranchPropMap.get(entry.getKey()).getInputType())){
						String newValue = resultMap.get(entry.getKey()).get("newValue");
						String[] dictIdArray = newValue.split(",");
						String oldValue = resultMap.get(entry.getKey()).get("oldValue");
						String[] dictIdArray2 = oldValue.split(",");
						if(dictIdArray.length != 0)
						{
							newValue = prodProductService.getDictCnValue(dictIdArray);
						}else{
							newValue = "";
						}
						if(dictIdArray2.length != 0)
						{
							oldValue = prodProductService.getDictCnValue(dictIdArray2);
						}else{
							oldValue = "";
						}
						logStr.append(ComLogUtil.getLogTxt(bizBranchPropMap.get(entry.getKey()).getPropName(),newValue,oldValue));
					}else if(PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_TEXTAREA.name().equals(bizBranchPropMap.get(entry.getKey()).getInputType()) 
							|| PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_RICH.name().equals(bizBranchPropMap.get(entry.getKey()).getInputType())){
						String oldValue = resultMap.get(entry.getKey()).get("oldValue");
						String newValue = resultMap.get(entry.getKey()).get("newValue");
						if(null!=newValue && !newValue.equals(oldValue))
						{
							logStr.append(ComLogUtil.getLogTxt(bizBranchPropMap.get(entry.getKey()).getPropName(),newValue,null));
						}else{
							logStr.append(ComLogUtil.getLogTxt(bizBranchPropMap.get(entry.getKey()).getPropName(),newValue,oldValue));
						}
					}
					else
					{
						logStr.append(ComLogUtil.getLogTxt(bizBranchPropMap.get(entry.getKey()).getPropName(),resultMap.get(entry.getKey()).get("newValue"),resultMap.get(entry.getKey()).get("oldValue")));
					}
				}
		     }

		 }
		 return logStr.toString();
	 }

}
