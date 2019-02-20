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

import com.lvmama.vst.back.biz.po.BizBrand;
import com.lvmama.vst.back.biz.service.BizBrandService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 品牌
 * @author dongningbo
 *
 */
@Controller
@RequestMapping("/biz/bizBrand")
public class BizBrandAction extends BaseActionSupport {

	private static final long serialVersionUID = 5382773196841020123L;
	
	@Autowired
	private BizBrandService bizBrandService;
	
	
	@Autowired
	private ComLogClientService comLogService;
	
	
	//查询列表
	@RequestMapping(value = "/findBizBrandList")
	public String findBizBrandList(Model model, Integer page, BizBrand bizBrand, String brandName, String cancelFlag, HttpServletRequest req) throws BusinessException {
		if(log.isDebugEnabled()) {
			log.debug("start method<findBizBrandList>");
		}
		Map<String, Object> params = new HashMap<String,Object>();
		//目的地ID
		params.put("brandId", bizBrand.getBrandId());
		//目的地名称
		params.put("brandName", brandName);
		//是否有效
		if(cancelFlag == null) {
			model.addAttribute("cancelFlag", "");
		} else if("Y".equals(cancelFlag) || "N".equals(cancelFlag)) {
			params.put("cancelFlag", cancelFlag);
			model.addAttribute("cancelFlag", cancelFlag);
		} else {
			model.addAttribute("cancelFlag", "");
		}
		
		int count = bizBrandService.queryTotalCount(params);
		
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		params.put("_start", pageParam.getStartRows());
		params.put("_end", pageParam.getEndRows());
		params.put("_orderby", " bd.brand_id ASC ");
		List<BizBrand> list = bizBrandService.findPageListByParams(params);
		pageParam.setItems(list);
		
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("page", pageParam.getPage().toString());
		model.addAttribute("bizBrand", bizBrand);
		model.addAttribute("brandName", brandName);
		
		return "/biz/brand/findBizBrandList";
	}

	//跳转到修改页面
	@RequestMapping(value = "/showUpdateBizBrand")
	public String showUpdateBizBrand(Model model, Long brandId) throws BusinessException {
		if(log.isDebugEnabled()) {
			log.debug("start method<showUpdateBizBrand>");
		}
		//品牌维护
		if (brandId == null) {
			model.addAttribute("bizBrand", new BizBrand());
			return "/biz/brand/showAddBrand";
		}
		BizBrand bizBrand = bizBrandService.getByBrandId(brandId);
		model.addAttribute("bizBrand", bizBrand);
		return "/biz/brand/showAddBrand";
	}

	@RequestMapping(value = "/updateBrand")
	@ResponseBody
	public Object updateBrand(BizBrand bizBrand) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<updateBrand>");
		}
		
		BizBrand oldBrand = bizBrandService.getByBrandId(bizBrand.getBrandId());

		int flag = bizBrandService.updateBrand(bizBrand);
		//添加操作日志
		try {
			String logType = null, log = "";
			if (flag == 1) {
				logType = COM_LOG_LOG_TYPE.BIZ_BRAND_EDIT_SUCCESS.getCnName();
			} else {
				logType = COM_LOG_LOG_TYPE.BIZ_BRAND_EDIT_FAIL.getCnName();
			}
			log = getChangeLog(bizBrand, oldBrand);
			comLogService.insert(COM_LOG_OBJECT_TYPE.BIZ_BRAND_EDIT,
					bizBrand.getBrandId(), bizBrand.getBrandId(),
					this.getLoginUserId(), 
					log, 
					logType, 
					"修改品牌编号【"+ bizBrand.getBrandId() + "】", null);
		} catch (Exception e) {
			log.error(e.getMessage());
		}
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}
	/**
	 * 编辑品牌时 比较新旧信息区别
	 */
	private String getChangeLog(BizBrand newKey, BizBrand oldKey) {
		StringBuilder log = new StringBuilder();

		if (newKey != null) {
			// 基本信息
			log.append(ComLogUtil.getLogTxt("是否有效", newKey.getCancelFlag(),
					oldKey.getCancelFlag()));
			log.append(ComLogUtil.getLogTxt("品牌名称", newKey.getBrandName(),
					oldKey.getBrandName()));
			log.append(ComLogUtil.getLogTxt("全称", newKey.getBrandFullName(),
					oldKey.getBrandFullName()));
			log.append(ComLogUtil.getLogTxt("简称", newKey.getBrandShortName(),
					oldKey.getBrandShortName()));
			log.append(ComLogUtil.getLogTxt("首字母", newKey.getBrandInitial(),
					oldKey.getBrandInitial()));
			log.append(ComLogUtil.getLogTxt("所属集团", newKey.getGroupName(),
					oldKey.getGroupName()));

		}
		return log.toString();
	}

	@RequestMapping(value = "/addBrand")
	@ResponseBody
	public Object addBrand(BizBrand bizBrand) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<addBrand>");
		}

		int flag = bizBrandService.add(bizBrand);
		//添加操作日志
		try {
			String logType = null;
			if (flag == 1) {
				logType = COM_LOG_LOG_TYPE.BIZ_BRAND_ADD_SUCCESS.getCnName();
			} else {
				logType = COM_LOG_LOG_TYPE.BIZ_BRAND_ADD_FAIL.getCnName();
			}
			comLogService.insert(COM_LOG_OBJECT_TYPE.BIZ_BRAND_EDIT,
					bizBrand.getBrandId(), bizBrand.getBrandId(),
					this.getLoginUserId(), 
					"新增【" + bizBrand.getBrandName()+ "】品牌，编号：【" + bizBrand.getBrandId() + "】", 
					logType, 
					"新增【" + bizBrand.getBrandName()+ "】品牌，编号：【" + bizBrand.getBrandId() + "】", null);
		} catch (Exception e) {
			log.error(e.getMessage());
		}
		return ResultMessage.ADD_SUCCESS_RESULT;
	}

	@RequestMapping(value = "/editFlag")
	@ResponseBody
	public Object editFlag(Long bizBrandId, String cancelFlag) {
		if (log.isDebugEnabled()) {
			log.debug("start method<editFlag>");
		}
		int flag = 0;
		try {
			flag = bizBrandService.editFlag(bizBrandId, cancelFlag);
		} catch (BusinessException e1) {
			e1.printStackTrace();
			return new ResultMessage(ResultMessage.ERROR, e1.getMessage());
		}
		//添加操作日志
		try {
			String log = "";
			if("Y".equalsIgnoreCase(cancelFlag)){
				log="有效";
			}else if("N".equalsIgnoreCase(cancelFlag)){
				log="无效";
			}
			String logType = null;
			if (flag == 1) {
				logType = COM_LOG_LOG_TYPE.BIZ_BRAND_EDIT_SUCCESS.getCnName();
			} else {
				logType = COM_LOG_LOG_TYPE.BIZ_BRAND_EDIT_FAIL.getCnName();
			}
			comLogService.insert(COM_LOG_OBJECT_TYPE.BIZ_BRAND_EDIT,
					bizBrandId, bizBrandId,
					this.getLoginUserId(), 
					"修改品牌状态为["+log+"]", 
					logType, 
					"修改品牌状态",null);
		} catch (Exception e) {
			log.error(e.getMessage());
		}
		return ResultMessage.SET_SUCCESS_RESULT;
	}

	@RequestMapping(value = "/findSelectBrandList")
	public String findSelectBrandList(Model model, Integer page, String brandName, HttpServletRequest req)throws BusinessException{
		model.addAttribute("brandName", brandName);
		
		if(page == null && brandName == null) {
			return "/biz/brand/findSelectBrandList";
		}
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("cancelFlag", "Y");
		parameters.put("brandName", brandName);
		int count = bizBrandService.queryTotalCount(parameters);

		// 分页
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		parameters.put("_start", pageParam.getStartRows());
		parameters.put("_end", pageParam.getEndRows());
		parameters.put("_orderby", " bd.brand_id ASC ");
		List<BizBrand> list = bizBrandService.findPageListByParams(parameters);

		// 页面赋值
		pageParam.setItems(list);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("page", pageParam.getPage().toString());
		
		return "/biz/brand/findSelectBrandList";
		
	}
}