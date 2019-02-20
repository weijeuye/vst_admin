package com.lvmama.vst.back.prod.scenicHotel;

import java.util.List;
import java.util.Arrays;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.StringTrimmerEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.client.prod.service.ProdLineRouteClientService;
import com.lvmama.vst.back.dujia.comm.prod.po.ProdProductDescription;
import com.lvmama.vst.back.dujia.comm.route.po.ProdLineRouteDescription;
import com.lvmama.vst.back.prod.po.ProdLineRoute;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.prod.po.ScenicHotelCostAllVo;
import com.lvmama.vst.back.prod.po.ScenicHotelCostExcludeVo;
import com.lvmama.vst.back.prod.po.ScenicHotelCostIncludeVo;
import com.lvmama.vst.back.prod.po.ScenicHotelTravelAlertVo;
import com.lvmama.vst.back.prod.po.ScenicHotel_HotelVo;
import com.lvmama.vst.back.prod.po.ScenicHotel_ScenicGoodsVo;
import com.lvmama.vst.back.prod.po.ScenicHotel_ScenicVo;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.Pair;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;

@Controller
@RequestMapping(value="/scenicHotel")
public class ScenicHotelStructuringAction extends BaseActionSupport{
	private static final long serialVersionUID = -6095261576115739363L;
	
	@InitBinder/* Converts empty strings into null when a form is submitted */
	public void initBinder(WebDataBinder binder) {
		binder.registerCustomEditor(String.class, new StringTrimmerEditor(true));
	}
	
	@Autowired
	private ScenicHotelStructuringService scenicHotelStructuringService;
	
	@Autowired
	private ProdLineRouteClientService prodLineRouteService;
	
	@Autowired
	private ProdProductService prodProductService;
	
	
	@RequestMapping(value="loadCost")
	public String loadCost(Model model, Long productId, String productType, Long lineRouteId, @RequestParam(required=false)String embedFlag) {
		ProdProduct prod = prodProductService
				.findProdProductByProductId(productId);
		Long categoryId = prod.getBizCategoryId();
		Map<String, Object> result = scenicHotelStructuringService.loadCost(productId, productType, lineRouteId,categoryId);
		Map<String, List<Pair<String, ScenicHotelCostIncludeVo.Item >>> map = scenicHotelStructuringService.loadPackagedProuctName(productId);
		
		//处理是否有变化
		ScenicHotelCostIncludeVo costIncludeInnerVO = (ScenicHotelCostIncludeVo)result.get("scenicHotelCostIncludeVo");
		scenicHotelStructuringService.judgeCostChangeState(costIncludeInnerVO, map);
		
		model.addAllAttributes(result);

		model.addAttribute("map", map);
		model.addAttribute("embedFlag", "Y".equals(embedFlag)?embedFlag: "N");
		
		//add routeInfo
		ProdLineRoute  lineRoute = MiscUtils.autoUnboxing( prodLineRouteService.findByProdLineRouteId(lineRouteId) );
		model.addAttribute("lineRoute", lineRoute );
		return "prod/packageTour/scenicHotel/scenicHotelCost";
	}
	
	
	
	@RequestMapping(value="saveCost")
	@ResponseBody
	public ResultMessage saveCost(ScenicHotelCostAllVo scenicHotelCostAllVo) {
		//费用包含说明VO
		ScenicHotelCostIncludeVo costIncludeInnerVO = scenicHotelCostAllVo.getScenicHotelCostIncludeVo();
		//费用不包含说明VO
		ScenicHotelCostExcludeVo costExcludeInnerVO = scenicHotelCostAllVo.getScenicHotelCostExcludeVo();
		//产品基本信息
		ProdLineRouteDescription prodLineRouteDescription = scenicHotelCostAllVo.getProdLineRouteDescription();
		if(costIncludeInnerVO == null) {
			costIncludeInnerVO = new ScenicHotelCostIncludeVo();
			costIncludeInnerVO.setHotel(new ScenicHotelCostIncludeVo.Item());
			costIncludeInnerVO.setTicket(new ScenicHotelCostIncludeVo.Item());
		}
		
		if(costExcludeInnerVO ==null){
			costExcludeInnerVO = new ScenicHotelCostExcludeVo();
		}
		
		
		if(prodLineRouteDescription == null || prodLineRouteDescription.getProductId() == null || prodLineRouteDescription.getProductType() == null 
				|| prodLineRouteDescription.getLineRouteId() == null ) {
			return new ResultMessage(ResultMessage.ERROR, "产品id, 产品类型，行程id必须都提供");
		}
		
		char presentItem = costExcludeInnerVO.getPresentItem();
		char securityItem = costExcludeInnerVO.getSecurityItem();
		char selfPayItem = costExcludeInnerVO.getSelfPayItem();
		
		if (presentItem=='\0') {
			costExcludeInnerVO.setPresentItem('N');
		}
		if (securityItem=='\0') {
			costExcludeInnerVO.setSecurityItem('N');
		}
		if (selfPayItem=='\0') {
			costExcludeInnerVO.setSelfPayItem('N');
		}
		String currentUserName = this.getLoginUser().getUserName();
		boolean isOK = scenicHotelStructuringService.saveCost(costIncludeInnerVO, costExcludeInnerVO, 
				prodLineRouteDescription, currentUserName);
		if(isOK) {
			return new ResultMessage(ResultMessage.SUCCESS, "保存成功");
		}  else {
			return new ResultMessage(ResultMessage.ERROR, "保存失败请联系管理员");
		}
	}

	
	@RequestMapping(value="loadTravelAlert")
	public String loadTravelAlert(Model model, Long productId, String productType, @RequestParam(required=false) String embedFlag) {
		if(productId == null) {
			throw new RuntimeException("productId can't be null");
		}
		
		model.addAttribute("embedFlag", "Y".equals(embedFlag)? embedFlag : "N");
		
		Map<String, Object>  travelAlert = scenicHotelStructuringService.loadTravelAlert(productId, productType);
		boolean isSupplierPackaged = (Boolean)travelAlert.get("isSupplierPackaged");
		ScenicHotelTravelAlertVo existed = (ScenicHotelTravelAlertVo)travelAlert.get("travelAlertInnerVO");
		ScenicHotelTravelAlertVo merged = null;
		
		//自主打包， 执行真正的merge动作
		if(!isSupplierPackaged) {
			ScenicHotelTravelAlertVo  packaged = scenicHotelStructuringService.loadPackagedProcuctForTravelAlert(productId);
			merged = scenicHotelStructuringService.mergeTravelAlertVo(existed, packaged);
		} else {
			//供应商打包， 如果已经保存过， 那么直接显示， 否则创建一个空的对象
			if(existed != null) { //要么有历史数据， 要么保存过
				merged = existed;
			} else {
				merged = new ScenicHotelTravelAlertVo();
			}
			
			if(merged.getHotelList() == null || merged.getHotelList().isEmpty()) {
				ScenicHotel_HotelVo hotelVo = new ScenicHotel_HotelVo();
				merged.setHotelList(Arrays.asList(hotelVo));
			}
			
			if(merged.getTicketList() == null || merged.getTicketList().isEmpty()) {
				ScenicHotel_ScenicVo scenicVo = new ScenicHotel_ScenicVo();
				ScenicHotel_ScenicGoodsVo scenicGoodsVo = new ScenicHotel_ScenicGoodsVo();
				scenicVo.setGoodsList(Arrays.asList(scenicGoodsVo));
				merged.setTicketList(Arrays.asList(scenicVo));
			}
		}
		
		model.addAttribute("traveAlertVo", merged) ;
		ProdProductDescription productDescription = (ProdProductDescription)travelAlert.get("productDescription");
		model.addAttribute("productDesc", productDescription) ;
		model.addAttribute("modelVersion", travelAlert.get("modelVersion"));
		model.addAttribute("isSupplierPackaged", isSupplierPackaged);
		if(isSupplierPackaged) {
			model.addAttribute("hotel_index", merged.getHotelList().size() -1);
			model.addAttribute("ticket_index", merged.getTicketList().size() -1 );
			return  "prod/packageTour/scenicHotel/scenicHotelTravelAlert_supplier";
		} else {
			return  "prod/packageTour/scenicHotel/scenicHotelTravelAlert_lvmama";
		}
	}
	
	@RequestMapping(value="saveTravelAlert")
	@ResponseBody
	public ResultMessage saveTravelAlert(ScenicHotelTravelAlertWrapperVo wrapperVo) {
		//检查是否需要更新modelVersion
		scenicHotelStructuringService.saveTravelAlert(wrapperVo.getTravelAlert(), wrapperVo.getProductDesc(), wrapperVo.getModelVersion(), this.getLoginUser().getUserName());	
		ResultMessage result = new ResultMessage(ResultMessage.SUCCESS, "保存成功");
		return result;
	}
}
