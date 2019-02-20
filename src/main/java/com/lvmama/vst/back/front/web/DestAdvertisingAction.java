package com.lvmama.vst.back.front.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tims.common.dto.PaginationDTO;
import com.tims.product.web.facade.VSTQueryProductInfoFacade;
import com.tims.product.web.facade.dto.product.VSTProductDTO;
import com.tims.product.web.facade.dto.product.VSTProductInfoConditionFacadeDTO;
import com.tims.product.web.facade.request.product.VSTProductInfoRequest;
import com.tims.product.web.facade.response.VSTProductResponse;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.comm.search.jms.SearchPhyDelMessageProducer;
import com.lvmama.comm.search.jms.SearchPushEnums;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.po.BizDest;
import com.lvmama.vst.back.biz.po.BizDistrict;
import com.lvmama.vst.back.biz.po.BizEnum;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.client.biz.service.DestClientService;
import com.lvmama.vst.back.client.biz.service.DistrictClientService;
import com.lvmama.vst.back.client.prod.service.ProdPackageDetailClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.front.po.BizProdAd;
import com.lvmama.vst.back.front.po.BizProdAdRank;
import com.lvmama.vst.back.front.po.BizProdProvince;
import com.lvmama.vst.back.front.service.BizProdAdService;
import com.lvmama.vst.back.front.service.BizProdRankAdService;
import com.lvmama.vst.back.front.vo.FrontDestRelatedVO;
import com.lvmama.dest.api.vst.prod.service.IHotelProductQrVstApiService;
import com.lvmama.dest.api.vst.prod.vo.HotelProductVstVo;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductBranch;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComLog;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.pub.service.PushAdapterServiceRemote;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comlog.LvmmLogClientService;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.utils.WineSplitConstants;
import com.lvmama.vst.comm.utils.bean.EnhanceBeanUtils;
import com.lvmama.vst.comm.utils.json.JSONOutput;
import com.lvmama.vst.comm.utils.json.JSONUtil;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.Constant.SEARCH_TYPE_TAG;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import scala.actors.threadpool.Arrays;

/**
 * 目的地广告位管理Action
 * 
 */

@Controller
@RequestMapping("/front/destAdvertising")
public class DestAdvertisingAction extends BaseActionSupport {
	/**
	 * 序列
	 */
	private static final long serialVersionUID = 6134572986468788818L;

	@Autowired
	private DestClientService destService;
	 
	@Autowired
	private ProdProductClientService prodProductService;
	
	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;
	@Autowired
	private ProdPackageDetailClientService prodPackageDetailService;
	
	@Autowired
	private BizProdAdService bizProdAdService;
	@Autowired
	private DistrictClientService districtService;
	@Autowired
	private PushAdapterServiceRemote pushAdapterService;

	@Autowired
	private BizProdRankAdService bizProdRankAdService;
	
	@Autowired
	private SearchPhyDelMessageProducer searchPhyDelMessageProducer;

	@Autowired
	private IHotelProductQrVstApiService iHotelProductQrVstApiServiceAgent;
	
	@Autowired
	private LvmmLogClientService lvmmLogClientService;

	@Autowired
	private VSTQueryProductInfoFacade vstQueryProductInfoFacade;
	
	/**
	 * 获得目的地列表
	 */
	@RequestMapping(value = "/findDestList")
	public String findDestList(Model model, Integer page,BizDest bizDest, HttpServletRequest req) throws BusinessException {
		
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("destId", bizDest.getDestId());
		parameters.put("destType", bizDest.getDestType());
		parameters.put("destName", bizDest.getDestName());
		if(null==bizDest.getCancelFlag()){
			parameters.put("cancelFlag", "all");
			model.addAttribute("cancelFlag", "all");
		}else{
			parameters.put("cancelFlag", bizDest.getCancelFlag());
			model.addAttribute("cancelFlag", bizDest.getCancelFlag());
		}		
		int count = MiscUtils.autoUnboxing( destService.findDestCount(parameters) );

		int pagenum = page == null ? 1 : page;
		Page<BizDest> pageParam = Page.page(count, 20, pagenum);
		pageParam.buildUrl(req);
		parameters.put("_start", pageParam.getStartRows());
		parameters.put("_end", pageParam.getEndRows());
		parameters.put("_orderby", "DEST_ID");
		parameters.put("_order", "ASC");
		List<BizDest> list = MiscUtils.autoUnboxing( destService.findDestList(parameters) );
		pageParam.setItems(list);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("destId", bizDest.getDestId());
		model.addAttribute("destName", bizDest.getDestName());
		model.addAttribute("destType", bizDest.getDestType());
		model.addAttribute("destTypeList", BizDest.DEST_TYPE.values());
		model.addAttribute("page", pageParam.getPage().toString());

		return "/front/destAdvertising/findDestList";
	}

	/**
	 * 跳转到修改页面
	 */
	@RequestMapping(value = "/destAdvertisingHeader")
	public String destAdvertisingHeader(Model model, Long destId, String showTab) throws BusinessException {
		
		BizDest bizDest = MiscUtils.autoUnboxing( destService.selectDestById(destId) );
		model.addAttribute("dest", bizDest);
		model.addAttribute("showTab", showTab);
		SEARCH_TYPE_TAG[] values = SEARCH_TYPE_TAG.values();
		model.addAttribute("oders", values);
		
		//加载自由行直系子品类
		List<BizCategory> bizFreedomList = bizCategoryQueryService.getBizCategorysByParentCategoryId(WineSplitConstants.ROUTE_FREEDOM);
		model.addAttribute(SEARCH_TYPE_TAG.FREETOUR.name(), bizFreedomList);
		return "/front/destAdvertising/destAdvertisingHeader";
	}
	
	/**
	 * 跳转到修改页面
	 */
	@RequestMapping(value = "/showEditDestAdvertising")
	public String showEditDestAdvertising(Model model, Long destId, String showTab,Long distrId, String subId) throws BusinessException {
		
		BizDest bizDest = MiscUtils.autoUnboxing( destService.selectDestById(destId) );
		model.addAttribute("dest", bizDest);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("destId", destId);
		params.put("distrId", distrId);
		params.put("_orderby", "SEQ");
		params.put("_order", "ASC");
		
		if("181".equals(subId)||"183".equals(subId)){
			model.addAttribute("cancelStickNumS",7);
		}else if("182".equals(subId)){
			model.addAttribute("cancelStickNumS",30);
		}
		
		if(StringUtils.isNotEmpty(showTab)){
			
			if(SEARCH_TYPE_TAG.FREETOUR.name().equalsIgnoreCase(showTab))
			{	
					params.put("type", SEARCH_TYPE_TAG.FREETOUR.name());
					if (StringUtils.isNotEmpty(subId) && !String.valueOf(SEARCH_TYPE_TAG.FREETOUR.getCode()).equals(subId)) {
						params.put("subCategoryId", subId);
						model.addAttribute("subId", subId);
					} else if (StringUtils.isNotEmpty(subId) && String.valueOf(SEARCH_TYPE_TAG.FREETOUR.getCode()).equals(subId)) {
						params.put("categoryId", subId);
						model.addAttribute("subId", subId);
					}
					String categoryids  = new String(SEARCH_TYPE_TAG.HOTELCOMB.getCode()+","+ SEARCH_TYPE_TAG.FREETOUR.getCode());
					model.addAttribute("categoryIds",categoryids);
					
			}else if(SEARCH_TYPE_TAG.YOULUN.name().equalsIgnoreCase(showTab)){
				params.put("type",showTab);
				model.addAttribute("parentCategoryId", SEARCH_TYPE_TAG.YOULUN.getCode());
				model.addAttribute("categoryIds", SEARCH_TYPE_TAG.YOULUN.getCode());
			}else if(SEARCH_TYPE_TAG.HOTEL.name().equalsIgnoreCase(showTab)){
				params.put("type",showTab);
				model.addAttribute("categoryIds", SEARCH_TYPE_TAG.HOTEL.getCode());
			}else if(SEARCH_TYPE_TAG.VISA.name().equalsIgnoreCase(showTab)){ //签证
				params.put("type",showTab);
				model.addAttribute("categoryIds", SEARCH_TYPE_TAG.VISA.getCode());
			}else if(SEARCH_TYPE_TAG.CONNECTS.name().equalsIgnoreCase(showTab)){ //交通接驳
				params.put("type",showTab);
				model.addAttribute("categoryIds", SEARCH_TYPE_TAG.CONNECTS.getCode());
			}else{
				
				String  categoryIds = "";
				int  parentCategoryId = SEARCH_TYPE_TAG.getCodebyName(showTab);
				if(Constant.SON_CATEGORY_ID.TICKET.name().equalsIgnoreCase(showTab)){
					 categoryIds = Constant.SON_CATEGORY_ID.TICKET.getCode();
				}else if(SEARCH_TYPE_TAG.ALL.name().equalsIgnoreCase(showTab)){
					 categoryIds = Constant.SON_CATEGORY_ID.ALL.getCode();

				}else{
					
					categoryIds = Constant.SON_CATEGORY_ID.ROUTE.getCode();
				}
				params.put("type",showTab);
				model.addAttribute("parentCategoryId", parentCategoryId);
				model.addAttribute("categoryIds",categoryIds);
			}
			
		}else{
			showTab = SEARCH_TYPE_TAG.ALL.name();
			params.put("type", SEARCH_TYPE_TAG.ALL.name());
			model.addAttribute("categoryIds", Constant.SON_CATEGORY_ID.ALL.getCode());

		}
		List<BizProdAd> bizProdAdList=null;
		//判断类别：旅游线路，跟团游，机+酒，周边跟团游
		String subCategoryId=(String)params.get("subCategoryId");
		if(isCategaryRoute((String)params.get("type"),subCategoryId==null?null:Long.parseLong(subCategoryId))){
			//查询出发地list
			params.put("destId", destId);
			List<BizDistrict> bizDistrictList=bizProdAdService.getDistrictTotalCount(params);
			params.put("_orderby", "bpa.SEQ");
			params.put("districtId", distrId);
			bizProdAdList=bizProdAdService.findBizProdAdListByRoute(params);
			//对于来自NS系统的产品品类做查询处理
			makeNsproductInfo(bizProdAdList);

			if(bizProdAdList!=null){
				for (BizProdAd bizProdAd : bizProdAdList) {
					if(BizProdAd.DISTRICT_TYPE.MUILT_DEPARTURE.name().equals(bizProdAd.getDistrictType())){
						params.put("districtType", bizProdAd.getDistrictType());
						List<BizDistrict> listBizDist=prodPackageDetailService.findDistrictList(bizProdAd.getProductId());
						if(distrId!=null&&listBizDist!=null&&listBizDist.size()>0){
							for (BizDistrict bizDistrict : listBizDist) {
								if(bizDistrict.getDistrictId().equals(distrId)){
									bizProdAd.getProdProduct().setBizDistrict(bizDistrict);
									bizProdAd.getProdProduct().setBizDistrictId(bizDistrict.getDistrictId());
									break;
								}
							}
						}else{
							if(listBizDist!=null&&listBizDist.size()>0){
								if(bizProdAd.getBizProdAdRanklist()!=null&&bizProdAd.getBizProdAdRanklist().size()>0){
									for(BizDistrict dis:listBizDist){
										if(dis.getDistrictId().equals(bizProdAd.getBizProdAdRanklist().get(0).getDistrictId())){
											bizProdAd.getProdProduct().setBizDistrict(dis);
											bizProdAd.getProdProduct().setBizDistrictId(dis.getDistrictId());
											break;
										}
									}
								}
							}
						}
					}else if(BizProdAd.DISTRICT_TYPE.NONE_DEPARTURE.name().equals(bizProdAd.getDistrictType())){
						//BizDistrict biz= MiscUtils.autoUnboxing(districtService.findDistrictById(distrId) );
//						bizProdAd.getProdProduct().setBizDistrict(biz);
//						list.add(bizProdAd);
						ProdProduct prodProduct = bizProdAd.getProdProduct();//空指针异常修复
						if(prodProduct !=null){
							bizProdAd.getProdProduct().setBizDistrictId(-1l);
						}
					}
				}
			}
			model.addAttribute("bizProdAdList", bizProdAdList);
			model.addAttribute("showTab", showTab);
			model.addAttribute("subId", subId);
			model.addAttribute("distrId", distrId);
			model.addAttribute("cateGroyType",params.get("type"));
			model.addAttribute("bizDistrictList", bizDistrictList);
			return "/front/destAdvertising/showEditDestAdvertising";
		}else{
			bizProdAdList = bizProdAdService.findBizProdAdList(params);
			//对于来自NS系统的产品品类做查询处理
			makeNsproductInfo(bizProdAdList);
		
		Map<Long,BizDistrict> map = new HashMap<Long, BizDistrict>();
		
		//全国出发设置出发地值
		if(bizProdAdList.size()>0){
			for(int i = 0; i < bizProdAdList.size(); i++){
				BizProdAd bd = bizProdAdList.get(i);
				if(bd.getProdProduct()!=null){
					if(bd.getProdProduct().getBizDistrictId()==null && !"Y".equals(bd.getProdProduct().getMuiltDpartureFlag())){
						bd.getProdProduct().setBizDistrictId(-1L); //如果选择为全国出发时,与下拉框值对应-1
					}else{
						if ("Y".equals(bd.getProdProduct().getMuiltDpartureFlag())) {
							bd.getProdProduct().setBizDistrictId(-2L); //如果选择为多出发地时,与下拉框值对应-2
						} else {
							map.put(bd.getProdProduct().getBizDistrictId(),bd.getProdProduct().getBizDistrict());
						}
					}
					if(null!=bd.getBizCategoryId() && BizEnum.BIZ_CATEGORY_TYPE.category_visa.getCategoryId().equals(bd.getBizCategoryId())){
						//规格列表
						List<ProdProductBranch> prodProductBranchList = bd.getProdProduct().getProdProductBranchList();
						if(null!=prodProductBranchList&&prodProductBranchList.size()>0){
							List<ProdProductBranch> prodBranchList = new ArrayList<ProdProductBranch>();
							for (int j = 0; j < prodProductBranchList.size(); j++) {
								if(prodProductBranchList.get(j).getProductBranchId().equals(bd.getProductBranchId())){
									prodBranchList.add(prodProductBranchList.get(j));
								}
							}
							bd.getProdProduct().setProdProductBranchList(prodBranchList);
						}
					}
					
				}
			}
		}
		List<BizDistrict> bizDistrictList = new ArrayList<BizDistrict>(map.values());	
		
		model.addAttribute("bizProdAdList", bizProdAdList);
		model.addAttribute("showTab", showTab);
		model.addAttribute("subId", subId);
		model.addAttribute("distrId", distrId);
		model.addAttribute("cateGroyType",params.get("type"));
		model.addAttribute("bizDistrictList", bizDistrictList);
		return "/front/destAdvertising/showEditDestAdvertising";
		
		}
		
}

	private void makeNsproductInfo(List<BizProdAd> bizProdAdList) {
		if (CollectionUtils.isEmpty(bizProdAdList)) {
			return;
		}
		for (BizProdAd bizProdAd : bizProdAdList) {
			if (15L == bizProdAd.getBizCategoryId() || 18L == bizProdAd.getBizCategoryId() || 16L == bizProdAd.getBizCategoryId()) {
				Long productId = bizProdAd.getProductId();
				if (productId != null) {
					//封装参数
					VSTProductInfoRequest request = new VSTProductInfoRequest();
					VSTProductInfoConditionFacadeDTO productFacadeDto = new VSTProductInfoConditionFacadeDTO();
					PaginationDTO paginationDTO = new PaginationDTO();
					request.setReqDtos(productFacadeDto);
					request.setPaginationDTO(paginationDTO);
					productFacadeDto.setId(productId.toString());
					if (15L == bizProdAd.getBizCategoryId()) { //跟团游
						productFacadeDto.setCategoryId("60");
					}else if(18L == bizProdAd.getBizCategoryId()){ //自由行
						productFacadeDto.setCategoryId("22");
					}else if(16L == bizProdAd.getBizCategoryId()){ //当地游
						productFacadeDto.setCategoryId("67");
					}
					int pagenum = 1;
					paginationDTO.setPageNumber(pagenum);
					paginationDTO.setPageSize(10);
					VSTProductResponse productResponse=new VSTProductResponse();
					//查询
					try {
						if("60".equals(productFacadeDto.getCategoryId())){
							productResponse= vstQueryProductInfoFacade.queryList(request);
							if(productResponse ==null || productResponse.getData() == null || productResponse.getPaginationDTO() == null){
								productFacadeDto.setCategoryId("66");
							}
							productResponse= vstQueryProductInfoFacade.queryList(request);
						}
						
						if("22".equals(productFacadeDto.getCategoryId())){
							productResponse= vstQueryProductInfoFacade.queryList(request);
							if(productResponse ==null || productResponse.getData() == null || productResponse.getPaginationDTO() == null){
								productFacadeDto.setCategoryId("65");
							}
							productResponse= vstQueryProductInfoFacade.queryList(request);
						}
						
						if("67".equals(productFacadeDto.getCategoryId())){
							productResponse= vstQueryProductInfoFacade.queryList(request);
							if(productResponse ==null || productResponse.getData() == null || productResponse.getPaginationDTO() == null){
								productFacadeDto.setCategoryId("16");
							}
							productResponse= vstQueryProductInfoFacade.queryList(request);
						}
						
						if (productResponse == null || productResponse.getData() == null || productResponse.getPaginationDTO() == null) {
							continue;
						}
						//封装结果集
						List<VSTProductDTO> vSTProductDTOList = productResponse.getData();
						VSTProductDTO vstProductDTO = vSTProductDTOList.get(0);
						ProdProduct prodProduct = new ProdProduct();
						BizCategory bizCategory = new BizCategory();
						prodProduct.setProductId(Long.valueOf(vstProductDTO.getId()));
						prodProduct.setProductName(vstProductDTO.getName());
						prodProduct.setSaleFlag(vstProductDTO.getCanSell());//是否可售
						prodProduct.setCancelFlag(vstProductDTO.getIsValid());//是否有效
						if (15L == bizProdAd.getBizCategoryId()) { //跟团游
							prodProduct.setBizCategoryId(15L);
							bizCategory.setCategoryId(15L);
							bizCategory.setCategoryName("NS跟团游");
						}else if(18L == bizProdAd.getBizCategoryId()){ //自由行
							prodProduct.setBizCategoryId(18L);
							bizCategory.setCategoryId(18L);
							bizCategory.setCategoryName("NS自由行");
						}else if(16L == bizProdAd.getBizCategoryId()){ //自由行
							prodProduct.setBizCategoryId(16L);
							bizCategory.setCategoryId(16L);
							bizCategory.setCategoryName("NS当地游");
						}
						prodProduct.setBizCategory(bizCategory);
						bizProdAd.setProdProduct(prodProduct);
					} catch (Exception e) {
						log.error("vstQueryProductInfoFacade queryList occurred error. "+e.getMessage());
						e.printStackTrace();
					}
				}
			}

		}
	}

	/**
	 * 判断类别：旅游线路，跟团游，机+酒，周边跟团游
	 * @param type
	 * @param categoryId
	 * @param subCategoryId
	 * @return
	 */
	private boolean isCategaryRoute(String type,Long subCategoryId){
		if(type.equals(SEARCH_TYPE_TAG.ROUTE.toString())
				||type.equals(SEARCH_TYPE_TAG.GROUP.toString())
				||(type.equals(SEARCH_TYPE_TAG.FREETOUR.toString())
						&&subCategoryId!=null&&
				(subCategoryId.equals(BizEnum.BIZ_CATEGORY_TYPE.category_route_flight_hotel.getCategoryId()) ||
				subCategoryId.equals(BizEnum.BIZ_CATEGORY_TYPE.category_route_scene_hotel.getCategoryId())
				)
				)
				||type.equals(SEARCH_TYPE_TAG.AROUND.toString())){
			return true;
		}
		return false;
	}
	/**
	 * 
	 * @param oldprodList
	 * @param newlist
	 * @return
	 */
	private List<BizProdAd> calcBizProdAd(List<BizProdAd> oldprodList,List<BizProdAd> newlist){
		List<BizProdAd> nowBizProdAdList=new ArrayList<BizProdAd>();
		for (BizProdAd oldbizProdAd : oldprodList) {
			for (BizProdAd newbizProdAd : newlist) {
				if(oldbizProdAd.getProductId().equals(newbizProdAd.getProductId())&&oldbizProdAd.getAdId().equals(newbizProdAd.getAdId())){
					nowBizProdAdList.add(oldbizProdAd);
				}
			}
		}
		oldprodList.removeAll(nowBizProdAdList);
		return oldprodList;
	}
	
	/**
	 * 添加目的地de产品广告
	 * 
	 * @return 添加结果JSON
	 */
	@RequestMapping(value = "/addDestAdvertising")
	@ResponseBody
	public Object addDestAdvertising(FrontDestRelatedVO frontDestRelatedVO, BizDest dest, String showTab, String subId) throws BusinessException {
	  
		BizProdAd record = new BizProdAd();
		Map<String, Object> findParameters = new HashMap<String, Object>(); 
		record.setDestId(dest.getDestId());
		findParameters.put("destId", dest.getDestId());
		String type = "ALL";
		if(SEARCH_TYPE_TAG.TICKET.name().equalsIgnoreCase(showTab)){
			type = SEARCH_TYPE_TAG.TICKET.name();
		}else if(SEARCH_TYPE_TAG.ROUTE.name().equalsIgnoreCase(showTab)){
			type = SEARCH_TYPE_TAG.ROUTE.name();
		}else if(SEARCH_TYPE_TAG.HOTEL.name().equalsIgnoreCase(showTab)){
			type = SEARCH_TYPE_TAG.HOTEL.name();
		}else if(SEARCH_TYPE_TAG.GROUP.name().equalsIgnoreCase(showTab)){
			type = SEARCH_TYPE_TAG.GROUP.name();
		}else if(SEARCH_TYPE_TAG.LOCAL.name().equalsIgnoreCase(showTab)){
			type = SEARCH_TYPE_TAG.LOCAL.name();
		}else if(SEARCH_TYPE_TAG.FREETOUR.name().equalsIgnoreCase(showTab)){
			type = SEARCH_TYPE_TAG.FREETOUR.name();
		}else if(SEARCH_TYPE_TAG.AROUND.name().equalsIgnoreCase(showTab)){
			type = SEARCH_TYPE_TAG.AROUND.name();
		}else if(SEARCH_TYPE_TAG.YOULUN.name().equalsIgnoreCase(showTab)){
			type = SEARCH_TYPE_TAG.YOULUN.name();
		}else if(SEARCH_TYPE_TAG.VISA.name().equalsIgnoreCase(showTab)){
			type = SEARCH_TYPE_TAG.VISA.name();
		}else if(SEARCH_TYPE_TAG.CONNECTS.name().equalsIgnoreCase(showTab)){
			type = SEARCH_TYPE_TAG.CONNECTS.name();
		}else{
			type = SEARCH_TYPE_TAG.ALL.name();
		}
		if (StringUtil.isNotEmptyString(subId) && String.valueOf(SEARCH_TYPE_TAG.FREETOUR.getCode()).equals(subId)) {
			record.setCategoryId(subId);
			findParameters.put("categoryId", subId);
		} else if (StringUtil.isNotEmptyString(subId)) {
			record.setSubCategoryId(Long.valueOf(subId));
			findParameters.put("subCategoryId", subId);
		}
		record.setType(type);
        findParameters.put("type", type);
		
		
		List<BizProdAd> oldBizProdAdList=bizProdAdService.findBizProdAdList(findParameters);
		List<BizProdAd> addBizProdAdList=new ArrayList<BizProdAd>();
		List<BizProdAd> newBizProdAdList=new ArrayList<BizProdAd>();
		List<BizProdAd> addBizProdAdList2=new ArrayList<BizProdAd>();
		String subCategoryId=(String)findParameters.get("subCategoryId");
		if(isCategaryRoute(type,subCategoryId==null?null:Long.parseLong(subCategoryId))){
			log.info("=====adId:userId:"+getLoginUserId()+"==enter==save button==");
			if(frontDestRelatedVO !=null && frontDestRelatedVO.getBizProdAdList()!=null){
				Long seqvalue=0L;
				for(int i=0; i<frontDestRelatedVO.getBizProdAdList().size(); i++){
					BizProdAd bizProdAd = frontDestRelatedVO.getBizProdAdList().get(i);
					if(bizProdAd!=null&&bizProdAd.getProductId() != null){
						if(bizProdAd.getSeq()!=null && bizProdAd.getSeq()+1>seqvalue){
							seqvalue=bizProdAd.getSeq()+1;
						}
						if(bizProdAd.getAdId()==null){
							addBizProdAdList2.add(bizProdAd);
						}
					}
					
				}
				for(int i=0; i<frontDestRelatedVO.getBizProdAdList().size(); i++){
					BizProdAd bizProdAd = frontDestRelatedVO.getBizProdAdList().get(i);
					if(bizProdAd == null || bizProdAd.getProductId() == null){
						continue;
					}
					bizProdAd.setType(type);
					bizProdAd.setDestId(dest.getDestId());
					if(bizProdAd.getProdProduct()!=null){
						bizProdAd.setBizCategoryId(bizProdAd.getProdProduct().getBizCategoryId());
						if(bizProdAd.getProdProduct().getSubCategoryId() != null && !Long.valueOf(String.valueOf(SEARCH_TYPE_TAG.FREETOUR.getCode())).equals(bizProdAd.getProdProduct().getSubCategoryId())){
							bizProdAd.setSubCategoryId(bizProdAd.getProdProduct().getSubCategoryId());
						}
					}
					if(bizProdAd.getSeq()!=null){
						bizProdAd.setSeq(Long.valueOf(bizProdAd.getSeq()));
					}else{
						if(seqvalue>0){
							bizProdAd.setSeq(seqvalue);
							seqvalue=seqvalue+1;
						}else{
							bizProdAd.setSeq(Long.valueOf(addBizProdAdList2.size()));
							seqvalue=seqvalue+1;
						}
						
					}
			
					for(int j=0;j<oldBizProdAdList.size();j++){
						BizProdAd oldAd=oldBizProdAdList.get(j);
						if(oldAd.getProductId().equals(bizProdAd.getProductId())){
							if(oldAd.getCancelStickMark()!=null){
								if(bizProdAd.getCancelStickNum()!=null){
							       bizProdAd.setCancelStickMark(oldAd.getCancelStickMark());
								}
							}
						}
					}
					newBizProdAdList.add(bizProdAd);
					if(bizProdAd.getAdId()==null){
						addBizProdAdList.add(bizProdAd);
					}else{
						//如果productId一样则做seq更新
						bizProdAdService.updateBizProdAdByPrimaryKey(bizProdAd);
					}
					
				}
				//获取已经删除了的产品list
				List<BizProdAd> delBizProdAdList=calcBizProdAd(oldBizProdAdList,newBizProdAdList);
				for (BizProdAd bizProdAd : delBizProdAdList) {
					bizProdAdService.deleteBizProdAdById(bizProdAd.getAdId());
				}
				for (BizProdAd bizProdAd : addBizProdAdList) {
					bizProdAdService.addBizProdAd(bizProdAd);
				}
			}else{
				bizProdAdService.deleteByBizProdAd(record);
			}
		}else{
			log.info("=====adId:userId:"+getLoginUserId()+"==enter==save button=1=");
			bizProdAdService.deleteByBizProdAd(record);
			if(frontDestRelatedVO !=null && frontDestRelatedVO.getBizProdAdList()!=null){
				for(int i=0; i<frontDestRelatedVO.getBizProdAdList().size(); i++){
					BizProdAd bizProdAd = frontDestRelatedVO.getBizProdAdList().get(i);
					if(bizProdAd == null || bizProdAd.getProductId() == null){
						continue;
					}
					bizProdAd.setType(type);
					bizProdAd.setDestId(dest.getDestId());
					if(bizProdAd.getProdProduct()!=null){
						bizProdAd.setBizCategoryId(bizProdAd.getProdProduct().getBizCategoryId());
						if(bizProdAd.getProdProduct().getSubCategoryId() != null && !Long.valueOf(String.valueOf(SEARCH_TYPE_TAG.FREETOUR.getCode())).equals(bizProdAd.getProdProduct().getSubCategoryId())){
							bizProdAd.setSubCategoryId(bizProdAd.getProdProduct().getSubCategoryId());
						}
					}
					if(bizProdAd.getSeq()!=null){
						bizProdAd.setSeq(Long.valueOf(bizProdAd.getSeq()));
					}else{
						bizProdAd.setSeq(Long.valueOf(frontDestRelatedVO.getBizProdAdList().size()));
					}
					for(int j=0;j<oldBizProdAdList.size();j++){
						BizProdAd oldAd=oldBizProdAdList.get(j);
						if(oldAd.getProductId().equals(bizProdAd.getProductId())){
							if(oldAd.getCancelStickMark()!=null){
								if(bizProdAd.getCancelStickNum()!=null){
							       bizProdAd.setCancelStickMark(oldAd.getCancelStickMark());
								}
							}
						}
					}
					bizProdAdService.addBizProdAd(bizProdAd);
				}
				
			
			}
		}
		//添加推送信息
		try {
			pushAdapterService.push(dest.getDestId(),
					ComPush.OBJECT_TYPE.DEST, ComPush.PUSH_CONTENT.BIZ_PROD_AD,ComPush.OPERATE_TYPE.ADD, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
		} catch (Exception e) {
			log.error("Push info failure ！Push Type:"
					+ ComPush.OBJECT_TYPE.DEST.name() + " ID:"
					+ dest.getDestId() + "." + e.getMessage());
		}
		
		
		return ResultMessage.SET_SUCCESS_RESULT;
	}
	
	/**
	 * 选择产品
	 * @param model
	 * @param page 分页参数
	 * @param prodProduct 查询条件
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/findProductList")
	public String findProductList(Model model, Integer page, Long productId, String categoryIds, String productName,String allcategoryIds,
			String subIds,HttpServletRequest req,String showTab) throws BusinessException {
		//查询品类
		List<BizCategory> bizCategoryList = bizCategoryQueryService.getAllValidCategorys();
		model.addAttribute("bizCategoryList", bizCategoryList);

		//判断是否属于携程NS品类（NS跟团游或者NS自由行或者NS当地游）
		if ("NS-22".equalsIgnoreCase(categoryIds) ||
				"NS-60".equalsIgnoreCase(categoryIds) || "NS-67".equalsIgnoreCase(categoryIds)||"NS-66".equalsIgnoreCase(categoryIds)||"NS-65".equalsIgnoreCase(categoryIds)) {
			this.findProductListInfoFacade(model,page,productId,categoryIds,productName,allcategoryIds,showTab,req);
			return "/front/destAdvertising/showFindProductList";
		}
		//加载自由行直系子品类
		List<BizCategory> bizFreedomList = bizCategoryQueryService.getBizCategorysByParentCategoryId(WineSplitConstants.ROUTE_FREEDOM);
		model.addAttribute("bizFreedomList", bizFreedomList);
		Map<String, Object> paramProdProduct = new HashMap<String, Object>();
		paramProdProduct.put("productName", productName);
		paramProdProduct.put("productId", productId);
		if(StringUtils.isNotBlank(categoryIds)){
			paramProdProduct.put("bizCategoryIdArray", categoryIds.split(","));
		}
		if(StringUtils.isNotBlank(subIds)){
			if (!categoryIds.equals(subIds)) {
				paramProdProduct.put("subIds", subIds);
			} else {
				paramProdProduct.put("subIdIsNull", "subIdIsNull");
			}
			model.addAttribute("subIds", subIds);
		}
		paramProdProduct.put("cancelFlag", "Y");
		int count = 0;

		//酒店走hotel prod新接口
		if (StringUtils.isNotBlank(categoryIds) && "1".equals(categoryIds)){
			com.lvmama.dest.api.common.RequestBody<Map<String, Object>> requestBody = new com.lvmama.dest.api.common.RequestBody<Map<String,Object>>();
			requestBody.setT(paramProdProduct);
			requestBody.setToken(Constant.DEST_BU_HOTEL_TOKEN);
			
			com.lvmama.dest.api.common.ResponseBody<Integer> responseBody = iHotelProductQrVstApiServiceAgent.findProdProductCount(requestBody);
			if(responseBody == null || responseBody.isFailure() || responseBody.getT() == null) {
				count = 0;
			} else {
				count = responseBody.getT();
			}
		}else {
			count = MiscUtils.autoUnboxing( prodProductService.findProdProductCount(paramProdProduct) );
		}

		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		paramProdProduct.put("_start", pageParam.getStartRows());
		paramProdProduct.put("_end", pageParam.getEndRows());
		paramProdProduct.put("_orderby", "PRODUCT_ID");
		paramProdProduct.put("_order", "DESC");

		//酒店走hotel prod新接口
		List<ProdProduct> prodProductList = new ArrayList<>();
		if (StringUtils.isNotBlank(categoryIds) && "1".equals(categoryIds)){
			com.lvmama.dest.api.common.RequestBody<Map<String, Object>> requestBody = new com.lvmama.dest.api.common.RequestBody<>();
			requestBody.setToken(Constant.DEST_BU_HOTEL_TOKEN);
			requestBody.setT(paramProdProduct);
			String paramJsonString = JSONUtil.bean2Json(paramProdProduct);
			
			com.lvmama.dest.api.common.ResponseBody<List<HotelProductVstVo>> responseBody = 
					iHotelProductQrVstApiServiceAgent.findProdProductListAndBranch(requestBody);
			if(responseBody == null || responseBody.isFailure() || responseBody.getT() == null) {
				
				this.log.error("invoke iHotelProductQrVstApiServiceAgent.findProdProductListAndBranch failed , request params:" + paramJsonString 
						+ ", result is:" + (responseBody==null? "null??":(responseBody.isFailure() ? responseBody.getErrorMessage() : "responseBody.getT() == null")) );
				
				prodProductList = null;
			} else {
				List<HotelProductVstVo> hotelProductVstVoList = responseBody.getT();
				List<ProdProduct> productList = new ArrayList<ProdProduct>();
				for (HotelProductVstVo hotelProductVstVo : hotelProductVstVoList) {
					ProdProduct product = new ProdProduct();
					EnhanceBeanUtils.copyProperties(hotelProductVstVo, product);
					productList.add(product);
				}
				prodProductList = productList;
			}
		}else {
			prodProductList = MiscUtils.autoUnboxing( prodProductService.findProdProductList(paramProdProduct) );
		}

		List<ProdProductBranch> prodBanchList = new ArrayList<ProdProductBranch>();
		try { 
			for (ProdProduct product : prodProductList) {
				BizDistrict dis =  MiscUtils.autoUnboxing( districtService.findDistrictById(product.getBizDistrictId()) );
				product.setBizDistrict(dis);
				List<ProdProductBranch> prodProductBranchList = product.getProdProductBranchList();
				for (int i = 0; i < prodProductBranchList.size(); i++) {
					prodBanchList.add(prodProductBranchList.get(i));
				}
			}
		} catch (Exception e) {
			log.error("districtService exception occurred. "+e.getMessage());
		}
		
		pageParam.setItems(prodProductList);
		if(StringUtil.isEmptyString(allcategoryIds)){
			allcategoryIds = categoryIds;
		}
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("allcategoryIds",allcategoryIds);
		model.addAttribute("productName", productName);
		model.addAttribute("productId", productId);
		model.addAttribute("categoryIds", categoryIds);
		model.addAttribute("prodBanchList",prodBanchList);
		model.addAttribute("showTab",showTab);
		return "/front/destAdvertising/showFindProductList";
	}

	/**
	 * 查询携程NS跟团游或者NS自由行数据
	 * @param
	 * @param
	 */
	private void findProductListInfoFacade(Model model,Integer page, Long productId, String categoryIds, String productName,
										   String allcategoryIds,String showTab,HttpServletRequest req) {
		//封装参数
		VSTProductInfoRequest request = new VSTProductInfoRequest();
		VSTProductInfoConditionFacadeDTO productFacadeDto = new VSTProductInfoConditionFacadeDTO();
		PaginationDTO paginationDTO = new PaginationDTO();
		request.setReqDtos(productFacadeDto);
		request.setPaginationDTO(paginationDTO);
		if (productId != null && productId> 0L) {
			productFacadeDto.setId(productId.toString());
		}
		if (StringUtils.isNotBlank(productName)) {
			productFacadeDto.setName(productName);
		}
		if ("NS-60".equalsIgnoreCase(categoryIds)) { //跟团游
			productFacadeDto.setCategoryId("60");
            model.addAttribute("selectedCategoryId","NS-60");
		}else if("NS-22".equalsIgnoreCase(categoryIds)){ //自由行
			productFacadeDto.setCategoryId("22");
            model.addAttribute("selectedCategoryId","NS-22");
        }else if("NS-67".equalsIgnoreCase(categoryIds)){ //当地游
			productFacadeDto.setCategoryId("67");
            model.addAttribute("selectedCategoryId","NS-67");
        }else if("NS-66".equalsIgnoreCase(categoryIds)){ //ns代售跟团游
			productFacadeDto.setCategoryId("66");
            model.addAttribute("selectedCategoryId","NS-66");
        }else if("NS-65".equalsIgnoreCase(categoryIds)){ //ns代售自由行
			productFacadeDto.setCategoryId("65");
            model.addAttribute("selectedCategoryId","NS-65");
        }
		
		int pagenum = page == null ? 1 : page;
		paginationDTO.setPageNumber(pagenum);
		paginationDTO.setPageSize(10);
        model.addAttribute("allcategoryIds",allcategoryIds);
        model.addAttribute("productName", productName);
        model.addAttribute("productId", productId);
        model.addAttribute("categoryIds", categoryIds);
        model.addAttribute("showTab",showTab);

        //查询
		try {
			VSTProductResponse productResponse = vstQueryProductInfoFacade.queryList(request);
			if (productResponse == null ) {
				log.warn("vstQueryProductInfoFacade queryList occurred error. productResponse == null,productId="
						+productId+" productName="+" categoryIds="+categoryIds);
				return;
			}
			if (productResponse.getData() == null || productResponse.getPaginationDTO() == null) {
				log.warn("vstQueryProductInfoFacade queryList occurred error. productResponse data or pagination== null,productId="
						+productId+" productName="+" categoryIds="+categoryIds);
				return;
			}
			//封装结果集
			List<VSTProductDTO> vSTProductDTOList = productResponse.getData();
			PaginationDTO paginationDTOResult = productResponse.getPaginationDTO();
			List<ProdProduct> prodProductList = new ArrayList<>();
			for (VSTProductDTO vstProductDTO : vSTProductDTOList) {
				ProdProduct prodProduct = new ProdProduct();
				prodProduct.setProductId(Long.valueOf(vstProductDTO.getId()));
				prodProduct.setProductName(vstProductDTO.getName());
				prodProduct.setSaleFlag(vstProductDTO.getCanSell());//是否可售
				prodProduct.setCancelFlag(vstProductDTO.getIsValid());//是否有效
				if ("NS-60".equalsIgnoreCase(categoryIds)) { //跟团游
					prodProduct.setBizCategoryId(15L);
				}else if("NS-22".equalsIgnoreCase(categoryIds)){ //自由行
					prodProduct.setBizCategoryId(18L);
				}else if("NS-67".equalsIgnoreCase(categoryIds)){ //当地游
					prodProduct.setBizCategoryId(16L);
				}if ("NS-66".equalsIgnoreCase(categoryIds)) { //跟团游
					prodProduct.setBizCategoryId(15L);
				}if ("NS-65".equalsIgnoreCase(categoryIds)) { //跟团游
					prodProduct.setBizCategoryId(18L);
				}
				prodProductList.add(prodProduct);
			}
			Page pageParam = Page.page(paginationDTOResult.getTotalCount(), 10, pagenum);
			pageParam.buildUrl(req);
			pageParam.setItems(prodProductList);
			model.addAttribute("pageParam", pageParam);
		} catch (Exception e) {
			log.error("vstQueryProductInfoFacade queryList occurred error. "+e.getMessage());
			e.printStackTrace();
		}


	}

	/**
	 * 根据父品类得到子品类集合
	 * @param parent
	 * @param response
	 */
	@RequestMapping(value = "/findChildrenCategoryList")
	public void findChildrenCategoryList(String parent, HttpServletResponse response) {
		JSONArray array = new JSONArray();
		if (parent != null && StringUtils.isNumeric(parent)) {
			List<BizCategory> bizFreedomList = bizCategoryQueryService.getBizCategorysByParentCategoryId(Integer.valueOf(parent).longValue());
			array = JSONArray.fromObject(bizFreedomList);
		}
		JSONOutput.writeJSON(response, array);
	}
	/**
	 * 根据AdId查询对应的出发地集合及seq
	 * @param adId 
	 * 上海,南京,苏州,哈尔滨,乌鲁木齐,武汉,天津,北京,杭州,厦门
	 * @param req
	 * @param response
	 */
	@RequestMapping(value = "/findProductDistrictListByAdId")
	public void findProductDistrictListByAdId(Long adId,String districtNames,HttpServletRequest req,HttpServletResponse response){
		JSONArray array = new JSONArray();
		if (adId != null&&StringUtil.isNotEmptyString(districtNames)) {
			//根据adid查询对应的seq值
			Map<String, Object> params=new HashMap<String, Object>();
			params.put("adId", adId);
			String[] districtNameList=districtNames.split(",");
			List<BizProdAd> listPordAd=bizProdAdService.findBizProdAdList(params);
			if(listPordAd==null){
				return;
			}
			//声明多出发地的list
			List<String> productNameList=null;
			for (BizProdAd bizProdAd : listPordAd) {
				if(BizProdAd.DISTRICT_TYPE.MUILT_DEPARTURE.name().equals(bizProdAd.getDistrictType())){
					productNameList=new ArrayList<String>();
					List<BizDistrict> listBizDist=prodPackageDetailService.findDistrictListByDestAdver(bizProdAd.getProductId());
					for (BizDistrict bizDistrict : listBizDist) {
						if("Y".equalsIgnoreCase(bizDistrict.getCancelFlag())){
							productNameList.add(bizDistrict.getDistrictName());
						}
					}
					if(productNameList!=null&&productNameList.size()>0){
						params.put("districtType", bizProdAd.getDistrictType());
						params.put("productNameList", productNameList);
					}else{
						return;
					}
				}
			}
			params.put("districtNameList", districtNameList);
			//判断是否热门城市
			String strs[]={"上海","北京","天津","广州","深圳","重庆","成都","南京","杭州","武汉","无锡"};
			boolean flag=true;
			List<String> hotCityList=new ArrayList<String>(Arrays.asList(strs));
			for (String str : districtNameList) {
				if(!hotCityList.contains(str)){
					flag=false;
					break;
				}
			}
			if(!flag){
				params.put("hotdistrictNameList", hotCityList);
			}
			List<BizProdProvince> list=bizProdRankAdService.queryBizProdRankAdList(params);
			array = JSONArray.fromObject(list);
		}
		JSONOutput.writeJSON(response, array);
	}
	
	/**
	 * 根据AdId查询对应的出发地集合及seq
	 * @param adId
	 * @param req
	 * @param response
	 */
	@RequestMapping(value = "/showDestCitySeq")
	public String showDestCitySeq(Model model,Long adId,HttpServletRequest req,HttpServletResponse response) throws BusinessException{
		model.addAttribute("adId", adId);
		return "/front/destAdvertising/findDestCitySeq";
	}
	
	
	/**
	 * 根据AdId查询对应的出发地集合及seq
	 * @param adId
	 * @param req
	 * @param response
	 */
	@RequestMapping(value = "/addDestRankListByAdId",method=RequestMethod.POST)
	public void addDestRankListByAdId(@RequestBody String jsonStr,HttpServletRequest req,HttpServletResponse response){
		log.info("==muti==save button=userId:"+getLoginUserId()+"==enter==save button==");
		List<BizProdAdRank> rankList=com.alibaba.fastjson.JSONObject.parseArray(jsonStr, BizProdAdRank.class);
		JSONObject josnObj = new JSONObject();
		if(rankList==null){
			josnObj=JSONObject.fromObject(new ResultMessage("-2", "空对象"));
			return;
		}
		if (rankList != null && rankList.size()>0) {
			//先删除adId
			Long adid=rankList.get(0).getAdId();
			log.info("==muti==delete=userId:"+getLoginUserId()+"======");
			bizProdRankAdService.deleteBizProdRankAd(rankList.get(0).getAdId());
			List<BizProdAdRank> prodRanklist=new ArrayList<>();
			for (BizProdAdRank bizProdAdRank : rankList) {
				if(bizProdAdRank!=null){
					if(bizProdAdRank.getSeq()!=null&&bizProdAdRank.getSeq().shortValue()!=0){
						prodRanklist.add(bizProdAdRank);
					}
				}
			}
			try{
				log.info("==muti==add=userId:"+getLoginUserId()+"======");
				bizProdRankAdService.addBizProdRankAd(prodRanklist);
				
				//查询
				Map<String, Object> params=new HashMap<>();
				params.put("adId", rankList.get(0).getAdId());
				List<BizProdAd> list=bizProdAdService.findBizProdAdList(params);
				if(list!=null&&list.size()>0){
					BizProdAd bizProdAd=list.get(0);
					if(bizProdAd.getProdProduct()!=null&&bizProdAd.getProdProduct().getBizDistrictId()!=null){
						for (BizProdAdRank bizProdAdRank : prodRanklist) {
							if(bizProdAdRank.getDistrictId().equals(bizProdAd.getProdProduct().getBizDistrictId())&&bizProdAdRank.getSeq()!=null){
								BizProdAd newBizProdAd=new BizProdAd();
								newBizProdAd.setAdId(bizProdAd.getAdId());
								newBizProdAd.setSeq(bizProdAdRank.getSeq().longValue());
								newBizProdAd.setType(bizProdAd.getType());
								newBizProdAd.setDistrictType(bizProdAd.getDistrictType());
								log.info("==muti==update=userId:"+getLoginUserId()+"======");
								bizProdAdService.updateBizProdAd(newBizProdAd);
								break;
							}
						}
					}
					log.info("=====发送消息：searchPhyDelMessageProducer："+list.get(0).getDestId()+"====");
					//发送消息处理this.searchPhyDelMessageProducer.sendMsg(SearchPushEnums.TABLE_NAME.BIZ_PROD_AD_RANK,SearchPushEnums.PK_TYPE.DEST,"981", "982");
					searchPhyDelMessageProducer.sendMsg(SearchPushEnums.TABLE_NAME.BIZ_PROD_AD_RANK,SearchPushEnums.PK_TYPE.DEST,list.get(0).getDestId());
				}
				
				josnObj=JSONObject.fromObject(new ResultMessage("0", "成功"));
			}catch(Exception e){
				log.error("====adId",e);
				josnObj=JSONObject.fromObject(new ResultMessage("-1", "失败"));
			}
			setDestAdverLog(adid,"操作了seq值");
		}
		
		JSONOutput.writeJSON(response, josnObj);
	}
	
	public void setDestAdverLog(Long destAdId,String contextLog){
		String loginUserId=this.getLoginUserId();
		lvmmLogClientService.sendLog(ComLog.COM_LOG_OBJECT_TYPE.PROD_DEST_DESTADVER, 
				destAdId, 
				destAdId, 
				loginUserId, 
				contextLog, 
				ComLog.COM_LOG_LOG_TYPE.PROD_DEST_DESTADVER.name(), 
				ComLog.COM_LOG_LOG_TYPE.PROD_DEST_DESTADVER.getCnName(),
				"修改出发地信息");
	}
	
}