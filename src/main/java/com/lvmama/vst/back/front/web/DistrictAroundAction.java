package com.lvmama.vst.back.front.web;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizDistrict;
import com.lvmama.vst.back.client.biz.service.DistrictClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.front.po.BizDestAround;
import com.lvmama.vst.back.front.po.BizDistrictAround;
import com.lvmama.vst.back.front.service.DistrictAroundService;
import com.lvmama.vst.back.front.vo.FrontDistrictRelatedVO;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.pub.service.PushAdapterServiceRemote;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 第2出发地管理Action
 * 
 */

@Controller
@RequestMapping("/front/districtAround")
public class DistrictAroundAction extends BaseActionSupport {
	private static final long serialVersionUID = -4483138246885222784L;
	/**
	 * 序列
	 */
	private static final Log LOG = LogFactory.getLog(DistrictAroundAction.class);
	@Autowired
	private DistrictAroundService districtAroundService;
	@Autowired
	PushAdapterServiceRemote pushAdapterService;
	
	@Autowired
	private DistrictClientService districtService;
	@Autowired
	private ComLogClientService comLogService;
	
	
	/**
	 * 第二出发地管理面板
	 */
	@RequestMapping(value="/districtAroundHeader")
	public String destAroundHeader(Model model){
		return "/front/districtAround/districtAroundHeader";
	}
	
	/**
	 * 获得目的地列表
	 */
	@RequestMapping(value = "/findDistrictList")
	public String findDistrictList(Model model, Integer page,BizDistrict bizDistrict,String hasSetDistrict,HttpServletRequest req) throws BusinessException {
		
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("districtId", bizDistrict.getDistrictId());
		if(StringUtil.isNotEmptyString(bizDistrict.getDistrictType())){
			parameters.put("districtType", bizDistrict.getDistrictType());
		}
		if(StringUtil.isNotEmptyString(bizDistrict.getDistrictName())){
			parameters.put("districtName", bizDistrict.getDistrictName());
		}
		if(StringUtil.isNotEmptyString(bizDistrict.getCancelFlag())){
			parameters.put("cancelFlag", bizDistrict.getCancelFlag());
			model.addAttribute("cancelFlag", bizDistrict.getCancelFlag());
		}
		if(StringUtil.isNotEmptyString(hasSetDistrict) && "Y".equalsIgnoreCase(hasSetDistrict)){
			parameters.put("hasSetDistrict", hasSetDistrict);
			model.addAttribute("hasSetDistrict", hasSetDistrict);
		}
		int count = MiscUtils.autoUnboxing( districtService.findDistrictCount(parameters) ) ;
		int pagenum = page == null ? 1 : page;
		Page<BizDistrict> pageParam = Page.page(count, 20, pagenum);
		pageParam.buildUrl(req);
		parameters.put("_start", pageParam.getStartRows());
		parameters.put("_end", pageParam.getEndRows());
		parameters.put("_orderby", "district_id");
		parameters.put("_order", "ASC");
		List<BizDistrict> list = MiscUtils.autoUnboxing( districtService.findDistrictList(parameters) );
		//迁移vst_admin的权益之作
		list = districtService.setParentsDistrictNameInfo(list, parameters);
		pageParam.setItems(list);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("districtId", bizDistrict.getDistrictId());
		model.addAttribute("districtName", bizDistrict.getDistrictName());
		model.addAttribute("districtType", bizDistrict.getDistrictType());
		model.addAttribute("districtTypeList", BizDistrict.DISTRICT_TYPE.values());
		model.addAttribute("page", pageParam.getPage().toString());

		return "/front/districtAround/findDistrictList";
	}

	/**
	 * 跳转到修改页面
	 */
	@RequestMapping(value = "/showAddAndUpdateDistrictAround")
	public String showAddAndUpdateDistrictAround(Model model, Long districtId,String districtName) throws BusinessException {
		
		Map<String,Object> params = new HashMap<String, Object>();
		params.put("districtId", districtId);
		params.put("_orderby", "SEQ");
		params.put("_order", "ASC");
		List<BizDistrictAround> districtAroundList = districtAroundService.findAroundDistrictWithPropList(params);
		model.addAttribute("districtId", districtId);
		model.addAttribute("districtName", districtName);
		model.addAttribute("districtAroundList", districtAroundList);
		List<BizDestAround.DESTAROUNDTYPE>  destAroundTypeList= new ArrayList<BizDestAround.DESTAROUNDTYPE>(Arrays.asList(BizDestAround.DESTAROUNDTYPE.values()));
		model.addAttribute("districtAroundTypeList", destAroundTypeList);
		return "/front/districtAround/showAddAndUpdateDistrictAround";
	}

	/**
	 * 添加第2目的地
	 * 
	 * @return 添加结果JSON
	 */
	@RequestMapping(value = "/addDistrictAround")
	@ResponseBody
	public Object addDistrictAround(FrontDistrictRelatedVO frontDistrictRelatedVO, BizDistrict district) throws BusinessException {
		
		if(district!=null && district.getDistrictId()!=null){
		Map<String,Object> params = new HashMap<String, Object>();
		params.put("districtId", district.getDistrictId());
		params.put("_orderby", "SEQ");
		params.put("_order", "ASC");
		List<BizDistrictAround> oldDistrictAroundList = districtAroundService.findAroundDistrictWithPropList(params);
		BizDistrictAround record = new BizDistrictAround();
		record.setDistrictId(district.getDistrictId());
		districtAroundService.deleteByDistrictAround(record);
		if(frontDistrictRelatedVO!=null && frontDistrictRelatedVO.getBizDistrictAroundList()!=null && frontDistrictRelatedVO.getBizDistrictAroundList().size()>0){
		for(int i=0; i<frontDistrictRelatedVO.getBizDistrictAroundList().size(); i++){
			BizDistrictAround bizDistrictAround = frontDistrictRelatedVO.getBizDistrictAroundList().get(i);
			if(bizDistrictAround == null || bizDistrictAround.getAroundDistrictId() == null){
				continue;
			}
			bizDistrictAround.setDistrictId(district.getDistrictId());
			if(null==bizDistrictAround.getSeq()){
				bizDistrictAround.setSeq(1L);
			}
			districtAroundService.addBizDistrictAround(bizDistrictAround);
		}
		}
		//添加推送信息
		try {
			pushAdapterService.push(district.getDistrictId(), ComPush.OBJECT_TYPE.DISTRICT, ComPush.PUSH_CONTENT.BIZ_DISTRICT_AROUND, ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
		} catch (Exception e) {
			LOG.error("Push info failure ！Push Type:"
					+ ComPush.OBJECT_TYPE.DISTRICT.name() + " ID:"
					+ district.getDistrictId() + "." + e.getMessage());
		}
		List<BizDistrictAround> newDistrictAroundList = districtAroundService.findAroundDistrictWithPropList(params);
		String logStr = getAroundDistrictLog(oldDistrictAroundList,newDistrictAroundList);
		if(StringUtils.isNotBlank(logStr)){
		try {
			comLogService.insert(COM_LOG_OBJECT_TYPE.BIZ_DISTRICT_AROUND,
					district.getDistrictId(),
					null, 
					this.getLoginUser().getUserName(), 
					"更新第二出发地"+ "："+logStr,
					COM_LOG_LOG_TYPE.BIZ_DISTRICT_AROUND_UPDATE.name(),
					"更新第二出发地", null);
			
		} catch (Exception e) {
			LOG.error("Record Log failure ！Log type:"+ COM_LOG_LOG_TYPE.BIZ_DISTRICT_AROUND_UPDATE);
			LOG.error(ExceptionFormatUtil.getTrace(e));
		}
		}
		return ResultMessage.SET_SUCCESS_RESULT;
		}
		return ResultMessage.SET_FAIL_RESULT;
	}
	
	

	
	
	/**
	 * 获得行政区列表
	 */
	@RequestMapping(value = "/selectDistrictList")
	public String selectDistrictList(Model model, Integer page, BizDistrict district, HttpServletRequest req) throws BusinessException {
		
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("districtName", district.getDistrictName());
		parameters.put("districtType", district.getDistrictType());
		parameters.put("cancelFlag", "Y");
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

		return "/front/districtAround/selectDistrictList";
	}
	
	
	private String getAroundDistrictLog(List<BizDistrictAround> oldBizDistrictAroundList,List<BizDistrictAround> newBizDistrictAroundList){
		StringBuffer sb = new StringBuffer();
		String oldLogTemplete ="原来值： ";
		String newLongTemplete ="新值： ";
		if(oldBizDistrictAroundList!=null && oldBizDistrictAroundList.size()>0){
		for(BizDistrictAround oldBizDistrictAround :oldBizDistrictAroundList){
			
			BizDistrict aroundDistrict = oldBizDistrictAround.getAroundDistrict();
			if(aroundDistrict!=null){
				sb.append("["+aroundDistrict.getDistrictId()+":"+aroundDistrict.getDistrictName()+"],");
				
			}
		}
		}else{
			sb.append("[],");
		}
		
		sb.insert(0, oldLogTemplete);
		sb.append(newLongTemplete);
		if(newBizDistrictAroundList!=null && newBizDistrictAroundList.size()>0){
		for(BizDistrictAround newBizDistrictAround :newBizDistrictAroundList){
			
			BizDistrict aroundDistrict = newBizDistrictAround.getAroundDistrict();
			if(aroundDistrict!=null){
				sb.append("【"+aroundDistrict.getDistrictId()+":"+aroundDistrict.getDistrictName()+"】,");
				
			}
		}
		}else{
			sb.append("【】");
		}
		return sb.toString();
		
		
	}
 
}