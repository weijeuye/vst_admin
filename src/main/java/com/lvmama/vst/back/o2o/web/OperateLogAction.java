package com.lvmama.vst.back.o2o.web;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.lvmama.vst.back.client.o2o.service.OperateLogClientService;
import com.lvmama.vst.back.o2o.po.OperateLog;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

@Controller
@RequestMapping("/o2o")
public class OperateLogAction extends BaseActionSupport {

    private static final long serialVersionUID = 9106149623333349400L;
    private static final Logger LOGGER = LoggerFactory.getLogger(OperateLogAction.class);

    @Autowired
    private OperateLogClientService operateLogService;

    /**
     * 获得日志列表
     * 
     * @param model
     * @param page
     * @param param
     * @param req
     * @return
     * @throws BusinessException
     */
    @RequestMapping(value = "/findOperateLogs")
    public String findOperateLogs(Model model, Integer page, String param, HttpServletRequest req)
            throws BusinessException {
        LOGGER.debug("start method<OperateLogAction#findOperateLogs>");
        try {
            Map<String, Object> paramsMap = new HashMap<String, Object>();
            if (null != param && !"".equals(param)) {
                JSONObject jsonObject = JSONObject.fromObject(param);
                for (Iterator<?> iter = jsonObject.keys(); iter.hasNext();) {
                    String key = (String) iter.next();
                    String value = jsonObject.get(key).toString();
                    paramsMap.put(key, value);
                }
            }
            Long count = Long.valueOf(operateLogService.findCountByParams(paramsMap).getReturnContent());
            int pagenum = page == null ? 1 : page;
            Page<OperateLog> pageParam = Page.page(count, 10, pagenum);
            pageParam.buildUrl(req);
            paramsMap.put("_start", pageParam.getStartRowsMySql());
            paramsMap.put("_pageSize", pageParam.getPageSize());
            //paramsMap.put("_end", pageParam.getEndRows());
            paramsMap.put("_orderby", "CREATE_TIME");
            paramsMap.put("_order", "DESC");
            List<OperateLog> operateLogList = operateLogService.findByParams(paramsMap).getReturnContent();
            if (null != operateLogList && !operateLogList.isEmpty()) {
                pageParam.setItems(operateLogList);
            }
            model.addAttribute("pageParam", pageParam);
        } catch (Exception e) {
            LOGGER.error("Error occurred while finding operate logs.", e);
            model.addAttribute("errorMsg", "系统内部异常");
        }
        return "/o2o/operateLogs";
    }
}
