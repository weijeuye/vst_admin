
package com.lvmama.vst.back.control.web;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.util.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.alibaba.dubbo.common.utils.CollectionUtils;
import com.lvmama.comm.pet.po.mark.MarkCouponUsage;
import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.vst.back.biz.po.BizEnum;
import com.lvmama.vst.back.client.dist.service.DistributorClientService;
import com.lvmama.vst.back.client.ord.service.OrderService;
import com.lvmama.vst.back.client.precontrol.service.ResPrecontrolBindGoodsClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.pub.service.ComPushClientService;
import com.lvmama.vst.back.client.supp.service.SuppSupplierClientService;
import com.lvmama.vst.back.control.po.ResControlEnum;
import com.lvmama.vst.back.control.po.ResPrecontrolAmount;
import com.lvmama.vst.back.control.po.ResPrecontrolBindGoods;
import com.lvmama.vst.back.control.po.ResPrecontrolInventory;
import com.lvmama.vst.back.control.po.ResPrecontrolJob;
import com.lvmama.vst.back.control.po.ResPrecontrolPayment;
import com.lvmama.vst.back.control.po.ResPrecontrolPolicy;
import com.lvmama.vst.back.control.po.ResPrecontrolPolicyItem;
import com.lvmama.vst.back.control.po.ResPrecontrolWarmOption;
import com.lvmama.vst.back.control.po.ResPrecontrolWarmReceiver;
import com.lvmama.vst.back.control.po.ResRuleReceiverRelation;
import com.lvmama.vst.back.control.po.ResWarmRule;
import com.lvmama.vst.back.control.po.vo.ResPrecontrolPolicyVo;
import com.lvmama.vst.back.control.service.ResPrecontrolAmountService;
import com.lvmama.vst.back.control.service.ResPrecontrolInventoryService;
import com.lvmama.vst.back.control.service.ResPrecontrolJobService;
import com.lvmama.vst.back.control.service.ResPrecontrolPaymentService;
import com.lvmama.vst.back.control.service.ResPrecontrolPolicyItemService;
import com.lvmama.vst.back.control.service.ResPrecontrolPolicyService;
import com.lvmama.vst.back.control.service.ResPrecontrolWarmOptionService;
import com.lvmama.vst.back.control.service.ResPrecontrolWarmReceiverService;
import com.lvmama.vst.back.control.service.ResRuleReceiverRelationSerive;
import com.lvmama.vst.back.control.service.ResWarmRuleService;
import com.lvmama.vst.back.control.vo.ResPrecontrolGoodsVo;
import com.lvmama.vst.back.control.vo.ResPrecontrolOrderVo;
import com.lvmama.vst.back.dist.po.Distributor;
import com.lvmama.vst.back.order.po.OrdMulPriceRate;
import com.lvmama.vst.back.order.po.OrdOrder;
import com.lvmama.vst.back.order.po.OrdOrderHotelTimeRate;
import com.lvmama.vst.back.order.po.OrdOrderItem;
import com.lvmama.vst.back.order.po.OrdOrderPack;
import com.lvmama.vst.back.order.po.OrderEnum;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.router.adapter.ResPrecontrolGoodsHotelAdapterService;
import com.lvmama.vst.back.supp.po.SuppSupplier;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.DateUtil;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.utils.ReadExcel;
import com.lvmama.vst.comm.utils.ResourceUtil;
import com.lvmama.vst.comm.utils.order.PriceUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultHandle;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.jxls.transformer.XLSTransformer;

/**
 * 商品绑定买断资源预控策略
 *
 */
@Controller
@RequestMapping("/goods/recontrol")
public class GoodsControlBudgetAction extends BaseActionSupport {

	private static final long serialVersionUID = 8336868649878157264L;

	private static final Log LOG = LogFactory.getLog(GoodsControlBudgetAction.class);

	// @Autowired
	// private ResPreControlService resPreControlService;

	@Autowired
	private OrderService orderService;

	@Autowired
	private ProdProductClientService prodProductService;// 查询商品

	@Autowired
	private ResPrecontrolPolicyService resPrecontrolPolicyService;

	@Autowired
	private PermUserServiceAdapter permUserServiceAdapter;

	@Autowired
	private SuppSupplierClientService suppSupplierService;

	@Autowired
	private ResPrecontrolInventoryService resPrecontrolInventoryService;

	@Autowired
	private ResPrecontrolAmountService resPrecontrolAmountService;

	@Autowired
	private ResPrecontrolWarmReceiverService resPrecontrolWarmReceiverService;

	@Autowired
	private ResPrecontrolWarmOptionService resPrecontrolWarmOptionService;

	@Autowired
	private ResRuleReceiverRelationSerive resRuleReceiverRelationSerive;

	@Autowired
	private ResWarmRuleService resWarmRuleService;

	@Autowired
	private ComLogClientService comLogService;

	@Autowired
	private ResPrecontrolBindGoodsClientService resPrecontrolBindGoodsService;

	@Autowired
	private ResPrecontrolGoodsHotelAdapterService resPrecontrolGoodsHotelAdapterService;

	@Autowired
	private ComPushClientService comPushClientService;

	@Autowired
	private ResPrecontrolJobService resPrecontrolJobService;

	@Autowired
	private ResPrecontrolPolicyItemService resPrecontrolPolicyItemService;

	@Autowired
	private ResPrecontrolPaymentService resPrecontrolPaymentService;

	// 注入分销商业务接口(订单来源、下单渠道)
	@Autowired
	private DistributorClientService distributorClientService;

	/**
	 * 导出excel对应模板文件地址
	 */
	public static final String POLICY_TEMPLATE_PATH = "/WEB-INF/resources/template/resPrecontrolPolicyTemplate.xls";

	/**
	 * 下载批量导入付款流水记录excel对应模板文件地址
	 */
	public static final String RES_PRECONTROL_PAYMENT_TEMPLATE_PATH = "/WEB-INF/resources/template/batchResPrecontrolPaymentTemplate.xls";

	/**
	 * 根据供应商ID，从买断系统中获取该供应商预控项目，只显示预控状态 = 新建，启用的项目；
	 *
	 * @param model
	 * @param page
	 * @param resPrecontrolPolicy
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/find/findResPrecontrolPolicyBySuppId")
	public String findResPrecontrolPolicyBySuppId(Model model, ResPrecontrolPolicy resPrecontrolPolicy,
			HttpServletRequest req) {
		try {
			// List<ResPrecontrolPolicy>
			// resPrecontrolPolicies =
			// this.resPreControlService.selectBySuppId(resPrecontrolPolicy.getSupplierId());
			// model.addAttribute("resPrecontrolPolicies",
			// resPrecontrolPolicies);
		} catch (Exception e) {
			log.error("【GoodsControlBudgetAction.findResPrecontrolPolicyBySuppId 】 Exception", e);
		}
		return "/res/resource_control_bind";
	}

	/**
	 * 测试专用调转到设置预控首页
	 */
	@RequestMapping(value = "/index")
	public String showIndex() {
		return "/res/resource_control_setting";
	}

	/**
	 * 查看剩余量的页面
	 *
	 * @param id
	 * @param modelMap
	 * @return
	 */
	@RequestMapping(value = "/goToRemainder/view")
	public String showView(Long id, ModelMap modelMap) {
		ResPrecontrolPolicy resPrecontrolPolicy = resPrecontrolPolicyService.findResPrecontrolPolicyById(id);
		Date resDate = resPrecontrolPolicy.getTradeEffectDate();
		String year = DateUtil.getFormatYear(resDate);
		int month = DateUtil.getMonth(resDate);
		if (month == 0) {
			month = 12;
		}
		modelMap.put("precontrolPolicyId", id);
		modelMap.put("year", year);
		modelMap.put("month", month);
		return "/res/resource_view_remainder";
	}

	/**
	 * 展示剩余量的详细
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/remainder/detail")
	@ResponseBody
	public JSONArray showDetail(Long id) {
		JSONArray jsonArray = new JSONArray();
		ResPrecontrolPolicy resPrecontrolPolicy = resPrecontrolPolicyService.findResPrecontrolPolicyById(id);
		String str = resPrecontrolPolicy.getControlType();
		if (str.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
			Long firstValue = divNumber(resPrecontrolPolicy.getAmount());
			List<ResPrecontrolAmount> list = resPrecontrolAmountService.findDailyByResPrecontrolPolicyId(id);
			if (null != list && !list.isEmpty()) {
				for (ResPrecontrolAmount amount : list) {
					// if (amount.getQuantity() != null &&
					// amount.getQuantity() < 0) {
					// amount.setQuantity(0L);
					// }
					JSONObject jsonObject = new JSONObject();
					String date = DateUtil.formatDate(amount.getEffectDate(), "yyyy-MM-dd");
					jsonObject.put("date", date);
					jsonObject.put("type", "money");
					jsonObject.put("value", "￥" + divNumber(amount.getQuantity()) + "/￥" + firstValue);
					jsonArray.add(jsonObject);
				}
			}
		} else {
			Long firstValue = resPrecontrolPolicy.getAmount();
			List<ResPrecontrolInventory> list = resPrecontrolInventoryService.findByCycleResPrecontrolPolicyId(id);
			if (null != list && !list.isEmpty()) {
				for (ResPrecontrolInventory inventory : list) {
					// if (inventory.getQuantity() != null
					// && inventory.getQuantity() < 0) {
					// inventory.setQuantity(0L);
					// }
					JSONObject jsonObject = new JSONObject();
					String date = DateUtil.formatDate(inventory.getEffectDate(), "yyyy-MM-dd");
					jsonObject.put("date", date);
					jsonObject.put("type", "stock");
					jsonObject.put("value", inventory.getQuantity() + "/" + firstValue);
					jsonArray.add(jsonObject);
				}
			}
		}
		// 组装JSON数据
		return jsonArray;
	}

	/**
	 * 查询列表的显示
	 *
	 * @param model
	 * @param page
	 * @param resPrecontrolPolicy
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/find/resPrecontrolPolicyList")
	public String findResPrecontrolPolicy(Model model, Integer page, ResPrecontrolPolicy resPrecontrolPolicy,
			HttpServletRequest req) {
		Map<String, Object> paramResPrecontrolPolicy = new HashMap<String, Object>();
		paramResPrecontrolPolicy.put("supplierId", resPrecontrolPolicy.getSupplierId());
		paramResPrecontrolPolicy.put("name", resPrecontrolPolicy.getName());
		paramResPrecontrolPolicy.put("controlType", resPrecontrolPolicy.getControlType());
		paramResPrecontrolPolicy.put("controlClassification", resPrecontrolPolicy.getControlClassification());
		paramResPrecontrolPolicy.put("state", resPrecontrolPolicy.getState()); // state
		paramResPrecontrolPolicy.put("productManagerId", resPrecontrolPolicy.getProductManagerId());
		paramResPrecontrolPolicy.put("tradeEffectDate", resPrecontrolPolicy.getTradeEffectDate());
		paramResPrecontrolPolicy.put("tradeExpiryDate", resPrecontrolPolicy.getTradeExpiryDate());
		paramResPrecontrolPolicy.put("isDeleted", 0);
		paramResPrecontrolPolicy.put("buCode", resPrecontrolPolicy.getBuCode());
		paramResPrecontrolPolicy.put("creatTimeStart", resPrecontrolPolicy.getCreatTimeStart());
		paramResPrecontrolPolicy.put("creatTimeEnd", resPrecontrolPolicy.getCreatTimeEnd() == null
				? resPrecontrolPolicy.getCreatTimeEnd() : DateUtil.addDays(resPrecontrolPolicy.getCreatTimeEnd(), 1));
		paramResPrecontrolPolicy.put("id", resPrecontrolPolicy.getId());
		if (StringUtils.isEmpty(resPrecontrolPolicy.getIsTest())) {
			resPrecontrolPolicy.setIsTest("N");
		}
		paramResPrecontrolPolicy.put("isTest", resPrecontrolPolicy.getIsTest());
		int count = resPrecontrolPolicyService.findResPrecontrolPolicyCount(paramResPrecontrolPolicy);
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		paramResPrecontrolPolicy.put("_start", pageParam.getStartRows());
		paramResPrecontrolPolicy.put("_end", pageParam.getEndRows());
		paramResPrecontrolPolicy.put("_orderby", "ID");
		paramResPrecontrolPolicy.put("_order", "DESC");
		// //获取登录用户
		// PermUser user=getLoginUser();
		// // 判断此用户是否有付款的权限
		// //"/vst_admin/goods/recontrol/goToResControlPaymentMain/view.do?precontrolPolicyId="+id
		// String isCanPay="N";//N:不能付款 Y:可以付款
		// String
		// URL="/vst_admin/goods/recontrol/goToResControlPaymentMain/view.do";
		// List<PermPermission> permissionList=
		// user.getPermissionList();
		// for (PermPermission permPermission :
		// permissionList) {
		// if (URL.equals(permPermission.getUrl())) {
		// isCanPay="Y";
		// break;
		// }
		// }
		List<ResPrecontrolPolicyVo> list = resPrecontrolPolicyService
				.findResPrecontrolPolicyList(paramResPrecontrolPolicy);
		List<ResPrecontrolPolicyVo> listAdd = new ArrayList<ResPrecontrolPolicyVo>();
		for (ResPrecontrolPolicyVo resPrecontrolPolicyVo : list) {
			// resPrecontrolPolicyVo.setIsCanPay(isCanPay);
			Long payAmount = 0L;
			List<ResPrecontrolPayment> paymentList = resPrecontrolPaymentService
					.selectByPolicyId(resPrecontrolPolicyVo.getId());
			if (paymentList != null && paymentList.size() > 0) {
				for (ResPrecontrolPayment payment : paymentList) {
					payAmount = payAmount + payment.getAmount();
				}
			}
			resPrecontrolPolicyVo.setPayAmount(payAmount);
			if (resPrecontrolPolicyVo.getControlType()
					.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
				resPrecontrolPolicyVo.setAmount(divNumber(resPrecontrolPolicyVo.getAmount()));
				if (resPrecontrolPolicyVo.getControlClassification()
						.equalsIgnoreCase(ResControlEnum.CONTROL_CLASSIFICATION.Cycle.name())) {
					ResPrecontrolAmount ra = resPrecontrolAmountService
							.findByResPrecontrolPolicyId(resPrecontrolPolicyVo.getId());
					if (ra != null) {
						resPrecontrolPolicyVo.setLeave(divNumber(ra.getQuantity()));
					}
				}
				// if (resPrecontrolPolicyVo.getLeave() !=
				// null && resPrecontrolPolicyVo.getLeave()
				// < 0) {
				// resPrecontrolPolicyVo.setLeave(0L);
				// }
				// 获取子预控金额之和
				Long itemSumAmount = resPrecontrolPolicyItemService
						.getSumAmountByPolicyId(resPrecontrolPolicyVo.getId());
				resPrecontrolPolicyVo.setItemSumAmount(divNumber(itemSumAmount));
				listAdd.add(resPrecontrolPolicyVo);
			} else {
				if (resPrecontrolPolicyVo.getControlClassification()
						.equalsIgnoreCase(ResControlEnum.CONTROL_CLASSIFICATION.Cycle.name())) {
					ResPrecontrolInventory ai = resPrecontrolInventoryService
							.findByResPrecontrolPolicyId(resPrecontrolPolicyVo.getId());
					if (ai != null) {
						resPrecontrolPolicyVo.setLeave(ai.getQuantity());
					}
				}
				// if (resPrecontrolPolicyVo.getLeave() !=
				// null && resPrecontrolPolicyVo.getLeave()
				// < 0) {
				// resPrecontrolPolicyVo.setLeave(0L);
				// }
				// 获取子预控库存之和
				Long itemSumAmount = resPrecontrolPolicyItemService
						.getSumAmountByPolicyId(resPrecontrolPolicyVo.getId());
				resPrecontrolPolicyVo.setItemSumAmount(itemSumAmount);
				listAdd.add(resPrecontrolPolicyVo);
			}
		}
		pageParam.setItems(listAdd);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("supplierName", resPrecontrolPolicy.getSupplierName());
		model.addAttribute("controlName", resPrecontrolPolicy.getName());
		model.addAttribute("supplierId", resPrecontrolPolicy.getSupplierId());
		model.addAttribute("managerName", resPrecontrolPolicy.getProductManagerName());
		model.addAttribute("controlClassification", resPrecontrolPolicy.getControlClassification());
		model.addAttribute("state", resPrecontrolPolicy.getState());
		model.addAttribute("controlType", resPrecontrolPolicy.getControlType());
		model.addAttribute("buCode", resPrecontrolPolicy.getBuCode());
		model.addAttribute("trackformDate",
				DateUtil.getFormatDate(resPrecontrolPolicy.getTradeEffectDate(), "yyyy-MM-dd"));
		model.addAttribute("trackbackDate",
				DateUtil.getFormatDate(resPrecontrolPolicy.getTradeExpiryDate(), "yyyy-MM-dd"));
		model.addAttribute("creatTimeStart",
				DateUtil.getFormatDate(resPrecontrolPolicy.getCreatTimeStart(), "yyyy-MM-dd"));
		model.addAttribute("creatTimeEnd", DateUtil.getFormatDate(resPrecontrolPolicy.getCreatTimeEnd(), "yyyy-MM-dd"));
		model.addAttribute("id", resPrecontrolPolicy.getId());
		model.addAttribute("isTest", resPrecontrolPolicy.getIsTest());
		return "/res/resource_control_setting";
	}

	/**
	 * 导出excel数据
	 * 
	 * @author
	 */
	@RequestMapping(value = "/find/exportExcelData")
	public void exportExcelData(Model model, ResPrecontrolPolicy resPrecontrolPolicy, HttpServletRequest req,
			HttpServletResponse response) throws Exception {
		List<ResPrecontrolPolicyVo> exportList = new ArrayList<ResPrecontrolPolicyVo>();
		Map<String, Object> paramResPrecontrolPolicy = new HashMap<String, Object>();
		paramResPrecontrolPolicy.put("supplierId", resPrecontrolPolicy.getSupplierId());
		paramResPrecontrolPolicy.put("name", resPrecontrolPolicy.getName());
		paramResPrecontrolPolicy.put("controlType", resPrecontrolPolicy.getControlType());
		paramResPrecontrolPolicy.put("controlClassification", resPrecontrolPolicy.getControlClassification());
		paramResPrecontrolPolicy.put("state", resPrecontrolPolicy.getState()); // state
		paramResPrecontrolPolicy.put("productManagerId", resPrecontrolPolicy.getProductManagerId());
		paramResPrecontrolPolicy.put("tradeEffectDate", resPrecontrolPolicy.getTradeEffectDate());
		paramResPrecontrolPolicy.put("tradeExpiryDate", resPrecontrolPolicy.getTradeExpiryDate());
		paramResPrecontrolPolicy.put("isDeleted", 0);
		paramResPrecontrolPolicy.put("buCode", resPrecontrolPolicy.getBuCode());
		paramResPrecontrolPolicy.put("creatTimeStart", resPrecontrolPolicy.getCreatTimeStart());
		paramResPrecontrolPolicy.put("creatTimeEnd", resPrecontrolPolicy.getCreatTimeEnd() == null
				? resPrecontrolPolicy.getCreatTimeEnd() : DateUtil.addDays(resPrecontrolPolicy.getCreatTimeEnd(), 1));
		paramResPrecontrolPolicy.put("id", resPrecontrolPolicy.getId());
		paramResPrecontrolPolicy.put("isTest", resPrecontrolPolicy.getIsTest());
		paramResPrecontrolPolicy.put("_orderby", "ID");
		paramResPrecontrolPolicy.put("_order", "DESC");
		// 根据查询条件查询资源预控策略基本信息
		List<ResPrecontrolPolicyVo> list = resPrecontrolPolicyService
				.findResPrecontrolPolicyList(paramResPrecontrolPolicy);
		for (ResPrecontrolPolicyVo buyoutVo : list) {
			if (buyoutVo.getControlType().equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
				buyoutVo.setAmount(divNumber(buyoutVo.getAmount()));
				if (buyoutVo.getControlClassification()
						.equalsIgnoreCase(ResControlEnum.CONTROL_CLASSIFICATION.Cycle.name())) {
					ResPrecontrolAmount ra = resPrecontrolAmountService.findByResPrecontrolPolicyId(buyoutVo.getId());
					if (ra != null) {
						buyoutVo.setLeave(divNumber(ra.getQuantity()));
					}
				}
			} else {
				if (buyoutVo.getControlClassification()
						.equalsIgnoreCase(ResControlEnum.CONTROL_CLASSIFICATION.Cycle.name())) {
					ResPrecontrolInventory ai = resPrecontrolInventoryService
							.findByResPrecontrolPolicyId(buyoutVo.getId());
					if (ai != null) {
						buyoutVo.setLeave(ai.getQuantity());
					}
				}
			}
			// 获取绑定商品信息
			boolean budgetFlag = true;
			Map<String, Object> paramsMap = new HashMap<String, Object>();
			// 供应商ID
			paramsMap.put("supplierId", buyoutVo.getSupplierId());
			// 资源预控策略ID
			paramsMap.put("precontrolPolicyId", buyoutVo.getId());
			// 根据供应商ID和资源预控策略ID查询绑定的商品数量
			Long totalBindCount = resPrecontrolGoodsHotelAdapterService.getTotalBindGoodsCount(paramsMap);
			if (totalBindCount <= 0) {
				ResPrecontrolPolicyVo exportVO = new ResPrecontrolPolicyVo();
				// 买断策略基本信息
				exportVO.setId(buyoutVo.getId()); // 预控ID
				exportVO.setName(buyoutVo.getName());
				exportVO.setSupplierId(buyoutVo.getSupplierId());
				exportVO.setSupplierName(buyoutVo.getSupplierName());
				exportVO.setBuCode(buyoutVo.getBuCode());
				exportVO.setArea1(buyoutVo.getArea1());
				exportVO.setProductManagerName(buyoutVo.getProductManagerName());
				exportVO.setAmount(buyoutVo.getAmount());
				exportVO.setControlType(buyoutVo.getControlType());
				exportVO.setControlClassification(buyoutVo.getControlClassification());
				exportVO.setCreatTime(buyoutVo.getCreatTime());
				exportVO.setState(buyoutVo.getState());
				exportVO.setTradeEffectDate(buyoutVo.getTradeEffectDate());
				exportVO.setTradeExpiryDate(buyoutVo.getTradeExpiryDate());
				exportVO.setIsTest(buyoutVo.getIsTest());
				exportList.add(exportVO);
				continue;
			} else {
				// 数据
				Page<ResPrecontrolGoodsVo> page = new Page<ResPrecontrolGoodsVo>();
				page.setCurrentPage(1L);
				page.setPageSize(totalBindCount);
				page.setTotalResultSize(totalBindCount);
				ResPrecontrolGoodsVo vo = new ResPrecontrolGoodsVo();
				// 供应商ID
				vo.setSupplierId(buyoutVo.getSupplierId());
				// 是已绑定商品
				vo.setBudgetFlag(budgetFlag);
				// 资源预控ID
				vo.setPrecontrolPolicyId(buyoutVo.getId());
				page.setParam(vo);
				// 根据供应商ID和资源预控策略ID查询绑定的商品数量
				List<ResPrecontrolGoodsVo> suppGoodsList = resPrecontrolGoodsHotelAdapterService
						.getResPrecontrolBindGoodsVoList(page);
				if (CollectionUtils.isEmpty(suppGoodsList)) {
					ResPrecontrolPolicyVo exportVO = new ResPrecontrolPolicyVo();
					// 买断策略基本信息
					exportVO.setId(buyoutVo.getId()); // 预控ID
					exportVO.setName(buyoutVo.getName());
					exportVO.setSupplierId(buyoutVo.getSupplierId());
					exportVO.setSupplierName(buyoutVo.getSupplierName());
					exportVO.setBuCode(buyoutVo.getBuCode());
					exportVO.setArea1(buyoutVo.getArea1());
					exportVO.setArea2(buyoutVo.getArea2());
					exportVO.setProductManagerName(buyoutVo.getProductManagerName());
					exportVO.setAmount(buyoutVo.getAmount());
					exportVO.setControlType(buyoutVo.getControlType());
					exportVO.setControlClassification(buyoutVo.getControlClassification());
					exportVO.setCreatTime(buyoutVo.getCreatTime());
					exportVO.setState(buyoutVo.getState());
					exportVO.setTradeEffectDate(buyoutVo.getTradeEffectDate());
					exportVO.setTradeExpiryDate(buyoutVo.getTradeExpiryDate());
					exportVO.setIsTest(buyoutVo.getIsTest());
					exportList.add(exportVO);
					continue;
				} else {
					for (ResPrecontrolGoodsVo goodsVo : suppGoodsList) {
						Long goods_id = goodsVo.getSuppGoodsId();
						Long goodsOrderItemCount = orderService.countPercontrolGoodsOrderList(goods_id,
								buyoutVo.getTradeEffectDate(), buyoutVo.getTradeExpiryDate(), null);
						if (goodsOrderItemCount <= 0) {
							ResPrecontrolPolicyVo exportVO = new ResPrecontrolPolicyVo();
							// 买断策略基本信息
							exportVO.setId(buyoutVo.getId()); // 预控ID
							exportVO.setName(buyoutVo.getName());
							exportVO.setSupplierId(buyoutVo.getSupplierId());
							exportVO.setSupplierName(buyoutVo.getSupplierName());
							exportVO.setBuCode(buyoutVo.getBuCode());
							exportVO.setArea1(buyoutVo.getArea1());
							exportVO.setArea2(buyoutVo.getArea2());
							exportVO.setProductManagerName(buyoutVo.getProductManagerName());
							exportVO.setAmount(buyoutVo.getAmount());
							exportVO.setControlType(buyoutVo.getControlType());
							exportVO.setControlClassification(buyoutVo.getControlClassification());
							exportVO.setCreatTime(buyoutVo.getCreatTime());
							exportVO.setState(buyoutVo.getState());
							exportVO.setTradeEffectDate(buyoutVo.getTradeEffectDate());
							exportVO.setTradeExpiryDate(buyoutVo.getTradeExpiryDate());
							exportVO.setGoodsName(goodsVo.getSuppGoodsName());
							exportVO.setIsTest(buyoutVo.getIsTest());
							exportList.add(exportVO);
							continue;
						}
						List<ResPrecontrolOrderVo> orderList = queryOrderItem(1L, goodsOrderItemCount,
								goodsOrderItemCount, goods_id, buyoutVo.getTradeEffectDate(),
								buyoutVo.getTradeExpiryDate());
						if (orderList != null && orderList.size() > 0) {
							for (ResPrecontrolOrderVo orderVo : orderList) {
								ResPrecontrolPolicyVo exportVO = new ResPrecontrolPolicyVo();
								// 买断策略基本信息
								exportVO.setId(buyoutVo.getId()); // 预控ID
								exportVO.setName(buyoutVo.getName());
								exportVO.setSupplierId(buyoutVo.getSupplierId());
								exportVO.setSupplierName(buyoutVo.getSupplierName());
								exportVO.setBuCode(buyoutVo.getBuCode());
								exportVO.setArea1(buyoutVo.getArea1());
								exportVO.setArea2(buyoutVo.getArea2());
								exportVO.setProductManagerName(buyoutVo.getProductManagerName());
								exportVO.setAmount(buyoutVo.getAmount());
								exportVO.setControlType(buyoutVo.getControlType());
								exportVO.setControlClassification(buyoutVo.getControlClassification());
								exportVO.setCreatTime(buyoutVo.getCreatTime());
								exportVO.setState(buyoutVo.getState());
								exportVO.setTradeEffectDate(buyoutVo.getTradeEffectDate());
								exportVO.setTradeExpiryDate(buyoutVo.getTradeExpiryDate());
								// 子订单明细信息
								exportVO.setOrderId(orderVo.getOrderId());
								exportVO.setOrderItemId(orderVo.getOrderItemId());
								exportVO.setOrderStatus(OrderEnum.ORDER_STATUS.getCnName(orderVo.getOrderStatus()));
								exportVO.setGoodsName(goodsVo.getSuppGoodsName());
								exportVO.setBuyoutSalesAmount(orderVo.getOrderItemSalesAmount() == null ? 0l
										: orderVo.getOrderItemSalesAmount());
								exportVO.setBuyoutSettlementAmount(orderVo.getBuyoutTotalSettlementPrice() == null ? 0
										: orderVo.getBuyoutTotalSettlementPrice());
								boolean isHotel = BizEnum.BIZ_CATEGORY_TYPE.category_hotel.getCategoryId() == orderVo
										.getOrderItemCategoryId();
								if (isHotel) {
									exportVO.setBuyoutRoomNightNum(orderVo.getBuyoutQuantity());
								} else {
									if (orderVo.getOrdMulPriceRateList() != null
											&& orderVo.getOrdMulPriceRateList().size() > 0) {
										// 六大品类需要重新计算儿童数、成人数、结算总价
										exportVO.setBuyoutAdultNum(orderVo.getBuyoutAdultNum());
										exportVO.setBuyoutChildNum(orderVo.getBuyoutChildNum());
										exportVO.setBuyoutSettlementAmount(orderVo.getTotal());
									} else {
										exportVO.setBuyoutAdultNum(orderVo.getBuyoutQuantity());
									}
								}
								// 设置毛利
								exportVO.setGrossProfit(divNumber(
										exportVO.getBuyoutSalesAmount() - exportVO.getBuyoutSettlementAmount()));
								// 订单ID
								Long orderId = orderVo.getOrderId();
								if (null != orderId) {
									OrdOrder ordOrderInfo = this.orderService.queryOrdorderByOrderId(orderId);
									if (null != ordOrderInfo) {
										Distributor distributor = this.distributorClientService
												.findDistributorById(ordOrderInfo.getDistributorId())
												.getReturnContent();
										if (null != distributor) {
											// 设置（订单来源）下单渠道
											exportVO.setSingleChannel(distributor.getDistributorName());
										}
									}
								}
								// 设置是否测试
								exportVO.setIsTest(buyoutVo.getIsTest());
								exportList.add(exportVO);
							}
						}
					}
				}
			}
		}
		if (exportList != null) {
			Map<String, Object> exportMap = new HashMap<String, Object>();
			exportMap.put("policyList", exportList);
			String destFileName = writeExcelByjXls(exportMap, POLICY_TEMPLATE_PATH);
			writeAttachment(destFileName, "precontrolPolicyExcel_" + DateUtil.formatDate(new Date(), "yyyyMMddHHmm"),
					response);
		}
	}

	/**
	 * 下载批量导入付款模板
	 * 
	 * @return
	 */
	@RequestMapping(value = "/downloadPaymentTemplate")
	public void downloadPaymentTemplate(Model model, HttpServletRequest request, HttpServletResponse response) {
		BufferedInputStream bis = null;
		BufferedOutputStream bos = null;
		try {
			// // 获取项目根目录
			// String ctxPath =
			// request.getSession().getServletContext().getRealPath("");
			// // 获取下载文件路径
			// String downLoadPath = ctxPath +
			// RES_PRECONTROL_PAYMENT_TEMPLATE_PATH;
			// File file = new File(downLoadPath);
			File file = ResourceUtil.getResourceFile(RES_PRECONTROL_PAYMENT_TEMPLATE_PATH);
			// 获取文件的长度
			long fileLength = file.length();
			// 设置文件输出类型
			// response.setContentType("application/vnd.ms-excel");
			// MediaType applicationOctetStream =
			// MediaType.APPLICATION_OCTET_STREAM;
			// String applicationOctetStreamValue =
			// MediaType.APPLICATION_OCTET_STREAM_VALUE;
			// 设置文件输出类型
			// response.setContentType("application/octet-stream");
			// 设置文件输出类型
			response.setContentType(MediaType.APPLICATION_OCTET_STREAM_VALUE);
			// 设置
			response.setHeader("Content-Disposition", "attachment; filename=" + file.getName());
			// 设置输出长度
			response.setHeader("Content-Length", String.valueOf(fileLength));
			// 获取输入流
			bis = new BufferedInputStream(new FileInputStream(file));
			// 输出流
			bos = new BufferedOutputStream(response.getOutputStream());
			IOUtils.copy(bis, bos);
			bos.flush();
		} catch (Exception e) {
			log.error("===========>【GoodsControlBudgetAction.downloadPaymentTemplate Exception】", e);
		} finally {
			// 关闭流
			org.apache.commons.io.IOUtils.closeQuietly(bis);
			org.apache.commons.io.IOUtils.closeQuietly(bos);
		}
	}

	/**
	 * 批量导入付款
	 * 
	 * @return
	 */
	@RequestMapping(value = "/goToResControlPaymentBatchImport/view")
	public String goToResControlPaymentBatchImport(Model model, HttpServletRequest request,
			HttpServletResponse response) {
		return "/res/resource_paymoney_batch_import";
	}

	/**
	 * 导入文件数据
	 */
	@RequestMapping(value = "/importResControlPaymentExcelData")
	@ResponseBody
	public Object importResControlPaymentExcelData(Model model, HttpServletRequest request,
			HttpServletResponse response) {
		ResultHandle resultHandle = new ResultHandle();
		try {
			MultipartHttpServletRequest mulRequest = (MultipartHttpServletRequest) request;
			MultipartFile file = mulRequest.getFile("excel");
			String filename = file.getOriginalFilename();
			if (filename == null || "".equals(filename)) {
				return null;
			}
			InputStream input = file.getInputStream();
			StringBuffer sb = new StringBuffer("");
			ArrayList<ArrayList<String>> rows = null;
			try {
				rows = ReadExcel.readExcel(null, input);
			} catch (Exception ex) {
				log.error("解析上传的文件异常:", ex);
				sb.append("解析上传的文件异常，请检查上传的文件是否正确！");
			}
			boolean isSuccess = true;
			List<ResPrecontrolPayment> insertResPrecontrolPaymentList = new ArrayList<>();
			ResPrecontrolPayment resPrecontrolPayment = null;
			boolean hasData = false;
			if (CollectionUtils.isEmpty(rows)) {
				sb.append("导入的文件没有付款记录无法导入！");
			} else {
				for (int rowIndex = 0; rowIndex < rows.size(); rowIndex++) {
					// 第一行表头返回
					// if (rowIndex == 0) {
					// continue;
					// }
					ArrayList<String> rowList = rows.get(rowIndex);
					resPrecontrolPayment = new ResPrecontrolPayment();
					if (ReadExcel.isStrListEveryEmpty(rowList)) {
						continue;
					} else {
						hasData = true;
					}
					ResPrecontrolPolicy resPrecontrolPolicy = null;
					for (int cellIndex = 0; cellIndex < rowList.size(); cellIndex++) {
						String cellStr = rowList.get(cellIndex);
						if (StringUtils.isNotEmpty(cellStr)) {
							cellStr = cellStr.trim();
						}
						if (cellIndex == 0) {
							if (StringUtils.isEmpty(cellStr)) {
								isSuccess = false;
								sb.append("第" + (rowIndex + 1) + "行预控ID不能为空！");
								continue;
							} else {
								// 预控ID
								Long precontrolPolicyId = null;
								try {
									double parseDouble = Double.parseDouble(cellStr);
									precontrolPolicyId = (long) parseDouble;
									// precontrolPolicyId =
									// Long.parseLong(cellStr);
								} catch (NumberFormatException e) {
									isSuccess = false;
									log.error("第" + (rowIndex + 1) + "行预控ID格式不正确！", e);
									sb.append("预控ID格式不正确！");
								}
								resPrecontrolPolicy = this.resPrecontrolPolicyService
										.findResPrecontrolPolicyById(precontrolPolicyId);
								if (null == resPrecontrolPolicy) {
									isSuccess = false;
									sb.append("预控ID【" + precontrolPolicyId + "】未找到对应的资源预控信息，请检查是否正确！");
									continue;
								}
								resPrecontrolPayment.setPrecontrolPolicyId(precontrolPolicyId);
							}
						} else if (cellIndex == 1) {
							// 预控名称
						} else if (cellIndex == 2) {
							// 付款日期
							if (StringUtils.isEmpty(cellStr)) {
								isSuccess = false;
								sb.append("预控ID【" + resPrecontrolPolicy.getId() + "】付款日期不能为空！");
							} else {
								SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
								Date payDate = null;
								try {
									payDate = sdf.parse(cellStr);
								} catch (ParseException e) {
									isSuccess = false;
									log.error("第" + (rowIndex + 1) + "行付款日期格式不正确！", e);
									sb.append("预控ID【" + resPrecontrolPolicy.getId() + "】付款日期格式不正确！");
								}
								resPrecontrolPayment.setPayDate(payDate);
							}
						} else if (cellIndex == 3) {
							// 付款金额
							if (StringUtils.isEmpty(cellStr)) {
								isSuccess = false;
								sb.append("预控ID【" + resPrecontrolPolicy.getId() + "】付款金额不能为空！");
							} else {
								double parseDouble = 0;
								try {
									parseDouble = Double.parseDouble(cellStr);
									// amount = Long.parseLong(cellStr);
								} catch (NumberFormatException e) {
									isSuccess = false;
									log.error("第" + (rowIndex + 1) + "行付款金额	格式不正确！", e);
									sb.append("预控ID【" + resPrecontrolPolicy.getId() + "】付款金额格式不正确！");
								}
								resPrecontrolPayment.setAmount((long) (parseDouble * 100));
							}
						} else if (cellIndex == 4) {
							// 备注
							if (StringUtils.isNotEmpty(cellStr)) {
								resPrecontrolPayment.setMemo(cellStr);
							}
						}
					}
					resPrecontrolPayment.setCreatTime(new Date());
					String userName = getUserName();
					String userCnName = getUserCnName();
					resPrecontrolPayment.setOperatorId(userName);
					resPrecontrolPayment.setPayPerson(userCnName);
					insertResPrecontrolPaymentList.add(resPrecontrolPayment);
				}
			}
			if (CollectionUtils.isNotEmpty(insertResPrecontrolPaymentList)) {
				if (insertResPrecontrolPaymentList.size() > 1000) {
					isSuccess = false;
					sb.append("数据条数超过1000条，请缩减条数分批次导入！");
				}
			}
			if (!hasData) {
				isSuccess = false;
				sb.append("导入的文件没有付款记录无法导入！");
			}
			String msg = sb.toString();
			if (!isSuccess && StringUtils.isNotEmpty(msg)) {
				// 返回提示信息到界面
				resultHandle.setMsg(msg);
				return resultHandle;
			}
			if (CollectionUtils.isNotEmpty(insertResPrecontrolPaymentList)) {
				for (int i = 0; i < insertResPrecontrolPaymentList.size(); i++) {
					ResPrecontrolPayment rppEntity = insertResPrecontrolPaymentList.get(i);
					this.resPrecontrolPaymentService.save(rppEntity);
				}
			}
			return resultHandle;
		} catch (Exception e) {
			log.error("=============>【GoodsControlBudgetAction.importResControlPaymentExcelData】 Exception", e);
			resultHandle.setMsg(e.getMessage());
			return resultHandle;
		}
	}

	/**
	 * 格式化Set为String，以“,”分割
	 * 
	 * @param set
	 * @return
	 */
	public static String formatSetToString(Set set) {
		StringBuffer sb = new StringBuffer();
		// 遍历
		int num = set.size();
		int i = 0;
		for (Iterator iterator = set.iterator(); iterator.hasNext();) {
			i++;
			if (i < num) {
				sb.append(iterator.next() + ",");
			} else {
				sb.append(iterator.next());
			}
		}
		return sb.toString();
	}

	/**
	 * 写excel通过模板 bean
	 * 
	 * @param beans
	 * @param template
	 * @return
	 * @throws Exception
	 */
	public static String writeExcelByjXls(Map<String, Object> beans, String template) {
		try {
			File templateResource = ResourceUtil.getResourceFile(template);
			XLSTransformer transformer = new XLSTransformer();
			String destFileName = getTempDir() + "/policyExcel" + new Date().getTime() + ".xls";
			transformer.transformXLS(templateResource.getAbsolutePath(), beans, destFileName);
			return destFileName;
		} catch (Exception e) {
			LOG.error("写excel通过模板 beanException", e);
		}
		return null;
	}

	public static String getTempDir() {
		return System.getProperty("java.io.tmpdir");
	}

	/**
	 * 内部跳转添加页面
	 *
	 * @return
	 */
	@RequestMapping(value = "/goToAddResControl/view")
	public String showAdd() {
		return "/res/resource_add_control";
	}

	@RequestMapping(value = "/editNewResourceControl")
	@ResponseBody
	public String editNewResourceControl(ResPrecontrolPolicy resPrecontrolPolicy,
			ResPrecontrolWarmReceiver resPrecontrolWarmReceiver, String code, String value, String ids,
			String ProductManagerEmail) {
		StringBuffer sb = new StringBuffer("{\"code\":");
		// 保存前先判断项目名称是否为空
		ResPrecontrolPolicy resPrecontrolPolicyFirst = resPrecontrolPolicyService
				.findResPrecontrolPolicyById(resPrecontrolPolicy.getId());
		if (null == resPrecontrolPolicyFirst) {
			// return ResultMessage.ERROR;
			sb.append("0, \"msg\":\"此资源预控不存在!\"}");
			return sb.toString();
		}
		// 判断子预控预控方式是否和主预控一致
		List<ResPrecontrolPolicyItem> policyItemList = resPrecontrolPolicyItemService
				.selectByPolicyId(resPrecontrolPolicy.getId());
		if (null != policyItemList && policyItemList.size() > 0) {
			if (!resPrecontrolPolicy.getControlType().equalsIgnoreCase(policyItemList.get(0).getItemControlType())) {
				sb.append("0, \"msg\":\"子预控类型与主预控不一致，如需继续操作 请先删除子预控!\"}");
				return sb.toString();
			}
		}

		// ==========================获取历史提醒设置
		// start============================================
		// 查询规则关系表
		List<ResPrecontrolWarmOption> resPrecontrolWarmOptionList = resPrecontrolWarmOptionService
				.findListByResPrecontrolPolicyId(resPrecontrolPolicy.getId());
		// 查找提醒规则表
		List<ResWarmRule> resWarmRuleList = new ArrayList<ResWarmRule>();
		for (ResPrecontrolWarmOption resPrecontrolWarmOption : resPrecontrolWarmOptionList) {
			ResWarmRule resWarmRule = resWarmRuleService.findResWarmRuleById(resPrecontrolWarmOption.getWarmRuleId());
			resWarmRuleList.add(resWarmRule);
		}
		// 规则去重
		Map<Long, ResWarmRule> map = new HashMap<Long, ResWarmRule>();
		for (ResWarmRule resWarmRule : resWarmRuleList) {
			map.put(resWarmRule.getId(), resWarmRule);
		}
		List<ResWarmRule> resWarmRuleRealList = new ArrayList<ResWarmRule>();
		for (Map.Entry<Long, ResWarmRule> entry : map.entrySet()) {
			resWarmRuleRealList.add(entry.getValue());
		}
		StringBuffer oldName = new StringBuffer();
		Set<String> resWarmRuleRealSet = new TreeSet<String>();
		if (CollectionUtils.isNotEmpty(resWarmRuleRealList)) {
			for (int i = 0; i < resWarmRuleRealList.size(); i++) {
				ResWarmRule resWarmRule = resWarmRuleRealList.get(i);
				String name = resWarmRule.getName();
				resWarmRuleRealSet.add(name);
				String cnName = ResWarmRule.RULE_NAME.getCnName(name);
				if (i > 0) {
					oldName.append(",");
				}
				oldName.append(cnName);
			}
		}

		boolean isResWarmRule = false;
		// 新抄送其他人
		String[] codeNew = null;
		if (StringUtils.isNotBlank(code)) {
			codeNew = code.split(",");
		}
		if (resWarmRuleRealSet.size() != codeNew.length) {
			isResWarmRule = true;
		}
		if (codeNew != null) {
			for (int i = 0; i < codeNew.length; i++) {
				if (!resWarmRuleRealSet.contains(codeNew[i])) {
					isResWarmRule = true;
					break;
				}
			}
		}

		// ==========================获取历史提醒设置
		// end============================================

		// ==========================获取历史抄送其他人
		// start============================================
		// 通过资源策略id查询所有的抄送人
		List<ResPrecontrolWarmReceiver> resPrecontrolWarmReceiverList = resPrecontrolWarmReceiverService
				.findListByResPrecontrolPolicyId(resPrecontrolPolicy.getId());
		StringBuffer oldReceiverName = new StringBuffer();
		Set<String> listReceiver = new TreeSet<String>();
		if (CollectionUtils.isNotEmpty(resPrecontrolWarmReceiverList)) {
			for (ResPrecontrolWarmReceiver receiver : resPrecontrolWarmReceiverList) {
				if (null != receiver && !receiver.getReceiverId().equals(resPrecontrolPolicy.getProductManagerId())) {
					listReceiver.add(receiver.getReceiverName());
				}
			}
			if (CollectionUtils.isNotEmpty(listReceiver)) {
				int k = 0;
				for (Iterator<String> iterator = listReceiver.iterator(); iterator.hasNext();) {
					String string = iterator.next();
					if (k > 0) {
						oldReceiverName.append(",");
					}
					k++;
					oldReceiverName.append(string);
				}
			}
		}
		boolean isReceiverName = false;
		// 新抄送其他人
		String[] resPrecontrolWarmReceiverNamesNew = null;
		if (StringUtils.isNotBlank(resPrecontrolWarmReceiver.getReceiverName())) {
			resPrecontrolWarmReceiverNamesNew = resPrecontrolWarmReceiver.getReceiverName().split(",");
			int len = 0;
			if (null != resPrecontrolWarmReceiverNamesNew) {
				len = resPrecontrolWarmReceiverNamesNew.length;
			}
			if (listReceiver.size() != len) {
				isReceiverName = true;
			}
			if (resPrecontrolWarmReceiverNamesNew != null) {
				for (int i = 0; i < resPrecontrolWarmReceiverNamesNew.length; i++) {
					if (!listReceiver.contains(resPrecontrolWarmReceiverNamesNew[i])) {
						isReceiverName = true;
						break;
					}
				}
			}
		}

		// ==========================获取历史抄送其他人
		// end============================================

		// 获取子预控总和
		Long sumItemAmount = resPrecontrolPolicyItemService.getSumAmountByPolicyId(resPrecontrolPolicy.getId());
		// delete policy
		ResPrecontrolPolicy res = resPrecontrolPolicyService.findResPrecontrolPolicyById(resPrecontrolPolicy.getId());
		// 校验名字是否已经存在
		ResPrecontrolPolicy resPrecontrolPolicyFirst1 = resPrecontrolPolicyService
				.findByName(resPrecontrolPolicy.getName());
		if (resPrecontrolPolicyFirst1 != null && !resPrecontrolPolicyFirst1.getId().equals(res.getId())) {
			sb.append("0, \"msg\":\"此名称资源预控已经存在!\"}");
			return sb.toString();
		}
		// 修改原来的删除原预控 为 更新原预控
		resPrecontrolPolicy.setState(ResControlEnum.CONTROL_STATE.New.toString());
		resPrecontrolPolicy.setIsDeleted((short) 0);
		if (resPrecontrolPolicy.getControlType()
				.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
			resPrecontrolPolicy.setAmount(mulNumber(resPrecontrolPolicy.getAmount()));
		}
		// 设置原始金额
		Long originAmount = resPrecontrolPolicy.getAmount();
		resPrecontrolPolicy.setOriginAmount(originAmount);
		// 预控金额加上子预控
		resPrecontrolPolicy.setAmount(originAmount + sumItemAmount);
		// 默认超卖为N
		resPrecontrolPolicy.setIsCanDelay("N");
		// 金额转换
		resPrecontrolPolicy.setBuyoutTotalCost(PriceUtil.convertToFen(resPrecontrolPolicy.getBuyoutTotalCostStr()));
		resPrecontrolPolicy.setForecastSales(PriceUtil.convertToFen(resPrecontrolPolicy.getForecastSalesStr()));
		resPrecontrolPolicy.setDepositAmount(PriceUtil.convertToFen(resPrecontrolPolicy.getDepositAmountStr()));
		resPrecontrolPolicy.setNameAmount(PriceUtil.convertToFen(resPrecontrolPolicy.getNameAmountStr()));
		// 更新主预控
		resPrecontrolPolicyService.updatePolicyByPrimaryKey(resPrecontrolPolicy);
		// Long id =
		// resPrecontrolPolicyService.save(resPrecontrolPolicy);
		Long id = resPrecontrolPolicy.getId();
		// int rr =
		// resPrecontrolPolicyService.deleteResPrecontrolPolicyById(
		// resPrecontrolPolicy.getId() );
		// LOG.info("删除了:" + rr + ", id: " +
		// resPrecontrolPolicy.getId());
		// delete amount
		if (resPrecontrolPolicy.getControlType()
				.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
			resPrecontrolAmountService.deleteByPolicyId(resPrecontrolPolicy.getId());
		} else {
			resPrecontrolInventoryService.deleteByPolicyId(resPrecontrolPolicy.getId());
		}
		// delete warm receiver
		resPrecontrolWarmReceiverService.deteteResPrecontrolWarmReceiver(resPrecontrolPolicy.getId());
		// delete warm rule
		resPrecontrolWarmOptionService.deleteResPrecontrolWarmOption(resPrecontrolPolicy.getId());
		// delete rule receiver relations ??
		// resRuleReceiverRelationSerive.deleteResRuleReceiverRelationByWarmRuleIds(1);
		/*
		 * System.out.println(resPrecontrolPolicy. getControlClassification());
		 * System.out.println(resPrecontrolPolicy. getControlType());
		 * System.out.println(ids);
		 */
		// return
		// this.addResourceControl(resPrecontrolPolicy,
		// resPrecontrolWarmReceiver, code, value, ids,
		// ProductManagerEmail);
		String[] codes = code.split(",");
		// 得到供应商
		/**
		 * 产品经理
		 */
		// // 供应商的id和产品经理的id自动填回页面
		// resPrecontrolPolicy.setState(ResControlEnum.CONTROL_STATE.New.toString());
		// resPrecontrolPolicy.setIsDeleted( (short) 0 );
		// if
		// (resPrecontrolPolicy.getControlType().equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name()))
		// {
		// resPrecontrolPolicy.setAmount(mulNumber(resPrecontrolPolicy.getAmount()));
		// }
		// //设置原始金额
		// Long
		// originAmount=resPrecontrolPolicy.getAmount();
		// resPrecontrolPolicy.setOriginAmount(originAmount);
		// //预控金额加上子预控
		// resPrecontrolPolicy.setAmount(originAmount +
		// sumItemAmount);
		// //默认超卖为N
		// resPrecontrolPolicy.setIsCanDelay("N");
		// //金额转换
		// resPrecontrolPolicy.setBuyoutTotalCost(PriceUtil.convertToFen(resPrecontrolPolicy.getBuyoutTotalCostStr()));
		// resPrecontrolPolicy.setForecastSales(PriceUtil.convertToFen(resPrecontrolPolicy.getForecastSalesStr()));
		// resPrecontrolPolicy.setDepositAmount(PriceUtil.convertToFen(resPrecontrolPolicy.getDepositAmountStr()));
		// resPrecontrolPolicy.setNameAmount(PriceUtil.convertToFen(resPrecontrolPolicy.getNameAmountStr()));
		// Long id =
		// resPrecontrolPolicyService.save(resPrecontrolPolicy);
		// //更新子预控表中的主预控ID
		// Long
		// oldPolicyID=resPrecontrolPolicyFirst.getId();
		// if(null!=policyItemList &&
		// policyItemList.size()>0){
		// resPrecontrolPolicyItemService.updatePolicyIdByPolicyId(id,
		// oldPolicyID);
		// }
		// //更新付款流水中的主预控ID
		// List<ResPrecontrolPayment> paymentList =
		// resPrecontrolPaymentService.selectByPolicyId(oldPolicyID);
		// if(null!=paymentList && paymentList.size()>0){
		// resPrecontrolPaymentService.updatePolicyIdByPolicyId(id,oldPolicyID);
		// }
		// 保存按金额
		int days = DateUtil.getDaysBetween(resPrecontrolPolicy.getTradeEffectDate(),
				resPrecontrolPolicy.getTradeExpiryDate()) + 1;
		if (resPrecontrolPolicy.getControlType()
				.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
			ResPrecontrolAmount resPrecontrolAmount = new ResPrecontrolAmount();
			// 按周期
			if (resPrecontrolPolicy.getControlClassification()
					.equalsIgnoreCase(ResControlEnum.CONTROL_CLASSIFICATION.Cycle.name())) {
				resPrecontrolAmount.setPrecontrolPolicyId(id);
				resPrecontrolAmount.setQuantity(resPrecontrolPolicy.getAmount());
				resPrecontrolAmount.setEffectDate(resPrecontrolPolicy.getTradeEffectDate());
				resPrecontrolAmount.setExpiryDate(resPrecontrolPolicy.getTradeExpiryDate());
				resPrecontrolAmountService.save(resPrecontrolAmount);
			} else {
				// 按日
				List<ResPrecontrolAmount> list = new ArrayList<ResPrecontrolAmount>();
				for (int i = 0; i < days; i++) {
					ResPrecontrolAmount resPrecontrolAmountA = new ResPrecontrolAmount();
					resPrecontrolAmountA.setPrecontrolPolicyId(id);
					resPrecontrolAmountA.setQuantity(resPrecontrolPolicy.getAmount());
					resPrecontrolAmountA
							.setEffectDate(DateUtil.dsDay_Date(resPrecontrolPolicy.getTradeEffectDate(), i));
					resPrecontrolAmountA
							.setExpiryDate(DateUtil.dsDay_Date(resPrecontrolPolicy.getTradeEffectDate(), i));
					list.add(resPrecontrolAmountA);
				}
				if (list.size() > 0)
					resPrecontrolAmountService.batchInsert(list);
			}
		} else {
			// 保存按库存
			// 按周期
			ResPrecontrolInventory resPrecontrolInventory = new ResPrecontrolInventory();
			if (resPrecontrolPolicy.getControlClassification()
					.equalsIgnoreCase(ResControlEnum.CONTROL_CLASSIFICATION.Cycle.name())) {
				resPrecontrolInventory.setPrecontrolPolicyId(id);
				resPrecontrolInventory.setQuantity(resPrecontrolPolicy.getAmount());
				resPrecontrolInventory.setEffectDate(resPrecontrolPolicy.getTradeEffectDate());
				resPrecontrolInventory.setExpiryDate(resPrecontrolPolicy.getTradeExpiryDate());
				resPrecontrolInventoryService.save(resPrecontrolInventory);
			} else {
				// 按日保存一天插入一条数据
				List<ResPrecontrolInventory> list = new ArrayList<ResPrecontrolInventory>();
				for (int i = 0; i < days; i++) {
					ResPrecontrolInventory resPrecontrolInventoryB = new ResPrecontrolInventory();
					resPrecontrolInventoryB.setPrecontrolPolicyId(id);
					resPrecontrolInventoryB.setQuantity(resPrecontrolPolicy.getAmount());
					Date dateStatic = DateUtil.dsDay_Date(resPrecontrolPolicy.getTradeEffectDate(), i);
					resPrecontrolInventoryB.setEffectDate(dateStatic);
					resPrecontrolInventoryB.setExpiryDate(dateStatic);
					list.add(resPrecontrolInventoryB);
				}
				if (list.size() > 0)
					resPrecontrolInventoryService.batchInsert(list);
			}
		}
		// 保存产品经理的提醒人
		ResPrecontrolWarmReceiver resPrecontrolWarmReceiverManger = new ResPrecontrolWarmReceiver();
		resPrecontrolWarmReceiverManger.setPrecontrolPolicyId(id);
		resPrecontrolWarmReceiverManger.setReceiverId(resPrecontrolPolicy.getProductManagerId());
		resPrecontrolWarmReceiverManger.setReceiverName(resPrecontrolPolicy.getProductManagerName());
		resPrecontrolWarmReceiverManger.setEmail(ProductManagerEmail);
		Long resPrecontrolWarmReceiverRealMangerId = resPrecontrolWarmReceiverService
				.save(resPrecontrolWarmReceiverManger);
		// 保存code规则的list
		List<Long> list = new ArrayList<Long>();
		for (String string : codes) {
			ResWarmRule resWarmRule = new ResWarmRule();
			if (string.equals("loss")) {
				resWarmRule.setValue(value);
			}
			resWarmRule.setName(string);
			Long resWarmRuleId = resWarmRuleService.save(resWarmRule);
			list.add(resWarmRuleId);
		}
		Long[] resPrecontrolWarmOptionIds = new Long[list.size()];
		List<ResRuleReceiverRelation> listRelation = new ArrayList<ResRuleReceiverRelation>();
		int x = 0;
		for (Long resWarmRuleId : list) {
			ResPrecontrolWarmOption resPrecontrolWarmOption = new ResPrecontrolWarmOption();
			resPrecontrolWarmOption.setPrecontrolPolicyId(id);
			resPrecontrolWarmOption.setControlClassification(resPrecontrolPolicy.getControlClassification());
			resPrecontrolWarmOption.setWarmRuleId(resWarmRuleId);
			Long resPrecontrolWarmOptionId = resPrecontrolWarmOptionService.save(resPrecontrolWarmOption);
			resPrecontrolWarmOptionIds[x++] = resPrecontrolWarmOptionId;
			for (Long resWarmRuleIds : list) {
				ResRuleReceiverRelation resRuleReceiverRelation = new ResRuleReceiverRelation();
				resRuleReceiverRelation.setPrecontrolWarmOptionId(resPrecontrolWarmOptionId);
				resRuleReceiverRelation.setWarmRuleId(resWarmRuleIds);
				resRuleReceiverRelation.setWarmReceiverId(resPrecontrolWarmReceiverRealMangerId);
				listRelation.add(resRuleReceiverRelation);
			}
		}
		int bathNum = resRuleReceiverRelationSerive.batchInsert(listRelation);
		// 判断抄送人是否为空
		if (ids != null && !ids.isEmpty()) {
			// 保存提醒人
			String[] resPrecontrolWarmReceiverIds = ids.split(",");
			String[] resPrecontrolWarmReceiverNames = resPrecontrolWarmReceiver.getReceiverName().split(",");
			String[] resPrecontrolWarmReceiverEmails = resPrecontrolWarmReceiver.getEmail().split(",");
			int length = resPrecontrolWarmReceiverIds.length;
			Long[] resPrecontrolWarmReceiverRealIds = new Long[length];
			for (int i = 0; i < length; i++) {
				ResPrecontrolWarmReceiver precontrolWarmReceiver = new ResPrecontrolWarmReceiver();
				precontrolWarmReceiver.setPrecontrolPolicyId(id);
				precontrolWarmReceiver.setReceiverId(((Long.parseLong(resPrecontrolWarmReceiverIds[i]))));
				precontrolWarmReceiver.setReceiverName(resPrecontrolWarmReceiverNames[i]);
				precontrolWarmReceiver.setEmail(resPrecontrolWarmReceiverEmails[i]);
				Long resPrecontrolWarmReceiverRealId = resPrecontrolWarmReceiverService.save(precontrolWarmReceiver);
				resPrecontrolWarmReceiverRealIds[i] = resPrecontrolWarmReceiverRealId;
			}
			List<ResRuleReceiverRelation> listsRelation = new ArrayList<ResRuleReceiverRelation>();
			// 保存买断资源预控提醒设置
			for (int y = 0; y < list.size(); y++) {
				for (int i = 0; i < length; i++) {
					for (Long resWarmRuleIds : list) {
						ResRuleReceiverRelation resRuleReceiverRelation = new ResRuleReceiverRelation();
						resRuleReceiverRelation.setPrecontrolWarmOptionId(resPrecontrolWarmOptionIds[y]);
						resRuleReceiverRelation.setWarmRuleId(resWarmRuleIds);
						resRuleReceiverRelation.setWarmReceiverId(resPrecontrolWarmReceiverRealIds[i]);
						listsRelation.add(resRuleReceiverRelation);
					}
				}
			}
			int bathsNum = resRuleReceiverRelationSerive.batchInsert(listsRelation);
		}
		sb.append("1, \"msg\":\"保存成功!\"");
		sb.append("}");
		try {
			// 保存操作日志
			String logContent = "";
			if (!res.getName().equals(resPrecontrolPolicy.getName())) {
				logContent = logContent + "预控名称：【（原值）" + res.getName() + "  修改为：（现值）" + resPrecontrolPolicy.getName()
						+ "】";
			}
			if (!res.getSupplierName().equals(resPrecontrolPolicy.getSupplierName())) {
				logContent = logContent + "】供应商ID：【（原值）" + res.getSupplierId() + "  修改为：（现值）"
						+ resPrecontrolPolicy.getSupplierId() + "】供应商名称：【（原值）" + res.getSupplierName() + "  修改为：（现值）"
						+ resPrecontrolPolicy.getSupplierName() + "】";
			}
			if (!res.getControlType().equals(resPrecontrolPolicy.getControlType())) {
				String controlType = "amount".equalsIgnoreCase(res.getControlType()) ? "预控金额" : "预控库存";
				String controlType1 = "amount".equalsIgnoreCase(resPrecontrolPolicy.getControlType()) ? "预控金额" : "预控库存";
				Long amount, amount1;
				if ("amount".equalsIgnoreCase(resPrecontrolPolicy.getControlType())) {
					amount = divNumber(resPrecontrolPolicy.getOriginAmount());
				} else {
					amount = resPrecontrolPolicy.getOriginAmount();
				}
				if ("amount".equalsIgnoreCase(res.getControlType())) {
					amount1 = divNumber(res.getOriginAmount());
				} else {
					amount1 = res.getOriginAmount();
				}
				logContent = logContent + "】预控方式：【（原值）" + controlType + "=" + amount1 + "  修改为：（现值）" + controlType1
						+ "=" + amount + "】";
			} else if (!res.getOriginAmount().equals(resPrecontrolPolicy.getOriginAmount())) {
				String controlType1 = "amount".equalsIgnoreCase(resPrecontrolPolicy.getControlType()) ? "预控金额" : "预控库存";
				Long amount, amount1;
				if ("amount".equalsIgnoreCase(resPrecontrolPolicy.getControlType())) {
					amount1 = divNumber(res.getOriginAmount());
					amount = divNumber(resPrecontrolPolicy.getOriginAmount());
				} else {
					amount1 = res.getOriginAmount();
					amount = resPrecontrolPolicy.getOriginAmount();
				}
				logContent = logContent + "】" + controlType1 + "：【（原值）" + amount1 + " 修改为：（现值）" + amount + "】";
			}
			if (!res.getSaleEffectDate().equals(resPrecontrolPolicy.getSaleEffectDate())
					|| !res.getSaleExpiryDate().equals(resPrecontrolPolicy.getSaleExpiryDate())) {
				logContent = logContent + "】销售起止日期：【（原值）"
						+ new SimpleDateFormat("yyyy-MM-dd").format(res.getSaleEffectDate()) + " -> "
						+ new SimpleDateFormat("yyyy-MM-dd").format(res.getSaleExpiryDate()) + "  修改为：（现值）"
						+ new SimpleDateFormat("yyyy-MM-dd").format(resPrecontrolPolicy.getSaleEffectDate()) + " ->"
						+ new SimpleDateFormat("yyyy-MM-dd").format(resPrecontrolPolicy.getSaleExpiryDate()) + "】";
			}
			if (!res.getTradeEffectDate().equals(resPrecontrolPolicy.getTradeEffectDate())
					|| !res.getTradeExpiryDate().equals(resPrecontrolPolicy.getTradeExpiryDate())) {
				logContent = logContent + "】游玩起止日期：【（原值）"
						+ new SimpleDateFormat("yyyy-MM-dd").format(res.getTradeEffectDate()) + " ->"
						+ new SimpleDateFormat("yyyy-MM-dd").format(res.getTradeExpiryDate()) + "  修改为：（现值）"
						+ new SimpleDateFormat("yyyy-MM-dd").format(resPrecontrolPolicy.getTradeEffectDate()) + " ->"
						+ new SimpleDateFormat("yyyy-MM-dd").format(resPrecontrolPolicy.getTradeExpiryDate()) + "】";
			}
			if (!res.getControlClassification().equals(resPrecontrolPolicy.getControlClassification())) {
				String getControlClassification1 = "Daily"
						.equalsIgnoreCase(resPrecontrolPolicy.getControlClassification()) ? "按日期预控" : "按周期预控";
				String getControlClassification = "Daily".equalsIgnoreCase(res.getControlClassification()) ? "按日期预控"
						: "按周期预控";
				logContent = logContent + "】预控类型：【（原值）" + getControlClassification + " 修改为：（现值）"
						+ getControlClassification1 + "】";
			}
			if (!res.getIsCanReturn().equals(resPrecontrolPolicy.getIsCanReturn())) {
				logContent = logContent + "】能否退还：【（原值）" + res.getIsCanReturn() + " 修改为：（现值）"
						+ resPrecontrolPolicy.getIsCanReturn() + "】";
			}
			if (!res.getIsCanDelay().equals(resPrecontrolPolicy.getIsCanDelay())) {
				logContent = logContent + "】能否延期：【（原值）" + res.getIsCanDelay() + " 修改为：（现值）"
						+ resPrecontrolPolicy.getIsCanDelay() + "】";
			}
			if (!res.getProductManagerName().equals(resPrecontrolPolicy.getProductManagerName())) {
				logContent = logContent + "】产品经理：【（原值）" + res.getProductManagerName() + " 修改为：（现值）"
						+ resPrecontrolPolicy.getProductManagerName() + "】";
			}

			if (null != res.getProjectNature()
					&& !res.getProjectNature().equals(resPrecontrolPolicy.getProjectNature())) {
				logContent = logContent + "项目性质：【（原值）" + res.getProjectNatureCnName() + "  修改为：（现值）"
						+ resPrecontrolPolicy.getProjectNatureCnName() + "】";
			}
			if (null != res.getBuCode() && !res.getBuCode().equals(resPrecontrolPolicy.getBuCode())) {
				logContent = logContent + "所属BU：【（原值）" + res.getBuCnName() + "  修改为：（现值）"
						+ resPrecontrolPolicy.getBuCnName() + "】";
			}
			if (null != res.getArea1() && !res.getArea1().equals(resPrecontrolPolicy.getArea1())) {
				logContent = logContent + "一级大区：【（原值）" + res.getArea1CnName() + "  修改为：（现值）"
						+ resPrecontrolPolicy.getArea1CnName() + "】";
			}
			if (null != res.getArea2() && !res.getArea2().equals(resPrecontrolPolicy.getArea2())) {
				logContent = logContent + "二级大区：【（原值）" + res.getArea2CnName() + "  修改为：（现值）"
						+ resPrecontrolPolicy.getArea2CnName() + "】";
			}
			if (null != res.getPayWay() && !res.getPayWay().equals(resPrecontrolPolicy.getPayWay())) {
				logContent = logContent + "付款方式：【（原值）" + res.getPayWayCnName() + "  修改为：（现值）"
						+ resPrecontrolPolicy.getPayWayCnName() + "】";
			}
			if (null != res.getBuyoutTotalCost()
					&& !res.getBuyoutTotalCost().equals(resPrecontrolPolicy.getBuyoutTotalCost())) {
				logContent = logContent + "买断总成本：【（原值）" + res.getBuyoutTotalCost() + "  修改为：（现值）"
						+ resPrecontrolPolicy.getBuyoutTotalCost() + "】";
			}
			if (null != res.getForecastSales()
					&& !res.getForecastSales().equals(resPrecontrolPolicy.getForecastSales())) {
				logContent = logContent + "预估营业额：【（原值）" + res.getForecastSales() + "  修改为：（现值）"
						+ resPrecontrolPolicy.getForecastSales() + "】";
			}
			if (null != res.getDepositAmount()
					&& !res.getDepositAmount().equals(resPrecontrolPolicy.getDepositAmount())) {
				logContent = logContent + "押金：【（原值）" + res.getDepositAmount() + "  修改为：（现值）"
						+ resPrecontrolPolicy.getDepositAmount() + "】";
			}
			if (null != res.getNameAmount() && !res.getNameAmount().equals(resPrecontrolPolicy.getNameAmount())) {
				logContent = logContent + "冠名金额：【（原值）" + res.getNameAmount() + "  修改为：（现值）"
						+ resPrecontrolPolicy.getNameAmount() + "】";
			}
			if (null != res.getPayMemo() && !res.getPayMemo().equals(resPrecontrolPolicy.getPayMemo())) {
				logContent = logContent + "付款备注：【（原值）" + res.getPayMemo() + "  修改为：（现值）"
						+ resPrecontrolPolicy.getPayMemo() + "】";
			}
			if (null != res.getMemo() && !res.getMemo().equals(resPrecontrolPolicy.getMemo())) {
				logContent = logContent + "备注：【（原值）" + res.getMemo() + "  修改为：（现值）" + resPrecontrolPolicy.getMemo()
						+ "】";
			}

			StringBuffer newRuleName = new StringBuffer();
			if (codes != null && codes.length > 0) {
				for (int i = 0; i < codes.length; i++) {
					String str = codes[i];
					if (i > 0) {
						newRuleName.append(",");
					}
					newRuleName.append(ResWarmRule.RULE_NAME.getCnName(str));
				}
			}
			if (isResWarmRule) {
				logContent = logContent + "提醒设置：【（原值）" + oldName + "  修改为：（现值）" + newRuleName.toString() + "】";
			}

			if (isReceiverName) {
				logContent = logContent + "抄送其他人：【（原值）" + oldReceiverName.toString() + "  修改为：（现值）"
						+ resPrecontrolWarmReceiver.getReceiverName() + "】";
			}

			if (StringUtils.isNotEmpty(logContent)) {
				comLogService.insert(COM_LOG_OBJECT_TYPE.RES_PRECONTROL_POLICY_POLICY, id, id,
						this.getLoginUser().getUserName(), logContent,
						COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name(), "修改新增资源预控" + resPrecontrolPolicy.getId(),
						null);
			}

		} catch (Exception e) {
			log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name());
			log.error(e.getMessage());
		}
		// 保存成功
		// return ResultMessage.SUCCESS;
		return sb.toString();
	}

	/**
	 * 设置资源预控策略
	 *
	 * @param resPrecontrolPolicy
	 * @param resPrecontrolWarmReceiver
	 * @param code
	 * @param value
	 * @param ids
	 * @param ProductManagerEmail
	 * @return
	 */
	@RequestMapping(value = "/addResourceControl")
	@ResponseBody
	public Object addResourceControl(ResPrecontrolPolicy resPrecontrolPolicy,
			ResPrecontrolWarmReceiver resPrecontrolWarmReceiver, String code, String value, String ids,
			String ProductManagerEmail) {
		// 保存前先判断项目名称是否为空
		ResPrecontrolPolicy resPrecontrolPolicyFirst = resPrecontrolPolicyService
				.findByName(resPrecontrolPolicy.getName());
		if (resPrecontrolPolicyFirst != null) {
			return ResultMessage.ERROR;
		}
		String[] codes = code.split(",");
		// 得到供应商
		/**
		 * 产品经理
		 */
		// 供应商的id和产品经理的id自动填回页面
		resPrecontrolPolicy.setState(ResControlEnum.CONTROL_STATE.New.toString());
		resPrecontrolPolicy.setIsDeleted((short) 0);
		if (resPrecontrolPolicy.getControlType()
				.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
			resPrecontrolPolicy.setAmount(mulNumber(resPrecontrolPolicy.getAmount()));
		}
		// 设置原始金额
		resPrecontrolPolicy.setOriginAmount(resPrecontrolPolicy.getAmount());
		// 默认超卖为N
		resPrecontrolPolicy.setIsCanDelay("N");
		// 金额转换
		resPrecontrolPolicy.setBuyoutTotalCost(PriceUtil.convertToFen(resPrecontrolPolicy.getBuyoutTotalCostStr()));
		resPrecontrolPolicy.setForecastSales(PriceUtil.convertToFen(resPrecontrolPolicy.getForecastSalesStr()));
		resPrecontrolPolicy.setDepositAmount(PriceUtil.convertToFen(resPrecontrolPolicy.getDepositAmountStr()));
		resPrecontrolPolicy.setNameAmount(PriceUtil.convertToFen(resPrecontrolPolicy.getNameAmountStr()));
		Long id = resPrecontrolPolicyService.save(resPrecontrolPolicy);
		// 保存按金额
		int days = DateUtil.getDaysBetween(resPrecontrolPolicy.getTradeEffectDate(),
				resPrecontrolPolicy.getTradeExpiryDate()) + 1;
		if (resPrecontrolPolicy.getControlType()
				.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
			ResPrecontrolAmount resPrecontrolAmount = new ResPrecontrolAmount();
			// 按周期
			if (resPrecontrolPolicy.getControlClassification()
					.equalsIgnoreCase(ResControlEnum.CONTROL_CLASSIFICATION.Cycle.name())) {
				resPrecontrolAmount.setPrecontrolPolicyId(id);
				resPrecontrolAmount.setQuantity(resPrecontrolPolicy.getAmount());
				resPrecontrolAmount.setEffectDate(resPrecontrolPolicy.getTradeEffectDate());
				resPrecontrolAmount.setExpiryDate(resPrecontrolPolicy.getTradeExpiryDate());
				resPrecontrolAmountService.save(resPrecontrolAmount);
			} else {
				// 按日
				List<ResPrecontrolAmount> list = new ArrayList<ResPrecontrolAmount>();
				for (int i = 0; i < days; i++) {
					ResPrecontrolAmount resPrecontrolAmountA = new ResPrecontrolAmount();
					resPrecontrolAmountA.setPrecontrolPolicyId(id);
					resPrecontrolAmountA.setQuantity(resPrecontrolPolicy.getAmount());
					resPrecontrolAmountA
							.setEffectDate(DateUtil.dsDay_Date(resPrecontrolPolicy.getTradeEffectDate(), i));
					resPrecontrolAmountA
							.setExpiryDate(DateUtil.dsDay_Date(resPrecontrolPolicy.getTradeEffectDate(), i));
					list.add(resPrecontrolAmountA);
				}
				resPrecontrolAmountService.batchInsert(list);
			}
		} else {
			// 保存按库存
			// 按周期
			ResPrecontrolInventory resPrecontrolInventory = new ResPrecontrolInventory();
			if (resPrecontrolPolicy.getControlClassification()
					.equalsIgnoreCase(ResControlEnum.CONTROL_CLASSIFICATION.Cycle.name())) {
				resPrecontrolInventory.setPrecontrolPolicyId(id);
				resPrecontrolInventory.setQuantity(resPrecontrolPolicy.getAmount());
				resPrecontrolInventory.setEffectDate(resPrecontrolPolicy.getTradeEffectDate());
				resPrecontrolInventory.setExpiryDate(resPrecontrolPolicy.getTradeExpiryDate());
				resPrecontrolInventoryService.save(resPrecontrolInventory);
			} else {
				// 按日保存一天插入一条数据
				List<ResPrecontrolInventory> list = new ArrayList<ResPrecontrolInventory>();
				for (int i = 0; i < days; i++) {
					ResPrecontrolInventory resPrecontrolInventoryB = new ResPrecontrolInventory();
					resPrecontrolInventoryB.setPrecontrolPolicyId(id);
					resPrecontrolInventoryB.setQuantity(resPrecontrolPolicy.getAmount());
					Date dateStatic = DateUtil.dsDay_Date(resPrecontrolPolicy.getTradeEffectDate(), i);
					resPrecontrolInventoryB.setEffectDate(dateStatic);
					resPrecontrolInventoryB.setExpiryDate(dateStatic);
					list.add(resPrecontrolInventoryB);
				}
				resPrecontrolInventoryService.batchInsert(list);
			}
		}
		// 保存产品经理的提醒人
		ResPrecontrolWarmReceiver resPrecontrolWarmReceiverManger = new ResPrecontrolWarmReceiver();
		resPrecontrolWarmReceiverManger.setPrecontrolPolicyId(id);
		resPrecontrolWarmReceiverManger.setReceiverId(resPrecontrolPolicy.getProductManagerId());
		resPrecontrolWarmReceiverManger.setReceiverName(resPrecontrolPolicy.getProductManagerName());
		resPrecontrolWarmReceiverManger.setEmail(ProductManagerEmail);
		Long resPrecontrolWarmReceiverRealMangerId = resPrecontrolWarmReceiverService
				.save(resPrecontrolWarmReceiverManger);
		// 保存code规则的list
		List<Long> list = new ArrayList<Long>();
		for (String string : codes) {
			ResWarmRule resWarmRule = new ResWarmRule();
			if (string.equals("loss")) {
				resWarmRule.setValue(value);
			}
			resWarmRule.setName(string);
			Long resWarmRuleId = resWarmRuleService.save(resWarmRule);
			list.add(resWarmRuleId);
		}
		Long[] resPrecontrolWarmOptionIds = new Long[list.size()];
		List<ResRuleReceiverRelation> listRelation = new ArrayList<ResRuleReceiverRelation>();
		int x = 0;
		for (Long resWarmRuleId : list) {
			ResPrecontrolWarmOption resPrecontrolWarmOption = new ResPrecontrolWarmOption();
			resPrecontrolWarmOption.setPrecontrolPolicyId(id);
			resPrecontrolWarmOption.setControlClassification(resPrecontrolPolicy.getControlClassification());
			resPrecontrolWarmOption.setWarmRuleId(resWarmRuleId);
			Long resPrecontrolWarmOptionId = resPrecontrolWarmOptionService.save(resPrecontrolWarmOption);
			resPrecontrolWarmOptionIds[x++] = resPrecontrolWarmOptionId;
			for (Long resWarmRuleIds : list) {
				ResRuleReceiverRelation resRuleReceiverRelation = new ResRuleReceiverRelation();
				resRuleReceiverRelation.setPrecontrolWarmOptionId(resPrecontrolWarmOptionId);
				resRuleReceiverRelation.setWarmRuleId(resWarmRuleIds);
				resRuleReceiverRelation.setWarmReceiverId(resPrecontrolWarmReceiverRealMangerId);
				listRelation.add(resRuleReceiverRelation);
			}
		}
		int bathNum = resRuleReceiverRelationSerive.batchInsert(listRelation);
		// 判断抄送人是否为空
		if (!ids.isEmpty()) {
			// 保存提醒人
			String[] resPrecontrolWarmReceiverIds = ids.split(",");
			String[] resPrecontrolWarmReceiverNames = resPrecontrolWarmReceiver.getReceiverName().split(",");
			String[] resPrecontrolWarmReceiverEmails = resPrecontrolWarmReceiver.getEmail().split(",");
			int length = resPrecontrolWarmReceiverIds.length;
			Long[] resPrecontrolWarmReceiverRealIds = new Long[length];
			for (int i = 0; i < length; i++) {
				ResPrecontrolWarmReceiver precontrolWarmReceiver = new ResPrecontrolWarmReceiver();
				precontrolWarmReceiver.setPrecontrolPolicyId(id);
				precontrolWarmReceiver.setReceiverId(((Long.parseLong(resPrecontrolWarmReceiverIds[i]))));
				precontrolWarmReceiver.setReceiverName(resPrecontrolWarmReceiverNames[i]);
				precontrolWarmReceiver.setEmail(resPrecontrolWarmReceiverEmails[i]);
				Long resPrecontrolWarmReceiverRealId = resPrecontrolWarmReceiverService.save(precontrolWarmReceiver);
				resPrecontrolWarmReceiverRealIds[i] = resPrecontrolWarmReceiverRealId;
			}
			List<ResRuleReceiverRelation> listsRelation = new ArrayList<ResRuleReceiverRelation>();
			// 保存买断资源预控提醒设置
			for (int y = 0; y < list.size(); y++) {
				for (int i = 0; i < length; i++) {
					for (Long resWarmRuleIds : list) {
						ResRuleReceiverRelation resRuleReceiverRelation = new ResRuleReceiverRelation();
						resRuleReceiverRelation.setPrecontrolWarmOptionId(resPrecontrolWarmOptionIds[y]);
						resRuleReceiverRelation.setWarmRuleId(resWarmRuleIds);
						resRuleReceiverRelation.setWarmReceiverId(resPrecontrolWarmReceiverRealIds[i]);
						listsRelation.add(resRuleReceiverRelation);
					}
				}
			}
			int bathsNum = resRuleReceiverRelationSerive.batchInsert(listsRelation);
		}
		try {
			// 保存操作日志
			comLogService.insert(COM_LOG_OBJECT_TYPE.RES_PRECONTROL_POLICY_POLICY, id, id,
					this.getLoginUser().getUserName(), "新增资源策略ID" + id,
					COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name(), "新增资源预控", null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name());
			log.error(e.getMessage());
		}
		// 保存成功
		return ResultMessage.SUCCESS;
	}

	/**
	 * 实现预控策略的更新
	 *
	 * @param resPrecontrolPolicy
	 * @param resPrecontrolWarmReceiver
	 * @param code
	 * @param value
	 * @param ids
	 * @param changeSum
	 * @param changeLeave
	 * @return
	 */
	@RequestMapping(value = "/editResourceControl")
	@ResponseBody
	public Object editResourceControl(ResPrecontrolPolicy resPrecontrolPolicy,
			ResPrecontrolWarmReceiver resPrecontrolWarmReceiver, String code, String value, String ids,
			String ProductManagerEmail) {
		String[] codes = code.split(",");
		Long id = resPrecontrolPolicy.getId();
		ResPrecontrolPolicy oldresPrecontrolPolicy = resPrecontrolPolicyService.findResPrecontrolPolicyById(id);
		Long amount = oldresPrecontrolPolicy.getAmount();
		Date newStartDate = oldresPrecontrolPolicy.getTradeExpiryDate();
		Date endDate = resPrecontrolPolicy.getTradeExpiryDate();
		// 默认超卖为N
		resPrecontrolPolicy.setIsCanDelay("N");
		// 金额转换
		resPrecontrolPolicy.setBuyoutTotalCost(PriceUtil.convertToFen(resPrecontrolPolicy.getBuyoutTotalCostStr()));
		resPrecontrolPolicy.setForecastSales(PriceUtil.convertToFen(resPrecontrolPolicy.getForecastSalesStr()));
		resPrecontrolPolicy.setDepositAmount(PriceUtil.convertToFen(resPrecontrolPolicy.getDepositAmountStr()));
		resPrecontrolPolicy.setNameAmount(PriceUtil.convertToFen(resPrecontrolPolicy.getNameAmountStr()));
		// 保存延期时间
		if (!DateUtil.isTheSameDay(newStartDate, endDate)) {
			resPrecontrolPolicy.setDelayTime(endDate);
		}
		resPrecontrolPolicyService.updateResPrecontrolPolicy(resPrecontrolPolicy);
		// 保存按金额
		int days = DateUtil.getDaysBetween(oldresPrecontrolPolicy.getTradeExpiryDate(),
				resPrecontrolPolicy.getTradeExpiryDate()) + 1;
		if (oldresPrecontrolPolicy.getControlType()
				.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
			ResPrecontrolAmount resPrecontrolAmount = new ResPrecontrolAmount();
			// 按周期
			if (oldresPrecontrolPolicy.getControlClassification()
					.equalsIgnoreCase(ResControlEnum.CONTROL_CLASSIFICATION.Cycle.name())) {
				resPrecontrolAmount.setPrecontrolPolicyId(id);
				resPrecontrolAmount.setExpiryDate(endDate);
				resPrecontrolAmountService.updateEndDate(resPrecontrolAmount);
			} else {
				// 按日
				List<ResPrecontrolAmount> list = new ArrayList<ResPrecontrolAmount>();
				for (int i = 1; i < days; i++) {
					ResPrecontrolAmount resPrecontrolAmountA = new ResPrecontrolAmount();
					resPrecontrolAmountA.setPrecontrolPolicyId(id);
					resPrecontrolAmountA.setQuantity(amount);
					resPrecontrolAmountA.setEffectDate(DateUtil.dsDay_Date(newStartDate, i));
					resPrecontrolAmountA.setExpiryDate(DateUtil.dsDay_Date(newStartDate, i));
					list.add(resPrecontrolAmountA);
				}
				if (list.size() > 0)
					resPrecontrolAmountService.batchInsert(list);
			}
		} else {
			// 保存按库存
			// 按周期
			ResPrecontrolInventory resPrecontrolInventory = new ResPrecontrolInventory();
			if (oldresPrecontrolPolicy.getControlClassification()
					.equalsIgnoreCase(ResControlEnum.CONTROL_CLASSIFICATION.Cycle.name())) {
				resPrecontrolInventory.setPrecontrolPolicyId(id);
				resPrecontrolInventory.setExpiryDate(endDate);
				resPrecontrolInventoryService.updateEndDate(resPrecontrolInventory);
			} else {
				// 按日保存一天插入一条数据
				List<ResPrecontrolInventory> list = new ArrayList<ResPrecontrolInventory>();
				for (int i = 1; i < days; i++) {
					ResPrecontrolInventory resPrecontrolInventoryB = new ResPrecontrolInventory();
					resPrecontrolInventoryB.setPrecontrolPolicyId(id);
					resPrecontrolInventoryB.setQuantity(amount);
					Date dateStatic = DateUtil.dsDay_Date(newStartDate, i);
					resPrecontrolInventoryB.setEffectDate(dateStatic);
					resPrecontrolInventoryB.setExpiryDate(dateStatic);
					list.add(resPrecontrolInventoryB);
				}
				if (list.size() > 0)
					resPrecontrolInventoryService.batchInsert(list);
			}
		}
		List<ResPrecontrolWarmOption> listOption = resPrecontrolWarmOptionService
				.findListByResPrecontrolPolicyId(resPrecontrolPolicy.getId());
		// 遍历删除所有的规则关联对象和规则对象
		List<Long> resWarmRuleList = new ArrayList<Long>();
		for (ResPrecontrolWarmOption resPrecontrolWarmOption : listOption) {
			resWarmRuleList.add(resPrecontrolWarmOption.getWarmRuleId());
		}
		resRuleReceiverRelationSerive.deleteResRuleReceiverRelationByWarmRuleIds(resWarmRuleList);
		resWarmRuleService.deleteResWarmRuleByIds(resWarmRuleList);
		resPrecontrolWarmOptionService.deleteResPrecontrolWarmOption(resPrecontrolPolicy.getId());
		resPrecontrolWarmReceiverService.deteteResPrecontrolWarmReceiver(resPrecontrolPolicy.getId());
		// 保存产品经理提醒人
		ResPrecontrolWarmReceiver resPrecontrolWarmReceiverManger = new ResPrecontrolWarmReceiver();
		resPrecontrolWarmReceiverManger.setPrecontrolPolicyId(resPrecontrolPolicy.getId());
		resPrecontrolWarmReceiverManger.setReceiverId(resPrecontrolPolicy.getProductManagerId());
		resPrecontrolWarmReceiverManger.setReceiverName(resPrecontrolPolicy.getProductManagerName());
		resPrecontrolWarmReceiverManger.setEmail(ProductManagerEmail);
		Long resPrecontrolWarmReceiverRealMangerId = resPrecontrolWarmReceiverService
				.save(resPrecontrolWarmReceiverManger);
		// 保存code规则的list
		List<Long> list = new ArrayList<Long>();
		for (String string : codes) {
			ResWarmRule resWarmRule = new ResWarmRule();
			if (string.equals("loss")) {
				resWarmRule.setValue(value);
			}
			resWarmRule.setName(string);
			Long resWarmRuleId = resWarmRuleService.save(resWarmRule);
			list.add(resWarmRuleId);
		}
		List<ResRuleReceiverRelation> listRelation = new ArrayList<ResRuleReceiverRelation>();
		Long[] resPrecontrolWarmOptionIds = new Long[list.size()];
		int x = 0;
		for (Long resWarmRuleId : list) {
			ResPrecontrolWarmOption resPrecontrolWarmOption = new ResPrecontrolWarmOption();
			resPrecontrolWarmOption.setPrecontrolPolicyId(resPrecontrolPolicy.getId());
			resPrecontrolWarmOption.setControlClassification(resPrecontrolPolicy.getControlClassification());
			resPrecontrolWarmOption.setWarmRuleId(resWarmRuleId);
			// 保存买断资源提醒设置
			Long resPrecontrolWarmOptionId = resPrecontrolWarmOptionService.save(resPrecontrolWarmOption);
			resPrecontrolWarmOptionIds[x++] = resPrecontrolWarmOptionId;
			for (Long resWarmRuleIds : list) {
				ResRuleReceiverRelation resRuleReceiverRelation = new ResRuleReceiverRelation();
				resRuleReceiverRelation.setPrecontrolWarmOptionId(resPrecontrolWarmOptionId);
				resRuleReceiverRelation.setWarmRuleId(resWarmRuleIds);
				resRuleReceiverRelation.setWarmReceiverId(resPrecontrolWarmReceiverRealMangerId);
				listRelation.add(resRuleReceiverRelation);
			}
		}
		// 保存收件人发件规则表
		int bathNum = resRuleReceiverRelationSerive.batchInsert(listRelation);
		// 保存提醒人
		if (ids != null) {
			// 保存提醒人
			String[] resPrecontrolWarmReceiverIds = ids.split(",");
			String[] resPrecontrolWarmReceiverNames = resPrecontrolWarmReceiver.getReceiverName().split(",");
			String[] resPrecontrolWarmReceiverEmails = resPrecontrolWarmReceiver.getEmail().split(",");
			int length = resPrecontrolWarmReceiverIds.length;
			Long[] resPrecontrolWarmReceiverRealIds = new Long[length];
			for (int i = 0; i < length; i++) {
				ResPrecontrolWarmReceiver precontrolWarmReceiver = new ResPrecontrolWarmReceiver();
				precontrolWarmReceiver.setPrecontrolPolicyId(resPrecontrolPolicy.getId());
				precontrolWarmReceiver.setReceiverId(((Long.parseLong(resPrecontrolWarmReceiverIds[i]))));
				precontrolWarmReceiver.setReceiverName(resPrecontrolWarmReceiverNames[i]);
				precontrolWarmReceiver.setEmail(resPrecontrolWarmReceiverEmails[i]);
				Long resPrecontrolWarmReceiverRealId = resPrecontrolWarmReceiverService.save(precontrolWarmReceiver);
				resPrecontrolWarmReceiverRealIds[i] = resPrecontrolWarmReceiverRealId;
			}
			List<ResRuleReceiverRelation> listsRelation = new ArrayList<ResRuleReceiverRelation>();
			// 保存买断资源预控提醒设置
			for (int y = 0; y < list.size(); y++) {
				for (int i = 0; i < length; i++) {
					for (Long resWarmRuleIds : list) {
						ResRuleReceiverRelation resRuleReceiverRelation = new ResRuleReceiverRelation();
						resRuleReceiverRelation.setPrecontrolWarmOptionId(resPrecontrolWarmOptionIds[y]);
						resRuleReceiverRelation.setWarmRuleId(resWarmRuleIds);
						resRuleReceiverRelation.setWarmReceiverId(resPrecontrolWarmReceiverRealIds[i]);
						listsRelation.add(resRuleReceiverRelation);
					}
				}
			}
			// 保存联系人关系表
			int bathsNum = resRuleReceiverRelationSerive.batchInsert(listsRelation);
		}
		StringBuilder strLog = new StringBuilder();
		strLog.append("更新资源策略id" + resPrecontrolPolicy.getId());
		try {
			if (!oldresPrecontrolPolicy.getIsCanDelay().equalsIgnoreCase(resPrecontrolPolicy.getIsCanDelay())) {
				strLog.append("超卖修改为：" + resPrecontrolPolicy.getIsCanDelay());
			}
		} catch (Exception e1) {
			log.error("Log overBuy fail ");
		}
		if (!DateUtil.isTheSameDay(newStartDate, endDate)) {
			strLog.append("延期:" + DateUtil.formatDate(newStartDate, "yyyy-MM-dd") + "-"
					+ DateUtil.formatDate(endDate, "yyyy-MM-dd"));
		}
		if (!oldresPrecontrolPolicy.getIsCanDelay().equalsIgnoreCase(resPrecontrolPolicy.getIsCanDelay())
				|| !DateUtil.isTheSameDay(newStartDate, endDate)) {
			ResPrecontrolJob job = new ResPrecontrolJob();
			job.setCreateDate(new Date());
			job.setPrecontrolPolicyId(id);
			job.setTaskType(ResControlEnum.CONTROL_STATE.modify.toString());
			this.resPrecontrolJobService.save(job);
		}
		try {
			// this.getLoginUser().getUserName()
			comLogService.insert(COM_LOG_OBJECT_TYPE.RES_PRECONTROL_POLICY_POLICY, resPrecontrolPolicy.getId(),
					resPrecontrolPolicy.getId(), this.getLoginUser().getUserName(), strLog.toString(),
					COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name(), "更新资源预控", null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name());
			log.error(e.getMessage());
		}
		// 更新成功
		return ResultMessage.SUCCESS;
	}

	/**
	 * 展示资源策略预控的页面非列表页面
	 *
	 * @return
	 */
	@RequestMapping(value = "/showResourceCotrol")
	public Object showResourceCotrol() {
		return "/res/resource_control_setting";
	}

	/**
	 * 跳转添加买断子预控页面
	 *
	 * @return
	 */
	@RequestMapping(value = "/goToAddResControlItem/view")
	public String goToAddResControlItem(Model model, Long precontrolPolicyId, String controlType) {
		// 预控ID
		model.addAttribute("precontrolPolicyId", precontrolPolicyId);
		model.addAttribute("controlType", controlType);
		return "/res/resource_add_control_item";
	}

	/**
	 * 添加买断子预控
	 * 
	 * @return
	 */
	@RequestMapping(value = "/addResourceControlItem")
	@ResponseBody
	@Transactional
	public String addResourceControlItem(ResPrecontrolPolicyItem resPrecontrolPolicyItem) {
		StringBuffer sb = new StringBuffer("{\"code\":");
		Long precontrolPolicyId = resPrecontrolPolicyItem.getPrecontrolPolicyId();
		StringBuilder strLog = new StringBuilder();
		StringBuilder strItemLog = new StringBuilder();
		strLog.append("资源策略id:" + precontrolPolicyId);
		if (null == precontrolPolicyId) {
			sb.append("0, \"msg\":\"参数资源预控ID不能为空!\"}");
			return sb.toString();
		}
		if (null == resPrecontrolPolicyItem.getQuantity()) {
			sb.append("0, \"msg\":\"参数库存/金额不能为空!\"}");
			return sb.toString();
		}
		// 查询资源策略
		ResPrecontrolPolicy policy = resPrecontrolPolicyService.findResPrecontrolPolicyById(precontrolPolicyId);
		if (null == policy) {
			sb.append("0, \"msg\":\"未查询到预控资源策略!\"}");
			return sb.toString();
		}
		if (resPrecontrolPolicyItem.getItemControlType()
				.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
			resPrecontrolPolicyItem.setQuantity(mulNumber(resPrecontrolPolicyItem.getQuantity()));
		}
		// 查询最小库存金额，判断是否能减
		Long minAmount = 0L;
		if (resPrecontrolPolicyItem.getItemControlClass() != null
				&& resPrecontrolPolicyItem.getItemControlClass().equals("subtract")) {
			if (resPrecontrolPolicyItem.getItemControlType()
					.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
				minAmount = resPrecontrolAmountService.findMinAmountByPolicyId(precontrolPolicyId);
			} else {
				minAmount = resPrecontrolInventoryService.findMinInventoryByPolicyId(precontrolPolicyId);
			}
			if ((minAmount - resPrecontrolPolicyItem.getQuantity()) <= 0) {
				sb.append("0, \"msg\":\"减少库存/金额超出预控库存/金额范围!\"}");
				return sb.toString();
			}
		}
		// 更新主预控金额/库存
		Long newAmountL = policy.getAmount();
		ResPrecontrolPolicy newPolicy = new ResPrecontrolPolicy();
		newPolicy.setId(policy.getId());
		// 保存子预控
		Long policyItemId = resPrecontrolPolicyItemService.save(resPrecontrolPolicyItem);
		// 子预控类型：增加
		if (resPrecontrolPolicyItem.getItemControlClass() != null
				&& resPrecontrolPolicyItem.getItemControlClass().equals("add")) {
			// 计算主预控金额/库存 加上追加的子预控，并更新
			newAmountL += Math.abs(resPrecontrolPolicyItem.getQuantity());
			newPolicy.setAmount(newAmountL);
			resPrecontrolPolicyService.updateAmountByPrimaryKey(newPolicy);
			// 更新库存/金额 ,加上追加的子预控
			if (resPrecontrolPolicyItem.getItemControlType()
					.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
				ResPrecontrolAmount newAmount = new ResPrecontrolAmount();
				newAmount.setQuantity(Math.abs(resPrecontrolPolicyItem.getQuantity()));
				newAmount.setPrecontrolPolicyId(precontrolPolicyId);
				resPrecontrolAmountService.updateAddAmountByPolicyId(newAmount);
			} else {
				ResPrecontrolInventory newInventory = new ResPrecontrolInventory();
				newInventory.setQuantity(Math.abs(resPrecontrolPolicyItem.getQuantity()));
				newInventory.setPrecontrolPolicyId(precontrolPolicyId);
				resPrecontrolInventoryService.updateAddInventoryByPolicyId(newInventory);
			}
		} else {
			// 计算主预控金额/库存 减去减少的子预控，并更新
			newAmountL += (-1 * Math.abs(resPrecontrolPolicyItem.getQuantity()));
			newPolicy.setAmount(newAmountL);
			resPrecontrolPolicyService.updateAmountByPrimaryKey(newPolicy);
			// 更新库存/金额 ,减去减少的子预控
			if (resPrecontrolPolicyItem.getItemControlType()
					.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
				ResPrecontrolAmount newAmount = new ResPrecontrolAmount();
				newAmount.setQuantity(-1 * Math.abs(resPrecontrolPolicyItem.getQuantity()));
				newAmount.setPrecontrolPolicyId(precontrolPolicyId);
				resPrecontrolAmountService.updateAddAmountByPolicyId(newAmount);
			} else {
				ResPrecontrolInventory newInventory = new ResPrecontrolInventory();
				newInventory.setQuantity(-1 * Math.abs(resPrecontrolPolicyItem.getQuantity()));
				newInventory.setPrecontrolPolicyId(precontrolPolicyId);
				resPrecontrolInventoryService.updateAddInventoryByPolicyId(newInventory);
			}
		}
		// 清缓存
		removeMemcached(policy.getId(), policy.getTradeEffectDate(), policy.getTradeExpiryDate());
		sb.append("1, \"msg\":\"保存成功\"");
		sb.append("}");
		try {
			// 日志
			if (resPrecontrolPolicyItem.getItemControlType()
					.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
				strLog.append(" 新增子预控id:" + policyItemId + " 子预控类型:"
						+ (resPrecontrolPolicyItem.getItemControlClass().equals("add") ? "追加" : "减少") + " 子预控金额:"
						+ divNumber(resPrecontrolPolicyItem.getQuantity()));
				strItemLog.append("新增子预控id:" + policyItemId + " 子预控类型:"
						+ (resPrecontrolPolicyItem.getItemControlClass().equals("add") ? "追加" : "减少") + " 子预控金额:"
						+ divNumber(resPrecontrolPolicyItem.getQuantity()));
			} else {
				strLog.append(" 新增子预控id:" + policyItemId + " 子预控类型:"
						+ (resPrecontrolPolicyItem.getItemControlClass().equals("add") ? "追加" : "减少") + " 子预控库存:"
						+ resPrecontrolPolicyItem.getQuantity());
				strItemLog.append("新增子预控id:" + policyItemId + " 子预控类型:"
						+ (resPrecontrolPolicyItem.getItemControlClass().equals("add") ? "追加" : "减少") + " 子预控库存:"
						+ resPrecontrolPolicyItem.getQuantity());
			}
			// 保存操作日志
			comLogService.insert(COM_LOG_OBJECT_TYPE.RES_PRECONTROL_POLICY_POLICY, precontrolPolicyId,
					precontrolPolicyId, this.getLoginUser().getUserName(), strLog.toString(),
					COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name(), "更新资源预控", null);
			comLogService.insert(COM_LOG_OBJECT_TYPE.RES_PRECONTROL_POLICY_POLICY_ITEM, policyItemId, policyItemId,
					this.getLoginUser().getUserName(), strItemLog.toString(),
					COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE_ITEM.name(), "新增资源预控子预控", null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE_ITEM.name());
			log.error(e.getMessage());
		}
		return sb.toString();
	}

	/**
	 * 跳转修改子预控页面
	 *
	 * @return
	 */
	@RequestMapping(value = "/goToEditResPrecontrolPolicyItem/view")
	public String goToEditResPrecontrolPolicyItem(Model model, Long policyItemId) {
		ResPrecontrolPolicyItem policyItem = resPrecontrolPolicyItemService.selectByPrimaryKey(policyItemId);
		if (policyItem.getItemControlType().equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
			policyItem.setQuantity(divNumber(policyItem.getQuantity()));
		}
		model.addAttribute("policyItem", policyItem);
		return "/res/resource_edit_control_item";
	}

	/**
	 * 修改买断子预控
	 * 
	 * @return
	 */
	@RequestMapping(value = "/editResourceControlItem")
	@ResponseBody
	@Transactional
	public String editResourceControlItem(ResPrecontrolPolicyItem resPrecontrolPolicyItem) {
		StringBuilder strLog = new StringBuilder();
		StringBuilder strItemLog = new StringBuilder();
		StringBuffer sb = new StringBuffer("{\"code\":");
		Long policyItemId = resPrecontrolPolicyItem.getPolicyItemId();
		if (null == policyItemId) {
			sb.append("0, \"msg\":\"参数子预控ID不能为空!\"}");
			return sb.toString();
		}
		ResPrecontrolPolicyItem oldPolicyItem = resPrecontrolPolicyItemService.selectByPrimaryKey(policyItemId);
		if (null == oldPolicyItem) {
			sb.append("0, \"msg\":\"未查询到子预控!\"}");
			return sb.toString();
		}
		// 主预控ID
		Long precontrolPolicyId = oldPolicyItem.getPrecontrolPolicyId();
		// 查询资源策略
		ResPrecontrolPolicy policy = resPrecontrolPolicyService.findResPrecontrolPolicyById(precontrolPolicyId);
		if (null == policy) {
			sb.append("0, \"msg\":\"未查询到预控资源策略!\"}");
			return sb.toString();
		}
		if (resPrecontrolPolicyItem.getItemControlType()
				.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
			resPrecontrolPolicyItem.setQuantity(mulNumber(resPrecontrolPolicyItem.getQuantity()));
		}
		// 查询最小库存金额，判断是否可以修改子预控
		// 变大变小标志
		boolean changeBigFlag = false;
		Long oldQuantity = oldPolicyItem.getQuantity();
		Long newQuantity = resPrecontrolPolicyItem.getQuantity();
		// 变动金额，新-老
		Long changeAmount = newQuantity - oldQuantity;
		// 新老金额一致代表没有修改,直接返回成功
		if (newQuantity == oldQuantity) {
			sb.append("1, \"msg\":\"保存成功!\"}");
			return sb.toString();
		} else if (newQuantity > oldQuantity) {
			changeBigFlag = true;
		} else {
			changeBigFlag = false;
		}
		// 追加改小 和 减少改大，需要校验预控库存范围
		Long minAmount = 0L;
		// 追加改小
		if ((!changeBigFlag && resPrecontrolPolicyItem.getItemControlClass().equals("add"))) {
			if (resPrecontrolPolicyItem.getItemControlType()
					.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
				minAmount = resPrecontrolAmountService
						.findMinAmountByPolicyId(resPrecontrolPolicyItem.getPrecontrolPolicyId());
			} else {
				minAmount = resPrecontrolInventoryService
						.findMinInventoryByPolicyId(resPrecontrolPolicyItem.getPrecontrolPolicyId());
			}
			if ((minAmount - (oldQuantity - newQuantity)) <= 0) {
				sb.append("0, \"msg\":\"修改的子预控超出预控库存/金额范围!\"}");
				return sb.toString();
			}
			// 减少改大
		} else if (changeBigFlag && resPrecontrolPolicyItem.getItemControlClass().equals("subtract")) {
			if (resPrecontrolPolicyItem.getItemControlType()
					.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
				minAmount = resPrecontrolAmountService
						.findMinAmountByPolicyId(resPrecontrolPolicyItem.getPrecontrolPolicyId());
			} else {
				minAmount = resPrecontrolInventoryService
						.findMinInventoryByPolicyId(resPrecontrolPolicyItem.getPrecontrolPolicyId());
			}
			if ((minAmount - changeAmount) <= 0) {
				sb.append("0, \"msg\":\"修改的子预控超出预控库存/金额范围!\"}");
				return sb.toString();
			}
		}
		// 更新主预控金额/库存
		Long newAmountL = policy.getAmount();
		ResPrecontrolPolicy newPolicy = new ResPrecontrolPolicy();
		newPolicy.setId(policy.getId());
		// 子预控类型：增加
		if (resPrecontrolPolicyItem.getItemControlClass() != null
				&& resPrecontrolPolicyItem.getItemControlClass().equals("add")) {
			// 计算主预控金额/库存 加上变动金额/库存，并更新
			newAmountL += changeAmount;
			newPolicy.setAmount(newAmountL);
			resPrecontrolPolicyService.updateAmountByPrimaryKey(newPolicy);
			// 更新库存/金额 ,加上变动金额/库存
			if (resPrecontrolPolicyItem.getItemControlType()
					.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
				ResPrecontrolAmount newAmount = new ResPrecontrolAmount();
				newAmount.setQuantity(changeAmount);
				newAmount.setPrecontrolPolicyId(precontrolPolicyId);
				resPrecontrolAmountService.updateAddAmountByPolicyId(newAmount);
			} else {
				ResPrecontrolInventory newInventory = new ResPrecontrolInventory();
				newInventory.setQuantity(changeAmount);
				newInventory.setPrecontrolPolicyId(precontrolPolicyId);
				resPrecontrolInventoryService.updateAddInventoryByPolicyId(newInventory);
			}
		} else {
			// 计算主预控金额/库存 减去变动金额/库存，并更新
			newAmountL -= changeAmount;
			newPolicy.setAmount(newAmountL);
			resPrecontrolPolicyService.updateAmountByPrimaryKey(newPolicy);
			// 更新库存/金额 ,减去变动金额/库存
			if (resPrecontrolPolicyItem.getItemControlType()
					.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
				ResPrecontrolAmount newAmount = new ResPrecontrolAmount();
				newAmount.setQuantity(-1 * changeAmount);
				newAmount.setPrecontrolPolicyId(precontrolPolicyId);
				resPrecontrolAmountService.updateAddAmountByPolicyId(newAmount);
			} else {
				ResPrecontrolInventory newInventory = new ResPrecontrolInventory();
				newInventory.setQuantity(-1 * changeAmount);
				newInventory.setPrecontrolPolicyId(precontrolPolicyId);
				resPrecontrolInventoryService.updateAddInventoryByPolicyId(newInventory);
			}
		}
		// 更新子预控
		ResPrecontrolPolicyItem policyItemNew = new ResPrecontrolPolicyItem();
		policyItemNew.setPolicyItemId(policyItemId);
		policyItemNew.setQuantity(resPrecontrolPolicyItem.getQuantity());
		if (resPrecontrolPolicyItemService.updateAmountByPrimaryKey(policyItemNew) > 0) {
			sb.append("1, \"msg\":\"修改成功\"");
		} else {
			sb.append("0, \"msg\":\"修改失败\"");
		}
		sb.append("}");
		// 清缓存
		removeMemcached(policy.getId(), policy.getTradeEffectDate(), policy.getTradeExpiryDate());
		try {
			// 日志
			strLog.append("资源策略id:" + precontrolPolicyId);
			if (resPrecontrolPolicyItem.getItemControlType()
					.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
				strLog.append(" 修改子预控id:" + policyItemId + " 子预控类型:"
						+ (oldPolicyItem.getItemControlClass().equals("add") ? "追加" : "减少") + " 原子预控金额:"
						+ divNumber(oldPolicyItem.getQuantity()) + " 新子预控金额:"
						+ divNumber(resPrecontrolPolicyItem.getQuantity()));
				strItemLog.append("修改子预控id:" + policyItemId + " 子预控类型:"
						+ (oldPolicyItem.getItemControlClass().equals("add") ? "追加" : "减少") + " 原子预控金额:"
						+ divNumber(oldPolicyItem.getQuantity()) + " 新子预控金额:"
						+ divNumber(resPrecontrolPolicyItem.getQuantity()));
			} else {
				strLog.append(" 修改子预控id:" + policyItemId + " 子预控类型:"
						+ (oldPolicyItem.getItemControlClass().equals("add") ? "追加" : "减少") + " 原子预控库存:"
						+ oldPolicyItem.getQuantity() + " 新子预控库存:" + resPrecontrolPolicyItem.getQuantity());
				strItemLog.append("修改子预控id:" + policyItemId + " 子预控类型:"
						+ (oldPolicyItem.getItemControlClass().equals("add") ? "追加" : "减少") + " 原子预控库存:"
						+ oldPolicyItem.getQuantity() + " 新子预控库存:" + resPrecontrolPolicyItem.getQuantity());
			}
			// 保存操作日志
			comLogService.insert(COM_LOG_OBJECT_TYPE.RES_PRECONTROL_POLICY_POLICY, precontrolPolicyId,
					precontrolPolicyId, this.getLoginUser().getUserName(), strLog.toString(),
					COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name(), "更新资源预控", null);
			comLogService.insert(COM_LOG_OBJECT_TYPE.RES_PRECONTROL_POLICY_POLICY_ITEM, policyItemId, policyItemId,
					this.getLoginUser().getUserName(), strItemLog.toString(),
					COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE_ITEM.name(), "修改资源预控子预控", null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE_ITEM.name());
			log.error(e.getMessage());
		}
		// 保存成功
		return sb.toString();
	}

	/**
	 * 删除子预控
	 * 
	 * @param policyItemId
	 * @return
	 */
	@RequestMapping("/deleteResouceControlItem")
	@ResponseBody
	@Transactional
	public String deleteResouceControlItem(Long policyItemId) {
		StringBuilder strLog = new StringBuilder();
		StringBuilder strItemLog = new StringBuilder();
		StringBuffer sb = new StringBuffer("{\"code\":");
		if (null == policyItemId) {
			sb.append("0, \"msg\":\"参数子预控ID不能为空!\"}");
			return sb.toString();
		}
		ResPrecontrolPolicyItem resPrecontrolPolicyItem = resPrecontrolPolicyItemService
				.selectByPrimaryKey(policyItemId);
		if (null == resPrecontrolPolicyItem) {
			sb.append("0, \"msg\":\"未查询到子预控!\"}");
			return sb.toString();
		}
		// 主预控ID
		Long precontrolPolicyId = resPrecontrolPolicyItem.getPrecontrolPolicyId();
		strLog.append("资源策略id:" + precontrolPolicyId);
		// 查询资源策略
		ResPrecontrolPolicy policy = resPrecontrolPolicyService.findResPrecontrolPolicyById(precontrolPolicyId);
		if (null == policy) {
			sb.append("0, \"msg\":\"未查询到预控资源策略!\"}");
			return sb.toString();
		}
		// 查询最小库存金额，判断追加的子预控是否可以删除
		Long minAmount = 0L;
		if (resPrecontrolPolicyItem.getItemControlClass() != null
				&& resPrecontrolPolicyItem.getItemControlClass().equals("add")) {
			if (resPrecontrolPolicyItem.getItemControlType()
					.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
				minAmount = resPrecontrolAmountService
						.findMinAmountByPolicyId(resPrecontrolPolicyItem.getPrecontrolPolicyId());
			} else {
				minAmount = resPrecontrolInventoryService
						.findMinInventoryByPolicyId(resPrecontrolPolicyItem.getPrecontrolPolicyId());
			}
			if ((minAmount - resPrecontrolPolicyItem.getQuantity()) <= 0) {
				sb.append("0, \"msg\":\"删除追加的子预控超出预控库存/金额范围!\"}");
				return sb.toString();
			}
		}
		// 更新主预控金额/库存
		Long newAmountL = policy.getAmount();
		ResPrecontrolPolicy newPolicy = new ResPrecontrolPolicy();
		newPolicy.setId(policy.getId());
		// 子预控类型：追加
		if (resPrecontrolPolicyItem.getItemControlClass() != null
				&& resPrecontrolPolicyItem.getItemControlClass().equals("add")) {
			// 计算主预控金额/库存 减去追加的子预控，并更新
			newAmountL += (-1 * Math.abs(resPrecontrolPolicyItem.getQuantity()));
			newPolicy.setAmount(newAmountL);
			resPrecontrolPolicyService.updateAmountByPrimaryKey(newPolicy);
			// 更新库存/金额 ,减去追加的子预控
			if (resPrecontrolPolicyItem.getItemControlType()
					.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
				ResPrecontrolAmount newAmount = new ResPrecontrolAmount();
				newAmount.setQuantity(-1 * Math.abs(resPrecontrolPolicyItem.getQuantity()));
				newAmount.setPrecontrolPolicyId(precontrolPolicyId);
				resPrecontrolAmountService.updateAddAmountByPolicyId(newAmount);
			} else {
				ResPrecontrolInventory newInventory = new ResPrecontrolInventory();
				newInventory.setQuantity(-1 * Math.abs(resPrecontrolPolicyItem.getQuantity()));
				newInventory.setPrecontrolPolicyId(precontrolPolicyId);
				resPrecontrolInventoryService.updateAddInventoryByPolicyId(newInventory);
			}
		} else {
			// 计算主预控金额/库存 加上减少的子预控，并更新
			newAmountL += Math.abs(resPrecontrolPolicyItem.getQuantity());
			newPolicy.setAmount(newAmountL);
			resPrecontrolPolicyService.updateAmountByPrimaryKey(newPolicy);
			// 更新库存/金额 ,加上减少的子预控
			if (resPrecontrolPolicyItem.getItemControlType()
					.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
				ResPrecontrolAmount newAmount = new ResPrecontrolAmount();
				newAmount.setQuantity(Math.abs(resPrecontrolPolicyItem.getQuantity()));
				newAmount.setPrecontrolPolicyId(precontrolPolicyId);
				resPrecontrolAmountService.updateAddAmountByPolicyId(newAmount);
			} else {
				ResPrecontrolInventory newInventory = new ResPrecontrolInventory();
				newInventory.setQuantity(Math.abs(resPrecontrolPolicyItem.getQuantity()));
				newInventory.setPrecontrolPolicyId(precontrolPolicyId);
				resPrecontrolInventoryService.updateAddInventoryByPolicyId(newInventory);
			}
		}
		// 删除子预控
		if (resPrecontrolPolicyItemService.deleteByPrimaryKey(policyItemId) > 0) { // delete
																					// from
																					// res_precontrol_policy
			sb.append("1, \"msg\":\"删除成功\"");
		} else {
			sb.append("0, \"msg\":\"删除失败!\"");
		}
		sb.append("}");
		// 清缓存
		removeMemcached(policy.getId(), policy.getTradeEffectDate(), policy.getTradeExpiryDate());
		try {
			// 日志
			if (resPrecontrolPolicyItem.getItemControlType()
					.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
				strLog.append(" 删除子预控id:" + policyItemId + " 子预控类型:"
						+ (resPrecontrolPolicyItem.getItemControlClass().equals("add") ? "追加" : "减少") + " 子预控金额:"
						+ divNumber(resPrecontrolPolicyItem.getQuantity()));
				strItemLog.append("删除子预控id:" + policyItemId + " 子预控类型:"
						+ (resPrecontrolPolicyItem.getItemControlClass().equals("add") ? "追加" : "减少") + " 子预控金额:"
						+ divNumber(resPrecontrolPolicyItem.getQuantity()));
			} else {
				strLog.append(" 删除子预控id:" + policyItemId + " 子预控类型:"
						+ (resPrecontrolPolicyItem.getItemControlClass().equals("add") ? "追加" : "减少") + " 子预控库存:"
						+ resPrecontrolPolicyItem.getQuantity());
				strItemLog.append("删除子预控id:" + policyItemId + " 子预控类型:"
						+ (resPrecontrolPolicyItem.getItemControlClass().equals("add") ? "追加" : "减少") + " 子预控库存:"
						+ resPrecontrolPolicyItem.getQuantity());
			}
			// 保存操作日志
			comLogService.insert(COM_LOG_OBJECT_TYPE.RES_PRECONTROL_POLICY_POLICY, precontrolPolicyId,
					precontrolPolicyId, this.getLoginUser().getUserName(), strLog.toString(),
					COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name(), "更新资源预控", null);
			comLogService.insert(COM_LOG_OBJECT_TYPE.RES_PRECONTROL_POLICY_POLICY_ITEM, policyItemId, policyItemId,
					this.getLoginUser().getUserName(), strItemLog.toString(),
					COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE_ITEM.name(), "删除资源预控子预控", null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name());
			log.error(e.getMessage());
		}
		return sb.toString();
	}

	/**
	 * 清理主预控下面绑定的商品的缓存
	 * 
	 * @param precontrolPolicyId
	 *            主预控ID
	 * @param startDate
	 *            开始日期
	 * @param endDate
	 *            结束日期
	 */
	public void removeMemcached(Long precontrolPolicyId, Date startDate, Date endDate) {
		try {
			Map<String, Long> paramsMap = new HashMap<String, Long>();
			paramsMap.put("precontrolPolicyId", precontrolPolicyId);
			List<ResPrecontrolBindGoods> goods = this.resPrecontrolBindGoodsService
					.findResPrecontrolBindGoodsPlus(paramsMap);
			List<Long> goodsList = new ArrayList<Long>();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			if (CollectionUtils.isNotEmpty(goods)) {
				for (ResPrecontrolBindGoods good : goods) {
					goodsList.add(good.getGoodsId());
				}
				List<Date> visitDate = DateUtil.getDateList(startDate, endDate);
				List<Date> dateList = new ArrayList<Date>();
				if (CollectionUtils.isNotEmpty(visitDate)) {
					for (Date date : visitDate) {
						dateList.add(sdf.parse(sdf.format(date)));
					}
				}
				for (Long goodsId : goodsList) {
					for (Date date : dateList) {
						String key = "PRE_CONTROL_" + goodsId + "_" + sdf.format(date);
						boolean b = MemcachedUtil.getInstance().keyExists(key);
						if (b) {
							boolean b2 = MemcachedUtil.getInstance().remove(key);
							if (!b2) {
								log.error("清理缓存失败！precontrolPolicyId=" + precontrolPolicyId + ",startDate=" + startDate
										+ ",endDate=" + endDate);
							}
						}
					}
				}
			}
		} catch (Exception e) {
			log.error("清理缓存出异常！precontrolPolicyId=" + precontrolPolicyId + ",startDate=" + startDate + ",endDate="
					+ endDate);
			log.error(e.getMessage());
		}
	}

	/**
	 * 跳转付款流水主页面
	 *
	 * @return
	 */
	@RequestMapping(value = "/goToResControlPaymentMain/view")
	public String goToResControlPaymentMain(Model model, Integer page, Long precontrolPolicyId,
			HttpServletRequest req) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("precontrolPolicyId", precontrolPolicyId);
		int count = resPrecontrolPaymentService.selectCountByParams(params);
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		params.put("_start", pageParam.getStartRows());
		params.put("_end", pageParam.getEndRows());
		params.put("_orderby", "PAYMENT_ID");
		params.put("_order", "DESC");
		List<ResPrecontrolPayment> list = resPrecontrolPaymentService.selectListByParams(params);
		pageParam.setItems(list);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("precontrolPolicyId", precontrolPolicyId);
		return "/res/resource_paymoney_main";
	}

	/**
	 * 跳转新增付款流水页面
	 *
	 * @return
	 */
	@RequestMapping(value = "/goToResControlPaymentAdd/view")
	public String goToResControlPaymentAdd(Model model, Long precontrolPolicyId) {
		// 预控ID
		model.addAttribute("precontrolPolicyId", precontrolPolicyId);
		return "/res/resource_paymoney_add";
	}

	/**
	 * 跳转新增付款流水页面
	 *
	 * @return
	 */
	@RequestMapping(value = "/goToResControlPaymentEdit/view")
	public String goToResControlPaymentEdit(Model model, Long precontrolPolicyId, Long paymentId) {
		// 预控ID
		model.addAttribute("precontrolPolicyId", precontrolPolicyId);
		// 查询付款流水记录
		ResPrecontrolPayment resPrecontrolPayment = this.resPrecontrolPaymentService.selectByPrimaryKey(paymentId);
		model.addAttribute("resPrecontrolPayment", resPrecontrolPayment);
		return "/res/resource_paymoney_edit";
	}

	/**
	 * 添加付款流水
	 * 
	 * @return
	 */
	@RequestMapping(value = "/addResourceControlPayment")
	@ResponseBody
	@Transactional
	public String addResourceControlPayment(ResPrecontrolPayment resPrecontrolPayment) {
		StringBuffer sb = new StringBuffer("{\"code\":");
		Long precontrolPolicyId = resPrecontrolPayment.getPrecontrolPolicyId();
		if (null == precontrolPolicyId) {
			sb.append("0, \"msg\":\"参数预控ID不能为空!\"}");
			return sb.toString();
		}
		if (null == resPrecontrolPayment.getAmountStr()) {
			sb.append("0, \"msg\":\"金额不能为空!\"}");
			return sb.toString();
		}
		// if (null == resPrecontrolPayment.getPayPerson())
		// {
		// sb.append("0, \"msg\":\"操作人不能为空!\"}");
		// return sb.toString();
		// }
		// 查询资源策略
		ResPrecontrolPolicy policy = resPrecontrolPolicyService.findResPrecontrolPolicyById(precontrolPolicyId);
		if (null == policy) {
			sb.append("0, \"msg\":\"未查询到预控资源策略!\"}");
			return sb.toString();
		}
		resPrecontrolPayment.setAmount(PriceUtil.convertToFen(resPrecontrolPayment.getAmountStr()));
		// resPrecontrolPayment.setPayPerson(resPrecontrolPayment.getPayPerson().trim());
		// 获取登录用户
		// Long userId = getUserId();
		String userName = getUserName();
		String userCnName = getUserCnName();
		// resPrecontrolPayment.setOperatorId(userId == null
		// ? null : userId.toString());
		resPrecontrolPayment.setOperatorId(userName);
		resPrecontrolPayment.setPayPerson(userCnName);
		Long paymentId = resPrecontrolPaymentService.save(resPrecontrolPayment);
		if (paymentId > 0) {
			sb.append("1, \"msg\":\"保存成功\"");
		} else {
			sb.append("0, \"msg\":\"插入失败\"");
		}
		sb.append("}");
		return sb.toString();
	}

	/**
	 * 删除付款流水
	 * 
	 * @return
	 */
	@RequestMapping(value = "/deleteResourceControlPayment")
	@ResponseBody
	@Transactional
	public Object deleteResourceControlPayment(Long paymentId) {
		try {
			if (null == paymentId) {
				return new ResultMessage(ResultMessage.ERROR, "删除失败，参数付款流水ID不能为空！");
			}
			this.resPrecontrolPaymentService.deleteByPrimaryKey(paymentId);
			return ResultMessage.DELETE_SUCCESS_RESULT;
		} catch (Exception e) {
			log.error("===========>【GoodsControlBudgetAction.deleteResourceControlPayment Exception】", e);
			return new ResultMessage(ResultMessage.ERROR, "删除失败:" + e.getMessage());
		}
	}

	/**
	 * 修改付款流水
	 * 
	 * @return
	 */
	@RequestMapping(value = "/editResourceControlPayment")
	@ResponseBody
	@Transactional
	public Object editResourceControlPayment(ResPrecontrolPayment resPrecontrolPayment) {
		StringBuffer sb = new StringBuffer("{\"code\":");
		try {
			// 资源预控ID
			Long precontrolPolicyId = resPrecontrolPayment.getPrecontrolPolicyId();
			// 付款流水ID
			Long paymentId = resPrecontrolPayment.getPaymentId();
			if (null == precontrolPolicyId) {
				sb.append("0, \"msg\":\"参数预控ID不能为空!\"}");
				return sb.toString();
			}
			if (null == resPrecontrolPayment.getAmountStr()) {
				sb.append("0, \"msg\":\"金额不能为空!\"}");
				return sb.toString();
			}
			if (null == paymentId) {
				sb.append("0, \"msg\":\"参数付款流水ID不能为空!\"}");
				return sb.toString();
			}
			// 查询资源策略
			ResPrecontrolPolicy policy = resPrecontrolPolicyService.findResPrecontrolPolicyById(precontrolPolicyId);
			if (null == policy) {
				sb.append("0, \"msg\":\"未查询到预控资源策略!\"}");
				return sb.toString();
			}
			ResPrecontrolPayment oldResPrecontrolPayment = this.resPrecontrolPaymentService
					.selectByPrimaryKey(paymentId);
			if (null == oldResPrecontrolPayment) {
				sb.append("0, \"msg\":\"付款流水ID：" + paymentId + "未查询到付款流水信息!\"}");
				return sb.toString();
			}
			resPrecontrolPayment.setAmount(PriceUtil.convertToFen(resPrecontrolPayment.getAmountStr()));
			// resPrecontrolPayment.setPayPerson(resPrecontrolPayment.getPayPerson().trim());
			// 获取登录用户
			// Long userId = getUserId();
			String userName = getUserName();
			// resPrecontrolPayment.setOperatorId(userId ==
			// null
			// ? null : userId.toString());
			resPrecontrolPayment.setOperatorId(userName);
			resPrecontrolPayment.setPayPerson(getUserCnName());
			resPrecontrolPayment.setUpdateTime(new Date());
			this.resPrecontrolPaymentService.updateByResPrecontrolPayment(resPrecontrolPayment);
			sb.append("}");

			try {
				// 保存操作日志
				String logContent = "";
				if (null != oldResPrecontrolPayment.getPayDate()
						&& !oldResPrecontrolPayment.getPayDate().equals(resPrecontrolPayment.getPayDate())) {
					logContent = logContent + "付款日期：【（原值）"
							+ DateUtil.formatDate(oldResPrecontrolPayment.getPayDate(), DateUtil.PATTERN_yyyy_MM_dd)
							+ "  修改为：（现值）"
							+ DateUtil.formatDate(resPrecontrolPayment.getPayDate(), DateUtil.PATTERN_yyyy_MM_dd) + "】";
				}
				if (null != oldResPrecontrolPayment.getAmount()
						&& !oldResPrecontrolPayment.getAmount().equals(resPrecontrolPayment.getAmount())) {
					logContent = logContent + "付款金额：【（原值）" + oldResPrecontrolPayment.getAmountYuanStr()
							+ "  修改为：（现值）" + resPrecontrolPayment.getAmountYuanStr() + "】";
				}
				if (null != oldResPrecontrolPayment.getMemo()
						&& !oldResPrecontrolPayment.getMemo().equals(resPrecontrolPayment.getMemo())) {
					logContent = logContent + "备注：【（原值）" + oldResPrecontrolPayment.getMemo() + "  修改为：（现值）"
							+ resPrecontrolPayment.getMemo() + "】";
				}
				if (null != oldResPrecontrolPayment.getOperatorId()
						&& !oldResPrecontrolPayment.getOperatorId().equals(resPrecontrolPayment.getOperatorId())) {
					logContent = logContent + "修改人：【（原值）" + oldResPrecontrolPayment.getOperatorId()
							+ oldResPrecontrolPayment.getPayPerson() + "  修改为：（现值）"
							+ resPrecontrolPayment.getPayPerson() + "】";
				}

				if (StringUtils.isNotEmpty(logContent)) {
					comLogService.insert(COM_LOG_OBJECT_TYPE.RES_PRECONTROL_POLICY_POLICY, precontrolPolicyId,
							precontrolPolicyId, this.getLoginUser().getUserName(), logContent,
							COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name(),
							"修改资源预控付款流水" + resPrecontrolPayment.getPaymentId(), null);
				}

			} catch (Exception e) {
				log.error("=======>GoodsControlBudgetAction.editResourceControlPayment Record Log failure ！Log type:"
						+ COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name(), e);
			}

			return ResultMessage.UPDATE_SUCCESS_RESULT;
		} catch (Exception e) {
			log.error("===========>【GoodsControlBudgetAction.editResourceControlPayment Exception】", e);
			sb.append("0, \"msg\":\"修改失败\"");
		}
		sb.append("}");
		return sb.toString();
	}

	protected PermUser getLoginUser() {
		PermUser pu = (PermUser) getSession(SESSION_BACK_USER);
		return pu;
	}

	private Long getUserId() {
		Long userId = null;
		if (this.getLoginUser() != null) {
			userId = this.getLoginUser().getUserId();
		}
		return userId;
	}

	private String getUserName() {
		String userName = null;
		if (this.getLoginUser() != null) {
			userName = this.getLoginUser().getUserName();
		}
		return userName;
	}

	private String getUserCnName() {
		String userCnName = null;
		PermUser loginUser = this.getLoginUser();
		if (loginUser != null) {
			userCnName = loginUser.getRealName();
		}
		return userCnName;
	}

	/**
	 * 根据产品经理姓名模糊查询产品经理列表
	 *
	 * @param name
	 * @return
	 */
	@RequestMapping(value = "/findMangement")
	@ResponseBody
	public JSONArray findMangement(String name) {
		List<PermUser> list = permUserServiceAdapter.findPermUser(name);
		// 组装查询条件
		// 组装JSON数据
		JSONArray jsonArray = new JSONArray();
		if (null != list && !list.isEmpty()) {
			for (PermUser permUser : list) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("email", permUser.getEmail());
				// 产品经理的id
				jsonObject.put("id", permUser.getUserId());
				// 产品经理的姓名
				jsonObject.put("name", permUser.getRealName());
				jsonArray.add(jsonObject);
			}
		}
		// 返回JSON数据
		return jsonArray;
	}

	/**
	 * 根据供应商的姓名模糊查询供应商的列表
	 *
	 * @param name
	 * @return
	 */
	@RequestMapping(value = "/findSuppSupplier")
	@ResponseBody
	public JSONArray findsuppSupplierByName(String name) {
		List<SuppSupplier> list = MiscUtils.autoUnboxing( suppSupplierService.findSuppSupplierByLimName(name) );
		// 组装查询条件
		// 组装JSON数据
		JSONArray jsonArray = new JSONArray();
		if (null != list && !list.isEmpty()) {
			for (SuppSupplier suppSupplier : list) {
				JSONObject jsonObject = new JSONObject();
				// 产品供应商的id
				jsonObject.put("id", suppSupplier.getSupplierId());
				// 产品供应商的姓名
				jsonObject.put("name", suppSupplier.getSupplierName());
				jsonArray.add(jsonObject);
			}
		}
		// 返回JSON数据
		return jsonArray;
	}

	/**
	 * 根据抄送人姓名自动模糊查询抄送人列表
	 *
	 * @param name
	 * @return
	 */
	@RequestMapping(value = "/findSend")
	@ResponseBody
	public JSONArray findSend(String name) {
		List<PermUser> list = permUserServiceAdapter.findPermUser(name);
		// 组装查询条件
		// 组装JSON数据
		JSONArray jsonArray = new JSONArray();
		if (null != list && !list.isEmpty()) {
			for (PermUser permUser : list) {
				JSONObject jsonObject = new JSONObject();
				// 抄送人id
				jsonObject.put("id", permUser.getUserId());
				// 抄送人姓名
				jsonObject.put("name", permUser.getRealName());
				// 抄送人email
				jsonObject.put("email", permUser.getEmail());
				jsonArray.add(jsonObject);
			}
		}
		// 返回JSON数据
		return jsonArray;
	}

	/**
	 * 查找是否有冲突的
	 * 
	 * @param id
	 * @param endDate
	 * @return
	 */
	@RequestMapping(value = "/findConflict")
	@ResponseBody
	public Boolean findConflict(@RequestParam("id") Long id, @RequestParam("endDate") Date endDate) {
		int count = resPrecontrolPolicyService.findDelaySameTime(id, endDate);
		return count > 0 ? false : true;
	}

	/**
	 * ajax判断项目的名称是否重复
	 *
	 * @param name
	 * @return
	 */
	@RequestMapping(value = "/findresPrecontrolPolicyName")
	@ResponseBody
	public String findresPrecontrolPolicyName(String name) {
		JSONObject jason = new JSONObject();
		ResPrecontrolPolicy resPrecontrolPolicy = resPrecontrolPolicyService.findByName(name);
		if (resPrecontrolPolicy != null) {
			jason.put("name", "N");
			return jason.toString();
		} else
			jason.put("name", "Y");
		return jason.toString();
	}

	/**
	 * 展示编辑预控的界面
	 *
	 * @param model
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/goToEditResPrecontrolPolicy/view")
	public String editResPrecontrolPolicy(Model model, Long id, Integer page, HttpServletRequest req) {
		ResPrecontrolPolicy resPrecontrolPolicy = resPrecontrolPolicyService.findResPrecontrolPolicyById(id);
		Long num = 0L;
		// 查询剩余量的表
		if (resPrecontrolPolicy.getControlType()
				.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
			resPrecontrolPolicy.setAmount(divNumber(resPrecontrolPolicy.getAmount()));
			resPrecontrolPolicy.setOriginAmount(divNumber(resPrecontrolPolicy.getOriginAmount()));
		}
		// 通过资源策略id查询所有的抄送人
		String productManagerEmail = null;
		List<ResPrecontrolWarmReceiver> resPrecontrolWarmReceiverList = resPrecontrolWarmReceiverService
				.findListByResPrecontrolPolicyId(resPrecontrolPolicy.getId());
		List<ResPrecontrolWarmReceiver> list = new ArrayList<ResPrecontrolWarmReceiver>();
		for (ResPrecontrolWarmReceiver resPrecontrolWarmReceiver : resPrecontrolWarmReceiverList) {
			if (!resPrecontrolWarmReceiver.getReceiverId().equals(resPrecontrolPolicy.getProductManagerId())) {
				list.add(resPrecontrolWarmReceiver);
			}
			productManagerEmail = resPrecontrolWarmReceiver.getEmail();
		}
		// 查询规则关系表
		List<ResPrecontrolWarmOption> resPrecontrolWarmOptionList = resPrecontrolWarmOptionService
				.findListByResPrecontrolPolicyId(resPrecontrolPolicy.getId());
		// 查找提醒规则表
		List<ResWarmRule> resWarmRuleList = new ArrayList<ResWarmRule>();
		for (ResPrecontrolWarmOption resPrecontrolWarmOption : resPrecontrolWarmOptionList) {
			ResWarmRule resWarmRule = resWarmRuleService.findResWarmRuleById(resPrecontrolWarmOption.getWarmRuleId());
			resWarmRuleList.add(resWarmRule);
		}
		// 规则去重
		Map<Long, ResWarmRule> map = new HashMap<Long, ResWarmRule>();
		for (ResWarmRule resWarmRule : resWarmRuleList) {
			map.put(resWarmRule.getId(), resWarmRule);
		}
		List<ResWarmRule> resWarmRuleRealList = new ArrayList<ResWarmRule>();
		for (Map.Entry<Long, ResWarmRule> entry : map.entrySet()) {
			resWarmRuleRealList.add(entry.getValue());
		}
		model.addAttribute("productManagerEmail", productManagerEmail);
		model.addAttribute("resPrecontrolPolicy", resPrecontrolPolicy);
		model.addAttribute("resWarmRuleList", resWarmRuleRealList);
		model.addAttribute("resPrecontrolWarmReceiverList", list);
		// 查询子预控
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("precontrolPolicyId", id);
		int count = resPrecontrolPolicyItemService.selectCountByParams(params);
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		params.put("_start", pageParam.getStartRows());
		params.put("_end", pageParam.getEndRows());
		params.put("_orderby", "POLICY_ITEM_ID");
		params.put("_order", "DESC");
		List<ResPrecontrolPolicyItem> itemlist = resPrecontrolPolicyItemService.selectListByParams(params);
		if (itemlist != null && itemlist.size() > 0) {
			for (ResPrecontrolPolicyItem item : itemlist) {
				if (item.getItemControlType()
						.equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
					item.setQuantity(divNumber(item.getQuantity()));
				}
			}
		}
		pageParam.setItems(itemlist);
		model.addAttribute("pageParam", pageParam);
		if (ResControlEnum.CONTROL_STATE.New.name().equals(resPrecontrolPolicy.getState())) {
			log.info("new");
			return "/res/resource_edit_control_new";
		} else {
			log.info("old");
			return "/res/resource_edit_control";
		}
	}

	/**
	 * Delete resource control by id logically
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping("/deleteResouceControl")
	@ResponseBody
	@Transactional
	public String deleteResouceControlById(Long id) {
		StringBuffer sb = new StringBuffer("{\"code\":");
		ResPrecontrolPolicy p = resPrecontrolPolicyService.findResPrecontrolPolicyById(id);
		if (null == p) {
			sb.append("0, \"msg\":\"未查询到预控品项!\"");
		} else {
			if (null != p.getState() && p.getState().equals(ResControlEnum.CONTROL_STATE.New.toString())) { // state
																											// is
																											// 'New'
				if (resPrecontrolPolicyService.deleteResPreControlPolicyById(id) > 0) { // delete
																						// from
																						// res_precontrol_policy
					resPrecontrolAmountService.deleteByPolicyId(id); // delete
																		// from
																		// res_precontrol_amount
					resPrecontrolInventoryService.deleteByPolicyId(id); // delete
																		// from
																		// res_precontrol_inventory
					resPrecontrolBindGoodsService.deleteByPolicyId(id); // delete
																		// from
																		// res_precontrol_bind_goods
					// delete warm receiver
					resPrecontrolWarmReceiverService.deteteResPrecontrolWarmReceiver(id);
					// delete warm rule
					resPrecontrolWarmOptionService.deleteResPrecontrolWarmOption(id);
					// delete item data
					resPrecontrolPolicyItemService.deleteByPolicyId(id);
					// delete payment date
					resPrecontrolPaymentService.deleteByPolicyId(id);
				}
				sb.append("1, \"msg\":\"删除成功\"");
			} else {
				sb.append("0, \"msg\":\"状态需要为 [ 新建 ] 才可以删除!\"");
			}
		}
		sb.append("}");
		try {
			// 保存操作日志
			comLogService.insert(COM_LOG_OBJECT_TYPE.RES_PRECONTROL_POLICY_POLICY, id, id,
					this.getLoginUser().getUserName(), "删除资源预控ID" + id,
					COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name(), "删除资源预控", null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name());
			log.error(e.getMessage());
		}
		return sb.toString();
	}

	/**
	 * freeze resource control by id
	 * 
	 * @param id
	 * @return
	 * @throws ParseException
	 */
	@SuppressWarnings("static-access")
	@RequestMapping("/freezeResouceControl")
	@ResponseBody
	@Transactional
	public String freezeResouceControlById(Long id) throws ParseException {
		StringBuffer sb = new StringBuffer("{\"code\":");
		ResPrecontrolPolicy p = resPrecontrolPolicyService.findResPrecontrolPolicyById(id);
		if (null == p) {
			sb.append("0, \"msg\":\"未查询到预控品项!\"");
		} else {
			if (null != p.getState() && p.getState().equals(ResControlEnum.CONTROL_STATE.InUse.toString())) { // state
																												// is
																												// 'InUse'
				// change state to 'Termination''
				Map<String, String> params = new HashMap<String, String>();
				params.put("id", String.valueOf(id));
				params.put("state", ResControlEnum.CONTROL_STATE.Termination.toString());
				this.resPrecontrolPolicyService.updateStateById(params);
				Map<String, Long> paramsMap = new HashMap<String, Long>();
				paramsMap.put("precontrolPolicyId", id);
				List<ResPrecontrolBindGoods> goods = this.resPrecontrolBindGoodsService
						.findResPrecontrolBindGoodsPlus(paramsMap);
				List<Long> goodsList = new ArrayList<Long>();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				if (CollectionUtils.isNotEmpty(goods)) {
					for (ResPrecontrolBindGoods good : goods) {
						goodsList.add(good.getGoodsId());
					}
					List<Date> visitDate = DateUtil.getDateList(p.getTradeEffectDate(), p.getTradeExpiryDate());
					List<Date> dateList = new ArrayList<Date>();
					if (CollectionUtils.isNotEmpty(visitDate)) {
						for (Date date : visitDate) {
							dateList.add(sdf.parse(sdf.format(date)));
						}
					}
					for (Long goodsId : goodsList) {
						for (Date date : dateList) {
							String key = "PRE_CONTROL_" + goodsId + "_" + sdf.format(date);
							MemcachedUtil.getInstance().remove(key);
						}
					}
				}
				ResPrecontrolJob job = new ResPrecontrolJob();
				job.setCreateDate(new Date());
				job.setPrecontrolPolicyId(p.getId());
				job.setTaskType(ResControlEnum.CONTROL_STATE.Termination.toString());
				this.resPrecontrolJobService.save(job);
				LOG.info("freezeResouceControlById ====success ===== " + id);
				sb.append("1, \"msg\":\"终止成功\"");
			} else {
				sb.append("0, \"msg\":\"状态需要为 [ 启用 ] 才可以终止!\"");
			}
		}
		sb.append("}");
		try {
			// 保存操作日志
			comLogService.insert(COM_LOG_OBJECT_TYPE.RES_PRECONTROL_POLICY_POLICY, id, id,
					this.getLoginUser().getUserName(), "终止资源预控ID" + id,
					COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name(), "终止资源预控", null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name());
			log.error(e.getMessage());
		}
		return sb.toString();
	}

	/**
	 * recover resource control by id
	 * 
	 * @param id
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping("/recoverResouceControl")
	@ResponseBody
	@Transactional
	public String recoverResouceControlById(Long id) throws ParseException {
		StringBuffer sb = new StringBuffer("{\"code\":");
		ResPrecontrolPolicy p = resPrecontrolPolicyService.findResPrecontrolPolicyById(id);
		if (null == p) {
			sb.append("0, \"msg\":\"未查询到预控品项!\"");
		} else {
			if (null != p.getState() && p.getState().equals(ResControlEnum.CONTROL_STATE.Termination.toString())) { // state
																													// is
																													// 'InUse'
				// change state to 'Termination''
				Map<String, String> params = new HashMap<String, String>();
				params.put("id", String.valueOf(id));
				params.put("state", ResControlEnum.CONTROL_STATE.InUse.toString());
				// check out same resouceControl
				int sameNum = this.resPrecontrolPolicyService.findSameTimeInUsePreControlPolicy(id);
				if (sameNum > 0) {
					sb.append("2, \"msg\":\"有" + sameNum + "个预控在相同时间区间内冲突不能恢复\"");
					sb.append("}");
					return sb.toString();
				}
				this.resPrecontrolPolicyService.updateStateById(params);
				Map<String, Long> paramsMap = new HashMap<String, Long>();
				paramsMap.put("precontrolPolicyId", id);
				List<ResPrecontrolBindGoods> goods = this.resPrecontrolBindGoodsService
						.findResPrecontrolBindGoodsPlus(paramsMap);
				List<Long> goodsList = new ArrayList<Long>();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				if (CollectionUtils.isNotEmpty(goods)) {
					for (ResPrecontrolBindGoods good : goods) {
						goodsList.add(good.getGoodsId());
					}
					List<Date> visitDate = DateUtil.getDateList(p.getTradeEffectDate(), p.getTradeExpiryDate());
					List<Date> dateList = new ArrayList<Date>();
					if (CollectionUtils.isNotEmpty(visitDate)) {
						for (Date date : visitDate) {
							dateList.add(sdf.parse(sdf.format(date)));
						}
					}
					for (Long goodsId : goodsList) {
						for (Date date : dateList) {
							String key = "PRE_CONTROL_" + goodsId + "_" + sdf.format(date);
							MemcachedUtil.getInstance().remove(key);
						}
					}
				}
				ResPrecontrolJob job = new ResPrecontrolJob();
				job.setCreateDate(new Date());
				job.setPrecontrolPolicyId(p.getId());
				job.setTaskType(ResControlEnum.CONTROL_STATE.InUse.toString());
				this.resPrecontrolJobService.save(job);
				LOG.info("recoverResouceControl ====success ===== " + id);
				sb.append("1, \"msg\":\"恢复成功\"");
			} else {
				sb.append("0, \"msg\":\"状态需要为 [ 终止 ] 才可以恢复!\"");
			}
		}
		sb.append("}");
		try {
			// 保存操作日志
			comLogService.insert(COM_LOG_OBJECT_TYPE.RES_PRECONTROL_POLICY_POLICY, id, id,
					this.getLoginUser().getUserName(), "恢复资源预控ID" + id,
					COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name(), "启用资源预控", null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name());
			log.error(e.getMessage());
		}
		return sb.toString();
	}

	/**
	 * 抽出数据除以100
	 *
	 * @param first
	 * @param num
	 * @return
	 */
	public Long divNumber(long first) {
		return first / 100;
	}

	/**
	 * 抽出数据乘以100
	 *
	 */
	public Long mulNumber(long first) {
		return first * 100;
	}

	/**
	 * Delete resource control by id logically
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping("/ajaxunBindGoods")
	@ResponseBody
	@Transactional
	public String unBindPolicyGoods(Long goodsId, Long policyId) {
		StringBuffer sb = new StringBuffer("{\"code\":");
		ResPrecontrolPolicy p = resPrecontrolPolicyService.findResPrecontrolPolicyById(policyId);
		try {
			if (null == p) {
				sb.append("0, \"msg\":\"未查询到预控品项!\"");
			} else {
				List<Long> goodsList = new ArrayList<Long>();
				goodsList.add(goodsId);
				List<Date> visitDate = DateUtil.getDateList(p.getTradeEffectDate(), p.getTradeExpiryDate());
				List<Date> dateList = new ArrayList<Date>();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				if (CollectionUtils.isNotEmpty(visitDate)) {
					for (Date date : visitDate) {
						dateList.add(sdf.parse(sdf.format(date)));
					}
				}
				ResultHandleT<Integer> resultT = comPushClientService.pushTimePrice(goodsList, dateList,
						ComIncreament.DATA_SOURCE_TYPE.CAL_BUSNINESS_DATA_JOB, true);
				Integer result = resultT.getReturnContent();
				int deleteResult = resPrecontrolBindGoodsService.deletePrecontrolBindGoodsByPolicyIdAndGoodsId(policyId,
						goodsId);
				log.info("deleteResult===========success===" + deleteResult + "===goodsId=" + goodsId + "  policyId="
						+ policyId);
				if (result > 0) {
					for (Long id : goodsList) {
						for (Date date : dateList) {
							String key = "PRE_CONTROL_" + id + "_" + sdf.format(date);
							MemcachedUtil.getInstance().remove(key);
						}
					}
				}
				sb.append("1, \"msg\":\"解绑成功成功\"");
				log.info("unBindPolicyGoods===========success======goodsId=" + goodsId + "  policyId=" + policyId);
			}
			sb.append("}");
			Map<String, Object> paramsMap = new HashMap<String, Object>();
			paramsMap.put("precontrolPolicyId", policyId);
			Long countBind = resPrecontrolGoodsHotelAdapterService.getTotalBindGoodsCount(paramsMap);
			if (countBind == null || countBind == 0L) {
				// 没有绑定商品 状态变为new
				Map<String, String> params = new HashMap<String, String>();
				params.put("id", String.valueOf(policyId));
				params.put("state", ResControlEnum.CONTROL_STATE.New.toString());
				resPrecontrolPolicyService.updateStateById(params);
			}
			// 保存操作日志
			comLogService.insert(COM_LOG_OBJECT_TYPE.RES_PRECONTROL_POLICY_POLICY, policyId, policyId,
					this.getLoginUser().getUserName(), "解绑预控ID" + policyId + "解绑商品ID=" + goodsId,
					COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name(), "解绑资源预控商品", null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name());
			log.error(e.getMessage());
			sb.append("0, \"msg\":\"解绑失败!\"");
			log.info("unBindPolicyGoods===========error======goodsId=" + goodsId + "  policyId=" + policyId);
		}
		return sb.toString();
	}

	/**
	 * 
	 * 批量解绑
	 * 
	 * @param suppGoodsIds
	 *            商品ID集合
	 */
	@RequestMapping("/unBindSuppGoods")
	@ResponseBody
	@Transactional
	public String batchUnbindSuppGoods(Long[] suppGoodsIds, Long[] productIds, Long supplierId, Long policyId,
			Model model) {
		StringBuffer sb = new StringBuffer("{\"code\":");
		ResPrecontrolPolicy policy = resPrecontrolPolicyService.findResPrecontrolPolicyById(policyId);
		boolean status = false;
		try {
			if (null == policy) {
				sb.append("0, \"msg\":\"未查询到预控品项!\"");
			} else {
				List<Long> goodsList = new ArrayList<Long>();
				List<Date> dateList = new ArrayList<Date>();
				Map<String, Object> paramsMap = new HashMap<String, Object>();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				List<Date> visitDate = DateUtil.getDateList(policy.getTradeEffectDate(),policy.getTradeExpiryDate());
				Date currentDate = new Date();
				String currentDateStr = sdf.format(currentDate);
				Date parseCurrentDate = sdf.parse(currentDateStr);
				if (CollectionUtils.isNotEmpty(visitDate)) {
					for (Date date : visitDate) {
						dateList.add(sdf.parse(sdf.format(date)));
					}
				}
				for (Long goodsId : suppGoodsIds) {
					goodsList.clear();
					goodsList.add(goodsId);
					ResultHandleT<Integer> resultT = comPushClientService.pushTimePrice(goodsList, dateList,
							ComIncreament.DATA_SOURCE_TYPE.CAL_BUSNINESS_DATA_JOB, true);
					//解绑
					int deleteResult = resPrecontrolBindGoodsService.deletePrecontrolBindGoodsByPolicyIdAndGoodsId(policyId, goodsId);
					log.info("deleteResult===========success===" + deleteResult + "===goodsId=" + goodsId + "  policyId=" + policyId);
					if (deleteResult == 1) {
						for (Date date : dateList) {
							if(date.getTime() >= parseCurrentDate.getTime()){
								String key = "PRE_CONTROL_" + goodsId + "_" + sdf.format(date);
								boolean  b = MemcachedUtil.getInstance().remove(key);
								log.info("removeMemcachedkey:"+key+",result:"+b);
							}
						}
						status = true; // 解绑成功
					}
					paramsMap.clear();
					paramsMap.put("precontrolPolicyId", policyId);
					Long countBind = resPrecontrolGoodsHotelAdapterService.getTotalBindGoodsCount(paramsMap);
					if (countBind == null || countBind == 0L) {
						// 没有绑定商品 状态变为new
						Map<String, String> params = new HashMap<String, String>();
						params.put("id", String.valueOf(policyId));
						params.put("state", ResControlEnum.CONTROL_STATE.New.toString());
						resPrecontrolPolicyService.updateStateById(params);
					}
					// 保存操作日志
					comLogService.insert(COM_LOG_OBJECT_TYPE.RES_PRECONTROL_POLICY_POLICY, policyId, policyId,
							this.getLoginUser().getUserName(), "解绑预控ID" + policyId + "解绑商品ID=" + goodsId,
							COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name(), "解绑资源预控商品", null);
				}
				if (status) {
					sb.append("1, \"msg\":\"解绑成功!\"");
				}
			}
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name());
			log.error(e.getMessage());
			sb.append("0, \"msg\":\"解绑失败!\"");
		}
		sb.append("}");
		return sb.toString();
	}

	private List<ResPrecontrolOrderVo> queryOrderItem(Long currentPage, Long pageSize, Long totalSize, Long goods_id,
			Date tradeEffectDate, Date tradeExpiryDate) {
		Page<ResPrecontrolOrderVo> page = new Page<ResPrecontrolOrderVo>();
		page.setCurrentPage(currentPage);
		page.setPageSize(pageSize);
		page.setTotalResultSize(totalSize);
		ResPrecontrolOrderVo vo = new ResPrecontrolOrderVo();
		vo.setTradeEffectDate(tradeEffectDate);
		vo.setTradeExpiryDate(tradeExpiryDate);
		vo.setSuppGoodsId(goods_id);
		page.setParam(vo);
		List<ResPrecontrolOrderVo> resPrecontrolOrderVoList = orderService.findPercontrolGoodsOrderList(page);
		for (ResPrecontrolOrderVo orderVo : resPrecontrolOrderVoList) {
			Long orderId = orderVo.getOrderId();
			Map<String, Object> paramPack = new HashMap<String, Object>();
			paramPack.put("orderId", orderId);// 订单号
			List<OrdOrderPack> orderPackList = orderService.findOrdOrderPackList(paramPack);
			if (!orderPackList.isEmpty()) {
				OrdOrderPack ordOrderPack = orderPackList.get(0);
				ProdProduct prodProduct = MiscUtils.autoUnboxing( prodProductService.findProdProductById(ordOrderPack.getProductId()) );
				orderVo.setProductName(prodProduct.getProductName());
			}
			// 获取子单营业额
			Long orderItemSalesAmount = getOrderItemSalesAmount(orderVo);
			// 设置买断子单营业额
			orderVo.setOrderItemSalesAmount(orderItemSalesAmount);
			// 获取成人数、儿童数
			populateAdultOrChildNum(orderVo);
		}
		return resPrecontrolOrderVoList;
	}

	private Boolean checkUserOrderMulPriceList(Long categoryId) {
		return BizEnum.BIZ_CATEGORY_TYPE.category_sightseeing.getCategoryId().equals(categoryId)
				|| BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCategoryId().equals(categoryId)
				|| BizEnum.BIZ_CATEGORY_TYPE.isCategoryTrafficRouteFreedom(categoryId)
				|| BizEnum.BIZ_CATEGORY_TYPE.category_route_local.getCategoryId().equals(categoryId)
				|| BizEnum.BIZ_CATEGORY_TYPE.category_route_customized.getCategoryId().equals(categoryId)
				|| BizEnum.BIZ_CATEGORY_TYPE.category_traffic_aero_other.getCategoryId().equals(categoryId)
				|| BizEnum.BIZ_CATEGORY_TYPE.category_cruise.getCategoryId().equals(categoryId);
	}

	private Long getOrderItemSalesAmount(ResPrecontrolOrderVo orderVo) {
		Long mainOrderSaleAmount = 0L;
		List<OrdOrderItem> orderItemList = orderService.queryOrderItemByOrderId(orderVo.getOrderId());
		if (orderItemList != null && orderItemList.size() > 0) {
			for (OrdOrderItem orderItem : orderItemList) {
				mainOrderSaleAmount += orderItem.getQuantity() * orderItem.getPrice();
			}
		}
		Long itemHotelSalesAmount = 0L;
		List<OrdOrderHotelTimeRate> hotelList = orderService.queryOrderHotelTimeRate(orderVo.getOrderItemId());
		if (hotelList != null && hotelList.size() > 0) {
			for (OrdOrderHotelTimeRate hotel : hotelList) {
				itemHotelSalesAmount += hotel.getQuantity() * hotel.getPrice();
			}
		}
		// 主单优惠券金额
		Long couponAmount = 0L;
		List<MarkCouponUsage> couponList = orderService.queryMarkCouponUsageByOrderId(orderVo.getOrderId());
		if (couponList != null && couponList.size() > 0) {
			for (MarkCouponUsage coupon : couponList) {
				couponAmount += coupon.getAmount();
			}
		}
		Long orderItemSalesAmount = 0L;
		Long refundedAmount = orderVo.getRefundedAmount() == null ? 0L : orderVo.getRefundedAmount();
		Long actualAmount = orderVo.getActualAmount() == null ? 0L : orderVo.getActualAmount();
		// 子单营业额=子单销售金额/主订单销售金额 * （实付金额+优惠卷金额-退款金额）
		// 单酒店
		if (orderVo.getOrderItemCategoryId() == 1) {
			orderItemSalesAmount = itemHotelSalesAmount / mainOrderSaleAmount
					* (actualAmount + couponAmount - refundedAmount);
		} else {
			orderItemSalesAmount = orderVo.getPrice() * orderVo.getQuantity() / mainOrderSaleAmount
					* (actualAmount + couponAmount - refundedAmount);
		}
		return orderItemSalesAmount;
	}

	private void populateAdultOrChildNum(ResPrecontrolOrderVo orderVo) {
		List<OrdMulPriceRate> mulPriceList = new ArrayList<OrdMulPriceRate>();
		boolean OrdMulPriceRate = checkUserOrderMulPriceList(orderVo.getOrderItemCategoryId());
		// 因为门店系统需每个品类的详细价格数据，此处逻辑影响子单价格信息展示 加此判断
		// 非原有存放数据品类不走遍历byOrdMulPriceRate 李志强 ---2017-03-20
		if (OrdMulPriceRate) {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("orderItemId", orderVo.getOrderItemId());
			mulPriceList = orderService.findOrdMulPriceRateList(param);
		}
		// 获取儿童数、成人数
		if (mulPriceList != null && mulPriceList.size() > 0) {
			Long adult = null;
			Long child = null;
			Long adultNum = null;
			Long childNum = null;
			Long allAdult = null;
			Long allChild = null;
			Long all = 0L;
			orderVo.setOrdMulPriceRateList(mulPriceList);
			for (OrdMulPriceRate ordMulPriceRate : mulPriceList) {
				if (ordMulPriceRate.getPriceType().equalsIgnoreCase("SETTLEMENT_ADULT_PRE")) {
					adult = ordMulPriceRate.getPrice();
					adultNum = ordMulPriceRate.getQuantity();
					if (adult != null && adultNum != null) {
						allAdult = adult * adultNum;
					}
				}
				if (ordMulPriceRate.getPriceType().equalsIgnoreCase("SETTLEMENT_CHILD_PRE")) {
					child = ordMulPriceRate.getPrice();
					childNum = ordMulPriceRate.getQuantity();
					if (child != null && childNum != null) {
						allChild = child * childNum;
					}
				}
			}
			orderVo.setBuyoutAdultNum(adultNum);
			orderVo.setBuyoutChildNum(childNum);
			if (allAdult != null) {
				all += allAdult;
			}
			if (allChild != null) {
				all += allChild;
			}
			// 设置多价格的买断总价
			orderVo.setTotal(all);
		}
	}
}
