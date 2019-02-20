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
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.client.o2o.service.PrincipalClientService;
import com.lvmama.vst.back.o2o.po.Principal;
import com.lvmama.vst.back.o2o.utils.ConstantEnums;
import com.lvmama.vst.back.o2o.utils.ConstantEnums.DATATYPE;
import com.lvmama.vst.back.utils.Constants;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

@Controller
@RequestMapping("/o2o")
public class PrincipalAction extends BaseActionSupport {

    private static final long serialVersionUID = 3682253475009593062L;
    private static final Logger LOGGER = LoggerFactory.getLogger(PrincipalAction.class);

    @Autowired
    private PrincipalClientService principalService;

    /**
     * 跳转到维护股东主要负责人信息页面
     * 
     * @return
     * @throws BusinessException
     */
    @RequestMapping(value = "/shareholder/showPrincipal")
    public String showSholdPrincipal(Model model, Long shareholderId, String type, String auditType)
            throws BusinessException {
        LOGGER.info("start showSholdPrincipal");
        if (null != shareholderId && !shareholderId.equals(0l)) {
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("workforType", ConstantEnums.DATATYPE.SHOLD.name());
            params.put("workforId", shareholderId);
            try {
                Map<String, Principal> principalMap = principalService.getPrincipalByParamsForSholdMap(params, type).getReturnContent();
                if (null == principalMap) {
                    throw new BusinessException("Error occurred while getting principal with shareholder id:"
                            + shareholderId);
                }
                model.addAttribute("principal", principalMap.get("principal"));
                model.addAttribute("oldPrincipal", principalMap.get("oldPrincipal"));
            } catch (Exception e) {
                LOGGER.error(e.getMessage(), e);
                model.addAttribute("errorMsg", "系统内部异常");
            }
        }
        model.addAttribute("workforType", ConstantEnums.DATATYPE.SHOLD.name());
        model.addAttribute("workforId", shareholderId);
        model.addAttribute("auditType", auditType);
        model.addAttribute("type", type);
        model.addAttribute("dataRefer", DATATYPE.SHOLD.name());
        return "/o2o/shareholder/showPrincipal";
    }

    /**
     * 跳转到维护子公司单个主要负责人信息页面
     * 
     * @return
     * @throws BusinessException
     */
    @RequestMapping(value = "/subCompany/principal")
    public String showSubCOPrincipal(Model model, Long subCompanyId, Long id, String type, String auditType)
            throws BusinessException {
        LOGGER.info("start showSubCOPrincipal");
        try {
            if (null != id && !id.equals(0l)) {
                Map<String, Principal> principalMap = principalService.getPrincipalByIdForSubCO(id, type).getReturnContent();
                if (null == principalMap) {
                    throw new BusinessException("Error occurred while getting principal with id:" + id);
                }
                model.addAttribute("principal", principalMap.get("principal"));
                model.addAttribute("oldPrincipal", principalMap.get("oldPrincipal"));
            }
        } catch (Exception e) {
            LOGGER.error(e.getMessage(), e);
            model.addAttribute("errorMsg", "系统内部异常");
        }
        model.addAttribute("workforType", ConstantEnums.DATATYPE.SUB_CO.name());
        model.addAttribute("workforId", subCompanyId);
        model.addAttribute("auditType", auditType);
        model.addAttribute("type", type);
        model.addAttribute("dataRefer", DATATYPE.SUB_CO.name());
        return "/o2o/principalForm";
    }

    /**
     * 跳转到维护子公司主要负责人信息页面
     * 
     * @return
     * @throws BusinessException
     */
    @RequestMapping(value = "/subCompany/showPrincipal")
    public String showSubCOPrincipal(Model model, Long subCompanyId, Integer page, String type, String auditType,
            HttpServletRequest req) throws BusinessException {
        LOGGER.info("start showSubCOPrincipal");
        model.addAttribute("workforType", ConstantEnums.DATATYPE.SUB_CO.name());
        model.addAttribute("workforId", subCompanyId);
        model.addAttribute("auditType", auditType);
        model.addAttribute("type", type);
        try {
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("workforType", ConstantEnums.DATATYPE.SUB_CO.name());
            params.put("workforId", subCompanyId);
            params.put("type", type);
            params.put("cancelFlag", Constants.VALID_STATUS);
            int count = principalService.findCountByParamsForSubCO(params, type).getReturnContent();

            LOGGER.info("Executing showSubCOPrincipal, the count is" + count);
            if (count == 0) {
                return "/o2o/subCompany/showPrincipals";
            }

            int pagenum = page == null ? 1 : page;
            Page<Principal> pageParam = Page.page(count, 10, pagenum);
            pageParam.buildUrl(req);
            params.put("_start", pageParam.getStartRowsMySql());
            params.put("_pageSize", pageParam.getPageSize());
            params.put("_orderby", "ID");
            params.put("_order", "DESC");
            List<Principal> list = principalService.findByParamsForSubCO(params, type).getReturnContent();
            if (null != list && list.size() > 0) {
                pageParam.setItems(list);
                model.addAttribute("pageParam", pageParam);
            }
        } catch (Exception e) {
            LOGGER.error("Error occurred while show subCompany principal.", e);
            model.addAttribute("errorMsg", "系统内部异常");
        }
        return "/o2o/subCompany/showPrincipals";
    }

    /**
     * 保存单个主要负责人基本信息
     * 
     * @param model
     * @param shareholderInfo
     * @param locations
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/principal", method = RequestMethod.POST)
    @ResponseBody
    public Object savePrincipal(Model model, Principal principal, HttpServletRequest req, HttpServletResponse res) {
        Map<String, Object> attributes = new HashMap<String, Object>();
        try {
            // 设置创建人
            principal.setCreateUser(this.getLoginUserId());
            Long principalId = principalService.savePrincipal(principal).getReturnContent();
            attributes.put("principalId", principalId);
        } catch (Exception e) {
            LOGGER.error("Error occurred while saving principal", e);
            return new ResultMessage(ResultMessage.ERROR, "系统内部异常");
        }
        return new ResultMessage(attributes, ResultMessage.SUCCESS, "保存成功");
    }

    /**
     * 修改主要负责人基本信息
     * 
     * @param model
     * @param shareholderInfo
     * @param locations
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/principal/edit", method = RequestMethod.POST)
    @ResponseBody
    public Object updatePrincipal(Model model, Principal principal, HttpServletRequest req, HttpServletResponse res) {
        Map<String, Object> attributes = new HashMap<String, Object>();
        try {// 设置创建人
            principal.setUpdateUser(this.getLoginUserId());
            Long principalId = principalService.updatePrincipal(principal).getReturnContent();
            attributes.put("principalId", principalId);
        } catch (Exception e) {
            LOGGER.error("Error occurred while updating principal", e);
            return new ResultMessage(ResultMessage.ERROR, "系统内部异常");
        }
        return new ResultMessage(attributes, ResultMessage.SUCCESS, "保存成功");
    }

    /**
     * 删除子公司主要负责人基本信息
     * 
     * @param model
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/principal/remove", method = RequestMethod.POST)
    @ResponseBody
    public Object deletePrincipal(Model model, Principal principal, HttpServletRequest req, HttpServletResponse res) {
        Map<String, Object> attributes = new HashMap<String, Object>();
        try {// 设置创建人
            principal.setUpdateUser(this.getLoginUserId());
            Long principalId = principalService.deletePrincipal(principal).getReturnContent();
            attributes.put("principalId", principalId);
        } catch (Exception e) {
            LOGGER.error("Error occurred while deleting principal", e);
            return new ResultMessage(ResultMessage.ERROR, "系统内部异常");
        }
        return new ResultMessage(attributes, ResultMessage.SUCCESS, "保存成功");
    }
}
