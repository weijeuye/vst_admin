package com.lvmama.vst.back.prod.web.selfTour;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;

import com.lvmama.vst.back.client.prod.service.ProdLineRouteClientService;
import com.lvmama.vst.back.client.prod.service.ProdTrafficClientService;
import com.lvmama.vst.back.prod.po.ProdGroup;
import com.lvmama.vst.back.prod.po.ProdLineRoute;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdVisadocRe;
import com.lvmama.vst.back.prod.service.AssociationRecommendService;
import com.lvmama.vst.back.prod.service.ProdGroupService;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.prod.service.ProdVisadocReService;
import com.lvmama.vst.back.utils.TimeLog;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 产品管理Action
 * 
 * @author qiujiehong
 * @date 2013-10-11
 */
@Controller
@RequestMapping("/selfTour/prod/product/flighthotel")
public class SelfTourFlightHotelProductAction extends BaseActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 3265205148436720342L;

	private static final Log LOG = LogFactory.getLog(SelfTourFlightHotelProductAction.class);
	
	@Autowired
	private ProdProductService prodProductService;
	
	@Autowired
	private ProdLineRouteClientService prodLineRouteService;

	@Autowired
	private ProdVisadocReService prodVisadocReService;
	
	@Autowired
	private ProdTrafficClientService prodTrafficService;
	
	@Autowired
	private AssociationRecommendService associationRecommendService;
	/**
	 * 最多关联产品的大小
	 */
	private static final String PROD_GROUP_MAX_SIZE ="prodGroupMaxSize";
	private static final short PROD_GROUP_MAX_SUM =10;
	private static final String PROD_GROUP_MESSAGE_EXISTS ="维护产品已被其它产品进行关联,请先取消";
	@Autowired
	private ProdGroupService prodGroupService;
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
		return "/prod/selfTour/product/flighthotel/findProdGroupList";
	}
	
	/**
	 * 获取关联产品的最大数目
	 * @return int
	 */
	private static int getNewProdGroupMaxSize(){
		Short size =PROD_GROUP_MAX_SUM;
		Assert.notNull(size, PROD_GROUP_MAX_SIZE +" not is null");
		return Integer.valueOf(size);
	}
	
	private boolean isEqual(Long long1, Long long2){
		return long1.intValue() == long2.intValue();
	}
	
	/**
	 * 跳转到产品维护页面
	 * 
	 * @param model
	 * @param productId
	 * @return
	 */
	@RequestMapping(value = "/showProductMaintain")
	public String showProductMaintain(Model model, Long productId, String categoryName,Long categoryId,String isView,Long subCategoryId) throws BusinessException {
		model.addAttribute("categoryId", categoryId);
		model.addAttribute("subCategoryId", subCategoryId);
		model.addAttribute("categoryName", categoryName);
		model.addAttribute("productId", productId);
		model.addAttribute("isView", isView);
		if (productId != null) {
			ProdProduct prodProduct = prodProductService.findProdProduct4FrontById(Long.valueOf(productId), Boolean.TRUE, Boolean.TRUE);
			//vst组织鉴权
			super.vstOrgAuthentication(LOG, prodProduct.getManagerIdPerm());
			
			model.addAttribute("productName", prodProduct.getProductName());
			model.addAttribute("categoryId", prodProduct.getBizCategoryId());
			model.addAttribute("categoryName", prodProduct.getBizCategory().getCategoryName());
			model.addAttribute("productType", prodProduct.getProductType());
			model.addAttribute("packageType", prodProduct.getPackageType());
			model.addAttribute("subCategoryId", prodProduct.getSubCategoryId());
			//校验行程
			List<ProdLineRoute> lineRouteList= checkRoute(productId);
			String routeFlag="false";
			if(lineRouteList!=null&&lineRouteList.size()>=1){
				routeFlag="true";
			}
			model.addAttribute("routeFlag", routeFlag);
			
			//校验交通信息是否已经填写
			Boolean saveTransportFlag = prodTrafficService.checkTrafficDetial(productId);
			model.addAttribute("saveTransportFlag", saveTransportFlag.toString());
			
			model.addAttribute("productType", prodProduct.getProductType());
			//出境-需要校验签证材料
			if("FOREIGNLINE".equals(prodProduct.getProductType())){
				String visaDocFlag=checkvisaDoc( productId);
				model.addAttribute("visaDocFlag", visaDocFlag);
			}
			
			String bu = associationRecommendService
					.getBuOfProduct(productId, prodProduct.getBu(), categoryId,
							prodProduct.getPackageType());
			model.addAttribute("bu", bu);
				
			// 供应商打包的不显示视频添加
			if(prodProduct.getPackageType().equalsIgnoreCase("LVMAMA")){
				model.addAttribute("productBU", prodProduct.getBu());
			}
		} else {
			model.addAttribute("productName", null);
		}
		
		
		return "/prod/selfTour/product/flighthotel/showProductMaintain";
	}
	
	/**
	 * 关联产品查询页面
	 */
	@RequestMapping(value = "/showSelectReProductList")
	public String showSelectReProductList(Model model,Long prodProductId, Long categoryId){
		model.addAttribute("prodProductId", prodProductId);
		model.addAttribute("categoryId", categoryId);
		return "/prod/selfTour/product/flighthotel/showSelectReProductList";
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
		
		//行程校验
		private List<ProdLineRoute> checkRoute(Long productId)throws BusinessException {
			Map<String,Object> pars = new HashMap<String, Object>();
			pars.put("productId", productId);
			pars.put("cancleFlag", "Y");
			List<ProdLineRoute> prodRouteList=  prodLineRouteService.findProdLineRouteByParams(pars);
			return prodRouteList;
		}
}
