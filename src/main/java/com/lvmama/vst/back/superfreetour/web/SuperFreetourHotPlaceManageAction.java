package com.lvmama.vst.back.superfreetour.web;

import com.alibaba.fastjson.JSONObject;
import com.lvmama.vst.back.biz.po.BizDistrict;
import com.lvmama.vst.back.biz.po.BizDistrictSign;
import com.lvmama.vst.back.client.biz.service.DistrictClientService;
import com.lvmama.vst.back.client.biz.service.DistrictSignClientService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.utils.web.HttpsUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.superfreetour.po.SuperFreetourHotPlaceInfo;
import com.lvmama.vst.superfreetour.service.SuperFreetourHotPlaceClientService;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author SuZhiguo
 * @Date created in 19:02 2018/3/7
 * @Description :超级自由行热门目的地配置管理action
 */
@Controller
@RequestMapping("/superfreetour/hotPlaceManage")
public class SuperFreetourHotPlaceManageAction  extends BaseActionSupport {

    private static final long serialVersionUID = -4186181333211620082L;

    private static final Log LOG = LogFactory.getLog(SuperFreetourHotPlaceManageAction.class);

    private static final String SHOW_ERROR_MANAGE_PAGE = "superfreetour/hotPlaceManage/hotPlaceManagePage";

    private static final String EDIT_ERROR_MANAGE_PAGE = "superfreetour/hotPlaceManage/editHotPlaceManagePage";

    private static final String CHOOSE_DEST_TAB_PAGE = "superfreetour/hotPlaceManage/chooseDestPage";

    private static final String TRAFFIC_POINT_PAGE = "superfreetour/hotPlaceManage/selectTrafficPointList";

    @Autowired
    private SuperFreetourHotPlaceClientService hotPlaceClientService;


    @Autowired
    private DistrictClientService districtClientService;

    @Autowired
    private DistrictSignClientService districtSignClientService;

    /**
     * 查询热门目的地列表页
     */
    @RequestMapping(value = "/findHotPlaceInfoList")
    public String findHotPlaceInfoList(Model model, Integer page, HttpServletRequest request, String redirectType, SuperFreetourHotPlaceInfo hotPlaceInfo) {
        model.addAttribute("hotPlaceInfo", hotPlaceInfo);
        model.addAttribute("hotDestTypeList", SuperFreetourHotPlaceInfo.HOT_DEST_TYPE.values());
        if (page == null && StringUtil.isEmptyString(redirectType)) {
            model.addAttribute("redirectType", "1");
            return SHOW_ERROR_MANAGE_PAGE;
        }

        Map<String, Object> params = new HashMap<String, Object>();
        if (hotPlaceInfo != null) {
            model.addAttribute("destType", hotPlaceInfo.getDestType());
            if (StringUtils.isNotEmpty(hotPlaceInfo.getDestName())) {
                params.put("destName",hotPlaceInfo.getDestName());
            }
            if (StringUtils.isNotEmpty(hotPlaceInfo.getDestType())) {
                params.put("destType",hotPlaceInfo.getDestType());
            }
            if (StringUtils.isNotEmpty(hotPlaceInfo.getCancleFlag())) {
                params.put("cancleFlag",hotPlaceInfo.getCancleFlag());
            }
            if (StringUtils.isNotEmpty(hotPlaceInfo.getDistrictName())) {
                params.put("districtName",hotPlaceInfo.getDistrictName());
            }
        }

        long count = hotPlaceClientService.findHotPlaceCountByParam(params);

        int pagenum = page == null ? 1 : page;
        Page pageParam = Page.page(count, 50, pagenum);
        if (count > 0) {
            pageParam.buildUrl(request);
            params.put("_start", pageParam.getStartRows());
            params.put("_end", pageParam.getEndRows());

            List<SuperFreetourHotPlaceInfo> errorInfoList = hotPlaceClientService.findHotPlaceListByParam(params);
            pageParam.setItems(errorInfoList);
        }
        model.addAttribute("pageParam", pageParam);
        model.addAttribute("page", page);
        model.addAttribute("redirectType", redirectType);

        return SHOW_ERROR_MANAGE_PAGE;
    }

    /**
     * 编辑或者新增目的地
     */
    @RequestMapping(value = "/editHotPlaceManagePage")
    public String editHotPlaceManagePage(Model model,Long hotPlaceId){
        if (hotPlaceId != null && hotPlaceId > 0) {
            model.addAttribute("hotPlaceId", hotPlaceId);
            SuperFreetourHotPlaceInfo hotPlaceInfo = hotPlaceClientService.findHotPlaceListByPremaryKey(hotPlaceId);
            if (hotPlaceInfo != null) {
                model.addAttribute("hotPlaceInfo", hotPlaceInfo);
            }
        }

        return EDIT_ERROR_MANAGE_PAGE;
    }

    /**
     * 编辑保存
     */
    @ResponseBody
    @RequestMapping(value = "/saveHotPlaceInfo")
    public Object saveHotPlaceInfo(Model model,SuperFreetourHotPlaceInfo hotPlaceInfo,String destId){
        if (hotPlaceInfo == null ) {
            LOG.error("saveHotPlaceInfo error, param hotPlaceInfo is null");
            return ResultMessage.UPDATE_FAIL_RESULT;
        }
        //编辑更新
        if (hotPlaceInfo.getHotPlaceId() != null) {
            SuperFreetourHotPlaceInfo oldHotPlaceInfo = hotPlaceClientService.findHotPlaceListByPremaryKey(hotPlaceInfo.getHotPlaceId());
            if (oldHotPlaceInfo == null) {
                LOG.error("saveHotPlaceInfo error,oldHotPlaceInfo is null,HotPlaceId is" +hotPlaceInfo.getHotPlaceId());
                return ResultMessage.UPDATE_FAIL_RESULT;
            }
            oldHotPlaceInfo.setHotNum(hotPlaceInfo.getHotNum());
            oldHotPlaceInfo.setHotPlaceAlias(hotPlaceInfo.getHotPlaceAlias());
            hotPlaceClientService.updateHotPlaceInfo(oldHotPlaceInfo);
            return ResultMessage.UPDATE_SUCCESS_RESULT;
        }
        if (StringUtils.isNotBlank(destId)) {
            try {
                //获取经纬度
                String  searchUrl = "http://php-api.lvmama.com/dest/getDestBaseInfo";
                Map<String,Object>  params = new HashMap<>();
                params.put("dest_id",destId);
                String jsonstr = HttpsUtil.requestGet(searchUrl,params);
                if (StringUtils.isNotBlank(jsonstr)) {
                    JSONObject destObj = JSONObject.parseObject(jsonstr);
                    if ("0".equals(destObj.getString("error"))) {//查询成功
                        JSONObject dataObj = destObj.getJSONObject("data");
                        if (StringUtils.isNotBlank(dataObj.getString("latitude")) && StringUtils.isNotBlank(dataObj.getString("longitude"))) {
                            hotPlaceInfo.setLatitude(Double.valueOf(dataObj.getString("latitude")));
                            hotPlaceInfo.setLongitude(Double.valueOf(dataObj.getString("longitude")));
                        } else {
                            LOG.error("saveHotPlaceInfo error,getDestBaseInfo error,jsonstr is" +jsonstr);
                            return ResultMessage.UPDATE_FAIL_RESULT;
                        }
                    }else{
                        LOG.error("saveHotPlaceInfo error,getDestBaseInfo error,jsonstr is" +jsonstr);
                        return ResultMessage.UPDATE_FAIL_RESULT;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                LOG.error("saveHotPlaceInfo error,getDestBaseInfo error,destId is" +destId);
                return ResultMessage.UPDATE_FAIL_RESULT;
            }
        }
        hotPlaceClientService.insertOneHotPlaceInfo(hotPlaceInfo);
        return ResultMessage.ADD_SUCCESS_RESULT;
    }

    /**
     * 设置状态
     */
    @ResponseBody
    @RequestMapping(value = "/changeHotPlaceCancleFlag")
    public Object changeHotPlaceCancleFlag(Model model,Long hotPlaceId,String cancleFlag){
        if (cancleFlag == null ||  hotPlaceId == null) {
            LOG.error("changeHotPlaceCancleFlag error, param is null,cancleFlag = "+cancleFlag+" ,hotPlaceId is "+hotPlaceId);
            return ResultMessage.UPDATE_FAIL_RESULT;
        }
        //更新
        SuperFreetourHotPlaceInfo oldHotPlaceInfo = hotPlaceClientService.findHotPlaceListByPremaryKey(hotPlaceId);
        if (oldHotPlaceInfo == null) {
            LOG.error("changeHotPlaceCancleFlag error, oldHotPlaceInfo is null,cancleFlag = "+cancleFlag+" ,hotPlaceId is "+hotPlaceId);
            return ResultMessage.UPDATE_FAIL_RESULT;
        }
        oldHotPlaceInfo.setCancleFlag(cancleFlag);
        hotPlaceClientService.updateHotPlaceInfo(oldHotPlaceInfo);
        return ResultMessage.UPDATE_SUCCESS_RESULT;
    }

    /**
     * 选择目的地tab
     */
    @RequestMapping(value = "/chooseDestPage")
    public String chooseDestPage(Model model){
        return CHOOSE_DEST_TAB_PAGE;
    }

    /**
     * 查询行政区
     */
    @ResponseBody
    @RequestMapping(value = "/selectParentsDistrictOfParams")
    public Object selectParentsDistrictOfParams(Model model,Long districtId){
        Map<String, Object> parameters = new HashMap<String, Object>();
        parameters.put("districtId",districtId);
        ResultHandleT<List<BizDistrict>> resultHandleT = districtClientService.selectParentsOfParams(parameters);
        if (resultHandleT ==null || resultHandleT.getReturnContent() == null) {
            LOG.error("selectParentsDistrictOfParams error, resultHandleT is null,districtId = "+districtId);
            return ResultMessage.SET_FAIL_RESULT;
        }
        List<BizDistrict> list = resultHandleT.getReturnContent();
        if (CollectionUtils.isEmpty(list)) {
            LOG.error("selectParentsDistrictOfParams error, list is null,districtId = "+districtId);
            return ResultMessage.SET_FAIL_RESULT;
        }
        StringBuilder stringBuilder = new StringBuilder();
        Map<String, Object> attrs = new HashMap<String, Object>();

        for (int i = list.size()-1; i >= 0 ; i--) {
            BizDistrict bizDistrict = list.get(i);
            if (StringUtils.isNotBlank(bizDistrict.getDistrictName())) {
                stringBuilder.append(bizDistrict.getDistrictName());
            }
            if (i != 0) {
                stringBuilder.append("-");
            }
            if (BizDistrict.DISTRICT_TYPE.CITY.getCode().equals(bizDistrict.getDistrictType())
                    || BizDistrict.DISTRICT_TYPE.PROVINCE_DCG.getCode().equals(bizDistrict.getDistrictType())) {
                attrs.put("cityDistrictId",bizDistrict.getDistrictId());
            }
        }
        attrs.put("districtName",stringBuilder.toString());
        return new ResultMessage(attrs,ResultMessage.SUCCESS,"查询成功");
    }

        /**
     * 交通点列表页
     */
    @RequestMapping(value = "/selectTrafficPointList")
    public Object selectTrafficPointList(Model model,BizDistrictSign bizDistrictSign, HttpServletRequest req, Integer page){
        model.addAttribute("signTypeList", BizDistrictSign.DISTRICT_SIGN_TYPE.values());
        Map<String, Object> parameters = new HashMap<String, Object>();
        int pagenum = page == null ? 1 : page;
        if (bizDistrictSign != null) {
            if (bizDistrictSign.getSignId() != null) {
                parameters.put("signId",bizDistrictSign.getSignId());
                model.addAttribute("signId", bizDistrictSign.getSignId());
            }
            if (StringUtils.isNotBlank(bizDistrictSign.getSignName())) {
                parameters.put("signName",bizDistrictSign.getSignName());
                model.addAttribute("signName", bizDistrictSign.getSignName());
            }
            if (StringUtils.isNotBlank(bizDistrictSign.getSignType())) {
                parameters.put("signType",bizDistrictSign.getSignType());
                model.addAttribute("signType", bizDistrictSign.getSignType());
            }

        }
        int count = MiscUtils.autoUnboxing( districtSignClientService.findDistrictSignCount(parameters) );
        Page<BizDistrictSign> pageParam = Page.page(count, 10, pagenum);
        if (count >= 0) {
            pageParam.buildUrl(req);
            parameters.put("_start", pageParam.getStartRows());
            parameters.put("_end", pageParam.getEndRows());
            ResultHandleT<List<BizDistrictSign>> resultHandleT = districtSignClientService.findDistrictSignByParams(parameters);
            if (resultHandleT ==null || resultHandleT.getReturnContent() == null) {
                LOG.error("findDistrictSignByParams error, resultHandleT is null,parameters = "+parameters);
                return TRAFFIC_POINT_PAGE;
            }
            List<BizDistrictSign> list = resultHandleT.getReturnContent();
            if (CollectionUtils.isEmpty(list)) {
                LOG.error("findDistrictSignByParams error, list is null,parameters = "+parameters);
                return TRAFFIC_POINT_PAGE;
            }
            pageParam.setItems(list);

            model.addAttribute("pageParam", pageParam);

            model.addAttribute("page", pageParam.getPage().toString());
            return TRAFFIC_POINT_PAGE;
        }
        return TRAFFIC_POINT_PAGE;
    }

    /**
     * 过滤已经选择的热门目的地
     */
    @ResponseBody
    @RequestMapping(value = "/checkHotplaceExist")
    public Object checkHotplaceExist(Model model,String destId,String destType){
        if (StringUtils.isBlank(destType) ||  StringUtils.isBlank(destId)) {
            LOG.error("checkHotplaceExist error, param is null,hotPlaceType = "+destType+" ,destId is "+destId);
            return ResultMessage.ADD_FAIL_RESULT;
        }
        Map<String,Object> params = new HashMap<>();
        params.put("destId",destId);
        params.put("destType",destType);
        Long num = hotPlaceClientService.findHotPlaceCountByParam(params);
        if (num == 0) {
            return ResultMessage.ADD_SUCCESS_RESULT;
        } else{
            return ResultMessage.ADD_FAIL_RESULT;
        }
    }




}
