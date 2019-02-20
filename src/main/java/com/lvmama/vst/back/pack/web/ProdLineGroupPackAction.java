package com.lvmama.vst.back.pack.web;

import static com.lvmama.vst.comm.utils.front.AutoPackageUtil.notZero;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.ArrayUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.dubbo.common.utils.StringUtils;
import com.lvmama.bridge.utils.hotel.DestHotelAdapterUtils;
import com.lvmama.comm.tnt.po.TntChannelVo;
import com.lvmama.comm.tnt.po.TntGoodsChannelVo;
import com.lvmama.comm.tnt.po.TntUserVo;
import com.lvmama.vst.back.biz.po.BizBranch;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.po.BizCategoryProp;
import com.lvmama.vst.back.biz.po.BizCitygroup;
import com.lvmama.vst.back.biz.po.BizDest;
import com.lvmama.vst.back.biz.po.BizDict;
import com.lvmama.vst.back.biz.po.BizDistrict;
import com.lvmama.vst.back.biz.po.BizEnum;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.biz.service.CitygroupService;
import com.lvmama.vst.back.biz.service.DestService;
import com.lvmama.vst.back.biz.service.DistrictQueryMemService;
import com.lvmama.vst.back.client.biz.service.BranchClientService;
import com.lvmama.vst.back.client.biz.service.CategoryClientService;
import com.lvmama.vst.back.client.biz.service.DistrictClientService;
import com.lvmama.vst.back.client.dist.service.DistDistributorProdClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsHotelAdapterClientService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteClientService;
import com.lvmama.vst.back.client.prod.service.ProdPackageDetailAddPriceClientService;
import com.lvmama.vst.back.client.prod.service.ProdPackageDetailClientService;
import com.lvmama.vst.back.client.prod.service.ProdPackageGroupClientService;
import com.lvmama.vst.back.client.prod.service.ProdTrafficClientService;
import com.lvmama.vst.back.client.pub.service.ComCalDataClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.dist.po.DistDistributorProd;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.goods.vo.ProdProductParam;
import com.lvmama.vst.back.goods.vo.SuppGoodsChangeHotelVO;
import com.lvmama.vst.back.pack.data.ProdPackageDetailGoodsData;
import com.lvmama.vst.back.pack.data.ProdProductGoodsBranchData;
import com.lvmama.vst.back.pack.service.ProdHotelGroupPackGoodslAdapterService;
import com.lvmama.vst.back.pack.service.ProdLineGroupPackService;
import com.lvmama.vst.back.pack.service.ProdPackageDetailGoodsAdapterService;
import com.lvmama.vst.back.pack.service.ProdPackageDetailGoodsService;
import com.lvmama.vst.back.pack.service.ProdPackageGroupLineService;
import com.lvmama.vst.back.pack.service.ProdPackageGroupTransportService;
import com.lvmama.vst.back.prod.comm.query.service.ProdEsQueueService;
import com.lvmama.vst.back.prod.po.ProdLineRoute;
import com.lvmama.vst.back.prod.po.ProdPackageDetail;
import com.lvmama.vst.back.prod.po.ProdPackageDetailAddPrice;
import com.lvmama.vst.back.prod.po.ProdPackageGroup;
import com.lvmama.vst.back.prod.po.ProdPackageGroupLine;
import com.lvmama.vst.back.prod.po.ProdPackageGroupTransport;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductAssociation;
import com.lvmama.vst.back.prod.po.ProdProductBranch;
import com.lvmama.vst.back.prod.po.ProdProductGoodsData;
import com.lvmama.vst.back.prod.po.ProdProductProp;
import com.lvmama.vst.back.prod.po.ProdProductSaleRe;
import com.lvmama.vst.back.prod.po.ProdStartDistrictDetail;
import com.lvmama.vst.back.prod.po.ProdTraffic;
import com.lvmama.vst.back.prod.service.ProdProductAssociationService;
import com.lvmama.vst.back.prod.service.ProdProductBranchAdapterService;
import com.lvmama.vst.back.prod.service.ProdProductBranchService;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.prod.service.ProdStartDistrictDetailService;
import com.lvmama.vst.back.pub.po.ComCalData;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.pub.service.PushAdapterService;
import com.lvmama.vst.back.router.adapter.ProdProductHotelAdapterService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.back.utils.MsgFactory;
import com.lvmama.vst.comm.utils.CalendarUtils;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.DateUtil;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.Pair;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.utils.front.AutoPackageUtil;
import com.lvmama.vst.comm.utils.web.HttpServletLocalThread;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.pet.adapter.TntGoodsChannelCouponAdapter;

@Controller
@RequestMapping("/productPack/line")
public class ProdLineGroupPackAction extends BaseActionSupport {

	@Autowired
	private ProdLineGroupPackService prodLineGroupPackService;

	@Autowired
	private ProdProductService prodProductService;
	
	@Autowired
	private ProdProductHotelAdapterService prodProductAdapterService;

	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;

	@Autowired
	private ProdProductBranchService prodProductBranchService;
	
	@Autowired
	private ProdProductBranchAdapterService prodProductBranchAdapterService;

	@Autowired
	private ProdPackageDetailClientService prodPackageDetailService;
	
	@Autowired
	private DestHotelAdapterUtils destHotelAdapterUtils;

	@Autowired
	private ProdPackageDetailAddPriceClientService prodPackageDetailAddPriceService;
	

	@Autowired
	private CategoryClientService categoryService;
	

	@Autowired
	private ProdPackageGroupClientService prodPackageGroupService;
	

	@Autowired
	private ProdPackageGroupLineService prodPackageGroupLineService;  //1

	@Autowired
	private ComLogClientService comLogService;
	

	@Autowired
	private BranchClientService branchService;
	

	@Autowired
	private ProdTrafficClientService prodTrafficService;
	

	@Autowired
	private SuppGoodsClientService suppGoodsService;
	
	
	@Autowired
	private SuppGoodsHotelAdapterClientService suppGoodsHotelAdapterService;
	

	@Autowired
	private ProdPackageGroupTransportService prodPackageGroupTransportService;//2

	@Autowired
	private ProdStartDistrictDetailService prodStartDistrictDetailService;

	@Autowired
	PushAdapterService pushAdapterService;

	@Autowired
	private DistrictClientService districtService;
	

	@Autowired
	private CitygroupService citygroupService;//3

//	@Autowired
//	private BizDistrictDao bizDistrictDao;//666
	

	@Autowired
	private ProdLineRouteClientService prodLineRouteService;
	
	// 获取已经打包的商品
	@Autowired
	ProdPackageDetailGoodsService prodPackageDetailGoodsService;

	@Autowired
	ProdPackageDetailGoodsAdapterService prodPackageDetailGoodsAdapterService;//4

	@Autowired
	private ProdHotelGroupPackGoodslAdapterService hotelGroupPackGoodslAdapterService;
	
	@Autowired
	DistrictQueryMemService districtQueryMemService;//5

//	@Resource(name="productProducerProxy")
//	private SimpleProducterProxy productProducerProxy;//6
	@Autowired
	ProdEsQueueService prodEsQueueService;

	@Autowired
	private DestService destService;
	
	@Autowired
	private ProdProductAssociationService prodProductAssociationService;
	
	@Autowired
	private ProdProductBranchService productBranchService;
	
	@Autowired
	private ProdProductHotelAdapterService prodProductHotelAdapterService;
	
//	@Autowired
//	private DestHotelAdapterUtils destHotelAdapterUtils;//7
	
	@Autowired
	private TntGoodsChannelCouponAdapter tntGoodsChannelCouponServiceRemote;
	
	@Autowired
	private DistDistributorProdClientService distDistributorProdService;
	
	@Autowired
	private ComCalDataClientService comCalDataService;
	
	@RequestMapping(value = "/showPackList")
	public String showProductMaintain(Model model, Long productId,
			String categoryName, String groupType) throws Exception {
		ProdProduct prodProduct = null;
		List<ProdPackageGroup> packGroupList = null;
		if (productId != null && StringUtil.isNotEmptyString(groupType)) {
			ProdProductParam param = new ProdProductParam();
			param.setBizCategory(true);
			param.setProdLineRoute(true);

			prodProduct = prodProductService.findProdProductById(productId,
					param);
			// 存放选择的打包的品类
			List<BizCategory> selectCategoryList = new ArrayList<BizCategory>();

			// 选择打包的品类(或父品类ID)
			Long selectCategoryId = 0L;
			// 选择打包的品类是否有父品类 默认无
			String selectParentCategoryFlag = "N";

			Map<String, Object> packGroupParams = new HashMap<String, Object>();
			packGroupParams.put("productId", productId);
			packGroupParams.put("groupType", groupType);
			packGroupParams.put("muiltDpartureFlag",
					prodProduct.getMuiltDpartureFlag());

			// 酒店
			if (ProdPackageGroup.GROUPTYPE.HOTEL.name().equalsIgnoreCase(
					groupType)) {
				selectCategoryId = 1L;

				BizCategory selectBizCategory = bizCategoryQueryService
						.getCategoryById(selectCategoryId);
				selectCategoryList.add(selectBizCategory);
			} else if (ProdPackageGroup.GROUPTYPE.LINE.name().equalsIgnoreCase(
					groupType)) {
				selectCategoryId = 14L;
			} else if (ProdPackageGroup.GROUPTYPE.LINE_TICKET.name()
					.equalsIgnoreCase(groupType)) {
				selectCategoryId = 5L;
			} else if (ProdPackageGroup.GROUPTYPE.TRANSPORT.name()
					.equalsIgnoreCase(groupType)) {
				selectCategoryId = 19L;
			}

			if (!ProdPackageGroup.GROUPTYPE.HOTEL.name().equalsIgnoreCase(
					groupType)) {
				selectParentCategoryFlag = "Y";
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parentId", selectCategoryId);
				String saleType = "";
				List<BizCategory> bizCategoryList=categoryService.findCategoryList(params);
				//去掉29  交通+X 这个品类
				Iterator <BizCategory> categoryit = bizCategoryList.iterator();  
				while(categoryit.hasNext())  
				{  
					BizCategory next = categoryit.next();
				    if(BizEnum.BIZ_CATEGORY_TYPE.category_route_aero_hotel.getCategoryId().equals(next.getCategoryId()))  
				    {  
				    	categoryit.remove();  
				    } else if (BizEnum.BIZ_CATEGORY_TYPE.category_route_new_hotelcomb.getCategoryId().equals(next.getCategoryId())) {
				    	//去掉新品类 酒套餐
				    	categoryit.remove();
				    }
				} 
				if(CollectionUtils.isNotEmpty(bizCategoryList)){
					if(prodProduct !=null)
					{
						List<ProdProductSaleRe> prodProductList = prodProduct.getProdProductSaleReList();
						if(prodProductList.size()>0)
						{
							for (ProdProductSaleRe prodProductSaleRe : prodProductList) 
							{
								saleType = prodProductSaleRe.getSaleType();
							}
						}
					}
					if(ProdPackageGroup.GROUPTYPE.LINE_TICKET.name().equalsIgnoreCase(groupType) && ProdProductSaleRe.SALETYPE.COPIES.name().equals(saleType)){
							selectCategoryList.addAll(bizCategoryList);
				    }else if(ProdPackageGroup.GROUPTYPE.LINE.name().equalsIgnoreCase(groupType) &&
				    		prodProduct.getBu().equalsIgnoreCase("DESTINATION_BU")){ //目的地产品，选择线路时，只显示酒店套餐 Added by yangzhenzhong
						for(int i=0;i<bizCategoryList.size();i++){
							BizCategory bizCategory = bizCategoryList.get(i);
							String categoryCode = bizCategory.getCategoryCode();
							if(categoryCode.equals("category_route_hotelcomb")) {
								selectCategoryList.add(bizCategory);
								break;
							}
						}
					}else{
						for(int i=0;i<bizCategoryList.size();i++){  
							 BizCategory bizCategory = bizCategoryList.get(i);
							 String categoryCode = bizCategory.getCategoryCode();
							 if(categoryCode.equals("category_comb_ticket"))
							 {
								 bizCategoryList.remove(i);  
				             }  
						}
						selectCategoryList.addAll(bizCategoryList);
					}
			    }
				model.addAttribute("categoryParentId", selectCategoryId);
			}

			packGroupList = prodLineGroupPackService
					.findProdLinePackGroupByParams(packGroupParams);
			Map<String,Long> groupIds = new HashMap<String, Long>();
			mergeAutoPackageGroup(packGroupList,groupIds);
			model.addAttribute("toGroupId", groupIds.get("toGroupId"));
			model.addAttribute("backGroupId", groupIds.get("backGroupId"));
			// 大交通
			if (packGroupList != null
					&& ProdPackageGroup.GROUPTYPE.TRANSPORT.name()
							.equalsIgnoreCase(groupType)) {
				for (ProdPackageGroup group : packGroupList) {
					ProdPackageGroupTransport ppgTransport = group.getProdPackageGroupTransport();
					if(ppgTransport != null && "Y".equalsIgnoreCase(ppgTransport.getAutoPackage())) {
						continue;
					}
					
					if (group.getProdPackageDetails() != null) {
						for (ProdPackageDetail detail : group
								.getProdPackageDetails()) {
							ProdProductBranch branch = detail
									.getProdProductBranch();
							if (branch != null) {
								ProdProduct prod = prodProductService
										.findProdProductByProductId(branch
												.getProductId());
								branch.setProduct(prod);

								ProdTraffic traffic = prodTrafficService
										.selectByProductId(prod.getProductId());
								if (traffic.getStartDistrict() != null) {
									// 出发城市
									traffic.setStartDistrictObj(districtService
											.selectByPrimaryKey(traffic
													.getStartDistrict()));
								}
								if (traffic.getEndDistrict() != null) {
									// 目的地城市
									traffic.setEndDistrictObj(districtService
											.selectByPrimaryKey(traffic
													.getEndDistrict()));
								}
								prod.setProdTraffic(traffic);
							}
						}
					}
				}
			}

			// 根据产品id，获得第一个单程去程的交通组
			ProdPackageGroupTransport transport = this
					.getFirstSingleToPackageGroupTransport(productId);
			if (transport != null) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("groupId", transport.getGroupId());
				List<ProdStartDistrictDetail> startDistrictDetailList = prodStartDistrictDetailService
						.findStartDistrictDetailListByParams(params);

				// 传入页面的返程的多目的地
				List<BizDistrict> backDestDistricts = new ArrayList<BizDistrict>();
				// 传入页面的返程单出发地
				BizDistrict backStartPoint = new BizDistrict();

				if (CollectionUtils.isNotEmpty(startDistrictDetailList)) {
					for (ProdStartDistrictDetail startDistrictDetail : startDistrictDetailList) {
						backDestDistricts.add(startDistrictDetail.getStartDistrict());
					}

					ProdStartDistrictDetail startDistrictDetail = startDistrictDetailList
							.get(0);
					backStartPoint = startDistrictDetail.getDestination();
				}

				model.addAttribute("backDestDistricts", backDestDistricts);
				model.addAttribute("backStartPoint", backStartPoint);
			}

			model.addAttribute("transport", transport);
			model.addAttribute("selectCategoryId", selectCategoryId);
			model.addAttribute("selectParentCategoryFlag",
					selectParentCategoryFlag);
			model.addAttribute("selectCategoryList", selectCategoryList);
			model.addAttribute("productType", prodProduct.getProductType());
			model.addAttribute("BU", prodProduct.getBu());
			model.addAttribute("categoryId", prodProduct.getBizCategoryId());

		}
		if (!ProdPackageGroup.GROUPTYPE.TRANSPORT.name().equalsIgnoreCase(
				groupType)) {
			setGoodsToPackGroupList(packGroupList);
		}
		model.addAttribute("packGroupList", packGroupList);

		//机酒打包跟团游隐藏
		if(ProdPackageGroup.GROUPTYPE.LINE.name().equalsIgnoreCase(groupType) && prodProduct != null && prodProduct.getBizCategoryId() == 18L && 
				prodProduct.getSubCategoryId() == 182L && ProdProduct.PRODUCTTYPE.INNERLINE.name().equals(prodProduct.getProductType())){
				if(packGroupList != null && packGroupList.size() > 0){
					model.addAttribute("lineGroupHidFlag", "true");
					for(ProdPackageGroup packageGroup : packGroupList){
						if(packageGroup.getCategoryId()==15L){
							model.addAttribute("lineGroupHidFlag", "false");
							break;
						}
					}
				}else{
					model.addAttribute("lineGroupHidFlag", "true");
				}
		}
		
		if (prodProduct != null && prodProduct.getBizCategory() != null) {
			model.addAttribute("categoryName", prodProduct.getBizCategory()
					.getCategoryName());
		}
		model.addAttribute("prodProduct", prodProduct);
		model.addAttribute("groupType", groupType);
		model.addAttribute("productId", productId);
		String associatedFlag = "true";
		ProdLineRoute mainProdLineRoute = prodLineRouteService.findOnlyLineRouteId(productId).get(0);
		//线路判断是否显示"设置关联"
		if(packGroupList != null && packGroupList.size() > 0 && ProdPackageGroup.GROUPTYPE.LINE.name().equalsIgnoreCase(groupType)){
			if(prodProduct != null && (prodProduct.getBizCategoryId() == 15L || (prodProduct.getBizCategoryId() == 18L && prodProduct.getSubCategoryId() != 181L))){
				for(ProdPackageGroup packageGroup : packGroupList){
					List<ProdPackageDetail> prodPackageDetailList = packageGroup.getProdPackageDetails();
					if (CollectionUtils.isEmpty(prodPackageDetailList)) continue;
					for (ProdPackageDetail detail : prodPackageDetailList) {
						detail.setAssociatedFlag(associatedFlag);
						ProdProductBranch prodProductBranch = detail.getProdProductBranch();
						if(prodProductBranch != null){
							if(prodProductBranch.getCategoryId() != null && prodProductBranch.getCategoryId() == 17L){
								associatedFlag = "false";
								detail.setAssociatedFlag(associatedFlag);
								continue;
							}
							ProdProduct product = prodProductService.findProdProductByProductId(prodProductBranch.getProductId());
							if(product != null && product.getSubCategoryId() != null && product.getSubCategoryId() == 181L){
								associatedFlag = "false";
								detail.setAssociatedFlag(associatedFlag);
								continue;
							}
							Map<String,Object> params = new HashMap<String, Object>();
							params.put("productId", prodProductBranch.getProductId());
							params.put("cancleFlag", "Y");
							
							List<ProdLineRoute> prodLineRouteList =MiscUtils.autoUnboxing(prodLineRouteService.findProdLineRouteByParamsSimple(params));
							if(prodLineRouteList != null && prodLineRouteList.size() == 1){
								if(!(prodLineRouteList.get(0).getRouteNum().equals(mainProdLineRoute.getRouteNum()) && prodLineRouteList.get(0).getStayNum().equals(mainProdLineRoute.getStayNum()))){
									associatedFlag = "false";
									detail.setAssociatedFlag(associatedFlag);
									continue;
								}
							}
						}
					}
				}
			}
		}

		if (ProdPackageGroup.GROUPTYPE.TRANSPORT.name().equalsIgnoreCase(
				groupType)) {
			return "/pack/line/showPackList_transport";
		}
		model.addAttribute("hotelOnLineFlag", String.valueOf(destHotelAdapterUtils.checkHotelSystemOnlineEnable()));
		
 		//从request中获取是否需要提示的标记
		HttpServletRequest request = HttpServletLocalThread.getRequest();
		if(request != null ) {
			String needToast = request.getParameter("needToast");
			if("Y".equals(needToast)) {
				model.addAttribute("needToast", needToast);
			}
		}
		
		return "/pack/line/showPackList";
	}
	
	/**
	 * 展示自动打包交通的详情
	 * @param model
	 * @param productId
	 * @param categoryName
	 * @param groupType
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/showPackageDetail")
	public String showProductMaintainDetail(Model model, Long groupId, Long productId) throws BusinessException {
		//获取自动打包交通的去程信息列表
		Map<String, Object> packGroupParams = new HashMap<String, Object>();
		packGroupParams.put("groupId", groupId);
		List<ProdPackageDetail> prodPackageDetails = prodPackageDetailService.findProdPackageDetailList(packGroupParams);
		//转换数据
		getProdPackageDetails(prodPackageDetails);
		model.addAttribute("prodPackageDetails", prodPackageDetails);
		model.addAttribute("productId", productId);
		return "/pack/line/showPackList_transport_detail";
	}
	
/**
 * 自动打包交通，查询所有的出发地或者目的地列表
 * @param model
 * @param groupId
 * @param productId
 * @return
 * @throws BusinessException
 */
	@RequestMapping(value = "/showManagerPoints")
	public Object showManagerPoints(Model model, Long groupId, Long productId) throws BusinessException {
		//查询全国到目的地的规格信息或者目的地到全国的规格信息
		Map<String, ProdTraffic> trafficMap = new HashMap<String, ProdTraffic>();
		Map<String, ProdTraffic> allTrafficMap = new HashMap<String, ProdTraffic>();
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("groupId", groupId); 
		List<ProdPackageGroupTransport> transportList = prodPackageGroupTransportService.selectByParams(params);
		params.clear();
		if (CollectionUtils.isEmpty(transportList)) {
			return new ResultMessage("error", "没有查询到相关数据！");
		}
		ProdPackageGroupTransport packTransport = transportList.get(0);
		model.addAttribute("packTransport", packTransport);
		allTrafficMap = prodPackageGroupService.getAutopackageTrafficMap(packTransport);
		params.clear();
		
		if (allTrafficMap==null || allTrafficMap.size()<=0) {
			return new ResultMessage("error", "没有查询到相关数据！");
		}
		
		//查询当前形成的出发城市或者到达城市信息
		params.put("groupId", groupId);
		List<ProdPackageDetail> prodPackageDetails = prodPackageDetailService.findProdPackageDetailList(params);
		params.clear();
		//转换数据
		if (CollectionUtils.isEmpty(prodPackageDetails)) {
			return new ResultMessage("error", "没有查询到相关数据！");
		}
		getProdPackageDetails(prodPackageDetails);
		List<ProdTraffic> trafficList = null;
		
		//过滤重复的地点
		for (ProdPackageDetail detail : prodPackageDetails) {
			ProdProductBranch branch = detail.getProdProductBranch();
			if (branch != null) {
				ProdProduct product = branch.getProduct();
				if (product != null) {
					ProdTraffic traffic = product.getProdTraffic();
					if (traffic != null) {
						trafficMap.put(traffic.getTrafficId().toString(), traffic);
					}
				}
			}
		}
		//设置已经打包的地点勾选状态
		for (String key : allTrafficMap.keySet()) {
			ProdTraffic prodTraffic = trafficMap.get(key);
			
			if (prodTraffic!=null) {
				prodTraffic.setCheckedFlag("Y");
			}else {
				prodTraffic = allTrafficMap.get(key);
				trafficMap.put(key, prodTraffic);
			}
		}
		
		
		trafficList = new ArrayList<ProdTraffic>();
		for (String key : trafficMap.keySet()) {
			trafficList.add(trafficMap.get(key));
		}
		
		model.addAttribute("productId", productId);
		model.addAttribute("groupId", groupId);
		model.addAttribute("trafficList", trafficList);
		
		return "/pack/line/show_transport_managerpoints";
	}
	
	/**
	 * 自动打包时，出发地管理，点击保存
	 * 若全不选，则取消该行程打包
	 * 都则将该目的地或者出发地打包到该行程交通中
	 * @param model
	 * @param groupId
	 * @param productId
	 * @param checkValuesStr
	 * @return
	 * @throws BusinessException
	 */
	
	@RequestMapping(value = "/saveautoPackDistrictPoint")
	@ResponseBody
	public Object saveautoPackDistrictPoint(Model model, Long groupId,
			Long productId, String checkValuesStr,String uncheckValuesStr) throws BusinessException {
		if (groupId<=0 ||productId<=0) {
			return new ResultMessage("error", "参数错误！");
		}
		//全部选状态下，删除该段行程交通
		if (StringUtils.isEmpty(checkValuesStr)) {
			return this.deletePackGroup(model, groupId, ProdPackageGroup.GROUPTYPE.TRANSPORT.name(), productId);
		}
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("groupId", groupId); 
		List<ProdPackageGroupTransport> transportList = prodPackageGroupTransportService.selectByParams(params);
		params.clear();
		if (CollectionUtils.isEmpty(transportList)) {
			return new ResultMessage("error", "没有查询到相关数据！");
		}
		ProdPackageGroupTransport packTransport = transportList.get(0);
		params.clear();
		
		//得到当前出发地或者目的的的自动打包数据
		params.put("groupId", groupId);
		List<ProdPackageDetail> prodPackageDetails = prodPackageDetailService.findProdPackageDetailList(params);
		params.clear();
		//转换数据
		if (CollectionUtils.isEmpty(prodPackageDetails)) {
			return new ResultMessage("error", "没有查询到相关数据！");
		}
		getProdPackageDetails(prodPackageDetails);
		Map<String, ProdTraffic> trafficMap = new HashMap<String, ProdTraffic>();

		//过滤重复的地点
		for (ProdPackageDetail detail : prodPackageDetails) {
			ProdProductBranch branch = detail.getProdProductBranch();
			if (branch != null) {
				ProdProduct product = branch.getProduct();
				if (product != null) {
					ProdTraffic traffic = product.getProdTraffic();
					if (traffic != null) {
						trafficMap.put(traffic.getTrafficId().toString(), traffic);
					}
				}
			}
		}
		try {
			//处理添加数据到自动打包
			if (StringUtils.isNotEmpty(checkValuesStr)) {
				String[] checkValuesArr = checkValuesStr.split("[,]");
				for (String districtId : checkValuesArr) {
					ProdTraffic traffic = this.getTrafficInfoFromMapByDistrictId(trafficMap,districtId,packTransport);
					if (traffic!=null) {
						//已经存在了，不需要添加
						continue;
					}else {
						
						prodPackageGroupService.saveSingleAutoPackageDetail(productId,groupId,Long.valueOf(districtId));
					}
					
				}
			}
			//处理删除自动打包数据
			if (StringUtils.isNotEmpty(uncheckValuesStr)) {
				String[] uncheckValuesArr = uncheckValuesStr.split("[,]");
				for (String districtId : uncheckValuesArr) {
					ProdTraffic traffic = this.getTrafficInfoFromMapByDistrictId(trafficMap,districtId,packTransport);
					if (traffic==null) {
						//本身就没有，不需要删除
						continue;
					}else {
						prodPackageGroupService.deleteSingleAutoPackageDetail(productId,groupId,traffic);
					}
				}
				
			}
		} catch (BusinessException e) {
			log.error("目的地管理或者出发地管理保存失败，原因："+e.getMessage());
			return new ResultMessage("success", "保存失敗！");
		}
		
		return new ResultMessage("success", "保存成功");
	}
	
	private ProdTraffic getTrafficInfoFromMapByDistrictId(
			Map<String, ProdTraffic> trafficMap,String districtId,ProdPackageGroupTransport packTransport) {
		
		ProdTraffic traffic =null;
		if (trafficMap==null || trafficMap.size()<0) {
			return traffic;
		}
		for (String key : trafficMap.keySet()) {
			ProdTraffic tempTraffic = trafficMap.get(key);
			BizDistrict district = null;
			if (packTransport.getToDestination()!=null) {
				district = tempTraffic.getStartDistrictObj();
			}else {
				district = tempTraffic.getEndDistrictObj();
			}
			if (districtId.equals(district.getDistrictId().toString())) {
				traffic = tempTraffic;
				break;
			}
		}
		
		return traffic;
	}

	/**
	 * 封装交通信息的内容
	 * @param prodPackageDetails
	 */
	private void getProdPackageDetails(List<ProdPackageDetail> prodPackageDetails){
		List<Long> branchIds = new ArrayList<Long>();
		if(prodPackageDetails != null){
			Map<Long,ProdProductBranch> branchMap = new HashMap<Long,ProdProductBranch>();
			for (int i = 0; i < prodPackageDetails.size(); i++) {
				ProdPackageDetail detail = prodPackageDetails.get(i);
				Long productBranchId = detail.getObjectId();
				branchIds.add(productBranchId);
				if(i%200 == 0 || i == prodPackageDetails.size()-1){
					//批量查询产品规格
					Map<String,Object> branchParams = new HashMap<String,Object>();
					branchParams.put("productAndBranchIdList", branchIds);
					List<ProdProductBranch> branchs = prodProductBranchService.findProductBranchListByIds(branchParams);
					List<Long> productIds = new ArrayList<Long>();
					for (ProdProductBranch prodProductBranch : branchs) {
						productIds.add(prodProductBranch.getProductId());
					}
					//批量查询产品信息
					Map<String,Object> productParams = new HashMap<String,Object>();
					productParams.put("productIdList", productIds);
					List<ProdProduct> products = prodProductService.findProductByIds(productParams);
					Map<Long,ProdProduct> productMap = new HashMap<Long,ProdProduct>();
					for (ProdProduct prodProduct : products) {
						productMap.put(prodProduct.getProductId(), prodProduct);
					}
					//批量查询交通信息
					List<ProdTraffic> traffics = prodTrafficService.selectByProductIds(productParams);
					for (ProdTraffic traffic : traffics) {
						if (traffic.getStartDistrict() != null) {
							// 出发城市
							traffic.setStartDistrictObj(districtQueryMemService.findDistrictById(traffic
											.getStartDistrict()));
						}
						if (traffic.getEndDistrict() != null) {
							// 目的地城市
							traffic.setEndDistrictObj(districtQueryMemService.findDistrictById(traffic
											.getEndDistrict()));
						}
						ProdProduct prodProduct = productMap.get(traffic.getProductId());
						if(prodProduct !=null){
							prodProduct.setProdTraffic(traffic);
						}
					}
					for (ProdProductBranch prodProductBranch : branchs) {
						prodProductBranch.setProduct(productMap.get(prodProductBranch.getProductId()));
						branchMap.put(prodProductBranch.getProductBranchId(), prodProductBranch);
					}
					//清除数据，为下一次批量做准备
					branchIds.clear();
				}
			}
			for (ProdPackageDetail detail : prodPackageDetails) {
				detail.setProdProductBranch(branchMap.get(detail.getObjectId()));
			}
		}
	}

	/*将自动打包的单去程，单返程合并为往返程*/
	private void mergeAutoPackageGroup(List<ProdPackageGroup> packGroupList ,Map<String,Long> groupIds) {
		if(packGroupList == null || packGroupList.isEmpty()) {
			return ;
		}
		//将自动打包的group 找出来
		ProdPackageGroup autoPackageGroup = null;
		ProdPackageGroup autoPackageBackGroup = null;
		Pair<String, String> toPair = null;
		Pair<String, String> backPair = null;
		for(int index = packGroupList.size()-1; index >=0 ; index -- ) {
			ProdPackageGroup group = packGroupList.get(index);
			if (!ProdPackageGroup.GROUPTYPE.TRANSPORT.name().equals(group.getGroupType())) {
				continue;
			}
			ProdPackageGroupTransport transport = group.getProdPackageGroupTransport();
			boolean isToTrip = notZero(transport.getToStartPoint())  && notZero(transport.getToDestination());
			boolean isBackTrip = notZero(transport.getBackStartPoint())  && notZero(transport.getBackDestination());
			if("Y".equals(transport.getAutoPackage())) {
				if(isToTrip) {
					autoPackageGroup = group;
					groupIds.put("toGroupId", transport.getGroupId()) ;
				} else if(isBackTrip) {
					autoPackageBackGroup = group;
					groupIds.put("backGroupId", transport.getGroupId()) ;
				}
				packGroupList.remove(index);
			}
		}
		
		
		
		//去程
		if (autoPackageGroup!=null) {
			if (CollectionUtils.isNotEmpty(autoPackageGroup.getProdPackageDetails())) {
				
			//处理组上的出发地，将去程的出发地定位全国，目的地为选定的目的地，
			ProdPackageGroupTransport transport = autoPackageGroup.getProdPackageGroupTransport();
			BizDistrict china = new BizDistrict();
			china.setDistrictName("全国");
			transport.setToStartPointDistrict(china);
			
			//清空该组下其他的detail
			ProdPackageDetail detail = autoPackageGroup.getProdPackageDetails().get(0);
			autoPackageGroup.getProdPackageDetails().clear();
			autoPackageGroup.getProdPackageDetails().add(detail);
			
			ProdProductBranch branch = detail.getProdProductBranch();
			branch.setCategoryName("其他机票");
			branch.setProductName("全国对接机票");
			
			BizDistrict startDistrict = new BizDistrict();
			startDistrict.setDistrictName("全国");
			
			ProdTraffic traffic = prodTrafficService.selectByProductId(branch.getProductId());
			BizDistrict endDistrict = districtService.selectByPrimaryKey(traffic.getEndDistrict());
			traffic.setEndDistrictObj(endDistrict);
			traffic.setStartDistrictObj(startDistrict);
			
			branch.setProduct(new ProdProduct());
			branch.getProduct().setProdTraffic(traffic);
			
			//将不要显示的域置空
			branch.setProductBranchId(null);
			branch.setBranchName("");
			branch.setProductId(null);
			detail.setProdProductBranch(branch);
			
			packGroupList.add(autoPackageGroup);
			}
		}
		//返程
		if (autoPackageBackGroup!=null) {
			if (CollectionUtils.isNotEmpty(autoPackageBackGroup.getProdPackageDetails())) {
				
			//处理组上的出发地，将返程的目的地定位全国
			ProdPackageGroupTransport transport = autoPackageBackGroup.getProdPackageGroupTransport();
			BizDistrict china = new BizDistrict();
			china.setDistrictName("全国");
			transport.setBackDestinationDistrict(china);
			
			//清空该组下其他的detail
			ProdPackageDetail detail = autoPackageBackGroup.getProdPackageDetails().get(0);
			autoPackageBackGroup.getProdPackageDetails().clear();
			autoPackageBackGroup.getProdPackageDetails().add(detail);
			
			ProdProductBranch branch = detail.getProdProductBranch();
			branch.setCategoryName("其他机票");
			branch.setProductName("全国对接机票");
			
			BizDistrict endDistrict = new BizDistrict();
			endDistrict.setDistrictName("全国");
			
			ProdTraffic traffic = prodTrafficService.selectByProductId(branch.getProductId());
			BizDistrict startDistrict = districtService.selectByPrimaryKey(traffic.getStartDistrict());
			traffic.setStartDistrictObj(startDistrict);
			traffic.setEndDistrictObj(endDistrict);
			
			branch.setProduct(new ProdProduct());
			branch.getProduct().setProdTraffic(traffic);
			
			//将不要显示的域置空
			branch.setProductBranchId(null);
			branch.setBranchName("");
			branch.setProductId(null);
			detail.setProdProductBranch(branch);
			
			packGroupList.add(autoPackageBackGroup);
			}
		}
		
	}
	 
	/**
	 * 设置规格商品集合
	 * @param packGroupList
	 */
	public void setGoodsToPackGroupList(List<ProdPackageGroup> packGroupList) {
		if (packGroupList == null) return;
	for (ProdPackageGroup group : packGroupList) {
			List<ProdPackageDetail> prodPackageDetailList = group
					.getProdPackageDetails();
			if (CollectionUtils.isEmpty(prodPackageDetailList)) continue;
			String groupType = group.getGroupType();
			for (ProdPackageDetail detail : prodPackageDetailList) {
				//规格
				ProdProductBranch prodProductBranchBean = detail.getProdProductBranch();
				if (detail == null || prodProductBranchBean == null) continue;
				
				//规格商品集合
				List<ProdProductGoodsData> goodList = new ArrayList<ProdProductGoodsData>();
				ProdProductGoodsData good =null;
				
				// 1.获取系统逻辑下面的商品
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("productBranchId", prodProductBranchBean.getProductBranchId());
				params.put("onlineFlag", "Y");
				params.put("groupType", groupType);
				List<ProdProductGoodsBranchData> goodsBranchDataList = hotelGroupPackGoodslAdapterService.selectBranchGoodsByParams(params);
				//显示默认
				prodProductBranchBean.setWetherSystemLogic("无可售商品");
				if(CollectionUtils.isNotEmpty(goodsBranchDataList)){
					for(ProdProductGoodsBranchData pd:goodsBranchDataList){
						good = new ProdProductGoodsData();
						BeanUtils.copyProperties(pd, good);
						goodList.add(good);
						
						good = null;
					}
					prodProductBranchBean.setWetherSystemLogic("系统逻辑");
					prodProductBranchBean.setGoodsDataList(goodList);
				}
				//2.获取该规格下已经打包的商品(勾选)
				params.clear();
				Long detailId = detail.getDetailId();
				params.put("groupId", group.getGroupId());
				params.put("detailId", detailId);
				params.put("groupType", groupType);
				List<ProdPackageDetailGoodsData> prodPackageDetailGoodsDataList = prodPackageDetailGoodsAdapterService.selectPackagedGoodsByParams(params);
				if(CollectionUtils.isEmpty(prodPackageDetailGoodsDataList)) continue;
				//覆盖系统逻辑商品
				goodList.clear();
				StringBuilder sBuilder =new StringBuilder(156);
				for(ProdPackageDetailGoodsData pd:prodPackageDetailGoodsDataList){
					good = new ProdProductGoodsData();
					BeanUtils.copyProperties(pd, good);
					SuppGoods suppGoodsBean = MiscUtils.autoUnboxing(suppGoodsHotelAdapterService.findSuppGoodsById(pd.getSuppGoodsId()));
					if(suppGoodsBean != null){
						good.setGoodsName(suppGoodsBean.getGoodsName());
					}
					goodList.add(good);
					if(sBuilder.length() > 0) sBuilder.append(";");
					sBuilder.append(good.getGoodsName());
					
					good = null;
				}
				//显示所有
				prodProductBranchBean.setWetherSystemLogic(sBuilder.toString());
				prodProductBranchBean.setGoodsDataList(goodList);
				
				
				int i = 0;
				int j = 0;
				for(ProdPackageDetailGoodsData pd:prodPackageDetailGoodsDataList){
					good = new ProdProductGoodsData();
					BeanUtils.copyProperties(pd, good);
					SuppGoods suppGoodsBean = MiscUtils.autoUnboxing(suppGoodsHotelAdapterService.findSuppGoodsById(pd.getSuppGoodsId()));
					if(suppGoodsBean != null){
						//good.setGoodsName(suppGoodsBean.getGoodsName());
						// 必选打包规格状态与商品状态关联
						//1.若有一个打包商品状态为有效可售，则规格显示有效可售
						if ("Y".equalsIgnoreCase(suppGoodsBean.getCancelFlag()) && "Y".equalsIgnoreCase(suppGoodsBean.getOnlineFlag())) {
							prodProductBranchBean.setCancelFlag("Y");//把规格的打包状态设为有效
							prodProductBranchBean.setSaleFlag("Y");//把规格的打包状态设为有效
							i++;
							j++;
							break;
						}else {
							if ("Y".equalsIgnoreCase(suppGoodsBean.getCancelFlag())) {
								i++;
							}
							//商品是否可售
							if ("Y".equalsIgnoreCase(suppGoodsBean.getOnlineFlag())) {
								j++;
							}
						}
					}
					
				}
				if (i == 0) {
						prodProductBranchBean.setCancelFlag("N");
						prodProductBranchBean.setSaleFlag("N");
				}
				if(i >= 1 && j != 1){
						prodProductBranchBean.setCancelFlag("Y");
						prodProductBranchBean.setSaleFlag("N");
				}
				
				if (j ==0) {
					prodProductBranchBean.setSaleFlag("N");
				}
				
				
			}
		}
	}

	/**
	 * 添加打包组的弹出页面
	 * @param model
	 * @param productId 产品Id
	 * @param groupType 组类型
	 * @param req 请求对象
	 * @return
	 * @throws BusinessException
     */
	@RequestMapping(value = "/showAddGroup")
	public String showAddGroup(Model model, Long productId, String groupType,
			HttpServletRequest req) throws BusinessException {

		List<BizCategory> bizCategoryList = bizCategoryQueryService
				.getAllValidCategorys();
		model.addAttribute("bizCategoryList", bizCategoryList);

		model.addAttribute("groupType", groupType);
		model.addAttribute("productId", productId);
		model.addAttribute("selectCategoryId",
				req.getParameter("selectCategoryId"));
		model.addAttribute("routeNum", req.getParameter("routeNum"));
		model.addAttribute("stayNum", req.getParameter("stayNum"));
		model.addAttribute("destId", req.getParameter("destId"));
		if (ProdPackageGroup.GROUPTYPE.HOTEL.name().equalsIgnoreCase(groupType)) {
			return "/pack/line/showAddGroupHotel";
		} else if (ProdPackageGroup.GROUPTYPE.LINE.name().equalsIgnoreCase(
				groupType)) {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("productId", productId);
			params.put("groupType", groupType);
			params.put("categoryId", 17);
			List<ProdPackageGroup> prodPackageGroups = prodLineGroupPackService
					.findProdLinePackGroupByParams(params);
			ProdPackageGroupLine prodPackageGroupLine = null;
			if (CollectionUtils.isNotEmpty(prodPackageGroups)) {
				prodPackageGroupLine = prodPackageGroups.get(0)
						.getProdPackageGroupLine();
			}
			model.addAttribute("prodPackageGroupLine", prodPackageGroupLine);
			return "/pack/line/showAddGroupLine";
		} else if (ProdPackageGroup.GROUPTYPE.LINE_TICKET.name()
				.equalsIgnoreCase(groupType)) {
			return "/pack/line/showAddGroupTicket";
		} else if (ProdPackageGroup.GROUPTYPE.CHANGE.name().equalsIgnoreCase(
				groupType)) {
			return "/goods/tour/goods/showAddGroupChangedHotel";
		} else if (ProdPackageGroup.GROUPTYPE.TRANSPORT.name()
				.equalsIgnoreCase(groupType)) {
			// 将是否为多出发地标记传入页面
			ProdProduct product = prodProductService
					.getProdProductBy(productId);
			model.addAttribute("isMuiltDparture",
					product.getMuiltDpartureFlag());

			// 将交通组下的二级品类传入页面
			String productType = product.getProductType();
			String BU = product.getBu();
			Long categoryId_ = product.getBizCategoryId();
			if(("INNERLINE".equalsIgnoreCase(productType) 
					|| "INNERSHORTLINE".equalsIgnoreCase(productType) 
					|| "INNERLONGLINE".equalsIgnoreCase(productType)
					|| "INNER_BORDER_LINE".equalsIgnoreCase(productType))
					&& categoryId_ !=null && categoryId_ != 15L){
				BizEnum.BIZ_CATEGORY_TYPE[] traffics = {
						BizEnum.BIZ_CATEGORY_TYPE.category_traffic_aero_other,
						//BizEnum.BIZ_CATEGORY_TYPE.category_traffic_train_other, //去掉其他火车票(http://ipm.lvmama.com/index.php?m=story&f=view&id=15186)
						BizEnum.BIZ_CATEGORY_TYPE.category_traffic_ship_other,
						BizEnum.BIZ_CATEGORY_TYPE.category_traffic_bus_other };
				model.addAttribute("twoLevelTraffics", traffics);
			}else{
				BizEnum.BIZ_CATEGORY_TYPE[] traffics = {
						BizEnum.BIZ_CATEGORY_TYPE.category_traffic_aero_other,
						BizEnum.BIZ_CATEGORY_TYPE.category_traffic_train_other,
						BizEnum.BIZ_CATEGORY_TYPE.category_traffic_ship_other,
						BizEnum.BIZ_CATEGORY_TYPE.category_traffic_bus_other };
				model.addAttribute("twoLevelTraffics", traffics);
			}
			model.addAttribute("BU", product.getBu());
			return "/pack/line/showAddGroupTransport";
		}

		return "";
	}
	/**
	 * 获得基础信息中目的地所在的城市
	 * @param model
	 * @param destId
	 * @param req
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/getCityBizDest")
	public void getCityBizDest(Model model, String destId,
			HttpServletRequest req) throws BusinessException {
		String destType = BizDest.DEST_TYPE.CITY.toString();
		List<BizDest> bizDestList = destService.selectOnlyParentByDestId(destId, destType);
		if (bizDestList!=null&&bizDestList.size()>0) {
			BizDest bizDest = bizDestList.get(0);
			BizDistrict bizDistrict = districtService.selectByPrimaryKey(bizDest.getDistrictId());
			bizDest.setDestName(bizDistrict.getDistrictName());
			String json = JSONObject.fromObject(bizDest).toString();
			this.sendAjaxResultByJson(json, HttpServletLocalThread.getResponse());
		}
		
	}

	/**
	 * 根据品类和所属BU查询城市组信息
	 * 
	 * @param id
	 */
	@RequestMapping(value = "/getCityGroupByCategoryId.do")
	@ResponseBody
	public void getCityGroupByCategoryId(String categoryId, String BU) {
		if (!"".equals(categoryId) && !"".equals(BU)) {
			Map<String, Object> params = new HashMap<String, Object>();
			Map<String, String> map = new HashMap<String, String>();
			params.put("categoryId", categoryId);
			params.put("buCode", BU);
			List<BizCitygroup> bizCitygroupList = citygroupService
					.findCitygroupList(params);
			if (!bizCitygroupList.isEmpty()) {
				for (BizCitygroup city : bizCitygroupList) {
					map.put(city.getCityGroupId().toString(),
							city.getCityGroupName());
				}
			}
			String json = JSONObject.fromObject(map).toString();
			this.sendAjaxResultByJson(json, HttpServletLocalThread.getResponse());

		}
	}

	/**
	 * 根据cityGroupId查询城市组城市
	 * 
	 * @param cityGroupId
	 */
	@RequestMapping(value = "/getCityGroupBycityGroupId.do")
	@ResponseBody
	public void getCityGroupBycityGroupId(String cityGroupId) {
		if (!"".equals(cityGroupId)) {
			BizCitygroup citygroup = citygroupService.findCitygroupById(Long
					.parseLong(cityGroupId));
			if (citygroup != null) {
				Map<String, Object> map = citygroup.getCityContentMap();
				String json = JSONObject.fromObject(map).toString();
				this.sendAjaxResultByJson(json, HttpServletLocalThread.getResponse());
			}
		}
	}

	/***
	 * 添加组
	 * 
	 * @param model
	 * @param prodPackageGroup
	 * @param productId
	 * @param groupType
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/addGroup")
	@ResponseBody
	public Object addGroup(Model model, ProdPackageGroup prodPackageGroup,
			Long productId, String groupType, String multiToStartPointIds)
			throws BusinessException {

		Long selectCategoryId = prodPackageGroup.getSelectCategoryId();
		BizCategory selectBizCategory = bizCategoryQueryService
				.getCategoryById(selectCategoryId);
		ProdProduct product = prodProductService
				.getProdProductBy(productId);
		String isMuiltDparture = product.getMuiltDpartureFlag();

		String stayDays = "";
		String travelDays = "";
		// 只对线路 酒店 可换酒店验证
		if (StringUtil.isNotEmptyString(groupType)
				&& !ProdPackageGroup.GROUPTYPE.LINE_TICKET.name()
						.equalsIgnoreCase(groupType)
				&& !"category_route_local".equalsIgnoreCase(selectBizCategory
						.getCategoryCode())
				&& !(selectBizCategory.getCategoryCode().indexOf(
						"category_traffic") >= 0)) {
			// 线路
			if (StringUtil.isNotEmptyString(groupType)
					&& ProdPackageGroup.GROUPTYPE.LINE.name().equalsIgnoreCase(
							groupType)) {

				if (prodPackageGroup.getProdPackageGroupLine() != null) {
					travelDays = prodLineGroupPackService.findLineStayDays(
							prodPackageGroup.getProdPackageGroupLine(), "1");
					if (StringUtil.isEmptyString(travelDays)) {
						return new ResultMessage("error", "请检查行程天数");
					}

					if (!"category_route_local"
							.equalsIgnoreCase(selectBizCategory
									.getCategoryCode())) {
						stayDays = prodLineGroupPackService
								.findLineStayDays(prodPackageGroup
										.getProdPackageGroupLine(), "2");
						if (StringUtil.isEmptyString(stayDays)) {
							return new ResultMessage("error", "请检查入住晚数");
						}
					}
				}
				// 酒店 可换酒店
			} else if (ProdPackageGroup.GROUPTYPE.CHANGE.name()
					.equalsIgnoreCase(groupType)
					|| ProdPackageGroup.GROUPTYPE.HOTEL.name()
							.equalsIgnoreCase(groupType)) {
				if (prodPackageGroup.getProdPackageGroupHotel() != null) {
					stayDays = prodPackageGroup.getProdPackageGroupHotel()
							.getStayDays();
				}
			}

			String conflictTime = prodLineGroupPackService
					.validateAddPackGroup(productId, selectCategoryId,
							stayDays, travelDays, groupType);
			if (StringUtil.isNotEmptyString(conflictTime)) {
				return new ResultMessage("error", "插入时间段与 " + conflictTime
						+ " 冲突");
			}
		}

		if (ProdPackageGroup.GROUPTYPE.TRANSPORT.name().equalsIgnoreCase(
				groupType)) {

			if ("N".equals(isMuiltDparture)) {
				// 线路验证时间+出发地+目的地不能重复
				Long toStartPoint = prodPackageGroup
						.getProdPackageGroupTransport().getToStartPoint();
				Long toDestination = prodPackageGroup
						.getProdPackageGroupTransport().getToDestination();
				Long toStartDays = prodPackageGroup
						.getProdPackageGroupTransport().getToStartDays();
				Long backStartPoint = prodPackageGroup
						.getProdPackageGroupTransport().getBackStartPoint();
				Long backDestination = prodPackageGroup
						.getProdPackageGroupTransport().getBackDestination();
				Long backStartDays = prodPackageGroup
						.getProdPackageGroupTransport().getBackStartDays();
				String toKey = "";
				String backKey = "";
				if (toStartPoint != null && toDestination != null
						&& toStartDays != null) {
					toKey = String.valueOf(toStartPoint)
							+ String.valueOf(toDestination)
							+ String.valueOf(toStartDays);
				}
				if (backStartPoint != null && backDestination != null
						&& backStartDays != null) {
					backKey = String.valueOf(backStartPoint)
							+ String.valueOf(backDestination)
							+ String.valueOf(backStartDays);
				}
				if (toKey.equals(backKey)) {
					return new ResultMessage("error", "去程和返程（时间+出发地+目的地）不能重复录入");
				}
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("groupType", groupType);
				params.put("productId", productId);
				List<ProdPackageGroup> prodPackageGroupList = prodLineGroupPackService
						.findProdLinePackGroupByParams(params);
				if (prodPackageGroupList != null
						&& prodPackageGroupList.size() > 0) {
					for (ProdPackageGroup prodPackageGroup2 : prodPackageGroupList) {
						if (prodPackageGroup.getProdPackageGroupTransport() != null) {
							Long toStartPoint2 = prodPackageGroup2
									.getProdPackageGroupTransport()
									.getToStartPoint();
							Long toDestination2 = prodPackageGroup2
									.getProdPackageGroupTransport()
									.getToDestination();
							Long toStartDays2 = prodPackageGroup2
									.getProdPackageGroupTransport()
									.getToStartDays();
							Long backStartPoint2 = prodPackageGroup2
									.getProdPackageGroupTransport()
									.getBackStartPoint();
							Long backDestination2 = prodPackageGroup2
									.getProdPackageGroupTransport()
									.getBackDestination();
							Long backStartDays2 = prodPackageGroup2
									.getProdPackageGroupTransport()
									.getBackStartDays();
							String toKey2 = "";
							String backKey2 = "";
							if (toStartPoint2 != null && toDestination2 != null
									&& toStartDays2 != null) {
								toKey2 = String.valueOf(toStartPoint2)
										+ String.valueOf(toDestination2)
										+ String.valueOf(toStartDays2);
							}
							if (backStartPoint2 != null
									&& backDestination2 != null
									&& backStartDays2 != null) {
								backKey2 = String.valueOf(backStartPoint2)
										+ String.valueOf(backDestination2)
										+ String.valueOf(backStartDays2);
							}

							if (toKey.equals(toKey2)
									&& backKey.equals(backKey2)) {
								return new ResultMessage("error",
										"交通组(时间+出发地+目的地+交通类型)不能重复插入");
							}
						}
					}
				}
			} else if ("Y".equals(isMuiltDparture)) {
				// 为多出发地时存储信息进行验证，并根据多出发地id集合，重新为prodPackageGroup赋值
				Map<String, Object> bulidResultMap = this
						.buildPackageGroupTransport(
								prodPackageGroup.getProdPackageGroupTransport(),
								productId, multiToStartPointIds);
				String errorMessage = (String) bulidResultMap.get("error");
				if (StringUtil.isNotEmptyString(errorMessage)) {
					return new ResultMessage("error", errorMessage);
				} else {
					prodPackageGroup
							.setProdPackageGroupTransport((ProdPackageGroupTransport) bulidResultMap
									.get("packageGroupTransport"));
				}
			} else {
				return new ResultMessage("error", "无法确认是否为多出发地");
			}
		}

		//添加组的时候发送消息，触发job计算可售
		if ("Y".equalsIgnoreCase(isMuiltDparture)) {
			pushAdapterService.push(productId,
					ComPush.OBJECT_TYPE.PRODUCT,
					ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP,
					ComPush.OPERATE_TYPE.UP,
					ComIncreament.DATA_SOURCE_TYPE.TRANS_API_JOB);
		} else {
			pushAdapterService.push(productId,
					ComPush.OBJECT_TYPE.PRODUCT,
					ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP,
					ComPush.OPERATE_TYPE.UP,
					ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
		}
		
		if (selectBizCategory != null) {
			prodPackageGroup.setGroupName(selectBizCategory.getCategoryName());
		}

		if (ProdPackageGroup.GROUPTYPE.CHANGE.name()
				.equalsIgnoreCase(groupType)) {
			prodPackageGroup.setGroupName(ProdPackageGroup.GROUPTYPE.CHANGE
					.name());
			prodPackageGroup.setSelectType(ProdPackageGroup.SELECTTYPE.ONE
					.name());
		}

		Long groupId = prodLineGroupPackService.addProdLinePackGroup(
				prodPackageGroup, groupType);

		//给分销商 分发消息
		this.handOut4Group(product.getBizCategoryId(),productId,String.valueOf(groupId),groupType,
				ComPush.OPERATE_TYPE.ADD.name());

		// 添加操作日志
		try {
			String log = getPackGroupAddString(prodPackageGroup);
			if (StringUtil.isNotEmptyString(log)) {
				comLogService.insert(
						COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP,
						productId, productId,
						this.getLoginUser().getUserName(), "创建组：" + log,
						COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP.name(),
						"创建组", null);
			}
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"
					+ COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
			log.error(e.getMessage());
		}

		Map<String, Object> attributes = new HashMap<String, Object>();
		attributes.put("productId", productId);
		attributes.put("groupType", groupType);
		attributes.put("groupId", groupId);
		attributes.put("selectCategoryId", selectCategoryId);

		return new ResultMessage(attributes, "success", "保存成功");
	}
	
	/**
	 * 检查当前产品是否存在自动打包并在前端页面提示相应的信息
	 * @param model
	 * @param prodPackageGroup
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/checkAutoPackGroup")
	@ResponseBody
	public Object checkAutoPackGroup(Model model, ProdPackageGroup prodPackageGroup,String type)
			throws BusinessException {
		if (prodPackageGroup == null) {
			return new ResultMessage("error", "组信息不能为空！");
		}
		if (prodPackageGroup.getProdPackageGroupTransport() == null) {
			return new ResultMessage("error", "交通组信息不能为空！");
		}
		ProdPackageGroupTransport prodPackageGroupTransport = prodPackageGroup.getProdPackageGroupTransport();
		
		Map<String, Object> params = new HashMap<String, Object>();
		//查询产品规格数据,判断是去程还是返程
		if (prodPackageGroupTransport.getToDestination()!=null) {
			params.put("districtId",prodPackageGroupTransport.getToDestination());
			params.put("startOrEnd", "end");   
			if (CollectionUtils.isEmpty(productBranchService.getAutopackageBranchByDistrict(params))) {
				return new ResultMessage("error", "没有查询到该行程下的产品规格信息！");
			}
		}
		if (prodPackageGroupTransport.getBackStartPoint()!=null) {
			params.put("districtId", prodPackageGroupTransport.getBackStartPoint());
			params.put("startOrEnd", "start");
			if (CollectionUtils.isEmpty(productBranchService.getAutopackageBranchByDistrict(params))) {
				return new ResultMessage("error", "没有查询到该行程下的产品规格信息！");
			}
		}
		params.clear();
		//检查当前目的地下是否存在全国出发自动打包的交通组信息
		params.put("productId", prodPackageGroup.getProductId()); 
		List<ProdPackageGroup> groupList = prodPackageGroupService.findProdPackageGroupByParams(params, true, false);
		params.clear();
		boolean toFlag =false;
		boolean backFlag =false;
		if (!CollectionUtils.isEmpty(groupList)) {
			for (ProdPackageGroup group : groupList) {
				params.put("groupId", group.getGroupId()); 
				List<ProdPackageGroupTransport> transportList = prodPackageGroupTransportService.selectByParams(params);
				if (CollectionUtils.isNotEmpty(transportList)) {
					ProdPackageGroupTransport packTransport = transportList.get(0);
					if ("Y".equalsIgnoreCase(packTransport.getAutoPackage()) && packTransport.getToStartPoint()!=null) {
						toFlag =  true;
					}
					if ("Y".equalsIgnoreCase(packTransport.getAutoPackage()) && packTransport.getBackStartPoint()!=null) {
						backFlag =  true;
					}
				}
			}

			if (StringUtil.isEmptyString(type)
					|| "undefined".equalsIgnoreCase(type)) {
				if (toFlag && backFlag) {
					return new ResultMessage("success", "当前产品已存在自动打包往返程交通组信息，继续保存将替换掉当前行程的交通组，是否确认保存？");
				}
				if (toFlag && !backFlag) {
					return new ResultMessage("success", "当前产品已存在自动打包去程交通组信息，继续保存将替换掉当前行程的交通组，是否确认保存？");
				}
				if (!toFlag && backFlag) {
					return new ResultMessage("success", "当前产品已存在自动打包返程交通组信息，继续保存将替换掉当前行程的交通组，是否确认保存？");
				}
			}else if ("TO".equals(type)) {
				if (toFlag) {
					return new ResultMessage("success", "当前产品已存在自动打包去程交通组信息，继续保存将替换掉当前行程的交通组，是否确认保存？");
				}
			}else if ("BACK".equals(type)) {
				if (backFlag) {
					return new ResultMessage("success", "当前产品已存在自动打包返程交通组信息，继续保存将替换掉当前行程的交通组，是否确认保存？");
				}
			}
			
		}
		
		return null;
	}
	
	/**
	 * 往返程+其他机票+自动打包时，添加组信息
	 * @param model
	 * @param prodPackageGroup
	 * @param multiToStartPointIds
	 * @param toStartTimeBegin
	 * @param toStartTimeEnd
	 * @param backStartTimeBegin
	 * @param backStartTimeEnd
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/tobackAutoPackAddGroup")
	@ResponseBody
	public Object tobackAutoPackAddGroup(Model model, ProdPackageGroup prodPackageGroup,
			String toStartTimeBegin,String toStartTimeEnd,
			String backStartTimeBegin,String backStartTimeEnd)
			throws BusinessException {
		if (prodPackageGroup == null) {
			return new ResultMessage("error", "组信息不能为空！");
		}
		if (prodPackageGroup.getProdPackageGroupTransport() == null) {
			return new ResultMessage("error", "交通组信息不能为空！");
		}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		ProdPackageGroupTransport prodPackageGroupTransport = prodPackageGroup.getProdPackageGroupTransport();
		Map<String, Object> params = new HashMap<String, Object>();
		//检查当前目的地下是否存在全国出发自动打包的交通组信息
		params.put("productId", prodPackageGroup.getProductId()); 
		List<ProdPackageGroup> groupList = prodPackageGroupService.findProdPackageGroupByParams(params, true, false);
		params.clear();
		if (!CollectionUtils.isEmpty(groupList)) {
			for (ProdPackageGroup group : groupList) {
				params.put("groupId", group.getGroupId()); 
				List<ProdPackageGroupTransport> transportList = prodPackageGroupTransportService.selectByParams(params);
				if (CollectionUtils.isNotEmpty(transportList)) {
					ProdPackageGroupTransport packTransport = transportList.get(0);
					if ("Y".equalsIgnoreCase(packTransport.getAutoPackage())) {
						if ("TOBACK".equals(prodPackageGroupTransport.getTransportType())) {
							//删两个
							this.deletePackGroup(model, packTransport.getGroupId(), prodPackageGroup.getGroupType(), prodPackageGroup.getProductId());
						}else{
							//删一个
							if (prodPackageGroupTransport.getBackStartPoint()==null && packTransport.getToStartPoint()!=null) {
								//删除TO
								this.deletePackGroup(model, packTransport.getGroupId(), prodPackageGroup.getGroupType(), prodPackageGroup.getProductId());
							}
							if (prodPackageGroupTransport.getToDestination()==null && packTransport.getBackStartPoint()!=null) {
								//删除BACK
								this.deletePackGroup(model, packTransport.getGroupId(), prodPackageGroup.getGroupType(), prodPackageGroup.getProductId());
							}
						}
					}
				}
			}
		}
		// 校验packageGroupTransport里的信息是否正确
		String validateResult = this.validateMultiPackageGroupTransport(
				prodPackageGroupTransport, prodPackageGroup.getProductId());
		
		if (StringUtil.isNotEmptyString(validateResult)) {
			return new ResultMessage("error", validateResult);
		}
		//处理时间格式为：hh:mm
		toStartTimeBegin = AutoPackageUtil.getStandTime(toStartTimeBegin,true);
		toStartTimeEnd = AutoPackageUtil.getStandTime(toStartTimeEnd,false);
		backStartTimeBegin = AutoPackageUtil.getStandTime(backStartTimeBegin,true);
		backStartTimeEnd = AutoPackageUtil.getStandTime(backStartTimeEnd,false);
		
		ProdPackageGroup prodPackageGroup2 = null;
			
		prodPackageGroup.setGroupName(BizEnum.BIZ_CATEGORY_TYPE.category_traffic.getCnName());
		//去程prodPackageGroup
		prodPackageGroupTransport.setTimeBegin(toStartTimeBegin);
		prodPackageGroupTransport.setTimeEnd(toStartTimeEnd);
		//往返程保存两个交通组
		if ("TOBACK".equals(prodPackageGroupTransport.getTransportType())) {
			prodPackageGroupTransport.setTransportType(ProdPackageGroupTransport.TRANSPORTTYPE.TO.name());
			//返程prodPackageGroup
			prodPackageGroup2 = new ProdPackageGroup();
			BeanUtils.copyProperties(prodPackageGroup, prodPackageGroup2);
			ProdPackageGroupTransport prodPackageGroupTransport2 = new ProdPackageGroupTransport();
			BeanUtils.copyProperties(prodPackageGroupTransport, prodPackageGroupTransport2);
			prodPackageGroupTransport2.setTimeBegin(backStartTimeBegin);
			prodPackageGroupTransport2.setTimeEnd(backStartTimeEnd);
			//设置返程目的地为空，返程出发地为去程目的地
			prodPackageGroupTransport2.setToDestination(null);
			prodPackageGroupTransport2.setBackStartPoint(prodPackageGroupTransport.getToDestination());
			prodPackageGroup2.setProdPackageGroupTransport(prodPackageGroupTransport2);
		}else{
			//出发地不为空，说明为单程返程，只保存返程信息，否则保存去程信息
			prodPackageGroupTransport.setTransportType(ProdPackageGroupTransport.TRANSPORTTYPE.TO.name());
			if (prodPackageGroupTransport.getBackStartPoint()!=null) {
				prodPackageGroup.setGroupName(BizEnum.BIZ_CATEGORY_TYPE.category_traffic.getCnName());
				//去程prodPackageGroup
				prodPackageGroupTransport.setTimeBegin(backStartTimeBegin);
				prodPackageGroupTransport.setTimeEnd(backStartTimeEnd);
			}
			
		}
		
		//插入往返程自动打包组信息
		Pair<Long, Long>  pair = prodPackageGroupService.insertAutopackageInfo2(prodPackageGroup,prodPackageGroup2);
		if(pair.getFirst() != null) {
			prodPackageGroup.setGroupId(pair.getFirst());
		}
		if(pair.getSecond() != null) {
			prodPackageGroup2.setGroupId(pair.getSecond());
		}
//		if (StringUtil.isNotEmptyString(message)) {
//			return new ResultMessage("error", message);
//		}
		if (prodPackageGroup2 != null) {
			resultMap.put("toGroupId", prodPackageGroup.getGroupId());
			resultMap.put("backGroupId", prodPackageGroup2.getGroupId());
		}else {
			if (prodPackageGroupTransport.getBackStartPoint()==null) {
				resultMap.put("toGroupId", prodPackageGroup.getGroupId());
			}else {
				resultMap.put("backGroupId", prodPackageGroup.getGroupId());
			}
		}
		resultMap.put("groupType", prodPackageGroup.getGroupType());

		return new ResultMessage(resultMap, "success", "保存成功");

	}

	/**
	 * 重新构建packageGroupTransport信息
	 * 
	 * @param packageGroupTransport
	 *            页面传来的packageGroupTransport信息
	 * @param multeToStartPointIds
	 *            多出发地id字符串（ , 分割）
	 * @return
	 */
	private Map<String, Object> buildPackageGroupTransport(
			ProdPackageGroupTransport packageGroupTransport, Long productId,
			String multeToStartPointIds) {
		Map<String, Object> resultMap = new HashMap<String, Object>();

		// 校验packageGroupTransport里的信息是否正确
		String validateResult = this.validateMultiPackageGroupTransport(
				packageGroupTransport, productId);

		if (StringUtil.isNotEmptyString(validateResult)) {
			resultMap.put("error", validateResult);
			return resultMap;
		}

		if (StringUtil.isEmptyString(multeToStartPointIds)) {
			resultMap.put("error", "出发地不能为空！");
			return resultMap;
		}

		String[] strToStartPointIds = multeToStartPointIds.split(",");
		Long[] longToStartPointIds = this
				.stringArrToLongArr(strToStartPointIds);

		// packageGroupTransport.setToStartPointIds(longToStartPointIds);//设置多出发地的id组信息
		if (longToStartPointIds == null || longToStartPointIds.length == 0) {
			resultMap.put("error", "多出发地id数组不能为空！");
			return resultMap;
		}

		packageGroupTransport.setToStartPointIds(longToStartPointIds);// 设置多出发地的id组信息

		// 如果是往返程
		if (ProdPackageGroupTransport.TRANSPORTTYPE.TOBACK.name()
				.equalsIgnoreCase(packageGroupTransport.getTransportType())) {
			packageGroupTransport.setToStartPoint(longToStartPointIds[0]);// 类型为往返值时，规定将多出发id集合的第一个值放入
			packageGroupTransport.setBackDestination(longToStartPointIds[0]);

			Long backStartPoint = packageGroupTransport.getBackStartPoint();
			if (backStartPoint == null) {
				packageGroupTransport.setBackStartPoint(packageGroupTransport.getToDestination());// 返程出发地等于去程的目的地
			}
		}// 如果是单程
		else if (ProdPackageGroupTransport.TRANSPORTTYPE.TO.name()
				.equalsIgnoreCase(packageGroupTransport.getTransportType())) {
			// 获得单程的 去程目的地，来判断是单程的去程or返程
			Long toDestination = packageGroupTransport.getToDestination();
			if (toDestination == null || toDestination == 0L) {// 为单程的返程
				packageGroupTransport
						.setBackDestination(longToStartPointIds[0]);
			} else {// 为单程的去程
				packageGroupTransport.setToStartPoint(longToStartPointIds[0]);
			}
		}

		resultMap.put("success", "验证通过");
		resultMap.put("packageGroupTransport", packageGroupTransport);
		return resultMap;
	}

	/**
	 * 校验packageGroupTransport里的信息是否正确（多出发地情况时适用）
	 * 
	 * @param packageGroupTransport
	 * @return 错误信息（为空代表正确）
	 */
	private String validateMultiPackageGroupTransport(
			ProdPackageGroupTransport packageGroupTransport, Long productId) {

		if (packageGroupTransport == null) {
			return "系统未接收到打包的交通信息！";
		}

		if (productId == null) {
			return "系统未接到产品编号信息！";
		}

		// Long toStartPoint = packageGroupTransport.getToStartPoint();//去程出发地id
		Long toDestination = packageGroupTransport.getToDestination();// 去程目的地id
		Long toStartDays = packageGroupTransport.getToStartDays();// 去程第几天出发

		Long backStartPoint = packageGroupTransport.getBackStartPoint();// 反程出发地id
		// Long backDestination =
		// packageGroupTransport.getBackDestination();//反程目的地id
		Long backStartDays = packageGroupTransport.getBackStartDays();// 反程第几天出发

		/* 1. 验证多出发地打包组基础信息 */
		/*
		 * 2.多出发地时，对于一个含大交通的线路产品只能下面三种交通组情况： （1）只能存在一组往返程 （2）只能存在一组单程去程
		 * （3）只能存在一组单程的去程 + 单程的返程
		 */

		// 该方法用于获得当前对于某个含大交通产品下已有的交通组信息情况
		Map<String, Boolean> existStatusMap = this
				.getPackageGroupDataSituation(productId);

		// 已存在往返程
		boolean existToBack = (Boolean) existStatusMap.get("existToBack");
		// 已存在单程去程
		boolean existSingleTo = (Boolean) existStatusMap.get("existSingleTo");
		// 已存在单程返程
		boolean existSingleBack = (Boolean) existStatusMap
				.get("existSingleBack");

		// 如果是往返程
		if (ProdPackageGroupTransport.TRANSPORTTYPE.TOBACK.name()
				.equalsIgnoreCase(packageGroupTransport.getTransportType())) {
			if (!"Y".equalsIgnoreCase(packageGroupTransport.getAutoPackage())) {
				if (toStartDays == null || backStartDays == null) {
					return "往返程时，去、反程出发天数均不能为空！";
				}
				if (toDestination == null) {
					return "往返程时，去程目的地不能为空！";
				}
				
				if (existToBack) {
					return "只能存在一组往返程交通组信息";
				}
			}
		} // 如果是单程
		else if (ProdPackageGroupTransport.TRANSPORTTYPE.TO.name()
				.equalsIgnoreCase(packageGroupTransport.getTransportType())) {
			if (toDestination != null && backStartPoint != null) {
				return "单程时，去程目的地和返程出发地不能同时存在！";
			}
			if (!"Y".equalsIgnoreCase(packageGroupTransport.getAutoPackage())) {
				if (toDestination == null || toDestination == 0L) {// 为单程的返程
					if (backStartDays == null) {
						return "单程返程时，反程出发天数不能为空！";
					}
					
					if (existSingleBack) {
						return "只能存在一组单程返程交通组";
					}
				} else {// 为单程的去程
					if (toStartDays == null) {
						return "单程去程时，去程出发天数不能为空！";
					}
					
					if (existSingleTo) {
						return "只能存在一组单程去程交通组";
					}
				}
			}

		} else {
			return "交通类型有误，接收到的交通类型为："
					+ packageGroupTransport.getTransportType();
		}

		return "";
	}

	/**
	 * 该方法用于获得当前对于某个含大交通产品下已有的交通组信息情况
	 * 
	 * @param productId
	 *            产品id
	 * @return 是否已存在 往返程、单程去程、单程返程。
	 */
	private Map<String, Boolean> getPackageGroupDataSituation(Long productId) {
		Map<String, Boolean> resultMap = new HashMap<String, Boolean>();
		// 已存在往返程
		boolean existToBack = false;
		// 已存在单程去程
		boolean existSingleTo = false;
		// 已存在单程返程
		boolean existSingleBack = false;

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productId", productId);
		List<ProdPackageGroup> packageGroupList = prodPackageGroupService
				.findProdPackageGroup(params);
		if (CollectionUtils.isNotEmpty(packageGroupList)) {
			for (ProdPackageGroup packageGroup : packageGroupList) {
				params.clear();
				params.put("groupId", packageGroup.getGroupId());
				List<ProdPackageGroupTransport> packageGroupTransportList = prodPackageGroupTransportService
						.selectByParams(params);
				if (CollectionUtils.isNotEmpty(packageGroupTransportList)) {
					ProdPackageGroupTransport transport = packageGroupTransportList
							.get(0);// PackageGroup与PackageGroupTransport为1:1关系
					//自动打包时因为插入的是两条TO的单程信息，故，在此做一次过滤
					if ("Y".equalsIgnoreCase(transport.getAutoPackage())) {
						continue;
					}
					if (ProdPackageGroupTransport.TRANSPORTTYPE.TOBACK.name()
							.equalsIgnoreCase(transport.getTransportType())) {
						existToBack = true;
					} else if (ProdPackageGroupTransport.TRANSPORTTYPE.TO
							.name().equalsIgnoreCase(
									transport.getTransportType())
							&& transport.getToStartPoint() != null) {
						existSingleTo = true;
					} else if (ProdPackageGroupTransport.TRANSPORTTYPE.TO
							.name().equalsIgnoreCase(
									transport.getTransportType())
							&& transport.getBackStartPoint() != null) {
						existSingleBack = true;
					}
				}
			}
		}

		resultMap.put("existToBack", existToBack);
		resultMap.put("existSingleTo", existSingleTo);
		resultMap.put("existSingleBack", existSingleBack);

		return resultMap;
	}

	/**
	 * 将string数组转化为Long类型的数组
	 * 
	 * @param stringArray
	 * @return 转换好的Long类型的数组
	 */
	public Long[] stringArrToLongArr(String[] stringArray) {
		if (stringArray == null || stringArray.length < 1) {
			return null;
		}
		Long longArray[] = new Long[stringArray.length];
		for (int i = 0; i < longArray.length; i++) {
			try {
				longArray[i] = Long.valueOf(stringArray[i]);
			} catch (NumberFormatException e) {
				longArray[i] = 0L;
				continue;
			}
		}
		return longArray;
	}

	/**
	 * 根据产品id号，查找是否存在单程去程的打包交通组，若存获取出发地目的地信息，不存在提示前台
	 * 
	 * @param productId
	 *            产品编号
	 * @return 查询结果，若存获取出发地目的地信息，不存在提示前台
	 */
	@RequestMapping(value = "/getToPackageGroupTransport")
	@ResponseBody
	public Object getToPackageGroupTransport(Long productId) {
		if (productId == null) {
			return new ResultMessage("error", "productId不能为空！");
		}

		// 根据产品id，获得第一个单程去程的交通组
		ProdPackageGroupTransport transport = this
				.getFirstSingleToPackageGroupTransport(productId);

		if (transport != null && !"Y".equalsIgnoreCase(transport.getAutoPackage())) {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("groupId", transport.getGroupId());
			List<ProdStartDistrictDetail> startDistrictDetailList = prodStartDistrictDetailService
					.findStartDistrictDetailListByParams(params);

			// 传入页面的返程的多目的地
			List<BizDistrict> backDestDistricts = new ArrayList<BizDistrict>();
			// 传入页面的返程单出发地
			BizDistrict backStartPoint = new BizDistrict();

			if (CollectionUtils.isNotEmpty(startDistrictDetailList)) {
				for (ProdStartDistrictDetail startDistrictDetail : startDistrictDetailList) {
					backDestDistricts.add(startDistrictDetail
							.getStartDistrict());
				}

				ProdStartDistrictDetail startDistrictDetail = startDistrictDetailList
						.get(0);
				backStartPoint = startDistrictDetail.getDestination();
			}

			Map<String, Object> attributes = new HashMap<String, Object>();
			attributes.put("backDestDistricts", backDestDistricts);
			attributes.put("backStartPoint", backStartPoint);
			return new ResultMessage(attributes, "success", "获取信息成功");
		}

		return new ResultMessage("error", "交通组内不存在单程去程交通组信息");
	}

	/**
	 * 当删除多出发地产品的单程交通组信息时，会发出该请求用于校验是否存在与其对应的单程返程的交通组信息
	 * 
	 * @param productId
	 *            产品编号
	 * @return 校验结果
	 */
	@RequestMapping(value = "/validateIsExistBack")
	@ResponseBody
	public Object validateIsExistBack(Long groupId, Long productId) {
		if (groupId == null || groupId.longValue() == 0 || productId == null
				|| productId.longValue() == 0) {
			return new ResultMessage("error", "校验时参数传递有误");
		}

		ProdProduct product = prodProductService
				.findProdProductByProductId(productId);
		if (product == null) {
			return new ResultMessage("error", "校验时无法获取到产品信息");
		}

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("groupId", groupId);
		List<ProdPackageGroupTransport> transportlist = prodPackageGroupTransportService
				.selectByParams(params);
		if (CollectionUtils.isEmpty(transportlist)) {
			return new ResultMessage("error", "校验时无法获取到交通组信息");
		}

		ProdPackageGroupTransport transport = transportlist.get(0);
		if (transport == null) {
			return new ResultMessage("error", "校验时无法获取到交通组信息");
		}

		Boolean isExistBack = false;
		String isMuiltDparture = product.getMuiltDpartureFlag();
		// 如果是多出发地并且是单程去程时，检验是否有单程返程交通信息
		if ("Y".equalsIgnoreCase(isMuiltDparture)
				&& ProdPackageGroupTransport.TRANSPORTTYPE.TO.name()
						.equalsIgnoreCase(transport.getTransportType())
				&& transport.getToStartPoint() != null) {
			// 该方法用于获得当前对于某个含大交通产品下已有的交通组信息情况
			Map<String, Boolean> existStatusMap = this
					.getPackageGroupDataSituation(productId);
			// 已存在单程返程
			boolean existSingleBack = (Boolean) existStatusMap
					.get("existSingleBack");
			if (existSingleBack) {
				isExistBack = true;
			}
		}

		Map<String, Object> attributes = new HashMap<String, Object>();
		attributes.put("isExistBack", isExistBack);
		return new ResultMessage(attributes, "success", "获取信息成功");
	}

	/**
	 * 根据产品id，获得第一个单程去程的交通组
	 * 
	 * @param productId
	 *            产品编号
	 * @return 单程去程交通组
	 */
	private ProdPackageGroupTransport getFirstSingleToPackageGroupTransport(
			Long productId) {
		ProdPackageGroupTransport packageGroupTransport = null;

		if (productId == null) {
			return packageGroupTransport;
		}

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productId", productId);
		List<ProdPackageGroup> packageGroupList = prodPackageGroupService
				.findProdPackageGroup(params);

		if (CollectionUtils.isNotEmpty(packageGroupList)) {
			for (ProdPackageGroup packageGroup : packageGroupList) {
				params.clear();
				params.put("groupId", packageGroup.getGroupId());
				List<ProdPackageGroupTransport> packageGroupTransportList = prodPackageGroupTransportService
						.selectByParams(params);
				if (CollectionUtils.isNotEmpty(packageGroupTransportList)) {
					// PackageGroup与PackageGroupTransport为1:1关系
					ProdPackageGroupTransport transport = packageGroupTransportList
							.get(0);
					//因为自动打包时，插入的是两条去程的交通组信息，故，在此做一次过滤
					if ("Y".equalsIgnoreCase(transport.getAutoPackage())) {
						continue;
					}
					// 找到交通组内第一个单程去程的打包组
					if (ProdPackageGroupTransport.TRANSPORTTYPE.TO.name()
							.equalsIgnoreCase(transport.getTransportType())
							&& transport.getBackStartPoint() == null) {
						return transport;
					}
				}
			}
		}

		return packageGroupTransport;
	}

	private String getPackGroupAddString(ProdPackageGroup prodPackageGroup) {
		StringBuffer logStr = new StringBuffer("");
		logStr.append(ComLogUtil.getLogTxt(
				"组类型",
				ProdPackageGroup.GROUPTYPE.getCnName(prodPackageGroup
						.getGroupType()) + "", null));
		logStr.append(ComLogUtil.getLogTxt("产品品类",
				prodPackageGroup.getCategoryId() + "", null));
		logStr.append(ComLogUtil.getLogTxt("组时间限制", ProdPackageGroup.DATETYPE
				.getCnName(prodPackageGroup.getDateType()), null));
		logStr.append(ComLogUtil.getLogTxt("组可添加产品数量限制",
				ProdPackageGroup.SELECTTYPE.NOLIMIT.getCnName(prodPackageGroup
						.getSelectType()), null));
		// 判断打包类型
		if (ProdPackageGroup.GROUPTYPE.HOTEL.name().equalsIgnoreCase(
				prodPackageGroup.getGroupType())) {
			logStr.append(ComLogUtil.getLogTxt("入住时间", prodPackageGroup
					.getProdPackageGroupHotel().getStayDays() + "", null));
			logStr.append(ComLogUtil.getLogTxt("备注", prodPackageGroup
					.getProdPackageGroupHotel().getRemark() + "", null));
		} else if (ProdPackageGroup.GROUPTYPE.LINE.name().equalsIgnoreCase(
				prodPackageGroup.getGroupType())) {
			logStr.append(ComLogUtil.getLogTxt("出游时间", prodPackageGroup
					.getProdPackageGroupLine().getStartDay() + "", null));
			logStr.append(ComLogUtil.getLogTxt("行程天数", prodPackageGroup
					.getProdPackageGroupLine().getTravelDays() + "", null));
			logStr.append(ComLogUtil.getLogTxt("入住晚数", prodPackageGroup
					.getProdPackageGroupLine().getStayDays() + "", null));
			logStr.append(ComLogUtil.getLogTxt("成人数", prodPackageGroup
					.getProdPackageGroupLine().getAdult() + "", null));
			logStr.append(ComLogUtil.getLogTxt("儿童数", prodPackageGroup
					.getProdPackageGroupLine().getChild() + "", null));
			logStr.append(ComLogUtil.getLogTxt("备注", prodPackageGroup
					.getProdPackageGroupLine().getRemark() + "", null));
		} else if (ProdPackageGroup.GROUPTYPE.LINE_TICKET.name()
				.equalsIgnoreCase(prodPackageGroup.getGroupType())) {
			logStr.append(ComLogUtil.getLogTxt("出游时间", prodPackageGroup
					.getProdPackageGroupTicket().getStartDay() + "", null));
			logStr.append(ComLogUtil.getLogTxt("备注", prodPackageGroup
					.getProdPackageGroupTicket().getRemark() + "", null));
		} else if (ProdPackageGroup.GROUPTYPE.CHANGE.name().equalsIgnoreCase(
				prodPackageGroup.getGroupType())) {
			logStr.append(ComLogUtil.getLogTxt("插入时间段", prodPackageGroup
					.getProdPackageGroupHotel().getStayDays() + "", null));
		}

		return logStr.toString();
	}

    /**
     * 自由行组合设计->选择产品
     *
     * @param model
     * @param page
     * @param groupId
     * @param groupType
     * @param transportType
     * @param prodProduct goodsid goodsname等参数会映射到里面
     * @param selectCategoryId
     * @param redirectType
     * @param productBranchId
     * @param branchName
     * @param SeatValue
     * @param goodsValidStatus 目前仅在自由行酒景打包商品时使用，检索是否包含有效商品
     * @param req
     * @return
     * @throws BusinessException
     */
	@RequestMapping(value = "/showSelectProductList")
	public Object showSelectProductList(Model model, Integer page,
			Long groupId, String groupType, String transportType,
			ProdProduct prodProduct, Long selectCategoryId, String productType, String BU,
			String redirectType, Long productBranchId, String branchName,Long categoryId_,
			String SeatValue, String goodsValidStatus, HttpServletRequest req) throws BusinessException {
		model.addAttribute("groupId", groupId);
		model.addAttribute("groupType", groupType);
		boolean isGuoNeiBU = false;
		if(("INNERLINE".equalsIgnoreCase(productType) 
				|| "INNERSHORTLINE".equalsIgnoreCase(productType) 
				|| "INNERLONGLINE".equalsIgnoreCase(productType)
				|| "INNER_BORDER_LINE".equalsIgnoreCase(productType))
				&& categoryId_ !=null && categoryId_ != 15L){
			isGuoNeiBU = true;
		}
		model.addAttribute("isGuoNeiBU", isGuoNeiBU);
		model.addAttribute("selectCategoryId", selectCategoryId);
		model.addAttribute("redirectType", redirectType);
		model.addAttribute("hotelOnlineFlag",String.valueOf(destHotelAdapterUtils.checkHotelSystemOnlineEnable()));
		if (prodProduct != null) {
			model.addAttribute("productName", prodProduct.getProductName());
			model.addAttribute("productId", prodProduct.getProductId());
		}
		// add by zhoudengyun
		model.addAttribute("productBranchId", productBranchId);
		model.addAttribute("branchName", branchName);

        //目前仅在自由行酒景打包商品时使用，检索是否包含有效商品
        model.addAttribute("goodsValidStatus", goodsValidStatus);

		String subCategoryId = req.getParameter("subCategoryId");
		model.addAttribute("subCategoryId", subCategoryId);
		String bizCategoryId = req.getParameter("bizCategoryId");
		model.addAttribute("bizCategoryId", bizCategoryId);
		if (ProdPackageGroup.GROUPTYPE.TRANSPORT.name().equalsIgnoreCase(
				groupType)) {
			// 根据打包组id，将打包类型为大交通的交通信息放入model中传入页面
			this.initTransportDistrictInfo(model, groupId);

			// 获取该交通组的交通类型（往返程：TOBACK 单程去程：TO 单程返程：BACK）
			if (StringUtil.isEmptyString(transportType)) {
				transportType = this.getTransportTypeByGroupId(groupId);
				if (StringUtil.isEmptyString(transportType)) {
					throw new BusinessException("未获取到交通组类型");
				}
			}
			model.addAttribute("transportType", transportType);
		}

		ProdPackageGroupLine prodPackageGroupLine = new ProdPackageGroupLine();
		boolean hotelCombFlag = false;
		if (ProdPackageGroup.GROUPTYPE.LINE.name().equalsIgnoreCase(groupType)) {
			// 查询线路的行程天数和入住晚数
			Map<String, Object> groupLineParams = new HashMap<String, Object>();
			groupLineParams.put("groupId", groupId);
			List<ProdPackageGroupLine> packGroupLineList = prodPackageGroupLineService
					.findGroupLineListByParams(groupLineParams);
			if (packGroupLineList != null && !packGroupLineList.isEmpty()) {
				prodPackageGroupLine = packGroupLineList.get(0);
				model.addAttribute("prodPackageGroupLine", prodPackageGroupLine);
			}

			// 如果是酒店套餐则需要匹配成人数和儿童数
			// 判断是否为酒店套餐
			if (Constant.VST_CATEGORY.CATEGORY_ROUTE_HOTELCOMB.getCategoryId()
					.equalsIgnoreCase(String.valueOf(selectCategoryId))) {
				hotelCombFlag = true;
				model.addAttribute("hotelCombFlag", Boolean.TRUE);
			}
		}

		// 存放下拉选择品类列表
		List<BizCategory> selectCategoryList = new ArrayList<BizCategory>();
		BizCategory selectBizCategory = bizCategoryQueryService
				.getCategoryById(selectCategoryId);
		selectCategoryList.add(selectBizCategory);

		model.addAttribute("selectCategoryList", selectCategoryList);

		if (page == null && StringUtil.isEmptyString(redirectType)) {
			model.addAttribute("redirectType", "1");
			if (ProdPackageGroup.GROUPTYPE.HOTEL.name().equalsIgnoreCase(
					groupType)) {
				return "/pack/line/showSelectHotelProductList";
			} else if (ProdPackageGroup.GROUPTYPE.LINE.name().equalsIgnoreCase(
					groupType)) {
				return "/pack/line/showSelectLineProductList";
			} else if (ProdPackageGroup.GROUPTYPE.LINE_TICKET.name()
					.equalsIgnoreCase(groupType)) {
				return "/pack/line/showSelectTicketProductList";
			} else if (ProdPackageGroup.GROUPTYPE.TRANSPORT.name()
					.equalsIgnoreCase(groupType)) {
				model.addAttribute("firstLoad", "1");
				return "/pack/line/showSelectTransportProductList";
			} else {
				throw new BusinessException("参数groupType:[" + groupType
						+ "]传递错误");
			}
		}

		// 分装请求参数
		Map<String, Object> paramProdProduct = new HashMap<String, Object>();
		if("HOTEL".equalsIgnoreCase(groupType)){
			Long categoryId = Long.valueOf(bizCategoryId);
			if(categoryId != null && (categoryId == 15L || (categoryId == 18L && Long.valueOf(subCategoryId) != 181L))){
				paramProdProduct.put("packHotelFlag", "Y");
			}
		}
		paramProdProduct.put("bizCategoryId", selectCategoryId);
		paramProdProduct.put("subCategoryId", subCategoryId);
		paramProdProduct.put("transportType", transportType);
		paramProdProduct.put("productName", prodProduct.getProductName());
		paramProdProduct.put("productId", prodProduct.getProductId());
		if (prodProduct.getSuppGoods() != null) {
			paramProdProduct.put("suppGoodsName", prodProduct.getSuppGoods().getGoodsName());
			paramProdProduct.put("suppGoodsId", prodProduct.getSuppGoods().getSuppGoodsId());
		}
		paramProdProduct.put("cancelFlag", prodProduct.getCancelFlag());
		paramProdProduct.put("saleFlag", "Y");
		if (prodProduct.getBizDistrict() != null) {
			paramProdProduct.put("bizDistrictId", prodProduct.getBizDistrict()
					.getDistrictId());
			paramProdProduct.put("districtName", prodProduct.getBizDistrict()
					.getDistrictName());
		}

		if (StringUtil.isEmptyString(groupType)) {
			groupType = prodProduct.getPackageType();
		}

		paramProdProduct.put("groupId", groupId);
		paramProdProduct.put("priceType",
				ProdPackageDetail.OBJECT_TYPE_DESC.PROD_BRANCH.name());

		if (prodPackageGroupLine != null) {
			paramProdProduct.put("routeNum",
					prodPackageGroupLine.getTravelDays());
			paramProdProduct.put("stayNum", prodPackageGroupLine.getStayDays());
		}

		if (hotelCombFlag) {
			paramProdProduct.put("adult", prodPackageGroupLine.getAdult());
			paramProdProduct.put("child", prodPackageGroupLine.getChild());
		}

		if (selectBizCategory != null
				&& StringUtil.isNotEmptyString(selectBizCategory
						.getCategoryCode())
				&& selectBizCategory.getCategoryCode()
						.indexOf("category_route") >= 0) {
			paramProdProduct.put("packageType",
					ProdProduct.PACKAGETYPE.SUPPLIER.name());
		}
		if(prodProduct != null && prodProduct.getSuppSupplier()!=null)
		{
			paramProdProduct.put("supplierId",prodProduct.getSuppSupplier().getSupplierId());
		}

		//酒+景子品类维护组合信息
        if (StringUtil.isNotEmptyString(goodsValidStatus)) {
            paramProdProduct.put("goodsValidStatus", goodsValidStatus);
        }

        // 给paramProdProduct增加规格名称和规格ID参数 add by zhoudengyun
		paramProdProduct.put("branchName", branchName);
		paramProdProduct.put("productBranchId", productBranchId);
		paramProdProduct.put("prepaid", true);// 是否为预付款的

		// 为组类型为大交通的分装查询参数
		paramProdProduct.put("groupType", groupType);
		if (ProdPackageGroup.GROUPTYPE.TRANSPORT.name().equalsIgnoreCase(
				groupType)) {
			// 获取页面选中的出发地和目的地信息
			String[] checkedStartDistrictIds = req.getParameterValues("checkedStartDistrictIds");
			String[] checkedToDistrictIds = req.getParameterValues("checkedToDistrictIds");

			model.addAttribute("checkedStartDistrictIds", checkedStartDistrictIds);
			model.addAttribute("checkedToDistrictIds", checkedToDistrictIds);

			paramProdProduct.put("startDistrictIds", this.stringArrToLongArr(checkedStartDistrictIds));
			paramProdProduct.put("endDistrictIds", this.stringArrToLongArr(checkedToDistrictIds));

			//处理缺程参数
			String backStartDistrictIdStr = req.getParameter("backStartDistrictId");
			if ("TOBACK".equals(transportType) && ArrayUtils.isNotEmpty(checkedToDistrictIds) && backStartDistrictIdStr != null) {
				paramProdProduct.put("backStartDistrictId", Long.valueOf(backStartDistrictIdStr));
			}
		}
		//如果是门票并且是组合套餐票(yangdechao)封装供应商打包参数
        if(ProdPackageGroup.GROUPTYPE.LINE_TICKET.name().equalsIgnoreCase(groupType))
        {
        	String categoryCode="";
        	if (selectBizCategory != null&& StringUtil.isNotEmptyString(selectBizCategory.getCategoryCode()))
        	{
        		 categoryCode = selectBizCategory.getCategoryCode();
        		if(categoryCode.equals("category_comb_ticket"))
        		{
        			 paramProdProduct.put("packageType","SUPPLIER");
        		}
        		
        	}
        }
        
      //根据后台checkbox里面的选择显示“经济舱”，“商务舱”,“头等舱”     panyu 20160602  
        String[] seatValueArray = null;
        if(null != SeatValue && !"".equals(SeatValue)){
        	model.addAttribute("SeatValue", SeatValue);
        	String[] seatValueAr= SeatValue.split(",");
        	int i = 0;
        	seatValueArray = new String[seatValueAr.length];
        	for(String seatValue : seatValueAr){
        		seatValueArray[i++] = seatValue.trim();
        	}
        	paramProdProduct.put("seatValueArray", seatValueArray);
        }
		Page pageParam;
		String productBu = getProdProductBu(groupId);
		try {
			if(ProdPackageGroup.GROUPTYPE.HOTEL.name().equalsIgnoreCase(groupType) && paramProdProduct.get("bizCategoryId")!=null && (Long)paramProdProduct.get("bizCategoryId") == 1L 
					&&paramProdProduct.get("productId")==null &&paramProdProduct.get("productName")!=null){
				paramProdProduct.put("limitParam", 100);
				log.info("use prodProductBranchAdapterService.filterProductByname begin! paramProdProduct is "+paramProdProduct);
				List<ProdProduct> prodList = prodProductBranchAdapterService.filterProductByname(paramProdProduct);
				if(prodList!=null && prodList.size()>=100){
					model.addAttribute("msg", "查询结果太多，请输入具体产品名称或者产品id");
					return "/pack/line/showSelectHotelProductList";
				}else if(prodList!=null){
					List<Long> ids =new ArrayList<Long>();
					for(ProdProduct prod: prodList){
						ids.add(prod.getProductId());
					}
					paramProdProduct.put("productIds", ids);
				}
			}
			
			log.info("use prodProductBranchAdapterService.findProdProductBranchCountForLine begin! paramProdProduct is "+paramProdProduct);
			int count = prodProductBranchAdapterService
					.findProdProductBranchCountForLine(paramProdProduct);
			log.info("use prodProductBranchAdapterService.findProdProductBranchCountForLine end! count is "+count);

			int pagenum = page == null ? 1 : page;
			pageParam = Page.page(count, 20, pagenum);
			pageParam.buildUrl(req);
			paramProdProduct.put("_start", pageParam.getStartRows());
			paramProdProduct.put("_end", pageParam.getEndRows());
			paramProdProduct.put("_orderby", "t.category_id");
			paramProdProduct.put("_order", "DESC");
			paramProdProduct.put("productBu", productBu);

			// 给paramProdProduct增加规格名称和规格ID参数 add by zhoudengyun
			log.info("use prodProductBranchAdapterService.findProdProductBranchListForLine begin! paramProdProduct is "+paramProdProduct);
			List<ProdProductBranch> list = prodProductBranchAdapterService
					.findProdProductBranchListForLine(paramProdProduct);
			log.info("use prodProductBranchAdapterService.findProdProductBranchListForLine end! list is "+list);

			// 对打包组类型为线路的进行结果筛选
			if (ProdPackageGroup.GROUPTYPE.LINE.name().equalsIgnoreCase(groupType)) {
				List<ProdProductBranch> listVis = new ArrayList<ProdProductBranch>();
				for (ProdProductBranch ppb : list) {
					Map<String, Object> routeMap = new HashMap<String, Object>();
					routeMap.put("productId", ppb.getProductId());
					if (ppb.getProductId() == null)
						continue;
					// 只能打包单行程的
					List<ProdLineRoute> prodLineRouteList = MiscUtils.autoUnboxing(prodLineRouteService
							.findProdLineRouteByParamsSimple(routeMap));
					if (prodLineRouteList == null || prodLineRouteList.size() <= 1) {
						listVis.add(ppb);
					}
				}
				list = listVis;
			}

			pageParam.setItems(list);
			model.addAttribute("pageParam", pageParam);
		} catch (Exception e) {
			log.info(e);
			throw new BusinessException("系统内部异常！");
		}

		// 跟团游 自由行 一个组中只能打包一个产品
		String inputType = "checkbox";
		if (selectCategoryId.longValue() == 15
				|| selectCategoryId.longValue() == 18) {
			inputType = "radio";
		}
		model.addAttribute("inputType", inputType);
		model.addAttribute("groupId", groupId);

		if (ProdPackageGroup.GROUPTYPE.HOTEL.name().equalsIgnoreCase(groupType)) {
			return "/pack/line/showSelectHotelProductList";
		} else if (ProdPackageGroup.GROUPTYPE.LINE.name().equalsIgnoreCase(
				groupType)) {
			return "/pack/line/showSelectLineProductList";
		} else if (ProdPackageGroup.GROUPTYPE.LINE_TICKET.name()
				.equalsIgnoreCase(groupType)) {
			if(StringUtils.isEquals(productBu, Constant.BU_NAME.DESTINATION_BU.getCode())){
				model.addAttribute("isDestinationBU", "Y");
			}
			return "/pack/line/showSelectTicketProductList";
		} else if (ProdPackageGroup.GROUPTYPE.TRANSPORT.name()
				.equalsIgnoreCase(groupType)) {
			return "/pack/line/showSelectTransportProductList";
		} else {
			throw new BusinessException("参数groupType:[" + groupType + "]传递错误");
		}
	}
	
	/**
	 * 根据groupId获取产品的BU
	 * @param groupId 打包组ID
	 * @return 产品的BU
	 */
	private String getProdProductBu(Long groupId){
		ProdPackageGroup prodPackageGroup = prodPackageGroupService.findProdPackageGroupByKey(groupId);
		ProdProduct prodProduct = null;
		if(prodPackageGroup != null){
			Long productId = prodPackageGroup.getProductId();
			prodProduct = prodProductService.getProdProductBy(productId);					
		}
		String bu = null;
		if(prodProduct != null){
			bu = prodProduct.getBu();
		}
		return bu;
	}

	/**
	 * 初始化交通的出发地目的地信息
	 * 
	 * @param model
	 * @param groupId
	 */
	private void initTransportDistrictInfo(Model model, Long groupId) {

		// 获取产品信息
		ProdPackageGroup packageGroup = prodPackageGroupService
				.findProdPackageGroupByKey(groupId);
		Long productId = packageGroup.getProductId();
		ProdProduct product = prodProductService
				.getProdProductBy(productId);
		String isMuiltDparture = product.getMuiltDpartureFlag();
		model.addAttribute("isMuiltDparture", isMuiltDparture);

		// 设置出发城市和到达城市
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("groupId", groupId);
		List<ProdPackageGroupTransport> ppgtList = prodPackageGroupTransportService
				.selectByParams(params);

		// 存储数据库中取出的出发地目的地信息
		List<BizDistrict> startDistricts = new ArrayList<BizDistrict>();// 出发地ArrayList
		List<BizDistrict> toDistricts = new ArrayList<BizDistrict>();// 目的地ArrayList

		if (CollectionUtils.isNotEmpty(ppgtList)) {
			ProdPackageGroupTransport ppgt = ppgtList.get(0);

			// 如果是多出发地
			if ("Y".equals(isMuiltDparture)) {
				// 如果是单程返程，则取产品的所有打包组的第一个单程去程的交通组
				if ("TO".equalsIgnoreCase(ppgt.getTransportType())
						&& ppgt.getToStartPoint() == null) {
					// 根据产品id，获得第一个单程去程的交通组
					ProdPackageGroupTransport transport = this
							.getFirstSingleToPackageGroupTransport(productId);
					if (transport == null) {
						throw new BusinessException("无法找到对应的单程去程的打包交通组信息");
					}

					// 找到对应的多出发地配置信息
					params.clear();
					params.put("groupId", transport.getGroupId());
					List<ProdStartDistrictDetail> startDistrictDetailList = prodStartDistrictDetailService
							.findStartDistrictDetailListByParams(params);

					if (CollectionUtils.isNotEmpty(startDistrictDetailList)) {
						for (ProdStartDistrictDetail startDistrictDetail : startDistrictDetailList) {
							toDistricts.add(startDistrictDetail.getStartDistrict());
						}

						ProdStartDistrictDetail startDistrictDetail = startDistrictDetailList.get(0);

						long backStartPoint = ppgt.getBackStartPoint() == null ? 0 : ppgt.getBackStartPoint().longValue();
						long firstSingleToDestination = startDistrictDetail.getDestinationId() == null ? 0 : 
							startDistrictDetail.getDestinationId().longValue();

						//缺程时，用户可以自主选择单程返程的出发地
						if (backStartPoint != 0 && firstSingleToDestination != backStartPoint) {
							startDistricts.add(ppgt.getBackStartPointDistrict());
						} else {
							startDistricts.add(startDistrictDetail.getDestination());
						}
					} else {
						throw new BusinessException("无法找到对应的单程去程的多出发地配置信息");
					}

				}// 往返程或单程去程
				else {
					// 找到对应的多出发地配置信息
					params.clear();
					params.put("groupId", groupId);
					List<ProdStartDistrictDetail> startDistrictDetailList = prodStartDistrictDetailService
							.findStartDistrictDetailListByParams(params);

					if (CollectionUtils.isNotEmpty(startDistrictDetailList)) {
						for (ProdStartDistrictDetail startDistrictDetail : startDistrictDetailList) {
							startDistricts.add(startDistrictDetail.getStartDistrict());
						}

						ProdStartDistrictDetail startDistrictDetail = startDistrictDetailList.get(0);
						toDistricts.add(startDistrictDetail.getDestination());

						long backStartPoint = ppgt.getBackStartPoint() == null ? 0 : ppgt.getBackStartPoint().longValue();
						long toDestination = startDistrictDetail.getDestinationId() == null ? 0 : 
							startDistrictDetail.getDestinationId().longValue();

						//缺程时，用户可以自主选择往返程的返程出发地
						if ("TOBACK".equalsIgnoreCase(ppgt.getTransportType()) && backStartPoint != 0 && backStartPoint != toDestination) {
							model.addAttribute("backStartDistrict", ppgt.getBackStartPointDistrict());
						}
					} else {
						throw new BusinessException("无法找到对应的多出发地配置信息,groupId:" + groupId);
					}
				}

			} // 如果是非多出发地
			else {
				Long startDistrict = null;
				Long toDistrict = null;
				// 首先判断是不是只有返程,如果只有返程则取返程的出发地和目的地
				if ("TO".equalsIgnoreCase(ppgt.getTransportType())
						&& ppgt.getToStartPoint() == null) {
					startDistrict = ppgt.getBackStartPoint();
					toDistrict = ppgt.getBackDestination();
				}// 如果是去程或往返程，则去去程的出发地和目的地
				else {
					startDistrict = ppgt.getToStartPoint();
					toDistrict = ppgt.getToDestination();

					//缺程时，用户可以自主选择往返程的返程出发地
					if ("TOBACK".equalsIgnoreCase(ppgt.getTransportType()) && ppgt.getBackStartPoint() != null && !ppgt.getBackStartPoint().equals(ppgt.getToDestination())) {
						model.addAttribute("backStartDistrict", ppgt.getBackStartPointDistrict());
					}
				}

				BizDistrict start = MiscUtils.autoUnboxing(districtService
						.findDistrictById(startDistrict));
				BizDistrict to = MiscUtils.autoUnboxing(districtService.findDistrictById(toDistrict));
				if (start != null) {
					startDistricts.add(start);
				}
				if (to != null) {
					toDistricts.add(to);
				}
			}

		} else {
			throw new BusinessException("无法找到对应的打包交通组信息");
		}

		// 将数据库中取出的出发地目的地信息放入页面
		model.addAttribute("startDistricts", startDistricts);
		model.addAttribute("toDistricts", toDistricts);
	}

	/**
	 * 通过交通组的组id获取该交通的交通类型
	 * 
	 * @param groupId交通组的组id
	 * @return 交通的交通类型（往返程：TOBACK 单程去程：TO 单程返程：BACK）
	 */
	private String getTransportTypeByGroupId(Long groupId) {
		String transportType = "";
		if (groupId == null || groupId.longValue() == 0) {
			return transportType;
		}

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("groupId", groupId);
		List<ProdPackageGroupTransport> packageGroupTransportList = prodPackageGroupTransportService
				.selectByParams(params);
		if (CollectionUtils.isNotEmpty(packageGroupTransportList)) {
			ProdPackageGroupTransport transport = packageGroupTransportList
					.get(0);// PackageGroup与PackageGroupTransport为1:1关系
			if (ProdPackageGroupTransport.TRANSPORTTYPE.TOBACK.name()
					.equalsIgnoreCase(transport.getTransportType())) {
				transportType = "TOBACK";
			} else if (ProdPackageGroupTransport.TRANSPORTTYPE.TO.name()
					.equalsIgnoreCase(transport.getTransportType())
					&& transport.getToStartPoint() != null) {
				transportType = "TO";
			} else if (ProdPackageGroupTransport.TRANSPORTTYPE.TO.name()
					.equalsIgnoreCase(transport.getTransportType())
					&& transport.getBackStartPoint() != null) {
				transportType = "BACK";
			}
		}

		return transportType;
	}

	/**
	 * 加入打包
	 * 
	 * @param model
	 * @param groupId
	 * @param branchIds
	 * @param groupType
	 * @param selectCategoryId
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/addGroupDetail")
	@ResponseBody
	public Object addGroupDetail(Model model, Long groupId, String branchIds, String suppGoodsIds,
			String groupType, Long selectCategoryId, HttpServletRequest req)
			throws BusinessException {

		Map<String, Object> attributes = new HashMap<String, Object>();
		if (StringUtil.isNotEmptyString(branchIds) && groupId != null) {

			String[] branIdArr = branchIds.split(",");
			String[] suppGoodsIddArr = null;
			if (StringUtil.isNotEmptyString(suppGoodsIds)) {
				suppGoodsIddArr = suppGoodsIds.split(";");
				if (branIdArr.length != suppGoodsIddArr.length) {
					return new ResultMessage("error", "后台参数获取错误，原因：规格信息数组与商品信息数组大小不相等！");
				}
			}
			List<ProdPackageDetail> packDetailList = new ArrayList<ProdPackageDetail>();

			if ((selectCategoryId.longValue() == 15l || selectCategoryId.longValue() == 18l)
					&& (!ProdPackageGroup.GROUPTYPE.CHANGE.name().equalsIgnoreCase(groupType))) {
				if (branIdArr != null && branIdArr.length > 1) {
					return new ResultMessage("error", "跟团游，自由行时间组只能打包一个产品");
				}
			}

			// 获取产品信息
			ProdPackageGroup packageGroup = prodPackageGroupService.findProdPackageGroupByKey(groupId);
			ProdProduct product = prodProductHotelAdapterService.findProdProductById(packageGroup.getProductId());
			List<ProdPackageDetail> listOfAllHotelDetail = new ArrayList<ProdPackageDetail>();
			List<ProdPackageDetail> jingJiulistOfAllHotelDetail = new ArrayList<ProdPackageDetail>();
			List<ProdPackageDetail> jingJiulistOfAllTicketDetail = new ArrayList<ProdPackageDetail>();
			HashMap<Long, ProdPackageDetail> removeDupMap = new HashMap<Long, ProdPackageDetail>();
			HashMap<Long, ProdPackageDetail> jingJiuremoveDupMap = new HashMap<Long, ProdPackageDetail>();
			boolean jingJiuFlag=false;
			boolean jingJiuTicketFlag=false;
			
			if(product.getBizCategoryId()==18&&product.getSubCategoryId()==181){
				Map<String, Object> packGroupParams = new HashMap<String, Object>();
				packGroupParams.put("productId", product.getProductId());
				packGroupParams.put("groupType", groupType);
				
				
				List<ProdPackageGroup> packGroupList = prodLineGroupPackService.findProdLinePackGroupByParams(packGroupParams);
				if(packGroupList.size()>0){
					for(ProdPackageGroup ppg : packGroupList){
						if(ppg.getProdPackageDetails()!=null){
						   if("HOTEL".equals(groupType)&&ppg.getProdProduct()!=null&&ppg.getProdProduct().getSubCategoryId()==181){
								jingJiulistOfAllHotelDetail.addAll(ppg.getProdPackageDetails());
								jingJiuFlag=true;
							}else if ("INNERLINE".equals(product.getProductType()) && "LINE_TICKET".equals(groupType)&&ppg.getProdProduct()!=null&&ppg.getProdProduct().getSubCategoryId()==181) {
								jingJiulistOfAllTicketDetail.addAll(ppg.getProdPackageDetails());
								jingJiuTicketFlag=true;
							}else{
								listOfAllHotelDetail.addAll(ppg.getProdPackageDetails());
							} 
						}
					}
				}
				
				if(jingJiuFlag){
					for(ProdPackageDetail ppd : jingJiulistOfAllHotelDetail){
						if(ppd!=null&&ppd.getProdProductBranch()!=null&&ppd.getProdProductBranch().getProductId()!=null){
							jingJiuremoveDupMap.put(ppd.getProdProductBranch().getProductId(), ppd);
						}
					}
				}else if (jingJiuTicketFlag) {
					for(ProdPackageDetail ppd : jingJiulistOfAllTicketDetail){
						if(ppd!=null&&ppd.getProdProductBranch()!=null&&ppd.getProdProductBranch().getProductId()!=null){
							jingJiuremoveDupMap.put(ppd.getProdProductBranch().getProductId(), ppd);
						}
					}
				}else{
					for(ProdPackageDetail ppd : listOfAllHotelDetail){
						removeDupMap.put(ppd.getProdProductBranch().getProductId(), ppd);
					}
				}
				
				if(jingJiuFlag){
					if(jingJiuremoveDupMap.size()>8){
						if(StringUtils.isEmpty(product.getProductOrigin())){
							return new ResultMessage("error", "景酒最多打包8个酒店产品");
						}
					}
				}else if (jingJiuTicketFlag) {
					if(jingJiuremoveDupMap.size()>8){
						if(StringUtils.isEmpty(product.getProductOrigin())){
							return new ResultMessage("error", "景酒最多打包8个门票产品");
						}
					}
				}else{
					if(removeDupMap.size()>5){
						if(StringUtils.isEmpty(product.getProductOrigin())){
							return new ResultMessage("error", "最多打包5个产品");
						}
					}
				}
			}
			
			//自由行产品，在基础信息勾选了“驴色飞扬自驾”，且设置售卖方式为按人售卖，同时设置了儿童价后在打包门票时，若门票票种含儿童票则无法打包
			if(suppGoodsIddArr!=null &&suppGoodsIddArr.length>0){
				StringBuffer str=new StringBuffer();
				for (int i = 0; i < suppGoodsIddArr.length; i++) {
					str.append(suppGoodsIddArr[i]).append(",");
				}
				String suppGoodsIddStr=str.toString();
				String[] allSuppGoodsIddArr=suppGoodsIddStr.split(",");
				List<Long> suppGoodsIddList=new ArrayList<Long>(); 
				for (int i = 0; i < allSuppGoodsIddArr.length; i++) {
					suppGoodsIddList.add(Long.parseLong(allSuppGoodsIddArr[i]));
				}
				List<SuppGoods> suppGoods=MiscUtils.autoUnboxing(suppGoodsHotelAdapterService.findSuppGoodsByIdList(suppGoodsIddList));
				for (int i = 0; i < suppGoods.size(); i++) {
					if("CHILDREN".equals(suppGoods.get(i).getGoodsSpec()) &&   isLvseAndChildPriceType(packageGroup.getProductId())){
						//产品售卖类型为：按人卖    &&  儿童价为固定价    并且勾选了  驴色飞扬自驾   并且打包的门票包含儿童票
						return new ResultMessage("error", "本产品已设置了儿童价，不能打包儿童规格的门票，请重新设置!");
					};
				}
			}
			// 获取是否为多出发地标示
			String isMuiltDparture = product.getMuiltDpartureFlag();

			// 多出发地产品并且组类型为大交通时，判断接收到得参数是否正确（多出发地任务添加）
			String[] startDistrictIdsArr = null;
			if (ProdPackageGroup.GROUPTYPE.TRANSPORT.name().equalsIgnoreCase(groupType)
					&& "Y".equals(isMuiltDparture)) {
				String startDistrictIds = req.getParameter("startDistrictIds");
				if (StringUtil.isEmptyString(startDistrictIds)) {
					return new ResultMessage("error", "没有获取到交通产品的出发地ID信息");
				}

				startDistrictIdsArr = startDistrictIds.split("[,]");

				if (startDistrictIdsArr.length != branIdArr.length) {
					return new ResultMessage("error",
							"后台参数获取错误，原因：规格信息数组与出发地信息数组大小不相等！");
				}
			}

			for (int i = 0; i < branIdArr.length; i++) {
				String branchId = branIdArr[i];
				ProdPackageDetail packDetail = new ProdPackageDetail();
				if (suppGoodsIddArr != null) {
					if (suppGoodsIddArr[i] == null || suppGoodsIddArr[i].length() == 0) {
						return new ResultMessage("error", "后台参数获取错误，原因：打包规格【" + branchId + "】下无可售商品！");
					}  
					String[] branchGoodsIdArr = suppGoodsIddArr[i].split(",");
					packDetail.setBranchGoodsIdArr(branchGoodsIdArr);
				}
				packDetail.setGroupId(groupId);
				packDetail.setObjectType(ProdPackageDetail.OBJECT_TYPE_DESC.PROD_BRANCH.name());
				packDetail.setObjectId(Long.parseLong(branchId));
				packDetail.setGroupProductId(product.getProductId());

				// 如果是大交通类型，并且为多发出地时，将startDistrictId设置值（多出发地任务添加）
				if (ProdPackageGroup.GROUPTYPE.TRANSPORT.name().equalsIgnoreCase(groupType)
						&& "Y".equals(isMuiltDparture)) {
					String strStartDistrictId = startDistrictIdsArr[i];
					if (StringUtil.isEmptyString(strStartDistrictId)) {
						return new ResultMessage("error", "规格id为" + branchId + ", 没有对应的出发地ID信息");
					} else {
						packDetail.setStartDistrictId(Long.parseLong(strStartDistrictId));
					}
				}

				if ((selectCategoryId.longValue() == 15l || selectCategoryId.longValue() == 18l)
						&& (!ProdPackageGroup.GROUPTYPE.CHANGE.name().equalsIgnoreCase(groupType))) {
					boolean flag = prodLineGroupPackService.validateProductSelectType(groupId);
					if (flag) {
						packDetailList.add(packDetail);
					} else {
						return new ResultMessage("error", "跟团游，自由行时间组只能打包一个产品");
					}
				} else {
					packDetailList.add(packDetail);
				}
				
			}
			for(ProdPackageDetail ppds : packDetailList){
				String[] goodsId = ppds.getBranchGoodsIdArr();
				if(goodsId!=null){
					SuppGoods sg = MiscUtils.autoUnboxing(suppGoodsHotelAdapterService.findSuppGoodsById(Long.parseLong(goodsId[0])));
					if(sg!=null){
						if("HOTEL".equals(groupType) &&product!=null&&product.getSubCategoryId()!=null&&product.getSubCategoryId()==181){
							jingJiuremoveDupMap.put(sg.getProductId(), ppds);
							jingJiuFlag=true;
						}else if ("INNERLINE".equals(product.getProductType()) && "LINE_TICKET".equals(groupType)&&product!=null&&product.getSubCategoryId()!=null&&product.getSubCategoryId()==181) {
							jingJiuremoveDupMap.put(sg.getProductId(), ppds);
							jingJiuTicketFlag = true;
						}else{
							removeDupMap.put(sg.getProductId(), ppds);
						}
					}
				}
			}
			if(jingJiuFlag){
				if(jingJiuremoveDupMap.size() > 8){
					if(StringUtils.isEmpty(product.getProductOrigin())){
						return new ResultMessage("error", "景酒最多打包8个酒店产品");
					}
				}
			}else if (jingJiuTicketFlag) {
				if(jingJiuremoveDupMap.size() > 8){
					if(StringUtils.isEmpty(product.getProductOrigin())){
						return new ResultMessage("error", "景酒最多打包8个门票产品");
					}
				}
			}else{
				if(removeDupMap.size() > 5){
					if(StringUtils.isEmpty(product.getProductOrigin())){
						return new ResultMessage("error", "最多打包5个产品");
					}
				}
			}

			if (!branchIds.isEmpty()) {
				List<Long> detailIdList = prodLineGroupPackService .addProdLinePackGroupDetailList(packDetailList);

				if (detailIdList == null) {
					return new ResultMessage("error", "添加产品已经存在");
				} else {
					StringBuffer detailIds = new StringBuffer();
					for (Long detailId : detailIdList) {
						detailIds.append(detailId).append(",");
					}
					attributes.put("detailIds", detailIds);
				}

				Map<String, Object> params = new HashMap<String, Object>();
				params.put("groupId", groupId);
				List<ProdPackageGroup> packageGroupList = prodPackageGroupService.findProdPackageGroup(params);
				if (packageGroupList != null && !packageGroupList.isEmpty()) {
					Long productId = packageGroupList.get(0).getProductId();
					if ("Y".equals(isMuiltDparture)) {
						pushAdapterService.push(packageGroupList.get(0)
								.getProductId(), ComPush.OBJECT_TYPE.PRODUCT,
								ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP,
								ComPush.OPERATE_TYPE.UP,
								ComIncreament.DATA_SOURCE_TYPE.TRANS_API_JOB);
					} else {
						pushAdapterService.push(packageGroupList.get(0)
								.getProductId(), ComPush.OBJECT_TYPE.PRODUCT,
								ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP,
								ComPush.OPERATE_TYPE.UP,
								ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
					}
					//新增打包项，发消息给分销商。
					this.handOut4Detail(product.getBizCategoryId(),productId,
							String.valueOf(groupId),null,groupType, ComPush.OPERATE_TYPE.ADD.name());
				}
			}
		} else {
			throw new BusinessException("参数传递错误");
		}

		attributes.put("groupType", groupType);
		attributes.put("groupId", groupId);
		attributes.put("selectCategoryId", selectCategoryId);

		return new ResultMessage(attributes, "success", "保存成功");
	}

	@RequestMapping(value = "/showUpdateGroupDetail")
	public Object showUpdateGroupDetai(Model model, Long groupId,
			String groupType, Long selectCategoryId, String detailIds,Long productId,
			HttpServletRequest req) throws Exception {

		if (groupId != null && selectCategoryId != null
				&& StringUtil.isNotEmptyString(detailIds)) {
			List<ProdPackageDetail> packDetailList = new ArrayList<ProdPackageDetail>();
			findUpdateGroupDetailByIds(detailIds, packDetailList);

			// 检查当前打包规格下是否存在可打包的票种（成人、儿童、亲子、家庭、双人）和
			// 门票规格下的上述票种是否可售，不存在不符合条件规格时，isAvaliableBranch为空串
			if (ProdPackageGroup.GROUPTYPE.LINE_TICKET.name().equalsIgnoreCase(
					groupType)) {
				String isAvaliableBranch = this
						.isAvaliableBranch4Pack(packDetailList);
				model.addAttribute("isAvaliableBranch", isAvaliableBranch);
			}

			model.addAttribute("packDetailList", packDetailList);
			model.addAttribute("groupId", groupId);
			model.addAttribute("groupType", groupType);
			model.addAttribute("selectCategoryId", selectCategoryId);
			model.addAttribute("detailIds", detailIds);
			if(productId != null){
				ProdProductAssociation prodProductAssociation = prodProductAssociationService.getProdProductAssociationByProductId(productId);
				if(prodProductAssociation != null){
					Long associatedRouteProdId = prodProductAssociation.getAssociatedRouteProdId();
					Long associatedFeeIncludeProdId = prodProductAssociation.getAssociatedFeeIncludeProdId();
					Long associatedContractProdId = prodProductAssociation.getAssociatedContractProdId();
					String feeIncludeExtra = prodProductAssociation.getFeeIncludeExtra();
					model.addAttribute("associatedRouteProdId", associatedRouteProdId);
					model.addAttribute("associatedFeeIncludeProdId", associatedFeeIncludeProdId);
					model.addAttribute("associatedContractProdId", associatedContractProdId);
					model.addAttribute("feeIncludeExtra", feeIncludeExtra);
				}
			}
			ProdPackageGroup packageGroup = prodPackageGroupService.findProdPackageGroupByKey(groupId);
			if(packageGroup != null){
				model.addAttribute("categoryId", packageGroup.getCategoryId());
			}
			ProdProduct prodProduct = prodProductService.getProdProductBy(productId);
			Long categoryId = null;
			Long subCategoryId = null;
			if(prodProduct != null){
				categoryId = prodProduct.getBizCategoryId();
				subCategoryId = prodProduct.getSubCategoryId();
			}
			if(packDetailList != null && packDetailList.size() == 1 && productId != null){
				String associatedFlag = "false";
				if(prodProduct != null && (prodProduct.getBizCategoryId() == 15L || (prodProduct.getBizCategoryId() == 18L && prodProduct.getSubCategoryId() != 181L))){
					ProdLineRoute mainProdLineRoute= prodLineRouteService.findOnlyLineRouteId(productId).get(0);
					Map<String,Object> params = new HashMap<String, Object>();
					params.put("productId", packDetailList.get(0).getProdProductBranch().getProductId());
					params.put("cancleFlag", "Y");
					List<ProdLineRoute> prodLineRouteList = MiscUtils.autoUnboxing(prodLineRouteService.findProdLineRouteByParamsSimple(params));
					if(prodLineRouteList != null && prodLineRouteList.size() == 1){
						if(prodLineRouteList.get(0).getRouteNum().equals(mainProdLineRoute.getRouteNum()) && prodLineRouteList.get(0).getStayNum().equals(mainProdLineRoute.getStayNum())){
							associatedFlag = "true";
						}
					}

					ProdProduct referProdProduct = prodProductHotelAdapterService.findProdProductByProductId(packDetailList.get(0).getProdProductBranch().getProductId());
					model.addAttribute("hotelOnlineFlag",String.valueOf(destHotelAdapterUtils.checkHotelRouteEnableByProductId(referProdProduct.getProductId())));
					if(referProdProduct != null && referProdProduct.getSubCategoryId() != null && referProdProduct.getSubCategoryId() == 181L){
						associatedFlag = "false";
					}
				}
				model.addAttribute("associatedFlag", associatedFlag);
			}
			
			if("HOTEL".equalsIgnoreCase(groupType)){
            	if(categoryId != null && (categoryId == 15L || (categoryId == 18L && subCategoryId != 181L))){
            		if(this.volidDistributor(productId)){
            			model.addAttribute("volidDistributor", "Y");
            		}
    				return "/pack/line/showUpdateHotelGroupDetail";
    			}else{
    				return "/pack/line/showUpdateGroupDetail";
    			}
            }
            return "/pack/line/showUpdateGroupDetail";

		} else {
			throw new BusinessException("参数传递错误");
		}
	}
	
	/**caiqing 20170221
	 * 使用新的酒店加价规则自动屏蔽super分销商中的其他分销
	 * @param
	 * @return
	 * @throws Exception 
	 */
	private boolean volidDistributor(Long productId) throws Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productId", productId);
		List<DistDistributorProd> distDistributorProds = MiscUtils.autoUnboxing(distDistributorProdService.findDistDistributorProdByParams(params));
		if(CollectionUtils.isNotEmpty(distDistributorProds)){
			for(DistDistributorProd distDistributorProd : distDistributorProds){
				if(distDistributorProd.getDistributorId().longValue() == 10L || distDistributorProd.getDistributorId().longValue() == 20L){
					return true;
				}
			}
		}
		ResultHandleT<TntGoodsChannelVo> tntGoodsChannelVoHandleT = tntGoodsChannelCouponServiceRemote.getChannels(TntGoodsChannelCouponAdapter.CH_TYPE.NONE.name());
		Long distributorId = null;
		if(tntGoodsChannelVoHandleT != null && tntGoodsChannelVoHandleT.getReturnContent() != null){
			TntGoodsChannelVo tntGoodsChannelVo = (TntGoodsChannelVo)tntGoodsChannelVoHandleT.getReturnContent();
			boolean distributorFlag = false;
			List<TntChannelVo> tntChannelVoList = tntGoodsChannelVo.getChannels();
			if(CollectionUtils.isNotEmpty(tntChannelVoList)){
				for(TntChannelVo tntChannelVo : tntChannelVoList){
					if(distributorFlag){
						break;
					}
					List<TntUserVo> tntUserVoList = tntChannelVo.getUsers();
					if(CollectionUtils.isNotEmpty(tntUserVoList)){
						for(TntUserVo tntUserVo : tntUserVoList){
							if("其他分销".equals(tntUserVo.getUserName())){
								distributorId = tntUserVo.getUserId();
								distributorFlag = true;
								break;
							}
						}
					}
				}
			}
		}
		
		ResultHandleT<Long[]> userIdLongRt = tntGoodsChannelCouponServiceRemote.list(productId,
				null, TntGoodsChannelCouponAdapter.PG_TYPE.PRODUCT.name());
		if(userIdLongRt != null && userIdLongRt.getReturnContent() != null && userIdLongRt.isSuccess()){
			Long[] userIdLong = (Long[])userIdLongRt.getReturnContent();
			if(userIdLong != null && userIdLong.length > 0){
				for(Long userId : userIdLong){
				    if(userId.longValue() == distributorId.longValue()){
				    	return true;
				    }
				}
			}
		}
		return false;
	}

	private void findUpdateGroupDetailByIds(String detailIds,
			List<ProdPackageDetail> packDetailList) {
		String[] detailIdArr = detailIds.split("[,]");
		for (String detailId : detailIdArr) {
			ProdPackageDetail packDetail = prodPackageDetailService
					.selectByPrimaryKey(Long.parseLong(detailId));
			Map<String, Object> params =  new HashMap<String, Object>();
			Long groupId = packDetail.getGroupId();
			params.put("groupId", groupId); 
			List<ProdPackageGroupTransport> packTransportList = prodPackageGroupTransportService.selectByParams(params);
			if (CollectionUtils.isNotEmpty(packTransportList)) {
				ProdPackageGroupTransport transport = packTransportList.get(0);
				packDetail.setAutopackage(transport.getAutoPackage());
			}
			
			Long productBranchId = packDetail.getObjectId();
			ProdProductBranch productBranch = prodProductBranchAdapterService
					.findProdProductBranchById(productBranchId);
			if(productBranch != null){
				ProdProduct prodProduct = prodProductHotelAdapterService
						.findProdProductByProductId(productBranch.getProductId());
				if(prodProduct != null){
					productBranch.setCategoryName(prodProduct.getBizCategory()
							.getCategoryName());
					productBranch.setProductName(prodProduct.getProductName());
					productBranch.setCategoryId(prodProduct.getBizCategory()
							.getCategoryId());
					
					if (prodProduct.getBizDistrict() != null) {
						productBranch.setDistrictName(prodProduct.getBizDistrict()
								.getDistrictName());
					}
				}
				packDetail.setProdProductBranch(productBranch);
				packDetailList.add(packDetail);
			}
		}
	}

	// 通过条件查询加价
	private void findUpdateGroupDetailAddPriceByIds(String detailIds,
			List<ProdPackageDetailAddPrice> packDetailList) {
		String[] detailIdArr = detailIds.split("[,]");
		for (String detailId : detailIdArr) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("detailId", detailId);
			List<ProdPackageDetailAddPrice> packDetailAddPriceList = MiscUtils.autoUnboxing(prodPackageDetailAddPriceService
					.findProdPackageDetailAddPriceList(map));
			if (CollectionUtils.isNotEmpty(packDetailAddPriceList)) {
				Long productBranchId = null;
				ProdProductBranch productBranch = null;
				for (ProdPackageDetailAddPrice addPrice : packDetailAddPriceList) {
					productBranchId = addPrice.getObjectId();
					productBranch = prodProductBranchAdapterService
							.findProdProductBranchById(productBranchId);
					ProdProduct prodProduct = prodProductHotelAdapterService
							.findProdProductByProductId(productBranch
									.getProductId());
					productBranch.setCategoryName(prodProduct.getBizCategory()
							.getCategoryName());
					productBranch.setProductName(prodProduct.getProductName());
					productBranch.setCategoryId(prodProduct.getBizCategory()
							.getCategoryId());
					if (prodProduct.getBizDistrict() != null) {
						productBranch.setDistrictName(prodProduct
								.getBizDistrict().getDistrictName());
					}
					addPrice.setProdProductBranch(productBranch);
					packDetailList.add(addPrice);
				}
			}
		}
	}

	/**
	 * 当打包的门票规格下不存在可打包的票种（成人、儿童、亲子、家庭、双人）， 或门票规格下的上述票种不可售时
	 * 
	 * @param packDetailList
	 *            被打包规格列表
	 * @return
	 */
	private String isAvaliableBranch4Pack(List<ProdPackageDetail> packDetailList) {
		StringBuffer unAvaliableBranchStr = new StringBuffer();
		if (packDetailList == null || packDetailList.size() == 0) {
			return unAvaliableBranchStr.toString();
		}

		List<String> goodsSpecList = Arrays.asList(new String[] {
				SuppGoods.GOODSSPEC.ADULT.name(),
				SuppGoods.GOODSSPEC.CHILDREN.name(),
				SuppGoods.GOODSSPEC.PARENTAGE.name(),
				SuppGoods.GOODSSPEC.FAMILY.name(),
				SuppGoods.GOODSSPEC.COUPE.name(),
				SuppGoods.GOODSSPEC.LOVER.name() });

		for (ProdPackageDetail detail : packDetailList) {
			ProdProductBranch branch = detail.getProdProductBranch();
			if (branch != null) {
				this.isAvaliableOneBranch4Pack(branch, unAvaliableBranchStr,
						goodsSpecList);
			}
		}

		if (unAvaliableBranchStr.length() == 0) {
			return unAvaliableBranchStr.toString();
		}
		return unAvaliableBranchStr.toString().substring(0,
				unAvaliableBranchStr.length() - 1);
	}

	/**
	 * 当打包的门票规格下不存在可打包的票种（成人、儿童、亲子、家庭、双人）， 或门票规格下的上述票种不可售时
	 * 
	 * @param packDetailList
	 *            被打包规格列表
	 * @return
	 */
	private String isAvaliableBranch4Pack1(
			List<ProdPackageDetailAddPrice> packDetailList) {
		StringBuffer unAvaliableBranchStr = new StringBuffer();
		if (packDetailList == null || packDetailList.size() == 0) {
			return unAvaliableBranchStr.toString();
		}

		List<String> goodsSpecList = Arrays.asList(new String[] {
				SuppGoods.GOODSSPEC.ADULT.name(),
				SuppGoods.GOODSSPEC.CHILDREN.name(),
				SuppGoods.GOODSSPEC.PARENTAGE.name(),
				SuppGoods.GOODSSPEC.FAMILY.name(),
				SuppGoods.GOODSSPEC.COUPE.name(),
				SuppGoods.GOODSSPEC.LOVER.name() });

		for (ProdPackageDetailAddPrice detail : packDetailList) {
			ProdProductBranch branch = detail.getProdProductBranch();
			if (branch != null) {
				this.isAvaliableOneBranch4Pack(branch, unAvaliableBranchStr,
						goodsSpecList);
			}
		}

		if (unAvaliableBranchStr.length() == 0) {
			return unAvaliableBranchStr.toString();
		}
		return unAvaliableBranchStr.toString().substring(0,
				unAvaliableBranchStr.length() - 1);
	}

	/**
	 * 判断给定打包门票规格是否有效
	 * 
	 * @param branch
	 * @param unAvaliableBranchStr
	 * @param goodsSpecList
	 */
	private void isAvaliableOneBranch4Pack(ProdProductBranch branch,
			StringBuffer unAvaliableBranchStr, List<String> goodsSpecList) {
		// 判断规格自身是否有效
		if ("N".equalsIgnoreCase(branch.getCancelFlag())) {
			unAvaliableBranchStr.append("\"" + branch.getBranchName() + "("
					+ branch.getProductBranchId() + ")\"、");
			return;
		}

		// 获取规格下可打包的票种（成人、儿童、亲子、家庭、双人）集合
		List<SuppGoods> avalibleList = new ArrayList<SuppGoods>();
		List<SuppGoods> goodsList = MiscUtils.autoUnboxing( suppGoodsService.findSuppGoodsByBranchId(branch.getProductBranchId()) );
		if (CollectionUtils.isNotEmpty(goodsList)) {
			for (SuppGoods suppGoods : goodsList) {
				if (goodsSpecList.contains(suppGoods.getGoodsSpec())) {
					avalibleList.add(suppGoods);
				}
			}
		}

		// 规格下不存在可打包票种
		if (avalibleList.size() == 0) {
			unAvaliableBranchStr.append("\"" + branch.getBranchName() + "("
					+ branch.getProductBranchId() + ")\"、");
			return;
		}

		// 判断是否存在有效的可打包门票
		boolean isGoodsAvaliable = false;
		for (SuppGoods s : avalibleList) {
			if ("Y".equalsIgnoreCase(s.getOnlineFlag())) {
				isGoodsAvaliable = true;
				break;
			}
		}
		if (!isGoodsAvaliable) {
			unAvaliableBranchStr.append("\"" + branch.getBranchName() + "("
					+ branch.getProductBranchId() + ")\"、");
		}
	}

	@RequestMapping(value = "/showSingleUpdateGroupDetail")
	public Object showSingleUpdateGroupDetail(Model model, String groupType,
			String detailIds, Long toGroupId, Long backGroupId,
			HttpServletRequest req) throws Exception {
		Map<String,Object> selectParams = new HashMap<String, Object>();
		if (StringUtil.isEmptyString(detailIds)) {//属于自动打包进入,取第一条详情记录
			List<ProdPackageDetail> toList = null;
			if (toGroupId!=null && toGroupId>0) {
				selectParams.put("groupId", toGroupId);
				 toList = prodPackageDetailService.selectByParams(selectParams);
			}
			if (CollectionUtils.isEmpty(toList)) {
				selectParams.put("groupId", backGroupId);
				toList = prodPackageDetailService.selectByParams(selectParams);
			}
			if (!CollectionUtils.isEmpty(toList)) {
				ProdPackageDetail detail = toList.get(0);
				detailIds = String.valueOf(detail.getDetailId());
			}else {
				throw new BusinessException("参数传递错误");
			}
			model.addAttribute("autopackage", "Y");
			model.addAttribute("toGroupId", toGroupId);
			model.addAttribute("backGroupId", backGroupId);
		}
		
		if (StringUtil.isNotEmptyString(detailIds)) {
			List<ProdPackageDetail> packDetailList = new ArrayList<ProdPackageDetail>();
			findUpdateGroupDetailByIds(detailIds, packDetailList);

			// 最多只会有一条记录
			Long productId = null;
			Long subCategoryId = null;
			Long categoryId = null;
			if (packDetailList != null && !packDetailList.isEmpty()) {
				ProdPackageDetail packDetail = packDetailList.get(0);
				model.addAttribute("packDetail", packDetail);
				ProdPackageGroup packageGroup = prodPackageGroupService.findProdPackageGroupByKey(packDetail.getGroupId());
				if(packageGroup != null){
					model.addAttribute("categoryId", packageGroup.getCategoryId());
				}
				String associatedFlag = "false";
				productId = packageGroup.getProductId();
				ProdProduct prodProduct = prodProductService.findProdProductByProductId(productId);
				if(prodProduct != null){
					categoryId = prodProduct.getBizCategoryId();
					subCategoryId = prodProduct.getSubCategoryId();
				}
				if(prodProduct != null && (prodProduct.getBizCategoryId() == 15L || (prodProduct.getBizCategoryId() == 18L && prodProduct.getSubCategoryId() != 181L))){
					ProdLineRoute mainProdLineRoute= prodLineRouteService.findOnlyLineRouteId(productId).get(0);
					Map<String,Object> params = new HashMap<String, Object>();
					params.put("productId", packDetail.getProdProductBranch().getProductId());
					params.put("cancleFlag", "Y");
					List<ProdLineRoute> prodLineRouteList = MiscUtils.autoUnboxing(prodLineRouteService.findProdLineRouteByParamsSimple(params));
					if(prodLineRouteList != null && prodLineRouteList.size() == 1){
						if(prodLineRouteList.get(0).getRouteNum().equals(mainProdLineRoute.getRouteNum()) && prodLineRouteList.get(0).getStayNum().equals(mainProdLineRoute.getStayNum())){
							associatedFlag = "true";
						}
					}
					ProdProduct referProdProduct = prodProductHotelAdapterService.findProdProductByProductId(packDetail.getProdProductBranch().getProductId());
					model.addAttribute("hotelOnlineFlag",String.valueOf(destHotelAdapterUtils.checkHotelRouteEnableByProductId(referProdProduct.getProductId())));
					if(referProdProduct != null && referProdProduct.getSubCategoryId() != null && referProdProduct.getSubCategoryId() == 181L){
						associatedFlag = "false";
					}
				}
				model.addAttribute("associatedFlag", associatedFlag);
			}

			// 检查当前打包规格下是否存在可打包的票种（成人、儿童、亲子、家庭、双人）和
			// 门票规格下的上述票种是否可售，不存在不符合条件规格时，isAvaliableBranch为空串
			if (ProdPackageGroup.GROUPTYPE.LINE_TICKET.name().equalsIgnoreCase(
					groupType)) {
				String isAvaliableBranch = this
						.isAvaliableBranch4Pack(packDetailList);
				model.addAttribute("isAvaliableBranch", isAvaliableBranch);
			}

			model.addAttribute("packDetailList", packDetailList);
			model.addAttribute("groupType", groupType);
			model.addAttribute("detailIds", detailIds);
			if(productId != null){
				ProdProductAssociation prodProductAssociation = prodProductAssociationService.getProdProductAssociationByProductId(productId);
				if(prodProductAssociation != null){
					Long associatedRouteProdId = prodProductAssociation.getAssociatedRouteProdId();
					Long associatedFeeIncludeProdId = prodProductAssociation.getAssociatedFeeIncludeProdId();
					Long associatedContractProdId = prodProductAssociation.getAssociatedContractProdId();
					String feeIncludeExtra = prodProductAssociation.getFeeIncludeExtra();
					model.addAttribute("associatedRouteProdId", associatedRouteProdId);
					model.addAttribute("associatedFeeIncludeProdId", associatedFeeIncludeProdId);
					model.addAttribute("associatedContractProdId", associatedContractProdId);
					model.addAttribute("feeIncludeExtra", feeIncludeExtra);
				}
			}
            if("HOTEL".equalsIgnoreCase(groupType)){
            	if(categoryId != null && (categoryId == 15L || (categoryId == 18L && subCategoryId != 181L))){
            		if(this.volidDistributor(productId)){
            			model.addAttribute("volidDistributor", "Y");
            		}
    				return "/pack/line/showUpdateHotelGroupDetail";
    			}else{
    				return "/pack/line/showUpdateGroupDetail";
    			}
            }
            return "/pack/line/showUpdateGroupDetail";
		} else {
			throw new BusinessException("参数传递错误");
		}
	}

	// 设置特殊价格规则
	@RequestMapping(value = "/showSingleUpdateGroupDetailAddPrice")
	public Object showSingleUpdateGroupDetailAddPrice(Model model,
			String groupType, String detailIds, HttpServletRequest req)
			throws BusinessException {
		if (StringUtil.isNotEmptyString(detailIds)) {
			List<ProdPackageDetailAddPrice> packDetailAddPriceList = new ArrayList<ProdPackageDetailAddPrice>();
			findUpdateGroupDetailAddPriceByIds(detailIds,
					packDetailAddPriceList);

			// 检查当前打包规格下是否存在可打包的票种（成人、儿童、亲子、家庭、双人）和
			// 门票规格下的上述票种是否可售，不存在不符合条件规格时，isAvaliableBranch为空串
			if (ProdPackageGroup.GROUPTYPE.LINE_TICKET.name().equalsIgnoreCase(
					groupType)) {
				//门票页面显示标识:期票不支持特殊价格规则
				model.addAttribute("isLineTicket", "Y");
				
				String isAvaliableBranch = this
						.isAvaliableBranch4Pack1(packDetailAddPriceList);
				model.addAttribute("isAvaliableBranch", isAvaliableBranch);
			}
			model.addAttribute("packDetailAddPriceList", packDetailAddPriceList);
			model.addAttribute("groupType", groupType);
			model.addAttribute("detailIds", detailIds);
			return "/pack/line/showUpdateGroupDetailAddPrice";
		} else {
			throw new BusinessException("参数传递错误");
		}
	}
	
	// 跟团游、自由行(非景酒)打包酒店,设置特殊价格规则
	@RequestMapping(value = "/showSingleUpdateHotelGroupDetailAddPrice")
	public Object showSingleUpdateHotelGroupDetailAddPrice(Model model,
			String groupType, String detailIds, Long productId, HttpServletRequest req)
			throws Exception {
		if (StringUtil.isNotEmptyString(detailIds)) {
			List<ProdPackageDetailAddPrice> packDetailAddPriceList = new ArrayList<ProdPackageDetailAddPrice>();
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("detailId", Long.valueOf(detailIds));
			packDetailAddPriceList = MiscUtils.autoUnboxing(prodPackageDetailAddPriceService.findProdPackageDetailAddPriceList(params));
			List<ProdPackageDetailGoodsData> prodPackageDetailGoodsDataList = prodPackageDetailGoodsService.selectPackagedGoodsByParams(params);
			Map<Long, List<ProdPackageDetailAddPrice>> map = new HashMap<Long, List<ProdPackageDetailAddPrice>>();
			if (CollectionUtils.isNotEmpty(packDetailAddPriceList)) {
				for (ProdPackageDetailAddPrice addPrice : packDetailAddPriceList) {
					if(map != null && map.containsKey(addPrice.getObjectId())){
						continue;
					}
					if(ProdPackageDetail.OBJECT_TYPE_DESC.SUPP_GOODS.name().equalsIgnoreCase(addPrice.getObjectType())){
						List<ProdPackageDetailAddPrice> detailAddPrices = new ArrayList<ProdPackageDetailAddPrice>();
						detailAddPrices.add(addPrice);
						map.put(addPrice.getObjectId(), detailAddPrices);
					}
				}
				if(CollectionUtils.isNotEmpty(prodPackageDetailGoodsDataList)){
					for(ProdPackageDetailGoodsData packageDetailGoodsData : prodPackageDetailGoodsDataList){
						if(packageDetailGoodsData.getSuppGoodsId() != null ){
							if(map != null && map.size() > 0){
								if(map.get(packageDetailGoodsData.getSuppGoodsId()) != null){
									packageDetailGoodsData.setProdPackageDetailAddPriceList(map.get(packageDetailGoodsData.getSuppGoodsId()));
									break;
								}
							}
						}
					}
				}
			}
			if(CollectionUtils.isNotEmpty(prodPackageDetailGoodsDataList)){
				for(ProdPackageDetailGoodsData packageDetailGoodsData : prodPackageDetailGoodsDataList){
					if(packageDetailGoodsData.getSuppGoodsId() != null ){
						SuppGoods suppGoods = MiscUtils.autoUnboxing(suppGoodsHotelAdapterService.findSuppGoodsById(packageDetailGoodsData.getSuppGoodsId()));
						packageDetailGoodsData.setPayTarget(suppGoods.getPayTarget());
						packageDetailGoodsData.setGoodsName(suppGoods.getGoodsName());
					}
				}
			}
			model.addAttribute("prodPackageDetailGoodsDataList", prodPackageDetailGoodsDataList);
			if(CollectionUtils.isEmpty(packDetailAddPriceList)){
				model.addAttribute("NoPackDetailAddPrice", "Y");
			}else{
				model.addAttribute("NoPackDetailAddPrice", "N");
			}
			model.addAttribute("groupType", groupType);
			model.addAttribute("detailIds", detailIds);
			if(this.volidDistributor(productId)){
    			model.addAttribute("volidDistributor", "Y");
    		}
			return "/pack/line/showUpdateHotelGroupDetailAddPrice";
		} else {
			throw new BusinessException("参数传递错误");
		}
	}
	
	// 跟团游、自由行(非景酒)打包酒店,显示删除特殊价格
	@RequestMapping(value = "/showDeleteHotelGroupDetailAddPrice")
	public Object showDeleteHotelGroupDetailAddPrice(Model model,
			String groupType, String detailIds, HttpServletRequest req)
			throws BusinessException {
		if (StringUtil.isNotEmptyString(detailIds)) {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("detailId", Long.valueOf(detailIds));
			List<ProdPackageDetailGoodsData> prodPackageDetailGoodsDataList = prodPackageDetailGoodsService.selectPackagedGoodsByParams(params);
			if(CollectionUtils.isNotEmpty(prodPackageDetailGoodsDataList)){
				for(ProdPackageDetailGoodsData packageDetailGoodsData : prodPackageDetailGoodsDataList){
					if(packageDetailGoodsData.getSuppGoodsId() != null ){
						SuppGoods suppGoods = MiscUtils.autoUnboxing(suppGoodsHotelAdapterService.findSuppGoodsById(packageDetailGoodsData.getSuppGoodsId()));
						packageDetailGoodsData.setPayTarget(suppGoods.getPayTarget());
						packageDetailGoodsData.setGoodsName(suppGoods.getGoodsName());
					}
				}
			}
			model.addAttribute("prodPackageDetailGoodsDataList", prodPackageDetailGoodsDataList);
			model.addAttribute("groupType", groupType);
			model.addAttribute("detailIds", detailIds);
			return "/pack/line/showDeleteteHotelGroupDetailAddPrice";
		} else {
			throw new BusinessException("参数传递错误");
		}
	}

	// 查询分段加价
	@RequestMapping("/getLinePackDetailAddPrice")
	@ResponseBody
	public Object getLinePackDetailAddPrice(ModelMap model, Long detailId) {
		ResultMessage msg = ResultMessage.createResultMessage();
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("detailId", detailId);
			List<ProdPackageDetailAddPrice> addPriceList = MiscUtils.autoUnboxing(prodPackageDetailAddPriceService
					.findProdPackageDetailAddPriceList(map));
			msg.addObject("addPriceList", addPriceList);
		} catch (Exception e) {
			log.error(ExceptionFormatUtil.getTrace(e));
			msg.raise("查询分段加价异常.");
		}
		msg.setCode(ResultMessage.SUCCESS);
		return msg;
	}
	
	// 跟团游,自由行(非景酒)打包酒店,查询特殊加价
	@RequestMapping("/getPackHotelDetailAddPrice")
	@ResponseBody
	public Object getPackHotelDetailAddPrice(Model model, Long detailId ,String suppGoodsIds) {
		ResultMessage resultMessage = ResultMessage.createResultMessage();
		if(StringUtil.isEmptyString(suppGoodsIds)){
			resultMessage.setCode(ResultMessage.ERROR);
			return resultMessage;
		}
		try {
			String[] goodsIds = suppGoodsIds.split(",");
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("detailId", detailId);
			map.put("objectId", goodsIds[0]);
			List<ProdPackageDetailAddPrice> addPriceList = MiscUtils.autoUnboxing(prodPackageDetailAddPriceService
					.findProdPackageDetailAddPriceList(map));
			resultMessage.addObject("addPriceList", addPriceList);
		} catch (Exception e) {
			log.error(ExceptionFormatUtil.getTrace(e));
			resultMessage.raise("查询特殊加价异常.");
		}
		resultMessage.setCode(ResultMessage.SUCCESS);
		return resultMessage;
	}	
	

	/**
	 * 更新价格规则
	 * @param model
	 * @param packDetail 打包组
	 * @param productId 产品Id
	 * @param groupType 组类型
	 * @return
	 * @throws BusinessException
     */
	@RequestMapping(value = "/updateGroupDetail")
	@ResponseBody
	public Object updateGroupDetail(Model model, ProdPackageDetail packDetail,
			Long productId,String groupType) throws BusinessException {
			
		if (packDetail != null) {
			String detailIds = packDetail.getDetailIds();
			if (StringUtil.isNotEmptyString(detailIds)) {

				String[] detailIdArr = detailIds.split("[,]");
				List<ProdPackageDetail> packDetailList = new ArrayList<ProdPackageDetail>();
				for (String detailId : detailIdArr) {
					ProdPackageDetail oldPackDetail = prodPackageDetailService
							.selectByPrimaryKey(Long.parseLong(detailId));
					if (oldPackDetail != null) {

						String log = getPackDetailLog(packDetail, oldPackDetail,false);
						if (StringUtil.isNotEmptyString(log)) {
							comLogService
									.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP,
											productId,
											productId,
											this.getLoginUserId(),
											"设置价格规则:" + log,
											COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP
													.name(), "设置价格规则", null);

							oldPackDetail.setPrice(packDetail.getPrice());
							oldPackDetail.setPriceType(packDetail
									.getPriceType());
							packDetailList.add(oldPackDetail);
						}
					}
				}

				if (packDetailList.size() > 0) {
					prodPackageDetailService.updateProdPackageDetail(packDetailList);
					ProdProduct prodProduct = this.prodProductService.findProdProductById(productId, null);
					/* 更改了加价规则，分发消息出去 */
					
					for(ProdPackageDetail prodPackageDetail : packDetailList){
						if(prodPackageDetail != null){
							this.handOut4Price(prodProduct.getBizCategoryId(),productId,
									String.valueOf(prodPackageDetail.getGroupId()),
									String.valueOf(prodPackageDetail.getObjectId()),groupType);
						}
					}
					//COM_CAL_DATA表插入数据，给价格平台使用
					this.calInset(prodProduct);
				}
			}
		} else {
			throw new BusinessException("参数传递错误");
		}

		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}
	
	/**
	 * 跟团游,自由行(非景酒)打包酒店更新价格规则
	 * @param model
	 * @param packDetail 打包组
	 * @param productId 产品Id
	 * @param groupType 组类型
	 * @return
	 * @throws BusinessException
     */
	@RequestMapping(value = "/updateHotelGroupDetail")
	@ResponseBody
	public Object updateHotelGroupDetail(Model model, ProdPackageDetail packDetail,
			Long productId,String groupType) throws BusinessException {
			
		if (packDetail != null) {
			String detailIds = packDetail.getDetailIds();
			if (StringUtil.isNotEmptyString(detailIds)) {

				String[] detailIdArr = detailIds.split("[,]");
				List<ProdPackageDetail> packDetailList = new ArrayList<ProdPackageDetail>();
				for (String detailId : detailIdArr) {
					ProdPackageDetail oldPackDetail = prodPackageDetailService
							.selectByPrimaryKey(Long.parseLong(detailId));
					if (oldPackDetail != null) {

						String log = getPackDetailLog(packDetail, oldPackDetail,false);
						if (StringUtil.isNotEmptyString(log)) {
							comLogService
									.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP,
											productId,
											productId,
											this.getLoginUserId(),
											"设置价格规则:" + log,
											COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP
													.name(), "设置价格规则", null);

							oldPackDetail.setPrice(packDetail.getPrice());
							oldPackDetail.setPriceType(packDetail
									.getPriceType());
							packDetailList.add(oldPackDetail);
						}
					}
				}

				if (packDetailList.size() > 0) {
					prodPackageDetailService.updateProdPackageDetail(packDetailList);
					ProdProduct prodProduct = this.prodProductService.findProdProductById(productId, null);
					/* 更改了加价规则，分发消息出去 */
					for(ProdPackageDetail prodPackageDetail : packDetailList){
						if(prodPackageDetail != null){
							this.handOut4Price(prodProduct.getBizCategoryId(),productId,
									String.valueOf(prodPackageDetail.getGroupId()),
									String.valueOf(prodPackageDetail.getObjectId()),groupType);
						}
					}
					//COM_CAL_DATA表插入数据，给价格平台使用
					this.calInset(prodProduct);
				}
			}

		} else {
			throw new BusinessException("参数传递错误");
		}

		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}
	
	@RequestMapping(value = "/updateSingleGroupDetail")
	@ResponseBody
	public Object updateSingleGroupDetail(HttpServletRequest request) throws BusinessException {
		String detailId = request.getParameter("detailId");
		String isShowFirst = request.getParameter("isShowFirst");
		String productId = request.getParameter("productId");
		if(StringUtil.isNotEmptyString(productId)&&StringUtil.isNotEmptyString(detailId)){
		
			Map<String, Object> packGroupParams = new HashMap<String, Object>();
			packGroupParams.put("productId", Long.parseLong(productId));
			packGroupParams.put("groupType", "HOTEL");
			
			List<ProdPackageGroup> packHotelGroupList = prodLineGroupPackService.findProdLinePackGroupByParams(packGroupParams);
			if(packHotelGroupList!=null&&packHotelGroupList.size()>0){
				for(ProdPackageGroup ppg : packHotelGroupList){
					if(ppg.getProdPackageDetails()!=null){
						for(ProdPackageDetail ppd : ppg.getProdPackageDetails()){
							if("Y".equals(ppd.getIsShowFirst())&&ppd.getDetailId()!=Long.parseLong(detailId)){
								return ResultMessage.SET_SHOW_FIRST_DUP;
							}
						}
					}
				}
			}
		
			ProdPackageDetail oldPackDetail = prodPackageDetailService.selectByPrimaryKey(Long.parseLong(detailId));
			oldPackDetail.setIsShowFirst(isShowFirst);
			prodPackageDetailService.updateSingleProdPackageDetail(oldPackDetail);
			
			return ResultMessage.UPDATE_SUCCESS_RESULT;
		}else{
			throw new BusinessException("参数传递错误");
		}
	}
	
	/**
	 * 自动打包时，批量更新价格规则
	 * @param model
	 * @param packDetail
	 * @param productId
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/autopackageUpdateGroupDetail")
	@ResponseBody
	public Object autopackageUpdateGroupDetail(Model model, ProdPackageDetail packDetail,
			Long productId,Long toGroupId,Long backGroupId) throws BusinessException {
		if (packDetail == null) {
			return ResultMessage.UPDATE_FAIL_RESULT;
		}
		String detailIds = packDetail.getDetailIds();
		String[] detailIdArr = null;
		
		if (StringUtil.isNotEmptyString(detailIds)) {
			detailIdArr = detailIds.split("[,]"); 
			ProdPackageDetail oldPackDetail = prodPackageDetailService.selectByPrimaryKey(Long.parseLong(detailIdArr[0]));
			if (oldPackDetail == null) {
				return ResultMessage.UPDATE_FAIL_RESULT;
			}
			
			//批量更新价格规则
			prodPackageDetailService.batchUpdatePackageDetailByParams(packDetail,toGroupId,backGroupId);
			
			//插入日志
			String groupLog = "";
			if (toGroupId!=null && toGroupId>0L) {
				groupLog += "去程组ID:"+toGroupId;
			}
			if (backGroupId!=null && backGroupId>0L) {
				groupLog += ","+"返程组ID"+backGroupId;
			}
			String log = getPackDetailLog(packDetail, oldPackDetail,true);
			if (StringUtil.isNotEmptyString(log)) {
				comLogService
						.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP,
								productId,
								productId,
								this.getLoginUserId(),
								"设置价格规则:" + groupLog +log,
								COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP
										.name(), "设置价格规则", null);
			}
			
		}else {
			throw new BusinessException("参数传递错误");
		}

		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}


	/**
	 * 设置特殊价格规则  景酒
	 * @param model
	 * @param detailAddPrice 加价对象
	 * @param productId 产品Id
	 * @return
	 * @throws BusinessException
     */
	@RequestMapping(value = "/updateGroupDetailAddPrice")
	@ResponseBody
	public Object updateGroupDetailAddPrice(Model model, ProdPackageDetailAddPrice detailAddPrice, Long productId) throws BusinessException {
		if(detailAddPrice == null) {
			throw new BusinessException("参数传递错误");
		}
		
		//得到适合日期
		List<Date> dateList = CalendarUtils.getDates(detailAddPrice.getStartDate(), detailAddPrice.getEndDate(), detailAddPrice.getWeekDay());
		Long detailId = detailAddPrice.getDetailId();
		//获取规格和组
		ProdPackageDetail packDetail = prodPackageDetailService.selectByPrimaryKey(detailId);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("detailId", detailId);
		List<ProdPackageDetailAddPrice> packDetailAddPriceList = MiscUtils.autoUnboxing(prodPackageDetailAddPriceService.findProdPackageDetailAddPriceList(params));
		//日志使用
		Map<Long, ProdPackageDetailAddPrice> addPriceMap = new HashMap<Long, ProdPackageDetailAddPrice>();
		
		//存放要保存的
		List<ProdPackageDetailAddPrice> saveList = new ArrayList<ProdPackageDetailAddPrice>();
		//存放要更新的
		List<ProdPackageDetailAddPrice> updateList = new ArrayList<ProdPackageDetailAddPrice>();
		
		ProdPackageDetailAddPrice packDetailAddPrice = null;
		if(CollectionUtils.isNotEmpty(packDetailAddPriceList)) {
			ProdPackageDetailAddPrice ap = null;
			for(ProdPackageDetailAddPrice p : packDetailAddPriceList) {
				boolean isContain = dateList.contains(p.getSpecDate());
				//更新
				if(isContain) {
					//日志使用
					ap = new ProdPackageDetailAddPrice();
					ap.setAddPriceId(p.getAddPriceId());
					ap.setPriceType(p.getPriceType());
					ap.setPrice(p.getPrice());
					ap.setSpecDate(p.getSpecDate());
					addPriceMap.put(ap.getAddPriceId(), ap);
					
					p.setPriceType(detailAddPrice.getPriceType());
					p.setPrice(detailAddPrice.getPrice());
					updateList.add(p);
					dateList.remove(p.getSpecDate());
				}
			}
			for(Date d : dateList) {
				packDetailAddPrice = new ProdPackageDetailAddPrice();
				packDetailAddPrice.setDetailId(packDetail.getDetailId()); //规格和组ID
				packDetailAddPrice.setSpecDate(d); //日期
				packDetailAddPrice.setGroupId(packDetail.getGroupId()); //打包组ID
				packDetailAddPrice.setObjectId(packDetail.getObjectId()); //对象ID
				packDetailAddPrice.setObjectType(packDetail.getObjectType()); //对象类型
				packDetailAddPrice.setPrice(detailAddPrice.getPrice()); //加价值
				packDetailAddPrice.setPriceType(detailAddPrice.getPriceType()); //加价类型，百分比/固定值
				saveList.add(packDetailAddPrice);
			}
		//保存
		} else {
			if(packDetail != null) {
				for(Date d : dateList) {
					packDetailAddPrice = new ProdPackageDetailAddPrice();
					packDetailAddPrice.setDetailId(detailId); //规格和组ID
					packDetailAddPrice.setSpecDate(d); //日期
					packDetailAddPrice.setGroupId(packDetail.getGroupId()); //打包组ID
					packDetailAddPrice.setObjectId(packDetail.getObjectId()); //对象ID
					packDetailAddPrice.setObjectType(packDetail.getObjectType()); //对象类型
					packDetailAddPrice.setPrice(detailAddPrice.getPrice()); //加价值
					packDetailAddPrice.setPriceType(detailAddPrice.getPriceType()); //加价类型，百分比/固定值
					saveList.add(packDetailAddPrice);
				}
			}
		}
		
		//保存列表
		if(saveList.size() > 0) {
			prodPackageDetailAddPriceService.saveProdPackageDetailAddPriceList(saveList);
		}
		
		//更新列表
		if(updateList.size() > 0) {
			prodPackageDetailAddPriceService.updateProdPackageDetailAddPrice(updateList);
		}

		//修改特殊加价规则，给分销商发消息
		Map<String,Object> pams = new HashMap<String,Object>();
		pams.put("groupId",packDetail.getGroupId());
		ProdProduct prodProduct = this.prodProductService.findProdProductById(productId, null);
		//获取相应的打包组
		List<ProdPackageGroup> prodPackageGroups = this.prodPackageGroupService.findProdPackageGroup(pams);
		if(prodProduct != null && CollectionUtils.isNotEmpty(prodPackageGroups)){
			String groupType = prodPackageGroups.get(0).getGroupType();

			for(ProdPackageDetailAddPrice addPri :updateList){
				dateList.add(addPri.getSpecDate());
			}
			//datelist也发出去
			if(CollectionUtils.isNotEmpty(dateList)){
				StringBuffer dateBuffer = new StringBuffer();
				for(Date date : dateList) {
					if(date != null){
						dateBuffer.append(DateUtil.formatDate(date,"yyyyMMdd")).append(",");
					}
				}
				String dateStr = dateBuffer.toString().endsWith(",") ?
						dateBuffer.toString().substring(0,dateBuffer.toString().length()-1) : dateBuffer.toString();
				String relateInfo = String.valueOf(packDetail.getObjectId())+"|"+dateStr;
				this.handOut4SpecialPrice(prodProduct.getBizCategoryId(),productId,String.valueOf(packDetail.getGroupId()),relateInfo, groupType);
			}
		}

		//操作日志-新增特殊加价日志
		if(CollectionUtils.isNotEmpty(saveList)) {
			for(ProdPackageDetailAddPrice ap : saveList) {
				String saveLog = getGroupDetailAddPriceLog(ap, null);
				if(saveLog.length() > 0) {
					comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP, productId, productId,
							this.getLoginUserId(), "新增特殊价格规则:" + saveLog,
							COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP.name(), "新增特殊价格规则", null);
				}
			}
		}
		//操作日志-修改特殊加价日志
		if(CollectionUtils.isNotEmpty(updateList)) {
			for(ProdPackageDetailAddPrice ap : updateList) {
				String updateLog = getGroupDetailAddPriceLog(ap, addPriceMap.get(ap.getAddPriceId()));
				if(updateLog.length() > 0) {
					comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP, productId, productId,
							this.getLoginUserId(), "修改特殊价格规则:" + updateLog,
							COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP.name(), "修改特殊价格规则", null);
				}
			}
		}
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}
	
	/**
	 * 跟团游,自由行(非景酒)打包酒店,设置特殊价格规则
	 * @param model
	 * @param detailAddPrice 加价对象
	 * @param productId 产品Id
	 * @return
	 * @throws BusinessException
     */
	@RequestMapping(value = "/updateHotelGroupDetailAddPrice")
	@ResponseBody
	public Object updateHotelGroupDetailAddPrice(Model model, ProdPackageDetailAddPrice detailAddPrice, Long productId, String suppGoodsIds) throws BusinessException {
		if(detailAddPrice == null || StringUtil.isEmptyString(suppGoodsIds)) {
			throw new BusinessException("参数传递错误");
		}
		String[] goodsIds = suppGoodsIds.split(",");
		if(goodsIds == null || goodsIds.length == 0){
			throw new BusinessException("参数传递错误");
		}
		//得到适合日期
		List<Date> dateList = CalendarUtils.getDates(detailAddPrice.getStartDate(), detailAddPrice.getEndDate(), detailAddPrice.getWeekDay());
		Long detailId = detailAddPrice.getDetailId();
		ProdPackageDetail packDetail = prodPackageDetailService.selectByPrimaryKey(detailId);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("detailId", detailId);
		List<ProdPackageDetailAddPrice> packDetailAddPriceList = MiscUtils.autoUnboxing(prodPackageDetailAddPriceService.findProdPackageDetailAddPriceList(params));
		//日志使用
		Map<Long, ProdPackageDetailAddPrice> addPriceMap = new HashMap<Long, ProdPackageDetailAddPrice>();
		
		//存放要保存的
		List<ProdPackageDetailAddPrice> saveList = new ArrayList<ProdPackageDetailAddPrice>();
		//存放要更新的
		List<ProdPackageDetailAddPrice> updateList = new ArrayList<ProdPackageDetailAddPrice>();
		
		ProdPackageDetailAddPrice packDetailAddPrice = null;
		if(CollectionUtils.isNotEmpty(packDetailAddPriceList)) {
			ProdPackageDetailAddPrice ap = null;
			for(ProdPackageDetailAddPrice p : packDetailAddPriceList) {
				if(!p.getObjectId().equals(Long.valueOf(goodsIds[0]))){
					continue;
				}
				boolean isContain = dateList.contains(p.getSpecDate());
				//更新
				if(isContain) {
					
					//日志使用
					ap = new ProdPackageDetailAddPrice();
					ap.setAddPriceId(p.getAddPriceId());
					ap.setPriceType(p.getPriceType());
					ap.setPrice(p.getPrice());
					ap.setSpecDate(p.getSpecDate());
					addPriceMap.put(ap.getAddPriceId(), ap);
					
					p.setPriceType(detailAddPrice.getPriceType());
					p.setPrice(detailAddPrice.getPrice());
					updateList.add(p);
					dateList.remove(p.getSpecDate());
				}
			}
			for(Date d : dateList) {
				packDetailAddPrice = new ProdPackageDetailAddPrice();
				packDetailAddPrice.setDetailId(packDetail.getDetailId()); //规格和组ID
				packDetailAddPrice.setSpecDate(d); //日期
				packDetailAddPrice.setGroupId(packDetail.getGroupId()); //打包组ID
				packDetailAddPrice.setObjectId(Long.valueOf(goodsIds[0])); //对象ID
				packDetailAddPrice.setObjectType(ProdPackageDetail.OBJECT_TYPE_DESC.SUPP_GOODS.name()); //对象类型
				packDetailAddPrice.setPrice(detailAddPrice.getPrice()); //加价值
				packDetailAddPrice.setPriceType(detailAddPrice.getPriceType()); //加价类型，利润百分比/固定值/按结算价比例加价
				saveList.add(packDetailAddPrice);
			}
		//保存
		} else {
			if(packDetail != null) {
				List<Long> suppGoodsIdList = new ArrayList<Long>(); 
				for(int i=0; i<goodsIds.length; i++){
					suppGoodsIdList.add(Long.valueOf(goodsIds[i]));
				}
				if(CollectionUtils.isNotEmpty(suppGoodsIdList)){
					for(Long goodsId : suppGoodsIdList){
						for(Date d : dateList) {
							packDetailAddPrice = new ProdPackageDetailAddPrice();
							packDetailAddPrice.setDetailId(detailId); //规格和组ID
							packDetailAddPrice.setSpecDate(d); //日期
							packDetailAddPrice.setGroupId(packDetail.getGroupId()); //打包组ID
							packDetailAddPrice.setObjectId(goodsId); //对象ID
							packDetailAddPrice.setObjectType(ProdPackageDetail.OBJECT_TYPE_DESC.SUPP_GOODS.name()); //对象类型
							packDetailAddPrice.setPrice(detailAddPrice.getPrice()); //加价值
							packDetailAddPrice.setPriceType(detailAddPrice.getPriceType()); //加价类型，利润百分比/固定值/按结算价比例加价
							saveList.add(packDetailAddPrice);
						}
					}
				}
			}
		}
		
		//保存列表
		if(saveList != null && saveList.size() > 0) {
			prodPackageDetailAddPriceService.saveProdPackageDetailAddPriceList(saveList);
		}
		
		//更新列表
		if(updateList != null && updateList.size() > 0) {
			prodPackageDetailAddPriceService.updateProdPackageDetailAddPrice(updateList);
		}

		//修改特殊加价规则，给分销商发消息
		Map<String,Object> pams = new HashMap<String,Object>();
		pams.put("groupId",packDetail.getGroupId());
		ProdProduct prodProduct = this.prodProductService.findProdProductById(productId, null);
		//获取相应的打包组
		List<ProdPackageGroup> prodPackageGroups = this.prodPackageGroupService.findProdPackageGroup(pams);
		if(prodProduct != null && CollectionUtils.isNotEmpty(prodPackageGroups)){
			String groupType = prodPackageGroups.get(0).getGroupType();
			for(ProdPackageDetailAddPrice addPri :updateList){
				dateList.add(addPri.getSpecDate());
			}
			//datelist也发出去
			if(CollectionUtils.isNotEmpty(dateList)){
				StringBuffer dateBuffer = new StringBuffer();
				for(Date date : dateList) {
					if(date != null){
						dateBuffer.append(DateUtil.formatDate(date,"yyyyMMdd")).append(",");
					}
				}
				String dateStr = dateBuffer.toString().endsWith(",") ?
						dateBuffer.toString().substring(0,dateBuffer.toString().length()-1) : dateBuffer.toString();
				String relateInfo = String.valueOf(suppGoodsIds)+"|"+dateStr;
				this.handOut4SpecialPriceSupp(prodProduct.getBizCategoryId(),productId,String.valueOf(packDetail.getGroupId()),relateInfo, groupType,ComPush.OPERATE_TYPE.UP.name());
			}
		}

		//操作日志-新增特殊加价日志
		if(CollectionUtils.isNotEmpty(saveList)) {
			for(ProdPackageDetailAddPrice ap : saveList) {
				String saveLog = getHotelGroupDetailAddPriceLog(ap, null);
				if(saveLog.length() > 0) {
					comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP, productId, productId,
							this.getLoginUserId(), "新增特殊价格规则:" + saveLog,
							COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP.name(), "新增特殊价格规则", null);
				}
			}
		}
		//操作日志-修改特殊加价日志
		if(CollectionUtils.isNotEmpty(updateList)) {
			for(ProdPackageDetailAddPrice ap : updateList) {
				String updateLog = getHotelGroupDetailAddPriceLog(ap, addPriceMap.get(ap.getAddPriceId()));
				if(updateLog.length() > 0) {
					comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP, productId, productId,
							this.getLoginUserId(), "修改特殊价格规则:" + updateLog,
							COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP.name(), "修改特殊价格规则", null);
				}
			}
		}
		ResultMessage resultMessage = (ResultMessage)getPackHotelDetailAddPrice(model, detailId , suppGoodsIds);
		return resultMessage;
	}
	
	/**
	 * 跟团游,自由行(非景酒)打包酒店,删除特殊价格
	 * @param model
	 * @param detailAddPrice 加价对象
	 * @param productId 产品Id
	 * @return
	 * @throws BusinessException
     */
	@RequestMapping(value="/deleteHotelGroupDetailAddPrice")
	@ResponseBody
	public Object deleteHotelGroupDetailAddPrice(Model model, ProdPackageDetailAddPrice detailAddPrice, Long productId, String suppGoodsIds, HttpServletRequest request) throws BusinessException{
		if(detailAddPrice == null || StringUtil.isEmptyString(suppGoodsIds)) {
			throw new BusinessException("参数传递错误");
		}
		String[] goodsIds = suppGoodsIds.split(",");
		if(goodsIds == null || goodsIds.length == 0){
			throw new BusinessException("参数传递错误");
		}
		List<Date> dateList = CalendarUtils.getDates(detailAddPrice.getStartDate(), detailAddPrice.getEndDate(), detailAddPrice.getWeekDay());
		Long detailId = detailAddPrice.getDetailId();
		Map<String, Object> params = new HashMap<String, Object>();
		List<Long> suppGoodsIdList = new ArrayList<Long>(); 
		for(int i=0; i<goodsIds.length; i++){
			suppGoodsIdList.add(Long.valueOf(goodsIds[i]));
		}
		if(CollectionUtils.isNotEmpty(suppGoodsIdList)){
			for(Long goodsId : suppGoodsIdList){
				params.clear();
				params.put("detailId", detailId);
				params.put("objectId", goodsId);
				params.put("specDateList", dateList);
				prodPackageDetailAddPriceService.deleteHotelGroupDetailAddPrice(params);
				// 添加操作日志
				try {
					StringBuffer dateBuffer = new StringBuffer();
					for(Date date : dateList){
						dateBuffer.append(CalendarUtils.getDateFormatString(date, "yyyy-MM-dd")+",");
					}
					dateBuffer.deleteCharAt(dateBuffer.length()-1);
					comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP, productId, productId, this.getLoginUserId(), "删除特殊价格规则: 打包DetailId:" + detailId + ", 打包商品Id:" + goodsId + ",加价日期:["+dateBuffer.toString()+"]",
							COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP.name(), "删除特殊价格规则", null);
				} catch (Exception e) {
					log.error("Record Log failure ！Log type:"
							+ COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
					log.error(e.getMessage());
				}
			}
			ProdProduct routeProduct = prodProductService.getProdProductBy(productId);
			if("Y".equalsIgnoreCase(routeProduct.getMuiltDpartureFlag())){
				pushAdapterService.push(productId, ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP,
						ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.TRANS_API_JOB);
			}else{
				pushAdapterService.push(productId, ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP,
						ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
			}
			
			ProdPackageDetail prodPackageDetail = prodPackageDetailService.selectByPrimaryKey(detailId);
			if(CollectionUtils.isNotEmpty(dateList)){
				StringBuffer dateBuffer = new StringBuffer();
				for(Date date : dateList) {
					if(date != null){
						dateBuffer.append(DateUtil.formatDate(date,"yyyyMMdd")).append(",");
					}
				}
				String dateStr = dateBuffer.toString().endsWith(",") ?
						dateBuffer.toString().substring(0,dateBuffer.toString().length()-1) : dateBuffer.toString();
				String relateInfo = suppGoodsIds+"|"+dateStr;
				this.handOut4SpecialPriceSupp(routeProduct.getBizCategoryId(),productId,String.valueOf(prodPackageDetail.getGroupId()), relateInfo, request.getParameter("groupType"),ComPush.OPERATE_TYPE.DEL.name());
			}
		}
		return new ResultMessage("success","删除成功");
	}

	//跟团游,自由行(非景酒)打包酒店,特殊加价日志
	private String getHotelGroupDetailAddPriceLog(ProdPackageDetailAddPrice newAddPrice, ProdPackageDetailAddPrice oldAddPrice) {
		StringBuffer logStr = new StringBuffer();
		String newPriceType = newAddPrice.getPriceType();
		//修改
		if(oldAddPrice != null) {
			
			String oldPriceType = oldAddPrice.getPriceType();
			
			logStr.append(ComLogUtil.getLogTxt("加价日期", newAddPrice.getSpecDateStr(), oldAddPrice.getSpecDateStr()));
			
			//价格规则改变
			if(!newPriceType.equalsIgnoreCase(oldPriceType)) {
				//为恒定
				if("FIXED_PRICE".equalsIgnoreCase(newPriceType) && "MAKEUP_PRICE".equalsIgnoreCase(oldPriceType)) {
					logStr.append(ComLogUtil.getLogTxt("价格规则", "恒定加价", "百分比加价"));
					logStr.append(ComLogUtil.getLogTxt("基于结算价恒定加价", "加价: " + String.valueOf(newAddPrice.getPrice()/100)
							+ " 元", "利润: " + String.valueOf(oldAddPrice.getPrice()/100) + "%"));
					
				}else if ("FIXED_PRICE".equalsIgnoreCase(newPriceType) && "FIXED_PERCENT".equalsIgnoreCase(oldPriceType)) {
					logStr.append(ComLogUtil.getLogTxt("价格规则", "恒定加价", "基于结算价恒定,按比例加价"));
					logStr.append(ComLogUtil.getLogTxt("基于结算价恒定加价", "加价: " + String.valueOf(newAddPrice.getPrice()/100)
							+ " 元", "基于结算价恒定,按比例加价: " + String.valueOf(Float.parseFloat(oldAddPrice.getPrice()+"")/100) + "%"));
				//为百分比
				} else if("MAKEUP_PRICE".equalsIgnoreCase(newPriceType) && "FIXED_PRICE".equalsIgnoreCase(oldPriceType)) {
					logStr.append(ComLogUtil.getLogTxt("价格规则", "百分比加价", "恒定加价"));
					logStr.append(ComLogUtil.getLogTxt("基于商品利润设置", "利润: " + String.valueOf(newAddPrice.getPrice()/100)
							+ "%", "加价: " + String.valueOf(oldAddPrice.getPrice()/100) + " 元"));
					
				}else if ("MAKEUP_PRICE".equalsIgnoreCase(newPriceType) && "FIXED_PERCENT".equalsIgnoreCase(oldPriceType)) {
					logStr.append(ComLogUtil.getLogTxt("价格规则", "百分比加价", "基于结算价恒定,按比例加价"));
					logStr.append(ComLogUtil.getLogTxt("基于商品利润设置", "利润: " + String.valueOf(newAddPrice.getPrice()/100)
							+ "%", "基于结算价恒定,按比例加价: " + String.valueOf(Float.parseFloat(oldAddPrice.getPrice()+"")/100)+ "%"));
				//结算价恒定,按比例加价
				}else if("FIXED_PERCENT".equalsIgnoreCase(newPriceType) && "FIXED_PRICE".equalsIgnoreCase(oldPriceType)) {
					logStr.append(ComLogUtil.getLogTxt("价格规则", "基于结算价恒定,按比例加价", "恒定加价"));
					logStr.append(ComLogUtil.getLogTxt("基于结算价恒定,按比例加价", "基于结算价恒定,按比例加价: " + String.valueOf(Float.parseFloat(newAddPrice.getPrice()+"")/100)
							+ "%", "基于结算价恒定,加价: " + String.valueOf(oldAddPrice.getPrice()/100) + " 元"));
					
				}else if ("FIXED_PERCENT".equalsIgnoreCase(newPriceType) && "MAKEUP_PRICE".equalsIgnoreCase(oldPriceType)) {
					logStr.append(ComLogUtil.getLogTxt("价格规则", "基于结算价恒定,按比例加价", "百分比加价"));
					logStr.append(ComLogUtil.getLogTxt("基于结算价恒定,按比例加价", "基于结算价恒定,按比例加价: " + String.valueOf(Float.parseFloat(newAddPrice.getPrice()+"")/100)
							+ "%", "利润: " + String.valueOf(oldAddPrice.getPrice()/100) + " %"));
				}
			} else { //价格规则没变
				//为恒定
				if ("FIXED_PRICE".equalsIgnoreCase(newPriceType)) {
					logStr.append(ComLogUtil.getLogTxt("价格规则", "恒定加价", "恒定加价"));
					logStr.append(ComLogUtil.getLogTxt("基于结算价恒定加价", "加价: " + String.valueOf(newAddPrice.getPrice()/100)
							+ " 元", "加价: " + String.valueOf(oldAddPrice.getPrice()/100)) + " 元");
				//为百分比
				} else if ("MAKEUP_PRICE".equalsIgnoreCase(newPriceType)) {
					logStr.append(ComLogUtil.getLogTxt("价格规则", "百分比加价", "百分比加价"));
					logStr.append(ComLogUtil.getLogTxt("基于商品利润设置", "利润: " + String.valueOf(newAddPrice.getPrice()/100)
							+ "%", "利润: " + String.valueOf(oldAddPrice.getPrice()/100) + "%"));
				//结算价恒定,按比例加价	
				}else if ("FIXED_PERCENT".equalsIgnoreCase(newPriceType)) {
					logStr.append(ComLogUtil.getLogTxt("价格规则", "基于结算价恒定,按比例加价", "基于结算价恒定,按比例加价"));
					logStr.append(ComLogUtil.getLogTxt("基于结算价恒定,按比例加价", "基于结算价恒定,按比例加价: " + String.valueOf(Float.parseFloat(newAddPrice.getPrice()+"")/100)
							+ "%", "基于结算价恒定,按比例加价: " + String.valueOf(Float.parseFloat(oldAddPrice.getPrice()+"")/100) + " %"));
				}
			}
		} else { //新增
			logStr.append(ComLogUtil.getLogTxt("加价日期", newAddPrice.getSpecDateStr(), null));
			if ("FIXED_PRICE".equalsIgnoreCase(newPriceType)) {
				logStr.append(ComLogUtil.getLogTxt("价格规则", "恒定加价", null));
				logStr.append(ComLogUtil.getLogTxt("基于结算价恒定加价",
						"加价: " + String.valueOf(newAddPrice.getPrice()/100) + " 元", null));
				
			}else if ("FIXED_PERCENT".equalsIgnoreCase(newPriceType)) {
				logStr.append(ComLogUtil.getLogTxt("价格规则", "基于结算价恒定,按比例加价", null));
				logStr.append(ComLogUtil.getLogTxt("基于结算价恒定,按比例加价", "基于结算价恒定,按比例加价: " + String.valueOf(Float.parseFloat(newAddPrice.getPrice()+"")/100)
						+ "%", null));
				
			} else {
				logStr.append(ComLogUtil.getLogTxt("价格规则", "百分比加价", null));
				logStr.append(ComLogUtil.getLogTxt("基于商品利润设置", "利润的: " + String.valueOf(newAddPrice.getPrice()/100) + "%", null));
			}
		}
		if (logStr.length() > 0) {
			Long suppGoodsId = newAddPrice.getObjectId();
			SuppGoods suppGoods = MiscUtils.autoUnboxing(suppGoodsHotelAdapterService.findSuppGoodsById(suppGoodsId));
			if (suppGoods != null) {
				return "打包DetailId: " + newAddPrice.getDetailId() + ", 打包产品Id: " + suppGoods.getProductId() + ", 打包产品规格Id：" +suppGoods.getProductBranchId()
						+ ", 打包商品Id: " + suppGoodsId + ", " + logStr.toString();
			}
		}
		return "";
	}
	
	//特殊加价日志
	private String getGroupDetailAddPriceLog(ProdPackageDetailAddPrice newAddPrice, ProdPackageDetailAddPrice oldAddPrice) {
		StringBuffer logStr = new StringBuffer();
		String newPriceType = newAddPrice.getPriceType();
		//修改
		if(oldAddPrice != null) {
			
			String oldPriceType = oldAddPrice.getPriceType();
			
			logStr.append(ComLogUtil.getLogTxt("加价日期", newAddPrice.getSpecDateStr(), oldAddPrice.getSpecDateStr()));
			
			//价格规则改变
			if(!newPriceType.equalsIgnoreCase(oldPriceType)) {
				//为恒定
				if("FIXED_PRICE".equalsIgnoreCase(newPriceType)) {
					logStr.append(ComLogUtil.getLogTxt("价格规则", "恒定加价", "百分比加价"));
					logStr.append(ComLogUtil.getLogTxt("基于结算价恒定加价", "加价: " + String.valueOf(newAddPrice.getPrice()/100)
							+ " 元", "利润: " + String.valueOf(oldAddPrice.getPrice()/100) + "%"));
				//为百分比
				} else if("MAKEUP_PRICE".equalsIgnoreCase(newPriceType)) {
					logStr.append(ComLogUtil.getLogTxt("价格规则", "百分比加价", "恒定加价"));
					logStr.append(ComLogUtil.getLogTxt("基于商品利润设置", "利润: " + String.valueOf(newAddPrice.getPrice()/100)
							+ "%", "加价: " + String.valueOf(oldAddPrice.getPrice()/100) + " 元"));
				}
			} else { //价格规则没变
				//为恒定
				if ("FIXED_PRICE".equalsIgnoreCase(newPriceType)) {
					logStr.append(ComLogUtil.getLogTxt("价格规则", "恒定加价", "恒定加价"));
					logStr.append(ComLogUtil.getLogTxt("基于结算价恒定加价", "加价: " + String.valueOf(newAddPrice.getPrice()/100)
							+ " 元", "加价: " + String.valueOf(oldAddPrice.getPrice()/100)) + " 元");
				//为百分比
				} else if ("MAKEUP_PRICE".equalsIgnoreCase(newPriceType)) {
					logStr.append(ComLogUtil.getLogTxt("价格规则", "百分比加价", "百分比加价"));
					logStr.append(ComLogUtil.getLogTxt("基于商品利润设置", "利润: " + String.valueOf(newAddPrice.getPrice()/100)
							+ "%", "利润: " + String.valueOf(oldAddPrice.getPrice()/100) + "%"));
				}
			}
		} else { //新增
			logStr.append(ComLogUtil.getLogTxt("加价日期", newAddPrice.getSpecDateStr(), null));
			if ("FIXED_PRICE".equalsIgnoreCase(newPriceType)) {
				logStr.append(ComLogUtil.getLogTxt("价格规则", "恒定加价", null));
				logStr.append(ComLogUtil.getLogTxt("基于结算价恒定加价",
						"加价: " + String.valueOf(newAddPrice.getPrice()/100) + " 元", null));
			} else {
				logStr.append(ComLogUtil.getLogTxt("价格规则", "百分比加价", null));
				logStr.append(ComLogUtil.getLogTxt("基于商品利润设置", "利润的: " + String.valueOf(newAddPrice.getPrice()/100) + "%", null));
			}
		}
		if (logStr.length() > 0) {
			Long productBranchId = newAddPrice.getObjectId();
			ProdProductBranch productBranch = prodProductBranchAdapterService.findProdProductBranchById(productBranchId);
			if (productBranch != null) {
				return "打包DetailId: " + newAddPrice.getDetailId() + ", 打包产品Id: " + productBranch.getProductId()
						+ ", 打包产品规格Id: " + productBranchId + ", " + logStr.toString();
			}
		}
		return "";
	}

	private String getPackDetailLog(ProdPackageDetail packDetail, ProdPackageDetail oldPackDetail,Boolean isAutopackage) {
		StringBuffer log = new StringBuffer();

		String priceType = packDetail.getPriceType();
		String oldPriceType = oldPackDetail.getPriceType();

		if (StringUtil.isEmptyString(oldPriceType)) {
			if ("FIXED_PRICE".equalsIgnoreCase(priceType)) {
				log.append(ComLogUtil.getLogTxt("价格规则", "恒定加价", null));
				log.append(ComLogUtil.getLogTxt("基于结算价恒定加价",
						"加价：" + String.valueOf(packDetail.getPrice() / 100)
								+ " 元", null));
			}else if ("FIXED_PERCENT".equalsIgnoreCase(priceType)) {
				log.append(ComLogUtil.getLogTxt("价格规则", "基于结算价恒定,按比例加价", null));
				log.append(ComLogUtil.getLogTxt("基于结算价恒定,按比例加价",
						"结算价的：" + String.valueOf(Float.parseFloat(packDetail.getPrice()+"") / 100)
								+ "%", null));
			}else {
				log.append(ComLogUtil.getLogTxt("价格规则", "商品利润", null));
				log.append(ComLogUtil.getLogTxt("基于商品利润设置",
						"利润的：" + String.valueOf(packDetail.getPrice() / 100)
								+ "%", null));
			}
		} else {
			if (!priceType.equalsIgnoreCase(oldPriceType)) {
				if ("FIXED_PRICE".equalsIgnoreCase(priceType) && "MAKEUP_PRICE".equalsIgnoreCase(oldPriceType)) {
					log.append(ComLogUtil.getLogTxt("价格规则", "恒定加价", "百分比加价"));
					log.append(ComLogUtil.getLogTxt(
							"基于结算价恒定加价",
							"加价：" + String.valueOf(packDetail.getPrice() / 100)
									+ " 元",
							"利润："
									+ String.valueOf(oldPackDetail.getPrice() / 100)
									+ "%"));
				}else if ("FIXED_PRICE".equalsIgnoreCase(priceType) && "FIXED_PERCENT".equalsIgnoreCase(oldPriceType)) {
					log.append(ComLogUtil.getLogTxt("价格规则", "恒定加价", "基于结算价恒定,按比例加价"));
					log.append(ComLogUtil.getLogTxt(
							"基于结算价恒定加价",
							"加价：" + String.valueOf(packDetail.getPrice() / 100)
									+ " 元",
							"基于结算价恒定,按比例加价："
									+ String.valueOf(Float.parseFloat(oldPackDetail.getPrice()+"") / 100)
									+ "%"));
				}else if ("FIXED_PERCENT".equalsIgnoreCase(priceType) && "FIXED_PRICE".equalsIgnoreCase(oldPriceType)) {
					log.append(ComLogUtil.getLogTxt("价格规则", "基于结算价恒定,按比例加价", "恒定加价"));
					log.append(ComLogUtil.getLogTxt(
							"基于结算价恒定,按比例加价",
							"按比例加价：" + String.valueOf(Float.parseFloat(packDetail.getPrice()+"") / 100)
									+ "%",
							"加价："
									+ String.valueOf(oldPackDetail.getPrice() / 100))
							+ " 元");
				}else if ("FIXED_PERCENT".equalsIgnoreCase(priceType) && "MAKEUP_PRICE".equalsIgnoreCase(oldPriceType)) {
					log.append(ComLogUtil.getLogTxt("价格规则", "基于结算价恒定,按比例加价", "百分比加价"));
					log.append(ComLogUtil.getLogTxt(
							"基于结算价恒定，按比例加价",
							"按比例加价：" + String.valueOf(Float.parseFloat(packDetail.getPrice()+"") / 100)
							        + "%",
							"利润："
									+ String.valueOf(oldPackDetail.getPrice() / 100)
									+ "%"));
				}else if ("MAKEUP_PRICE".equalsIgnoreCase(priceType) && "FIXED_PERCENT".equalsIgnoreCase(oldPriceType)) {
					log.append(ComLogUtil.getLogTxt("价格规则", "百分比加价", "基于结算价恒定,按比例加价"));
					log.append(ComLogUtil.getLogTxt(
							"基于商品利润设置",
							"利润：" + String.valueOf(packDetail.getPrice() / 100)
									+ "%",
							"基于结算价恒定,按比例加价："
								    + String.valueOf(Float.parseFloat(oldPackDetail.getPrice()+"") / 100)
									+ "%"));
				} else {
					log.append(ComLogUtil.getLogTxt("价格规则", "百分比加价", "恒定加价"));
					log.append(ComLogUtil.getLogTxt(
							"基于商品利润设置",
							"利润：" + String.valueOf(packDetail.getPrice() / 100)
									+ "%",
							"加价："
									+ String.valueOf(oldPackDetail.getPrice() / 100))
							+ " 元");
				}
			} else {
				if ("FIXED_PRICE".equalsIgnoreCase(priceType)) {
					log.append(ComLogUtil.getLogTxt(
							"基于结算价恒定加价",
							"加价：" + String.valueOf(packDetail.getPrice() / 100)
									+ " 元",
							"加价："
									+ String.valueOf(oldPackDetail.getPrice() / 100))
							+ " 元");
				} else if ("MAKEUP_PRICE".equalsIgnoreCase(priceType)) {
					log.append(ComLogUtil.getLogTxt(
							"基于商品利润设置",
							"利润：" + String.valueOf(packDetail.getPrice() / 100)
									+ "%",
							"利润："
									+ String.valueOf(oldPackDetail.getPrice() / 100)
									+ "%"));
				}else if ("FIXED_PERCENT".equalsIgnoreCase(priceType)) {
					log.append(ComLogUtil.getLogTxt(
							"基于结算价恒定加价",
							"按比例加价：" + String.valueOf(Float.parseFloat(packDetail.getPrice()+"") / 100)
							        + "%",
							"按比例加价："
									+ String.valueOf(Float.parseFloat(oldPackDetail.getPrice()+"") / 100)
									+ "%"));
				}
			}
		}

		if (log.length() > 0) {
			Long productBranchId = oldPackDetail.getObjectId();
			ProdProductBranch productBranch = prodProductBranchAdapterService
					.findProdProductBranchById(productBranchId); 
			if (productBranch != null) {
				if (isAutopackage) {
					return ",打包产品Id: " + productBranch.getProductId()
							+ ",打包产品规格Id:" + productBranchId + "," + log.toString();
				}else {
					return "打包DetailId：" + oldPackDetail.getDetailId()
							+ ",打包产品Id: " + productBranch.getProductId()
							+ ",打包产品规格Id:" + productBranchId + "," + log.toString();
				}
			}
		}

		return "";

	}

	/**
	 * 取消打包
	 * @param model
	 * @param detailId
	 * @param productId
	 * @return
	 * @throws BusinessException
     */
	@RequestMapping(value = "/deletePackGroupDetail")
	@ResponseBody
	public Object deletePackGroupDetail(Model model, Long detailId, Long productId) throws BusinessException {

		StringBuffer logContent = new StringBuffer();
		if (detailId != null) {

			ProdPackageDetail packDetail = prodPackageDetailService
					.selectByPrimaryKey(detailId);
			Long productBranchId = packDetail.getObjectId();
			ProdProductBranch productBranch = prodProductBranchAdapterService
					.findProdProductBranchById(productBranchId);
			
			if (productBranch == null || productBranch.getProductId() == null) {
				throw new BusinessException("系统内部异常，没有查询到规格信息！");
			}
			
			ProdProduct prodProduct = prodProductHotelAdapterService
					.findProdProductById(productBranch.getProductId());
			logContent.append(",产品类型id:")
					.append(prodProduct.getBizCategoryId()).append(",产品id:")
					.append(prodProduct.getProductId());
			logContent.append(",产品名称：").append(prodProduct.getProductName())
					.append(",规格id:").append(productBranchId).append(",规格：")
					.append(productBranch.getBranchName());

			prodLineGroupPackService.deletePackGroupDetail(detailId);

			//取消打包,给供应商发消息
			Map<String,Object> params = new HashMap<String, Object>();
			params.put("groupId",packDetail.getGroupId());
			List<ProdPackageGroup> prodPackageGroups = prodLineGroupPackService.findProdLinePackGroupByParams(params);
			ProdProduct product = this.prodProductService.findProdProductById(productId, null);
			if(CollectionUtils.isNotEmpty(prodPackageGroups)){
				ProdPackageGroup prodPackageGroup = prodPackageGroups.get(0);
				this.handOut4Detail(product.getBizCategoryId(),productId,
						String.valueOf(packDetail.getGroupId()),String.valueOf(packDetail.getObjectId()),
						prodPackageGroup.getGroupType(),ComPush.OPERATE_TYPE.DEL.name());
			}

			//取消打包是  删除该产品下面打包的商品
			if(detailId!=null && detailId.longValue() > 0)
			{
				Map<String, Object> packagedDetailParams = new HashMap<String, Object>();
				packagedDetailParams.put("detailId",detailId);
				//删除已经打包的商品
				prodPackageDetailGoodsService.deleteGoodsByParams(packagedDetailParams);
			}

			ProdProduct routeProduct = prodProductHotelAdapterService
					.findProdProductById(productId);
			if ("Y".equalsIgnoreCase(routeProduct.getMuiltDpartureFlag())) {
				pushAdapterService.push(productId, ComPush.OBJECT_TYPE.PRODUCT,
						ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP,
						ComPush.OPERATE_TYPE.UP,
						ComIncreament.DATA_SOURCE_TYPE.TRANS_API_JOB);
			} else {
				pushAdapterService.push(productId, ComPush.OBJECT_TYPE.PRODUCT,
						ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP,
						ComPush.OPERATE_TYPE.UP,
						ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
			}
			//删除该打包产品关联属性
			if(!prodProduct.getBizCategoryId().equals(17L)){
				this.deleteAssociatedDetail(productId, prodProduct.getProductId());
			}
             
		} else {
			throw new BusinessException("参数传递错误");
		}

		// 添加操作日志
		try {
			comLogService.insert(
					COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP, productId,
					productId, this.getLoginUser().getUserName(), "取消打包：id:"
							+ detailId + logContent,
					COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP.name(),
					"取消打包", null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"
					+ COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
			log.error(e.getMessage());
		}

		return new ResultMessage("success", "删除成功");
	}

	// 删除单个日期的分段加价
	@RequestMapping(value = "/deletePackGroupDetailAddPrice")
	@ResponseBody
	public Object deletePackGroupDetailAddPrice(Model model, Long detailId,
			Date specDate, Long productId, String groupType) throws BusinessException {

		StringBuffer logContent = new StringBuffer();
		if (detailId != null && specDate != null) {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("detailId", detailId);
			params.put("specDate", specDate);
			List<ProdPackageDetailAddPrice> detailAddPriceList = MiscUtils.autoUnboxing(prodPackageDetailAddPriceService
					.findProdPackageDetailAddPriceList(params));
			ProdPackageDetailAddPrice detailAddPrice = null;
			if (CollectionUtils.isNotEmpty(detailAddPriceList)) {
				detailAddPrice = detailAddPriceList.get(0);
			}
			Long productBranchId = null;
			if (detailAddPrice != null) {
				productBranchId = detailAddPrice.getObjectId();
			}
			if(productBranchId != null) {
				ProdProductBranch productBranch = prodProductBranchAdapterService.findProdProductBranchById(productBranchId);
				ProdProduct prodProduct = prodProductAdapterService.findProdProductById(productBranch.getProductId());
				logContent.append(", 产品类型id:").append(prodProduct.getBizCategoryId()).append(", 产品id:")
						.append(prodProduct.getProductId());
				logContent.append(", 产品名称：").append(prodProduct.getProductName()).append(", 规格id:").append(productBranchId)
						.append(", 规格：").append(productBranch.getBranchName());
	
				prodPackageDetailAddPriceService.deleteAddPriceByDetailIdAndSpecDate(detailId, specDate);
				
				ProdProduct routeProduct = prodProductService.getProdProductBy(productId);
				if("Y".equalsIgnoreCase(routeProduct.getMuiltDpartureFlag())){
					pushAdapterService.push(productId, ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP,
							ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.TRANS_API_JOB);
				}else{
					pushAdapterService.push(productId, ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP,
							ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
				}
				String dateStr = DateUtil.formatDate(specDate, "yyyyMMdd");
				String relateInfo = String.valueOf(productBranchId)+"|"+dateStr;
				this.handOut4SpecialPrice(routeProduct.getBizCategoryId(),productId,String.valueOf(detailAddPrice.getGroupId()),relateInfo, groupType);
			}
		} else {
			throw new BusinessException("参数传递错误");
		}

		// 添加操作日志
		try {
			comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP, productId, productId, this.getLoginUserId(), "删除特殊价格规则: 打包DetailId:" + detailId + ", 加价日期:" + DateUtil.formatDate(specDate, "yyyy-MM-dd") + logContent,
					COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP.name(), "删除特殊价格规则", null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"
					+ COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
			log.error(e.getMessage());
		}
		return new ResultMessage("success", "删除成功");
	}

	/**
	 * 删除组
	 * 
	 * @param model
	 * @param groupId
	 * @param groupType
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/deletePackGroup")
	@ResponseBody
	public Object deletePackGroup(Model model, Long groupId, String groupType,
			Long productId) throws BusinessException {
		this.doDeletePackGroup(groupId, groupType, productId);
		ProdProduct routeProduct = prodProductService.getProdProductBy(productId);
		if(routeProduct != null && "HOTEL".equals(groupType)){
			Long bizCategoryId = routeProduct.getBizCategoryId();
			Long subCategoryId = routeProduct.getSubCategoryId();
			if(bizCategoryId != null && (bizCategoryId == 15L || (bizCategoryId == 18L && subCategoryId != 181L))){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("groupId", groupId);
				prodPackageDetailAddPriceService.deleteHotelGroupDetailAddPrice(params);
			}
		}
		if ("Y".equalsIgnoreCase(routeProduct.getMuiltDpartureFlag())) {
			pushAdapterService.push(productId,
					ComPush.OBJECT_TYPE.PRODUCT,
					ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP,
					ComPush.OPERATE_TYPE.UP,
					ComIncreament.DATA_SOURCE_TYPE.TRANS_API_JOB);
		} else {
			pushAdapterService.push(productId,
					ComPush.OBJECT_TYPE.PRODUCT,
					ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP,
					ComPush.OPERATE_TYPE.UP,
					ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
		}
		
		// 添加操作日志0
		try {
			String msg =  "删除组：id:" + groupId;
			comLogService.insert(
					COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP, productId,
					productId, this.getLoginUser().getUserName(),msg ,
					COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP.name(),
					"删除组", null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"
					+ COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
			log.error(e.getMessage());
		}
		return new ResultMessage("success", "删除成功");
	}
	
	private void doDeletePackGroup(Long groupId, String groupType, Long productId){

		if (groupId != null && groupId.longValue() > 0
				&& StringUtil.isNotEmptyString(groupType)) {
			ProdPackageGroup oldProdPackageGroup = prodPackageGroupService
					.findProdPackageGroupByKey(groupId);
			if (oldProdPackageGroup != null) {
				//删除该组下打包产品关联属性
				if(!oldProdPackageGroup.getCategoryId().equals(17L)){
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("groupId",groupId);
					List<ProdPackageDetail> prodPackageDetails = prodPackageDetailService.findProdPackageDetailList(params);
					if(prodPackageDetails != null && prodPackageDetails.size() > 0){
						for(ProdPackageDetail prodPackageDetail : prodPackageDetails){
							Long productBranchId = prodPackageDetail.getObjectId();
							ProdProductBranch productBranch = prodProductBranchAdapterService.findProdProductBranchById(productBranchId);
							if (productBranch!=null && productBranch.getProductId()!=null) {
								this.deleteAssociatedDetail(productId, productBranch.getProductId());
							}
						}
					}
				}
				prodLineGroupPackService.deleteProdLinePackGroup(groupId,
						groupType);
				
				if(groupId!=null && groupId.longValue() > 0)
				{
					Map<String, Object> packagedGroupParams = new HashMap<String, Object>();
					packagedGroupParams.put("groupId",groupId);
					//删除已经打包的商品
					prodPackageDetailGoodsService.deleteGoodsByParams(packagedGroupParams);
				}
				//删除打包组，向分销商发消息
				ProdProduct prodProduct = this.prodProductService.findProdProductById(productId,null);
				this.handOut4Group(prodProduct.getBizCategoryId(),productId,
						String.valueOf(groupId),groupType,ComPush.OPERATE_TYPE.DEL.name());

				ProdProduct routeProduct = prodProductService
						.getProdProductBy(productId);
				if ("Y".equalsIgnoreCase(routeProduct.getMuiltDpartureFlag())) {
					pushAdapterService.push(productId,
							ComPush.OBJECT_TYPE.PRODUCT,
							ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP,
							ComPush.OPERATE_TYPE.UP,
							ComIncreament.DATA_SOURCE_TYPE.TRANS_API_JOB);
				} else {
					pushAdapterService.push(productId,
							ComPush.OBJECT_TYPE.PRODUCT,
							ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP,
							ComPush.OPERATE_TYPE.UP,
							ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
				}
			}
			
		} else {
			throw new BusinessException("参数传递错误");
		}
	}

	@RequestMapping(value = "/showChangeHotelList")
	public String showChangeHotelList(Model model, Long productId,
			String categoryName, Long categoryId, Long mainProdBranchId,
			String branchCode) throws BusinessException {
		ProdProduct prodProduct = null;
		List<ProdPackageGroup> packGroupList = null;
		ProdProductParam param = new ProdProductParam();
		param.setBizCategory(true);
		param.setProdLineRoute(true);

		prodProduct = prodProductService.findProdProductById(productId, param);

		Map<String, Object> packGroupParams = new HashMap<String, Object>();
		packGroupParams.put("productId", productId);
		packGroupParams.put("groupType",
				ProdPackageGroup.GROUPTYPE.CHANGE.name());

		packGroupList = prodLineGroupPackService
				.findProdLinePackGroupByParams(packGroupParams);

		List<SuppGoodsChangeHotelVO> unPackList = prodLineGroupPackService
				.findSuppGoodsListByChangedHotel(productId, null, categoryId);
		if (CollectionUtils.isNotEmpty(packGroupList)) {
			model.addAttribute("groupId", packGroupList.get(0).getGroupId());
		}
		model.addAttribute("packGroupList", packGroupList);
		model.addAttribute("unPackList", unPackList);

		model.addAttribute("categoryName", prodProduct.getBizCategory()
				.getCategoryName());
		model.addAttribute("prodProduct", prodProduct);
		model.addAttribute("productId", productId);
		model.addAttribute("categoryId", categoryId);
		model.addAttribute("mainProdBranchId", mainProdBranchId);

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("categoryId", categoryId);
		parameters.put("branchCode", branchCode);
		List<BizBranch> branchList = MiscUtils.autoUnboxing(branchService
				.findBranchListByParams(parameters));

		if (branchList != null && branchList.size() > 0) {
			model.addAttribute("branchId", branchList.get(0).getBranchId());
		}
		// 获取最大晚数行程
		ProdLineRoute maxProdLineRoute = new ProdLineRoute();
		List<ProdLineRoute> maxList = prodLineRouteService
				.findRouteMaxStayNum(packGroupParams);
		if (maxList != null && maxList.size() > 0) {
			maxProdLineRoute = maxList.get(0);
		}
		model.addAttribute("maxProdLineRoute", maxProdLineRoute);
		return "/goods/tour/goods/showPackList";
	}

	@RequestMapping(value = "/showSelectChangedHotelProductList")
	public Object showSelectChangedHotelProductList(Model model, Long groupId,
			String groupType, Long productId, Long selectCategoryId,
			HttpServletRequest req) throws BusinessException {
		if (groupId != null && productId != null && selectCategoryId != null) {
			List<SuppGoodsChangeHotelVO> list = prodLineGroupPackService
					.findSuppGoodsListByChangedHotel(productId, groupId,
							selectCategoryId);

			model.addAttribute("changeHotelList", list);
			model.addAttribute("selectCategoryId", selectCategoryId);
			model.addAttribute("groupId", groupId);
			model.addAttribute("groupType", groupType);

			return "/goods/tour/goods/showSelectProductList";
		} else {
			throw new BusinessException("参数groupType:[" + groupType + "]传递错误");
		}

	}
	/**
	 * 新增打包组，发消息给分销商
	 * @param categoryId 品类Id
	 * @param productId 产品Id
	 * @param groupId 打包组Id
	 * @param groupType 组类型
	 * @param operateType 操作类型
	 */
	private final void handOut4Group(Long categoryId,Long productId,String groupId, String groupType,String operateType){
		if(BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCategoryId().equals(categoryId)||BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCategoryId().equals(categoryId)){
			if(ProdPackageGroup.GROUPTYPE.HOTEL.name().equalsIgnoreCase(groupType)){
				String msg = MsgFactory.get().
						create4PackGroup(productId,
								categoryId,
								ComPush.OBJECT_TYPE.PRODUCT.name(),
								ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP.name(),
								groupId,
								null,
								ComPush.PUSH_DETAIL.GROUP_HOTEL.name(),
								operateType);
				this.prodEsQueueService.handOutProdocut(msg);
			}else if(ProdPackageGroup.GROUPTYPE.TRANSPORT.name().equalsIgnoreCase(groupType)){
				String msg = MsgFactory.get().
						create4PackGroup(productId,
								categoryId,
								ComPush.OBJECT_TYPE.PRODUCT.name(),
								ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP.name(),
								groupId,
								null,
								ComPush.PUSH_DETAIL.GROUP_TRAFFIC.name(),
								operateType);
				this.prodEsQueueService.handOutProdocut(msg);
			}else if(ProdPackageGroup.GROUPTYPE.LINE.name().equalsIgnoreCase(groupType)){
				String msg = MsgFactory.get().
						create4PackGroup(productId,
								categoryId,
								ComPush.OBJECT_TYPE.PRODUCT.name(),
								ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP.name(),
								groupId,
								null,
								ComPush.PUSH_DETAIL.GROUP_ROUTE.name(),
								operateType);
				this.prodEsQueueService.handOutProdocut(msg);
			} else if(ProdPackageGroup.GROUPTYPE.LINE_TICKET.name().equalsIgnoreCase(groupType)){
				String msg = MsgFactory.get().
						create4PackGroup(productId,
								categoryId,
								ComPush.OBJECT_TYPE.PRODUCT.name(),
								ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP.name(),
								groupId,
								null,
								ComPush.PUSH_DETAIL.GROUP_TICKET.name(),
								operateType);
				this.prodEsQueueService.handOutProdocut(msg);
			}
		}else{
			log.info(" the categoryId is " + categoryId);
			return;
		}
		
	}

	/**
	 * 新增取消打包，发消息给分销商
	 * @param categoryId 品类Id
	 * @param productId 产品Id
	 * @param groupId 打包项Id
	 * @param groupType 组类型
	 */
	private final void handOut4Detail(Long categoryId,Long productId,String groupId,String branchId,
									  String groupType,String operateType){
		if(BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCategoryId().equals(categoryId)||BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCategoryId().equals(categoryId)){
			if(ProdPackageGroup.GROUPTYPE.HOTEL.name().equalsIgnoreCase(groupType)){
				String msg = MsgFactory.get().
						create4PackGroup(productId,
								categoryId,
								ComPush.OBJECT_TYPE.PRODUCT.name(),
								ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP.name(),
								groupId,
								branchId,
								ComPush.PUSH_DETAIL.GROUP_BRANCH_HOTEL.name(),
								operateType);
				this.prodEsQueueService.handOutProdocut(msg);
			}else if(ProdPackageGroup.GROUPTYPE.TRANSPORT.name().equalsIgnoreCase(groupType)){
				String msg = MsgFactory.get().
						create4PackGroup(productId,
								categoryId,
								ComPush.OBJECT_TYPE.PRODUCT.name(),
								ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP.name(),
								groupId,
								branchId,
								ComPush.PUSH_DETAIL.GROUP_BRANCH_TRAFFIC.name(),
								operateType);
				this.prodEsQueueService.handOutProdocut(msg);
			}else if(ProdPackageGroup.GROUPTYPE.LINE.name().equalsIgnoreCase(groupType)){
				String msg = MsgFactory.get().
						create4PackGroup(productId,
								categoryId,
								ComPush.OBJECT_TYPE.PRODUCT.name(),
								ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP.name(),
								groupId,
								branchId,
								ComPush.PUSH_DETAIL.GROUP_BRANCH_ROUTE.name(),
								operateType);
				this.prodEsQueueService.handOutProdocut(msg);
			}else if (ProdPackageGroup.GROUPTYPE.LINE_TICKET.name().equalsIgnoreCase(groupType)) {
				String msg = MsgFactory.get().
						create4PackGroup(productId,
								categoryId, 
								ComPush.OBJECT_TYPE.PRODUCT.name(), 
								ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP.name(), 
								groupId, 
								branchId, 
								ComPush.PUSH_DETAIL.GROUP_BRANCH_TICKET.name(), 
								operateType);
				this.prodEsQueueService.handOutProdocut(msg);
			}
		}else{
			log.info(" the categoryId is " + categoryId);
			return;
		}
		
	}

	/**
	 * 更改打包组中 的 加价规则，发消息给分销商
	 * @param categoryId 品类Id
	 * @param productId 产品Id
	 * @param groupId 打包组Id
	 * @param groupType 组类型
	 */
	private final void handOut4Price(Long categoryId,Long productId,String groupId,String branchId, String groupType){
		if(BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCategoryId().equals(categoryId)||BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCategoryId().equals(categoryId)){
			if(ProdPackageGroup.GROUPTYPE.HOTEL.name().equalsIgnoreCase(groupType)){
				String msg = MsgFactory.get().
						create4PackGroup(productId,
								categoryId,
								ComPush.OBJECT_TYPE.PRODUCT.name(),
								ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP.name(),
								groupId,
								branchId,
								ComPush.PUSH_DETAIL.GROUP_BRANCH_PRICE_HOTEL.name(),
								ComPush.OPERATE_TYPE.UP.name());
				this.prodEsQueueService.handOutProdocut(msg);
			}else if(ProdPackageGroup.GROUPTYPE.TRANSPORT.name().equalsIgnoreCase(groupType)){
				String msg = MsgFactory.get().
						create4PackGroup(productId,
								categoryId,
								ComPush.OBJECT_TYPE.PRODUCT.name(),
								ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP.name(),
								groupId,
								branchId,
								ComPush.PUSH_DETAIL.GROUP_BRANCH_PRICE_TRAFFIC.name(),
								ComPush.OPERATE_TYPE.UP.name());
				this.prodEsQueueService.handOutProdocut(msg);
			}else if(ProdPackageGroup.GROUPTYPE.LINE.name().equalsIgnoreCase(groupType)){
				String msg = MsgFactory.get().
						create4PackGroup(productId,
								categoryId,
								ComPush.OBJECT_TYPE.PRODUCT.name(),
								ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP.name(),
								groupId,
								branchId,
								ComPush.PUSH_DETAIL.GROUP_BRANCH_PRICE_ROUTE.name(),
								ComPush.OPERATE_TYPE.UP.name());
				this.prodEsQueueService.handOutProdocut(msg);
			}else if (ProdPackageGroup.GROUPTYPE.LINE_TICKET.name().equalsIgnoreCase(groupType)) {
				String msg = MsgFactory.get().
						create4PackGroup(productId,
								categoryId,
								ComPush.OBJECT_TYPE.PRODUCT.name(),
								ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP.name(),
								groupId,
								branchId,
								ComPush.PUSH_DETAIL.GROUP_BRANCH_PRICE_TICKET.name(),
								ComPush.OPERATE_TYPE.UP.name());
				this.prodEsQueueService.handOutProdocut(msg);
			}
		}else{
			log.info(" the categoryId is " + categoryId);
			return;
		}
		
	}


	/**
	 * 更改打包组中 的 特殊加价规则，发消息给分销商
	 * @param categoryId 品类Id
	 * @param productId 产品Id
	 * @param groupId 打包组Id
	 */
	private final void handOut4SpecialPrice(Long categoryId,Long productId,String groupId,String branchId,String groupType){
		/*if(!BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCategoryId().equals(categoryId)){
			log.info(" the categoryId is " + categoryId);
			return;
		}*/
		
		log.info("handOut4SpecialPrice productId:" + productId + ", groupId:" + groupId + ", branchId:" + branchId + ",groupType:" + groupType);
		
		if(ProdPackageGroup.GROUPTYPE.HOTEL.name().equalsIgnoreCase(groupType)){
			String msg = MsgFactory.get().
					create4PackGroup(productId,
							categoryId,
							ComPush.OBJECT_TYPE.PRODUCT.name(),
							ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP.name(),
							groupId,
							branchId,
							ComPush.PUSH_DETAIL.GROUP_BRANCH_SPECIAL_PRICE_HOTEL.name(),
							ComPush.OPERATE_TYPE.UP.name());
			this.prodEsQueueService.handOutProdocut(msg);
		}else if(ProdPackageGroup.GROUPTYPE.TRANSPORT.name().equalsIgnoreCase(groupType)){
			String msg = MsgFactory.get().
					create4PackGroup(productId,
							categoryId,
							ComPush.OBJECT_TYPE.PRODUCT.name(),
							ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP.name(),
							groupId,
							branchId,
							ComPush.PUSH_DETAIL.GROUP_BRANCH_SPECIAL_PRICE_TRAFFIC.name(),
							ComPush.OPERATE_TYPE.UP.name());
			this.prodEsQueueService.handOutProdocut(msg);
		}else if(ProdPackageGroup.GROUPTYPE.LINE.name().equalsIgnoreCase(groupType)){
			String msg = MsgFactory.get().
					create4PackGroup(productId,
							categoryId,
							ComPush.OBJECT_TYPE.PRODUCT.name(),
							ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP.name(),
							groupId,
							branchId,
							ComPush.PUSH_DETAIL.GROUP_BRANCH_SPECIAL_PRICE_ROUTE.name(),
							ComPush.OPERATE_TYPE.UP.name());
			this.prodEsQueueService.handOutProdocut(msg);
		}else if(ProdPackageGroup.GROUPTYPE.LINE_TICKET.name().equalsIgnoreCase(groupType)){
			String msg = MsgFactory.get().
					create4PackGroup(productId,
							categoryId,
							ComPush.OBJECT_TYPE.PRODUCT.name(),
							ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP.name(),
							groupId,
							branchId,
							ComPush.PUSH_DETAIL.GROUP_BRANCH_SPECIAL_PRICE_TICKET.name(),
							ComPush.OPERATE_TYPE.UP.name());
			this.prodEsQueueService.handOutProdocut(msg);
		}
	}
	
	/**
	 * 判断产品下有有效预售券ajax请求
	 * @param model
	 * @param productId
	 * @return
	 */
	@RequestMapping("/isBoundStamp")
	@ResponseBody
    public Object isBoundStamp(Model model,Long productId){	
    		ResultMessage msg = ResultMessage.createResultMessage();
    		boolean boundStampFalg=true;
    		try {
    			String url =Constant.getInstance().getPreSaleBaseUrl() + "/customer/product/canModify?productId="+productId;
    			log.info("isBoundStamp,判断产品下有有效预售券url:"+url);
 			   // boundStampFalg =RestClient.getClient().getForObject(url,Boolean.class);
 			   // log.info("isBoundStamp,判断产品下有有效预售券结果:"+boundStampFalg);
    			msg.addObject("boundStampFalg", boundStampFalg);
    		 }catch (Exception e) {
    			log.error(ExceptionFormatUtil.getTrace(e));
    			msg.raise("判断该产品下有有效预售券异常！");
    		 }
    		 msg.setCode(ResultMessage.SUCCESS);
    	return msg;
    }
	
	/**
	 * 设置关联属性
	 * @param model
	 * @param packDetail
	 * @param associatedRouteProdId 行程明细
	 * @param associatedFeeIncludeProdId 费用说明
	 * @param associatedContractProdId 合同条款
	 * @param feeIncludeExtra 费用补充说明
	 * @param productId
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/updateAssociatedDetail")
	@ResponseBody
	public Object updateAssociatedDetail(Model model, ProdPackageDetail packDetail,Long associatedRouteProdId,Long associatedFeeIncludeProdId,Long associatedContractProdId,String feeIncludeExtra,Long productId) throws BusinessException {
		ProdProductAssociation prodProductAssociation = prodProductAssociationService.getProdProductAssociationByProductId(productId);
		String logs = null;
		if(prodProductAssociation != null){
			prodProductAssociation.setAssociatedRouteProdId(associatedRouteProdId);
			prodProductAssociation.setAssociatedFeeIncludeProdId(associatedFeeIncludeProdId);
			prodProductAssociation.setAssociatedContractProdId(associatedContractProdId);
			prodProductAssociation.setFeeIncludeExtra(feeIncludeExtra);
			prodProductAssociationService.updateProdProductAssociation(prodProductAssociation);
		}else{
			ProdProductAssociation prodProductAssociation2 = new ProdProductAssociation();
			prodProductAssociation2.setProductId(productId);
			prodProductAssociation2.setAssociatedRouteProdId(associatedRouteProdId);
			prodProductAssociation2.setAssociatedFeeIncludeProdId(associatedFeeIncludeProdId);
			prodProductAssociation2.setAssociatedContractProdId(associatedContractProdId);
			prodProductAssociation2.setFeeIncludeExtra(feeIncludeExtra);
			prodProductAssociationService.insertProdProductAssociation(prodProductAssociation2);
		}
		//添加操作日志
		logs = "【行程明细】关联的产品id：" + associatedRouteProdId + ";"
	              + "【费用说明】关联的产品id：" + associatedFeeIncludeProdId + ";"
	              +"【费用补充说明】：" + feeIncludeExtra + ";"
			      + "【合同条款】关联的产品id：" + associatedContractProdId;
		comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP,productId,productId,this.getLoginUserId(),"设置关联:" + logs,COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP.name(), "设置关联", null);
		//TODO
		return updateGroupDetail(model, packDetail, productId,null);
	}
	
	/**
	 * 取消打包时清除相应关联项
	 * @param productId
	 * @param associatedProdId
	 */
	private void deleteAssociatedDetail(Long productId,Long associatedProdId){
		if(productId != null && associatedProdId != null){
			ProdProductAssociation prodProductAssociation = prodProductAssociationService.getProdProductAssociationByProductId(productId);
			if(prodProductAssociation != null){
				if(prodProductAssociation.getAssociatedRouteProdId() != null && prodProductAssociation.getAssociatedRouteProdId().equals(associatedProdId)){
					prodProductAssociation.setAssociatedRouteProdId(null);
				}
				if(prodProductAssociation.getAssociatedFeeIncludeProdId() != null && prodProductAssociation.getAssociatedFeeIncludeProdId().equals(associatedProdId)){
					prodProductAssociation.setAssociatedFeeIncludeProdId(null);
					prodProductAssociation.setFeeIncludeExtra(null);
				}
				if(prodProductAssociation.getAssociatedContractProdId() != null && prodProductAssociation.getAssociatedContractProdId().equals(associatedProdId)){
					prodProductAssociation.setAssociatedContractProdId(null);
				}
				prodProductAssociationService.updateProdProductAssociation(prodProductAssociation);
			}
		}
	}
	/*
	 * 1.判断产品售卖方式是否是按人卖，并且是否设置为儿童固定价格
	 * 2.判断产品是否勾选 驴色飞扬自驾
	 */
	private boolean isLvseAndChildPriceType(Long productId){
		boolean flag=false;
		ProdProduct product=prodProductService.findProdProductSaleTypeByProductId(productId);
		if(product==null){
			return false;
		}
		List<ProdProductSaleRe>  prodProductSaleReList=product.getProdProductSaleReList();
		if(prodProductSaleReList==null || prodProductSaleReList.size()==0){
			return false;
		}
		//产品售卖类型为：按人卖    &&  儿童价为固定价
		if("PEOPLE".equals(prodProductSaleReList.get(0).getSaleType())&& "AMOUNT".equals(prodProductSaleReList.get(0).getChildPriceType())){
			flag=true;
		}
		List<ProdProductProp> propproductprop=product.getProdProductPropList();
		if(propproductprop!=null && propproductprop.size()>0){
			for (int i = 0; i < propproductprop.size(); i++) {
				String propValue=propproductprop.get(i).getPropValue();
				BizCategoryProp  bizCategoryProp =propproductprop.get(i).getBizCategoryProp();
				if(bizCategoryProp!=null){
					List<BizDict> bizDictList=bizCategoryProp.getBizDictList();
					if(bizDictList!=null && bizDictList.size()>0){
						for (int j = 0; j < bizDictList.size(); j++) {
							Long dictId=bizDictList.get(j).getDictId();
							if(propValue!=null && propValue.contains(String.valueOf(dictId))  && "驴色飞扬自驾".equals(bizDictList.get(j).getDictName())){
								//产品售卖类型为：按人卖    &&  儿童价为固定价    并且勾选了  驴色飞扬自驾 
								if(flag){
									return true;
								}
							}
						}
					}
				}
			}
		}
		return false;
	}
	
	
	
	
	/**
	 * 更改打包组中 的 特殊加价规则（跟团游,自由行(非景酒)打包酒店，到商品），发消息给分销商
	 * @param categoryId 品类Id
	 * @param productId 产品Id
	 * @param groupId 打包组Id
	 * @param suppGoodsId 商品Id
	 */
	private final void handOut4SpecialPriceSupp(Long categoryId,Long productId,String groupId,String suppGoodsId,String groupType,String operateType ){
		if(BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCategoryId().equals(categoryId)||BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCategoryId().equals(categoryId)){
			if(ProdPackageGroup.GROUPTYPE.HOTEL.name().equalsIgnoreCase(groupType)){
				String msg = MsgFactory.get().
						create4PackGroup(productId,
								categoryId,
								ComPush.OBJECT_TYPE.PRODUCT.name(),
								ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP.name(),
								groupId,
								suppGoodsId,
								ComPush.PUSH_DETAIL.GROUP_SUPPGOODS_SPECIAL_PRICE_HOTEL.name(),
								operateType);
				this.prodEsQueueService.handOutProdocut(msg);
			} 
		}else{
			log.info(" the categoryId is " + categoryId);
			return;
		}
	}
	
	private void calInset(ProdProduct prodProduct){
		ComCalData comCalData =new ComCalData();
		comCalData.setCategoryId(prodProduct.getBizCategoryId());
		comCalData.setProdPackageType(prodProduct.getPackageType());
		comCalData.setObjectId(prodProduct.getProductId());
		comCalData.setObjectType(ComPush.OBJECT_TYPE.PRODUCT.name());
		comCalData.setDataSouce(ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA.name());
		comCalData.setDataLevel(1);
		comCalData.setPushContent(ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP.name());
		comCalData.setPushCount(0);
		comCalData.setPushFlag("N");
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(new Date());
		calendar.add(Calendar.MINUTE, 0);
		comCalData.setCreateTime( calendar.getTime());
		try {
			comCalDataService.addComCalData(comCalData);
			log.info("COM_CAL_DATA 插入数据 productId="+prodProduct.getProductId());
		} catch (Exception e) {
			log.error("COM_CAL_DATA 插入失败",e);
		}
		
	}
}


