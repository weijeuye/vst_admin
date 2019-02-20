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

import com.lvmama.vst.back.biz.po.BizBranchProp;
import com.lvmama.vst.back.biz.service.BizBranchQueryService;
import com.lvmama.vst.back.biz.service.BranchPropService;
import com.lvmama.vst.back.client.biz.service.BranchClientService;
import com.lvmama.vst.back.client.biz.service.BranchPropClientService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.MemcachedEnum;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

@Controller
@RequestMapping("/biz/branchProp")
public class BranchPropAction extends BaseActionSupport {

	@Autowired
	BranchPropService branchPropService;
	

	@Autowired
	private BizBranchQueryService bizBranchQueryService;
	
	@Autowired
	BranchClientService branchService;
	

	@RequestMapping(value = "/findBranchPropsList")
	public String findBranchPropsList(Model model, Long categoryId, Long branchId, Integer page, HttpServletRequest req) throws BusinessException {

		Map<String, Object> params = new HashMap<String, Object>();
		if (branchId != null) {
			params.put("branchId", branchId);
		} else {
			params.put("categoryId", categoryId);
		}
		int count = branchPropService.queryBizBranchPropTotalCount(params);
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		params.put("_start", pageParam.getStartRows());
		params.put("_end", pageParam.getEndRows());
		params.put("_orderby", "PROP_ID DESC");
		List<BizBranchProp> bizBranchProps = branchPropService.findBranchPropsByParams(params);

		model.addAttribute("categoryId", categoryId);
		model.addAttribute("branchId", branchId);

		pageParam.setItems(bizBranchProps);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("page", pageParam.getPage().toString());

		return "/biz/category/branchProplist";
	}

	@RequestMapping(value = "/showBranchProp")
	public String showBranchProp(Model model, Long categoryId, Long branchId, Long propId) throws BusinessException {
		BizBranchProp bizBranchProp = new BizBranchProp();
		bizBranchProp.setBranchId(branchId);
		if (propId != null) {
			bizBranchProp = MiscUtils.autoUnboxing( branchPropService.findBranchPropById(propId));
		}

		model.addAttribute("bizBranchProp", bizBranchProp);
		model.addAttribute("inputtypes", Constant.PROPERTY_INPUT_TYPE_ENUM.values());
		return "/biz/category/showBranchProp";
	}

	@RequestMapping(value = "/addBranchProp")
	@ResponseBody
	public Object addBranchProp(BizBranchProp bizBranchProp) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<addBranchProp>");
		}

		branchPropService.addBranchProp(bizBranchProp);
		// 清空缓存中的规格值
		MemcachedUtil.getInstance().remove(
				MemcachedEnum.BizBranchPropList.getKey() + String.valueOf(bizBranchProp.getBranchId()));
		return ResultMessage.ADD_SUCCESS_RESULT;
	}

	@RequestMapping(value = "/updateBranchProp")
	@ResponseBody
	public Object updateBranchProp(BizBranchProp bizBranchProp) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<updateBranchProp>");
		}

		branchPropService.updateBranchProp(bizBranchProp);
		// 清空缓存中的规格值
		MemcachedUtil.getInstance().remove(
				MemcachedEnum.BizBranchPropList.getKey() + String.valueOf(bizBranchProp.getBranchId()));
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

	@RequestMapping(value = "/editFlag")
	@ResponseBody
	public Object editFlag(Long propId, String cancelFlag) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<editFlag>");
		}
		branchPropService.editFlag(propId, cancelFlag);
		// 清空缓存中的规格值
		BizBranchProp bizBranchProp = MiscUtils.autoUnboxing( branchPropService.findBranchPropById(propId));
		MemcachedUtil.getInstance().remove(
				MemcachedEnum.BizBranchPropList.getKey() + String.valueOf(bizBranchProp.getBranchId()));
		return ResultMessage.SET_SUCCESS_RESULT;
	}

}