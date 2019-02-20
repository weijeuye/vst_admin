package com.lvmama.vst.back.prod.web.packageTour;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizBranch;
import com.lvmama.vst.back.biz.po.BizBranchProp;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.po.BizDict;
import com.lvmama.vst.back.biz.po.BizDictProp;
import com.lvmama.vst.back.biz.service.BizBranchQueryService;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.biz.service.BranchPropService;
import com.lvmama.vst.back.client.biz.service.BranchClientService;
import com.lvmama.vst.back.client.biz.service.DictPropClientService;
import com.lvmama.vst.back.biz.service.DictService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.goods.po.SuppGoodsRelation;
import com.lvmama.vst.supp.client.service.SuppGoodsLineTimePriceClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsRelationClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.prod.po.ProdPackageDetail;
import com.lvmama.vst.back.prod.po.ProdPackageGroup;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductBranch;
import com.lvmama.vst.back.prod.po.ProdProductBranchProp;
import com.lvmama.vst.back.prod.po.ProdProductProp;
import com.lvmama.vst.back.client.prod.service.ProdPackageDetailClientService;
import com.lvmama.vst.back.client.prod.service.ProdPackageGroupClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductBranchPropClientService;
import com.lvmama.vst.back.prod.service.ProdProductBranchService;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.prod.vo.PackageTourProductBranchVO;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.pub.service.ComPushClientService;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Constant.PROPERTY_INPUT_TYPE_ENUM;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.pet.goods.PetProdGoodsAdapter;
import com.lvmama.vst.back.utils.MiscUtils;
/**
 * 线路产品规格管理Action
 * 
 */
@Controller
@RequestMapping("/packageTour/prod/prodbranch")
public class PackageTourProdProductBranchAction extends BaseActionSupport {
	/**
	 * 序列
	 */
	private static final long serialVersionUID = 6028072615238721788L;
	
	private static final Log LOG = LogFactory.getLog(PackageTourProdProductBranchAction.class);

	/**
	 * 获得产品规格列表
	 * 
	 * @return
	 */
	@Autowired
	private ProdProductBranchService prodProductBranchService;

	@Autowired
	private BranchPropService branchPropService;

	@Autowired
	private DictService dictService;

	@Autowired
	private ProdProductBranchPropClientService prodProductBranchPropService;

	@Autowired
	private BranchClientService branchService;

	@Autowired
	private ProdProductService prodProductService;

	@Autowired
	private ComLogClientService comLogService;

	@Autowired
	private PetProdGoodsAdapter petProdGoodsAdapter;
	
	@Autowired
	private ComPushClientService comPushService;
	
	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;
	
	@Autowired
	private BizBranchQueryService bizBranchQueryService;
	
	@Autowired
	private SuppGoodsClientService suppGoodsService;
	
	@Autowired
	private SuppGoodsRelationClientService suppGoodsRelationService;
	
	@Autowired
	private ProdPackageGroupClientService prodPackageGroupService;
	
	@Autowired
	private ProdPackageDetailClientService prodPackageDetailService;
	
	@Autowired
	private DictPropClientService dictPropService;

	@Autowired
	private SuppGoodsLineTimePriceClientService suppGoodsLineTimePriceService;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/findProductBranchList.do")
	public String findProductBranchList(Model model, Integer page, Long categoryId, String branchCode, Long productId, Long mainProdBranchId, HttpServletRequest req) throws BusinessException {
		
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("categoryId", categoryId);
		parameters.put("branchCode", branchCode);
		List<BizBranch> branchList = MiscUtils.autoUnboxing(branchService.findBranchListByParams(parameters));
		List<PackageTourProductBranchVO> tourProductBranchVOList;
		
		if(branchList != null && branchList.size() >0 ){
			tourProductBranchVOList = new ArrayList<PackageTourProductBranchVO>();
			
			model.addAttribute("branchId", branchList.get(0).getBranchId());
			parameters.put("branchId", branchList.get(0).getBranchId());
			parameters.put("productId", productId);
			parameters.put("hasProp", Boolean.TRUE);
			parameters.put("hasPropValue", Boolean.TRUE);
			parameters.put("_orderby", "product_branch_id");
			parameters.put("_order", "DESC");
			List<ProdProductBranch> prodProductBranchList = prodProductBranchService.findProdProductBranchList(parameters);
			
			//添加商品和关联关系
			for(ProdProductBranch prodProductBranch : prodProductBranchList){
				PackageTourProductBranchVO packBranchVO = new PackageTourProductBranchVO();
				//获取主商品
				List<SuppGoods> mainGoodsList = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsByBranchId(mainProdBranchId));
				List<SuppGoods> goodsList = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsByBranchId(prodProductBranch.getProductBranchId()));
				
				if(goodsList != null && goodsList.size() > 0){
					BeanUtils.copyProperties(prodProductBranch, packBranchVO);
					packBranchVO.setSuppGoods(goodsList.get(0));
					SuppGoodsRelation suppGoodsRelation = new SuppGoodsRelation();
					suppGoodsRelation.setMainGoodsId(mainGoodsList.get(0).getSuppGoodsId());
					suppGoodsRelation.setSecGoodsId(goodsList.get(0).getSuppGoodsId());
					List<SuppGoodsRelation> goodsRelationlist = suppGoodsRelationService.findAllSuppGoodsRelation(suppGoodsRelation);
					if(goodsRelationlist != null  && goodsRelationlist.size() > 0){
						packBranchVO.setSuppGoodsRelation(goodsRelationlist.get(0));
					}
				}
				if(packBranchVO.getProductBranchId() != null){
					tourProductBranchVOList.add(packBranchVO);
				}
			}
			model.addAttribute("productId", productId);
			model.addAttribute("mainProdBranchId", mainProdBranchId);
			BizCategory bizCategory = bizCategoryQueryService.getCategoryById(categoryId);
			model.addAttribute("bizCategory", bizCategory);
			model.addAttribute("tourProductBranchVOList", tourProductBranchVOList);
			model.addAttribute("branchCode", branchCode);
		}
		
		return "/prod/packageTour/prodbranch/findProductBranchList";
	}
 
	/**
	 * 跳转到修改产品规格页面
	 */
	public void showUpdateProductBranch(Model model, Long productBranchId, Long branchId, Long mainProdBranchId) throws BusinessException {

		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("branchId", branchId);
		params.put("_orderby", "SEQ");
		params.put("productBranchId",productBranchId);
		//查询该规格下面所有的产品规格（包括无效的）
		List<BizBranchProp> branchPropList = branchPropService.findBranchPropsByParams(params);
		
		List<BizBranchProp> branchPropList2 = new ArrayList<BizBranchProp>();
		//设置产品规格属性
		if(branchPropList!=null){
			for(BizBranchProp branchProp : branchPropList){
				params.clear();
				params.put("productBranchId", productBranchId);
				params.put("propId", branchProp.getPropId());
				List<ProdProductBranchProp> prodProductBranchPropList = MiscUtils.autoUnboxing( prodProductBranchPropService.findProdProductBranchPropList(params));
				if(prodProductBranchPropList!=null&&prodProductBranchPropList.size()>0){
					branchProp.setProdProductBranchProp(prodProductBranchPropList.get(0));
				}
				//该处过滤掉无效的规格（如果该规格无效但是已经设置了对应的产品规格，则保留）
				if("Y".equals(branchProp.getCancelFlag())||branchProp.getProdProductBranchProp()!=null){
					branchPropList2.add(branchProp);
				}
			}
		}
		model.addAttribute("addValueTitle", ProdProductProp.PROP_ADD_VALUE_SPLIT);
		model.addAttribute("branchPropList", branchPropList2);
		
		ProdProductBranch prodProductBranch = prodProductBranchService.findProdProductBranchById(productBranchId, Boolean.TRUE, Boolean.TRUE);
		model.addAttribute("productBranch", prodProductBranch);
		
		this.filterDictListByProductId(branchPropList, prodProductBranch.getProductId());
		
		//获取主规格下商品
		List<SuppGoods> mainGoodsList = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsByBranchId(mainProdBranchId));
		if(mainGoodsList != null && mainGoodsList.size() > 0){
			//获取当前产品规格下商品与主规格下商品关联关系
			List<SuppGoods> goodsList = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsByBranchId(productBranchId));
			if(goodsList != null && goodsList.size() > 0){
				SuppGoodsRelation suppGoodsRelation = new SuppGoodsRelation();
				suppGoodsRelation.setSecGoodsId(goodsList.get(0).getSuppGoodsId());
				suppGoodsRelation.setMainGoodsId(mainGoodsList.get(0).getSuppGoodsId());
				List<SuppGoodsRelation> goodsRelationlist = suppGoodsRelationService.findAllSuppGoodsRelation(suppGoodsRelation);
				if(goodsRelationlist != null && goodsRelationlist.size() > 0){
					model.addAttribute("prodBranchRelationType", goodsRelationlist.get(0));
				}
			}
		}
	}

	/**
	 * 跳转到选择有效规格
	 */
	@RequestMapping(value = "/showBranchs.do")
	public String showBranchs(Model model, Long productId, Long categoryId, String categoryCode) throws BusinessException {
		List<BizBranch> branchList = bizBranchQueryService.findBranchListByCategoryId(categoryId);
		model.addAttribute("branchList", branchList);
		model.addAttribute("productId", productId);
		return "/prod/packageTour/prodbranch/showBranchs";
	}

	/**
	 * 跳转到添加产品规格
	 */
	@RequestMapping(value = "/showAddProductBranch.do")
	public String showAddProductBranch(Model model, Long mainProdBranchId, Long productId, Long branchId, Long productBranchId, Long groupId) throws BusinessException {

		BizBranch bizBranch = bizBranchQueryService.selectBranchByPrimaryKey(branchId);
		model.addAttribute("bizBranch", bizBranch);
		if(productBranchId != null){
			//修改步骤
			showUpdateProductBranch(model, productBranchId, branchId, mainProdBranchId);
		}else{
			ProdProductBranch prodProductBranch = new ProdProductBranch();
			prodProductBranch.setBranchId(branchId);
			prodProductBranch.setBranchName(bizBranch.getBranchName());
			prodProductBranch.setProductId(productId);
			prodProductBranch.setCancelFlag("Y");
			prodProductBranch.setRecommendLevel(3L);
			model.addAttribute("productBranch", prodProductBranch);
			
			List<BizBranchProp> list = bizBranchQueryService.findBranchPropListByBranchId(branchId);

			this.filterDictListByProductId(list, productId);
			
			model.addAttribute("branchPropList", list);
		}
		//附加 规格
		model.addAttribute("relationTypes", SuppGoodsRelation.RELATIONTYPE.values());
		
		model.addAttribute("productBranchId", productBranchId);
		model.addAttribute("mainProdBranchId", mainProdBranchId);
		model.addAttribute("productId", productId);
		model.addAttribute("branchId", branchId);
		model.addAttribute("groupId", groupId);
		return "/prod/packageTour/prodbranch/showAddProductBranch";
	}
	
	private void filterDictListByProductId(List<BizBranchProp> list, Long productId){
		if(list != null && !list.isEmpty()){
			for(BizBranchProp branchProp: list){
				//所属酒店
				if("belongs_hotel".equalsIgnoreCase(branchProp.getPropCode())){
					List<BizDict> belongsHotelDictList = branchProp.getDictList();
					if(belongsHotelDictList != null && !belongsHotelDictList.isEmpty()){
						Map<String, Object> params = new HashMap<String, Object>();
						List<BizDict> validBelongsDictList = new ArrayList<BizDict>();
						for(BizDict belongHotelDict : belongsHotelDictList){
							Long dictDefId = belongHotelDict.getDictDefId();
							//字典定义属性Id（存放产品Id）
							Long dictPropDefId = 50L;
							
							params.clear();
							params.put("dictDefId", dictDefId);
							params.put("dictPropDefId", dictPropDefId);
							params.put("dictPropValue", String.valueOf(productId));
							
							List<BizDictProp> dictPropList = MiscUtils.autoUnboxing(dictPropService.findDictPropList(params));
							if(dictPropList != null && !dictPropList.isEmpty()){
								for(BizDictProp dictProp : dictPropList){
									Long dictId = dictProp.getDictId();
									if(dictId.intValue() == belongHotelDict.getDictId().intValue()){
										validBelongsDictList.add(belongHotelDict);
									}
								}
							}
						}
						
						branchProp.setDictList(validBelongsDictList);
					}
				}
			}
		}
	}

	/**
	 * 跳转到添加产品规格tab页
	 */
	@RequestMapping(value = "/showAddProductBranchTab.do")
	public String showAddProductBranchTab(Model model, Long productId, Long branchId, Long productBranchId, Long mainProdBranchId, Long groupId) throws BusinessException {
		if (branchId != null) {
			BizBranch bizBranch = bizBranchQueryService.selectBranchByPrimaryKey(branchId);
			model.addAttribute("bizBranch", bizBranch);
			/*List<BizBranchProp> list = bizBranchQueryService.findBranchPropListByBranchId(branchId);
			model.addAttribute("branchPropList", list);*/
		}
		model.addAttribute("productId", productId);
		model.addAttribute("branchId", branchId);
		model.addAttribute("mainProdBranchId", mainProdBranchId);
		model.addAttribute("productBranchId", productBranchId);
		model.addAttribute("groupId", groupId);
		
		return "/prod/packageTour/prodbranch/showAddProductBranchTab";
	}
	
	@RequestMapping(value = "/checkProductBranch.do")
	@ResponseBody
	public Object checkProductBranch(String  branchCode,Long productId,Long categoryId) throws BusinessException {
		try{
		
		//如果是新增可换，则判断是否已经有升级
		if("changed_hotel".equalsIgnoreCase(branchCode)){
			branchCode = "upgrad";
		//如果是升级，则判断是否已经有可换	
		}else if("upgrad".equalsIgnoreCase(branchCode)){
			branchCode = "changed_hotel";
		}
		HashMap<String,Object> params = new HashMap<String,Object>();
		//查询规格ID
		if("changed_hotel".equals(branchCode)) {
			params.clear();
			params.put("productId",productId);
			params.put("categoryId", categoryId);
			params.put("groupType", ProdPackageGroup.GROUPTYPE.CHANGE.name());
			
			List<ProdPackageGroup> prodPackageGroupList = prodPackageGroupService.findProdPackageGroup(params);
			if(prodPackageGroupList !=null && prodPackageGroupList.size() >0){
				return "error";
			}
		}
		else {
			params.clear();
			params.put("branchCode", branchCode);
			params.put("categoryId", categoryId);
			List<BizBranch> branchList = MiscUtils.autoUnboxing(branchService.findBranchListByParams(params));
			if(branchList!=null && branchList.size()>0){
				BizBranch branch = branchList.get(0);
				params.clear();
				params.put("branchId", branch.getBranchId());
				params.put("productId", productId);
				List<ProdProductBranch> list =  prodProductBranchService.findProdProductBranchList(params);
				if(list!=null && list.size() > 0)
					return "error";
			}
		}
		
		}catch(Exception e){
		    LOG.error(e.getMessage());
		}
		return "success";
	}
	
	@RequestMapping(value = "/saveProductBranch.do")
	@ResponseBody
	public Object saveProductBranch(ProdProductBranch prodProductBranch, Long mainProdBranchId, String relationType) throws BusinessException {
		Object object = null;
		
		//修改规格
		if(prodProductBranch.getProductBranchId() != null){
			object = updateProductBranch(prodProductBranch, relationType, mainProdBranchId);
		}else{
			//新增规格(可换-酒店和升级两种模式先做互斥)
			BizBranch bizBranch = MiscUtils.autoUnboxing(branchService.findBranchById(prodProductBranch.getBranchId()));
			if(bizBranch != null && ("changed_hotel".equalsIgnoreCase(bizBranch.getBranchCode()) || "upgrad".equalsIgnoreCase(bizBranch.getBranchCode()))){
				/*Long otherBranchId = null;
				String otherBranchCode = null;
				//获取任外的otherbranchId，来做排除
				if(bizBranch.getBranchCode().equalsIgnoreCase("changed_hotel")){
					 otherBranchCode = "upgrad";
				}else{
					 otherBranchCode = "changed_hotel";
				}
				parameters.put("categoryId", bizBranch.getCategoryId());
				parameters.put("branchCode", otherBranchCode);
				List<BizBranch> otherBizBranch = branchService.findBranchListByParams(parameters);
				if(otherBizBranch != null && otherBizBranch.size() >0){
					 otherBranchId = otherBizBranch.get(0).getBranchId();
					 parameters.clear();
					 parameters.put("productId", prodProductBranch.getProductId());
					 parameters.put("branchId", otherBranchId);
					 List<ProdProductBranch> list = prodProductBranchService.findProdProductBranchList(parameters);
					 if(list != null && list.size() > 0){
						throw new BusinessException("可换-酒店和升级排斥两种模式互斥");
					 }
				}*/
				
				//需要校验
				String checkMsg = (String)checkProductBranch(bizBranch.getBranchCode(), prodProductBranch.getProductId(), bizBranch.getCategoryId());
				if("error".equalsIgnoreCase(checkMsg)){
					throw new BusinessException("可换-酒店和升级排斥两种模式互斥");
				}
			}
			
			object = addProductBranch(prodProductBranch, mainProdBranchId, relationType, bizBranch);
		}
		return object;
	}
	
	/**
	 * 独立函数(更新产品规格)
	 */
	public Object updateProductBranch(ProdProductBranch prodProductBranch, String relationType, Long mainProdBranchId) throws BusinessException {
		//获取原来的规格
		ProdProductBranch oldProdProductBranch = prodProductBranchService.findProdProductBranchById(prodProductBranch.getProductBranchId(), Boolean.TRUE, Boolean.TRUE);
		//填充产品规格属性列表
		prodProductBranchService.findPropValueOfProdBranch(oldProdProductBranch, true, true);
		prodProductBranchService.updateProdProductBranch(prodProductBranch);
 
		List<SuppGoods> secGoodsList = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsByBranchId(prodProductBranch.getProductBranchId()));
		if(secGoodsList != null && secGoodsList.size() > 0){
			SuppGoods suppGoods = secGoodsList.get(0);
			suppGoods.setGoodsName(prodProductBranch.getBranchName());
			suppGoods.setSenisitiveFlag(prodProductBranch.getSenisitiveFlag());
			suppGoodsService.updateSuppGoods(suppGoods);
		}
		
		BizBranch bizBranch = MiscUtils.autoUnboxing(branchService.findBranchById(prodProductBranch.getBranchId()));
		//新增附加规格，获取主规格下所有商品，先移除所有老关联关系，后新建
		if(bizBranch != null && bizBranch.getBranchCode().equalsIgnoreCase("addition")){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("hasProp", Boolean.TRUE);
			params.put("hasPropValue", Boolean.TRUE);
			params.put("getPropInfo", "true");
			ProdProduct prodProduct = prodProductService.getProductPropInfoFromCacheById(prodProductBranch.getProductId(), params);
			List<SuppGoods> mainGoodsList = null;
			//判断是不是酒店套餐
			if(prodProduct.getBizCategoryId()==17){
				params.clear();
				params.put("productId", prodProduct.getProductId());
				params.put("categoryId", prodProduct.getBizCategoryId());
				List<Long> allMainProdBranchId = prodProductBranchService.selectMainProdBranchList(params);
				mainGoodsList = new ArrayList<SuppGoods>();
				if(allMainProdBranchId!=null&&allMainProdBranchId.size()>0){
					for(Long mProdBranchId : allMainProdBranchId){
						ArrayList<SuppGoods>list=MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsByBranchId(mProdBranchId));
						mainGoodsList.addAll(list);
					}
				}
			}else {
				mainGoodsList = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsByBranchId(mainProdBranchId));
			}


			for(SuppGoods mainSuppGoods : mainGoodsList){
				for(SuppGoods secSuppGoods : secGoodsList){
					SuppGoodsRelation suppGoodsRelation = new SuppGoodsRelation();
					suppGoodsRelation.setMainGoodsId(mainSuppGoods.getSuppGoodsId());
					suppGoodsRelation.setSecGoodsId(secSuppGoods.getSuppGoodsId());
					suppGoodsRelationService.deleteRelatinByRelation(suppGoodsRelation);
				}
			}
			SuppGoodsRelation suppGoodsRelation = new SuppGoodsRelation();
			for(SuppGoods mainSuppGoods : mainGoodsList){
				for(SuppGoods secSuppGoods : secGoodsList){
					suppGoodsRelation.setMainGoodsId(mainSuppGoods.getSuppGoodsId());
					suppGoodsRelation.setSecGoodsId(secSuppGoods.getSuppGoodsId());
					suppGoodsRelation.setRelationType(relationType);
					suppGoodsRelationService.saveRelation(suppGoodsRelation);
				}
			}
		}
		
		//获取操作日志
		try {
			String logContent = getProductBranchChangeLog(oldProdProductBranch, prodProductBranch);
			if(null!=logContent && !"".equals(logContent)) {
				
				//添加操作日志
				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_BRANCH, 
						prodProductBranch.getProductId(), prodProductBranch.getProductBranchId(),
						this.getLoginUser().getUserName(), 
						"修改了产品规格："+prodProductBranch.getBranchName()+"。修改内容："+logContent, 
						COM_LOG_LOG_TYPE.PROD_PRODUCT_BRANCH_CHANGE.name(), 
						"修改产品规格",null);
			}} catch (Exception e) {
				log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_BRANCH_CHANGE.name());
				log.error(e.getMessage());
			}
		
		return ResultMessage.SET_SUCCESS_RESULT;
	}

	/**
	 * 独立函数(新增产品规格)
	 */
	public Object addProductBranch(ProdProductBranch prodProductBranch, Long mainProdBranchId, String relationType, BizBranch bizBranch) throws BusinessException {
		if(prodProductBranch!=null)
		prodProductBranch.setCancelFlag("Y");
		int id =prodProductBranchService.addProdProductBranch(prodProductBranch);
		prodProductBranch.setProductBranchId((long) id);

		//获取主规格下商品---同时新增一商品(基础属性与主规格下商品一致)
		List<SuppGoods> mainGoodsList = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsByBranchId(mainProdBranchId));
		if(mainGoodsList != null && mainGoodsList.size() > 0){
			SuppGoods mainSuppGoods = mainGoodsList.get(0);
			SuppGoods newSuppGoods = new SuppGoods();
			newSuppGoods.setContentManagerId(mainSuppGoods.getContentManagerId());
			newSuppGoods.setSupplierId(mainSuppGoods.getSupplierId());
			newSuppGoods.setContractId(mainSuppGoods.getContractId());
			newSuppGoods.setPayTarget(SuppGoods.PAYTARGET.PREPAID.name());
			newSuppGoods.setFaxFlag(mainSuppGoods.getFaxFlag());
			newSuppGoods.setFaxRuleId(mainSuppGoods.getFaxRuleId());
			newSuppGoods.setCurrencyType(mainSuppGoods.getCurrencyType());
			newSuppGoods.setGoodsName(prodProductBranch.getBranchName());
			newSuppGoods.setSenisitiveFlag(prodProductBranch.getSenisitiveFlag());
			newSuppGoods.setBizBranch(prodProductBranch.getBizBranch());
			newSuppGoods.setProductId(prodProductBranch.getProductId());
			newSuppGoods.setProductBranchId(prodProductBranch.getProductBranchId());
			newSuppGoods.setPackageFlag(mainSuppGoods.getPackageFlag());
			newSuppGoods.setCancelFlag("N");
			newSuppGoods.setMinQuantity(1L);
			newSuppGoods.setMaxQuantity(10L);
			newSuppGoods.setOrgId(mainSuppGoods.getOrgId());
			newSuppGoods.setManagerId(mainSuppGoods.getManagerId());
			newSuppGoods.setFiliale(mainSuppGoods.getFiliale());
			newSuppGoods.setBu(mainSuppGoods.getBu());
			newSuppGoods.setAttributionId(mainSuppGoods.getAttributionId());
			newSuppGoods.setCompanyType(mainSuppGoods.getCompanyType());
            newSuppGoods.setEbkSupplierGroupId(mainSuppGoods.getEbkSupplierGroupId());
			newSuppGoods.setBuyoutSettlementEntityCode(mainSuppGoods.getBuyoutSettlementEntityCode());
            newSuppGoods.setSettlementEntityCode(mainSuppGoods.getSettlementEntityCode());
			//设置价格类型
			//如果是可换酒店就设置为多价格
			if(prodProductBranch.getBranchId()!=null){
				 BizBranch  branch = bizBranchQueryService.selectBranchByPrimaryKey(prodProductBranch.getBranchId());
				 if(branch.getBranchCode().equalsIgnoreCase("changed_hotel")){
					 newSuppGoods.setPriceType(SuppGoods.PRICETYPE.MULTIPLE_PRICE.name());
				 }
			}
			//如果是酒店套餐，就自动设置成人数和儿童数
			ProdProduct  pp = prodProductService.getProdProductBy(prodProductBranch.getProductId());
			if(pp!=null && pp.getBizCategoryId()==17L){
				newSuppGoods.setAdult(mainSuppGoods.getAdult());
				newSuppGoods.setChild(mainSuppGoods.getChild());
			}
			newSuppGoods.setCreateUser(this.getLoginUserId());
			Long id2 =MiscUtils.autoUnboxing(suppGoodsService.addSuppGoods(newSuppGoods));
			newSuppGoods.setSuppGoodsId(id2);

			//新增附加规格，获取主规格下所有商品，新增商品间关联关系
			if(bizBranch != null && bizBranch.getBranchCode().equalsIgnoreCase("addition")){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("hasProp", Boolean.TRUE);
				params.put("hasPropValue", Boolean.TRUE);
				params.put("getPropInfo", "true");
				ProdProduct prodProduct = prodProductService.getProductPropInfoFromCacheById(prodProductBranch.getProductId(), params);
				//酒店套餐特殊存在多个主规格(线路的其他子品类不同)
				if(prodProduct !=null && prodProduct.getBizCategory() != null
						&& prodProduct.getBizCategoryId().intValue() == 17
						&& prodProduct.getBizCategory().getParentId() != null
						&& prodProduct.getBizCategory().getParentId().intValue() == 14){
					params.clear();
					params.put("productId", prodProductBranch.getProductId());
					params.put("categoryId", prodProduct.getBizCategory().getCategoryId());
					List<Long> allMainProdBranchId = prodProductBranchService.selectMainProdBranchList(params);
					if(allMainProdBranchId != null && allMainProdBranchId.size() > 0){
						for(Long eachMainProdBranchId : allMainProdBranchId){
							List<SuppGoods> eachMainGoodsList = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsByBranchId(eachMainProdBranchId));
							SuppGoodsRelation suppGoodsRelation = new SuppGoodsRelation();
							for(SuppGoods mainGoods : eachMainGoodsList){
								suppGoodsRelation.setMainGoodsId(mainGoods.getSuppGoodsId());
								suppGoodsRelation.setSecGoodsId(newSuppGoods.getSuppGoodsId());
								suppGoodsRelation.setRelationType(relationType);
								suppGoodsRelationService.saveRelation(suppGoodsRelation);
							}
						}
					}
				}else{
					SuppGoodsRelation suppGoodsRelation = new SuppGoodsRelation();
					for(SuppGoods mainGoods : mainGoodsList){
						suppGoodsRelation.setMainGoodsId(mainGoods.getSuppGoodsId());
						suppGoodsRelation.setSecGoodsId(newSuppGoods.getSuppGoodsId());
						suppGoodsRelation.setRelationType(relationType);
						suppGoodsRelationService.saveRelation(suppGoodsRelation);
					}
				}
			}else {
				//获得所有附加，增加商品间关联关系
				SuppGoodsRelation sgrq = new SuppGoodsRelation();
				sgrq.setMainGoodsId(mainSuppGoods.getSuppGoodsId());
				List<SuppGoodsRelation> list =  suppGoodsRelationService.findAllSuppGoodsRelation(sgrq);
				if(list!=null && list.size()>0){
					//为新增的主规格增加关联关系
					for(SuppGoodsRelation suppGoodsRelation : list){
						suppGoodsRelation.setRelationId(null);
						suppGoodsRelation.setMainGoodsId(newSuppGoods.getSuppGoodsId());
						suppGoodsRelationService.saveRelation(suppGoodsRelation);
					}
				}
			}

		}
		
		//新升级规格关联组
		if(bizBranch != null && bizBranch.getBranchCode().equalsIgnoreCase("upgrad")){
			HashMap<String,Object> params = new HashMap<String,Object>();
			params.put("productId", prodProductBranch.getProductId());
			params.put("groupType", ProdPackageGroup.GROUPTYPE.UPDATE.name());
			params.put("categoryId", prodProductBranch.getCategoryId());
			List<ProdPackageGroup> tempList = prodPackageGroupService.findProdPackageGroupByParams(params, Boolean.FALSE, Boolean.FALSE);
			if(tempList.size() > 0){
				ProdPackageDetail prodPackageDetail = new ProdPackageDetail();
				prodPackageDetail.setObjectId(prodProductBranch.getProductBranchId());
				prodPackageDetail.setObjectType(ProdPackageDetail.OBJECT_TYPE_DESC.PROD_BRANCH.name());
				prodPackageDetail.setGroupId(tempList.get(0).getGroupId());
				params.put("groupId", prodPackageDetail.getGroupId());
				params.put("objectId", prodPackageDetail.getObjectId());
				params.put("objectType", prodPackageDetail.getObjectType());
				int count = prodPackageDetailService.getProdPackageDetailCount(params);
				if(count == 0){
					prodPackageDetailService.saveProdPackageDetail(prodPackageDetail);
				}
			}
		}
		
		Long productId = null;
		Long productBranchId = null;
        if(prodProductBranch != null){
            productId = prodProductBranch.getProductId();
            productBranchId = prodProductBranch.getProductBranchId();
        }
		
		//添加操作日志
		try {
			comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_BRANCH, 
			        productId, productBranchId, 
					this.getLoginUser().getUserName(), 
					"添加了产品编号为：【"+productId+"】的产品规格：【"+productBranchId+"】", 
					COM_LOG_LOG_TYPE.PROD_PRODUCT_BRANCH_CHANGE.name(), 
					"添加产品规格",null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_BRANCH_CHANGE.name());
			log.error(e.getMessage());
		}
		
		Map<String, Object> attributes = new HashMap<String, Object>();
		
		attributes.put("productBranchId", productBranchId);
		return new ResultMessage(attributes, "success", "保存成功");
	}

	@RequestMapping(value = "/showProductBranchCheck")
	@ResponseBody
	public Object showSuppGoodsListCheck(HttpServletRequest req) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<showSuppGoodsListCheck>");
		}
		ResultMessage message = null;
		if (req.getParameter("productId") != null) {
			Map<String, Object> parameters = new HashMap<String, Object>();
			parameters.put("productId", req.getParameter("productId"));
			ProdProduct prodProduct = prodProductService.findProdProduct4FrontById(Long.valueOf(req.getParameter("productId")), Boolean.TRUE, Boolean.TRUE);
			new HashMap<String, Object>();
			// 商品维护前，产品基本信息check
			message = new ResultMessage("success", "success");
			if ((prodProduct == null) || (prodProduct.getProductId() == null)) {
				message = new ResultMessage("error", "该产品不存在，请先维护产品！");
			} else {
//取消产品不可用的检查				
//				if ("N".equals(prodProduct.getCancelFlag())) {
//					message = new ResultMessage("error", "该产品不可用，请先修改产品状态！");
//				}
			}
		}
		return message;
	}

	/**
	 * 设置是否有效
	 */
	@RequestMapping(value = "/editSuppGoodsFlag.do")
	@ResponseBody
	public Object editSuppGoodsFlag(SuppGoods suppGoods) throws BusinessException {
		
		SuppGoods oldSuppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoods.getSuppGoodsId()));
		if(oldSuppGoods == null){
			return new ResultMessage("error", "无该商品");
		}
		
		if ("N".equals(oldSuppGoods.getCancelFlag())) {
			oldSuppGoods.setCancelFlag("Y");
		} else if ("Y".equals(oldSuppGoods.getCancelFlag())) {
			oldSuppGoods.setCancelFlag("N");
		} else if (StringUtil.isEmptyString(oldSuppGoods.getCancelFlag())) {
			oldSuppGoods.setCancelFlag("Y");
		}else {
			return new ResultMessage("error", "设置失败,无效参数");
		}
		suppGoodsService.updateCancelFlag(oldSuppGoods);
		//suppGoodsLineTimePriceService.updateGruopStockBySuppGoods(suppGoods,oldSuppGoods.getGroupId());
		//添加操作日志
		try {
			String key ="";
			if ("Y".equals(oldSuppGoods.getCancelFlag())) {
				key = "有效";
			} else {
				key = "无效";
			}
			comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
					oldSuppGoods.getProductId(), oldSuppGoods.getSuppGoodsId(), 
					this.getLoginUser().getUserName(), 
					"修改了商品的有效性为:"+key, 
					COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name(), 
					"修改商品有效性",null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.SUPP_GOODS_GOODS_CHANGE.name());
			log.error(e.getMessage());
		}	
		
		return ResultMessage.SET_SUCCESS_RESULT;
	}
	
	
	 private String getProductBranchChangeLog(ProdProductBranch oldProductBranch,ProdProductBranch newProductBranch){
		 StringBuffer logStr = new StringBuffer("");
		 if(null!= newProductBranch)
		 {
			 logStr.append(ComLogUtil.getLogTxt("规格名称",newProductBranch.getBranchName(),oldProductBranch.getBranchName()));
			 logStr.append(ComLogUtil.getLogTxt("是否有效","Y".equals(newProductBranch.getCancelFlag())?"是":"否","Y".equals(oldProductBranch.getCancelFlag())?"是":"否"));
			 if(newProductBranch.getMaxVisitor() != null && oldProductBranch.getMaxVisitor() != null){
				 logStr.append(ComLogUtil.getLogTxt("最大入住人数",newProductBranch.getMaxVisitor().toString(),oldProductBranch.getMaxVisitor().toString()));
			 }
			 logStr.append(ComLogUtil.getLogTxt("推荐级别",newProductBranch.getRecommendLevel().toString(),oldProductBranch.getRecommendLevel().toString()));

		     if(!newProductBranch.getProductBranchPropList().equals(oldProductBranch.getProductBranchPropList())){
		 		Map<Long,ProdProductBranchProp> oldProductBranchPropMap = new HashMap<Long, ProdProductBranchProp>();
				Map<Long,ProdProductBranchProp> prodProductBranchPropMap = new HashMap<Long, ProdProductBranchProp>();
				Map<Long,Map<String,String>> resultMap = new HashMap<Long, Map<String,String>>();
				
				ComLogUtil.setProdProductBranchProp2Map(oldProductBranch.getProductBranchPropList(),oldProductBranchPropMap);
				ComLogUtil.setProdProductBranchProp2Map(newProductBranch.getProductBranchPropList(),prodProductBranchPropMap);
				ComLogUtil.diffProdProductBranchPropMap(oldProductBranchPropMap, prodProductBranchPropMap, resultMap);
				
				Map<Long,BizBranchProp> bizBranchPropMap = new HashMap<Long,BizBranchProp>();
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("branchId", newProductBranch.getBranchId());
				params.put("_orderby", "SEQ");
				params.put("productBranchId",newProductBranch.getProductBranchId());
				//查询该规格下面所有的产品规格（包括无效的）
				List<BizBranchProp> branchPropList = branchPropService.findBranchPropsByParams(params);
				if ((branchPropList != null) && (branchPropList.size() > 0)) {
					for (BizBranchProp bizBranchProp : branchPropList) {
						ComLogUtil.setBizBranchProp2Map(branchPropList, bizBranchPropMap);
				     }
					
				}
				
				//获取产品规格动态属性列表变更日志
				for (Map.Entry<Long,Map<String,String>> entry : resultMap.entrySet()) {
					if(PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_YESNO.name().equals(bizBranchPropMap.get(entry.getKey()).getInputType()))
					{
						String oldValue = ("Y".equals(resultMap.get(entry.getKey()).get("oldValue"))?"是":"否");
						String newValue = ("Y".equals(resultMap.get(entry.getKey()).get("newvalue"))?"是":"否");
						logStr.append(ComLogUtil.getLogTxt(bizBranchPropMap.get(entry.getKey()).getPropName(),newValue,oldValue));
					}
					else if(PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_RADIO.name().equals(bizBranchPropMap.get(entry.getKey()).getInputType())){
						String newValue = resultMap.get(entry.getKey()).get("newValue");
						String[] dictIdArray = newValue.split(",");
						String oldValue = resultMap.get(entry.getKey()).get("oldValue");
						String[] dictIdArray2 = oldValue.split(",");
						if(dictIdArray.length != 0)
						{
							newValue = prodProductService.getDictCnValue(dictIdArray);
						}else{
							newValue = "";
						}
						if(dictIdArray2.length != 0)
						{
							oldValue = prodProductService.getDictCnValue(dictIdArray2);
						}else{
							oldValue = "";
						}
						logStr.append(ComLogUtil.getLogTxt(bizBranchPropMap.get(entry.getKey()).getPropName(),newValue,oldValue));
					}else if(PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_SELECT.name().equals(bizBranchPropMap.get(entry.getKey()).getInputType())){
						String newValue = resultMap.get(entry.getKey()).get("newValue");
						String[] dictIdArray = newValue.split(",");
						String oldValue = resultMap.get(entry.getKey()).get("oldValue");
						String[] dictIdArray2 = oldValue.split(",");
						if(dictIdArray.length > 0)
						{
							newValue = prodProductService.getDictCnValue(dictIdArray);
						}else{
							newValue = "";
						}
						if(dictIdArray2.length > 0)
						{
							oldValue = prodProductService.getDictCnValue(dictIdArray2);
						}else{
							oldValue = "";
						}
						logStr.append(ComLogUtil.getLogTxt(bizBranchPropMap.get(entry.getKey()).getPropName(),newValue,oldValue));
					}else if(PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_TEXTAREA.name().equals(bizBranchPropMap.get(entry.getKey()).getInputType()) 
							|| PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_RICH.name().equals(bizBranchPropMap.get(entry.getKey()).getInputType())){
						String oldValue = resultMap.get(entry.getKey()).get("oldValue");
						String newValue = resultMap.get(entry.getKey()).get("newValue");
						if(null!=newValue && !newValue.equals(oldValue))
						{
							logStr.append(ComLogUtil.getLogTxt(bizBranchPropMap.get(entry.getKey()).getPropName(),newValue,null));
						}else{
							logStr.append(ComLogUtil.getLogTxt(bizBranchPropMap.get(entry.getKey()).getPropName(),newValue,oldValue));
						}
					}
					else
					{
						logStr.append(ComLogUtil.getLogTxt(bizBranchPropMap.get(entry.getKey()).getPropName(),resultMap.get(entry.getKey()).get("newValue"),resultMap.get(entry.getKey()).get("oldValue")));
					}
				}
		     }

		 }
		 return logStr.toString();
	 }

}
