package com.lvmama.vst.back.o2o.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizDistrict;
import com.lvmama.vst.back.client.biz.service.DistrictClientService;
import com.lvmama.vst.back.client.o2o.service.SubCompanyClientService;
import com.lvmama.vst.back.client.o2o.service.SubCompanySupplierRelationClientService;
import com.lvmama.vst.back.client.supp.service.SuppSupplierClientService;
import com.lvmama.vst.back.supp.po.SuppContact;
import com.lvmama.vst.back.supp.po.SuppSupplier;
import com.lvmama.vst.back.supp.service.SuppContactService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * @author shenlibin
 *
 * 子公司关联供应商Action
 */
@Controller
@RequestMapping("/o2o/subCompany")
public class SubCompanySupplierRelationAction extends BaseActionSupport {
	private static final long serialVersionUID = 481251585277869238L;

    @Autowired
    private SubCompanyClientService subCompanyService;

    @Autowired
	private SuppSupplierClientService suppSupplierService;

	@Autowired
	private DistrictClientService districtService;
	
	@Autowired
	private SuppContactService suppContactService;
	
	@Autowired
	private SubCompanySupplierRelationClientService subCompanySupplierRelationService;

    /**
     * 关联供应商列表页面
     */
    @RequestMapping(value = "/showRelateSuppliers")
    public String showRelateSuppliers(Model model, Long subCompanyId, Integer page, String type, 
    		String auditType, HttpServletRequest req) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<showRelateSuppliers>");
		}
    	model.addAttribute("subCompanyId", subCompanyId);
        model.addAttribute("auditType", auditType);
        model.addAttribute("type", type);

		List<Long> supplierIdList = subCompanySupplierRelationService.findAllRelateSupplierIds(subCompanyId).getReturnContent();
		if (CollectionUtils.isEmpty(supplierIdList)) {
			Page emptyPageParam = new Page();
			emptyPageParam.buildUrl(req);
			model.addAttribute("pageParam", emptyPageParam);
			return "/o2o/subCompany/showRelateSupplierList";
		}
        
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("supplierIds", supplierIdList);
		Integer count = MiscUtils.autoUnboxing( suppSupplierService.findSuppSupplierCount(parameters) );
		
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		
		parameters.put("_start", pageParam.getStartRowsMySql());
		parameters.put("_pageSize", pageParam.getPageSize());
		parameters.put("_orderby", "supp.SUPPLIER_ID desc");
		List<SuppSupplier> supplierList = MiscUtils.autoUnboxing( suppSupplierService.findSuppSupplierListByConditon(parameters) );
		for (SuppSupplier suppSupplier : supplierList) {
			// 区域
			if (suppSupplier.getDistrictId() != null) {
				BizDistrict bizDistrict = MiscUtils.autoUnboxing( districtService.findDistrictById(suppSupplier.getDistrictId()) );
				if (bizDistrict != null) {
					suppSupplier.setSupplierDistrict(bizDistrict.getDistrictName());
				}
			}
		}
		pageParam.setItems(supplierList);
		model.addAttribute("pageParam", pageParam);
        
        return "/o2o/subCompany/showRelateSupplierList";
    }
    
	/**
	 * 查看供应商信息
	 */
	@RequestMapping(value = "/showRelateSupplierInfo")
	public String showRelateSupplierInfo(Model model, Integer page, Long supplierId, HttpServletRequest req) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<showRelateSupplierInfo>");
		}

		// 供应商基本信息
		SuppSupplier suppSupplier = MiscUtils.autoUnboxing( suppSupplierService.findSuppSupplierById(supplierId) );
		if (suppSupplier != null) {
			// 区域
			if (suppSupplier.getDistrictId() != null) {
				BizDistrict bizDistrict = MiscUtils.autoUnboxing( districtService.findDistrictById(suppSupplier.getDistrictId()) );
				if (bizDistrict != null) {
					suppSupplier.setSupplierDistrict(bizDistrict.getDistrictName());
				}
			}
			// 父供应商
			if (suppSupplier.getFatherId() != null) {
				SuppSupplier fatherSupplier = suppSupplierService.selectByPrimaryKey(suppSupplier.getFatherId());
				if (fatherSupplier != null) {
					suppSupplier.setFatherSupplier(fatherSupplier.getSupplierName());
				}
			}
		}
		model.addAttribute("supplierTypeList", SuppSupplier.SUPPLIER_TYPE.values());
		model.addAttribute("supplier", suppSupplier);

		// 供应商联系人信息
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("supplierId", supplierId);
		int count = suppContactService.findSuppContactCount(parameters);

		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 5, pagenum);
		pageParam.buildUrl(req);
		parameters.put("_start", pageParam.getStartRowsMySql());
		parameters.put("_end", pageParam.getEndRows());
		List<SuppContact> list = suppContactService.findSuppContactList(parameters);
		pageParam.setItems(list);

		model.addAttribute("supplierId",supplierId);
		model.addAttribute("pageParam", pageParam);

		return "/o2o/subCompany/showRelateSupplierInfo";
	}
    
	/**
	 * 添加关联供应商
	 */
	@RequestMapping(value = "/addRelateSuppliers")
	@ResponseBody
	public Object addRelateSuppliers(String supplierIds, Long subCompanyId) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<addRelateSuppliers>");
		}

		if (StringUtils.isBlank(supplierIds) || subCompanyId == null) {
			return new ResultMessage(ResultMessage.ERROR, "添加关联供应商失败,无效参数：[subCompanyId=" + subCompanyId + "], [supplierIds=" + supplierIds + "]");
		}
			
		String[] supplierIdsArry = StringUtils.split(supplierIds.trim(), ",");

		List<Long> supplierIdsList = new ArrayList<Long>();

		for (String supplierId : supplierIdsArry) {
			supplierIdsList.add(Long.valueOf(supplierId));
		}
		Integer successCount = subCompanySupplierRelationService.saveSubCompanySupplierRelation(subCompanyId, supplierIdsList, this.getLoginUserId()).getReturnContent();
		Integer failCount = supplierIdsList.size() - successCount;
		if (successCount == 0) {
			return new ResultMessage(ResultMessage.ERROR, "关联供应商失败" + ",失败原因可能为: 供应商不存在or供应商已经关联在该子公司下");
		}
		if (failCount == 0) {
			return new ResultMessage(ResultMessage.SUCCESS, "关联供应商成功!");
		}
		return new ResultMessage(ResultMessage.SUCCESS, "关联供应商成功数为" + successCount + ",失败数为" + failCount + ",失败原因可能为: 供应商不存在or供应商已经关联在该子公司下");
		
	}
	
	/**
	 * 取消供应商关联
	 */
	@RequestMapping(value = "/cancelRelateSupplier")
	@ResponseBody
	public Object cancelRelateSupplier(Long subCompanyId, Long supplierId) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<cancelRelateSupplier>");
		}

		if (subCompanyId == null || supplierId == null) {
			return new ResultMessage(ResultMessage.ERROR, "取消供应商关联失败,无效参数：[subCompanyId=" + subCompanyId + "], [supplierId=" + supplierId + "]");
		}
		Integer result = subCompanySupplierRelationService.updateRelateSupplierCancelFlagForRemove(subCompanyId, supplierId, this.getLoginUserId()).getReturnContent();
		if (result > 0) {
			return new ResultMessage(ResultMessage.SUCCESS, "取消关联供应商成功!");
		}
		return new ResultMessage(ResultMessage.ERROR, "取消供应商关联失败!");
	}


}
