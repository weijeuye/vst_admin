package com.lvmama.vst.back.o2o.web;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.client.o2o.service.SubCompanyClientService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.o2o.po.SubCompany;
import com.lvmama.vst.back.o2o.utils.ConstantEnums;
import com.lvmama.vst.back.o2o.utils.ConstantEnums.DATATYPE;
import com.lvmama.vst.back.o2o.utils.ConstantEnums.VIEWTYPE;
import com.lvmama.vst.comm.utils.json.JSONOutput;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;

@Controller
@RequestMapping("/o2o")
public class SubCompanyAction extends BaseActionSupport {
    private static final long serialVersionUID = -6188629544886748032L;
    private static final Logger LOGGER = LoggerFactory.getLogger(SubCompanyAction.class);

    @Autowired
    private SubCompanyClientService subCompanyService;

    /**
     * 获得子公司列表
     * 
     * @param model
     * @param page
     *            分页参数
     * @param writablePerm
     *            可写权限
     * @param subCompany
     *            查询条件：包括子公司名称，地区，子公司状态，审核状态
     * @param req
     * @return
     */
    @RequestMapping(value = "/subCompanys")
    public String findSubCompanys(Model model, Integer page, Boolean writablePerm, SubCompany subCompany,
            HttpServletRequest req) throws BusinessException {
        LOGGER.debug("start method<findSubCompanys>");
        try {
            model.addAttribute("auditTypes", ConstantEnums.AUDITTYPE.values());
            model.addAttribute("subCompany", subCompany);
            if (null == subCompany || null == subCompany.getName()) {
                return "/o2o/subCompany/findList";
            }
            Map<String, Object> paramSubCompany = new HashMap<String, Object>();

            // 根据writablePerm编辑或审核权限的，显示之前已经审核通过的信息。
            writablePerm = BooleanUtils.isTrue(writablePerm);
            paramSubCompany.put("writablePerm", writablePerm);

            paramSubCompany.put("name", subCompany.getName()); // 子公司名称
            paramSubCompany.put("cancelFlag", "Y");

            if (StringUtils.isNotEmpty(subCompany.getAuditStatus())) {
                paramSubCompany.put("auditStatus", subCompany.getAuditStatus()); // 审核状态
            }
            if (StringUtils.isNotEmpty(subCompany.getCoStatus())) {
                paramSubCompany.put("coStatus", subCompany.getCoStatus()); // 子公司合作状态
            }
            if (StringUtils.isNotEmpty(subCompany.getCompanyLocation())) {
                List<String> locations = new ArrayList<String>();
                locations.addAll(Arrays.asList(subCompany.getCompanyLocation().split(" ")));
                paramSubCompany.put("locations", locations); // 子公司所在地
            }
            int count = subCompanyService.findSubCompanyCount(paramSubCompany).getReturnContent();
            
            int pagenum = page == null ? 1 : page;
            Page<SubCompany> pageParam = Page.page(count, 10, pagenum);
            pageParam.buildUrl(req);
            paramSubCompany.put("_start", pageParam.getStartRowsMySql());
            paramSubCompany.put("_pageSize", pageParam.getPageSize());
            //paramSubCompany.put("_end", pageParam.getEndRows());
            paramSubCompany.put("_orderby", "ID");
            paramSubCompany.put("_order", "DESC");
            List<SubCompany> list = subCompanyService.findSubCompanys(paramSubCompany, writablePerm).getReturnContent();
            for (SubCompany item : list) {
                item.setCompanyLocation(StringUtils.replace(item.getCompanyLocation(), "<br/>", " "));
            }
            pageParam.setItems(list);
            model.addAttribute("pageParam", pageParam);
        } catch (Exception e) {
            LOGGER.error("Error occurred while finding SubCompanys.", e);
            model.addAttribute("errorMsg", "系统内部异常");
        }
        return "/o2o/subCompany/findList";
    }

    /**
     * 保存单个子公司基本信息
     * 
     * @param model
     * @param subCompany
     * @param locations
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/subCompany", method = RequestMethod.POST)
    @ResponseBody
    public Object savesubCompany(Model model, SubCompany subCompany, String[] locations, HttpServletRequest req,
            HttpServletResponse res) {
        Map<String, Object> attributes = new HashMap<String, Object>();
        try { // 将页面上locations数组转成字符串用<br/>隔开
            subCompany.setCompanyLocation(StringUtils.join(locations, "<br/>"));
            // 设置创建人
            subCompany.setCreateUser(this.getLoginUserId());
            Long subCompanyId = subCompanyService.saveSubCompany(subCompany).getReturnContent();

            attributes.put("subCompanyId", subCompanyId);
        } catch (Exception e) {
            LOGGER.error("Error occurred while saving subCompany", e);
            return new ResultMessage(ResultMessage.ERROR, "系统内部异常");
        }
        return new ResultMessage(attributes, ResultMessage.SUCCESS, "保存成功");
    }

    /**
     * 跳转到子公司信息维护页面
     * 
     * @param model
     * @param subCompanyId
     * @param type
     *            包含有三种情况：READONLY,WRITABLE,COMPARED
     * @return
     */
    @RequestMapping(value = "/subCompany/showMaintain")
    public String showMaintain(Model model, Long subCompanyId, String type) throws BusinessException {
        model.addAttribute("subCompanyId", subCompanyId);
        // 如果子公司有ID且type是COMPARED的时候，需要知道哪些内容是需要审批的。
        try {
            if (null != subCompanyId && VIEWTYPE.COMPARED.name().equalsIgnoreCase(type)) {
                Map<String, Integer> resultMap = subCompanyService.findBakValCounts(subCompanyId).getReturnContent();
                for (String s : resultMap.keySet()) {
                    model.addAttribute(s, resultMap.get(s));
                }
            }
        } catch (Exception e) {
            LOGGER.error("Error occurred while showing subCompany maintain", e);
            model.addAttribute("errorMsg", "系统内部异常");
        }
        model.addAttribute("type", type);
        return "/o2o/subCompany/showMaintain";
    }

    /**
     * 跳转到新增子公司信息页面
     * 
     * @return
     * @throws BusinessException
     */
    @RequestMapping(value = "/subCompany/showAddSubCompany")
    public String showAddSubCompany(Model model) throws BusinessException {
        model.addAttribute("aptitudeTypes", ConstantEnums.APTITUDETYPE.values());
        return "/o2o/subCompany/showAddSubCompany";
    }

    /**
     * 显示审核子公司弹框
     * 
     * @return
     * @throws BusinessException
     */
    @RequestMapping(value = "/subCompany/showAduitDialog")
    public String showAduitDialog(Model model, Long id) throws BusinessException {
        model.addAttribute("id", id);
        model.addAttribute("type", DATATYPE.SUB_CO.name());
        return "/o2o/auditForm";
    }

    /**
     * 跳转到修改子公司信息页面
     * 
     * @return
     * @throws BusinessException
     */
    @RequestMapping(value = "/subCompany/showUpdateSubCompany")
    public String showUpdateSubCompany(Model model, Long subCompanyId, String type) throws BusinessException {
        model.addAttribute("aptitudeTypes", ConstantEnums.APTITUDETYPE.values());
        Map<String, SubCompany> subCompanyMap = null;
        List<String> oldLocations = null;
        List<String> locations = null;
        SubCompany subCompany = null;
        try {
            subCompanyMap = subCompanyService.findBySubCompanyId(subCompanyId, type).getReturnContent();
            SubCompany oldSubCompany = subCompanyMap.get("oldSubCompany");
            subCompany = subCompanyMap.get("subCompany");
            if (null != oldSubCompany && StringUtils.isNotEmpty(oldSubCompany.getCompanyLocation())) {
                oldLocations = Arrays.asList(oldSubCompany.getCompanyLocation().split("<br/>", 4));
            }
            if (null != subCompany && StringUtils.isNotEmpty(subCompany.getCompanyLocation())) {
                locations = Arrays.asList(subCompany.getCompanyLocation().split("<br/>", 4));
            }
        } catch (Exception e) {
            LOGGER.error("Error occurred while showing update subCompany page.", e);
            model.addAttribute("errorMsg", "系统内部异常");
            subCompany = new SubCompany();
            // 设置四个空白字串以便在页面显示
            locations = Arrays.asList(",,,".split(",", 4));
        }
        model.addAttribute("subCompany", subCompany);
        model.addAttribute("locations", locations);
        if (null != subCompanyMap && subCompanyMap.containsKey("oldSubCompany")) {
            model.addAttribute("oldSubCompany", subCompanyMap.get("oldSubCompany"));
            model.addAttribute("oldLcations", oldLocations);
        }
        model.addAttribute("type", type);
        return "/o2o/subCompany/showUpdateSubCompany";
    }

    /**
     * 更新子公司信息
     * 
     * @return
     */
    @RequestMapping(value = "/subCompany/edit", method = RequestMethod.POST)
    @ResponseBody
    public Object updateSubCompany(SubCompany subCompany, String[] locations) throws BusinessException {
        LOGGER.debug("start method<updateSubCompany>");
        Map<String, Object> attributes = new HashMap<String, Object>();
        try { // 将页面上locations数组转成字符串用<br/>隔开
            subCompany.setCompanyLocation(StringUtils.join(locations, "<br/>"));
            subCompany.setUpdateUser(this.getLoginUserId());
            Long subCompanyId = subCompanyService.updateSubCompany(subCompany).getReturnContent();
            attributes.put("subCompanyId", subCompanyId);
        } catch (Exception e) {
            LOGGER.error("Error occurred while updating subCompany", e);
            return new ResultMessage(ResultMessage.ERROR, "系统内部异常");
        }
        return new ResultMessage(attributes, ResultMessage.SUCCESS, "保存成功");
    }

    /**
     * 改变子公司信息审核状态
     * 
     * @param model
     * @param subCompanyInfo
     * @return
     */
    @RequestMapping(value = "/subCompany/audit")
    @ResponseBody
    public Object updateAuditStatus(Model model, SubCompany subCompany, String memo) {
        LOGGER.info("start method: updateAuditStatus.");
        if (LOGGER.isInfoEnabled()) {
            LOGGER.info("subCompany:" + subCompany + ";memo:" + memo);
        }
        try {
            subCompany.setUpdateUser(this.getLoginUserId());
            subCompanyService.updateSubCompanyAuditStatus(subCompany, memo);
        } catch (Exception e) {
            LOGGER.error("Error occurred while updating the audit status of subCompany", e);
            return new ResultMessage(ResultMessage.ERROR, "系统内部异常");
        }
        return new ResultMessage(ResultMessage.SUCCESS, "保存成功");
    }
    
	/**
	 * 子公司联想查询
	 * @param search
	 * @param response
	 * @throws BusinessException
	 */
	@RequestMapping(value="/querySubCompanySuggest.do")
	public void querySubCompanySuggest(String search,HttpServletResponse response) throws BusinessException{
		Map<String, Object> paraMap = new HashMap<String, Object>();
		
		paraMap.put("cancelFlag", "Y");
		paraMap.put("name", search);
		paraMap.put("_orderby", "ID");
		paraMap.put("_order", "DESC");
		
		List<SubCompany> subCompanyList = subCompanyService.findSubCompanys(paraMap,  false).getReturnContent();
		
		JSONArray array = new JSONArray();
		if(CollectionUtils.isNotEmpty(subCompanyList)){
			for(SubCompany e:subCompanyList){
				JSONObject obj=new JSONObject();
				obj.put("id", e.getId());
				obj.put("text", e.getName());
				array.add(obj);
			}
		}
		JSONOutput.writeJSON(response, array);
	}
}
