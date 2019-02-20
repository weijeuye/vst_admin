package com.lvmama.vst.back.pub.web;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.comm.utils.ChineseToPinYin;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.web.BaseActionSupport;

/**
 * Web 工具
 * 
 * @author ranlongfei
 */
@Controller
@RequestMapping("/pub/utils")
public class WebUtilsCommonAction extends BaseActionSupport {

	@RequestMapping(value = "/getPinYin")
	@ResponseBody
	public Object getPinYin(Model model, String param,String type) {
		if(StringUtils.isNotEmpty(param) && StringUtil.isEmptyString(type)) {
			return ChineseToPinYin.getPingYin(param);
		}else if(StringUtils.isNotEmpty(param) && StringUtil.isNotEmptyString(type)){
			return ChineseToPinYin.getPinYinHeadChar(param);
		}
		return "";
	}
}
