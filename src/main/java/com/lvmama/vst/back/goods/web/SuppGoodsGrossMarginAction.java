package com.lvmama.vst.back.goods.web;

import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.vst.back.biz.po.Attribution;
import com.lvmama.vst.back.biz.po.BizBuEnum;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.client.biz.service.AttributionClientService;
import com.lvmama.vst.back.client.biz.service.BizBuEnumClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsHotelAdapterClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.goods.po.*;
import com.lvmama.vst.back.goods.service.*;
import com.lvmama.vst.back.goods.vo.SuppGoodsParam;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.pub.po.ComLog;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.enumeration.CommEnumSet;
import com.lvmama.vst.comm.utils.CalendarUtils;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.DateUtil;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.web.HttpServletLocalThread;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

import java.text.DecimalFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

/**
 * 毛利率管理
 * 
 * @author qiujiehong
 * @date 2013-10-11
 */
@Controller
@RequestMapping("/goods/grossMargin")
public class SuppGoodsGrossMarginAction extends BaseActionSupport {
	/**
	 *
	 */
	private static final long serialVersionUID = 5576904778178181774L;

	private static final Log LOG = LogFactory.getLog(SuppGoodsGrossMarginAction.class);

	@Autowired
	private SuppGoodsGrossMarginService suppGoodsGrossMarginService;
	@Autowired
	private GrossMarginDistrictService  grossMarginDistrictService;
	@Autowired
	private GrossMarginReceiverService grossMarginReceiverService;
	@Autowired
	private AttributionClientService attributionService;
	@Autowired
	private PermUserServiceAdapter permUserServiceAdapter;
	@Autowired
	private ComLogClientService comLogService;
	@Autowired
	private BizCategoryQueryService categoryQueryService;
	@Autowired
	private ProdProductClientService prodProductService;
	@Autowired
	private SuppGoodsClientService suppGoodsService;
	@Autowired
	private SuppGoodsGrossMarginLogsService suppGoodsGrossMarginLogsService;
	@Autowired
	private BizBuEnumClientService bizBuEnumClientService;
	@Autowired
	private SuppGoodsHotelAdapterClientService suppGoodsHotelAdapterService;


	/**
	 * 跳转到低毛利规则列表
	 * @param req
	 * @param page
	 * @param attributeName
	 * @param bu
	 * @param categoryId
	 * @param creatorId
	 * @param filiale
	 * @param operator
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/showSuppGoodsGrossMarginList")
	public Object showSuppGoodsGrossMarginList(HttpServletRequest req,Integer page,String attributeName,String bu,Long categoryId,Long creatorId,String filiale,String operator) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showSuppGoodsGrossMarginList>");
		}
		HashMap<String,Object> params = new HashMap<String,Object>();
		params.put("attributeName",attributeName);
		params.put("bu",bu);
		if(categoryId!=null)
		params.put("categoryId",","+categoryId+",");
		params.put("creatorId",creatorId);
		params.put("filiale",filiale);
		params.put("creatorId",creatorId);

		Long  count = suppGoodsGrossMarginService.findGoodsGrossMarginCount(params);

		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		params.put("_start", pageParam.getStartRows());
		params.put("_end", pageParam.getEndRows());
		params.put("_orderby", "create_time desc");


		List<SuppGoodsGrossMargin> grossMarginList = suppGoodsGrossMarginService.selectListByParams(params);

		if(grossMarginList!=null && grossMarginList.size()>0){
			params.clear();
			for(SuppGoodsGrossMargin suppGoodsGrossMargin : grossMarginList){
				String cnName = null;
				ResultHandleT<BizBuEnum> resultHandleT = bizBuEnumClientService.getBizBuEnumByBuCode(suppGoodsGrossMargin.getBu());
				if(resultHandleT.isSuccess()){
					cnName = resultHandleT.getReturnContent().getCnName();
				}
				params.put("suppGoodsGrossMarginId", suppGoodsGrossMargin.getSuppGoodsGrossMarginId());
//				suppGoodsGrossMargin.setGrossMarginDistrictList(getDistrict(params));
				suppGoodsGrossMargin.setBu(cnName);
				suppGoodsGrossMargin.setFiliale(CommEnumSet.FILIALE_NAME.getCnName(suppGoodsGrossMargin.getFiliale()));
				if(suppGoodsGrossMargin.getCreator()==null)
					continue;
				PermUser user =  permUserServiceAdapter.getPermUserByUserId(suppGoodsGrossMargin.getCreator());
				if(user!=null)
					suppGoodsGrossMargin.setCreatorName(user.getRealName());
			}
		}
		pageParam.setItems(grossMarginList);
		HttpServletLocalThread.getModel().addAttribute("filialeList", CommEnumSet.FILIALE_NAME.values());
		// BU
		HttpServletLocalThread.getModel().addAttribute("buList", CommEnumSet.BU_NAME.values());
		HttpServletLocalThread.getModel().addAttribute("attributeName",attributeName);
		HttpServletLocalThread.getModel().addAttribute("bu",bu);
		HttpServletLocalThread.getModel().addAttribute("pageParam",pageParam);
		HttpServletLocalThread.getModel().addAttribute("categoryId",categoryId);
		HttpServletLocalThread.getModel().addAttribute("creatorId",creatorId);
		HttpServletLocalThread.getModel().addAttribute("filiale",filiale);
		HttpServletLocalThread.getModel().addAttribute("operator",operator);
		return "/goods/grossMargin/findSuppGoodsGrossMarginList";
	}

	/**
	 * 展示已经推送的低毛利产品
	 * @param req
	 * @param page
	 * @param attributeName
	 * @param bu
	 * @param productName
	 * @param goodsId
	 * @param goodsName
	 * @param productId
	 * @param creatorId
	 * @param filiale
	 * @param operator
	 * @param startDate
	 * @param endDate
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/showSuppGoodsGrossMarginProdLogsList")
	 public Object showSuppGoodsGrossMarginProdLogsList(HttpServletRequest req,Integer page,String attributeName,String bu,String productName,Long goodsId,String goodsName,Long productId,
														Long creatorId,String filiale,String operator,Date startDate,Date endDate) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showSuppGoodsGrossMarginProdLogsList>");
		}
		HashMap<String,Object> params = new HashMap<String,Object>();
		params.put("productId",productId);
		params.put("productName",productName);
		params.put("goodsId",goodsId);
		params.put("goodsName",goodsName);
		params.put("bu",bu);
		params.put("filiale",filiale);
		params.put("startDate",DateUtil.changeDayEnd(startDate,0,0,0));
		params.put("endDate",DateUtil.changeDayEnd(endDate,23,59,59));
		params.put("creatorId",creatorId);


		Long  count = suppGoodsGrossMarginLogsService.selectListAsProductCount(params);

		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		params.put("_start", pageParam.getStartRows());
		params.put("_end", pageParam.getEndRows());


		List<ProdProduct>  productsList = suppGoodsGrossMarginLogsService.selectListAsProductListParams(params);
		if(productsList!=null && productsList.size()>0){
			for(ProdProduct pp : productsList){
				pp.setBizCategory(categoryQueryService.getCategoryById(pp.getBizCategoryId()));
			}
		}


		pageParam.setItems(productsList);
		HttpServletLocalThread.getModel().addAttribute("filialeList", CommEnumSet.FILIALE_NAME.values());
		HttpServletLocalThread.getModel().addAttribute("auditTypeList", ProdProduct.AUDITTYPE.values());
		// BU
		HttpServletLocalThread.getModel().addAttribute("buList", CommEnumSet.BU_NAME.values());
		HttpServletLocalThread.getModel().addAttribute("attributeName",attributeName);
		HttpServletLocalThread.getModel().addAttribute("bu",bu);
		HttpServletLocalThread.getModel().addAttribute("pageParam",pageParam);
		HttpServletLocalThread.getModel().addAttribute("productId",productId);
		HttpServletLocalThread.getModel().addAttribute("productName",productName);
		HttpServletLocalThread.getModel().addAttribute("goodsId",goodsId);
		HttpServletLocalThread.getModel().addAttribute("goodsName",goodsName);
		if(startDate!=null)
			HttpServletLocalThread.getModel().addAttribute("startDate", DateUtil.formatSimpleDate(startDate));
		if(endDate!=null)
			HttpServletLocalThread.getModel().addAttribute("endDate",DateUtil.formatSimpleDate(endDate));
		HttpServletLocalThread.getModel().addAttribute("creatorId",creatorId);
		HttpServletLocalThread.getModel().addAttribute("filiale",filiale);
		HttpServletLocalThread.getModel().addAttribute("operator",operator);
		return "/goods/grossMargin/findSuppGoodsGrossMarginProdLogsList";
	}


	/**
	 * 展示已经推送的商品列表
	 * @param req
	 * @param page
	 * @param productId
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/showSuppGoodsGrossMarginGoodsLogsList")
	public Object showSuppGoodsGrossMarginGoodsLogsList(HttpServletRequest req,Integer page,Long productId) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showSuppGoodsGrossMarginGoodsLogsList>");
		}
		HashMap<String,Object> params = new HashMap<String, Object>();
		params.put("productId",productId);
		Long  count = suppGoodsGrossMarginLogsService.findGoodsGrossMarginLogCountByProductId(params);

		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		params.put("_start", pageParam.getStartRows());
		params.put("_end", pageParam.getEndRows());



		List<SuppGoodsGrossMarginLog> goodsGrossMarginLogList = suppGoodsGrossMarginLogsService.findGoodsGrossMarginLogByProductId(params);
		if(goodsGrossMarginLogList!=null && goodsGrossMarginLogList.size()>0){
			for(SuppGoodsGrossMarginLog marginLog : goodsGrossMarginLogList){
				SuppGoods goods = MiscUtils.autoUnboxing( suppGoodsService.findSuppGoodsById(marginLog.getSuppGoodsId(), new SuppGoodsParam()) );
				goods.setBu(CommEnumSet.BU_NAME.getCnName(goods.getBu()));
				goods.setFiliale(CommEnumSet.FILIALE_NAME.getCnName(goods.getFiliale()));
				marginLog.setSuppGoods(goods);
				//处理
				if(marginLog.getGrossMargin()!=null && !"".equals(marginLog.getGrossMargin())){
					if(marginLog.getGrossMargin().contains("%")){
						String str = marginLog.getGrossMargin().substring(0, marginLog.getGrossMargin().indexOf('%'));
						marginLog.setGrossMarginLong(Long.parseLong(str));
						marginLog.setGrossMarginUnit("%");
					}else {
						marginLog.setGrossMarginLong(Long.parseLong(marginLog.getGrossMargin()));
					}
				}

				if(marginLog.getGrossMarginPoint()!=null && !"".equals(marginLog.getGrossMarginPoint())){
					if(marginLog.getGrossMarginPoint().contains("%")){
						String str = marginLog.getGrossMarginPoint().substring(0, marginLog.getGrossMarginPoint().indexOf('%'));
						marginLog.setGrossMarginPointLong(Long.parseLong(str));
						marginLog.setGrossMarginPointUnit("%");
					}else {
						marginLog.setGrossMarginPointLong(Long.parseLong(marginLog.getGrossMarginPoint()));
					}
				}
			}
		}
		pageParam.setItems(goodsGrossMarginLogList);
		HttpServletLocalThread.getModel().addAttribute("pageParam",pageParam);

		HttpServletLocalThread.getModel().addAttribute("goodsGrossMarginLogList", goodsGrossMarginLogList);
		return "/goods/grossMargin/findSuppGoodsGrossMarginGoodsLogsList";
	}


	//
	private boolean checkConstrict(SuppGoodsGrossMargin suppGoodsGrossMargin){
		return false;
	}

	/**
	 * 跳转到添加低毛利率规则
	 * @param req
	 * @param model
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/showAddSuppGoodsGrossMargin")
	public Object showAddSuppGoodsGrossMargin(HttpServletRequest req,Model model) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showAddSuppGoodsGrossMargin>");
		}
		// 分公司
		model.addAttribute("filialeList", CommEnumSet.FILIALE_NAME.values());
		// BU
		model.addAttribute("buList", CommEnumSet.BU_NAME.values());

		return "/goods/grossMargin/showAddSuppGoodsGrossMargin";
	}

	/**
	 * 删除低毛利规则
	 * @param req
	 * @param model
	 * @param id
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/deleteSuppGoodsGrossMargin")
	@ResponseBody
	public Object deleteSuppGoodsGrossMargin(HttpServletRequest req,Model model,Long id) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showAddSuppGoodsGrossMargin>");
		}
		suppGoodsGrossMarginService.deleteByPrimaryKey(id);
		HashMap<String,Object> params = new HashMap<String, Object>();
		params.put("suppGoodsGrossMarginId",id);
		List<GrossMarginReceiver> grossMarginReceiverList = grossMarginReceiverService.selectListByParams(params);
		for(GrossMarginReceiver receiver : grossMarginReceiverList){
			grossMarginReceiverService.deleteByPrimaryKey(receiver.getGrossMarginReceriverId());
		}
		comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.GROSS_MARGIN_GOODS,
				id, id,
				this.getLoginUser() == null ? "" : this.getLoginUser().getUserName(),
				"删除毛利率："+id,
				ComLog.COM_LOG_LOG_TYPE.GROSS_MARGIN_GOODS_ADD.name(),
				"删除毛利率",null);
		return ResultMessage.DELETE_SUCCESS_RESULT;
	}


	private List<GrossMarginDistrict>  getDistrict(HashMap<String,Object> params){
		List<GrossMarginDistrict> list = grossMarginDistrictService.selectListByParams(params);
		if(list==null || list.size() == 0){
			return null;
		}
		for(GrossMarginDistrict grossMarginDistrict : list){
			Attribution attribution =  attributionService.findAttributionById(grossMarginDistrict.getDistrictId());
			if(attribution==null)
				continue;
			grossMarginDistrict.setDistrictName(attribution.getAttributionName());
		}
		return list;
	}

	private List<GrossMarginDistrict>  getReceiver(HashMap<String,Object> params){
		List<GrossMarginDistrict> list = grossMarginDistrictService.selectListByParams(params);
		if(list==null || list.size() == 0){
			return null;
		}
		for(GrossMarginDistrict grossMarginDistrict : list){
			Attribution attribution =  attributionService.findAttributionById(grossMarginDistrict.getDistrictId());
			if(attribution==null)
				continue;
			grossMarginDistrict.setDistrictName(attribution.getAttributionName());
		}
		return list;
	}

	/**
	 * 时间价格表弹出低毛利原因页面
	 * @return
	 */
	@RequestMapping(value = "/showAddLowPrice")
	public String showAddLowPrice(){
		return "/goods/grossMargin/addGoodsGrossMarginLog";
	}

	/**
	 * 计算酒店 是否低毛利率
	 * @param suppGoodsTimePrice
	 * @return
	 */
	@RequestMapping(value = "/getLowerGrossMargin_Hotel")
	@ResponseBody
	public Object calHotel(SuppGoodsTimePrice suppGoodsTimePrice){
		if(!"0".equals(suppGoodsTimePrice.getType()) || suppGoodsTimePrice.getSuppGoodsIdList()==null){
			return new ResultMessage("NO_LOWER","");
		}
		for(Long goodsId : suppGoodsTimePrice.getSuppGoodsIdList()){
			if(goodsId == null)
				continue;
			//获得商品
			SuppGoods goods = MiscUtils.autoUnboxing( suppGoodsHotelAdapterService.findSuppGoodsById(goodsId, new SuppGoodsParam()) );
			Assert.notNull(goods.getCategoryId());
			Assert.notNull(goods.getBu());
			Assert.notNull(goods.getFiliale());
			if("Y".equals(goods.getApiFlag()))
				continue;
			HashMap<String,Object> params = new HashMap<String, Object>();
			params.put("categoryId",","+goods.getCategoryId()+",");
			params.put("filiale",goods.getFiliale());
			params.put("bu",goods.getBu());
			List<SuppGoodsGrossMargin> goodsGrossMarginList =  suppGoodsGrossMarginService.selectListByParams(params);
			if(goodsGrossMarginList==null || goodsGrossMarginList.size() == 0)
				continue;
			SuppGoodsGrossMargin suppGoodsGrossMargin = goodsGrossMarginList.get(0);
			if(suppGoodsGrossMargin==null)
				continue;
			Long value = suppGoodsTimePrice.getPrice() - suppGoodsTimePrice.getSettlementPrice();
			//判断是按照什么形式
			if("FIXED".equals(suppGoodsGrossMargin.getGrossMarginType())){
				if(value < suppGoodsGrossMargin.getGrossMargin()){
					return new ResultMessage("WITH_LOWER",suppGoodsGrossMargin.getGrossMargin() + ":" + suppGoodsGrossMargin.getGrossMarginType());
				}
			}else {
				if((suppGoodsTimePrice.getPrice() - suppGoodsTimePrice.getSettlementPrice())*10000/suppGoodsTimePrice.getSettlementPrice() < suppGoodsGrossMargin.getGrossMargin()){
					return new ResultMessage("WITH_LOWER",suppGoodsGrossMargin.getGrossMargin() + ":" + suppGoodsGrossMargin.getGrossMarginType());
				}
			}
		}
		return new ResultMessage("NO_LOWER","");
	}

	/**
	 * 计算门票 是否低毛利率
	 * @param suppGoodsAddTimePrice
	 * @return
	 */
	@RequestMapping(value = "/getLowerGrossMargin_Ticket")
	@ResponseBody
	private Object calTicket(SuppGoodsAddTimePrice suppGoodsAddTimePrice){
			if(suppGoodsAddTimePrice==null)
				return new ResultMessage("NO_LOWER","");
			//获得商品
			SuppGoods goods = MiscUtils.autoUnboxing( suppGoodsService.findSuppGoodsById(suppGoodsAddTimePrice.getSuppGoodsId()) );
			Assert.notNull(goods.getCategoryId());
			Assert.notNull(goods.getBu());
			Assert.notNull(goods.getFiliale());
			if("Y".equals(goods.getApiFlag()))
				return new ResultMessage("NO_LOWER","");
			HashMap<String,Object> params = new HashMap<String, Object>();
			params.put("categoryId",","+goods.getCategoryId()+",");
			params.put("filiale",goods.getFiliale());
			params.put("bu",goods.getBu());
			List<SuppGoodsGrossMargin> goodsGrossMarginList =  suppGoodsGrossMarginService.selectListByParams(params);
			if(goodsGrossMarginList==null || goodsGrossMarginList.size() == 0)
				return new ResultMessage("NO_LOWER","");
			SuppGoodsGrossMargin suppGoodsGrossMargin = goodsGrossMarginList.get(0);
			if(suppGoodsGrossMargin==null)
				return new ResultMessage("NO_LOWER","");
			Long value = suppGoodsAddTimePrice.getPrice() - suppGoodsAddTimePrice.getSettlementPrice();
			//判断是按照什么形式
			if("FIXED".equals(suppGoodsGrossMargin.getGrossMarginType())){
				if(value < suppGoodsGrossMargin.getGrossMargin()){
					return new ResultMessage("WITH_LOWER",suppGoodsGrossMargin.getGrossMargin() + ":" + suppGoodsGrossMargin.getGrossMarginType());
				}
			}else {
				if((suppGoodsAddTimePrice.getPrice() - suppGoodsAddTimePrice.getSettlementPrice())*10000/suppGoodsAddTimePrice.getSettlementPrice() < suppGoodsGrossMargin.getGrossMargin()){
					return new ResultMessage("WITH_LOWER",suppGoodsGrossMargin.getGrossMargin() + ":" + suppGoodsGrossMargin.getGrossMarginType());
				}
			}
		return new ResultMessage("NO_LOWER","");
	}


	/**
	 * 计算线路 是否低毛利率
	 * @param suppGoodsLineTimePriceList
	 * @return
	 */
	@RequestMapping(value = "/getLowerGrossMargin_Line")
	@ResponseBody
	private Object calLine(SuppGoodsGrossMarginLog suppGoodsGrossMarginLog){
		Assert.notNull(suppGoodsGrossMarginLog);
		Assert.notNull(suppGoodsGrossMarginLog.getTimePriceList());
		for(SuppGoodsLineTimePrice suppGoodsLineTimePrice : suppGoodsGrossMarginLog.getTimePriceList()){
			//获得商品
			SuppGoods goods = MiscUtils.autoUnboxing( suppGoodsService.findSuppGoodsById(suppGoodsLineTimePrice.getSuppGoodsId()) );
			Assert.notNull(goods.getCategoryId());
			Assert.notNull(goods.getBu());
			Assert.notNull(goods.getFiliale());
			if("Y".equals(goods.getApiFlag()))
				continue;
			HashMap<String,Object> params = new HashMap<String, Object>();
			params.put("categoryId",","+goods.getCategoryId()+",");
			params.put("filiale",goods.getFiliale());
			params.put("bu",goods.getBu());
			List<SuppGoodsGrossMargin> goodsGrossMarginList =  suppGoodsGrossMarginService.selectListByParams(params);
			if(goodsGrossMarginList==null || goodsGrossMarginList.size() == 0)
				return new ResultMessage("NO_LOWER","");
			SuppGoodsGrossMargin suppGoodsGrossMargin = goodsGrossMarginList.get(0);
			if(suppGoodsGrossMargin==null)
				return new ResultMessage("NO_LOWER","");
			if(suppGoodsLineTimePrice.getAuditPrice() == null || suppGoodsLineTimePrice.getAuditSettlementPrice() == null){
				continue;
			}
			Long value = suppGoodsLineTimePrice.getAuditPrice() - suppGoodsLineTimePrice.getAuditSettlementPrice();

			//判断是按照什么形式
			if("FIXED".equals(suppGoodsGrossMargin.getGrossMarginType())){
				if(value < suppGoodsGrossMargin.getGrossMargin()){
					return new ResultMessage("WITH_LOWER",suppGoodsGrossMargin.getGrossMargin() + ":" + suppGoodsGrossMargin.getGrossMarginType());
				}
			}else {
				if((suppGoodsLineTimePrice.getAuditPrice() - suppGoodsLineTimePrice.getAuditSettlementPrice())*10000/suppGoodsLineTimePrice.getAuditSettlementPrice() < suppGoodsGrossMargin.getGrossMargin()){
					return new ResultMessage("WITH_LOWER",suppGoodsGrossMargin.getGrossMargin() + ":" + suppGoodsGrossMargin.getGrossMarginType());
				}
			}
		}

		return new ResultMessage("NO_LOWER","");
	}


	/**
	 * 时间价格表输入低毛利原因之后进行相关数据入库
	 * @param suppGoodsGrossMarginLog
	 * @return
	 */
	@RequestMapping(value = "/saveGrossMarginLogs")
	@ResponseBody
	public Object saveGrossMarginLogs(SuppGoodsGrossMarginLog suppGoodsGrossMarginLog){
		try{
			if(suppGoodsGrossMarginLog==null)
				return ResultMessage.SUCCESS;
			//判断是不是线路,线路
			if(suppGoodsGrossMarginLog.getNfadd_date()!=null){
				if(suppGoodsGrossMarginLog.getTimePriceList()!=null && suppGoodsGrossMarginLog.getTimePriceList().size()>0){
					SuppGoodsLineTimePrice suppGoodsLineTimePrice = suppGoodsGrossMarginLog.getTimePriceList().get(0);
					List<Date> dateList = null;
					if("selectDate".equals(suppGoodsGrossMarginLog.getNfadd_date())){
						dateList = suppGoodsGrossMarginLog.getSelectDates();
					}else {
						dateList = CalendarUtils.getDates(suppGoodsGrossMarginLog.getStartDate(),suppGoodsGrossMarginLog.getEndDate(),suppGoodsGrossMarginLog.getWeekDay());
					}
					if(dateList==null)
						return ResultMessage.SUCCESS;
					for(Date date  : dateList){
						suppGoodsGrossMarginLog.setSuppGoodsId(suppGoodsLineTimePrice.getSuppGoodsId());
						suppGoodsGrossMarginLog.setSpecDate(date);
						suppGoodsGrossMarginLog.setCreateDate(new Date());

						SuppGoods goods =  MiscUtils.autoUnboxing( suppGoodsService.findSuppGoodsById(suppGoodsLineTimePrice.getSuppGoodsId()) );
						if(goods == null)
							continue;
						HashMap<String,Object> params = new HashMap<String, Object>();
						params.put("categoryId",","+goods.getCategoryId()+",");
						params.put("filiale",goods.getFiliale());
						params.put("bu",goods.getBu());
						List<SuppGoodsGrossMargin> goodsGrossMarginList =  suppGoodsGrossMarginService.selectListByParams(params);
						if(goodsGrossMarginList==null || goodsGrossMarginList.size() == 0)
							continue;
						SuppGoodsGrossMargin suppGoodsGrossMargin = goodsGrossMarginList.get(0);
						if(suppGoodsGrossMargin==null)
							continue;
						suppGoodsGrossMarginLog.setGrossMargin(suppGoodsGrossMargin.getGrossMargin()+""+("FIXED".equals(suppGoodsGrossMargin.getGrossMarginType()) ? "" : "%"));
						Long value = suppGoodsLineTimePrice.getAuditPrice() - suppGoodsLineTimePrice.getAuditSettlementPrice();
						//判断是按照什么形式
						if("FIXED".equals(suppGoodsGrossMargin.getGrossMarginType())){
							suppGoodsGrossMarginLog.setGrossMarginPoint(value + "");
						}else {
							if((value)*10000/suppGoodsLineTimePrice.getAuditSettlementPrice() < suppGoodsGrossMargin.getGrossMargin()){
								suppGoodsGrossMarginLog.setGrossMarginPoint(((value)*10000/suppGoodsLineTimePrice.getAuditSettlementPrice()) + "%");
							}
						}

						suppGoodsGrossMarginLog.setCreator(this.getLoginUser() == null ? null :this.getLoginUser().getUserId());
						suppGoodsGrossMarginLog.setCreatorName(this.getLoginUser() == null ? "" : this.getLoginUser().getUserName());
						suppGoodsGrossMarginLog.setPrice(suppGoodsLineTimePrice.getAuditPrice());
						suppGoodsGrossMarginLog.setSettlementPrice(suppGoodsLineTimePrice.getAuditSettlementPrice());
						suppGoodsGrossMarginLogsService.insert(suppGoodsGrossMarginLog);
					}
				}
			}else {
				//获得商品
				List<Date> dates = CalendarUtils.getDates(suppGoodsGrossMarginLog.getStartDate(),suppGoodsGrossMarginLog.getEndDate(),suppGoodsGrossMarginLog.getWeekDay());
				for(Date date : dates){
					for(Long goodsId : suppGoodsGrossMarginLog.getSuppGoodsIdList()){
						suppGoodsGrossMarginLog.setSuppGoodsId(goodsId);
						suppGoodsGrossMarginLog.setSpecDate(date);
						suppGoodsGrossMarginLog.setCreateDate(new Date());

						SuppGoods goods =  MiscUtils.autoUnboxing( suppGoodsHotelAdapterService.findSuppGoodsById( goodsId, new SuppGoodsParam()) );
						if(goods == null)
							continue;
						HashMap<String,Object> params = new HashMap<String, Object>();
						params.put("categoryId",","+goods.getCategoryId()+",");
						params.put("filiale",goods.getFiliale());
						params.put("bu",goods.getBu());
						List<SuppGoodsGrossMargin> goodsGrossMarginList =  suppGoodsGrossMarginService.selectListByParams(params);
						if(goodsGrossMarginList==null || goodsGrossMarginList.size() == 0)
							continue;
						SuppGoodsGrossMargin suppGoodsGrossMargin = goodsGrossMarginList.get(0);
						if(suppGoodsGrossMargin==null)
							continue;
						suppGoodsGrossMarginLog.setGrossMargin(suppGoodsGrossMargin.getGrossMargin()+""+("FIXED".equals(suppGoodsGrossMargin.getGrossMarginType()) ? "" : "%"));
						Long value = suppGoodsGrossMarginLog.getPrice() - suppGoodsGrossMarginLog.getSettlementPrice();
						//判断是按照什么形式
						if("FIXED".equals(suppGoodsGrossMargin.getGrossMarginType())){
							suppGoodsGrossMarginLog.setGrossMarginPoint(value+ "");
						}else {
							if((value)*10000/suppGoodsGrossMarginLog.getSettlementPrice() < suppGoodsGrossMargin.getGrossMargin()){
								suppGoodsGrossMarginLog.setGrossMarginPoint(((value)*10000/suppGoodsGrossMarginLog.getSettlementPrice()) + "%");
							}else{
								continue;
							}
						}
						suppGoodsGrossMarginLog.setCreator(this.getLoginUser() == null ? null :this.getLoginUser().getUserId());
						suppGoodsGrossMarginLog.setCreatorName(this.getLoginUser() == null ? "" : this.getLoginUser().getUserName());
						suppGoodsGrossMarginLogsService.insert(suppGoodsGrossMarginLog);
					}
				}
			}
		}catch(Exception e){
			LOG.error(ExceptionFormatUtil.getTrace(e));
		}
		return ResultMessage.SUCCESS;
	}

	/**
	 * 添加低毛利规则
	 * @param req
	 * @param suppGoodsGrossMargin
	 * @return
	 * @throws BusinessException
	 */

	@RequestMapping(value = "/addSuppGoodsGrossMargin")
	@ResponseBody
	public Object addSuppGoodsGrossMargin(HttpServletRequest req,SuppGoodsGrossMargin suppGoodsGrossMargin) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<addSuppGoodsGrossMargin>");
		}
		try {
			Assert.notNull(suppGoodsGrossMargin);
			Assert.notNull(suppGoodsGrossMargin.getCategoryIds());
			Assert.notNull(suppGoodsGrossMargin.getGrossMarginReceiverList());
			Assert.notNull(suppGoodsGrossMargin.getGrossMarginType());
			Assert.notNull(suppGoodsGrossMargin.getGrossMargin());
			if(checkExists(suppGoodsGrossMargin))
				return ResultMessage.GROSS_EXITE_RESULT;
			String categoryIds = "";
			for(String ids : suppGoodsGrossMargin.getCategoryIds()){

				categoryIds = ids + "," + categoryIds;
			}
			suppGoodsGrossMargin.setCategoryId(","+categoryIds);
			suppGoodsGrossMargin.setCreateDate(new Date());
			if(this.getLoginUser()!=null)
			suppGoodsGrossMargin.setCreator(this.getLoginUser().getUserId());
			//保存毛利率
			suppGoodsGrossMarginService.insert(suppGoodsGrossMargin);
			//保存接收人
			for(GrossMarginReceiver grossMarginReceiver : suppGoodsGrossMargin.getGrossMarginReceiverList()){
				if(grossMarginReceiver.getUserId()==null)
					continue;
				grossMarginReceiver.setSuppGoodsGrossMarginId(suppGoodsGrossMargin.getSuppGoodsGrossMarginId());
				grossMarginReceiverService.insert(grossMarginReceiver);
			}
			String logContent = getAddLog(suppGoodsGrossMargin);

			comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.GROSS_MARGIN_GOODS,
					suppGoodsGrossMargin.getSuppGoodsGrossMarginId(), suppGoodsGrossMargin.getSuppGoodsGrossMarginId(),
					this.getLoginUser() == null ? "" : this.getLoginUser().getUserName(),
					"新增毛利率："+logContent,
					ComLog.COM_LOG_LOG_TYPE.GROSS_MARGIN_GOODS_ADD.name(),
					"新增毛利率",null);
		}catch(Exception e){
			LOG.error(ExceptionFormatUtil.getTrace(e));
			return ResultMessage.ADD_FAIL_RESULT;
		}

		return ResultMessage.ADD_SUCCESS_RESULT;
	}

	private String  getAddLog(SuppGoodsGrossMargin suppGoodsGrossMargin){
		String cnName = null;
		ResultHandleT<BizBuEnum> resultHandleT = bizBuEnumClientService.getBizBuEnumByBuCode(suppGoodsGrossMargin.getBu());
		if(resultHandleT.isSuccess()){
			cnName = resultHandleT.getReturnContent().getCnName();
		}
		String log = "";
		//获得品类
		log = log + "品类:[";
		for(String ids : suppGoodsGrossMargin.getCategoryIds()){
			if(ids==null)
				continue;
			BizCategory category = categoryQueryService.getCategoryById(Long.parseLong(ids));
			if(category==null)
				continue;
			log = log + category.getCategoryName() +",";
		}
		log = log + "]";
		//所属分公司
		log = log + " 所属分公司 : [" +CommEnumSet.FILIALE_NAME.getCnName(suppGoodsGrossMargin.getFiliale())+ "]";
		//所属BU
		log = log + " 所属BU : ["+cnName+"]";
		//毛利基准
		DecimalFormat df = new DecimalFormat("#.00");
		String a = "FIXED".equals(suppGoodsGrossMargin.getGrossMarginType()) ? "元" : "%";
		log = log + " 毛利基准:["+ (df.format(suppGoodsGrossMargin.getGrossMargin().floatValue() / 10000)) + a +"]";
		//接收人
		log = log + " 接收人 : [";
		for(GrossMarginReceiver grossMarginReceiver : suppGoodsGrossMargin.getGrossMarginReceiverList()){
			if(grossMarginReceiver.getUserId()==null)
				continue;
			PermUser user = permUserServiceAdapter.getPermUserByUserId(grossMarginReceiver.getUserId());
			if(user==null)
				continue;
			log = log + "," + user.getRealName();
		}
		log = log +"]";
		return log;
	}


	private String  getChangeLog(SuppGoodsGrossMargin suppGoodsGrossMargin,SuppGoodsGrossMargin  oldSuppGoodsGrossMargin,List<GrossMarginReceiver> oldGrossMarginReceiverList){
		String cnName = null;
		ResultHandleT<BizBuEnum> resultHandleT = bizBuEnumClientService.getBizBuEnumByBuCode(suppGoodsGrossMargin.getBu());
		if(resultHandleT.isSuccess()){
			cnName = resultHandleT.getReturnContent().getCnName();
		}
		String oldCnName = null;
		ResultHandleT<BizBuEnum> oldResultHandleT = bizBuEnumClientService.getBizBuEnumByBuCode(oldSuppGoodsGrossMargin.getBu());
		if(oldResultHandleT.isSuccess()){
			oldCnName = oldResultHandleT.getReturnContent().getCnName();
		}
		String log1 = "";
		String log1_old = "";
		//获得品类
		StringBuffer logStr = new StringBuffer("");
		log1 = log1 + "品类:[";
		for(String ids : suppGoodsGrossMargin.getCategoryIds()){
			if(ids==null)
				continue;
			BizCategory category = categoryQueryService.getCategoryById(Long.parseLong(ids));
			if(category==null)
				continue;
			log1 = log1 + category.getCategoryName() +",";
		}
		log1 = log1 + "]";
		String categoryIds = oldSuppGoodsGrossMargin.getCategoryId();
		String[] array = categoryIds.split(",");
		for(String id : array){
			if("".equals(id))
				continue;
			BizCategory category = categoryQueryService.getCategoryById(Long.parseLong(id));
			if(category==null)
				continue;
			log1_old = log1_old + category.getCategoryName() +",";
		}
		logStr.append(ComLogUtil.getLogTxt("品类", log1, log1_old));

		//所属分公司
		logStr.append(ComLogUtil.getLogTxt("所属分公司", CommEnumSet.FILIALE_NAME.getCnName(suppGoodsGrossMargin.getFiliale()), CommEnumSet.FILIALE_NAME.getCnName(oldSuppGoodsGrossMargin.getFiliale())));
		//所属BU
		logStr.append(ComLogUtil.getLogTxt("所属BU", cnName, oldCnName));
		//毛利基准
		DecimalFormat df = new DecimalFormat("#.00");
		String log2 = "FIXED".equals(suppGoodsGrossMargin.getGrossMarginType()) ? "元" : "%";
		String log2_old = "FIXED".equals(suppGoodsGrossMargin.getGrossMarginType()) ? "元" : "%";
		logStr.append(ComLogUtil.getLogTxt("毛利基准",df.format(suppGoodsGrossMargin.getGrossMargin().floatValue()/10000)+log2, df.format(oldSuppGoodsGrossMargin.getGrossMargin().floatValue()/10000)+log2_old));
		//接收人
		String log3 = "";
		String log3_old = "";
		for(GrossMarginReceiver grossMarginReceiver : suppGoodsGrossMargin.getGrossMarginReceiverList()){
			if(grossMarginReceiver.getUserId()==null)
				continue;
			PermUser user = permUserServiceAdapter.getPermUserByUserId(grossMarginReceiver.getUserId());
			if(user==null)
				continue;
			log3 = log3 + "," + user.getRealName();
		}

		for(GrossMarginReceiver grossMarginReceiver : oldGrossMarginReceiverList){
			if(grossMarginReceiver.getUserId()==null)
				continue;
			PermUser user = permUserServiceAdapter.getPermUserByUserId(grossMarginReceiver.getUserId());
			if(user==null)
				continue;
			log3_old = log3_old + "," + user.getRealName();
		}
		logStr.append(ComLogUtil.getLogTxt("接收人",log3, log3_old));
		return logStr.toString();
	}

	private boolean checkExists(SuppGoodsGrossMargin suppGoodsGrossMargin){
		HashMap<String,Object> params = new HashMap<String, Object>();
		for(String ids : suppGoodsGrossMargin.getCategoryIds()){
			params.clear();
			params.put("bu",suppGoodsGrossMargin.getBu());
			params.put("categoryId",","+ids+",");
			params.put("filiale",suppGoodsGrossMargin.getFiliale());
			params.put("suppGoodsGrossMarginId",suppGoodsGrossMargin.getSuppGoodsGrossMarginId());
			Long count = suppGoodsGrossMarginService.isExists(params);
			if(count > 0) {
				return true;
			}
		}
		return false;
	}

	/**
	 * 跳转到低毛利规则设置页面
	 * @param req
	 * @param suppGoodsGrossMargin
	 * @param model
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/showUpdateSuppGoodsGrossMargin")
	public Object showUpdateSuppGoodsGrossMargin(HttpServletRequest req,SuppGoodsGrossMargin suppGoodsGrossMargin,Model model) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showUpdateSuppGoodsGrossMargin>");
		}
		Assert.notNull(suppGoodsGrossMargin);
		Assert.notNull(suppGoodsGrossMargin.getSuppGoodsGrossMarginId());
		suppGoodsGrossMargin = suppGoodsGrossMarginService.selectByPrimaryKey(suppGoodsGrossMargin.getSuppGoodsGrossMarginId());
		HashMap<String,Object> params = new HashMap<String, Object>();
		params.put("suppGoodsGrossMarginId",suppGoodsGrossMargin.getSuppGoodsGrossMarginId());
		List<GrossMarginReceiver> grossMarginReceiverList = grossMarginReceiverService.selectListByParams(params);
		for(GrossMarginReceiver receiver : grossMarginReceiverList){
			PermUser user =  permUserServiceAdapter.getPermUserByUserId(receiver.getUserId());
			if(user!=null)
				receiver.setUserName(user.getRealName());
		}
		suppGoodsGrossMargin.setGrossMarginReceiverList(grossMarginReceiverList);
		model.addAttribute("suppGoodsGrossMargin",suppGoodsGrossMargin);
		model.addAttribute("filialeList", CommEnumSet.FILIALE_NAME.values());
		// BU
		model.addAttribute("buList", CommEnumSet.BU_NAME.values());
		return "/goods/grossMargin/showUpdateSuppGoodsGrossMargin";
	}

	/**
	 * 更新低毛利率规则
	 * @param req
	 * @param suppGoodsGrossMargin
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/updateSuppGoodsGrossMargin")
	@ResponseBody
	public Object updateSuppGoodsGrossMargin(HttpServletRequest req,SuppGoodsGrossMargin suppGoodsGrossMargin) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<updateSuppGoodsGrossMargin>");
		}
		try{
			Assert.notNull(suppGoodsGrossMargin);
			Assert.notNull(suppGoodsGrossMargin.getSuppGoodsGrossMarginId());
			Assert.notNull(suppGoodsGrossMargin.getCategoryIds());
			Assert.notNull(suppGoodsGrossMargin.getGrossMarginReceiverList());
			Assert.notNull(suppGoodsGrossMargin.getGrossMarginType());
			Assert.notNull(suppGoodsGrossMargin.getGrossMargin());
			if(checkExists(suppGoodsGrossMargin))
				return ResultMessage.GROSS_EXITE_RESULT;
			String categoryIds = "";
			for(String ids : suppGoodsGrossMargin.getCategoryIds()){
				categoryIds = ids + "," + categoryIds;
			}
			suppGoodsGrossMargin.setCategoryId(","+categoryIds);
			SuppGoodsGrossMargin  oldSuppGoodsGrossMargin = suppGoodsGrossMarginService.selectByPrimaryKey(suppGoodsGrossMargin.getSuppGoodsGrossMarginId());
			HashMap<String,Object> params = new HashMap<String, Object>();
			params.put("suppGoodsGrossMarginId",suppGoodsGrossMargin.getSuppGoodsGrossMarginId());
			List<GrossMarginReceiver> oldGrossMarginReceiverList = grossMarginReceiverService.selectListByParams(params);
			int res = suppGoodsGrossMarginService.updateByPrimaryKey(suppGoodsGrossMargin);
			if(res==1){
				//删除原有
				grossMarginReceiverService.deleteByGrossMarginId(suppGoodsGrossMargin.getSuppGoodsGrossMarginId());
				//保存接收人
				for(GrossMarginReceiver grossMarginReceiver : suppGoodsGrossMargin.getGrossMarginReceiverList()){
					if(grossMarginReceiver.getUserId()==null)
						continue;
					grossMarginReceiver.setSuppGoodsGrossMarginId(suppGoodsGrossMargin.getSuppGoodsGrossMarginId());
					grossMarginReceiverService.insert(grossMarginReceiver);
				}
			}
			String logContent = getChangeLog(suppGoodsGrossMargin, oldSuppGoodsGrossMargin,oldGrossMarginReceiverList);

			comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.GROSS_MARGIN_GOODS,
					suppGoodsGrossMargin.getSuppGoodsGrossMarginId(), suppGoodsGrossMargin.getSuppGoodsGrossMarginId(),
					this.getLoginUser() == null ? "" : this.getLoginUser().getUserName(),
					"修改毛利率："+logContent,
					ComLog.COM_LOG_LOG_TYPE.GROSS_MARGIN_GOODS_ADD.name(),
					"修改毛利率",null);
		}catch(Exception e){
			LOG.error(ExceptionFormatUtil.getTrace(e));
			return ResultMessage.UPDATE_FAIL_RESULT;
		}
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

}
