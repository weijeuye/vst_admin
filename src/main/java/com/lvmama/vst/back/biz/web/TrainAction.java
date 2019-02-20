package com.lvmama.vst.back.biz.web;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizDistrict;
import com.lvmama.vst.back.biz.po.BizDistrictSign;
import com.lvmama.vst.back.biz.po.BizTrain;
import com.lvmama.vst.back.biz.service.BizTrainService;
import com.lvmama.vst.back.client.biz.service.DictClientService;
import com.lvmama.vst.back.client.biz.service.DistrictClientService;
import com.lvmama.vst.back.client.biz.service.DistrictSignClientService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

@Controller
@RequestMapping("/biz/train")
public class TrainAction extends BaseActionSupport {

    private static final long serialVersionUID = -358078769854481061L;

    @Autowired
    private BizTrainService bizTrainService;

    @Autowired
    private DictClientService bizDictQueryService;

    @Autowired
    private DistrictClientService districtService;

    @Autowired
    private DistrictSignClientService districtSignService;

    @RequestMapping("/findTrainList")
    public String findTrainList(BizTrain bizTrain, Integer page, Model model, HttpServletRequest request)
            throws BusinessException {

        HashMap<String, Object> parameters = new HashMap<String, Object>(5);
        String trainNo = bizTrain.getTrainNo() == null ? null : bizTrain.getTrainNo().trim();
        parameters.put("trainNo", trainNo);
        parameters.put("startDistrict", bizTrain.getStartDistrict());
        parameters.put("arriveDistrict", bizTrain.getArriveDistrict());
        parameters.put("trainType", bizTrain.getTrainType());
        parameters.put("like", "Y"); // 车次号模糊查询

        Long count = bizTrainService.findBizTrainCount(parameters);
        Page<BizTrain> pager = Page.page(count, 10L, (page == null ? 1L : page.longValue()));
        pager.buildUrl(request);
        parameters.put("_start", pager.getStartRows());
        parameters.put("_end", pager.getEndRows());
        parameters.put("_orderby", "TRAIN_ID");
        parameters.put("_order", "DESC");

        List<BizTrain> bizTrains = bizTrainService.selectByParams(parameters);
        for (BizTrain train : bizTrains) {
            fillBizTrain(train);
        }
        pager.setItems(bizTrains);
        model.addAttribute("pager", pager);

        model.addAttribute("trainNo", bizTrain.getTrainNo());
        model.addAttribute("startDistrict", bizTrain.getStartDistrict());
        model.addAttribute("startDistrictString", bizTrain.getStartDistrictString());
        model.addAttribute("arriveDistrict", bizTrain.getArriveDistrict());
        model.addAttribute("arriveDistrictString", bizTrain.getArriveDistrictString());
        model.addAttribute("trainTypes", BizTrain.TRAIN_TYPE.values());
        model.addAttribute("page", pager.getPage().toString());

        return "/biz/train/findTrainList";
    }

    @RequestMapping(value = "/addTrain")
    @ResponseBody
    public Object addTrain(BizTrain bizTrain) throws BusinessException {
        setCostTime(bizTrain);
        int result = bizTrainService.insertSelective(bizTrain);
        return result == 0 ? ResultMessage.ADD_FAIL_RESULT : ResultMessage.ADD_SUCCESS_RESULT;
    }

    @RequestMapping(value = "/updateTrain")
    @ResponseBody
    public Object updateTrain(BizTrain bizTrain) throws BusinessException {
        setCostTime(bizTrain);
        int result = bizTrainService.updateByPrimaryKeySelective(bizTrain);
        return result == 0 ? ResultMessage.UPDATE_FAIL_RESULT : ResultMessage.UPDATE_SUCCESS_RESULT;
    }

    @RequestMapping(value = "/showAddTrain")
    public String showAddTrain(Model model) {
        model.addAttribute("trainTypes", BizTrain.TRAIN_TYPE.values());

        return "/biz/train/showAddTrain";
    }

    @RequestMapping(value = "/showUpdateTrain")
    public String showUpdateTrain(Long trainId, Model model) {
        BizTrain bizTrain = bizTrainService.selectByPrimaryKey(trainId);
        fillBizTrain(bizTrain);
        model.addAttribute("bizTrain", bizTrain);
        model.addAttribute("trainTypes", BizTrain.TRAIN_TYPE.values());

        return "/biz/train/showUpdateTrain";
    }

    @RequestMapping(value = "/setTrainCancelFlag")
    @ResponseBody
    public Object setTrainCancelFlag(BizTrain bizTrain) throws BusinessException {
        int result = bizTrainService.updateCancelFlag(bizTrain);
        return result == 0 ? ResultMessage.UPDATE_FAIL_RESULT : ResultMessage.UPDATE_SUCCESS_RESULT;
    }

    private void fillBizTrain(BizTrain bizTrain) {
        if (bizTrain.getStartStation() != null) {
            BizDistrictSign bds = MiscUtils.autoUnboxing( districtSignService.findDistrictSignById(bizTrain.getStartStation()) );
            if (bds != null) {
                bizTrain.setStartStationString(bds.getSignName());
            }
        }

        if (bizTrain.getArriveStation() != null) {
            BizDistrictSign bds = MiscUtils.autoUnboxing( districtSignService.findDistrictSignById(bizTrain.getArriveStation()) );
            if (bds != null) {
                bizTrain.setArriveStationString(bds.getSignName());
            }
        }

        if (bizTrain.getStartDistrict() != null) {
            BizDistrict district = MiscUtils.autoUnboxing( districtService.findDistrictById(bizTrain.getStartDistrict()) );
            if (district != null) {
                bizTrain.setStartDistrictString(district.getDistrictName());
            }
        }

        if (bizTrain.getArriveDistrict() != null) {
            BizDistrict district = MiscUtils.autoUnboxing( districtService.findDistrictById(bizTrain.getArriveDistrict()) );
            if (district != null) {
                bizTrain.setArriveDistrictString(district.getDistrictName());
            }
        }

    }

    /**
     * 计算运行时长
     * 
     * @param bizTrain
     */
    private void setCostTime(BizTrain bizTrain) {
        Long time = Long.valueOf(bizTrain.getCostTimeHour()) * 60L + Long.valueOf(bizTrain.getCostTimeMinute());
        bizTrain.setCostTime(time);
    }
}
