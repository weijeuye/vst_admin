package com.lvmama.vst.back.prod.web.insurance;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.po.BizDict;
import com.lvmama.vst.back.biz.po.BizInsurCatRule;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.client.biz.service.CategoryClientService;
import com.lvmama.vst.back.client.biz.service.DictClientService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.biz.service.BizInsurCatRuleService;

/**
 * 保险调配规格
 * @author yuzhizeng
 */
@Controller
@RequestMapping("/insurance/InsurCatRule")
public class InsurCatRuleAction extends BaseActionSupport {

	/**
	 * 序列
	 */
	private static final long serialVersionUID = -5672927144371295777L;

	@Autowired
	private BizInsurCatRuleService bizInsurCatRuleService;

	@Autowired
	private DictClientService bizDictService;
	
	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;
	
	@Autowired
	private CategoryClientService categoryService;
	
	@RequestMapping(value = "/findInsurCatRuleList")
	public String findInsurCatRuleList(Model model, HttpServletRequest req)throws BusinessException {

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("_orderby", "CATEGORY_ID DESC");
		/*parameters.put("_orderby", "RECOMMEND_LEVEL");
		parameters.put("_order", "DESC");*/
		List<BizInsurCatRule> bizInsurCatRuleList = bizInsurCatRuleService.findAllPropsByParams(parameters);
		for(BizInsurCatRule bizInsurCatRule : bizInsurCatRuleList){
			BizCategory bizCategory = MiscUtils.autoUnboxing(categoryService.findCategoryById(bizInsurCatRule.getCategoryId()));
			bizInsurCatRule.setBizCategory(bizCategory);
			
			List<BizDict> bizDictList = new ArrayList<BizDict>();
			for(String insurTypeDict : bizInsurCatRule.getInsurType().split(",")){
				BizDict bizDict = MiscUtils.autoUnboxing(bizDictService.findDictById(Long.parseLong(insurTypeDict)));
				if(bizDict != null){
					bizDictList.add(bizDict);
				}
			}
			bizInsurCatRule.setBizDictList(bizDictList);
		}
		model.addAttribute("bizInsurCatRuleList", bizInsurCatRuleList);
				
		return "/prod/insurance/findInsurCatRuleList";
	}

	/**
	 * 编辑页跳转
	 */
	@RequestMapping(value = "/showAddUpdateInsurCatRule")
	public String showAddUpdateInsurCatRule(Model model, BizInsurCatRule bizInsurCatRule,Long categoryId) throws BusinessException {
		if (bizInsurCatRule.getRuleId() != null) {
			//修改
			bizInsurCatRule = bizInsurCatRuleService.findBizInsurCatRuleById(bizInsurCatRule.getRuleId());
			BizCategory bizCategory = MiscUtils.autoUnboxing(categoryService.findCategoryById(bizInsurCatRule.getCategoryId()) );
			bizInsurCatRule.setBizCategory(bizCategory);
		}else{
			//新增
			 bizInsurCatRule = new BizInsurCatRule();
			 BizCategory bizCategory = new BizCategory();
			 bizInsurCatRule.setBizCategory(bizCategory);
		}
		//查询品类
		List<BizCategory> bizCategoryList = bizCategoryQueryService.getAllValidCategorysForInsur();
		model.addAttribute("bizCategoryList", bizCategoryList);
		//险种
		List<BizDict> bizDictList = MiscUtils.autoUnboxing( bizDictService.findDictListByDefId(new Long(516)) );
		model.addAttribute("insurTypeDictList", bizDictList);
		model.addAttribute("bizInsurCatRule", bizInsurCatRule);
		model.addAttribute("daysTypeList", BizInsurCatRule.DAYS_TYPE.values());
		model.addAttribute("categoryId1",categoryId);
		
		return "/prod/insurance/showAddUpdateInsurCatRule";
	}

	/**
	 * @param 编辑业务字典
	 */
	@RequestMapping(value = "/saveInsurCatRule")
	@ResponseBody
	public Object saveInsurCatRule(BizInsurCatRule bizInsurCatRule,Long categoryId1) throws BusinessException {
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("_orderby", "CATEGORY_ID DESC");
		List<BizInsurCatRule> bizInsurCatRuleList = bizInsurCatRuleService.findAllPropsByParams(parameters);
		//新增
		if(bizInsurCatRule.getRuleId() == null){
			for(BizInsurCatRule bizInsurCatRule1 : bizInsurCatRuleList){
				if(bizInsurCatRule1.getCategoryId().equals(bizInsurCatRule.getCategoryId())) {
					return ResultMessage.UPDATE_CATEGORY_ERROR_RESULT;
				}
			}
			bizInsurCatRuleService.addBizInsurCatRule(bizInsurCatRule);
		}else{
			for(BizInsurCatRule bizInsurCatRule1 : bizInsurCatRuleList){
				if(bizInsurCatRule1.getCategoryId().equals(bizInsurCatRule.getCategoryId()) && !bizInsurCatRule.getCategoryId().equals(categoryId1) ) {
					return ResultMessage.UPDATE_CATEGORY_ERROR_RESULT;
				}
			}
			//修改
			bizInsurCatRuleService.updateBizInsurCatRule(bizInsurCatRule);
		}
	 
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

}