package com.lvmama.vst.back.prod.web.superMember;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Collections;
import javax.servlet.http.HttpServletRequest;
import com.lvmama.crm.outer.user.api.CrmPayMemberService;
import com.lvmama.crm.outer.user.bo.paymember.PayLabelForProductBO;
import com.lvmama.price.api.comm.vo.PriceResultHandleT;
import com.lvmama.price.api.strategy.model.vo.SuperMemberGoodsTimePriceVo;
import com.lvmama.price.api.strategy.service.SuperMemberGoodsTimePriceApiService;
import com.lvmama.vst.back.client.prod.service.ProdProductPropClientService;
import com.lvmama.vst.back.prod.po.*;
import com.lvmama.vst.back.prod.service.ProdRefundService;
import com.lvmama.vst.back.prod.service.SuperMemberPriceSetService;
import com.lvmama.vst.back.prod.service.SuperMemberSalePromotionService;
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
import com.lvmama.vst.back.client.biz.service.CategoryPropClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductBranchClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.goods.vo.ProdProductParam;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductProp;
import com.lvmama.vst.back.prod.service.ProdProductServiceAdapter;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.DateUtil;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.MemcachedEnum;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;

@Controller
@RequestMapping("/supermember/prod/product")
public class SuperMemberProductAction extends BaseActionSupport {

    private static final long serialVersionUID = 8568567978967945L;

    private static final Log LOG = LogFactory.getLog(SuperMemberProductAction.class);

	@Autowired
	private ProdProductClientService prodProductService;

	@Autowired
	private ProdProductBranchClientService prodProductBranchService;

	@Autowired
	private CategoryPropGroupService categoryPropGroupService;

	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;

	@Autowired
	private ProdProductServiceAdapter prodProductServiceAdapter;

	@Autowired
	private PermUserServiceAdapter permUserServiceAdapter;

	@Autowired
	private ComLogClientService comLogService;

	@Autowired
	private CategoryPropClientService categoryPropService;

	@Autowired
    private SuppGoodsClientService suppGoodsService;

	@Autowired
    private ProdProductPropClientService prodProductPropClientService;

	@Autowired
    private ProdRefundService prodRefundService;
    @Autowired
    private SuperMemberPriceSetService superMemberPriceSetService;

    @Autowired
    private SuperMemberSalePromotionService superMemberSalePromotionService;

    @Autowired
    private SuperMemberGoodsTimePriceApiService superMemberGoodsTimePriceApiService;

    @Autowired
    private CrmPayMemberService crmPayMemberService;

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
		return "/prod/superMember/product/showProductMaintain";
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
		}catch(Exception  e){
			LOG.error("Error on "+this.getClass().getName(), e);
	        model.addAttribute("errorMsg", "系统内部异常");
		}
		return "/prod/superMember/product/showAddProduct";
	}

	/**
	 * 新增产品
	 *
	 * @return
	 */
	@RequestMapping(value = "/addProduct")
	@ResponseBody
	public Object addProduct(ProdProduct prodProduct, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<addProduct>");
		}

		if (prodProduct.getBizCategoryId()!=null) {
			prodProduct.setCancelFlag("N");
			//设置国内游玩人后置
			prodProduct.setTravellerDelayFlag("N");
			//保存产品和自动创建产品规格
			prodProduct.setAuditStatus(ProdProduct.AUDITTYPE.AUDITTYPE_PASS.name());

			prodProduct.setCreateUser(this.getLoginUserId());
			//保存基本信息、产品属性、规格
			long id = prodProductServiceAdapter.saveProdProduct(prodProduct);
			prodProduct.setProductId(id);
			Long suppGoodsId = createSuppGoods(prodProduct);
			// 清除缓存
			//基本信息
			MemcachedUtil.getInstance().remove(MemcachedEnum.ProdProductSingle.getKey() + prodProduct.getProductId());
			//产品属性
			MemcachedUtil.getInstance().remove(MemcachedEnum.ProductWithPropList.getKey() + prodProduct.getProductId());

			Map<String, Object> attributes = new HashMap<String, Object>();
			attributes.put("productId", id);
			attributes.put("productName", prodProduct.getProductName());
			attributes.put("categoryName", prodProduct.getBizCategory().getCategoryName());
			attributes.put("suppGoodsId", suppGoodsId);

			//添加操作日志
			try {
				String logContent = "，产品Id：" + id;
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
	 * 在超级会员产品下，创建一个默认的商品
	 * @param prodProduct
	 * @return suppGoodsId
	 */
	private Long createSuppGoods(ProdProduct prodProduct) throws BusinessException{
		Long userId = getLoginUser().getUserId();
		List<ProdProductBranch> branchList = null;
		try {
			branchList = MiscUtils.autoUnboxing(prodProductBranchService.findProdProductBranchByProductId(prodProduct.getProductId()));
		} catch (Exception e) {
			LOG.error("findProdProductBranchByProductId error.", e);
			throw new BusinessException("查询规格信息失败");
		}
		if(CollectionUtils.isEmpty(branchList)){
			throw new BusinessException("无规格信息");
		}
		Long productBranchId = branchList.get(0).getProductBranchId();
		SuppGoods suppGoods = new SuppGoods();
		suppGoods.setBranchId(188L);
		suppGoods.setProductId(prodProduct.getProductId());
		suppGoods.setProductBranchId(productBranchId);
		suppGoods.setSupplierId(Constant.SUPER_MEMBER_SUPPLIER_ID);
		suppGoods.setContractId(Constant.SUPER_MEMBER_CONTRACT_ID);
        //默认设置为有效
        suppGoods.setCancelFlag(Constant.Y_FLAG);
		suppGoods.setPayTarget(SuppGoods.PAYTARGET.PREPAID.name());
		suppGoods.setMinQuantity(1L);
		suppGoods.setMaxQuantity(10L);
		suppGoods.setCurrencyType("RMB");
		suppGoods.setManagerId(userId);
		suppGoods.setContentManagerId(userId);
		suppGoods.setCreateUser(this.getLoginUserId());
		suppGoods.setPriceType(SuppGoods.PRICETYPE.SINGLE_PRICE.name());
        Long suppGoodsId = MiscUtils.autoUnboxing(suppGoodsService.addSuppGoods(suppGoods));
        //默认创建商品时是不可售，修改为可售
        suppGoods.setSuppGoodsId(suppGoodsId);
        suppGoods.setOnlineFlag(Constant.Y_FLAG);
        suppGoodsService.updateOnlineFlag(suppGoods, false);
		return suppGoodsId;
	}

	private Map<String, String> getSaleDateMap(List<ProdProductProp> propList){
        Map<String, String> resultMap = new HashMap<>();
	    if(CollectionUtils.isEmpty(propList)){
	        return resultMap;
        }
        for (ProdProductProp prop : propList) {
            if (prop.getPropId().equals(1356L)) {
                resultMap.put("sale_start_date", prop.getPropValue());
            } else if (prop.getPropId().equals(1357L)) {
                resultMap.put("sale_end_date", prop.getPropValue());
            }
        }
        return resultMap;
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
            Map<String, String> resultMap = getSaleDateMap(propList);
	    	String start = resultMap.get("sale_start_date");
	    	String end = resultMap.get("sale_end_date");
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
				//获取商品Id
				SuppGoods suppGoods = suppGoodsService.findBaseSuppGoodsByProductId(productId);
				if(suppGoods != null){
					model.addAttribute("suppGoodsId", suppGoods.getSuppGoodsId());
				}
			}
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
		}
		return "/prod/superMember/product/showUpdateProduct";
	}

	/**
	 * 修改产品
	 *
	 * @return
	 */
	@RequestMapping(value = "/updateProduct")
	@ResponseBody
	public Object updateProduct(ProdProduct prodProduct, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<updateProduct>");
		}
		ProdProduct oldProduct = getProdProductByProductId(prodProduct.getProductId());
		if (prodProduct.getBizCategoryId()!=null) {
			//修改产品基本信息、产品属性
			prodProductService.updateProdProductProp(prodProduct);

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
				String logContent = "，产品Id:"+oldProduct.getProductId()+ logProduct;
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
	 * 跳转到修改页面
	 * @return
	 */
	@RequestMapping(value = "/showOrderLimit")
	public String showOrderLimit(Model model, HttpServletRequest req) throws BusinessException {
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
				List<BizCategoryProp> bizCategoryPropList = new ArrayList<BizCategoryProp>();
				if(CollectionUtils.isNotEmpty(bizCatePropGroupList)){
					for(BizCatePropGroup bizCatePropGroup : bizCatePropGroupList){
						if(bizCatePropGroup != null && bizCatePropGroup.getGroupId() == 196){
							bizCategoryPropList = bizCatePropGroup.getBizCategoryPropList();
							break;
						}
					}
				}
				model.addAttribute("bizCategoryPropList", bizCategoryPropList);
			}
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
		}
		return "/prod/superMember/product/showOrderLimit";
	}

	/**
	 * 修改产品
	 *
	 * @return
	 */
	@RequestMapping(value = "/saveOrderLimit")
	@ResponseBody
	public Object saveOrderLimit(ProdProduct prodProduct, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<updateProduct>");
		}
		ProdProduct oldProduct = getProdProductByProductId(prodProduct.getProductId());
		if (prodProduct.getBizCategoryId()!=null) {
			//修改产品基本信息、产品属性
			prodProductService.updateProdProductProp(prodProduct);

			// 清除缓存
			//基本信息
			MemcachedUtil.getInstance().remove(MemcachedEnum.ProdProductSingle.getKey() + prodProduct.getProductId());
			//产品属性
			MemcachedUtil.getInstance().remove(MemcachedEnum.ProductWithPropList.getKey() + prodProduct.getProductId());

			Map<String, Object> attributes = new HashMap<String, Object>();
			attributes.put("productId", prodProduct.getProductId());
			attributes.put("productName", oldProduct.getProductName());
			attributes.put("categoryName", oldProduct.getBizCategory().getCategoryName());
			//添加操作日志
			try {
				String logProduct = getProdProductPropLog(prodProduct, oldProduct);
				String logContent = "，产品Id:"+oldProduct.getProductId()+ logProduct;
				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT,
						prodProduct.getProductId(), prodProduct.getProductId(),
						this.getLoginUser().getUserName(),
						"修改产品：【"+oldProduct.getProductName()+"】"+logContent,
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
        //产品属性
        sb.append(getProdProductPropLog(prodProduct, oldProduct));
        return sb.toString();
    }

    /**
     * 获取产品某个字段的修改日志
     *
     * @param columnName
     * @param oldStr
     * @param newStr
     * @return
     */
    private String getChangeLog(String columnName, String oldStr, String newStr) {
        if (oldStr != null && (oldStr.equals(SuperMemberPriceSet.PROD_EXPIRE_DATE_TYPE.AFTER_BUY_DATE.name())
                || oldStr.equals(SuperMemberPriceSet.PROD_EXPIRE_DATE_TYPE.DESIGNATED_DATE.name()))) {
            oldStr = SuperMemberPriceSet.PROD_EXPIRE_DATE_TYPE.getCnName(oldStr);
        }
        if (newStr != null && (newStr.equals(SuperMemberPriceSet.PROD_EXPIRE_DATE_TYPE.AFTER_BUY_DATE.name())
                || newStr.equals(SuperMemberPriceSet.PROD_EXPIRE_DATE_TYPE.DESIGNATED_DATE.name()))) {
            newStr = SuperMemberPriceSet.PROD_EXPIRE_DATE_TYPE.getCnName(newStr);
        }
        if (oldStr != null && (oldStr.equals(SuperMemberPriceSet.AFTER_BUY_EXPIRE_DATE_TYPE.YEAR.name())
                || oldStr.equals(SuperMemberPriceSet.AFTER_BUY_EXPIRE_DATE_TYPE.MONTH.name())
                || oldStr.equals(SuperMemberPriceSet.AFTER_BUY_EXPIRE_DATE_TYPE.DAY.name()))) {
            oldStr = SuperMemberPriceSet.AFTER_BUY_EXPIRE_DATE_TYPE.getCnName(oldStr);
        }
        if (newStr != null && (newStr.equals(SuperMemberPriceSet.AFTER_BUY_EXPIRE_DATE_TYPE.YEAR.name())
                || newStr.equals(SuperMemberPriceSet.AFTER_BUY_EXPIRE_DATE_TYPE.MONTH.name())
                || newStr.equals(SuperMemberPriceSet.AFTER_BUY_EXPIRE_DATE_TYPE.DAY.name()))) {
            newStr = SuperMemberPriceSet.AFTER_BUY_EXPIRE_DATE_TYPE.getCnName(newStr);
        }
        String temp = "";
        if (oldStr == null && newStr == null) {
            return temp;
        } else if (oldStr == null || newStr == null) {
            temp = ComLogUtil.getLogTxt(columnName, newStr, oldStr);
            return temp;
        } else {
            if (!oldStr.equals(newStr)) {
                temp = ComLogUtil.getLogTxt(columnName, newStr, oldStr);
                return temp;
            }
        }
        return "";
    }

    /**
     * 获取产品属性的修改日志
     *
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
            if (bizCategoryProp == null) {
                continue;
            }
            String newPropStr = prop.getPropValue();
            if(prop.getAddValue() != null){
            	newPropStr += prop.getAddValue();
            }
            //新属性存在和原来的属性都存在
            if (oldPropPropIdMap.containsKey(prop.getProdPropId())) {
                ProdProductProp oldProp = oldPropPropIdMap.get(prop.getProdPropId());
                String oldPropStr = oldProp.getPropValue();
                if(oldProp.getAddValue() != null){
                	oldPropStr += oldProp.getAddValue();
                }
                ret.append(getChangeLog(bizCategoryProp.getPropName(), oldPropStr,newPropStr));
            } else {  //新属性存在,原来的属性不存在
                ret.append(getChangeLog(bizCategoryProp.getPropName(), null, newPropStr));
            }
        }
        return ret.toString();
    }

    @RequestMapping("/showSaleInfo")
    public Object showSaleInfo(Model model, Long productId) {
        if(productId == null){
            throw new BusinessException("产品id为空");
        }
        model.addAttribute("productId", productId);
        ProdProduct prodProduct = getProdProductByProductId(productId);
        if(prodProduct == null){
            throw new BusinessException("产品不存在");
        }
        model.addAttribute("prodProduct", prodProduct);
        List<BizCatePropGroup> bizCatePropGroupList =
                categoryPropGroupService.findCategoryPropGroupsAndCategoryProp(prodProduct.getBizCategoryId(), false);
        if (CollectionUtils.isNotEmpty(bizCatePropGroupList)) {
            List<BizCategoryProp> bizCategoryPropList = bizCatePropGroupList.get(0).getBizCategoryPropList();
            bizCatePropGroupList.get(0).setBizCategoryPropList(filterAndSortProp(bizCategoryPropList));
        }
        model.addAttribute("bizCatePropGroupList", bizCatePropGroupList);
        //产品属性值
        Map<String, Object> propMap = prodProduct.getPropValue();
        model.addAttribute("propMap", propMap);
        //产品属性
        Map<String, ProdProductProp> prodPropMap = new HashMap<>();
        List<ProdProductProp> prodPropList = prodProduct.getProdProductPropList();
        if (CollectionUtils.isNotEmpty(prodPropList)) {
            for (ProdProductProp prodProp : prodPropList) {
                if (prodProp == null) {
                    continue;
                }
                prodPropMap.put(String.valueOf(prodProp.getPropId()), prodProp);
            }
        }
        model.addAttribute("prodPropMap", prodPropMap);
        //退改规则
        HashMap<String, Object> params = new HashMap<>();
        params.put("productId", productId);
        List<ProdRefund> prodRefundList = prodRefundService.selectByParams(params);
        if (CollectionUtils.isNotEmpty(prodRefundList)) {
            ProdRefund prodRefund = prodRefundList.get(0);
            model.addAttribute("prodRefund", prodRefund);
            if (ProdRefund.CANCELSTRATEGYTYPE.RETREATANDCHANGE.name().equals(prodRefund.getCancelStrategy())) {
                if (CollectionUtils.isNotEmpty(prodRefund.getProdRefundRules())) {
                    model.addAttribute("prodRefundRule", prodRefund.getProdRefundRules().get(0));
                }
            }
        }
        return "prod/superMember/product/showSaleInfo";
    }

    private List<BizCategoryProp> filterAndSortProp(List<BizCategoryProp> bizCategoryPropList) {
        if (CollectionUtils.isEmpty(bizCategoryPropList)) {
            return null;
        }
        List<BizCategoryProp> propList = new ArrayList<>();
        for (BizCategoryProp prop : bizCategoryPropList) {
            if (prop.getPropId() >= 1351 && prop.getPropId() <= 1358) {
                propList.add(prop);
            }
        }
        Collections.sort(propList, new Comparator<BizCategoryProp>() {
            @Override
            public int compare(BizCategoryProp o1, BizCategoryProp o2) {
                if (o1.getPropId() > o2.getPropId()) {
                    return 1;
                }
                return -1;
            }
        });
        return propList;
    }

    @RequestMapping("/saveSaleInfo")
    @ResponseBody
    public Object saveSaleInfo(ProdProduct product, ProdRefund prodRefund) {
        ResultMessage resultMessage = ResultMessage.createResultMessage();
        if (product == null || product.getProductId() == null) {
            resultMessage.raise("产品id不存在");
            return resultMessage;
        }
        ProdProduct oldProduct = getProdProductByProductId(product.getProductId());
        List<ProdProductProp> prodProductPropList = product.getProdProductPropList();
        if (CollectionUtils.isNotEmpty(prodProductPropList)) {
            for (ProdProductProp prodProductProp : prodProductPropList) {
                prodProductProp.setProductId(product.getProductId());
                if (prodProductProp.getProdPropId() == null) {
                    prodProductPropClientService.addProdProductProp(prodProductProp);
                } else {
                    prodProductPropClientService.updateProdProductProp(prodProductProp);
                }
            }
        }
        //更新可售状态
		prodProductService.updateProductSaleFlag(product.getProductId(), isSale(product)?"Y":"N", false);
        //退改规则
        HashMap<String, Object> params = new HashMap<>();
        params.put("productId", product.getProductId());
        List<ProdRefund> prodRefundList = prodRefundService.selectByParams(params);
        String oldRefundStr = null;
        String newRefundStr = getRefundContent(prodRefund);
        if (CollectionUtils.isNotEmpty(prodRefundList)) {
            ProdRefund oldProdRefund = prodRefundList.get(0);
            oldRefundStr = getRefundContent(oldProdRefund);
        }
        prodRefundService.saveSuperMemberProdRefund(prodRefund);
        //更新价格库存对应的销售时间
        updateTimePriceBySalesDate(product, oldProduct);
        //添加操作日志
        try {
            String logContent = getProdProductPropLog(product, oldProduct) + ComLogUtil.getChangeLog("产品退改规则", newRefundStr, oldRefundStr);
            comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT,
                    product.getProductId(), product.getProductId(),
                    this.getLoginUser().getUserName(),
                    "修改产品销售信息：" + logContent,
                    COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name(),
                    "修改产品", null);
        } catch (Exception e) {
            log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
            log.error(e.getMessage());
        }
        //清除产品属性缓存
        MemcachedUtil.getInstance().remove(MemcachedEnum.ProductWithPropList.getKey() + product.getProductId());
        return resultMessage;
    }

    private void updateTimePriceBySalesDate(ProdProduct prodProduct, ProdProduct oldProduct){
        if(prodProduct == null || oldProduct == null){
            return;
        }
        List<ProdProductProp> propList = prodProduct.getProdProductPropList();
        Map<String, String> dateMap = getSaleDateMap(propList);
        Map<String, String> oldDateMap = getSaleDateMap(oldProduct.getProdProductPropList());
        String start = dateMap.get("sale_start_date");
        String end = dateMap.get("sale_end_date");
        String oldStart = oldDateMap.get("sale_start_date");
        String oldEnd = oldDateMap.get("sale_end_date");
        if(StringUtils.isBlank(start) || StringUtils.isBlank(end)){
            return;
        }
        if(StringUtils.isBlank(oldStart) || StringUtils.isBlank(oldEnd)){
            return;
        }
        if(oldStart.equals(start) && oldEnd.equals(end)){
            return;
        }
        SuppGoods suppGoods = suppGoodsService.findBaseSuppGoodsByProductId(prodProduct.getProductId());
        SuperMemberGoodsTimePriceVo priceVo = null;
        if (suppGoods != null) {
            PriceResultHandleT<SuperMemberGoodsTimePriceVo> resultHandleT = superMemberGoodsTimePriceApiService.selectBySuppGoodsId(suppGoods.getSuppGoodsId());
            if(resultHandleT != null){
                priceVo = resultHandleT.getReturnContent();
            }
        }
        if(priceVo == null){
            return;
        }
        PriceResultHandleT<Integer> priceResultHandleT = superMemberGoodsTimePriceApiService.updateTimePriceBySalesDate(priceVo,
                DateUtil.toDate(start, "yyyy-MM-dd"), DateUtil.toDate(end, "yyyy-MM-dd"));
        if(priceResultHandleT != null && priceResultHandleT.isFail()){
            LOG.error("更新时间价格表对应的销售时间失败：" + priceResultHandleT.getMsg());
        }
    }

    private String getRefundContent(ProdRefund refund) {
        String refundStr = null;
        if (ProdRefund.CANCELSTRATEGYTYPE.UNRETREATANDCHANGE.name().equals(refund.getCancelStrategy())) {
            refundStr = "本产品一经预定不可退改";
        } else if (ProdRefund.CANCELSTRATEGYTYPE.RETREATANDCHANGE.name().equals(refund.getCancelStrategy())) {
            ProdRefundRule refundRule = refund.getProdRefundRules().get(0);
            refundStr = "可退改，购买产品" + refundRule.getCancelTime() + "天内" + refundRule.getApplyType();
        }
        return refundStr;
    }

    @RequestMapping("/showPriceStock")
    public Object showPriceStock(Model model, Long productId) {
        if (productId == null) {
            throw new BusinessException("产品id不存在");
        }
        Map<String, Object> params = new HashMap<>();
        params.put("productId", productId);
        SuperMemberPriceSet superMemberPriceSet = superMemberPriceSetService.selectByParams(params);
        if (superMemberPriceSet != null) {
            model.addAttribute("priceSet", superMemberPriceSet);
            List<SuperMemberSalePromotion> promotionList = superMemberPriceSet.getSuperMemberSalePromotionList();
            model.addAttribute("promotion", mergePromotion(promotionList));
        }
        model.addAttribute("productId", productId);
        //会员接口获取人群标签
        List<PayLabelForProductBO> payLabelForProductBOList = crmPayMemberService.getLabelsForProduct();
        model.addAttribute("payLabelForProductBOList", payLabelForProductBOList);
        model.addAttribute("weekTimes", SuperMemberSalePromotion.WEEK_TIME.values());
        SuppGoods suppGoods = suppGoodsService.findBaseSuppGoodsByProductId(productId);
        if (suppGoods != null) {
			PriceResultHandleT<SuperMemberGoodsTimePriceVo> resultHandleT = superMemberGoodsTimePriceApiService.selectBySuppGoodsId(suppGoods.getSuppGoodsId());
			SuperMemberGoodsTimePriceVo priceVo = null;
			if(resultHandleT != null){
				priceVo = resultHandleT.getReturnContent();
			}
            if (priceVo != null) {
                model.addAttribute("totalStock", priceVo.getTotalStock());
                model.addAttribute("marketPrice", parsePriceToStr(priceVo.getMarketPrice()));
                model.addAttribute("salesPrice", parsePriceToStr(priceVo.getSalesPrice()));
                model.addAttribute("salePrice", parsePriceToStr(priceVo.getSalePrice()));
            }
        }
        return "prod/superMember/product/showPriceStock";
    }

    private SuperMemberSalePromotion mergePromotion(List<SuperMemberSalePromotion> promotionList) {
        if (CollectionUtils.isEmpty(promotionList)) {
            return null;
        }
        SuperMemberSalePromotion salePromotion = null;
        if (promotionList.size() == 1) {
            salePromotion = promotionList.get(0);
        } else {
            SuperMemberSalePromotion peoplePromotion = null;
            for (SuperMemberSalePromotion promotion : promotionList) {
                if (SuperMemberSalePromotion.PROMOTION_TYPE.PEOPLE_PROMOTION.name().equals(promotion.getPromotionType())) {
                    peoplePromotion = promotion;
                } else {
                    salePromotion = promotion;
                }
            }
            if (salePromotion != null && peoplePromotion != null) {
                salePromotion.setPromotionType("PEOPLE_PROMOTION,TIME_PROMOTION");
                salePromotion.setPeopleTag(peoplePromotion.getPeopleTag());
            }
        }
        return salePromotion;
    }

    private Map<String, String> getProdSaleDate(Long productId) {
        Map<String, String> dateMap = new HashMap<>();
        ProdProduct prodProduct = getProdProductByProductId(productId);
        dateMap.put("categoryId", String.valueOf(prodProduct.getBizCategoryId()));
        List<ProdProductProp> prodProductPropList = prodProduct.getProdProductPropList();
        if (CollectionUtils.isNotEmpty(prodProductPropList)) {
            for (ProdProductProp prop : prodProductPropList) {
                if (prop.getPropId().equals(1356L)) {
                    dateMap.put("sale_start_date", prop.getPropValue());
                } else if (prop.getPropId().equals(1357L)) {
                    dateMap.put("sale_end_date", prop.getPropValue());
                }
            }
        }
        return dateMap;
    }

    @RequestMapping("/savePriceStock")
    @ResponseBody
    public Object savePriceStock(HttpServletRequest request, SuperMemberPriceSet priceSet,
                                 SuperMemberSalePromotion salePromotion) {
        ResultMessage resultMessage = ResultMessage.createResultMessage();
        if (priceSet == null || priceSet.getProductId() == null) {
            resultMessage.raise("产品id不存在");
            return resultMessage;
        }
        Map<String, Object> params = new HashMap<>();
        params.put("productId", priceSet.getProductId());
        SuperMemberPriceSet oldPriceSet = superMemberPriceSetService.selectByParams(params);
        SuppGoods suppGoods = suppGoodsService.findBaseSuppGoodsByProductId(priceSet.getProductId());
        SuperMemberGoodsTimePriceVo priceVo = new SuperMemberGoodsTimePriceVo();
        priceVo.setProductId(priceSet.getProductId());
        priceVo.setSuppGoodsId(suppGoods.getSuppGoodsId());
        String totalStockStr = request.getParameter("totalStock");
        String marketPriceStr = request.getParameter("marketPrice");
        String salesPriceStr = request.getParameter("salesPrice");
        String salePriceStr = request.getParameter("salePrice");
        if (StringUtils.isNotBlank(totalStockStr)) {
            priceVo.setTotalStock(Long.valueOf(totalStockStr));
        }
        if (StringUtils.isNotBlank(marketPriceStr)) {
            priceVo.setMarketPrice(dealPrice(marketPriceStr));
        }
        if (StringUtils.isNotBlank(salesPriceStr)) {
            priceVo.setSalesPrice(dealPrice(salesPriceStr));
        }
        if (StringUtils.isNotBlank(salePriceStr)) {
            priceVo.setSalePrice(dealPrice(salePriceStr));
        }
        Map<String, String> saleDateMap = getProdSaleDate(priceSet.getProductId());
        String categoryIdStr = saleDateMap.get("categoryId");
        if (StringUtils.isNotBlank(categoryIdStr)) {
            priceVo.setCategoryId(Long.valueOf(categoryIdStr));
        }
        String saleStartDate = saleDateMap.get("sale_start_date");
        String saleEndDate = saleDateMap.get("sale_end_date");
		if (StringUtils.isBlank(saleStartDate) || StringUtils.isBlank(saleEndDate)) {
			resultMessage.raise("操作失败，未设置销售有效期");
			return resultMessage;
		}
        SuperMemberGoodsTimePriceVo oldPriceVo = null;
        StringBuilder logBuilder = new StringBuilder();
        if (oldPriceSet == null) {
            //新增价格设置
            Long setId = superMemberPriceSetService.insertSelective(priceSet);
            if (setId == null) {
                resultMessage.raise("新增失败");
                return resultMessage;
            }
            logBuilder.append("新增库存设置：【" + formatStockFlag(priceSet.getStockFlag(), priceVo) + "】");
            logBuilder.append("新增价格设置：【" + SuperMemberPriceSet.PRICE_TYPE.getCnName(priceSet.getPriceType()) + "】");
            salePromotion.setSetId(setId);
            if (SuperMemberPriceSet.PRICE_TYPE.PROMOTED_PRICE.name().equals(priceSet.getPriceType())) {
                logBuilder.append(addSalePromotion(salePromotion));
            }
        } else {
            priceSet.setSetId(oldPriceSet.getSetId());
            superMemberPriceSetService.updateByPrimaryKey(priceSet);
			PriceResultHandleT<SuperMemberGoodsTimePriceVo> resultHandleT = superMemberGoodsTimePriceApiService.selectBySuppGoodsId(suppGoods.getSuppGoodsId());
			if(resultHandleT != null){
				oldPriceVo = resultHandleT.getReturnContent();
			}
            logBuilder.append(ComLogUtil.getChangeLog("库存设置",
                    formatStockFlag(oldPriceSet.getStockFlag(), oldPriceVo), formatStockFlag(priceSet.getStockFlag(), priceVo)));
            logBuilder.append(ComLogUtil.getChangeLog("售价类型",
                    SuperMemberPriceSet.PRICE_TYPE.getCnName(oldPriceSet.getPriceType()), SuperMemberPriceSet.PRICE_TYPE.getCnName(priceSet.getPriceType())));
            logBuilder.append(ComLogUtil.getChangeLog("促销标签内容", oldPriceSet.getPromotionContent(), priceSet.getPromotionContent()));
            List<SuperMemberSalePromotion> oldSalePromotionList = oldPriceSet.getSuperMemberSalePromotionList();
            if(salePromotion.getSetId() == null){
            	salePromotion.setSetId(priceSet.getSetId());
			}
            if (CollectionUtils.isEmpty(oldSalePromotionList)) {
                if (SuperMemberPriceSet.PRICE_TYPE.PROMOTED_PRICE.name().equals(priceSet.getPriceType())) {
                    logBuilder.append(addSalePromotion(salePromotion));
                }
            } else {
                if (SuperMemberPriceSet.PRICE_TYPE.FIXED_PRICE.name().equals(priceSet.getPriceType())) {
                    params.clear();
                    params.put("setId", oldPriceSet.getSetId());
                    superMemberSalePromotionService.deleteByParams(params);
                } else {
                    logBuilder.append(updatePromotion(oldSalePromotionList, salePromotion));
                }
            }
        }
        //新增价格库存
        if (StringUtils.isNotBlank(saleStartDate) && StringUtils.isNotBlank(saleEndDate)) {
			PriceResultHandleT<Integer> resultHandleT = null;
        	if(oldPriceVo == null){
        		priceVo.setStock(priceVo.getTotalStock());
				resultHandleT = superMemberGoodsTimePriceApiService.saveTimePrice(priceVo, DateUtil.toDate(saleStartDate, "yyyy-MM-dd")
						, DateUtil.toDate(saleEndDate, "yyyy-MM-dd"));
			}else {
				resultHandleT = superMemberGoodsTimePriceApiService.updateTimePrice(priceVo);
			}
			if(resultHandleT != null && resultHandleT.isFail()){
        		LOG.error("保存价格库存数据失败：" + resultHandleT.getMsg());
			}
            logBuilder.append(ComLogUtil.getChangeLog("市场价", parsePriceToStr(oldPriceVo == null ? null : oldPriceVo.getMarketPrice()), marketPriceStr));
            logBuilder.append(ComLogUtil.getChangeLog("销售价", parsePriceToStr(oldPriceVo == null ? null : oldPriceVo.getSalesPrice()), salesPriceStr));
            logBuilder.append(ComLogUtil.getChangeLog("促销价", parsePriceToStr(oldPriceVo == null ? null : oldPriceVo.getSalePrice()), salePriceStr));
        }
        //添加操作日志
        try {
            comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT,
                    priceSet.getProductId(), priceSet.getProductId(),
                    this.getLoginUser().getUserName(),
                    "修改产品价格库存：" + logBuilder.toString(),
                    COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name(),
                    "修改产品", null);
        } catch (Exception e) {
            log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
            log.error(e.getMessage());
        }
        return resultMessage;
    }

    private Long dealPrice(String priceStr) {
        BigDecimal price = new BigDecimal(priceStr);
        return price.multiply(new BigDecimal(100)).longValue();
    }

    private String parsePriceToStr(Long price) {
        if (price == null) {
            return null;
        }
        BigDecimal bigDecimal = new BigDecimal(price);
        return bigDecimal.divide(new BigDecimal(100)).toString();
    }

    private String updatePromotion(List<SuperMemberSalePromotion> oldSalePromotionList, SuperMemberSalePromotion salePromotion) {
        if (StringUtils.isBlank(salePromotion.getPromotionType())) {
            return "";
        }
        StringBuilder oldPromotionStr = new StringBuilder();
        StringBuilder promotionStr = new StringBuilder();
        SuperMemberSalePromotion oldPeoplePromotion = null;
        SuperMemberSalePromotion oldTimePromotion = null;
        for (SuperMemberSalePromotion promotion : oldSalePromotionList) {
            if (SuperMemberSalePromotion.PROMOTION_TYPE.PEOPLE_PROMOTION.name().equals(promotion.getPromotionType())) {
                oldPeoplePromotion = promotion;
            } else {
                oldTimePromotion = promotion;
            }
            oldPromotionStr.append(getPromotionLog(promotion));
        }
        Map<String, SuperMemberSalePromotion> promotionMap = formatSalePromotion(salePromotion);
        SuperMemberSalePromotion peoplePromotion = promotionMap.get("peoplePromotion");
        SuperMemberSalePromotion timePromotion = promotionMap.get("timePromotion");
        changeSalePromotionWithOld(peoplePromotion, oldPeoplePromotion);
        changeSalePromotionWithOld(timePromotion, oldTimePromotion);
        if (peoplePromotion != null) {
            promotionStr.append(getPromotionLog(peoplePromotion));
        }
        if (timePromotion != null) {
            promotionStr.append(getPromotionLog(timePromotion));
        }
        return ComLogUtil.getChangeLog("促销设置", oldPromotionStr.toString(), promotionStr.toString());
    }

    private void changeSalePromotionWithOld(SuperMemberSalePromotion salePromotion, SuperMemberSalePromotion oldPromotion) {
        if (oldPromotion != null && salePromotion != null) {
            salePromotion.setPromotionId(oldPromotion.getPromotionId());
            superMemberSalePromotionService.updateByPrimaryKey(salePromotion);
        } else if (oldPromotion != null) {
            if (oldPromotion.getSetId() != null) {
                Map<String, Object> params = new HashMap<>();
                params.put("promotionId", oldPromotion.getPromotionId());
                superMemberSalePromotionService.deleteByParams(params);
            }
        } else if (salePromotion != null) {
            superMemberSalePromotionService.insertSelective(salePromotion);
        }
    }

    private String formatStockFlag(String stockFlag, SuperMemberGoodsTimePriceVo priceVo) {
        StringBuilder builder = new StringBuilder();
        builder.append(SuperMemberPriceSet.STOCK_FLAG.getCnName(stockFlag));
        if (SuperMemberPriceSet.STOCK_FLAG.Y.name().equals(stockFlag)) {
        	if(priceVo != null){
				builder.append(priceVo.getTotalStock());
			}
        }
        return builder.toString();
    }

    private String getPromotionLog(SuperMemberSalePromotion salePromotion) {
        if (salePromotion == null) {
            return "";
        }
        StringBuilder logBuilder = new StringBuilder();
        if (SuperMemberSalePromotion.PROMOTION_TYPE.PEOPLE_PROMOTION.name().equals(salePromotion.getPromotionType())) {
            logBuilder.append("【人群促销：“" + salePromotion.getPeopleTag() + "”】");
        } else if (SuperMemberSalePromotion.PROMOTION_TYPE.TIME_PROMOTION.name().equals(salePromotion.getPromotionType())) {
            logBuilder.append("【时间促销：“");
            if (SuperMemberSalePromotion.TIME_TYPE.EVERY_WEEK.name().equals(salePromotion.getTimeType())) {
                logBuilder.append("每周的" + formatWeekTime(salePromotion.getWeekTime()));
            } else if (SuperMemberSalePromotion.TIME_TYPE.EVERY_MONTH.name().equals(salePromotion.getTimeType())) {
                logBuilder.append("每月的" + salePromotion.getMonthTime() + "号");
            } else if (SuperMemberSalePromotion.TIME_TYPE.DESIGNED_TIME.name().equals(salePromotion.getTimeType())) {
                logBuilder.append("固定时间：" + salePromotion.getDesignatedStartDate() + "—" + salePromotion.getDesignatedEndDate());
            }
            logBuilder.append("”】");
        }
        return logBuilder.toString();
    }

    private Map<String, SuperMemberSalePromotion> formatSalePromotion(SuperMemberSalePromotion salePromotion) {
        Map<String, SuperMemberSalePromotion> promotionMap = new HashMap<>();
        List<String> promotionTypeList = Arrays.asList(salePromotion.getPromotionType().split(","));
        SuperMemberSalePromotion peoplePromotion = null;
        SuperMemberSalePromotion timePromotion = null;
        if (promotionTypeList.contains(SuperMemberSalePromotion.PROMOTION_TYPE.PEOPLE_PROMOTION.name())) {
            peoplePromotion = new SuperMemberSalePromotion();
            peoplePromotion.setSetId(salePromotion.getSetId());
            peoplePromotion.setPromotionType(SuperMemberSalePromotion.PROMOTION_TYPE.PEOPLE_PROMOTION.name());
            peoplePromotion.setPeopleTag(salePromotion.getPeopleTag());
            promotionMap.put("peoplePromotion", peoplePromotion);
        }
        if (promotionTypeList.contains(SuperMemberSalePromotion.PROMOTION_TYPE.TIME_PROMOTION.name())) {
            timePromotion = new SuperMemberSalePromotion();
			timePromotion.setSetId(salePromotion.getSetId());
            timePromotion.setPromotionType(SuperMemberSalePromotion.PROMOTION_TYPE.TIME_PROMOTION.name());
            timePromotion.setTimeType(salePromotion.getTimeType());
            if (SuperMemberSalePromotion.TIME_TYPE.EVERY_WEEK.name().equals(timePromotion.getTimeType())) {
                timePromotion.setWeekTime(salePromotion.getWeekTime());
            } else if (SuperMemberSalePromotion.TIME_TYPE.EVERY_MONTH.name().equals(timePromotion.getTimeType())) {
                timePromotion.setMonthTime(salePromotion.getMonthTime());
            } else if (SuperMemberSalePromotion.TIME_TYPE.DESIGNED_TIME.name().equals(timePromotion.getTimeType())) {
                timePromotion.setDesignatedStartDate(salePromotion.getDesignatedStartDate());
                timePromotion.setDesignatedEndDate(salePromotion.getDesignatedEndDate());
            }
            promotionMap.put("timePromotion", timePromotion);
        }
        return promotionMap;
    }


    private String addSalePromotion(SuperMemberSalePromotion salePromotion) {
        if (StringUtils.isBlank(salePromotion.getPromotionType())) {
            LOG.error("促销类型为空");
            return "";
        }
        StringBuilder logBuilder = new StringBuilder();
        logBuilder.append("新增促销：");
        Map<String, SuperMemberSalePromotion> promotionMap = formatSalePromotion(salePromotion);
        SuperMemberSalePromotion peoplePromotion = promotionMap.get("peoplePromotion");
        SuperMemberSalePromotion timePromotion = promotionMap.get("timePromotion");
        if (peoplePromotion != null) {
            superMemberSalePromotionService.insertSelective(peoplePromotion);
            logBuilder.append(getPromotionLog(peoplePromotion));
        }
        if (timePromotion != null) {
            superMemberSalePromotionService.insertSelective(timePromotion);
            logBuilder.append(getPromotionLog(timePromotion));
        }
        return logBuilder.toString();
    }

    private String formatWeekTime(String weekTime) {
        if (StringUtils.isBlank(weekTime)) {
            return "";
        }
        StringBuilder result = new StringBuilder();
        List<String> weekList = Arrays.asList(weekTime.split(","));
        for (String item : weekList) {
            result.append(SuperMemberSalePromotion.WEEK_TIME.getCnName(item));
            result.append(",");
        }
        result.deleteCharAt(result.length() - 1);
        return result.toString();
    }
}
