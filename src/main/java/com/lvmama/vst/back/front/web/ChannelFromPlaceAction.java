package com.lvmama.vst.back.front.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;

import com.lvmama.vst.back.client.channel.service.ChannelFromPlaceClientService;
import com.lvmama.vst.comm.vo.ResultHandleT;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.front.po.ChannelFromPlace;
import com.lvmama.vst.comm.utils.ErrorCodeMsg;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 频道出发地管理Action
 */
@Controller
@RequestMapping("/front/channelFromPlace")
public class ChannelFromPlaceAction extends BaseActionSupport {

	private static final long serialVersionUID = 7734677861650485969L;
	@Autowired
	private ChannelFromPlaceClientService channelFromPlaceClientService;
	
	/**
	 * 获取频道出发地列表
	 * @param channelFromPlace
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/findChannelFromPlaceList")
	public String selectChannelFromPlaceList(Model model, Integer page, ChannelFromPlace channelFromPlace,
			String queryType, HttpServletRequest req) throws BusinessException{
		try {
			Map<String, Object> parameters = new HashMap<String, Object>();
			parameters.put("placeCode", channelFromPlace.getPlaceCode());
			parameters.put("placeName", channelFromPlace.getPlaceName());
			parameters.put("byLike", "true");
			ResultHandleT<Integer> resultHandleTCount = channelFromPlaceClientService.findChannelFromPlaceCount(parameters);
			if(resultHandleTCount == null || resultHandleTCount.isFail()){
				log.error(resultHandleTCount.getMsg());
				throw new BusinessException(resultHandleTCount.getMsg());
			}
			int pagenum = page == null ? 1 : page;
			Page<ChannelFromPlace> pageParam = Page.page(resultHandleTCount.getReturnContent(), 10, pagenum);
			pageParam.buildUrl(req);
			parameters.put("_start", pageParam.getStartRowsMySql());
			parameters.put("_pageSize", pageParam.getPageSize());
			parameters.put("_orderby", "PLACE_ID");
			parameters.put("_order", "ASC");
			ResultHandleT<List<ChannelFromPlace>> resultHandleT = channelFromPlaceClientService.findChannelFromPlaceList(parameters);
			if(resultHandleT == null || resultHandleT.isFail()){
				log.error(resultHandleT.getMsg());
				throw new BusinessException(resultHandleT.getMsg());
			}
			pageParam.setItems(resultHandleT.getReturnContent());
			model.addAttribute("pageParam", pageParam);
			model.addAttribute("channelFromPlace", channelFromPlace);
			model.addAttribute("page", pageParam.getPage().toString());
		} catch (Exception e) {
			log.error(ExceptionFormatUtil.getTrace(e));
			throw new BusinessException(ErrorCodeMsg.ERR_SYS);
		}
		if (StringUtils.equals(queryType, "select")) {
			model.addAttribute("parent", req.getParameter("parent")); 
			return "/front/channelArea/showSelectChannelFromPlace";
		} else {
			return "/front/channelArea/findChannelFromPlaceList";
		}
	}
	
	/**
	 * 跳转到添加页面
	 */
	@RequestMapping(value = "/showAddChannelFromPlace")
	public String showAddChannelFromPlace(Model model) {
		model.addAttribute("isAdd","true");
		return "/front/channelArea/showAddAndUpdateChannelFromPlace";
	}
	
	/**
	 * 跳转到修改页面
	 * @param placeId
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/showUpdateChannelFromPlace")
	public String showUpdateChannelFromPlace(Model model,Long placeId)throws BusinessException {
		ResultHandleT<ChannelFromPlace> resultHandleT = channelFromPlaceClientService.findChannelFromPlaceById(placeId);
		if(resultHandleT == null || resultHandleT.isFail()){
			log.error(resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		 model.addAttribute("isAdd","false");
         model.addAttribute("channelFromPlace",resultHandleT.getReturnContent());
		return "/front/channelArea/showAddAndUpdateChannelFromPlace";
	}
	
	/**
	 * 新增出发地数据
	 * @param  channelFromPlace
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/addChannelFromPlace")
	@ResponseBody
	public Object addChannelFromPlace(ChannelFromPlace channelFromPlace)throws BusinessException {
		if(CollectionUtils.isNotEmpty(geChannelFromPlaceByNewParam(channelFromPlace))){
			return new ResultMessage(ResultMessage.ERROR,"新增失败，新增出发地数据与已有数据重复");
		}
		ResultHandleT<Integer> resultHandleT= channelFromPlaceClientService.addChannelFromPlace(channelFromPlace);
		if(resultHandleT == null || resultHandleT.isFail()){
			log.error(resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		if(resultHandleT.getReturnContent()>0){
			return  ResultMessage.ADD_SUCCESS_RESULT;
		}
		return ResultMessage.ADD_FAIL_RESULT;
	}
	
	
	/**
	 * 修改出发地数据
	 * @param  channelFromPlace
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/updateChannelFromPlace")
	@ResponseBody
	public Object updateChannelAreaFrom(ChannelFromPlace channelFromPlace)throws BusinessException {
		List<ChannelFromPlace> oldList=geChannelFromPlaceByNewParam(channelFromPlace);
		if (CollectionUtils.isNotEmpty(oldList) && oldList.size() > 1) {
			return new ResultMessage(ResultMessage.ERROR, "修改失败，修改后出发地数据与已有数据重复");
		}
		ResultHandleT<Integer> resultHandleT= channelFromPlaceClientService.updateChannelFromPlace(channelFromPlace);
		if(resultHandleT == null || resultHandleT.isFail()){
			log.error(resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		if(resultHandleT.getReturnContent()>0){
			return  ResultMessage.UPDATE_SUCCESS_RESULT;
		}
		return ResultMessage.UPDATE_FAIL_RESULT;
	}
	
	/**
	 * 根据新增或者修改后的数据查询已经存在的出发地
	 * @param  newPlace
	 * @param  List<ChannelFromPlace>
	 */
	private List<ChannelFromPlace> geChannelFromPlaceByNewParam(ChannelFromPlace newPlace){
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("placeCode", newPlace.getPlaceCode());
		parameters.put("placeName", newPlace.getPlaceName());
		parameters.put("placeId", newPlace.getPlaceId());
		ResultHandleT<List<ChannelFromPlace>> resultHandleT = channelFromPlaceClientService.findChannelFromPlaceListByExists(parameters);
		if(resultHandleT == null || resultHandleT.isFail()){
			log.error(resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		return resultHandleT.getReturnContent();
	}

	

}
