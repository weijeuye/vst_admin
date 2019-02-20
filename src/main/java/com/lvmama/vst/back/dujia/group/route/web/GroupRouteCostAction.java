package com.lvmama.vst.back.dujia.group.route.web;

import com.alibaba.fastjson.JSONObject;
import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.comm.pet.po.pub.ComMessage;
import com.lvmama.comm.pet.service.pub.ComMessageService;
import com.lvmama.vst.back.dujia.comm.route.po.ProdLineRouteDescription;
import com.lvmama.vst.back.dujia.client.comm.route.service.ProdLineRouteDescriptionClientService;
import com.lvmama.vst.back.dujia.group.route.vo.CostExcludeInnerVO;
import com.lvmama.vst.back.dujia.group.route.vo.CostExcludeOutsideVO;
import com.lvmama.vst.back.dujia.group.route.vo.CostIncludeInnerVO;
import com.lvmama.vst.back.dujia.group.route.vo.CostIncludeOutsideVO;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.goods.vo.ProdProductParam;
import com.lvmama.vst.back.prod.po.ProdLineRoute;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteClientService;
import com.lvmama.vst.back.prod.service.ProdProductService;
import static com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE.PROD_TRAVEL_DESIGN;
import static com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE.PROD_LINE_ROUTE;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.MemcachedEnum;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.lvmama.vst.back.utils.MiscUtils;

@Controller
@RequestMapping("/dujia/group/route/cost")
public class GroupRouteCostAction extends BaseActionSupport {

	private static final long serialVersionUID = 976483245381853295L;
	

	private static final Log LOG = LogFactory.getLog(GroupRouteCostAction.class);

	@Autowired
	private ProdLineRouteDescriptionClientService prodLineRouteDescriptionService;

	@Autowired
	private ProdProductService prodProductService;

	@Autowired
	private ProdLineRouteClientService prodLineRouteService;

	@Autowired
	private ComLogClientService comLogService;
	
	@Autowired
	private PermUserServiceAdapter permUserServiceAdapter;
	
	@Autowired
	private ComMessageService comMessageService;

	/**
	 * 跳转到费用说明（国内 或 出境）
	 */
	@RequestMapping(value="/editProdRouteCost")
	public String toEditProdRouteCost(Model model,Long productId, String productType, Long lineRouteId, String editFlag , String oldProductId) {
		if(productId == null || StringUtil.isEmptyString(productType) || lineRouteId == null){
			throw new BusinessException("系统参数异常：某些必要参数为空"); 
		}

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productId", productId);
		params.put("lineRouteId", lineRouteId);
		params.put("productType", productType);
		List<ProdLineRouteDescription> lineRouteDescriptionList = MiscUtils.autoUnboxing(prodLineRouteDescriptionService.findLineRouteDescriptionListByParams(params));

		//设置N早N正
		Map<String,Integer> mapRouteDetail = MiscUtils.autoUnboxing(prodLineRouteService.getMealCountMap(lineRouteId));
		String breackfaskCount = Long.toString(mapRouteDetail.get("breackfaskCount"));
		String lunchCount = Long.toString(mapRouteDetail.get("lunchCount"));

		model.addAttribute("lineRouteId", lineRouteId);
		model.addAttribute("productId", productId);
		model.addAttribute("productType", productType);
		model.addAttribute("noEditFlag", editFlag);
		model.addAttribute("oldProductId", oldProductId);

		ProdProductParam paramMap=new ProdProductParam();
		paramMap.setBizCategory(true);
		ProdProduct prodProduct = prodProductService.findProdProductById(productId,paramMap);
		model.addAttribute("prodProduct", prodProduct);
		model.addAttribute("packageType", ProdProduct.PACKAGETYPE.getCnName(prodProduct.getPackageType()));
		model.addAttribute("prodLineRoute", prodLineRouteService.findByProdLineRouteId(lineRouteId));
		//判断产品版本为1.0(是供应商打包，类别为15)
		Double modelVesion=prodProduct.getModelVersion();
		if(modelVesion==null||modelVesion!=1.0){
			model.addAttribute("modelVersion", "false");
		}else if(modelVesion==1.0){
			model.addAttribute("modelVersion", "true");
		}
		//是否是新增页面(用于判断页面是否显示 页面尚未保存 提示框)
		boolean isAddPage = false;
		if ("FOREIGNLINE".equals(productType)) {
			//费用包含（出境）
			CostIncludeOutsideVO costIncluOutside = new CostIncludeOutsideVO();
			//费用不包含（出境）
			CostExcludeOutsideVO costExcludeOutsideVO = new CostExcludeOutsideVO();
			if(CollectionUtils.isNotEmpty(lineRouteDescriptionList)){
				for(ProdLineRouteDescription routeDesc : lineRouteDescriptionList){
					if(ProdLineRouteDescription.CONTENT_TYPE.COST_INCLUDE.name().equals(routeDesc.getContentType())){
						costIncluOutside =JSONObject.parseObject(routeDesc.getContent(), CostIncludeOutsideVO.class);
					}
					if(ProdLineRouteDescription.CONTENT_TYPE.COST_EXCLUDE.name().equals(routeDesc.getContentType())){
						costExcludeOutsideVO = JSONObject.parseObject(routeDesc.getContent(), CostExcludeOutsideVO.class);
					}
				}
			}else{
				//页面初始化
				isAddPage = true;
				costIncluOutside.setLargeTrans("team_ticket");
				costIncluOutside.setLocalTraffic(new String[]{"local_tra"});
				costIncluOutside.setStay("stay_dest_hotel");
				costIncluOutside.setTicket("include_ticket");
				costIncluOutside.setDinner("dinner_detail");
				costIncluOutside.setTourGuideSer("local_tour_guide");
				costIncluOutside.setInsurance("insurace_give");
				costIncluOutside.setChilPriStan("children_price");
				costIncluOutside.setChilCostIncl("children_include");
			}
			costIncluOutside.setBreackfaskCount(breackfaskCount);
			costIncluOutside.setLunchCount(lunchCount);

			model.addAttribute("isAddPage", isAddPage);
			model.addAttribute("costIncludeOutsideVO", costIncluOutside);
			model.addAttribute("costExcludeOutsideVO", costExcludeOutsideVO);

			return "/dujia/group/route/showRouteCostOut";

		} else if("INNERLONGLINE".equals(productType)||"INNERSHORTLINE".equals(productType) || "INNER_BORDER_LINE".equals(productType) ||"INNERLINE".equals(productType)){
			//费用包含（国内）
			CostIncludeInnerVO costIncludeInnerVO = new CostIncludeInnerVO();
			//费用不包含（国内）
			CostExcludeInnerVO costExcludeInnerVO = new CostExcludeInnerVO();
			if(CollectionUtils.isNotEmpty(lineRouteDescriptionList)){
				for(ProdLineRouteDescription routeDesc :lineRouteDescriptionList){
					if(ProdLineRouteDescription.CONTENT_TYPE.COST_INCLUDE.name().equals(routeDesc.getContentType())){
						costIncludeInnerVO = JSONObject.parseObject(routeDesc.getContent(), CostIncludeInnerVO.class);
						model.addAttribute("lineRouteDescriptionIn", routeDesc);
					}
					if (ProdLineRouteDescription.CONTENT_TYPE.COST_EXCLUDE.name().equals(routeDesc.getContentType())) {
						costExcludeInnerVO = JSONObject.parseObject(routeDesc.getContent(), CostExcludeInnerVO.class);
						model.addAttribute("lineRouteDescriptionEx", routeDesc);
					}
				}
			}else{
				//页面初始化
				isAddPage = true;
				costIncludeInnerVO.setStay("stay_hotel");
				costIncludeInnerVO.setDinner("dinner_all");
				costIncludeInnerVO.setChilPriStan("children_price");
				costIncludeInnerVO.setChilCostIncl("children_include");
			}
			costIncludeInnerVO.setBreackfaskCount(breackfaskCount);
			costIncludeInnerVO.setLunchCount(lunchCount);
			model.addAttribute("bizDistrict", prodProduct.getBizDistrict());
			model.addAttribute("prodDestReList", prodProduct.getProdDestReList());
			model.addAttribute("isAddPage", isAddPage);
			model.addAttribute("costIncludeInnerVO", costIncludeInnerVO);
			model.addAttribute("costExcludeInnerVO", costExcludeInnerVO);

			return "/dujia/group/route/showRouteCostIn";
		}
		return "";
	}

	/**
	 * 新增、编辑费用说明（国内）
	 */
	@RequestMapping(value = "/saveCostInner")
	@ResponseBody
	public Object saveCostInner(CostIncludeInnerVO costIncludeInnerVO,CostExcludeInnerVO costExcludeInnerVO, ProdLineRouteDescription lineRouteDescription) throws BusinessException {
		if (costIncludeInnerVO == null ||costExcludeInnerVO == null ||
				lineRouteDescription == null || lineRouteDescription.getProductId() == null || 
				lineRouteDescription.getLineRouteId() == null|| StringUtil.isEmptyString(lineRouteDescription.getProductType())) {
			return new ResultMessage(ResultMessage.ERROR, "系统异常：某些必要参数为空");
		}

		try {
			//费用包含
			ProdLineRouteDescription descInclude = new ProdLineRouteDescription();
			descInclude.setCategoryId(lineRouteDescription.getCategoryId());
			descInclude.setProductId(lineRouteDescription.getProductId());
			descInclude.setProductType(lineRouteDescription.getProductType());
			descInclude.setLineRouteId(lineRouteDescription.getLineRouteId());
			descInclude.setContentType(ProdLineRouteDescription.CONTENT_TYPE.COST_INCLUDE.name());
			descInclude.setContent(JSONObject.toJSONString(costIncludeInnerVO));
			prodLineRouteDescriptionService.saveOrUpdateDoublePlaceForRouteDes(descInclude);

			//费用不含
			ProdLineRouteDescription descExclude=new ProdLineRouteDescription();
			descExclude.setCategoryId(lineRouteDescription.getCategoryId());
			descExclude.setProductId(lineRouteDescription.getProductId());
			descExclude.setProductType(lineRouteDescription.getProductType());
			descExclude.setLineRouteId(lineRouteDescription.getLineRouteId());
			descExclude.setContentType(ProdLineRouteDescription.CONTENT_TYPE.COST_EXCLUDE.name());
			descExclude.setContent(JSONObject.toJSONString(costExcludeInnerVO));
			prodLineRouteDescriptionService.saveOrUpdateDoublePlaceForRouteDes(descExclude);

			//日志
			ProdLineRoute prodLineRoute=new ProdLineRoute();
			prodLineRoute.setLineRouteId(lineRouteDescription.getLineRouteId());
			prodLineRoute.setProductId(lineRouteDescription.getProductId());
			logLineRouteOperate(prodLineRoute,"更新行程费用说明：","新增、编辑费用说明（国内）");
			
			//如果当地游产品被跟团游产品打包，且当地游产品名称修改，消息通知跟团游产品经理
			ProdProduct prodProduct = prodProductService.findProdProductByProductId(lineRouteDescription.getProductId());
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
			//清除缓存
			MemcachedUtil.getInstance().remove(MemcachedEnum.ProdRouteCostStatementInner.getKey() +lineRouteDescription.getLineRouteId());
			return new ResultMessage(ResultMessage.SUCCESS, "保存成功");
		} catch (Exception e) {
			return new ResultMessage(ResultMessage.ERROR, "系统异常");
		}
	}

	/**
	 * 新增、编辑费用说明（出境）
	 */
	@RequestMapping(value = "/saveCostOut")
	@ResponseBody
	public Object saveCostOut(CostIncludeOutsideVO costIncludeOutsideVO,CostExcludeOutsideVO costExcludeOutsideVO, ProdLineRouteDescription lineRouteDescription) throws BusinessException {
		if (costIncludeOutsideVO == null ||costExcludeOutsideVO == null ||
				lineRouteDescription == null || lineRouteDescription.getProductId() == null || 
				lineRouteDescription.getLineRouteId() == null|| StringUtil.isEmptyString(lineRouteDescription.getProductType())) {
			return new ResultMessage(ResultMessage.ERROR, "系统异常：某些必要参数为空");
		}

		try {
			//费用包含
			ProdLineRouteDescription descInclude = new ProdLineRouteDescription();
			descInclude.setCategoryId(lineRouteDescription.getCategoryId());
			descInclude.setProductId(lineRouteDescription.getProductId());
			descInclude.setProductType(lineRouteDescription.getProductType());
			descInclude.setLineRouteId(lineRouteDescription.getLineRouteId());
			descInclude.setContentType(ProdLineRouteDescription.CONTENT_TYPE.COST_INCLUDE.name());
			descInclude.setContent(JSONObject.toJSONString(costIncludeOutsideVO));
			prodLineRouteDescriptionService.saveOrUpdateDoublePlaceForRouteDes(descInclude);

			//费用不含
			ProdLineRouteDescription descExclude = new ProdLineRouteDescription();
			descExclude.setCategoryId(lineRouteDescription.getCategoryId());
			descExclude.setProductId(lineRouteDescription.getProductId());
			descExclude.setProductType(lineRouteDescription.getProductType());
			descExclude.setLineRouteId(lineRouteDescription.getLineRouteId());
			descExclude.setContentType(ProdLineRouteDescription.CONTENT_TYPE.COST_EXCLUDE.name());
			descExclude.setContent(JSONObject.toJSONString(costExcludeOutsideVO));
			prodLineRouteDescriptionService.saveOrUpdateDoublePlaceForRouteDes(descExclude);

			//日志
			ProdLineRoute prodLineRoute=new ProdLineRoute();
			prodLineRoute.setLineRouteId(lineRouteDescription.getLineRouteId());
			prodLineRoute.setProductId(lineRouteDescription.getProductId());
			logLineRouteOperate(prodLineRoute,"更新行程费用说明：","新增、编辑费用说明（出境）");
			
			return new ResultMessage(ResultMessage.SUCCESS, "保存成功");
		} catch (Exception e) {
			return new ResultMessage(ResultMessage.ERROR, "系统异常");
		}
	}
	
	/**
	 * 记录行程操作日志
	 */
	private void logLineRouteOperate(ProdLineRoute LineRoute, String logText, String logName) {
		try{
			ProdLineRoute pRoute=MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(LineRoute.getLineRouteId()));
			
			comLogService.insert(PROD_LINE_ROUTE, LineRoute.getProductId(), LineRoute.getLineRouteId(),
					this.getLoginUser().getUserName(), "【"+pRoute.getRouteName()+"】"+logText, PROD_TRAVEL_DESIGN.name(), logName, null);
		}catch(Exception e) {
			log.error("Record Log failure ！Log Type:" + PROD_TRAVEL_DESIGN.name());
			log.error(e.getMessage(), e);
		}
	}
}
