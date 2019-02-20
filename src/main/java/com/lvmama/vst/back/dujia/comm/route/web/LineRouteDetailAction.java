package com.lvmama.vst.back.dujia.comm.route.web;

import static com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE.PROD_TRAVEL_DESIGN;
import static com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE.PROD_LINE_ROUTE;

import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfig;

import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.comm.pet.po.pub.ComMessage;
import com.lvmama.comm.pet.service.pub.ComMessageService;
import com.lvmama.comm.vo.ConstantJMS;
import com.lvmama.vst.back.biz.po.BizDest;
import com.lvmama.vst.back.biz.po.BizDict;
import com.lvmama.vst.back.biz.po.BizEnum.BIZ_CATEGORY_TYPE;
import com.lvmama.vst.back.biz.service.BizDictQueryService;
import com.lvmama.vst.back.client.biz.service.DestClientService;
import com.lvmama.vst.back.dujia.comm.route.detail.po.ProdRouteDetailActivity;
import com.lvmama.vst.back.dujia.comm.route.detail.po.ProdRouteDetailGroup;
import com.lvmama.vst.back.dujia.comm.route.detail.po.ProdRouteDetailHotel;
import com.lvmama.vst.back.dujia.comm.route.detail.po.ProdRouteDetailMeal;
import com.lvmama.vst.back.dujia.comm.route.detail.po.ProdRouteDetailRecommend;
import com.lvmama.vst.back.dujia.comm.route.detail.po.ProdRouteDetailScenic;
import com.lvmama.vst.back.dujia.comm.route.detail.po.ProdRouteDetailShopping;
import com.lvmama.vst.back.dujia.comm.route.detail.po.ProdRouteDetailVehicle;
import com.lvmama.vst.back.dujia.comm.route.detail.po.ProdRouteDetailVehicle.VEHICLE_TYPE;
import com.lvmama.vst.back.dujia.comm.route.detail.service.ProdLineRouteDetailHelperService;
import com.lvmama.vst.back.dujia.comm.route.detail.service.ProdRouteDetailGroupService;
import com.lvmama.vst.back.dujia.comm.route.detail.service.ProdRouteDetailHotelService;
import com.lvmama.vst.back.dujia.comm.route.detail.service.ProdRouteDetailMealService;
import com.lvmama.vst.back.dujia.comm.route.detail.service.ProdRouteDetailScenicService;
import com.lvmama.vst.back.dujia.comm.route.detail.service.ProdRouteDetailShoppingService;
import com.lvmama.vst.back.dujia.comm.route.detail.utils.ProdRouteDetailUtils;
import com.lvmama.vst.back.dujia.comm.route.detail.utils.RouteDetailFormat;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.goods.vo.ProdProductParam;
import com.lvmama.vst.back.prod.po.ProdLineRoute;
import com.lvmama.vst.back.prod.po.ProdLineRouteDetail;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductBranch;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteDetailClientService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteClientService;
import com.lvmama.vst.back.prod.service.ProdProductBranchService;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.prod.service.ProdVisadocReService;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.pub.service.PushAdapterService;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;
import com.lvmama.vst.back.utils.MiscUtils;

import freemarker.template.Template;

@Controller
@RequestMapping("/dujia/comm/route/detail")
public class LineRouteDetailAction extends BaseActionSupport {

	private static final long serialVersionUID = -4251086752438532872L;

	@Autowired
	private ProdProductService prodProductService;

	@Autowired
	private ProdLineRouteClientService prodLineRouteService;

	@Autowired
	private ProdVisadocReService prodVisadocReService;

	@Autowired
	private ProdLineRouteDetailClientService prodLineRouteDetailService;

	@Autowired
	private ProdLineRouteDetailHelperService prodLineRouteDetailHelperService;

	@Autowired
	private ProdRouteDetailGroupService prodRouteDetailGroupService;

	@Autowired
	private ProdRouteDetailScenicService prodRouteDetailScenicService;
	
	@Autowired
	private ProdRouteDetailShoppingService prodRouteDetailShoppingService;

	@Autowired
	private ProdRouteDetailMealService prodRouteDetailMealService;

	@Autowired
	private ProdRouteDetailHotelService prodRouteDetailHotelService;
	
	@Autowired
	private ComLogClientService comLogService;

	@Autowired
	private FreeMarkerConfig config;

	@Autowired
	private FreeMarkerConfig freeMarkerConfig;

	@Autowired
	private BizDictQueryService bizDictQueryService;

	@Autowired
	private DestClientService destService;

	@Autowired
	private ProdProductBranchService prodProductBranchService;
	
	@Autowired
	private PushAdapterService pushAdapterService;
	
	@Autowired
	private PermUserServiceAdapter permUserServiceAdapter;
	
	@Autowired
	private ComMessageService comMessageService;
	
	private static final String STAR_CHANGE = "民宿/客栈/其他";

	/**
	 * 渲染行程明细页面
	 */
	@RequestMapping(value = "/showRouteDetail")
	public String showRouteDetail(Model model, Long routeId , String editFlag,Long categoryId) {
		ProdLineRoute prodLineRoute = MiscUtils.autoUnboxing(prodLineRouteService.findRouteReByRouteId(routeId));
		ProdProduct prodProduct = prodProductService.getProdProductBy(prodLineRoute.getProductId());
		this.loadProdLineRouteVoInfo(prodLineRoute);//加载话术模板等信息
		RouteDetailFormat.escapeRouteHtml(prodLineRoute);//转义行程信息上HTML特殊字符
		//酒店产品 星级
		List<BizDict> hotelStarList = bizDictQueryService.findDictListByDefId(2L);
		//产品 星级
		List<BizDict> prodStarList = bizDictQueryService.findDictListByDefId(515L);
		//TASK #38179 
		for (BizDict bizDict : hotelStarList) {
			if(bizDict.getDictId() != null){
				if(bizDict.getDictId().longValue() == 109){
					bizDict.setDictName(STAR_CHANGE);
				}
			}
		}
		//是否可编辑
		model.addAttribute("noEditFlag", editFlag);//有关联行程，费用，合同，则为true
		model.addAttribute("routeId", routeId);
		model.addAttribute("prodLineRoute", prodLineRoute);
		model.addAttribute("routeDetailFormat", new RouteDetailFormat());//行程明细模板格式化辅助类
		//币种信息
		model.addAttribute("currencys", SuppGoods.CURRENCYTYPE.values());
		//星级
		model.addAttribute("productType", prodProduct==null ? null : prodProduct.getProductType());
		model.addAttribute("prodProduct", prodProduct);
		model.addAttribute("hotelStarList", hotelStarList);
		model.addAttribute("prodStarList", prodStarList);
		model.addAttribute("prodRouteDetailActivityEmpty", new ProdRouteDetailActivity());
		model.addAttribute("prodRouteDetailMealEmpty", new ProdRouteDetailMeal());
		model.addAttribute("prodRouteDetailHotelEmpty", new ProdRouteDetailHotel());
		model.addAttribute("prodRouteDetailRecommendEmpty", new ProdRouteDetailRecommend());
		model.addAttribute("categoryId", categoryId);
		return "/dujia/comm/route/showRouteDetail";
	}

	/**
	 * 保存行程明细（保存一个行程下所有行程明细）
	 */
	@RequestMapping(value = "/saveRouteDetail")
	@ResponseBody
	public Object saveRouteDetail(ProdLineRoute prodLineRoute) throws BusinessException {
		if(prodLineRoute.getProductId() == null || prodLineRoute.getLineRouteId() == null) {
			return new ResultMessage(ResultMessage.ERROR, "系统参数异常：某些必要参数为空");
		}

		try {
			//过滤并检验detailList数据
			this.filterAndCheckRoute(prodLineRoute);
			List<ProdLineRouteDetail> routeDetailList = prodLineRoute.getProdLineRouteDetailList();
			
			if(CollectionUtils.isNotEmpty(routeDetailList)){
				for(ProdLineRouteDetail prodLineRouteDetailTemp : routeDetailList){
					List<ProdRouteDetailGroup> prodRouteDetailGroups = prodLineRouteDetailTemp.getProdRouteDetailGroupList();
					if(CollectionUtils.isNotEmpty(prodRouteDetailGroups)){
						for(ProdRouteDetailGroup prodRouteDetailGroup : prodRouteDetailGroups){
							this.processTime(prodRouteDetailGroup);
						}
					}
				}
			}
				
			prodLineRouteDetailHelperService.saveOrUpdateDoublePlaceForDetailList(routeDetailList);
			//保存底部温馨提示
			ProdLineRoute pLRoute = MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(prodLineRoute.getLineRouteId()));
			if(null!=pLRoute){
				pLRoute.setWarningText(prodLineRoute.getWarningText());
				prodLineRouteService.updateProdLineRoute(pLRoute);
			}

			//记录日志信息
			if (CollectionUtils.isNotEmpty(routeDetailList)) {
				logLineRouteOperate(prodLineRoute.getLineRouteId(), this.buildSaveRouteDetailLogText(routeDetailList));
			}
			//如果当地游产品被跟团游产品打包，且当地游产品名称修改，消息通知跟团游产品经理
			ProdProduct prodProduct = prodProductService.getProdProductBy(prodLineRoute.getProductId());
			this.sendMessageToGroupProductManager(prodProduct);
			//发送消息
	        pushAdapterService.push(prodLineRoute.getProductId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_PRODUCT,ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
			return new ResultMessage(ResultMessage.SUCCESS, "保存成功");
		} catch (BusinessException e) {
			return new ResultMessage(ResultMessage.ERROR, e.getMessage());
		} catch (Exception e) {
			log.error("Call saveLineRouteDetail occurs exception, caused by:",  e);
			return new ResultMessage(ResultMessage.ERROR, "保存失败");
		}
	}

	/**
	 * 删除行程明细
	 */
	@RequestMapping(value = "/deleteRouteDetail")
	@ResponseBody
	public Object deleteRouteDetail(Long detailId) throws BusinessException {
		if(detailId == null) {
			return new ResultMessage(ResultMessage.ERROR, "系统参数异常：某些必要参数为空");
		}

		try {
			ProdLineRouteDetail prodLineRouteDetail = MiscUtils.autoUnboxing(prodLineRouteDetailService.findByPrimaryKey(detailId));
			if (prodLineRouteDetail == null) {
				return new ResultMessage(ResultMessage.ERROR, "删除失败：没有该明细信息");
			}

			prodLineRouteDetailService.deleteRouteDetailReByDetailId(detailId);
			
			ProdLineRoute pLRoute = MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(prodLineRouteDetail.getRouteId()));
			//如果当地游产品被跟团游产品打包，且当地游产品名称修改，消息通知跟团游产品经理
			ProdProduct prodProduct = prodProductService.getProdProductBy(pLRoute.getProductId());
			this.sendMessageToGroupProductManager(prodProduct);
			
			logLineRouteOperate(prodLineRouteDetail.getRouteId(), this.buildDeleteRouteDetailLogText(prodLineRouteDetail));

			return new ResultMessage(ResultMessage.SUCCESS, "删除成功");
		} catch (BusinessException e) {
			return new ResultMessage(ResultMessage.ERROR, e.getMessage());
		} catch (Exception e) {
			log.error("Call deleteRouteDetail occurs exception, caused by:" , e);
			return new ResultMessage(ResultMessage.ERROR, "删除失败");
		}
	}

	/**
	 * 保存行程明细组
	 */
	@RequestMapping(value = "/saveRouteDetailGroup")
	@ResponseBody
	public Object saveRouteDetailGroup(ProdRouteDetailGroup prodRouteDetailGroup,
			@RequestParam(value = "nDay", required = false) Integer nDay, String productType, String flightTimeValidate,Long categoryId) throws BusinessException {
		try {
			//查询老数据
			ProdRouteDetailGroup oldprodRouteDetailGroup = prodRouteDetailGroupService.loadRouteDetailGroupRe(prodRouteDetailGroup.getGroupId());
			//过滤与校验组信息
			this.filterAndCheckGroup(prodRouteDetailGroup);
			
			this.processTime(prodRouteDetailGroup);

			Long id=prodLineRouteDetailHelperService.saveOrUpdateDoublePlaceForGroup(prodRouteDetailGroup);
			prodRouteDetailGroup.setGroupId(id);

			//日志记录
			try {
				logLineRouteOperate(prodRouteDetailGroup.getRouteId(), this.buildSaveRouteDetailGroupLogText(prodRouteDetailGroup, oldprodRouteDetailGroup, nDay));
			} catch (Exception e) {
				log.error("save or update prodRouteDetailGroup error",e);
			}
			

			String moduleType = prodRouteDetailGroup.getModuleType();
			String templateUrl = "";
			if (ProdRouteDetailGroup.MODULE_TYPE.SCENIC.name().equals(moduleType)) {
				templateUrl = "/dujia/comm/route/scenic.ftl";
			} else if (ProdRouteDetailGroup.MODULE_TYPE.HOTEL.name().equals(moduleType)) {
				templateUrl = "/dujia/comm/route/hotel.ftl";
			} else if (ProdRouteDetailGroup.MODULE_TYPE.MEAL.name().equals(moduleType)) {
				templateUrl = "/dujia/comm/route/meal.ftl";
			} else if (ProdRouteDetailGroup.MODULE_TYPE.VEHICLE.name().equals(moduleType)) {
				templateUrl = "/dujia/comm/route/vehicle.ftl";
			} else if (ProdRouteDetailGroup.MODULE_TYPE.SHOPPING.name().equals(moduleType)) {
				templateUrl = "/dujia/comm/route/shopping.ftl";
			} else if (ProdRouteDetailGroup.MODULE_TYPE.FREE_ACTIVITY.name().equals(moduleType) || 
					ProdRouteDetailGroup.MODULE_TYPE.OTHER_ACTIVITY.name().equals(moduleType)) {
				templateUrl = "/dujia/comm/route/activity.ftl";
			} else if (ProdRouteDetailGroup.MODULE_TYPE.RECOMMEND.name().equals(moduleType)) {
				templateUrl = "/dujia/comm/route/recommend.ftl";
			}

			ProdRouteDetailGroup newRouteDetailGroup = prodRouteDetailGroupService.loadRouteDetailGroupRe(prodRouteDetailGroup.getGroupId());
			//加载话术模板等信息
			this.loadProdRouteDetailGroupVoInfo(newRouteDetailGroup);
			//转义HTML特殊字符
			RouteDetailFormat.escapeGroupHtml(newRouteDetailGroup);

			Map<String, Object> attributes = new HashMap<String, Object>();
			attributes.put("html", renderHtml(templateUrl, newRouteDetailGroup, nDay, productType, flightTimeValidate,categoryId));
			//如果当地游产品被跟团游产品打包，且当地游产品名称修改，消息通知跟团游产品经理
			ProdProduct prodProduct = prodProductService.getProdProductBy(prodRouteDetailGroup.getProductId());
			this.sendMessageToGroupProductManager(prodProduct);
			//发送消息
			if(null!=prodRouteDetailGroup.getProductId()){
				pushAdapterService.push(prodRouteDetailGroup.getProductId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_PRODUCT,ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
			}
			return new ResultMessage(attributes, ResultMessage.SUCCESS, "保存成功");
		} catch (BusinessException e) {
			return new ResultMessage(ResultMessage.ERROR, e.getMessage());
		} catch (Exception e) {
			log.error("Call saveRouteDetailGroup occurs exception, caused by:", e);
			return new ResultMessage(ResultMessage.ERROR, "保存失败");
		}
	}

	private String renderHtml(String templateUrl, ProdRouteDetailGroup prodRouteDetailGroup, Integer nDay, String productType, String flightTimeValidate,Long categoryId) throws Exception {
		Map<String, Object> rootMap = new HashMap<String, Object>();
		rootMap.put("productType", productType);
		rootMap.put("flightTimeValidate", flightTimeValidate);
		rootMap.put("timeTypes", ProdRouteDetailGroup.TIME_TYPE.values());
		rootMap.put("routeDetailFormat", new RouteDetailFormat()); // 行程明细模板格式化辅助类
		rootMap.put("currencys", SuppGoods.CURRENCYTYPE.values());
		rootMap.put("routeDetailGroup", prodRouteDetailGroup);
		rootMap.put("categoryId", categoryId);
		//酒店产品(星级)
		List<BizDict> hotelStarList = bizDictQueryService.findDictListByDefId(2L);
		//产品 星级
		List<BizDict> prodStarList = bizDictQueryService.findDictListByDefId(515L);
		//TASK #38179 
		for (BizDict bizDict : hotelStarList) {
			if(bizDict.getDictId() != null){
				if(bizDict.getDictId().longValue() == 109){
					bizDict.setDictName(STAR_CHANGE);
				}
			}
		}
		rootMap.put("hotelStarList", hotelStarList);
		rootMap.put("prodStarList", prodStarList);
		//强制为新的结构，默认为view状态
		rootMap.put("newStructureFlag", "Y");

		String moduleType = prodRouteDetailGroup.getModuleType();
		if (ProdRouteDetailGroup.MODULE_TYPE.FREE_ACTIVITY.name().equals(moduleType)
				|| ProdRouteDetailGroup.MODULE_TYPE.OTHER_ACTIVITY.name().equals(moduleType)) {
			rootMap.put("prodRouteDetailActivityEmpty", new ProdRouteDetailActivity());
		} else if(ProdRouteDetailGroup.MODULE_TYPE.HOTEL.name().equals(moduleType)) {
			List<ProdRouteDetailHotel> prodRouteDetailHotelList = prodRouteDetailGroup.getProdRouteDetailHotelList();
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("cancelFlag", "Y");
			for(ProdRouteDetailHotel prdh : prodRouteDetailHotelList) {
				if("109".equals(prdh.getStarLevel())){
					prdh.setStarLevelName(STAR_CHANGE);
				}
				if(prdh.getProductId() != null) {
					params.put("productId", prdh.getProductId());
					//酒店产品的房型
					prdh.setRoomTypeList(prodProductBranchService.findProdProductBranchList(params));
				}
			}
		} else if (ProdRouteDetailGroup.MODULE_TYPE.VEHICLE.name().equals(moduleType)) {
			Integer lineRouteNum = (Integer)MiscUtils.autoUnboxing(this.prodLineRouteDetailService.selectMaxRouteNum(prodRouteDetailGroup.getRouteId()));
			if (lineRouteNum != null ) {
				//最大多少天
				rootMap.put("real_route_Num", lineRouteNum.shortValue());
				//当前是哪一天
				rootMap.put("day_index", nDay);
			}
		}

		// 渲染页面将页面转化为字符串传入前台
		Template template = freeMarkerConfig.getConfiguration().getTemplate(templateUrl);
		StringWriter out = new StringWriter();
		template.process(rootMap, out);
		return out.toString();
	}

	@RequestMapping(value = "/getRouteDetailGroup")
	public String getRouteDetailGroup(Model model, Long groupId) {
		ProdRouteDetailGroup prodRouteDetailGroup = prodRouteDetailGroupService.loadRouteDetailGroupRe(groupId);
		this.loadProdRouteDetailGroupVoInfo(prodRouteDetailGroup);
		model.addAttribute("routeDetailGroup", prodRouteDetailGroup);
		model.addAttribute("timeTypes", ProdRouteDetailGroup.TIME_TYPE.values());
		model.addAttribute("prodRouteDetailActivityEmpty", new ProdRouteDetailActivity());
		//币种信息
		model.addAttribute("currencys", SuppGoods.CURRENCYTYPE.values());
		model.addAttribute("routeDetailFormat", new RouteDetailFormat());
		return "/dujia/comm/route/scenic";
	}

	/**
	 * 删除行程明细组
	 */
	@RequestMapping(value = "/deleteRouteDetailGroup")
	@ResponseBody
	public Object deleteRouteDetailGroup(Long groupId, Long productId, Integer nDay) throws BusinessException {
		if(groupId == null) {
			return new ResultMessage(ResultMessage.ERROR, "系统参数异常：必要参数groupId为null");
		}

		try {
			ProdRouteDetailGroup prodRouteDetailGroup = prodRouteDetailGroupService.loadRouteDetailGroupRe(groupId);
			if (prodRouteDetailGroup == null) {
				return new ResultMessage(ResultMessage.ERROR, "删除失败：没有该模块信息");
			}
			//删除明细组并更新老数据
			prodLineRouteDetailHelperService.deleteByGroupIdAndUpdate(groupId, prodRouteDetailGroup.getDetailId(), productId);

			//如果当地游产品被跟团游产品打包，且当地游产品名称修改，消息通知跟团游产品经理
			ProdProduct prodProduct = prodProductService.getProdProductBy(productId);
			this.sendMessageToGroupProductManager(prodProduct);
			//日志记录
			try {
				logLineRouteOperate(prodRouteDetailGroup.getRouteId(), this.buildDeleteRouteDetailGroupLogText(prodRouteDetailGroup, nDay));
			} catch (Exception e) {
				log.error("delete LineRouteDetail error", e);
			}
			return new ResultMessage(ResultMessage.SUCCESS, "删除成功");
		} catch (BusinessException e) {
			return new ResultMessage(ResultMessage.ERROR, e.getMessage());
		} catch (Exception e) {
			log.error("Call saveLineRouteDetail occurs exception, caused by:", e);
			return new ResultMessage(ResultMessage.ERROR, "删除失败");
		}
	}

	/**
	 * 预览话术模板
	 */
	@RequestMapping(value = "/previewModuleTemplate")
	@ResponseBody
	public Object previewModuleTemplate(ProdRouteDetailGroup prodRouteDetailGroup, int index) throws BusinessException {
		try {
			String templateText = "";
			if (prodRouteDetailGroup != null) {
				String moduleType = prodRouteDetailGroup.getModuleType();

				if (ProdRouteDetailGroup.MODULE_TYPE.SCENIC.name().equals(moduleType)) {
					List<ProdRouteDetailScenic> scenicList = prodRouteDetailGroup.getProdRouteDetailScenicList();
					ProdRouteDetailScenic scenic = scenicList.get(index);
					templateText = prodRouteDetailScenicService.buildTemplateText(scenic);
				}
				else if (ProdRouteDetailGroup.MODULE_TYPE.SHOPPING.name().equals(moduleType)) {
					List<ProdRouteDetailShopping> shoppingList = prodRouteDetailGroup.getProdRouteDetailShoppingList();
					ProdRouteDetailShopping shopping = shoppingList.get(index);
					templateText = prodRouteDetailShoppingService.buildTemplateText(shopping);
				}
				if (ProdRouteDetailGroup.MODULE_TYPE.MEAL.name().equals(moduleType)) {
					List<ProdRouteDetailMeal> mealList = prodRouteDetailGroup.getProdRouteDetailMealList();
					ProdRouteDetailMeal meal = mealList.get(0);
					//templateText = prodRouteDetailMealService.buildTemplateText(meal);
					templateText = prodRouteDetailMealService.buildNewTemplateText(meal,prodRouteDetailGroup.getStartTime());
				}
				if (ProdRouteDetailGroup.MODULE_TYPE.HOTEL.name().equals(moduleType)) {
					List<ProdRouteDetailHotel> hotelList = prodRouteDetailGroup.getProdRouteDetailHotelList();
					templateText = prodRouteDetailHotelService.buildTemplateText(hotelList, true);
				}
			}

			Map<String, Object> attributes = new HashMap<String, Object>();
			attributes.put("templateText", StringEscapeUtils.escapeHtml(templateText));
			return new ResultMessage(attributes, ResultMessage.SUCCESS, "获取成功");
		} catch (BusinessException e) {
			return new ResultMessage(ResultMessage.ERROR, e.getMessage());
		} catch (Exception e) {
			log.error("Call saveLineRouteDetail occurs exception, caused by:" + e);
			return new ResultMessage(ResultMessage.ERROR, "获取失败");
		}
	}

	@RequestMapping("saveDayHeader")
	@ResponseBody
	public ResultMessage saveDayHeader(@RequestParam(value = "detailId", required = false) Long detailId, Long routeId,
			Short nDay, String title) {
		try {
			//获取老的线路明细
			ProdLineRouteDetail oldProdLineRouteDetail = MiscUtils.autoUnboxing(prodLineRouteDetailService.findByPrimaryKey(detailId));
			ProdLineRouteDetail detail = new ProdLineRouteDetail();
			detail.setDetailId(detailId);
			detail.setRouteId(routeId);
			detail.setnDay(nDay);
			detail.setTitle(title);
			Long newDetailId = prodLineRouteDetailHelperService.saveOrUpdateRouteDetail(detail);

			ProdLineRoute pLRoute = MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(routeId));
			//如果当地游产品被跟团游产品打包，且当地游产品名称修改，消息通知跟团游产品经理
			ProdProduct prodProduct = prodProductService.getProdProductBy(pLRoute.getProductId());
			this.sendMessageToGroupProductManager(prodProduct);
			//日志记录
			logLineRouteOperate(routeId, this.buildSaveDayHeaderLogText(detail, oldProdLineRouteDetail));

			Map<String, Object> attributes = new HashMap<String, Object>();
			attributes.put("detailId", newDetailId);
			return new ResultMessage(attributes, ResultMessage.SUCCESS, "保存成功");
		} catch (Exception e) {
			return new ResultMessage(ResultMessage.ERROR, "内部异常");
		}
	}

	/**
	 * 保存行程的提示信息
	 */
	@RequestMapping(value = "/saveWarningFlag")
	@ResponseBody
	public Object saveWarningFlag(Long routeId, String warningFlag) throws BusinessException {
		if (routeId == null) {
			return new ResultMessage(ResultMessage.ERROR, "系统参数异常：routeId为null");
		}

		try {
			ProdLineRoute prodLineRoute = new ProdLineRoute();
			prodLineRoute.setLineRouteId(routeId);
			prodLineRoute.setWarningFlag("Y".equals(warningFlag) ? "Y" : "N");
			//设置不更新的数据(初始化为0的属性)
			prodLineRoute.setStayNum(null);
			prodLineRoute.setRouteNum(null);
			prodLineRoute.setTrafficNum(null);
			prodLineRouteService.updateProdLineRoute(prodLineRoute);

			ProdLineRoute pLRoute = MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(routeId));
			//如果当地游产品被跟团游产品打包，且当地游产品名称修改，消息通知跟团游产品经理
			ProdProduct prodProduct = prodProductService.getProdProductBy(pLRoute.getProductId());
			this.sendMessageToGroupProductManager(prodProduct);
			
			//日志记录
			logLineRouteOperate(routeId, this.buildSaveWarningFlagLogText(warningFlag));

			return new ResultMessage(ResultMessage.SUCCESS, "设置成功");
		} catch (BusinessException e) {
			return new ResultMessage(ResultMessage.ERROR, e.getMessage());
		} catch (Exception e) {
			log.error("Call saveWarningFlag occurs exception, caused by:", e);
			return new ResultMessage(ResultMessage.ERROR, "设置失败");
		}
	}

	/**
	 * 得到购物模块下拉列表
	 * @param destName
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/getDestList")
	@ResponseBody
	public Object getDestList(String destName) throws BusinessException {
		try {
			Map<String, Object> attributes = new HashMap<String, Object>();
			Map<String, Object> param = new HashMap<String, Object>();
			List<BizDest> bizDestList = new ArrayList<BizDest>();
			param.put("bds", true);
			param.put("_start", 0);
			param.put("_end", 20);
			param.put("destType", BizDest.DEST_TYPE.SHOP);
			param.put("destName", destName);
			bizDestList = MiscUtils.autoUnboxing(destService.findDestList(param));
			attributes.put("bizDestList", bizDestList);
			return new ResultMessage(attributes, ResultMessage.SUCCESS, "获取成功");
		}catch (Exception e) {
			return new ResultMessage(ResultMessage.ERROR, e.getMessage());
		} 
	}
	
	/**
	 * 得到购物模块购物点详情
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/getDest")
	@ResponseBody
	public Object getDest(Long destId) throws BusinessException {
		try {
			Map<String, Object> attributes = new HashMap<String, Object>();
			Map<String, Object> param = new HashMap<String, Object>();
			Map<String, Object> result = new HashMap<String, Object>();
			
			if(destId == null){
				return new ResultMessage(attributes, ResultMessage.SUCCESS, "获取成功,但没查询到数据");
			}
			param.put("bds", true);
			param.put("destId", destId);
			List<BizDest> bizDestList = MiscUtils.autoUnboxing(destService.findDestList(param));
			result = ProdRouteDetailUtils.getPoiinfoByDestid(destId);
			if(bizDestList != null && bizDestList.size()>0){
				BizDest bizDest = bizDestList.get(0);
				if(bizDest != null){
					attributes.put("bizDestShop", bizDest.getBizDestShop());
				}
			}
			if(result != null && result.size() >0 && result.containsKey("addr")){
				List<String> addrList = (List<String>) result.get("addr");
				if(addrList != null && addrList.size() >0 ){
					attributes.put("poi", addrList.get(0));
				}
			}
			return new ResultMessage(attributes, ResultMessage.SUCCESS, "获取成功");
		}catch (Exception e) {
			return new ResultMessage(ResultMessage.ERROR, e.getMessage());
		} 
	}
	
	/**
	 * 删除单个模块
	 */
	@RequestMapping(value = "/deleteModule")
	@ResponseBody
	public Object deleteModule(Long groupId, Long moduleId, Short nDay) throws BusinessException {
		if(groupId == null || moduleId == null) {
			return new ResultMessage(ResultMessage.ERROR, "系统参数异常：必要参数为空");
		}

		try {
			ProdRouteDetailGroup prodRouteDetailGroup = prodRouteDetailGroupService.findGroupByGroupId(groupId);
			if (prodRouteDetailGroup == null) {
				return new ResultMessage(ResultMessage.ERROR, "删除失败：没有该模块信息");
			}

			String moduleType = prodRouteDetailGroup.getModuleType();
			prodLineRouteDetailHelperService.deleteByModuleIdAndUpdate(moduleId, moduleType, prodRouteDetailGroup.getDetailId());

			ProdLineRoute pLRoute = MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(prodRouteDetailGroup.getRouteId()));
			//如果当地游产品被跟团游产品打包，且当地游产品名称修改，消息通知跟团游产品经理
			ProdProduct prodProduct = prodProductService.getProdProductBy(pLRoute.getProductId());
			this.sendMessageToGroupProductManager(prodProduct);
			
			//日志记录
			logLineRouteOperate(prodRouteDetailGroup.getRouteId(), this.buildDeleteModuleLogText(prodRouteDetailGroup, nDay));

			return new ResultMessage(ResultMessage.SUCCESS, "删除成功");
		} catch (BusinessException e) {
			return new ResultMessage(ResultMessage.ERROR, e.getMessage());
		} catch (Exception e) {
			log.error("Call saveLineRouteDetail occurs exception, caused by:" + e);
			return new ResultMessage(ResultMessage.ERROR, "删除失败");
		}
	}

	/**
	 * 加载行程下话术模板等信息
	 */
	private void loadProdLineRouteVoInfo(ProdLineRoute prodLineRoute) {
		if (prodLineRoute == null) {
			return;
		}

		List<ProdLineRouteDetail> lineRouteDetailList = prodLineRoute.getProdLineRouteDetailList();
		if (CollectionUtils.isEmpty(lineRouteDetailList)) {
			return;
		}

		for (ProdLineRouteDetail prodLineRouteDetail : lineRouteDetailList) {
			List<ProdRouteDetailGroup> groupList = prodLineRouteDetail.getProdRouteDetailGroupList();
			if (CollectionUtils.isEmpty(groupList)) {
				continue;
			}

			for (ProdRouteDetailGroup group : groupList) {
				this.loadProdRouteDetailGroupVoInfo(group);
			}
		}
	}

	/**
	 * 过滤并检验组信息行程明细列表信息
	 * @param routeDetailList 行程明细列表
	 */
	private void filterAndCheckRoute(ProdLineRoute prodLineRoute) {
		if (prodLineRoute == null || prodLineRoute.getLineRouteId() == null) {
			throw new BusinessException("系统参数异常：某些必要参数为空");
		}

		List<ProdLineRouteDetail> routeDetailList = prodLineRoute.getProdLineRouteDetailList();
		if (CollectionUtils.isNotEmpty(routeDetailList)) {
			//过滤无用的明细信息
			for (int i = routeDetailList.size() - 1; i >= 0; i--) {
				ProdLineRouteDetail detail = routeDetailList.get(i);
				if(detail.getnDay() != null && detail.getnDay() != 0){
					detail.setRouteId(prodLineRoute.getLineRouteId());
				} else {
					routeDetailList.remove(i);
				}
			}

			//过滤组上信息
			for (ProdLineRouteDetail detail : routeDetailList) {
				List<ProdRouteDetailGroup> groupList = detail.getProdRouteDetailGroupList();
				if (CollectionUtils.isNotEmpty(groupList)) {
					for (ProdRouteDetailGroup group : groupList) {
						this.filterAndCheckGroup(group);
					}
				}
			}
		}

		prodLineRoute.setProdLineRouteDetailList(routeDetailList);
	}

	/**
	 * 过滤并检验组信息
	 * @param prodRouteDetailGroup 组对象
	 * @throws BusinessException 业务异常（挂载着必要参数的校验返回信息）
	 */
	private void filterAndCheckGroup(ProdRouteDetailGroup prodRouteDetailGroup) throws BusinessException {
		if(prodRouteDetailGroup.getRouteId() == null || prodRouteDetailGroup.getDetailId() == null 
				|| StringUtil.isEmptyString(prodRouteDetailGroup.getModuleType())) {
			throw new BusinessException("系统参数异常：某些必要参数为空");
		}

		String moduleType = prodRouteDetailGroup.getModuleType();
		if (ProdRouteDetailGroup.MODULE_TYPE.SCENIC.name().equals(moduleType)) {
			List<ProdRouteDetailScenic> scenicList = prodRouteDetailGroup.getProdRouteDetailScenicList();
			if (CollectionUtils.isNotEmpty(scenicList)) {
				for (int i = scenicList.size() - 1; i >= 0; i--) {
					ProdRouteDetailScenic scenic = scenicList.get(i);
					//移除名称为空的无用景点数据
					if (StringUtil.isEmptyString(scenic.getScenicName())) {
						scenicList.remove(i);
					}
				}
			}
		} else if (ProdRouteDetailGroup.MODULE_TYPE.MEAL.name().equals(moduleType)) {
			List<ProdRouteDetailMeal> mealList = prodRouteDetailGroup.getProdRouteDetailMealList();
			if (mealList == null || mealList.isEmpty() || StringUtil.isEmptyString(mealList.get(0).getMealType())) {
				log.error("用餐类型不能为空！");
				throw new BusinessException("用餐类型不能为空！");
			}
		} else if (ProdRouteDetailGroup.MODULE_TYPE.HOTEL.name().equals(moduleType)) {
			List<ProdRouteDetailHotel> hotelList = prodRouteDetailGroup.getProdRouteDetailHotelList();
			if (CollectionUtils.isNotEmpty(hotelList)) {
				for (int i = hotelList.size() - 1; i >= 0; i--) {
					ProdRouteDetailHotel hotel = hotelList.get(i);
					//移除名称为空的无用酒店数据
					if (StringUtil.isEmptyString(hotel.getHotelName())) {
						hotelList.remove(i);
					}
				}
			}
		} else if (ProdRouteDetailGroup.MODULE_TYPE.SHOPPING.name().equals(moduleType)) {
			List<ProdRouteDetailShopping> shoppingList = prodRouteDetailGroup.getProdRouteDetailShoppingList();
			if (CollectionUtils.isNotEmpty(shoppingList)) {
				for (int i = shoppingList.size() - 1; i >= 0; i--) {
					ProdRouteDetailShopping shopping = shoppingList.get(i);
					//移除名称为空的无用购物点数据
					if (StringUtil.isEmptyString(shopping.getShoppingName())) {
						shoppingList.remove(i);
					}
				}
			}
		}

	}
	
	/**
	 * 处理时间空格问题
	 * 
	 * @param prodRouteDetailGroup
	 * @throws BusinessException
	 */
	private void processTime(ProdRouteDetailGroup prodRouteDetailGroup) throws BusinessException {
		if(prodRouteDetailGroup == null){
			return;
		}
		
		// 处理本模块的开始时间，几点几分，另有全天，上午，下午等特殊值
		if(StringUtils.isNotEmpty(prodRouteDetailGroup.getStartTime())){
			String startTime = this.timeStrTrim(prodRouteDetailGroup.getStartTime());
			if(StringUtils.isNotEmpty(startTime)){
				prodRouteDetailGroup.setStartTime(startTime);
			}
		}
		
		// 处理景点列表
		if(CollectionUtils.isNotEmpty(prodRouteDetailGroup.getProdRouteDetailScenicList())){
			List<ProdRouteDetailScenic> prodRouteDetailScenicList = prodRouteDetailGroup.getProdRouteDetailScenicList();
			for(ProdRouteDetailScenic prodRouteDetailScenic : prodRouteDetailScenicList){
				if(StringUtils.isNotEmpty(prodRouteDetailScenic.getTravelTime())){
					String travelTime = this.timeStrTrim(prodRouteDetailScenic.getTravelTime());
					if(StringUtils.isNotEmpty(travelTime)){
						prodRouteDetailScenic.setTravelTime(travelTime);
					}
				}
				if(StringUtils.isNotEmpty(prodRouteDetailScenic.getVisitTime())){
					String visitTime = this.timeStrTrim(prodRouteDetailScenic.getVisitTime());
					if(StringUtils.isNotEmpty(visitTime)){
						prodRouteDetailScenic.setVisitTime(visitTime);
					}
				}
			}
		}
		
		// 处理酒店列表
		if(CollectionUtils.isNotEmpty(prodRouteDetailGroup.getProdRouteDetailHotelList())){
			List<ProdRouteDetailHotel> prodRouteDetailHotelList = prodRouteDetailGroup.getProdRouteDetailHotelList();
			for(ProdRouteDetailHotel prodRouteDetailHotel : prodRouteDetailHotelList){
				if(StringUtils.isNotEmpty(prodRouteDetailHotel.getTravelTime())){
					String travelTime = this.timeStrTrim(prodRouteDetailHotel.getTravelTime());
					if(StringUtils.isNotEmpty(travelTime)){
						prodRouteDetailHotel.setTravelTime(travelTime);
					}
				}
			}
		}
		
		// 处理购物点列表
		if(CollectionUtils.isNotEmpty(prodRouteDetailGroup.getProdRouteDetailShoppingList())){
			List<ProdRouteDetailShopping> prodRouteDetailShoppingList = prodRouteDetailGroup.getProdRouteDetailShoppingList();
			for(ProdRouteDetailShopping prodRouteDetailShopping : prodRouteDetailShoppingList){
				if(StringUtils.isNotEmpty(prodRouteDetailShopping.getTravelTime())){
					String travelTime = this.timeStrTrim(prodRouteDetailShopping.getTravelTime());
					if(StringUtils.isNotEmpty(travelTime)){
						prodRouteDetailShopping.setTravelTime(travelTime);
					}
				}
				if(StringUtils.isNotEmpty(prodRouteDetailShopping.getVisitTime())){
					String visitTime = this.timeStrTrim(prodRouteDetailShopping.getVisitTime());
					if(StringUtils.isNotEmpty(visitTime)){
						prodRouteDetailShopping.setVisitTime(visitTime);
					}
				}
			}
		}
		
		// 处理用餐模块
		if(CollectionUtils.isNotEmpty(prodRouteDetailGroup.getProdRouteDetailMealList())){
			List<ProdRouteDetailMeal> prodRouteDetailMealList = prodRouteDetailGroup.getProdRouteDetailMealList();
			for(ProdRouteDetailMeal prodRouteDetailMeal : prodRouteDetailMealList){
				if(StringUtils.isNotEmpty(prodRouteDetailMeal.getMealTime())){
					String mealTime = this.timeStrTrim(prodRouteDetailMeal.getMealTime());
					if(StringUtils.isNotEmpty(mealTime)){
						// 处理用餐时间，xxx小时xx分钟格式
						prodRouteDetailMeal.setMealTime(mealTime);
					}
				}
				if(StringUtils.isNotEmpty(prodRouteDetailMeal.getBreakfastMealTime())){
					String breakfastMealTime = this.timeStrTrim(prodRouteDetailMeal.getBreakfastMealTime());
					if(StringUtils.isNotEmpty(breakfastMealTime)){
						// 处理早餐用餐时间
						prodRouteDetailMeal.setBreakfastMealTime(breakfastMealTime);
					}
				}
				if(StringUtils.isNotEmpty(prodRouteDetailMeal.getLunchMealTime())){
					String lunchMealTime = this.timeStrTrim(prodRouteDetailMeal.getLunchMealTime());
					if(StringUtils.isNotEmpty(lunchMealTime)){
						// 处理午餐用餐时间
						prodRouteDetailMeal.setLunchMealTime(lunchMealTime);
					}
				}
				if(StringUtils.isNotEmpty(prodRouteDetailMeal.getDinnerMealTime())){
					String dinnerMealTime = this.timeStrTrim(prodRouteDetailMeal.getDinnerMealTime());
					if(StringUtils.isNotEmpty(dinnerMealTime)){
						// 处理晚餐用脑残时间
						prodRouteDetailMeal.setDinnerMealTime(dinnerMealTime);
					}
				}
				
			}
		}
		
		// 处理活动列表
		if(CollectionUtils.isNotEmpty(prodRouteDetailGroup.getProdRouteDetailActivityList())){
			List<ProdRouteDetailActivity> prodRouteDetailActivityList = prodRouteDetailGroup.getProdRouteDetailActivityList();
			for(ProdRouteDetailActivity prodRouteDetailActivity : prodRouteDetailActivityList){
				if(StringUtils.isNotEmpty(prodRouteDetailActivity.getTravelTime())){
					String travelTime = this.timeStrTrim(prodRouteDetailActivity.getTravelTime());
					if(StringUtils.isNotEmpty(travelTime)){
						prodRouteDetailActivity.setTravelTime(travelTime);
					}
				}
				if(StringUtils.isNotEmpty(prodRouteDetailActivity.getVisitTime())){
					String visitTime = this.timeStrTrim(prodRouteDetailActivity.getVisitTime());
					if(StringUtils.isNotEmpty(visitTime)){
						prodRouteDetailActivity.setVisitTime(visitTime);
					}
				}
			}
		}
	}
	
	/**
	 * 把时间格式的字符串去空格，如10: 5变成10:5
	 * 
	 * @param time
	 * @return
	 */
	private String timeStrTrim(String time){
		String returnTime = "";
		if(StringUtils.isNotEmpty(time)){
			String[] timeArr = time.split(":");
			if(ArrayUtils.isNotEmpty(timeArr)){
				if(timeArr.length == 1){
					if(StringUtils.isNotEmpty(timeArr[0]) && StringUtils.isNotEmpty(timeArr[0].trim())){
						if(time.indexOf(":") > 0){
							returnTime += timeArr[0].trim() + ":"; 
						}else{
							returnTime += timeArr[0].trim();
						}
					}
				}else if(timeArr.length == 2){
					if(StringUtils.isNotEmpty(timeArr[0].trim()) || StringUtils.isNotEmpty(timeArr[1].trim())){
						if(StringUtils.isEmpty(timeArr[0].trim())){
							returnTime += ":"; 
						}else{
							returnTime += timeArr[0].trim() + ":"; 
						}
						returnTime += timeArr[1].trim();
					}
				}
			}
		}
		return returnTime;
	}
	
	/**
	 *加载明细组下话术模板等信息
	 */
	private void loadProdRouteDetailGroupVoInfo(ProdRouteDetailGroup prodRouteDetailGroup) {
		if (prodRouteDetailGroup == null) {
			return;
		}

		String moduleType = prodRouteDetailGroup.getModuleType();
		//加载景点的话术模板
		if (ProdRouteDetailGroup.MODULE_TYPE.SCENIC.name().equals(moduleType)) {
			List<ProdRouteDetailScenic> scenicList = prodRouteDetailGroup.getProdRouteDetailScenicList();
			if (CollectionUtils.isNotEmpty(scenicList)) {
				for (ProdRouteDetailScenic scenic : scenicList) {
					if ("Y".equals(scenic.getUseTemplateFlag())) {
						scenic.setTemplateText(prodRouteDetailScenicService.buildTemplateText(scenic));
					}
				}
			}
		} else if(ProdRouteDetailGroup.MODULE_TYPE.HOTEL.name().equals(moduleType)) {
			List<ProdRouteDetailHotel> hotelList = prodRouteDetailGroup.getProdRouteDetailHotelList();
			if (CollectionUtils.isNotEmpty(hotelList)) {
				for (ProdRouteDetailHotel hotel : hotelList) {
					if("109".equals(hotel.getStarLevel())){
						hotel.setStarLevelName(STAR_CHANGE);
					}
					if ("Y".equals(hotel.getUseTemplateFlag())) {
						prodRouteDetailGroup.setHotelTemplateText(prodRouteDetailHotelService.buildTemplateText(hotelList, false));
						break;
					}
				}
			}
		} else if (ProdRouteDetailGroup.MODULE_TYPE.SHOPPING.name().equals(moduleType)) {
			List<ProdRouteDetailShopping> shoppings = prodRouteDetailGroup.getProdRouteDetailShoppingList();
			if (CollectionUtils.isNotEmpty(shoppings)) {
				for (ProdRouteDetailShopping shopping : shoppings) {
					if ("Y".equals(shopping.getUseTemplateFlag())) {
						shopping.setTemplateText(prodRouteDetailShoppingService.buildTemplateText(shopping));
					}
				}
			}
		} else if (ProdRouteDetailGroup.MODULE_TYPE.MEAL.name().equals(moduleType)) {
			List<ProdRouteDetailMeal> mealList = prodRouteDetailGroup.getProdRouteDetailMealList();
			if (CollectionUtils.isNotEmpty(mealList)) {
				for (ProdRouteDetailMeal meal : mealList) {
					if ("Y".equals(meal.getUseTemplateFlag())) {
						meal.setTemplateText(prodRouteDetailMealService.buildNewTemplateText(meal,prodRouteDetailGroup.getStartTime()));
					}
				}
			}
		}
	}
	
	//查询酒店
	@RequestMapping("/searchHotelList")
	@ResponseBody
	public ResultMessage searchHotelList(Integer page, String hotelName) {
		try {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("productName", hotelName); //产品名称
			params.put("bizCategoryId", BIZ_CATEGORY_TYPE.category_hotel.getCategoryId());

			params.put("_start", 1);
			params.put("_end", 10);
			params.put("_orderby", "PRODUCT_ID");
			params.put("_order", "DESC");
			params.put("isneedmanager", "false");
			List<ProdProduct> searchHotelList = prodProductService.findProdProductListSales(params);
			if(searchHotelList != null) {
				resultMap.put("data", searchHotelList);
			}
			return new ResultMessage(resultMap, ResultMessage.SUCCESS, null);
		} catch (Exception e) {
			return new ResultMessage(ResultMessage.ERROR, "内部异常");
		}
	}
	
	//查询酒店
	@RequestMapping("/loadProductById")
	@ResponseBody
	public ResultMessage loadProductById(Long productId) {
		try {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			ProdProduct pp = null;
			if(productId != null) {
				ProdProductParam param = new ProdProductParam();
				param.setProductBranch(true);
				param.setProductProp(true);
				param.setProductPropValue(true);
				pp = prodProductService.findProdProductById(productId, param);
			}
			if(pp != null ) {
				resultMap.put("pp", pp);
				resultMap.put("startName", pp.getProp("star_rate"));
				List<ProdProductBranch> ppbList = pp.getProdProductBranchList();
				ProdProductBranch ppb = null;
				for(Iterator<ProdProductBranch> it = ppbList.iterator();it.hasNext();) {
					ppb = it.next();
					if("N".equalsIgnoreCase(ppb.getCancelFlag())) {
						it.remove();
					}
				}
				//产品的房型
				resultMap.put("roomTypeList", ppbList);
			}
			return new ResultMessage(resultMap, ResultMessage.SUCCESS, null);
		} catch (Exception e) {
			return new ResultMessage(ResultMessage.ERROR, "内部异常");
		}
	}
	
	//查询星级
	@RequestMapping("/findStarList")
	@ResponseBody
	public ResultMessage findStarList() {
		try {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			List<BizDict> prodStarList = bizDictQueryService.findDictListByDefId(515L);
			resultMap.put("data", prodStarList);
			return new ResultMessage(resultMap, ResultMessage.SUCCESS, null);
		} catch (Exception e) {
			return new ResultMessage(ResultMessage.ERROR, "内部异常");
		}
	}
	
		/**
		 * 保存模块或天数移动数据
		 * 模块更新nday值,组更新sortValue值
		 * @param dayMoveFlag 是否天移动
		 * @param moudleMoveFlag 是否组移动
		 * @return
		 */
		@RequestMapping("/saveDayOrMoudlelMove")
		@ResponseBody
		public ResultMessage saveDayOrMoudlelMove(ProdLineRoute prodLineRoute,boolean dayMoveFlag,boolean moudleMoveFlag){
			try {
				if(prodLineRoute!=null &&prodLineRoute.getLineRouteId()!=null &&(dayMoveFlag||moudleMoveFlag) ){
					ProdLineRoute pRoute = MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(prodLineRoute.getLineRouteId()));
					if(pRoute!=null){
						String callBackStr = MiscUtils.autoUnboxing(prodLineRouteDetailService.updateDayOrMoudelSort(prodLineRoute, dayMoveFlag, moudleMoveFlag));
						
						//如果当地游产品被跟团游产品打包，且当地游产品名称修改，消息通知跟团游产品经理
						ProdProduct prodProduct = prodProductService.getProdProductBy(prodLineRoute.getProductId());
						this.sendMessageToGroupProductManager(prodProduct);
						
						if(StringUtils.isNotBlank(callBackStr)){
							PermUser operateUser = this.getLoginUser();
							StringBuilder logStr = new StringBuilder();
							String type = "";
							if(dayMoveFlag){
								type = "天数顺序";
							}else if(moudleMoveFlag){
								type = "模块顺序";
							}
							if(StringUtils.isNotBlank(type)){
								try {
									
									logStr.append("更新了"+"【").append(pRoute.getRouteName()).append("】"+type+"（关联行程ID：").append(pRoute.getLineRouteId())
									.append(callBackStr)
									.append("）");
									comLogService.insert(PROD_LINE_ROUTE, prodLineRoute.getProductId(), pRoute.getLineRouteId(), operateUser.getUserName(), 
											logStr.toString(), PROD_TRAVEL_DESIGN.name(), "编辑行程明细", null);
									
								} catch (Exception e) {
									log.error(ExceptionFormatUtil.getTrace(e));
								}
								
								
							}
							return new ResultMessage(ResultMessage.SUCCESS, "移动成功");
						}
						
					}
					
					
				}
					
			} catch (Exception e) {
				log.error(ExceptionFormatUtil.getTrace(e));
				return new ResultMessage(ResultMessage.ERROR, "内部异常");
			}
			 return new ResultMessage(ResultMessage.ERROR, "移动失败");
		}
	

	/**
	 * 记录行程操作日志
	 */
	private void logLineRouteOperate(Long routeId, String logText) {
		try{
			if (routeId != null) {
				ProdLineRoute pRoute = MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(routeId));
				if (pRoute != null) {
					PermUser operateUser = this.getLoginUser();
					String operateUserName = operateUser == null ? "" : operateUser.getUserName();
					StringBuilder logStr = new StringBuilder();
					logStr.append("【").append(pRoute.getRouteName()).append("】更新行程明细（关联行程ID：").append(pRoute.getLineRouteId())
					.append("）：").append(logText);
					comLogService.insert(PROD_LINE_ROUTE, pRoute.getProductId(), pRoute.getLineRouteId(), operateUserName, 
							logStr.toString(), PROD_TRAVEL_DESIGN.name(), "编辑行程", null);
				}
			}
		}catch(Exception e) {
			log.error("Record Log failure ！Log Type:" + PROD_TRAVEL_DESIGN.name());
			log.error(e.getMessage(), e);
		}
	}

	private String buildSaveRouteDetailLogText(List<ProdLineRouteDetail> routeDetailList) {
		StringBuilder logText = new StringBuilder();
		//记录操作日志
		if (CollectionUtils.isNotEmpty(routeDetailList)) {
			for(ProdLineRouteDetail prodLineRouteDetail : routeDetailList){
				logText.append("线路产品明细ID:").append(prodLineRouteDetail.getDetailId()).append("，");
				logText.append("线路天数：").append(prodLineRouteDetail.getnDay()).append("，修改了行程；");
			}
		}
		return logText.toString();
	}

	private String buildDeleteRouteDetailLogText(ProdLineRouteDetail prodLineRouteDetail) {
		StringBuilder logText = new StringBuilder();
		if (prodLineRouteDetail != null) {
			logText.append("线路产品明细ID：").append(prodLineRouteDetail.getDetailId()).append("，");
			logText.append("线路天数：").append(prodLineRouteDetail.getnDay()).append("，");
			logText.append("删除明细");
		}
		return logText.toString();
	}

	private String buildSaveRouteDetailGroupLogText(ProdRouteDetailGroup prodRouteDetailGroup, ProdRouteDetailGroup oldProdRouteDetailGroup, Integer nDay) {
		StringBuilder logText = new StringBuilder();
		if (prodRouteDetailGroup != null) {
			logText.append("线路产品明细ID：").append(prodRouteDetailGroup.getDetailId()).append("，");
			logText.append("线路天数：").append(nDay).append("，");
			logText.append("(").append("模块ID：").append(prodRouteDetailGroup.getGroupId()).append("）");
			//创建线路行程明细
			if(oldProdRouteDetailGroup==null && prodRouteDetailGroup!=null){
				logText.append("创建"+ProdRouteDetailGroup.MODULE_TYPE.getCnName(prodRouteDetailGroup.getModuleType())+"模块(");
				logText.append(buildRouteDetailGroupLogText(prodRouteDetailGroup));
			//修改线路行程明细
			}else if(oldProdRouteDetailGroup!=null && prodRouteDetailGroup!=null){
				logText.append("修改"+ProdRouteDetailGroup.MODULE_TYPE.getCnName(prodRouteDetailGroup.getModuleType())+"模块(");
				logText.append("修改前的"+(oldProdRouteDetailGroup.getStartTime()!=null?"开始时间："+oldProdRouteDetailGroup.getStartTime()+(!"Y".equals(oldProdRouteDetailGroup.getLocalTimeFlag())?",":"(当地时间),"):""));
				logText.append("修改后的"+(prodRouteDetailGroup.getStartTime()!=null?"开始时间："+prodRouteDetailGroup.getStartTime()+(!"Y".equals(prodRouteDetailGroup.getLocalTimeFlag())?",":"(当地时间),"):""));
				if(ProdRouteDetailGroup.MODULE_TYPE.SCENIC.name().equals(prodRouteDetailGroup.getModuleType())){
					if(prodRouteDetailGroup.getProdRouteDetailScenicList()!=null){
						logText.append("修改前的【");
						for(ProdRouteDetailScenic prodRouteDetailScenic:oldProdRouteDetailGroup.getProdRouteDetailScenicList()){
			 				logText.append(createScenicLog(prodRouteDetailScenic));
							logText.append(";");
						}
						logText.append("】,修改后的【");
						for(ProdRouteDetailScenic prodRouteDetailScenic:prodRouteDetailGroup.getProdRouteDetailScenicList()){
							logText.append(createScenicLog(prodRouteDetailScenic));
							logText.append(";");
						}
						logText.append("】");
					}
				}else if(ProdRouteDetailGroup.MODULE_TYPE.HOTEL.name().equals(prodRouteDetailGroup.getModuleType())){
					if(prodRouteDetailGroup.getProdRouteDetailHotelList()!=null){
						logText.append("修改前的【");
						for(ProdRouteDetailHotel prodRouteDetailHotel:oldProdRouteDetailGroup.getProdRouteDetailHotelList()){
			 				logText.append(createHotelLog(prodRouteDetailHotel));
							logText.append(";");
						}
						logText.append("】,修改后的【");
						for(ProdRouteDetailHotel prodRouteDetailHotel:prodRouteDetailGroup.getProdRouteDetailHotelList()){
							logText.append(createHotelLog(prodRouteDetailHotel));
							logText.append(";");
						}
						logText.append("】");
					}
				}else if(ProdRouteDetailGroup.MODULE_TYPE.VEHICLE.name().equals(prodRouteDetailGroup.getModuleType())){
					if(prodRouteDetailGroup.getProdRouteDetailVehicleList()!=null){
						logText.append("修改前的【");
						for(ProdRouteDetailVehicle prodRouteDetailVehicle:oldProdRouteDetailGroup.getProdRouteDetailVehicleList()){
			 				logText.append(createVehicleLog(prodRouteDetailVehicle));
							logText.append(";");
						}
						logText.append("】,修改后的【");
						for(ProdRouteDetailVehicle prodRouteDetailVehicle:prodRouteDetailGroup.getProdRouteDetailVehicleList()){
							logText.append(createVehicleLog(prodRouteDetailVehicle));
							logText.append(";");
						}
						logText.append("】");
					}
				}else if(ProdRouteDetailGroup.MODULE_TYPE.MEAL.name().equals(prodRouteDetailGroup.getModuleType())){
					if(prodRouteDetailGroup.getProdRouteDetailMealList()!=null){
						logText.append("修改前的【");
						for(ProdRouteDetailMeal prodRouteDetailMeal:oldProdRouteDetailGroup.getProdRouteDetailMealList()){
							logText.append(createMealLog(prodRouteDetailMeal));
							logText.append(";");
						}
						logText.append("】,修改后的【");
						for(ProdRouteDetailMeal prodRouteDetailMeal:prodRouteDetailGroup.getProdRouteDetailMealList()){
							logText.append(createMealLog(prodRouteDetailMeal));
							logText.append(";");
						}
						logText.append("】");
					}
				}else if(ProdRouteDetailGroup.MODULE_TYPE.SHOPPING.name().equals(prodRouteDetailGroup.getModuleType())){
					if(prodRouteDetailGroup.getProdRouteDetailShoppingList()!=null){
						logText.append("修改前的【");
						for(ProdRouteDetailShopping prodRouteDetailShopping:oldProdRouteDetailGroup.getProdRouteDetailShoppingList()){
							logText.append(createShoppingLog(prodRouteDetailShopping));
							logText.append(";");
						}
						logText.append("】,修改后的【");
						for(ProdRouteDetailShopping prodRouteDetailShopping:prodRouteDetailGroup.getProdRouteDetailShoppingList()){
							logText.append(createShoppingLog(prodRouteDetailShopping));
							logText.append(";");
						}
						logText.append("】");
					}
				}else if(ProdRouteDetailGroup.MODULE_TYPE.FREE_ACTIVITY.name().equals(prodRouteDetailGroup.getModuleType())
						|| ProdRouteDetailGroup.MODULE_TYPE.OTHER_ACTIVITY.name().equals(prodRouteDetailGroup.getModuleType())){
					logText.append("修改前的【");
					for(ProdRouteDetailActivity prodRouteDetailActivity:oldProdRouteDetailGroup.getProdRouteDetailActivityList()){
						logText.append(createActivityLog( prodRouteDetailActivity));
						logText.append(";");
					}
					logText.append("】,修改后的【");
					for(ProdRouteDetailActivity prodRouteDetailActivity:prodRouteDetailGroup.getProdRouteDetailActivityList()){
						logText.append(createActivityLog( prodRouteDetailActivity));
						logText.append(";");
					}
					logText.append("】");
				}
				
				logText.append(")");
			}
			
		}
		return logText.toString();
	}
	
	private String buildRouteDetailGroupLogText(ProdRouteDetailGroup prodRouteDetailGroup){
		StringBuffer  logText = new StringBuffer();
		logText.append(prodRouteDetailGroup.getStartTime()!=null?"开始时间："+prodRouteDetailGroup.getStartTime()+(!"Y".equals(prodRouteDetailGroup.getLocalTimeFlag())?",":"(当地时间),"):"");
		if(ProdRouteDetailGroup.MODULE_TYPE.SCENIC.name().equals(prodRouteDetailGroup.getModuleType())){
			for(ProdRouteDetailScenic prodRouteDetailScenic:prodRouteDetailGroup.getProdRouteDetailScenicList()){
				logText.append(createScenicLog(prodRouteDetailScenic));
				logText.append(";");
			}
			
		}else if(ProdRouteDetailGroup.MODULE_TYPE.HOTEL.name().equals(prodRouteDetailGroup.getModuleType())){
			for(ProdRouteDetailHotel prodRouteDetailHotel:prodRouteDetailGroup.getProdRouteDetailHotelList()){
				logText.append(createHotelLog(prodRouteDetailHotel));
				logText.append(";");
			}
		}else if(ProdRouteDetailGroup.MODULE_TYPE.VEHICLE.name().equals(prodRouteDetailGroup.getModuleType())){
			for(ProdRouteDetailVehicle prodRouteDetailVehicle:prodRouteDetailGroup.getProdRouteDetailVehicleList()){
				logText.append(createVehicleLog(prodRouteDetailVehicle));
				logText.append(";");
			}
		}else if(ProdRouteDetailGroup.MODULE_TYPE.MEAL.name().equals(prodRouteDetailGroup.getModuleType())){
			for(ProdRouteDetailMeal prodRouteDetailMeal:prodRouteDetailGroup.getProdRouteDetailMealList()){
				logText.append(createMealLog(prodRouteDetailMeal));
				logText.append(";");
			}
		}else if(ProdRouteDetailGroup.MODULE_TYPE.SHOPPING.name().equals(prodRouteDetailGroup.getModuleType())){
			for(ProdRouteDetailShopping prodRouteDetailShopping:prodRouteDetailGroup.getProdRouteDetailShoppingList()){
				logText.append(createShoppingLog(prodRouteDetailShopping));
				logText.append(";");
			}
		}else if(ProdRouteDetailGroup.MODULE_TYPE.FREE_ACTIVITY.name().equals(prodRouteDetailGroup.getModuleType())
				|| ProdRouteDetailGroup.MODULE_TYPE.OTHER_ACTIVITY.name().equals(prodRouteDetailGroup.getModuleType())){
			for(ProdRouteDetailActivity prodRouteDetailActivity:prodRouteDetailGroup.getProdRouteDetailActivityList()){
				logText.append(createActivityLog( prodRouteDetailActivity));
				logText.append(";");
			}
		}
		return logText.append(")").toString();
		
	}
	
	
	
	private String buildDeleteRouteDetailGroupLogText(ProdRouteDetailGroup prodRouteDetailGroup, Integer nDay) {
		StringBuilder logText = new StringBuilder();
		if (prodRouteDetailGroup != null) {
			logText.append("线路产品明细ID：").append(prodRouteDetailGroup.getDetailId()).append("，");
			logText.append("线路天数：").append(nDay).append("，");
			logText.append("删除"+ProdRouteDetailGroup.MODULE_TYPE.getCnName(prodRouteDetailGroup.getModuleType())+"模块(");
			logText.append(buildRouteDetailGroupLogText(prodRouteDetailGroup));
		}
		return logText.toString();
	}
	
	private String createVehicleLog(ProdRouteDetailVehicle prodRouteDetailVehicle){
		String vehicleType = prodRouteDetailVehicle.getVehicleType();
		Map<String,Object> propMap = new HashMap<String, Object>();
		Map<String,Object> explainMap = new HashMap<String,Object>();
		propMap.put("VehicleType", "交通类型");
		explainMap.put("VehicleType", VEHICLE_TYPE.getCnName(prodRouteDetailVehicle.getVehicleType()));
		if(vehicleType!=null){
			if( vehicleType.equals(VEHICLE_TYPE.PLANE.name())){
				propMap.put("VehicleTime", "飞行时间");
				propMap.put("VehicleKm", "飞行距离");
			}else{
				propMap.put("VehicleTime", "行驶时间");
				propMap.put("VehicleKm", "行驶距离");
			}
		}
		if ("Y".equals(prodRouteDetailVehicle.getPickUpFlag()) ) {
			propMap.put("PickUpDay", "接机服务");
		}
		propMap.put("VehicleDesc", "交通说明");
		return ComLogUtil.appendLogs(propMap, prodRouteDetailVehicle, explainMap);
	}
	
	private String createScenicLog(ProdRouteDetailScenic prodRouteDetailScenic){
		Map<String,Object> propMap = new HashMap<String, Object>();
		Map<String,Object> explainMap = new HashMap<String,Object>();
		propMap.put("ScenicName", "前往景点");
		propMap.put("ScenicExplainName", "行程已含、自费景点、推荐景点");
		propMap.put("ReferencePrice", "参考价格");
		propMap.put("OtherFeesTip", "自定义服务");
		propMap.put("TravelTime", "行驶时间");
		propMap.put("DistanceKM", "行驶距离");
		propMap.put("VisitTime", "游览时间");
		propMap.put("UseTemplateFlag", "话术模板");
		propMap.put("ScenicDesc", "活动说明");
		explainMap.put("UseTemplateFlag", "Y".equals(prodRouteDetailScenic.getUseTemplateFlag())?"使用":"不使用");
		if(prodRouteDetailScenic.getReferencePrice()!=null){
			explainMap.put("ReferencePrice", (prodRouteDetailScenic.getReferencePrice()/100) 
				+(prodRouteDetailScenic.getCurrency()!=null?SuppGoods.CURRENCYTYPE.getCnName(prodRouteDetailScenic.getCurrency()):""));
		}
		return ComLogUtil.appendLogs(propMap, prodRouteDetailScenic, explainMap);
	}
	
	private String createHotelLog(ProdRouteDetailHotel prodRouteDetailHotel){
		Map<String,Object> propMap = new HashMap<String, Object>();
		Map<String,Object> explainMap = new HashMap<String,Object>();
		propMap.put("HotelName", "入住酒店");
		propMap.put("RoomType", "房型");
		propMap.put("StarLevelName", "星级");
		propMap.put("BelongToPlace", "所在地");
		propMap.put("UseTemplateFlag", "启用模板");
		propMap.put("HotelDesc", "酒店说明");
		propMap.put("TravelTime", "行驶时间");
		propMap.put("DistanceKM", "行驶距离");
		explainMap.put("UseTemplateFlag", "Y".equals(prodRouteDetailHotel.getUseTemplateFlag())?"使用":"不使用");
		return ComLogUtil.appendLogs(propMap, prodRouteDetailHotel, explainMap);
	}
	
	private String createMealLog(ProdRouteDetailMeal prodRouteDetailMeal){
		Map<String,Object> propMap = new HashMap<String, Object>();
		Map<String,Object> explainMap = new HashMap<String,Object>();
		propMap.put("MealName", "用餐类型");
		propMap.put("MealTime", "用餐时间");
		propMap.put("Price", "餐费标准");
		propMap.put("MealPlace", "用餐地点");
		propMap.put("UseTemplateFlag", "启用模板");
		propMap.put("MealDesc", "用餐说明");
		explainMap.put("UseTemplateFlag", "Y".equals(prodRouteDetailMeal.getUseTemplateFlag())?"使用":"不使用");
		if(prodRouteDetailMeal.getPrice()!=null){
			explainMap.put("Price", (prodRouteDetailMeal.getPrice()/100)
			+(prodRouteDetailMeal.getCurrency()!=null?SuppGoods.CURRENCYTYPE.getCnName(prodRouteDetailMeal.getCurrency()):""));
		}
		explainMap.put("MealPlace", ("1".equals(prodRouteDetailMeal.getMealPlace())? "酒店内":prodRouteDetailMeal.getMealPlaceOther()));
		return ComLogUtil.appendLogs(propMap, prodRouteDetailMeal, explainMap);
	}
	
	private String createActivityLog(ProdRouteDetailActivity prodRouteDetailActivity){
		Map<String,Object> propMap = new HashMap<String, Object>();
		Map<String,Object> explainMap = new HashMap<String,Object>();
		propMap.put("VisitTime", "活动时间");
		propMap.put("TravelTime", "行驶时间");
		propMap.put("DistanceKm", "行驶距离");
		propMap.put("ActivityDesc", "活动内容");
		return ComLogUtil.appendLogs(propMap, prodRouteDetailActivity, explainMap);
	}
	
	private String createShoppingLog(ProdRouteDetailShopping prodRouteDetailShopping){
		Map<String,Object> propMap = new HashMap<String, Object>();
		Map<String,Object> explainMap = new HashMap<String,Object>();
		propMap.put("ShoppingName", "购物点");
		propMap.put("RecommendFlag", "启用推荐购物点");
		propMap.put("Dddress", "购物点地址");
		propMap.put("MainProducts", "主营产品");
		propMap.put("UseTemplateFlag", "启用模板");
		propMap.put("SubjoinProducts", "兼营产品");
		propMap.put("TravelTime", "行驶时间");
		propMap.put("DistanceKM", "行驶距离");
		propMap.put("VisitTime", "参观时间");
		propMap.put("ShoppingDesc", "购物点说明 ");
		explainMap.put("UseTemplateFlag", "Y".equals(prodRouteDetailShopping.getUseTemplateFlag())?"使用":"不使用");
		explainMap.put("RecommendFlag", "Y".equals(prodRouteDetailShopping.getRecommendFlag())?"使用":"不使用");
		return ComLogUtil.appendLogs(propMap, prodRouteDetailShopping, explainMap);
	}
	
	

	private String buildSaveWarningFlagLogText(String warningFlag) {
		StringBuilder logText = new StringBuilder();
			logText.append("设置行程警告提示为：").append("Y".equals(warningFlag) ? "是" : "否");
		return logText.toString();
	}

	private String buildSaveDayHeaderLogText(ProdLineRouteDetail prodLineRouteDetail, ProdLineRouteDetail oldProdLineRouteDetail) {
		StringBuilder logText = new StringBuilder();
		if (prodLineRouteDetail != null) {
			logText.append("线路产品明细ID：").append(prodLineRouteDetail.getDetailId()).append("，");
			logText.append("线路天数：").append(prodLineRouteDetail.getnDay()).append("，");
			if(oldProdLineRouteDetail==null){
				logText.append("创建标题信息：").append(prodLineRouteDetail.getTitle());
			}else{
				logText.append("修改标题信息：").append("【旧值】"+(oldProdLineRouteDetail.getTitle()!=null?oldProdLineRouteDetail.getTitle():"" ))
				.append("【新值】"+(prodLineRouteDetail.getTitle()!=null?prodLineRouteDetail.getTitle():"" ));
			}
		}
		return logText.toString();
	}

	private String buildDeleteModuleLogText(ProdRouteDetailGroup prodRouteDetailGroup, Short nDay) {
		StringBuilder logText = new StringBuilder();
		if (prodRouteDetailGroup != null) {
			logText.append("线路产品明细ID：").append(prodRouteDetailGroup.getDetailId()).append("，");
			logText.append("线路天数：").append(nDay).append("，");
			logText.append("删除").append(ProdRouteDetailGroup.MODULE_TYPE.getCnName(prodRouteDetailGroup.getModuleType())).append("模块下子模块信息");
		}
		return logText.toString();
	}
	
	private void sendMessageToGroupProductManager(ProdProduct prodProduct){
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
					log.info("当前当地游产品被跟团游产品打包，且当地游产品行程明细被修改，向产品经理发送通知，packProductList size = "+packProductList.size()+"当地游:prodProductId = "+prodProduct.getProductId());
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
}
