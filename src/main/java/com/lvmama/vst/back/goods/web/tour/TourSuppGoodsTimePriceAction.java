package com.lvmama.vst.back.goods.web.tour;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizBranch;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.service.BizBranchQueryService;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.goods.po.SuppGoodsLineTimePrice;
import com.lvmama.vst.back.goods.po.SuppGoodsTimePrice;
import com.lvmama.vst.supp.client.service.SuppGoodsLineTimePriceClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
//import com.lvmama.vst.back.goods.web.ship.ShipSuppGoodsTimePriceAction;
//import com.lvmama.vst.back.goods.web.ticket.TicketSuppGoodsAddTimePriceAction;
import com.lvmama.vst.back.prod.po.ProdProductBranch;
import com.lvmama.vst.back.prod.service.ProdProductBranchService;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.pub.service.ComPushClientService;
import com.lvmama.vst.back.client.supp.service.SuppSupplierClientService;
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
@RequestMapping("/tour/goods/timePrice")
public class TourSuppGoodsTimePriceAction extends BaseActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8807286024535854841L;
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
	private BizCategoryQueryService bizCategoryQueryService;
	@Autowired
	private ProdProductBranchService prodProductBranchService;
	@Autowired
	private BizBranchQueryService branchQueryService;
	
	@Autowired
	private ComPushClientService comPushService;
	
	/**
	 * 获得时间价格列表
	 * @throws Exception 
	 */
	@RequestMapping(value = "/findGoodsTimePriceList")
	@ResponseBody
	public Object findGoodsTimePriceList(Model model, Date specDate, HttpServletRequest req) throws Exception {
		Map<String, Object> parameters = new HashMap<String, Object>();
		String[] goodsIdArray = req.getParameterValues("suppGoodsId");
		List<SuppGoodsLineTimePrice> list = new ArrayList<SuppGoodsLineTimePrice>();
		for(String goodsId : goodsIdArray){
			if(goodsId!=null && !"".equalsIgnoreCase(goodsId)){
				parameters.put("suppGoodsId", goodsId);
				parameters.put("beginDate",CalendarUtils.getFirstDayOfMonth(specDate));
				parameters.put("endDate", CalendarUtils.getLastDayOfMonth(specDate));
			}
			List tempList = suppGoodsLineTimePriceService.findSuppGoodsLineTimePriceList(parameters);
			if(tempList!=null)
			list.addAll(tempList);
		}
		//加载vst权限
		super.loadVstOrgAuthentication(TourSuppGoodsTimePriceAction.class, VstBackOrgAuthentication.class, list);
		return list;
	}

	/**
	 * 打开时间价格表页面
	 */
	@RequestMapping(value = "/showGoodsTimePrice")
	public String showGoodsTimePrice(Model model, Long prodProductId ,String cancelFlag,Long categoryId) throws BusinessException {
		//查询品类
		BizCategory category  = bizCategoryQueryService.getCategoryById(categoryId);
		if(category == null){
			throw new BusinessException("品类不存在");
		}
		HashMap<String,Object> goodsMap = new HashMap<String, Object>();
		HashMap<String,Object> params = new HashMap<String,Object>();
		//如果是跟团游和自由行又或者是定制游
		if("category_route_group".equalsIgnoreCase(category.getCategoryCode()) || "category_route_freedom".equalsIgnoreCase(category.getCategoryCode()) || "category_route_customized".equalsIgnoreCase(category.getCategoryCode())){
			//查询规格
			List<BizBranch> branchList = branchQueryService.findBranchListByCategoryId(categoryId);
			for(BizBranch branch : branchList){
				//成人儿童
				if("adult_child_diff".equalsIgnoreCase(branch.getBranchCode())){
					//设置成人儿童房差
					queryAdultChildDiff(params,prodProductId,branch,goodsMap);
				//附加	
				}else if("addition".equalsIgnoreCase(branch.getBranchCode())){
					queryAddition(params,prodProductId,branch,goodsMap);
				//升级	
				}else if("upgrad".equalsIgnoreCase(branch.getBranchCode())){
					queryUpgrade(params,prodProductId,branch,goodsMap);
				//可换	
				}else if("changed_hotel".equalsIgnoreCase(branch.getBranchCode())){
					queryChangeHotel(params,prodProductId,branch,goodsMap);
				}
			}
			
		//如果是当地游
		}else if("category_route_local".equalsIgnoreCase(category.getCategoryCode())){
			//查询规格
			List<BizBranch> branchList = branchQueryService.findBranchListByCategoryId(categoryId);
			for(BizBranch branch : branchList){
				//成人儿童
				if("adult_child_diff".equalsIgnoreCase(branch.getBranchCode())){
					//设置成人儿童房差
					queryAdultChildDiff(params,prodProductId,branch,goodsMap);
				//附加	
				}else if("addition".equalsIgnoreCase(branch.getBranchCode())){
					queryAddition(params,prodProductId,branch,goodsMap);
				//升级	
				}
			}
		//如果是酒店套餐
		}else if("category_route_hotelcomb".equalsIgnoreCase(category.getCategoryCode())){
			//查询规格
			List<BizBranch> branchList = branchQueryService.findBranchListByCategoryId(categoryId);
			for(BizBranch branch : branchList){
				//套餐
				if("combo_dinner".equalsIgnoreCase(branch.getBranchCode())){
					//设置成人儿童房差
					queryCombDinner(params,prodProductId,branch,goodsMap);
				//附加	
				}else if("addition".equalsIgnoreCase(branch.getBranchCode())){
					queryAddition(params,prodProductId,branch,goodsMap);
				}
			}
		}
		
		model.addAttribute("cancelFlag", cancelFlag);
		model.addAttribute("goodsMap", goodsMap);
		model.addAttribute("categoryCode", category.getCategoryCode());
		model.addAttribute("prodProductId", prodProductId);
		model.addAttribute("categoryId", categoryId);
		
		return "/goods/tour/goods/showGoodsTimePrice";
	}

	/**
	 * 查询成人儿童房差
	 * @param params
	 * @param branch
	 * @param goodsMap
	 */
	private void queryAdultChildDiff(HashMap<String,Object> params,Long productId,BizBranch branch,HashMap<String,Object> goodsMap){
		params.clear();
		params.put("branchId", branch.getBranchId());
		params.put("productId", productId);
		List<ProdProductBranch> ppbList = prodProductBranchService.findProdProductBranchList(params);
		if(ppbList!=null&&ppbList.size()==1){
			ProdProductBranch ppb = ppbList.get(0);
			List<SuppGoods> goodsList = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsByBranchId(ppb.getProductBranchId()));
			if(goodsList!=null && goodsList.size() == 1){
				SuppGoods goods = goodsList.get(0);
				goodsMap.put("adult_child_diff", goods);
			}else {
				throw new BusinessException("无成人/儿童/房差商品或商品不唯一");
			}
		}else {
			throw new BusinessException("成人/儿童/房差产品规格不唯一");
		}
	}
	
	/**
	 * 查询套餐
	 * @param params
	 * @param branch
	 * @param goodsMap
	 */
	private void queryCombDinner(HashMap<String,Object> params,Long productId,BizBranch branch,HashMap<String,Object> goodsMap){
		params.clear();
		params.put("branchId", branch.getBranchId());
		params.put("productId", productId);
		List<SuppGoods> goodsList = new ArrayList<SuppGoods>();
		List<ProdProductBranch> ppbList = prodProductBranchService.findProdProductBranchList(params);
		if(ppbList!=null&&ppbList.size()>0){
			for(ProdProductBranch ppb : ppbList){
				List<SuppGoods> tempGoodsList = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsByBranchId(ppb.getProductBranchId()));
				if(tempGoodsList!=null && tempGoodsList.size()>0)
					goodsList.addAll(tempGoodsList);
			}
			goodsMap.put("combo_dinner", goodsList);
		}else {
			throw new BusinessException("请设置套餐规格");
		}
	}
	
	/**
	 * 查询附加
	 * @param params
	 * @param branch
	 * @param goodsMap
	 */
	private void queryAddition(HashMap<String,Object> params,Long productId,BizBranch branch,HashMap<String,Object> goodsMap){
		params.clear();
		params.put("branchId", branch.getBranchId());
		params.put("productId", productId);
		List<ProdProductBranch> ppbList = prodProductBranchService.findProdProductBranchList(params);
		List<SuppGoods> suppGoodsList = new ArrayList<SuppGoods>();
		if(ppbList!=null && ppbList.size()>0){
			for(ProdProductBranch ppb : ppbList){
				List<SuppGoods> goodsList = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsByBranchId(ppb.getProductBranchId()));
				if(goodsList!=null && goodsList.size() == 1){
					SuppGoods goods = goodsList.get(0);
					suppGoodsList.add(goods);
				}else {
					throw new BusinessException("附加商品与产品规格不是一对一关系");
				}
			}
		}
		goodsMap.put("addition", suppGoodsList);
	}
	
	/**
	 * 查询升级
	 * @param params
	 * @param branch
	 * @param goodsMap
	 */
	private void queryUpgrade(HashMap<String,Object> params,Long productId,BizBranch branch,HashMap<String,Object> goodsMap){
		params.clear();
		params.put("branchId", branch.getBranchId());
		params.put("productId", productId);
		List<ProdProductBranch> ppbList = prodProductBranchService.findProdProductBranchList(params);
		List<SuppGoods> suppGoodsList = new ArrayList<SuppGoods>();
		if(ppbList!=null && ppbList.size()>0){
			for(ProdProductBranch ppb : ppbList){
				List<SuppGoods> goodsList = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsByBranchId(ppb.getProductBranchId()));
				if(goodsList!=null && goodsList.size() == 1){
					SuppGoods goods = goodsList.get(0);
					suppGoodsList.add(goods);
				}else {
					throw new BusinessException("升级商品与产品规格不是一对一关系");
				}
			}
		}
		goodsMap.put("upgrad", suppGoodsList);
	}
	
	
	/**
	 * 查询可换
	 * @param params
	 * @param branch
	 * @param goodsMap
	 */
	private void queryChangeHotel(HashMap<String,Object> params,Long productId,BizBranch branch,HashMap<String,Object> goodsMap){
		params.clear();
		params.put("branchId", branch.getBranchId());
		params.put("productId", productId);
		List<ProdProductBranch> ppbList = prodProductBranchService.findProdProductBranchList(params);
		List<SuppGoods> suppGoodsList = new ArrayList<SuppGoods>();
		if(ppbList!=null && ppbList.size()>0){
			for(ProdProductBranch ppb : ppbList){
				//设置信息
				prodProductBranchService.findPropValueOfProdBranch(ppb, true, true);
				List<SuppGoods> goodsList = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsByBranchId(ppb.getProductBranchId()));
				if(goodsList!=null && goodsList.size() == 1){
					SuppGoods goods = goodsList.get(0);
					
					suppGoodsList.add(goods);
				}else {
					throw new BusinessException("可换酒店商品与产品规格不是一对一关系");
				}
			}
		}
		goodsMap.put("changed_hotel", suppGoodsList);
	}
	
	
	/**
	 * 保存时间价格表
	 */
	@RequestMapping(value = "/editGoodsTimePrice")
	@ResponseBody
	public Object editGoodsTimePrice(Model model, HttpServletRequest request,SuppGoodsLineVO suppGoodsLineVO,Long prodProductId,Long categoryId) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<saveGoodsTimePrice>");
		}
		String logStr ="";
		
		try {
			 logStr = getTimePriceChangeLog(suppGoodsLineVO,prodProductId);
		} catch (Exception e) {
			
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
            log.error(e.getMessage());
		}
		
		//更新时间价格
		suppGoodsLineTimePriceService.editSuppGoodsLineTimePrice(suppGoodsLineVO);

		//设置日志
		if(StringUtils.isNotBlank(logStr)){
			  try {
				  	Long suppGoodsId=null;
				  	if(suppGoodsLineVO.getTimePriceList()!=null && suppGoodsLineVO.getTimePriceList().size()>0){
				  		 suppGoodsId=suppGoodsLineVO.getTimePriceList().get(0).getSuppGoodsId();
				  	}
		            comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
		                    prodProductId, suppGoodsId, 
		                   this.getLoginUser().getUserName(),
		                    "修改时间价格表:"+logStr, 
		                    COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_TIME.name(), 
		                    "修改时间价格表",null);
		        } catch (Exception e) {
		            // TODO Auto-generated catch block
		            log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
		            log.error(e.getMessage());
		        }
			
		}
		
      
		return ResultMessage.SET_SUCCESS_RESULT;
	}

	//日志
	 private String getTimePriceChangeLog(SuppGoodsLineVO suppGoodsLineVO,Long prodProductId){
		 StringBuffer logStr = new StringBuffer("");
		 StringBuffer logStrNew = new StringBuffer("");
		 StringBuffer logStrUpdate = new StringBuffer("");
		 if(suppGoodsLineVO!=null && suppGoodsLineVO.getTimePriceList()!=null && suppGoodsLineVO.getTimePriceList().size()>0){
				// 计算两个日期之间的日期
				List<Date> dateList = CalendarUtils.getDates(suppGoodsLineVO.getStartDate(), suppGoodsLineVO.getEndDate(), suppGoodsLineVO.getWeekDay());
				for(SuppGoodsLineTimePrice slt : suppGoodsLineVO.getTimePriceList())
					{
					Map<String, Object> params = new HashMap<String, Object>();
					
					for (Date date : dateList) {
						params.clear();
						// 判断该条记录是否存在
						params.put("suppGoodsId", slt.getSuppGoodsId());
						params.put("specDate", date);
						SuppGoodsLineTimePrice oldSuppGoodsLineTimePrice = suppGoodsLineTimePriceService.selectByGoodsSpecDate(params);
						if(oldSuppGoodsLineTimePrice!=null){
						//更新	
							updateTimePriceLog(logStrUpdate,oldSuppGoodsLineTimePrice,slt,suppGoodsLineVO,prodProductId);
							logStr.append(logStrUpdate);
						}else {
						//新增	
							slt.setSpecDate(date);
							createTimePriceLog(logStrNew,slt,suppGoodsLineVO,prodProductId);
							logStr.append(logStrNew);
						}
					}
				}
		 }
		 return logStr.toString();
	}
	 
	 
	 private void createTimePriceLog(StringBuffer logsStr,SuppGoodsLineTimePrice suppGoodsLineTimePrice,SuppGoodsLineVO suppGoodsLineVO,Long prodProductId){
		 logsStr.delete(0,logsStr.length());
		 	SuppGoods goods =  MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoodsLineTimePrice.getSuppGoodsId()));

            /** 酒店套餐 **/
            if(goods.getCategoryId()==17L){
            	
                              	 SuppGoods suppGoods =  MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoodsLineTimePrice.getSuppGoodsId()));
                                   if(suppGoodsLineTimePrice.getAuditPrice()==null){
                                	   logsStr.append(getChangeLog(suppGoods.getGoodsName(),"禁售",null));
                                   }else{
                                	   logsStr.append(getChangeLog(suppGoods.getGoodsName(),"可售",null));
                                	   logsStr.append(getChangeLog("销售价",getInputPrice(suppGoodsLineTimePrice.getAuditPrice())+"",null));
                                	   logsStr.append(getChangeLog("结算价",getInputPrice(suppGoodsLineTimePrice.getAuditSettlementPrice())+"",null));
                                   }
                              
                      
            }else{
    			if(suppGoodsLineTimePrice.getAuditPrice()==null){
    				logsStr.append(getChangeLog("成人/儿童/房差（成人价）","禁售",null));
                }else{
                	logsStr.append(getChangeLog("成人/儿童/房差（成人价）","可售",null));
                	logsStr.append(getChangeLog("成人价",getInputPrice(suppGoodsLineVO.getTimePriceList().get(0).getAuditPrice())+"",null));
                	logsStr.append(getChangeLog("成人结算价",getInputPrice(suppGoodsLineVO.getTimePriceList().get(0).getAuditSettlementPrice())+"",null));
                }
    			
    			if(suppGoodsLineTimePrice.getChildPrice() == null){
    				logsStr.append(getChangeLog("成人/儿童/房差（儿童价）","禁售",null));
                }else{
                	logsStr.append(getChangeLog("成人/儿童/房差（儿童价）","可售",null));
                	logsStr.append(getChangeLog("儿童价",getInputPrice(suppGoodsLineVO.getTimePriceList().get(0).getChildPrice())+"",null));
                	logsStr.append(getChangeLog("儿童结算价",getInputPrice(suppGoodsLineVO.getTimePriceList().get(0).getChildSettlementPrice())+"",null));
                }
    			
    			if(suppGoodsLineTimePrice.getGapPrice()==null){
    				logsStr.append(getChangeLog("成人/儿童/房差（单房差）","禁售",null));
                }else{
                	logsStr.append(getChangeLog("成人/儿童/房差（单房差）","可售",null));
                	logsStr.append(getChangeLog("房差",getInputPrice(suppGoodsLineVO.getTimePriceList().get(0).getGapPrice())+"",null));
                	logsStr.append(getChangeLog("房差结算价",getInputPrice(suppGoodsLineVO.getTimePriceList().get(0).getGrapSettlementPrice())+"",null));
                }
	        }
            logsStr.append(getChangeLog("库存",suppGoodsLineTimePrice.getStock()+"",null));
            logsStr.append(getChangeLog("库存类型",SuppGoodsLineTimePrice.STOCKTYPE.getCnName(suppGoodsLineTimePrice.getStockType())+"",null));
            logsStr.append(getChangeLog("是否可超卖","Y".equalsIgnoreCase(suppGoodsLineTimePrice.getOversellFlag()) == true ? "可超卖":"不可超卖"+"",null));
            logsStr.append(getChangeLog("提前预定时间",formatMinutes(suppGoodsLineVO.getTimePriceList().get(0).getAheadBookTime())+"",null));
			
				if(logsStr.length()>0){
				
					logsStr.insert(0, "-日期"+suppGoodsLineTimePrice.getSpecDateStr());
					logsStr.insert(0,"商品名称"+goods.getGoodsName());
				
			}
				
			//预付预授权限制
			String limitType = suppGoodsLineTimePrice.getBookLimitType();
			limitType = SuppGoodsTimePrice.BOOKLIMITTYPE.getCnName(limitType);
			if(limitType != null){
				logsStr.append(ComLogUtil.getLogTxt("预付预授权限制", limitType, null));
			}
		}
		
		/**
		 * 更新时间价格
		 * @param oldSuppGoodsLineTimePrice
		 * @param suppGoodsLineTimePrice
		 */
		private void updateTimePriceLog(StringBuffer logsStr,SuppGoodsLineTimePrice oldSuppGoodsLineTimePrice,SuppGoodsLineTimePrice suppGoodsLineTimePrice,SuppGoodsLineVO suppGoodsLineVO,Long prodProductId){
			logsStr.delete(0,logsStr.length());
			SuppGoods goods =  MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoodsLineTimePrice.getSuppGoodsId()));
			
			if("Y".equalsIgnoreCase(suppGoodsLineVO.getIsSetPrice())){
			    /** 酒店套餐 **/
			    if(goods.getCategoryId()==17L){
			    	
                 	 SuppGoods suppGoods =  MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoodsLineTimePrice.getSuppGoodsId()));
                      if(suppGoodsLineTimePrice.getAuditPrice()==null){
                    	  logsStr.append(getChangeLog(suppGoods.getGoodsName(),"禁售",(oldSuppGoodsLineTimePrice.getAuditPrice()==null&&oldSuppGoodsLineTimePrice.getAuditSettlementPrice()==null)?"禁售":"可售"));
                      }else{
                    	  logsStr.append(getChangeLog(suppGoods.getGoodsName(),"可售",(oldSuppGoodsLineTimePrice.getAuditPrice()==null&&oldSuppGoodsLineTimePrice.getAuditSettlementPrice()==null)?"禁售":"可售"));
                    	  logsStr.append(getChangeLog("销售价",getInputPrice(suppGoodsLineTimePrice.getAuditPrice())+"",getInputPrice(oldSuppGoodsLineTimePrice.getAuditPrice())));
                    	  logsStr.append(getChangeLog("结算价",getInputPrice(suppGoodsLineTimePrice.getAuditSettlementPrice())+"",getInputPrice(oldSuppGoodsLineTimePrice.getAuditPrice())));
                      }
                      			       
			    }else{
			    
    				if(suppGoodsLineTimePrice.getAuditPrice()!=null){
    					logsStr.append(getChangeLog("成人/儿童/房差（成人价）","可售",(oldSuppGoodsLineTimePrice.getAuditPrice()==null&&oldSuppGoodsLineTimePrice.getAuditSettlementPrice()==null)?"禁售":"可售"));
    					logsStr.append(getChangeLog("成人价",getInputPrice(suppGoodsLineVO.getTimePriceList().get(0).getAuditPrice())+"",getInputPrice(oldSuppGoodsLineTimePrice.getAuditPrice())+""));
    					logsStr.append(getChangeLog("成人结算价",getInputPrice(suppGoodsLineVO.getTimePriceList().get(0).getAuditSettlementPrice())+"",getInputPrice(oldSuppGoodsLineTimePrice.getAuditSettlementPrice())+""));
    				
    				}else{
    					logsStr.append(getChangeLog("成人/儿童/房差（成人价）","禁售",(oldSuppGoodsLineTimePrice.getAuditPrice()==null&&oldSuppGoodsLineTimePrice.getAuditSettlementPrice()==null)?"禁售":"可售"));
    				    
    				}
    				if(suppGoodsLineTimePrice.getChildPrice()!=null){
    					logsStr.append(getChangeLog("成人/儿童/房差（儿童价）","可售",(oldSuppGoodsLineTimePrice.getChildPrice()==null&&oldSuppGoodsLineTimePrice.getChildSettlementPrice()==null)?"禁售":"可售"));
    					logsStr.append(getChangeLog("儿童价",getInputPrice(suppGoodsLineVO.getTimePriceList().get(0).getChildPrice())+"",getInputPrice(oldSuppGoodsLineTimePrice.getChildPrice())+""));
    					logsStr.append(getChangeLog("儿童结算价",getInputPrice(suppGoodsLineVO.getTimePriceList().get(0).getChildSettlementPrice())+"",getInputPrice(oldSuppGoodsLineTimePrice.getChildSettlementPrice())+""));
    				}else{
    					logsStr.append(getChangeLog("成人/儿童/房差（儿童价）","禁售",(oldSuppGoodsLineTimePrice.getChildPrice()==null&&oldSuppGoodsLineTimePrice.getChildSettlementPrice()==null)?"禁售":"可售"));
    				}
    				if(suppGoodsLineTimePrice.getGapPrice()!=null){
    					logsStr.append(getChangeLog("成人/儿童/房差（单房差）","可售",(oldSuppGoodsLineTimePrice.getGapPrice()==null&&oldSuppGoodsLineTimePrice.getGrapSettlementPrice()==null)?"禁售":"可售"));
    					logsStr.append(getChangeLog("房差",getInputPrice(suppGoodsLineVO.getTimePriceList().get(0).getGapPrice())+"",getInputPrice(oldSuppGoodsLineTimePrice.getGapPrice())+""));
    					logsStr.append(getChangeLog("房差结算价",getInputPrice(suppGoodsLineVO.getTimePriceList().get(0).getGrapSettlementPrice())+"",getInputPrice(oldSuppGoodsLineTimePrice.getGrapSettlementPrice())+""));
    				}else{
    					logsStr.append(getChangeLog("成人/儿童/房差（单房差）","禁售",(oldSuppGoodsLineTimePrice.getGapPrice()==null&&oldSuppGoodsLineTimePrice.getGrapSettlementPrice()==null)?"禁售":"可售"));
    				}
			    }
				
			}
			//判断是否需要设置库存
			if("Y".equalsIgnoreCase(suppGoodsLineVO.getIsSetStock())){
				if(suppGoodsLineTimePrice.getStock()!=null && !SuppGoodsLineTimePrice.STOCKTYPE.INQUIRE_NO_STOCK.name().equals(suppGoodsLineTimePrice.getStockType())){
					Long stock = suppGoodsLineTimePrice.getStock();;
					
					if(oldSuppGoodsLineTimePrice.getStockType() == null){
						oldSuppGoodsLineTimePrice.setStockType("");
					}
					//以前的共享库存要退
					if(!oldSuppGoodsLineTimePrice.getStockType().equalsIgnoreCase(suppGoodsLineTimePrice.getStockType())) {
						
						stock = suppGoodsLineTimePrice.getStock();
				}
					logsStr.append(getChangeLog("库存",stock + "",oldSuppGoodsLineTimePrice.getStock()+""));
					logsStr.append(getChangeLog("是否可超卖","Y".equalsIgnoreCase(suppGoodsLineTimePrice.getOversellFlag()) == true ? "可超卖":"不可超卖","Y".equalsIgnoreCase(oldSuppGoodsLineTimePrice.getOversellFlag()) == true ? "可超卖":"不可超卖"));	
				
				
			}
				logsStr.append(getChangeLog("库存类型",SuppGoodsLineTimePrice.STOCKTYPE.getCnName(suppGoodsLineTimePrice.getStockType())+"",SuppGoodsLineTimePrice.STOCKTYPE.getCnName(oldSuppGoodsLineTimePrice.getStockType())));
				
			}
			//判断是否需要设置提前预定时间
			if("Y".equalsIgnoreCase(suppGoodsLineVO.getIsSetAheadBookTime())){
				logsStr.append(getChangeLog("提前预定时间",formatMinutes(suppGoodsLineTimePrice.getAheadBookTime())+"",formatMinutes(oldSuppGoodsLineTimePrice.getAheadBookTime())+""));
			}
			
			if(logsStr.length()>0){
				
				logsStr.insert(0, "-日期"+oldSuppGoodsLineTimePrice.getSpecDateStr());
				logsStr.insert(0,"商品名称"+goods.getGoodsName());
				
			}
			
			//预付预授权限制
			String limitType = suppGoodsLineTimePrice.getBookLimitType();
			limitType = SuppGoodsTimePrice.BOOKLIMITTYPE.getCnName(limitType);
			String oldLimitType = oldSuppGoodsLineTimePrice.getBookLimitType();
			oldLimitType = SuppGoodsTimePrice.BOOKLIMITTYPE.getCnName(oldLimitType);
			if(limitType != null && oldLimitType != null && !limitType.equals(oldLimitType)){
				logsStr.append(ComLogUtil.getLogTxt("预付预授权限制", limitType, oldLimitType));
			}
		}
		
		
		private String getInputPrice(Long price){
			if(price!=null){
				
				return price/100.00d+"";
			}
			return "";
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
		
		
		public String getChangeLog(String columnName,String newStr,String oldStr){
			String temp = "";
			if(oldStr ==null && newStr == null){
				
				return temp;
				
			}else if(oldStr ==null ||newStr ==null ){
				temp =  ComLogUtil.getLogTxt(columnName,newStr,oldStr);
				return temp;
			}else{
				
				if( !oldStr.equals(newStr)){
					temp = ComLogUtil.getLogTxt(columnName,newStr,oldStr)+",";
					return temp;
				}
			}
			
			
			return "";
			
		}
		

	private static String formatMinutes(Long time){
		if(time !=null){
			long day = 0;
			long hour = 0;
			long minute = 0;
			String format = "%d天%d时%d分";
			if(time >0){
				day = (long)Math.ceil((double)time/1440);
				if(time%1440==0){
					hour = 0;
					minute = 0;
				}else {
					hour = (long)((1440 - time%1440)/60);
					minute = (long)((1440 - time%1440)%60);
				}
			} else if(time <0){
				time = -time;
				hour = (long)(time/60);
				minute = (long)(time%60);
			}
			return String.format(format, day,hour,minute);
		}
		return null;
	}
}
