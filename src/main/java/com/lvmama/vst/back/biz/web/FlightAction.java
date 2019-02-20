package com.lvmama.vst.back.biz.web;


import java.lang.reflect.Field;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.lvmama.channel.util.StringUtil;
import com.lvmama.vst.comm.utils.web.HttpServletLocalThread;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizDict;
import com.lvmama.vst.back.biz.po.BizDistrict;
import com.lvmama.vst.back.biz.po.BizDistrictSign;
import com.lvmama.vst.back.biz.po.BizFlight;
import com.lvmama.vst.back.biz.service.BizFlightService;
import com.lvmama.vst.back.client.biz.service.DictClientService;
import com.lvmama.vst.back.client.biz.service.DistrictClientService;
import com.lvmama.vst.back.client.biz.service.DistrictSignClientService;
import com.lvmama.vst.comlog.LvmmLogClientService;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

@Controller
@RequestMapping("/biz/flight")
public class FlightAction extends BaseActionSupport {

    private static final long serialVersionUID = 1130354069750493897L;

    @Autowired
    private BizFlightService bizFlightService;

    @Autowired
    private DictClientService bizDictQueryService;

    @Autowired
    private DistrictClientService districtService;

    @Autowired
    private DistrictSignClientService districtSignService;
    
	@Autowired
	private LvmmLogClientService lvmmLogClientService;

    @RequestMapping("/findFlightList")
    public String findFlightList(BizFlight bizFlight, Integer page, Model model, HttpServletRequest request)
            throws BusinessException {

        HashMap<String, Object> parameters = new HashMap<String, Object>(5);
        String flightNo = bizFlight.getFlightNo() == null ? null : bizFlight.getFlightNo().trim();
        parameters.put("flightNo", flightNo);
        parameters.put("startDistrict", bizFlight.getStartDistrict());
        parameters.put("arriveDistrict", bizFlight.getArriveDistrict());
        parameters.put("airline", bizFlight.getAirline());
        parameters.put("like", "Y"); // 航班号模糊查询
        fillBizFlight(bizFlight);
        int count = bizFlightService.findBizFlightCount(parameters);
        Page<BizFlight> pager = Page.page(count, 10L, (page == null ? 1L : page.longValue()));
        pager.buildUrl(request);
        parameters.put("_start", pager.getStartRows());
        parameters.put("_end", pager.getEndRows());
        parameters.put("_orderby", "FLIGHT_ID");
        parameters.put("_order", "DESC");
        List<BizFlight> bizFlights = bizFlightService.selectFlightListByParams(parameters);
//        for (BizFlight flight: bizFlights) {
//            fillBizFlight(flight);
//           
//        }
        pager.setItems(bizFlights);
        model.addAttribute("pager", pager);
        model.addAttribute("flightNo", bizFlight.getFlightNo());
        model.addAttribute("startDistrict", bizFlight.getStartDistrict());
        model.addAttribute("startDistrictString", bizFlight.getStartDistrictString());
        model.addAttribute("arriveDistrict", bizFlight.getArriveDistrict());
        model.addAttribute("arriveDistrictString", bizFlight.getArriveDistrictString());
        model.addAttribute("airline", bizFlight.getAirline());
        model.addAttribute("page", pager.getPage().toString());

        return "/biz/flight/findFlightList";
    }

    @RequestMapping(value = "/addFlight")
    @ResponseBody
    public Object addFlight(BizFlight bizFlight) throws BusinessException {
        setFlightTime(bizFlight);
        int result = bizFlightService.insertSelective(bizFlight);
        return result == 0 ? ResultMessage.ADD_FAIL_RESULT : ResultMessage.ADD_SUCCESS_RESULT;
    }

    @RequestMapping(value = "/updateFlight")
    @ResponseBody
    public Object updateFlight(BizFlight bizFlight) throws BusinessException {
    	BizFlight oldFlight = bizFlightService.selectByPrimaryKey(bizFlight.getFlightId());
        setFlightTime(bizFlight);
        int result = bizFlightService.updateByPrimaryKey(bizFlight);
        try{
        	fillBizFlight(bizFlight);
        	fillBizFlight(oldFlight);
        	String[] logString = {"flightNo","airlineString","startAirportString","arriveAirportString","startTerminal","arriveTerminal","startDistrictString"
  	    		  , "arriveDistrictString","startTime","arriveTime","stopCount","airplaneString","flightTimeHour","flightTimeMinute","shareFlightNo"};
        	String logText= logStr(oldFlight,bizFlight,logString);
        	if(StringUtil.isNotEmptyString(logText)){
        		lvmmLogClientService.sendLog(COM_LOG_OBJECT_TYPE.BIZ_FLIGHT_OPER, bizFlight.getFlightId(), bizFlight.getFlightId(),
    					this.getLoginUser().getUserName(), logText, COM_LOG_LOG_TYPE.BIZ_FLIGHT_UPDATE.name(), "修改航班信息", null);
        	}
        }catch(Exception e){
        	log.error(bizFlight.getFlightId() +"记录日志失败"+e);
        }
        return result == 0 ? ResultMessage.UPDATE_FAIL_RESULT : ResultMessage.UPDATE_SUCCESS_RESULT;
    }
    // 记录 string的日志logString为需要记录的字段
    public String logStr(BizFlight old,BizFlight bizFlight,String[] logString ){
    		StringBuffer sb = new StringBuffer();
	       Class oldClass = (Class) old.getClass();  
	       Class bizFlightClass = (Class) bizFlight.getClass(); 
	       // 得到类中的所有属性集合 
	       Field[] oldFs = oldClass.getDeclaredFields(); 
	       Field[] newFs = bizFlightClass.getDeclaredFields(); 
	       
	       try {
	    	   for(int i = 0 ; i < oldFs.length; i++){  
		           Field f = oldFs[i];  
		           f.setAccessible(true); //设置些属性是可以访问的  
		           Object val = f.get(old);//得到此属性的值     
		           if(logString!=null && Arrays.asList(logString).contains(f.getName())){
		        	   for(int j = 0; j < newFs.length; j++){
			        	   Field Nf = newFs[j];  
			        	   Nf.setAccessible(true); //设置些属性是可以访问的  
				           Object val2 = Nf.get(bizFlight);//得到此属性的值    
			        	   if(Nf.getName().equals(f.getName())){
			        		   if(val!=null && !"".equals(val)){
			        			   if(!val.equals(val2)){
						        	  sb.append("修改" + f.getName()+"原值为【"+val+"】，新值为【" +val2+"】。");
						        	  break;
						           }
			        		   }else if(val2!=null && !"".equals(val2)){
			        			   sb.append("新增" + f.getName()+"值为【" +val2+"】。");
			        			   break;
			        		   }
			        		   break;
					           
			        	   } 
			           }  
		           }
		           
		       }  
		} catch (Exception e) {
			System.out.println(e);
		} 
    	return sb.toString();
    }

    @RequestMapping(value = "/showAddFlight")
    public String showAddFlight(Model model) {

        return "/biz/flight/showAddFlight";
    }

    @RequestMapping(value = "/showUpdateFlight")
    public String showUpdateFlight(Long flightId, Model model) {
        BizFlight bizFlight = bizFlightService.selectByPrimaryKey(flightId);
        fillBizFlight(bizFlight);
        model.addAttribute("bizFlight", bizFlight);
        fillBizFlight(bizFlight);
        return "/biz/flight/showUpdateFlight";
    }

    @RequestMapping(value = "/setCancelFlag")
    @ResponseBody
    public Object setCancelFlag(BizFlight bizFlight) throws BusinessException {
        int result = bizFlightService.updateCancelFlag(bizFlight);
        return result == 0 ? ResultMessage.UPDATE_FAIL_RESULT : ResultMessage.UPDATE_SUCCESS_RESULT;
    }

    private void fillBizFlight(BizFlight bizFlight) {
        if (bizFlight == null) {
            return;
        }
        // 航空公司
        if (bizFlight.getAirline() != null) {
            BizDict dict = MiscUtils.autoUnboxing( bizDictQueryService.findDictById(bizFlight.getAirline()) );
            if (dict != null) {
                bizFlight.setAirlineString(dict.getDictName());
            }
        }
        // 机型
        if (bizFlight.getAirplane() != null) {
            BizDict dict = MiscUtils.autoUnboxing( bizDictQueryService.findDictById(bizFlight.getAirplane()) );
            if (dict != null) {
                bizFlight.setAirplaneString(dict.getDictName());
            }
        }
        // 出发城市
        if (bizFlight.getStartDistrict() != null) {
            BizDistrict district = MiscUtils.autoUnboxing( districtService.findDistrictById(bizFlight.getStartDistrict()) );
            if (district != null) {
                bizFlight.setStartDistrictString(district.getDistrictName());
            }
        }
        // 抵达城市
        if (bizFlight.getArriveDistrict() != null) {
            BizDistrict district = MiscUtils.autoUnboxing( districtService.findDistrictById(bizFlight.getArriveDistrict()) );
            if (district != null) {
                bizFlight.setArriveDistrictString(district.getDistrictName());
            }
        }
        // 始发机场
        if (bizFlight.getStartAirport() != null) {
            BizDistrictSign bizDistrictSign = MiscUtils.autoUnboxing( districtSignService.findDistrictSignById(bizFlight.getStartAirport()) );
            if (bizDistrictSign != null) {
                bizFlight.setStartAirportString(bizDistrictSign.getSignName());
            }
        }
        // 到达机场
        if (bizFlight.getArriveAirport() != null) {
            BizDistrictSign bizDistrictSign = MiscUtils.autoUnboxing( districtSignService.findDistrictSignById(bizFlight.getArriveAirport()) );
            if (bizDistrictSign != null) {
                bizFlight.setArriveAirportString(bizDistrictSign.getSignName());
            }
        }
    }

    @RequestMapping(value = "/showSelectFlight")
    public String showSelectFlight(String flightNumber, Long startDistrict, Long arriveDistrict, Integer page,
            Model model) throws BusinessException {
        HashMap<String, Object> parameters = new HashMap<String, Object>(4);
        parameters.put("flightNo", flightNumber == null ? null : flightNumber.trim());
        parameters.put("startDistrict", startDistrict);
        parameters.put("arriveDistrict", arriveDistrict);
        parameters.put("like", "Y");

        int count = bizFlightService.findBizFlightCount(parameters);
        Page<BizFlight> pager = Page.page(count, 10L, (page == null ? 1L : page.longValue()));
        pager.buildUrl(HttpServletLocalThread.getRequest());
        parameters.put("_start", pager.getStartRows());
        parameters.put("_end", pager.getEndRows());
        parameters.put("_orderby", "FLIGHT_ID");
        parameters.put("_order", "ASC");

        List<BizFlight> bizFlights = bizFlightService.selectByParams(parameters);
        for (BizFlight flight : bizFlights) {
            fillBizFlight(flight);
        }
        pager.setItems(bizFlights);
        model.addAttribute("pager", pager);

        model.addAttribute("flightNo", flightNumber);
        model.addAttribute("startDistrict", startDistrict);
        model.addAttribute("arriveDistrict", arriveDistrict);
        model.addAttribute("page", pager.getPage().toString());

        return "/biz/flight/showSelectFlight";
    }
    
    
    /**
	 * 模糊查询机型
	 * @param search
	 * @param resp
	 */
	@RequestMapping(value = "/searchAirplanetypeList")
	@ResponseBody
	public Object searchAirplanetypeList(String search, HttpServletResponse resp){
		if (log.isDebugEnabled()) {
			log.debug("start method<searchAirplanetypeList>");
		}
		String flightNo = search == null ? null : search.trim();
		 Map<String, Object> parameters = new HashMap<String, Object>();
		 parameters.put("dictDefId",1005L);
		 parameters.put("dictName",flightNo);
		List<BizDict> airplanetypeList = MiscUtils.autoUnboxing( bizDictQueryService.findDictByCondition(parameters) );
		
		JSONArray array = new JSONArray();
		if(airplanetypeList != null && airplanetypeList.size() > 0){
			for(BizDict bizDict:airplanetypeList){
				JSONObject obj=new JSONObject();
				obj.put("id", bizDict.getDictId());
				obj.put("text", bizDict.getDictName());
				array.add(obj);
			}
		}
		return array;
	}
	
	
    /**
	 * 模糊查询航空公司
	 * @param search
	 * @param resp
	 */
	@RequestMapping(value = "/searchAirlineList")
	@ResponseBody
	public Object searchAirplineList(String search, HttpServletResponse resp){
		if (log.isDebugEnabled()) {
			log.debug("start method<searchAirlineList>");
		}
		String airline = search == null ? null : search.trim();
		 Map<String, Object> parameters = new HashMap<String, Object>();
		 parameters.put("dictDefId",1004L);
		 parameters.put("dictName",airline);
		List<BizDict> airlineList = MiscUtils.autoUnboxing( bizDictQueryService.findDictByCondition(parameters) );
		
		JSONArray array = new JSONArray();
		if(airlineList != null && airlineList.size() > 0){
			for(BizDict bizDict:airlineList){
				JSONObject obj=new JSONObject();
				obj.put("id", bizDict.getDictId());
				obj.put("text", bizDict.getDictName());
				array.add(obj);
			}
		}
		return array;
	}
	
	
	
	

    /**
     * 计算飞行时长
     * 
     * @param bizFlight
     */
    private void setFlightTime(BizFlight bizFlight) {
        Long flihtTime = 0L;
        String hours = bizFlight.getFlightTimeHour();
        if (StringUtils.isNotEmpty(hours)) {
            flihtTime = Long.valueOf(hours) * 60L;
        }
        String minutes = bizFlight.getFlightTimeMinute();
        if (StringUtils.isNotEmpty(minutes)) {
            flihtTime += Long.valueOf(minutes);
        }
        if (flihtTime != 0L) {
            bizFlight.setFlightTime(flihtTime);
        }
    }
}
