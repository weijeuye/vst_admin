package com.lvmama.vst.back.biz.web;

import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizDistrict;
import com.lvmama.vst.back.biz.po.BizDistrict.DISTRICT_TYPE;
import com.lvmama.vst.back.client.biz.service.DistrictClientService;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.pub.po.ComPush.OPERATE_TYPE;
import com.lvmama.vst.back.pub.service.PushAdapterServiceRemote;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.ChineseToPinYin;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.utils.json.JSONOutput;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 行政区域处理Action
 * 
 * @author mayonghua
 */

@Controller
@RequestMapping("/biz/district")
public class DistrictAction extends BaseActionSupport {
	
	private static Logger log = Logger.getLogger(DistrictAction.class);

	@Autowired
	private DistrictClientService districtService;
	@Autowired
	private PushAdapterServiceRemote pushAdapterService;

	/**
	 * 获得行政区列表
	 */
	@RequestMapping(value = "/findDistrictList")
	public String findDistrictList(Model model, Integer page, BizDistrict district, HttpServletRequest req) throws BusinessException {
		
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("districtName", district.getDistrictName());
		parameters.put("districtType", district.getDistrictType());
		int count = MiscUtils.autoUnboxing( districtService.findDistrictCount(parameters) );

		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		parameters.put("_start", pageParam.getStartRows());
		parameters.put("_end", pageParam.getEndRows());
		parameters.put("_orderby", "DISTRICT_ID");
		parameters.put("_order", "DESC");
		List<BizDistrict> list = MiscUtils.autoUnboxing( districtService.findDistrictList(parameters) );
		districtService.setParentsDistrictNameInfo(list, parameters);
		pageParam.setItems(list);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("districtName", district.getDistrictName());
		model.addAttribute("districtType", district.getDistrictType());
		model.addAttribute("districtTypeList", BizDistrict.DISTRICT_TYPE.values());
		model.addAttribute("page", pageParam.getPage().toString());

		return "/biz/district/findDistrictList";
	}

	/**
	 * 查看行政区
	 * 
	 * @return
	 */
	public String showDistrict() {
		return "";
	}

	/**
	 * 跳转到修改页面
	 */
	@RequestMapping(value = "/showUpdateDistrict")
	public String showUpdateDistrict(Model model, Long districtId) throws BusinessException {
		BizDistrict district = MiscUtils.autoUnboxing( districtService.findDistrictById(districtId) );
		model.addAttribute("district", district);
		model.addAttribute("districtTypeList", BizDistrict.DISTRICT_TYPE.values());
		return "/biz/district/showUpdateDistrict";
	}

	/**
	 * 跳转到添加页面
	 */
	@RequestMapping(value = "/showAddDistrict")
	public String showAddDistrict(Model model) {
		model.addAttribute("districtTypeList", BizDistrict.DISTRICT_TYPE.values());
		return "/biz/district/showAddDistrict";
	}

	/**
	 * 跳转到添加下级区域页面
	 */
	@RequestMapping(value = "/showAddChildDistrict")
	public String showAddChildDistrict(Model model, Long districtId) throws BusinessException {
		BizDistrict district = MiscUtils.autoUnboxing( districtService.findDistrictById(districtId) );
		model.addAttribute("district", district);
		model.addAttribute("districtTypeList", BizDistrict.DISTRICT_TYPE.values());
		return "/biz/district/showAddChildDistrict";
	}

	/**
	 * 添加行政区
	 * 
	 * @return 添加结果JSON
	 */
	@RequestMapping(value = "/addDistrict")
	@ResponseBody
	public Object addDistrict(BizDistrict bizDistrict) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<addDistrict>");
		}

		if ((bizDistrict.getPinyin() == null) || "".equals(bizDistrict.getPinyin())) {
			bizDistrict.setPinyin(ChineseToPinYin.getPingYin(bizDistrict.getDistrictName()));
		}
		if ((bizDistrict.getShortPinyin() == null) || "".equals(bizDistrict.getShortPinyin())) {
			bizDistrict.setShortPinyin(ChineseToPinYin.getPinYinHeadChar(bizDistrict.getDistrictName()));
		}
		bizDistrict.setCancelFlag("N");
		fillUrlPinYin(bizDistrict);
		districtService.addDistrict(bizDistrict);
		
		//添加推送信息
		try {
			pushAdapterService.push(bizDistrict.getDistrictId(), ComPush.OBJECT_TYPE.DISTRICT, ComPush.PUSH_CONTENT.BIZ_DISTRICT,ComPush.OPERATE_TYPE.ADD, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
		} catch (Exception e) {
			log.error("Push info failure ！Push Type:"+ComPush.OBJECT_TYPE.DISTRICT.name()+" ID:"+bizDistrict.getDistrictId()+"."+e.getMessage());
		}
		
		return ResultMessage.ADD_SUCCESS_RESULT;
	}

	/**
	 * 更新行政区内容
	 */
	@RequestMapping(value = "/updateDistrict")
	@ResponseBody
	public Object updateDistrict(BizDistrict bizDistrict) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<updateDistrict>");
		}
		if ((bizDistrict.getPinyin() == null) || "".equals(bizDistrict.getPinyin())) {
			bizDistrict.setPinyin(ChineseToPinYin.getPingYin(bizDistrict.getDistrictName()));
		}
		if ((bizDistrict.getShortPinyin() == null) || "".equals(bizDistrict.getShortPinyin())) {
			bizDistrict.setShortPinyin(ChineseToPinYin.getPinYinHeadChar(bizDistrict.getDistrictName()));
		}
		fillUrlPinYin(bizDistrict);
		districtService.updateDistrict(bizDistrict);
		

		//添加推送信息
		try {
			pushAdapterService.push(bizDistrict.getDistrictId(), ComPush.OBJECT_TYPE.DISTRICT, ComPush.PUSH_CONTENT.BIZ_DISTRICT,ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
		} catch (Exception e) {
			log.error("Push info failure ！Push Type:"+ComPush.OBJECT_TYPE.DISTRICT.name()+" ID:"+bizDistrict.getDistrictId()+"."+e.getMessage());
		}
		
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}
	
	//填充UrlPinYin数据到行政区对象
	private void fillUrlPinYin(BizDistrict bizDistrict){
		if(StringUtil.isEmptyString(bizDistrict.getUrlPinyin())) {
			String urlPinyin = "";
			if(StringUtil.isNotEmptyString(bizDistrict.getPinyin())) {
				urlPinyin = bizDistrict.getPinyin();
			}else if(StringUtil.isNotEmptyString(bizDistrict.getDistrictName())){
				urlPinyin = ChineseToPinYin.getPingYin(bizDistrict.getDistrictName());
			}
			Map<String, Object> params = new HashMap<String, Object>();
			
			if(StringUtil.isNotEmptyString(urlPinyin)){
				params.put("urlPinyin", urlPinyin);
				int num = MiscUtils.autoUnboxing( districtService.findDistrictCount(params) );
				//$pinyin, $pinyin1, $pinyin2...序号增长
				if(num > 0){
					bizDistrict.setUrlPinyin(urlPinyin + (num + 1));
				}else{
					bizDistrict.setUrlPinyin(urlPinyin);
				}
			}
		}
		// 补充 CityPinyin
		if (StringUtil.isEmptyString(bizDistrict.getCityPinyin()) && StringUtil.isNotEmptyString(bizDistrict.getCityName())) {
			bizDistrict.setCityPinyin(ChineseToPinYin.getPingYin(bizDistrict.getCityName()));
		}
		// 补充 ProvincePinyin
		if (StringUtil.isEmptyString(bizDistrict.getProvincePinyin()) && StringUtil.isNotEmptyString(bizDistrict.getProvinceName())) {
			bizDistrict.setProvincePinyin(ChineseToPinYin.getPingYin(bizDistrict.getProvinceName()));
		}
	}
	
	/**
	 * 为每个行政区生成拼音
	 */
	@RequestMapping(value = "/updateDistrictPinyin")
	@ResponseBody
	public Object updateDistrictPinyin() throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<updateDistrictPinyin>");
		}

		List<BizDistrict> list = MiscUtils.autoUnboxing( districtService.findDistrictListForReport(new HashMap<String, Object>()) );
		for (BizDistrict bizDistrict : list) {
			String pinyin = ChineseToPinYin.getPingYin(bizDistrict.getDistrictName());
			bizDistrict.setPinyin(pinyin);
			districtService.updateDistrict(bizDistrict);
			
			//添加推送信息
			try {
				pushAdapterService.push(bizDistrict.getDistrictId(), ComPush.OBJECT_TYPE.DISTRICT, ComPush.PUSH_CONTENT.BIZ_DISTRICT,ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
			} catch (Exception e) {
				log.error("Push info failure ！Push Type:"+ComPush.OBJECT_TYPE.DISTRICT.name()+" ID:"+bizDistrict.getDistrictId()+"."+e.getMessage());
			}
		}
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

	/**
	 * 设置行政区的有效性
	 */
	@RequestMapping(value = "/cancelDistrict")
	@ResponseBody
	public Object cancelDistrict(BizDistrict bizDistrict) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<cancelDistrict>");
		}

		OPERATE_TYPE delType = ComPush.OPERATE_TYPE.INVALID;
		if ((bizDistrict != null) && "Y".equals(bizDistrict.getCancelFlag())) {
			delType = ComPush.OPERATE_TYPE.VALID;
			bizDistrict.setCancelFlag("Y");
		} else if ((bizDistrict != null) && "N".equals(bizDistrict.getCancelFlag())) {
			bizDistrict.setCancelFlag("N");
		} else {
			return new ResultMessage("error", "设置失败,无效参数");
		}

		districtService.updateCancelFlag(bizDistrict);
		
		//添加推送信息
		try {
			pushAdapterService.push(bizDistrict.getDistrictId(), ComPush.OBJECT_TYPE.DISTRICT, ComPush.PUSH_CONTENT.BIZ_DISTRICT,delType, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
		} catch (Exception e) {
			log.error("Push info failure ！Push Type:"+ComPush.OBJECT_TYPE.DISTRICT.name()+" ID:"+bizDistrict.getDistrictId()+"."+e.getMessage());
		}
		
		return ResultMessage.SET_SUCCESS_RESULT;
	}

	/**
	 * 
	 * @param model
	 * @param page
	 * @param district
	 * @param req
	 * @param callBack
	 * @param elementId   要设置id的元素
	 * @param nameId  要设置name的元素
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/selectDistrictList")
	public String selectDistrictList(Model model, Integer page, BizDistrict district, HttpServletRequest req,String callBack,String elementId,String nameId, String districtTypeForKeyword) throws BusinessException {
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("districtName", district.getDistrictName());
		parameters.put("districtType", district.getDistrictType());
		parameters.put("cancelFlag", "Y");
		if(StringUtil.isNotEmptyString(district.getDistrictTypeForVisa()) 
				&& StringUtil.isNotEmptyString(district.getDistrictType())){
			if("COUNTRY".equals(district.getDistrictType())){
				parameters.put("foreighFlag", "Y");
			}else if("PROVINCE_SA".equals(district.getDistrictType())){
				parameters.put("foreighFlag", "N");
			}else if("PROVINCE".equals(district.getDistrictType())){
				parameters.put("foreighFlag", "N");
				if(StringUtil.isEmptyString(district.getDistrictName())){
					parameters.put("districtName", "台湾");
				}
			}else{
				;
			}
		}
		
		//董宁波 2016年5月24日 16:29:40 关键词
		if (StringUtil.isNotEmptyString(districtTypeForKeyword)) {
			parameters.put("foreighFlag", "N");
			if (StringUtil.isEmptyString(district.getDistrictType())) {
				parameters.put("districtType", BizDistrict.DISTRICT_TYPE.PROVINCE.name());
			} 
			model.addAttribute("districtTypeForKeyword", districtTypeForKeyword);
		}
		//end
		int count = MiscUtils.autoUnboxing( districtService.findDistrictCount(parameters) );

		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		parameters.put("_start", pageParam.getStartRows());
		parameters.put("_end", pageParam.getEndRows());
		parameters.put("_orderby", "DISTRICT_ID");
		parameters.put("_order", "DESC");
		List<BizDistrict> list = MiscUtils.autoUnboxing( districtService.findDistrictList(parameters) );
		districtService.setParentsDistrictNameInfo(list, parameters);
		pageParam.setItems(list);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("districtName", district.getDistrictName());
		model.addAttribute("callBack", callBack);
		model.addAttribute("elementId", elementId);
		model.addAttribute("nameId", nameId);
		model.addAttribute("parentDistrict", district.getParentDistrict());
		model.addAttribute("districtType", district.getDistrictType());
		model.addAttribute("districtTypeList", BizDistrict.DISTRICT_TYPE.values());
		model.addAttribute("page", pageParam.getPage().toString());
		if(null != district.getDistrictTypeForVisa()){
			model.addAttribute("districtTypeForVisa", district.getDistrictTypeForVisa());//签证的行政区划，区域类型只显示"国家"
		}

		return "/biz/district/selectDistrictList";
	}

	@RequestMapping(value = "/multiSelectDistrictList")
	public String multiSelectDistrictList(Model model, Integer page, BizDistrict district, HttpServletRequest req,String callBack,String elementId,String nameId) throws BusinessException {
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("districtName", district.getDistrictName());
		parameters.put("districtType", district.getDistrictType());
		parameters.put("cancelFlag", "Y");
		if(StringUtil.isNotEmptyString(district.getDistrictTypeForVisa())){
			Set<String> districtTypeSet = new HashSet<String>(Arrays.asList("PROVINCE", "PROVINCE_DCG", "PROVINCE_AN", "PROVINCE_SA"));
			if(StringUtil.isNotEmptyString(district.getDistrictType())){
				if(districtTypeSet.contains(district.getDistrictType())){
					parameters.put("foreighFlag", "N");
				}
			}else{
				parameters.put("foreighFlag", "N");
				parameters.put("districtTypes", "'" + StringUtils.join(districtTypeSet.toArray(), "', '") + "'");
			}
		}		
		int count = MiscUtils.autoUnboxing( districtService.findDistrictCount(parameters) );
		int pagenum = page == null ? 1 : page;
		Page pageParam = null;
		if(StringUtil.isNotEmptyString(district.getDistrictTypeForVisa())){
			pageParam = Page.page(count, 40, pagenum);
		}else{
			pageParam = Page.page(count, 10, pagenum);
		}
		pageParam.buildUrl(req);
		parameters.put("_start", pageParam.getStartRows());
		parameters.put("_end", pageParam.getEndRows());
		parameters.put("_orderby", "DISTRICT_ID");
		parameters.put("_order", "DESC");
		List<BizDistrict> list = MiscUtils.autoUnboxing( districtService.findDistrictList(parameters) );
		districtService.setParentsDistrictNameInfo(list, parameters);
		pageParam.setItems(list);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("districtName", district.getDistrictName());
		model.addAttribute("callBack", callBack);
		model.addAttribute("elementId", elementId);
		model.addAttribute("nameId", nameId);
		model.addAttribute("parentDistrict", district.getParentDistrict());
		model.addAttribute("districtType", district.getDistrictType());
		model.addAttribute("districtTypeList", BizDistrict.DISTRICT_TYPE.values());
		model.addAttribute("district", district);
		model.addAttribute("page", pageParam.getPage().toString());
		return "/biz/district/multiSelectDistrictList";
	}

	/**
	 * 获得行政区列表
	 */
	@RequestMapping(value = "/searchDistrictList")
	@ResponseBody
	public Object searchDistrictList(String search, HttpServletResponse resp) throws BusinessException {
		
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("districtName", search);
		parameters.put("districtType", DISTRICT_TYPE.COUNTRY.getCode());
		parameters.put("cancelFlag", "Y");
		List<BizDistrict> list = MiscUtils.autoUnboxing( districtService.findDistrictList(parameters) );

		JSONArray array = new JSONArray();
		if(list != null && list.size() > 0){
			for(BizDistrict bizDistrict:list){
				JSONObject obj=new JSONObject();
				obj.put("id", bizDistrict.getDistrictId());
				obj.put("text", bizDistrict.getDistrictName());
				
				array.add(obj);
			}
		}
		return array;
	}
	
	/**
	 * 搜索用户列表
	 */
	@RequestMapping(value = "/seachDistrict")
	@ResponseBody
	public void seachDistrict(String search, HttpServletResponse resp){
		if (log.isDebugEnabled()) {
			log.debug("start method<seachDistrict>");
		}
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("districtName", search);
		List<BizDistrict> list = MiscUtils.autoUnboxing( districtService.findDistrictList(parameters) );
		JSONArray array = new JSONArray();
		if (list != null && list.size() > 0) {
			for (BizDistrict district : list) {
				JSONObject obj = new JSONObject();
				obj.put("id", district.getDistrictId());
				obj.put("text", district.getDistrictName());
				array.add(obj);
			}
		}
		JSONOutput.writeJSON(resp, array);
	}
	
}