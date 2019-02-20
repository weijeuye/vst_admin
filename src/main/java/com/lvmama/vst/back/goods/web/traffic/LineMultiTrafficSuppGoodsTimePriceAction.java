package com.lvmama.vst.back.goods.web.traffic;

import java.util.ArrayList;
import java.util.Collections;
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
import com.lvmama.comm.stamp.vo.PresaleEnum;
import com.lvmama.vst.back.biz.po.BizBranch;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.service.BizBranchQueryService;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.goods.po.PresaleStampTimePrice;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.goods.po.SuppGoodsFApiTimePrice;
import com.lvmama.vst.back.goods.po.SuppGoodsLineTimePrice;
import com.lvmama.vst.back.goods.po.SuppGoodsTimePrice;
import com.lvmama.vst.supp.client.service.SuppGoodsLineTimePriceClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.goods.web.BaseLineMultiAction;
import com.lvmama.vst.back.prod.po.ProdLineRoute;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductBranch;
import com.lvmama.vst.back.prod.po.ProdRefund;
import com.lvmama.vst.back.prod.service.LineRouteDateService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteClientService;
import com.lvmama.vst.back.prod.service.ProdProductBranchService;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.prod.service.ProdRefundService;
import com.lvmama.vst.back.prod.vo.LineRouteDateVO;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.pub.service.ComPushClientService;
import com.lvmama.vst.back.supp.po.SuppContract;
import com.lvmama.vst.back.supp.po.SuppSupplier;
import com.lvmama.vst.back.client.supp.service.SuppSupplierClientService;
import com.lvmama.vst.back.supp.vo.SuppGoodsBaseTimePriceVo.CANCELSTRATEGYTYPE;
import com.lvmama.vst.back.util.tag.VstBackOrgAuthentication;
import com.lvmama.vst.comm.utils.CalendarUtils;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.DateUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.pet.goods.PetProdGoodsAdapter;
import com.lvmama.vst.back.utils.MiscUtils;

/**
 * 其它机票、火车票、巴士多行程时间价格表Action
 * @author LIULIANG
 * @date 2015-05-13
 */
@Controller
@RequestMapping("/lineMultiTraffic/goods/timePrice")
@SuppressWarnings({"unused","deprecation"})
public class LineMultiTrafficSuppGoodsTimePriceAction extends BaseLineMultiAction{

	private static final long serialVersionUID = 2165895040446415243L;
	
	private static final Log log = LogFactory.getLog(LineMultiTrafficSuppGoodsTimePriceAction.class);
	
	/**
	 *  打开时间价格表页面
	 */
	@RequestMapping(value = "/showGoodsTimePrice")
	public String showGoodsTimePrice(Model model, SuppGoods suppGoods) {
		if (log.isDebugEnabled()) {
			log.debug("start method<showGoodsTimePrice>");
		}
		String viewName = "/goods/traffic/timePrice/showTrafficSuppGoodsTimePrice"; 
		model.addAttribute("apiFlag", suppGoods.getApiFlag());
		if("Y".equalsIgnoreCase(suppGoods.getApiFlag())){
			viewName = "/goods/traffic/timePrice/showGoodsFApiTimePrice";
		}
		
		return getSuppGoodsInfo(model, suppGoods, viewName);
	}
	
	/**
	 * 跳转到批量录入页面
	 */
	@RequestMapping(value = "/showBatchSaveTrafficTimePrice")
	public String showBatchSaveTrafficTimePrice(Model model, SuppGoods suppGoods) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<showBatchSaveTrafficTimePrice>");
		}
		String viewName = "/goods/traffic/timePrice/showBatchSaveTrafficTimePrice"; 
		return getSuppGoodsInfo(model, suppGoods, viewName);
	}
	
	/**
	 * 跳转到单个产品录入页面
	 */
	@RequestMapping(value = "/showSaveTrafficTimePrice")
	public String showSaveTrafficTimePrice(Model model, HttpServletRequest req,SuppGoods suppGoods) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<showSaveTrafficTimePrice>");
		}
		String viewName = "/goods/traffic/timePrice/showSaveTrafficTimePrice"; 
		model.addAttribute("spec_date", req.getParameter("spec_date"));
		return getSuppGoodsInfo(model, suppGoods, viewName);
	}	
	
	/**
	 * 跳转到批量修改销售价页面
	 */
	@RequestMapping(value = "/showBatchSavePrice")
	public String showBatchSavePrice(Model model, SuppGoods suppGoods) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<showBatchSavePrice>");
		}
		String viewName = "/goods/traffic/timePrice/showBatchSaveTrafficPrice"; 
		return getSuppGoodsInfo(model, suppGoods, viewName);
	}
	
	/**
	 * 跳转到批量修改结算价页面
	 */
	@RequestMapping(value = "/showBatchSaveSellmentPrice")
	public String showBatchSaveSellmentPrice(Model model, SuppGoods suppGoods) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<showBatchSaveSellmentPrice>");
		}
		String viewName = "/goods/traffic/timePrice/showBatchSaveTrafficSellmentPrice"; 
		return getSuppGoodsInfo(model, suppGoods, viewName);
	}
	
	/**
	 * 跳转到批量禁售页面
	 */
	@RequestMapping(value = "/showBatchSuppGoodsLockUp")
	public String showBatchSuppGoodsLockUp(Model model, SuppGoods suppGoods) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<showBatchSaveCancelStrategy>");
		}
		String viewName = "/goods/traffic/timePrice/showBatchSaveTrafficLockUp"; 
		return getSuppGoodsInfo(model, suppGoods, viewName);
	}
	
	/**
	 * 批量录入其它机票、火车票、巴士多行程时间价格表
	 */
	@RequestMapping(value = "/editGoodsTimePrice")
	@ResponseBody
	public Object editGoodsTimePrice(Model model, HttpServletRequest request,LineRouteDateVO lineRouteDateVO) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<saveGoodsTimePrice>");
		}
		if(null==lineRouteDateVO){
			return new ResultMessage("error", "参数错误");
		}
		String logStr ="";
		try {
			lineRouteDateVO.setIsSetAheadBookTime("Y");
			lineRouteDateVO.setIsSetPrice("Y");
			lineRouteDateVO.setIsSetStock("Y");
			logStr = getTimePriceChangeLog(lineRouteDateVO,lineRouteDateVO.getProductId(),false,true,true);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
            log.error(e.getMessage());
		}
		//更新时间价格
		try {
			lineRouteDateService.saveOrUpdateTrafficDate(lineRouteDateVO);
			//更新预售时间价格
			lineRouteDateService.saveOrUpdatePresalePrice(lineRouteDateVO,this.getLoginUser().getUserName());
		} catch (Exception e1) {
			return new ResultMessage("error", e1.getMessage());
		}
		
		//设置日志
		if(StringUtils.isNotBlank(logStr)){
		   try {
	            comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
	            	   lineRouteDateVO.getProductId(), lineRouteDateVO.getProductId(), 
	                   this.getLoginUser().getUserName(),
	                    "修改时间价格表:"+logStr, 
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
	 * 批量修改其它机票、火车票、巴士多行程结算价\销售价页面
	 */
	@RequestMapping(value = "/editTrafficPrice")
	@ResponseBody
	public Object editTrafficPrice(Model model, HttpServletRequest request,LineRouteDateVO lineRouteDateVO,Long prodProductId,Long categoryId){
		if (log.isDebugEnabled()) {
			log.debug("start method<editTrafficPrice>");
		}
		if(lineRouteDateVO==null){
			throw new BusinessException("价格设置失败");
		}
		StringBuffer logStr = new StringBuffer();
		try {
			lineRouteDateVO.setIsSetPrice("Y");
			updateLineMultiRoutePriceLog(logStr, lineRouteDateVO);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_TIME.name());
            log.error(e.getMessage());
		}
		// 修改其它机票、火车票、巴士结算价\销售价
		try {
			lineRouteDateService.updateBathTimePrice(lineRouteDateVO);
		} catch (BusinessException e) {
			return new ResultMessage("error",e.getMessage());
		}
		
		if(StringUtils.isNotBlank(logStr)){
		  try {
	            comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
	            		lineRouteDateVO.getProductId(), lineRouteDateVO.getProductId(), 
	                    this.getLoginUser().getUserName(),
	                    "修改时间价格表:"+logStr.toString(), 
	                    COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_TIME.name(), 
	                    "修改时间价格表",null);
	        } catch (Exception e) {
	            log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_TIME.name());
	            log.error(e.getMessage());
	        }
		}
		return ResultMessage.SET_SUCCESS_RESULT;
	}
	
	/**
	 * 修改其它机票、火车票、巴士多行程禁售规则
	 */
	@RequestMapping(value = "/editTrafficLockUp")
	@ResponseBody
	public Object editTrafficLockUp(Model model, HttpServletRequest request,LineRouteDateVO lineRouteDateVO,Long prodProductId,Long categoryId) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<editTrafficLockUp>");
		}
		if(lineRouteDateVO==null){
			throw new BusinessException("退改规则设置失败");
		}
		StringBuffer logStr = new StringBuffer();
		try {
			lineRouteDateVO.setIsSetPrice("Y");
			updateLineMultiRouteLockUpLog(logStr,lineRouteDateVO);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
            log.error(e.getMessage());
		}		
		try {
			lineRouteDateService.updateBathTimePrice(lineRouteDateVO);
			
			lineRouteDateService.updatePresalePriceIsBanSell(lineRouteDateVO,this.getLoginUser().getUserName());
        } catch (Exception e) {
            log.debug(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS.getCnName()+"操作异常！");
        }
		if(StringUtils.isNotBlank(logStr)){
			try{
	            comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
	            		lineRouteDateVO.getProductId(), lineRouteDateVO.getProductId(), 
	                   this.getLoginUser().getUserName(),
	                    "修改时间价格表:"+logStr.toString(), 
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
	 * @throws Exception 
	 */
	@RequestMapping(value = "/findGoodsTimePriceList")
	@ResponseBody
	public Object findGoodsTimePriceList(Model model, Integer page, SuppGoodsLineTimePrice  suppGoodsLineTimePrice, HttpServletRequest req) throws Exception {
		List<SuppGoodsLineTimePrice> list = new ArrayList<SuppGoodsLineTimePrice>();
		List<SuppGoodsLineTimePrice> dtos = new ArrayList<SuppGoodsLineTimePrice>();
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("suppGoodsId", suppGoodsLineTimePrice.getSuppGoodsId());
		parameters.put("suppilerId", suppGoodsLineTimePrice.getSupplierId());
		parameters.put("beginDate",CalendarUtils.getFirstDayOfMonth(suppGoodsLineTimePrice.getSpecDate()));
		parameters.put("endDate", CalendarUtils.getLastDayOfMonth(suppGoodsLineTimePrice.getSpecDate()));
		String productId = req.getParameter("productId");
		if(StringUtil.isNumber(productId)){
			list = prodLineRouteService.findSuppGoodsTimePriceAndLineRoute(parameters, Long.valueOf(productId));
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
						}
					}
					dtos.add(dto);
				}   
				super.loadVstOrgAuthentication(LineMultiTrafficSuppGoodsTimePriceAction.class, VstBackOrgAuthentication.class, list);
			}
			for(int m=0;m<list.size();m++){
				SuppGoodsLineTimePrice p = list.get(m);
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
		return dtos;
	}
	
	/**
	 * 获取大交通对于的商品信息
	 * @param model
	 * @param suppGoods
	 * @param viewName 对应的视图路径
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	private String getSuppGoodsInfo(Model model,SuppGoods suppGoods,String viewName){
		if(null==suppGoods){
			return "";
		}
		// 查询供应商
		if(suppGoods.getSuppSupplier()!=null){
			suppGoods.setSuppSupplier( (SuppSupplier) MiscUtils.autoUnboxing(suppSupplierService.findSuppSupplierById(suppGoods.getSuppSupplier().getSupplierId())));
		}
		
		Map<String, Object> params = new HashMap<String, Object>();
		if (suppGoods.getProdProduct() != null && suppGoods.getSuppSupplier() != null) {
			// 查询产品
			ProdProduct product = prodProductService.findProdProduct4FrontById(suppGoods.getProdProduct().getProductId(), false, false);
			model.addAttribute("prodProduct", product);
			// 查询商品
			params.put("productId", suppGoods.getProdProduct().getProductId());
			if(suppGoods.getSuppSupplier().getSupplierId()!=null){
				params.put("supplierId", suppGoods.getSuppSupplier().getSupplierId());
			}
			params.put("branchId", suppGoods.getProdProductBranch().getBizBranch().getBranchId());
			List<SuppGoods> goodsList = new ArrayList<SuppGoods>();
			Long suppGoodsId = suppGoods.getSuppGoodsId();
			if(null!=suppGoodsId && suppGoodsId.intValue()>0){
				SuppGoods suoppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoodsId));
				if(null!=suppGoods){
					ProdProductBranch prodProductBranch = prodProductBranchService.findProdProductBranchById(suoppGoods.getProductBranchId());
					suoppGoods.setProdProductBranch(prodProductBranch);
					goodsList.add(suoppGoods);
				}
			}else{
				goodsList = suppGoodsService.findSuppGoodsListByBranch(params);
			}
			model.addAttribute("goodsList", goodsList);
			//查询商品信息，是否存在 大于当前时间的 时间价格数据
			Date newDate = new Date();
			Map<String,String> hasTimePriceMap = new HashMap<String,String>();
			for (SuppGoods suppGoods2 : goodsList) {
				if("Y".equalsIgnoreCase(suppGoods.getApiFlag())){ //对接商品
					SuppGoodsFApiTimePrice suppGoodsFApiTimePrice = suppGoodsFApiTimePriceService.getOneSaleAbleTimePrice(suppGoods2.getSuppGoodsId(),newDate);
					if( suppGoodsFApiTimePrice != null){
						hasTimePriceMap.put(String.valueOf(suppGoods2.getSuppGoodsId()), "red");
					}
				}else{ //非对接商品
					SuppGoodsLineTimePrice oldSuppGoodsLineTimePrice = suppGoodsLineTimePriceService.getOneSaleAbleTimePrice(suppGoods2.getSuppGoodsId(),newDate);
					if( oldSuppGoodsLineTimePrice != null){
						hasTimePriceMap.put(String.valueOf(suppGoods2.getSuppGoodsId()), "red");
					}
				}
			}
			model.addAttribute("hasTimePriceMap", hasTimePriceMap);
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
		if(suppGoods != null && suppGoods.getBizCategory()!=null){
			Map<String, Object> parBizBranch = new HashMap<String, Object>();
			parBizBranch.put("categoryId", suppGoods.getBizCategory().getCategoryId());
			parBizBranch.put("cancelFlag", "Y");
			parBizBranch.put("_orderby", "ATTACH_FLAG desc, BRANCH_ID desc");
			if(25==suppGoods.getBizCategory().getCategoryId()){
				parBizBranch.put("branchId", suppGoods.getProdProductBranch().getBizBranch().getBranchId());
			}
			bizBranchList =  MiscUtils.autoUnboxing(branchService.findBranchListByParams(parBizBranch));
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
					List<SuppGoods> suppGoodsList =  MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsList(parSuppGoods));
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
				Map<String, Object> params1 = new HashMap<String, Object>();
				params1.put("userIds", manageIds.toArray());
				params1.put("maxResults", 100);
				params1.put("skipResults", 0);
				
				List<PermUser> permUserList = permUserServiceAdapter.queryPermUserByParam(params1);
				for (PermUser permUser : permUserList) {
					for (SuppGoods suppGoods1 : suppGoodsListArray) {
						if (suppGoods1.getManagerId()!=null&&suppGoods1.getManagerId().equals(permUser.getUserId())) {
							suppGoods1.setManagerName(permUser.getRealName());
						}
					}
				}	
				//设置内容维护人员
				params1.put("userIds", contentManagerIds.toArray());
				List<PermUser> contentManagerList = permUserServiceAdapter.queryPermUserByParam(params1);
				for (PermUser permUser : contentManagerList) {
					for (SuppGoods suppGoods1 : suppGoodsListArray) {
						if (suppGoods1 !=null&&suppGoods1.getContentManagerId()!=null&&suppGoods1.getContentManagerId().equals(permUser.getUserId())) {
							suppGoods1.setContentManagerName(permUser.getRealName());
						}
					}
				}
			}
			branchIdMap.put(pairs.getKey(), suppGoodsListArray);
			model.addAttribute("suppGoodsMap", branchIdMap);
		}
		
		if (suppGoods.getBizCategory() != null) {
			//查询品类
			BizCategory category  = bizCategoryQueryService.getCategoryById(suppGoods.getBizCategory().getCategoryId());
			if(null!=category){
				model.addAttribute("bizCategory", category);
			}
		}
		
		model.addAttribute("suppGoods", suppGoods);
		return viewName;
	}
}
