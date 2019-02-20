package com.lvmama.vst.back.superfreetour.web;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.api.util.StringUtil;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.superfreetour.service.TravelHotelRuleService;
import com.lvmama.vst.back.superfreetour.service.TravelRecommendService;
import com.lvmama.vst.back.superfreetour.util.PrUtil;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.superfreetour.po.TravelHotelSort;
import com.lvmama.vst.superfreetour.po.TravelHotelTime;
import com.lvmama.vst.superfreetour.vo.TravelRecommendVo;

/**
 * 旅游宝典的酒店规则Action
 * @author zhangdewen
 */
@Controller
@RequestMapping("/superfreetour/travelHotelRule")
public class TravelHotelRuleAction extends BaseActionSupport {
	private static final long serialVersionUID = -4568769879078078L;
	
	private static final Log LOG = LogFactory.getLog(TravelHotelRuleAction.class);

	@Autowired
	private TravelHotelRuleService hotelRuleService;
	
	@Autowired
	private ComLogClientService comLogService;
	
	 @Autowired
	 private TravelRecommendService travelRecommendService;
	 
	private final static int HOTEL_SEARCH_PAGE_NUM = 2;
	private final static int HOTEL_SEARCH_PAGE_SIZE = 100;
	
	/**
	 * 查询酒店时间段和第一个时间段的酒店排序，跳转到旅游宝典的酒店规则设置首页
	 */
	@RequestMapping(value = "/showHotelRule")
	public String showUpdateTravelRoute(Model model, Long recommendId) throws BusinessException {
		if(recommendId == null){
			LOG.warn("showUpdateTravelRoute error. recommendId=" + recommendId);
			return "/superfreetour/showHotelRuleList";
		}
		//获取旅游宝典的酒店所有时段段
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("recommendId", recommendId);		
		List<TravelHotelTime> hotelTimeList =  hotelRuleService.findTravelHotelTime(params);
		if(CollectionUtils.isNotEmpty(hotelTimeList)){
			//转换时间段显示格式, 如"1,2",转化为"D1,D2"
			for(TravelHotelTime hotelTime : hotelTimeList){
				if(hotelTime != null){
					String days = hotelTime.getDays();
					if(StringUtil.isNotEmptyString(days)){
						StringBuffer buf = new StringBuffer();
						String tempDays[] = days.split(",");
						int index = 1;
						for(String day : tempDays){
							if(index++ != 1){
								buf.append(",");
							}
							buf.append("D").append(day);
						}
						hotelTime.setDays(buf.toString());
					}
				}
			}
			model.addAttribute("hotelTimeList", hotelTimeList);
			
			//获取第一个时间段的酒店排序
			TravelHotelTime hotelTime = hotelTimeList.get(0);
			if(hotelTime != null){
				params = new HashMap<String, Object>();
				params.put("hotelTimeId", hotelTime.getHotelTimeId());
				model.addAttribute("hotelTimeId", hotelTime.getHotelTimeId());				
				List<TravelHotelSort> hotelSortList =  hotelRuleService.findTravelHotelSort(params);
				if(CollectionUtils.isNotEmpty(hotelSortList)){
					model.addAttribute("hotelSortList", hotelSortList);
				}
			}
		}
		return "/superfreetour/travelRecommendRule/travelRecommendHotelRule";
	}
	
	/**						
	 * 获取某天的酒店排序结果					
	 * @throws Exception 
	 */					
	@RequestMapping(value = "/getHotelSortList")					
	public String  getHotelSortist(Model model,Long hotelTimeId) throws Exception {					
		if(hotelTimeId == null){				
			LOG.warn("getHotelSortList error. hotelTimeId=" + hotelTimeId);			
			throw new Exception("没有获取正确的时间段Id，获取失败");
		}				
		//获取某天的酒店排序结果				
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("hotelTimeId", hotelTimeId);				
		List<TravelHotelSort> hotelSortList =  hotelRuleService.findTravelHotelSort(params);				
		Map<String, Object> attributes = new HashMap<String, Object>();				
		attributes.put("hotelSortList", hotelSortList);				
		model.addAttribute("hotelTimeId",hotelTimeId);				
		model.addAttribute("hotelSortList", hotelSortList);				
		return "/superfreetour/travelRecommendRule/travelRecommendAjaxHotelByTimeId";				
						
	}					

	
	/**						
	 * 查询酒店					
	 * @throws Exception 
	 */					
	@RequestMapping(value = "/searchHotel")					
	public String searchHotel(Model model,Long recommendId, TravelHotelSort hotelSort) throws Exception {					
		if(recommendId == null || hotelSort == null){				
			LOG.warn("searchHotel error. destId=" + recommendId + ", hotelSort=" + hotelSort);			
			throw new Exception("查询条件为空，查询酒店失败");		
		}
		TravelRecommendVo travelRecommendVo = travelRecommendService.findTravelRecommendVoAndTagById(recommendId);
		if(PrUtil.isEmpty(travelRecommendVo) || PrUtil.isEmpty(travelRecommendVo.getDestDistrictId())){
			throw new Exception("旅游宝典目的地为空，无法根据目的地查询酒店！");
		}
		//搜索酒店,只搜索200条		
		List<TravelHotelSort> hotelSortList = new ArrayList<TravelHotelSort>();		
		for(int i=1; i<=HOTEL_SEARCH_PAGE_NUM; i++){
			List<TravelHotelSort> tempHotelSortList = hotelRuleService.searchHotel(travelRecommendVo.getDestDistrictId(),
					hotelSort, i, HOTEL_SEARCH_PAGE_SIZE);
			if(CollectionUtils.isNotEmpty(tempHotelSortList)){
				hotelSortList.addAll(tempHotelSortList);
			}			
		}
			
		model.addAttribute("hotelSortList", hotelSortList);		
		
		return "/superfreetour/travelRecommendRule/travelRecommendHotelBoxResult";			
		}				
	
	/**
	 * 新增酒店时间段
	 */
	@RequestMapping(value = "/addTravelHotelTime")
	@ResponseBody
	public Object addTravelHotelTime(String hotelTime,Long recommendId) throws BusinessException {
		if(hotelTime == null || recommendId == null){
			LOG.warn("addTravelHotelTime error. hotelTime=" + hotelTime);
			return new ResultMessage("error", "新增时间段失败");
		}
		TravelHotelTime travelTotelTime =new TravelHotelTime();
		travelTotelTime.setDays(hotelTime);
		travelTotelTime.setRecommendId(recommendId);
		Long hotelTimeId = hotelRuleService.insertTravelHotelTime(travelTotelTime);
		if(hotelTimeId > 0){
			Map<String, Object> attributes = new HashMap<String, Object>();
			attributes.put("hotelTimeId", hotelTimeId);
			// 添加操作日志
			try {
				comLogService.insert(COM_LOG_OBJECT_TYPE.TRAVEL_RECOMMEND_HOTEL_RULE, travelTotelTime.getRecommendId(), 
						hotelTimeId, this.getLoginUser().getUserName(), "新增时间段:"+ travelTotelTime.getDays(),
						COM_LOG_LOG_TYPE.TRAVEL_HOTEL_RULE_CHANGE.name(), "新增时间段", null);
			} catch (Exception e) {
				log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.TRAVEL_HOTEL_RULE_CHANGE.name(), e);
			}
			return new ResultMessage(attributes, "success", "保存成功");
		} else {
			return new ResultMessage("error", "新增时间段失败");
		}
	}
	
	/**
	 * 删除某个酒店时间段
	 */
	@RequestMapping(value = "/deleteTravelHotelTime")
	@ResponseBody
	public Object deleteTravelHotelTime(Long hotelTimeId) throws BusinessException {
		if(hotelTimeId == null){
			LOG.warn("deleteTravelHotelTime error. hotelTimeId=" + hotelTimeId);
			return new ResultMessage("error", "未获取时间段Id，删除失败");
		}
		
		TravelHotelTime hotelTime = hotelRuleService.findTravelHotelTimeById(hotelTimeId);
		//删除某个酒店时间段，同时删除该时段的酒店排序		
		try {
			hotelRuleService.deleteTravelHotelTime(hotelTime);
		} catch (Exception e) {
			log.error("deleteTravelHotelSort fail.", e);
			return new ResultMessage("error", "删除失败");
		}
		
		//添加操作日志
		try {
			comLogService.insert(COM_LOG_OBJECT_TYPE.TRAVEL_RECOMMEND_HOTEL_RULE, hotelTime.getRecommendId(), 
					hotelTimeId, this.getLoginUser().getUserName(), "删除酒店时间段:"+ hotelTime.getDays(),
					COM_LOG_LOG_TYPE.TRAVEL_HOTEL_RULE_CHANGE.name(), "删除酒店时间段", null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.TRAVEL_HOTEL_RULE_CHANGE.name(), e);
		}
		return new ResultMessage("success", "删除成功");
	}
	
	/**
	 * 保存酒店排序
	 */
	@RequestMapping(value = "/saveTravelHotelSort")
	@ResponseBody
	public Object saveTravelHotelSort(Long hotelTimeId,String hotelSortStr) throws BusinessException {
		/*if(PrUtil.isEmpty(hotelSortStr)){
			LOG.warn("saveTravelHotelSort error. hotelSortList=" + hotelSortStr);
			return new ResultMessage("error", "没有获取数据，保存失败");
		}*/
		JSONArray array = JSONArray.fromObject(hotelSortStr);				
		TravelHotelSort[] guides = (TravelHotelSort[]) JSONArray.toArray(array,TravelHotelSort.class);				
		List<TravelHotelSort> hotelSortList = Arrays.asList(guides);				
		Long index = 1L;
		for(TravelHotelSort hotelSort : hotelSortList){
			hotelSort.setPriority(index++);
			hotelSort.setHotelTimeId(hotelTimeId);
		}
		TravelHotelTime hotelTime = hotelRuleService.findTravelHotelTimeById(hotelTimeId);
		int result = hotelRuleService.updateTravelHotelSort(hotelTime, hotelSortList);
		if(result > 0){
			// 添加操作日志
			try {
				comLogService.insert(COM_LOG_OBJECT_TYPE.TRAVEL_RECOMMEND_HOTEL_RULE, hotelTime.getRecommendId(), 
						hotelTimeId, this.getLoginUser().getUserName(), "保存酒店排序时间段:"+ hotelTime.getDays(),
						COM_LOG_LOG_TYPE.TRAVEL_HOTEL_RULE_CHANGE.name(), "保存酒店排序", null);
			} catch (Exception e) {
				log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.TRAVEL_HOTEL_RULE_CHANGE.name(), e);
			}
			return new ResultMessage("success", "保存成功");
		} else {
			return new ResultMessage("error", "保存失败");
		}
	}
	
	/**
	 * 删除某个时间段的酒店排序
	 */
	@RequestMapping(value = "/deleteTravelHotelSort")
	@ResponseBody
	public Object deleteTravelHotelSort(Long hotelTimeId) throws BusinessException {
		if(hotelTimeId == null){
			LOG.warn("deleteTravelHotelSort error. hotelTimeId=" + hotelTimeId);
			return new ResultMessage("error", "未获取时间段Id，清除失败");
		}
		
		//删除某个时间段的酒店排序
		TravelHotelTime hotelTime = hotelRuleService.findTravelHotelTimeById(hotelTimeId);
		try {
			hotelRuleService.deleteTravelHotelSort(hotelTime);
		} catch (Exception e) {
			log.error("deleteTravelHotelSort fail.", e);
			return new ResultMessage("error", "清除失败");
		}
		
		//添加操作日志
		try {
			comLogService.insert(COM_LOG_OBJECT_TYPE.TRAVEL_RECOMMEND_HOTEL_RULE, hotelTime.getRecommendId(), 
					hotelTimeId, this.getLoginUser().getUserName(), "清除酒店排序，时间段:"+ hotelTime.getDays(),
					COM_LOG_LOG_TYPE.TRAVEL_HOTEL_RULE_CHANGE.name(), "清除酒店排序", null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.TRAVEL_HOTEL_RULE_CHANGE.name(), e);
		}
		return new ResultMessage("success", "清除成功");
	}

}
