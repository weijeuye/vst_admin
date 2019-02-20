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

import com.lvmama.vst.back.biz.po.BizCatePropGroup;
import com.lvmama.vst.back.client.biz.service.CategoryPropClientService;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * @Description: TODO
 */
@Controller
@RequestMapping("/biz/categoryPropGroup")
public class CategoryPropGroupAction extends BaseActionSupport {

	@Autowired
	private CategoryPropClientService categoryPropGroupService;
	

	@RequestMapping(value = "/findCategoryPropGroup")
	public String findCategoryPropGroup(Model model, Long categoryId, Integer page, HttpServletRequest req) throws BusinessException {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("categoryId", categoryId);
		int count = categoryPropGroupService.findCatePropGroupCount(params);
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		params.put("_start", pageParam.getStartRows());
		params.put("_end", pageParam.getEndRows());
		params.put("_orderby", "GROUP_ID DESC");
		List<BizCatePropGroup> bizCatePropGroups = categoryPropGroupService.findCatePropGroupListByPara(params);
		pageParam.setItems(bizCatePropGroups);

		model.addAttribute("categoryId", categoryId);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("page", pageParam.getPage().toString());

		return "/biz/category/categoryPropGrouplist";
	}

	@RequestMapping(value = "/addCategoryPropGroup")
	@ResponseBody
	public Object addCategoryPropGroup(BizCatePropGroup bizCatePropGroup) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<addCategoryPropGroup>");
		}

		categoryPropGroupService.addCategoryPropGroup(bizCatePropGroup);
		return ResultMessage.ADD_SUCCESS_RESULT;
	}

	@RequestMapping(value = "/updateCategoryPropGroup")
	@ResponseBody
	public Object updateCategoryPropGroup(BizCatePropGroup bizCatePropGroup) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<updateCategoryPropGroup>");
		}

		categoryPropGroupService.updateCategoryPropGroup(bizCatePropGroup);
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

	@RequestMapping(value = "/editFlag")
	@ResponseBody
	public Object editFlag(Long groupId, String cancelFlag) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<editFlag>");
		}

		categoryPropGroupService.editFlag(groupId, cancelFlag);
		return ResultMessage.SET_SUCCESS_RESULT;
	}

	@RequestMapping(value = "/deleteCatePropGroup")
	@ResponseBody
	public Object deleteCatePropGroup(Long groupId) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<deleteCatePropGroup>");
		}

		categoryPropGroupService.deleteCatePropGroup(groupId);
		return ResultMessage.DELETE_SUCCESS_RESULT;
	}

	@RequestMapping(value = "/showAddCategoryPropGroup")
	public String showAddCategoryPropGroup(Model model, Long categoryId, Long groupId) throws BusinessException {
		BizCatePropGroup bizCatePropGroup = new BizCatePropGroup();
		bizCatePropGroup.setCategoryId(categoryId);
		bizCatePropGroup.setGroupId(groupId);

		if (groupId != null) {
			bizCatePropGroup = categoryPropGroupService.findCategoryPropGroupById(groupId);
		}
		model.addAttribute("bizCatePropGroup", bizCatePropGroup);
		return "/biz/category/showAddCategoryPropGroup";
	}

}
