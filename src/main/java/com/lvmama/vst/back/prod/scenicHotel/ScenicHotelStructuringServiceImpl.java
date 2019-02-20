package com.lvmama.vst.back.prod.scenicHotel;

import static com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE.PROD_TRAVEL_DESIGN;
import static com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE.PROD_LINE_ROUTE;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;

import org.apache.commons.collections.CollectionUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.alibaba.fastjson.JSONObject;
import com.lvmama.dest.api.common.RequestBody;
import com.lvmama.dest.api.common.ResponseBody;
import com.lvmama.dest.api.vst.goods.vo.HotelGoodsVstVo;
import com.lvmama.dest.api.vst.prod.po.HotelProductVstPo;
import com.lvmama.dest.api.vst.prod.service.IHotelProdBranchQueryVstApiService;
import com.lvmama.dest.api.vst.prod.service.IHotelProductQrVstApiService;
import com.lvmama.dest.api.vst.prod.vo.HotelProductBranchVstVo;
import com.lvmama.dest.api.vst.prod.vo.HotelProductVstVo;
import com.lvmama.scenic.api.back.prod.po.ProdDestRe;
import com.lvmama.scenic.api.back.prod.po.ScenicProdProduct;
import com.lvmama.scenic.api.back.prod.po.ScenicProdProductBranch;
import com.lvmama.scenic.api.back.prod.service.ScenicProdProductBranchService;
import com.lvmama.scenic.api.back.prod.service.ScenicProdProductService;
import com.lvmama.scenic.api.prod.service.ScenicSuppGoodsService;
import com.lvmama.scenic.api.vo.PageVo;
import com.lvmama.scenic.api.vo.prod.GoodsBaseVo;
import com.lvmama.vst.back.client.goods.service.SuppGoodsHotelAdapterClientService;
import com.lvmama.scenic.api.ticket.prod.service.ScenicTicketGoodsService;
import com.lvmama.scenic.api.ticket.prod.vo.ScenicTicketGoodsVo;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteClientService;
import com.lvmama.vst.back.client.prod.service.ProdPackageGroupClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductPropClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.dujia.client.comm.prod.service.ProdProductDescriptionClientService;
import com.lvmama.vst.back.dujia.client.comm.route.service.ProdLineRouteDescriptionClientService;
import com.lvmama.vst.back.dujia.comm.prod.po.ProdProductDescription;
import com.lvmama.vst.back.dujia.comm.route.po.ProdLineRouteDescription;
import com.lvmama.vst.back.dujia.group.prod.vo.TravelAlertInnerVO;
import com.lvmama.vst.back.dujia.group.route.vo.CostIncludeInnerVO;
import com.lvmama.vst.back.prod.po.ProdLineRoute;
import com.lvmama.vst.back.prod.po.ProdPackageDetail;
import com.lvmama.vst.back.prod.po.ProdPackageGroup;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductProp;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.prod.po.ScenicHotelCostExcludeVo;
import com.lvmama.vst.back.prod.po.ScenicHotelCostIncludeVo;
import com.lvmama.vst.back.prod.po.ScenicHotelTravelAlertVo;
import com.lvmama.vst.back.prod.po.ScenicHotel_BaseVo;
import com.lvmama.vst.back.prod.po.ScenicHotel_HotelVo;
import com.lvmama.vst.back.prod.po.ScenicHotel_ScenicGoodsVo;
import com.lvmama.vst.back.prod.po.ScenicHotel_ScenicVo;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.utils.Pair;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.MemcachedEnum;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.web.BusinessException;

@Component
public class ScenicHotelStructuringServiceImpl implements ScenicHotelStructuringService {
	
	private static final Logger logger = Logger.getLogger(ScenicHotelStructuringServiceImpl.class);

	@Autowired
	private ProdPackageGroupClientService prodPackageGroupClientService;
	
	@Autowired
	private IHotelProdBranchQueryVstApiService hotelProdBranchQueryVstApiService;
	
	@Autowired
	//ref HotelProductQrVstApiServiceAgentImpl.findProdProductList
	private IHotelProductQrVstApiService hotelProductQrVstApiService;
	
	@Autowired
	private ScenicProdProductBranchService scenicProdProductBranchService;
	
	@Autowired
	private ScenicProdProductService scenicProdProductService;
	
	@Autowired
	private SuppGoodsHotelAdapterClientService suppGoodsHotelService;
	
	@Autowired
	private ScenicSuppGoodsService scenicSuppGoodsService;
	
	@Autowired
	//门票商品的详情， suppGoodsDesc and suppGoodsExp 
	private ScenicTicketGoodsService scenicTicketGoodsService;
	
	@Autowired
	private ProdLineRouteDescriptionClientService prodLineRouteDescriptionService;
	
	@Autowired
	private ProdLineRouteClientService prodLineRouteService;

	@Autowired
	private ComLogClientService comLogService;
	
	@Autowired
	private ProdProductDescriptionClientService productDescriptionService;
	
	@Autowired
	private ProdProductService prodProductService;
	
	@Autowired
	private ProdProductPropClientService prodProductPropService;
	
	@Autowired
	private com.lvmama.phppid.dest.service.MultiDestInfoService destInfoService;
	
	@Autowired
	private com.lvmama.dest.api.vst.goods.service.IHotelGoodsQueryVstApiService hotelGoodsQueryVstApiService; 
	
	private static final String pattern = "<br\u0020*/?>";
	//HTML tag remove pattern
	private static final String DIV_END_PATTERN = "</div>";
	private static final String P_END_PATTERN = "</p>";
	private static final String MULTI_SPACE_PATTERN = "[\\u000a\\u000d\\u0020]{2,}";
	private static final String TR_END_PATTERN = "</tr>";
	private static final String EXTRA_BEGIN_PATTERN = "<[^<>]*>";
	private static final String EXTRA_END_PATTERN = "</[^<>]*>";
	
	@Override
	public ScenicHotelTravelAlertVo  loadPackagedProcuctForTravelAlert (Long productId) {
		if(productId == null) {
			throw new IllegalArgumentException("productId is null");
		}
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productId", productId);
		ResultHandleT<List<ProdPackageGroup>>  resultWrapper = prodPackageGroupClientService.findProdPackageGroupList(params);
		List<ProdPackageGroup> pkgList = resultWrapper != null && resultWrapper.isSuccess() ? resultWrapper.getReturnContent() : null;
		if(pkgList == null || pkgList.isEmpty()) {
			logger.info("findProdPackageGroupList for productId:" + productId + " is null");
			return null;
		}
		
		Collection<ScenicHotel_HotelVo> hotelVoList = this.loadPackagedHotelForTravelAlert(pkgList);
		Collection<ScenicHotel_ScenicVo> scenicVoList = this.loadPackagedTicketForTravelAlert(pkgList);
		ScenicHotelTravelAlertVo travelAlertVo = new ScenicHotelTravelAlertVo();
		travelAlertVo.setHotelList(new ArrayList<ScenicHotel_HotelVo>(hotelVoList));
		travelAlertVo.setTicketList(new ArrayList<ScenicHotel_ScenicVo>(scenicVoList));
		return travelAlertVo;
	}

	@Override
	public void judgeCostChangeState(ScenicHotelCostIncludeVo existsVo, Map<String, List<Pair<String, ScenicHotelCostIncludeVo.Item>>> packagedVo) {
		if(existsVo == null) {
			throw new IllegalArgumentException("existsVo can't be null");
		}
		if(packagedVo == null) {
			throw new IllegalArgumentException("packagedVo can't be null");
		}
		this.judgeHotelCostChangeState(existsVo, packagedVo);
		this.judgeTicketCostChangeState(existsVo, packagedVo);
	}
	
	
	private void judgeHotelCostChangeState(ScenicHotelCostIncludeVo existsVo, Map<String, List<Pair<String, ScenicHotelCostIncludeVo.Item>>> packagedVo) {
		List<Pair<String, ScenicHotelCostIncludeVo.Item>> pkgedHotel = packagedVo.get(ProdPackageGroup.GROUPTYPE.HOTEL.name());
		Set<String> hotelProductIds = new HashSet<String>();
		Set<String> existsHotelProductIds = new HashSet<String>();
		StringBuilder packagedHotel = new StringBuilder();
		
		if(pkgedHotel != null) {
			for(Pair<String, ScenicHotelCostIncludeVo.Item> pair :pkgedHotel) {
				String productIdStr =  pair.getSecond().getProductIds();
				if(productIdStr != null && !productIdStr.isEmpty()) {
					String[] productIds = pair.getSecond().getProductIds().split(",");
					hotelProductIds.addAll(Arrays.asList(productIds));
				}
				packagedHotel.append(pair.getSecond().getContent()).append('\n');
			}
		} else {
			pkgedHotel = new ArrayList<Pair<String, ScenicHotelCostIncludeVo.Item>>();
			packagedVo.put(ProdPackageGroup.GROUPTYPE.HOTEL.name(), pkgedHotel);
		}
		
		if(existsVo.getHotel() != null && existsVo.getHotel().getProductIds() != null) {
			existsHotelProductIds.addAll(Arrays.asList( existsVo.getHotel().getProductIds().split(",") ) );
		}
		
		existsHotelProductIds.remove("") ;
		hotelProductIds.remove("");
		int[] state = existsVo.getState();
		if( existsHotelProductIds.containsAll(hotelProductIds) && hotelProductIds.containsAll(existsHotelProductIds)) {
			state[0] = 0;
		} else {
			state[0] = 1;
			//hotel
			if(existsVo.getHotel() == null) {
				existsVo.setHotel(new ScenicHotelCostIncludeVo.Item());
			}
			StringBuilder sb = new StringBuilder();
			for(String str : hotelProductIds) {
				sb.append(',').append(str);
			}
			existsVo.getHotel().setProductIds(sb.length() > 0 ? sb.substring(1) : "");
			String existsContent = existsVo.getHotel().getContent();
			if(existsHotelProductIds.isEmpty() &&  (existsContent== null || existsContent.isEmpty()) ) {
				existsVo.getHotel().setContent(packagedHotel.toString());
			}
		}
		logger.debug("previous hotelIds:" + existsHotelProductIds + ", current hotelIds:"  + hotelProductIds);
	}
	
	private void judgeTicketCostChangeState(ScenicHotelCostIncludeVo existsVo, Map<String, List<Pair<String, ScenicHotelCostIncludeVo.Item>>> packagedVo) {
		List<Pair<String, ScenicHotelCostIncludeVo.Item>> pkgedTicket = packagedVo.get(ProdPackageGroup.GROUPTYPE.LINE_TICKET.name());

		Set<String> ticketProductIds = new HashSet<String>();
		Set<String> existsTicketProductIds = new HashSet<String>();
		StringBuilder packagedTicket = new StringBuilder();
		
		if(pkgedTicket != null) {
			for(Pair<String, ScenicHotelCostIncludeVo.Item> pair :pkgedTicket) {
				String productIdStr =  pair.getSecond().getProductIds();
				if(productIdStr != null && !productIdStr.isEmpty()) {
					String[] productIds = pair.getSecond().getProductIds().split(",");
					ticketProductIds.addAll(Arrays.asList(productIds));
				}
				packagedTicket.append(pair.getFirst()).append('\n').append(pair.getSecond().getContent()).append('\n');
			}
		} else {
			pkgedTicket = new ArrayList<Pair<String, ScenicHotelCostIncludeVo.Item>>();
			packagedVo.put(ProdPackageGroup.GROUPTYPE.LINE_TICKET.name(), pkgedTicket);
		}
		
		if(existsVo.getTicket() != null && existsVo.getTicket().getProductIds() != null ) {
			existsTicketProductIds.addAll(Arrays.asList( existsVo.getTicket().getProductIds().split(",") ) );
		}
		
		existsTicketProductIds.remove("") ;
		ticketProductIds.remove("");
		int[] state = existsVo.getState();
		if( existsTicketProductIds.containsAll(ticketProductIds) && ticketProductIds.containsAll(existsTicketProductIds)) {
			state[1] = 0;
		} else {
			state[1] = 1;
			//ticket
			if(existsVo.getTicket() == null) {
				existsVo.setTicket(new ScenicHotelCostIncludeVo.Item());
			}
			StringBuilder sb = new StringBuilder();
			for(String str : ticketProductIds) {
				sb.append(',').append(str);
			}
			if(sb.length() > 0) {
				existsVo.getTicket().setProductIds(sb.substring(1));
			}
			String content = existsVo.getTicket().getContent();
			if(existsTicketProductIds.isEmpty() && (content == null || content.isEmpty())) {
				existsVo.getTicket().setContent(packagedTicket.toString());
			}
		}
		logger.debug("previous ticketIds:" + existsTicketProductIds + ", current ticketIds:"  + ticketProductIds);
	}
	
	@Override
	public Map<String, List<Pair<String, ScenicHotelCostIncludeVo.Item>>> loadPackagedProuctName(Long productId) {
		if(productId == null) {
			throw new IllegalArgumentException("productId is null");
		}

		Map<String, List<Pair<String, ScenicHotelCostIncludeVo.Item>>> result = new HashMap<String, List<Pair<String,ScenicHotelCostIncludeVo.Item>>>();
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productId", productId);
		ResultHandleT<List<ProdPackageGroup>>  resultWrapper = prodPackageGroupClientService.findProdPackageGroupList(params);
		List<ProdPackageGroup> pkgList = resultWrapper != null && resultWrapper.isSuccess() ? resultWrapper.getReturnContent() : null;
		if(pkgList == null) {
			return result;
		}
		
		List<Pair<String, ScenicHotelCostIncludeVo.Item>> ticketResult = getPackagedTicketNames(pkgList);
		List<Pair<String, ScenicHotelCostIncludeVo.Item> > hotelResult = this.getPackagedHotelNames(pkgList);

		result.put(ProdPackageGroup.GROUPTYPE.LINE_TICKET.name(), ticketResult);
		result.put(ProdPackageGroup.GROUPTYPE.HOTEL.name(), hotelResult);
		return result;
	}
	
	@Override
	public boolean saveCost(ScenicHotelCostIncludeVo costIncludeInnerVO, ScenicHotelCostExcludeVo costExcludeInnerVO, ProdLineRouteDescription lineRouteDescription,
			String currentUserName) {
		
		//日志
		ProdLineRoute prodLineRoute=new ProdLineRoute();
		prodLineRoute.setLineRouteId(lineRouteDescription.getLineRouteId());
		prodLineRoute.setProductId(lineRouteDescription.getProductId());
		
		String log = this.concatCostLog(costIncludeInnerVO, costExcludeInnerVO, lineRouteDescription);
		logLineRouteOperate(currentUserName, prodLineRoute,log,"新增、编辑费用说明（国内）");
		
		//费用包含
		ProdLineRouteDescription descInclude = new ProdLineRouteDescription();
		descInclude.setCategoryId(lineRouteDescription.getCategoryId());
		descInclude.setProductId(lineRouteDescription.getProductId());
		descInclude.setProductType(lineRouteDescription.getProductType());
		descInclude.setLineRouteId(lineRouteDescription.getLineRouteId());
		descInclude.setContentType(ProdLineRouteDescription.CONTENT_TYPE.COST_INCLUDE.name());
		descInclude.setContent(JSONObject.toJSONString(costIncludeInnerVO));
		prodLineRouteDescriptionService.saveOrUpdateDoublePlaceForRouteDes(descInclude);

		//费用不含
		ProdLineRouteDescription descExclude=new ProdLineRouteDescription();
		descExclude.setCategoryId(lineRouteDescription.getCategoryId());
		descExclude.setProductId(lineRouteDescription.getProductId());
		descExclude.setProductType(lineRouteDescription.getProductType());
		descExclude.setLineRouteId(lineRouteDescription.getLineRouteId());
		descExclude.setContentType(ProdLineRouteDescription.CONTENT_TYPE.COST_EXCLUDE.name());
		descExclude.setContent(JSONObject.toJSONString(costExcludeInnerVO));
		prodLineRouteDescriptionService.saveOrUpdateDoublePlaceForRouteDes(descExclude);
		
		//清除缓存
		MemcachedUtil.getInstance().remove(MemcachedEnum.ProdRouteCostStatementInner.getKey() +lineRouteDescription.getLineRouteId());
		return true;
	}

	private String concatCostLog(ScenicHotelCostIncludeVo costIncludeInnerVO, ScenicHotelCostExcludeVo costExcludeInnerVO, ProdLineRouteDescription lineRouteDescription) {
		StringBuilder log = new StringBuilder("更新行程费用说明：");
		
		//赋空值， 减少判断
		if(costIncludeInnerVO == null) {
			costIncludeInnerVO  = new ScenicHotelCostIncludeVo();
			costIncludeInnerVO.setHotel(new ScenicHotelCostIncludeVo.Item());
			costIncludeInnerVO.setTicket(new ScenicHotelCostIncludeVo.Item());
		} else {
			if(costIncludeInnerVO.getHotel() == null) {
				costIncludeInnerVO.setHotel(new ScenicHotelCostIncludeVo.Item());
			}
			if(costIncludeInnerVO.getTicket() == null) {
				costIncludeInnerVO.setTicket(new ScenicHotelCostIncludeVo.Item());
			}
		}
		if(costExcludeInnerVO == null) {
			costExcludeInnerVO = new ScenicHotelCostExcludeVo();
		}
		try{
			//查询  产品ID+行程ID+产品类型（国内或出境）+内容类型（费用包含或费用不含）组成唯一值
			Long productId=lineRouteDescription.getProductId();
			Long lineRouteId=lineRouteDescription.getLineRouteId();
			String productType=lineRouteDescription.getProductType();
			//String contentType=lineRouteDescription.getContentType();
			if(productId==null||lineRouteId==null||productType==null ) {
				log.append("productId==null||lineRouteId==null||productType==null");
				return log.toString();
			}
			Map<String, Object> params=new HashMap<String, Object>();
			params.put("productId", productId);
			params.put("lineRouteId", lineRouteId);
			params.put("productType", productType);
			//params.put("contentType", contentType);
			List<ProdLineRouteDescription> routeDescList= MiscUtils.autoUnboxing( prodLineRouteDescriptionService.findLineRouteDescriptionListByParams(params) );
			ScenicHotelCostIncludeVo preCostIncludeInnerVO = null;
			ScenicHotelCostExcludeVo existedCostExcludeInnerVO = null;
			if(routeDescList != null ) {
				for(ProdLineRouteDescription  vo : routeDescList) {
					if(ProdLineRouteDescription.CONTENT_TYPE.COST_INCLUDE.name().equals(vo.getContentType())) {
						try{
						preCostIncludeInnerVO = JSONObject.parseObject(vo.getContent(), ScenicHotelCostIncludeVo.class);
						}catch(Exception e) {
							logger.info(e.getMessage(), e);
							log.append("转换旧的记录失败， 非结构化的ProdLineRouteDescription费用包含数据？");
						}
					} else if (ProdLineRouteDescription.CONTENT_TYPE.COST_EXCLUDE.name().equals(vo.getContentType()) ) {
						try{
						existedCostExcludeInnerVO = JSONObject.parseObject(vo.getContent(), ScenicHotelCostExcludeVo.class);
						}catch (Exception e) {
							logger.info(e.getMessage(), e);
							log.append("转换旧的记录失败， 非结构化的ProdLineRouteDescription费用不包含数据？");
						}
					}
				}
			}
			
			//旧值赋空值，便于比较
			if(preCostIncludeInnerVO == null) {
				preCostIncludeInnerVO  = new ScenicHotelCostIncludeVo();
				preCostIncludeInnerVO.setHotel(new ScenicHotelCostIncludeVo.Item());
				preCostIncludeInnerVO.setTicket(new ScenicHotelCostIncludeVo.Item());
			}  else {
				if(preCostIncludeInnerVO.getHotel() == null) {
					preCostIncludeInnerVO.setHotel(new ScenicHotelCostIncludeVo.Item());
				}
				if(preCostIncludeInnerVO.getTicket() == null) {
					preCostIncludeInnerVO.setTicket(new ScenicHotelCostIncludeVo.Item());
				}
			}
			if(existedCostExcludeInnerVO == null) {
				existedCostExcludeInnerVO = new ScenicHotelCostExcludeVo();
			}
			
			//比较费用包含
			if(costIncludeInnerVO != null && preCostIncludeInnerVO!= null ) {
				log.append("【费用包含】：");
				//酒店和门票
				log.append(concateCostOneItemLog ( costIncludeInnerVO.getHotel(),  preCostIncludeInnerVO.getHotel() , "酒店") ) ;
				log.append(concateCostOneItemLog ( costIncludeInnerVO.getTicket(),  preCostIncludeInnerVO.getTicket(), "门票") ) ;
				//其他项
				log.append(concateCostOneFieldLog ( costIncludeInnerVO.getBuyPresent(),  preCostIncludeInnerVO.getBuyPresent() , "买赠") ) ;
				log.append(concateCostOneFieldLog ( costIncludeInnerVO.getEntertainment(),  preCostIncludeInnerVO.getEntertainment() , "娱乐") ) ;
				log.append(concateCostOneFieldLog ( costIncludeInnerVO.getMeal(),  preCostIncludeInnerVO.getMeal() , "用餐") ) ;
				log.append(concateCostOneFieldLog ( costIncludeInnerVO.getSupplement(),  preCostIncludeInnerVO.getSupplement() , "补充") ) ;
				log.append(concateCostOneFieldLog ( costIncludeInnerVO.getTransport(),  preCostIncludeInnerVO.getTransport() , "交通") ) ;
			}
			//比较费用不包含
			log.append("【费用不包含】：");
			log.append(concateCostOneFlag(costExcludeInnerVO.getSelfPayItem(), existedCostExcludeInnerVO.getSelfPayItem(), "自理项目"));
			log.append(concateCostOneFlag(costExcludeInnerVO.getPresentItem(), existedCostExcludeInnerVO.getPresentItem(), "赠送项目"));
			log.append(concateCostOneFlag(costExcludeInnerVO.getSecurityItem(), existedCostExcludeInnerVO.getSecurityItem(), "保险"));
			log.append(concateCostOneFieldLog ( costExcludeInnerVO.getSupplement(),  existedCostExcludeInnerVO.getSupplement() , "补充") ) ;
		}catch(Exception e) {
			logger.info(e.getMessage(), e);
		}
		
		if(logger.isDebugEnabled()) {
			logger.debug(log.toString());
		}
		return log.toString();
	}
	
	private StringBuilder concateCostOneFlag(char curr , char previous, String fieldName){
		StringBuilder log = new StringBuilder();
		if(curr != previous)
			log.append(fieldName).append((previous!='Y'? 'N':previous) + "->" + (curr!='Y'? 'N':curr)).append(',');
		return log;
	}
	
	private StringBuilder concateCostOneItemLog(ScenicHotelCostIncludeVo.Item current, ScenicHotelCostIncludeVo.Item previous,  String fieldName) {
		String currValue  = current.getContent();
		if(current.get_default() != null) {
			currValue = currValue == null ?current.get_default() : currValue + current.get_default();
		}
		String preValue = previous.getContent();
		if(previous.get_default() != null) {
			preValue = preValue == null ?previous.get_default() : preValue + previous.get_default();
		}
		return this.concateCostOneFieldLog(currValue, preValue, fieldName);
	}
	
	private StringBuilder concateCostOneFieldLog(String currValue, String previousValue, String fieldName) {
		StringBuilder log = new StringBuilder();
		if(previousValue != null && currValue != null) {
			if(!currValue.equals(previousValue)) {
				log.append("更新").append(fieldName).append("，新值[").append(currValue).append("],旧值[").append(previousValue).append(']');
			}
		} else if (currValue  == null && previousValue != null) {
			log.append("清空").append(fieldName).append(",旧值[").append(previousValue).append(']');
		} else if (currValue != null && previousValue == null) {
			log.append("新增").append(fieldName).append(",新值[").append(currValue).append(']');
		}
		return log;
	}
	
	@Override
	public Map<String, Object> loadCost(Long productId, String productType, Long lineRouteId,Long categoryId){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productId", productId);
		params.put("lineRouteId", lineRouteId);
		params.put("productType", productType);
		List<ProdLineRouteDescription> lineRouteDescriptionList = MiscUtils.autoUnboxing(prodLineRouteDescriptionService.findLineRouteDescriptionListByParams(params));
		
		Map<String, Object> result = new HashMap<String, Object>();
		ScenicHotelCostIncludeVo costIncludeInnerVO = null;
		ScenicHotelCostExcludeVo costExcludeInnerVO = null;
		if(CollectionUtils.isNotEmpty(lineRouteDescriptionList)){
			for(ProdLineRouteDescription routeDesc :lineRouteDescriptionList){
				if(ProdLineRouteDescription.CONTENT_TYPE.COST_INCLUDE.name().equals(routeDesc.getContentType())){
					costIncludeInnerVO = JSONObject.parseObject(routeDesc.getContent(), ScenicHotelCostIncludeVo.class);
					result.put("lineRouteDescriptionIn", routeDesc);
				}
				if (ProdLineRouteDescription.CONTENT_TYPE.COST_EXCLUDE.name().equals(routeDesc.getContentType())) {
					costExcludeInnerVO = JSONObject.parseObject(routeDesc.getContent(), ScenicHotelCostExcludeVo.class);
					result.put("lineRouteDescriptionEx", routeDesc);
				}
			}
		}
		
		// 如果没有记录， 那么进行历史数据转换工作
		if(costIncludeInnerVO == null && costExcludeInnerVO == null) {
			ResultHandleT<ProdLineRoute> routeWrapper = this.prodLineRouteService.findRouteReByRouteId(lineRouteId);
			ProdLineRoute route = routeWrapper == null || routeWrapper.isFail()? null : routeWrapper.getReturnContent();
			//convert <br/> to \n
			costIncludeInnerVO = new ScenicHotelCostIncludeVo();
			costIncludeInnerVO.setHotel(new ScenicHotelCostIncludeVo.Item());
			costIncludeInnerVO.setTicket(new ScenicHotelCostIncludeVo.Item());
			//描述信息初始化， 让其默认被勾选中
			costIncludeInnerVO.getHotel().set_default("酒店房型、间夜数以实际下单为准");
			costIncludeInnerVO.getTicket().set_default("门票数量、具体游玩日期以实际下单为准");
			if(route != null && route.getCostInclude() != null) {
				String str = route.getCostInclude();
				str = str.replaceAll(pattern, "\n");
				costIncludeInnerVO.setSupplement(str);
			}
			
			costExcludeInnerVO = new ScenicHotelCostExcludeVo();
			if(route != null && route.getCostExclude() != null) {
				String str = route.getCostExclude();
				str = str.replaceAll(pattern, "\n");
				costExcludeInnerVO.setSupplement(str);
				//将不包含选项初始化为'N'
				costExcludeInnerVO.setPresentItem('N');
				costExcludeInnerVO.setSecurityItem('N');
				costExcludeInnerVO.setSelfPayItem('N');
			} else {
				//将不包含选项初始化为'N'
				costExcludeInnerVO.setPresentItem('Y');
				costExcludeInnerVO.setSecurityItem('Y');
				costExcludeInnerVO.setSelfPayItem('Y');
			}
			
		}
		
		//need some initialize?
		ProdLineRouteDescription lineRouteDescriptionIn = new ProdLineRouteDescription();
		lineRouteDescriptionIn.setProductId(productId);
		lineRouteDescriptionIn.setProductType(productType);
		lineRouteDescriptionIn.setLineRouteId(lineRouteId);
		lineRouteDescriptionIn.setCategoryId(categoryId);
		result.put("prodLineRouteDescription", lineRouteDescriptionIn);
		
		result.put("scenicHotelCostIncludeVo", costIncludeInnerVO);
		result.put("scenicHotelCostExcludeVo", costExcludeInnerVO);
		return result;
	}
	
	@Override
	public boolean saveTravelAlert(ScenicHotelTravelAlertVo travelAlertInnerVO, ProdProductDescription productDescription, 
			Double modelVersion, String currentUserName) {
		if(travelAlertInnerVO == null) {
			travelAlertInnerVO = new ScenicHotelTravelAlertVo();
		}
		//预处理无效的item
		preProcessVo(travelAlertInnerVO);
		
		try{ //write log
			processTravelAlertLog(travelAlertInnerVO , productDescription.getProdDescId(), productDescription.getProductId(), currentUserName);
		}catch(Exception e) {
			logger.info("write log failed", e);
		}
		
		//检测是否需要更新modelVersion
		if(modelVersion == null || modelVersion < 2.0d) {
			Long productId = productDescription.getProductId();
			ProdProduct prodProduct = new ProdProduct();
			prodProduct.setProductId(productId);
			prodProduct.setModelVersion(2.0d);
			this.prodProductService.updateModelVersionByPrimaryKey(prodProduct);
		}
		
		// 保存出行警示
		String jsonStr = JSONObject.toJSONString(travelAlertInnerVO);
		productDescription.setContentType(ProdProductDescription.CONTENT_TYPE.TRAVEL_ALERT.name());
		productDescription.setContent(jsonStr);
		productDescriptionService.saveOrUpdateDoublePlaceForProductDes(productDescription);

		//清空出行警示缓存
		MemcachedUtil.getInstance().remove(MemcachedEnum.ProdProductTravelAlertInner.getKey() + productDescription.getProductId());
		return true;
	}


	@Override
	public Map<String, Object> loadTravelAlert(Long productId, String productType) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productId", productId);
		params.put("productType", productType);
		params.put("contentType", ProdProductDescription.CONTENT_TYPE.TRAVEL_ALERT.name());
		// 查询出行警示
		List<ProdProductDescription> productDescriptionList = MiscUtils.autoUnboxing( productDescriptionService.findProductDescriptionListByParams(params) );
		ProdProductDescription productDescription = null;
		ScenicHotelTravelAlertVo travelAlertInnerVO = null;
		if (CollectionUtils.isNotEmpty(productDescriptionList)) {
			productDescription = productDescriptionList.get(0);
			if (StringUtil.isNotEmptyString(productDescription.getContent())) {
				travelAlertInnerVO = JSONObject.parseObject(productDescription.getContent(), ScenicHotelTravelAlertVo.class);
			}
		}
		
		if(productDescription == null) {
			//没有值，初始化一个空， 便于spring mvc绑定
			productDescription = new ProdProductDescription();
			productDescription.setProductId(productId);
			productDescription.setProductType(productType);
			productDescription.setContentType(ProdProductDescription.CONTENT_TYPE.TRAVEL_ALERT.name());
		}
		
		com.lvmama.vst.back.prod.po.ProdProduct product = prodProductService.getProdProductBy(productId);
		if(product != null) {
			productDescription.setCategoryId(product.getBizCategoryId());
		} else {
			logger.info("prod_product for productId:" + productId + " not found, wtf?");
			throw new RuntimeException("product not exists for " + productId);
		}
		
		Double modelVersion = product.getModelVersion();
		//modeVersion为空表示历史数据， 加载原来的出行警示， 放到其他域中
		if(modelVersion == null || modelVersion < 2.0d ) {
			if(travelAlertInnerVO == null) {
				travelAlertInnerVO = new ScenicHotelTravelAlertVo();
			}
			String supplements = loadHistoryTravelAlert(productId);
			travelAlertInnerVO.setSupplements(supplements);
		}
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("travelAlertInnerVO", travelAlertInnerVO);
		result.put("productDescription", productDescription);
		result.put("modelVersion", modelVersion != null ? modelVersion : 0d);
		result.put("isSupplierPackaged", ProdProduct.PACKAGETYPE.SUPPLIER.name().equals(product.getPackageType()));
		return result;
	}
	
	private String loadHistoryTravelAlert(Long productId) {
		String supplements = null;
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("propId", 607L);
		params.put("productId", productId);
		ResultHandleT<List<ProdProductProp>> propListWrapper = prodProductPropService.findProdProductPropListDetail(params);
		if(propListWrapper != null && propListWrapper.getReturnContent() != null && !propListWrapper.getReturnContent().isEmpty()) {
			ProdProductProp prop = propListWrapper.getReturnContent().get(0);
			supplements = prop.getPropValue();
			if(supplements != null ) {
				//防止是转义的文本
				supplements = org.springframework.web.util.HtmlUtils.htmlUnescape(supplements);
				supplements = supplements.replaceAll(pattern, "\n");
				supplements = supplements.replaceAll(DIV_END_PATTERN, "\n");
				supplements = supplements.replaceAll(P_END_PATTERN, "\n");
				supplements = supplements.replaceAll(TR_END_PATTERN, "\n");
				supplements = supplements.replaceAll(EXTRA_BEGIN_PATTERN, "");
				supplements = supplements.replaceAll(EXTRA_END_PATTERN, "");
				supplements = supplements.replaceAll(MULTI_SPACE_PATTERN, "\n");
			}
		}
		return supplements;
	}
	
	private Collection<ScenicHotel_HotelVo>  loadPackagedHotelForTravelAlert (List<ProdPackageGroup> pkgList) {
		Map<Long, Long> detailId2BranchIdMap = new HashMap<Long, Long>();
		//detailId-> set<goodsId> 
		Map<Long, Set<Long>> detailId2GoodsIdMap = new HashMap<Long, Set<Long>>();
		for(ProdPackageGroup pkg : pkgList) {
			if ( ProdPackageGroup.GROUPTYPE.HOTEL.name().equals(pkg.getGroupType())) {
				if (pkg.getProdPackageDetails()!=null) {
					for(ProdPackageDetail detail  : pkg.getProdPackageDetails()) {
						detailId2BranchIdMap.put(detail.getDetailId(), detail.getObjectId());
					}
				}
				Long groupId = pkg.getGroupId();
				Map<Long, Long> goodsPackaged = findSuppGoodsIdsForOneGroup(groupId);
				//将 goodsId-> detailId 映射转换为  detailId-> 商品id 的映射
				for(Map.Entry<Long, Long> entry : goodsPackaged.entrySet()) {
					Long detailId = entry.getValue();
					Long goodsId = entry.getKey();
					if(!detailId2GoodsIdMap.containsKey(detailId)) {
						detailId2GoodsIdMap.put(detailId, new HashSet<Long>());
					}
					Set<Long> goodsList = detailId2GoodsIdMap.get(detailId);
					goodsList.add(goodsId);
					//如果打包到商品， 那就不需要从规格确定产品id了。
					detailId2BranchIdMap.remove(detailId);
				}
			}
		}
		
		//查询商品id对应的产品id, 然后构建goodsId -> productId映射
		Set<Long> goodsIdSet = new HashSet<Long>();
		for(Map.Entry<Long, Set<Long>> entry : detailId2GoodsIdMap.entrySet()) {
			goodsIdSet.addAll(entry.getValue());
		}
		
		Map<Long, Long> goodsId2ProductIdMap = new HashMap<Long, Long>();
		List<HotelGoodsVstVo>  goodsVoList = queryHotelGoodsById(new ArrayList<Long>(goodsIdSet));
		for(HotelGoodsVstVo vo : goodsVoList) {
			goodsId2ProductIdMap.put(vo.getSuppGoodsId(), vo.getProductId());
		}

		//branchId->productId
		Map<Long, Long> hotelProductIdMap = this.findHotelProcuctIdForBranchId(detailId2BranchIdMap.values());
		
		Set<Long> productIdSet = new HashSet<Long>();
		productIdSet.addAll(hotelProductIdMap.values());
		productIdSet.addAll(goodsId2ProductIdMap.values());
		List<HotelProductVstVo>  hotelProcutList = this.findHotelProductListByIds(new ArrayList<Long>( productIdSet));
		
		//根据商品id 查询对应的商品及封装vo
		Map<Long, ScenicHotel_HotelVo> scenicResultMap = new HashMap<Long, ScenicHotel_HotelVo>();
		for(HotelProductVstVo product :  hotelProcutList) {
			ScenicHotel_HotelVo vo = new ScenicHotel_HotelVo();
			scenicResultMap.put(product.getProductId(), vo);
			vo.setId(product.getProductId());
			vo.setName(product.getProductName());
			Map<String, Object> propValue = product.getPropValue();
			if(propValue != null) {
				vo.setAddress((String)propValue.get("address"));
				vo.setPhone((String)propValue.get("telephone"));
				vo.setArriveTime((String)propValue.get("earliest_arrive_time"));
				vo.setLeaveTime((String)propValue.get("latest_leave_time"));
			} else {
				logger.info("PropValue for productId:" + product.getProductId() + "is null");
			}
			
		}
		return scenicResultMap.values();
	}
	
	
	private Collection<ScenicHotel_ScenicVo>  loadPackagedTicketForTravelAlert (List<ProdPackageGroup> pkgList) {
		//branchId->detailId映射
		Map<Long, Long> branchId2DetailIdMap = new HashMap<Long, Long>();
		Map<Long, Set<Long>> detailId2GoodsIdMap = new HashMap<Long, Set<Long>>();
		Long lineProductId = null;
		for(ProdPackageGroup pkg : pkgList) {
			lineProductId = pkg.getProductId();
			if( ProdPackageGroup.GROUPTYPE.LINE_TICKET.name().equals( pkg.getGroupType()) ) {
				if(pkg.getProdPackageDetails() != null) {
					for(ProdPackageDetail detail : pkg.getProdPackageDetails()) {
						branchId2DetailIdMap.put(detail.getObjectId(), detail.getDetailId());
					}
				}
				Long groupId = pkg.getGroupId();
				Map<Long, Long> goodsPackaged = findSuppGoodsIdsForOneGroup(groupId);
				//将 商品id-> 规格id 映射转换为  规格id-> 商品id 的映射
				for(Map.Entry<Long, Long> entry : goodsPackaged.entrySet()) {
					if(!detailId2GoodsIdMap.containsKey(entry.getValue())) {
						detailId2GoodsIdMap.put(entry.getValue(), new HashSet<Long>());
					}
					Set<Long> goodsList = detailId2GoodsIdMap.get(entry.getValue());
					goodsList.add(entry.getKey());
				}
			}
		}
		
		//筛选只打包到规格的情况，
		Set<Long> needLoadGoodsBranchIdList = new HashSet<Long>();
		//branchId->goodsId映射
		Map<Long, Set<Long>> branchId2GoodsIdMap = new HashMap<Long, Set<Long>>();
		for(Map.Entry<Long, Long> entry :branchId2DetailIdMap.entrySet()) {
			if(!detailId2GoodsIdMap.containsKey(entry.getValue())) {
				needLoadGoodsBranchIdList.add(entry.getKey());
			} else {
				//合并各个detail下的商品id
				if(!branchId2GoodsIdMap.containsKey(entry.getKey())) {
					branchId2GoodsIdMap.put(entry.getKey(), new HashSet<Long>());
				}
				branchId2GoodsIdMap.get(entry.getKey()).addAll( detailId2GoodsIdMap.get(entry.getValue())  );
			}
		}
		//只打包到规格， 根据branchId 加载商品
		List<GoodsBaseVo> goodsList = findTicketSuppGoodsForBranchIds(new ArrayList<Long>(needLoadGoodsBranchIdList));
		if(goodsList != null) {
			for(GoodsBaseVo vo : goodsList) {
				if(!branchId2GoodsIdMap.containsKey(vo.getProductBranchId())) {
					branchId2GoodsIdMap.put(vo.getProductBranchId(), new HashSet<Long>());
				}
				branchId2GoodsIdMap.get(vo.getProductBranchId()).add( vo.getSuppGoodsId()  );
			}
		}
		
		//加载门票的branchId->productId 映射
		Map<Long, Long> ticketProductIdMap = this.findTicketProductIdForBranchId(new ArrayList<Long>(branchId2DetailIdMap.keySet()) );
		Set<Long> productIdSet = new HashSet<Long>(ticketProductIdMap.values());
		List<ScenicProdProduct>  ticketProcutList = findTicketProcutListByIds(new ArrayList<Long>( productIdSet));
		
		//根据productId -> branchId 和 branchId-> goodsId 生成 productId -> goodsId映射
		Map<Long, Set<Long> > productId2GoodsIdMap = new HashMap<Long, Set<Long>>();
		for(Map.Entry<Long, Long> entry : ticketProductIdMap.entrySet()) {
			Long branchId = entry.getKey();
			Long productId = entry.getValue();
			if(!productId2GoodsIdMap.containsKey(productId)) {
				productId2GoodsIdMap.put(productId, new HashSet<Long>());
			}
			productId2GoodsIdMap.get(productId).addAll(  branchId2GoodsIdMap.get(branchId));
		}
		
		//根据商品id 查询对应的商品及封装vo
		Map<Long, ScenicHotel_ScenicVo> scenicResultMap = new HashMap<Long, ScenicHotel_ScenicVo>();
		for(ScenicProdProduct product :  ticketProcutList) {
			ScenicHotel_ScenicVo vo = new ScenicHotel_ScenicVo();
			
			vo.setId(product.getProductId());
			vo.setName(product.getProductName());
			List<ProdDestRe> destReList = product.getProdDestReList();
			if(destReList != null && !destReList.isEmpty()) {
				String address = getDestAddress(destReList.get(0).getDestId(), lineProductId, product.getProductId());
				vo.setDestName(address);
			} else {
				logger.info("ProdDestRe for productId:" + product.getProductId() + " is empty");
			}
			
			vo.setFreePolicy( product.getProp("book_free_policy")) ;
			vo.setPreferentialCrowd( product.getProp("book_preferential_crowd") );
			vo.setBookDescription(product.getProp("book_description"));
			
			Set<Long> goodsIdSet = productId2GoodsIdMap.get(product.getProductId());
			List<ScenicHotel_ScenicGoodsVo> goodsVoList = new ArrayList<ScenicHotel_ScenicGoodsVo>();
			vo.setGoodsList(goodsVoList);
			for(Long goodsId : goodsIdSet) {
				ScenicHotel_ScenicGoodsVo  goodsVo = wrapOneTicketGoods(goodsId);
				if(goodsVo != null) {
					goodsVoList.add(goodsVo);
				}
			}
			if(goodsVoList != null && !goodsVoList.isEmpty()) {
				scenicResultMap.put(product.getProductId(), vo);
			}
		}
		return scenicResultMap.values();
	}

	
	
	private ScenicHotel_ScenicGoodsVo wrapOneTicketGoods(Long goodsId) {
		ScenicHotel_ScenicGoodsVo result = new ScenicHotel_ScenicGoodsVo();
		ScenicTicketGoodsVo goodsVo = findTicketGoodsDetail(goodsId);
		//必须有效可售
		if(goodsVo == null || !"Y".equals( goodsVo.getCancelFlag()) 
				|| !"Y".equals(goodsVo.getOnlineFlag())) {
			return null;
		}
		result.setId(goodsId);
		result.setName( goodsVo.getGoodsName() );
		com.lvmama.scenic.api.ticket.prod.vo.SuppGoodsExpVo expVo = goodsVo.getSuppGoodsExpVo();
		if(expVo != null && expVo.getDays() != null) {
			//指定游玩日天内有效
			result.setExpireDays("指定游玩日" + (expVo.getDays() == 1 ? "当": expVo.getDays()) +  "天内有效");
		} else {
			logger.info("SuppGoodsExpVo for suppGoodsId:" + goodsId + " is null");
		}
		
		com.lvmama.scenic.api.ticket.prod.vo.SuppGoodsDescVo suppGoodsDesc = goodsVo.getSuppGoodsDescVo();
		if(suppGoodsDesc != null) {
			result.setLimitTime(suppGoodsDesc.getLimitTime());
			result.setChangeTime(suppGoodsDesc.getChangeTime());
			result.setChangeAddress(suppGoodsDesc.getChangeAddress());
			result.setEntryStyle(suppGoodsDesc.getEnterStyle());
			result.setImportWarning(suppGoodsDesc.getOthers());
		} else {
			logger.info("SuppGoodsDescVo for suppGoodsId:" + goodsId + " is null");
		}
		return result;
	}
	
	//加载被打包产品的名称

	
	private String getDaysInfo(ProdPackageGroup pkg) {
		StringBuilder daysInfo = new StringBuilder("");
		if( ProdPackageGroup.GROUPTYPE.LINE_TICKET.name().equals( pkg.getGroupType()) ) {
			String stayDays = pkg.getProdPackageGroupTicket().getStartDay();
			//门票时离散的
			String[] days = stayDays.split(",");
			if(days.length == 1) {
				daysInfo.append("第").append(days[0]).append("天");
			} else {
				for(String day : days) {
					daysInfo.append(",").append(day);
				}
				daysInfo.replace(0, 1, "第").append("天");
			}
		} else if ( ProdPackageGroup.GROUPTYPE.HOTEL.name().equals(pkg.getGroupType())) {
			String stayDays = pkg.getProdPackageGroupHotel().getStayDays();
			String[] days = stayDays.split(",");
			if(days.length == 1) {
				daysInfo.append("第").append(days[0]).append("晚");
			} else {
				daysInfo.append("第").append(days[0]).append("晚").append("—第").append( days[days.length -1] ).append("晚");
			}
		}
		return daysInfo.toString();
	}
	
	
	private List<Pair<String, ScenicHotelCostIncludeVo.Item> > getPackagedHotelNames(List<ProdPackageGroup> pkgList) {
		Map<Long, Long> detailId2BranchIdMap = new HashMap<Long, Long>();
		//detailId-> set<goodsId> 
		Map<Long, Set<Long>> detailId2GoodsIdMap = new HashMap<Long, Set<Long>>();
		for(ProdPackageGroup pkg : pkgList) {
			if ( ProdPackageGroup.GROUPTYPE.HOTEL.name().equals(pkg.getGroupType())) {
				if (pkg.getProdPackageDetails()!=null) {
					for(ProdPackageDetail detail  : pkg.getProdPackageDetails()) {
						detailId2BranchIdMap.put(detail.getDetailId(), detail.getObjectId());
					}
				}
				Long groupId = pkg.getGroupId();
				Map<Long, Long> goodsPackaged = findSuppGoodsIdsForOneGroup(groupId);
				//将 goodsId-> detailId 映射转换为  detailId-> 商品id 的映射
				for(Map.Entry<Long, Long> entry : goodsPackaged.entrySet()) {
					Long detailId = entry.getValue();
					Long goodsId = entry.getKey();
					if(!detailId2GoodsIdMap.containsKey(detailId)) {
						detailId2GoodsIdMap.put(detailId, new HashSet<Long>());
					}
					Set<Long> goodsList = detailId2GoodsIdMap.get(detailId);
					goodsList.add(goodsId);
					//如果打包到商品， 那就不需要从规格确定产品id了。
					detailId2BranchIdMap.remove(detailId);
				}
			}
		}
		
		//查询商品id对应的产品id, 然后构建goodsId -> productId映射
		Set<Long> goodsIdSet = new HashSet<Long>();
		for(Map.Entry<Long, Set<Long>> entry : detailId2GoodsIdMap.entrySet()) {
			goodsIdSet.addAll(entry.getValue());
		}
		
		Map<Long, Long> goodsId2ProductIdMap = new HashMap<Long, Long>();
		List<HotelGoodsVstVo>  goodsVoList = queryHotelGoodsById(new ArrayList<Long>(goodsIdSet));
		for(HotelGoodsVstVo vo : goodsVoList) {
			goodsId2ProductIdMap.put(vo.getSuppGoodsId(), vo.getProductId());
		}

		//branchId->productId
		Map<Long, Long> hotelProductIdMap = this.findHotelProcuctIdForBranchId(detailId2BranchIdMap.values());
		
		Set<Long> productIdSet = new HashSet<Long>();
		productIdSet.addAll(hotelProductIdMap.values());
		productIdSet.addAll(goodsId2ProductIdMap.values());
		
		List<HotelProductVstVo>  hotelProcutList = findHotelProductListByIds(new ArrayList<Long>( productIdSet ));
		Map<Long,HotelProductVstVo> id2ProductMap = new HashMap<>();
		if(hotelProcutList != null) {
			for(HotelProductVstVo vo : hotelProcutList) {
				id2ProductMap.put(vo.getProductId(), vo);
			}
		}
		
		List<Pair<String, ScenicHotelCostIncludeVo.Item> > hotelResult = new ArrayList<Pair<String, ScenicHotelCostIncludeVo.Item> >();
		for(ProdPackageGroup pkg : pkgList) {
			Pair<String, ScenicHotelCostIncludeVo.Item> pair = new Pair<String, ScenicHotelCostIncludeVo.Item>();
			if(ProdPackageGroup.GROUPTYPE.HOTEL.name().equals(pkg.getGroupType())){
				hotelResult.add(pair);
			} else {
				continue; //非景点和门票组， 略过
			}
			String daysInfo = getDaysInfo(pkg);
			//pair.setFirst(daysInfo);
			String productName = "";
			String productIds = "";
			if(pkg.getProdPackageDetails() != null) {
				//一个产品在一个组中只需要显示一次
				Set<Long> uniqueSet = new HashSet<Long>();
				for(ProdPackageDetail detail  : pkg.getProdPackageDetails()) {
					Long detailId = detail.getDetailId();
					Long branchId = detail.getObjectId();
					Long productId = null; 
					if(detailId2BranchIdMap.containsKey(detailId)) {
						//打包到规格
						productId = hotelProductIdMap.get(branchId);
					}else if(detailId2GoodsIdMap.containsKey(detailId)) {
						//打包到商品
						Set<Long> _goodsIdSet = detailId2GoodsIdMap.get(detailId);
						if(_goodsIdSet != null) {
							for(Long id : _goodsIdSet) {
								if(goodsId2ProductIdMap.containsKey(id)) {
									productId = goodsId2ProductIdMap.get(id);
									break;
								}
							}
						}
					}
					HotelProductVstVo product = id2ProductMap.get(productId);
					if(product != null && !uniqueSet.contains(productId)) {
						uniqueSet.add( productId );
						productName = productName + '/' + product.getProductName();
						productIds = productIds + "," + product.getProductId();
					}

				}
			}
			ScenicHotelCostIncludeVo.Item item = new ScenicHotelCostIncludeVo.Item();
			if(productIds.length() > 1) {
				item.setProductIds(productIds.substring(1));
			}
			if(productName.length() < 1) {
				//productName = "暂无可售产品";
			} else {
				String[] split = productName.split("/");
				if (split.length > 2) {
					productName=productName+"(多选一)";
				}
				productName = productName.substring(1);
				item.setContent(daysInfo+"  "+productName);
			}
			pair.setSecond(item);
		}
		return hotelResult;
	}
	
	private List<Pair<String, ScenicHotelCostIncludeVo.Item>>  getPackagedTicketNames (List<ProdPackageGroup> pkgList) {
		//branchId->detailId映射
		Map<Long, Long> detailId2BranchIdMap = new HashMap<Long, Long>();
		Map<Long, Set<Long>> detailId2GoodsIdMap = new HashMap<Long, Set<Long>>();
		Map<Long, Long> detailId2ProductIdMap = new HashMap<Long, Long>();
		Set<Long> needLoadGoodsBranchIdList = new HashSet<Long>();
		
		for(ProdPackageGroup pkg : pkgList) {
			if( ProdPackageGroup.GROUPTYPE.LINE_TICKET.name().equals( pkg.getGroupType()) ) {
				if(pkg.getProdPackageDetails() != null) {
					for(ProdPackageDetail detail : pkg.getProdPackageDetails()) {
						detailId2BranchIdMap.put(detail.getDetailId(), detail.getObjectId());
						needLoadGoodsBranchIdList.add(detail.getObjectId());
					}
				}
				Long groupId = pkg.getGroupId();
				// 商品id->detailId映射
				Map<Long, Long> goodsPackaged = findSuppGoodsIdsForOneGroup(groupId);
				if(goodsPackaged != null ) {
					for(Map.Entry<Long, Long> entry : goodsPackaged.entrySet()) {
						Long goodsId = entry.getKey();
						Long detailId = entry.getValue();
						if(!detailId2GoodsIdMap.containsKey(detailId)) {
							detailId2GoodsIdMap.put(detailId, new HashSet<Long>());
						}
						detailId2GoodsIdMap.get(detailId).add(goodsId);
					}
					//如果detailId2BranchIdMap中的detail 在goodsPackaged 中， 那么该detail就是打包到商品， 否则打包到规格
					Set<Long> detailIdSet = new HashSet<Long>(detailId2BranchIdMap.keySet() );
					for(Long detailId : detailIdSet) {
						if(goodsPackaged.containsValue(detailId)) {
							needLoadGoodsBranchIdList.remove(detailId2BranchIdMap.get(detailId));
						}
					}
				}

			}
		}
		
		Map<Long, GoodsBaseVo> id2GoodsVoMap = new HashMap<Long, GoodsBaseVo>();
		
		//打包到商品id, 根据商品id加载商品
		List<Long> ticketGoodsIdList = new ArrayList<Long>();
		for(Set<Long> set : detailId2GoodsIdMap.values()) {
			ticketGoodsIdList.addAll(set);
		}
		if(!ticketGoodsIdList.isEmpty()) {
			com.lvmama.scenic.api.vo.ResultHandleT<ArrayList<GoodsBaseVo>>  goodsWrapper = scenicSuppGoodsService.findSuppGoodsByIdList(ticketGoodsIdList);
			if(goodsWrapper != null && goodsWrapper.getReturnContent() != null) {
				for(GoodsBaseVo vo : goodsWrapper.getReturnContent()) {
					//有效可售
					if("Y".equals(vo.getCancelFlag()) && "Y".equals(vo.getOnlineFlag())) {
						if(!id2GoodsVoMap.containsKey(vo.getSuppGoodsId())) {
							id2GoodsVoMap.put(vo.getSuppGoodsId(), vo);
						}
					}
				}
			}
		}
		
		// 都往id2GoodsVoMap中塞值， 打包到商品的要先处理
		
		//只打包到规格， 根据branchId 加载商品
		List<GoodsBaseVo> goodsList = findTicketSuppGoodsForBranchIds(new ArrayList<Long>(needLoadGoodsBranchIdList));
		if(goodsList != null) {
			Map<Long, Set<Long>> branchId2GoodsIdMap = new HashMap<Long, Set<Long>>();
			for(GoodsBaseVo vo : goodsList) {
				//只要有效可售的
				if("Y".equals(vo.getCancelFlag()) && "Y".equals(vo.getOnlineFlag())) {
					if(!id2GoodsVoMap.containsKey( vo.getSuppGoodsId() )) {
						id2GoodsVoMap.put( vo.getSuppGoodsId() , vo);
					}
					if(!branchId2GoodsIdMap.containsKey(vo.getProductBranchId())) {
						branchId2GoodsIdMap.put(vo.getProductBranchId(), new HashSet<Long>());
					}
					branchId2GoodsIdMap.get(vo.getProductBranchId()).add(vo.getSuppGoodsId());
				}
			}
			for(Long detailId : detailId2BranchIdMap.keySet()) {
				Long branchId = detailId2BranchIdMap.get(detailId);
				Set<Long> goodsIdSet = branchId2GoodsIdMap.get(branchId);
				if(!detailId2GoodsIdMap.containsKey(detailId) && goodsIdSet != null) {
					detailId2GoodsIdMap.put(detailId, goodsIdSet);
				}
			}
			
		}
		
		//branchid->productId
		Map<Long, Long> ticketProductIdMap = this.findTicketProductIdForBranchId(new ArrayList<Long>(detailId2BranchIdMap.values()) );
		
		for(Long detailId : detailId2BranchIdMap.keySet()) {
			Long productId = ticketProductIdMap.get(detailId2BranchIdMap.get(detailId));
			//过滤无效的
			if(productId != null) {
				detailId2ProductIdMap.put(detailId, productId);
			}
		}
		
		Map<Long, ScenicProdProduct> id2ProductVoMap = new HashMap<Long, ScenicProdProduct>();
		Set<Long> productIdSet = new HashSet<Long>(ticketProductIdMap.values());
		List<ScenicProdProduct>  ticketProcutList = findTicketProcutListByIds(new ArrayList<Long>( productIdSet));
		for(ScenicProdProduct product : ticketProcutList) {
			id2ProductVoMap.put(product.getProductId(), product);
		}
		
		//根据商品id 查询对应的商品及封装vo
		List<Pair<String, ScenicHotelCostIncludeVo.Item>> result = new ArrayList<Pair<String, ScenicHotelCostIncludeVo.Item>>();
		
		for(ProdPackageGroup pkg : pkgList) {
			if( ProdPackageGroup.GROUPTYPE.LINE_TICKET.name().equals( pkg.getGroupType()) ) {
				String daysInfo = this.getDaysInfo(pkg);
				StringBuilder ids = new StringBuilder();
				StringBuilder names = new StringBuilder();
				if(pkg.getProdPackageDetails() != null) {
					for(ProdPackageDetail detail : pkg.getProdPackageDetails()) {
						Long detailId = detail.getDetailId();
						Set<Long> goodsIdSet = detailId2GoodsIdMap.get(detailId);
						Long productId = detailId2ProductIdMap.get(detailId);
						
						if(goodsIdSet == null || productId == null) {
							logger.info("productId:" + pkg.getProductId() + ", detailId: " + detailId + " isEmpty") ;
							continue;
						}
						com.lvmama.scenic.api.back.prod.po.ScenicProdProduct product = id2ProductVoMap.get(productId);
						if(goodsIdSet != null && product != null) {
							ids.append(productId).append(',');
							
							if (names.length()==0) {
								names.append(product.getProductName()).append("\n");
							}else {
								if (names.indexOf(product.getProductName())==-1) {
									names.append(product.getProductName()).append("\n");
								}
							}
						}
					}
				}
				Pair<String, ScenicHotelCostIncludeVo.Item> pair = new Pair<>();
				pair.setFirst(daysInfo);
				ScenicHotelCostIncludeVo.Item item = new ScenicHotelCostIncludeVo.Item();
				pair.setSecond(item );
				if(ids.length() > 0 ) {
					result.add(pair);
					String[] split = names.toString().split("\n");
					item.setProductIds(ids.substring(0, ids.length() -1));
					
					if(split.length>1){
						names.append("(多选一)");
					}else{
						if (names.toString().contains("\n")) {
							
							 String substring = names.substring(0, names.length()-2);
							 names = new StringBuilder(substring);
							 
						}
						
					}
					item.setContent(names.substring(0, names.length()));
					
				} else {
					//item.setContent("暂无可售门票商品");
				}
			}

		}
		return result;
	}
	
	private Map<Long, Long> findTicketProductIdForBranchId(Collection<Long> ticketBranchIdList) {
		Map<Long, Long> result = new HashMap<Long, Long>();
		if(ticketBranchIdList == null) {
			logger.debug("ticketBranchIdList is null");
			return result;
		}
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productBranchIdList", new ArrayList<Long>(ticketBranchIdList));
		params.put("omitBizBranch", true);
		List<ScenicProdProductBranch>  resultWrapper = null;
		try {
			resultWrapper = scenicProdProductBranchService.findProdProductBranchList(params);
		} catch (Exception e) {
			// TODO: handle exception
			return new HashMap<Long, Long>();
		}
		if (resultWrapper == null || resultWrapper.isEmpty() ) {
			return new HashMap<Long, Long>();
		}
		for(ScenicProdProductBranch branch : resultWrapper) {
			if ("Y".equals( branch.getCancelFlag() ) 
					&& "Y".equals(branch.getSaleFlag())) {
				//有效可售的
				result.put(branch.getProductBranchId(), branch.getProductId());
			}
		}
		return result;
	}
	
	
	private Map<Long , Long> findHotelProcuctIdForBranchId(Collection<Long> hotelBranchIdList) {
		Map<Long, Long> result = new HashMap<Long, Long>();
		
		if(hotelBranchIdList == null || hotelBranchIdList.isEmpty()) {
			return result;
		}
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productBranchIdList", new ArrayList<Long>(hotelBranchIdList));
		params.put("omitBizBranch", true);
		
		RequestBody<Map<String, Object>> request = new RequestBody<Map<String,Object>>();
		request.setT(params);
		request.setToken(Constant.DEST_BU_HOTEL_TOKEN);
		
		ResponseBody<List<HotelProductBranchVstVo>>   resultWrapper = hotelProdBranchQueryVstApiService.findProdProductBranchList(request);
		if (resultWrapper == null || resultWrapper.isFailure() ) {
			return new HashMap<Long, Long>();
		}
		List<Long> existsProductIds = new ArrayList<Long>();
		for(HotelProductBranchVstVo branch : resultWrapper.getT()) {
			if (!existsProductIds.contains(branch.getProductId()) 
					&& "Y".equals( branch.getCancelFlag() ) 
					&& "Y".equals(branch.getSaleFlag())) {
				//有效可售的
				result.put(branch.getProductBranchId(), branch.getProductId());
			}
		}
		return result;
	}
	
	
	private List<HotelGoodsVstVo> queryHotelGoodsById(List<Long> goodsIdList) {
		List<HotelGoodsVstVo> result = new ArrayList<HotelGoodsVstVo>();
		if(goodsIdList == null) {
			return result;
		}
		RequestBody<List<Long>> request = new RequestBody<List<Long>>();
		request.setT(goodsIdList);
		request.setToken(Constant.DEST_BU_HOTEL_TOKEN);
		ResponseBody<List<HotelGoodsVstVo>>  hotelGoodsVoList = hotelGoodsQueryVstApiService.findSuppGoodsByIdList(request);
		if(hotelGoodsVoList == null || hotelGoodsVoList.isFailure()) {
			logger.info("query hotel goods for " + goodsIdList + " failed");
		} else {
			for(HotelGoodsVstVo vo : hotelGoodsVoList.getT()) {
				if("Y".equals(vo.getCancelFlag()) && "Y".equals(vo.getOnlineFlag())  ) {
					result.add(vo);
				}
			}
		}
		return result;
	}
	
	private List<ScenicProdProduct>  findTicketProcutListByIds(List<Long> productIds) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productIdLst", productIds);
		List<ScenicProdProduct>  result = this.scenicProdProductService.findProdProductList(params, true);
		if(result == null) {
			result = new ArrayList<ScenicProdProduct>();
		}
		return result;
	}

	
	private List<HotelProductVstVo> findHotelProductListByIds(List<Long>  productIds) {
		if(productIds == null || productIds.isEmpty()) {
			return new ArrayList<HotelProductVstVo>();
		}
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productIdLst", productIds);
		
		RequestBody<HotelProductVstPo> requestBody = new RequestBody<HotelProductVstPo>();
		requestBody.setToken(Constant.DEST_BU_HOTEL_TOKEN);
		HotelProductVstPo hotelProductVstPo = new HotelProductVstPo();
		hotelProductVstPo.setParams(params);
		hotelProductVstPo.setHasProp(false);
		requestBody.setT(hotelProductVstPo);
		
		ResponseBody<List<HotelProductVstVo>> responseBody = hotelProductQrVstApiService.findProdProductList(requestBody);
		if(responseBody == null || responseBody.isFailure()) {
			return new ArrayList<HotelProductVstVo>();
		}
		return responseBody.getT();
	}
	
	private Map<Long, Long> findSuppGoodsIdsForOneGroup(Long groupId) {
		Map<String, Long> idMaps = new HashMap<String, Long>();
		idMaps.put("groupId", groupId);
		ResultHandleT<Map<Long,Long>> resultWrapper = suppGoodsHotelService.selectSuppGoodsIdsForOneGroup(idMaps);
		if(resultWrapper == null || resultWrapper.isFail()) {
			return new HashMap<Long, Long>();
		}
		return resultWrapper.getReturnContent();
	}
	
	private List<GoodsBaseVo> findTicketSuppGoodsForBranchIds (List<Long> branchIds) {
		if(branchIds == null || branchIds.isEmpty()) {
			return new ArrayList<GoodsBaseVo>();
		}
		com.lvmama.scenic.api.vo.ResultHandleT<PageVo<GoodsBaseVo>>  resultWrapper = scenicSuppGoodsService.findSuppGoodsByBranchIdList(branchIds);
		if(resultWrapper != null && resultWrapper.getReturnContent() != null) {
			PageVo<GoodsBaseVo> pageVo = resultWrapper.getReturnContent();
			return pageVo.getItems();
		}
		return new ArrayList<GoodsBaseVo>();
	}
	
	private ScenicTicketGoodsVo findTicketGoodsDetail(Long goodsId) {
		com.lvmama.scenic.api.vo.ResultHandleT<ScenicTicketGoodsVo> resultWrapper = scenicTicketGoodsService.findGoodsDetailSimple(goodsId);
		if(resultWrapper == null || resultWrapper.isFail()) {
			return null;
		}
		return resultWrapper.getReturnContent();
	}
	

	/**
	 * 记录行程操作日志,
	 * this.getLoginUser().getUserName() this style is not friendly to unit test ,
	 *  so call  this.getLoginUser().getUserName() in your action and pass userName in
	 */
	private void logLineRouteOperate(String currUserName, ProdLineRoute LineRoute, String logText, String logName) {
		try{
			ProdLineRoute pRoute=MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(LineRoute.getLineRouteId()));
			
			comLogService.insert(PROD_LINE_ROUTE, LineRoute.getProductId(), LineRoute.getLineRouteId(),
					currUserName, "【"+pRoute.getRouteName()+"】"+logText, PROD_TRAVEL_DESIGN.name(), logName, null);
		}catch(Exception e) {
			logger.error("Record Log failure ！Log Type:" + PROD_TRAVEL_DESIGN.name());
			logger.error(e.getMessage(), e);
		}
	}
	
	
	@SuppressWarnings("unchecked")
	public ScenicHotelTravelAlertVo mergeTravelAlertVo(ScenicHotelTravelAlertVo exists, ScenicHotelTravelAlertVo packaged){
		if(exists == null) {
			exists = new ScenicHotelTravelAlertVo();
		}
		if(packaged == null) {
			packaged = new ScenicHotelTravelAlertVo();
		}
		ScenicHotelTravelAlertVo result = new ScenicHotelTravelAlertVo();
		Map<String, String > stateMap = new HashMap<>();
		result.setStateMap(stateMap);
		
		List<ScenicHotel_HotelVo> hotelVoList = (List<ScenicHotel_HotelVo>) this.mergeOneList(exists.getHotelList(),
				packaged.getHotelList(), stateMap, ProdPackageGroup.GROUPTYPE.HOTEL.name() + "_");
		List<ScenicHotel_ScenicVo> scenicVoList = (List<ScenicHotel_ScenicVo>)this.mergeOneList(exists.getTicketList(), 
				packaged.getTicketList(), stateMap, ProdPackageGroup.GROUPTYPE.LINE_TICKET.name() + "_");
		result.setHotelList(hotelVoList);
		result.setTicketList(scenicVoList);
		
		result.setHotelExtra(exists.getHotelExtra());
		result.setTicketExtra(exists.getTicketExtra());
		result.setSupplements(exists.getSupplements());
		return result;
	}
	
	private List<? extends ScenicHotel_BaseVo> mergeOneList(List<? extends ScenicHotel_BaseVo> existedList, 
			List<? extends ScenicHotel_BaseVo> packagedList, Map<String, String> stateMap, 
					String keyPrefix){
		
		Map<Long, ScenicHotel_BaseVo> existedMap = new HashMap<Long, ScenicHotel_BaseVo>();
		Map<Long, ScenicHotel_BaseVo> packagedMap = new HashMap<Long, ScenicHotel_BaseVo>();
		Set<Long> uniqueProductIdSet = new HashSet<>();
		if(existedList != null) {
			for(ScenicHotel_BaseVo vo : existedList) {
				existedMap.put(vo.getId(), vo);
			}
		}
		
		if(packagedList != null) {
			for(ScenicHotel_BaseVo vo : packagedList) {
				packagedMap.put(vo.getId(), vo);
			}
		}
		
		uniqueProductIdSet.addAll(existedMap.keySet());
		uniqueProductIdSet.addAll(packagedMap.keySet());
		
		List<ScenicHotel_BaseVo> resultList = new ArrayList<>();
		// 比较item 和域， 确定是否是新增， 还是更改了
		for(Long productId : uniqueProductIdSet) {
			ScenicHotel_BaseVo existed = existedMap.get(productId);
			ScenicHotel_BaseVo packaged = packagedMap.get(productId);
			if(existed != null && packaged == null) {
				//被删了， 标识之
				stateMap.put(keyPrefix + productId, "2");
				resultList.add(existed);
			} else if(existed == null && packaged != null) {
				//新增
				stateMap.put(keyPrefix + productId, "1");
				resultList.add(packaged);
			} else {
				//都存在， 比较单个域
				ScenicHotel_BaseVo baseVo = mergeTravelAlertOneItemVo(existed, packaged);
				if(baseVo != null) {
					resultList.add(baseVo);
				}
			}
		}
		return resultList;
	}
	
	private ScenicHotel_BaseVo mergeTravelAlertOneItemVo(ScenicHotel_BaseVo exists, ScenicHotel_BaseVo packaged){
		if(exists instanceof ScenicHotel_HotelVo || packaged instanceof ScenicHotel_HotelVo) {
			return this.mergeTravelAlertOneHotelVo((ScenicHotel_HotelVo)exists, (ScenicHotel_HotelVo)packaged);
		} else if(exists instanceof ScenicHotel_ScenicVo || packaged instanceof ScenicHotel_ScenicVo) {
			return this.mergeTravelAlertOneTicketVo((ScenicHotel_ScenicVo)exists, (ScenicHotel_ScenicVo)packaged);
		} else if(exists instanceof ScenicHotel_ScenicGoodsVo || packaged instanceof ScenicHotel_ScenicGoodsVo) {
			return mergeTravelAlertOneTicketGoodsVo((ScenicHotel_ScenicGoodsVo)exists, (ScenicHotel_ScenicGoodsVo)packaged);
		}
		return null;
	}
	
	private ScenicHotel_HotelVo mergeTravelAlertOneHotelVo(ScenicHotel_HotelVo exists, ScenicHotel_HotelVo packaged) {
		Map<String, String>  state = new HashMap<>();
		packaged.setState(state);
		
		mergeTravelAlertOneField(exists.getAddress(), packaged.getAddress(), "address", state);
		mergeTravelAlertOneField(exists.getArriveTime(), packaged.getArriveTime(), "arriveTime", state);
		mergeTravelAlertOneField(exists.getLeaveTime(), packaged.getLeaveTime(), "leaveTime", state);
		mergeTravelAlertOneField(exists.getPhone(), packaged.getPhone(), "phone", state);
		mergeTravelAlertOneField(exists.getName(), packaged.getName(), "name", state);
		
		//’入住方式‘ 手工录入的， packaged肯定没值，所以直接赋值
		packaged.setCheckinStyle(exists.getCheckinStyle());
		mergeTravelAlertOneField(exists.getCheckinStyle(), packaged.getCheckinStyle(), "checkinStyle", state);
		return packaged;
	}
	
	private ScenicHotel_ScenicGoodsVo mergeTravelAlertOneTicketGoodsVo(ScenicHotel_ScenicGoodsVo exists, ScenicHotel_ScenicGoodsVo packaged) {
		Map<String, String>  state = new HashMap<>();
		packaged.setState(state);
		
		mergeTravelAlertOneField(exists.getName(), packaged.getName(), "name", state);
		mergeTravelAlertOneField(exists.getChangeAddress(), packaged.getChangeAddress(), "changeAddress", state);
		mergeTravelAlertOneField(exists.getChangeTime(), packaged.getChangeTime(), "changeTime", state);
		mergeTravelAlertOneField(exists.getEntryStyle(), packaged.getEntryStyle(), "entryStyle", state);
		mergeTravelAlertOneField(exists.getExpireDays(), packaged.getExpireDays(), "expireDays", state);
		mergeTravelAlertOneField(exists.getImportWarning(), packaged.getImportWarning(), "importWarning", state);
		mergeTravelAlertOneField(exists.getLimitTime(), packaged.getLimitTime(), "limitTime", state);
		return packaged;
	}
	
	
	@SuppressWarnings("unchecked")
	private ScenicHotel_ScenicVo mergeTravelAlertOneTicketVo(ScenicHotel_ScenicVo exists, ScenicHotel_ScenicVo packaged) {
		Map<String, String>  state = new HashMap<>();
		packaged.setState(state);
		
		mergeTravelAlertOneField(exists.getDestName(), packaged.getDestName(), "destName", state);
		mergeTravelAlertOneField(exists.getFreePolicy(), packaged.getFreePolicy(), "freePolicy", state);
		mergeTravelAlertOneField(exists.getPreferentialCrowd(), packaged.getPreferentialCrowd(), "preferentialCrowd", state);
		mergeTravelAlertOneField(exists.getName(), packaged.getName(), "name", state);
		mergeTravelAlertOneField(exists.getBookDescription(), packaged.getBookDescription(), "bookDescription", state);
		
		List<ScenicHotel_ScenicGoodsVo> existedList =  exists.getGoodsList();
		List<ScenicHotel_ScenicGoodsVo> packagedList = packaged.getGoodsList();
		List<ScenicHotel_ScenicGoodsVo> allGoodsList = (List<ScenicHotel_ScenicGoodsVo>)mergeOneList(existedList, packagedList, state, "TICKET_GOODS_");
		packaged.setGoodsList(allGoodsList);
		return packaged;
	}
	
	private void mergeTravelAlertOneField(String exists, String packaged, String key , Map<String, String> state) {
		if(exists == null && packaged == null) {
			return ;
		} else if(exists == null && packaged != null) {
			state.put(key, "Y");
			return;
		}
		//防止各个环境对回车换行的不同表示
		String existes1 = exists.replaceAll("[\r\n]", "");
		String packaged1 = packaged;
		if(packaged1 != null) {
			packaged1 = packaged1.replaceAll("[\r\n]", "");
		}
		if ( ! existes1.equals(packaged1)) {
			state.put(key, "Y");
		}
	}
	
	
	private void processTravelAlertLog(ScenicHotelTravelAlertVo travelAlertInnerVO, Long prodDescId, Long productId, String currentUserName ){
		StringBuilder sb = new StringBuilder();
		ScenicHotelTravelAlertVo  oldTravelAlertVo = null;
		if(prodDescId != null) {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("prodDescId", prodDescId);
			ResultHandleT<List<ProdProductDescription>>  resultWrapper = this.productDescriptionService.findProductDescriptionListByParams(params);
			if(resultWrapper != null && resultWrapper.getReturnContent() != null && !resultWrapper.getReturnContent().isEmpty()) {
				ProdProductDescription productDescription = resultWrapper.getReturnContent().get(0);
				oldTravelAlertVo = JSONObject.parseObject(productDescription.getContent(), ScenicHotelTravelAlertVo.class);
			}
		}
		
		if(travelAlertInnerVO != null ) {
			//先处理酒店
			if(travelAlertInnerVO.getHotelList() != null && !travelAlertInnerVO.getHotelList().isEmpty()) {
				List<ScenicHotel_HotelVo> newList = travelAlertInnerVO.getHotelList();
				List<ScenicHotel_HotelVo> oldList = null;
				if(oldTravelAlertVo != null && oldTravelAlertVo.getHotelList() != null) {
					oldList = oldTravelAlertVo.getHotelList();
				}
				String ticketLog = concateOneGroupLog(newList, oldList, ProdPackageGroup.GROUPTYPE.HOTEL);
				if(ticketLog != null && !ticketLog.isEmpty()) {
					sb.append(ticketLog);
				}
			} else {
				sb.append("酒店为空");
			}
			
			String currExtra = travelAlertInnerVO.getHotelExtra();
			String preExtra = oldTravelAlertVo != null ? oldTravelAlertVo.getHotelExtra() : null;
			appendExtra(currExtra, preExtra, sb, "酒店其他");
			
			
			//处理门票
			if(travelAlertInnerVO.getTicketList() != null && !travelAlertInnerVO.getTicketList().isEmpty()) {
				List<ScenicHotel_ScenicVo> newList = travelAlertInnerVO.getTicketList();
				List<ScenicHotel_ScenicVo> oldList = null;
				if(oldTravelAlertVo != null && oldTravelAlertVo.getTicketList() != null) {
					oldList = oldTravelAlertVo.getTicketList();
				}
				String ticketLog = concateOneGroupLog(newList, oldList, ProdPackageGroup.GROUPTYPE.LINE_TICKET);
				sb.append(ticketLog);
			} else {
				sb.append("门票为空");
			}
			currExtra = travelAlertInnerVO.getTicketExtra();
			preExtra = oldTravelAlertVo != null ? oldTravelAlertVo.getTicketExtra() : null;
			appendExtra(currExtra, preExtra, sb, "门票其他");
			//处理补充
			currExtra = travelAlertInnerVO.getSupplements();
			preExtra = oldTravelAlertVo != null ? oldTravelAlertVo.getSupplements() : null;
			appendExtra(currExtra, preExtra, sb, "补充");
		}
		
		if(logger.isDebugEnabled()) {
			logger.debug("------------>" + sb.toString());
		} else {
			if(sb.length() > 0) {
				comLogService.insert(com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE.PROD_PRODUCT_SUGG,
					productId, 
					productId, 
					currentUserName, 
					sb.toString(), 
					COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_SUGG_CHANGE.name(), 
					"修改产品", 
					null);
			}
		}
	}
	
	private void appendExtra(String currExtra , String preExtra, StringBuilder sb, String groupType ){
		if(currExtra != preExtra) {
			if(currExtra == null) {
				sb.append("删除" + groupType + preExtra);
			} else if(preExtra == null) {
				sb.append("新增" + groupType + currExtra);
			} else if(!preExtra.equals(currExtra)) {
				sb.append(groupType + "新值：【" + currExtra).append("】").append(groupType + "旧值:【" + preExtra).append("】");
			}
		}
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private String concateOneGroupLog(List<? extends ScenicHotel_BaseVo> newList, List<? extends ScenicHotel_BaseVo> oldList, 
			ProdPackageGroup.GROUPTYPE groupType) {
		StringBuilder sb = new StringBuilder();
		//确定新增和删除的列表
		List[] triplet = null;
		try{
			triplet = judgeAddDelteList(newList, oldList);
		}catch(BusinessException e) {
			String previous = oldList.toString();
			String current = newList.toString();
			if(!previous.equals(current)) {
				sb.append(groupType.getCnName() + "修改前").append(oldList).append("修改后").append(newList);
				return sb.toString();
			}
			return null;
		}
		List<ScenicHotel_BaseVo> addList = triplet[0];
		List<ScenicHotel_BaseVo> deleteList = triplet[1];
		List<ScenicHotel_BaseVo> sameNewList = triplet[2];
		List<ScenicHotel_BaseVo> sameOldList = triplet[3];
		
		if(addList != null && !addList.isEmpty()) {
			sb.append("新增" + groupType.getCnName()  + "【");
			for(ScenicHotel_BaseVo vo : addList) {
				sb.append(vo.getId() + "," + vo.getName()+ ";");
			}
			sb.append("】");
		}
		if(deleteList != null && !deleteList.isEmpty()) {
			sb.append("删除" + groupType.getCnName()  + "【");
			for(ScenicHotel_BaseVo vo : deleteList) {
				sb.append(vo.getId() + "," + vo.getName() + ";");
			}
			sb.append("】");
		}
		
		if(sameNewList != null && !sameNewList.isEmpty()) {
			sb.append("修改" + groupType.getCnName()  + "【");
			for(int i = 0; i< sameNewList.size(); i++) {
				ScenicHotel_BaseVo vo1 = sameNewList.get(i);
				ScenicHotel_BaseVo vo2 = sameOldList.get(i);
				
				sb.append("旧值:").append(vo2.toString() ).append(", 新值:").append(vo1.toString());
			}
			sb.append("】");
		}
		
		return sb.toString();
	}
	
	@SuppressWarnings("unchecked")
	private List<ScenicHotel_BaseVo>[] judgeAddDelteList(List<? extends ScenicHotel_BaseVo> newList, 
			List<? extends ScenicHotel_BaseVo> oldList){
		List<ScenicHotel_BaseVo> addList = new ArrayList<>();
		List<ScenicHotel_BaseVo> deleteList = new ArrayList<>();
		List<ScenicHotel_BaseVo> sameNewList = new ArrayList<>();
		List<ScenicHotel_BaseVo> sameOldList = new ArrayList<>();
		if(newList == null || newList.isEmpty()) {
			deleteList = (List<ScenicHotel_BaseVo>)oldList;
		} else if(oldList == null || oldList.isEmpty()) {
			addList = (List<ScenicHotel_BaseVo>)newList;
		} else {
			Map<Long, ScenicHotel_BaseVo> newMap = new HashMap<>();
			Map<Long,  ScenicHotel_BaseVo> oldMap = new HashMap<>();
			for(ScenicHotel_BaseVo vo : newList) {
				if(vo.getId() == null) {
					throw new BusinessException("非自主打包？");
				}
				newMap.put(vo.getId(), vo);
			}
			for(ScenicHotel_BaseVo vo : oldList) {
				if(vo.getId() == null) {
					throw new BusinessException("非自主打包？");
				}
				oldMap.put(vo.getId(), vo);
			}
			
			Set<Long> sameIdSet = new HashSet<Long>();
			for(Long id : newMap.keySet()) {
				if(!oldMap.containsKey(id)) {
					addList.add(newMap.get(id));
				} else {
					sameIdSet.add(id);
				}
			}
			
			for(Long id : sameIdSet) {
				ScenicHotel_BaseVo newVo = newMap.get(id);
				ScenicHotel_BaseVo oldVo = oldMap.get(id);
				if(!newVo.toString().equals(oldVo.toString())) {
					sameNewList.add(newVo);
					sameOldList.add(oldVo);
				}
			}
 			
			for(Long id : oldMap.keySet()) {
				if(!newMap.containsKey(id)) {
					deleteList.add(oldMap.get(id));
				} 
			}
			
		}

		return new List[]{addList, deleteList, sameNewList, sameOldList};
	}
	
	private void preProcessVo(ScenicHotelTravelAlertVo travelAlertInnerVO) {
		if (travelAlertInnerVO != null) {
			List<ScenicHotel_HotelVo> hotelList = travelAlertInnerVO.getHotelList();
			List<ScenicHotel_HotelVo> hotelList2 = new ArrayList<>();
			if (hotelList != null) {
				for (ScenicHotel_HotelVo vo : hotelList) {
					if (vo.getName() != null && !vo.getName().isEmpty()) {
						hotelList2.add(vo);
					}
				}
			}

			List<ScenicHotel_ScenicVo> ticketList = travelAlertInnerVO.getTicketList();
			List<ScenicHotel_ScenicVo> ticketList2 = new ArrayList<>();
			if (ticketList != null) {
				for (ScenicHotel_ScenicVo vo : ticketList) {
					if (vo.getName() != null && !vo.getName().isEmpty()) {
						ticketList2.add(vo);
					}
				}
			}
			travelAlertInnerVO.setHotelList(hotelList2);
			travelAlertInnerVO.setTicketList(ticketList2);
		}
	}
	
	
	private String getDestAddress(Long destId, Long lineProductId, Long ticketProductId) {
		if(destId == null) {
			return "";
		}
		String logInfo = "for lineProductId:" + lineProductId + ", query dest:" + destId + " for ticketProductId:" + ticketProductId;
		
		long currTime = System.currentTimeMillis();
		com.lvmama.phppid.vo.ResultHandleT<Map<String, Object>> wrap = destInfoService.getMuitiDestInfoByDestId(destId);
		
		boolean needRecord = false;
		long timeElapsed = System.currentTimeMillis() - currTime;
		if(timeElapsed > 500) {
			logInfo = logInfo + ", getMuitiDestInfoByDestId cost:" + timeElapsed + " Millis,";
			needRecord = true;
		}
		
		Map<String, Object> destInfo = null;
		if(wrap != null ) {
			destInfo = wrap.getReturnContent();
		}
		//{addressList=[{enAddress=, address=浙江省湖州市南浔镇人瑞路51号}]
		String address = null;
		if(destInfo != null) {
			List<Map<String, Object>> addressList = (List<Map<String, Object>>)destInfo.get("addressList");
			if(addressList != null && !addressList.isEmpty()) {
				address = (String)addressList.get(0).get("address");
			}
		}
		if(address == null || address.isEmpty()) {
			logInfo = logInfo + ", query address failed, rawInfo is" + destInfo;
			needRecord = true;
		}
		
		if(needRecord) {
			logger.info(logInfo);
		}
		
		return address;
	}
}
