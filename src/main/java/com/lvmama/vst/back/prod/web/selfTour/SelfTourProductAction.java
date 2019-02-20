package com.lvmama.vst.back.prod.web.selfTour;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.lvmama.vst.back.client.prod.service.ProdLineRouteClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.client.prod.service.ProdTrafficClientService;
import com.lvmama.vst.back.prod.po.ProdLineRoute;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdVisadocRe;
import com.lvmama.vst.back.prod.service.AssociationRecommendService;
import com.lvmama.vst.back.prod.service.ProdVisadocReService;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 产品管理Action
 * 
 * @author qiujiehong
 * @date 2013-10-11
 */
@Controller
@RequestMapping("/selfTour/prod/product")
public class SelfTourProductAction extends BaseActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 8116600416992961434L;

	private static final Log LOG = LogFactory.getLog(SelfTourProductAction.class);

	@Autowired
	private ProdProductClientService prodProductService;
	

	@Autowired
	private ProdLineRouteClientService prodLineRouteService;
	

	@Autowired
	private ProdVisadocReService prodVisadocReService;
	
	@Autowired
	private ProdTrafficClientService prodTrafficService;
	
	
	@Autowired
	private AssociationRecommendService associationRecommendService;
	
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
			
			Map<String, Object> propMap =prodProduct.getPropValue();
			String auto_pack_traffic = "N";
			if(propMap != null){
				auto_pack_traffic = (String)propMap.get("auto_pack_traffic");
			}
			model.addAttribute("auto_pack_traffic",auto_pack_traffic);
			if(prodProduct.getProductName().contains("#")){
				String prodName = null;
				String[] title = prodProduct.getProductName().split("#");
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
				LOG.info("标题结构化产品处理后：prodName="+prodName);
				prodProduct.setProductName(prodName);
			}
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
				
			model.addAttribute("productBU", prodProduct.getBu());
			//判断产品版本为1.0
			Double modelVesion=prodProduct.getModelVersion();
			if(modelVesion==null||modelVesion!=1.0){
				model.addAttribute("modelVersion", "false");
			}else if(modelVesion==1.0){
				model.addAttribute("modelVersion", "true");
			}
		} else {
			model.addAttribute("productName", null);
		}
		
		
		return "/prod/selfTour/product/showProductMaintain";
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
