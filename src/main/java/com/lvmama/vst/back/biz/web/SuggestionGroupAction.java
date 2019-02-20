package com.lvmama.vst.back.biz.web;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizSuggestionGroup;
import com.lvmama.vst.back.biz.service.SuggestionGroupService;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 建议内容分类
 */
@Controller
@RequestMapping("/biz/suggestionGroup")
public class SuggestionGroupAction extends BaseActionSupport {

	private static final long serialVersionUID = -5871504342335301322L;

	@Autowired
	private SuggestionGroupService suggestionGroupService;

	@RequestMapping(value = "/findGroupList")
	public String suggestionList(Model model, Integer page, BizSuggestionGroup group, HttpServletRequest req) throws BusinessException {
		Map<String, Object> params = new HashMap<String, Object>();
		String suggId = req.getParameter("suggId");
		if (StringUtils.isNotEmpty(suggId)) {
			params.put("suggId", suggId);
		}
		int count = suggestionGroupService.findGroupCount(params);
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		params.put("_start", pageParam.getStartRows());
		params.put("_end", pageParam.getEndRows());
		params.put("orderByClause", "SEQ");
		pageParam.setItems(suggestionGroupService.selectByExample(params));
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("group", group);
		return "/biz/suggestionGroup/findGroupList";
	}

	/**
	 * 新增/修改页跳转
	 */
	@RequestMapping(value = "/showAddGroup")
	public String showAddDict(Model model, Long groupId, Long suggId) throws BusinessException {
		BizSuggestionGroup group = new BizSuggestionGroup();
		if (groupId!=null) { // 修改
			group = suggestionGroupService.selectByPrimaryKey(groupId);
		} else { // 新增
			group.setSuggId(suggId);
		}
		model.addAttribute("group", group);
		return "/biz/suggestionGroup/showAddGroup";
	}

	@RequestMapping(value = "/addOrModifyGroup")
	@ResponseBody
	public Object addOrModifyGroup(BizSuggestionGroup group) {
		if (group.getGroupId() == null) {
			return this.addGroup(group);
		}
		return this.modifyGroup(group);
	}

	public Object addGroup(BizSuggestionGroup group) {
		int res = suggestionGroupService.insertSelective(group);
		if (res==1)
			return ResultMessage.ADD_SUCCESS_RESULT;
		else
			return new ResultMessage(ResultMessage.ERROR, "新增失败");
	}

	private Object modifyGroup(BizSuggestionGroup group) throws BusinessException {
		int res = suggestionGroupService.updateByPrimaryKeySelective(group);
		if (res==1)
			return ResultMessage.UPDATE_SUCCESS_RESULT;
		else
			return new ResultMessage(ResultMessage.ERROR, "修改失败");
	}

}
