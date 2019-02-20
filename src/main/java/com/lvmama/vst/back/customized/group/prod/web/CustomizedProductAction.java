package com.lvmama.vst.back.customized.group.prod.web;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.comm.cache.squid.SquidClient;
import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.comm.tnt.po.TntGoodsChannelVo;
import com.lvmama.vst.back.biz.po.BizCatePropGroup;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.po.BizCategoryProp;
import com.lvmama.vst.back.biz.po.BizDest;
import com.lvmama.vst.back.biz.po.BizDict;
import com.lvmama.vst.back.biz.po.BizEnum;
import com.lvmama.vst.back.biz.po.BizOrderRequired;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.biz.service.BizDictQueryService;
import com.lvmama.vst.back.client.biz.service.BizOrderRequiredClientService;
import com.lvmama.vst.back.biz.service.CategoryPropGroupService;
import com.lvmama.vst.back.client.biz.service.CategoryPropClientService;
import com.lvmama.vst.back.biz.service.DestService;
import com.lvmama.vst.back.dist.po.DistDistributorProd;
import com.lvmama.vst.back.dist.po.Distributor;
import com.lvmama.vst.back.dist.service.DistributorCachedService;
import com.lvmama.vst.back.dujia.comm.prod.po.ProdLineBasicInfo;
import com.lvmama.vst.back.dujia.comm.prod.po.ProdProductDescription;
import com.lvmama.vst.back.dujia.client.comm.prod.service.ProdLineBasicInfoClientService;
import com.lvmama.vst.back.dujia.client.comm.prod.service.ProdProductDescriptionClientService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.goods.vo.ProdProductParam;
import com.lvmama.vst.back.prod.po.ProdDestRe;
import com.lvmama.vst.back.prod.po.ProdEcontract;
import com.lvmama.vst.back.prod.po.ProdLineRoute;
import com.lvmama.vst.back.prod.po.ProdLineRouteDetail;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductProp;
import com.lvmama.vst.back.prod.po.ProdProductSaleRe;
import com.lvmama.vst.back.prod.po.ProdVisadocRe;
import com.lvmama.vst.back.prod.service.AssociationRecommendService;
import com.lvmama.vst.back.client.dist.service.DistDistributorProdClientService;
import com.lvmama.vst.back.client.prod.service.ProdDestReClientService;
import com.lvmama.vst.back.client.prod.service.ProdEcontractClientService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteDetailClientService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductPropClientService;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.prod.service.ProdProductServiceAdapter;
import com.lvmama.vst.back.prod.service.ProdTrafficGroupService;
import com.lvmama.vst.back.client.prod.service.ProdTrafficClientService;
import com.lvmama.vst.back.prod.service.ProdVisadocReService;
import com.lvmama.vst.back.pub.po.ComLog;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.pub.po.ComOrderRequired;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.pub.service.ComOrderRequiredClientService;
import com.lvmama.vst.back.pub.service.PushAdapterService;
import com.lvmama.vst.comm.enumeration.CommEnumSet;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.Constant.VST_CATEGORY;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;
import com.lvmama.vst.pet.adapter.TntGoodsChannelCouponAdapter;
import com.lvmama.vst.back.utils.MiscUtils;
/**
 * 定制游供应商打包产品Action
 */
@Controller
@RequestMapping("/customized/group/product")
public class CustomizedProductAction extends BaseActionSupport {

	private static final long serialVersionUID = 3636755752901703434L;

	@Autowired
	private ProdTrafficClientService prodTrafficService;

	@Autowired
	private ProdProductService prodProductService;

	@Autowired
	PushAdapterService pushAdapterService;

	@Autowired
	private ComLogClientService comLogService;

	@Autowired
	private ProdLineRouteClientService prodLineRouteService;

	@Autowired
	private PermUserServiceAdapter permUserService;

	@Autowired
	private ProdVisadocReService prodVisadocReService;

	@Autowired
	private ProdLineRouteDetailClientService prodLineRouteDetailService;

	@Autowired
	private ProdProductDescriptionClientService productDescriptionService;
	
	@Autowired
	private TntGoodsChannelCouponAdapter tntGoodsChannelCouponServiceRemote;

	@Autowired
	private DistributorCachedService distributorService;

	@Autowired
	private ProdProductDescriptionClientService prodProductDescriptionService;

	@Autowired
	private ProdProductServiceAdapter prodProductServiceAdapter;

	@Autowired
	private ComOrderRequiredClientService comOrderRequiredService;

	@Autowired
	private DistDistributorProdClientService distDistributorProdService;

	@Autowired
	private ProdLineBasicInfoClientService prodLineBasicInfoService;

	@Autowired
	private BizOrderRequiredClientService bizOrderRequiredService;

	@Autowired
	private ProdEcontractClientService prodEcontractService;

	@Autowired
	private ProdDestReClientService prodDestReService;

	@Autowired
	private  DistDistributorProdClientService prodDistributorService;
	
	@Autowired
	private CategoryPropClientService categoryPropService;
	
	@Autowired
	private BizDictQueryService bizDictQueryService;
	
	@Autowired
	private AssociationRecommendService associationRecommendService;
	
	@Autowired
	private DestService destService;
	
	@Autowired
    private CategoryPropGroupService categoryPropGroupService;
	
	@Autowired
    private ProdProductPropClientService prodProductPropService;
	
	@Autowired
	private ProdTrafficGroupService prodTrafficGroupService;
	
	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;
	/**
	 * 渲染 产品主框架 页面
	 */
	@RequestMapping(value = "/showProductMaintain")
	public String showProductMaintain(Model model, Long productId, String categoryName, Long categoryId, String isView) {
		model.addAttribute("categoryId", categoryId);
		model.addAttribute("categoryName", categoryName);
		model.addAttribute("productId", productId);
		model.addAttribute("isView", isView);
		if (productId != null) {
			//1. 校验行程
			List<ProdLineRoute> lineRouteList = checkRoute(productId);
			String routeFlag = "false";
			if (lineRouteList != null && lineRouteList.size() >= 1) {
				routeFlag = "true";
			}
			model.addAttribute("routeFlag", routeFlag);

			//2. 校验行程明细
			String saveRouteFlag = checkRouteDetail(productId);
			model.addAttribute("saveRouteFlag", saveRouteFlag);

			//3. 校验交通信息是否已经填写
			Boolean saveTransportFlag = prodTrafficService.checkTrafficDetial(productId);
			model.addAttribute("saveTransportFlag", saveTransportFlag.toString());

			ProdProduct prodProduct = prodProductService.getProdProductBy(productId);

			// 出境-需要校验签证材料
			if ("FOREIGNLINE".equals(prodProduct.getProductType())) {
				String visaDocFlag = checkvisaDoc(productId);
				model.addAttribute("visaDocFlag", visaDocFlag);
			}

			model.addAttribute("productName", prodProduct.getProductName());
			model.addAttribute("productType", prodProduct.getProductType());
			model.addAttribute("categoryId", prodProduct.getBizCategoryId());
			model.addAttribute("categoryName", BizEnum.BIZ_CATEGORY_TYPE.getCnName(prodProduct.getBizCategoryId()));
			model.addAttribute("packageType", prodProduct.getPackageType());
			
			String bu = associationRecommendService
					.getBuOfProduct(productId, prodProduct.getBu(), categoryId,
							prodProduct.getPackageType());
			model.addAttribute("bu", bu);
		} else {
			model.addAttribute("productName", null);
		}
		return "/customized/group/prod/showProductMaintain";
	}

	/**
	 * 渲染 新增产品 页面 
	 */
	@RequestMapping(value = "/showAddProduct")
	public String showAddProduct(Model model, HttpServletRequest req) {
		
		BizCategory bizCategory = null;
		List<BizCatePropGroup> bizCatePropGroupList = null;
		if (req.getParameter("categoryId") != null) {
			bizCategory = bizCategoryQueryService.getCategoryById(Long.valueOf(req.getParameter("categoryId")));
			bizCatePropGroupList = categoryPropGroupService.findCategoryPropGroupsAndCategoryProp(Long.valueOf(req.getParameter("categoryId")), true);
		}
		model.addAttribute("bizCategory", bizCategory);
		if(bizCategory != null){
		    model.addAttribute("categoryName", bizCategory.getCategoryName());
		    //用于判断前台是否展示按份售卖
		    VST_CATEGORY routeFreedom = Constant.VST_CATEGORY.CATEGORY_ROUTE_FREEDOM;
		    String showSaleTypeFlag = routeFreedom.getCategoryId().equals(bizCategory.getCategoryId().toString()) ? "YES" : "NO";
			model.addAttribute("showSaleTypeFlag", showSaleTypeFlag);
		}
		model.addAttribute("copiesList", ProdProductSaleRe.COPIES.values());
		
		this.setModelAtrributes(model);
		model.addAttribute("bizCatePropGroupList", bizCatePropGroupList);
		model.addAttribute("categoryId", req.getParameter("categoryId"));
		return "/customized/group/prod/showAddProduct";
	}

	/**
	 * 渲染 产品修改页面
	 */
	@RequestMapping(value = "/showUpdateProduct")
	public String showUpdateProduct(Model model, long productId, HttpServletRequest req) {
		if (productId <= 0) {
			return "/customized/group/prod/showUpdateProduct";
		}

		//1. 抓取产品基础信息
		ProdProductParam productParam = new ProdProductParam();
		productParam.setBizCategory(true);
		productParam.setBizDistrict(true);
		ProdProduct prodProduct = prodProductService.findProdProductById(productId, productParam);
		if (prodProduct == null) {
			return "/customized/group/prod/showUpdateProduct";
		}

		//判断是否点击条款菜单响应
		String suggestionType = req.getParameter("suggestionType");
		//查询产品经理名称
		PermUser permUser = permUserService.getPermUserByUserId(prodProduct.getManagerId());
		if(permUser != null) {
			prodProduct.setManagerName(permUser.getRealName());
		}
		/**
		 * 条款
		 */
		List<BizCatePropGroup> bizCatePropGroupList = null;
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
		
		model.addAttribute("bizCatePropGroupList", bizCatePropGroupList);
		
		//查询关联数据
		prodProductServiceAdapter.findProdProductReData(prodProduct);
		model.addAttribute("prodProduct", prodProduct);

		//设置上级目的地名称
		List<ProdDestRe> prodDestReList = prodProduct.getProdDestReList();
		List<BizDest> bizDestList = new ArrayList<BizDest>();
		if(prodDestReList != null){
			for(ProdDestRe prodDestRe:prodDestReList){
				BizDest bizDest = new BizDest();
				BizDest parentBbizDest = new BizDest();
				bizDest.setDestId(prodDestRe.getDestId());
				bizDest.setParentDest(parentBbizDest);
				bizDestList.add(bizDest);
			}
			Map<String, Object> parameters = new HashMap<String, Object>();
			bizDestList = destService.setParentsDestNameInfo(bizDestList,parameters);
			StringBuffer sb = new StringBuffer();
			for(BizDest bizDest:bizDestList){
				for(ProdDestRe prodDestRe:prodDestReList){
					if(bizDest.getDestId().longValue() == prodDestRe.getDestId().longValue()){
						String[] sArray=bizDest.getParentDest().getDestName().split("--");
						sArray[sArray.length-1]=null;
						for(String i:sArray){
							if(i!=null){
								sb.append(i+"--");
							}
						};
						if(sb.length() > 0){
							sb.delete(sb.lastIndexOf("--"),sb.length());
						}
					       
						prodDestRe.setParentDestName(sb.toString());
						if(sb.length() > 0){
							sb.delete(0,sb.length());}
					}
				}
			}
		}

		//2. 抓取线路基础数据信息
		Map<String,Object> lineBasicInfoParam = new HashMap<String, Object>();
		lineBasicInfoParam.put("productId", productId);
		List<ProdLineBasicInfo> lineBasicInfoList = MiscUtils.autoUnboxing(prodLineBasicInfoService.findBasicInfoListByParams(lineBasicInfoParam));

		ProdLineBasicInfo lineBasicInfo = new ProdLineBasicInfo();
		if (CollectionUtils.isNotEmpty(lineBasicInfoList)) {
			lineBasicInfo = lineBasicInfoList.get(0);
		}
		model.addAttribute("prodLineBasicInfo", lineBasicInfo);

		//3. 线路产品描述信息（产品名称、产品推荐、产品详情）
		Map<String,Object> productNameParam = new HashMap<String, Object>();
		productNameParam.put("productId", productId);
		productNameParam.put("productType", prodProduct.getProductType());
		List<ProdProductDescription> productDescriptionList = MiscUtils.autoUnboxing(prodProductDescriptionService.findProductDescriptionListByParams(productNameParam));

		//接收产品名称
		//ProdProductNameVO productNameVo = new ProdProductNameVO();
		//接收产品推荐
		String[] productRecommends = new String[]{};
		//接收产品详情
		String productDetail = "";

		if (CollectionUtils.isNotEmpty(productDescriptionList)) {
			for (ProdProductDescription productDescription : productDescriptionList) {
				String contentType = productDescription.getContentType();
				String content = productDescription.getContent();
				if (StringUtil.isEmptyString(content)) {
					continue;
				}

				if (ProdProductDescription.CONTENT_TYPE.PRODUCT_NAME.name().equals(contentType)) {
					//productNameVo = JSONObject.parseObject(content, ProdProductNameVO.class);
				} else if (ProdProductDescription.CONTENT_TYPE.PRODUCT_RECOMMEND.name().equals(contentType)) {
					productRecommends = content.split("<br/>");
				} else if (ProdProductDescription.CONTENT_TYPE.PRODUCT_DETAIL.name().equals(contentType)) {
					productDetail = content;
				}
			}
		}
		//model.addAttribute("prodProductNameVo", productNameVo);
		model.addAttribute("productRecommends", productRecommends);
		model.addAttribute("productDetail", productDetail);

		//4.加载分销渠道的分销商
		ResultHandleT<Long[]> userIdLongRt = tntGoodsChannelCouponServiceRemote.list(productId, null, TntGoodsChannelCouponAdapter.PG_TYPE.PRODUCT.name());
		if(userIdLongRt != null && userIdLongRt.getReturnContent() != null && userIdLongRt.isSuccess()){
			Long[] userIdLong = (Long[])userIdLongRt.getReturnContent();
			StringBuilder userIdLongStr = new StringBuilder(",");
			for(Long userId : userIdLong){
				userIdLongStr.append(userId.toString()).append(",");
			}
			model.addAttribute("userIdLongStr", userIdLongStr.toString());
		}

		//5. 下单必填项
		Map<String, Object> params = new HashMap<String, Object>();
		List<BizOrderRequired> bizOrderRequiredList = bizOrderRequiredService.selectByExample(params);
		model.addAttribute("bizOrderRequiredList", bizOrderRequiredList);

		params.clear();
		params.put("objectType", ComOrderRequired.OBJECTTYPE.PROD_PROCUT.name());
		params.put("objectId", productId);
		List<ComOrderRequired> comOrderRequiredList = comOrderRequiredService.findComOrderRequiredList(params);
		if(CollectionUtils.isNotEmpty(comOrderRequiredList)){
			model.addAttribute("comOrderRequired", comOrderRequiredList.get(0));
		}

		//6. 电子合同
		ProdEcontract econtract = prodEcontractService.selectByProductId(prodProduct.getProductId());
		model.addAttribute("econtract", econtract);
		model.addAttribute("categoryId", prodProduct.getBizCategoryId());
		//7. 设置model的一些基础信息
		this.setModelAtrributes(model);
		if(StringUtil.isEmptyString(suggestionType)){
			return "/customized/group/prod/showUpdateProduct";
		}else{
			return "/customized/group/prod/showProductSugg";
		}
	}
	
	@RequestMapping(value = "/updateProductSugg")
    @ResponseBody
    public Object updateProductSugg(ProdProduct prodProduct, HttpServletRequest req) throws BusinessException {
        if (log.isDebugEnabled()) {
            log.debug("start method<updateProduct>");
        }
        if (prodProduct.getBizCategoryId() == null) {
            throw new BusinessException("产品数据错误：无品类");
        }
        if (prodProduct.getProductId() == null) {
            throw new BusinessException("产品数据错误：无产品Id");
        }
        ResultMessage message = null;

        //获取原始对象
        ProdProductParam param = new ProdProductParam();
        param.setProductProp(true);
        param.setProductPropValue(true);
        ProdProduct oldProdProduct = prodProductService.findProdProductById(prodProduct.getProductId(), param);

        prodProductService.updateProdProductProp(prodProduct);

        //添加操作日志
        try {
            String log =  getProdProductPropLog(prodProduct, oldProdProduct);
            if(StringUtil.isNotEmptyString(log)){
                comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.PROD_PRODUCT_SUGG,
                        prodProduct.getProductId(), prodProduct.getProductId(),
                        this.getLoginUser().getUserName(),
                        "修改产品:" + log,
                        ComLog.COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_SUGG_CHANGE.name(),
                        "修改产品",null);
            }
        } catch (Exception e) {
            log.error("Record Log failure ！Log type:"+ ComLog.COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
            log.error(ExceptionFormatUtil.getTrace(e));
        }
        SquidClient.getInstance().purgeProduct(prodProduct.getBizCategoryId(), prodProduct.getProductId()+"");
        message = new ResultMessage("success", "保存成功");
        return message;
    }


	/**
	 * 新增产品
	 */
	@RequestMapping(value = "/addProduct")
	@ResponseBody
	public Object addProduct(ProdProduct prodProduct, ComOrderRequired comOrderRequired, String comOrderRequiredFlag, String distributorUserIds, HttpServletRequest req) throws BusinessException {
		if (prodProduct == null || prodProduct.getBizCategoryId() == null || StringUtil.isEmptyString(prodProduct.getProductType())) {
			return new ResultMessage(ResultMessage.ERROR, "系统参数异常：接收到得必要参数为空");
		}

		//设置版本号
		prodProduct.setModelVersion(ProdProduct.MODEL_VERSION_1D0);
		//审核状态：待产品经理审核 （自动创建产品规格）
		prodProduct.setAuditStatus(ProdProduct.AUDITTYPE.AUDITTYPE_TO_PM.name());
		//创建人：当前操作账号名称
		prodProduct.setCreateUser(this.getLoginUserId());
		long productId = prodProductServiceAdapter.saveProdProduct(prodProduct);

		if (productId <= 0) {
			return new ResultMessage(ResultMessage.ERROR, "添加产品失败");
		}
		prodProduct.setProductId(productId);

		//1. 保存产品关联数据
		prodProductServiceAdapter.saveProdProductReData(prodProduct);

		//2. 双写 线路产品基础数据、产品名称、产品推荐、产品详情 等信息
		this.doubleWriteLineProductRe(prodProduct, req);

		//3. 保存下单必填项
		if("Y".equals(comOrderRequiredFlag)){
			comOrderRequired.setObjectType(ComOrderRequired.OBJECTTYPE.PROD_PROCUT.name());
			comOrderRequired.setObjectId(productId);
			comOrderRequiredService.saveComOrderRequired(comOrderRequired);
		}

		//4. 新增产品的销售渠道
		String[] distributorIds = req.getParameterValues("distributorIds");
		String[] distUserNames =req.getParameterValues("distUserNames");
		String logContent = distDistributorProdService.saveOrUpdateDistributorProd(productId, distributorIds);
		if(distUserNames!=null){
			logContent=logContent+"分销商为："+Arrays.toString(distUserNames);
		}
		
		distDistributorProdService.pushSuperDistributor(prodProduct, distributorUserIds);

		//5. 跟团游 自由行发送消息，计算交通 酒店信息
		//pushAdapterService.push(prodProduct.getProductId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_PRODUCT,ComPush.OPERATE_TYPE.ADD);

		//6. 添加操作日志
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

		Map<String, Object> attributes = new HashMap<String, Object>();
		attributes.put("productId", productId);
		attributes.put("productName", prodProduct.getProductName());
		attributes.put("categoryName", prodProduct.getBizCategory().getCategoryName());
		attributes.put("productType", prodProduct.getProductType());
		return new ResultMessage(attributes, ResultMessage.SUCCESS, "保存成功");
	}

	/**
	 * 更新产品
	 */
	@RequestMapping(value = "/updateProduct")
	@ResponseBody
	public Object updateProduct(ProdProduct prodProduct, ComOrderRequired comOrderRequired, String distributorUserIds, HttpServletRequest req) throws BusinessException {
		if (prodProduct == null || prodProduct.getBizCategoryId() == null || prodProduct.getProductId() == null) {
			log.error("update product occurs error, message:某些必要参数为空, [productId:" + (prodProduct == null ? "null" : prodProduct.getProductId()) + "] categoryId:[" + (prodProduct == null ? "null" : prodProduct.getBizCategoryId()) + "]");
			return new ResultMessage(ResultMessage.ERROR, "系统参数异常：某些必要参数为空");
		}

		//获取老产品信息（为DB日志记录）
		ProdProduct oldProduct = this.getOldProdProuductByProductIdForLog(prodProduct.getProductId(), comOrderRequired);
		if (oldProduct == null) {
			return new ResultMessage(ResultMessage.ERROR, "无法找到该产品");
		}

		//1. 更新产品基础
		prodProduct.setUpdateUser(this.getLoginUserId());
		prodProductService.updateProdProductProp(prodProduct);

		//2. 更新产品关联数据（目的地信息、下单必填项）
		if (comOrderRequired != null) {
			prodProduct.setComOrderRequired(comOrderRequired);
		}
		prodProductServiceAdapter.updateProdProductReData(prodProduct);

		//3. 更新电子合同
		prodEcontractService.saveOrUpdate(prodProduct.getProdEcontract());

		//4. 双写 线路产品基础数据、产品名称、产品推荐、产品详情 等信息
		this.doubleWriteLineProductRe(prodProduct, req);

		//5. 更新产品的销售渠道
		String[] distributorIds = req.getParameterValues("distributorIds");
		String[] distUserNames =req.getParameterValues("distUserNames");
		
		
		String logContent = distDistributorProdService.saveOrUpdateDistributorProd(prodProduct.getProductId(), distributorIds);
		if(distUserNames!=null){
			logContent=logContent+"分销商为："+Arrays.toString(distUserNames);
		}
		
		distDistributorProdService.pushSuperDistributor(prodProduct, distributorUserIds);

		//6. 如果出境线路产品基础信息中的最小成团人数改变则修改出行警示（出境）VO json字符串及对应的大文本信息
		ProdLineBasicInfo oldProdLineBasicInfo = oldProduct.getProdLineBasicInfo();
		ProdLineBasicInfo newProdLineBasicInfo = prodProduct.getProdLineBasicInfo();
		long oldLeastClusterPerson = oldProdLineBasicInfo.getLeastClusterPerson();
		long newLeastClusterPerson = newProdLineBasicInfo.getLeastClusterPerson();
		if (ProdProduct.PRODUCTTYPE.FOREIGNLINE.name().equals(prodProduct.getProductType()) && oldLeastClusterPerson != newLeastClusterPerson) {
			ProdProductDescription productDescription = new ProdProductDescription();
			productDescription.setCategoryId(prodProduct.getBizCategoryId());
			productDescription.setProductId(prodProduct.getProductId());
			productDescription.setProductType(prodProduct.getProductType());
			prodProductDescriptionService.buildTravelAlertOutsideTextAndDoubleWrite(productDescription, false);
		}

		//7. 添加操作DB日志
		try {
			String logStr = getProdProductLog(prodProduct, oldProduct, distributorIds, distributorUserIds, comOrderRequired);

			if(StringUtils.isNotBlank(logStr)){
				logStr = "产品ID"+oldProduct.getProductId()+"," + logStr;

				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, 
						prodProduct.getProductId(), prodProduct.getProductId(), 
						this.getLoginUser().getUserName(), 
						"修改产品:"+logStr+","+logContent, 
						COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name(), 
						"修改产品",null);
			}

		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
			log.error(e.getMessage());
		}

		return new ResultMessage(ResultMessage.SUCCESS, "保存成功");
	}

	/**
	 * 双写 线路产品基础数据、产品名称、产品推荐、产品详情 等信息
	 */
	private void doubleWriteLineProductRe(ProdProduct prodProduct, HttpServletRequest req) {
		//1. 更新线路产品基础数据(双写)
		ProdLineBasicInfo lineBasicInfo = prodProduct.getProdLineBasicInfo();
		lineBasicInfo.setCategoryId(prodProduct.getBizCategoryId());
		lineBasicInfo.setProductId(prodProduct.getProductId());
		lineBasicInfo.setAddress("");
		prodLineBasicInfoService.saveOrUpdateDoublePlaceBasicInfoForCustomized(lineBasicInfo);

		//2. 保存跟团游的产品名称
		/*ProdProductDescription productNameDesc = new ProdProductDescription();
		productNameDesc.setCategoryId(prodProduct.getBizCategoryId());
		productNameDesc.setProductId(prodProduct.getProductId());
		productNameDesc.setProductType(prodProduct.getProductType());
		productNameDesc.setContentType(ProdProductDescription.CONTENT_TYPE.PRODUCT_NAME.name());
		if (prodProduct.getProdProductNameVO() != null) {
			String jsonStr = JSONObject.toJSONString(prodProduct.getProdProductNameVO());
			productNameDesc.setContent(jsonStr);
		}
		prodProductDescriptionService.saveOrUpdateDoublePlaceForProductDes(productNameDesc);*/

		//3. 保存产品推荐 (双写)
		String[] productRecommends = req.getParameterValues("productRecommends");
		StringBuffer recommendBuffer = new StringBuffer();
		if (ArrayUtils.isNotEmpty(productRecommends)) {
			for (int i = 0; i < productRecommends.length ; i++) {
				String value = productRecommends[i];
				if (i == productRecommends.length-1) {
					recommendBuffer.append(value);
				} else {
					recommendBuffer.append(value+"<br/>");
				}
			}
		}

		ProdProductDescription productRecommendDesc = new ProdProductDescription();
		productRecommendDesc.setCategoryId(prodProduct.getBizCategoryId());
		productRecommendDesc.setProductId(prodProduct.getProductId());
		productRecommendDesc.setProductType(prodProduct.getProductType());
		productRecommendDesc.setContentType(ProdProductDescription.CONTENT_TYPE.PRODUCT_RECOMMEND.name());
		productRecommendDesc.setContent(recommendBuffer.toString());
		prodProductDescriptionService.saveOrUpdateDoublePlaceForProductDesForCustomized(productRecommendDesc);

		//4. 保存产品特色 (双写)
		String productDetail = "";
		if(null != prodProduct.getProdProductPropList() && prodProduct.getProdProductPropList().size() > 0) {
			for(ProdProductProp prodProductProp : prodProduct.getProdProductPropList()) {
				if(prodProductProp != null && prodProductProp.getPropId() != null) {
					if(prodProductProp.getPropId() == 953L) {
						productDetail = prodProductProp.getPropValue();
					}
				}
			}
		}
		
		ProdProductDescription productDetailDesc = new ProdProductDescription();
		productDetailDesc.setCategoryId(prodProduct.getBizCategoryId());
		productDetailDesc.setProductId(prodProduct.getProductId());
		productDetailDesc.setProductType(prodProduct.getProductType());
		productDetailDesc.setContentType(ProdProductDescription.CONTENT_TYPE.PRODUCT_DETAIL.name());
		productDetailDesc.setContent(productDetail);
		prodProductDescriptionService.saveOrUpdateDoublePlaceForProductDesForCustomized(productDetailDesc);
	}

	/**
	 * 设置传递给页面的信息
	 * @param model 页面模型对象
	 * @param isNewAddProduct 是否是新增加产品
	 */
	private void setModelAtrributes(Model model) {
		try{
		//1. 获取产品类型
		List<ProdProduct.PRODUCTTYPE> productTypeList = new ArrayList<ProdProduct.PRODUCTTYPE>(Arrays.asList(ProdProduct.PRODUCTTYPE.values()));
		// 过滤掉 国内、快递,押金项
		productTypeList.remove(ProdProduct.PRODUCTTYPE.INNERLINE);
		productTypeList.remove(ProdProduct.PRODUCTTYPE.EXPRESS);
		productTypeList.remove(ProdProduct.PRODUCTTYPE.DEPOSIT);
		productTypeList.remove(ProdProduct.PRODUCTTYPE.INNER_BORDER_LINE);
		model.addAttribute("productTypes", productTypeList);

		//2. 获取跟团类型（半自助， 跟团游）
		model.addAttribute("groupTypes", ProdLineBasicInfo.GROUP_TYPE.values());

		//3. 下单必填项{游玩人信息}
		model.addAttribute("travNumTypeList", BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.values());

		model.addAttribute("copiesList", ProdProductSaleRe.COPIES.values());

		//4. 打包类型
		model.addAttribute("packageTypeList", ProdProduct.PACKAGETYPE.values());

		//5. 分公司
		model.addAttribute("filiales", CommEnumSet.FILIALE_NAME.values());

		//6. 销售渠道
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("cancelFlag", "Y");
		List<Distributor> distributors = distributorService.findDistributorList(params).getReturnContent();
		model.addAttribute("distributorList", distributors);

		//7. 加载分销渠道的分销商
		ResultHandleT<TntGoodsChannelVo> tntGoodsChannelVoRt = tntGoodsChannelCouponServiceRemote.getChannels(TntGoodsChannelCouponAdapter.CH_TYPE.NONE.name());
		if(tntGoodsChannelVoRt != null && tntGoodsChannelVoRt.getReturnContent() != null){
			TntGoodsChannelVo tntGoodsChannelVo = (TntGoodsChannelVo)tntGoodsChannelVoRt.getReturnContent();
			model.addAttribute("tntGoodsChannelVo", tntGoodsChannelVo);
		}

			
		}catch(Exception e){
			throw new BusinessException(e.getMessage());
		}
		
		
		
	}

	/**
	 * 获取修改基本产品信息原始对象
	 */
	public ProdProduct getOldProdProuductByProductIdForLog(Long productId, ComOrderRequired comOrderRequired){

		//获取原来产品对象
		ProdProductParam productParam = new ProdProductParam();
		productParam.setBizCategory(true);
		productParam.setBizDistrict(true);
		ProdProduct oldProduct = prodProductService.findProdProductById(productId, productParam);

		if (oldProduct == null) {
			return null;
		}

		//基础参数
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productId", productId);

		//1. 关联目的地数据
		List<ProdDestRe> prodDestReList = prodDestReService.findProdDestReByParams(params);
		oldProduct.setProdDestReList(prodDestReList);

		//2. 关联的销售渠道信息
		try {
			List<DistDistributorProd> distDistributorList = MiscUtils.autoUnboxing(prodDistributorService.findDistDistributorProdByParams(params));
			oldProduct.setDistDistributorProds(distDistributorList);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		//3. 电子合同
		ProdEcontract econtract = prodEcontractService.selectByProductId(productId);
		oldProduct.setProdEcontract(econtract);

		//4. 下单必填项
		if(comOrderRequired != null && comOrderRequired.getReqId() != null){
			ComOrderRequired oldComOrderRequirede = comOrderRequiredService.findComOrderRequiredById(comOrderRequired.getReqId());
			oldProduct.setComOrderRequired(oldComOrderRequirede);
		}

		//5. 线路产品的基础信息
		List<ProdLineBasicInfo> lineBasicInfoList = MiscUtils.autoUnboxing(prodLineBasicInfoService.findBasicInfoListByParams(params));
		ProdLineBasicInfo lineBasicInfo = new ProdLineBasicInfo();
		if (CollectionUtils.isNotEmpty(lineBasicInfoList)) {
			lineBasicInfo = lineBasicInfoList.get(0);
		}
		oldProduct.setProdLineBasicInfo(lineBasicInfo);

		return oldProduct;
	}


	// 校验签证材料
	private String checkvisaDoc(Long productId) throws BusinessException {
		String visaDocFlag = "true";
		// 签证材料是否存在
		Map<String, Object> pars = new HashMap<String, Object>();
		List<ProdLineRoute> prodRouteList = checkRoute(productId);
		if (prodRouteList == null || prodRouteList.size() <= 0) {
			visaDocFlag = "false";
		}
		for (ProdLineRoute pr : prodRouteList) {
			pars.put("lineRouteId", pr.getLineRouteId());
			List<ProdVisadocRe> visadocList = prodVisadocReService.findProdVisadocReByParams(pars);
			if (visadocList == null || visadocList.size() <= 0) {
				visaDocFlag = "false";
				break;
			}
		}
		return visaDocFlag;
	}

	// 行程明细校验
	private String checkRouteDetail(Long productId) throws BusinessException {
		String saveRouteFlag = "true";
		List<ProdLineRoute> prodRouteList = checkRoute(productId);
		if (prodRouteList == null || prodRouteList.size() <= 0) {
			saveRouteFlag = "false";
		}
		for (ProdLineRoute pr : prodRouteList) {
			List<ProdLineRouteDetail> routeDetailList = prodLineRouteDetailService.selectByProdLineRouteId(pr.getLineRouteId());
			if (routeDetailList == null || routeDetailList.size() <= 0) {
				saveRouteFlag = "false";
				break;
			}
		}
		return saveRouteFlag;
	}

	// 行程校验
	private List<ProdLineRoute> checkRoute(Long productId) throws BusinessException {
		Map<String, Object> pars = new HashMap<String, Object>();
		pars.put("productId", productId);
		pars.put("cancleFlag", "Y");
		List<ProdLineRoute> prodRouteList = prodLineRouteService.findProdLineRouteByParams(pars);
		return prodRouteList;
	}

	/**
	 * 获取 产品 修改日志文本
	 */
	private String getProdProductLog(ProdProduct prodProduct,ProdProduct oldProduct,String[] distributorIds, String distributorUserIds,ComOrderRequired comOrderRequired) {
		if(prodProduct == null){
			return StringUtils.EMPTY;
		}

		//获取目的地地址
		List<String> destList = new ArrayList<String>();
		for(ProdDestRe dest : oldProduct.getProdDestReList()){
			destList.add(dest.getDestName());
		}
		String districtName = "";
		if(oldProduct.getBizDistrict()!=null){
			districtName = oldProduct.getBizDistrict().getDistrictName();
		}
		String[] newDestValues = prodProduct.getDest(); 
		List<String> newDestvalue = new ArrayList<String>();
		for(String newDest : newDestValues ){
			if(newDest.contains("[")) {
				String dest = newDest.substring(0, newDest.lastIndexOf("["));
				newDestvalue.add(dest);
			}
		}

		StringBuilder sb = new StringBuilder();
		sb.append(getChangeLog("产品名称", oldProduct.getProductName(), prodProduct.getProductName()));
		sb.append(getChangeLog("供应商产品名称", oldProduct.getSuppProductName(), prodProduct.getSuppProductName()));
		sb.append(getChangeLog("是否有效","Y".equals(oldProduct.getCancelFlag())?"是":"否","Y".equals(prodProduct.getCancelFlag())?"是":"否"));
		sb.append(getChangeLog("推荐级别", String.valueOf(oldProduct.getRecommendLevel()), String.valueOf(prodProduct.getRecommendLevel())));
		sb.append(getChangeLog("类别","INNERLINE".equals(oldProduct.getProductType())?"国内":"出境/港澳台" , "INNERLINE".equals(prodProduct.getProductType())?"国内":"出境/港澳台"));
		sb.append(getChangeLog("打包类型", "LVMAMA".equals(oldProduct.getPackageType())?"自主打包":"供应商打包", "LVMAMA".equals(prodProduct.getPackageType())?"自主打包":"供应商打包"));
		sb.append(getChangeLog("所属分公司", CommEnumSet.FILIALE_NAME.getCnName(oldProduct.getFiliale()), CommEnumSet.FILIALE_NAME.getCnName(prodProduct.getFiliale())));
		sb.append(getProdLineBasicInfoLog(prodProduct,oldProduct));
		sb.append((StringUtils.isBlank(districtName) || StringUtils.isBlank(prodProduct.getDistrict())) ? "" : getChangeLog("出发地", districtName, prodProduct.getDistrict()));
		sb.append(getChangeLog("目的地", destList.toString(),newDestvalue.toString()));
		sb.append(getDistributorLog(distributorIds,distributorUserIds,oldProduct));
		sb.append(getReservationLimitLog(comOrderRequired,oldProduct));
		String oldEcontract = StringUtils.EMPTY;
		if(oldProduct.getProdEcontract() != null){
			String oldEcontractTemplate = oldProduct.getProdEcontract().getEcontractTemplate();
			oldEcontract = StringUtils.isEmpty(oldEcontractTemplate)?"自动调取":ProdEcontract.ELECTRONIC_CONTRACT_TEMPLATE.getCnName(oldEcontractTemplate);
		}else{
			oldEcontract = "自动调取";
		}

		String newEcontract = prodProduct.getProdEcontract().getEcontractTemplate();
		sb.append(getChangeLog("电子合同", oldEcontract, StringUtils.isEmpty(newEcontract)?"自动调取":ProdEcontract.ELECTRONIC_CONTRACT_TEMPLATE.getCnName(newEcontract)));
		return sb.toString();
	}

	/**
	 * 获取 线路产品基础信息 修改日志文本
	 */
	private Object getProdLineBasicInfoLog(ProdProduct prodProduct, ProdProduct oldProduct) {
		String ret = StringUtils.EMPTY;
		StringBuilder logStr = new StringBuilder();

		ProdLineBasicInfo newLineBasicInfo = prodProduct.getProdLineBasicInfo();
		ProdLineBasicInfo oldLineBasicInfo = oldProduct.getProdLineBasicInfo();

		if(newLineBasicInfo != null && oldLineBasicInfo != null) {
			logStr.append(getChangeLog("是否为大交通", oldLineBasicInfo.getTrafficFlag(), newLineBasicInfo.getTrafficFlag()));
			logStr.append(getChangeLog("跟团类型", ProdLineBasicInfo.GROUP_TYPE.getCnNameByCode(oldLineBasicInfo.getGroupType()), ProdLineBasicInfo.GROUP_TYPE.getCnNameByCode(newLineBasicInfo.getGroupType())));
			logStr.append(getChangeLog("最少成团人数", Long.toString(oldLineBasicInfo.getLeastClusterPerson()), Long.toString(newLineBasicInfo.getLeastClusterPerson())));
			logStr.append(getChangeLog("儿童价标准描述", oldLineBasicInfo.getChildPriceDesc(), newLineBasicInfo.getChildPriceDesc()));
			logStr.append(getChangeLog("地址", oldLineBasicInfo.getAddress(), newLineBasicInfo.getAddress()));
		}

		if(logStr.length() >0){
			ret = "线路产品基础信息:["+logStr.toString()+"]";
		}
		return ret;
	}

	/**
	 * 获取 预订限制 修改日志文本
	 */
	private String getReservationLimitLog(ComOrderRequired comOrderRequired,ProdProduct oldProduct) {
		String ret = StringUtils.EMPTY;
		if(comOrderRequired==null){
			return ret;
		}
		StringBuilder logStr = new StringBuilder();

		ComOrderRequired oldComOrderRequirede = oldProduct.getComOrderRequired();
		if(oldComOrderRequirede != null) {
			if(StringUtils.isNotEmpty(comOrderRequired.getTravNumType())){
				logStr.append(getChangeLog("1笔订单需要的“游玩人/取票人”数量",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(oldComOrderRequirede.getTravNumType()) , BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getTravNumType())));
			}
			if(StringUtils.isNotEmpty(comOrderRequired.getEnnameType())){
				logStr.append(getChangeLog("英文姓名",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(oldComOrderRequirede.getEnnameType()), BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getEnnameType())));
			}
			if(StringUtils.isNotEmpty(comOrderRequired.getOccupType())){
				logStr.append(getChangeLog("人群",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(oldComOrderRequirede.getOccupType()), BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getOccupType())));
			}
			if(StringUtils.isNotEmpty(comOrderRequired.getPhoneType())){
				logStr.append(getChangeLog("手机号",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(oldComOrderRequirede.getPhoneType()), BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getPhoneType())));
			}
			if(StringUtils.isNotEmpty(comOrderRequired.getEmailType())){
				logStr.append(getChangeLog("email",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(oldComOrderRequirede.getEmailType()), BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getEmailType())));
			}
			if(StringUtils.isNotEmpty(comOrderRequired.getCredType())){
				logStr.append(getChangeLog("证件",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(oldComOrderRequirede.getCredType()), BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getCredType())));
			}
			if(logStr.length() >0)
			{
				ret = "预订限制:["+logStr.toString()+"]";
			}

			String documentType = StringUtils.EMPTY;
			String idFlag = getValidLog(comOrderRequired.getIdFlag());
			if(StringUtils.isNotEmpty(idFlag)){
				documentType += getChangeLog("身份证",getValidLog(oldComOrderRequirede.getIdFlag()),idFlag);
			}
			if(StringUtils.isNotEmpty(idFlag)){
				documentType += getChangeLog("护照",getValidLog(oldComOrderRequirede.getPassportFlag()) ,getValidLog(comOrderRequired.getPassportFlag()));
			}
			if(StringUtils.isNotEmpty(idFlag)){
				documentType += getChangeLog("港澳通行证",getValidLog(oldComOrderRequirede.getPassFlag()) ,getValidLog(comOrderRequired.getPassFlag()));
			}
			if(StringUtils.isNotEmpty(idFlag)){
				documentType += getChangeLog("台湾通行证",getValidLog(oldComOrderRequirede.getTwPassFlag()) ,getValidLog(comOrderRequired.getTwPassFlag()));
				documentType += getChangeLog("台胞证",getValidLog(oldComOrderRequirede.getTwResidentFlag()) ,getValidLog(comOrderRequired.getTwResidentFlag()));
				documentType += getChangeLog("出生证明(婴儿)",getValidLog(oldComOrderRequirede.getBirthCertFlag()) ,getValidLog(comOrderRequired.getBirthCertFlag()));
				documentType += getChangeLog("户口簿(儿童)",getValidLog(oldComOrderRequirede.getHouseholdRegFlag()) ,getValidLog(comOrderRequired.getHouseholdRegFlag()));
				documentType += getChangeLog("士兵证",getValidLog(oldComOrderRequirede.getSoldierFlag()) ,getValidLog(comOrderRequired.getSoldierFlag()));
				documentType += getChangeLog("军官证",getValidLog(oldComOrderRequirede.getOfficerFlag()) ,getValidLog(comOrderRequired.getOfficerFlag()));
				documentType += getChangeLog("回乡证(港澳居民)",getValidLog(oldComOrderRequirede.getHkResidentFlag()) ,getValidLog(comOrderRequired.getHkResidentFlag()));
			}
			if(StringUtils.isNotEmpty(documentType)){
				documentType="可用证件类型:["+documentType+"]";
			}
			if(StringUtils.isNotEmpty(ret)){
				ret = ret +",";
			}
			ret += documentType;
		}

		return ret;
	}

	/**
	 * 获取 销售渠道 修改日志文本
	 */

	private String getDistributorLog(String[] distributorIds, String distributorUserIds,ProdProduct oldProduct) {
		String ret = StringUtils.EMPTY;
		//修改之前
		StringBuilder logStr = new StringBuilder();
		try{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("cancelFlag", "Y");
		List<String> distributorNames = new ArrayList<String>();
		List<Distributor> oldistributors = distributorService.findDistributorList(params).getReturnContent();
		for(Distributor distributor :oldistributors){

			for(DistDistributorProd disTributorProd :oldProduct.getDistDistributorProds()){
				if(disTributorProd.getDistributorId().equals(distributor.getDistributorId())){
					distributorNames.add(distributor.getDistributorName());
				}
			}
		}

		//修改中
		if(ArrayUtils.isNotEmpty(distributorIds)){
			List<String> distributors = new ArrayList<String>();
			for(String distributorId : distributorIds){
				Distributor distributor = distributorService.findDistributorById(Long.valueOf(distributorId)).getReturnContent();
				if(distributor!=null){
					distributors.add(distributor.getDistributorName());
				}
			}
			ret = distributors.toString();
		}

		logStr.append(getChangeLog("销售渠道", distributorNames.toString(), ret));
		return logStr.toString();
		}catch(Exception e){
				throw new BusinessException(e.getMessage());
		}
		
	}

	private String getValidLog(String flag){
		if(StringUtils.isEmpty(flag)){
			return StringUtils.EMPTY;
		}
		return "Y".equals(flag)?"可用":"不可用";
	}

	private String getChangeLog(String columnName, String oldStr, String newStr){
		String temp = "";

		if(oldStr ==null && newStr == null){
			return temp;
		}else if(oldStr ==null ||newStr ==null ){
			temp = ComLogUtil.getLogTxt(columnName,newStr,oldStr);
			return temp;
		}else{
			if(!oldStr.equals(newStr)){
				temp = ComLogUtil.getLogTxt(columnName,newStr,oldStr)+",";
				return temp;
			}
		}

		return "";
	}
	
	 private String getProdProductPropLog(ProdProduct prodProduct, ProdProduct oldProdProduct) {
	        StringBuilder ret = new StringBuilder();
	        if (prodProduct == null) {
	            return StringUtils.EMPTY;
	        }
	        List<Long> propPropIds = new ArrayList<Long>();
	        for (ProdProductProp props : oldProdProduct.getProdProductPropList()) {

	            propPropIds.add(props.getProdPropId());
	        }

	        for (ProdProductProp prop : prodProduct.getProdProductPropList()) {
	            if (!propPropIds.contains(prop.getProdPropId())) {

	                BizCategoryProp bizCategoryProp = categoryPropService.findCategoryPropById(prop.getPropId());
	                if ("INPUT_TYPE_RICH".equalsIgnoreCase(bizCategoryProp.getInputType())) {

	                    String temp = "";
	                    temp = getChangeLog(bizCategoryProp.getPropName(), "", prop.getPropValue());
	                    if (StringUtils.isNotBlank(temp)) {
	                        temp = "修改了" + bizCategoryProp.getPropName() + ",";
	                    }
	                    ret.append(temp);

	                } else {
	                    ret.append(getChangeLog(bizCategoryProp.getPropName(), "", prop.getPropValue()));
	                }
	                continue;
	            }
	            for (ProdProductProp prop2 : oldProdProduct.getProdProductPropList()) {

	                if (prop.getProdPropId().equals(prop2.getProdPropId())) {

	                    BizCategoryProp bizCategoryProp = categoryPropService.findCategoryPropById(prop.getPropId());
	                    if ("traffic_flag".equalsIgnoreCase(bizCategoryProp.getPropCode())) {

	                        ret.append(getChangeLog(bizCategoryProp.getPropName(), prop2.getPropValue().equals("Y") ? "是"
	                                : "否", prop.getPropValue().equals("Y") ? "是" : "否"));

	                    } else if ("combo_contained".equalsIgnoreCase(bizCategoryProp.getPropCode())) {

	                        ret.append(getChangeLog("套餐包含", getPackageContent(prop2).toString(), getPackageContent(prop)
	                                .toString()));

	                    } else if ("contained_item".equalsIgnoreCase(bizCategoryProp.getPropCode())) {
	                        String ss = prop2.getPropValue();
	                        String[] oldstrs = ss.split(",");
	                        List<String> str1 = new ArrayList<String>();
	                        for (String s : oldstrs) {
	                            str1.add(getDictName(s));
	                        }

	                        String[] newstrs = prop.getPropValue().split(",");
	                        List<String> str2 = new ArrayList<String>();
	                        for (String s : newstrs) {
	                            str2.add(getDictName(s));
	                        }

	                        ret.append(getChangeLog(bizCategoryProp.getPropName(), str1.toString(), str2.toString()));

	                    } else {
	                        if ("INPUT_TYPE_RICH".equalsIgnoreCase(bizCategoryProp.getInputType())) {

	                            String temp = "";
	                            temp = getChangeLog(bizCategoryProp.getPropName(), prop2.getPropValue(),
	                                    prop.getPropValue());
	                            if (StringUtils.isNotBlank(temp)) {
	                                temp = "修改了" + bizCategoryProp.getPropName() + ",";
	                            }
	                            ret.append(temp);

	                        } else {
	                            ret.append(getChangeLog(bizCategoryProp.getPropName(), prop2.getPropValue(),
	                                    prop.getPropValue()));
	                        }

	                    }

	                }

	            }

	        }
	        return ret.toString();
	    }
	 
	 private List<String> getPackageContent(ProdProductProp prodProductProp) {
	        if(prodProductProp==null){
	            return Collections.emptyList();
	        }
	        String contents = prodProductProp.getPropValue();
	        if(StringUtils.isEmpty(contents)){
	            return Collections.emptyList();
	        }
	        List<String> ret = new ArrayList<String>();
	        for(String dictId : contents.split(",")){
	            BizDict bizDict = bizDictQueryService.selectByPrimaryKey(Long.valueOf(dictId));
	            ret.add(bizDict.getDictName());
	        }
	        return ret;
	    }
	 
	 private String getDictName(String defId){
			String dictname = "";
			if(StringUtil.isNotEmptyString(defId)){
				
				
				BizDict bizdict = bizDictQueryService.selectByPrimaryKey(Long.parseLong(defId));
				if(bizdict!=null){
					dictname = bizdict.getDictName();
					if(StringUtils.isNotBlank(dictname)){
						return dictname;
					}
				}
				
				
				}
				
			return "";	
		}
}
