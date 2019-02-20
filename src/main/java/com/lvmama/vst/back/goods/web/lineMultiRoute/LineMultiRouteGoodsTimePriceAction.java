package com.lvmama.vst.back.goods.web.lineMultiRoute;

import static com.lvmama.vst.back.prod.po.ProdLineRoute.VALID;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.comm.stamp.vo.PresaleEnum;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.po.BizEnum;
import com.lvmama.vst.back.control.po.ResPrecontrolPolicy;
import com.lvmama.vst.back.control.vo.ResPrecontrolPolicyBindVo;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.goods.po.PresaleStampTimePrice;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.goods.po.SuppGoodsLineTimePrice;
import com.lvmama.vst.back.goods.web.BaseLineMultiAction;
import com.lvmama.vst.back.prod.po.LineRouteDate;
import com.lvmama.vst.back.prod.po.ProdLineRoute;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdRefund;
import com.lvmama.vst.back.prod.po.ProdRefundRule;
import com.lvmama.vst.back.prod.po.ProdVisaDocDate;
import com.lvmama.vst.back.prod.vo.LineRouteDateVO;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.supp.vo.SuppGoodsBaseTimePriceVo.CANCELSTRATEGYTYPE;
import com.lvmama.vst.back.util.tag.VstBackOrgAuthentication;
import com.lvmama.vst.comm.utils.CalendarUtils;
import com.lvmama.vst.comm.utils.DateUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.utils.TimePriceUtils;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.back.utils.MiscUtils;

/**
 * 线路多行程时间价格表Action
 * @author LIULIANG
 * @date 2015-05-06
 */
@Controller
@RequestMapping("/lineMultiroute/goods/timePrice")
@SuppressWarnings({"unused"})
public class LineMultiRouteGoodsTimePriceAction extends BaseLineMultiAction{

	private static final long serialVersionUID = 2165895040446415243L;
	
	private static final Log log = LogFactory.getLog(LineMultiRouteGoodsTimePriceAction.class);
	
	/**
	 *  打开时间价格表页面
	 */
	@RequestMapping(value = "/showGoodsTimePrice")
	public String showGoodsTimePrice(Model model, Long prodProductId ,String cancelFlag,Long categoryId,String productType,String packageType) {
		//查询品类
		BizCategory category  = bizCategoryQueryService.getCategoryById(categoryId);
		if(category == null){
			throw new BusinessException("品类不存在");
		}
		HashMap<String,Object> goodsMap = new HashMap<String, Object>();
		//根据线路品类获取对应的商品信息
		getDataByCategoryCode(category.getCategoryCode(),categoryId,prodProductId,goodsMap);
		
		model.addAttribute("cancelFlag", cancelFlag);
		model.addAttribute("goodsMap", goodsMap);
		model.addAttribute("categoryCode", category.getCategoryCode());
		model.addAttribute("prodProductId", prodProductId);
		model.addAttribute("categoryId", categoryId);
		model.addAttribute("productType", productType);
		model.addAttribute("packageType",packageType);
		
		ProdProduct  productProduct=prodProductService.getProdProductBy(prodProductId);
		model.addAttribute("subCategoryId", productProduct.getSubCategoryId());
		return "/goods/line_multi_route/showLineMultiRouteSuppGoodsTimePrice";
	}
	
	/**
	 * 跳转到批量录入页面
	 */
	@RequestMapping(value = "/showBatchSaveLineMultiRoute")
	public String showBatchSaveLineMultiRoute(Model model, HttpServletRequest req,Long productId, Long categoryId,String productType, String packageType) throws BusinessException {
		
		if (log.isDebugEnabled()) {
			log.debug("start method<showBatchSaveLineMultiRoute>");
		}
		//查询品类
		BizCategory category  = bizCategoryQueryService.getCategoryById(categoryId);
		if(category == null){
			throw new BusinessException("品类不存在");
		}
		HashMap<String,Object> goodsMap = new HashMap<String, Object>();
		//根据线路品类获取对应的商品信息
		getDataByCategoryCode(category.getCategoryCode(),categoryId,productId,goodsMap);
		model.addAttribute("goodsMap", goodsMap);
		model.addAttribute("categoryCode", category.getCategoryCode());
		model.addAttribute("prodProductId", productId);
		model.addAttribute("categoryId", categoryId);
		model.addAttribute("packageType", packageType);
		model.addAttribute("productType", productType);
		// 检索线路产品列表 
		searchProdLineRoute(productId,model);
		log.info("@@@@@@@@@@####################");
		model.addAttribute("defaultBookLimitType", getBookLimitType(productId,categoryId));


		//查询酒店套餐的bu
		model.addAttribute("productBu", suppGoodsService.getHotelCombBu(productId));
		
		//酒店套餐
		if("category_route_hotelcomb".equals(category.getCategoryCode())){
			return "/goods/line_multi_route/dest/showBatchSaveHotelCombNew";
		}
		
		ProdProduct  productProduct=prodProductService.getProdProductBy(productId);
		model.addAttribute("subCategoryId", productProduct.getSubCategoryId());
		if(StringUtil.isEmptyString(packageType)){
			model.addAttribute("packageType", productProduct.getPackageType());
		}
		
		return "/goods/line_multi_route/showBatchSaveLineMultiRouteNew";

	}
	
	/**
	 * 跳转显示预控项目列表
	 * @param model
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/showControlProject")
	public String showControlProject(Model model,Long suppId,Long goodsId) throws BusinessException{
		//调用接口查询预控项目集合
		ResPrecontrolPolicyBindVo resPrecontrolPolicyBindVo = resPreControlService.selectBySuppId(suppId, goodsId);
		List<ResPrecontrolPolicy> resPrecontrolList = resPrecontrolPolicyBindVo.getResPrecontrolPolicies();
		if(!resPrecontrolPolicyBindVo.isBindGoods() && resPrecontrolList != null && resPrecontrolList.size()>0){
			model.addAttribute("resPrecontrolList", resPrecontrolList);
			model.addAttribute("goodsId", goodsId);
		}
		
		return "/goods/line_multi_route/showPreControlList"; 
	}
	
	/**
	 * 查询商品绑定的预控项
	 */
	@RequestMapping(value = "/showControlProjectData")
	@ResponseBody
	public Object showControlProjectData(Long suppId,Long goodsId) throws BusinessException {
		//调用接口查询预控项目集合
		ResPrecontrolPolicyBindVo resPrecontrolPolicyBindVo = resPreControlService.selectBySuppId(suppId, goodsId);
		List<ResPrecontrolPolicy> resPrecontrolList = resPrecontrolPolicyBindVo.getResPrecontrolPolicies();
		if(resPrecontrolPolicyBindVo.isBindGoods() && resPrecontrolList != null && resPrecontrolList.size()>0){
			return resPrecontrolList;
		}
		return null;
	}
	
	
	/**
	 * 跳转到单个产品录入页面
	 */
	@RequestMapping(value = "/showSaveLineMultiRoute")
	public String showSaveLineMultiRoute(Model model, HttpServletRequest req,Long productId, Long categoryId ,String productType, String packageType) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<showSaveLineMultiRoute>");
		}
		//查询品类
		BizCategory category  = bizCategoryQueryService.getCategoryById(categoryId);
		if(category == null){
			throw new BusinessException("品类不存在");
		}
		HashMap<String,Object> goodsMap = new HashMap<String, Object>();
		String date = req.getParameter("spec_date");
		//根据线路品类获取对应的商品信息
		getDataByCategoryCode(category.getCategoryCode(),categoryId,productId,goodsMap);
		model.addAttribute("goodsMap", goodsMap);
		model.addAttribute("categoryCode", category.getCategoryCode());
		model.addAttribute("prodProductId", productId);
		model.addAttribute("categoryId", categoryId);
		model.addAttribute("spec_date", date);
		model.addAttribute("productType", productType);
		model.addAttribute("packageType", packageType);
		Map<String, Object> pvddParam=new HashMap<String, Object>();
		pvddParam.put("productId",productId);//
		pvddParam.put("specDate", DateUtil.toSimpleDate(date));
		List<ProdVisaDocDate> pvddList=MiscUtils.autoUnboxing(prodVisaDocDateService.findProdVisaDocDate(pvddParam,false));//根据产品Id和游玩日期获取签证材料截止收取时间,根据这两个条件可以取到一条数据
		if(CollectionUtils.isNotEmpty(pvddList)){
			ProdVisaDocDate prodVisaDocDate=pvddList.get(0);
			model.addAttribute("lastDate", prodVisaDocDate.getLastDate());
		}
		
	
		HashMap<String,Object> params = new HashMap<String, Object>();
		if(StringUtil.isNotEmptyString(date)){
			try {
				Date specDate=  CalendarUtils.getDateFormatDate(date, "yyyy-MM-dd");
				params.put("specDate",specDate);
				params.put("productId", productId);
			} catch (Exception e) {
				log.error(e);
			}
			List<LineRouteDate> list = lineRouteDateService.findByParams(params);
			if(null!=list && !list.isEmpty()){
				model.addAttribute("lineRouteId", list.get(0).getProdLineRoute().getLineRouteId());
			}
			// 产品退改规则
			List<ProdRefund> prodRefunds = prodRefundService.selectByParams(params);
			if(null!=prodRefunds && !prodRefunds.isEmpty()){
				String str = prodRefunds.get(0).getCancelStrategy();
				model.addAttribute("cancelStrategy", str);
				List<ProdRefundRule> rules = new ArrayList<ProdRefundRule>();
				rules = prodRefunds.get(0).getProdRefundRules();
				if(rules!=null && !rules.isEmpty()){
					JSONArray jsonArray = JSONArray.fromObject(rules);					
					model.addAttribute("cancelStrategyRules", jsonArray.toString());
				}
			}
				
		}
		
		// 检索线路产品列表 
		searchProdLineRoute(productId,model);
		
		model.addAttribute("defaultBookLimitType", getBookLimitType(productId, categoryId));

		//查询酒店套餐的bu
		model.addAttribute("productBu",suppGoodsService.getHotelCombBu(productId));
		
		//酒店套餐
		if("category_route_hotelcomb".equals(category.getCategoryCode())){
			return "/goods/line_multi_route/dest/showSaveHotelCombNew";
		}
		
		ProdProduct  productProduct=prodProductService.getProdProductBy(productId);
		model.addAttribute("subCategoryId", productProduct.getSubCategoryId());
		if(StringUtil.isEmptyString(packageType)){
			model.addAttribute("packageType", productProduct.getPackageType());
		}
		return "/goods/line_multi_route/showSaveLineMultiRouteNew";
	}
	
	/**
	 * 跳转到批量修改销售价页面
	 */
	@RequestMapping(value = "/showBatchSavePrice")
	public String showBatchSavePrice(Model model, HttpServletRequest req,Long productId, Long categoryId) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<showBatchSavePrice>");
		}
		//查询品类
		BizCategory category  = bizCategoryQueryService.getCategoryById(categoryId);
		if(category == null){
			throw new BusinessException("品类不存在");
		}
		HashMap<String,Object> goodsMap = new HashMap<String, Object>();
		//根据线路品类获取对应的商品信息
		getDataByCategoryCode(category.getCategoryCode(),categoryId,productId,goodsMap);
		model.addAttribute("goodsMap", goodsMap);
		model.addAttribute("categoryCode", category.getCategoryCode());
		model.addAttribute("prodProductId", productId);
		model.addAttribute("categoryId", categoryId);
		// 检索线路产品列表 
		searchProdLineRoute(productId,model);
		return "/goods/line_multi_route/showBatchSavePrice";
	}
	
	/**
	 * 跳转到批量修改结算价页面
	 */
	@RequestMapping(value = "/showBatchSaveSellmentPrice")
	public String showBatchSaveSellmentPrice(Model model, HttpServletRequest req,Long productId, Long categoryId) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<showBatchSaveSellmentPrice>");
		}
		//查询品类
		BizCategory category  = bizCategoryQueryService.getCategoryById(categoryId);
		if(category == null){
			throw new BusinessException("品类不存在");
		}
		HashMap<String,Object> goodsMap = new HashMap<String, Object>();
		//根据线路品类获取对应的商品信息
		getDataByCategoryCode(category.getCategoryCode(),categoryId,productId,goodsMap);
		
		model.addAttribute("goodsMap", goodsMap);
		model.addAttribute("categoryCode", category.getCategoryCode());
		model.addAttribute("prodProductId", productId);
		model.addAttribute("categoryId", categoryId);
		// 检索线路产品列表 
		searchProdLineRoute(productId,model);
		
		return "/goods/line_multi_route/showBatchSaveSellmentPrice";
	}
	
	/**
	 * 跳转到批量禁售页面
	 */
	@RequestMapping(value = "/showBatchSuppGoodsLockUp")
	public String showBatchSuppGoodsLockUp(Model model, HttpServletRequest req,Long productId, Long categoryId) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<showBatchSaveCancelStrategy>");
		}
		//查询品类
		BizCategory category  = bizCategoryQueryService.getCategoryById(categoryId);
		if(category == null){
			throw new BusinessException("品类不存在");
		}
		HashMap<String,Object> goodsMap = new HashMap<String, Object>();
		//根据线路品类获取对应的商品信息
		getDataByCategoryCode(category.getCategoryCode(),categoryId,productId,goodsMap);
		model.addAttribute("goodsMap", goodsMap);
		model.addAttribute("categoryCode", category.getCategoryCode());
		model.addAttribute("prodProductId", productId);
		model.addAttribute("categoryId", categoryId);
		// 检索线路产品列表 
		searchProdLineRoute(productId,model);
		
		return "/goods/line_multi_route/showBatchSuppGoodsLockUp";
	}
	
	/**
	 * 跳转到批量修改退改规则页面
	 */
	@RequestMapping(value = "/showBatchSaveCancelStrategy")
	public String showBatchSaveCancelStrategy(Model model, HttpServletRequest req,Long productId, Long categoryId) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<showBatchSaveCancelStrategy>");
		}
		//查询品类
		BizCategory category  = bizCategoryQueryService.getCategoryById(categoryId);
		if(category == null){
			throw new BusinessException("品类不存在");
		}
		HashMap<String,Object> goodsMap = new HashMap<String, Object>();
		//根据线路品类获取对应的商品信息
		getDataByCategoryCode(category.getCategoryCode(),categoryId,productId,goodsMap);
		model.addAttribute("goodsMap", goodsMap);
		model.addAttribute("categoryCode", category.getCategoryCode());
		model.addAttribute("prodProductId", productId);
		model.addAttribute("categoryId", categoryId);
		// 检索线路产品列表 
		searchProdLineRoute(productId,model);
		
		return "/goods/line_multi_route/showBatchSaveCancelStrategy";
	}
	
	
	/**
	 * 获得商品时间价格 库存 提前预订时间
	 */
	@RequestMapping(value = "/findSuppGoodsInfoByIdAndSpecDate")
	@ResponseBody
	public Object findSuppGoodsInfoByIdAndSpecDate(Model model, String specDate, Long suppGoodsId, String categoryCode,HttpServletRequest req) throws BusinessException {
		List<SuppGoodsLineTimePrice> list = new ArrayList<SuppGoodsLineTimePrice>();
		if(null!=suppGoodsId && suppGoodsId>0 && StringUtil.isNotEmptyString(specDate)){
			Map<String, Object> parameters = new HashMap<String, Object>();
			parameters.put("suppGoodsId", suppGoodsId);
			parameters.put("specDate",CalendarUtils.getDateFromString(specDate, "yyyy-MM-dd"));
			List<SuppGoodsLineTimePrice> tempList = suppGoodsLineTimePriceService.findSuppGoodsLineTimePriceList(parameters);
			//查询买断
			SuppGoods suppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoodsId, true));
			for (int index = 0; index < tempList.size() ; index ++ ) {
				SuppGoodsLineTimePrice LineTimePrice = tempList.get(index);
				LineTimePrice.setIsPreControl(suppGoods.getBuyoutFlag());
				LineTimePrice = resControlBudgetRemote.setLineBudgetPriceForPre(LineTimePrice);
				tempList.set(index, LineTimePrice);
				
				//查询绑定预控项目
				ResPrecontrolPolicyBindVo resPrecontrolPolicyBindVo = resControlBudgetRemote.selectBySuppId(suppGoods.getSupplierId(), suppGoodsId);
				if(resPrecontrolPolicyBindVo.isBindGoods()){
					LineTimePrice.setResPrecontrolPolicies(resPrecontrolPolicyBindVo.getResPrecontrolPolicies());
				}
			}
			
			
			for(int m=0;m<tempList.size();m++){
				SuppGoodsLineTimePrice p = tempList.get(m);
				if("category_route_hotelcomb".equals(categoryCode)&&categoryCode!=null){
					Map<String, Object> hotelmap=new HashMap<String, Object>();
					hotelmap.put("goodsId", p.getSuppGoodsId());
					hotelmap.put("specDate", p.getSpecDate());
					PresaleStampTimePrice  hotelpresaleStampTimePrice= goodsPresaleStampTimePriceService.toSetPresaleStampTime(hotelmap);
					if(hotelpresaleStampTimePrice!=null){
						p.setBringPreSale(hotelpresaleStampTimePrice.getIsPreSale());
						p.setHotelShowPreSale_pre(hotelpresaleStampTimePrice.getValue());
						p.setHotelIsBanSell(hotelpresaleStampTimePrice.getIsBanSell());
					}
				}else{
					Map<String, Object> auditmap=new HashMap<String, Object>();
					auditmap.put("goodsId", p.getSuppGoodsId());
					auditmap.put("specDate", p.getSpecDate());
					auditmap.put("priceClassificationCode",PresaleEnum.PRICE_CLASSIFICATION_CODE.AUDIT.toString());
					PresaleStampTimePrice auditpresaleStampTimePrice= goodsPresaleStampTimePriceService.toSetPresaleStampTime(auditmap);
					Map<String, Object> childmap=new HashMap<String, Object>();
					childmap.put("goodsId", p.getSuppGoodsId());
					childmap.put("specDate", p.getSpecDate());
					childmap.put("priceClassificationCode",PresaleEnum.PRICE_CLASSIFICATION_CODE.CHILD.toString());
					PresaleStampTimePrice childpresaleStampTimePrice= goodsPresaleStampTimePriceService.toSetPresaleStampTime(childmap);
					if(auditpresaleStampTimePrice!=null||childpresaleStampTimePrice!=null){
						p.setBringPreSale(auditpresaleStampTimePrice.getIsPreSale());
						p.setAuditShowPreSale_pre(auditpresaleStampTimePrice.getValue());
						p.setChildShowPreSale_pre(childpresaleStampTimePrice.getValue());
						p.setAuditIsBanSell(auditpresaleStampTimePrice.getIsBanSell());
						p.setChildIsBanSell(childpresaleStampTimePrice.getIsBanSell());
					}
					
				}
			}
			
			if(tempList!=null){
				list.addAll(tempList);
			}
		}
		return list;
	}

	/**获取一天的销售信息[支持多个商品]
	 * @param req
	 * @param model
	 * @param specDate		日期
	 * @param productId		产品ID
	 * @param suppGoodsIds  商品Ids
	 * @return
	 */
	@RequestMapping("/getOneDaySalesInfo")
	@ResponseBody
	public Object getOneDaySalesInfo(HttpServletRequest req,Model model ,String specDate,String productId,String suppGoodsIds,String categoryCode){
		
		List<SuppGoodsLineTimePrice> list = new ArrayList<SuppGoodsLineTimePrice>();
		String[] goodsArr = suppGoodsIds.split("##");
		if(goodsArr!=null && goodsArr.length>0)
		for(int m=0,n=goodsArr.length;m<n;m++){
			Long suppGoodsId = Long.valueOf(goodsArr[m]);
			if (null != suppGoodsId && suppGoodsId > 0
					&& StringUtil.isNotEmptyString(specDate)) {
				Date date  = CalendarUtils.getDateFromString(specDate, "yyyy-MM-dd");
				
				Map<String, Object> parameters = new HashMap<String, Object>();
				parameters.put("suppGoodsId", suppGoodsId);
				parameters.put("specDate",	date);
				List<SuppGoodsLineTimePrice> tempList = suppGoodsLineTimePriceService.findSuppGoodsLineTimePriceList(parameters);
				SuppGoods suppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoodsId));
				for (int index =0; index < tempList.size() ; index ++) {
					SuppGoodsLineTimePrice LineTimePrice = tempList.get(index);
					LineTimePrice.setIsPreControl(suppGoods.getBuyoutFlag());
					LineTimePrice = resControlBudgetRemote.setLineBudgetPriceForPre(LineTimePrice);
					tempList.set(index, LineTimePrice);
				}			
				SuppGoodsLineTimePrice timePrice = null;
				if (tempList != null && tempList.size() > 0) {
					timePrice = tempList.get(0);
				}
				if(timePrice == null){
					continue;
				}
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("productId", productId);
				params.put("specDate", date);
				List<ProdRefund> prodRefunds = prodRefundService
						.selectByParams(params);
				ProdRefund prodRefund = null;
				if (prodRefunds != null && prodRefunds.size() > 0) {
					prodRefund = prodRefunds.get(0);
	//				json = "[{\"refundId\":\"" + prodRefund.getRefundId()
	//						+ "\",\"productId\":\"" + prodRefund.getProductId()
	//						+ "\",\"specDate\":\"" + prodRefund.getSpecDateStr()
	//						+ "\",\"cancelStrategy\":\""
	//						+ prodRefund.getCancelStrategy() + "\"}]";
				}
	
				Map<String, Object> lineRouteparams = new HashMap<String, Object>(
						2, 1f);
				lineRouteparams.put("specDate",date);
				lineRouteparams.put("productId", productId);
				List<LineRouteDate> alist = lineRouteDateService.findByParams(lineRouteparams);
				LineRouteDate lineRouteDate = null;
				Long lineRouteId = -1L;
				if (null != alist && !alist.isEmpty()) {
					lineRouteDate = alist.get(0);
					lineRouteId = lineRouteDate.getProdLineRoute().getLineRouteId();
	//				json = "[{\"lineRouteId\":\"" + lineRouteId + "\"}]";
				}
				if (prodRefund != null) {
					timePrice.setCancelStrategy(prodRefund.getCancelStrategy());
					timePrice.setCancelStrategyRules(prodRefund.getProdRefundRules());
				}
				if (lineRouteId != -1) {
					// 这里存放行程的ID
					timePrice.setRouteName(String.valueOf(lineRouteId));
				}
				//设置预售
					if ("category_route_hotelcomb".equals(categoryCode)
							&& categoryCode != null) {
						Map<String, Object> hotelmap = new HashMap<String, Object>();
						hotelmap.put("goodsId", suppGoodsId);
						hotelmap.put("specDate", date);
						PresaleStampTimePrice hotelpresaleStampTimePrice = goodsPresaleStampTimePriceService
								.toSetPresaleStampTime(hotelmap);
						if (hotelpresaleStampTimePrice != null) {
							timePrice
									.setBringPreSale(hotelpresaleStampTimePrice
											.getIsPreSale());
							timePrice
									.setHotelShowPreSale_pre(hotelpresaleStampTimePrice
											.getValue());
							timePrice.setHotelIsBanSell(hotelpresaleStampTimePrice.getIsBanSell());
						}
					} else {
						Map<String, Object> auditmap = new HashMap<String, Object>();
						auditmap.put("goodsId", suppGoodsId);
						auditmap.put("specDate", date);
						auditmap.put("priceClassificationCode",
								PresaleEnum.PRICE_CLASSIFICATION_CODE.AUDIT
										.toString());
						PresaleStampTimePrice auditpresaleStampTimePrice = goodsPresaleStampTimePriceService
								.toSetPresaleStampTime(auditmap);
						Map<String, Object> childmap = new HashMap<String, Object>();
						childmap.put("goodsId", suppGoodsId);
						childmap.put("specDate", date);
						childmap.put("priceClassificationCode",
								PresaleEnum.PRICE_CLASSIFICATION_CODE.CHILD
										.toString());
						PresaleStampTimePrice childpresaleStampTimePrice = goodsPresaleStampTimePriceService
								.toSetPresaleStampTime(childmap);
						if (auditpresaleStampTimePrice != null
								|| childpresaleStampTimePrice != null) {
							timePrice
									.setBringPreSale(auditpresaleStampTimePrice
											.getIsPreSale());
							timePrice
									.setAuditShowPreSale_pre(auditpresaleStampTimePrice
											.getValue());
							timePrice
									.setChildShowPreSale_pre(childpresaleStampTimePrice
											.getValue());
							timePrice.setAuditIsBanSell(auditpresaleStampTimePrice.getIsBanSell());
							timePrice.setChildIsBanSell(childpresaleStampTimePrice.getIsBanSell());
						}

					}
			
				list.add(timePrice);
			}
		}
	

		return list;
	}

	 /*
	 * @param model
	 * @param request
	 * @param lineRouteDateVO
	 * @param categoryId
	 * @param updateWhat   0  库存，  1 价格   2  提前预定时间
	 * @return
	 */
	@RequestMapping(value = "/editExistsSuppGoods")
	@ResponseBody
	public Object editExistsSuppGoods(Model model, HttpServletRequest request,LineRouteDateVO lineRouteDateVO,Long categoryId,Long updateWhat){
		if (log.isDebugEnabled()) {
			log.debug("start method<editExistsSuppGoods>" + updateWhat);
		}
		if(null==lineRouteDateVO){
			return new ResultMessage("error", "参数错误");
		}
		if(null==updateWhat){
			return new ResultMessage("error", "参数错误-请标记修改的具体内容");
		}
		if(categoryId!=null && categoryId==17L && updateWhat!=null && updateWhat==0L){//Added by yangzhenzhong 如果是酒店套餐且更新库存时，校验新设库存和已售出的库存

			Long maxSelloutStock = lineRouteDateService.validateSelloutStock(lineRouteDateVO);
			if(maxSelloutStock>0){// 存在新设的库存值小于已售出的库存值的情况

				ResultMessage resultMessage = new ResultMessage("validateStock",maxSelloutStock.toString());
				return  resultMessage;
			}
		}
		if( updateWhat!=null&&updateWhat.intValue() == 6){
			//预售价格设置
			try {
				lineRouteDateService.saveOrUpdatePresalePrice(lineRouteDateVO,this.getLoginUser().getUserName());
			} catch (Exception e) {
				return new ResultMessage("error", e.getMessage());
			}
		}
		String logStr ="";
		String str = "";
		try 
		{
			//5是买断设置
			if(updateWhat.intValue() != 5)
			{
				if(updateWhat.intValue() == 0)
					lineRouteDateVO.setIsSetStock("Y");
				if(updateWhat.intValue() == 1)
					lineRouteDateVO.setIsSetPrice("Y");
				if(updateWhat.intValue() == 2)
					lineRouteDateVO.setIsSetAheadBookTime("Y");			
				logStr = getTimePriceChangeLog(lineRouteDateVO,lineRouteDateVO.getProductId(),true,false,false);
				//更新时间价格
				try {
					int flag = updateWhat.intValue();
					str = lineRouteDateService.editExistsSuppGoods(lineRouteDateVO,flag, this.getLoginUser().getUserName());
				} catch (BusinessException e1) {
					return new ResultMessage("error", e1.getMessage());
				}
				
				//设置日志
				if(StringUtils.isNotBlank(logStr + str)){
				   try {
			            comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
			            	   lineRouteDateVO.getProductId(), lineRouteDateVO.getProductId(), 
			            	   this.getLoginUser().getUserName(),
			                    "修改时间价格表:"+logStr + "\r\n" + str, 
			                    COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_TIME.name(), 
			                    "修改时间价格表",null);
			        } catch (Exception e) {
			            log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
			            log.error(e.getMessage());
			        }
				}
			}else
			{
				//5：买断设置TAB
				if(updateWhat.intValue() == 5){
				  lineRouteDateService.updateLinePreControlPrice(lineRouteDateVO);
				  //添加买断日志
//				  logStr = getTimePriceChangeLog(lineRouteDateVO,lineRouteDateVO.getProductId(),true,false,false);
//					if(StringUtils.isNotBlank(logStr)){
//						   try {
//					            comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
//					            	   lineRouteDateVO.getProductId(), lineRouteDateVO.getProductId(), 
//					            	   this.getLoginUser().getUserName(),
//					                    "修改买断时间价格表:"+logStr, 
//					                    COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_TIME.name(), 
//					                    "修改买断时间价格表",null);
//					        } catch (Exception e) {
//					            log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
//					            log.error(e.getMessage());
//					        }
//						}
				  
				}
			
			}
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
           log.error(e.getMessage());
		}
		return ResultMessage.SET_SUCCESS_RESULT;
	}
	
	
	/**
	 * 跳转到批量修改销售价、结算价  页面
	 */
	@RequestMapping(value = "/showEditBatchPrice")
	public String showEditBatchPrice(Model model, HttpServletRequest req,Long productId, Long categoryId, String productType, String packageType) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<showEditBatchPrice>");
		}
		//查询品类
		BizCategory category  = bizCategoryQueryService.getCategoryById(categoryId);
		if(category == null){
			throw new BusinessException("品类不存在");
		}
		HashMap<String,Object> goodsMap = new HashMap<String, Object>();
		//根据线路品类获取对应的商品信息
		getDataByCategoryCode(category.getCategoryCode(),categoryId,productId,goodsMap);
		model.addAttribute("goodsMap", goodsMap);
		model.addAttribute("categoryCode", category.getCategoryCode());
		model.addAttribute("prodProductId", productId);
		model.addAttribute("productId", productId);
		model.addAttribute("categoryId", categoryId);
		model.addAttribute("packageType", packageType);
		model.addAttribute("productType", productType);
		// 检索线路产品列表 
		Map<String, Object> params = new HashMap<String, Object>(2, 1f);
		params.put("productId", productId);
		params.put("cancleFlag", VALID);
		List<ProdLineRoute> prodLineRouteList = prodLineRouteService.findProdLineRouteByParams(params);
		model.addAttribute("prodLineRouteList", prodLineRouteList);

		//查询酒店套餐的bu
		model.addAttribute("productBu",suppGoodsService.getHotelCombBu(productId));
		
		/////////
		//酒店套餐
		if("category_route_hotelcomb".equals(category.getCategoryCode())){
			return "/goods/line_multi_route/dest/showHotelCombEditBatchPrice";
		}
		
		ProdProduct  productProduct=prodProductService.getProdProductBy(productId);
		model.addAttribute("subCategoryId", productProduct.getSubCategoryId());
		if(StringUtil.isEmptyString(packageType)){
			model.addAttribute("packageType", productProduct.getPackageType());
		}
		
		return "/goods/line_multi_route/showEditBatchPrice";
	}
	
	/**
	 * 批量录入线路多行程时间价格表
	 */
	@RequestMapping(value = "/editGoodsTimePrice")
	@ResponseBody
	public Object editGoodsTimePrice(Model model, HttpServletRequest request,LineRouteDateVO lineRouteDateVO,Long categoryId) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<saveGoodsTimePrice>");
		}
		ResultMessage resultMessage = null;
		if(null==lineRouteDateVO){
			return new ResultMessage("error", "参数错误");
		}

		if(categoryId!=null && categoryId==17L){//Added by yangzhenzhong 如果是酒店套餐时间价格表更新，校验新设库存和已售出的库存

			Long maxSelloutStock = lineRouteDateService.validateSelloutStock(lineRouteDateVO);
			if(maxSelloutStock>0){// 存在新设的库存值小于已售出的库存值的情况
				return new ResultMessage("validateStock",maxSelloutStock.toString());
			}
		}

		String logStr ="";
		try {
			lineRouteDateVO.setIsSetAheadBookTime("Y");
			lineRouteDateVO.setIsSetPrice("Y");
			lineRouteDateVO.setIsSetStock("Y");
			logStr = getTimePriceChangeLog(lineRouteDateVO,lineRouteDateVO.getProductId(),false,true,false);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
            log.error(e.getMessage());
		}
		//更新时间价格
		boolean saveFlag=false;
		String saveVisaDocLog="材料截止收取时间：【";
		String specDate="";
		String oldDate="";
		String newDate="";
		String[] upDocLastTime=lineRouteDateVO.getUpDocLastTime();
		if(upDocLastTime!=null){
			for (int i = 0; i < upDocLastTime.length; i++) {
				String upDocLastTimeTmp=upDocLastTime[i];
				String[] specLastdate=upDocLastTimeTmp.split("\\|");
				Map<String, Object> params=new HashMap<String, Object>();
				params.put("productId", lineRouteDateVO.getProductId());
				params.put("specDate", DateUtil.toDate(specLastdate[0], "yyyy-MM-dd"));
				specDate=specLastdate[0];
				newDate=specLastdate[1]; //获取新的上传材料日期
				
				List<ProdVisaDocDate> pvddList=MiscUtils.autoUnboxing(prodVisaDocDateService.findProdVisaDocDate(params,false));
				if(pvddList!=null && pvddList.size()>0){
					ProdVisaDocDate visaDocDate = pvddList.get(0);
					oldDate=DateUtil.formatDate(visaDocDate.getLastDate(), "yyyy-MM-dd") ;//获取原上传材料日期
				}
				saveVisaDocLog+="出发日期："+specDate+",原值："+oldDate+",新值："+newDate+";";
			}
		}
		saveVisaDocLog+="】";
		try {
			Map<String,Object> result = lineRouteDateService.saveOrUpdateLineRouteDate(lineRouteDateVO);
			//预售价格设置
			lineRouteDateService.saveOrUpdatePresalePrice(lineRouteDateVO,this.getLoginUser().getUserName());
			saveFlag=prodVisaDocDateService.saveOrUpdateVisaDocDate(lineRouteDateVO.getProductId(), lineRouteDateVO.getUpDocLastTime()); //保存签证材料最晚上传时间
			resultMessage = ResultMessage.SET_SUCCESS_RESULT;
			Map<String, Object> attributesMap = new HashMap<String, Object>();
			attributesMap.put("infoMsg", result.get("infoMsg"));
			resultMessage.setAttributes(attributesMap);
		} catch (Exception e1) {
			return new ResultMessage("error", e1.getMessage());
		}
		
		if(saveFlag){
			logStr+=saveVisaDocLog;
		}
		
		//设置日志
		if(StringUtils.isNotBlank(logStr)){
		   try {
	            comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
	            	   lineRouteDateVO.getProductId(), lineRouteDateVO.getProductId(), 
	                   this.getLoginUser().getUserName(),
	                    "修改时间价格表:"+logStr+";", 
	                    COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_TIME.name(), 
	                    "修改时间价格表",null);
	            
	        } catch (Exception e) {
	            log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
	            log.error(e.getMessage());
	        }
		}
		if(saveFlag){
			comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, 
	            	   lineRouteDateVO.getProductId(), lineRouteDateVO.getProductId(), 
	                   this.getLoginUser().getUserName(),
	                    "修改时间价格表:日期"+logStr, 
	                    COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_TIME.name(), 
	                    "修改时间价格表",null);
		}
		return resultMessage;
	}
	
	/**
	 * 修改线路多行程退改规则页面
	 */
	@RequestMapping(value = "/editLineMultiRouteCancelStrategy")
	@ResponseBody
	public Object editLineMultiRouteCancelStrategy(Model model, HttpServletRequest request,ProdRefund prodRefund,Long prodProductId,Long categoryId) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<editLineMultiRouteCancelStrategy>");
		}
		if(prodRefund==null){
			throw new BusinessException("退改规则设置失败");
		}
		
		String logStr ="";
		try {
			logStr = getProdRefundLog(prodRefund);
		} catch (Exception e) {
			log.error(e.getMessage());
		}
		prodRefundService.updateProdRefund(prodRefund);
		try {
            comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
                    prodRefund.getProductId(), prodRefund.getProductId(), 
                    this.getLoginUser().getUserName(), 
                    "修改退改规则:"+logStr, 
                    COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_TIME.name(), 
                    "修改退改规则:",null);
        } catch (Exception e) {
            log.debug(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS.getCnName()+"日志操作异常！");
        }
		return ResultMessage.SET_SUCCESS_RESULT;
	}
	
	/**
	 * 批量修改线路多行程结算价\销售价页面
	 */
	@RequestMapping(value = "/editLineMultiRoutePrice")
	@ResponseBody
	public Object editLineMultiRoutePrice(Model model, HttpServletRequest request,LineRouteDateVO lineRouteDateVO,Long prodProductId,Long categoryId){
		if (log.isDebugEnabled()) {
			log.debug("start method<editLineMultiRoutePrice>");
		}
		if(lineRouteDateVO==null){
			throw new BusinessException("价格设置失败");
		}
		StringBuffer logStr = new StringBuffer();
		try {
			lineRouteDateVO.setIsSetPrice("Y");
			updateLineMultiRoutePriceLog(logStr, lineRouteDateVO);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
            log.error(e.getMessage());
		}
		
		// 修改线路结算价\销售价
		try {
			lineRouteDateService.updateBathTimePriceAtNew(lineRouteDateVO);
		} catch (BusinessException e1) {
			return new ResultMessage("error",e1.getMessage());
		}
		
		if(StringUtils.isNotBlank(logStr)){
			  try {
		            comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
		            		lineRouteDateVO.getProductId(), lineRouteDateVO.getProductId(), 
		                    this.getLoginUser().getUserName(),
		                    "修改结算价或销售价:"+logStr.toString(), 
		                    COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_TIME.name(), 
		                    "修改时间价格表",null);
		        } catch (Exception e) {
		            log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
		            log.error(e.getMessage());
		        }
		}
		return ResultMessage.SET_SUCCESS_RESULT;
	}
	
	/**
	 * 修改线路多行程时间价格禁售规则
	 */
	@RequestMapping(value = "/editLineMultiRouteLockUp")
	@ResponseBody
	public Object editLineMultiRouteLockUp(Model model, HttpServletRequest request,LineRouteDateVO lineRouteDateVO,Long prodProductId,Long categoryId) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<editLineMultiRouteLockUp>");
		}
		if(lineRouteDateVO==null){
			throw new BusinessException("禁售规则设置失败");
		}
		StringBuffer logStr = new StringBuffer();
		try {
			lineRouteDateVO.setIsSetPrice("Y");
			updateLineMultiRouteLockUpLog(logStr,lineRouteDateVO);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
            log.error(e.getMessage());
		}
		lineRouteDateService.updateBathTimePrice(lineRouteDateVO);
		if(StringUtils.isNotBlank(logStr)){
		  try {
	            comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
	            		lineRouteDateVO.getProductId(), lineRouteDateVO.getProductId(), 
	                   this.getLoginUser().getUserName(),
	                    "修改禁售规则:"+logStr.toString(), 
	                    COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_TIME.name(), 
	                    "修改时间价格表",null);
	        } catch (Exception e) {
	            log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
	            log.error(e.getMessage());
	        }
		}
		return ResultMessage.SET_SUCCESS_RESULT;
	}
	
	 
	/**
	 * 获得时间价格列表
	 */
	@RequestMapping(value = "/findGoodsTimePriceList")
	@ResponseBody
	public Object findGoodsTimePriceList(Model model, Date specDate, HttpServletRequest req, HttpServletResponse resp) throws Exception {
		List<SuppGoodsLineTimePrice> list = new ArrayList<SuppGoodsLineTimePrice>();
		List<SuppGoodsLineTimePrice> dtos = new ArrayList<SuppGoodsLineTimePrice>();
		String[] goodsIdArray = req.getParameterValues("suppGoodsId");
		String productId = req.getParameter("productId");
		if(null!=goodsIdArray && goodsIdArray.length>0 && StringUtil.isNumber(productId)){
			for(String goodsId : goodsIdArray){
				Map<String, Object> parameters = new HashMap<String, Object>();
				if(goodsId!=null && !"".equalsIgnoreCase(goodsId)){
					parameters.put("suppGoodsId", goodsId);
					parameters.put("beginDate",CalendarUtils.getFirstDayOfMonth(specDate));
					parameters.put("endDate", CalendarUtils.getLastDayOfMonth(specDate));
				}
				List<SuppGoodsLineTimePrice> tempList = prodLineRouteService.findSuppGoodsTimePriceAndLineRoute(parameters,Long.valueOf(productId));
				//设置买断价
				//将正常价，放入这些字段
				if(tempList !=null)
				for(int x=0,y=tempList.size();x<y;x++){
					SuppGoodsLineTimePrice p = tempList.get(x);
					p.setAuditPrice_pre(p.getAuditPrice());
					p.setAuditSettlementPrice_pre(p.getAuditSettlementPrice());
					p.setChildPrice_pre(p.getChildPrice());
					p.setChildSettlementPrice_pre(p.getChildSettlementPrice());
				}
				
				SuppGoods suppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(Long.valueOf(goodsId)));				
				tempList = resControlBudgetRemote.toSetLineBudgetPrice(tempList, suppGoods);
				
				if(tempList !=null)
				for(int x=0,y=tempList.size();x<y;x++){
					SuppGoodsLineTimePrice p = tempList.get(x);
					if(p == null){continue;}

					//Added by yangzhenzhong  增加BU属性,类别ID
					p.setBu(suppGoods.getBu());
					p.setCategoryId(suppGoods.getCategoryId());
					//end

					Long a = p.getAuditPrice();
					p.setAuditPrice(p.getAuditPrice_pre());
					p.setAuditPrice_pre(a);
					
					Long b = p.getAuditSettlementPrice();
					p.setAuditSettlementPrice(p.getAuditSettlementPrice_pre());
					p.setAuditSettlementPrice_pre(b);
					
					Long c = p.getChildPrice();
					p.setChildPrice(p.getChildPrice_pre());
					p.setChildPrice_pre(c);
					
					Long d = p.getChildSettlementPrice();
					p.setChildSettlementPrice(p.getChildSettlementPrice_pre());
					p.setChildSettlementPrice_pre(d);
				}
				for(int m=0;m<tempList.size();m++){
					SuppGoodsLineTimePrice p = tempList.get(m);
					if("category_route_hotelcomb".equals(req.getParameter("categoryCode"))&&req.getParameter("categoryCode")!=null){
						Map<String, Object> hotelmap=new HashMap<String, Object>();
						hotelmap.put("goodsId", p.getSuppGoodsId());
						hotelmap.put("specDate", p.getSpecDate());
						PresaleStampTimePrice  hotelpresaleStampTimePrice= goodsPresaleStampTimePriceService.toSetPresaleStampTime(hotelmap);
						if(hotelpresaleStampTimePrice!=null){
							p.setBringPreSale(hotelpresaleStampTimePrice.getIsPreSale());
							p.setHotelShowPreSale_pre(hotelpresaleStampTimePrice.getValue());
							p.setHotelIsBanSell(hotelpresaleStampTimePrice.getIsBanSell());
						}
					}else{
					Map<String, Object> auditmap=new HashMap<String, Object>();
					auditmap.put("goodsId", p.getSuppGoodsId());
					auditmap.put("specDate", p.getSpecDate());
					auditmap.put("priceClassificationCode",PresaleEnum.PRICE_CLASSIFICATION_CODE.AUDIT.toString());
					PresaleStampTimePrice auditpresaleStampTimePrice= goodsPresaleStampTimePriceService.toSetPresaleStampTime(auditmap);
					Map<String, Object> childmap=new HashMap<String, Object>();
					childmap.put("goodsId", p.getSuppGoodsId());
					childmap.put("specDate", p.getSpecDate());
					childmap.put("priceClassificationCode",PresaleEnum.PRICE_CLASSIFICATION_CODE.CHILD.toString());
					PresaleStampTimePrice childpresaleStampTimePrice= goodsPresaleStampTimePriceService.toSetPresaleStampTime(childmap);
					if(auditpresaleStampTimePrice!=null||childpresaleStampTimePrice!=null){
						p.setBringPreSale(auditpresaleStampTimePrice.getIsPreSale());
						p.setAuditShowPreSale_pre(auditpresaleStampTimePrice.getValue());
						p.setChildShowPreSale_pre(childpresaleStampTimePrice.getValue());
						p.setAuditIsBanSell(auditpresaleStampTimePrice.getIsBanSell());
						p.setChildIsBanSell(childpresaleStampTimePrice.getIsBanSell());
					}
					}
				}
				
				if(tempList!=null){
					list.addAll(tempList);
				}
				
			}
			 
		}
		if(null!=list && !list.isEmpty()){
			Map<Date,Date> valueMap = new HashMap<Date,Date>();
			Map<Date,Date> valueMap1 = new HashMap<Date,Date>();
			for (SuppGoodsLineTimePrice dto : list) {
				HashMap<String, Object> search = new HashMap<String, Object>();
				Date sDate = dto.getSpecDate();
				// 根据产品ID与游玩日期获取产品行程信息
				ProdLineRoute prodLineRoute = prodLineRouteService.findLineRouteId(Long.valueOf(productId),sDate);
				if(null!=prodLineRoute){
					if(!isExis(sDate,valueMap)){
						dto.setRouteName(prodLineRoute.getRouteName());
					}
				}
				HashMap<String, Object> searchParams = new HashMap<String, Object>();
				searchParams.put("specDate", sDate);
				searchParams.put("productId", productId);
				// 产品退改规则
				List<ProdRefund> prodRefunds = prodRefundService.selectByParams(searchParams);
				if(null!=prodRefunds && !prodRefunds.isEmpty()){
					String str = CANCELSTRATEGYTYPE.getCnName(prodRefunds.get(0).getCancelStrategy());
					if(!isExis(sDate,valueMap1)){
						dto.setCancelStrategyName(str);
						dto.setErrorRefundStrategy(TimePriceUtils.checkRefundAndPrice(prodRefunds.get(0),dto));
					}
				}
				dtos.add(dto);
			}
			//加载vst权限
			super.loadVstOrgAuthentication(log, VstBackOrgAuthentication.class, list);
		}
		return dtos;
	}
	
		
	/**
	 * 判断商品是否是已经买断的商品
	 */
	@RequestMapping(value = "/isPreBudgeGoods")
	@ResponseBody
	public Object isPreBudgeGoods(String goodsArrays) throws BusinessException {
		Map<String, Object> map = new HashMap<String, Object>();
		StringBuffer strMsg = new StringBuffer("");
		if(StringUtils.isNotEmpty(goodsArrays)){
			String[] goods = goodsArrays.split(",");
			if(goods.length>0)
			{
				for (String goodsId : goods) 
				{
					if (goodsId != null && ! "undefined".equals(goodsId)) {
						SuppGoods suppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(Long.valueOf(goodsId)));
						if(StringUtils.isNotEmpty(suppGoods.getBuyoutFlag()) && "Y".equals(suppGoods.getBuyoutFlag())){
							strMsg.append("("+suppGoods.getGoodsName()+")");						
						}		 
					}
				}
			}
		}
		
		if(StringUtils.isNotEmpty(strMsg.toString()))
		{
			map.put("data", "Y");
			map.put("errMsg", "商品"+strMsg+"已经设置为可预控商品,是否重新设置？");
		}else{
			map.put("data", "N");
		}
		return map;
	}

	
	  //时间价格表相关页面预授权默认值设置(不使用预授权NOT_PREAUTH)
	    protected  String getBookLimitType(Long productId,Long categoryId){
			String defaultBookLimitType="NONE";
		    ProdProduct product = prodProductService.getProductPropInfoFromCacheById(productId, new HashMap<String, Object>());  
		    SuppGoods suppGoods = suppGoodsService.findBaseSuppGoodsByProductId(productId);
		    if(product==null) return defaultBookLimitType;
		    if(suppGoods==null) return defaultBookLimitType;
		    String  productType=product.getProductType();//产品类型
		    if(!StringUtil.isNotEmptyString(productType))  return defaultBookLimitType;
		    Long subCategoryId=product.getSubCategoryId();//子品类
		    
		    boolean innerBoolean="INNERSHORTLINE".equals(product.getProductType())||//国内-短线
		             "INNERLONGLINE".equals(product.getProductType())||//国内-长线
		             "INNERLINE".equals(product.getProductType());//国内
		    boolean outBoolean = ProdProduct.PRODUCTTYPE.FOREIGNLINE.name().equals(product.getProductType());
		    
			//跟团游：跟团游-国内
			if(BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCategoryId().equals(categoryId)&&innerBoolean){
				defaultBookLimitType="NOT_PREAUTH";
			}
			//跟团游：跟团游-出境
			if(BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCategoryId().equals(categoryId)&&outBoolean){
				defaultBookLimitType="NOT_PREAUTH";
			}
			//当地游：当地游-国内
			if(BizEnum.BIZ_CATEGORY_TYPE.category_route_local.getCategoryId().equals(categoryId)&&innerBoolean){
				defaultBookLimitType="NOT_PREAUTH";
			}
			//自由行：自由行-国内-机酒（三级品类182） 、
			//     自由行-国内-交通+服务（三级品类 183）
			//     自由行-国内-巴士+酒 （三级品类 184）
			//     自由行 -国内 -景酒（三级品类  181）且所属 BU为国内游事业部    
			if(BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCategoryId().equals(categoryId)&&innerBoolean){
				if(new Long(182l).equals(subCategoryId) ||new Long(183l).equals(subCategoryId) ||new Long(184l).equals(subCategoryId)){
					defaultBookLimitType="NOT_PREAUTH";
				}else if(new Long(181l).equals(subCategoryId)){
					if("LOCAL_BU".equals(suppGoods.getBu())){
						defaultBookLimitType="NOT_PREAUTH";
					}
				}
			}
			//酒店套餐：国内-所属BU为国内游事业部    
			if(BizEnum.BIZ_CATEGORY_TYPE.category_route_hotelcomb.getCategoryId().equals(categoryId)&&innerBoolean){
				if("LOCAL_BU".equals(suppGoods.getBu())){
					defaultBookLimitType="NOT_PREAUTH";
				}
			}

            //定制游-国内
            if(BizEnum.BIZ_CATEGORY_TYPE.category_route_customized.getCategoryId().equals(categoryId)&&innerBoolean){
                defaultBookLimitType="NOT_PREAUTH";
            }
            //定制游-出境
            if(BizEnum.BIZ_CATEGORY_TYPE.category_route_customized.getCategoryId().equals(categoryId)&&outBoolean){
                defaultBookLimitType="NOT_PREAUTH";
            }

			return defaultBookLimitType;
		}
}
