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
import com.lvmama.vst.back.biz.po.BizCategoryProp;
import com.lvmama.vst.back.biz.service.CategoryPropGroupService;
import com.lvmama.vst.back.client.biz.service.CategoryPropClientService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.MemcachedEnum;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

@Controller
@RequestMapping("/biz/categoryProp")
public class CategoryPropAction extends BaseActionSupport {

	@Autowired
	private CategoryPropClientService categoryPropService;
	

	@Autowired
	private CategoryPropGroupService categoryPropGroupService;
	

	@RequestMapping(value = "/findCategoryPropList")
	public String findCategoryPropList(Model model, Integer page, Long categoryId, Long groupId, HttpServletRequest req) throws BusinessException {

		// 获取品类下的属性分组
		List<BizCatePropGroup> bizCatePropGroups = categoryPropGroupService.getAllValidCategoryPropGroup(categoryId);

		Map<String, Object> params = new HashMap<String, Object>();
		if (groupId != null) {
			params.put("groupId", groupId);
		} else {
			params.put("categoryId", categoryId);
		}
		int count = categoryPropService.findCategoryPropCount(params);
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		params.put("_start", pageParam.getStartRows());
		params.put("_end", pageParam.getEndRows());
		params.put("_orderby", "PROP_ID DESC");
		List<BizCategoryProp> bizCategoryProps = MiscUtils.autoUnboxing(categoryPropService.findAllPropsByParams(params));

		model.addAttribute("bizCatePropGroups", bizCatePropGroups);
		model.addAttribute("groupSize", bizCatePropGroups.size());
		model.addAttribute("bizCategoryProps", bizCategoryProps);
		model.addAttribute("categoryId", categoryId);
		model.addAttribute("groupId", groupId);
		pageParam.setItems(bizCategoryProps);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("page", pageParam.getPage().toString());

		return "/biz/category/categoryProplist";
	}

	// 新增品类下的属性
	@RequestMapping(value = "/addCategoryProp")
	@ResponseBody
	public Object addCategoryProp(BizCategoryProp bizCateProp) throws BusinessException {
		if (log.isDebugEnabled()) {
			 log.debug("start method<addCategoryProp>");
	    } 
		categoryPropService.addCategoryProp(bizCateProp);
		// 清空缓存中的品类值
		MemcachedUtil.getInstance().remove(
				MemcachedEnum.BizCategorySinglePropList.getKey()+String.valueOf(bizCateProp.getCategoryId()));
		return ResultMessage.ADD_SUCCESS_RESULT;
	}

	@RequestMapping(value = "/showCategoryProp")
	public String showCategoryProp(Model model, Long categoryId, Long groupId, Long propId) throws BusinessException {

		BizCategoryProp bizCategoryProp = new BizCategoryProp();
		bizCategoryProp.setGroupId(groupId); // 仅仅为了与编辑已有的页面统一
		bizCategoryProp.setCategoryId(categoryId);// 仅仅为了与编辑已有的页面统一

		if (propId != null) {
			bizCategoryProp = categoryPropService.findCategoryPropById(propId);
		}
		List<BizCatePropGroup> bizCatePropGroups = categoryPropGroupService.getAllValidCategoryPropGroup(bizCategoryProp.getCategoryId());

		model.addAttribute("bizCategoryProp", bizCategoryProp);
		model.addAttribute("bizCatePropGroups", bizCatePropGroups);
		model.addAttribute("inputtypes", Constant.PROPERTY_INPUT_TYPE_ENUM.values());
		return "/biz/category/showCategoryProp";
	}

	// 修改品类下的属性
	@RequestMapping(value = "/updateCategoryProp")
	@ResponseBody
	public Object updateCategoryProp(BizCategoryProp bizCateProp) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<updateCategoryProp>");
		}

		categoryPropService.updateCategoryProp(bizCateProp);
		// 清空缓存中的品类值
		MemcachedUtil.getInstance().remove(
				MemcachedEnum.BizCategorySinglePropList.getKey()+String.valueOf(bizCateProp.getCategoryId()));
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

	// 设置属性标示状态
	@RequestMapping(value = "/editFlag")
	@ResponseBody
	public Object editFlag(Long propId, String cancelFlag) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<editFlag>");
		}

		categoryPropService.editFlag(propId, cancelFlag);
		// 清空缓存中的品类属性列表
		BizCategoryProp bizCateProp = categoryPropService.findCategoryPropById(propId);
		MemcachedUtil.getInstance().remove(
				MemcachedEnum.BizCategorySinglePropList.getKey()+String.valueOf(bizCateProp.getCategoryId()));
						
		return ResultMessage.SET_SUCCESS_RESULT;
	}
}
