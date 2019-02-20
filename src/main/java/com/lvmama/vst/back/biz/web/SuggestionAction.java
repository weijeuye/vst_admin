package com.lvmama.vst.back.biz.web;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizSuggestion;
import com.lvmama.vst.back.client.biz.service.SuggestionClientService;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 建议内容插件
 */
@Controller
@RequestMapping("/biz/suggestion")
public class SuggestionAction extends BaseActionSupport {

	private static final long serialVersionUID = -1357217569819363610L;

	@Autowired
	private SuggestionClientService suggestionService;
	

	@RequestMapping(value = "/findSuggestionList")
	public String suggestionList(Model model, Integer page, BizSuggestion bizSuggestion, HttpServletRequest req) throws BusinessException {
		Map<String, Object> params = new HashMap<String, Object>();
		int count = suggestionService.findSuggestionCount(params);
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		params.put("_start", pageParam.getStartRows());
		params.put("_end", pageParam.getEndRows());
		params.put("_orderby", "SUGG_ID");
		params.put("_order", "DESC");
		pageParam.setItems(suggestionService.selectByExample(params));
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("bizSuggestion", bizSuggestion);
		return "/biz/suggestion/findSuggestionList";
	}
	
	/**
	 * 新增页跳转
	 */
	@RequestMapping(value = "/showAddSuggestion")
	public String showAddSuggestion(Model model, Long suggId) throws BusinessException {
		BizSuggestion suggestion = new BizSuggestion();
		if (suggId!=null) {
			suggestion = suggestionService.selectByPrimaryKey(suggId);
		}
		model.addAttribute("suggestion", suggestion);
		return "/biz/suggestion/showAddSuggestion";
	}
	
	@RequestMapping(value = "/addOrModifySuggestion")
	@ResponseBody
	public Object addOrModifySuggestion(BizSuggestion bizSuggestion) {
		if (bizSuggestion.getSuggId() == null) {
			return this.addSuggestion(bizSuggestion);
		}
		return this.modifySuggestion(bizSuggestion);
	}
	
	// 校验 suggCode 是否已存在
	public boolean isExistSuggCode(String suggCode) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("suggCode", suggCode);
		return suggestionService.findSuggestionCount(params) > 0;
	}
	
	@RequestMapping(value = "/addSuggestion")
	@ResponseBody
	public Object addSuggestion(BizSuggestion bizSuggestion) {
		if (this.isExistSuggCode(bizSuggestion.getSuggCode())) {
			return new ResultMessage(ResultMessage.ERROR, "新增失败，编号已存在");
		}
		int res = suggestionService.insertSelective(bizSuggestion);
		if (res==1)
			return ResultMessage.ADD_SUCCESS_RESULT;
		else
			return new ResultMessage(ResultMessage.ERROR, "新增失败");
	}

	@RequestMapping(value = "/modifySuggestion")
	@ResponseBody
	public Object modifySuggestion(BizSuggestion bizSuggestion) throws BusinessException {
		int res = suggestionService.updateByPrimaryKeySelective(bizSuggestion);
		if (res==1)
			return ResultMessage.UPDATE_SUCCESS_RESULT;
		else
			return new ResultMessage(ResultMessage.ERROR, "修改失败");
	}

}
