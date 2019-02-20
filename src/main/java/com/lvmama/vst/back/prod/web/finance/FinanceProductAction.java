package com.lvmama.vst.back.prod.web.finance;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.vst.back.biz.po.BizCatePropGroup;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.po.BizCategoryProp;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.biz.service.CategoryPropGroupService;
import com.lvmama.vst.back.client.biz.service.BizBuEnumClientService;
import com.lvmama.vst.back.client.biz.service.CategoryPropClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.pub.service.ComPhotoClientService;
import com.lvmama.vst.back.dist.po.Distributor;
import com.lvmama.vst.back.dist.service.DistributorCachedService;
import com.lvmama.vst.back.goods.vo.ProdProductParam;
import com.lvmama.vst.back.prod.po.FinanceProdRefundRule;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductProp;
import com.lvmama.vst.back.prod.po.ProdRefund;
import com.lvmama.vst.back.prod.service.ProdProductServiceAdapter;
import com.lvmama.vst.back.prod.vo.FinanceProdRefundRuleVo;
import com.lvmama.vst.back.client.prod.service.FinanceProdRefundRuleClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.pub.po.ComPhoto;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.Constants;
import com.lvmama.vst.comm.utils.DateUtil;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.MemcachedEnum;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;

@Controller
@RequestMapping("/finance/prod/product")
public class FinanceProductAction extends BaseActionSupport {
	
	private static final long serialVersionUID = 7573034578979789L;
	
	private static final Log LOG = LogFactory.getLog(FinanceProductAction.class);

	@Autowired
	private ProdProductClientService prodProductService;
	
	@Autowired
	private CategoryPropGroupService categoryPropGroupService;
	
	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;
	
	@Autowired
	private DistributorCachedService distributorService;
	
	@Autowired
	private BizBuEnumClientService bizBuEnumClientService;
	
	@Autowired
	private ProdProductServiceAdapter prodProductServiceAdapter;
	
	@Autowired
	private PermUserServiceAdapter permUserServiceAdapter;
	
	@Autowired
	private FinanceProdRefundRuleClientService financeProdRefundRuleClientService;
	
	@Autowired
	private ComLogClientService comLogService;
	
	@Autowired
	private CategoryPropClientService categoryPropService;
	
    @Autowired
	private SuppGoodsClientService suppGoodsService;
	@Autowired
	private ComPhotoClientService comPhotoClientRemote;
	/**
	 * 跳转到产品维护页面
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
			ProdProduct prodProduct = getProdProductByProductId(productId);
			//vst组织鉴权
			super.vstOrgAuthentication(LOG, prodProduct.getManagerIdPerm());
			
			model.addAttribute("productName", prodProduct.getProductName());
			model.addAttribute("categoryId", prodProduct.getBizCategoryId());
			model.addAttribute("categoryName", prodProduct.getBizCategory().getCategoryName());
			model.addAttribute("productBu", prodProduct.getBu());
		} else {
			model.addAttribute("productName", null);
		}
		return "/prod/finance/product/showProductMaintain";
	}
	
	/**
	 * 跳转到添加产品
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/showAddProduct")
	public String showAddProduct(Model model, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showAddProduct>");
		}
		model.addAttribute("userName", this.getLoginUser().getUserName());
		BizCategory bizCategory = null;
		List<BizCatePropGroup> bizCatePropGroupList = null;
		try{
			//产品属性
			if (req.getParameter("categoryId") != null) {
				bizCategory = bizCategoryQueryService.getCategoryById(Long.valueOf(req.getParameter("categoryId")));
				bizCatePropGroupList = categoryPropGroupService.findCategoryPropGroupsAndCategoryProp(Long.valueOf(req.getParameter("categoryId")), true);
			}
			if(bizCategory != null){
			    model.addAttribute("categoryName", bizCategory.getCategoryName());
			}
			model.addAttribute("bizCategory", bizCategory);
			model.addAttribute("categoryId", req.getParameter("categoryId"));
			model.addAttribute("bizCatePropGroupList", bizCatePropGroupList);
			//BU
			model.addAttribute("buList", bizBuEnumClientService.getAllBizBuEnumList().getReturnContent());
			//销售渠道
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("cancelFlag", "Y");
			List<Distributor> distributors = distributorService.findDistributorList(params).getReturnContent();
			model.addAttribute("distributorList", distributors);
		}catch(Exception  e){
			LOG.error("Error on "+this.getClass().getName(), e);
	        model.addAttribute("errorMsg", "系统内部异常");
		}
		return "/prod/finance/product/showAddProduct";
	}
	
	/**
	 * 新增产品
	 * 
	 * @return
	 */
	@RequestMapping(value = "/addProduct")
	@ResponseBody
	public Object addProduct(ProdProduct prodProduct, FinanceProdRefundRuleVo prodRefundRuleVo,
			HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) { 
			LOG.debug("start method<addProduct>");
		}
		
		if (prodProduct.getBizCategoryId()!=null) {
			prodProduct.setCancelFlag("N");
			//设置国内游玩人后置
			prodProduct.setTravellerDelayFlag("N");
			//保存产品和自动创建产品规格
			prodProduct.setAuditStatus(ProdProduct.AUDITTYPE.AUDITTYPE_TO_PM.name());
			
			prodProduct.setCreateUser(this.getLoginUserId());
			//保存基本信息、产品属性、规格
			long id = prodProductServiceAdapter.saveProdProduct(prodProduct);
			prodProduct.setProductId(id);
			//如果当前时间在有效期范围内，修改可售状态
			boolean isSale = isSale(prodProduct);
			if(isSale){
				prodProductService.updateProductSaleFlag(prodProduct.getProductId(), Constant.Y_FLAG, false);
			}
			//保存退改规则
			if(prodRefundRuleVo != null){
				String cancelStrategy = prodRefundRuleVo.getCancelStrategy();				
				//List<FinanceProdRefundRule> refundRuleList = prodRefundRuleVo.getProdRefundRuleList();
				List<FinanceProdRefundRule> refundRuleList = new ArrayList<FinanceProdRefundRule>();
				if(ProdRefund.CANCELSTRATEGYTYPE.MANUALCHANGE.getCode().equalsIgnoreCase(cancelStrategy)){
					FinanceProdRefundRule refundRule = new FinanceProdRefundRule();
					refundRule.setProductId(id);
					refundRule.setCancelStrategy(cancelStrategy);
					refundRule.setRuleContent(prodRefundRuleVo.getRuleContent());
					refundRuleList.add(refundRule);
				}
				/*else {
					if(cancelStrategy != null && CollectionUtils.isNotEmpty(refundRuleList)){
						for(FinanceProdRefundRule refundRule : refundRuleList){
							if(refundRule != null){
								refundRule.setCancelStrategy(cancelStrategy);
							}
						}
					}
				}*/
				financeProdRefundRuleClientService.saveProdRefundRule(refundRuleList);
			}
			
			// 清除缓存 
			//基本信息
			MemcachedUtil.getInstance().remove(MemcachedEnum.ProdProductSingle.getKey() + prodProduct.getProductId());
			//产品属性
			MemcachedUtil.getInstance().remove(MemcachedEnum.ProductWithPropList.getKey() + prodProduct.getProductId());
			
			Map<String, Object> attributes = new HashMap<String, Object>();
			attributes.put("productId", id);
			attributes.put("productName", prodProduct.getProductName());
			attributes.put("categoryName", prodProduct.getBizCategory().getCategoryName());
			//todo
			String logContent = "，产品Id：" + id;
			//添加操作日志
			try {
				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, 
						prodProduct.getProductId(), prodProduct.getProductId(), 
						this.getLoginUser().getUserName(), 
						"添加了产品：【"+prodProduct.getProductName()+"】"+logContent, 
						COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name(), 
						"添加产品",null);
			} catch (Exception e) {
				log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
				log.error(e.getMessage());
			}
			
			return new ResultMessage(attributes, "success", "保存成功");
		}
		return new ResultMessage("error", "保存失败,未选择品类");
	}
	
	/**
	 * 检查产品是否可售
	 * @param prodProduct
	 * @return
	 */
	private boolean isSale(ProdProduct prodProduct){
		boolean flag = false;
		//产品属性
		List<ProdProductProp> propList =prodProduct.getProdProductPropList();
	    if(CollectionUtils.isNotEmpty(propList)){
	    	//获取销售有效期
	    	ProdProductProp saleStartDateProp = propList.get(2);
	    	ProdProductProp saleEndDateProp = propList.get(3);
	    	String start = null;
	    	String end = null;
	    	if(saleStartDateProp != null){
	    		start = saleStartDateProp.getPropValue();
	    	}
	    	if(saleEndDateProp != null){
	    		end = saleEndDateProp.getPropValue();
	    	}
	    	Date startDate = null;
	    	Date endDate = null;
	    	Date nowDate = new Date();
	    	if(StringUtils.isNotEmpty(start)){
	    		startDate = DateUtil.parse(start, DateUtil.HHMMSS_DATE_FORMAT);
	    		if(startDate != null && nowDate.getTime() >= startDate.getTime()){
	    			if(StringUtils.isNotEmpty(end)){
	    				String  endStr = (String)end;
	    				endDate = DateUtil.parse(endStr, DateUtil.HHMMSS_DATE_FORMAT);
	    				boolean betweenDate = DateUtil.isBetweenDate(nowDate, startDate, endDate);
	    				if(betweenDate){
	    					flag = true;
	    				}
	    			}else{
	    				flag = true;
	    			}
	    		}
	    	}else{
    			if(StringUtils.isNotEmpty(end)){
    				endDate = DateUtil.parse(end, DateUtil.HHMMSS_DATE_FORMAT);
    				if(endDate != null && nowDate.getTime() <= endDate.getTime()){
    					flag = true;
    				}
    			}else{
    				flag = true;
    			}
	    	}
	    }
		return flag;
	}
	
	/**
	 * 跳转到修改页面
	 * @return
	 */
	@RequestMapping(value = "/showUpdateProduct")
	public String showUpdateProduct(Model model, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showUpdateProduct>");
		}
		model.addAttribute("userName", this.getLoginUser().getUserName());
		if (req.getParameter("productId") != null) {
			Long productId = Long.valueOf(req.getParameter("productId"));
			ProdProduct prodProduct = getProdProductByProductId(productId);			
			if(prodProduct != null){
				if(prodProduct.getManagerId() != null){
					PermUser permUser = permUserServiceAdapter.getPermUserByUserId(prodProduct.getManagerId());
					if(permUser != null) {
						prodProduct.setManagerName(permUser.getRealName());
					}
				}
				model.addAttribute("prodProduct", prodProduct);
				//所属品类
				model.addAttribute("bizCategory", bizCategoryQueryService.getCategoryById(prodProduct.getBizCategoryId()));
				List<BizCatePropGroup> bizCatePropGroupList = 
						categoryPropGroupService.findCategoryPropGroupsAndCategoryProp(prodProduct.getBizCategoryId(), false);
				model.addAttribute("bizCatePropGroupList", bizCatePropGroupList);
			}
			//BU
			model.addAttribute("buList", bizBuEnumClientService.getAllBizBuEnumList().getReturnContent());
			//产品属性值
			Map<String, Object> propMap = prodProduct.getPropValue();
			model.addAttribute("propMap", propMap);
			//产品属性
			Map<String, ProdProductProp> prodPropMap = new HashMap<String, ProdProductProp>();
			List<ProdProductProp> prodPropList = prodProduct.getProdProductPropList();
			if(CollectionUtils.isNotEmpty(prodPropList)){
				for(ProdProductProp prodProp : prodPropList){
					if(prodProp == null){
						continue;
					}
					prodPropMap.put(String.valueOf(prodProp.getPropId()), prodProp);
				}
			}
			model.addAttribute("prodPropMap", prodPropMap);
				
			//退改规则
			List<FinanceProdRefundRule> refundRuleList = 
					MiscUtils.autoUnboxing(financeProdRefundRuleClientService.findProdRefundRuleList(productId));
			if(CollectionUtils.isNotEmpty(refundRuleList)){
				FinanceProdRefundRule firstRefundRule = refundRuleList.get(0);
				if(firstRefundRule != null){
					String cancelStrategy = firstRefundRule.getCancelStrategy();
					model.addAttribute("cancelStrategy", cancelStrategy);
					model.addAttribute("ruleId", firstRefundRule.getRuleId());
					if(ProdRefund.CANCELSTRATEGYTYPE.MANUALCHANGE.getCode().equalsIgnoreCase(cancelStrategy)){
						model.addAttribute("ruleContent", firstRefundRule.getRuleContent());
					}
				}
			}
		}
		return "/prod/finance/product/showUpdateProduct";
	}
	
	/**
	 * 修改产品
	 * 
	 * @return
	 */
	@RequestMapping(value = "/updateProduct")
	@ResponseBody
	public Object updateProduct(ProdProduct prodProduct, FinanceProdRefundRuleVo prodRefundRuleVo,
			HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) { 
			LOG.debug("start method<updateProduct>");
		}
		ProdProduct oldProduct = getProdProductByProductId(prodProduct.getProductId());
		List<FinanceProdRefundRule> oldRefundRuleList = MiscUtils.autoUnboxing(
				financeProdRefundRuleClientService.findProdRefundRuleList(prodProduct.getProductId()));
		//检查当前时间是否在有效期范围内
		boolean isSale = isSale(prodProduct);
		if(isSale){
			prodProduct.setSaleFlag(Constant.Y_FLAG);
		} else {
			prodProduct.setSaleFlag(Constant.N_FLAG);
		}
		
		List<FinanceProdRefundRule> refundRuleList = new ArrayList<FinanceProdRefundRule>();
		if (prodProduct.getBizCategoryId()!=null) {
			//修改产品基本信息、产品属性
			prodProductService.updateProdProductProp(prodProduct);
			//保存退改规则
			if(prodRefundRuleVo != null){
				String cancelStrategy = prodRefundRuleVo.getCancelStrategy();				
				//List<FinanceProdRefundRule> refundRuleList = prodRefundRuleVo.getProdRefundRuleList();				
				if(ProdRefund.CANCELSTRATEGYTYPE.MANUALCHANGE.getCode().equalsIgnoreCase(cancelStrategy)){
					FinanceProdRefundRule refundRule = new FinanceProdRefundRule();
					refundRule.setRuleId(prodRefundRuleVo.getRuleId());
					refundRule.setProductId(prodProduct.getProductId());
					refundRule.setCancelStrategy(cancelStrategy);
					refundRule.setRuleContent(prodRefundRuleVo.getRuleContent());
					refundRuleList.add(refundRule);
				}
				/*else {
					if(cancelStrategy != null && CollectionUtils.isNotEmpty(refundRuleList)){
						for(FinanceProdRefundRule refundRule : refundRuleList){
							if(refundRule != null){
								refundRule.setCancelStrategy(cancelStrategy);
							}
						}
					}
				}*/
				financeProdRefundRuleClientService.saveProdRefundRule(refundRuleList);
			}
			
			// 清除缓存 
			//基本信息
			MemcachedUtil.getInstance().remove(MemcachedEnum.ProdProductSingle.getKey() + prodProduct.getProductId());
			//产品属性
			MemcachedUtil.getInstance().remove(MemcachedEnum.ProductWithPropList.getKey() + prodProduct.getProductId());
			
			Map<String, Object> attributes = new HashMap<String, Object>();
			attributes.put("productId", prodProduct.getProductId());
			attributes.put("productName", prodProduct.getProductName());
			attributes.put("categoryName", prodProduct.getBizCategory().getCategoryName());
			//添加操作日志
			try {
				String logProduct = getProdProductLog(prodProduct, oldProduct);
				String logRefund = getProdRefundLog(refundRuleList, oldRefundRuleList);
				String logContent = "，产品Id:"+oldProduct.getProductId()+ logProduct + logRefund;
				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, 
						prodProduct.getProductId(), prodProduct.getProductId(), 
						this.getLoginUser().getUserName(), 
						"修改产品：【"+prodProduct.getProductName()+"】"+logContent, 
						COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name(), 
						"修改产品",null);
			} catch (Exception e) {
				log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
				log.error(e.getMessage());
			}
			
			return new ResultMessage(attributes, "success", "保存成功");
		}
		return new ResultMessage("error", "保存失败,未选择品类");
	}
	
	/**
	 * 获取原来产品对象
	 * @param prodProductId
	 * @param reqId
	 * @return
	 */
	private ProdProduct getProdProductByProductId(Long prodProductId) {
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("productId", prodProductId);
		ProdProductParam param = new ProdProductParam();
		param.setBizCategory(true);
		param.setProductProp(true);
		param.setProductPropValue(true);
		ProdProduct prodProduct = MiscUtils.autoUnboxing(prodProductService.findProdProductById(prodProductId, param));
		return prodProduct;
	}
	
	/**
	 * 产生修改产品日志内容
	 * @param prodProduct 现有产品
	 * @param oldProduct 原有产品
	 * @return 日志内容
	 */
	private String getProdProductLog(ProdProduct prodProduct,ProdProduct oldProduct) {
        if(prodProduct == null){
            return StringUtils.EMPTY;
        }
        
        StringBuilder sb = new StringBuilder();
        sb.append(getChangeLog("产品名称", oldProduct.getProductName(), prodProduct.getProductName()));        
        sb.append(getChangeLog("推荐级别", String.valueOf(oldProduct.getRecommendLevel()), String.valueOf(prodProduct.getRecommendLevel())));
        //BU
        if(prodProduct.getBu() != null){
			String newValue = bizBuEnumClientService.getBizBuEnumByBuCode(prodProduct.getBu()).getReturnContent().getCnName();
			String oldValue = bizBuEnumClientService.getBizBuEnumByBuCode(oldProduct.getBu()).getReturnContent().getCnName();
        	sb.append(getChangeLog("BU", oldValue, newValue));
        }
        //内容维护人员
        if(prodProduct.getManagerId() != null && oldProduct.getManagerId() != null &&
        		prodProduct.getManagerId().longValue() != oldProduct.getManagerId()){
        	String oldManagerName = null;
	        PermUser permUser = permUserServiceAdapter.getPermUserByUserId(oldProduct.getManagerId());
			if(permUser != null) {
				oldManagerName = permUser.getRealName();
			}
	        sb.append(getChangeLog("内容维护人员", oldManagerName, prodProduct.getManagerName()));
        }
        //产品属性
        sb.append(getProdProductPropLog(prodProduct,oldProduct));
        return sb.toString();
	}
	
	/**
	 * 获取退改规则的日志修改记录
	 * @param refundRuleList 新的退改规则
	 * @param oldRefundRuleList 老的退改规则
	 * @return
	 */
	private String getProdRefundLog(List<FinanceProdRefundRule> refundRuleList,
			List<FinanceProdRefundRule> oldRefundRuleList) {
		if(CollectionUtils.isEmpty(refundRuleList) && CollectionUtils.isEmpty(oldRefundRuleList)){
			return "";
		}
		StringBuilder sb = new StringBuilder();
		StringBuilder refundContent = new StringBuilder();
		StringBuilder oldRefundContent = new StringBuilder();
		String cancelStrategy = refundRuleList.get(0).getCancelStrategy();
		String oldCancelStrategy = oldRefundRuleList.get(0).getCancelStrategy();
		//检查退改类型是否修改
		if(!StringUtils.equalsIgnoreCase(cancelStrategy, oldCancelStrategy)){
			String refundType = getRefundType(cancelStrategy);
			refundContent.append("退改类型：").append(refundType).append(",");
			String oldRefundType = getRefundType(oldCancelStrategy);
			oldRefundContent.append("退改类型：").append(oldRefundType).append(",");
		}
		refundContent.append(getRefundContent(refundRuleList));
		oldRefundContent.append(getRefundContent(oldRefundRuleList));
		
		sb.append(getChangeLog("退改说明", oldRefundContent.toString(), refundContent.toString()));
		return sb.toString();
	}
	
	/**
	 *  获取退改类型中文名
	 * @param cancelStrategy
	 * @return
	 */
	private String getRefundType(String cancelStrategy){
		String refundType = "";
		if(ProdRefund.CANCELSTRATEGYTYPE.MANUALCHANGE.getCode().equalsIgnoreCase(cancelStrategy)){
			refundType = ProdRefund.CANCELSTRATEGYTYPE.MANUALCHANGE.getCnName();
		} else if(ProdRefund.CANCELSTRATEGYTYPE.RETREATANDCHANGE.getCode().equalsIgnoreCase(cancelStrategy)){
			refundType = ProdRefund.CANCELSTRATEGYTYPE.RETREATANDCHANGE.getCnName();
		}
		return refundType;
	}
	
	/**
	 * 获取退改内容
	 * @param refundRuleList
	 * @return
	 */
	private String getRefundContent(List<FinanceProdRefundRule> refundRuleList){
		StringBuilder sb = new StringBuilder();
		sb.append("退改内容：");
		for(FinanceProdRefundRule refundRule : refundRuleList){
			if(refundRule == null){
				continue;
			}
			String cancelStrategy = refundRule.getCancelStrategy();
			if(ProdRefund.CANCELSTRATEGYTYPE.MANUALCHANGE.getCode().equalsIgnoreCase(cancelStrategy)){
				if(refundRule.getRuleContent() != null){
					sb.append(refundRule.getRuleContent());
				}
				break;
			} else if(ProdRefund.CANCELSTRATEGYTYPE.RETREATANDCHANGE.getCode().equalsIgnoreCase(cancelStrategy)) {
				String returnFlag;
				if("LESSEQ".equalsIgnoreCase(refundRule.getRuleType())){
					sb.append("小于等于").append(refundRule.getStartDays()).append("日,");
					returnFlag = Constants.Y_FLAG.equals(refundRule.getReturnFlag())?"是":"否";
					sb.append(",退还权益金标识:").append(returnFlag);
				} else if("GREATEREQ".equalsIgnoreCase(refundRule.getRuleType())){
					sb.append("大于等于").append(refundRule.getStartDays()).append("日,");
					returnFlag = Constants.Y_FLAG.equals(refundRule.getReturnFlag())?"是":"否";
					sb.append(",退还权益金标识:").append(returnFlag);
				} else if("BETWEEN".equalsIgnoreCase(refundRule.getRuleType())){
					sb.append("介于").append(refundRule.getStartDays());
					sb.append("和").append(refundRule.getEndDays()).append("日,");;
					returnFlag = Constants.Y_FLAG.equals(refundRule.getReturnFlag())?"是":"否";
					sb.append(",退还权益金标识:").append(returnFlag);
				}
				sb.append(";");
			}
		}
		return sb.toString();
	}
	
	/**
	 * 获取产品某个字段的修改日志
	 * @param columnName
	 * @param oldStr
	 * @param newStr
	 * @return
	 */
	private String getChangeLog(String columnName,String oldStr,String newStr){
		String temp = "";
		if(oldStr ==null && newStr == null){
			return temp;
		}else if(oldStr ==null ||newStr ==null ){
			temp =  ComLogUtil.getLogTxt(columnName,newStr,oldStr);
			return temp;
		}else{
			if( !oldStr.equals(newStr)){
				temp = ComLogUtil.getLogTxt(columnName,newStr,oldStr);
				return temp;
			}
		}
		return "";		
	}
	
	/**
	 * 获取产品属性的修改日志
	 * @param prodProduct
	 * @param oldProdProduct
	 * @return
	 */
	private String getProdProductPropLog(ProdProduct prodProduct, ProdProduct oldProdProduct) {
        StringBuilder ret = new StringBuilder();
        if (prodProduct == null) {
            return StringUtils.EMPTY;
        }
        Map<Long, ProdProductProp> oldPropPropIdMap = new HashMap<Long, ProdProductProp>();
        for (ProdProductProp props : oldProdProduct.getProdProductPropList()) {
        	oldPropPropIdMap.put(props.getProdPropId(), props);
        }

        for (ProdProductProp prop : prodProduct.getProdProductPropList()) {
        	BizCategoryProp bizCategoryProp = categoryPropService.findCategoryPropById(prop.getPropId());
        	if(bizCategoryProp == null){
        		continue;
        	}
        	//新属性存在和原来的属性都存在
            if (oldPropPropIdMap.containsKey(prop.getProdPropId())) {
            	ProdProductProp oldProp = oldPropPropIdMap.get(prop.getProdPropId());
            	ret.append(getChangeLog(bizCategoryProp.getPropName(), oldProp.getPropValue(),
                        prop.getPropValue()));
            } else {  //新属性存在,原来的属性不存在
            	ret.append(getChangeLog(bizCategoryProp.getPropName(), null, prop.getPropValue()));
            }
        }
        return ret.toString();
    }

	/**
	 * 复制产品
	 * 
	 * @return
	 */
	@RequestMapping(value = "/copyProduct")
	@ResponseBody
	public Object copyProduct(Model model, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<copyProduct>");
		}
		
		if (req.getParameter("productId") != null) {
			Long oldProductId  = Long.valueOf(req.getParameter("productId"));
			ProdProductParam param = new ProdProductParam();
			param.setBizCategory(true);
			param.setBizDistrict(true);
			param.setProductProp(true);
			param.setProductPropValue(true);
			//原来的产品
			ProdProduct prodProduct =MiscUtils.autoUnboxing(prodProductService.findProdProductById(oldProductId,param));

			//1.产品的基本信息
			prodProduct.setProductId(null);
			prodProduct.setCreateUser(this.getLoginUserId());
	        prodProduct.setSource("BACK");
			prodProduct.setUrlId(null);
			prodProduct.setCancelFlag("N");
			//判断产品是否在销售有效期
			Boolean isSaleFlag = prodProductService.findProdSaleFlagByProductId(oldProductId);
			if(null != isSaleFlag && isSaleFlag){
				prodProduct.setSaleFlag("Y");
			}else{
				prodProduct.setSaleFlag("N");
			}
	        prodProduct.setEbkSupplierGroupId(null);
	        long newProductId = 0l;
	        try{
		        //保存产品基本信息 以及属性和规格
				newProductId = prodProductServiceAdapter.saveProdProduct(prodProduct);
				prodProduct.setProductId(newProductId);
			} catch (Exception e) {
				LOG.error("复制产品基本信息失败,productId:" + oldProductId + " error: " + ExceptionFormatUtil.getTrace(e));
				return new ResultMessage("error", "产品基本信息复制失败");
			}

			//添加操作日志
			try {
				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, 
						newProductId, newProductId, 
						this.getLoginUser().getUserName(), 
						"复制产品：【"+newProductId+"】,原产品ID:【"+oldProductId+"】", 
						COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name(), 
						"复制产品",null);
			} catch (Exception e) {
				log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
				log.error(e.getMessage());
			}

	        ResultMessage message;
	        String msg = "";
			//2.复制退改规则
			ResultHandleT<List<FinanceProdRefundRule>> refundRuleResult = financeProdRefundRuleClientService.findProdRefundRuleList(oldProductId);
			try{
				if(null != refundRuleResult && null != refundRuleResult.getReturnContent()){
					List<FinanceProdRefundRule> refundRuleList = refundRuleResult.getReturnContent();
					for(FinanceProdRefundRule rule : refundRuleList){
						rule.setProductId(newProductId);
						rule.setRuleId(null);
					}
					financeProdRefundRuleClientService.saveProdRefundRule(refundRuleList);
				}
			} catch (Exception e) {
				LOG.error("复制退改规则失败,productId:" + newProductId + " error: " + ExceptionFormatUtil.getTrace(e));
				msg += "复制产品退改规则失败,新产品id:"+newProductId+"##";
			}
			
			//3.复制产品图片
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("objectId", oldProductId);
			params.put("objectType", "PRODUCT_ID");
			params.put("_orderby", "photo_seq");
			params.put("_order", "asc");
			ResultHandleT<List<ComPhoto>> imageListResult = comPhotoClientRemote.findImageList(params);
			try{
				if(null != imageListResult && null != imageListResult.getReturnContent()){
					List<ComPhoto> photoList = imageListResult.getReturnContent();
					if(photoList!=null && photoList.size()>0){
						for (ComPhoto comPhoto : photoList) {
							comPhoto.setObjectId(prodProduct.getProductId());
							comPhoto.setPhotoId(null);
							comPhotoClientRemote.insert(comPhoto);
						}
					}
				}
			} catch (Exception e) {
				LOG.error("复制产品图片失败,productId:" + newProductId + " error: " + ExceptionFormatUtil.getTrace(e));
				msg += "复制产品图片失败,新产品id:"+newProductId+"##";
			}
			//3.复制关联数据
	        message = prodProductServiceAdapter.copyFinanceProdReData(prodProduct,oldProductId);
			
			if("".equals(msg) && "success".equalsIgnoreCase(message.getCode())){
				return new ResultMessage("success", "复制成功");
			}else{
				msg = msg +"####商品复制:"+ message.getMessage();
				return new ResultMessage("success", "复制成功,部分数据复制失败,可手动设置,详情："+msg);
			}
		}
		return new ResultMessage("error", "复制失败");
	}
}
