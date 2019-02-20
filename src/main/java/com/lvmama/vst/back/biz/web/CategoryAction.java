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

import com.lvmama.vst.back.biz.po.BizBranch;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.client.biz.service.BranchClientService;
import com.lvmama.vst.back.client.biz.service.CategoryClientService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.vo.MemcachedEnum;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

@Controller
@RequestMapping("/biz/category")
public class CategoryAction extends BaseActionSupport {

	@Autowired
	private CategoryClientService categoryService;
	
	
	@Autowired
	private BranchClientService branchService;
	
	
	@RequestMapping(value = "/findCategoryList")
	public String findCategoryList(Model model, Integer page, String categoryName, HttpServletRequest req) throws BusinessException {
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("categoryName", categoryName);
		int count = categoryService.findCategoryCount(parameters);

		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		parameters.put("_start", pageParam.getStartRows());
		parameters.put("_end", pageParam.getEndRows());
		parameters.put("_orderby", "CATEGORY_ID");
		parameters.put("_order", "DESC");
		List<BizCategory> list = categoryService.findCategoryList(parameters);
		pageParam.setItems(list);

		model.addAttribute("pageParam", pageParam);
		model.addAttribute("categoryName", categoryName);
		model.addAttribute("page", pageParam.getPage().toString());

		return "/biz/category/findCategoryList";
	}

	@RequestMapping(value = "/showAddCategory")
	public String showAddCategory(Model model, Long categoryId) throws BusinessException {
		BizCategory bizCategory = new BizCategory();
		if (categoryId != null) {
			 bizCategory = MiscUtils.autoUnboxing(categoryService.findCategoryById(categoryId));
		}
		List<BizCategory> bizCategoryList = categoryService.getAllValidCategory();

		model.addAttribute("bizCategory", bizCategory);
		model.addAttribute("parentCategoryList", bizCategoryList);
		return "/biz/category/showAddCategory";
	}
	
	/**
	 * 
	 * @param model
	 * @param categoryId
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/removeCache")
	@ResponseBody
	public String removeCache(Model model) throws BusinessException {
		
		//清空品类缓存
		List<BizCategory> categoryList = categoryService.getAllValidCategory();
		if (categoryList != null && categoryList.size() > 0) {
			for (BizCategory category : categoryList) {
				// 清空缓存中的品类值
				MemcachedUtil.getInstance().remove(
						MemcachedEnum.BizCategorySingle.getKey()
								+ category.getCategoryId());
				
				MemcachedUtil.getInstance().remove(
						MemcachedEnum.BizCategorySinglePropList.getKey()
								+ category.getCategoryId());
				
				//清空规格
				List<BizBranch> brancheList = branchService.findValidBranchList(category.getCategoryId());
				if(brancheList != null && brancheList.size() > 0){
					for(BizBranch branch : brancheList){
						
						MemcachedUtil.getInstance().remove(
								MemcachedEnum.BizBranchSingle.getKey()
										+ branch.getBranchId());
						
					}
				}
				
				MemcachedUtil.getInstance().remove(
						MemcachedEnum.BizBranchList.getKey()
								+ category.getCategoryId());
			}
		}
		
		MemcachedUtil.getInstance().remove(MemcachedEnum.BizCategoryList.getKey());
		
		return "Success";
	}

	@RequestMapping(value = "/updateCategory")
	@ResponseBody
	public Object updateCategory(BizCategory bizCategory) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<updateCategory>");
		}

		categoryService.updateCategory(bizCategory);
		//清空缓存中的品类值
		MemcachedUtil.getInstance().remove(MemcachedEnum.BizCategorySingle.getKey()+bizCategory.getCategoryId());
		MemcachedUtil.getInstance().remove(MemcachedEnum.BizCategoryList.getKey());
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

	@RequestMapping(value = "/addCategory")
	@ResponseBody
	public Object addCategory(BizCategory bizCategory) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<addCategory>");
		}

		categoryService.addCategory(bizCategory);
		// 清空缓存中的品类值
		MemcachedUtil.getInstance().remove(
				MemcachedEnum.BizCategoryList.getKey());
		return ResultMessage.ADD_SUCCESS_RESULT;
	}

	@RequestMapping(value = "/editFlag")
	@ResponseBody
	public Object editFlag(Long categoryId, String cancelFlag) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<editFlag>");
		}

		categoryService.editFlag(categoryId, cancelFlag);
		// 清空缓存中的品类值
		MemcachedUtil.getInstance().remove(
				MemcachedEnum.BizCategorySingle.getKey() + categoryId);
		MemcachedUtil.getInstance().remove(
				MemcachedEnum.BizCategoryList.getKey());
		return ResultMessage.SET_SUCCESS_RESULT;
	}

}