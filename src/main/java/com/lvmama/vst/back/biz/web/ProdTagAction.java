package com.lvmama.vst.back.biz.web;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import scala.actors.threadpool.Arrays;
import com.alibaba.fastjson.JSON;
import com.lvmama.visa.api.service.VisaProdProductBranchService;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.po.BizEnum;
import com.lvmama.vst.back.biz.po.BizTag;
import com.lvmama.vst.back.biz.po.BizTagGroup;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.client.biz.service.CategoryClientService;
import com.lvmama.vst.back.client.biz.service.ProdTagClientService;
import com.lvmama.vst.back.client.biz.service.TagClientService;
import com.lvmama.vst.back.client.biz.service.TagGroupClientService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductBranch;
import com.lvmama.vst.back.prod.po.ProdTag;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.prod.vo.ProdTagVO;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.pub.service.PushAdapterServiceRemote;
import com.lvmama.vst.back.utils.ListUtil;
import com.lvmama.vst.comlog.LvmmLogClientService;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.jms.Message;
import com.lvmama.vst.comm.jms.TopicMessageProducer;
import com.lvmama.vst.comm.jms.MessageFactory;
import com.lvmama.comm.vo.ConstantJMS;
import com.lvmama.vst.back.utils.MiscUtils;


@SuppressWarnings({ "rawtypes", "unchecked" })
@Controller
@RequestMapping("/biz/prodTag")
public class ProdTagAction extends BaseActionSupport {

	private static final long serialVersionUID = -6198856582225829130L;

	private final Logger logger = LoggerFactory.getLogger(ProdTagAction.class);

	@Autowired
	private TagClientService tagClientService;
	@Autowired
	private ProdTagClientService prodTagClientService;
	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;
	@Autowired
	private CategoryClientService categoryService;
	@Autowired
	private PushAdapterServiceRemote pushAdapterService;
	@Autowired
	private LvmmLogClientService lvmmLogClientService;
	@Autowired
	private ProdProductClientService prodProductService;
	@Autowired
	private SuppGoodsClientService suppGoodsService;
	
	@Autowired
	private VisaProdProductBranchService visaProdProductBranchServiceRemote;
	
	@Autowired
	private TopicMessageProducer prodTagToDestMessageProducer;
	
	@Autowired
	private TagGroupClientService tagGroupClientService;

	/**
	 * 显示标签管理页面头
	 */
	@RequestMapping(value = "/findTagManagement")
	public String findTagManagement(Model model) {
		
		model.addAttribute("selectedTab", "prodTab");
		return "/biz/prodTag/tagManagement";
	}
	
	/**
	 * 显示查询产品与标签的关联信息页面
	 */
	@RequestMapping(value = "/showProdTagList")
	public String showProdTagList(Model model, @RequestParam String objectType, @RequestParam String tagGroup, 
			HttpServletRequest req) throws BusinessException, UnsupportedEncodingException {
		
			ProdTagVO prodTagVO = new ProdTagVO();
			Map<String, Object> map = new HashMap<String, Object>();
			
			// 标签组查询
			String paramTagGroup = null;
			if(StringUtils.isNotEmpty(tagGroup)) {
				paramTagGroup = URLDecoder.decode(tagGroup, "utf-8");
			}
			
			if(("品牌").equals(paramTagGroup)) {
				map.put("tagGroupName", "品牌");
				// prodTagVO.setTagGroup("全部");
			} else {
				map.put("excludeTagGroupName", "品牌");
			}
			
			ResultHandleT<List<BizTagGroup>> resultHandleT = tagGroupClientService.findTagGroupByConditons(map);
			if(resultHandleT == null || resultHandleT.isFail()) {
				logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
				throw new BusinessException(resultHandleT.getMsg());
			}
			List<BizTagGroup> tagGroups = resultHandleT.getReturnContent();
			if (("品牌").equals(paramTagGroup) && tagGroups.size() == 0) {
				logger.error("No Brand Tag Group is detected...");
				throw new BusinessException("数据库没有品牌小组的产品");
			}
			model.addAttribute("tagGroups", tagGroups);
			
			// 查询顶层品类ID
			List<BizCategory> bizCategorys = bizCategoryQueryService.getAllParentCategorys();
			List<BizCategory> dtos = new ArrayList<BizCategory>();
			if (null != bizCategorys && !bizCategorys.isEmpty()) {
				for (BizCategory bizCategory : bizCategorys) {
					String code = bizCategory.getCategoryCode();
					if (!code.equalsIgnoreCase("category_insurance") && !code.equalsIgnoreCase("category_addition")) {
						dtos.add(bizCategory);
					}
				}
			}
			model.addAttribute("bizCategorys", dtos);
			model.addAttribute("prodTagVO", prodTagVO);
			
			if(("品牌").equals(paramTagGroup)){				
				return "/biz/prodTag/findBrandTagList";
			} else if(("SUPP_GOODS").equals(objectType)) {
				return "/biz/prodTag/findSuppGoodsTagList";
			} else if(("PROD_PRODUCT_BRANCH").equals(objectType)) {
				return "/biz/prodTag/findProdBranchTagList";
			} else {
				return "/biz/prodTag/findProdTagList";
			}
	}
	

	/**
	 * 查询产品与标签的关联信息
	 */
	@RequestMapping(value = "/findProdTagList")
	public String findProdTagList(Model model, Integer page, ProdTagVO prodTagVO, HttpServletRequest req) throws BusinessException {

		// 查询小组名称
		Map<String, Object> map = new HashMap<String, Object>();
		
		ResultHandleT<List<BizTagGroup>> resultHandleT = tagGroupClientService.findTagGroupByConditons(map);
		if(resultHandleT == null || resultHandleT.isFail()){
			logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		List<BizTagGroup> tagGroups = resultHandleT.getReturnContent();
		model.addAttribute("tagGroups", tagGroups);

		// 查询顶层品类ID
		List<BizCategory> bizCategorys = bizCategoryQueryService.getAllParentCategorys();
		List<BizCategory> dtos = new ArrayList<BizCategory>();
		Map<Long, List<Long>> childCategoryIds = new HashMap<Long, List<Long>>();
		if (null != bizCategorys && !bizCategorys.isEmpty()) {
			for (BizCategory bizCategory : bizCategorys) {
				String code = bizCategory.getCategoryCode();
				if (!code.equalsIgnoreCase("category_insurance") && !code.equalsIgnoreCase("category_addition")) {
					dtos.add(bizCategory);
					List<Long> categoryIds = new ArrayList<Long>();
					Map<String, Object> bizParams = new HashMap<String, Object>();
					bizParams.put("parentId", bizCategory.getCategoryId());
					List<BizCategory> cateGorys = categoryService.findCategoryList(bizParams);
					if (null != cateGorys && !cateGorys.isEmpty() && !bizCategory.getCategoryId().equals(17L) && !bizCategory.getCategoryId().equals(18L) && !bizCategory.getCategoryId().equals(1L)) {
						for (int i = 0; i < cateGorys.size(); i++) {
							categoryIds.add(cateGorys.get(i).getCategoryId());
						}
					} else {
						categoryIds.add(bizCategory.getCategoryId());
					}
					childCategoryIds.put(bizCategory.getCategoryId(), categoryIds);
				}
			}
		}
		model.addAttribute("bizCategorys", dtos);

		// 查询标签配置信息
		Map<String, Object> prodTagPams = new HashMap<String, Object>();
		Map<String, Object> params = new HashMap<String, Object>();
		int size = 0;
		if (null != prodTagVO) {
			Long tagGroupId = prodTagVO.getTagGroupId();
			String tagName = prodTagVO.getTagName();
			if (StringUtil.isNotEmptyString(tagName) || (tagGroupId!=null && tagGroupId > 0L)) {
				prodTagPams.put("tagGroupId", prodTagVO.getTagGroupId());// 小组名称
				prodTagPams.put("tagName", prodTagVO.getTagName());// 标签名称
				prodTagPams.put("objectType", prodTagVO.getObjectType());
				params.put("selectParams", "true"); // 是否查询标签信息
				ResultHandleT<List<Long>> resultHandleT4ProductId = prodTagClientService.selectForProdTagUnion(prodTagPams);
				if(resultHandleT4ProductId == null || resultHandleT4ProductId.isFail()){
					logger.error(resultHandleT4ProductId == null ? "ResultHandleT is empty..." : resultHandleT4ProductId.getMsg());
					throw new BusinessException(resultHandleT4ProductId.getMsg());
				}
				List<Long> productIdList = resultHandleT4ProductId.getReturnContent() == null ? new ArrayList<Long>() : resultHandleT4ProductId.getReturnContent();
				List<List<Long>> productListArr = new ArrayList<List<Long>>();
				if(CollectionUtils.isEmpty(productIdList)){
					productIdList = new ArrayList<Long>();
					productIdList.add(-1l);
					productListArr.add(productIdList);
				}else {
					Integer count = 0;
					Integer total = productIdList.size();
					List<Long> tempList = new ArrayList<Long>();
					for(Long productId : productIdList){
						count++;
						if(count%999 == 0  || count.equals(total)){
							tempList.add(productId);
							productListArr.add(tempList);
							tempList = new ArrayList<Long>();
						}else {
							tempList.add(productId);
						}
					}
				}
				params.put("productListArr", productListArr);
			}

			params.put("productName", prodTagVO.getProductName());// 产品名称
			// 顶层品类IDS
			String categoryName = prodTagVO.getCategoryName();
			if (StringUtil.isNumber(categoryName)) {
				// 查询顶层品类对应的子品类
				List<Long> bizIds = childCategoryIds.get(Long.valueOf(categoryName));
				params.put("categoryIds", bizIds.toArray());// 品类ID
			} else {
				Long[] ids = new Long[] { 1L, 2L, 4L, 8L, 11L, 12L, 13L, 15L, 16L, 17L, 18L, 42L };
				params.put("categoryIds", ids);// 品类ID
			}
			// 产品编号
			String productIds = prodTagVO.getProductIds();
			if (StringUtil.isNotEmptyString(productIds)) {
				String[] strs = productIds.split("\\D");
				size = 0;
				StringBuffer strBf = new StringBuffer();
				if (null != strs && strs.length > 0) {
					List<Long> prodIds = new ArrayList<Long>();
					for (int i = 0; i < strs.length; i++) {
						if (StringUtil.isNumber(strs[i])) {
							try {
								prodIds.add(Long.valueOf(strs[i]));
								size++;
							} catch (Exception e) {
							}
						}
					}
					if (size > 0) {
						for (Long pid : prodIds) {
							strBf.append(pid).append(",");
						}
						params.put("productIds", prodIds.toArray());
						prodTagVO.setProductIds(strBf.toString());
					} else {
						params.put("productIds", new Long[] { -1L });
						prodTagVO.setProductIds(strBf.append(productIds).append(",").toString());
					}
				} else {
					params.put("productIds", new Long[] { -1L });
					prodTagVO.setProductIds(strBf.append(productIds).append(",").toString());
				}
			}
		}

		Integer count = prodProductService.selectProdProductTagCountByParams(params);
		int pagenum = page == null ? 1 : page;
		Page pageParam = null;
		// 输入产品ID时不需要分页
		if (size <= 0) {
			pageParam = Page.page(count, 100, pagenum);
			pageParam.buildUrl(req);
			params.put("_start", pageParam.getStartRows());
			params.put("_end", pageParam.getEndRows());
			params.put("_orderby", "PP.PRODUCT_ID");
			params.put("_order", "DESC");
		} else {
			pageParam = Page.page(count, 10000L, pagenum);
			pageParam.buildUrl(req);
		}
		List<ProdProduct> list = prodProductService.selectProdProductTagByParams(params);
		pageParam.setItems(list);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("page", pageParam.getPage().toString());
		model.addAttribute("prodTagVO", prodTagVO);

		return "/biz/prodTag/findProdTagList";
	}

	/**
	 * 查询商品与标签的关联信息
	 */
	@RequestMapping(value = "/findSuppTagList")
	public String findSuppTagList(Model model, Integer page, ProdTagVO prodTagVO, HttpServletRequest req) throws BusinessException {

		// 查询小组名称
		Map<String, Object> map = new HashMap<String, Object>();
		ResultHandleT<List<BizTagGroup>> resultHandleT = tagGroupClientService.findTagGroupByConditons(map);
		if(resultHandleT == null || resultHandleT.isFail()){
			logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		List<BizTagGroup> tagGroups = resultHandleT.getReturnContent();
		model.addAttribute("tagGroups", tagGroups);

		// 查询标签配置信息
		Map<String, Object> suppTagParams = new HashMap<String, Object>();
		Map<String, Object> params = new HashMap<String, Object>();
		int size = 0;
		if (null != prodTagVO) {
			Long tagGroupId = prodTagVO.getTagGroupId();
			String tagName = prodTagVO.getTagName();
			if (StringUtil.isNotEmptyString(tagName) || (tagGroupId!=null && tagGroupId > 0L)) {
				suppTagParams.put("tagGroupId", prodTagVO.getTagGroupId());// 小组名称
				suppTagParams.put("tagName", prodTagVO.getTagName());
				suppTagParams.put("objectType", prodTagVO.getObjectType());// 标签名称
				params.put("selectParams", "true"); // 是否查询标签信息
				ResultHandleT<List<Long>> resultHandleT4SuppGoodsId = prodTagClientService.selectForProdTagUnion(suppTagParams);
				if(resultHandleT4SuppGoodsId == null || resultHandleT4SuppGoodsId.isFail()){
					logger.error(resultHandleT4SuppGoodsId == null ? "ResultHandleT is empty..." : resultHandleT4SuppGoodsId.getMsg());
					throw new BusinessException(resultHandleT4SuppGoodsId.getMsg());
				}
				List<Long> suppGoodsIdList = resultHandleT4SuppGoodsId.getReturnContent() == null ? new ArrayList<Long>() : resultHandleT4SuppGoodsId.getReturnContent();
				List<List<Long>> suppGoodsIdListArr = new ArrayList<List<Long>>();
				if(CollectionUtils.isEmpty(suppGoodsIdList)){
					suppGoodsIdList = new ArrayList<Long>();
					suppGoodsIdList.add(-1l);
					suppGoodsIdListArr.add(suppGoodsIdList);
				}else {
					Integer count = 0;
					Integer total = suppGoodsIdList.size();
					List<Long> tempList = new ArrayList<Long>();
					for(Long suppGoodsId : suppGoodsIdList){
						count++;
						if(count%999 == 0  || count.equals(total)){
							tempList.add(suppGoodsId);
							suppGoodsIdListArr.add(tempList);
							tempList = new ArrayList<Long>();
						}else {
							tempList.add(suppGoodsId);
						}
					}
				}
				params.put("suppGoodsIdListArr", suppGoodsIdListArr);
			}
			params.put("goodsName", prodTagVO.getGoodsName());// 商品名称
			// 顶层品类IDS
			String categoryName = prodTagVO.getCategoryName();
			if(StringUtil.isNotEmptyString(categoryName) && Integer.valueOf(categoryName).intValue()==BizEnum.BIZ_CATEGORY_TYPE.category_ticket.getCategoryId()){
				Long[] categoryIds = new Long[]{11L,12L,13L};
				params.put("categoryIds", categoryIds);// 门票子品类
			}else if(StringUtil.isNotEmptyString(categoryName) && Integer.valueOf(categoryName).intValue()==BizEnum.BIZ_CATEGORY_TYPE.category_hotel.getCategoryId()){
				Long[] categoryIds = new Long[]{1L};
				params.put("categoryIds", categoryIds);
			}
			// 商品编号
			String suppGoodsIds = prodTagVO.getSuppGoodsIds();
			if (StringUtil.isNotEmptyString(suppGoodsIds)) {
				String[] strs = suppGoodsIds.split("\\D");
				size = 0;
				StringBuffer strBf = new StringBuffer();
				if (null != strs && strs.length > 0) {
					List<Long> prodIds = new ArrayList<Long>();
					for (int i = 0; i < strs.length; i++) {
						if (StringUtil.isNumber(strs[i])) {
							try {
								prodIds.add(Long.valueOf(strs[i]));
								size++;
							} catch (Exception e) {
							}
						}
					}
					if (size > 0) {
						for (Long pid : prodIds) {
							strBf.append(pid).append(",");
						}
						params.put("suppGoodsIds", prodIds.toArray());
						prodTagVO.setSuppGoodsIds(strBf.toString());
					} else {
						params.put("suppGoodsIds", new Long[] { -1L });
						prodTagVO.setSuppGoodsIds(strBf.append(suppGoodsIds).append(",").toString());
					}
				} else {
					params.put("suppGoodsIds", new Long[] { -1L });
					prodTagVO.setSuppGoodsIds(strBf.append(suppGoodsIds).append(",").toString());
				}
			}
		}

		Integer count = MiscUtils.autoUnboxing(suppGoodsService.selectSuppGoodsTagCountByParams(params));
		int pagenum = page == null ? 1 : page;
		Page pageParam = null;
		// 输入商品ID时不需要分页
		if (size <= 0) {
			pageParam = Page.page(count, 100, pagenum);
			pageParam.buildUrl(req);
			params.put("_start", pageParam.getStartRows());
			params.put("_end", pageParam.getEndRows());
			params.put("_orderby", "SP.SUPP_GOODS_ID");
			params.put("_order", "DESC");
		} else {
			pageParam = Page.page(count, 10000L, pagenum);
			pageParam.buildUrl(req);
		}
		List<SuppGoods> list = MiscUtils.autoUnboxing(suppGoodsService.selectSuppGoodsTagByParams(params));
		pageParam.setItems(list);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("page", pageParam.getPage().toString());
		model.addAttribute("prodTagVO", prodTagVO);

		return "/biz/prodTag/findSuppGoodsTagList";
	}

	/**
	 * 查询品牌与标签的关联信息
	 */
	@RequestMapping(value = "/findBrandTagList")
	public String findBrandTagList(Model model, Integer page, ProdTagVO prodTagVO, HttpServletRequest req) throws BusinessException {

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cancelFlag", "Y");
		map.put("tagGroupName", "品牌");
		ResultHandleT<List<BizTagGroup>> resultHandleT = tagGroupClientService.findTagGroupByConditons(map);
		if (resultHandleT == null || resultHandleT.isFail()) {
			logger.error(resultHandleT == null ? "ResultHandleT is empty...": resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		List<BizTagGroup> tagGroups = resultHandleT.getReturnContent();
		model.addAttribute("tagGroups", tagGroups);

		// 查询顶层品类ID
		List<BizCategory> bizCategorys = bizCategoryQueryService.getAllParentCategorys();
		List<BizCategory> dtos = new ArrayList<BizCategory>();
		Map<Long, List<Long>> childCategoryIds = new HashMap<Long, List<Long>>();

		if (null != bizCategorys && !bizCategorys.isEmpty()) {
			for (BizCategory bizCategory : bizCategorys) {
				String code = bizCategory.getCategoryCode();
				if (!code.equalsIgnoreCase("category_insurance")&& !code.equalsIgnoreCase("category_addition")) {
					dtos.add(bizCategory);
					List<Long> categoryIds = new ArrayList<Long>();
					Map<String, Object> bizParams = new HashMap<String, Object>();
					bizParams.put("parentId", bizCategory.getCategoryId());
					List<BizCategory> cateGorys = categoryService.findCategoryList(bizParams);
					if (null != cateGorys && !cateGorys.isEmpty()&& !bizCategory.getCategoryId().equals(17L) && !bizCategory.getCategoryId().equals(18L)
							&& !bizCategory.getCategoryId().equals(1L)) {
						for (int i = 0; i < cateGorys.size(); i++) {
							categoryIds.add(cateGorys.get(i).getCategoryId());
						}
					} else {
						categoryIds.add(bizCategory.getCategoryId());
					}
					childCategoryIds.put(bizCategory.getCategoryId(), categoryIds);
				}
			}
		}
		model.addAttribute("bizCategorys", dtos);

		// 查询标签配置信息
		Map<String, Object> prodTagPams = new HashMap<String, Object>();
		Map<String, Object> params = new HashMap<String, Object>();
		int size = 0;

		if (null != prodTagVO) {
			Long tagGroupId = prodTagVO.getTagGroupId();
			String tagName = prodTagVO.getTagName();
			if (StringUtil.isNotEmptyString(tagName) || (tagGroupId!=null && tagGroupId > 0L)) {
				prodTagPams.put("tagGroupId", prodTagVO.getTagGroupId());// 小组名称
				prodTagPams.put("tagName", prodTagVO.getTagName());
				prodTagPams.put("objectType", prodTagVO.getObjectType());// 标签名称
				params.put("selectParams", "true"); // 是否查询标签信息
				ResultHandleT<List<Long>> resultHandleT4ProductId = prodTagClientService.selectForProdTagUnion(prodTagPams);
				if (resultHandleT4ProductId == null || resultHandleT4ProductId.isFail()) {
					logger.error(resultHandleT4ProductId == null ? "ResultHandleT is empty...": resultHandleT4ProductId.getMsg());
					throw new BusinessException(resultHandleT4ProductId.getMsg());
				}

				List<Long> productIdList = resultHandleT4ProductId.getReturnContent() == null ? new ArrayList<Long>() : resultHandleT4ProductId.getReturnContent();
				List<List<Long>> productListArr = new ArrayList<List<Long>>();
				if (resultHandleT4ProductId.getReturnContent() == null || resultHandleT4ProductId.getReturnContent().size() == 0) {
					productIdList = new ArrayList<Long>();
					productIdList.add(-1L);
					productListArr.add(productIdList);
				} else {
					Integer count = 0;
					Integer total = productIdList.size();
					List<Long> tempList = new ArrayList<Long>();
					for(Long productId : productIdList){
						count++;
						if(count%999 == 0  || count.equals(total)){
							tempList.add(productId);
							productListArr.add(tempList);
							tempList = new ArrayList<Long>();
						}else {
							tempList.add(productId);
						}
					}
				}

				params.put("productListArr", productListArr);
			}

			params.put("productName", prodTagVO.getProductName());// 产品名称
			// 顶层品类IDS
			String categoryName = prodTagVO.getCategoryName();
			if (StringUtil.isNumber(categoryName)) {
				// 查询顶层品类对应的子品类
				List<Long> bizIds = childCategoryIds.get(Long.valueOf(categoryName));
				params.put("categoryIds", bizIds.toArray());// 品类ID
			} else {
				Long[] ids = new Long[] { 1L, 2L, 4L, 8L, 11L, 12L, 13L, 15L,
						16L, 17L, 18L, 42L };
				params.put("categoryIds", ids);// 品类ID
			}
			// 产品编号
			String productIds = prodTagVO.getProductIds();
			if (StringUtil.isNotEmptyString(productIds)) {
				String[] strs = productIds.split("\\D");
				size = 0;
				StringBuffer strBf = new StringBuffer();
				if (null != strs && strs.length > 0) {
					List<Long> prodIds = new ArrayList<Long>();
					for (int i = 0; i < strs.length; i++) {
						if (StringUtil.isNumber(strs[i])) {
							try {
								prodIds.add(Long.valueOf(strs[i]));
								size++;
							} catch (Exception e) {
							}
						}
					}
					if (size > 0) {
						for (Long pid : prodIds) {
							strBf.append(pid).append(",");
						}
						params.put("productIds", prodIds.toArray());
						prodTagVO.setProductIds(strBf.toString());
					} else {
						params.put("productIds", new Long[] { -1L });
						prodTagVO.setProductIds(strBf.append(productIds)
								.append(",").toString());
					}
				} else {
					params.put("productIds", new Long[] { -1L });
					prodTagVO.setProductIds(strBf.append(productIds).append(",").toString());
				}
			}
		}

		Integer count = prodProductService.selectProdProductTagCountByParams(params);
		int pagenum = page == null ? 1 : page;
		Page pageParam = null;
		// 输入产品ID时不需要分页
		if (size <= 0) {
			pageParam = Page.page(count, 100, pagenum);
			pageParam.buildUrl(req);
			params.put("_start", pageParam.getStartRows());
			params.put("_end", pageParam.getEndRows());
			params.put("_orderby", "PP.PRODUCT_ID");
			params.put("_order", "DESC");
		} else {
			pageParam = Page.page(count, 10000L, pagenum);
			pageParam.buildUrl(req);
		}
		List<ProdProduct> list = prodProductService
				.selectProdProductTagByParams(params);
		pageParam.setItems(list);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("page", pageParam.getPage().toString());
		model.addAttribute("prodTagVO", prodTagVO);
		model.addAttribute("isBranchTab", "Y");
		
		return "/biz/prodTag/findBrandTagList";
	}
	
	
	/**
	 * 查询规格与标签的关联信息
	 */
	@RequestMapping(value = "/findProdBranchTagList")
	public String findProdBranchTagList(Model model, Integer page, ProdTagVO prodTagVO, HttpServletRequest req) throws BusinessException {

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cancelFlag", "Y");
		
		final BizCategory visaCategory = bizCategoryQueryService.getCategoryByCode("category_visa");
		
		ResultHandleT<List<BizTagGroup>> resultHandleT = tagGroupClientService.findTagGroupByConditons(map);
		if (resultHandleT == null || resultHandleT.isFail()) {
			logger.error(resultHandleT == null ? "ResultHandleT is empty...": resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		List<BizTagGroup> tagGroups = resultHandleT.getReturnContent();
		model.addAttribute("tagGroups", tagGroups);

		
		// 查询品类
		if(visaCategory!=null) {
			List<BizCategory> bizCategorys = new ArrayList<BizCategory>();
			bizCategorys.add(bizCategoryQueryService.getCategoryByCode("category_visa"));
			model.addAttribute("bizCategorys", bizCategorys);
		} else {
			logger.error("数据库端无签证品类");
			throw new BusinessException("数据库端无签证品类");
		}		
		

		// 查询标签配置信息
		Map<String, Object> prodBranchTagParams = new HashMap<String, Object>();
		Map<String, Object> params = new HashMap<String, Object>();
		int size = 0;

		if (null != prodTagVO) {
			Long tagGroupId = prodTagVO.getTagGroupId();
			String tagName = prodTagVO.getTagName();
			if (StringUtil.isNotEmptyString(tagName) || (tagGroupId != null && tagGroupId > 0L)) {
				prodBranchTagParams.put("tagGroupId", prodTagVO.getTagGroupId());// 小组名称
				prodBranchTagParams.put("tagName", prodTagVO.getTagName());// 标签名称
				prodBranchTagParams.put("objectType", prodTagVO.getObjectType());
				
				ResultHandleT<List<Long>> resultHandleT4ProductId = prodTagClientService.selectForProdTagUnion(prodBranchTagParams);
				if (resultHandleT4ProductId == null || resultHandleT4ProductId.isFail()) {
					logger.error(resultHandleT4ProductId == null ? "ResultHandleT is empty...": resultHandleT4ProductId.getMsg());
					throw new BusinessException(resultHandleT4ProductId.getMsg());
				}

				List<Long> productBranchIdList = resultHandleT4ProductId.getReturnContent() == null ? new ArrayList<Long>() : resultHandleT4ProductId.getReturnContent();
				
				if (resultHandleT4ProductId.getReturnContent() == null || resultHandleT4ProductId.getReturnContent().size() == 0) {
					productBranchIdList = new ArrayList<Long>();
					productBranchIdList.add(-1L);
				} 

				params.put("productBranchIdList", productBranchIdList);
			}

			
			if(0L < visaCategory.getCategoryId()) {
				params.put("categtoryId", visaCategory.getCategoryId());
			}
			
			String branchName = prodTagVO.getBranchName();
			if(StringUtil.isNotEmptyString(branchName)) {
				params.put("equalBranchName", branchName);
			}
			
			
			// 规格ID
			String branchIds = prodTagVO.getBranchIds();
			if (StringUtil.isNotEmptyString(branchIds)) {
				String[] strs = branchIds.split("\\D");
				size = 0;
				StringBuffer strBf = new StringBuffer();
				if (null != strs && strs.length > 0) {
					List<Long> brchIds = new ArrayList<Long>();
					for (int i = 0; i < strs.length; i++) {
						if (StringUtil.isNumber(strs[i])) {
							try {
								brchIds.add(Long.valueOf(strs[i]));
								size++;
							} catch (Exception e) {
							}
						}
					}
					if (size > 0) {
						for (Long pid : brchIds) {
							strBf.append(pid).append(",");
						}
						params.put("selectParams", "true"); 
						params.put("selectedBranchIdList", brchIds.toArray());
						prodTagVO.setBranchIds(strBf.toString());
					} else {
						params.put("selectedBranchIdList", new Long[] { -1L });
						prodTagVO.setBranchIds(strBf.append(branchIds)
								.append(",").toString());
					}
				} else {
					params.put("selectedBranchIdList", new Long[] { -1L });
					prodTagVO.setBranchIds(strBf.append(branchIds).append(",").toString());
				}
			}
		}

		Integer count = visaProdProductBranchServiceRemote.findProdProductBranchCount(params).getReturnContent();
		int pagenum = page == null ? 1 : page;
		Page pageParam = null;
		// 输入产品ID时不需要分页
		if (size <= 0) {
			pageParam = Page.page(count, 100, pagenum);
			pageParam.buildUrl(req);
			params.put("_start", pageParam.getStartRows() > 0L? pageParam.getStartRows() - 1L : 0L);
			params.put("_end", pageParam.getEndRows());
			params.put("_orderby", "ppb.BRANCH_ID");
			params.put("_order", "DESC");
		} else {
			pageParam = Page.page(count, 10000L, pagenum);
			pageParam.buildUrl(req);
		}

		String resultMessage = visaProdProductBranchServiceRemote.findProdProductBranchList(params).getReturnContent();
		List<ProdProductBranch> list = JSON.parseArray(resultMessage, ProdProductBranch.class);  
		
		pageParam.setItems(list);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("page", pageParam.getPage().toString());
		model.addAttribute("prodTagVO", prodTagVO);

		return "/biz/prodTag/findProdBranchTagList";
	}

	/**
	 * 跳转到保存页面
	 */
	@RequestMapping(value = "/showAddProdTag")
	public String showAddProdTag(Model model, ProdTagVO prodTagVO) throws BusinessException {

		// 查询小组名称
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (prodTagVO.getTagGroupId() != null && prodTagVO.getTagGroupId() > 0L) {
			Long tagGroupId = prodTagVO.getTagGroupId();
			ResultHandleT<BizTagGroup> bizTagGroupHandleT = tagGroupClientService.findTagGroupByTagGroupId(tagGroupId);
			if(bizTagGroupHandleT == null || bizTagGroupHandleT.isFail()) {
				logger.error(bizTagGroupHandleT == null ? "ResultHandleT is empty..." : bizTagGroupHandleT.getMsg());
				throw new BusinessException(bizTagGroupHandleT.getMsg());
			}
			
			BizTagGroup bizTagGroup = bizTagGroupHandleT.getReturnContent();
			if(bizTagGroup != null && "品牌".equals(bizTagGroup.getTagGroupName())) {
				map.put("tagGroupId", bizTagGroup.getTagGroupId());
			} else {
				map.put("excludeTagGroupName", "品牌");
			}
		} else {
			map.put("excludeTagGroupName", "品牌");
		}
		
		map.put("cancelFlag", "Y");
		ResultHandleT<List<BizTagGroup>> resultHandleT = tagGroupClientService.findTagGroupByConditons(map);
		if(resultHandleT == null || resultHandleT.isFail()){
			logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		List<BizTagGroup> tagGroups = resultHandleT.getReturnContent();
		model.addAttribute("tagGroups", tagGroups);
		model.addAttribute("prodTagVO", prodTagVO);

		return "/biz/prodTag/showSaveProdTag";
	}

	/**
	 * 新增标签与产品或商品的关联信息
	 */
	@RequestMapping(value = "/saveProdTag")
	@ResponseBody
	public Object saveProdTag(ProdTagVO prodTagVO) throws BusinessException {
		
		if (null != prodTagVO) {
			Long objectId = prodTagVO.getObjectId();
			if (null != objectId && objectId > 0) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tagGroupId", prodTagVO.getTagGroupId());
				params.put("tagName", prodTagVO.getTagName());
				// 根据小组名称、标签名称查询标签信息
				ResultHandleT<List<BizTag>> resultHandleT = tagClientService.findBizTagListByParams(params);
				if(resultHandleT == null || resultHandleT.isFail()){
					logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
					throw new BusinessException(resultHandleT.getMsg());
				}
				List<BizTag> bizTags = resultHandleT.getReturnContent();
				if (null != bizTags && !bizTags.isEmpty()) {
					for (BizTag bizTag : bizTags) {
						ProdTag prodTag = new ProdTag();
						prodTag.setObjectId(objectId);
						prodTag.setObjectType(prodTagVO.getObjectType());
						prodTag.setTagId(bizTag.getTagId());
						prodTag.setStartTime(prodTagVO.getStartTime());
						prodTag.setEndTime(prodTagVO.getEndTime());
						prodTag.setDisplaytype(prodTagVO.getDisplaytype());
						prodTag.setBrandTagGroup(prodTagVO.isBrandTagGroup());
						// 新增产品或商品与标签的关联信息
						try {
							ResultHandleT<Integer> integerResultHandleT = prodTagClientService.addProdTag(prodTag, true);
							if(integerResultHandleT == null || integerResultHandleT.isFail()){
								logger.error(integerResultHandleT == null ? "ResultHandleT is empty...": integerResultHandleT.getMsg());
								return new ResultMessage(ResultMessage.ERROR, integerResultHandleT.getMsg());
							}
							int result = integerResultHandleT.getReturnContent() == null ? 0 : integerResultHandleT.getReturnContent();
							if (result != 0) {
								try {
									String startTime = prodTagVO.getStartTime() != null ? new SimpleDateFormat("yyyy-MM-dd").format(prodTagVO.getStartTime()) : null;
									String endTime = prodTagVO.getEndTime() != null ? new SimpleDateFormat("yyyy-MM-dd").format(prodTagVO.getEndTime()) : null;
									lvmmLogClientService.sendLog(getComLogType(prodTagVO.getObjectType()),
											objectId, objectId, getLoginUser() != null ? getLoginUser().getUserName() : null,
											"添加了标签：【" + bizTag.getTagName() + "】 " + "标签有效期：【" + startTime + "~" + endTime + "】"+ "  显示位置：" + convertDisplayType(prodTagVO.getDisplaytype()),
											COM_LOG_LOG_TYPE.TAG_ADD.name(), "添加标签", null);
								} catch (Exception e) {
									log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.TAG_ADD.name());
									log.error(e.getMessage());
								}
							}
						} catch (BusinessException e) {
							return new ResultMessage("error", e.getMessage());
						}
					}
					ComPush.OBJECT_TYPE pushObjectType = ComPush.OBJECT_TYPE.PRODUCT;
					if ("SUPP_GOODS".equals(prodTagVO.getObjectType())) {
						pushObjectType = ComPush.OBJECT_TYPE.GOODS;
					} else if("PROD_PRODUCT_BRANCH".equals(prodTagVO.getObjectType())) {
						pushObjectType = ComPush.OBJECT_TYPE.PRODUCTBRANCH;
					}
					pushAdapterService.push(objectId, pushObjectType, ComPush.PUSH_CONTENT.PROD_TAG, ComPush.OPERATE_TYPE.UP,
							ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
				}
			}
		}
		return ResultMessage.ADD_SUCCESS_RESULT;
	}

	/**
	 * 批量新增标签与产品或商品的关联信息
	 */
	@RequestMapping(value = "/saveBatchProdTag")
	@ResponseBody
	public Object saveBatchProdTag(ProdTagVO prodTagVO) throws BusinessException {
		
		if (null != prodTagVO) {
			Long[] objectIds = prodTagVO.getObjectIds();
			if (null != objectIds && objectIds.length > 0) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tagGroupId", prodTagVO.getTagGroupId());
				params.put("tagName", prodTagVO.getTagName());
				// 根据小组名称、标签名称查询标签信息
				ResultHandleT<List<BizTag>> resultHandleT = tagClientService.findBizTagListByParams(params);
				if(resultHandleT == null || resultHandleT.isFail()){
					logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
					throw new BusinessException(resultHandleT.getMsg());
				}
				
				List<BizTag> bizTags = resultHandleT.getReturnContent();
				if (null != bizTags && !bizTags.isEmpty()) {
					for (BizTag bizTag : bizTags) {
						for (Long objectId : objectIds) {
							ProdTag prodTag = new ProdTag();
							prodTag.setObjectId(objectId);
							prodTag.setObjectType(prodTagVO.getObjectType());
							prodTag.setTagId(bizTag.getTagId());
							prodTag.setStartTime(prodTagVO.getStartTime());
							prodTag.setEndTime(prodTagVO.getEndTime());
							prodTag.setDisplaytype(prodTagVO.getDisplaytype());
						    prodTag.setBrandTagGroup(prodTagVO.isBrandTagGroup());
							// 新增产品或商品与标签的关联信息
							ResultHandleT<Integer> integerResultHandleT = prodTagClientService.addProdTag(prodTag, false);
							if (integerResultHandleT == null || integerResultHandleT.isFail()) {
								logger.error(integerResultHandleT == null ? "ResultHandleT is empty...": integerResultHandleT.getMsg());
								return new ResultMessage(ResultMessage.ERROR, integerResultHandleT.getMsg());
							}
							int result = integerResultHandleT.getReturnContent() == null ? 0 : integerResultHandleT.getReturnContent();
							if (result != 0) {
								try {
									String startTime = prodTagVO.getStartTime() != null ? new SimpleDateFormat("yyyy-MM-dd").format(prodTagVO.getStartTime()) : null;
									String endTime = prodTagVO.getEndTime() != null ? new SimpleDateFormat("yyyy-MM-dd").format(prodTagVO.getEndTime()) : null;
									
									lvmmLogClientService.sendLog(getComLogType(prodTagVO.getObjectType()),
											objectId, objectId, getLoginUser() != null ? getLoginUser().getUserName() : null,
											"添加了标签：【" + bizTag.getTagName() + "】 " + "标签有效期：【" + startTime + "~" + endTime + "】" + "  显示位置：" + convertDisplayType(prodTagVO.getDisplaytype()),
											COM_LOG_LOG_TYPE.TAG_ADD.name(), "添加标签", null);

								} catch (Exception e) {
									log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.TAG_ADD.name());
									log.error(e.getMessage());
								}
							}
							if ("PROD_PRODUCT".equalsIgnoreCase(prodTag.getObjectType())) {
								pushAdapterService.push(prodTag.getObjectId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_TAG, ComPush.OPERATE_TYPE.UP,
										ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
							} else if("PROD_PRODUCT_BRANCH".equalsIgnoreCase(prodTag.getObjectType())) {
								pushAdapterService.push(prodTag.getObjectId(), ComPush.OBJECT_TYPE.PRODUCTBRANCH, ComPush.PUSH_CONTENT.PROD_TAG, ComPush.OPERATE_TYPE.UP,
										ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
							}
						}
					}
				}
			}
		}
		return ResultMessage.ADD_SUCCESS_RESULT;
	}

	/**
	 * 跳转到删除页面
	 */
	@RequestMapping(value = "/showDelProdTag")
	public String showDelProdTag(Model model, ProdTagVO prodTagVO) throws BusinessException {

		// 查询小组名称
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (prodTagVO.getTagGroupId()!=null && prodTagVO.getTagGroupId() > 0L) {
			ResultHandleT<BizTagGroup> tagGroupResultHandleT = tagGroupClientService.findTagGroupByTagGroupId(prodTagVO.getTagGroupId());
			if(tagGroupResultHandleT == null || tagGroupResultHandleT.isFail()){
				logger.error(tagGroupResultHandleT == null ? "ResultHandleT is empty..." : tagGroupResultHandleT.getMsg());
				throw new BusinessException(tagGroupResultHandleT.getMsg());
			}
			BizTagGroup tagGroup = tagGroupResultHandleT.getReturnContent();
			if("品牌".equals(tagGroup.getTagGroupName())) {
				map.put("tagGroupId", tagGroup.getTagGroupId());
			} else {
				map.put("excludeTagGroupName", "品牌");
			}
		} else {
			map.put("excludeTagGroupName", "品牌");
		}
		
		ResultHandleT<List<BizTagGroup>> resultHandleT = tagGroupClientService.findTagGroupByConditons(map);
		if(resultHandleT == null || resultHandleT.isFail()){
			logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		List<BizTagGroup> tagGroups =resultHandleT.getReturnContent();
		model.addAttribute("tagGroups", tagGroups);
		model.addAttribute("prodTagVO", prodTagVO);
		return "/biz/prodTag/showDelProdTag";
	}

	/**
	 * 批量删除产品或商品与标签的关联信息
	 */
	@RequestMapping(value = "/deleteProdTagByObject")
	@ResponseBody
	public Object deleteProdTagByObject(ProdTagVO prodTagVO, HttpServletRequest req) throws BusinessException {
		
		final int BATCH_DELETE_SIZE = 100;
		int numOfDeletedProdTag = 0;
		Long[] objectIds = prodTagVO.getObjectIds();
		if (null != objectIds && objectIds.length > 0) {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("tagGroupId", prodTagVO.getTagGroupId());
			params.put("tagName", prodTagVO.getTagName());
			params.put("objectType", prodTagVO.getObjectType());
			params.put("objectIds", objectIds);
	
			ResultHandleT<List<ProdTagVO>> prodTagListResultHandleT = prodTagClientService.findProdTagVoListByParams(params);
			if(prodTagListResultHandleT == null || prodTagListResultHandleT.isFail() || prodTagListResultHandleT.getReturnContent().size() == 0){
				logger.error(prodTagListResultHandleT == null ? "ResultHandleT is empty..." : prodTagListResultHandleT.getMsg());
				return ResultMessage.DELETE_FAIL_RESULT;
			}
			List<ProdTagVO> prodTags = prodTagListResultHandleT.getReturnContent();
			
			List<List<ProdTagVO>> prodTagBatchList = ListUtil.splitList(prodTags, BATCH_DELETE_SIZE);
			for(List<ProdTagVO> prodTagVOs : prodTagBatchList) {
				numOfDeletedProdTag += prodTagClientService.deleteProdTag(getReIdsByProdTagVOs(prodTagVOs)).getReturnContent();
			}
			logger.info("Deleted Prod Tags: " + numOfDeletedProdTag);
			sendProdTagDelInfoToQueue(prodTags);
		}
		
		return ResultMessage.DELETE_SUCCESS_RESULT;
	}
	
	private Long[] getReIdsByProdTagVOs(final List<ProdTagVO> prodTagList) {
		
		if(prodTagList==null || prodTagList.size()==0) {
			return null;
		}
		Long[] result = new Long[prodTagList.size()];
		for(int i=0; i < prodTagList.size(); i++) {
			Long reId;
			if((reId = prodTagList.get(i).getReId()) > 0L)
			result[i] = reId;
		}
		return result;
	}
	
	private void sendProdTagDelInfoToQueue(List<ProdTagVO> prodTags){
		
		for(ProdTagVO prodTag : prodTags) {
			if(prodTag != null) {
				String objectType = prodTag.getObjectType();
				String addition = "Object ID:" + prodTag.getObjectId() +", Object Type:" + (prodTag.getObjectType()==null ? "": prodTag.getObjectType())
						+", Tag ID:"+ (prodTag.getTagId()==null ? "": prodTag.getTagId()); 
				Message msg = null;
				lvmmLogClientService.sendLog(getComLogType(prodTag.getObjectType()),
					prodTag.getObjectId(), prodTag.getObjectId(), getLoginUser() != null ? getLoginUser().getUserName() : null, 
					"删除了标签：【" + prodTag.getTagName() + "】", 
					COM_LOG_LOG_TYPE.TAG_DELETE.name(), "删除标签", null);
				
				if ("PROD_PRODUCT".equalsIgnoreCase(objectType)) {
					pushAdapterService.push(prodTag.getObjectId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_TAG, ComPush.OPERATE_TYPE.UP,
							ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
					msg = MessageFactory.newProdTagCommonMessage(ConstantJMS.EVENT_TYPE.VST_PROD_TAG_DELETE.name(), prodTag.getReId(), ComPush.OBJECT_TYPE.PRODUCT.name(), addition);
					prodTagToDestMessageProducer.sendMsg(msg);
				} else if ("SUPP_GOODS".equalsIgnoreCase(objectType)) {
					pushAdapterService.push(prodTag.getObjectId(), ComPush.OBJECT_TYPE.GOODS, ComPush.PUSH_CONTENT.PROD_TAG, ComPush.OPERATE_TYPE.UP,
							ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
					msg = MessageFactory.newProdTagCommonMessage(ConstantJMS.EVENT_TYPE.VST_PROD_TAG_DELETE.name(), prodTag.getReId(), ComPush.OBJECT_TYPE.GOODS.name(), addition);
					prodTagToDestMessageProducer.sendMsg(msg);
				} else if("PROD_PRODUCT_BRANCH".equalsIgnoreCase(objectType)){
					pushAdapterService.push(prodTag.getObjectId(), ComPush.OBJECT_TYPE.PRODUCTBRANCH, ComPush.PUSH_CONTENT.PROD_TAG, ComPush.OPERATE_TYPE.UP,
							ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
					msg = MessageFactory.newProdTagCommonMessage(ConstantJMS.EVENT_TYPE.VST_PROD_TAG_DELETE.name(), prodTag.getReId(), ComPush.OBJECT_TYPE.PRODUCTBRANCH.name(), addition);
					prodTagToDestMessageProducer.sendMsg(msg);
				}
			}
		}
	}


	/**
	 * 删除指定产品或商品与标签关联信息
	 */
	@RequestMapping(value = "/deleteProdTagByReId")
	@ResponseBody
	public Object deleteProdTagByReId(ProdTagVO prodTagVO, HttpServletRequest req) throws BusinessException {
		
		Long[] reIds = prodTagVO.getReIds();
		if (null != reIds && reIds.length > 0) {			
			for(int index=0; index < reIds.length; index ++) {
				Long reId = reIds[index];
				ResultHandleT<ProdTagVO> resultHandleT = prodTagClientService.findProdTagVOById(reId);
				if(resultHandleT == null || resultHandleT.isFail()){
					logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
					throw new BusinessException(resultHandleT.getMsg());
				}
				ProdTagVO prodTag =resultHandleT.getReturnContent();
				ResultHandleT<Integer> deleteResult = prodTagClientService.deleteProdTag(new Long[]{reId});
				if(prodTag != null && deleteResult.getReturnContent() > 0) {
					sendProdTagDelInfoToQueue(Arrays.asList(new ProdTagVO[]{prodTag}));
				} else {
					reIds[index] = -1L;
					continue;
				}
			}
			return ResultMessage.DELETE_SUCCESS_RESULT;
		} else {
			return new ResultMessage("error", "请选择需要删除的信息");
		}
	}

	/**
	 * 跳转到修改页面
	 */
	@RequestMapping(value = "/showUpdateProdTag")
	public String showUpdateProdTag(Model model, ProdTagVO prodTagVO) throws BusinessException {

		model.addAttribute("prodTagVO", prodTagVO);
		return "/biz/prodTag/showUpdateProdTag";
	}
	
	/**
	 * 跳转到标签修改页面-获取数据
	 */
	@RequestMapping(value = "/listUpdateProdTags")
	public String listUpdateProdTags(Model model, String objectType, Long objectId, Long tagGroupId, Integer tagType) throws BusinessException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("objectType", objectType);
		params.put("objectId", objectId);
		params.put("tagType", tagType);
		
		if(tagType!=null) {
			if(tagType.equals(BigDecimal.ONE.intValue())) {
				params.put("expired", "N");
			} else if(tagType.equals(BigDecimal.ZERO.intValue())) {
				params.put("expired", "Y");
			}
		}
		

		if (tagGroupId!=null && tagGroupId > 0L) {
			BizTagGroup bizTagGroup = tagGroupClientService.findTagGroupByTagGroupId(tagGroupId).getReturnContent();
			if("品牌".equals(bizTagGroup.getTagGroupName())) {
				params.put("tagGroupId", bizTagGroup.getTagGroupId());
			} else {
				params.put("excludeTagGroupName", "品牌");
			}
		} else {
			params.put("excludeTagGroupName", "品牌");
		}

		ResultHandleT<List<ProdTagVO>> resultHandleT = prodTagClientService.findProdTagVoListByParams(params);
		if(resultHandleT == null || resultHandleT.isFail()){
			logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		List<ProdTagVO> prodTagVOs = resultHandleT.getReturnContent();
		model.addAttribute("prodTagVOs", prodTagVOs);
		return "/biz/prodTag/selectProdTagsForUpdate";
	}


	/**
	 * 标签操作中修改页面的保存
	 */
	@RequestMapping(value = "/saveUpdateProdTag")
	@ResponseBody
	public Object saveUpdateProdTag(ProdTagVO prodTagVO) throws BusinessException {

		for (ProdTagVO prodTag : prodTagVO.getProdTags()) {
			boolean isSameProdTag = prodTagClientService.selectBySameProdTag(prodTag).getReturnContent();
			if (!isSameProdTag) {
				ResultHandleT<Integer> integerResultHandleT = prodTagClientService.updateByPrimaryKeySelective(prodTag);
				if(integerResultHandleT == null || integerResultHandleT.isFail()){
					logger.error(integerResultHandleT == null ? "ResultHandleT is empty..." : integerResultHandleT.getMsg());
					throw new BusinessException(integerResultHandleT.getMsg());
				}
				int result =integerResultHandleT.getReturnContent() == null ? 0 : integerResultHandleT.getReturnContent();
				if (result != 0) {
					try {
						String startTime = prodTag.getStartTime() != null ? new SimpleDateFormat("yyyy-MM-dd").format(prodTag.getStartTime()) : null;
						String endTime = prodTag.getEndTime() != null ? new SimpleDateFormat("yyyy-MM-dd").format(prodTag.getEndTime()) : null;

						lvmmLogClientService
							.sendLog(getComLogType(prodTag.getObjectType()),
									prodTag.getObjectId(),
									prodTag.getObjectId(),
									getLoginUser() != null ? getLoginUser().getUserName() : null,
									"修改标签起止时间：【" + prodTag.getTagName() + "】 " + "标签有效期：【" + startTime + "~" + endTime + "】，显示位置："
											+ convertDisplayType(prodTag.getDisplaytype()), COM_LOG_LOG_TYPE.TAG_ADD.name(), "修改起止时间", null);

					} catch (Exception e) {
						log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.TAG_ADD.name());
						log.error(e.getMessage());
					}
				}
				if ("PROD_PRODUCT".equalsIgnoreCase(prodTag.getObjectType())) {
					pushAdapterService.push(prodTag.getObjectId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_TAG, ComPush.OPERATE_TYPE.UP,
						ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
				} else if ("PROD_PRODUCT_BRANCH".equalsIgnoreCase(prodTag.getObjectType())) {
					pushAdapterService.push(prodTag.getObjectId(), ComPush.OBJECT_TYPE.PRODUCTBRANCH, ComPush.PUSH_CONTENT.PROD_TAG, ComPush.OPERATE_TYPE.UP,
						ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
				}
			}
		}

		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

	/**
	 * 标签操作中修改页面的保存
	 */
	@RequestMapping(value = "/saveUpdateProdTagTimes")
	@ResponseBody
	public Object saveUpdateProdTagTimes(ProdTagVO prodTagVO) throws BusinessException {

		if (null != prodTagVO) {
			Long[] objectIds = prodTagVO.getObjectIds();
			if (null != objectIds && objectIds.length > 0) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tagGroup", prodTagVO.getTagGroup());
				params.put("tagName", prodTagVO.getTagName());
				// 根据小组名称、标签名称查询标签信息

				int noTagCout = 0;

				ResultHandleT<List<BizTag>> resultHandleTList = tagClientService.findBizTagListByParams(params);
				if(resultHandleTList == null || resultHandleTList.isFail()){
					logger.error(resultHandleTList == null ? "ResultHandleT is empty..." : resultHandleTList.getMsg());
					throw new BusinessException(resultHandleTList.getMsg());
				}
				List<BizTag> bizTags = resultHandleTList.getReturnContent();
				if (null != bizTags && !bizTags.isEmpty()) {
					for (BizTag bizTag : bizTags) {
						for (Long objectId : objectIds) {
							ProdTag prodTag = new ProdTag();
							prodTag.setObjectId(objectId);
							prodTag.setObjectType(prodTagVO.getObjectType());
							prodTag.setTagId(bizTag.getTagId());
							if (prodTagVO.getStartTime() != null) {
								prodTag.setStartTime(prodTagVO.getStartTime());
							}
							
							if(prodTagVO.getEndTime() != null) {
								prodTag.setEndTime(prodTagVO.getEndTime());
							}
							
							if(prodTagVO.getDisplaytype()!=null && prodTagVO.getDisplaytype() > 0L) {
								prodTag.setDisplaytype(prodTagVO.getDisplaytype());
							}
							
							// 修改产品或商品与标签的关联起止时间
							ResultHandleT<List<ProdTag>> resultHandleT = prodTagClientService.selectByProdTag(prodTag);
							if(resultHandleT == null || resultHandleT.isFail()){
								logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
								throw new BusinessException(resultHandleT.getMsg());
							}
							List<ProdTag> tags = resultHandleT.getReturnContent();

							if (tags.size() >= 1) {
								ResultHandleT<Integer> integerResultHandleT = prodTagClientService.updateProdTagTime(prodTag);
								if(integerResultHandleT == null || integerResultHandleT.isFail()){
									logger.error(integerResultHandleT == null ? "ResultHandleT is empty..." : integerResultHandleT.getMsg());
									throw new BusinessException(integerResultHandleT.getMsg());
								}
								int result =integerResultHandleT.getReturnContent() == null ? 0 : integerResultHandleT.getReturnContent();
								if (result != 0) {
									try {
										String startTime = prodTagVO.getStartTime() != null ? new SimpleDateFormat("yyyy-MM-dd").format(prodTagVO.getStartTime()) : null;
										String endTime = prodTagVO.getEndTime() != null ? new SimpleDateFormat("yyyy-MM-dd").format(prodTagVO.getEndTime()) : null;
										COM_LOG_OBJECT_TYPE logType = getComLogType(prodTagVO.getObjectType());
										if(StringUtil.isNotEmptyString(startTime) && StringUtil.isNotEmptyString(endTime)) {
											lvmmLogClientService.sendLog(logType, objectId, objectId,
												getLoginUser() != null ? getLoginUser().getUserName() : null,
												"修改标签起止时间：【" + bizTag.getTagName() + "】 " + "标签有效期：【" + startTime + "~" + endTime + "】", COM_LOG_LOG_TYPE.TAG_ADD.name(),
												"修改起止时间", null);
										}
										
										if(prodTagVO.getDisplaytype() != null && prodTagVO.getDisplaytype() > 0L) {
											lvmmLogClientService.sendLog(logType, objectId, objectId,
												getLoginUser() != null ? getLoginUser().getUserName() : null, "修改了标签：【" + bizTag.getTagName() + "】，修改内容："
														+ convertDisplayType(prodTagVO.getDisplaytype()), COM_LOG_LOG_TYPE.TAG_UPDATE.name(), "修改标签显示位置", null);
										}
									} catch (Exception e) {
										log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.TAG_ADD.name());
										log.error(e.getMessage());
									}
								}
								if ("PROD_PRODUCT".equalsIgnoreCase(prodTag.getObjectType())) {
									pushAdapterService.push(prodTag.getObjectId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_TAG, ComPush.OPERATE_TYPE.UP,
											ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
								} else if("PROD_PRODUCT_BRANCH".equalsIgnoreCase(prodTag.getObjectType())){
									pushAdapterService.push(prodTag.getObjectId(), ComPush.OBJECT_TYPE.PRODUCTBRANCH, ComPush.PUSH_CONTENT.PROD_TAG, ComPush.OPERATE_TYPE.UP,
											ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
								}

							} else {
								noTagCout++;
							}
						}
					}
				}
				if (noTagCout == objectIds.length) {
					return new ResultMessage("error", "选中产品无此标签");
				}
			}
		}
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}
	
	/**
	 * 跳转到标签修改时间页面
	 */
	@RequestMapping(value = "/showUpdateProdTagTime")
	public String showUpdateProdTagTime(Model model, ProdTagVO prodTagVO) throws BusinessException {
		// 查询小组名称
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("excludeTagGroupName", "品牌");
		ResultHandleT<List<BizTagGroup>> resultHandleTList = tagGroupClientService.findTagGroupByConditons(map);
		if(resultHandleTList == null || resultHandleTList.isFail()){
			logger.error(resultHandleTList == null ? "ResultHandleT is empty..." : resultHandleTList.getMsg());
			throw new BusinessException(resultHandleTList.getMsg());
		}
		List<BizTagGroup> tagGroups =resultHandleTList.getReturnContent();
		model.addAttribute("tagGroups", tagGroups);
		model.addAttribute("prodTagVO", prodTagVO);

		return "/biz/prodTag/showUpdateProdTagTime";
	}

	/**
	 * 跳转到品牌标签修改页面 
	 */
	@RequestMapping(value = "/showUpdateTagTimePosition")
	public String showUpdateTagTimePosition(Model model, ProdTagVO prodTagVO)
			throws BusinessException {
		// 查询小组名称
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (prodTagVO.getTagGroupId()!=null && prodTagVO.getTagGroupId() > 0L) {
			ResultHandleT<BizTagGroup> tagGroupHandleTResult = tagGroupClientService.findTagGroupByTagGroupId(prodTagVO.getTagGroupId());
			if (tagGroupHandleTResult == null || tagGroupHandleTResult.isFail()) {
				logger.error(tagGroupHandleTResult == null ? "ResultHandleT is empty..."
							: tagGroupHandleTResult.getMsg());
				throw new BusinessException(tagGroupHandleTResult.getMsg());
			}
			BizTagGroup bizTagGroup = tagGroupHandleTResult.getReturnContent();
			if("品牌".equals(bizTagGroup.getTagGroupName())) {
				map.put("tagGroupId", bizTagGroup.getTagGroupId());
			} else {
				map.put("excludeTagGroupName", "品牌");
			}
		} else {
			map.put("excludeTagGroupName", "品牌");
		}
		
		ResultHandleT<List<BizTagGroup>> resultHandleTList = tagGroupClientService.findTagGroupByConditons(map);
		if (resultHandleTList == null || resultHandleTList.isFail()) {
			logger.error(resultHandleTList == null ? "ResultHandleT is empty..."
					: resultHandleTList.getMsg());
			throw new BusinessException(resultHandleTList.getMsg());
		}
		List<BizTagGroup> tagGroups = resultHandleTList.getReturnContent();

		model.addAttribute("tagGroups", tagGroups);
		model.addAttribute("prodTagVO", prodTagVO);

		return "/biz/prodTag/showUpdateTagTimePosition";
	}

	/**
	 * 修改指定产品或商品与标签起止时间
	 */
	@RequestMapping(value = "/saveUpdateProdTagTime")
	@ResponseBody
	public Object saveUpdateProdTagTime(ProdTagVO prodTagVO) throws BusinessException {
		if (null != prodTagVO) {
			Long[] objectIds = prodTagVO.getObjectIds();
			if (null != objectIds && objectIds.length > 0) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tagGroupId", prodTagVO.getTagGroupId());
				params.put("tagName", prodTagVO.getTagName());
				// 根据小组名称、标签名称查询标签信息

				int noTagCout = 0;

				ResultHandleT<List<BizTag>> resultHandleTList = tagClientService.findBizTagListByParams(params);
				if(resultHandleTList == null || resultHandleTList.isFail()){
					logger.error(resultHandleTList == null ? "ResultHandleT is empty..." : resultHandleTList.getMsg());
					throw new BusinessException(resultHandleTList.getMsg());
				}
				List<BizTag> bizTags =resultHandleTList.getReturnContent();
				if (null != bizTags && !bizTags.isEmpty()) {
					for (BizTag bizTag : bizTags) {
						for (Long objectId : objectIds) {
							ProdTag prodTag = new ProdTag();
							prodTag.setObjectId(objectId);
							prodTag.setObjectType(prodTagVO.getObjectType());
							prodTag.setTagId(bizTag.getTagId());
							if(prodTagVO.getStartTime()!=null) {
								prodTag.setStartTime(prodTagVO.getStartTime());
							}
							
							if(prodTagVO.getEndTime()!=null) {
								prodTag.setEndTime(prodTagVO.getEndTime());
							}
							
							if(prodTagVO.getDisplaytype()!=null && 0L < prodTagVO.getDisplaytype()) {
								prodTag.setDisplaytype(prodTagVO.getDisplaytype());
							}

							// 修改产品或商品与标签的关联起止时间
							ResultHandleT<List<ProdTag>> resultHandleT = prodTagClientService.selectByProdTag(prodTag);
							if(resultHandleT == null || resultHandleT.isFail()){
								logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
								throw new BusinessException(resultHandleT.getMsg());
							}
							List<ProdTag> tags =resultHandleT.getReturnContent();

							if (tags.size() >= 1) {
								ResultHandleT<Integer> resultHandleTCount = prodTagClientService.updateProdTagTime(prodTag);
								if(resultHandleTCount == null || resultHandleTCount.isFail()){
									logger.error(resultHandleTCount == null ? "ResultHandleT is empty..." : resultHandleTCount.getMsg());
									throw new BusinessException(resultHandleTCount.getMsg());
								}
								int result = resultHandleTCount.getReturnContent() == null ? 0 : resultHandleTCount.getReturnContent();
								if (result != 0) {
									try {
										String startTime = prodTagVO.getStartTime() != null ? new SimpleDateFormat("yyyy-MM-dd").format(prodTagVO.getStartTime()) : null;
										String endTime = prodTagVO.getEndTime() != null ? new SimpleDateFormat("yyyy-MM-dd").format(prodTagVO.getEndTime()) : null;

										lvmmLogClientService.sendLog(getComLogType(prodTagVO.getObjectType()), objectId, objectId,
												getLoginUser() != null ? getLoginUser().getUserName() : null,
												"修改标签起止时间：【" + bizTag.getTagName() + "】 " + "标签有效期：【" + startTime + "~" + endTime + "】", COM_LOG_LOG_TYPE.TAG_ADD.name(),
												"修改起止时间", null);
									} catch (Exception e) {
										log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.TAG_ADD.name());
										log.error(e.getMessage());
									}
								}
								if ("PROD_PRODUCT".equalsIgnoreCase(prodTag.getObjectType())) {
									pushAdapterService.push(prodTag.getObjectId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_TAG, ComPush.OPERATE_TYPE.UP,
											ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
								} else if("PROD_PRODUCT_BRANCH".equalsIgnoreCase(prodTag.getObjectType())){
									pushAdapterService.push(prodTag.getObjectId(), ComPush.OBJECT_TYPE.PRODUCTBRANCH, ComPush.PUSH_CONTENT.PROD_TAG, ComPush.OPERATE_TYPE.UP,
											ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
								}

							} else {
								noTagCout++;
							}
						}
					}
				}
				if (noTagCout == objectIds.length) {
					return new ResultMessage("error", "选中产品无此标签");
				}
			}
		}
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

	/**
	 * 跳转到标签修改时间页面
	 */
	@RequestMapping(value = "/showUpdateProdTagDisplay")
	public String showUpdateProdTagDisplay(Model model, ProdTagVO prodTagVO) throws BusinessException {
		// 查询小组名称
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cancelFlag", "Y");
		map.put("excludeTagGroupName", "品牌");
		ResultHandleT<List<BizTagGroup>> resultHandleT = tagGroupClientService.findTagGroupByConditons(map);
		if(resultHandleT == null || resultHandleT.isFail()){
			logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		List<BizTagGroup> tagGroups =resultHandleT.getReturnContent();
		model.addAttribute("tagGroups", tagGroups);
		model.addAttribute("prodTagVO", prodTagVO);

		return "/biz/prodTag/showUpdateProdTagDisplay";
	}

	/**
	 * 修改指定产品或商品与标签显示位置
	 */
	@RequestMapping(value = "/saveUpdateProdTagDisplay")
	@ResponseBody
	public Object saveUpdateProdTagDisplay(ProdTagVO prodTagVO) throws BusinessException {
		if (null != prodTagVO) {
			Long[] objectIds = prodTagVO.getObjectIds();
			if (null != objectIds && objectIds.length > 0) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tagGroupId", prodTagVO.getTagGroupId());
				params.put("tagName", prodTagVO.getTagName());
				// 根据小组名称、标签名称查询标签信息

				int noTagCout = 0;

				ResultHandleT<List<BizTag>> resultHandleTList = tagClientService.findBizTagListByParams(params);
				if(resultHandleTList == null || resultHandleTList.isFail()){
					logger.error(resultHandleTList == null ? "ResultHandleT is empty..." : resultHandleTList.getMsg());
					throw new BusinessException(resultHandleTList.getMsg());
				}
				List<BizTag> bizTags = resultHandleTList.getReturnContent();
				if (null != bizTags && !bizTags.isEmpty()) {
					for (BizTag bizTag : bizTags) {
						for (Long objectId : objectIds) {
							ProdTag prodTag = new ProdTag();
							prodTag.setObjectId(objectId);
							prodTag.setObjectType(prodTagVO.getObjectType());
							prodTag.setTagId(bizTag.getTagId());
							prodTag.setStartTime(prodTagVO.getStartTime());
							prodTag.setEndTime(prodTagVO.getEndTime());
							prodTag.setDisplaytype(prodTagVO.getDisplaytype());

							// 修改产品或商品与标签的显示位置
							ResultHandleT<List<ProdTag>> resultHandleT = prodTagClientService.selectByProdTag(prodTag);
							if(resultHandleT == null || resultHandleT.isFail()){
								logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
								throw new BusinessException(resultHandleT.getMsg());
							}
							List<ProdTag> tags = resultHandleT.getReturnContent();
							if (null != tags) {
								if (tags.size() == 1) {
									ResultHandleT<Integer> resultHandleTCount = prodTagClientService.updateProdTagTime(prodTag);
									if(resultHandleTCount == null || resultHandleTCount.isFail()){
										logger.error(resultHandleTCount == null ? "ResultHandleT is empty..." : resultHandleTCount.getMsg());
										throw new BusinessException(resultHandleTCount.getMsg());
									}
									int result = resultHandleTCount.getReturnContent() == null ? 0 : resultHandleTCount.getReturnContent();
									if (result != 0) {
										try {
											ProdTag oldProdTag = tags.get(0);
											// 获取操作日志
											String logContent = getTagChangeLog(oldProdTag, prodTag);
											// 添加操作日志
											if (null != logContent && !"".equals(logContent)) {

												lvmmLogClientService.sendLog(getComLogType(prodTagVO.getObjectType()), oldProdTag
																.getObjectId(), oldProdTag.getObjectId(),
														getLoginUser() != null ? getLoginUser().getUserName() : null, "修改了标签：【" + bizTag.getTagName() + "】，修改内容："
																+ logContent, COM_LOG_LOG_TYPE.TAG_UPDATE.name(), "修改标签显示位置", null);

											}

										} catch (Exception e) {
											log.error("Record Log failure ！Log type:" + COM_LOG_LOG_TYPE.TAG_ADD.name());
											log.error(e.getMessage());
										}
									}
									if ("PROD_PRODUCT".equalsIgnoreCase(prodTag.getObjectType())) {
										pushAdapterService.push(prodTag.getObjectId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_TAG,
												ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
									} else if("PROD_PRODUCT_BRANCH".equalsIgnoreCase(prodTag.getObjectType())) {
										pushAdapterService.push(prodTag.getObjectId(), ComPush.OBJECT_TYPE.PRODUCTBRANCH, ComPush.PUSH_CONTENT.PROD_TAG,
												ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
									}

								} else {
									noTagCout++;
								}
							}
						}
					}
				}
				if (noTagCout == objectIds.length) {
					return new ResultMessage("error", "选中产品无此标签");
				}
			}
		}
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

	// 拼接日志内容
	private String getTagChangeLog(ProdTag oldProdTag, ProdTag prodTag) {
		StringBuffer logStr = new StringBuffer("");
		if (null != prodTag) {
			logStr.append(ComLogUtil.getLogTxt("显示位置", convertDisplayType(prodTag.getDisplaytype()), convertDisplayType(oldProdTag.getDisplaytype())));
		}
		return logStr.toString();
	}

	private String convertDisplayType(long displaytype) {
		if (1 == displaytype) {
			return "【PC端】";
		}
		if (2 == displaytype) {
			return "【无线端】";
		}
		if (3 == displaytype) {
			return "【PC端，无线端】";
		}
		return "【】";
	}
	

	private COM_LOG_OBJECT_TYPE getComLogType(String objectType) {
		
		switch(objectType) {
			
			case "PROD_PRODUCT":
				return COM_LOG_OBJECT_TYPE.PROD_TAG;
			case "SUPP_GOODS":
				return COM_LOG_OBJECT_TYPE.SUPP_GOODS_TAG;
			case "PROD_PRODUCT_BRANCH":
				return COM_LOG_OBJECT_TYPE.PROD_BRANCH_TAG;
			default:
				throw new BusinessException("missing object type");
		}
		
	}
}