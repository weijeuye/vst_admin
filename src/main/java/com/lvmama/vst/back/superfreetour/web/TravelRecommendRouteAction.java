package com.lvmama.vst.back.superfreetour.web;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

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
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.client.biz.service.BranchClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.prod.po.ProdPackageDetail;
import com.lvmama.vst.back.prod.po.ProdPackageGroup;
import com.lvmama.vst.back.prod.po.ProdPackageGroupLine;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductBranch;
import com.lvmama.vst.back.prod.service.ProdProductBranchAdapterService;
import com.lvmama.vst.back.prod.service.ProdProductBranchService;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.superfreetour.service.TravelHotelRuleService;
import com.lvmama.vst.back.superfreetour.service.TravelRecommendRouteService;
import com.lvmama.vst.back.superfreetour.util.PrUtil;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.MemcachedEnum;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.superfreetour.po.TravelHotelTime;
import com.lvmama.vst.superfreetour.po.TravelRecommendRoute;
import com.lvmama.vst.superfreetour.po.TravelRecommendRouteDetail;
import com.lvmama.vst.superfreetour.po.TravelRecommendTicket;
import com.lvmama.vst.superfreetour.po.TravelRouteDetailGroup;

/**
 * 旅游宝典的行程Action
 * @author zhangdewen
 */
@Controller
@RequestMapping("/superfreetour/travelRecommendRoute")
public class TravelRecommendRouteAction extends BaseActionSupport {
	private static final long serialVersionUID = -67978060897567688L;
	
	private static final Log LOG = LogFactory.getLog(TravelRecommendRouteAction.class);

	@Autowired
	private TravelRecommendRouteService routeService;
	
	@Autowired
	private ComLogClientService comLogService;

	@Autowired
	private ProdProductBranchService prodProductBranchService;

	@Autowired
	private ProdProductService prodProductService;

	@Autowired
	private BranchClientService branchService;
	

	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;

	@Autowired
	private ProdProductBranchAdapterService prodProductBranchAdapterService;

	@Autowired
	private TravelHotelRuleService hotelRuleService;
	
	
	/**
	 * 超级自由行行程->选择门票
	 *
	 * @param model
	 * @param page
	 * @param groupId
	 * @param groupType
	 * @param transportType
	 * @param prodProduct goodsid goodsname等参数会映射到里面
	 * @param selectCategoryId
	 * @param redirectType
	 * @param productBranchId
	 * @param branchName
	 * @param SeatValue
	 * @param goodsValidStatus
	 * @param req
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/showSelectProductList")
	public Object showSelectProductList(Model model, Integer page,Long groupId, String groupType, ProdProduct prodProduct,
										Long selectCategoryId, String productType,  Long productBranchId, String branchName,String redirectType,
										String goodsValidStatus,HttpServletRequest req) throws BusinessException {
		model.addAttribute("groupType", groupType);
		model.addAttribute("selectCategoryId", selectCategoryId);
		model.addAttribute("redirectType", redirectType);

		if (prodProduct != null) {
			model.addAttribute("productName", prodProduct.getProductName());
			model.addAttribute("productId", prodProduct.getProductId());
		}
		model.addAttribute("productBranchId", productBranchId);
		model.addAttribute("branchName", branchName);
		model.addAttribute("goodsValidStatus", goodsValidStatus);

		String subCategoryId = req.getParameter("subCategoryId");
		model.addAttribute("subCategoryId", subCategoryId);
		String bizCategoryId = req.getParameter("bizCategoryId");
		model.addAttribute("bizCategoryId", bizCategoryId);


		ProdPackageGroupLine prodPackageGroupLine = new ProdPackageGroupLine();


		// 存放下拉选择品类列表
		List<BizCategory> selectCategoryList = new ArrayList<BizCategory>();
		BizCategory selectBizCategory = bizCategoryQueryService
				.getCategoryById(selectCategoryId);
		selectCategoryList.add(selectBizCategory);

		model.addAttribute("selectCategoryList", selectCategoryList);

		if (page == null && StringUtil.isEmptyString(redirectType)) {
			model.addAttribute("redirectType", "1");

				return "/superfreetour/showSelectTicketProductList";

		}

		// 分装请求参数
		Map<String, Object> paramProdProduct = new HashMap<String, Object>();

		paramProdProduct.put("bizCategoryId", selectCategoryId);
		paramProdProduct.put("subCategoryId", subCategoryId);
		paramProdProduct.put("productName", prodProduct.getProductName());
		paramProdProduct.put("productId", prodProduct.getProductId());
		if (prodProduct.getSuppGoods() != null) {
			paramProdProduct.put("suppGoodsName", prodProduct.getSuppGoods().getGoodsName());
			paramProdProduct.put("suppGoodsId", prodProduct.getSuppGoods().getSuppGoodsId());
		}
		paramProdProduct.put("cancelFlag", prodProduct.getCancelFlag());
		paramProdProduct.put("saleFlag", "Y");
		if (prodProduct.getBizDistrict() != null) {
			paramProdProduct.put("bizDistrictId", prodProduct.getBizDistrict()
					.getDistrictId());
			paramProdProduct.put("districtName", prodProduct.getBizDistrict()
					.getDistrictName());
		}

		if (StringUtil.isEmptyString(groupType)) {
			groupType = prodProduct.getPackageType();
		}

		paramProdProduct.put("groupId", groupId);
		paramProdProduct.put("priceType",
				ProdPackageDetail.OBJECT_TYPE_DESC.PROD_BRANCH.name());

		if (prodPackageGroupLine != null) {
			paramProdProduct.put("routeNum",
					prodPackageGroupLine.getTravelDays());
			paramProdProduct.put("stayNum", prodPackageGroupLine.getStayDays());
		}

		if (selectBizCategory != null
				&& StringUtil.isNotEmptyString(selectBizCategory
				.getCategoryCode())
				&& selectBizCategory.getCategoryCode()
				.indexOf("category_route") >= 0) {
			paramProdProduct.put("packageType",
					ProdProduct.PACKAGETYPE.SUPPLIER.name());
		}
		if(prodProduct != null && prodProduct.getSuppSupplier()!=null)
		{
			paramProdProduct.put("supplierId",prodProduct.getSuppSupplier().getSupplierId());
		}

		//酒+景子品类维护组合信息
		if (StringUtil.isNotEmptyString(goodsValidStatus)) {
			paramProdProduct.put("goodsValidStatus", goodsValidStatus);
		}
		// 给paramProdProduct增加规格名称和规格ID参数 add by zhoudengyun
		paramProdProduct.put("branchName", branchName);
		paramProdProduct.put("productBranchId", productBranchId);
		paramProdProduct.put("prepaid", true);// 是否为预付款的

		// 为组类型为大交通的分装查询参数
		paramProdProduct.put("groupType", groupType);

		//如果是门票并且是组合套餐票(yangdechao)封装供应商打包参数
		if(ProdPackageGroup.GROUPTYPE.LINE_TICKET.name().equalsIgnoreCase(groupType))
		{
			String categoryCode="";
			if (selectBizCategory != null&& StringUtil.isNotEmptyString(selectBizCategory.getCategoryCode()))
			{
				categoryCode = selectBizCategory.getCategoryCode();
				if(categoryCode.equals("category_comb_ticket"))
				{
					paramProdProduct.put("packageType","SUPPLIER");
				}

			}
		}
		Page pageParam;
		try {
			log.info("use prodProductBranchAdapterService.findProdProductBranchCountForLine begin! paramProdProduct is "+paramProdProduct);
			int count = prodProductBranchAdapterService
					.findProdProductBranchCountForLine(paramProdProduct);
			log.info("use prodProductBranchAdapterService.findProdProductBranchCountForLine end! count is "+count);

			int pagenum = page == null ? 1 : page;
			pageParam = Page.page(count, 20, pagenum);
			pageParam.buildUrl(req);
			paramProdProduct.put("_start", pageParam.getStartRows());
			paramProdProduct.put("_end", pageParam.getEndRows());
			paramProdProduct.put("_orderby", "t.category_id");
			paramProdProduct.put("_order", "DESC");

			// 给paramProdProduct增加规格名称和规格ID参数 add by zhoudengyun
			log.info("use prodProductBranchAdapterService.findProdProductBranchListForLine begin! paramProdProduct is "+paramProdProduct);
			List<ProdProductBranch> list = prodProductBranchAdapterService
					.findProdProductBranchListForLine(paramProdProduct);
			log.info("use prodProductBranchAdapterService.findProdProductBranchListForLine end! list is "+list);
			pageParam.setItems(list);
			model.addAttribute("pageParam", pageParam);
		} catch (Exception e) {
			log.info(e);
			throw new BusinessException("系统内部异常！");
		}

		String inputType = "checkbox";
		model.addAttribute("inputType", inputType);
		model.addAttribute("groupId", groupId);


		if (ProdPackageGroup.GROUPTYPE.LINE_TICKET.name()
				.equalsIgnoreCase(groupType)) {

			return "/superfreetour/showSelectTicketProductList";
		} else {
			throw new BusinessException("参数groupType:[" + groupType + "]传递错误");
		}
	}

	/**
	 * 跳转到行程首页
	 */
	@RequestMapping(value = "/showTravelRoute")
	public String showUpdateTravelRoute(Model model, Long recommendId) throws BusinessException {
		//传递参数旅游宝典Id
		model.addAttribute("recommendId", recommendId);
		
		//获取行程天数
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("recommendId", recommendId);		
		List<TravelRecommendRoute> routeList =  routeService.findRecommendRoute(params);
		int daynum=1;
		if(CollectionUtils.isNotEmpty(routeList)){
			TravelRecommendRoute route = routeList.get(0);
			if(route != null){
				daynum = route.getRouteNum().intValue();
				model.addAttribute("travelRecommendRoute", route);
			}
		}
		
		//获取行程明细
		params = new HashMap<String, Object>();
		params.put("recommendId", recommendId);
		List<TravelRecommendRouteDetail> routeDetailList =  routeService.findRouteDetail(params);
		//routeDetailList 可能是不连续的，不从第一天开始的，不完整的
		if(routeDetailList==null){
			routeDetailList = new ArrayList<>();
		}
		for(int i=1;i<=daynum;i++){
			if(routeDetailList.size()<i){
				//数组没有天数大，直接追加到最后
				routeDetailList.add(null);
			}else if(routeDetailList.get(i-1)==null || routeDetailList.get(i-1).getnDay().intValue()!=i){
				//目标位置空缺，或者目标位置不是当天，则追加在这个位置
				routeDetailList.add(i-1,null);
			}
		}

		model.addAttribute("routeDetailList", routeDetailList);
		//获取第一天的行程明细
		TravelRecommendRouteDetail routeDetail = routeDetailList.get(0);
		if(routeDetail != null){
			model.addAttribute("routeDetail", routeDetail);
			//获取某天的行程明细分组
			List<TravelRouteDetailGroup> detailGroupList = getDetailGroupList(routeDetail.getDetailId());
			if(CollectionUtils.isNotEmpty(detailGroupList)){
				model.addAttribute("detailGroupList", detailGroupList);
			}
		}
		return "/superfreetour/travelRecommendRoute";
	}
	
	/**
	 * 获取某天的行程明细
	 * @param recommendId 旅游宝典Id
	 * @param nDay 第几天
	 * @return
	 */
	private TravelRecommendRouteDetail getRouteDetail(Long recommendId, Long nDay){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("recommendId", recommendId);
		params.put("nDay", nDay);
		List<TravelRecommendRouteDetail> routeDetailList =  routeService.findRouteDetail(params);
		TravelRecommendRouteDetail routeDetail = null;
		if(CollectionUtils.isNotEmpty(routeDetailList)){
			routeDetail = routeDetailList.get(0);
		}
		return routeDetail;
	}
	
	/**
	 * 获取某天的行程明细分组
	 * @param detailId 行程明细Id
	 * @return 行程明细分组
	 */
	private List<TravelRouteDetailGroup> getDetailGroupList(Long detailId){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("detailId", detailId);
		List<TravelRouteDetailGroup> detailGroupList =  routeService.findRouteDetailGroup(params);
		//多个图片地址是“，”分隔，把图片地址从字符串转化为List结构
		if(CollectionUtils.isNotEmpty(detailGroupList)){
			for(TravelRouteDetailGroup detailGroup : detailGroupList){
				String photoUrls = detailGroup.getPhotoUrl();
				if (StringUtils.isNotEmpty(photoUrls)){
					List<String> photoUrlList = new ArrayList<String>();
					for (String photoUrl : photoUrls.split(",")) {
						photoUrlList.add(photoUrl);
					}
					detailGroup.setPhotoUrlList(photoUrlList);
				}
			}
		}
		return detailGroupList;
	}
	
	/**
	 * 获取某天行程
	 */
	@RequestMapping(value = "/getNdayRoute")
	@ResponseBody
	public Object getNdayRoute(Long routeDetailId) throws BusinessException {
		if(routeDetailId == null){
			LOG.warn("getNdayRoute error. routeDetailId=" + routeDetailId);
			return new ResultMessage("error", "行程明细Id为空，获取失败");
		}
		
		//获取第N天的行程明细
		TravelRecommendRouteDetail routeDetail = routeService.findRouteDetailById(routeDetailId);
		if(routeDetail != null){
			Map<String, Object> attributes = new HashMap<String, Object>();
			attributes.put("routeDetail", routeDetail);
			//获取某天的行程明细分组
			List<TravelRouteDetailGroup> detailGroupList = getDetailGroupList(routeDetail.getDetailId());
			if(CollectionUtils.isNotEmpty(detailGroupList)){
				attributes.put("detailGroupList", detailGroupList);
			}
			return new ResultMessage(attributes, "success", "获取行程明细成功");
		}
		return new ResultMessage("error", "获取行程明细失败");
	}
	
	/**
	 * 获取行程天数
	 */
	@RequestMapping(value = "/getRouteNum")
	@ResponseBody
	public Object getRouteNum(Long recommendId) throws BusinessException {
		if(recommendId == null){
			LOG.warn("getRouteNum error. routeDetailId=" + recommendId);
			return new ResultMessage("error", "宝典Id为空，获取失败");
		}
		//获取行程天数
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("recommendId", recommendId);		
		List<TravelRecommendRoute> routeList =  routeService.findRecommendRoute(params);
		if(CollectionUtils.isNotEmpty(routeList)){
			TravelRecommendRoute route = routeList.get(0);
			if(route != null){
				Map<String, Object> attributes = new HashMap<String, Object>();
				attributes.put("routeNum", route.getRouteNum());
				return new ResultMessage(attributes, "success", "保存成功");
			}
		}
		return new ResultMessage("error", "获取行程天数失败");
	}	
	
	/**
	 * 新增行程天数
	 */
	@RequestMapping(value = "/addRouteNum")
	@ResponseBody
	public Object addRouteNum(Long recommendId, Long routeNum) throws BusinessException {
		if(routeNum == null){
			LOG.warn("addRouteNum error. routeNum=" + routeNum);
			return new ResultMessage("error", "宝典Id为空，获取失败");
		}
		//获取行程天数
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("recommendId", recommendId);		
		List<TravelRecommendRoute> routeList =  routeService.findRecommendRoute(params);
		TravelRecommendRoute route = null;
		if(CollectionUtils.isNotEmpty(routeList)){
			route = routeList.get(0);						
		}
		if(route == null){
			route = new TravelRecommendRoute();
			route.setRecommendId(recommendId);				
		}
		route.setRouteNum(routeNum);
		route.setStayNum(routeNum - 1);
		Long routeId = routeService.saveTravelRecommendRoute(route);
		if(routeId > 0){
			// 添加操作日志
			try {
				comLogService.insert(COM_LOG_OBJECT_TYPE.TRAVEL_RECOMMEND_ROUTE, route.getRecommendId(), 
						route.getRouteId(), this.getLoginUser().getUserName(), 
						"新增行程天数：" + routeNum ,
						COM_LOG_LOG_TYPE.TRAVEL_RECOMMEND_ROUTE_CHANGE.name(), "新增行程天数", null);
			} catch (Exception e) {
				log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.TRAVEL_RECOMMEND_ROUTE_CHANGE.name(), e);
			}
			return new ResultMessage("success", "新增行程天数成功");
		}
		return new ResultMessage("error", "新增行程天数失败");
	}
	
	/**
	 * 保存行程
	 */
	@RequestMapping(value = "/saveRoute")
	@ResponseBody
	public Object saveTravelRecommendRoute(Long recommendId,String jsonStr) throws BusinessException {
		if(recommendId == null){
			LOG.warn("saveTravelRecommendRoute error. recommendId=" + recommendId);
			return new ResultMessage("error", "未获取正确数据，保存失败");
		}

		JSONObject jsonObject = JSONObject.fromObject(jsonStr);
		Map<String, Class> classMap = new HashMap<String, Class>();
		classMap.put("detailGroupList", TravelRouteDetailGroup.class);
		classMap.put("ticketList",TravelRecommendTicket.class);
		TravelRecommendRouteDetail routeDetail = (TravelRecommendRouteDetail) JSONObject.toBean(jsonObject,TravelRecommendRouteDetail.class,classMap);
		if(routeDetail == null){
			LOG.warn("saveTravelRecommendRoute error. routeDetail=" + routeDetail);
			return new ResultMessage("error", "未获取正确数据，保存失败");
		}

		//补足数据
		List<TravelRouteDetailGroup> detailGroups = routeDetail.getDetailGroupList();
		if(detailGroups!=null){
			long index=0;
			for (TravelRouteDetailGroup detailGroup : detailGroups) {
				detailGroup.setPropSort(index);
				index++;
			}
		}

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("recommendId", recommendId);
		List<TravelRecommendRoute> routeList =  routeService.findRecommendRoute(params);
		TravelRecommendRoute route = null;
		Map<String, Object> attributes = new HashMap<String, Object>();
		if(CollectionUtils.isNotEmpty(routeList)){
			route = routeList.get(0);
			routeDetail.setRouteId(route.getRouteId());
			attributes.put("routeId", route.getRouteId());
		} else {
			//如果数据库中没有相关行程，保存行程
			route = new TravelRecommendRoute();
			route.setRecommendId(recommendId);
			Long routeNum = routeDetail.getnDay();
			route.setRouteNum(routeNum);
			route.setStayNum(routeNum - 1);
			Long routeId = routeService.saveTravelRecommendRoute(route);
			routeDetail.setRouteId(routeId);
			attributes.put("routeId", routeId);
		}

		routeDetail.setRecommendId(recommendId);
		if(routeDetail.getDetailId() == null){  //新增行程明细
			Long routeDetailId = routeService.insertRouteDetail(routeDetail);
			if(routeDetailId != null && routeDetailId > 0){
				attributes.put("routeDetailId", routeDetailId);
				// 添加操作日志
				try {
					String logContent = getRouteDetailLog(routeDetail);
					comLogService.insert(COM_LOG_OBJECT_TYPE.TRAVEL_RECOMMEND_ROUTE, route.getRecommendId(),
							route.getRouteId(), this.getLoginUser().getUserName(),
							"新增行程第【" + routeDetail.getnDay() + "】天。" + logContent,
							COM_LOG_LOG_TYPE.TRAVEL_RECOMMEND_ROUTE_CHANGE.name(), "添加行程", null);
				} catch (Exception e) {
					log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.TRAVEL_RECOMMEND_ROUTE_CHANGE.name(), e);
				}
				return new ResultMessage(attributes, "success", "保存成功");
			}
		} else {  //修改行程明细
			//获取老的行程及行程明细，用于记录日志
			TravelRecommendRouteDetail oldRouteDetail = routeService.findRouteDetailById(routeDetail.getDetailId());
			params = new HashMap<String, Object>();
			params.put("detailId", routeDetail.getDetailId());
			List<TravelRouteDetailGroup> oldDetailGroupList =  routeService.findRouteDetailGroup(params);
			if(CollectionUtils.isNotEmpty(oldDetailGroupList)){
				oldRouteDetail.setDetailGroupList(oldDetailGroupList);
			}

			//修改行程及行程明细
			routeService.updateRouteDetail(routeDetail);
			attributes.put("routeDetailId", routeDetail.getDetailId());
			// 添加操作日志
			try {
				String logContent = getRouteDetailChangeLog(oldRouteDetail, routeDetail);
				comLogService.insert(COM_LOG_OBJECT_TYPE.TRAVEL_RECOMMEND_ROUTE, route.getRecommendId(), 
						route.getRouteId(), this.getLoginUser().getUserName(), 
						"修改行程第【" + routeDetail.getnDay() + "】天，修改内容：" + logContent,
						COM_LOG_LOG_TYPE.TRAVEL_RECOMMEND_ROUTE_CHANGE.name(), "修改行程", null);
			} catch (Exception e) {
				log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.TRAVEL_RECOMMEND_ROUTE_CHANGE.name(), e);
			}
			return new ResultMessage(attributes, "success", "保存成功");
		}
		return new ResultMessage("error", "保存失败");
	}
	
	/**
	 * 获取行程明细的详细内容，用于记录日志
	 * @param routeDetail 行程明细
	 * @return 行程明细的详细内容
	 */
	private String getRouteDetailLog(TravelRecommendRouteDetail routeDetail) {
		StringBuffer logStr = new StringBuffer("");
		if (null != routeDetail) {			
			logStr.append("行程标题:").append(routeDetail.getRouteTitle());
			logStr.append("，行程明细:");
			List<TravelRouteDetailGroup> groupList = routeDetail.getDetailGroupList();
			//先遍历行程明细，并删除新的行程明细中相同类型的行程明细
			if(CollectionUtils.isNotEmpty(groupList)){
				for (TravelRouteDetailGroup group : groupList) {
						logStr.append(group.toString()).append(",");
				}
			}			
		}
		//删除结尾的“，”
		String logContent = logStr.toString();
		if(logContent.endsWith(",")){
			logContent = logContent.substring(0, logContent.length()-1);
		}
		return logContent;
	}
	
	/**
	 * 把行程明细List转化为Map结构
	 * @param groupList 行程明细List
	 * @return 行程明细Map
	 */
	private Map<String, TravelRouteDetailGroup> getDetailGroupMap(List<TravelRouteDetailGroup> groupList) {
		Map<String, TravelRouteDetailGroup> groupMap = new HashMap<String, TravelRouteDetailGroup>();
		if(CollectionUtils.isNotEmpty(groupList)){
			for (TravelRouteDetailGroup group : groupList) {
				if(group.getPropType() != null){
					groupMap.put(group.getPropType(), group);
				}
			}
		}
		return groupMap;
	}
	
	/**
	 * 获取行程明细的变化，用于记录日志
	 * @param oldRouteDetail 老的行程明细
	 * @param newRouteDetail 新的行程明细
	 * @return 行程明细的变化日志内容
	 */
	private String getRouteDetailChangeLog(TravelRecommendRouteDetail oldRouteDetail, 
			TravelRecommendRouteDetail newRouteDetail) {
		StringBuffer logStr = new StringBuffer("");
		if (null != oldRouteDetail && null != newRouteDetail) {			
			logStr.append(ComLogUtil.getLogTxt("行程标题", newRouteDetail.getRouteTitle(), oldRouteDetail.getRouteTitle()));

			List<TravelRouteDetailGroup> newGroupList = newRouteDetail.getDetailGroupList();
			List<TravelRouteDetailGroup> oldGroupList = oldRouteDetail.getDetailGroupList();
			Map<String, TravelRouteDetailGroup> oldGroupMap = getDetailGroupMap(oldGroupList);
			//先遍历新的行程明细，并删除新的行程明细中相同类型的行程明细
			if(CollectionUtils.isNotEmpty(newGroupList)){
				for (TravelRouteDetailGroup newGroup : newGroupList) {
					String propType = TravelRouteDetailGroup.PROPTYPE.getCnName(newGroup.getPropType());
					TravelRouteDetailGroup oldGroup = oldGroupMap.remove(newGroup.getPropType());					
					if(oldGroup != null){ //存在老的行程明细
						//行程明细发生变化，则记录日志
						if(!newGroup.toString().equalsIgnoreCase(oldGroup.toString())){ 
							logStr.append(ComLogUtil.getLogTxt(propType, newGroup.toString(), oldGroup.toString()));
						}
					} else { //不存在老的行程明细
						logStr.append(ComLogUtil.getLogTxt(propType, newGroup.toString(), null));
					}
				}
			}
			//如果老的行程明细还有值
			for (Map.Entry<String, TravelRouteDetailGroup> entry : oldGroupMap.entrySet()) {
				String propType = TravelRouteDetailGroup.PROPTYPE.getCnName(entry.getKey());
				logStr.append(ComLogUtil.getLogTxt(propType, null, entry.getValue().toString()));
			}
		}
		return logStr.toString();
	}
	
	/**
	 * 删除第N天行程
	 */
	@RequestMapping(value = "/deleteRouteDetail")
	@ResponseBody
	public Object deleteRouteDetail(Long routeDetailId, Long dayNum, Long recommendId) throws BusinessException {
		Map<String, Object> hotelTimeparams = new HashMap<String, Object>();
		hotelTimeparams.put("recommendId", recommendId);
		List<TravelHotelTime> hotelTimeList =  hotelRuleService.findTravelHotelTime(hotelTimeparams);
		String str="该日期已被酒店规则设置应用,请先去资源组合设置的酒店规则页面设置页面删除该日期的时间段才可删除此日期喔~";
		Map<String, Object> attributes = new HashMap<String, Object>();
		List<String> dayAllList=new ArrayList<String>();
		if(CollectionUtils.isNotEmpty(hotelTimeList)){
			for(TravelHotelTime travelHotelTime: hotelTimeList){
				String dayStr=travelHotelTime.getDays();
				if(!PrUtil.isEmpty(dayStr)){
				String [] dayArray=	dayStr.split(",");
				List<String> daylist = Arrays.asList(dayArray);  
				dayAllList.addAll(daylist);
				}
			}
			if(!PrUtil.isEmpty(dayAllList)){
				for (int i = 0; i < dayAllList.size(); i++) {
					if(String.valueOf(dayNum).equals(dayAllList.get(i))){
						return new ResultMessage(attributes, "error", str);
					}
				}
			}
		}
		//根据routeDetailId删除第N天行程
		if(routeDetailId != null){
			//获取删除的行程及行程明细，用于记录日志
			TravelRecommendRouteDetail routeDetail = routeService.findRouteDetailById(routeDetailId);
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("detailId", routeDetail.getDetailId());
			List<TravelRouteDetailGroup> detailGroupList =  routeService.findRouteDetailGroup(params);
			routeDetail.setDetailGroupList(detailGroupList);
			
			try {
				routeService.deleteRouteDetail(routeDetail);
			} catch (Exception e) {
				log.error("TravelRecommendRouteDetail deleteRouteDetail error.", e);
				return new ResultMessage("error", "行程天数小于1，不能删除行程");
			}
			// 添加操作日志
			try {
				String logContent = getRouteDetailLog(routeDetail);
				comLogService.insert(COM_LOG_OBJECT_TYPE.TRAVEL_RECOMMEND_ROUTE, routeDetail.getRecommendId(), 
						routeDetail.getRouteId(), this.getLoginUser().getUserName(), 
						"删除行程第【" + routeDetail.getnDay() + "】天。" + logContent,
						COM_LOG_LOG_TYPE.TRAVEL_RECOMMEND_ROUTE_CHANGE.name(), "删除行程", null);
			} catch (Exception e) {
				log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.TRAVEL_RECOMMEND_ROUTE_CHANGE.name(), e);
			}
			return new ResultMessage("success", "保存成功");
		} else {  //根据recommendId、nDay删除第N天行程
			if(dayNum == null){
				LOG.warn("deleteRouteDetail error. dayNum=" + dayNum);
				return new ResultMessage("error", "未获取第几天，删除失败");
			}
			try {
				//获取行程
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("recommendId", recommendId);		
				List<TravelRecommendRoute> routeList =  routeService.findRecommendRoute(params);
				TravelRecommendRoute route = null;
				if(CollectionUtils.isNotEmpty(routeList)){
					route = routeList.get(0);
					if(route != null){
						routeService.deleteRouteDetail(recommendId, dayNum, route);
						// 添加操作日志
						try {
							comLogService.insert(COM_LOG_OBJECT_TYPE.TRAVEL_RECOMMEND_ROUTE, recommendId, 
									route.getRouteId(), this.getLoginUser().getUserName(), 
									"删除行程第【" + dayNum + "】天。",
									COM_LOG_LOG_TYPE.TRAVEL_RECOMMEND_ROUTE_CHANGE.name(), "删除行程", null);
						} catch (Exception e) {
							log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.TRAVEL_RECOMMEND_ROUTE_CHANGE.name(), e);
						}
					}
				}				
			} catch (Exception e) {
				log.error("TravelRecommendRouteDetail deleteRouteDetail error.", e);
				return new ResultMessage("error", "行程天数小于1，不能删除行程");
			}			
			return new ResultMessage("success", "保存成功");
		}
	}
	
	/**
	 * 删除第N天行程的某个行程明细
	 */
	@RequestMapping(value = "/deleteRouteDetailGroup")
	@ResponseBody
	public Object deleteRouteDetailGroup(TravelRouteDetailGroup detailGroup, Long recommendId, Long routeId,
			Long routeDetailId, Long routeDetailGroupId, Long nDay) throws BusinessException {
		if(detailGroup == null){
			LOG.warn("deleteRouteDetailGroup error. routeDetailGroupId=" + detailGroup);
			return new ResultMessage("error", "未获取明细Id，删除失败");
		}
		
		routeService.deleteRouteDetailGroup(detailGroup.getGroupId());
		
		String recommendMemKey = MemcachedEnum.TravelRecommendInfo.getKey()+recommendId;
        MemcachedUtil.getInstance().remove(recommendMemKey);
		// 添加操作日志
		try {
			comLogService.insert(COM_LOG_OBJECT_TYPE.TRAVEL_RECOMMEND_ROUTE, recommendId, 
					routeId, this.getLoginUser().getUserName(), "删除行程明细：【" + nDay + "】天。" + detailGroup.toString(),
					COM_LOG_LOG_TYPE.TRAVEL_RECOMMEND_ROUTE_CHANGE.name(), "修改行程", null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.TRAVEL_RECOMMEND_ROUTE_CHANGE.name(), e);
		}
		return new ResultMessage("success", "保存成功");
	}
}
