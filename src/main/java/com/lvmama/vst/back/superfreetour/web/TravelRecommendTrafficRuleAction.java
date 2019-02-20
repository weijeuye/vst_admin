package com.lvmama.vst.back.superfreetour.web;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.service.BizDictQueryService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.superfreetour.service.TravelRecommendTrafficRuleService;
import com.lvmama.vst.back.superfreetour.util.PrUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.superfreetour.po.TravelRecommendTrafficRule;
@Controller
@RequestMapping("/superfreetour/travelRecommendTrafficRule")
public class TravelRecommendTrafficRuleAction extends BaseActionSupport{
	/**
	 * 旅游宝典交通规则ACTION
	 */
	private static final long serialVersionUID = -6209865883119715045L;
	
	private static final Log LOG = LogFactory.getLog(TravelRecommendTrafficRuleAction.class);
	@Autowired
	private TravelRecommendTrafficRuleService travelRecommendTrafficRuleService;
	@Autowired
	private ComLogClientService comLogService;
	@Autowired
    private BizDictQueryService bizDictQueryService;
	
	@RequestMapping(value = "/showHotelSetBox")
	public String showshowHotelSetBox(Model model, long hotelTimeId,HttpServletRequest req) {
		model.addAttribute("hotelTimeId", hotelTimeId);
		return "/superfreetour/travelRecommendRule/travelRecommendHotelRuleSetBox";
	}
	@RequestMapping(value = "/showUpdatetravelRecommendTrafficRule")
	public String showUpdatetravelRecommendTrafficRule(Model model, long recommendId,HttpServletRequest req) {
		
		//查询出老的导语显示到页面上
		TravelRecommendTrafficRule travelRecommendTrafficRule=travelRecommendTrafficRuleService.findTravelRecommendTrafficRuleByRecommendId(recommendId);
		
		model.addAttribute("recommendId", recommendId);
		model.addAttribute("travelRecommendTrafficRule", travelRecommendTrafficRule);
		
		return "/superfreetour/travelRecommendRule/travelRecommendResourceRule";
	}
	
	@RequestMapping(value="/updatetravelRecommendTrafficRule")
	@ResponseBody
	public Object updatetravelRecommendTrafficRule(Model model, HttpServletRequest req) {
		TravelRecommendTrafficRule travelRecommendTrafficRule =new TravelRecommendTrafficRule();
		 String trafficType=req.getParameter("rule-type");//对接类型
		 String cabinLevel=req.getParameter("rule-space");//舱位等级
		 String airCompanyFlag=req.getParameter("rule-boat");//航司要求
		 String transitFlag=req.getParameter("rule-transfer");//中转要求
		 String stopFlag=req.getParameter("rule-stop");//经停要求
		 String nightFlag=req.getParameter("rule-night");//隔夜要求
		 String goStartMin=req.getParameter("goStartMin");//出发起飞时间(小)
		 String goStartMax=req.getParameter("goStartMax");//出发起飞时间(大)
		 String goArriveMin=req.getParameter("goArriveMin");//出发到达时间(小)
		 String goArriveMax=req.getParameter("goArriveMax");//出发到达时间(大)
		 String backStartMin=req.getParameter("backStartMin");//返程出发时间(小)
		 String backStartMax=req.getParameter("backStartMax");//返程出发时间(大)
		 String trafficRuleId=req.getParameter("trafficRuleId");
		 String recommendId=req.getParameter("recommendId");
		 travelRecommendTrafficRule.setTrafficType(trafficType);
		 travelRecommendTrafficRule.setCabinLevel(cabinLevel);
		 travelRecommendTrafficRule.setAirCompanyFlag(airCompanyFlag);
		 travelRecommendTrafficRule.setTransitFlag(transitFlag);
		 travelRecommendTrafficRule.setStopFlag(stopFlag);
		 travelRecommendTrafficRule.setNightFlag(nightFlag);
		 travelRecommendTrafficRule.setGoStartMintime(goStartMin);
		 travelRecommendTrafficRule.setGoStartMaxtime(goStartMax);
		 travelRecommendTrafficRule.setGoArriveMintime(goArriveMin);
		 travelRecommendTrafficRule.setGoArriveMaxtime(goArriveMax);
		 travelRecommendTrafficRule.setBackStartMintime(backStartMin);
		 travelRecommendTrafficRule.setBackStartMaxtime(backStartMax);
		 travelRecommendTrafficRule.setRecommendId(Long.parseLong(recommendId));
		 if(trafficRuleId==null || trafficRuleId==""){
			 travelRecommendTrafficRule.setTrafficRuleId(null);
		 }else{
			 travelRecommendTrafficRule.setTrafficRuleId(Long.parseLong(trafficRuleId)); 
		 }
		
		//用于添加日志
		TravelRecommendTrafficRule oldtravelRecommendTrafficRule=travelRecommendTrafficRuleService.findTravelRecommendTrafficRuleByRecommendId(Long.parseLong(recommendId));
	
		try{
			
			if(PrUtil.isEmpty(trafficRuleId)){
				travelRecommendTrafficRuleService.insertTravelRecommendTrafficRule(travelRecommendTrafficRule);
			}else{
				travelRecommendTrafficRuleService.updateTravelRecommendTrafficRule(travelRecommendTrafficRule);
			}
			
			//用于添加日志
			TravelRecommendTrafficRule newtravelRecommendTrafficRule=travelRecommendTrafficRuleService.findTravelRecommendTrafficRuleByRecommendId(Long.parseLong(recommendId));
			// 添加操作LOG日志
			try {
				String log =  getTravelRecommendTrafficRuleLog(oldtravelRecommendTrafficRule	,newtravelRecommendTrafficRule);
				if(StringUtil.isNotEmptyString(log)){
					comLogService.insert(COM_LOG_OBJECT_TYPE.TRAVEL_RECOMMEND_TRAFFIC_RULE, 
							Long.parseLong(recommendId), Long.parseLong(recommendId), 
							this.getLoginUser().getUserName(),
							"修改宝典交通规则:" + log, 
							COM_LOG_LOG_TYPE.TRAVEL_RECOMMEND_TRAFFIC_RULE_CHANGE.name(), 
							"修改宝典交通规则",null);
				}

			} catch (Exception e) {
				LOG.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.TRAVEL_RECOMMEND_TRAFFIC_RULE_CHANGE.name());
				LOG.error(e.getMessage());
			}
			
		}catch (Exception e){
			LOG.error("修改旅游宝典导语失败,宝典ID:"+recommendId, e);
			return new ResultMessage(ResultMessage.ERROR, "保存失败"); 
		}
		
		return new ResultMessage(ResultMessage.SUCCESS, "保存成功"); 
		
	}
	
	
	 private String getTravelRecommendTrafficRuleLog(TravelRecommendTrafficRule oldTravelRecommendTrafficRule,TravelRecommendTrafficRule newTravelRecommendTrafficRule){
		 StringBuffer sb=new StringBuffer();
		 if(PrUtil.isEmpty(oldTravelRecommendTrafficRule) && !PrUtil.isEmpty(newTravelRecommendTrafficRule)){
			 sb.append(" 新增了旅游宝典交通规则");
		 }
		 if(!PrUtil.isEmpty(oldTravelRecommendTrafficRule) && !PrUtil.isEmpty(newTravelRecommendTrafficRule)){
			

			if(null !=judgeUpdateType(oldTravelRecommendTrafficRule.getTrafficType(),newTravelRecommendTrafficRule.getTrafficType())){
				 String newValue=newTravelRecommendTrafficRule.getTrafficType();
				sb.append(" 操作了对接类型,").append(judgeUpdateType(oldTravelRecommendTrafficRule.getTrafficType(),newValue));
				if("DUIJIE".equals(newValue)){
					sb.append("对接机票优先");
				}else if("QIEWEI".equals(newValue)){
					sb.append("切位机票优先");
				}else if("LIANGXIANG".equals(newValue)){
					sb.append("良翔机票优先");
				}
				sb.append("; ");
			} 
			
			if(null !=judgeUpdateType(oldTravelRecommendTrafficRule.getCabinLevel(),newTravelRecommendTrafficRule.getCabinLevel())){
				 String newValue=newTravelRecommendTrafficRule.getCabinLevel();
				sb.append(" 操作了舱位等级,").append(judgeUpdateType(oldTravelRecommendTrafficRule.getCabinLevel(),newValue));
				if("ECONOMY".equals(newValue)){
					sb.append("经济舱");
				}else if("BUSINESS".equals(newValue)){
					sb.append("公务舱");
				}else if("FIRST".equals(newValue)){
					sb.append("头等舱");
				}
				sb.append("; ");
			} 
			
			if(null !=judgeUpdateType(oldTravelRecommendTrafficRule.getStopFlag(),newTravelRecommendTrafficRule.getStopFlag())){
				 String newValue=newTravelRecommendTrafficRule.getStopFlag();
				 String oldValue=oldTravelRecommendTrafficRule.getStopFlag();
				sb.append(" 操作了经停,").append(judgeUpdateType(oldValue,newValue));
				if("Y".equals(newValue)){
					sb.append("无经停");
				}else {
					sb.append("无");
				}
				sb.append("; ");
			} 
			
			if(null !=judgeUpdateType(oldTravelRecommendTrafficRule.getNightFlag(),newTravelRecommendTrafficRule.getNightFlag())){
				 String newValue=newTravelRecommendTrafficRule.getNightFlag();
				 String oldValue=oldTravelRecommendTrafficRule.getNightFlag();
				sb.append(" 操作了隔夜航班,").append(judgeUpdateType(oldValue,newValue));
				if("Y".equals(newValue)){
					sb.append("无隔夜");
				}else {
					sb.append("无");
				}
				sb.append("; ");
			} 
			if(null !=judgeUpdateType(oldTravelRecommendTrafficRule.getTransitFlag(),newTravelRecommendTrafficRule.getTransitFlag())){
				 String newValue=newTravelRecommendTrafficRule.getTransitFlag();
				 String oldValue=oldTravelRecommendTrafficRule.getTransitFlag();
				sb.append(" 操作了中转,").append(judgeUpdateType(oldValue,newValue));
				if("Y".equals(newValue)){
					sb.append("无中转");
				}else {
					sb.append("无");
				}
				sb.append("; ");
			}
			
			if(null !=judgeUpdateType(oldTravelRecommendTrafficRule.getGoStartMintime(),newTravelRecommendTrafficRule.getGoStartMintime())){
				 String newValue=newTravelRecommendTrafficRule.getGoStartMintime();
				 String oldValue=oldTravelRecommendTrafficRule.getGoStartMintime();
				sb.append(" 操作了去程出发最早时间,旧值为： "+oldValue==null?"无":"oldValue"+",").append(judgeUpdateType(oldValue,newValue));
				sb.append(newValue + "; ");
			}
			if(null !=judgeUpdateType(oldTravelRecommendTrafficRule.getGoStartMaxtime(),newTravelRecommendTrafficRule.getGoStartMaxtime())){
				 String newValue=newTravelRecommendTrafficRule.getGoStartMaxtime();
				 String oldValue=oldTravelRecommendTrafficRule.getGoStartMaxtime();
				sb.append(" 操作了去程出发最晚时间,旧值为： "+oldValue==null?"无":"oldValue"+",").append(judgeUpdateType(oldValue,newValue));
				sb.append(newValue + "; ");
			}
			if(null !=judgeUpdateType(oldTravelRecommendTrafficRule.getGoArriveMintime(),newTravelRecommendTrafficRule.getGoArriveMintime())){
				 String newValue=newTravelRecommendTrafficRule.getGoArriveMintime();
				 String oldValue=oldTravelRecommendTrafficRule.getGoArriveMintime();
				sb.append(" 操作了去程到达最早时间,旧值为： "+oldValue==null?"无":"oldValue"+",").append(judgeUpdateType(oldValue,newValue));
				sb.append(newValue + "; ");
			}
			if(null !=judgeUpdateType(oldTravelRecommendTrafficRule.getGoArriveMaxtime(),newTravelRecommendTrafficRule.getGoArriveMaxtime())){
				 String newValue=newTravelRecommendTrafficRule.getGoArriveMaxtime();
				 String oldValue=oldTravelRecommendTrafficRule.getGoArriveMaxtime();
				sb.append(" 操作了去程出发最晚时间,旧值为： "+oldValue==null?"无":"oldValue"+",").append(judgeUpdateType(oldValue,newValue));
				sb.append(newValue + "; ");
			}
			if(null !=judgeUpdateType(oldTravelRecommendTrafficRule.getBackStartMintime(),newTravelRecommendTrafficRule.getBackStartMintime())){
				 String newValue=newTravelRecommendTrafficRule.getBackStartMintime();
				 String oldValue=oldTravelRecommendTrafficRule.getBackStartMintime();
				sb.append(" 操作了返程出发最早时间,旧值为： "+oldValue==null?"无":"oldValue"+",").append(judgeUpdateType(oldValue,newValue));
				sb.append(newValue + "; ");
			}
			if(null !=judgeUpdateType(oldTravelRecommendTrafficRule.getBackStartMaxtime(),newTravelRecommendTrafficRule.getBackStartMaxtime())){
				 String newValue=newTravelRecommendTrafficRule.getBackStartMaxtime();
				 String oldValue=oldTravelRecommendTrafficRule.getBackStartMaxtime();
				sb.append(" 操作了返程出发最晚时间,旧值为： "+oldValue==null?"无":"oldValue"+",").append(judgeUpdateType(oldValue,newValue));
				sb.append(newValue + "; ");
			}
		 }
		return sb.toString();
		 
	 }

	 private String judgeUpdateType(Object oldValue,Object newValue){
		 String st=null;
		 if(PrUtil.isEmpty(oldValue) && !PrUtil.isEmpty(newValue)){
			 st="新增值为：";
		 }
		 if(!PrUtil.isEmpty(oldValue) && !PrUtil.isEmpty(newValue)){
			if(!oldValue.equals(newValue)){
			 st="新值为：";
			}
		 }
		 if(!PrUtil.isEmpty(oldValue) && PrUtil.isEmpty(newValue)){
			 st="新值为：";
			 }
		
		return st;
		 
	 }
	 
	 
}
