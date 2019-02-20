package com.lvmama.vst.back.prod.productSupplier;

import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.prod.service.ProdEcontractClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.supp.service.SuppContractClientService;
import com.lvmama.vst.back.client.supp.service.SuppSettleRuleClientService;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.service.ProdSupplierService;
import com.lvmama.vst.back.prod.vo.ProdSupplierInfoVO;
import com.lvmama.vst.back.prod.vo.ProductSupplier;
import com.lvmama.vst.back.pub.po.ComLog;
import com.lvmama.vst.back.supp.po.SuppContract;
import com.lvmama.vst.back.supp.po.SuppSettleRule;
import com.lvmama.vst.back.supp.po.SuppSettlementEntities;
import com.lvmama.vst.back.supp.service.SuppSettlementEntitiesService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.ebooking.client.ebk.serivce.EbkSupplierGroupClientService;
import com.lvmama.vst.ebooking.ebk.po.EbkSupplierGroup;
import com.lvmama.vst.ebooking.ebk.vo.ZTreeNode;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * 批量更换产品供应商组织Action
 */
@Controller
@RequestMapping("/prod/changeProductSupplier")
public class ChangeProductSupplierAction extends BaseActionSupport{


    private static final Log log= LogFactory.getLog(ChangeProductSupplierAction.class);
    @Autowired
    private ProdSupplierService prodSupplierService;
    @Autowired
    private EbkSupplierGroupClientService ebkSupplierGroupClientRemote;
    @Autowired
    private SuppContractClientService suppContractService;
    @Autowired
    private SuppSettleRuleClientService suppSettleRuleService;
    @Autowired
    private ProdProductClientService prodProductService;
    @Autowired
    private ComLogClientService comLogService;
    @Autowired
    private SuppGoodsClientService suppGoodsService;

    @Autowired
    private SuppSettlementEntitiesService suppSettlementEntitiesService;
    @Autowired
    private ProdEcontractClientService prodEcontractClientService;
    /**
     * 根据条件查询产品及供应商信息
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/showProductSupplier")
    public String showProductSupplier(Model model, HttpServletRequest request, HttpServletResponse response, ProductSupplier productSupplier, Integer page,String redirectType){
        model.addAttribute("productSupplier",productSupplier);
        model.addAttribute("redirectType", redirectType);
        // vst组织鉴权
        //super.vstOrgAuthentication(log, prodProduct.getManagerIdPerm());
        if (page == null && StringUtil.isEmptyString(redirectType)) {
            model.addAttribute("redirectType", "1"  );
            return "/prod/productSupplier/showProductSupplier";
        }
        Map<String, Object> param= Maps.newHashMap();
        assembleParam(productSupplier,param);
        int count=prodSupplierService.findProdSupplierCountByParam(param);
        int pagenum = page == null ? 1 : page;
        Page pageParam = Page.page(count, 15, pagenum);
        pageParam.buildUrl(request);
        param.put("_start", pageParam.getStartRows());
        param.put("_end", pageParam.getEndRows());
        List<ProdSupplierInfoVO> prodSupplierInfoVoList=prodSupplierService.findProdSupplierByParam(param);
        if(prodSupplierInfoVoList !=null && prodSupplierInfoVoList.size() > 0){
            getContractAndSettlementInfo(prodSupplierInfoVoList);
        }
        model.addAttribute("ProdSupplierInfoVoList",prodSupplierInfoVoList);
        model.addAttribute("pageParam", pageParam);
        return "/prod/productSupplier/showProductSupplier";
    }

    /***
     * 根据供应商查找审核通过的合同列表
     *
     * @return
     */
    @RequestMapping(value = "/selectContractListBySupplier")
    public String selectContractListBySupplier(Model model, Long supplierId) throws BusinessException {
        if (log.isDebugEnabled()) {
            log.debug("start method<selectContractListBySupplier>");
        }
        SuppContract suppContract=new SuppContract();
        suppContract.setSupplierId(supplierId);
        suppContract.setContractStatus(SuppContract.CONTRACT_AUDIT.PASS.getCode());// 查询审核通过的合同
        List<SuppContract> suppContractList = MiscUtils.autoUnboxing(suppContractService.findSuppContractListBySupplierId(suppContract));

        // 合同结算主体
        for (SuppContract contract : suppContractList) {
            SuppSettleRule suppSettleRule = suppSettleRuleService.findSuppSettleRuleByContractId(contract.getContractId());
            contract.setSuppSettleRule(suppSettleRule);
        }

        model.addAttribute("suppContractList", suppContractList);
        model.addAttribute("accSubjectList", SuppContract.ACC_SUBJECT.values());
        model.addAttribute("lvAccSubjectList", SuppSettleRule.LVACC_SUBJECT.values());
        return "/prod/productSupplier/changeSupplier-contract-iframe";
    }

    /**
     * 返回更换供应商静态页面
     * @param model
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/selectSupplier")
    public String selectSupplier(Model model,HttpServletRequest request,HttpServletResponse response){

       return "/prod/productSupplier/changeSupplier-iframe";
    }
    /**
     * 获取供应商组列表
     */
    @RequestMapping(value = "/getEbkSupplierGroupsByParams")
    @ResponseBody
    public Object getEbkSupplierGroupsByParams(HttpServletRequest req, HttpServletResponse res,Long supplierId){
        List<ZTreeNode> nodeList = new ArrayList<ZTreeNode>();
        Map<String, Object> params = new HashMap<String, Object>();
        List<EbkSupplierGroup> ebkSupplierGroups;
        Map<String,Object> resultMap=Maps.newHashMap();
        try {
            params.put("supplierId", supplierId);
            params.put("cancelFlag", "Y");
            ebkSupplierGroups = ebkSupplierGroupClientRemote.getEbkSupplierGroupsByParams(params).getReturnContent();

            for(EbkSupplierGroup item : ebkSupplierGroups){
                ZTreeNode node = new ZTreeNode();
                node.setId(item.getGroupId().toString());
                node.setpId(item.getParentId().toString());
                node.setName(item.getGroupName());
                //获取根节点 即总部
                if(item.getLevelCode()==0){
                    resultMap.put("baseNode",node);
                }
                nodeList.add(node);
            }
            resultMap.put("nodeList",nodeList);
        } catch (Exception e) {
            log.error("error method<getPermissionTree>", e);
        }
        return resultMap;
    }

    /**
     * 批量更新产品和商品表的供应商信息
     * @param request
     * @param response
     * @param prodSupplierInfoVo
     * @return
     */
    @RequestMapping("/updateProductsSupplier")
    @ResponseBody
    public Object updateProductsSupplier(HttpServletRequest request,HttpServletResponse response,ProdSupplierInfoVO prodSupplierInfoVo){

        if(prodSupplierInfoVo == null ){
            return new ResultMessage(ResultMessage.ERROR,"参数异常");
        }
        List<Long> productIdList= prodSupplierInfoVo.getProductIds();
        if(productIdList == null || productIdList.size() ==0){
            return new ResultMessage(ResultMessage.ERROR,"产品id为空！");
        }
        Long supplierId=prodSupplierInfoVo.getSupplierId();
        if(supplierId == null){
            return new ResultMessage(ResultMessage.ERROR,"供应商Id为空！");
        }
        Long ebkSupplierGroupId=prodSupplierInfoVo.getSupplierGroupId();
        if(ebkSupplierGroupId ==null){
            return new ResultMessage(ResultMessage.ERROR,"供应商组为空！");
        }
        Long contractId=prodSupplierInfoVo.getContractId();
        if(contractId ==null){
            return new ResultMessage(ResultMessage.ERROR,"供应商合同为空！");
        }
        String suppSettlementEntityCode =prodSupplierInfoVo.getSuppSettlementEntityCode();
        String buyoutSuppSettlementEntityCode = prodSupplierInfoVo.getBuyoutSuppSettlementEntityCode();
        if((suppSettlementEntityCode ==null || suppSettlementEntityCode =="") && (buyoutSuppSettlementEntityCode ==null || buyoutSuppSettlementEntityCode =="") ){
            return new ResultMessage(ResultMessage.ERROR,"至少有一个结算对象不为空！");
        }
        Map<String, Object> productParams=Maps.newHashMap();
        productParams.put("productIds",productIdList);
        productParams.put("supplierId",supplierId);
        productParams.put("ebkSupplierGroupId",ebkSupplierGroupId);
        productParams.put("contractId",contractId);
        productParams.put("suppSettlementEntityCode",suppSettlementEntityCode);
        productParams.put("buyoutSuppSettlementEntityCode",buyoutSuppSettlementEntityCode);
        productParams.put("companyType",prodSupplierInfoVo.getCompanyType());

        Map<String, Object> goodsParams=Maps.newHashMap();
        goodsParams.put("productIdList",productIdList);
        //先查询出所有商品 写日志使用
        ResultHandleT<List<SuppGoods>> goodsResult=suppGoodsService.findSuppGoodsList(goodsParams);

        ResultHandleT<Integer> result= prodProductService.updateProductSuppGroupBatch(productParams);
        if(result==null || result.hasNull()){
            return new ResultMessage(ResultMessage.ERROR,"更换供应商失败！");
        }
        productParams.put("supplierName",prodSupplierInfoVo.getSupplierName());
        try {

            int count=prodEcontractClientService.updateSupplierIdBatch(productParams);
            if(count <= 0){
                log.info("批量更换供应商时,没有相关供应商信息同步到电子合同表！");
            }
        }catch (Exception e){
            log.error("批量更换供应商时,电子合同表同步供应商失败"+e.getMessage());
        }
        List<SuppGoods> goodsList=null;
        if(goodsResult !=null && goodsResult.getReturnContent()!=null){
            goodsList=goodsResult.getReturnContent();
        }

        recordUpdateLog(prodSupplierInfoVo,goodsList);
        return new ResultMessage(ResultMessage.SUCCESS,"更换供应商成功！");
    }

    /**
     * 批量更换供应商日志记录
     * @param prodSupplierInfoVo
     * @param goodsList
     */
    private void recordUpdateLog(ProdSupplierInfoVO prodSupplierInfoVo,List<SuppGoods> goodsList){
        String oldSupplierName=prodSupplierInfoVo.getOldSupplierName();
        StringBuffer batchProductLogContent=new StringBuffer("将产品ID为");
        String memo="";
        String contracName=prodSupplierInfoVo.getContractName()==null?"":prodSupplierInfoVo.getContractName();
        String settCodeName=prodSupplierInfoVo.getSuppSettlementEntityName()==null?"":prodSupplierInfoVo.getSuppSettlementEntityName();
        String settCode=prodSupplierInfoVo.getSuppSettlementEntityCode()==null?"":prodSupplierInfoVo.getSuppSettlementEntityCode();
        String buyoutSettCodeName=prodSupplierInfoVo.getBuyoutSuppSettlementEntityName();
        String buyoutSettCode=prodSupplierInfoVo.getBuyoutSuppSettlementEntityCode();
        String settCodeLog="";
        String buyoutSettCodeLog="";
        if(settCode!=null && settCode !=""){
            settCodeLog="非买断结算对象变更为"+settCodeName+"，非买断结算对象Code变更为"+settCode+"。";
        }
        if(buyoutSettCode!=null && buyoutSettCode !=""){
            buyoutSettCodeLog="买断结算对象变更为"+buyoutSettCodeName+"，买断结算对象Code变更为"+buyoutSettCode+"。";
        }
        //判断供应商组有没有更改
        if(!prodSupplierInfoVo.getSupplierGroupId().equals(prodSupplierInfoVo.getOldSupplierGroupId())){
            memo=memo+"供应商"+prodSupplierInfoVo.getSupplierName()+"更换了所属组织，由【"+prodSupplierInfoVo.getOldSupplierGroupName()
                    +"】变更为【"+prodSupplierInfoVo.getSupplierGroupName()+"】。";
        }
        StringBuffer productStr=new StringBuffer();
        ArrayList<Long> productIds=prodSupplierInfoVo.getProductIds();
        for(int i=0;i< productIds.size();i++){
            if(i==0){
                productStr.append(productIds.get(i));
            }else {
                productStr.append(","+productIds.get(i));
            }
        }
        batchProductLogContent.append(productStr);
        if(oldSupplierName!=null && oldSupplierName!=""){
            batchProductLogContent.append("的供应商由【"+oldSupplierName+"】更改为：【"+prodSupplierInfoVo.getSupplierName()+"】。");
        }else {
            batchProductLogContent.append("的供应商更改为：【"+prodSupplierInfoVo.getSupplierName()+"】。");
        }
        batchProductLogContent.append("商品合同变更为"+contracName).append(";").append(settCodeLog).append(buyoutSettCodeLog);
        // 添加批量修改供应商LOG日志
        try {
            if(StringUtil.isNotEmptyString(batchProductLogContent.toString())){
                comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.PROD_PRODUCT_SUPPLIER,
                        null,null ,
                        this.getLoginUser().getUserName(),
                        "修改产品供应商组:" + batchProductLogContent,
                        ComLog.COM_LOG_LOG_TYPE.PROD_PRODUCT_SUPPLIER_BATCH_CHANGE.name(),
                        "修改产品供应商组",memo);
            }

        } catch (Exception e) {
            log.error("Record Log failure ！Log type:"+ ComLog.COM_LOG_LOG_TYPE.TRAVEL_RECOMMEND_GUIDE_CHANGE.name());
            log.error(e.getMessage());
        }
        //商品不为空
        if(goodsList !=null && goodsList.size() > 0){
            for(SuppGoods  suppGoods: goodsList){
                StringBuffer singleGoodsLogContent=new StringBuffer("商品的供应商");
                if(oldSupplierName!=null &&  oldSupplierName!=""){
                    singleGoodsLogContent.append("由【"+oldSupplierName+"】更改为：【"+prodSupplierInfoVo.getSupplierName()+"】。");
                }else {
                    singleGoodsLogContent.append("更改为：【"+prodSupplierInfoVo.getSupplierName()+"】。");
                }
                singleGoodsLogContent.append("商品合同变更为"+contracName).append(";").append(settCodeLog).append(buyoutSettCodeLog);
                try {
                    // 添加修改商品供应商信息操作日志
                    if (null != singleGoodsLogContent && !"".equals(singleGoodsLogContent)) {
                        comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS,
                                suppGoods.getProductId(), suppGoods.getSuppGoodsId(),
                                this.getLoginUser().getUserName(),
                                "修改了商品：【"+suppGoods.getGoodsName()+"】,变更内容："+singleGoodsLogContent,
                                ComLog.COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(),
                                "修改商品",memo);
                    }
                } catch (Exception e) {
                    log.error("Record Log failure ！Log Type:" + ComLog.COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
                    log.error(e.getMessage());
                }
            }
        }
    }
    /**
     * 组装查询参数
     * @param productSupplier
     * @param param
     */
    private void assembleParam(ProductSupplier productSupplier,Map<String, Object> param){
        if(productSupplier !=null){
            String productIds=productSupplier.getProductIds();
            if (StringUtils.isNotEmpty(productIds)) {
                List<Long> prodIds = new ArrayList<Long>();
                String[] strs = productIds.split("\\D");
                if (null != strs && strs.length > 0) {
                    for (int i = 0; i < strs.length; i++) {
                        if (StringUtil.isNumber(strs[i])) {
                            try {
                                prodIds.add(Long.valueOf(strs[i]));
                            } catch (Exception e) {
                            }
                        }
                    }
                }
                if (CollectionUtils.isNotEmpty(prodIds)) {
                    param.put("productIds", prodIds);
                }else {
                    param.put("productIds", new Long[] { -1L });
                }
            }
            param.put("supplierId",productSupplier.getSupplierId());
            param.put("supplierName",productSupplier.getSupplierName());
            String productType=productSupplier.getProductType();
            List<Long> categoryIds=new ArrayList<Long>();
            List<String> productTypes=new ArrayList<String>();
            List<String> innerProductTypes=new ArrayList<String>();
            innerProductTypes.add(ProdProduct.PRODUCTTYPE.INNERSHORTLINE.getCode());
            innerProductTypes.add(ProdProduct.PRODUCTTYPE.INNERLONGLINE.getCode());
            innerProductTypes.add(ProdProduct.PRODUCTTYPE.INNER_BORDER_LINE.getCode());
            if(productType !=null && productType !=""){
                if("INNER_15".equals(productType)){
                    categoryIds.add(15L);
                    productTypes.addAll(innerProductTypes);
                }else if("INNER_16".equals(productType)){
                    productTypes.addAll(innerProductTypes);
                    categoryIds.add(16L);
                } else if("FOREIGN_15".equals(productType)){
                    categoryIds.add(15L);
                    productTypes.clear();
                    productTypes.add(ProdProduct.PRODUCTTYPE.FOREIGNLINE.getCode());
                }else if("FOREIGN_16".equals(productType)){
                    categoryIds.add(16L);
                    productTypes.clear();
                    productTypes.add(ProdProduct.PRODUCTTYPE.FOREIGNLINE.getCode());
                }else if("FOREIGN_18".equals(productType)){
                    categoryIds.add(18L);
                    productTypes.clear();
                    productTypes.add(ProdProduct.PRODUCTTYPE.FOREIGNLINE.getCode());
                }else{
                    categoryIds.add(15L);
                    categoryIds.add(16L);
                    categoryIds.add(18L);
                }
            }else {
                categoryIds.add(15L);
                categoryIds.add(16L);
                categoryIds.add(18L);
            }
            param.put("categoryIds",categoryIds);
            param.put("productTypes",productTypes);
        }
    }

    /**
     * 分别获取合同name 和结算对象名称
     * @param ProdSupplierInfoVoList
     * 暂时没有批量查询合同和结算对象接口 所以先循环单个查询
     */
    private void getContractAndSettlementInfo(List<ProdSupplierInfoVO> ProdSupplierInfoVoList){
        HashMap<String,String> settCodeMap=Maps.newHashMap();
        HashMap<String,String> buyoutSettCodeMap=Maps.newHashMap();
        HashMap<Long,String> contractIdMap=Maps.newHashMap();
        ArrayList<String> settCodeList = Lists.newArrayList();
        ArrayList<String> buyoutSettCodeList = Lists.newArrayList();
        ArrayList<Long> contractIdList = Lists.newArrayList();

        for(ProdSupplierInfoVO ProdSupplierInfoVo: ProdSupplierInfoVoList){
            if(ProdSupplierInfoVo.getSuppSettlementEntityCode() !=null){
                settCodeList.add(ProdSupplierInfoVo.getSuppSettlementEntityCode());
            }
            if(ProdSupplierInfoVo.getContractId() != null){
                contractIdList.add(ProdSupplierInfoVo.getContractId());
            }
            if(ProdSupplierInfoVo.getBuyoutSuppSettlementEntityCode() != null){
                buyoutSettCodeList.add(ProdSupplierInfoVo.getBuyoutSuppSettlementEntityCode());
            }
        }

        if(settCodeList.size() > 0){
            for(int i=0;i<settCodeList.size();i++){
                if(settCodeList.get(i)!=null && settCodeList.get(i)!= ""){
                    SuppSettlementEntities suppSettlementEntitie=suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(settCodeList.get(i));
                    if(suppSettlementEntitie !=null){
                        String settCode=suppSettlementEntitie.getCode();
                        if(settCode!=null && !settCodeMap.containsKey(settCode)){
                            settCodeMap.put(settCode,suppSettlementEntitie.getName());
                        }
                    }
                }
            }
        }
        if(buyoutSettCodeList.size() > 0){
            for(int i=0;i<buyoutSettCodeList.size();i++){
                if(buyoutSettCodeList.get(i)!=null && buyoutSettCodeList.get(i)!= ""){
                    SuppSettlementEntities suppSettlementEntitie=suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(buyoutSettCodeList.get(i));
                    if(suppSettlementEntitie !=null){
                        String buyoutSettCode=suppSettlementEntitie.getCode();
                        if(buyoutSettCode!=null && !buyoutSettCodeMap.containsKey(buyoutSettCode)){
                            buyoutSettCodeMap.put(buyoutSettCode,suppSettlementEntitie.getName());
                        }
                    }
                }
            }
        }
        if(contractIdList.size() > 0){
            for(int j=0;j<contractIdList.size();j++){
                Long contractId=contractIdList.get(j);
                if(contractId !=null){
                    SuppContract suppContract=suppContractService.findSuppContractById(contractId);
                    if(suppContract!=null && !contractIdMap.containsKey(suppContract.getContractId())){
                        contractIdMap.put(contractId,suppContract.getContractName());
                    }
                }
            }
        }

        if(ProdSupplierInfoVoList !=null && ProdSupplierInfoVoList.size() > 0){
            for(ProdSupplierInfoVO ProdSupplierInfoVo: ProdSupplierInfoVoList){
                if(ProdSupplierInfoVo.getSuppSettlementEntityCode() !=null){
                    String settCodeName=settCodeMap.get(ProdSupplierInfoVo.getSuppSettlementEntityCode())==null?"":settCodeMap.get(ProdSupplierInfoVo.getSuppSettlementEntityCode());
                    ProdSupplierInfoVo.setSuppSettlementEntityName(settCodeName);
                }
                if(ProdSupplierInfoVo.getBuyoutSuppSettlementEntityCode() !=null){
                    String buyoutSettCodeName=buyoutSettCodeMap.get(ProdSupplierInfoVo.getBuyoutSuppSettlementEntityCode())==null?"":buyoutSettCodeMap.get(ProdSupplierInfoVo.getBuyoutSuppSettlementEntityCode());
                    ProdSupplierInfoVo.setBuyoutSuppSettlementEntityName(buyoutSettCodeName);
                }
                if(ProdSupplierInfoVo.getContractId() != null){
                    String contractName=  contractIdMap.get(ProdSupplierInfoVo.getContractId())==null?"":contractIdMap.get(ProdSupplierInfoVo.getContractId());
                    ProdSupplierInfoVo.setContractName(contractName);
                }
            }
        }
    }
}
