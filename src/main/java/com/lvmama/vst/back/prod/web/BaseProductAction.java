package com.lvmama.vst.back.prod.web;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.po.BizEnum;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.client.biz.service.CategoryClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 产品管理router 产品的添加，修改都要在此处做中转
 * 
 * @author mayonghua
 *
 */
@Controller
@RequestMapping("/prod/baseProduct")
public class BaseProductAction {

	@Autowired
	private CategoryClientService categoryService;

	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;
	@Autowired
	private ProdProductClientService prodProductService;
	
	private static String SHIP_BACK_LOCATION="http://super.lvmama.com/ship_back";
	private final static String SHIP_BACK_LOCATION_MEM_KEY="SHIP_BACK_LOCATION_MEM_KEY";
	
	private static String VISA_PROD_LOCATION = "http://super.lvmama.com/visa_prod";
	
	private String SCENIC_TICKET_LOCATION="http://super.lvmama.com/scenic_back";
	
	private String VST_ADMIN_LOCATION="http://super.lvmama.com/vst_back";
	
	private final String DEST_HOTEL_LOCATION="http://super.lvmama.com/lvmm_dest_back";
	

	/**
	 * 切换邮轮location
	 * 
	 * @return
	 */
	@RequestMapping("/switchShipLocation")
	@ResponseBody
	public  String switchShipLocation() {
		String location = MemcachedUtil.getInstance().get(SHIP_BACK_LOCATION_MEM_KEY);
		if( null == location || location.length() == 0 ){
			SHIP_BACK_LOCATION="http://super.lvmama.com/ship_back";
		} else {
			SHIP_BACK_LOCATION = "";
		}
		MemcachedUtil.getInstance().set(SHIP_BACK_LOCATION_MEM_KEY,SHIP_BACK_LOCATION);
		return "ship location："+SHIP_BACK_LOCATION;
	}

	@RequestMapping("/switchVisaLocation")
	@ResponseBody
	public String switchVisaLocation() {
		if (StringUtils.isEmpty(VISA_PROD_LOCATION)) {
			VISA_PROD_LOCATION = "http://super.lvmama.com/visa_prod";
			return VISA_PROD_LOCATION;
		}
		VISA_PROD_LOCATION = "";

		return "super.lvmama.com/vst_admin";
	}
	
	/**
	 * 未实现的产品跳转提示页面
	 * 
	 * @return
	 */
	@RequestMapping("/productNoRealize")
	public String productNoRealize() {

		return "/prod/product/productNoRealize";
	}

	/**
	 * 产品预览
	 * 
	 * @return
	 */
	@RequestMapping("/preview")
	public String productPreview(Long categoryId, String previewId) {
		String url = prodProductService.findProductUrl(categoryId, previewId, true);
		return "redirect:" + url;
	}

	/**
	 * 跳转到新增供應商打包
	 * 
	 * @param model
	 * @param categoryId
	 * @return
	 */
	@RequestMapping("/toSupplierAddProduct")
	public ModelAndView addNewProduct(Model model, Long categoryId) {
		if (categoryId == null) {
			throw new BusinessException("品类ID无效");
		}
		BizCategory category = bizCategoryQueryService.getCategoryById(categoryId);
		if (category == null) {
			throw new BusinessException("品类不存在");
		}
		if (BizEnum.BIZ_CATEGORY_TYPE.category_route_group.name().equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin" + "/dujia/group/product/showProductMaintain.do?categoryId=" + categoryId);
		} else if (BizEnum.BIZ_CATEGORY_TYPE.category_comb_cruise.name().equalsIgnoreCase(category.getCategoryCode())) {

			/**
			 * 邮轮组合产品跳转到ship_back
			 */
			return new ModelAndView("redirect:"+SHIP_BACK_LOCATION+"/compship/prod/product/showProductMaintain.do?categoryId=" + categoryId);
			
		} else if (BizEnum.BIZ_CATEGORY_TYPE.category_route_customized.name().equalsIgnoreCase(category.getCategoryCode())){//定制游
            return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin"  + "/customized/group/product/showProductMaintain.do?categoryId="+categoryId);
        } else {
			// throw new BusinessException("未设置跳转地址");
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin"   + "/prod/baseinfo/productNoRealize.do");
		}
	}

	/**
	 * 跳转到新增
	 * 
	 * @param model
	 * @param categoryId
	 * @return
	 */
	@RequestMapping(value = "/toAddProduct")
	public ModelAndView addProduct(Model model, Long categoryId, Long subCategoryId) {
		if (categoryId == null) {
			throw new BusinessException("品类ID无效");
		}
		BizCategory category = bizCategoryQueryService.getCategoryById(categoryId);
		if (category == null) {
			throw new BusinessException("品类不存在");
		}

		// 酒店品类
		if ("category_hotel".equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + VST_ADMIN_LOCATION + "/prod/product/showProductMaintain.do?categoryId=" + categoryId);
			// 邮轮品类
		} else if ("category_cruise".equalsIgnoreCase(category.getCategoryCode())) {
			/**
			 * 邮轮品类跳转到ship_back
			 */
			return new ModelAndView("redirect:"+SHIP_BACK_LOCATION+"/ship/prod/product/showProductMaintain.do?categoryId=" + categoryId);
			// 签证品类
		} else if ("category_visa".equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:"+VISA_PROD_LOCATION+"/visa/product/showProductMaintain.do?categoryId=" + categoryId);
			// 岸上观光
		} else if ("category_sightseeing".equalsIgnoreCase(category.getCategoryCode())) {
			/**
			 * 岸上观光跳转到ship_back
			 */
			return new ModelAndView("redirect:"+SHIP_BACK_LOCATION+"/prod/shoreExcursions/showProductMaintain.do?categoryId=" + categoryId);
			// 邮轮组合产品
		} else if ("category_comb_cruise".equalsIgnoreCase(category.getCategoryCode())) {
			/**
			 * 邮轮组合产品跳转到ship_back
			 */
			return new ModelAndView("redirect:"+SHIP_BACK_LOCATION+"/prod/compship/baseinfo/toCruiseCombPage.do?categoryId=" + categoryId);

			// 邮轮附加项
		} else if ("category_cruise_addition".equalsIgnoreCase(category.getCategoryCode())) {
			/**
			 * 邮轮附加项跳转到ship_back
			 */
			return new ModelAndView("redirect:"+SHIP_BACK_LOCATION+"/prod/shipAddition/showProductMaintain.do?categoryId=" + categoryId);
			// 跟团游
		} else if (BizEnum.BIZ_CATEGORY_TYPE.category_route_group.name().equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin" + "/packageTour/prod/product/showProductMaintain.do?categoryId=" + categoryId);
			// 自由行
		} else if (BizEnum.BIZ_CATEGORY_TYPE.isCategoryTrafficRouteFreedom(category.getCategoryCode())) {
			if (subCategoryId != null) {
				BizCategory subCategory = bizCategoryQueryService.getCategoryById(subCategoryId);
				if (subCategory == null) {
					throw new BusinessException("子品类不存在");
				}
				return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin" + "/selfTour/prod/product/showProductMaintain.do?categoryId=" + categoryId + "&subCategoryId=" + subCategoryId);
			}
			// 当地游
		} else if (BizEnum.BIZ_CATEGORY_TYPE.category_route_local.name().equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin" + "/localTour/prod/product/showProductMaintain.do?categoryId=" + categoryId);
			// 酒店套餐
		} else if (BizEnum.BIZ_CATEGORY_TYPE.category_route_hotelcomb.name().equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin" + "/hotelPackage/prod/product/showProductMaintain.do?categoryId=" + categoryId);
			// 酒套餐
		} else if (BizEnum.BIZ_CATEGORY_TYPE.category_route_new_hotelcomb.name().equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + VST_ADMIN_LOCATION + "/hotelcomb/prod/product/showProductMaintain.do?categoryId=" + categoryId);
			// 景点门票
		} else if (BizEnum.BIZ_CATEGORY_TYPE.category_single_ticket.name().equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:"+SCENIC_TICKET_LOCATION+"/singleTicket/prod/product/showProductMaintain.do?categoryId=" + categoryId);
		} else if (BizEnum.BIZ_CATEGORY_TYPE.category_other_ticket.name().equalsIgnoreCase(category.getCategoryCode())) {
            return new ModelAndView("redirect:"+SCENIC_TICKET_LOCATION+"/otherTicket/prod/product/showProductMaintain.do?categoryId="+categoryId);
            //组合套餐票
		} else if (BizEnum.BIZ_CATEGORY_TYPE.category_show_ticket.name().equalsIgnoreCase(category.getCategoryCode())) {
            // 演出票
            return new ModelAndView("redirect:"+SCENIC_TICKET_LOCATION+"/showTicket/prod/product/showProductMaintain.do?categoryId=" + categoryId);
			// 组合套餐票
		} else if ("category_comb_ticket".equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:"+SCENIC_TICKET_LOCATION+"/combTicket/prod/product/showProductMaintain.do?categoryId=" + categoryId);
			// 保险
		} else if ("category_insurance".equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + VST_ADMIN_LOCATION + "/insurance/prod/product/showProductMaintain.do?categoryId=" + categoryId);
			// 飞机
		} else if ("category_traffic_aero_other".equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin"  + "/prod/traffic/showProductMaintain.do?categoryId=" + categoryId);
			// 火车
		} else if ("category_traffic_train_other".equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin"  + "/prod/traffic/showProductMaintain.do?categoryId=" + categoryId);
			// 轮船
		} else if ("category_traffic_ship_other".equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin"  + "/prod/traffic/showProductMaintain.do?categoryId=" + categoryId);
			// 巴士
		} else if ("category_traffic_bus_other".equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin"  + "/prod/traffic/showProductMaintain.do?categoryId=" + categoryId);
			// wifi
		} else if ("category_wifi".equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:"+SCENIC_TICKET_LOCATION+"/prod/wifi/showProductMaintain.do?categoryId=" + categoryId);
			//交通接驳
		}else if("category_connects".equalsIgnoreCase(category.getCategoryCode())){
				return new ModelAndView("redirect:"+SCENIC_TICKET_LOCATION+"/connects/prod/product/showProductMaintain.do?categoryId="+categoryId);
			//其它	
		} else if ("category_other".equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin" + "/other/prod/product/showProductMaintain.do?categoryId=" + categoryId);
			//定制游
		} else if (BizEnum.BIZ_CATEGORY_TYPE.category_route_customized.name().equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin"  + "/customized/packageTour/product/showProductMaintain.do?categoryId=" + categoryId);
			//购物
		}else if(BizEnum.BIZ_CATEGORY_TYPE.category_shop.name().equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:"+SCENIC_TICKET_LOCATION+"/shop/prod/product/showProductMaintain.do?categoryId=" + categoryId);
			//美食
		}else if(BizEnum.BIZ_CATEGORY_TYPE.category_food.name().equalsIgnoreCase(category.getCategoryCode())){
			return new ModelAndView("redirect:"+SCENIC_TICKET_LOCATION+"/food/prod/product/showProductMaintain.do?categoryId=" + categoryId);
			//娱乐
		}else if(BizEnum.BIZ_CATEGORY_TYPE.category_sport.name().equalsIgnoreCase(category.getCategoryCode())){
			return new ModelAndView("redirect:"+SCENIC_TICKET_LOCATION+"/sport/prod/product/showProductMaintain.do?categoryId=" + categoryId);
			//金融
		}else if(BizEnum.BIZ_CATEGORY_TYPE.category_finance.name().equalsIgnoreCase(category.getCategoryCode())){
			return new ModelAndView("redirect:"+ "http://super.lvmama.com/vst_admin" +"/finance/prod/product/showProductMaintain.do?categoryId=" + categoryId);
			//超级会员
		}else if(BizEnum.BIZ_CATEGORY_TYPE.category_supermember.name().equalsIgnoreCase(category.getCategoryCode())){
			return new ModelAndView("redirect:"+ "http://super.lvmama.com/vst_admin" +"/supermember/prod/product/showProductMaintain.do?categoryId=" + categoryId);
		}
		// throw new BusinessException("未设置跳转地址");
		return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin"   + "/prod/baseProduct/productNoRealize.do");
	}

	/**
	 * 跳转到供應商打包修改
	 * 
	 * @param model
	 * @param categoryId
	 * @param productId
	 * @param categoryName
	 * @param isView
	 * @return
	 */
	@RequestMapping(value = "/toUpdateSupplierProduct")
	public ModelAndView updateNewProduct(Model model, Long categoryId, Long productId, String categoryName, String isView) {
		if (categoryId == null) {
			throw new BusinessException("品类ID无效");
		}
		BizCategory category = bizCategoryQueryService.getCategoryById(categoryId);
		if (category == null) {
			throw new BusinessException("品类不存在");
		}
		if (BizEnum.BIZ_CATEGORY_TYPE.category_route_group.name().equalsIgnoreCase(category.getCategoryCode())) {
			//return new ModelAndView("redirect:" + VST_ADMIN_LOCATION + "/dujia/group/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin" + "/dujia/group/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			//return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin" + "/packageTour/prod/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
		} else if (BizEnum.BIZ_CATEGORY_TYPE.category_comb_cruise.name().equalsIgnoreCase(category.getCategoryCode())) {
			/**
			 * 邮轮组合产品跳转到ship_back
			 */
			return new ModelAndView("redirect:"+SHIP_BACK_LOCATION+"/compship/prod/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
		} else if (BizEnum.BIZ_CATEGORY_TYPE.category_route_customized.name().equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin"  + "/customized/group/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
		}  
		else {
			throw new BusinessException("未设置跳转地址");
		}
	}

	/**
	 * 跳转到修改
	 * 
	 * @param model
	 * @param categoryId
	 * @param productId
	 * @param categoryName
	 * @return
	 */
	@RequestMapping(value = "/toUpdateProduct")
	public ModelAndView updateProduct(Model model, Long categoryId, Long productId, String categoryName, String isView, String packageType) {
		if(categoryId == null){
			throw new BusinessException("品类ID无效");
		}
		BizCategory category= bizCategoryQueryService.getCategoryById(categoryId);
		if(category == null){
			throw new BusinessException("品类不存在");
		}
		// 酒店品类
		if ("category_hotel".equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + DEST_HOTEL_LOCATION + "/prod/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			// 邮轮品类
		} else if ("category_cruise".equalsIgnoreCase(category.getCategoryCode())) {
			/**
			 * 邮轮品类跳转到ship_back
			 */
			return new ModelAndView("redirect:"+SHIP_BACK_LOCATION+"/ship/prod/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			// 签证品类
		} else if ("category_visa".equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:"+VISA_PROD_LOCATION+"/visa/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			// 岸上观光
		} else if ("category_sightseeing".equalsIgnoreCase(category.getCategoryCode())) {
			/**
			 * 岸上观光跳转到ship_back
			 */
			return new ModelAndView("redirect:"+SHIP_BACK_LOCATION+"/prod/shoreExcursions/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&isView=" + isView + "&categoryName=" + categoryName);
			// 邮轮组合产品 自主打包
		} else if ("category_comb_cruise".equalsIgnoreCase(category.getCategoryCode()) && !ProdProduct.PACKAGETYPE.SUPPLIER.name().equals(packageType)) {
			/**
			 * 邮轮组合产品跳转到ship_back
			 */
			return new ModelAndView("redirect:"+SHIP_BACK_LOCATION+"/prod/compship/baseinfo/toCruiseCombPage.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			// 邮轮组合产品 自主打包邮轮组合产品 供应商打包
		} else if ("category_comb_cruise".equalsIgnoreCase(category.getCategoryCode()) && ProdProduct.PACKAGETYPE.SUPPLIER.name().equals(packageType)) {
			/**
			 * 邮轮组合产品跳转到ship_back
			 */
			return new ModelAndView("redirect:"+SHIP_BACK_LOCATION+"/compship/prod/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			// 邮轮附加项
		} else if ("category_cruise_addition".equalsIgnoreCase(category.getCategoryCode())) {
			/**
			 * 邮轮附加项跳转到ship_back
			 */
			return new ModelAndView("redirect:"+SHIP_BACK_LOCATION+"/prod/shipAddition/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			// 景点门票
		} else if ("category_single_ticket".equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:"+SCENIC_TICKET_LOCATION+"/singleTicket/prod/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);

		} else if ("category_other_ticket".equalsIgnoreCase(category.getCategoryCode())) {
            // 其它票
            return new ModelAndView("redirect:"+SCENIC_TICKET_LOCATION+"/otherTicket/prod/product/showProductMaintain.do?categoryId="+categoryId+"&productId="+productId+"&categoryName="+categoryName+"&isView="+isView);
		} else if (BizEnum.BIZ_CATEGORY_TYPE.category_show_ticket.getCode().equalsIgnoreCase(category.getCategoryCode())) {
            //演出票
            return new ModelAndView("redirect:"+SCENIC_TICKET_LOCATION+"/showTicket/prod/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			// 组合套餐票
		} else if ("category_comb_ticket".equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:"+SCENIC_TICKET_LOCATION+"/combTicket/prod/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			// 跟团游
		} else if (BizEnum.BIZ_CATEGORY_TYPE.category_route_group.name().equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin" + "/packageTour/prod/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			// 自由行
		} else if (BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.name().equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin" + "/selfTour/prod/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			// 机+酒
		} else if (BizEnum.BIZ_CATEGORY_TYPE.category_route_aero_hotel.name().equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin" + "/selfTour/prod/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			// 当地游
		} else if (BizEnum.BIZ_CATEGORY_TYPE.category_route_local.name().equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin" + "/localTour/prod/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			// 酒店套餐
		} else if (BizEnum.BIZ_CATEGORY_TYPE.category_route_hotelcomb.name().equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin" + "/hotelPackage/prod/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			// 酒套餐
		} else if (BizEnum.BIZ_CATEGORY_TYPE.category_route_new_hotelcomb.name().equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + VST_ADMIN_LOCATION + "/hotelcomb/prod/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			//交通接驳
		}else if("category_connects".equalsIgnoreCase(category.getCategoryCode())){
			return new ModelAndView("redirect:"+SCENIC_TICKET_LOCATION+"/connects/prod/product/showProductMaintain.do?categoryId="+categoryId+"&productId="+productId+"&categoryName="+categoryName+"&isView="+isView);
			// 保险
		}else if (BizEnum.BIZ_CATEGORY_TYPE.category_insurance.name().equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + VST_ADMIN_LOCATION + "/insurance/prod/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
		} // 飞机
		else if ("category_traffic_aero_other".equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin" + "/prod/traffic/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			// 火车
		} else if ("category_traffic_train_other".equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin"  + "/prod/traffic/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			// 轮船
		} else if ("category_traffic_ship_other".equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin"  + "/prod/traffic/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			// 巴士
		} else if ("category_traffic_bus_other".equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin"  + "/prod/traffic/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			// 保险
		} else if ("category_other".equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin" + "/other/prod/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
		} else if ("category_wifi".equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:"+SCENIC_TICKET_LOCATION+"/prod/wifi/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			//定制游
		} else if (BizEnum.BIZ_CATEGORY_TYPE.category_route_customized.name().equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:" + "http://super.lvmama.com/vst_admin"  + "/customized/packageTour/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			//购物
		} else if(BizEnum.BIZ_CATEGORY_TYPE.category_shop.name().equalsIgnoreCase(category.getCategoryCode())) {
			return new ModelAndView("redirect:"+SCENIC_TICKET_LOCATION+"/shop/prod/product/showProductMaintain.do?categoryId=" + categoryId+ "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			//美食
		}else if(BizEnum.BIZ_CATEGORY_TYPE.category_food.name().equalsIgnoreCase(category.getCategoryCode())){
			return new ModelAndView("redirect:"+SCENIC_TICKET_LOCATION+"/food/prod/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			//娱乐
		}else if(BizEnum.BIZ_CATEGORY_TYPE.category_sport.name().equalsIgnoreCase(category.getCategoryCode())){
			return new ModelAndView("redirect:"+SCENIC_TICKET_LOCATION+"/sport/prod/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			//金融
		}else if(BizEnum.BIZ_CATEGORY_TYPE.category_finance.name().equalsIgnoreCase(category.getCategoryCode())){
			return new ModelAndView("redirect:"+ "http://super.lvmama.com/vst_admin" +"/finance/prod/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
			//超级会员
		}else if(BizEnum.BIZ_CATEGORY_TYPE.category_supermember.name().equalsIgnoreCase(category.getCategoryCode())){
			return new ModelAndView("redirect:"+ "http://super.lvmama.com/vst_admin" +"/supermember/prod/product/showProductMaintain.do?categoryId=" + categoryId + "&productId=" + productId + "&categoryName=" + categoryName + "&isView=" + isView);
		}
		throw new BusinessException("未设置跳转地址");
	}

}
