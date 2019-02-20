package com.lvmama.vst.back.goods.web.finance;

import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.comm.tnt.po.TntChannelVo;
import com.lvmama.comm.tnt.po.TntGoodsChannelVo;
import com.lvmama.comm.tnt.po.TntUserVo;
import com.lvmama.price.api.comm.vo.PriceResultHandleT;
import com.lvmama.price.api.strategy.model.vo.FinancialGoodsTimePriceVo;
import com.lvmama.price.api.strategy.service.FinancialGoodsTimePriceApiService;
import com.lvmama.vst.back.biz.po.BizOrderRequired;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.client.biz.service.BizBuEnumClientService;
import com.lvmama.vst.back.client.biz.service.BizOrderRequiredClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.pub.service.ComOrderRequiredClientService;
import com.lvmama.vst.back.client.supp.service.SuppContractClientService;
import com.lvmama.vst.back.client.supp.service.SuppSupplierClientService;
import com.lvmama.vst.back.dist.po.DistDistributorGoods;
import com.lvmama.vst.back.dist.po.Distributor;
import com.lvmama.vst.back.dist.service.DistributorCachedService;
import com.lvmama.vst.back.dist.service.DistributorGoodsService;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.goods.service.FinanceInterestsBonusService;
import com.lvmama.vst.back.goods.vo.ProdProductParam;
import com.lvmama.vst.back.goods.vo.SuppGoodsParam;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductBranch;
import com.lvmama.vst.back.prod.service.ProdProductBranchService;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.pub.po.ComLog;
import com.lvmama.vst.back.pub.po.ComOrderRequired;
import com.lvmama.vst.back.supp.po.SuppContract;
import com.lvmama.vst.back.supp.po.SuppSettleRule;
import com.lvmama.vst.back.supp.po.SuppSettlementEntities;
import com.lvmama.vst.back.supp.po.SuppSupplier;
import com.lvmama.vst.back.supp.service.SuppSettlementEntitiesService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.Constants;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.utils.bean.EnhanceBeanUtils;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.ResultHandle;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;
import com.lvmama.vst.pet.adapter.TntGoodsChannelCouponAdapter;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
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
import java.math.BigDecimal;
import java.util.*;

@Controller
@RequestMapping("/finance/goods")
public class FinanceSuppGoodsAction extends BaseActionSupport {

    private static final long serialVersionUID = -5966494518894003774L;

    private static final Log LOG = LogFactory.getLog(FinanceSuppGoodsAction.class);
    @Autowired
    private ProdProductService prodProductService;
    @Autowired
    private ProdProductBranchService prodProductBranchService;
    @Autowired
    private BizCategoryQueryService bizCategoryQueryService;
    @Autowired
    private SuppSupplierClientService suppSupplierService;
    @Autowired
    private SuppGoodsClientService suppGoodsService;
    @Autowired
    private PermUserServiceAdapter permUserServiceAdapter;
    @Autowired
    private SuppContractClientService suppContractService;
    @Autowired
    private BizBuEnumClientService bizBuEnumClientService;
    @Autowired
    private DistributorCachedService distributorService;
    @Autowired
    private TntGoodsChannelCouponAdapter tntGoodsChannelCouponServiceRemote;
    @Autowired
    private DistributorGoodsService distributorGoodsService;
    @Autowired
    private SuppSettlementEntitiesService suppSettlementEntitiesService; // 结算对象SETTLE_ENTITY_MARK
    @Autowired
    private ComLogClientService comLogService;
    @Autowired
    private FinancialGoodsTimePriceApiService financialGoodsTimePriceApiService;
    @Autowired
    private BizOrderRequiredClientService bizOrderRequiredClientService;
    @Autowired
    private ComOrderRequiredClientService comOrderRequiredService;
    @Autowired
    private FinanceInterestsBonusService financeInterestsBonusService;


    @RequestMapping(value = "/showSuppGoodsListCheck")
    @ResponseBody
    public Object showSuppGoodsListCheck(HttpServletRequest req) throws BusinessException {

        ResultMessage message = null;
        if (req.getParameter("productId") != null) {
            ProdProduct prodProduct = prodProductService.getProdProductBy(Long.valueOf(req.getParameter("productId")));
            // 商品维护前，产品基本信息check
            message = new ResultMessage("success", "success");
            if ((prodProduct == null) || (prodProduct.getProductId() == null)) {
                message = new ResultMessage("error", "该产品不存在，请先维护产品！");
                return message;
            }
        }
        return message;
    }

    /**
     * 商品维护页
     */
    @RequestMapping(value = "/showSuppGoodsList")
    public Object showSuppGoodsList(Model model, HttpServletRequest req) throws BusinessException {

        if (req.getParameter("productId") != null) {
            ProdProduct prodProduct = prodProductService.findProdProductByProductId(Long.valueOf(req.getParameter("productId")));
            model.addAttribute("prodProduct", prodProduct);
            Map<String, Object> parameprodProductBranch = new HashMap<>();
            parameprodProductBranch.put("productId", prodProduct.getProductId());
            List<ProdProductBranch> prodProductBranchList = prodProductBranchService.findProdProductBranchList(parameprodProductBranch);
            if (CollectionUtils.isNotEmpty(prodProductBranchList)) {
                model.addAttribute("prodProductBranch", prodProductBranchList.get(0));
            }
            SuppGoods suppGoods = new SuppGoods();
            prodProduct.setBizCategory(bizCategoryQueryService.getCategoryById(prodProduct.getBizCategoryId()));
            suppGoods.setProdProduct(prodProduct);
            model.addAttribute("suppGoods", suppGoods);
            selectExistsSupplierDisableMark(model, prodProduct.getProductId());
        }
        return "/goods/finance/findSuppGoodsList";
    }

    private void selectExistsSupplierDisableMark(Model model, Long productId) {
        //已经存在的供应商
        List<SuppSupplier> suppSupplierList = MiscUtils.autoUnboxing(suppSupplierService.findSuppSupplierListByProductId(productId));
        if (suppSupplierList != null) {
            JSONArray array = new JSONArray();
            JSONArray arrayDisable = new JSONArray();
            Map<String, Object> params = new HashMap<>();
            params.put("productId", productId);
            params.put("cancelFlag", "Y");
            params.put("bizBranchCancelFlag", "Y");

            for (SuppSupplier supp : suppSupplierList) {
                if (supp != null) {
                    JSONObject obj = new JSONObject();
                    Long supplierId = supp.getSupplierId();
                    obj.put("id", supp.getSupplierId());

                    params.put("supplierId", supplierId);
                    Integer result = suppGoodsService.findSuppGoodsCountBySupplierId(params);
                    if (result == 0) {
                        obj.put("text", supp.getSupplierName() + "（无效）");
                        arrayDisable.add(obj);
                    } else {
                        obj.put("text", supp.getSupplierName());
                        array.add(obj);
                    }
                }
            }
            if (arrayDisable.size() > 0) {
                array.addAll(arrayDisable);
            }
            if (array.size() > 0) {
                model.addAttribute("suppJsonList", array.toString());
            }
        }
    }

    /**
     * 商品列表
     */
    @RequestMapping("/findSuppGoodsList")
    public Object findSuppGoodsList(Model model, SuppGoods suppGoods, HttpServletRequest req) throws BusinessException {
        if (suppGoods == null || suppGoods.getProductId() == null || suppGoods.getSupplierId() == null) {
            throw new BusinessException("参数错误");
        }
        ProdProductParam param = new ProdProductParam();
        param.setBizCategory(true);
        param.setProductBranch(true);
        param.setProductProp(false);
        param.setProductPropValue(false);
        // 查询产品信息
        ProdProduct prodProduct = prodProductService.findProdProductById(suppGoods.getProductId(), param);
        suppGoods.setProdProduct(prodProduct);
        List<ProdProductBranch> prodProductBranchList = prodProduct.getProdProductBranchList();
        ProdProductBranch prodProductBranch = prodProductBranchList.get(0);
        model.addAttribute("prodProductBranch", prodProductBranch);
        Map<String, Object> params = new HashMap<>();
        // 取得商品
        params.put("productId", suppGoods.getProductId());
        params.put("supplierId", suppGoods.getSupplierId());
        params.put("branchId", prodProductBranch.getBranchId());
        if (Constants.Y_FLAG.equals(suppGoods.getCancelFlag()) || Constants.N_FLAG.equals(suppGoods.getCancelFlag())) {
            params.put("cancelFlag", suppGoods.getCancelFlag());
        }
        params.put("_orderby", "seq asc");
        List<SuppGoods> suppGoodsList = suppGoodsService.findSuppGoodsByBranchIdAndProductId(params);
        if (CollectionUtils.isNotEmpty(suppGoodsList)) {
            Set<Long> contentManagerIds = new HashSet<>();
            for (SuppGoods goods : suppGoodsList) {
                contentManagerIds.add(goods.getContentManagerId());
            }
            params.clear();
            params.put("userIds", contentManagerIds.toArray());
            params.put("maxResults", 100);
            params.put("skipResults", 0);
            List<PermUser> contentManagerList = permUserServiceAdapter.queryPermUserByParam(params);
            for (PermUser permUser : contentManagerList) {
                for (SuppGoods goods : suppGoodsList) {
                    if (goods != null && goods.getContentManagerId() != null && goods.getContentManagerId().equals(permUser.getUserId())) {
                        goods.setContentManagerName(permUser.getRealName());
                    }
                }
            }
        }
        if (suppGoods.getSuppContract() != null && suppGoods.getSuppContract().getContractId() != null) {
            SuppContract suppContract = new SuppContract();
            suppContract.setContractId(suppGoods.getSuppContract().getContractId());
            suppContract.setContractName(suppContractService.findSuppContractById(suppGoods.getSuppContract().getContractId()).getContractName());
            suppGoods.setSuppContract(suppContract);
        }
        params.clear();
        params.put("groupCode", BizOrderRequired.BIZ_ORDER_REQUIRED_FIELD_LIST.FINANCE_PROD.name());
        List<BizOrderRequired> bizOrderRequiredList = bizOrderRequiredClientService.selectByExample(params);
        if (CollectionUtils.isNotEmpty(bizOrderRequiredList)) {
            model.addAttribute("showOrderRequire", bizOrderRequiredList.get(0).getOperatorConfig());
        }
        model.addAttribute("suppGoods", suppGoods);
        model.addAttribute("suppGoodsList", suppGoodsList);
        selectExistsSupplierDisableMark(model, suppGoods.getProductId());
        return "/goods/finance/findSuppGoodsList";
    }

    @RequestMapping("/showAddSuppGoods")
    public Object showAddSuppGoods(Model model, HttpServletRequest req) throws BusinessException {
        if (StringUtils.isBlank(req.getParameter("productId"))
                || StringUtils.isBlank(req.getParameter("supplierId"))
                || StringUtils.isBlank(req.getParameter("productBranchId"))
                || StringUtils.isBlank(req.getParameter("categoryId"))) {
            throw new BusinessException("参数错误");
        }
        SuppGoods suppGoods = new SuppGoods();
        Long supplierId = Long.valueOf(req.getParameter("supplierId"));
        Long productId = Long.valueOf(req.getParameter("productId"));
        Long categoryId = Long.valueOf(req.getParameter("categoryId"));
        Long productBranchId = Long.valueOf(req.getParameter("productBranchId"));
        suppGoods.setSupplierId(supplierId);
        suppGoods.setProductId(productId);
        suppGoods.setCategoryId(categoryId);
        suppGoods.setProductBranchId(productBranchId);
        if (StringUtils.isNotBlank(req.getParameter("categoryId"))) {
            suppGoods.setCategoryId(Long.valueOf(req.getParameter("categoryId")));
        }
        if (StringUtils.isNotBlank(req.getParameter("contentManagerId"))) {
            suppGoods.setContentManagerId(Long.valueOf(req.getParameter("contentManagerId")));
            suppGoods.setContentManagerName(req.getParameter("contentManagerName"));
        }
        if (StringUtils.isNotBlank(req.getParameter("contractId"))) {
            SuppContract suppContract = new SuppContract();
            suppContract.setContractId(Long.valueOf(req.getParameter("contractId")));
            suppContract.setContractName(suppContractService.findSuppContractById(Long.valueOf(req.getParameter("contractId"))).getContractName());
            suppGoods.setSuppContract(suppContract);
        }
        // 支付对象
        model.addAttribute("payTargetList", SuppGoods.PAYTARGET.values());
        // BU
        model.addAttribute("buList", bizBuEnumClientService.getAllBizBuEnumList().getReturnContent());
        // 分销商列表
        Map<String, Object> paramDistributor = new HashMap<>();
        paramDistributor.put("cancelFlag", "Y");
        paramDistributor.put("_orderby", "DISTRIBUTOR_ID");
        paramDistributor.put("_order", "ASC");
        ResultHandleT<List<Distributor>> dist_result = distributorService.findDistributorList(paramDistributor);
        if (dist_result != null && dist_result.getReturnContent() != null) {
            List<Distributor> distributorList = dist_result.getReturnContent();
            model.addAttribute("distributorList", distributorList);
        }
        //加载分销渠道的分销商
        ResultHandleT<TntGoodsChannelVo> tntGoodsChannelVoRt = tntGoodsChannelCouponServiceRemote
                .getChannels(TntGoodsChannelCouponAdapter.CH_TYPE.NONE.name());
        if (tntGoodsChannelVoRt != null && tntGoodsChannelVoRt.getReturnContent() != null) {
            TntGoodsChannelVo tntGoodsChannelVo = tntGoodsChannelVoRt.getReturnContent();
            model.addAttribute("tntGoodsChannelVo", tntGoodsChannelVo);
        }
        model.addAttribute("suppGoods", suppGoods);
        //结算主体类型
        model.addAttribute("lvAccSubjectList", SuppSettleRule.LVACC_SUBJECT.values());
        //供应商资质类型
        model.addAttribute("qualifyTypeList", SuppSupplier.QUAIFY_TYPE.values());
        return "/goods/finance/showAddSuppGoods";
    }

    @RequestMapping("/addSuppGoods")
    @ResponseBody
    public Object addSuppGoods(SuppGoods suppGoods, HttpServletRequest req) throws BusinessException {
        ResultMessage resultMessage = ResultMessage.createResultMessage();
        if (suppGoods == null
                || suppGoods.getProductId() == null
                || suppGoods.getSupplierId() == null
                || suppGoods.getCategoryId() == null) {
            resultMessage.raise("参数错误");
            return resultMessage;
        }
        // 取得当前排序值
        Map<String, Object> paramSuppGoods = new HashMap<>();
        paramSuppGoods.put("productId", suppGoods.getProductId());
        int seq = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsCount(paramSuppGoods));
        suppGoods.setSeq(seq + 1);
        suppGoods.setCreateUser(this.getLoginUserId());
        //默认设置为无效
        suppGoods.setCancelFlag("N");
        suppGoods.setOnlineFlag("N");
        Long suppGoodsId = MiscUtils.autoUnboxing(suppGoodsService.addSuppGoods(suppGoods));
        suppGoods.setSuppGoodsId(suppGoodsId);
        if (StringUtils.isNotBlank(req.getParameter("salesPrice"))) {
            Long salesPrice = dealPrice(req.getParameter("salesPrice"));
            Long totalStock = null;
            if (StringUtils.isNotBlank(req.getParameter("totalStock"))) {
                totalStock = Long.valueOf(req.getParameter("totalStock"));
            }
            saveFinancialGoodsTimePrice(suppGoods, salesPrice, totalStock);
        }
        // 结算对象SETTLE_ENTITY_MARK
        String settleEntityLogText = null;
        if (StringUtils.isNotEmpty(suppGoods.getSettlementEntityCode())) {
            SuppSettlementEntities settlementEntity = suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(suppGoods.getSettlementEntityCode());
            if (null != settlementEntity) {
                settleEntityLogText = " ; 【 绑定结算对象 】：" + settlementEntity.getName() + " , 【  绑定结算对象CODE 】" + settlementEntity.getCode();
            } else {
                settleEntityLogText = " ; 【 未找到可绑定结算对象 】";
            }
        } else {
            settleEntityLogText = "; 【 绑定结算对象CODE 为空，无法绑定 】";
        }
        //添加操作日志
        try {
            LOG.info("新增商品 suppGoodsId:" + suppGoods.getSuppGoodsId() + ",loginfo:" + suppGoods.toString());
            comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS,
                    suppGoods.getProductId(), suppGoods.getSuppGoodsId(),
                    this.getLoginUser().getUserName(),
                    "添加了商品：【" + suppGoods.getGoodsName() + "】" + settleEntityLogText, // 结算对象SETTLE_ENTITY_MARK,
                    ComLog.COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(),
                    "新增商品", null);
        } catch (Exception e) {
            LOG.error("Record Log failure ！Log type:" + ComLog.COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
            LOG.error(e.getMessage());
        }
        return resultMessage;
    }

    private Long dealPrice(String priceStr) {
        BigDecimal price = new BigDecimal(priceStr);
        return price.multiply(new BigDecimal(100)).longValue();
    }

    // 修改或保存产品与渠道对应关系
    private void saveOrUpdateDistributorGoods(Long productId, Long productBranchId, Long suppGoodsId, String[] distributorIds) {
        if (null != suppGoodsId && suppGoodsId > 0) {
            boolean saveOrUpdate = false;
            if (null != distributorIds && distributorIds.length > 0) {
                Long[] ids = new Long[distributorIds.length];
                for (int i = 0; i < distributorIds.length; i++) {
                    if (StringUtil.isNumber(distributorIds[i])) {
                        ids[i] = Long.valueOf(distributorIds[i]);
                        saveOrUpdate = true;
                    }
                }
                if (saveOrUpdate) {
                    distributorGoodsService.saveOrUpdateDistDistributorGoods(productId, productBranchId, suppGoodsId, ids);
                }
            }
            if (!saveOrUpdate) {
                // 没有选择商品对应的销售渠道
                Map<String, Object> params = new HashMap<>();
                params.put("suppGoodsId", suppGoodsId);
                distributorGoodsService.deleteDistDistributorGoods(params);
            }
        }
    }

    @RequestMapping("/showUpdateSuppGoods")
    public Object showUpdateSuppGoods(Model model, HttpServletRequest req) throws BusinessException {
        if (StringUtils.isBlank(req.getParameter("suppGoodsId"))) {
            throw new BusinessException("参数错误");
        }
        Long suppGoodsId = Long.valueOf(req.getParameter("suppGoodsId"));
        SuppGoodsParam suppGoodsParam = new SuppGoodsParam();
        suppGoodsParam.setContract(true);
        SuppGoods suppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoodsId, suppGoodsParam));
        if (suppGoods == null) {
            throw new BusinessException("未查询到商品");
        }
        Long contentManagerId = suppGoods.getContentManagerId();
        if (contentManagerId != null) {
            PermUser user = permUserServiceAdapter.getPermUserByUserId(contentManagerId);
            if (user != null) {
                model.addAttribute("contentManagerName", user.getRealName());
            } else {
                model.addAttribute("contentManagerName", "");
            }
        }
        // 支付对象
        model.addAttribute("payTargetList", SuppGoods.PAYTARGET.values());
        // BU
        model.addAttribute("buList", bizBuEnumClientService.getAllBizBuEnumList().getReturnContent());

        // 取得产品对应的销售渠道信息
        Map<String, Object> paraDistDistributorSuppGoods = new HashMap<>();
        paraDistDistributorSuppGoods.put("suppGoodsId", suppGoods.getSuppGoodsId());
        suppGoods.setDistDistributorGoods(distributorGoodsService.findDistDistributorGoodsList(paraDistDistributorSuppGoods));
        // 分销商列表
        Map<String, Object> paramDistributor = new HashMap<>();
        paramDistributor.put("cancelFlag", "Y");
        paramDistributor.put("_orderby", "DISTRIBUTOR_ID");
        paramDistributor.put("_order", "ASC");
        ResultHandleT<List<Distributor>> dist_result = distributorService.findDistributorList(paramDistributor);
        if (dist_result != null && dist_result.getReturnContent() != null) {
            List<Distributor> distributorList = dist_result.getReturnContent();
            model.addAttribute("distributorList", distributorList);
        }
        PriceResultHandleT<FinancialGoodsTimePriceVo> resultHandleT = financialGoodsTimePriceApiService.selectBySuppGoodsId(suppGoodsId);
        if (resultHandleT != null && resultHandleT.getReturnContent() != null) {
            FinancialGoodsTimePriceVo priceVo = resultHandleT.getReturnContent();
            model.addAttribute("salesPrice", new BigDecimal(priceVo.getSalesPrice()).divide(new BigDecimal(100), 2, BigDecimal.ROUND_UP));
            model.addAttribute("totalStock", priceVo.getTotalStock());
        }
        //加载分销渠道的分销商
        ResultHandleT<TntGoodsChannelVo> tntGoodsChannelVoRt = tntGoodsChannelCouponServiceRemote
                .getChannels(TntGoodsChannelCouponAdapter.CH_TYPE.NONE.name());
        if (tntGoodsChannelVoRt != null && tntGoodsChannelVoRt.getReturnContent() != null) {
            TntGoodsChannelVo tntGoodsChannelVo = tntGoodsChannelVoRt.getReturnContent();
            model.addAttribute("tntGoodsChannelVo", tntGoodsChannelVo);
        }

        ResultHandleT<Long[]> userIdLongRt = tntGoodsChannelCouponServiceRemote.list(Long.parseLong(req.getParameter("productId")),
                Long.parseLong(req.getParameter("suppGoodsId")), TntGoodsChannelCouponAdapter.PG_TYPE.GOODS.name());
        if (userIdLongRt != null && userIdLongRt.getReturnContent() != null && userIdLongRt.isSuccess()) {
            Long[] userIdLong = userIdLongRt.getReturnContent();
            StringBuilder userIdLongStr = new StringBuilder(",");
            for (Long userId : userIdLong) {
                userIdLongStr.append(userId.toString()).append(",");
            }
            model.addAttribute("userIdLongStr", userIdLongStr.toString());
        }
        // 结算对象SETTLE_ENTITY_MARK
        // 设置结算对象
        SuppSettlementEntities settlementEntity = suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(suppGoods.getSettlementEntityCode());
        suppGoods.setSettlementEntity(settlementEntity);
        model.addAttribute("suppGoods", suppGoods);
        // 公司主体
        Map<String, String> companyTypeMap = new HashMap<>();
        for (ProdProduct.COMPANY_TYPE_DIC item : ProdProduct.COMPANY_TYPE_DIC.values()) {
            companyTypeMap.put(item.name(), item.getTitle());
        }
        model.addAttribute("companyTypeMap", companyTypeMap);
        //结算主体类型
        model.addAttribute("lvAccSubjectList", SuppSettleRule.LVACC_SUBJECT.values());
        //供应商资质类型
        model.addAttribute("qualifyTypeList", SuppSupplier.QUAIFY_TYPE.values());
        return "/goods/finance/showUpdateSuppGoods";
    }

    @RequestMapping("/updateSuppGoods")
    @ResponseBody
    public Object updateSuppGoods(SuppGoods suppGoods, String distributorUserIds, HttpServletRequest req) throws BusinessException {
        ResultMessage resultMessage = ResultMessage.createResultMessage();
        if (suppGoods == null || suppGoods.getSuppGoodsId() == null) {
            resultMessage.raise("参数错误");
            return resultMessage;
        }
        SuppGoodsParam suppGoodsParam = new SuppGoodsParam();
        suppGoodsParam.setContract(true);
        SuppGoods oldSuppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoods.getSuppGoodsId(), suppGoodsParam));
        StringBuilder logContent = new StringBuilder();
        mergeGoodsAndPackLog(suppGoods, oldSuppGoods, logContent);
        suppGoodsService.updateSuppGoods(oldSuppGoods);
        if (StringUtils.isNotBlank(req.getParameter("salesPrice"))) {
            Long salesPrice = dealPrice(req.getParameter("salesPrice"));
            Long totalStock = null;
            if (StringUtils.isNotBlank(req.getParameter("totalStock"))) {
                totalStock = Long.valueOf(req.getParameter("totalStock"));
            }
            saveFinancialGoodsTimePrice(oldSuppGoods, salesPrice, totalStock);
        }
        // 修改产品的销售渠道
        String oldDistributorNames = "";
        String distributorNames = "";
        if (suppGoods.getDistributorIds() != null) {
            // 分销商列表
            Map<String, Object> paramDistributor = new HashMap<>();
            paramDistributor.put("cancelFlag", "Y");
            paramDistributor.put("_orderby", "DISTRIBUTOR_ID");
            paramDistributor.put("_order", "ASC");

            List<Distributor> distributorList = null;
            ResultHandleT<List<Distributor>> dist_result = distributorService.findDistributorList(paramDistributor);
            if (dist_result != null && dist_result.getReturnContent() != null) {
                distributorList = dist_result.getReturnContent();
            }

            // 取得旧产品对应的销售渠道信息
            Map<String, Object> paraDistDistributorSuppGoods = new HashMap<>();
            paraDistDistributorSuppGoods.put("suppGoodsId", suppGoods.getSuppGoodsId());
            paraDistDistributorSuppGoods.put("_orderby", "DISTRIBUTOR_ID");
            paraDistDistributorSuppGoods.put("_order", "ASC");
            List<DistDistributorGoods> distDistributorGoodsList = distributorGoodsService.findDistDistributorGoodsList(paraDistDistributorSuppGoods);

            if (CollectionUtils.isNotEmpty(distDistributorGoodsList) && CollectionUtils.isNotEmpty(distributorList)) {
                StringBuilder sb = new StringBuilder();
                for (DistDistributorGoods distDistributorGoods : distDistributorGoodsList) {
                    for (Distributor distributor : distributorList) {
                        if (distributor.getDistributorId().longValue() == distDistributorGoods.getDistributorId().longValue()) {
                            sb.append(distributor.getDistributorName()).append(",");
                        }
                    }
                }
                if (StringUtils.isNotBlank(sb.toString())) {
                    oldDistributorNames = sb.toString().substring(0, sb.length() - 1);
                }
            }


            StringBuilder sb = new StringBuilder();
            String[] distributorIds = suppGoods.getDistributorIds().split(",");
            if (CollectionUtils.isNotEmpty(distributorList) && distributorIds.length > 0) {
                for (String distributorId : distributorIds) {
                    for (Distributor distributor : distributorList) {
                        if (distributorId.equals(String.valueOf(distributor.getDistributorId()))) {
                            sb.append(distributor.getDistributorName()).append(",");
                        }
                    }
                }
            }
            if (StringUtils.isNotBlank(sb.toString())) {
                distributorNames = sb.toString().substring(0, sb.length() - 1);
            }
            saveOrUpdateDistributorGoods(suppGoods.getProductId(), suppGoods.getProductBranchId(), suppGoods.getSuppGoodsId(), distributorIds);
        }
        //推送商品的分销商关系给super系统
        distributorGoodsService.pushSuperDistributor(suppGoods, distributorUserIds);
        logContent.append(ComLogUtil.getLogTxt("销售渠道", distributorNames, oldDistributorNames));
        //添加操作日志
        try {
            comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS,
                    suppGoods.getProductId(), suppGoods.getSuppGoodsId(),
                    this.getLoginUser().getUserName(),
                    "修改了商品：【" + suppGoods.getGoodsName() + "】,变更内容：" + logContent.toString(),
                    ComLog.COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(),
                    "修改商品", null);

        } catch (Exception e) {
            log.error("Record Log failure ！Log type:" + ComLog.COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
            log.error(ExceptionFormatUtil.getTrace(e));
        }
        return resultMessage;
    }

    private void mergeGoodsAndPackLog(SuppGoods suppGoods, SuppGoods oldSuppGoods, StringBuilder logContent) {
        if (oldSuppGoods.getGoodsName() != null
                && !oldSuppGoods.getGoodsName().equals(suppGoods.getGoodsName())) {
            logContent.append(ComLogUtil.getLogTxt("商品名称", suppGoods.getGoodsName(), oldSuppGoods.getGoodsName()));
            oldSuppGoods.setGoodsName(suppGoods.getGoodsName());
        }
        if (oldSuppGoods.getContractId() != null
                && !oldSuppGoods.getContractId().equals(suppGoods.getContractId())) {
            if (suppGoods.getSuppContract() != null && oldSuppGoods.getSuppContract() != null) {
                logContent.append(ComLogUtil.getLogTxt("商品合同", suppGoods.getSuppContract().getContractName(), oldSuppGoods.getSuppContract().getContractName()));
            }
            oldSuppGoods.setContractId(suppGoods.getContractId());
        }
        if (oldSuppGoods.getPayTarget() != null
                && !oldSuppGoods.getPayTarget().equals(suppGoods.getPayTarget())) {
            String newValue = SuppGoods.PAYTARGET.getCnName(suppGoods.getPayTarget());
            String oldValue = SuppGoods.PAYTARGET.getCnName(oldSuppGoods.getPayTarget());
            logContent.append(ComLogUtil.getLogTxt("支付对象", newValue, oldValue));
            oldSuppGoods.setPayTarget(suppGoods.getPayTarget());
        }
        if (oldSuppGoods.getMinQuantity() != null
                && !oldSuppGoods.getMinQuantity().equals(suppGoods.getMinQuantity())) {
            logContent.append(ComLogUtil.getLogTxt("最小起订数量", suppGoods.getMinQuantity().toString(), oldSuppGoods.getMinQuantity().toString()));
            oldSuppGoods.setMinQuantity(suppGoods.getMinQuantity());
        }
        if (oldSuppGoods.getMaxQuantity() != null
                && !oldSuppGoods.getMaxQuantity().equals(suppGoods.getMaxQuantity())) {
            logContent.append(ComLogUtil.getLogTxt("最大订购数量", suppGoods.getMaxQuantity().toString(), oldSuppGoods.getMaxQuantity().toString()));
            oldSuppGoods.setMaxQuantity(suppGoods.getMaxQuantity());
        }
        if (oldSuppGoods.getContentManagerId() != null
                && !oldSuppGoods.getContentManagerId().equals(suppGoods.getContentManagerId())) {
            Long contentManagerId = oldSuppGoods.getContentManagerId();
            if (contentManagerId != null) {
                PermUser user = permUserServiceAdapter.getPermUserByUserId(contentManagerId);
                logContent.append(ComLogUtil.getLogTxt("内容维护人员", suppGoods.getContentManagerName(), user.getRealName()));
            }
            oldSuppGoods.setContentManagerId(suppGoods.getContentManagerId());
        }
        if (oldSuppGoods.getSenisitiveFlag() != null
                && !oldSuppGoods.getSenisitiveFlag().equals(suppGoods.getSenisitiveFlag())) {
            oldSuppGoods.setSenisitiveFlag(suppGoods.getSenisitiveFlag());
        }
        if (oldSuppGoods.getBu() != null
                && !oldSuppGoods.getBu().equals(suppGoods.getBu())) {
            String newValue = Constant.BU_NAME.getCnName(suppGoods.getBu());
            String oldValue = Constant.BU_NAME.getCnName(oldSuppGoods.getBu());
            logContent.append(ComLogUtil.getLogTxt("BU", newValue, oldValue));
            oldSuppGoods.setBu(suppGoods.getBu());
        }
        if (oldSuppGoods.getCompanyType() != null
                && !oldSuppGoods.getCompanyType().equals(suppGoods.getCompanyType())) {
            oldSuppGoods.setCompanyType(suppGoods.getCompanyType());
        }
    }

    private void saveFinancialGoodsTimePrice(SuppGoods suppGoods, Long salesPrice, Long totalStock) {
        try {
            PriceResultHandleT<FinancialGoodsTimePriceVo> resultHandleT = financialGoodsTimePriceApiService.selectBySuppGoodsId(suppGoods.getSuppGoodsId());
            FinancialGoodsTimePriceVo priceVo = null;
            if (resultHandleT != null && resultHandleT.getReturnContent() != null) {
                priceVo = resultHandleT.getReturnContent();
            } else {
                priceVo = new FinancialGoodsTimePriceVo();
                priceVo.setCategoryId(suppGoods.getCategoryId());
                priceVo.setProductId(suppGoods.getProductId());
                priceVo.setSuppGoodsId(suppGoods.getSuppGoodsId());
            }
            priceVo.setSettlementPrice(salesPrice);
            priceVo.setSalesPrice(salesPrice);
            priceVo.setTotalStock(totalStock);
            priceVo.setOnsaleFlag(suppGoods.getOnlineFlag());
            PriceResultHandleT<Integer> handleT = financialGoodsTimePriceApiService.saveOrUpdateTimePrice(priceVo);
            if (handleT != null && handleT.isFail()) {
                LOG.error("FinancialGoodsTimePriceApiService#saveOrUpdateTimePrice error:" + handleT.getMsg());
            }
        } catch (Exception e) {
            LOG.error("saveFinancialGoodsTimePrice error:", e);
        }
    }

    @RequestMapping("/cancelGoods")
    @ResponseBody
    public Object cancelGoods(SuppGoods suppGoods) throws BusinessException {
        ResultMessage resultMessage = ResultMessage.createResultMessage();
        if (suppGoods == null
                || suppGoods.getSuppGoodsId() == null
                || suppGoods.getProductId() == null
                || StringUtils.isBlank(suppGoods.getCancelFlag())) {
            resultMessage.raise("参数错误");
            return resultMessage;
        }
        if ("Y".equalsIgnoreCase(suppGoods.getCancelFlag())) {
            String result = checkRequired(suppGoods);
            if (StringUtils.isNotBlank(result)) {
                result = result + "，请维护后再设为有效";
                resultMessage.raise(result);
                return resultMessage;
            } else {
                suppGoods.setCancelFlag("Y");
                suppGoods.setOnlineFlag("Y");
            }
        } else if ("N".equalsIgnoreCase(suppGoods.getCancelFlag())) {
            suppGoods.setCancelFlag("N");
            suppGoods.setOnlineFlag("N");
        } else {
            resultMessage.raise("参数错误");
            return resultMessage;
        }
        ResultHandle resultHandle = suppGoodsService.updateFinancialCancelState(suppGoods);
        if (resultHandle != null && resultHandle.isSuccess()) {
            updateGoodsTimePriceSaleState(suppGoods);
            //添加操作日志
            try {
                String key;
                if ("Y".equals(suppGoods.getCancelFlag())) {
                    key = "有效";
                } else {
                    key = "无效";
                }
                comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS,
                        suppGoods.getProductId(), suppGoods.getSuppGoodsId(),
                        this.getLoginUser().getUserName(),
                        "修改了商品有效性为:" + key,
                        ComLog.COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(),
                        "修改商品有效性", null);

            } catch (Exception e) {
                LOG.error("Record Log failure ！Log type:" + ComLog.COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
                LOG.error(e.getMessage());
            }
        } else {
            resultMessage.raise("设置商品有效性失败");
        }
        return resultMessage;
    }

    private void updateGoodsTimePriceSaleState(SuppGoods suppGoods) {
        try {
            PriceResultHandleT<FinancialGoodsTimePriceVo> resultHandleT = financialGoodsTimePriceApiService.selectBySuppGoodsId(suppGoods.getSuppGoodsId());
            FinancialGoodsTimePriceVo priceVo = null;
            if (resultHandleT != null && resultHandleT.getReturnContent() != null) {
                priceVo = resultHandleT.getReturnContent();
                priceVo.setOnsaleFlag(suppGoods.getOnlineFlag());
            }
            PriceResultHandleT<Integer> handleT = financialGoodsTimePriceApiService.saveOrUpdateTimePrice(priceVo);
            if (handleT != null && handleT.isFail()) {
                LOG.error("FinancialGoodsTimePriceApiService#saveOrUpdateTimePrice error:" + handleT.getMsg());
            }
        } catch (Exception e) {
            LOG.error("updateGoodsTimePriceSaleState error:", e);
        }
    }

    private String checkRequired(SuppGoods suppGoods) {
        StringBuilder builder = new StringBuilder();
        ProdProduct prodProduct = prodProductService.getProdProductBy(suppGoods.getProductId());
        if (!"Y".equals(prodProduct.getCancelFlag())) {
            builder.append("产品为无效状态/");
        }
        Map<String, Object> params = new HashMap<>();
        params.put("groupCode", BizOrderRequired.BIZ_ORDER_REQUIRED_FIELD_LIST.FINANCE_PROD.name());
        List<BizOrderRequired> bizOrderRequiredList = bizOrderRequiredClientService.selectByExample(params);
        if (CollectionUtils.isNotEmpty(bizOrderRequiredList)) {
            BizOrderRequired bizOrderRequired = bizOrderRequiredList.get(0);
            if ("Y".equalsIgnoreCase(bizOrderRequired.getOperatorConfig())) {
                int resultRequired = comOrderRequiredService.countBySuppGoodsId(suppGoods.getSuppGoodsId());
                if (resultRequired == 0) {
                    builder.append("下单必填项未设置/");
                }
            }
        }
        if (!financeInterestsBonusService.checkInterestsBonusAndOtherInterests(suppGoods.getSuppGoodsId())) {
            builder.append("商品权益未设置/");
        }
        PriceResultHandleT<FinancialGoodsTimePriceVo> resultHandleT = financialGoodsTimePriceApiService.selectBySuppGoodsId(suppGoods.getSuppGoodsId());
        if (resultHandleT == null || resultHandleT.getReturnContent() == null) {
            builder.append("商品销售价库存未设置/");
        }
        String result = builder.toString();
        if (StringUtils.isNotBlank(result)) {
            result = result.substring(0, result.length() - 1);
        }
        return result;
    }

    @RequestMapping(value = "/updateSeq.do")
    @ResponseBody
    public Object updateSeq(HttpServletRequest req) throws BusinessException {
        ResultMessage resultMessage = ResultMessage.createResultMessage();
        if (StringUtils.isBlank(req.getParameter("goodsIdA"))
                || StringUtils.isBlank(req.getParameter("goodsIdB"))) {
            resultMessage.raise("参数错误");
            return resultMessage;
        }
        SuppGoods suppGoodsA = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(Long.valueOf(req.getParameter("goodsIdA").trim())));
        SuppGoods suppGoodsB = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(Long.valueOf(req.getParameter("goodsIdB").trim())));
        if (suppGoodsA == null || suppGoodsB == null) {
            resultMessage.raise("查询商品为空");
            return resultMessage;
        }
        int tempSeq = suppGoodsA.getSeq();
        suppGoodsA.setSeq(suppGoodsB.getSeq());
        suppGoodsService.updateSeq(suppGoodsA);
        suppGoodsB.setSeq(tempSeq);
        suppGoodsService.updateSeq(suppGoodsB);
        //添加操作日志
        try {
            comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS,
                    suppGoodsA.getProductId(), suppGoodsA.getSuppGoodsId(),
                    this.getLoginUser().getUserName(),
                    "修改了商品：【" + suppGoodsA.getGoodsName() + "】,变更内容：商品排序:[原来值:" + suppGoodsB.getSeq() + ",新值:" + suppGoodsA.getSeq() + "]",
                    ComLog.COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(),
                    "修改商品", null);
            comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS,
                    suppGoodsB.getProductId(), suppGoodsB.getSuppGoodsId(),
                    this.getLoginUser().getUserName(),
                    "修改了商品：【" + suppGoodsB.getGoodsName() + "】,变更内容：商品排序:[原来值:" + suppGoodsA.getSeq() + ",新值:" + suppGoodsB.getSeq() + "]",
                    ComLog.COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(),
                    "修改商品", null);
        } catch (Exception e) {
            LOG.error("Record Log failure ！Log type:" + ComLog.COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
            LOG.error(ExceptionFormatUtil.getTrace(e));
        }
        return resultMessage;
    }

    @RequestMapping(value = "/showCopyGoods.do")
    public Object showCopyGoods(Model model, Long suppGoodsId, Long productId,
                                Long categoryId, Long oldSupplierId, String oldSupplierName) throws BusinessException {
        if (null != productId && null != suppGoodsId) {
            model.addAttribute("suppGoodsId", suppGoodsId);
            model.addAttribute("productId", productId);
            model.addAttribute("categoryId", categoryId);
            model.addAttribute("oldSupplierId", oldSupplierId);
            model.addAttribute("oldSupplierName", oldSupplierName);
            // 获取供应商列表
            selectExistsSupplierDisableMark(model, productId);
        }
        return "goods/finance/showCopyGoods";
    }

    @RequestMapping("/copyGoods")
    @ResponseBody
    public Object copyGoods(HttpServletRequest request) throws BusinessException {
        ResultMessage resultMessage = ResultMessage.createResultMessage();
        if (StringUtils.isBlank(request.getParameter("copySuppGoodsId"))
                || StringUtils.isBlank(request.getParameter("copySupplierId"))
                || StringUtils.isBlank(request.getParameter("contractId"))
                || StringUtils.isBlank(request.getParameter("settlementEntityCode"))
                || StringUtils.isBlank(request.getParameter("copyFlag"))) {
            resultMessage.raise("参数错误");
            return resultMessage;
        }
        Long copySuppGoodsId = Long.valueOf(request.getParameter("copySuppGoodsId"));
        Long copySupplierId = Long.valueOf(request.getParameter("copySupplierId"));
        String copySupplierName = request.getParameter("copySupplierName");
        Long contractId = Long.valueOf(request.getParameter("contractId"));
        String contractName = request.getParameter("newContract");
        Long newSupplierId = null;
        if (StringUtils.isNotBlank(request.getParameter("newSupplierId"))) {
            newSupplierId = Long.valueOf(request.getParameter("newSupplierId"));
        }
        String newSupplierName = request.getParameter("newSupplierName");
        String settlementEntityCode = request.getParameter("settlementEntityCode");
        String copyFlag = request.getParameter("copyFlag");
        SuppGoods goodsDTO = new SuppGoods();
        goodsDTO.setSuppGoodsId(copySuppGoodsId);
        SuppContract suppContract = new SuppContract();
        suppContract.setContractId(contractId);
        suppContract.setContractName(contractName);
        goodsDTO.setSuppContract(suppContract);
        goodsDTO.setSettlementEntityCode(settlementEntityCode);
        //根据选择设置供应商ID和Name
        if ("1".equals(copyFlag)) {
            goodsDTO.setSupplierId(newSupplierId);
            goodsDTO.setSupplierName(newSupplierName);
        } else {
            goodsDTO.setSupplierId(copySupplierId);
            goodsDTO.setSupplierName(copySupplierName);
        }
        resultMessage = suppGoodsBasicCopy(goodsDTO);
        return resultMessage;
    }

    /**
     * 商品信息及下单必填项复制
     *
     * @return 复制结果 fail 失败 normal 商品表成功，其他存在失败 success 复制成功
     */
    private ResultMessage suppGoodsBasicCopy(SuppGoods goodsDTO) {
        ResultMessage resultMessage = ResultMessage.createResultMessage();
        Long suppGoodsId = null;
        SuppGoods oldGoods = null;
        SuppGoods newGoods = new SuppGoods();
        try {
            oldGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(goodsDTO.getSuppGoodsId(), new SuppGoodsParam()));
            EnhanceBeanUtils.copyProperties(oldGoods, newGoods);
            newGoods.setSuppGoodsId(null);
            newGoods.setEbkSupplierGroupId(null);
            newGoods.setCreateUser(this.getLoginUserId());
            newGoods.setContractId(goodsDTO.getSuppContract().getContractId());
            newGoods.setSupplierId(goodsDTO.getSupplierId());
            newGoods.setSettlementEntityCode(goodsDTO.getSettlementEntityCode());
            // 默认设置为无效
            newGoods.setCancelFlag("N");
            newGoods.setOnlineFlag("N");
            // 取得当前排序值
            Map<String, Object> paramSuppGoods = new HashMap<>();
            paramSuppGoods.put("productId", oldGoods.getProductId());
            int seq = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsCount(paramSuppGoods));
            newGoods.setSeq(seq + 1);
            suppGoodsId = MiscUtils.autoUnboxing(suppGoodsService.addSuppGoods(newGoods));
            newGoods.setSuppGoodsId(suppGoodsId);
            resultMessage.addObject("suppGoodsId", suppGoodsId);
        } catch (Exception e) {
            LOG.error("复制商品#基本信息失败,suppGoodsId:" + goodsDTO.getSuppGoodsId() + " error: "
                    + ExceptionFormatUtil.getTrace(e));
            resultMessage.setCode("fail");
            resultMessage.raise("商品基本信息复制失败");
            return resultMessage;
        }
        try {
            comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS,
                    newGoods.getProductId(), suppGoodsId, this
                            .getLoginUser().getUserName(), "商品基本信息复制成功，从商品ID 【"
                            + goodsDTO.getSuppGoodsId() + "】复制而来",
                    ComLog.COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(), "复制商品",
                    null);
        } catch (Exception e) {
            LOG.error("Record suppGoodsDescCopy Log failure " + e.toString());
            LOG.error(ExceptionFormatUtil.getTrace(e));
        }
        StringBuilder message = new StringBuilder();
        // 新增商品的分销渠道
        try {
            Map<String, Object> paraDistDistributorSuppGoods = new HashMap<>();
            paraDistDistributorSuppGoods.put("suppGoodsId", goodsDTO.getSuppGoodsId());
            List<DistDistributorGoods> distDistributorGoods = distributorGoodsService
                    .findDistDistributorGoodsList(paraDistDistributorSuppGoods);
            List<Long> list = distributorGoodsService
                    .saveOrUpdateDistDistributorGoods(distDistributorGoods, suppGoodsId);
            if (list != null && list.size() > 0) {
                newGoods.setDistributorIds(listToString(list));
            }
        } catch (Exception e) {
            LOG.error("复制商品#商品分销渠道失败,suppGoodsId:" + suppGoodsId + " error: "
                    + ExceptionFormatUtil.getTrace(e));
            message.append("设置商品分销渠道失败;");
        }
        // 推送商品的分销商关系给super系统
        try {
            String distributorUserIds = "";
            ResultHandleT<Long[]> vstResult = tntGoodsChannelCouponServiceRemote
                    .list(newGoods.getProductId(), goodsDTO.getSuppGoodsId(),
                            TntGoodsChannelCouponAdapter.PG_TYPE.GOODS.name());
            Long[] userIdLong = vstResult.getReturnContent();
            StringBuilder userIdLongStr = new StringBuilder();
            for (Long userId : userIdLong) {
                userIdLongStr.append(userId.toString()).append(",");
            }
            if (userIdLongStr.length() > 0) {
                ResultHandleT<TntGoodsChannelVo> vstResponse = tntGoodsChannelCouponServiceRemote
                        .getChannels(TntGoodsChannelCouponAdapter.CH_TYPE.NONE
                                .name());
                if (vstResponse != null
                        && vstResponse.getReturnContent() != null) {
                    List<TntUserVo> users = null;
                    List<TntChannelVo> channels = vstResponse
                            .getReturnContent().getChannels();
                    if (channels != null && channels.size() > 0) {
                        for (TntChannelVo tnt : channels) {
                            if (tnt.getUsers() != null
                                    && tnt.getUsers().size() > 0) {
                                users = tnt.getUsers();
                                for (TntUserVo user : users) {
                                    if (userIdLongStr.indexOf(user.getUserId()
                                            .toString()) > -1) {
                                        distributorUserIds += tnt
                                                .getChannelId()
                                                + "-"
                                                + user.getUserId() + ",";
                                    }
                                }

                            }
                        }
                    }
                }
            }
            if (distributorUserIds.length() > 0) {
                distributorUserIds = distributorUserIds.substring(0,
                        distributorUserIds.length() - 1);
            }
            distributorGoodsService.pushSuperDistributor(newGoods, distributorUserIds);
        } catch (Exception e) {
            LOG.error("复制商品#super系统分销商失败,suppGoodsId:" + suppGoodsId
                    + " error: " + ExceptionFormatUtil.getTrace(e));
            message.append("设置super系统分销商失败;");
        }

        // 插入错误日志
        if (StringUtils.isNotBlank(message.toString())) {
            try {
                comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS,
                        newGoods.getProductId(), suppGoodsId, this.getLoginUser().getUserName(),
                        message.toString(), ComLog.COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(),
                        "复制商品", null);
            } catch (Exception e) {
                LOG.error("Record suppGoodsDescCopy Log failure "
                        + e.toString());
                LOG.error(ExceptionFormatUtil.getTrace(e));
            }
        }
        if (StringUtils.isBlank(message.toString())) {
            resultMessage.setMessage("复制成功");
        } else {
            message.append("请在复制后的商品（ID:");
            message.append(suppGoodsId);
            message.append("）设置里手动设置！");
            resultMessage.setMessage(message.toString());
            resultMessage.setCode("normal");
        }
        return resultMessage;
    }

    private String listToString(List<Long> list) {
        StringBuilder sb = new StringBuilder();
        for (Long value : list) {
            sb.append(value.toString()).append(",");
        }
        return sb.toString().substring(0, sb.toString().length() - 1);
    }

    /**
     * 跳转到修改下單必填項页面
     *
     * @return
     */
    @RequestMapping(value = "/showSuppGoodsOrderRequired")
    public String showSuppGoodsOrderRequired(Model model, Long suppGoodsId) throws BusinessException {
        if (LOG.isDebugEnabled()) {
            LOG.debug("start method<showSuppGoodsOrderRequired>");
        }
        model.addAttribute("suppGoodsId", suppGoodsId);
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("objectId", suppGoodsId);
        params.put("OBJECT_TYPE", ComOrderRequired.OBJECTTYPE.SUPP_GOODS.name());
        List<ComOrderRequired> list = comOrderRequiredService.findComOrderRequiredList(params);
        if (list != null && list.size() > 0) {
            ComOrderRequired comOrderRequired = list.get(0);
            if (comOrderRequired != null) {
                model.addAttribute("comOrderRequired", comOrderRequired);
            }
        }
        return "/goods/finance/showSuppGoodsOrderRequired";
    }

    /**
     * 更新产品
     */
    @RequestMapping(value = "/updateOrderRequired")
    @ResponseBody
    public Object updateOrderRequired(ComOrderRequired comOrderRequired) throws BusinessException {
        if (LOG.isDebugEnabled()) {
            LOG.debug("start method<updateOrderRequired>");
        }
        try {
            if (comOrderRequired != null) {
                if (comOrderRequired.getReqId() != null) {
                    comOrderRequiredService.updateConOrderRequired(comOrderRequired);
                } else {
                    //新增
                    comOrderRequired.setObjectType(ComOrderRequired.OBJECTTYPE.SUPP_GOODS.name());
                    comOrderRequiredService.saveComOrderRequired(comOrderRequired);
                }
            }
        } catch (Exception e) {
            LOG.error(ExceptionFormatUtil.getTrace(e));
            return new ResultMessage(ResultMessage.ERROR, "新增或更新失败");
        }
        return ResultMessage.UPDATE_SUCCESS_RESULT;
    }

}
