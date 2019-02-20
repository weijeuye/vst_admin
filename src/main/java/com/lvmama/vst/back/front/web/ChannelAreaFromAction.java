package com.lvmama.vst.back.front.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.lvmama.vst.back.client.channel.service.ChannelAreaFromClientService;
import com.lvmama.vst.comm.vo.ResultHandleT;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.front.po.ChannelAreaFrom;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.ErrorCodeMsg;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;
/**
 * 出境频道站点配置Action
 */
@Controller
@RequestMapping("/front/channelAreaFrom")
public class ChannelAreaFromAction  extends BaseActionSupport{

	private static final long serialVersionUID = -7160566999439191704L;
	private static final String  CHANNEL_PAGE_ABROAD="GET_RECOMMEND_INFO_MAP_CHANNEL_ABROAD_RECOMMEND_8413_fromPlaceId_abroad2";
	private static final String  PUT_RECOMMENT_INFO_ABROAD="base_putRecommentInfoResult_abroad2_8413_CHANNEL_ABROAD_RECOMMEND_";
	private static final String  CHANNEL_PAGE_SHIP="GET_RECOMMEND_INFO_MAP_CHANNEL_YOULUN_RECOMMEND2_0_fromPlaceId_youlun";
	private static final String  PUT_RECOMMENT_INFO_SHIP="base_putRecommentInfoResult_youlun_0_CHANNEL_YOULUN_RECOMMEND2_";
	@Autowired
	private ChannelAreaFromClientService channelAreaFromClientService;
	@Autowired
	private ComLogClientService comLogService;
	/**
	 * 获取出境频道区域出发地配置列表
	 * @param channelAreaFrom
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/findChanleAreaFromList")
	public String findChanleAreaFromList(Model model, Integer page,ChannelAreaFrom channelAreaFrom,HttpServletRequest req)throws BusinessException{
		try {
			Map<String, Object> parameters = new HashMap<String, Object>();
			parameters.put("channelPage", channelAreaFrom.getChannelPage());
			if (channelAreaFrom.getChannelArea() != null) {
				parameters.put("areaName", channelAreaFrom.getChannelArea().getAreaName());
			}
			if (channelAreaFrom.getFromPlace() != null) {
				parameters.put("placeName", channelAreaFrom.getFromPlace().getPlaceName());
			}
			if (channelAreaFrom.getParentFromPlace() != null) {
				parameters.put("parentPlaceName", channelAreaFrom.getParentFromPlace().getPlaceName());
			}
			parameters.put("valid", channelAreaFrom.getValid());
			parameters.put("focusPlaceCode", channelAreaFrom.getFocusPlaceCode());
			ResultHandleT<Integer> resultHandleTCount = channelAreaFromClientService.findChannelAreaFromCount(parameters);
			if(resultHandleTCount == null || resultHandleTCount.isFail()){
				log.error(resultHandleTCount.getMsg());
				throw new BusinessException(resultHandleTCount.getMsg());
			}
			int pagenum = page == null ? 1 : page;
			Page<ChannelAreaFrom> pageParam = Page.page(resultHandleTCount.getReturnContent(),10, pagenum);
			pageParam.buildUrl(req);
			parameters.put("_start", pageParam.getStartRowsMySql());
			parameters.put("_pageSize", pageParam.getPageSize());
			parameters.put("_orderby", "CONFIG_ID");
			parameters.put("_order", "ASC");
			ResultHandleT<List<ChannelAreaFrom>> resultHandleT = channelAreaFromClientService.findComplexChannelAreaFromListByUnion(parameters);
			if(resultHandleTCount == null || resultHandleTCount.isFail()){
				log.error(resultHandleTCount.getMsg());
				throw new BusinessException(resultHandleTCount.getMsg());
			}
			pageParam.setItems(resultHandleT.getReturnContent());
			model.addAttribute("pageParam", pageParam);
			model.addAttribute("channelAreaFrom", channelAreaFrom);
			model.addAttribute("page", pageParam.getPage().toString());
		} catch (BusinessException e) {
			log.error(ExceptionFormatUtil.getTrace(e));
			throw new BusinessException(ErrorCodeMsg.ERR_SYS);
		}
		return "/front/channelArea/findChannelAreaFromList";
	}
	
	/**
	 * 跳转到添加页面
	 */
	@RequestMapping(value = "/showAddChannelAreaFrom")
	public String showAddChannelAreaFrom(Model model) {
		 model.addAttribute("isAdd","true");	
		return "/front/channelArea/showAddAndUpdateChannelAreaFrom";
	}
	
	/**
	 * 跳转到修改页面
	 * @param configId
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/showUpdateChannelAreaFrom")
	public String showUpdateChannelAreaFrom(Model model,Long configId)throws BusinessException{
		 ResultHandleT<ChannelAreaFrom> resultHandleT = channelAreaFromClientService.findChannelAreaFromById(configId);
		if(resultHandleT == null || resultHandleT.isFail()){
			log.error(resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		 model.addAttribute("isAdd","false");
         model.addAttribute("channelAreaFrom",resultHandleT.getReturnContent());
		return "/front/channelArea/showAddAndUpdateChannelAreaFrom";
	}
	
	/**
	 * 新增频道区域出发地配置
	 * @param channelAreaFrom
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/addChannelAreaFrom")
	@ResponseBody
	public Object addChannelAreaFrom(ChannelAreaFrom channelAreaFrom)throws BusinessException {
		if(channelAreaFrom==null || channelAreaFrom.getPlaceId()==null){
			return new ResultMessage("error", "参数异常！");
		}
		if (CollectionUtils.isNotEmpty(getChannelAreaFromByParameter(channelAreaFrom))) {
			return new ResultMessage(ResultMessage.ERROR, "新增失败,新增数据:(频道:" + channelAreaFrom.getChannelPage()+","+ "站点:"
					+channelAreaFrom.getChannelArea().getAreaName() + ")与已有数据重复");
		}
		ResultHandleT<Integer> resultHandleT = channelAreaFromClientService.addChannelAreaFromBySelective(channelAreaFrom);
		if(resultHandleT == null || resultHandleT.isFail()){
			log.error(resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		removeCacheByChannelPage(channelAreaFrom);
		if (resultHandleT.getReturnContent() > 0) {
			//添加操作日志
			try {
				comLogService.insert(COM_LOG_OBJECT_TYPE.CHANNEL_AREA_FROM, 
						channelAreaFrom.getConfigId(), channelAreaFrom.getConfigId(), 
						this.getLoginUser().getUserName(), 
						"添加了频道站点配置：【频道:"+channelAreaFrom.getChannelPage()+"站点:"+channelAreaFrom.getChannelArea().getAreaName()+"】", 
						COM_LOG_LOG_TYPE.CHANNEL_AREA_FROM_ADD.name(), 
						"添加频道站点配置",null);
			} catch (Exception e) {
				log.error(ExceptionFormatUtil.getTrace(e));
			}
			
			return ResultMessage.ADD_SUCCESS_RESULT;
		}
		return ResultMessage.ADD_FAIL_RESULT;
	}
	
	/**
	 * 修改频道出发地配置
	 * @param channelAreaFrom
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/updateChannelAreaFrom")
	@ResponseBody
	public Object updateChannelAreaFrom(ChannelAreaFrom channelAreaFrom) throws BusinessException{
		if(channelAreaFrom==null ||channelAreaFrom.getConfigId()==null){
			return new ResultMessage("error", "参数异常！");
		}
		ResultHandleT<ChannelAreaFrom> oldChannel= channelAreaFromClientService.findChannelAreaFromById(channelAreaFrom.getConfigId());
		if(oldChannel == null || oldChannel.isFail()){
			log.error(oldChannel.getMsg());
			throw new BusinessException(oldChannel.getMsg());
		}
		ResultHandleT<Integer> result= channelAreaFromClientService.updateChannelAreaFromBySelective(channelAreaFrom);
		if(result == null || result.isFail()){
			log.error(result.getMsg());
			throw new BusinessException(result.getMsg());
		}
		removeCacheByChannelPage(channelAreaFrom);
		if(result.getReturnContent()>0){
			String logStr=getChannelAreaFromChangeLog(oldChannel.getReturnContent(),channelAreaFrom);
			//添加操作日志
			try {
				if(StringUtils.isNotEmpty(logStr)){
				comLogService.insert(COM_LOG_OBJECT_TYPE.CHANNEL_AREA_FROM,
						channelAreaFrom.getConfigId(), channelAreaFrom.getConfigId(), 
						this.getLoginUser().getUserName(), 
						"更新了频道站点配置：【"+logStr+"】", 
						COM_LOG_LOG_TYPE.CHANNEL_AREA_FROM_UPDATE.name(), 
						"更新频道站点配置",null);
				}
				
			} catch (Exception e) {
				log.error(ExceptionFormatUtil.getTrace(e));
			}
			
			return  ResultMessage.UPDATE_SUCCESS_RESULT;
		}
		return ResultMessage.UPDATE_FAIL_RESULT;
	}
	
	/**
	 * 根据条件查询频道出发地配置
	 * @param channelAreaFrom
	 * @return List<ChannelAreaFrom>
	 */
	private List<ChannelAreaFrom> getChannelAreaFromByParameter(ChannelAreaFrom channelAreaFrom) {
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("channelPage", channelAreaFrom.getChannelPage());
		parameters.put("areaCode", channelAreaFrom.getAreaCode());
		ResultHandleT<List<ChannelAreaFrom>> resultHandleT = channelAreaFromClientService.findChannelAreaFromList(parameters);
		if(resultHandleT == null || resultHandleT.isFail()){
			log.error(resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		return resultHandleT.getReturnContent();
	}
	
	private String getChannelAreaFromChangeLog(ChannelAreaFrom oldFrom,ChannelAreaFrom newFrom){
		StringBuilder logStr = new StringBuilder("");
		if (oldFrom == null || newFrom == null) {
			return "";
		}
		if (!StringUtils.equals(String.valueOf(newFrom.getPlaceId()), String.valueOf(oldFrom.getPlaceId()))) {
			logStr.append(ComLogUtil.getLogTxt("出发地", newFrom.getPlaceId(), oldFrom.getPlaceId()));
		}
		if (!StringUtils.equals(String.valueOf(newFrom.getParentPlaceId()),
				String.valueOf(oldFrom.getParentPlaceId()))) {
			logStr.append(ComLogUtil.getLogTxt("父级出发地", newFrom.getParentPlaceId(), oldFrom.getParentPlaceId()));
		}
		if (!StringUtils.equals(newFrom.getFocusPlaceCode(), oldFrom.getFocusPlaceCode())) {
			logStr.append(ComLogUtil.getLogTxt("焦点图配置", newFrom.getFocusPlaceCode(),
					oldFrom.getFocusPlaceCode()));
		}
		if (!StringUtils.equals(newFrom.getValid(), oldFrom.getValid())) {
			logStr.append(ComLogUtil.getLogTxt("有效性", newFrom.getValid(),
					oldFrom.getValid()));
		}
		return logStr.toString();
	}
	
	/**
	 *根据频道清除前台缓存
	 * @param channelAreaFrom
	 */
	private void removeCacheByChannelPage(ChannelAreaFrom channelAreaFrom){
		// 清除前台缓存
		String channelPage ="";
		String putRecommentInfo = "";
		String channelConfigMemCatche="";
		if (StringUtils.equals("ship2", channelAreaFrom.getChannelPage())) {
			channelPage = CHANNEL_PAGE_SHIP;
			putRecommentInfo = PUT_RECOMMENT_INFO_SHIP;
			channelConfigMemCatche="SHIP_CHANNEL_CONFIG_DATA_MEM";
		} else if(StringUtils.equals("visa2", channelAreaFrom.getChannelPage())){
			channelPage = CHANNEL_PAGE_ABROAD;
			putRecommentInfo = PUT_RECOMMENT_INFO_ABROAD;
			channelConfigMemCatche="VISA_CHANNEL_CONFIG_DATA_MEM";
		}else{
			channelPage = CHANNEL_PAGE_ABROAD;
			putRecommentInfo = PUT_RECOMMENT_INFO_ABROAD;
			channelConfigMemCatche="CHANNEL_CONFIG_DATA_MEM";
		}
		MemcachedUtil.getInstance().remove(channelPage.replace("fromPlaceId", String.valueOf(channelAreaFrom.getPlaceId())));
		MemcachedUtil.getInstance().remove(putRecommentInfo+channelAreaFrom.getPlaceId());
		MemcachedUtil.getInstance().remove(channelConfigMemCatche);	
	}
}
