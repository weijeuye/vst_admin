package com.lvmama.vst.back.prod.web.hotelPackage.productPack;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.bridge.utils.hotel.DestHotelAdapterUtils;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.po.BizCategoryProp;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.biz.service.BizDictQueryService;
import com.lvmama.vst.back.biz.service.CategoryPropGroupService;
import com.lvmama.vst.back.client.biz.service.CategoryPropClientService;
import com.lvmama.vst.back.client.biz.service.CategoryClientService;
import com.lvmama.vst.back.biz.service.DestService;
import com.lvmama.vst.back.client.biz.service.DistrictClientService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.prod.po.ProdLineRoute;
import com.lvmama.vst.back.prod.po.ProdPackageDetail;
import com.lvmama.vst.back.prod.po.ProdPackageDetail.OBJECT_TYPE_DESC;
import com.lvmama.vst.back.prod.po.ProdPackageHotelCombDetail;
import com.lvmama.vst.back.prod.po.ProdPackageHotelCombHotel;
import com.lvmama.vst.back.prod.po.ProdPackageHotelCombTicket;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductProp;
import com.lvmama.vst.back.client.prod.service.ProdDestReClientService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteClientService;
import com.lvmama.vst.back.client.prod.service.ProdPackageHotelCombDetailService;
import com.lvmama.vst.back.client.prod.service.ProdPackageHotelCombHotelService;
import com.lvmama.vst.back.client.prod.service.ProdPackageHotelCombTicketService;
import com.lvmama.vst.back.prod.service.ProdProductBranchService;
import com.lvmama.vst.back.client.prod.service.ProdProductPropClientService;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.prod.vo.ProdPackageHotelCombDetailVO;
import com.lvmama.vst.back.prod.vo.ProdPackageHotelCombHotelVO;
import com.lvmama.vst.back.prod.vo.ProdPackageHotelCombTicketVO;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.router.adapter.ProdPackageHotelCombDetailAdapterService;
import com.lvmama.vst.back.router.adapter.ProdProductHotelAdapterService;
import com.lvmama.vst.back.client.supp.service.SuppSupplierClientService;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.utils.json.JSONOutput;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.Constant.VST_CATEGORY;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.pet.goods.PetProdGoodsAdapter;
import com.lvmama.vst.back.utils.MiscUtils;
/**
 * 产品管理Action
 * 
 * 
 * 
 */
@Controller
@RequestMapping("/hotelCommbPackage/productPack")
@SuppressWarnings({"rawtypes","unchecked","static-access"})
public class HotelCommbPackageProductAction extends BaseActionSupport {
	private static final long serialVersionUID = 4662780244725170052L;

	private static final Log LOG = LogFactory.getLog(HotelCommbPackageProductAction.class);

	@Autowired
	private ProdProductService prodProductService;
	@Autowired
	private ProdProductHotelAdapterService prodProductHotelAdapterService;
	
	@Autowired
	private  SuppGoodsClientService   suppGoodsService;
	
	@Autowired
	private ProdProductPropClientService prodProductPropService;
	
	@Autowired
	private CategoryClientService categoryService;

	@Autowired
	private CategoryPropGroupService categoryPropGroupService;
	@Autowired
	private ComLogClientService comLogService;

	@Autowired
	private DistrictClientService districtService;

	@Autowired
	private PetProdGoodsAdapter petProdGoodsAdapter;

	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;

	@Autowired
	private BizDictQueryService bizDictQueryService;
	
	@Autowired
	ProdProductBranchService prodProductBranchService;
	
	@Autowired
	private ProdPackageHotelCombHotelService prodPackageHotelCombHotelService;
	
	@Autowired
	ProdPackageHotelCombTicketService prodPackageHotelCombTicketService;
	@Autowired
	private ProdPackageHotelCombDetailService prodPackageHotelCombDetailService;
	@Autowired
	private ProdPackageHotelCombDetailAdapterService prodPackageHotelCombDetailAdapterService;
	@Autowired
	private ProdLineRouteClientService prodLineRouteService;
	@Autowired
	private ProdDestReClientService prodDestReService;
	@Autowired
	DestService destService;
	@Autowired
	private SuppSupplierClientService suppSupplierService;
	@Autowired
	private CategoryPropClientService categoryPropService;
	@Autowired
	private DestHotelAdapterUtils destHotelAdapterUtils;

	/**
	 * 酒店套餐跳转到打包产品维护页面
	 * 
	 * @param model
	 * @param productBranchId
	 * @param productId
	 * @return
	 */
	@RequestMapping(value = "/showPackList")
	public String showPackList(Model model, Long productId,Long productBranchId)
			throws BusinessException {
		if (productId != null) {
			List<SuppGoods> suppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsByBranchId(productBranchId));
			List<ProdPackageHotelCombDetailVO> prodPackageHotelCombHotelDetailList = null;
			List<ProdPackageHotelCombDetailVO> prodPackageHotelCombTicketDetailList = null;
			if(suppGoods!=null && suppGoods.size()>0){
				//酒店组
				List<ProdPackageHotelCombHotelVO> prodPackageHotelCombHotelList= prodPackageHotelCombHotelService.findProdPackageHotelCombHotelBySuppGoodsId(suppGoods.get(0).getSuppGoodsId(),false);
				
				if(prodPackageHotelCombHotelList!=null && prodPackageHotelCombHotelList.size()>0){
					
					for(ProdPackageHotelCombHotelVO prodPackageHotelCombHotelVO  : prodPackageHotelCombHotelList){
						ProdLineRoute prodLineRoute =  MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(prodPackageHotelCombHotelVO.getLineRouteId()));
						prodPackageHotelCombHotelVO.setProdLineRoute(prodLineRoute);
						//打包酒店规格
						 prodPackageHotelCombHotelDetailList = prodPackageHotelCombDetailService.findProdPackageHotelCombDetailByGroupId(prodPackageHotelCombHotelVO.getHotelGroupId(),null,ProdPackageDetail.OBJECT_TYPE_DESC.PROD_BRANCH.name(),true);
						
						 prodPackageHotelCombHotelVO.setCombDetailVOs(prodPackageHotelCombHotelDetailList);
						 
					
					}
				}
				//门票组
				List<ProdPackageHotelCombTicketVO> prodPackageHotelCombTicketList = prodPackageHotelCombTicketService.findProdPackageHotelCombTicketBySuppGoodsId(suppGoods.get(0).getSuppGoodsId(),false);
				
				if(prodPackageHotelCombTicketList!=null && prodPackageHotelCombTicketList.size()>0){
					
					for(ProdPackageHotelCombTicketVO prodPackageHotelCombTicketVO  : prodPackageHotelCombTicketList){
						ProdLineRoute prodLineRoute =  MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(prodPackageHotelCombTicketVO.getLineRouteId()));
						
						prodPackageHotelCombTicketVO.setProdLineRoute(prodLineRoute);
						//打包门票商品
						 prodPackageHotelCombTicketDetailList = prodPackageHotelCombDetailService.findProdPackageHotelCombDetailByGroupId(prodPackageHotelCombTicketVO.getTicketGroupId(),null,ProdPackageDetail.OBJECT_TYPE_DESC.SUPP_GOODS.name(),true);
						
						 prodPackageHotelCombTicketVO.setCombDetailVOs(prodPackageHotelCombTicketDetailList);
					}
					
					
				}
				
				
				VST_CATEGORY hotelBizcategory= Constant.VST_CATEGORY.CATEGORY_HOTEL;
				VST_CATEGORY ticketBizcategory = Constant.VST_CATEGORY.CATEGORY_TICKET;
				model.addAttribute("productId", productId);
				model.addAttribute("hotelBizcategory", hotelBizcategory);
				model.addAttribute("ticketBizcategory", ticketBizcategory);
				model.addAttribute("suppGoodsId", suppGoods.get(0).getSuppGoodsId());
				model.addAttribute("prodPackageHotelCombHotelList", prodPackageHotelCombHotelList);
				model.addAttribute("prodPackageHotelCombTicketList", prodPackageHotelCombTicketList);
				model.addAttribute("hotelOnlineFlag",String.valueOf(destHotelAdapterUtils.checkHotelSystemOnlineEnable()));
				
			}
		}
		return "/prod/hotelPackage/productPack/showPackList";

	
	}
	
	/**
	 * 添加 酒店组||门票组 页面
	 * @param model
	 * @param productId
	 * @param categoryId
	 * @param suppGoodsId
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/showAddGroup")
	public String showAddGroup(Model model, Long productId,Long categoryId,Long suppGoodsId)
			throws BusinessException {
		if(productId!=null && categoryId!=null){
			Map<String,Object> parms = new HashMap<String, Object>();
			parms.put("productId", productId);
			parms.put("cancleFlag", "Y");
			//获取有效的行程
			List<ProdLineRoute> prodLineRouteList = prodLineRouteService.findProdLineRouteByParams(parms);
			boolean isHotel = false;
			boolean isTicket = false;
			if(prodLineRouteList!=null&&prodLineRouteList.size()>0){
				Constant.VST_CATEGORY bizCategory = null;
				if(isHotelCategory(categoryId)){
					isHotel = true;
					bizCategory = Constant.VST_CATEGORY.CATEGORY_HOTEL;
				}else if(isTickectCategory(categoryId)){
					isTicket = true;
					bizCategory = Constant.VST_CATEGORY.CATEGORY_TICKET;
				}
				//品类列表
				List<Constant.VST_CATEGORY> categoryList = new ArrayList<Constant.VST_CATEGORY>();
				for(Constant.VST_CATEGORY category : Constant.VST_CATEGORY.values()){
					if(isHotel && Constant.VST_CATEGORY.CATEGORY_HOTEL.getCategoryId().equals(String.valueOf(category.getCategoryId()))){
						categoryList.add(category);
					}else if(isTicket && Constant.VST_CATEGORY.CATEGORY_TICKET.getCategoryId().equals(category.getFathercategoryId())){
						categoryList.add(category);
					}
					
				}
				model.addAttribute("prodLineRouteList",prodLineRouteList);
				model.addAttribute("productId", productId);
				model.addAttribute("suppGoodsId", suppGoodsId);
				model.addAttribute("bizCategory", bizCategory);
				model.addAttribute("bizCategoryList", categoryList);
				if(isHotel){
					
					return "/prod/hotelPackage/productPack/showAddGroupHotel";
					
				}else if(isTicket){
					
					return "/prod/hotelPackage/productPack/showAddGroupTicket";
				}
				
				
			}else{
				
				throw  new BusinessException("无有效行程");
			}
			
		}
			return "";
	}
	
	
	
	/**
	 * 添加 酒店组||门票组 
	 * @param model
	 * @param prodPackageHotelCombTicket
	 * @param selectCategoryId
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/addGroup")
	public Object addGroup (Model model ,ProdPackageHotelCombTicket prodPackageHotelCombTicket, ProdPackageHotelCombHotel prodPackageHotelCombHotel,Long suppGoodsId,Long selectCategoryId){
		if(LOG.isInfoEnabled()){
			log.info("");
		}
		int rs=0;
		boolean isHotel = false;
		boolean isTicket = false;
		ProdLineRoute prodLineRoute = new ProdLineRoute();
		if(prodPackageHotelCombTicket!=null){

			Long categoryId = prodPackageHotelCombTicket.getCategoryId();
			
			Long productId = prodPackageHotelCombTicket.getProductId();
			
			Long lineRouteId = prodPackageHotelCombTicket.getLineRouteId();
			
			String stayDays =  prodPackageHotelCombTicket.getStayDays();
			
			ProdPackageHotelCombDetailVO prodPackageHotelCombDetailVO = new ProdPackageHotelCombDetailVO();
			if(categoryId!=null && productId!=null && lineRouteId!=null && suppGoodsId!=null && StringUtils.isNotBlank(stayDays)){
				
					
					prodLineRoute =  MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(lineRouteId));
					prodPackageHotelCombDetailVO.setProdLineRoute(prodLineRoute);
					BizCategory bizcategory =  MiscUtils.autoUnboxing(categoryService.findCategoryById(categoryId));
					prodPackageHotelCombDetailVO.setBizCategory(bizcategory);
			    	 if(prodLineRoute!=null){
			    		 
			    		 SuppGoods suppGoods =  MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(suppGoodsId));
			    		 if(suppGoods!=null){
			    			 
			    			prodPackageHotelCombTicket.setCreateUser(this.getLoginUser().getUserId());
			    			 
			    			 String[] stayDayArr = stayDays.split(",");
			 				if(stayDayArr!=null && stayDayArr.length>0){
			 					
			 				
			 					//添加酒店组，要对插入时间段校验交集
			 				if(isHotelCategory(selectCategoryId)){
			 					isHotel = true;
			 					if(stayDayArr.length>0 && (stayDayArr.length<= prodLineRoute.getStayNum())){
			 						String startDay = stayDayArr[0];
			 						String endDay = null;
			 						if(stayDayArr.length==1){
			 							endDay = startDay;
			 						}else{
			 							endDay = stayDayArr[1];
			 						}
			 						
			 						if(StringUtils.isNumeric(startDay) && StringUtils.isNumeric(endDay)){
			 							Long start = Long.valueOf(startDay);
			 							Long end =  Long.valueOf(endDay);
			 							//校验时间 是否非法
			 							if(start<1 || end<1 || start>end || start > prodLineRoute.getStayNum() || end >prodLineRoute.getStayNum()){
			 								
			 								throw  new BusinessException("插入时间有误");
			 							}
			 						}
			 						
			 					}else{
			 						throw  new BusinessException("参数错误");
			 					}
			 					//获取数据库数据同行程的时间段
			 					List<ProdPackageHotelCombHotelVO> prodPackageHotelCombHotelList = prodPackageHotelCombHotelService.findProdPackageHotelCombHotelBySuppGoodsIdAndLineRouteId(suppGoodsId, lineRouteId,false);
			 					if(prodPackageHotelCombHotelList!=null&& prodPackageHotelCombHotelList.size()>0){
			 							for(ProdPackageHotelCombHotelVO prodPackageHotelCombHotelVO :prodPackageHotelCombHotelList){
				 							if(prodLineRoute.getLineRouteId().equals(prodPackageHotelCombHotelVO.getLineRouteId())){
				 							String[]  dbStayDaysArr = prodPackageHotelCombHotelVO.getStayDays().split(",");
				 								//对同一行程打包酒店组进行时间段交集校验
				 								if(validateGroupTimeIsConflict(dbStayDaysArr,stayDayArr)){
					 								throw new BusinessException("与行程["+prodLineRoute.getRouteName()+"]"+"第"+dbStayDaysArr[0]+"---"+dbStayDaysArr[dbStayDaysArr.length-1]+"晚冲突");
					 							}
				 								
				 								
				 								
				 							}
				 						}
			 							rs = prodPackageHotelCombHotelService.saveProdPackageHotelCombHotel(prodPackageHotelCombHotel);
			 						
			 					}else{
			 						   //数据库不存在时直接保存即可
			 						   rs = prodPackageHotelCombHotelService.saveProdPackageHotelCombHotel(prodPackageHotelCombHotel);
			 						
			 					}
			 					
			 				}else if(isTickectCategory(selectCategoryId)){
			 						isTicket = true;
			 						prodPackageHotelCombTicket.setCreateUser(this.getLoginUser().getUserId());
			 						prodPackageHotelCombTicket.setCategoryId(selectCategoryId);
			 						for(String s  : stayDayArr){
			 							if(StringUtils.isNumeric(s)){
			 								Long stayDayNum = Long.valueOf(s);
			 								if(stayDayNum <1 && stayDayNum > prodLineRoute.getRouteNum()){
			 									throw  new BusinessException("插入时间有误");
			 								}
			 							}
			 							
			 						}		
			 									//门票组不做校验
						 						rs = prodPackageHotelCombTicketService.saveProdPackageHotelCombTicket(prodPackageHotelCombTicket);
			 					
			 				}
			    		 
			 				}else{
			    			 
			    			 throw  new BusinessException("插入时间有误");
			    		 }
			    		 
			    	 }
				}
				
			}
		}
		
		if(rs==1){
			
			try {
				String log = "";
			
			if(isHotel){
				
				log = getPackGroupAddLog(prodPackageHotelCombHotel,prodLineRoute);
			}else if(isTicket){
				
				log = getPackGroupAddLog(prodPackageHotelCombTicket,prodLineRoute);
				
			}
				//添加操作日志
				if (StringUtil.isNotEmptyString(log)) {
					comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_HOTELCOMMB_GROUP, suppGoodsId, suppGoodsId, 
							this.getLoginUser().getUserName(),
							"创建组：" + log,
							COM_LOG_OBJECT_TYPE.PROD_PRODUCT_HOTELCOMMB_GROUP.name(),
							"创建组", null);
				}
			} catch (Exception e) {
				LOG.error("Record Log failure ！Log type:" + COM_LOG_OBJECT_TYPE.PROD_PRODUCT_HOTELCOMMB_GROUP.name());
				LOG.error(e.getMessage());
			}
			
			
			
			return new ResultMessage("success", "保存成功");
		}else {
			
			return new ResultMessage("success", "保存失败");
		}
	}
	
	/**
	 * 删除酒店或门票组
	 * @param model
	 * @param groupId
	 * @param categoryId
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/delGroup")
	public Object delGroup (Model model,Long groupId,Long categoryId,Long suppGoodsId,Long lineRouteId){
		int rs = 0;
		List<ProdPackageHotelCombDetailVO> pakageList = null;
		String detailStr ="";
		String delLog = "";
		boolean ishotel = false;
		boolean isTiket = false;
		if(groupId!=null && categoryId!=null){
			 
		if(isHotelCategory(categoryId)){
			pakageList = prodPackageHotelCombDetailService.findProdPackageHotelCombDetailByGroupId(groupId,null, ProdPackageDetail.OBJECT_TYPE_DESC.PROD_BRANCH.name(),false);
			ishotel=true;
		}else if(isTickectCategory(categoryId)){
			pakageList = prodPackageHotelCombDetailService.findProdPackageHotelCombDetailByGroupId(groupId,null,ProdPackageDetail.OBJECT_TYPE_DESC.SUPP_GOODS.name(),false);
			isTiket = true;
		}
		if(pakageList!=null && pakageList.size()>0){
			for(ProdPackageHotelCombDetailVO detail : pakageList){
				 detailStr+=detail.getObjectId()+",";
					
			}	
			
		
		}
		
		ProdLineRoute prodLineRoute =  MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(lineRouteId));
	    /** 行程名称 */
	    String routeName= "";
		if(null!=prodLineRoute){
			routeName = prodLineRoute.getRouteName();
		}
		delLog = "组ID:"+groupId+","+"品类:"+ Constant.VST_CATEGORY.getCnNameByStatus(String.valueOf(categoryId))+","+"行程:"+routeName+","+"打包ID:"+"["+detailStr+"]";
		if(ishotel){
			rs = prodPackageHotelCombHotelService.deleteByHotelGroupId(groupId);
		}else if(isTiket){
			rs = prodPackageHotelCombTicketService.deleteByTicketGroupId(groupId);
		}
	
		if(rs == 1){
				   try {
					   
						//添加操作日志
						if (StringUtil.isNotEmptyString(delLog)) {
							comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_HOTELCOMMB_GROUP, suppGoodsId, suppGoodsId, 
									this.getLoginUser().getUserName(),
									"删除组：" + delLog,
									COM_LOG_OBJECT_TYPE.PROD_PRODUCT_HOTELCOMMB_GROUP.name(),
									"删除组", null);
						}
					} catch (Exception e) {
						LOG.error("Record Log failure ！Log type:" + COM_LOG_OBJECT_TYPE.PROD_PRODUCT_HOTELCOMMB_GROUP.name());
						LOG.error(e.getMessage());
					}
					
				   return new ResultMessage("success", "删除成功");
			}
			
			
			
		}
			return new ResultMessage("success", "删除失败");
		
	}
	
	/**
	 * 选择酒店规格或门票商品列表页
	 * @param model
	 * @param page
	 * @param groupId
	 * @param prodPackageHotelCombDetailVO
	 * @param selectCategoryId
	 * @param redirectType
	 * @param isSelectFlag
	 * @param productBranchId
	 * @param branchName
	 * @param suppGoodsId
	 * @param req
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/showSelectProductList")
	public Object showSelectProductList(Model model, Integer page, Long groupId,ProdPackageHotelCombDetailVO prodPackageHotelCombDetailVO,
		 Long selectCategoryId, String redirectType,String isSelectFlag, String branchName,Long suppGoodsId,Long lineRouteId,
			HttpServletRequest req) throws BusinessException {
		
		HashMap<String, Object> params = new HashMap<String, Object>();
		if (prodPackageHotelCombDetailVO != null ) {
			if(prodPackageHotelCombDetailVO.getProdProduct()!=null){
				Long productId =  prodPackageHotelCombDetailVO.getProdProduct().getProductId();
			String productName = prodPackageHotelCombDetailVO.getProdProduct().getProductName();
			
			model.addAttribute("productName",productName);
			model.addAttribute("productId",productId);
			
			params.put("productName", productName);
			params.put("productId", productId);
			
			}
			if(prodPackageHotelCombDetailVO.getProdProductBranch()!=null){
				Long productBranchId = prodPackageHotelCombDetailVO.getProdProductBranch().getProductBranchId();
				params.put("productBranchId", productBranchId);
				model.addAttribute("productBranchId", productBranchId);
				
			}
			if(prodPackageHotelCombDetailVO.getSuppGoods()!=null){
				Long pSuppGoodsId = prodPackageHotelCombDetailVO.getSuppGoods().getSuppGoodsId();
				params.put("suppGoodsId", pSuppGoodsId);
				model.addAttribute("pSuppGoodsId",pSuppGoodsId);
				
			}
		}
		params.put("bizCategoryId", selectCategoryId);
		params.put("IsNotExistsObject", "Y");//过滤已经被该组打包商品或规格
		params.put("groupId", groupId);
		model.addAttribute("selectCategoryId", selectCategoryId);
		model.addAttribute("isSelectFlag", isSelectFlag);
		model.addAttribute("lineRouteId", lineRouteId);
		//存放下拉选择品类列表
		List<BizCategory> selectCategoryList = new ArrayList<BizCategory>();
		
		
		if(isHotelCategory(selectCategoryId)){
			
			BizCategory selectBizCategory = bizCategoryQueryService.getCategoryById(selectCategoryId);
			selectCategoryList.add(selectBizCategory);
			if (StringUtil.isNotEmptyString(redirectType)) {
				
				if(prodPackageHotelCombDetailVO.getBizDistrict()!=null){
					String districtName = prodPackageHotelCombDetailVO.getBizDistrict().getDistrictName();
					Long bizDistrictId = prodPackageHotelCombDetailVO.getBizDistrict().getDistrictId();
					if(bizDistrictId!=null ){
						params.put("bizDistrictId",bizDistrictId);
					}
					if(StringUtils.isNotBlank(districtName)){
						params.put("districtName",districtName);
					}
					model.addAttribute("districtId", bizDistrictId);
					model.addAttribute("districtName", districtName);
				}
				params.put("objectType",ProdPackageDetail.OBJECT_TYPE_DESC.PROD_BRANCH.name());
				int count = prodPackageHotelCombDetailAdapterService.getTotalHotelCommbBranchOrGoodListCount(params);
				int pagenum = page == null ? 1 : page;
				Page pageParam = Page.page(count, 20, pagenum);
				pageParam.buildUrl(req);
				params.put("_start", pageParam.getStartRows());
				params.put("_end", pageParam.getEndRows());
				params.put("_orderby", "t.PRODUCT_ID");
				params.put("_order", "DESC");
				List<ProdPackageHotelCombDetailVO> branchList = prodPackageHotelCombDetailAdapterService.selectHotelBranchOrGoodList(params);
				pageParam.setItems(branchList);
				model.addAttribute("pageParam", pageParam);
				
			}
			
			model.addAttribute("groupId",groupId);
			model.addAttribute("redirectType",redirectType);
			model.addAttribute("isSelectFlag",isSelectFlag);
			model.addAttribute("suppGoodsId",suppGoodsId);
			model.addAttribute("selectCategoryList", selectCategoryList);
			model.addAttribute("hotelOnlineFlag",String.valueOf(destHotelAdapterUtils.checkHotelSystemOnlineEnable()));
			return "/prod/hotelPackage/productPack/showSelectHotelProductList";
			
		}else if(isTickectCategory(selectCategoryId)){
			
			List<BizCategory> ticketBizcategoryList = bizCategoryQueryService.getBizCategorysByParentCategoryId(Long.valueOf(Constant.VST_CATEGORY.CATEGORY_TICKET.getCategoryId()));
			if (StringUtil.isNotEmptyString(redirectType)) {
				
				if(prodPackageHotelCombDetailVO.getBizDest()!=null){
					String destName = prodPackageHotelCombDetailVO.getBizDest().getDestName();
					Long destId = prodPackageHotelCombDetailVO.getBizDest().getDestId();
					if(destId!=null){
						params.put("destId",destId);
					}else{
						params.put("destName",destName);
					}
					model.addAttribute("destId", destId);
					model.addAttribute("destName", destName);
				}
				//当查询门票商品时必选y
				params.put("isNeedGood", "Y");
				//获取供应商信息
				params.put("isNeedSupplier", "Y");
				params.put("bizCategoryId", selectCategoryId);
				params.put("parentId",Constant.VST_CATEGORY.CATEGORY_TICKET.getCategoryId());
				params.put("objectType", ProdPackageDetail.OBJECT_TYPE_DESC.SUPP_GOODS.name());
				int count = prodPackageHotelCombDetailAdapterService.getTotalHotelCommbBranchOrGoodListCount(params);
				int pagenum = page == null ? 1 : page;
				Page pageParam = Page.page(count,20, pagenum);
				pageParam.buildUrl(req);
				params.put("_start", pageParam.getStartRows());
				params.put("_end", pageParam.getEndRows());
				params.put("_orderby", "t.PRODUCT_ID");
				params.put("_order", "DESC");
				List<ProdPackageHotelCombDetailVO> goodsVoList = prodPackageHotelCombDetailAdapterService.selectTicketBranchOrGoodList(params);
				pageParam.setItems(goodsVoList);
				model.addAttribute("pageParam", pageParam);
				
			}
			model.addAttribute("groupId",groupId);
			//当redirectType == ""时，说明是第一次打开列表框.
			model.addAttribute("redirectType",redirectType);
			//当isSelectFlag == 1时说明不是第一次勾选商品，那么已选商品框会显示
			model.addAttribute("isSelectFlag",isSelectFlag);
			model.addAttribute("suppGoodsId",suppGoodsId);
			selectCategoryList.addAll(ticketBizcategoryList);
			model.addAttribute("selectCategoryList", selectCategoryList);
			return "/prod/hotelPackage/productPack/showSelectTicketProductList";
			
		}
		return "";
		
	}

	/**
	 * 加入打包
	 * @param model
	 * @param selectCategoryId
	 * @param groupId
	 * @param objectIdStr
	 * @param suppGoodsId
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/addGroupDetail")
	public Object addGroupDetail(Model model,Long selectCategoryId,Long groupId,String objectIdStr,Long suppGoodsId,Long lineRouteId){
		String logStr = "";
		boolean ishotel = false;
		boolean isTiket = false;
		
		if(selectCategoryId!=null && groupId!=null && StringUtils.isNotBlank(objectIdStr)){
			//获取打包对象
			String[] split = objectIdStr.split(",");
			if(split == null || split.length<=0){
				
				return new ResultMessage("success", "参数错误");
			}
			List<Long> objectIds = new ArrayList<Long>();
			for(String objectId: split ){
				
				if(StringUtils.isNumeric(objectId)){
					objectIds.add(Long.valueOf(objectId));
				}
				
			}
			Long[] ids = null;
			if(objectIds.size()>0){
				 ids = objectIds.toArray(new Long[objectIds.size()]);
			}
			
			
			ProdPackageHotelCombDetailVO prodPackageHotelCombDetailVO = new ProdPackageHotelCombDetailVO();
			List<ProdPackageHotelCombDetailVO> prodPackageHotelCombDetailList = null;
			
			if(isHotelCategory(selectCategoryId)){
				 ProdPackageHotelCombHotel hotelGroup = prodPackageHotelCombHotelService.findProdPackageHotelCombHotelByGroupId(groupId);
					if(hotelGroup==null){
						return new ResultMessage("error", "组不存在");
					}
				ishotel = true;
				prodPackageHotelCombDetailVO.setObjectType(ProdPackageDetail.OBJECT_TYPE_DESC.PROD_BRANCH.name());
				prodPackageHotelCombDetailList = prodPackageHotelCombDetailService.findProdPackageHotelCombDetailByGroupId(groupId,ids,ProdPackageDetail.OBJECT_TYPE_DESC.PROD_BRANCH.name(),true);
				
			}else if(isTickectCategory(selectCategoryId)){
				ProdPackageHotelCombTicket ticketGroup = prodPackageHotelCombTicketService.findProdPackageHotelCombHotelByGroupId(groupId);
				if(ticketGroup==null){
					return new ResultMessage("error", "组不存在");
				}
				isTiket = true;
				prodPackageHotelCombDetailVO.setObjectType(ProdPackageDetail.OBJECT_TYPE_DESC.SUPP_GOODS.name());
				prodPackageHotelCombDetailList = prodPackageHotelCombDetailService.findProdPackageHotelCombDetailByGroupId(groupId,ids,ProdPackageDetail.OBJECT_TYPE_DESC.SUPP_GOODS.name(),true);
			}
			
			
			if(prodPackageHotelCombDetailList!=null && prodPackageHotelCombDetailList.size()>0){
				StringBuffer sb = new StringBuffer();
				for(ProdPackageHotelCombDetailVO prodPackageHotelCombDetail:prodPackageHotelCombDetailList){
					sb.append(prodPackageHotelCombDetail.getObjectId()+",");
				}
				String objs = sb.toString();
				sb.delete(0,sb.length());
				sb.append("这些"+OBJECT_TYPE_DESC.getCnName(prodPackageHotelCombDetailVO.getObjectType())+"ID"+"["+objs+"]"+"已经被打包过了");
				return new ResultMessage(objs,sb.toString());
			}
			
			prodPackageHotelCombDetailVO.setObjectIds(ids);
			prodPackageHotelCombDetailVO.setCreateUser(this.getLoginUser().getUserId());
			prodPackageHotelCombDetailVO.setHotelCombGroupId(groupId);
			prodPackageHotelCombDetailService.saveProdPackageHotelCombDetail(prodPackageHotelCombDetailVO);
			
				try {
					if(ishotel){
						
						logStr =  "打包"+Constant.VST_CATEGORY.CATEGORY_HOTEL.getCnName()+"规格ID:"+"["+objectIdStr+"]";
						
					}else if(isTiket){
						
						logStr =  "打包"+Constant.VST_CATEGORY.CATEGORY_TICKET.getCnName()+"商品ID:"+"["+objectIdStr+"]";
						
					}
					
					if(StringUtils.isNotBlank(logStr)){
					comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_HOTELCOMMB_GROUP, suppGoodsId, suppGoodsId,
							this.getLoginUser().getUserName(), "组ID:"+groupId+"["+logStr+"]",
							COM_LOG_OBJECT_TYPE.PROD_PRODUCT_HOTELCOMMB_GROUP.name(), "加入打包", null);
					}
				} catch (Exception e) {
					log.error("Record Log failure ！Log type:" + COM_LOG_OBJECT_TYPE.PROD_PRODUCT_HOTELCOMMB_GROUP.name());
					log.error(e.getMessage());
				}
			
			
			return new ResultMessage("success", "保存成功");
			
		}else{
			
			return new ResultMessage("error", "保存失败");
			
		}
		
	}
	
	
	/**
	 * 取消打包
	 * @param model
	 * @param hotelCombDetailId
	 * @param categoryId
	 * @param suppGoodsId
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/delGroupDetail")
	public Object delGroupDetail(Model model,Long hotelCombDetailId,Long categoryId,Long suppGoodsId){
		
		String logStr = "";
		try {
			logStr = getDeletePackGroupDetail(hotelCombDetailId,categoryId);
		} catch (Exception e) {
			log.error("methd<delGroupDetail> getLog error "+e);
		}
		
		int res=0;
		if(hotelCombDetailId!=null){
			res = prodPackageHotelCombDetailService.deleteByHotelCombDetailId(hotelCombDetailId);
	
		}
		
			try {
					
				if(StringUtils.isNotBlank(logStr)){
				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_HOTELCOMMB_GROUP, suppGoodsId, suppGoodsId,
						this.getLoginUser().getUserName(), "取消打包: "+logStr,
						COM_LOG_OBJECT_TYPE.PROD_PRODUCT_HOTELCOMMB_GROUP.name(), "取消打包", null);
				}
			} catch (Exception e) {
				log.error("Record Log failure ！Log type:" + COM_LOG_OBJECT_TYPE.PROD_PRODUCT_HOTELCOMMB_GROUP.name());
				log.error(e.getMessage());
			}
		
		
		if(res>0){
			return new ResultMessage("success", "取消成功");
		}
		
		return new ResultMessage("error", "取消失败");
		
	}
	
	
	/**
	 * 校验酒店套餐商品打包是否符合产品套餐包含勾选的门票和酒店选项
	 * 酒店是必选的，要求不符合时返回一个提示
	 * 
	 */
	@ResponseBody
	@RequestMapping(value="/checkHotelCommbGoodIsHasPackege")
	public Object checkHotelCommbGoodIsHasPackege(Model model,Long suppGoodsId,Long productId){
		
		Map<String,Object> params = new HashMap<String, Object>(); 
		params.put("propCode", "combo_contained");
		params.put("categoryId",Constant.VST_CATEGORY.CATEGORY_ROUTE_HOTELCOMB.getCategoryId());
		List<BizCategoryProp> categoryPropList =  MiscUtils.autoUnboxing(categoryPropService.findCategoryPropList(params));
		boolean isNeedPackTicket = false;
		if(categoryPropList!=null && categoryPropList.size()>0){
			BizCategoryProp combo_contained  = categoryPropList.get(0);
			params.clear();
			params.put("productId", productId);
			params.put("propId", combo_contained.getPropId());
			List<ProdProductProp> prodProductPropList =  MiscUtils.autoUnboxing(prodProductPropService.findProdProductPropList(params));
			if(prodProductPropList!=null && prodProductPropList.size()>0){
				ProdProductProp prodProductProp = prodProductPropList.get(0);
				String propValue = prodProductProp.getPropValue();
				if(StringUtils.isNotBlank(propValue)){
					//套餐包含门票选项
					if(propValue.indexOf("343")!=-1){
						isNeedPackTicket = true;
					}
				}
			}	
		}
		ResultMessage resultMessage = new ResultMessage("error", "该套餐还未设置酒店或门票商品信息，您确定要设置为有效？");
		
		//酒店套餐产品中套餐包含信息必选酒店
		List<ProdPackageHotelCombDetailVO> hotelDetailList = new ArrayList<ProdPackageHotelCombDetailVO>();
		List<ProdPackageHotelCombHotelVO> hotelGroupList = prodPackageHotelCombHotelService.findProdPackageHotelCombHotelBySuppGoodsId(suppGoodsId, false);
		if(hotelGroupList==null|| hotelGroupList.size()<=0){
			return resultMessage; 
		}
		for(ProdPackageHotelCombHotelVO hotelGroup :hotelGroupList ){
			List<ProdPackageHotelCombDetailVO> packageHotelList = prodPackageHotelCombDetailService.findProdPackageHotelCombDetailByGroupId(hotelGroup.getHotelGroupId(), null,ProdPackageDetail.OBJECT_TYPE_DESC.PROD_BRANCH.name(), false);
			hotelDetailList.addAll(packageHotelList);
			if(hotelDetailList==null || hotelDetailList.size()<=0 ){
				return resultMessage; 
			}
		
		}
		
		//酒店套餐产品信息中套餐包含中勾选了门票选项
		if(isNeedPackTicket){
			List<ProdPackageHotelCombDetailVO> ticketDetailList = new ArrayList<ProdPackageHotelCombDetailVO>();
			List<ProdPackageHotelCombTicketVO> ticketGroupList = prodPackageHotelCombTicketService.findProdPackageHotelCombTicketBySuppGoodsId(suppGoodsId,false);
			if(ticketGroupList==null|| ticketGroupList.size()<=0){
				return resultMessage; 
			}
			for(ProdPackageHotelCombTicketVO ticketGroup :ticketGroupList ){
				
				List<ProdPackageHotelCombDetailVO> packageTicketList = prodPackageHotelCombDetailService.findProdPackageHotelCombDetailByGroupId(ticketGroup.getTicketGroupId(), null,ProdPackageDetail.OBJECT_TYPE_DESC.SUPP_GOODS.name(), false);
				ticketDetailList.addAll(packageTicketList);
				if(ticketDetailList==null || ticketDetailList.size()<=0 ){
					return resultMessage; 
				}
			
			}
			
			
		}
		return new ResultMessage("success", "校验通过");
		
	}
	
	
	/**
	 * 校验酒店插入时间冲突
	 * @param dbStayDaysArr
	 * @param formStayDaysArr
	 * @return
	 */
	public boolean validateGroupTimeIsConflict(String[] dbStayDaysArr,String[] formStayDaysArr){
		if(dbStayDaysArr!=null && dbStayDaysArr.length>0 &&  formStayDaysArr!=null && formStayDaysArr.length>0){
			List<Long> formStayDayList = new ArrayList<Long>();
			List<Long> dbStayDaysList = new ArrayList<Long>();
			for(int i=0;i<formStayDaysArr.length;i++){
				if(!StringUtils.isNumeric(formStayDaysArr[i])){
					throw new BusinessException("参数错误");
				}else{
					formStayDayList.add(Long.valueOf(formStayDaysArr[i])) ;
				}
			}
			
			for(int i=0;i<dbStayDaysArr.length;i++){
				if(!StringUtils.isNumeric(dbStayDaysArr[i])){
					throw new BusinessException("参数错误");
				}else{
					dbStayDaysList.add(Long.valueOf(dbStayDaysArr[i]));
				}
			}
			//获取两个组,分别取两组的最大值和最小值,获取两组时间时间的交集
			if(formStayDayList.size()>0 && dbStayDaysList.size()>0 ){
				Long formMax = Collections.max(formStayDayList);
				Long formMin = Collections.min(formStayDayList);
				Long dbMax =  Collections.max(dbStayDaysList);
				Long dbMin =  Collections.min(dbStayDaysList);
				//1,3  2,4   3>=2 && 1<=4 存在交集 
				if(formMax >= dbMin && formMin<=dbMax){
					return true;
				}
			}else{
				throw new BusinessException("参数错误");
			}
		
		}else{
			throw new BusinessException("参数错误");
		}
		return false;
	}
	
	
	
	/**
	 * 门票品类
	 * @param selectCategoryId
	 * @return
	 */
	public boolean isTickectCategory(Long  selectCategoryId){
		
		if(selectCategoryId !=null){
		if(Constant.VST_CATEGORY.getCodeListByCategoryId(String.valueOf(Constant.VST_CATEGORY.CATEGORY_TICKET.getCategoryId())).indexOf(Constant.VST_CATEGORY.CATEGORY_TICKET.getCodeByCategoryId(String.valueOf(selectCategoryId)))!=-1){
			
			return true;
		}
		
		if(Constant.VST_CATEGORY.CATEGORY_TICKET.getCategoryId().equals(String.valueOf(selectCategoryId))){
			
			return true;
		}
		
		}
		
		return false;

	}
	
	
	/**
	 * 酒店品类
	 * @param selectCategoryId
	 * @return
	 */
	
	public boolean isHotelCategory(Long selectCategoryId){
		if(selectCategoryId !=null){
			
		if(Constant.VST_CATEGORY.CATEGORY_HOTEL.getCategoryId().equals(String.valueOf(selectCategoryId))){
			
			return true;
		}
		
		}
		return false;

	}
	
	/**联想补全产品名称
	 * bizCategoryId品类id
	 * @param search
	 * @param res
	 * @param resp
	 */
	@RequestMapping(value = "/seachProductList")
	@ResponseBody
	public void seachProductList(String search,HttpServletRequest res, HttpServletResponse resp){
		if (log.isDebugEnabled()) {
			log.debug("start method<seachProductList>");
		}
		Map<String, Object> parameters = new HashMap<String, Object>();
		String bizCategoryId = res.getParameter("bizCategoryId");
		JSONArray array = new JSONArray();
		if(StringUtils.isNumeric(bizCategoryId)&&StringUtils.isNotBlank(search)){
			Long categoryId = Long.valueOf(bizCategoryId);
			parameters.put("bizCategoryId", categoryId);
			parameters.put("productName", search);
			parameters.put("_start", 0);
			parameters.put("_end",20);
			//获取当前品类组下可打包的规格或商品
			//list = prodPackageHotelCombDetailService.selectHotelCommbCanPackegeProductListByparams(parameters);
			List<ProdProduct> productList = prodProductHotelAdapterService.findProdProductList(parameters, false);
				if (productList != null && productList.size() > 0) {
					for (ProdProduct prodProduct : productList) {
						if(prodProduct!=null){
							JSONObject obj = new JSONObject();
							obj.put("id",prodProduct.getProductId());
							obj.put("text",prodProduct.getProductName());
							array.add(obj);
							
						}
						
					}
				}
				
		}
	
		JSONOutput.writeJSON(resp, array);
	}
	
	
	
	
	/**
	 * 根据酒店和门票类型生成添加组日志
	 * @param prodPackageGroup
	 * @param prodLineRoute 行程
	 * @return
	 */
	public String getPackGroupAddLog(Object prodPackageGroup,ProdLineRoute prodLineRoute){

		if(prodPackageGroup!=null){
			StringBuffer sb = new StringBuffer();
			String tempStr =""; 
			String[] staysDay =null;
			//酒店
			if(prodPackageGroup instanceof ProdPackageHotelCombHotel){
				ProdPackageHotelCombHotel prodPackageHotelCombHotel = (ProdPackageHotelCombHotel)  prodPackageGroup;
				sb.append(ComLogUtil.getChangeLog("组ID", null,String.valueOf(prodPackageHotelCombHotel.getHotelGroupId())));
				sb.append(ComLogUtil.getChangeLog("组品类", null,Constant.VST_CATEGORY.CATEGORY_HOTEL.getCnName()));
				sb.append(ComLogUtil.getChangeLog("行程", null,prodLineRoute.getRouteName()));
				  		
				staysDay = prodPackageHotelCombHotel.getStayDays().split(",");
					if( staysDay!=null  && staysDay.length==1 ){
						tempStr="第"+staysDay[0]+"晚";
					}else if(staysDay!=null && staysDay.length>1){
						tempStr="第"+staysDay[0]+"-"+staysDay[staysDay.length-1]+"晚";
					}
					sb.append(ComLogUtil.getChangeLog("入住晚数", null,tempStr));
					sb.append(ComLogUtil.getChangeLog("备注信息", null,prodPackageHotelCombHotel.getReMark()));
			//门票	
			}else if(prodPackageGroup instanceof ProdPackageHotelCombTicket){
				
				ProdPackageHotelCombTicket prodPackageHotelCombTicket = (ProdPackageHotelCombTicket)  prodPackageGroup;
				sb.append(ComLogUtil.getChangeLog("组ID", null,String.valueOf(prodPackageHotelCombTicket.getTicketGroupId())));
				sb.append(ComLogUtil.getChangeLog("组品类", null,Constant.VST_CATEGORY.getCnNameByStatus(String.valueOf(prodPackageHotelCombTicket.getCategoryId()))));
				sb.append(ComLogUtil.getChangeLog("行程", null,prodLineRoute.getRouteName()));
				staysDay = prodPackageHotelCombTicket.getStayDays().split(",");
					if(staysDay!=null && staysDay.length>0){
						
						for(int i =0;i<staysDay.length;i++ ){
							tempStr += staysDay[i];
							if(i!=staysDay.length-1){
								tempStr += ",";
							}
						}
						
					}
				sb.append(ComLogUtil.getChangeLog("游玩日期", null,"第"+tempStr+"天"));
				sb.append(ComLogUtil.getChangeLog("备注信息", null,prodPackageHotelCombTicket.getReMark()));
				
			}
			return sb.toString();
		
		}
		return "";
		
	}
	
	/**
	 * 获取删除酒店规格、门票商品打包关联信息日志
	 * @param hotelCombDetailId 关系信息ID
	 * @param categoryId 品类ID
	 * @param suppGoodsId 酒店套餐商品ID
	 * @return
	 */
	private String getDeletePackGroupDetail(Long hotelCombDetailId,Long categoryId){
		StringBuilder logStr = new StringBuilder();
		ProdPackageHotelCombDetail dto = prodPackageHotelCombDetailService.findProdPackageHotelCombDetailById(hotelCombDetailId);
		if(null!=dto){
			String objectType = ProdPackageDetail.OBJECT_TYPE_DESC.getCnName(dto.getObjectType());
			logStr.append("组ID:["+dto.getHotelCombGroupId()+"],");
			logStr.append("品类:["+Constant.VST_CATEGORY.getCnNameByStatus(categoryId+"")+"]")
				.append(",打包类型:["+objectType).append("],"+objectType+"ID:[").append(dto.getObjectId()+"]");
		}
		return logStr.toString();
	}
	
}
