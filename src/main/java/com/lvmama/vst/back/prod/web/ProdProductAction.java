package com.lvmama.vst.back.prod.web;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lvmama.vst.back.biz.po.*;
import com.lvmama.vst.back.biz.service.*;
import com.lvmama.vst.back.prod.service.*;
import com.lvmama.vst.comm.utils.web.HttpServletLocalThread;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.dest.api.utils.DynamicRouterUtils;
import com.lvmama.vst.back.client.biz.service.CategoryClientService;
import com.lvmama.vst.back.client.biz.service.DestClientService;
import com.lvmama.vst.back.client.biz.service.DistrictClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.prod.service.ProdDestReClientService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteClientService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteDetailClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductAdapterClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductBranchAdapterClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductBranchClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductPropClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.pub.service.ComPhotoClientService;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.goods.vo.ProdProductParam;
import com.lvmama.vst.back.prod.po.ProdLineRoute;
import com.lvmama.vst.back.prod.po.ProdLineRouteDetail;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductAssociation;
import com.lvmama.vst.back.prod.po.ProdProductBranch;
import com.lvmama.vst.back.prod.po.ProdProductProp;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.router.adapter.ProdProductHotelAdapterService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.enumeration.CommEnumSet;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.Constants;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.utils.WineSplitConstants;
import com.lvmama.vst.comm.utils.json.JSONOutput;
import com.lvmama.vst.comm.vo.Constant.PROPERTY_INPUT_TYPE_ENUM;
import com.lvmama.vst.comm.vo.Constant.SEARCH_TYPE_TAG;
import com.lvmama.vst.comm.vo.MemcachedEnum;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultHandleTT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;
import com.lvmama.vst.pet.adapter.SensitiveWordServiceAdapter;
import com.lvmama.vst.pet.adapter.TntProductGoodsPreviewAdapter;
import com.lvmama.vst.pet.vo.TntChannelPreViewVo;
/**
 * 产品管理Action
 * 
 * @author qiujiehong
 * @date 2013-10-11
 */
@Controller
@RequestMapping("/prod/product")
public class ProdProductAction extends BaseActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = -6351446724576585206L;

	private static final Log LOG = LogFactory.getLog(ProdProductAction.class);

	@Autowired
	private ProdProductClientService prodProductService;

	@Autowired
	private CategoryClientService categoryService;

	@Autowired
	private CategoryPropGroupService categoryPropGroupService;

	@Autowired
	private ComLogClientService comLogService;

	@Autowired
	private DistrictClientService districtService;

	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;

	@Autowired
	private SensitiveWordServiceAdapter sensitiveWordServiceAdapter;

	@Autowired
	private SuppGoodsClientService suppGoodsService;

	@Autowired
	private TntProductGoodsPreviewAdapter tntProductGoodsPreviewService;

	@Autowired
	private ProdLineRouteDetailClientService prodLineRouteDetailService;

	@Autowired
	private SensitiveSupport sensitiveFlagSupport;

	@Autowired
	private PermUserServiceAdapter permUserServiceAdapter;

	@Autowired
	ProdProductPropClientService prodProductPropClientService;

	@Autowired
	private ProdProductClientService prodProductClientRemote;

	@Autowired
	private ProdDestReClientService prodDestReService;

	@Autowired
	private DestClientService destService;

	@Autowired
	private ProdProductAdapterClientService prodProductServiceAdapter;

	@Autowired
	private ComPhotoClientService comPhotoService;
	
	
	@Autowired
	private ProdLineRouteClientService prodLineRouteService;
	
	@Autowired
	private ProdProductAssociationService prodProductAssociationService;
	
	@Autowired
	private ProdProductHotelAdapterService prodProductHotelAdapterService;
	
	@Autowired
	private ProdProductBranchAdapterClientService prodProductBranchAdapterService;
	
	@Autowired
	private ProdProductBranchClientService prodProductBranchService;

	/**
	 * 获得产品列表
	 * 
	 * @param model
	 * @param page
	 *            分页参数
	 * @param prodProduct
	 *            查询条件
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/findProductList")
	public String findProductList(Model model, Integer page, ProdProduct prodProduct, String goodsId, String brandName, String subCompany, Long productManagerId, String productManagerName, String destId, String destName, HttpServletRequest req)
			throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<findProductList>");
		}

		// 条件搜索展开状态
		model.addAttribute("foldingType", req.getParameter("foldingType"));

		// 查询品类
		List<BizCategory> bizCategoryList = bizCategoryQueryService.getAllValidCategorys();
		//除去预售
		Iterator<BizCategory> bizCategory = bizCategoryList.iterator();
		while (bizCategory.hasNext()) {
		    BizCategory biz = bizCategory.next();
		    if(biz.getCategoryId().intValue()==99){
		        bizCategory.remove();
		    }
            
        }
		
		//去掉1L 酒店h和酒套餐品类
		boolean hotelOnlineFlag = DynamicRouterUtils.getInstance().isHotelSystemOnlineEnabled();
		if (hotelOnlineFlag) {
			model.addAttribute("hotelOnlineFlag", hotelOnlineFlag);
			Iterator<BizCategory> cateit = bizCategoryList.iterator();
			while (cateit.hasNext()) {
				if (BizEnum.BIZ_CATEGORY_TYPE.category_hotel.getCategoryId().equals(cateit.next().getCategoryId())) {
					cateit.remove();
				}
				
			}
			Iterator<BizCategory> cateit2 = bizCategoryList.iterator();
			while (cateit2.hasNext()) {
				if (BizEnum.BIZ_CATEGORY_TYPE.category_route_new_hotelcomb.getCategoryId().equals(cateit2.next().getCategoryId())) {
					cateit2.remove();
				}
				
			}
		}
		        

		// 去掉29 交通+X 这个品类,添加去除景乐9品类逻辑
		Iterator<BizCategory> categoryit = bizCategoryList.iterator();
		while (categoryit.hasNext()) {
			BizCategory next = categoryit.next();
			if (BizEnum.BIZ_CATEGORY_TYPE.category_route_aero_hotel.getCategoryId().equals(next.getCategoryId())
					||BizEnum.JINGLE_CATEGORY_TYPE.isJingLe(next.getCategoryId())) {
				categoryit.remove();
			}
		}


		model.addAttribute("bizCategoryList", bizCategoryList); // 所有品类

		// 查询自由行子品类
		List<BizCategory> subCategoryList = bizCategoryQueryService.getBizCategorysByParentCategoryId(WineSplitConstants.ROUTE_FREEDOM);
		model.addAttribute("subCategoryList", subCategoryList);

		model.addAttribute("auditTypeList", ProdProduct.AUDITTYPE.values()); // 审批状态列表
		model.addAttribute("filialeNameList", CommEnumSet.FILIALE_NAME.values()); // 子公司列表
		if (prodProduct == null || prodProduct.getAbandonFlag() == null) {
			model.addAttribute("abandonFlag", "N");// 默认
		} else {
			model.addAttribute("abandonFlag", prodProduct.getAbandonFlag());//
		}

		if (prodProduct == null || prodProduct.getProductName() == null) {
			return "/prod/product/findProductList";
		}
		Map<String, Object> paramProdProduct = new HashMap<String, Object>();
		paramProdProduct.put("productName", prodProduct.getProductName()); // 产品名称
		paramProdProduct.put("productId", prodProduct.getProductId()); // 产品ID
		paramProdProduct.put("cancelFlag", prodProduct.getCancelFlag()); // 产品状态
		paramProdProduct.put("saleFlag", prodProduct.getSaleFlag()); // 是否可售
		paramProdProduct.put("subCompany", subCompany); // 子公司
		paramProdProduct.put("destId", destId); // 目的地
		paramProdProduct.put("abandonFlag", prodProduct.getAbandonFlag()); // 废弃标识
		paramProdProduct.put("subCategoryId", prodProduct.getSubCategoryId()); // 子分类id
		if(prodProduct.getPackageType()!=null && StringUtils.isNotEmpty(prodProduct.getPackageType())){
			paramProdProduct.put("packageType", prodProduct.getPackageType()); // 打包类型
		}
		if(prodProduct.getProductType()!=null && StringUtils.isNotEmpty(prodProduct.getProductType()) ){
			paramProdProduct.put("productType", prodProduct.getProductType());
		}
		if(prodProduct.getBu()!=null && StringUtils.isNotEmpty(prodProduct.getBu())){
//			if("dujia".equals(prodProduct.getBu())){
//				paramProdProduct.put("buArray", Arrays.asList("LOCAL_BU","DESTINATION_BU"));
//			}else{
//				paramProdProduct.put("buArray", Arrays.asList(prodProduct.getBu()));
//			}
			paramProdProduct.put("buArray", Arrays.asList(prodProduct.getBu()));	
		}
		if (hotelOnlineFlag) {
			paramProdProduct.put("hotelOnlineFlag", hotelOnlineFlag);
		}
		List<Long> jingleIdList = new ArrayList<Long>();
		for (BizEnum.JINGLE_CATEGORY_TYPE jingle_category_type : BizEnum.JINGLE_CATEGORY_TYPE.values()) {
			jingleIdList.add(jingle_category_type.getCategoryId().longValue());
		}
		paramProdProduct.put("excludeBizCategoryIdLst", jingleIdList);
		if (!"".equalsIgnoreCase(prodProduct.getAuditStatus())) {
			paramProdProduct.put("auditStatus", prodProduct.getAuditStatus()); // 审核状态
		}
		if (prodProduct.getBizDistrict() != null) {
			paramProdProduct.put("bizDistrictId", prodProduct.getBizDistrict().getDistrictId()); // 行政区划ID
			paramProdProduct.put("districtName", prodProduct.getBizDistrict().getDistrictName()); // 行政区划
		}
		if (goodsId != null) {
			paramProdProduct.put("goodsId", goodsId.trim()); // 商品ID
		}
		paramProdProduct.put("productManagerId", productManagerId); // 产品经理
		paramProdProduct.put("suppProductName", prodProduct.getSuppProductName()); // 供应商产品名称
		if (prodProduct.getSuppSupplier() != null) {
			paramProdProduct.put("supplierId", prodProduct.getSuppSupplier().getSupplierId()); // 供应商名称
		}
		if (prodProduct.getBizCategory() != null) {
			paramProdProduct.put("bizCategoryId", prodProduct.getBizCategory().getCategoryId());
			if((null != prodProduct.getBizCategory().getCategoryId()) && (prodProduct.getBizCategory().getCategoryId().intValue() == 3)) {//如果是保险则拉出产品动态字段
			    model.addAttribute("showInsProp", true);
			    paramProdProduct.put("needsPropList", Boolean.TRUE);
			}
		}
		if (prodProduct.getProductBrand() != null) {
			paramProdProduct.put("brandId", prodProduct.getProductBrand().getBrandId()); // 酒店品牌
		}
		int count = 0;
		count = MiscUtils.autoUnboxing( prodProductService.findProdProductCount(paramProdProduct) );


		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		paramProdProduct.put("_start", pageParam.getStartRows());
		paramProdProduct.put("_end", pageParam.getEndRows());
		paramProdProduct.put("_orderby", "PRODUCT_ID");
		paramProdProduct.put("_order", "DESC");
		paramProdProduct.put("isneedmanager", "false");
		List<ProdProduct> list = null;

		list = prodProductService.findProdProductListSales(paramProdProduct);
	
		// 判断是否有敏感词
		if (list != null && list.size() > 0) {
			for (ProdProduct pp : list) {
				Object obj = getSensitiveFlag(pp.getProductId());
				ResultMessage rm = (ResultMessage) obj;
				if (!"success".equalsIgnoreCase(rm.getCode())) {
					pp.setSenisitiveFlag("Y");
				}
				
				if(pp.getProductName()!=null){
					if(pp.getProductName().contains("#")){
						String prodName = null;
						String[] title = pp.getProductName().split("#");
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
						pp.setProductName(prodName);
					}
				}
			}
		}
		pageParam.setItems(list);
		model.addAttribute("auditStatus", prodProduct.getAuditStatus());
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("prodProduct", prodProduct);
		model.addAttribute("bizCategory", prodProduct.getBizCategory());
		model.addAttribute("goodsId", goodsId);
		model.addAttribute("productManagerId", productManagerId);
		model.addAttribute("productManagerName", productManagerName);
		model.addAttribute("destId", destId);
		model.addAttribute("destName", destName);
		model.addAttribute("brandName", brandName);
		model.addAttribute("subCompany", subCompany);
		model.addAttribute("abandonFlag", prodProduct.getAbandonFlag());
		//演出票
		model.addAttribute("showTicket", BizEnum.BIZ_CATEGORY_TYPE.category_show_ticket);
		return "/prod/product/findProductList";
	}
	
	/**
	 * 获得产品关系列表
	 * 
	 * @param model
	 * @param page
	 *            分页参数
	 * @param prodProduct
	 *            查询条件
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/findProductRelationList")
	public String findProductRelationList(Model model, Integer page, ProdProduct prodProduct, Long packagedId,  Long productManagerId, String productManagerName, HttpServletRequest req)
			throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<findProductRelationList>");
		}
		// 条件搜索展开状态
		model.addAttribute("foldingType", req.getParameter("foldingType"));
		// 查询品类
		List<BizCategory> bizCategoryList = bizCategoryQueryService.getAllValidCategorys();
		//除去预售
		Iterator<BizCategory> bizCategory = bizCategoryList.iterator();
		while (bizCategory.hasNext()) {
		    BizCategory biz = bizCategory.next();
		    if(biz.getCategoryId().intValue()!=15 && biz.getCategoryId().intValue()!=18){
		        bizCategory.remove();
		    }
        }
		model.addAttribute("bizCategoryList", bizCategoryList); // 跟团游，自由行
		// 查询自由行子品类
		List<BizCategory> subCategoryList = bizCategoryQueryService.getBizCategorysByParentCategoryId(WineSplitConstants.ROUTE_FREEDOM);
		model.addAttribute("subCategoryList", subCategoryList);
		if (packagedId == null) {
			return "/prod/product/findProductRelationList";
		}
		model.addAttribute("packagedId", packagedId);
		Map<String, Object> paramProdProduct = new HashMap<String, Object>();
		List<Long> objectIdLst = new ArrayList<Long>();
		HashMap<String,Object> params = new HashMap<String,Object>();
		params.put("productId", packagedId);
		try{
			ProdProduct prodProduct2 = prodProductBranchAdapterService.findProdProductAndBranchById(packagedId);
			if(prodProduct2!=null){
				model.addAttribute("packagedProdName",prodProduct2.getProductName());
				if(prodProduct2.getProdProductBranchList()!=null &&prodProduct2.getProdProductBranchList().size()>0){
					for(ProdProductBranch prodBranch:prodProduct2.getProdProductBranchList()){
						objectIdLst.add(prodBranch.getProductBranchId());
					}
				}else{
					LOG.info("getProdProductBranchList null productid="+packagedId);
				}
			}
		}catch(Exception e) {
			LOG.error("method productReation findProdProductAndBranchById error, ", e);
			
		}
		if(objectIdLst!=null&&objectIdLst.size()>0){
			//根据规格id查主产品
			paramProdProduct.put("objectIdLst", objectIdLst);
			if(prodProduct.getBizCategory().getCategoryId()!=null){
				paramProdProduct.put("categoryId", prodProduct.getBizCategory().getCategoryId());	
			}
			if(prodProduct.getSubCategoryId()!=null){
				paramProdProduct.put("subCategoryId", prodProduct.getSubCategoryId());
			}
			if(productManagerId!=null){
				paramProdProduct.put("productManagerId", productManagerId); // 产品经理
			}
			paramProdProduct.put("cancelFlag", prodProduct.getCancelFlag()); // 产品状态
			paramProdProduct.put("saleFlag", prodProduct.getSaleFlag()); // 是否可售
			paramProdProduct.put("relationType",prodProduct.getRelationType());
			int count = prodProductService.findRelationProductCount(paramProdProduct);
			int pagenum = page == null ? 1 : page;
			Page pageParam = Page.page(count, 10, pagenum);
			pageParam.buildUrl(req);
			paramProdProduct.put("_start", pageParam.getStartRows());
			paramProdProduct.put("_end", pageParam.getEndRows());
			paramProdProduct.put("_orderby", "PRODUCT_ID");
			paramProdProduct.put("_order", "DESC");
			paramProdProduct.put("isneedmanager", "true");
			List<ProdProduct> Productlist = null;
			Productlist = prodProductService.findRelationProductList(paramProdProduct);
			pageParam.setItems(Productlist);
			model.addAttribute("pageParam", pageParam);
			model.addAttribute("prodProduct", prodProduct);
			model.addAttribute("productManagerId", productManagerId);
			model.addAttribute("productManagerName", productManagerName);
		}
		return "/prod/product/findProductRelationList";
		
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/findsaveRouteFlag")
	public Object findsaveRouteFlag(Long productId){
		ProdProduct prodProduct = MiscUtils.autoUnboxing( prodProductService.getProdProductBy(productId) );
		if(prodProduct.getBizCategoryId() == 15L && prodProduct.getPackageType().equals("LVMAMA")){
			String saveRouteFlag="Y";
			Map<String,Object> pars = new HashMap<String, Object>();
			pars.put("productId", productId);
			pars.put("cancleFlag", "Y");
			List<ProdLineRoute> prodRouteList=  prodLineRouteService.findProdLineRouteByParams(pars);
			if(prodRouteList==null||prodRouteList.size()<=0){
				saveRouteFlag="N";
			}
			for(ProdLineRoute pr:prodRouteList){
				List<ProdLineRouteDetail> routeDetailList=  null;
				try{
				    routeDetailList=  MiscUtils.autoUnboxing( 
						prodLineRouteService.findProdLineRouteDetailByLineRouteId(pr.getLineRouteId()) );
				}catch(Exception e) {
					LOG.error("ProdProductAction.findsaveRouteFlag productId:" + productId , e);
				}
				if(routeDetailList==null||routeDetailList.size()<=0){
					saveRouteFlag="N";
					break;
				}
			}
			ProdProductAssociation prodProductAssociation = prodProductAssociationService.getProdProductAssociationByProductId(productId);
			if (prodProductAssociation!=null) {
				if(prodProductAssociation.getAssociatedRouteProdId()!=null){
					saveRouteFlag="Y";
				}
			}
			ProdProductParam param = new ProdProductParam();
			param.setProductProp(true);
			param.setProductPropValue(true);
			ProdProduct product = MiscUtils.autoUnboxing( prodProductService.findProdProductById(productId, param) );
			Map<String, Object> propMap =product.getPropValue();
			if(propMap != null){
				String auto_pack_traffic = (String)propMap.get("auto_pack_traffic");
				String isuse_packed_route_details = (String)propMap.get("isuse_packed_route_details");
				if(auto_pack_traffic != null && isuse_packed_route_details != null && auto_pack_traffic.equalsIgnoreCase("Y") && isuse_packed_route_details.equalsIgnoreCase("Y")){
					saveRouteFlag="Y";
				}
			}
			if(saveRouteFlag.equals("Y")){
				return getSensitiveFlag(productId);
			}
			return new ResultMessage("saveRouteFlag", saveRouteFlag);
		}else{
			return getSensitiveFlag(productId);
		}
	}

	
	/**
	 * 跳转到产品维护页面
	 * 
	 * @param model
	 * @param productId
	 * @return
	 */
	@RequestMapping(value = "/showProductMaintain")
	public String showProductMaintain(Model model, Long productId, String categoryName, Long categoryId, String isView) throws BusinessException {
		model.addAttribute("categoryId", categoryId);
		model.addAttribute("categoryName", categoryName);
		model.addAttribute("productId", productId);
		model.addAttribute("isView", isView);
		if (productId != null) {
			ProdProduct prodProduct = prodProductHotelAdapterService.findProdProduct4FrontById(Long.valueOf(productId), Boolean.TRUE, Boolean.TRUE);
			// vst组织鉴权
			super.vstOrgAuthentication(LOG, prodProduct.getManagerIdPerm());

			model.addAttribute("productName", prodProduct.getProductName());
			model.addAttribute("categoryId", prodProduct.getBizCategoryId());
			model.addAttribute("categoryName", prodProduct.getBizCategory().getCategoryName());
		} else {
			model.addAttribute("productName", null);
		}
		return "/prod/product/showProductMaintain";
	}

	@RequestMapping(value = "/showSelectCategory")
	public String showSelectCategory(Model model) throws BusinessException {
		Map<String, Object> paramBizCategory = new HashMap<String, Object>();
		// paramBizCategory.put("_orderby", "SEQ");
		paramBizCategory.put("_orderby", "CATEGORY_ID");
		paramBizCategory.put("_order", "asc");
		paramBizCategory.put("cancelFlag", "Y");
		// List<BizCategory> bizCategoryList = categoryService.findCategoryList(paramBizCategory);
		List<BizCategory> bizCategoryList = MiscUtils.autoUnboxing( categoryService.findCategoryListBottomCategory(paramBizCategory) );

		// 去掉29 交通+X 这个品类,移除景乐9个品类
		Iterator<BizCategory> categoryit = bizCategoryList.iterator();
		while (categoryit.hasNext()) {
			 BizCategory next = categoryit.next();
			if (BizEnum.BIZ_CATEGORY_TYPE.category_route_aero_hotel.getCategoryId().equals(next.getCategoryId())
					||BizEnum.JINGLE_CATEGORY_TYPE.isJingLe(next.getCategoryId())) {
				categoryit.remove();
			}
		}
		
		//去掉1L 酒店品类
		boolean hotelOnlineflag = DynamicRouterUtils.getInstance().isHotelSystemOnlineEnabled();
		if (hotelOnlineflag) {
			Iterator<BizCategory> cateit = bizCategoryList.iterator();
			while (cateit.hasNext()) {
				if (BizEnum.BIZ_CATEGORY_TYPE.category_hotel.getCategoryId().equals(cateit.next().getCategoryId())) {
					cateit.remove();
				}
				
			}
			
			Iterator<BizCategory> cateit2 = bizCategoryList.iterator();
			while (cateit2.hasNext()) {
				if (BizEnum.BIZ_CATEGORY_TYPE.category_route_new_hotelcomb.getCategoryId().equals(cateit2.next().getCategoryId())) {
					cateit2.remove();
				}
				
			}
		}
		
		model.addAttribute("bizCategoryList", bizCategoryList);

		// 加载自由行直系子品类
		List<BizCategory> bizFreedomList = bizCategoryQueryService.getBizCategorysByParentCategoryId(WineSplitConstants.ROUTE_FREEDOM);
		model.addAttribute("bizFreedomList", bizFreedomList);

		// 加载其他票子品类
		List<BizCategory> bizOtherTicketList = bizCategoryQueryService.getBizCategorysByParentCategoryId(BizEnum.BIZ_CATEGORY_TYPE.category_other_ticket.getCategoryId());
		Collections.reverse(bizOtherTicketList);
		model.addAttribute("bizOtherTicketList", bizOtherTicketList);

		return "/prod/product/showSelectCategory";
	}

	/**
	 * 查看产品
	 * 
	 * @return
	 */
	public String showProduct() {

		return "";
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
		ProdProduct prodProduct = null;
		// BizCategory bizCategory = null;
		List<BizCatePropGroup> bizCatePropGroupList = null;

		if (req.getParameter("productId") != null) {
			Map<String, Object> parameters = new HashMap<String, Object>();
			parameters.put("productId", req.getParameter("productId"));
			prodProduct = prodProductHotelAdapterService.findProdProduct4FrontById(Long.valueOf(req.getParameter("productId")), Boolean.TRUE, Boolean.TRUE);
			Long managerId = prodProduct.getManagerId();
			if (managerId != null) {
				PermUser permUser = permUserServiceAdapter.getPermUserByUserId(managerId);
				prodProduct.setManagerName("");
				if (permUser != null) {
					prodProduct.setManagerName(permUser.getRealName());
				}
			}
			if (prodProduct != null) {
				bizCatePropGroupList = categoryPropGroupService.findCategoryPropGroupsAndCategoryProp(prodProduct.getBizCategory().getCategoryId(), false);
				if ((bizCatePropGroupList != null) && (bizCatePropGroupList.size() > 0)) {
					//供应商打包过滤 交通自动打包组的属性（105 跟团/106自由行）
					List<BizCatePropGroup> tempBizCatePropGroupList=new ArrayList<BizCatePropGroup>();
					for (BizCatePropGroup bizCatePropGroup : bizCatePropGroupList) {
						if(ProdProduct.PACKAGETYPE.SUPPLIER.getCode().equals(prodProduct.getPackageType())){
							if(bizCatePropGroup.getGroupId()!=null
									&&(105==bizCatePropGroup.getGroupId().longValue()||106==bizCatePropGroup.getGroupId().longValue())){
								continue;
							}
						}
						tempBizCatePropGroupList.add(bizCatePropGroup);
					}
					bizCatePropGroupList=tempBizCatePropGroupList;
					for (BizCatePropGroup bizCatePropGroup : bizCatePropGroupList) {
						if ((bizCatePropGroup.getBizCategoryPropList() != null) && (bizCatePropGroup.getBizCategoryPropList().size() > 0)) {
							for (BizCategoryProp bizCategoryProp : bizCatePropGroup.getBizCategoryPropList()) {
								Map<String, Object> parameters2 = new HashMap<String, Object>();
								Long propId = bizCategoryProp.getPropId();
								parameters2.put("productId", req.getParameter("productId"));
								parameters2.put("propId", propId);

								List<ProdProductProp> prodProductPropList = prodProductHotelAdapterService.findProdProductPropList(parameters2);
								bizCategoryProp.setProdProductPropList(prodProductPropList);
							}
						}
					}
				}
			}

			// 查询没有上传图片的规格列表
			List<ProdProductBranch> productBranchList = prodProductBranchAdapterService.findProductBranchNotexistPic(parameters);
			model.addAttribute("productBranchList", productBranchList);

			// 查询图片上传个数
			int ratio = 1;
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("productId", prodProduct.getProductId());
			params.put("propId", 20);
			List<ProdProductProp> result = prodProductHotelAdapterService.findProdProductPropList(params);
			if (result != null && result.size() > 0) {
				if ("1".equals(result.get(0).getPropValue()) || "3".equals(result.get(0).getPropValue())) {
					ratio = 2;
				}
			}
			Map<String, Object> photoParameters = new HashMap<String, Object>();
			photoParameters.put("objectId", prodProduct.getProductId());
			photoParameters.put("objectType", "PRODUCT_ID");
			if (ratio == 1) {
				photoParameters.put("ratio", ratio);
			}
			Integer photoCount = comPhotoService.queryComPhotoTotalCount(photoParameters);
			model.addAttribute("photoCount", photoCount);
		}
		model.addAttribute("addValueTitle", ProdProductProp.PROP_ADD_VALUE_SPLIT);
		model.addAttribute("prodProduct", prodProduct);

		if (prodProduct != null && prodProduct.getBizCategory() != null) {
			model.addAttribute("categoryName", prodProduct.getBizCategory().getCategoryName());
		}
		// model.addAttribute("bizCategory", bizCategory);
		model.addAttribute("bizCatePropGroupList", bizCatePropGroupList);
		// 类别
		model.addAttribute("productTypeList", new ArrayList<ProdProduct.PRODUCTTYPE>(Arrays.asList(ProdProduct.PRODUCTTYPE.values())));
		
		return "/prod/product/showUpdateProduct";
	}

	/**
	 * 跳转到添加产品
	 * 
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
		}
		model.addAttribute("addValueTitle", ProdProductProp.PROP_ADD_VALUE_SPLIT);
		model.addAttribute("bizCategory", bizCategory);
		if (bizCategory != null) {
			model.addAttribute("categoryName", bizCategory.getCategoryName());
		}
		model.addAttribute("bizCatePropGroupList", bizCatePropGroupList);
		// 类别
		model.addAttribute("productTypeList", new ArrayList<ProdProduct.PRODUCTTYPE>(Arrays.asList(ProdProduct.PRODUCTTYPE.values())));
		
		return "/prod/product/showAddProduct";
	}

	/**
	 * 跳转到添加产品
	 * 
	 * @return
	 */
	@RequestMapping(value = "/productPropList")
	public String productPropList() {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<productPropList>");
		}
		return "/prod/product/productPropList";
	}

	/**
	 * 更新产品
	 * 
	 * @return
	 */
	@RequestMapping(value = "/updateProduct")
	@ResponseBody
	public Object updateProduct(ProdProduct prodProduct) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<updateProduct>");
		}
		if ((prodProduct.getBizCategoryId() == null)) {
			throw new BusinessException("产品数据错误：无品类");
		}
		ResultMessage message = null;

		// 获取原始对象
		ProdProduct oldProdProduct = prodProductService.findProdProductById(prodProduct.getProductId(), Boolean.TRUE, Boolean.TRUE);
		// update by wangguoqing 2015-11-10 商品数据更新规则 start
		prodProduct = prodProductService.fillBizCategoryPropList(prodProduct);
		// 修改之前的酒店类型
		String oldHotelType = oldProdProduct.getProp("hotel_type");
		String newHotelType = prodProduct.getProp("hotel_type");

		// 董宁波 2016年1月8日 10:19:22 酒店产品数据唯一性验证
		if (SEARCH_TYPE_TAG.HOTEL.getCode() == prodProduct.getBizCategoryId().intValue()) {
			// 修改了产品名称数据
			if (!oldProdProduct.getProductName().equals(prodProduct.getProductName())) {
				ProdProduct product = prodProductService.findProdProductByProductNameWithOutId(prodProduct.getProductName(), prodProduct.getProductId());
				if (product != null) {
					return new ResultMessage("error", "保存失败, 产品名称已存在！");
				}
			}
		}
		// end
		// 查询商品信息
		List<SuppGoods> suppGoodsList = MiscUtils.autoUnboxing( suppGoodsService.findSuppGoodsByProductId(prodProduct.getProductId()) );
		for (SuppGoods suppGoods : suppGoodsList) {
			SuppGoods newSuppGoods = new SuppGoods();
			BeanUtils.copyProperties(suppGoods, newSuppGoods);
			newSuppGoods.setCancelFlag("N");
			newSuppGoods.setUpdateTime(new Date());

			// 判断酒店类型是否为【直签酒店】或【度假酒店&直签酒店】，是则商品设置为【无效】
			if (!newHotelType.equals(oldHotelType) && (newHotelType.equals("3") || newHotelType.equals("4"))) {
				// 商品是对接并且是现付的商品设置为无效
				if ("Y".equals(suppGoods.getApiFlag()) && "PAY".equals(suppGoods.getPayTarget())) {
					suppGoodsService.updateSuppGoods(newSuppGoods);
					// 添加商品日志
					addSuppGoodsLog(suppGoods, newSuppGoods);
				}
			} else {// 非直签酒店
					// 艺龙二星以下无效，其他有效
				if ("1".equals(suppGoods.getSupplierId().toString()) && prodProductClientRemote.isHotelStarRateBelowTwo(prodProduct.getProductId())) {
					suppGoodsService.updateSuppGoods(newSuppGoods);
					addSuppGoodsLog(suppGoods, newSuppGoods);
				}
			}
		}
		// update by wangguoqing 2015-11-10 商品数据更新规则 end

		prodProductService.updateProdProductProp(prodProduct);

		// 更新目的地
		prodProductServiceAdapter.updateProductDestRe(prodProduct);

		try {
			// 获取操作日志
			String logContent = getProdProductChangeLog(oldProdProduct, prodProduct);
			// 添加操作日志
			if (null != logContent && !"".equals(logContent)) {
				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, prodProduct.getProductId(), prodProduct.getProductId(), this.getLoginUser().getUserName(), "修改了产品：【" + prodProduct.getProductName() + "】，修改内容：" + logContent,
						COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name(), "修改产品", null);
			}
		} catch (Exception e) {
			log.error("Record Log failure ！Log Type:" + COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
			log.error(e.getMessage());
		}
		//SquidClient.getInstance().purgeProduct(prodProduct.getBizCategoryId(), prodProduct.getProductId() + "");
		message = new ResultMessage("success", "保存成功");
		return message;
	}

	private void addSuppGoodsLog(SuppGoods suppGoods, SuppGoods newSuppGoods) {
		// 获取商品变更日志内容
		// 添加操作日志
		try {
			String logContent = "";
			logContent = getSuppGoodsChangeLog(suppGoods, newSuppGoods);
			if (null != logContent && !"".equals(logContent)) {
				comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, suppGoods.getProductId(), suppGoods.getSuppGoodsId(), this.getLoginUser().getUserName(), "修改了商品：【" + suppGoods.getGoodsName() + "】,变更内容：" + logContent,
						COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(), "修改商品", null);
			}
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
			log.error(e.getMessage());
		}
	}

	/**
	 * 新增产品
	 * 
	 * @return
	 */
	@RequestMapping(value = "/addProduct")
	@ResponseBody
	public Object addProduct(ProdProduct prodProduct) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<addProduct>");
		}
		if (prodProduct.getBizCategoryId() != null) {
			// 董宁波 2016年1月8日 10:19:22 酒店产品数据唯一性验证
			if (SEARCH_TYPE_TAG.HOTEL.getCode() == prodProduct.getBizCategoryId().intValue()) {
				ProdProduct product = prodProductService.findProdProductByProductNameWithOutId(prodProduct.getProductName(), null);
				if (product != null) {
					return new ResultMessage("error", "保存失败, 产品名称已存在！");
				}
				prodProduct.setAuditStatus(ProdProduct.AUDITTYPE.AUDITTYPE_TO_PM.name());
			}
			// end
			prodProduct.setCreateUser(this.getLoginUserId());
			// 产品默认设置为有效
			prodProduct.setCancelFlag("Y");
			long id = MiscUtils.autoUnboxing( prodProductService.addProdProduct(prodProduct) );
			Map<String, Object> attributes = new HashMap<String, Object>();

			attributes.put("productId", id);
			attributes.put("productName", prodProduct.getProductName());
			attributes.put("categoryName", prodProduct.getBizCategory().getCategoryName());
			// 添加操作日志
			try {
				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, prodProduct.getProductId(), prodProduct.getProductId(), this.getLoginUser().getUserName(), "添加了产品：【" + prodProduct.getProductName() + "】",
						COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name(), "添加产品", null);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
				log.error(e.getMessage());
			}

			return new ResultMessage(attributes, "success", "保存成功");
		}
		return new ResultMessage("error", "保存失败,未选择品类");
	}

	/**
	 * 设置产品的有效性
	 * 
	 * @return
	 */
	@RequestMapping(value = "/cancelProduct")
	@ResponseBody
	public Object cancelProduct(ProdProduct prodProduct) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<cancelProduct>");
		}
		if(null != prodProduct && prodProduct.getBizCategoryId() == 33L){
			Boolean isValidity = prodProductService.findProdIsCancelFlagByProductId(prodProduct.getProductId());
			LOG.info("cancelProduct#productId:"+prodProduct.getProductId()+",isValidity:"+isValidity+",cancelFlag:"+prodProduct.getCancelFlag());
			if(null != isValidity && !isValidity && "Y".equals(prodProduct.getCancelFlag())){
				//金融产品当设为有效时  需要验证一下是否过期
				return ResultMessage.SET_VALIDITY_FAIL_RESULT;
			}
		}
		prodProductService.updateCancelFlag(prodProduct.getProductId(), prodProduct.getCancelFlag());

		//同步酒店对应的目的地有效性 add by lijuntao
		ProdProduct product = MiscUtils.autoUnboxing( prodProductService.getProdProductBy(prodProduct.getProductId()) );
		if(product != null && BizEnum.BIZ_CATEGORY_TYPE.category_hotel.getCategoryId().equals(product.getBizCategoryId())){
			Long destId = MiscUtils.autoUnboxing( prodDestReService.findDestIdByProductId(product.getProductId()) );
			if(destId != null){
				BizDest bizDest = new BizDest();
				bizDest.setDestId(destId);
				bizDest.setCancelFlag(product.getCancelFlag());
				destService.updateBizDestFlag(bizDest);
			}
		}

		// 去Super操作
		// petProdGoodsAdapter.updatePetProductCancel(prodProduct.getProductId());
		// 添加操作日志
		try {
			String key = "";
			if ("Y".equals(product.getCancelFlag())) {
				key = "有效";
			} else {
				key = "无效";
			}
			comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, product.getProductId(), product.getProductId(), this.getLoginUser().getUserName(), "修改了产品：【" + product.getProductName() + "】的有效性为：" + key,
					COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_STATUS.name(), "设置产品的有效性", null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_STATUS.name());
			log.error(e.getMessage());
		}

		return ResultMessage.SET_SUCCESS_RESULT;
	}

	/**
	 * 设置产品的废弃标识
	 * 
	 * @param prodProduct
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/abandonProduct")
	@ResponseBody
	public Object abandonProduct(ProdProduct prodProduct) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<cancelProduct>");
		}

		prodProductService.updateAbandonFlag(prodProduct);

		// 添加操作日志
		Long productId = prodProduct.getProductId();
		prodProduct = MiscUtils.autoUnboxing( prodProductService.getProdProductBy(productId) );

		try {
			String key = "";
			if ("Y".equals(prodProduct.getAbandonFlag())) {
				key = "废弃";
			} else {
				key = "正常";
			}
			comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, prodProduct.getProductId(), prodProduct.getProductId(), this.getLoginUser().getUserName(), "修改了产品：【" + prodProduct.getProductName() + "】的废弃标识为：" + key,
					COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_STATUS.name(), "设置产品的废弃标识", null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_STATUS.name());
			log.error(e.getMessage());
		}

		return ResultMessage.SET_SUCCESS_RESULT;
	}

	/**
	 * ajax查找所有产品信息
	 * @param response
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/queryProdProductList")
	public void queryProdProductList(String search, HttpServletResponse response) throws BusinessException {
		Map<String, Object> param = new HashMap<String, Object>();

		if (search.matches("^\\d+$")) {
			param.put("searchProductId", NumberUtils.toLong(search));
		}
		param.put("productName", search);

		List<ProdProduct> prodProductList = prodProductService.findProdProductListByCondition(param);

		JSONArray jsonArray = new JSONArray();
		if (null != prodProductList && prodProductList.size() > 0) {
			for (ProdProduct prodProduct : prodProductList) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("id", prodProduct.getProductId());
				jsonObject.put("text", prodProduct.getProductName());
				jsonArray.add(jsonObject);
			}
		}
		JSONOutput.writeJSON(response, jsonArray);
	}

	/**
	 * ajax查找所有产品信息
	 * @param response
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/getProdProductByProductName")
	public void getProdProductByProductName(String productName, Long productId, HttpServletResponse response) throws BusinessException {
		ResultHandleTT<ProdProduct> t = new ResultHandleTT<ProdProduct>();
		ProdProduct product = prodProductService.findProdProductByProductNameWithOutId(productName, productId);
		if (product != null) {
			// 产品名称已存在
			t.setReturnContent(product);
			t.setCode(1);// 0-正常，1-错误
			t.setMsg("产品名称已存在");
		} else {
			t.setCode(0);
		}

		JSONOutput.writeJSON(response, JSONObject.fromObject(t));
	}

	private String getProdProductChangeLog(ProdProduct oldProduct, ProdProduct newProduct) {
		StringBuffer logStr = new StringBuffer("");
		if (null != newProduct) {
			// logStr.append(ComLogUtil.getLogTxt("是否可售","Y".equals(newProduct.getSaleFlag())?"是":"否","Y".equals(oldProduct.getSaleFlag())?"是":"否"));
			logStr.append(ComLogUtil.getLogTxt("产品名称", newProduct.getProductName(), oldProduct.getProductName()));
			if (StringUtils.isNotBlank(newProduct.getProductType()) &&
					!StringUtils.equals(newProduct.getProductType(), oldProduct.getProductType())) {
				logStr.append(ComLogUtil.getLogTxt("类别", ProdProduct.PRODUCTTYPE.getCnName(newProduct.getProductType())
						, ProdProduct.PRODUCTTYPE.getCnName(oldProduct.getProductType())));
			}
			logStr.append(ComLogUtil.getLogTxt("是否有效", "Y".equals(newProduct.getCancelFlag()) ? "是" : "否", "Y".equals(oldProduct.getCancelFlag()) ? "是" : "否"));
			logStr.append(ComLogUtil.getLogTxt("推荐级别", newProduct.getRecommendLevel().toString(), oldProduct.getRecommendLevel().toString()));
			if (null != newProduct.getBizDistrict()) {
				if (!newProduct.getBizDistrict().getDistrictId().equals(oldProduct.getBizDistrict().getDistrictId())) {
					BizDistrict bizDistrict = MiscUtils.autoUnboxing( districtService.findDistrictById(newProduct.getBizDistrict().getDistrictId()) );
					logStr.append(ComLogUtil.getLogTxt("行政区划", bizDistrict.getDistrictName(), null));
				}
			}
			if (!newProduct.getProdProductPropList().equals(oldProduct.getProdProductPropList())) {
				Map<Long, ProdProductProp> oldProductProdMap = new HashMap<Long, ProdProductProp>();
				Map<Long, ProdProductProp> productProdMap = new HashMap<Long, ProdProductProp>();
				Map<Long, Map<String, String>> resultMap = new HashMap<Long, Map<String, String>>();

				ComLogUtil.setProductProp2Map(oldProduct.getProdProductPropList(), oldProductProdMap);
				ComLogUtil.setProductProp2Map(newProduct.getProdProductPropList(), productProdMap);
				ComLogUtil.diffProductPropMap(oldProductProdMap, productProdMap, resultMap);

				Map<Long, BizCategoryProp> bizCategoryMap = new HashMap<Long, BizCategoryProp>();
				List<BizCatePropGroup> bizCatePropGroupList = categoryPropGroupService.findCategoryPropGroupsAndCategoryProp(newProduct.getBizCategoryId(), false);
				if ((bizCatePropGroupList != null) && (bizCatePropGroupList.size() > 0)) {
					for (BizCatePropGroup bizCatePropGroup : bizCatePropGroupList) {
						ComLogUtil.setbizCategory2Map(bizCatePropGroup.getBizCategoryPropList(), bizCategoryMap);
					}
				}

				// 获取产品动态属性列表变更日志
				for (Map.Entry<Long, Map<String, String>> entry : resultMap.entrySet()) {
					if (PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_YESNO.name().equals(bizCategoryMap.get(entry.getKey()).getInputType())) {
						String oldValue = ("Y".equals(resultMap.get(entry.getKey()).get("oldValue")) ? "是" : "否");
						String newValue = ("Y".equals(resultMap.get(entry.getKey()).get("newvalue")) ? "是" : "否");
						logStr.append(ComLogUtil.getLogTxt(bizCategoryMap.get(entry.getKey()).getPropName(), newValue, oldValue));
					} else if (PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_CHECKBOX.name().equals(bizCategoryMap.get(entry.getKey()).getInputType())) {
						String newValue = resultMap.get(entry.getKey()).get("newValue");
						String[] dictIdArray = newValue.split(",");
						if (dictIdArray.length != 0) {
							newValue = MiscUtils.autoUnboxing( prodProductService.getDictCnValue(dictIdArray) );
						} else {
							newValue = "";
						}
						logStr.append(ComLogUtil.getLogTxt(bizCategoryMap.get(entry.getKey()).getPropName(), newValue, null));
					} else if (PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_SELECT.name().equals(bizCategoryMap.get(entry.getKey()).getInputType())) {
						String newValue = resultMap.get(entry.getKey()).get("newValue");
						String[] dictIdArray = newValue.split(",");
						String oldValue = resultMap.get(entry.getKey()).get("oldValue");
						String[] dictIdArray2 = oldValue.split(",");
						if (dictIdArray.length != 0) {
							newValue = MiscUtils.autoUnboxing( prodProductService.getDictCnValue(dictIdArray) );
						} else {
							newValue = "";
						}
						if (dictIdArray2.length != 0) {
							oldValue = MiscUtils.autoUnboxing( prodProductService.getDictCnValue(dictIdArray2) );
						} else {
							oldValue = "";
						}
						logStr.append(ComLogUtil.getLogTxt(bizCategoryMap.get(entry.getKey()).getPropName(), newValue, oldValue));
					} else if (PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_TEXTAREA.name().equals(bizCategoryMap.get(entry.getKey()).getInputType())
							|| PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_RICH.name().equals(bizCategoryMap.get(entry.getKey()).getInputType())) {
						String oldValue = resultMap.get(entry.getKey()).get("oldValue");
						String newValue = resultMap.get(entry.getKey()).get("newValue");
						if (null != newValue && !newValue.equals(oldValue)) {
							logStr.append(ComLogUtil.getLogTxt(bizCategoryMap.get(entry.getKey()).getPropName(), newValue, null));
						} else {
							logStr.append(ComLogUtil.getLogTxt(bizCategoryMap.get(entry.getKey()).getPropName(), newValue, oldValue));
						}
					} else {
						logStr.append(ComLogUtil.getLogTxt(bizCategoryMap.get(entry.getKey()).getPropName(), resultMap.get(entry.getKey()).get("newValue"), resultMap.get(entry.getKey()).get("oldValue")));
					}
				}
			}

		}
		return logStr.toString();
	}

	@RequestMapping(value = "removeCache")
	@ResponseBody
	public String removeCateByCategoryId(Model model, Long categoryId, HttpServletRequest req) throws BusinessException {
		String result = "false";
		if (categoryId != null) {

			Map<String, Object> paramProdProduct = new HashMap<String, Object>();
			// paramProdProduct.put("cancelFlag", "Y");
			// paramProdProduct.put("saleFlag", "Y");
			paramProdProduct.put("bizCategoryId", categoryId);

			int count = MiscUtils.autoUnboxing( prodProductService.findProdProductCount(paramProdProduct) );

			int pagenum = 1;
			int pageSize = 999;
			Page pageParam = Page.page(count, pageSize, pagenum);
			long totalPages = pageParam.getTotalPages();

			if (totalPages > 0) {
				for (pagenum = 1; pagenum <= totalPages; pagenum++) {
					pageParam = Page.page(count, pageSize, pagenum);

					paramProdProduct.put("_start", pageParam.getStartRows());
					paramProdProduct.put("_end", pageParam.getEndRows());

					List<ProdProduct> prodProductList = MiscUtils.autoUnboxing( prodProductService.findProdProductList(paramProdProduct) );

					if (prodProductList != null && prodProductList.size() > 0) {
						for (ProdProduct prodProduct : prodProductList) {
							Long productId = prodProduct.getProductId();

							/*
							 * MemcachedUtil.getInstance().remove(Constant.MEM_CACH_KEY.VST_PRODUCT_NO_BRAND_BASIC_.toString()+productId); MemcachedUtil.getInstance().remove(Constant.MEM_CACH_KEY.VST_PRODUCT_HAS_BRAND_BASIC_.toString()+productId);
							 */

							// TODO 清除缓存
							// 基本信息
							MemcachedUtil.getInstance().remove(MemcachedEnum.ProdProductSingle.getKey() + productId);
							MemcachedUtil.getInstance().remove(MemcachedEnum.ProdProductOnly.getKey() + productId);
							// 产品属性
							MemcachedUtil.getInstance().remove(MemcachedEnum.ProductWithPropList.getKey() + productId);
							// 规格属性
							MemcachedUtil.getInstance().remove(MemcachedEnum.ProductBranchList.getKey() + productId);

						}
					}
				}
			}

			result = "success !";
		} else {
			result = "categoryId is necessity";
		}

		return result;
	}

	/**
	 * 敏感词
	 * 
	 * @param word
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/sensitiveWord")
	public Object sensitiveWord(String word) {
		ResultMessage rm = new ResultMessage("", "");
		String sensitiveWords = "";
		try {
			sensitiveWords = sensitiveWordServiceAdapter.returnSensitiveWords(word);
		} catch (Exception e) {
			LOG.error(e.getMessage());
		} catch (Throwable e) {
			log.error(e.getMessage(), e);
		}
		if (sensitiveWords != null)
			rm.setMessage(sensitiveWords);
		return rm;
	}

	/**
	 * 判断是否有敏感词
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/getSensitiveFlag")
	public Object getSensitiveFlag(Long productId) {
		return sensitiveFlagSupport.findSensitiveFlag(productId);
	}

	@RequestMapping(value = "/findProductGoodsPreview")
	public String findProductGoodsPreview(Long productId) {
		ResultHandleT<TntChannelPreViewVo> productViewR = tntProductGoodsPreviewService.getProductView(productId);
		if (productViewR.isSuccess()) {
			HttpServletLocalThread.getModel().addAttribute("productView", productViewR.getReturnContent());
		}
		return "/prod/product/showProductGoodsPreview";

	}

	private String getSuppGoodsChangeLog(SuppGoods oldSuppGoods, SuppGoods newSuppGoods) {
		StringBuffer logStr = new StringBuffer("");
		if (null != newSuppGoods) {
			logStr.append(ComLogUtil.getLogTxt("商品名称", newSuppGoods.getGoodsName(), oldSuppGoods.getGoodsName()));
			logStr.append(ComLogUtil.getLogTxt("是否有效", "Y".equals(newSuppGoods.getCancelFlag()) ? "是" : "否", "Y".equals(oldSuppGoods.getCancelFlag()) ? "是" : "否"));
			if (!newSuppGoods.getLvmamaFlag().equals(oldSuppGoods.getLvmamaFlag())) {
				logStr.append(ComLogUtil.getLogTxt("是否驴妈妈可售", "Y".equals(newSuppGoods.getLvmamaFlag()) ? "是" : "否", null));
			}
			if (!newSuppGoods.getDistributeFlag().equals(oldSuppGoods.getDistributeFlag())) {
				logStr.append(ComLogUtil.getLogTxt("是否可分销", "Y".equals(newSuppGoods.getDistributeFlag()) ? "是" : "否", null));
			}

			// 内容维护人员
			if (!newSuppGoods.getContentManagerId().equals(oldSuppGoods.getContentManagerId())) {
				Long contentManagerId = oldSuppGoods.getContentManagerId();
				if (contentManagerId != null) {
					PermUser user = permUserServiceAdapter.getPermUserByUserId(contentManagerId);
					logStr.append(ComLogUtil.getLogTxt("内容维护人员", newSuppGoods.getContentManagerName(), user.getRealName()));
				}
			}
			// 商品合同
			// if (!newSuppGoods.getContractId().equals(oldSuppGoods.getSuppContract().getContractId())) {
			// logStr.append(ComLogUtil.getLogTxt("商品合同", newSuppGoods.getSuppContract().getContractName(),
			// oldSuppGoods.getSuppContract().getContractName()));
			// }
			if (!newSuppGoods.getPayTarget().equals(oldSuppGoods.getPayTarget())) {
				String newValue = "";
				String oldValue = "";
				newValue = SuppGoods.PAYTARGET.getCnName(newSuppGoods.getPayTarget());
				oldValue = SuppGoods.PAYTARGET.getCnName(oldSuppGoods.getPayTarget());
				logStr.append(ComLogUtil.getLogTxt("支付对象", newValue, oldValue));
			}
			if (!newSuppGoods.getFiliale().equals(oldSuppGoods.getFiliale())) {
				String newValue = "";
				String oldValue = "";
				newValue = CommEnumSet.FILIALE_NAME.getCnName(newSuppGoods.getFiliale());
				oldValue = CommEnumSet.FILIALE_NAME.getCnName(oldSuppGoods.getFiliale());
				logStr.append(ComLogUtil.getLogTxt("分公司", newValue, oldValue));
			}
			// 是否仅组合销售
			if (!newSuppGoods.getPackageFlag().equals(oldSuppGoods.getPackageFlag())) {
				logStr.append(ComLogUtil.getLogTxt("是否仅组合销售", "Y".equals(newSuppGoods.getPackageFlag()) ? "是" : "否", null));
			}
			// 是否使用传真
			if (!newSuppGoods.getFaxFlag().equals(oldSuppGoods.getFaxFlag())) {
				logStr.append(ComLogUtil.getLogTxt("是否使用传真", "Y".equals(newSuppGoods.getFaxFlag()) ? "是" : "否", null));
			}
			// 最少起订份数/间数
			logStr.append(ComLogUtil.getLogTxt("最少起订份数/间数", newSuppGoods.getMinQuantity().toString(), oldSuppGoods.getMinQuantity().toString()));
			logStr.append(ComLogUtil.getLogTxt("最多订购份数/间数", newSuppGoods.getMaxQuantity().toString(), oldSuppGoods.getMaxQuantity().toString()));
			logStr.append(ComLogUtil.getLogTxt("最少入住天数", newSuppGoods.getMinStayDay().toString(), oldSuppGoods.getMinStayDay().toString()));
			logStr.append(ComLogUtil.getLogTxt("最多入住天数", newSuppGoods.getMaxStayDay().toString(), oldSuppGoods.getMaxStayDay().toString()));

			// 公司主体-操作日志
			if (!StringUtils.equals(newSuppGoods.getCompanyType(), oldSuppGoods.getCompanyType())) {
				logStr.append(ComLogUtil.getLogTxt("合同主体：", newSuppGoods.getCompanyType(), oldSuppGoods.getCompanyType()));
			}

			if (!newSuppGoods.getGoodsType().equals(oldSuppGoods.getGoodsType())) {
				String newValue = "";
				String oldValue = "";
				newValue = SuppGoods.GOODSTYPE.getCnName(newSuppGoods.getGoodsType());
				oldValue = SuppGoods.GOODSTYPE.getCnName(oldSuppGoods.getGoodsType());
				logStr.append(ComLogUtil.getLogTxt("商品类型", newValue, oldValue));
				if (newSuppGoods.getGoodsType().equals("EXPRESSTYPE_DISPLAY")) {
					if (!newSuppGoods.getExpressType().equals(oldSuppGoods.getExpressType())) {
						String nValue = "";
						nValue = SuppGoods.EXPRESSTYPE.getCnName(newSuppGoods.getExpressType());
						logStr.append(ComLogUtil.getLogTxt("寄件方", nValue, null));
					}
				}
				if (newSuppGoods.getGoodsType().equals("NOTICETYPE_DISPLAY")) {
					if (!newSuppGoods.getNoticeType().equals(oldSuppGoods.getNoticeType())) {
						String nValue = "";
						nValue = SuppGoods.NOTICETYPE.getCnName(newSuppGoods.getNoticeType());
						logStr.append(ComLogUtil.getLogTxt("通知方式", nValue, null));
					}
				}

			} else {
				if (newSuppGoods.getGoodsType().equals("EXPRESSTYPE_DISPLAY")) {
					if (!newSuppGoods.getExpressType().equals(oldSuppGoods.getExpressType())) {
						String newValue = "";
						String oldValue = "";
						newValue = SuppGoods.EXPRESSTYPE.getCnName(newSuppGoods.getExpressType());
						oldValue = SuppGoods.EXPRESSTYPE.getCnName(oldSuppGoods.getExpressType());
						logStr.append(ComLogUtil.getLogTxt("寄件方", newValue, oldValue));
					}
				}
				if (newSuppGoods.getGoodsType().equals("NOTICETYPE_DISPLAY")) {
					if (!newSuppGoods.getNoticeType().equals(oldSuppGoods.getNoticeType())) {
						String newValue = "";
						String oldValue = "";
						newValue = SuppGoods.NOTICETYPE.getCnName(newSuppGoods.getNoticeType());
						oldValue = SuppGoods.NOTICETYPE.getCnName(oldSuppGoods.getNoticeType());
						logStr.append(ComLogUtil.getLogTxt("通知方式", newValue, oldValue));
					}
				}
			}
		}
		return logStr.toString();
	}

	@RequestMapping(value = "findWifiProductGoodsPreview")
	public String findWifiProductGoodsPreview(Model model, Long productId, String productType) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productId", productId);
		params.put("_orderby", "CANCEL_FLAG,SUPP_GOODS_ID");
		List<SuppGoods> suppList = MiscUtils.autoUnboxing( suppGoodsService.findSuppGoodsList(params) );
		model.addAttribute("suppList", suppList);
		model.addAttribute("productType", productType);
		return "/prod/product/showWifiProductGoodsPreview";
	}
	
	
	
	/**
	 * 设置游玩人配置页面
	 * @param model
	 * @param productId
	 */
	@RequestMapping(value="showProdTravellerConfig")
	public String showProdTravellerConfig(Model model,Long  productId){
		ProdProduct product = MiscUtils.autoUnboxing( prodProductService.findProdProductById(productId) );
		if(product == null)
			throw new BusinessException("产品不存在");
		model.addAttribute("travellerDelayFlag", product.getTravellerDelayFlag());
		model.addAttribute("productId", product.getProductId());
		model.addAttribute("categoryId", product.getBizCategoryId());
		return "/prod/product/showProdTravellerConfig";
	}

	
	/**设置游玩人配置
	 * 1,设置游玩人后置((自由行 机+酒、交通+服务)、跟团游、当地游、邮轮)
	 * @param productId 产品id
	 * @param travellerDelayFlag 后置标记(Y/N)
	 */
	@ResponseBody
	@RequestMapping(value="saveProdTravellerConfig")
	public Object saveTravellerConfig(Model model,Long  productId,String travellerDelayFlag){
		boolean suceessFlag = false;
		ProdProduct product =null;
		try {
			product = MiscUtils.autoUnboxing( prodProductService.findProdProductById(productId) );
			if(product!=null && product.getIsSupportTravellerDelay()
							 &&(Constants.N_FLAG.equals(travellerDelayFlag)
							 ||Constants.Y_FLAG.equals(travellerDelayFlag))){
				ProdProduct prodProduct = new ProdProduct();
				prodProduct.setProductId(productId);
				prodProduct.setTravellerDelayFlag(travellerDelayFlag);
				com.lvmama.vst.comm.vo.ResultHandle result = prodProductService.updateByPrimaryKeySelective(prodProduct);
				if(result != null && result.isSuccess()){
					suceessFlag = true;
					MemcachedUtil.getInstance().remove(MemcachedEnum.ProdProductSingle.getKey() + productId);
					MemcachedUtil.getInstance().remove(MemcachedEnum.ProdProductOnly.getKey() + productId);
				}
			}
			
		} catch (Exception e) {
			LOG.error(ExceptionFormatUtil.getTrace(e));
		}
		try {
			if(suceessFlag){
				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, 
						product.getProductId(), product.getProductId(), 
						this.getLoginUser().getUserName(), 
						"修改产品：【"+product.getProductName()+"】： "+ComLogUtil.getLogTxt("设置游玩人是否后置", 
								Constants.Y_FLAG.equals(travellerDelayFlag)?"可以":"不可以",
								Constants.Y_FLAG.equals(product.getTravellerDelayFlag())?"可以":"不可以"), 
						COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name(), 
						"游玩人设置",null);
			}
		} catch (Exception e) {
			LOG.error(ExceptionFormatUtil.getTrace(e));
		}
		if(suceessFlag){
			return new ResultMessage("success", "设置成功");
		}else{
			return new ResultMessage( "error", "设置失败");
		}
	}
	
	
	@RequestMapping(value = "/showProductBranchCheck")
	@ResponseBody
	public Object showSuppGoodsListCheck(HttpServletRequest req) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<showSuppGoodsListCheck>");
		}
		ResultMessage message = null;
		if (req.getParameter("productId") != null) {
			Map<String, Object> parameters = new HashMap<String, Object>();
			parameters.put("productId", req.getParameter("productId"));
			ProdProduct prodProduct = prodProductService.findProdProductById(Long.valueOf(req.getParameter("productId")), Boolean.TRUE, Boolean.TRUE);
			new HashMap<String, Object>();
			// 商品维护前，产品基本信息check
			message = new ResultMessage("success", "success");
			if ((prodProduct == null) || (prodProduct.getProductId() == null)) {
				message = new ResultMessage("error", "该产品不存在，请先维护产品！");
			}
		}
		return message;
	}
	
}
