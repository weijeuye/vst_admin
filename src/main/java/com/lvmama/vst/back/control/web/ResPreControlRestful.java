package com.lvmama.vst.back.control.web;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.lvmama.vst.back.client.precontrol.service.ResPrecontrolBindGoodsClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.control.po.*;
import com.lvmama.vst.back.control.service.ResPrecontrolPolicyService;
import com.lvmama.vst.back.pub.po.ComLog;
import com.lvmama.vst.comm.utils.DateUtil;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.utils.bean.EnhanceBeanUtils;
import com.lvmama.vst.comm.vo.ResultHandle;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BusinessException;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.IOException;
import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 星云系统同步预控资源
 */
@Controller
@RequestMapping("/nebula_project/pre_control")
public class ResPreControlRestful {

    private static final Log LOG = LogFactory.getLog(ResPreControlRestful.class);
    @Autowired
    private ResPrecontrolPolicyService resPrecontrolPolicyService;
    @Autowired
    private ComLogClientService comLogService;
    @Autowired
    private ResPrecontrolBindGoodsClientService resPrecontrolBindGoodsService;

    //操作
    public static enum NEBULA_ACTION {
        //新建
        New,
        //更新
        Update,
        //终止
        Termination,
        //恢复
        Renew,
        //删除
        Delete
    }

    public static enum RES_PRECONTROL_POLICY{
        nebulaProjectId("星云项目id"),
        name("预控名称"),
        supplierId("供应商id"),
        supplierName("供应商名称"),
        controlType("预控方式"),
        tradeEffectDate("游玩开始日期"),
        tradeExpiryDate("游玩终止日期"),
        controlClassification("预控类型"),
        productManagerId("产品经理id"),
        productManagerName("产品经理名称"),
        amount("金额/库存数量"),
        creatTime("创建时间"),
        buyoutTotalCost("买断总成本"),
        forecastSales("预估营业额"),
        depositAmount("押金"),
        payWay("付款方式"),
        buCode("所属bu");
        private String propName;
        RES_PRECONTROL_POLICY(String propName){
            this.propName = propName;
        }
        public static String getPropName(String code){
            if(code == null){
                return null;
            }
            for(RES_PRECONTROL_POLICY item : RES_PRECONTROL_POLICY.values()){
                if(item.name().equals(code)){
                    return item.propName;
                }
            }
            return null;
        }
    }

    /**
     * 保存预控资源
     */
    @RequestMapping(value = "/saveResPreControl", method = RequestMethod.POST)
    @ResponseBody
    public Object saveResPreControl(HttpServletRequest request) {
        ResultHandle resultHandle = new ResultHandle();
        try {
            String params = resolveRequest(request);
            LOG.info("ResPreControlRestful#saveResPreControl 请求参数:" + params);
            ResultMessage resultMessage = checkResPreControl(params);
            if (!resultMessage.isSuccess()) {
                resultHandle.setMsg(resultMessage.getMessage());
                resultHandle.setErrorCode("101");
                return resultHandle;
            }
            Map<String, Object> attributes = resultMessage.getAttributes();
            String action = (String) attributes.get("action");
            ResPrecontrolPolicy resPrecontrolPolicy = (ResPrecontrolPolicy) attributes.get("resPrecontrolPolicy");
            attributes.clear();
            attributes.put("nebulaProjectId", resPrecontrolPolicy.getNebulaProjectId());
            attributes.put("isDeleted", 0);
            attributes.put("buCode", resPrecontrolPolicy.getBuCode());
            List<ResPrecontrolPolicy> resPrecontrolPolicyList = resPrecontrolPolicyService.findResPreControlListForNebula(attributes);
            if (NEBULA_ACTION.New.name().equalsIgnoreCase(action)) {
                if (CollectionUtils.isNotEmpty(resPrecontrolPolicyList)) {
                    resultHandle.setMsg("星云系统项目ID已存在");
                    resultHandle.setErrorCode("102");
                    return resultHandle;
                }
                addResPreControl(resPrecontrolPolicy);
            } else {
                if (CollectionUtils.isEmpty(resPrecontrolPolicyList)) {
                    resultHandle.setMsg("星云系统项目ID不存在");
                    resultHandle.setErrorCode("103");
                    return resultHandle;
                }
                ResPrecontrolPolicy oldResPrecontrolPolicy = resPrecontrolPolicyList.get(0);
                if (!ResControlEnum.CONTROL_STATE.New.toString().equals(oldResPrecontrolPolicy.getState())
                        && !ResControlEnum.CONTROL_STATE.InUse.toString().equals(oldResPrecontrolPolicy.getState())) {
                    resultHandle.setMsg("预控状态不是新建状态或启用状态，不支持修改");
                    resultHandle.setErrorCode("200");
                    return resultHandle;
                }
                ResPrecontrolPolicy newResPrecontrolPolicy = mergeResPrecontrolPolicy(oldResPrecontrolPolicy, params);
                updateResPreControl(oldResPrecontrolPolicy, newResPrecontrolPolicy);
            }
        } catch (Exception e) {
            LOG.error("ResPreControlRestful#saveResPreControl error:" + e.getMessage());
            resultHandle.setErrorCode("200");
            resultHandle.setMsg(e.getMessage());
        }
        return resultHandle;
    }

    /**
     * 终止、恢复、删除预控资源
     */
    @RequestMapping(value = "/changePreControlState", method = RequestMethod.POST)
    @ResponseBody
    public Object changePreControlState(HttpServletRequest request) {
        ResultHandle resultHandle = new ResultHandle();
        try {
            String params = resolveRequest(request);
            LOG.info("ResPreControlRestful#changePreControlState 请求参数:" + params);
            JSONObject jsonObject = JSON.parseObject(params);
            String action = jsonObject.getString("action");
            Long nebulaProjectId = jsonObject.getLong("nebulaProjectId");
            String buCode = jsonObject.getString("buCode");
            if (StringUtils.isBlank(action)
                    || nebulaProjectId == null
                    || StringUtils.isBlank(buCode)) {
                resultHandle.setMsg("参数缺失");
                resultHandle.setErrorCode("101");
                return resultHandle;
            }
            Map<String, Object> attributes = new HashMap<>();
            attributes.put("nebulaProjectId", nebulaProjectId);
            attributes.put("isDeleted", 0);
            attributes.put("buCode", buCode);
            List<ResPrecontrolPolicy> resPrecontrolPolicyList = resPrecontrolPolicyService.findResPreControlListForNebula(attributes);
            if (CollectionUtils.isEmpty(resPrecontrolPolicyList)) {
                resultHandle.setMsg("星云系统项目ID不存在");
                resultHandle.setErrorCode("103");
                return resultHandle;
            }
            ResPrecontrolPolicy resPrecontrolPolicy = resPrecontrolPolicyList.get(0);
            String state = null;
            Long id = resPrecontrolPolicy.getId();
            String logName = null;
            if (NEBULA_ACTION.Termination.name().equalsIgnoreCase(action)) {
                logName = "终止资源预控";
                if (!ResControlEnum.CONTROL_STATE.InUse.name().equalsIgnoreCase(resPrecontrolPolicy.getState())
                        && !ResControlEnum.CONTROL_STATE.New.name().equalsIgnoreCase(resPrecontrolPolicy.getState())) {
                    resultHandle.setMsg("预控状态不是启用状态或者新建状态，无法终止");
                }
                state = ResControlEnum.CONTROL_STATE.Termination.name();
            } else if (NEBULA_ACTION.Renew.name().equalsIgnoreCase(action)) {
                logName = "启用资源预控";
                if (!ResControlEnum.CONTROL_STATE.Termination.name().equalsIgnoreCase(resPrecontrolPolicy.getState())) {
                    resultHandle.setMsg("预控状态不是终止状态，无法恢复");
                }
                int sameNum = resPrecontrolPolicyService.findSameTimeInUsePreControlPolicy(id);
                if (sameNum > 0) {
                    resultHandle.setMsg("有" + sameNum + "个预控资源在相同时间区间内冲突不能恢复");
                }
                state = ResControlEnum.CONTROL_STATE.InUse.name();
            } else if (NEBULA_ACTION.Delete.name().equalsIgnoreCase(action)) {
                logName = "删除资源预控";
                if (!ResControlEnum.CONTROL_STATE.New.name().equalsIgnoreCase(resPrecontrolPolicy.getState())) {
                    resultHandle.setMsg("预控状态不是新建状态，无法删除");
                }
                state = resPrecontrolPolicy.getState();
            } else {
                resultHandle.setMsg("不支持的操作类型");
            }
            if (!resultHandle.isSuccess()) {
                resultHandle.setErrorCode("200");
                return resultHandle;
            }
            if (NEBULA_ACTION.Termination.name().equalsIgnoreCase(action)
                    || NEBULA_ACTION.Renew.name().equalsIgnoreCase(action)) {
                resPrecontrolPolicy.setState(state);
                resPrecontrolPolicyService.changePreControlStateForNebula(resPrecontrolPolicy);
            } else {
                resPrecontrolPolicyService.deleteResPreControlForNebula(resPrecontrolPolicy);
            }
            clearCache(resPrecontrolPolicy);
            // 保存操作日志
            comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.RES_PRECONTROL_POLICY_POLICY, id, id,
                    "星云系统", "星云系统" + logName + ",ID:" + id,
                    ComLog.COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name(), logName, null);
        } catch (Exception e) {
            LOG.error("ResPreControlRestful#changePreControlState error:" + e.getMessage());
            resultHandle.setErrorCode("200");
            resultHandle.setMsg(e.getMessage());
        }
        return resultHandle;
    }

    /**
     * 预控资源延期
     */
    @RequestMapping(value = "/delayPrecontrolPolicy", method = RequestMethod.POST)
    @ResponseBody
    public Object delayPrecontrolPolicy(HttpServletRequest request) {
        ResultHandle resultHandle = new ResultHandle();
        try {
            String params = resolveRequest(request);
            LOG.info("ResPreControlRestful#delayPrecontrolPolicy 请求参数:" + params);
            JSONObject jsonObject = JSON.parseObject(params);
            Long nebulaProjectId = jsonObject.getLong("nebulaProjectId");
            Date tradeExpiryDate = jsonObject.getDate("tradeExpiryDate");
            String buCode = jsonObject.getString("buCode");
            if (tradeExpiryDate == null
                    || nebulaProjectId == null
                    || StringUtils.isBlank(buCode)) {
                resultHandle.setMsg("参数缺失");
                resultHandle.setErrorCode("101");
                return resultHandle;
            }
            Map<String, Object> attributes = new HashMap<>();
            attributes.put("nebulaProjectId", nebulaProjectId);
            attributes.put("isDeleted", 0);
            attributes.put("buCode", buCode);
            List<ResPrecontrolPolicy> resPrecontrolPolicyList = resPrecontrolPolicyService.findResPreControlListForNebula(attributes);
            if (CollectionUtils.isEmpty(resPrecontrolPolicyList)) {
                resultHandle.setMsg("星云系统项目ID不存在");
                resultHandle.setErrorCode("103");
                return resultHandle;
            }
            ResPrecontrolPolicy resPrecontrolPolicy = resPrecontrolPolicyList.get(0);
            if (!ResControlEnum.CONTROL_STATE.InUse.name().equalsIgnoreCase(resPrecontrolPolicy.getState())
                    && !ResControlEnum.CONTROL_STATE.New.name().equalsIgnoreCase(resPrecontrolPolicy.getState())) {
                resultHandle.setMsg("当前项目状态，不支持延期");
            }
            if (ResControlEnum.CONTROL_STATE.InUse.name().equalsIgnoreCase(resPrecontrolPolicy.getState())
                    && tradeExpiryDate.before(resPrecontrolPolicy.getTradeExpiryDate())) {
                resultHandle.setMsg("延期时间小于原来的终止时间");
            }
            if (!resultHandle.isSuccess()) {
                resultHandle.setErrorCode("200");
                return resultHandle;
            }
            String newTradeExpiryDate = DateUtil.formatSimpleDate(tradeExpiryDate);
            String oldTradeExpiryDate = DateUtil.formatSimpleDate(resPrecontrolPolicy.getTradeExpiryDate());
            resPrecontrolPolicyService.delayPrecontrolPolicyForNebula(resPrecontrolPolicy, tradeExpiryDate);
            // 保存操作日志
            Long id = resPrecontrolPolicy.getId();
            comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.RES_PRECONTROL_POLICY_POLICY, id, id,
                    "星云系统", "星云系统预控资源延期，ID:" + id + "，旧值：" + oldTradeExpiryDate + "，新值：" + newTradeExpiryDate,
                    ComLog.COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name(), "资源预控延期", null);
        } catch (Exception e) {
            LOG.error("ResPreControlRestful#delayPrecontrolPolicy error:" + e.getMessage());
            resultHandle.setErrorCode("200");
            resultHandle.setMsg(e.getMessage());
        }
        return resultHandle;
    }

    /**
     * 查询预控资源状态
     */
    @RequestMapping(value = "/queryPreControlPolicyState", method = RequestMethod.POST)
    @ResponseBody
    public Object queryPreControlPolicyState(HttpServletRequest request){
        ResultMessage resultMessage = ResultMessage.createResultMessage();
        try {
            String params = resolveRequest(request);
            LOG.info("ResPreControlRestful#queryPreControlPolicyState 请求参数:" + params);
            JSONObject jsonObject = JSON.parseObject(params);
            Long nebulaProjectId = jsonObject.getLong("nebulaProjectId");
            String buCode = jsonObject.getString("buCode");
            if (nebulaProjectId == null
                    || StringUtils.isBlank(buCode)) {
                resultMessage.raise("参数缺失");
                return resultMessage;
            }
            Map<String, Object> attributes = new HashMap<>();
            attributes.put("nebulaProjectId", nebulaProjectId);
            attributes.put("isDeleted", 0);
            attributes.put("buCode", buCode);
            List<ResPrecontrolPolicy> resPrecontrolPolicyList = resPrecontrolPolicyService.findResPreControlListForNebula(attributes);
            if (CollectionUtils.isEmpty(resPrecontrolPolicyList)) {
                resultMessage.raise("星云系统项目ID不存在");
                return resultMessage;
            }
            ResPrecontrolPolicy resPrecontrolPolicy = resPrecontrolPolicyList.get(0);
            resultMessage.addObject("state", resPrecontrolPolicy.getState());
        }catch (Exception e){
            LOG.error("ResPreControlRestful#queryPreControlPolicyState error:" + e.getMessage());
            resultMessage.raise(e.getMessage());
        }
        return resultMessage;
    }

    /**
     * 清除预控资源绑定商品的缓存
     */
    private void clearCache(ResPrecontrolPolicy resPrecontrolPolicy) {
        Map<String, Long> paramsMap = new HashMap<String, Long>();
        paramsMap.put("precontrolPolicyId", resPrecontrolPolicy.getId());
        List<ResPrecontrolBindGoods> goods = this.resPrecontrolBindGoodsService
                .findResPrecontrolBindGoodsPlus(paramsMap);
        List<Long> goodsList = new ArrayList<Long>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        if (CollectionUtils.isNotEmpty(goods)) {
            for (ResPrecontrolBindGoods good : goods) {
                goodsList.add(good.getGoodsId());
            }
            List<Date> visitDate = DateUtil.getDateList(resPrecontrolPolicy.getTradeEffectDate(), resPrecontrolPolicy.getTradeExpiryDate());
            for (Long goodsId : goodsList) {
                for (Date date : visitDate) {
                    String key = "PRE_CONTROL_" + goodsId + "_" + sdf.format(date);
                    MemcachedUtil.getInstance().remove(key);
                }
            }
        }
    }

    /**
     * 格式化请求参数
     */
    private String resolveRequest(HttpServletRequest request) throws IOException {
        BufferedReader reader = null;
        StringBuilder result = null;
        try {
            request.setCharacterEncoding("UTF-8");
            reader = request.getReader();
            String jsonStr = null;
            result = new StringBuilder();
            while ((jsonStr = reader.readLine()) != null) {
                result.append(jsonStr);
            }
        } catch (Exception e) {
            LOG.error("ResPreControlRestful#resolveRequest error:" + e.getMessage());
        }
        reader.close();
        return result.toString();
    }

    /**
     * 合并得到需要更新预控对象
     */
    private ResPrecontrolPolicy mergeResPrecontrolPolicy(ResPrecontrolPolicy oldResPrecontrolPolicy, String params) {
        ResPrecontrolPolicy newResPrecontrolPolicy = new ResPrecontrolPolicy();
        try {
            EnhanceBeanUtils.copyProperties(oldResPrecontrolPolicy, newResPrecontrolPolicy);
            JSONObject object = JSON.parseObject(params);
            ResPrecontrolPolicy resPrecontrolPolicy = JSON.parseObject(params, ResPrecontrolPolicy.class);
            Set<String> set = object.keySet();
            String setMethodName = null;
            String getMethodName = null;
            Method setMethod = null;
            Method getMethod = null;
            Class<?> type = null;
            Object value = null;
            for (String property : set) {
                try{
                    type = ResPrecontrolPolicy.class.getDeclaredField(property).getType();
                    setMethodName = "set" + property.substring(0, 1).toUpperCase() + property.substring(1);
                    getMethodName = "get" + property.substring(0, 1).toUpperCase() + property.substring(1);
                    setMethod = ResPrecontrolPolicy.class.getDeclaredMethod(setMethodName, type);
                    getMethod = ResPrecontrolPolicy.class.getDeclaredMethod(getMethodName);
                    value = getMethod.invoke(resPrecontrolPolicy);
                    setMethod.invoke(newResPrecontrolPolicy, value);
                }catch (Exception e){
                    LOG.error("ResPreControlRestful#mergeResPrecontrolPolicy  set property error:" + e.getMessage());
                }
            }
        } catch (Exception e) {
            LOG.error("ResPreControlRestful#mergeResPrecontrolPolicy error:" + e.getMessage());
        }
        return newResPrecontrolPolicy;
    }

    /**
     * 新增预控资源
     */
    private void addResPreControl(ResPrecontrolPolicy resPrecontrolPolicy) throws BusinessException {
        Long id = resPrecontrolPolicyService.addResPreControlForNebula(resPrecontrolPolicy);
        // 保存操作日志
        comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.RES_PRECONTROL_POLICY_POLICY, id, id,
                "星云系统", "星云系统新增资源预控，ID：" + id,
                ComLog.COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name(), "新增资源预控", null);
    }

    /**
     * 更新预控资源
     */
    private void updateResPreControl(ResPrecontrolPolicy oldResPrecontrolPolicy, ResPrecontrolPolicy newResPrecontrolPolicy) throws BusinessException {
        //状态是新建时，游玩起止日期修改没有限制；
        //状态为启用，游玩开始时间不变，如修改的截至时间如果大于原来的截至时间，则修改；如小于上次修改时间则不修改；
        if (ResControlEnum.CONTROL_STATE.InUse.toString().equals(oldResPrecontrolPolicy.getState())) {
            newResPrecontrolPolicy.setTradeEffectDate(oldResPrecontrolPolicy.getTradeEffectDate());
            if (newResPrecontrolPolicy.getTradeExpiryDate() != null
                    && newResPrecontrolPolicy.getTradeExpiryDate().before(oldResPrecontrolPolicy.getTradeExpiryDate())) {
                newResPrecontrolPolicy.setTradeExpiryDate(oldResPrecontrolPolicy.getTradeExpiryDate());
            }
        }
        if (newResPrecontrolPolicy.getTradeExpiryDate().before(newResPrecontrolPolicy.getTradeEffectDate())) {
            throw new BusinessException("游玩终止日期必须大于等于游玩开始日期");
        }
        Date oldEndDate = oldResPrecontrolPolicy.getTradeExpiryDate();
        Date newEndDate = newResPrecontrolPolicy.getTradeExpiryDate();
        // 保存延期时间
        if (!DateUtil.isTheSameDay(oldEndDate, newEndDate)) {
            newResPrecontrolPolicy.setDelayTime(newEndDate);
        }
        resPrecontrolPolicyService.updateResPreControlForNebula(oldResPrecontrolPolicy, newResPrecontrolPolicy);
        clearCache(newResPrecontrolPolicy);
        StringBuilder strLog = new StringBuilder();
        strLog.append("星云系统更新资源预控，ID：" + newResPrecontrolPolicy.getId() +"；");
        strLog.append(getLogContent(oldResPrecontrolPolicy, newResPrecontrolPolicy));
        // 保存操作日志
        comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.RES_PRECONTROL_POLICY_POLICY, newResPrecontrolPolicy.getId(), newResPrecontrolPolicy.getId(),
                "星云系统", strLog.toString(),
                ComLog.COM_LOG_LOG_TYPE.RES_PRECONTROL_POLICY_CHANGE.name(), "更新资源预控", null);
    }

    private String getLogContent(ResPrecontrolPolicy oldPolicy, ResPrecontrolPolicy resPrecontrolPolicy){
        // 保存操作日志
        String logContent = "";
        if (oldPolicy.getName() != null
                && !oldPolicy.getName().equals(resPrecontrolPolicy.getName())) {
            logContent = logContent + "预控名称：【（原值）" + oldPolicy.getName() + "  修改为：（现值）" + resPrecontrolPolicy.getName()
                    + "】";
        }
        if (oldPolicy.getSupplierName() != null
                && !oldPolicy.getSupplierName().equals(resPrecontrolPolicy.getSupplierName())) {
            logContent = logContent + "】供应商ID：【（原值）" + oldPolicy.getSupplierId() + "  修改为：（现值）"
                    + resPrecontrolPolicy.getSupplierId() + "】供应商名称：【（原值）" + oldPolicy.getSupplierName() + "  修改为：（现值）"
                    + resPrecontrolPolicy.getSupplierName() + "】";
        }
        if (oldPolicy.getControlType() != null
                && !oldPolicy.getControlType().equals(resPrecontrolPolicy.getControlType())) {
            String controlType = "amount".equalsIgnoreCase(oldPolicy.getControlType()) ? "预控金额" : "预控库存";
            String controlType1 = "amount".equalsIgnoreCase(resPrecontrolPolicy.getControlType()) ? "预控金额" : "预控库存";
            Long amount, amount1;
            if ("amount".equalsIgnoreCase(resPrecontrolPolicy.getControlType())) {
                amount = divNumber(resPrecontrolPolicy.getOriginAmount());
            } else {
                amount = resPrecontrolPolicy.getOriginAmount();
            }
            if ("amount".equalsIgnoreCase(oldPolicy.getControlType())) {
                amount1 = divNumber(oldPolicy.getOriginAmount());
            } else {
                amount1 = oldPolicy.getOriginAmount();
            }
            logContent = logContent + "】预控方式：【（原值）" + controlType + "=" + amount1 + "  修改为：（现值）" + controlType1
                    + "=" + amount + "】";
        } else if (oldPolicy.getOriginAmount() != null
                && !oldPolicy.getOriginAmount().equals(resPrecontrolPolicy.getOriginAmount())) {
            String controlType1 = "amount".equalsIgnoreCase(resPrecontrolPolicy.getControlType()) ? "预控金额" : "预控库存";
            Long amount, amount1;
            if ("amount".equalsIgnoreCase(resPrecontrolPolicy.getControlType())) {
                amount1 = divNumber(oldPolicy.getOriginAmount());
                amount = divNumber(resPrecontrolPolicy.getOriginAmount());
            } else {
                amount1 = oldPolicy.getOriginAmount();
                amount = resPrecontrolPolicy.getOriginAmount();
            }
            logContent = logContent + "】" + controlType1 + "：【（原值）" + amount1 + " 修改为：（现值）" + amount + "】";
        }
        if ((oldPolicy.getSaleEffectDate() != null
                && !oldPolicy.getSaleEffectDate().equals(resPrecontrolPolicy.getSaleEffectDate()))
                || (oldPolicy.getSaleExpiryDate() != null
                && !oldPolicy.getSaleExpiryDate().equals(resPrecontrolPolicy.getSaleExpiryDate()))) {
            logContent = logContent + "】销售起止日期：【（原值）"
                    + new SimpleDateFormat("yyyy-MM-dd").format(oldPolicy.getSaleEffectDate()) + " -> "
                    + new SimpleDateFormat("yyyy-MM-dd").format(oldPolicy.getSaleExpiryDate()) + "  修改为：（现值）"
                    + new SimpleDateFormat("yyyy-MM-dd").format(resPrecontrolPolicy.getSaleEffectDate()) + " ->"
                    + new SimpleDateFormat("yyyy-MM-dd").format(resPrecontrolPolicy.getSaleExpiryDate()) + "】";
        }
        if ((oldPolicy.getTradeEffectDate() != null
                && !oldPolicy.getTradeEffectDate().equals(resPrecontrolPolicy.getTradeEffectDate()))
                || (oldPolicy.getTradeExpiryDate() != null
                && !oldPolicy.getTradeExpiryDate().equals(resPrecontrolPolicy.getTradeExpiryDate()))) {
            logContent = logContent + "】游玩起止日期：【（原值）"
                    + new SimpleDateFormat("yyyy-MM-dd").format(oldPolicy.getTradeEffectDate()) + " ->"
                    + new SimpleDateFormat("yyyy-MM-dd").format(oldPolicy.getTradeExpiryDate()) + "  修改为：（现值）"
                    + new SimpleDateFormat("yyyy-MM-dd").format(resPrecontrolPolicy.getTradeEffectDate()) + " ->"
                    + new SimpleDateFormat("yyyy-MM-dd").format(resPrecontrolPolicy.getTradeExpiryDate()) + "】";
        }
        if (oldPolicy.getControlClassification() != null
                && !oldPolicy.getControlClassification().equals(resPrecontrolPolicy.getControlClassification())) {
            String getControlClassification1 = "Daily"
                    .equalsIgnoreCase(resPrecontrolPolicy.getControlClassification()) ? "按日期预控" : "按周期预控";
            String getControlClassification = "Daily".equalsIgnoreCase(oldPolicy.getControlClassification()) ? "按日期预控"
                    : "按周期预控";
            logContent = logContent + "】预控类型：【（原值）" + getControlClassification + " 修改为：（现值）"
                    + getControlClassification1 + "】";
        }
        if (oldPolicy.getIsCanReturn() != null
                && !oldPolicy.getIsCanReturn().equals(resPrecontrolPolicy.getIsCanReturn())) {
            logContent = logContent + "】能否退还：【（原值）" + oldPolicy.getIsCanReturn() + " 修改为：（现值）"
                    + resPrecontrolPolicy.getIsCanReturn() + "】";
        }
        if (oldPolicy.getIsCanDelay() != null
                && !oldPolicy.getIsCanDelay().equals(resPrecontrolPolicy.getIsCanDelay())) {
            logContent = logContent + "】能否延期：【（原值）" + oldPolicy.getIsCanDelay() + " 修改为：（现值）"
                    + resPrecontrolPolicy.getIsCanDelay() + "】";
        }
        if (oldPolicy.getProductManagerName() != null
                && !oldPolicy.getProductManagerName().equals(resPrecontrolPolicy.getProductManagerName())) {
            logContent = logContent + "】产品经理：【（原值）" + oldPolicy.getProductManagerName() + " 修改为：（现值）"
                    + resPrecontrolPolicy.getProductManagerName() + "】";
        }

        if (null != oldPolicy.getProjectNature()
                && !oldPolicy.getProjectNature().equals(resPrecontrolPolicy.getProjectNature())) {
            logContent = logContent + "项目性质：【（原值）" + oldPolicy.getProjectNatureCnName() + "  修改为：（现值）"
                    + resPrecontrolPolicy.getProjectNatureCnName() + "】";
        }
        if (null != oldPolicy.getBuCode() && !oldPolicy.getBuCode().equals(resPrecontrolPolicy.getBuCode())) {
            logContent = logContent + "所属BU：【（原值）" + oldPolicy.getBuCnName() + "  修改为：（现值）"
                    + resPrecontrolPolicy.getBuCnName() + "】";
        }
        if (null != oldPolicy.getArea1() && !oldPolicy.getArea1().equals(resPrecontrolPolicy.getArea1())) {
            logContent = logContent + "一级大区：【（原值）" + oldPolicy.getArea1CnName() + "  修改为：（现值）"
                    + resPrecontrolPolicy.getArea1CnName() + "】";
        }
        if (null != oldPolicy.getArea2() && !oldPolicy.getArea2().equals(resPrecontrolPolicy.getArea2())) {
            logContent = logContent + "二级大区：【（原值）" + oldPolicy.getArea2CnName() + "  修改为：（现值）"
                    + resPrecontrolPolicy.getArea2CnName() + "】";
        }
        if (null != oldPolicy.getPayWay() && !oldPolicy.getPayWay().equals(resPrecontrolPolicy.getPayWay())) {
            logContent = logContent + "付款方式：【（原值）" + oldPolicy.getPayWayCnName() + "  修改为：（现值）"
                    + resPrecontrolPolicy.getPayWayCnName() + "】";
        }
        if (null != oldPolicy.getBuyoutTotalCost()
                && !oldPolicy.getBuyoutTotalCost().equals(resPrecontrolPolicy.getBuyoutTotalCost())) {
            logContent = logContent + "买断总成本：【（原值）" + oldPolicy.getBuyoutTotalCost() + "  修改为：（现值）"
                    + resPrecontrolPolicy.getBuyoutTotalCost() + "】";
        }
        if (null != oldPolicy.getForecastSales()
                && !oldPolicy.getForecastSales().equals(resPrecontrolPolicy.getForecastSales())) {
            logContent = logContent + "预估营业额：【（原值）" + oldPolicy.getForecastSales() + "  修改为：（现值）"
                    + resPrecontrolPolicy.getForecastSales() + "】";
        }
        if (null != oldPolicy.getDepositAmount()
                && !oldPolicy.getDepositAmount().equals(resPrecontrolPolicy.getDepositAmount())) {
            logContent = logContent + "押金：【（原值）" + oldPolicy.getDepositAmount() + "  修改为：（现值）"
                    + resPrecontrolPolicy.getDepositAmount() + "】";
        }
        if (null != oldPolicy.getNameAmount() && !oldPolicy.getNameAmount().equals(resPrecontrolPolicy.getNameAmount())) {
            logContent = logContent + "冠名金额：【（原值）" + oldPolicy.getNameAmount() + "  修改为：（现值）"
                    + resPrecontrolPolicy.getNameAmount() + "】";
        }
        if (null != oldPolicy.getPayMemo() && !oldPolicy.getPayMemo().equals(resPrecontrolPolicy.getPayMemo())) {
            logContent = logContent + "付款备注：【（原值）" + oldPolicy.getPayMemo() + "  修改为：（现值）"
                    + resPrecontrolPolicy.getPayMemo() + "】";
        }
        if (null != oldPolicy.getMemo() && !oldPolicy.getMemo().equals(resPrecontrolPolicy.getMemo())) {
            logContent = logContent + "备注：【（原值）" + oldPolicy.getMemo() + "  修改为：（现值）" + resPrecontrolPolicy.getMemo()
                    + "】";
        }
        return logContent;
    }

    public Long divNumber(Long first) {
        return first / 100;
    }

    /**
     * 检查预控资源对象中非空的字段
     */
    private ResultMessage checkResPreControl(String params) throws BusinessException {
        ResultMessage resultMessage = ResultMessage.createResultMessage();
        if (params == null || params.isEmpty()) {
            resultMessage.setCode(ResultMessage.ERROR);
            resultMessage.setMessage("请求参数为空");
            return resultMessage;
        }
        ResPrecontrolPolicy resPrecontrolPolicy = JSON.parseObject(params, ResPrecontrolPolicy.class);
        if (resPrecontrolPolicy.getNebulaProjectId() == null) {
            resultMessage.setCode(ResultMessage.ERROR);
            resultMessage.setMessage("星云项目id为空");
            return resultMessage;
        }
        String policyJsonStr = JSON.toJSONString(resPrecontrolPolicy, SerializerFeature.WriteMapNullValue);
        JSONObject object = JSON.parseObject(policyJsonStr);
        String action = JSON.parseObject(params).getString("action");
        if (!NEBULA_ACTION.New.name().equalsIgnoreCase(action) && !NEBULA_ACTION.Update.name().equalsIgnoreCase(action)) {
            resultMessage.setCode(ResultMessage.ERROR);
            resultMessage.setMessage("无效的操作类型");
            return resultMessage;
        }
        if (NEBULA_ACTION.New.name().equalsIgnoreCase(action)) {
            Set<Map.Entry<String, Object>> set = object.entrySet();
            Iterator<Map.Entry<String, Object>> iterator = set.iterator();
            Map.Entry<String, Object> entry = null;
            //资源预控对象非空属性
            List<String> propertyList = Arrays.asList("nebulaProjectId", "name", "supplierId", "supplierName", "controlType"
                    , "tradeEffectDate", "tradeExpiryDate", "controlClassification", "productManagerId", "productManagerName"
                    , "amount", "creatTime", "buyoutTotalCost", "forecastSales", "depositAmount", "payWay", "buCode");
            while (iterator.hasNext()) {
                entry = iterator.next();
                if (propertyList.contains(entry.getKey()) && entry.getValue() == null) {
                    resultMessage.setCode(ResultMessage.ERROR);
                    resultMessage.setMessage(RES_PRECONTROL_POLICY.getPropName(entry.getKey()) + "为空");
                    return resultMessage;
                }
            }
        }
        resultMessage.addObject("action", action);
        resultMessage.addObject("resPrecontrolPolicy", resPrecontrolPolicy);
        return resultMessage;
    }
}
