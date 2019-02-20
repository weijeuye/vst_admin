package com.lvmama.vst.back.biz.web;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizBranchProp;
import com.lvmama.vst.back.biz.po.BizCategoryProp;
import com.lvmama.vst.back.biz.po.BizPropPool;
import com.lvmama.vst.back.biz.service.BizPropPoolService;
import com.lvmama.vst.back.client.biz.service.BranchPropClientService;
import com.lvmama.vst.back.client.biz.service.CategoryPropClientService;
import com.lvmama.vst.back.client.destinationannouncement.service.Destinationannouncement2ClientService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.DESCoder;
import com.lvmama.vst.comm.utils.DateUtil;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.order.service.ScenicComplexQueryService;

@Controller
@RequestMapping("/biz/category")
public class BizPropPoolAction extends BaseActionSupport {

	@Autowired
	private BizPropPoolService bizPropPoolService;
	

	@Autowired
	private CategoryPropClientService categoryPropService;
	

	@Autowired
	private BranchPropClientService branchPropService;
	
	
	@Autowired
	private Destinationannouncement2ClientService destinationannouncement2ClientServiceRemote;

	@Autowired
	private ScenicComplexQueryService scenicComplexQuery;
	
	
	protected Logger LOG = Logger.getLogger(this.getClass());

	@RequestMapping(value = "/findBizPropPoolList")
	public String findBizPropPoolList(Model model, Integer page, BizPropPool bizPropPool, HttpServletRequest req) throws BusinessException {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("propType", bizPropPool.getPropType());
		params.put("propName", bizPropPool.getPropName());
		params.put("propCodeLike", bizPropPool.getPropCode());
		int count = bizPropPoolService.findBizPropPoolCount(params);

		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum); // 暂时不分页全取数据
		pageParam.buildUrl(req);
		params.put("_start", pageParam.getStartRows());
		params.put("_end", pageParam.getEndRows());
		params.put("_orderby", "PROP_ID DESC");
		List<BizPropPool> BizPropPools = bizPropPoolService.findAllPropsByParams(params);

		pageParam.setItems(BizPropPools);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("page", pageParam.getPage().toString());

		return "/biz/category/bizPropPoolList";
	}
	
	@RequestMapping(value = "/findObjectList")
	public String findObjectList(Model model, String sql, HttpServletRequest req) throws BusinessException {
		model.addAttribute("sql", sql);

		model.addAttribute("code", req.getParameter("code"));

		if(!checkUrlValid(req.getParameter("code"))){
			model.addAttribute("ERROR","亲，你没有权限!");
			return "/biz/category/findObjectList";
		}

		String[] authUsers = new String[]{"lv8865", "lv9629","lv6332","lv9423","lv9625", "lv6764", "admin",
				"lv5788","lv6852","lv1434","lv5457","lv1430","lv1543","lv6902","lv9532","lv6868","lv6901",
				"lv1231","lv9705","lv14705","lv16222","lv18192",  "lv14678", "lv15923","lv19552"};

		if(!Arrays.asList(authUsers).contains(getLoginUserId())) {
			model.addAttribute("ERROR","不在允许的人员列表内!");
			return "/biz/category/findObjectList";
		}

		if(!StringUtils.isEmpty(sql)) {
			List<Map<String, Object>> result=null;
			if(sql.trim().toLowerCase().startsWith("select ")) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("sql", sql);
				if(sql.toLowerCase().indexOf("lvmama_ord.") == -1)
					result = bizPropPoolService.findAllObjectsBySql(params);
				else
					result = scenicComplexQuery.findAllObjectsBySqlFromReadDB(params);
			} else {
				result = new ArrayList<Map<String,Object>>();
				Map<String, Object> e = new HashMap<String, Object>();
				e.put("ERROR", "not support");
				result.add(e );
			}
			if(result != null && result.size() > 0) {
				int size = result.get(0)==null?0:result.get(0).size();
				Set<String> head = result.get(0)==null?null:result.get(0).keySet();
				for(Map<String, Object> r : result) {
					if(r==null) {
						continue;
					}
					if(r.size() > size) {
						size = r.size();
						head = r.keySet();
					}
				}
				model.addAttribute("resultHead", head);
				model.addAttribute("resultList", result);
			}
		}

		return "/biz/category/findObjectList";
	}

	// 新增和修改页面跳转
	@RequestMapping(value = "/showBizPropPool")
	public String showBizPropPool(Model model, String operate, Long propId) throws BusinessException {
		String operateUrl = "";
		BizPropPool bizPropPool =  MiscUtils.autoUnboxing(bizPropPoolService.findBizPropPoolById(propId));
		
		model.addAttribute("bizPropPool", bizPropPool);
		model.addAttribute("inputtypes", Constant.PROPERTY_INPUT_TYPE_ENUM.values());
		if ("update".equalsIgnoreCase(operate)) {
			operateUrl = "/biz/category/showUpdateBizPropPool";
		} else if ("add".equalsIgnoreCase(operate)) {
			operateUrl = "/biz/category/showAddBizPropPool";
		}
		return operateUrl;
	}

	// 新增属性池
	@RequestMapping(value = "/addBizPropPool")
	@ResponseBody
	public Object addBizPropPool(BizPropPool bizPropPool) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<addBizPropPool>");
		}
		bizPropPool.setPropCode(bizPropPool.getPropCode().trim());
		bizPropPool.setPropName(bizPropPool.getPropName().trim());
		bizPropPoolService.addBizPropPool(bizPropPool);
		return ResultMessage.ADD_SUCCESS_RESULT;
	}

	// 修改属性池
	@RequestMapping(value = "/updateBizPropPool")
	@ResponseBody
	public Object updateBizPropPool(BizPropPool bizCateProp) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<updateBizPropPool>");
		}

		bizPropPoolService.updateBizPropPool(bizCateProp);
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

	/**
	 * 选择属性池属性列表
	 */
	@RequestMapping(value = "/selectBizPropPoolList")
	public String selectBizPropPoolList(Model model, Integer page, BizPropPool bizPropPool, 
		String callback, Long categoryId, Long groupId, String propType, Long branchId, HttpServletRequest req) throws BusinessException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		if(propType != null){
			params.put("propType", propType);
		}else{
			params.put("propType", bizPropPool.getPropType());
		}
		if(branchId != null){
			params.put("notInBranchId", branchId);
		}else{
			if(categoryId != null){
				params.put("notInCategoryId", categoryId);
			}
		}
		params.put("propName", bizPropPool.getPropName());
		params.put("propId", bizPropPool.getPropId());
		params.put("propCodeLike", bizPropPool.getPropCode());
		int count  = bizPropPoolService.findBizPropPoolCount(params);
		
	    int pagenum = page == null? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		params.put("_start", pageParam.getStartRows());
		params.put("_end", pageParam.getEndRows());
		params.put("_orderby", "PROP_ID DESC");
		List<BizPropPool> BizPropPools = bizPropPoolService.findAllPropsByParams(params);
		
		pageParam.setItems(BizPropPools);
		model.addAttribute("branchId", branchId);
		model.addAttribute("groupId", groupId);
		model.addAttribute("categoryId", categoryId);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("callback", callback);
		model.addAttribute("page", pageParam.getPage().toString());
		 
		return "/biz/category/selectBizPropPoolList";
	}

	// 新增属性(品类或规格下属性)
	@RequestMapping(value = "/addProp")
	@ResponseBody
	public Object addProp(String batchPropIds, Long categoryId, Long groupId, Long branchId) throws BusinessException, IllegalAccessException, InvocationTargetException {
		if (log.isDebugEnabled()) {
			log.debug("start method<addProp>");
		}

		for (String propId : batchPropIds.split(",")) {
			BizPropPool po = bizPropPoolService.findBizPropPoolById(Long.parseLong(propId));
			if (groupId != null) {
				BizCategoryProp bizCateProp = new BizCategoryProp();
				bizCateProp.setCategoryId(categoryId);
				bizCateProp.setGroupId(groupId);
				BeanUtils.copyProperties(bizCateProp, po);
				bizCateProp.setPropId(null); // 防止BizPropPool中PropId传递
				categoryPropService.addCategoryProp(bizCateProp);
			} else if (branchId != null) {
				BizBranchProp bizBranchProp = new BizBranchProp();
				bizBranchProp.setBranchId(branchId);
				BeanUtils.copyProperties(bizBranchProp, po);
				bizBranchProp.setPropId(null); // 防止BizPropPool中PropId传递
				branchPropService.addBranchProp(bizBranchProp);
			}
		}
		return ResultMessage.ADD_SUCCESS_RESULT;
	}
	
	private boolean checkUrlValid(String code){
		if(code == null){
			return false;
		}
		
		try{
			code = DESCoder.decrypt(code);
			String today = DateUtil.formatSimpleDate(DateUtil.getTodayDate());

			if(today.equalsIgnoreCase(code)){
				return true;
			}
		}catch(Exception e){
			log.error(e);
		}
		return false;
	}

	@RequestMapping(value = "/findObjFromCacheByKey")
	public String findObjFromCacheByKey(Model model, String key, HttpServletRequest req) throws BusinessException {
		if(!checkUrlValid(req.getParameter("code"))){
			return ("failed + 连接非法");
		}

		LOG.info("get key start key is="+key);
		boolean isSessionBoolean =false;
		String isSession = req.getParameter("isSession");

		if("Y".equalsIgnoreCase(isSession)){
			LOG.info("is Y");
			isSessionBoolean=true;
		}
		StringBuilder string = new StringBuilder();
		if(!StringUtils.isEmpty(key)) {

			LOG.info("MemcacheUtil key start key is="+key);
			Object obj = MemcachedUtil.getInstance().get(key,isSessionBoolean);
			if(obj != null){
				string.append("原始内容：");
				string.append(obj);
				String cache = ToStringBuilder.reflectionToString(obj);
				string.append("<br/>格式化后内容：");
				string.append(cache);
			}
		}
		model.addAttribute("key", key);
		model.addAttribute("cache", string.toString());
		model.addAttribute("code", req.getParameter("code"));

		return "/biz/category/findCacheByKey";
	}

	@RequestMapping(value = "/board/findObjectList")
	public String Mysql_Board_findObjectList(Model model, String sql, HttpServletRequest req) throws BusinessException {
		model.addAttribute("sql", sql);
		model.addAttribute("code", req.getParameter("code"));

		if(!checkUrlValid(req.getParameter("code"))){
			model.addAttribute("ERROR","亲，你没有权限!");
			return "/biz/category/boardfindObjectList";
		}

		String[] authUsers = new String[]{"lv10283", "lv9629","lv6332","lv9423","lv9625", "lv6764", "admin", "lv5788","lv6852","lv1434","lv5457","lv1430","lv1543","lv6902","lv9532","lv6868","lv6901","lv1231","lv9705","lv14705","lv6800","lv19552"};

		if(!Arrays.asList(authUsers).contains(getLoginUserId())) {
			model.addAttribute("ERROR","不在允许的人员列表内!");
			return "/biz/category/boardfindObjectList";
		}

		if(!StringUtils.isEmpty(sql)) {
			List<Map<String, Object>> result=null;
			if(sql.trim().toLowerCase().startsWith("select ")) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("sql", sql);
				
				ResultHandleT<List<Map<String, Object>>> resultHandleT = destinationannouncement2ClientServiceRemote.findAllObjectsBySql(params);
				if(resultHandleT == null || resultHandleT.isFail()){
					result = new ArrayList<Map<String,Object>>();
					Map<String, Object> e = new HashMap<String, Object>();
					e.put("ERROR", resultHandleT.getMsg());
					result.add(e );
				}else {
					result = resultHandleT.getReturnContent();
				}
			} else {
				result = new ArrayList<Map<String,Object>>();
				Map<String, Object> e = new HashMap<String, Object>();
				e.put("ERROR", "not support");
				result.add(e );
			}
			if(result != null && result.size() > 0) {
				int size = result.get(0)==null?0:result.get(0).size();
				Set<String> head = result.get(0)==null?null:result.get(0).keySet();
				for(Map<String, Object> r : result) {
					if(r==null) {
						continue;
					}
					if(r.size() > size) {
						size = r.size();
						head = r.keySet();
					}
				}
				model.addAttribute("resultHead", head);
				model.addAttribute("resultList", result);
			}
		}

		return "/biz/category/boardfindObjectList";
	}

}
