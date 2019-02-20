package com.lvmama.vst.back.o2o.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.client.o2o.service.ShareholderInfoClientService;
import com.lvmama.vst.back.client.o2o.service.SubCompanySholdRelationClientService;
import com.lvmama.vst.back.o2o.po.ShareholderInfo;
import com.lvmama.vst.back.o2o.utils.ConstantEnums;
import com.lvmama.vst.back.utils.Constants;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

@Controller
@RequestMapping("/o2o/subCompany")
public class SubCompanySholdRelationAction extends BaseActionSupport {
    private static final long serialVersionUID = -9080827798387167380L;
    private static final Logger LOGGER = LoggerFactory.getLogger(SubCompanySholdRelationAction.class);
    @Autowired
    private SubCompanySholdRelationClientService subCompanySholdRelationService;
    @Autowired
    private ShareholderInfoClientService shareholderInfoService;

    /**
     * 跳转到维护子公司股东方信息页面
     * 
     * @return
     * @throws BusinessException
     */
    @RequestMapping(value = "/showSholds")
    public String findSholdList(Model model, Long subCompanyId, Integer page, String relationType, String type,
            String auditType, HttpServletRequest req) throws BusinessException {
        LOGGER.info("start showSholds");
        model.addAttribute("relationType", relationType);
        model.addAttribute("subCompanyId", subCompanyId);
        model.addAttribute("auditType", auditType);
        model.addAttribute("type", type);
        model.addAttribute("sholdTypes", ConstantEnums.SHOLDTYPE.values());
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("relationType", relationType);
        params.put("subCompanyId", subCompanyId);
        params.put("type", type);
        params.put("cancelFlag", Constants.VALID_STATUS);
        try {
            int count = subCompanySholdRelationService.findCountByParams(params, type).getReturnContent();
            LOGGER.info("Executing findSholdList, the count is" + count);
            if (count == 0) {
                return "/o2o/subCompany/showSholds";
            }
            int pagenum = page == null ? 1 : page;
            Page<ShareholderInfo> pageParam = Page.page(count, 10, pagenum);
            pageParam.buildUrl(req);
            params.put("_start", pageParam.getStartRowsMySql());
            params.put("_pageSize", pageParam.getPageSize());
            params.put("_orderby", "ID");
            params.put("_order", "DESC");
            List<ShareholderInfo> list = subCompanySholdRelationService.findByParams(params, type).getReturnContent();
            if (null != list && list.size() > 0) {
                pageParam.setItems(list);
                model.addAttribute("pageParam", pageParam);
            }
        } catch (Exception e) {
            LOGGER.error("Error occurred while show subCompany shareholders.", e);
            model.addAttribute("errorMsg", "系统内部异常");
        }
        return "/o2o/subCompany/showSholds";
    }

    /**
     * 获得股东列表
     * 
     * @param model
     * @param page
     *            分页参数
     * @param writablePerm
     *            可写权限
     * @param shareholderInfo
     *            查询条件：包括股东方名称，股东方类型
     * @param req
     * @return
     */
    @RequestMapping(value = "/findReadOnlySholdList")
    public String findReadOnlySholdList(Model model, Integer page, ShareholderInfo shareholderInfo, Long subCompanyId,
            String relationType, HttpServletRequest req) throws BusinessException {
        LOGGER.debug("start method<findReadOnlySholdList>");
        model.addAttribute("sholdTypes", ConstantEnums.SHOLDTYPE.values());
        model.addAttribute("shareholder", shareholderInfo);
        model.addAttribute("subCompanyId", subCompanyId);
        model.addAttribute("relationType", relationType);
        if (null == shareholderInfo || null == shareholderInfo.getName()) {
            return "/o2o/subCompany/showAddSholds";
        }
        Map<String, Object> paramShareholder = new HashMap<String, Object>();

        // 根据writablePerm编辑或审核权限的，显示之前已经审核通过的信息。
        Boolean writablePerm = false;
        paramShareholder.put("writablePerm", writablePerm);

        paramShareholder.put("name", shareholderInfo.getName()); // 股东名称
        paramShareholder.put("sholdType", shareholderInfo.getSholdType()); // 股东类型
        paramShareholder.put("cancelFlag", "Y"); // 股东状态
        try {
            int count = shareholderInfoService.findShareholdersCount(paramShareholder).getReturnContent();

            int pagenum = page == null ? 1 : page;
            Page<ShareholderInfo> pageParam = Page.page(count, 10, pagenum);
            pageParam.buildUrl(req);
            paramShareholder.put("_start", pageParam.getStartRowsMySql());
            paramShareholder.put("_pageSize", pageParam.getPageSize());
            paramShareholder.put("_orderby", "ID");
            paramShareholder.put("_order", "DESC");

            List<ShareholderInfo> list = shareholderInfoService.findShareholders(paramShareholder, writablePerm).getReturnContent();
            pageParam.setItems(list);
            model.addAttribute("subPageParam", pageParam);
            List<Long> ids = subCompanySholdRelationService.findAllSholdIds(subCompanyId, relationType).getReturnContent();
            model.addAttribute("ids", ids);
        } catch (Exception e) {
            LOGGER.error("Error occurred while find readOnly shareholder list", e);
            model.addAttribute("errorMsg", "系统内部异常");
        }
        return "/o2o/subCompany/showAddSholds";
    }

    /**
     * 保存子公司、股东关联关系
     * 
     * @param model
     * @param subCompanyId
     * @param sholdIds
     * @param relationType
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/sholdRel", method = RequestMethod.POST)
    @ResponseBody
    public Object saveSholdRel(Model model, Long subCompanyId,
            @RequestParam(value = "sholdIds[]", required = false) List<Long> sholdIds, String relationType,
            HttpServletRequest req, HttpServletResponse res) {
        try {
            subCompanySholdRelationService.saveSubCompanySholdRelation(subCompanyId, sholdIds, relationType,
                    this.getLoginUserId());
        } catch (Exception e) {
            LOGGER.error("Error occurred while saving the relationship between subCompany and sharehold", e);
            return new ResultMessage(ResultMessage.ERROR, "系统内部异常");
        }
        return new ResultMessage(ResultMessage.SUCCESS, "保存成功");
    }

    /**
     * 删除子公司、股东关联关系
     * 
     * @param model
     * @param subCompanyId
     * @param relId
     * @param relationType
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/sholdRel/remove", method = RequestMethod.POST)
    @ResponseBody
    public Object removeSholdRel(Model model, Long subCompanyId, Long relId, HttpServletRequest req,
            HttpServletResponse res) {
        try {
            subCompanySholdRelationService.updateSubCoSholdRelForRemove(subCompanyId, relId, this.getLoginUserId());
        } catch (Exception e) {
            LOGGER.error("Error occurred while removing the relationship between subCompany and sharehold", e);
            return new ResultMessage(ResultMessage.ERROR, "系统内部异常");
        }
        return new ResultMessage(ResultMessage.SUCCESS, "保存成功");
    }
}
