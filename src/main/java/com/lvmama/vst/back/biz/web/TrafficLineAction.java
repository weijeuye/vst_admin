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

import com.lvmama.vst.back.biz.po.BizTrafficLine;
import com.lvmama.vst.back.biz.service.TrafficLineService;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 地铁线路管理Action
 * 
 * @author xiexun
 */

@Controller
@RequestMapping("/biz/trafficLine")
public class TrafficLineAction extends BaseActionSupport {

	@Autowired
	private TrafficLineService trafficLineService;

	/**
	 * 获得地铁线路列表
	 */
	@RequestMapping(value = "/findTrafficLineList")
	public String findTrafficLineList(Model model, Integer page,BizTrafficLine bizTrafficLine, HttpServletRequest req) throws BusinessException {
		
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("districtId", bizTrafficLine.getDistrictId());
		parameters.put("trafficName", bizTrafficLine.getTrafficName());
		if(null==bizTrafficLine.getCancelFlag()){
			parameters.put("cancelFlag", "all");
			model.addAttribute("cancelFlag", "all");
		}else{
			parameters.put("cancelFlag", bizTrafficLine.getCancelFlag());
			model.addAttribute("cancelFlag", bizTrafficLine.getCancelFlag());
		}		
		int count = trafficLineService.findTrafficLineCount(parameters);

		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 20, pagenum);
		pageParam.buildUrl(req);
		parameters.put("_start", pageParam.getStartRows());
		parameters.put("_end", pageParam.getEndRows());
		parameters.put("_orderby", "TRAFFIC_ID");
		parameters.put("_order", "ASC");
		List<BizTrafficLine> list = trafficLineService.findTrafficLineList(parameters);
		pageParam.setItems(list);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("trafficName", bizTrafficLine.getTrafficName());
		model.addAttribute("districtId", bizTrafficLine.getDistrictId());
		model.addAttribute("districtName", bizTrafficLine.getDistrictName());
		model.addAttribute("page", pageParam.getPage().toString());

		return "/biz/trafficLine/findTrafficLineList";
	}


	/**
	 * 跳转到修改页面
	 */
	@RequestMapping(value = "/showUpdateTrafficLine")
	public String showUpdateTrafficLine(Model model, Long trafficId) throws BusinessException {
		BizTrafficLine bizTrafficLine = trafficLineService.findTrafficLineDetailById(trafficId);
		model.addAttribute("trafficLine", bizTrafficLine);
		return "/biz/trafficLine/showUpdateTrafficLine";
	}

	/**
	 * 跳转到添加页面
	 */
	@RequestMapping(value = "/showAddTrafficLine")
	public String showAddTrafficLine(Model model) {
		return "/biz/trafficLine/showAddTrafficLine";
	}


	/**
	 * 添加地铁线路
	 * 
	 * @return 添加结果JSON
	 */
	@RequestMapping(value = "/addTrafficLine")
	@ResponseBody
	public Object addTrafficLine(BizTrafficLine bizTrafficLine) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<addDistrict>");
		}
		bizTrafficLine.setCancelFlag("N");
		trafficLineService.addBizTrafficLine(bizTrafficLine);
		return ResultMessage.ADD_SUCCESS_RESULT;
	}

	/**
	 * 更新地铁线路
	 */
	@RequestMapping(value = "/updateTrafficLine")
	@ResponseBody
	public Object updateTrafficLine(BizTrafficLine bizTrafficLine) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<updateTrafficLine>");
		}
		trafficLineService.updateBizTrafficLine(bizTrafficLine);
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}
	

	/**
	 * 设置地铁线路的有效性
	 */
	@RequestMapping(value = "/modiTrafficLineFlag")
	@ResponseBody
	public Object modiTrafficLineFlag(BizTrafficLine bizTrafficLine) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<modiTrafficLineFlag>");
		}
		trafficLineService.updateBizTrafficLineFlag(bizTrafficLine);
		return ResultMessage.SET_SUCCESS_RESULT;
	}

	/**
	 * 选择地铁线路
	 */
	@RequestMapping(value = "/selectTrafficLineList")
	public String selectTrafficLineList(Model model, Integer page, BizTrafficLine bizTrafficLine,String trafficIds, HttpServletRequest req) throws BusinessException {
		Map<String, Object> parameters = new HashMap<String, Object>();
		int pagenum = page == null ? 1 : page;
		parameters.put("districtId", bizTrafficLine.getDistrictId());
		parameters.put("cancelFlag", "Y");
		int count = trafficLineService.findTrafficLineCount(parameters);
		Page pageParam = Page.page(count, 10000, pagenum);
		pageParam.buildUrl(req);
		parameters.put("_start", pageParam.getStartRows());
		parameters.put("_end", pageParam.getEndRows());
		parameters.put("_orderby", "TRAFFIC_ID");
		parameters.put("_order", "ASC");
		List<BizTrafficLine> list = trafficLineService.findTrafficLineList(parameters);
		pageParam.setItems(list);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("trafficIds", trafficIds);
		return "/biz/trafficLine/selectTrafficLineList";
	}
	
}