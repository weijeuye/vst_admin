package com.lvmama.vst.back.front.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.lvmama.vst.back.client.channel.service.ChannelAreaClientService;
import com.lvmama.vst.comm.vo.ResultHandleT;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.front.po.ChannelArea;
import com.lvmama.vst.comm.utils.ErrorCodeMsg;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 频道站点管理Action
 */
@Controller
@RequestMapping("/front/channelArea")
public class ChannelAreaAction extends BaseActionSupport {

	private static final long serialVersionUID = -4662970154673089098L;
	@Autowired
	private ChannelAreaClientService channelAreaClientService;
	/**
	 * 获取频道站点列表
	 * @param channelArea
	 * @param type
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/findChanleAreaList")
	public String findChanleAreaList(Model model, Integer page, ChannelArea channelArea,String queryType, HttpServletRequest req) throws BusinessException{
		try {
			Map<String, Object> parameters = new HashMap<String, Object>();
			parameters.put("areaType", channelArea.getAreaType());
			parameters.put("areaCode", channelArea.getAreaCode());
			parameters.put("areaName", channelArea.getAreaName());
			parameters.put("byLike","true");
			ResultHandleT<Integer> resultHandleTCount = channelAreaClientService.findChannelAreaCount(parameters);
			if(resultHandleTCount == null || resultHandleTCount.isFail()){
				log.error(resultHandleTCount.getMsg());
				throw new BusinessException(resultHandleTCount.getMsg());
			}
			int pagenum = page == null ? 1 : page;
			Page<ChannelArea> pageParam = Page.page(resultHandleTCount.getReturnContent(), 10, pagenum);
			pageParam.buildUrl(req);
			parameters.put("_start", pageParam.getStartRowsMySql());
			parameters.put("_pageSize", pageParam.getPageSize());
			parameters.put("_orderby", "AREA_CODE");
			parameters.put("_order", "ASC");
			ResultHandleT<List<ChannelArea>> resultHandleT = channelAreaClientService.findChannelAreaList(parameters);
			if(resultHandleT == null || resultHandleT.isFail()){
				log.error(resultHandleT.getMsg());
				throw new BusinessException(resultHandleT.getMsg());
			}
			pageParam.setItems(resultHandleT.getReturnContent());
			model.addAttribute("pageParam", pageParam);
			model.addAttribute("areaTypeList", ChannelArea.AREA_TYPE.values());
			model.addAttribute("channelArea", channelArea);
			model.addAttribute("page", pageParam.getPage().toString());
		} catch (Exception e) {
			log.error(ExceptionFormatUtil.getTrace(e));
			throw new BusinessException(ErrorCodeMsg.ERR_SYS);
		}
		if(StringUtils.equals(queryType,"select")){
			return "/front/channelArea/showSelectChannelArea";
		}else{
			return "/front/channelArea/findChannelAreaList";
		}
		
	}
	/**
	 * 跳转到添加页面
	 */
	@RequestMapping(value = "/showAddChannelArea")
	public String showAddChannelFromPlace(Model model) {
		model.addAttribute("areaTypeList", ChannelArea.AREA_TYPE.values());
		model.addAttribute("isAdd","true");
		return "/front/channelArea/showAddAndUpdateChannelArea";
	}
	/**
	 * 跳转到修改页面
	 * @param areaCode
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/showUpdateChannelArea")
	public String showUpdateChannelFromPlace(Model model, String areaCode) throws BusinessException {
		ResultHandleT<ChannelArea> resultHandleT = channelAreaClientService.findChannelAreaById(areaCode);
		if(resultHandleT == null || resultHandleT.isFail()){
			log.error(resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		model.addAttribute("channelArea", resultHandleT.getReturnContent());
		model.addAttribute("areaTypeList", ChannelArea.AREA_TYPE.values());
		model.addAttribute("isAdd","false");
		return "/front/channelArea/showAddAndUpdateChannelArea";
	}
	
	/**
	 * 新增频道站点
	 * @param channelArea
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/addChannelArea")
	@ResponseBody
	public Object addChannelArea(ChannelArea channelArea) throws BusinessException{
		if(CollectionUtils.isNotEmpty(getChannelAreaByNewParam(channelArea))){
			return new ResultMessage(ResultMessage.ERROR, "新增失败,新增站点数据与已有数据重复");
		 }
		ResultHandleT<Integer> resultHandleT = channelAreaClientService.addChannelArea(channelArea);
		if(resultHandleT == null || resultHandleT.isFail()){
			log.error(resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		if (resultHandleT.getReturnContent() > 0) {
			return ResultMessage.ADD_SUCCESS_RESULT;
		}
		return ResultMessage.ADD_FAIL_RESULT;
	}
	
	/**
	 * 更新频道站点
	 * @param channelArea
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/updateChannelArea")
	@ResponseBody
	public Object updateChannelArea(ChannelArea channelArea) throws BusinessException{
		List<ChannelArea> oldList = getChannelAreaByNewParam(channelArea);
		if (CollectionUtils.isNotEmpty(oldList) && oldList.size() > 1) {
			return new ResultMessage(ResultMessage.ERROR, "更新失败,更新后站点数据与已有数据重复");
		}
		ResultHandleT<Integer> resultHandleT = channelAreaClientService.updateChannelArea(channelArea);
		if(resultHandleT == null || resultHandleT.isFail()){
			log.error(resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		if (resultHandleT.getReturnContent() > 0) {
			return ResultMessage.UPDATE_SUCCESS_RESULT;
		}
		return ResultMessage.UPDATE_FAIL_RESULT;
	}
	/**
	 * 根据新增的站点名称和编码查询已经存在的站点
	 * @param channelArea
	 * @return  List<ChannelArea>
	 */
	private List<ChannelArea> getChannelAreaByNewParam(ChannelArea channelArea){
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("areaCode", channelArea.getAreaCode());
		parameters.put("areaName", channelArea.getAreaName());
		parameters.put("areaType", channelArea.getAreaType());
		ResultHandleT<List<ChannelArea>> resultHandleT = channelAreaClientService.findChannelAreaListByExists(parameters);
		if(resultHandleT == null || resultHandleT.isFail()){
			log.error(resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		return resultHandleT.getReturnContent();
	}

}
