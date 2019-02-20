package com.lvmama.vst.back.goods.web.traffic;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.lvmama.vst.back.goods.service.SuppGoodsFApiTimePriceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.goods.po.SuppGoodsFApiTimePrice;
import com.lvmama.vst.back.goods.po.SuppGoodsLineTimePrice;
import com.lvmama.vst.back.goods.po.SuppGoodsTimePrice;
import com.lvmama.vst.supp.client.service.SuppGoodsLineTimePriceClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.supp.service.SuppSupplierClientService;
import com.lvmama.vst.back.supp.po.SuppSupplier;
import com.lvmama.vst.back.util.tag.VstBackOrgAuthentication;
import com.lvmama.vst.comm.utils.CalendarUtils;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.ebooking.ebk.vo.SuppGoodsLineVO;
import com.lvmama.vst.pet.goods.PetProdGoodsAdapter;
import com.lvmama.vst.back.utils.MiscUtils;

/**
 * 时间价格表Action
 * 
 * @author mayonghua
 * @date 2013-10-24
 */
@Controller
@RequestMapping("/goods/traffic/timePrice")
public class TrafficSuppGoodsTimePriceAction extends BaseActionSupport {

	@Autowired
	private SuppGoodsLineTimePriceClientService suppGoodsLineTimePriceService;
	@Autowired
	private SuppSupplierClientService suppSupplierService;
	@Autowired
	private SuppGoodsClientService suppGoodsService;
	@Autowired
	private ProdProductService prodProductService;
	@Autowired
	private ComLogClientService comLogService;
	@Autowired
	private PetProdGoodsAdapter petProdGoodsAdapter;
	@Autowired
	private SuppGoodsFApiTimePriceService suppGoodsFApiTimePriceService;
	
	/**
	 * 获得时间价格列表
	 * @throws Exception 
	 */
	@RequestMapping(value = "/findGoodsTimePriceList")
	@ResponseBody
	public Object findGoodsTimePriceList(Model model, Integer page, SuppGoodsLineTimePrice  suppGoodsLineTimePrice, HttpServletRequest req,String apiFlag) throws Exception {

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("suppGoodsId", suppGoodsLineTimePrice.getSuppGoodsId());
		parameters.put("suppilerId", suppGoodsLineTimePrice.getSupplierId());
		parameters.put("beginDate",CalendarUtils.getFirstDayOfMonth(suppGoodsLineTimePrice.getSpecDate()));
		parameters.put("endDate", CalendarUtils.getLastDayOfMonth(suppGoodsLineTimePrice.getSpecDate()));
		if(!"Y".equalsIgnoreCase(apiFlag)){
			List<SuppGoodsLineTimePrice> list = suppGoodsLineTimePriceService.findSuppGoodsLineTimePriceList(parameters);
			super.loadVstOrgAuthentication(TrafficSuppGoodsTimePriceAction.class, VstBackOrgAuthentication.class, list);
			return list;
			}
		else{
			List<SuppGoodsFApiTimePrice> list = suppGoodsFApiTimePriceService.findSuppGoodsFApiTimePriceList(parameters);
			super.loadVstOrgAuthentication(TrafficSuppGoodsTimePriceAction.class, VstBackOrgAuthentication.class, list);
			return list;
		}
		}

	/**
	 * 打开时间价格表页面
	 */
	@RequestMapping(value = "/showGoodsTimePrice")
	public String showGoodsTimePrice(Model model, SuppGoods suppGoods) throws BusinessException {
		// 查询供应商
		if(suppGoods.getSuppSupplier()!=null){
			suppGoods.setSuppSupplier((SuppSupplier) MiscUtils.autoUnboxing(suppSupplierService.findSuppSupplierById(suppGoods.getSuppSupplier().getSupplierId())));
		}
		
		Map<String, Object> params = new HashMap<String, Object>();
		if ((suppGoods.getProdProduct() != null) && (suppGoods.getSuppSupplier() != null)) {
			// 查询产品
			ProdProduct product = prodProductService.findProdProduct4FrontById(suppGoods.getProdProduct().getProductId(), false, false);
			model.addAttribute("prodProduct", product);
			// 查询商品
			params.put("productId", suppGoods.getProdProduct().getProductId());
			if(suppGoods.getSuppSupplier().getSupplierId()!=null){
				params.put("supplierId", suppGoods.getSuppSupplier().getSupplierId());
			}
			params.put("branchId", suppGoods.getProdProductBranch().getBizBranch().getBranchId());
			List<SuppGoods> goodsList = suppGoodsService.findSuppGoodsListByBranch(params);
			model.addAttribute("goodsList", goodsList);
		}
		model.addAttribute("suppGoods", suppGoods);
		model.addAttribute("apiFlag", suppGoods.getApiFlag());
		if("Y".equalsIgnoreCase(suppGoods.getApiFlag())){
			return "/goods/traffic/timePrice/showGoodsFApiTimePrice";
		}
		return "/goods/traffic/timePrice/showGoodsTimePrice";
	}

	/**
	 * 保存时间价格表
	 */
	@RequestMapping(value = "/editGoodsTimePrice")
	@ResponseBody
	public Object editGoodsTimePrice(Model model, SuppGoodsLineVO suppGoodsLineVO) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<saveGoodsTimePrice>");
		}
		suppGoodsLineVO.setIsSetAheadBookTime("Y");
		suppGoodsLineVO.setIsSetPrice("Y");
		suppGoodsLineVO.setIsSetStock("Y");
		suppGoodsLineTimePriceService.editSuppGoodsLineTimePrice(suppGoodsLineVO);
		return ResultMessage.SET_SUCCESS_RESULT;
	}

	/**
	 * 保存机票时间价格表
	 */
	@RequestMapping(value = "/editGoodsFApiTimePrice")
	@ResponseBody
	public Object editGoodsFApiTimePrice(Model model, SuppGoodsLineVO suppGoodsLineVO) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<saveGoodsTimePrice>");
		}
		suppGoodsLineVO.setIsSetAheadBookTime("Y");
		suppGoodsLineVO.setIsSetPrice("Y");
		suppGoodsLineVO.setIsSetStock("Y");
		suppGoodsFApiTimePriceService.editSuppGoodsFApiTimePrice(suppGoodsLineVO);
		return ResultMessage.SET_SUCCESS_RESULT;
	}

	/**
	 * 跳转到修改页面
	 */
	@RequestMapping(value = "/showUpdateGoodsTimePrice")
	public String showUpdateGoodsTimePrice(Model model, Long suppGoodsTimePriceId) throws BusinessException {
		SuppGoodsLineTimePrice suppGoodsTimePrice = suppGoodsLineTimePriceService.findSuppGoodsLineTimePrice(suppGoodsTimePriceId);
		model.addAttribute("suppGoodsTimePrice", suppGoodsTimePrice);
		return "/goods/timePrice/showUpdateGoodsTimePrice";
	}

	/**
	 * 跳转到添加
	 */
	@RequestMapping(value = "/showAddSuppGoodsTimePrice")
	public String showAddGoodsTimePrice(Model model) {
		return "/goods/traffic/timePrice/showAddSuppGoodsTimePrice";
	}

	/**
	 * 更新
	 */
	@RequestMapping(value = "/updateSuppGoodsTimePrice")
	@ResponseBody
	public Object updateGoodsTimePrice(SuppGoodsLineTimePrice suppGoodsLineTimePrice) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<updateGoodsTimePrice>");
		}

		suppGoodsLineTimePriceService.updateSuppGoodsLineTimePrice(suppGoodsLineTimePrice);
		 SuppGoods suppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoodsLineTimePrice.getSuppGoodsId()));
			//添加操作日志
			try {
				comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
						suppGoodsLineTimePrice.getSuppGoodsId(), suppGoodsLineTimePrice.getSuppGoodsId(), 
						this.getLoginUser().getUserName(), 
						"修改了商品：【"+suppGoods.getGoodsName()+"】的时间价格.", 
						COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_TIME.name(), 
						"修改商品时间价格表",null);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				log.error("Record Log failure ！Log Type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_TIME.name());
				log.error(e.getMessage());
			}	
	
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}
	
	
	 private String getTimePriceChangeLog(SuppGoodsTimePrice suppGoodsTimePrice,String payType){
		 StringBuffer logStr = new StringBuffer("");
		 if(null!= suppGoodsTimePrice)
		 {
			 //日期范围
			 logStr.append(ComLogUtil.getLogTxt("日期范围",CalendarUtils.getDateFormatString(suppGoodsTimePrice.getStartDate(),CalendarUtils.DATE_PATTERN)+"至"+CalendarUtils.getDateFormatString(suppGoodsTimePrice.getEndDate(),CalendarUtils.DATE_PATTERN),null));
			 if("0".equals(suppGoodsTimePrice.getType()))
			 {
				 //价格禁售
				 logStr.append(ComLogUtil.getLogTxt("价格禁售","Y".equals(suppGoodsTimePrice.getOnsaleFlag())?"可售":"禁售",null));
				 //早餐情况
				 logStr.append(ComLogUtil.getLogTxt("早餐情况",String.valueOf(suppGoodsTimePrice.getBreakfast()),null));
				 if("Y".equals(suppGoodsTimePrice.getOnsaleFlag()))
				 {
					 // 销售价
					 Long salePrice = suppGoodsTimePrice.getPrice();
					 if(null!=salePrice && salePrice>0)
					 {
						 logStr.append(ComLogUtil.getLogTxt("销售价",String.valueOf(salePrice/100),null));
					 }
					 
					 // 结算价
					 Long settlement = suppGoodsTimePrice.getSettlementPrice();
					 if(null!=settlement && settlement>0)
					 {
						 logStr.append(ComLogUtil.getLogTxt("结算价",String.valueOf(settlement/100),null)); 
					 }
					 
					 //提前预定时间
					 logStr.append(ComLogUtil.getLogTxt("提前预定时间",String.valueOf(suppGoodsTimePrice.getAheadBookTime()),null));
					
	
				 }
			}else if ("1".equals(suppGoodsTimePrice.getType())) {
				// 更新退改机制
				//(预付)
				if("PREPAID".equals(payType)){
					//预付最晚无损取消时间
					logStr.append(ComLogUtil.getLogTxt("预付最晚无损取消时间",String.valueOf(suppGoodsTimePrice.getLatestCancelTime()),null));
					//预付扣款类型
					String newValue = suppGoodsTimePrice.getDeductType();
					String strValue = SuppGoodsTimePrice.DEDUCTTYPE.getCnName(newValue);
					logStr.append(ComLogUtil.getLogTxt("预付扣款类型",strValue,null));
					if("MONEY".equals(newValue))
					{
						Long money = suppGoodsTimePrice.getDeductValue();
						if(null!=money && money > 0)
						{
						   logStr.append(ComLogUtil.getLogTxt("扣款金额",String.valueOf(money/100),null));
						}
					}
					if("PERCENT".equals(newValue))
					{
						Long percent = suppGoodsTimePrice.getDeductValue();
						if(null!=percent && percent > 0)
						{
						   logStr.append(ComLogUtil.getLogTxt("扣款百分比",String.valueOf(percent)+"%",null));
						}
					}
					
					//预付预授权限制
					String limitType = suppGoodsTimePrice.getBookLimitType();
					limitType = SuppGoodsTimePrice.BOOKLIMITTYPE.getCnName(limitType);
					logStr.append(ComLogUtil.getLogTxt("预付预授权限制",limitType,null));
					
				}
				//(现付)
				if("PAY".equals(payType)){
					//担保最晚无损取消时间
					logStr.append(ComLogUtil.getLogTxt("担保最晚无损取消时间",String.valueOf(suppGoodsTimePrice.getLatestCancelTime()),null));
					//全额/峰时担保扣款
					String newValue = suppGoodsTimePrice.getDeductType();
					newValue = SuppGoodsTimePrice.DEDUCTTYPE.getCnName(newValue);
					logStr.append(ComLogUtil.getLogTxt("全额/峰时担保扣款类型",newValue,null));
					//预订限制
					String limitType = suppGoodsTimePrice.getBookLimitType();
					limitType = SuppGoodsTimePrice.BOOKLIMITTYPE.getCnName(limitType);
					logStr.append(ComLogUtil.getLogTxt("预订限制",limitType,null));
					//担保类型 
					String guarType = suppGoodsTimePrice.getGuarType();
					guarType = SuppGoodsTimePrice.GUARTYPE.getCnName(guarType);
					logStr.append(ComLogUtil.getLogTxt("担保类型",guarType,null));
					//预定限制_是否房量担保  quantityType guarQuantity
					Long guarQuantity = suppGoodsTimePrice.getGuarQuantity();
					if(null!= guarQuantity)
					{
						logStr.append(ComLogUtil.getLogTxt("超量担保",String.valueOf(suppGoodsTimePrice.getGuarQuantity()),null));
					}
					
				}
				
			} else if ("3".equals(suppGoodsTimePrice.getType())) {
				// 更新库存
				//合同库存 
				logStr.append(ComLogUtil.getLogTxt("合同库存 ",String.valueOf(suppGoodsTimePrice.getTotalStock()),null));
				//库存类型 
				logStr.append(ComLogUtil.getLogTxt("库存类型 ","Y".equals(suppGoodsTimePrice.getStockFlag())?"保留房":"非保留房",null));
				if("Y".equals(suppGoodsTimePrice.getStockFlag()))
				{
					//增减保留房
					int increase = suppGoodsTimePrice.getIncrease();
					if(increase>0)
					{
						logStr.append(ComLogUtil.getLogTxt("保留房增加",String.valueOf(suppGoodsTimePrice.getIncrease()),null));
					}else{
						logStr.append(ComLogUtil.getLogTxt("保留房减少 ",String.valueOf(suppGoodsTimePrice.getIncrease()),null));
					}
					//保留房可否恢复 restoreFlag
					logStr.append(ComLogUtil.getLogTxt("保留房可否恢复 ","Y".equals(suppGoodsTimePrice.getRestoreFlag())?"可恢复":"不可恢复",null));
					//是否可超卖 overshellFlag
					logStr.append(ComLogUtil.getLogTxt("是否可超卖","Y".equals(suppGoodsTimePrice.getOvershellFlag())?"可超卖":"不可超卖",null));
				}
			}
			 
			//预付预授权限制
			String limitType = suppGoodsTimePrice.getBookLimitType();
			limitType = SuppGoodsTimePrice.BOOKLIMITTYPE.getCnName(limitType);
			if(limitType != null){
				logStr.append(ComLogUtil.getLogTxt("预付预授权限制", limitType, null));
			}
		 }
		 return logStr.toString();
	 }

}
