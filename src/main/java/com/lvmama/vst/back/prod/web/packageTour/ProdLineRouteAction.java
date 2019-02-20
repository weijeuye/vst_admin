package com.lvmama.vst.back.prod.web.packageTour;

import static com.lvmama.vst.back.prod.po.ProdLineRoute.INVALID;
import static com.lvmama.vst.back.prod.po.ProdLineRoute.VALID;
import static com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE.PROD_TRAVEL_DESIGN;
import static com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE.PROD_LINE_ROUTE;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.comm.pet.po.pub.ComMessage;
import com.lvmama.comm.pet.service.pub.ComMessageService;
import com.lvmama.vst.back.biz.po.BizDict;
import com.lvmama.vst.back.biz.po.BizDictExtend;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.biz.service.BizDictQueryService;
import com.lvmama.vst.back.biz.service.DictService;
import com.lvmama.vst.back.dujia.comm.prod.po.ProdProductDescription;
import com.lvmama.vst.back.dujia.client.comm.prod.service.ProdProductDescriptionClientService;
import com.lvmama.vst.back.dujia.group.prod.vo.ProdProductNameVO;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.goods.vo.ProdProductParam;
import com.lvmama.vst.back.prod.po.LineRouteDate;
import com.lvmama.vst.back.prod.po.LineRouteEnum;
import com.lvmama.vst.back.prod.po.ProdDestRe;
import com.lvmama.vst.back.prod.po.ProdGroup;
import com.lvmama.vst.back.prod.po.ProdLineRoute;
import com.lvmama.vst.back.prod.po.ProdLineRouteDetail;
import com.lvmama.vst.back.prod.po.ProdPackageGroup;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductAssociation;
import com.lvmama.vst.back.prod.po.ProdVisadocRe;
import com.lvmama.vst.back.prod.scenicHotel.ScenicHotelStructuringService;
import com.lvmama.vst.back.prod.service.LineRouteDateService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.prod.service.ProdGroupClientService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteDetailClientService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteClientService;
import com.lvmama.vst.back.client.prod.service.ProdPackageGroupClientService;
import com.lvmama.vst.back.prod.service.ProdProductAssociationService;
import com.lvmama.vst.back.prod.service.ProdProductBranchService;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.client.prod.service.ProdVisaDocDateClientService;
import com.lvmama.vst.back.prod.service.ProdVisadocReService;
import com.lvmama.vst.back.prod.vo.LineRouteDateVO;
import com.lvmama.vst.back.prod.po.ScenicHotelCostIncludeVo;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.pub.service.PushAdapterService;
import com.lvmama.vst.comm.utils.CalendarUtils;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.Pair;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.utils.web.HttpServletLocalThread;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;
import com.lvmama.vst.back.utils.MiscUtils;
/**
 * 线路产品行程Action
 */
@Controller
@RequestMapping("/prod/prodLineRoute/")
public class ProdLineRouteAction extends BaseActionSupport {

	/** Serial Version UID */
	private static final long serialVersionUID = 8152013431376424411L;

	private static final Log LOG = LogFactory.getLog(ProdLineRouteAction.class);
	
	@Autowired
	private ProdLineRouteClientService 	prodLineRouteService;
	@Autowired
	private ProdProductService 		prodProductService;
	@Autowired
	private BizDictQueryService 	bizDictQueryService;
	
	@Autowired
	private DictService 			dictService;
	@Autowired
	private ComLogClientService 			comLogService;
	@Autowired
	private ProdVisadocReService 	prodVisadocReService;
	@Autowired
	private ProdLineRouteDetailClientService prodLineRouteDetailService;
	@Autowired
	private PushAdapterService pushAdapterService;
	@Autowired
	private LineRouteDateService lineRouteDateService;
	@Autowired
	private ProdProductBranchService prodProductBranchService;
	@Autowired
	private ProdPackageGroupClientService prodPackageGroupService;
	@Autowired
	private ProdGroupClientService prodGroupService;
	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;
	@Autowired
	private ProdVisaDocDateClientService prodVisaDocDateService;
	@Autowired
	private ProdProductAssociationService prodProductAssociationService;
	@Autowired
	private com.lvmama.visa.api.service.VisaDocService visaDocServiceRemote;
	@Autowired
	private PermUserServiceAdapter permUserServiceAdapter;
	@Autowired
	private ComMessageService comMessageService;
	@Autowired
	private ProdProductDescriptionClientService prodProductDescriptionService;
	@Autowired
	private ScenicHotelStructuringService scenicHotelStructuringService;
	
	@Autowired
	private SuppGoodsClientService suppGoodsService;
	
	/**
	 * 行程优化页面
	 * @param model
	 * @param productId
	 * @param categoryId
	 * @return
	 */
	@RequestMapping(value = "/showAddProductTrip")
	public String showAddProductTrip(ModelMap modelMap,Long productId,Long categoryId,Long lineRouteId,Long subCategoryId,String modelVersion,String productType){
		modelMap.addAttribute("productId", productId);
		modelMap.addAttribute("categoryId", categoryId);
		modelMap.addAttribute("lineRouteId", lineRouteId);
		modelMap.addAttribute("subCategoryId", subCategoryId);
		modelMap.addAttribute("modelVersion", modelVersion);
		modelMap.addAttribute("productType", productType);
		return "/prod/route/showAddProductTrip";
	}

	/**
	 * 行程列表页面
	 * @param modelMap
	 * @param productId
	 * @param cancelFlag
	 * @return
	 */
	@RequestMapping(value = "/showUpdateRoute")
	public String showUpdateRoute(ModelMap modelMap, @Param("productId")Long productId, @Param("oldProductId")Long oldProductId , @Param("cancelFlag")String cancleFlag,
			 @Param("productType")String productType) {
		if(!(VALID.equals(cancleFlag) || INVALID.equals(cancleFlag))) {
			cancleFlag = null;
		}
		if(oldProductId!=null){
			productId = oldProductId;
		}
			//查询行程是否有关联行程，关联费用，关联合同，并在前台显示对应关联的入口（关联行程，关联费用，关联合同）
			ProdProductAssociation prodProductAssociation = prodProductAssociationService.getProdProductAssociationByProductId(productId);
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
					if(assModelVesion==null||assModelVesion!=1.0){
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
			List<ProdLineRoute> lineRouteList= checkRoute(productId);
			String routeFlag="false";
			if(lineRouteList!=null&&lineRouteList.size()>=1){
				routeFlag="true";
			}
			modelMap.addAttribute("routeFlag", routeFlag);
			//校验行程明细
			String saveRouteFlag=checkRouteDetail(productId);
			modelMap.addAttribute("saveRouteFlag", saveRouteFlag);
		}
		//获取产品行程列表
		getProdLineRouteList(modelMap, productId, cancleFlag);
		
		if(productType==""||productType==null){
			 ProdProduct prodProduct =(ProdProduct) modelMap.get("prodProduct");
			 productType=prodProduct.getProductType();
		}
		//出境-需要校验签证材料
		if("FOREIGNLINE".equals(productType)){
			String visaDocFlag=checkvisaDoc( productId);
			modelMap.addAttribute("visaDocFlag", visaDocFlag);
		}else if((ProdProduct) modelMap.get("prodProduct")!=null && ((ProdProduct) modelMap.get("prodProduct")).getBizCategoryId() == 15L){
			//国内跟团途牛对接 行程走老版本
			
			List<SuppGoods> suppGoodsList = MiscUtils.autoUnboxing( suppGoodsService.findSuppGoodsByProductId(productId));
			if(suppGoodsList!=null &&suppGoodsList.size()>0){
				a: for(SuppGoods sg:suppGoodsList){
					if(sg.getSupplierId()==23975L){
						modelMap.put("tuNiuFlag", "true");
						break a;
					}
				}
			}
		}
		
		modelMap.put("cancleFlag", cancleFlag);
		
		//判断产品版本为1.0(是供应商打包，类别为15)
		Double modelVesion = ((ProdProduct)modelMap.get("prodProduct")).getModelVersion();
		if(modelVesion==null||modelVesion!=1.0){
			modelMap.put("modelVersion", "false");
		}else if(modelVesion==1.0){
			modelMap.put("modelVersion", "true");
		}		
		return "/prod/route/showUpdateRoute";
	}

	/**
	 * 复制行程
	 * @param lineRouteId
	 * @return
	 */
	@RequestMapping(value="/copyProdLineRoute", method=RequestMethod.GET)
	@ResponseBody
	public Object copyProdLineRoute(@Param("lineRouteId")Long lineRouteId) {
		if(lineRouteId == null) {
			return new ResultMessage("fail", "行程ID不能为空！");
		}
		ProdLineRoute prodLineRoute = MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(lineRouteId));
		if(prodLineRoute == null) {
			return new ResultMessage("fail", "该行程不存在！");
		}
		
		try{
			prodLineRouteService.copyProdLineRoute(prodLineRoute);
		}catch(Exception be) {
			LOG.error(be.getMessage(), be);
			return new ResultMessage("fail", "操作失败, 请联系相关人员！");
		}
		
        logLineRouteOperate(prodLineRoute, "复制 【" + prodLineRoute.getRouteName() + "】 的行程", "复制行程");
        
        return new ResultMessage("success", "复制成功");
	}

	/**
	 * 设置行程是否有效
	 * @param lineRouteId
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/setCancelFlag", method=RequestMethod.GET)
	public Object setCancelFlagProdLineRoute(@Param("lineRouteId")Long lineRouteId) {
		if(lineRouteId == null) {
			return new ResultMessage("fail", "产品ID不能为空！");
		}
		ProdLineRoute prodLineRoute = MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(lineRouteId));
		if(prodLineRoute == null) {
			return new ResultMessage("fail", "该行程不存在！");
		}
		
		try{
			Integer re=MiscUtils.autoUnboxing(prodLineRouteService.setProdLineRouteCancelFlag(prodLineRoute));
			if(re==-1){
				return new ResultMessage("fail", "操作失败, 该行程最大晚数被可换酒店使用 不能操作为无效！"); 
			}
			if(VALID.equals(prodLineRoute.getCancleFlag())){
				pushAdapterService.push(prodLineRoute.getProductId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_LINE_ROUTE,ComPush.OPERATE_TYPE.VALID, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
			}else{
				pushAdapterService.push(prodLineRoute.getProductId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_LINE_ROUTE,ComPush.OPERATE_TYPE.INVALID, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
			}
			
			
		} catch (Exception e) {
			LOG.error(ExceptionFormatUtil.getTrace(e));
			return new ResultMessage("fail", "操作失败, 请联系相关人员！");
		}
		
        logLineRouteOperate(prodLineRoute, "行程名称【"+prodLineRoute.getRouteName()+"】 有效标识设置为："+prodLineRoute.getCancleFlag(), "行程有效标识设置");
        
		return new ResultMessage("success", "操作成功");
	}
	
	@RequestMapping(value="/editprodroutedetail", method=RequestMethod.GET)
	public String toEditProdRouteDetail(Long productId, Long lineRouteId, ModelMap modelMap, @RequestParam(required=false)String embedFlag) {
		ProdProduct prodProduct = prodProductService.findProdProductByProductId(productId);
		modelMap.addAttribute("embedFlag", "Y".equals(embedFlag)?embedFlag: "N");
		modelMap.put("prodProduct", prodProduct);
		modelMap.put("packageType", ProdProduct.PACKAGETYPE.getCnName(prodProduct.getPackageType()));
		modelMap.put("prodLineRoute", prodLineRouteService.findByProdLineRouteId(lineRouteId).getReturnContent());
		
		modelMap.put("trafficList", LineRouteEnum.TRAFFIC_TYPE.values());
		List<BizDict> hotelStarList=bizDictQueryService.findDictListByDefId(515L);
		modelMap.put("hotelStarList", hotelStarList);
		
		modelMap.put("prodLineRouteDetailList", prodLineRouteDetailService.selectByProdLineRouteId(lineRouteId));
		modelMap.put("route", new ProdLineRouteDetail());
		
		return "/prod/route/showUpdateRouteDetail";
	}
	
	/**
	 * 查看费用说明
	 * @param productId
	 * @param lineRouteId
	 * @param modelMap
	 * @return
	 */
	@RequestMapping(value="/editprodroutecost", method=RequestMethod.GET)
	public String toEditProdRouteCost(Long productId, Long lineRouteId, String editFlag, String oldProductId,ModelMap modelMap,Model model) {
		ProdProduct prodProduct = prodProductService.findProdProductByProductId(productId);
		//国内景酒自主打包
		if (Long.valueOf(181L).equals( prodProduct.getSubCategoryId() ) && (
				ProdProduct.PRODUCTTYPE.INNERLINE.name().equalsIgnoreCase(prodProduct.getProductType()) ||
				ProdProduct.PRODUCTTYPE.INNERSHORTLINE.name().equalsIgnoreCase(prodProduct.getProductType()) ||
				ProdProduct.PRODUCTTYPE.INNERLONGLINE.name().equalsIgnoreCase(prodProduct.getProductType()) ||
				ProdProduct.PRODUCTTYPE.INNER_BORDER_LINE.name().equalsIgnoreCase(prodProduct.getProductType()))) {//国内自由行景酒查询相关推荐
			Map<String, Object> result = scenicHotelStructuringService.loadCost(productId, prodProduct.getProductType(), lineRouteId,prodProduct.getBizCategoryId());
			Map<String, List<Pair<String, ScenicHotelCostIncludeVo.Item>>> map = scenicHotelStructuringService.loadPackagedProuctName(productId);
			model.addAllAttributes(result);
			model.addAttribute("map", map);
			//add routeInfo
			ProdLineRoute  lineRoute = MiscUtils.autoUnboxing( prodLineRouteService.findByProdLineRouteId(lineRouteId) );
			model.addAttribute("lineRoute", lineRoute );
			return "prod/packageTour/scenicHotel/scenicHotelCost_supplier";
		}else {
			modelMap.put("prodProduct", prodProduct);
			modelMap.put("packageType", ProdProduct.PACKAGETYPE.getCnName(prodProduct.getPackageType()));
			modelMap.put("noEditFlag", editFlag);
			modelMap.put("oldProductId", oldProductId);
			modelMap.put("productType", prodProduct.getProductType());
			//判断产品版本为1.0(是供应商打包，类别为15)
			Double modelVesion=prodProduct.getModelVersion();
			if(modelVesion==null||modelVesion!=1.0){
				modelMap.put("modelVersion", "false");
			}else if(modelVesion==1.0){
				modelMap.put("modelVersion", "true");
			}
			ProdLineRoute prodLineRoute = MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(lineRouteId));
			modelMap.put("prodLineRoute", prodLineRoute);
			return "/prod/route/showUpdateRouteCost";
		}
		
		
	}
	
	/**
	 * 保存费用说明
	 * @param lineRouteId
	 * @param include
	 * @param exclude
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/editprodroutecost", method=RequestMethod.POST)
	public Object editProdRouteCost(Long lineRouteId, String include, String exclude) {
		ProdLineRoute prodLineRoute = MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(lineRouteId));
		if(prodLineRoute == null) {
			return new ResultMessage("fail", "该行程不存在！");
		}
		String logText = "行程名称：" + prodLineRoute.getRouteName() + 
						 ";【费用包含】原始值：" + prodLineRoute.getCostInclude() + ";新值：" + include + 
						 ";【费用不包含】原始值：" + prodLineRoute.getCostExclude() + ";新值：" + exclude;

		try{
			prodLineRoute.setCostInclude(include);
			prodLineRoute.setCostExclude(exclude);
			prodLineRouteService.updateProdLineRoute(prodLineRoute);
		} catch (Exception e) {
			LOG.error(ExceptionFormatUtil.getTrace(e));
			return new ResultMessage("fail", "保存失败, 请联系相关人员！");
		}
		
		//如果当地游产品被跟团游产品打包，且当地游产品名称修改，消息通知跟团游产品经理
		if (prodLineRoute.getProductId() != null) {
			ProdProduct prodProduct = prodProductService.findProdProductByProductId(prodLineRoute.getProductId());
			if (prodProduct != null) {
				if (Constant.VST_CATEGORY.CATEGORY_ROUTE_LOCAL.getCategoryId().equalsIgnoreCase(String.valueOf(prodProduct.getBizCategoryId()))) {
					
					//查询当地游产品是否被跟团游产品打包
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("bizCategoryId", 15);
					params.put("packageType", "LVMAMA");
					params.put("productId", prodProduct.getProductId());
					params.put("groupName", "当地游");
					List<ProdProduct> packProductList = prodProductService.getPackProductListByParams(params);
					
					if (CollectionUtils.isNotEmpty(packProductList)) {
						LOG.info("当前当地游产品被跟团游产品打包，且当地游产品费用说明被修改，向产品经理发送通知，packProductList size = "+packProductList.size()+"当地游:productid = "+prodProduct.getProductId());
						PermUser localPermUser = permUserServiceAdapter.getPermUserByUserId(prodProduct.getManagerId());
						if (localPermUser != null && localPermUser.getUserName() != null) {
							for (ProdProduct packProdProduct : packProductList) {
								//内容
								String content = "您的跟团游产品"+packProdProduct.getProductId()
										+"中的当地游"+prodProduct.getProductId()
										+"发生信息变更，请及时跟进维护";
								//operatorName
								PermUser permUser = permUserServiceAdapter.getPermUserByUserId(packProdProduct.getManagerId());
								if(permUser != null && permUser.getUserName() != null) {
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
		}
		
		logLineRouteOperate(prodLineRoute, logText, "编辑费用包含");
		//发送消息
        pushAdapterService.push(prodLineRoute.getProductId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_PRODUCT,ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);    
		return new ResultMessage("success", " 保存成功！");
	}
	
	/**
	 * 去  查看所有行程适用出发日期  页面
	 * @param productId
	 * @return
	 */
	@RequestMapping(value="/showlinedate")
	public String toShowAllProdLineRouteDate(Long productId, ModelMap modelMap) {
		modelMap.put("productId", productId);
		return "/prod/route/showlinedate";
	}
	
	/**
	 * 查询  所有行程适用出发日期
	 * @param productId
	 * @param specDate
	 * @param modelMap
	 * @return
	 */
	@RequestMapping(value="/getRouteName")
	@ResponseBody
	public Object getRouteName(Long productId,Date specDate, ModelMap modelMap){
		List list = new ArrayList();
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("productId", productId);
		parameters.put("begin",CalendarUtils.getFirstDayOfMonth(specDate));
		parameters.put("end", CalendarUtils.getLastDayOfMonth(specDate));
		parameters.put("cancleFlag", 'Y');
		List<ProdLineRoute> prodLineRouteList=prodLineRouteService.queryLineRouteByProductIdAndDate(parameters);
		if(prodLineRouteList!=null){
			for(ProdLineRoute route :prodLineRouteList){
				for(LineRouteDate date :route.getLineRouteDateList()){
					ProdLineRoute pr=new ProdLineRoute();
					pr.setRouteName(route.getRouteName());
					pr.setSpecDate(date.getSpecDate());
					list.add(pr);
				}
			}
			 
		} 
		 return list;
	}

	@ResponseBody
	@RequestMapping(value="/showlinedate", method=RequestMethod.POST)
	public Object showAllProdLineRouteDate(Long productId, Date specDate) {
		List<ProdLineRoute> result = prodLineRouteService.queryLineRouteByProductIdAndDate(productId, specDate);
		return result != null ? result : Collections.emptyList();
	}
	
	@RequestMapping(value = "/showUpdateLineRouteDate")
	public String showUpdateLineRouteDate(Long productId, ModelMap modelMap) {
		//获取产品行程列表
		getProdLineRouteList(modelMap, productId, VALID);
		return "/prod/route/showupdatelineroutedate";
	}

	@ResponseBody
	@RequestMapping(value = "/updateLineRouteDate")
	public Object updateLineRouteDate(LineRouteDateVO lineRouteDateVO) {
		String logStr = "";
		try {
			logStr = getUpdateLineRouteDateLog(lineRouteDateVO);
		} catch (Exception e) {
			LOG.error(ExceptionFormatUtil.getTrace(e));
		}
		try {
			lineRouteDateService.updateProductLineRouteDate(lineRouteDateVO);
		} catch (BusinessException e) {
			return new ResultMessage("error", e.getMessage());
		}
		try{
            comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
            		lineRouteDateVO.getProductId(), lineRouteDateVO.getProductId(), 
                   this.getLoginUser().getUserName(),
                    "修改适用行程:"+logStr.toString(), 
                    COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_TIME.name(), 
                    "修改适用行程",null);
        } catch (Exception e) {
            log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
            log.error(e.getMessage());
        }
		return ResultMessage.SET_SUCCESS_RESULT;
	}
	
	@RequestMapping(value = "/updateExistsLineRouteDate")
	@ResponseBody
	public Object updateExistsLineRouteDate(LineRouteDateVO lineRouteDateVO) {
		String logStr = "";
		try {
			logStr = getUpdateLineRouteDateLog(lineRouteDateVO);
		} catch (Exception e) {
			LOG.error(ExceptionFormatUtil.getTrace(e));
		}
		try {
			String selectCalendar = lineRouteDateVO.getSelectCalendar();
			if(StringUtil.isEmptyString(selectCalendar)){
				throw new BusinessException("selectCalendar must be not null");
			}
			List<Date> dateList = getSuppGoodSelectDate(lineRouteDateVO.getStartDate(), lineRouteDateVO.getEndDate(), lineRouteDateVO.getWeekDay(), 
					lineRouteDateVO.getSelectDates(),lineRouteDateVO.getSelectCalendar());
			if(null==dateList || dateList.isEmpty()){
				throw new BusinessException("请选择日期或时间");
			}
			lineRouteDateService.updateExistsLineRouteDate(lineRouteDateVO.getProductId(),lineRouteDateVO.getLineRouteId(),dateList);
		} catch (BusinessException e) {
			return new ResultMessage("error", e.getMessage());
		}
		try{
            comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
            		lineRouteDateVO.getProductId(), lineRouteDateVO.getProductId(), 
            	   this.getLoginUser().getUserName(),
                    "修改适用行程:"+logStr.toString(), 
                    COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_TIME.name(), 
                    "修改适用行程",null);
        } catch (Exception e) {
            log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
            log.error(e.getMessage());
        }
		return ResultMessage.SET_SUCCESS_RESULT;
	}
	/**
	 * 修改签证材料最晚上传时间 
	 * @param lineRouteId
	 * @param productId
	 * @return
	 * @throws BusinessException
	 */
	
	@RequestMapping(value = "/updatePordVisaDocDate")
	@ResponseBody
	public Object updatePordVisaDocDate(LineRouteDateVO lineRouteDateVO) {
		try {
			prodVisaDocDateService.saveOrUpdateVisaDocDate(lineRouteDateVO.getProductId(), lineRouteDateVO.getUpDocLastTime());
		}catch (Exception e) {
			log.error(e.getMessage(), e);
		}
		return ResultMessage.SET_SUCCESS_RESULT;
	}
	
	/**
	 * 点击‘新增’或‘编辑’按钮后，查询单个行程
	 * @param lineRouteId
	 * @param productId
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/selectProdLineRoute")
	public String selectProdLineRoute(Long lineRouteId,Long productId, @RequestParam(required=false)String embedFlag) throws BusinessException {
		ProdLineRoute prodLineRoute=new ProdLineRoute();
		ProdProduct prodProduct = prodProductService.findProdProductByProductId(productId);
		HttpServletLocalThread.getModel().addAttribute("bizCategory", prodProduct.getBizCategory());
		HttpServletLocalThread.getModel().addAttribute("prodProduct", prodProduct);
		HttpServletLocalThread.getModel().addAttribute("embedFlag", "Y".equals(embedFlag)?embedFlag: "N");
		//判断行程是否可以修改
		HttpServletLocalThread.getModel().addAttribute("routeChangeAble",isRouteChangeAble(productId));
		if (lineRouteId==null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("productId", productId);
			String routName =null;
			try {
				routName = MiscUtils.autoUnboxing(prodLineRouteService.generateProdLineRouteName(productId));
			} catch (Exception e) {
				log.error(e.getMessage(), e);
			}
			List<ProdLineRoute> prodLineRouteList = prodLineRouteService.findProdLineRouteByParams(params);
			if(CollectionUtils.isNotEmpty(prodLineRouteList)){
				Collections.reverse(prodLineRouteList);
				ProdLineRoute prodLineRoutes = prodLineRouteList.get(0);
				HttpServletLocalThread.getModel().addAttribute("prodLineRoutes", prodLineRoutes.getLineRouteId()+1);
			}
			HttpServletLocalThread.getModel().addAttribute("routName", routName);
			if("自由行".equals(prodProduct.getBizCategory().getCategoryName()) && "DESTINATION_BU".equals(prodProduct.getBu()) && prodProduct.getSubCategoryId()==181 )
			{
				return "/prod/route/addRoute";
				
			}
			else{
				return "/prod/route/addRouteForAim";
		    }
			}
		//查询行程
		HashMap<String,Object> hm = new HashMap<String, Object>();
		hm.put("lineRouteId",lineRouteId);
		
		List<ProdLineRoute> prList =null;
		try {
			prList = MiscUtils.autoUnboxing(prodLineRouteService.findProdLineRouteByParamsSimple(hm));
		} catch (Exception e) {
			log.error(e.getMessage(), e);
		}
		if(prList!=null && prList.size()>0){
			prodLineRoute =  prList.get(0);
		}
		HttpServletLocalThread.getModel().addAttribute("prodLineRoute", prodLineRoute);
		if("自由行".equals(prodProduct.getBizCategory().getCategoryName()) && "DESTINATION_BU".equals(prodProduct.getBu()) && prodProduct.getSubCategoryId()==181 )
		{
			return "/prod/route/updateRoute";
			
		}
		else{
			return "/prod/route/updateRouteForAim";
	    }
	}
	
	
	/**
	 * 保存或更新行程
	 * @param prodLineRoute
	 * @param productId
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/addProdLineRoute")
	@ResponseBody
	public Object addProdLineRoute(ProdLineRoute prodLineRoute,Long productId) throws BusinessException {
		if(prodLineRoute.getLineRouteId()!=null){
			ProdLineRoute oldProdLineRoute = MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(prodLineRoute.getLineRouteId()));
			try {
				prodLineRouteService.updateProdLineRoute(prodLineRoute);
			} catch (Exception e) {
				log.error(e.getMessage(), e);
			} 
	        logLineRouteOperate(prodLineRoute, buildUpdateLineRouteLogText(prodLineRoute, oldProdLineRoute), "编辑行程");
	        //发送消息
	        pushAdapterService.push(prodLineRoute.getProductId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_PRODUCT,ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);    
			//更新景酒 产品名称 行程天数+目的地；
	        updateName(productId,prodLineRoute.getRouteNum(),prodLineRoute.getStayNum());
	        return ResultMessage.UPDATE_SUCCESS_RESULT;
		}
		
		prodLineRoute.setProductId(productId);
		prodLineRoute.setCancleFlag("Y");
		prodLineRoute.setWarningFlag("Y");
		prodLineRoute.setNewStructureFlag("Y");
		prodLineRoute.setCreateTime(new Date());
		try {
			Long lineRouteId = prodLineRouteService.saveProdLineRoute(prodLineRoute);
			prodLineRoute.setLineRouteId(lineRouteId);
		} catch (Exception e) {
			log.error(e.getMessage(), e);
		}
		
		logLineRouteOperate(prodLineRoute, "新建 【"+prodLineRoute.getRouteName()+"】 的行程", "新建行程");
		
		ResultMessage addMsg =ResultMessage.ADD_SUCCESS_RESULT;
		addMsg.addObject("lineRouteId", prodLineRoute.getLineRouteId());
		 //发送消息
        pushAdapterService.push(prodLineRoute.getProductId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_PRODUCT,ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);  
        //更新景酒 产品名称 行程天数+目的地；
        updateName(productId,prodLineRoute.getRouteNum(),prodLineRoute.getStayNum());
        return addMsg;
	}

	//校验自主打包行程数量、供应商打包是否已被打包
	@RequestMapping(value = "/valiLVMAMALineRoute")
	@ResponseBody
	public Object valiLVMAMALineRoute(Long productId) throws BusinessException {
		ProdProduct product=prodProductService.findProdProductByProductId(productId);
		String packageType=product.getPackageType();
		HashMap<String,Object> hm = new HashMap<String, Object>();
		hm.put("productId",productId);
		//自主打包为单行程
		if("LVMAMA".equalsIgnoreCase(packageType)){
			
			List<ProdLineRoute> prodLineRouteList =null;
			try {
				prodLineRouteList = MiscUtils.autoUnboxing(prodLineRouteService.findProdLineRouteByParamsSimple(hm));
			} catch (Exception e) {
				log.error(e.getMessage(), e);
			}
			if(prodLineRouteList!=null&&prodLineRouteList.size()>=1){
				return  new ResultMessage("error", "自主打包不可设置多行程");
			}
		}else{
			//非酒店套餐
			if(!Constant.VST_CATEGORY.CATEGORY_ROUTE_HOTELCOMB.name().equalsIgnoreCase(product.getBizCategory().getCategoryCode())){
				hm.put("branchName", "成人/儿童/房差");
			} 
			boolean  packFlag=prodProductBranchService.selectPackageBranchFlag(hm);
			if(packFlag){
				return  new ResultMessage("error", "已被自主打包产品打包，不能新建行程");
			}
		}
		if(productId != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("associatedRouteProdId", productId);
			List<ProdProductAssociation> prodProductAssociations = prodProductAssociationService.findProdProductAssociationByParams(params);
			if(prodProductAssociations != null && prodProductAssociations.size() > 0){
				return new ResultMessage("error", "已被其他产品关联行程明细及合同条款，不可设置多行程");
			}
			Map<String, Object> pms = new HashMap<String, Object>();
			pms.put("associatedFeeIncludeProdId",productId);
			List<ProdProductAssociation> prodProductAssociationList = prodProductAssociationService.findProdProductAssociationByParams(pms);
			if(prodProductAssociationList != null && prodProductAssociationList.size() > 0){
				return new ResultMessage("error", "已被其他产品关联费用说明，不可设置多行程");
			}
		}

		return ResultMessage.ADD_SUCCESS_RESULT;
	}
	/**
	 * 获取某行程的签证材料
	 * @param productId
	 * @return
	 */
	@RequestMapping(value = "/selectProdVisadocRe")
	public String selectProdVisadocRe(Long productId,Long lineRouteId)throws BusinessException {
		//取得签证与产品关联
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("productId", productId);
		params.put("lineRouteId", lineRouteId);
		List<ProdVisadocRe> prodVisadocReList = prodVisadocReService.findProdVisadocReByParams(params);
		StringBuilder docIds = new StringBuilder(",");
		List<com.lvmama.visa.api.vo.doc.VisaDoc> bizVisaDocList = new ArrayList<>();
		if(prodVisadocReList != null && prodVisadocReList.size() > 0){
			for(ProdVisadocRe prodVisaRe : prodVisadocReList){
				docIds.append(prodVisaRe.getVisaDocId()).append(",");
				//改为接口的方式进行访问
				com.lvmama.visa.api.vo.doc.VisaDoc visaDoc = visaDocServiceRemote.findBizVisaDocById(prodVisaRe.getVisaDocId()).getReturnContent();
				bizVisaDocList.add(visaDoc);
			}
			HttpServletLocalThread.getModel().addAttribute("docIds", docIds);
			HttpServletLocalThread.getModel().addAttribute("bizVisaDocList", bizVisaDocList);
		}
		//查询签证类型\送签城市字典
		params.clear();
		params.put("dictCode", "VISA_TYPE");
		List<BizDictExtend> vistTypeList = dictService.findBizDictExtendList(params);
		params.clear();
		params.put("dictCode", "VISA_CITY");
		List<BizDictExtend> vistCityList = dictService.findBizDictExtendList(params);
		HttpServletLocalThread.getModel().addAttribute("vistTypeList", vistTypeList);
		HttpServletLocalThread.getModel().addAttribute("vistCityList", vistCityList);
		HttpServletLocalThread.getModel().addAttribute("productId", productId);
		HttpServletLocalThread.getModel().addAttribute("lineRouteId", lineRouteId);
		return "/prod/route/visaDocList";
	}
	
	/**
	 * 添加签证与行程关联
	 * @param docIds
	 * @param productId
	 * @param lineRouteId
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/updateVisaDocRe")
	@ResponseBody
	public Object updateVisaDocRe(String docIds,Long productId,Long lineRouteId)throws BusinessException {
		//更新签证与行程关联(先删除后重建)
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("lineRouteId", lineRouteId); 
		List<ProdVisadocRe> oldProdVisadocReList=prodVisadocReService.findProdVisadocReByParams(params);
		
		prodVisadocReService.deleteByParams(params);
		 
		//添加签证与行程关联
		if(StringUtil.isNotEmptyString(docIds)){
			for(String docId : docIds.split(",")){
				ProdVisadocRe prodVisadocRe = new ProdVisadocRe();
				if(docId.length()==0) continue;
				prodVisadocRe.setVisaDocId(Long.parseLong(docId));
				prodVisadocRe.setProductId(productId);
				prodVisadocRe.setLineRouteId(lineRouteId);
			 
				prodVisadocReService.addProdVisadocRe(prodVisadocRe) ;
			}
			 
		}
		String visaDocFlag =checkvisaDoc(productId);
		String oldVisId="";
		for(ProdVisadocRe vis:oldProdVisadocReList){
			oldVisId+=vis.getVisaDocId()+" ,";
		}
		//获取行程名称
		ProdLineRoute  prodLineRoute=MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(lineRouteId));
        ProdLineRoute lineRoute = new ProdLineRoute();
        lineRoute.setProductId(lineRouteId);
        lineRoute.setLineRouteId(lineRouteId);
        logLineRouteOperate(lineRoute, "【"+prodLineRoute.getRouteName()+"】 签证材料【原值：签证id="+oldVisId+" 新值：签证id="+docIds+"】", "新建/修改关联签证材料");
		
		 return  new ResultMessage("success",visaDocFlag);
	}
	
	private void getProdLineRouteList(ModelMap modelMap, Long productId, String cancleFlag) {
		ProdProduct prodProduct = prodProductService.getProdProductBy(productId);
		prodProduct.setBizCategory(bizCategoryQueryService.getCategoryById(prodProduct.getBizCategoryId()));
		modelMap.put("prodProduct", prodProduct);
		modelMap.put("packageType", ProdProduct.PACKAGETYPE.getCnName(prodProduct.getPackageType()));
		
		Map<String, Object> params = new HashMap<String, Object>(2, 1f);
		params.put("productId", productId);
		params.put("cancleFlag", cancleFlag);
		List<ProdLineRoute> prodLineRouteList = prodLineRouteService.findProdLineRouteByParams(params);
		modelMap.put("prodLineRouteList", prodLineRouteList);
	}
	
	/**
	 * 记录行程操作日志
	 */
	private void logLineRouteOperate(ProdLineRoute LineRoute, String logText, String logName) {
		try{
			PermUser operateUser = this.getLoginUser();
			comLogService.insert(PROD_LINE_ROUTE, LineRoute.getProductId(), LineRoute.getLineRouteId(),
					operateUser==null? "" : operateUser.getUserName(), logText, PROD_TRAVEL_DESIGN.name(), logName, null);
		}catch(Exception e) {
			log.error("Record Log failure ！Log Type:" + PROD_TRAVEL_DESIGN.name());
			log.error(e.getMessage(), e);
		}
		synProdGroup(LineRoute);
	}
	
	/**
	 * 生产编辑行程的日志内容
	 */
	private String buildUpdateLineRouteLogText(ProdLineRoute prodLineRoute, ProdLineRoute oldProdLineRoute) {
		String logVal="行程名称【原值："+oldProdLineRoute.getRouteName()+" 新值："+prodLineRoute.getRouteName()+"】；" +
				"行程天数【原值："+oldProdLineRoute.getRouteNum()+"新值："+prodLineRoute.getRouteNum()+"】；" +
				"航班原因【原值："+oldProdLineRoute.getTrafficNum()+"新值："+prodLineRoute.getTrafficNum()+"】；" +
				"行程晚数【原值："+oldProdLineRoute.getStayNum()+"新值："+prodLineRoute.getStayNum()+"】；" +
		        "行程特色【原值："+oldProdLineRoute.getRouteFeature()+"新值："+prodLineRoute.getRouteFeature()+"】；" ;
		
		return logVal;
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
		List<ProdLineRoute> prodRouteList =null;
		try {
			prodRouteList = MiscUtils.autoUnboxing(prodLineRouteService.findProdLineRouteByParamsSimple(pars));
		} catch (Exception e) {
			log.error(e.getMessage(), e);
		}
		return prodRouteList;
	}
	
	//判断行程天数是否可以修改
	private String isRouteChangeAble(Object productId){
		HashMap<String,Object> pp = new HashMap<String, Object>();
		pp.put("productId",productId);
		String routeChangeAble = "Y";
		//查询是否有可换酒店
		List<ProdPackageGroup> list = prodPackageGroupService.findProdPackageGroup(pp);
		if(list!=null && list.size()>0){
			for(ProdPackageGroup ppg : list){
				//如果有可换酒店，则不能修改
				if(ppg.getGroupType().equals(ProdPackageGroup.GROUPTYPE.CHANGE.name())
						||ppg.getGroupType().equals(ProdPackageGroup.GROUPTYPE.HOTEL.name())
						||ppg.getGroupType().equals(ProdPackageGroup.GROUPTYPE.LINE.name())
						||ppg.getGroupType().equals(ProdPackageGroup.GROUPTYPE.TRANSPORT.name())
						||ppg.getGroupType().equals(ProdPackageGroup.GROUPTYPE.LINE_TICKET.name())
						){
					routeChangeAble = "N";
				}
			}
		}
		return routeChangeAble;
	}
	
	private String getUpdateLineRouteDateLog(LineRouteDateVO lineRouteDateVO){
		StringBuffer logStr = new StringBuffer();
		String selectCalendar = lineRouteDateVO.getSelectCalendar();
		if(StringUtil.isEmptyString(selectCalendar)){
			throw new BusinessException("selectCalendar must be not null");
		}
		List<Date> dateList = getSuppGoodSelectDate(lineRouteDateVO.getStartDate(), lineRouteDateVO.getEndDate(), lineRouteDateVO.getWeekDay(), 
				lineRouteDateVO.getSelectDates(),lineRouteDateVO.getSelectCalendar());
		
		if(null==lineRouteDateVO.getProductId()){
			throw new BusinessException("productId must be not null");
		}
		
		Long lineRouteId = lineRouteDateVO.getLineRouteId();
		
		if(null!=dateList && !dateList.isEmpty()){
			Map<String,Object> params = new HashMap<String, Object>();
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			for (Date date : dateList) {
				params.put("specDate", date);
				params.put("productId", lineRouteDateVO.getProductId());
				ProdLineRoute prodLineRoute = MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(lineRouteId));//新行程
				List<LineRouteDate> lineRouteDates = lineRouteDateService.findByParams(params);
				if(null!=lineRouteDates && !lineRouteDates.isEmpty()){
					LineRouteDate lineRouteDate = lineRouteDates.get(0);
					ProdLineRoute dto = lineRouteDate.getProdLineRoute();// 原有行程
					if(null!=lineRouteId && null!=dto && !lineRouteId.equals(dto.getLineRouteId())){
						if(null!=prodLineRoute){
							//修改
							logStr.append("日期-").append(df.format(date)).append(ComLogUtil.getLogTxt(" 行程:",prodLineRoute.getRouteName(),dto.getRouteName()));
						}
					}
				}else{
					if(null!=prodLineRoute){
						//新增
						logStr.append("日期-").append(df.format(date)).append(ComLogUtil.getLogTxt(" 行程:",prodLineRoute.getRouteName(),null));
					}
				}
			}
		}
		return logStr.toString();
	}
	
	/**
	 * 根据选择日期的方式得到时间集合
	 * @param startDate 开始日期
	 * @param endDate 结束日期
	 * @param weekDay 适用日期
	 * @param selectDates 选择的日期
	 * @param selectCalendar 选择时间的方式
	 * @return
	 * @throws Exception 
	 */
	private List<Date> getSuppGoodSelectDate(Date startDate,Date endDate,List<Integer> weekDay,List<String> selectDates,String selectCalendar){
		List<Date> dateList = new ArrayList<Date>();
		// 时间段
		if(selectCalendar.equalsIgnoreCase("selectTime")){
			dateList = CalendarUtils.getDates(startDate,endDate,weekDay);
		}else{
			if(null!=selectDates && !selectDates.isEmpty()){
				for (String specDate : selectDates) {
					SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
					try {
						Date date = df.parse(specDate);
						dateList.add(date);
					} catch (ParseException e) {
						throw new BusinessException("日期格式错误");
					}
				}
			}
		}
		if(null==dateList || dateList.isEmpty()){
			throw new BusinessException("dateList must be not null");
		}
		return dateList;
	}
	
	/**
	 * 同步产品关联
	 * @param prodLineRoute
	 */
	@Async
	private void synProdGroup(ProdLineRoute LineRoute){
		LOG.info("ProdLineRouteAction.synProdGroup start...");
		StringBuilder builder =new StringBuilder(80);
		try{
			builder.append("【lineRouteId=").append(LineRoute.getLineRouteId());
			builder.append(",routeNum=").append(LineRoute.getRouteNum());
			builder.append(",stayNum=").append(LineRoute.getStayNum()).append("】");
			LOG.info(builder.toString());
			
			ProdGroup prodGroup =new ProdGroup();
			prodGroup.setLineRouteId(LineRoute.getLineRouteId());
			prodGroup.setRouteNum(LineRoute.getRouteNum());
			prodGroup.setStayNum(LineRoute.getStayNum());
			prodGroupService.updateByRouteId(prodGroup);
		}catch(Exception e){
			LOG.error(ExceptionFormatUtil.getTrace(e));
		}
	}
	
	@RequestMapping(value="/showReferRouteForm")
	public String showReferRouteForm(Model model,Long productId,Long categoryId,Long lineRouteId,Long subCategoryId,String modelVersion,String productType,HttpServletRequest req) throws BusinessException{
		model.addAttribute("productId", productId);
		model.addAttribute("categoryId", categoryId);
		model.addAttribute("lineRouteId", lineRouteId);
		model.addAttribute("subCategoryId", subCategoryId);
		model.addAttribute("modelVersion", modelVersion);
		model.addAttribute("productType", productType);
		return "/prod/route/referRoute";
	}
	
	/**
	 * 获取引用产品行程
	 * @param productId 引用产品id
	 * @return
	 */
	@RequestMapping(value="/getProdLineRouteList")
	@ResponseBody
	public Object getProdLineRouteList(Long productId){
		Map<String,Object> params = new HashMap<String, Object>();
		params.put("productId", productId);
		List<ProdLineRoute> prodLineRouteList =null;
		try {
			prodLineRouteList = MiscUtils.autoUnboxing(prodLineRouteService.findProdLineRouteByParamsSimple(params));
		} catch (Exception e) {
			LOG.error(ExceptionFormatUtil.getTrace(e));
		}
		ProdProduct referproduct = prodProductService.findProdProductByProductId(productId);
		if(referproduct.getBizCategoryId() == 17L){
			return new ResultMessage("error","不可引用酒店套餐产品");
		}
		//返回JSON数组
		JSONArray jsonArray = new JSONArray();
		if(prodLineRouteList != null && prodLineRouteList.size() > 0){
			for(ProdLineRoute prodLineRoute : prodLineRouteList){
				Map<String,Object> routeName = new HashMap<String, Object>();
				routeName.put("routeName", prodLineRoute.getRouteName());
				routeName.put("routeId", prodLineRoute.getLineRouteId());
				JSONObject jsonObject = JSONObject.fromObject(routeName);
				jsonArray.add(jsonObject);
			}
			return new ResultMessage("success", jsonArray.toString());
		}else{
			return new ResultMessage("error","该产品无可引用的行程");
		}
	}
	
	/**
	 * 引用行程
	 * @param referProductId 引用产品id
	 * @param mainRouteId 主产品行程id
	 * @param referRouteId 引用产品行程id
	 * @return
	 */
	@RequestMapping(value="/referProductRoute")
	@ResponseBody
	public Object referProductRoute(Long referProductId,Long mainRouteId,Long referRouteId){
		if(mainRouteId!= null && referRouteId != null){
			ProdLineRoute referLineRoute = MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(referRouteId));
			ProdLineRoute mainLineRoute = MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(mainRouteId));
			List<ProdLineRouteDetail> prodLineRouteDetails = prodLineRouteDetailService.selectByProdLineRouteId(mainRouteId);
			try {
				prodLineRouteService.referProdLineRoute(mainLineRoute, referLineRoute);
			} catch (Exception e) {
				log.error(e.getMessage(), e);
			}
			//添加操作日志
			if(prodLineRouteDetails != null && prodLineRouteDetails.size()>0){
				logLineRouteOperate(mainLineRoute, "删除原有行程内容。引用产品ID："+ referLineRoute.getProductId()+ ","+ referLineRoute.getRouteName()+"。"+"【"+mainLineRoute.getRouteName()+"】 创建行程明细", "引用行程");
			}else{
				logLineRouteOperate(mainLineRoute, "引用产品ID："+ referLineRoute.getProductId()+ ","+ referLineRoute.getRouteName()+"。"+"【"+mainLineRoute.getRouteName()+"】 创建行程明细", "引用行程");
			}
			return new ResultMessage("success","引用成功");
		}
		return new ResultMessage("error","error");
	}
	
	private void updateName(Long productId,Short routeNum,Short stayNum ){
		String destName="";
		String destNameTest="";
		if(routeNum!=null&&stayNum!=null){
			ProdProductParam param = new ProdProductParam();
			param.setProductProp(true);
			param.setProductPropValue(true);
			ProdProduct prodProduct = prodProductService.findProdProductByProductId(productId);
			if(prodProduct!=null && "LVMAMA".equals(prodProduct.getPackageType()) && "INNERLINE".equals(prodProduct.getProductType())){
				try{
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
					if(!"".equals(destName)){
						destName = destName+" "+routeNum+"天"+stayNum+"晚";
					}else{
						destName = routeNum+"天"+stayNum+"晚";
					}
					//产品名称结构化信息
					Map<String,Object> productNameParam = new HashMap<String, Object>();
					productNameParam.put("productId", prodProduct.getProductId());
					productNameParam.put("productType", prodProduct.getProductType());
					productNameParam.put("contentType", ProdProductDescription.CONTENT_TYPE.PRODUCT_NAME.name());
					List<ProdProductDescription> productDescriptionList = MiscUtils.autoUnboxing(prodProductDescriptionService.findProductDescriptionListByParams(productNameParam));
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
								productNameVo = com.alibaba.fastjson.JSONObject.parseObject(content, ProdProductNameVO.class);
							}
							if(productNameVo!=null){
								if(productNameVo.getJjDestDay()!=null){
									productNameVo.setJjDestDay(destName);
								}
								String jsonStr = com.alibaba.fastjson.JSONObject.toJSONString(productNameVo);
								productDescription.setContent(jsonStr);
								prodProductDescriptionService.saveOrUpdateDoublePlaceForProductDes(productDescription);
								break;
							}
						}
					}
				
				}catch(Exception e){
					LOG.error("updateName error productId="+prodProduct.getProductId(),e);
				}
			}
		}
	}
}