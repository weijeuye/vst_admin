package com.lvmama.vst.back.pub.web;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.comm.utils.web.HttpServletLocalThread;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.prod.service.ProdDestReClientService;
import com.lvmama.vst.back.client.prod.service.ProdPackageGroupClientService;
import com.lvmama.vst.back.client.prod.service.ProdPackageHotelCombDistributionClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductPropClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.pub.service.ComPhotoClientService;
import com.lvmama.vst.back.prod.po.ProdProductProp;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComPhoto;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.pub.service.PushAdapterServiceRemote;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.MemcachedEnum;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

@Controller
@RequestMapping("/pub/comphoto")
public class ComPhotoCommonAction extends BaseActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 8188210046359250229L;
	
	@Autowired
	private ComPhotoClientService comPhotoClientService;
	@Autowired
	private ComLogClientService comLogService;

	@Autowired
	private ProdProductClientService prodProductService;

	@Autowired
	private SuppGoodsClientService suppGoodsService;

	@Autowired
	private ProdProductPropClientService prodProductPropService;
	@Autowired
	PushAdapterServiceRemote pushAdapterService;

	@Autowired
	private ProdDestReClientService prodDestReService;

	@Autowired
	private ProdPackageHotelCombDistributionClientService prodPackageHotelCombHotelService;
	//private ProdPackageHotelCombHotelService prodPackageHotelCombHotelService;

	@Autowired
	private ProdPackageHotelCombDistributionClientService prodPackageHotelCombTicketService;
	//ProdPackageHotelCombTicketService prodPackageHotelCombTicketService;


	@Autowired
	private ProdPackageGroupClientService prodPackageGroupService;

	/**
	 * 
	 * @param model
	 * @param objectType
	 * @param objectId
	 * @param parentId
	 * @param logType
	 * @param minNum 上传照片最少张数
	 * @param maxNum 上传照片最多张数
	 * @return
	 */
	@RequestMapping(value = "/findComPhotoList")
	public String findComPhotoList(Model model, String objectType, Long objectId,Long parentId,String logType, String minNum, String maxNum, String imgLimitType) {
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("objectId", objectId);
		parameters.put("objectType", objectType);
		parameters.put("_orderby", "photo_seq");
		parameters.put("_order", "asc");
		List<ComPhoto> comPhotoList = MiscUtils.autoUnboxing( comPhotoClientService.findImageList(parameters) );	
		
		List<ComPhoto> list32 = new ArrayList<ComPhoto>();		
		List<ComPhoto> list52 = new ArrayList<ComPhoto>();
		//比例标识：1(3:2)；2(5:2)
		for(ComPhoto photo: comPhotoList){
			if(photo.getRatio().equals(1)){
				list32.add(photo);
			}else{
				list52.add(photo);
			}
		}		
		model.addAttribute("list32", list32);
		model.addAttribute("list52", list52);
		model.addAttribute("objectId", objectId);
		model.addAttribute("objectType", objectType);
		model.addAttribute("parentId", parentId);
		model.addAttribute("logType", logType);
		
		model.addAttribute("minNum", minNum );
		model.addAttribute("maxNum", maxNum );
		model.addAttribute("userName", this.getLoginUser().getUserName());
		
		String scheme = HttpServletLocalThread.getRequest().getScheme();
		String serverName = HttpServletLocalThread.getRequest().getServerName();
		int serverPort = HttpServletLocalThread.getRequest().getServerPort();
		
		model.addAttribute("scheme", scheme);
		model.addAttribute("serverName", serverName);
		model.addAttribute("serverPort", serverPort);
		
		model.addAttribute("requestURL", scheme + "://" + serverName + ":" + serverPort);
		model.addAttribute("typeList", ComPhoto.PHOTO_TYPE.values());
		model.addAttribute("imgLimitType", imgLimitType);
		
		//查询产品酒店类型
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("productId",objectId);
		params.put("propId", 20);
		List<ProdProductProp> result = MiscUtils.autoUnboxing( prodProductPropService.findProdProductPropList(params) );
		if(result != null && result.size()>0){
			model.addAttribute("hotelType",result.get(0).getPropValue());
		}else{
			model.addAttribute("hotelType",0);
		}

		//add by yangzhenzhong BU是目的地下的景+酒产品（酒店套餐，自由行中的景+酒）,新增图片同步功能，添加图片同步按钮
		boolean synchronizePhoto;
		ProdProduct product = MiscUtils.autoUnboxing( prodProductService.getProdProductBy(objectId) );
		if(product!=null){
			Long categoryId = product.getBizCategoryId();
			Long subCategoryId = product.getSubCategoryId();
			String bu;
			if((categoryId!=null && subCategoryId!=null && categoryId==18L && subCategoryId==181L) ||(categoryId!=null &&categoryId==17L)){
				bu=product.getBu();
				if(bu==null){
					List<SuppGoods> suppGoodsList= MiscUtils.autoUnboxing( suppGoodsService.findSuppGoodsByProductId(objectId) );
					if(suppGoodsList!=null && suppGoodsList.size()>0){
						SuppGoods suppGoods=suppGoodsList.get(0);
						bu=suppGoods.getBu();
					}
				}
				synchronizePhoto= (bu!=null&&bu.equalsIgnoreCase("DESTINATION_BU"))?true:false;
				model.addAttribute("synchronizePhoto", synchronizePhoto);
			}
			
			model.addAttribute("categoryId", categoryId);
			model.addAttribute("subCategoryId", subCategoryId);
			
		}
		
		//智能货架大图
		if(StringUtils.isNotBlank(objectType)&&"PRODUCT_ID_WIRELESS".equalsIgnoreCase(objectType)){
			model.addAttribute("listWireless", comPhotoList);
			return "/pub/comphoto/findComPhotoWirelessList";
		}
		return "/pub/comphoto/findComPhotoList";
	}
	
	
	@RequestMapping(value="/isQuoteProductId")
	@ResponseBody
	public Object isQuoteProductId(ModelMap model, String quoteProductId,Long objectId) {
		Map<String, Object> parameters = new HashMap<String, Object>();
		List<ComPhoto> comPhotoList = new ArrayList<ComPhoto>();
		
		parameters.put("objectId", quoteProductId);
		parameters.put("objectType", "PRODUCT_ID");
		parameters.put("_orderby", "photo_seq");
		parameters.put("_order", "asc");
		comPhotoList = MiscUtils.autoUnboxing( comPhotoClientService.findImageList(parameters) );	
		if(comPhotoList.size() <= 0){
			return new ResultMessage("error", "失败！");
		}else{
			parameters.put("objectId", objectId);
			parameters.put("objectType", "PRODUCT_ID");
			parameters.put("_orderby", "photo_seq");
			parameters.put("_order", "asc");
			comPhotoList = new ArrayList<ComPhoto>();
			comPhotoList = MiscUtils.autoUnboxing( comPhotoClientService.findImageList(parameters) );	
			
			//循环删除原产品图片特色
			for(ComPhoto comPhoto : comPhotoList){
				comPhotoClientService.deleteByPK(comPhoto.getPhotoId());
			}
			
			parameters.clear();
			parameters.put("objectId", quoteProductId);
			parameters.put("objectType", "PRODUCT_ID");
			parameters.put("_orderby", "photo_seq");
			parameters.put("_order", "asc");
			comPhotoList = new ArrayList<ComPhoto>();
			comPhotoList = MiscUtils.autoUnboxing( comPhotoClientService.findImageList(parameters) );	
			for(ComPhoto comPhoto : comPhotoList){
				ComPhoto cp = new ComPhoto();
				cp.setPhotoUrl(comPhoto.getPhotoUrl());
				cp.setPhotoContent(comPhoto.getPhotoContent());
				cp.setPhotoDisplay(comPhoto.getPhotoDisplay());
				cp.setPhotoSeq(comPhoto.getPhotoSeq());
				cp.setObjectId(objectId);
				cp.setObjectType("PRODUCT_ID");
				cp.setLastUpdateTime(comPhoto.getLastUpdateTime());
				cp.setFileId(comPhoto.getFileId());
				cp.setRatio(comPhoto.getRatio());
				cp.setSource(comPhoto.getSource());
				cp.setQuondamPhotoContent(comPhoto.getQuondamPhotoContent());
				comPhotoClientService.insert(cp);
			}
			return new ResultMessage("success", "成功！");
		}
		
	}
	
	
	@RequestMapping(value="/showQuoteProductForm")
	public String showQuoteProductForm(Model model,String objectId) throws BusinessException{
		model.addAttribute("objectId", objectId);
		return "/pub/comphoto/quoteProduct";
	}
	
	@RequestMapping(value = "/showAddComPhoto")
	public String showAddComPhoto(Model model, String objectType, Long objectId,Long parentId,String logType) {
		model.addAttribute("objectId", objectId);
		model.addAttribute("parentId", parentId);
		model.addAttribute("objectType", objectType);
		model.addAttribute("logType", logType);
		model.addAttribute("typelist", ComPhoto.PHOTO_TYPE.values());
		model.addAttribute("picUrl", "");
		return "/pub/comphoto/showAddComPhoto";
	}
	@RequestMapping(value = "/showComPhotoByPhotoId")
	public String showComPhotoByPhotoId(Model model, Long id) {
		model.addAttribute("photo", MiscUtils.autoUnboxing( comPhotoClientService.selectByPrimaryKey(id) ));
		return "/pub/comphoto/showComPhotoByPhotoId";
	}
	@RequestMapping(value = "/upload")
	public Object upload(Model model, MultipartFile file, HttpServletRequest req, HttpServletResponse res) {
		ResultMessage result = ResultMessage.createResultMessage();
		File tmpFile = new File("/tmp/photo/"+file.getOriginalFilename());
		try {
			File f = new File("/tmp/photo/");
			if(!f.exists()){
				f.mkdirs();
			}
			file.transferTo(tmpFile);
			String url = tmpFile.getAbsolutePath();
			ResultHandleT<String[]> loadresult = comPhotoClientService.uploadPhoto(url);
			if(loadresult.isFail()) {
				result.setCode(ResultMessage.ERROR);
				result.setMessage(loadresult.getMsg());
				this.sendAjaxMsg(JSONObject.fromObject(result).toString(), req, res);
				return null;
			} else {
				result.addObject("photoUrl", loadresult.getReturnContent());
			}
		} catch (Exception e) {
			log.error(ExceptionFormatUtil.getTrace(e));
			result.setCode(ResultMessage.ERROR);
			result.setMessage(e.getMessage());
		} finally{
			tmpFile.deleteOnExit();
		}
		this.sendAjaxMsg(JSONObject.fromObject(result).toString(), req, res);
		return null;
	}
	@RequestMapping(value = "/addComPhoto")
	@ResponseBody
	public Object addComPhoto(Model model, ComPhoto photo,Long parentId,String logType) {
		Long objectId = photo.getObjectId();
		String objectType = photo.getObjectType();
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("objectId", objectId);
		parameters.put("objectType", objectType);
		List<ComPhoto> list = MiscUtils.autoUnboxing( comPhotoClientService.findImageList(parameters) );
		if(list != null && !list.isEmpty()){
			photo.setPhotoSeq(Long.valueOf(list.size() + 1));
		}else{
			photo.setPhotoSeq(1L);
		}
		
		photo.setLastUpdateTime(new Date());
		
		photo.setPhotoDisplay(ComPhoto.PHOTO_DISPLAY.SHOW.toString());

		//Added by yangzhenzhong 添加图片来源 manual:手动添加
		photo.setSource("manual");

		comPhotoClientService.insert(photo);
		
		if(objectType.equalsIgnoreCase("PRODUCT_ID")){
			pushAdapterService.push(objectId, ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.COM_PHOTO,ComPush.OPERATE_TYPE.ADD, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
			MemcachedUtil.getInstance().remove(MemcachedEnum.ProductComPhotoList.getKey()+parentId);
		}
		MemcachedUtil.getInstance().remove(MemcachedEnum.ComPhotoList.getKey()+objectType+objectId);
		
		if (null != logType && !"".equals(logType)) {
			//添加操作日志
			try {
				comLogService.insert(COM_LOG_LOG_TYPE.getParentByCode(logType),
						parentId, photo.getObjectId(), this.getLoginUser()
								.getUserName(),
						"添加了图片，图片ID为：" + photo.getPhotoId(), logType, "添加产品图片",
						null);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				log.debug("Record Log failure ！Log Type:" + logType);
			}
		}
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}
	
	/**
	 * 保存从图库操作的图片JSON数据
	 * @param model
	 * @param photo
	 * @param parentId
	 * @param logType
	 * @return
	 */
	@RequestMapping(value = "/addBatchComPhoto")
	@ResponseBody
	public Object addBatchComPhoto(Model model, String photoJson, String objectType, Long objectId, Long parentId,String logType) {
		if(StringUtil.isNotEmptyString(photoJson) 
				&& StringUtil.isNotEmptyString(objectType) && objectId != null	){
			Map<String, Object> parameters = new HashMap<String, Object>();
			parameters.put("objectId", objectId);
			parameters.put("objectType", objectType);
			
			List<ComPhoto> dbList = MiscUtils.autoUnboxing( comPhotoClientService.findImageList(parameters) );
			int dbPhotoSize = 0;
			if(dbList != null ){
				dbPhotoSize = dbList.size();
			}
			
			List<ComPhoto> photoList = this.jsonToList(ComPhoto.class, photoJson);
			if(photoList == null || photoList.size() <= 0) {
				return new ResultMessage("error", "缺少图片列表");
			}
//			JSONObject jsonObject = JSONObject.fromObject(photoJson);
//	        ComPhoto photo = (ComPhoto) JSONObject.toBean(jsonObject, ComPhoto.class);
			StringBuilder ids= new StringBuilder();
			for (ComPhoto photo : photoList) {
				photo.setPhotoSeq(Long.valueOf(dbPhotoSize + 1));
				photo.setLastUpdateTime(new Date());
				photo.setObjectType(objectType);
				photo.setObjectId(objectId);
				photo.setPhotoDisplay(ComPhoto.PHOTO_DISPLAY.SHOW.toString());
				//Added by yangzhenzhong 添加图片来源 manual:手动添加
				photo.setSource("manual");
				comPhotoClientService.insert(photo);
				ids.append(photo.getPhotoId()).append(",");
			}
			removeCacheAndSendMsg(parentId, objectId, objectType, logType, "添加图片");
		}else{
			return new ResultMessage("error", "参数【objectId=" + objectId + ";objectType=" + objectType + ";parentId=" + parentId + ";logType=" + logType + ";】传递错误");
		}
		
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}
	
	@RequestMapping(value = "/deleteComPhoto")
	@ResponseBody
	public Object deleteComPhoto(Model model, Long id,Long parentId,String logType) {
		ComPhoto photo = MiscUtils.autoUnboxing( comPhotoClientService.selectByPrimaryKey(id) );
		comPhotoClientService.deleteByPK(id);
		removeCacheAndSendMsg(parentId, photo.getObjectId(), photo.getObjectType(), logType, "删除了图片");
		return ResultMessage.DELETE_SUCCESS_RESULT;
	}
	
	@RequestMapping(value = "/batchDeleteComPhoto")
	@ResponseBody
	public Object batchDeleteComPhoto(Model model,String photoIds,Long parentId,String logType){
		if(StringUtil.isNotEmptyString(photoIds)){
			String [] photoIdArray= photoIds.split(",");
			if(null !=photoIdArray && photoIdArray.length>0){
				for (String photoId : photoIdArray) {
					ComPhoto photo = MiscUtils.autoUnboxing( comPhotoClientService.selectByPrimaryKey(Long.valueOf(photoId)) );
					comPhotoClientService.deleteByPK(Long.valueOf(photoId));
					removeCacheAndSendMsg(parentId, photo.getObjectId(), photo.getObjectType(), logType, "删除了图片");
				}
			}
		}
		return ResultMessage.DELETE_SUCCESS_RESULT;
	}

	/**
	 * Created by yangzhenzhong
	 * @param model
	 * @param parentId
	 * @param logType
	 * @param objectId
	 * @param objectType
	 * @param ratio
	 * @return
	 */
	@RequestMapping(value = "/synchronizePhoto")
	@ResponseBody
	public Object synchronizePhoto(Model model, Long parentId, String logType, Long objectId, String objectType, String ratio) {

		ProdProduct product = MiscUtils.autoUnboxing( prodProductService.getProdProductBy(objectId) );
		List<Long> productIdList=null;
		Map<String, Object> params = new HashMap<String, Object>();
		if(product.getBizCategoryId()!=null && product.getBizCategoryId().equals(17l)) {//酒店套餐

			params.put("productId", objectId);

			List<Long> hotelProductIds = prodPackageHotelCombHotelService.findProductIdsInPackageHotelCombByParams(params);
			List<Long> ticketProductIds = prodPackageHotelCombTicketService.findProductIdsInPackageHotelCombByParams(params);

			productIdList = new ArrayList<Long>();

			productIdList.addAll(hotelProductIds);
			productIdList.addAll(ticketProductIds);

			if(productIdList==null || productIdList.size()==0){//结构化酒店套餐中，对应的打包信息没有，根据目的地得到打包的产品ID
				productIdList=prodDestReService.selectCombineProductIdsWithDestReByProductId(objectId);
			}

		}else if(product.getSubCategoryId()!=null && product.getSubCategoryId().equals(181l)){//自由行景+酒

			params.put("productId", objectId);
			List<Long> categoryIds = new ArrayList<Long>();
			categoryIds.add(1l);//酒店
			categoryIds.add(11l);//景点门票
			categoryIds.add(12l);//其它票
			categoryIds.add(17l);//酒店套餐
			params.put("categoryIds", categoryIds);

			productIdList = prodPackageGroupService.findProductIdsInPackageGroupByParams(params);
		}

		comPhotoClientService.synchronizePhoto(objectId, productIdList);

		removeCacheAndSendMsg(parentId, objectId, objectType, logType, "添加图片");

		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}


	@RequestMapping(value = "/updateComPhoto")
	@ResponseBody
	public Object updateComPhoto(Model model, Long parentId, String logType, Long objectId, String objectType, String ratio) {
		
		String photoJson = HttpServletLocalThread.getRequest().getParameter("photoJson");
		List<ComPhoto> photoList = null;
		if(StringUtil.isNotEmptyString(photoJson) || (objectId != null && objectId > 0 && StringUtil.isNotEmptyString(objectType))){
			
			photoList = this.jsonToList(ComPhoto.class, photoJson);
			comPhotoClientService.updateListByPrimaryKeySelective(photoList, objectId, objectType,ratio);
			
			removeCacheAndSendMsg(parentId, objectId, objectType, logType, "修改了图片");
			
		}else{
			return new ResultMessage("error", "参数异常:photojson:[" + photoJson + "];objectId:[" + photoJson + "];objectType:[" + objectType + "]");
		}
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}
	/**
	 * 
	 * @author: ranlongfei 2014-10-13 下午2:23:17
	 * @param parentId
	 * @param objectId
	 * @param objectType
	 */
	private void removeCacheAndSendMsg(Long parentId, Long objectId, String objectType, String logType, String logContent) {
		try {
			if(objectType.equalsIgnoreCase(ComPhoto.OBJECT_TYPE.PRODUCT_ID.name()) || objectType.equalsIgnoreCase(ComPhoto.OBJECT_TYPE.PRODUCT_BRANCH_ID.name())){
				pushAdapterService.push(objectId, ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.COM_PHOTO,ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
				MemcachedUtil.getInstance().remove(MemcachedEnum.ProductComPhotoList.getKey()+parentId);
			}
			MemcachedUtil.getInstance().remove(MemcachedEnum.ComPhotoList.getKey()+objectType+objectId);
			
			if (null != logType && !"".equals(logType)) {
				comLogService.insert(COM_LOG_LOG_TYPE.getParentByCode(logType),
					parentId, objectId, this.getLoginUser().getUserName(),
					"图片更新操作", logType, logContent, null);
			}
		} catch (Exception e) {
			log.error("updateComPhoto error:"+e.getMessage()); 
		}
	}
	
	private List<ComPhoto> jsonToList(Class clazz, String jsons) {
      List<ComPhoto> objs = null;
      JSONArray jsonArray = (JSONArray) JSONSerializer.toJSON(jsons);
      if (jsonArray != null) {
          objs = new ArrayList<ComPhoto>();
          List list = (List) JSONSerializer.toJava(jsonArray);
          for (Object o : list) {
            JSONObject jsonObject = JSONObject.fromObject(o);
            ComPhoto obj = (ComPhoto) JSONObject.toBean(jsonObject, clazz);
            if(jsonObject.has("quondamPhotoContent")){
            	if(jsonObject.getString("quondamPhotoContent")!=null){
            		 String quondamPhotoContent=jsonObject.getString("quondamPhotoContent").toString().replace(" ","");
            		 obj.setQuondamPhotoContent(quondamPhotoContent);
            	}
              }
            objs.add(obj);
          }
      }
      return objs;
    }
}
