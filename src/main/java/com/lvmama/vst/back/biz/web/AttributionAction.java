package com.lvmama.vst.back.biz.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.Attribution;
import com.lvmama.vst.back.client.biz.service.AttributionClientService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;

@Controller
@RequestMapping("/biz/attribution")
public class AttributionAction extends BaseActionSupport {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 2896672539962901809L;
	@Autowired
	private AttributionClientService service;
	

	/**
	 * 获得归属地列表
	 */
	@RequestMapping(value = "/findAttributionList")
	public String findAttributionList(Model model, Integer page, String attributionName, String  attributionType,  HttpServletRequest req) {
		
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("attributionName", attributionName);
		parameters.put("attributionType", attributionType);
		int count = MiscUtils.autoUnboxing(service.findAttributionCount(parameters));

		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		parameters.put("_start", pageParam.getStartRows());
		parameters.put("_end", pageParam.getEndRows());
		
		List<Attribution> attributionList = service.findAttributionList(parameters);
		pageParam.setItems(attributionList);
		model.addAttribute("attributionName", attributionName);
		model.addAttribute("attributionType", attributionType);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("attributionTypeList", Attribution.ATTRIBUTION_TYPE.values());
		model.addAttribute("page", pageParam.getPage().toString());
		return "/biz/attribution/findAttributionList";
	}
	
	
	
	@RequestMapping(value = "/selectAttributionList")
	public String selectAttributionList(Model model, Integer page, String attributionName, String  attributionType,  HttpServletRequest req) {
		
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("attributionName", attributionName);
		parameters.put("attributionType", attributionType);
		int count =  MiscUtils.autoUnboxing(service.findAttributionCount(parameters));
		

		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		parameters.put("_start", pageParam.getStartRows());
		parameters.put("_end", pageParam.getEndRows());
		
		List<Attribution> attributionList = service.findAttributionList(parameters);
		pageParam.setItems(attributionList);
		model.addAttribute("attributionName", attributionName);
		model.addAttribute("attributionType", attributionType);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("attributionTypeList", Attribution.ATTRIBUTION_TYPE.values());
		model.addAttribute("page", pageParam.getPage().toString());
		if(req.getParameter("multi")!=null)
			return "/biz/attribution/selectAttributionListMulti";
		return "/biz/attribution/selectAttributionList";
	}
	
 
	/**
	 * 跳转到修改页面
	 */
	@RequestMapping(value = "/showUpdateAttribution")
	public String showUpdateAttribution(Model model, Long attributionId) {
		Attribution attribution = service.findAttributionById(attributionId);
		model.addAttribute("attribution", attribution);
		model.addAttribute("attributionTypeList", Attribution.ATTRIBUTION_TYPE.values());
		
		return "/biz/attribution/showUpdateAttribution";
	}

	/**
	 * 跳转到添加页面
	 */
	@RequestMapping(value = "/showAddAttribution")
	public String showAddAttribution(Model model) {
		model.addAttribute("attributionTypeList", Attribution.ATTRIBUTION_TYPE.values());
		return "/biz/attribution/showAddAttribution";
	}

	/**
	 * 添加归属地
	 * 
	 * @return 添加结果JSON
	 */
	@RequestMapping(value = "/addAttribution")
	@ResponseBody
	public Object addAttribution(Attribution attribution) {
		if (log.isDebugEnabled()) {
			log.debug("start method<addDistrictSign>");
		}
		service.addAttribution(attribution);
		return ResultMessage.ADD_SUCCESS_RESULT;
	}

	/**
	 * 更新归属地
	 */
	@RequestMapping(value = "/updateAttribution")
	@ResponseBody
	public Object updateAttribution(Attribution attribution) {
		if (log.isDebugEnabled()) {
			log.debug("start method<updateDistrictSign>");
		}

		service.updateAttribution(attribution);
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

}
