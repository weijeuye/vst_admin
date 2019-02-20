package com.lvmama.vst.back.prod.web.other;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizCatePropGroup;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.po.BizCategoryProp;
import com.lvmama.vst.back.biz.po.BizDistrict;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.biz.service.CategoryPropGroupService;
import com.lvmama.vst.back.client.biz.service.DistrictClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductPropClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductProp;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.Constant.PROPERTY_INPUT_TYPE_ENUM;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 产品管理Action
 * 
 */
@Controller
@RequestMapping("/other/prod/product")
public class OtherProdProductAction extends BaseActionSupport {

	/**
	 * 序列
	 */
	private static final long serialVersionUID = -4484273058094646963L;
 
	private static final Log LOG = LogFactory.getLog(OtherProdProductAction.class);

	@Autowired
	private ProdProductClientService prodProductService;
	

	@Autowired
	private ProdProductPropClientService prodProductPropService;
	

	@Autowired
	private CategoryPropGroupService categoryPropGroupService;
	
	@Autowired
	private ComLogClientService comLogService;
	
	
	@Autowired
	private DistrictClientService districtService;
	
	
	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;

	/**
	 * 跳转到产品维护页面
	 * 
	 * @param model
	 * @param productId
	 * @return
	 */
	@RequestMapping(value = "/showProductMaintain")
	public String showProductMaintain(Model model, Long productId, String categoryName,Long categoryId,String isView) throws BusinessException {
		model.addAttribute("categoryId", categoryId);
		model.addAttribute("categoryName", categoryName);
		model.addAttribute("productId", productId);
		model.addAttribute("isView", isView);
		if (productId != null) {
			ProdProduct prodProduct = prodProductService.findProdProduct4FrontById(Long.valueOf(productId), Boolean.TRUE, Boolean.TRUE);
			//vst组织鉴权
			super.vstOrgAuthentication(LOG, prodProduct.getManagerIdPerm());
			
			model.addAttribute("productName", prodProduct.getProductName());
			model.addAttribute("categoryId", prodProduct.getBizCategoryId());
			model.addAttribute("categoryName", prodProduct.getBizCategory().getCategoryName());
		} else {
			model.addAttribute("productName", null);
		}
		return "/prod/other/product/showProductMaintain";
	}

	/**
	 * 跳转到修改页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/showUpdateProduct")
	public String showUpdateProduct(Model model, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showUpdateProduct>");
		}
		ProdProduct prodProduct = null;
		List<BizCatePropGroup> bizCatePropGroupList = null;
		
		if (req.getParameter("productId") != null) {
			Map<String, Object> parameters = new HashMap<String, Object>();
			parameters.put("productId", req.getParameter("productId"));
			prodProduct = prodProductService.findProdProduct4FrontById(Long.valueOf(req.getParameter("productId")), Boolean.TRUE, Boolean.TRUE);
			if (prodProduct != null) {
				bizCatePropGroupList = categoryPropGroupService.findCategoryPropGroupsAndCategoryProp(prodProduct.getBizCategory().getCategoryId(), false);
				if ((bizCatePropGroupList != null) && (bizCatePropGroupList.size() > 0)) {
					for (BizCatePropGroup bizCatePropGroup : bizCatePropGroupList) {
						if ((bizCatePropGroup.getBizCategoryPropList() != null) && (bizCatePropGroup.getBizCategoryPropList().size() > 0)) {
							for (BizCategoryProp bizCategoryProp : bizCatePropGroup.getBizCategoryPropList()) {
								Map<String, Object> parameters2 = new HashMap<String, Object>();
								Long propId = bizCategoryProp.getPropId();
								parameters2.put("productId", req.getParameter("productId"));
								parameters2.put("propId", propId);
								
								
								List<ProdProductProp> prodProductPropList = MiscUtils.autoUnboxing(prodProductPropService.findProdProductPropList(parameters2));
								bizCategoryProp.setProdProductPropList(prodProductPropList);
							}
						}
					}
				}
			}

		}
		// 类别
		List<ProdProduct.PRODUCTTYPE> productTypeList = new ArrayList<ProdProduct.PRODUCTTYPE>();
		// 快递
		productTypeList.add(ProdProduct.PRODUCTTYPE.EXPRESS);
		//押金
		productTypeList.add(ProdProduct.PRODUCTTYPE.DEPOSIT);
		model.addAttribute("productTypeList", productTypeList);
		model.addAttribute("addValueTitle", ProdProductProp.PROP_ADD_VALUE_SPLIT);
		model.addAttribute("prodProduct", prodProduct);
		if(prodProduct != null && prodProduct.getBizCategory() != null){
		    model.addAttribute("categoryName", prodProduct.getBizCategory().getCategoryName());
		}
	//	model.addAttribute("bizCategory", bizCategory);
		model.addAttribute("bizCatePropGroupList", bizCatePropGroupList);
		return "/prod/other/product/showUpdateProduct";
	}

	/**
	 * 跳转到添加产品
	 * 
	 * @return
	 */
	@RequestMapping(value = "/showAddProduct")
	public String showAddProduct(Model model, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showAddProduct>");
		}
		BizCategory bizCategory = null;
		List<BizCatePropGroup> bizCatePropGroupList = null;
		if (req.getParameter("categoryId") != null) {
			bizCategory = bizCategoryQueryService.getCategoryById(Long.valueOf(req.getParameter("categoryId")));
			bizCatePropGroupList = categoryPropGroupService.findCategoryPropGroupsAndCategoryProp(Long.valueOf(req.getParameter("categoryId")), true);
		}
		// 类别
		List<ProdProduct.PRODUCTTYPE> productTypeList = new ArrayList<ProdProduct.PRODUCTTYPE>();
		// 快递
		productTypeList.add(ProdProduct.PRODUCTTYPE.EXPRESS);
		//押金
                productTypeList.add(ProdProduct.PRODUCTTYPE.DEPOSIT);
		model.addAttribute("productTypeList", productTypeList);
		model.addAttribute("addValueTitle", ProdProductProp.PROP_ADD_VALUE_SPLIT);
		model.addAttribute("bizCategory", bizCategory);
		if(bizCategory != null){
		    model.addAttribute("categoryName", bizCategory.getCategoryName());
		}
		model.addAttribute("bizCatePropGroupList", bizCatePropGroupList);
		
		return "/prod/other/product/showAddProduct";
	}

	/**
	 * 更新产品
	 * @return
	 */
	@RequestMapping(value = "/updateProduct")
	@ResponseBody
	public Object updateProduct(ProdProduct prodProduct) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<updateProduct>");
		}
		if ((prodProduct.getBizCategoryId() == null)) {
			throw new BusinessException("产品数据错误：无品类");
		}
		ResultMessage message = null;
		
		//获取原始对象
		ProdProduct oldProdProduct = prodProductService.findProdProduct4FrontById(prodProduct.getProductId(), Boolean.TRUE, Boolean.TRUE);
		prodProductService.updateProdProductProp(prodProduct);
				
		try {
			//获取操作日志	
			String logContent = getProdProductChangeLog(oldProdProduct,prodProduct, "","");
			//添加操作日志
			if(null!=logContent && !"".equals(logContent)) {
				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, 
						prodProduct.getProductId(), prodProduct.getProductId(), 
						this.getLoginUser().getUserName(), 
						"修改了产品：【"+prodProduct.getProductName()+"】，修改内容："+logContent, 
						COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name(), 
						"修改产品",null);
			}
		} catch (Exception e) {
			log.error("Record Log failure ！Log Type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
			log.error(e.getMessage());
		}

		// 清除前台缓存
		MemcachedUtil.getInstance().remove(Constant.MEM_CACH_KEY.VST_TICKET_PRODUCT_.toString() + prodProduct.getProductId() + "true");
		MemcachedUtil.getInstance().remove(Constant.MEM_CACH_KEY.VST_TICKET_PRODUCT_.toString() + prodProduct.getProductId() + "false");

		message = new ResultMessage("success", "保存成功");
		return message;
	}

	/**
	 * 新增产品
	 * 
	 * @return
	 */
	@RequestMapping(value = "/addProduct")
	@ResponseBody
	public Object addProduct(ProdProduct prodProduct) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<addProduct>");
		}
		if (prodProduct.getBizCategoryId()!=null) {
			prodProduct.setCreateUser(this.getLoginUserId());
			prodProduct.setCancelFlag("Y");
			long id = MiscUtils.autoUnboxing(prodProductService.addProdProduct(prodProduct));
			Map<String, Object> attributes = new HashMap<String, Object>();
			attributes.put("productId", id);
			attributes.put("productName", prodProduct.getProductName());
			attributes.put("categoryName", prodProduct.getBizCategory().getCategoryName());
			//添加操作日志
			try {
				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, 
						prodProduct.getProductId(), prodProduct.getProductId(), 
						this.getLoginUser().getUserName(), 
						"添加了产品：【"+prodProduct.getProductName()+"】", 
						COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name(), 
						"添加产品",null);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
				log.error(e.getMessage());
			}
			
			return new ResultMessage(attributes, "success", "保存成功");
		}
		return new ResultMessage("error", "保存失败,未选择品类");
	}

	/**
	 * 设置产品的有效性
	 * @return
	 */
	@RequestMapping(value = "/cancelProduct")
	@ResponseBody
	public Object cancelProduct(ProdProduct prodProduct) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<cancelProduct>");
		}
		
		if ((prodProduct != null) && "Y".equals(prodProduct.getCancelFlag())) {
			prodProduct.setCancelFlag("Y");
		} else if ((prodProduct != null) && "N".equals(prodProduct.getCancelFlag())) {
			prodProduct.setCancelFlag("N");
		} else {
			return new ResultMessage("error", "设置失败,无效参数");
		}

		prodProductService.updateCancelFlag(prodProduct);
		//添加操作日志
		Long productId = prodProduct.getProductId();
		prodProduct = MiscUtils.autoUnboxing(prodProductService.getProdProductBy(productId));
		
		try {
			String key ="";
			if("Y".equals(prodProduct.getCancelFlag()))
			{
				key = "有效";
			}
			else
			{
				key = "无效";
			}
			comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, 
					prodProduct.getProductId(), prodProduct.getProductId(), 
					this.getLoginUser().getUserName(), 
					"修改了产品：【"+prodProduct.getProductName()+"】的有效性为："+key, 
					COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_STATUS.name(), 
					"设置产品的有效性",null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_STATUS.name());
			log.error(e.getMessage());
		}
		
		return ResultMessage.SET_SUCCESS_RESULT;
	}
	
	 private String getProdProductChangeLog(ProdProduct oldProduct,ProdProduct newProduct, String oldDestStr, String newDestStr){
		 StringBuffer logStr = new StringBuffer("");
		 if(null!= newProduct)
		 {
			 logStr.append(ComLogUtil.getLogTxt("产品名称",newProduct.getProductName(),oldProduct.getProductName()));
			 logStr.append(ComLogUtil.getLogTxt("是否有效","Y".equals(newProduct.getCancelFlag())?"是":"否","Y".equals(oldProduct.getCancelFlag())?"是":"否"));
			 logStr.append(ComLogUtil.getLogTxt("推荐级别",newProduct.getRecommendLevel().toString(),oldProduct.getRecommendLevel().toString()));
			 if(!oldDestStr.equalsIgnoreCase(newDestStr)){
				 logStr.append(ComLogUtil.getLogTxt("目的地", newDestStr, oldDestStr));
			 }
		     if(null!=newProduct.getBizDistrict())
		     {
		    	 if(!newProduct.getBizDistrict().getDistrictId().equals(oldProduct.getBizDistrict().getDistrictId()))
		    	 {
			    	 BizDistrict bizDistrict = MiscUtils.autoUnboxing(districtService.findDistrictById(newProduct.getBizDistrict().getDistrictId()));
			         logStr.append(ComLogUtil.getLogTxt("行政区划", bizDistrict.getDistrictName(), null));
		    	 }
		     }
		     if(!newProduct.getProdProductPropList().equals(oldProduct.getProdProductPropList())){
		 		Map<Long,ProdProductProp> oldProductProdMap = new HashMap<Long, ProdProductProp>();
				Map<Long,ProdProductProp> productProdMap = new HashMap<Long, ProdProductProp>();
				Map<Long,Map<String,String>> resultMap = new HashMap<Long, Map<String,String>>();
				
				ComLogUtil.setProductProp2Map(oldProduct.getProdProductPropList(),oldProductProdMap);
				ComLogUtil.setProductProp2Map(newProduct.getProdProductPropList(),productProdMap);
				ComLogUtil.diffProductPropMap(oldProductProdMap, productProdMap, resultMap);
				
				Map<Long,BizCategoryProp> bizCategoryMap = new HashMap<Long,BizCategoryProp>();
				List<BizCatePropGroup> bizCatePropGroupList = categoryPropGroupService.findCategoryPropGroupsAndCategoryProp(newProduct.getBizCategoryId(), false);
				if ((bizCatePropGroupList != null) && (bizCatePropGroupList.size() > 0)) {
					for (BizCatePropGroup bizCatePropGroup : bizCatePropGroupList) {
						ComLogUtil.setbizCategory2Map(bizCatePropGroup.getBizCategoryPropList(), bizCategoryMap);
				     }
				}
				
				//获取产品动态属性列表变更日志
				for (Map.Entry<Long,Map<String,String>> entry : resultMap.entrySet()) {
					if(PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_YESNO.name().equals(bizCategoryMap.get(entry.getKey()).getInputType()))
					{
						String oldValue = ("Y".equals(resultMap.get(entry.getKey()).get("oldValue"))?"是":"否");
						String newValue = ("Y".equals(resultMap.get(entry.getKey()).get("newvalue"))?"是":"否");
						logStr.append(ComLogUtil.getLogTxt(bizCategoryMap.get(entry.getKey()).getPropName(),newValue,oldValue));
					}
					else if(PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_CHECKBOX.name().equals(bizCategoryMap.get(entry.getKey()).getInputType())){
						String newValue = resultMap.get(entry.getKey()).get("newValue");
						String[] dictIdArray = newValue.split(",");
						if(dictIdArray.length != 0)
						{
							newValue = MiscUtils.autoUnboxing(prodProductService.getDictCnValue(dictIdArray));
						}else{
							newValue = "";
						}
						logStr.append(ComLogUtil.getLogTxt(bizCategoryMap.get(entry.getKey()).getPropName(),newValue,null));
					}else if(PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_SELECT.name().equals(bizCategoryMap.get(entry.getKey()).getInputType())){
						String newValue = resultMap.get(entry.getKey()).get("newValue");
						String[] dictIdArray = newValue.split(",");
						String oldValue = resultMap.get(entry.getKey()).get("oldValue");
						String[] dictIdArray2 = oldValue.split(",");
						if(dictIdArray.length != 0)
						{
							newValue = MiscUtils.autoUnboxing(prodProductService.getDictCnValue(dictIdArray));
						}else{
							newValue = "";
						}
						if(dictIdArray2.length != 0)
						{
							oldValue = MiscUtils.autoUnboxing(prodProductService.getDictCnValue(dictIdArray2));
						}else{
							oldValue = "";
						}
						logStr.append(ComLogUtil.getLogTxt(bizCategoryMap.get(entry.getKey()).getPropName(),newValue,oldValue));
					}else if(PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_TEXTAREA.name().equals(bizCategoryMap.get(entry.getKey()).getInputType()) 
							|| PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_RICH.name().equals(bizCategoryMap.get(entry.getKey()).getInputType())){
						String oldValue = resultMap.get(entry.getKey()).get("oldValue");
						String newValue = resultMap.get(entry.getKey()).get("newValue");
						if(null!=newValue && !newValue.equals(oldValue))
						{
							logStr.append(ComLogUtil.getLogTxt(bizCategoryMap.get(entry.getKey()).getPropName(),newValue,null));
						}else{
							logStr.append(ComLogUtil.getLogTxt(bizCategoryMap.get(entry.getKey()).getPropName(),newValue,oldValue));
						}
					}
					else
					{
						logStr.append(ComLogUtil.getLogTxt(bizCategoryMap.get(entry.getKey()).getPropName(),resultMap.get(entry.getKey()).get("newValue"),resultMap.get(entry.getKey()).get("oldValue")));
					}
				}
		     }

		 }
		 return logStr.toString();
	 }
	  
}
