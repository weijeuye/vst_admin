package com.lvmama.vst.back.prod.web.insurance;

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
import com.lvmama.vst.back.biz.po.BizDest;
import com.lvmama.vst.back.biz.po.BizDistrict;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.client.biz.service.CategoryClientService;
import com.lvmama.vst.back.client.biz.service.CategoryPropClientService;
import com.lvmama.vst.back.client.biz.service.DestClientService;
import com.lvmama.vst.back.client.biz.service.DestContentClientService;
import com.lvmama.vst.back.client.biz.service.DistrictClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsSaleReClientService;
import com.lvmama.vst.back.client.prod.service.ProdDestReClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductPropClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.prod.po.ProdDestRe;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductProp;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.pub.service.PushAdapterServiceRemote;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.vo.Constant.PROPERTY_INPUT_TYPE_ENUM;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.pet.goods.PetProdGoodsAdapter;

/**
 * 产品管理Action
 * 
 * @author yuzhizeng
 */
@Controller
@RequestMapping("/insurance/prod/product")
public class InsuranceProdProductAction extends BaseActionSupport {
	
	/**
	 * 序列
	 */
	private static final long serialVersionUID = 336573931429737081L;

	private static final Log LOG = LogFactory.getLog(InsuranceProdProductAction.class);

	@Autowired
	private ProdProductClientService prodProductService;

	@Autowired
	private ProdProductPropClientService prodProductPropService;

	@Autowired
	private CategoryClientService categoryService;
	
	@Autowired
	private ComLogClientService comLogService;
	
	@Autowired
	private DistrictClientService districtService;
	
	@Autowired
	private PetProdGoodsAdapter petProdGoodsAdapter;
	
	@Autowired
	private PushAdapterServiceRemote pushAdapterService;
	
	@Autowired
	private CategoryPropClientService categoryPropService;
	
	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;
	
	@Autowired
	private ProdDestReClientService prodDestReService;
	
	@Autowired
	private DestClientService destService;
	
	@Autowired
	private SuppGoodsSaleReClientService suppGoodsSaleReClientService;
	
	@Autowired
	private DestContentClientService destContentClientService;

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
			ProdProduct prodProduct = MiscUtils.autoUnboxing(
					prodProductService.findProdProductById(Long.valueOf(productId), Boolean.TRUE, Boolean.TRUE) );
			//vst组织鉴权
			super.vstOrgAuthentication(LOG, prodProduct.getManagerIdPerm());
			
			model.addAttribute("productName", prodProduct.getProductName());
			model.addAttribute("categoryId", prodProduct.getBizCategoryId());
			model.addAttribute("categoryName", prodProduct.getBizCategory().getCategoryName());
		} else {
			model.addAttribute("productName", null);
		}
		return "/prod/insurance/product/showProductMaintain";
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
	//	BizCategory bizCategory = null;
		List<BizCatePropGroup> bizCatePropGroupList = null;
		
		if (req.getParameter("productId") != null) {
			Map<String, Object> parameters = new HashMap<String, Object>();
			parameters.put("productId", req.getParameter("productId"));
			prodProduct = MiscUtils.autoUnboxing(
					prodProductService.findProdProductById(Long.valueOf(req.getParameter("productId")), Boolean.TRUE, Boolean.TRUE) );
			if (prodProduct != null) {
				bizCatePropGroupList = categoryService.findCategoryPropGroupsAndCategoryProp(prodProduct.getBizCategory().getCategoryId(), false);
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
		
		// 取得产品目的地关联
		Map<String, Object> paraProdDestRe = new HashMap<String, Object>();
		if(prodProduct != null){
		    paraProdDestRe.put("productId", prodProduct.getProductId());
		    List<ProdDestRe> prodDestReList = MiscUtils.autoUnboxing(destContentClientService.findProdDestReList(paraProdDestRe));
		    prodProduct.setProdDestReList(prodDestReList);
		}
		model.addAttribute("addValueTitle", ProdProductProp.PROP_ADD_VALUE_SPLIT);
		model.addAttribute("prodProduct", prodProduct);
		model.addAttribute("categoryName", prodProduct.getBizCategory().getCategoryName());
	//	model.addAttribute("bizCategory", bizCategory);
		model.addAttribute("bizCatePropGroupList", bizCatePropGroupList);
		return "/prod/insurance/product/showUpdateProduct";
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
			bizCatePropGroupList = categoryService.findCategoryPropGroupsAndCategoryProp(Long.valueOf(req.getParameter("categoryId")), true);
		}
		model.addAttribute("addValueTitle", ProdProductProp.PROP_ADD_VALUE_SPLIT);
		model.addAttribute("bizCategory", bizCategory);
		if(bizCategory != null){
		    model.addAttribute("categoryName", bizCategory.getCategoryName());
		}
		
		model.addAttribute("bizCatePropGroupList", bizCatePropGroupList);
		
		return "/prod/insurance/product/showAddProduct";
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
		
		List<ProdDestRe> newProdDestReList = new ArrayList<ProdDestRe>();
		for (ProdDestRe prodDestRe : prodProduct.getProdDestReList()) {
			if(prodDestRe.getDestId() !=null){
				newProdDestReList.add(prodDestRe);
			}
		}
		prodProduct.setProdDestReList(newProdDestReList);
		
		//获取原始对象
		ProdProduct oldProdProduct = prodProductService.findProdProductById(prodProduct.getProductId(), Boolean.TRUE, Boolean.TRUE);
		fillProductTypeWithInsurence(prodProduct);
		prodProductService.updateProdProductProp(prodProduct);
		StringBuilder newDestStr = new StringBuilder(",");
		List<ProdDestRe> insertProdDestReList= new ArrayList<ProdDestRe>(); 
		List<ProdDestRe> updateProdDestReList= new ArrayList<ProdDestRe>(); 
		
		// 取得原来产品目的地关联
		BizDest bizDest;
		for (ProdDestRe prodDestRe : prodProduct.getProdDestReList()) {
			if(prodDestRe.getReId()!=null){
				updateProdDestReList.add(prodDestRe);
			}else if(prodDestRe.getDestId()!=null){
				prodDestRe.setProductId(prodProduct.getProductId());
				insertProdDestReList.add(prodDestRe);
			}
			bizDest = MiscUtils.autoUnboxing( destService.selectDestById(prodDestRe.getDestId()) );
			newDestStr.append(bizDest.getDestName()).append(",");
		}
		
		// 取得原来产品目的地关联
		Map<String, Object> paraProdDestRe = new HashMap<String, Object>();
		paraProdDestRe.put("productId", prodProduct.getProductId());
		List<ProdDestRe> oldProdDestReList = MiscUtils.autoUnboxing(destContentClientService.findProdDestReList(paraProdDestRe));

		//修改产品目的地关联
		prodDestReService.addProdDestReList(insertProdDestReList);
		prodDestReService.saveOrUpdateProdDestReList(updateProdDestReList);
		StringBuilder oldDestStr = new StringBuilder(",");
		for (ProdDestRe oldProdDestRe : oldProdDestReList) {
			boolean flg = false;
			for (ProdDestRe updateProdDestRe : updateProdDestReList) {
				if(oldProdDestRe.getReId().longValue() == updateProdDestRe.getReId().longValue()){
					flg = true;
				}
			}
			if(!flg){
				prodDestReService.deleteProdDestReByPrimaryKey(oldProdDestRe.getReId());
			}
			bizDest = MiscUtils.autoUnboxing(destService.selectDestById(oldProdDestRe.getDestId()) );
			oldDestStr.append(bizDest.getDestName()).append(",");
		}
				
		//向分销推送产品状态
		try {
			pushAdapterService.push(prodProduct.getProductId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_DEST_RE,ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA); 
		} catch (Exception e) {
			LOG.error("Push info failure ！Push Type:"+ComPush.OBJECT_TYPE.PRODUCT.name()+" ID:"+prodProduct.getProductId());
		}
		try {
			//获取操作日志	
			String logContent = getProdProductChangeLog(oldProdProduct,prodProduct, oldDestStr.toString(),newDestStr.toString());
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
			fillProductTypeWithInsurence(prodProduct);
			prodProduct.setCancelFlag("Y");
			Long productId = MiscUtils.autoUnboxing(prodProductService.addProdProduct(prodProduct));
			//目的地新增
			if(prodProduct.getProdDestReList()!=null && prodProduct.getProdDestReList().size()>0
					&& prodProduct.getProdDestReList().get(0).getDestId() != null){
				
				for (ProdDestRe prodDestRe : prodProduct.getProdDestReList()) {
					prodDestRe.setProductId(productId);
				}
				prodDestReService.addProdDestReList(prodProduct.getProdDestReList());
			}
			Map<String, Object> attributes = new HashMap<String, Object>();
			attributes.put("productId", productId);
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

	private void fillProductTypeWithInsurence(ProdProduct prodProduct) {
		if(prodProduct != null && prodProduct.getProdProductPropList() != null) {
			for (ProdProductProp prop :prodProduct.getProdProductPropList()) {
				if(prop != null && new Long(650).equals(prop.getPropId()) &&prop.getPropValue() != null) {
					prodProduct.setProductType(ProdProduct.EX_INS_PRODUCTTYPE+prop.getPropValue());
				}
			}
		}
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

		prodProductService.updateCancelFlag(prodProduct.getProductId(), prodProduct.getCancelFlag());
		// 去Super操作
//		petProdGoodsAdapter.updatePetProductCancel(prodProduct.getProductId());
		//添加操作日志
		Long productId = prodProduct.getProductId();
		prodProduct = MiscUtils.autoUnboxing( prodProductService.getProdProductBy(productId));
		
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
			    	 BizDistrict bizDistrict = MiscUtils.autoUnboxing( districtService.findDistrictById(newProduct.getBizDistrict().getDistrictId()) );
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
				List<BizCatePropGroup> bizCatePropGroupList = categoryService.findCategoryPropGroupsAndCategoryProp(newProduct.getBizCategoryId(), false);
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
							newValue = MiscUtils.autoUnboxing( prodProductService.getDictCnValue(dictIdArray) );
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
							newValue = MiscUtils.autoUnboxing( prodProductService.getDictCnValue(dictIdArray) );
						}else{
							newValue = "";
						}
						if(dictIdArray2.length != 0)
						{
							oldValue = MiscUtils.autoUnboxing( prodProductService.getDictCnValue(dictIdArray2) );
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
