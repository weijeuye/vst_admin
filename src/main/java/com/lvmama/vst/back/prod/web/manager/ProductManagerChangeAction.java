package com.lvmama.vst.back.prod.web.manager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.dubbo.common.utils.CollectionUtils;
import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.dest.api.common.RequestBody;
import com.lvmama.dest.api.vst.goods.service.IHotelGoodsQueryVstApiService;
import com.lvmama.dest.api.vst.prod.service.IHotelProductQrVstApiService;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.po.BizEnum;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;

/**
 * 产品经理归属人变更Action Created by yangzhenzhong on 2016/5/3.
 */
@Controller
@RequestMapping("/prod/managerChange")
public class ProductManagerChangeAction  extends BaseActionSupport{

	private static final Log LOG = LogFactory
			.getLog(ProductManagerChangeAction.class);

	@Autowired
	private ProdProductClientService prodProductService;

	@Autowired
	private SuppGoodsClientService suppGoodsService;

	@Autowired
	private ComLogClientService comLogService;
	@Autowired
	private PermUserServiceAdapter permUserServiceAdapter;

	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;

	@Autowired
	private IHotelGoodsQueryVstApiService hotelGoodsQueryVstApiService;

	@Autowired
	private IHotelProductQrVstApiService hotelProductQrVstApiService;

	@RequestMapping(value = "/showManagerChangeMain")
	public String showManagerChangeTab(Model model) throws BusinessException {

		return "/prod/managerChange/managerTab";
	}
	
	@RequestMapping(value = "/showManagerChange")
	public String showManagerChangeMain(Model model) throws BusinessException {

		return "/prod/managerChange/managerChangeNew";
	}


	@RequestMapping(value = "/findProductList")
	public String findProductList(Model model, Integer page, String oldManagerName, Long oldManagerId, String categoryId, String[] buArray,
								  HttpServletRequest req, String productIds) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<findProductList>");
		}
		Map<String, Object> paramProdProduct = new HashMap<String, Object>();
		List<Long> prodIds = new ArrayList<Long>();
		//获取修改产品列表
		if (StringUtils.isNotBlank(productIds)) {
			String[] strs = productIds.split("\\D");
			if (null != strs && strs.length > 0) {
				for (int i = 0; i < strs.length; i++) {
					if (StringUtil.isNumber(strs[i])) {
						try {
							prodIds.add(Long.valueOf(strs[i]));
						} catch (Exception e) {
						}
					}
				}
			}
			if (CollectionUtils.isNotEmpty(prodIds)) {
				paramProdProduct.put("productIds", prodIds);
			}
		}
		paramProdProduct.put("managerId", oldManagerId);
		if (buArray != null && buArray.length > 0) {
			paramProdProduct.put("buArray", buArray);
			model.addAttribute("buArray", buArray[0]);
		}
		if(StringUtil.isEmptyString(categoryId)){
			paramProdProduct.put("bizCategoryIdArray", new String[]{BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCategoryId().toString(),
					BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCategoryId().toString(),
					BizEnum.BIZ_CATEGORY_TYPE.category_route_local.getCategoryId().toString(),
					BizEnum.BIZ_CATEGORY_TYPE.category_route_hotelcomb.getCategoryId().toString()});
		}
		paramProdProduct.put("bizCategoryId", categoryId);
		int count = prodProductService.findProdProductCountOnly(paramProdProduct).getReturnContent();

		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 15, pagenum);
		pageParam.buildUrl(req);
		paramProdProduct.put("_start", pageParam.getStartRows());
		paramProdProduct.put("_end", pageParam.getEndRows());
		paramProdProduct.put("_orderby", "PRODUCT_ID");
		paramProdProduct.put("_order", "DESC");

		List<ProdProduct> list = prodProductService
				.findSimpleProdProductListByManager(paramProdProduct);
		for (ProdProduct prodProduct : list) {
			BizCategory bizCat =bizCategoryQueryService.getCategoryById(prodProduct.getBizCategoryId());
			prodProduct.setBizCategoryName(bizCat.getCategoryName());
			PermUser user = permUserServiceAdapter.getPermUserByUserId(prodProduct.getManagerId());
			if (user != null) {
				prodProduct.setManagerName(user.getRealName());
			}
		}
		pageParam.setItems(list);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("auditTypeList", ProdProduct.AUDITTYPE.values()); // 审批状态列表
		model.addAttribute("categoryId", categoryId);
		if (CollectionUtils.isNotEmpty(prodIds)) {
			model.addAttribute("productIds", productIds);
			model.addAttribute("selectProductRadioFlag", "checked");
		}
		if (oldManagerId != null && oldManagerId > 0L) {
			try {
				PermUser user = permUserServiceAdapter.getPermUserByUserId(oldManagerId);
				if (user != null)
					model.addAttribute("oldManagerName", user.getRealName());
			} catch (Exception e){
				LOG.error("findProductList ERROR:"+ e.getMessage());
			}
			model.addAttribute("oldManagerId", oldManagerId);
			model.addAttribute("selectProductRadioFlag", "");
		}

		return "/prod/managerChange/managerChangeNew";
	}


	@RequestMapping(value = "/doChangeManager")
	@ResponseBody
	public Object doChangeManager(Model model, Long oldManagerId, String[] productIdList, String type,
								  Long newManagerId, String categoryId, String[] buArray, String oldManagerName, String newManagerName)
			throws BusinessException {
		if((oldManagerId==null || oldManagerName=="") && (productIdList == null && productIdList.length == 0)){
			return new ResultMessage("paramException", "参数异常，产品经理和产品id不能同时为空！");
		}
		if(oldManagerId !=null){
			try {
				PermUser user = permUserServiceAdapter.getPermUserByUserId(oldManagerId);
				if (user != null)
					oldManagerName = user.getRealName();
			} catch (Exception e){
				LOG.error("doChangeManager error :"+e.getMessage());
			}
		}
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, Object> logParams = new HashMap<String, Object>();
		if (!"all".equals(type)) {
			params.put("productIdLst", productIdList);
			params.put("productIdList", productIdList);
		}
		int productCount =0;
		if (buArray != null && buArray.length > 0) {
			logParams.put("buArray", buArray);
			params.put("buArray", buArray);
		}
		params.put("managerId", oldManagerId);
		if(StringUtil.isEmptyString(categoryId)){
			params.put("bizCategoryIdArray", new String[]{BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCategoryId().toString(),
					BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCategoryId().toString(),
					BizEnum.BIZ_CATEGORY_TYPE.category_route_local.getCategoryId().toString(),
					BizEnum.BIZ_CATEGORY_TYPE.category_route_hotelcomb.getCategoryId().toString()});
			params.put("bizCategoryIdLst",new String[]{BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCategoryId().toString(),
					BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCategoryId().toString(),
					BizEnum.BIZ_CATEGORY_TYPE.category_route_local.getCategoryId().toString(),
					BizEnum.BIZ_CATEGORY_TYPE.category_route_hotelcomb.getCategoryId().toString()});
		}
		params.put("bizCategoryId", categoryId);
		productCount = prodProductService.findProdProductCountOnly(params).getReturnContent();

		logParams.put("bizCategoryId", categoryId);
		logParams.put("oldManagerName", oldManagerName);
		logParams.put("newManagerName", newManagerName);
		logParams.put("managerId", oldManagerId);
		logParams.put("oldManagerId", oldManagerId);
		logParams.put("productCount", productCount);
		logParams.put("productIdList", productIdList);

		//酒店商品数量
		int suppGoodsCount=0;

		if (!StringUtil.isEmptyString(categoryId))
			params.put("categoryId",categoryId);
		suppGoodsCount = suppGoodsService.findSuppGoodsCount(params).getReturnContent();
		logParams.put("suppGoodsCount", suppGoodsCount);

		params.put("oldManagerId", oldManagerId);
		params.put("newManagerId", newManagerId);

		try {
			String content =addOperationContent(logParams);
				//非酒店
				if (!StringUtil.isEmptyString(categoryId))
					params.put("categoryId", categoryId);
				suppGoodsService.updateBatchSuppGoodsManager(params);
				prodProductService.updateBatchProdProductManager(params);

			if(productCount>0||suppGoodsCount>0){	//添加操作日志
				comLogService.insert(COM_LOG_OBJECT_TYPE.MANAGER_CHANGE_OPRATE, oldManagerId, 567891L, getLoginUserId(), content, COM_LOG_LOG_TYPE.MANAGER_CHANGE_CATEORYSANDGOODS.name(), "产品经理变更操作", null);
			}
		} catch (BusinessException e) {
			LOG.error("oldManagerId="+oldManagerId+",categoryId="+categoryId+",doChangeManager error:"+e.getMessage());
			return ResultMessage.UPDATE_FAIL_RESULT;
		}
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

	//查询操作日志

	@RequestMapping(value = "/queryOpeatorOfChangeManager")
	@ResponseBody
	public Object queryOpeatorOfChangeManager(Model model, Long oldManagerId, String categoryId, String[] buArray,
											  String oldManagerName, String newManagerName, String type, String[] productIdList){
		Map<String, Object> params = new HashMap<String, Object>();
		RequestBody<Map<String, Object>> responseBody = new RequestBody();
		if (!"all".equals(type)) {
			if (productIdList == null || productIdList.length == 0) {
				return new ResultMessage("NoSelected", "NoSelected");
			}
			params.put("productIdLst", productIdList);
			params.put("productIdList", productIdList);
		}
		if((oldManagerId==null || oldManagerName=="") && (productIdList == null && productIdList.length == 0)){
			return new ResultMessage("paramException", "参数异常，产品经理和产品id不能同时为空！");
		}
		if(oldManagerId!=null){
			try {
				PermUser user = permUserServiceAdapter.getPermUserByUserId(oldManagerId);
				if (user != null)
					oldManagerName = user.getRealName();
			} catch (Exception e){}
		}
		Map<String, Object> logParams = new HashMap<String, Object>();
		if (productIdList != null && productIdList.length > 0) {
			logParams.put("productIdList", productIdList);
		}
		logParams.put("categoryId", categoryId);
		logParams.put("oldManagerName", oldManagerName);
		logParams.put("newManagerName", newManagerName);
		logParams.put("managerId", oldManagerId);
		logParams.put("oldManagerId", oldManagerId);
		params.put("managerId", oldManagerId);
		if (buArray != null && buArray.length > 0) {
			params.put("buArray", buArray);
		}
		int productCount =0 ;
		params.put("bizCategoryId", categoryId);
		if(StringUtil.isEmptyString(categoryId)){
			params.put("bizCategoryIdArray", new String[]{BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCategoryId().toString(),
					BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCategoryId().toString(),
					BizEnum.BIZ_CATEGORY_TYPE.category_route_local.getCategoryId().toString(),
					BizEnum.BIZ_CATEGORY_TYPE.category_route_hotelcomb.getCategoryId().toString()});
			params.put("bizCategoryIdLst",new String[]{BizEnum.BIZ_CATEGORY_TYPE.category_route_group.getCategoryId().toString(),
					BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCategoryId().toString(),
					BizEnum.BIZ_CATEGORY_TYPE.category_route_local.getCategoryId().toString(),
					BizEnum.BIZ_CATEGORY_TYPE.category_route_hotelcomb.getCategoryId().toString()});
		}
		productCount = prodProductService.findProdProductCountOnly(params).getReturnContent();
		logParams.put("productCount", productCount);
		if (!"all".equals(type)) {
			params.put("productIdLst", productIdList);
			params.put("productIdList", productIdList);
		}
		int suppGoodsCount = 0;
		if (!StringUtil.isEmptyString(categoryId)) {
			params.put("categoryId", categoryId);
		}
		suppGoodsCount = suppGoodsService.findSuppGoodsCount(params).getReturnContent();

		logParams.put("suppGoodsCount", suppGoodsCount);
		logParams.put("productIdList", productIdList);
		if(suppGoodsCount==0&& productCount==0){
			return new ResultMessage("bothNone", "bothNone");
		}

		String confirmContent = addOperationContent(logParams);

		return  new ResultMessage("confirmContent",confirmContent);
	}

	public String addOperationContent(Map<String, Object> logParams) {
		StringBuffer stBuf = new StringBuffer();
		String oldManagerName = logParams.get("oldManagerName") == null?null:logParams.get("oldManagerName").toString();
		String[] productIdList = (String[])logParams.get("productIdList");
		if(oldManagerName !=null && oldManagerName!=""){

			stBuf.append("变更【").append((String) logParams.get("oldManagerName"))
					.append("】名下的");
			String bizCategoryId = (String) logParams.get("bizCategoryId");
			int productCount = (int) logParams.get("productCount");
			stBuf.append(productCount+"个");
			String categoryName = "";
			if (bizCategoryId != null && !bizCategoryId.equals("")) {
				BizCategory bizCat = bizCategoryQueryService.getCategoryById(Long.valueOf(bizCategoryId));
				categoryName = bizCat.getCategoryName();
				stBuf.append("【"+categoryName+"】");
			}
			stBuf.append("产品 ");
			int suppGoodsCount  =(Integer)logParams.get("suppGoodsCount");
			stBuf.append(suppGoodsCount+"个");
			if(categoryName!=null&&!"".equals(categoryName)){
				stBuf.append("【"+categoryName+"】");
			}
			stBuf.append("商品 ");
			stBuf.append("至【"+(String)logParams.get("newManagerName")+"】");
		}else {

			if (productIdList != null && productIdList.length > 0) {
				String productIdsStr = "";
				for(int i=0;i<productIdList.length ;i++){
					if(i == productIdList.length-1){
						productIdsStr = productIdsStr+ productIdList[i] ;
					}else {
						productIdsStr = productIdsStr+ productIdList[i] + ",";
					}
				}
				stBuf.append("变更产品【").append(productIdsStr)
						.append("】至【").append((String)logParams.get("newManagerName")+"】");
			}
		}
		return stBuf.toString();
	}

	@RequestMapping(value="/showManager")
	public String showManager(Model model, HttpServletRequest req) throws BusinessException {
		model.addAttribute("type", req.getParameter("type"));
		return "/prod/managerChange/showManager";
	}
}
