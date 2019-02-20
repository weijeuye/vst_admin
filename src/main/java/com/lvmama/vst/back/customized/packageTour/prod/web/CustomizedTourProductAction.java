package com.lvmama.vst.back.customized.packageTour.prod.web;

import static com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE.PROD_TRAVEL_DESIGN;
import static com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE.PROD_LINE_ROUTE;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.comm.cache.squid.SquidClient;
import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.comm.tnt.po.TntGoodsChannelVo;
import com.lvmama.vst.back.biz.po.Attribution;
import com.lvmama.vst.back.biz.po.BizCatePropGroup;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.po.BizCategoryProp;
import com.lvmama.vst.back.biz.po.BizDest;
import com.lvmama.vst.back.biz.po.BizDict;
import com.lvmama.vst.back.biz.po.BizDictExtend;
import com.lvmama.vst.back.biz.po.BizEnum;
import com.lvmama.vst.back.biz.po.BizOrderRequired;
import com.lvmama.vst.back.biz.po.BizVisaDoc;
import com.lvmama.vst.back.client.biz.service.AttributionClientService;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.biz.service.BizDictQueryService;
import com.lvmama.vst.back.client.biz.service.BizOrderRequiredClientService;
import com.lvmama.vst.back.biz.service.CategoryPropGroupService;
import com.lvmama.vst.back.client.biz.service.CategoryPropClientService;
import com.lvmama.vst.back.biz.service.DestService;
import com.lvmama.vst.back.biz.service.DictService;
import com.lvmama.vst.back.client.biz.service.BizBuEnumClientService;
import com.lvmama.vst.back.dist.po.DistDistributorProd;
import com.lvmama.vst.back.dist.po.Distributor;
import com.lvmama.vst.back.dist.service.DistributorCachedService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.goods.vo.ProdProductParam;
import com.lvmama.vst.back.pack.service.ProdLineGroupPackService;
import com.lvmama.vst.back.prod.po.LineRouteEnum;
import com.lvmama.vst.back.prod.po.ProdDestRe;
import com.lvmama.vst.back.prod.po.ProdEcontract;
import com.lvmama.vst.back.prod.po.ProdLineRoute;
import com.lvmama.vst.back.prod.po.ProdLineRouteDetail;
import com.lvmama.vst.back.prod.po.ProdPackageGroup;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductProp;
import com.lvmama.vst.back.prod.po.ProdProductSaleRe;
import com.lvmama.vst.back.prod.po.ProdTraffic;
import com.lvmama.vst.back.prod.po.ProdTrafficGroup;
import com.lvmama.vst.back.prod.po.ProdVisadocRe;
import com.lvmama.vst.back.prod.service.AssociationRecommendService;
import com.lvmama.vst.back.client.dist.service.DistDistributorProdClientService;
import com.lvmama.vst.back.client.prod.service.ProdDestReClientService;
import com.lvmama.vst.back.client.prod.service.ProdEcontractClientService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteDetailClientService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteClientService;
import com.lvmama.vst.back.client.prod.service.ProdPackageGroupClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductPropClientService;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.prod.service.ProdProductServiceAdapter;
import com.lvmama.vst.back.prod.service.ProdTrafficGroupService;
import com.lvmama.vst.back.client.prod.service.ProdTrafficClientService;
import com.lvmama.vst.back.prod.service.ProdVisadocReService;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComLog;
import com.lvmama.vst.back.pub.po.ComOrderRequired;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.pub.service.ComOrderRequiredClientService;
import com.lvmama.vst.back.pub.service.PushAdapterService;
import com.lvmama.vst.back.visa.service.VisaDocService;
import com.lvmama.vst.comm.enumeration.CommEnumSet;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.utils.WineSplitConstants;
import com.lvmama.vst.comm.utils.web.HttpServletLocalThread;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;
import com.lvmama.vst.pet.adapter.TntGoodsChannelCouponAdapter;
import com.lvmama.vst.back.utils.MiscUtils;
/**
 * 定制游自主打包产品Action
 * Created by wuqing on 2016/6/27.
 */
@Controller
@RequestMapping("/customized/packageTour/product")
public class CustomizedTourProductAction extends BaseActionSupport {

    /** Serial Version UID */
    private static final long serialVersionUID = -994536186179040393L;

    private static final Log LOG = LogFactory.getLog(CustomizedTourProductAction.class);

    @Autowired
    private ProdProductService prodProductService;

    @Autowired
    private ProdProductPropClientService prodProductPropService;

    @Autowired
    private CategoryPropGroupService categoryPropGroupService;

    @Autowired
    private ComLogClientService comLogService;

    @Autowired
    private BizCategoryQueryService bizCategoryQueryService;

    @Autowired
    private BizDictQueryService bizDictQueryService;

    @Autowired
    private ProdProductServiceAdapter prodProductServiceAdapter;

    @Autowired
    private DistributorCachedService distributorService;

    @Autowired
    private PermUserServiceAdapter permUserService;

    @Autowired
    private ProdLineRouteDetailClientService prodLineRouteDetailService;

    @Autowired
    private ComOrderRequiredClientService comOrderRequiredService;

    @Autowired
    private BizOrderRequiredClientService bizOrderRequiredService;

    @Autowired
    private DistDistributorProdClientService distDistributorProdService;

    @Autowired
    private CategoryPropClientService categoryPropService;

    @Autowired
    private VisaDocService visaDocService;

    @Autowired
    private DictService dictService;

    @Autowired
    private ProdVisadocReService prodVisadocReService;

    @Autowired
    private TntGoodsChannelCouponAdapter tntGoodsChannelCouponServiceRemote;

    @Autowired
    private ProdTrafficClientService prodTrafficService;

    @Autowired
    private ProdTrafficGroupService prodTrafficGroupService;

    @Autowired
    private ProdLineRouteClientService prodLineRouteService;

    @Autowired
    private ProdDestReClientService prodDestReService;

    @Autowired
    private DistDistributorProdClientService prodDistributorService;

    @Autowired
    PushAdapterService pushAdapterService;

    @Autowired
    private ProdEcontractClientService prodEcontractService;

    @Autowired
    private ProdPackageGroupClientService prodPackageGroupService;

    @Autowired
    private AttributionClientService attributionService;

    @Autowired
    private BizBuEnumClientService bizBuEnumClientService;

    @Autowired
    private AssociationRecommendService associationRecommendService;

    @Autowired
    private SuppGoodsClientService suppGoodsService;

    @Autowired
    private ProdLineGroupPackService prodLineGroupPackService;

    @Autowired
    private DestService destService;
    /**
     * 跳转到产品维护页面
     *
     * @param model
     * @param productId
     * @return
     */
    @RequestMapping(value = "/showProductMaintain")
    public String showProductMaintain(Model model, Long productId, String categoryName,Long categoryId,String isView) throws BusinessException {
        model.addAttribute("categoryId", categoryId);
        model.addAttribute("categoryName", categoryName);
        model.addAttribute("productId", productId);
        model.addAttribute("isView", isView);
        if (productId != null) {

            //校验行程
            List<ProdLineRoute> lineRouteList= checkRoute(productId);
            String routeFlag="false";
            if(lineRouteList!=null&&lineRouteList.size()>=1){
                routeFlag="true";
            }
            model.addAttribute("routeFlag", routeFlag);

            //校验行程明细
            String saveRouteFlag=checkRouteDetail(productId);
            model.addAttribute("saveRouteFlag", saveRouteFlag);

            //校验交通信息是否已经填写
            Boolean saveTransportFlag = prodTrafficService.checkTrafficDetial(productId);
            model.addAttribute("saveTransportFlag", saveTransportFlag.toString());

            ProdProduct prodProduct = prodProductService.getProdProductBy(productId);
            LOG.info("@@@@@@#########packageType="+prodProduct.getPackageType()+"@@@@@@#########productType="+prodProduct.getProductType());
            //vst组织鉴权
            super.vstOrgAuthentication(LOG, prodProduct.getManagerIdPerm());

            model.addAttribute("productType", prodProduct.getProductType());
            //出境-需要校验签证材料
            if("FOREIGNLINE".equals(prodProduct.getProductType())){
                String visaDocFlag=checkvisaDoc( productId);
                model.addAttribute("visaDocFlag", visaDocFlag);
            }
            model.addAttribute("productName", prodProduct.getProductName());
            model.addAttribute("categoryId", prodProduct.getBizCategoryId());
            model.addAttribute("packageType",prodProduct.getPackageType());
            model.addAttribute("categoryName", BizEnum.BIZ_CATEGORY_TYPE.getCnName(prodProduct.getBizCategoryId()));
            String bu = associationRecommendService
                    .getBuOfProduct(productId, prodProduct.getBu(), categoryId,
                            prodProduct.getPackageType());
            model.addAttribute("bu", bu);
            
          //校验“自动打包交通”属性和“是否使用被打包产品行程明细”属性
			ProdProductParam param = new ProdProductParam();
			param.setProductProp(true);
			param.setProductPropValue(true);
			ProdProduct product = prodProductService.findProdProductById(productId, param);
			Map<String, Object> propMap =product.getPropValue();
			String auto_pack_traffic = "N";
			String isuse_packed_route_details = "Y";
			if(propMap != null){
				auto_pack_traffic = (String)propMap.get("auto_pack_traffic");
				isuse_packed_route_details = (String)propMap.get("isuse_packed_route_details");
			}
			model.addAttribute("auto_pack_traffic", auto_pack_traffic);
			model.addAttribute("isuse_packed_route_details", isuse_packed_route_details);
        } else {
            model.addAttribute("productName", null);
        }
        return "/customized/packageTour/product/showProductMaintain";
    }

    /**
     * 跳转到添加产品
     *
     * @param model
     * @param productId
     * @return
     */
    @RequestMapping(value = "/showAddProduct")
    public String showAddProduct(Model model, HttpServletRequest req) throws BusinessException {
        if (LOG.isDebugEnabled()) {
            LOG.debug("start method<showAddProduct>");
        }
        BizCategory bizCategory = null;
        List<BizCatePropGroup> bizCatePropGroupList = null;
        try{
        if (req.getParameter("categoryId") != null) {
            bizCategory = bizCategoryQueryService.getCategoryById(Long.valueOf(req.getParameter("categoryId")));
            bizCatePropGroupList = categoryPropGroupService.findCategoryPropGroupsAndCategoryProp(Long.valueOf(req.getParameter("categoryId")), true);
        }
        model.addAttribute("bizCategory", bizCategory);
        if(bizCategory != null){
            model.addAttribute("categoryName", bizCategory.getCategoryName());
            //用于判断前台是否展示按份售卖
            Constant.VST_CATEGORY routeFreedom = Constant.VST_CATEGORY.CATEGORY_ROUTE_FREEDOM;
            String showSaleTypeFlag = routeFreedom.getCategoryId().equals(bizCategory.getCategoryId().toString()) ? "YES" : "NO";
            model.addAttribute("showSaleTypeFlag", showSaleTypeFlag);
        }
        model.addAttribute("copiesList", ProdProductSaleRe.COPIES.values());
//		model.addAttribute("bizCatePropGroupList", bizCatePropGroupList);
        //下单必填项
        model.addAttribute("travNumTypeList", BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.all());

        setModelAtrribute(model);

        //加载分销渠道的分销商
        ResultHandleT<TntGoodsChannelVo> tntGoodsChannelVoRt = tntGoodsChannelCouponServiceRemote
                .getChannels(TntGoodsChannelCouponAdapter.CH_TYPE.NONE.name());
        if(tntGoodsChannelVoRt != null && tntGoodsChannelVoRt.getReturnContent() != null){
            TntGoodsChannelVo tntGoodsChannelVo = (TntGoodsChannelVo)tntGoodsChannelVoRt.getReturnContent();
            model.addAttribute("tntGoodsChannelVo", tntGoodsChannelVo);
        }

        // 公司主体
        Map<String, String> companyTypeMap = new HashMap<String, String>();
        for (ProdProduct.COMPANY_TYPE_DIC item : ProdProduct.COMPANY_TYPE_DIC.values()) {
            companyTypeMap.put(item.name(), item.getTitle());
        }
        model.addAttribute("companyTypeMap", companyTypeMap);
        if (req.getParameter("subCategoryId") != null&&!req.getParameter("subCategoryId").equals("")) {//子分类id不为空
            Long subCategoryId = Long.valueOf(req.getParameter("subCategoryId"));
            WineSplitConstants.changeCateProp(subCategoryId, bizCatePropGroupList);
            model.addAttribute("subCategoryId",subCategoryId);
            model.addAttribute("bizCatePropGroupList", bizCatePropGroupList);
            List<BizCatePropGroup> subCatePropGroupList = null;
            subCatePropGroupList = categoryPropGroupService.findCategoryPropGroupsAndCategoryProp(subCategoryId, true);
            model.addAttribute("subCatePropGroupList", subCatePropGroupList);
            model.addAttribute("categoryId", req.getParameter("categoryId"));
            return "/customized/packageTour/product/showAddSubProduct";
        }
        //如果不是 自由行—景+酒产品  则前台不显示"驴色飞扬自驾"标志
        if(req.getParameter("categoryId")!=null && req.getParameter("categoryId")!=""){
        	try {
        		 WineSplitConstants.changeTypeShow(Long.valueOf(req.getParameter("categoryId")),bizCatePropGroupList);
			} catch (Exception e) {
				log.error("品类："+req.getParameter("categoryId")+"--如果不是 自由行—景+酒产品  则前台不显示'驴色飞扬自驾'标志,数据类型转换异常" + e);
			}
        }
        model.addAttribute("categoryId", req.getParameter("categoryId"));
        model.addAttribute("bizCatePropGroupList", bizCatePropGroupList);
        }catch(Exception  e){
			LOG.error("Error on "+this.getClass().getName(), e);
	        model.addAttribute("errorMsg", "系统内部异常");
		}
        return "/customized/packageTour/product/showAddProduct";
    }


    /**
     * 行程列表页面
     * @param modelMap
     * @param productId
     * @param cancelFlag
     * @return
     */
    @RequestMapping(value = "/showUpdateRoute")
    public String showUpdateRoute(ModelMap modelMap, @Param("productId")Long productId, @Param("cancelFlag")String cancelFlag) {
        if(!("Y".equals(cancelFlag) || "N".equals(cancelFlag))) {
            cancelFlag = null;
        }
        modelMap.put("cancelFlag", cancelFlag);

        ProdProduct prodProduct = prodProductService.findProdProductByProductId(productId);
        modelMap.put("prodProduct", prodProduct);
        modelMap.put("packageType", ProdProduct.PACKAGETYPE.getCnName(prodProduct.getPackageType()));

        Map<String, Object> params = new HashMap<String, Object>();
        params.put("productId", productId);
        params.put("cancelFlag", cancelFlag);
        List<ProdLineRoute> prodLineRouteList = prodLineRouteService.findProdLineRouteByParams(params);
        modelMap.put("prodLineRouteList", prodLineRouteList);
        //校验行程
        List<ProdLineRoute> lineRouteList= checkRoute(productId);
        String routeFlag="false";
        if(lineRouteList!=null&&lineRouteList.size()>=1){
            routeFlag="true";
        }
        modelMap.addAttribute("routeFlag", routeFlag);

        //校验行程明细
        String saveRouteFlag=checkRouteDetail(productId);
        modelMap.addAttribute("saveRouteFlag", saveRouteFlag);

        //出境-需要校验签证材料
        if("FOREIGNLINE".equals(prodProduct.getProductType())){
            String visaDocFlag=checkvisaDoc( productId);
            modelMap.addAttribute("visaDocFlag", visaDocFlag);
        }

        //判断产品版本为1.0(是供应商打包，类别为15)
        Double modelVesion=prodProduct.getModelVersion();
        if(modelVesion==null||modelVesion!=1.0){
            modelMap.put("modelVersion", "false");
        }else if(modelVesion==1.0){
            modelMap.put("modelVersion", "true");
        }
        
        //校验“自动打包交通”属性和“是否使用被打包产品行程明细”属性
		ProdProductParam param = new ProdProductParam();
		param.setProductProp(true);
		param.setProductPropValue(true);
		ProdProduct product = prodProductService.findProdProductById(productId, param);
		Map<String, Object> propMap =product.getPropValue();
		String auto_pack_traffic = "N";
		String isuse_packed_route_details = "Y";
		if(propMap != null){
			auto_pack_traffic = (String)propMap.get("auto_pack_traffic");
			isuse_packed_route_details = (String)propMap.get("isuse_packed_route_details");
		}
        HttpServletLocalThread.getModel().addAttribute("auto_pack_traffic", auto_pack_traffic);
        HttpServletLocalThread.getModel().addAttribute("isuse_packed_route_details", isuse_packed_route_details);

        return "/prod/route/showUpdateRoute";
    }

    /**
     * 新增行程明细
     *
     * @return
     */
    @RequestMapping(value = "/addProdLineRouteDetail")
    @ResponseBody
    public Object addProdLineRouteDetail(ProdLineRoute prodLineRoute) throws BusinessException {
        if (LOG.isDebugEnabled()) {
            LOG.debug("start method<addProdLineRouteDetail>");
        }

        Map<String, Object> attributes = new HashMap<String, Object>();
        boolean isSuccess=true;

        if (null==prodLineRoute||null==prodLineRoute.getProductId()) {
            throw new BusinessException("非法请求参数");
        }

        try {
            prodLineRouteDetailService.saveProdLineRouteDetail(prodLineRoute);

            Long productId = prodLineRoute.getProductId();
            attributes.put("productId", productId);

//			ProdProductParam param = new ProdProductParam();
//			param.setBizCategory(true);
//			ProdProduct product = prodProductService.findProdProductById(productId,param);
            ProdProduct product = prodProductService.getProdProductBy(productId);
            attributes.put("categoryId", product.getBizCategoryId());
            attributes.put("categoryName", bizCategoryQueryService.getCategoryById(product.getBizCategoryId()).getCategoryName());
            attributes.put("productName", product.getProductName());

        } catch (Exception e) {
            LOG.error(ExceptionFormatUtil.getTrace(e));
            LOG.error("Push info failure ！Push Type:"+ ComPush.OBJECT_TYPE.PRODUCT.name()+" ID:"+prodLineRoute.getProductId());
            isSuccess=false;
        }

        //日志
        for(ProdLineRouteDetail prodLineRouteDetail : prodLineRoute.getProdLineRouteDetailList()){
            logLineRouteOperate(prodLineRoute,"更新行程明细："+getProdLineRouteDetailLog(prodLineRouteDetail),"更新行程明细");
        }


        if(!isSuccess)
        {
            throw new BusinessException("行程明细保存失败");
        }
        return new ResultMessage(attributes, "success", "行程保存成功");
    }

    @RequestMapping(value = "/deleteProdLineRouteDetail")
    @ResponseBody
    public Object deleteProdLineRouteDetail(Long detailId,Long routeId,Long productId) throws BusinessException {
        if (LOG.isDebugEnabled()) {
            LOG.debug("start method<deleteProdLineRouteDetail>");
        }

        Map<String, Object> attributes = new HashMap<String, Object>();
        boolean isSuccess=true;

        if (null==detailId || null==routeId) {
            throw new BusinessException("非法请求参数");
        }
        ProdLineRouteDetail prodLineRouteDetail = MiscUtils.autoUnboxing(prodLineRouteDetailService.findByPrimaryKey(detailId));
        try {
            pushAdapterService.push(productId, ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_LINE_ROUTE_DETAIL,ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);

            prodLineRouteDetailService.deleteByDetailId(detailId,routeId);

        } catch (Exception e) {
            LOG.error(ExceptionFormatUtil.getTrace(e));
            LOG.error("Push info failure ！Push Type:"+ComPush.OBJECT_TYPE.PRODUCT.name()+" ID:"+productId);
            isSuccess=false;
        }
        //日志
        ProdLineRoute prodLineRoute=new ProdLineRoute();
        prodLineRoute.setProductId(productId);
        prodLineRoute.setLineRouteId(routeId);
        logLineRouteOperate(prodLineRoute,"删除行程明细:"+getProdLineRouteDetailLog(prodLineRouteDetail),"删除行程明细");
        if(!isSuccess)
        {
            throw new BusinessException("行程明细保存失败");
        }
        return new ResultMessage(attributes, "success", "删除行程成功");
    }


    /**
     * 新增产品
     *
     * @return
     */
    @RequestMapping(value = "/addProduct")
    @ResponseBody
    public Object addProduct(ProdProduct prodProduct, ComOrderRequired comOrderRequired, String comOrderRequiredFlag,
                             HttpServletRequest req, String distributorUserIds, String docIds) throws BusinessException {
        if (LOG.isDebugEnabled()) {
            LOG.debug("start method<addProduct>");
        }

        if (prodProduct.getBizCategoryId()!=null) {
            //判断子品类是否存在
            if(prodProduct.getSubCategoryId()!=null){
                BizCategory subCategory  = bizCategoryQueryService.getCategoryById(prodProduct.getSubCategoryId());
                if(subCategory==null){
                    return new ResultMessage("error", "保存失败, 子品类不存在！");
                }
            }
            //保存产品和自动创建产品规格
            prodProduct.setAuditStatus(ProdProduct.AUDITTYPE.AUDITTYPE_TO_PM.name());
            //prodProduct.setCancelFlag("N");
            prodProduct.setCreateUser(this.getLoginUserId());
            long id = prodProductServiceAdapter.saveProdProduct(prodProduct);
            prodProduct.setProductId(id);

            //保存产品关联数据
            prodProductServiceAdapter.saveProdProductReData(prodProduct);

            //保存下单必填项
            if("Y".equals(comOrderRequiredFlag)){
                comOrderRequired.setObjectType(ComOrderRequired.OBJECTTYPE.PROD_PROCUT.name());
                comOrderRequired.setObjectId(id);
                comOrderRequiredService.saveComOrderRequired(comOrderRequired);
            }

            // 新增产品的销售渠道
            String[] distributorIds = req.getParameterValues("distributorIds");
            String[] distUserNames =req.getParameterValues("distUserNames");
            String logContent = distDistributorProdService.saveOrUpdateDistributorProd(id,distributorIds);
            if(distUserNames!=null){
                logContent=logContent+"分销商为："+ Arrays.toString(distUserNames);
            }
            distDistributorProdService.pushSuperDistributor(prodProduct, distributorUserIds);

            //添加签证材料与产品关联
            if(StringUtil.isNotEmptyString(docIds)){
                for(String docId : docIds.split(",")){
                    ProdVisadocRe prodVisadocRe = new ProdVisadocRe();
                    prodVisadocRe.setVisaDocId(Long.parseLong(docId));
                    prodVisadocRe.setProductId(prodProduct.getProductId());
                    prodVisadocReService.addProdVisadocRe(prodVisadocRe);
                }
            }

            //跟团游 自由行发送消息，计算交通 酒店信息
//			pushAdapterService.push(prodProduct.getProductId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_PRODUCT,ComPush.OPERATE_TYPE.ADD, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);

            Map<String, Object> attributes = new HashMap<String, Object>();
            attributes.put("productId", id);
            attributes.put("productName", prodProduct.getProductName());
            attributes.put("categoryName", prodProduct.getBizCategory().getCategoryName());
            attributes.put("productType", prodProduct.getProductType());           //添加操作日志
            try {
                comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT,
                        prodProduct.getProductId(), prodProduct.getProductId(),
                        this.getLoginUser().getUserName(),
                        "添加了产品：【"+prodProduct.getProductName()+"】"+logContent,
                        ComLog.COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name(),
                        "添加产品",null);
            } catch (Exception e) {
                // TODO Auto-generated catch block
                log.error("Record Log failure ！Log type:"+ ComLog.COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
                log.error(e.getMessage());
            }

            return new ResultMessage(attributes, "success", "保存成功");
        }
        return new ResultMessage("error", "保存失败,未选择品类");
    }

    /**
     * 跳转到修改页面
     * @return
     */
    @RequestMapping(value = "/showUpdateProduct")
    public String showUpdateProduct(Model model, HttpServletRequest req) throws BusinessException {
        if (LOG.isDebugEnabled()) {
            LOG.debug("start method<showUpdateProduct>");
        }
        ProdProduct prodProduct = null;
        List<BizCatePropGroup> bizCatePropGroupList = null;
        //判断是否点击条款菜单响应
        String suggestionType = req.getParameter("suggestionType");
        try{
        if (req.getParameter("productId") != null) {
            Map<String, Object> parameters = new HashMap<String, Object>();
            parameters.put("productId", req.getParameter("productId"));
            ProdProductParam param = new ProdProductParam();
            param.setBizCategory(true);
            param.setBizDistrict(true);	
            param.setProductProp(true);
            param.setProductPropValue(true);
            prodProduct = prodProductService.findProdProductById(Long.valueOf(req.getParameter("productId")),param);
            
            //用于前台校验“自动打包交通”属性和“是否使用被打包产品行程明细”属性
			Map<String, Object> propMap =prodProduct.getPropValue();
			String auto_pack_traffic = "N";
			String isuse_packed_route_details = "Y";
			if(propMap != null){
				auto_pack_traffic = (String)propMap.get("auto_pack_traffic");
				isuse_packed_route_details = (String)propMap.get("isuse_packed_route_details");
			}
			model.addAttribute("auto_pack_traffic", auto_pack_traffic);
			model.addAttribute("isuse_packed_route_details", isuse_packed_route_details);

            if(StringUtil.isEmptyString(suggestionType)){

                findManagerNameById(prodProduct);
                //查询关联数据
                prodProductServiceAdapter.findProdProductReData(prodProduct);

                //加载产品自动创建的规格
            }

            if (prodProduct != null) {
                bizCatePropGroupList = categoryPropGroupService.findCategoryPropGroupsAndCategoryProp(prodProduct.getBizCategory().getCategoryId(), false);
                if ((bizCatePropGroupList != null) && (bizCatePropGroupList.size() > 0)) {
                    for (BizCatePropGroup bizCatePropGroup : bizCatePropGroupList) {
                        if ((bizCatePropGroup.getBizCategoryPropList() != null) && (bizCatePropGroup.getBizCategoryPropList().size() > 0)) {
                            for (BizCategoryProp bizCategoryProp : bizCatePropGroup.getBizCategoryPropList()) {
                                Map<String, Object> parameters2 = new HashMap<String, Object>();
                                Long propId = bizCategoryProp.getPropId();
                                parameters2.put("productId", req.getParameter("productId"));
                                parameters2.put("propId", propId);

                                List<ProdProductProp> prodProductPropList = MiscUtils.autoUnboxing(prodProductPropService.findProdProductPropList(parameters2));
                                bizCategoryProp.setProdProductPropList(prodProductPropList);
                            }
                        }
                    }
                }



                if(null != prodProduct.getAttributionId()){
                    Attribution attribution = attributionService.findAttributionById(prodProduct.getAttributionId());
                    if(null != attribution){
                        prodProduct.setAttributionName(attribution.getAttributionName());
                    }
                }
                //用于判断前台是否展示按份售卖
                Constant.VST_CATEGORY routeFreedom = Constant.VST_CATEGORY.CATEGORY_ROUTE_FREEDOM;
                String showSaleTypeFlag = routeFreedom.getCategoryId().equals(prodProduct.getBizCategoryId().toString()) ? "YES" : "NO";
                model.addAttribute("showSaleTypeFlag", showSaleTypeFlag);
                model.addAttribute("copiesList", ProdProductSaleRe.COPIES.values());
                //查看是否打包酒店套餐
                if(!CollectionUtils.isEmpty(prodProduct.getProdProductSaleReList())){
                    model.addAttribute("isPackageGroupHotel", isPackageGroupHotel(prodProduct));
                }

            }

            //取得签证材料与产品关联
            HashMap<String, Object> params = new HashMap<String, Object>();
            params.put("productId", req.getParameter("productId"));
            List<ProdVisadocRe> prodVisadocReList = prodVisadocReService.findProdVisadocReByParams(params);
            params.clear();
            StringBuilder docIds = new StringBuilder(",");
            if(prodVisadocReList != null && prodVisadocReList.size() > 0){
                for(ProdVisadocRe prodVisadocRe : prodVisadocReList){
                    params.put("docId", prodVisadocRe.getVisaDocId());
                    docIds.append(prodVisadocRe.getVisaDocId()).append(",");
                }
                params.clear();
                params.put("docIds", docIds.toString().split(","));
                List<BizVisaDoc> bizVisaDocList = visaDocService.findBizVisaDoc(params);
                model.addAttribute("docIds", docIds);
                model.addAttribute("bizVisaDocList", bizVisaDocList);
            }

            //查询签证类型\送签城市字典
            params.clear();
            params.put("dictCode", "VISA_TYPE");
            List<BizDictExtend> vistTypeList = dictService.findBizDictExtendList(params);
            params.clear();
            params.put("dictCode", "VISA_CITY");
            List<BizDictExtend> vistCityList = dictService.findBizDictExtendList(params);
            model.addAttribute("vistTypeList", vistTypeList);
            model.addAttribute("vistCityList", vistCityList);

            //上级目的地查询
            if(prodProduct.getSubCategoryId() == null || prodProduct.getSubCategoryId().longValue()!=(long)181){
                if(prodProduct.getBizCategoryId().longValue()!=(long)17){
                    List<ProdDestRe> prodDestReList = prodProduct.getProdDestReList();
                    List<BizDest> bizDestList = new ArrayList<BizDest>();
                    if(prodDestReList!=null){
                        for(ProdDestRe prodDestRe:prodDestReList){
                            BizDest bizDest =new BizDest();
                            BizDest bizDestParent = new BizDest();
                            bizDest.setDestId(prodDestRe.getDestId());
                            bizDest.setParentDest(bizDestParent);
                            bizDestList.add(bizDest);
                        }
                    }
                    Map<String,Object> parametersParent =new HashMap<String,Object>();
                    bizDestList = destService.setParentsDestNameInfo(bizDestList,parametersParent);
                    StringBuffer sb = new StringBuffer();
                    for(BizDest bizDest:bizDestList){
                        for(ProdDestRe prodDestRe:prodDestReList){
                            if(prodDestRe.getDestId().longValue()==bizDest.getDestId().longValue()){
                                String[] array =  bizDest.getParentDest().getDestName().split("--");
                                array[array.length-1] = null;
                                for(String i:array){
                                    if(i!=null){
                                        sb.append(i+"--");
                                    }
                                }
                                if(sb.length() > 0){
                                    sb.delete(sb.lastIndexOf("--"),sb.length());
                                }

                                prodDestRe.setParentDestName(sb.toString());

                                if(sb!=null){
                                    sb.delete(0, sb.length());
                                }
                            }
                        }
                    }

                }
            }


            //加载分销渠道的分销商
            ResultHandleT<TntGoodsChannelVo> tntGoodsChannelVoRt = tntGoodsChannelCouponServiceRemote
                    .getChannels(TntGoodsChannelCouponAdapter.CH_TYPE.NONE.name());
            if(tntGoodsChannelVoRt != null && tntGoodsChannelVoRt.getReturnContent() != null){
                TntGoodsChannelVo tntGoodsChannelVo = (TntGoodsChannelVo)tntGoodsChannelVoRt.getReturnContent();
                model.addAttribute("tntGoodsChannelVo", tntGoodsChannelVo);
            }

            ResultHandleT<Long[]> userIdLongRt = tntGoodsChannelCouponServiceRemote.list(Long.parseLong(req.getParameter("productId")),
                    null, TntGoodsChannelCouponAdapter.PG_TYPE.PRODUCT.name());
            if(userIdLongRt != null && userIdLongRt.getReturnContent() != null && userIdLongRt.isSuccess()){
                Long[] userIdLong = (Long[])userIdLongRt.getReturnContent();
                StringBuilder userIdLongStr = new StringBuilder(",");
                for(Long userId : userIdLong){
                    userIdLongStr.append(userId.toString()).append(",");
                }
                model.addAttribute("userIdLongStr", userIdLongStr.toString());
            }
        }
        //判断是否组合套餐票打包
        if(prodProduct != null){
            Map<String, Object> packGroupParams = new HashMap<String, Object>();
            packGroupParams.put("productId", prodProduct.getProductId());
            packGroupParams.put("categoryId",13L);
            packGroupParams.put("muiltDpartureFlag",
                    prodProduct.getMuiltDpartureFlag());
            packGroupParams.put("groupType", ProdPackageGroup.GROUPTYPE.LINE_TICKET.name());
            List<ProdPackageGroup>  packGroupList = prodLineGroupPackService
                    .findProdLinePackGroupByParams(packGroupParams);
            if(packGroupList.size()>0)
            {
                prodProduct.setCategoryCombTicket("true");
            }
        }

        // 下单必填项
        Map<String, Object> param = new HashMap<String, Object>();
        List<BizOrderRequired> bizOrderRequiredList = bizOrderRequiredService.selectByExample(param);
        model.addAttribute("bizOrderRequiredList", bizOrderRequiredList);
        Map<String, Object> parameters = new HashMap<String, Object>();
        parameters.put("objectType", ComOrderRequired.OBJECTTYPE.PROD_PROCUT.name());
        parameters.put("objectId", req.getParameter("productId"));
        List<ComOrderRequired> comOrderRequiredList = comOrderRequiredService.findComOrderRequiredList(parameters);
        if(comOrderRequiredList!=null && comOrderRequiredList.size()>0){
            model.addAttribute("comOrderRequired", comOrderRequiredList.get(0));
        }
        model.addAttribute("travNumTypeList", BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.all());
        model.addAttribute("prodProduct", prodProduct);
        if(prodProduct != null && prodProduct.getBizCategory() != null){
            model.addAttribute("categoryName", prodProduct.getBizCategory().getCategoryName());
        }
        if (prodProduct != null && prodProduct.getSubCategoryId() != null) {//子分类id不为空
            Long subCategoryId = prodProduct.getSubCategoryId();
            WineSplitConstants.changeCateProp(subCategoryId, bizCatePropGroupList);
            List<BizCatePropGroup> subCatePropGroupList = null;
            subCatePropGroupList = categoryPropGroupService.findCategoryPropGroupsAndCategoryProp(prodProduct.getSubCategoryId(), false);
            if ((subCatePropGroupList != null) && (subCatePropGroupList.size() > 0)) {
                for (BizCatePropGroup bizCatePropGroup : subCatePropGroupList) {
                    if ((bizCatePropGroup.getBizCategoryPropList() != null) && (bizCatePropGroup.getBizCategoryPropList().size() > 0)) {
                        for (BizCategoryProp bizCategoryProp : bizCatePropGroup.getBizCategoryPropList()) {
                            Map<String, Object> parameters2 = new HashMap<String, Object>();
                            Long propId = bizCategoryProp.getPropId();
                            parameters2.put("productId", req.getParameter("productId"));
                            parameters2.put("propId", propId);

                            List<ProdProductProp> prodProductPropList = MiscUtils.autoUnboxing(prodProductPropService.findProdProductPropList(parameters2));
                            bizCategoryProp.setProdProductPropList(prodProductPropList);
                        }
                    }
                }
            }
            model.addAttribute("subCatePropGroupList", subCatePropGroupList);
        }else{
        	if(prodProduct!=null && prodProduct.getBizCategoryId()!=null){
				WineSplitConstants.changeTypeShow(prodProduct.getBizCategoryId(),bizCatePropGroupList);
			}
        }
        //酒店套餐，判断bu
        if(prodProduct != null && prodProduct.getBizCategory() != null && "category_route_hotelcomb".equals(prodProduct.getBizCategory().getCategoryCode())){
            SuppGoods suppGoods = suppGoodsService.findBaseSuppGoodsByProductId(prodProduct.getProductId());
            if(suppGoods != null){
                model.addAttribute("suppGoodsBu", suppGoods.getBu());
            }
        }
        model.addAttribute("bizCatePropGroupList", bizCatePropGroupList);
        model.addAttribute("productId", req.getParameter("productId"));
        setModelAtrribute(model);

        //电子合同
        if(prodProduct != null){
            ProdEcontract econtract = prodEcontractService.selectByProductId(prodProduct.getProductId());
            model.addAttribute("econtract", econtract);
        }

        // 公司主体
        Map<String, String> companyTypeMap = new HashMap<String, String>();
        for (ProdProduct.COMPANY_TYPE_DIC item : ProdProduct.COMPANY_TYPE_DIC.values()) {
            companyTypeMap.put(item.name(), item.getTitle());
        }
        model.addAttribute("companyTypeMap", companyTypeMap);
        model.addAttribute("categoryId", prodProduct.getBizCategoryId());
        }catch(Exception  e){
			LOG.error("Error on "+this.getClass().getName(), e);
	        model.addAttribute("errorMsg", "系统内部异常");
		}
        if(StringUtil.isEmptyString(suggestionType)){
            if (prodProduct != null && prodProduct.getSubCategoryId() != null) {
                return "/customized/packageTour/product/showUpdateSubProduct";
            }
            return "/customized/packageTour/product/showUpdateProduct";
        }else{
            return "/customized/packageTour/product/showProductSugg";
        }
    }

    /**
     * 更新产品
     *
     * @return
     */
    @RequestMapping(value = "/updateProduct")
    @ResponseBody
    public Object updateProduct(ProdProduct prodProduct, ComOrderRequired comOrderRequired, String distributorUserIds,
                                HttpServletRequest req, String docIds, String oldDocIds) throws BusinessException {
        if (LOG.isDebugEnabled()) {
            LOG.debug("start method<updateProduct>");
        }
        if (prodProduct.getBizCategoryId() == null) {
            throw new BusinessException("产品数据错误：无品类");
        }
        if (prodProduct.getProductId() == null) {
            throw new BusinessException("产品数据错误：无产品Id");
        }
        ResultMessage message = null;
        Long reqid = null;
        if(comOrderRequired !=null && comOrderRequired.getReqId()!=null){
            reqid = comOrderRequired.getReqId();
        }

        ProdProduct oldProduct = getOldProdProuDuctByProductIdForLog(prodProduct.getProductId(),reqid);

        //产品目的地关联时想增量表中添加数据
        //addComPushForProdDest(prodProduct);

        //如果多出发地按钮没有显示或没被选中
        if (StringUtil.isEmptyString(prodProduct.getMuiltDpartureFlag())) {
            prodProduct.setMuiltDpartureFlag("N");
        }

        // 是否为多出发地信息改变时，校验是否有打包交通组信息
        if (!prodProduct.getMuiltDpartureFlag().equalsIgnoreCase(oldProduct.getMuiltDpartureFlag())) {
            HashMap<String,Object> packageGroupParams = new HashMap<String,Object>();
            packageGroupParams.put("productId", prodProduct.getProductId());
            packageGroupParams.put("groupType", ProdPackageGroup.GROUPTYPE.TRANSPORT.name());//类型为交通
            List<ProdPackageGroup> packageGroupList = prodPackageGroupService.findProdPackageGroup(packageGroupParams);
            if(packageGroupList !=null && packageGroupList.size()>0){
                throw new BusinessException("请先删除产品下的打包交通组信息");
            }
        }

        prodProductService.updateProdProductProp(prodProduct);

        prodProductServiceAdapter.updateProdProductReData(prodProduct);

        //如果没有产品的出发地并且又不是多出发地产品，说明没有大交通,删掉之前的交通数据 （备注：如果多出发复选框勾选，产品的出发地是非必填项）
        if(prodProduct.getBizDistrictId()==null && prodProduct.getMuiltDpartureFlag() == "N"){
            //把行政区域设置为null
            prodProductService.updateDistrictByPrimaryKey(prodProduct);
            ProdTraffic pt  = prodTrafficService.selectByProductId(prodProduct.getProductId());
            if(pt!=null){
                prodTrafficService.deleteByPrimaryKey(pt.getTrafficId());
            }
            HashMap<String,Object> params = new HashMap<String,Object>();
            params.put("productId", prodProduct.getProductId());
            //删除交通组信息
            List<ProdTrafficGroup>  ptgList = prodTrafficGroupService.selectByParams(params);
            if(ptgList!=null && ptgList.size() >0){
                for(ProdTrafficGroup ptg : ptgList){
                    prodTrafficGroupService.deleteByPrimaryKey(ptg.getGroupId());
                }
            }
//			prodTrafficService.deleteByPrimaryKey(trafficId);
        }

        //修改下单必填项
        if(comOrderRequired != null){
            if(null!=comOrderRequired.getReqId()){
                comOrderRequiredService.updateConOrderRequired(comOrderRequired);
            }else{
                comOrderRequired.setObjectId(prodProduct.getProductId());
                comOrderRequired.setObjectType(ComOrderRequired.OBJECTTYPE.PROD_PROCUT.name());
                comOrderRequiredService.saveComOrderRequired(comOrderRequired);
            }
        }

        //更新签证材料与产品关联(先删除后重建)
        if(docIds != null && !docIds.equalsIgnoreCase(oldDocIds)){
            HashMap<String, Object> params = new HashMap<String, Object>();
            params.put("productId", prodProduct.getProductId());
            prodVisadocReService.deleteByParams(params);

            for(String docId : docIds.split(",")){
                if(StringUtil.isNotEmptyString(docId)){
                    ProdVisadocRe prodVisadocRe = new ProdVisadocRe();
                    prodVisadocRe.setVisaDocId(Long.parseLong(docId));
                    prodVisadocRe.setProductId(prodProduct.getProductId());
                    prodVisadocReService.addProdVisadocRe(prodVisadocRe);
                }
            }
        }

        // 新增产品的销售渠道
        String[] distributorIds = req.getParameterValues("distributorIds");
        String[] distUserNames =req.getParameterValues("distUserNames");
        String logContent = distDistributorProdService.saveOrUpdateDistributorProd(prodProduct.getProductId(),distributorIds);
        if(distUserNames!=null){
            logContent=logContent+"分销商为："+Arrays.toString(distUserNames);
        }
        distDistributorProdService.pushSuperDistributor(prodProduct, distributorUserIds);

        // 签证材料关联
        logContent += ComLogUtil.getLogTxt("签证材料关联", docIds, oldDocIds);

        // 电子合同
        prodEcontractService.saveOrUpdate(prodProduct.getProdEcontract());

        //添加操作日志

        try {
            //修改
            sendPushForSaleType(prodProduct, oldProduct);

            String logStr = getProdProductLog(prodProduct,oldProduct,distributorIds, distributorUserIds,comOrderRequired);
            if(StringUtils.isNotBlank(logStr)){

                logStr = "产品ID"+oldProduct.getProductId()+"," + logStr;
                String userName = "";
                PermUser permUser = this.getLoginUser();
                if(permUser !=null)
                {
                    userName = permUser.getUserName();
                }
                comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT,
                        prodProduct.getProductId(), prodProduct.getProductId(),
                        userName,
                        "修改产品:"+logStr+","+logContent,
                        ComLog.COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name(),
                        "修改产品",null);

            }


        } catch (Exception e) {
            log.error("Record Log failure ！Log type:"+ ComLog.COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
            log.error(e.getMessage());
        }
        SquidClient.getInstance().purgeProduct(prodProduct.getBizCategoryId(), prodProduct.getProductId()+"");
        message = new ResultMessage("success", "保存成功");
        return message;
    }

    private void sendPushForSaleType(ProdProduct prodProduct,
                                     ProdProduct oldProduct) {

        String saleType = prodProduct.getProdProductAdditionSaleType();
        String oldSaleType = oldProduct.getProdProductAdditionSaleType();

        if(saleType.contains(ProdProductSaleRe.SALETYPE.COPIES.name())
                && oldSaleType.contains(ProdProductSaleRe.SALETYPE.PEOPLE.name())){
            pushAdapterService.push(prodProduct.getProductId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_PRODUCT,ComPush.OPERATE_TYPE.VALID, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
        }
    }

    @RequestMapping(value = "/updateProductSugg")
    @ResponseBody
    public Object updateProductSugg(ProdProduct prodProduct, HttpServletRequest req) throws BusinessException {
        if (LOG.isDebugEnabled()) {
            LOG.debug("start method<updateProduct>");
        }
        if (prodProduct.getBizCategoryId() == null) {
            throw new BusinessException("产品数据错误：无品类");
        }
        if (prodProduct.getProductId() == null) {
            throw new BusinessException("产品数据错误：无产品Id");
        }
        ResultMessage message = null;

        //获取原始对象
        ProdProductParam param = new ProdProductParam();
        param.setProductProp(true);
        param.setProductPropValue(true);
        ProdProduct oldProdProduct = prodProductService.findProdProductById(prodProduct.getProductId(), param);

        prodProductService.updateProdProductProp(prodProduct);

        //添加操作日志
        try {
            String log =  getProdProductPropLog(prodProduct, oldProdProduct);
            if(StringUtil.isNotEmptyString(log)){
                comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.PROD_PRODUCT_SUGG,
                        prodProduct.getProductId(), prodProduct.getProductId(),
                        this.getLoginUser().getUserName(),
                        "修改产品:" + log,
                        ComLog.COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_SUGG_CHANGE.name(),
                        "修改产品",null);
            }
        } catch (Exception e) {
            log.error("Record Log failure ！Log type:"+ ComLog.COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
            log.error(ExceptionFormatUtil.getTrace(e));
        }
        SquidClient.getInstance().purgeProduct(prodProduct.getBizCategoryId(), prodProduct.getProductId()+"");
        message = new ResultMessage("success", "保存成功");
        return message;
    }

    private String getProdProductLog(ProdProduct prodProduct,ProdProduct oldProduct,String[] distributorIds, String distributorUserIds,ComOrderRequired comOrderRequired) {
        if(prodProduct == null){
            return StringUtils.EMPTY;
        }


        //获取目的地地址
        List<String> destList = new ArrayList<String>();
        for(ProdDestRe dest : oldProduct.getProdDestReList()){
            destList.add(dest.getDestName());
        }
        String districtName = "";
        if(oldProduct.getBizDistrict()!=null){
            districtName = oldProduct.getBizDistrict().getDistrictName();
        }
        String[] newDestValues = prodProduct.getDest();
        List<String> newDestvalue = new ArrayList<String>();
        for(String newDest : newDestValues ){
            if(newDest.contains("[")) {
                String dest = newDest.substring(0, newDest.lastIndexOf("["));
                newDestvalue.add(dest);
            }
        }

        StringBuilder sb = new StringBuilder();
        sb.append(getChangeLog("产品名称", oldProduct.getProductName(), prodProduct.getProductName()));
        sb.append(getChangeLog("供应商产品名称", oldProduct.getSuppProductName(), prodProduct.getSuppProductName()));
        sb.append(getChangeLog("是否有效","Y".equals(oldProduct.getCancelFlag())?"是":"否","Y".equals(prodProduct.getCancelFlag())?"是":"否"));
        sb.append(getChangeLog("推荐级别", String.valueOf(oldProduct.getRecommendLevel()), String.valueOf(prodProduct.getRecommendLevel())));
        sb.append(getChangeLog("类别","INNERLINE".equals(oldProduct.getProductType())?"国内":"出境/港澳台" , "INNERLINE".equals(prodProduct.getProductType())?"国内":"出境/港澳台"));
        sb.append(getChangeLog("打包类型", "LVMAMA".equals(oldProduct.getPackageType())?"自主打包":"供应商打包", "LVMAMA".equals(prodProduct.getPackageType())?"自主打包":"供应商打包"));
        sb.append(getChangeLog("所属分公司", CommEnumSet.FILIALE_NAME.getCnName(oldProduct.getFiliale()), CommEnumSet.FILIALE_NAME.getCnName(prodProduct.getFiliale())));
        //日志新增bu与归属地
        if(prodProduct.getBu() != null){
            String newValue = "";
            String oldValue = "";
            newValue = bizBuEnumClientService.getBizBuEnumByBuCode(prodProduct.getBu()).getReturnContent().getCnName();
            oldValue = bizBuEnumClientService.getBizBuEnumByBuCode(oldProduct.getBu()).getReturnContent().getCnName();
            sb.append(getChangeLog("BU", oldValue, newValue));
        }
        if(prodProduct.getAttributionId() != null){
            String oldValue = null;
            if(oldProduct.getAttributionId() != null){
                Attribution attribution = attributionService.findAttributionById(oldProduct.getAttributionId());
                if (null != attribution) {
                    oldValue = attribution.getAttributionName();
                }
            }
            sb.append(getChangeLog("归属地", oldValue, prodProduct.getAttributionName()));
        }
        sb.append(getProdProductPropLog(prodProduct,oldProduct));
        sb.append((StringUtils.isBlank(districtName) || StringUtils.isBlank(prodProduct.getDistrict())) ? "" : getChangeLog("出发地", districtName, prodProduct.getDistrict()));
        sb.append(getChangeLog("目的地", destList.toString(),newDestvalue.toString()));
        sb.append(getDistributorLog(distributorIds,distributorUserIds,oldProduct));
        sb.append(getReservationLimitLog(comOrderRequired,oldProduct));
        String oldEcontract = StringUtils.EMPTY;
        if(oldProduct.getProdEcontract() != null){
            String oldEcontractTemplate = oldProduct.getProdEcontract().getEcontractTemplate();
            oldEcontract = StringUtils.isEmpty(oldEcontractTemplate)?"自动调取":ProdEcontract.ELECTRONIC_CONTRACT_TEMPLATE.getCnName(oldEcontractTemplate);
        }else{
            oldEcontract = "自动调取";
        }

        String newEcontract = prodProduct.getProdEcontract().getEcontractTemplate();
        sb.append(getChangeLog("电子合同", oldEcontract, StringUtils.isEmpty(newEcontract)?"自动调取":ProdEcontract.ELECTRONIC_CONTRACT_TEMPLATE.getCnName(newEcontract)));
        sb.append(buildSaleTypeLogText(oldProduct, prodProduct));
        return sb.toString();
    }

    private String buildSaleTypeLogText(ProdProduct oldProduct, ProdProduct prodProduct) {
        ProdProductSaleRe preSaleType = null;
        if(oldProduct.getProdProductSaleReList() != null && !oldProduct.getProdProductSaleReList().isEmpty()) {
            preSaleType = oldProduct.getProdProductSaleReList().get(0);
        }
        ProdProductSaleRe currSaleType = null;
        if(prodProduct.getProdProductSaleReList() != null && !prodProduct.getProdProductSaleReList().isEmpty()) {
            currSaleType = prodProduct.getProdProductSaleReList().get(0);
        }
        StringBuilder logText = new StringBuilder();
        if(preSaleType != null && currSaleType != null) {
            logText.append("售卖方式"+":[原来值：" + preSaleType.getSaleType() + "," + "新值：" + preSaleType.getSaleType() + "]");
            logText.append("成人数"+":[原来值：" + preSaleType.getAdult() + "," + "新值：" + preSaleType.getAdult() + "]");
            logText.append("儿童数"+":[原来值：" + preSaleType.getChild() + "," + "新值：" + preSaleType.getChild() + "]");
        }
        return logText.toString();
    }

    private String getReservationLimitLog(ComOrderRequired comOrderRequired,ProdProduct oldProduct) {
        String ret = StringUtils.EMPTY;
        if(comOrderRequired==null){
            return ret;
        }
        StringBuilder logStr = new StringBuilder();

        ComOrderRequired oldComOrderRequirede = oldProduct.getComOrderRequired();
        if(oldComOrderRequirede != null) {
            if(StringUtils.isNotEmpty(comOrderRequired.getTravNumType())){
                logStr.append(getChangeLog("1笔订单需要的“游玩人/取票人”数量",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(oldComOrderRequirede.getTravNumType()) , BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getTravNumType())));
            }
            if(StringUtils.isNotEmpty(comOrderRequired.getEnnameType())){
                logStr.append(getChangeLog("英文姓名",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(oldComOrderRequirede.getEnnameType()), BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getEnnameType())));
            }
            if(StringUtils.isNotEmpty(comOrderRequired.getOccupType())){
                logStr.append(getChangeLog("人群",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(oldComOrderRequirede.getOccupType()), BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getOccupType())));
            }
            if(StringUtils.isNotEmpty(comOrderRequired.getPhoneType())){
                logStr.append(getChangeLog("手机号",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(oldComOrderRequirede.getPhoneType()), BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getPhoneType())));
            }
            if(StringUtils.isNotEmpty(comOrderRequired.getEmailType())){
                logStr.append(getChangeLog("email",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(oldComOrderRequirede.getEmailType()), BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getEmailType())));
            }
            if(StringUtils.isNotEmpty(comOrderRequired.getCredType())){
                logStr.append(getChangeLog("证件",BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(oldComOrderRequirede.getCredType()), BizOrderRequired.BIZ_ORDER_REQUIRED_TRAV_NUM_LIST.getCnName(comOrderRequired.getCredType())));
            }
            if(logStr.length() >0)
            {
                ret = "预订限制:["+logStr.toString()+"]";
            }

            String documentType = StringUtils.EMPTY;
            String idFlag = getValidLog(comOrderRequired.getIdFlag());
            if(StringUtils.isNotEmpty(idFlag)){
                documentType += getChangeLog("身份证",getValidLog(oldComOrderRequirede.getIdFlag()),idFlag);
            }
            ;
            if(StringUtils.isNotEmpty(idFlag)){
                documentType += getChangeLog("护照",getValidLog(oldComOrderRequirede.getPassportFlag()) ,getValidLog(comOrderRequired.getPassportFlag()));
            }
            if(StringUtils.isNotEmpty(idFlag)){
                documentType += getChangeLog("港澳通行证",getValidLog(oldComOrderRequirede.getPassFlag()) ,getValidLog(comOrderRequired.getPassFlag()));
            }
            if(StringUtils.isNotEmpty(idFlag)){
                documentType += getChangeLog("台湾通行证",getValidLog(oldComOrderRequirede.getTwPassFlag()) ,getValidLog(comOrderRequired.getTwPassFlag()));
                documentType += getChangeLog("台胞证",getValidLog(oldComOrderRequirede.getTwResidentFlag()) ,getValidLog(comOrderRequired.getTwResidentFlag()));
                documentType += getChangeLog("出生证明(婴儿)",getValidLog(oldComOrderRequirede.getBirthCertFlag()) ,getValidLog(comOrderRequired.getBirthCertFlag()));
                documentType += getChangeLog("户口簿(儿童)",getValidLog(oldComOrderRequirede.getHouseholdRegFlag()) ,getValidLog(comOrderRequired.getHouseholdRegFlag()));
                documentType += getChangeLog("士兵证",getValidLog(oldComOrderRequirede.getSoldierFlag()) ,getValidLog(comOrderRequired.getSoldierFlag()));
                documentType += getChangeLog("军官证",getValidLog(oldComOrderRequirede.getOfficerFlag()) ,getValidLog(comOrderRequired.getOfficerFlag()));
                documentType += getChangeLog("回乡证(港澳居民)",getValidLog(oldComOrderRequirede.getHkResidentFlag()) ,getValidLog(comOrderRequired.getHkResidentFlag()));
            }
            if(StringUtils.isNotEmpty(documentType)){
                documentType="可用证件类型:["+documentType+"]";
            }
            if(StringUtils.isNotEmpty(ret)){
                ret = ret +",";
            }
            ret += documentType;
        }
        return ret;
    }

    private String getValidLog(String flag){
        if(StringUtils.isEmpty(flag)){
            return StringUtils.EMPTY;
        }
        return "Y".equals(flag)?"可用":"不可用";
    }

    private String getDistributorLog(String[] distributorIds, String distributorUserIds,ProdProduct oldProduct) {

        String ret = StringUtils.EMPTY;
        //销售渠道
        //修改之前
        StringBuilder logStr = new StringBuilder();
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("cancelFlag", "Y");
        List<String> distributorNames = new ArrayList<String>();
        try{
        List<Distributor> oldistributors = distributorService.findDistributorList(params).getReturnContent();
        for(Distributor distributor :oldistributors){
            for(DistDistributorProd disTributorProd :oldProduct.getDistDistributorProds()){
                if(disTributorProd.getDistributorId().equals(distributor.getDistributorId())){
                    distributorNames.add(distributor.getDistributorName());
                }
            }
        }

        //修改中
        if(ArrayUtils.isNotEmpty(distributorIds)){
            List<String> distributors = new ArrayList<String>();
            for(String distributorId : distributorIds){
                Distributor distributor = distributorService.findDistributorById(Long.valueOf(distributorId)).getReturnContent();
                if(distributor!=null){
                    distributors.add(distributor.getDistributorName());
                }
            }
            ret = distributors.toString();
        }

        logStr.append(getChangeLog("销售渠道",distributorNames.toString(),ret));

        return logStr.toString();
        }catch(Exception  e){
			LOG.error("Error on "+this.getClass().getName(), e);
			return null;
        }
    }

    private String getProdProductPropLog(ProdProduct prodProduct, ProdProduct oldProdProduct) {
        StringBuilder ret = new StringBuilder();
        if (prodProduct == null) {
            return StringUtils.EMPTY;
        }
        List<Long> propPropIds = new ArrayList<Long>();
        for (ProdProductProp props : oldProdProduct.getProdProductPropList()) {

            propPropIds.add(props.getProdPropId());
        }

        for (ProdProductProp prop : prodProduct.getProdProductPropList()) {
            if (!propPropIds.contains(prop.getProdPropId())) {

                BizCategoryProp bizCategoryProp = categoryPropService.findCategoryPropById(prop.getPropId());
                if ("INPUT_TYPE_RICH".equalsIgnoreCase(bizCategoryProp.getInputType())) {

                    String temp = "";
                    temp = getChangeLog(bizCategoryProp.getPropName(), "", prop.getPropValue());
                    if (StringUtils.isNotBlank(temp)) {
                        temp = "修改了" + bizCategoryProp.getPropName() + ",";
                    }
                    ret.append(temp);

                } else {
                    ret.append(getChangeLog(bizCategoryProp.getPropName(), "", prop.getPropValue()));
                }
                continue;
            }
            for (ProdProductProp prop2 : oldProdProduct.getProdProductPropList()) {

                if (prop.getProdPropId().equals(prop2.getProdPropId())) {

                    BizCategoryProp bizCategoryProp = categoryPropService.findCategoryPropById(prop.getPropId());
                    if ("traffic_flag".equalsIgnoreCase(bizCategoryProp.getPropCode())) {

                        ret.append(getChangeLog(bizCategoryProp.getPropName(), prop2.getPropValue().equals("Y") ? "是"
                                : "否", prop.getPropValue().equals("Y") ? "是" : "否"));

                    } else if ("combo_contained".equalsIgnoreCase(bizCategoryProp.getPropCode())) {

                        ret.append(getChangeLog("套餐包含", getPackageContent(prop2).toString(), getPackageContent(prop)
                                .toString()));

                    } else if ("contained_item".equalsIgnoreCase(bizCategoryProp.getPropCode())) {
                        String ss = prop2.getPropValue();
                        String[] oldstrs = ss.split(",");
                        List<String> str1 = new ArrayList<String>();
                        for (String s : oldstrs) {
                            str1.add(getDictName(s));
                        }

                        String[] newstrs = prop.getPropValue().split(",");
                        List<String> str2 = new ArrayList<String>();
                        for (String s : newstrs) {
                            str2.add(getDictName(s));
                        }

                        ret.append(getChangeLog(bizCategoryProp.getPropName(), str1.toString(), str2.toString()));

                    } else {
                        if ("INPUT_TYPE_RICH".equalsIgnoreCase(bizCategoryProp.getInputType())) {

                            String temp = "";
                            temp = getChangeLog(bizCategoryProp.getPropName(), prop2.getPropValue(),
                                    prop.getPropValue());
                            if (StringUtils.isNotBlank(temp)) {
                                temp = "修改了" + bizCategoryProp.getPropName() + ",";
                            }
                            ret.append(temp);

                        } else {
                            ret.append(getChangeLog(bizCategoryProp.getPropName(), prop2.getPropValue(),
                                    prop.getPropValue()));
                        }

                    }

                }

            }

        }
        return ret.toString();
    }


    private String getDictName(String defId){
        String dictname = "";
        if(StringUtil.isNotEmptyString(defId)){


            BizDict bizdict = bizDictQueryService.selectByPrimaryKey(Long.parseLong(defId));
            if(bizdict!=null){
                dictname = bizdict.getDictName();
                if(StringUtils.isNotBlank(dictname)){
                    return dictname;
                }
            }


        }

        return "";
    }

    private List<String> getPackageContent(ProdProductProp prodProductProp) {
        if(prodProductProp==null){
            return Collections.emptyList();
        }
        String contents = prodProductProp.getPropValue();
        if(StringUtils.isEmpty(contents)){
            return Collections.emptyList();
        }
        List<String> ret = new ArrayList<String>();
        for(String dictId : contents.split(",")){
            BizDict bizDict = bizDictQueryService.selectByPrimaryKey(Long.valueOf(dictId));
            ret.add(bizDict.getDictName());
        }
        return ret;
    }

    private String getProdProductChangeLog(ProdProduct oldProduct,ProdProduct newProduct){
        StringBuffer logStr = new StringBuffer("");
        if(null!= newProduct)
        {
            if(!newProduct.getProdProductPropList().equals(oldProduct.getProdProductPropList())){
                Map<Long,ProdProductProp> oldProductProdMap = new HashMap<Long, ProdProductProp>();
                Map<Long,ProdProductProp> productProdMap = new HashMap<Long, ProdProductProp>();
                Map<Long,Map<String,String>> resultMap = new HashMap<Long, Map<String,String>>();

                ComLogUtil.setProductProp2Map(oldProduct.getProdProductPropList(),oldProductProdMap);
                ComLogUtil.setProductProp2Map(newProduct.getProdProductPropList(),productProdMap);
                ComLogUtil.diffProductPropMap(oldProductProdMap, productProdMap, resultMap);

                StringBuffer suggGroupIds = new StringBuffer();
                Long categoryId = oldProduct.getBizCategoryId();
                Map<String, Object> categoryPropMap = new HashMap<String, Object>();
                categoryPropMap.put("dictDefFlag", "Y");
                categoryPropMap.put("needSuggCodes", "Y");
                categoryPropMap.put("categoryId", categoryId);
                List<BizCategoryProp> categoryPropList = MiscUtils.autoUnboxing(categoryPropService.findCategoryPropList(categoryPropMap));
                if(categoryPropList != null && !categoryPropList.isEmpty()){
                    for(BizCategoryProp categoryProp : categoryPropList){
                        suggGroupIds.append(categoryProp.getGroupId() + ",");
                    }
                }

                Map<Long,BizCategoryProp> bizCategoryMap = new HashMap<Long,BizCategoryProp>();
                List<BizCatePropGroup> bizCatePropGroupList = categoryPropGroupService.findCategoryPropGroupsAndCategoryProp(newProduct.getBizCategoryId(), false);
                if ((bizCatePropGroupList != null) && (bizCatePropGroupList.size() > 0)) {
                    for (BizCatePropGroup bizCatePropGroup : bizCatePropGroupList) {
                        if(suggGroupIds.indexOf(String.valueOf(bizCatePropGroup.getGroupId())) >= 0){
                            ComLogUtil.setbizCategory2Map(bizCatePropGroup.getBizCategoryPropList(), bizCategoryMap);
                        }
                    }
                }

                //获取产品动态属性列表变更日志
                for (Map.Entry<Long,Map<String,String>> entry : resultMap.entrySet()) {
                    if(Constant.PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_TEXTAREA.name().equals(bizCategoryMap.get(entry.getKey()).getInputType())
                            || Constant.PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_RICH.name().equals(bizCategoryMap.get(entry.getKey()).getInputType())){
                        String oldValue = resultMap.get(entry.getKey()).get("oldValue");
                        String newValue = resultMap.get(entry.getKey()).get("newValue");
                        if(null!=newValue && !newValue.equals(oldValue))
                        {
                            logStr.append(ComLogUtil.getLogTxt(bizCategoryMap.get(entry.getKey()).getPropName(),newValue,null));
                        }else{
                            logStr.append(ComLogUtil.getLogTxt(bizCategoryMap.get(entry.getKey()).getPropName(),newValue,oldValue));
                        }
                    }
                }
            }

        }
        return logStr.toString();
    }

    //封装返回固定值
    private void setModelAtrribute(Model model){
        model.addAttribute("addValueTitle", ProdProductProp.PROP_ADD_VALUE_SPLIT);
        // 类别
        List<ProdProduct.PRODUCTTYPE> productTypeList = new ArrayList<ProdProduct.PRODUCTTYPE>(Arrays.asList(ProdProduct.PRODUCTTYPE.values()));
        // 去掉快递
        productTypeList.remove(ProdProduct.PRODUCTTYPE.EXPRESS);
        //去掉押金
        productTypeList.remove(ProdProduct.PRODUCTTYPE.DEPOSIT);
        //去掉国内
        productTypeList.remove(ProdProduct.PRODUCTTYPE.INNERLINE);
        //去掉国内-边境游
        productTypeList.remove(ProdProduct.PRODUCTTYPE.INNER_BORDER_LINE);
        
        model.addAttribute("productTypeList", productTypeList);
        //打包类型
        model.addAttribute("packageTypeList", ProdProduct.PACKAGETYPE.values());
        // 分公司
        model.addAttribute("filiales", CommEnumSet.FILIALE_NAME.values());
        // BU
        model.addAttribute("buList", bizBuEnumClientService.getAllBizBuEnumList().getReturnContent());

        //销售渠道
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("cancelFlag", "Y");
        try{
	        List<Distributor> distributors = distributorService.findDistributorList(params).getReturnContent();
	        model.addAttribute("distributorList", distributors);
        }catch(Exception  e){
			LOG.error("Error on "+this.getClass().getName(), e);
			throw new BusinessException(e.getMessage());
		}
    }

    private void findManagerNameById(ProdProduct prodProduct){
        if(null!=prodProduct){
            PermUser permUser = permUserService.getPermUserByUserId(prodProduct.getManagerId());
            prodProduct.setManagerName("");
            if(permUser != null) {
                prodProduct.setManagerName(permUser.getRealName());
            }
        }
    }

    private String getProdLineRouteDetailLog(ProdLineRouteDetail prodLineRouteDetail){
        if(prodLineRouteDetail == null){
            return null;
        }
        String ret = "线路产品明细Id:"+(prodLineRouteDetail.getDetailId()==null?"":prodLineRouteDetail.getDetailId())
                +",关联行程Id:"+(prodLineRouteDetail.getRouteId()==null?"":prodLineRouteDetail.getRouteId())
                +",线路天数:"+(prodLineRouteDetail.getnDay()==null?"":prodLineRouteDetail.getnDay())
                +",标题:"+(prodLineRouteDetail.getTitle()==null?"":prodLineRouteDetail.getTitle())
                +",行程内容:"+(prodLineRouteDetail.getContent()==null?"":prodLineRouteDetail.getContent())
                +",住宿类型:"+(prodLineRouteDetail.getStayType()==null?"":bizDictQueryService.selectByPrimaryKey(Long.valueOf(prodLineRouteDetail.getStayType())).getDictName())
                +",住宿描述:"+(prodLineRouteDetail.getStayDesc()==null?"":prodLineRouteDetail.getStayDesc())
                +",是否有早餐:"+(prodLineRouteDetail.getBreakfastFlag()==null?"":prodLineRouteDetail.getBreakfastFlag())
                +",早餐描述:"+(prodLineRouteDetail.getBreakfastDesc()==null?"":prodLineRouteDetail.getBreakfastDesc())
                +",是否有午餐:"+(prodLineRouteDetail.getLunchFlag()==null?"":prodLineRouteDetail.getLunchFlag())
                +",午餐描述:"+(prodLineRouteDetail.getLunchDesc()==null?"":prodLineRouteDetail.getLunchDesc())
                +",是否有晚餐:"+(prodLineRouteDetail.getDinnerFlag()==null?"":prodLineRouteDetail.getDinnerFlag())
                +",晚餐描述:"+(prodLineRouteDetail.getDinnerDesc()==null?"":prodLineRouteDetail.getDinnerDesc())
                +",交通工具类型:"+getTrafficType(prodLineRouteDetail.getTrafficType());
        if(prodLineRouteDetail.getTrafficType()!=null && prodLineRouteDetail.getTrafficType().contains("OTHERS")){
            ret +=",其他交通:"+(prodLineRouteDetail.getTrafficOther()==null?"":prodLineRouteDetail.getTrafficOther());
        }
        return ret;
    }

    private List<String> getTrafficType(String trafficType){
        if(StringUtils.isEmpty(trafficType)){
            return Collections.emptyList();
        }
        List<String> ret = new ArrayList<String>();
        for(String type : trafficType.split(",")){
            ret.add(LineRouteEnum.TRAFFIC_TYPE.getCnName(type));
        }
        return ret;
    }



    //获取修改基本产品信息原始对象
    public ProdProduct getOldProdProuDuctByProductIdForLog(Long prodProductId,Long reqId){

        //获取原来产品对象
        Map<String, Object> parameters = new HashMap<String, Object>();
        parameters.put("productId",prodProductId);
        ProdProductParam param = new ProdProductParam();
        param.setBizCategory(true);
        param.setBizDistrict(true);
        param.setProductProp(true);
        param.setProductPropValue(true);
        ProdProduct oldProduct = prodProductService.findProdProductById(prodProductId,param);

        //查询关联数据
        if(oldProduct != null){
            Long productId = oldProduct.getProductId();
            //1、行程天数
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("productId", productId);
//					List<ProdLineRoute> prodLineRouteList = prodLineRouteService.findProdLineRouteByParams(params);
//					if(prodLineRouteList != null && prodLineRouteList.size() > 0){
//						oldProduct.setProdLineRoute(prodLineRouteList.get(0));
//					}

            //2、关联目的地数据
            oldProduct.setProdDestReList(prodDestReService.findProdDestReByParams(params));


            //3、关联的销售渠道信息
            try {
				oldProduct.setDistDistributorProds((List<DistDistributorProd>) MiscUtils.autoUnboxing(prodDistributorService.findDistDistributorProdByParams(params)));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

            //关联出发地


            //电子合同
            ProdEcontract econtract = prodEcontractService.selectByProductId(productId);
            oldProduct.setProdEcontract(econtract);

        }

        if(reqId!=null){
            ComOrderRequired oldComOrderRequirede = comOrderRequiredService.findComOrderRequiredById(reqId);
            oldProduct.setComOrderRequired(oldComOrderRequirede);
        }

        return oldProduct;

    }


    public String getChangeLog(String columnName,String oldStr,String newStr){
        String temp = "";
        if(oldStr ==null && newStr == null){

            return temp;

        }else if(oldStr ==null ||newStr ==null ){
            temp =  ComLogUtil.getLogTxt(columnName,newStr,oldStr);
            return temp;
        }else{

            if( !oldStr.equals(newStr)){
                temp = ComLogUtil.getLogTxt(columnName,newStr,oldStr)+",";
                return temp;
            }
        }


        return "";

    }


    private String getLog(ProdProduct product, String distributors){
        String ret = StringUtils.EMPTY;
        if(product == null){
            return ret;
        }

        ret += "所属品类：" + product.getBizCategory().getCategoryName() + " "
                + "产品名称：" + product.getProductName() + " "
                + "供应商产品名称：" + product.getSuppProductName() + " "
                + "推荐级别：" + product.getRecommendLevel() + " "
                + "类别：" ;

        if("INNERSHORTLINE".equals(product.getProductType())){
            ret += "国内-短线";
        } else if ("INNERLONGLINE".equals(product.getProductType())){
            ret += "国内-长线";
        } else if ("FOREIGNLINE".equals(product.getProductType())){
            ret += "出境/港澳台";
        } else if ("INNERLINE".equals(product.getProductType())) {
            ret += "国内";
        } else {
            ret += product.getProductType();
        }

        ret += " 打包类型：" + ("LVMAMA".equals(product.getPackageType())?"自主打包":"供应商打包") + " "
                + "所属分公司：" + CommEnumSet.FILIALE_NAME.getCnName(product.getFiliale()) + " "
                + "电子合同: " + (StringUtils.isEmpty(product.getProdEcontract().getEcontractTemplate())?"自动调取":ProdEcontract.ELECTRONIC_CONTRACT_TEMPLATE.getCnName(product.getProdEcontract().getEcontractTemplate())+ " ");

        for(ProdProductProp prop: product.getProdProductPropList()){
            if(prop.getPropId() == 600 ){
                ret += getChangeLog("是否有大交通",  prop.getPropValue().equals("Y")?"是":"否", prop.getPropValue().equals("Y")?"是":"否");
            }else if(prop.getPropId() == 601 ){
                ret += getChangeLog("套餐包含", getPackageContent(prop).toString(),getPackageContent(prop).toString());
            }else if(prop.getPropId() == 602 ){
                ret+= getChangeLog("产品经理推荐", prop.getPropValue(),prop.getPropValue());
            }else if(prop.getPropId() == 603 ){
                ret+= getChangeLog("产品特色", prop.getPropValue(),prop.getPropValue());
            }else if(prop.getPropId() == 604 ){
                ret+= getChangeLog("交通到达", prop.getPropValue(),prop.getPropValue());
            }
        }

        ret += " 出发地：" + product.getDistrict() + " "
                + "目的地：";

        String[] newDestValues = product.getDest();
        List<String> newDestvalue = new ArrayList<String>();
        for(String newDest : newDestValues ){
            if(newDest.contains("[")) {
                String dest = newDest.substring(0, newDest.lastIndexOf("["));
                newDestvalue.add(dest);
            }
        }
        ret += Arrays.asList(newDestValues) + " "
                + distributors;

        return ret;
    }

    /**
     * 复制产品
     *
     * @return
     */
    @RequestMapping(value = "/copyProduct")
    @ResponseBody
    public Object copyProduct(Model model, HttpServletRequest req) throws BusinessException {
        if (LOG.isDebugEnabled()) {
            LOG.debug("start method<copyProduct>");
        }

        if (req.getParameter("productId") != null) {
            ProdProductParam param = new ProdProductParam();
            param.setBizCategory(true);
            param.setBizDistrict(true);
            param.setProductProp(true);
            param.setProductPropValue(true);
            //复制产品
            ProdProduct prodProduct = prodProductService.findProdProductById(Long.valueOf(req.getParameter("productId")),param);
            
            //需求：交通自主打包产品 产品复制时不复制 自动打包交通组的内容，将自动打包交通组的值置为初始值  panyu  20160612
			Map<String, Object> propValue = prodProduct.getPropValue();
			if(null !=propValue && "Y".equals(propValue.get("auto_pack_traffic"))){
				propValue.put("auto_pack_traffic", "N");//自动打包交通
				propValue.put("isuse_packed_route_details", "Y");//是否使用被打包产品行程明细
				propValue.put("isuse_packed_cost_explanation", "N");//是否使用被打包产品费用说明
				propValue.put("packed_product_id", "");//被打包产品ID
			}
            
            long oldProductId = prodProduct.getProductId();
            prodProduct.setProductId(null);
            prodProduct.setCreateTime(new Date());
            prodProduct.setCreateUser(this.getLoginUserId());
            prodProduct.setAuditStatus(ProdProduct.AUDITTYPE.AUDITTYPE_TO_PM.name());
            prodProduct.setUrlId(null);
            prodProduct.setCancelFlag("N");
            prodProduct.setEbkSupplierGroupId(null);
            long newProductId = prodProductServiceAdapter.saveProdProduct(prodProduct);

            //复制关联数据
            int result = prodProductServiceAdapter.copyProdProductReData(prodProduct,oldProductId);

            Map<String, Object> attributes = new HashMap<String, Object>();
            attributes.put("productId", newProductId);
            attributes.put("productName", prodProduct.getProductName());
            attributes.put("categoryName", prodProduct.getBizCategory().getCategoryName());

            if(result!=1){
                return new ResultMessage(attributes, "success", "复制产品关联数据失败！");
            }
            //跟团游 自由行发送消息，计算交通 酒店信息
            pushAdapterService.push(prodProduct.getProductId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_PRODUCT,ComPush.OPERATE_TYPE.ADD, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);


            //添加操作日志
            try {
                comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT,
                        prodProduct.getProductId(), prodProduct.getProductId(),
                        this.getLoginUser().getUserName(),
                        "复制产品：【"+prodProduct.getProductName()+"】,原产品ID:【"+oldProductId+"】",
                        ComLog.COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name(),
                        "复制产品",null);
            } catch (Exception e) {
                // TODO Auto-generated catch block
                log.error("Record Log failure ！Log type:"+ ComLog.COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
                log.error(e.getMessage());
            }

            return new ResultMessage(attributes, "success", "复制成功");
        }

        return new ResultMessage("error", "复制失败");
    }
    //校验签证材料
    private String checkvisaDoc(Long productId )throws BusinessException {
        String visaDocFlag="true";
        //签证材料是否存在
        Map<String,Object> pars = new HashMap<String, Object>();
        List<ProdLineRoute> prodRouteList=checkRoute(productId);
        if(prodRouteList==null||prodRouteList.size()<=0){
            visaDocFlag="false";
        }
        for(ProdLineRoute pr:prodRouteList){
            pars.put("lineRouteId", pr.getLineRouteId());
            List<ProdVisadocRe>  visadocList=prodVisadocReService.findProdVisadocReByParams(pars);
            if(visadocList==null||visadocList.size()<=0){
                visaDocFlag="false";
                break;
            }
        }
        return  visaDocFlag;
    }

    //行程明细校验
    private String checkRouteDetail(Long productId)throws BusinessException {
        String saveRouteFlag="true";
        List<ProdLineRoute> prodRouteList=checkRoute(productId);
        if(prodRouteList==null||prodRouteList.size()<=0){
            saveRouteFlag="false";
        }
        for(ProdLineRoute pr:prodRouteList){
            List<ProdLineRouteDetail> routeDetailList=  prodLineRouteDetailService.selectByProdLineRouteId(pr.getLineRouteId());
            if(routeDetailList==null||routeDetailList.size()<=0){
                saveRouteFlag="false";
                break;
            }
        }
        return saveRouteFlag;
    }

    //行程校验
    private List<ProdLineRoute> checkRoute(Long productId)throws BusinessException {
        Map<String,Object> pars = new HashMap<String, Object>();
        pars.put("productId", productId);
        pars.put("cancleFlag", "Y");
        List<ProdLineRoute> prodRouteList=  prodLineRouteService.findProdLineRouteByParams(pars);
        return prodRouteList;
    }

    /**
     * 记录行程操作日志
     */
    private void logLineRouteOperate(ProdLineRoute LineRoute, String logText, String logName) {
        try{
            ProdLineRoute  pRoute=MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(LineRoute.getLineRouteId()));

            comLogService.insert(PROD_LINE_ROUTE, LineRoute.getProductId(), LineRoute.getLineRouteId(),
                    this.getLoginUser().getUserName(), "【"+pRoute.getRouteName()+"】"+logText, PROD_TRAVEL_DESIGN.name(), logName, null);
        }catch(Exception e) {
            log.error("Record Log failure ！Log Type:" + PROD_TRAVEL_DESIGN.name());
            log.error(e.getMessage(), e);
        }
    }

    /**
     * 查看产品是否打包酒店套餐
     * @param prodProduct
     * @return
     */
    private boolean isPackageGroupHotel(ProdProduct prodProduct)
    {
        HashMap<String,Object> params = new HashMap<String,Object>();
        params.put("productId", prodProduct.getProductId());
        params.put("groupType", ProdPackageGroup.GROUPTYPE.LINE.name());//类型为交通
        List<ProdPackageGroup> packageGroupList = prodPackageGroupService.findProdPackageGroup(params);
        if(CollectionUtils.isEmpty(packageGroupList)) return false;
        for(ProdPackageGroup pg :packageGroupList){
            if(pg.getCategoryId() == 17) return true;
        }
        return false;
    }
}
