package com.lvmama.vst.back.prod.web;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.lvmama.vst.back.biz.po.BizEnum;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsHotelAdapterClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsTimePriceClientService;
import com.lvmama.vst.back.client.prod.service.ProdCalClientService;
import com.lvmama.vst.back.client.prod.service.ProdGroupDateClientService;
import com.lvmama.vst.back.client.prod.service.ProdPackageDetailClientService;
import com.lvmama.vst.back.client.prod.service.ProdPackageGroupClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.goods.po.SuppGoodsRefund;
import com.lvmama.vst.back.goods.po.SuppGoodsTimePrice;
import com.lvmama.vst.back.goods.service.SuppGoodsRefundService;
import com.lvmama.vst.back.goods.utils.SuppGoodsRefundTools;
import com.lvmama.vst.back.pack.data.ProdPackageDetailGoodsData;
import com.lvmama.vst.back.pack.service.ProdPackageDetailGoodsService;
import com.lvmama.vst.back.prod.po.ProdGroupDate;
import com.lvmama.vst.back.prod.po.ProdPackageDetail;
import com.lvmama.vst.back.prod.po.ProdPackageDetail.OBJECT_TYPE_DESC;
import com.lvmama.vst.back.prod.po.ProdPackageGroup;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdRefund;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.prod.service.ProdRefundService;
import com.lvmama.vst.back.prod.vo.ProdRefundExt;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.CalendarUtils;
import com.lvmama.vst.comm.utils.DESCoder;
import com.lvmama.vst.comm.utils.DateUtil;
import com.lvmama.vst.comm.utils.WineSplitConstants;
import com.lvmama.vst.comm.utils.web.HttpsUtil;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 产品管理router
 * 产品的添加，修改都要在此处做中转
 * @author mayonghua
 *
 */
@Controller
@RequestMapping("/prod/refund")
public class ProductReFundAction extends BaseActionSupport{
	
    private static final long serialVersionUID = 76839820479921244L;

    @Autowired
	private ProdRefundService prodRefundService;
    
    @Autowired
    private ProdProductService prodProductService;
	
	@Autowired
    private ComLogClientService comLogService;
	
	@Autowired
	private ProdPackageGroupClientService prodPackageGroupService;
	
	@Autowired
	private ProdPackageDetailClientService prodPackageDetailService;
	
	@Autowired
	private ProdPackageDetailGoodsService prodPackageDetailGoodsService;

	@Autowired
	private SuppGoodsClientService suppGoodsService;

	@Autowired
	private SuppGoodsHotelAdapterClientService suppGoodsHotelAdapterService;
	
	@Autowired
	private SuppGoodsRefundService suppGoodsRefundService;

	@Autowired
	private SuppGoodsTimePriceClientService suppGoodsTimePriceAdapterService;
	
	@Autowired
	private ProdGroupDateClientService prodGroupDateService;
	
	@Autowired
	private ProdCalClientService prodCalClientService;
	
	/**
	 * 编辑
	 * @param model
	 * @param categoryId
	 * @return
	 */
	@RequestMapping(value = "/editProductReFund")
	@ResponseBody
	public Object updateProductReFund(Model model,ProdRefund prodRefund){
		if(prodRefund==null)
			throw new BusinessException("退改规则设置失败");
		prodRefundService.updateProdRefund(prodRefund);
		
		try {
            comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
                    prodRefund.getProductId(), prodRefund.getProductId(), 
                    this.getLoginUserId(), 
                    "修改退改规则:"+getProdRefundLog(prodRefund), 
                    COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_TIME.name(), 
                    "修改退改规则:",null);
        } catch (Exception e) {
            log.error(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS.getCnName()+"日志操作异常！");
        }
		
		return ResultMessage.SET_SUCCESS_RESULT;
	}
	
	
	/**
	 * 编辑已存在的退改规则
	 * @param model
	 * @param categoryId
	 * @return
	 */
	@RequestMapping(value = "/editExistsProductReFund")
	@ResponseBody
	public Object editExistsProductReFund(Model model,ProdRefund prodRefund){
		if(prodRefund==null)
			throw new BusinessException("退改规则设置失败");
		prodRefundService.updateExistsProdRefund(prodRefund);
		try {
			String logString = getProdRefundLog(prodRefund);
            comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
                    prodRefund.getProductId(), prodRefund.getProductId(), 
                    this.getLoginUserId(), 
                    "修改退改规则:"+logString, 
                    COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_TIME.name(), 
                    "修改退改规则:",null);
        } catch (Exception e) {
            log.debug(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS.getCnName()+"日志操作异常！");
        }
		
		return ResultMessage.SET_SUCCESS_RESULT;
	}
	
	
	@RequestMapping(value = "/showProductReFund")
	public Object showProductReFund(Model model,Long productId){
		try {
			ProdProduct product = prodProductService.findProdProductByProductId(productId);
			if (isBu(product) && isPackageType(product) && isFreetour(product)) {
				model.addAttribute("isNeed", "true");
			} else if( ("INNERLINE".equals(product.getProductType())
					||"INNER_BORDER_LINE".equals(product.getProductType())
					||"INNERLONGLINE".equals(product.getProductType()) 
					||"INNERSHORTLINE".equals(product.getProductType()) )
					&& isPackageType(product)) {
				//国内自主打包线路
				model.addAttribute("isNeed", "true");
				
			}
			//国内自主打包自由行景酒判断
			if (isPackageType(product) && isFreetour(product) && 
					("INNERLINE".equals(product.getProductType())
							||"INNER_BORDER_LINE".equals(product.getProductType())
							||"INNERLONGLINE".equals(product.getProductType()) 
							||"INNERSHORTLINE".equals(product.getProductType()))) {
				model.addAttribute("LOCAL_BU_LVMAMA_INNER_JINGJIU", "true");
			}
			model.addAttribute("product", product);
		} catch (Exception e) {
			log.error("findProductById exception occurred. ");
		}
		model.addAttribute("productId", productId);
		return "/prod/packageTour/product/showProdReFund";
	}

	/**
	 * 打包类型
	 * @param product
	 * @return
	 */
	private boolean isPackageType(ProdProduct product) {
		return ProdProduct.PACKAGETYPE.LVMAMA.getCode().equals(product.getPackageType());
	}

	/**
	 * BU限制
	 * @param product
	 * @return
	 */
	private boolean isBu(ProdProduct product) {
		return "DESTINATION_BU".equals(product.getBu()) || "LOCAL_BU".equals(product.getBu()) || "OUTBOUND_BU".equals(product.getBu());
	}
	
	/**
	 * 是否自由行 景+酒 产品
	 * @param product
	 * @return
	 */
	private boolean isFreetour(ProdProduct product) {
		if (Constant.SEARCH_TYPE_TAG.FREETOUR.getCode() == product.getBizCategoryId().intValue()) {
			if(WineSplitConstants.WINE_SPLIT_CATEGORY_ID.equals(product.getSubCategoryId())){
				return true;
			}			
		}
		return false;
	}
	
	/**
	 * 查询
	 * @param model
	 * @param categoryId
	 * @param productId
	 * @param categoryName
	 * @return
	 */
	@RequestMapping(value = "/findProductReFund")
	@ResponseBody
	public Object findProductReFund(Model model,Long productId, Date specDate){
		if(specDate==null)
			specDate = new Date();
		if(productId==null)
			throw new BusinessException("产品ID不能为空");
		HashMap<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("productId", productId);
		parameters.put("beginDate",CalendarUtils.getFirstDayOfMonth(specDate));
		parameters.put("endDate", CalendarUtils.getLastDayOfMonth(specDate));
		List<ProdRefund> list = prodRefundService.selectByParams(parameters);
		if (list == null || list.isEmpty()) {
			return list;
		}
		
		ProdProduct product = prodProductService.getProdProductBy(productId);
		//添加上团期
		list = setProdGroupDate(list, product, parameters);
		
		//不是原来的景酒，对于同步商品退改，不用列出明细
		if (isBu(product) && isPackageType(product) && isFreetour(product)) {
			for (ProdRefund refund : list) {
				if (ProdRefund.CANCELSTRATEGYTYPE.GOODSRETREATANDCHANGE.getCode().equals(refund.getCancelStrategy())) {	//同步商品退改
					// 待确认 退改规则表显示同步商品的退改规则
					log.error("GOODSRETREATANDCHANGE get rule list .");
					List<Long> suppGoodsIdList = new ArrayList<Long>();
					try {
						//Long productId = refund.getProductId();
						//Date specDate = refund.getSpecDate();
						Map<String, Object> prodPackageGroupParams = new HashMap<String, Object>();
						prodPackageGroupParams.put("productId", productId);
						List<ProdPackageGroup> packGroupList = prodPackageGroupService.findProdPackageGroup(prodPackageGroupParams);
						if (packGroupList == null || packGroupList.isEmpty()) {
							continue;
						}
						HashMap<String, Object> params = new HashMap<String, Object>();
						params.put("productId", productId);
						for (ProdPackageGroup group : packGroupList) {
							params.put("groupId", group.getGroupId());
							List<ProdPackageDetail> detailList = prodPackageDetailService.findProdPackageDetailList(params);
							for (ProdPackageDetail detail : detailList) {
								String objectType = detail.getObjectType();
								Long objectId = detail.getObjectId();
								//商品
								if(OBJECT_TYPE_DESC.SUPP_GOODS.getCode().equals(objectType)){
									suppGoodsIdList.add(objectId);
								}
								// 产品
								else if(OBJECT_TYPE_DESC.PROD_PROCUT.getCode().equals(objectType)){
	//								List<SuppGoods> suppGoodsList = suppGoodsService.findSuppGoodsByProductId(objectId);
	//								if (suppGoodsList == null || suppGoodsList.isEmpty()) {
	//									continue;
	//								}
	//								for (SuppGoods suppGoods : suppGoodsList) {
	//									suppGoodsIdList.add(suppGoods.getSuppGoodsId());
	//								}
								}else if(OBJECT_TYPE_DESC.PROD_BRANCH.getCode().equals(objectType)){
									Map<String, Object> detailParams = new HashMap<String, Object>();
									detailParams.put("detailId", detail.getDetailId());
									List<ProdPackageDetailGoodsData> detailGoodsList = prodPackageDetailGoodsService.selectPackagedGoodsByParams(detailParams);
									if (detailGoodsList == null || detailGoodsList.isEmpty()) {
										Map<String, Object> goodsParams = new HashMap<String, Object>();
										goodsParams.put("productBranchId", detail.getObjectId());
										goodsParams.put("cancelFlag", "Y");
										if (group.getCategoryId().equals(BizEnum.BIZ_CATEGORY_TYPE.category_single_ticket.getCategoryId())) {
											goodsParams.put("aperiodicFlag", "N");
										}
										goodsParams.put("isNotHotel", true);
										List<SuppGoods> goodsList = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsByProduct(goodsParams));
										if (goodsList == null || goodsList.isEmpty()) {
											continue;
										}
										for (SuppGoods goods : goodsList) {
											suppGoodsIdList.add(goods.getSuppGoodsId());
										}
										List<SuppGoods> hotelGoodsList = suppGoodsHotelAdapterService.findSuppGoodsListByBranch(goodsParams);
										for (SuppGoods goods : hotelGoodsList) {
											suppGoodsIdList.add(goods.getSuppGoodsId());
										}
									} else {
										for (ProdPackageDetailGoodsData goodsData : detailGoodsList) {
											suppGoodsIdList.add(goodsData.getSuppGoodsId());
										}
									}
								}
							}
						}
						HashMap<String,Object> goodsParams = new HashMap<String, Object>();
						for (Long goodsId : suppGoodsIdList) {
							String type = "";
							String content = "";
							SuppGoods suppgoods = MiscUtils.autoUnboxing( suppGoodsHotelAdapterService.findSuppGoodsById(goodsId) );
							if(suppgoods == null){
								continue;
							}
							if(BizEnum.BIZ_CATEGORY_TYPE.category_hotel.getCategoryId().equals(suppgoods.getCategoryId())){
								goodsParams.clear();
								goodsParams.put("suppGoodsId", goodsId);
								goodsParams.put("specDate", refund.getSpecDate());
								
								SuppGoodsTimePrice suppGoodsTimePrice = suppGoodsTimePriceAdapterService.getHotelGoodsTimePrice(goodsId, refund.getSpecDate(), false);
								List<SuppGoodsTimePrice> suppGoodsTimePrices = new ArrayList<>();
								if (suppGoodsTimePrice != null) {
									suppGoodsTimePrices.add(suppGoodsTimePrice);
									if(suppGoodsTimePrices != null && suppGoodsTimePrices.size() == 1){
										SuppGoodsTimePrice timePrice = suppGoodsTimePrices.get(0);
										Map<String,String> tempMap = timePrice.getHotelCancelStrategyDesc(suppGoodsTimePrices,suppgoods.getPayTarget());
										type = tempMap.get("type");
										content = tempMap.get("content");
									}
								}
							}else if(BizEnum.BIZ_CATEGORY_TYPE.category_single_ticket.getCategoryId().equals(suppgoods.getCategoryId()) 
									|| BizEnum.BIZ_CATEGORY_TYPE.category_other_ticket.getCategoryId().equals(suppgoods.getCategoryId())
									|| BizEnum.BIZ_CATEGORY_TYPE.category_comb_ticket.getCategoryId().equals(suppgoods.getCategoryId())){
								goodsParams.clear();
								goodsParams.put("goodsId", goodsId);
								List<SuppGoodsRefund> suppGoodsRefunds = suppGoodsRefundService.findSuppGoodsRefundList(goodsParams);
								content = SuppGoodsRefundTools.SuppGoodsRefundVOToStr(suppGoodsRefunds, suppgoods.getAperiodicFlag());
							} else if(BizEnum.BIZ_CATEGORY_TYPE.category_route_hotelcomb.getCategoryId().equals(suppgoods.getCategoryId())){
								//TODO
							}
							Map<String, String> map = new HashMap<String, String>();
	
							map.put("type", suppgoods.getGoodsName());
							map.put("content", content);
							if (refund.getGoodsRefundRules() == null) {
								refund.setGoodsRefundRules(new ArrayList<Map<String,String>>());
							}
							refund.getGoodsRefundRules().add(map);
						}
					} catch (Exception e) {
						log.error("GOODSRETREATANDCHANGE get rule list exception occurred.");
						e.printStackTrace();
					}
				}
			}
		}
		return list;
	}
	
	//只对国内的线路有效
	private List<ProdRefund> setProdGroupDate(List<ProdRefund> list, ProdProduct product, Map<String, Object> parameters) {
		//不是国内线路产品，直接返回，不添加起价信息了
		if( !(("INNER_BORDER_LINE".equals(product.getProductType())
				||"INNERLINE".equals(product.getProductType())
				||"INNERLONGLINE".equals(product.getProductType()) 
				||"INNERSHORTLINE".equals(product.getProductType()) )
				&& isPackageType(product)) ) {
			return list;
		}
		List<ProdGroupDate> prodGroupDateList = prodGroupDateService.findProdGroupDateByParamsBaseNoCache2(product.getProductId(), parameters);
		Map<Date, ProdGroupDate> dayLowestPriceMap = new HashMap<Date, ProdGroupDate>();
		if(prodGroupDateList != null && !prodGroupDateList.isEmpty()) {
			Set<Long> startDistrictIdSet = new HashSet<Long>();
			for(ProdGroupDate groupDate : prodGroupDateList) {
				if(groupDate.getStartDistrictId() != null && groupDate.getStartDistrictId() != -1L) {					
					startDistrictIdSet.add(groupDate.getStartDistrictId());
				}
				if(dayLowestPriceMap.containsKey(groupDate.getSpecDate())) {
					ProdGroupDate curr = dayLowestPriceMap.get(groupDate.getSpecDate());
					if (curr.getAheadBookTime() != null && groupDate.getAheadBookTime() != null
							&& groupDate.getAheadBookTime() > curr.getAheadBookTime()) {
						dayLowestPriceMap.put(groupDate.getSpecDate(), groupDate);
					} else if (curr.getLowestSaledPrice() == null && groupDate.getLowestSaledPrice() != null) {
						dayLowestPriceMap.put(groupDate.getSpecDate(), groupDate);
					}
				} else {
					dayLowestPriceMap.put(groupDate.getSpecDate(), groupDate);
				}
			}
		}
		List<ProdRefund> extList = new ArrayList<ProdRefund>();
		for (ProdRefund refund : list) {
			ProdRefundExt ext = new ProdRefundExt(refund, product);
			ext.setProdGroupDate(dayLowestPriceMap.get(refund.getSpecDate()));
			extList.add(ext);
		}
		return extList;
	}
	
	private List<Date> getSuppGoodSelectDate(Date startDate,Date endDate,List<Integer> weekDay,List<String> selectDates,String selectCalendar){
		List<Date> dateList = new ArrayList<Date>();
		// 时间段
		if(selectCalendar.equalsIgnoreCase("selectTime")){
			dateList = CalendarUtils.getDates(startDate,endDate,weekDay);
		}else{
			if(null!=selectDates && !selectDates.isEmpty()){
				for (String specDate : selectDates) {
					SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
					try {
						Date date = df.parse(specDate);
						dateList.add(date);
					} catch (ParseException e) {
						throw new BusinessException("日期格式错误");
					}
				}
			}
		}
		if(null==dateList || dateList.isEmpty()){
			throw new BusinessException("dateList must be not null");
		}
		return dateList;
	}
	
    private String getProdRefundLog(ProdRefund prodRefund){
        if(prodRefund == null){
            return null;
        }
        
        String dateType = "selectDate";
        List<String> dates = new ArrayList<String>();
        if(prodRefund.getSpecDates()!=null ){
        	String[] dateArr = prodRefund.getSpecDates();
        	for(int i=0,j=dateArr.length;i<j;i++){
        		dates.add(dateArr[i]);
        	}
        	dateType = "selectDate";
        }else{
        	dateType = "selectTime";
        }
        
        List<Date> dateList = getSuppGoodSelectDate(prodRefund.getStartDate(), prodRefund.getEndDate(), prodRefund.getWeekDay(), dates,dateType);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        StringBuilder datestr = new StringBuilder();
        datestr.append("日期范围：[值变更为：");
        if(dateList!=null && dateList.size()>0){
        	datestr.append(sdf.format(dateList.get(0)));
        	if(dateList.size()>1){
        		datestr.append("至"+sdf.format(dateList.get(dateList.size()-1)));
            }
        }
        datestr.append("] ");
        
        List<String> weeks = getChineseWeekDays(prodRefund.getWeekDay());
        for(int m=0,n=weeks.size();m<n;m++){
        	if(m==0) datestr.append("适用日期：[值变更为：");
        	datestr.append("星期"+weeks.get(m));
        	if(m==n-1) {
        		datestr.append("] ");
        	}else{
        		datestr.append("、");
        	}
        }
        datestr.append(", 退改类型:"+ProdRefund.CANCELSTRATEGYTYPE.getCnName(prodRefund.getCancelStrategy())+"; ");
        
        datestr.append(",提前预定时间:" + (prodRefund.getAheadBookTime() == null?"为空":prodRefund.getAheadBookTime()) + ";");

        if ("RETREATANDCHANGE".equals(prodRefund.getCancelStrategy())) {
			datestr.append(prodRefund.getRefundRuleLog());			
		}
		return datestr.toString();
    }

    
    private List<String> getChineseWeekDays(List<Integer> weekDays){
        if(CollectionUtils.isEmpty(weekDays)){
            return Collections.emptyList();
        }
        List<String> chineseWeekDays = new ArrayList<String>();
        for(Integer weekDay : weekDays){
            if(weekDay == 1){
                chineseWeekDays.add("日");
            }else if(weekDay == 2){
                chineseWeekDays.add("一");
            }else if(weekDay == 3){
                chineseWeekDays.add("二");
            }else if(weekDay == 4){
                chineseWeekDays.add("三");
            }else if(weekDay == 5){
                chineseWeekDays.add("四");
            }else if(weekDay == 6){
                chineseWeekDays.add("五");
            }else if(weekDay == 7){
                chineseWeekDays.add("六");
            }
        }
        return chineseWeekDays;
    }
    
	@RequestMapping(value = "/refreshGroupDate")
	@ResponseBody
    public ResultMessage refreshGroupDate(Long productId) {
		if(productId==null)
			return new ResultMessage(ResultMessage.ERROR, "产品id不能为空");
		
		//检查产品是否已经打包规格了
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productId", productId);
		
		//自主打包的产品才需要检查打包情况
		ProdProduct product = prodProductService.findProdProductByProductId(productId);
		if (product != null && "LVMAMA".equals(product.getPackageType())) {
			List<ProdPackageGroup> groupList = prodPackageGroupService.findProdPackageGroup(params);
			if (groupList == null || groupList.isEmpty()) {
				return new ResultMessage(ResultMessage.ERROR, "请先打包产品");
			}
			for (ProdPackageGroup group : groupList) {
				params.put("groupId", group.getGroupId());
				int count = prodPackageDetailService.getProdPackageDetailCount(params);
				if (count < 1) {
					String categoryName = BizEnum.BIZ_CATEGORY_TYPE.getCnName(group.getCategoryId());
					return new ResultMessage(ResultMessage.ERROR, categoryName + "组未打包产品");
				}
			}
		}
		//团期计算
		try {
			String code = DESCoder.encrypt(DateUtil.formatSimpleDate(DateUtil.getTodayDate()));
			//先计算可售
			String url = "http://super.lvmama.com/prodcal_routePackage/productCal/calProdSell.do?productId=" + productId + "&code=" + code;
			String strResult = HttpsUtil.requestGet(url);
			if(strResult == null || strResult.contains("failed") || strResult.contains("不可售")) {
				return new ResultMessage(ResultMessage.ERROR, "可售计算结果为不可售");
			}
			url = "http://super.lvmama.com/prodcal_routePackage/productCal/calProductPricemy.do?productId=" + productId + "&code=" + code ;
			strResult = HttpsUtil.requestGet(url);
			if (strResult != null) {
				Map<String, Object> resultMap = new Gson().fromJson(strResult,
						new TypeToken<Map<String, Object>>() {}.getType());
				if(resultMap != null && "success".equals(resultMap.get("code")) ) {
					return new ResultMessage(ResultMessage.SUCCESS, "团期计算完成");
				}
			}
		} catch (Exception e) {
			log.error(e.getMessage(), e);
			return new ResultMessage(ResultMessage.ERROR, "计算异常！！！");
		};
    	return new ResultMessage(ResultMessage.SUCCESS, "团期计算失败");
    }
	
	@RequestMapping(value = "/refreshSuppPackGroupDate")
	@ResponseBody
    public ResultMessage refreshSuppPackGroupDate(Long productId) {
		if(productId==null)
			return new ResultMessage(ResultMessage.ERROR, "产品id不能为空");
		
		//检查产品是否已经打包规格了
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productId", productId);
		

		//团期计算
		try {
			String code = DESCoder.encrypt(DateUtil.formatSimpleDate(DateUtil.getTodayDate()));
			//先计算可售
			String url = "http://super.lvmama.com/prodcal_routeSupplier/productCal/calProdSell.do?productId=" + productId + "&code=" + code;
			String strResult = HttpsUtil.requestGet(url);
			if(strResult == null || strResult.contains("failed") || strResult.contains("不可售")) {
				return new ResultMessage(ResultMessage.ERROR, "可售计算结果为不可售");
			}
			url = "http://super.lvmama.com/prodcal_routeSupplier/productCal/calProductPricemy.do?productId=" + productId + "&code=" + code ;
			strResult = HttpsUtil.requestGet(url);
			comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, 
					productId,productId, 
                    this.getLoginUserId(), 
                    "产品刷新团期操作:刷新团期", 
                    COM_LOG_LOG_TYPE.PROD_GROUP_DATE.name(), 
                    "刷新团期:",null);
			String str ="\"code\":\"failed\"";
			if (strResult != null  &&!strResult.contains(str)){
				
			
					  
					return new ResultMessage(ResultMessage.SUCCESS, "团期计算完成");
				
				
			}
		} catch (Exception e) {
			log.error(e.getMessage(), e);
			return new ResultMessage(ResultMessage.ERROR, "计算异常！！！");
		};
		

    	return new ResultMessage(ResultMessage.SUCCESS, "团期计算失败");
    }
}
