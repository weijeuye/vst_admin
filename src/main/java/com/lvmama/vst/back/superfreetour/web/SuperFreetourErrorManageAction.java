package com.lvmama.vst.back.superfreetour.web;

import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.superfreetour.po.SuperFreetourErrorInfo;
import com.lvmama.vst.superfreetour.service.SuperFreetourErrorManageClientService;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/superfreetour/errorManage")
public class SuperFreetourErrorManageAction  extends BaseActionSupport {

    private static final long serialVersionUID = -5883478326721523916L;

    private static final Log LOG = LogFactory.getLog(SuperFreetourErrorManageAction.class);

    private static final String SHOW_ERROR_MANAGE_PAGE = "superfreetour/errorManage/errorManagePage";

    @Autowired
    private SuperFreetourErrorManageClientService errorManageClientService;

    /**
     * 查询错误信息列表页
     */
    @RequestMapping(value = "/findErrorInfoList")
    public String findErrorInfoList(Model model, Integer page, HttpServletRequest request, String redirectType, SuperFreetourErrorInfo errorInfo) {
        model.addAttribute("errorInfo", errorInfo);
        if (page == null && StringUtil.isEmptyString(redirectType)) {
            model.addAttribute("redirectType", "1");
            return SHOW_ERROR_MANAGE_PAGE;
        }

        Map<String, Object> params = new HashMap<String, Object>();
        if (errorInfo != null) {
            if (StringUtils.isNotEmpty(errorInfo.getErrorPlace())) {
                params.put("errorPlace",errorInfo.getErrorPlace());
            }
            if (errorInfo.getProductId() != null) {
                params.put("productId",errorInfo.getProductId());
            }
            if (errorInfo.getSuppGoodsId() != null) {
                params.put("suppGoodsId",errorInfo.getSuppGoodsId());
            }
            if (StringUtils.isNotEmpty(errorInfo.getErrorMessage())) {
                params.put("errorMessage",errorInfo.getErrorMessage());
            }
        }

        long count = errorManageClientService.findErrorInfoCountByParam(params);

        int pagenum = page == null ? 1 : page;
        Page pageParam = Page.page(count, 50, pagenum);
        if (count > 0) {
            pageParam.buildUrl(request);
            params.put("_start", pageParam.getStartRows());
            params.put("_end", pageParam.getEndRows());

            List<SuperFreetourErrorInfo> errorInfoList = errorManageClientService.findErrorInfoListByParam(params);
            pageParam.setItems(errorInfoList);
        }
        model.addAttribute("pageParam", pageParam);
        model.addAttribute("redirectType", "1");
        model.addAttribute("page", page);
        return SHOW_ERROR_MANAGE_PAGE;

    }


}
