package com.lvmama.vst.back.biz.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizSuggestion;
import com.lvmama.vst.back.biz.po.BizSuggestionDetail;
import com.lvmama.vst.back.biz.po.BizSuggestionGroup;
import com.lvmama.vst.back.biz.service.SuggestionDetailService;
import com.lvmama.vst.back.biz.service.SuggestionGroupService;
import com.lvmama.vst.back.client.biz.service.SuggestionClientService;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 建议内容插件
 */
@Controller
@RequestMapping("/biz/suggestionDetail")
public class SuggestionDetailAction extends BaseActionSupport {

	private static final long serialVersionUID = 1828705023046854768L;
	
	private static final Log LOG = LogFactory.getLog(SuggestionDetailAction.class);

	@Autowired
	private SuggestionClientService suggestionService;
	

	@Autowired
	private SuggestionDetailService suggestionDetailService;
	

	@Autowired
	private SuggestionGroupService suggestionGroupService;

	@RequestMapping(value = "/findDetailList")
	public String findDetailList(Model model, Long suggId, HttpServletRequest req) 
			throws BusinessException {
		// detailMap<key=groupId, value=对应所有的 detail 记录>
		Map<String, Object> detailMap = new HashMap<String, Object>();
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("suggId", suggId);
		params.put("orderByClause", "SEQ");
		List<BizSuggestionGroup> groups = suggestionGroupService.selectByExample(params);
		if (CollectionUtils.isNotEmpty(groups)) {
			for (BizSuggestionGroup group : groups) {
				params.clear();
				params.put("groupId", group.getGroupId());
				List<BizSuggestionDetail> details = suggestionDetailService.selectByExample(params);
				detailMap.put(String.valueOf(group.getGroupId()), details);
			}
		}
		model.addAttribute("detailMap", detailMap);
		model.addAttribute("groupList", groups);
		model.addAttribute("suggId", suggId);
		model.addAttribute("suggName", req.getParameter("suggName"));
		return "/biz/suggestionDetail/findDetailList";
	}

	@RequestMapping(value = "/addOrModifyDetail")
	@ResponseBody
	public Object addOrModifyDetail(HttpServletRequest req) {
		String suggId = req.getParameter("suggId");
		if (StringUtils.isEmpty(suggId))
			return ResultMessage.ID_UNEXITE_RESULT;
		
		String detailValue = req.getParameter("detailValue");
		// 删掉所有 suggId 对应的 detail
		try {
			suggestionDetailService.deleteBySuggId(Long.valueOf(suggId));
		} catch (Exception e) {
			return ResultMessage.DELETE_FAIL_RESULT;
		}
		// 插入页面上保存的所有 detail
		if (StringUtils.isNotEmpty(detailValue)) {
			String[] groups = detailValue.split(";");
			for (String group : groups) {
				String[] details = group.split(",");
				BizSuggestionDetail suggestionDetail = new BizSuggestionDetail();
				suggestionDetail.setGroupId(Long.valueOf(details[0]));
				suggestionDetail.setSuggDesc(details[1]);
				this.addSuggestionDetail(suggestionDetail);
			}
		}
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

	@RequestMapping(value = "/addDetail")
	@ResponseBody
	public Object addSuggestionDetail(BizSuggestionDetail detail) {
		int res = suggestionDetailService.insertSelective(detail);
		if (res==1)
			return ResultMessage.ADD_SUCCESS_RESULT;
		else
			return new ResultMessage(ResultMessage.ERROR, "新增失败");
	}

	@RequestMapping(value = "/modifyDetail")
	@ResponseBody
	public Object modifySuggestionDetail(BizSuggestionDetail detail) throws BusinessException {
		int res = suggestionDetailService.updateByPrimaryKeySelective(detail);
		if (res==1)
			return ResultMessage.UPDATE_SUCCESS_RESULT;
		else
			return new ResultMessage(ResultMessage.ERROR, "修改失败");
	}

	// 效果预览
	@RequestMapping(value = "/previewSuggDetail")
	public String previewSuggDetail(Model model, String suggCode, String reqDataFrom, HttpServletRequest req) 
			throws BusinessException {

		try {
			// 查 sugg
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("suggCode", suggCode);
			List<BizSuggestion> suggestions = suggestionService.selectByExample(params);
			if (CollectionUtils.isEmpty(suggestions)) {
				if(StringUtil.isNotEmptyString(reqDataFrom)){
					return "/prod/packageTour/product/showSelectSuggestionList";
				}else{
					return "/biz/suggestionDetail/previewSuggestionDetail";
				}
			}

			// 查 sugg_group
			BizSuggestion suggestion = suggestions.get(0); // code 肯定唯一
			params.clear();
			params.put("suggId", suggestion.getSuggId());
			params.put("orderByClause", "SEQ");
			List<BizSuggestionGroup> groups = suggestionGroupService.selectByExample(params);

			// detailMap<key=groupId, value=对应所有的 detail 记录>
			Map<String, Object> detailMap = new HashMap<String, Object>();
			if (CollectionUtils.isNotEmpty(groups)) {
				for (BizSuggestionGroup group : groups) {
					params.clear();
					params.put("groupId", group.getGroupId());
					params.put("orderByClause", " DETAIL_ID ");
					List<BizSuggestionDetail> details = suggestionDetailService.selectByExample(params);
					for (BizSuggestionDetail detail : details) {
						detail.setSuggDesc(this.transformDetail(detail.getDetailId(), detail.getSuggDesc()));
					}
					detailMap.put(String.valueOf(group.getGroupId()), details);
				}
			}
			model.addAttribute("detailMap", detailMap);
			model.addAttribute("groupList", groups);
			model.addAttribute("suggCode", suggCode);
		} catch (Exception e) {
			LOG.error(ExceptionFormatUtil.getTrace(e));
		}
		
		if(StringUtil.isNotEmptyString(reqDataFrom)){
			return "/prod/packageTour/product/showSelectSuggestionList";
		}else{
			return "/biz/suggestionDetail/previewSuggestionDetail";
		}
		
	}

	// 把 detail 转成 预览效果的 string
	private String transformDetail(Long detailId, String suggDesc) {
		int m = suggDesc.indexOf("【");
		if (m!=-1) {
			List<Integer> list1 = new ArrayList<Integer>();
			List<Integer> list2 = new ArrayList<Integer>();
			list1.add(m);
			int n = suggDesc.indexOf("】");
			if (n != -1)
				list2.add(n);
			while (m != -1) {
				m = suggDesc.indexOf("【", m + 1);
				if (m!=-1) {
					list1.add(m);
					n = suggDesc.indexOf("】", n + 1);
					if (n != -1)
						list2.add(n);
				}
			}

			StringBuilder result = new StringBuilder(128);
			for (int i=0; i<list1.size(); i++) {
				String str = suggDesc.substring(list1.get(i)+1, list2.get(i));
				StringBuilder sb = new StringBuilder(64);
				sb.append("<input name='txt").append(detailId).append("' id='txt").append(detailId).append("_").append(i).append("' ");
				String[] strs = str.split("-");
				if (strs.length==3) {
					if (strs[2].indexOf("默认值")==0) {
						sb.append("value='").append(strs[2].substring(4, strs[2].indexOf("”"))).append("' ");
					}
				}
				if ("文本".equals(strs[0]))
					sb.append("type='text' ");
				sb.append("size='");
				sb.append(strs[1].substring(0, strs[1].indexOf("字符")));
				sb.append("' tail=tail>");
				StringBuilder res = new StringBuilder();
				if (i==0)
					res.append(suggDesc.substring(0, list1.get(i))).append(sb.toString());
				else if (i==list1.size()-1) {
					res.append(suggDesc.substring(list2.get(i-1)+1, list1.get(i))).append(sb.toString()).append(suggDesc.substring(list2.get(i)+1));
				}
				else
					res.append(suggDesc.substring(list2.get(i-1)+1, list1.get(i))).append(sb.toString());
				result.append(res);
			}
			return result.toString();
		} else { // 原样输出
			return suggDesc;
		}
	}
}
