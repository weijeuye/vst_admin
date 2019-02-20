package com.lvmama.vst.back.biz.web;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.comm.utils.ServletUtil;
import com.lvmama.vst.back.biz.po.BizCitygroup;
import com.lvmama.vst.back.biz.po.BizDistrict;
import com.lvmama.vst.back.biz.service.CitygroupService;
import com.lvmama.vst.back.client.biz.service.CategoryClientService;
import com.lvmama.vst.back.client.biz.service.DistrictClientService;
import com.lvmama.vst.back.pub.service.PushAdapterService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.enumeration.CommEnumSet;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.web.HttpServletLocalThread;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 城市组处理Action
 * 
 */

@Controller
@RequestMapping("/biz/citygroup")
public class CitygroupAction extends BaseActionSupport {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private static Logger log = Logger.getLogger(CitygroupAction.class);

	@Autowired
	private DistrictClientService districtService;
	
	@Autowired
	PushAdapterService pushAdapterService;
	
	@Autowired
	private CitygroupService citygroupService;
	
	@Autowired
	private CategoryClientService categoryService;
	

	/**
	 * 获得城市组列表，查询信息
	 */
	@RequestMapping(value = "/findCitygroupList")
	public String findCitygroupList(Model model, Integer page,Integer pageSize, BizCitygroup cityGroup, 
			HttpServletRequest request, HttpServletResponse response) throws BusinessException {
		Map<String, Object> params = new HashMap<String, Object>();
		// 获取全部BU
		Map<String, String> belongBUMap = new LinkedHashMap<String, String>();
		belongBUMap.put("", "请选择所属BU");
		for (CommEnumSet.BU_NAME item : CommEnumSet.BU_NAME.values()) {
			belongBUMap.put(item.getCode(), item.getCnName());
		}
		model.addAttribute("belongBUMap", belongBUMap);
		
		// 获取产品品类
		Map<String, String> groupCodeMap = new LinkedHashMap<String, String>();
		groupCodeMap.put("", "请选择所属产品品类");
		for (Constant.VST_CATEGORY item : Constant.VST_CATEGORY.values()) {
			if (item.getCategoryId().equals("21") || item.getCategoryId().equals("23")
					||item.getCategoryId().equals("25") || item.getCategoryId().equals("27")) {
				groupCodeMap.put(item.getCategoryId(), item.getCnName());
			}
		}
		model.addAttribute("groupCodeMap", groupCodeMap);
		
		if (cityGroup.getCityGroupName() != null) {//组名称
			params.put("cityGroupName", cityGroup.getCityGroupName());
		}
		if (cityGroup.getBuCode() != null){//所属BU
			params.put("buCode", cityGroup.getBuCode());
		}
		if (cityGroup.getCategoryId() != null){//所属产品品类
			params.put("categoryId", cityGroup.getCategoryId());
		}
		//根据添加获取总记录数
		int totalCount = citygroupService.findCitygroupCount(params);
		
		Integer currentPage = page == null ? 1 : page;
		Integer currentPageSize = pageSize == null ? 10: pageSize;
		Page<BizCitygroup> resultPage = Page.page(totalCount,currentPageSize, currentPage);
		resultPage.buildUrl(request);

		params.put("_start", resultPage.getStartRows());
		params.put("_end", resultPage.getEndRows());
		params.put("_orderby", "bc.CREATE_TIME DESC");//按创建时间从大到小排序
		
		List<BizCitygroup> citygroupList = citygroupService.findCitygroupList(params);
		
		resultPage.setItems(citygroupList);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("cityGroup", cityGroup);
		model.addAttribute("page", resultPage.getPage().toString());
		return "/biz/citygroup/findCitygroupList";
	}
	
	@RequestMapping(value = "/deleteCateCityGroup")
	@ResponseBody
	public Object deleteCateCityGroup(Long cityGroupId,String cityGroupIdList) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<deleteCateCityGroup>");
		}
		try {
			Map<String, Object> params = new HashMap<String, Object>();
			if(cityGroupId != null){
				params.put("cityGroupId", cityGroupId);
			}
			
			if(cityGroupIdList != null){
				List<Integer> ids = new ArrayList<Integer>();
				for(String d : cityGroupIdList.split(",")){
					ids.add(Integer.parseInt(d));
				}
				params.put("cityList", ids);
			}
			citygroupService.deleteCitygroupKey(params);
			return ResultMessage.DELETE_SUCCESS_RESULT;
		} catch (Exception e) {
			e.getStackTrace();
		}
		return null;
	}

	/**
	 * 跳转到城市组修改页面
	 * @param model
	 * @param cityGroupId
	 * @param strCityIds
	 * @param strCitys
	 * @return
	 */
	@RequestMapping(value = "/getCityGroupById")
	public String getCityGroupById(Model model,Long cityGroupId,String strCityIds,String strCitys){
		if (log.isDebugEnabled()) {
			log.debug("start method<getCityGroupById>");
		}
		try {
			// 获取全部BU
			Map<String, String> belongBUMap = new LinkedHashMap<String, String>();
			belongBUMap.put("", "请选择所属BU");
			for (CommEnumSet.BU_NAME item : CommEnumSet.BU_NAME.values()) {
				belongBUMap.put(item.getCode(), item.getCnName());
			}
			model.addAttribute("belongBUMap", belongBUMap);
			
			BizCitygroup cityGroup = citygroupService.findCitygroupById(cityGroupId);
			Map<String, Object> params = new HashMap<String, Object>();
			List<Integer> districtIds = new ArrayList<Integer>();
			Map<String,Object> content = new HashMap<String, Object>();
			Map<String, Object> cityContentMap = cityGroup.getCityContentMap();
			if(!cityContentMap.isEmpty()){
				for(Map.Entry<String, Object> entry:cityContentMap.entrySet()){    
				     districtIds.add(Integer.parseInt(entry.getKey())); 
				     content.put(entry.getKey(), entry.getValue());
				}
			}
			if(!"".equals(strCityIds) && !"".equals(strCitys)){
				int i = 0;
				String[] strCitysA = strCitys.split("、");
				for(String key:strCityIds.split(",")){ 
					districtIds.add(Integer.parseInt(key)); 
					content.put(key, strCitysA[i]);
				    i++;
				}
			}
			if(districtIds != null && districtIds.size() > 0){
				params.put("districtIds", districtIds);
				List<BizDistrict> bizDistrictList = MiscUtils.autoUnboxing(districtService.findDistrictList(params));
				model.addAttribute("bizDistrictList", bizDistrictList);
			}
			model.addAttribute("cityGroup", cityGroup);
			
			addCityGroupCookie(content);
			
		} catch (Exception e) {
			e.getStackTrace();
		}
		return "/biz/citygroup/showUpdateOrInsertCitygroup";
	}
	
	/**
	 * 修改页面删除城市信息
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping("/removeCityGroupByDistrictId.do")
	@ResponseBody
	public Object removeCityGroup(ModelMap model, String districtId) {
		if (StringUtils.isEmpty(districtId)) {
			return new ResultMessage(ResultMessage.ERROR, "删除ID为空");
		}

		try {
			Map<String, Object> map = getCityGroupCookies();
			
			if (map == null) {
				return new ResultMessage(ResultMessage.ERROR, "系统出现错误,map为空");
			}

			if (map.size() == 1) {
				return new ResultMessage(ResultMessage.ERROR, "已选择城市不能全部删除");
			}

			if(map.containsKey(districtId)){
				map.remove(districtId);
				addCityGroupCookie(map);
			}

			return new ResultMessage(ResultMessage.SUCCESS, "删除成功");
		} catch (Exception ex) {
			return new ResultMessage(ResultMessage.ERROR, "系统出现错误");
		}
	}
	
	@SuppressWarnings("deprecation")
	private void addCityGroupCookie(Map<String,Object> content){
		
		String jsonSt = JSONObject.fromObject(content).toString();
		try {
			jsonSt = URLEncoder.encode(jsonSt, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			log.error(ExceptionFormatUtil.getTrace(e));
		}
		ServletUtil.addCookie(HttpServletLocalThread.getResponse(), "CITY_GROUP", jsonSt);
	}
	
	@SuppressWarnings({ "deprecation", "unchecked", "rawtypes" })
	private Map<String, Object> getCityGroupCookies(){
		Map<String,Object> retMap;
		String jsonSt = ServletUtil.getCookieValue(HttpServletLocalThread.getRequest(), "CITY_GROUP");
		try {
			if(jsonSt == null || "".equals(jsonSt)){
				retMap = new HashMap<String, Object>();
			}else{
				jsonSt = URLDecoder.decode(jsonSt, "UTF-8");
				retMap = (Map)JSONObject.toBean(JSONObject.fromObject(jsonSt), Map.class);
			}
		}catch(Exception ex){
			log.error(ExceptionFormatUtil.getTrace(ex));
			return null;
		}
		return retMap;
	}
	

	/**
	 * 更新城市组内容
	 */
	@RequestMapping(value = "/updateCityGroup")
	@ResponseBody
	public Object updateCityGroup(BizCitygroup bizCitygroup,HttpServletRequest request, HttpServletResponse response) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<updateDistrict>");
		}
		try {
			if ((bizCitygroup.getCityGroupName() != null) && !"".equals(bizCitygroup.getCityGroupName())) {
				bizCitygroup.setCityGroupName(bizCitygroup.getCityGroupName());
			}
			if ((bizCitygroup.getCategoryId() != null) && !"".equals(bizCitygroup.getCategoryId())) {
				bizCitygroup.setCategoryId(bizCitygroup.getCategoryId());
			}
			if ((bizCitygroup.getBuCode() != null)&& !"".equals(bizCitygroup.getBuCode())) {
				bizCitygroup.setBuCode(bizCitygroup.getBuCode());
			}
			
			Map<String, Object> map = getCityGroupCookies();
			if((map != null) && !"".equals(map)){
				JSONArray json = JSONArray.fromObject(map); 
				bizCitygroup.setCityContent(json.toString().substring(1, json.toString().length()-1));
			}
			bizCitygroup.setUpdateTime(new Date());
			bizCitygroup.setCreateName(getLoginUser().getUserName());
			bizCitygroup.setCreateId(getLoginUser().getUserId());

			citygroupService.updateByCitygroupKeySelective(bizCitygroup);

			ServletUtil.clearCookie(request, response,"CITY_GROUP");
		} catch (Exception e) {
			log.error("Push info failure ！Push Type:修改城市组信息, ID:"+ bizCitygroup.getCityGroupId() + "." + e.getMessage());
		}

		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}
	
	/**
	 * 选择行政区页面
	 * @param model
	 * @param page
	 * @param district
	 * @param req
	 * @param callBack
	 * @param elementId
	 * @param nameId
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/multiSelectDistrictList")
	public String multiSelectDistrictList(Model model, Long cityGroupId,Integer page, BizDistrict district, HttpServletRequest req,String callBack,String elementId,String nameId) throws BusinessException {
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("districtName", district.getDistrictName());
		parameters.put("districtType", district.getDistrictType());
		parameters.put("cancelFlag", "Y");
		int count = MiscUtils.autoUnboxing(districtService.findDistrictCount(parameters));

		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		parameters.put("_start", pageParam.getStartRows());
		parameters.put("_end", pageParam.getEndRows());
		parameters.put("_orderby", "DISTRICT_ID");
		parameters.put("_order", "DESC");
		List<BizDistrict> list = MiscUtils.autoUnboxing(districtService.findDistrictList(parameters));
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
		
		
		//cityGroupId 为空是添加，反之则修改
		if(cityGroupId != null){
			StringBuffer sb = new StringBuffer();
			List<BizDistrict> bizDistrictList = getBizDistrictList(cityGroupId);
			if(bizDistrictList != null && bizDistrictList.size() > 0){
				for(BizDistrict district2:bizDistrictList){
					sb.append(district2.getDistrictName()).append("、");
				}
				model.addAttribute("str", sb.toString().substring(0, sb.toString().length()-1));
			}
			model.addAttribute("bizDistrictList", bizDistrictList);
			model.addAttribute("cityGroupId", cityGroupId);
		}
		return "/biz/citygroup/multiSelectDistrictList";
	}
	

	private List<BizDistrict> getBizDistrictList(Long cityGroupId){
		BizCitygroup cityGroup = citygroupService.findCitygroupById(cityGroupId);
		Map<String, Object> params = new HashMap<String, Object>();
		List<Integer> districtIds = new ArrayList<Integer>();
		List<BizDistrict> bizDistrictList = new ArrayList<BizDistrict>();
		Map<String, Object> cityContentMap = cityGroup.getCityContentMap();
		if(!cityContentMap.isEmpty()){
			for(Map.Entry<String, Object> entry:cityContentMap.entrySet()){    
			     districtIds.add(Integer.parseInt(entry.getKey()));
			}
			params.put("districtIds", districtIds);
			
			bizDistrictList = MiscUtils.autoUnboxing(districtService.findDistrictList(params));
			
		}
		return bizDistrictList;
	}
	

	/**
	 * 跳转到添加城市组信息页面
	 * @param model
	 * @param strCityIds
	 * @param strCitys
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/addCityGroup")
	public String addCityGroup(Model model,String strCityIds,String strCitys,BizCitygroup cityGroup,HttpServletRequest request){
		// 获取全部BU
		Map<String, String> belongBUMap = new LinkedHashMap<String, String>();
		belongBUMap.put("", "请选择所属BU");
		for (CommEnumSet.BU_NAME item : CommEnumSet.BU_NAME.values()) {
			belongBUMap.put(item.getCode(), item.getCnName());
		}
		model.addAttribute("belongBUMap", belongBUMap);
		
		Map<String,Object> content = new HashMap<String, Object>();
		Map<String, Object> params = new HashMap<String, Object>();
		List<BizDistrict> bizDistrictList = new ArrayList<BizDistrict>();
		if(!"".equals(strCityIds) && !"".equals(strCitys)){
			List<Integer> districtIds = new ArrayList<Integer>();
			int i = 0;
			String[] strCitysA = strCitys.split("、");
			for(String key:strCityIds.split(",")){ 
				districtIds.add(Integer.parseInt(key)); 
				content.put(key, strCitysA[i]);
			    i++;
			}
			addCityGroupCookie(content);
			params.put("districtIds", districtIds);
			
			bizDistrictList = MiscUtils.autoUnboxing(districtService.findDistrictList(params));
		}
		model.addAttribute("bizDistrictList", bizDistrictList);
		model.addAttribute("cityGroup", cityGroup);
		return "/biz/citygroup/showUpdateOrInsertCitygroup";
	}
	
	
	/**
	 * 添加城市组内容
	 */
	@RequestMapping(value = "/insertCityGroup")
	@ResponseBody
	public Object insertCityGroup(BizCitygroup bizCitygroup,HttpServletRequest request, HttpServletResponse response) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<insertCityGroup>");
		}
		try {
			if ((bizCitygroup.getCityGroupName() != null) && !"".equals(bizCitygroup.getCityGroupName())) {
				bizCitygroup.setCityGroupName(bizCitygroup.getCityGroupName());
			}
			if ((bizCitygroup.getCategoryId() != null) && !"".equals(bizCitygroup.getCategoryId())) {
				bizCitygroup.setCategoryId(bizCitygroup.getCategoryId());
			}
			if ((bizCitygroup.getBuCode() != null)&& !"".equals(bizCitygroup.getBuCode())) {
				bizCitygroup.setBuCode(bizCitygroup.getBuCode());
			}
			
			Map<String, Object> map = getCityGroupCookies();
			if(map!=null){
				JSONArray json = JSONArray.fromObject(map); 
				bizCitygroup.setCityContent(json.toString().substring(1, json.toString().length()-1));
			}
			bizCitygroup.setCreateTime(new Date());
			bizCitygroup.setCreateName(getLoginUser().getUserName());
			bizCitygroup.setCreateId(getLoginUser().getUserId());

			citygroupService.addCitygroup(bizCitygroup);
			
			ServletUtil.clearCookie(request, response,"CITY_GROUP");
		} catch (Exception e) {
			log.error("Push info failure ！Push Type:添加城市组信息, ID:"+ bizCitygroup.getCityGroupId() + "." + e.getMessage());
		}

		return ResultMessage.ADD_SUCCESS_RESULT;
	}
	
	
}