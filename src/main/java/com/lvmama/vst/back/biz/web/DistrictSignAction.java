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
import com.lvmama.vst.back.biz.po.BizDistrict;
import com.lvmama.vst.back.biz.po.BizDistrictSign;
import com.lvmama.vst.back.biz.po.BizTrafficLine;
import com.lvmama.vst.back.biz.service.BizDictQueryService;
import com.lvmama.vst.back.client.biz.service.DistrictClientService;
import com.lvmama.vst.back.client.biz.service.DistrictSignClientService;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.pub.po.ComPush.OPERATE_TYPE;
import com.lvmama.vst.back.pub.service.PushAdapterService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.ChineseToPinYin;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;

/**
 * 地理位置处理Action
 * 
 * @author liuhuan
 * @date 2013-10-12
 */
@Controller
@RequestMapping("/biz/districtSign")
public class DistrictSignAction extends BaseActionSupport {

	/**
	 * 序列
	 */
	private static final long serialVersionUID = 3132700074027532228L;

	@Autowired
	private DistrictSignClientService districtSignService;
	
	@Autowired
	private DistrictClientService districtService;
	
	@Autowired
	private BizDictQueryService bizDictQueryService;
	@Autowired
	PushAdapterService pushAdapterService;
	
	private final long DICT_DEF_ID = 300;
	
	/**
	 * 获得地理位置列表
	 */
	@RequestMapping(value = "/findDistrictSignList")
	public String findDistrictSignList(Model model, Integer page, BizDistrictSign districtSign, HttpServletRequest req,
			String districtName, String longitudeNullFlag, String flag) {
	
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("signId", districtSign.getSignId());
		parameters.put("signName", districtSign.getSignName());
		parameters.put("signType", districtSign.getSignType());
		parameters.put("districtName", districtName);
		parameters.put("cancelFlag", districtSign.getCancelFlag());
		parameters.put("longitudeNullFlag", longitudeNullFlag);
		int count = MiscUtils.autoUnboxing( districtSignService.findDistrictSignCount(parameters) );

		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		parameters.put("_start", pageParam.getStartRows());
		parameters.put("_end", pageParam.getEndRows());
		parameters.put("_orderby", " bds.SIGN_ID");
		parameters.put("_order", "DESC");
		List<BizDistrictSign> list = MiscUtils.autoUnboxing( districtSignService.findDistrictSignList(parameters) );
		BizDict signTypeBizDict = null;
		for(BizDistrictSign bizDistrictSign : list){
			signTypeBizDict = bizDictQueryService.selectByPrimaryKey(Long.parseLong(bizDistrictSign.getSignType()));
			bizDistrictSign.setSignTypeBizDict(signTypeBizDict);
		}
		pageParam.setItems(list);
		List<BizDict> bizDictList = bizDictQueryService.findDictListByDefId(DICT_DEF_ID);
		
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("districtName", districtName);
		model.addAttribute("signId", districtSign.getSignId());
		model.addAttribute("signName", districtSign.getSignName());
		model.addAttribute("signType", districtSign.getSignType());
		model.addAttribute("cancelFlag", districtSign.getCancelFlag());
		model.addAttribute("longitudeNullFlag", longitudeNullFlag);
		//model.addAttribute("signTypeList", BizDistrictSign.DISTRICT_SIGN_TYPE.values());
		model.addAttribute("bizDictList", bizDictList);
		model.addAttribute("page", pageParam.getPage().toString());
		model.addAttribute("flag", flag);
		if(!"PROP_ATTR".equals(flag)){
			return "/biz/districtSign/findDistrictSignList";
		}
		return "/biz/districtSign/selectDistrictSignList";
	}
 
	/**
	 * 跳转到修改页面
	 */
	@RequestMapping(value = "/showUpdateDistrictSign")
	public String showUpdateDistrict(Model model, Long signId) {
		BizDistrictSign districtSign = MiscUtils.autoUnboxing( districtSignService.findDistrictSignById(signId) );
		BizDistrict district = MiscUtils.autoUnboxing( districtService.findDistrictById(districtSign.getDistrictId()) );
		model.addAttribute("districtSign", districtSign);
		model.addAttribute("district",district );
		//model.addAttribute("districtSignTypeList", BizDistrictSign.DISTRICT_SIGN_TYPE.values());
		
		List<BizDict> bizDictList = bizDictQueryService.findDictListByDefId(DICT_DEF_ID);
		model.addAttribute("bizDictList", bizDictList);
		StringBuffer lineNames = new StringBuffer();
		if(null != districtSign.getTrafficLines() && districtSign.getTrafficLines().size()>0){
			for (BizTrafficLine bizTrafficLine : districtSign.getTrafficLines()) {
				lineNames.append(bizTrafficLine.getTrafficName());
				lineNames.append(",");
			}
			if(lineNames.length()>0){
				lineNames.replace(0, lineNames.length(), lineNames.substring(0, lineNames.lastIndexOf(",")));
	        }
			model.addAttribute("lineNames", lineNames);
		}
		return "/biz/districtSign/showUpdateDistrictSign";
	}

	/**
	 * 跳转到添加页面
	 */
	@RequestMapping(value = "/showAddDistrictSign")
	public String showAddDistrictSign(Model model) {
		List<BizDict> bizDictList = bizDictQueryService.findDictListByDefId(DICT_DEF_ID);
		model.addAttribute("bizDictList", bizDictList);
		
		//model.addAttribute("districtSignTypeList", BizDistrictSign.DISTRICT_SIGN_TYPE.values());
		return "/biz/districtSign/showAddDistrictSign";
	}

	/**
	 * 添加地理位置
	 * 
	 * @return 添加结果JSON
	 */
	@RequestMapping(value = "/addDistrictSign")
	@ResponseBody
	public Object addDistrictSign(BizDistrictSign bizDistrictSign) {
		if (log.isDebugEnabled()) {
			log.debug("start method<addDistrictSign>");
		}
		bizDistrictSign.setCancelFlag("N");
		String quanping = bizDistrictSign.getPinyin();
		String jianping = bizDistrictSign.getShortPinyin();
		if(null == bizDistrictSign.getPinyin() || "".equals(bizDistrictSign.getPinyin().trim()))
		{
			quanping = ChineseToPinYin.getPingYin(bizDistrictSign.getSignName());
			
		}
		if(null == bizDistrictSign.getShortPinyin() || "".equals(bizDistrictSign.getShortPinyin()))
		{
			jianping = ChineseToPinYin.getPinYinHeadChar(bizDistrictSign.getSignName());
		}
		bizDistrictSign.setPinyin(quanping);
		bizDistrictSign.setShortPinyin(jianping);
		
		districtSignService.addDistrictSign(bizDistrictSign);
		//添加推送信息
		try {
				pushAdapterService.push(bizDistrictSign.getSignId(), ComPush.OBJECT_TYPE.DISTRICTSIGN, ComPush.PUSH_CONTENT.BIZ_DISTRICT_SIGN,ComPush.OPERATE_TYPE.ADD, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
		} catch (Exception e) {
				log.error("Push info failure ！Push Type:"+ComPush.OBJECT_TYPE.DISTRICTSIGN.name()+" ID:"+bizDistrictSign.getSignId()+"."+e.getMessage());
		}
		return ResultMessage.ADD_SUCCESS_RESULT;
	}

	/**
	 * 更新地理位置
	 */
	@RequestMapping(value = "/updateDistrictSign")
	@ResponseBody
	public Object updateDistrictSign(BizDistrictSign bizDistrictSign) {
		if (log.isDebugEnabled()) {
			log.debug("start method<updateDistrictSign>");
		}

		districtSignService.updateDistrictSign(bizDistrictSign);
		//添加推送信息
		try {
			pushAdapterService.push(bizDistrictSign.getSignId(),
					ComPush.OBJECT_TYPE.DISTRICTSIGN, ComPush.PUSH_CONTENT.BIZ_DISTRICT_SIGN,ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
		} catch (Exception e) {
			log.error("Push info failure ！Push Type:"
					+ ComPush.OBJECT_TYPE.DISTRICTSIGN.name() + " ID:"
					+ bizDistrictSign.getSignId() + "." + e.getMessage());
		}
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

	/**
	 * 设置地理位置有效性
	 */
	@RequestMapping(value = "/cancelDistrictSign")
	@ResponseBody
	public Object cancelDistrictSign(BizDistrictSign bizDistrictSign) {
		if (log.isDebugEnabled()) {
			log.debug("start method<cancelDistrictSign>");
		}

		OPERATE_TYPE delType = ComPush.OPERATE_TYPE.INVALID;
		if ((bizDistrictSign != null) && "Y".equals(bizDistrictSign.getCancelFlag())) {
			delType = ComPush.OPERATE_TYPE.VALID;
			bizDistrictSign.setCancelFlag("Y");
		} else if ((bizDistrictSign != null) && "N".equals(bizDistrictSign.getCancelFlag())) {
			bizDistrictSign.setCancelFlag("N");
		} else {
			return new ResultMessage("2", "设置失败,无效参数");
		}

		districtSignService.updateDistrictSignFlag(bizDistrictSign);
		//添加推送信息
		try {
			pushAdapterService.push(bizDistrictSign.getSignId(),
							ComPush.OBJECT_TYPE.DISTRICTSIGN,
							ComPush.PUSH_CONTENT.BIZ_DISTRICT_SIGN,delType, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
		} catch (Exception e) {
			log.error("Push info failure ！Push Type:"
					+ ComPush.OBJECT_TYPE.DISTRICTSIGN.name() + " ID:"
					+ bizDistrictSign.getSignId() + "." + e.getMessage());
		}
		return ResultMessage.SET_SUCCESS_RESULT;
	}
	 
	  /**
		 * 选择经纬度
		 * @return
		 */
	@RequestMapping(value = "/selectCoordinate")
	public String modifyCoordinate(Model model, String callback, String placeName, String coordinateStr) {
		if(coordinateStr != null){
			String[] coordinate = coordinateStr.split(",");
			if(null != coordinate && coordinate.length>1)
			{
				model.addAttribute("longitude", coordinate[0]);
				model.addAttribute("latitude", coordinate[1]);
			}
		}
		model.addAttribute("placeName", placeName);
		model.addAttribute("callback", callback);
		return "/biz/districtSign/selectCoordinate";
	}
	
	
}