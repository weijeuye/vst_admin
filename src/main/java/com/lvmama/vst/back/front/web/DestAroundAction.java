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

import com.lvmama.vst.back.biz.po.BizDest;
import com.lvmama.vst.back.biz.po.BizDistrict;
import com.lvmama.vst.back.client.biz.service.DestClientService;
import com.lvmama.vst.back.client.biz.service.DistrictClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.front.po.BizDestAround;
import com.lvmama.vst.back.front.service.DestAroundService;
import com.lvmama.vst.back.front.vo.FrontDestRelatedVO;
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
 * 第2目的地管理Action
 * 
 */

@Controller
@RequestMapping("/front/destAround")
public class DestAroundAction extends BaseActionSupport {
	/**
	 * 序列
	 */
	private static final long serialVersionUID = -5244200781469028766L;
	private static final Log LOG = LogFactory.getLog(DestAroundAction.class);
	
	@Autowired
	private DestClientService destService;
	
	@Autowired
	private DestAroundService destAroundService;
	@Autowired
	private PushAdapterServiceRemote pushAdapterService;
	
	@Autowired
	private DistrictClientService districtService;
	
	@Autowired
	private ComLogClientService comLogService;
	/**
	 * 获得目的地,出发地列表
	 */
	@RequestMapping(value = "/findDestList")
	public String findDestList(Model model, Integer page,BizDest bizDest,String hasSetAroundDest,HttpServletRequest req) throws BusinessException {
		return "/front/districtAround/districtAroundHeader";
	}
	
	
	/**
	 * 获得目的地列表
	 */
	@RequestMapping(value = "/findDestLists")
	public String findDestLists(Model model, Integer page,BizDest bizDest,String hasSetAroundDest,HttpServletRequest req) throws BusinessException {
		
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("destId", bizDest.getDestId());
		parameters.put("destType", bizDest.getDestType());
		parameters.put("destName", bizDest.getDestName());
		if(StringUtil.isNotEmptyString(bizDest.getCancelFlag())){
			parameters.put("cancelFlag", bizDest.getCancelFlag());
			model.addAttribute("cancelFlag", bizDest.getCancelFlag());
		}
		if(StringUtil.isNotEmptyString(hasSetAroundDest) && "Y".equalsIgnoreCase(hasSetAroundDest)){
			parameters.put("hasSetAroundDest", hasSetAroundDest);
			model.addAttribute("hasSetAroundDest", hasSetAroundDest);
		}		
		int count = MiscUtils.autoUnboxing( destService.findDestCount(parameters) );

		int pagenum = page == null ? 1 : page;
		Page<BizDest> pageParam = Page.page(count, 20, pagenum);
		pageParam.buildUrl(req);
		parameters.put("_start", pageParam.getStartRows());
		parameters.put("_end", pageParam.getEndRows());
		parameters.put("_orderby", "DEST_ID");
		parameters.put("_order", "ASC");
		List<BizDest> list = MiscUtils.autoUnboxing( destService.findDestList(parameters) );
		list = destService.setParentsDestNameInfo(list, parameters);
		pageParam.setItems(list);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("destId", bizDest.getDestId());
		model.addAttribute("destName", bizDest.getDestName());
		model.addAttribute("destType", bizDest.getDestType());
		model.addAttribute("destTypeList", BizDest.DEST_TYPE.values());
		model.addAttribute("page", pageParam.getPage().toString());

		return "/front/destAround/findDestList";
	}
	
	
	
	
	
	
	
	

	/**
	 * 跳转到修改页面
	 */
	@RequestMapping(value = "/showAddAndUpdateDestAround")
	public String showAddAndUpdateDestAround(Model model, Long destId,String destName) throws BusinessException {
		Map<String,Object> params = new HashMap<String, Object>();
		params.put("destId", destId);
		params.put("_orderby", "SEQ");
		params.put("_order", "ASC");
		
		List<BizDestAround> destAroundList = destAroundService.findAroundDestWithPropList(params);
		model.addAttribute("destAroundList", destAroundList);
		model.addAttribute("destId", destId);
		model.addAttribute("destName", destName);
		List<BizDestAround.DESTAROUNDTYPE>  destAroundTypeList= new ArrayList<BizDestAround.DESTAROUNDTYPE>(Arrays.asList(BizDestAround.DESTAROUNDTYPE.values()));
		model.addAttribute("destAroundTypeList", destAroundTypeList);
		return "/front/destAround/showAddAndUpdateDestAround";
	}

	/**
	 * 添加第2目的地
	 * 
	 * @return 添加结果JSON
	 */
	@RequestMapping(value = "/addDestAround")
	@ResponseBody
	public Object addDestAround(FrontDestRelatedVO frontDestRelatedVO, BizDest dest) throws BusinessException {
		if(dest!=null && dest.getDestId()!=null){
		BizDestAround record = new BizDestAround();
		record.setDestId(dest.getDestId());
		Map<String,Object> params = new HashMap<String, Object>();
		params.put("destId", dest.getDestId());
		params.put("_orderby", "SEQ");
		params.put("_order", "ASC");
		List<BizDestAround> oldDestAroundList = destAroundService.findAroundDestWithPropList(params);
		destAroundService.deleteByDestAround(record);
		if(frontDestRelatedVO!=null && frontDestRelatedVO.getBizDestAroundList()!=null && frontDestRelatedVO.getBizDestAroundList().size()>0){
		for(int i=0; i<frontDestRelatedVO.getBizDestAroundList().size(); i++){
			BizDestAround bizDestAround = frontDestRelatedVO.getBizDestAroundList().get(i);
			if(bizDestAround == null || bizDestAround.getAroundDestId() == null){
				continue;
			}
			bizDestAround.setDestId(dest.getDestId());
			if(null==bizDestAround.getSeq()){
				bizDestAround.setSeq(Long.valueOf(i+1));
			}
			
			destAroundService.addBizDestAround(bizDestAround);
		}
		}
		//添加推送信息
		try {
			pushAdapterService.push(dest.getDestId(), ComPush.OBJECT_TYPE.DEST, ComPush.PUSH_CONTENT.BIZ_DEST_AROUND, ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
		} catch (Exception e) {
			LOG.error("Push info failure ！Push Type:"
					+ ComPush.OBJECT_TYPE.DEST.name() + " ID:"
					+ dest.getDestId() + "." + e.getMessage());
		}
		
		List<BizDestAround> newDestAroundList = destAroundService.findAroundDestWithPropList(params);
		String logStr = getAroundDesttLog(oldDestAroundList, newDestAroundList);
		if(StringUtils.isNotBlank(logStr)){
		try {
			comLogService.insert(COM_LOG_OBJECT_TYPE.BIZ_DEST_AROUND,
					dest.getDestId(),
					null, 
					this.getLoginUser().getUserName(), 
					"更新第二目的地"+ "："+logStr,
					COM_LOG_LOG_TYPE.BIZ_DEST_AROUND_UPDATE.name(),
					"更新第二目的地", null);
			
		} catch (Exception e) {
			LOG.error("Record Log failure ！Log type:"+ COM_LOG_LOG_TYPE.BIZ_DEST_AROUND_UPDATE);
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

		return "/front/destAround/selectDistrictList";
	}
	
	
	private String getAroundDesttLog(List<BizDestAround> oldBizDestAroundList,List<BizDestAround> newBizDestAroundList){
		StringBuffer sb = new StringBuffer();
		String oldLogTemplete ="原来值： ";
		String newLongTemplete ="新值： ";
		if(oldBizDestAroundList!=null && oldBizDestAroundList.size()>0){
		for(BizDestAround oldBizDestAround :oldBizDestAroundList){
			
			BizDistrict aroundDest = oldBizDestAround.getAroundDistrict();
			if(aroundDest!=null){
				sb.append("["+aroundDest.getDistrictId()+":"+aroundDest.getDistrictName()+"],");
				
			}
		}
		}else{
			sb.append("[],");
		}
		
		sb.insert(0, oldLogTemplete);
		sb.append(newLongTemplete);
		if(newBizDestAroundList!=null && newBizDestAroundList.size()>0){
		for(BizDestAround newBizDestAround :newBizDestAroundList){
			
			BizDistrict aroundDest = newBizDestAround.getAroundDistrict();
			if(aroundDest!=null){
				sb.append("【"+aroundDest.getDistrictId()+":"+aroundDest.getDistrictName()+"】,");
				
			}
		}
		}else{
			sb.append("【】");
		}
		return sb.toString();
		
		
	}
	
 
}