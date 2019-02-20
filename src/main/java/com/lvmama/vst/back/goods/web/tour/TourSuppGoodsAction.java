package com.lvmama.vst.back.goods.web.tour;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.lvmama.vst.back.client.supp.service.*;

import net.sf.json.JSONArray;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.dubbo.common.utils.CollectionUtils;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.TypeReference;
import com.lvmama.bridge.router.SalesRouter;
import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.visa.api.service.VisaBranchService;
import com.lvmama.visa.api.service.VisaProdProductBranchService;
import com.lvmama.visa.api.service.VisaProdProductService;
import com.lvmama.vst.back.biz.po.Attribution;
import com.lvmama.vst.back.biz.po.BizBranch;
import com.lvmama.vst.back.biz.po.BizEnum;
import com.lvmama.vst.back.client.biz.service.AttributionClientService;
import com.lvmama.vst.back.client.biz.service.BizBuEnumClientService;
import com.lvmama.vst.back.client.biz.service.BranchClientService;
import com.lvmama.vst.back.client.dist.service.DistDistributorProdClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsHotelAdapterClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsSaleReClientService;
import com.lvmama.vst.back.client.prod.service.ProdAdditionFlagClientService;
import com.lvmama.vst.back.client.prod.service.ProdEcontractClientService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductBranchAdapterClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductBranchClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.client.prod.service.ProdRouteFeatureClientService;
import com.lvmama.vst.back.client.pub.service.ComCalDataClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.dist.po.DistDistributorProd;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.goods.po.SuppGoodsSaleRe;
import com.lvmama.vst.back.goods.po.SuppGoodsSaleReDetail;
import com.lvmama.vst.back.goods.service.SuppGoodsAdapterService;
import com.lvmama.vst.back.goods.service.SuppGoodsSaleReDetailService;
import com.lvmama.vst.back.goods.vo.ProdProductParam;
import com.lvmama.vst.back.pack.data.ProdProductGoodsBranchData;
import com.lvmama.vst.back.pack.service.ProdHotelGroupPackGoodsService;
import com.lvmama.vst.back.pack.service.ProdHotelGroupPackGoodslAdapterService;
import com.lvmama.vst.back.pack.vo.ProdProductGoodsBranchVO;
import com.lvmama.vst.back.prod.adapter.ProdProductHotelAdapterClientService;
import com.lvmama.vst.back.prod.po.ProdEcontract;
import com.lvmama.vst.back.prod.po.ProdLineRoute;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProduct.COMPANY_TYPE_DIC;
import com.lvmama.vst.back.prod.po.ProdProductBranch;
import com.lvmama.vst.back.prod.vo.ProdAdditionFlag;
import com.lvmama.vst.back.prod.vo.ProdProductSaleRelation;
import com.lvmama.vst.back.pub.po.ComCalData;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.supp.po.SuppContract;
import com.lvmama.vst.back.supp.po.SuppFaxRule;
import com.lvmama.vst.back.supp.po.SuppSettleRule;
import com.lvmama.vst.back.supp.po.SuppSettlementEntities;
import com.lvmama.vst.back.supp.po.SuppSupplier;
import com.lvmama.vst.back.supp.service.SuppSettlementEntitiesService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.enumeration.CommEnumSet;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.utils.front.ProductPreorderUtil;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.MemcachedEnum;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;

/**
 * 商品维护管理Action
 * 
 * @author qiujiehong
 * @date 2013-10-11
 */
@Controller
@RequestMapping("/tour/goods/goods")
public class TourSuppGoodsAction extends BaseActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = -7903219249998453644L;

	private static final Log LOG = LogFactory.getLog(TourSuppGoodsAction.class);

	@Autowired
	private SuppGoodsClientService suppGoodsService;
	
	
	@Autowired
	private SuppGoodsHotelAdapterClientService suppGoodsHotelAdapterService;
	
	@Autowired
	private ProdProductClientService prodProductService;
	
	@Autowired
	private ComLogClientService comLogService;
	
	
	@Autowired
	private ProdProductBranchClientService prodProductBranchService;
	
	@Autowired
	private ProdProductBranchAdapterClientService prodProductBranchAdapterService;
	
	
	@Autowired
	private SuppGoodsSaleReClientService suppGoodsSaleReService;
	

	@Autowired
	private SuppSupplierClientService suppSupplierService;
	

	@Autowired
	private SuppContractClientService suppContractService;
	

	@Autowired
	 protected ProdProductClientService prodProductClientRemote;       // 产品数据

	@Autowired
	private SuppFaxClientService suppFaxService;
	
	
	@Autowired
	private PermUserServiceAdapter permUserServiceAdapter;
	
	
	@Autowired
	private BranchClientService branchService;
	
	
	@Autowired
	private SuppGoodsAdapterService suppGoodsAdapter;//xxxx
	
	@Autowired
	private DistDistributorProdClientService distDistributorProdService;

	
    @Autowired
    private AttributionClientService attributionService;
    
    
    @Autowired
	private BizBuEnumClientService bizBuEnumClientService;
    
    @Autowired
    private SuppSettleRuleClientService   suppSettleRuleService;
    
    
    @Autowired
	private ProdLineRouteClientService prodLineRouteService;
    

	@Autowired
	private ProdRouteFeatureClientService prodRouteFeatureService;
	
    
    @Autowired
	private ProdEcontractClientService prodEcontractService;
    

	@Autowired
	private ProdHotelGroupPackGoodsService prodHotelGroupPackGoodsService;//3
	
	@Autowired
	private ProdHotelGroupPackGoodslAdapterService prodHotelGroupPackGoodslAdapterService;

	@Autowired
	private SuppGoodsSaleReDetailService suppGoodsSaleReDetailService;

	@Autowired
    private VisaProdProductBranchService visaProdProductBranchServiceRemote;

	@Autowired
	private VisaProdProductService visaProdProductServiceRemote;

	@Autowired
	private VisaBranchService visaBranchServiceRemote;

	@Autowired
	private SuppSettlementEntitiesService suppSettlementEntitiesService;
	
	@Autowired
	private SalesRouter salesRouter;//2
	
	@Autowired
	private ProdProductHotelAdapterClientService prodProductHotelAdapterService;
	
	
	@Autowired
	private ProdAdditionFlagClientService prodAdditionFlagService;

	@Autowired
	private SuppSettlementEntityClientService suppSettlementEntityClientServiceRemote;
	
	@Autowired
	private ComCalDataClientService comCalDataService;
	

	@RequestMapping(value = "/showBaseSuppGoods")
	public String showBaseSuppGoods(Model model, HttpServletRequest req,Long prodProductId,Long categoryId) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showSuppGoodsList>");
		}
		if(prodProductId==null)
			throw new BusinessException("产品ID不能为空");
		SuppGoods suppGoods = suppGoodsService.findBaseSuppGoodsByProductId(prodProductId);
		//如果有商品则设置相关信息
		if(suppGoods!=null){
			//内容维护人员
			Long contentManagerId = suppGoods.getContentManagerId();
			if (contentManagerId!=null) {
				PermUser user = permUserServiceAdapter.getPermUserByUserId(contentManagerId);
				if(user!=null)
					model.addAttribute("contentManagerName", user.getRealName());
				else
					model.addAttribute("contentManagerName", "");
			}
			//设置产品经理
			PermUser manager = permUserServiceAdapter.getPermUserByUserId(suppGoods.getManagerId());
				if(null != manager){
					suppGoods.setManagerName(manager.getRealName());
				}
			
			//设置供应商
			SuppSupplier suppSupplier =MiscUtils.autoUnboxing(suppSupplierService.findSuppSupplierById(suppGoods.getSupplierId()));
			suppGoods.setSuppSupplier(suppSupplier);
			//设置合同
			SuppContract suppContract = suppContractService.findSuppContractById(suppGoods.getContractId());
			//设置合同结算主体
			SuppSettleRule suppSettle =suppSettleRuleService.findSuppSettleRuleByContractId(suppContract.getContractId());
			suppContract.setSuppSettleRule(suppSettle);
			
			suppGoods.setSuppContract(suppContract);

			// 设置结算对象
			SuppSettlementEntities settlementEntity = suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(suppGoods.getSettlementEntityCode());
			suppGoods.setSettlementEntity(settlementEntity);
			// 设置买断结算对象
			if (StringUtils.isNotBlank(suppGoods.getBuyoutSettlementEntityCode())) {
				SuppSettlementEntities buyoutSettlementEntity = suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(suppGoods.getBuyoutSettlementEntityCode());
				suppGoods.setBuyoutSettlementEntity(buyoutSettlementEntity);
			}

			//判断有没有传真
			if("Y".equalsIgnoreCase(suppGoods.getFaxFlag())){
				SuppFaxRule suppFaxRule =MiscUtils.autoUnboxing(suppFaxService.findSuppFaxRuleById(suppGoods.getFaxRuleId()));
				suppGoods.setSuppFaxRule(suppFaxRule);
			}
			//归属地
			if(null != suppGoods.getAttributionId()){
				Attribution attribution = attributionService.findAttributionById(suppGoods.getAttributionId());
				if(null != attribution){
					suppGoods.setAttributionName(attribution.getAttributionName());
				}
			}
		}else {
			suppGoods = new SuppGoods();
		}
		
		// 公司主体
		Map<String, String> companyTypeMap = new HashMap<String, String>();
		for (COMPANY_TYPE_DIC item : COMPANY_TYPE_DIC.values()) {
			companyTypeMap.put(item.name(), item.getTitle());
		}
		model.addAttribute("companyTypeMap", companyTypeMap);
		
		//结算主体类型	
		model.addAttribute("lvAccSubjectList",SuppSettleRule.LVACC_SUBJECT.values());
		//供应商资质类型
		model.addAttribute("qualifyTypeList",SuppSupplier.QUAIFY_TYPE.values());
		
		//查询当前商品所属的产品
		ProdProduct prodProduct = null;
		ProdProductParam param = new ProdProductParam();
		param.setBizCategory(true);
		param.setBizDistrict(true);
		param.setProductProp(true);
		param.setProductPropValue(true);
		prodProduct =MiscUtils.autoUnboxing(prodProductService.findProdProductById(prodProductId,param));
				
		// 支付对象
		model.addAttribute("payTargetList", SuppGoods.PAYTARGET.values());
		// 分公司
		model.addAttribute("filialeList", CommEnumSet.FILIALE_NAME.values());
		// BU
		model.addAttribute("buList", bizBuEnumClientService.getAllBizBuEnumList().getReturnContent());
		// 商品类型
		model.addAttribute("goodsTypeList", SuppGoods.GOODSTYPE.values());
		// 寄件方
		model.addAttribute("expressTypeList", SuppGoods.EXPRESSTYPE.values());
		// 币种
		model.addAttribute("currencyTypeList", SuppGoods.CURRENCYTYPE.values());
		model.addAttribute("suppGoods", suppGoods);
		model.addAttribute("prodProductId", prodProductId);
		model.addAttribute("prodProduct", prodProduct);
		model.addAttribute("categoryId", categoryId);
		return "/goods/tour/goods/showGoodsBase";
	}
	
	
	@RequestMapping(value = "/updateSuppGoodsBase")
	@ResponseBody
	public Object updateSuppGoodsBase(Model model, HttpServletRequest req,SuppGoods suppGoods,Long categoryId) throws Exception {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showSuppGoodsList>");
		}
		LOG.info("updateSuppGoodsBase获取的商品信息："+suppGoods.toString());
		//查询该产品下所有产品规格
		HashMap<String,Object> params = new HashMap<String,Object>();
		params.put("productId", suppGoods.getProductId());
		List<ProdProductBranch>  productBranchList =MiscUtils.autoUnboxing(prodProductBranchService.findProdProductBranchList(params));
		if(productBranchList==null || productBranchList.size()==0){
			throw new BusinessException("没有产品规格!");
		}
		int rs = 0;
		//设置组织ID
		PermUser manager = permUserServiceAdapter.getPermUserByUserId(suppGoods.getManagerId());
		if(null != manager){
			suppGoods.setOrgId(manager.getDepartmentId());
		}	
		//如果是委托组团的话，商品修改或者新增需要标准化被委托组团方
		//供应商打包,委托组团
		ProdEcontract prodEcontract = this.prodEcontractService.selectByProductId(suppGoods.getProductId());
		if(ProdEcontract.GROUP_TYPE.COMMISSIONED_TOUR.name().equals(prodEcontract.getGroupType())){
			
			String supplierId =req.getParameter("supplierId");
			SuppSupplier suppSupplier =MiscUtils.autoUnboxing(suppSupplierService.findSuppSupplierById(Long.valueOf(supplierId)));
			//如果是子供应商，供应商对应的上级供应商名称
			if("2".equals(suppSupplier.getSupplierLevelType())){
				if(suppSupplier.getFatherId()!=null&&suppSupplier.getFatherId()!=0L){
					suppSupplier=MiscUtils.autoUnboxing(suppSupplierService.findSuppSupplierById(Long.valueOf(suppSupplier.getFatherId())));
					prodEcontract.setGroupSupplierName(suppSupplier.getSupplierName());
				}else{
					prodEcontract.setGroupSupplierName(suppSupplier.getSupplierName());
				}
			}else{//不是子供应商，供应商名称
				prodEcontract.setGroupSupplierName(suppSupplier.getSupplierName());
			}
			prodEcontractService.update(prodEcontract);
		}
		if(suppGoods.getSuppGoodsId()==null){
			suppGoods.setCreateUser(this.getLoginUserId());
			rs = suppGoodsAdapter.saveBaseSuppGoods(suppGoods, productBranchList, categoryId);
			//添加操作日志
			try {
				comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
						suppGoods.getProductId(), (long) rs, 
						this.getLoginUser().getUserName(), 
						"添加了商品：【商品基本信息】"+getSuppGoodsSaveLog(suppGoods), 
						COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(), 
						"新增商品",null);
			} catch (Exception e) {
				log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
				log.error(ExceptionFormatUtil.getTrace(e));
			}	
		}
		else{
			SuppGoods old =MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoods.getSuppGoodsId()));
			if(null!=old.getManagerId()){
				PermUser permUser=permUserServiceAdapter.getPermUserByUserId(old.getManagerId());
				if(null!=permUser){
					old.setManagerName(permUser.getRealName());
				}
			}
			SuppContract contract=this.suppContractService.findSuppContractById(old.getContractId());
			old.setSuppContract(contract);
			
			suppGoods.setUpdateUser(this.getLoginUserId());
			rs = suppGoodsAdapter.updateBaseSuppGoods(suppGoods);
			//添加操作日志
			try {
				comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
						suppGoods.getProductId(), suppGoods.getSuppGoodsId(), 
						this.getLoginUser().getUserName(), 
						"修改了商品：【商品基本信息】"+getSuppGoodsChangeLog(old,suppGoods),
						COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(), 
						"修改商品",null);
			} catch (Exception e) {
				log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
				log.error(ExceptionFormatUtil.getTrace(e));
			}	
		}

		if(rs==0){
			return new ResultMessage("error", "操作失败");
		}else{ //保存商品基本信息成功，获取商品的BU信息同步更新产品的BU信息
			ProdProduct prodProduct=new ProdProduct();
			prodProduct.setProductId(suppGoods.getProductId());
			prodProduct.setBu(suppGoods.getBu());
			prodProductService.updateByPrimaryKeySelective(prodProduct);
			if(suppGoods.getFiliale()!=null){
				if(("SH_FILIALE".equals(suppGoods.getFiliale())||"GZ_FILIALE".equals(suppGoods.getFiliale()) 
						|| "BJ_FILIALE".equals(suppGoods.getFiliale()) ||"CD_FILIALE".equals(suppGoods.getFiliale()) )){
					ProdAdditionFlag prodAdditionFlagold=MiscUtils.autoUnboxing(prodAdditionFlagService.selectByProductId(prodProduct.getProductId()));
					if(prodAdditionFlagold !=null){
						prodAdditionFlagold.setSelfFlag("Y");
						prodAdditionFlagService.updateProdAdditionFlagByPrimaryKey(prodAdditionFlagold);
					}else{
						ProdAdditionFlag prodAdditionFlag = new ProdAdditionFlag();
						prodAdditionFlag.setProductId(prodProduct.getProductId());
						prodAdditionFlag.setSelfFlag("Y");
						prodAdditionFlagService.insertProdAdditionFlag(prodAdditionFlag);
					}
					MemcachedUtil.getInstance().set(MemcachedEnum.SelfProductFlag.getKey() + prodProduct.getProductId(), MemcachedEnum.SelfProductFlag.getSec(),"Y");
				}else{
					ProdAdditionFlag prodAdditionFlagold=MiscUtils.autoUnboxing(prodAdditionFlagService.selectByProductId(prodProduct.getProductId()));
					if(prodAdditionFlagold !=null){
						prodAdditionFlagold.setSelfFlag("N");
						prodAdditionFlagService.updateProdAdditionFlagByPrimaryKey(prodAdditionFlagold);
						MemcachedUtil.getInstance().set(MemcachedEnum.SelfProductFlag.getKey() + prodProduct.getProductId(), MemcachedEnum.SelfProductFlag.getSec(),"N");
					}
				}
			}
			
			//重新构造目的地线路产品的产品特色
			if(Constant.BU_NAME.DESTINATION_BU.getCode().equals(suppGoods.getBu())){
				prodRouteFeatureService.updateDestBuProdRouteFeature(suppGoods.getProductId());
			}

		}
		
		return new ResultMessage("success", "操作成功");
	}

	@RequestMapping(value = "/showSuppGoodsList")
	public String showSuppGoodsList(Model model, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) { 
			LOG.debug("start method<showSuppGoodsList>");
		}
		return "/goods/tour/goods/findSuppGoodsList";
	}
	
	
	/**
	 * 跳转到成人儿童房差更新页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/showUpdateSuppGoods")
	public String showUpdateSuppGoods(Model model, HttpServletRequest req) throws Exception {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showUpdateSuppGoods>");
		}
		List<SuppGoods> suppGoodsList = null;
		String prodBranchId = req.getParameter("branchId");
		//如果没有传入产品规格ID，则尝试取产品ID,然后获取主规格ID
		if(StringUtils.isBlank(prodBranchId)){
			String productId = req.getParameter("productId");
			if(StringUtils.isNotBlank(productId)){
				HashMap<String,Object> params = new HashMap<String,Object>();
				params.put("productId", Long.valueOf(productId));
				List<ProdProductBranch> productBranchList = new ArrayList<ProdProductBranch>();
				productBranchList = MiscUtils.autoUnboxing(prodProductBranchService.findProdProductBranchList(params));
				if(productBranchList==null || productBranchList.size()==0){
					throw new BusinessException("没有产品规格!");				
				}
				for(ProdProductBranch productBranch : productBranchList){
					BizBranch branch =  MiscUtils.autoUnboxing(branchService.findBranchById(productBranch.getBranchId()));
					if("adult_child_diff".equalsIgnoreCase(branch.getBranchCode()) && "Y".equalsIgnoreCase(branch.getAttachFlag())){
						prodBranchId = productBranch.getProductBranchId() + "";
					}
				}
			}
			
		}
		
		if (StringUtils.isNotBlank(prodBranchId)) {
			ProdProductBranch prodProductBranch =  prodProductBranchService.findProdProductBranchById(Long.valueOf(prodBranchId), false, false);
			suppGoodsList =MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsByBranchId(Long.valueOf(prodBranchId)));
			ProdProduct pp = prodProductService.findProdProductByProductId(prodProductBranch.getProductId());
			if (null != suppGoodsList && suppGoodsList.size()>0) {
				SuppGoods suppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoodsList.get(0).getSuppGoodsId(), false, false));
				Long contentManagerId = suppGoods.getContentManagerId();
				if (contentManagerId != null) {
					PermUser user = permUserServiceAdapter
							.getPermUserByUserId(contentManagerId);
					if (user != null)
						model.addAttribute("contentManagerName",
								user.getRealName());
					else
						model.addAttribute("contentManagerName", "");
				}
				//设置产品经理
				PermUser manager = permUserServiceAdapter
						.getPermUserByUserId(suppGoods.getManagerId());
				if (null != manager) {
					suppGoods.setManagerName(manager.getRealName());
				}
				// 支付对象
				model.addAttribute("payTargetList",
						SuppGoods.PAYTARGET.values());
				// 设置结算对象
				SuppSettlementEntities settlementEntity = suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(suppGoods.getSettlementEntityCode());
				suppGoods.setSettlementEntity(settlementEntity);
				// 设置买断结算对象
				if (StringUtils.isNotBlank(suppGoods.getBuyoutSettlementEntityCode())) {
					SuppSettlementEntities buyoutSettlementEntity = suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(suppGoods.getBuyoutSettlementEntityCode());
					suppGoods.setBuyoutSettlementEntity(buyoutSettlementEntity);
				}
				
				// 分公司
				model.addAttribute("filialeList",
						CommEnumSet.FILIALE_NAME.values());
				// BU
				model.addAttribute("buList", bizBuEnumClientService.getAllBizBuEnumList().getReturnContent());
				// 商品类型
				model.addAttribute("goodsTypeList",
						SuppGoods.GOODSTYPE.values());
				// 商品价格类型
				model.addAttribute("priceTypeList",
						SuppGoods.PRICETYPE.values());
				// 寄件方
				model.addAttribute("expressTypeList",
						SuppGoods.EXPRESSTYPE.values());
				// 通知方式
				model.addAttribute("noticeTypeList",
						SuppGoods.NOTICETYPE.values());
				if(pp!=null)
				model.addAttribute("categoryId", pp.getBizCategoryId());
				
				//是否可分销
				Map<String,Object> params = new HashMap<String,Object>();
				params.put("productId", suppGoods.getProductId());
				List<DistDistributorProd> ddpList = null;
				ddpList = MiscUtils.autoUnboxing(distDistributorProdService.findDistDistributorProdByParams(params));
				suppGoods.setDistributeFlag("N");
				suppGoods.setLvmamaFlag("N");
				if(ddpList!=null && ddpList.size() > 0){
					suppGoods.setDistributeFlag("Y");
					for(DistDistributorProd ddp : ddpList){
							if(ddp.getDistributorId()==2L||ddp.getDistributorId()==3L){
								suppGoods.setLvmamaFlag("Y");
							}
					}
				}
				
				if (null != suppGoods.getSuppSupplier() && null != req.getParameter("categoryId")) {
					Map<String, Object> paramSuppFax = new HashMap<String, Object>();
					paramSuppFax.put("supplierId",
							Long.valueOf(req.getParameter("supplierId")));
					paramSuppFax.put("categoryId",
							Long.valueOf(req.getParameter("categoryId")));
					paramSuppFax.put("cancelFlag", "Y");// 有效定义
					List<SuppFaxRule> suppFaxRuleList = MiscUtils.autoUnboxing(suppFaxService
							.findSuppFaxRuleList(paramSuppFax));
					model.addAttribute("suppFaxRuleList", suppFaxRuleList);
				}
				model.addAttribute("currencyTypeList", SuppGoods.CURRENCYTYPE.values());
				model.addAttribute("suppGoods", suppGoods);
				model.addAttribute("branchName", prodProductBranch.getBranchName());
				model.addAttribute("groupId", req.getParameter("groupId"));
			}
		}
		return "/goods/tour/goods/showUpdateSuppGoods";
	}
	
    /**
     * 更新成人、儿童、房差商品
     */
    @RequestMapping(value = "/updateSuppGoods")
    @ResponseBody
    public Object updateSuppGoods(SuppGoods suppGoods) throws BusinessException {
        if (LOG.isDebugEnabled()) {
            LOG.debug("start method<updateSuppGoods>");
        }

        if (suppGoods != null) {
            SuppGoods oldSuppGoods =MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoods.getSuppGoodsId()));
            if(oldSuppGoods == null){
                return ResultMessage.ERROR;
            }
            if(oldSuppGoods.getMinQuantity()!=null && oldSuppGoods.getMaxQuantity()!=null 
            		&& (oldSuppGoods.getMinQuantity() !=suppGoods.getMinQuantity() || oldSuppGoods.getMaxQuantity()!=suppGoods.getMaxQuantity())){
            	ProdProductParam param = new ProdProductParam();
    			param.setBizCategory(true);
            	ResultHandleT<ProdProduct>	prodProductResult = prodProductService.findProdProductById(suppGoods.getProductId(),param);
            	if(prodProductResult!=null && prodProductResult.getReturnContent()!=null &&prodProductResult.isSuccess()){
            		ProdProduct prodProduct =prodProductResult.getReturnContent();
            		if("SUPPLIER".equals(prodProduct.getPackageType()) &&
            				(prodProduct.getBizCategoryId() == 15L|| prodProduct.getBizCategoryId()==17L || prodProduct.getBizCategoryId()==18L)){
            			//跟团游，自由行，酒店套餐 供应商打包
            			//最小，最大订购数修改，触发价格计算
                    	this.calInset(oldSuppGoods);
            		}
            	}
            }
            oldSuppGoods.setMinQuantity(suppGoods.getMinQuantity());
            oldSuppGoods.setMaxQuantity(suppGoods.getMaxQuantity());
            oldSuppGoods.setPriceType(suppGoods.getPriceType());
            oldSuppGoods.setAdult(suppGoods.getAdult());
            oldSuppGoods.setChild(suppGoods.getChild());
            oldSuppGoods.setSenisitiveFlag(suppGoods.getSenisitiveFlag());
            if (null != suppGoods.getGoodsType()) {
                oldSuppGoods.setGoodsType(suppGoods.getGoodsType());
                oldSuppGoods.setExpressType(suppGoods.getExpressType());
                oldSuppGoods.setNoticeType(suppGoods.getNoticeType());
            }
            //传真备注
            oldSuppGoods.setFaxRemark(suppGoods.getFaxRemark());
            suppGoods.setStockApiFlag(oldSuppGoods.getStockApiFlag());
            suppGoods.setApiFlag(oldSuppGoods.getApiFlag());
//            //更新结算对象
//			oldSuppGoods.setBuyoutSettlementEntityCode(suppGoods.getBuyoutSettlementEntityCode());
//			oldSuppGoods.setSettlementEntityCode(suppGoods.getSettlementEntityCode());
            suppGoodsService.updateSuppGoods(oldSuppGoods);

            //更改主商品将同步更新所有附加升级以及商品基础信息的结算对象
//			try {
//				if (oldSuppGoods.getProductBranchId() != null) {
//                    ProdProductBranch productBranch = MiscUtils.autoUnboxing(prodProductBranchService.findProdProductBranchById(oldSuppGoods.getProductBranchId()));
//					if (productBranch == null) {
//						LOG.info("prodProductBranchService method<findProdProductBranchById> result null");
//						return ResultMessage.UPDATE_SUCCESS_RESULT;
//					}
//					BizBranch branch =  MiscUtils.autoUnboxing(branchService.findBranchById(productBranch.getBranchId()));
//					if("adult_child_diff".equalsIgnoreCase(branch.getBranchCode()) && "Y".equalsIgnoreCase(branch.getAttachFlag())){
//						//是主商品，执行同步更新其他商品操作
//						List<SuppGoods> suppGoodsList = MiscUtils.autoUnboxing(suppGoodsService.listSuppGoodsByProductId(oldSuppGoods.getProductId()));
//						if (CollectionUtils.isNotEmpty(suppGoodsList)) {
//							for (SuppGoods goods : suppGoodsList) {
//								if (goods.getProductBranchId() == oldSuppGoods.getProductBranchId()) {
//									continue;
//								}
//								goods.setBuyoutSettlementEntityCode(oldSuppGoods.getBuyoutSettlementEntityCode());
//								goods.setSettlementEntityCode(oldSuppGoods.getSettlementEntityCode());
//								suppGoodsService.updateSuppGoods(goods);
//							}
//						}
//					}
//
//
//                }
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
			return ResultMessage.UPDATE_SUCCESS_RESULT;
        }
        return ResultMessage.ERROR;
    }
	
	
	/**
	 * 调转到产品查询页面
	 */
	@RequestMapping(value = "/showSuppGoodsSaleProductList")
	public String showSuppGoodsSaleProductList(Model model,Integer page , Long productId,Long categoryId,String productName,HttpServletRequest req){
        boolean  addLocal=true;
		 ProdProductParam param = new ProdProductParam();
         param.setActivity(true);
         param.setComPhoto(true);
         param.setFeature(true);
         param.setViewSpot(true);
         param.setServiceRe(true);
         param.setHotelCombFlag(true);//用来判断酒店套餐，如果没有，不进行判断
         param.setLineRoute(true);//加载行程的东西
         param.setDest(true);
         param.setBizDistrict(true);
         param.setTraffic(true);
         param.setAddtion(true);
         param.setProdEcontract(true);
         //判断是否是当地游品类的
         boolean isLocalCategory = false;
         ResultHandleT<ProdProduct> productHandleT = prodProductClientRemote.findLineProductByProductId(productId, param);
         if(productHandleT == null || productHandleT.getReturnContent() == null || ( "Y".equalsIgnoreCase(productHandleT.getReturnContent().getPackageFlag()))){
             LOG.error("LineProductAction showLineProduct error, productHandleT is null. prodProductId is " + productId);
             LOG.error("LineProductAction showLineProduct error, productHandleT return msg is " + productHandleT.getMsg());
       		addLocal=false;
         	model.addAttribute("addLocal", addLocal);
         	model.addAttribute("isLocalCategory", isLocalCategory);
    		return "/goods/tour/goodsSaleRe/showFindProductBranchList";
         	
         }
         ProdProduct prodProduct = productHandleT.getReturnContent();
         if(prodProduct == null ){
             LOG.error("LineProductAction showLineProduct error, prodProduct is null. prodProductId is " + productId);
             LOG.error("LineProductAction showLineProduct error, productHandleT return msg is " + productHandleT.getMsg());
       		addLocal=false;
          	model.addAttribute("addLocal", addLocal);
          	model.addAttribute("isLocalCategory", isLocalCategory);
    		return "/goods/tour/goodsSaleRe/showFindProductBranchList";
         }
      	boolean isDestinationBU = ProductPreorderUtil.isDestinationBUDetail(prodProduct);
      	if (isDestinationBU || 16L==prodProduct.getBizCategoryId()) {
      		if(16L==prodProduct.getBizCategoryId()){
      			isLocalCategory = true;
      		}
      		addLocal=false;
		}
      	model.addAttribute("oldProductId",productId);
      	model.addAttribute("addLocal", addLocal);
      	model.addAttribute("isLocalCategory", isLocalCategory);
		return "/goods/tour/goodsSaleRe/showFindProductBranchList";
	}
	
	
	/**
	 * 产品的关联销售查询
	 * @throws Exception 
	 */
	@RequestMapping(value = "/suppGoodsSaleProductList")
	public String suppGoodsSaleProductList(Model model,Integer page , Long productId,Long categoryId,String productName,Long oldProductId,
			Long productBranchId, String branchName,HttpServletRequest req) throws Exception{
		
		//无查询条件
//		if(categoryId==null){
//			return "/goods/tour/goodsSaleRe/findProductBranchList";
//		}
		model.addAttribute("branchName",branchName);
		model.addAttribute("productBranchId",productBranchId);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productName", productName);
		params.put("productId", productId);
		params.put("categoryId", categoryId);
		params.put("forSaleRelation", "Y");
		params.put("branchName", branchName);
		if(productBranchId != null){
			List<Long> productBranchIdList = new ArrayList<Long>();
			productBranchIdList.add(productBranchId);
			params.put("productBranchIdList", productBranchIdList);
		}
		if (BizEnum.BIZ_CATEGORY_TYPE.category_route_local.getCategoryId().equals(categoryId)) {
			params.put("attachFlag", "Y");
			//暂时隐藏标记
		//	model.addAttribute("hiddenFlag", "N");
		}else{
		//	model.addAttribute("hiddenFlag", "Y");
		}
		int counts =0;
		//查询总行数
		if(BizEnum.BIZ_CATEGORY_TYPE.category_visa.getCategoryId().equals(categoryId)){
			counts = visaProdProductBranchServiceRemote.findProdProductBranchCount(params).getReturnContent();
			model.addAttribute("hiddenFlag", "Y");
		}else{
			counts = prodProductBranchAdapterService.findProdProductBranchCount(params);
			model.addAttribute("hiddenFlag", "N");
		}
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(counts,10, pagenum);
		pageParam.buildJSONUrl(req);
		params.put("_start", pageParam.getStartRows());
		params.put("_end", pageParam.getEndRows());
		List<ProdProductBranch> productBranchList = new ArrayList<ProdProductBranch>();
		List<ProdProductBranch> tmpProductBranchList = null;
		if(BizEnum.BIZ_CATEGORY_TYPE.category_visa.getCategoryId().equals(categoryId)){
			params.put("_start",pageParam.getStartRowsMySql());
			params.put("_end",pageParam.getPageSize());
			String returnContent = visaProdProductBranchServiceRemote.findProdProductBranchList(params).getReturnContent();
			tmpProductBranchList = JSONObject.parseObject(returnContent,new TypeReference<ArrayList<ProdProductBranch>>(){});
		}else{
			tmpProductBranchList = prodProductBranchAdapterService.findProdProductBranchList(params);
		}
		ProdProductParam ppp = new ProdProductParam();
		ppp.setBizCategory(true);
		ppp.setProdLineRoute(true);
		if(tmpProductBranchList!=null && tmpProductBranchList.size()>0){
			List<Long> branchIds =new ArrayList<Long>();
			HashMap<String,Object> params2 = new HashMap<String,Object>();
			params2.put("productId", oldProductId);
			List<ProdProductSaleRelation> saleRelationList = suppGoodsSaleReService.selectProdProductSaleRelationByParams(params2);
			for(ProdProductSaleRelation psr :saleRelationList){
				if(psr.getSuppGoodsSaleRe()!=null && psr.getSuppGoodsSaleRe().getReBranchId()!=null){
					branchIds.add(psr.getSuppGoodsSaleRe().getReBranchId());
				}
			}
			for(ProdProductBranch ppb : tmpProductBranchList){
				//隐藏已经被打包的规格
				Boolean flag =false;
				if(branchIds!=null && branchIds.size()>0){
					for(Long id:branchIds){
						if(ppb.getProductBranchId().longValue()==id.longValue()){
							flag=true;
							break;
						}
					}
				}
				if(flag){
					continue;
				}
				BizBranch branch;
				if(BizEnum.BIZ_CATEGORY_TYPE.category_visa.getCategoryId().equals(categoryId)){
					String prodProductStr = visaProdProductServiceRemote.findProdProductById(ppb.getProductId()).getReturnContent();
					ppb.setProduct(JSONObject.parseObject(prodProductStr,ProdProduct.class));
					String branchStr = visaBranchServiceRemote.findBranchById(ppb.getBranchId()).getReturnContent();
					branch = JSONObject.parseObject(branchStr,BizBranch.class);
				}else{
					ppb.setProduct(prodProductHotelAdapterService.findProdProductByIdAndParam(ppb.getProductId(), ppp));
					branch =MiscUtils.autoUnboxing(branchService.findBranchById(ppb.getBranchId()));
				}
				if(branch!=null && "Y".equalsIgnoreCase(branch.getAttachFlag())){
					productBranchList.add(ppb);
				}
				//商品信息
				Map<String, Object> goodsParams = new HashMap<String, Object>();
				goodsParams.put("productBranchId", ppb.getProductBranchId());
//				if(params.get("suppGoodsName")!=null && params.get("suppGoodsName")!="") {
//					goodsParams.put("goodsName", params.get("suppGoodsName"));
//				}
//				if(params.get("supplierName")!=null && params.get("supplierName")!="") {
//					goodsParams.put("supplierName", params.get("supplierName"));
//				}
//				if(params.get("suppGoodsId")!=null && params.get("suppGoodsId")!="") {
//					goodsParams.put("suppGoodsId", params.get("suppGoodsId"));
//				}
				List<SuppGoods> goodsList = new ArrayList<SuppGoods>();
				if (!goodsParams.isEmpty()) {
					//获取查询条件下该商品规格下的所有满足条件的酒店商品(不分页商品)
					List<ProdProductGoodsBranchData> hotelGoodsList2 = prodHotelGroupPackGoodslAdapterService.selectBranchGoodsByParams(goodsParams);
					if (CollectionUtils.isNotEmpty(hotelGoodsList2)) {
						for (ProdProductGoodsBranchData data : hotelGoodsList2) {
							SuppGoods goods = new SuppGoods();
							goods.setSuppGoodsId(data.getSuppGoodsId());
							goods.setGoodsName(data.getGoodsName());
							goods.setOnlineFlag(data.getOnlineFlag());
							//供应商信息
							goods.setSupplierId(data.getSupplierId());
							goods.setSupplierName(data.getSupplierName());
							goods.setAperiodicFlag(data.getAperiodicFlag());
							goodsList.add(goods);
						}
					}
				}
				ppb.setSuppGoodsList(goodsList);
			}
		}
		if(BizEnum.BIZ_CATEGORY_TYPE.category_single_ticket.getCategoryId().equals(categoryId)
				||BizEnum.BIZ_CATEGORY_TYPE.category_other_ticket.getCategoryId().equals(categoryId)
				||BizEnum.BIZ_CATEGORY_TYPE.category_comb_ticket.getCategoryId().equals(categoryId) 
				||BizEnum.BIZ_CATEGORY_TYPE.category_show_ticket.getCategoryId().equals(categoryId)){
			ProdProduct prodProduct = MiscUtils.autoUnboxing( prodProductService.getProdProductBy(oldProductId) );
			if(prodProduct != null &&  Constant.BU_NAME.DESTINATION_BU.getCode().equalsIgnoreCase(prodProduct.getBu())){
				model.addAttribute("isDestinationBU", "Y");
			}
		}
		pageParam.setItems(productBranchList);
		model.addAttribute("pageParam", pageParam);
		return "/goods/tour/goodsSaleRe/findProductBranchList";
	}
	
	/**
	 * 产品的关联销售列表
	 */
	@RequestMapping(value = "/findGoodsSaleReList")
	public String suppGoodsSaleReList(Model model , Long prodProductId,Long categoryId){
		HashMap<String,Object> params = new HashMap<String,Object>();
		params.put("productId", prodProductId);
		List<ProdProductSaleRelation> saleRelationList = suppGoodsSaleReService.selectProdProductSaleRelationByParams(params);
		if(saleRelationList!=null && saleRelationList.size()>0){
			//排序
			ProdProductSaleRelation array[] = new ProdProductSaleRelation[saleRelationList.size()];
			 saleRelationList.toArray(array);
			for(int i=0;i<array.length-1;i++){
				for(int j=i+1;j<array.length;j++){
					ProdProductSaleRelation tempj = array[j];
					ProdProductSaleRelation tempi = array[i];
					if(tempj.getProduct().getBizCategoryId() < tempi.getProduct().getBizCategoryId()){
						/*ProdProductSaleRelation temp = tempj;
						tempj = tempi;
						tempi = temp;
						*/
						ProdProductSaleRelation temp = tempi;
						array[i]=tempj;
						array[j]=temp;
						
					}
				}
			}
			saleRelationList = Arrays.asList(array);
		}
		model.addAttribute("prodProductId", prodProductId);
		model.addAttribute("saleRelationList", saleRelationList);
		model.addAttribute("categoryId",categoryId);
		return "/goods/tour/goodsSaleRe/findGoodsSaleReList";
	}
	
	/**
	 * 选择设置价格
	 */
	@RequestMapping(value = "/openGoodsSaleRe")
	public String openGoodsSaleRe(Model model , HttpServletRequest request,Long mainProductId){
		if(mainProductId==null)
			throw new BusinessException("没有主产品ID");
		//判断是否含有交通接驳品类去掉任选
		String hasConnects = "N";
		String[] productBranchIds = request.getParameterValues("productBranchIds");
		String suppGoodsIds = request.getParameter("suppGoodsIds");
		String[] suppGoodsIddArr = null;
		if(StringUtil.isNotEmptyString(suppGoodsIds)){
			suppGoodsIddArr = suppGoodsIds.split(";");
			if (productBranchIds==null||productBranchIds!=null && productBranchIds.length != suppGoodsIddArr.length) {
				throw new BusinessException("后台参数获取错误，原因：规格信息数组与商品信息数组大小不相等！");
			}
		}
		List<ProdProductSaleRelation> saleRelationList = new ArrayList<ProdProductSaleRelation>();
		if(productBranchIds!=null && productBranchIds.length>0 && suppGoodsIddArr!=null &&suppGoodsIddArr.length>0){
			int i = 0;
			for(String id : productBranchIds){
				SuppGoodsSaleRe  sgs = new SuppGoodsSaleRe();
				sgs.setProductId(mainProductId);
				sgs.setReBranchId(Long.valueOf(id));
				sgs.setSuppGoodsIdStr(suppGoodsIddArr[i]);
				ProdProductSaleRelation prodProductSaleRelation= suppGoodsSaleReService.selectSaleRelationByBranchIdSGId(sgs);
				if(prodProductSaleRelation!=null && prodProductSaleRelation.getCategory()!=null &&
					BizEnum.BIZ_CATEGORY_TYPE.category_connects.getCategoryId().equals(prodProductSaleRelation.getCategory().getCategoryId())){
					hasConnects = "Y";
				}
				saleRelationList.add(prodProductSaleRelation);
				i++;
			}
		}
		model.addAttribute("mainProductId",mainProductId);
		model.addAttribute("saleRelationList",saleRelationList);
		model.addAttribute("hasConnects",hasConnects);
		return "/goods/tour/goodsSaleRe/updateSalRe";
	}
	
	/**
	 * 更新关联销售
	 */
	@RequestMapping(value = "/updateGoodsSaleRe")
	@ResponseBody
	public String updateGoodsSaleRe(Model model , HttpServletRequest request,String reType){
		String[] reIds = request.getParameterValues("reIds");
		String[] routeNum = request.getParameterValues("routeNum");
		String[] suppGoodsIds = request.getParameterValues("suppGoodsIds");
		String[] productBranchIds = request.getParameterValues("productBranchIds");
		String  ProductId = request.getParameter("mainProductId");
		Long mainProductId =0L;
		if(StringUtil.isNotEmptyString(ProductId)){
			 mainProductId = Long.valueOf(request.getParameter("mainProductId"));
		}
		StringBuffer sb = new StringBuffer();
		if(routeNum != null && routeNum.length != 0){
			for(String num : routeNum){
				sb.append(num).append(",");
			}
		}
		if(mainProductId!=0L){
			//保存操作
			if(suppGoodsIds!=null && suppGoodsIds.length>0 && productBranchIds!=null && productBranchIds.length>0){
				if (suppGoodsIds.length != productBranchIds.length) {
					throw new BusinessException("后台参数获取错误，原因：规格信息数组与商品信息数组大小不相等！");
				}
				
				int i = 0;
				for(String id : productBranchIds){
					SuppGoodsSaleRe  sgs = new SuppGoodsSaleRe();
					sgs.setProductId(mainProductId);
					sgs.setReBranchId(Long.valueOf(id));
					sgs.setSuppGoodsIdStr(suppGoodsIds[i]);
					sgs.setReType(reType);
					if(sb.length() != 0){
						sgs.setLimitDays(sb.toString().substring(0, sb.toString().length() - 1));
					}
					if(suppGoodsSaleReService.insert(sgs)!=1){
						throw new BusinessException("保存失败");
					}
					i++;
				}
				//设置关联产品ID
				//新增操作 记录日志
				StringBuilder logIds = new StringBuilder("关联产品规格ID:[");
				i = 0;
				for(String id : productBranchIds){
				    logIds.append(" ").append(id);
				    logIds.append("：商品ID{").append(suppGoodsIds[i]).append("}");
				    i++;
				}
				logIds.append("]");
				//设置日志
				try {
					comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_RELATION, 
							mainProductId, mainProductId, 
							this.getLoginUser().getUserName(), 
							"增加关联销售"+logIds.toString(), 
							COM_LOG_LOG_TYPE.PROD_PRODUCT_RELATION.name(), 
							"增加关联销售",null);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
					log.error(e.getMessage());
				}
				return ResultMessage.SUCCESS;
			}else{
				throw new BusinessException("后台参数获取错误，原因：规格信息数组或商品信息数组值为空！");
			}
		}else{
			//更新操作
			for(String id : reIds){
				SuppGoodsSaleRe sgsr = new SuppGoodsSaleRe();
				sgsr.setReId(Long.valueOf(id));
				sgsr.setReType(reType);
				if(sb.length() != 0){
					sgsr.setLimitDays(sb.toString().substring(0, sb.toString().length() - 1));
				}
				int rs = suppGoodsSaleReService.updateByPrimaryKey(sgsr);
				if(rs!=1)
					throw new BusinessException("更新失败");
			}
			return ResultMessage.SUCCESS;
		}
		
		
	}
	/**
	 * 更新关联销售
	 */
	@RequestMapping(value = "/toUpdateGoodsSaleRe")
	public String toGoodsSaleRe(Model model , HttpServletRequest request,Long reId,Long productId,String categoryId){
		if(reId==null)
			throw new BusinessException("没有关联关系ID");
		List<ProdProductSaleRelation> saleRelationList = new ArrayList<ProdProductSaleRelation>();
		model.addAttribute("saleRelationList",saleRelationList);
		
		SuppGoodsSaleRe goodsSaleRe = suppGoodsSaleReService.selectByPrimaryKey(reId);
		if(goodsSaleRe.getLimitDays() != null && !goodsSaleRe.getLimitDays().equals("")){
			List<Object> limitDayList = new ArrayList<Object>();
			for(String limitDay:goodsSaleRe.getLimitDays().split(",")){
				limitDayList.add(limitDay);
			}
			model.addAttribute("limitDayList", limitDayList);  
	        model.addAttribute("limitDays", goodsSaleRe.getLimitDays());
		}
		//判断是否含有交通接驳品类去掉任选
		String hasConnects = "N";
		ProdProductSaleRelation prodProductSaleRelation= suppGoodsSaleReService.selectSaleRelationById(goodsSaleRe.getReId());
		if(prodProductSaleRelation!=null && prodProductSaleRelation.getCategory()!=null &&
				BizEnum.BIZ_CATEGORY_TYPE.category_connects.getCategoryId().equals(prodProductSaleRelation.getCategory().getCategoryId())){
			hasConnects = "Y";
		}
		saleRelationList.add(prodProductSaleRelation);
		model.addAttribute("hasConnects",hasConnects);
		//根据产品id获取行程天数
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productId", productId);
		List<ProdLineRoute> prodLineRouteList = prodLineRouteService.findProdLineRouteByParams(params);
		
		List<Short> routeNumlist = new ArrayList<Short>();
		for(ProdLineRoute route :prodLineRouteList){
			routeNumlist.add(route.getRouteNum());
		}
		Collections.sort(routeNumlist,Collections.reverseOrder());
		for(Short routeNum:routeNumlist){
			model.addAttribute("routeNum", routeNum);
			break;
		}
		
		if(productId != null) {
			ProdProduct productProuct =MiscUtils.autoUnboxing(prodProductService.getProdProductBy(productId));
			model.addAttribute("mainProductProuct", productProuct);
		}
		
		model.addAttribute("categoryId", categoryId);
		return "/goods/tour/goodsSaleRe/updateSalRe";
	}
	
	
	/**
	 * 删除关联销售
	 */
	@RequestMapping(value = "/deleteGoodsSaleRe")
	@ResponseBody
	public String deleteGoodsSaleRe(Model model , HttpServletRequest request,Long reId,Long prodProductId){
		if(reId==null)
			throw new BusinessException("没有关联关系ID");
		
		ProdProductSaleRelation prodProductSaleRelation=suppGoodsSaleReService.selectSaleRelationById(reId);
		ProdProduct prodProduct =prodProductSaleRelation.getProduct();
		ProdProductBranch productBranch=prodProductSaleRelation.getProductBranch();
		StringBuffer logContent=new StringBuffer();
		logContent.append(",产品类型id:").append(prodProduct.getBizCategoryId()).append(",产品id:").append(prodProduct.getProductId());
		logContent.append(",产品名称：").append(prodProduct.getProductName()).append(",规格id:").append(productBranch.getProductBranchId()).append(",规格：").append(productBranch.getBranchName());
		
		
		suppGoodsSaleReService.deleteByPrimaryKey(reId);
		suppGoodsSaleReDetailService.deleteByReId(reId);
		try {
			comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_RELATION, 
					prodProductId, prodProductId, 
					this.getLoginUser().getUserName(), 
					"删除关联销售id："+reId+logContent, 
					COM_LOG_LOG_TYPE.PROD_PRODUCT_RELATION.name(), 
					"增加关联销售",null);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
			log.error(e.getMessage());
		}	
		return ResultMessage.SUCCESS;
	}
	
	
	private String getSuppGoodsSaveLog(SuppGoods newSuppGoods){
		 StringBuffer logStr = new StringBuffer("");
		 if(null!= newSuppGoods)
		 {
			 logStr.append(ComLogUtil.getLogTxt("基础商品", "基础商品", ""));
			 logStr.append(ComLogUtil.getLogTxt("是否有效","Y".equals(newSuppGoods.getCancelFlag())?"是":"否",""));
			 //内容维护人员
			Long contentManagerId = newSuppGoods.getContentManagerId();
			if (contentManagerId!=null) {
				PermUser user = permUserServiceAdapter.getPermUserByUserId(contentManagerId);
				 logStr.append(ComLogUtil.getLogTxt("内容维护人员",user.getRealName(),""));
			 }
			 logStr.append(ComLogUtil.getLogTxt("产品经理",newSuppGoods.getManagerName(),""));
			 //商品合同
			 logStr.append(ComLogUtil.getLogTxt("商品合同",newSuppGoods.getSuppContract().getContractName(),""));

			 // 结算对象日志
			 String settleEntityLogText = null;
			 String buyoutSttleEntityLogText = null;
			 if(StringUtils.isNotEmpty(newSuppGoods.getSettlementEntityCode())){
				 SuppSettlementEntities settlementEntity = suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(newSuppGoods.getSettlementEntityCode());
				 if(null!=settlementEntity){
					 settleEntityLogText = " ; 【 绑定结算对象 】："+settlementEntity.getName()+" , 【  绑定结算对象CODE 】"+settlementEntity.getCode();
				 }else{
					 settleEntityLogText = " ; 【 未找到可绑定结算对象 】";
				 }
			 }
			 if(StringUtils.isNotEmpty(newSuppGoods.getBuyoutSettlementEntityCode())){
				 SuppSettlementEntities buyoutSettlementEntity = suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(newSuppGoods.getBuyoutSettlementEntityCode());
				 if(null!=buyoutSettlementEntity){
					 buyoutSttleEntityLogText = " ; 【 绑定买断结算对象 】："+buyoutSettlementEntity.getName()+" , 【  绑定买断结算对象CODE 】"+buyoutSettlementEntity.getCode();
				 }else{
					 buyoutSttleEntityLogText = " ; 【 未找到可绑定买断结算对象 】";
				 }
			 }
			 if(StringUtils.isEmpty(newSuppGoods.getBuyoutSettlementEntityCode()) && StringUtils.isEmpty(newSuppGoods.getSettlementEntityCode())){
				 settleEntityLogText = "; 【 绑定结算对象CODE 为空，无法绑定 】";
			 }
			 logStr.append(settleEntityLogText);
			 logStr.append(buyoutSttleEntityLogText);

			 logStr.append(ComLogUtil.getLogTxt("支付对象",SuppGoods.PAYTARGET.getCnName(newSuppGoods.getPayTarget()),""));
			 logStr.append(ComLogUtil.getLogTxt("分公司",CommEnumSet.FILIALE_NAME.getCnName(newSuppGoods.getFiliale()),""));
			 if(newSuppGoods.getBu() != null){
				 logStr.append(ComLogUtil.getLogTxt("BU",bizBuEnumClientService.getBizBuEnumByBuCode(newSuppGoods.getBu()).getReturnContent().getCnName(),""));
			 }
			 if(newSuppGoods.getAttributionName() != null){
				 logStr.append(ComLogUtil.getLogTxt("归属地",newSuppGoods.getAttributionName(),""));
			 }
			 logStr.append(ComLogUtil.getLogTxt("是否使用传真","Y".equals(newSuppGoods.getFaxFlag())?"是":"否",null));
			 logStr.append(ComLogUtil.getLogTxt("币种",SuppGoods.CURRENCYTYPE.getCnName(newSuppGoods.getCurrencyType()),""));
		 }
		 return logStr.toString();
	 }
	
	private String getSuppGoodsChangeLog(SuppGoods oldSuppGoods,SuppGoods newSuppGoods){
		 StringBuffer logStr = new StringBuffer("");
		 if(null!= newSuppGoods)
		 {
			 logStr.append(ComLogUtil.getLogTxt("商品名称",newSuppGoods.getGoodsName(),oldSuppGoods.getGoodsName()));
			 //所有字段增加去空判断
			 if(newSuppGoods.getCancelFlag() != null){
				 if(!newSuppGoods.getCancelFlag().equals(oldSuppGoods.getCancelFlag())) {
	                 logStr.append(ComLogUtil.getLogTxt("是否有效", "Y".equals(newSuppGoods.getCancelFlag()) ? "是" : "否", "Y".equals(oldSuppGoods.getCancelFlag()) ? "是" : "否"));
	             } 
			 }
             if(newSuppGoods.getContentManagerId() != null){
            	//内容维护人员
    			 if(!newSuppGoods.getContentManagerId().equals(oldSuppGoods.getContentManagerId())){
    			
    					Long contentManagerId = oldSuppGoods.getContentManagerId();
    					if (contentManagerId!=null) {
    						PermUser user = permUserServiceAdapter.getPermUserByUserId(contentManagerId);
    						 logStr.append(ComLogUtil.getLogTxt("内容维护人员",newSuppGoods.getContentManagerName(),user.getRealName()));
    					}
    			 } 
             }
			 
             if(newSuppGoods.getManagerName() != null){
            	 if(!newSuppGoods.getManagerName().equals(oldSuppGoods.getManagerName())){
                     logStr.append(ComLogUtil.getLogTxt("产品经理",newSuppGoods.getManagerName(),oldSuppGoods.getManagerName()));
                 }
             }
             
             if(newSuppGoods.getPackageFlag() != null){
	             if(!newSuppGoods.getPackageFlag().equals(oldSuppGoods.getPackageFlag())){
	            	 logStr.append(ComLogUtil.getLogTxt("是否仅组合销售","Y".equals(newSuppGoods.getPackageFlag())?"是":"否","Y".equals(oldSuppGoods.getPackageFlag())?"是":"否"));
	             }
             }
			 
             if(newSuppGoods.getContractId() != null){
            	//商品合同
    			 if(!newSuppGoods.getContractId().equals(oldSuppGoods.getContractId())){
    				 logStr.append(ComLogUtil.getLogTxt("商品合同",newSuppGoods.getSuppContract().getContractName(),oldSuppGoods.getSuppContract().getContractName()));
    			 } 
             }

			 // 更改结算对象
			 if(!newSuppGoods.getSettlementEntityCode().equals(oldSuppGoods.getSettlementEntityCode())) {
				 SuppSettlementEntities newSettleEntity = suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(newSuppGoods.getSettlementEntityCode());
				 SuppSettlementEntities oldSettleEntity = suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(oldSuppGoods.getSettlementEntityCode());
				 if (null != newSettleEntity && null != oldSettleEntity) {
					 logStr.append(ComLogUtil.getLogTxt("结算对象", newSettleEntity.getName(), oldSettleEntity.getName()));
					 logStr.append(ComLogUtil.getLogTxt("结算对象CODE", newSuppGoods.getSettlementEntityCode(), oldSuppGoods.getSettlementEntityCode()));
				 }
			 }
			 //增加了结算对象
			 if(StringUtils.isEmpty(oldSuppGoods.getSettlementEntityCode()) && StringUtils.isNotEmpty(newSuppGoods.getSettlementEntityCode())) {
				 SuppSettlementEntities newSettleEntity = suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(newSuppGoods.getSettlementEntityCode());
				 if (null != newSettleEntity) {
					 logStr.append(ComLogUtil.getLogTxt("结算对象", newSettleEntity.getName(),"空"));
					 logStr.append(ComLogUtil.getLogTxt("结算对象CODE", newSuppGoods.getSettlementEntityCode(), "空"));
				 }
			 }
			 //删除了结算对象
			 if(StringUtils.isNotEmpty(oldSuppGoods.getSettlementEntityCode()) && StringUtils.isEmpty(newSuppGoods.getSettlementEntityCode())) {
				 SuppSettlementEntities oldSettleEntity = suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(oldSuppGoods.getSettlementEntityCode());
				 if (null != oldSettleEntity) {
					 logStr.append(ComLogUtil.getLogTxt("结算对象", "空",oldSettleEntity.getName()));
					 logStr.append(ComLogUtil.getLogTxt("结算对象CODE", "空", oldSuppGoods.getSettlementEntityCode()));
				 }
			 }
			 // 更改买断结算对象
			 if(StringUtils.isNotEmpty(oldSuppGoods.getBuyoutSettlementEntityCode()) &&!newSuppGoods.getBuyoutSettlementEntityCode().equals(oldSuppGoods.getBuyoutSettlementEntityCode())) {
				 SuppSettlementEntities newBuyoutSettleEntity = suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(newSuppGoods.getBuyoutSettlementEntityCode());
				 SuppSettlementEntities oldBuyoutSettleEntity = suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(oldSuppGoods.getBuyoutSettlementEntityCode());
				 if (null != newBuyoutSettleEntity && null != oldBuyoutSettleEntity) {
					 logStr.append(ComLogUtil.getLogTxt("买断结算对象", newBuyoutSettleEntity.getName(), oldBuyoutSettleEntity.getName()));
					 logStr.append(ComLogUtil.getLogTxt("买断结算对象CODE", newSuppGoods.getBuyoutSettlementEntityCode(), oldSuppGoods.getBuyoutSettlementEntityCode()));
				 }
			 }
			 //增加了买断结算对象
			 if(StringUtils.isEmpty(oldSuppGoods.getBuyoutSettlementEntityCode()) && StringUtils.isNotEmpty(newSuppGoods.getBuyoutSettlementEntityCode())) {
				 SuppSettlementEntities newBuyoutSettleEntity = suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(newSuppGoods.getBuyoutSettlementEntityCode());
				 if (null != newBuyoutSettleEntity) {
					 logStr.append(ComLogUtil.getLogTxt("买断结算对象", newBuyoutSettleEntity.getName(),"空"));
					 logStr.append(ComLogUtil.getLogTxt("买断结算对象CODE", newSuppGoods.getBuyoutSettlementEntityCode(), "空"));
				 }
			 }
			 //删除了买断结算对象
			 if(StringUtils.isNotEmpty(oldSuppGoods.getBuyoutSettlementEntityCode()) && StringUtils.isEmpty(newSuppGoods.getBuyoutSettlementEntityCode())) {
				 SuppSettlementEntities oldBuyoutSettleEntity = suppSettlementEntitiesService.findSuppSettlementEntitiesByCode(oldSuppGoods.getBuyoutSettlementEntityCode());
				 if (null != oldBuyoutSettleEntity) {
					 logStr.append(ComLogUtil.getLogTxt("买断结算对象", "空",oldBuyoutSettleEntity.getName()));
					 logStr.append(ComLogUtil.getLogTxt("买断结算对象CODE", "空", oldSuppGoods.getBuyoutSettlementEntityCode()));
				 }
			 }

             if(newSuppGoods.getPayTarget() != null){
            	 if(!newSuppGoods.getPayTarget().equals(oldSuppGoods.getPayTarget()))
    			 {
    				 String newValue = "";
    				 String oldValue = "";
    				 newValue = SuppGoods.PAYTARGET.getCnName(newSuppGoods.getPayTarget());
    				 oldValue = SuppGoods.PAYTARGET.getCnName(oldSuppGoods.getPayTarget());
    				 logStr.append(ComLogUtil.getLogTxt("支付对象",newValue,oldValue));
    			 } 
             }
			 
             if(newSuppGoods.getFiliale() != null){
            	 if(!newSuppGoods.getFiliale().equals(oldSuppGoods.getFiliale()))
    			 {
    				 String newValue = "";
    				 String oldValue = "";
    				 newValue = CommEnumSet.FILIALE_NAME.getCnName(newSuppGoods.getFiliale());
    				 oldValue = CommEnumSet.FILIALE_NAME.getCnName(oldSuppGoods.getFiliale());
    				 logStr.append(ComLogUtil.getLogTxt("分公司",newValue,oldValue));
    			 }
             }
			 
             if(newSuppGoods.getBu() != null){
            	//BU
    			 if(!newSuppGoods.getBu().equals(oldSuppGoods.getBu()))
    			 {
    				 String newValue = "";
    				 String oldValue = "";
    				 newValue = bizBuEnumClientService.getBizBuEnumByBuCode(newSuppGoods.getBu()).getReturnContent().getCnName();
    				 if (oldSuppGoods.getBu()!=null && bizBuEnumClientService.getBizBuEnumByBuCode(oldSuppGoods.getBu())!=null) {
    					 oldValue = bizBuEnumClientService.getBizBuEnumByBuCode(oldSuppGoods.getBu()).getReturnContent().getCnName();
    				 }
    				 logStr.append(ComLogUtil.getLogTxt("BU",newValue,oldValue));
    			 }
             }
			 
             if(newSuppGoods.getAttributionId() != null){
            	//归属地
    			 if(newSuppGoods.getAttributionId().compareTo(oldSuppGoods.getAttributionId()) != 0)
    			 {
    				 String oldValue = null;
    				 if(oldSuppGoods.getAttributionId() != null){
    					 Attribution attribution = attributionService.findAttributionById(oldSuppGoods.getAttributionId());
    						if (null != attribution) {
    							oldValue = attribution.getAttributionName();
    						}
    				 }
    				 logStr.append(ComLogUtil.getLogTxt("归属地",newSuppGoods.getAttributionName(),oldValue));
    			 } 
             }
			 
             if(newSuppGoods.getFaxFlag() != null){
            	 //是否使用传真
    			 if(!newSuppGoods.getFaxFlag().equals(oldSuppGoods.getFaxFlag()))
    			 {
    				 logStr.append(ComLogUtil.getLogTxt("是否使用传真","Y".equals(newSuppGoods.getFaxFlag())?"是":"否",null));
    			 } 
             }
			
			 logStr.append(ComLogUtil.getLogTxt("币种",SuppGoods.CURRENCYTYPE.getCnName(newSuppGoods.getCurrencyType()),SuppGoods.CURRENCYTYPE.getCnName(oldSuppGoods.getCurrencyType())));
			 if(newSuppGoods.getAdult() != null){
				//成人数
				 if(newSuppGoods.getAdult().intValue() != oldSuppGoods.getAdult().intValue()){
					 logStr.append(ComLogUtil.getLogTxt("成人数", newSuppGoods.getAdult().toString(), oldSuppGoods.getAdult().toString()));
				 } 
			 }
			 
			 if(newSuppGoods.getChild() != null){
				//儿童数
				 if(newSuppGoods.getChild().intValue() != oldSuppGoods.getChild().intValue()){
					 logStr.append(ComLogUtil.getLogTxt("儿童数", newSuppGoods.getChild().toString(), oldSuppGoods.getChild().toString()));
				 } 
			 }
			 
		 }
		 return logStr.toString();
	 }

	//打开商品查询页面
	@RequestMapping(value = "/showProductGoodsForm.do")
	public String showProductGoodsForm(HttpServletRequest request,
									   HttpServletRequest req, Integer page, Model model) {
		ProdProductBranch prodProductBranch=null;
		String productBranchId = request.getParameter("productBranchId");
		//组产品id
//		String groupProductId = request.getParameter("groupProductId");
		if(productBranchId!=null && productBranchId!="")
		{
			try {
				prodProductBranch =MiscUtils.autoUnboxing(prodProductBranchAdapterService.findProdProductBranchById(Long.valueOf(productBranchId)));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		if(prodProductBranch!=null)
		{
			String branchName = prodProductBranch.getBranchName();
			model.addAttribute("branchName", branchName);
		}
		String categoryId = request.getParameter("categoryId");
		String productId = request.getParameter("productId");
		String reId = request.getParameter("reId");
//		String groupType = request.getParameter("groupType");
//		String productBu = request.getParameter("productBu");
//		model.addAttribute("groupProductId", groupProductId);
		model.addAttribute("productBranchId", productBranchId);
		model.addAttribute("productId", productId);
		model.addAttribute("categoryId", categoryId);
		model.addAttribute("reId", reId);
		model.addAttribute("groupType", salesRouter.getCategoryTypeByCategoryId(Long.valueOf(categoryId)));
//		model.addAttribute("groupType", groupType);
//		model.addAttribute("productBu", productBu);
		return "/goods/tour/goodsSaleRe/selectGoods/showProductGoodsForm";
	}

	@RequestMapping(value = "/showGoodsData.do")
	public String showGoodsData(ProdProductGoodsBranchVO vo, Integer page, HttpServletRequest request, Model model) {
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, Object> districtIdparams = new HashMap<String, Object>();
		ProdProductBranch prodProductBranch=null;
		//用来存放已经打包的商品id
		String suppGoodsIdString= "";
		//用来存放系统逻辑下商品id
		String systemLogicGoodsIdString= "";
		//系统逻辑下商品名称
		String systemLogicGoodsNameString="";
		//用来存放商品名称
		String goodsNameString= "";
		//商品是否打包
		String whetherPackaged="false";
		String productBranchId = request.getParameter("productBranchId");
		if(productBranchId!=null && productBranchId!="")
		{
			try {
				prodProductBranch = MiscUtils.autoUnboxing(prodProductBranchAdapterService.findProdProductBranchById(Long.valueOf(productBranchId)));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		if(prodProductBranch!=null)
		{
			String branchName = prodProductBranch.getBranchName();
			model.addAttribute("branchName", branchName);
		}
		if(vo.getSupplierName()!=null && vo.getSupplierName()!="")
		{
			params.put("supplierName", vo.getSupplierName().trim());
		}
		if(vo.getGoodsName()!=null && vo.getGoodsName()!="")
		{
			params.put("goodsName", vo.getGoodsName().trim());
		}
		if(vo.getSuppGoodsId()!=null )
		{
			params.put("suppGoodsId", vo.getSuppGoodsId());
		}
		if(vo.getDistrictName()!=null && vo.getDistrictName()!="")
		{
			params.put("districtName", vo.getDistrictName().trim());
		}
		if(vo.getOnlineFlag()=="" || vo.getOnlineFlag()==null)
		{
			params.put("onlineFlag",null);
		}
		else
		{
			params.put("onlineFlag",vo.getOnlineFlag());
		}
		String categoryId = request.getParameter("categoryId");
		String productId = request.getParameter("productId");
		String reId = request.getParameter("reId");
		districtIdparams.put("reId",Long.valueOf(reId));
		params.put("productBranchId",Integer.parseInt(productBranchId));
		model.addAttribute("productBranchId", productBranchId);
		model.addAttribute("productId", productId);
		model.addAttribute("categoryId", categoryId);
		model.addAttribute("detailId", reId);
		model.addAttribute("ticketOnlineFlag", categoryId);
		model.addAttribute("onlineFlag", vo.getOnlineFlag());
		model.addAttribute("districtName", vo.getDistrictName());
		model.addAttribute("suppGoodsId", vo.getSuppGoodsId());
		model.addAttribute("goodsName", vo.getGoodsName());
		model.addAttribute("supplierName", vo.getSupplierName());
		// 获取规格下商品总数 todo
		int count = prodHotelGroupPackGoodslAdapterService.getTotalCount(params);
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(request);
		params.put("_start", pageParam.getStartRows());
		params.put("_end", pageParam.getEndRows());
		int systemLogicGoodsNum=0;
		//获取查询条件下该商品规格下的所有满足条件的酒店商品(分页商品)todo
		List<ProdProductGoodsBranchData> hotelGoodsList = prodHotelGroupPackGoodslAdapterService.selectHotelGoodsByParams(params);
		//获取查询条件下该商品规格下的所有满足条件的酒店商品(不分页商品)todo
		List<ProdProductGoodsBranchData> hotelGoodsList2 = prodHotelGroupPackGoodslAdapterService.selectBranchGoodsByParams(params);
		if(CollectionUtils.isNotEmpty(hotelGoodsList2))
		{
			//系统逻辑下商品数量
			int length = hotelGoodsList2.size();
			systemLogicGoodsNum = hotelGoodsList2.size();
			for(int i = 0;i < length; i ++)
			{
				ProdProductGoodsBranchData goodsData= hotelGoodsList2.get(i);
				Long suppGoodsId = goodsData.getSuppGoodsId();
				String goodsName = goodsData.getGoodsName();
				if(i==length-1)
				{

					systemLogicGoodsIdString= systemLogicGoodsIdString+suppGoodsId;
					systemLogicGoodsNameString = systemLogicGoodsNameString + goodsName;
				}
				else if(i<length)
				{
					systemLogicGoodsIdString= systemLogicGoodsIdString+suppGoodsId + ",";
					systemLogicGoodsNameString = systemLogicGoodsNameString + goodsName + ",";
				}
			}

		}
		model.addAttribute("systemLogicGoodsNum",systemLogicGoodsNum);
		model.addAttribute("systemLogicGoodsIdString",systemLogicGoodsIdString);
		model.addAttribute("systemLogicGoodsNameString",systemLogicGoodsNameString);
		//获取查询条件该规格下已经打包商品表中的数据 todo
		List<SuppGoodsSaleReDetail> detailGoodsDataList = suppGoodsSaleReDetailService.selectByParams(districtIdparams);
		if(CollectionUtils.isNotEmpty(detailGoodsDataList))
		{

			int length = detailGoodsDataList.size();
			if(length>0)
			{
				whetherPackaged="true";
			}
			for(int i = 0;i < length; i ++)
			{
				SuppGoodsSaleReDetail goodsData= detailGoodsDataList.get(i);
				if(goodsData != null)
				{
					Long suppGoodsId = goodsData.getSuppGoodsId();
					String cancelFlag = "N";
					String goodsName="";
					if(suppGoodsId != null)
					{
						SuppGoods suppGoods= MiscUtils.autoUnboxing(suppGoodsHotelAdapterService.findSuppGoodsById(suppGoodsId));
						if(suppGoods != null)
						{
							goodsName = suppGoods.getGoodsName();
							cancelFlag = suppGoods.getCancelFlag();
						}
					}
					if(i==length-1)
					{
						//如果已打包商品不可售
						if(cancelFlag !="" & "N".equals(cancelFlag))
						{
							suppGoodsIdString= suppGoodsIdString+suppGoodsId;
							goodsNameString = goodsNameString + goodsName+"【(cancelGoods)】";
						}else
						{
							suppGoodsIdString= suppGoodsIdString+suppGoodsId;
							goodsNameString = goodsNameString + goodsName;
						}

					}
					else if(i<length)
					{
						//如果已打包商品不可售
						if(cancelFlag !="" & "N".equals(cancelFlag))
						{
							suppGoodsIdString= suppGoodsIdString+suppGoodsId+",";
							goodsNameString= goodsNameString+goodsName+"【(cancelGoods)】,";
						}else
						{
							suppGoodsIdString= suppGoodsIdString+suppGoodsId+",";
							goodsNameString= goodsNameString+goodsName+",";
						}
					}
				}
			}
			model.addAttribute("suppGoodsIdString", suppGoodsIdString);
			model.addAttribute("goodsNameString", goodsNameString);
		}
		pageParam.setItems(hotelGoodsList);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("whetherPackaged", whetherPackaged);
		return "/goods/tour/goodsSaleRe/selectGoods/showGoodsData";
	}

	/**
	 * 关联销售到商品
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/addGoodsToBranch")
	@ResponseBody
	public Object addGoodsToBranch(HttpServletRequest request) throws Exception {
		Map<String, Object> attributes = new HashMap<String, Object>();
		Map<String, Object> detailIdparams = new HashMap<String, Object>();
		Long groupId=(long) 0;
		//用来存放已经打包的商品id
		ArrayList<String> packageedSuppGoodsIdList = new ArrayList<String>();
		//用来存放将要打包的商品id
		ArrayList<String> willPackageSuppGoodsIdList = new ArrayList<String>();
		//查询该规格下面已经打包的商品
		List<SuppGoodsSaleReDetail> suppGoodsSaleReDetails=null;
		SuppGoodsSaleRe suppGoodsSaleRe=null;
		String reId = request.getParameter("reId");
		//要打包的酒店商品id
		String values=request.getParameter("key");
		StringBuffer goodsIdString = new StringBuffer();
		JSONArray jsonArray = JSONArray.fromObject(values);
		if(reId==null || reId=="") {
			return new ResultMessage("error", "reId不能为空！");
		}else if(StringUtil.isNotEmptyString(reId)) {
			detailIdparams.put("reId", Long.valueOf(reId));
			suppGoodsSaleReDetails = suppGoodsSaleReDetailService.selectByParams(detailIdparams);
			suppGoodsSaleRe = suppGoodsSaleReService.selectByPrimaryKey(Long.valueOf(reId));
		}
		if(CollectionUtils.isNotEmpty(suppGoodsSaleReDetails)) {
			for(int j = 0 ; j< suppGoodsSaleReDetails.size();j++) {
				SuppGoodsSaleReDetail detailDataBean = suppGoodsSaleReDetails.get(j);
				//数据库中已经绑定的商品id
				if(detailDataBean!=null) {
					Long suppGoodsIdValue = detailDataBean.getSuppGoodsId();
					packageedSuppGoodsIdList.add(String.valueOf(suppGoodsIdValue));
				}
			}
		}
		//通过循环将没有打包的数据打包到自主绑定数据库
		for (int i = 0; i < jsonArray.size(); i++) {
			SuppGoodsSaleReDetail reDetail = new SuppGoodsSaleReDetail();
			//前端页面需要绑定的商品id
			String suppGoodsId = (String) jsonArray.get(i);

			willPackageSuppGoodsIdList.add(suppGoodsId);
			//如何返回true 表示该商品在数据库中已经绑定，  如果返回false则表示数据库中没有绑定该商品
			Boolean result = isInList(suppGoodsId,packageedSuppGoodsIdList);
			//如果数据库中没有绑定该商品则在数据库中进行新增
			if(!result){

				reDetail.setReId(Long.parseLong(reId));
				reDetail.setSuppGoodsId(Long.parseLong(suppGoodsId));
				//商品打包到自主打包数据表
				suppGoodsSaleReDetailService.insert(reDetail);
			}
		}
		//将已经打包但不需要打包的商品在PROD_PACKAGE_DETAIL_GOODS中删除
		if(CollectionUtils.isNotEmpty(packageedSuppGoodsIdList)) {
			for(int k=0;k<packageedSuppGoodsIdList.size();k++) {
				Map<String, Object> paramsValues = new HashMap<String, Object>();
				//数据库中已经打包的商品id
				String suppGoodsBean =packageedSuppGoodsIdList.get(k);
				paramsValues.put("suppGoodsId", suppGoodsBean);
				paramsValues.put("reId", Long.valueOf(reId));
				if(reId!=null && reId!="") {
					Boolean resultValue = isInList(suppGoodsBean,willPackageSuppGoodsIdList);
					if(!resultValue) {
						//将取消打包的商品删除
						suppGoodsSaleReDetailService.deleteByParams(paramsValues);
					}
				}

			}
		}

		//添加操作日志
//		addComLog(detailId,vo,jsonArray);
		attributes.put("reId", Long.valueOf(reId));
//		attributes.put("selectCategoryId", selectCategoryId);
		return new ResultMessage(attributes, "success", "关联商品成功!");
	}

	private Boolean isInList(String str,List<String> list){
		if(list.contains(str)){
			return true;
		}else{
			return false;
		}
	}

	/**
	 * 根据查询值、合同Id、买断标识查询结算对象
	 * @param search 查询值
	 * @param contractId 合同Id
	 * @param buyoutFlag 买断标识, "Y" 买断，"N",非买断
	 * @return 买断或非买断的结算对象list
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/findSettlementEntityList")
	@ResponseBody
	public Object findSettlementEntityList(String searchValue, Long contractId, String buyoutFlag) throws BusinessException {
		if (contractId == null) {
			log.error("contractId is null");
			throw new BusinessException("contractId is null");
		}

		List<SuppSettlementEntities> suppSettlementEntitiesList
				= suppSettlementEntityClientServiceRemote.selectSuppSettlementEntitiesByContractIdAndBuyoutFlag(contractId,buyoutFlag);
		JSONArray entitiesArray = new JSONArray();
		if (CollectionUtils.isEmpty(suppSettlementEntitiesList)) {
			return entitiesArray;
		}
		for (SuppSettlementEntities entity : suppSettlementEntitiesList) {
			String name = entity.getName();
			String code = entity.getCode();
			if (StringUtils.isEmpty(searchValue) || (StringUtils.isNotEmpty(name) && name.contains(searchValue))
					|| (StringUtils.isNotEmpty(code) && code.contains(searchValue))) {
				JSONObject obj = new JSONObject();
				obj.put("id", entity.getId());
				obj.put("name", entity.getName());//结算名称
				obj.put("code", entity.getCode());//结算code
				obj.put("settleType",entity.getSettlementClasification());//结算方式枚举值
				obj.put("bu", entity.getCooperatedBuNostro());//结算合作bu枚举值
				obj.put("text", entity.getName());
				String desc = "结算对象CODE: " + entity.getCode();
				if (StringUtils.isNotEmpty(entity.getCooperatedBuNostro())) {
					desc += ", 合作BU：" + SuppSettlementEntities.CONTRACT_SETTLE_BU.getCnName(entity.getCooperatedBuNostro());
				}
				if(StringUtils.isNotEmpty(entity.getSettlementClasification())){
					desc += ",结算方式：" + SuppSettlementEntities.SETTLEMENT_CLASIFICATION_STATUS.getCnName(entity.getSettlementClasification());
				}
				obj.put("desc", desc);
				entitiesArray.add(obj);
			}
		}
		return entitiesArray;
	}
	
	private void calInset(SuppGoods suppGoods){
		ComCalData comCalData =new ComCalData();
		comCalData.setCategoryId(suppGoods.getCategoryId());
		comCalData.setProdPackageType("SUPPLIER");
		comCalData.setObjectId(suppGoods.getProductId());
		comCalData.setObjectType(ComPush.OBJECT_TYPE.PRODUCT.name());
		comCalData.setDataSouce(ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA.name());
		comCalData.setDataLevel(1);
		comCalData.setPushContent(ComPush.PUSH_CONTENT.SUPP_GOODS.name());
		comCalData.setPushCount(0);
		comCalData.setPushFlag("N");
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(new Date());
		calendar.add(Calendar.MINUTE, 0);
		comCalData.setCreateTime( calendar.getTime());
		try {
			int count = comCalDataService.addComCalData(comCalData);
			log.info("COM_CAL_DATA 插入数据 productId="+suppGoods.getProductId() +" suppGoodsId ="+suppGoods.getSuppGoodsId() +" count ="+count);
		} catch (Exception e) {
			log.error("COM_CAL_DATA 插入失败",e);
		}
		
	}

}
