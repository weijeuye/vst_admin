/**
 * 
 */
package com.lvmama.vst.back.visa.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lvmama.vst.comlog.LvmmLogClientService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizDictExtend;
import com.lvmama.vst.back.biz.po.BizDistrict;
import com.lvmama.vst.back.biz.po.BizVisaDetailTemplate;
import com.lvmama.vst.back.biz.po.BizVisaDoc;
import com.lvmama.vst.back.biz.po.BizVisaDocDetail;
import com.lvmama.vst.back.biz.po.BizVisaDocOccup;
import com.lvmama.vst.back.biz.service.DictService;
import com.lvmama.vst.back.client.biz.service.DistrictClientService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.back.visa.service.VisaDocService;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.json.JSONOutput;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;

/**
 * @author pengyayun
 *
 */
@Controller
@RequestMapping("/visa/visaDoc")
public class VisaDocAction extends BaseActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = -5488331407117825990L;

	private static final Log LOG = LogFactory.getLog(VisaDocAction.class);
	
	@Autowired
	private VisaDocService visaDocService;
	
	@Autowired
	private DictService dictService;
	
	@Autowired
	private DistrictClientService districtService;

	@Autowired
	private LvmmLogClientService lvmmLogClientService;

	@Autowired
	private com.lvmama.visa.api.service.VisaDocService visaDocServiceRemote;

	/**
	 * 
	 * 跳转到签证审核页面
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/findBizVisaDocList")
	public String findBizVisaDocList(Integer page, HttpServletRequest req, Model model, BizVisaDoc bizVisaDoc) throws BusinessException {
		try {
			Map<String, Object> paramBizVisaDoc = new HashMap<String, Object>();
			if(StringUtils.isNotBlank(bizVisaDoc.getCancelFlag())){
				paramBizVisaDoc.put("cancelFlag", bizVisaDoc.getCancelFlag());
			}
			if(StringUtils.isNotBlank(bizVisaDoc.getCity())){
				paramBizVisaDoc.put("city", bizVisaDoc.getCity());
			}
			if(StringUtils.isNotBlank(bizVisaDoc.getCountry())){
				paramBizVisaDoc.put("country", bizVisaDoc.getCountry());
			}
			if(StringUtils.isNotBlank(bizVisaDoc.getVisaType())){
				paramBizVisaDoc.put("visaType", bizVisaDoc.getVisaType());
			}
			if(bizVisaDoc.getDocId()!=null){
				paramBizVisaDoc.put("docId", bizVisaDoc.getDocId());
			}
			if(StringUtils.isNotBlank(bizVisaDoc.getDocName())){
				paramBizVisaDoc.put("docName", bizVisaDoc.getDocName());
			}

			int count = visaDocService.findBizVisaDocCount(paramBizVisaDoc);

			int pagenum = page == null ? 1 : page;
			Page pageParam = Page.page(count, 10, pagenum);
			pageParam.buildUrl(req);
			paramBizVisaDoc.put("_start", pageParam.getStartRows());
			paramBizVisaDoc.put("_end", pageParam.getEndRows());
			paramBizVisaDoc.put("_orderby", "DOC_ID");
			paramBizVisaDoc.put("_order", "DESC");

			List<BizVisaDoc> list=visaDocService.findBizVisaDoc(paramBizVisaDoc);
			pageParam.setItems(list);
			model.addAttribute("pageParam", pageParam);

			//查询签证类型\送签城市字典
			Map<String, Object> params1 = new HashMap<String, Object>();
			params1.put("dictCode", "VISA_TYPE");
			List<BizDictExtend> vistTypeList = dictService.findBizDictExtendList(params1);
			Map<String, Object> params2 = new HashMap<String, Object>();
			params2.put("dictCode", "VISA_CITY");
			List<BizDictExtend> vistCityList = dictService.findBizDictExtendList(params2);
			model.addAttribute("vistTypeList", vistTypeList);
			model.addAttribute("vistCityList", vistCityList);
		} catch (Exception e) {
			log.error(e);
		}
	
		return "/prod/visa/document/findBizVisaDocList";
	}
	
	
	/**
	 * 
	 * 跳转到签证审核页面
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/selectBizVisaDocList")
	public String selectBizVisaDocList(Integer page, HttpServletRequest req, Model model, BizVisaDoc bizVisaDoc) throws BusinessException {
		try {
			
			Map<String, Object> paramBizVisaDoc = new HashMap<String, Object>();
			if(StringUtils.isNotBlank(bizVisaDoc.getCancelFlag())){
				paramBizVisaDoc.put("cancelFlag", bizVisaDoc.getCancelFlag());
			}
			if(StringUtils.isNotBlank(bizVisaDoc.getCity())){
				paramBizVisaDoc.put("city", bizVisaDoc.getCity());
			}
			if(StringUtils.isNotBlank(bizVisaDoc.getCountry())){
				paramBizVisaDoc.put("country", bizVisaDoc.getCountry());
			}
			if(StringUtils.isNotBlank(bizVisaDoc.getVisaType())){
				paramBizVisaDoc.put("visaType", bizVisaDoc.getVisaType());
			}
			if(bizVisaDoc.getDocId()!=null){
				paramBizVisaDoc.put("docId", bizVisaDoc.getDocId());
			}
			if(StringUtils.isNotBlank(bizVisaDoc.getDocName())){
				paramBizVisaDoc.put("docName", bizVisaDoc.getDocName());
			}

			paramBizVisaDoc.put("cancelFlag", "Y");
			//改成visa远程调用
			int count = visaDocServiceRemote.findBizVisaDocCountValid(paramBizVisaDoc).getReturnContent();

			int pagenum = page == null ? 1 : page;
			Page pageParam = Page.page(count, 10, pagenum);
			pageParam.buildUrl(req);
			paramBizVisaDoc.put("_start", pageParam.getStartRowsMySql());
			paramBizVisaDoc.put("_end", pageParam.getPageSize());
			paramBizVisaDoc.put("_orderby", "DOC_ID");
			paramBizVisaDoc.put("_order", "DESC");
			
			//改成visa远程调用
			List<com.lvmama.visa.api.vo.doc.VisaDoc> list=visaDocServiceRemote.findBizVisaDocValid(paramBizVisaDoc).getReturnContent();

			pageParam.setItems(list);
			model.addAttribute("pageParam", pageParam);
			
			//查询签证类型\送签城市字典
			Map<String, Object> params1 = new HashMap<String, Object>();
			params1.put("dictCode", "VISA_TYPE");
			List<BizDictExtend> vistTypeList = dictService.findBizDictExtendList(params1);
			Map<String, Object> params2 = new HashMap<String, Object>();
			params2.put("dictCode", "VISA_CITY");
			List<BizDictExtend> vistCityList = dictService.findBizDictExtendList(params2);
			model.addAttribute("vistTypeList", vistTypeList);
			model.addAttribute("vistCityList", vistCityList);
	 } catch (Exception e) {
			log.error(e);
	}
	
		return "/prod/visa/document/selectBizVisaDocList";
	}
	
	
	
	
	
	/**
	 * 跳转到 新增更新签证材料页面
	 * @param request
	 * @param model
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/showBizVisaDoc.do")
	public String showBizVisaDoc(HttpServletRequest request, BizVisaDoc bizVisaDoc, Model model) throws BusinessException {
		if(bizVisaDoc!=null && bizVisaDoc.getDocId()!=null){
			BizVisaDoc result = visaDocService.queryBizVisaDocById(bizVisaDoc.getDocId());
			model.addAttribute("bizVisaDoc", result);
		}
		//查询签证类型\送签城市字典
		Map<String, Object> params1 = new HashMap<String, Object>();
		params1.put("dictCode", "VISA_TYPE");
		List<BizDictExtend> vistTypeList = dictService.findBizDictExtendList(params1);
		Map<String, Object> params2 = new HashMap<String, Object>();
		params2.put("dictCode", "VISA_CITY");
		List<BizDictExtend> vistCityList = dictService.findBizDictExtendList(params2);
		model.addAttribute("vistTypeList", vistTypeList);
		model.addAttribute("vistCityList", vistCityList);
		return "/prod/visa/document/showBizVisaDoc";
	}
	
	/**
	 * 跳转到 新增更新签证材料页面
	 * @param request
	 * @param model
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/updateBizVisaDoc.do")
	@ResponseBody
	public Object updateBizVisaDoc(HttpServletRequest request, BizVisaDoc bizVisaDoc, Model model) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<updateBizVisaDoc>");
		}
		try {
			if (bizVisaDoc.getDocId()!=null) {
				BizVisaDoc oldBizVisaDoc = visaDocService.queryBizVisaDocById(bizVisaDoc.getDocId());
				bizVisaDoc.setCity(oldBizVisaDoc.getCity());
				bizVisaDoc.setCountry(oldBizVisaDoc.getCountry());
				bizVisaDoc.setVisaType(oldBizVisaDoc.getVisaType());
				bizVisaDoc.setCancelFlag(oldBizVisaDoc.getCancelFlag());
				visaDocService.updateBizVisaDoc(bizVisaDoc);
				
				String logContent = "";
				logContent = getBizVisaDocChangeLog(bizVisaDoc,oldBizVisaDoc);
				if(null != logContent && !"".equals(logContent))
				{
					//添加操作日志
					try {

						lvmmLogClientService.sendLog(COM_LOG_OBJECT_TYPE.VISA_DOCUMNET,
								bizVisaDoc.getDocId(), bizVisaDoc.getDocId(), 
								this.getLoginUser().getUserName(),    
								"修改了签证材料：【"+bizVisaDoc.getDocName()+"】修改内容："+logContent, 
								COM_LOG_LOG_TYPE.VISA_DOCUMNET_CHANGE.name(), 
								"设置签证材料",null);

					} catch (Exception e) {
						LOG.error(ExceptionFormatUtil.getTrace(e));
					}	
				}
				
				return new ResultMessage("success", "修改成功");
			}else{
				bizVisaDoc.setCancelFlag("Y");
				visaDocService.addBizVisaDoc(bizVisaDoc);
				
				String logContent = "";
				logContent = getBizVisaDocChangeLog(bizVisaDoc,null);
				if(null != logContent && !"".equals(logContent))
				{
					//添加操作日志
					try {
						lvmmLogClientService.sendLog(COM_LOG_OBJECT_TYPE.VISA_DOCUMNET,
								bizVisaDoc.getDocId(), bizVisaDoc.getDocId(), 
								this.getLoginUser().getUserName(),    
								"新增签证材料：【"+bizVisaDoc.getDocName()+"】修改内容："+logContent, 
								COM_LOG_LOG_TYPE.VISA_DOCUMNET_CHANGE.name(), 
								"设置签证材料",null);
					} catch (Exception e) {
						LOG.error(ExceptionFormatUtil.getTrace(e));
					}	
				}
				return new ResultMessage("success", "保存成功");
			}
		} catch (Exception e) {;
			LOG.error(ExceptionFormatUtil.getTrace(e));
		}
		if (LOG.isDebugEnabled()) {
			LOG.debug("end method<updateBizVisaDoc>");
		}
		return new ResultMessage("error", "保存失败");
	}

	/**
	 * 设置产品的有效性
	 * 
	 * @return
	 */
	@RequestMapping(value = "/cancelBizVisaDoc")
	@ResponseBody
	public Object cancelBizVisaDoc(BizVisaDoc bizVisaDoc) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<bizVisaDoc>");
		}
		
		if ((bizVisaDoc != null) && "Y".equals(bizVisaDoc.getCancelFlag())) {
			bizVisaDoc.setCancelFlag("Y");
		} else if ((bizVisaDoc != null) && "N".equals(bizVisaDoc.getCancelFlag())) {
			bizVisaDoc.setCancelFlag("N");
		} else {
			return new ResultMessage("error", "设置失败,无效参数");
		}

		int result = visaDocService.updateCancelFlag(bizVisaDoc);
		
		if(result>0){
			//添加操作日志
			bizVisaDoc = visaDocService.queryBizVisaDocById(bizVisaDoc.getDocId());
			
			try {
				String key ="";
				if("Y".equals(bizVisaDoc.getCancelFlag())){
					key = "有效";
				}else {
					key = "无效";
				}
				lvmmLogClientService.sendLog(COM_LOG_OBJECT_TYPE.VISA_DOCUMNET,
						bizVisaDoc.getDocId(), bizVisaDoc.getDocId(), 
						this.getLoginUser().getUserName(),   
						"修改了签证材料：【"+bizVisaDoc.getDocName()+"】的有效性为："+key, 
						COM_LOG_LOG_TYPE.VISA_DOCUMNET_STATUS.name(), 
						"设置签证材料的有效性",null);
			} catch (Exception e) {
				log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.VISA_DOCUMNET_STATUS.name());
				log.error(e.getMessage());
			}
		}else{
			return new ResultMessage("error", "设置失败");
		}
		
		
		
		return ResultMessage.SET_SUCCESS_RESULT;
	}
	
	/**
	 * 跳转到添加签证材料页面
	 * @param request
	 * @param promotionId
	 * @param model
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/showBizVisaDocOccup.do")
	public String showBizVisaDocOccup(Long docId,Model model) throws BusinessException {
		if(null==docId){
			throw new IllegalArgumentException("签证材料ID为空！");
		}
		BizVisaDoc bizVisaDoc = visaDocService.queryBizVisaDocById(docId);
		model.addAttribute("bizVisaDoc", bizVisaDoc);
		if(bizVisaDoc!=null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("docId", bizVisaDoc.getDocId());
			List<BizVisaDocOccup> bizVisaDocOccupList = visaDocService.findBizVisaDocOccup(params);
			model.addAttribute("bizVisaDocOccupList", bizVisaDocOccupList);
		}
		model.addAttribute("docId", docId);
		//查询签证类型\送签城市字典
		Map<String, Object> params1 = new HashMap<String, Object>();
		params1.put("dictCode", "VISA_TYPE");
		List<BizDictExtend> vistTypeList = dictService.findBizDictExtendList(params1);
		Map<String, Object> params2 = new HashMap<String, Object>();
		params2.put("dictCode", "VISA_CITY");
		List<BizDictExtend> vistCityList = dictService.findBizDictExtendList(params2);
		model.addAttribute("vistTypeList", vistTypeList);
		model.addAttribute("vistCityList", vistCityList);
		model.addAttribute("occupTypeList", BizVisaDocOccup.OCCUP_TYPE.values());
		return "/prod/visa/document/showBizVisaDocOccup";
	}
	
	/**
	 * 跳转到添加签证材料页面
	 * @param request
	 * @param promotionId
	 * @param model
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/showAddBizVisaDocOccup.do")
	public String showAddBizVisaDocOccup(Long docId, Long occupId, Model model) throws BusinessException {
		if(null==docId){
			throw new IllegalArgumentException("签证材料ID为空！");
		}
		model.addAttribute("docId", docId);
		model.addAttribute("occupId", occupId);
		model.addAttribute("occupTypeList", BizVisaDocOccup.OCCUP_TYPE.values());
		return "/prod/visa/document/inc/addBizVisaDocOccup";
	}
	
	
	/**
	 * 保存签证材料人群
	 * @param prodVisaDocument
	 * @param model
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/saveBizVisaDocOccup.do")
	@ResponseBody
	public Object saveBizVisaDocOccup(BizVisaDocOccup bizVisaDocOccup,Model model) throws BusinessException {
		 try {
			 // 验证同一签证材料下不能重复设置同种人群
			 if(bizVisaDocOccup.getDocId()!=null){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("docId", bizVisaDocOccup.getDocId());
				params.put("occupType", bizVisaDocOccup.getOccupType());
				List<BizVisaDocOccup> bizVisaDocOccupList = visaDocService.findBizVisaDocOccup(params);
				if(bizVisaDocOccupList!=null && bizVisaDocOccupList.size()>0){
					return new ResultMessage("error", "同一签证材料下不能重复设置同种人群");
				}
			 }
			 
			if(bizVisaDocOccup.getDocId()!=null){
			 	//保存
				if(bizVisaDocOccup.getOccupId()!=null){
				//copy签证材料
					BizVisaDocOccup copyBizVisaDocOccup = visaDocService.queryBizVisaDocOccupById(bizVisaDocOccup.getOccupId());
					Map<String, Object> paramsBizVisaDocDetail = new HashMap<String, Object>();
					paramsBizVisaDocDetail.put("docId", copyBizVisaDocOccup.getDocId());
					paramsBizVisaDocDetail.put("occupId", copyBizVisaDocOccup.getOccupId());
					List<BizVisaDocDetail> copyBizVisaDocDetailList = visaDocService.findBizVisaDocDetail(paramsBizVisaDocDetail);
					//新签证材料人群关联
					copyBizVisaDocOccup.setOccupId(null);
					copyBizVisaDocOccup.setOccupType(bizVisaDocOccup.getOccupType());
					Long newOccupId = visaDocService.addBizVisaDocOccup(copyBizVisaDocOccup);
					//添加操作日志
					 try {
						lvmmLogClientService.sendLog(COM_LOG_OBJECT_TYPE.VISA_DOCUMNET,
								bizVisaDocOccup.getDocId(), bizVisaDocOccup.getDocId(), 
								this.getLoginUser().getUserName(),   
								"复制签证材料人群：【"+BizVisaDocOccup.OCCUP_TYPE.getCnName(bizVisaDocOccup.getOccupType())+"】", 
								COM_LOG_LOG_TYPE.VISA_DOCUMNET_CHANGE.name(), 
								"复制签证材料人群",null);
					} catch (Exception e) {
						log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.VISA_DOCUMNET_CHANGE.name());
						log.error(e.getMessage());
					}
					
					
					//新签证材料明细
					for (BizVisaDocDetail copyBizVisaDocDetail : copyBizVisaDocDetailList) {
						copyBizVisaDocDetail.setDetailId(null);
						copyBizVisaDocDetail.setOccupId(newOccupId);
						Long newBizVisaDocDetailId = visaDocService.addBizVisaDocDetail(copyBizVisaDocDetail);
						
						try {
					 		lvmmLogClientService.sendLog(
					 						COM_LOG_OBJECT_TYPE.VISA_DOCUMNET_DETAIL,
											bizVisaDocOccup.getDocId(), newOccupId,
											this.getLoginUser().getUserName(),
											"复制了签证材料明细：【"+copyBizVisaDocDetail.getTitle()+"】",
											COM_LOG_LOG_TYPE.VISA_DOCUMNET_CHANGE.name(),
											"复制签证材料明细",null);
					 	} catch (Exception e) {
							log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.VISA_DOCUMNET_CHANGE.name());
							log.error(e.getMessage());
						}
						
						
						//新签证材料明细模板
						if(copyBizVisaDocDetail.getBizVisaDetailTemplateList()!=null && copyBizVisaDocDetail.getBizVisaDetailTemplateList().size()>0){
							for (BizVisaDetailTemplate copyBizVisaDetailTemplate : copyBizVisaDocDetail.getBizVisaDetailTemplateList()) {
								copyBizVisaDetailTemplate.setTemplateId(null);
								copyBizVisaDetailTemplate.setDetailId(newBizVisaDocDetailId);
								visaDocService.addBizVisaDetailTemplate(copyBizVisaDetailTemplate);
								
								//添加操作日志
								 try {
									lvmmLogClientService.sendLog(COM_LOG_OBJECT_TYPE.VISA_DOCUMNET_DETAIL,
											bizVisaDocOccup.getDocId(), newOccupId, 
											this.getLoginUser().getUserName(),   
											"复制签证材料明细【"+copyBizVisaDocDetail.getTitle()+"】下模板【"+copyBizVisaDetailTemplate.getTemplateName()+"】", 
											COM_LOG_LOG_TYPE.VISA_DOCUMNET_CHANGE.name(), 
											"复制签证材料模板",null);
								} catch (Exception e) {
									log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.VISA_DOCUMNET_CHANGE.name());
									log.error(e.getMessage());
								}
							}
						}
					}
					
					
				}else{
					visaDocService.addBizVisaDocOccup(bizVisaDocOccup);
					//添加操作日志
					 try {
						lvmmLogClientService.sendLog(COM_LOG_OBJECT_TYPE.VISA_DOCUMNET,
								bizVisaDocOccup.getDocId(), bizVisaDocOccup.getDocId(), 
								this.getLoginUser().getUserName(),   
								"添加签证材料人群：【"+BizVisaDocOccup.OCCUP_TYPE.getCnName(bizVisaDocOccup.getOccupType())+"】", 
								COM_LOG_LOG_TYPE.VISA_DOCUMNET_CHANGE.name(), 
								"添加签证材料人群",null);
					} catch (Exception e) {
						log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.VISA_DOCUMNET_CHANGE.name());
						log.error(e.getMessage());
					}
				}
		 	}
		} catch (Exception e) {
			LOG.error(ExceptionFormatUtil.getTrace(e));
		}
		 return ResultMessage.SET_SUCCESS_RESULT;
	}

	/**
	 * 跳转到 签证材料明细页面
	 * @param request
	 * @param productId
	 * @param model
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/showBizVisaDocDetail.do")
	public String showBizVisaDocDetail(HttpServletRequest request,BizVisaDocDetail bizVisaDocDetail,Model model) throws BusinessException {
		 
		try {
				//根据产品Id查找 签证材料信息
				Map<String, Object> params=new HashMap<String, Object>();
				params.put("docId", bizVisaDocDetail.getDocId());
				
				params.put("occupId", bizVisaDocDetail.getOccupId());
				List<BizVisaDocDetail> bizVisaDocDetailList=visaDocService.findBizVisaDocDetail(params);
				BizVisaDoc bizVisaDoc = visaDocService.queryBizVisaDocById(bizVisaDocDetail.getDocId());
				BizVisaDocOccup bizVisaDocOccup = visaDocService.queryBizVisaDocOccupById(bizVisaDocDetail.getOccupId());
				
				model.addAttribute("bizVisaDoc", bizVisaDoc);
				model.addAttribute("bizVisaDocOccup", bizVisaDocOccup);
				model.addAttribute("bizVisaDocDetailList", bizVisaDocDetailList);
				
				//查询签证类型\送签城市字典
				Map<String, Object> params1 = new HashMap<String, Object>();
				params1.put("dictCode", "VISA_TYPE");
				List<BizDictExtend> vistTypeList = dictService.findBizDictExtendList(params1);
				Map<String, Object> params2 = new HashMap<String, Object>();
				params2.put("dictCode", "VISA_CITY");
				List<BizDictExtend> vistCityList = dictService.findBizDictExtendList(params2);
				model.addAttribute("vistTypeList", vistTypeList);
				model.addAttribute("vistCityList", vistCityList);
				model.addAttribute("occupTypeList", BizVisaDocOccup.OCCUP_TYPE.values());
		 } catch (Exception e) {
				// TODO: handle exception
				log.error(e);
		}
		
		return "/prod/visa/document/showBizVisaDocDetail";
	}	
	
	/**
	 * 保存签证材料明细信息
	 * @param prodVisaDocumentDetail
	 * @param model
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/saveBizVisaDocDetail.do")
	@ResponseBody
	public Object saveBizVisaDocDetail(BizVisaDocDetail bizVisaDocDetail, Model model) throws BusinessException {
		 try {
			 	if(bizVisaDocDetail.getDetailId()==null){
				 	//保存
				 	Long detailId=visaDocService.addBizVisaDocDetail(bizVisaDocDetail);
				 	try {
				 		lvmmLogClientService.sendLog(
				 						COM_LOG_OBJECT_TYPE.VISA_DOCUMNET_DETAIL,
										bizVisaDocDetail.getDocId(), bizVisaDocDetail.getOccupId(),
										this.getLoginUser().getUserName(),
										"添加了签证材料明细：【"+bizVisaDocDetail.getTitle()+"】",
										COM_LOG_LOG_TYPE.VISA_DOCUMNET_CHANGE.name(),
										"添加签证材料明细",null);
				 	} catch (Exception e) {
						log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.VISA_DOCUMNET_CHANGE.name());
						log.error(e.getMessage());
					}
			 	}else{
			 		BizVisaDocDetail oldBizVisaDocDetail = visaDocService.queryBizVisaDocDetailById(bizVisaDocDetail.getDetailId());
			 		if(oldBizVisaDocDetail!=null){
			 			visaDocService.updateBizVisaDocDetail(bizVisaDocDetail);
			 		}
			 		
			 		String logContent = "";
					logContent = getBizVisaDocDetailChangeLog(bizVisaDocDetail, oldBizVisaDocDetail);
					if(null != logContent && !"".equals(logContent))
					{
						//添加操作日志
						try {
							lvmmLogClientService.sendLog(
											COM_LOG_OBJECT_TYPE.VISA_DOCUMNET_DETAIL,
											bizVisaDocDetail.getDocId(), bizVisaDocDetail.getOccupId(),
											this.getLoginUser().getUserName(),
											"修改了签证材料明细：【"+bizVisaDocDetail.getTitle()+"】修改内容："+logContent,
											COM_LOG_LOG_TYPE.VISA_DOCUMNET_CHANGE.name(),
											"修改签证材料明细",null);
						} catch (Exception e) {
							LOG.error(ExceptionFormatUtil.getTrace(e));
						}	
					}
			 	}
			 	Map<String, Object> attributes = new HashMap<String, Object>();
			 	Map<String, Object> paramsBizVisaDocDetail = new HashMap<String, Object>();
				paramsBizVisaDocDetail.put("docId", bizVisaDocDetail.getDocId());
				paramsBizVisaDocDetail.put("occupId", bizVisaDocDetail.getOccupId());
				List<BizVisaDocDetail> bizVisaDocDetailList=visaDocService.findBizVisaDocDetail(paramsBizVisaDocDetail);
				attributes.put("bizVisaDocDetailList", bizVisaDocDetailList);
				
				return new ResultMessage(attributes,"success", "保存成功");
		} catch (Exception e) {
			LOG.error(ExceptionFormatUtil.getTrace(e));
		}
		return new ResultMessage("error", "保存失败");
	}	
	
	/**
	 * 删除签证材料明细信息
	 * @param detailsId
	 * @param model
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/delBizVisaDocDetail.do")
	@ResponseBody
	public Object delBizVisaDocDetail(Long detailId,Model model) throws BusinessException {
		 try {
			 	BizVisaDocDetail bizVisaDocDetail = visaDocService.queryBizVisaDocDetailById(detailId);
			 	if(bizVisaDocDetail!=null){
			 		//删除
				 	visaDocService.delBizVisaDocDetail(detailId);
				 	
				 	Map<String, Object> attributes = new HashMap<String, Object>();
				 	Map<String, Object> paramsBizVisaDocDetail = new HashMap<String, Object>();
					paramsBizVisaDocDetail.put("docId", bizVisaDocDetail.getDocId());
					paramsBizVisaDocDetail.put("occupId", bizVisaDocDetail.getOccupId());
					List<BizVisaDocDetail> bizVisaDocDetailList=visaDocService.findBizVisaDocDetail(paramsBizVisaDocDetail);
					attributes.put("bizVisaDocDetailList", bizVisaDocDetailList);
					
					try {
				 		lvmmLogClientService.sendLog(
										COM_LOG_OBJECT_TYPE.VISA_DOCUMNET_DETAIL,
										bizVisaDocDetail.getDocId(), bizVisaDocDetail.getOccupId(),
										this.getLoginUser().getUserName(),
										"删除了签证材料明细：【"+bizVisaDocDetail.getTitle()+"】",
										COM_LOG_LOG_TYPE.VISA_DOCUMNET_CHANGE.name(),
										"删除签证材料明细",null);
				 	} catch (Exception e) {
						log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.VISA_DOCUMNET_CHANGE.name());
						log.error(e.getMessage());
					}
					
					return new ResultMessage(attributes,"success", "删除成功");
			 	}else{
			 		return new ResultMessage("error", "该数据已不存在");
			 	}
		} catch (Exception e) {
			LOG.error(ExceptionFormatUtil.getTrace(e));
		}
		return new ResultMessage("error", "删除失败");
	}
	
	
	/**
	 * 跳转到新增上传签证材料明细模板页面
	 */
	@RequestMapping(value = "/showUploadTemplate.do")
	public String showUploadTemplate(Model model,Long detailId)
			throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<showUploadTemplate>");
		}
		if(detailId!=null){
			BizVisaDocDetail bizVisaDocDetail=visaDocService.queryBizVisaDocDetailById(detailId);
			model.addAttribute("detailId", detailId);
			model.addAttribute("docId", bizVisaDocDetail.getDocId());
			model.addAttribute("occupId", bizVisaDocDetail.getOccupId());
		}

		return "/prod/visa/document/inc/showUploadTemplate";
	}
	
	/**
	 * 新增上传签证材料明细模板附件
	 * @param supplier
	 * @return
	 */
	@RequestMapping(value = "/addBizVisaDetailTemplate.do")
	@ResponseBody
	public Object addBizVisaDetailTemplate(Long attachment, String fileName, 
			BizVisaDetailTemplate bizVisaDetailTemplate,BizVisaDocDetail bizVisaDocDetail) throws BusinessException {
		
		if (log.isDebugEnabled()) {
			log.debug("start method<addBizVisaDetailTemplate>");
		}
		bizVisaDetailTemplate.setTemplateName(fileName);
		bizVisaDetailTemplate.setFileId(attachment);
		long result= visaDocService.addBizVisaDetailTemplate(bizVisaDetailTemplate);
		if(result>0l){
			Map<String, Object> attributes = new HashMap<String, Object>();
		 	Map<String, Object> paramsBizVisaDocDetail = new HashMap<String, Object>();
			paramsBizVisaDocDetail.put("docId", bizVisaDocDetail.getDocId());
			paramsBizVisaDocDetail.put("occupId", bizVisaDocDetail.getOccupId());
			List<BizVisaDocDetail> bizVisaDocDetailList=visaDocService.findBizVisaDocDetail(paramsBizVisaDocDetail);
			attributes.put("bizVisaDocDetailList", bizVisaDocDetailList);
			
			bizVisaDocDetail = visaDocService.queryBizVisaDocDetailById(bizVisaDocDetail.getDetailId());
			
			//添加操作日志
			 try {
				lvmmLogClientService.sendLog(
								COM_LOG_OBJECT_TYPE.VISA_DOCUMNET_DETAIL,
								bizVisaDocDetail.getDocId(), bizVisaDocDetail.getOccupId(),
								this.getLoginUser().getUserName(),
								"添加签证材料明细【"+bizVisaDocDetail.getTitle()+"】下模板【"+fileName+"】",
								COM_LOG_LOG_TYPE.VISA_DOCUMNET_CHANGE.name(),
								"添加签证材料模板",null);
			} catch (Exception e) {
				log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.VISA_DOCUMNET_CHANGE.name());
				log.error(e.getMessage());
			}
			
			
			return new ResultMessage(attributes,"success", "新增成功");
		}else{
			return new ResultMessage("error", "新增失败");
		}
	}
	
	/**
	 * 删除签证材料明细模板
	 * @param templateId
	 * @param model
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/delBizVisaDetailTemplate.do")
	@ResponseBody
	public Object delBizVisaDetailTemplate(Long templateId,Model model) throws BusinessException {
		 try {
			 	//删除
			 	BizVisaDetailTemplate bizVisaDetailTemplate = visaDocService.queryBizVisaDetailTemplateById(templateId);
			 	BizVisaDocDetail bizVisaDocDetail = visaDocService.queryBizVisaDocDetailById(bizVisaDetailTemplate.getDetailId());
			 	int result=visaDocService.delBizVisaDetailTemplate(templateId);
			 	if(result>0){
			 		//添加操作日志
					 try {
						lvmmLogClientService.sendLog(
										COM_LOG_OBJECT_TYPE.VISA_DOCUMNET_DETAIL,
										bizVisaDocDetail.getDocId(), bizVisaDocDetail.getOccupId(),
										this.getLoginUser().getUserName(),
										"删除签证材料明细【"+bizVisaDocDetail.getTitle()+"】下模板【"+bizVisaDetailTemplate.getTemplateName()+"】",
										COM_LOG_LOG_TYPE.VISA_DOCUMNET_CHANGE.name(),
										"删除签证材料模板",null);
					} catch (Exception e) {
						log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.VISA_DOCUMNET_CHANGE.name());
						log.error(e.getMessage());
					}
			 		return new ResultMessage("success", "删除成功");
			 	}else{
			 		return new ResultMessage("error", "删除失败");
			 	}
		} catch (Exception e) {
			LOG.error(ExceptionFormatUtil.getTrace(e));
		}
		return new ResultMessage("error", "删除失败");
	}
	
	
	/**
	 * 删除签证材料信息
	 * @param documentId
	 * @param model
	 * @return
	 * @throws BusinessException
	 */
    @RequestMapping(value = "/delBizVisaDocOccup.do")
    @ResponseBody
    public Object delBizVisaDocOccup(Long docId, Long occupId, Model model) throws BusinessException {
        try {

            // 删除
            BizVisaDocOccup bizVisaDocOccup = visaDocService.queryBizVisaDocOccupById(occupId);
            if (bizVisaDocOccup != null) {
                visaDocService.delBizVisaDocOccup(docId, occupId);

                // 添加操作日志
                try {
                    lvmmLogClientService.sendLog(
                    		COM_LOG_OBJECT_TYPE.VISA_DOCUMNET, docId, docId,
							this.getLoginUser().getUserName(),
                            "删除签证材料人群及相关所有信息：【" + BizVisaDocOccup.OCCUP_TYPE.getCnName(bizVisaDocOccup.getOccupType()) + "】",
							COM_LOG_LOG_TYPE.VISA_DOCUMNET_CHANGE.name(), "删除签证材料人群及相关所有信息", null);
                } catch (Exception e) {
                    log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.VISA_DOCUMNET_CHANGE.name());
                    log.error(e.getMessage());
                }

                return new ResultMessage("success", "删除成功");
            }

        } catch (Exception e) {
        	LOG.error(ExceptionFormatUtil.getTrace(e));
        }
        return new ResultMessage("error", "删除失败");
    }
	
	 private String getBizVisaDocChangeLog(BizVisaDoc bizVisaDoc,BizVisaDoc oldBizVisaDoc){
		 StringBuffer logStr = new StringBuffer("");
		Map<String, Object> params1 = new HashMap<String, Object>();
		params1.put("dictCode", "VISA_TYPE");
		List<BizDictExtend> vistTypeList = dictService.findBizDictExtendList(params1);
		Map<String, Object> params2 = new HashMap<String, Object>();
		params2.put("dictCode", "VISA_CITY");
		List<BizDictExtend> vistCityList = dictService.findBizDictExtendList(params2);
		if(null== oldBizVisaDoc){
			//新增
			 logStr.append(ComLogUtil.getLogTxt("签证材料名字 ",bizVisaDoc.getDocName(),null));
			 logStr.append(ComLogUtil.getLogTxt("签证国家/地区 ",String.valueOf(bizVisaDoc.getCountry()),null));
			 if(StringUtils.isNotBlank(bizVisaDoc.getCity())){
				 for (BizDictExtend bizDictExtend : vistCityList) {
					 if(bizDictExtend.getDictId().longValue()==Long.valueOf(bizVisaDoc.getCity()).longValue()){
						 logStr.append(ComLogUtil.getLogTxt("送签城市 ",bizDictExtend.getDictName(),null));
					 }
				 }
			 }

			 for (BizDictExtend bizDictExtend : vistTypeList) {
				 if(bizDictExtend.getDictId().longValue()==Long.valueOf(bizVisaDoc.getVisaType()).longValue()){
					 logStr.append(ComLogUtil.getLogTxt("签证类型 ",bizDictExtend.getDictName(),null));
				 }
			 }
			 logStr.append(ComLogUtil.getLogTxt("是否有效 ",String.valueOf("Y".equals(bizVisaDoc.getCancelFlag()) ? "是" : "否"),null));
		 }else{
			 logStr.append(ComLogUtil.getLogTxt("签证材料名字 ",bizVisaDoc.getDocName(),oldBizVisaDoc.getDocName()));
			 logStr.append(ComLogUtil.getLogTxt("签证国家/地区 ",String.valueOf(bizVisaDoc.getCountry()),String.valueOf(oldBizVisaDoc.getCountry())));
	
			 String cityName="";
			 String oldCityName="";
			 for (BizDictExtend bizDictExtend : vistCityList) {
				 if(StringUtils.isNotBlank(bizVisaDoc.getCity()) && bizDictExtend.getDictId().longValue()==Long.valueOf(bizVisaDoc.getCity()).longValue()){
					 cityName = bizDictExtend.getDictName();
				 }
				 if(StringUtils.isNotBlank(oldBizVisaDoc.getCity()) && bizDictExtend.getDictId().longValue()==Long.valueOf(oldBizVisaDoc.getCity()).longValue()){
					 oldCityName = bizDictExtend.getDictName();
				 }
			 }
			 logStr.append(ComLogUtil.getLogTxt("送签城市 ",cityName,oldCityName));
			 
			 if(!String.valueOf(bizVisaDoc.getVisaType()).equals(String.valueOf(oldBizVisaDoc.getVisaType()))){
				 String visaTypeName="";
				 String oldVisaTypeName="";
				 for (BizDictExtend bizDictExtend : vistTypeList) {
					 if(bizDictExtend.getDictId().longValue()==Long.valueOf(bizVisaDoc.getVisaType()).longValue()){
						 visaTypeName = bizDictExtend.getDictName();
					 }
					 if(bizDictExtend.getDictId().longValue()==Long.valueOf(oldBizVisaDoc.getVisaType()).longValue()){
						 oldVisaTypeName = bizDictExtend.getDictName();
					 }
				 }
				 logStr.append(ComLogUtil.getLogTxt("签证类型 ",visaTypeName,oldVisaTypeName));
			 }
			 
			 
			 logStr.append(ComLogUtil.getLogTxt("是否有效 ",String.valueOf("Y".equals(bizVisaDoc.getCancelFlag()) ? "是" : "否"),String.valueOf("Y".equals(oldBizVisaDoc.getCancelFlag()) ? "是" : "否")));
		 }
		 return logStr.toString();
	 }
	
	 
	 private String getBizVisaDocDetailChangeLog(BizVisaDocDetail bizVisaDocDetail,BizVisaDocDetail oldBizVisaDocDetail){
		 StringBuffer logStr = new StringBuffer("");
		if(null== oldBizVisaDocDetail){
			//新增
			 logStr.append(ComLogUtil.getLogTxt("材料名称 ",bizVisaDocDetail.getTitle(),null));
			 logStr.append(ComLogUtil.getLogTxt("材料要求 ",bizVisaDocDetail.getContent(),null));
			 logStr.append(ComLogUtil.getLogTxt("次序 ",String.valueOf(bizVisaDocDetail.getSeq()),null));
		 }else{
			 logStr.append(ComLogUtil.getLogTxt("材料名称 ",bizVisaDocDetail.getTitle(),oldBizVisaDocDetail.getTitle()));
			 logStr.append(ComLogUtil.getLogTxt("材料要求 ",bizVisaDocDetail.getContent(),oldBizVisaDocDetail.getContent()));
			 logStr.append(ComLogUtil.getLogTxt("次序 ",String.valueOf(bizVisaDocDetail.getSeq()),String.valueOf(oldBizVisaDocDetail.getSeq())));
		 }
		 return logStr.toString();
	 }
		/**
		 * 搜索签证国家/地区
		 */
		@RequestMapping(value = "/searchVisaCountry")
		@ResponseBody
		public void searchVisaCountry(String search, HttpServletResponse resp){
			if (LOG.isDebugEnabled()) {
				LOG.debug("start method<searchVisaCountry>");
			}
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("districtName", search);
			params.put("cancelFlag", "Y");
			List<BizDistrict> bizDistricts = MiscUtils.autoUnboxing( districtService.findDistrictList(params) );
			JSONArray array = new JSONArray();
			if(bizDistricts != null && bizDistricts.size() > 0){
				for(BizDistrict bizDistrict : bizDistricts){
					JSONObject obj=new JSONObject();
					obj.put("id", bizDistrict.getDistrictId());
					obj.put("text", bizDistrict.getDistrictName());
					array.add(obj);
				}
			}
			JSONOutput.writeJSON(resp, array);
		}
		
}
