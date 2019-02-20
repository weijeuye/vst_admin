package com.lvmama.vst.back.prod.web.traffic;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizCatePropGroup;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.po.BizCategoryProp;
import com.lvmama.vst.back.biz.po.BizDistrict;
import com.lvmama.vst.back.biz.po.BizEnum;
import com.lvmama.vst.back.biz.po.BizFlight;
import com.lvmama.vst.back.biz.po.BizTrainStop;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.biz.service.BizDictQueryService;
import com.lvmama.vst.back.biz.service.BizFlightService;
import com.lvmama.vst.back.biz.service.BizTrainStopService;
import com.lvmama.vst.back.biz.service.CategoryPropGroupService;
import com.lvmama.vst.back.client.biz.service.CategoryPropClientService;
import com.lvmama.vst.back.client.biz.service.CategoryClientService;
import com.lvmama.vst.back.biz.service.DestService;
import com.lvmama.vst.back.client.biz.service.DistrictClientService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductProp;
import com.lvmama.vst.back.prod.po.ProdTraffic;
import com.lvmama.vst.back.prod.po.ProdTrafficBus;
import com.lvmama.vst.back.prod.po.ProdTrafficFlight;
import com.lvmama.vst.back.prod.po.ProdTrafficGroup;
import com.lvmama.vst.back.prod.po.ProdTrafficTrain;
import com.lvmama.vst.back.client.prod.service.ProdProductPropClientService;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.prod.service.ProdProductServiceAdapter;
import com.lvmama.vst.back.client.prod.service.ProdTrafficBusClientService;
import com.lvmama.vst.back.prod.service.ProdTrafficFlightService;
import com.lvmama.vst.back.prod.service.ProdTrafficGroupService;
import com.lvmama.vst.back.client.prod.service.ProdTrafficClientService;
import com.lvmama.vst.back.prod.service.ProdTrafficTrainService;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;
import com.lvmama.vst.pet.goods.PetProdGoodsAdapter;
import com.lvmama.vst.back.utils.MiscUtils;

/**
 * 交通Action
 * 
 * @author qiujiehong
 * @date 2013-10-11
 */
@Controller
@RequestMapping("/prod/traffic")
public class TrafficProductAction extends BaseActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = -994536186179040393L;

	private static final Log LOG = LogFactory.getLog(TrafficProductAction.class);
	@Autowired
	private ProdProductService prodProductService;

	@Autowired
	private ProdProductPropClientService prodProductPropService;

	@Autowired
	private CategoryClientService categoryService;

	@Autowired
	private CategoryPropGroupService categoryPropGroupService;
	
	@Autowired
	private ComLogClientService comLogService;
	
	@Autowired
	private DistrictClientService districtService;
	
	@Autowired
	private PetProdGoodsAdapter petProdGoodsAdapter;
	
	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;
	
	@Autowired
	private BizDictQueryService bizDictQueryService;
	
	@Autowired
	private ProdProductServiceAdapter prodProductServiceAdapter;
	
	@Autowired
	private DestService destService;
	
	//@Autowired
	//private DistributorService distributorService;
	
	@Autowired
	private PermUserServiceAdapter permUserServiceAdapter;
	
	
	@Autowired
	private CategoryPropClientService categoryPropService;
	
	@Autowired
	private ProdTrafficClientService prodTrafficService;
	
	@Autowired
	private ProdTrafficGroupService prodTrafficGroupService;
	
	@Autowired
	private ProdTrafficFlightService prodTrafficFlightService;
	
	@Autowired
	private ProdTrafficTrainService prodTrafficTrainService;
	
	@Autowired
	private ProdTrafficBusClientService prodTrafficBusService;

    @Autowired
    private BizTrainStopService bizTrainStopService;
    
    @Autowired
	private BizFlightService bizFlightService;
	
	
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
			
			ProdProduct prodProduct = prodProductService.getProdProductBy(productId);
			//vst组织鉴权
			super.vstOrgAuthentication(LOG, prodProduct.getManagerIdPerm());
			
			model.addAttribute("productName", prodProduct.getProductName());
			model.addAttribute("categoryId", prodProduct.getBizCategoryId());
			model.addAttribute("categoryName", BizEnum.BIZ_CATEGORY_TYPE.getCnName(prodProduct.getBizCategoryId()));
		} else {
			model.addAttribute("productName", null);
		}
		return "/prod/traffic/product/showProductMaintain";
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
		BizCategory bizCategory = null;
		List<BizCatePropGroup> bizCatePropGroupList = null;
		if (req.getParameter("categoryId") != null) {
			bizCategory = bizCategoryQueryService.getCategoryById(Long.valueOf(req.getParameter("categoryId")));
			bizCatePropGroupList = categoryPropGroupService.findCategoryPropGroupsAndCategoryProp(Long.valueOf(req.getParameter("categoryId")), true);
		
		    if(bizCategory.getCategoryId()==25){
		    	// 类别
			    List<ProdProduct.PRODUCTTYPE> productTypeList = new ArrayList<ProdProduct.PRODUCTTYPE>(Arrays.asList(ProdProduct.PRODUCTTYPE.values()));
			    model.addAttribute("productTypeList", productTypeList);		
		    }
			
		}
		
		model.addAttribute("bizCategory", bizCategory);
		if(bizCategory != null){
		    model.addAttribute("categoryName", bizCategory.getCategoryName());
		}
		model.addAttribute("bizCatePropGroupList", bizCatePropGroupList);
		
		return "/prod/traffic/product/showAddProduct";
	}
	
	
	/**
	 * 新增产品
	 * 
	 * @return
	 */
	@RequestMapping(value = "/addProduct")
	@ResponseBody
	public Object addProduct(ProdProduct prodProduct,ProdTraffic prodTraffic, HttpServletRequest req, String docIds) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<addProduct>");
		}
		if (prodProduct.getBizCategoryId()!=null) {
			BizCategory category = bizCategoryQueryService.getCategoryById(prodProduct.getBizCategoryId());
			String trafficType = "";
			//设置交通类型
			if("category_traffic_aero_other".equalsIgnoreCase(category.getCategoryCode())){
				trafficType = ProdTraffic.TRAFFICTYPE.FLIGHT.name();
			//火车
			}else if("category_traffic_train_other".equalsIgnoreCase(category.getCategoryCode())){
				trafficType = ProdTraffic.TRAFFICTYPE.TRAIN.name();
			//轮船
			}else if("category_traffic_ship_other".equalsIgnoreCase(category.getCategoryCode())){
				trafficType = ProdTraffic.TRAFFICTYPE.SHIP.name();
			//巴士
			}else if("category_traffic_bus_other".equalsIgnoreCase(category.getCategoryCode())){
				trafficType = ProdTraffic.TRAFFICTYPE.BUS.name();
			}
			if("Y".equalsIgnoreCase(prodTraffic.getToBackType())){
				prodTraffic.setBackType(trafficType);
				prodTraffic.setToType(trafficType);
			}else {
				prodTraffic.setToType(trafficType);
			}
			prodProduct.setCancelFlag("Y");
			//添加产品
			Long productId = prodProductService.addProdProduct(prodProduct);
			prodProduct.setProductId(productId);
			prodTraffic.setProductId(productId);
			prodTrafficService.insert(prodTraffic);
			
			//添加交通信息
			Map<String, Object> attributes = new HashMap<String, Object>();
			attributes.put("productId", prodProduct.getProductId());
			attributes.put("productName", prodProduct.getProductName());
			attributes.put("categoryName", prodProduct.getBizCategory().getCategoryName());
			//添加操作日志
			try {
				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, 
						prodProduct.getProductId(), prodProduct.getProductId(), 
						this.getLoginUser().getUserName(), 
						"添加了产品：【"+prodProduct.getProductName()+"】", 
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
	 * 跳转到修改页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/showUpdateProduct")
	public String showUpdateProduct(Model model, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showUpdateProduct>");
		}
		Long productId = Long.valueOf(req.getParameter("productId"));
		//查询产品
		ProdProduct product =  prodProductService.findProdProductByProductId(productId);
		//查询交通
		ProdTraffic traffic = prodTrafficService.selectByProductId(productId);
		//去程出发城市
		if(traffic.getStartDistrict()!=null){
			traffic.setStartDistrictObj((BizDistrict) MiscUtils.autoUnboxing(districtService.findDistrictById(traffic.getStartDistrict())));
		}
		//去程到达城市
		if(traffic.getEndDistrict()!=null){
			traffic.setEndDistrictObj((BizDistrict) MiscUtils.autoUnboxing(districtService.findDistrictById(traffic.getEndDistrict())));
		}
		//其他机票
		if(product.getBizCategory().getCategoryId() == 21){
			//返程出发城市
			if(traffic.getBackStartDisirict()!=null){
				traffic.setBackStartDisirictObj((BizDistrict) MiscUtils.autoUnboxing(districtService.findDistrictById(traffic.getBackStartDisirict())));
			}
			//返程到达城市
			if(traffic.getBackEndDisirict()!=null){
				traffic.setBackEndDisirictObj((BizDistrict) MiscUtils.autoUnboxing(districtService.findDistrictById(traffic.getBackEndDisirict())));
			}
			//反写老数据时当返程出发地和到达地为空时，对应数据为：去程出发地==返程到达地，去程到达地==返程出发地
			if (traffic.getBackStartDisirict() == null && traffic.getEndDistrict() != null) {
				traffic.setBackStartDisirictObj((BizDistrict) MiscUtils.autoUnboxing(districtService.findDistrictById(traffic.getEndDistrict())));
			}
			if (traffic.getBackEndDisirict() == null && traffic.getStartDistrict() != null) {
				traffic.setBackEndDisirictObj((BizDistrict) MiscUtils.autoUnboxing(districtService.findDistrictById(traffic.getStartDistrict())));
			}
		}
		
		//其它巴士
		if(product.getBizCategory().getCategoryId()==25){
	    	// 类别
		    List<ProdProduct.PRODUCTTYPE> productTypeList = new ArrayList<ProdProduct.PRODUCTTYPE>(Arrays.asList(ProdProduct.PRODUCTTYPE.values()));
		    model.addAttribute("productTypeList", productTypeList);		
	   
		    List<BizCatePropGroup> bizCatePropGroupList = null;
		    ProdProduct prodProduct = null;
	        //获取产品 产品属性
			if (productId != null) {
				Map<String, Object> parameters = new HashMap<String, Object>();
				parameters.put("productId", productId);
				prodProduct = prodProductService.findProdProduct4FrontById(Long.valueOf(productId), Boolean.TRUE, Boolean.TRUE);
				if (prodProduct != null) {
					bizCatePropGroupList = categoryPropGroupService.findCategoryPropGroupsAndCategoryProp(prodProduct.getBizCategory().getCategoryId(), false);
					if (CollectionUtils.isNotEmpty(bizCatePropGroupList)) {
						for (BizCatePropGroup bizCatePropGroup : bizCatePropGroupList) {
							if (CollectionUtils.isNotEmpty(bizCatePropGroup.getBizCategoryPropList())) {
	                            this.fillNormalProp(bizCatePropGroup, req.getParameter("productId"));
							}
						}
					}
					model.addAttribute("bizCatePropGroupList", bizCatePropGroupList);
				}
				 
			}

		}
		
		if(traffic.getBackType()!=null && traffic.getToType()!=null){
			traffic.setToBackType("Y");
		}else {
			traffic.setToBackType("N");
		}
		
		model.addAttribute("categoryName", product.getBizCategory().getCategoryName());
		model.addAttribute("product", product);
		model.addAttribute("traffic", traffic);
		return "/prod/traffic/product/showUpdateProduct";
	}
	
	/**
	 * 更新产品
	 * 
	 * @return
	 */
	@RequestMapping(value = "/updateProduct")
	@ResponseBody
	public Object updateProduct(ProdProduct prodProduct,ProdTraffic prodTraffic, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<updateProduct>");
		}
		if (prodProduct.getBizCategoryId() == null) {
			throw new BusinessException("产品数据错误：无品类");
		}
		if (prodProduct.getProductId() == null) {
			throw new BusinessException("产品数据错误：无产品Id");
		}
		if (prodProduct.getBizCategoryId()!=null) {
			BizCategory category = bizCategoryQueryService.getCategoryById(prodProduct.getBizCategoryId());
			String trafficType = "";
			//设置交通类型
			if("category_traffic_aero_other".equalsIgnoreCase(category.getCategoryCode())){
				trafficType = ProdTraffic.TRAFFICTYPE.FLIGHT.name();
			//火车
			}else if("category_traffic_train_other".equalsIgnoreCase(category.getCategoryCode())){
				trafficType = ProdTraffic.TRAFFICTYPE.TRAIN.name();
			//轮船
			}else if("category_traffic_ship_other".equalsIgnoreCase(category.getCategoryCode())){
				trafficType = ProdTraffic.TRAFFICTYPE.SHIP.name();
			//巴士
			}else if("category_traffic_bus_other".equalsIgnoreCase(category.getCategoryCode())){
				trafficType = ProdTraffic.TRAFFICTYPE.BUS.name();
			}
			if("Y".equalsIgnoreCase(prodTraffic.getToBackType())){
				prodTraffic.setBackType(trafficType);
				prodTraffic.setToType(trafficType);
			}else {
				prodTraffic.setToType(trafficType);
			}
			//添加产品
			prodProductService.updateProdProductProp(prodProduct);
			prodTraffic.setProductId(prodProduct.getProductId());
			if(prodTraffic.getTrafficId() != null) {
				prodTrafficService.updateByPrimaryKey(prodTraffic);
			} else {
				prodTrafficService.insert(prodTraffic);
			}
			//添加操作日志
			try {
				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, 
						prodProduct.getProductId(), prodProduct.getProductId(), 
						this.getLoginUser().getUserName(), 
						"修改了产品：【"+prodProduct.getProductName()+"】", 
						COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name(), 
						"修改产品",null);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
				log.error(e.getMessage());
			}
			
			return new ResultMessage("success", "保存成功");
		}
		return new ResultMessage("error", "修改失败,未选择品类");
	}
	
	//---------------------大交通开始------------------
	
	//查询交通详情
	@RequestMapping(value = "/findTrafficDetailList")
	public Object findTrafficDetailList(Model model,Long prodProductId){
		ProdProduct product =  prodProductService.getProdProductBy(prodProductId);
		model.addAttribute("prodProductId", prodProductId);
		if(product!=null){
	 		BizCategory category = bizCategoryQueryService.getCategoryById(product.getBizCategoryId());
	 		HashMap<String,Object> params = new HashMap<String,Object>();
	 		//飞机
	 		if("category_traffic_aero_other".equalsIgnoreCase(category.getCategoryCode())){
	 			params.clear();
	 			params.put("productId", prodProductId);
	 			List<ProdTrafficGroup> groupList =  prodTrafficGroupService.selectByParams(params);
	 			if(groupList!=null && groupList.size()>0){
	 				for(ProdTrafficGroup group  : groupList){
	 					params.clear();
	 					params.put("groupId", group.getGroupId());
		 				List<ProdTrafficFlight> flightList =  prodTrafficFlightService.selectByParams(params);
		 				group.setProdTrafficFlightList(flightList);
	 				}
	 			}
	 			model.addAttribute("groupList", groupList);
	 			return "/prod/traffic/trafficDetail/findTrafficFlightDetailList";
			//火车
			}else if("category_traffic_train_other".equalsIgnoreCase(category.getCategoryCode())){
				//火车仅有一个Group
				params.clear();
				params.put("productId", prodProductId);
	 			List<ProdTrafficGroup> groupList =  prodTrafficGroupService.selectByParams(params);
	 			if(groupList!=null && groupList.size()>0){
	 				ProdTrafficGroup group = groupList.get(0);
 					params.clear();
 					params.put("groupId", group.getGroupId());
	 				List<ProdTrafficTrain> trainList =  prodTrafficTrainService.selectByParams(params);
	 				group.setProdTrafficTrainList(trainList);
	 				model.addAttribute("group", group);
	 			}
	 			return "/prod/traffic/trafficDetail/findTrafficTrainDetailList";
			//轮船
			}else if("category_traffic_ship_other".equalsIgnoreCase(category.getCategoryCode())){
				params.clear();
				params.put("productId", prodProductId);
	 			List<ProdTrafficGroup> groupList =  prodTrafficGroupService.selectByParams(params);
	 			if(groupList!=null && groupList.size()>0){
	 					ProdTrafficGroup group = groupList.get(0);
	 					params.clear();
	 					params.put("groupId", group.getGroupId());
		 				List<ProdTrafficBus> busList =  prodTrafficBusService.selectByParams(params);
		 				group.setProdTrafficBusList(busList);
		 				model.addAttribute("group", group);
	 			}
	 			model.addAttribute("type", category.getCategoryCode());
	 			model.addAttribute("groupList", groupList);
	 			return "/prod/traffic/trafficDetail/findTrafficBusDetailList";
			//巴士
			}else if("category_traffic_bus_other".equalsIgnoreCase(category.getCategoryCode())){
				params.clear();
				params.put("productId", prodProductId);
	 			List<ProdTrafficGroup> groupList =  prodTrafficGroupService.selectByParams(params);
	 			model.addAttribute("type", category.getCategoryCode());
	 			if(groupList!=null && groupList.size()>0){
	 					ProdTrafficGroup group = groupList.get(0);
	 					params.clear();
	 					params.put("groupId", group.getGroupId());
		 				List<ProdTrafficBus> busList =  prodTrafficBusService.selectByParams(params);
		 				group.setProdTrafficBusList(busList);
		 				model.addAttribute("group", group);
	 			}
	 			return "/prod/traffic/trafficDetail/findTrafficBusDetailList";
			}	
		}
		return "/prod/traffic/trafficDetail/findTrafficDetailList";
	}
	
	
	//跳转到添加交通详情
	@RequestMapping(value = "/showAddTrafficFlightDetail")
	public  Object showAddTrafficFlightDetail(Model model,Long productId){
		ProdTraffic traffic = prodTrafficService.selectByProductId(productId);
		model.addAttribute("traffic", traffic);
		return "/prod/traffic/trafficDetail/showAddTrafficFlightDetail";
	}
	
	
	//跳转到修改交通详情
	@RequestMapping(value = "/showUpdateTrafficFlightDetail")
	public  Object showUpdateTrafficFlightDetail(Model model,Long productId,Long groupId){
		ProdTraffic traffic = prodTrafficService.selectByProductId(productId);
		model.addAttribute("traffic", traffic);
		//查询组
		ProdTrafficGroup rtg =  prodTrafficGroupService.selectByPrimaryKey(groupId);
		//查询列表
		HashMap<String,Object> params = new HashMap<String,Object>();
		params.put("groupId", groupId);
		//把列表分为两个
		List<ProdTrafficFlight> flightList =  prodTrafficFlightService.selectByParams(params);
		rtg.setProdTrafficFlightList(flightList);
		List<ProdTrafficFlight> flightListTo = new ArrayList<ProdTrafficFlight>();
		List<ProdTrafficFlight> flightListBack = new ArrayList<ProdTrafficFlight>();
		if(flightList!=null && flightList.size()>0){
			for(ProdTrafficFlight ptf : flightList){
				if (ptf.getFlightNo() == null ){
					continue;
				}
				if("TO".equalsIgnoreCase(ptf.getTripType())){
					flightListTo.add(ptf);
				}else if("BACK".equalsIgnoreCase(ptf.getTripType())){
					flightListBack.add(ptf);
				}
			}
		}
		model.addAttribute("group", rtg);
		model.addAttribute("flightListTo", flightListTo);
		model.addAttribute("flightListBack", flightListBack);
		return "/prod/traffic/trafficDetail/showUpdateTrafficFlightDetail";
	}
	
	//删除航班
	@RequestMapping(value = "/deleteTrafficFlightDetail")
	@ResponseBody
	public  Object deleteTrafficFlightDetail(Model model,Long flightId){
		try{
			if(flightId!=null)
			prodTrafficFlightService.deleteByPrimaryKey(flightId);
		}catch(Exception e){
			LOG.error(ExceptionFormatUtil.getTrace(e));
		}
		return new ResultMessage("success", "保存成功");
	}
	
	//添加交通详情
	@RequestMapping(value = "/addTrafficFlightDetail")
	@ResponseBody
	public  Object addTrafficFlightDetail(Model model,ProdTrafficGroup prodTrafficGroup){
		if(prodTrafficGroup!=null){
			//首先保存组
			int id =prodTrafficGroupService.insert(prodTrafficGroup);
			prodTrafficGroup.setGroupId((long) id);
			//保存交通信息
			if(prodTrafficGroup.getProdTrafficFlightList()!=null&&prodTrafficGroup.getProdTrafficFlightList().size()>0){
				for(ProdTrafficFlight ptf : prodTrafficGroup.getProdTrafficFlightList()){
					//判断航班是否存在
					HashMap<String,Object> params = new HashMap<String,Object>();
					if(StringUtil.isNotEmptyString(ptf.getFlightNo())){
						params.put("flightNo", ptf.getFlightNo());
						params.put("like", "Y");
						List<BizFlight> flightList = bizFlightService.selectByParams(params);
						if(flightList != null && flightList.size() > 0){
							List<String> flightNoList = new ArrayList<String>();
							for(BizFlight bf : flightList){
								flightNoList.add(bf.getFlightNo());
							}
							if(flightNoList.contains(ptf.getFlightNo())){
								ptf.setGroupId(prodTrafficGroup.getGroupId());
								ptf.setProductId(prodTrafficGroup.getProductId());
								ptf.setCancelFlag("Y");
								prodTrafficFlightService.insert(ptf);
								
							}else{
								return new ResultMessage("error", "航班信息不存在");
							}
						}else{
							return new ResultMessage("error", "航班信息不存在");
						}
					}
				}
			}
		}
		return new ResultMessage("success", "保存成功");
	}
	
		//添加交通详情
		@RequestMapping(value = "/updateTrafficFlightDetail")
		@ResponseBody
		public  Object updateTrafficFlightDetail(Model model,ProdTrafficGroup prodTrafficGroup){
			if(prodTrafficGroup!=null){
				//保存交通信息
				if(prodTrafficGroup.getProdTrafficFlightList() != null && prodTrafficGroup.getProdTrafficFlightList().size() > 0){
					for(ProdTrafficFlight ptf : prodTrafficGroup.getProdTrafficFlightList()){
						//判断航班是否存在
						if(StringUtil.isNotEmptyString(ptf.getFlightNo())){
							HashMap<String,Object> params = new HashMap<String,Object>();
							params.put("flightNo", ptf.getFlightNo());
							params.put("like", "Y");
							List<BizFlight> flightList = bizFlightService.selectByParams(params);
							
							if(flightList != null && flightList.size() > 0){
								List<String> flightNoList = new ArrayList<String>();
								for(BizFlight bf : flightList){
									flightNoList.add(bf.getFlightNo());
								}
								if(flightNoList.contains(ptf.getFlightNo())){
									if(ptf.getFlightId()!=null)
										prodTrafficFlightService.updateByPrimaryKey(ptf);
									else {
										ptf.setGroupId(prodTrafficGroup.getGroupId());
										ptf.setProductId(prodTrafficGroup.getProductId());
										ptf.setCancelFlag("Y");
										prodTrafficFlightService.insert(ptf);
									}
								}else{
									return new ResultMessage("error", "航班信息不存在");
								}
							}else{
								return new ResultMessage("error", "航班信息不存在");
							}
						}
					}
				}
			}
			return new ResultMessage("success", "更新成功");
		}
		
		//更新状态
		@RequestMapping(value = "/updateFlightCancelFlag")
		@ResponseBody
		public  Object updateFlightCancelFlag(Model model,Long groupId,String cancelFlag){
			HashMap<String,Object> params = new HashMap<String,Object>();
			params.put("groupId", groupId);
			List<ProdTrafficFlight> flightList =  prodTrafficFlightService.selectByParams(params);
			if(flightList!=null){
					for(ProdTrafficFlight ptf  : flightList){
						ptf.setCancelFlag(cancelFlag);
						prodTrafficFlightService.updateByPrimaryKey(ptf);
					}
			}
			return new ResultMessage("success", "更新成功");
		}
		
		//---------------------------------火车票详情----------------------------
		
		//跳转到添加火车票详情
		@RequestMapping(value = "/showAddTrafficTrainDetail")
		public  Object showAddTrafficTrainDetail(Model model,Long productId){
			ProdTraffic traffic = prodTrafficService.selectByProductId(productId);
			model.addAttribute("traffic", traffic);
			return "/prod/traffic/trafficDetail/showAddTrafficTrainDetail";
		}
		
		
		//添加火车票详情
		@RequestMapping(value = "/addTrafficTrainDetail")
		@ResponseBody
		public  Object addTrafficTrainDetail(Model model,ProdTrafficGroup prodTrafficGroup){
			if(prodTrafficGroup!=null){
				Long productId = prodTrafficGroup.getProductId();
				//如果已经存在组了
				ProdTrafficGroup currentGroup = null;
				if(prodTrafficGroup.getProductId()!=null){
					HashMap<String,Object> params = new HashMap<String,Object>();
					params.clear();
					params.put("productId", productId);
		 			List<ProdTrafficGroup> groupList =  prodTrafficGroupService.selectByParams(params);
		 			if(groupList!=null && groupList.size()>0){
		 				currentGroup = groupList.get(0);
		 			}
				}
				if(currentGroup==null){
					//首先保存组
					int groupId = prodTrafficGroupService.insert(prodTrafficGroup);
					prodTrafficGroup.setGroupId((long) groupId);
					currentGroup = prodTrafficGroup;
				}
				//保存交通信息
				if(prodTrafficGroup.getProdTrafficTrainList()!=null&&prodTrafficGroup.getProdTrafficTrainList().size()>0){
					for(ProdTrafficTrain ptf : prodTrafficGroup.getProdTrafficTrainList()){
						
						ptf.setGroupId(currentGroup.getGroupId());
						ptf.setProductId(currentGroup.getProductId());
						ptf.setCancelFlag("Y");
						String msg = fillDistrict(ptf);
						if(msg != null) {
							return new ResultMessage("error", msg);
						}
						prodTrafficTrainService.insert(ptf);
					}
				}
			}
			return new ResultMessage("success", "保存成功");
		}

		private String fillDistrict(ProdTrafficTrain ptf) {
			String trainNo = ptf.getTrainNo();
			if(StringUtil.isEmptyString(trainNo)) {
				return "车次不能为空";
			}
			
			ProdTraffic traffic = this.prodTrafficService.selectByProductId(ptf.getProductId());
			Long stationStrat = findStation(trainNo, traffic.getStartDistrict());
			if(stationStrat == null) {
				BizDistrict dist = MiscUtils.autoUnboxing(this.districtService.findDistrictById(traffic.getStartDistrict()));
				return "车次 "+trainNo+" 在"+dist.getDistrictName()+" 没有停留站点";
			}
			ptf.setStartDistrict(stationStrat);
			Long stationEnd = findStation(trainNo, traffic.getEndDistrict());
			if(stationEnd == null) {
				BizDistrict dist = MiscUtils.autoUnboxing(this.districtService.findDistrictById(traffic.getEndDistrict()));
				return "车次 "+trainNo+" 在"+dist.getDistrictName()+" 没有停留站点";
			}
			ptf.setEndDistrict(stationEnd);
			return null;
		}

		private Long findStation(String trainNo, Long district) {
			if(district == null || StringUtils.isEmpty(trainNo)) {
				return null;
			}
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("trainNo", trainNo);
			params.put("districtId", district);
			params.put("cancelFlag", "Y");
			
			List<BizTrainStop> stopList = bizTrainStopService.selectByParams(params);
			if(stopList != null && stopList.size() > 0) {
				return stopList.get(0).getStopStation();
			}
			return null;
		}
		
		//跳转到修改火车详情
		@RequestMapping(value = "/showUpdateTrafficTrainDetail")
		public  Object showUpdateTrafficTrainDetail(Model model,Long productId,Long trainId){
			ProdTraffic traffic = prodTrafficService.selectByProductId(productId);
			model.addAttribute("traffic", traffic);
			ProdTrafficTrain train =  prodTrafficTrainService.selectByPrimaryKey(trainId);
			model.addAttribute("train", train);
			return "/prod/traffic/trafficDetail/showUpdateTrafficTrainDetail";
		}
		
		
		//修改火车票详情
		@RequestMapping(value = "/updateTrafficTrainDetail")
		@ResponseBody
		public  Object updateTrafficTrainDetail(Model model,ProdTrafficTrain prodTrafficTrain){
			if(prodTrafficTrain!=null){
				String msg = fillDistrict(prodTrafficTrain);
				if(msg != null) {
					return new ResultMessage("error", msg);
				}
				prodTrafficTrainService.updateByPrimaryKey(prodTrafficTrain);
			}
			return new ResultMessage("success", "保存成功");
		}
		
		//---------------------------------车船票详情----------------------------
		
		
		//跳转到添加车船票详情
		@RequestMapping(value = "/showAddTrafficBusDetail")
		public  Object showAddTrafficBusDetail(Model model,Long productId){
			ProdTraffic traffic = prodTrafficService.selectByProductId(productId);
			ProdProduct product =  prodProductService.findProdProductByProductId(productId);
			model.addAttribute("type", product.getBizCategory().getCategoryCode());
			model.addAttribute("traffic", traffic);
			return "/prod/traffic/trafficDetail/showAddTrafficBusDetail";
		}
				
				
		//添加火车船详情
		@RequestMapping(value = "/addTrafficBusDetail")
		@ResponseBody
		public  Object addTrafficBusDetail(Model model,ProdTrafficGroup prodTrafficGroup){
			if(prodTrafficGroup!=null){
				//如果已经存在组了
				ProdTrafficGroup currentGroup = null;
				if(prodTrafficGroup.getProductId()!=null){
					HashMap<String,Object> params = new HashMap<String,Object>();
					params.clear();
					params.put("productId", prodTrafficGroup.getProductId());
		 			List<ProdTrafficGroup> groupList =  prodTrafficGroupService.selectByParams(params);
		 			if(groupList!=null && groupList.size()>0){
		 				currentGroup = groupList.get(0);
		 			}
				}
				if(currentGroup==null){
					//首先保存组
					int groupId = prodTrafficGroupService.insert(prodTrafficGroup);
					prodTrafficGroup.setGroupId((long) groupId);
					currentGroup = prodTrafficGroup;
				}
				//保存交通信息
				if(prodTrafficGroup.getProdTrafficBusList()!=null&&prodTrafficGroup.getProdTrafficBusList().size()>0){
					for(ProdTrafficBus ptf : prodTrafficGroup.getProdTrafficBusList()){
						ptf.setGroupId(currentGroup.getGroupId());
						ptf.setProductId(currentGroup.getProductId());
						ptf.setCancelFlag("Y");
						prodTrafficBusService.insert(ptf);
					}
				}
			}
			return new ResultMessage("success", "保存成功");
		}
				
			//跳转到修改车船详情
			@RequestMapping(value = "/showUpdateTrafficBusDetail")
			public  Object showUpdateTrafficBusDetail(Model model,Long productId,Long busId){
				ProdProduct product =  prodProductService.findProdProductByProductId(productId);
				model.addAttribute("type", product.getBizCategory().getCategoryCode());
				ProdTraffic traffic = prodTrafficService.selectByProductId(productId);
				model.addAttribute("traffic", traffic);
				ProdTrafficBus bus =  prodTrafficBusService.selectByPrimaryKey(busId);
				model.addAttribute("bus", bus);
				if(bus!=null&&StringUtils.isNotEmpty(bus.getStartTime())){
					String[] array = bus.getStartTime().split(":");
					if(array.length==2){
						model.addAttribute("hour", array[0]);
						model.addAttribute("minute", array[1]);
					}
				}
				return "/prod/traffic/trafficDetail/showUpdateTrafficBusDetail";
			}
				
				
			//修改车船详情
			@RequestMapping(value = "/updateTrafficBusDetail")
			@ResponseBody
			public  Object updateTrafficBusDetail(Model model,ProdTrafficBus prodTrafficBus){
				if(prodTrafficBus!=null){
					prodTrafficBusService.updateByPrimaryKey(prodTrafficBus);
				}
				return new ResultMessage("success", "保存成功");
			}
			
			@RequestMapping(value = "/deleteTrafficBusDetail")
			@ResponseBody
			public  Object deleteTrafficBusDetail(Model model,Long busId){
				if(busId!=null){
					prodTrafficBusService.deleteByPrimaryKey(busId);
				}
				return new ResultMessage("success", "删除成功");
			}
			
			
			/**
			 * 遍历属性组获取属性
			 * @param bizCatePropGroup
			 * @param productId
			 * @return
			 */
		    private void fillNormalProp(BizCatePropGroup bizCatePropGroup, String productId) {
		        for (BizCategoryProp bizCategoryProp : bizCatePropGroup.getBizCategoryPropList()) {
		            this.fillNormalProp(bizCategoryProp, productId);
		        }
		    }
		    /**
			 * 遍历属性为属性注入属性值
			 * @param bizCatePropGroup
			 * @param productId
			 * @return
			 */
		    private void fillNormalProp(BizCategoryProp bizCategoryProp , String productId) {
		        Map<String, Object> parameters2 = new HashMap<String, Object>();
		        parameters2.put("productId", productId);
		        parameters2.put("propId", bizCategoryProp.getPropId());
		        List<ProdProductProp> prodProductPropList = MiscUtils.autoUnboxing(prodProductPropService.findProdProductPropList(parameters2));
		        bizCategoryProp.setProdProductPropList(prodProductPropList);
		    }
}
