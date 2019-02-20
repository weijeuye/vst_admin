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

import com.lvmama.vst.back.biz.po.BizDest;
import com.lvmama.vst.back.biz.po.BizDestShop;
import com.lvmama.vst.back.biz.service.BizDestShopService;
import com.lvmama.vst.back.client.biz.service.DestClientService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 购物点维护
 * @author luolihua
 *
 */
@SuppressWarnings({"rawtypes","unchecked"})
@Controller
@RequestMapping("/biz/bizDestShop")
public class BizDestShopAction extends BaseActionSupport {

	private static final long serialVersionUID = 5382773196841020123L;
	
	@Autowired
	private BizDestShopService bizDestShopService;
	
	@Autowired
	private DestClientService destService;
	
	
	//查询列表
	@RequestMapping(value = "/findBizDestShopList")
	public String findBizDestShopList(Model model, Integer page, BizDestShop bizDestShop, String destName, String cancelFlag, HttpServletRequest req) throws BusinessException {
		if(log.isDebugEnabled()) {
			log.debug("start method<findBizDestShopList>");
		}
		Map<String, Object> params = new HashMap<String,Object>();
		//目的地ID
		params.put("destId", bizDestShop.getDestId());
		//目的地名称
		params.put("destName", destName);
		//主营产品
		params.put("mainProducts", bizDestShop.getMainProducts());
		//兼营产品
		params.put("subjoinProducts", bizDestShop.getSubjoinProducts());
		//是否有效
		if(cancelFlag == null) {
			model.addAttribute("cancelFlag", "null");
		} else if("Y".equals(cancelFlag) || "N".equals(cancelFlag)) {
			params.put("cancelFlag", cancelFlag);
			model.addAttribute("cancelFlag", cancelFlag);
		} else {
			model.addAttribute("cancelFlag", "all");
		}
		
		//类型为购物地
		params.put("destType", BizDest.DEST_TYPE.SHOP);
		int count = MiscUtils.autoUnboxing(destService.findDestCount(params));
		
		
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		params.put("_start", pageParam.getStartRows());
		params.put("_end", pageParam.getEndRows());
		//注入购物点
		params.put("bds", true);
		List<BizDest> list = MiscUtils.autoUnboxing(destService.findDestList(params));
		pageParam.setItems(list);
		
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("page", pageParam.getPage().toString());
		model.addAttribute("bizDestShop", bizDestShop);
		model.addAttribute("destName", destName);
		
		return "/biz/dest/findBizDestShopList";
	}

	//跳转到修改页面
	@RequestMapping(value = "/showUpdateBizDestShop")
	public String showUpdateBizDestShop(Model model, Long destId) throws BusinessException {
		if(log.isDebugEnabled()) {
			log.debug("start method<showUpdateBizDestShop>");
		}
		//购物点维护
		BizDest bizDest = destService.findDestDetailById(destId);
		bizDest.setBizDestShop(bizDestShopService.getByDestId(destId));
		model.addAttribute("bizDest", bizDest);
		model.addAttribute("destTypeList", BizDest.DEST_TYPE.values());
		model.addAttribute("destMarkList", BizDest.DEST_MARK.values());
		return "/biz/dest/showUpdateBizDestShop";
	}
	
	//更新购物点
	@RequestMapping(value = "/saveOrUpdateBizDestShop")
	@ResponseBody
	public Object saveOrUpdateBizDestShop(BizDestShop bizDestShop) throws BusinessException {
		if(log.isDebugEnabled()) {
			log.debug("start method<updateBizDestShop>");
		}
		bizDestShopService.saveOrUpdateBizDestShop(bizDestShop);
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}
}