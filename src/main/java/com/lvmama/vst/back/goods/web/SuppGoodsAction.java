package com.lvmama.vst.back.goods.web;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.comm.tnt.po.TntGoodsChannelVo;
import com.lvmama.vst.back.biz.po.BizBranch;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.client.biz.service.BizBuEnumClientService;
import com.lvmama.vst.back.client.biz.service.BranchClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.supp.service.SuppContractClientService;
import com.lvmama.vst.back.client.supp.service.SuppFaxClientService;
import com.lvmama.vst.back.client.supp.service.SuppSupplierClientService;
import com.lvmama.vst.back.dist.po.Distributor;
import com.lvmama.vst.back.dist.service.DistributorCachedService;
import com.lvmama.vst.back.dist.service.DistributorGoodsService;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.goods.vo.SupplierGoodsVO;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductBranch;
import com.lvmama.vst.back.prod.service.ProdProductBranchService;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.router.adapter.ProdProductHotelAdapterService;
import com.lvmama.vst.back.supp.po.SuppContract;
import com.lvmama.vst.back.supp.po.SuppFaxRule;
import com.lvmama.vst.back.supp.po.SuppSettleRule;
import com.lvmama.vst.back.supp.po.SuppSupplier;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.enumeration.CommEnumSet;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.ebooking.client.ebk.serivce.EbkSupplierGroupClientService;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;
import com.lvmama.vst.pet.adapter.TntGoodsChannelCouponAdapter;

/**
 * 商品维护管理Action
 * 
 * @author qiujiehong
 * @date 2013-10-11
 */
@Controller
@RequestMapping("/goods/goods")
public class SuppGoodsAction extends BaseActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 5576904778178181774L;

	private static final Log LOG = LogFactory.getLog(SuppGoodsAction.class);
	
	@Autowired
	private SuppGoodsClientService suppGoodsService;
	@Autowired
	private ProdProductService prodProductService;
	@Autowired
	private ComLogClientService comLogService;
	@Autowired
	private ProdProductBranchService prodProductBranchService;

	@Autowired
	private SuppSupplierClientService suppSupplierService;

	@Autowired
	private SuppContractClientService suppContractService;

	@Autowired
	private DistributorCachedService distributorService;

	@Autowired
	private DistributorGoodsService distributorGoodsService;

	@Autowired
	private SuppFaxClientService suppFaxService;
	
	@Autowired
	private PermUserServiceAdapter permUserServiceAdapter;
	

	@Autowired
	private TntGoodsChannelCouponAdapter tntGoodsChannelCouponServiceRemote;
	
	@Autowired
	private BranchClientService branchService;
	
	@Autowired
	private BizBuEnumClientService bizBuEnumClientService;
	
	/*DEL_PROD_GOODS_RE_0313@Autowired
	private EbkUserService ebkUserService;
	
	@Autowired
	private EbkHotelUserSuppGoodsReService ebkHotelUserSuppGoodsReService;*/

    @Autowired
    private EbkSupplierGroupClientService ebkSupplierGroupClientServiceRemote;

	@Autowired
	private ProdProductHotelAdapterService prodProductHotelAdapterService;

	@RequestMapping(value = "/showSuppGoodsListCheck")
	@ResponseBody
	public Object showSuppGoodsListCheck(HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showSuppGoodsListCheck>");
		}
		ResultMessage message = null;
		if (req.getParameter("productId") != null) {
			ProdProduct prodProduct = prodProductHotelAdapterService.findProdProductById(Long.valueOf(req.getParameter("productId")));
			// 商品维护前，产品基本信息check
			message = new ResultMessage("success", "success");
			if ((prodProduct == null) || (prodProduct.getProductId() == null)) {
				message = new ResultMessage("error", "该产品不存在，请先维护产品！");
				return message;
			} else {
//				if ("N".equals(prodProduct.getCancelFlag())) {
//					message = new ResultMessage("error", "该产品不可用，请先修改产品状态！");
//					return message;
//				}
//				Map<String, Object> parameprodProductBranch = new HashMap<String, Object>();
//				parameprodProductBranch.put("productId", prodProduct.getProductId());
//				parameprodProductBranch.put("cancelFlag", "Y");
//				int count = prodProductBranchService.findProdProductBranchCount(parameprodProductBranch);
//				if (count == 0) {
//					message = new ResultMessage("error", "该产品有效的规格不存在，请先维护产品规格！");
//					return message;
//				}
			}
		}
		return message;
	}

	@RequestMapping(value = "/showSuppGoodsList")
	public String showSuppGoodsList(Model model, HttpServletRequest req) throws BusinessException, UnsupportedEncodingException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showSuppGoodsList>");
		} 
		String automaticQuery = req.getParameter("automaticQuery");
		String supplierNameValue = req.getParameter("supplierName");
		if(supplierNameValue!=null && supplierNameValue!="")
		{
			//String newparam = new String(supplierNameValue.getBytes("utf-8"),"utf-8");
			String newparam = supplierNameValue;
			model.addAttribute("supplierName", newparam);
		}
		if(automaticQuery=="" || automaticQuery==null)
		{
			automaticQuery="false";
			model.addAttribute("automaticQuery", automaticQuery);
		}
		else
		{
			model.addAttribute("automaticQuery", automaticQuery);
		}
		if(StringUtil.isNotEmptyString(req.getParameter("supplierId"))){
			model.addAttribute("supplierIdValue", req.getParameter("supplierId"));
		}
		if (req.getParameter("productId") != null) {
			Map<String, Object> parameters = new HashMap<String, Object>();
			parameters.put("productId", req.getParameter("productId"));
			ProdProduct prodProduct = prodProductService.findProdProductByProductId(Long.valueOf(req.getParameter("productId")));
			model.addAttribute("prodProduct", prodProduct);
			Map<String, Object> parameprodProductBranch = new HashMap<String, Object>();
			parameprodProductBranch.put("productId", prodProduct.getProductId());
			List<ProdProductBranch> prodProductBranchList = prodProductBranchService.findProdProductBranchList(parameprodProductBranch);
			SuppGoods suppGoods = new SuppGoods();
			BizCategory bizCategory=new BizCategory();
			bizCategory.setCategoryId(prodProduct.getBizCategoryId());
			prodProduct.setBizCategory(bizCategory);
			suppGoods.setProdProduct(prodProduct);
			model.addAttribute("prodProductBranchList", prodProductBranchList);
			model.addAttribute("suppGoods", suppGoods);
			selectExistsSupplier(model, prodProduct.getProductId());
		}
		return "/goods/goods/findSuppGoodsList";
	}

	private void selectExistsSupplier(Model model, Long productId) {
		//已经存在的供应商
		List<SuppSupplier> suppSupplierList = MiscUtils.autoUnboxing( suppSupplierService.findSuppSupplierListByProductId(productId) );
		if(suppSupplierList != null) {
			JSONArray array = new JSONArray();
			for(SuppSupplier supp : suppSupplierList) {
				JSONObject obj=new JSONObject();
				obj.put("id", supp.getSupplierId());
					obj.put("text", supp.getSupplierName());
				array.add(obj);
			}
			if(array.size() > 0) {
				model.addAttribute("suppJsonList", array.toString());
			}
		}
	}	
	
	/**
	 * 获得商品列表
	 * 
	 * @param model
	 * @param page
	 *            分页参数
	 * @param suppGoods
	 *            查询条件
	 * @param req
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/findSuppGoodsList")
	public String findSuppGoodsList(Model model, Integer page, SuppGoods suppGoods, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<findSuppGoodsList>");
		}
		TreeMap branchIdMap = new TreeMap<String, List>(new Comparator() {
			@Override
			public int compare(Object o1, Object o2) {
				// 如果有空值，直接返回0
				if ((o1 == null) || (o2 == null)) {
					return 0;
				}
				String ck1 = String.valueOf(o1);
				String ck2 = String.valueOf(o2);
				return ck1.compareTo(ck2);
			}
		});
		List<BizBranch> bizBranchList = new ArrayList<BizBranch>();
		if(suppGoods != null && suppGoods.getProdProduct()!=null && suppGoods.getProdProduct().getBizCategory() !=null){
			Map<String, Object> parBizBranch = new HashMap<String, Object>();
			parBizBranch.put("categoryId", suppGoods.getProdProduct().getBizCategory().getCategoryId());
			parBizBranch.put("cancelFlag", "Y");
			parBizBranch.put("_orderby", "ATTACH_FLAG desc, BRANCH_ID desc");
			bizBranchList = MiscUtils.autoUnboxing( branchService.findBranchListByParams(parBizBranch) );
		}
		
		if(bizBranchList.size()>0){
			int sort = 1;
			for (BizBranch bizBranch : bizBranchList) {
				String bizBranchKey = "";
				if ("Y".equals(bizBranch.getAttachFlag())) {
					bizBranchKey = sort+ "<h2 class='fl'>" + bizBranch.getBranchName() + "</h2> (主规格)_"+bizBranch.getBranchId();
				} else {
					bizBranchKey = sort+ "<h2 class='fl'>" + bizBranch.getBranchName() + "</h2> (次规格)_"+bizBranch.getBranchId();
				}
				branchIdMap.put(bizBranchKey, bizBranch.getBranchId());
				++sort;
			}
		}
		
		Iterator it = branchIdMap.entrySet().iterator();
		while (it.hasNext()) {
			Map.Entry pairs = (Map.Entry) it.next();
			Map<String, Object> parameprodProductBranch = new HashMap<String, Object>();
			parameprodProductBranch.put("branchId", pairs.getValue());
			parameprodProductBranch.put("productId", suppGoods.getProdProduct().getProductId());
			List<ProdProductBranch> prodProductBranchList = prodProductBranchService.findProdProductBranchList(parameprodProductBranch);
			List<SuppGoods> suppGoodsListArray = new ArrayList<SuppGoods>();
			if(prodProductBranchList!=null && prodProductBranchList.size()>0){
				for (ProdProductBranch prodProductBranch : prodProductBranchList) {
					Map<String, Object> parSuppGoods = new HashMap<String, Object>();
					parSuppGoods.put("productId", suppGoods.getProductId());
					parSuppGoods.put("supplierId", suppGoods.getSupplierId());
					parSuppGoods.put("productBranchId", prodProductBranch.getProductBranchId());

					parSuppGoods.put("_orderby", "PRODUCT_BRANCH_ID desc, SUPP_GOODS_ID desc");
					List<SuppGoods> suppGoodsList = MiscUtils.autoUnboxing( suppGoodsService.findSuppGoodsList(parSuppGoods) );
					if(suppGoodsList!=null && suppGoodsList.size()>0){
						for (SuppGoods sg : suppGoodsList) {
							sg.setProdProductBranch(prodProductBranch);
							suppGoodsListArray.add(sg);
						}
					}
				}
			}
			
			if(suppGoodsListArray.size()>0){
				Set<Long> manageIds = new HashSet<Long>();
				Set<Long> contentManagerIds = new HashSet<Long>();
				for (SuppGoods sc : suppGoodsListArray) {
					if (sc.getContractId() != null && sc.getContractId() > 0) {
						SuppContract suppContract = suppContractService.findSuppContractById(sc.getContractId());
						sc.setSuppContract(suppContract);
						manageIds.add(sc.getManagerId());
					}
					contentManagerIds.add(sc.getContentManagerId());
				}
				//设置产品经理
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userIds", manageIds.toArray());
				params.put("maxResults", 100);
				params.put("skipResults", 0);
				
				List<PermUser> permUserList = permUserServiceAdapter.queryPermUserByParam(params);
				for (PermUser permUser : permUserList) {
					for (SuppGoods suppGoods1 : suppGoodsListArray) {
						if (suppGoods1.getManagerId()!=null&&suppGoods1.getManagerId().equals(permUser.getUserId())) {
							suppGoods1.setManagerName(permUser.getRealName());
						}
					}
				}	
				//设置内容维护人员
				params.put("userIds", contentManagerIds.toArray());
				List<PermUser> contentManagerList = permUserServiceAdapter.queryPermUserByParam(params);
				for (PermUser permUser : contentManagerList) {
					for (SuppGoods suppGoods1 : suppGoodsListArray) {
						if (suppGoods1 !=null&&suppGoods1.getContentManagerId()!=null&&suppGoods1.getContentManagerId().equals(permUser.getUserId())) {
							suppGoods1.setContentManagerName(permUser.getRealName());
						}
					}
				}
			}
			branchIdMap.put(pairs.getKey(), suppGoodsListArray);
			
		}
		
		
		
		
		// 支付对象
		model.addAttribute("payTargetList", SuppGoods.PAYTARGET.values());
		if (suppGoods != null && suppGoods.getSuppContract()!=null && suppGoods.getSuppContract().getContractId()!=null) {
			SuppContract suppContract = new SuppContract();
			suppContract.setContractId(suppGoods.getSuppContract().getContractId());
			suppContract.setContractName(suppContractService.findSuppContractById(suppGoods.getSuppContract().getContractId()).getContractName());
			suppGoods.setSuppContract(suppContract);
		}
		Map<String, Object> parameprodProductBranch = new HashMap<String, Object>();
		if(suppGoods != null && suppGoods.getProdProduct() != null){
		    parameprodProductBranch.put("productId", suppGoods.getProdProduct().getProductId());
		}
		List<ProdProductBranch> prodProductBranchList = prodProductBranchService.findProdProductBranchList(parameprodProductBranch);
		model.addAttribute("prodProductBranchList", prodProductBranchList);
		model.addAttribute("suppGoods", suppGoods);
		model.addAttribute("suppGoodsMap", branchIdMap);
		selectExistsSupplier(model, suppGoods.getProdProduct().getProductId());

		return "/goods/goods/findSuppGoodsList";
	}

	/**
	 * 跳转到修改页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/showUpdateSuppGoods")
	public String showUpdateSuppGoods(Model model, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showUpdateSuppGoods>");
		}
		List<ProdProductBranch> prodProductBranchList = null;
		Map goodsTypeMap = new HashMap();
		SuppGoods suppGoods = null;
		if (StringUtils.isNotBlank(req.getParameter("suppGoodsId")) && StringUtils.isNotBlank(req.getParameter("productId")) && StringUtils.isNotBlank(req.getParameter("supplierId"))) {
			Map<String, Object> paramProdProductBranch = new HashMap<String, Object>();
			paramProdProductBranch.put("productId", String.valueOf(req.getParameter("productId")));
			prodProductBranchList = prodProductBranchService.findProdProductBranchList(paramProdProductBranch);
			suppGoods = MiscUtils.autoUnboxing( suppGoodsService.findSuppGoodsById(Long.valueOf(req.getParameter("suppGoodsId")), Boolean.FALSE, Boolean.FALSE) );
			Long contentManagerId = suppGoods.getContentManagerId();
			if (contentManagerId!=null) {
				PermUser user = permUserServiceAdapter.getPermUserByUserId(contentManagerId);
				if(user!=null)
					model.addAttribute("contentManagerName", user.getRealName());
				else
					model.addAttribute("contentManagerName", "");
			}
			//设置产品经理
			PermUser manager = permUserServiceAdapter.getPermUserByUserId(suppGoods.getManagerId());
				if(null != manager){
					suppGoods.setManagerName(manager.getRealName());
				}
			// 支付对象
			model.addAttribute("payTargetList", SuppGoods.PAYTARGET.values());
			// 分公司
			model.addAttribute("filialeList", CommEnumSet.FILIALE_NAME.values());
			// BU
			model.addAttribute("buList", bizBuEnumClientService.getAllBizBuEnumList().getReturnContent());
			// 商品类型
			model.addAttribute("goodsTypeList", SuppGoods.GOODSTYPE.values());
			// 寄件方
			model.addAttribute("expressTypeList", SuppGoods.EXPRESSTYPE.values());
			// 通知方式
			model.addAttribute("noticeTypeList", SuppGoods.NOTICETYPE.values());
			if (StringUtils.isNotBlank(req.getParameter("categoryId"))) {
				Map<String, Object> paramSuppFax = new HashMap<String, Object>();
				paramSuppFax.put("supplierId", Long.valueOf(req.getParameter("supplierId")));
				paramSuppFax.put("categoryId", Long.valueOf(req.getParameter("categoryId")));
				paramSuppFax.put("cancelFlag", "Y");// 有效定义
				List<SuppFaxRule> suppFaxRuleList = MiscUtils.autoUnboxing( suppFaxService.findSuppFaxRuleList(paramSuppFax) );
				model.addAttribute("suppFaxRuleList", suppFaxRuleList);
				model.addAttribute("categoryId", req.getParameter("categoryId"));
			}

			//载入全部分销商
			loadDistributors(model);
			//载入选中的分销商
			loadSelectedDistributors(suppGoods,model);

		}
		model.addAttribute("goodsTypeMap", goodsTypeMap);
		model.addAttribute("suppGoods", suppGoods);
		model.addAttribute("prodProductBranchList", prodProductBranchList);
		
		// 公司主体
		/*Map<String, String> companyTypeMap = new HashMap<String, String>();
		for (COMPANY_TYPE_DIC item : COMPANY_TYPE_DIC.values()) {
			companyTypeMap.put(item.name(), item.getTitle());
		}
		model.addAttribute("companyTypeMap", companyTypeMap);
		*/
		
		//结算主体类型	
		model.addAttribute("lvAccSubjectList",SuppSettleRule.LVACC_SUBJECT.values());
		
		return "/goods/goods/showUpdateSuppGoods";
	}

	/**
	 * 跳转到添加商品
	 * 
	 * @return
	 */
	@RequestMapping(value = "/showAddSuppGoods")
	public String showAddSuppGoods(Model model, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showAddSuppGoods>");
		}
		List<ProdProductBranch> prodProductBranchList = null;
		SuppGoods suppGoods = null;
		Map goodsTypeMap = new HashMap();
		if (StringUtils.isNotBlank(req.getParameter("productId")) && StringUtils.isNotBlank(req.getParameter("supplierId"))) {
			Map<String, Object> paramProdProductBranch = new HashMap<String, Object>();
			paramProdProductBranch.put("productId", String.valueOf(req.getParameter("productId")));
			paramProdProductBranch.put("cancelFlag", "Y");
			prodProductBranchList = prodProductBranchService.findProdProductBranchList(paramProdProductBranch);
			suppGoods = new SuppGoods();
			SuppSupplier suppSupplier = new SuppSupplier();
			suppSupplier.setSupplierId(Long.valueOf(req.getParameter("supplierId")));
			suppGoods.setSuppSupplier(suppSupplier);
			ProdProduct prodProduct = new ProdProduct();
			prodProduct.setProductId(Long.valueOf(req.getParameter("productId")));
			suppGoods.setProdProduct(prodProduct);
			if (StringUtils.isNotBlank(req.getParameter("contentManagerId"))) {
				suppGoods.setContentManagerId(Long.valueOf(req.getParameter("contentManagerId")));
				suppGoods.setContentManagerName(req.getParameter("contentManagerName"));
			}
			if (StringUtils.isNotBlank(req.getParameter("contractId"))) {
				SuppContract suppContract = new SuppContract();
				suppContract.setContractId(Long.valueOf(req.getParameter("contractId")));
				suppContract.setContractName(suppContractService.findSuppContractById(Long.valueOf(req.getParameter("contractId"))).getContractName());
				suppGoods.setSuppContract(suppContract);
			}
			if (StringUtils.isNotBlank(req.getParameter("productBranchId"))) {
				ProdProductBranch prodProductBranch = new ProdProductBranch();
				prodProductBranch.setProductBranchId(Long.valueOf(req.getParameter("productBranchId")));
				suppGoods.setProdProductBranch(prodProductBranch);
			}
			// 支付对象
			model.addAttribute("payTargetList", SuppGoods.PAYTARGET.values());
			// 分公司
			model.addAttribute("filialeList", CommEnumSet.FILIALE_NAME.values());
			// BU
			model.addAttribute("buList", bizBuEnumClientService.getAllBizBuEnumList().getReturnContent());
			// 商品类型
			model.addAttribute("goodsTypeList", SuppGoods.GOODSTYPE.values());
			// 寄件方
			model.addAttribute("expressTypeList", SuppGoods.EXPRESSTYPE.values());
			// 通知方式
			model.addAttribute("noticeTypeList", SuppGoods.NOTICETYPE.values());
			if (StringUtils.isNotBlank(req.getParameter("categoryId"))) {
				Map<String, Object> paramSuppFax = new HashMap<String, Object>();
				paramSuppFax.put("supplierId", Long.valueOf(req.getParameter("supplierId")));
				paramSuppFax.put("categoryId", Long.valueOf(req.getParameter("categoryId")));
				paramSuppFax.put("cancelFlag", "Y");// 有效定义
				List<SuppFaxRule> suppFaxRuleList = MiscUtils.autoUnboxing( suppFaxService.findSuppFaxRuleList(paramSuppFax) );
				model.addAttribute("suppFaxRuleList", suppFaxRuleList);
				model.addAttribute("categoryId", req.getParameter("categoryId"));
			}
			//载入分销商
			loadDistributors(model);
		}
		model.addAttribute("goodsTypeMap", goodsTypeMap);
		model.addAttribute("suppGoods", suppGoods);
		model.addAttribute("prodProductBranchList", prodProductBranchList);
		
		// 公司主体
		/*Map<String, String> companyTypeMap = new HashMap<String, String>();
		for (COMPANY_TYPE_DIC item : COMPANY_TYPE_DIC.values()) {
			companyTypeMap.put(item.name(), item.getTitle());
		}
		model.addAttribute("companyTypeMap", companyTypeMap);*/
		
		//结算主体类型	
		model.addAttribute("lvAccSubjectList",SuppSettleRule.LVACC_SUBJECT.values());
				
		return "/goods/goods/showAddSuppGoods";
	}

	//载入全部供应商
	private void loadDistributors(Model model){
		//销售渠道
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("cancelFlag", "Y");
		List<Distributor> distributors = distributorService.findDistributorList(params).getReturnContent();
		model.addAttribute("distributorList", distributors);
		//加载分销渠道的分销商
		ResultHandleT<TntGoodsChannelVo> tntGoodsChannelVoRt = tntGoodsChannelCouponServiceRemote
				.getChannels(TntGoodsChannelCouponAdapter.CH_TYPE.NONE.name());
		if(tntGoodsChannelVoRt != null && tntGoodsChannelVoRt.getReturnContent() != null){
			TntGoodsChannelVo tntGoodsChannelVo = (TntGoodsChannelVo)tntGoodsChannelVoRt.getReturnContent();
			model.addAttribute("tntGoodsChannelVo", tntGoodsChannelVo);
		}
	}

	//载入选中的供应商
	private void loadSelectedDistributors(SuppGoods suppGoods,Model model){
		// 取得产品对应的销售渠道信息
		Map<String, Object> paraDistDistributorSuppGoods = new HashMap<String, Object>();
		paraDistDistributorSuppGoods.put("suppGoodsId", suppGoods.getSuppGoodsId());
		suppGoods.setDistDistributorGoods(distributorGoodsService.findDistDistributorGoodsList(paraDistDistributorSuppGoods));

		ResultHandleT<Long[]> userIdLongRt = tntGoodsChannelCouponServiceRemote.list(suppGoods.getProductId(),
				suppGoods.getSuppGoodsId(), TntGoodsChannelCouponAdapter.PG_TYPE.GOODS.name());
		if(userIdLongRt != null && userIdLongRt.getReturnContent() != null && userIdLongRt.isSuccess()){
			Long[] userIdLong = (Long[])userIdLongRt.getReturnContent();
			StringBuilder userIdLongStr = new StringBuilder(",");
			for(Long userId : userIdLong){
				userIdLongStr.append(userId.toString()).append(",");
			}
			model.addAttribute("userIdLongStr", userIdLongStr.toString());
		}
	}

	/**
	 * 更新产品
	 */
	@RequestMapping(value = "/updateSuppGoods")
	@ResponseBody
	public Object updateSuppGoods(SuppGoods suppGoods,HttpServletRequest req,String distributorUserIds) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<updateSuppGoods>");
		}
		if (suppGoods != null) {
				if(null != suppGoods.getManagerId())
				{
					//设置组织ID
					PermUser manager = permUserServiceAdapter.getPermUserByUserId(suppGoods.getManagerId());
					if(null != manager){
						suppGoods.setOrgId(manager.getDepartmentId());
					}
				}
			//获取原商品
			SuppGoods oldSuppGoods = null;
			   oldSuppGoods = MiscUtils.autoUnboxing( suppGoodsService.findSuppGoodsById(suppGoods.getSuppGoodsId(), Boolean.FALSE, Boolean.FALSE) );
		    suppGoods.setCreateTime(oldSuppGoods.getCreateTime());
		    suppGoods.setCreateUser(oldSuppGoods.getCreateUser());
		    suppGoods.setStockApiFlag(oldSuppGoods.getStockApiFlag());
		    suppGoods.setApiFlag(oldSuppGoods.getApiFlag());
			suppGoods.setCancelFlag(oldSuppGoods.getCancelFlag());
			suppGoods.setEbkSupplierGroupId(oldSuppGoods.getEbkSupplierGroupId());
			//判断是否驴妈妈可售
			String[] distributorIds = req.getParameterValues("distributorIds");
			suppGoods.setLvmamaFlag("N");
			suppGoods.setDistributeFlag("N");
			if(distributorIds!=null&&distributorIds.length>0){
				for(String distributorId : distributorIds){
					if("2".equals(distributorId) || "3".equals(distributorId)){
						suppGoods.setLvmamaFlag("Y");
					}
					if("4".equals(distributorId) || "5".equals(distributorId)){
						suppGoods.setDistributeFlag("Y");
					}
				}
			}
			suppGoodsService.updateSuppGoods(suppGoods);
			saveOrUpdateDistributorGoods(suppGoods.getProductId(),suppGoods.getProductBranchId(),suppGoods.getSuppGoodsId(),distributorIds);
			//推送商品的分销商关系给super系统
			distributorGoodsService.pushSuperDistributor(suppGoods, distributorUserIds);

			//获取商品变更日志内容 
			//添加操作日志
				try {
					String logContent = "";
					logContent = getSuppGoodsChangeLog(oldSuppGoods, suppGoods);
					if(null!=logContent && !"".equals(logContent))
					{
					comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
							suppGoods.getProductId(), suppGoods.getSuppGoodsId(), 
							this.getLoginUser().getUserName(), 
							"修改了商品：【"+suppGoods.getGoodsName()+"】,变更内容："+logContent, 
							COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(), 
							"修改商品",null);
					}
				} catch (Exception e) {
					// TODO Auto-generated catch block
					log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
					log.error(e.getMessage());
				}	
		}
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

	/**
	 * 新增产品
	 * 
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/addSuppGoods")
	@ResponseBody
	public Object addSuppGoods(SuppGoods suppGoods,String distributorUserIds) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<addSuppGoods>");
		}
		if (suppGoods != null) {
			if(null != suppGoods.getManagerId())
			{
				//设置组织ID
				PermUser manager = permUserServiceAdapter.getPermUserByUserId(suppGoods.getManagerId());
				if(null != manager){
					suppGoods.setOrgId(manager.getDepartmentId());
				}
			}
			suppGoods.setCreateUser(this.getLoginUserId());
			//判断是否驴妈妈可售
			String[] distributorIds = suppGoods.getDistributorIds().split(",");
			suppGoods.setLvmamaFlag("N");
			suppGoods.setDistributeFlag("N");
			if(distributorIds!=null&&distributorIds.length>0){
				for(String distributorId : distributorIds){
					if("2".equals(distributorId) || "3".equals(distributorId)){
						suppGoods.setLvmamaFlag("Y");
					}
					if("4".equals(distributorId) || "5".equals(distributorId)){
						suppGoods.setDistributeFlag("Y");
					}
				}
			}
			//商品默认设置为有效
			suppGoods.setCancelFlag("Y");
			//如果是非对接酒店走对接流程(长隆对接酒店)
			if(Constant.getInstance().isGetDockeHotelRoute(suppGoods.getSupplierId().toString())){
				suppGoods.setApiFlag("Y");
				suppGoods.setStockApiFlag("Y");
			}

            Map<String, Object> params = new HashMap<String,Object>();
            params.put("supplierId",suppGoods.getSupplierId());
            long groupId = ebkSupplierGroupClientServiceRemote.getEbkSupplierMainGroupIdByParams(params).getReturnContent();
            suppGoods.setEbkSupplierGroupId(groupId);

			Long suppGoodsId = MiscUtils.autoUnboxing( suppGoodsService.addSuppGoods(suppGoods) );
			suppGoods.setSuppGoodsId(suppGoodsId);
			//向中间表插入产品
			ProdProduct prodProduct = prodProductService.getProdProductBy(suppGoods.getProductId());
			if(null != prodProduct && null != suppGoods.getSupplierId())
			{
				suppGoods.setProdProduct(prodProduct);

                //用户组ID维护
                try{
                    if( (null == prodProduct.getEbkSupplierGroupId() || prodProduct.getEbkSupplierGroupId() == 0 ) && (prodProduct.getBizCategoryId() != null && prodProduct.getBizCategoryId() != 1)){
                        prodProduct.setEbkSupplierGroupId(groupId);
                        prodProductService.updateProdProduct(prodProduct);
                    }
                }catch(Exception e){
                    log.error("user group id add fail : " , e);
                }
			}

			// 新增商品的分销渠道
			saveOrUpdateDistributorGoods(suppGoods.getProductId(),suppGoods.getProductBranchId(),suppGoods.getSuppGoodsId(),distributorIds);
			//推送商品的分销商关系给super系统
			distributorGoodsService.pushSuperDistributor(suppGoods, distributorUserIds);
			//添加操作日志
			try {
				comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
						suppGoods.getProductId(), suppGoods.getSuppGoodsId(), 
						this.getLoginUser().getUserName(), 
						"添加了商品：【"+suppGoods.getGoodsName()+"】", 
						COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(), 
						"新增商品",null);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
				log.error(e.getMessage());
			}	
		}
		return ResultMessage.ADD_SUCCESS_RESULT;
	}


	// 修改或保存产品与渠道对应关系
	private void saveOrUpdateDistributorGoods(Long productId, Long productBranchId, Long suppGoodsId,String[] distributorIds){
		if(log.isDebugEnabled()){
			LOG.debug("start method<saveOrUpdateDistributorGoods>.......");
		}
		if(null!=suppGoodsId && suppGoodsId>0){
			boolean saveOrUpdate = false;
			if(null!=distributorIds && distributorIds.length>0){
				Long[] ids = new Long[distributorIds.length];
				for (int i = 0; i < distributorIds.length; i++) {
					if(StringUtil.isNumber(distributorIds[i])){
						ids[i] = Long.valueOf(distributorIds[i]);
						saveOrUpdate = true;
					}
				}
				if(saveOrUpdate){
					distributorGoodsService.saveOrUpdateDistDistributorGoods(productId, productBranchId, suppGoodsId, ids);
				}
			}
			if(!saveOrUpdate){
				// 没有选择商品对应的销售渠道
				Map<String,Object> params = new HashMap<String, Object>();
				params.put("suppGoodsId", suppGoodsId);
				distributorGoodsService.deleteDistDistributorGoods(params);
			}
		}
	}

	/**
	 * 设置行政区的有效性
	 * 
	 * @return
	 */
	@RequestMapping(value = "/cancelProduct")
	@ResponseBody
	public Object cancelProduct(SuppGoods suppGoods,Long groupId) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<cancelProduct>");
		}

		if ((suppGoods != null) && "Y".equals(suppGoods.getCancelFlag())) {
			suppGoods.setCancelFlag("Y");
		} else if ((suppGoods != null) && "N".equals(suppGoods.getCancelFlag())) {
			suppGoods.setCancelFlag("N");
		} else {
			return new ResultMessage("error", "设置失败,无效参数");
		}

		int s = MiscUtils.autoUnboxing( suppGoodsService.updateCancelFlag(suppGoods) );
		//SuppGoods sg =  suppGoodsService.selectByPrimaryKey(suppGoods.getSuppGoodsId());
		//suppGoodsTimePrice.updateGruopStockBySuppGoods(suppGoods,sg.getGroupId());
		
		//s等于-1表示酒套餐商品有无效的关联商品
		if(s == -1){
			return ResultMessage.SET_EXP_RELATED_RESULT;
		}
		
		//添加操作日志
		try {
			String key ="";
			if("Y".equals(suppGoods.getCancelFlag()))
			{
				key = "有效";
			}
			else
			{
				key = "无效";
			}
			comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
					suppGoods.getProductId(), suppGoods.getSuppGoodsId(), 
					this.getLoginUser().getUserName(), 
					"修改了商品的行政区域有效性为:"+key, 
					COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(), 
					"修改商品有效性",null);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
			log.error(e.getMessage());
		}	
//		petProdGoodsAdapter.updatePetSuppGoodsCancel(suppGoods.getSuppGoodsId());
		return ResultMessage.SET_SUCCESS_RESULT;
	}
	/**
	 * 设置上架下架
	 * 
	 * @return
	 */
	@RequestMapping(value = "/onlineProduct")
	@ResponseBody
	public Object onlineProduct(SuppGoods suppGoods) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<onlineProduct>");
		}

		if ((suppGoods != null) && "Y".equals(suppGoods.getOnlineFlag())) {
			suppGoods.setOnlineFlag("Y");
		} else if ((suppGoods != null) && "N".equals(suppGoods.getOnlineFlag())) {
			suppGoods.setOnlineFlag("N");
		} else {
			return new ResultMessage("error", "设置失败,无效参数");
		}

		suppGoodsService.updateOnlineFlag(suppGoods, true);
		//添加操作日志
		try {
			String key ="";
			if("Y".equals(suppGoods.getOnlineFlag()))
			{
				key = "上架";
			}
			else
			{
				key = "下架";
			}
				comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
				suppGoods.getProductId(), suppGoods.getSuppGoodsId(), 
				this.getLoginUser().getUserName(), 
				"商品编号：【"+suppGoods.getSuppGoodsId()+"】上架属性为："+key,
				COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(), 
				"修改商品上下架属性",null);
			 } catch (Exception e) {
					// TODO Auto-generated catch block
					log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
					log.error(e.getMessage());
			 }	
		return ResultMessage.SET_SUCCESS_RESULT;
	}
	
	/**
	 * 根据供应商ID查询商品列表并返回JSON对象
	 * @param model
	 * @param supplierId
	 * @param req
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/findSuppGoodsJson")
	@ResponseBody
	public Object findSuppGoodsJson(Model model,Long supplierId,Long productId, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<findSuppGoodsJson>");
		}
		List<SupplierGoodsVO> suppGoodsList = null;
		if(supplierId!=null){
			Map<String,Object> params = new HashMap<String,Object>();
			params.put("supplierId", supplierId);
			params.put("productId", productId);
			suppGoodsList =  suppGoodsService.findSupplierGoodsList(params);
		}
		return suppGoodsList;
	}
	
	
    private String getSuppGoodsChangeLog(SuppGoods oldSuppGoods, SuppGoods newSuppGoods) {
        StringBuffer logStr = new StringBuffer("");
        if (null != newSuppGoods) {
            logStr.append(ComLogUtil.getLogTxt("商品名称", newSuppGoods.getGoodsName(), oldSuppGoods.getGoodsName()));
            logStr.append(ComLogUtil.getLogTxt("是否有效", "Y".equals(newSuppGoods.getCancelFlag()) ? "是" : "否",
                    "Y".equals(oldSuppGoods.getCancelFlag()) ? "是" : "否"));
            if (!newSuppGoods.getLvmamaFlag().equals(oldSuppGoods.getLvmamaFlag())) {
                logStr.append(ComLogUtil.getLogTxt("是否驴妈妈可售", "Y".equals(newSuppGoods.getLvmamaFlag()) ? "是" : "否",
                        null));
            }
            if (!newSuppGoods.getDistributeFlag().equals(oldSuppGoods.getDistributeFlag())) {
                logStr.append(ComLogUtil.getLogTxt("是否可分销", "Y".equals(newSuppGoods.getDistributeFlag()) ? "是" : "否",
                        null));
            }

            // 内容维护人员
            if (!newSuppGoods.getContentManagerId().equals(oldSuppGoods.getContentManagerId())) {
                Long contentManagerId = oldSuppGoods.getContentManagerId();
                if (contentManagerId != null) {
                    PermUser user = permUserServiceAdapter.getPermUserByUserId(contentManagerId);
                    logStr.append(ComLogUtil.getLogTxt("内容维护人员", newSuppGoods.getContentManagerName(),
                            user.getRealName()));
                }
            }
            // 商品合同
            if (!newSuppGoods.getContractId().equals(oldSuppGoods.getSuppContract().getContractId())) {
                logStr.append(ComLogUtil.getLogTxt("商品合同", newSuppGoods.getSuppContract().getContractName(),
                        oldSuppGoods.getSuppContract().getContractName()));
            }
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
                logStr.append(ComLogUtil.getLogTxt("是否仅组合销售", "Y".equals(newSuppGoods.getPackageFlag()) ? "是" : "否",
                        null));
            }
            // 是否使用传真
            if (!newSuppGoods.getFaxFlag().equals(oldSuppGoods.getFaxFlag())) {
                logStr.append(ComLogUtil.getLogTxt("是否使用传真", "Y".equals(newSuppGoods.getFaxFlag()) ? "是" : "否", null));
            }
            // 最少起订份数/间数
            logStr.append(ComLogUtil.getLogTxt("最少起订份数/间数", newSuppGoods.getMinQuantity().toString(), oldSuppGoods
                    .getMinQuantity().toString()));
            logStr.append(ComLogUtil.getLogTxt("最多订购份数/间数", newSuppGoods.getMaxQuantity().toString(), oldSuppGoods
                    .getMaxQuantity().toString()));
            logStr.append(ComLogUtil.getLogTxt("最少入住天数", newSuppGoods.getMinStayDay().toString(), oldSuppGoods
                    .getMinStayDay().toString()));
            logStr.append(ComLogUtil.getLogTxt("最多入住天数", newSuppGoods.getMaxStayDay().toString(), oldSuppGoods
                    .getMaxStayDay().toString()));
            
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

            }else {
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
}
