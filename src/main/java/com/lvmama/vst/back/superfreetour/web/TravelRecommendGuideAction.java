package com.lvmama.vst.back.superfreetour.web;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import scala.actors.threadpool.Arrays;

import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.superfreetour.service.TravelRecommendGuideService;
import com.lvmama.vst.back.superfreetour.service.TravelRecommendTrafficRuleService;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.superfreetour.po.TravelRecommendGuide;
@Controller
@RequestMapping("/superfreetour/travelRecommendGuide")
public class TravelRecommendGuideAction extends BaseActionSupport{
	
	/**
	 * 旅游宝典导语ACTION
	 */
	private static final long serialVersionUID = 6701670412039996962L;
	private static final Log LOG = LogFactory.getLog(TravelRecommendGuideAction.class);
	@Autowired
	private TravelRecommendGuideService travelRecommendGuideService;
	@Autowired
	private ComLogClientService comLogService;
	
	
	@Autowired
	private TravelRecommendTrafficRuleService travelRecommendTrafficRuleService;
	
	@RequestMapping(value = "/showUpdateTravelRecommendGuide")
	public String showUpdateTravelRecommendGuide(Model model, long recommendId,HttpServletRequest req) {
		
		//查询出老的导语显示到页面上
		List<TravelRecommendGuide> travelRecommendGuide=travelRecommendGuideService.findTravelRecommendGuideByRecommendId(recommendId);
		
		model.addAttribute("recommendId", recommendId);
		model.addAttribute("travelRecommendGuide", travelRecommendGuide);
		
		return "/superfreetour/showUpdateTravelRecommendGuide";
	}
	
	@RequestMapping(value="/updateTravelRecommendGuide")
	@ResponseBody
	public Object updateTravelRecommendGuide(Model model, Long recommendId,String guideStr, HttpServletRequest req) {
		try{
			//用于添加日志
			List<TravelRecommendGuide> oldTravelRecommendGuide=travelRecommendGuideService.findTravelRecommendGuideByRecommendId(recommendId);

			JSONArray array = JSONArray.fromObject(guideStr);
			TravelRecommendGuide[] guides = (TravelRecommendGuide[]) JSONArray.toArray(array,TravelRecommendGuide.class);
			List<TravelRecommendGuide> travelRecommendGuideList = Arrays.asList(guides);
			//处理页面数据
			Date now = new Date();

			Iterator<TravelRecommendGuide> iter = travelRecommendGuideList.iterator();
			Long index =0L;
			while(iter.hasNext()){
				TravelRecommendGuide guid = iter.next();
				if(!"Y".equals(guid.getCoverFlag())){
					guid.setCoverFlag("N");
				}
				if(StringUtils.isBlank(guid.getPropType())){
					iter.remove();
					continue;
				}
				guid.setCreateTime(now);
				guid.setRecommendId(recommendId);
				index++;
				guid.setPropSort(index);
			}

			travelRecommendGuideService.saveTravelRecommendGuide(recommendId,travelRecommendGuideList);
			
			//用于添加日志
			List<TravelRecommendGuide> newTravelRecommendGuide=travelRecommendGuideService.findTravelRecommendGuideByRecommendId(recommendId);
			// 添加操作LOG日志
			try {
				String log =  getProdProductFeatureLog(newTravelRecommendGuide,oldTravelRecommendGuide);
				if(StringUtil.isNotEmptyString(log)){
					comLogService.insert(COM_LOG_OBJECT_TYPE.TRAVEL_RECOMMEND_GUIDE, 
							recommendId, recommendId, 
							this.getLoginUser().getUserName(),
							"修改宝典导语:" + log, 
							COM_LOG_LOG_TYPE.TRAVEL_RECOMMEND_GUIDE_CHANGE.name(), 
							"修改宝典导语",null);
				}

			} catch (Exception e) {
				LOG.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.TRAVEL_RECOMMEND_GUIDE_CHANGE.name());
				LOG.error(e.getMessage());
			}

		}catch (Exception e){
			LOG.error("修改旅游宝典导语失败,宝典ID:"+recommendId);
			return new ResultMessage(ResultMessage.ERROR, "保存失败"); 
		}
		
		return new ResultMessage(ResultMessage.SUCCESS, "保存成功"); 
		
	}
	
	 private String getProdProductFeatureLog(List<TravelRecommendGuide> NewRecommendGuideVoList,List<TravelRecommendGuide> OldRecommendGuideVoList) {
		 StringBuilder ret = new StringBuilder();
		 
		 List<TravelRecommendGuide> imgTypeList = new ArrayList<TravelRecommendGuide>();
		 List<TravelRecommendGuide> guideTypeList = new ArrayList<TravelRecommendGuide>();
		 List<TravelRecommendGuide> visaTypeList = new ArrayList<TravelRecommendGuide>();
		 List<TravelRecommendGuide> currenyTypeList = new ArrayList<TravelRecommendGuide>();
		 List<TravelRecommendGuide> bankcardTypeList = new ArrayList<TravelRecommendGuide>();
		 List<TravelRecommendGuide> medicineTypeList = new ArrayList<TravelRecommendGuide>();
		 List<TravelRecommendGuide> pluginTypeList = new ArrayList<TravelRecommendGuide>();
		 List<TravelRecommendGuide> inhibitionTypeList = new ArrayList<TravelRecommendGuide>();
		 
		 List<TravelRecommendGuide> oldimgTypeList = new ArrayList<TravelRecommendGuide>();
		 List<TravelRecommendGuide> oldguideTypeList = new ArrayList<TravelRecommendGuide>();
		 List<TravelRecommendGuide> oldvisaTypeList = new ArrayList<TravelRecommendGuide>();
		 List<TravelRecommendGuide> oldcurrenyTypeList = new ArrayList<TravelRecommendGuide>();
		 List<TravelRecommendGuide> oldbankcardTypeList = new ArrayList<TravelRecommendGuide>();
		 List<TravelRecommendGuide> oldmedicineTypeList = new ArrayList<TravelRecommendGuide>();
		 List<TravelRecommendGuide> oldpluginTypeList = new ArrayList<TravelRecommendGuide>();
		 List<TravelRecommendGuide> oldinhibitionTypeList = new ArrayList<TravelRecommendGuide>();
		 
		 if(NewRecommendGuideVoList!=null&&NewRecommendGuideVoList.size()>0){
			 for(TravelRecommendGuide recommendGuideVo:NewRecommendGuideVoList){
				 if("IMG".equals(recommendGuideVo.getPropType())){
					 imgTypeList.add(recommendGuideVo);
				 }else if("GUIDE".equals(recommendGuideVo.getPropType())){
					 guideTypeList.add(recommendGuideVo);
				 }else if("VISA".equals(recommendGuideVo.getPropType())){
					 visaTypeList.add(recommendGuideVo);
				 }else if("CURRENCY".equals(recommendGuideVo.getPropType())){
					 currenyTypeList.add(recommendGuideVo);
				 }else if("BANKCARD".equals(recommendGuideVo.getPropType())){
					 bankcardTypeList.add(recommendGuideVo);
				 }else if("MEDICINE".equals(recommendGuideVo.getPropType())){
					 medicineTypeList.add(recommendGuideVo);
				 }else if("PLUGIN".equals(recommendGuideVo.getPropType())){
					 pluginTypeList.add(recommendGuideVo);
				 }else if("INHIBITION".equals(recommendGuideVo.getPropType())){
					 inhibitionTypeList.add(recommendGuideVo);
				 }
			 }
		 }
		 if(OldRecommendGuideVoList!=null&&OldRecommendGuideVoList.size()>0){
			 for(TravelRecommendGuide recommendGuideVo:OldRecommendGuideVoList){
				 if("IMG".equals(recommendGuideVo.getPropType())){
					 oldimgTypeList.add(recommendGuideVo);
				 }else if("GUIDE".equals(recommendGuideVo.getPropType())){
					 oldguideTypeList.add(recommendGuideVo);
				 }else if("VISA".equals(recommendGuideVo.getPropType())){
					 oldvisaTypeList.add(recommendGuideVo);
				 }else if("CURRENCY".equals(recommendGuideVo.getPropType())){
					 oldcurrenyTypeList.add(recommendGuideVo);
				 }else if("BANKCARD".equals(recommendGuideVo.getPropType())){
					 oldbankcardTypeList.add(recommendGuideVo);
				 }else if("MEDICINE".equals(recommendGuideVo.getPropType())){
					 oldmedicineTypeList.add(recommendGuideVo);
				 }else if("PLUGIN".equals(recommendGuideVo.getPropType())){
					 oldpluginTypeList.add(recommendGuideVo);
				 }else if("INHIBITION".equals(recommendGuideVo.getPropType())){
					 oldinhibitionTypeList.add(recommendGuideVo);
				 }
			 }
		 }
		 getRet(ret,imgTypeList,oldimgTypeList);
		 getRet(ret,guideTypeList,oldguideTypeList);
		 getRet(ret,visaTypeList,oldvisaTypeList);
		 getRet(ret,currenyTypeList,oldcurrenyTypeList);
		 getRet(ret,bankcardTypeList,oldbankcardTypeList);
		 getRet(ret,medicineTypeList,oldmedicineTypeList);
		 getRet(ret,pluginTypeList,oldpluginTypeList);
		 getRet(ret,inhibitionTypeList,oldinhibitionTypeList);
		 
		 return ret.toString();
	 }
	 
	 private void getRet(StringBuilder ret,List<TravelRecommendGuide> newlist,List<TravelRecommendGuide> oldlist){
		 
		 if(newlist.size()==oldlist.size() ){
			 if(newlist.size()>0){
				 for(int i=0;i<newlist.size();i++){
					 String PropType =newlist.get(i).getPropType();
					 String ProdValue = newlist.get(i).getPropValue();
					 String newCoverFlag = newlist.get(i).getCoverFlag();
					 String oldCoverFlag = oldlist.get(i).getCoverFlag();
					 String oldPropValue = oldlist.get(i).getPropValue();
					 if(!ProdValue.equals(oldPropValue)){
						 addString(ret,PropType,"修改为'"+ProdValue+"'");
					 }
					 if(!newCoverFlag.equals(oldCoverFlag)){
						 if("Y".equals(newCoverFlag)){
							 addString(ret,PropType,"设置了新封面！");
						 }
					 }
				 } 
			 }
			 
		 }else if(newlist.size()>oldlist.size()){
			 if(oldlist.size()>0){
				 for(int i=0;i<newlist.size();i++){
					 Boolean flag = true;
					 String PropType =newlist.get(i).getPropType();
					 String ProdValue = newlist.get(i).getPropValue();
					 if(oldlist.size()>0){
						 for(TravelRecommendGuide prf:oldlist){
							 if(ProdValue.equals(prf.getPropValue())){
								 flag=false;
								 oldlist.remove(prf) ;
								 break;
							 }
						 } 
					 }
					 if(flag){
						 addString(ret,PropType,"'"+ProdValue+"'");
					 }
				 } 
			 }else{
				 for(TravelRecommendGuide prf:newlist){
					 addString(ret,prf.getPropType(),"新增了'"+prf.getPropValue()+"'"); 
				 }
			 }
		 }else if(newlist.size()<oldlist.size()){
			 if(newlist.size()>0){
				 for(TravelRecommendGuide prf:newlist){
					 Boolean flag = true;
					 String PropType =prf.getPropType();
					 String ProdValue = prf.getPropValue();
					 if(oldlist.size()>0){
						 for(TravelRecommendGuide prf2:oldlist){
							 if(ProdValue.equals(prf2.getPropValue())){
								 flag=false;
								 oldlist.remove(prf2);
								 break;
							 }
						 } 
					 }
					 if(flag){
						 addString(ret,PropType,"'"+ProdValue+"'");
					 }
				 }
				 if(oldlist.size()>0){
					 for(TravelRecommendGuide prf:oldlist){
						 addString(ret,prf.getPropType(),"删除了'"+prf.getPropValue()+"'");
					 }
				 }
				 
			 }else{
				 for(TravelRecommendGuide prf:oldlist){
					 addString(ret,prf.getPropType(),"删除了'"+prf.getPropValue()+"'");
				 }
			 }
		 }
		 
	 }
	 
	 private void addString(StringBuilder ret,String propType,String propValue){
		 if("GUIDE".equals(propType)){
			 ret.append(" 导语正文变更："+propValue);
		 }else if("VISA".equals(propType)){
			 ret.append(" 行前准备-->签证变更："+propValue);
		 }else if("CURRENCY".equals(propType)){
			 ret.append(" 行前准备-->货币正文变更："+propValue);
		 }else if("BANKCARD".equals(propType)){
			 ret.append(" 行前准备-->银行卡变更："+propValue);
		 }else if("MEDICINE".equals(propType)){
			 ret.append(" 行前准备-->药品变更："+propValue);
		 }else if("PLUGIN".equals(propType)){
			 ret.append(" 行前准备-->电源插头变更："+propValue);
		 }else if("INHIBITION".equals(propType)){
			 ret.append(" 行前准备-->禁忌变更："+propValue);
		 }else if("IMG".equals(propType)){
			 ret.append(" 图片变更："+propValue);
		 }
	 }
	 
	 @RequestMapping(value = "/testTravelRecommendGuide")
		public String test(Model model, long recommendId,HttpServletRequest req) {
			
		    recommendId=12345l;
			List<TravelRecommendGuide> travelRecommendGuidelist=new ArrayList<TravelRecommendGuide>();
			TravelRecommendGuide t1=new TravelRecommendGuide();
			TravelRecommendGuide t2=new TravelRecommendGuide();
			
			
			t1.setRecommendId(recommendId);
			t1.setPropType("IMG");
			t1.setPropValue("www.baidu.com");
			t1.setCoverFlag("Y");
			t1.setPropSort(1l);
			
			
			t2.setRecommendId(recommendId);
			t2.setPropType("IMG");
			t2.setPropValue("www.baidu.com2");
			t2.setCoverFlag("N");
			t2.setPropSort(2l);
			travelRecommendGuidelist.add(t1);
			travelRecommendGuidelist.add(t2);
		 	/*TravelRecommendTrafficRule travelRecommendTrafficRule=new TravelRecommendTrafficRule();
		 	travelRecommendTrafficRule.setAirCompanyFlag("Y");
		 	travelRecommendTrafficRule.setTrafficType("FIRST");
		 	travelRecommendTrafficRule.setRecommendId(12345l);
		 	travelRecommendTrafficRule.setBackStartMaxtime("14:25");
		 	travelRecommendTrafficRule.setStopFlag("N");*/
			try {
				travelRecommendGuideService.saveTravelRecommendGuide(recommendId, travelRecommendGuidelist);
				
				//travelRecommendTrafficRuleService.insertTravelRecommendTrafficRule(travelRecommendTrafficRule);
			} catch (Exception e) {
				System.out.print(e);
			}
			return "superfreetour/showProductMaintain";
		}
}
