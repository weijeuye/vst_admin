package com.lvmama.vst.back.biz.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.lvmama.vst.back.biz.po.BizDict;
import com.lvmama.vst.back.biz.po.BizDictDef;
import com.lvmama.vst.back.client.biz.service.DictClientService;
import com.lvmama.vst.back.client.biz.service.DictDefClientService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 邮轮公司Action
 * 
 * @author zhangwei
 */
@Controller
@RequestMapping("/biz/bussinessDict")
public class BussinessDictAction extends BaseActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1863773297050916212L;

	private static final Log LOG = LogFactory.getLog(BussinessDictAction.class);

	@Autowired
	private DictClientService dictService;

	@Autowired
	private DictDefClientService dictDefService;

	/**
	 * 获得列表
	 * 
	 * @param model
	 * @param page
	 *            分页参数
	 * @param prodProduct
	 *            查询条件
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/findBussinessDictList")
	public String findShipCompanyList(Model model, Integer page,BizDictDef bizDictDef,BizDict bizDict, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<findBussinessDictList>");
		}
		
		if(isRedirectShipBack(req)){
			String permId = req.getParameter("permId");
			if( null == permId ){
				permId = "";
			}
			return "redirect:http://super.lvmama.com/ship_back/biz/bussinessDict/findBussinessDictList.do?dictCode=liner_company&permId="+permId;
		}
		
		BizDictDef linerCompanyBizDictDef=BizBussinessDictDef(bizDictDef,bizDict);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("dictId", bizDict.getDictId());
		params.put("dictName", bizDict.getDictName());
		params.put("dictDefId", linerCompanyBizDictDef.getDictDefId());

		int count = dictService.findDictCount(params);

		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		params.put("_start", pageParam.getStartRows());
		params.put("_end", pageParam.getEndRows());
		params.put("_orderby", "bd.DICT_ID");
		params.put("_order", "DESC");

		List<BizDict> bizDictList= MiscUtils.autoUnboxing( dictService.findDictList(params) );
		pageParam.setItems(bizDictList);
		model.addAttribute("bizdictdef",linerCompanyBizDictDef);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("bizDict", bizDict);
		return "/biz/bussinessDict/findBussinessDictList";
	}
	
	private boolean isRedirectShipBack(HttpServletRequest req){
		String dictCode = req.getParameter("dictCode");
		if( "liner_company".equalsIgnoreCase(dictCode)){
			return true;
		}
		return false;
	}
	
	private BizDictDef BizBussinessDictDef(BizDictDef bizDictDef,BizDict bizDict) {
		Map<String, Object> parameters = new HashMap<String, Object>();
		if(bizDictDef == null){
			parameters.put("dictDefId",bizDict.getDictDefId());
		}else{
		parameters.put("cancelFlag", "Y");
		parameters.put("dictCode",bizDictDef.getDictCode());
		}
		
		List<BizDictDef> bizDictDeflist = MiscUtils.autoUnboxing( dictDefService.findDictDefList(parameters) );
		
		BizDictDef linerCompanyBizDictDef=bizDictDeflist.get(0);
		return linerCompanyBizDictDef;
		
	}
	
}
