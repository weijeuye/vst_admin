/**
 *
 */
package com.lvmama.vst.back.goods.web.ticket;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.comm.tnt.po.TntGoodsChannelVo;
import com.lvmama.comm.vst.VstOrderEnum;
import com.lvmama.vst.back.biz.po.BizBranch;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.po.BizEnum;
import com.lvmama.vst.back.biz.po.BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.client.biz.service.BranchClientService;
import com.lvmama.vst.back.client.biz.service.BizBuEnumClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsAdditionClientService;
import com.lvmama.vst.back.client.passport.service.PassProductGoodsDubboService;
import com.lvmama.vst.back.client.passport.service.PassportService;
import com.lvmama.vst.back.control.po.ResPreControlTimePrice;
import com.lvmama.vst.back.control.service.ResPreControlTimePriceService;
import com.lvmama.vst.back.control.vo.ResPreControlTimePriceVO;
import com.lvmama.vst.back.dist.po.DistDistributorGoods;
import com.lvmama.vst.back.dist.po.Distributor;
import com.lvmama.vst.back.dist.service.DistributorCachedService;
import com.lvmama.vst.back.dist.service.DistributorGoodsService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.goods.po.SuppGoods.USE_STATUS;
import com.lvmama.vst.back.goods.po.SuppGoodsAddition;
import com.lvmama.vst.back.goods.po.SuppGoodsBaseTimePrice;
import com.lvmama.vst.back.goods.po.SuppGoodsCircus;
import com.lvmama.vst.back.goods.po.SuppGoodsDesc;
import com.lvmama.vst.back.goods.po.SuppGoodsDescJson;
import com.lvmama.vst.back.goods.po.SuppGoodsEditPerm;
import com.lvmama.vst.back.goods.po.SuppGoodsExp;
import com.lvmama.vst.back.goods.po.SuppGoodsOrder;
import com.lvmama.vst.back.goods.po.SuppGoodsRefund;
import com.lvmama.vst.back.goods.po.SuppGoodsReschedule;
import com.lvmama.vst.back.client.goods.service.ProdSmsChannelClientService;
import com.lvmama.vst.back.goods.service.SuppGoodsAddTimePriceService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsCircusClientService;
import com.lvmama.vst.back.goods.service.SuppGoodsDescJsonService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsDescClientService;
import com.lvmama.vst.back.goods.service.SuppGoodsEditPermRemoteService;
import com.lvmama.vst.back.goods.service.SuppGoodsExpService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsHotelAdapterClientService;
import com.lvmama.vst.back.goods.service.SuppGoodsNotimeTimePriceService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsOrderClientService;
import com.lvmama.vst.back.goods.service.SuppGoodsQueryService;
import com.lvmama.vst.back.goods.service.SuppGoodsRefundService;
import com.lvmama.vst.back.goods.service.SuppGoodsRescheduleService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.ticket.service.SuppGoodsSkuRelationClientService;
import com.lvmama.vst.back.goods.utils.SuppGoodsExpTools;
import com.lvmama.vst.back.goods.utils.SuppGoodsRefundTools;
import com.lvmama.vst.back.goods.utils.SuppGoodsRescheduleTools;
import com.lvmama.vst.back.goods.vo.SuppGoodsParam;
import com.lvmama.vst.back.goods.vo.SuppGoodsRescheduleVO;
import com.lvmama.vst.back.goods.vo.SupplierGoodsVO;
import com.lvmama.vst.back.passport.po.PassProvider;
import com.lvmama.vst.back.prod.po.ProdBranchDictionary;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProduct.COMPANY_TYPE_DIC;
import com.lvmama.vst.back.prod.po.ProdProductBranch;
import com.lvmama.vst.back.prod.service.ProdBranchDictionaryService;
import com.lvmama.vst.back.client.prod.service.ProdDestReClientService;
import com.lvmama.vst.back.prod.service.ProdProductBranchService;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.prod.ticketDetail.FeeContent;
import com.lvmama.vst.back.prod.ticketDetail.FeeContentArray;
import com.lvmama.vst.back.prod.ticketDetail.TicketGoodsFormattedDesc;
import com.lvmama.vst.back.prod.ticketDetail.TicketGoodsLimit;
import com.lvmama.vst.back.prod.ticketDetail.TicketGoodsTimeLimit;
import com.lvmama.vst.back.prod.ticketDetail.TicketGoodsTimeLimitVO;
import com.lvmama.vst.back.prod.ticketDetail.TicketGoodsTypeFormattedDescription;
import com.lvmama.vst.back.prod.ticketDetail.TicketHeightAgeDetailVO;
import com.lvmama.vst.back.prod.ticketDetail.TicketHeightAgeVO;
import com.lvmama.vst.back.prod.ticketDetail.VisitMethod;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.pub.po.ComOrderRequired;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.pub.service.ComOrderRequiredClientService;
import com.lvmama.vst.back.pub.service.PushAdapterService;
import com.lvmama.vst.back.router.adapter.ProdProductHotelAdapterService;
import com.lvmama.vst.back.router.adapter.SuppGoodsDescAdapterService;
import com.lvmama.vst.back.router.adapter.SuppGoodsDescJsonAdapterService;
import com.lvmama.vst.back.router.adapter.SuppGoodsExpAdapterService;
import com.lvmama.vst.back.router.adapter.SuppGoodsRefundAdapterService;
import com.lvmama.vst.back.supp.po.SuppContract;
import com.lvmama.vst.back.supp.po.SuppFaxRule;
import com.lvmama.vst.back.supp.po.SuppSettlementEntities;
import com.lvmama.vst.back.supp.po.SuppSettleRule;
import com.lvmama.vst.back.supp.po.SuppSupplier;
import com.lvmama.vst.back.client.supp.service.SuppContractClientService;
import com.lvmama.vst.back.supp.service.SuppFaxService;
import com.lvmama.vst.back.supp.service.SuppSettlementEntitiesService;
import com.lvmama.vst.back.client.supp.service.SuppSupplierClientService;
import com.lvmama.vst.comm.enumeration.CommEnumSet;
import com.lvmama.vst.comm.utils.CalendarUtils;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.Constants;
import com.lvmama.vst.comm.utils.DateUtil;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.utils.Pair;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.ebooking.client.ebk.serivce.EbkUserClientService;
import com.lvmama.vst.ebooking.ebk.po.EbkUser;
import com.lvmama.vst.passport.po.PassProductGoodsRspBo;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;
import com.lvmama.vst.pet.adapter.PetMessageServiceAdapter;
import com.lvmama.vst.pet.adapter.TntGoodsChannelCouponAdapter;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import com.lvmama.vst.back.utils.MiscUtils;
/**
 * @author qiujiehong
 *@date 2014-06-26
 */				 
@Controller
@RequestMapping("/ticket/goods/goods")
public class TicketSuppGoodsAction extends BaseActionSupport {

	/**
	 *
	 */
	private static final long serialVersionUID = -81189271841215004L;

	private static final Log LOG = LogFactory.getLog(TicketSuppGoodsAction.class);

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
	private ProdDestReClientService prodDestReService;

	@Autowired
	private SuppGoodsExpService suppGoodsExpService;

	@Autowired
	private SuppGoodsRefundService suppGoodsRefundService;

	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;
	@Autowired
	private SuppGoodsDescClientService suppGoodsDescService;
	@Autowired
	private SuppGoodsDescJsonService suppGoodsDescJsonService;
	
	@Autowired
	private PassProductGoodsDubboService passProductGoodsDubboService;

	/*DEL_PROD_GOODS_RE_0313@Autowired
	private EbkUserService ebkUserService;

	@Autowired
	private EbkUserPrdGoodsReService ebkUserPrdGoodsReService;*/

	@Autowired
	private SuppGoodsAdditionClientService suppGoodsAdditionClientRemote;

	@Autowired
	private TntGoodsChannelCouponAdapter tntGoodsChannelCouponServiceRemote;

	@Autowired
	private ComOrderRequiredClientService comOrderRequiredService;

	@Autowired
	private BizBuEnumClientService bizBuEnumClientService;

	@Autowired
	private SuppGoodsSkuRelationClientService skuRelationService;

	@Autowired
	private SuppGoodsOrderClientService suppGoodsOrderService;

	@Autowired
	private SuppGoodsCircusClientService suppGoodsCircusService;

	@Autowired
	private ProdSmsChannelClientService prodSmsChannelService;

	@Autowired
	private PushAdapterService pushAdapterService;

	@Autowired
	private SuppGoodsEditPermRemoteService suppGoodsEditPermService;

    @Autowired
    private SuppGoodsRescheduleService suppGoodsRescheduleService;

    @Autowired
    private PassportService passportServiceRemote;

	@Autowired
	SuppGoodsAddTimePriceService suppGoodsAddTimePriceService;

	@Autowired
	SuppGoodsNotimeTimePriceService suppGoodsNotimeTimePriceService;

	@Autowired
	ProdBranchDictionaryService prodBranchDictionaryService;
	
	@Autowired
	private ResPreControlTimePriceService resPreControlTimeService;
	
	@Autowired
	SuppGoodsQueryService suppGoodsQueryService;
	@Autowired
	PetMessageServiceAdapter petMessageService;
	@Autowired
	private SuppSettlementEntitiesService suppSettlementEntitiesService; // 结算对象SETTLE_ENTITY_MARK
	@Autowired
    private  EbkUserClientService ebkUserClientService;
	
	@Autowired
	private SuppGoodsExpAdapterService suppGoodsExpAdapterService;
	@Autowired
	private SuppGoodsRefundAdapterService suppGoodsRefundAdapterService;
	@Autowired
	private SuppGoodsDescAdapterService suppGoodsDescAdapterService;
	@Autowired
	private SuppGoodsDescJsonAdapterService suppGoodsDescJsonAdapterService;
	@Autowired
	private SuppGoodsHotelAdapterClientService suppGoodsHotelAdapterService;
	@Autowired
	private ProdProductHotelAdapterService prodProductHotelAdapterService;



	@RequestMapping(value = "/showSuppGoodsListCheck.do")
	@ResponseBody
	public Object showSuppGoodsListCheck(HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showSuppGoodsListCheck>");
		}
		ResultMessage message = null;
		if (req.getParameter("productId") != null) {
			ProdProduct prodProduct = prodProductService.findProdProductByProductId(Long.valueOf(req.getParameter("productId")));
			// 商品维护前，产品基本信息check
			message = new ResultMessage("success", "success");
			if ((prodProduct == null) || (prodProduct.getProductId() == null)) {
				message = new ResultMessage("error", "该产品不存在，请先维护产品！");
				return message;
			}
		}
		return message;
	}

	@RequestMapping(value = "/showSuppGoodsList.do")
	public String showSuppGoodsList(Model model, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showSuppGoodsList>");
		}
		if (req.getParameter("productId") != null) {
			ProdProduct prodProduct = prodProductService.findProdProductByProductId(Long.valueOf(req.getParameter("productId")));
			model.addAttribute("prodProduct", prodProduct);
			Map<String, Object> parameprodProductBranch = new HashMap<String, Object>();
			parameprodProductBranch.put("productId", prodProduct.getProductId());
			List<ProdProductBranch> prodProductBranchList = prodProductBranchService.findProdProductBranchList(parameprodProductBranch);
			SuppGoods suppGoods = new SuppGoods();
			prodProduct.setBizCategory(bizCategoryQueryService.getCategoryById(prodProduct.getBizCategoryId()));
			suppGoods.setProdProduct(prodProduct);
			model.addAttribute("prodProductBranchList", prodProductBranchList);
			model.addAttribute("suppGoods", suppGoods);
			selectExistsSupplierDisableMark(model, prodProduct.getProductId());
		}
		return "/goods/ticket/goods/findSuppGoodsList";
	}

	@RequestMapping(value = "/showSuppGoodsOrderCheck.do")
	@ResponseBody
	public Object showSuppGoodsOrderCheck(HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showSuppGoodsOrderCheck>");
		}
		ResultMessage message = null;
		if (req.getParameter("productId") != null) {
			ProdProduct prodProduct = prodProductService.getProdProductBy(Long.valueOf(req.getParameter("productId")));
			// 商品维护前，产品基本信息check
			message = new ResultMessage("success", "success");
			if ((prodProduct == null) || (prodProduct.getProductId() == null)) {
				message = new ResultMessage("error", "该产品不存在，请先维护产品！");
				return message;
			}
		}
		return message;
	}

	@RequestMapping(value = "/showSuppGoodsOrder.do")
	public String showSuppGoodsOrder(Model model, Long productId, Long distributorId, Long categoryId, String goodsSpecCode, Integer page, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showSuppGoodsOrder>");
		}
		if (req.getParameter("productId") != null) {
			Map<String, Object> parameters = new HashMap<String, Object>();
			parameters.put("productId", productId);
			ProdProduct prodProduct = prodProductService.findProdProductByProductId(productId);

			if (categoryId == null) {
				categoryId = BizEnum.BIZ_CATEGORY_TYPE.category_single_ticket.getCategoryId();
			}
			if (BizEnum.BIZ_CATEGORY_TYPE.category_single_ticket.getCategoryId().equals(categoryId)) {
				if (goodsSpecCode == null) {
					goodsSpecCode = SuppGoods.GOODSSPEC.ADULT.getCode();
				}
				parameters.put("goodsSpec", goodsSpecCode);
			} else {
				goodsSpecCode = null;
			}
			List<Distributor> distributorList = this.getAllDistributors();
			boolean foundDistributorId = false;
			for (Distributor distributor : distributorList) {
				if (distributorId == null) {
					break;
				}
				if (distributor.getDistributorId().equals(distributorId)) {
					foundDistributorId = true;
					break;
				}
			}

			if (!foundDistributorId) {
				distributorId = distributorList.get(1).getDistributorId();
			}

			parameters.put("categoryId", categoryId);
			parameters.put("onlineFlag", "Y");
			parameters.put("distributionId", distributorId);
			model.addAttribute("categoryId", categoryId);
			model.addAttribute("distributorId", distributorId);
			model.addAttribute("goodsSpecCode", goodsSpecCode);

			int pagenum = page == null ? 1 : page;
			suppGoodsOrderService.findSuppGoodsOrder(model, prodProduct, distributorId, categoryId, pagenum, parameters, req);

			prodProduct.setBizCategory(bizCategoryQueryService.getCategoryById(prodProduct.getBizCategoryId()));

			model.addAttribute("bizCategoryList", this.getAllTicketCategories()); //所有门票品类
			model.addAttribute("goodsSpecList", this.getAllTicketGoodsSpec()); //所有门票票种
			model.addAttribute("payTargetList", SuppGoods.PAYTARGET.values());
			model.addAttribute("prodProduct", prodProduct);
			model.addAttribute("distributorList", distributorList);
			selectExistsSupplier(model, prodProduct.getProductId());
		}
		return "/goods/ticket/goods/findSuppGoodsOrder";
	}

	@RequestMapping(value = "/saveSuppGoodsOrder.do", method = RequestMethod.POST)
	@ResponseBody
	public Object saveSuppGoodsOrder(Model model, @RequestBody SuppGoodsOrder[] suppGoodsOrders, HttpServletRequest req) throws BusinessException {
		try {
			String message = suppGoodsOrderService.saveSuppGoodsOrderList(suppGoodsOrders);
			if (message != null) {
				return  new ResultMessage("fail", message);
			}
		} catch (Exception e) {
			LOG.info(e.getMessage());
			return  new ResultMessage("fail", "保存失败");
		}
		Map<String, Object> result = new HashMap<String, Object>();

		return new ResultMessage(result, "success", "保存成功");
	}

	private List<BizCategory> getAllTicketCategories() {
		return bizCategoryQueryService.getBizCategorysByParentCategoryId(BizEnum.BIZ_CATEGORY_TYPE.category_ticket.getCategoryId());
	}

	private List<Distributor> getAllDistributors() {
		// 分销商列表
		Map<String, Object> paramDistributor = new HashMap<String, Object>();
		paramDistributor.put("cancelFlag", "Y");
		paramDistributor.put("_orderby", "DISTRIBUTOR_ID");
		paramDistributor.put("_order", "ASC");
		return distributorService.findDistributorList(paramDistributor).getReturnContent();
	}

	private SuppGoods.GOODSSPEC[] getAllTicketGoodsSpec() {
		return SuppGoods.GOODSSPEC.values();
	}

	private void selectExistsSupplier(Model model, Long productId) {
		//已经存在的供应商
		List<SuppSupplier> suppSupplierList = MiscUtils.autoUnboxing(suppSupplierService.findSuppSupplierListByProductId(productId));
		if(suppSupplierList != null) {
			JSONArray array = new JSONArray();
			for(SuppSupplier supp : suppSupplierList) {
				if(supp!=null){
					JSONObject obj=new JSONObject();
					obj.put("id", supp.getSupplierId());
					obj.put("text", supp.getSupplierName());
					array.add(obj);
				}
			}
			if(array.size() > 0) {
				model.addAttribute("suppJsonList", array.toString());
			}
		}
	}

	private void selectExistsSupplierDisableMark(Model model, Long productId) {
		//已经存在的供应商
		List<SuppSupplier> suppSupplierList = MiscUtils.autoUnboxing(suppSupplierService.findSuppSupplierListByProductId(productId));
		if(suppSupplierList != null) {
			JSONArray array = new JSONArray();
			JSONArray arrayDisable = new JSONArray();
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("productId", productId);
			params.put("cancelFlag", "Y");
			params.put("bizBranchCancelFlag", "Y");

			for(SuppSupplier supp : suppSupplierList) {
				if(supp!=null){
					JSONObject obj=new JSONObject();
					Long supplierId = supp.getSupplierId();
					obj.put("id", supp.getSupplierId());

					params.put("supplierId", supplierId);
					Integer result = suppGoodsService.findSuppGoodsCountBySupplierId(params);
					if(result.intValue()==0){
						obj.put("text", supp.getSupplierName()+"（无效）");
						arrayDisable.add(obj);
					}else{
						obj.put("text", supp.getSupplierName());
						array.add(obj);
					}
				}
			}
			if(arrayDisable.size() > 0){
				array.addAll(arrayDisable);
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
	@SuppressWarnings({ "rawtypes", "unchecked", "deprecation" })
	@RequestMapping(value = "/findSuppGoodsList.do")
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
			bizBranchList = MiscUtils.autoUnboxing(branchService.findBranchListByParams(parBizBranch));

			// 查询产品信息
			ProdProduct prodProduct = prodProductService.findProdProduct4FrontById(suppGoods.getProductId(),false,false);
			suppGoods.setProdProduct(prodProduct);
		}

		if(bizBranchList.size()>0){
			int sort = 1;
			for (BizBranch bizBranch : bizBranchList) {
				String bizBranchKey;
				if ("Y".equals(bizBranch.getAttachFlag())) {
					bizBranchKey = sort+ "<h2 class='fl'>" + bizBranch.getBranchName() + "</h2> (主规格)_"+bizBranch.getBranchId();
				} else {
					bizBranchKey = sort+ "<h2 class='fl'>" + bizBranch.getBranchName() + "</h2> (次规格)_"+bizBranch.getBranchId();
				}
				branchIdMap.put(bizBranchKey, bizBranch.getBranchId());
				++sort;
			}
		}

		for (Object o : branchIdMap.entrySet()) {
			Map.Entry pairs = (Map.Entry) o;
			Map<String, Object> parSuppGoods = new HashMap<String, Object>();
			// 取得商品
			parSuppGoods.put("branchId", pairs.getValue());
			parSuppGoods.put("productId", suppGoods.getProductId());
			parSuppGoods.put("supplierId", suppGoods.getSupplierId());
			if (Constants.Y_FLAG.equals(suppGoods.getCancelFlag()) || Constants.N_FLAG.equals(suppGoods.getCancelFlag())) {
				parSuppGoods.put("cancelFlag", suppGoods.getCancelFlag());
			}
			parSuppGoods.put("_orderby", "seq asc");
			List<SuppGoods> suppGoodsList = suppGoodsService.findSuppGoodsByBranchIdAndProductId(parSuppGoods);
			for (SuppGoods suppGoods2 : suppGoodsList) {
				// 设置门票票种名称（已增加门票票种名称字段）
				suppGoods2.setGoodsSpecName(SuppGoods.GOODSSPEC.getCnName(suppGoods2.getGoodsSpec() == null ? "" : suppGoods2.getGoodsSpec()));

				suppGoods2.setSuppGoodsAddition(suppGoodsAdditionClientRemote.selectByPrimaryKey(suppGoods2.getSuppGoodsId()));
				suppGoods2.setProdProductBranch(prodProductBranchService.findProdProductBranchById(suppGoods2.getProductBranchId()));
			}

			if (suppGoodsList.size() > 0) {
				Set<Long> manageIds = new HashSet<Long>();
				Set<Long> contentManagerIds = new HashSet<Long>();
				Set<Long> regionalLeaderIds = new HashSet<Long>();
				Set<Long> commercialStaffIds = new HashSet<Long>();
				for (SuppGoods sc : suppGoodsList) {
					if (sc.getContractId() != null && sc.getContractId() > 0) {
						SuppContract suppContract = suppContractService.findSuppContractById(sc.getContractId());
						sc.setSuppContract(suppContract);
						manageIds.add(sc.getManagerId());
					}
					contentManagerIds.add(sc.getContentManagerId());
					regionalLeaderIds.add(sc.getRegionalLeaderId());
					commercialStaffIds.add(sc.getCommercialStaffId());
				}
				//设置产品经理
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userIds", manageIds.toArray());
				params.put("maxResults", 100);
				params.put("skipResults", 0);

				List<PermUser> permUserList = permUserServiceAdapter.queryPermUserByParam(params);
				for (PermUser permUser : permUserList) {
					for (SuppGoods suppGoods1 : suppGoodsList) {
						if (suppGoods1.getManagerId() != null && suppGoods1.getManagerId().equals(permUser.getUserId())) {
							suppGoods1.setManagerName(permUser.getRealName());
						}
					}
				}
				//设置内容维护人员
				params.put("userIds", contentManagerIds.toArray());
				List<PermUser> contentManagerList = permUserServiceAdapter.queryPermUserByParam(params);
				for (PermUser permUser : contentManagerList) {
					for (SuppGoods suppGoods1 : suppGoodsList) {
						if (suppGoods1 != null && suppGoods1.getContentManagerId() != null && suppGoods1.getContentManagerId().equals(permUser.getUserId())) {
							suppGoods1.setContentManagerName(permUser.getRealName());
						}
					}
				}
				//设置区域负责人
				params.put("userIds", regionalLeaderIds.toArray());
				List<PermUser> regionalLeaderList = permUserServiceAdapter.queryPermUserByParam(params);
				for (PermUser permUser : regionalLeaderList) {
					for (SuppGoods suppGoods1 : suppGoodsList) {
						if (suppGoods1 != null && suppGoods1.getRegionalLeaderId() != null && suppGoods1.getRegionalLeaderId().equals(permUser.getUserId())) {
							suppGoods1.setRegionalLeaderName(permUser.getRealName());
						}
					}
				}

				//设置商务人员
				params.put("userIds", commercialStaffIds.toArray());
				List<PermUser> commercialStaffList = permUserServiceAdapter.queryPermUserByParam(params);
				for (PermUser permUser : commercialStaffList) {
					for (SuppGoods suppGoods1 : suppGoodsList) {
						if (suppGoods1 != null && suppGoods1.getCommercialStaffId() != null && suppGoods1.getCommercialStaffId().equals(permUser.getUserId())) {
							suppGoods1.setCommercialStaffName(permUser.getRealName());
						}
					}
				}
			}
			branchIdMap.put(pairs.getKey(), suppGoodsList);

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
		if(suppGoods != null){
			parameprodProductBranch.put("productId", suppGoods.getProductId());
		}
		List<ProdProductBranch> prodProductBranchList = prodProductBranchService.findProdProductBranchList(parameprodProductBranch);
		model.addAttribute("prodProductBranchList", prodProductBranchList);
		model.addAttribute("suppGoods", suppGoods);
		model.addAttribute("suppGoodsMap", branchIdMap);
		if(suppGoods != null){
			selectExistsSupplierDisableMark(model, suppGoods.getProductId());
		}

		return "/goods/ticket/goods/findSuppGoodsList";
	}

	/**
	 * 跳转到修改页面
	 *
	 * @return
	 */
	@RequestMapping(value = "/showUpdateSuppGoods.do")
	public String showUpdateSuppGoods(Model model, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showUpdateSuppGoods>");
		}
		Long prodValue=0L;
		List<ProdProductBranch> prodProductBranchList = null;
		SuppGoods suppGoods = null;
		SuppGoodsExp suppGoodsExp = null;
		if (StringUtils.isNotBlank(req.getParameter("suppGoodsId")) && StringUtils.isNotBlank(req.getParameter("productId")) && StringUtils.isNotBlank(req.getParameter("supplierId"))) {
			Map<String, Object> paramProdProductBranch = new HashMap<String, Object>();
			paramProdProductBranch.put("productId", String.valueOf(req.getParameter("productId")));
			paramProdProductBranch.put("hasProp", true);
			paramProdProductBranch.put("hasPropValue", true);
			prodProductBranchList = prodProductBranchService.findProdProductBranchList(paramProdProductBranch);
			suppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(Long.valueOf(req.getParameter("suppGoodsId")), Boolean.FALSE, Boolean.FALSE));
			if(suppGoods != null)
			{
				if(suppGoods.getLimitBookDay() == null) {
					suppGoods.setLimitBookDay(-1L);
				}
				// 取得有效期
				Map<String, Object> paramSuppGoodsExp = new HashMap<String, Object>();
				paramSuppGoodsExp.put("goodsId", suppGoods.getSuppGoodsId());
				List<SuppGoodsExp> suppGoodsExpList = suppGoodsExpService.findSuppGoodsExpList(paramSuppGoodsExp);
				if (CollectionUtils.isNotEmpty(suppGoodsExpList)) {
					suppGoodsExp = suppGoodsExpList.get(0);
				}
				// 取得退改策略
				Map<String, Object> paramSuppGoodsRefund = new HashMap<String, Object>();
				paramSuppGoodsRefund.put("goodsId", suppGoods.getSuppGoodsId());
				paramSuppGoodsRefund.put("cancelStrategyType", "RETREATANDCHANGE");
				suppGoods.setGoodsReFundList(suppGoodsRefundService.findSuppGoodsRefundList(paramSuppGoodsRefund));

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
				//设置区域负责人
				PermUser regionalLeader = permUserServiceAdapter.getPermUserByUserId(suppGoods.getRegionalLeaderId());
				if(null != regionalLeader){
					suppGoods.setRegionalLeaderName(regionalLeader.getRealName());
				}
				//设置商务人员

				PermUser commercialStaff = permUserServiceAdapter.getPermUserByUserId(suppGoods.getCommercialStaffId());
				if(null != commercialStaff){
					suppGoods.setCommercialStaffName(commercialStaff.getRealName());
				}

				//商品品类细分逻辑
                prodValue = getProdValueAndSetModelForCategoryDetail(model, req, prodValue,false);
				// 门票票种
				model.addAttribute("goodsSpecList", SuppGoods.GOODSSPEC.values());
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
			}
			//设置产品经理
			PermUser manager = permUserServiceAdapter.getPermUserByUserId(suppGoods.getManagerId());
			if(null != manager){
				suppGoods.setManagerName(manager.getRealName());
			}

			//如何是出境商品进行主从商品检查
			if (CommEnumSet.BU_NAME.OUTBOUND_BU.getCode().equals(suppGoods.getBu())) {
				// 查询选择商品是否有主商品
				Long masterSuppGoodsId = skuRelationService.selectMasterSuppGoodsIdBySlaveGoodsId(suppGoods.getSuppGoodsId());
				LOG.info("OUTBOUND BU TICKET:" + masterSuppGoodsId);
				if (masterSuppGoodsId != null) {
					model.addAttribute("masterSuppGoodsId", masterSuppGoodsId);
				}
			}

			// 门票票种
			model.addAttribute("goodsSpecList", SuppGoods.GOODSSPEC.values());
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
            //取票类型
            model.addAttribute("takeTimeTypeList", SuppGoodsExp.TAKE_TIME_ENUM.values());
            //方式
            model.addAttribute("actList", SuppGoodsExp.ACT_ENUM.values());
            //有效期类型
            model.addAttribute("expTypeList", SuppGoodsExp.EXP_TIME_ENUM.values());
            model.addAttribute("refundTypeList", SuppGoodsRefund.REFUND_TYPE.values());
			if (StringUtils.isNotBlank(req.getParameter("categoryId"))) {
				Map<String, Object> paramSuppFax = new HashMap<String, Object>();
				paramSuppFax.put("supplierId", Long.valueOf(req.getParameter("supplierId")));
				paramSuppFax.put("categoryId", Long.valueOf(req.getParameter("categoryId")));
				paramSuppFax.put("cancelFlag", "Y");// 有效定义
				List<SuppFaxRule> suppFaxRuleList = suppFaxService.findSuppFaxRuleList(paramSuppFax);
				model.addAttribute("suppFaxRuleList", suppFaxRuleList);
			}
		}

		// 判断是否是组合套餐票
		BizCategory category  = bizCategoryQueryService.getCategoryById(Long.valueOf(req.getParameter("categoryId")));
		if("category_comb_ticket".equalsIgnoreCase(category.getCategoryCode())){
			model.addAttribute("combTicketFlag", "Y");
		}else{
			model.addAttribute("combTicketFlag", "N");
		}

		// 取得产品对应的销售渠道信息
		Map<String, Object> paraDistDistributorSuppGoods = new HashMap<String, Object>();
		if(suppGoods != null){
			paraDistDistributorSuppGoods.put("suppGoodsId", suppGoods.getSuppGoodsId());
			suppGoods.setDistDistributorGoods(distributorGoodsService.findDistDistributorGoodsList(paraDistDistributorSuppGoods));
		}

//		Map<String, Object> circusParams = new HashMap<String, Object>();
//		circusParams.put("suppGoodsId", suppGoods.getSuppGoodsId());
		List<SuppGoodsCircus> suppGoodsCircusList = MiscUtils.autoUnboxing(suppGoodsCircusService.getSuppGoodsCircusByGoodsId(suppGoods.getSuppGoodsId()));
		if(CollectionUtils.isNotEmpty(suppGoodsCircusList)) {
			suppGoods.setIsCircus("1");
		} else {
			suppGoods.setIsCircus("0");
		}
        //获取改期设置
		 String isCanReschedule=isCanReschedule(suppGoods);
	     model.addAttribute("isCanReschedule",isCanReschedule);
        SuppGoodsReschedule suppGoodsReschedule = suppGoodsRescheduleService.findSuppGoodsRescheduleByGoodsId(suppGoods.getSuppGoodsId());
        if(null!=suppGoodsReschedule && SuppGoods.GOODSTYPE.NOTICETYPE_DISPLAY.name().equalsIgnoreCase(suppGoods.getGoodsType())
                && SuppGoods.PAYTARGET.PREPAID.name().equalsIgnoreCase(suppGoods.getPayTarget())){
            model.addAttribute("goodsReschedule",suppGoodsReschedule);
        }else{
            List<SuppGoodsRefund> goodsReFundList = suppGoods.getGoodsReFundList();
            SuppGoodsReschedule defaultGoodsReschedule = new SuppGoodsReschedule();
            defaultGoodsReschedule.setGoodsId(suppGoods.getSuppGoodsId());
            if(CollectionUtils.isEmpty(goodsReFundList) || !SuppGoods.GOODSTYPE.NOTICETYPE_DISPLAY.name().equalsIgnoreCase(suppGoods.getGoodsType())
                    || !SuppGoods.PAYTARGET.PREPAID.name().equalsIgnoreCase(suppGoods.getPayTarget())){
                defaultGoodsReschedule.setChangeDesc("2");
                defaultGoodsReschedule.setChangeStrategy(SuppGoodsRescheduleVO.CHANGE_STRATEGY.NOTRESCHEDULE.name());
            }else{
                defaultGoodsReschedule.setChangeDesc("3");
                defaultGoodsReschedule.setChangeStrategy(SuppGoodsRescheduleVO.CHANGE_STRATEGY.NOTRESCHEDULE.name());
            }
            model.addAttribute("goodsReschedule",defaultGoodsReschedule);
        }
        //
        
		String onlyLvmamaFlag = prodSmsChannelService.getOnlyLvmamaFlagByGoodsId(suppGoods.getSuppGoodsId());
		LOG.info("showUpdateSuppGoods, onlyLvmamaFlag:" + onlyLvmamaFlag);
		suppGoods.setOnlyLvmamaFlag(onlyLvmamaFlag);

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
			TntGoodsChannelVo tntGoodsChannelVo = tntGoodsChannelVoRt.getReturnContent();
			model.addAttribute("tntGoodsChannelVo", tntGoodsChannelVo);
		}

		ResultHandleT<Long[]> userIdLongRt = tntGoodsChannelCouponServiceRemote.list(Long.parseLong(req.getParameter("productId")),
				Long.parseLong(req.getParameter("suppGoodsId")), TntGoodsChannelCouponAdapter.PG_TYPE.GOODS.name());
		if(userIdLongRt != null && userIdLongRt.getReturnContent() != null && userIdLongRt.isSuccess()){
			Long[] userIdLong = userIdLongRt.getReturnContent();
			StringBuilder userIdLongStr = new StringBuilder(",");
			for(Long userId : userIdLong){
				userIdLongStr.append(userId.toString()).append(",");
			}
			model.addAttribute("userIdLongStr", userIdLongStr.toString());
		}
		
		// 结算对象SETTLE_ENTITY_MARK
		// 设置结算对象
		SuppSettlementEntities settlementEntity = suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(suppGoods.getSettlementEntityCode());
		suppGoods.setSettlementEntity(settlementEntity);
		
		//查询服务商信息
		cateGoryDetailWhichCheck(prodValue, suppGoods);
		PassProvider passProvider = passportServiceRemote.getPassProvide(suppGoods.getSuppGoodsId(), new Date());
		model.addAttribute("passProvider", passProvider);
		model.addAttribute("suppGoods", suppGoods);
		model.addAttribute("suppGoodsExp", suppGoodsExp);
		model.addAttribute("prodProductBranchList", prodProductBranchList);

		// 公司主体
		Map<String, String> companyTypeMap = new HashMap<String, String>();
		for (COMPANY_TYPE_DIC item : COMPANY_TYPE_DIC.values()) {
			companyTypeMap.put(item.name(), item.getTitle());
		}
		model.addAttribute("companyTypeMap", companyTypeMap);

        //结算主体类型
        model.addAttribute("lvAccSubjectList", SuppSettleRule.LVACC_SUBJECT.values());
        //供应商资质类型
        model.addAttribute("qualifyTypeList",SuppSupplier.QUAIFY_TYPE.values());

		this.fillShowCircusFlag(model);
		this.fillShowTianNiuFlag(model);
		this.fillSpecialTicketType(model);
		
		//add by jswujian 凭证码库需求  2017-04-25 begin
		//判断是否已被凭证码库绑定的商品
		LOG.info("TicketSuppGoodsAction#showUpdateSuppGoods#passProductGoodsDubboService.getGoodsAndCredentialsBySuppgoodsId suppGoodsId="+req.getParameter("suppGoodsId"));
		try{
			List<PassProductGoodsRspBo> ppgRsp=passProductGoodsDubboService.getGoodsAndCredentialsBySuppgoodsId(Long.valueOf(req.getParameter("suppGoodsId")));
			if(ppgRsp==null){
				//没有定过
				model.addAttribute("isAlreadyBoundCredentials","N");
			}else{
				model.addAttribute("isAlreadyBoundCredentials","Y");
			}
			LOG.info("TicketSuppGoodsAction#showUpdateSuppGoods#passProductGoodsDubboService.getGoodsAndCredentialsBySuppgoodsId ppgRsp="+com.alibaba.fastjson.JSONObject.toJSONString(ppgRsp));
		}catch(Exception e){
			LOG.error("调用vst_passport系统PassProductGoodsDubboService服务异常", e);
			throw new BusinessException("PassProductGoodsDubboService服务异常");
		}
		//add by jswujian 凭证码库需求  2017-04-25 end
		
		
		return "/goods/ticket/goods/showUpdateSuppGoods";
	}

    private Long getProdValueAndSetModelForCategoryDetail(Model model, HttpServletRequest req, Long prodValue,Boolean isUseAddProductBranchId) {
        String thisProductBranchId =null;
        if(isUseAddProductBranchId){
            thisProductBranchId=req.getParameter("productBranchId");
        }else{
            thisProductBranchId = req.getParameter("thisProductBranchId");
        }
        List<ProdBranchDictionary> goodsCategoryList=null;
        if(StringUtil.isNotEmptyString(thisProductBranchId)) {
            long productBranchId = Long.parseLong(thisProductBranchId);
            goodsCategoryList = prodBranchDictionaryService.findCnNameListByBranchId(productBranchId);
            if(goodsCategoryList!=null && goodsCategoryList.size()>0){
                prodValue=goodsCategoryList.get(0).getProductBranchId();
            }
        }
        //门票商品品类细分
        model.addAttribute("goodsCategoryList",goodsCategoryList);
        return prodValue;
    }

    private void cateGoryDetailWhichCheck(Long prodValue, SuppGoods suppGoods) {
        if(suppGoods==null){
            return;
        }
		if(null== suppGoods.getCategoryDetail() || 0L==suppGoods.getCategoryDetail() ){
//			suppGoods.setCategoryDetail(prodValue*1000+99L);
			if(prodValue!=null && prodValue.equals(310L)){
				suppGoods.setCategoryDetail(prodValue*1000+1L);
			}
		}
	}

	/**
	 * 是否长隆马戏票权限
	 * @return
	 */
	private void fillShowCircusFlag(Model model) {
		//LV6868 王雪梅;LV6147  童小能;  LV6785  王芬；LV13722 余国平; LV6341 刘琴；LV8105 冯晨阳; LV6396 杨梓涵；LV14663 叶盛; LV13816 郝韵 ； lv14971 嵇宁欣;lv15196 陶勇; lv10343 高颜敏
		//lv9692 王雁  ;lv6881 熊鹰；lv15318 章赛英；lv13894 刘芸

		List<SuppGoodsEditPerm> suppGoodsEditPermList = suppGoodsEditPermService.selectAllEditPermFromMemCache();
		String isShowCircusFlag = "N";
		for (SuppGoodsEditPerm suppGoodsEditPerm : suppGoodsEditPermList) {
			if( SuppGoodsEditPerm.PERM_TYPE.IS_CIRCUS.getCode().equals(suppGoodsEditPerm.getPermType())
				&& suppGoodsEditPerm.getUserName().equals(getLoginUserId())){
					isShowCircusFlag = "Y";
					break;
			}
		}
		model.addAttribute("isShowCircusFlag", isShowCircusFlag);
	}

	/**
	 * 是否天牛计划权限
	 * @param model
	 */
	private void fillShowTianNiuFlag(Model model) {
		//admin ;lv5738 吴宇
		List<SuppGoodsEditPerm> suppGoodsEditPermList = suppGoodsEditPermService.selectAllEditPermFromMemCache();
		String isShowTianNiuFlag = "N";
		for (SuppGoodsEditPerm suppGoodsEditPerm : suppGoodsEditPermList) {
			if( SuppGoodsEditPerm.PERM_TYPE.TIAN_NIU_FLAG.getCode().equals(suppGoodsEditPerm.getPermType())
				&& suppGoodsEditPerm.getUserName().equals(getLoginUserId())){
					isShowTianNiuFlag = "Y";
					break;
			}
		}
		model.addAttribute("isShowTianNiuFlag", isShowTianNiuFlag);
	}

	/**
	 * 跳转到添加商品
	 *
	 * @return
	 */
	@RequestMapping(value = "/showAddSuppGoods.do")
	public String showAddSuppGoods(Model model, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showAddSuppGoods>");
		}
        Long prodValue=0L;
		List<ProdProductBranch> prodProductBranchList = null;
		SuppGoods suppGoods = null;
		if (StringUtils.isNotBlank(req.getParameter("productId")) && StringUtils.isNotBlank(req.getParameter("supplierId"))&& StringUtils.isNotBlank(req.getParameter("aperiodicFlag"))) {
			Map<String, Object> paramProdProductBranch = new HashMap<String, Object>();
			paramProdProductBranch.put("productId", String.valueOf(req.getParameter("productId")));
			paramProdProductBranch.put("cancelFlag", "Y");
			paramProdProductBranch.put("hasProp", true);
			paramProdProductBranch.put("hasPropValue", true);
			prodProductBranchList = prodProductBranchService.findProdProductBranchList(paramProdProductBranch);
			suppGoods = new SuppGoods();
			SuppSupplier suppSupplier = new SuppSupplier();
			suppSupplier.setSupplierId(Long.valueOf(req.getParameter("supplierId")));
			suppGoods.setSuppSupplier(suppSupplier);
			ProdProduct prodProduct = new ProdProduct();
			prodProduct.setProductId(Long.valueOf(req.getParameter("productId")));
			// 取得产品目的地关联
			Map<String, Object> paraProdDestRe = new HashMap<String, Object>();
			paraProdDestRe.put("productId", prodProduct.getProductId());
			prodProduct.setProdDestReList(prodDestReService.findProdDestReByParams(paraProdDestRe));

			suppGoods.setProdProduct(prodProduct);
			suppGoods.setAperiodicFlag(req.getParameter("aperiodicFlag"));
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
            //商品品类细分逻辑
            prodValue = getProdValueAndSetModelForCategoryDetail(model, req, prodValue,true);
			// 门票票种
			model.addAttribute("goodsSpecList", SuppGoods.GOODSSPEC.values());
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
            //取票类型
            model.addAttribute("takeTimeTypeList", SuppGoodsExp.TAKE_TIME_ENUM.values());
            //方式
            model.addAttribute("actList", SuppGoodsExp.ACT_ENUM.values());
            //有效期类型
            model.addAttribute("expTypeList", SuppGoodsExp.EXP_TIME_ENUM.values());
            model.addAttribute("refundTypeList", SuppGoodsRefund.REFUND_TYPE.values());
			if (StringUtils.isNotBlank(req.getParameter("categoryId"))) {
			    suppGoods.setCategoryId(Long.valueOf(req.getParameter("categoryId")));
				Map<String, Object> paramSuppFax = new HashMap<String, Object>();
				paramSuppFax.put("supplierId", Long.valueOf(req.getParameter("supplierId")));
				paramSuppFax.put("categoryId", Long.valueOf(req.getParameter("categoryId")));
				paramSuppFax.put("cancelFlag", "Y");// 有效定义
				List<SuppFaxRule> suppFaxRuleList = suppFaxService.findSuppFaxRuleList(paramSuppFax);
				model.addAttribute("suppFaxRuleList", suppFaxRuleList);
			}
		}
		// 判断是否是组合套餐票
		BizCategory category  = bizCategoryQueryService.getCategoryById(Long.valueOf(req.getParameter("categoryId")));
 		if("category_comb_ticket".equalsIgnoreCase(category.getCategoryCode())){
			model.addAttribute("combTicketFlag", "Y");
		}else{
 			model.addAttribute("combTicketFlag", "N");
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
			TntGoodsChannelVo tntGoodsChannelVo = tntGoodsChannelVoRt.getReturnContent();
			model.addAttribute("tntGoodsChannelVo", tntGoodsChannelVo);
		}
        if(prodValue.equals(310L)){
            suppGoods.setCategoryDetail(310001L);
        }
        
		// 结算对象SETTLE_ENTITY_MARK
		// 设置结算对象
//		SuppSettlementEntities settlementEntity = suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(suppGoods.getSettlementEntityCode());
//		suppGoods.setSettlementEntity(settlementEntity);
        
		model.addAttribute("suppGoods", suppGoods);
		model.addAttribute("prodProductBranchList", prodProductBranchList);

		// 公司主体
		Map<String, String> companyTypeMap = new HashMap<String, String>();
		for (COMPANY_TYPE_DIC item : COMPANY_TYPE_DIC.values()) {
			companyTypeMap.put(item.name(), item.getTitle());
		}
		
		//查询服务商信息
		Map<String,Object> paramsMap = new HashMap<String,Object>();
		paramsMap.put("suppSupplierId", Long.valueOf(req.getParameter("supplierId")));
		PassProvider passProvider = passportServiceRemote.findPassSupplierListSorted(paramsMap);
		model.addAttribute("passProvider", passProvider);
		model.addAttribute("companyTypeMap", companyTypeMap);
        //结算主体类型
        model.addAttribute("lvAccSubjectList", SuppSettleRule.LVACC_SUBJECT.values());
        //供应商资质类型
        model.addAttribute("qualifyTypeList",SuppSupplier.QUAIFY_TYPE.values());


        this.fillShowCircusFlag(model);
		this.fillShowTianNiuFlag(model);
		this.fillSpecialTicketType(model);
		return "/goods/ticket/goods/showAddSuppGoods";
	}

	private void fillSpecialTicketType(Model model) {
		String isShowSpecialTicketType = this.getShowSpecialTicketTypeFlag();
		SuppGoods.SPECIAL_TICKET_TYPE[] specialTicketTypes = SuppGoods.SPECIAL_TICKET_TYPE.values();
		model.addAttribute("specialTicketTypes", specialTicketTypes);
		model.addAttribute("isShowSpecialTicketType", isShowSpecialTicketType);
	}

	/**
	 * 特殊门票类型权限
	 * @return
	 */
	private String getShowSpecialTicketTypeFlag() {
		//lv1543（吉凯） lv6868（王雪梅） lv6878（梁振宇） lv5088（侯秦） lv5887（陶单红） lv11230（杨钰琦） lv10343（高颜敏）lv14671（冯沁） lv8791（陆定益） lv5812 （于海存）LV8165(冯晨阳)  LV6341(刘琴);lv15196 陶勇; lv10343 高颜敏;lv14579 王辉
		//lv9692 王雁  ;lv6881 熊鹰

		String isShowSpecialTicketType = "N";
		List<SuppGoodsEditPerm> suppGoodsEditPermList = suppGoodsEditPermService.selectAllEditPermFromMemCache();
		LOG.info("getShowSpecialTicketTypeFlag   suppGoodsEditPermList.size"+suppGoodsEditPermList.size());
		for (SuppGoodsEditPerm suppGoodsEditPerm : suppGoodsEditPermList) {
			if( SuppGoodsEditPerm.PERM_TYPE.SPECIAL_TICKET_TYPE.getCode().equals(suppGoodsEditPerm.getPermType())
				&& suppGoodsEditPerm.getUserName().equals(getLoginUserId())){
					isShowSpecialTicketType = "Y";
					break;
			}
		}
		LOG.info("isShowSpecialTicketType  "+isShowSpecialTicketType);
		return isShowSpecialTicketType;
	}

	/**
	 * 更新产品
	 */
	@RequestMapping(value = "/updateSuppGoods.do")
	@ResponseBody
	public Object updateSuppGoods(SuppGoods suppGoods,SuppGoodsExp suppGoodsExp,String distributorUserIds,String cancelStrategy, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<updateSuppGoods>");
		}
		try{

			boolean isSuppGoodsRefund = false; // 退单信息是否改变
			boolean isOrderLimit = false; // 预订限制是否改变

            if(!"".equals(suppGoodsExp.getUnvalidData())&&suppGoodsExp.getUnvalidData()!=null){
                JSONObject jsonObject= JSONObject.fromObject(suppGoodsExp.getUnvalidData());

                this.setUnvalidDesc(jsonObject,suppGoodsExp);
                if(SuppGoodsExp.EXP_TIME_ENUM.PERIOD.getCode().equals(suppGoodsExp.getUseType())){
                    ResultMessage resultMessage = this.setUnvalid(jsonObject, suppGoodsExp);
                    if(resultMessage != null){
                        return resultMessage;
                    }
                }
            }else{
                suppGoodsExp.setUnvalidDesc("");
            }


			if (suppGoods != null) {

				Long newLimitBookDay;

				if (suppGoods.getLimitBookDay() == null)
					newLimitBookDay = -1L;
				else
					newLimitBookDay = suppGoods.getLimitBookDay();

				log.info("newLimitBookDay: " + suppGoods.getLimitBookDay() + "|newLimitBookDaySwitch: " + newLimitBookDay);

				if(null != suppGoods.getManagerId())
				{
					//设置组织ID
					PermUser manager = permUserServiceAdapter.getPermUserByUserId(suppGoods.getManagerId());
					if(null != manager){
						suppGoods.setOrgId(manager.getDepartmentId());
					}
				}
			
			//获取原商品
			SuppGoods oldSuppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoods.getSuppGoodsId(), Boolean.FALSE, Boolean.FALSE));
			//查看原产品是否勾选 是否长隆马戏票
			List<SuppGoodsCircus> oldSuppGoodsCircusList = MiscUtils.autoUnboxing(suppGoodsCircusService.getSuppGoodsCircusByGoodsId(oldSuppGoods.getSuppGoodsId()));
			if(CollectionUtils.isNotEmpty(oldSuppGoodsCircusList)){
				oldSuppGoods.setIsCircus("1");
			}
            
            //查看原产品是否勾选 分销独立短信通道
			String onlyLvmamaFlag = prodSmsChannelService.getOnlyLvmamaFlagByGoodsId(oldSuppGoods.getSuppGoodsId());
			oldSuppGoods.setOnlyLvmamaFlag(onlyLvmamaFlag);
			Long productId = oldSuppGoods.getProductId();
				suppGoods.setCreateTime(oldSuppGoods.getCreateTime());
				suppGoods.setCreateUser(oldSuppGoods.getCreateUser());
				suppGoods.setCancelFlag(oldSuppGoods.getCancelFlag());
				suppGoods.setEbkSupplierGroupId(oldSuppGoods.getEbkSupplierGroupId());
				String isShowSpecialTicketType = this.getShowSpecialTicketTypeFlag();
				log.info("SuppGoodsId: " + suppGoods.getSuppGoodsId() + "当前用户是否有权限："+isShowSpecialTicketType+",修改前商品SpecialTicketType:"+oldSuppGoods.getSpecialTicketType());
				if("N".equals(isShowSpecialTicketType)){
				suppGoods.setSpecialTicketType(oldSuppGoods.getSpecialTicketType());}
				if(suppGoods.getLimitBookDay() == null) {
					suppGoods.setLimitBookDay(-1L);
				}

				Map<String, Object> paramSuppGoodsExp = new HashMap<String, Object>();
				paramSuppGoodsExp.put("goodsId", suppGoods.getSuppGoodsId());
				List<SuppGoodsExp> suppGoodsExpList = suppGoodsExpService.findSuppGoodsExpList(paramSuppGoodsExp);
				SuppGoodsExp oldSuppGoodsExp = null;
				if (CollectionUtils.isNotEmpty(suppGoodsExpList)) {
					oldSuppGoodsExp = suppGoodsExpList.get(0);
				} else {
					oldSuppGoodsExp = new SuppGoodsExp();
				}
				if("Y".equals(suppGoods.getAperiodicFlag())){
					setSuppGoodsAperiodicTypeId(oldSuppGoodsExp,suppGoodsExp,suppGoods);
				}

				// 判断预订限制是否改变
				if ((oldSuppGoods.getPackageFlag().equals(suppGoods.getPackageFlag()) &&
						oldSuppGoods.getMinQuantity().equals(suppGoods.getMinQuantity()) &&
						oldSuppGoods.getMaxQuantity().equals(suppGoods.getMaxQuantity())) &&
						oldSuppGoods.getLimitBookDay().equals(newLimitBookDay)) {
					log.info("SuppGoodsId: " + suppGoods.getSuppGoodsId() + "预订限制没有修改");
				} else {
					log.info("SuppGoodsId: " + suppGoods.getSuppGoodsId() + "预订限制修改了");
					isOrderLimit = true;
				}
				if("Y".equals(suppGoods.getIsBusiness())){
					suppGoods.setIsBusiness("Y");
				}else{
					suppGoods.setIsBusiness("N");
				}
				suppGoodsService.updateSuppGoods(suppGoods);

				//如果非马戏票，则删除马戏票数据
				if("0".equals(suppGoods.getIsCircus())) {
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("suppGoodsId", suppGoods.getSuppGoodsId());

					suppGoodsCircusService.deleteCircusByCondition(params);
				} else {
//				Map<String, Object> circusParams = new HashMap<String, Object>();
//				circusParams.put("suppGoodsId", suppGoods.getSuppGoodsId());
					List<SuppGoodsCircus> suppGoodsCircusList = MiscUtils.autoUnboxing(suppGoodsCircusService.getSuppGoodsCircusByGoodsId(suppGoods.getSuppGoodsId()));

					if(CollectionUtils.isEmpty(suppGoodsCircusList)) {
						SuppGoodsCircus suppGoodsCircus = new SuppGoodsCircus();
						suppGoodsCircus.setProductId(suppGoods.getProductId());
						suppGoodsCircus.setSuppGoodsId(suppGoods.getSuppGoodsId());

						suppGoodsCircusService.saveSuppGoodsCircus(suppGoodsCircus);
					}
				}
                //改期设置更新
                    SuppGoodsReschedule goodsReschedule = suppGoods.getGoodsReschedule();
                    log.info("updateSuppGoods goodsReschedule:"+goodsReschedule);
                    if(null!=goodsReschedule){
                        goodsReschedule.setGoodsId(suppGoods.getSuppGoodsId());
                        SuppGoodsReschedule suppGoodsReschedule = suppGoodsRescheduleService.findSuppGoodsRescheduleByGoodsId(suppGoods.getSuppGoodsId());
                        oldSuppGoods.setGoodsReschedule(suppGoodsReschedule);
                        if(null!=suppGoodsReschedule){
                            goodsReschedule.setRescheduleId(suppGoodsReschedule.getRescheduleId());
                        }
                        suppGoodsRescheduleService.saveOrUpdateSuppGoodsReschedule(goodsReschedule);
                    }
                //

				prodSmsChannelService.updateOnlyLvmmFlagByGoodsId(suppGoods.getSuppGoodsId(), suppGoods.getOnlyLvmamaFlag());
				//更新有效期
				suppGoodsExpService.updateSuppGoodsExpSelective(suppGoodsExp);
				Map<String, Object> map = new HashMap<String,Object>();
				try {
					//检测商品效期和使用次数是否发生变化
					map = this.isChangedForExp(map,oldSuppGoodsExp,suppGoodsExp);
				} catch (Exception e) {
					log.info("Send information to the freedom failure");
					log.error(e.getMessage());
				}	
				//设置门票的退改
				Map<String, Object> paramSuppGoodsRefund = new HashMap<String, Object>();
				paramSuppGoodsRefund.put("goodsId", suppGoods.getSuppGoodsId());
				List<SuppGoodsRefund> suppGoodsRefundList = suppGoodsRefundService.findSuppGoodsRefundList(paramSuppGoodsRefund);
				if(!CollectionUtils.isEmpty(suppGoodsRefundList)){
					for(SuppGoodsRefund sgr :suppGoodsRefundList){
						suppGoodsRefundService.deleteByPrimaryKey(sgr.getRefundId());
					}
				}
				List<SuppGoodsRefund> suppGoodsRefundListTemp = new ArrayList<SuppGoodsRefund>(); // 定义临时存储变量
				//System.out.println("cancelStrategy===="+cancelStrategy);
				if((SuppGoodsBaseTimePrice.CANCELSTRATEGYTYPE.RETREATANDCHANGE.name().equals(cancelStrategy) || SuppGoodsBaseTimePrice.CANCELSTRATEGYTYPE.PARTRETREATANDCHANGE.name().equals(cancelStrategy))
						&& suppGoods.getGoodsReFundList()!=null && suppGoods.getGoodsReFundList().size()>0){
					for(SuppGoodsRefund sgr : suppGoods.getGoodsReFundList()){
						if(sgr.getDeductType() ==null || sgr.getDeductValue() ==null || (sgr.getLatestCancelTime()==null && StringUtils.isBlank(sgr.getCancelTimeType()))){
							continue;
						}
						sgr.setGoodsId(suppGoods.getSuppGoodsId());
						sgr.setCancelStrategy(cancelStrategy);
						suppGoodsRefundService.addSuppGoodsRefund(sgr);
						suppGoodsRefundListTemp.add(sgr);
					}
				}
				if(SuppGoodsBaseTimePrice.CANCELSTRATEGYTYPE.UNRETREATANDCHANGE.name().equals(cancelStrategy)){
					SuppGoodsRefund supGoodsRefund = new SuppGoodsRefund();
					supGoodsRefund.setGoodsId(suppGoods.getSuppGoodsId());
					supGoodsRefund.setCancelStrategy(cancelStrategy);
					suppGoodsRefundService.addSuppGoodsRefund(supGoodsRefund);
					suppGoods.setGoodsReFundList(Arrays.asList(supGoodsRefund));
					suppGoodsRefundListTemp.add(supGoodsRefund);
				}
				log.info("退改信息前后比较: " + suppGoodsRefundList.toString() + "|" +suppGoodsRefundListTemp.toString());
				if (suppGoodsRefundList.toString().equals(suppGoodsRefundListTemp.toString()) && suppGoods.getNotInTimeFlag().equals(oldSuppGoods.getNotInTimeFlag())) {
					log.info("SuppGoodsId: " + suppGoods.getSuppGoodsId() + "退改信息没有修改");
				} else {
					log.info("SuppGoodsId: " + suppGoods.getSuppGoodsId() + "退改信息修改了");
					isSuppGoodsRefund = true;
				}
				try {
					if(CollectionUtils.isNotEmpty(suppGoodsRefundList)){
						//老数据
						if(SuppGoodsBaseTimePrice.CANCELSTRATEGYTYPE.UNRETREATANDCHANGE.name().equals(cancelStrategy) && cancelStrategy.equals(suppGoodsRefundList.get(0).getCancelStrategy())){
						    log.info("newCancelStrategy:"+cancelStrategy);
						}else{
							List<SuppGoodsRefund>  newSuppGoodsRefundList = suppGoodsRefundService.findSuppGoodsRefundList(paramSuppGoodsRefund);
							//相等        同为  部分退  或者 整单退
							String flag="Y";
							if(cancelStrategy.equals(suppGoodsRefundList.get(0).getCancelStrategy())){
							    this.commonLogicForPartAndRetreat(flag,map, suppGoodsRefundList, newSuppGoodsRefundList);
							}else{
								//不相等  一个为整单退，一个为部分退
								flag="N";
								this.commonLogicForPartAndRetreat(flag,map, suppGoodsRefundList, newSuppGoodsRefundList);
							}
						}
						this.sendMessageToFreedom(map, suppGoods.getSuppGoodsId());
					}else{
					    this.sendMessageToFreedom(map, suppGoods.getSuppGoodsId());
					}
				} catch (Exception e1) {
					log.info("Send message to the freedom failure");
					log.error(e1.getMessage());
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
						if(StringUtils.isNotBlank(sb.toString())){
							oldDistributorNames = sb.toString().substring(0, sb.length()-1);
						}
					}


					StringBuilder sb = new StringBuilder();
					String[] distributorIds = suppGoods.getDistributorIds().split(",");
					if(distributorIds!=null && distributorIds.length>0){
						for (String distributorId : distributorIds) {
							for (Distributor distributor : distributorList) {
								if(distributorId.equals(String.valueOf(distributor.getDistributorId()))){
									sb.append(distributor.getDistributorName()).append(",");
								}
							}
						}
					}
					if(StringUtils.isNotBlank(sb.toString())){
						distributorNames = sb.toString().substring(0, sb.length()-1);
					}
					saveOrUpdateDistributorGoods(suppGoods.getProductId(),suppGoods.getProductBranchId(),suppGoods.getSuppGoodsId(),distributorIds);
				}
				//推送商品的分销商关系给super系统
				distributorGoodsService.pushSuperDistributor(suppGoods, distributorUserIds);

				// 发送商品更新消息通知分销

				if (isSuppGoodsRefund || isOrderLimit) {
					pushAdapterService.push(suppGoods.getSuppGoodsId(), ComPush.OBJECT_TYPE.GOODS, ComPush.PUSH_CONTENT.FX_SUPPGOODS_EDIT, ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
					log.info( "SuppGoodsId: " + suppGoods.getSuppGoodsId() + "发送修改消息");
				}
				//获取当前商品所选的规格
				ProdProductBranch prodProductBranch = prodProductBranchService.findProdProductBranchById(suppGoods.getProductBranchId(), Boolean.FALSE, Boolean.FALSE);
				suppGoods.setProdProductBranch(prodProductBranch);
				//获取商品变更日志内容
				String logContent = getSuppGoodsChangeLog(oldSuppGoods,oldSuppGoodsExp,suppGoodsRefundList,oldDistributorNames, suppGoods,suppGoodsExp,suppGoods.getGoodsReFundList(),distributorNames);
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
						log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
						log.error(ExceptionFormatUtil.getTrace(e));
					}
				}
				// 清除前台缓存
				MemcachedUtil.getInstance().remove(Constant.MEM_CACH_KEY.VST_TICKET_PRODUCT_.toString() + productId + "true");
				MemcachedUtil.getInstance().remove(Constant.MEM_CACH_KEY.VST_TICKET_PRODUCT_.toString() + productId + "false");
			}
			return ResultMessage.UPDATE_SUCCESS_RESULT;
		}catch(Exception e){
			log.error(ExceptionFormatUtil.getTrace(e));
			return ResultMessage.UPDATE_FAIL_RESULT;
		}

	}

	/**
	 * 填充商品的短信提示内容
	 */
	@RequestMapping(value = "/fillSmsContent.do")
	@ResponseBody
	public Object fillSmsContent(Long suppGoodsId, String content, HttpServletRequest req) throws BusinessException {

		//content = content.substring(0, 50);
		SuppGoodsAddition suppGoodsAddition = suppGoodsAdditionClientRemote.selectByPrimaryKey(suppGoodsId);
		if(suppGoodsAddition != null){
			suppGoodsAddition.setSmsContent(content);
			suppGoodsAdditionClientRemote.updateByPrimaryKeySelective(suppGoodsAddition);
			return ResultMessage.UPDATE_SUCCESS_RESULT;
		}else{
			suppGoodsAddition = new SuppGoodsAddition();
			suppGoodsAddition.setSmsContent(content);
			suppGoodsAddition.setSuppGoodsId(suppGoodsId);
			suppGoodsAdditionClientRemote.insert(suppGoodsAddition);
			return ResultMessage.ADD_SUCCESS_RESULT;
		}
	}

    private void setUnvalidDesc(JSONObject jsonObject,SuppGoodsExp suppGoodsExp){
        StringBuilder chinaWeeks= new StringBuilder();
        if(jsonObject.has("weeks")&&jsonObject.get("weeks")!=null){
            JSONArray weekArray=jsonObject.getJSONArray("weeks");
            for(int i=0;i<weekArray.size();i++){
                chinaWeeks.append(DateUtil.getChsWeekDay(weekArray.getString(i))).append("、");
            }
        }

        if(jsonObject.has("dateScope")&&jsonObject.get("dateScope")!=null){
            JSONArray dateArray=jsonObject.getJSONArray("dateScope");
            for(int j=0;j<dateArray.size();j++){
                JSONObject dateObject=dateArray.getJSONObject(j);
                if(dateObject.getString("startDate").equals(dateObject.getString("endDate"))){
                    chinaWeeks.append(dateObject.getString("startDate")).append("、");
                }else{
                    chinaWeeks.append(dateObject.getString("startDate")+"至"+dateObject.getString("endDate")).append("、");
                }
            }
        }
        String chData= chinaWeeks.substring(0, chinaWeeks.length()-1)+"不可使用";
        suppGoodsExp.setUnvalidDesc(chData);
    }

    private ResultMessage setUnvalid(JSONObject jsonObject,SuppGoodsExp suppGoodsExp){
        List<String> weekList=new ArrayList<String>();
        List<String> dateList=new ArrayList<String>();

        if(jsonObject.has("weeks")&&jsonObject.get("weeks")!=null){
            JSONArray weekArray=jsonObject.getJSONArray("weeks");
            for(int i=0;i<weekArray.size();i++){
                String unval=getDateString(suppGoodsExp.getStartTimeStr(),suppGoodsExp.getEndTimeStr(),weekArray.getString(i));
                if(unval!=null&&!"".equals(unval)){
                    for(String str:unval.split(",")){
                        weekList.add(str);
                    }
                }else{
                    return new ResultMessage("ERROR", "有效期不包含"+DateUtil.getChsWeekDay(weekArray.getString(i)));
                }
            }
        }

        if(jsonObject.has("dateScope")&&jsonObject.get("dateScope")!=null){
            JSONArray dateArray=jsonObject.getJSONArray("dateScope");
            for(int j=0;j<dateArray.size();j++){
                JSONObject dateObject=dateArray.getJSONObject(j);
                String dateScopes=getDateString(dateObject.getString("startDate"),dateObject.getString("endDate"),null);
                for(String str:dateScopes.split(",")){
                    dateList.add(str);
                }
            }
        }

        String unvalid = distinctList(weekList,dateList);
        if(StringUtil.isNotEmptyString(unvalid)){
            int unvalidLength=unvalid.length()-1;
            if(unvalidLength<4000){
                suppGoodsExp.setUnvalid(unvalid.substring(0, unvalidLength));
            }else{
                return new ResultMessage("ERROR", "不适用日期超过360天，请修改！");
            }
        }
        return null;
    }

	/**
	 * 计算AperiodicTypeId值
	 * @param oldExp
	 * @param newExp
	 * @param suppGoods
	 */
	private void setSuppGoodsAperiodicTypeId(SuppGoodsExp oldExp,SuppGoodsExp newExp,SuppGoods suppGoods){
		int s = 0;

		if((null != oldExp.getStartTime() && !oldExp.getStartTime().equals(newExp.getStartTime())) || (null == oldExp.getStartTime() && null != newExp.getStartTime())){
			s = 1;
		}
		if((null != oldExp.getEndTime() && !oldExp.getEndTime().equals(newExp.getEndTime())) || (null == oldExp.getEndTime() && null != newExp.getEndTime())){
			s = 1;
		}
		if((null != oldExp.getUnvalid() && !oldExp.getUnvalid().equals(newExp.getUnvalid())) || (null == oldExp.getUnvalid() && null != newExp.getUnvalid())){
			s = 1;
		}
        if((null != oldExp.getTakeFlag() && !oldExp.getTakeFlag().equals(newExp.getTakeFlag())) || (null == oldExp.getTakeFlag() && null != newExp.getTakeFlag())){
            s = 1;
        }
        if((null != oldExp.getTakeType() && !oldExp.getTakeType().equals(newExp.getTakeType())) || (null == oldExp.getTakeType() && null != newExp.getTakeType())){
            s = 1;
        }
        if((null != oldExp.getTakeStartTime() && !oldExp.getTakeStartTime().equals(newExp.getTakeStartTime())) || (null == oldExp.getTakeStartTime() && null != newExp.getTakeStartTime())){
            s = 1;
        }
        if((null != oldExp.getTakeEndTime() && !oldExp.getTakeEndTime().equals(newExp.getTakeEndTime())) || (null == oldExp.getTakeEndTime() && null != newExp.getTakeEndTime())){
            s = 1;
        }
        if((null != oldExp.getTakeDay() && !oldExp.getTakeDay().equals(newExp.getTakeDay())) || (null == oldExp.getTakeDay() && null != newExp.getTakeDay())){
            s = 1;
        }
        if((null != oldExp.getTakeTimeType() && !oldExp.getTakeTimeType().equals(newExp.getTakeTimeType())) || (null == oldExp.getTakeTimeType() && null != newExp.getTakeTimeType())){
            s = 1;
        }
        if((null != oldExp.getTakeTime() && !oldExp.getTakeTime().equals(newExp.getTakeTime())) || (null == oldExp.getTakeTime() && null != newExp.getTakeTime())){
            s = 1;
        }
        if((null != oldExp.getTakeAct() && !oldExp.getTakeAct().equals(newExp.getTakeAct())) || (null == oldExp.getTakeAct() && null != newExp.getTakeAct())){
            s = 1;
        }
        if((null != oldExp.getTakeDeadLineDay() && !oldExp.getTakeDeadLineDay().equals(newExp.getTakeDeadLineDay())) || (null == oldExp.getTakeDeadLineDay() && null != newExp.getTakeDeadLineDay())){
            s = 1;
        }
        if((null != oldExp.getTakeDeadLineTime() && !oldExp.getTakeDeadLineTime().equals(newExp.getTakeDeadLineTime())) || (null == oldExp.getTakeDeadLineTime() && null != newExp.getTakeDeadLineTime())){
            s = 1;
        }
        if((null != oldExp.getUseType() && !oldExp.getUseType().equals(newExp.getUseType())) || (null == oldExp.getUseType() && null != newExp.getUseType())){
            s = 1;
        }
        if((null != oldExp.getUseDay() && !oldExp.getUseDay().equals(newExp.getUseDay())) || (null == oldExp.getUseDay() && null != newExp.getUseDay())){
            s = 1;
        }
        if((null != oldExp.getUseTimeType() && !oldExp.getUseTimeType().equals(newExp.getUseTimeType())) || (null == oldExp.getUseTimeType() && null != newExp.getUseTimeType())){
            s = 1;
        }
        if((null != oldExp.getUseTime() && !oldExp.getUseTime().equals(newExp.getUseTime())) || (null == oldExp.getUseTime() && null != newExp.getUseTime())){
            s = 1;
        }
        if((null != oldExp.getUseAct() && !oldExp.getUseAct().equals(newExp.getUseAct())) || (null == oldExp.getUseAct() && null != newExp.getUseAct())){
            s = 1;
        }
        if((null != oldExp.getUseDeadLineDay() && !oldExp.getUseDeadLineDay().equals(newExp.getUseDeadLineDay())) || (null == oldExp.getUseDeadLineDay() && null != newExp.getUseDeadLineDay())){
            s = 1;
        }
        if((null != oldExp.getUseDeadLineTime() && !oldExp.getUseDeadLineTime().equals(newExp.getUseDeadLineTime())) || (null == oldExp.getUseDeadLineTime() && null != newExp.getUseDeadLineTime())){
            s = 1;
        }
		suppGoods.setAperiodicTypeId(s);
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

	/**
	 * 新增商品
	 *
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/addSuppGoods.do")
	@ResponseBody
	public Object addSuppGoods(SuppGoods suppGoods,SuppGoodsExp suppGoodsExp, String distributorUserIds,
							   String cancelStrategy, HttpServletRequest req) throws BusinessException {

		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<addSuppGoods>");
		}

		//设置期票不适用日期
        if(!"".equals(suppGoodsExp.getUnvalidData())&&suppGoodsExp.getUnvalidData()!=null){
            JSONObject jsonObject= JSONObject.fromObject(suppGoodsExp.getUnvalidData());

            this.setUnvalidDesc(jsonObject,suppGoodsExp);
            if(SuppGoodsExp.EXP_TIME_ENUM.PERIOD.getCode().equals(suppGoodsExp.getUseType())){
                ResultMessage resultMessage = this.setUnvalid(jsonObject, suppGoodsExp);
                if(resultMessage != null){
                    return resultMessage;
                }
            }
        }else{
            suppGoodsExp.setUnvalidDesc("");
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

			// 取得当前排序值
			Map<String, Object> paramSuppGoods = new HashMap<String, Object>();
			paramSuppGoods.put("productId", suppGoods.getProductId());
			int seq = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsCount(paramSuppGoods));
			suppGoods.setSeq(seq+1);
			suppGoods.setLvmamaFlag("Y");
			suppGoods.setDistributeFlag("Y");
			suppGoods.setCreateUser(this.getLoginUserId());
			//默认设置为有效
			suppGoods.setCancelFlag("N");
			Long suppGoodsId = MiscUtils.autoUnboxing(suppGoodsService.addSuppGoods(suppGoods));

			//马戏票
			if("1".equals(suppGoods.getIsCircus())) {
				SuppGoodsCircus suppGoodsCircus = new SuppGoodsCircus();
				suppGoodsCircus.setProductId(suppGoods.getProductId());
				suppGoodsCircus.setSuppGoodsId(suppGoodsId);

				suppGoodsCircusService.saveSuppGoodsCircus(suppGoodsCircus);
			}

			prodSmsChannelService.saveGoodsSmsChannel(suppGoodsId, suppGoods.getOnlyLvmamaFlag());

			/*DEL_PROD_GOODS_RE_0313//绑定门票用户关联关系
			if(suppGoods.getSupplierId() !=null){
				Map<String, Object> ebkParams = new HashMap<String, Object>();
				ebkParams.put("supplierId", suppGoods.getSupplierId());
				ebkParams.put("adminFlag", "Y"); //只关联到管理员账号  add by jsyangyang
				List<EbkUser> ebkUsers = ebkUserService.getEbkUser(ebkParams);
				if(ebkUsers != null && ebkUsers.size() > 0){
					for(EbkUser ebkUser : ebkUsers){
						EbkUserPrdGoodsRe ebkUserPrdGoodsRe = new EbkUserPrdGoodsRe();
						ebkUserPrdGoodsRe.setObjectId(suppGoods.getSuppGoodsId());
						ebkUserPrdGoodsRe.setObjectType(EbkUserPrdGoodsRe.OBJECT_TYPE.SUPP_GOODS.getCode());
						ebkUserPrdGoodsRe.setUserId(ebkUser.getUserId());
						ebkUserPrdGoodsReService.insert(ebkUserPrdGoodsRe);
					}
				}
			}*/

			// 设置门票有效期
			suppGoodsExp.setGoodsId(suppGoodsId);
			suppGoodsExpService.addSuppGoodsExp(suppGoodsExp);
			// 设置门票退改策略
//			suppGoodsRefund.setGoodsId(suppGoodsId);
//			suppGoodsRefundService.addSuppGoodsRefund(suppGoodsRefund);

			// 新增商品的分销渠道
			if(suppGoods.getDistributorIds()!=null){
				String[] distributorIds = suppGoods.getDistributorIds().split(",");
				saveOrUpdateDistributorGoods(suppGoods.getProductId(),suppGoods.getProductBranchId(),suppGoodsId,distributorIds);
			}

			//设置门票的退改
			if((SuppGoodsBaseTimePrice.CANCELSTRATEGYTYPE.RETREATANDCHANGE.name().equals(cancelStrategy) || SuppGoodsBaseTimePrice.CANCELSTRATEGYTYPE.PARTRETREATANDCHANGE.name().equals(cancelStrategy)) 
					&& suppGoods.getGoodsReFundList()!=null && suppGoods.getGoodsReFundList().size()>0){
				for(SuppGoodsRefund sgr : suppGoods.getGoodsReFundList()){
					if(sgr.getDeductType() ==null || sgr.getDeductValue() ==null || (sgr.getLatestCancelTime()==null && StringUtils.isBlank(sgr.getCancelTimeType()))){
						continue;
					}
					sgr.setGoodsId(suppGoods.getSuppGoodsId());
					sgr.setCancelStrategy(cancelStrategy);
					suppGoodsRefundService.addSuppGoodsRefund(sgr);
				}
			}else if (! SuppGoods.PAYTARGET.PAY.getCode().equalsIgnoreCase(suppGoods.getPayTarget())){
				SuppGoodsRefund supGoodsRefund = new SuppGoodsRefund();
				supGoodsRefund.setGoodsId(suppGoods.getSuppGoodsId());
				supGoodsRefund.setCancelStrategy(cancelStrategy);
				suppGoodsRefundService.addSuppGoodsRefund(supGoodsRefund);
			}
            //设置改期配置
            SuppGoodsReschedule goodsReschedule = suppGoods.getGoodsReschedule();
            log.info("addSuppGoods goodsReschedule:"+goodsReschedule);
            if(goodsReschedule!=null){
                goodsReschedule.setGoodsId(suppGoodsId);
                suppGoodsRescheduleService.saveOrUpdateSuppGoodsReschedule(goodsReschedule);
            }
            //推送商品的分销商关系给super系统
			distributorGoodsService.pushSuperDistributor(suppGoods, distributorUserIds);

			if(suppGoods.getCategoryId() != null){
				if(suppGoods.getCategoryId() ==11|| suppGoods.getCategoryId() ==12|| suppGoods.getCategoryId() ==13){
					//新增商品时默认新建下单必填项
					ComOrderRequired comOrderRequired = new ComOrderRequired();
					comOrderRequired.setObjectId(suppGoodsId);
					comOrderRequired.setObjectType(ComOrderRequired.OBJECTTYPE.SUPP_GOODS.name());
					comOrderRequired.setTravNumType(BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.TRAV_NUM_ONE.name());
					comOrderRequired.setPhoneType(BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.TRAV_NUM_ONE.name());
					comOrderRequired.setEnnameType(BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.TRAV_NUM_NO.name());
					comOrderRequired.setEmailType(BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.TRAV_NUM_NO.name());
					comOrderRequired.setOccupType(BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.TRAV_NUM_NO.name());
					comOrderRequired.setCredType(BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.TRAV_NUM_NO.name());
					comOrderRequired.setIdFlag("N");
					comOrderRequired.setPassportFlag("N");
					comOrderRequired.setPassFlag("N");
					comOrderRequired.setTwPassFlag("N");
					comOrderRequired.setTwResidentFlag("N");
					comOrderRequired.setBirthCertFlag("N");
					comOrderRequired.setHouseholdRegFlag("N");
					comOrderRequired.setSoldierFlag("N");
					comOrderRequired.setOfficerFlag("N");
					comOrderRequired.setHkResidentFlag("N");
					comOrderRequiredService.saveComOrderRequired(comOrderRequired);
				}
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
				log.info("新增商品 suppGoodsId:"+suppGoods.getSuppGoodsId()+",loginfo:"+suppGoods.toString());
				comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS,
						suppGoods.getProductId(), suppGoods.getSuppGoodsId(),
						this.getLoginUser().getUserName(),
						"添加了商品：【"+suppGoods.getGoodsName()+"】"+settleEntityLogText, // 结算对象SETTLE_ENTITY_MARK,
						COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(),
						"新增商品",null);
			} catch (Exception e) {
				log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
				log.error(e.getMessage());
			}
		}
		ResultMessage res = ResultMessage.ADD_SUCCESS_RESULT;
		res.addObject("suppGoodsId", suppGoods.getSuppGoodsId());
		res.addObject("noticeType", suppGoods.getNoticeType());
		return res;
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
	@RequestMapping(value = "/cancelProduct.do")
	@ResponseBody
	public Object cancelProduct(SuppGoods suppGoods) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<cancelProduct>");
		}

		String ERROR = "error";
		if ((suppGoods != null) && "Y".equals(suppGoods.getCancelFlag())) {
			String checkRequired = checkRequired(suppGoods.getSuppGoodsId());
			if(checkRequired ==null) {
				suppGoods.setCancelFlag("Y");
			}else {
				return new ResultMessage(ERROR, checkRequired+"中内容不完整，请填写完整后再将商品设为有效。");
			}
		} else if ((suppGoods != null) && "N".equals(suppGoods.getCancelFlag())) {
			suppGoods.setCancelFlag("N");
		} else {
			return new ResultMessage(ERROR, "设置失败,无效参数");
		}

		suppGoodsService.updateCancelFlag(suppGoods);      
	    //查询该商品是否添加过买断		
		dealResPreControlTimePriceInfo(suppGoods);		
		//添加操作日志
		try {
			String key;
			if("Y".equals(suppGoods.getCancelFlag())) {
				key = "有效";
			} else {
				key = "无效";
			}
			comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS,
					suppGoods.getProductId(), suppGoods.getSuppGoodsId(),
					this.getLoginUser().getUserName(),
					"修改了商品有效性为:"+key,
					COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(),
					"修改商品有效性",null);

		} catch (Exception e) {
			// TODO Auto-generated catch block
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
			log.error(e.getMessage());
//			return new ResultMessage("error", "设置失败,无效参数");
		}
//		petProdGoodsAdapter.updatePetSuppGoodsCancel(suppGoods.getSuppGoodsId());
		return ResultMessage.SET_SUCCESS_RESULT;
	}
	
	//处理商品买断信息
	private void dealResPreControlTimePriceInfo(SuppGoods suppGoods){
		List<Long> ids = new ArrayList<Long>();		
		//查询条件
        ResPreControlTimePrice resPre = new ResPreControlTimePrice();
        resPre.setCategoryId(suppGoods.getCategoryId());
        resPre.setGoodsId(suppGoods.getSuppGoodsId());        
        List<ResPreControlTimePriceVO> list = resPreControlTimeService.queryPreControlTimePriceByParamChange(resPre);
        if(CollectionUtils.isNotEmpty(list)){
        	for (ResPreControlTimePrice resPreControlTimePrice : list) {    		
        		if("X".equals(resPreControlTimePrice.getPreSaleFlag())){
        			resPreControlTimePrice.setPreSaleFlag("Y");
        			ids.add(resPreControlTimePrice.getId());
        		}        		
        	}
        	if(CollectionUtils.isNotEmpty(ids)){        		
//        		Map<String, Object> params = new HashMap<String, Object>();
//	        	params.put("ids", ids);
//	        	params.put("preSaleFlag", "Y");     		
//        		resPreControlTimeService.updateResPrecontrolTimePrice(params);	
                //更新商品
        		suppGoods.setBuyoutFlag("Y");
                suppGoodsService.updateSelective(suppGoods);
        		suppGoodsQueryService.removeSuppGoodsCacheById(suppGoods.getSuppGoodsId());
        	}
        }
		
	}
	

	private String checkRequired(Long suppGgoodsId) {
		int resultTimePrice = suppGoodsAddTimePriceService.countGoodsTimePriceById(suppGgoodsId);
		SuppGoodsDesc suppGoodsDesc = suppGoodsDescService.selectBySuppGoodsId(suppGgoodsId);
		int resultRequired = comOrderRequiredService.countBySuppGoodsId(suppGgoodsId);
		int notimePriceCount = suppGoodsNotimeTimePriceService.countGoodsTimePriceById(suppGgoodsId);

		String result = "";
		if (resultTimePrice == 0 && notimePriceCount==0)
		{
			result = "价格库存/";
		}
		if (suppGoodsDesc == null) {
			result = result + "商品描述/";
		}
		if (resultRequired == 0) {
			result = result + "下单必填项/";
		}
		if(StringUtil.isNotEmptyString(result)){
			return result.substring(0,result.length()-1);
		}else {
			return null;
		}

	}

	/**
	 * 设置上架下架
	 *
	 * @return
	 */
	@RequestMapping(value = "/onlineProduct.do")
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
			String key;
			if("Y".equals(suppGoods.getOnlineFlag())) {
				key = "上架";
			} else {
				key = "下架";
			}
			comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS,
					suppGoods.getProductId(), suppGoods.getSuppGoodsId(),
					this.getLoginUser().getUserName(),
					"商品编号：【"+suppGoods.getSuppGoodsId()+"】上架属性为："+key,
					COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(),
					"修改商品上下架属性",null);
		} catch (Exception e) {
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
	@RequestMapping(value = "/findSuppGoodsJson.do")
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

	/**
	 * 根据供应商ID查询商品列表并返回JSON对象
	 * @param model
	 * @param supplierId
	 * @param req
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/deleteSuppGoodsRefund.do")
	@ResponseBody
	public Object deleteSuppGoodsRefund(Model model,Long goodsRefundId) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<findSuppGoodsJson>");
		}
		if(goodsRefundId!=null){
			int i = suppGoodsRefundService.deleteByPrimaryKey(goodsRefundId);
			if(i==1)
				return ResultMessage.SET_SUCCESS_RESULT;
		}

		return ResultMessage.SYS_ERROR;
	}


	private String getSuppGoodsChangeLog(SuppGoods oldSuppGoods,SuppGoodsExp oldSuppGoodsExp,List<SuppGoodsRefund> oldSuppGoodsRefundList,String oldDistributorNames,SuppGoods newSuppGoods,SuppGoodsExp newSuppGoodsExp,List<SuppGoodsRefund> newSuppGoodsRefundList,String distributorNames){
		StringBuilder logStr = new StringBuilder("");
		if(null!= newSuppGoods) {

			logStr.append(ComLogUtil.getLogTxt("商品名称",newSuppGoods.getGoodsName(),oldSuppGoods.getGoodsName()));
			logStr.append(ComLogUtil.getLogTxt("是否有效","Y".equals(newSuppGoods.getCancelFlag())?"是":"否","Y".equals(oldSuppGoods.getCancelFlag())?"是":"否"));
			//有效期
            String newStartTime = newSuppGoodsExp.getStartTime()!=null?CalendarUtils.getDateFormatString(newSuppGoodsExp.getStartTime(),CalendarUtils.DATE_PATTERN):"null";
            String newEndTime = newSuppGoodsExp.getEndTime()!=null?CalendarUtils.getDateFormatString(newSuppGoodsExp.getEndTime(),CalendarUtils.DATE_PATTERN):"null";
            String oldStartTime = oldSuppGoodsExp.getStartTime()!=null?CalendarUtils.getDateFormatString(oldSuppGoodsExp.getStartTime(),CalendarUtils.DATE_PATTERN):"null";
            String oldEndTime = oldSuppGoodsExp.getEndTime()!=null?CalendarUtils.getDateFormatString(oldSuppGoodsExp.getEndTime(),CalendarUtils.DATE_PATTERN):"null";
            logStr.append(ComLogUtil.getLogTxt("有效期", newStartTime+ "至"+ newEndTime, oldStartTime+ "至"+oldEndTime));
            logStr.append(ComLogUtil.getLogTxt("不适用日期",newSuppGoodsExp.getUnvalidDesc(),oldSuppGoodsExp.getUnvalidDesc()));

			logStr.append(ComLogUtil.getLogTxt("有效天数",newSuppGoodsExp.getDays()!=null?String.valueOf(newSuppGoodsExp.getDays()):"null",oldSuppGoodsExp.getDays()!=null?String.valueOf(oldSuppGoodsExp.getDays()):"null"));

			if(oldSuppGoodsExp.getUseInsTruction() != null){
				logStr.append(ComLogUtil.getLogTxt("有效次数",String.valueOf(newSuppGoodsExp.getUseInsTruction()),String.valueOf(oldSuppGoodsExp.getUseInsTruction())));
			}
			//规格suppGoods.prodProductBranch
			if(!newSuppGoods.getProductBranchId().equals(oldSuppGoods.getProductBranchId())){
				logStr.append(ComLogUtil.getLogTxt("规格", newSuppGoods.getProdProductBranch().getBranchName(), oldSuppGoods.getProdProductBranch().getBranchName()));
			}

			//票种
			if(!newSuppGoods.getGoodsSpec().equals(oldSuppGoods.getGoodsSpec())){
				logStr.append(ComLogUtil.getLogTxt("票种", SuppGoods.GOODSSPEC.getCnName(newSuppGoods.getGoodsSpec()), SuppGoods.GOODSSPEC.getCnName(oldSuppGoods.getGoodsSpec())));
			}
			//短信不显示人群类别及数量
			if(newSuppGoods.getSpecialSmsFlag()!=null  &&!newSuppGoods.getSpecialSmsFlag().equals(oldSuppGoods.getSpecialSmsFlag())){
				logStr.append(ComLogUtil.getLogTxt("短信不显示人群类别及数量", "Y".equals(newSuppGoods.getSpecialSmsFlag())?"是":"否", "Y".equals(oldSuppGoods.getSpecialSmsFlag())?"是":"否"));
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
			
			//内容维护人员
			if(!newSuppGoods.getContentManagerId().equals(oldSuppGoods.getContentManagerId())){

				Long contentManagerId = oldSuppGoods.getContentManagerId();
				if (contentManagerId!=null) {
					PermUser user = permUserServiceAdapter.getPermUserByUserId(contentManagerId);
					logStr.append(ComLogUtil.getLogTxt("内容维护人员",newSuppGoods.getContentManagerName(),user.getRealName()));
				}
			}
			//区域负责人
			if(newSuppGoods.getRegionalLeaderId()!=null &&!newSuppGoods.getRegionalLeaderId().equals(oldSuppGoods.getRegionalLeaderId())){

				Long regionalLeaderId = oldSuppGoods.getRegionalLeaderId();
				if (regionalLeaderId!=null) {
					PermUser user = permUserServiceAdapter.getPermUserByUserId(regionalLeaderId);
					logStr.append(ComLogUtil.getLogTxt("区域负责人",newSuppGoods.getRegionalLeaderName(),user.getRealName()));
				}
			}
			//商务人员
			if(newSuppGoods.getCommercialStaffId()!=null &&!newSuppGoods.getCommercialStaffId().equals(oldSuppGoods.getCommercialStaffId())){

				Long commercialStaffId = oldSuppGoods.getCommercialStaffId();
				if (commercialStaffId!=null) {
					PermUser user = permUserServiceAdapter.getPermUserByUserId(commercialStaffId);
					logStr.append(ComLogUtil.getLogTxt("商务人员",newSuppGoods.getCommercialStaffName(),user.getRealName()));
				}
			}
			//商品合同
			if(!newSuppGoods.getContractId().equals(oldSuppGoods.getSuppContract().getContractId())){
				logStr.append(ComLogUtil.getLogTxt("商品合同",newSuppGoods.getSuppContract().getContractName(),oldSuppGoods.getSuppContract().getContractName()));
			}

            if (!newSuppGoods.getContractId().equals(oldSuppGoods.getSuppContract().getContractId())) {
                logStr.append(ComLogUtil.getLogTxt("商品ID", newSuppGoods.getSuppContract().getContractId(),
                        oldSuppGoods.getSuppContract().getContractId()));
            }

			if(!newSuppGoods.getPayTarget().equals(oldSuppGoods.getPayTarget())) {
				String newValue = SuppGoods.PAYTARGET.getCnName(newSuppGoods.getPayTarget());
				String oldValue = SuppGoods.PAYTARGET.getCnName(oldSuppGoods.getPayTarget());
				logStr.append(ComLogUtil.getLogTxt("支付对象",newValue,oldValue));
			}
			if(!newSuppGoods.getFiliale().equals(oldSuppGoods.getFiliale())) {
				String newValue = CommEnumSet.FILIALE_NAME.getCnName(newSuppGoods.getFiliale());
				String oldValue = CommEnumSet.FILIALE_NAME.getCnName(oldSuppGoods.getFiliale());
				logStr.append(ComLogUtil.getLogTxt("分公司",newValue,oldValue));
			}
			//BU
			if(!newSuppGoods.getBu().equals(oldSuppGoods.getBu())) {
				String newValue = CommEnumSet.BU_NAME.getCnName(newSuppGoods.getBu());
				String oldValue = CommEnumSet.BU_NAME.getCnName(oldSuppGoods.getBu());
				logStr.append(ComLogUtil.getLogTxt("BU",newValue,oldValue));
			}
			//归属地
			if(!newSuppGoods.getAttributionName().equals(oldSuppGoods.getAttributionName())) {
				logStr.append(ComLogUtil.getLogTxt("归属地",newSuppGoods.getAttributionName(),oldSuppGoods.getAttributionName()));
			}

			//是否仅组合销售
			if(!newSuppGoods.getPackageFlag().equals(oldSuppGoods.getPackageFlag())) {
				logStr.append(ComLogUtil.getLogTxt("是否仅组合销售","Y".equals(newSuppGoods.getPackageFlag())?"是":"否","Y".equals(oldSuppGoods.getPackageFlag())?"是":"否"));
			}
			//是否使用传真
			if(!newSuppGoods.getFaxFlag().equals(oldSuppGoods.getFaxFlag())) {
				logStr.append(ComLogUtil.getLogTxt("是否使用传真","Y".equals(newSuppGoods.getFaxFlag())?"是":"否","Y".equals(oldSuppGoods.getFaxFlag())?"是":"否"));
			}
			//是否需要供应商在ebk确认资源
			if(!newSuppGoods.getEbkFlag().equals(oldSuppGoods.getEbkFlag())) {
				logStr.append(ComLogUtil.getLogTxt("是否需要供应商在ebk确认资源","Y".equals(newSuppGoods.getEbkFlag())?"是":"否","Y".equals(oldSuppGoods.getEbkFlag())?"是":"否"));
			}

			//是否使用传真策略
			logStr.append(ComLogUtil.getLogTxt("传真策略",String.valueOf(newSuppGoods.getFaxRuleId()),String.valueOf(oldSuppGoods.getFaxRuleId())));

			logStr.append(ComLogUtil.getLogTxt("最小起订数量",newSuppGoods.getMinQuantity().toString(),oldSuppGoods.getMinQuantity().toString()));
			logStr.append(ComLogUtil.getLogTxt("最大订购数量",newSuppGoods.getMaxQuantity().toString(),oldSuppGoods.getMaxQuantity().toString()));


			if(!newSuppGoods.getGoodsType().equals(oldSuppGoods.getGoodsType())) {
				String newValue = SuppGoods.GOODSTYPE.getCnName(newSuppGoods.getGoodsType());
				String oldValue = SuppGoods.GOODSTYPE.getCnName(oldSuppGoods.getGoodsType());
				logStr.append(ComLogUtil.getLogTxt("商品类型",newValue,oldValue));
			}
			if(newSuppGoods.getExpressType()!=null && !newSuppGoods.getExpressType().equals(oldSuppGoods.getExpressType())){
				String nValue = SuppGoods.EXPRESSTYPE.getCnName(newSuppGoods.getExpressType());
				logStr.append(ComLogUtil.getLogTxt("寄件方",nValue,null));
			}
			if(newSuppGoods.getNoticeType()!=null && !newSuppGoods.getNoticeType().equals(oldSuppGoods.getNoticeType())){
				String nValue = SuppGoods.NOTICETYPE.getCnName(newSuppGoods.getNoticeType());
				logStr.append(ComLogUtil.getLogTxt("通知方式",nValue,null));
			}
			logStr.append(ComLogUtil.getLogTxt("销售渠道",distributorNames,oldDistributorNames));

			//退改策略
			String oldRefundsStr = "";
			String newRefundsStr = "";
			String cancelStrategy = "";
			if(!CollectionUtils.isEmpty(oldSuppGoodsRefundList)){
				if(SuppGoodsBaseTimePrice.CANCELSTRATEGYTYPE.RETREATANDCHANGE.name().equals(oldSuppGoodsRefundList.get(0).getCancelStrategy())){
					cancelStrategy="仅支持整单退，";
				}else if(SuppGoodsBaseTimePrice.CANCELSTRATEGYTYPE.PARTRETREATANDCHANGE.name().equals(oldSuppGoodsRefundList.get(0).getCancelStrategy())){
					cancelStrategy="部分退，";
				}
				oldRefundsStr = cancelStrategy+SuppGoodsRefundTools.SuppGoodsRefundVOToStrForFront(oldSuppGoodsRefundList,oldSuppGoods.getAperiodicFlag());
			}
			if(!CollectionUtils.isEmpty(newSuppGoodsRefundList)){
				if(SuppGoodsBaseTimePrice.CANCELSTRATEGYTYPE.RETREATANDCHANGE.name().equals(newSuppGoodsRefundList.get(0).getCancelStrategy())){
					cancelStrategy="仅支持整单退，";
				}else if(SuppGoodsBaseTimePrice.CANCELSTRATEGYTYPE.PARTRETREATANDCHANGE.name().equals(newSuppGoodsRefundList.get(0).getCancelStrategy())){
					cancelStrategy="部分退，";
				}
				newRefundsStr = cancelStrategy+SuppGoodsRefundTools.SuppGoodsRefundVOToStrForFront(newSuppGoodsRefundList,newSuppGoods.getAperiodicFlag());
			}
			logStr.append(ComLogUtil.getLogTxt("退改策略",newRefundsStr,oldRefundsStr));

			// 商品是否可及时处理
			if (newSuppGoods.getNotInTimeFlag() !=null && !newSuppGoods.getNotInTimeFlag().equals(oldSuppGoods.getNotInTimeFlag())) {
				logStr.append(ComLogUtil.getLogTxt("商品是否可及时处理", "Y".equals(newSuppGoods.getNotInTimeFlag()) ? "不可及时处理" : "可及时处理", "Y".equals(oldSuppGoods.getNotInTimeFlag()) ? "不可及时处理" : "可及时处理"));
			}

			//天牛计划标识
			if(newSuppGoods.getTianNiuFlag()!=null && !newSuppGoods.getTianNiuFlag().equals(oldSuppGoods.getTianNiuFlag())) {
				logStr.append(ComLogUtil.getLogTxt("是否天牛计划","Y".equals(newSuppGoods.getTianNiuFlag())?"是":"否","Y".equals(oldSuppGoods.getTianNiuFlag())?"是":"否"));
			}
			//是否长隆马戏票suppGoods.getIsCircus()
			if(newSuppGoods.getIsCircus()!=null && !newSuppGoods.getIsCircus().equals(oldSuppGoods.getIsCircus())) {
				logStr.append(ComLogUtil.getLogTxt("是否长隆马戏票","1".equals(newSuppGoods.getIsCircus())?"是":"否","1".equals(oldSuppGoods.getIsCircus())?"是":"否"));
			}
            
            if(newSuppGoods.getGoodsReschedule()!=null){
                String oldChangeDescStr = SuppGoodsRescheduleTools.convertChangeDesc(oldSuppGoods.getGoodsReschedule(), false,null);
                String changeDescStr = SuppGoodsRescheduleTools.convertChangeDesc(newSuppGoods.getGoodsReschedule(), false,null);
                if(!StringUtils.equals(oldChangeDescStr,changeDescStr)){
                    logStr.append(ComLogUtil.getLogTxt("改期策略",changeDescStr,oldChangeDescStr));
                }
            }
            
			//特殊门票类型
			if(newSuppGoods.getSpecialTicketType()!=null && !newSuppGoods.getSpecialTicketType().equals(oldSuppGoods.getSpecialTicketType())) {
				logStr.append(ComLogUtil.getLogTxt("特殊门票类型",SuppGoods.SPECIAL_TICKET_TYPE.getCnName(newSuppGoods.getSpecialTicketType()),SuppGoods.SPECIAL_TICKET_TYPE.getCnName(oldSuppGoods.getSpecialTicketType())));
			}
			//分销独立短信通道
			if(newSuppGoods.getOnlyLvmamaFlag()!=null && !newSuppGoods.getOnlyLvmamaFlag().equals(oldSuppGoods.getOnlyLvmamaFlag())) {
				logStr.append(ComLogUtil.getLogTxt("分销独立短信通道","Y".equals(newSuppGoods.getOnlyLvmamaFlag())?"是":"否","Y".equals(oldSuppGoods.getOnlyLvmamaFlag())?"是":"否"));
			}

			//预订日期限制
			if(newSuppGoods.getLimitBookDay()!=null && !newSuppGoods.getLimitBookDay().equals(oldSuppGoods.getLimitBookDay())) {
				String oldLimitBook=(oldSuppGoods.getLimitBookDay()==null ?"-1":oldSuppGoods.getLimitBookDay().toString());
				String newLimitBook=newSuppGoods.getLimitBookDay().toString();
				if("-1".equals(oldLimitBook)){
					oldLimitBook="否";
				}
				if("-1".equals(newLimitBook)){
					newLimitBook="否";
				}
				logStr.append(ComLogUtil.getLogTxt("预订日期限制",newLimitBook,oldLimitBook));
			}
			if(newSuppGoods.getIsBusiness()!=null&&!newSuppGoods.getIsBusiness().equals(oldSuppGoods.getIsBusiness())){
				logStr.append(ComLogUtil.getLogTxt("使用状态返回是否为业务人员选择",VstOrderEnum.SUPPLIER_API_FLAG.getCnName(newSuppGoods.getIsBusiness()),VstOrderEnum.SUPPLIER_API_FLAG.getCnName(oldSuppGoods.getIsBusiness())));
			}
			if(newSuppGoods.getUseStatus()!=null&&!newSuppGoods.getUseStatus().equals(oldSuppGoods.getUseStatus())){
				logStr.append(ComLogUtil.getLogTxt("使用状态返回",SuppGoods.USE_STATUS.getCnName(newSuppGoods.getUseStatus()),USE_STATUS.getCnName(oldSuppGoods.getUseStatus())));
			}
			if(newSuppGoods.getUseStatus()!=null&&!newSuppGoods.getUseStatus().equals(oldSuppGoods.getUseStatus())){
				logStr.append(ComLogUtil.getLogTxt("ebk使用状态",SuppGoods.EBK_USE_STATUS.getCnName(newSuppGoods.getEbkUseStatusReturn()),SuppGoods.EBK_USE_STATUS.getCnName(oldSuppGoods.getEbkUseStatusReturn())));
			}
			//EBK是否支持发邮件
            if(newSuppGoods.getEbkEmailFlag()!=null && !newSuppGoods.getEbkEmailFlag().equals(oldSuppGoods.getEbkEmailFlag())) {
				 logStr.append(ComLogUtil.getLogTxt("EBK是否支持发邮件","Y".equals(newSuppGoods.getEbkEmailFlag())?"是":"否","Y".equals(oldSuppGoods.getEbkEmailFlag())?"是":"否"));
			}
		}
		return logStr.toString();
	}

	/**
	 * 更新seq
	 * @param model
	 * @param supplierId
	 * @param req
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/updateSeq.do")
	@ResponseBody
	public Object updateSeq(HttpServletRequest req) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<updateSeq>");
		}
		try {
			if (StringUtils.isNotBlank(req.getParameter("goodsIdA"))
					&& StringUtils.isNotBlank(req.getParameter("goodsIdB"))) {
				SuppGoods suppGoodsA = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(Long.valueOf(req.getParameter("goodsIdA").trim())));
				SuppGoods suppGoodsB = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(Long.valueOf(req.getParameter("goodsIdB").trim())));
				int tempSeq = suppGoodsA.getSeq();
				suppGoodsA.setSeq(suppGoodsB.getSeq());
				suppGoodsService.updateSeq(suppGoodsA);
				suppGoodsB.setSeq(tempSeq);
				suppGoodsService.updateSeq(suppGoodsB);

				//添加操作日志
				try {
					comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS,
							suppGoodsA.getProductId(), suppGoodsA.getSuppGoodsId(),
							this.getLoginUser().getUserName(),
							"修改了商品：【"+suppGoodsA.getGoodsName()+"】,变更内容：商品排序:[原来值:"+suppGoodsB.getSeq()+",新值:"+suppGoodsA.getSeq()+"]",
							COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(),
							"修改商品",null);
					comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS,
							suppGoodsB.getProductId(), suppGoodsB.getSuppGoodsId(),
							this.getLoginUser().getUserName(),
							"修改了商品：【"+suppGoodsB.getGoodsName()+"】,变更内容：商品排序:[原来值:"+suppGoodsA.getSeq()+",新值:"+suppGoodsB.getSeq()+"]",
							COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(),
							"修改商品",null);
				} catch (Exception e) {
					log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
					log.error(ExceptionFormatUtil.getTrace(e));
				}

			} else {
				return new ResultMessage("error", "设置失败,无效参数");
			}
		} catch (Exception e) {
			return new ResultMessage("error", "设置失败,无效参数");
		}
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

	private boolean isSingleTicket(SuppGoods suppGoods) {
		return BizEnum.BIZ_CATEGORY_TYPE.category_single_ticket.getCategoryId() == suppGoods.getCategoryId();
	}

	private boolean isCombineTicket(SuppGoods suppGoods) {
		return BizEnum.BIZ_CATEGORY_TYPE.category_comb_ticket.getCategoryId() == suppGoods.getCategoryId();
	}

	private TicketGoodsFormattedDesc genFormatted() {
		TicketGoodsFormattedDesc vo = new TicketGoodsFormattedDesc();
		Map<String, VisitMethod> map = new HashMap<String, VisitMethod>();
		map.put(TicketGoodsFormattedDesc.VISIT_METHOD.QR_CODE.getCode(), new VisitMethod(true, "二维码"));
		map.put(TicketGoodsFormattedDesc.VISIT_METHOD.DEFINE.getCode(), new VisitMethod(true, "自定义"));
		vo.setVisitMethods(map);
		FeeContentArray array = new FeeContentArray();
		FeeContent[] a = new FeeContent[2];
		a[0] = new FeeContent();
		a[0].setDetail("aaa");
		a[0].setQuantifier("片");
		a[0].setQuantity(2);
		a[0].setRemark("remark");

		a[1] = new FeeContent();
		a[1].setDetail("bbb");
		a[1].setQuantifier("个");
		a[1].setQuantity(20);
		a[1].setRemark("remark2");

		array.setFeeContents(a);
		vo.setFeeContents(array);

		TicketGoodsTypeFormattedDescription formattedDescription = new TicketGoodsTypeFormattedDescription();
		vo.setTypeDesc(formattedDescription);
		formattedDescription.setCombine(TicketHeightAgeDetailVO.COMBINE.AND);
		formattedDescription.setTicketDesc("儿童票");

		TicketGoodsLimit  agelimit = new TicketGoodsLimit();
		agelimit.setRemark("ss");
		TicketHeightAgeVO heightAgeVO = new TicketHeightAgeVO();
		heightAgeVO.setAge(20);
		heightAgeVO.setUpFlag(true);
		heightAgeVO.setIncludeFlag(true);

		agelimit.setHeightAgeVOs(new TicketHeightAgeVO[] {heightAgeVO});
		agelimit.setRemark("eee");
		formattedDescription.setAgeLimit(agelimit);

		TicketHeightAgeVO heightAgeVO2 = new TicketHeightAgeVO();
		heightAgeVO2.setHeight("30");
		heightAgeVO2.setIncludeFlag(false);
		TicketGoodsLimit  heightlimit = new TicketGoodsLimit();

		TicketHeightAgeVO heightAgeVO3 = new TicketHeightAgeVO();
		heightAgeVO3.setHeight("40");
		heightAgeVO3.setIncludeFlag(false);

		heightlimit.setHeightAgeVOs(new TicketHeightAgeVO[]{heightAgeVO2, heightAgeVO3});
		heightlimit.setRemark("remark2");
//        heightlimit.setCombine(TicketHeightAgeDetailVO.COMBINE.TO);
		formattedDescription.setHeightLimit(heightlimit);

		formattedDescription.setDefines(new String[] {"aaa", "bbb", "ccc"});

		vo.setFetchSite("aa");
		vo.setVisitSite("bb");
		vo.setNeedFetchTicket("N");
		vo.setOthers("aaaaddd");
		TicketGoodsTimeLimit  f = new TicketGoodsTimeLimit();
		f.setLimitFlag("N");
		TicketGoodsTimeLimitVO[] ass = new TicketGoodsTimeLimitVO[2];
		ass[0] = new TicketGoodsTimeLimitVO();
		ass[0].setStartHour("2");
		ass[0].setStartMinute("22");
		ass[0].setEndHour("3");
		ass[0].setEndMinute("44");
		ass[0].setRemark("x");

		ass[1] = new TicketGoodsTimeLimitVO();
		ass[1].setStartHour("5");
		ass[1].setStartMinute("25");
		ass[1].setEndHour("8");
		ass[1].setEndMinute("09");
		ass[1].setRemark("r");

		vo.setFetchLimit(f);

		TicketGoodsTimeLimit d = new TicketGoodsTimeLimit();
		d.setLimitFlag("Y");
		d.setTimeLimitVOs(ass);
		vo.setVisitLimit(d);
		return vo;
	}

	private String getGoodsSpecCnName(SuppGoods suppGoods) {
		return SuppGoods.GOODSSPEC.getCnName(suppGoods.getGoodsSpec() == null ? "" : suppGoods.getGoodsSpec());
	}

	/**
	 * 商品信息描述初始化页面
	 */
	@RequestMapping(value = "/suppGoodsDescInit.do")
	public String suppGoodsDescInit(SuppGoodsDesc suppGoodsDesc,Model model){
		Long suppGoodsId =suppGoodsDesc.getSuppGoodsId();
		SuppGoodsDesc goodsDescTmp=suppGoodsDescAdapterService.selectBySuppGoodsId(suppGoodsId);
		SuppGoods suppGoods = MiscUtils.autoUnboxing(suppGoodsHotelAdapterService.findSuppGoodsById(suppGoodsId));
		boolean needFormattedFlag = false;
		if (suppGoods != null) {
			if (this.isSingleTicket(suppGoods)) {
				needFormattedFlag = true;
			} else if (this.isCombineTicket(suppGoods)) {
				ProdProduct product = prodProductHotelAdapterService.findProdProductByProductId(suppGoods.getProductId());
				if (ProdProduct.PACKAGETYPE.SUPPLIER.getCode().equalsIgnoreCase(product.getPackageType())) {
					needFormattedFlag = true;
				}
			}
			if (needFormattedFlag) {
				Map<String, Object> queryParams = new HashMap<String, Object>();
				queryParams.put("suppGoodsId", suppGoodsId);
				SuppGoodsDescJson suppGoodsDescJson = null;
				List<SuppGoodsDescJson> list = suppGoodsDescJsonAdapterService.findSuppGoodsDescJsonListByParams(queryParams);
				if (CollectionUtils.isNotEmpty(list)) {
					suppGoodsDescJson = list.get(0);
				}
				if (suppGoodsDescJson != null) {
					TicketGoodsFormattedDesc ticketGoodsFormattedDesc = com.alibaba.fastjson.JSONObject.parseObject(suppGoodsDescJson.getContent(), TicketGoodsFormattedDesc.class);
					if (ticketGoodsFormattedDesc.getTypeDesc() == null) {
						TicketGoodsTypeFormattedDescription description = new TicketGoodsTypeFormattedDescription();
						ticketGoodsFormattedDesc.setTypeDesc(description);
					}
					if (StringUtils.isEmpty(ticketGoodsFormattedDesc.getTypeDesc().getTicketDesc())) {
						ticketGoodsFormattedDesc.getTypeDesc().setTicketDesc(this.getGoodsSpecCnName(suppGoods));
					}
					model.addAttribute("ticketGoodsFormattedDesc", ticketGoodsFormattedDesc);
				} else {
					TicketGoodsFormattedDesc ticketGoodsFormattedDesc = new TicketGoodsFormattedDesc();
					ticketGoodsFormattedDesc.setSuppGoodsId(suppGoodsDesc.getSuppGoodsId());
					TicketGoodsTypeFormattedDescription description = new TicketGoodsTypeFormattedDescription();
					description.setTicketDesc(this.getGoodsSpecCnName(suppGoods));
					ticketGoodsFormattedDesc.setTypeDesc(description);
					model.addAttribute("ticketGoodsFormattedDesc", ticketGoodsFormattedDesc);
				}
			}
		}
		model.addAttribute("hourList",this.getHousList());
		model.addAttribute("minuteList",this.getMinuteList());
		if(goodsDescTmp!=null && !needFormattedFlag){
			model.addAttribute("suppGoodsDesc",goodsDescTmp);
			String limitTime = goodsDescTmp.getLimitTime();
			// 有入园限制
			if(StringUtil.isNotEmptyString(limitTime)&&goodsDescTmp.getLimitTime().split(":").length==2){
				String[] arr=goodsDescTmp.getLimitTime().split(":");
				model.addAttribute("hour",arr[0]);// 入园当天限制小时
				model.addAttribute("minute",arr[1]);// 入园当天限制分钟
			}
			//有通关时间限制
			String passFlag=goodsDescTmp.getPassFlag();
			if("Y".equalsIgnoreCase(passFlag) && StringUtil.isNotEmptyString(goodsDescTmp.getPassLimitTime())&&goodsDescTmp.getPassLimitTime().split(":").length==3){
				String [] arr=goodsDescTmp.getPassLimitTime().split(":");
				model.addAttribute("passTimeLimitHour",arr[0]);// 通关限制小时
				model.addAttribute("passTimeLimitMinute",arr[1]);// 通关限制分钟
				model.addAttribute("passTimeLimitSeconds",arr[2]);// 通关限制分钟
			}
		}
		if(null!=suppGoods){
			model.addAttribute("suppGoods", suppGoods);
			// 取得退改策略
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("goodsId", suppGoods.getSuppGoodsId());
			List<SuppGoodsRefund> suppGoodsRefunds = suppGoodsRefundAdapterService.findSuppGoodsRefundList(params);
			if(null!=suppGoodsRefunds && !suppGoodsRefunds.isEmpty()){
				SuppGoodsRefund suppGoodsRefund = suppGoodsRefunds.get(0);
				model.addAttribute("suppGoodsRefund", suppGoodsRefund);
				model.addAttribute("suppGoodsRefunds", suppGoodsRefunds);
			}
			String aperiodicFlag = suppGoods.getAperiodicFlag();
			if(StringUtil.isNotEmptyString(aperiodicFlag)){
				// 获取商品有效期
				SuppGoodsExp suppGoodsExp = suppGoodsExpAdapterService.findSuppGoodsExpList(params).get(0);
				model.addAttribute("suppGoodsExp", suppGoodsExp);
                model.addAttribute("suppGoodsExpInfo", SuppGoodsExpTools.getAperiodicExpDescForFront(suppGoodsExp));
				// 判断是否为期票
				int days = 0;
				if(aperiodicFlag.equalsIgnoreCase("Y")){
                    if(suppGoodsExp.getStartTime() != null && suppGoodsExp.getEndTime() != null){
                        days = DateUtil.getDaysBetween(suppGoodsExp.getStartTime(), suppGoodsExp.getEndTime());
                    }
				}else{
					days = suppGoodsExp.getDays();
				}
				model.addAttribute("days", days);// 有效期
				//页面退改文案显示
				String cancelStrategyDesc =SuppGoodsRefundTools.SuppGoodsRefundVOToStr(suppGoodsRefunds, aperiodicFlag);
				model.addAttribute("cancelStrategyDesc",cancelStrategyDesc);
			}
		}

		if (needFormattedFlag) {
			model.addAttribute("needShowAddMapImg", needFormattedFlag);
			return "goods/ticket/goods/showAddSuppGoodsFormattedDesc";
		} else {
			return "goods/ticket/goods/showAddSuppGoodsDesc";
		}
	}

	/**
	 * 商品信息描保存
	 */
	@RequestMapping(value = "/suppGoodsDescAdd.do")
	@ResponseBody
	public Object suppGoodsDescAdd(SuppGoodsDesc suppGoodsDesc,String hour,String minute){
		Pair<Integer, Long> pair;
		int row=0;
		SuppGoodsDesc goodsDescTmp=suppGoodsDescService.selectBySuppGoodsId(suppGoodsDesc.getSuppGoodsId());
		if(goodsDescTmp==null){
			if(suppGoodsDesc.getLimitFlag().equals("0")&&hour!=null&&!hour.equals("")&&minute!=null&&!minute.equals("")){
				suppGoodsDesc.setLimitTime(hour+":"+minute);
			}else{
				suppGoodsDesc.setLimitTime("0"+":"+"00");
			}
			pair=suppGoodsDescService.insertSelective(suppGoodsDesc);
			if(pair!=null && pair.isSuccess()){
				row=pair.getFirst();
				suppGoodsDesc.setSuppGoodsId(pair.getSecond());
			}
		}else{
			suppGoodsDesc.setDescId(goodsDescTmp.getDescId());
			if(suppGoodsDesc.getLimitFlag().equals("0")&&hour!=null&&!hour.equals("")&&minute!=null&&!minute.equals("")){
				suppGoodsDesc.setLimitTime(hour+":"+minute);
			}else{
				suppGoodsDesc.setLimitTime("0"+":"+"00");
			}
			row=suppGoodsDescService.updateByPrimaryKeySelective(suppGoodsDesc);
		}
		if(row>0){

			String logContent = getGoodsDescChangeLog(suppGoodsDesc,goodsDescTmp);
			if(null!=logContent && !"".equals(logContent)) {
				//添加操作日志
				try {
					SuppGoodsParam param = new SuppGoodsParam();
					param.setProduct(false);
					SuppGoods suppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoodsDesc.getSuppGoodsId(), param));
					comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS,
							suppGoods.getProductId(), suppGoods.getSuppGoodsId(),
							this.getLoginUser().getUserName(),
							"修改了商品：【"+suppGoods.getGoodsName()+"】商品描述,变更内容:["+logContent+"]",
							COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(),
							"修改商品",null);

					// 清除前台缓存
					MemcachedUtil.getInstance().remove(Constant.MEM_CACH_KEY.VST_TICKET_PRODUCT_.toString() + suppGoods.getProductId() + "true");
					MemcachedUtil.getInstance().remove(Constant.MEM_CACH_KEY.VST_TICKET_PRODUCT_.toString() + suppGoods.getProductId() + "false");
				} catch (Exception e) {
					log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
					log.error(ExceptionFormatUtil.getTrace(e));
				}
			}
			return new ResultMessage("SUCCESS","更新成功");
		}
		return new ResultMessage("ERROR","更新失败");
	}

	private int saveOrUpdateFormattedDesc(TicketGoodsFormattedDesc ticketGoodsFormattedDesc) {
		Long suppGoodsId = ticketGoodsFormattedDesc.getSuppGoodsId();
		SuppGoods suppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoodsId));
		if (suppGoods == null) {
			return 0;
		}
		SuppGoodsDescJson descJson = new SuppGoodsDescJson();
		descJson.setContent(com.alibaba.fastjson.JSONObject.toJSONString(ticketGoodsFormattedDesc));
		descJson.setCategoryId(suppGoods.getCategoryId());
		descJson.setSuppGoodsType(SuppGoodsDescJson.SUPP_GOODS_TYPE.SUPP_GOODS.name());
		descJson.setContentType(SuppGoodsDescJson.CONTENT_TYPE.SUPP_GOODS_DESC.name());
		descJson.setSuppGoodsId(ticketGoodsFormattedDesc.getSuppGoodsId());
		return suppGoodsDescJsonService.saveOrUpdateSuppGoodsDescJson(descJson);
	}

	/**
	 * 商品信息描保存
	 */
	@RequestMapping(value = "/suppGoodsFormattedDescAdd.do")
	@ResponseBody
	public Object suppGoodsFormattedDescAdd(TicketGoodsFormattedDesc ticketGoodsFormattedDesc) {
		String validate = ticketGoodsFormattedDesc.validateData();
		if (StringUtil.isNotEmptyString(validate)) {
			return new ResultMessage(ResultMessage.ERROR, validate);
		}
		Pair<Integer, Long> pair;
		int row=0;
		SuppGoodsDesc suppGoodsDesc =new SuppGoodsDesc(ticketGoodsFormattedDesc);
		SuppGoodsDesc goodsDescTmp=suppGoodsDescService.selectBySuppGoodsId(ticketGoodsFormattedDesc.getSuppGoodsId());
		if(goodsDescTmp==null){
			pair=suppGoodsDescService.insertSelective(suppGoodsDesc);
			if(pair!=null && pair.isSuccess()){
				row=pair.getFirst();
				suppGoodsDesc.setSuppGoodsId(pair.getSecond());
			}
		}else{
			suppGoodsDesc.setDescId(goodsDescTmp.getDescId());
			row=suppGoodsDescService.updateByPrimaryKeySelective(suppGoodsDesc);
			try {
				Map<String, Object> map = new HashMap<String,Object>();
				map = this.isChangedForDesc(map, goodsDescTmp, suppGoodsDesc);
				this.sendMessageToFreedom(map, ticketGoodsFormattedDesc.getSuppGoodsId());
			} catch (Exception e) {
				log.info("suppGoodsFormattedDescAdd#suppGoodsId:"+ticketGoodsFormattedDesc.getSuppGoodsId());
				log.error(e.getMessage());
			}		
		}
		int saveRow = this.saveOrUpdateFormattedDesc(ticketGoodsFormattedDesc);
		if(row>0){
			log.info("goodsId: " + suppGoodsDesc.getSuppGoodsId() + "suppGoodsFormattedDescAdd通知分销开始了");
			// 发送商品描述更新消息通知分销
			pushAdapterService.push(suppGoodsDesc.getSuppGoodsId(), ComPush.OBJECT_TYPE.GOODS, ComPush.PUSH_CONTENT.FX_SUPPGOODS_DESC, ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
			log.info("goodsId: " + suppGoodsDesc.getSuppGoodsId() + "suppGoodsFormattedDescAdd通知分销结束了");
			String logContent = getGoodsDescChangeLog(suppGoodsDesc,goodsDescTmp);
			if(null!=logContent && !"".equals(logContent)) {
				//添加操作日志
				try {
					SuppGoodsParam param = new SuppGoodsParam();
					param.setProduct(false);
					SuppGoods suppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoodsDesc.getSuppGoodsId(), param));
					comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS,
							suppGoods.getProductId(), suppGoods.getSuppGoodsId(),
							this.getLoginUser().getUserName(),
							"修改了商品：【"+suppGoods.getGoodsName()+"】商品描述,变更内容:["+logContent+"]",
							COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(),
							"修改商品",null);

					// 清除前台缓存
					MemcachedUtil.getInstance().remove(Constant.MEM_CACH_KEY.VST_TICKET_PRODUCT_.toString() + suppGoods.getProductId() + "true");
					MemcachedUtil.getInstance().remove(Constant.MEM_CACH_KEY.VST_TICKET_PRODUCT_.toString() + suppGoods.getProductId() + "false");
				} catch (Exception e) {
					log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
					log.error(ExceptionFormatUtil.getTrace(e));
				}
			}
			return new ResultMessage("SUCCESS","更新成功");
		}
		if (saveRow == 0) {
			return new ResultMessage(ResultMessage.ERROR, "更新格式化描述失败");
		}
		return new ResultMessage("ERROR","更新失败");
	}


	/**
	 * 跳转到用户新增编辑商品特殊权限
	 * @param model
	 * @param suppGoodsEditPerm
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/toSaveSuppGoodsEditPerm.do")
	public String findList(Model model,SuppGoodsEditPerm suppGoodsEditPerm, HttpServletRequest req) {
		return "goods/ticket/goods/addSuppGoodsEditPerm";
	}
	
	/**
	 * 用户新增编辑商品特殊权限
	 * @param request
	 * @param suppGoodsEditPerm
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/saveSuppGoodsEditPerm.do")
	public Object saveSuppGoodsEditPerm(HttpServletRequest request,SuppGoodsEditPerm suppGoodsEditPerm,
			HttpServletResponse response) {
		try{
			Map<String, Object> params = new HashMap<String, Object>();    
			params.put("userName", suppGoodsEditPerm.getUserName());
			params.put("permType", suppGoodsEditPerm.getPermType());
			List<SuppGoodsEditPerm>  list = suppGoodsEditPermService.selectEditPermByParams(params);
			if(list != null && list.size() >0){
				return new ResultMessage("ERROR", "新增失败,该用户已添加此权限");
			}
			suppGoodsEditPermService.save(suppGoodsEditPerm);
			return new ResultMessage("SUCCESS", "新增成功");
		}catch(Exception e){
			log.error(e.getMessage(),e);
			return new ResultMessage("ERROR", "新增失败,Exception:"+e.getMessage());
		}
	}


	
	private String yOrNToChs(String yOrN) {
		if (StringUtils.isEmpty(yOrN)) {
			return "";
		}
		if (Constants.N_FLAG.equals(yOrN)) {
			return "否";
		} else if (Constants.Y_FLAG.equals(yOrN)) {
			return "是";
		} else {
			return yOrN;
		}
	}

	@ResponseBody
	@RequestMapping(value = "/findSuppGoodsDetail.do")
	public Object findSuppGoodsDetail(HttpServletRequest request){

		Long prodValue =0L;
		String branchId = request.getParameter("branchId");
		List<ProdBranchDictionary> goodsCategoryList=null;
		if(StringUtil.isNotEmptyString(branchId)) {
			long productBranchId = Long.parseLong(branchId);
			goodsCategoryList = prodBranchDictionaryService.findCnNameListByBranchId(productBranchId);
			if(goodsCategoryList!=null && goodsCategoryList.size()>0){
				prodValue=goodsCategoryList.get(0).getProductBranchId();
			}
		}
        SuppGoods suppGoods=null;
        Long categoryDetail=null;
        String suppGoodsId = request.getParameter("suppGoodsId");
        if(suppGoodsId!=null && !prodValue.equals(310L)) {
            suppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(Long.valueOf(suppGoodsId), Boolean.FALSE, Boolean.FALSE));
            cateGoryDetailWhichCheck(prodValue, suppGoods);
            categoryDetail = suppGoods.getCategoryDetail();
        }
        //如果是单门票就直接设置成310001L（单门票）
        if(prodValue!=null && prodValue.equals(310L)){
            categoryDetail=310001L;
        }
		String json = JSON.toJSONString(goodsCategoryList);
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("status", 200);
		map.put("data", json);
		map.put("suppCateGoryDetailId",categoryDetail);
		return map;
	}

	private String getGoodsDescChangeLog(SuppGoodsDesc suppGoodsDesc,SuppGoodsDesc oldSuppGoodsDesc){
		StringBuilder logStr = new StringBuilder("");
		if (oldSuppGoodsDesc == null || !StringUtils.equals(suppGoodsDesc.getPriceIncludes(), oldSuppGoodsDesc.getPriceIncludes())) {
			logStr.append(ComLogUtil.getLogTxt("费用包含 ", suppGoodsDesc.getPriceIncludes(), oldSuppGoodsDesc == null ? null : oldSuppGoodsDesc.getPriceIncludes()));
		}
		if (oldSuppGoodsDesc == null || !StringUtils.equals(suppGoodsDesc.getCostsNotIncluded(), oldSuppGoodsDesc.getCostsNotIncluded())) {
          logStr.append(ComLogUtil.getLogTxt("费用不包含 ", suppGoodsDesc.getCostsNotIncluded(), oldSuppGoodsDesc == null ? null : oldSuppGoodsDesc.getCostsNotIncluded()));
        }
		if (oldSuppGoodsDesc == null || !StringUtils.equals(suppGoodsDesc.getTypeDesc(), oldSuppGoodsDesc.getTypeDesc())) {
			logStr.append(ComLogUtil.getLogTxt("票种说明 ", suppGoodsDesc.getTypeDesc(), oldSuppGoodsDesc == null ? null : oldSuppGoodsDesc.getTypeDesc()));
		}
		if (oldSuppGoodsDesc == null || !StringUtils.equals(suppGoodsDesc.getNeedTicket(), oldSuppGoodsDesc.getNeedTicket())) {
			logStr.append(ComLogUtil.getLogTxt("是否需要取票", yOrNToChs(suppGoodsDesc.getNeedTicket()), oldSuppGoodsDesc == null ? null : yOrNToChs(oldSuppGoodsDesc.getNeedTicket())));
		}
		if (oldSuppGoodsDesc == null || !StringUtils.equals(suppGoodsDesc.getChangeTime(), oldSuppGoodsDesc.getChangeTime())) {
			logStr.append(ComLogUtil.getLogTxt("取票时间", suppGoodsDesc.getChangeTime(), oldSuppGoodsDesc == null ? null : oldSuppGoodsDesc.getChangeTime()));
		}
		if (oldSuppGoodsDesc == null || !StringUtils.equals(suppGoodsDesc.getChangeAddress(), oldSuppGoodsDesc.getChangeAddress())) {
			logStr.append(ComLogUtil.getLogTxt("取票地点 ", suppGoodsDesc.getChangeAddress(), oldSuppGoodsDesc == null ? null : oldSuppGoodsDesc.getChangeAddress()));
		}
		if (oldSuppGoodsDesc == null || !StringUtils.equals(suppGoodsDesc.getEnterStyle(), oldSuppGoodsDesc.getEnterStyle())) {
			logStr.append(ComLogUtil.getLogTxt("入园方式 ", suppGoodsDesc.getEnterStyle(), oldSuppGoodsDesc == null ? null : oldSuppGoodsDesc.getEnterStyle()));
		}
		if (oldSuppGoodsDesc == null || !StringUtils.equals(suppGoodsDesc.getVisitAddress(), oldSuppGoodsDesc.getVisitAddress())) {
			logStr.append(ComLogUtil.getLogTxt("入园地点", suppGoodsDesc.getVisitAddress(), oldSuppGoodsDesc == null ? null : oldSuppGoodsDesc.getVisitAddress()));
		}
		if (oldSuppGoodsDesc == null || !StringUtils.equals(suppGoodsDesc.getLimitFlag(), oldSuppGoodsDesc.getLimitFlag())) {
			logStr.append(ComLogUtil.getLogTxt("入园限制 ", String.valueOf("1".equals(suppGoodsDesc.getLimitFlag()) ? "无限制" : "有限制"), oldSuppGoodsDesc == null ? null : String.valueOf("1".equals(oldSuppGoodsDesc.getLimitFlag()) ? "无限制" : "有限制")));
		}
		if (oldSuppGoodsDesc == null || !StringUtils.equals(suppGoodsDesc.getLimitTime(), oldSuppGoodsDesc.getLimitTime())) {
			if ("0".equals(suppGoodsDesc.getLimitFlag())) {
				logStr.append(ComLogUtil.getLogTxt("入园限制时间", suppGoodsDesc.getLimitTime(), oldSuppGoodsDesc == null ? null : oldSuppGoodsDesc.getLimitTime()));
			}
		}
		if (oldSuppGoodsDesc == null || !StringUtils.equals(suppGoodsDesc.getHeight(), oldSuppGoodsDesc.getHeight())) {
			logStr.append(ComLogUtil.getLogTxt("身高", suppGoodsDesc.getHeight(), oldSuppGoodsDesc == null ? null : oldSuppGoodsDesc.getHeight()));
		}
		if (oldSuppGoodsDesc == null || !StringUtils.equals(suppGoodsDesc.getAge(), oldSuppGoodsDesc.getAge())) {
			logStr.append(ComLogUtil.getLogTxt("年龄", suppGoodsDesc.getAge(), oldSuppGoodsDesc == null ? null : oldSuppGoodsDesc.getAge()));
		}
		if (oldSuppGoodsDesc == null || !StringUtils.equals(suppGoodsDesc.getRegion(), oldSuppGoodsDesc.getRegion())) {
			logStr.append(ComLogUtil.getLogTxt("地域", suppGoodsDesc.getRegion(), oldSuppGoodsDesc == null ? null : oldSuppGoodsDesc.getRegion()));
		}
		if (oldSuppGoodsDesc == null || !StringUtils.equals(suppGoodsDesc.getMaxQuantity(), oldSuppGoodsDesc.getMaxQuantity())) {
			logStr.append(ComLogUtil.getLogTxt("最大限购", suppGoodsDesc.getMaxQuantity(), oldSuppGoodsDesc == null ? null : oldSuppGoodsDesc.getMaxQuantity()));
		}
		if (oldSuppGoodsDesc == null || !StringUtils.equals(suppGoodsDesc.getExpress(), oldSuppGoodsDesc.getExpress())) {
			logStr.append(ComLogUtil.getLogTxt("快递", suppGoodsDesc.getExpress(), oldSuppGoodsDesc == null ? null : oldSuppGoodsDesc.getExpress()));
		}
		if (oldSuppGoodsDesc == null || !StringUtils.equals(suppGoodsDesc.getEntityTicket(), oldSuppGoodsDesc.getEntityTicket())) {
			logStr.append(ComLogUtil.getLogTxt("实体票", suppGoodsDesc.getEntityTicket(), oldSuppGoodsDesc == null ? null : oldSuppGoodsDesc.getEntityTicket()));
		}
		if (oldSuppGoodsDesc == null || !StringUtils.equals(suppGoodsDesc.getOthers(), oldSuppGoodsDesc.getOthers())) {
			logStr.append(ComLogUtil.getLogTxt("其他", suppGoodsDesc.getOthers(), oldSuppGoodsDesc == null ? null : oldSuppGoodsDesc.getOthers()));
		}
		if (oldSuppGoodsDesc == null || !StringUtils.equals(suppGoodsDesc.getPassFlag(), oldSuppGoodsDesc.getPassFlag())) {
			logStr.append(ComLogUtil.getLogTxt("是否限制通关", suppGoodsDesc.getPassFlag(), oldSuppGoodsDesc == null ? null : oldSuppGoodsDesc.getPassFlag()));
		}
		if (oldSuppGoodsDesc == null || !StringUtils.equals(suppGoodsDesc.getPassLimitTime(), oldSuppGoodsDesc.getPassLimitTime())) {
			logStr.append(ComLogUtil.getLogTxt("限制通关时间", suppGoodsDesc.getPassLimitTime(), oldSuppGoodsDesc == null ? null : oldSuppGoodsDesc.getPassLimitTime()));
		}
		return logStr.toString();
	}

	/**
	 * 随机数
	 * @param min
	 * @param max
	 * @return
	 */
	public static ArrayList<Integer> getNumbers(int min,int max){
		max += 1;
		Integer temp;
		ArrayList<Integer> list = new ArrayList<Integer>(max-min);
		Set<Integer> s = new HashSet<Integer>();
		for(;max>min && s.size()<max-min;){
			temp = ((int) (Math.random() * max)) +min;
			s.add(temp);
			if(list.size() < s.size())list.add(temp);
		}
		return list;
	}

	public List<String> getMinuteList() {
		List<Integer> randomNumberList = getNumbers(0, 59);
		Object[] numberArr = randomNumberList.toArray();
		Arrays.sort(numberArr);
		List<String> list = new ArrayList<String>();
		for (Object obj : numberArr) {
			if (Integer.parseInt(obj.toString()) < 10) {
				String s = "0" + obj.toString();
				list.add(s);
			} else {
				list.add(obj.toString());
			}

		}
		return list;
	}
	/**
	 * 获取小时
	 * @return
	 */
	public List<String> getHousList() {
		List<Integer> randomNumberList = getNumbers(0, 23);
		Object[] numberArr = randomNumberList.toArray();
		Arrays.sort(numberArr);
		List<String> list = new ArrayList<String>();
		for (Object obj : numberArr) {
			list.add(obj.toString());
		}
		return list;
	}
	/******
	 * 获取时间范围内的具体日期，（week不为空获取，范围内周的具体日期）
	 * @param beginDate
	 * @param endDate
	 * @param week
	 * @return
	 * @throws Exception
	 */
	public static String getDateString(String beginDate, String endDate,
									   String week)  {
		String dateString = "";
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Date dBegin = sdf.parse(beginDate);

			Date dEnd = sdf.parse(endDate);
			List<Date> listDate = getDatesBetweenTwoDate(dBegin, dEnd);

			for (int i = 0; i < listDate.size(); i++) {
				if (week != null && !"".equals(week)
						&& week.equals(getWeekDayString(listDate.get(i)))) {
					dateString += sdf.format(listDate.get(i)) + ",";
				}
				if (week == null && !"".equals(week)) {
					dateString += sdf.format(listDate.get(i)) + ",";
				}
			}

		} catch (ParseException e) {
			LOG.error(e.getMessage());
			return null;
		}
		if(!"".equals(dateString)&&null!=dateString){
			dateString=dateString.substring(0, dateString.length() - 1);
		}
		return dateString;
	}
	/**
	 * 根据开始时间和结束时间返回时间段内的时间集合
	 *
	 * @param beginDate
	 * @param endDate
	 * @return List
	 */
	public static List<Date> getDatesBetweenTwoDate(Date beginDate, Date endDate) {
		List<Date> lDate = new ArrayList<Date>();
		if (beginDate.getTime() == endDate.getTime()) {
			lDate.add(beginDate);// 把开始时间加入集合
			return lDate;
		}
		lDate.add(beginDate);// 把开始时间加入集合
		Calendar cal = Calendar.getInstance();
		// 使用给定的 Date 设置此 Calendar 的时间
		cal.setTime(beginDate);
		boolean bContinue = true;
		while (bContinue) {
			// 根据日历的规则，为给定的日历字段添加或减去指定的时间量
			cal.add(Calendar.DAY_OF_MONTH, 1);
			// 测试此日期是否在指定日期之后
			if (endDate.after(cal.getTime())) {
				lDate.add(cal.getTime());
			} else {
				break;
			}
		}
		lDate.add(endDate);// 把结束时间加入集合
		return lDate;
	}

	public static String getWeekDayString(Date pTime)
	{
		String weekString = "";
		final String dayNames[] = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
				"Saturday" };
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(pTime);
		int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);
		weekString = dayNames[dayOfWeek - 1];
		return weekString;
	}
	public String distinctList(List<String> list1,List<String> list2){
		String unvalString="";
		for(int i=0;i<list1.size();i++){
			for(int j=0;j<list2.size();j++){
				if(list1.get(i).equals(list2.get(j))){
					list2.remove(j);
				}
			}
		}
		list1.addAll(list2);
		Collections.sort(list1);
		for(String unval:list1){
			unvalString+=unval+",";
		}
		return unvalString;
	}

	  //商品描述
		private Map<String,Object> isChangedForDesc(Map<String,Object> map,SuppGoodsDesc oldSuppGoodsDesc,SuppGoodsDesc newSuppGoodsDesc){
	        if(null != oldSuppGoodsDesc && null != newSuppGoodsDesc){
	        	Map<String, Object> hashMap = new HashMap<String,Object>();
		        if(compareValue(oldSuppGoodsDesc.getLimitTime(),newSuppGoodsDesc.getLimitTime())){
		        	hashMap.put("limitTime", newSuppGoodsDesc.getLimitTime());
		        }
		        if(compareValue(oldSuppGoodsDesc.getChangeTime(),newSuppGoodsDesc.getChangeTime())){
		        	hashMap.put("changeTime", newSuppGoodsDesc.getChangeTime());
		        }
		        if(compareValue(oldSuppGoodsDesc.getVisitAddress(),newSuppGoodsDesc.getVisitAddress())){
		        	hashMap.put("visitAddress", newSuppGoodsDesc.getVisitAddress());
		        }
		        if(compareValue(oldSuppGoodsDesc.getChangeAddress(),newSuppGoodsDesc.getChangeAddress())){
		        	hashMap.put("changeAddress", newSuppGoodsDesc.getChangeAddress());
		        }
		        if(compareValue(oldSuppGoodsDesc.getEnterStyle(),newSuppGoodsDesc.getEnterStyle())){
		        	hashMap.put("enterStyle", newSuppGoodsDesc.getEnterStyle());
		        }
		        if(hashMap.size()>0){
		        	map.put("suppGoodsDesc", hashMap);
		        	this.fillGoodsInfomation(map, newSuppGoodsDesc.getSuppGoodsId());
		        }
	        }
	        return map;
		}
		//商品有效期
		private Map<String,Object> isChangedForExp(Map<String,Object> map,SuppGoodsExp oldSuppGoodsExp,SuppGoodsExp suppGoodsExp){
	        if(null != oldSuppGoodsExp && null != suppGoodsExp){
	        	Map<String, Object> suppGoodsExpMap = new HashMap<String,Object>();
		        if(compareValue(oldSuppGoodsExp.getDays(),suppGoodsExp.getDays())){
		        	suppGoodsExpMap.put("days", suppGoodsExp.getDays());
		        }
		        if(compareValue(oldSuppGoodsExp.getUseInsTruction(),suppGoodsExp.getUseInsTruction())){
		        	suppGoodsExpMap.put("useInsTruction", suppGoodsExp.getUseInsTruction());
		        }
		        if(suppGoodsExpMap.size()>0){
		        	map.put("suppGoodsExp", suppGoodsExpMap);
		        }
	        }
	        return map;
		}
		//退改策略
		private Map<String,Object> isChangedForRefund(String flag,int i,Map<String,Object> refundMap,SuppGoodsRefund oldSuppGoodsRefund,SuppGoodsRefund suppGoodsRefund){
			if(null != suppGoodsRefund){
				Map<String, Object> suppGoodsRefundMap = new HashMap<String,Object>();
				if(null != oldSuppGoodsRefund){
			        if(compareValue(oldSuppGoodsRefund.getDeductType(),suppGoodsRefund.getDeductType())){
			        	suppGoodsRefundMap.put("deductType", suppGoodsRefund.getDeductType());
			        }
			        if(compareValue(oldSuppGoodsRefund.getDeductValue(),suppGoodsRefund.getDeductValue())){
			        	suppGoodsRefundMap.put("deductValue", suppGoodsRefund.getDeductValue());
			        }
			        if(compareValue(oldSuppGoodsRefund.getCancelTimeType(),suppGoodsRefund.getCancelTimeType())){
			        	suppGoodsRefundMap.put("cancelTimeType", suppGoodsRefund.getCancelTimeType());
			        }
			        if(compareValue(oldSuppGoodsRefund.getRefundType(),suppGoodsRefund.getRefundType())){
			        	suppGoodsRefundMap.put("refundType", suppGoodsRefund.getRefundType());
			        }
				}else{
					suppGoodsRefundMap.put("deductType", suppGoodsRefund.getDeductType());
					suppGoodsRefundMap.put("deductValue", suppGoodsRefund.getDeductValue());
					if(null != suppGoodsRefund.getCancelTimeType()){
						suppGoodsRefundMap.put("cancelTimeType", suppGoodsRefund.getCancelTimeType());
					}
					if(null != suppGoodsRefund.getLatestCancelTime()){
						suppGoodsRefundMap.put("latestCancelTime", suppGoodsRefund.getLatestCancelTime());
					}
				}
				if("N".equals(flag)){
					suppGoodsRefundMap.put("cancelStrategy", suppGoodsRefund.getCancelStrategy());
				}
				if(suppGoodsRefundMap.size()>0){
					if(i>=0){
						refundMap.put("suppGoodsRefund"+i, suppGoodsRefundMap);
					}else{
						refundMap.put("suppGoodsRefund", suppGoodsRefundMap);
					}
				}
			}
			return refundMap;
		}

		private Boolean compareValue(Object oldObject,Object newObject){
			if(null != oldObject && null != newObject && !oldObject.equals(newObject)
					|| (null == oldObject && null != newObject)
					|| (null != oldObject && null == newObject)){
				return true;
			}
			return false;
		}

		private void sendMessageToFreedom(Map<String,Object> map,Long suppGoodsId){
			LOG.info("sendMessageToFreedom#suppGoodsId:"+suppGoodsId);
			if(null != map && map.size()>0){
				JSONObject json = JSONObject.fromObject(map);
				petMessageService.sendCommMessage(suppGoodsId, ComPush.OBJECT_TYPE.TICKET_CHANGE, ComPush.PUSH_CONTENT.SUPP_GOODS, json.toString());
				LOG.info("sendMessageToFreedom#message:"+json.toString());
			}
		}
		
		private void commonLogicForPartAndRetreat(String flag,Map<String,Object> map,List<SuppGoodsRefund> suppGoodsRefundList,List<SuppGoodsRefund>  newSuppGoodsRefundList){
			SuppGoodsRefund suppGoodsRefund = suppGoodsRefundList.get(0);
			Map<String, Object> refundMap = new HashMap<String,Object>();
			//老数据为扣除每张   
			if(null != suppGoodsRefund.getCancelTimeType() && suppGoodsRefundList.size() == 1){
				if(CollectionUtils.isNotEmpty(newSuppGoodsRefundList)){
					//新数据为 扣除每张
					if(null != newSuppGoodsRefundList.get(0).getCancelTimeType() && newSuppGoodsRefundList.size()==1){
						refundMap = this.isChangedForRefund(flag,-1,refundMap, suppGoodsRefund, newSuppGoodsRefundList.get(0));
					}else{
						for(int i=0;i<newSuppGoodsRefundList.size();i++){
							refundMap = this.isChangedForRefund(flag,i,refundMap, null, newSuppGoodsRefundList.get(i));
						}
					}

				}
			}else{
			    //老数据 为时间分级   suppGoodsRefundList   主要监测latest_cancel_time  deduct_type  deduct_value  次要cancel_time_type
				if(CollectionUtils.isNotEmpty(newSuppGoodsRefundList)){
					List<SuppGoodsRefund> oldArrayList = new ArrayList<SuppGoodsRefund>();
					//新数据为 扣除每张
					if(null != newSuppGoodsRefundList.get(0).getCancelTimeType() && newSuppGoodsRefundList.size()==1){
						refundMap = this.isChangedForRefund(flag,-1,refundMap, null, newSuppGoodsRefundList.get(0));
					}else{
						oldArrayList.addAll(suppGoodsRefundList);
					    //新数据为分时间等级
						for(int i=0,len=newSuppGoodsRefundList.size();i<len;i++){
							for(int j=0,len2=oldArrayList.size();j<len2;j++){
								if(oldArrayList.get(j).getDeductType().equals(newSuppGoodsRefundList.get(i).getDeductType())
								   && oldArrayList.get(j).getDeductValue().equals(newSuppGoodsRefundList.get(i).getDeductValue())){
									   //新旧数据cancelTimeType  latestCancelTime都相等时
									   if((null == oldArrayList.get(j).getCancelTimeType() && null == newSuppGoodsRefundList.get(i).getCancelTimeType())
											   ||(null != oldArrayList.get(j).getCancelTimeType() && null != newSuppGoodsRefundList.get(i).getCancelTimeType()
											   && oldArrayList.get(j).getCancelTimeType().equals(newSuppGoodsRefundList.get(i).getCancelTimeType()))){
										   if((null == oldArrayList.get(j).getLatestCancelTime() && null == newSuppGoodsRefundList.get(i).getLatestCancelTime())
												 || (null != oldArrayList.get(j).getLatestCancelTime() && null != newSuppGoodsRefundList.get(i).getLatestCancelTime()
												 && oldArrayList.get(j).getLatestCancelTime().equals(newSuppGoodsRefundList.get(i).getLatestCancelTime()))){
											   newSuppGoodsRefundList.remove(newSuppGoodsRefundList.get(i));
											   oldArrayList.remove(oldArrayList.get(j));
											   len--;
											   i--;
											   len2--;
											   j--;
										   }
									   }
								}
							}
						}
						if(newSuppGoodsRefundList.size()>0){
							for(int i=0;i<newSuppGoodsRefundList.size();i++){
								refundMap = this.isChangedForRefund(flag,i,refundMap, null, newSuppGoodsRefundList.get(i));
								
							}
						}
					}
				}
			}
			if(refundMap.size()>0){
				map.put("suppGoodsRefund", refundMap);
			}
			if(map.size()>0){
				this.fillGoodsInfomation(map, suppGoodsRefund.getGoodsId());
			}
		}
		
		private void fillGoodsInfomation(Map<String,Object> map,Long suppGoodsId){
			SuppGoods suppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoodsId));
        	if(null != suppGoods){
        		ProdProductBranch prodProductBranch = prodProductBranchService.findProdProductBranchById(suppGoods.getProductBranchId(), false, false);
        	    if(null != prodProductBranch){
        	    	map.put("branchName",prodProductBranch.getBranchName());
        	    }
        	    map.put("productId", suppGoods.getProductId());
        	    map.put("productBranchId", suppGoods.getProductBranchId());
        	}
		}
		public String isCanReschedule(SuppGoods suppGoods){
          String canReschedule="N";
          boolean isEBKAndEnterInTime = false;
          boolean apiFlag =false;
           try {
                Boolean IS_EBK_NOTICE = Boolean.FALSE;
                Boolean IS_FAX_NOTICE = "Y".equalsIgnoreCase(suppGoods.getFaxFlag());
                if (null != suppGoods&&!IS_FAX_NOTICE && isRescheduleCategory(suppGoods.getCategoryId())) {
                    if (!IS_EBK_NOTICE) {
                        Map<String,Object> paramUser=new HashMap<String,Object>();
                        paramUser.put("cancelFlag", "Y");
                        paramUser.put("supplierId", suppGoods.getSupplierId());
                        List<EbkUser> ebkUserList = ebkUserClientService.getEbkUserList(paramUser).getReturnContent();
                        if(ebkUserList!=null&& !ebkUserList.isEmpty()){
                            IS_EBK_NOTICE= true;
                        }
                    }
                    if (IS_EBK_NOTICE) {
                        String notInTimeFlag_suppgoods = suppGoods.getNotInTimeFlag();
                        if (!"Y".equals(notInTimeFlag_suppgoods)) {
                            isEBKAndEnterInTime = true;
                        }
                    }
                   if(SuppGoods.NOTICETYPE.QRCODE.name().equalsIgnoreCase(suppGoods.getNoticeType())){
                      apiFlag = true;
                   }
                }
            } catch (Exception e) {
                LOG.error("OrderRescheduleClientServiceImpl isEbkAndEnterInTime error:", e);
            }
          if(isEBKAndEnterInTime&&!apiFlag){
           canReschedule="Y";
          }
          return canReschedule;
        }
        private boolean isRescheduleCategory(Long categoryId) {
            return categoryId != null && (
            BizEnum.BIZ_CATEGORY_TYPE.category_single_ticket.getCategoryId().equals(categoryId) ||
            BizEnum.BIZ_CATEGORY_TYPE.category_other_ticket.getCategoryId().equals(categoryId) ||
            BizEnum.BIZ_CATEGORY_TYPE.category_comb_ticket.getCategoryId().equals(categoryId));
        }
}
