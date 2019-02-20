package com.lvmama.vst.back.biz.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lvmama.vst.back.client.biz.service.IMsgMultiLangClientService;
import com.lvmama.vst.back.client.biz.service.SubjectClientService;
import com.lvmama.vst.back.client.prod.service.ProdSubjectClientService;
import com.lvmama.vst.comlog.LvmmLogClientService;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;

import com.lvmama.vst.comm.vo.ResultHandleT;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.po.BizSubject;
import com.lvmama.vst.back.biz.po.MuitlLangMessage;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdSubject;
import com.lvmama.vst.back.prod.service.ProdProductQueryService;
import com.lvmama.vst.back.prod.vo.BizSubjectVO;
import com.lvmama.vst.back.prod.vo.MultiLangMessageVO;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.pub.service.PushAdapterServiceRemote;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.utils.json.JSONOutput;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;

@SuppressWarnings({"rawtypes","unchecked"})
@Controller
@RequestMapping("/biz/bizSubject")
public class BizSubjectAction extends BaseActionSupport {

	private static final long serialVersionUID = -6198856582225829130L;
	
	private static final String DEFAULT_LANG_MSG_LINK_TEXT = "配置多语言[英文，繁体中文，韩文，日文]";
	
	@Autowired
	PushAdapterServiceRemote pushAdapterService;
	
	@Autowired
	private SubjectClientService subjectClientService;
	
	@Autowired
	private ProdSubjectClientService prodSubjectClientService;

	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;
	@Autowired
	private ProdProductQueryService prodProductQueryService;

	@Autowired
	private LvmmLogClientService lvmmLogClientService;
	
	@Autowired
	private IMsgMultiLangClientService iMsgMultiLangClientService;
	
	/**
	 * 显示查询主题信息页面
	 */
	@RequestMapping(value = "/showBizSubjectList")
	public String showBizSubjectList(Model model,BizSubject bizSubject,HttpServletRequest req) throws BusinessException {
		// 查询主题小组名称
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cancelFlag", "Y");
		ResultHandleT<List<BizSubject>> resultHandleT = subjectClientService.findBizSubjectGroupListByParams(map);
		if(resultHandleT == null || resultHandleT.isFail()){
			log.error(resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		List<BizSubject> subjectGroups = resultHandleT.getReturnContent();
		model.addAttribute("subjectGroups", subjectGroups);
		model.addAttribute("subjectTypeList", BizSubject.SUBJECT_TYPE.values());
		model.addAttribute("bizSubject", bizSubject);
		return "/biz/prodSubject/findBizSubjectList";
	}
	
	
	@RequestMapping(value = "/setBizSubjectMultiLang")
	public String setBizSubjectMultiLang (Model model, Long messageId, HttpServletRequest req) throws BusinessException {
		
		MultiLangMessageVO multiLangMessageVO = null;
		
		if(messageId!=null && messageId > 0L) {
			ResultHandleT<MultiLangMessageVO> multiLangMessageResultHandleT = iMsgMultiLangClientService.selectByPrimaryKey(messageId);
			if(multiLangMessageResultHandleT == null || multiLangMessageResultHandleT.isFail()){
				log.error(multiLangMessageResultHandleT == null ? "ResultHandleT is empty..." : multiLangMessageResultHandleT.getMsg());
				throw new BusinessException(multiLangMessageResultHandleT.getMsg());
			}
			multiLangMessageVO = multiLangMessageResultHandleT.getReturnContent();
			multiLangMessageVO.setMessageSource(MuitlLangMessage.SOURCE.BIZ_SUBJECT.name());
		}
		model.addAttribute("messageSource", MuitlLangMessage.SOURCE.BIZ_SUBJECT.name());
		model.addAttribute("multiLangMessageSetting", multiLangMessageVO);
		return "/biz/prodTag/showTextMultiLangSetting";
	}
	/**
	 * 查询主题信息
	 */
	@RequestMapping(value = "/findBizSubjectList")
	public String findBizSubjectList(Model model, Integer page,BizSubject bizSubject,HttpServletRequest req) throws BusinessException {
		// 查询主题小组名称
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cancelFlag", "Y");
		ResultHandleT<List<BizSubject>> resultHandleT = subjectClientService.findBizSubjectGroupListByParams(map);
		if(resultHandleT == null || resultHandleT.isFail()){
			log.error(resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		List<BizSubject> subjectGroups = resultHandleT.getReturnContent();
		model.addAttribute("subjectGroups", subjectGroups);

		model.addAttribute("subjectTypeList", BizSubject.SUBJECT_TYPE.values());
		
		// 查询标签配置信息
		Map<String,Object> params = new HashMap<String, Object>();
		if(null!=bizSubject){
			params.put("subjectType", bizSubject.getSubjectType());// 类型
			params.put("subjectGroup", bizSubject.getSubjectGroup());//主题小组
			params.put("subjectName", bizSubject.getSubjectName());// 名称
			params.put("redFlag", bizSubject.getRedFlag());// 是否标红
			params.put("cancelFlag", bizSubject.getCancelFlag());// 是否有效
		}
		
		ResultHandleT<Integer> resultHandleTCount = subjectClientService.queryBizSubjectTotalCount(params);
		if(resultHandleTCount == null || resultHandleTCount.isFail()){
			log.error(resultHandleTCount.getMsg());
			throw new BusinessException(resultHandleTCount.getMsg());
		}
		int count = resultHandleTCount.getReturnContent() == null ? 0 : resultHandleTCount.getReturnContent();
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		params.put("_start", pageParam.getStartRowsMySql());
		params.put("_pageSize", pageParam.getPageSize());
		params.put("_orderby", "SEQ");
		params.put("_order", "ASC");			
		ResultHandleT<List<BizSubject>> resultHandleTList = subjectClientService.findBizSubjectListByParams(params);
		if(resultHandleTList == null || resultHandleTList.isFail()){
			log.error(resultHandleTList.getMsg());
			throw new BusinessException(resultHandleTList.getMsg());
		}
		List<BizSubject> list = resultHandleTList.getReturnContent();
		pageParam.setItems(list);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("page", pageParam.getPage().toString());
		model.addAttribute("bizSubject", bizSubject);
		
		return "/biz/prodSubject/findBizSubjectList";
	}
	
	
	/**
	 * 查询主题信息{支持模糊查询}
	 * @param search 查询条件即主题名称
	 * @param res
	 */
	@RequestMapping(value = "/searchBizSubject")
	public void searchBizSubject(String search,Long categoryId, HttpServletResponse res){
		if (log.isDebugEnabled()) {
			log.debug("start method<searchBizSubject>");
		}
		Map<String,Object> params = new HashMap<String, Object>();
		params.put("subjectName", search);
		params.put("cancelFlag", "Y");
		String subjectType = null;
		if(categoryId != null) {
			BizCategory cate = bizCategoryQueryService.getCategoryById(categoryId);
			if(cate != null){
    			if(cate.getParentId() ==null) {
    				subjectType = cate.getCategoryCode();
    			} else {
    				BizCategory cate1 = bizCategoryQueryService.getCategoryById(cate.getParentId());
    				if(cate1 != null && cate1.getParentId() ==null) {
    					subjectType = cate1.getCategoryCode();
    				}
    			}
			}
		}
		params.put("subjectType", subjectType );
		
		ResultHandleT<List<BizSubject>> listResultHandleT = subjectClientService.findBizSubjectListByParams(params);
		if(listResultHandleT == null || listResultHandleT.isFail()){
			log.error(listResultHandleT.getMsg());
			throw new BusinessException(listResultHandleT.getMsg());
		}
		JSONArray array = new JSONArray();
		if(CollectionUtils.isNotEmpty(listResultHandleT.getReturnContent())){
			for(BizSubject bizSubject : listResultHandleT.getReturnContent()){
				JSONObject obj=new JSONObject();
				obj.put("id", bizSubject.getSubjectId());
				obj.put("text", bizSubject.getSubjectName());
				array.add(obj);
			}
		}
		JSONOutput.writeJSON(res, array);
	}

	/**
	 * 根据小组名称查询有效小组主题
	 */
	@RequestMapping(value = "/findAllSubjectNameByGroup")
	@ResponseBody
	public Object findAllSubjectNameByGroup(String iniAll, String isAll, String subjectGroup, HttpServletResponse res) throws BusinessException {
		// 查询主题名称
		try {
			subjectGroup = (subjectGroup == "" ? subjectGroup : URLDecoder.decode(subjectGroup, "UTF-8"));
			iniAll = (iniAll == null ? iniAll : URLDecoder.decode(iniAll, "UTF-8"));
		} catch (UnsupportedEncodingException e) {
		}

		ResultHandleT<List<BizSubject>> listResultHandleT = null;
		BizSubject bizSubject = new BizSubject();
		bizSubject.setSubjectGroup(subjectGroup);
		if ("Y".equals(isAll)) {
			listResultHandleT = subjectClientService.findBizAllSubjectNameByGroup(bizSubject);
		} else {
			bizSubject.setCancelFlag("Y");
			listResultHandleT = subjectClientService.findBizAllSubjectNameByGroup(bizSubject);
		}
		if(listResultHandleT == null || listResultHandleT.isFail()){
			log.error(listResultHandleT.getMsg());
			throw new BusinessException(listResultHandleT.getMsg());
		}
		List<BizSubject> subjectNames = listResultHandleT.getReturnContent();

		JSONArray array = new JSONArray();

		if (null != iniAll) {
			JSONObject obj1 = new JSONObject();
			obj1.put("subjectValue", "");
			obj1.put("subjectName", iniAll);
			array.add(obj1);
		}

		if (CollectionUtils.isNotEmpty(subjectNames)) {
			for (BizSubject bs : subjectNames) {
				JSONObject obj = new JSONObject();
				obj.put("subjectValue", bs.getSubjectName());
				obj.put("subjectName", bs.getSubjectName());
				array.add(obj);
			}
		}
		return array;
	}



	
	/**
	 * 跳转到产品与主题关联关系页面
	 */
	@RequestMapping(value = "/showProdProduct")
	public String showProdProduct(Model model,Integer page, BizSubject bizSubject, HttpServletRequest req) throws BusinessException {
		
		// 查询产品与主题关联关系
		Map<String,Object> params = new HashMap<String, Object>();
		if(null!=bizSubject){
			params.put("subjectId", bizSubject.getSubjectId());
		}
		
		ResultHandleT<Integer> resultHandleTCount = prodSubjectClientService.queryProdSubjectTotalCount(params);
		if(resultHandleTCount == null || resultHandleTCount.isFail()){
			log.error(resultHandleTCount.getMsg());
			throw new BusinessException(resultHandleTCount.getMsg());
		}
		int count = resultHandleTCount.getReturnContent() == null ? 0 : resultHandleTCount.getReturnContent();
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		params.put("_start", pageParam.getStartRowsMySql());
		params.put("_pageSize", pageParam.getPageSize());
		params.put("_orderby", "RE_ID");
		params.put("_order", "DESC");
		List<ProdSubject> prodSubjects = prodSubjectClientService.findProdSubjectListByParams(params,false);
		if(CollectionUtils.isNotEmpty(prodSubjects)){
			for (ProdSubject prodSubject : prodSubjects) {
				// 查询产品信息
				ProdProduct prodProduct = prodProductQueryService.findProdProductSimpleById(prodSubject.getProductId());
				prodSubject.setProdProduct(prodProduct);

			}
		}

		pageParam.setItems(prodSubjects);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("page", pageParam.getPage().toString());
		model.addAttribute("bizSubject", bizSubject);
		
		return "/biz/prodSubject/showProdSubjectList";
	}
	
	@RequestMapping(value = "/getSubjectTypeForParentTypeCode")
	@ResponseBody
	public Object getSubjectTypeForParentTypeCode(String parentSubjectTypeCode){
		try {
			List<BizSubject.SUBJECT_TYPE> list = BizSubject.SUBJECT_TYPE.getObjectTypes(parentSubjectTypeCode);
			Map map = new HashMap();
			for(BizSubject.SUBJECT_TYPE item :list){
				map.put(item.getCode(),item.getCnName());
			}
			JSONObject obj = JSONObject.fromObject(map);
			
			return obj;
		} catch (Exception e) {
			return new ResultMessage("error","父标题类型错误");
		}
		
	}
	
	/**
	 * 跳转到批量修改页面
	 */
	@RequestMapping(value = "/batchUpdateBizSubject")
	public String batchUpdateBizSubject(Model model, BizSubjectVO bizSubjectVO) throws BusinessException {
		model.addAttribute("bizSubjectVO", bizSubjectVO);

		return "/biz/prodSubject/batchUpdateBizSubject";
	}
	
	/**
	 * 批量修改保存
	 */
	@RequestMapping(value = "/saveBatchUpdateBizSubject")
	@ResponseBody
	public Object saveBatchUpdateBizSubject(BizSubjectVO bizSubjectVO) throws BusinessException {
		if(bizSubjectVO != null) {
			PermUser user = getLoginUser();
			Long[] objectIds = bizSubjectVO.getObjectIds();
			if (null != objectIds && objectIds.length > 0) {
				for (Long objectId : objectIds) {
					ResultHandleT<BizSubject> resultHandleT = subjectClientService.findBizSubjectById(objectId);
					if(resultHandleT == null || resultHandleT.isFail()){
						log.error(resultHandleT.getMsg());
						throw new BusinessException(resultHandleT.getMsg());
					}
					BizSubject bizSubject = resultHandleT.getReturnContent();
					if(bizSubject != null) {
						BizSubject oldBizSubject = new BizSubject();
						BeanUtils.copyProperties(bizSubject, oldBizSubject);
						
						//更新修改人
						if(null != user){
							bizSubject.setUpdateUser(user.getUserName());
						}
						//更新状态
						bizSubject.setCancelFlag(bizSubjectVO.getCancelFlag());
						try {
							ResultHandleT<Integer> resultHandleTCount = subjectClientService.updateBizSubject(bizSubject);
							if(resultHandleTCount == null || resultHandleTCount.isFail()){
								log.error(resultHandleTCount.getMsg());
								throw new BusinessException(resultHandleTCount.getMsg());
							}
							int result = resultHandleTCount.getReturnContent() == null ? 0 : resultHandleTCount.getReturnContent();
							if (result != 0) {
								pushAdapterService.push(bizSubject.getSubjectId(), ComPush.OBJECT_TYPE.SUBJECT, ComPush.PUSH_CONTENT.BIZ_SUBJECT,ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
								//获取操作日志
								String logContent = getBizSubjectChangeLog(oldBizSubject, bizSubject);
								//添加操作日志
								if(StringUtil.isNotEmptyString(logContent)) {
									lvmmLogClientService.sendLog(
											COM_LOG_OBJECT_TYPE.SUBJECT, oldBizSubject.getSubjectId(), oldBizSubject.getSubjectId(),
											user != null ? user.getUserName() : null,
											"批量修改主题：【"+bizSubject.getSubjectName()+"】，修改内容："+logContent, 
											COM_LOG_LOG_TYPE.SUBJECT_UPDATE.name(), 
											"批量修改主题",null);									
								}
							}
						} catch (Exception e) {
							log.error("Record Log failure ！Log Type:"+COM_LOG_LOG_TYPE.SUBJECT_UPDATE.name());
							log.error(e.getMessage());
						}
					}
				}
			}
		}
		
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}
	
	/**
	 * 跳转到保存与新增页面
	 */
	@RequestMapping(value = "/showSaveOrUpdateBizSubject")
	public String showSaveOrUpdateBizSubject(Model model, BizSubject bizSubject) throws BusinessException {
		model.addAttribute("parentSubjectTypeList",BizSubject.PARENT_TYPE.values());
		// 查询小组名称
		Map<String, Object> map = new HashMap<String, Object>();
		String msgMultiLangLinkText = DEFAULT_LANG_MSG_LINK_TEXT;
		
		// map.put("cancelFlag", "Y");
		ResultHandleT<List<BizSubject>> listResultHandleT = subjectClientService.findBizSubjectGroupListByParams(map);
		if(listResultHandleT == null || listResultHandleT.isFail()){
			log.error(listResultHandleT.getMsg());
			throw new BusinessException(listResultHandleT.getMsg());
		}
		List<BizSubject> subjectGroups = listResultHandleT.getReturnContent();
		if(null!=bizSubject){
    		if(null!=bizSubject.getSubjectId()){
    			// 查询主题引用次数
    			Map<String,Object> params = new HashMap<String, Object>();
    			params.put("subjectId", bizSubject.getSubjectId());
				ResultHandleT<Integer> resultHandleTCount = prodSubjectClientService.queryProdSubjectTotalCount(params);
				if(resultHandleTCount == null || resultHandleTCount.isFail()){
					log.error(resultHandleTCount.getMsg());
					throw new BusinessException(resultHandleTCount.getMsg());
				}
				int count = resultHandleTCount.getReturnContent() == null ? 0 : resultHandleTCount.getReturnContent();
    			model.addAttribute("count", count);
    			// 查询主题信息
    			ResultHandleT<BizSubject> resultHandleT = subjectClientService.findBizSubjectById(bizSubject.getSubjectId());
				if(resultHandleT == null || resultHandleT.isFail()){
					log.error(resultHandleT.getMsg());
					throw new BusinessException(resultHandleT.getMsg());
				}
				bizSubject = resultHandleT.getReturnContent();
				//多语言信息
				Long messageId = bizSubject.getMessageId();
				if(messageId != null && messageId > 0L) {
					MultiLangMessageVO multiLangMessage = iMsgMultiLangClientService.selectByPrimaryKey(messageId).getReturnContent();
					if(multiLangMessage!=null) {
						msgMultiLangLinkText = multiLangMessage.getLinkText();
					}
				}
    			//修改主题时
    			String parentName = BizSubject.SUBJECT_TYPE.getParentObjectType(bizSubject.getSubjectType()).name();
    			List<BizSubject.SUBJECT_TYPE> list = BizSubject.SUBJECT_TYPE.getObjectTypes(parentName);
    			model.addAttribute("subjectTypeList",list);
    			model.addAttribute("parentSubjectType",parentName);
    		
    		} else {
    			//默认
    			bizSubject.setSeq(1);
    		}
		}
		model.addAttribute("bizSubjectNameLinkText", msgMultiLangLinkText);
		model.addAttribute("bizSubject", bizSubject);
		model.addAttribute("subjectGroups", subjectGroups);
		return "/biz/prodSubject/showSaveOrUpdateBizSubject";
	}
	
	/**
	 *  新增或修改主题信息
	 */
	@RequestMapping(value = "/saveOrUpdateProdTag")
	@ResponseBody
	public Object saveOrUpdateProdTag(BizSubject bizSubject) throws BusinessException {
		if(null == bizSubject){
			return new ResultMessage("error", "参数错误");
		}
		if(StringUtil.isEmptyString(bizSubject.getSubjectName())){
			return new ResultMessage("error", "主题名称不能为空");
		}
		if(StringUtil.isEmptyString(bizSubject.getPinyin())){
			return new ResultMessage("error", "主题拼音不能为空");
		}
		if(StringUtil.isEmptyString(bizSubject.getSubjectType())){
			return new ResultMessage("error", "主题类型不能为空");
		}
		Integer seq = bizSubject.getSeq();
		if(!StringUtil.isNumber(seq+"")){
			bizSubject.setSeq(1);
		}
		PermUser user = getLoginUser();
		Long subjectId = bizSubject.getSubjectId();
		// 判断是否新增或修改
		ResultMessage result = null;
		if(null == subjectId){
			if(null != user){
				bizSubject.setCreateUser(user.getUserName());
				bizSubject.setUpdateUser(user.getUserName());
			}
			if (StringUtil.isNotEmptyString(bizSubject.getAddSubjectGroup())) {
				bizSubject.setSubjectGroup(bizSubject.getAddSubjectGroup());
			}
			ResultHandleT<BizSubject> resultHandleT = subjectClientService.addBizSubject(bizSubject);
			if(resultHandleT == null || resultHandleT.isFail()){
				log.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
				throw new BusinessException(resultHandleT.getMsg());
			}
			bizSubject = resultHandleT.getReturnContent();
			pushAdapterService.push(bizSubject.getSubjectId(), ComPush.OBJECT_TYPE.SUBJECT, ComPush.PUSH_CONTENT.BIZ_SUBJECT,ComPush.OPERATE_TYPE.ADD, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
			try {
				lvmmLogClientService.sendLog(COM_LOG_OBJECT_TYPE.SUBJECT,
						bizSubject.getSubjectId(), bizSubject.getSubjectId(), getLoginUser() != null ? getLoginUser().getUserName() : null,
						"添加了主题：【" + bizSubject.getSubjectName() + "】",
						COM_LOG_LOG_TYPE.SUBJECT_ADD.name(), "添加主题", null);
			} catch (Exception e) {
				log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.SUBJECT_ADD.name());
				log.error(e.getMessage());
			}
			result = ResultMessage.ADD_SUCCESS_RESULT;
			return result;
		} else {
			if(null != user){
				bizSubject.setUpdateUser(user.getUserName());
			}
			if (StringUtil.isNotEmptyString(bizSubject.getAddSubjectGroup())) {
				bizSubject.setSubjectGroup(bizSubject.getAddSubjectGroup());
			}
			ResultHandleT<BizSubject> resultHandleT = subjectClientService.findBizSubjectById(bizSubject.getSubjectId());
			if(resultHandleT == null || resultHandleT.isFail()){
				log.error(resultHandleT.getMsg());
				throw new BusinessException(resultHandleT.getMsg());
			}
			BizSubject oldBizSubject = resultHandleT.getReturnContent();
			subjectClientService.updateBizSubject(bizSubject);
			pushAdapterService.push(bizSubject.getSubjectId(), ComPush.OBJECT_TYPE.SUBJECT, ComPush.PUSH_CONTENT.BIZ_SUBJECT,ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
			try {
				//获取操作日志
				String logContent = getBizSubjectChangeLog(oldBizSubject, bizSubject);
				//添加操作日志
				if(null != logContent && !"".equals(logContent)) {
					lvmmLogClientService.sendLog(
							COM_LOG_OBJECT_TYPE.SUBJECT, oldBizSubject.getSubjectId(), oldBizSubject.getSubjectId(),
							getLoginUser() != null ? getLoginUser().getUserName() : null,
							"修改了主题：【"+bizSubject.getSubjectName()+"】，修改内容："+logContent, 
							COM_LOG_LOG_TYPE.SUBJECT_UPDATE.name(), 
							"修改主题",null);
				}
			} catch (Exception e) {
				log.error("Record Log failure ！Log Type:"+COM_LOG_LOG_TYPE.SUBJECT_UPDATE.name());
				log.error(e.getMessage());
			}
			result = ResultMessage.UPDATE_SUCCESS_RESULT;
		}
		return result;
	}
	
	/**
	 * 删除主题信息
	 */
	@RequestMapping(value = "/deleteBizSubjectByReId")
	@ResponseBody
	public Object deleteBizSubjectByReId(BizSubject bizSubject,HttpServletRequest req) throws BusinessException {
		if(null==bizSubject || null==bizSubject.getSubjectId()){
			return new ResultMessage("error","请选择删除的信息"); 
		}
		subjectClientService.deleteBizSubjectById(bizSubject.getSubjectId());
		pushAdapterService.push(bizSubject.getSubjectId(), ComPush.OBJECT_TYPE.SUBJECT, ComPush.PUSH_CONTENT.BIZ_SUBJECT,ComPush.OPERATE_TYPE.DEL, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
		return ResultMessage.DELETE_SUCCESS_RESULT;
	}

	/**
	 * 判断主题名称、拼音是否存在
	 */
	@RequestMapping(value = "/subjectNameOrPyisExists")
	@ResponseBody
	public Object subjectNameOrPyisExists(BizSubject bizSubject) throws BusinessException {
		if(null!=bizSubject){
			ResultHandleT<Boolean> resultHandleT = subjectClientService.subjectNameOrPYisExists(bizSubject);
			if(resultHandleT == null){
				log.error("ResultHandleT is empty...");
				throw new BusinessException("ResultHandleT is empty...");
			}
			if(!resultHandleT.getReturnContent()){
				return new ResultMessage("error", resultHandleT.getMsg());
			}
		}
		return new ResultMessage("success","不存在");
	}
	
	//拼接主题日志内容
	private String getBizSubjectChangeLog(BizSubject oldBizSubject, BizSubject newBizSubject) {
		StringBuffer logStr = new StringBuffer("");
		if(null != newBizSubject) {
			logStr.append(ComLogUtil.getLogTxt("小组名称", newBizSubject.getSubjectGroup(), oldBizSubject.getSubjectGroup()));
			logStr.append(ComLogUtil.getLogTxt("主题名称", newBizSubject.getSubjectName(), oldBizSubject.getSubjectName()));
			logStr.append(ComLogUtil.getLogTxt(" 拼音", newBizSubject.getPinyin(), oldBizSubject.getPinyin()));
			logStr.append(ComLogUtil.getLogTxt(" 主题类型", BizSubject.SUBJECT_TYPE.getCnName(newBizSubject.getSubjectType()), BizSubject.SUBJECT_TYPE.getCnName(oldBizSubject.getSubjectType())));
			logStr.append(ComLogUtil.getLogTxt(" 是否标红", newBizSubject.getRedFlag(), oldBizSubject.getRedFlag()));
			logStr.append(ComLogUtil.getLogTxt(" 是否有效", newBizSubject.getCancelFlag(), oldBizSubject.getCancelFlag()));
			logStr.append(ComLogUtil.getLogTxt(" 排序值", newBizSubject.getSeq().toString(), oldBizSubject.getSeq().toString()));
			logStr.append(ComLogUtil.getLogTxt(" 创建人", newBizSubject.getCreateUser(), oldBizSubject.getCreateUser()));
			logStr.append(ComLogUtil.getLogTxt(" 修改人", newBizSubject.getUpdateUser(), oldBizSubject.getUpdateUser()));
		}
		return logStr.toString();
	}
}