package com.lvmama.vst.back.goods.web.traffic;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
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

import org.apache.commons.collections.CollectionUtils;
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
import com.lvmama.vst.back.biz.po.BizOrderRequired;
import com.lvmama.vst.back.client.biz.service.BranchClientService;
import com.lvmama.vst.back.client.biz.service.BizBuEnumClientService;
import com.lvmama.vst.back.dist.po.DistDistributorGoods;
import com.lvmama.vst.back.dist.po.Distributor;
import com.lvmama.vst.back.dist.service.DistributorCachedService;
import com.lvmama.vst.back.dist.service.DistributorGoodsService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.goods.po.SuppGoodsBaseTimePrice;
import com.lvmama.vst.back.goods.po.SuppGoodsBus;
import com.lvmama.vst.back.goods.po.SuppGoodsRefund;
import com.lvmama.vst.back.client.goods.service.SuppGoodsBusClientService;
import com.lvmama.vst.back.goods.service.SuppGoodsRefundService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.goods.vo.SuppGoodsParam;
import com.lvmama.vst.back.goods.vo.SupplierGoodsVO;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductBranch;
import com.lvmama.vst.back.prod.po.ProdTraffic;
import com.lvmama.vst.back.prod.service.ProdProductBranchService;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.client.prod.service.ProdTrafficClientService;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.pub.po.ComOrderRequired;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.pub.service.ComOrderRequiredClientService;
import com.lvmama.vst.back.supp.po.SuppContract;
import com.lvmama.vst.back.supp.po.SuppFaxRule;
import com.lvmama.vst.back.supp.po.SuppSettleRule;
import com.lvmama.vst.back.supp.po.SuppSettlementEntities;
import com.lvmama.vst.back.supp.po.SuppSupplier;
import com.lvmama.vst.back.client.supp.service.SuppContractClientService;
import com.lvmama.vst.back.supp.service.SuppFaxService;
import com.lvmama.vst.back.supp.service.SuppSettlementEntitiesService;
import com.lvmama.vst.back.client.supp.service.SuppSupplierClientService;
import com.lvmama.vst.comm.enumeration.CommEnumSet;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.flight.client.goods.service.SuppGoodsFlightClientService;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;
import com.lvmama.vst.pet.adapter.TntGoodsChannelCouponAdapter;
import com.lvmama.vst.back.utils.MiscUtils;

/**
 * 商品维护管理Action
 * 
 * @author qiujiehong
 * @date 2013-10-11
 */
@Controller
@RequestMapping("/goods/traffic")
public class TrafficSuppGoodsAction extends BaseActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 5576904778178181774L;

	private static final Log LOG = LogFactory.getLog(TrafficSuppGoodsAction.class);

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
	private SuppFaxService suppFaxService;
	
	@Autowired
	private PermUserServiceAdapter permUserServiceAdapter;
	
	@Autowired
	private BranchClientService branchService;
	
	@Autowired
	private SuppGoodsRefundService suppGoodsRefundService;
	
	@Autowired
	private TntGoodsChannelCouponAdapter tntGoodsChannelCouponServiceRemote;

	@Autowired
	private SuppGoodsFlightClientService suppGoodsFlightClientService;
	
	@Autowired
	private BizBuEnumClientService bizBuEnumClientService;
	
	@Autowired
	private ComOrderRequiredClientService comOrderRequiredService;
	
	@Autowired
	private SuppGoodsBusClientService  suppGoodsBusService;
	
	@Autowired
	private ProdTrafficClientService prodTrafficService;

	@Autowired
	private SuppSettlementEntitiesService suppSettlementEntitiesService; // 结算对象SETTLE_ENTITY_MARK
	
	@RequestMapping(value = "/showSuppGoodsListCheck")
	@ResponseBody
	public Object showSuppGoodsListCheck(HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showSuppGoodsListCheck>");
		}
		ResultMessage message = null;
		if (req.getParameter("productId") != null) {
			ProdProduct prodProduct = prodProductService.getProdProductBy(Long.valueOf(req.getParameter("productId")));
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
	public String showSuppGoodsList(Model model, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showSuppGoodsList>");
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
		return "/goods/traffic/goods/findSuppGoodsList";
	}

	private void selectExistsSupplier(Model model, Long productId) {
		//已经存在的供应商
		List<SuppSupplier> suppSupplierList = MiscUtils.autoUnboxing(suppSupplierService.findSuppSupplierListByProductId(productId));
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
	 * @param prodProduct
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
		String apiFlag = "N";
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
			bizBranchList = MiscUtils.autoUnboxing(branchService.findBranchListByParams(parBizBranch));
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
					List<SuppGoods> suppGoodsList = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsList(parSuppGoods));
					if(suppGoodsList!=null && suppGoodsList.size()>0){
						for (SuppGoods sg : suppGoodsList) {
							sg.setProdProductBranch(prodProductBranch);
							suppGoodsListArray.add(sg);
							apiFlag = sg.getApiFlag();
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
		model.addAttribute("apiFlag", apiFlag);
		model.addAttribute("suppGoodsMap", branchIdMap);
		selectExistsSupplier(model, suppGoods.getProdProduct().getProductId());

		return "/goods/traffic/goods/findSuppGoodsList";
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
		ProdProduct prodProduct = null;
		Map goodsTypeMap = new HashMap();
		SuppGoods suppGoods = null;
		if (StringUtils.isNotBlank(req.getParameter("suppGoodsId")) && StringUtils.isNotBlank(req.getParameter("productId")) && StringUtils.isNotBlank(req.getParameter("supplierId"))) {
			Map<String, Object> paramProdProductBranch = new HashMap<String, Object>();
			paramProdProductBranch.put("productId", String.valueOf(req.getParameter("productId")));
			prodProductBranchList = prodProductBranchService.findProdProductBranchList(paramProdProductBranch);
			
			prodProduct = prodProductService.findProdProductByProductId(Long.valueOf(req.getParameter("productId")));
			
			suppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(Long.valueOf(req.getParameter("suppGoodsId")), Boolean.FALSE, Boolean.FALSE));
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
			// 退款策略
			model.addAttribute("cancelStrategyList", SuppGoodsBaseTimePrice.CANCELSTRATEGYTYPE.values());
			if (StringUtils.isNotBlank(req.getParameter("categoryId"))) {
				Map<String, Object> paramSuppFax = new HashMap<String, Object>();
				paramSuppFax.put("supplierId", Long.valueOf(req.getParameter("supplierId")));
				paramSuppFax.put("categoryId", Long.valueOf(req.getParameter("categoryId")));
				paramSuppFax.put("cancelFlag", "Y");// 有效定义
				List<SuppFaxRule> suppFaxRuleList = suppFaxService.findSuppFaxRuleList(paramSuppFax);
				model.addAttribute("suppFaxRuleList", suppFaxRuleList);
			}
			// 取得退改策略
			Map<String, Object> paramSuppGoodsRefund = new HashMap<String, Object>();
			paramSuppGoodsRefund.put("goodsId", suppGoods.getSuppGoodsId());
			if(suppGoodsRefundService.findSuppGoodsRefundList(paramSuppGoodsRefund).size()>0){
				SuppGoodsRefund  suppGoodsRefund = suppGoodsRefundService.findSuppGoodsRefundList(paramSuppGoodsRefund).get(0);
				model.addAttribute("suppGoodsRefund", suppGoodsRefund);
			}
			
			// 取得产品对应的销售渠道信息
			Map<String, Object> paraDistDistributorSuppGoods = new HashMap<String, Object>();
			paraDistDistributorSuppGoods.put("suppGoodsId", suppGoods.getSuppGoodsId());
			suppGoods.setDistDistributorGoods(distributorGoodsService.findDistDistributorGoodsList(paraDistDistributorSuppGoods));
			// 分销商列表
			Map<String, Object> paramDistributor = new HashMap<String, Object>();
			paramDistributor.put("cancelFlag", "Y");
			paramDistributor.put("_orderby", "DISTRIBUTOR_ID");
			paramDistributor.put("_order", "ASC");
			 ResultHandleT<List<Distributor>>  dist_result=distributorService.findDistributorList(paramDistributor);
			 if(dist_result!=null&&dist_result.getReturnContent()!=null){
				List<Distributor> distributorList =dist_result.getReturnContent();
				model.addAttribute("distributorList", distributorList);
			 }
			 
			/*List<Distributor> distributorList = distributorService.findDistributorList(paramDistributor);
			model.addAttribute("distributorList", distributorList);*/
			
			//加载分销渠道的分销商
			ResultHandleT<TntGoodsChannelVo> tntGoodsChannelVoRt = tntGoodsChannelCouponServiceRemote
					.getChannels(TntGoodsChannelCouponAdapter.CH_TYPE.NONE.name());
			if(tntGoodsChannelVoRt != null && tntGoodsChannelVoRt.getReturnContent() != null){
				TntGoodsChannelVo tntGoodsChannelVo = (TntGoodsChannelVo)tntGoodsChannelVoRt.getReturnContent();
				model.addAttribute("tntGoodsChannelVo", tntGoodsChannelVo);
			}
			
			ResultHandleT<Long[]> userIdLongRt = tntGoodsChannelCouponServiceRemote.list(Long.parseLong(req.getParameter("productId")),
					Long.parseLong(req.getParameter("suppGoodsId")), TntGoodsChannelCouponAdapter.PG_TYPE.GOODS.name());
			if(userIdLongRt != null && userIdLongRt.getReturnContent() != null && userIdLongRt.isSuccess()){
				Long[] userIdLong = (Long[])userIdLongRt.getReturnContent();
				StringBuilder userIdLongStr = new StringBuilder(",");
				for(Long userId : userIdLong){
				    userIdLongStr.append(userId.toString()).append(",");
				}
				model.addAttribute("userIdLongStr", userIdLongStr.toString());
			}
		}
		// 公司主体
		/*Map<String, String> companyTypeMap = new HashMap<String, String>();
		for (COMPANY_TYPE_DIC item : COMPANY_TYPE_DIC.values()) {
			companyTypeMap.put(item.name(), item.getTitle());
		}
		model.addAttribute("companyTypeMap", companyTypeMap);*/
		
		// 结算对象SETTLE_ENTITY_MARK
		// 设置结算对象
		SuppSettlementEntities settlementEntity = suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(suppGoods.getSettlementEntityCode());
		suppGoods.setSettlementEntity(settlementEntity);
		
		//结算主体类型	
		model.addAttribute("lvAccSubjectList",SuppSettleRule.LVACC_SUBJECT.values());
		
		model.addAttribute("prodProduct", prodProduct);
				
		model.addAttribute("goodsTypeMap", goodsTypeMap);
		 
		if(prodProduct.getBizCategoryId()==25){
			Map<String, Object> paramBus = new HashMap<String, Object>();
			paramBus.put("suppGoodsId", suppGoods.getSuppGoodsId());
			List<SuppGoodsBus> sBustList=MiscUtils.autoUnboxing(suppGoodsBusService.findSuppGoodsBusList(paramBus));
			if(sBustList!=null&&sBustList.size()>0){
				SuppGoodsBus sBus=sBustList.get(0);
				suppGoods.setSuppGoodsBus(sBus);
			}
		}
		
		model.addAttribute("suppGoods", suppGoods);

		// 其他机票 对接 显示航班号
		String flightNo = "";
		if("Y".equals(suppGoods.getApiFlag()) && suppGoods.getSuppGoodsId() != null){
			ResultHandleT<String> resultHandleT = suppGoodsFlightClientService.getFlightInfosByGoodsId(suppGoods.getSuppGoodsId());
			flightNo = resultHandleT.getReturnContent();
		}
		model.addAttribute("flightNo",flightNo);

		model.addAttribute("prodProductBranchList", prodProductBranchList);
		return "/goods/traffic/goods/showUpdateSuppGoods";
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
			// 退款策略
			model.addAttribute("cancelStrategyList", SuppGoodsBaseTimePrice.CANCELSTRATEGYTYPE.values());
			if (StringUtils.isNotBlank(req.getParameter("categoryId"))) {
				Map<String, Object> paramSuppFax = new HashMap<String, Object>();
				paramSuppFax.put("supplierId", Long.valueOf(req.getParameter("supplierId")));
				paramSuppFax.put("categoryId", Long.valueOf(req.getParameter("categoryId")));
				paramSuppFax.put("cancelFlag", "Y");// 有效定义
				model.addAttribute("categoryId", req.getParameter("categoryId"));
				List<SuppFaxRule> suppFaxRuleList = suppFaxService.findSuppFaxRuleList(paramSuppFax);
				model.addAttribute("suppFaxRuleList", suppFaxRuleList);
			}
			
			// 分销商列表
			Map<String, Object> paramDistributor = new HashMap<String, Object>();
			paramDistributor.put("cancelFlag", "Y");
			paramDistributor.put("_orderby", "DISTRIBUTOR_ID");
			paramDistributor.put("_order", "ASC");
			 ResultHandleT<List<Distributor>>  dist_result=distributorService.findDistributorList(paramDistributor);
			 if(dist_result!=null&&dist_result.getReturnContent()!=null){
				List<Distributor> distributorList =dist_result.getReturnContent();
				model.addAttribute("distributorList", distributorList);
			 }
			//加载分销渠道的分销商
			ResultHandleT<TntGoodsChannelVo> tntGoodsChannelVoRt = tntGoodsChannelCouponServiceRemote
					.getChannels(TntGoodsChannelCouponAdapter.CH_TYPE.NONE.name());
			if(tntGoodsChannelVoRt != null && tntGoodsChannelVoRt.getReturnContent() != null){
				TntGoodsChannelVo tntGoodsChannelVo = (TntGoodsChannelVo)tntGoodsChannelVoRt.getReturnContent();
				model.addAttribute("tntGoodsChannelVo", tntGoodsChannelVo);
			}
		}
		
		// 公司主体
		/*Map<String, String> companyTypeMap = new HashMap<String, String>();
		for (COMPANY_TYPE_DIC item : COMPANY_TYPE_DIC.values()) {
			companyTypeMap.put(item.name(), item.getTitle());
		}
		model.addAttribute("companyTypeMap", companyTypeMap);*/
		
		//结算主体类型	
		model.addAttribute("lvAccSubjectList",SuppSettleRule.LVACC_SUBJECT.values());
		
		//其它巴士
		if (StringUtils.isNotBlank(req.getParameter("categoryId"))&&StringUtils.isNotBlank(req.getParameter("productId"))) {
			if(25==Integer.valueOf(req.getParameter("categoryId"))){
				ProdTraffic traffic = prodTrafficService.selectByProductId(Long.valueOf(req.getParameter("productId")));
				if(traffic.getBackType()!=null && traffic.getToType()!=null){
					traffic.setToBackType("Y");
				}else {
					traffic.setToBackType("N");
				}
				model.addAttribute("traffic", traffic);
			}
		}
		model.addAttribute("goodsTypeMap", goodsTypeMap);
		model.addAttribute("suppGoods", suppGoods);
		model.addAttribute("prodProductBranchList", prodProductBranchList);
		return "/goods/traffic/goods/showAddSuppGoods";
	}

	/**
	 * 更新产品
	 */
	@RequestMapping(value = "/updateSuppGoods")
	@ResponseBody
	public Object updateSuppGoods(SuppGoods suppGoods,SuppGoodsRefund suppGoodsRefund, String distributorUserIds) throws BusinessException {
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
			   oldSuppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoods.getSuppGoodsId(), Boolean.FALSE, Boolean.FALSE));
		    suppGoods.setCreateTime(oldSuppGoods.getCreateTime());
		    suppGoods.setCreateUser(oldSuppGoods.getCreateUser());
		    suppGoods.setStockApiFlag(oldSuppGoods.getStockApiFlag());
		    suppGoods.setApiFlag(oldSuppGoods.getApiFlag());
			suppGoods.setCancelFlag(oldSuppGoods.getCancelFlag());
			suppGoodsService.updateSuppGoods(suppGoods);
			
			if(suppGoods.getCategoryId()!=null&&suppGoods.getCategoryId()==25){
				SuppGoodsBus  sbus=suppGoods.getSuppGoodsBus();
				sbus.setUpdateTime(new Date());
				suppGoodsBusService.updateSuppGoodsBus(sbus);
			}
			
			//更新退改策略
			Map<String, Object> paramSuppGoodsRefund = new HashMap<String, Object>();
			paramSuppGoodsRefund.put("goodsId", suppGoods.getSuppGoodsId());
			if(suppGoodsRefundService.findSuppGoodsRefundList(paramSuppGoodsRefund).size()>0){
				SuppGoodsRefund oldSuppGoodsRefund = suppGoodsRefundService.findSuppGoodsRefundList(paramSuppGoodsRefund).get(0);
				oldSuppGoodsRefund.setCancelStrategy(suppGoodsRefund.getCancelStrategy());
				suppGoodsRefundService.updateSuppGoodsRefundSelective(oldSuppGoodsRefund);
			}else {
				// 设置门票退改策略
				suppGoodsRefund.setGoodsId(suppGoods.getSuppGoodsId());
				suppGoodsRefundService.addSuppGoodsRefund(suppGoodsRefund);
			}
			
			// 修改产品的销售渠道
			
			String distributorNames="";
			if(suppGoods.getDistributorIds()!=null){
				// 分销商列表
				Map<String, Object> paramDistributor = new HashMap<String, Object>();
				paramDistributor.put("cancelFlag", "Y");
				paramDistributor.put("_orderby", "DISTRIBUTOR_ID");
				paramDistributor.put("_order", "ASC");
				List<Distributor> distributorList = null;
				 ResultHandleT<List<Distributor>>  dist_result=distributorService.findDistributorList(paramDistributor);
				 if(dist_result!=null&&dist_result.getReturnContent()!=null){
					 distributorList =dist_result.getReturnContent();
				 }
				 
				// 取得旧产品对应的销售渠道信息
				Map<String, Object> paraDistDistributorSuppGoods = new HashMap<String, Object>();
				paraDistDistributorSuppGoods.put("suppGoodsId", suppGoods.getSuppGoodsId());
				paraDistDistributorSuppGoods.put("_orderby", "DISTRIBUTOR_ID");
				paraDistDistributorSuppGoods.put("_order", "ASC");
				List<DistDistributorGoods> distDistributorGoodsList = distributorGoodsService.findDistDistributorGoodsList(paraDistDistributorSuppGoods);
				
				if(distDistributorGoodsList!=null && distDistributorGoodsList.size()>0){
				    StringBuilder sb = new StringBuilder();
					for (DistDistributorGoods distDistributorGoods : distDistributorGoodsList) {
						for (Distributor distributor : distributorList) {
							if(distributor.getDistributorId().longValue()==distDistributorGoods.getDistributorId().longValue()){
							    sb.append(distributor.getDistributorName()).append(",");
							}
						}
					}
				}
				

				String[] distributorIds = suppGoods.getDistributorIds().split(",");
				if(distributorIds!=null && distributorIds.length>0){
				    StringBuilder sb = new StringBuilder();
					for (String distributorId : distributorIds) {
						for (Distributor distributor : distributorList) {
							if(distributorId.equals(String.valueOf(distributor.getDistributorId()))){
								sb.append(distributor.getDistributorName()).append(",");
							}
						}
					}
					
					if(StringUtils.isNotBlank(sb.toString())){
	                    distributorNames = sb.toString().substring(0, sb.length()-1);
	                }
				}
				
				saveOrUpdateDistributorGoods(suppGoods.getProductId(),suppGoods.getProductBranchId(),suppGoods.getSuppGoodsId(),distributorIds);	
			}
			//推送商品的分销商关系给super系统
			distributorGoodsService.pushSuperDistributor(suppGoods, distributorUserIds);
						
			//获取商品变更日志内容 
			String logContent = "";
			logContent = getSuppGoodsChangeLog(oldSuppGoods, suppGoods);
			if(null!=logContent && !"".equals(logContent))
			{
			//添加操作日志
				try {
					comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
							suppGoods.getProductId(), suppGoods.getSuppGoodsId(), 
							this.getLoginUser().getUserName(), 
							"修改了商品：【"+suppGoods.getGoodsName()+"】,变更内容："+logContent, 
							COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(), 
							"修改商品",null);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
					log.error(e.getMessage());
				}	
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
	public Object addSuppGoods(SuppGoods suppGoods,SuppGoodsRefund suppGoodsRefund, String distributorUserIds) throws BusinessException {
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
			suppGoods.setCancelFlag("Y");
			//自建商品必须为非对接
			suppGoods.setApiFlag("N");
			suppGoodsService.addSuppGoods(suppGoods);
			// 设置门票退改策略
			suppGoodsRefund.setGoodsId(suppGoods.getSuppGoodsId());
			suppGoodsRefundService.addSuppGoodsRefund(suppGoodsRefund);
			
			if(suppGoods.getCategoryId()!=null&&suppGoods.getCategoryId()==25){
				SuppGoodsBus  sbus=suppGoods.getSuppGoodsBus();
				sbus.setSuppGoodsId(suppGoods.getSuppGoodsId());
				sbus.setCreateTime(new Date());
				suppGoodsBusService.addSuppGoodsBus(sbus);
			}
			
			// 新增商品的分销渠道
			if(suppGoods.getDistributorIds()!=null){
				String[] distributorIds = suppGoods.getDistributorIds().split(",");
				saveOrUpdateDistributorGoods(suppGoods.getProductId(),
						suppGoods.getProductBranchId(), suppGoods.getSuppGoodsId(), distributorIds);
			}
			//推送商品的分销商关系给super系统
			distributorGoodsService.pushSuperDistributor(suppGoods, distributorUserIds);
			
			// 结算对象SETTLE_ENTITY_MARK
			String settleEntityLogText = null;
			if(StringUtils.isNotEmpty(suppGoods.getSettlementEntityCode())){
				SuppSettlementEntities settlementEntity = suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(suppGoods.getSettlementEntityCode());
				if(null!=settlementEntity){
					settleEntityLogText = " ; 【 绑定结算对象 】："+settlementEntity.getName()+" , 【  绑定结算对象CODE 】"+settlementEntity.getCode();
				}else{
					settleEntityLogText = " ; 【 未找到可绑定结算对象 】";
				}
			}else{
				settleEntityLogText = "; 【 绑定结算对象CODE 为空，无法绑定 】";
			}
			
			//添加操作日志
			try {
				comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
						suppGoods.getProductId(), suppGoods.getSuppGoodsId(), 
						this.getLoginUser().getUserName(), 
						"添加了商品：【"+suppGoods.getGoodsName()+"】"+settleEntityLogText, // 结算对象SETTLE_ENTITY_MARK
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

	/**
	 * 设置行政区的有效性
	 * 
	 * @return
	 */
	@RequestMapping(value = "/cancelProduct")
	@ResponseBody
	public Object cancelProduct(SuppGoods suppGoods) throws BusinessException {
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

		suppGoodsService.updateCancelFlag(suppGoods);
		
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
	
	
	private String getSuppGoodsChangeLog(SuppGoods oldSuppGoods,SuppGoods newSuppGoods){
		 StringBuffer logStr = new StringBuffer("");
		 if(null!= newSuppGoods)
		 {
			 logStr.append(ComLogUtil.getLogTxt("商品名称",newSuppGoods.getGoodsName(),oldSuppGoods.getGoodsName()));
			 logStr.append(ComLogUtil.getLogTxt("是否有效","Y".equals(newSuppGoods.getCancelFlag())?"是":"否","Y".equals(oldSuppGoods.getCancelFlag())?"是":"否"));
             
			 //内容维护人员
			 if(!newSuppGoods.getContentManagerId().equals(oldSuppGoods.getContentManagerId())){
			
					Long contentManagerId = oldSuppGoods.getContentManagerId();
					if (contentManagerId!=null) {
						PermUser user = permUserServiceAdapter.getPermUserByUserId(contentManagerId);
						 logStr.append(ComLogUtil.getLogTxt("内容维护人员",newSuppGoods.getContentManagerName(),user.getRealName()));
					}
			 }
			 //商品合同
			 if(!newSuppGoods.getContractId().equals(oldSuppGoods.getSuppContract().getContractId())){
				 logStr.append(ComLogUtil.getLogTxt("商品合同",newSuppGoods.getSuppContract().getContractName(),oldSuppGoods.getSuppContract().getContractName()));
			 }
			 
			 // 结算对象SETTLE_ENTITY_MARK
			 // 结算对象
			if (!newSuppGoods.getSettlementEntityCode().equals(
					oldSuppGoods.getSettlementEntityCode())) {
				SuppSettlementEntities newSettleEntity = suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(newSuppGoods.getSettlementEntityCode());
				SuppSettlementEntities oldSettleEntity = suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(oldSuppGoods.getSettlementEntityCode());
				if (null != newSettleEntity && null != oldSettleEntity) {
					logStr.append(ComLogUtil.getLogTxt("结算对象", newSettleEntity.getName(), oldSettleEntity.getName()));
					logStr.append(ComLogUtil.getLogTxt("结算对象CODE", newSuppGoods.getSettlementEntityCode(), oldSuppGoods.getSettlementEntityCode()));
				}
			}
			
			 if(!newSuppGoods.getPayTarget().equals(oldSuppGoods.getPayTarget()))
			 {
				 String newValue = "";
				 String oldValue = "";
				 newValue = SuppGoods.PAYTARGET.getCnName(newSuppGoods.getPayTarget());
				 oldValue = SuppGoods.PAYTARGET.getCnName(oldSuppGoods.getPayTarget());
				 logStr.append(ComLogUtil.getLogTxt("支付对象",newValue,oldValue));
			 }
			 if(!newSuppGoods.getFiliale().equals(oldSuppGoods.getFiliale()))
			 {
				 String newValue = "";
				 String oldValue = "";
				 newValue = CommEnumSet.FILIALE_NAME.getCnName(newSuppGoods.getFiliale());
				 oldValue = CommEnumSet.FILIALE_NAME.getCnName(oldSuppGoods.getFiliale());
				 logStr.append(ComLogUtil.getLogTxt("分公司",newValue,oldValue));
			 }
			 //是否仅组合销售
			 if(!newSuppGoods.getPackageFlag().equals(oldSuppGoods.getPackageFlag()))
			 {
				 logStr.append(ComLogUtil.getLogTxt("是否仅组合销售","Y".equals(newSuppGoods.getPackageFlag())?"是":"否",null));
			 }
			 //是否使用传真
			 if(!newSuppGoods.getFaxFlag().equals(oldSuppGoods.getFaxFlag()))
			 {
				 logStr.append(ComLogUtil.getLogTxt("是否使用传真","Y".equals(newSuppGoods.getFaxFlag())?"是":"否",null));
			 }
			 //最少起订份数/间数
			 logStr.append(ComLogUtil.getLogTxt("最少起订份数/间数",newSuppGoods.getMinQuantity().toString(),oldSuppGoods.getMinQuantity().toString()));
			 logStr.append(ComLogUtil.getLogTxt("最多订购份数/间数",newSuppGoods.getMaxQuantity().toString(),oldSuppGoods.getMaxQuantity().toString()));
			 
			 //其它巴士
			 if(oldSuppGoods.getCategoryId()==25L){
				 SuppGoodsBus  newBus=newSuppGoods.getSuppGoodsBus();
				 SuppGoodsBus  oldBus=oldSuppGoods.getSuppGoodsBus();
				 if(newBus==null){
					 newBus=new SuppGoodsBus();
				 }
				 if(oldBus==null){
					 oldBus=new SuppGoodsBus();
				 }
				 logStr.append(ComLogUtil.getLogTxt("班次",newBus.getToNumberOfRuns(),oldBus.getToNumberOfRuns()));
				 logStr.append(ComLogUtil.getLogTxt("出发时间",newBus.getToDepartureTime(),oldBus.getToDepartureTime()));
				 logStr.append(ComLogUtil.getLogTxt("行程时间",newBus.getToTravelTime(),oldBus.getToTravelTime()));
				 
				 logStr.append(ComLogUtil.getLogTxt("返程班次",newBus.getBackNumberOfRuns(),oldBus.getBackNumberOfRuns()));
				 logStr.append(ComLogUtil.getLogTxt("返程出发时间",newBus.getBackDepartureTime(),oldBus.getBackDepartureTime()));
				 logStr.append(ComLogUtil.getLogTxt("返程行程时间",newBus.getBackTravelTime(),oldBus.getBackTravelTime()));
			 }
			
			 
			 
			 
		 }
		 return logStr.toString();
	 }

	//检查并保存
		private void saveDistributorGoods(Distributor distributor,DistDistributorGoods distDistributorGoods,SuppGoods suppGoods){
			Map<String, Object> paramDistributorGoods = new HashMap<String, Object>();
			paramDistributorGoods.put("distributorId", distributor.getDistributorId());
			paramDistributorGoods.put("suppGoodsId", suppGoods.getSuppGoodsId());
			List<DistDistributorGoods> tempList = distributorGoodsService.findDistDistributorGoodsList(paramDistributorGoods);
			if(tempList==null || tempList.size()==0){
				distDistributorGoods.setSuppGoodsId(suppGoods.getSuppGoodsId());
				distDistributorGoods.setDistributorId(distributor.getDistributorId());
				distDistributorGoods.setCancelFlag("Y");
				distDistributorGoods.setProductId(suppGoods.getProductId());
				distDistributorGoods.setProductBranchId(suppGoods.getProductBranchId());
				distributorGoodsService.addDistDistributorGoods(distDistributorGoods);
			}
		}
		
		//删除分销商商品
		private void deleteDistributorGoods(Distributor distributor,SuppGoods suppGoods){
			Map<String, Object> paramDistributorGoods = new HashMap<String, Object>();
			paramDistributorGoods.put("distributorId", distributor.getDistributorId());
			paramDistributorGoods.put("suppGoodsId", suppGoods.getSuppGoodsId());
			distributorGoodsService.deleteDistDistributorGoods(paramDistributorGoods);
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
		
		//其他巴士 显示下单必填项
		@RequestMapping(value = "/showGoodsReservationLimit.do")
		public String showGoodsReservationLimit(Model model, HttpServletRequest req) throws BusinessException {

			if (LOG.isDebugEnabled()) {
				LOG.debug("start method<showGoodsReservationLimit>");
			}

			String suppGoodsId = req.getParameter("suppGoodsId");
			String categoryId = req.getParameter("categoryId");

			if (StringUtil.isNotEmptyString(suppGoodsId)) {

				//查询商品和产品，主要目的是查询产品是 国内还是出境
				Long suppGoodId = Long.valueOf(suppGoodsId);
				SuppGoodsParam suppGoodsParam = new SuppGoodsParam();
				suppGoodsParam.setProduct(true);
				SuppGoods suppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoodId,suppGoodsParam));

				//查询下单必填项
				Map<String, Object> parameters = new HashMap<String, Object>();
				parameters.put("objectType", ComOrderRequired.OBJECTTYPE.SUPP_GOODS.name());
				parameters.put("objectId", suppGoodsId);
				List<ComOrderRequired> comOrderRequiredList = comOrderRequiredService.findComOrderRequiredList(parameters);
				if(CollectionUtils.isNotEmpty(comOrderRequiredList)){
					model.addAttribute("comOrderRequired", comOrderRequiredList.get(0));
				}

				model.addAttribute("suppGoods", suppGoods);
				model.addAttribute("travNumTypeList", BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.all());
				model.addAttribute("suppGoodsId", suppGoodsId);
				model.addAttribute("categoryId", categoryId);
			}

			return "/goods/traffic/goods/showGoodsReservationLimit";
		}
		
		//其他巴士 新增下单必填项
		@RequestMapping(value = "/addReservationLimit.do")
		@ResponseBody
		public Object addReservationLimit(Model model, HttpServletRequest req, ComOrderRequired comOrderRequired) throws BusinessException {
			if (LOG.isDebugEnabled()) {
				LOG.debug("start method<addReservationLimit>");
			}
			comOrderRequired.setObjectType(ComOrderRequired.OBJECTTYPE.SUPP_GOODS.name());
			comOrderRequiredService.saveComOrderRequired(comOrderRequired);
			
			//获取商品时间价格变更日志内容
			SuppGoodsParam param = new SuppGoodsParam();
			param.setProduct(true);
			SuppGoods suppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(comOrderRequired.getObjectId(), param));


			//添加操作日志
			try {
	            //文字变更日期20151113
				comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS,
										comOrderRequired.getObjectId(),
										comOrderRequired.getObjectId(),
										this.getLoginUser().getUserName(),
										"添加了商品下单必填项：【"+suppGoods.getGoodsName()+"】",
										COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(),
										"新增商品下单必填项",
										null);
			} catch (Exception e) {
				LOG.error(ExceptionFormatUtil.getTrace(e));
			}	

			return ResultMessage.ADD_SUCCESS_RESULT;
		}
		
		
		//其他巴士 修改下单必填项
		@RequestMapping(value = "/updateReservationLimit.do")
		@ResponseBody
		public Object updateReservationLimit(Model model, HttpServletRequest req, ComOrderRequired comOrderRequired) throws BusinessException {
			if (LOG.isDebugEnabled()) {
				LOG.debug("start method<updateReservationLimit>");
			}
			try{
				ComOrderRequired oldcomOrderRequired = comOrderRequiredService.findComOrderRequiredById(comOrderRequired.getReqId());
				if(BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.TRAV_NUM_NO.name().equals(comOrderRequired.getCredType())){
					comOrderRequired.setIdFlag("N");
					comOrderRequired.setTwPassFlag("N");
					comOrderRequired.setPassFlag("N");
					comOrderRequired.setPassportFlag("N");
					comOrderRequired.setTwResidentFlag("N");
					comOrderRequired.setBirthCertFlag("N");
					comOrderRequired.setHouseholdRegFlag("N");
					comOrderRequired.setHkResidentFlag("N");
					comOrderRequired.setOfficerFlag("N");
					comOrderRequired.setSoldierFlag("N");
				}
				comOrderRequiredService.updateConOrderRequired(comOrderRequired);	
				
				//获取商品时间价格变更日志内容
				SuppGoodsParam param = new SuppGoodsParam();
				param.setProduct(true);
				SuppGoods suppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(comOrderRequired.getObjectId(), param));
				
				//获取商品变更日志内容 
				String logContent = getReservationLimitLog(comOrderRequired,oldcomOrderRequired);
				if(null!=logContent && !"".equals(logContent)){
					//添加操作日志
					try {
						comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS,
												suppGoods.getProdProduct().getProductId(),
												comOrderRequired.getObjectId(),
												this.getLoginUser().getUserName(),
												"修改了商品下单必填项：【"+suppGoods.getGoodsName()+"】,变更内容："+logContent,
												COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(),
												"修改商品下单必填项",
												null);
					} catch (Exception e) {
						LOG.error(ExceptionFormatUtil.getTrace(e));
					}
				}
			} catch (Exception e) {
				LOG.error(ExceptionFormatUtil.getTrace(e));
				return ResultMessage.SYS_ERROR;
			}
			return ResultMessage.UPDATE_SUCCESS_RESULT;
		}
		
		/**
		 * 下单必填项更改日志
		 * @param comOrderRequired
		 * @param oldComOrderRequired
	     * @return
	     */
		private String getReservationLimitLog(ComOrderRequired comOrderRequired,ComOrderRequired oldComOrderRequired){
			 StringBuffer logStr = new StringBuffer("");
			 //修改
			 if(null== oldComOrderRequired){
				 logStr.append(ComLogUtil.getLogTxt("1笔订单需要的“游玩人/取票人”数量",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getTravNumType()),null));
				 logStr.append(ComLogUtil.getLogTxt("境内手机号",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getPhoneType()),null));
				 logStr.append(ComLogUtil.getLogTxt("境外手机号",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getOutboundPhoneType()),null));
				 logStr.append(ComLogUtil.getLogTxt("email",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getEmailType()),null));
				 logStr.append(ComLogUtil.getLogTxt("证件",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getCredType()),null));
				 logStr.append(ComLogUtil.getLogTxt("身份证",String.valueOf("Y".equals(comOrderRequired.getIdFlag()) ? "可用" : "不可用"),null));
				 logStr.append(ComLogUtil.getLogTxt("护照",String.valueOf("Y".equals(comOrderRequired.getPassportFlag()) ? "可用" : "不可用"),null));
				 logStr.append(ComLogUtil.getLogTxt("通行证",String.valueOf("Y".equals(comOrderRequired.getPassFlag()) ? "可用" : "不可用"),null));
			 }else{
				 //新增	 
				 logStr.append(ComLogUtil.getLogTxt("1笔订单需要的“游玩人/取票人”数量",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getTravNumType()),BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(oldComOrderRequired.getTravNumType())));
				 logStr.append(ComLogUtil.getLogTxt("境内手机号",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getPhoneType()),BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(oldComOrderRequired.getPhoneType())));
				 logStr.append(ComLogUtil.getLogTxt("境外手机号",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getOutboundPhoneType()),BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(oldComOrderRequired.getOutboundPhoneType())));
				 logStr.append(ComLogUtil.getLogTxt("email",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getEmailType()),BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(oldComOrderRequired.getEmailType())));
				 logStr.append(ComLogUtil.getLogTxt("证件",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getCredType()),BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(oldComOrderRequired.getCredType())));
				 logStr.append(ComLogUtil.getLogTxt("身份证",String.valueOf("Y".equals(comOrderRequired.getIdFlag()) ? "可用" : "不可用"),String.valueOf("Y".equals(oldComOrderRequired.getIdFlag()) ? "可用" : "不可用")));
				 logStr.append(ComLogUtil.getLogTxt("护照",String.valueOf("Y".equals(comOrderRequired.getPassportFlag()) ? "可用" : "不可用"),String.valueOf("Y".equals(oldComOrderRequired.getPassportFlag()) ? "可用" : "不可用")));
				 logStr.append(ComLogUtil.getLogTxt("通行证",String.valueOf("Y".equals(comOrderRequired.getPassFlag()) ? "可用" : "不可用"),String.valueOf("Y".equals(oldComOrderRequired.getPassFlag()) ? "可用" : "不可用")));	
			 }
			 return logStr.toString();
		 }	
		
}
