/**
 * 
 */
package com.lvmama.vst.back.goods.web.ticket;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.pub.service.PushAdapterService;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizOrderRequired;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.goods.vo.SuppGoodsParam;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.pub.po.ComOrderRequired;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.pub.service.ComOrderRequiredClientService;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.back.utils.MiscUtils;

/**
 * @author qiujiehong
 *@date 2014-06-26
 */
@Controller
@RequestMapping("/ticket/goods/reservationLimit")
public class TicketReservationLimitAction extends BaseActionSupport {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -81189271841215004L;

	private static final Log LOG = LogFactory.getLog(TicketReservationLimitAction.class);
	
	@Autowired
	private ComOrderRequiredClientService comOrderRequiredService;
	
	@Autowired
	private ComLogClientService comLogService;
	
	@Autowired
	private SuppGoodsClientService suppGoodsService;

	@Autowired
	private PushAdapterService pushAdapterService;
	
	@RequestMapping(value = "/showGoodsReservationLimit.do")
	public String showGoodsReservationLimit(Model model, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showGoodsReservationLimit>");
		}
		if (req.getParameter("suppGoodsId") != null) {
			Map<String, Object> parameters = new HashMap<String, Object>();
			parameters.put("objectType", ComOrderRequired.OBJECTTYPE.SUPP_GOODS.name());
			parameters.put("objectId", req.getParameter("suppGoodsId"));
			List<ComOrderRequired> comOrderRequiredList = comOrderRequiredService.findComOrderRequiredList(parameters);
			if(comOrderRequiredList!=null && comOrderRequiredList.size()>0){
				model.addAttribute("comOrderRequired", comOrderRequiredList.get(0));
			}
			if("11".equals(req.getParameter("categoryId"))){
				SuppGoods suppGoods =MiscUtils.autoUnboxing( suppGoodsService.findSuppGoodsById(Long.parseLong(req.getParameter("suppGoodsId"))));
				String goodsSpec = suppGoods.getGoodsSpec();
				model.addAttribute("goodsSpec", goodsSpec);
			}
			model.addAttribute("travNumTypeList", BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.all());
			model.addAttribute("suppGoodsId", req.getParameter("suppGoodsId"));
			model.addAttribute("categoryId", req.getParameter("categoryId"));
			
		}
		return "/goods/ticket/goods/showGoodsReservationLimit";
	}
	
	@RequestMapping(value = "/addReservationLimit.do")
	@ResponseBody
	public Object addReservationLimit(Model model, HttpServletRequest req, ComOrderRequired comOrderRequired) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<addReservationLimit>");
		}
		comOrderRequired.setObjectType(ComOrderRequired.OBJECTTYPE.SUPP_GOODS.name());
		comOrderRequiredService.saveComOrderRequired(comOrderRequired);
		
		//获取商品时间价格变更日志内容
		SuppGoodsParam param = new SuppGoodsParam();
		param.setProduct(true);
		SuppGoods suppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(comOrderRequired.getObjectId(), param));
		
		//添加操作日志
		try {
            //文字变更日期20151113
			comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS,
					comOrderRequired.getObjectId(), comOrderRequired.getObjectId(), 
					this.getLoginUser().getUserName(),  
					"添加了商品下单必填项：【"+suppGoods.getGoodsName()+"】",
					COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(), 
					"新增商品下单必填项",null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
			log.error(e.getMessage());
			return new ResultMessage(ResultMessage.ERROR, "添加日志失败!");
		}	
			
		return ResultMessage.ADD_SUCCESS_RESULT;
	}
	
	@RequestMapping(value = "/updateReservationLimit.do")
	@ResponseBody
	public Object updateReservationLimit(Model model, HttpServletRequest req, ComOrderRequired comOrderRequired) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<updateReservationLimit>");
		}
		try{
			ComOrderRequired oldcomOrderRequired = comOrderRequiredService.findComOrderRequiredById(comOrderRequired.getReqId());
			if(BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.TRAV_NUM_NO.name().equals(comOrderRequired.getCredType())){
				comOrderRequired.setIdFlag("N");
				comOrderRequired.setTwPassFlag("N");
				comOrderRequired.setPassFlag("N");
				comOrderRequired.setPassportFlag("N");
				comOrderRequired.setTwResidentFlag("N");
				comOrderRequired.setBirthCertFlag("N");
				comOrderRequired.setHouseholdRegFlag("N");
				comOrderRequired.setHkResidentFlag("N");
				comOrderRequired.setOfficerFlag("N");
				comOrderRequired.setSoldierFlag("N");
			}
			if(BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.TRAV_NUM_NO.name().equals(comOrderRequired.getNeedGuideFlag())){
				comOrderRequired.setGuideNameType(BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.TRAV_NUM_NO.name());
				comOrderRequired.setGuideNoType(BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.TRAV_NUM_NO.name());
				comOrderRequired.setGuidePhoneType(BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.TRAV_NUM_NO.name());
				comOrderRequired.setGuideIdType(BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.TRAV_NUM_NO.name());
			}
			if(comOrderRequired.getGuideIdType()==null){
				comOrderRequired.setGuideIdType(BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.TRAV_NUM_NO.name());				
			}
			if(comOrderRequired.getGuideNoType()==null){
				comOrderRequired.setGuideNoType(BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.TRAV_NUM_NO.name());				
			}
			comOrderRequiredService.updateConOrderRequired(comOrderRequired);	
			
			//获取商品时间价格变更日志内容
			SuppGoodsParam param = new SuppGoodsParam();
			param.setProduct(true);
			SuppGoods suppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(comOrderRequired.getObjectId(), param));
			log.info("goodsId: " + suppGoods.getSuppGoodsId() + "updateReservationLimit通知分销开始了");
			// 发送下单必填项更新消息通知分销
			pushAdapterService.push(suppGoods.getSuppGoodsId(), ComPush.OBJECT_TYPE.GOODS, ComPush.PUSH_CONTENT.FX_SUPPGOODS_ORDER_REQUIRED, ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
			log.info("goodsId: " + suppGoods.getSuppGoodsId() + "updateReservationLimit通知分销结束了");
			//获取商品变更日志内容 
			String logContent = "";
			logContent = getReservationLimitLog(comOrderRequired,oldcomOrderRequired);
			if(null!=logContent && !"".equals(logContent))
			{
			//添加操作日志
				try {
                    //文字变更日期20151113
					comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
					suppGoods.getProdProduct().getProductId(), comOrderRequired.getObjectId(), 
					this.getLoginUser().getUserName(),   
					"修改了商品下单必填项：【"+suppGoods.getGoodsName()+"】,变更内容："+logContent,
					COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(), 
					"修改商品下单必填项",null);
				} catch (Exception e) {
					log.error(ExceptionFormatUtil.getTrace(e));
					log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
					log.error(e.getMessage());
				}	
			}	
			
		} catch (Exception e) {
			log.error(e.getMessage());
			return ResultMessage.SYS_ERROR;
		}	
		
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}
	
	/**
	 * 构造加价预定限制日志
	 * @param suppGoodsAddTimePrice 修改后的时间价格信息
	 * @param oldSuppGoodsAddTimePrice 修改前时间价格信息
	 * @return
	 */
	private String getReservationLimitLog(ComOrderRequired comOrderRequired,ComOrderRequired oldComOrderRequired){
		 StringBuffer logStr = new StringBuffer("");
		 //修改
		 if(null== oldComOrderRequired){
			 logStr.append(ComLogUtil.getLogTxt("1笔订单需要的“游玩人/取票人”数量",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getTravNumType()),null));
			 logStr.append(ComLogUtil.getLogTxt("英文姓名",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getEnnameType()),null));
			 logStr.append(ComLogUtil.getLogTxt("人群",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getOccupType()),null));
			 logStr.append(ComLogUtil.getLogTxt("手机号",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getPhoneType()),null));
			 logStr.append(ComLogUtil.getLogTxt("email",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getEmailType()),null));
			 logStr.append(ComLogUtil.getLogTxt("证件",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getCredType()),null));
			 logStr.append(ComLogUtil.getLogTxt("身份证",String.valueOf("Y".equals(comOrderRequired.getIdFlag()) ? "可用" : "不可用"),null));
			 logStr.append(ComLogUtil.getLogTxt("护照",String.valueOf("Y".equals(comOrderRequired.getPassportFlag()) ? "可用" : "不可用"),null));
			 logStr.append(ComLogUtil.getLogTxt("通行证",String.valueOf("Y".equals(comOrderRequired.getPassFlag()) ? "可用" : "不可用"),null));
			 logStr.append(ComLogUtil.getLogTxt("是否需要导游信息",String.valueOf("Y".equals(comOrderRequired.getNeedGuideFlag()) ? "需要" : "不需要"),null));
			 logStr.append(ComLogUtil.getLogTxt("导游证号",String.valueOf("Y".equals(comOrderRequired.getGuideNoType()) ? "需要" : "不需要"),null));
			 logStr.append(ComLogUtil.getLogTxt("导游身份证证号",String.valueOf("Y".equals(comOrderRequired.getGuideIdType()) ? "需要" : "不需要"),null));
			 
			 logStr.append(ComLogUtil.getLogTxt("是否需要导游信息",String.valueOf("NEED".equals(comOrderRequired.getNeedGuideFlag()) ? "需要" : "不需要"),null));
			 logStr.append(ComLogUtil.getLogTxt("导游证号",String.valueOf("NEED".equals(comOrderRequired.getGuideNoType()) ? "需要" : "不需要"),null));
			 logStr.append(ComLogUtil.getLogTxt("导游身份证证号",String.valueOf("NEED".equals(comOrderRequired.getGuideIdType()) ? "需要" : "不需要"),null));
		 }else{
			 //新增	 
			 logStr.append(ComLogUtil.getLogTxt("1笔订单需要的“游玩人/取票人”数量",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getTravNumType()),BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(oldComOrderRequired.getTravNumType())));
			 logStr.append(ComLogUtil.getLogTxt("英文姓名",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getEnnameType()),BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(oldComOrderRequired.getEnnameType())));
			 logStr.append(ComLogUtil.getLogTxt("人群",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getOccupType()),BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(oldComOrderRequired.getOccupType())));
			 logStr.append(ComLogUtil.getLogTxt("手机号",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getPhoneType()),BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(oldComOrderRequired.getPhoneType())));
			 logStr.append(ComLogUtil.getLogTxt("email",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getEmailType()),BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(oldComOrderRequired.getEmailType())));
			 logStr.append(ComLogUtil.getLogTxt("证件",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getCredType()),BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(oldComOrderRequired.getCredType())));
			 logStr.append(ComLogUtil.getLogTxt("身份证",String.valueOf("Y".equals(comOrderRequired.getIdFlag()) ? "可用" : "不可用"),String.valueOf("Y".equals(oldComOrderRequired.getIdFlag()) ? "可用" : "不可用")));
			 logStr.append(ComLogUtil.getLogTxt("护照",String.valueOf("Y".equals(comOrderRequired.getPassportFlag()) ? "可用" : "不可用"),String.valueOf("Y".equals(oldComOrderRequired.getPassportFlag()) ? "可用" : "不可用")));
			 logStr.append(ComLogUtil.getLogTxt("通行证",String.valueOf("Y".equals(comOrderRequired.getPassFlag()) ? "可用" : "不可用"),String.valueOf("Y".equals(oldComOrderRequired.getPassFlag()) ? "可用" : "不可用")));	
			 
			 logStr.append(ComLogUtil.getLogTxt("是否需要导游信息",String.valueOf("NEED".equals(comOrderRequired.getNeedGuideFlag()) ? "需要" : "不需要"),String.valueOf("NEED".equals(oldComOrderRequired.getNeedGuideFlag()) ? "需要" : "不需要")));	
			 logStr.append(ComLogUtil.getLogTxt("导游证号",String.valueOf("NEED".equals(comOrderRequired.getGuideNoType()) ? "需要" : "不需要"),String.valueOf("NEED".equals(oldComOrderRequired.getGuideNoType()) ? "需要" : "不需要")));	
			 logStr.append(ComLogUtil.getLogTxt("导游身份证证号",String.valueOf("NEED".equals(comOrderRequired.getGuideIdType()) ? "需要" : "不需要"),String.valueOf("NEED".equals(oldComOrderRequired.getGuideIdType()) ? "需要" : "不需要")));	
		 }
		 return logStr.toString();
	 }	
}
