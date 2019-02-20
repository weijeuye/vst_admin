package com.lvmama.vst.back.superfreetour.web;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Maps;
import com.lvmama.vst.back.biz.po.BizBuEnum;
import com.lvmama.vst.back.client.biz.service.BizBuEnumClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.pub.po.ComLog;
import com.lvmama.vst.back.superfreetour.service.TravelRecommendRouteService;
import com.lvmama.vst.back.superfreetour.service.TravelRecommendTagService;
import com.lvmama.vst.comm.enumeration.CommEnumSet;
import com.lvmama.vst.comm.utils.gson.GsonUtils;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.superfreetour.po.TravelRecommend;
import com.lvmama.vst.superfreetour.po.TravelRecommendRoute;
import com.lvmama.vst.superfreetour.po.TravelRecommendTag;
import com.lvmama.vst.superfreetour.po.TravelRecommendTagRe;
import com.lvmama.vst.superfreetour.service.TravelRecommendClientService;
import com.lvmama.vst.superfreetour.vo.TravelRecommendTagReVo;
import com.lvmama.vst.superfreetour.vo.TravelRecommendVo;

/**
 * Created shanping on 2017/6/7.
 */
@Controller
@RequestMapping("/prod/travelRecommend")
public class TravelRecommendAction extends BaseActionSupport {

    private static final Log LOG = LogFactory.getLog(TravelRecommendAction.class);

    @Autowired
    private BizBuEnumClientService bizBuEnumClientService;

    @Autowired
    private TravelRecommendClientService travelRecommendService;

    @Autowired
    private TravelRecommendTagService travelRecommendTagService;

    @Autowired
    private ComLogClientService comLogService;
    

    @Autowired
    private TravelRecommendRouteService travelRecommendRouteService;
    

    //跳转攻略维护页面
    @RequestMapping(value = "/showTravelRecommendMaintain")
    public String showProductMaintain(Model model, Long travelRecommendId){
        model.addAttribute("travelRecommendId", travelRecommendId);
        if (travelRecommendId != null) {
            // vst组织鉴权
           // super.vstOrgAuthentication(LOG, "prodProduct.getManagerIdPerm()");
            TravelRecommendVo travelRecommendVo = travelRecommendService.findTravelRecommendVoById(travelRecommendId);
            model.addAttribute("recommendName", travelRecommendVo.getRecommendName());
        }else{

        }
        return "/superfreetour/showTravelRecommendMaintain";
    }

    //基本信息维护
    @RequestMapping(value = "/showAddTravelRecommend")
    public String showAddTravelRecommend(Model model, Long travelRecommendId){
        if (LOG.isDebugEnabled()) {
            LOG.debug("start method<showAddTravelRecommend>");
        }
        model.addAttribute("travelRecommendId", travelRecommendId);
        if(travelRecommendId!=null){
            //修改
            TravelRecommendVo travelRecommendVo = travelRecommendService.findTravelRecommendVoAndTagById(travelRecommendId);
            model.addAttribute("travelRecommendVo", travelRecommendVo);
        }

        // BU
        List<BizBuEnum> bulist = bizBuEnumClientService.getAllBizBuEnumList().getReturnContent();
        Iterator<BizBuEnum> buEnumIterator = bulist.iterator();
        while (buEnumIterator.hasNext()){
            BizBuEnum bu = buEnumIterator.next();
            if(StringUtils.equals(bu.getCode(),"LOCAL_BU")){
                bu.setCnName("大目的地委员会");
            }else if(StringUtils.equals(bu.getCode(),"DESTINATION_BU")){
                buEnumIterator.remove();
            }
        }
        model.addAttribute("buList",bulist );
        // 分公司
        model.addAttribute("filiales", CommEnumSet.FILIALE_NAME.values());

        if (LOG.isDebugEnabled()) {
            LOG.debug("end method<showAddTravelRecommend>");
        }
        return "/superfreetour/showAddTravelRecommend";
    }

    //封装处理自定义标签
    private List<TravelRecommendTagRe> initTagRe(String[] tags, String[] tagchecks){
        List<String> tagchecksList = new ArrayList<>();
        if(tagchecks!=null){
            for (String tagcheck : tagchecks) {
                if(StringUtils.isNotBlank(tagcheck)){
                    tagchecksList.add(tagcheck.trim());
                }
            }
        }

        List<String> tagList = new ArrayList<>();

        List<TravelRecommendTagRe> tagReList = new ArrayList<>();

        if(tags!=null){
            for (String tagstr : tags) {
                if(StringUtils.isNotBlank(tagstr) && !tagList.contains(tagstr.trim())){
                    tagList.add(tagstr.trim());
                }
            }

            for (String tagstr : tagList) {
                TravelRecommendTagRe tagRe = new TravelRecommendTagRe();
                TravelRecommendTag tag = new TravelRecommendTag();
                tag.setTagName(tagstr.trim());
                tagRe.setTravelRecommendTag(tag);
                if(tagchecksList.contains(tagstr.trim())){
                    tagRe.setTagStatus("Y");
                }else{
                    tagRe.setTagStatus("N");
                }
                tagReList.add(tagRe);
            }
        }
        return tagReList;
    }

    //保存基本信息
    @RequestMapping(value = "/addTravelRecommend")
    @ResponseBody
    public Object addTravelRecommend(Model model, HttpServletRequest request, TravelRecommend travelRecommend, Long travelRecommendId){
        if (LOG.isDebugEnabled()) {
            LOG.debug("start method<addTravelRecommend>");
        }
        ResultMessage result = null;
        try {
            if(travelRecommend==null){
                throw new BusinessException("参数错误");
            }
            if (LOG.isDebugEnabled()) {
                LOG.error(GsonUtils.toJson(travelRecommend));
            }

            String[] tags=request.getParameterValues("tag");
            String[] tagchecks=request.getParameterValues("tagcheck");

            List<TravelRecommendTagRe> tagReList = initTagRe(tags,tagchecks);
            travelRecommend.setTagReList(tagReList);
            if(travelRecommendId==null){
                //新增
                travelRecommendService.saveTravelRecommend(travelRecommend);
                result = ResultMessage.createResultMessage();
                result.addObject("travelRecommendId",travelRecommend.getRecommendId());
                result.addObject("recommendName",travelRecommend.getRecommendName());
                try {
                    String content = getTravelRecommendFeatureLog(travelRecommend,null);
                    comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.TRAVEL_RECOMMEND, travelRecommend.getRecommendId(),travelRecommend.getRecommendId(),this.getLoginUser().getUserName(), "添加宝典："+ content,
                            ComLog.COM_LOG_LOG_TYPE.TRAVEL_RECOMMEND_CHANGE.name(), "添加宝典", null);
                } catch (Exception e) {
                    log.error("Record Log failure ！Log type:" + ComLog.COM_LOG_LOG_TYPE.TRAVEL_RECOMMEND_CHANGE.name());
                    log.error(e.getMessage());
                }
            }else{
                //取旧数据
                TravelRecommendVo oldVo = travelRecommendService.findTravelRecommendVoAndTagById(travelRecommendId);

                //修改
                travelRecommend.setRecommendId(travelRecommendId);
                travelRecommendService.updateTravelRecommend(travelRecommend);
                result = ResultMessage.createResultMessage();
                result.addObject("travelRecommendId",travelRecommend.getRecommendId());
                result.addObject("recommendName",travelRecommend.getRecommendName());
                try {
                    String content = getTravelRecommendFeatureLog(travelRecommend,oldVo);
                    comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.TRAVEL_RECOMMEND, travelRecommend.getRecommendId(),travelRecommend.getRecommendId(),this.getLoginUser().getUserName(), "修改了宝典："+content,
                            ComLog.COM_LOG_LOG_TYPE.TRAVEL_RECOMMEND_CHANGE.name(), "修改宝典", null);
                } catch (Exception e) {
                    log.error("Record Log failure ！Log type:" + ComLog.COM_LOG_LOG_TYPE.TRAVEL_RECOMMEND_CHANGE.name());
                    log.error(e.getMessage());
                }
            }
        }catch (BusinessException e){
            result = new ResultMessage("error", e.getMessage());
        }
        if (LOG.isDebugEnabled()) {
            LOG.debug("end method<addTravelRecommend>");
        }
        return result;
    }

    @RequestMapping(value = "/findtravelRecommendList")
    public String findtravelRecommendList(Model model, Integer page, TravelRecommend travelRecommend, HttpServletRequest req){
        if (LOG.isDebugEnabled()) {
            LOG.debug("start method<findtravelRecommendList>");
        }
        if(travelRecommend!=null){
            //需要搜索
            Integer pagenum = page == null ? 1 : page;
            Integer pageSize = 10;
            Page pageParam = Page.page(pageSize,pagenum);
            List<TravelRecommendVo> travelRecommendVoList = travelRecommendService.findTravelRecommendVoList(travelRecommend,pageParam);
            Long totalResultSize = travelRecommendService.getCountTravelRecommend(travelRecommend);
            pageParam.setItems(travelRecommendVoList);
            pageParam.setTotalResultSize(totalResultSize);
            pageParam.buildUrl(req);
            model.addAttribute("travelRecommendVoList",travelRecommendVoList);
            model.addAttribute("pageParam",pageParam);
        }
        return "/superfreetour/findtravelRecommendList";
    }

    //搜索标签
    @RequestMapping(value = "/searchTags")
    @ResponseBody
    public Object searchTags(Model model, String search){
        if (LOG.isDebugEnabled()) {
            LOG.debug("start method<searchTags>");
        }
        if(StringUtils.isBlank(search)){
            return new JSONArray();
        }
        List<TravelRecommendTag> list = travelRecommendTagService.searchTags(search,20);
        JSONArray array = new JSONArray();
        if(list != null && list.size() > 0){
            for(TravelRecommendTag tag:list){
                JSONObject obj=new JSONObject();
                obj.put("id", tag.getRecommendTagId());
                obj.put("text", tag.getTagName());
                array.add(obj);
            }
        }
        return array;
    }

    //修改状态
    @RequestMapping(value = "/changeTravelRecommendValid")
    @ResponseBody
    public Object changeTravelRecommendValid(Long recommedId,String validFlag){
        if (LOG.isDebugEnabled()) {
            LOG.debug("start method<changeTravelRecommendValid>");
        }
        ResultMessage result = null;
        try {
            if(recommedId==null){
                throw new BusinessException("参数错误");
            }
            String validFlagStr = "有效";

            if(!"Y".equalsIgnoreCase(validFlag)){
                validFlag="N";
                validFlagStr = "无效";
            }else{
                //当设为有效时  校验宝典是否有行程 若无行程 给提示不能设为有效
                Map<String,Object> params = Maps.newHashMap();
                params.put("recommendId",recommedId);
                List<TravelRecommendRoute>  travelRecommendRouteList=travelRecommendRouteService.findRecommendRoute(params);
                if(CollectionUtils.isEmpty(travelRecommendRouteList) || travelRecommendRouteList.size()==0){
                    Map<String, Object> attributes=Maps.newHashMap();
                    attributes.put("noRoute","noRoute");
                    result = new ResultMessage(attributes,"", "");
                    return result;
                }
            }
            validFlag = validFlag.toUpperCase();

            TravelRecommend travelRecommend = new TravelRecommend();
            travelRecommend.setRecommendId(recommedId);
            travelRecommend.setValidFlag(validFlag);
            travelRecommendService.updateSimpleTravelRecommend(travelRecommend);
            result = ResultMessage.createResultMessage();
            try {
                comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.TRAVEL_RECOMMEND, travelRecommend.getRecommendId(),travelRecommend.getRecommendId(),this.getLoginUser().getUserName(), "修改了宝典状态为："+validFlagStr,
                        ComLog.COM_LOG_LOG_TYPE.TRAVEL_RECOMMEND_CHANGE.name(), "修改宝典状态", null);
            } catch (Exception e) {
                log.error("Record Log failure ！Log type:" + ComLog.COM_LOG_LOG_TYPE.TRAVEL_RECOMMEND_CHANGE.name());
                log.error(e.getMessage());
            }
        }catch (BusinessException e){
            result = new ResultMessage("error", e.getMessage());
        }
        if (LOG.isDebugEnabled()) {
            LOG.debug("end method<addTravelRecommend>");
        }
        return result;
    }

    private String getTagLog(List<? extends TravelRecommendTagRe> tagReList){
        StringBuilder sb = new StringBuilder();
        Map<String,TravelRecommendTagRe> tagReMap = new TreeMap<>();
        if(tagReList!=null){
            for (TravelRecommendTagRe tagRe : tagReList) {
                if(tagRe.getTravelRecommendTag()!=null){
                    tagReMap.put(tagRe.getTravelRecommendTag().getTagName(),tagRe);
                }else if(tagRe instanceof TravelRecommendTagReVo){
                    tagReMap.put(((TravelRecommendTagReVo)tagRe).getTagName(),tagRe);
                }
            }
        }
        Iterator<Map.Entry<String,TravelRecommendTagRe>> iter=tagReMap.entrySet().iterator();
        while(iter.hasNext()){
            Map.Entry<String,TravelRecommendTagRe> entry = iter.next();
            TravelRecommendTagRe tagRe = entry.getValue();
            sb.append(entry.getKey());
            if("N".equals(tagRe.getTagStatus())){
                sb.append("(禁用)");
            }
            if(iter.hasNext()){
                sb.append("、");
            }
        }
        return sb.toString();
    }



    //拼装日志
    private String getTravelRecommendFeatureLog(TravelRecommend newBean,TravelRecommendVo oldBean){
        StringBuilder sb = new StringBuilder();
        if(oldBean==null){
            //新增
            sb.append("新增宝典【").append("主标题：").append(newBean.getRecommendName()).append(",");
            sb.append("类别：");
            if("INNERLINE".equals(newBean.getRecommendType())){
                sb.append("国内");
            }else{
                sb.append("出境/港澳台");
            }
            sb.append(",");
            sb.append("副标题：").append(newBean.getViceName()).append(",");
            sb.append("状态：").append(newBean.getValidFlag()).append(",");
            sb.append("最佳游玩季节：").append(newBean.getVisitSeason()).append(",");
            sb.append("人均价格：").append(newBean.getAverageFee()).append(",");
            sb.append("攻略目的地：").append(newBean.getDestName()).append(",");
            sb.append("推荐级别：").append(newBean.getRecommendLevel()).append(",");
            sb.append("产品经理：").append(newBean.getManagerName()).append(",");
            sb.append("所属组织：").append(newBean.getFiliale()).append(",");
            sb.append("所属BU：").append(newBean.getBu()).append(",");
            sb.append("标签：").append(getTagLog(newBean.getTagReList())).append("");
            sb.append("】");
            return sb.toString();
        }else{
            sb.append("【");
            if(!Objects.equals(newBean.getRecommendName(),oldBean.getRecommendName())){
                sb.append("主标题 ").append("修改为：").append(newBean.getRecommendName());
            }
            if(!Objects.equals(newBean.getRecommendType(),oldBean.getRecommendType())){
                if(sb.length()>1){
                    sb.append(",");
                }
                sb.append("类别 ").append("修改为：");
                if("INNERLINE".equals(newBean.getRecommendType())){
                    sb.append("国内");
                }else{
                    sb.append("出境/港澳台");
                }
            }
            if(!Objects.equals(newBean.getViceName(),oldBean.getViceName())){
                if(sb.length()>1){
                    sb.append(",");
                }
                sb.append("副标题 ").append("修改为：").append(newBean.getViceName());
            }
            if(!Objects.equals(newBean.getValidFlag(),oldBean.getValidFlag())){
                if(sb.length()>1){
                    sb.append(",");
                }
                sb.append("状态 ").append("修改为：").append(newBean.getValidFlag());
            }
            if(!Objects.equals(newBean.getVisitSeason(),oldBean.getVisitSeason())){
                if(sb.length()>1){
                    sb.append(",");
                }
                sb.append("最佳游玩季节 ").append("修改为：").append(newBean.getVisitSeason());
            }
            if(!Objects.equals(newBean.getAverageFee(),oldBean.getAverageFee())){
                if(sb.length()>1){
                    sb.append(",");
                }
                sb.append("人均价格 ").append("修改为：").append(newBean.getAverageFee());
            }
            if(!Objects.equals(newBean.getDestName(),oldBean.getDestName())){
                if(sb.length()>1){
                    sb.append(",");
                }
                sb.append("攻略目的地 ").append("修改为：").append(newBean.getDestName());
            }
            if(!Objects.equals(newBean.getRecommendLevel(),oldBean.getRecommendLevel())){
                if(sb.length()>1){
                    sb.append(",");
                }
                sb.append("推荐级别 ").append("修改为：").append(newBean.getRecommendLevel());
            }
            if(!Objects.equals(newBean.getManagerName(),oldBean.getManagerName())){
                if(sb.length()>1){
                    sb.append(",");
                }
                sb.append("产品经理 ").append("修改为：").append(newBean.getManagerName());
            }
            if(!Objects.equals(newBean.getFiliale(),oldBean.getFiliale())){
                if(sb.length()>1){
                    sb.append(",");
                }
                sb.append("所属组织 ").append("修改为：").append(newBean.getFiliale());
            }
            if(!Objects.equals(newBean.getBu(),oldBean.getBu())){
                if(sb.length()>1){
                    sb.append(",");
                }
                sb.append("所属BU ").append("修改为：").append(newBean.getBu());
            }
            if(!Objects.equals(getTagLog(newBean.getTagReList()),getTagLog(oldBean.getTravelRecommendTagReVoList()))){
                if(sb.length()>1){
                    sb.append(",");
                }
                sb.append("标签 ").append("修改为：").append(getTagLog(newBean.getTagReList()));
            }
            sb.append("】");
            return sb.toString();
        }
    }

}
