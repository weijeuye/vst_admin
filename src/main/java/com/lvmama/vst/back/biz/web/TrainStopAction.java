package com.lvmama.vst.back.biz.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizDistrictSign;
import com.lvmama.vst.back.biz.po.BizTrainStop;
import com.lvmama.vst.back.biz.service.BizTrainStopService;
import com.lvmama.vst.back.client.biz.service.DistrictSignClientService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

@Controller
@RequestMapping("/biz/trainStop")
public class TrainStopAction extends BaseActionSupport {

    private static final long serialVersionUID = -4703760250500889294L;

    @Autowired
    private BizTrainStopService bizTrainStopService;

    @Autowired
    private DistrictSignClientService districtSignService;

    @RequestMapping("/findTrainStopList")
    public String findTrainStopList(Long trainId, String trainNo, Model model) throws BusinessException {
        Map<String, Object> parameters = new HashMap<String, Object>(3);
        parameters.put("trainId", trainId);
        parameters.put("_orderby", "STOP_STEP");
        parameters.put("_order", "ASC");
        List<BizTrainStop> bizTrainStops = bizTrainStopService.selectByParams(parameters);
        for (BizTrainStop stop : bizTrainStops) {
            fillBizTrainStop(stop);
        }
        model.addAttribute("bizTrainStops", bizTrainStops);
        model.addAttribute("trainId", trainId);
        model.addAttribute("trainNo", trainNo);

        return "/biz/trainStop/findTrainStopList";
    }

    @RequestMapping(value = "/showAddTrainStop")
    public String showAddTrainStop(Long trainId, String trainNo, Model model) {
        model.addAttribute("trainId", trainId);
        model.addAttribute("trainNo", trainNo);

        return "/biz/trainStop/showAddTrainStop";
    }

    @RequestMapping(value = "/showUpdateTrainStop")
    public String showUpdateTrainStop(Long stopId, Long trainId, String trainNo, Model model) {
        BizTrainStop bizTrainStop = bizTrainStopService.selectByPrimaryKey(stopId);
        fillBizTrainStop(bizTrainStop);
        model.addAttribute("bizTrainStop", bizTrainStop);
        model.addAttribute("trainId", trainId);
        model.addAttribute("trainNo", trainNo);

        return "/biz/trainStop/showUpdateTrainStop";
    }

    @RequestMapping(value = "/addTrainStop")
    @ResponseBody
    public Object addTrainStop(BizTrainStop bizTrainStop) throws BusinessException {
        int result = bizTrainStopService.insertSelective(bizTrainStop);
        return result == 0 ? ResultMessage.ADD_FAIL_RESULT : ResultMessage.ADD_SUCCESS_RESULT;
    }

    @RequestMapping(value = "/updateTrainStop")
    @ResponseBody
    public Object updateTrainStop(BizTrainStop bizTrainStop) throws BusinessException {
        int result = bizTrainStopService.updateByPrimaryKeySelective(bizTrainStop);
        return result == 0 ? ResultMessage.UPDATE_FAIL_RESULT : ResultMessage.UPDATE_SUCCESS_RESULT;
    }

    @RequestMapping(value = "/setCancelFlag")
    @ResponseBody
    public Object setCancelFlag(BizTrainStop bizTrainStop) throws BusinessException {
        int result = bizTrainStopService.updateCancelFlag(bizTrainStop);
        return result == 0 ? ResultMessage.UPDATE_FAIL_RESULT : ResultMessage.UPDATE_SUCCESS_RESULT;
    }

    private void fillBizTrainStop(BizTrainStop bizTrainStop) {
        if (bizTrainStop.getStopStation() != null) {
            BizDistrictSign bds = MiscUtils.autoUnboxing( districtSignService.findDistrictSignById(bizTrainStop.getStopStation()) );
            if (bds != null) {
                bizTrainStop.setStopStationString(bds.getSignName());
            }
        }
    }
}
