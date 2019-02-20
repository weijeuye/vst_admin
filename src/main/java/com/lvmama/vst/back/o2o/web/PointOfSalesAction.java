package com.lvmama.vst.back.o2o.web;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.client.o2o.service.PointOfSalesClientService;
import com.lvmama.vst.back.o2o.po.PointOfSales;
import com.lvmama.vst.back.o2o.utils.ConstantEnums.PERMITTYPE;
import com.lvmama.vst.back.utils.Constants;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

@Controller
@RequestMapping("/o2o/subCompany")
public class PointOfSalesAction extends BaseActionSupport {

    private static final long serialVersionUID = 8362713896245356348L;
    private static final Logger LOGGER = LoggerFactory.getLogger(PointOfSalesAction.class);
    @Autowired
    private PointOfSalesClientService pointOfSalesService;

    /**
     * 跳转到维护子公司营业网点信息页面
     * 
     * @return
     * @throws BusinessException
     */
    @RequestMapping(value = "/poses")
    public String findPOSList(Model model, Long subCompanyId, Integer page, String type, String auditType,
            HttpServletRequest req) throws BusinessException {
        LOGGER.info("start findPOSList");
        model.addAttribute("subCompanyId", subCompanyId);
        model.addAttribute("auditType", auditType);
        model.addAttribute("type", type);
        try {
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("subCompanyId", subCompanyId);
            params.put("type", type);
            params.put("cancelFlag", Constants.VALID_STATUS);
            int count = pointOfSalesService.findCountByParams(params, type).getReturnContent();
            if (count == 0) {
                return "/o2o/subCompany/ShowPointOfSales";
            }
            int pagenum = page == null ? 1 : page;
            Page<PointOfSales> pageParam = Page.page(count, 10, pagenum);
            pageParam.buildUrl(req);
            params.put("_start", pageParam.getStartRowsMySql());
            params.put("_pageSize", pageParam.getPageSize());
            params.put("_orderby", "ID");
            params.put("_order", "DESC");
            List<PointOfSales> list = pointOfSalesService.findByParams(params, type).getReturnContent();
            if (null != list && list.size() > 0) {
                pageParam.setItems(list);
                model.addAttribute("pageParam", pageParam);
            }
        } catch (Exception e) {
            LOGGER.error("Error occurred while show Point of Sales.", e);
            model.addAttribute("errorMsg", "系统内部异常");
        }
        return "/o2o/subCompany/ShowPointOfSales";
    }

    /**
     * 保存营业网点
     * 
     * @param model
     * @param subCompanyId
     * @param sholdIds
     * @param relationType
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/pos", method = RequestMethod.POST)
    @ResponseBody
    public Object savePOS(Model model, PointOfSales pointOfSales, String[] locations, HttpServletRequest req,
            HttpServletResponse res) {
        Map<String, Object> attributes = new HashMap<String, Object>();
        try {
            // 将页面上locations数组转成字符串用<br/>隔开
            pointOfSales.setSalesLocation(StringUtils.join(locations, "<br/>"));
            // 设置创建人
            pointOfSales.setCreateUser(this.getLoginUserId());
            Long pointOfSalesId = pointOfSalesService.savePOS(pointOfSales).getReturnContent();
            attributes.put("posId", pointOfSalesId);
        } catch (Exception e) {
            LOGGER.error("Error occurred while saving point of sales", e);
            return new ResultMessage(ResultMessage.ERROR, "系统内部异常");
        }
        return new ResultMessage(attributes, ResultMessage.SUCCESS, "保存成功");
    }

    /**
     * 显示新增营业网点
     * 
     * @param model
     * @param subCompanyId
     * @param relationType
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/showPOSForm")
    public Object showPOSForm(Model model, Long subCompanyId, Long id, String type, String auditType,
            HttpServletRequest req, HttpServletResponse res) {
        LOGGER.info("start showContractForm");
        model.addAttribute("subCompanyId", subCompanyId);
        model.addAttribute("auditType", auditType);
        model.addAttribute("type", type);
        model.addAttribute("permitTypes", PERMITTYPE.values());
        Map<String, PointOfSales> posMap = null;
        List<String> oldLocations = null;
        List<String> locations = null;
        PointOfSales pos = null;
        try {
            if (null != id && !id.equals(0l)) {
                posMap = pointOfSalesService.getPOSById(id, type).getReturnContent();
                if (null == posMap) {
                    throw new BusinessException("Error occurred while getting PointOfSales with id:" + id);
                }

                pos = posMap.get("pos");
                PointOfSales oldPos = posMap.get("oldPos");

                if (null != pos && StringUtils.isNotEmpty(pos.getSalesLocation())) {
                    locations = Arrays.asList(pos.getSalesLocation().split("<br/>", 4));
                }
                if (null != oldPos && StringUtils.isNotEmpty(oldPos.getSalesLocation())) {
                    oldLocations = Arrays.asList(oldPos.getSalesLocation().split("<br/>", 4));
                } else {
                    oldLocations = Arrays.asList(",,,".split(",", 4));
                }
            }
        } catch (Exception e) {
            LOGGER.error(e.getMessage(), e);
            model.addAttribute("errorMsg", "系统内部异常");
            pos = new PointOfSales();
        }
        if (null == locations) {
            // 设置四个空白字串以便在页面显示
            locations = Arrays.asList(",,,".split(",", 4));
        }
        model.addAttribute("pos", pos);
        model.addAttribute("locations", locations);
        if (null != posMap && posMap.containsKey("oldPos")) {
            model.addAttribute("oldPos", posMap.get("oldPos"));
            model.addAttribute("oldLcations", oldLocations);
        }
        return "/o2o/subCompany/posForm";
    }

    /**
     * 修改营业网点
     * 
     * @param model
     * @param shareholderInfo
     * @param locations
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/pos/edit", method = RequestMethod.POST)
    @ResponseBody
    public Object updatePOS(Model model, PointOfSales pointOfSales, String[] locations, HttpServletRequest req,
            HttpServletResponse res) {
        Map<String, Object> attributes = new HashMap<String, Object>();
        try {
            // 将页面上locations数组转成字符串用<br/>隔开
            pointOfSales.setSalesLocation(StringUtils.join(locations, "<br/>"));
            // 设置创建人
            pointOfSales.setUpdateUser(this.getLoginUserId());
            Long pointOfSalesId = pointOfSalesService.updatePointOfSales(pointOfSales).getReturnContent();
            attributes.put("posId", pointOfSalesId);
        } catch (Exception e) {
            LOGGER.error("Error occurred while updating point of sales", e);
            return new ResultMessage(ResultMessage.ERROR, "系统内部异常");
        }
        return new ResultMessage(attributes, ResultMessage.SUCCESS, "保存成功");
    }

    /**
     * 删除营业网点
     * 
     * @param model
     * @param pointOfSales
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/pos/remove", method = RequestMethod.POST)
    @ResponseBody
    public Object removePOS(Model model, PointOfSales pointOfSales, HttpServletRequest req, HttpServletResponse res) {
        Map<String, Object> attributes = new HashMap<String, Object>();
        try {
            // 设置操作人
            pointOfSales.setUpdateUser(this.getLoginUserId());
            Long pointOfSalesId = pointOfSalesService.updatePOSForRemove(pointOfSales).getReturnContent();
            attributes.put("posId", pointOfSalesId);
        } catch (Exception e) {
            LOGGER.error("Error occurred while deleting point of sales", e);
            return new ResultMessage(ResultMessage.ERROR, "系统内部异常");
        }
        return new ResultMessage(attributes, ResultMessage.SUCCESS, "保存成功");
    }
}
