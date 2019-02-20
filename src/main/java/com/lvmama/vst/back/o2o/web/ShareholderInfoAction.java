package com.lvmama.vst.back.o2o.web;

import java.util.Arrays;
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

import com.lvmama.vst.back.client.o2o.service.ShareholderInfoClientService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.o2o.po.ShareholderInfo;
import com.lvmama.vst.back.o2o.utils.ConstantEnums;
import com.lvmama.vst.back.o2o.utils.ConstantEnums.DATATYPE;
import com.lvmama.vst.back.o2o.utils.ConstantEnums.VIEWTYPE;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;

@Controller
@RequestMapping("/o2o")
public class ShareholderInfoAction extends BaseActionSupport {
    private static final long serialVersionUID = -6188629544886748032L;
    private static final Logger LOGGER = LoggerFactory.getLogger(ShareholderInfoAction.class);

    @Autowired
    private ShareholderInfoClientService shareholderInfoService;

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
    @RequestMapping(value = "/shareholder/findList")
    public String findShareholders(Model model, Integer page, Boolean writablePerm, ShareholderInfo shareholderInfo,
            HttpServletRequest req) throws BusinessException {
        LOGGER.debug("start method<findShareholders>");
        model.addAttribute("sholdTypes", ConstantEnums.SHOLDTYPE.values());
        model.addAttribute("auditTypes", ConstantEnums.AUDITTYPE.values());
        model.addAttribute("shareholder", shareholderInfo);
        if (null == shareholderInfo || null == shareholderInfo.getName()) {
            return "/o2o/shareholder/findList";
        }
        Map<String, Object> paramShareholder = new HashMap<String, Object>();

        // 根据writablePerm编辑或审核权限的，显示之前已经审核通过的信息。
        writablePerm = BooleanUtils.isTrue(writablePerm);
        paramShareholder.put("writablePerm", writablePerm);

        paramShareholder.put("name", shareholderInfo.getName()); // 股东名称
        paramShareholder.put("sholdType", shareholderInfo.getSholdType()); // 股东类型
        paramShareholder.put("cancelFlag", "Y"); // 股东状态

        if (StringUtils.isNotEmpty(shareholderInfo.getAuditStatus())) {
            paramShareholder.put("auditStatus", shareholderInfo.getAuditStatus()); // 审核状态
        }
        if (StringUtils.isNotEmpty(shareholderInfo.getSholdStatus())) {
            paramShareholder.put("sholdStatus", shareholderInfo.getSholdStatus()); // 合作状态
        }
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
            model.addAttribute("pageParam", pageParam);
        } catch (Exception e) {
            LOGGER.error("Error occurred while finding Shareholders", e);
            model.addAttribute("errorMsg", "系统内部异常");
        }
        return "/o2o/shareholder/findList";
    }

    /**
     * 保存单个股东基本信息
     * 
     * @param model
     * @param shareholderInfo
     * @param locations
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/shareholder", method = RequestMethod.POST)
    @ResponseBody
    public Object saveShareholder(Model model, ShareholderInfo shareholderInfo, String[] locations,
            HttpServletRequest req, HttpServletResponse res) {
        Map<String, Object> attributes = new HashMap<String, Object>();
        try {// 将页面上locations数组转成字符串用<br/>隔开
            shareholderInfo.setSholdLocation(StringUtils.join(locations, "<br/>"));
            // 设置创建人
            shareholderInfo.setCreateUser(this.getLoginUserId());
            Long shareholderId = shareholderInfoService.saveShareholderInfo(shareholderInfo).getReturnContent();

            attributes.put("shareholderId", shareholderId);
        } catch (Exception e) {
            LOGGER.error("Error occurred while saving ShareholderInfo", e);
            return new ResultMessage(ResultMessage.ERROR, "系统内部异常");
        }
        return new ResultMessage(attributes, ResultMessage.SUCCESS, "保存成功");
    }

    /**
     * 跳转到股东信息维护页面
     * 
     * @param model
     * @param shareholderId
     * @param type
     *            包含有三种情况：readOnly,writable,compared
     * @return
     */
    @RequestMapping(value = "/shareholder/showMaintain")
    public String showMaintain(Model model, Long shareholderId, String type) throws BusinessException {
        model.addAttribute("shareholderId", shareholderId);
        try {
            if (null != shareholderId && VIEWTYPE.COMPARED.name().equalsIgnoreCase(type)) {
                Map<String, Integer> resultMap = shareholderInfoService.findBakValCounts(shareholderId).getReturnContent();
                for (String s : resultMap.keySet()) {
                    model.addAttribute(s, resultMap.get(s));
                }
            }
        } catch (Exception e) {
            LOGGER.error("Error occurred while show maintain", e);
            model.addAttribute("errorMsg", "系统内部异常");
        }
        model.addAttribute("type", type);
        return "/o2o/shareholder/showMaintain";
    }

    /**
     * 跳转到新增股东信息页面
     * 
     * @return
     * @throws BusinessException
     */
    @RequestMapping(value = "/shareholder/showAddShareholder")
    public String showAddShareholder(Model model) throws BusinessException {
        model.addAttribute("sholdTypes", ConstantEnums.SHOLDTYPE.values());
        return "/o2o/shareholder/showAddShareholder";
    }

    /**
     * 显示审核股东弹框
     * 
     * @return
     * @throws BusinessException
     */
    @RequestMapping(value = "/shareholder/showAduitDialog")
    public String showAduitDialog(Model model, Long id) throws BusinessException {
        model.addAttribute("id", id);
        model.addAttribute("type", DATATYPE.SHOLD.name());
        return "/o2o/auditForm";
    }

    /**
     * 跳转到修改股东信息页面
     * 
     * @return
     * @throws BusinessException
     */
    @RequestMapping(value = "/shareholder/showUpdateShareholder")
    public String showUpdateShareholder(Model model, Long shareholderId, String type) throws BusinessException {
        model.addAttribute("sholdTypes", ConstantEnums.SHOLDTYPE.values());
        Map<String, ShareholderInfo> shareholderMap = null;
        List<String> oldLocations = null;
        List<String> locations = null;
        ShareholderInfo shareholder = null;
        try {
            shareholderMap = shareholderInfoService.findByShareholderInfoId(shareholderId, type).getReturnContent();
            ShareholderInfo oldShareholder = shareholderMap.get("oldShareholder");
            shareholder = shareholderMap.get("shareholder");
            if (null != oldShareholder && StringUtils.isNotEmpty(oldShareholder.getSholdLocation())) {
                oldLocations = Arrays.asList(oldShareholder.getSholdLocation().split("<br/>", 4));
            }
            if (null != shareholder && StringUtils.isNotEmpty(shareholder.getSholdLocation())) {
                locations = Arrays.asList(shareholder.getSholdLocation().split("<br/>", 4));
            }
        } catch (Exception e) {
            LOGGER.error("Error occurred while showing update shareholder page.", e);
            model.addAttribute("errorMsg", "系统内部异常");
            shareholder = new ShareholderInfo();
            // 设置四个空白字串以便在页面显示
            locations = Arrays.asList(",,,".split(",", 4));
        }
        model.addAttribute("shareholder", shareholder);
        model.addAttribute("locations", locations);
        if (null != shareholderMap && shareholderMap.containsKey("oldShareholder")) {
            model.addAttribute("oldShareholder", shareholderMap.get("oldShareholder"));
            model.addAttribute("oldLcations", oldLocations);
        }
        model.addAttribute("type", type);
        return "/o2o/shareholder/showUpdateShareholder";
    }

    /**
     * 更新股东信息
     * 
     * @return
     */
    @RequestMapping(value = "/shareholder/edit", method = RequestMethod.POST)
    @ResponseBody
    public Object updateShareholder(ShareholderInfo shareholderInfo, String[] locations) throws BusinessException {
        LOGGER.debug("start method<updateShareholder>");
        Map<String, Object> attributes = new HashMap<String, Object>();
        try { // 将页面上locations数组转成字符串用<br/>隔开
            shareholderInfo.setSholdLocation(StringUtils.join(locations, "<br/>"));
            shareholderInfo.setUpdateUser(this.getLoginUserId());
            Long shareholderId = shareholderInfoService.updateShareholder(shareholderInfo).getReturnContent();
            attributes.put("shareholderId", shareholderId);
        } catch (Exception e) {
            LOGGER.error("Error occurred while updating Shareholder", e);
            return new ResultMessage(ResultMessage.ERROR, "系统内部异常");
        }
        return new ResultMessage(attributes, ResultMessage.SUCCESS, "保存成功");
    }

    /**
     * 改变股东信息审核状态
     * 
     * @param model
     * @param shareholderInfo
     * @return
     */
    @RequestMapping(value = "/shareholder/audit")
    @ResponseBody
    public Object updateAuditStatus(Model model, ShareholderInfo shareholder, String memo) {
        LOGGER.info("start method: updateAuditStatus.");
        if (LOGGER.isInfoEnabled()) {
            LOGGER.info("shareholder:" + shareholder + ";memo:" + memo);
        }
        try {
            shareholder.setUpdateUser(this.getLoginUserId());
            shareholderInfoService.updateShareholderAuditStatus(shareholder, memo);
        } catch (Exception e) {
            LOGGER.error("Error occurred while updating the audit status of Shareholder", e);
            return new ResultMessage(ResultMessage.ERROR, "系统内部异常");
        }
        return new ResultMessage(ResultMessage.SUCCESS, "保存成功");
    }
}
