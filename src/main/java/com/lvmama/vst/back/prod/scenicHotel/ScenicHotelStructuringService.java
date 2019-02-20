package com.lvmama.vst.back.prod.scenicHotel;

import java.util.List;
import java.util.Map;

import com.lvmama.vst.back.dujia.comm.prod.po.ProdProductDescription;
import com.lvmama.vst.back.dujia.comm.route.po.ProdLineRouteDescription;
import com.lvmama.vst.back.prod.po.ScenicHotelCostExcludeVo;
import com.lvmama.vst.back.prod.po.ScenicHotelCostIncludeVo;
import com.lvmama.vst.back.prod.po.ScenicHotelTravelAlertVo;
import com.lvmama.vst.comm.utils.Pair;

public interface ScenicHotelStructuringService {

	/**
	 * 出行警示， 加载被打包的产品信息
	 * @param productId
	 * @return
	 */
	public ScenicHotelTravelAlertVo  loadPackagedProcuctForTravelAlert (Long productId) ;
	
	/**
	 * 费用说明加载被打包的产品名称
	 * @param productId
	 * @return
	 */
	public Map<String, List<Pair<String, ScenicHotelCostIncludeVo.Item>>> loadPackagedProuctName(Long productId);
	
	/**
	 * 保存费用说明到ProdLineRouteDescription 表
	 * @param costIncludeInnerVO
	 * @param costExcludeInnerVO
	 * @param lineRouteDescription
	 * @return
	 */
	public boolean saveCost(ScenicHotelCostIncludeVo costIncludeInnerVO, ScenicHotelCostExcludeVo costExcludeInnerVO, ProdLineRouteDescription lineRouteDescription,
			String currentUserName);
	
	/**
	 * 从ProdLineRouteDescription加载费用说信息
	 * @param productId
	 * @param productType
	 * @param lineRouteId
	 * @return
	 */
	public Map<String, Object> loadCost(Long productId, String productType, Long lineRouteId ,Long categoryId);
	

	/**
	 * 保存出行警示信息到ProdProductDescription 表
	 * @param travelAlertInnerVO
	 * @param productDescription
	 * @param travleProdDescId
	 * @return
	 */
	public boolean saveTravelAlert(ScenicHotelTravelAlertVo travelAlertInnerVO, ProdProductDescription productDescription,
			Double modelVersion, String currentUserName);
	
	/**
	 * 从ProdProductDescription 加载出行警示信息
	 * @param productId
	 * @param productType
	 * @return
	 */
	public Map<String, Object> loadTravelAlert(Long productId, String productType) ;
	
	
	public ScenicHotelTravelAlertVo mergeTravelAlertVo(ScenicHotelTravelAlertVo exists, ScenicHotelTravelAlertVo packaged);
	
	//判断费用说明是否有变化
	public void judgeCostChangeState(ScenicHotelCostIncludeVo existsVo, Map<String, List<Pair<String, ScenicHotelCostIncludeVo.Item>>> packagedVo);
}

