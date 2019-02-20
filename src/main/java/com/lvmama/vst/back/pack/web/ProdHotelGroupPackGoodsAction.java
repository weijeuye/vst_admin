package com.lvmama.vst.back.pack.web;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.bridge.utils.hotel.DestHotelAdapterUtils;
import com.lvmama.vst.back.biz.po.BizCategoryProp;
import com.lvmama.vst.back.biz.po.BizDict;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsHotelAdapterClientService;
import com.lvmama.vst.back.client.prod.service.ProdPackageDetailClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductBranchAdapterClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.pack.data.ProdPackageDetailGoodsData;
import com.lvmama.vst.back.pack.data.ProdProductGoodsBranchData;
import com.lvmama.vst.back.pack.service.ProdHotelGroupPackGoodsService;
import com.lvmama.vst.back.pack.service.ProdHotelGroupPackGoodslAdapterService;
import com.lvmama.vst.back.pack.service.ProdPackageDetailGoodsService;
import com.lvmama.vst.back.pack.vo.ProdPackageDetailGoodsVO;
import com.lvmama.vst.back.pack.vo.ProdProductGoodsBranchVO;
import com.lvmama.vst.back.prod.comm.query.service.ProdEsQueueService;
import com.lvmama.vst.back.prod.po.ProdPackageDetail;
import com.lvmama.vst.back.prod.po.ProdPackageGroup;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductBranch;
import com.lvmama.vst.back.prod.po.ProdProductProp;
import com.lvmama.vst.back.prod.po.ProdProductSaleRe;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.pub.service.PushAdapterService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.back.utils.MsgFactory;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.pet.adapter.PetMessageServiceAdapter;

@Controller
@RequestMapping("/productPack/hotel")
public class ProdHotelGroupPackGoodsAction extends BaseActionSupport {
	
	private static final long serialVersionUID = 9101717380199220419L;
	
	/**
	 * 获得产品规格列表
	 */
	@Autowired
	private ProdProductBranchAdapterClientService prodProductBranchAdapterService;
	

	@Autowired
	private SuppGoodsHotelAdapterClientService suppGoodsHotelAdapterService;
	
	
	@Autowired
	private ProdHotelGroupPackGoodslAdapterService prodHotelGroupPackGoodslAdapterService;//1
	
	@Autowired
	private ProdHotelGroupPackGoodsService prodHotelGroupPackGoodsService;//2
	/**
	 * 操作日志记录
	 */
	@Autowired
	private ComLogClientService comLogService;
	

	/**
	 * 规格和组关联关系
	 */
	@Autowired
	private ProdPackageDetailClientService prodPackageDetailService;
	
	//获取已经打包的商品
	@Autowired
	private ProdPackageDetailGoodsService prodPackageDetailGoodsService;//3
	//获取商品信息 
	@Autowired
	private SuppGoodsClientService suppGoodsService;
	
	@Autowired
	private DestHotelAdapterUtils destHotelAdapterUtils;
	
	//数据推送
	@Autowired
	private PushAdapterService pushAdapterService;//5
	@Autowired
	private ProdProductClientService prodProductService;
	
	@Autowired
	private PetMessageServiceAdapter petMessageService;//6

//	@Resource(name="productProducerProxy")
//	private SimpleProducterProxy productProducerProxy;
	
	@Autowired
	ProdEsQueueService prodEsQueueService;

	/**
	 * 将酒店商品打包到相应的规格
	 * @param vo
	 * @param groupType
	 * @param selectCategoryId
	 * @param request
	 * @return
     * @throws Exception
     */
	@RequestMapping(value = "/addGoodsToBranch")
	@ResponseBody
	public Object addGoodsToBranch(ProdPackageDetailGoodsVO vo,String groupType,Long selectCategoryId, HttpServletRequest request) throws Exception {
		Map<String, Object> attributes = new HashMap<String, Object>();
		Map<String, Object> detailIdparams = new HashMap<String, Object>();
		Long groupId=(long) 0;
		//用来存放已经打包的商品id
		ArrayList<String> packageedSuppGoodsIdList = new ArrayList<String>(); 
		//用来存放将要打包的商品id
		ArrayList<String> willPackageSuppGoodsIdList = new ArrayList<String>();
		//需要推送的商品id
		ArrayList<Long> goodsIdList = new ArrayList<Long>(); 
		//查询该规格下面已经打包的商品
		List<ProdPackageDetailGoodsData> ProdPackageDetailGoodsList=null;
		ProdPackageDetail prodPackageDetail=null;
		String detailId = request.getParameter("detailId");
		 //要打包的酒店商品id
	    String values=request.getParameter("key");
	  //第一次打包，标记页面上所有商品id，为了记录去打包日志用
		String allIds=request.getParameter("jsonAllId");
		JSONArray jsonAllIds = JSONArray.fromObject(allIds);
	    StringBuffer goodsIdString = new StringBuffer();
		JSONArray jsonArray = JSONArray.fromObject(values);
		//自由行产品，在基础信息勾选了“驴色飞扬自驾”，且设置售卖方式为按人售卖，同时设置了儿童价后在打包门票时，若门票票种含儿童票则无法打包
		if(jsonArray!=null && jsonArray.size()>0){
			StringBuffer str=new StringBuffer();
			for (int i = 0; i < jsonArray.size(); i++) {
				str.append(jsonArray.get(i)).append(",");
			}
			String suppGoodsIddStr=str.toString();
			String[] allSuppGoodsIddArr=suppGoodsIddStr.split(",");
			List<Long> suppGoodsIddList=new ArrayList<Long>(); 
			for (int i = 0; i < allSuppGoodsIddArr.length; i++) {
				suppGoodsIddList.add(Long.parseLong(allSuppGoodsIddArr[i]));
			}
			List<SuppGoods> suppGoods=MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsByIdList(suppGoodsIddList));
			for (int i = 0; i < suppGoods.size(); i++) {
				if (suppGoods.get(i) != null) {
					if("CHILDREN".equals(suppGoods.get(i).getGoodsSpec()) &&   isLvseAndChildPriceType(vo.getGroupProductId())){
						//产品售卖类型为：按人卖    &&  儿童价为固定价    并且勾选了  驴色飞扬自驾   并且打包的门票包含儿童票
						return new ResultMessage("error", "本产品已设置了儿童价，不能打包儿童规格的门票，请重新设置！");
					};
				}
				
			}
		}
		if(detailId==null || detailId=="") {
			return new ResultMessage("error", "detailId不能为空！");
		}else if(StringUtil.isNotEmptyString(detailId)) {
			detailIdparams.put("detailId", Long.valueOf(detailId));
			ProdPackageDetailGoodsList = prodPackageDetailGoodsService.selectPackagedGoodsByParams(detailIdparams);
			prodPackageDetail = prodPackageDetailService.selectByPrimaryKey(Long.valueOf(detailId));
		}
		if(CollectionUtils.isNotEmpty(ProdPackageDetailGoodsList)) {
			for(int j = 0 ; j< ProdPackageDetailGoodsList.size();j++) {
				ProdPackageDetailGoodsData detailDataBean = ProdPackageDetailGoodsList.get(j);
				//数据库中已经绑定的商品id
				if(detailDataBean!=null) {
					Long suppGoodsIdValue = detailDataBean.getSuppGoodsId();
					packageedSuppGoodsIdList.add(String.valueOf(suppGoodsIdValue));
				}
			}
		}		  
		//通过循环将没有打包的数据打包到自主绑定数据库
		for (int i = 0; i < jsonArray.size(); i++) {
		    ProdPackageDetailGoodsVO prodPackageDetailGoodsVO = new ProdPackageDetailGoodsVO();
			   //前端页面需要绑定的商品id
		        String suppGoodsId = (String) jsonArray.get(i);
		       //将推送的商品id收集
				goodsIdList.add(Long.parseLong(suppGoodsId));
		        willPackageSuppGoodsIdList.add(suppGoodsId);
		        //如何返回true 表示该商品在数据库中已经绑定，  如果返回false则表示数据库中没有绑定该商品
		        Boolean result = isInList(suppGoodsId,packageedSuppGoodsIdList);
		        //如果数据库中没有绑定该商品则在数据库中进行新增
		        if(!result){
		        	if(prodPackageDetail!=null){
		        		prodPackageDetailGoodsVO.setGroupId(prodPackageDetail.getGroupId());
		        	}
		        	prodPackageDetailGoodsVO.setDetailId(Long.parseLong(detailId));
					prodPackageDetailGoodsVO.setSuppGoodsId(Long.parseLong(suppGoodsId));
					prodPackageDetailGoodsVO.setCreateTime(new Date());
					//商品打包到自主打包数据表
					prodPackageDetailGoodsService.addGoodsBranch(prodPackageDetailGoodsVO);
				}	
	    }
		//将已经打包但不需要打包的商品在PROD_PACKAGE_DETAIL_GOODS中删除
		String deleteSuppIdForLog = "";
		if(CollectionUtils.isNotEmpty(packageedSuppGoodsIdList)) {
			for(int k=0;k<packageedSuppGoodsIdList.size();k++) {
				Map<String, Object> paramsValues = new HashMap<String, Object>();
				//数据库中已经打包的商品id
				String suppGoodsBean =packageedSuppGoodsIdList.get(k);
				paramsValues.put("suppGoodsId", suppGoodsBean);
				paramsValues.put("detailId", Long.valueOf(detailId));
				if(detailId!=null && detailId!="") {
					Boolean resultValue = isInList(suppGoodsBean,willPackageSuppGoodsIdList);
					if(!resultValue) {
						//将取消打包的商品删除
						prodPackageDetailGoodsService.deleteGoodsByParams(paramsValues);
						//记录删除打包商品的日志
						if(StringUtil.isEmptyString(deleteSuppIdForLog)){
							deleteSuppIdForLog =suppGoodsBean;
						}else{
							deleteSuppIdForLog +=","+suppGoodsBean;
						}
						
						
					}
				}

			}
		}else{
			if(jsonAllIds!=null&&jsonAllIds.size()>0){
        		for(int y=0 ; y < jsonAllIds.size() ; y++){
        			Boolean deleteFlag =true;
        			for (int i = 0; i < jsonArray.size(); i++) {
        				if(jsonAllIds.get(y).equals(jsonArray.get(i))){
        					deleteFlag =false;
            				break;
            			}
        			}
        			if(deleteFlag){
        				if(StringUtil.isEmptyString(deleteSuppIdForLog)){
        					deleteSuppIdForLog = (String) jsonAllIds.get(y);
						}else{
							deleteSuppIdForLog +=","+(String) jsonAllIds.get(y);
						}
        			}
        			
        		}
        	}
		}
		//数据推送
		try{
			if(prodPackageDetail!=null){
				Long groupIdValue = prodPackageDetail.getGroupId();
				//推送计算起价需要的数据到数据表  此处的产品id为组产品id
				Long groupProductId = vo.getGroupProductId();
				if(groupProductId!=null){
					ProdProduct routeProduct = MiscUtils.autoUnboxing(prodProductService.getProdProductBy(groupProductId));
					if(routeProduct!=null){
						if ("Y".equalsIgnoreCase(routeProduct.getMuiltDpartureFlag())) {
							pushAdapterService.push(groupProductId,
									ComPush.OBJECT_TYPE.PRODUCT,
									ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP,
									ComPush.OPERATE_TYPE.UP,
									ComIncreament.DATA_SOURCE_TYPE.TRANS_API_JOB);
						} else {
							pushAdapterService.push(groupProductId,
									ComPush.OBJECT_TYPE.PRODUCT,
									ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP,
									ComPush.OPERATE_TYPE.UP,
									ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
						}
						//获取有效的商品list(推送有效商品)
						if(CollectionUtils.isNotEmpty(goodsIdList)){
							int length = goodsIdList.size();
							for(int i=0;i<length;i++){
								Long suppGoodsId = goodsIdList.get(i);
								if(suppGoodsId != null){
									SuppGoods suppGoods= suppGoodsService.selectByPrimaryKey(suppGoodsId);
									if(suppGoods !=null){
										String cancelFlag = suppGoods.getCancelFlag();
										if("Y".equals(cancelFlag)){
											if(i==length-1){
												goodsIdString.append(suppGoodsId);
											}
											else if(i<length){
												goodsIdString.append(suppGoodsId+",");
											}
										}else if("N".equals(cancelFlag)){
											continue;
										}
									}
								}
							}
						}
						petMessageService.sendCommMessage(groupProductId, ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_PACKAGE_DETAIL_GOODS, groupIdValue+"|"+goodsIdString);
						//发消息给分销商
						long gropId = prodPackageDetail.getGroupId();
						ProdProduct prodProduct = MiscUtils.autoUnboxing(prodProductService.findProdProductById(groupProductId,null));
						if(prodProduct != null){
							this.handOut4BranchGoods(groupType,groupProductId,prodProduct.getBizCategoryId(),String.valueOf(gropId),
									String.valueOf(prodPackageDetail.getObjectId()));
						}
					}
				}
			}
		}catch(Exception e){
			//return new ResultMessage(attributes, "success", "商品打包成功!");
			throw new BusinessException("数据推送接口异常!"+e);
		}
		//添加操作日志
		addComLog(detailId,vo,jsonArray,deleteSuppIdForLog);
		attributes.put("detailIds", Long.valueOf(detailId));
		attributes.put("groupType", groupType);
		attributes.put("groupId", groupId);
		attributes.put("selectCategoryId", selectCategoryId);
		return new ResultMessage(attributes, "success", "商品打包成功!");
	}	
	
	@RequestMapping(value = "/showGoodsData.do")
	public String showGoodsData(ProdProductGoodsBranchVO vo,Integer page,HttpServletRequest request, Model model) throws Exception, Exception {
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
		  prodProductBranch = MiscUtils.autoUnboxing(prodProductBranchAdapterService.findProdProductBranchById(Long.valueOf(productBranchId)));
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
		String detailId = request.getParameter("detailId");
		String groupType = request.getParameter("groupType");
		districtIdparams.put("detailId",Long.valueOf(detailId));
		params.put("productBranchId",Integer.parseInt(productBranchId));
		params.put("groupType",groupType);
		model.addAttribute("productBranchId", productBranchId);
		model.addAttribute("productId", productId);
		model.addAttribute("categoryId", categoryId);
		model.addAttribute("detailId", detailId);
		model.addAttribute("groupType", groupType);
		model.addAttribute("onlineFlag", vo.getOnlineFlag());
		model.addAttribute("districtName", vo.getDistrictName());
		model.addAttribute("suppGoodsId", vo.getSuppGoodsId());
		model.addAttribute("goodsName", vo.getGoodsName());
		model.addAttribute("supplierName", vo.getSupplierName());
		
		//打包期票
		String groupProductId = request.getParameter("groupProductId");
		if(groupProductId != null){
			String productBu = getProdProductBu(Long.parseLong(groupProductId));
			if(StringUtils.equalsIgnoreCase(productBu, Constant.BU_NAME.DESTINATION_BU.getCode())){
				params.put("needAperiodFlag","Y");
				model.addAttribute("isDestinationBU", "Y");
			}
		}
		
		// 获取规格下商品总数
		int count = prodHotelGroupPackGoodslAdapterService.getTotalCount(params);
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(request);
		params.put("_start", pageParam.getStartRows());
		params.put("_end", pageParam.getEndRows());
		int systemLogicGoodsNum=0;
		params.put("noTeam", "Y");//过滤团体票
		//获取查询条件下该商品规格下的所有满足条件的酒店商品(分页商品)
		List<ProdProductGoodsBranchData> hotelGoodsList = prodHotelGroupPackGoodslAdapterService.selectHotelGoodsByParams(params);
		//获取查询条件下该商品规格下的所有满足条件的酒店商品(不分页商品)
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
				  SuppGoods suppGoods= MiscUtils.autoUnboxing(suppGoodsHotelAdapterService.findSuppGoodsById(suppGoodsId));
				  if ("TEAM".equals(suppGoods.getGoodsSpec())) {
					  systemLogicGoodsNum= systemLogicGoodsNum -1;
					  continue;
				}
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
	    //获取查询条件该规格下已经打包商品表中的数据
		  List<ProdPackageDetailGoodsData> ProdPackageDetailGoodsDataList = MiscUtils.autoUnboxing(suppGoodsHotelAdapterService.selectPackagedGoodsByParams(districtIdparams));
		  if(CollectionUtils.isNotEmpty(ProdPackageDetailGoodsDataList))
		{
			
			int length = ProdPackageDetailGoodsDataList.size();
			if(length>0)
			{
				whetherPackaged="true";
			}
			for(int i = 0;i < length; i ++)
			{
				ProdPackageDetailGoodsData goodsData= ProdPackageDetailGoodsDataList.get(i);
				if(goodsData != null)
				{
					Long suppGoodsId = goodsData.getSuppGoodsId();
					String cancelFlag = goodsData.getCancelFlag();
					String goodsName="";
					if(suppGoodsId != null)
					{
					SuppGoods suppGoods= MiscUtils.autoUnboxing(suppGoodsHotelAdapterService.findSuppGoodsById(suppGoodsId));
						if(suppGoods != null)
						{
							if ("TEAM".equals(suppGoods.getGoodsSpec())) {
							  continue;
							}else {
								goodsName = suppGoods.getGoodsName();
							}
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
		  List<ProdProductGoodsBranchData> resultList = new ArrayList<ProdProductGoodsBranchData>();
		  if (CollectionUtils.isNotEmpty(hotelGoodsList)) {
			//过滤团队票
			  for (ProdProductGoodsBranchData detailGoodsData : hotelGoodsList) {
				  SuppGoods suppGoods= MiscUtils.autoUnboxing(suppGoodsHotelAdapterService.findSuppGoodsById(detailGoodsData.getSuppGoodsId()));
				  if (!"TEAM".equals(suppGoods.getGoodsSpec())) {
					  resultList.add(detailGoodsData);
				}
			  }
		}
		pageParam.setItems(resultList);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("whetherPackaged", whetherPackaged);
		model.addAttribute("hotelOnLineFlag", String.valueOf(destHotelAdapterUtils.checkHotelSystemOnlineEnable()));
		return "/pack/hotel/showGoodsData";
	}
	
	/**
	 * 根据productId获取产品的BU
	 * @param productId 产品ID
	 * @return 产品的BU
	 */
	private String getProdProductBu(Long productId){
		ProdProduct prodProduct = null;
		if(productId != null){
			prodProduct = MiscUtils.autoUnboxing(prodProductService.getProdProductBy(productId));					
		}
		String bu = null;
		if(prodProduct != null){
			bu = prodProduct.getBu();
		}
		return bu;
	}
	
	//打开商品查询页面
	@RequestMapping(value = "/showProductGoodsForm.do")
	public String showProductGoodsForm(HttpServletRequest request,
			HttpServletRequest req, Integer page, Model model) throws Exception, Exception {
		ProdProductBranch prodProductBranch=null;
		String productBranchId = request.getParameter("productBranchId");
		//组产品id
		String groupProductId = request.getParameter("groupProductId");
		if(productBranchId!=null && productBranchId!="")
		{ 
		  prodProductBranch = MiscUtils.autoUnboxing(prodProductBranchAdapterService.findProdProductBranchById(Long.valueOf(productBranchId)));
		}
		
		if(prodProductBranch!=null)
		{
			String branchName = prodProductBranch.getBranchName();
			model.addAttribute("branchName", branchName);
		}
		String categoryId = request.getParameter("categoryId");
		String productId = request.getParameter("productId");
		String detailId = request.getParameter("detailId");
		String groupType = request.getParameter("groupType");
		String productBu = request.getParameter("productBu");
		model.addAttribute("groupProductId", groupProductId);
		model.addAttribute("productBranchId", productBranchId);
		model.addAttribute("productId", productId);
		model.addAttribute("categoryId", categoryId);
		model.addAttribute("detailId", detailId);
		model.addAttribute("groupType", groupType);
		model.addAttribute("productBu", productBu);
		return "/pack/hotel/showProductGoodsForm";
	}
	
	public Boolean isInList(String str,List<String> list)
	{
		if(list.contains(str))
		{
		   return true;
		}
		else
		{
		   return false;
		}
	}	
	public void addComLog(String detailId,ProdPackageDetailGoodsVO vo,JSONArray jsonArray,String deteleLog)
	{
		// 添加操作日志
		try {
			if(StringUtils.isNotEmpty(detailId))
			{		
				if(StringUtil.isNotEmptyString(deteleLog)){
					comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP,
							vo.getGroupProductId(),
							vo.getGroupProductId(),
							this.getLoginUserId(),
							"打包商品:打包DetailId: "+detailId+", 打包商品是:" + jsonArray.toString()+"去除打包的商品是："+deteleLog,
							COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP
									.name(), "将商品打包到规格", null);
				}else{
					comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP,
							vo.getGroupProductId(),
							vo.getGroupProductId(),
							this.getLoginUserId(),
							"打包商品:打包DetailId: "+detailId+", 打包商品是:" + jsonArray.toString(),
							COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT_GROUP
									.name(), "将商品打包到规格", null);
				}	        
			}
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"
					+ COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
			log.error(e.getMessage());
		}
	}

	/**
	 * 发消息给分销商
	 * @param productId 产品Id
	 * @param categoryId 品类Id
	 * @param groupId 打包组Id
	 * @param branchId 规格Id
     */
	private final void handOut4BranchGoods(String groupType,Long productId,long categoryId,String groupId,String branchId){
		if(ProdPackageGroup.GROUPTYPE.HOTEL.name().equalsIgnoreCase(groupType)){
			String msg = MsgFactory.get().
					create4PackGroup(productId,
							categoryId,
							ComPush.OBJECT_TYPE.PRODUCT.name(),
							ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP.name(),
							groupId,
							branchId,
							ComPush.PUSH_DETAIL.GROUP_BRANCH_GOODS_HOTEL.name(),
							ComPush.OPERATE_TYPE.UP.name());
			this.prodEsQueueService.handOut(msg);
		}else if (ProdPackageGroup.GROUPTYPE.LINE_TICKET.name().equalsIgnoreCase(groupType)) {
			String msg = MsgFactory.get().
					create4PackGroup(productId,
							categoryId,
							ComPush.OBJECT_TYPE.PRODUCT.name(),
							ComPush.PUSH_CONTENT.PROD_PACKAGE_GROUP.name(),
							groupId,
							branchId,
							ComPush.PUSH_DETAIL.GROUP_BRANCH_GOODS_TICKET.name(),
							ComPush.OPERATE_TYPE.UP.name());
			this.prodEsQueueService.handOut(msg);
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

}