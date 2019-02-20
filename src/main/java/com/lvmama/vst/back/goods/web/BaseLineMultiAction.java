package com.lvmama.vst.back.goods.web;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.ui.Model;

import com.lvmama.vst.back.biz.po.BizBranch;
import com.lvmama.vst.back.biz.service.BizBranchQueryService;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.client.biz.service.BranchClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.precontrol.service.ResPreControlService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.supp.service.SuppSupplierClientService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.goods.po.SuppGoods.PRICETYPE;
import com.lvmama.vst.back.goods.po.SuppGoodsLineTimePrice;
import com.lvmama.vst.back.goods.po.SuppGoodsTimePrice;
import com.lvmama.vst.back.goods.service.SuppGoodsFApiTimePriceService;
import com.lvmama.vst.supp.client.service.SuppGoodsLineTimePriceClientService;
import com.lvmama.vst.back.goods.service.SuppGoodsPresaleStampTimePriceService;
import com.lvmama.vst.back.prod.po.LineRouteDate;
import com.lvmama.vst.back.prod.po.ProdLineRoute;
import com.lvmama.vst.back.prod.po.ProdProductBranch;
import com.lvmama.vst.back.prod.po.ProdRefund;
import com.lvmama.vst.back.prod.service.LineRouteDateService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteClientService;
import com.lvmama.vst.back.prod.service.ProdProductBranchService;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.prod.service.ProdRefundService;
import com.lvmama.vst.back.client.prod.service.ProdVisaDocDateClientService;
import com.lvmama.vst.back.prod.vo.LineRouteDateVO;
import com.lvmama.vst.back.client.pub.service.ComPushClientService;
import com.lvmama.vst.back.client.supp.service.SuppContractClientService;
import com.lvmama.vst.back.supp.vo.SuppGoodsBaseTimePriceVo.CANCELSTRATEGYTYPE;
import com.lvmama.vst.comm.utils.CalendarUtils;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.DateUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;
import com.lvmama.vst.pet.goods.PetProdGoodsAdapter;
import com.lvmama.vst.back.utils.MiscUtils;

public class BaseLineMultiAction extends BaseActionSupport {

	protected static final long serialVersionUID = -6487667449047481545L;
	
	@Autowired
	protected ProdProductBranchService prodProductBranchService;
	@Autowired
	protected SuppGoodsLineTimePriceClientService suppGoodsLineTimePriceService;
	@Autowired
	protected SuppSupplierClientService suppSupplierService;
	@Autowired
	protected SuppGoodsClientService suppGoodsService;
	@Autowired
	protected ProdProductService prodProductService;
	@Autowired
	protected ComLogClientService comLogService;
	@Autowired
	protected PetProdGoodsAdapter petProdGoodsAdapter;
	@Autowired
	protected BizCategoryQueryService bizCategoryQueryService;
	@Autowired
	protected BizBranchQueryService branchQueryService;
	@Autowired
	protected ComPushClientService comPushService;
	@Autowired
	protected LineRouteDateService lineRouteDateService;
	@Autowired
	protected ProdLineRouteClientService prodLineRouteService;
    @Autowired
	protected ProdRefundService prodRefundService;
	@Autowired
	protected SuppContractClientService suppContractService;
	@Autowired
	protected PermUserServiceAdapter permUserServiceAdapter;
	@Autowired
	protected BranchClientService branchService;
	@Autowired
	protected ResPreControlService resControlBudgetRemote;
	@Autowired
	protected ProdVisaDocDateClientService prodVisaDocDateService;
	
	@Autowired
	
	protected SuppGoodsPresaleStampTimePriceService goodsPresaleStampTimePriceService;
	@Autowired
	protected ResPreControlService resPreControlService;
	
	@Autowired
	protected SuppGoodsFApiTimePriceService suppGoodsFApiTimePriceService;
	
	/**
	 * 根据线路品类获取对应的商品信息
	 * @param categoryCode　品类CODE
	 * @param categoryId 品类ID
	 * @param productId 产品ID
	 * @param goodsMap
	 */
	protected void getDataByCategoryCode(String categoryCode,Long categoryId,Long productId,HashMap<String,Object> goodsMap){
		HashMap<String,Object> params = new HashMap<String,Object>();
		//如果是跟团游和自由行
		if("category_route_group".equalsIgnoreCase(categoryCode) || "category_route_freedom".equalsIgnoreCase(categoryCode) || "category_route_customized".equalsIgnoreCase(categoryCode)){
			//查询规格
			List<BizBranch> branchList = branchQueryService.findBranchListByCategoryId(categoryId);
			for(BizBranch branch : branchList){
				//成人儿童
				if("adult_child_diff".equalsIgnoreCase(branch.getBranchCode())){
					//设置成人儿童房差
					queryAdultChildDiff(params,productId,branch,goodsMap);
				//附加	
				}else if("addition".equalsIgnoreCase(branch.getBranchCode())){
					queryAddition(params,productId,branch,goodsMap);
				//升级	
				}else if("upgrad".equalsIgnoreCase(branch.getBranchCode())){
					queryUpgrade(params,productId,branch,goodsMap);
				//可换	
				}else if("changed_hotel".equalsIgnoreCase(branch.getBranchCode())){
					queryChangeHotel(params,productId,branch,goodsMap);
				}
			}
			
		//如果是当地游
		}else if("category_route_local".equalsIgnoreCase(categoryCode)){
			//查询规格
			List<BizBranch> branchList = branchQueryService.findBranchListByCategoryId(categoryId);
			for(BizBranch branch : branchList){
				//成人儿童
				if("adult_child_diff".equalsIgnoreCase(branch.getBranchCode())){
					//设置成人儿童房差
					queryAdultChildDiff(params,productId,branch,goodsMap);
				//附加	
				}else if("addition".equalsIgnoreCase(branch.getBranchCode())){
					queryAddition(params,productId,branch,goodsMap);
				//升级	
				}
			}
		//如果是酒店套餐
		}else if("category_route_hotelcomb".equalsIgnoreCase(categoryCode)){
			//查询规格
			List<BizBranch> branchList = branchQueryService.findBranchListByCategoryId(categoryId);
			for(BizBranch branch : branchList){
				//套餐
				if("combo_dinner".equalsIgnoreCase(branch.getBranchCode())){
					//设置成人儿童房差
					queryCombDinner(params,productId,branch,goodsMap);
				//附加	
				}else if("addition".equalsIgnoreCase(branch.getBranchCode())){
					queryAddition(params,productId,branch,goodsMap);
				}
			}
		//新品类酒套餐
		}else if("category_route_new_hotelcomb".equalsIgnoreCase(categoryCode)){
			//查询规格
			List<BizBranch> branchList = branchQueryService.findBranchListByCategoryId(categoryId);
			for(BizBranch branch : branchList){
				//套餐
				if("product_branch".equalsIgnoreCase(branch.getBranchCode())){
					queryProductBranch(params,productId,branch,goodsMap);
				}
			}
		}
	}
	
	 /**
	 * 更新时间价格
	 * @param oldSuppGoodsLineTimePrice 
	 * @param suppGoodsLineTimePrice
	 * @param isLimitType "Y":记录强制预授权日志 
	 */
	protected void updateTimePriceLog(SuppGoods goods,StringBuffer logsStr,SuppGoodsLineTimePrice oldSuppGoodsLineTimePrice,SuppGoodsLineTimePrice suppGoodsLineTimePrice,LineRouteDateVO lineRouteDateVO,Long prodProductId,String isLimitType){
		if("Y".equalsIgnoreCase(lineRouteDateVO.getIsSetPrice())){
			logsStr.append("<br/>商品名称 :"+goods.getGoodsName());	
			logsStr.append("-日期:"+oldSuppGoodsLineTimePrice.getSpecDateStr());	
			String priceType = goods.getPriceType();
		    /** 酒店套餐 **/
		    if(goods.getCategoryId()==17L || goods.getCategoryId()==32L){
         	  SuppGoods suppGoods =  MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoodsLineTimePrice.getSuppGoodsId()));
              if(!"Y".equals(suppGoodsLineTimePrice.getOnsaleFlag())){
            	  logsStr.append(getChangeLog(suppGoods.getGoodsName(),"禁售",!"Y".equals(oldSuppGoodsLineTimePrice.getOnsaleFlag())?"禁售":"可售"));
              }else{
            	  logsStr.append(getChangeLog(suppGoods.getGoodsName(),"可售",((oldSuppGoodsLineTimePrice.getAuditPrice()==null&&oldSuppGoodsLineTimePrice.getAuditSettlementPrice()==null)||!"Y".equals(oldSuppGoodsLineTimePrice.getOnsaleFlag()))?"禁售":"可售"));
            	  logsStr.append(getChangeLog("销售价",getInputPrice(suppGoodsLineTimePrice.getAuditPrice())+"",getInputPrice(oldSuppGoodsLineTimePrice.getAuditPrice())));
            	  logsStr.append(getChangeLog("结算价",getInputPrice(suppGoodsLineTimePrice.getAuditSettlementPrice())+"",getInputPrice(oldSuppGoodsLineTimePrice.getAuditSettlementPrice())));
              }
		    }else{
				if(suppGoodsLineTimePrice.getAuditPrice()!=null){
					if(PRICETYPE.MULTIPLE_PRICE.getCode().equals(priceType)){
						logsStr.append(getChangeLog("成人/儿童/房差（成人价）","可售",(oldSuppGoodsLineTimePrice.getAuditPrice()==null&&oldSuppGoodsLineTimePrice.getAuditSettlementPrice()==null)?"禁售":"可售"));
					}
					logsStr.append(getChangeLog("成人价",getInputPrice(suppGoodsLineTimePrice.getAuditPrice())+"",getInputPrice(oldSuppGoodsLineTimePrice.getAuditPrice())+""));
					logsStr.append(getChangeLog("成人结算价",getInputPrice(suppGoodsLineTimePrice.getAuditSettlementPrice())+"",getInputPrice(oldSuppGoodsLineTimePrice.getAuditSettlementPrice())+""));
				
				}else{
					if(PRICETYPE.MULTIPLE_PRICE.getCode().equals(priceType)){
						logsStr.append(getChangeLog("成人/儿童/房差（成人价）","禁售",(oldSuppGoodsLineTimePrice.getAuditPrice()==null&&oldSuppGoodsLineTimePrice.getAuditSettlementPrice()==null)?"禁售":"可售"));
					}
				}
				if(suppGoodsLineTimePrice.getChildPrice()!=null){
					if(PRICETYPE.MULTIPLE_PRICE.getCode().equals(priceType)){
						logsStr.append(getChangeLog("成人/儿童/房差（儿童价）","可售",(oldSuppGoodsLineTimePrice.getChildPrice()==null&&oldSuppGoodsLineTimePrice.getChildSettlementPrice()==null)?"禁售":"可售"));
					}
					logsStr.append(getChangeLog("儿童价",getInputPrice(suppGoodsLineTimePrice.getChildPrice())+"",getInputPrice(oldSuppGoodsLineTimePrice.getChildPrice())+""));
					logsStr.append(getChangeLog("儿童结算价",getInputPrice(suppGoodsLineTimePrice.getChildSettlementPrice())+"",getInputPrice(oldSuppGoodsLineTimePrice.getChildSettlementPrice())+""));
				}else{
					if(PRICETYPE.MULTIPLE_PRICE.getCode().equals(priceType))
						logsStr.append(getChangeLog("成人/儿童/房差（儿童价）","禁售",(oldSuppGoodsLineTimePrice.getChildPrice()==null&&oldSuppGoodsLineTimePrice.getChildSettlementPrice()==null)?"禁售":"可售"));
				}
				if(suppGoodsLineTimePrice.getGapPrice()!=null){
					if(PRICETYPE.MULTIPLE_PRICE.getCode().equals(priceType)){
						logsStr.append(getChangeLog("成人/儿童/房差（单房差）","可售",(oldSuppGoodsLineTimePrice.getGapPrice()==null&&oldSuppGoodsLineTimePrice.getGrapSettlementPrice()==null)?"禁售":"可售"));
					}
					logsStr.append(getChangeLog("房差",getInputPrice(suppGoodsLineTimePrice.getGapPrice())+"",getInputPrice(oldSuppGoodsLineTimePrice.getGapPrice())+""));
					logsStr.append(getChangeLog("房差结算价",getInputPrice(suppGoodsLineTimePrice.getGrapSettlementPrice())+"",getInputPrice(oldSuppGoodsLineTimePrice.getGrapSettlementPrice())+""));
				}else{
					if(PRICETYPE.MULTIPLE_PRICE.getCode().equals(priceType)){
						logsStr.append(getChangeLog("成人/儿童/房差（单房差）","禁售",(oldSuppGoodsLineTimePrice.getGapPrice()==null&&oldSuppGoodsLineTimePrice.getGrapSettlementPrice()==null)?"禁售":"可售"));
					}
				}
		    }
		}
		//判断是否需要设置库存
		if("Y".equalsIgnoreCase(lineRouteDateVO.getIsSetStock())){
			if(suppGoodsLineTimePrice.getStock()!=null && !SuppGoodsLineTimePrice.STOCKTYPE.INQUIRE_NO_STOCK.name().equals(suppGoodsLineTimePrice.getStockType())){
				Long stock = suppGoodsLineTimePrice.getStock();;
				if(oldSuppGoodsLineTimePrice.getStockType() == null){
					oldSuppGoodsLineTimePrice.setStockType("");
				}
				//以前的共享库存要退
				if(!oldSuppGoodsLineTimePrice.getStockType().equalsIgnoreCase(suppGoodsLineTimePrice.getStockType())) {
					stock = suppGoodsLineTimePrice.getStock();
				}
				String stockString = getChangeLog("库存",stock + "",oldSuppGoodsLineTimePrice.getStock()+"");
				if(stockString!=null && stockString!=""){
					stockString = goods.getGoodsName()+"["+oldSuppGoodsLineTimePrice.getSpecDateStr()+"]"+stockString;
				}
				logsStr.append(stockString);
				
				String overstockString = getChangeLog("是否可超卖","Y".equalsIgnoreCase(suppGoodsLineTimePrice.getOversellFlag()) == true ? "可超卖":"不可超卖","Y".equalsIgnoreCase(oldSuppGoodsLineTimePrice.getOversellFlag()) == true ? "可超卖":"不可超卖");
				if(overstockString!=null && overstockString!=""){
					overstockString = goods.getGoodsName()+"["+oldSuppGoodsLineTimePrice.getSpecDateStr()+"]"+overstockString;
				}
				
				logsStr.append(overstockString);	
			}
			String stockTypeStr = getChangeLog("库存类型",SuppGoodsLineTimePrice.STOCKTYPE.getCnName(suppGoodsLineTimePrice.getStockType())+"",SuppGoodsLineTimePrice.STOCKTYPE.getCnName(oldSuppGoodsLineTimePrice.getStockType()));
			if(stockTypeStr!=null && stockTypeStr!=""){
				stockTypeStr = goods.getGoodsName()+"["+oldSuppGoodsLineTimePrice.getSpecDateStr()+"]"+stockTypeStr;
			}
			
			
			logsStr.append(stockTypeStr);
		}
		//判断是否需要设置提前预定时间
		if("Y".equalsIgnoreCase(lineRouteDateVO.getIsSetAheadBookTime())){
			
			String aheadStr = getChangeLog("提前预定时间",formatMinutes(suppGoodsLineTimePrice.getAheadBookTime())+"",formatMinutes(oldSuppGoodsLineTimePrice.getAheadBookTime())+"");
			if(aheadStr!=null && aheadStr!=""){
				aheadStr = goods.getGoodsName()+"["+oldSuppGoodsLineTimePrice.getSpecDateStr()+"]"+aheadStr;
			}
			
			logsStr.append(aheadStr);
		}
		
		//预付预授权限制
		if("Y".equals(isLimitType)){
			String limitType = suppGoodsLineTimePrice.getBookLimitType();
			limitType = SuppGoodsTimePrice.BOOKLIMITTYPE.getCnName(limitType);
			String oldLimitType = oldSuppGoodsLineTimePrice.getBookLimitType();
			oldLimitType = SuppGoodsTimePrice.BOOKLIMITTYPE.getCnName(oldLimitType);
			if(limitType != null && oldLimitType != null && !limitType.equals(oldLimitType)){
				logsStr.append(ComLogUtil.getLogTxt("预付预授权限制", limitType, oldLimitType));
			}
		}
	}

	protected void createTimePriceLog(SuppGoods goods, StringBuffer logsStr,SuppGoodsLineTimePrice suppGoodsLineTimePrice,LineRouteDateVO lineRouteDateVO,Long prodProductId){
		logsStr.append("<br/>商品名称:"+goods.getGoodsName());
		/** 酒店套餐 **/
      if(goods.getCategoryId()==17L || goods.getCategoryId()==32L){
   	     SuppGoods suppGoods =  MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoodsLineTimePrice.getSuppGoodsId()));
         if(!"Y".equals(suppGoodsLineTimePrice.getOnsaleFlag())){
      	   logsStr.append(getChangeLog(suppGoods.getGoodsName(),"禁售",null));
         }else{
      	   logsStr.append(getChangeLog(suppGoods.getGoodsName(),"可售",null));
      	   logsStr.append(getChangeLog("销售价",getInputPrice(suppGoodsLineTimePrice.getAuditPrice())+"",null));
      	   logsStr.append(getChangeLog("结算价",getInputPrice(suppGoodsLineTimePrice.getAuditSettlementPrice())+"",null));
         }
      }else{
//    	  String priceType = goods.getPriceType();
    	  if(suppGoodsLineTimePrice.getAuditPrice()==null){
//    		  if(PRICETYPE.MULTIPLE_PRICE.getCode().equals(priceType)){
    			  logsStr.append(getChangeLog("成人/儿童/房差（成人价）","禁售",null));
//    		  }
          }else{
//        	  if(PRICETYPE.MULTIPLE_PRICE.getCode().equals(priceType)){
        		  logsStr.append(getChangeLog("成人/儿童/房差（成人价）","可售",null));
//        	  }
          	logsStr.append(getChangeLog("成人价",getInputPrice(suppGoodsLineTimePrice.getAuditPrice())+"",null));
          	logsStr.append(getChangeLog("成人结算价",getInputPrice(suppGoodsLineTimePrice.getAuditSettlementPrice())+"",null));
          }
		
    	  if(suppGoodsLineTimePrice.getChildPrice() == null){
//    		  if(PRICETYPE.MULTIPLE_PRICE.getCode().equals(priceType)){
    			  logsStr.append(getChangeLog("成人/儿童/房差（儿童价）","禁售",null));
//    		  }
          }else{
//        	  if(PRICETYPE.MULTIPLE_PRICE.getCode().equals(priceType)){
        		  logsStr.append(getChangeLog("成人/儿童/房差（儿童价）","可售",null));
//        	  }
          	logsStr.append(getChangeLog("儿童价",getInputPrice(suppGoodsLineTimePrice.getChildPrice())+"",null));
          	logsStr.append(getChangeLog("儿童结算价",getInputPrice(suppGoodsLineTimePrice.getChildSettlementPrice())+"",null));
          }
		
    	  if(suppGoodsLineTimePrice.getGapPrice()==null){
//    		  if(PRICETYPE.MULTIPLE_PRICE.getCode().equals(priceType)){
    			  logsStr.append(getChangeLog("成人/儿童/房差（单房差）","禁售",null));
//    		  }
          }else{
//        	  if(PRICETYPE.MULTIPLE_PRICE.getCode().equals(priceType)){
        		  logsStr.append(getChangeLog("成人/儿童/房差（单房差）","可售",null));
//        	  }
          	logsStr.append(getChangeLog("房差",getInputPrice(suppGoodsLineTimePrice.getGapPrice())+"",null));
          	logsStr.append(getChangeLog("房差结算价",getInputPrice(suppGoodsLineTimePrice.getGrapSettlementPrice())+"",null));
          }
       }

	      logsStr.append(getChangeLog("库存",suppGoodsLineTimePrice.getStock()+"",null));
	      logsStr.append(getChangeLog("库存类型",SuppGoodsLineTimePrice.STOCKTYPE.getCnName(suppGoodsLineTimePrice.getStockType())+"",null));
	      logsStr.append(getChangeLog("是否可超卖","Y".equalsIgnoreCase(suppGoodsLineTimePrice.getOversellFlag()) == true ? "可超卖":"不可超卖"+"",null));
	      logsStr.append(getChangeLog("提前预定时间",formatMinutes(suppGoodsLineTimePrice.getAheadBookTime())+"",null));
			
		//预付预授权限制
		String limitType = suppGoodsLineTimePrice.getBookLimitType();
		limitType = SuppGoodsTimePrice.BOOKLIMITTYPE.getCnName(limitType);
		if(limitType != null){
			logsStr.append(ComLogUtil.getLogTxt("预付预授权限制", limitType, null));
		}
	}
	
	/**
	 * 查询套餐
	 * @param params
	 * @param branch
	 * @param goodsMap
	 */
	protected void queryProductBranch(HashMap<String,Object> params,Long productId,BizBranch branch,HashMap<String,Object> goodsMap){
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
			goodsMap.put("product_branch", goodsList);
		}else {
			throw new BusinessException("请设置套餐规格");
		}
	}
	
	/**
	 * 查询套餐
	 * @param params
	 * @param branch
	 * @param goodsMap
	 */
	protected void queryCombDinner(HashMap<String,Object> params,Long productId,BizBranch branch,HashMap<String,Object> goodsMap){
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
	protected void queryAddition(HashMap<String,Object> params,Long productId,BizBranch branch,HashMap<String,Object> goodsMap){
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
	protected void queryUpgrade(HashMap<String,Object> params,Long productId,BizBranch branch,HashMap<String,Object> goodsMap){
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
	protected void queryChangeHotel(HashMap<String,Object> params,Long productId,BizBranch branch,HashMap<String,Object> goodsMap){
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
	  * 记录时间价格表操作日志
	  * @param lineRouteDateVO 线路多行程
	  * @param prodProductId 产品ID
	  * @param isExistsSuppGoodsTime true:不存在商品时间价格表时不需要记录日志 
	  * @param isProdRefund 是否需要记录退改规则日志 true:需要 
	  * @param isTraffic 是否交通
	  * @return
	  */
	 protected String getTimePriceChangeLog(LineRouteDateVO lineRouteDateVO,Long prodProductId,boolean isExistsSuppGoodsTime,boolean isProdRefund,boolean isTraffic){
		 StringBuffer logStr = new StringBuffer("");
		 StringBuffer logStrNew = new StringBuffer("");
		 SimpleDateFormat simple = new SimpleDateFormat("yyyy-MM-dd");
		 if(lineRouteDateVO!=null && lineRouteDateVO.getTimePriceList()!=null && lineRouteDateVO.getTimePriceList().size()>0){
				// 计算两个日期之间的日期
				List<Date> dateList = getSuppGoodSelectDate(lineRouteDateVO.getStartDate(), lineRouteDateVO.getEndDate(), lineRouteDateVO.getWeekDay(), 
						lineRouteDateVO.getSelectDates(),lineRouteDateVO.getSelectCalendar());
				Map<Long,SuppGoodsLineTimePrice> addMap = new HashMap<Long, SuppGoodsLineTimePrice>();
				Map<Date,String> addDate = new HashMap<Date, String>();
				if(null==dateList || dateList.isEmpty()){
					return "";
				}
				for(SuppGoodsLineTimePrice slt : lineRouteDateVO.getTimePriceList())
				{
					SuppGoods goods =  MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(slt.getSuppGoodsId()));
					if(null==goods){
						return "";
					}
					StringBuffer logStrUpdate = new StringBuffer("");
					Map<String, Object> params = new HashMap<String, Object>();
					for (Date date : dateList) {
						params.clear();
						// 判断该条记录是否存在
						params.put("suppGoodsId", slt.getSuppGoodsId());
						params.put("specDate", date);
						SuppGoodsLineTimePrice oldSuppGoodsLineTimePrice = suppGoodsLineTimePriceService.selectByGoodsSpecDate(params);
						if(oldSuppGoodsLineTimePrice!=null){
							String isLimitType = "Y";
							//更新
							updateTimePriceLog(goods,logStrUpdate,oldSuppGoodsLineTimePrice,slt,lineRouteDateVO,prodProductId,isLimitType);
							logStr.append(logStrUpdate);
							logStrUpdate = new StringBuffer("");
						}else {
							if(isExistsSuppGoodsTime){
								continue;
							}
							//新增	
							slt.setSpecDate(date);
							addMap.put(slt.getSuppGoodsId(), slt);
							addDate.put(date, simple.format(date));
						}
					}
				}
				if(null!=addMap && !addMap.isEmpty()){
					SuppGoods suppGoods = null;
					logStrNew.append("<br/>开始新增商品:").append("日期");
					for(Map.Entry<Date, String> aDate: addDate.entrySet()) {
						logStrNew.append(aDate.getValue()+"、");
					}
					for(Map.Entry<Long, SuppGoodsLineTimePrice> entry: addMap.entrySet()) {
						SuppGoods goods =  MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(entry.getKey()));
						if(!isTraffic){
							createTimePriceLog(goods, logStrNew, entry.getValue(),lineRouteDateVO,prodProductId);
						}
						suppGoods = goods;
					}
					if(isTraffic){
						createTimePriceLog(suppGoods, logStrNew, addMap.get(0),lineRouteDateVO,prodProductId);
					}
					logStrNew.append("结束新增商品:<br/>");
					logStr.append(logStrNew);
				}
				
				for (Date date : dateList) {
					HashMap<String, Object> searchRefund = new HashMap<String, Object>();
					if(isProdRefund){
						searchRefund.put("productId", prodProductId);
						searchRefund.put("specDate", date);
						ProdRefund oldProdRefund = null;
						// 退改规则
						List<ProdRefund> list =  prodRefundService.selectByParams(searchRefund);
						if(list!=null && list.size()>0){
							oldProdRefund = list.get(0);
						}							
						ProdRefund prodRefund = new ProdRefund();
						prodRefund.setProductId(prodProductId);
						prodRefund.setSpecDate(date);
						prodRefund.setCancelStrategy(lineRouteDateVO.getCancelStrategy());
						prodRefund.setProdRefundRules(lineRouteDateVO.getProdRefundRules());
						saveOrUpdateProdRefundLog(logStr,prodRefund,oldProdRefund);
						// 产品适用行程日志
						logStr.append(getUpdateLineRouteDateLog(lineRouteDateVO.getLineRouteId(),prodProductId,date));
					}
				}
		 }
		 
		 String ss = logStr.toString();
		 if(null !=StringUtils.trimToNull(ss)){
			 String douStr = ss.substring(ss.length()-1, ss.length());
			 if(",".equals(douStr)){
				 ss = ss.substring(0,ss.length() - 1);
			 }
		 }
		 
		 return ss;
	}
	 
	 /**
	 * 查询成人儿童房差
	 * @param params
	 * @param branch
	 * @param goodsMap
	 */
	protected void queryAdultChildDiff(HashMap<String,Object> params,Long productId,BizBranch branch,HashMap<String,Object> goodsMap){
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
		}else{
			throw new BusinessException("成人/儿童/房差产品规格不唯一");
		}
	}
	
	protected String formatMinutes(Long time){
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
	
	protected String getChangeLog(String columnName,String newStr,String oldStr){
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
	
	protected String getInputPrice(Long price){
		if(price!=null){
			return price/100.00d+"";
		}
		return "";
	}
	
    protected String getProdRefundLog(ProdRefund prodRefund){
    	StringBuffer logStr = new StringBuffer();
        if(prodRefund == null){
            return null;
        }
        if(prodRefund.getProductId() == null){
			throw new BusinessException("产品ID不能为空");
		}
		
		// 选择的时间
		if(null==prodRefund.getSpecDates()){
			if(prodRefund.getStartDate()==null || prodRefund.getEndDate()==null){
				throw new BusinessException("起始日期不能为空");
			}
		}
		
		List<Date> dateList = new ArrayList<Date>();
		if(prodRefund.getSpecDates()!=null){
			for (String specDate : prodRefund.getSpecDates()) {
				SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
				Date date;
				try {
					date = df.parse(specDate);
					dateList.add(date);
				} catch (ParseException e) {
					throw new BusinessException("日期格式错误");
				}
			}
		}else{
			dateList = CalendarUtils.getDates(prodRefund.getStartDate(), prodRefund.getEndDate(), prodRefund.getWeekDay());
		}

		for (Date date : dateList) {
			//判断有没有
			HashMap<String,Object> params = new HashMap<String,Object>();
			params.put("productId", prodRefund.getProductId());
			params.put("specDate", date);
			List<ProdRefund> list =  prodRefundService.selectByParams(params);
			if(list!=null && list.size()>0){
				ProdRefund oldProdRefund = list.get(0);
				logStr.append("日期:"+DateUtil.formatDate(date, "yyyy-MM-dd")).append(getChangeLog("退改类型:", ("MANUALCHANGE".equals(prodRefund.getCancelStrategy())?"人工退改":"不退不改"), ("MANUALCHANGE".equals(oldProdRefund.getCancelStrategy())?"人工退改":"不退不改")));
			}else {
				logStr.append("日期:"+DateUtil.formatDate(date, "yyyy-MM-dd")).append(getChangeLog("退改类型:", ("MANUALCHANGE".equals(prodRefund.getCancelStrategy())?"人工退改":"不退不改"), null));
			}
 		}
		
		if(logStr.length()<=0){
			logStr.delete(0, logStr.length());
		}
		
		return logStr.toString();
    }
    
    protected List<String> getChineseWeekDays(List<Integer> weekDays){
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
    
    protected List<String> seach(List<Integer> weekDays){
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
    
    /**
     * 检索行程天数列表
     * @param productId 产品ID
     */
    protected void searchProdLineRoute(Long productId,Model model){
		Map<String,Object> prodLineRoutesParams = new HashMap<String, Object>();
		prodLineRoutesParams.put("productId", productId);
		prodLineRoutesParams.put("cancleFlag", "Y");
		List<ProdLineRoute> prodLineRoutes = prodLineRouteService.findProdLineRouteByParams(prodLineRoutesParams);
		model.addAttribute("prodLineRoutes", prodLineRoutes);
    }
    
    /**
     */
    protected boolean isExis(Date str,Map<Date,Date> valueMap){
    	if(valueMap.containsKey(str)){
    		return true;
    	}else{
    		valueMap.put(str, str);
    		return false;
    	}
    }
    
	/**
	 * 根据选择日期的方式得到时间集合
	 * @param startDate 开始日期
	 * @param endDate 结束日期
	 * @param weekDay 适用日期
	 * @param selectDates 选择的日期
	 * @param selectCalendar 选择时间的方式
	 * @return
	 * @throws Exception 
	 */
	public List<Date> getSuppGoodSelectDate(Date startDate,Date endDate,List<Integer> weekDay,List<String> selectDates,String selectCalendar){
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
	
	 /**
	 * 更新或新增退改规则
	 * @param oldProdRefund
	 * @param prodRefund
	 */
	protected void saveOrUpdateProdRefundLog(StringBuffer logsStr,ProdRefund prodRefund,ProdRefund oldProdRefund){
		if(null==oldProdRefund){
			logsStr.append(getChangeLog("退改规则"+"-日期"+prodRefund.getSpecDateStr(),CANCELSTRATEGYTYPE.getCnName(prodRefund.getCancelStrategy()),null));
		}else{
			logsStr.append(getChangeLog("退改规则"+"-日期"+prodRefund.getSpecDateStr(),CANCELSTRATEGYTYPE.getCnName(prodRefund.getCancelStrategy()),CANCELSTRATEGYTYPE.getCnName(oldProdRefund.getCancelStrategy())));
		}
		if(ProdRefund.CANCELSTRATEGYTYPE.RETREATANDCHANGE.getCode().equals(prodRefund.getCancelStrategy())){			
			logsStr.append(getChangeLog("阶梯退改规则"+"-日期"+prodRefund.getSpecDateStr(),prodRefund.getRefundRuleLog(),oldProdRefund.getRefundRuleLog()));			
		}
	}
    
    /**
	 * 更新时间价格禁售记录日志
	 */
	protected void updateLineMultiRouteLockUpLog(StringBuffer logsStr,LineRouteDateVO lineRouteDateVO){
		logsStr.delete(0,logsStr.length());
		if(lineRouteDateVO!=null && lineRouteDateVO.getTimePriceList()!=null && lineRouteDateVO.getTimePriceList().size()>0){
			// 计算两个日期之间的日期
			List<Date> dateList = getSuppGoodSelectDate(lineRouteDateVO.getStartDate(), lineRouteDateVO.getEndDate(), lineRouteDateVO.getWeekDay(), 
					lineRouteDateVO.getSelectDates(),lineRouteDateVO.getSelectCalendar());
			for(SuppGoodsLineTimePrice slt : lineRouteDateVO.getTimePriceList())
				{
				Map<String, Object> params = new HashMap<String, Object>();
				for (Date date : dateList) {
					params.clear();
					// 判断该条记录是否存在
					params.put("suppGoodsId", slt.getSuppGoodsId());
					params.put("specDate", date);
					SuppGoodsLineTimePrice oldSuppGoodsLineTimePrice = suppGoodsLineTimePriceService.selectByGoodsSpecDate(params);
					if(oldSuppGoodsLineTimePrice!=null){
						String onsaleFlag = slt.getOnsaleFlag();
						if(StringUtil.isNotEmptyString(onsaleFlag) && "Y".equalsIgnoreCase(onsaleFlag)){
							if("Y".equalsIgnoreCase(lineRouteDateVO.getIsSetPrice())){
						        Long auditSettlementPrice = slt.getAuditSettlementPrice();
						        Long auditPrice=slt.getAuditPrice();
						        Long childSettlementPrice=slt.getChildSettlementPrice();
						        Long childPrice=slt.getChildPrice();
						        Long grapSettlementPrice=slt.getGrapSettlementPrice();
						        Long gapPrice=slt.getGapPrice();						        
								SuppGoods suppGoods =  MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(slt.getSuppGoodsId()));
								if(null==suppGoods){
									return;
								}
								String priceType = suppGoods.getPriceType();
							    /** 酒店套餐 **/
							    if(suppGoods.getCategoryId()==17L || suppGoods.getCategoryId()==32L){
					              if(null!=auditPrice && null!=auditSettlementPrice && auditPrice==0 && auditSettlementPrice==0){
					            	  logsStr.append(getChangeLog(suppGoods.getGoodsName()+"-日期"+oldSuppGoodsLineTimePrice.getSpecDateStr(),"禁售","可售"));
					              }
							    }else{
						    	    logsStr.append("<br/>商品名称:"+suppGoods.getGoodsName());
								    logsStr.append("-日期:"+oldSuppGoodsLineTimePrice.getSpecDateStr());		
									if(null!=auditPrice && null!=auditSettlementPrice && auditPrice==0 && auditSettlementPrice==0){
										if(PRICETYPE.MULTIPLE_PRICE.getCode().equals(priceType)){
											logsStr.append(getChangeLog("成人/儿童/房差（成人价）"+"-日期"+oldSuppGoodsLineTimePrice.getSpecDateStr(),"可售",(oldSuppGoodsLineTimePrice.getAuditPrice()==0&&oldSuppGoodsLineTimePrice.getAuditSettlementPrice()==0)?"禁售":"可售"));
										}
										logsStr.append(getChangeLog("成人价"+"-日期"+oldSuppGoodsLineTimePrice.getSpecDateStr(),"禁售",getInputPrice(oldSuppGoodsLineTimePrice.getAuditPrice())+""));
										logsStr.append(getChangeLog("成人结算价"+"-日期"+oldSuppGoodsLineTimePrice.getSpecDateStr(),"禁售",getInputPrice(oldSuppGoodsLineTimePrice.getAuditSettlementPrice())+""));
									}
									if(null!=childPrice && null!=childSettlementPrice && childPrice==0 && childSettlementPrice==0){
										if(PRICETYPE.MULTIPLE_PRICE.getCode().equals(priceType)){
											logsStr.append(getChangeLog("成人/儿童/房差（儿童价）"+"-日期"+oldSuppGoodsLineTimePrice.getSpecDateStr(),"可售",(oldSuppGoodsLineTimePrice.getChildPrice()==0&&oldSuppGoodsLineTimePrice.getChildSettlementPrice()==0)?"禁售":"可售"));
										}
										logsStr.append(getChangeLog("儿童价"+"-日期"+oldSuppGoodsLineTimePrice.getSpecDateStr(),"禁售",getInputPrice(oldSuppGoodsLineTimePrice.getChildPrice())+""));
										logsStr.append(getChangeLog("儿童结算价"+"-日期"+oldSuppGoodsLineTimePrice.getSpecDateStr(),"禁售",getInputPrice(oldSuppGoodsLineTimePrice.getChildSettlementPrice())+""));
									}
									if(null!=gapPrice && null!=grapSettlementPrice && grapSettlementPrice==0 && grapSettlementPrice==0){
										if(PRICETYPE.MULTIPLE_PRICE.getCode().equals(priceType)){
											logsStr.append(getChangeLog("成人/儿童/房差（单房差）"+"-日期"+oldSuppGoodsLineTimePrice.getSpecDateStr(),"可售",(oldSuppGoodsLineTimePrice.getGapPrice()==0&&oldSuppGoodsLineTimePrice.getGrapSettlementPrice()==0)?"禁售":"可售"));
										}
										logsStr.append(getChangeLog("房差"+"-日期"+oldSuppGoodsLineTimePrice.getSpecDateStr(),"禁售",getInputPrice(oldSuppGoodsLineTimePrice.getGapPrice())+""));
										logsStr.append(getChangeLog("房差结算价"+"-日期"+oldSuppGoodsLineTimePrice.getSpecDateStr(),"禁售",getInputPrice(oldSuppGoodsLineTimePrice.getGrapSettlementPrice())+""));
									}
							    }
							}							
						}
					}
				}
			}
		}
	}
	
	
 	/**
	 * 更新时间价格销售价与结算价记录日志
	 */
	protected void updateLineMultiRoutePriceLog(StringBuffer logsStr,LineRouteDateVO lineRouteDateVO){
		logsStr.delete(0,logsStr.length());
		if(lineRouteDateVO!=null && lineRouteDateVO.getTimePriceList()!=null && lineRouteDateVO.getTimePriceList().size()>0){
			// 计算两个日期之间的日期
			List<Date> dateList = getSuppGoodSelectDate(lineRouteDateVO.getStartDate(), lineRouteDateVO.getEndDate(), lineRouteDateVO.getWeekDay(), 
					lineRouteDateVO.getSelectDates(),lineRouteDateVO.getSelectCalendar());
			for(SuppGoodsLineTimePrice slt : lineRouteDateVO.getTimePriceList())
			{
				SuppGoods suppGoods =  MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(slt.getSuppGoodsId()));
				if(null==suppGoods){
					return;
				}				
				logsStr.append("<br/>"+suppGoods.getGoodsName());
				Map<String, Object> params = new HashMap<String, Object>();
				for (Date date : dateList) {
					params.clear();
					// 判断该条记录是否存在
					params.put("suppGoodsId", slt.getSuppGoodsId());
					params.put("specDate", date);
					SuppGoodsLineTimePrice oldDto = suppGoodsLineTimePriceService.selectByGoodsSpecDate(params);
					if(oldDto!=null){
						StringBuffer updateStr = new StringBuffer();
				        slt.calculatePrice(oldDto.getAuditSettlementPrice(),oldDto.getAuditPrice(),
								oldDto.getChildSettlementPrice(),oldDto.getChildPrice(),oldDto.getGrapSettlementPrice(),oldDto.getGapPrice());
					    /** 酒店套餐 **/
					    if(suppGoods.getCategoryId()==17L || suppGoods.getCategoryId()==32L){
							if(null!=slt.getAuditPrice()){
								updateStr.append(getChangeLog("销售价"+"-日期"+oldDto.getSpecDateStr(),getInputPrice(slt.getAuditPrice())+"",getInputPrice(oldDto.getAuditPrice())+""));
							}
							if(null!=slt.getAuditSettlementPrice()){
								updateStr.append(getChangeLog("结算价"+"-日期"+oldDto.getSpecDateStr(),getInputPrice(slt.getAuditSettlementPrice())+"",getInputPrice(oldDto.getAuditSettlementPrice())+""));
							}							
					    }else{
					    	System.out.println(slt.getAuditPrice());
							if(null!=slt.getAuditPrice()){
								updateStr.append(getChangeLog("成人销售价"+"-日期"+oldDto.getSpecDateStr(),getInputPrice(slt.getAuditPrice())+"",getInputPrice(oldDto.getAuditPrice())+""));
							}
							if(null!=slt.getAuditSettlementPrice()){
								updateStr.append(getChangeLog("成人结算价"+"-日期"+oldDto.getSpecDateStr(),getInputPrice(slt.getAuditSettlementPrice())+"",getInputPrice(oldDto.getAuditSettlementPrice())+""));
							}
							if(null!=slt.getChildPrice()){
								updateStr.append(getChangeLog("儿童销售价"+"-日期"+oldDto.getSpecDateStr(),getInputPrice(slt.getChildPrice())+"",getInputPrice(oldDto.getChildPrice())+""));
							}
							if(null!=slt.getChildSettlementPrice()){
								updateStr.append(getChangeLog("儿童结算价"+"-日期"+oldDto.getSpecDateStr(),getInputPrice(slt.getChildSettlementPrice())+"",getInputPrice(oldDto.getChildSettlementPrice())+""));
							}							
							if(null!=slt.getGapPrice()){
								updateStr.append(getChangeLog("房差销售价"+"-日期"+oldDto.getSpecDateStr(),getInputPrice(slt.getGapPrice())+"",getInputPrice(oldDto.getGapPrice())+""));
							}
							if(null!=slt.getGrapSettlementPrice()){
								updateStr.append(getChangeLog("房差结算价"+"-日期"+oldDto.getSpecDateStr(),getInputPrice(slt.getGrapSettlementPrice())+"",getInputPrice(oldDto.getGrapSettlementPrice())+""));
							}					
					    }
				    	logsStr.append(updateStr.toString());
					}
				}
			}
		}
	}
	
	/**
	 * 产品适用行程修改
	 * @param lineRouteId 行程ID
	 * @param productId 产品ID
	 * @param specDate 团期
	 * @return
	 */
	private String getUpdateLineRouteDateLog(Long lineRouteId,Long productId,Date specDate){
		StringBuffer logStr = new StringBuffer();
		Map<String,Object> params = new HashMap<String, Object>();
		params.put("specDate", specDate);
		params.put("productId", productId);
		ProdLineRoute prodLineRoute = MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(lineRouteId));//新行程
		List<LineRouteDate> lineRouteDates = lineRouteDateService.findByParams(params);
		if(null!=lineRouteDates && !lineRouteDates.isEmpty()){
			LineRouteDate lineRouteDate = lineRouteDates.get(0);
			ProdLineRoute dto = lineRouteDate.getProdLineRoute();// 原有行程
			if(null!=lineRouteId && null!=dto && !lineRouteId.equals(dto.getLineRouteId())){
				if(null!=prodLineRoute){
					//修改
					logStr.append(ComLogUtil.getLogTxt("行程-日期:"+CalendarUtils.getDateFormatString(specDate, "yyyy-MM-dd"),prodLineRoute.getRouteName(),dto.getRouteName()));
				}
			}
		}else{
			if(null!=prodLineRoute){
				//新增
				logStr.append(ComLogUtil.getLogTxt("行程-日期:"+CalendarUtils.getDateFormatString(specDate, "yyyy-MM-dd"),prodLineRoute.getRouteName(),null));
			}
		}
		return logStr.toString();
	}
}
