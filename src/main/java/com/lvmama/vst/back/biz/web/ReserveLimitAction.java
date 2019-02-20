package com.lvmama.vst.back.biz.web;

import com.alibaba.fastjson.JSONObject;
import com.lvmama.vst.back.biz.po.BizReserveLimit;
import com.lvmama.vst.back.biz.po.DestReserveLimit;
import com.lvmama.vst.back.biz.service.BizReserveLimitService;
import com.lvmama.vst.back.biz.service.DestReserveLimitService;
import com.lvmama.vst.back.client.prod.service.ProdDestReClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.dujia.client.comm.prod.service.ProdProductDescriptionClientService;
import com.lvmama.vst.back.dujia.comm.prod.po.ProdProductDescription;
import com.lvmama.vst.back.prod.po.ProdDestRe;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdReserveLimit;
import com.lvmama.vst.back.pub.po.ComLog;
import com.lvmama.vst.back.redis.JedisTemplate;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.UUID;

/**
 * 预定条件配置
 * @author caiqing
*/
@Controller
@RequestMapping("/biz/reserveLimit")
public class ReserveLimitAction extends BaseActionSupport{

    private static final long serialVersionUID = 7843662977703659389L;
    private static final Log LOG = LogFactory.getLog(ReserveLimitAction.class);

    @Autowired
    private BizReserveLimitService bizReserveLimitService;
    @Autowired
    private DestReserveLimitService destReserveLimitService;
    @Autowired
    private ComLogClientService comLogClientServiceRemote;
    @Autowired
    private ProdDestReClientService prodDestReClientServiceRemote;
    @Autowired
    private ProdProductDescriptionClientService prodProductDescriptionClientService;
    @Autowired
    private ProdProductClientService prodProductClientServiceRemote;
    private static String SYNC_RESERVE_LIMIT_DOING = "SYNC_RESERVE_LIMIT_DOING";
    private static ExecutorService executorService = Executors.newFixedThreadPool(1);

    /**
     * 预定条件配置页
     */
    @RequestMapping("/showDestReserveLimit")
    public String showDestReserveLimit(Model model, HttpServletRequest request, Integer page){
        int pageNum = page == null?1 : page.intValue();
        Map<String, Object> params = new HashMap<>();
        int count = bizReserveLimitService.findTotalCount(params);
        Page<BizReserveLimit> pageParam = Page.page(count, 10, pageNum);
        pageParam.buildUrl(request);
        params.put("_start", pageParam.getStartRows());
        params.put("_end", pageParam.getEndRows());
        params.put("_orderBy","RESERVE_LIMIT_ID");
        params.put("_order","ASC");
        //获取所有预定条件
        List<BizReserveLimit> bizReserveLimitList = bizReserveLimitService.queryListByParams(params);
        params.clear();
        params.put("bizReserveLimitList", bizReserveLimitList);
        params.put("_orderBy","DEST_LIMIT_ID");
        params.put("_order","ASC");
        //获取预定条件对应的目的地
        List<DestReserveLimit> destReserveLimitList = destReserveLimitService.queryListByParams(params);
        //同一个预定限制条件包含多个目的地
        if(CollectionUtils.isNotEmpty(bizReserveLimitList) && CollectionUtils.isNotEmpty(destReserveLimitList)){
            StringBuilder builder = new StringBuilder();
            for(BizReserveLimit bizReserveLimit : bizReserveLimitList){
                List<DestReserveLimit> limits = new ArrayList<>();
                if(builder.length() > 0){
                    builder.delete(0, builder.length());
                }
                for(DestReserveLimit destReserveLimit : destReserveLimitList){
                    if(destReserveLimit.getReserveLimitId() != null
                            && destReserveLimit.getReserveLimitId().equals(bizReserveLimit.getReserveLimitId())){
                        limits.add(destReserveLimit);
                        if(StringUtils.isNotBlank(destReserveLimit.getDestName())){
                            builder.append(destReserveLimit.getDestName());
                            builder.append("，");
                        }
                    }
                }
                bizReserveLimit.setDestReserveLimitList(limits);
                if(builder.length() > 0){
                    bizReserveLimit.setDestNameStr(builder.substring(0, builder.length()-1));
                }
                bizReserveLimit.setReserveContent(getLimitContent(bizReserveLimit));
            }
        }
        model.addAttribute("bizReserveLimitList", bizReserveLimitList);
        model.addAttribute("pageParam", pageParam);
        return "/biz/reserveLimit/destReserveLimit";
    }

    /**
     * 编辑预定条件配置
     */
    @RequestMapping("/editReserveLimit")
    public String editReserveLimit(Model model, BizReserveLimit bizReserveLimit){
        String contentTemplate = BizReserveLimit.RESERVE_LIMIT_CONTENT.getContent(bizReserveLimit.getReserveType());
        if(BizReserveLimit.RESERVE_LIMIT_CONTENT.age_range_limit.name().equals(bizReserveLimit.getReserveType())){
            String ageUpperStr = "<input type='text' class='ageLimit' name='ageUpperLimit' value='" + bizReserveLimit.getAgeUpperLimit() + "'/>";
            String ageLowerStr = "<input type='text' class='ageLimit' name='ageLowerLimit' value='" + bizReserveLimit.getAgeLowerLimit() + "'/>";
            bizReserveLimit.setReserveContent(String.format(contentTemplate, ageLowerStr, ageUpperStr));
        }else if(BizReserveLimit.RESERVE_LIMIT_CONTENT.advanced_age_limit.name().equals(bizReserveLimit.getReserveType())){
            String ageUpperStr = "<input type='text' class='ageLimit' name='ageUpperLimit' value='" + bizReserveLimit.getAgeUpperLimit() + "'/>";
            bizReserveLimit.setReserveContent(String.format(contentTemplate, ageUpperStr));
        }else if(BizReserveLimit.RESERVE_LIMIT_CONTENT.young_age_limit.name().equals(bizReserveLimit.getReserveType())){
            String ageLowerStr = "<input type='text' class='ageLimit' name='ageLowerLimit' value='" + bizReserveLimit.getAgeLowerLimit() + "'/>";
            bizReserveLimit.setReserveContent(String.format(contentTemplate, ageLowerStr));
        }else {
            bizReserveLimit.setReserveContent(contentTemplate);
        }
        model.addAttribute("bizReserveLimit", bizReserveLimit);
        return "/biz/reserveLimit/editReserveLimit";
    }

    /**
     * 保存预定条件配置
     */
    @RequestMapping("/saveReserveLimit")
    @ResponseBody
    public Object saveReserveLimit(BizReserveLimit bizReserveLimit){
        ResultMessage resultMessage = ResultMessage.createResultMessage();
        if(bizReserveLimit == null || bizReserveLimit.getReserveLimitId() == null){
            resultMessage.raise("参数异常");
            return resultMessage;
        }
        Map<String, Object> params  = new HashMap<>();
        params.put("reserveLimitId", bizReserveLimit.getReserveLimitId());
        List<BizReserveLimit> limitList = bizReserveLimitService.queryListByParams(params);
        if(CollectionUtils.isEmpty(limitList)){
            resultMessage.raise("获取历史数据失败");
            return resultMessage;
        }
        BizReserveLimit oldLimit = limitList.get(0);
        BizReserveLimit limit = new BizReserveLimit();
        limit.setReserveLimitId(bizReserveLimit.getReserveLimitId());
        limit.setReserveType(bizReserveLimit.getReserveType());
        if(BizReserveLimit.RESERVE_LIMIT_CONTENT.age_range_limit.name().equals(bizReserveLimit.getReserveType())){
            if(bizReserveLimit.getAgeLowerLimit() == null || bizReserveLimit.getAgeUpperLimit() == null){
                resultMessage.raise("年龄限制为空");
            }else {
                limit.setAgeLowerLimit(bizReserveLimit.getAgeLowerLimit());
                limit.setAgeUpperLimit(bizReserveLimit.getAgeUpperLimit());
                bizReserveLimitService.updateByPrimaryKeySelective(limit);
            }
        }else if(BizReserveLimit.RESERVE_LIMIT_CONTENT.advanced_age_limit.name().equals(bizReserveLimit.getReserveType())){
            if(bizReserveLimit.getAgeUpperLimit() == null){
                resultMessage.raise("年龄限制为空");
            }else {
                limit.setAgeUpperLimit(bizReserveLimit.getAgeUpperLimit());
                bizReserveLimitService.updateByPrimaryKeySelective(limit);
            }
        }else if(BizReserveLimit.RESERVE_LIMIT_CONTENT.young_age_limit.name().equals(bizReserveLimit.getReserveType())){
            if(bizReserveLimit.getAgeLowerLimit() == null){
                resultMessage.raise("年龄限制为空");
            }else {
                limit.setAgeLowerLimit(bizReserveLimit.getAgeLowerLimit());
                bizReserveLimitService.updateByPrimaryKeySelective(limit);
            }
        }
        if(resultMessage.isSuccess()){
            resultMessage.setMessage("保存成功");
            recordLog(ComLog.COM_LOG_LOG_TYPE.RESERVE_LIMIT_UPDATE, oldLimit, limit);
        }
        return resultMessage;
    }

    /**
     * 日志记录
     */
    private void recordLog(ComLog.COM_LOG_LOG_TYPE logType, BizReserveLimit oldLimit, BizReserveLimit newLimit){
        StringBuilder content = new StringBuilder();
        String limitType = oldLimit.getReserveType();
        if(ComLog.COM_LOG_LOG_TYPE.RESERVE_LIMIT_UPDATE.equals(logType)){
            if(BizReserveLimit.RESERVE_LIMIT_CONTENT.age_range_limit.name().equals(limitType)){
                content.append("【年龄区间旧值："+oldLimit.getAgeLowerLimit()+"-"+oldLimit.getAgeUpperLimit()+"】");
                content.append(",【年龄区间新值："+newLimit.getAgeLowerLimit()+"-"+newLimit.getAgeUpperLimit()+"】");
            }else if(BizReserveLimit.RESERVE_LIMIT_CONTENT.advanced_age_limit.name().equals(limitType)){
                content.append("【高龄限制旧值："+oldLimit.getAgeUpperLimit()+"】");
                content.append(",【高龄限制新值："+newLimit.getAgeUpperLimit()+"】");
            }else if(BizReserveLimit.RESERVE_LIMIT_CONTENT.young_age_limit.name().equals(limitType)){
                content.append("【低龄限制旧值："+oldLimit.getAgeLowerLimit()+"】");
                content.append(",【低龄限制新值："+newLimit.getAgeLowerLimit()+"】");
            }
        }else if(ComLog.COM_LOG_LOG_TYPE.RESERVE_LIMIT_SYNC.equals(logType)){
            content.append("【同步产品预订限制数据】");
        }
        if(content.length() > 0){
            comLogClientServiceRemote.insert(ComLog.COM_LOG_OBJECT_TYPE.RESERVE_LIMIT_OPERATE,
                    oldLimit.getReserveLimitId(),
                    oldLimit.getReserveLimitId(),
                    getLoginUser().getUserName(),
                    content.toString(), logType.name(), logType.getCnName(), null);
        }
    }

    /**
     * 填充模板数据
     */
    private String getLimitContent(BizReserveLimit bizReserveLimit){
        String contentTemplate = BizReserveLimit.RESERVE_LIMIT_CONTENT.getContent(bizReserveLimit.getReserveType());
        if(BizReserveLimit.RESERVE_LIMIT_CONTENT.age_range_limit.name().equals(bizReserveLimit.getReserveType())){
            contentTemplate = String.format(contentTemplate, bizReserveLimit.getAgeLowerLimit(), bizReserveLimit.getAgeUpperLimit());
        }else if(BizReserveLimit.RESERVE_LIMIT_CONTENT.advanced_age_limit.name().equals(bizReserveLimit.getReserveType())){
            contentTemplate = String.format(contentTemplate, bizReserveLimit.getAgeUpperLimit());
        }else if(BizReserveLimit.RESERVE_LIMIT_CONTENT.young_age_limit.name().equals(bizReserveLimit.getReserveType())){
            contentTemplate = String.format(contentTemplate, bizReserveLimit.getAgeLowerLimit());
        }
        return contentTemplate;
    }

    /**
     * 同步数据
     */
    private void syncData(BizReserveLimit bizReserveLimit){
        long start = System.currentTimeMillis();
        try{
            Map<String, Object> params = new HashMap<>();
            params.put("reserveLimitId", bizReserveLimit.getReserveLimitId());
            List<DestReserveLimit> destReserveLimitList = destReserveLimitService.queryListByParams(params);
            if(CollectionUtils.isNotEmpty(destReserveLimitList)){
                Map<Long, BizReserveLimit> destStrictAgeLimitMap = null;
                List<Long> destIds = new ArrayList<>();
                Map<Long, BizReserveLimit> strictProdLimitMap = null;
                if(isAgeLimit(bizReserveLimit)){
                    destStrictAgeLimitMap = new HashMap<>();
                    params.clear();
                    params.put("operationCategory", bizReserveLimit.getOperationCategory());
                    //取该运营类别下,全部目的地与年龄限制的映射数据
                    List<DestReserveLimit> allDestReserveLimitList = destReserveLimitService.queryAllDestWithAgeLimit(params);
                    for(DestReserveLimit destReserveLimit : allDestReserveLimitList){
                        if(isAgeLimit(bizReserveLimit)){
                            //获取最严格的年龄限制条件
                            destStrictAgeLimitMap.put(destReserveLimit.getDestId(), formatAgeLimit(destReserveLimit.getBizReserveLimitList()));
                        }
                    }
                }
                for(DestReserveLimit destReserveLimit : destReserveLimitList){
                    if(destReserveLimit.getDestId() != 0){
                        destIds.add(destReserveLimit.getDestId());
                    }
                }
                params.clear();
                params.put("operation_category", bizReserveLimit.getOperationCategory());
                //非所有目的地的情况，传入具体目的地id
                if(CollectionUtils.isNotEmpty(destIds)){
                    params.put("destIds", destIds);
                }
                params.put("_orderby","pdr.PRODUCT_ID");
                params.put("_order","desc");
                ResultHandleT<Integer> countHandle = prodDestReClientServiceRemote.queryProdCountByParams(params);
                if(countHandle == null || countHandle.getReturnContent() == null){
                    return;
                }
                Integer count = countHandle.getReturnContent();
                LOG.info("同步预订限制的产品数量："+count);
                long totalPageSize = Page.page(count, 500, 1).getTotalPageNum();
                //每次同步500条数据
                for(int i=1; i<=totalPageSize; i++){
                    Page page = Page.page(count, 500, i);
                    params.put("_start", page.getStartRows());
                    params.put("_end", page.getEndRows());
                    ResultHandleT<List<Long>> productIdsHandle = prodDestReClientServiceRemote.queryProductIdListByParams(params);
                    List<Long> productIdList = productIdsHandle.getReturnContent();
                    if(isAgeLimit(bizReserveLimit)){
                        ResultHandleT<List<ProdProduct>> productHandle = prodProductClientServiceRemote.queryProductWithDestRe(productIdList);
                        List<ProdProduct> productList = productHandle.getReturnContent();
                        strictProdLimitMap = mappingStrictProdLimit(productList, destStrictAgeLimitMap);
                    }
                    //产品是否有预订限制历史数据
                    ResultHandleT<List<ProdProductDescription>> prodDescHandle = prodProductDescriptionClientService.queryProdDescByProdIds(productIdList);
                    List<ProdProductDescription> prodDescList = prodDescHandle.getReturnContent();
                    if(CollectionUtils.isNotEmpty(prodDescList)){
                        List<Long> updateProdIds = new ArrayList<>();
                        for(ProdProductDescription description : prodDescList){
                            if(CollectionUtils.isNotEmpty(updateProdIds) && updateProdIds.contains(description.getProductId())){
                                continue;
                            }
                            updateProdIds.add(description.getProductId());
                        }
                        productIdList.removeAll(updateProdIds);
                    }
                    if(isAgeLimit(bizReserveLimit)){
                        //更新历史数据
                        updateProductDesc(prodDescList, true, null, strictProdLimitMap);
                        //插入新增数据
                        insertProductDesc(productIdList,true, null, strictProdLimitMap);
                    }else{
                        //更新历史数据
                        updateProductDesc(prodDescList, false, bizReserveLimit, null);
                        //插入新增数据
                        insertProductDesc(productIdList,false, bizReserveLimit, null);
                    }
                }
            }
        }catch (Exception e){
            LOG.error("出游人预订限制同步数据异常"+ ExceptionFormatUtil.getTrace(e));
        }
        if(JedisTemplate.getWriterInstance() != null){
            //清除缓存中的同步数据标志位
            JedisTemplate.getWriterInstance().del(SYNC_RESERVE_LIMIT_DOING);
        }
        LOG.info("出游人预订限制同步数据耗时："+(System.currentTimeMillis()-start)+"ms");
    }

    private Map<Long, BizReserveLimit> mappingStrictProdLimit(List<ProdProduct> productList, Map<Long, BizReserveLimit> destStrictAgeLimitMap){
        Map<Long, BizReserveLimit> resultMap = new HashMap<>();
        List<BizReserveLimit> bizReserveLimitList = new ArrayList<>();
        for(ProdProduct prodProduct : productList){
            if(CollectionUtils.isNotEmpty(prodProduct.getProdDestReList())){
                bizReserveLimitList.clear();
                for(ProdDestRe prodDestRe : prodProduct.getProdDestReList()){
                    if(destStrictAgeLimitMap.get(prodDestRe.getDestId()) != null){
                        bizReserveLimitList.add(destStrictAgeLimitMap.get(prodDestRe.getDestId()));
                    }
                }
                if(destStrictAgeLimitMap.get(0L) != null){
                    bizReserveLimitList.add(destStrictAgeLimitMap.get(0L));
                }
                resultMap.put(prodProduct.getProductId(), formatAgeLimit(bizReserveLimitList));
            }
        }
        return resultMap;
    }

    /**
     * 查询同步数据是否完成
     */
    @RequestMapping("/querySyncHasCompleted")
    @ResponseBody
    public Object querySyncHasCompleted(String token){
        ResultMessage resultMessage = ResultMessage.createResultMessage();
        String hasCompleted = "Y";
        String cacheValue = JedisTemplate.getReaderInstance().get(SYNC_RESERVE_LIMIT_DOING);
        if(cacheValue != null && cacheValue.equals(token)){
            hasCompleted = "N";
        }
        resultMessage.addObject("hasCompleted", hasCompleted);
        return resultMessage;
    }

    /**
     * 同步预定条件
     */
    @RequestMapping("/syncReserveLimit")
    @ResponseBody
    public Object syncReserveLimit(BizReserveLimit bizReserveLimit){
        ResultMessage resultMessage = ResultMessage.createResultMessage();
        if(bizReserveLimit == null || bizReserveLimit.getReserveLimitId() == null){
            resultMessage.raise("数据同步失败，参数为空");
            return resultMessage;
        }
        Map<String, Object> params = new HashMap<>();
        params.put("reserveLimitId", bizReserveLimit.getReserveLimitId());
        List<BizReserveLimit> reserveLimitList = bizReserveLimitService.queryListByParams(params);
        if(CollectionUtils.isEmpty(reserveLimitList)){
            resultMessage.raise("数据同步失败，查询数据异常");
            return resultMessage;
        }
        final BizReserveLimit limit = reserveLimitList.get(0);
        if(JedisTemplate.getWriterInstance() == null){
            resultMessage.raise("数据同步失败，获取redis实例失败");
            return resultMessage;
        }
        String token = UUID.randomUUID().toString();
        //redis分布式锁，阻止并发
        if(JedisTemplate.getWriterInstance().setnx(SYNC_RESERVE_LIMIT_DOING,token)){
            resultMessage.addObject("token", token);
            //子线程执行同步数据操作
            executorService.execute(new Runnable() {
                @Override
                public void run() {
                    syncData(limit);
                }
            });
            //记录日志
            recordLog(ComLog.COM_LOG_LOG_TYPE.RESERVE_LIMIT_SYNC, bizReserveLimit, null);
        }else {
            resultMessage.raise("系统正在同步数据，请稍后再操作");
        }
        return resultMessage;
    }

    /**
     * 是否属于年龄限制
     */
    private boolean isAgeLimit(BizReserveLimit bizReserveLimit){
        return BizReserveLimit.RESERVE_LIMIT_CONTENT.age_range_limit.name().equals(bizReserveLimit.getReserveType())
                || BizReserveLimit.RESERVE_LIMIT_CONTENT.advanced_age_limit.name().equals(bizReserveLimit.getReserveType())
                || BizReserveLimit.RESERVE_LIMIT_CONTENT.young_age_limit.name().equals(bizReserveLimit.getReserveType());
    }

    /**
     * 取最严格的年龄限制
     */
    private BizReserveLimit formatAgeLimit(List<BizReserveLimit> strictAgeLimits){
        if(CollectionUtils.isEmpty(strictAgeLimits)){
            return null;
        }
        BizReserveLimit bizReserveLimit = new BizReserveLimit();
        Integer upperLimit = null;
        Integer lowerLimit = null;
        for(BizReserveLimit limit : strictAgeLimits){
            if(limit.getAgeUpperLimit() != null){
                if(upperLimit == null || upperLimit > limit.getAgeUpperLimit()){
                    upperLimit = limit.getAgeUpperLimit();
                }
            }
            if(limit.getAgeLowerLimit() != null){
                if(lowerLimit == null || lowerLimit < limit.getAgeLowerLimit()){
                    lowerLimit = limit.getAgeLowerLimit();
                }
            }
        }
        bizReserveLimit.setAgeUpperLimit(upperLimit);
        bizReserveLimit.setAgeLowerLimit(lowerLimit);
        if(upperLimit != null && lowerLimit != null){
            bizReserveLimit.setReserveType(BizReserveLimit.RESERVE_LIMIT_CONTENT.age_range_limit.name());
        }else if(upperLimit != null){
            bizReserveLimit.setReserveType(BizReserveLimit.RESERVE_LIMIT_CONTENT.advanced_age_limit.name());
        }else if(lowerLimit != null){
            bizReserveLimit.setReserveType(BizReserveLimit.RESERVE_LIMIT_CONTENT.young_age_limit.name());
        }
        return bizReserveLimit;
    }

    /**
     * 批量更新预定限制
     */
    private void updateProductDesc(List<ProdProductDescription> prodDescList, boolean isAgeLimit, BizReserveLimit noAgeLimit, Map<Long, BizReserveLimit> strictProdLimitMap){
        if(CollectionUtils.isEmpty(prodDescList)){
            return;
        }
        BizReserveLimit bizReserveLimit = null;
        String limitKey = null;
        if(!isAgeLimit){
            bizReserveLimit = noAgeLimit;
        }
        List<ProdProductDescription> saveProdDescList = new ArrayList<>();
        for(ProdProductDescription description : prodDescList){
            if(isAgeLimit){
                bizReserveLimit = strictProdLimitMap.get(description.getProductId());
            }
            if(bizReserveLimit == null){
                continue;
            }
            limitKey = ProdReserveLimit.PROD_RESERVE_LIMIT.getDataKey(bizReserveLimit.getReserveType());
            ProdReserveLimit prodReserveLimit = JSONObject.parseObject(description.getContent(), ProdReserveLimit.class);
            if(prodReserveLimit != null){
                List<String> limitInfo = prodReserveLimit.getLimitInfor();
                if(limitInfo == null){
                    limitInfo = new ArrayList<>();
                    limitInfo.add(limitKey);
                }else {
                    if(!limitInfo.contains(limitKey)){
                        limitInfo.add(limitKey);
                    }
                }
                prodReserveLimit.setLimitInfor(limitInfo);
            }else {
                prodReserveLimit = new ProdReserveLimit();
                List<String> limitInfo = new ArrayList<>();
                limitInfo.add(limitKey);
                prodReserveLimit.setLimitInfor(limitInfo);
            }
            prodReserveLimit.setAgeRangeLower(bizReserveLimit.getAgeLowerLimit());
            prodReserveLimit.setAgeRangeUpper(bizReserveLimit.getAgeUpperLimit());
            prodReserveLimit.setDataFromSync("Y");
            description.setContent(JSONObject.toJSONString(prodReserveLimit));
            description.setClobFlag("N");
            saveProdDescList.add(description);
        }
        prodProductDescriptionClientService.batchUpdateProdDesc(saveProdDescList);
    }

    /**
     * 批量插入预定限制
     */
    private void insertProductDesc(List<Long> prodIds, boolean isAgeLimit, BizReserveLimit noAgeLimit, Map<Long, BizReserveLimit> strictProdLimitMap){
        if(CollectionUtils.isEmpty(prodIds)){
            return;
        }
        ResultHandleT<List<ProdProduct>> resultHandleT = prodProductClientServiceRemote.queryProdListByIds(prodIds);
        if(resultHandleT == null || resultHandleT.getReturnContent() == null){
            return;
        }
        BizReserveLimit bizReserveLimit = null;
        if(!isAgeLimit){
            bizReserveLimit = noAgeLimit;
        }
        List<ProdProduct> productList = resultHandleT.getReturnContent();
        List<Long> needInsertProdIds = new ArrayList<>();
        List<ProdProductDescription> saveProdDescList = new ArrayList<>();
        for(ProdProduct prodProduct : productList){
            if(CollectionUtils.isNotEmpty(needInsertProdIds)
                    && needInsertProdIds.contains(prodProduct.getProductId())){
                continue;
            }
            if(isAgeLimit){
                bizReserveLimit = strictProdLimitMap.get(prodProduct.getProductId());
            }
            if(bizReserveLimit == null){
                continue;
            }
            needInsertProdIds.add(prodProduct.getProductId());
            ProdReserveLimit prodReserveLimit = new ProdReserveLimit();
            prodReserveLimit.setDataFromSync("Y");
            List<String> limitInfor = new ArrayList<>();
            limitInfor.add(ProdReserveLimit.PROD_RESERVE_LIMIT.getDataKey(bizReserveLimit.getReserveType()));
            prodReserveLimit.setLimitInfor(limitInfor);
            if(isAgeLimit(bizReserveLimit)){
                if(bizReserveLimit.getAgeLowerLimit() != null){
                    prodReserveLimit.setAgeRangeLower(bizReserveLimit.getAgeLowerLimit());
                }
                if(bizReserveLimit.getAgeUpperLimit() != null){
                    prodReserveLimit.setAgeRangeUpper(bizReserveLimit.getAgeUpperLimit());
                }
            }
            ProdProductDescription description = new ProdProductDescription();
            description.setProductId(prodProduct.getProductId());
            description.setCategoryId(prodProduct.getBizCategoryId());
            description.setProductType(prodProduct.getProductType());
            description.setContentType(ProdProductDescription.CONTENT_TYPE.RESERVE_LIMIT.name());
            description.setContent(JSONObject.toJSONString(prodReserveLimit));
            description.setClobFlag("N");
            saveProdDescList.add(description);
        }
        prodProductDescriptionClientService.batchInsertProdDesc(saveProdDescList);
    }
}
