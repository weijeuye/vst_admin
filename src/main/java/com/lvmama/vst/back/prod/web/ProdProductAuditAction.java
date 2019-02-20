package com.lvmama.vst.back.prod.web;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.lvmama.comm.pet.po.email.EmailContent;
import com.lvmama.vst.back.biz.po.Attribution;
import com.lvmama.vst.back.pub.po.ComLog;
import com.lvmama.vst.back.supp.po.SuppSettlementEntities;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.enumeration.CommEnumSet;
import com.lvmama.vst.pet.adapter.VstEmailServiceAdapter;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.po.BizEnum;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.client.biz.service.AttributionClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductBranchClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.supp.service.SuppSettlementEntityClientService;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductBranch;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.comm.utils.DateUtil;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.WineSplitConstants;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 产品审核管理
 * @author luolihua
 * @date 2015-05-04
 */
@Controller
@RequestMapping("/prod/product")
public class ProdProductAuditAction extends BaseActionSupport {
	
	private static final long serialVersionUID = -6351446724576585206L;

	private static final Log LOG = LogFactory.getLog(ProdProductAuditAction.class);

	@Autowired
	private ProdProductClientService prodProductService;

	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;
	
	@Autowired 
	private ProdProductBranchClientService prodProductBranchService;
	
	@Autowired
	private SuppGoodsClientService suppGoodsService;

	@Autowired
	private SuppSettlementEntityClientService suppSettlementEntitiesService;
	
	@Autowired
	private ComLogClientService comLogService;
	
	@Autowired
	private SensitiveSupport sensitiveSupport;

	@Autowired
	private VstEmailServiceAdapter vstEmailService;

	@Autowired
	private AttributionClientService attributionService;

	private final static String CONFIRM_SETTLE_ENTITY_RESULT = "result_settleEntity";
	private final static String CONFIRM_SETTLE_ENTITY_MSG = "msg_settleEntity";

	/**
	 * 获得审核产品列表
	 * @param model
	 * @param page 分页参数
	 * @param prodProduct 查询条件
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/findProductAuditList")
	public String findProductAuditList(Model model, Integer page, ProdProduct prodProduct, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<findProductAuditList>");
		}
		//查询品类
		List<BizCategory> bizCategoryList = bizCategoryQueryService.getAllValidCategorys();
		//去掉29  交通+X 这个品类
		Iterator <BizCategory> categoryit = bizCategoryList.iterator();  
		while(categoryit.hasNext())  
		{
			BizCategory next = categoryit.next();
			if(BizEnum.BIZ_CATEGORY_TYPE.category_route_aero_hotel.getCategoryId().equals(next.getCategoryId())
					||BizEnum.JINGLE_CATEGORY_TYPE.isJingLe(next.getCategoryId()))
		    {  
		    	categoryit.remove();  
		    }  
		} 
		
		model.addAttribute("bizCategoryList", bizCategoryList);
		model.addAttribute("auditTypeList", ProdProduct.AUDITTYPE.values());
		
		//查询自由行子品类
		List<BizCategory> subCategoryList = bizCategoryQueryService.getBizCategorysByParentCategoryId(WineSplitConstants.ROUTE_FREEDOM);
//		BizCategory freedom = bizCategoryQueryService.getCategoryById(WineSplitConstants.ROUTE_FREEDOM);
//		subCategoryList.add(freedom);
		model.addAttribute("subCategoryList", subCategoryList);
		
		if(prodProduct == null || prodProduct.getProductName() == null) {
			return "/prod/product/findProductAuditList";
		}
		Map<String, Object> paramProdProduct = new HashMap<String, Object>();
		paramProdProduct.put("productName", prodProduct.getProductName());
		paramProdProduct.put("productId", prodProduct.getProductId());
		paramProdProduct.put("cancelFlag", prodProduct.getCancelFlag());
		paramProdProduct.put("saleFlag", prodProduct.getSaleFlag());
		paramProdProduct.put("auditStatus", prodProduct.getAuditStatus());
		paramProdProduct.put("subCategoryId", prodProduct.getSubCategoryId());
		paramProdProduct.put("abandonFlag", "N");//废弃的产品在审核页面搜索不到
		if (prodProduct.getBizCategory() != null) {
			paramProdProduct.put("bizCategoryId", prodProduct.getBizCategory().getCategoryId());
		}
		if (prodProduct.getBizDistrict() != null) {
			paramProdProduct.put("bizDistrictId", prodProduct.getBizDistrict().getDistrictId());
			paramProdProduct.put("districtName", prodProduct.getBizDistrict().getDistrictName());
		}

		List<Long> jingleIdList = new ArrayList<Long>();
		for (BizEnum.JINGLE_CATEGORY_TYPE jingle_category_type : BizEnum.JINGLE_CATEGORY_TYPE.values()) {
			jingleIdList.add(jingle_category_type.getCategoryId().longValue());
		}
		paramProdProduct.put("excludeBizCategoryIdLst", jingleIdList);

		int count = MiscUtils.autoUnboxing( prodProductService.findProdProductCount(paramProdProduct) );

		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		paramProdProduct.put("_start", pageParam.getStartRows());
		paramProdProduct.put("_end", pageParam.getEndRows());
		paramProdProduct.put("_orderby", "PRODUCT_ID");
		paramProdProduct.put("_order", "DESC");
		paramProdProduct.put("isneedmanager", "false");

		List<ProdProduct> list = prodProductService.findProdProductListSales(paramProdProduct);
		//判断是否有敏感词
		if(list != null && list.size() > 0){
			ResultMessage rm = null;
			for(ProdProduct pp : list){
				rm = sensitiveSupport.findSensitiveFlag(pp.getProductId());
				if(!"success".equalsIgnoreCase(rm.getCode())){
					pp.setSenisitiveFlag("Y");
				}
			}
		}
		pageParam.setItems(list);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("prodProduct", prodProduct);
		model.addAttribute("bizCategory", prodProduct.getBizCategory());
		return "/prod/product/findProductAuditList";
	}
	
	/**
	 * 更新审核状态
	 * @param model
	 * @param currentType
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/updateAudtiType")
	public Object updateAudtiType(Model model, ProdProduct product, String isPass, String content, String isSubmit) {
		if (product == null || product.getCurrentAuditStatus() == null || isPass == null) {
			return new ResultMessage("error", "状态无效");
		}

		// 获得下一个状态
		ProdProduct.AUDITTYPE audiType = null;
		if ("EBK".equalsIgnoreCase(product.getSource()) 
				&& Constant.SON_CATEGORY_ID.ROUTE.getCode().indexOf(product.getBizCategoryId().toString()) != -1) {
			ProdProduct prodProuduct = MiscUtils.autoUnboxing( prodProductService.findProdProductById(product.getProductId()) );
			if (prodProuduct != null) {
				Map<String, Object> returnMap = new HashMap<String, Object>();
				String productType=prodProuduct.getProductType();
				String producTourtType=prodProuduct.getProducTourtType();
				//国内跟团游，不含一日游产品
				if(prodProuduct.getBizCategoryId()!=null && productType!=null&&producTourtType!=null){
					if("AUDITTYPE_TO_PM".equals(prodProuduct.getAuditStatus())){
						if("Y".equalsIgnoreCase(isPass ) && (15==prodProuduct.getBizCategoryId() || 16==prodProuduct.getBizCategoryId()) &&("INNERSHORTLINE".equals(productType) || "INNERLONGLINE".equals(productType) ||
								"INNER_BORDER_LINE".equals(productType) || "INNERLINE".equals(productType))){
							String operationCategory=prodProuduct.getOperationCategory();
							if(operationCategory==null||operationCategory==""){
								returnMap.put("settingOperFlag", true);
								return returnMap;
							}
						}
					}
				}

				SuppGoods baseGood = suppGoodsService.findBaseSuppGoodsByProductId(prodProuduct.getProductId());
				if (baseGood != null) {
					if (null == baseGood.getBu() || null == baseGood.getAttributionId()) {
						returnMap.put("settingFlag", true);
						return returnMap;
					}
				} else {
					returnMap.put("settingFlag", true);
					return returnMap;
				}

				// 判断EBK 推送过来的产品 所含商品是否 含有结算对象
				// 仅 产品经理审核 且 审核通过时 判断
				if(ProdProduct.AUDITTYPE.AUDITTYPE_TO_PM.name().equalsIgnoreCase(product.getCurrentAuditStatus()) && "Y".equals(isPass)){
					returnMap = confirmSuppGoodsHasSettlementForLine(prodProuduct,returnMap);
					if(returnMap.get(CONFIRM_SETTLE_ENTITY_RESULT).equals("failed")){
						return returnMap;
					}
				}
			}
		}
		audiType = getNextAuditType(product,isPass);

		product.setAuditStatus(audiType.name());
		product.setUpdateTime(DateUtil.getDateByStr(
				DateUtil.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss"), "yyyy-MM-dd HH:mm:ss"));
		int rs = prodProductService.updateAuditByPrimaryKey(product);
		if(ProdProduct.AUDITTYPE.AUDITTYPE_TO_QA.equals(audiType)){
			sendDestinationEmail(product);
		}
		// 如果是审核通过，则产品设置为有效
		if (audiType.name().equalsIgnoreCase(ProdProduct.AUDITTYPE.AUDITTYPE_PASS.name())) {
			//金融品类产品设为有效时需要先验证有效期
			if(product.getBizCategoryId() == 33L){
				Boolean isValidity = prodProductService.findProdIsCancelFlagByProductId(product.getProductId());
				if(null != isValidity && isValidity){
					//产品在有效期中  设置产品为有效
					product.setCancelFlag("Y");
				}else{
					//设置产品为无效
					product.setCancelFlag("N");
				}
			}else if(product.getBizCategoryId() == 15L){
				//途牛跟团对接，供应商id 23975,审核完，产品有效设为N
				product.setCancelFlag("Y");
				
			}else{
				product.setCancelFlag("Y");
			}
			prodProductService.updateCancelFlag(product.getProductId(), product.getCancelFlag());
		}
		if (rs == 1) {
			// 审核结果
			String res = "";
			if (!"Y".equalsIgnoreCase(isSubmit)) {
				if (product.getCurrentAuditStatus().equalsIgnoreCase(
						ProdProduct.AUDITTYPE.AUDITTYPE_TO_PM.name())
						|| product.getCurrentAuditStatus().equalsIgnoreCase(
								ProdProduct.AUDITTYPE.AUDITTYPE_BACK_PM.name())
						|| product.getCurrentAuditStatus().equalsIgnoreCase(
								ProdProduct.AUDITTYPE.AUDITTYPE_TO_QA.name())
						|| product.getCurrentAuditStatus().equalsIgnoreCase(
								ProdProduct.AUDITTYPE.AUDITTYPE_BACK_QA.name())
						|| product.getCurrentAuditStatus().equalsIgnoreCase(
								ProdProduct.AUDITTYPE.AUDITTYPE_TO_BUSINESS
										.name())
						|| product.getCurrentAuditStatus().equalsIgnoreCase(
								ProdProduct.AUDITTYPE.AUDITTYPE_BACK_BUSINESS
										.name())) {
					if (content != null && !"".equalsIgnoreCase(content)) {
						res = "审核备注:" + content + "</br>";
					}
					if ("Y".equalsIgnoreCase(isPass)) {
						res = res + "审核结果:审核通过";
					} else {
						res = res + "审核结果:审核不通过";
					}
				} else {
					res = "提交审核";
				}
			} else {
				res = "提交审核";
			}

			String oper = "";
			if (!"Y".equalsIgnoreCase(isSubmit)) {
				if (product.getCurrentAuditStatus().equalsIgnoreCase(
						ProdProduct.AUDITTYPE.AUDITTYPE_TO_PM.name())
						|| product.getCurrentAuditStatus().equalsIgnoreCase(
								ProdProduct.AUDITTYPE.AUDITTYPE_BACK_PM.name())) {
					oper = "操作人:产品经理"+ this.getLoginUser().getUserName();
				} else if (product.getCurrentAuditStatus().equalsIgnoreCase(
						ProdProduct.AUDITTYPE.AUDITTYPE_TO_QA.name())
						|| product.getCurrentAuditStatus().equalsIgnoreCase(
								ProdProduct.AUDITTYPE.AUDITTYPE_BACK_QA.name())) {
					oper = "操作人:QA审核"+ this.getLoginUser().getUserName();
				} else if (product.getCurrentAuditStatus().equalsIgnoreCase(
						ProdProduct.AUDITTYPE.AUDITTYPE_TO_BUSINESS.name())
						|| product.getCurrentAuditStatus().equalsIgnoreCase(
								ProdProduct.AUDITTYPE.AUDITTYPE_BACK_BUSINESS.name())) {
					oper = "操作人:商务审核"+ this.getLoginUser().getUserName();
				} else {
					oper = "操作人:" + this.getLoginUser().getUserName();
				}
			} else {
				oper = "操作人:" + this.getLoginUser().getUserName();
			}

			// 记录日志
			comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, product.getProductId(), 
					product.getProductId(), oper, res, COM_LOG_LOG_TYPE.PROD_PRODUCT_ADUIT_STATUS.name(), "", null);

			return new ResultMessage("success", "操作成功");
		} else
			return new ResultMessage("error", "操作失败");
	}

	private ProdProduct.AUDITTYPE getNextAuditType(ProdProduct product,String isPass){
		ProdProduct.AUDITTYPE auditType = ProdProduct.AUDITTYPE.getNextAuditType(ProdProduct.AUDITTYPE.valueOf(product.getCurrentAuditStatus()), isPass, "N", product.getSource());
		return auditType;
	}

	/**
	 * 判断EBK 推送过来的产品 所含商品是否 含有结算对象，仅限 产品经理审核时才做校验
	 */
	private Map<String, Object> confirmSuppGoodsHasSettlementForLine(ProdProduct prodProuduct,Map<String, Object> map){
		Long productId= prodProuduct.getProductId();
		List<SuppGoods> suppGoodsList = MiscUtils.autoUnboxing( suppGoodsService.findSuppGoodsByProductId(productId) );
		if(CollectionUtils.isEmpty(suppGoodsList)){
			map.put(CONFIRM_SETTLE_ENTITY_RESULT,"failed");
			map.put(CONFIRM_SETTLE_ENTITY_MSG,"产品下无商品,请添加商品!");
			return map;
		}

		// 编译产品下面所有商品
		for(SuppGoods suppGoods:suppGoodsList){
			String code = suppGoods.getSettlementEntityCode();
			String buyoutCode = suppGoods.getBuyoutSettlementEntityCode();
			if(StringUtils.isEmpty(code) && StringUtils.isEmpty(buyoutCode)){
				map.put(CONFIRM_SETTLE_ENTITY_RESULT,"failed");
				map.put(CONFIRM_SETTLE_ENTITY_MSG,"产品下有商品(ID:"+suppGoods.getSuppGoodsId()+",名称："+suppGoods.getGoodsName()+")未绑定结算信息，请到商品页面设置结算对象后再继续操作");
				return map;
			}
		}

		map.put(CONFIRM_SETTLE_ENTITY_RESULT,"success");
		return map;
	}

	/**
	 * 目的地bu的酒店套餐和自由行，提交审核时会向产品运营发送邮件
	 * @param product
	 */
	private void sendDestinationEmail(ProdProduct product){
		ProdProduct prodProduct = MiscUtils.autoUnboxing( prodProductService.findProdProductById(product.getProductId()) );
		if(prodProduct == null){
			return;
		}
		if(prodProduct.getBizCategoryId() == null){
			return;
		}
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("objectId",prodProduct.getProductId());
		params.put("logType", ComLog.COM_LOG_LOG_TYPE.PROD_PRODUCT_ADUIT_STATUS.getCode());
		params.put("objectType", COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT.getCode());
		Integer count = MiscUtils.autoUnboxing( comLogService.getTotalCount(params) );
		if(count != null && count > 0){
			return;
		}
		String attributionName = "";
		if(prodProduct.getAttributionId() != null){
			Attribution attribution = attributionService.findAttributionById(prodProduct.getAttributionId());
			if(null != attribution){
				attributionName ="{"+attribution.getAttributionName()+"}";
			}else{
				attributionName ="{区域不明}";
			}
		}else{
			attributionName ="{区域不明}";
		}
		String content = "请点击以下链接查看";
		if(prodProduct.getBizCategoryId().equals(BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCategoryId())){
			if(BizEnum.BIZ_CATEGORY_TYPE.category_route_scene_hotel.getCategoryId().equals(prodProduct.getSubCategoryId()) && "DESTINATION_BU".equals(prodProduct.getBu())){
				content = content +"http://super.lvmama.com/vst_admin/selfTour/prod/product/showProductMaintain.do?categoryId=18&productId="+prodProduct.getProductId()+"&isView=Y";
			}else{
				return;
			}
		}else if(prodProduct.getBizCategoryId().equals(BizEnum.BIZ_CATEGORY_TYPE.category_route_hotelcomb.getCategoryId())){
			SuppGoods baseGood = suppGoodsService.findBaseSuppGoodsByProductId(prodProduct.getProductId());
			if(baseGood != null && "DESTINATION_BU".equals(baseGood.getBu())){
				content = content +"http://super.lvmama.com/vst_admin/hotelPackage/prod/product/showProductMaintain.do?categoryId=17&productId="+prodProduct.getProductId()+"&isView=Y";
				Attribution attribution = attributionService.findAttributionById(baseGood.getAttributionId());
				if(null != attribution){
					attributionName ="{"+attribution.getAttributionName()+"}";
				}
			}else{
				return;
			}

		}else{
			return ;
		}

		EmailContent emailContent = new EmailContent();
		emailContent.setFromAddress("service@cs.lvmama.com");
		emailContent.setFromName("驴妈妈旅游网");
		emailContent.setSubject("审核产品通知，"+attributionName+"，产品ID：{"+prodProduct.getProductId()+"}，产品名：{"+prodProduct.getProductName()+"}");
		emailContent.setToAddress("mddcpsh@lvmama.com");
		emailContent.setContentText(content);
		try {
			log.info("产品审核发送邮件");
			log.info("FromAddress:"+emailContent.getFromAddress());
			log.info("FromName:"+emailContent.getFromName());
			log.info("Subject:"+emailContent.getSubject());
			log.info("ToAddress:"+emailContent.getToAddress());
			log.info("ContentText:"+emailContent.getContentText());
			vstEmailService.sendEmail(emailContent);
		} catch (Exception e) {
			LOG.error(ExceptionFormatUtil.getTrace(e));
//			throw new BusinessException("邮件发送失败"+e);
		}
	}

	/**
	 * 撤回审核
	 * @param model
	 * @param currentType
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/cancelAudtiType")
	public Object cancelAudtiType(Model model,ProdProduct product){
		if(product!=null){
			product.setUpdateTime(DateUtil.getDateByStr(DateUtil.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss"), "yyyy-MM-dd HH:mm:ss"));
			product.setAuditStatus(ProdProduct.AUDITTYPE.getNextAuditType(ProdProduct.AUDITTYPE.valueOf(product.getCurrentAuditStatus()),"N","Y",product.getSource()).name()); 
		}
		int rs = prodProductService.updateAuditByPrimaryKey(product);
		if(rs == 1){
			//记录日志
			comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, 
					product.getProductId(), product.getProductId(), 
					"操作人:"+this.getLoginUser().getUserName(), 
					"撤销审核", 
					COM_LOG_LOG_TYPE.PROD_PRODUCT_ADUIT_STATUS.name(), 
					"",null);
			return new ResultMessage("success", "操作成功");
		}
		return new ResultMessage("error", "操作失败");
	}
	
	/**
	 * 查询产品的状态
	 * @param model
	 * @param productId
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/findProductStatus")
	public String cancelAudtiType(Model model,Long productId){
		
		ProdProduct prodProduct = MiscUtils.autoUnboxing( prodProductService.findProdProductById(productId) );
		
		String cancelFlag = prodProduct.getCancelFlag();
		
		return cancelFlag!=null?cancelFlag:"";
	}
}
