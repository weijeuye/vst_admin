package com.lvmama.vst.back.o2o.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import com.lvmama.vst.back.client.o2o.service.SholdAssCompanyClientService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.o2o.po.SholdAssCompany;
import com.lvmama.vst.back.o2o.utils.ConstantEnums;
import com.lvmama.vst.back.o2o.utils.ConstantEnums.DATATYPE;
import com.lvmama.vst.back.o2o.utils.ConstantEnums.VIEWTYPE;
import com.lvmama.vst.back.utils.Constants;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;

@Controller
@RequestMapping("/o2o")
public class SholdAssCompanyAction extends BaseActionSupport {
    private static final long serialVersionUID = -6188629544886748032L;
    private static final Logger LOGGER = LoggerFactory.getLogger(SholdAssCompanyAction.class);

    @Autowired
    private SholdAssCompanyClientService sholdAssCompanyService;

    /**
     * 获得股东关联公司列表
     * 
     * @param model
     * @param page
     *            分页参数
     * @param writablePerm
     *            可写权限
     * @param subCompany
     *            查询条件：包括股东关联公司名称，地区，股东关联公司状态，审核状态
     * @param req
     * @return
     */
    @RequestMapping(value = "/sholdAssCompanys")
    public String findSholdAssCompanys(Model model, Integer page, String sholdName, Boolean writablePerm,
            SholdAssCompany sholdAssCompany, HttpServletRequest req) throws BusinessException {
        LOGGER.debug("start method<findSholdAssCompanys>");
        model.addAttribute("auditTypes", ConstantEnums.AUDITTYPE.values());
        model.addAttribute("sholdAssCompany", sholdAssCompany);
        if (null == sholdAssCompany || null == sholdAssCompany.getName()) {
            return "/o2o/sholdAssCompany/findList";
        }
        Map<String, Object> paramSubCompany = new HashMap<String, Object>();

        // 根据writablePerm编辑或审核权限的，显示之前已经审核通过的信息。
        writablePerm = BooleanUtils.isTrue(writablePerm);
        paramSubCompany.put("writablePerm", writablePerm);

        paramSubCompany.put("name", sholdAssCompany.getName()); // 股东关联公司名称
        paramSubCompany.put("cancelFlag", Constants.VALID_STATUS);

        if (StringUtils.isNotEmpty(sholdAssCompany.getAuditStatus())) {
            paramSubCompany.put("auditStatus", sholdAssCompany.getAuditStatus()); // 审核状态
        }
        if (StringUtils.isNotEmpty(sholdAssCompany.getAssoStatus())) {
            paramSubCompany.put("assoStatus", sholdAssCompany.getAssoStatus()); // 股东关联公司合作状态
        }
        if (StringUtils.isNotEmpty(sholdName) && writablePerm) {
            paramSubCompany.put("sholdName", sholdName); // 股东名称状态
            model.addAttribute("sholdName", sholdName);
        }
        try{
            int count = sholdAssCompanyService.findSholdAssCompanyCount(paramSubCompany).getReturnContent();
            
            int pagenum = page == null ? 1 : page;
            Page<SholdAssCompany> pageParam = Page.page(count, 10, pagenum);
            pageParam.buildUrl(req);
            paramSubCompany.put("_start", pageParam.getStartRowsMySql());
            paramSubCompany.put("_pageSize", pageParam.getPageSize());
            paramSubCompany.put("_orderby", "ID");
            paramSubCompany.put("_order", "DESC");
            List<SholdAssCompany> list = sholdAssCompanyService.findSholdAssCompanys(paramSubCompany, writablePerm).getReturnContent();
            pageParam.setItems(list);
            model.addAttribute("pageParam", pageParam);
        } catch (Exception e) {
            LOGGER.error("Error occurred while finding SholdAssCompanys", e);
            model.addAttribute("errorMsg", "系统内部异常");
        }
        return "/o2o/sholdAssCompany/findList";
    }

    @RequestMapping(value = "/sholdAssCompany/readOnlySholdAssCompanysForShold")
    public String findReadOnlySholdAssCompanysForShold(Model model, Integer page, Long shareholderId,
            HttpServletRequest req) throws BusinessException {
        LOGGER.debug("start method<findReadOnlySholdAssCompanysForShold>");
        Map<String, Object> paramSubCompany = new HashMap<String, Object>();

        // 根据writablePerm编辑或审核权限的，显示之前已经审核通过的信息。
        paramSubCompany.put("writablePerm", false);
        paramSubCompany.put("shareholderId", shareholderId);
        paramSubCompany.put("cancelFlag", Constants.VALID_STATUS);
        try{
            int count = sholdAssCompanyService.findReadOnlySholdAssCompanyCountForShold(paramSubCompany).getReturnContent();
            if(count == 0) {
                return "/o2o/subCompany/showSholdAssCompanys";
            }
            int pagenum = page == null ? 1 : page;
            Page<SholdAssCompany> pageParam = Page.page(count, 10, pagenum);
            pageParam.buildUrl(req);
            paramSubCompany.put("_start", pageParam.getStartRowsMySql());
            paramSubCompany.put("_pageSize", pageParam.getPageSize());
            paramSubCompany.put("_orderby", "ID");
            paramSubCompany.put("_order", "DESC");
            List<SholdAssCompany> list = sholdAssCompanyService.findReadOnlySholdAssCompanysForShold(paramSubCompany).getReturnContent();
            pageParam.setItems(list);
            model.addAttribute("pageParam", pageParam);
        } catch (Exception e) {
            LOGGER.error("Error occurred while finding ReadOnlySholdAssCompanysForShold", e);
            model.addAttribute("errorMsg", "系统内部异常");
        }
        return "/o2o/subCompany/showSholdAssCompanys";
    }

    /**
     * 保存单个股东关联公司基本信息
     * 
     * @param model
     * @param subCompany
     * @param locations
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/sholdAssCompany", method = RequestMethod.POST)
    @ResponseBody
    public Object saveSholdAssCompany(Model model, SholdAssCompany sholdAssCompany, String[] locations,
            HttpServletRequest req, HttpServletResponse res) {
        Map<String, Object> attributes = new HashMap<String, Object>();
        try {
            // 设置创建人
            sholdAssCompany.setCreateUser(this.getLoginUserId());
            Long companyId = sholdAssCompanyService.saveSholdAssCompany(sholdAssCompany).getReturnContent();
            attributes.put("companyId", companyId);
        } catch (Exception e) {
            LOGGER.error("Error occurred while saving sholdAssCompany", e);
            return new ResultMessage(ResultMessage.ERROR, "系统内部异常");
        }
        return new ResultMessage(attributes, ResultMessage.SUCCESS, "保存成功");
    }

    /**
     * 跳转到股东关联公司信息维护页面
     * 
     * @param model
     * @param subCompanyId
     * @param type
     *            包含有三种情况：READONLY,WRITABLE,COMPARED
     * @return
     */
    @RequestMapping(value = "/sholdAssCompany/showMaintain")
    public String showMaintain(Model model, Long companyId, String type) throws BusinessException {
        try {
            model.addAttribute("companyId", companyId);
            // 如果股东关联公司有ID且type是COMPARED的时候，需要知道哪些内容是需要审批的。
            if (null != companyId && VIEWTYPE.COMPARED.name().equalsIgnoreCase(type)) {
                Map<String, Integer> resultMap = sholdAssCompanyService.findBakValCounts(companyId).getReturnContent();
                for (String s : resultMap.keySet()) {
                    model.addAttribute(s, resultMap.get(s));
                }
            }
            model.addAttribute("type", type);
        }catch(Exception e){
            LOGGER.error("Error occurred while showing SholdAssCompany maintain.", e);
            model.addAttribute("errorMsg", "系统内部异常");
        }
        return "/o2o/sholdAssCompany/showMaintain";
    }

    /**
     * 跳转到新增股东关联公司信息页面
     * 
     * @return
     * @throws BusinessException
     */
    @RequestMapping(value = "/sholdAssCompany/showAddAssCompany")
    public String showAddAssoCompany(Model model) throws BusinessException {
        model.addAttribute("aptitudeTypes", ConstantEnums.APTITUDETYPE.values());
        return "/o2o/sholdAssCompany/showAddAssCompany";
    }

    /**
     * 显示审核股东关联公司弹框
     * 
     * @return
     * @throws BusinessException
     */
    @RequestMapping(value = "/sholdAssCompany/showAduitDialog")
    public String showAduitDialog(Model model, Long id) throws BusinessException {
        model.addAttribute("id", id);
        model.addAttribute("type", DATATYPE.ASSCO_CO.name());
        return "/o2o/auditForm";
    }

    /**
     * 跳转到修改股东关联公司信息页面
     * 
     * @return
     * @throws BusinessException
     */
    @RequestMapping(value = "/sholdAssCompany/showUpdateAssCompany")
    public String showUpdateAssoCompany(Model model, Long companyId, String type) throws BusinessException {
        model.addAttribute("aptitudeTypes", ConstantEnums.APTITUDETYPE.values());
        Map<String, SholdAssCompany> sholdAssCompanyMap = null;
        SholdAssCompany sholdAssCompany = null;
        try {
            if (null == companyId || companyId.intValue() == 0) {
                throw new RuntimeException("Invalid companyId.");
            }
            sholdAssCompanyMap = sholdAssCompanyService.findBySholdAssCompanyId(companyId, type).getReturnContent();
            sholdAssCompany = sholdAssCompanyMap.get("sholdAssCompany");
        } catch (Exception e) {
            LOGGER.error("Error occurred while showing update subCompany page.", e);
            model.addAttribute("errorMsg", "系统内部异常");
            sholdAssCompany = new SholdAssCompany();
        }
        model.addAttribute("sholdAssCompany", sholdAssCompany);
        if (null != sholdAssCompanyMap && sholdAssCompanyMap.containsKey("oldSholdAssCompany")) {
            model.addAttribute("oldSholdAssCompany", sholdAssCompanyMap.get("oldSholdAssCompany"));
        }
        model.addAttribute("type", type);
        model.addAttribute("companyId", companyId);
        return "/o2o/sholdAssCompany/showUpdateAssCompany";
    }

    /**
     * 更新股东关联公司信息
     * 
     * @return
     */
    @RequestMapping(value = "/sholdAssCompany/edit", method = RequestMethod.POST)
    @ResponseBody
    public Object updateSholdAssCompany(SholdAssCompany sholdAssCompany) throws BusinessException {
        LOGGER.debug("start method<updateSholdAssCompany>");
        Map<String, Object> attributes = new HashMap<String, Object>();
        try {
            sholdAssCompany.setUpdateUser(this.getLoginUserId());
            Long companyId = sholdAssCompanyService.updateSholdAssCompany(sholdAssCompany).getReturnContent();
            attributes.put("companyId", companyId);
        } catch (Exception e) {
            LOGGER.error("Error occurred while updating sholdAssCompany", e);
            return new ResultMessage(ResultMessage.ERROR, "系统内部异常");
        }
        return new ResultMessage(attributes, ResultMessage.SUCCESS, "保存成功");
    }

    /**
     * 改变股东关联公司信息审核状态
     * 
     * @param model
     * @param subCompanyInfo
     * @return
     */
    @RequestMapping(value = "/sholdAssCompany/audit")
    @ResponseBody
    public Object updateAuditStatus(Model model, SholdAssCompany sholdAssCompany, String memo) {
        LOGGER.info("start method: updateAuditStatus.");
        if (LOGGER.isInfoEnabled()) {
            LOGGER.info("sholdAssCompany:" + sholdAssCompany + ";memo:" + memo);
        }
        try {
            sholdAssCompany.setUpdateUser(this.getLoginUserId());
            sholdAssCompanyService.updateSholdAssCompanyAuditStatus(sholdAssCompany, memo);
        } catch (Exception e) {
            LOGGER.error("Error occurred while updating the audit status of sholdAssCompany", e);
            return new ResultMessage(ResultMessage.ERROR, "系统内部异常");
        }
        return new ResultMessage(ResultMessage.SUCCESS, "保存成功");
    }
}
