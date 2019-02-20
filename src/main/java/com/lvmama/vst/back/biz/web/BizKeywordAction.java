/**
 * 
 */
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

import com.lvmama.vst.back.biz.po.BizKeyword;
import com.lvmama.vst.back.biz.service.BizKeywordService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * @author dongningbo
 *
 */
@Controller
@RequestMapping("/biz/keyword")
public class BizKeywordAction extends BaseActionSupport {

	@Autowired
	private BizKeywordService bizKeywordService;
	
	
	
	@Autowired
	private ComLogClientService comLogService;
	

	@RequestMapping(value = "/findKeywordList")
	public String findKeywordList(Model model, Integer page, HttpServletRequest req) throws BusinessException {
		Map<String, Object> parameters = new HashMap<String, Object>();
		String keywordName = req.getParameter("keywordName");
		String districtName = req.getParameter("districtName");
		String cancelFlag = req.getParameter("cancelFlag");
		parameters.put("keywordName", keywordName);
		parameters.put("districtName", districtName);
		parameters.put("cancelFlag", cancelFlag);
		
		int count = bizKeywordService.findKeywordCount(parameters);

		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		parameters.put("_start", pageParam.getStartRows());
		parameters.put("_end", pageParam.getEndRows());
		parameters.put("_orderby", "KEYWORD_ID");
		parameters.put("_order", "DESC");
		List<BizKeyword> list = bizKeywordService.findKeywordList(parameters);
		pageParam.setItems(list);

		model.addAttribute("pageParam", pageParam);
		model.addAttribute("keywordName", keywordName);
		model.addAttribute("districtName", districtName);
		model.addAttribute("cancelFlag", cancelFlag);
		model.addAttribute("page", pageParam.getPage().toString());

		return "/biz/keyword/findKeywordList";
	}

	@RequestMapping(value = "/showAddKeyword")
	public String showAddKeyword(Model model, Long keywordId) throws BusinessException {
		BizKeyword bizKeyword =MiscUtils.autoUnboxing(bizKeywordService.findKeywordById(keywordId));

		model.addAttribute("bizKeyword", bizKeyword);
		return "/biz/keyword/showAddKeyword";
	}

	@RequestMapping(value = "/updateKeyword")
	@ResponseBody
	public Object updateKeyword(BizKeyword bizKeyword) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<updateKeyword>");
		}
		
		BizKeyword oldKeyword = bizKeywordService.findKeywordById(bizKeyword.getKeywordId());

		int flag = bizKeywordService.updateKeyword(bizKeyword);
		//添加操作日志
		try {
			String logType = null, log = "";
			if (flag == 1) {
				logType = COM_LOG_LOG_TYPE.BIZ_KEYWORD_EDIT_SUCCESS.getCnName();
			} else {
				logType = COM_LOG_LOG_TYPE.BIZ_KEYWORD_EDIT_FAIL.getCnName();
			}
			log = getChangeLog(bizKeyword, oldKeyword);
			comLogService.insert(COM_LOG_OBJECT_TYPE.BIZ_KEYWORD_EDIT,
					bizKeyword.getKeywordId(), bizKeyword.getKeywordId(),
					this.getLoginUserId(), 
					log, 
					logType, 
					"修改【"+ bizKeyword.getKeywordId() + "】关键词", null);
		} catch (Exception e) {
			log.error(e.getMessage());
		}
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}
	/**
	 * 编辑关键词时 比较新旧信息区别
	 */
	private String getChangeLog(BizKeyword newKey, BizKeyword oldKey) {
		StringBuilder log = new StringBuilder();

		if (newKey != null) {
			// 基本信息
			log.append(ComLogUtil.getLogTxt("关键词", newKey.getKeywordName(),
					oldKey.getKeywordName()));
			log.append(ComLogUtil.getLogTxt("是否有效", newKey.getCancelFlag(),
					oldKey.getCancelFlag()));
			log.append(ComLogUtil.getLogTxt("关联行政区", newKey.getDistrictName(),
					oldKey.getDistrictName()));

		}
		return log.toString();
	}

	@RequestMapping(value = "/addKeyword")
	@ResponseBody
	public Object addKeyword(BizKeyword bizKeyword) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<addKeyword>");
		}

		int flag = bizKeywordService.addKeyword(bizKeyword);
		//添加操作日志
		try {
			String logType = null;
			if (flag == 1) {
				logType = COM_LOG_LOG_TYPE.BIZ_KEYWORD_EDIT_SUCCESS.getCnName();
			} else {
				logType = COM_LOG_LOG_TYPE.BIZ_KEYWORD_EDIT_FAIL.getCnName();
			}
			comLogService.insert(COM_LOG_OBJECT_TYPE.BIZ_KEYWORD_EDIT,
					bizKeyword.getKeywordId(), bizKeyword.getKeywordId(),
					this.getLoginUserId(), 
					"新增【" + bizKeyword.getKeywordName()+ "】关键词，编号：【" + bizKeyword.getKeywordId() + "】", 
					logType, 
					"新增【" + bizKeyword.getKeywordName()+ "】关键词，编号：【" + bizKeyword.getKeywordId() + "】", null);
		} catch (Exception e) {
			log.error(e.getMessage());
		}
		return ResultMessage.ADD_SUCCESS_RESULT;
	}

	@RequestMapping(value = "/editFlag")
	@ResponseBody
	public Object editFlag(Long keywordId, String cancelFlag) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<editFlag>");
		}
		int flag = bizKeywordService.editFlag(keywordId, cancelFlag);
		//添加操作日志
		try {
			String log = "";
			if("Y".equalsIgnoreCase(cancelFlag)){
				log="有效";
			}else if("N".equalsIgnoreCase(cancelFlag)){
				log="无效";
			}
			String logType = null;
			if (flag == 1) {
				logType = COM_LOG_LOG_TYPE.BIZ_KEYWORD_EDIT_SUCCESS.getCnName();
			} else {
				logType = COM_LOG_LOG_TYPE.BIZ_KEYWORD_EDIT_FAIL.getCnName();
			}
			comLogService.insert(COM_LOG_OBJECT_TYPE.BIZ_KEYWORD_EDIT,
					keywordId, keywordId,
					this.getLoginUserId(), 
					"修改关键词状态为["+log+"]", 
					logType, 
					"修改关键词状态",null);
		} catch (Exception e) {
			log.error(e.getMessage());
		}
		return ResultMessage.SET_SUCCESS_RESULT;
	}

}
