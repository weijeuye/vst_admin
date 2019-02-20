package com.lvmama.vst.back.biz.web;

import static com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE.SEASON_EFFECT_DESIGN;
import static com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE.SEASON_EFFECT_PORATE;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.vst.back.biz.po.SeasonEffect;
import com.lvmama.vst.back.biz.service.SeasonEffectService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.comm.utils.DateUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 季节性影响排序设置
 * @author kongzhiwen
 *
 */
@SuppressWarnings("serial")
@Controller
@RequestMapping("/biz/seasoneffect")
public class SeasonEffectAction extends BaseActionSupport {

	@Autowired
	private SeasonEffectService seasonEffectService;
	@Autowired
	private ComLogClientService 	comLogService;
	
	/*
	 * 查询季节影响
	 */
	@RequestMapping(value = "/findSeasonEffectList")
	public String findSeasonEffect(Model model, SeasonEffect seasonEffect, Integer page, HttpServletRequest req) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<findSeasonEffect>");
		}
		
		Map<String, Object> param = new HashMap<String, Object>();
		if(seasonEffect != null){
			param.put("seasonId", seasonEffect.getSeasonId());
			param.put("seasonName", seasonEffect.getSeasonName());			
			param.put("effectStatus", seasonEffect.getEffectStatus());
			
			String seasonEffectType = seasonEffect.getSeasonEffectType();
			if(seasonEffectType != null && !seasonEffectType.equals("")){
				String categoryId[] = seasonEffectType.split("-");
				if(categoryId != null){
					param.put("categoryId", categoryId[0]);
					if(categoryId.length >=2){
						param.put("subcategoryId", categoryId[1]);
					}
				}
			}
		}
		int count = seasonEffectService.findSeasonEffectCount(param);

		int pagenum = page == null ? 1 : page;
		Page<SeasonEffect> pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		
		param.put("_start", pageParam.getStartRows());
		param.put("_end", pageParam.getEndRows());
		param.put("_orderby", "CREATE_TIME");
		param.put("_order", "DESC");
		List<SeasonEffect> list = seasonEffectService.findSeasonEffectByParams(param);
		pageParam.setItems(list);

		model.addAttribute("pageParam", pageParam);
		model.addAttribute("page", pageParam.getPage().toString());	
		model.addAttribute("seasonEffect", seasonEffect);
		model.addAttribute("seasonEffectTypeList", SeasonEffect.SEASON_EFFECT_TYPE.values());

		return "/biz/seasoneffect/findSeasonEffectList";
	}	
	
	/*
	 * 删除某个季节影响
	 */
	@RequestMapping(value = "/deleteSeasonEffect")
	@ResponseBody
	public Object deleteSeasonEffect(Long seasonId) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<deleteSeasonEffect>, seasonId=" + seasonId);
		}
		try {
			SeasonEffect seasonEffect = seasonEffectService.findSeasonEffectById(seasonId);
			
			if(seasonEffect != null){
				seasonEffectService.deleteById(seasonId);
				//添加日志
				logLineRouteOperate(seasonId, "删除季节" + seasonEffect.toString(), "删除季节");
				
				return ResultMessage.DELETE_SUCCESS_RESULT;
			}
			else{
				return new ResultMessage(ResultMessage.ERROR, "数据不存在");
			}
		} catch (Exception e) {
			log.error("deleteSeasonEffect error:", e);
		}
		return new ResultMessage(ResultMessage.ERROR, "系统出现错误");
	}
	
	@RequestMapping(value = "/addOrUpdateSeason")
	@ResponseBody	
	public Object addOrUpdateSeason(SeasonEffect seasonEffect,Long[] categoryIds) throws BusinessException {
		try {
			if(seasonEffect.getSeasonId() != null){
				SeasonEffect oldSeasonEffect = seasonEffectService.findSeasonEffectById(seasonEffect.getSeasonId());
				seasonEffect.setUpdateTime(new Date());
				seasonEffectService.updateByPrimaryKey(seasonEffect);
				logLineRouteOperate(seasonEffect.getSeasonId(),buildUpdateLineRouteLogText(oldSeasonEffect,seasonEffect),"修改季节");
			}else{
				if(categoryIds !=null){
					for (int i = 0; i < categoryIds.length; i++) {
						if(categoryIds[i] == 182L || categoryIds[i] == 183L){
							seasonEffect.setCategoryId(18L);
							seasonEffect.setSubcategoryId(categoryIds[i]);
						}else{
							seasonEffect.setCategoryId(categoryIds[i]);
							seasonEffect.setSubcategoryId(null);
						}
						seasonEffect.setCreateTime(new Date());
						Long seasonId = seasonEffectService.addSeasonEffect(seasonEffect);
						if(seasonId !=null){
							logLineRouteOperate(seasonId,"新增【"+seasonEffect.getSeasonName()+"】季节","新增季节");
						}
					}
				}
			}
			return ResultMessage.DELETE_SUCCESS_RESULT;
		} catch (Exception e) {
			log.error(e.getMessage());
		}
		return new ResultMessage(ResultMessage.ERROR, "系统出现错误");
	}

	@RequestMapping(value = "/showAddSeason")
	public String showAddSeason(Model model, Long seasonId) throws BusinessException {
		SeasonEffect seasonEffect = new SeasonEffect();
		if(seasonId != null){
			seasonEffect = seasonEffectService.findSeasonEffectById(seasonId);
			model.addAttribute("effectBeginDateString", DateUtil.formatDate(seasonEffect.getEffectBeginDate(), DateUtil.PATTERN_yyyy_MM_dd));
			model.addAttribute("effectEndDateString", DateUtil.formatDate(seasonEffect.getEffectEndDate(),  DateUtil.PATTERN_yyyy_MM_dd));
			model.addAttribute("seasonBeginDateString", DateUtil.formatDate(seasonEffect.getSeasonBeginDate(),  DateUtil.PATTERN_yyyy_MM_dd));
			model.addAttribute("seasonEndDateString", DateUtil.formatDate(seasonEffect.getSeasonEndDate(),  DateUtil.PATTERN_yyyy_MM_dd));
		}
		model.addAttribute("seasonEffect", seasonEffect);
		return "/biz/seasoneffect/showAddSeasonEffect";
	}

	
	/**
	 * 记录操作日志
	 */
	private void logLineRouteOperate(Long seasonId, String logText, String logName) {
		try{
			PermUser operateUser = this.getLoginUser();
			comLogService.insert(SEASON_EFFECT_PORATE, seasonId, seasonId,
					operateUser==null? "" : operateUser.getUserName(), logText, SEASON_EFFECT_DESIGN.name(), logName, null);
		}catch(Exception e) {
			log.error("Record Log failure ！Log Type:" + SEASON_EFFECT_DESIGN.name());
			log.error(e.getMessage(), e);
		}
	}
	
	/**
	 * 生产编辑行程的日志内容
	 */
	private String buildUpdateLineRouteLogText(SeasonEffect oldSeason, SeasonEffect newSeason) {
		String logVal="节日时间【原值："+DateUtil.formatDate(oldSeason.getSeasonBeginDate(), DateUtil.PATTERN_yyyy_MM_dd)+" ~ "+DateUtil.formatDate(oldSeason.getSeasonEndDate(), DateUtil.PATTERN_yyyy_MM_dd)+" 新值："+DateUtil.formatDate(newSeason.getSeasonBeginDate(), DateUtil.PATTERN_yyyy_MM_dd)+" ~ "+DateUtil.formatDate(newSeason.getSeasonEndDate(), DateUtil.PATTERN_yyyy_MM_dd)+"】；" +
				"有效时间【原值："+DateUtil.formatDate(oldSeason.getEffectBeginDate(), DateUtil.PATTERN_yyyy_MM_dd)+" ~ "+DateUtil.formatDate(oldSeason.getEffectEndDate(), DateUtil.PATTERN_yyyy_MM_dd)+"新值："+DateUtil.formatDate(newSeason.getEffectBeginDate(), DateUtil.PATTERN_yyyy_MM_dd)+" ~ "+DateUtil.formatDate(newSeason.getEffectEndDate(), DateUtil.PATTERN_yyyy_MM_dd)+"】；" +
				"状态【原值："+("1".equals(oldSeason.getEffectStatus())?"有效":"无效")+"新值："+("1".equals(newSeason.getEffectStatus())?"有效":"无效")+"】；" +
				"排序值【原值："+oldSeason.getOrderValue()+"新值："+newSeason.getOrderValue()+"】；" ;
		
		return logVal;
	}
}