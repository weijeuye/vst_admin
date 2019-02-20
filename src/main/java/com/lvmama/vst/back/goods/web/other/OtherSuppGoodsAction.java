package com.lvmama.vst.back.goods.web.other;

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
import com.lvmama.vst.back.biz.po.BizDistrict;
import com.lvmama.vst.back.client.biz.service.BizBuEnumClientService;
import com.lvmama.vst.back.client.biz.service.BizPostAeraClientService;
import com.lvmama.vst.back.client.biz.service.BranchClientService;
import com.lvmama.vst.back.client.biz.service.DistrictClientService;
import com.lvmama.vst.back.client.dist.service.DistributorGoodsClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsAdditionClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductBranchClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.supp.service.SuppContractClientService;
import com.lvmama.vst.back.client.supp.service.SuppSupplierClientService;
import com.lvmama.vst.back.dist.po.DistDistributorGoods;
import com.lvmama.vst.back.dist.po.Distributor;
import com.lvmama.vst.back.dist.service.DistributorCachedService;
import com.lvmama.vst.back.goods.po.BizPostAera;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.goods.po.SuppGoodsAddition;
import com.lvmama.vst.back.goods.po.SuppGoodsNotimeTimePrice;
import com.lvmama.vst.back.goods.po.SuppGoodsRefund;
import com.lvmama.vst.back.goods.service.SuppGoodsNotimeTimePriceService;
import com.lvmama.vst.back.goods.service.SuppGoodsRefundService;
import com.lvmama.vst.back.goods.service.SuppGroupStockService;
import com.lvmama.vst.back.goods.vo.SupplierGoodsVO;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProduct.COMPANY_TYPE_DIC;
import com.lvmama.vst.back.prod.po.ProdProductBranch;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.supp.po.SuppContract;
import com.lvmama.vst.back.supp.po.SuppSettlementEntities;
import com.lvmama.vst.back.supp.po.SuppSupplier;
import com.lvmama.vst.back.supp.service.SuppSettlementEntitiesService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.enumeration.CommEnumSet;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.DateUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;
import com.lvmama.vst.pet.adapter.TntGoodsChannelCouponAdapter;

/**
 * 其它商品维护管理Action
 * 
 * @author yuzhizeng
 */
@Controller
@RequestMapping("/other/goods")
public class OtherSuppGoodsAction extends BaseActionSupport {
	/**
	 * 序列
	 */
	private static final long serialVersionUID = 5040537774202298456L;

	private static final Log LOG = LogFactory.getLog(OtherSuppGoodsAction.class);
	
	@Autowired
	private SuppGoodsClientService suppGoodsService;
	
	@Autowired
	private SuppGroupStockService suppGroupStockService;//1
	
	@Autowired
	private ProdProductClientService prodProductService;
	
	@Autowired
	private ComLogClientService comLogService;
	
	@Autowired
	private ProdProductBranchClientService prodProductBranchService;
	

	@Autowired
	private SuppSupplierClientService suppSupplierService;
	

	@Autowired
	private SuppContractClientService suppContractService;
	


	@Autowired
	private DistributorCachedService distributorService;//2

	@Autowired
	private DistributorGoodsClientService distributorGoodsService;
	

	
	@Autowired
	private PermUserServiceAdapter permUserServiceAdapter;//3
	
	@Autowired
	private BranchClientService branchService;
	

	@Autowired
	private BizPostAeraClientService bizPostAeraService;
	
	
	@Autowired
	private SuppGoodsNotimeTimePriceService suppGoodsNotimeTimePriceService;//4
	
	@Autowired
	private SuppGoodsRefundService suppGoodsRefundService;//5
	
	@Autowired
	private SuppGoodsAdditionClientService  suppGoodsAdditionClientRemote;
	
	@Autowired
	private DistrictClientService districtService;
	
	
	@Autowired
	private TntGoodsChannelCouponAdapter tntGoodsChannelCouponServiceRemote;//6
	
	@Autowired
	private BizBuEnumClientService bizBuEnumClientService;

	@Autowired
	private SuppSettlementEntitiesService suppSettlementEntitiesService; // 结算对象SETTLE_ENTITY_MARK  7

	//新增商品先检测条件
	@RequestMapping(value = "/showSuppGoodsListCheck")
	@ResponseBody
	public Object showSuppGoodsListCheck(HttpServletRequest req) throws BusinessException {
		ResultMessage message = null;
		if (req.getParameter("productId") != null) {
			ProdProduct prodProduct = MiscUtils.autoUnboxing(prodProductService.getProdProductBy(Long.valueOf(req.getParameter("productId"))));
			// 商品维护前，产品基本信息check
			message = new ResultMessage("success", "success");
			if ((prodProduct == null) || (prodProduct.getProductId() == null)) {
				message = new ResultMessage("error", "该产品不存在，请先维护产品！");
				return message;
			}
		}
		return message;
	}

	//展示商品列表
	@RequestMapping(value = "/showSuppGoodsList")
	public String showSuppGoodsList(Model model, HttpServletRequest req) throws Exception {
		if (req.getParameter("productId") != null) {
			Map<String, Object> parameters = new HashMap<String, Object>();
			parameters.put("productId", req.getParameter("productId"));
			ProdProduct prodProduct = prodProductService.findProdProductByProductId(Long.valueOf(req.getParameter("productId")));
			
			model.addAttribute("prodProduct", prodProduct);
			Map<String, Object> parameprodProductBranch = new HashMap<String, Object>();
			parameprodProductBranch.put("productId", prodProduct.getProductId());
			List<ProdProductBranch> prodProductBranchList = MiscUtils.autoUnboxing(prodProductBranchService.findProdProductBranchList(parameprodProductBranch));
			
			SuppGoods suppGoods = new SuppGoods();
			BizCategory bizCategory=new BizCategory();
			bizCategory.setCategoryId(prodProduct.getBizCategoryId());
			prodProduct.setBizCategory(bizCategory);
			suppGoods.setProdProduct(prodProduct);
			selectExistsSupplier(model, prodProduct.getProductId());
			
			model.addAttribute("prodProductBranchList", prodProductBranchList);
			model.addAttribute("suppGoods", suppGoods);
		}
		return "/goods/other/findSuppGoodsList";
	}
 
	/**
	 * 获得商品列表
	 * @param model
	 * @param page 分页参数
	 * @param prodProduct  查询条件
	 * @param req
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/findSuppGoodsList")
	public String findSuppGoodsList(Model model, Integer page, SuppGoods suppGoods, HttpServletRequest req) throws Exception {
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
			List<ProdProductBranch> prodProductBranchList = MiscUtils.autoUnboxing(prodProductBranchService.findProdProductBranchList(parameprodProductBranch));
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
		List<ProdProductBranch> prodProductBranchList = MiscUtils.autoUnboxing(prodProductBranchService.findProdProductBranchList(parameprodProductBranch));
		model.addAttribute("prodProductBranchList", prodProductBranchList);
		model.addAttribute("suppGoods", suppGoods);
		model.addAttribute("suppGoodsMap", branchIdMap);

		return "/goods/other/findSuppGoodsList";
	}

	/**
	 * 跳转到修改页面
	 * 
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/showUpdateSuppGoods")
	public String showUpdateSuppGoods(Model model, HttpServletRequest req) throws Exception {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showUpdateSuppGoods>");
		}
		List<ProdProductBranch> prodProductBranchList = null;
		Map goodsTypeMap = new HashMap();
		SuppGoods suppGoods = null;
		if (StringUtils.isNotBlank(req.getParameter("suppGoodsId")) && StringUtils.isNotBlank(req.getParameter("productId")) && StringUtils.isNotBlank(req.getParameter("supplierId"))) {
			Map<String, Object> paramProdProductBranch = new HashMap<String, Object>();
			paramProdProductBranch.put("productId", String.valueOf(req.getParameter("productId")));
			prodProductBranchList = MiscUtils.autoUnboxing(prodProductBranchService.findProdProductBranchList(paramProdProductBranch));
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
			
			// 取得产品对应的销售渠道信息
			Map<String, Object> paraDistDistributorSuppGoods = new HashMap<String, Object>();
			paraDistDistributorSuppGoods.put("suppGoodsId", suppGoods.getSuppGoodsId());
			List<DistDistributorGoods> distDistributorGoods = MiscUtils.autoUnboxing(distributorGoodsService.findDistDistributorGoodsList(paraDistDistributorSuppGoods));
			suppGoods.setDistDistributorGoods(distDistributorGoods);
			
			//销售渠道
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("cancelFlag", "Y");
			
			ResultHandleT<List<Distributor>>  result=distributorService.findDistributorList(params);
			if(result!=null&&result.getReturnContent()!=null){
				List<Distributor> distributors = result.getReturnContent();
				model.addAttribute("distributorList", distributors);
			}
					
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
			
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("suppGoodsId", suppGoods.getSuppGoodsId());
			List<SuppGoodsNotimeTimePrice> timePriceList = suppGoodsNotimeTimePriceService.findSuppGoodsNotimeTimePriceList(param);
			if(timePriceList != null && timePriceList.size() > 0 ){
				model.addAttribute("timePrice", timePriceList.get(0));
			}
			param.clear();
			param.put("goodsId", suppGoods.getSuppGoodsId());
			List<SuppGoodsRefund> suppGoodsRefundList = suppGoodsRefundService.findSuppGoodsRefundList(param);
			if(suppGoodsRefundList != null && suppGoodsRefundList.size() > 0 ){
				SuppGoodsRefund suppGoodsRefund = suppGoodsRefundList.get(0);
				model.addAttribute("suppGoodsRefund", suppGoodsRefund);
			}
			
			//快递地
			SuppGoodsAddition oldRecord = suppGoodsAdditionClientRemote.selectByPrimaryKey(suppGoods.getSuppGoodsId());
			if(oldRecord != null){
				param.clear();
				param.put("areaId", oldRecord.getDistrictArea());
				List<BizPostAera> bizPostAeraList = bizPostAeraService.findBizPostAreaList(param);
				if(bizPostAeraList != null && bizPostAeraList.size() > 0 ){
					BizPostAera bizPostAera = bizPostAeraList.get(0);
					model.addAttribute("bizPostAera", bizPostAera);
				}
			}
			
			param.clear();
			params.put("hasProp", Boolean.TRUE);
			params.put("hasPropValue", Boolean.TRUE);
			params.put("getPropInfo", "true");
			ProdProduct prodProduct = prodProductService.getProductPropInfoFromCacheById(Long.parseLong(req.getParameter("productId")), params);
			model.addAttribute("prodProduct", prodProduct);
		}

		// 结算对象SETTLE_ENTITY_MARK
		// 设置结算对象
		SuppSettlementEntities settlementEntity = suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(suppGoods.getSettlementEntityCode());
		suppGoods.setSettlementEntity(settlementEntity);

		// 公司主体
		Map<String, String> companyTypeMap = new HashMap<String, String>();
		for (COMPANY_TYPE_DIC item : COMPANY_TYPE_DIC.values()) {
			companyTypeMap.put(item.name(), item.getTitle());
		}
		model.addAttribute("companyTypeMap", companyTypeMap);
				
		model.addAttribute("goodsTypeMap", goodsTypeMap);
		model.addAttribute("suppGoods", suppGoods);
		model.addAttribute("prodProductBranchList", prodProductBranchList);
		return "/goods/other/showUpdateSuppGoods";
	}

	/**
	 * 跳转到添加商品
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/showAddSuppGoods")
	public String showAddSuppGoods(Model model, HttpServletRequest req) throws Exception {
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
			prodProductBranchList = MiscUtils.autoUnboxing(prodProductBranchService.findProdProductBranchList(paramProdProductBranch));
			suppGoods = new SuppGoods();
			SuppSupplier suppSupplier = new SuppSupplier();
			suppSupplier.setSupplierId(Long.valueOf(req.getParameter("supplierId")));
			suppGoods.setSuppSupplier(suppSupplier);
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("hasProp", Boolean.TRUE);
			params.put("hasPropValue", Boolean.TRUE);
			params.put("getPropInfo", "true");
			ProdProduct prodProduct = prodProductService.getProductPropInfoFromCacheById(Long.parseLong(req.getParameter("productId")), params);
			model.addAttribute("prodProduct", prodProduct);
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
			//销售渠道
			params.clear();
			params.put("cancelFlag", "Y");
			ResultHandleT<List<Distributor>> dist_result=distributorService.findDistributorList(params);
			if(dist_result!=null&&dist_result.getReturnContent()!=null){
				List<Distributor> distributors = dist_result.getReturnContent();
				model.addAttribute("distributorList", distributors);
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
		Map<String, String> companyTypeMap = new HashMap<String, String>();
		for (COMPANY_TYPE_DIC item : COMPANY_TYPE_DIC.values()) {
			companyTypeMap.put(item.name(), item.getTitle());
		}
		model.addAttribute("companyTypeMap", companyTypeMap);
				
		model.addAttribute("goodsTypeMap", goodsTypeMap);
		model.addAttribute("suppGoods", suppGoods);
		model.addAttribute("prodProductBranchList", prodProductBranchList);
		return "/goods/other/showAddSuppGoods";
	}

	/**
	 * 更新产品
	 * @throws Exception 
	 */
	@RequestMapping(value = "/updateSuppGoods")
	@ResponseBody
	public Object updateSuppGoods(SuppGoods suppGoods, SuppGoodsNotimeTimePrice timePrice, SuppGoodsRefund suppGoodsRefund, 
			Long areaId, String distributorUserIds) throws Exception {
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
			if(oldSuppGoods == null){
				throw new BusinessException("编辑商品不存在"); 
			}
			suppGoods.setSuppGoodsId(oldSuppGoods.getSuppGoodsId());
		    suppGoods.setCreateTime(oldSuppGoods.getCreateTime());
		    suppGoods.setCreateUser(oldSuppGoods.getCreateUser());
		    suppGoods.setStockApiFlag(oldSuppGoods.getStockApiFlag());
		    suppGoods.setApiFlag(oldSuppGoods.getApiFlag());
			suppGoods.setCancelFlag(oldSuppGoods.getCancelFlag());
			suppGoodsService.updateSuppGoods(suppGoods);
			
			SuppGoodsNotimeTimePrice oldTimePrice = suppGoodsNotimeTimePriceService.getSuppGoodsNotimeTimePriceById(timePrice.getTimePriceId());
			if(oldTimePrice == null){
				throw new BusinessException("编辑商品时间价格不存在"); 
			}
			/*Date startDate = new Date();
			timePrice.setStartDate(startDate);
			timePrice.setEndDate(DateUtil.dsDay_Date(startDate, 3650));*/
			timePrice.setTimePriceId(oldTimePrice.getTimePriceId());
			suppGoodsNotimeTimePriceService.updateSuppGoodsNotimeTimePrice(timePrice);
			
			SuppGoodsRefund oldSuppGoodsRefund = suppGoodsRefundService.selectByPrimaryKey(suppGoodsRefund.getRefundId());
			suppGoodsRefund.setRefundId(oldSuppGoodsRefund.getRefundId());
			suppGoodsRefund.setGoodsId(suppGoods.getSuppGoodsId());
			suppGoodsRefundService.updateSuppGoodsRefund(suppGoodsRefund);
			
                        if (null != areaId) {
                            // 保存快递地ID
                            SuppGoodsAddition oldRecord = suppGoodsAdditionClientRemote.selectByPrimaryKey(suppGoods.getSuppGoodsId());
                            if (oldRecord == null) {
                                oldRecord = new SuppGoodsAddition();
                                oldRecord.setDistrictArea(areaId);
                                oldRecord.setSuppGoodsId(suppGoods.getSuppGoodsId());
                                suppGoodsAdditionClientRemote.insert(oldRecord);
                            } else {
                                oldRecord.setDistrictArea(areaId);
                                oldRecord.setSuppGoodsId(suppGoods.getSuppGoodsId());
                                suppGoodsAdditionClientRemote.updateByPrimaryKeySelective(oldRecord);
                            }
                        }
			// 修改产品的销售渠道
			String oldDistributorNames ="";
			String distributorNames="";
			if(suppGoods.getDistributorIds()!=null){
				// 分销商列表
				Map<String, Object> paramDistributor = new HashMap<String, Object>();
				paramDistributor.put("cancelFlag", "Y");
				paramDistributor.put("_orderby", "DISTRIBUTOR_ID");
				paramDistributor.put("_order", "ASC");
				ResultHandleT<List<Distributor>> dist_result=distributorService.findDistributorList(paramDistributor);
				List<Distributor> distributorList;
				if(dist_result!=null&&dist_result.getReturnContent()!=null){
					distributorList =dist_result.getReturnContent();	
				}else{
					return ResultMessage.ADD_FAIL_RESULT;
				}
				// 取得旧产品对应的销售渠道信息
				Map<String, Object> paraDistDistributorSuppGoods = new HashMap<String, Object>();
				paraDistDistributorSuppGoods.put("suppGoodsId", suppGoods.getSuppGoodsId());
				paraDistDistributorSuppGoods.put("_orderby", "DISTRIBUTOR_ID");
				paraDistDistributorSuppGoods.put("_order", "ASC");
				List<DistDistributorGoods> distDistributorGoodsList = MiscUtils.autoUnboxing(distributorGoodsService.findDistDistributorGoodsList(paraDistDistributorSuppGoods));
				if(distDistributorGoodsList!=null && distDistributorGoodsList.size()>0){
				    StringBuilder sb = new StringBuilder();
					for (DistDistributorGoods distDistributorGoods : distDistributorGoodsList) {
						for (Distributor distributor : distributorList) {
							if(distributor.getDistributorId().longValue()==distDistributorGoods.getDistributorId().longValue()){
								sb.append(distributor.getDistributorName()).append(",");
							}
						}
					}
					
					if(StringUtils.isNotBlank(sb.toString())){
	                    oldDistributorNames = sb.toString().substring(0, sb.length()-1);
	                }
				}

				String[] distributorIds = suppGoods.getDistributorIds().split(",");
				if(distributorIds!=null && distributorIds.length>0){
					for (String distributorId : distributorIds) {
						for (Distributor distributor : distributorList) {
							if(distributorId.equals(String.valueOf(distributor.getDistributorId()))){
								distributorNames = distributorNames + distributor.getDistributorName()+",";
							}
						}
					}
				}
				if(StringUtils.isNotBlank(distributorNames)){
					distributorNames = distributorNames.substring(0, distributorNames.length()-1);
				}
				
				saveOrUpdateDistributorGoods(suppGoods.getProductId(),suppGoods.getProductBranchId(),suppGoods.getSuppGoodsId(),distributorIds);	
			
				distributorGoodsService.pushSuperDistributor(suppGoods, distributorUserIds);
			}
			
			//获取商品变更日志内容 
			String logContent = "";
			logContent = getSuppGoodsChangeLog(oldSuppGoods, suppGoods, oldTimePrice, timePrice, oldSuppGoodsRefund ,suppGoodsRefund, distributorNames, oldDistributorNames);
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
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/addSuppGoods")
	@ResponseBody
	public Object addSuppGoods(SuppGoods suppGoods, SuppGoodsNotimeTimePrice timePrice, String distributorUserIds,
			SuppGoodsRefund suppGoodsRefund, Long areaId, HttpServletRequest req) throws BusinessException {

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
			long suppGoodsId = MiscUtils.autoUnboxing(suppGoodsService.addSuppGoods(suppGoods));
			
			Date startDate = DateUtil.accurateToDay(new Date());
			timePrice.setStartDate(startDate);
			timePrice.setEndDate(DateUtil.dsDay_Date(startDate, 3650));
			
			timePrice.setSuppGoodsId(suppGoodsId);
			timePrice.setStockFlag("N");
			timePrice.setPriceModel("FIRM_PRICE");
			timePrice.setOnsaleFlag("Y");
			timePrice.setOversellFlag("Y");
			suppGoodsNotimeTimePriceService.addSuppGoodsNotimeTimePrice(timePrice);
			
			suppGoodsRefund.setGoodsId(suppGoodsId);
			suppGoodsRefundService.addSuppGoodsRefund(suppGoodsRefund);
			
			ProdProduct product = MiscUtils.autoUnboxing(prodProductService.getProdProductBy(suppGoods.getProductId()));
			if("EXPRESS".endsWith(product.getProductType())){
			    //保存快递地ID
			    SuppGoodsAddition oldRecord = suppGoodsAdditionClientRemote.selectByPrimaryKey(suppGoodsId);
			    if(oldRecord == null){
			        SuppGoodsAddition record = new SuppGoodsAddition();
			        record.setDistrictArea(areaId);
			        record.setSuppGoodsId(suppGoodsId);
			        suppGoodsAdditionClientRemote.insert(record);
			    }else{
			        throw new BusinessException("商品已有快递地"); 
			    }
			}
			
			//向中间表插入产品
			/*ProdProduct prodProduct = prodProductService.findProdProductByProductId(suppGoods.getProductId());
			if(null != prodProduct && null != suppGoods.getSupplierId())
			{
				suppGoods.setProdProduct(prodProduct);
				ebkVstService.addEbkSuperProd(suppGoods);
			}*/
		 
			// 新增产品的销售渠道
			if(suppGoods.getDistributorIds()!=null){
				String[] distributorIds = suppGoods.getDistributorIds().split(",");
				if(distributorIds!=null && distributorIds.length>0){
					for (String distributorId : distributorIds) {
						DistDistributorGoods distDistributorGoods = new DistDistributorGoods();
						distDistributorGoods.setSuppGoodsId(suppGoods.getSuppGoodsId());
						distDistributorGoods.setDistributorId(Long.parseLong(distributorId));
						distDistributorGoods.setCancelFlag("Y");
						distDistributorGoods.setProductId(suppGoods.getProductId());
						distDistributorGoods.setProductBranchId(suppGoods.getProductBranchId());
						distributorGoodsService.addDistDistributorGoods(distDistributorGoods);
					}
				}
				
				//推送商品的分销商关系给super系统
				distributorGoodsService.pushSuperDistributor(suppGoods, distributorUserIds);
			}

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

	 private String getSuppGoodsChangeLog(SuppGoods oldSuppGoods,SuppGoods newSuppGoods, 
			 SuppGoodsNotimeTimePrice oldTimePrice, SuppGoodsNotimeTimePrice timePrice, 
			 SuppGoodsRefund oldSuppGoodsRefund , SuppGoodsRefund suppGoodsRefund,
			 String distributorNames, String oldDistributorNames){
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
			 //产品经理
			 if(!newSuppGoods.getManagerId().equals(oldSuppGoods.getManagerId())){
			
					Long managerId = oldSuppGoods.getManagerId();
					if (managerId!=null) {
						PermUser user = permUserServiceAdapter.getPermUserByUserId(managerId);
						 logStr.append(ComLogUtil.getLogTxt("产品经理",newSuppGoods.getManagerName(),user.getRealName()));
					}
			 }

			 // 结算对象SETTLE_ENTITY_MARK
			 // 结算对象
			 if(!newSuppGoods.getSettlementEntityCode().equals(oldSuppGoods.getSettlementEntityCode())){
			 SuppSettlementEntities newSettleEntity =  suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(newSuppGoods.getSettlementEntityCode());
			 SuppSettlementEntities oldSettleEntity =  suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(oldSuppGoods.getSettlementEntityCode());
			 if(null!=newSettleEntity && null!=oldSettleEntity){
				 logStr.append(ComLogUtil.getLogTxt("结算对象",newSettleEntity.getName(),oldSettleEntity.getName()));
				 logStr.append(ComLogUtil.getLogTxt("结算对象CODE",newSuppGoods.getSettlementEntityCode(),oldSuppGoods.getSettlementEntityCode()));
			 }
		 }

			 //商品合同
			 if(!newSuppGoods.getContractId().equals(oldSuppGoods.getContractId())){
				 logStr.append(ComLogUtil.getLogTxt("商品合同",newSuppGoods.getSuppContract().getContractName(),oldSuppGoods.getSuppContract().getContractName()));
			 }
			 if(!newSuppGoods.getPayTarget().equals(oldSuppGoods.getPayTarget()))
			 {
				 String newValue = "";
				 String oldValue = "";
				 newValue = SuppGoods.PAYTARGET.getCnName(newSuppGoods.getPayTarget());
				 oldValue = SuppGoods.PAYTARGET.getCnName(oldSuppGoods.getPayTarget());
				 logStr.append(ComLogUtil.getLogTxt("支付对象",newValue,oldValue));
			 }
			 
			 logStr.append(ComLogUtil.getLogTxt("销售金额(元)", timePrice.getPriceYuanStr() , oldTimePrice.getPriceYuanStr()));
			 logStr.append(ComLogUtil.getLogTxt("结算金额(元)", timePrice.getSettlementPriceYuanStr(), oldTimePrice.getSettlementPriceYuanStr() ));
			 logStr.append(ComLogUtil.getLogTxt("提前预定时间", timePrice.getAheadBookTime().toString(), oldTimePrice.getAheadBookTime().toString()));
			 logStr.append(ComLogUtil.getLogTxt("提前退改时间", suppGoodsRefund.getLatestCancelTime().toString(), oldSuppGoodsRefund.getLatestCancelTime().toString()));
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
				 logStr.append(ComLogUtil.getLogTxt("是否仅组合销售","Y".equals(newSuppGoods.getPackageFlag())?"是":"否","Y".equals(oldSuppGoods.getPackageFlag())?"是":"否"));
			 }
			 logStr.append(ComLogUtil.getLogTxt("最小起订数量",newSuppGoods.getMinQuantity().toString(),oldSuppGoods.getMinQuantity().toString()));
			 logStr.append(ComLogUtil.getLogTxt("最大订购数量",newSuppGoods.getMaxQuantity().toString(),oldSuppGoods.getMaxQuantity().toString()));
			 
			 if(distributorNames.split(",").length == oldDistributorNames.split(",").length){
				 Boolean isSame = Boolean.TRUE;
				 for(String distributorName : distributorNames.split(",")){
					 if(!oldDistributorNames.contains(distributorName)){
						 isSame = Boolean.FALSE;
						 break;
					 }
				 }
				 if(!isSame){
					 logStr.append(ComLogUtil.getLogTxt("销售渠道", distributorNames, oldDistributorNames));
				 }
			 }else{
				 logStr.append(ComLogUtil.getLogTxt("销售渠道", distributorNames, oldDistributorNames));
			 }
			 
		 }
		 return logStr.toString();
	 }
	 

/**
	 * 设置商品的有效性
	 * 
	 * @return
	 */
	@RequestMapping(value = "/cancelGoods")
	@ResponseBody
	public Object cancelGoods(SuppGoods suppGoods) throws BusinessException {
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
			if("Y".equals(suppGoods.getCancelFlag())){
				key = "有效";
			}else{
				key = "无效";
			}
			comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
					suppGoods.getProductId(), suppGoods.getSuppGoodsId(), 
					this.getLoginUser().getUserName(), 
					"修改了商品的有效性为:"+key, 
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
	
	@RequestMapping(value = "/selectBizPostAeraList")
	public String selectBizPostAeraList(Model model, Integer page, BizPostAera BizPostAera, HttpServletRequest req, String callback) throws BusinessException {

		if (log.isDebugEnabled()) {
			log.debug("start method<selectBizPostAeraList>");
		}

		Map<String,Object> param = new HashMap<String,Object>();
		param.put("_orderby", "AREA_ID asc");
		
		int count = bizPostAeraService.findBizPostAreaCount(param);
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		param.put("_start", pageParam.getStartRows());
		param.put("_end", pageParam.getEndRows());
		List<BizPostAera> bizPostAeraList = bizPostAeraService.findBizPostAreaList(param);
		pageParam.setItems(bizPostAeraList);
		
		for(BizPostAera bizPostAera : bizPostAeraList){
			if(bizPostAera.getDistrictArea() == null){
				continue;
			}
			param.clear();
			param.put("districtIds", bizPostAera.getDistrictArea().split(","));
			param.put("fillParentDistrict", "true");
			List<BizDistrict> bizDistrictList = MiscUtils.autoUnboxing(districtService.findDistrictList(param));
			if(bizDistrictList != null && bizDistrictList.size() > 0){
				bizPostAera.setBizDistrictList(bizDistrictList);
			}
		}
		model.addAttribute("callback", callback);
	 
		model.addAttribute("pageParam", pageParam);
		return "/goods/other/selectBizPostAeraList";
	}
}
