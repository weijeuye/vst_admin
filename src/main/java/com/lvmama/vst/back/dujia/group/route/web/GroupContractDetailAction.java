package com.lvmama.vst.back.dujia.group.route.web;

import static com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE.PROD_TRAVEL_DESIGN;
import static com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE.PROD_LINE_ROUTE;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.dujia.comm.route.detail.po.ProdRouteDetailGroup;
import com.lvmama.vst.back.dujia.comm.route.detail.po.ProdRouteDetailRecommend;
import com.lvmama.vst.back.dujia.comm.route.detail.po.ProdRouteDetailShopping;
import com.lvmama.vst.back.dujia.comm.route.detail.service.ProdLineRouteDetailHelperService;
import com.lvmama.vst.back.dujia.comm.route.detail.service.ProdRouteDetailGroupService;
import com.lvmama.vst.back.dujia.comm.route.detail.service.ProdRouteDetailRecommendService;
import com.lvmama.vst.back.dujia.comm.route.detail.service.ProdRouteDetailShoppingService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.prod.po.ProdContractDetail;
import com.lvmama.vst.back.prod.po.ProdLineRoute;
import com.lvmama.vst.back.prod.po.ProdLineRouteDetail;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.client.prod.service.ProdContractDetailClientService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteDetailClientService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteClientService;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.pub.service.PushAdapterService;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.back.utils.MiscUtils;

@Controller
@RequestMapping("/dujia/group/route/contractDetail")
public class GroupContractDetailAction extends BaseActionSupport {

	private static final long serialVersionUID = 8430171557699260014L;

	@Autowired
	private ProdProductService prodProductService;

	@Autowired
	private ProdLineRouteClientService prodLineRouteService;

	@Autowired
	private ProdContractDetailClientService prodContractDetailService;

	@Autowired
	private ComLogClientService comLogService;

	@Autowired
	private PushAdapterService pushAdapterService;
	
	@Autowired
	private ProdRouteDetailRecommendService prodRouteDetailRecommendService;
	
	@Autowired
	private ProdRouteDetailShoppingService prodRouteDetailShoppingService;
	
	@Autowired
	private ProdLineRouteDetailClientService prodLineRouteDetailService;
	
	@Autowired
	private ProdRouteDetailGroupService prodRouteDetailGroupService;
	
	@Autowired
	ProdLineRouteDetailHelperService prodLineRouteDetailHelperService;

	/**
	 * 跳转到推荐活动
	 */
	@RequestMapping(value = "/showAddContractDetailList")
	public String showAddContractDetailList(Model model, Long productId, Long lineRouteId,String editFlag , String oldProductId , HttpServletRequest req,Long categoryId) throws BusinessException {

		Map<String, Object> paramters = new HashMap<String, Object>();
		paramters.put("productId", productId);
		paramters.put("lineRouteId", lineRouteId);
		paramters.put("routeId", lineRouteId);
		
		List<ProdContractDetail> prodContractDetails = MiscUtils.autoUnboxing(prodContractDetailService.findFullContractList(paramters,null));
		//来自合同信息表的    推荐列表
		List<ProdContractDetail> recommendList = new ArrayList<ProdContractDetail>();
		//来自合同信息表的    购物点
		List<ProdContractDetail> shopingList = new ArrayList<ProdContractDetail>();
		//判断查询可有数据
		if(null != prodContractDetails && prodContractDetails.size() > 0){
			for(ProdContractDetail prodContractDetail : prodContractDetails){
				if(ProdContractDetail.CONTRACT_DETAIL_TYPE.SHOPING.getCode().toString().equals(prodContractDetail.getDetailType())){//购物点信息
					shopingList.add(prodContractDetail);
				}
				if(ProdContractDetail.CONTRACT_DETAIL_TYPE.RECOMMEND.getCode().toString().equals(prodContractDetail.getDetailType())){//推荐模块信息
					recommendList.add(prodContractDetail);
				}
			}
		}
		model.addAttribute("recommendList", recommendList);	
		model.addAttribute("shopingList", shopingList);
		model.addAttribute("productId", productId);
		model.addAttribute("lineRouteId", lineRouteId);
		model.addAttribute("noEditFlag", editFlag);
		model.addAttribute("oldProductId", oldProductId);
		
		ProdProduct prodProduct = prodProductService.findProdProductByProductId(productId);
		model.addAttribute("prodProduct", prodProduct);
		model.addAttribute("packageType", ProdProduct.PACKAGETYPE.getCnName(prodProduct.getPackageType()));
		model.addAttribute("prodLineRoute", prodLineRouteService.findByProdLineRouteId(lineRouteId));
		model.addAttribute("categoryId",categoryId);
		return "/dujia/group/route/showContractDetailList";
	}

	/**
	 * 进入添加/修改页
	 */
	@RequestMapping(value = "/addOrUpdateContractDetail")
	public String addOrUpdateContractDetail(Model model, ProdContractDetail prodContractDetail, Long lineRouteId,Long categoryId)
			throws UnsupportedEncodingException {
		model.addAttribute("categoryId", categoryId);
		if("ROUTE".equals(prodContractDetail.getRouteContractSource())){
			Map<String, Object> parameters = new HashMap<String, Object>();
			ProdContractDetail newProdContractDetail = new ProdContractDetail();
			if(prodContractDetail.getDetailId() != null){
				parameters.put("recommendId", prodContractDetail.getDetailId());
				List<ProdRouteDetailRecommend> prodRouteDetailRecommendList = prodRouteDetailRecommendService.findRecommendListByParams(parameters);
				if(0!=prodRouteDetailRecommendList.size()){
					ProdRouteDetailRecommend recommendFromLine = prodRouteDetailRecommendList.get(0);
					newProdContractDetail.setRouteContractSource("ROUTE");
					newProdContractDetail.setDetailId(recommendFromLine.getRecommendId());
					newProdContractDetail.setDetailType("RECOMMEND");
					newProdContractDetail.setAddress(recommendFromLine.getAddress());
					newProdContractDetail.setDetailName(recommendFromLine.getRecommendName());
					if(null!=recommendFromLine.getReferencePrice()){
						newProdContractDetail.setDetailValue(recommendFromLine.getReferencePrice()/100+" "+SuppGoods.CURRENCYTYPE.getCnName(recommendFromLine.getCurrency()));
					}
					newProdContractDetail.setStay(recommendFromLine.getVisitTime());
					newProdContractDetail.setOther(recommendFromLine.getRecommendDesc());
				}else{
					parameters.put("shoppingId", prodContractDetail.getDetailId());
					List<ProdRouteDetailShopping> ProdRouteDetailShoppingLsit = prodRouteDetailShoppingService.findShoppingListByParams(parameters);
					if(0!=ProdRouteDetailShoppingLsit.size()){
						ProdRouteDetailShopping shoppingFromLine = ProdRouteDetailShoppingLsit.get(0);
						newProdContractDetail.setRouteContractSource("ROUTE");
						newProdContractDetail.setDetailId(shoppingFromLine.getShoppingId());
						newProdContractDetail.setDetailType("SHOPING");
						newProdContractDetail.setAddress(shoppingFromLine.getAddress());
						newProdContractDetail.setDetailName(shoppingFromLine.getShoppingName());
						newProdContractDetail.setDetailValue(shoppingFromLine.getMainProducts());
						if(null!=shoppingFromLine.getVisitTime() || "".equals(shoppingFromLine.getVisitTime())){
							String[] timeArr = (""+shoppingFromLine.getVisitTime()+"").split(":");
							String sHour = "";
							String sMin = "";
							Long hour = 0L;
							Long min = 0L;
							if(shoppingFromLine.getVisitTime().trim().lastIndexOf(":")==(shoppingFromLine.getVisitTime().trim().length()-1)){
								sHour = timeArr[0];
								if(null!=sHour && !"".equals(sHour)){
									hour = Long.parseLong(sHour)*60;
								}
								newProdContractDetail.setStay(hour);
						    }else if(shoppingFromLine.getVisitTime().trim().indexOf(":")==0){
								sMin = timeArr[1];
								if(null!=sMin && !"".equals(sMin)){
									min = Long.parseLong(sMin);
								}
								newProdContractDetail.setStay(min);
							}else{
								sHour = timeArr[0];
								sMin = timeArr[1];
								if(null!=sHour && !"".equals(sHour)){
									hour = Long.parseLong(sHour)*60;
								}
								if(null!=sMin && !"".equals(sMin)){
									min = Long.parseLong(sMin);
								}
								newProdContractDetail.setStay(hour+min);
							}
						}
						newProdContractDetail.setOther(shoppingFromLine.getShoppingDesc());
					}
				}
			}
				
			model.addAttribute("prodContractDetail", newProdContractDetail);
			return "/dujia/group/route/showAddContractDetailFromRoute";
		}else{//来自 合同条款的信息
			
			if (prodContractDetail.getDetailId() != null) {
				prodContractDetail = prodContractDetailService.findProdContractDetailById(prodContractDetail.getDetailId());
			}
			model.addAttribute("prodContractDetail", prodContractDetail);
			return "/dujia/group/route/showAddContractDetail";
		}
	}

	/**
	 * 添加/修改
	 */
	@RequestMapping(value = "/saveProdContractDetail")
	@ResponseBody
	public Object addProdContractDetail(ProdContractDetail prodContractDetail) throws BusinessException {
		String detailType;
		ResultMessage resultMessage;

		if (ProdContractDetail.CONTRACT_DETAIL_TYPE.RECOMMEND.getCode().toString()
				.equalsIgnoreCase(prodContractDetail.getDetailType())) {
			detailType = "推荐项目.";
		} else {
			detailType = "购物说明.";
		}
		String loginfo = "";
		if (prodContractDetail.getDetailId() != null) {
			ProdContractDetail oldProdContractDetail = prodContractDetailService
					.findProdContractDetailById(prodContractDetail.getDetailId());
			loginfo = getupdateLogInfo(oldProdContractDetail, prodContractDetail, "增加了" + detailType);
			prodContractDetailService.updateProdContractDetail(prodContractDetail);
			resultMessage = ResultMessage.UPDATE_SUCCESS_RESULT;
		} else {
			loginfo = getaddLogInfo(prodContractDetail, detailType);
			prodContractDetailService.addProdContractDetail(prodContractDetail);
			resultMessage = ResultMessage.ADD_SUCCESS_RESULT;
		}

		// 消息推送
		if (prodContractDetail.getDetailId() != null)
			pushAdapterService.push(prodContractDetail.getProductId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_CONTRACT_DETAIL, ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
		
		// 添加操作日志(增加了第几天的购物，修改了第几天推荐)
		ProdLineRoute LineRoute = new ProdLineRoute();
		LineRoute.setProductId(prodContractDetail.getProductId());
		LineRoute.setLineRouteId(prodContractDetail.getLineRouteId());
		logLineRouteOperate(LineRoute, loginfo, "合同条款操作");

		return resultMessage;
	}

	/**
	 * 删除
	 */
	@RequestMapping(value = "/deleteProdContractDetail")
	@ResponseBody
	public Object deleteProdContractDetail(Model model, Long detailId,String routeContractSource,String detailType, HttpServletResponse res)throws BusinessException {
		ProdContractDetail oldProdContractDetail = new ProdContractDetail();
		ProdLineRoute LineRoute =new ProdLineRoute();
		Map<String,Object> params = new HashMap<String,Object>();
		String loginfo = "";
		//操作日志
		String type;
		Long groupId = 0L;
		Long newDetailId = 0L;
		Long productId = 0L;
		Long routeId = 0L;
		if(ProdContractDetail.CONTRACT_DETAIL_TYPE.RECOMMEND.getCode().toString()
				.equalsIgnoreCase(detailType)){
			type = "推荐项目.";
		}else{
			type = "购物说明.";
		}
		if(null!=routeContractSource && "ROUTE".equals(routeContractSource)){
            if(null!=detailType && "SHOPING".equals(detailType)){
            	params.put("shoppingId", detailId);
            	List<ProdRouteDetailShopping> prodRouteDetailShoppingList = prodRouteDetailShoppingService.findShoppingListByParams(params);
            	if(0!=prodRouteDetailShoppingList.size() && null!=prodRouteDetailShoppingList.get(0).getGroupId()){
            		 groupId = prodRouteDetailShoppingList.get(0).getGroupId();
            	}
            }else if(null!=detailType && "RECOMMEND".equals(detailType)){
            	params.put("recommendId", detailId);
            	List<ProdRouteDetailRecommend> prodRouteDetailRecommendList = prodRouteDetailRecommendService.findRecommendListByParams(params);
            	if(0!=prodRouteDetailRecommendList.size() && null!=prodRouteDetailRecommendList.get(0).getGroupId()){
            		 groupId = prodRouteDetailRecommendList.get(0).getGroupId();
            	}
            }
            
          //通过groupId查询detailId 
			ProdRouteDetailGroup prodRouteDetailGroup = prodRouteDetailGroupService.findGroupByGroupId(groupId);
			if(null!=prodRouteDetailGroup){
				newDetailId=prodRouteDetailGroup.getDetailId();
				routeId = prodRouteDetailGroup.getRouteId();
				ProdLineRoute prodLineRoute = MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(routeId));
				if(null!=prodLineRoute){
					productId = prodLineRoute.getProductId();
				}
			}
			
			//删除合同条款中的   行程明细中的（推荐项目  或  购物点）信息
			//回写老数据
			prodLineRouteDetailHelperService.deleteByGroupIdAndUpdate(groupId, newDetailId, productId,detailId);
		}else{
			oldProdContractDetail=prodContractDetailService.findProdContractDetailById(detailId);
			prodContractDetailService.deleteByPrimaryKey(detailId);
			loginfo=getaddLogInfo(oldProdContractDetail,"删除了"+type);
			LineRoute.setProductId(oldProdContractDetail.getProductId());
			LineRoute.setLineRouteId(oldProdContractDetail.getLineRouteId());
		}
		logLineRouteOperate(LineRoute,loginfo,"合同条款操作");
		return ResultMessage.DELETE_SUCCESS_RESULT;
	}
	// 日志
	public String getaddLogInfo(ProdContractDetail prodContractDetail, String detailType) {
		String insertLog = "";
		String logvname = "";
		String logvvalue = "";
		String logvstay = "";
		if (ProdContractDetail.CONTRACT_DETAIL_TYPE.RECOMMEND.getCode().toString()
				.equalsIgnoreCase(prodContractDetail.getDetailType())) {
			logvname = "项目名称和内容 :";
			logvvalue = "费    用:";
			logvstay = "项目时长(分钟)：";
		} else {
			logvname = "购物场所名称:";
			logvvalue = "主要商品信息:";
			logvstay = "最长停留时间(分钟):";
		}
		insertLog = "合同条款  :" + detailType + ",行程天数" + prodContractDetail.getnDays()==null?"":prodContractDetail.getnDays() + "天 " + ",地点 ："
				+ prodContractDetail.getAddress() + "," + logvname + prodContractDetail.getDetailName() + ","
				+ logvvalue + prodContractDetail.getDetailValue() + "," + logvstay + prodContractDetail.getStay()
				+ ",其他说明：" + prodContractDetail.getOther();
		return insertLog;
	}

	// 日志
	public String getupdateLogInfo(ProdContractDetail oldprodContractDetail, ProdContractDetail newprodContractDetail,
			String detailType) {
		String updateLog = "";
		String logvname = "";
		String logvvalue = "";
		String logvstay = "";
		if (ProdContractDetail.CONTRACT_DETAIL_TYPE.RECOMMEND.getCode().toString()
				.equalsIgnoreCase(newprodContractDetail.getDetailType())) {
			logvname = "项目名称和内容 :";
			logvvalue = "费    用:";
			logvstay = "项目时长(分钟):";
		} else {
			logvname = "购物场所名称:";
			logvvalue = "主要商品信息:";
			logvstay = "最长停留时间(分钟):";
		}
		updateLog = "合同条款  :更新了 " + detailType + ",行程天数" + "原值【" + oldprodContractDetail.getnDays() + "】" + "新值：【"
				+ newprodContractDetail.getnDays() + "】天 " + ",地点 ：" + "原值【" + oldprodContractDetail.getAddress() + "】"
				+ "新值：【" + newprodContractDetail.getAddress() + "】" + "," + logvname + "原值【"
				+ oldprodContractDetail.getDetailName() + "】" + "新值：【" + newprodContractDetail.getDetailName() + "】"
				+ "," + logvvalue + "原值【" + oldprodContractDetail.getDetailValue() + "】" + "新值：【"
				+ newprodContractDetail.getDetailValue() + "】" + "," + logvstay + "原值【"
				+ oldprodContractDetail.getStay() + "】" + "新值：【" + newprodContractDetail.getStay() + "】" + ",其他说明："
				+ "原值【" + oldprodContractDetail.getOther() + "】" + "新值：【" + newprodContractDetail.getOther() + "】";
		return updateLog;
	}

	/**
	 * 记录行程操作日志
	 */
	private void logLineRouteOperate(ProdLineRoute LineRoute, String logText, String logName) {
		try {
			// 获取行程名称
			ProdLineRoute prodLineRoute = MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(LineRoute.getLineRouteId()));
			comLogService.insert(PROD_LINE_ROUTE, LineRoute.getProductId(), LineRoute.getLineRouteId(),
					this.getLoginUser().getUserName(), "【" + prodLineRoute.getRouteName() + "】" + logText,
					PROD_TRAVEL_DESIGN.name(), logName, null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log Type:" + PROD_TRAVEL_DESIGN.name());
			log.error(e.getMessage(), e);
		}
	}
}
