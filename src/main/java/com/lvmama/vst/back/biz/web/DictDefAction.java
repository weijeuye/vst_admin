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

import com.lvmama.vst.back.biz.po.BizDict;
import com.lvmama.vst.back.biz.po.BizDict.DICT_TYPE;
import com.lvmama.vst.back.biz.po.BizDictDef;
import com.lvmama.vst.back.client.biz.service.DictDefClientService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 字典定义处理器
 * 
 * @author yuzhizeng
 */
@Controller
@RequestMapping("/biz/dict")
public class DictDefAction extends BaseActionSupport {

	@Autowired
	private DictDefClientService dictDefService;
	

	/**
	 * 列表页
	 */
	@RequestMapping(value = "/findDictDefList")
	public String findDictDefList(Model model, Integer page, BizDictDef bizDictDef, HttpServletRequest req) throws BusinessException {
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("dictDefName", bizDictDef.getDictDefName());
		parameters.put("cancelFlag", bizDictDef.getCancelFlag());
		parameters.put("dictType", bizDictDef.getDictType());
		parameters.put("_orderby", "DICT_DEF_ID");
		parameters.put("_order", "DESC");

		int count = dictDefService.queryBizDictDefTotalCount(parameters);

		// 分页
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		parameters.put("_start", pageParam.getStartRows());
		parameters.put("_end", pageParam.getEndRows());
		List<BizDictDef> list =MiscUtils.autoUnboxing(dictDefService.findDictDefList(parameters));
		pageParam.setItems(list);

		// 页面赋值
		DICT_TYPE[] dictTypeList = BizDict.DICT_TYPE.values();
		model.addAttribute("dictTypeList", dictTypeList);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("bizDictDef", bizDictDef);
		model.addAttribute("page", pageParam.getPage().toString());

		return "/biz/dict/findDictDefList";
	}

	/**
	 * 新增页跳转
	 */
	@RequestMapping(value = "/showAddDictDef.do")
	public String showAddDictDef(Model model, Long dictDefId) throws BusinessException {
		BizDictDef bizDictDef = new BizDictDef();
		DICT_TYPE[] dictTypeList = BizDict.DICT_TYPE.values();

		if (dictDefId != null) {
			bizDictDef = MiscUtils.autoUnboxing(dictDefService.findDictDefById(dictDefId));
		}
		model.addAttribute("bizDictDef", bizDictDef);
		model.addAttribute("dictTypeList", dictTypeList);

		return "/biz/dict/showAddDictDef";
	}

	/**
	 * 编辑页跳转
	 */
	@RequestMapping(value = "/updateDictDef")
	@ResponseBody
	public Object updateDictDef(BizDictDef bizDictDef) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<updateDict>");
		}

		dictDefService.updateDictDef(bizDictDef);
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

	@RequestMapping(value = "/addDictDef")
	@ResponseBody
	public Object addDictDef(BizDictDef bizDictDef) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<addDictDef>");
		}

		dictDefService.addDictDef(bizDictDef);
		return ResultMessage.ADD_SUCCESS_RESULT;
	}

	@RequestMapping(value = "/editDictDefFlag")
	@ResponseBody
	public Object editDictDefFlag(Long dictDefId, String cancelFlag) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<editDictDefFlag>");
		}

		dictDefService.editFlag(dictDefId, cancelFlag);
		return ResultMessage.SET_SUCCESS_RESULT;
	}

	@RequestMapping(value = "/findDictDefInSuggest.do")
	@ResponseBody
	public Object findDictDefInSuggest(Model model, String dictDefName) throws BusinessException {
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("dictDefName", dictDefName);
		parameters.put("cancelFlag", "Y");
		List<BizDictDef> list = MiscUtils.autoUnboxing(dictDefService.findDictDefList(parameters));
		return list;
	}
}