package com.lvmama.vst.back.prod.web.packageTour;

import static com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE.PROD_TRAVEL_DESIGN;
import static com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE.PROD_LINE_ROUTE;

import java.awt.image.BufferedImage;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.lvmama.vst.back.biz.po.*;
import com.lvmama.vst.back.client.biz.service.*;
import com.lvmama.vst.back.prod.po.*;
import com.lvmama.vst.comm.utils.*;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.lvmama.comm.cache.squid.SquidClient;
import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.comm.pet.po.pub.ComMessage;
import com.lvmama.comm.pet.service.pub.ComMessageService;
import com.lvmama.comm.tnt.po.TntGoodsChannelVo;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.biz.service.BizDictQueryService;
import com.lvmama.vst.back.biz.service.BizReserveLimitService;
import com.lvmama.vst.back.biz.service.CategoryPropGroupService;
import com.lvmama.vst.back.biz.service.DestService;
import com.lvmama.vst.back.biz.service.DictService;
import com.lvmama.vst.back.client.dist.service.DistDistributorProdClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.prod.service.ProdAdditionFlagClientService;
import com.lvmama.vst.back.client.prod.service.ProdDestReClientService;
import com.lvmama.vst.back.client.prod.service.ProdEcontractClientService;
import com.lvmama.vst.back.client.prod.service.ProdGroupClientService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteClientService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteDetailClientService;
import com.lvmama.vst.back.client.prod.service.ProdPackageDetailAddPriceClientService;
import com.lvmama.vst.back.client.prod.service.ProdPackageDetailClientService;
import com.lvmama.vst.back.client.prod.service.ProdPackageGroupClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductPropClientService;
import com.lvmama.vst.back.client.prod.service.ProdRouteFeatureClientService;
import com.lvmama.vst.back.client.prod.service.ProdTrafficClientService;
import com.lvmama.vst.back.client.pub.service.ComCalDataClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.pub.service.ComOrderRequiredClientService;
import com.lvmama.vst.back.client.supp.service.SuppSupplierClientService;
import com.lvmama.vst.back.dist.po.DistDistributorProd;
import com.lvmama.vst.back.dist.po.Distributor;
import com.lvmama.vst.back.dist.service.DistributorCachedService;
import com.lvmama.vst.back.dujia.client.comm.prod.service.ProdProductDescriptionClientService;
import com.lvmama.vst.back.dujia.comm.prod.po.ProdProductDescription;
import com.lvmama.vst.back.dujia.comm.route.po.ProdRouteFeature;
import com.lvmama.vst.back.dujia.group.prod.vo.ProdProductNameVO;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.goods.vo.ProdProductParam;
import com.lvmama.vst.back.pack.data.ProdPackageDetailGoodsData;
import com.lvmama.vst.back.pack.service.ProdLineGroupPackService;
import com.lvmama.vst.back.pack.service.ProdPackageDetailGoodsService;
import com.lvmama.vst.back.prod.po.ProdProduct.COMPANY_TYPE_DIC;
import com.lvmama.vst.back.prod.service.AssociationRecommendService;
import com.lvmama.vst.back.client.prod.service.ProdPackageDetailClientService;
import com.lvmama.vst.back.prod.service.ProdProductAssociationService;
import com.lvmama.vst.back.client.prod.service.ProdProductSaleReClientService;
import com.lvmama.vst.back.prod.service.ProdProductServiceAdapter;
import com.lvmama.vst.back.prod.service.ProdStartDistrictDetailService;
import com.lvmama.vst.back.prod.service.ProdTrafficGroupService;
import com.lvmama.vst.back.prod.service.ProdVisadocReService;
import com.lvmama.vst.back.prod.vo.ProdAdditionFlag;
import com.lvmama.vst.back.pub.po.ComCalData;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.pub.po.ComOrderRequired;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.pub.service.PushAdapterService;
import com.lvmama.vst.back.supp.po.SuppSupplier;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.back.utils.TimeLog;
import com.lvmama.vst.back.utils.TwoDimensionCode;
import com.lvmama.vst.back.visa.service.VisaDocService;
import com.lvmama.vst.comm.enumeration.CommEnumSet;
import com.lvmama.vst.comm.utils.web.HttpServletLocalThread;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.Constant.PROPERTY_INPUT_TYPE_ENUM;
import com.lvmama.vst.comm.vo.Constant.VST_CATEGORY;
import com.lvmama.vst.comm.vo.MemcachedEnum;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;
import com.lvmama.vst.pet.adapter.TntGoodsChannelCouponAdapter;


/**
 * 产品管理Action
 * 
 * @author qiujiehong
 * @date 2013-10-11
 */
@Controller
@RequestMapping("/packageTour/prod/product")
public class PackageTourProductAction extends BaseActionSupport {
	
	/** Serial Version UID */
	private static final long serialVersionUID = -994536186179040393L;

	private static final Log LOG = LogFactory.getLog(PackageTourProductAction.class);

	@Autowired
	private ProdProductClientService prodProductService;//1
	

	@Autowired
	private ProdProductPropClientService prodProductPropService;//2
	
	
	@Autowired
	private CategoryPropGroupService categoryPropGroupService;//3
	
	@Autowired
	private ComLogClientService comLogService;//4
	
	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;//5
	
	@Autowired
	private BizDictQueryService bizDictQueryService;//6
	
	@Autowired
	private ProdProductServiceAdapter prodProductServiceAdapter;//no
	
	@Autowired
	private DistributorCachedService distributorService;//7
	
	@Autowired
	private PermUserServiceAdapter permUserServiceAdapter;
	
	@Autowired
	private ProdLineRouteDetailClientService prodLineRouteDetailService;
	
 
	@Autowired
	private ComOrderRequiredClientService comOrderRequiredService;
	
	
	@Autowired
	private BizOrderRequiredClientService bizOrderRequiredService;
	
	
	@Autowired
	private DistDistributorProdClientService distDistributorProdService;
	
	
	@Autowired
	private CategoryPropClientService categoryPropService;
	
	
	@Autowired
	private VisaDocService visaDocService;//no
	
	@Autowired
	private DictService dictService;
	
	
	@Autowired
	private ProdVisadocReService prodVisadocReService;
	
	@Autowired
	private TntGoodsChannelCouponAdapter tntGoodsChannelCouponServiceRemote;//new
	
	@Autowired
	private ProdTrafficClientService prodTrafficService;
	
	
	@Autowired
	private ProdTrafficGroupService prodTrafficGroupService;
	
	@Autowired
	private ProdLineRouteClientService prodLineRouteService;
	
	
	@Autowired
	private ProdDestReClientService prodDestReService;
	
	
	
	@Autowired
	private DistDistributorProdClientService prodDistributorService;
	
	
	@Autowired
	private PushAdapterService pushAdapterService;
	
	@Autowired
    private ProdEcontractClientService prodEcontractService;
	
	@Autowired
	private ProdPackageGroupClientService prodPackageGroupService;
	
	
	@Autowired
	private AttributionClientService attributionService;
	
	
	@Autowired
	private BizBuEnumClientService bizBuEnumClientService;
	
	@Autowired
	private AssociationRecommendService associationRecommendService;
	
	
	@Autowired
	private SuppGoodsClientService suppGoodsService;
	
	
	@Autowired
	private ProdLineGroupPackService prodLineGroupPackService;
	
	@Autowired
	private DestService destService;
	

	@Autowired
	private ProdGroupClientService prodGroupService;
	
	
//	@Autowired
//	private SuppSupplierService suppSupplierService;
	@Autowired
	private SuppSupplierClientService suppSupplierClientService;
	
	@Autowired
	private ProdProductDescriptionClientService prodProductDescriptionService;
	
	
	@Autowired
	private ComCalDataClientService comCalDataService;
	
	
	private static final String PROD_GROUP_MESSAGE_EXISTS ="维护产品已被其它产品进行关联,请先取消";
	
	@Autowired
	private ProdRouteFeatureClientService prodRouteFeatureService;
	
	
	@Autowired
	private ProdProductAssociationService prodProductAssociationService;
	
	@Autowired
	private ProdPackageDetailAddPriceClientService prodPackageDetailAddPriceService;
	
	
	@Autowired
	private ProdPackageDetailGoodsService prodPackageDetailGoodsService;
	
	@Autowired
	private ComMessageService comMessageService;
	
	
	@Autowired
	private ProdStartDistrictDetailService prodStartDistrictDetailService;
	@Autowired
	private ProdPackageDetailClientService prodPackageDetailService;
	
	@Autowired
	private ProdAdditionFlagClientService prodAdditionFlagService;
	
	@Autowired
	private BizReserveLimitService bizReserveLimitService;
	
	@Autowired
	private ProdProductSaleReClientService prodProductSaleReService;

	@Autowired
	private ProdTagClientService prodTagClientService;
	@Autowired
	private TagClientService tagClientService;
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
		return "/prod/packageTour/product/findProdGroupList";
	}
	
	/**
	 * 关联产品查询页面
	 */
	@RequestMapping(value = "/showSelectReProductList")
	public String showSelectReProductList(Model model,Long prodProductId, Long categoryId){
		model.addAttribute("prodProductId", prodProductId);
		model.addAttribute("categoryId", categoryId);
		return "/prod/packageTour/product/showSelectReProductList";
	}
	
	
	private boolean isEqual(Long long1, Long long2){
		return long1.intValue() == long2.intValue();
	}
	private static final short PROD_GROUP_MAX_SUM =10;
	/**
	 * 获取关联产品的最大数目
	 * @return int
	 */
	private static int getNewProdGroupMaxSize(){
		Short size =PROD_GROUP_MAX_SUM;
		Assert.notNull(size, PROD_GROUP_MAX_SUM +" not is null");
		return Integer.valueOf(size);
	}
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
	 
			//校验行程
			List<ProdLineRoute> lineRouteList= checkRoute(productId);
			String routeFlag="false";
			if(lineRouteList!=null&&lineRouteList.size()>=1){
				routeFlag="true";
			}
			model.addAttribute("routeFlag", routeFlag);
			//校验行程明细
			String saveRouteFlag=checkRouteDetail(productId);
			model.addAttribute("saveRouteFlag", saveRouteFlag);
			
			//校验交通信息是否已经填写
			Boolean saveTransportFlag = prodTrafficService.checkTrafficDetial(productId);
			model.addAttribute("saveTransportFlag", saveTransportFlag.toString());
			
			ProdProduct prodProduct = MiscUtils.autoUnboxing(prodProductService.getProdProductBy(productId));
			LOG.info("@@@@@@#########packageType="+prodProduct.getPackageType()+"@@@@@@#########productType="+prodProduct.getProductType());
			//vst组织鉴权 
//			super.vstOrgAuthentication(LOG, prodProduct.getManagerIdPerm());
			 
			model.addAttribute("productType", prodProduct.getProductType());
			//出境-需要校验签证材料
			if("FOREIGNLINE".equals(prodProduct.getProductType())){
				String visaDocFlag=checkvisaDoc( productId);
				model.addAttribute("visaDocFlag", visaDocFlag);
			}
			model.addAttribute("productName", prodProduct.getProductName());
			model.addAttribute("categoryId", prodProduct.getBizCategoryId());
			model.addAttribute("packageType",prodProduct.getPackageType());
			model.addAttribute("categoryName", BizEnum.BIZ_CATEGORY_TYPE.getCnName(prodProduct.getBizCategoryId()));
			model.addAttribute("productBu", prodProduct.getBu());
			String bu = associationRecommendService
					.getBuOfProduct(productId, prodProduct.getBu(), categoryId,
							prodProduct.getPackageType());
			model.addAttribute("bu", bu);
			//校验“自动打包交通”属性和“是否使用被打包产品行程明细”属性
			ProdProductParam param = new ProdProductParam();
			param.setProductProp(true);
			param.setProductPropValue(true);
			ProdProduct product = MiscUtils.autoUnboxing(prodProductService.findProdProductById(productId, param));
			Map<String, Object> propMap =product.getPropValue();
			String auto_pack_traffic = "N";
			String isuse_packed_route_details = "Y";
			if(propMap != null){
				auto_pack_traffic = (String)propMap.get("auto_pack_traffic");
				isuse_packed_route_details = (String)propMap.get("isuse_packed_route_details");
			}
			
			//判断产品版本为1.0
			Double modelVesion=prodProduct.getModelVersion();
			if(modelVesion==null||modelVesion!=1.0){	
				model.addAttribute("modelVersion", "false");
			}else if(modelVesion==1.0){
				model.addAttribute("modelVersion", "true");
			}
			model.addAttribute("auto_pack_traffic", auto_pack_traffic);
			model.addAttribute("isuse_packed_route_details", isuse_packed_route_details);
			
			
			try {
				//判断是出境 跟团游 modelVersion不是1.0 编辑时设为无效
				if (isOutGroupAndunVersion(prodProduct)) {
					prodProduct.setCancelFlag("N");
					prodProductService.updateCancelFlag(prodProduct);
					model.addAttribute("modelVersionToNew", "true");
				}
			} catch (Exception e) {
				LOG.error(ExceptionFormatUtil.getTrace(e));
			}
		} else {
			model.addAttribute("productName", null);
		}
		return "/prod/packageTour/product/showProductMaintain";
	}
	
	/**
	 * 跳转到添加产品
	 * 
	 * @param model
	 * @param productId
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
		if (req.getParameter("categoryId") != null) {
			bizCategory = bizCategoryQueryService.getCategoryById(Long.valueOf(req.getParameter("categoryId")));
			bizCatePropGroupList = categoryPropGroupService.findCategoryPropGroupsAndCategoryProp(Long.valueOf(req.getParameter("categoryId")), true);
			//国内跟团游和国内当地游情况下显示私享团类型，其他情况过滤
			boolean selfEnjoyFlag = false;
			if ("15".equals(req.getParameter("categoryId").toString()) || "16".equals(req.getParameter("categoryId").toString())) {
				selfEnjoyFlag = true;
			}
			
			for (BizCatePropGroup bizCatePropGroup : bizCatePropGroupList) {
				if ((bizCatePropGroup.getBizCategoryPropList() != null) && (bizCatePropGroup.getBizCategoryPropList().size() > 0)) {
					for (BizCategoryProp bizCategoryProp : bizCatePropGroup.getBizCategoryPropList()) {
						Long propId = bizCategoryProp.getPropId();
						if (!selfEnjoyFlag) {//国内跟团游和国内当地游情况下显示私享团类型，其他情况过滤
							List<BizDict> bizDictList = bizCategoryProp.getBizDictList();
							if (CollectionUtils.isNotEmpty(bizDictList)) {
								for (int i = 0; i < bizDictList.size(); i++) {
									BizDict bizDict=bizDictList.get(i);
									if("私享团".equals(bizDict.getDictName())){
										bizDictList.remove(i);
									}
								}
							}
						}
						this.filterGuaranteeType(null, bizCategoryProp, req);
					}
				}
			}
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
//		model.addAttribute("bizCatePropGroupList", bizCatePropGroupList);
		//下单必填项
		model.addAttribute("travNumTypeList", BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.all());
		
		setModelAtrribute(model);
		
		//加载分销渠道的分销商
		ResultHandleT<TntGoodsChannelVo> tntGoodsChannelVoRt = tntGoodsChannelCouponServiceRemote
				.getChannels(TntGoodsChannelCouponAdapter.CH_TYPE.NONE.name());
		if(tntGoodsChannelVoRt != null && tntGoodsChannelVoRt.getReturnContent() != null){
			TntGoodsChannelVo tntGoodsChannelVo = (TntGoodsChannelVo)tntGoodsChannelVoRt.getReturnContent();
			model.addAttribute("tntGoodsChannelVo", tntGoodsChannelVo);
		}
		
		// 公司主体
		Map<String, String> companyTypeMap = new HashMap<String, String>();
		for (COMPANY_TYPE_DIC item : COMPANY_TYPE_DIC.values()) {
			companyTypeMap.put(item.name(), item.getTitle());
		}
		model.addAttribute("companyTypeMap", companyTypeMap);
		if (req.getParameter("subCategoryId") != null&&!req.getParameter("subCategoryId").equals("")) {//子分类id不为空
			Long subCategoryId = Long.valueOf(req.getParameter("subCategoryId"));
			WineSplitConstants.changeCateProp(subCategoryId, bizCatePropGroupList);
			model.addAttribute("subCategoryId",subCategoryId);
			model.addAttribute("bizCatePropGroupList", bizCatePropGroupList);
			List<BizCatePropGroup> subCatePropGroupList = null;		
			subCatePropGroupList = categoryPropGroupService.findCategoryPropGroupsAndCategoryProp(subCategoryId, true);		
			model.addAttribute("subCatePropGroupList", subCatePropGroupList);
			model.addAttribute("categoryId", req.getParameter("categoryId"));
			return "/prod/packageTour/product/showAddSubProduct";
		}
		//只有自由行 --机+酒才显示"驴色飞扬自驾"标志
		if(bizCategory!=null && bizCategory.getCategoryId()!=null){
			WineSplitConstants.changeTypeShow(bizCategory.getCategoryId(),bizCatePropGroupList);
		}
      
		model.addAttribute("categoryId", req.getParameter("categoryId"));
		model.addAttribute("bizCatePropGroupList", bizCatePropGroupList);
		}catch(Exception  e){
			LOG.error("Error on "+this.getClass().getName(), e);
	        model.addAttribute("errorMsg", "系统内部异常");
		}
		return "/prod/packageTour/product/showAddProduct";
	}
	
	
	/**
	 * 行程列表页面
	 * @param modelMap
	 * @param productId
	 * @param cancelFlag
	 * @return
	 */
	@RequestMapping(value = "/showUpdateRoute")
	public String showUpdateRoute(ModelMap modelMap, @Param("productId")Long productId, @Param("cancelFlag")String cancelFlag, @RequestParam(required=false)String embedFlag) {
		if(!("Y".equals(cancelFlag) || "N".equals(cancelFlag))) {
			cancelFlag = null;
		}
		modelMap.put("cancelFlag", cancelFlag);
		modelMap.put("embedFlag", "Y".equals(embedFlag) ? embedFlag : "N");
		
		//查询行程是否有关联行程，关联费用，关联合同，并在前台显示对应关联的入口（关联行程，关联费用，关联合同）
		
		ProdProductAssociation prodProductAssociation = prodProductAssociationService.getProdProductAssociationByProductId(productId);
		try{	
			if(prodProductAssociation != null&&(prodProductAssociation.getAssociatedRouteProdId() != null || prodProductAssociation.getAssociatedFeeIncludeProdId() != null || prodProductAssociation.getAssociatedContractProdId() != null)){
				if(prodProductAssociation.getAssociatedRouteProdId() != null){
					Long associationProductId = prodProductAssociation.getAssociatedRouteProdId();
					ProdLineRoute prodLineRoute = showAssociatedRoute(modelMap,associationProductId);
					modelMap.addAttribute("assLineRoute", prodLineRoute);
					modelMap.addAttribute("associatedRouteFlag", "true");
					ProdProduct lineProdProduct = prodProductService.findProdProductByProductId(associationProductId);
					modelMap.addAttribute("lineProdProduct", lineProdProduct);
				}
				if(prodProductAssociation.getAssociatedFeeIncludeProdId() != null){
					Long associationProductId = prodProductAssociation.getAssociatedFeeIncludeProdId();
					ProdLineRoute prodLineRoute = showAssociatedRoute(modelMap,associationProductId);
					modelMap.addAttribute("assFeeLineRoute", prodLineRoute);
					modelMap.addAttribute("associatedFeeFlag", "true");
					ProdProduct lineProdProduct = prodProductService.findProdProductByProductId(associationProductId);
					Double assModelVesion=lineProdProduct.getModelVersion();
					if(assModelVesion == null || assModelVesion != 1.0){	
						modelMap.put("assFeeModelVesion", "false");
					}else if(assModelVesion==1.0){
						modelMap.put("assFeeModelVesion", "true");
					}
					modelMap.addAttribute("feeProdProduct", lineProdProduct);
				}
				if(prodProductAssociation.getAssociatedContractProdId() != null){
					Long associationProductId = prodProductAssociation.getAssociatedContractProdId();
					ProdLineRoute prodLineRoute = showAssociatedRoute(modelMap,associationProductId);
					modelMap.addAttribute("assContractLineRoute", prodLineRoute);
					modelMap.addAttribute("associatedContractFlag", "true");
					ProdProduct lineProdProduct = prodProductService.findProdProductByProductId(associationProductId);
					Double assModelVesion=lineProdProduct.getModelVersion();
					if(assModelVesion==null||assModelVesion!=1.0){
						modelMap.put("asscontModelVesion", "false");
					}else if(assModelVesion==1.0){
						modelMap.put("asscontModelVesion", "true");
					}
					modelMap.addAttribute("contractProdProduct", lineProdProduct);
				}
			}else{
				//校验行程
				String routeFlag = checkLineRoute(productId);
				modelMap.addAttribute("routeFlag", routeFlag);
				//校验行程明细
				String saveRouteFlag=checkRouteDetail(productId);
				modelMap.addAttribute("saveRouteFlag", saveRouteFlag);
			}
		} catch (Exception e) {
			LOG.error(ExceptionFormatUtil.getTrace(e));
			LOG.error("PackageTourProductAction method:showUpdateRoute: productId="+productId+" prodProductAssociation:"+JSONObject.toJSONString(prodProductAssociation));
		}
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productId", productId);
		params.put("cancelFlag", cancelFlag);
		List<ProdLineRoute> prodLineRouteList = prodLineRouteService.findProdLineRouteByParams(params);
		modelMap.put("prodLineRouteList", prodLineRouteList);
		ProdProduct prodProduct = prodProductService.findProdProductByProductId(productId);
		modelMap.put("prodProduct", prodProduct);
		modelMap.put("packageType", ProdProduct.PACKAGETYPE.getCnName(prodProduct.getPackageType()));
		//出境-需要校验签证材料
		if("FOREIGNLINE".equals(prodProduct.getProductType())){
			String visaDocFlag=checkvisaDoc( productId);
			modelMap.addAttribute("visaDocFlag", visaDocFlag);
		}
		//判断产品版本为1.0(是供应商打包，类别为15)
		Double modelVesion=prodProduct.getModelVersion();
		if(modelVesion==null||modelVesion!=1.0){
			modelMap.put("modelVersion", "false");
		}else if(modelVesion==1.0){
			modelMap.put("modelVersion", "true");
		}
		//校验“自动打包交通”属性和“是否使用被打包产品行程明细”属性
		ProdProductParam param = new ProdProductParam();
		param.setProductProp(true);
		param.setProductPropValue(true);
		ProdProduct product = MiscUtils.autoUnboxing(prodProductService.findProdProductById(productId, param));
		Map<String, Object> propMap =product.getPropValue();
		String auto_pack_traffic = "N";
		String isuse_packed_route_details = "Y";
		if(propMap != null){
			auto_pack_traffic = (String)propMap.get("auto_pack_traffic");
			isuse_packed_route_details = (String)propMap.get("isuse_packed_route_details");
		}
		HttpServletLocalThread.getModel().addAttribute("auto_pack_traffic", auto_pack_traffic);
		HttpServletLocalThread.getModel().addAttribute("isuse_packed_route_details", isuse_packed_route_details);
		
		//判断是否为出境跟团游
		if (isOutGroupAndunVersion(prodProduct)) {
			HttpServletLocalThread.getModel().addAttribute("modelVersionToNew", "true");
		}
		return "/prod/route/showUpdateRoute";
	}
	
	/**
	 * 新增行程明细
	 * 
	 * @return
	 */
	@RequestMapping(value = "/addProdLineRouteDetail")
	@ResponseBody
	public Object addProdLineRouteDetail(ProdLineRoute prodLineRoute) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<addProdLineRouteDetail>"); 
		}
		
		Map<String, Object> attributes = new HashMap<String, Object>();
		boolean isSuccess=true;
		
		if (null==prodLineRoute||null==prodLineRoute.getProductId()) {
			throw new BusinessException("非法请求参数");
		}
		
		try {
			prodLineRouteDetailService.saveProdLineRouteDetail(prodLineRoute);
			
			Long productId = prodLineRoute.getProductId();
			attributes.put("productId", productId);
			
//			ProdProductParam param = new ProdProductParam();
//			param.setBizCategory(true);
//			ProdProduct product = prodProductService.findProdProductById(productId,param);
			ProdProduct product = MiscUtils.autoUnboxing(prodProductService.getProdProductBy(productId));
			attributes.put("categoryId", product.getBizCategoryId());
			attributes.put("categoryName", bizCategoryQueryService.getCategoryById(product.getBizCategoryId()).getCategoryName());
			attributes.put("productName", product.getProductName());
			
		} catch (Exception e) {
			LOG.error(ExceptionFormatUtil.getTrace(e));
			LOG.error("Push info failure ！Push Type:"+ComPush.OBJECT_TYPE.PRODUCT.name()+" ID:"+prodLineRoute.getProductId());
			isSuccess=false;
		}
		
		 //日志
		 for(ProdLineRouteDetail prodLineRouteDetail : prodLineRoute.getProdLineRouteDetailList()){
		    	logLineRouteOperate(prodLineRoute,"更新行程明细："+getProdLineRouteDetailLog(prodLineRouteDetail),"更新行程明细");
		    }   
			
		 
		if(!isSuccess)
		{
			throw new BusinessException("行程明细保存失败");
		}
		return new ResultMessage(attributes, "success", "行程保存成功");
	}
	
	@RequestMapping(value = "/deleteProdLineRouteDetail")
	@ResponseBody
	public Object deleteProdLineRouteDetail(Long detailId,Long routeId,Long productId) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<deleteProdLineRouteDetail>");
		}
		
		Map<String, Object> attributes = new HashMap<String, Object>();
		boolean isSuccess=true;
		
		if (null==detailId || null==routeId) {
			throw new BusinessException("非法请求参数");
		}
		ProdLineRouteDetail prodLineRouteDetail = MiscUtils.autoUnboxing(prodLineRouteDetailService.findByPrimaryKey(detailId));
		try {
			pushAdapterService.push(productId, ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_LINE_ROUTE_DETAIL,ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
			
			prodLineRouteDetailService.deleteByDetailId(detailId,routeId);
			
		} catch (Exception e) {
			LOG.error(ExceptionFormatUtil.getTrace(e));
			LOG.error("Push info failure ！Push Type:"+ComPush.OBJECT_TYPE.PRODUCT.name()+" ID:"+productId);
			isSuccess=false;
		}
		//日志
		ProdLineRoute prodLineRoute=new ProdLineRoute();
		prodLineRoute.setProductId(productId);
		prodLineRoute.setLineRouteId(routeId);
		logLineRouteOperate(prodLineRoute,"删除行程明细:"+getProdLineRouteDetailLog(prodLineRouteDetail),"删除行程明细");
		if(!isSuccess)
		{
			throw new BusinessException("行程明细保存失败");
		}
		return new ResultMessage(attributes, "success", "删除行程成功");
	}
	
	
	/**
	 * 新增产品
	 * 
	 * @return
	 */
	@RequestMapping(value = "/addProduct")
	@ResponseBody
	public Object addProduct(ProdProduct prodProduct, ComOrderRequired comOrderRequired, String comOrderRequiredFlag, 
			HttpServletRequest req, String distributorUserIds, String docIds) throws BusinessException {
		if (LOG.isDebugEnabled()) { 
			LOG.debug("start method<addProduct>");
		}
		
		String packTitle = req.getParameter("packTitle");
		String logForProductOrigin = null;
		
		if(StringUtils.isEmpty(prodProduct.getProductName())&&StringUtils.isNotEmpty(packTitle)){
			String oldProductName = productRename(packTitle);
			prodProduct.setProductName(oldProductName);
			prodProduct.setProductNameStruct(packTitle);
			logForProductOrigin = prodProduct.getProductOrigin();
		}
		
		if (prodProduct.getBizCategoryId()!=null) {
			//判断子品类是否存在
			if(prodProduct.getSubCategoryId()!=null){
				BizCategory subCategory  = bizCategoryQueryService.getCategoryById(prodProduct.getSubCategoryId());
				if(subCategory==null){
					return new ResultMessage("error", "保存失败, 子品类不存在！");
				}
			}
			String productType = prodProduct.getProductType();
			//交通+服务版本号设为旧版 （自由行只有机酒新增 版本号为1.0）
			if((ProdProduct.PRODUCTTYPE.INNERLINE.name().equals(productType)&&prodProduct.getSubCategoryId()!=null && prodProduct.getSubCategoryId()==182L)
					||ProdProduct.PRODUCTTYPE.INNERLONGLINE.name().equals(productType)||ProdProduct.PRODUCTTYPE.INNERSHORTLINE.name().equals(productType)||ProdProduct.PRODUCTTYPE.INNER_BORDER_LINE.name().equals(productType)){
				//设置版本号
				prodProduct.setModelVersion(ProdProduct.MODEL_VERSION_1D0);
			}
			if((ProdProduct.PRODUCTTYPE.FOREIGNLINE.name().equalsIgnoreCase(productType)) &&  Long.valueOf(15L).equals(prodProduct.getBizCategoryId())){
				//设置版本号
				prodProduct.setModelVersion(ProdProduct.MODEL_VERSION_1D0);
			}
			// 默认打开出游人后置开关(包括出境跟团)
			Long bizCategoryId = prodProduct.getBizCategoryId().longValue();
			//关闭国内游玩人后置
			if(bizCategoryId == 15L && ProdProduct.PRODUCTTYPE.FOREIGNLINE.name().equals(productType)){
				prodProduct.setTravellerDelayFlag("Y");
			}
			//保存产品和自动创建产品规格
			prodProduct.setAuditStatus(ProdProduct.AUDITTYPE.AUDITTYPE_TO_PM.name());
			//prodProduct.setCancelFlag("N");
			prodProduct.setCreateUser(this.getLoginUserId());
			long id = prodProductServiceAdapter.saveProdProduct(prodProduct);
			prodProduct.setProductId(id);

			
			//保存产品关联数据
			prodProductServiceAdapter.saveProdProductReData(prodProduct);
			
			//此处双写 产品名称 结构化信息
			if (prodProduct.getProdProductNameVO() != null) {
				ProdProductDescription productNameDesc = new ProdProductDescription();
				productNameDesc.setCategoryId(prodProduct.getBizCategoryId());
				productNameDesc.setProductId(prodProduct.getProductId());
				productNameDesc.setProductType(prodProduct.getProductType());
				productNameDesc.setContentType(ProdProductDescription.CONTENT_TYPE.PRODUCT_NAME.name());
				String jsonStr = JSONObject.toJSONString(prodProduct.getProdProductNameVO());
				productNameDesc.setContent(jsonStr);
				prodProductDescriptionService.saveOrUpdateDoublePlaceForProductDes(productNameDesc);
			}
			
			
			//保存下单必填项
			if("Y".equals(comOrderRequiredFlag)){
				comOrderRequired.setObjectType(ComOrderRequired.OBJECTTYPE.PROD_PROCUT.name());
				comOrderRequired.setObjectId(id);
				comOrderRequiredService.saveComOrderRequired(comOrderRequired);
			}
			// 清除缓存 
			//基本信息
			MemcachedUtil.getInstance().remove(MemcachedEnum.ProdProductSingle.getKey() + prodProduct.getProductId());
			//产品属性
			MemcachedUtil.getInstance().remove(MemcachedEnum.ProductWithPropList.getKey() + prodProduct.getProductId());
			
			// 新增产品的销售渠道
			String[] distributorIds = req.getParameterValues("distributorIds");
			String[] distUserNames =req.getParameterValues("distUserNames");
			String logContent = distDistributorProdService.saveOrUpdateDistributorProd(id,distributorIds);
			if(distUserNames!=null){
				logContent=logContent+"分销商为："+Arrays.toString(distUserNames);
			}
			if(StringUtils.isNotEmpty(logForProductOrigin)){
				logContent += logForProductOrigin;
			}
			
			distDistributorProdService.pushSuperDistributor(prodProduct, distributorUserIds);
			
			//添加签证材料与产品关联
			if(StringUtil.isNotEmptyString(docIds)){
				for(String docId : docIds.split(",")){
					ProdVisadocRe prodVisadocRe = new ProdVisadocRe();
					prodVisadocRe.setVisaDocId(Long.parseLong(docId));
					prodVisadocRe.setProductId(prodProduct.getProductId());
					prodVisadocReService.addProdVisadocRe(prodVisadocRe);
				}
			}
			
			//跟团游 自由行发送消息，计算交通 酒店信息
//			pushAdapterService.push(prodProduct.getProductId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_PRODUCT,ComPush.OPERATE_TYPE.ADD, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
			//供应商打包，181 182 183多出发地入库(总产子销)
			Long categoryId = prodProduct.getBizCategoryId();
			Long subCategoryId = prodProduct.getSubCategoryId();
			String multiToStartPointIds = req.getParameter("multiToStartPointIds");
			if("SUPPLIER".equals(prodProduct.getPackageType())&&"FOREIGNLINE".equals(prodProduct.getProductType())
					&&(BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCategoryId().equals(categoryId) ||
					(BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCategoryId().equals(categoryId)&&(Long.valueOf(181).equals(subCategoryId)||Long.valueOf(182).equals(subCategoryId)||Long.valueOf(183).equals(subCategoryId))))){
				//删除老的行程
				prodStartDistrictDetailService.deleteStartDistrictDetailByProductId(id);
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
						prodStartDistrictDetail.setProductId(id);
						startDistrictDetailList.add(prodStartDistrictDetail);
					}
					prodStartDistrictDetailService.saveBatchStartDistrictDetailList(startDistrictDetailList);
				}
			}
			//自主打包，标记为自产产品
			if("LVMAMA".equals(prodProduct.getPackageType())){
				ProdAdditionFlag prodAdditionFlagold=MiscUtils.autoUnboxing(prodAdditionFlagService.selectByProductId(prodProduct.getProductId()));
				if(prodAdditionFlagold !=null){
					prodAdditionFlagold.setSelfFlag("Y");
					prodAdditionFlagService.updateProdAdditionFlagByPrimaryKey(prodAdditionFlagold);
				}else{
					ProdAdditionFlag prodAdditionFlag = new ProdAdditionFlag();
					prodAdditionFlag.setProductId(prodProduct.getProductId());
					prodAdditionFlag.setSelfFlag("Y");
					prodAdditionFlagService.insertProdAdditionFlag(prodAdditionFlag);
				}
				MemcachedUtil.getInstance().set(MemcachedEnum.SelfProductFlag.getKey() + prodProduct.getProductId(), MemcachedEnum.SelfProductFlag.getSec(),"Y");
			}
			//酒店套餐、景酒品类新增产品默认添加驴妈妈自营标签
			try{
				if((prodProduct.getBizCategoryId()==17L || (prodProduct.getBizCategoryId()==18L && prodProduct.getSubCategoryId()==181L)) && "INNERLINE".equals(prodProduct.getProductType()) ){
					ResultHandleT<BizTag> bizTagResultHandleT=tagClientService.findBizTagById(3749L);
					if(bizTagResultHandleT !=null && bizTagResultHandleT.getReturnContent() !=null){
						BizTag bizTag=bizTagResultHandleT.getReturnContent();
						ProdTag prodTag = new ProdTag();
						prodTag.setObjectId(prodProduct.getProductId());
						prodTag.setObjectType("PROD_PRODUCT");
						prodTag.setTagId(bizTag.getTagId());
						prodTag.setStartTime(new Date());
						//结束时间产品说先这么写
						prodTag.setEndTime(DateUtil.converDateFromStr4("2037-12-31"));
						prodTag.setDisplaytype(3L);
						ResultHandleT<Integer> integerResultHandleT = prodTagClientService.addProdTag(prodTag, true);
						if(integerResultHandleT == null || integerResultHandleT.isFail()){
							log.error("新增产品："+prodProduct.getProductId()+"初始化驴妈妈自营标签失败："+integerResultHandleT.getMsg());
						}
					}
				}
			}catch (Exception e){
				log.error("新增产品："+prodProduct.getProductId()+"初始化驴妈妈自营标签出错："+e.getMessage());
			}
			Map<String, Object> attributes = new HashMap<String, Object>();
			attributes.put("productId", id);
			attributes.put("productName", prodProduct.getProductName());
			attributes.put("categoryName", prodProduct.getBizCategory().getCategoryName());
			attributes.put("productType", prodProduct.getProductType());
			attributes.put("packageType", prodProduct.getPackageType());
			//添加操作日志
			try {
				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, 
						prodProduct.getProductId(), prodProduct.getProductId(), 
						this.getLoginUser().getUserName(), 
						"添加了产品：【"+prodProduct.getProductName()+"】"+logContent, 
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
	 * 跳转到修改页面
	 * @return
	 */
	@RequestMapping(value = "/showUpdateProduct")
	public String showUpdateProduct(Model model, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showUpdateProduct>");
		}
		model.addAttribute("userName", this.getLoginUser().getUserName());
		ProdProduct prodProduct = null;
		List<BizCatePropGroup> bizCatePropGroupList = null;
		//判断是否点击条款菜单响应
		String suggestionType = req.getParameter("suggestionType");
		
		if (req.getParameter("productId") != null) {
			Map<String, Object> parameters = new HashMap<String, Object>();
			parameters.put("productId", req.getParameter("productId"));
			ProdProductParam param = new ProdProductParam();
			param.setBizCategory(true);
			param.setBizDistrict(true);
			param.setProductProp(true);
			param.setProductPropValue(true);
			prodProduct =MiscUtils.autoUnboxing(prodProductService.findProdProductById(Long.valueOf(req.getParameter("productId")),param));
//			if(prodProduct!=null && StringUtils.isNotEmpty(prodProduct.getProductNameStruct()) && prodProduct.getSubCategoryId()!=181L){
//				String title = prodProduct.getProductNameStruct();
//				if(title.contains("#")){
//					String[] splitTitle = title.split("#");
//					model.addAttribute("promTitle", splitTitle[0]);
//					model.addAttribute("mainTitle", splitTitle[1]);
//					model.addAttribute("subTitle", splitTitle[2]);
//					LOG.info("product with id="+req.getParameter("productId")+" promTitle="+splitTitle[0]+ " mainTitle="+splitTitle[1]+" subTitle="+splitTitle[2]);
//				}
//			}
			
		
			//用于前台校验“自动打包交通”属性和“是否使用被打包产品行程明细”属性
			Map<String, Object> propMap =prodProduct.getPropValue();
			String auto_pack_traffic = "N";
			String isuse_packed_route_details = "Y";
			if(propMap != null){
				auto_pack_traffic = (String)propMap.get("auto_pack_traffic");
				isuse_packed_route_details = (String)propMap.get("isuse_packed_route_details");
			}
			model.addAttribute("auto_pack_traffic", auto_pack_traffic);
			model.addAttribute("isuse_packed_route_details", isuse_packed_route_details);
			
			if(StringUtil.isEmptyString(suggestionType)){
				findManagerNameById(prodProduct);
				//查询关联数据
				prodProductServiceAdapter.findProdProductReData(prodProduct);
				
				//加载产品自动创建的规格
			}
			
			if (prodProduct != null) {
				//判断产品版本为1.0(是供应商打包，类别为15)
				Double modelVesion=prodProduct.getModelVersion();
				if(modelVesion==null||modelVesion!=1.0){
					model.addAttribute("modelVersion", "false");
				}else if(modelVesion==1.0){
					model.addAttribute("modelVersion", "true");
				}
				//产品名称结构化信息
				Map<String,Object> productNameParam = new HashMap<String, Object>();
				productNameParam.put("productId", prodProduct.getProductId());
				productNameParam.put("productType", prodProduct.getProductType());
				productNameParam.put("contentType", ProdProductDescription.CONTENT_TYPE.PRODUCT_NAME.name());
				List<ProdProductDescription> productDescriptionList =MiscUtils.autoUnboxing(prodProductDescriptionService.findProductDescriptionListByParams(productNameParam));
				//接收产品名称
				ProdProductNameVO productNameVo = new ProdProductNameVO();
				if (CollectionUtils.isNotEmpty(productDescriptionList)) {
					for (ProdProductDescription productDescription : productDescriptionList) {
						String contentType = productDescription.getContentType();
						String content = productDescription.getContent();
						if (StringUtil.isEmptyString(content)) {
							continue;
						}
						if (ProdProductDescription.CONTENT_TYPE.PRODUCT_NAME.name().equals(contentType)) {
							productNameVo = JSONObject.parseObject(content, ProdProductNameVO.class);
						}
					}
				}
				model.addAttribute("prodProductNameVo", productNameVo);
				
				bizCatePropGroupList = categoryPropGroupService.findCategoryPropGroupsAndCategoryProp(prodProduct.getBizCategory().getCategoryId(), false);
				if ((bizCatePropGroupList != null) && (bizCatePropGroupList.size() > 0)) {
					//供应商打包过滤 交通自动打包组的属性（105 跟团/106自由行）
					List<BizCatePropGroup> tempBizCatePropGroupList=new ArrayList<BizCatePropGroup>();
					for (BizCatePropGroup bizCatePropGroup : bizCatePropGroupList) {
						if(ProdProduct.PACKAGETYPE.SUPPLIER.getCode().equals(prodProduct.getPackageType())){
							if(bizCatePropGroup.getGroupId()!=null
									&&(105==bizCatePropGroup.getGroupId().longValue()||106==bizCatePropGroup.getGroupId().longValue())){
								continue;
							}
						}
						tempBizCatePropGroupList.add(bizCatePropGroup);
					}
					
					//国内跟团游和国内当地游情况下显示私享团类型，其他情况过滤
					boolean selfEnjoyFlag = false;
	        		if (prodProduct.getBizCategoryId()!=null && prodProduct.getProductType()!=null) {
	        			if ("15".equals(prodProduct.getBizCategoryId().toString()) || "16".equals(prodProduct.getBizCategoryId().toString())) {
	        				if (ProdProduct.PRODUCTTYPE.INNERLINE.toString().equals(prodProduct.getProductType()) ||
	        						ProdProduct.PRODUCTTYPE.INNERSHORTLINE.toString().equals(prodProduct.getProductType()) ||
	        						ProdProduct.PRODUCTTYPE.INNERLONGLINE.toString().equals(prodProduct.getProductType()) ||
	        						ProdProduct.PRODUCTTYPE.INNER_BORDER_LINE.toString().equals(prodProduct.getProductType())) {
	        					selfEnjoyFlag = true;
	        				}
	        			}
	        		}
					
					bizCatePropGroupList=tempBizCatePropGroupList;
					for (BizCatePropGroup bizCatePropGroup : bizCatePropGroupList) {
						if ((bizCatePropGroup.getBizCategoryPropList() != null) && (bizCatePropGroup.getBizCategoryPropList().size() > 0)) {
							
							for (BizCategoryProp bizCategoryProp : bizCatePropGroup.getBizCategoryPropList()) {
								
								Map<String, Object> parameters2 = new HashMap<String, Object>();
								Long propId = bizCategoryProp.getPropId();
								parameters2.put("productId", req.getParameter("productId"));
								parameters2.put("propId", propId);
								
								List<ProdProductProp> prodProductPropList =MiscUtils.autoUnboxing(prodProductPropService.findProdProductPropList(parameters2));
								bizCategoryProp.setProdProductPropList(prodProductPropList);
								if (!selfEnjoyFlag) {//国内跟团游和国内当地游情况下显示私享团类型，其他情况过滤
									List<BizDict> bizDictList = bizCategoryProp.getBizDictList();
									if (CollectionUtils.isNotEmpty(bizDictList)) {
										for (int i = 0; i < bizDictList.size(); i++) {
											BizDict bizDict=bizDictList.get(i);
											if("私享团".equals(bizDict.getDictName())){
												bizDictList.remove(i);
											}
										}
									}
								}
								this.filterGuaranteeType(prodProduct, bizCategoryProp, null);
							}
						}
					}
				}
				
				
				
				if(null != prodProduct.getAttributionId()){
					Attribution attribution = attributionService.findAttributionById(prodProduct.getAttributionId());
					if(null != attribution){
						prodProduct.setAttributionName(attribution.getAttributionName());
					}
				}
				//用于判断前台是否展示按份售卖
			    VST_CATEGORY routeFreedom = Constant.VST_CATEGORY.CATEGORY_ROUTE_FREEDOM;
			    String showSaleTypeFlag = routeFreedom.getCategoryId().equals(prodProduct.getBizCategoryId().toString()) ? "YES" : "NO";
				model.addAttribute("showSaleTypeFlag", showSaleTypeFlag);
				model.addAttribute("copiesList", ProdProductSaleRe.COPIES.values());
				//查看是否打包酒店套餐
				if(!CollectionUtils.isEmpty(prodProduct.getProdProductSaleReList())){
					model.addAttribute("isPackageGroupHotel", isPackageGroupHotel(prodProduct));
				}
				
			}
			

			//取得签证材料与产品关联
			HashMap<String, Object> params = new HashMap<String, Object>();
			params.put("productId", req.getParameter("productId"));
			List<ProdVisadocRe> prodVisadocReList = prodVisadocReService.findProdVisadocReByParams(params);
			params.clear();
			StringBuilder docIds = new StringBuilder(",");
			if(prodVisadocReList != null && prodVisadocReList.size() > 0){
				for(ProdVisadocRe prodVisadocRe : prodVisadocReList){
					params.put("docId", prodVisadocRe.getVisaDocId());
					docIds.append(prodVisadocRe.getVisaDocId()).append(",");
				}
				params.clear();
				params.put("docIds", docIds.toString().split(","));
				List<BizVisaDoc> bizVisaDocList = visaDocService.findBizVisaDoc(params);
				model.addAttribute("docIds", docIds);
				model.addAttribute("bizVisaDocList", bizVisaDocList);
			}
			
			//查询签证类型\送签城市字典
			params.clear();
			params.put("dictCode", "VISA_TYPE");
			List<BizDictExtend> vistTypeList = dictService.findBizDictExtendList(params);
			params.clear();
			params.put("dictCode", "VISA_CITY");
			List<BizDictExtend> vistCityList = dictService.findBizDictExtendList(params);
			model.addAttribute("vistTypeList", vistTypeList);
			model.addAttribute("vistCityList", vistCityList);
			
			//上级目的地查询
			if(prodProduct.getSubCategoryId() == null || prodProduct.getSubCategoryId().longValue()!=(long)181){
				if(prodProduct.getBizCategoryId().longValue()!=(long)17){
					List<ProdDestRe> prodDestReList = prodProduct.getProdDestReList();
					List<BizDest> bizDestList = new ArrayList<BizDest>();
					if(prodDestReList!=null){
						for(ProdDestRe prodDestRe:prodDestReList){
							BizDest bizDest =new BizDest();
							BizDest bizDestParent = new BizDest();
							bizDest.setDestId(prodDestRe.getDestId());
							bizDest.setParentDest(bizDestParent);
							bizDestList.add(bizDest);
						}
					}
					Map<String,Object> parametersParent =new HashMap<String,Object>();    
					bizDestList = destService.setParentsDestNameInfo(bizDestList,parametersParent);
					StringBuffer sb = new StringBuffer();
					for(BizDest bizDest:bizDestList){
					 for(ProdDestRe prodDestRe:prodDestReList){
						 if(prodDestRe.getDestId().longValue()==bizDest.getDestId().longValue()){
							String[] array =  bizDest.getParentDest().getDestName().split("--");
							array[array.length-1] = null;
							for(String i:array){
								if(i!=null){
									sb.append(i+"--");
								}
							}
							if(sb.length() > 0){
								sb.delete(sb.lastIndexOf("--"),sb.length());
							}
							
							prodDestRe.setParentDestName(sb.toString());
							
							if(sb!=null){
								sb.delete(0, sb.length());
							}
						 }
					 }
				}

				}
			}
			
			//加载分销渠道的分销商
			ResultHandleT<TntGoodsChannelVo> tntGoodsChannelVoRt = tntGoodsChannelCouponServiceRemote
					.getChannels(TntGoodsChannelCouponAdapter.CH_TYPE.NONE.name());
			if(tntGoodsChannelVoRt != null && tntGoodsChannelVoRt.getReturnContent() != null){
				TntGoodsChannelVo tntGoodsChannelVo = (TntGoodsChannelVo)tntGoodsChannelVoRt.getReturnContent();
				model.addAttribute("tntGoodsChannelVo", tntGoodsChannelVo);
			}
			
			ResultHandleT<Long[]> userIdLongRt = tntGoodsChannelCouponServiceRemote.list(Long.parseLong(req.getParameter("productId")),
					null, TntGoodsChannelCouponAdapter.PG_TYPE.PRODUCT.name());
			if(userIdLongRt != null && userIdLongRt.getReturnContent() != null && userIdLongRt.isSuccess()){
				Long[] userIdLong = (Long[])userIdLongRt.getReturnContent();
				StringBuilder userIdLongStr = new StringBuilder(",");
				for(Long userId : userIdLong){
				    userIdLongStr.append(userId.toString()).append(",");
				}
				model.addAttribute("userIdLongStr", userIdLongStr.toString());
			}
		}
		//判断是否组合套餐票打包
		if(prodProduct != null){
			Map<String, Object> packGroupParams = new HashMap<String, Object>();
			packGroupParams.put("productId", prodProduct.getProductId());
			packGroupParams.put("categoryId",13L);
			packGroupParams.put("muiltDpartureFlag",
					prodProduct.getMuiltDpartureFlag());
			packGroupParams.put("groupType", ProdPackageGroup.GROUPTYPE.LINE_TICKET.name());
			List<ProdPackageGroup>  packGroupList = prodLineGroupPackService
					.findProdLinePackGroupByParams(packGroupParams);
			if(packGroupList.size()>0)
			{
				prodProduct.setCategoryCombTicket("true");
			}
		}

		// 下单必填项
		Map<String, Object> param = new HashMap<String, Object>();
		List<BizOrderRequired> bizOrderRequiredList = bizOrderRequiredService.selectByExample(param);
		model.addAttribute("bizOrderRequiredList", bizOrderRequiredList);
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("objectType", ComOrderRequired.OBJECTTYPE.PROD_PROCUT.name());
		parameters.put("objectId", req.getParameter("productId"));
		List<ComOrderRequired> comOrderRequiredList = comOrderRequiredService.findComOrderRequiredList(parameters);
		if(comOrderRequiredList!=null && comOrderRequiredList.size()>0){
			model.addAttribute("comOrderRequired", comOrderRequiredList.get(0));
		}
		model.addAttribute("travNumTypeList", BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.all());
		model.addAttribute("prodProduct", prodProduct);
		if(prodProduct != null && prodProduct.getBizCategory() != null){
		    model.addAttribute("categoryName", prodProduct.getBizCategory().getCategoryName());
		}
		if (prodProduct != null && prodProduct.getSubCategoryId() != null) {//子分类id不为空
			Long subCategoryId = prodProduct.getSubCategoryId();
			WineSplitConstants.changeCateProp(subCategoryId, bizCatePropGroupList);
			List<BizCatePropGroup> subCatePropGroupList = null;
			subCatePropGroupList = categoryPropGroupService.findCategoryPropGroupsAndCategoryProp(prodProduct.getSubCategoryId(), false);
			if ((subCatePropGroupList != null) && (subCatePropGroupList.size() > 0)) {
				for (BizCatePropGroup bizCatePropGroup : subCatePropGroupList) {
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
			model.addAttribute("subCatePropGroupList", subCatePropGroupList);
		}else{
			//如果不是 自由行—景+酒产品  则前台不显示"驴色飞扬自驾"标志
			if(prodProduct!=null && prodProduct.getBizCategoryId()!=null){
				WineSplitConstants.changeTypeShow(prodProduct.getBizCategoryId(),bizCatePropGroupList);
			}
        }
		//酒店套餐，判断bu
//		if(prodProduct != null && prodProduct.getBizCategory() != null && "category_route_hotelcomb".equals(prodProduct.getBizCategory().getCategoryCode())){
//			SuppGoods suppGoods = suppGoodsService.findBaseSuppGoodsByProductId(prodProduct.getProductId());
//			if(suppGoods != null){
//				model.addAttribute("suppGoodsBu", suppGoods.getBu());
//			}
//		}
		model.addAttribute("bizCatePropGroupList", bizCatePropGroupList);
		model.addAttribute("productId", req.getParameter("productId"));
		setModelAtrribute(model);
		
		//电子合同
		if(prodProduct != null){
    		ProdEcontract econtract = prodEcontractService.selectByProductId(prodProduct.getProductId());
    		model.addAttribute("econtract", econtract);
		}
		
		// 公司主体
		Map<String, String> companyTypeMap = new HashMap<String, String>();
		for (COMPANY_TYPE_DIC item : COMPANY_TYPE_DIC.values()) {
			companyTypeMap.put(item.name(), item.getTitle());
		}
		model.addAttribute("companyTypeMap", companyTypeMap);
		model.addAttribute("categoryId", prodProduct.getBizCategoryId());
		
		//提前获取产品供应商或上级供应商名称以便修改组团方式时及时取值
		if(null!=req.getParameter("productId")){
			findsuppSupplierName(model, Long.valueOf(req.getParameter("productId")));
		}
		
		
		if(prodProduct != null){
			//所属品类
			model.addAttribute("bizCategory", this.getBizCategoryById(prodProduct.getBizCategoryId()));
		}
		
		if(ProdProduct.PACKAGETYPE.LVMAMA.name().equalsIgnoreCase(prodProduct.getPackageType()) && 
				(15L == prodProduct.getBizCategoryId().longValue() || (18L == prodProduct.getBizCategoryId().longValue() && 181L != prodProduct.getSubCategoryId().longValue()))){
			model.addAttribute("validNewHotelPriceRule", validNewHotelPriceRule(prodProduct.getProductId()));
		}
		if("Y".equals(prodProduct.getIsMuiltDeparture())){
			//得到供应商打包多出发地的数据
			List<BizDistrict> bizDistricts = prodPackageDetailService.findDistrictList(prodProduct.getProductId());
			if(CollectionUtils.isNotEmpty(bizDistricts)) {
				model.addAttribute("startDistricts", JSON.toJSONString(bizDistricts));
			}
		}
		if("Y".equals(suggestionType)
				&&((BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCategoryId().equals(prodProduct.getBizCategoryId())
				    || BizEnum.BIZ_CATEGORY_TYPE.category_route_local.getCategoryId().equals(prodProduct.getBizCategoryId()))
				    && !"FOREIGNLINE".equalsIgnoreCase(prodProduct.getProductType()))){
			ProdReserveLimit prodReserveLimit = new ProdReserveLimit();
			ProdProductDescription productDescription = new ProdProductDescription();
			Map<String, Object> params = new HashMap<>();
			params.put("productId", prodProduct.getProductId());
			params.put("contentType", ProdProductDescription.CONTENT_TYPE.RESERVE_LIMIT.name());
			List<ProdProductDescription> productDescriptionList = MiscUtils.autoUnboxing(prodProductDescriptionService.findProductDescriptionListByParams(params));
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
		if(StringUtil.isEmptyString(suggestionType)){
			if (prodProduct != null && prodProduct.getSubCategoryId() != null) {
				return "/prod/packageTour/product/showUpdateSubProduct";
			}
			return "/prod/packageTour/product/showUpdateProduct";
		}else{
			return "/prod/packageTour/product/showProductSugg";
		}
	}

	
	private void filterGuaranteeType(ProdProduct product, BizCategoryProp prop, HttpServletRequest req){
		
		Long subCategoryId = null;
		Long categoryId = null;
		if(product != null) {
			subCategoryId = product.getSubCategoryId();
			categoryId = product.getBizCategoryId();
		} else if (req != null) {
			String _subCategoryId = req.getParameter("subCategoryId");
			String _categoryId = req.getParameter("categoryId");
			try {
				if (_categoryId != null && !_categoryId.isEmpty()) {
					categoryId = Long.valueOf(_categoryId);
				}
				if (_subCategoryId != null && !_subCategoryId.isEmpty()) {
					subCategoryId = Long.valueOf(_subCategoryId);
				}
			} catch (Exception e) {
				this.log.error(e.getMessage(), e);
			}
		}
		
		if(categoryId == null) {
			return ;
		}
		
		boolean needFilter = Long.valueOf(17L).equals(categoryId)
				|| Long.valueOf(181L).equals(subCategoryId);
		if(needFilter && "type".equals(prop.getPropCode())){
			List<BizDict> dictList = prop.getBizDictList();
			if(dictList != null) {
				for (int i = dictList.size() -1 ; i >= 0;  i--) {
					BizDict dict = dictList.get(i);
					if("逍遥驴行".equals(dict.getDictName()) || "开心驴行".equals(dict.getDictName())){
						dictList.remove(i);
					}
				}
			}
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
	
	private void findsuppSupplierName(Model model,long productId){
		//提前获取产品供应商或上级供应商名称以便修改组团方式时及时取值
		SuppGoods suppGoods = suppGoodsService.findBaseSuppGoodsByProductId(productId);
		if(suppGoods!=null){
			ResultHandleT<SuppSupplier> resultHandleT1 = suppSupplierClientService.findSuppSupplierById(suppGoods.getSupplierId());
			if(resultHandleT1 == null || resultHandleT1.isFail()){
				log.error(resultHandleT1.getMsg());
				throw new BusinessException(resultHandleT1.getMsg());
			}
			SuppSupplier suppSupplier = resultHandleT1.getReturnContent();
			//SuppSupplier suppSupplier = suppSupplierService.findSuppSupplierById(suppGoods.getSupplierId());
			if(suppSupplier!=null){
				if("2".equals(suppSupplier.getSupplierLevelType())){
					if(suppSupplier.getFatherId()!=null&&suppSupplier.getFatherId()!=0L){
						ResultHandleT<SuppSupplier> resultHandleT2 = suppSupplierClientService.findSuppSupplierById(suppSupplier.getFatherId());
						if(resultHandleT2 == null || resultHandleT2.isFail()){
							log.error(resultHandleT2.getMsg());
							throw new BusinessException(resultHandleT2.getMsg());
						}
						suppSupplier = resultHandleT2.getReturnContent();
						//suppSupplier=suppSupplierService.findSuppSupplierById(suppSupplier.getFatherId());
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
	 * 更新产品
	 * 
	 * @return
	 * @throws 
	 */
	@RequestMapping(value = "/updateProduct")
	@ResponseBody
	public Object updateProduct(ProdProduct prodProduct, ComOrderRequired comOrderRequired, String distributorUserIds,
			HttpServletRequest req, String docIds, String oldDocIds) {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<updateProduct>");
		}
		
		String packTitle = req.getParameter("packTitle");
		String logForProductOrigin = null;
		
		if(StringUtils.isNotEmpty(packTitle)){
			if(prodProduct.getProductOrigin()!=null){
				if(prodProduct.getProductOrigin().equals("DISNEY")||prodProduct.getProductOrigin().equals("CHANGLONG")){
					LOG.info("产品为老数据，且后续操作为 "+ prodProduct.getProductOrigin());
					//prodProductService.updateByPrimaryKeySelective(prodProduct);
					//切成迪士尼产品和长隆产品后，结构化字段被置为空
					prodProduct.setProductNameStruct("");
				}else{
					String oldProductName = productRename(packTitle);
					prodProduct.setProductName(oldProductName);
					prodProduct.setProductNameStruct(packTitle);
					logForProductOrigin = prodProduct.getProductOrigin();
					//prodProductService.updateByPrimaryKeySelective(prodProduct);
				}
			}
		}
 		if(prodProduct.getProdProductNameVO()!=null &&prodProduct.getBizCategoryId()==18L&&prodProduct.getSubCategoryId()!=null&&prodProduct.getSubCategoryId()==181L){
			if("DESTINATION_BU".equals(prodProduct.getBu()) && "INNERLINE".equals(prodProduct.getProductType())){
				if(StringUtils.isNotEmpty(prodProduct.getProdProductNameVO().getJjDestDay())){
					prodProduct.setProductName(prodProduct.getProdProductNameVO().getJjDestDay()+" "+prodProduct.getProdProductNameVO().getJjTitle());
				}else if(StringUtils.isNotEmpty(prodProduct.getProdProductNameVO().getJjTitle())){
					prodProduct.setProductName(prodProduct.getProdProductNameVO().getJjTitle());
				}
			}	
		}
		//纠正结构化2个版本之间的错误数据
		if(!"DESTINATION_BU".equals(prodProduct.getBu())){
			prodProduct.setProductName(prodProduct.getProductName().replaceAll("#", ""));
		}
		
		if (prodProduct.getBizCategoryId() == null) {
			throw new BusinessException("产品数据错误：无品类");
		}
		if (prodProduct.getProductId() == null) {
			throw new BusinessException("产品数据错误：无产品Id");
		}
		ResultMessage message = null;
		Long reqid = null;
		if(comOrderRequired !=null && comOrderRequired.getReqId()!=null){
			 reqid = comOrderRequired.getReqId();
		}
		
		ProdProduct oldProduct = getOldProdProuDuctByProductIdForLog(prodProduct.getProductId(),reqid);

		//产品目的地关联时想增量表中添加数据
		//addComPushForProdDest(prodProduct);

		//如果多出发地按钮没有显示或没被选中
		if (StringUtil.isEmptyString(prodProduct.getMuiltDpartureFlag())) {
			prodProduct.setMuiltDpartureFlag("N");
		}
		if (StringUtil.isEmptyString(prodProduct.getIsMuiltDeparture())) {
			prodProduct.setIsMuiltDeparture("N");
		}

		// 是否为多出发地信息改变时，校验是否有打包交通组信息
		if (!prodProduct.getMuiltDpartureFlag().equalsIgnoreCase(oldProduct.getMuiltDpartureFlag())) {
			HashMap<String,Object> packageGroupParams = new HashMap<String,Object>();
			packageGroupParams.put("productId", prodProduct.getProductId());
			packageGroupParams.put("groupType", ProdPackageGroup.GROUPTYPE.TRANSPORT.name());//类型为交通
			List<ProdPackageGroup> packageGroupList = prodPackageGroupService.findProdPackageGroup(packageGroupParams);
			if(packageGroupList !=null && packageGroupList.size()>0){
				throw new BusinessException("请先删除产品下的打包交通组信息");
			}
		}

		//检查是否允许修改景酒产品的BU
		if(!StringUtils.equalsIgnoreCase(oldProduct.getBu(), prodProduct.getBu())) {
			//如果产品是景酒产品、并且原BU是目的地BU、产品已经打包了期票商品，不允许修改BU
			if(canModifyBu(oldProduct)){
				return new ResultMessage("error", "保存失败！ 目的地BU产品打包了门票期票后不可更改为其他BU，否则可能影响下单，请检查打包的门票商品类型并确认归属BU。");
			}
		}	
		//检查 景酒 安份售卖修改成人儿童 则发消息，计算团期
		Boolean pushFlag =false;
		if(prodProduct.getBizCategoryId()==18L&&prodProduct.getSubCategoryId()==181L && !"FOREIGNLINE".equals(prodProduct.getProductType()) 
				&& "LVMAMA".equals(oldProduct.getPackageType())){
			   List<ProdProductSaleRe> ProdProductSaleReList = prodProduct.getProdProductSaleReList();
			   if(ProdProductSaleReList!=null && ProdProductSaleReList.size()>0){
			    ProdProductSaleRe ProdProductSaleRenew =ProdProductSaleReList.get(0);
			    if(ProdProductSaleRenew != null &&ProdProductSaleRenew.getSaleType() != null 
			    		&& ProdProductSaleRenew.getSaleType().contains(ProdProductSaleRe.SALETYPE.COPIES.name()) ){
					//查询修改前按份的成人儿童数
					List<ProdProductSaleRe> existedSaleTypeList = MiscUtils.autoUnboxing(prodProductSaleReService.queryByProductId(prodProduct.getProductId()));
					if(existedSaleTypeList!=null && existedSaleTypeList.size()>0 &&existedSaleTypeList.get(0).getSaleType().contains(ProdProductSaleRe.SALETYPE.COPIES.name())){
						ProdProductSaleRe prodProductSaleRe=existedSaleTypeList.get(0);
						if(ProdProductSaleRenew.getAdult()!=null && ProdProductSaleRenew.getChild()!=null
								&&!(ProdProductSaleRenew.getAdult().shortValue()==prodProductSaleRe.getAdult().shortValue()
									&&ProdProductSaleRenew.getChild().shortValue()==prodProductSaleRe.getChild().shortValue())){
							pushAdapterService.push(prodProduct.getProductId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_PRODUCT,ComPush.OPERATE_TYPE.VALID, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
							pushFlag =true;
						}
						
					}
				}
			}
		}
		prodProductService.updateProdProductProp(prodProduct);
		
		prodProductServiceAdapter.updateProdProductReData(prodProduct);
		
		//如果是国内跟团游，修改了“最小起订份数”，需要在comCalData中插入数据，便于重新计算团期
		Long minOrderQuantity = prodProduct.getMinOrderQuantity();
		String productType = prodProduct.getProductType();		
		if(minOrderQuantity != null && minOrderQuantity > 0
				&& minOrderQuantity != oldProduct.getMinOrderQuantity()
				&& Constant.VST_CATEGORY.CATEGORY_ROUTE_GROUP.getCategoryId().equalsIgnoreCase(String.valueOf(prodProduct.getBizCategoryId()))
				&& (ProdProduct.PRODUCTTYPE.INNERLINE.name().equalsIgnoreCase(productType)
						||ProdProduct.PRODUCTTYPE.INNERSHORTLINE.name().equalsIgnoreCase(productType)
						||ProdProduct.PRODUCTTYPE.INNERLONGLINE.name().equalsIgnoreCase(productType)
						||ProdProduct.PRODUCTTYPE.INNER_BORDER_LINE.name().equalsIgnoreCase(productType))){
			try {
				comCalDataService.addComCalData(new ComCalData.Builder(prodProduct.getProductId(), ComPush.OBJECT_TYPE.PRODUCT.name(), 
						ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA.name(), ComPush.PUSH_CONTENT.PROD_PRODUCT.name()).createTime(0).pushCount().pushFlag().dataLevel().build());
			} catch (Exception e) {
				log.error("comCalDataService addComCalData error in updateProduct.", e);
			}
		}
		
		//此处双写 产品名称 结构化信息
		if (prodProduct.getProdProductNameVO() != null) {
			ProdProductDescription productNameDesc = new ProdProductDescription();
			productNameDesc.setCategoryId(prodProduct.getBizCategoryId());
			productNameDesc.setProductId(prodProduct.getProductId());
			productNameDesc.setProductType(prodProduct.getProductType());
//			productNameDesc.setProductNameStruct(prodProduct.getProductNameStruct());
//			productNameDesc.setProductOrigin(prodProduct.getProductOrigin());
			
			productNameDesc.setContentType(ProdProductDescription.CONTENT_TYPE.PRODUCT_NAME.name());
			String jsonStr = JSONObject.toJSONString(prodProduct.getProdProductNameVO());
			productNameDesc.setContent(jsonStr);
			prodProductDescriptionService.saveOrUpdateDoublePlaceForProductDes(productNameDesc);
		}

		//如果没有产品的出发地并且又不是多出发地产品，说明没有大交通,删掉之前的交通数据 （备注：如果多出发复选框勾选，产品的出发地是非必填项）
		if(prodProduct.getBizDistrictId()==null && prodProduct.getMuiltDpartureFlag() == "N"){
			//把行政区域设置为null
			prodProductService.updateDistrictByPrimaryKey(prodProduct);
			ProdTraffic pt  = prodTrafficService.selectByProductId(prodProduct.getProductId());
			if(pt!=null){
				prodTrafficService.deleteByPrimaryKey(pt.getTrafficId());
			}
			HashMap<String,Object> params = new HashMap<String,Object>();
			params.put("productId", prodProduct.getProductId());
			//删除交通组信息
			 List<ProdTrafficGroup>  ptgList = prodTrafficGroupService.selectByParams(params);
			 if(ptgList!=null && ptgList.size() >0){
				 for(ProdTrafficGroup ptg : ptgList){
					 prodTrafficGroupService.deleteByPrimaryKey(ptg.getGroupId());
				 }
			 }
//			prodTrafficService.deleteByPrimaryKey(trafficId);
		}
		
		//修改下单必填项
		if(comOrderRequired != null){
			if(null!=comOrderRequired.getReqId()){
				comOrderRequiredService.updateConOrderRequired(comOrderRequired);						
			}else{
				comOrderRequired.setObjectId(prodProduct.getProductId());
				comOrderRequired.setObjectType(ComOrderRequired.OBJECTTYPE.PROD_PROCUT.name());
				comOrderRequiredService.saveComOrderRequired(comOrderRequired);
			}
		}
		
		//更新签证材料与产品关联(先删除后重建)
		if(docIds != null && !docIds.equalsIgnoreCase(oldDocIds)){
			HashMap<String, Object> params = new HashMap<String, Object>();
			params.put("productId", prodProduct.getProductId());
			prodVisadocReService.deleteByParams(params);
			
			for(String docId : docIds.split(",")){
				if(StringUtil.isNotEmptyString(docId)){
					ProdVisadocRe prodVisadocRe = new ProdVisadocRe();
					prodVisadocRe.setVisaDocId(Long.parseLong(docId));
					prodVisadocRe.setProductId(prodProduct.getProductId());
					prodVisadocReService.addProdVisadocRe(prodVisadocRe);
				}
			}
		}
		
		// 新增产品的销售渠道
		String[] distributorIds = req.getParameterValues("distributorIds");
		String[] distUserNames =req.getParameterValues("distUserNames");
		String logContent = distDistributorProdService.saveOrUpdateDistributorProd(prodProduct.getProductId(),distributorIds);	
		if(distUserNames!=null){
			logContent=logContent+"分销商为："+Arrays.toString(distUserNames);
		}
		distDistributorProdService.pushSuperDistributor(prodProduct, distributorUserIds);
		
		// 签证材料关联
		logContent += ComLogUtil.getLogTxt("签证材料关联", docIds, oldDocIds);
		
		if(StringUtils.isNotEmpty(logForProductOrigin)){
			logContent += logForProductOrigin;
		}
		
		// 电子合同
		if(prodProduct.getProdEcontract() != null){
			prodEcontractService.saveOrUpdate(prodProduct.getProdEcontract());
		}
		
		//如果当地游产品被跟团游产品打包，且当地游产品名称修改，消息通知跟团游产品经理
		if (prodProduct.getProductName() != null && !prodProduct.getProductName().equals(oldProduct.getProductName())) {
			if (Constant.VST_CATEGORY.CATEGORY_ROUTE_LOCAL.getCategoryId().equalsIgnoreCase(String.valueOf(prodProduct.getBizCategoryId()))) {
				
				//查询当地游产品是否被跟团游产品打包
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("bizCategoryId", 15);
				params.put("packageType", "LVMAMA");
				params.put("productId", prodProduct.getProductId());
				params.put("groupName", "当地游");
				List<ProdProduct> packProductList = prodProductService.getPackProductListByParams(params);
				
				if (CollectionUtils.isNotEmpty(packProductList)) {
					LOG.info("当前当地游产品被跟团游产品打包，且当地游产品名称被修改，向产品经理发送通知，packProductList size = "+packProductList.size()+"当地游:prodProductId = "+prodProduct.getProductId());
					PermUser localPermUser = permUserServiceAdapter.getPermUserByUserId(prodProduct.getManagerId());
					if (localPermUser != null && localPermUser.getUserName() != null) {
						for (ProdProduct packProdProduct : packProductList) {
							//内容
							String content = "您的跟团游产品"+packProdProduct.getProductId()
									+"中的当地游"+prodProduct.getProductId()
									+"发生信息变更，请及时跟进维护";
							//operatorName
							PermUser permUser = permUserServiceAdapter.getPermUserByUserId(packProdProduct.getManagerId());
							if (permUser != null && permUser.getUserName() != null) {
								ComMessage comMessage = new ComMessage();
								comMessage.setSender(localPermUser.getUserName());
								comMessage.setReceiver(permUser.getUserName());
								comMessage.setContent(content);
								comMessage.setStatus("CREATE");
								comMessage.setCreateTime(new Date());
								comMessageService.insertComMessage(comMessage);
							}
						}
					}
				}
			}
		}
		//供应商打包，181 182 183多出发地入库(总产子销)
		Long categoryId = prodProduct.getBizCategoryId();
		Long subCategoryId = prodProduct.getSubCategoryId();
		String multiToStartPointIds = req.getParameter("multiToStartPointIds");
		if("SUPPLIER".equals(prodProduct.getPackageType())&&"FOREIGNLINE".equals(prodProduct.getProductType())
				&&(BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCategoryId().equals(categoryId) ||
				(BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCategoryId().equals(categoryId)&&(Long.valueOf(181).equals(subCategoryId)||Long.valueOf(182).equals(subCategoryId)||Long.valueOf(183).equals(subCategoryId))))){
			//删除老的行程
			prodStartDistrictDetailService.deleteStartDistrictDetailByProductId(prodProduct.getProductId());
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
					prodStartDistrictDetail.setProductId(prodProduct.getProductId());
					startDistrictDetailList.add(prodStartDistrictDetail);
				}
				prodStartDistrictDetailService.saveBatchStartDistrictDetailList(startDistrictDetailList);
			}
		}
		//添加操作日志

		try {
			//修改
			sendPushForSaleType(prodProduct, oldProduct,pushFlag);
			
			 String logStr = getProdProductLog(prodProduct,oldProduct,distributorIds, distributorUserIds,comOrderRequired);
			 if(StringUtils.isNotBlank(logStr)){
			 
			 	 logStr = "产品ID"+oldProduct.getProductId()+"," + logStr;
			 	String userName = "";
			 	PermUser permUser = this.getLoginUser();
			 	if(permUser !=null)
			 	{
			 		userName = permUser.getUserName();
			 	}
			 	comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, 
						prodProduct.getProductId(), prodProduct.getProductId(), 
						userName, 
						"修改产品:"+logStr+","+logContent, 
						COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name(), 
						"修改产品",null);
			 	 
			 }
				
				
			} catch (Exception e) {
				log.error("productId = "+prodProduct.getProductId()+" Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
				log.error("productId = "+prodProduct.getProductId()+e.getMessage(),e);
			}
		SquidClient.getInstance().purgeProduct(prodProduct.getBizCategoryId(), prodProduct.getProductId()+"");
		message = new ResultMessage("success", "保存成功");

		//作废相关的缓存数据
		this.invalidProductCache(prodProduct.getProductId());

		return message;
	}

	//作废产品相关的缓存
	private void invalidProductCache(Long productId) {
		String key = MemcachedEnum.DestBuRouteProdProductSingle.getKey() + productId;
		try {
			MemcachedUtil.getInstance().remove(key);
		} catch (Exception e) {
			log.warn("Error invalid product " + productId + " cache");
			return;
		}

		log.info("Product " + productId + " cache removed, keys are " + key);
	}
	
	/**
	 * 判断是否允许修改景酒产品的BU
	 * @param prodProduct 产品对象
	 * @return true:不能修改景酒产品的BU，false:可以修改景酒产品的BU
	 */
	private boolean canModifyBu(ProdProduct prodProduct){
		try{
			long subCategoryId = -1;
			if(prodProduct != null && prodProduct.getSubCategoryId() != null){
				subCategoryId = prodProduct.getSubCategoryId().longValue();
			}
			//如果产品是景酒产品、并且原BU是目的地BU、产品已经打包了期票商品，不允许修改BU
			if(subCategoryId == BizEnum.BIZ_CATEGORY_TYPE.category_route_scene_hotel.getCategoryId()
					&& StringUtils.equalsIgnoreCase(prodProduct.getBu(), CommEnumSet.BU_NAME.DESTINATION_BU.getCode())
					&& hasAperiodicTicket(prodProduct)){
				return true;
			}
		} catch (Exception e) {
			log.error("检查是否允许修改BU时出错.", e);
		}
		return false;
	}
	
	/**
	 * 判断产品是否打包了门票期票
	 * @param prodProduct 产品对象
	 * @return true：打包了门票期票， false：没有打包门票期票
	 */	
	private boolean hasAperiodicTicket(ProdProduct prodProduct) {
		if(prodProduct == null){
			return false;
		}
		boolean result = false;
		//获取产品下所有门票分组
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("productId", prodProduct.getProductId());
		param.put("groupType", ProdPackageGroup.GROUPTYPE.LINE_TICKET.name());
		List<ProdPackageGroup> groupList = prodPackageGroupService.findProdPackageGroup(param);
		
		if(CollectionUtils.isNotEmpty(groupList)){
			//遍历门票分组，检查每个分组中是否包含期票商品。
			for(ProdPackageGroup prodPackageGroup : groupList){
				if(prodPackageGroup == null){
					continue;
				}

				Map<String, Object> goodsParam = new HashMap<String, Object>();
				goodsParam.put("groupId", prodPackageGroup.getGroupId());
				//获取产品下所有的商品
				List<ProdPackageDetailGoodsData> goodsDataList = prodPackageDetailGoodsService.selectPackagedGoodsByParams(goodsParam);
				for(ProdPackageDetailGoodsData goodsData : goodsDataList){
					//如果包含期票商品
					if(StringUtils.equalsIgnoreCase(Constants.Y_FLAG,goodsData.getAperiodicFlag())){
						return true;
					}
				}
			}
		}
		return result;
	}

	private void sendPushForSaleType(ProdProduct prodProduct,
			ProdProduct oldProduct ,Boolean pushFlag) {
		String saleType = prodProduct.getProdProductAdditionSaleType();
		String oldSaleType = oldProduct.getProdProductAdditionSaleType();
		//按人换成按份，按份换成按人，按份修改份数
		if(pushFlag ||(saleType.contains(ProdProductSaleRe.SALETYPE.COPIES.name()) && oldSaleType.contains(ProdProductSaleRe.SALETYPE.PEOPLE.name()))
				||saleType.contains(ProdProductSaleRe.SALETYPE.PEOPLE.name()) && oldSaleType.contains(ProdProductSaleRe.SALETYPE.COPIES.name())){
			pushAdapterService.push(prodProduct.getProductId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_PRODUCT,ComPush.OPERATE_TYPE.VALID, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
		}
	}
	
	@RequestMapping(value = "/updateProductSugg")
	@ResponseBody
	public Object updateProductSugg(ProdProduct prodProduct, HttpServletRequest req, ProdReserveLimit prodReserveLimit) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<updateProduct>");
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
		ProdProduct oldProdProduct = MiscUtils.autoUnboxing(prodProductService.findProdProductById(prodProduct.getProductId(), param));
		
		prodProductService.updateProdProductProp(prodProduct);
		//保存预订限制
		if(prodReserveLimit != null){
			prodReserveLimit.setDataFromSync("N");
			String jsonStr = JSONObject.toJSONString(prodReserveLimit);
			ProdProductDescription productDescription = new ProdProductDescription();
			productDescription.setProductId(prodProduct.getProductId());
			productDescription.setCategoryId(oldProdProduct.getBizCategoryId());
			productDescription.setProductType(oldProdProduct.getProductType());
			productDescription.setContentType(ProdProductDescription.CONTENT_TYPE.RESERVE_LIMIT.name());
			productDescription.setContent(jsonStr);
			prodProductDescriptionService.saveOrUpdateProdDescByReserveLimit(productDescription);
		}
		
		//添加操作日志
		try {
			String log =  getProdProductPropLog(prodProduct, oldProdProduct);
			if(prodReserveLimit != null){
				log = log + "修改了预订限制";
			}
			if(StringUtil.isNotEmptyString(log)){
				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_SUGG, 
						prodProduct.getProductId(), prodProduct.getProductId(), 
						this.getLoginUser().getUserName(),
						"修改产品:" + log, 
						COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_SUGG_CHANGE.name(), 
						"修改产品",null);
			}
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
			log.error(ExceptionFormatUtil.getTrace(e));
		}
		SquidClient.getInstance().purgeProduct(prodProduct.getBizCategoryId(), prodProduct.getProductId()+"");
		message = new ResultMessage("success", "保存成功");
		return message;
	}
	
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
        //日志新增bu与归属地
        if(prodProduct.getBu() != null){
        	String newValue = "";
			String oldValue = "";
			newValue = bizBuEnumClientService.getBizBuEnumByBuCode(prodProduct.getBu()).getReturnContent().getCnName();
			oldValue = bizBuEnumClientService.getBizBuEnumByBuCode(oldProduct.getBu()).getReturnContent().getCnName();
        	sb.append(getChangeLog("BU", oldValue, newValue));
        }
        if(prodProduct.getAttributionId() != null){
        	String oldValue = null;
			 if(oldProduct.getAttributionId() != null){
				 Attribution attribution = attributionService.findAttributionById(oldProduct.getAttributionId());
					if (null != attribution) {
						oldValue = attribution.getAttributionName();
					}
			 }
			 sb.append(getChangeLog("归属地", oldValue, prodProduct.getAttributionName()));
        }
        sb.append(getProdProductPropLog(prodProduct,oldProduct));
        sb.append((StringUtils.isBlank(districtName) || StringUtils.isBlank(prodProduct.getDistrict())) ? "" : getChangeLog("出发地", districtName, prodProduct.getDistrict()));
		sb.append(getChangeLog("是否为多出发地", "Y".equalsIgnoreCase(oldProduct.getMuiltDpartureFlag()) ? "是" : "否", "Y".equalsIgnoreCase(prodProduct.getMuiltDpartureFlag()) ? "是" : "否"));
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
        sb.append(buildSaleTypeLogText(oldProduct, prodProduct));
     return sb.toString();
	}
	/**
	 * 转换yn为是或者否
	 * @param groupSettleFlag
	 * @return
	 */
	private String  convertYorNFlag(String groupSettleFlag){
		if("Y".equals(groupSettleFlag)){
			return "是";
		}else if("N".equals(groupSettleFlag)){
			return "否";
		}else{
			return null;
		}
	}
    private String buildSaleTypeLogText(ProdProduct oldProduct, ProdProduct prodProduct) {
    	ProdProductSaleRe preSaleType = null;
    	if(oldProduct.getProdProductSaleReList() != null && !oldProduct.getProdProductSaleReList().isEmpty()) {
    		preSaleType = oldProduct.getProdProductSaleReList().get(0);
    	}
    	ProdProductSaleRe currSaleType = null;
    	if(prodProduct.getProdProductSaleReList() != null && !prodProduct.getProdProductSaleReList().isEmpty()) {
    		currSaleType = prodProduct.getProdProductSaleReList().get(0);
    	}
    	StringBuilder logText = new StringBuilder();
    	if(preSaleType != null && currSaleType != null) {
    		logText.append("售卖方式"+":[原来值：" + preSaleType.getSaleType() + "," + "新值：" + preSaleType.getSaleType() + "]");
    		logText.append("成人数"+":[原来值：" + preSaleType.getAdult() + "," + "新值：" + preSaleType.getAdult() + "]");
    		logText.append("儿童数"+":[原来值：" + preSaleType.getChild() + "," + "新值：" + preSaleType.getChild() + "]");
    	}
		return logText.toString();
	}

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
         ;
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
    
    private String getValidLog(String flag){
        if(StringUtils.isEmpty(flag)){
            return StringUtils.EMPTY;
        }
        return "Y".equals(flag)?"可用":"不可用";
    }

    private String getDistributorLog(String[] distributorIds, String distributorUserIds,ProdProduct oldProduct) {
    	try{
    	String ret = StringUtils.EMPTY;
    	//销售渠道
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
        
        logStr.append(getChangeLog("销售渠道",distributorNames.toString(),ret));
        return logStr.toString();
    	}catch(Exception  e){
			LOG.error("Error on "+this.getClass().getName(), e);
			return null;
		}
       
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

                }  else if("INPUT_TYPE_YESNO".equals(bizCategoryProp.getInputType())) {
					ret.append(getChangeLog(bizCategoryProp.getPropName(), null, convertYorNFlag(prop.getPropValue())));
				}else {
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

                    } else if("group_settle_flag".equalsIgnoreCase(bizCategoryProp.getPropCode())) {

						ret.append(getChangeLog(bizCategoryProp.getPropName(), convertYorNFlag(prop2.getPropValue())
								, convertYorNFlag(prop.getPropValue())));
					}else {
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

    private String getProdProductChangeLog(ProdProduct oldProduct,ProdProduct newProduct){
		 StringBuffer logStr = new StringBuffer("");
		 if(null!= newProduct)
		 {
		     if(!newProduct.getProdProductPropList().equals(oldProduct.getProdProductPropList())){
		 		Map<Long,ProdProductProp> oldProductProdMap = new HashMap<Long, ProdProductProp>();
				Map<Long,ProdProductProp> productProdMap = new HashMap<Long, ProdProductProp>();
				Map<Long,Map<String,String>> resultMap = new HashMap<Long, Map<String,String>>();
				
				ComLogUtil.setProductProp2Map(oldProduct.getProdProductPropList(),oldProductProdMap);
				ComLogUtil.setProductProp2Map(newProduct.getProdProductPropList(),productProdMap);
				ComLogUtil.diffProductPropMap(oldProductProdMap, productProdMap, resultMap);
				
				StringBuffer suggGroupIds = new StringBuffer();
				Long categoryId = oldProduct.getBizCategoryId();
				Map<String, Object> categoryPropMap = new HashMap<String, Object>();
				categoryPropMap.put("dictDefFlag", "Y");
				categoryPropMap.put("needSuggCodes", "Y");
				categoryPropMap.put("categoryId", categoryId);
				List<BizCategoryProp> categoryPropList =MiscUtils.autoUnboxing(categoryPropService.findCategoryPropList(categoryPropMap));
				if(categoryPropList != null && !categoryPropList.isEmpty()){
					for(BizCategoryProp categoryProp : categoryPropList){
						suggGroupIds.append(categoryProp.getGroupId() + ",");
					}
				}
				
				Map<Long,BizCategoryProp> bizCategoryMap = new HashMap<Long,BizCategoryProp>();
				List<BizCatePropGroup> bizCatePropGroupList = categoryPropGroupService.findCategoryPropGroupsAndCategoryProp(newProduct.getBizCategoryId(), false);
				if ((bizCatePropGroupList != null) && (bizCatePropGroupList.size() > 0)) {
					for (BizCatePropGroup bizCatePropGroup : bizCatePropGroupList) {
						if(suggGroupIds.indexOf(String.valueOf(bizCatePropGroup.getGroupId())) >= 0){
							ComLogUtil.setbizCategory2Map(bizCatePropGroup.getBizCategoryPropList(), bizCategoryMap);
						}
				     }
				}
				
				//获取产品动态属性列表变更日志
				for (Map.Entry<Long,Map<String,String>> entry : resultMap.entrySet()) {
					if(PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_TEXTAREA.name().equals(bizCategoryMap.get(entry.getKey()).getInputType()) 
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
				}
		     }

		 }
		 return logStr.toString();
	 }
	
	//封装返回固定值
	private void setModelAtrribute(Model model){
		model.addAttribute("addValueTitle", ProdProductProp.PROP_ADD_VALUE_SPLIT);
		// 类别
		List<ProdProduct.PRODUCTTYPE> productTypeList = new ArrayList<ProdProduct.PRODUCTTYPE>(Arrays.asList(ProdProduct.PRODUCTTYPE.values()));

		// 去掉快递
		productTypeList.remove(ProdProduct.PRODUCTTYPE.EXPRESS);
		//去掉押金
		productTypeList.remove(ProdProduct.PRODUCTTYPE.DEPOSIT);
		
		//排序，国内边境游和国内其他排在一起
		productTypeList.remove(ProdProduct.PRODUCTTYPE.INNER_BORDER_LINE);
		
		int index = productTypeList.indexOf(ProdProduct.PRODUCTTYPE.FOREIGNLINE);
		productTypeList.add(index, ProdProduct.PRODUCTTYPE.INNER_BORDER_LINE);
		
		model.addAttribute("productTypeList", productTypeList);
		//打包类型
		model.addAttribute("packageTypeList", ProdProduct.PACKAGETYPE.values());
		// 分公司
		model.addAttribute("filiales", CommEnumSet.FILIALE_NAME.values());
		// BU
		model.addAttribute("buList", bizBuEnumClientService.getAllBizBuEnumList().getReturnContent());
		
		//销售渠道
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("cancelFlag", "Y");
		try{
		List<Distributor> distributors = distributorService.findDistributorList(params).getReturnContent();
		model.addAttribute("distributorList", distributors);
		}catch(Exception  e){
			LOG.error("Error on "+this.getClass().getName(), e);
			throw new BusinessException(e.getMessage());
		}
	}

	private void findManagerNameById(ProdProduct prodProduct){
		if(null!=prodProduct){
			PermUser permUser = permUserServiceAdapter.getPermUserByUserId(prodProduct.getManagerId());
			prodProduct.setManagerName("");
			if(permUser != null) {
				prodProduct.setManagerName(permUser.getRealName());
			}
		}
	}
	
	private String getProdLineRouteDetailLog(ProdLineRouteDetail prodLineRouteDetail){
        if(prodLineRouteDetail == null){
            return null;
        }
        String ret = "线路产品明细Id:"+(prodLineRouteDetail.getDetailId()==null?"":prodLineRouteDetail.getDetailId())
                    +",关联行程Id:"+(prodLineRouteDetail.getRouteId()==null?"":prodLineRouteDetail.getRouteId())
                    +",线路天数:"+(prodLineRouteDetail.getnDay()==null?"":prodLineRouteDetail.getnDay())
                    +",标题:"+(prodLineRouteDetail.getTitle()==null?"":prodLineRouteDetail.getTitle())
                    +",行程内容:"+(prodLineRouteDetail.getContent()==null?"":prodLineRouteDetail.getContent())
                    +",住宿类型:"+(prodLineRouteDetail.getStayType()==null?"":bizDictQueryService.selectByPrimaryKey(Long.valueOf(prodLineRouteDetail.getStayType())).getDictName())
                    +",住宿描述:"+(prodLineRouteDetail.getStayDesc()==null?"":prodLineRouteDetail.getStayDesc())
                    +",是否有早餐:"+(prodLineRouteDetail.getBreakfastFlag()==null?"":prodLineRouteDetail.getBreakfastFlag())
                    +",早餐描述:"+(prodLineRouteDetail.getBreakfastDesc()==null?"":prodLineRouteDetail.getBreakfastDesc())
                    +",是否有午餐:"+(prodLineRouteDetail.getLunchFlag()==null?"":prodLineRouteDetail.getLunchFlag())
                    +",午餐描述:"+(prodLineRouteDetail.getLunchDesc()==null?"":prodLineRouteDetail.getLunchDesc())
                    +",是否有晚餐:"+(prodLineRouteDetail.getDinnerFlag()==null?"":prodLineRouteDetail.getDinnerFlag())
                    +",晚餐描述:"+(prodLineRouteDetail.getDinnerDesc()==null?"":prodLineRouteDetail.getDinnerDesc())
                    +",交通工具类型:"+getTrafficType(prodLineRouteDetail.getTrafficType());
        if(prodLineRouteDetail.getTrafficType()!=null && prodLineRouteDetail.getTrafficType().contains("OTHERS")){
            ret +=",其他交通:"+(prodLineRouteDetail.getTrafficOther()==null?"":prodLineRouteDetail.getTrafficOther());
        }
        return ret;
    }
	
	private List<String> getTrafficType(String trafficType){
	    if(StringUtils.isEmpty(trafficType)){
	        return Collections.emptyList();
	    }
	    List<String> ret = new ArrayList<String>();        
	    for(String type : trafficType.split(",")){
	        ret.add(LineRouteEnum.TRAFFIC_TYPE.getCnName(type));
	    }
	    return ret;
	}
	
	
	
	//获取修改基本产品信息原始对象
	@SuppressWarnings("unchecked")
	public ProdProduct getOldProdProuDuctByProductIdForLog(Long prodProductId,Long reqId){
		
		//获取原来产品对象
				Map<String, Object> parameters = new HashMap<String, Object>();
				parameters.put("productId",prodProductId);
				ProdProductParam param = new ProdProductParam();
				param.setBizCategory(true);
				param.setBizDistrict(true);
				param.setProductProp(true);
				param.setProductPropValue(true);
				ProdProduct oldProduct = MiscUtils.autoUnboxing(prodProductService.findProdProductById(prodProductId,param));
				
				//查询关联数据
				if(oldProduct != null){
					Long productId = oldProduct.getProductId();
					//1、行程天数
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("productId", productId);
//					List<ProdLineRoute> prodLineRouteList = prodLineRouteService.findProdLineRouteByParams(params);
//					if(prodLineRouteList != null && prodLineRouteList.size() > 0){
//						oldProduct.setProdLineRoute(prodLineRouteList.get(0));
//					}
					
					//2、关联目的地数据
					oldProduct.setProdDestReList(prodDestReService.findProdDestReByParams(params));
					
					
					//3、关联的销售渠道信息
					try {
						oldProduct.setDistDistributorProds((List<DistDistributorProd>) MiscUtils.autoUnboxing(prodDistributorService.findDistDistributorProdByParams(params)));
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
					//关联出发地
					
					
					//电子合同
					ProdEcontract econtract = prodEcontractService.selectByProductId(productId);
					oldProduct.setProdEcontract(econtract);
					
				}
				 
						if(reqId!=null){
							ComOrderRequired oldComOrderRequirede = comOrderRequiredService.findComOrderRequiredById(reqId);
							oldProduct.setComOrderRequired(oldComOrderRequirede);
						}
						
						return oldProduct;
		
	}
	
	
	public String getChangeLog(String columnName,String oldStr,String newStr){
		String temp = "";
		if(oldStr ==null && newStr == null){
			
			return temp;
			
		}else if(oldStr ==null ||newStr ==null ){
			temp =  ComLogUtil.getLogTxt(columnName,newStr,oldStr);
			return temp;
		}else{
			
			if( !oldStr.equals(newStr)){
				temp = ComLogUtil.getLogTxt(columnName,newStr,oldStr)+",";
				return temp;
			}
		}
		
		
		return "";
		
	}
	

	private String getLog(ProdProduct product, String distributors){
        String ret = StringUtils.EMPTY;
        if(product == null){
            return ret;
        }

        ret += "所属品类：" + product.getBizCategory().getCategoryName() + " "
            + "产品名称：" + product.getProductName() + " "
            + "供应商产品名称：" + product.getSuppProductName() + " "
            + "推荐级别：" + product.getRecommendLevel() + " "
            + "类别：" ;

        if("INNERSHORTLINE".equals(product.getProductType())){
            ret += "国内-短线";
        } else if ("INNERLONGLINE".equals(product.getProductType())){
            ret += "国内-长线";
        } else if ("FOREIGNLINE".equals(product.getProductType())){
            ret += "出境/港澳台";
        } else if ("INNERLINE".equals(product.getProductType())) {
            ret += "国内";
        } else {
            ret += product.getProductType();
        }

        ret += " 打包类型：" + ("LVMAMA".equals(product.getPackageType())?"自主打包":"供应商打包") + " "
            + "所属分公司：" + CommEnumSet.FILIALE_NAME.getCnName(product.getFiliale()) + " "
            + "电子合同: " + (StringUtils.isEmpty(product.getProdEcontract().getEcontractTemplate())?"自动调取":ProdEcontract.ELECTRONIC_CONTRACT_TEMPLATE.getCnName(product.getProdEcontract().getEcontractTemplate())+ " ");
        
        for(ProdProductProp prop: product.getProdProductPropList()){
            if(prop.getPropId() == 600 ){
                ret += getChangeLog("是否有大交通",  prop.getPropValue().equals("Y")?"是":"否", prop.getPropValue().equals("Y")?"是":"否");
            }else if(prop.getPropId() == 601 ){
                ret += getChangeLog("套餐包含", getPackageContent(prop).toString(),getPackageContent(prop).toString());
            }else if(prop.getPropId() == 602 ){
                ret+= getChangeLog("产品经理推荐", prop.getPropValue(),prop.getPropValue());
            }else if(prop.getPropId() == 603 ){
                ret+= getChangeLog("产品特色", prop.getPropValue(),prop.getPropValue());
            }else if(prop.getPropId() == 604 ){
                ret+= getChangeLog("交通到达", prop.getPropValue(),prop.getPropValue());
            }
        }

        ret += " 出发地：" + product.getDistrict() + " "
            + "目的地：";

        String[] newDestValues = product.getDest();
        List<String> newDestvalue = new ArrayList<String>();
        for(String newDest : newDestValues ){
            if(newDest.contains("[")) {
                String dest = newDest.substring(0, newDest.lastIndexOf("["));
                newDestvalue.add(dest);
            }
        }
        ret += Arrays.asList(newDestValues) + " "
            + distributors;

        return ret;
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
			ProdProductParam param = new ProdProductParam();
			param.setBizCategory(true);
			param.setBizDistrict(true);
			param.setProductProp(true);
			param.setProductPropValue(true);
			//复制产品
			ProdProduct prodProduct =MiscUtils.autoUnboxing(prodProductService.findProdProductById(Long.valueOf(req.getParameter("productId")),param));
			//需求：交通自主打包产品 产品复制时不复制 自动打包交通组的内容，将自动打包交通组的值置为初始值  panyu  20160612
			Map<String, Object> propValue = prodProduct.getPropValue();
			if(null !=propValue && "Y".equals(propValue.get("auto_pack_traffic"))){
				propValue.put("auto_pack_traffic", "N");//自动打包交通
				propValue.put("isuse_packed_route_details", "Y");//是否使用被打包产品行程明细
				propValue.put("isuse_packed_cost_explanation", "N");//是否使用被打包产品费用说明
				propValue.put("packed_product_id", "");//被打包产品ID
			}

			long oldProductId = prodProduct.getProductId();
			prodProduct.setProductId(null);
			prodProduct.setCreateTime(new Date());
			prodProduct.setCreateUser(this.getLoginUserId());
            prodProduct.setSource("BACK");
			prodProduct.setAuditStatus(ProdProduct.AUDITTYPE.AUDITTYPE_TO_PM.name());
			prodProduct.setUrlId(null);
			prodProduct.setCancelFlag("N");
            prodProduct.setEbkSupplierGroupId(null);
			long newProductId = prodProductServiceAdapter.saveProdProduct(prodProduct);
			prodProduct.setProductId(newProductId);
			//自主打包或者（供应商打包并且符合总产规则），插入数据，增加总产标识
			if(prodProduct.getBizCategoryId()==15L||prodProduct.getBizCategoryId()==16L||prodProduct.getBizCategoryId()==18L||prodProduct.getBizCategoryId()==17L||prodProduct.getBizCategoryId()==8L){
				if("SUPPLIER".equals(prodProduct.getPackageType())){
					SuppGoods suppGoods = suppGoodsService.findBaseSuppGoodsByProductId(oldProductId);
					if(suppGoods!=null && suppGoods.getFiliale()!=null
						&& ("SH_FILIALE".equals(suppGoods.getFiliale())||"GZ_FILIALE".equals(suppGoods.getFiliale()) 
						|| "BJ_FILIALE".equals(suppGoods.getFiliale()) ||"CD_FILIALE".equals(suppGoods.getFiliale()) )){
						ProdAdditionFlag prodAdditionFlag = new ProdAdditionFlag();
						prodAdditionFlag.setProductId(prodProduct.getProductId());
						prodAdditionFlag.setSelfFlag("Y");
						prodAdditionFlagService.insertProdAdditionFlag(prodAdditionFlag);
						MemcachedUtil.getInstance().set(MemcachedEnum.SelfProductFlag.getKey() + prodProduct.getProductId(), MemcachedEnum.SelfProductFlag.getSec(),"Y");
					}
				}else if("LVMAMA".equals(prodProduct.getPackageType())){
						ProdAdditionFlag prodAdditionFlag = new ProdAdditionFlag();
						prodAdditionFlag.setProductId(prodProduct.getProductId());
						prodAdditionFlag.setSelfFlag("Y");
						prodAdditionFlagService.insertProdAdditionFlag(prodAdditionFlag);
						MemcachedUtil.getInstance().set(MemcachedEnum.SelfProductFlag.getKey() + prodProduct.getProductId(), MemcachedEnum.SelfProductFlag.getSec(),"Y");
				}
			}
			//复制关联数据
			int result = prodProductServiceAdapter.copyProdProductReData(prodProduct,oldProductId);
			
			Map<String, Object> attributes = new HashMap<String, Object>();
			attributes.put("productId", newProductId);
			attributes.put("productName", prodProduct.getProductName());
			attributes.put("categoryName", prodProduct.getBizCategory().getCategoryName());
			
			if(result!=1){
				return new ResultMessage(attributes, "success", "复制产品关联数据失败！");
			}
			//跟团游 自由行发送消息，计算交通 酒店信息
			pushAdapterService.push(prodProduct.getProductId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_PRODUCT,ComPush.OPERATE_TYPE.ADD, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
			

			//添加操作日志
			try {
				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, 
						prodProduct.getProductId(), prodProduct.getProductId(), 
						this.getLoginUser().getUserName(), 
						"复制产品：【"+prodProduct.getProductName()+"】,原产品ID:【"+oldProductId+"】", 
						COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name(), 
						"复制产品",null);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
				log.error(e.getMessage());
			}
			
			return new ResultMessage(attributes, "success", "复制成功");
		}
		
		return new ResultMessage("error", "复制失败");
	}
	
	@RequestMapping(value = "/showUpdateProductFeature")
	public String showUpdateProductFeature(Model model, long productId, long categoryId, String packageType,String productType, Long subCategoryId, HttpServletRequest req) {
		String dataFrom=req.getParameter("dataFrom");
		model.addAttribute("categoryId",categoryId);
		model.addAttribute("productId", productId);
		model.addAttribute("packageType",packageType);
		model.addAttribute("subCategoryId", subCategoryId);
		model.addAttribute("userName", this.getLoginUser().getUserName());
		if(subCategoryId != null&&subCategoryId.longValue() == 181L){
			model.addAttribute("editFlag","true");
		}else{
			ProdProductAssociation prodProductAssociation= prodProductAssociationService.getProdProductAssociationByProductId(Long.valueOf(productId));
			if(prodProductAssociation != null && prodProductAssociation.getAssociatedFeatureId() != null ){
				productId = prodProductAssociation.getAssociatedFeatureId();
				ProdProduct prodproduct = prodProductService.findProdProductByProductId(Long.valueOf(productId));
				model.addAttribute("associatedFeatureId",productId);
				model.addAttribute("associatedcategoryId",prodproduct.getBizCategoryId());
				model.addAttribute("editFlag","false");
				categoryId=prodproduct.getBizCategoryId();
				productType=prodproduct.getProductType();
				LOG.info("packageTourProductAction showUpdateProductFeature  productId = "+productId+" AssociatedFeatureId="+prodProductAssociation.getAssociatedFeatureId());
			}else{
				model.addAttribute("editFlag","true");
			}
		}
		if(!"FOREIGNLINE".equals(productType)&& (categoryId==15L||categoryId==16L)){
			model.addAttribute("hasRichText","true");
		}
		List<ProdRouteFeature> prfList=prodRouteFeatureService.findProdRouteFeatureByProdId(productId);
		ProdProductDescription prodProductDescription = prodRouteFeatureService.findProdProductDescription(productId);
		if(CollectionUtils.isEmpty(prfList) && StringUtils.isNotEmpty(prodProductDescription.getContent())){
			model.addAttribute("hasHead", "true");
		}else{
			model.addAttribute("hasHead","false");
		}
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
		return "/prod/packageTour/product/productRouteFeature"; 
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
			for (int i=0; i < featurePropStrs.length; i++) {
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
	public String showProductRouteFeatureOld(Model model, long productId,Long categoryId,Long associatedFeatureId,String packageType, HttpServletRequest req) {
		model.addAttribute("productId", productId);
		model.addAttribute("categoryId", categoryId);
		model.addAttribute("packageType", packageType);
		LOG.info("PackageTourProductAction method: showProductRouteFeatureOld productId="+productId+" associatedFeatureId="+associatedFeatureId);
		if(associatedFeatureId!=null){
			productId=associatedFeatureId;
		}
		ProdProductDescription prodProductDescription = prodRouteFeatureService.findProdProductDescription(productId);
		model.addAttribute("ProductDescription", prodProductDescription);
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
		return "/prod/packageTour/product/productRouteFeatureOld"; 
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
	 * 复制产品特色结构化
	 * 
	 * @param oldProductId 原来产品的ID
	 * @param newProductId 复制产品的ID
	 */
	@RequestMapping(value = "/copyProdFeature")
	@ResponseBody
	public Object copyProdFeature(String oldProductId, String newProductId,String copyType) {
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
						Map<String,Object> params =new HashMap<String,Object>();
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
				&& StringUtils.isEmpty(prodProductDescription.getContent()) && StringUtils.isEmpty(prodProductDescription.getContentType()) 
				&& StringUtils.isEmpty(prodProductDescription.getProductType()) &&StringUtils.isEmpty(prodProductDescription.getClobFlag())){
			flag = true;
		}
		return flag;
		
	}
	
	
	
	@RequestMapping(value = "/showAddPicture")
	public String showAddPicture(Model model, HttpServletRequest req) {
		String divIndex=req.getParameter("divIndex");
		if(StringUtil.isNotEmptyString(divIndex)){
			model.addAttribute("divIndex", divIndex);
		}
		return "/prod/packageTour/product/addPicture"; 
	}
	
	@RequestMapping(value = "/previewProdFeature")
	public String previewProdFeature(Model model, HttpServletRequest req) {
		return "/prod/packageTour/product/previewProdFeature"; 
	}
	
	//校验签证材料
	private String checkvisaDoc(Long productId )throws BusinessException {
		String visaDocFlag="true";
		//签证材料是否存在
		Map<String,Object> pars = new HashMap<String, Object>();
		List<ProdLineRoute> prodRouteList=checkRoute(productId);
		if(prodRouteList==null||prodRouteList.size()<=0){
			visaDocFlag="false";
		}
		for(ProdLineRoute pr:prodRouteList){
			pars.put("lineRouteId", pr.getLineRouteId());
			List<ProdVisadocRe>  visadocList=prodVisadocReService.findProdVisadocReByParams(pars);
			if(visadocList==null||visadocList.size()<=0){
				visaDocFlag="false";
				break;
			}
		}
		return  visaDocFlag;
	}
	//关联行程
	private ProdLineRoute showAssociatedRoute(ModelMap modelMap, Long associationProductId) {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productId", associationProductId);
		params.put("cancelFlag", "Y");
		List<ProdLineRoute> prodLineRouteList = prodLineRouteService.findProdLineRouteByParams(params);
		if(CollectionUtils.isNotEmpty(prodLineRouteList)){
			ProdLineRoute prodLineRoute = prodLineRouteList.get(0);
			if(prodLineRoute != null){
				//校验行程明细
				modelMap.addAttribute("routeFlag", "true");
				String saveRouteFlag=checkRouteDetail(associationProductId);
				modelMap.addAttribute("saveRouteFlag", saveRouteFlag);
				return prodLineRoute;
			}
		}
		return null;
	} 
	
	private String checkLineRoute(Long productId)throws BusinessException {
		List<ProdLineRoute> lineRouteList= checkRoute(productId);
		String routeFlag="false";
		if(lineRouteList!=null&&lineRouteList.size()>=1){
			routeFlag="true";
		}
		return routeFlag;
	}

	//行程明细校验
	private String checkRouteDetail(Long productId)throws BusinessException {
		String saveRouteFlag="true";
		List<ProdLineRoute> prodRouteList=checkRoute(productId);
		if(prodRouteList==null||prodRouteList.size()<=0){
			saveRouteFlag="false";
		}
		for(ProdLineRoute pr:prodRouteList){
			List<ProdLineRouteDetail> routeDetailList=  prodLineRouteDetailService.selectByProdLineRouteId(pr.getLineRouteId());
			if(routeDetailList==null||routeDetailList.size()<=0){
				saveRouteFlag="false";
				break;
			}
		}
		return saveRouteFlag;
	}
	
	
	
	//行程校验
	private List<ProdLineRoute> checkRoute(Long productId)throws BusinessException {
		Map<String,Object> pars = new HashMap<String, Object>();
		pars.put("productId", productId);
		pars.put("cancleFlag", "Y");
		List<ProdLineRoute> prodRouteList=  prodLineRouteService.findProdLineRouteByParams(pars);
		return prodRouteList;
	}
	
	/**
	 * 记录行程操作日志
	 */
	private void logLineRouteOperate(ProdLineRoute LineRoute, String logText, String logName) {
		try{
			ProdLineRoute  pRoute=MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(LineRoute.getLineRouteId()));
			
			comLogService.insert(PROD_LINE_ROUTE, LineRoute.getProductId(), LineRoute.getLineRouteId(),
					this.getLoginUser().getUserName(), "【"+pRoute.getRouteName()+"】"+logText, PROD_TRAVEL_DESIGN.name(), logName, null);
		}catch(Exception e) {
			log.error("Record Log failure ！Log Type:" + PROD_TRAVEL_DESIGN.name());
			log.error(e.getMessage(), e);
		}
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
			 ret.append(" 大标题变更："+ titleFromCodeToText(propValue) );
		 }else if(ProdRouteFeature.FEATPROP_TYPE.SMALL_TITLE.name().equals(propType)){
			 ret.append(" 小标题变更："+propValue);
		 }else if(ProdRouteFeature.FEATPROP_TYPE.TEXT.name().equals(propType)){
			 ret.append(" 正文变更："+propValue);
		 }else if(ProdRouteFeature.FEATPROP_TYPE.IMG.name().equals(propType)){
			 ret.append(" 图片变更："+propValue);
		 }
	 }
	
	 private String titleFromCodeToText(String txt){
		 if(txt != null) {
			 txt = txt.replace("HOTEL", " 酒店介绍").replace("VIEW_PORT", "景点介绍")
					 .replace("FOOD", "美食推荐").replace("TRAFFIC", "交通信息")
					 .replace("OTHER", "自定义");
		 }
		 return txt;
	 }
	
	/**
	 * 查看产品是否打包酒店套餐
	 * @param prodProduct
	 * @return
	 */
	private boolean isPackageGroupHotel(ProdProduct prodProduct)
	{
		HashMap<String,Object> params = new HashMap<String,Object>();
		params.put("productId", prodProduct.getProductId());
		params.put("groupType", ProdPackageGroup.GROUPTYPE.LINE.name());//类型为交通
		List<ProdPackageGroup> packageGroupList = prodPackageGroupService.findProdPackageGroup(params);
		if(CollectionUtils.isEmpty(packageGroupList)) return false;
		for(ProdPackageGroup pg :packageGroupList){
			if(pg.getCategoryId() == 17) return true;
		}
		return false;
	}
	
	
	/**  panyu 20160523
	 * 由产品ID 查询所属品类, 如果没有查询到，返回0
	 * @param packedProductID
	 * @return
	 */
	@RequestMapping(value = "/findCategoryIDFormProductByID")
	@ResponseBody
	public Long findCategoryIDFormProductByID(Long packedProductID)
	{
		if(null == packedProductID){
			return 0L;
		}

		ProdProduct prodProduct = prodProductService.findProdProductByProductId(packedProductID);
		if(prodProduct == null){
			return 0L;
		}
		return prodProduct.getBizCategoryId();
	}
	
	/**
	 * 判断是出境 跟团游 modelVersion不是1.0 
	 * @param prodProduct
	 * @return boolean
	 * */
	private boolean  isOutGroupAndunVersion(ProdProduct  prodProduct){
		if ((prodProduct.getModelVersion() == null || prodProduct.getModelVersion() < 1.0)
				&& Long.valueOf(15L).equals(prodProduct.getBizCategoryId())
				&& ProdProduct.PRODUCTTYPE.FOREIGNLINE.getCode().equals(prodProduct.getProductType())) {
			return Boolean.TRUE;
		}
		return Boolean.FALSE;
	}
	
	private String productRename(String packTitle) {
		String prodName = null;
		if(packTitle.contains("#")){
			String[] title = packTitle.split("#");
			//title[0]促销   title[1]主   title[2]副
			if(StringUtils.isEmpty(title[0])){
				if(StringUtils.isEmpty(title[1])){
					prodName =  title[2];
				}else{
					prodName = "【"+ title[1] + "】"+ title[2];
				}
			}else{
				if(StringUtils.isEmpty(title[1])){
					prodName = title[0] + "-" + title[2];
				}else{
					prodName = title[0]+ "【"+ title[1] + "】" + title[2];
				}
			}
			LOG.info("产品处理后：prodName="+prodName);
		}
		return prodName;
	}
	
	/**caiqing 20170221
	 * 使用新的酒店加价规则自动屏蔽门票渠道和super分销商中的其他分销
	 * @param
	 * @return
	 */
	private boolean validNewHotelPriceRule(Long productId){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productId", productId);
		params.put("groupType", "HOTEL");
		params.put("priceType", ProdPackageDetail.PRICE_TYPE.FIXED_PERCENT.name());
		List<ProdPackageGroup> prodPackageGroupList = prodPackageGroupService.findProdPackageGroupByParams(params, true, false);
		if(CollectionUtils.isNotEmpty(prodPackageGroupList)){
			boolean NewHotelPriceRule = false;
			for(ProdPackageGroup prodPackageGroup : prodPackageGroupList){
				if(CollectionUtils.isNotEmpty(prodPackageGroup.getProdPackageDetails())){
					NewHotelPriceRule = true;
					break;
				}
			}
			if(NewHotelPriceRule){
				return Boolean.TRUE;
			}
			for(ProdPackageGroup prodPackageGroup : prodPackageGroupList){
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("groupId", prodPackageGroup.getGroupId());
				map.put("priceType", ProdPackageDetail.PRICE_TYPE.FIXED_PERCENT.name());
				List<ProdPackageDetailAddPrice> prodPackageDetailAddPriceList = MiscUtils.autoUnboxing(prodPackageDetailAddPriceService.findProdPackageDetailAddPriceList(map));
				if(CollectionUtils.isNotEmpty(prodPackageDetailAddPriceList)){
					NewHotelPriceRule = true;
					break;
				}
			}
			if(NewHotelPriceRule){
				return Boolean.TRUE;
			}
		}
		return Boolean.FALSE;
	}

	@RequestMapping(value = "/updateStructName")
	@ResponseBody
	public Object updateStructName(HttpServletRequest httpServletRequest,Long productId){
		ResultMessage msg = ResultMessage.createResultMessage();
		LOG.info("updateStructName productId="+productId);
		String destName="";
		String destNameTest="";
		String nameLog="";
		Short routeNum = null;
		Short stayNum = null;
		try{
			//更新目的地与行程
			ProdProductParam param = new ProdProductParam();
			param.setProductProp(true);
			param.setProductPropValue(true);
			ProdProduct prodProduct = prodProductService.findProdProductByProductId(productId);
			List<ProdDestRe> prodDestReList = prodProduct.getProdDestReList();
			if(prodDestReList!=null&&prodDestReList.size()>0){
				int size=0;
				for(ProdDestRe prodDestRe:prodDestReList){
					if("CITY".equals(prodDestRe.getDestTypeCode())){
						if("".equals(destName)){
							if(prodDestRe.getDestName().length()<16){
								destName = prodDestRe.getDestName();
								size=1;
							}
						}else{
							if(destName.indexOf(prodDestRe.getDestName())<0 && size<2){
								destNameTest = 	destName+"＋"+prodDestRe.getDestName();
								if(destNameTest.length()<16){
									destName = destName+"＋"+prodDestRe.getDestName();
									size=size+1;
								}
							}
						}
					}
				}
			}
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("productId", productId);
			params.put("cancelFlag", "Y");
			List<ProdLineRoute> prodLineRouteList = prodLineRouteService.findProdLineRouteByParams(params);
			if(prodLineRouteList!=null&&prodLineRouteList.size()>0){
				ProdLineRoute prodLineRoute =  prodLineRouteList.get(0);
				routeNum= prodLineRoute.getRouteNum();
				stayNum=prodLineRoute.getStayNum();
			}
			if(routeNum!=null&&stayNum!=null){
				if(!"".equals(destName)){
					destName = destName+" "+routeNum+"天"+stayNum+"晚";
				}else{
					destName = routeNum+"天"+stayNum+"晚";
				}
			}else{
				if("".equals(destName)){
					LOG.info("updateStructName destName为空  productId="+productId);
				}
			}
			nameLog = "目的地+行程改为："+destName;
			msg.addObject("destAndDays", destName);
			comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, 
					productId, productId, 
					this.getLoginUser().getUserName(),
					"修改产品:结构化标题 "+nameLog, 
					COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name(), 
					"修改产品",null);
			return msg;
		}catch(Exception e){
			LOG.error("updateStructName error productId="+productId,e);
			msg.setCode("error");
			msg.setMessage("更新失败");
			return msg;
		}
	}
	
	@RequestMapping(value = "/showAppPreviewCode")
	public String showAppPreviewCode(Model model, HttpServletRequest req, HttpServletResponse Resp, Long productId,String cancelFlag,String saleFlag) throws Exception{

		model.addAttribute("productId",productId);
		model.addAttribute("cancelFlag",cancelFlag);
		model.addAttribute("saleFlag",saleFlag);
		return "/prod/packageTour/product/showAppPreviewCode";
	}
	
	@RequestMapping(value = "/showPic")
	public void showPic(Model model, HttpServletRequest req, HttpServletResponse Resp, Long productId,String cancelFlag,String saleFlag) throws Exception{
		
		Resp.setHeader("Pragma", "No-cache");
		Resp.setHeader("Cache-Control", "No-cache");
		Resp.setDateHeader("Expires", 0);
		// 指定生成的响应是png图片
		Resp.setContentType("image/png");
		model.addAttribute("productId",productId);
		String httpPath = "https://m.lvmama.com/product/"+productId+"?invalidFlag=true"; 
		if("Y".equals(cancelFlag) && "Y".equals(saleFlag)){
			 httpPath = "https://m.lvmama.com/product/"+productId;
		}
		
		ServletOutputStream out = Resp.getOutputStream();
		try{
			BufferedImage bufferedImage  = TwoDimensionCode.qRCodeCommon(httpPath, "png", 7);
			ImageIO.write(bufferedImage,"PNG",Resp.getOutputStream()); // 输出2维码图片
			out.flush();
		}catch(Exception e){
			e.printStackTrace();
		}finally {  
            out.close();  
        } 
	}
}
