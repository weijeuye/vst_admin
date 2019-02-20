package com.lvmama.vst.back.biz.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizBranch;
import com.lvmama.vst.back.client.biz.service.BranchClientService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.vo.MemcachedEnum;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

@Controller
@RequestMapping("/biz/branch")
public class BranchAction extends BaseActionSupport {

	@Autowired
	private BranchClientService branchService;
	

	@RequestMapping(value = "/findBranchList")
	public String findBranchList(Model model, Long categoryId) throws BusinessException {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("categoryId", categoryId);
		params.put("_orderby", "BRANCH_ID DESC");
		List<BizBranch> bizBranchs = MiscUtils.autoUnboxing(branchService.findBranchListByParams(params));

		model.addAttribute("bizBranchs", bizBranchs);
		model.addAttribute("categoryId", categoryId);
		return "/biz/category/branchlist";
	}

	@RequestMapping(value = "/updateBranch")
	@ResponseBody
	public Object updateBranch(BizBranch bizBranch) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<updateBranch>");
		}

		branchService.updateBranch(bizBranch);
		// 清空缓存中的规格值
		MemcachedUtil.getInstance().remove(
				MemcachedEnum.BizBranchSingle.getKey() + bizBranch.getBranchId());
		MemcachedUtil.getInstance().remove(
				MemcachedEnum.BizBranchList.getKey()
				+ String.valueOf(bizBranch.getCategoryId()));
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

	@RequestMapping(value = "/addBranch")
	@ResponseBody
	public Object addBranch(BizBranch bizBranch) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<addBranch>");
		}

		branchService.addBranch(bizBranch);
		// 清空缓存中的规格值
		MemcachedUtil.getInstance().remove(
				MemcachedEnum.BizBranchList.getKey()
				+ String.valueOf(bizBranch.getCategoryId()));
		return ResultMessage.ADD_SUCCESS_RESULT;
	}

	@RequestMapping(value = "/showAddBranch")
	public String showAddBranch(Model model, Long categoryId, Long branchId) throws BusinessException {
		BizBranch bizBranch = new BizBranch();
		bizBranch.setCategoryId(categoryId);
		bizBranch.setBranchId(branchId);

		if (branchId != null) {
			bizBranch = MiscUtils.autoUnboxing(branchService.findBranchById(branchId));
		}
		model.addAttribute("bizBranch", bizBranch);
		return "/biz/category/showAddBranch";
	}

	@RequestMapping(value = "/editFlag")
	@ResponseBody
	public Object editFlag(Long branchId, String cancelFlag) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<editFlag>");
		}

		branchService.editFlag(branchId, cancelFlag);
		// 清空缓存中的规格值
		BizBranch bizBranch = MiscUtils.autoUnboxing(branchService.findBranchById(branchId));
		MemcachedUtil.getInstance().remove(
				MemcachedEnum.BizBranchSingle.getKey() + branchId);
		MemcachedUtil.getInstance().remove(
				MemcachedEnum.BizBranchList.getKey()
				+ String.valueOf(bizBranch.getCategoryId()));
		return ResultMessage.SET_SUCCESS_RESULT;
	}

}