package com.lvmama.vst.back.biz.web;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.lvmama.vst.comm.utils.web.HttpServletLocalThread;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizOrderRequired;
import com.lvmama.vst.back.biz.po.BizOrderRequired.BIZ_ORDER_REQUIRED_FIELD_LIST;
import com.lvmama.vst.back.biz.po.BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST;
import com.lvmama.vst.back.biz.po.BizOrderRequiredExpand;
import com.lvmama.vst.back.biz.service.BizOrderRequiredExpandService;
import com.lvmama.vst.back.client.biz.service.BizOrderRequiredClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 品类下单必填项
 */
@Controller
@RequestMapping("/biz/orderRequired")
public class OrderRequiredAction extends BaseActionSupport {

	private static final long serialVersionUID = -1357217569819363610L;
	
	private static final Log LOG = LogFactory.getLog(OrderRequiredAction.class);

	@Autowired
	private BizOrderRequiredClientService bizOrderRequiredService;
	
	@Autowired
	private BizOrderRequiredExpandService bizOrderRequiredExpandService;
	
	@Autowired
	private ComLogClientService comLogService;
	

	@RequestMapping(value = "/showOrderRequired")
	public String showOrderRequired(Model model, String groupCode) throws BusinessException {

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("groupCode", groupCode);
		List<BizOrderRequired> list = bizOrderRequiredService.findBizOrderRequiredByParams(param);
		BizOrderRequired bizRequired = new BizOrderRequired();
		if (CollectionUtils.isNotEmpty(list))
			bizRequired = list.get(0);
		else { // 部分参数要赋默认值
			bizRequired.setGroupCode(groupCode);
			bizRequired.setPhoneNumType(BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.TRAV_NUM_NO.getCode());
			bizRequired.setIdNumType(BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.TRAV_NUM_NO.getCode());
		}
		Map<String, String> expandMap = new HashMap<String, String>();

		param.clear();
		if (bizRequired.getReqId()!=null) {
			param.put("reqId", bizRequired.getReqId());
			List<BizOrderRequiredExpand> listExpand=bizOrderRequiredExpandService.selectByExample(param);
			if (CollectionUtils.isNotEmpty(listExpand)) {
				for (BizOrderRequiredExpand bre:listExpand) {
					String key=bre.getWordsType()+"_"+bre.getObjectType();
					String value=bre.getObejctValue();
					expandMap.put(key, value);
				}
			}
		}
		
		model.addAttribute("orderNeedTravNumMap", needTravNumMap());
		model.addAttribute("bizOrderRequired", bizRequired);
		model.addAttribute("expandMap", expandMap);
		model.addAttribute("orderRequiredFieldMap", requiredFieldMap());
		model.addAttribute("orderRequiredTravNumMap", requiredTravNumMap());
		return "/biz/orderRequired/showOrderRequired";
	}

	private Map<String, String> requiredFieldMap() {
		Map<String, String> map = new HashMap<String, String>();
		BIZ_ORDER_REQUIRED_FIELD_LIST[] list = BIZ_ORDER_REQUIRED_FIELD_LIST.values();
		for (BIZ_ORDER_REQUIRED_FIELD_LIST field : list) {
			map.put(field.getCode(), field.getCnName());
		}
		return map;
	}

	private Map<String, String> needTravNumMap() {
		Map<String, String> map = new LinkedHashMap<String, String>();
		BIZ_ORDER_REQUIRED_TRAV_NUM_LIST[] list = BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.need();
		for (BIZ_ORDER_REQUIRED_TRAV_NUM_LIST field : list) {
			map.put(field.getCode(), field.getCnName());
		}
		return map;
	}
	private Map<String, String> requiredTravNumMap() {
		Map<String, String> map = new HashMap<String, String>();
		BIZ_ORDER_REQUIRED_TRAV_NUM_LIST[] list = BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.all();
		for (BIZ_ORDER_REQUIRED_TRAV_NUM_LIST field : list) {
			map.put(field.getCode(), field.getCnName());
		}
		return map;
	}

	@RequestMapping(value = "/addOrModifyOrderRequired")
	@ResponseBody
	public Object addOrModifyDict(BizOrderRequired bizOrderRequired) throws BusinessException {
		if(BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.TRAV_NUM_NO.name().equalsIgnoreCase(bizOrderRequired.getNeedGuideFlag())){
			bizOrderRequired.setGuideIdType(null);
			bizOrderRequired.setGuideNameType(null);
			bizOrderRequired.setGuideNoType(null);
			bizOrderRequired.setGuidePhoneType(null);
			
		}
		try {
			if (bizOrderRequired.getReqId()==null) {
				return addOrderRequired(bizOrderRequired);
			}
			return updateOrderRequired(bizOrderRequired);
		} catch (Exception e) {
			LOG.error(ExceptionFormatUtil.getTrace(e));
			return new ResultMessage(ResultMessage.ERROR, "新增失败");
		}
	}
	
	private Object addOrderRequired(BizOrderRequired bizOrderRequired) {
		int res = bizOrderRequiredService.insertSelective(bizOrderRequired);
		if(res==0){
			return new ResultMessage(ResultMessage.ERROR, "新增失败");
		}
		try {
			Map<String,String> param = requiredFieldMap();
			String cnName= param.get(bizOrderRequired.getGroupCode());
			comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, 
					bizOrderRequired.getReqId(), bizOrderRequired.getReqId(), 
					this.getLoginUser() == null ? "" : this.getLoginUser().getUserName(), 
					"新增【" + cnName+ "】品类：【" + bizOrderRequired.getReqId() + "】", 
					COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name(), 
					"新增【" + cnName+ "】品类：【" + bizOrderRequired.getReqId() + "】",null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.DICT_BUSINESS_SHIP_COMPANY.name());
			log.error(e.getMessage());
		}
		//处理扩展字段信息
		bizOrderRequiredExpandHandle(bizOrderRequired);
		return ResultMessage.ADD_SUCCESS_RESULT;
	}

	private void bizOrderRequiredExpandHandle(BizOrderRequired bizOrderRequired) {
		Map<String, Object> param =new HashMap<String, Object>();
		param.put("reqId", bizOrderRequired.getReqId());
		List<BizOrderRequiredExpand> oldListExpand=bizOrderRequiredExpandService.selectByExample(param);
		if (CollectionUtils.isNotEmpty(oldListExpand)) {
			for (BizOrderRequiredExpand bre:oldListExpand) {
				bizOrderRequiredExpandService.deleteByPrimaryKey(bre.getExpandId());
			}
		}
		if (CollectionUtils.isNotEmpty(bizOrderRequired.getListExpand())) {
			for (BizOrderRequiredExpand bre:bizOrderRequired.getListExpand()) {
				bre.setReqId(bizOrderRequired.getReqId());
				bizOrderRequiredExpandService.insertSelective(bre);
			}
		}
	}

	private Object updateOrderRequired(BizOrderRequired bizOrderRequired) throws BusinessException {
		BizOrderRequired oldBizOrderRequired = bizOrderRequiredService.selectByPrimaryKey(bizOrderRequired.getReqId());
		int res = bizOrderRequiredService.updateByPrimaryKeySelective(bizOrderRequired);
		if (res==0){
			return new ResultMessage(ResultMessage.ERROR, "修改失败");
		}
		try {
			//获取操作日志
			String logContent = getTagChangeLog(oldBizOrderRequired, bizOrderRequired);
			//添加操作日志
			if(null != logContent && !"".equals(logContent)) {
				Map<String,String> param = requiredFieldMap();
				String cnName= param.get(bizOrderRequired.getGroupCode());
			    comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, 
					oldBizOrderRequired.getReqId(), oldBizOrderRequired.getReqId(), 
					this.getLoginUser() == null ? "" : this.getLoginUser().getUserName(), 
					"修改了品类：[" + cnName+ "]：修改内容为【" +logContent + "】", 
					COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name(), 
					"["+cnName+"]",null);    
			}
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.DICT_BUSINESS_SHIP_COMPANY.name());
			log.error(e.getMessage());
		}
		//处理扩展字段信息
		bizOrderRequiredExpandHandle(bizOrderRequired);
		return ResultMessage.UPDATE_SUCCESS_RESULT;

	}
	
	//拼接日志内容
		private String getTagChangeLog(BizOrderRequired oldBizOrderRequired, BizOrderRequired bizOrderRequired) {
			String ennamaTypeOptional= HttpServletLocalThread.getRequest().getParameter("listExpand[0].obejctValue");
			String ennameTypeOnlyBackView= HttpServletLocalThread.getRequest().getParameter("listExpand[1].obejctValue");
			String phoneTypeOptional= HttpServletLocalThread.getRequest().getParameter("listExpand[2].obejctValue");
			String phoneTypeOnlyBackView= HttpServletLocalThread.getRequest().getParameter("listExpand[3].obejctValue");
			String emailTypeOptional= HttpServletLocalThread.getRequest().getParameter("listExpand[4].obejctValue");
			String emailTypeOnlyBackView= HttpServletLocalThread.getRequest().getParameter("listExpand[5].obejctValue");
			String occupTypeOptional= HttpServletLocalThread.getRequest().getParameter("listExpand[6].obejctValue");
			String occupTypeOnlyBackView= HttpServletLocalThread.getRequest().getParameter("listExpand[7].obejctValue");
			String idNumTypeOptional= HttpServletLocalThread.getRequest().getParameter("listExpand[8].obejctValue");
			String idNumTypeOnlyBackView= HttpServletLocalThread.getRequest().getParameter("listExpand[9].obejctValue");
			String localHotelAddressTypeOptional= HttpServletLocalThread.getRequest().getParameter("listExpand[12].obejctValue");
			String localHotelAddressTypeOnlyBackView= HttpServletLocalThread.getRequest().getParameter("listExpand[13].obejctValue");
			String useTimeTypeOptional= HttpServletLocalThread.getRequest().getParameter("listExpand[14].obejctValue");
			String useTimeOnlyBackView= HttpServletLocalThread.getRequest().getParameter("listExpand[15].obejctValue");
			
			String guideNoTypeOptional=HttpServletLocalThread.getRequest().getParameter("listExpand[16].obejctValue");
			String guidePhoneTypeOptional=HttpServletLocalThread.getRequest().getParameter("listExpand[17].obejctValue");
			String guideIdTypeOptional=HttpServletLocalThread.getRequest().getParameter("listExpand[18].obejctValue");
			//选填配置or仅后台显示
			Map<String,Object> param = new HashMap<String,Object>();
			Map<String,String> expandMaps = new HashMap<String,String>(); 
			if (bizOrderRequired.getReqId()!=null) {
				param.put("reqId", bizOrderRequired.getReqId());
				List<BizOrderRequiredExpand> listExpand=bizOrderRequiredExpandService.selectByExample(param);
				if (CollectionUtils.isNotEmpty(listExpand)) {
					for (BizOrderRequiredExpand bre:listExpand) {
						String key=bre.getWordsType()+"_"+bre.getObjectType();
						String value=bre.getObejctValue();
						expandMaps.put(key, value);
					}
				}
			}
			String oldEnnamaTypeOptional = expandMaps.get("ennameType_OPTIONAL");
			String oldEnnameTypeOnlyBackView = expandMaps.get("ennameType_ONLYBACKVIEW");
			
			String oldPhoneTypeOptional = expandMaps.get("phoneType_OPTIONAL"); 
			String oldPhoneTypeOnlyBackView = expandMaps.get("phoneType_ONLYBACKVIEW");
			
			String oldEmailTypeOptional = expandMaps.get("emailType_OPTIONAL");
			String oldEmailTypeOnlyBackView = expandMaps.get("emailType_ONLYBACKVIEW");
			
			String oldOccupTypeOptional = expandMaps.get("occupType_OPTIONAL");
			String oldOccupTypeOnlyBackView = expandMaps.get("occupType_ONLYBACKVIEW");
			
			String oldIdNumTypeOptional = expandMaps.get("idNumType_OPTIONAL");
			String oldIdNumTypeOnlyBackView = expandMaps.get("idNumType_ONLYBACKVIEW");
			String olduseTimeTypeOptional=expandMaps.get("useTimeType_OPTIONAL");
			String olduseTimeTypeOnlyBackView=expandMaps.get("useTimeType_ONLYBACKVIEW");
			String oldlocalHotelAddressTypeOptional=expandMaps.get("localHotelAddressType_OPTIONAL");
			String oldlocalHotelAddressTypeOnlyBackView=expandMaps.get("localHotelAddressType_ONLYBACKVIEW");
			
			String oldGuideNoTypeOptional=expandMaps.get("guideNoType_OPTIONAL");
			String oldGuidePhoneTypeOptional=expandMaps.get("guidePhoneType_OPTIONAL");
			String oldGuideIdTypeOptional=expandMaps.get("guideIdType_OPTIONAL");
			
			//转换成汉字显示
			Map<String,String> params= requiredTravNumMap();
			String travNumType = params.get(bizOrderRequired.getTravNumType());
			String oldTravNumType = params.get(oldBizOrderRequired.getTravNumType());
			String ennameType = params.get(bizOrderRequired.getEnnameType());
			String oldEnnameType = params.get(oldBizOrderRequired.getEnnameType());
			String phoneNumType = params.get(bizOrderRequired.getPhoneNumType());
			String oldPhoneNumType = params.get(oldBizOrderRequired.getPhoneNumType());
			String emailType = params.get(bizOrderRequired.getEmailType());
			String oldEmailType = params.get(oldBizOrderRequired.getEmailType());
			String occupType = params.get(bizOrderRequired.getOccupType());
			String oldOccupType = params.get(oldBizOrderRequired.getOccupType());
			String idNumType = params.get(bizOrderRequired.getIdNumType());
			String oldIdNumType = params.get(oldBizOrderRequired.getIdNumType());
			String oldUseTimeType=params.get(oldBizOrderRequired.getUseTimeType());
			String useTimeType=params.get(bizOrderRequired.getUseTimeType());
			String OldLocalHotelType=params.get(oldBizOrderRequired.getLocalHotelAddressType());
			String localHotelType=params.get(bizOrderRequired.getLocalHotelAddressType());
			
			params = needTravNumMap();
			
			//导游证号
			String guideNoType = params.get(bizOrderRequired.getGuideNoType());
			String oldGuideNoType = params.get(oldBizOrderRequired.getGuideNoType());
			
			//导游手机号
			String guidePhoneType = params.get(bizOrderRequired.getGuidePhoneType());
			String oldGuidePhoneType = params.get(oldBizOrderRequired.getGuidePhoneType());
			
			//导游身份证号
			String guideIdType = params.get(bizOrderRequired.getGuideIdType());
			String oldGuideIdType = params.get(oldBizOrderRequired.getGuideIdType());
			
			//是否需要导游
			String needGuideFlag = params.get(bizOrderRequired.getNeedGuideFlag());
			String oldNeedGuideFlag = params.get(oldBizOrderRequired.getNeedGuideFlag());
			String operateCongif = params.get(bizOrderRequired.getOperatorConfig());
			String oldOperateCongif = params.get(oldBizOrderRequired.getOperatorConfig());
			StringBuffer logStr = new StringBuffer("");
			if(null != bizOrderRequired) {
				logStr.append(ComLogUtil.getLogTxt("是否需要游玩人信息", bizOrderRequired.getNeedTravFlag(), oldBizOrderRequired.getNeedTravFlag()));
				logStr.append(ComLogUtil.getLogTxt("游玩人数量类型", travNumType, oldTravNumType));
				logStr.append(ComLogUtil.getLogTxt("英文名选择类型", ennameType, oldEnnameType));
				if(StringUtil.isNotEmptyString(operateCongif) ||  StringUtil.isNotEmptyString(oldOperateCongif)){
					logStr.append(ComLogUtil.getLogTxt("是否业务配置", operateCongif, oldOperateCongif));
				}
				if(StringUtil.isNotEmptyString(ennamaTypeOptional)|| StringUtil.isNotEmptyString(ennameTypeOnlyBackView))
				{
					logStr.append(ComLogUtil.getLogTxt("选项信息",ennamaTypeOptional,oldEnnamaTypeOptional));
					logStr.append(ComLogUtil.getLogTxt("仅后台显示", ennameTypeOnlyBackView,oldEnnameTypeOnlyBackView));
				}
				logStr.append(ComLogUtil.getLogTxt("手机号数量类型", phoneNumType, oldPhoneNumType));
				if(StringUtil.isNotEmptyString(phoneTypeOptional) || StringUtil.isNotEmptyString(phoneTypeOnlyBackView))
				{
					logStr.append(ComLogUtil.getLogTxt("选项信息", phoneTypeOptional, oldPhoneTypeOptional));
					logStr.append(ComLogUtil.getLogTxt("仅后台显示", phoneTypeOnlyBackView, oldPhoneTypeOnlyBackView));
				}
				logStr.append(ComLogUtil.getLogTxt("email选择类型",emailType, oldEmailType));
				if(StringUtil.isNotEmptyString(emailTypeOptional) || StringUtil.isNotEmptyString(emailTypeOnlyBackView))
				{
					logStr.append(ComLogUtil.getLogTxt("选项信息", emailTypeOptional, oldEmailTypeOptional));
					logStr.append(ComLogUtil.getLogTxt("仅后台显示", emailTypeOnlyBackView, oldEmailTypeOnlyBackView));
				}
				logStr.append(ComLogUtil.getLogTxt("人群选择类型", occupType, oldOccupType));
				if(StringUtil.isNotEmptyString(occupTypeOptional) || StringUtil.isNotEmptyString(occupTypeOnlyBackView))
				{
					logStr.append(ComLogUtil.getLogTxt("选项信息", occupTypeOptional, oldOccupTypeOptional));
					logStr.append(ComLogUtil.getLogTxt("仅后台显示", occupTypeOnlyBackView, oldOccupTypeOnlyBackView));
				}
				logStr.append(ComLogUtil.getLogTxt("证件数量类型", idNumType, oldIdNumType));
				if(StringUtil.isNotEmptyString(idNumTypeOptional) || StringUtil.isNotEmptyString(idNumTypeOnlyBackView))
				{
					logStr.append(ComLogUtil.getLogTxt("选项信息", idNumTypeOptional, oldIdNumTypeOptional));
					logStr.append(ComLogUtil.getLogTxt("仅后台显示", idNumTypeOnlyBackView, oldIdNumTypeOnlyBackView));
				}
				logStr.append(ComLogUtil.getLogTxt("使用时间", useTimeType, oldUseTimeType));
				if(StringUtil.isNotEmptyString(useTimeTypeOptional) || StringUtil.isNotEmptyString(useTimeOnlyBackView)){
					logStr.append(ComLogUtil.getLogTxt("选项信息", useTimeTypeOptional, olduseTimeTypeOptional));
					logStr.append(ComLogUtil.getLogTxt("仅后台显示",useTimeOnlyBackView, olduseTimeTypeOnlyBackView));
					
				}
				logStr.append(ComLogUtil.getLogTxt("当地酒店地址", localHotelType, OldLocalHotelType));
				if(StringUtil.isNotEmptyString(localHotelAddressTypeOptional) || StringUtil.isNotEmptyString(localHotelAddressTypeOnlyBackView)){
					logStr.append(ComLogUtil.getLogTxt("选项信息", localHotelAddressTypeOptional, oldlocalHotelAddressTypeOptional));
					logStr.append(ComLogUtil.getLogTxt("仅后台显示",localHotelAddressTypeOnlyBackView, oldlocalHotelAddressTypeOnlyBackView));
					
				}
				if("全部游玩人".equals(idNumType)||"一个游玩人".equals(idNumType)||"Y".equals(idNumType)){
				logStr.append(ComLogUtil.getLogTxt("是否需要身份证", bizOrderRequired.getIdFlag(), oldBizOrderRequired.getIdFlag()));
				logStr.append(ComLogUtil.getLogTxt("是否需要护照", bizOrderRequired.getPassprotFlag(), oldBizOrderRequired.getPassprotFlag()));
				logStr.append(ComLogUtil.getLogTxt("是否港澳通行证", bizOrderRequired.getPassFlag(), oldBizOrderRequired.getPassFlag()));
				logStr.append(ComLogUtil.getLogTxt("是否台湾通行证", bizOrderRequired.getTwPassFlag(), oldBizOrderRequired.getTwPassFlag()));
				logStr.append(ComLogUtil.getLogTxt("是否台胞证", bizOrderRequired.getTwResidentFlag(), oldBizOrderRequired.getTwResidentFlag()));
				logStr.append(ComLogUtil.getLogTxt("是否出生证明", bizOrderRequired.getBirthCertFlag(), oldBizOrderRequired.getBirthCertFlag()));
				logStr.append(ComLogUtil.getLogTxt("是否户口簿", bizOrderRequired.getHouseholdRegFlag(), oldBizOrderRequired.getHouseholdRegFlag()));
				logStr.append(ComLogUtil.getLogTxt("是否士兵证", bizOrderRequired.getSoldierFlag(), oldBizOrderRequired.getSoldierFlag()));
				logStr.append(ComLogUtil.getLogTxt("是否军官证", bizOrderRequired.getOfficerFlag(), oldBizOrderRequired.getOfficerFlag()));
				logStr.append(ComLogUtil.getLogTxt("是否回乡证", bizOrderRequired.getHkResidentFlag(), oldBizOrderRequired.getHkResidentFlag()));
				}
				
				logStr.append(ComLogUtil.getLogTxt("是否需要导游", needGuideFlag, oldNeedGuideFlag));
				
				logStr.append(ComLogUtil.getLogTxt("导游证号", guideNoType, oldGuideNoType));
				
				logStr.append(ComLogUtil.getLogTxt("导游手机号", guidePhoneType, oldGuidePhoneType));
				
				logStr.append(ComLogUtil.getLogTxt("导游身份证号", guideIdType, oldGuideIdType));
				
				if(StringUtil.isNotEmptyString(guideNoTypeOptional)){
					logStr.append(ComLogUtil.getLogTxt("导游证号选项信息", guideNoTypeOptional, oldGuideNoTypeOptional));
				}
				if(StringUtil.isNotEmptyString(guidePhoneTypeOptional)){
					logStr.append(ComLogUtil.getLogTxt("导游手机号选项信息", guidePhoneTypeOptional, oldGuidePhoneTypeOptional));
				}
				if(StringUtil.isNotEmptyString(guideIdTypeOptional)){
					logStr.append(ComLogUtil.getLogTxt("导游身份证号选项信息", guideIdTypeOptional, oldGuideIdTypeOptional));
				}
			}
			return logStr.toString();
		}

	
	
	/**
	 * 获得下单必填项列表
	 */
	@RequestMapping(value = "/findOrderRequiredList")
	@ResponseBody
	public Object findOrderRequiredList(Model model, BizOrderRequired bizOrderRequired) throws BusinessException {

		Map<String, Object> params = new HashMap<String, Object>();
		String groupCode =  bizOrderRequired.getGroupCode();
		//国内短线，国内长线走下单必填项当地游国内逻辑
		if(groupCode.equals("LOCAL_INNERLONGLINE") || groupCode.equals("LOCAL_INNERSHORTLINE")){
			groupCode = "LOCAL_INNERLINE";
		}
		params.put("groupCode", groupCode);
		List<BizOrderRequired> bizOrderRequiredList = bizOrderRequiredService.findBizOrderRequiredByParams(params);
		if(bizOrderRequiredList!=null && bizOrderRequiredList.size()>0){
			return bizOrderRequiredList.get(0);
		}
		return null;
	}
}
