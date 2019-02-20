package com.lvmama.vst.back.prod.web.hotelPackage;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.biz.service.BizDictQueryService;
import com.lvmama.vst.back.biz.service.CategoryPropGroupService;
import com.lvmama.vst.back.client.biz.service.CategoryClientService;
import com.lvmama.vst.back.client.biz.service.DistrictClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductPropClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.prod.po.ProdLineRoute;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdVisadocRe;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.prod.service.ProdVisadocReService;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.pet.goods.PetProdGoodsAdapter;

/**
 * 产品管理Action
 * 
 * @author qiujiehong
 * @date 2013-10-11
 */
@Controller
@RequestMapping("/hotelPackage/prod/product")
public class HotelPackageProductAction extends BaseActionSupport {
	private static final Log LOG = LogFactory.getLog(HotelPackageProductAction.class);

	@Autowired
	private SuppGoodsClientService suppGoodsService;
	
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
	private ProdLineRouteClientService prodLineRouteService;

	@Autowired
	private ProdVisadocReService prodVisadocReService;

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
			ProdProduct prodProduct = prodProductService.findProdProduct4FrontById(Long.valueOf(productId), Boolean.TRUE, Boolean.TRUE);
			//vst组织鉴权
			super.vstOrgAuthentication(LOG, prodProduct.getManagerIdPerm());
			
			model.addAttribute("productName", prodProduct.getProductName());
			model.addAttribute("categoryId", prodProduct.getBizCategoryId());
			model.addAttribute("categoryName", prodProduct.getBizCategory().getCategoryName());
			model.addAttribute("productType", prodProduct.getProductType());

			//校验行程
			List<ProdLineRoute> lineRouteList= checkRoute(productId);
			String routeFlag="false";
			if(lineRouteList!=null&&lineRouteList.size()>=1){
				routeFlag="true";
			}
			model.addAttribute("routeFlag", routeFlag);
			
			model.addAttribute("productType", prodProduct.getProductType());
			//出境-需要校验签证材料
			if("FOREIGNLINE".equals(prodProduct.getProductType())){
				String visaDocFlag=checkvisaDoc( productId);
				model.addAttribute("visaDocFlag", visaDocFlag);
			}
			SuppGoods suppGoods = suppGoodsService.findBaseSuppGoodsByProductId(productId);
			if(suppGoods!=null) {
				model.addAttribute("productBU", suppGoods.getBu());
			}
		} else {
			model.addAttribute("productName", null);
		}
		
		return "/prod/hotelPackage/product/showProductMaintain";
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
