package com.lvmama.vst.back.prod.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.client.biz.service.BizBuEnumClientService;
import com.lvmama.vst.back.client.pub.service.ComPhotoClientService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdPromotionDesc;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.prod.service.ProdPromotionDescService;
import com.lvmama.vst.back.prod.vo.ProdProductSearch;
import com.lvmama.vst.back.prod.vo.ProdPromotionDescSearch;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.pub.po.ComPhoto;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.pub.service.ComPhotoClientService;
import com.lvmama.vst.comm.enumeration.CommEnumSet;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;
import com.lvmama.vst.back.utils.MiscUtils;

@Controller
@RequestMapping("prod/promotion/desc")
public class ProdPromotionDescAction extends BaseActionSupport {

	/**
	 * 序列
	 */
	private static final long serialVersionUID = -8241123314449635473L;
	
	private static final Log LOG = LogFactory.getLog(ProdPromotionDescAction.class);
	
	@Autowired
	private BizBuEnumClientService bizBuEnumClientService;
	
	@Autowired
	private ProdPromotionDescService prodPromotionDescService;
	
	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;
	
	@Autowired
	private ProdProductClientService prodProductService;
	
	@Autowired
	private PermUserServiceAdapter permUserServiceAdapter;
	
	@Autowired
	private ComLogClientService comLogService;
	
	@Autowired
	private ComPhotoClientService comPhotoClientService;
	
	@Autowired
	private ComPhotoClientService comPhotoService;

	
	private final Integer DEFAULT_PAGE_SIZE = 10;
	
	private final String PHOTO_TYPE = "DESC_ID";
	
	@RequestMapping(value = "/toAdd")
	public String toAdd(Model model,HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<toAdd>");
		}
		
		// BU
		model.addAttribute("buList", bizBuEnumClientService.getAllBizBuEnumList().getReturnContent());
		// 分销商
		model.addAttribute("channelList",ProdPromotionDesc.CHANNEL_TYPE.values());
		return "prod/promotion/addPromotion";
	}
	
	@RequestMapping(value = "/toEdit")
	public String toEdit(Model model,HttpServletRequest req,Long descId,String isEdit) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<toEdit>");
		}
		ProdPromotionDesc promotionDesc = prodPromotionDescService.queryPromotionDescById(descId);
		model.addAttribute("desc", promotionDesc);
		
		if("Y".equals(isEdit)){
			//给予编辑权限
			model.addAttribute("isEdit", "Y");
		}
		
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("objectId", descId);
		parameters.put("objectType", PHOTO_TYPE);
		parameters.put("_orderby", "PHOTO_ID");
		parameters.put("_order", "asc");
		List<ComPhoto> list = MiscUtils.autoUnboxing(comPhotoService.findImageList(parameters));
		if(null!=list && !list.isEmpty()){
			model.addAttribute("compShipPhotoSize", list.size());
		}
		model.addAttribute("objectType", PHOTO_TYPE);
		model.addAttribute("objectId", descId);
		model.addAttribute("list", list);
		
		// BU
		model.addAttribute("buList", bizBuEnumClientService.getAllBizBuEnumList().getReturnContent());
		// 分销商
		model.addAttribute("channelList",ProdPromotionDesc.CHANNEL_TYPE.values());
		return "prod/promotion/editPromotion";
	}
	
	@RequestMapping(value = "/toQuery")
	public String toQuery(Model model,HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<toQuery>");
		}
		// BU
		model.addAttribute("buList", bizBuEnumClientService.getAllBizBuEnumList().getReturnContent());
		// 分销商
		model.addAttribute("channelList",ProdPromotionDesc.CHANNEL_TYPE.values());
		return "prod/promotion/queryPromotion";
	}
	
	@RequestMapping(value = "/queryEnum")
	@ResponseBody
	public Object[] queryEnum(Model model,HttpServletRequest req) throws BusinessException {
		// 分销商
		model.addAttribute("channelList",ProdPromotionDesc.CHANNEL_TYPE.values());
		return ProdPromotionDesc.CHANNEL_TYPE.values();
	}
	
	@RequestMapping(value = "/toBind")
	public String toBind(Model model,Long descId,HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<toBind>");
		}
		model.addAttribute("descId", descId);
		
		ProdPromotionDesc promotionDesc = prodPromotionDescService.queryPromotionDescById(descId);
		model.addAttribute("desc", promotionDesc);
		//查询品类
		List<BizCategory> bizCategoryList = bizCategoryQueryService.getAllValidCategorys();
		model.addAttribute("filialeNameList", CommEnumSet.FILIALE_NAME.values()); //子公司列表
		// 产品品类
		model.addAttribute("bizCategoryList", bizCategoryList);
		return "prod/promotion/bindPromotion";
	}
	
	@RequestMapping(value = "/bind")
	public String bind(Model model,HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<bind>");
		}
		return "prod/promotion/bindPromotionSuc";
	}
	
	@RequestMapping(value = "/toLog")
	public String toLog(Model model,HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<toLog>");
		}
		return "prod/promotion/logPromotion";
	}
	
	@RequestMapping(value = "/save")
	@ResponseBody
	public Object save(Model model,ProdPromotionDesc prodPromotionDesc,String[] photoUrl,HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<save>");
		}
		try{
			prodPromotionDesc.setUserId(this.getLoginUser().getUserId());
			prodPromotionDescService.addPromotionDesc(prodPromotionDesc);
			
			//添加图片
			if(photoUrl!=null && photoUrl.length>0){
				for(String url : photoUrl){
					ComPhoto photo = new ComPhoto();
					photo.setLastUpdateTime(new Date());
					photo.setPhotoSeq(0L);
					photo.setPhotoDisplay(ComPhoto.PHOTO_DISPLAY.SHOW.toString());
					photo.setObjectId(prodPromotionDesc.getDescId());
					photo.setObjectType(PHOTO_TYPE);
					photo.setPhotoUrl(url);
					comPhotoService.insert(photo);
				}
			}
			//添加操作日志
			comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PROMOTION, 
					prodPromotionDesc.getDescId(), prodPromotionDesc.getDescId(), 
					this.getLoginUser().getUserName(), 
					"添加了活动：【"+prodPromotionDesc.getDescName()+"】", 
					COM_LOG_LOG_TYPE.PROD_PRODUCT_PROMOTION_CHANGE.name(), 
					"添加活动",null);
			JSONObject object = new JSONObject();
			object.put("code", "success");
			object.put("descId", prodPromotionDesc.getDescId());
			return object;
		}catch(Exception e){
			log.error("Record Log failure ！Log type:"+"新增优惠活动");
			log.error(ExceptionFormatUtil.getTrace(e));
			JSONObject object = new JSONObject();
			object.put("code", "error");
			return object;
		}
	}
	
	@RequestMapping(value = "/edit")
	@ResponseBody
	public Object edit(Model model,ProdPromotionDesc prodPromotionDesc,String[] photoUrl,HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<save>");
		}
		try{
			ProdPromotionDesc oldProdPromotionDesc = prodPromotionDescService.queryPromotionDescById(prodPromotionDesc.getDescId());
			
			if("Y".equals(oldProdPromotionDesc.getCancelFlag())){
				if(StringUtils.isEmpty(prodPromotionDesc.getCancelFlag())){
					return new ResultMessage("error", "有效的活动不允许编辑");
				}
			}
			
			prodPromotionDescService.updatePromotionDesc(prodPromotionDesc);
			
			Map<String, Object> parameters = new HashMap<String, Object>();
			parameters.put("objectId", prodPromotionDesc.getDescId());
			parameters.put("objectType", PHOTO_TYPE);
			parameters.put("_orderby", "PHOTO_ID");
			parameters.put("_order", "asc");
			List<ComPhoto> list = MiscUtils.autoUnboxing(comPhotoService.findImageList(parameters));
			StringBuffer oldBuf = new StringBuffer();
			StringBuffer newBuf = new StringBuffer();
			String oldPicPaths = "";
			String newPicPaths = "";
			//删除旧的图片
			if(StringUtils.isEmpty(prodPromotionDesc.getCancelFlag())){
				if(null!=list && !list.isEmpty()){
					for(ComPhoto photo : list){
						oldBuf.append(photo.getPhotoUrl()).append(",");
						if(photoUrl == null || photoUrl.length == 0 || !Arrays.asList(photoUrl).contains(photo.getPhotoUrl())){
							comPhotoService.deleteByPK(photo.getPhotoId());
						}
					}
					oldPicPaths = oldBuf.substring(0,oldBuf.length()-1);
					
				}
			}
			//添加新的图片
			if(photoUrl!=null && photoUrl.length>0){
				for(String url : photoUrl){
					if(!oldBuf.toString().contains(url)){
						ComPhoto photo = new ComPhoto();
						photo.setLastUpdateTime(new Date());
						photo.setPhotoSeq(0L);
						photo.setPhotoDisplay(ComPhoto.PHOTO_DISPLAY.SHOW.toString());
						photo.setObjectId(prodPromotionDesc.getDescId());
						photo.setObjectType(PHOTO_TYPE);
						photo.setPhotoUrl(url);
						comPhotoService.insert(photo);
					}
					newBuf.append(url).append(",");
				}
				newPicPaths = newBuf.substring(0,newBuf.length()-1);
			}
			
			String logContent = getCompareDesc(prodPromotionDesc, oldProdPromotionDesc,newPicPaths,oldPicPaths);
			
			if(StringUtils.isNotEmpty(logContent)){
				//添加操作日志
				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PROMOTION, 
						prodPromotionDesc.getDescId(), prodPromotionDesc.getDescId(), 
						this.getLoginUser().getUserName(), 
						"修改了活动：【"+logContent+"】", 
						COM_LOG_LOG_TYPE.PROD_PRODUCT_PROMOTION_CHANGE.name(), 
						"修改活动",null);
			}
			return new ResultMessage("success", "编辑成功");
		}catch(Exception e){
			log.error("Record Log failure ！Log type:"+"编辑优惠活动");
			log.error(ExceptionFormatUtil.getTrace(e));
			return new ResultMessage("error", "编辑失败");
		}
	}
	
	@RequestMapping(value = "/toSaveSuc")
	public String toSaveSuc(Model model,HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<toSaveSuc>");
		}
		return "prod/promotion/savePromotionSuc";
	}
	
	@RequestMapping(value = "/query")
	public String query(Model model,ProdPromotionDescSearch prodPromotionDescSearch,HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<query>");
		}
		Page<ProdPromotionDesc> resultPage = prodPromotionDescService.queryPromotionDesc(prodPromotionDescSearch);
		resultPage.buildJSONUrl(req);
		model.addAttribute("resultPage", resultPage);
		return "prod/promotion/queryPromotionRes";
	}
	
	@RequestMapping(value = "/queryProName")
	@ResponseBody
	public Object queryProName(Model model,Long descId,String productName,HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<queryProName>");
		}
		return prodPromotionDescService.queryProductForName(descId,productName);
	}
	
	@RequestMapping(value = "/queryBindpro")
	public String queryBindpro(Model model,ProdProductSearch prodProductSearch,HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<queryBindpro>");
		}
		ProdPromotionDesc promotionDesc =prodPromotionDescService.queryPromotionDescById(prodProductSearch.getDescId());
		model.addAttribute("desc", promotionDesc);
		
		Page<ProdProduct> resultPage = prodPromotionDescService.queryProductForSearch(prodProductSearch);
		resultPage.buildJSONUrl(req);
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("descId", prodProductSearch.getDescId());
		return "prod/promotion/UnBindPromotionRes";
	}
	
	@RequestMapping(value = "/queryOtherpro")
	public String queryOtherpro(Model model,ProdProductSearch prodProductSearch,String subCompany,HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<queryOtherpro>");
		}
		Page<ProdProduct> resultPage = null;
		Integer auditTotalCount = 0;
        int currentPage = prodProductSearch.getPage() == null ? 1 : prodProductSearch.getPage();
        int currentPageSize = prodProductSearch.getPageSize() == null ? DEFAULT_PAGE_SIZE
                : prodProductSearch.getPageSize();
		Map<String, Object> paramProdProduct = new HashMap<String, Object>();
		paramProdProduct.put("productId", prodProductSearch.getProductId()); //产品ID
		if(StringUtils.isNotEmpty(prodProductSearch.getProductIds())){
			List<Long> productIdLst = new ArrayList<Long>();
			for(String str : prodProductSearch.getProductIds().split(",")){
				Long productId = Long.parseLong(str);
				productIdLst.add(productId);
			}
			if(productIdLst.size()>0){
				paramProdProduct.put("productIdLst", productIdLst); //产品ID数组
			}
		}
		paramProdProduct.put("cancelFlag", prodProductSearch.getCancelFlag()); //产品状态
		paramProdProduct.put("saleFlag", prodProductSearch.getSaleFlag()); //是否可售
		paramProdProduct.put("subCompany", subCompany); //子公司
		
		paramProdProduct.put("productManagerId", prodProductSearch.getManagerId()); //产品经理
		paramProdProduct.put("supplierId", prodProductSearch.getSupplierId()); //供应商名称
		paramProdProduct.put("bizCategoryId", prodProductSearch.getBizCategoryId());//产品品类
		auditTotalCount = MiscUtils.autoUnboxing(prodProductService.findProdProductCount(paramProdProduct));
		resultPage = Page.page(auditTotalCount, currentPageSize, currentPage);
		resultPage.buildJSONUrl(req);
		paramProdProduct.put("_start", resultPage.getStartRows());
		paramProdProduct.put("_end", resultPage.getEndRows());
		paramProdProduct.put("_orderby", "PRODUCT_ID");
		paramProdProduct.put("_order", "DESC");
		paramProdProduct.put("isneedmanager", "false");

		List<ProdProduct> list = prodProductService.findProdProductListSales(paramProdProduct);
		
		if(list!=null && list.size() > 0){
			resultPage.setItems(list);
    		model.addAttribute("resultPage", resultPage);
		}
		model.addAttribute("descId", prodProductSearch.getDescId());
		return "prod/promotion/bindPromotionRes";
	}
	
	@RequestMapping(value = "/deleteBind")
	@ResponseBody
	public Object deleteBind(Model model,Long descId,String productIds,HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<deleteBind>");
		}
		try{
			if(StringUtils.isNotEmpty(productIds)){
				List<Long> productIdLst = new ArrayList<Long>();
				for(String str : productIds.split(",")){
					Long productId = Long.parseLong(str);
					productIdLst.add(productId);
				}
				prodPromotionDescService.deleteBind(descId, productIdLst);
				//添加操作日志
				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PROMOTION, 
						descId, descId, 
						this.getLoginUser().getUserName(), 
						"解绑了产品：【产品ID列表："+productIds+"】", 
						COM_LOG_LOG_TYPE.PROD_PRODUCT_PROMOTION_CHANGE.name(), 
						"解绑产品",null);
			}
			return new ResultMessage("success", "解绑成功");
		}catch(Exception e){
				log.error("Record Log failure ！Log type:"+"解绑");
				log.error(ExceptionFormatUtil.getTrace(e));
				return new ResultMessage("success", "解绑失败");
		}
	}
	
	@RequestMapping(value = "/deleteAllBind")
	@ResponseBody
	public Object deleteAllBind(Model model,ProdProductSearch prodProductSearch,HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<deleteAllBind>");
		}
		try{
			
			prodPromotionDescService.deleteAllBind(prodProductSearch);
			//添加操作日志
			comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PROMOTION, 
					prodProductSearch.getDescId(), prodProductSearch.getDescId(), 
					this.getLoginUser().getUserName(), 
					"解绑了产品：【所有符合查询条件的产品】", 
					COM_LOG_LOG_TYPE.PROD_PRODUCT_PROMOTION_CHANGE.name(), 
					"解绑产品",null);
			return new ResultMessage("success", "解绑成功");
		}catch(Exception e){
				log.error("Record Log failure ！Log type:"+"解绑");
				log.error(ExceptionFormatUtil.getTrace(e));
				return new ResultMessage("success", "解绑失败");
		}
	}
	
	@RequestMapping(value = "/addAllBind")
	public String addAllBind(Model model,ProdProductSearch prodProductSearch,String subCompany,HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<addAllBind>");
		}
		Map<String, Object> paramProdProduct = new HashMap<String, Object>();
		paramProdProduct.put("productId", prodProductSearch.getProductId()); //产品ID
		if(StringUtils.isNotEmpty(prodProductSearch.getProductIds())){
			List<Long> productIdLst = new ArrayList<Long>();
			for(String str : prodProductSearch.getProductIds().split(",")){
				Long productId = Long.parseLong(str);
				productIdLst.add(productId);
			}
			if(productIdLst.size()>0){
				paramProdProduct.put("productIdLst", productIdLst); //产品ID数组
			}
		}
		paramProdProduct.put("cancelFlag", prodProductSearch.getCancelFlag()); //产品状态
		paramProdProduct.put("saleFlag", prodProductSearch.getSaleFlag()); //是否可售
		paramProdProduct.put("subCompany", subCompany); //子公司
		paramProdProduct.put("descId", prodProductSearch.getDescId());//活动Id
		paramProdProduct.put("productManagerId", prodProductSearch.getManagerId()); //产品经理
		paramProdProduct.put("supplierId", prodProductSearch.getSupplierId()); //供应商名称
		paramProdProduct.put("bizCategoryId", prodProductSearch.getBizCategoryId());//产品品类
		prodProductService.addAllBindForDesc(paramProdProduct);
		//添加操作日志
		comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PROMOTION, 
				prodProductSearch.getDescId(), prodProductSearch.getDescId(), 
				this.getLoginUser().getUserName(), 
				"绑定了产品：【所有符合查询条件的产品】", 
				COM_LOG_LOG_TYPE.PROD_PRODUCT_PROMOTION_CHANGE.name(), 
				"绑定产品",null);
		return "prod/promotion/bindPromotionSuc";
	}
	
	@RequestMapping(value = "/addBind")
	public String addBind(Model model,Long descId,String productIds,HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<addBind>");
		}
		if(StringUtils.isNotEmpty(productIds)){
			List<Long> productIdLst = new ArrayList<Long>();
			for(String str : productIds.split(",")){
				Long productId = Long.parseLong(str);
				productIdLst.add(productId);
			}
			Map<String, String> resultWrapper = prodPromotionDescService.addBind(descId, productIdLst);
			String validproductIds = resultWrapper.get("validStr");
			String repeatedProductIds = resultWrapper.get("repeatedProductIds");
			if(StringUtils.isNotEmpty(repeatedProductIds)) {
				model.addAttribute("repeatedProductIds", repeatedProductIds);
			}
			
			
			if(StringUtils.isNotEmpty(validproductIds)){
				//添加操作日志
				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PROMOTION, 
						descId, descId, 
						this.getLoginUser().getUserName(), 
						"绑定了产品：【产品ID列表："+validproductIds+"】", 
						COM_LOG_LOG_TYPE.PROD_PRODUCT_PROMOTION_CHANGE.name(), 
						"绑定产品",null);
			}
			
		}
		return "prod/promotion/bindPromotionSuc";
	}

	@RequestMapping(value = "/bindActivity")
	public String bindActivity(Model model,Long currentDescId,Long sourceDescId,HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<bindActivity>");
		}
		Map<String, Object> result = prodPromotionDescService.bindActivity(currentDescId,sourceDescId);
		model.addAllAttributes(result);
        return "prod/promotion/bindPromotionSuc";

	}

	
	@RequestMapping(value = "/deleteBindSuc")
	public String deleteBindSuc(Model model,Long descId,String productIds,HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<addBind>");
		}
		return "prod/promotion/UnBindPromotionSuc";
	}
	
	/**
	 * 根据产品经理姓名模糊查询产品经理列表
	 * @param name
	 * @return
	 */
	@RequestMapping(value = "/findMangement")
	@ResponseBody
	public JSONArray findMangement(String name) {
		List<PermUser> list = permUserServiceAdapter.findPermUser(name);
		// 组装查询条件
		// 组装JSON数据
		JSONArray jsonArray = new JSONArray();
		if (null != list && !list.isEmpty()) {
			for (PermUser permUser : list) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("email",permUser.getEmail());
				// 产品经理的id
				jsonObject.put("id", permUser.getUserId());
				// 产品经理的姓名
				jsonObject.put("name", permUser.getRealName());
				jsonArray.add(jsonObject);
			}
		}
		// 返回JSON数据
		return jsonArray;
	}
	
	/**
	 * 获取修改的不同值
	 * @param newDesc
	 * @param oldDesc
	 * @param newPictureUrls
	 * @param oldPictureUrls
	 * @return
	 */
	public String getCompareDesc(ProdPromotionDesc newDesc,ProdPromotionDesc oldDesc,String newPictureUrls,String oldPictureUrls){
		StringBuffer buffer = new StringBuffer();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		if(newDesc !=null && oldDesc !=null){
			if(StringUtils.isNotEmpty(newDesc.getDescName())){
				if(!oldDesc.getDescName().equals(newDesc.getDescName())){
					buffer.append("活动名称:[原来值:"+oldDesc.getDescName()+",新值:"+newDesc.getDescName()+"];");
				}
			}
			if(newDesc.getDescStartTime() != null){
				if(oldDesc.getDescStartTime().compareTo(newDesc.getDescStartTime()) != 0){
					buffer.append("活动展示开始时间:[原来值:"+format.format(oldDesc.getDescStartTime())+",新值:"+format.format(newDesc.getDescStartTime())+"];");
				}
			}
			if(newDesc.getDescEndTime() != null){
				if(oldDesc.getDescEndTime().compareTo(newDesc.getDescEndTime()) != 0){
					buffer.append("活动展示结束时间:[原来值:"+format.format(oldDesc.getDescEndTime())+",新值:"+format.format(newDesc.getDescEndTime())+"];");
				}
			}
			if(newDesc.getChannelCode() != null && newDesc.getChannelCode().size() > 0){
				StringBuffer oldBuf = new StringBuffer();
				StringBuffer newBuf = new StringBuffer();
				String[] oldArray = oldDesc.getChannelList().split(",");
				for(int i=0;i<oldArray.length;i++){
					oldBuf.append(ProdPromotionDesc.CHANNEL_TYPE.getCnNameBycnCode(oldArray[i]));
					oldBuf.append(",");
				}
				String oldValue = oldBuf.substring(0,oldBuf.length()-1);
				for(int i=0;i<newDesc.getChannelCode().size();i++){
					newBuf.append(ProdPromotionDesc.CHANNEL_TYPE.getCnNameBycnCode(newDesc.getChannelCode().get(i)));
					newBuf.append(",");
				}
				String newValue = newBuf.substring(0,newBuf.length()-1);
				if(!oldValue.equals(newValue)){
					buffer.append("显示渠道:[原来值:"+oldValue+",新值:"+newValue+"];");
				}
			}
			if(StringUtils.isNotEmpty(newDesc.getBuCode())){
				if(!oldDesc.getBuCode().equals(newDesc.getBuCode())){
					String oldValue = bizBuEnumClientService.getBizBuEnumByBuCode(oldDesc.getBuCode()).getReturnContent().getCnName();
					String newValue = bizBuEnumClientService.getBizBuEnumByBuCode(newDesc.getBuCode()).getReturnContent().getCnName();
					buffer.append("所属BU:[原来值:"+oldValue+",新值:"+newValue+"];");
				}
			}
			if(newDesc.getSeq() != null){
				if(oldDesc.getSeq().intValue() != newDesc.getSeq().intValue()){
					buffer.append("活动排序值:[原来值:"+oldDesc.getSeq().intValue()+",新值:"+newDesc.getSeq().intValue()+"];");
				}
			}
			
			if(oldDesc.getDescDescription() == null){
				oldDesc.setDescDescription("");
			}
			if(newDesc.getDescDescription()!=null){
				if(!oldDesc.getDescDescription().equals(newDesc.getDescDescription())){
					buffer.append("活动描述内容:[原来值:"+oldDesc.getDescDescription()+",新值:"+newDesc.getDescDescription()+"];");
				}
			}
			if(StringUtils.isNotEmpty(newDesc.getCancelFlag())){
				if(!oldDesc.getCancelFlag().equals(newDesc.getCancelFlag())){
					String oldValue = "Y".equals(oldDesc.getCancelFlag())?"有效":"无效";
					String newValue = "Y".equals(newDesc.getCancelFlag())?"有效":"无效";
					buffer.append("有效值:[原来值:"+oldValue+",新值:"+newValue+"];");
				}
			}
			
			if(!newPictureUrls.equals(oldPictureUrls)){
				buffer.append("图片路径列表:[原来值:"+oldPictureUrls+",新值:"+newPictureUrls+"];");
			}
			
			String str = buffer.toString();
			if (str.endsWith(";")){
				return str.substring(0,str.length()-1);
			}else{
				return str;
			}
			
		}
		
		return "";
		
	}
}
