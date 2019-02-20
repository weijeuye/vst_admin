
package com.lvmama.vst.back.control.web;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.ArrayUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.dubbo.common.utils.CollectionUtils;
import com.lvmama.finance.comm.vst.dto.PushHistoryResourceDTO;
import com.lvmama.finance.comm.vst.dto.SucceedCode;
import com.lvmama.finance.comm.vst.service.BudgetService;
import com.lvmama.precontrol.vo.VstOrderItemVo;
import com.lvmama.vst.back.biz.po.BizEnum;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsHotelAdapterClientService;
import com.lvmama.vst.back.client.ord.service.OrdOrderRouteClientService;
import com.lvmama.vst.back.client.ord.service.OrderService;
import com.lvmama.vst.back.client.precontrol.service.ResPreControlService;
import com.lvmama.vst.back.client.precontrol.service.ResPrecontrolBindGoodsClientService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.supp.service.SuppSupplierClientService;
import com.lvmama.vst.back.control.po.ResControlEnum;
import com.lvmama.vst.back.control.po.ResPreControlTimePrice;
import com.lvmama.vst.back.control.po.ResPrecontrolAmount;
import com.lvmama.vst.back.control.po.ResPrecontrolBindGoods;
import com.lvmama.vst.back.control.po.ResPrecontrolInventory;
import com.lvmama.vst.back.control.po.ResPrecontrolPolicy;
import com.lvmama.vst.back.control.service.ResPreControlTimePriceService;
import com.lvmama.vst.back.control.service.ResPrecontrolAmountService;
import com.lvmama.vst.back.control.service.ResPrecontrolBindGoodsService;
import com.lvmama.vst.back.control.service.ResPrecontrolGoodsService;
import com.lvmama.vst.back.control.service.ResPrecontrolInventoryService;
import com.lvmama.vst.back.control.service.ResPrecontrolPolicyService;
import com.lvmama.vst.back.control.vo.GoodsResPrecontrolPolicyVO;
import com.lvmama.vst.back.control.vo.HisResPrecontrolOrderVo;
import com.lvmama.vst.back.control.vo.ResPreControlTimePriceVO;
import com.lvmama.vst.back.control.vo.ResPrecontrolBindGoodsVo;
import com.lvmama.vst.back.control.vo.ResPrecontrolGoodsVo;
import com.lvmama.vst.back.control.vo.ResPrecontrolOrderVo;
import com.lvmama.vst.back.control.vo.ResPrecontrolPolicyOrderVo;
import com.lvmama.vst.back.control.vo.ResPrecontrolPolicyVo;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.order.po.OrdMulPriceRate;
import com.lvmama.vst.back.order.po.OrdOrderItem;
import com.lvmama.vst.back.order.po.OrdOrderPack;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComLog;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.pub.service.PushAdapterServiceRemote;
import com.lvmama.vst.back.router.adapter.ResPrecontrolGoodsHotelAdapterService;
import com.lvmama.vst.back.supp.po.SuppSupplier;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comlog.LvmmLogClientService;
import com.lvmama.vst.comm.utils.DateUtil;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.IntersectionDate;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultHandle;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;

/**
 * 买断资源预控策略
 * Created by luoweiyi on 2015/11/11.
 */
@Controller
@RequestMapping("/percontrol")
public class ResPrecontrolAction extends BaseActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5761853157399558945L;

	private static final Integer PAGE_SIZE = 30;

	@Autowired
	private SuppSupplierClientService suppSupplierService;

	@Autowired
	private ResPreControlTimePriceService resPreControlTimeService;

	@Autowired
	private ResPrecontrolGoodsService resPrecontrolGoodsService;

	@Autowired
	private SuppGoodsClientService suppGoodsService;

	@Autowired
	private ResPrecontrolPolicyService resPrecontrolPolicyService;

	@Autowired
	private OrderService orderService;

	@Autowired
	private ResPrecontrolAmountService resPrecontrolAmountService;

	@Autowired
	private ResPrecontrolInventoryService resPrecontrolInventoryService;

	@Autowired
	private ComLogClientService comLogService;

	@Autowired
	private PushAdapterServiceRemote pushAdapterService;

	@Autowired
	private ResPreControlService resPreControlService;

	@Autowired
	private ProdProductService prodProductService;// 查询商品

	@Autowired
	private ProdLineRouteClientService lineRouteDateService;

	@Autowired
	private BudgetService budgetService;// 推送到财务历史资源

	@Autowired
	private ResPrecontrolBindGoodsService resPrecontrolBindGoodsService;

	// 日志写入es
	@Autowired
	private LvmmLogClientService lvmmLogClientService;

	@Autowired
	private ResPrecontrolGoodsHotelAdapterService resPrecontrolGoodsHotelAdapterService;

	@Autowired
	private SuppGoodsHotelAdapterClientService suppGoodsHotelAdapterService;


	@Autowired
	private OrdOrderRouteClientService  ordOrderRouteService;
	private static enum PushStatus {
		ERROR("推送失败"), OK("OK"), PartialOk("部分订单没推送成功，财务端不存在"), TimeNotNull("推送时间不能为空"), FirstPushTimeError(
				"推送时间只能小于上次推送时间.第一次推送小于预控生效时间"), GoodsIDPreControlIdNotNull("推送历史资源预控ID与商品ID不能为空");

		private String value;

		private PushStatus(String value) {
			this.value = value;
		}
	}

	/**
	 * 根据供应商得到已设置价格绑定的商品列表
	 * 
	 * @param model
	 * @param supplierId
	 * @return
	 */
	@RequestMapping("/suppGoods/index")
	public String percontrolGoodsListIndex(Model model, Long supplierId, Long policyId) {
		model.addAttribute("supplierId", supplierId);
		// 得到买断策略
		ResPrecontrolPolicy policy = resPrecontrolPolicyService.findResPrecontrolPolicyById(policyId);
		// 翻页第一页数据
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("supplierId", supplierId);
		paramsMap.put("precontrolPolicyId", policyId);
		Long unTotalBongCount = resPrecontrolGoodsHotelAdapterService.getTotalUnbindGoodsCount(paramsMap);
		setGoodsListToModel(model, 1L, PAGE_SIZE, unTotalBongCount, supplierId, false, null, policyId, null);
		// 获取供应商
		SuppSupplier suppSupplier = MiscUtils.autoUnboxing( suppSupplierService.findSuppSupplierById(supplierId) );
		model.addAttribute("supplier", suppSupplier);
		model.addAttribute("policyId", policyId);
		model.addAttribute("policyName", policy.getName());
		return "/percontrol/suppGoods/index";
	}

	/**
	 * 商品列表翻页
	 * 
	 * @param model
	 * @param currentPage
	 * @param supplierId
	 * @param budgetFlag
	 * @return
	 */
	@RequestMapping("/suppGoods/goodsList")
	public String getResPercontrolGoodsList(Model model, Long currentPage, Long supplierId, Boolean budgetFlag, Long suppGoodsId,
			Long precontrolPolicyId, Long productId) {
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("supplierId", supplierId);
		paramsMap.put("suppGoodsId", suppGoodsId);
		paramsMap.put("productId", productId);
		paramsMap.put("precontrolPolicyId", precontrolPolicyId);
		Long totalCount = 0L;
		if (budgetFlag) {
			totalCount = resPrecontrolGoodsHotelAdapterService.getTotalBindGoodsCount(paramsMap);
		} else {
			totalCount = resPrecontrolGoodsHotelAdapterService.getTotalUnbindGoodsCount(paramsMap);
		}
		setGoodsListToModel(model, currentPage, PAGE_SIZE, totalCount, supplierId, budgetFlag, suppGoodsId, precontrolPolicyId, productId);
		return "/percontrol/suppGoods/suppGoods";
	}

	/**
	 * 推送买断历史资源订单到财务 财务仅仅是更新数据，重复推送其实无影响
	 * 
	 * @param pushDate
	 *            历史时间点，必须小于买断起始时间
	 * @return
	 */
	@RequestMapping(value = "/suppGoods/pushHistoryResource", produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String pushHistoryResource(Date pushDate, Date lastPushDate, long preControlPolicyID, long goodsID, Date saleEffectDate) {
		if (pushDate == null || lastPushDate == null || saleEffectDate == null)
			return PushStatus.TimeNotNull.value;
		if (pushDate.getTime() >= lastPushDate.getTime())
			return PushStatus.FirstPushTimeError.value;
		if (preControlPolicyID == 0 || goodsID == 0) {
			log.error(PushStatus.GoodsIDPreControlIdNotNull.value);
			return PushStatus.GoodsIDPreControlIdNotNull.value;
		}
		// 推送边界涵盖上一天遗漏订单
		long pushTime = lastPushDate.getTime();
		lastPushDate.setTime(pushTime + 3600 * 30 * 1000 * 30L);
		ResPreControlInner inner = new ResPreControlInner();
		PushStatus pushResult = inner.doPushInternal(preControlPolicyID, pushDate, lastPushDate, goodsID);
		boolean ok = PushStatus.OK == pushResult;
		boolean partialOK = PushStatus.PartialOk == pushResult;
		if (ok || partialOK)
			inner.setVstOrderItemBudgetFlag(preControlPolicyID, pushDate, lastPushDate, goodsID);
		return pushResult.value;
	}

	@RequestMapping(value = "/gotoPushHistoryOrder/view")
	public String gotoPushHistoryOrder() {
		// return "/res/resource_push_hisorder";
		return "/res/history_data_additional_recording";
	}

	/**
	 * 弹出提示页面
	 * @return
	 */
	@RequestMapping(value = "/goToRemindMain/view")
	public String goToRemindMain() {
		return "/res/resource_add_remind";
	}
	/**
	 * 推送买断预控期内非买断订单 改为买断订单,并减少库存
	 * 
	 * @param policyIds
	 *            预控id集合(由","隔开，例如：10,12,13)
	 * @return
	 */
	@RequestMapping(value = "/suppGoods/pushHistoryOrder")
	@ResponseBody
	public String pushHistoryOrder(String policyId) {
		List<String> errorIds = new ArrayList<String>();// 新建的预控ID
		List<Long> notExistPolicyIds = new ArrayList<Long>();// 不存在的预控ID
		List<Long> newPolicyIds = new ArrayList<Long>();// 新建的预控ID
		List<Long> successPolicyIds = new ArrayList<Long>();// 成功推送预控ID
		StringBuffer sb = new StringBuffer("{\"code\":");
		if (null == policyId || "".equals(policyId.trim())) {
			sb.append("0, \"msg\":\"预控id不能为空!\"}");
			return sb.toString();
		}
		policyId = policyId.trim();
		List<Long> policyIds = new ArrayList<Long>();
		String[] idArr = policyId.split(",");
		for (int i = 0, j = idArr.length; i < j; i++) {
			try {
				Long pid = Long.valueOf(idArr[i]);
				if (pid < 0) {
					log.error("是负数," + idArr[i]);
					errorIds.add(idArr[i]);
					continue;
				}
				policyIds.add(pid);
			} catch (Exception e) {
				log.error("非数字类型，" + idArr[i]);
				errorIds.add(idArr[i]);
			}
		}
		for (int i = 0; i < policyIds.size(); i++) {
			Long prePolicyId = policyIds.get(i);
			if (prePolicyId == null) {
				continue;
			}
			ResPrecontrolPolicy resPrecontrolPolicy = resPrecontrolPolicyService.findResPrecontrolPolicyById(prePolicyId);
			if (null == resPrecontrolPolicy || (null != resPrecontrolPolicy.getIsDeleted() && resPrecontrolPolicy.getIsDeleted() == 1)) {
				notExistPolicyIds.add(prePolicyId);
				continue;
			}
			if (resPrecontrolPolicy.getState().equals(ResControlEnum.CONTROL_STATE.New.toString())) {
				newPolicyIds.add(prePolicyId);
				continue;
			}
			successPolicyIds.add(prePolicyId);
			// 推送订单（更新vst非买断订单为买断订单、更新库存）
			ResPreControlInner inner = new ResPreControlInner();
			PushStatus pushResult = inner.doPushInternalOrder(resPrecontrolPolicy);
		}
		// 返回处理信息
		String result = "共成功推送" + successPolicyIds.size() + "个买断预控;" + "\\n";
		if (!CollectionUtils.isEmpty(notExistPolicyIds)) {
			String temp = "";
			for (int i1 = 0; i1 < notExistPolicyIds.size(); i1++) {
				if (i1 < notExistPolicyIds.size() - 1) {
					temp += notExistPolicyIds.get(i1) + ",";
				} else {
					temp += notExistPolicyIds.get(i1);
				}
			}
			result += "其中" + temp + "资源预控不存在;" + "\\n";
		}
		if (!CollectionUtils.isEmpty(newPolicyIds)) {
			String temp = "";
			for (int i2 = 0; i2 < newPolicyIds.size(); i2++) {
				if (i2 < newPolicyIds.size() - 1) {
					temp += newPolicyIds.get(i2) + ",";
				} else {
					temp += newPolicyIds.get(i2);
				}
			}
			result += "其中" + temp + "为新建状态，不符合推送要求;" + "\\n";
		}
		if (!CollectionUtils.isEmpty(errorIds)) {
			String temp = "";
			for (int i2 = 0; i2 < errorIds.size(); i2++) {
				if (i2 < errorIds.size() - 1) {
					temp += errorIds.get(i2) + ",";
				} else {
					temp += errorIds.get(i2);
				}
			}
			result += "其中" + temp + "不是正确的ID类型;" + "\\n";
		}
		sb.append("1, \"msg\":\"" + result + "\"");
		sb.append("}");
		return sb.toString();
	}

	/**
	 * 历史数据补录校验
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @param goodsId
	 *            商品ID
	 * @param resId
	 *            资源预控策略ID
	 * @param startDate
	 *            补录开始时间
	 * @param endDate
	 *            b补录结束时间
	 * @return
	 */
	@RequestMapping("/checkHistoryDataAdditionalRecoding")
	@ResponseBody
	public Object checkHistoryDataAdditionalRecoding(HttpServletRequest request, HttpServletResponse response, Model model, Long goodsId, Long resId,
			Date startDate, Date endDate, String rcType) {
		try {
			StringBuffer sb = new StringBuffer();
			ResPrecontrolPolicy resPrecontrolPolicy = this.resPrecontrolPolicyService.findResPrecontrolPolicyById(resId);
			if (null == resPrecontrolPolicy) {
				sb.append("预控ID" + resId + "未找到对应的买断资源预控策略信息，不可进行补录");
				return new ResultHandle(sb.toString());
			}
			if (ResControlEnum.CONTROL_STATE_CN.Termination.name().equals(resPrecontrolPolicy.getState())) {
				sb.append("预控ID" + resId + "对应的买断资源预控策略状态已经终止，不可进行补录");
				return new ResultHandle(sb.toString());
			}
			if (ResControlEnum.CONTROL_STATE_CN.Expired.name().equals(resPrecontrolPolicy.getState())) {
				sb.append("预控ID" + resId + "对应的买断资源预控策略状态已经过期，不可进行补录");
				return new ResultHandle(sb.toString());
			}
			// 游玩起日期
			Date tradeEffectDate = resPrecontrolPolicy.getTradeEffectDate();
			// 游玩止日期
			Date tradeExpiryDate = resPrecontrolPolicy.getTradeExpiryDate();
			// 补录时间必须在游玩起止时间内
			// 时间范围，取交集
			IntersectionDate intersectionDate = DateUtil.getIntersectionDate(tradeEffectDate, tradeExpiryDate, startDate, endDate);
			if (null == intersectionDate) {
				sb.append("商品ID" + goodsId + "的补录时间必须在预控ID"+resId+"的游玩起止时间范围内，请检查！");
				return new ResultHandle(sb.toString());
			}
			// 判断商品的价格是不是绑定价格
			SuppGoods suppGoods = MiscUtils.autoUnboxing(suppGoodsHotelAdapterService.findSuppGoodsById(goodsId) );
			// bindGoods已绑定商品补录
			if ("bindGoods".equals(rcType)) {
				Map<String, Object> paramMap = new HashMap<>();
				paramMap.put("goodsId", goodsId);
				paramMap.put("policyId", resId);
				Long countByGoodsIdAndPrecontrolId = this.resPrecontrolBindGoodsService.getCountByGoodsIdAndPrecontrolId(paramMap);
				if (countByGoodsIdAndPrecontrolId == 0) {
					sb.append("该商品ID" + goodsId + "不属于该资源预控商品");
					return new ResultHandle(sb.toString());
				}
				if(null == suppGoods){
					sb.append("商品ID" + goodsId + "找不到对应的商品信息");
					return new ResultHandle(sb.toString());
				}
				String cancelFlag = suppGoods.getCancelFlag();
				if("N".equals(cancelFlag)){
					sb.append("商品ID" + goodsId + "是无效商品，不可在已绑定商品补录");
					return new ResultHandle(sb.toString());
				}
			}else{
				if(null == suppGoods){
					sb.append("商品ID" + goodsId + "找不到对应的商品信息");
					return new ResultHandle(sb.toString());
				}
				String cancelFlag = suppGoods.getCancelFlag();
				if("Y".equals(cancelFlag)){
					sb.append("商品ID" + goodsId + "是有效商品，不可在无效商品补录");
					return new ResultHandle(sb.toString());
				}
			}
		} catch (Exception e) {
			log.error("历史数据补录校验", e);
			return new ResultHandle("历史数据补录校验异常：" + e.getMessage());
		}
		return new ResultHandle();
	}

	/**
	 * 历史数据补录提交
	 * 
	 * @param model
	 * @param resPrecontrolBindGoodsVos
	 * @return
	 */
	@RequestMapping("/historyDataAditionalRecording")
	@ResponseBody
	public Object historyDataAditionalRecording(HttpServletRequest request, Model model, ResPrecontrolPolicyVo resPrecontrolPolicyVo) {
		StringBuffer sb = new StringBuffer();
		boolean isError = false;
		try {
			List<ResPrecontrolBindGoodsVo> resPrecontrolBindGoodsVos = resPrecontrolPolicyVo.getResPrecontrolBindGoodsVos();
			if (CollectionUtils.isEmpty(resPrecontrolBindGoodsVos)) {
				return new ResultHandle("历史数据补录的数据不能为空");
			}
			// 补录类型
			String arType = resPrecontrolPolicyVo.getArType();
			for (ResPrecontrolBindGoodsVo resPrecontrolBindGoodsVo : resPrecontrolBindGoodsVos) {
				// 资源预控策略ID
				Long precontrolPolicyId = resPrecontrolBindGoodsVo.getPrecontrolPolicyId();
				// 商品ID
				Long goodsId = resPrecontrolBindGoodsVo.getGoodsId();
				// 补录开始时间
				Date startDate = resPrecontrolBindGoodsVo.getStartDate();
				// 补录结束时间
				Date endDate = resPrecontrolBindGoodsVo.getEndDate();
				// 根据资源预控策略ID主键查询资源预控策略信息
				ResPrecontrolPolicy resPrecontrolPolicy = this.resPrecontrolPolicyService.findResPrecontrolPolicyById(precontrolPolicyId);
				if (null == resPrecontrolPolicy) {
					sb.append("预控ID" + precontrolPolicyId + "未找到对应的买断资源预控策略信息，不可进行补录");
					isError = true;
				}
				String state = resPrecontrolPolicy.getState();
				if (ResControlEnum.CONTROL_STATE_CN.Termination.name().equals(state)) {
					sb.append("预控ID" + precontrolPolicyId + "对应的买断资源预控策略状态已经终止，不可进行补录");
					isError = true;
				}
				if (ResControlEnum.CONTROL_STATE_CN.Expired.name().equals(state)) {
					sb.append("预控ID" + precontrolPolicyId + "对应的买断资源预控策略状态已经过期，不可进行补录");
					isError = true;
				}

				// 判断商品的价格是不是绑定价格
				SuppGoods suppGoods = MiscUtils.autoUnboxing( suppGoodsHotelAdapterService.findSuppGoodsById(goodsId) );
				// bindGoods已绑定商品补录
				if ("bindGoods".equals(arType)) {
					Map<String, Object> paramMap = new HashMap<>();
					paramMap.put("goodsId", goodsId);
					paramMap.put("policyId", precontrolPolicyId);
					Long countByGoodsIdAndPrecontrolId = this.resPrecontrolBindGoodsService.getCountByGoodsIdAndPrecontrolId(paramMap);
					if (countByGoodsIdAndPrecontrolId == 0) {
						sb.append("该商品ID" + goodsId + "不属于该资源预控商品");
						return new ResultHandle(sb.toString());
					}
					if(null == suppGoods){
						sb.append("商品ID" + goodsId + "找不到对应的商品信息");
						return new ResultHandle(sb.toString());
					}
					String cancelFlag = suppGoods.getCancelFlag();
					if("N".equals(cancelFlag)){
						sb.append("商品ID" + goodsId + "是无效商品，不可在已绑定商品补录");
						return new ResultHandle(sb.toString());
					}
				}else{
					if(null == suppGoods){
						sb.append("商品ID" + goodsId + "找不到对应的商品信息");
						return new ResultHandle(sb.toString());
					}
					String cancelFlag = suppGoods.getCancelFlag();
					if("Y".equals(cancelFlag)){
						sb.append("商品ID" + goodsId + "是有效商品，不可在无效商品补录");
						return new ResultHandle(sb.toString());
					}
				}
				if (isError) {
					return new ResultHandle(sb.toString());
				}
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("preControlPolicyID", precontrolPolicyId);
				List<Long> goodIds = new ArrayList<Long>();
				goodIds.add(goodsId);
				params.put("goodIds", goodIds);
				// 时间范围，取交集
				IntersectionDate intersectionDate = DateUtil.getIntersectionDate(resPrecontrolPolicy.getTradeEffectDate(),
						resPrecontrolPolicy.getTradeExpiryDate(), startDate, endDate);
				params.put("startDate", intersectionDate.getStartDate());
				params.put("endDate", intersectionDate.getEndDate());
				// 推送订单（更新vst非买断订单为买断订单、更新库存）
				ResPreControlInner inner = new ResPreControlInner();
				// 推送预控期内VST非买断订单为买断订单
				inner.doPushInternalOrderByGoodsId(params, resPrecontrolPolicy);
				// // 处理非酒店的vst订单
				// inner.dealNoHotelVstOrderByGoodsId(params,
				// resPrecontrolPolicy);
				// // 处理酒店vst订单
				// inner.dealHotelVstOrderByGoodsId(params,
				// resPrecontrolPolicy);
				try {
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					// 添加日志
					comLogService.insert(COM_LOG_OBJECT_TYPE.RES_PRECONTROL_POLICY_POLICY, precontrolPolicyId, precontrolPolicyId,
							this.getLoginUser().getUserName(),
							"商品ID：" + resPrecontrolBindGoodsVo.getGoodsId() + "，推送时间为：" + sdf.format(startDate)+" - "+sdf.format(endDate),
							COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_HDAR.name(), "历史数据补录", null);
				} catch (Exception e) {
					log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_HDAR.name());
					log.error("历史数据补录添加日志异常：", e);
				}
			}
		} catch (Exception e) {
			log.error("历史数据补录提交异常：", e);
			return new ResultHandle("历史数据补录提交异常：" + e.getMessage());
		}
		return new ResultHandle();
	}

	/**
	 * 商品绑定资源预控策略
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @param goodsId
	 *            商品ID
	 * @param productId
	 *            产品ID
	 * @param suppliedId
	 *            供应商ID
	 * @param policyId
	 *            资源预控策略ID
	 * @return
	 */
	@RequestMapping("/goodsBindResPrecontrol")
	@ResponseBody
	public Object goodsBindResPrecontrol(HttpServletRequest request, HttpServletResponse response, Model model, Long goodsId, Long productId,
			Long suppliedId, Long policyId) {
		StringBuffer errorMsgs = new StringBuffer();
		ResultHandle resultHandle = null;
		try {
			// 根据商品ID查询绑定预控资源数量
			Long countByGoodsId = this.resPrecontrolBindGoodsService.getCountByGoodsId(goodsId);
			if (countByGoodsId > 0) {
				Map<String, Object> paramMap = new HashMap<>();
				paramMap.put("goodsId", goodsId);
				paramMap.put("policyId", policyId);
				List<ResPrecontrolBindGoods> list = this.resPrecontrolBindGoodsService.selectByGoodsIdAndPrecontrolId(paramMap);
				// 修改商品绑定的资源预控策略记录
				if (CollectionUtils.isNotEmpty(list)) {
					ResPrecontrolBindGoods resPrecontrolBindGoods = list.get(0);
					resPrecontrolBindGoods.setPrecontrolPolicyId(policyId);
					this.resPrecontrolBindGoodsService.updateByPrimaryKeySelective(resPrecontrolBindGoods);
					return new ResultHandle();
				}
				// }
			}
			// 根据产品ID获取供应商产品信息
			SuppGoods suppGoods = suppGoodsService.findBaseSuppGoodsByProductId(productId);
			if (null == suppGoods) {
				errorMsgs.append("请先填写产品的供应商信息");
				resultHandle = new ResultHandle(errorMsgs.toString());
				return resultHandle;
			}
			ResPrecontrolBindGoods resPrecontrolBindGoods = new ResPrecontrolBindGoods();
			resPrecontrolBindGoods.setGoodsId(goodsId);
			resPrecontrolBindGoods.setPrecontrolPolicyId(policyId);
			resPrecontrolBindGoods.setSupplierId(suppGoods.getSupplierId());
			resPrecontrolBindGoods.setProductId(productId);
			this.resPrecontrolGoodsService.saveResPrecontrolBindGoods(resPrecontrolBindGoods);
		} catch (Exception e) {
			log.error("=======>goodsBindResPrecontrol Exception", e);
			// 商品在买断系统中已绑定预控项目，修改时只允许修改为已绑定的项目，不可选择其他预控项目
			errorMsgs.append("商品绑定资源预控策略异常");
			resultHandle = new ResultHandle(errorMsgs.toString());
			return resultHandle;
		}
		return new ResultHandle();
	}

	/**
	 * 绑定商品（游轮、签证，买断不做了）
	 * 
	 * @param suppGoodsIds
	 *            商品ID集合
	 */
	@RequestMapping("/suppGoods/bindSuppGoods")
	@ResponseBody
	public Object bindSuppGoods(HttpServletRequest req, HttpServletResponse res, Long[] suppGoodsIds, Long[] productIds, Long supplierId,
			Long policyId, Model model) {
		if (ArrayUtils.isEmpty(suppGoodsIds))
			return ResultMessage.ADD_FAIL_RESULT;
		List<String> errorMsg = new ArrayList<String>();
		List<Integer> suppGoodsIdIndexs = getCanBindSuppGoodsIndexs(suppGoodsIds, policyId, supplierId, errorMsg);
		if (CollectionUtils.isEmpty(suppGoodsIdIndexs)) {
			if (!CollectionUtils.isEmpty(errorMsg)) {
				String errorMsgs = "共绑定 " + suppGoodsIdIndexs.size() + " 件商品，其中\n";
				for (String error : errorMsg) {
					errorMsgs += error + "\n";
				}
				return new ResultMessage(ResultMessage.ERROR, errorMsgs);
			}
			return ResultMessage.ADD_FAIL_RESULT;
		}
		// 处理买断信息
		this.dealResPreControlTimePriceInfo(suppGoodsIds);
		StringBuilder str = new StringBuilder();
		for (Integer index : suppGoodsIdIndexs) {
			ResPrecontrolBindGoods resPrecontrolBindGoods = new ResPrecontrolBindGoods();
			resPrecontrolBindGoods.setProductId(productIds[index]);
			resPrecontrolBindGoods.setGoodsId(suppGoodsIds[index]);
			str.append("商品的ID   " + suppGoodsIds[index]);
			resPrecontrolBindGoods.setPrecontrolPolicyId(policyId);
			resPrecontrolBindGoods.setSupplierId(supplierId);
			resPrecontrolGoodsService.saveResPrecontrolBindGoods(resPrecontrolBindGoods);
			GoodsResPrecontrolPolicyVO vo = new GoodsResPrecontrolPolicyVO();
			ResPrecontrolPolicy p = resPrecontrolPolicyService.findResPrecontrolPolicyById(policyId);
			if (p != null) {
				vo.setAmount(p.getAmount());
				vo.setControlClassification(p.getControlClassification());
				vo.setControlType(p.getControlType());
				vo.setId(p.getId());
				vo.setIsCanDelay(p.getIsCanDelay());
				vo.setIsCanReturn(p.getIsCanReturn());
				vo.setName(p.getName());
				vo.setProductManagerId(p.getProductManagerId());
				vo.setProductManagerName(p.getProductManagerName());
				vo.setSaleEffectDate(p.getSaleEffectDate());
				vo.setSaleExpiryDate(p.getSaleExpiryDate());
				vo.setSupplierId(p.getSupplierId());
				vo.setSupplierName(p.getSupplierName());
				vo.setTradeEffectDate(p.getTradeEffectDate());
				vo.setTradeExpiryDate(p.getTradeExpiryDate());
				vo.setSuppGoodsId(suppGoodsIds[index]);
				resPreControlService.handleResPrecontrolSaledOut(vo, null, suppGoodsIds[index]);
			}
			pushAdapterService.push(suppGoodsIds[index], ComPush.OBJECT_TYPE.GOODS, ComPush.PUSH_CONTENT.SUPP_GOODS, ComPush.OPERATE_TYPE.VALID,
					ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
		}
		// update state to 'InUse'
		Map<String, String> params = new HashMap<String, String>();
		params.put("id", String.valueOf(policyId));
		params.put("state", ResControlEnum.CONTROL_STATE.InUse.toString());
		resPrecontrolPolicyService.updateStateById(params);
		try {
			// this.getLoginUser().getUserName()
			comLogService.insert(COM_LOG_OBJECT_TYPE.RES_PRECONTROL_POLICY_POLICY, policyId, policyId, this.getLoginUser().getUserName(),
					"绑定资源策略ID" + policyId + "供应商ID" + supplierId + str, COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name(), "绑定资源预控", null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name());
			log.error(e.getMessage());
		}
		if (!CollectionUtils.isEmpty(errorMsg)) {
			String errorMsgs = "共绑定 " + suppGoodsIdIndexs.size() + " 件商品，其中\n";
			for (String error : errorMsg) {
				errorMsgs += error + "\n";
			}
			return new ResultMessage(ResultMessage.SUCCESS, errorMsgs);
		}
		return ResultMessage.ADD_SUCCESS_RESULT;
	}

	// 处理商品买断信息
	private void dealResPreControlTimePriceInfo(Long[] suppGoodsIds) {
		SuppGoods goods = null;
		for (Long suppGoodId : suppGoodsIds) {
			goods = MiscUtils.autoUnboxing( suppGoodsService.findSuppGoodsById(suppGoodId, true) );
			if (goods == null)
				continue;
			List<Long> ids = new ArrayList<Long>();
			// 查询条件
			ResPreControlTimePrice resPre = new ResPreControlTimePrice();
			resPre.setCategoryId(goods.getCategoryId());
			resPre.setGoodsId(goods.getSuppGoodsId());
			List<ResPreControlTimePriceVO> list = resPreControlTimeService.queryPreControlTimePriceByParamChange(resPre);
			if (CollectionUtils.isNotEmpty(list)) {
				for (ResPreControlTimePrice resPreControlTimePrice : list) {
					if ("X".equals(resPreControlTimePrice.getPreSaleFlag())) {
						resPreControlTimePrice.setPreSaleFlag("Y");
						ids.add(resPreControlTimePrice.getId());
					}
				}
				if (CollectionUtils.isNotEmpty(ids)) {
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("ids", ids);
					params.put("preSaleFlag", "Y");
					resPreControlTimeService.updateResPrecontrolTimePrice(params);
				}
			}
		}
	}

	@RequestMapping("/suppGoods/searchBudgetGoodsCount")
	@ResponseBody
	public Long searchBudgetGoodsCount(Long suppGoodsId, Boolean budgetFlag, Long precontrolPolicyId) {
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("suppGoodsId", suppGoodsId);
		if (budgetFlag) {
			paramsMap.put("precontrolPolicyId", precontrolPolicyId);
			return resPrecontrolGoodsService.getTotalBindGoodsCount(paramsMap);
		} else {
			return resPrecontrolGoodsService.getTotalUnbindGoodsCount(paramsMap);
		}
	}

	/**
	 * 查看商品买断的订单
	 * 
	 * @param suppGoodsId
	 * @param policyId
	 */
	@RequestMapping("/suppGoods/getSuppGoodsBudgetOrder")
	public String getSuppGoodsBudgetOrder(Model model, Long suppGoodsId, Long policyId) {
		// 得到买断策略
		ResPrecontrolPolicy policy = resPrecontrolPolicyService.findResPrecontrolPolicyById(policyId);
		ResPrecontrolPolicyOrderVo policyVo = new ResPreControlInner().getResPrecontrolPolicyOrderVo(policy);

		Long totalCount = orderService.countPercontrolGoodsOrderList(suppGoodsId, policy.getTradeEffectDate(),
				policy.getTradeExpiryDate(), 1);

		setGoodsOrderListToModel(model, 1L, PAGE_SIZE, totalCount, policy, suppGoodsId);
		model.addAttribute("policy", policyVo);
		return "/percontrol/suppGoods/orderIndex";
	}

	/**
	 * 查看商品推送的历史的订单
	 * 
	 * @param model
	 * @param suppGoodsId
	 * @param policyId
	 * @return
	 */
	@RequestMapping("/suppGoods/getHistorySuppGoodsBudgetOrder")
	public String getHistorySuppGoodsBudgetOrder(Model model, long suppGoodsId, long preControlPolicyId) {
		if (suppGoodsId <= 0 || preControlPolicyId <= 0)
			return "预控ID，商品ID为空";
		new ResPreControlInner().setHistoryOrderUIModel(model, 1L, PAGE_SIZE, suppGoodsId, preControlPolicyId);
		return "/percontrol/suppGoods/orderIndex";
	}

	@RequestMapping("/suppGoods/historyOrderList")
	public String getPagenationBudgetHistoryOrderList(Model model, long currentPage, long totalCount, long suppGoodsId, long preControlPolicyId) {
		new ResPreControlInner().setHistoryOrderUIModelPagaination(model, currentPage, totalCount, PAGE_SIZE, suppGoodsId, preControlPolicyId);
		return "/percontrol/suppGoods/orderList";
	}

	/**
	 * 买断商品订单列表翻页
	 * 
	 * @param model
	 * @param currentPage
	 * @param suppGoodsId
	 * @param tradeEffectDate
	 * @param tradeExpiryDate
	 * @return
	 */
	@RequestMapping("/suppGoods/orderList")
	public String getPagenationBudgetOrderList(Model model, Long currentPage, Long suppGoodsId, String tradeEffectDate, String tradeExpiryDate,
			HttpServletRequest req) {
		ResPrecontrolPolicyOrderVo policy = new ResPrecontrolPolicyOrderVo();
		policy.setTradeEffectDate(DateUtil.toSimpleDate(tradeEffectDate));
		policy.setTradeExpiryDate(DateUtil.toSimpleDate(tradeExpiryDate));
		Long totalCount = orderService.countPercontrolGoodsOrderList(suppGoodsId, policy.getTradeEffectDate(),
				policy.getTradeExpiryDate(), 1);

		setGoodsOrderListToModel(model, currentPage, PAGE_SIZE, totalCount, policy, suppGoodsId);
		return "/percontrol/suppGoods/orderList";
	}

	/**
	 * 检查商品是否可以绑定(返回可以绑定的商品数组下标)
	 * 
	 * @param suppGoodsIds
	 * @return
	 */
	private synchronized List<Integer> getCanBindSuppGoodsIndexs(Long[] suppGoodsIds, Long policyId, Long supplierId, List<String> errorMsg) {
		List<Integer> idsIndex = new ArrayList<Integer>();
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		// 得到买断策略
		ResPrecontrolPolicy policy = resPrecontrolPolicyService.findResPrecontrolPolicyById(policyId);
		for (int i = 0; i < suppGoodsIds.length; i++) {
			// 判断该商品是否已经绑定
			paramsMap.clear();
			paramsMap.put("suppGoodsId", suppGoodsIds[i]);
			paramsMap.put("statusDate", policy.getTradeEffectDate());
			paramsMap.put("endDate", policy.getTradeExpiryDate());
			paramsMap.put("flag", "InUse");

			List<Long> policyIdes = resPrecontrolGoodsHotelAdapterService.getPolicyIdBindGoodsCountNew(paramsMap);
			// 判断商品的价格是不是绑定价格
			SuppGoods suppGoods = MiscUtils.autoUnboxing( suppGoodsHotelAdapterService.findSuppGoodsById(suppGoodsIds[i]) );
			if (suppGoods == null) {
				errorMsg.add("商品id=" + suppGoodsIds[i] + ",未查询到该商品。");
				continue;
			}
			// 判断当前商品所属供应商与预控供应商是否一致
			Long currentSupplierId = suppGoods.getSupplierId();
			if (com.alibaba.dubbo.common.utils.CollectionUtils.isNotEmpty(policyIdes)) {
				StringBuilder ids = new StringBuilder();
				for (Long id : policyIdes) {
					ResPrecontrolPolicy policy1 = resPrecontrolPolicyService.findResPrecontrolPolicyById(id);
					ids.append(id).append("策略名称：").append(policy1.getName()).append(";");
				}
				errorMsg.add("商品id=" + suppGoodsIds[i] + ",该商品已经有绑定策略。策略ID：" + ids.toString());
				continue;
			}
			if (!"Y".equalsIgnoreCase(suppGoods.getBuyoutFlag())) {
				errorMsg.add("商品id=" + suppGoodsIds[i] + ",该商品为不可买断商品。");
				continue;
			}
			if (currentSupplierId.longValue() != supplierId.longValue()) {
				errorMsg.add("商品id=" + suppGoodsIds[i] + ",该商品的供应商ID和绑定策略的供应商ID不一致。");
				continue;
			}
			if ("Y".equalsIgnoreCase(suppGoods.getApiFlag()) || suppGoods.getCategoryId() == 11L || suppGoods.getCategoryId() == 12L
					|| suppGoods.getCategoryId() == 13L) {
				if (suppGoods.getCategoryId() == 11L || suppGoods.getCategoryId() == 12L || suppGoods.getCategoryId() == 13L) {
					// 允许门票二维码产品绑定
					if ("QRCODE".equalsIgnoreCase(suppGoods.getNoticeType())) {
						idsIndex.add(i);
						continue;
					}
				} else {
					errorMsg.add("商品id=" + suppGoodsIds[i] + ",该商品是对接商品，不允许绑定。");
					continue;
				}
			}
			if ("Y".equals(suppGoods.getAperiodicFlag()) && "Daily".equals(policy.getControlClassification())) {
				errorMsg.add("商品id=" + suppGoodsIds[i] + ",该商品是期票且绑定预控类型是按日，不允许绑定。");
				continue;
			}
			idsIndex.add(i);
		}
		return idsIndex;
	}

	private void setGoodsListToModel(Model model, Long currentPage, Integer pageSize, Long totalSize, Long supplierId, Boolean budgetFlag,
			Long suppGoodsId, Long precontrolPolicyId, Long productId) {
		try {
			// 数据
			Page<ResPrecontrolGoodsVo> page = new Page<ResPrecontrolGoodsVo>();
			page.setCurrentPage(currentPage);
			page.setPageSize(pageSize);
			page.setTotalResultSize(totalSize);
			ResPrecontrolGoodsVo vo = new ResPrecontrolGoodsVo();
			vo.setSuppGoodsId(suppGoodsId);
			vo.setSupplierId(supplierId);
			vo.setBudgetFlag(budgetFlag);
			vo.setPrecontrolPolicyId(precontrolPolicyId);
			vo.setProductId(productId);
			page.setParam(vo);
			List<ResPrecontrolGoodsVo> suppGoodsList = null;
			if (budgetFlag) {
				suppGoodsList = resPrecontrolGoodsHotelAdapterService.getResPrecontrolBindGoodsVoList(page);
			} else {
				suppGoodsList = resPrecontrolGoodsHotelAdapterService.getResPrecontrolUnbindGoodsVoList(page);
			}
			// 翻页标签
			String paginationTag = resPrecontrolGoodsService.getGeneratePaginationTag(page);
			model.addAttribute("suppGoodsList", suppGoodsList);
			model.addAttribute("paginationTag", paginationTag);
			model.addAttribute("budgetFlag", budgetFlag);
			model.addAttribute("totalSize", totalSize);
		} catch (Exception e) {
			log.error(e.getMessage());
		}
	}

	private void setGoodsOrderListToModel(Model model, Long currentPage, Integer pageSize, Long totalSize, ResPrecontrolPolicy policy,
			Long suppGoodsId) {
		Page<ResPrecontrolOrderVo> page = new Page<ResPrecontrolOrderVo>();
		page.setCurrentPage(currentPage);
		page.setPageSize(pageSize);
		page.setTotalResultSize(totalSize);
		ResPrecontrolOrderVo vo = new ResPrecontrolOrderVo();
		vo.setTradeEffectDate(policy.getTradeEffectDate());
		vo.setTradeExpiryDate(policy.getTradeExpiryDate());
		vo.setSuppGoodsId(suppGoodsId);
		vo.setQrySource(1);
		page.setParam(vo);
		List<ResPrecontrolOrderVo> resPrecontrolOrderVoList = orderService.findPercontrolGoodsOrderList(page);
		Map<Long, Boolean> orderIdMap = new HashMap<Long, Boolean>();// 避免重复调用浪费性能
		for (ResPrecontrolOrderVo resPrecontrolOrderVo : resPrecontrolOrderVoList) {
			Map<String, Object> paramPack = new HashMap<String, Object>();
			paramPack.put("orderId", resPrecontrolOrderVo.getOrderId());// 订单号
			List<OrdOrderPack> orderPackList = orderService.findOrdOrderPackList(paramPack);
			if (!orderPackList.isEmpty()) {
				OrdOrderPack ordOrderPack = orderPackList.get(0);
				ProdProduct prodProduct = prodProductService.findProdProductByProductId(ordOrderPack.getProductId());
				resPrecontrolOrderVo.setProductName(prodProduct.getProductName());
			}
			List<OrdMulPriceRate> orderItems = new ArrayList<OrdMulPriceRate>();
			OrdOrderItem ordOrderItem=ordOrderRouteService.getOrderItem(resPrecontrolOrderVo.getOrderItemId());		
			boolean OrdMulPriceRate = checkUserOrderMulPriceList(ordOrderItem.getCategoryId());
			// 因为门店系统需每个品类的详细价格数据，此处逻辑影响子单价格信息展示 加此判断
			// 非原有存放数据品类不走遍历byOrdMulPriceRate 李志强
			// ---2017-03-20
			if (OrdMulPriceRate) {
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("orderItemId", resPrecontrolOrderVo.getOrderItemId());
				orderItems = orderService.findOrdMulPriceRateList(param);
			}
			if (!orderItems.isEmpty()) {
				Long adult = null;
				Long child = null;
				Long adultNum = null;
				Long childNum = null;
				Long allAdult = null;
				Long allChild = null;
				Long all = 0L;
				resPrecontrolOrderVo.setOrdMulPriceRateList(orderItems);
				for (OrdMulPriceRate ordMulPriceRate : orderItems) {
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
				if (allAdult != null) {
					all += allAdult;
				}
				if (allChild != null) {
					all += allChild;
				}
				// 设置多价格的买断总价
				resPrecontrolOrderVo.setTotal(all);
			}
		}
		// 翻页标签
		String paginationTag = resPrecontrolGoodsService.getGeneratePaginationTag(page);
		model.addAttribute("suppGoodsOrderList", resPrecontrolOrderVoList);
		model.addAttribute("paginationTag", paginationTag);
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

	/**
	 * 判断该商品是否启用了买断价
	 * 
	 * @param goodsId
	 *            商品Id，
	 * @param dates
	 *            日期
	 * @return
	 */
	@RequestMapping("/suppGoods/getResPrecontrolByParams")
	@ResponseBody
	public String getResPrecontrolByParams(String goodIds, String dates, String weekDays, String startDate, String endDate, String selectCalendar) {
		if (goodIds == "") {
			return "{}";
		}
		StringBuilder ret = new StringBuilder();
		List<Long> goodsIds = new ArrayList<Long>();
		goodIds = goodIds.substring(0, goodIds.length() - 1);
		String[] idArr = goodIds.split(",");
		for (int i = 0, j = idArr.length; i < j; i++) {
			goodsIds.add(Long.valueOf(idArr[i]));
		}
		List<Integer> days = new ArrayList<Integer>();
		if (weekDays.length() > 0) {
			weekDays = weekDays.substring(0, weekDays.length() - 1);
			String[] dayArr = weekDays.split(",");
			for (int i = 0, j = dayArr.length; i < j; i++) {
				days.add(Integer.valueOf(dayArr[i]));
			}
		}
		List<String> selectDates = new ArrayList<String>();
		if (dates.length() > 0) {
			dates = dates.substring(0, dates.length() - 1);
			String[] dateArr = dates.split(",");
			for (int m = 0, n = dateArr.length; m < n; m++) {
				selectDates.add(dateArr[m]);
			}
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		try {
			Date st = startDate == "" || startDate == null ? null : sdf.parse(startDate);
			Date ed = endDate == "" || endDate == null ? null : sdf.parse(endDate);
			List<Long> ids = lineRouteDateService.getResPrecontrolByParams(goodsIds, st, ed, days, selectDates, selectCalendar);
			if (ids != null && ids.size() > 0) {
				ret.append("{\"code\":\"" + ids.size() + "\",\"datas\":");
				StringBuilder data = new StringBuilder();
				data.append("[");
				for (int x = 0, y = ids.size(); x < y; x++) {
					String template = "{\"goodsId\":\"GOODSID\"},";
					template = template.replaceAll("GOODSID", ids.get(x) + "");
					data.append(template);
				}
				ret.append(data.substring(0, data.length() - 1)).append("]}");
			} else {
				ret.append("{\"code\":\"none\"}");
			}
		} catch (ParseException e) {
			log.error(ExceptionFormatUtil.getTrace(e));
		}
		return ret.toString();
	}

	/**
	 * 买断逻辑内部类
	 */
	private class ResPreControlInner {

		private ResPrecontrolPolicyOrderVo getResPrecontrolPolicyOrderVo(ResPrecontrolPolicy policy) {
			ResPrecontrolPolicyOrderVo policyVo = new ResPrecontrolPolicyOrderVo();
			BeanUtils.copyProperties(policy, policyVo);
			// 剩余量需要一个单独的接口来计算
			Long amount = 0L;
			if ("amount".equalsIgnoreCase(policy.getControlType())) {
				amount = resPrecontrolAmountService.findRemainAmountByPolicyId(policy.getId());
			} else {
				amount = resPrecontrolInventoryService.findRemainInventoryByPolicyId(policy.getId());
			}
			policyVo.setRemainAmount(amount);
			return policyVo;
		}

		/**
		 * 历史推送订单分页控件
		 * 
		 * @return
		 */
		private String getHisResPrecontrolPaginationTag(long currentPage, long pageSize, long totalSize) {
			Page<HisResPrecontrolOrderVo> page = generatePage(currentPage, pageSize, totalSize);
			return resPrecontrolGoodsService.getGeneratePaginationTag(page);
		}

		/**
		 * 查询某个预控 商品 下的历史推送订单
		 * 
		 * @return
		 */
		private List<ResPrecontrolOrderVo> getHisResPrecontrolVO(long currentPage, long pageSize, long totalSize, long suppGoodsId,
				long preControlPolicyId) {
			Page<HisResPrecontrolOrderVo> page = generatePage(currentPage, pageSize, totalSize);
			page.setParam(new HisResPrecontrolOrderVo(suppGoodsId, preControlPolicyId));
			return orderService.findPercontrolGoodsHisOrderList(page);
		}

		private Page<HisResPrecontrolOrderVo> generatePage(long currentPage, long pageSize, long totalSize) {
			Page<HisResPrecontrolOrderVo> page = new Page<HisResPrecontrolOrderVo>();
			page.setCurrentPage(currentPage);
			page.setPageSize(pageSize);
			page.setTotalResultSize(totalSize);
			return page;
		}

		/**
		 * 分页数据
		 * 
		 * @param model
		 * @param currentPage
		 * @param pageSize
		 * @param suppGoodsId
		 * @param preControlPolicyId
		 */
		private void setHistoryOrderUIModelPagaination(Model model, long currentPage, long totalCount, long pageSize, long suppGoodsId,
				long preControlPolicyId) {
			model.addAttribute("suppGoodsOrderList", getHisResPrecontrolVO(currentPage, pageSize, totalCount, suppGoodsId, preControlPolicyId));
			model.addAttribute("paginationTag", getHisResPrecontrolPaginationTag(currentPage, pageSize, totalCount));
		}

		/**
		 * 历史订单主页数据
		 * 
		 * @param model
		 * @param currentPage
		 * @param pageSize
		 * @param suppGoodsId
		 * @param preControlPolicyId
		 */
		private void setHistoryOrderUIModel(Model model, long currentPage, long pageSize, long suppGoodsId, long preControlPolicyId) {
			// 得到买断策略
			ResPrecontrolPolicy policy = resPrecontrolPolicyService.findResPrecontrolPolicyById(preControlPolicyId);
			ResPrecontrolPolicyOrderVo policyVo = getResPrecontrolPolicyOrderVo(policy);
			model.addAttribute("policy", policyVo);
			Long totalCount = orderService.countPercontrolGoodsHisOrder(suppGoodsId, preControlPolicyId);
			setHistoryOrderUIModelPagaination(model, currentPage, totalCount, pageSize, suppGoodsId, preControlPolicyId);
		}

		private PushStatus doPushInternal(Long preControlPolicyID, Date pushDate, Date lastPushDate, long goodsID) {
			int pageSize = 128 << 2;
			int startIndex = -pageSize;
			int endIndex = 0;
			Map<String, Object> params = new HashMap<>(8, 1);
			params.put("preControlPolicyID", preControlPolicyID);
			params.put("goodsID", goodsID);
			params.put("from", pushDate);
			params.put("to", lastPushDate);
			int pushCount = 0;
			int totalPushCount = 0;
			List<Long> orderIDs = null;
			do {
				startIndex += pageSize;
				endIndex += pageSize;
				params.put("statIndex", startIndex);
				params.put("endIndex", endIndex);
				orderIDs = resPrecontrolBindGoodsService.getPreControlPolicyHistoryOrder(params);
				if (orderIDs == null || orderIDs.size() == 0)
					break;
				totalPushCount += orderIDs.size();
				List<PushHistoryResourceDTO> dtos = new ArrayList<>(orderIDs.size());
				for (Long id : orderIDs) {
					PushHistoryResourceDTO dto = new PushHistoryResourceDTO();
					dto.setOrderItemMetaID(id);
					dtos.add(dto);
				}
				SucceedCode succeedCode = new SucceedCode();
				try {
					succeedCode = budgetService.pushHistoryOrder(dtos);
					int code = succeedCode.getCode();
					if (code == SucceedCode.ORDERERROR || code == SucceedCode.ERROR)
						return PushStatus.ERROR;
					pushCount += succeedCode.getSucceedPushCount();
					// 暂时释放数据库资源。让给其它业务占用
					Thread.sleep(10);
				} catch (Exception ex) {
					ex.printStackTrace();
					return PushStatus.ERROR;
				}
			} while (orderIDs != null && orderIDs.size() == pageSize);
			String pushComment = "无订单";
			if (pushCount > 0) {
				pushComment = "共推送" + pushCount + "条子订单";
			}
			// 记录日志
			lvmmLogClientService.sendLog(ComLog.COM_LOG_OBJECT_TYPE.RES_PRECONTROL_POLICY_PUSH_HISTORY, preControlPolicyID, goodsID, "预控历史推送",
					"推送时间:" + DateUtil.formatDate(pushDate, DateUtil.PATTERN_yyyy_MM_dd), null, getLoginUser().getRealName(), pushComment);
			log.info("成功推送:" + pushCount + ",总共:" + totalPushCount);
			if (totalPushCount != pushCount)
				return PushStatus.PartialOk;
			return PushStatus.OK;
		}

		/**
		 * 推送预控期内vst非买断订单为买断订单
		 * 
		 * @param resPrecontrolPolicy
		 * @return
		 */
		@Transactional
		private PushStatus doPushInternalOrder(ResPrecontrolPolicy resPrecontrolPolicy) {
			List<Long> goodIds = new ArrayList<Long>();
			Map<String, Object> paramsMap = new HashMap<String, Object>();
			Long policyId = resPrecontrolPolicy.getId();
			paramsMap.put("precontrolPolicyId", policyId);
			List<ResPrecontrolBindGoods> bindGoodsList = resPrecontrolBindGoodsService.findResPrecontrolBindGoods(paramsMap);
			for (int i = 0; i < bindGoodsList.size(); i++) {
				ResPrecontrolBindGoods good = bindGoodsList.get(i);
				goodIds.add(good.getGoodsId());
			}
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("preControlPolicyID", policyId);
			params.put("goodIds", goodIds);
			params.put("startDate", resPrecontrolPolicy.getTradeEffectDate());
			params.put("endDate", resPrecontrolPolicy.getTradeExpiryDate());
			// 处理非酒店的vst订单
			dealNoHotelVstOrder(params, resPrecontrolPolicy);
			// 处理酒店的vst订单
			dealHotelVstOrder(params, resPrecontrolPolicy);
			return PushStatus.OK;
		}

		/**
		 * 处理非酒店vst订单
		 * 
		 * @param params
		 * @param resPrecontrolPolicy
		 */
		private void dealNoHotelVstOrder(Map<String, Object> params, ResPrecontrolPolicy resPrecontrolPolicy) {
			Long policyId = resPrecontrolPolicy.getId();
			log.info("处理非酒店订单，policyId=" + policyId);
			// 查询预控周期内非买断的
			List<VstOrderItemVo> orderItemList = resPrecontrolBindGoodsService.getVstNotBuyoutOrder(params);
			if (orderItemList != null && orderItemList.size() > 0) {
				Long totalCount = 0L;
				Long totalAmount = 0L;
				// 组装重新计价VO
				GoodsResPrecontrolPolicyVO goodsResPrecontrolPolicyVO = fillPolicyVO(resPrecontrolPolicy);
				if (resPrecontrolPolicy.getControlType().equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
					// 按周期
					if (resPrecontrolPolicy.getControlClassification().equalsIgnoreCase(ResControlEnum.CONTROL_CLASSIFICATION.Cycle.name())) {
						totalAmount = 0L;
						for (int i = 0; i < orderItemList.size(); i++) {
							VstOrderItemVo ordOrderItem = orderItemList.get(i);
							totalAmount += (ordOrderItem.getTotalSettlementPrice() == null ? 0L : ordOrderItem.getTotalSettlementPrice());
						}
						ResPrecontrolAmount resPrecontrolAmount = resPrecontrolAmountService.findByResPrecontrolPolicyId(policyId);
						Long leftValue = resPrecontrolAmount.getQuantity();
						leftValue = leftValue - totalAmount;
						// leftValue = leftValue< 0?
						// 0L:leftValue;
						// 更新库存金额
						resPrecontrolPolicyService.updateAmountResPrecontrolPolicy(resPrecontrolAmount.getPrecontrolAmountSeq(), policyId, null,
								leftValue);
						// Long leftValue = leftAmount -
						// value;
						// leftValue = leftValue< 0?
						// 0L:leftValue;
						// reduceResult =
						// resControlBudgetRemote.updateAmountResPrecontrolPolicy(amountId,controlId,
						// visitDate, leftValue);
						// if(reduceResult){
						// logger.info("按金额预控-更新成功");
						// sendBudgetMsgToSendEmail(goodsResPrecontrolPolicyVO,leftAmount,leftValue);
						// }
						// //如果预控金额已经没了，清空该商品的预控缓存
						if (leftValue <= 0) {
							resPreControlService.handleResPrecontrolSaledOut(goodsResPrecontrolPolicyVO, null, 1L);
						}
					} else {
						// 按日
						List<ResPrecontrolAmount> amountList = resPrecontrolAmountService.findDailyByResPrecontrolPolicyId(policyId);
						for (int i = 0; i < amountList.size(); i++) {
							totalAmount = 0L;
							ResPrecontrolAmount resPrecontrolAmount = amountList.get(i);
							for (VstOrderItemVo orderItem : orderItemList) {
								if (DateUtil.isTheSameDay(orderItem.getVisitTime(), resPrecontrolAmount.getEffectDate())) {
									totalAmount += (orderItem.getTotalSettlementPrice() == null ? 0L : orderItem.getTotalSettlementPrice());
								}
							}
							Long leftValue = resPrecontrolAmount.getQuantity();
							leftValue = leftValue - totalAmount;
							// leftValue = leftValue< 0?
							// 0L:leftValue;
							// 更新库存金额
							resPrecontrolPolicyService.updateAmountResPrecontrolPolicy(resPrecontrolAmount.getPrecontrolAmountSeq(), policyId, null,
									leftValue);
							// 如果预控金额已经没了，清空该商品在这一天的预控缓存
							if (leftValue <= 0) {
								resPreControlService.handleResPrecontrolSaledOut(goodsResPrecontrolPolicyVO, resPrecontrolAmount.getEffectDate(), 1L);
							}
						}
					}
					// 库存
				} else {
					// 按周期
					if (resPrecontrolPolicy.getControlClassification().equalsIgnoreCase(ResControlEnum.CONTROL_CLASSIFICATION.Cycle.name())) {
						totalCount = 0L;
						for (int i = 0; i < orderItemList.size(); i++) {
							VstOrderItemVo ordOrderItem = orderItemList.get(i);
							totalCount += (ordOrderItem.getQuantity() == null ? 0L : ordOrderItem.getQuantity());
						}
						ResPrecontrolInventory resPrecontrolInventory = resPrecontrolInventoryService.findByResPrecontrolPolicyId(policyId);
						Long leftStore = resPrecontrolInventory.getQuantity();
						leftStore = leftStore - totalCount;
						// leftStore = leftStore< 0?
						// 0L:leftStore;
						// 更新库存
						resPrecontrolPolicyService.updateStoreResPrecontrolPolicy(resPrecontrolInventory.getId(), policyId, null, leftStore);
						// 如果预控库存已经没了，清空该商品的预控缓存
						if (leftStore <= 0) {
							resPreControlService.handleResPrecontrolSaledOut(goodsResPrecontrolPolicyVO, null, 1L);
						}
					} else {
						// 按日
						List<ResPrecontrolInventory> inventoryList = resPrecontrolInventoryService.findByCycleResPrecontrolPolicyId(policyId);
						for (int i = 0; i < inventoryList.size(); i++) {
							totalCount = 0L;
							ResPrecontrolInventory resPrecontrolInventory = inventoryList.get(i);
							for (VstOrderItemVo orderItem : orderItemList) {
								if (DateUtil.isTheSameDay(orderItem.getVisitTime(), resPrecontrolInventory.getEffectDate())) {
									totalCount += (orderItem.getQuantity() == null ? 0L : orderItem.getQuantity());
								}
							}
							Long leftStore = resPrecontrolInventory.getQuantity();
							leftStore = leftStore - totalCount;
							// leftStore = leftStore< 0?
							// 0L:leftStore;
							// 更新库存
							resPrecontrolPolicyService.updateStoreResPrecontrolPolicy(resPrecontrolInventory.getId(), policyId, null, leftStore);
							// 如果预控库存已经没了，清空该商品在这一天的预控缓存
							if (leftStore <= 0) {
								resPreControlService.handleResPrecontrolSaledOut(goodsResPrecontrolPolicyVO, resPrecontrolInventory.getEffectDate(),
										1L);
							}
						}
					}
				}
				// 设置订单与子预控的关系
				resPrecontrolBindGoodsService.insertPushOrderBatch(params);
				log.info("处理非酒店订单，生成推送记录，policyId=" + policyId);
				// 更新VST非买断订单为买断订单
				resPrecontrolBindGoodsService.updateVstBudgetFlagBylist(params);
				log.info("处理非酒店订单，更新VST为买断订单，policyId=" + policyId);
			}
		}

		/**
		 * 处理非酒店vst订单
		 * 
		 * @param params
		 * @param resPrecontrolPolicy
		 */
		private void dealNoHotelVstOrderByGoodsId(Map<String, Object> params, ResPrecontrolPolicy resPrecontrolPolicy) {
			Long policyId = resPrecontrolPolicy.getId();
			log.info("处理非酒店订单，policyId=" + policyId);
			// 查询预控周期内非买断的
			List<VstOrderItemVo> orderItemList = resPrecontrolBindGoodsService.getVstNotBuyoutOrder(params);
			if (orderItemList != null && orderItemList.size() > 0) {
				Long totalCount = 0L;
				Long totalAmount = 0L;
				// 组装重新计价VO
				GoodsResPrecontrolPolicyVO goodsResPrecontrolPolicyVO = fillPolicyVO(resPrecontrolPolicy);
				if (resPrecontrolPolicy.getControlType().equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
					// 按周期
					if (resPrecontrolPolicy.getControlClassification().equalsIgnoreCase(ResControlEnum.CONTROL_CLASSIFICATION.Cycle.name())) {
						totalAmount = 0L;
						for (int i = 0; i < orderItemList.size(); i++) {
							VstOrderItemVo ordOrderItem = orderItemList.get(i);
							totalAmount += (ordOrderItem.getTotalSettlementPrice() == null ? 0L : ordOrderItem.getTotalSettlementPrice());
						}
						ResPrecontrolAmount resPrecontrolAmount = resPrecontrolAmountService.findByResPrecontrolPolicyId(policyId);
						Long leftValue = resPrecontrolAmount.getQuantity();
						leftValue = leftValue - totalAmount;
						// leftValue = leftValue< 0?
						// 0L:leftValue;
						// 更新库存金额
						resPrecontrolPolicyService.updateAmountResPrecontrolPolicy(resPrecontrolAmount.getPrecontrolAmountSeq(), policyId, null,
								leftValue);
						// Long leftValue = leftAmount -
						// value;
						// leftValue = leftValue< 0?
						// 0L:leftValue;
						// reduceResult =
						// resControlBudgetRemote.updateAmountResPrecontrolPolicy(amountId,controlId,
						// visitDate, leftValue);
						// if(reduceResult){
						// logger.info("按金额预控-更新成功");
						// sendBudgetMsgToSendEmail(goodsResPrecontrolPolicyVO,leftAmount,leftValue);
						// }
						// //如果预控金额已经没了，清空该商品的预控缓存
						if (leftValue <= 0) {
							resPreControlService.handleResPrecontrolSaledOut(goodsResPrecontrolPolicyVO, null, 1L);
						}
					} else {
						// 按日
						List<ResPrecontrolAmount> amountList = resPrecontrolAmountService.findDailyByResPrecontrolPolicyId(policyId);
						for (int i = 0; i < amountList.size(); i++) {
							totalAmount = 0L;
							ResPrecontrolAmount resPrecontrolAmount = amountList.get(i);
							for (VstOrderItemVo orderItem : orderItemList) {
								if (DateUtil.isTheSameDay(orderItem.getVisitTime(), resPrecontrolAmount.getEffectDate())) {
									totalAmount += (orderItem.getTotalSettlementPrice() == null ? 0L : orderItem.getTotalSettlementPrice());
								}
							}
							Long leftValue = resPrecontrolAmount.getQuantity();
							leftValue = leftValue - totalAmount;
							// leftValue = leftValue< 0?
							// 0L:leftValue;
							// 更新库存金额
							resPrecontrolPolicyService.updateAmountResPrecontrolPolicy(resPrecontrolAmount.getPrecontrolAmountSeq(), policyId, null,
									leftValue);
							// 如果预控金额已经没了，清空该商品在这一天的预控缓存
							if (leftValue <= 0) {
								resPreControlService.handleResPrecontrolSaledOut(goodsResPrecontrolPolicyVO, resPrecontrolAmount.getEffectDate(), 1L);
							}
						}
					}
					// 库存
				} else {
					// 按周期
					if (resPrecontrolPolicy.getControlClassification().equalsIgnoreCase(ResControlEnum.CONTROL_CLASSIFICATION.Cycle.name())) {
						totalCount = 0L;
						for (int i = 0; i < orderItemList.size(); i++) {
							VstOrderItemVo ordOrderItem = orderItemList.get(i);
							totalCount += (ordOrderItem.getQuantity() == null ? 0L : ordOrderItem.getQuantity());
						}
						ResPrecontrolInventory resPrecontrolInventory = resPrecontrolInventoryService.findByResPrecontrolPolicyId(policyId);
						Long leftStore = resPrecontrolInventory.getQuantity();
						leftStore = leftStore - totalCount;
						// leftStore = leftStore< 0?
						// 0L:leftStore;
						// 更新库存
						resPrecontrolPolicyService.updateStoreResPrecontrolPolicy(resPrecontrolInventory.getId(), policyId, null, leftStore);
						// 如果预控库存已经没了，清空该商品的预控缓存
						if (leftStore <= 0) {
							resPreControlService.handleResPrecontrolSaledOut(goodsResPrecontrolPolicyVO, null, 1L);
						}
					} else {
						// 按日
						List<ResPrecontrolInventory> inventoryList = resPrecontrolInventoryService.findByCycleResPrecontrolPolicyId(policyId);
						for (int i = 0; i < inventoryList.size(); i++) {
							totalCount = 0L;
							ResPrecontrolInventory resPrecontrolInventory = inventoryList.get(i);
							for (VstOrderItemVo orderItem : orderItemList) {
								if (DateUtil.isTheSameDay(orderItem.getVisitTime(), resPrecontrolInventory.getEffectDate())) {
									totalCount += (orderItem.getQuantity() == null ? 0L : orderItem.getQuantity());
								}
							}
							Long leftStore = resPrecontrolInventory.getQuantity();
							leftStore = leftStore - totalCount;
							// leftStore = leftStore< 0?
							// 0L:leftStore;
							// 更新库存
							resPrecontrolPolicyService.updateStoreResPrecontrolPolicy(resPrecontrolInventory.getId(), policyId, null, leftStore);
							// 如果预控库存已经没了，清空该商品在这一天的预控缓存
							if (leftStore <= 0) {
								resPreControlService.handleResPrecontrolSaledOut(goodsResPrecontrolPolicyVO, resPrecontrolInventory.getEffectDate(),
										1L);
							}
						}
					}
				}
				// 设置订单与子预控的关系
				resPrecontrolBindGoodsService.insertPushOrderBatch(params);
				log.info("处理非酒店订单，生成推送记录，policyId=" + policyId);
				// 更新VST非买断订单为买断订单
				if(null != params){
					params.put("nebulaProjectId", resPrecontrolPolicy.getNebulaProjectId());
				}
				resPrecontrolBindGoodsService.updateVstBudgetFlagBylist(params);
				log.info("处理非酒店订单，更新VST为买断订单，policyId=" + policyId);
			}
		}

		/**
		 * 处理酒店vst订单
		 * 
		 * @param params
		 * @param resPrecontrolPolicy
		 */
		private void dealHotelVstOrder(Map<String, Object> params, ResPrecontrolPolicy resPrecontrolPolicy) {
			Long policyId = resPrecontrolPolicy.getId();
			log.info("处理酒店订单，policyId=" + policyId);
			// 查询预控周期内非买断的
			List<VstOrderItemVo> orderItemList = resPrecontrolBindGoodsService.getVstNotBuyoutOrderHotel(params);
			if (orderItemList != null && orderItemList.size() > 0) {
				Long totalCount = 0L;
				Long totalAmount = 0L;
				// 组装重新计价VO
				GoodsResPrecontrolPolicyVO goodsResPrecontrolPolicyVO = fillPolicyVO(resPrecontrolPolicy);
				if (resPrecontrolPolicy.getControlType().equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
					// 按周期
					if (resPrecontrolPolicy.getControlClassification().equalsIgnoreCase(ResControlEnum.CONTROL_CLASSIFICATION.Cycle.name())) {
						totalAmount = 0L;
						for (int i = 0; i < orderItemList.size(); i++) {
							VstOrderItemVo ordOrderItem = orderItemList.get(i);
							totalAmount += (ordOrderItem.getHotelTotalSettlementPrice() == null ? 0L : ordOrderItem.getHotelTotalSettlementPrice());
						}
						ResPrecontrolAmount resPrecontrolAmount = resPrecontrolAmountService.findByResPrecontrolPolicyId(policyId);
						Long leftValue = resPrecontrolAmount.getQuantity();
						leftValue = leftValue - totalAmount;
						// 更新库存金额
						resPrecontrolPolicyService.updateAmountResPrecontrolPolicy(resPrecontrolAmount.getPrecontrolAmountSeq(), policyId, null,
								leftValue);
						// //如果预控金额已经没了，清空该商品的预控缓存
						if (leftValue <= 0) {
							resPreControlService.handleResPrecontrolSaledOut(goodsResPrecontrolPolicyVO, null, 1L);
						}
					} else {
						// 按日
						List<ResPrecontrolAmount> amountList = resPrecontrolAmountService.findDailyByResPrecontrolPolicyId(policyId);
						for (int i = 0; i < amountList.size(); i++) {
							totalAmount = 0L;
							ResPrecontrolAmount resPrecontrolAmount = amountList.get(i);
							for (VstOrderItemVo orderItem : orderItemList) {
								if (DateUtil.isTheSameDay(orderItem.getVisitTime(), resPrecontrolAmount.getEffectDate())) {
									totalAmount += (orderItem.getHotelTotalSettlementPrice() == null ? 0L : orderItem.getHotelTotalSettlementPrice());
								}
							}
							Long leftValue = resPrecontrolAmount.getQuantity();
							leftValue = leftValue - totalAmount;
							// 更新库存金额
							resPrecontrolPolicyService.updateAmountResPrecontrolPolicy(resPrecontrolAmount.getPrecontrolAmountSeq(), policyId, null,
									leftValue);
							// 如果预控金额已经没了，清空该商品在这一天的预控缓存
							if (leftValue <= 0) {
								resPreControlService.handleResPrecontrolSaledOut(goodsResPrecontrolPolicyVO, resPrecontrolAmount.getEffectDate(), 1L);
							}
						}
					}
					// 库存
				} else {
					// 按周期
					if (resPrecontrolPolicy.getControlClassification().equalsIgnoreCase(ResControlEnum.CONTROL_CLASSIFICATION.Cycle.name())) {
						totalCount = 0L;
						for (int i = 0; i < orderItemList.size(); i++) {
							VstOrderItemVo ordOrderItem = orderItemList.get(i);
							totalCount += (ordOrderItem.getHotelSumQuantity() == null ? 0L : ordOrderItem.getHotelSumQuantity());
						}
						ResPrecontrolInventory resPrecontrolInventory = resPrecontrolInventoryService.findByResPrecontrolPolicyId(policyId);
						Long leftStore = resPrecontrolInventory.getQuantity();
						leftStore = leftStore - totalCount;
						// 更新库存
						resPrecontrolPolicyService.updateStoreResPrecontrolPolicy(resPrecontrolInventory.getId(), policyId, null, leftStore);
						// 如果预控库存已经没了，清空该商品的预控缓存
						if (leftStore <= 0) {
							resPreControlService.handleResPrecontrolSaledOut(goodsResPrecontrolPolicyVO, null, 1L);
						}
					} else {
						// 按日
						List<ResPrecontrolInventory> inventoryList = resPrecontrolInventoryService.findByCycleResPrecontrolPolicyId(policyId);
						for (int i = 0; i < inventoryList.size(); i++) {
							totalCount = 0L;
							ResPrecontrolInventory resPrecontrolInventory = inventoryList.get(i);
							for (VstOrderItemVo orderItem : orderItemList) {
								if (DateUtil.isTheSameDay(orderItem.getVisitTime(), resPrecontrolInventory.getEffectDate())) {
									totalCount += (orderItem.getHotelSumQuantity() == null ? 0L : orderItem.getHotelSumQuantity());
								}
							}
							Long leftStore = resPrecontrolInventory.getQuantity();
							leftStore = leftStore - totalCount;
							// 更新库存
							resPrecontrolPolicyService.updateStoreResPrecontrolPolicy(resPrecontrolInventory.getId(), policyId, null, leftStore);
							// 如果预控库存已经没了，清空该商品在这一天的预控缓存
							if (leftStore <= 0) {
								resPreControlService.handleResPrecontrolSaledOut(goodsResPrecontrolPolicyVO, resPrecontrolInventory.getEffectDate(),
										1L);
							}
						}
					}
				}
				// 设置订单与子预控的关系
				resPrecontrolBindGoodsService.insertPushOrderBatchHotel(params);
				log.info("处理酒店订单，生成推送记录，policyId=" + policyId);
				// 更新VST非买断订单为买断订单
				resPrecontrolBindGoodsService.updateVstBudgetFlagBylistHotel(params);
				log.info("处理酒店订单，更新VST为买断订单，policyId=" + policyId);
				// //批量更新
				// Map<Long, VstOrderItemVo> orderItemParams
				// =new HashMap<Long, VstOrderItemVo>();
				// //去重 组装
				// for(VstOrderItemVo
				// orderItem:orderItemList){
				// Long
				// orderItemId=orderItem.getOrderItemId();
				// if(orderItemParams.get(orderItemId) ==
				// null){
				// VstOrderItemVo newVo=new
				// VstOrderItemVo();
				// newVo.setBuyoutPrice(orderItem.getHotelSumSettlementPrice());
				// newVo.setBuyoutTotalPrice(orderItem.getHotelTotalSettlementPrice());
				// newVo.setBuyoutQuantity(orderItem.getHotelSumQuantity());
				// newVo.setBuyoutFlag("Y");
				// orderItemParams.put(orderItemId, newVo);
				// }else{
				// VstOrderItemVo oldVo =
				// orderItemParams.get(orderItemId);
				// VstOrderItemVo newVo=new
				// VstOrderItemVo();
				// newVo.setOrderItemId(orderItemId);
				// newVo.setBuyoutPrice(sumLong(oldVo.getBuyoutPrice(),orderItem.getHotelSumSettlementPrice()));
				// newVo.setBuyoutTotalPrice(sumLong(oldVo.getBuyoutTotalPrice(),orderItem.getHotelTotalSettlementPrice()));
				// newVo.setBuyoutQuantity(sumLong(oldVo.getQuantity(),orderItem.getHotelSumQuantity()));
				// newVo.setBuyoutFlag("Y");
				// orderItemParams.put(orderItemId, newVo);
				// }
				// }
				//
				// List itemList = new ArrayList();
				// Iterator iter =
				// orderItemParams.entrySet().iterator();
				// while(iter.hasNext()) {
				// VstOrderItemVo itemVo =
				// (VstOrderItemVo)iter.next();
				// itemList.add(itemVo);
				// }
				// resPrecontrolBindGoodsService.updateOrderBatchHotel(itemList);
			}
		}

		/**
		 * 处理酒店vst订单
		 * 
		 * @param params
		 * @param resPrecontrolPolicy
		 */
		private void dealHotelVstOrderByGoodsId(Map<String, Object> params, ResPrecontrolPolicy resPrecontrolPolicy) {
			Long policyId = resPrecontrolPolicy.getId();
			log.info("处理酒店订单，policyId=" + policyId);
			// 查询预控周期内非买断的
			List<VstOrderItemVo> orderItemList = resPrecontrolBindGoodsService.getVstNotBuyoutOrderHotel(params);
			if (orderItemList != null && orderItemList.size() > 0) {
				Long totalCount = 0L;
				Long totalAmount = 0L;
				// 组装重新计价VO
				GoodsResPrecontrolPolicyVO goodsResPrecontrolPolicyVO = fillPolicyVO(resPrecontrolPolicy);
				if (resPrecontrolPolicy.getControlType().equalsIgnoreCase(ResControlEnum.RES_PRECONTROL_POLICY_TYPE.amount.name())) {
					// 按周期
					if (resPrecontrolPolicy.getControlClassification().equalsIgnoreCase(ResControlEnum.CONTROL_CLASSIFICATION.Cycle.name())) {
						totalAmount = 0L;
						for (int i = 0; i < orderItemList.size(); i++) {
							VstOrderItemVo ordOrderItem = orderItemList.get(i);
							totalAmount += (ordOrderItem.getHotelTotalSettlementPrice() == null ? 0L : ordOrderItem.getHotelTotalSettlementPrice());
						}
						ResPrecontrolAmount resPrecontrolAmount = resPrecontrolAmountService.findByResPrecontrolPolicyId(policyId);
						Long leftValue = resPrecontrolAmount.getQuantity();
						leftValue = leftValue - totalAmount;
						// 更新库存金额
						resPrecontrolPolicyService.updateAmountResPrecontrolPolicy(resPrecontrolAmount.getPrecontrolAmountSeq(), policyId, null,
								leftValue);
						// //如果预控金额已经没了，清空该商品的预控缓存
						if (leftValue <= 0) {
							resPreControlService.handleResPrecontrolSaledOut(goodsResPrecontrolPolicyVO, null, 1L);
						}
					} else {
						// 按日
						List<ResPrecontrolAmount> amountList = resPrecontrolAmountService.findDailyByResPrecontrolPolicyId(policyId);
						for (int i = 0; i < amountList.size(); i++) {
							totalAmount = 0L;
							ResPrecontrolAmount resPrecontrolAmount = amountList.get(i);
							for (VstOrderItemVo orderItem : orderItemList) {
								if (DateUtil.isTheSameDay(orderItem.getVisitTime(), resPrecontrolAmount.getEffectDate())) {
									totalAmount += (orderItem.getHotelTotalSettlementPrice() == null ? 0L : orderItem.getHotelTotalSettlementPrice());
								}
							}
							Long leftValue = resPrecontrolAmount.getQuantity();
							leftValue = leftValue - totalAmount;
							// 更新库存金额
							resPrecontrolPolicyService.updateAmountResPrecontrolPolicy(resPrecontrolAmount.getPrecontrolAmountSeq(), policyId, null,
									leftValue);
							// 如果预控金额已经没了，清空该商品在这一天的预控缓存
							if (leftValue <= 0) {
								resPreControlService.handleResPrecontrolSaledOut(goodsResPrecontrolPolicyVO, resPrecontrolAmount.getEffectDate(), 1L);
							}
						}
					}
					// 库存
				} else {
					// 按周期
					if (resPrecontrolPolicy.getControlClassification().equalsIgnoreCase(ResControlEnum.CONTROL_CLASSIFICATION.Cycle.name())) {
						totalCount = 0L;
						for (int i = 0; i < orderItemList.size(); i++) {
							VstOrderItemVo ordOrderItem = orderItemList.get(i);
							totalCount += (ordOrderItem.getHotelSumQuantity() == null ? 0L : ordOrderItem.getHotelSumQuantity());
						}
						ResPrecontrolInventory resPrecontrolInventory = resPrecontrolInventoryService.findByResPrecontrolPolicyId(policyId);
						Long leftStore = resPrecontrolInventory.getQuantity();
						leftStore = leftStore - totalCount;
						// 更新库存
						resPrecontrolPolicyService.updateStoreResPrecontrolPolicy(resPrecontrolInventory.getId(), policyId, null, leftStore);
						// 如果预控库存已经没了，清空该商品的预控缓存
						if (leftStore <= 0) {
							resPreControlService.handleResPrecontrolSaledOut(goodsResPrecontrolPolicyVO, null, 1L);
						}
					} else {
						// 按日
						List<ResPrecontrolInventory> inventoryList = resPrecontrolInventoryService.findByCycleResPrecontrolPolicyId(policyId);
						for (int i = 0; i < inventoryList.size(); i++) {
							totalCount = 0L;
							ResPrecontrolInventory resPrecontrolInventory = inventoryList.get(i);
							for (VstOrderItemVo orderItem : orderItemList) {
								if (DateUtil.isTheSameDay(orderItem.getVisitTime(), resPrecontrolInventory.getEffectDate())) {
									totalCount += (orderItem.getHotelSumQuantity() == null ? 0L : orderItem.getHotelSumQuantity());
								}
							}
							Long leftStore = resPrecontrolInventory.getQuantity();
							leftStore = leftStore - totalCount;
							// 更新库存
							resPrecontrolPolicyService.updateStoreResPrecontrolPolicy(resPrecontrolInventory.getId(), policyId, null, leftStore);
							// 如果预控库存已经没了，清空该商品在这一天的预控缓存
							if (leftStore <= 0) {
								resPreControlService.handleResPrecontrolSaledOut(goodsResPrecontrolPolicyVO, resPrecontrolInventory.getEffectDate(),
										1L);
							}
						}
					}
				}
				// 设置订单与子预控的关系
				resPrecontrolBindGoodsService.insertPushOrderBatchHotel(params);
				log.info("处理酒店订单，生成推送记录，policyId=" + policyId);
				// 更新VST非买断订单为买断订单
				if(null != params){
					params.put("nebulaProjectId", resPrecontrolPolicy.getNebulaProjectId());
				}
				resPrecontrolBindGoodsService.updateVstBudgetFlagBylistHotel(params);
				log.info("处理酒店订单，更新VST为买断订单，policyId=" + policyId);
				// //批量更新
				// Map<Long, VstOrderItemVo> orderItemParams
				// =new HashMap<Long, VstOrderItemVo>();
				// //去重 组装
				// for(VstOrderItemVo
				// orderItem:orderItemList){
				// Long
				// orderItemId=orderItem.getOrderItemId();
				// if(orderItemParams.get(orderItemId) ==
				// null){
				// VstOrderItemVo newVo=new
				// VstOrderItemVo();
				// newVo.setBuyoutPrice(orderItem.getHotelSumSettlementPrice());
				// newVo.setBuyoutTotalPrice(orderItem.getHotelTotalSettlementPrice());
				// newVo.setBuyoutQuantity(orderItem.getHotelSumQuantity());
				// newVo.setBuyoutFlag("Y");
				// orderItemParams.put(orderItemId, newVo);
				// }else{
				// VstOrderItemVo oldVo =
				// orderItemParams.get(orderItemId);
				// VstOrderItemVo newVo=new
				// VstOrderItemVo();
				// newVo.setOrderItemId(orderItemId);
				// newVo.setBuyoutPrice(sumLong(oldVo.getBuyoutPrice(),orderItem.getHotelSumSettlementPrice()));
				// newVo.setBuyoutTotalPrice(sumLong(oldVo.getBuyoutTotalPrice(),orderItem.getHotelTotalSettlementPrice()));
				// newVo.setBuyoutQuantity(sumLong(oldVo.getQuantity(),orderItem.getHotelSumQuantity()));
				// newVo.setBuyoutFlag("Y");
				// orderItemParams.put(orderItemId, newVo);
				// }
				// }
				//
				// List itemList = new ArrayList();
				// Iterator iter =
				// orderItemParams.entrySet().iterator();
				// while(iter.hasNext()) {
				// VstOrderItemVo itemVo =
				// (VstOrderItemVo)iter.next();
				// itemList.add(itemVo);
				// }
				// resPrecontrolBindGoodsService.updateOrderBatchHotel(itemList);
			}
		}

		/**
		 * 组装PolicyVO
		 * 
		 * @param resPrecontrolPolicy
		 * @return
		 */
		private GoodsResPrecontrolPolicyVO fillPolicyVO(ResPrecontrolPolicy resPrecontrolPolicy) {
			GoodsResPrecontrolPolicyVO goodsResPrecontrolPolicyVO = new GoodsResPrecontrolPolicyVO();
			goodsResPrecontrolPolicyVO.setAmount(resPrecontrolPolicy.getAmount());
			goodsResPrecontrolPolicyVO.setControlClassification(resPrecontrolPolicy.getControlClassification());
			goodsResPrecontrolPolicyVO.setControlType(resPrecontrolPolicy.getControlType());
			goodsResPrecontrolPolicyVO.setId(resPrecontrolPolicy.getId());
			goodsResPrecontrolPolicyVO.setIsCanDelay(resPrecontrolPolicy.getIsCanDelay());
			goodsResPrecontrolPolicyVO.setIsCanReturn(resPrecontrolPolicy.getIsCanReturn());
			goodsResPrecontrolPolicyVO.setName(resPrecontrolPolicy.getName());
			goodsResPrecontrolPolicyVO.setProductManagerId(resPrecontrolPolicy.getProductManagerId());
			goodsResPrecontrolPolicyVO.setProductManagerName(resPrecontrolPolicy.getProductManagerName());
			goodsResPrecontrolPolicyVO.setSaleEffectDate(resPrecontrolPolicy.getSaleEffectDate());
			goodsResPrecontrolPolicyVO.setSaleExpiryDate(resPrecontrolPolicy.getSaleExpiryDate());
			goodsResPrecontrolPolicyVO.setSupplierId(resPrecontrolPolicy.getSupplierId());
			goodsResPrecontrolPolicyVO.setSupplierName(resPrecontrolPolicy.getSupplierName());
			goodsResPrecontrolPolicyVO.setTradeEffectDate(resPrecontrolPolicy.getTradeEffectDate());
			goodsResPrecontrolPolicyVO.setTradeExpiryDate(resPrecontrolPolicy.getTradeExpiryDate());
			// goodsResPrecontrolPolicyVO.setSuppGoodsId(suppGoodsIds[index]);
			return goodsResPrecontrolPolicyVO;
		}

		/**
		 * 计算两个数之和
		 * 
		 * @param amt1
		 * @param amt2
		 * @return
		 */
		// private Long sumLong(Long amt1, Long amt2) {
		// Long a1 = (amt1 == null ? 0L : amt1);
		// Long a2 = (amt2 == null ? 0L : amt1);
		// Long sum = a1 + a2;
		// return sum;
		// }
		/**
		 * 设置vst子订单买断标志
		 */
		private void setVstOrderItemBudgetFlag(Long preControlPolicyID, Date pushDate, Date lastPushDate, long goodsID) {
			Map<String, Object> params = new HashMap<>(4, 1);
			params.put("preControlPolicyID", preControlPolicyID);
			params.put("goodsID", goodsID);
			params.put("from", pushDate);
			params.put("to", lastPushDate);
			resPrecontrolBindGoodsService.setVstOrderItemBudgetFlag(params);
		}

		/**
		 * 推送预控期内VST非买断订单为买断订单
		 * 
		 * @param resPrecontrolPolicy
		 * @return
		 */
		@Transactional
		private PushStatus doPushInternalOrderByGoodsId(Map<String, Object> params, ResPrecontrolPolicy resPrecontrolPolicy) {
			// 处理非酒店的VST订单
			dealNoHotelVstOrderByGoodsId(params, resPrecontrolPolicy);
			// 处理酒店的VST订单
			dealHotelVstOrderByGoodsId(params, resPrecontrolPolicy);
			return PushStatus.OK;
		}
	}
}
