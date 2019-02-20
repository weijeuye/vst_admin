package com.lvmama.vst.back.customized.web;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.lvmama.vst.back.biz.po.BizCatePropGroup;
import com.lvmama.vst.back.biz.po.BizCategoryProp;
import com.lvmama.vst.back.biz.po.BizDest;
import com.lvmama.vst.back.biz.service.CategoryPropGroupService;
import com.lvmama.vst.back.biz.service.DestService;
import com.lvmama.vst.back.customized.po.CustomizedProdDestRe;
import com.lvmama.vst.back.customized.po.CustomizedProdDetail;
import com.lvmama.vst.back.customized.po.CustomizedProdLineInfo;
import com.lvmama.vst.back.customized.po.CustomizedProdSubject;
import com.lvmama.vst.back.customized.po.CustomizedProduct;
import com.lvmama.vst.back.customized.service.CustomizedProdDestReService;
import com.lvmama.vst.back.customized.service.CustomizedProdDetailService;
import com.lvmama.vst.back.customized.service.CustomizedProdLineInfoService;
import com.lvmama.vst.back.customized.service.CustomizedProdSubjectService;
import com.lvmama.vst.back.customized.service.CustomizedProductService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.prod.po.ProdProductProp;
import com.lvmama.vst.back.client.prod.service.ProdProductPropClientService;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.pub.po.ComPhoto;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.pub.service.ComPhotoClientService;
import com.lvmama.vst.comm.jms.TopicMessageProducer;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.utils.web.HttpServletLocalThread;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.back.utils.MiscUtils;


@Controller
@RequestMapping("/prod/customized")
public class CustomizedProdAction extends BaseActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6916359953460627398L;
	

	private static final Log LOG = LogFactory.getLog(CustomizedProdAction.class);
	
	@Autowired
	private ComPhotoClientService comPhotoService;
	
	@Autowired
	private CustomizedProductService customizedProductService;
	
	@Autowired
	private CustomizedProdDetailService customizedProdDetailService;
	
	@Autowired
	private CustomizedProdLineInfoService customizedProdLineInfoService;
	
	@Autowired
	private CategoryPropGroupService categoryPropGroupService;
	
	@Autowired
	private ProdProductPropClientService prodProductPropService;
	
	@Autowired
	private ComLogClientService comLogService;
	
	@Autowired
	private CustomizedProdSubjectService customizedProdSubjectService;
	
	@Autowired
	private CustomizedProdDestReService customizedProdDestReService;
	
	@Autowired
	private DestService destService;
	
	@Resource(name="ebkSmsMessageProducer")
	private TopicMessageProducer ebkSmsProcess;
	/**
	 * 跳转到产品主页面
	 * @param model
	 * @param req
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/showProductMaintain")
	public String showProductMaintain(Model model,Long productId,HttpServletRequest req) throws BusinessException {
		model.addAttribute("productId", productId);
		if(productId != null) {
			CustomizedProduct customizedProduct = customizedProductService.findCustomizedProductByCustomizedProdId(productId);
			model.addAttribute("customizedProduct", customizedProduct);
		} else {
			model.addAttribute("productName", null);
			model.addAttribute("customizedProduct", new CustomizedProduct());
		}
		
		return "/prod/customized/showProductMaintain";
	}
	
	/**
	 * 跳转到产品修改页面
	 * @param model
	 * @param req
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/toUpdateProduct")
	public ModelAndView toUpdatrProduct(Model model,Long productId,HttpServletRequest req) throws BusinessException {
		return new ModelAndView("redirect:/prod/customized/showProductMaintain.do?productId="+productId);
		
	}
	
	/**
	 * 跳转到新增产品页面
	 * @param model
	 * @param req
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/showAddProduct")
	public String showAddProduct(Model model,HttpServletRequest req) throws BusinessException {

		model.addAttribute("customizedProduct", new CustomizedProduct());
		return "/prod/customized/showAddProduct";
	}
	
	/**
	 * 新增产品
	 * @param model
	 * @param req
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/addProduct")
	@ResponseBody
	public Object addProduct(Model model,CustomizedProduct customizedProduct,HttpServletRequest req) throws BusinessException {
		Map<String, Object> attributes = new HashMap<String, Object>();
		customizedProduct.setCreateTime(new Date());
		customizedProduct.setCreateUser(getLoginUserId());
		customizedProduct.setUpdateTime(new Date());
		customizedProduct.setUpdateUser(getLoginUserId());
		
		//默认上线
		customizedProduct.setCancelFlag("Y");
		if(StringUtil.isEmptyString(customizedProduct.getPrice())) {
			customizedProduct.setPrice("一团一议");
		}
		//还应根据后台登陆用户设置createUser
		customizedProduct.setCreateUser(getLoginUserId());
		long id =  customizedProductService.addCustomizedProduct(customizedProduct);
		customizedProduct.setCustomizedProdId(id);
		//目的地新增
		if(customizedProduct.getCustomizedProdDestReList()!=null && customizedProduct.getCustomizedProdDestReList().size()>0
				&& customizedProduct.getCustomizedProdDestReList().get(0).getDestId() != null){
			
			for (CustomizedProdDestRe prodDestRe : customizedProduct.getCustomizedProdDestReList()) {
				prodDestRe.setProductId(customizedProduct.getCustomizedProdId());
			}
			customizedProdDestReService.addProdDestReList(customizedProduct.getCustomizedProdDestReList());
		}
		
		//添加操作日志
		try {
			comLogService.insert(COM_LOG_OBJECT_TYPE.CUSTOMIZED_PRODUCT,
					id, id,
					"admin", 
					"新增了ID为【"+id+"】的产品",
					COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_STATUS.name(), 
					"新增产品",null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_STATUS.name());
			log.error(ExceptionFormatUtil.getTrace(e));
		}
		attributes.put("productId", id);
		attributes.put("productName", customizedProduct.getProductName());
		attributes.put("categoryName","定制游");
		return new ResultMessage(attributes, "success", "保存成功");
		//return "/prod/customized/showProductMaintain";
	}
	
	/**
	 * 跳转到修改产品页面
	 * @param model
	 * @param req
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/showUpdateProduct")
	public String showUpdateProduct(Model model,Long customizedProdId,HttpServletRequest req) throws BusinessException {
		
		CustomizedProduct customizedProduct = customizedProductService.findCustomizedProductByCustomizedProdId(customizedProdId);	
		//返回适合人数
		String[] propPersons = customizedProduct.getPropPerson().split(",");
		model.addAttribute("propPerson0", propPersons[0]);
		if(propPersons.length == 2) {
			model.addAttribute("propPerson1", propPersons[1]);
		}
		
		// 取得产品目的地关联
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		if(customizedProduct != null){
			paramsMap.put("productId", customizedProduct.getCustomizedProdId());
			customizedProduct.setCustomizedProdDestReList(customizedProdDestReService.findProdDestReByParams(paramsMap));
		}
		model.addAttribute("customizedProduct", customizedProduct);
		
		return "/prod/customized/showUpdateProduct";
	}
	
	/**
	 * 修改产品
	 * @param model
	 * @param req
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/updateProduct")
	@ResponseBody
	public Object updateProduct(Model model,CustomizedProduct customizedProduct,HttpServletRequest req) throws BusinessException {
		Map<String, Object> attributes = new HashMap<String, Object>();
		if(StringUtil.isEmptyString(customizedProduct.getPrice())) {
			customizedProduct.setPrice("一团一议");
		}
		CustomizedProduct oldProduct = customizedProductService.findCustomizedProductByCustomizedProdId(customizedProduct.getCustomizedProdId());
		customizedProduct.setUpdateTime(new Date());
		customizedProduct.setUpdateUser(getLoginUserId());
		Long id = customizedProductService.updateCustomizedProductByCustomizedProdId(customizedProduct);
		
		StringBuilder newDestStr = new StringBuilder(",");
		List<CustomizedProdDestRe> insertProdDestReList= new ArrayList<CustomizedProdDestRe>(); 
		List<CustomizedProdDestRe> updateProdDestReList= new ArrayList<CustomizedProdDestRe>(); 
		
		// 取得原来产品目的地关联
		BizDest bizDest;
		if(customizedProduct.getCustomizedProdDestReList() != null && customizedProduct.getCustomizedProdDestReList().size() > 0) {
			for (CustomizedProdDestRe prodDestRe : customizedProduct.getCustomizedProdDestReList()) {
				if(prodDestRe.getReId()!=null){
					updateProdDestReList.add(prodDestRe);
				}else if(prodDestRe.getDestId()!=null){
					prodDestRe.setProductId(oldProduct.getCustomizedProdId());
					insertProdDestReList.add(prodDestRe);
				}
				bizDest = destService.findDestDetailById(prodDestRe.getDestId());
				newDestStr.append(bizDest.getDestName()).append(",");
			}
			
			// 取得原来产品目的地关联
			Map<String, Object> paraProdDestRe = new HashMap<String, Object>();
			paraProdDestRe.put("productId", oldProduct.getCustomizedProdId());
			List<CustomizedProdDestRe> oldProdDestReList = customizedProdDestReService.findProdDestReByParams(paraProdDestRe);

			//修改产品目的地关联
			customizedProdDestReService.addProdDestReList(insertProdDestReList);
			customizedProdDestReService.updateProdDestReList(updateProdDestReList);
			StringBuilder oldDestStr = new StringBuilder(",");
			for (CustomizedProdDestRe oldProdDestRe : oldProdDestReList) {
				boolean flg = false;
				for (CustomizedProdDestRe updateProdDestRe : updateProdDestReList) {
					if(oldProdDestRe.getReId().longValue() == updateProdDestRe.getReId().longValue()){
						flg = true;
					}
				}
				if(!flg){
					customizedProdDestReService.deleteProdDestReByPrimaryKey(oldProdDestRe.getReId());
				}
				bizDest = destService.findDestDetailById(oldProdDestRe.getDestId());
				oldDestStr.append(bizDest.getDestName()).append(",");
			}
		} else {
			//目的地新增
			if(customizedProduct.getCustomizedProdDestReList()!=null && customizedProduct.getCustomizedProdDestReList().size()>0
					&& customizedProduct.getCustomizedProdDestReList().get(0).getDestId() != null){
				
				for (CustomizedProdDestRe prodDestRe : customizedProduct.getCustomizedProdDestReList()) {
					prodDestRe.setProductId(customizedProduct.getCustomizedProdId());
				}
				customizedProdDestReService.addProdDestReList(customizedProduct.getCustomizedProdDestReList());
			}
		}
		
		try {
			comLogService.insert(COM_LOG_OBJECT_TYPE.CUSTOMIZED_PRODUCT,
					customizedProduct.getCustomizedProdId(), customizedProduct.getCustomizedProdId(),
					"admin", 
					"修改了产品"+getCustomizedProductChangeLog(oldProduct, customizedProduct),
					COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_STATUS.name(), 
					"修改产品",null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_STATUS.name());
			log.error(ExceptionFormatUtil.getTrace(e));
		}
		attributes.put("productId", id);
		attributes.put("productName", customizedProduct.getProductName());
		attributes.put("categoryName","定制游");
		return new ResultMessage(attributes, "success", "修改成功");
		//return "/prod/customized/showProductMaintain";
	}
	
	
	/**
	 * 查询定制游产品
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value="/findProductList")
	public String findProductList(CustomizedProduct customizedProduct,Model model, Integer page,HttpServletRequest req) throws BusinessException {
		
		Map<String,Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("customizedProdId", customizedProduct.getCustomizedProdId());
		paramsMap.put("productName", customizedProduct.getProductName());
		paramsMap.put("cancelFlag",customizedProduct.getCancelFlag());
		paramsMap.put("substation", customizedProduct.getSubstation());
		int count = customizedProductService.findCustomizedProductsCountByParams(paramsMap);

		int pagenum = page == null ? 1 : page;
		Page<CustomizedProduct> pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		paramsMap.put("_start", pageParam.getStartRows());
		paramsMap.put("_end", pageParam.getEndRows());
		paramsMap.put("_orderby", "UPDATE_TIME");
		paramsMap.put("_order", "DESC");
		
		
		
		// 查询列表
		List<CustomizedProduct> customizedProductList = customizedProductService.findCustomizedProductByParams(paramsMap);
		pageParam.setItems(customizedProductList);
		
		for(CustomizedProduct customizedProduct2 : customizedProductList) {
			
			//查询产品主题
			Map<String, Object> paramsSubject = new HashMap<String, Object>();
			paramsSubject.put("productId", customizedProduct2.getCustomizedProdId());
			paramsSubject.put("prodType", "CustomizedProduct");
			List<CustomizedProdSubject> prodSubjectList = customizedProdSubjectService.findProdSubjectListByParams(paramsSubject, true);
			customizedProduct2.setProdSubjectList(prodSubjectList);
		}
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("customizedProdId", customizedProduct.getCustomizedProdId());
		model.addAttribute("productName", customizedProduct.getProductName());
		model.addAttribute("cancelFlag",customizedProduct.getCancelFlag());
		model.addAttribute("substation", customizedProduct.getSubstation());
		return "/prod/customized/findCustomizedProdList";
	}
	
	/**
	 * 查询产品与主题的关联信息(定制游)
	 * @param model
	 * @param customizedProdSubject
	 * @param req
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/findProdSubjectListForCustomizedProduct")
	public String findProdSubjectListForCustomizedProduct(Model model, CustomizedProdSubject customizedProdSubject,HttpServletRequest req) throws BusinessException {
		if(null!=customizedProdSubject){
			Map<String,Object> params = new HashMap<String, Object>();
			params.put("productId", customizedProdSubject.getProductId());
			params.put("_orderby", "SEQ");
			params.put("_order", "ASC");	
			List<CustomizedProdSubject> prodSubjects = customizedProdSubjectService.findProdSubjectListByParams(params,true);
			model.addAttribute("prodSubjects", prodSubjects);
			model.addAttribute("prodSubject", customizedProdSubject);
		}
		return "/prod/customized/findProdSubjectListForCustomizedProduct";
	}
	
	/**
	 * 新增主题与产品的关联信息
	 */
	@RequestMapping(value = "/saveProdSubjectForCustomizedProduct")
	@ResponseBody
	public Object saveProdSubjectForCustomizedProduct(CustomizedProdSubject customizedProdSubject,Long productId) throws BusinessException {
		if(null!=customizedProdSubject){
			try {
				Long subjectId = customizedProdSubject.getSubjectId();
				if(null==subjectId){
					return new ResultMessage("error","主题不存在");
				}
				customizedProdSubjectService.addProdSubjectForCustomizedProduct(customizedProdSubject);
				
				CustomizedProduct customizedProductParam = new CustomizedProduct();
				customizedProductParam.setCustomizedProdId(productId);
				customizedProductParam.setUpdateUser(getLoginUserId());
				customizedProductParam.setUpdateTime(new Date());
				customizedProductService.updateCustomizedProductByCustomizedProdId(customizedProductParam);

				HttpServletLocalThread.getModel().addAttribute("prodSubject", customizedProdSubject);
			} catch (BusinessException e) {
				return new ResultMessage("error",e.getMessage());
			}
			return ResultMessage.ADD_SUCCESS_RESULT;
		}else{
			return new ResultMessage("error","参数错误");
		}
	}
	
	/**
	 * 删除指定产品与主题关联信息
	 */
	@RequestMapping(value = "/deleteProdSubjectByReId")
	@ResponseBody
	public Object deleteProdSubjectByReId(Long reId,HttpServletRequest req) throws BusinessException {
		if(null!=reId && reId>0){
			// 删除主题与产品关联信息
			customizedProdSubjectService.deleteProdSubjectById(reId);
			return ResultMessage.DELETE_SUCCESS_RESULT;
		}else{
			return new ResultMessage("error", "请选择需要删除的信息");
		}
	}
	
	/**
	 * 上线下线
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/updateCancelFlag")
	@ResponseBody
	public Object cancelProduct(Model model,CustomizedProduct product,Long productId,HttpServletRequest req) {
		
		if (log.isDebugEnabled()) {
			log.debug("start method<cancelProduct>");
		}
		product.setCustomizedProdId(productId);
		product.setUpdateTime(new Date());
		//应新增updateUser
		product.setUpdateUser(getLoginUserId());
		//Long productId = customizedProduct.getCustomizedProdId();
		customizedProductService.updateCancelFlagByCustomizedProdId(product);
		//添加操作日志
		try {
			comLogService.insert(COM_LOG_OBJECT_TYPE.CUSTOMIZED_PRODUCT,
					product.getCustomizedProdId(), product.getCustomizedProdId(),
					"admin", 
					"修改了产品：【"+product.getProductName()+"】的有效性为："+product.getCancelFlag(), 
					COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_STATUS.name(), 
					"设置产品的有效性",null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_STATUS.name());
			log.error(ExceptionFormatUtil.getTrace(e));
		}
		
		return ResultMessage.SET_SUCCESS_RESULT;
	}
	
	@RequestMapping(value = "/findComPhotoListForCustomized")
	public String findComPhotoListForCustomized(Model model,Long objectId) {
		
		model.addAttribute("objectId", objectId);
		
		//查询产品信息
		CustomizedProduct customizedProduct = customizedProductService.findCustomizedProductByCustomizedProdId(objectId);
		//查询产品详情信息
		List<CustomizedProdDetail> customizedProdDetailList = customizedProdDetailService.findCustomizedProdDetailByProdId(objectId);
		//查询行程信息
		List<CustomizedProdLineInfo> customizedProdLineInfoList = customizedProdLineInfoService.findCustomizedProdLineInfoByCustomizedProdId(objectId);
		
		model.addAttribute("customizedProduct", customizedProduct);
		model.addAttribute("customizedProdDetailList", customizedProdDetailList);
		
		model.addAttribute("customizedProdLineInfoList", customizedProdLineInfoList);
		
		model.addAttribute("objectId", objectId);
		return "/prod/customized/findComPhotoListForCustomized";
	}
	
	@RequestMapping(value = "/findComPhotoList")
	public String findComPhotoList(Model model, String objectType,String objectType1,String objectType2, Long objectId,Long parentId,String logType, String minNum, String maxNum, String imgLimitType) {
		
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("objectId", objectId);
		parameters.put("objectType", objectType);
		parameters.put("_orderby", "photo_seq");
		parameters.put("_order", "asc");
		
		List<ComPhoto> list = MiscUtils.autoUnboxing(comPhotoService.findImageList(parameters));
		
		model.addAttribute("list", list);
		
		model.addAttribute("objectId", objectId);
		model.addAttribute("objectType", objectType);
		model.addAttribute("parentId", parentId);
		model.addAttribute("logType", logType);
		
		model.addAttribute("minNum", minNum );
		model.addAttribute("maxNum", maxNum );
		
		String scheme = HttpServletLocalThread.getRequest().getScheme();
		String serverName = HttpServletLocalThread.getRequest().getServerName();
		int serverPort = HttpServletLocalThread.getRequest().getServerPort();
		
		model.addAttribute("scheme", scheme);
		model.addAttribute("serverName", serverName);
		model.addAttribute("serverPort", serverPort);
		
		model.addAttribute("requestURL", scheme + "://" + serverName + ":" + serverPort);
		model.addAttribute("typeList", ComPhoto.PHOTO_TYPE.values());
		model.addAttribute("imgLimitType", imgLimitType);
		
		//查询产品信息
		CustomizedProduct customizedProduct = customizedProductService.findCustomizedProductByCustomizedProdId(objectId);
		//查询产品详情信息
		List<CustomizedProdDetail> customizedProdDetailList = customizedProdDetailService.findCustomizedProdDetailByProdId(objectId);
		//查询行程信息
		List<CustomizedProdLineInfo> customizedProdLineInfoList = customizedProdLineInfoService.findCustomizedProdLineInfoByCustomizedProdId(objectId);
		
		model.addAttribute("customizedProduct", customizedProduct);
		model.addAttribute("customizedProdDetailList", customizedProdDetailList);
		model.addAttribute("customizedProdLineInfoList", customizedProdLineInfoList);
		return "/prod/customized/findComPhotoList";
	}
	
	/**
	 * 加载建议条款页面
	 * @param model
	 * @param productId
	 * @param categoryId
	 * @param req
	 * @return
	 */
	@RequestMapping("/showProductSugg")
	public String showProductSugg(Model model,Long productId,Long categoryId,HttpServletRequest req) {
		
		List<BizCatePropGroup> bizCatePropGroupList = null;
		
		CustomizedProduct customizedProduct = customizedProductService.findCustomizedProductByCustomizedProdId(productId);
		
		if (customizedProduct != null) {
			bizCatePropGroupList = categoryPropGroupService.findCategoryPropGroupsAndCategoryProp(categoryId, false);
			if ((bizCatePropGroupList != null) && (bizCatePropGroupList.size() > 0)) {
				for (BizCatePropGroup bizCatePropGroup : bizCatePropGroupList) {
					if ((bizCatePropGroup.getBizCategoryPropList() != null) && (bizCatePropGroup.getBizCategoryPropList().size() > 0)) {
						for (BizCategoryProp bizCategoryProp : bizCatePropGroup.getBizCategoryPropList()) {
							Map<String, Object> parameters2 = new HashMap<String, Object>();
							Long propId = bizCategoryProp.getPropId();
							parameters2.put("productId", req.getParameter("productId"));
							parameters2.put("propId", propId);
							parameters2.put("addValue", "customized");
							List<ProdProductProp> prodProductPropList = MiscUtils.autoUnboxing(prodProductPropService.findProdProductPropList(parameters2));
							bizCategoryProp.setProdProductPropList(prodProductPropList);
						}
					}
				}
			}
			
			model.addAttribute("customizedProduct", customizedProduct);
			model.addAttribute("bizCatePropGroupList", bizCatePropGroupList);
			
		}
		
		return "/prod/customized/showProductSugg";
	}
	
	@RequestMapping(value = "/updateProductSugg")
	@ResponseBody
	public Object updateProductSugg(CustomizedProduct customizedProduct,Long customizedProdId, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<updateProduct>");
		}

		ResultMessage message = null;
		customizedProduct.setCustomizedProdId(customizedProdId);
		
		customizedProductService.updateCustomizedProductByCustomizedProdId(customizedProduct);
		
		CustomizedProduct customizedProductParam = new CustomizedProduct();
		customizedProductParam.setCustomizedProdId(customizedProdId);
		customizedProductParam.setUpdateUser(getLoginUserId());
		customizedProductParam.setUpdateTime(new Date());
		customizedProductService.updateCustomizedProductByCustomizedProdId(customizedProductParam);
		
		message = new ResultMessage("success", "保存成功");
		return message;
	}
	
	 private String getCustomizedProductChangeLog(CustomizedProduct oldProduct,CustomizedProduct newProduct){
		 StringBuffer logStr = new StringBuffer("");
		 if(null!= newProduct)
		 {
			 logStr.append(ComLogUtil.getLogTxt("产品名称",newProduct.getProductName(),oldProduct.getProductName()));
			 logStr.append(ComLogUtil.getLogTxt("适合人数",newProduct.getPropPerson(),oldProduct.getPropPerson()));
			 logStr.append(ComLogUtil.getLogTxt("行程特色",newProduct.getFeature(),oldProduct.getFeature()));
			 logStr.append(ComLogUtil.getLogTxt("参考价格",newProduct.getPrice(),oldProduct.getPrice()));
			 logStr.append(ComLogUtil.getLogTxt("所属分站",newProduct.getSubstation(),oldProduct.getSubstation()));
		 }
		 return logStr.toString();
	 }

}
