package com.lvmama.vst.back.dujia.group.prod.web;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.alibaba.fastjson.JSON;
import com.lvmama.vst.back.biz.po.BizDistrict;
import com.lvmama.vst.back.prod.po.ProdStartDistrictDetail;
import com.lvmama.vst.back.client.prod.service.ProdPackageDetailClientService;
import com.lvmama.vst.back.prod.service.ProdStartDistrictDetailService;
import com.lvmama.vst.comm.utils.MemcachedUtil;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;
import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.comm.tnt.po.TntGoodsChannelVo;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.po.BizCategoryProp;
import com.lvmama.vst.back.biz.po.BizDest;
import com.lvmama.vst.back.biz.po.BizDestTravelAlert;
import com.lvmama.vst.back.biz.po.BizDict;
import com.lvmama.vst.back.biz.po.BizEnum;
import com.lvmama.vst.back.biz.po.BizOrderRequired;
import com.lvmama.vst.back.biz.po.BizReserveLimit;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.biz.service.BizDictQueryService;
import com.lvmama.vst.back.biz.service.BizReserveLimitService;
import com.lvmama.vst.back.client.biz.service.BizDestTravelAlertClientService;
import com.lvmama.vst.back.client.biz.service.BizOrderRequiredClientService;
import com.lvmama.vst.back.client.biz.service.CategoryPropClientService;
import com.lvmama.vst.back.client.biz.service.DestClientService;
import com.lvmama.vst.back.client.dist.service.DistDistributorProdClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.prod.service.ProdDestReClientService;
import com.lvmama.vst.back.client.prod.service.ProdEcontractClientService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteClientService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteDetailClientService;
import com.lvmama.vst.back.client.prod.service.ProdPackageDetailClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductPropClientService;
import com.lvmama.vst.back.client.prod.service.ProdRouteFeatureClientService;
import com.lvmama.vst.back.client.prod.service.ProdTrafficClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.pub.service.ComOrderRequiredClientService;
import com.lvmama.vst.back.client.supp.service.SuppSupplierClientService;
import com.lvmama.vst.back.dist.po.DistDistributorProd;
import com.lvmama.vst.back.dist.po.Distributor;
import com.lvmama.vst.back.dist.service.DistributorCachedService;
import com.lvmama.vst.back.dujia.client.comm.prod.service.ProdLineBasicInfoClientService;
import com.lvmama.vst.back.dujia.client.comm.prod.service.ProdProductDescriptionClientService;
import com.lvmama.vst.back.dujia.comm.prod.po.ProdLineBasicInfo;
import com.lvmama.vst.back.dujia.comm.prod.po.ProdProductDescription;
import com.lvmama.vst.back.dujia.comm.route.po.ProdRouteFeature;
import com.lvmama.vst.back.dujia.group.prod.vo.ProdProductNameVO;
import com.lvmama.vst.back.dujia.group.prod.vo.RefundExplainInnerVO;
import com.lvmama.vst.back.dujia.group.prod.vo.RefundExplainOutsideVO;
import com.lvmama.vst.back.dujia.group.prod.vo.TravelAlertInnerSelfTourVO;
import com.lvmama.vst.back.dujia.group.prod.vo.TravelAlertInnerVO;
import com.lvmama.vst.back.dujia.group.prod.vo.TravelAlertOutsideVO;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.goods.vo.ProdProductParam;
import com.lvmama.vst.back.prod.po.ProdDestRe;
import com.lvmama.vst.back.prod.po.ProdEcontract;
import com.lvmama.vst.back.prod.po.ProdGroup;
import com.lvmama.vst.back.prod.po.ProdLineRoute;
import com.lvmama.vst.back.prod.po.ProdLineRouteDetail;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductAssociation;
import com.lvmama.vst.back.prod.po.ProdProductProp;
import com.lvmama.vst.back.prod.po.ProdProductSaleRe;
import com.lvmama.vst.back.prod.po.ProdReserveLimit;
import com.lvmama.vst.back.prod.po.ProdVisadocRe;
import com.lvmama.vst.back.prod.service.AssociationRecommendService;
import com.lvmama.vst.back.prod.service.ProdGroupService;
import com.lvmama.vst.back.prod.service.ProdProductAssociationService;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.prod.service.ProdProductServiceAdapter;
import com.lvmama.vst.back.prod.service.ProdVisadocReService;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.pub.po.ComOrderRequired;
import com.lvmama.vst.back.pub.service.PushAdapterService;
import com.lvmama.vst.back.supp.po.SuppSupplier;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.back.utils.TimeLog;
import com.lvmama.vst.comm.enumeration.CommEnumSet;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.MemcachedEnum;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;
import com.lvmama.vst.pet.adapter.TntGoodsChannelCouponAdapter;

@Controller
@RequestMapping("/dujia/group/product")
public class GroupProductAction extends BaseActionSupport {

	private static final long serialVersionUID = 3636755752901703434L;
	private static final Log LOG = LogFactory.getLog(GroupProductAction.class);
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
	private PermUserServiceAdapter permUserServiceAdapter;

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
	private CategoryPropClientService categoryPropService;
	
	@Autowired
	private BizDictQueryService bizDictQueryService;
	
	@Autowired
	private AssociationRecommendService associationRecommendService;
	
	@Autowired
	private DestClientService destService;
	
	@Autowired
	private ProdGroupService prodGroupService;
	
	@Autowired
	private ProdProductPropClientService prodProductPropService;
	
	@Autowired
	private ProdProductAssociationService prodProductAssociationService;
	
	@Autowired
	private SuppGoodsClientService suppGoodsService;

	@Autowired
	private SuppSupplierClientService suppSupplierService;
	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;

	@Autowired
	private BizDestTravelAlertClientService bizDestTravelAlertService;
	@Autowired
	private ProdStartDistrictDetailService prodStartDistrictDetailService;
	@Autowired
	private ProdPackageDetailClientService prodPackageDetailService;
	
	@Autowired
	private BizReserveLimitService bizReserveLimitService;
	
	private static final String PROD_GROUP_MAX_SIZE ="prodGroupMaxSize";
	private static final String PROD_GROUP_MESSAGE_EXISTS ="维护产品已被其它产品进行关联,请先取消";
	
	/**
	 * 产品关联
	 */
	@RequestMapping(value = "/findProdGroupList")
	public String findProdGroupList(Model model ,Long prodProductId, Long categoryId){
		LOG.info("ProdGroupAction.findProdGroupList start...");
		//是否能选择关联产品
		boolean isProductSelect =true;
		String errorMsg ="";
		try{
			TimeLog timeLog = new TimeLog(LOG);
			List<ProdGroup> prodGroupList = prodGroupService.selectInfoByProductId(prodProductId, true);
			timeLog.logWrite("findProdGroupList.selectByProductId()", "size="+ prodGroupList.size());
			for(ProdGroup prodGroup : prodGroupList){
				if(StringUtil.isNotEmptyString(prodGroup.getToTraffic())){
					prodGroup.setToTraffic(Constant.LINE_TRAFFIC.getCnName(prodGroup.getToTraffic()));
				}
				if(StringUtil.isNotEmptyString(prodGroup.getBackTraffic())){
					prodGroup.setBackTraffic(Constant.LINE_TRAFFIC.getCnName(prodGroup.getBackTraffic()));
				}
			}
			
			int maxSize =getNewProdGroupMaxSize();

			if(prodGroupList.size() >0 && prodGroupList.size() <maxSize){
//				if(!isEqual(prodGroupList.get(0).getGroupId(), prodProductId)){
//					isProductSelect =false;
//					errorMsg =PROD_GROUP_MESSAGE_EXISTS;
//				}
			}else if(prodGroupList.size() >= maxSize){
				errorMsg ="最多关联产品数目为" +maxSize;
				isProductSelect =false;
			}
			model.addAttribute("maxSize", maxSize -prodGroupList.size());
			model.addAttribute("prodProductId", prodProductId);
			model.addAttribute("categoryId", categoryId);
			model.addAttribute("prodGroupList", prodGroupList);
		}catch(Exception e){
			isProductSelect =false;
			errorMsg =e.getMessage();
			LOG.error(ExceptionFormatUtil.getTrace(e));
		}
		model.addAttribute("isProductSelect", isProductSelect);
		model.addAttribute("errorMsg", errorMsg);
		return "/dujia/group/prod/findProdGroupList";
	}

	@Autowired
	private ProdRouteFeatureClientService prodRouteFeatureService;
	
	private static final short PROD_GROUP_MAX_SUM =10;

	/**
	 * 获取关联产品的最大数目
	 * @return int
	 */
	private static int getNewProdGroupMaxSize(){
		Short size =PROD_GROUP_MAX_SUM;
		Assert.notNull(size, PROD_GROUP_MAX_SIZE +" not is null");
		return Integer.valueOf(size);
	}
	/**
	 * 关联产品查询页面
	 */
	@RequestMapping(value = "/showSelectReProductList")
	public String showSelectReProductList(Model model,Long prodProductId, Long categoryId){
		model.addAttribute("prodProductId", prodProductId);
		model.addAttribute("categoryId", categoryId);
		return "/dujia/group/prod/showSelectReProductList";
	}
	
	private boolean isEqual(Long long1, Long long2){
		return long1.intValue() == long2.intValue();
	}
	
	

	
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
			model.addAttribute("productBu", prodProduct.getBu());
			
			String bu = associationRecommendService
					.getBuOfProduct(productId, prodProduct.getBu(), categoryId,
							prodProduct.getPackageType());
			model.addAttribute("bu", bu);
			
			try {
				//判断是出境 跟团游 modelVersion不是1.0 编辑时设为无效
				if (isOutGroupAndunVersion(prodProduct)) {
					prodProduct.setCancelFlag("N");
					prodProductService.updateCancelFlag(prodProduct);
					prodProductServiceAdapter.convertDataOldToNew(productId);
				}
			} catch (Exception e) {
				LOG.error(ExceptionFormatUtil.getTrace(e));
			}
			
		} else {
			model.addAttribute("productName", null);
		}
		return "/dujia/group/prod/showProductMaintain";
	}
	
	/**
	 * 判断是出境 跟团游 modelVersion不是1.0 
	 * @param prodProduct
	 * @return boolean
	 * */
	private boolean  isOutGroupAndunVersion(ProdProduct  prodProduct){
		if ((prodProduct.getModelVersion() == null || prodProduct.getModelVersion().doubleValue() < 1.0)
				&& Long.valueOf(15L).equals(prodProduct.getBizCategoryId())
				&& ProdProduct.PRODUCTTYPE.FOREIGNLINE.getCode().equals(prodProduct.getProductType())) {
			return Boolean.TRUE;
		}
		return Boolean.FALSE;
	}
	
	/**
	 * 根据id获取所属品类
	 * @param categoryId
	 * @return
	 */
	private BizCategory getBizCategoryById(long categoryId) {	
		if (categoryId != 0) {
			return bizCategoryQueryService.getCategoryById(categoryId);
		}
		return  null;
	}
	
	/**
	 * 渲染 新增产品 页面 
	 */
	@RequestMapping(value = "/showAddProduct")
	public String showAddProduct(Model model, HttpServletRequest req) {
		ProdProduct prodProduct = new ProdProduct();
		String categoryId = req.getParameter("categoryId");
		if (categoryId != null) {
			prodProduct.setBizCategoryId(Long.parseLong(categoryId));
		}
		this.setModelAtrributes(model,prodProduct);
		model.addAttribute("categoryId", categoryId);

		model.addAttribute("bizCategory", this.getBizCategoryById(Long.valueOf(req.getParameter("categoryId"))));
		return "/dujia/group/prod/showAddProduct";
	}

	/**
	 * 渲染 产品修改页面
	 */
	@RequestMapping(value = "/showUpdateProduct")
	public String showUpdateProduct(Model model, long productId, HttpServletRequest req) {
		if (productId <= 0) {
			return "/dujia/group/prod/showUpdateProduct";
		}

		//1. 抓取产品基础信息
		ProdProductParam productParam = new ProdProductParam();
		productParam.setBizCategory(true);
		productParam.setBizDistrict(true);
		ProdProduct prodProduct = prodProductService.findProdProductById(productId, productParam);
		if (prodProduct == null) {
			return "/dujia/group/prod/showUpdateProduct";
		}
		
		PermUser permUser = permUserServiceAdapter.getPermUserByUserId(prodProduct.getManagerId());
		if(permUser != null) {
			prodProduct.setManagerName(permUser.getRealName());
		}

		//所属品类
		model.addAttribute("bizCategory", this.getBizCategoryById(prodProduct.getBizCategoryId()));
				
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
		List<ProdLineBasicInfo> lineBasicInfoList = MiscUtils.autoUnboxing( prodLineBasicInfoService.findBasicInfoListByParams(lineBasicInfoParam) );

		ProdLineBasicInfo lineBasicInfo = new ProdLineBasicInfo();
		if (CollectionUtils.isNotEmpty(lineBasicInfoList)) {
			lineBasicInfo = lineBasicInfoList.get(0);
		}
		model.addAttribute("prodLineBasicInfo", lineBasicInfo);

		//3. 线路产品描述信息（产品名称、产品推荐、产品详情）
		Map<String,Object> productNameParam = new HashMap<String, Object>();
		productNameParam.put("productId", productId);
		productNameParam.put("productType", prodProduct.getProductType());
		List<ProdProductDescription> productDescriptionList = 
				MiscUtils.autoUnboxing( prodProductDescriptionService.findProductDescriptionListByParams(productNameParam) );

		//接收产品名称
		ProdProductNameVO productNameVo = new ProdProductNameVO();
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
					productNameVo = JSONObject.parseObject(content, ProdProductNameVO.class);
				} else if (ProdProductDescription.CONTENT_TYPE.PRODUCT_RECOMMEND.name().equals(contentType)) {
					productRecommends = content.split("<br/>");
				} else if (ProdProductDescription.CONTENT_TYPE.PRODUCT_DETAIL.name().equals(contentType)) {
					productDetail = content;
				}
			}
		}
		model.addAttribute("prodProductNameVo", productNameVo);
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
		
		//获取选择的类型:：开心驴行，驴悦亲子
		Map<String,Object> param = new HashMap<String, Object>();
		param.put("productId", productId);
		param.put("propId", 575L);
		List<ProdProductProp> prodProductPropList = MiscUtils.autoUnboxing( prodProductPropService.findProdProductPropList(param) );
		if (CollectionUtils.isNotEmpty(prodProductPropList)) {
			model.addAttribute("prodProductProp", prodProductPropList.get(0));
		}
		findsuppSupplierName(model, productId);
		//7. 设置model的一些基础信息
		this.setModelAtrributes(model,prodProduct);
		
		if("Y".equals(prodProduct.getIsMuiltDeparture())){
			//得到供应商打包多出发地的数据
			List<BizDistrict> bizDistricts = prodPackageDetailService.findDistrictList(prodProduct.getProductId());
			if(CollectionUtils.isNotEmpty(bizDistricts)) {
				model.addAttribute("startDistricts", JSON.toJSONString(bizDistricts));
			}
		}
		return "/dujia/group/prod/showUpdateProduct";
	}

	
	private void findsuppSupplierName(Model model,long productId){
		//提前获取产品供应商或上级供应商名称以便修改组团方式时及时取值
		SuppGoods suppGoods = suppGoodsService.findBaseSuppGoodsByProductId(productId);
		if(suppGoods!=null){
			SuppSupplier suppSupplier = MiscUtils.autoUnboxing( suppSupplierService.findSuppSupplierById(suppGoods.getSupplierId()) );
			if(suppSupplier!=null){
				if("2".equals(suppSupplier.getSupplierLevelType())){
					if(suppSupplier.getFatherId()!=null&&suppSupplier.getFatherId()!=0L){
						suppSupplier= MiscUtils.autoUnboxing( suppSupplierService.findSuppSupplierById(suppSupplier.getFatherId()) );
						model.addAttribute("groupSupplierName", suppSupplier.getSupplierName());
					}else{
						model.addAttribute("groupSupplierName", suppSupplier.getSupplierName());
					}
				}else{//不是子供应商，供应商名称
						model.addAttribute("groupSupplierName", suppSupplier.getSupplierName());
				}
			}
		}
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
		// 默认打开出游人后置开关(包括出境)
		if(BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCategoryId().equals(prodProduct.getBizCategoryId()) && ProdProduct.PRODUCTTYPE.FOREIGNLINE.name().equals(prodProduct.getProductType())){
			prodProduct.setTravellerDelayFlag("Y");
		}
		long productId = prodProductServiceAdapter.saveProdProduct(prodProduct);
		prodProduct.setProductId(productId);

		if (productId <= 0) {
			return new ResultMessage(ResultMessage.ERROR, "添加产品失败");
		}

		//1. 保存产品关联数据
		prodProductServiceAdapter.saveProdProductReData(prodProduct);

		//2. 双写 线路产品基础数据、产品名称、产品推荐、产品详情 等信息
		//此处双写 产品名称 结构化信息
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
		//供应商打包，15多出发地入库(总产子销)
		Long categoryId = prodProduct.getBizCategoryId();
		Long subCategoryId = prodProduct.getSubCategoryId();
		String multiToStartPointIds = req.getParameter("multiToStartPointIds");
		if("SUPPLIER".equals(prodProduct.getPackageType())&&"FOREIGNLINE".equals(prodProduct.getProductType())
				&&(BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCategoryId().equals(categoryId) ||
				(BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCategoryId().equals(categoryId)&&(Long.valueOf(181).equals(subCategoryId)||Long.valueOf(182).equals(subCategoryId)||Long.valueOf(183).equals(subCategoryId))))){
			//删除老的行程
			prodStartDistrictDetailService.deleteStartDistrictDetailByProductId(productId);
			String key = ProdPackageDetailClientService.class.getSimpleName() + "->startDistrictFor->" + prodProduct.getProductId();
			MemcachedUtil.getInstance().remove(key);
			if("Y".equals(prodProduct.getIsMuiltDeparture())&&StringUtils.isNotBlank(multiToStartPointIds)){
				//插入新的行程
				List<ProdStartDistrictDetail> startDistrictDetailList = new ArrayList<ProdStartDistrictDetail>();
				String[] strArry = multiToStartPointIds.split(",");
				for(String idStr:strArry){
					Long startDistrictId = Long.valueOf(idStr);
					ProdStartDistrictDetail prodStartDistrictDetail = new ProdStartDistrictDetail();
					prodStartDistrictDetail.setStartDistrictId(startDistrictId);
					prodStartDistrictDetail.setProductId(productId);
					startDistrictDetailList.add(prodStartDistrictDetail);
				}
				prodStartDistrictDetailService.saveBatchStartDistrictDetailList(startDistrictDetailList);
			}
		}
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
		//总产子销
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
		if (StringUtil.isEmptyString(prodProduct.getIsMuiltDeparture())) {
			prodProduct.setIsMuiltDeparture("N");
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
		if(prodProduct.getProdEcontract() != null){
			prodEcontractService.saveOrUpdate(prodProduct.getProdEcontract());
		}
		

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
		//供应商打包，15多出发地入库(总产子销)
		Long categoryId = prodProduct.getBizCategoryId();
		Long subCategoryId = prodProduct.getSubCategoryId();
		String multiToStartPointIds = req.getParameter("multiToStartPointIds");
		if("SUPPLIER".equals(prodProduct.getPackageType())&&"FOREIGNLINE".equals(prodProduct.getProductType())
				&&(BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCategoryId().equals(categoryId) ||
				(BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCategoryId().equals(categoryId)&&(Long.valueOf(181).equals(subCategoryId)||Long.valueOf(182).equals(subCategoryId)||Long.valueOf(183).equals(subCategoryId))))){
			//删除老的行程
			prodStartDistrictDetailService.deleteStartDistrictDetailByProductId(prodProduct.getProductId());
			if("Y".equals(prodProduct.getIsMuiltDeparture())&&StringUtils.isNotBlank(multiToStartPointIds)){
				//插入新的行程
				List<ProdStartDistrictDetail> startDistrictDetailList = new ArrayList<ProdStartDistrictDetail>();
				String[] strArry = multiToStartPointIds.split(",");
				for(String idStr:strArry){
					Long startDistrictId = Long.valueOf(idStr);
					ProdStartDistrictDetail prodStartDistrictDetail = new ProdStartDistrictDetail();
					prodStartDistrictDetail.setStartDistrictId(startDistrictId);
					prodStartDistrictDetail.setProductId(prodProduct.getProductId());
					startDistrictDetailList.add(prodStartDistrictDetail);
				}
				prodStartDistrictDetailService.saveBatchStartDistrictDetailList(startDistrictDetailList);
			}
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
		prodLineBasicInfoService.saveOrUpdateDoublePlaceBasicInfo(lineBasicInfo);

		//2. 保存跟团游的产品名称
		ProdProductDescription productNameDesc = new ProdProductDescription();
		productNameDesc.setCategoryId(prodProduct.getBizCategoryId());
		productNameDesc.setProductId(prodProduct.getProductId());
		productNameDesc.setProductType(prodProduct.getProductType());
		productNameDesc.setContentType(ProdProductDescription.CONTENT_TYPE.PRODUCT_NAME.name());
		//产品名称 结构化信息 保存
		if (prodProduct.getProdProductNameVO() != null) {
			String jsonStr = JSONObject.toJSONString(prodProduct.getProdProductNameVO());
			productNameDesc.setContent(jsonStr);
		}
		prodProductDescriptionService.saveOrUpdateDoublePlaceForProductDes(productNameDesc);

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
		prodProductDescriptionService.saveOrUpdateDoublePlaceForProductDes(productRecommendDesc);

	}

	/**
	 * 设置传递给页面的信息
	 * @param model 页面模型对象
	 * @param isNewAddProduct 是否是新增加产品
	 */
	private void setModelAtrributes(Model model,ProdProduct prodProduct) {
		//1. 获取产品类型
		List<ProdProduct.PRODUCTTYPE> productTypeList = new ArrayList<ProdProduct.PRODUCTTYPE>(Arrays.asList(ProdProduct.PRODUCTTYPE.values()));
		// 过滤掉 国内、快递,押金项
		productTypeList.remove(ProdProduct.PRODUCTTYPE.INNERLINE);
		productTypeList.remove(ProdProduct.PRODUCTTYPE.EXPRESS);
		productTypeList.remove(ProdProduct.PRODUCTTYPE.DEPOSIT);
		
		//排序，国内边境游和国内其他排在一起
		productTypeList.remove(ProdProduct.PRODUCTTYPE.INNER_BORDER_LINE);
		int index = productTypeList.indexOf(ProdProduct.PRODUCTTYPE.FOREIGNLINE);
		productTypeList.add(index, ProdProduct.PRODUCTTYPE.INNER_BORDER_LINE);
		
		model.addAttribute("productTypes", productTypeList);
		
		//类型：开心驴行，驴悦亲子
		BizCategoryProp bizCategoryProp = categoryPropService.findCategoryPropById(575L);
	    model.addAttribute("bizCategoryProp", bizCategoryProp);
	    if (bizCategoryProp != null) {
	        if (StringUtil.isNotEmptyString(bizCategoryProp.getDataFrom())) {
	        	List<BizDict> bizDictList = bizDictQueryService.findDictListByDefId( Long.parseLong(bizCategoryProp.getDataFrom()));
	        	List<BizDict> removeDicts = new ArrayList<BizDict>();
	        	if(bizDictList !=null && bizDictList.size()> 0){
	        		//如果不是 自由行—景+酒产品  则前台不显示"驴色飞扬自驾"和"逍遥驴行"标志
	        		for (BizDict bizDict : bizDictList) {
	        			if("驴色飞扬自驾".equals(bizDict.getDictName()) || "逍遥驴行".equals(bizDict.getDictName())){
	        				removeDicts.add(bizDict);
	        			}
					}
	        		bizDictList.removeAll(removeDicts);
	        		
	        		//非国内跟团游、国内当地游情况下过滤掉私享团类型
	        		boolean selfEnjoyFlag = false;
	        		if (prodProduct!=null && prodProduct.getBizCategoryId()!=null && prodProduct.getProductType()!=null) {//编辑页面判断
	        			if ("15".equals(prodProduct.getBizCategoryId().toString()) || "16".equals(prodProduct.getBizCategoryId().toString())) {
	        				if (ProdProduct.PRODUCTTYPE.INNERLINE.toString().equals(prodProduct.getProductType()) ||
	        						ProdProduct.PRODUCTTYPE.INNERSHORTLINE.toString().equals(prodProduct.getProductType()) ||
	        						ProdProduct.PRODUCTTYPE.INNERLONGLINE.toString().equals(prodProduct.getProductType()) ||
	        						ProdProduct.PRODUCTTYPE.INNER_BORDER_LINE.toString().equals(prodProduct.getProductType())) {
	        					selfEnjoyFlag = true;
	        				}
	        			}
	        		}
	        		if (prodProduct!=null && prodProduct.getBizCategoryId()!=null && prodProduct.getProductType()==null) {//新增页面判断
	        			if ("15".equals(prodProduct.getBizCategoryId().toString())) {
	        				selfEnjoyFlag = true;
	        			}
					}
	        		if (!selfEnjoyFlag) {
		        		for (int i = 0; i < bizDictList.size(); i++) {
		        			BizDict bizDict=bizDictList.get(i);
		        			if("私享团".equals(bizDict.getDictName())){
		        				bizDictList.remove(i);
		        			}
						}
	        		}
        	}
	        	model.addAttribute("bizDictList", bizDictList);
	        }
	    }
		
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
		try{
			List<Distributor> distributors = distributorService.findDistributorList(params).getReturnContent();
			model.addAttribute("distributorList", distributors);
		 } catch (Exception e) {
			 throw new BusinessException(e.getMessage());
	     }
		//7. 加载分销渠道的分销商
		ResultHandleT<TntGoodsChannelVo> tntGoodsChannelVoRt = tntGoodsChannelCouponServiceRemote.getChannels(TntGoodsChannelCouponAdapter.CH_TYPE.NONE.name());
		if(tntGoodsChannelVoRt != null && tntGoodsChannelVoRt.getReturnContent() != null){
			TntGoodsChannelVo tntGoodsChannelVo = (TntGoodsChannelVo)tntGoodsChannelVoRt.getReturnContent();
			model.addAttribute("tntGoodsChannelVo", tntGoodsChannelVo);
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
		List<DistDistributorProd> distDistributorList = null;
		try {
			distDistributorList = MiscUtils.autoUnboxing( distDistributorProdService.findDistDistributorProdByParams(params) );
		} catch (Exception e) {
			LOG.error(e.getMessage(), e);
		}
		oldProduct.setDistDistributorProds(distDistributorList);

		//3. 电子合同
		ProdEcontract econtract = prodEcontractService.selectByProductId(productId);
		oldProduct.setProdEcontract(econtract);

		//4. 下单必填项
		if(comOrderRequired != null && comOrderRequired.getReqId() != null){
			ComOrderRequired oldComOrderRequirede = comOrderRequiredService.findComOrderRequiredById(comOrderRequired.getReqId());
			oldProduct.setComOrderRequired(oldComOrderRequirede);
		}

		//5. 线路产品的基础信息
		List<ProdLineBasicInfo> lineBasicInfoList = MiscUtils.autoUnboxing( prodLineBasicInfoService.findBasicInfoListByParams(params) );
		ProdLineBasicInfo lineBasicInfo = new ProdLineBasicInfo();
		if (CollectionUtils.isNotEmpty(lineBasicInfoList)) {
			lineBasicInfo = lineBasicInfoList.get(0);
		}
		oldProduct.setProdLineBasicInfo(lineBasicInfo);

		return oldProduct;
	}

	/**
	 * 渲染 条款页面
	 */
	@RequestMapping(value = "/showUpdateProductSugg")
	public String showUpdateProductSugg(Model model, Long productId, Long categoryId, HttpServletRequest req) throws BusinessException {
		if (productId == null) {
			throw new BusinessException("系统参数异常：某些必要参数为空");
		}

		// 根据产品id查询产品
		ProdProduct prodProduct = prodProductService.findProdProductByProductId(productId);
		String productType = prodProduct.getProductType();

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productId", productId);
		params.put("productType", productType);
		params.put("contentType", ProdProductDescription.CONTENT_TYPE.TRAVEL_ALERT.name());
		// 查询出行警示
		List<ProdProductDescription> productDescriptionList = MiscUtils.autoUnboxing( productDescriptionService.findProductDescriptionListByParams(params) );

		ProdProductDescription productDescription = new ProdProductDescription();

		TravelAlertOutsideVO travelAlertOutsideVO = new TravelAlertOutsideVO();
		TravelAlertInnerVO travelAlertInnerVO = new TravelAlertInnerVO();

		if (productType.equalsIgnoreCase("FOREIGNLINE")) {
			if (CollectionUtils.isNotEmpty(productDescriptionList)) {
				productDescription = productDescriptionList.get(0);
				if (StringUtil.isNotEmptyString(productDescription.getContent())) {
					travelAlertOutsideVO = JSONObject.parseObject(productDescription.getContent(), TravelAlertOutsideVO.class);
				}
			}
		} else {
			if (CollectionUtils.isNotEmpty(productDescriptionList)) {
				productDescription = productDescriptionList.get(0);
				if (StringUtil.isNotEmptyString(productDescription.getContent())) {
					travelAlertInnerVO = JSONObject.parseObject(productDescription.getContent(), TravelAlertInnerVO.class);
				}
			}
			model.addAttribute("travelAlertInnerVO", travelAlertInnerVO);
		}
		//出境跟团游供应商打包
		if ("FOREIGNLINE".equalsIgnoreCase(productType) && "SUPPLIER".equalsIgnoreCase(prodProduct.getPackageType())) {
			model.addAttribute("travelAlertTemplateList", TravelAlertOutsideVO.TRAVEL_ALERT_TEMPLATE.values());
			try {
				if (travelAlertOutsideVO == null || StringUtil.isEmptyString(travelAlertOutsideVO.getTravelAlertTemplate())) {
					List<Long> destIdList = MiscUtils.autoUnboxing( prodDestReService.findDestIdByProductId(productId) );
					Long destId = destIdList.get(0);
					BizDest country = MiscUtils.autoUnboxing( destService.selectCountryOfDestId(destId) );
					BizDestTravelAlert bizDestTravelAlert = bizDestTravelAlertService.findDestTravelAlertById(country == null ? destId : country.getDestId());
					if (travelAlertOutsideVO == null) {
						travelAlertOutsideVO = new TravelAlertOutsideVO();
					}
					if (bizDestTravelAlert != null) {
						travelAlertOutsideVO.setTravelAlertTemplate(bizDestTravelAlert.getTravelAlertCode());
					}

				}
			} catch (Exception e) {
				LOG.error(ExceptionFormatUtil.getTrace(e));
			}

		}
		if ("FOREIGNLINE".equalsIgnoreCase(productType)) {
			model.addAttribute("travelAlertOutsideVO", travelAlertOutsideVO);
		}
		model.addAttribute("travleProductDescription", productDescription);

		params.put("contentType", ProdProductDescription.CONTENT_TYPE.REFUND_EXPLAIN.name());
		// 查询退改说明
		productDescriptionList = MiscUtils.autoUnboxing( productDescriptionService.findProductDescriptionListByParams(params) );

		productDescription = new ProdProductDescription();

		RefundExplainInnerVO refundExplainInnerVO = new RefundExplainInnerVO();
		RefundExplainOutsideVO refundExplainOutsideVO = new RefundExplainOutsideVO();

		if (productType.equalsIgnoreCase("FOREIGNLINE")) {
			if (CollectionUtils.isNotEmpty(productDescriptionList)) {
				productDescription = productDescriptionList.get(0);
				if (StringUtil.isNotEmptyString(productDescription.getContent())) {
					refundExplainOutsideVO = JSONObject.parseObject(productDescription.getContent(), RefundExplainOutsideVO.class);
				}
			}
			model.addAttribute("refundExplainOutsideVO", refundExplainOutsideVO);
		} else {
			if (CollectionUtils.isNotEmpty(productDescriptionList)) {
				productDescription = productDescriptionList.get(0);
				if (StringUtil.isNotEmptyString(productDescription.getContent())) {
					refundExplainInnerVO = JSONObject.parseObject(productDescription.getContent(), RefundExplainInnerVO.class);
				}
			}
			model.addAttribute("refundExplainInnerVO", refundExplainInnerVO);
		}

		model.addAttribute("refundProductDescription", productDescription);
		model.addAttribute("prodProduct", prodProduct);
		model.addAttribute("categoryId", categoryId);
		//国内跟团游、当地游新增预订限制---start
		if((BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCategoryId().equals(categoryId)
                || BizEnum.BIZ_CATEGORY_TYPE.category_route_local.getCategoryId().equals(categoryId))
                && !productType.equalsIgnoreCase("FOREIGNLINE")){
            ProdReserveLimit prodReserveLimit = new ProdReserveLimit();
            productDescription = new ProdProductDescription();
            params.put("contentType", ProdProductDescription.CONTENT_TYPE.RESERVE_LIMIT.name());
            productDescriptionList = MiscUtils.autoUnboxing( productDescriptionService.findProductDescriptionListByParams(params) );
            if(CollectionUtils.isNotEmpty(productDescriptionList)){
                productDescription = productDescriptionList.get(0);
                if(StringUtil.isNotEmptyString(productDescription.getContent())){
                    prodReserveLimit = JSONObject.parseObject(productDescription.getContent(), ProdReserveLimit.class);
                }
            }else {
                setDefaultReserveLimit(prodProduct, prodReserveLimit);
            }
            model.addAttribute("isInnerGroupOrLocal","Y");
            model.addAttribute("prodReserveLimit", prodReserveLimit);
            model.addAttribute("reserveLimitDescription", productDescription);
        }
        //国内跟团游、当地游新增预订限制---end
		// 以下根据产品类型 PRODUCT_TYPE(产品类型（国内/出境）)判断跳转
		if (productType.equalsIgnoreCase("FOREIGNLINE")) {
			// 出境
			return "/dujia/group/prod/showProductSuggOut";
		} else {
			// 国内
			return "/dujia/group/prod/showProductSuggIn";
		}
	}

    /**
     * 出游人预订限制默认值
     */
	private void setDefaultReserveLimit(ProdProduct prodProduct, ProdReserveLimit prodReserveLimit){
        String productFiliale = prodProduct.getFiliale();
        if(CommEnumSet.FILIALE_NAME.SH_FILIALE.name().equals(productFiliale)
                || CommEnumSet.FILIALE_NAME.GZ_FILIALE.name().equals(productFiliale)
                || CommEnumSet.FILIALE_NAME.BJ_FILIALE.name().equals(productFiliale)
                || CommEnumSet.FILIALE_NAME.CD_FILIALE.name().equals(productFiliale)
                || CommEnumSet.FILIALE_NAME.SY_FILIALE.name().equals(productFiliale)){
			//获取省级目的地
        	List<Long> destIdList = destService.queryProvinceByProductId(prodProduct.getProductId());
            if(CollectionUtils.isEmpty(destIdList)){
                destIdList = new ArrayList<>();
            }
			//所有目的地范围的预定限制
            destIdList.add(0L);
            Map<String, Object> params = new HashMap<>();
            params.put("operationCategory", prodProduct.getOperationCategory());
            params.put("destIdList", destIdList);
			//获取目的地对应的预订限制
            List<BizReserveLimit> reserveLimitList = bizReserveLimitService.queryReserveLimitForProduct(params);
            if(CollectionUtils.isNotEmpty(reserveLimitList)){
                List<String> limitInfor = new ArrayList<>();
                Integer ageRangeUpper = null;
                Integer ageRangeLower = null;
                for(BizReserveLimit bizReserveLimit : reserveLimitList){
                    String limitKey = ProdReserveLimit.PROD_RESERVE_LIMIT.getDataKey(bizReserveLimit.getReserveType());
                    if(BizReserveLimit.RESERVE_LIMIT_CONTENT.age_range_limit.name().equals(bizReserveLimit.getReserveType())
                            || BizReserveLimit.RESERVE_LIMIT_CONTENT.advanced_age_limit.name().equals(bizReserveLimit.getReserveType())
                            || BizReserveLimit.RESERVE_LIMIT_CONTENT.young_age_limit.name().equals(bizReserveLimit.getReserveType())){
                        if(bizReserveLimit.getAgeUpperLimit() != null){
                            if(ageRangeUpper == null || ageRangeUpper.intValue() > bizReserveLimit.getAgeUpperLimit().intValue()){
                                ageRangeUpper = bizReserveLimit.getAgeUpperLimit();
                            }
                        }
                        if(bizReserveLimit.getAgeLowerLimit() != null){
                            if(ageRangeLower == null || ageRangeLower.intValue() < bizReserveLimit.getAgeLowerLimit().intValue()){
                                ageRangeLower = bizReserveLimit.getAgeLowerLimit();
                            }
                        }
                    }else {
                        if(!limitInfor.contains(limitKey)){
                            limitInfor.add(limitKey);
                        }
                    }
                }
                if(ageRangeLower != null && ageRangeUpper != null){
                    limitInfor.add(ProdReserveLimit.PROD_RESERVE_LIMIT.getDataKey(BizReserveLimit.RESERVE_LIMIT_CONTENT.age_range_limit.name()));
                }else if(ageRangeUpper != null){
                    limitInfor.add(ProdReserveLimit.PROD_RESERVE_LIMIT.getDataKey(BizReserveLimit.RESERVE_LIMIT_CONTENT.advanced_age_limit.name()));
                }else if(ageRangeLower != null){
                    limitInfor.add(ProdReserveLimit.PROD_RESERVE_LIMIT.getDataKey(BizReserveLimit.RESERVE_LIMIT_CONTENT.young_age_limit.name()));
                }
                prodReserveLimit.setLimitInfor(limitInfor);
                prodReserveLimit.setAgeRangeUpper(ageRangeUpper);
                prodReserveLimit.setAgeRangeLower(ageRangeLower);
            }
        }
    }
	
	/**
	 * 渲染 条款页面(国内自由行)
	 */
	@RequestMapping(value = "/showUpdateProductSuggForSelfTour")
	public String showUpdateProductSuggForSelfTour(Model model, Long productId, Long categoryId, HttpServletRequest req) throws BusinessException {
		if (productId == null) {
			throw new BusinessException("系统参数异常：某些必要参数为空");
		}
		
		// 根据产品id查询产品
		ProdProduct prodProduct = prodProductService.findProdProductByProductId(productId);
		String productType = prodProduct.getProductType();
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productId", productId);
		params.put("productType", productType);
		params.put("contentType", ProdProductDescription.CONTENT_TYPE.TRAVEL_ALERT.name());
		// 查询出行警示
		List<ProdProductDescription> productDescriptionList = MiscUtils.autoUnboxing( productDescriptionService.findProductDescriptionListByParams(params) );
		
		ProdProductDescription productDescription = new ProdProductDescription();
		
		TravelAlertInnerSelfTourVO travelAlertInnerSelfTourVO = new TravelAlertInnerSelfTourVO();
		
		if (CollectionUtils.isNotEmpty(productDescriptionList)) {
			productDescription = productDescriptionList.get(0);
			if (StringUtil.isNotEmptyString(productDescription.getContent())) {
				travelAlertInnerSelfTourVO = JSONObject.parseObject(productDescription.getContent(), TravelAlertInnerSelfTourVO.class);
			}
		}
		model.addAttribute("travelAlertInnerSelfTourVO", travelAlertInnerSelfTourVO);
		model.addAttribute("travleProductDescription", productDescription);
		
		params.put("contentType", ProdProductDescription.CONTENT_TYPE.REFUND_EXPLAIN.name());
		// 查询退改说明
		productDescriptionList = MiscUtils.autoUnboxing( productDescriptionService.findProductDescriptionListByParams(params) );
		
		productDescription = new ProdProductDescription();
		
		RefundExplainInnerVO refundExplainInnerVO = new RefundExplainInnerVO();
		
		if (CollectionUtils.isNotEmpty(productDescriptionList)) {
			productDescription = productDescriptionList.get(0);
			if (StringUtil.isNotEmptyString(productDescription.getContent())) {
				refundExplainInnerVO = JSONObject.parseObject(productDescription.getContent(), RefundExplainInnerVO.class);
			}
		}
		model.addAttribute("refundExplainInnerVO", refundExplainInnerVO);
		
		model.addAttribute("refundProductDescription", productDescription);
		model.addAttribute("prodProduct", prodProduct);
		model.addAttribute("categoryId", categoryId);
		return "/dujia/group/prod/showProductSuggInSelfTour";
	}

	/**
	 * 新增、编辑条款（国内自由行）
	 */
	@RequestMapping("/saveOrUpdateProductSuggInnerForSelfTour")
	@ResponseBody
	public Object saveOrUpdateProductSuggInnerForSelfTour(HttpServletRequest req, TravelAlertInnerSelfTourVO travelAlertInnerVO,
			RefundExplainInnerVO refundExplainInnerVO, ProdProductDescription productDescription, Long travleProdDescId,
			Long refundProdDescId) {
		if (travelAlertInnerVO == null || productDescription == null || productDescription.getProductId() == null
				|| StringUtil.isEmptyString(productDescription.getProductType())) {
			return new ResultMessage(ResultMessage.ERROR, "系统异常：某些必要参数为空");
		}
		
		try {
			//获取原始对象
			ProdProductParam param = new ProdProductParam();
			param.setProductProp(true);
			param.setProductPropValue(true);			
			ProdProduct oldProdProduct = prodProductService.findProdProductById(productDescription.getProductId(), param);
			
			// 保存出行警示
			String jsonStr = JSONObject.toJSONString(travelAlertInnerVO);
			productDescription.setContentType(ProdProductDescription.CONTENT_TYPE.TRAVEL_ALERT.name());
			productDescription.setContent(jsonStr);
			productDescription.setProdDescId(travleProdDescId);
			productDescriptionService.saveOrUpdateDoublePlaceForProductDes(productDescription);
			
			Map<String, Object> attributes = new HashMap<String, Object>();
			attributes.put("travleProdDescId", productDescription.getProdDescId());
			
			// 保存退改说明
			jsonStr = JSONObject.toJSONString(refundExplainInnerVO);
			productDescription.setContentType(ProdProductDescription.CONTENT_TYPE.REFUND_EXPLAIN.name());
			productDescription.setContent(jsonStr);
			productDescription.setProdDescId(refundProdDescId);
			productDescriptionService.saveOrUpdateDoublePlaceForProductDes(productDescription);
			
			attributes.put("refundProdDescId", productDescription.getProdDescId());
			
			//查询新保存后的产品对象
			ProdProduct prodProduct = prodProductService.findProdProductById(productDescription.getProductId(), param);
			
			//添加操作日志
			try {
				String log =  getProdProductPropLog(prodProduct, oldProdProduct);
				if(StringUtil.isNotEmptyString(log)){
					comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_SUGG, 
							productDescription.getProductId(), productDescription.getProductId(), 
							this.getLoginUser().getUserName(),
							"修改产品:" + log, 
							COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_SUGG_CHANGE.name(), 
							"修改产品",null);
				}
			} catch (Exception e) {
				log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
				log.error(ExceptionFormatUtil.getTrace(e));
			}
			return new ResultMessage(attributes, ResultMessage.SUCCESS, "保存成功");
		} catch (Exception e) {
			log.error("Call saveTravelAlertInner or saveRefundExplainInner occurs exception, caused by:"
					+ e.getMessage());
			return new ResultMessage(ResultMessage.ERROR, "系统异常");
		}
	}
	
	/**
	 * 新增、编辑条款（国内）
	 */
	@RequestMapping("/saveOrUpdateProductSuggInner")
	@ResponseBody
	public Object saveOrUpdateProductSuggInner(HttpServletRequest req, TravelAlertInnerVO travelAlertInnerVO,
			RefundExplainInnerVO refundExplainInnerVO, ProdProductDescription productDescription, Long travleProdDescId,
			Long refundProdDescId, ProdReserveLimit prodReserveLimit, Long reserveLimitProdDescId) {
		if (travelAlertInnerVO == null || productDescription == null || productDescription.getProductId() == null
				|| StringUtil.isEmptyString(productDescription.getProductType())) {
			return new ResultMessage(ResultMessage.ERROR, "系统异常：某些必要参数为空");
		}

		try {
			//获取原始对象
			ProdProductParam param = new ProdProductParam();
			param.setProductProp(true);
			param.setProductPropValue(true);			
			ProdProduct oldProdProduct = prodProductService.findProdProductById(productDescription.getProductId(), param);
			
			// 保存出行警示
			String jsonStr = JSONObject.toJSONString(travelAlertInnerVO);
			productDescription.setContentType(ProdProductDescription.CONTENT_TYPE.TRAVEL_ALERT.name());
			productDescription.setContent(jsonStr);
			productDescription.setProdDescId(travleProdDescId);
			productDescriptionService.saveOrUpdateDoublePlaceForProductDes(productDescription);

			//清空出行警示缓存
			MemcachedUtil.getInstance().remove(MemcachedEnum.ProdProductTravelAlertInner.getKey() + productDescription.getProductId());
			
			Map<String, Object> attributes = new HashMap<String, Object>();
			attributes.put("travleProdDescId", productDescription.getProdDescId());

			// 保存退改说明
			jsonStr = JSONObject.toJSONString(refundExplainInnerVO);
			productDescription.setContentType(ProdProductDescription.CONTENT_TYPE.REFUND_EXPLAIN.name());
			productDescription.setContent(jsonStr);
			productDescription.setProdDescId(refundProdDescId);
			productDescriptionService.saveOrUpdateDoublePlaceForProductDes(productDescription);

			attributes.put("refundProdDescId", productDescription.getProdDescId());
			//保存预订限制
            if(prodReserveLimit != null){
                prodReserveLimit.setDataFromSync("N");
                jsonStr = JSONObject.toJSONString(prodReserveLimit);
                productDescription.setContentType(ProdProductDescription.CONTENT_TYPE.RESERVE_LIMIT.name());
                productDescription.setContent(jsonStr);
                productDescription.setProdDescId(reserveLimitProdDescId);
                productDescriptionService.saveOrUpdateProdDescByReserveLimit(productDescription);
                attributes.put("reserveLimitProdDescId", productDescription.getProdDescId());
            }

			//查询新保存后的产品对象
			ProdProduct prodProduct = prodProductService.findProdProductById(productDescription.getProductId(), param);
			
			//添加操作日志
			try {
				String log =  getProdProductPropLog(prodProduct, oldProdProduct);
				if(prodReserveLimit != null){
					log = log + "修改了预订限制";
				}
				if(StringUtil.isNotEmptyString(log)){
					comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_SUGG, 
							productDescription.getProductId(), productDescription.getProductId(), 
							this.getLoginUser().getUserName(),
							"修改产品:" + log, 
							COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_SUGG_CHANGE.name(), 
							"修改产品",null);
				}
			} catch (Exception e) {
				log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
				log.error(ExceptionFormatUtil.getTrace(e));
			}
			return new ResultMessage(attributes, ResultMessage.SUCCESS, "保存成功");
		} catch (Exception e) {
			log.error("Call saveTravelAlertInner or saveRefundExplainInner occurs exception, caused by:"
					+ e.getMessage());
			return new ResultMessage(ResultMessage.ERROR, "系统异常");
		}
	}

	/**
	 * 新增、编辑条款（出境）
	 */
	@RequestMapping("/saveOrUpdateProductSuggOut")
	@ResponseBody
	public Object saveOrUpdateProductSuggOut(TravelAlertOutsideVO travelAlertOutsideVO,
			RefundExplainOutsideVO refundExplainOutsideVO, ProdProductDescription productDescription,
			Long refundExplainOutProdDescId, Long travelAlertOutProdDescId) {
		if (travelAlertOutsideVO == null || productDescription == null || productDescription.getProductId() == null
				|| StringUtil.isEmptyString(productDescription.getProductType())) {
			return new ResultMessage(ResultMessage.ERROR, "系统异常：某些必要参数为空");
		}

		try {
			//获取原始对象
			ProdProductParam param = new ProdProductParam();
			param.setProductProp(true);
			param.setProductPropValue(true);			
			ProdProduct oldProdProduct = prodProductService.findProdProductById(productDescription.getProductId(), param);
			
			// 保存出行警示（出境）
			productDescription.setContentType(ProdProductDescription.CONTENT_TYPE.TRAVEL_ALERT.name());
			String jsonStr = JSONObject.toJSONString(travelAlertOutsideVO);
			productDescription.setContent(jsonStr);
			productDescription.setProdDescId(travelAlertOutProdDescId);
			productDescriptionService.buildTravelAlertOutsideTextAndDoubleWrite(productDescription, false);

			Map<String, Object> attributes = new HashMap<String, Object>();
			attributes.put("travelAlertOutProdDescId", productDescription.getProdDescId());
			// 保存退改说明（出境）
			jsonStr = JSONObject.toJSONString(refundExplainOutsideVO);
			productDescription.setContentType(ProdProductDescription.CONTENT_TYPE.REFUND_EXPLAIN.name());
			productDescription.setContent(jsonStr);
			productDescription.setProdDescId(refundExplainOutProdDescId);
			productDescriptionService.saveOrUpdateDoublePlaceForProductDes(productDescription);

			attributes.put("refundExplainOutProdDescId", productDescription.getProdDescId());
			
			//查询新保存后的产品对象
			ProdProduct prodProduct = prodProductService.findProdProductById(productDescription.getProductId(), param);
			
			try {
				if (isOutGroupAndunVersion(prodProduct)) {
					ProdProduct versionProduct = new ProdProduct();
					versionProduct.setProductId(productDescription.getProductId());
					versionProduct.setModelVersion(ProdProduct.MODEL_VERSION_1D0);
					prodProductService.updateModelVersionByPrimaryKey(versionProduct);
				}
			} catch (Exception ex) {
				LOG.error(ExceptionFormatUtil.getTrace(ex));
			}
			
			//添加操作日志
			try {
				String log =  getProdProductPropLog(prodProduct, oldProdProduct);
				if(StringUtil.isNotEmptyString(log)){
					comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_SUGG, 
							productDescription.getProductId(), productDescription.getProductId(), 
							this.getLoginUser().getUserName(),
							"修改产品:" + log, 
							COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_SUGG_CHANGE.name(), 
							"修改产品",null);
				}
			} catch (Exception e) {
				log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
				log.error(ExceptionFormatUtil.getTrace(e));
			}

			return new ResultMessage(attributes, ResultMessage.SUCCESS, "保存成功");
		} catch (Exception e) {
			log.error("Call saveTravelAlertOutside or saveRefundExplainOutside occurs exception, caused by:"
					+ e.getMessage());
			return new ResultMessage(ResultMessage.ERROR, "系统异常");
		}
	}
	
	@RequestMapping(value = "/showUpdateProductFeature")
	public String showUpdateProductFeature(Model model, long productId, String packageType,String productType, HttpServletRequest req) {
		String dataFrom=req.getParameter("dataFrom");
		model.addAttribute("packageType",packageType);
		model.addAttribute("productId", productId);
		model.addAttribute("productType", productType);
		ProdProductAssociation prodProductAssociation= prodProductAssociationService.getProdProductAssociationByProductId(Long.valueOf(productId));
		List<ProdRouteFeature> prfList = new ArrayList<ProdRouteFeature>();
		ProdProductDescription prodProductDescription = new ProdProductDescription();
		ProdProduct prodproduct = prodProductService.findProdProductByProductId(Long.valueOf(productId));
		if(prodProductAssociation!=null&&prodProductAssociation.getAssociatedFeatureId()!=null){
			productId = prodProductAssociation.getAssociatedFeatureId();
		    model.addAttribute("associatedFeatureId",productId);
			model.addAttribute("associatedcategoryId",prodproduct.getBizCategoryId());
			model.addAttribute("editFlag","false");
			log.info("GroupProductAction method showUpdateProductFeature productId = "+productId+" AssociatedFeatureId="+prodProductAssociation.getAssociatedFeatureId());
		}else{
			model.addAttribute("editFlag","true");
		}
		prfList=prodRouteFeatureService.findProdRouteFeatureByProdId(productId);
		
		prodProductDescription = prodRouteFeatureService.findProdProductDescription(productId);
		if(CollectionUtils.isEmpty(prfList) && StringUtils.isNotEmpty(prodProductDescription.getContent())){
			model.addAttribute("hasHead", "true");
		}else{
			model.addAttribute("hasHead","false");
		}
		model.addAttribute("userName", this.getLoginUser().getUserName());
		
		model.addAttribute("categoryId", prodproduct.getBizCategoryId());
		if("fromPage".equals(dataFrom)){
			HttpSession session=req.getSession();
			model.addAttribute("ProdRouteFeatureList", session.getAttribute("pageData"));
		}else{
			model.addAttribute("ProdRouteFeatureList", prfList);
		}
		if(CollectionUtils.isNotEmpty(prfList)){
			for(ProdRouteFeature prodRouteFeature :prfList){
				if(ProdRouteFeature.FEATPROP_TYPE.RICH_TEXT.name().equals(prodRouteFeature.getFeatPropType())){
					model.addAttribute("featPropValue", prodRouteFeature.getFeatPropValue());
				}
			}
		}
		return "/dujia/group/prod/productRouteFeature"; 
	}
	
	@RequestMapping(value="/updateProductFeature")
	@ResponseBody
	public Object updateProductFeature(Model model, long productId, HttpServletRequest req) {
		
		List<ProdRouteFeature> OldprodRoutefeatureList =prodRouteFeatureService.findProdRouteFeatureByProdId(productId);
		String[] featurePropStrs=req.getParameterValues("featureProp");
		String htmlForFeature=req.getParameter("htmlForFeature");
		String richTextVal = req.getParameter("richTextVal");
		List<ProdRouteFeature> prodRoutefeatureList=new ArrayList<ProdRouteFeature>();
		Boolean richflag =false;
		if(richTextVal!=null){
			ProdRouteFeature prodRouteFeature = new ProdRouteFeature();
			prodRouteFeature.setProductId(productId);
			prodRouteFeature.setFeatPropType(ProdRouteFeature.FEATPROP_TYPE.RICH_TEXT.name());
			prodRouteFeature.setFeatPropValue(richTextVal);
			prodRouteFeature.setPropSort((long) 0);
			prodRoutefeatureList.add(prodRouteFeature);
			richflag=true;
		}
		if (featurePropStrs != null && featurePropStrs.length > 0) {
			for (int i = 0; i < featurePropStrs.length; i++) {
				int index=featurePropStrs[i].indexOf("`");
				String propType=StringUtils.substring(featurePropStrs[i],0, index);
				String propValue=StringUtils.substring(featurePropStrs[i],index+1, featurePropStrs[i].length());
				if (StringUtils.isNotEmpty(propType) && StringUtils.isNotEmpty(propValue)) {
					ProdRouteFeature prodRouteFeature = new ProdRouteFeature();
					prodRouteFeature.setProductId(productId);
					prodRouteFeature.setFeatPropType(propType);
					prodRouteFeature.setFeatPropValue(propValue);
					if(richflag){
						prodRouteFeature.setPropSort((long) i+1);
					}else{
						prodRouteFeature.setPropSort((long) i);
					}
					prodRoutefeatureList.add(prodRouteFeature);
				}
			}
		}
		boolean res=prodRouteFeatureService.saveProdRouteFeature(productId, prodRoutefeatureList,htmlForFeature);
		
		// 添加操作LOG日志
				try {
					String log =  getProdProductFeatureLog(prodRoutefeatureList,OldprodRoutefeatureList);
					if(StringUtil.isNotEmptyString(log)){
						comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_FEATURE, 
								productId, productId, 
								this.getLoginUser().getUserName(),
								"修改产品:" + log, 
								COM_LOG_LOG_TYPE.PROD_PRODUCT_FEATURE_CHANGE.name(), 
								"修改产品",null);
					}

				} catch (Exception e) {
					log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_FEATURE_CHANGE.name());
					log.error(e.getMessage());
				}
		
		//清除页面缓存数据
		HttpSession session=req.getSession();
		if(session.getAttribute("pageData")!=null){
			session.removeAttribute("pageData");
		}
		if(res){
			return new ResultMessage(ResultMessage.SUCCESS, "保存成功"); 
		}else{
			return new ResultMessage(ResultMessage.ERROR, "保存失败");
		}
	}

	@RequestMapping(value = "/showProductRouteFeatureOld")
	public String showProductRouteFeatureOld(Model model, long productId, Long associatedFeatureId, String packageType,HttpServletRequest req) {
		model.addAttribute("productId", productId);
		if(associatedFeatureId != null){
			productId = associatedFeatureId;
		}
		ProdProductDescription prodProductDescription = prodRouteFeatureService.findProdProductDescription(productId);
		model.addAttribute("ProductDescription", prodProductDescription);
		model.addAttribute("packageType", packageType);
		String[] featurePropStrs=req.getParameterValues("featureProp");
		List<ProdRouteFeature> prodRoutefeatureList=new ArrayList<ProdRouteFeature>();
		if(featurePropStrs!=null && featurePropStrs.length>0){
			for (int i = 0; i < featurePropStrs.length; i++) {
				int index=featurePropStrs[i].indexOf("`");
				String propType=StringUtils.substring(featurePropStrs[i],0, index);
				String propValue=StringUtils.substring(featurePropStrs[i],index+1, featurePropStrs[i].length());
				if (StringUtils.isNotEmpty(propType) && StringUtils.isNotEmpty(propValue)) {
					ProdRouteFeature prodRouteFeature = new ProdRouteFeature();
					prodRouteFeature.setProductId(productId);
					prodRouteFeature.setFeatPropType(propType);
					prodRouteFeature.setFeatPropValue(propValue);
					prodRouteFeature.setPropSort((long) i);
					prodRoutefeatureList.add(prodRouteFeature);
				}
			}
		}
		
		//将未保存到数据库中的数据，暂时缓存
		HttpSession session=req.getSession();
		session.setAttribute("pageData", prodRoutefeatureList);
		return "/dujia/group/prod/productRouteFeatureOld"; 
	}
	
	/**
	 *复制产品富文本
	 *@param oldProductId 原来产品的ID
	 *@param newProductId 复制产品的ID
	 */
	@RequestMapping(value = "/copyProdRichText")
	@ResponseBody
	public Object copyProdRichText(String oldProductId,String newProductId){
		if (!StringUtil.isNumber(oldProductId) || !StringUtil.isNumber(newProductId)) {
			return new ResultMessage(ResultMessage.ERROR, "参数错误");
		}
		String propValue=null;
		try {
			//copyProdRichText
			List<ProdRouteFeature> newFeatureList = this.prodRouteFeatureService.findProdRouteFeatureByProdId(Long.parseLong(newProductId));
			if (CollectionUtils.isNotEmpty(newFeatureList)) {
				for(ProdRouteFeature prodRouteFeature : newFeatureList){
					if(ProdRouteFeature.FEATPROP_TYPE.RICH_TEXT.name().equals(prodRouteFeature.getFeatPropType())){
						propValue=prodRouteFeature.getFeatPropValue();
						if(StringUtil.isEmptyString(propValue)){
							return new ResultMessage(ResultMessage.ERROR, "复制失败:产品" +newProductId +"富文本为空");
						}
						break;
					}
				}
			}
			if(StringUtil.isEmptyString(propValue)){
				return new ResultMessage(ResultMessage.ERROR,"复制失败:产品" +newProductId +"富文本为空");
			}else{
				return new ResultMessage(ResultMessage.SUCCESS, propValue);
			}
		} catch (Exception e) {
			LOG.error("newProductId="+newProductId+"oldProductId="+oldProductId+ExceptionFormatUtil.getTrace(e));
			return new ResultMessage(ResultMessage.ERROR, "复制失败:"+e.getMessage());
		}
	}
	
	/**
	 *复制产品特色结构化
	 *@param oldProductId 原来产品的ID
	 *@param newProductId 复制产品的ID
	 */
	@RequestMapping(value = "/copyProdFeature")
	@ResponseBody
	public Object copyProdFeature(String oldProductId,String newProductId,String copyType){
		if (!StringUtil.isNumber(oldProductId) || !StringUtil.isNumber(oldProductId)) {
			return new ResultMessage(ResultMessage.ERROR, "参数错误");
		}
		if(copyType == null || copyType.equals("")){
			try {
				List<ProdRouteFeature> prfList = this.prodRouteFeatureService.findProdRouteFeatureByProdId(Long.valueOf(newProductId));
				if(prfList!=null && prfList.size()>0){
					this.prodRouteFeatureService.copyProdRouteFeatureService(Long.valueOf(oldProductId),Long.valueOf(newProductId));
				}else{
					return new ResultMessage(ResultMessage.ERROR, "复制失败: 产品 ID:" + newProductId + "的产品特色没有结构化"	);	
				}			
			} catch (Exception e) {
				 LOG.error(ExceptionFormatUtil.getTrace(e));
				return new ResultMessage(ResultMessage.ERROR, "复制失败:" + e.getMessage());
			}
			//记录日志
			insertlog("复制产品特色，复制了产品id为"+newProductId,Long.parseLong(oldProductId));
		}else if(copyType.equals("copyOnly")){
			try {
				List<ProdRouteFeature> prfList = this.prodRouteFeatureService.findProdRouteFeatureByProdId(Long.valueOf(newProductId));
				if(prfList!=null && prfList.size()>0){
					this.prodRouteFeatureService.copyProdRouteFeatureService(Long.valueOf(oldProductId), Long.valueOf(newProductId));
					//清除特色关联表中特色关联id
					ProdProductAssociation prodProductAssociation= prodProductAssociationService.getProdProductAssociationByProductId(Long.valueOf(oldProductId));
					if(prodProductAssociation != null && prodProductAssociation.getAssociatedFeatureId() != null){
						Map<String,Object> params = new HashMap<String,Object>();
						params.put("productId", oldProductId);
						params.put("associatedFeatureId", null);
						prodProductAssociationService.updateFeatureIdAssociation(params);
					}
				}else{
					return new ResultMessage(ResultMessage.ERROR, "复制失败: 产品 ID:" + newProductId + "的产品特色没有结构化"	);	
				}
			} catch (Exception e) {
				LOG.error(ExceptionFormatUtil.getTrace(e));
				LOG.info("packageTourProductAction method:copyProdFeature  引用   copyOnly error "+"newProductId="+newProductId+"oldProductId="+oldProductId);
				return new ResultMessage(ResultMessage.ERROR, "引用失败:"+e.getMessage());
			}
			//记录日志
			insertlog("复制产品特色，复制了产品id为"+newProductId,Long.parseLong(oldProductId));
		}else if(copyType.equals("related")){
			try {
				ProdProduct prodproduct = prodProductService.findProdProductByProductId(Long.valueOf(newProductId));
				if(prodproduct == null){
					return new ResultMessage(ResultMessage.ERROR, "关联失败:产品id不正确:"+newProductId);
				}
				List<ProdRouteFeature> prfList=prodRouteFeatureService.findProdRouteFeatureByProdId(Long.valueOf(newProductId));
				ProdProductDescription prodProductDescription = prodRouteFeatureService.findProdProductDescription(Long.valueOf(newProductId));
				if(CollectionUtils.isEmpty(prfList) && this.isnull(prodProductDescription)){
					return new ResultMessage(ResultMessage.ERROR, "关联失败:该产品id没有产品特色:"+newProductId);
				}
				this.prodRouteFeatureService.relateProdRouteFeatureService(Long.valueOf(oldProductId), Long.valueOf(newProductId));
			} catch (Exception e) {
				LOG.error(ExceptionFormatUtil.getTrace(e));
				LOG.info("packageTourProductAction method:copyProdFeature 关联 related error "+"newProductId="+newProductId+"oldProductId="+oldProductId);
				return new ResultMessage(ResultMessage.ERROR, "关联失败:"+e.getMessage());
			}
			// 添加操作LOG日志
			insertlog("关联产品特色，关联了产品id为"+newProductId,Long.parseLong(oldProductId));
		}
		
		return new ResultMessage(ResultMessage.SUCCESS, "复制或者引用或者关联成功");
	}
	
	private void insertlog(String logcontent,Long productId){
		try {
			if(StringUtil.isNotEmptyString(logcontent)){
				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_FEATURE, 
						productId, productId, 
						this.getLoginUser().getUserName(),
						"修改产品:" + logcontent, 
						COM_LOG_LOG_TYPE.PROD_PRODUCT_FEATURE_CHANGE.name(), 
						"修改产品",null);
			}

		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_FEATURE_CHANGE.name());
			log.error(e.getMessage());
		}
	}
	
	public Boolean isnull(ProdProductDescription prodProductDescription){
		Boolean flag = false;
		if(prodProductDescription.getCategoryId() == null && prodProductDescription.getProdDescId() == null && prodProductDescription.getProductId() == null  
				&& StringUtils.isNotEmpty(prodProductDescription.getContent()) && StringUtils.isNotEmpty(prodProductDescription.getContentType()) 
				&& StringUtils.isNotEmpty(prodProductDescription.getProductType()) &&StringUtils.isNotEmpty(prodProductDescription.getClobFlag())){
			flag = true;
		}
		return flag;
		
	}
	
	@RequestMapping(value = "/showAddPicture")
	public String showAddPicture(Model model, HttpServletRequest req,long productId) {
		String divIndex=req.getParameter("divIndex");
		if(StringUtil.isNotEmptyString(divIndex)){
			model.addAttribute("divIndex", divIndex);
		}
		model.addAttribute("productId", productId);
		return "/dujia/group/prod/addPicture"; 
	}
	
	
	@RequestMapping(value = "/previewProdFeature")
	public String previewProdFeature(Model model, HttpServletRequest req) {
		
		return "/dujia/group/prod/previewProdFeature"; 
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
		sb.append(getChangeLog("产品经理", oldProduct.getManagerName(), prodProduct.getManagerName()));
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
		if(null != oldProduct.getProdEcontract() && null != oldProduct.getProdEcontract().getGroupType()
				&& null != prodProduct.getProdEcontract() && null != prodProduct.getProdEcontract().getGroupType()){
			String oldGroupTypeName = ProdEcontract.GROUP_TYPE.getCnName(oldProduct.getProdEcontract().getGroupType());
			if(ProdEcontract.GROUP_TYPE.COMMISSIONED_TOUR.name().equalsIgnoreCase(oldProduct.getProdEcontract().getGroupType())){
				oldGroupTypeName += "[" + oldProduct.getProdEcontract().getGroupSupplierName() + "]";
			}
			String groupTypeName = ProdEcontract.GROUP_TYPE.getCnName(prodProduct.getProdEcontract().getGroupType());
			if(ProdEcontract.GROUP_TYPE.COMMISSIONED_TOUR.name().equalsIgnoreCase(prodProduct.getProdEcontract().getGroupType())){
				groupTypeName += "[" + prodProduct.getProdEcontract().getGroupSupplierName() + "]";
			}
			sb.append(getChangeLog("组团方式", oldGroupTypeName, groupTypeName));
		}
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
			logStr.append(getChangeLog("是否是团结算", convertYorNFlag(oldLineBasicInfo.getGroupSettleFlag()), convertYorNFlag(newLineBasicInfo.getGroupSettleFlag())));
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
	 * 转换yn为是或者否
	 * @param groupSettleFlag
	 * @return
	 */
	private String  convertYorNFlag(String groupSettleFlag) {
		if ("Y".equals(groupSettleFlag)) {
			return "是";
		} else if ("N".equals(groupSettleFlag)) {
			return "否";
		} else {
			return null;
		}
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
		try{
		//修改之前
		StringBuilder logStr = new StringBuilder();

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
	 } catch (Exception e) {
		 return " get getDistributorLog error"+e.getMessage();
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
	            	
	            	if (prop2.getProdPropId() != null && prop.getProdPropId() != null) {
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

	        }
	        return ret.toString();
	    }
	 
	 private String getProdProductFeatureLog(List<ProdRouteFeature> NewFeaturelist,List<ProdRouteFeature> OldFeaturelist) {
		 StringBuilder ret = new StringBuilder();
		 List<ProdRouteFeature> bigtitlelist = new ArrayList<ProdRouteFeature>();
		 List<ProdRouteFeature> smalltitlelist = new ArrayList<ProdRouteFeature>();
		 List<ProdRouteFeature> txttitlelist = new ArrayList<ProdRouteFeature>();
		 List<ProdRouteFeature> imgtitlelist = new ArrayList<ProdRouteFeature>();
		 List<ProdRouteFeature> oldbigtitlelist = new ArrayList<ProdRouteFeature>();
		 List<ProdRouteFeature> oldsmalltitlelist = new ArrayList<ProdRouteFeature>();
		 List<ProdRouteFeature> oldtxttitlelist = new ArrayList<ProdRouteFeature>();
		 List<ProdRouteFeature> oldimgtitlelist = new ArrayList<ProdRouteFeature>();
		 if(NewFeaturelist!=null&&NewFeaturelist.size()>0){
			 for(ProdRouteFeature prodRouteFeature:NewFeaturelist){
				 if(ProdRouteFeature.FEATPROP_TYPE.BIG_TITLE.name().equals(prodRouteFeature.getFeatPropType())){
					 bigtitlelist.add(prodRouteFeature);
				 }else if(ProdRouteFeature.FEATPROP_TYPE.SMALL_TITLE.name().equals(prodRouteFeature.getFeatPropType())){
					 smalltitlelist.add(prodRouteFeature);
				 }else if(ProdRouteFeature.FEATPROP_TYPE.TEXT.name().equals(prodRouteFeature.getFeatPropType())){
					 txttitlelist.add(prodRouteFeature);
				 }else if(ProdRouteFeature.FEATPROP_TYPE.IMG.name().equals(prodRouteFeature.getFeatPropType())){
					 imgtitlelist.add(prodRouteFeature);
				 }
			 }
		 }
		 if(OldFeaturelist!=null&&OldFeaturelist.size()>0){
			 for(ProdRouteFeature prodRouteFeature:OldFeaturelist){
				 if(ProdRouteFeature.FEATPROP_TYPE.BIG_TITLE.name().equals(prodRouteFeature.getFeatPropType())){
					 oldbigtitlelist.add(prodRouteFeature);
				 }else if(ProdRouteFeature.FEATPROP_TYPE.SMALL_TITLE.name().equals(prodRouteFeature.getFeatPropType())){
					 oldsmalltitlelist.add(prodRouteFeature);
				 }else if(ProdRouteFeature.FEATPROP_TYPE.TEXT.name().equals(prodRouteFeature.getFeatPropType())){
					 oldtxttitlelist.add(prodRouteFeature);
				 }else if(ProdRouteFeature.FEATPROP_TYPE.IMG.name().equals(prodRouteFeature.getFeatPropType())){
					 oldimgtitlelist.add(prodRouteFeature);
				 }
			 }
		 }
		 getRet(ret,bigtitlelist,oldbigtitlelist);
		 getRet(ret,smalltitlelist,oldsmalltitlelist);
		 getRet(ret,txttitlelist,oldtxttitlelist);
		 getRet(ret,imgtitlelist,oldimgtitlelist);
		 
		 return ret.toString();
	 }
	 
	 private void getRet(StringBuilder ret,List<ProdRouteFeature> newlist,List<ProdRouteFeature> oldlist){
		 
		 if(newlist.size()==oldlist.size() ){
			 if(newlist.size()>0){
				 for(int i=0;i<newlist.size();i++){
					 String PropType =newlist.get(i).getFeatPropType();
					 String ProdValue = newlist.get(i).getFeatPropValue();
					 String oldPropValue = oldlist.get(i).getFeatPropValue();
					 if(!ProdValue.equals(oldPropValue)){
						 addString(ret,PropType,"修改为'"+ProdValue+"'");
					 }
				 } 
			 }
			 
		 }else if(newlist.size()>oldlist.size()){
			 if(oldlist.size()>0){
				 for(int i=0;i<newlist.size();i++){
					 Boolean flag = true;
					 String PropType =newlist.get(i).getFeatPropType();
					 String ProdValue = newlist.get(i).getFeatPropValue();
					 if(oldlist.size()>0){
						 for(ProdRouteFeature prf:oldlist){
							 if(ProdValue.equals(prf.getFeatPropValue())){
								 flag=false;
								 oldlist.remove(prf) ;
								 break;
							 }
						 } 
					 }
					 if(flag){
						 addString(ret,PropType,"'"+ProdValue+"'");
					 }
				 } 
			 }else{
				 for(ProdRouteFeature prf:newlist){
					 addString(ret,prf.getFeatPropType(),"新增了'"+prf.getFeatPropValue()+"'"); 
				 }
			 }
		 }else if(newlist.size()<oldlist.size()){
			 if(newlist.size()>0){
				 for(ProdRouteFeature prf:newlist){
					 Boolean flag = true;
					 String PropType =prf.getFeatPropType();
					 String ProdValue = prf.getFeatPropValue();
					 if(oldlist.size()>0){
						 for(ProdRouteFeature prf2:oldlist){
							 if(ProdValue.equals(prf2.getFeatPropValue())){
								 flag=false;
								 oldlist.remove(prf2);
								 break;
							 }
						 } 
					 }
					 if(flag){
						 addString(ret,PropType,"'"+ProdValue+"'");
					 }
				 }
				 if(oldlist.size()>0){
					 for(ProdRouteFeature prf:oldlist){
						 addString(ret,prf.getFeatPropType(),"删除了'"+prf.getFeatPropValue()+"'");
					 }
				 }
				 
			 }else{
				 for(ProdRouteFeature prf:oldlist){
					 addString(ret,prf.getFeatPropType(),"删除了'"+prf.getFeatPropValue()+"'");
				 }
			 }
		 }
		 
	 }
	 
	 private void addString(StringBuilder ret,String propType,String propValue){
		 if(ProdRouteFeature.FEATPROP_TYPE.BIG_TITLE.name().equals(propType)){
			 ret.append(" 大标题变更："+propValue);
		 }else if(ProdRouteFeature.FEATPROP_TYPE.SMALL_TITLE.name().equals(propType)){
			 ret.append(" 小标题变更："+propValue);
		 }else if(ProdRouteFeature.FEATPROP_TYPE.TEXT.name().equals(propType)){
			 ret.append(" 正文变更："+propValue);
		 }else if(ProdRouteFeature.FEATPROP_TYPE.IMG.name().equals(propType)){
			 ret.append(" 图片变更："+propValue);
		 }
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
