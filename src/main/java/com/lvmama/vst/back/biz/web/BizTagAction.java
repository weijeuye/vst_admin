package com.lvmama.vst.back.biz.web;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import joptsimple.internal.Strings;

import com.lvmama.vst.back.client.biz.service.IMsgMultiLangClientService;
import com.lvmama.vst.back.client.biz.service.ProdTagClientService;
import com.lvmama.vst.back.client.biz.service.TagClientService;
import com.lvmama.vst.back.client.biz.service.TagGroupClientService;
import com.lvmama.vst.comlog.LvmmLogClientService;
import com.lvmama.vst.comm.utils.web.HttpServletLocalThread;
import com.lvmama.vst.comm.vo.ResultHandleT;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.comm.utils.DateUtil;
import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.po.BizEnum;
import com.lvmama.vst.back.biz.po.BizTag;
import com.lvmama.vst.back.biz.po.BizTagGroup;
import com.lvmama.vst.back.biz.po.MuitlLangMessage;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdTag;
import com.lvmama.vst.back.prod.service.ProdProductQueryService;
import com.lvmama.vst.back.prod.vo.BizTagGroupVO;
import com.lvmama.vst.back.prod.vo.BizTagVO;
import com.lvmama.vst.back.prod.vo.MultiLangMessageVO;
import com.lvmama.vst.back.prod.vo.ProdTagVO;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.pub.service.PushAdapterServiceRemote;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;

@SuppressWarnings({ "rawtypes", "unchecked" })
@Controller
@RequestMapping("/biz/bizTag")
public class BizTagAction extends BaseActionSupport {

	private static final long serialVersionUID = -6198856582225829130L;
	private static final String EMPTY_COMMIT_FAIL = "提交失败，请填写修改内容！";
	private static final String DEFAULT_LANG_MSG_LINK_TEXT = "配置多语言[英文，繁体中文，韩文，日文]";

	private final Logger logger = LoggerFactory.getLogger(BizTagAction.class);

	@Autowired
	private TagClientService tagClientService;
	
	@Autowired
	private ProdTagClientService prodTagClientService;
	
	@Autowired
	private PushAdapterServiceRemote pushAdapterService;
	
	@Autowired
	private ProdProductQueryService prodProductQueryService;
	
	@Autowired
	private SuppGoodsClientService suppGoodsService;
	
	@Autowired
	private LvmmLogClientService lvmmLogClientService;
	
	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;
	
	@Autowired
	private TagGroupClientService tagGroupClientService;
	
	@Autowired
	private IMsgMultiLangClientService iMsgMultiLangClientService;

	/**
	 * 根据小组名称查询小组标签
	 */
	@RequestMapping(value = "/findTagNameByGroup")
	@ResponseBody
	public Object findTagNameByGroup(Long tagGroupId, HttpServletResponse res) throws BusinessException {
		// 查询标签名称
		ResultHandleT<List<BizTag>> listResultHandleT = tagClientService.findBizTagNameByGroup(tagGroupId);
		if(listResultHandleT == null || listResultHandleT.isFail()){
			logger.error(listResultHandleT == null ? "ResultHandleT is empty..." : listResultHandleT.getMsg());
			throw new BusinessException(listResultHandleT.getMsg());
		}
		List<BizTag> tagNames = listResultHandleT.getReturnContent();
		JSONArray array = new JSONArray();
		if (tagNames != null && tagNames.size() > 0) {
			for (BizTag bizTag : tagNames) {
				JSONObject obj = new JSONObject();
				obj.put("tagName", bizTag.getTagName());
				array.add(obj);
			}
		}
		return array;
	}

	/**
	 * 根据小组名称查询有效小组标签
	 */
	@RequestMapping(value = "/findAllTagNameByGroup")
	@ResponseBody
	public Object findAllTagNameByGroup(String iniAll, String isAll, Long tagGroupId, HttpServletResponse res) throws BusinessException {
		// 查询标签名称
		try {
			// tagGroup = (tagGroup == "" ? tagGroup : URLDecoder.decode(tagGroup, "UTF-8"));
			iniAll = (iniAll == null ? iniAll : URLDecoder.decode(iniAll, "UTF-8"));
		} catch (UnsupportedEncodingException e) {
		}

		ResultHandleT<List<BizTag>> resultHandleT = null;
		BizTag tag = new BizTag();
		tag.setTagGroupId(tagGroupId);
		if ("Y".equals(isAll)) {
			resultHandleT = tagClientService.findBizAllTagNameByGroup(tag);
		} else {
			tag.setCancelFlag("Y");
			resultHandleT = tagClientService.findBizAllTagNameByGroup(tag);
		}
		if(resultHandleT == null || resultHandleT.isFail()){
			logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		List<BizTag> tagNames = resultHandleT.getReturnContent();
		JSONArray array = new JSONArray();
		if (null != iniAll) {
			JSONObject obj1 = new JSONObject();
			obj1.put("tagValue", "");
			obj1.put("tagName", iniAll);
			array.add(obj1);
		}

		if (tagNames != null && tagNames.size() > 0) {
			for (BizTag bizTag : tagNames) {
				JSONObject obj = new JSONObject();
				obj.put("tagValue", bizTag.getTagName());
				obj.put("tagName", bizTag.getTagName());
				array.add(obj);
			}
		}
		return array;
	}

	/**
	 * 查看标签管理的产品与商品信息
	 */
	@RequestMapping(value = "/findProdTagByTagId")
	public String findProdTagByTagId(Model model, Integer page, ProdTagVO prodTagVO, HttpServletRequest req) throws BusinessException {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("objectType", prodTagVO.getObjectType());
		params.put("tagId", prodTagVO.getTagId());

		ResultHandleT<Integer> resultHandleTCount = prodTagClientService.selectProdTagTotalCount(params);
		if(resultHandleTCount == null || resultHandleTCount.isFail()){
			logger.error(resultHandleTCount == null ? "ResultHandleT is empty..." : resultHandleTCount.getMsg());
			throw new BusinessException(resultHandleTCount.getMsg());
		}
		int count = resultHandleTCount.getReturnContent() == null ? 0 : resultHandleTCount.getReturnContent();
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 20, pagenum);
		pageParam.buildUrl(req);
		params.put("_start", pageParam.getStartRowsMySql());
		params.put("_pageSize", pageParam.getPageSize());
		params.put("_orderby", "TAG_ID");
		params.put("_order", "DESC");
		params.put("tagStatus", prodTagVO.getTagStatus());
		ResultHandleT<List<ProdTagVO>> resultHandleTList = prodTagClientService.findProdTagVoListByParams(params);
		if(resultHandleTList == null || resultHandleTList.isFail()){
			logger.error(resultHandleTList == null ? "ResultHandleT is empty..." : resultHandleTCount.getMsg());
			throw new BusinessException(resultHandleTList.getMsg());
		}
		List<ProdTagVO> prodTagVOItems = resultHandleTList.getReturnContent();
		List<ProdTagVO> prodTagVOs = new ArrayList<ProdTagVO>();
		String categoryName = null;
		for (ProdTagVO prodTag : prodTagVOItems) {
			if (StringUtil.isNotEmptyString(prodTag.getObjectType())) {
				if ("PROD_PRODUCT".equalsIgnoreCase(prodTag.getObjectType())) {
					// 产品
					ProdProduct prodProduct = prodProductQueryService.findProdProductSimpleById(prodTag.getObjectId());
					Long categoryId = (prodProduct == null? null: prodProduct.getCategoryId());					
					if (categoryId != null) {
						categoryName = tagClientService.getCategoryNameById(categoryId).getReturnContent();
						prodTag.setCategoryId(categoryId);
						prodTag.setCategoryName(categoryName);
					}
					if (null != prodProduct) {
						prodTagVO.setProductId(prodTag.getObjectId());
						prodTagVO.setProductName(prodProduct.getProductName());

						prodTag.setProductId(prodTag.getObjectId());
						prodTag.setProductName(prodProduct.getProductName());
						if (null != prodProduct.getBizCategory()) {
							prodTagVO.setCategoryId(prodProduct.getBizCategory().getCategoryId());
							prodTagVO.setCategoryName(prodProduct.getBizCategory().getCategoryName());

							prodTag.setCategoryId(prodProduct.getBizCategory().getCategoryId());
							prodTag.setCategoryName(prodProduct.getBizCategory().getCategoryName());
						}
					}
				} else if ("SUPP_GOODS".equalsIgnoreCase(prodTag.getObjectType())) {
					// 商品
					SuppGoods suppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(prodTag.getObjectId()));
					Long categoryId = (suppGoods==null?null:suppGoods.getCategoryId());
					if (categoryId != null) {
						categoryName = tagClientService.getCategoryNameById(categoryId).getReturnContent();
						prodTag.setCategoryId(categoryId);
						prodTag.setCategoryName(categoryName);
					}
					if (null != suppGoods) {
						prodTagVO.setSuppGoodsId(prodTag.getObjectId());
						prodTagVO.setGoodsName(suppGoods.getGoodsName());
						prodTagVO.setCategoryId(suppGoods.getCategoryId());
						prodTagVO.setCategoryName(BizEnum.BIZ_CATEGORY_TYPE.getCnName(suppGoods.getCategoryId()));

						prodTag.setSuppGoodsId(prodTag.getObjectId());
						prodTag.setGoodsName(suppGoods.getGoodsName());
						prodTag.setCategoryId(suppGoods.getCategoryId());
						prodTag.setCategoryName(BizEnum.BIZ_CATEGORY_TYPE.getCnName(suppGoods.getCategoryId()));
					}
				}
				prodTagVOs.add(prodTag);
			}

		}
		pageParam.setItems(prodTagVOs);

		model.addAttribute("pageParam", pageParam);
		model.addAttribute("prodTagVO", prodTagVO);

		return "/biz/prodTag/showProdTagByTag";
	}

	/**
	 * 查询标签信息
	 */
	@RequestMapping(value = "/findBizTagList")
	public String findBizTagList(Model model, Integer page, BizTag bizTag, HttpServletRequest req) throws BusinessException {
		
		ResultHandleT<List<BizTagGroup>> resultHandleT =  tagGroupClientService.findTagGroupByConditons(new HashMap<String, Object>());
//		ResultHandleT<List<BizTag>> resultHandleT = tagClientService.findBizTagGroupListByParams(map);
		if(resultHandleT == null || resultHandleT.isFail()){
			logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		List<BizTagGroup> tagGroups = resultHandleT.getReturnContent();
		model.addAttribute("tagGroups", tagGroups);

		// 查询标签配置信息
		final Map<String, Object> params = new HashMap<String, Object>();
		if (null != bizTag) {
			params.put("tagGroupId", bizTag.getTagGroupId());
			params.put("tagName", bizTag.getTagName());
			params.put("cancelFlag", bizTag.getCancelFlag());
		}

		Integer count = tagClientService.queryBizTagTotalCount(params).getReturnContent();

		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		params.put("_start", pageParam.getStartRowsMySql());
		params.put("_pageSize", pageParam.getPageSize());
		params.put("_orderby", "b.SEQ, a.SEQ");
		params.put("_order", "ASC");
		params.put("cancelFlag", bizTag.getCancelFlag());
		ResultHandleT<List<BizTag>> resultHandleTList = tagClientService.findBizTagListByParams(params);
		if(resultHandleTList == null || resultHandleTList.isFail()){
			logger.error(resultHandleTList == null ? "ResultHandleT is empty..." : resultHandleTList.getMsg());
			throw new BusinessException(resultHandleTList.getMsg());
		}
		List<BizTag> list = resultHandleTList.getReturnContent();
		pageParam.setItems(list);

		model.addAttribute("pageParam", pageParam);
		model.addAttribute("page", pageParam.getPage().toString());
		model.addAttribute("bizTag", bizTag);

		return "/biz/prodTag/findBizTagList";
	}

	/**
	 * 跳转到只修改SEQ页面
	 */
	@RequestMapping(value = "/showUpdateBizTagSeq")
	public String showUpdateBizTagSeq(Model model, BizTag bizTag) throws BusinessException {
		if (bizTag !=null && bizTag.getTagId() != null) {
			ResultHandleT<BizTag> resultHandleT = tagClientService.findBizTagById(bizTag.getTagId());
			if(resultHandleT == null || resultHandleT.isFail()){
				logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
				throw new BusinessException(resultHandleT.getMsg());
			}
			bizTag = resultHandleT.getReturnContent();
		}
		model.addAttribute("bizTag", bizTag);
		return "/biz/prodTag/showUpdateBizTagSeq";
	}

	/**
	 * 修改SEQ值
	 */
	@RequestMapping(value = "/saveBizTagSeq")
	@ResponseBody
	public Object saveBizTagSeq(BizTag bizTag) throws BusinessException {
		if (bizTag == null || bizTag.getTagId() == null) {
			return new ResultMessage("error", "参数错误");
		}
		Integer seq = bizTag.getSeq();
		if(!StringUtil.isNumber(seq+"")){
			return new ResultMessage("error", "SEQ值只能为整数");
		}
		ResultHandleT<BizTag> resultHandleT = tagClientService.findBizTagById(bizTag.getTagId());
		if(resultHandleT == null || resultHandleT.isFail()){
			logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		BizTag oldBizTag = resultHandleT.getReturnContent();
		if(oldBizTag != null) {
			BizTag newBizTag = new BizTag();
			BeanUtils.copyProperties(oldBizTag, newBizTag);
			PermUser user = getLoginUser();
			if (user != null) {
				newBizTag.setUpdateUser(user.getUserName());
			}
			newBizTag.setSeq(seq);
			ResultHandleT<Integer> integerResultHandleT = tagClientService.updateBizTag(newBizTag);
			if(integerResultHandleT == null || integerResultHandleT.isFail()){
				logger.error(integerResultHandleT == null ? "ResultHandleT is empty..." : integerResultHandleT.getMsg());
				throw new BusinessException(resultHandleT.getMsg());
			}
			Integer result = integerResultHandleT.getReturnContent();
			if (result != null && result != 0) {
				try {
					// 获取操作日志
					String logContent = getTagChangeLog(oldBizTag, newBizTag);
					//添加操作日志
					if (null != logContent && !"".equals(logContent)) {
						lvmmLogClientService.sendLog(
								COM_LOG_OBJECT_TYPE.TAG,
								oldBizTag.getTagId(), oldBizTag.getTagId(),
								getLoginUser() != null ? getLoginUser().getUserName() : null,
								"修改了标签：【" + oldBizTag.getTagName() + "】，修改内容：" + logContent,
								COM_LOG_LOG_TYPE.TAG_UPDATE.name(),
								"修改标签", null);
					}

				} catch (Exception e) {
					log.error("Record Log failure ！Log Type:" + COM_LOG_LOG_TYPE.TAG_UPDATE.name());
					log.error(e.getMessage());
				}
			}
		}
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

	/**
	 * 跳转到保存或修改页面
	 * 
	 * @param model
	 * @param bizTag
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/showSaveOrUpdateBizTag")
	public String showSaveOrUpdateBizTag(Model model, BizTag bizTag) throws BusinessException {
		
		List<BizTagGroup> tagGroups =  tagGroupClientService.findTagGroupByConditons(new HashMap<String, Object>()).getReturnContent();

		BizTag dto = null;
		String msgMemoText = null;
		String msgNameText = null;
		
		if (null != bizTag && bizTag.getTagId() != null) {
			// 查询标签信息
			ResultHandleT<BizTag> resultHandleTDto = tagClientService.findBizTagById(bizTag.getTagId());
			if(resultHandleTDto == null || resultHandleTDto.isFail()){
				logger.error(resultHandleTDto == null ? "ResultHandleT is empty..." : resultHandleTDto.getMsg());
				throw new BusinessException(resultHandleTDto.getMsg());
			}
			dto = resultHandleTDto.getReturnContent();
		}
		
		if(dto != null && dto.getMessageId() != null) {
			Long msgMultiLangId = dto.getMessageId();
			MultiLangMessageVO multiLangMessage = iMsgMultiLangClientService.selectByPrimaryKey(msgMultiLangId).getReturnContent();
			msgNameText = (multiLangMessage==null ? DEFAULT_LANG_MSG_LINK_TEXT : multiLangMessage.getLinkText());
		} else {
			msgNameText = DEFAULT_LANG_MSG_LINK_TEXT;
		}
		
		if(dto != null && dto.getMemoMessageId() != null) {
			Long memoMultiLangId = dto.getMemoMessageId();
			MultiLangMessageVO multiLangMemo = iMsgMultiLangClientService.selectByPrimaryKey(memoMultiLangId).getReturnContent();
			msgMemoText = (multiLangMemo==null? DEFAULT_LANG_MSG_LINK_TEXT :multiLangMemo.getLinkText());			
		} else {
			msgMemoText = DEFAULT_LANG_MSG_LINK_TEXT;
		}
		
		model.addAttribute("bizTagNameMultiLangLinkText", msgNameText);
		model.addAttribute("bizTagMemoMultiLangLinkText", msgMemoText);
		model.addAttribute("bizTag", dto);
		model.addAttribute("tagGroups", tagGroups);
		return "/biz/prodTag/showSaveOrUpdateBizTag";
	}

	
	@RequestMapping(value = "/setBizTagMemoMultiLang")
	public String setBizTagMemoMultiLang (Model model, Long messageId, HttpServletRequest req) {
		
		MultiLangMessageVO multiLangMessageVO = null;
		
		if(messageId!=null && messageId > 0L) {
			ResultHandleT<MultiLangMessageVO> multiLangMessageResultHandleT = iMsgMultiLangClientService.selectByPrimaryKey(messageId);
			if(multiLangMessageResultHandleT == null || multiLangMessageResultHandleT.isFail()){
				logger.error(multiLangMessageResultHandleT == null ? "ResultHandleT is empty..." : multiLangMessageResultHandleT.getMsg());
				throw new BusinessException(multiLangMessageResultHandleT.getMsg());
			}
			multiLangMessageVO = multiLangMessageResultHandleT.getReturnContent();
			multiLangMessageVO.setMessageSource(MuitlLangMessage.SOURCE.BIZ_TAG_MEMO.name());
		}
		model.addAttribute("messageSource", MuitlLangMessage.SOURCE.BIZ_TAG_MEMO.name());
		model.addAttribute("multiLangMessageSetting", multiLangMessageVO);
		return "/biz/prodTag/showTextAreaMultiLangSetting";
	}
	
	
	@RequestMapping(value = "/setBizTagMultiLang")
	public String setBizTagMultiLang (Model model, Long messageId, HttpServletRequest req) {
		
		MultiLangMessageVO multiLangMessageVO = null;
		
		if(messageId!=null && messageId > 0L) {
			ResultHandleT<MultiLangMessageVO> multiLangMessageResultHandleT = iMsgMultiLangClientService.selectByPrimaryKey(messageId);
			if(multiLangMessageResultHandleT == null || multiLangMessageResultHandleT.isFail()){
				logger.error(multiLangMessageResultHandleT == null ? "ResultHandleT is empty..." : multiLangMessageResultHandleT.getMsg());
				throw new BusinessException(multiLangMessageResultHandleT.getMsg());
			}
			multiLangMessageVO = multiLangMessageResultHandleT.getReturnContent();
			multiLangMessageVO.setMessageSource(MuitlLangMessage.SOURCE.BIZ_TAG_NAME.name());
		}
		model.addAttribute("messageSource", MuitlLangMessage.SOURCE.BIZ_TAG_NAME.name());
		model.addAttribute("multiLangMessageSetting", multiLangMessageVO);
		return "/biz/prodTag/showTextMultiLangSetting";
	}
	
	@RequestMapping(value = "/saveBizTagMultiLangSetting")
	@ResponseBody
	public Object saveBizTagMultiLangSetting(Model model, MuitlLangMessage multiLangMessageSetting) {
		
		ResultMessage resultMessage = null;
		boolean isNew = (multiLangMessageSetting.getMessageId() == null || multiLangMessageSetting.getMessageId() <= 0L);
		PermUser user = getLoginUser();
		
		multiLangMessageSetting.setUpdateUser(user == null ? "" : user.getUserName());
		if(isNew) {
			multiLangMessageSetting.setCreateUser(user == null ? "" : user.getUserName());
			ResultHandleT<MultiLangMessageVO> addedResult = iMsgMultiLangClientService.insertMsgMultiLang(multiLangMessageSetting);
			if(addedResult==null || addedResult.isFail()) {
				logger.error(addedResult == null ? "ResultHandleT is empty..." : addedResult.getMsg());
				resultMessage = ResultMessage.ADD_FAIL_RESULT;
				resultMessage.setMessage(addedResult.getMsg());
				
				return resultMessage;
			} else {
				MultiLangMessageVO resultOfAdded = addedResult.getReturnContent();
				if(resultOfAdded != null) {
					resultMessage = ResultMessage.ADD_SUCCESS_RESULT;
					resultMessage.addObject("multiLangMessageSetting", resultOfAdded);
				} else {
					resultMessage = ResultMessage.ADD_FAIL_RESULT;
				}
			}
		} else {
			ResultHandleT<MultiLangMessageVO> updateResult = iMsgMultiLangClientService.updateByPrimaryKey(multiLangMessageSetting);
			if(updateResult==null || updateResult.isFail()) {
				logger.error(updateResult == null ? "ResultHandleT is empty..." : updateResult.getMsg());
				resultMessage = ResultMessage.UPDATE_FAIL_RESULT;
				resultMessage.setMessage(updateResult.getMsg());
				return resultMessage;
			} else {
				MultiLangMessageVO resultOfAdded = updateResult.getReturnContent();
				if(resultOfAdded != null) {
					resultMessage = ResultMessage.ADD_SUCCESS_RESULT;
					resultMessage.addObject("multiLangMessageSetting", resultOfAdded);
				} else {
					resultMessage = ResultMessage.ADD_FAIL_RESULT;
				}
			}
		}
		
		return resultMessage;
	}
	
	private ResultMessage validteBizTag(BizTag bizTag, boolean isPromoteTag) {
		
		if(isPromoteTag) {
			String categoryIdStr = bizTag.getCategoryIds();
			if(StringUtils.isNotEmpty(categoryIdStr)) {
				bizTag.setCategoryIds("," + categoryIdStr + ",");
			}
		}
		if(bizTag.getExpirationTime()!=null &&  bizTag.getExpirationTime().before(DateUtil.getTodayDate())) {
			
			if(("Y").equalsIgnoreCase(bizTag.getCancelFlag())) {
				return new ResultMessage("error", "此标签已过期，不可设为有效，请先修改标签到期时间");
			}
		}
		if(bizTag.getImageURL() == null) {
			bizTag.setImageURL("");
		}
		return validateRequired(bizTag);
	}

	/**
	 * 新增或修改标签信息
	 */
	@RequestMapping(value = "/saveOrUpdateBizTag")
	@ResponseBody
	public Object saveOrUpdateBizTag(BizTag bizTag) throws BusinessException {
		
		boolean isPromoteTag = Long.valueOf(1L).equals(bizTag.getTagType());
		ResultMessage message = validteBizTag(bizTag, isPromoteTag);
		
		if (null == message) {
			PermUser user = getLoginUser();
			Long tagId = bizTag.getTagId();
			// 判断是否新增或修改
			if (null == tagId) {
				ResultHandleT<BizTag> resultHandleT = new ResultHandleT<BizTag>();
				if (null != user) {
					bizTag.setCreateUser(user.getUserName());
					bizTag.setUpdateUser(user.getUserName());
				}
				
				Integer seq = bizTag.getSeq();
				if (!StringUtil.isNumber(seq + "")) {
					bizTag.setSeq(1);
				}
				
				
				Long tagGroupId = bizTag.getTagGroupId();
				String tagGroupName = Strings.EMPTY;
				BizTagGroup bizTagGroup = tagGroupClientService.findTagGroupByTagGroupId(tagGroupId).getReturnContent();
				if(bizTagGroup !=null ) {
					tagGroupName = bizTagGroup.getTagGroupName();
					bizTag.setTagGroup(tagGroupName);
				}
				
				
				if(isPromoteTag) {
					List<Long> categoryIds = bizTag.getCategoryIdList();
					if(categoryIds == null || categoryIds.size() == 0) {
						logger.error("标签 " + bizTag.getTagName() + " 品类ID为空！！");
						return ResultMessage.ADD_FAIL_RESULT;
					}
					for(int index=0; index<categoryIds.size(); index++) {
	        			Long categoryId = categoryIds.get(index);
	        			BizTag tag = tagClientService.findPromoteTagHasSameCategory(categoryId, null).getReturnContent();
	        			if(tag != null && tag.getTagId() > 0L) {
	        				if(categoryId.equals(0L)) {
	        					resultHandleT.setMsg(tag.getTagName()+"标签已经绑定品类：全部品类");
		        				throw new BusinessException(resultHandleT.getMsg());
	        				} else {
	        					BizCategory bizTagWithSameCategory = bizCategoryQueryService.getCategoryById(categoryId);
	        					resultHandleT.setMsg(tag.getTagName()+"标签已经绑定品类：" + bizTagWithSameCategory.getCategoryName());
	        					throw new BusinessException(resultHandleT.getMsg());
	        				}
	        			}
	        		}
					resultHandleT = tagClientService.addBizTag(bizTag);
				} else {
					resultHandleT = tagClientService.addBizTag(bizTag);
				}
				if(resultHandleT == null || resultHandleT.isFail()){
					logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
					throw new BusinessException(resultHandleT.getMsg());
				}
				BizTag result = resultHandleT.getReturnContent();
				if (result.getTagId() != null) {
						lvmmLogClientService.sendLog(
								COM_LOG_OBJECT_TYPE.TAG,
								result.getTagId(), result.getTagId(), getLoginUser() != null ? getLoginUser().getUserName() : null,
								"添加了标签：【" + result.getTagName() + "】 " + "组名：【" + result.getBizTagGroup().getTagGroupName() + "】",
								COM_LOG_LOG_TYPE.TAG_ADD.name(), "添加标签", null);
					
				}
				return ResultMessage.ADD_SUCCESS_RESULT;
			} else {
				ResultHandleT<Integer> resultHandleT = new ResultHandleT<Integer>();
				if (null != user) {
					bizTag.setUpdateUser(user.getUserName());
				}
				
				Integer seq = bizTag.getSeq();
				if (!StringUtil.isNumber(seq + "")) {
					bizTag.setSeq(1);
				}
				
				ResultHandleT<BizTag> oldResultHandleT = tagClientService.findBizTagById(tagId);
				if(oldResultHandleT == null || oldResultHandleT.isFail()){
					logger.error(oldResultHandleT == null ? "ResultHandleT is empty..." : oldResultHandleT.getMsg());
					throw new BusinessException(oldResultHandleT.getMsg());
				}
				BizTag oldBizTag = oldResultHandleT.getReturnContent();
				
				if(isPromoteTag) {
					List<Long> categoryIds = bizTag.getCategoryIdList();
					
					for(int index = 0; index < categoryIds.size(); index++) {
	        			Long categoryId = categoryIds.get(index);
	        			BizTag tag = tagClientService.findPromoteTagHasSameCategory(categoryId, tagId).getReturnContent();
	        			if(tag != null && tag.getTagId() > 0L) {
	        				if(categoryId.equals(0L)) {
	        					resultHandleT.setMsg(tag.getTagName() + "标签已经绑定品类：全部品类");
		        				throw new BusinessException(resultHandleT.getMsg());
	        				}
	        				
	        				BizCategory bizTagWithSameCategory = bizCategoryQueryService.getCategoryById(categoryId);
	        				resultHandleT.setMsg(tag.getTagName()+"标签已经绑定品类：" + bizTagWithSameCategory.getCategoryName());
	        				throw new BusinessException(resultHandleT.getMsg());
	        			}
	        		}
					 resultHandleT = tagClientService.updateBizTag(bizTag);
				} else {
					 resultHandleT = tagClientService.updateBizTag(bizTag);
				}
				
				
				if(resultHandleT == null || resultHandleT.isFail()){
					logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
					throw new BusinessException(resultHandleT.getMsg());
				}
				int result = resultHandleT.getReturnContent() == null ? 0 : resultHandleT.getReturnContent();
				if (result != 0) {
					try {

						if ("N".equals(bizTag.getCancelFlag())) {
							// 删除标签对应的产品商品信息
							Map<String, Object> params = new HashMap<String, Object>();
							params.put("tagId", tagId);
							prodTagClientService.deleteProdTagByParams(params);
							
							/*comLogClientService.insert(COM_LOG_OBJECT_TYPE.TAG, bizTag.getTagId(), bizTag.getTagId(), "标签ID:" + tagId, "删除标签ID：" + tagId, COM_LOG_LOG_TYPE.TAG_DELETE.name(),
									"删除标签", null);*/
						}
						
						// 获取操作日志
						String logContent = getTagChangeLog(oldBizTag, bizTag);
						//添加操作日志
						if(null != logContent && !"".equals(logContent)) {
							lvmmLogClientService.sendLog(
									COM_LOG_OBJECT_TYPE.TAG,
									oldBizTag.getTagId(), oldBizTag.getTagId(),
									getLoginUser() != null ? getLoginUser().getUserName() : null,
									"修改了标签：【"+oldBizTag.getTagName()+"】，修改内容："+logContent, 
									COM_LOG_LOG_TYPE.TAG_UPDATE.name(), 
									"修改标签", null);
						}

					} catch (Exception e) {
						log.error("Record Log failure ！Log Type:" + COM_LOG_LOG_TYPE.TAG_UPDATE.name());
						log.error(e.getMessage());
					}
				}

				return ResultMessage.UPDATE_SUCCESS_RESULT;
			}
		} else {
			return message;
		}
	}

	// 拼接日志内容
	private String getTagChangeLog(BizTag oldBizTag, BizTag bizTag) {
		StringBuffer logStr = new StringBuffer("");
		if (null != bizTag) {
			if(!oldBizTag.getTagGroupId().equals(bizTag.getTagGroupId())) {
				BizTagGroup oldBizTagGroup = tagGroupClientService.findTagGroupByTagGroupId(oldBizTag.getTagGroupId()).getReturnContent();
				BizTagGroup newBizTagGroup = tagGroupClientService.findTagGroupByTagGroupId(bizTag.getTagGroupId()).getReturnContent();
				logStr.append(ComLogUtil.getLogTxt("小组名称", newBizTagGroup.getTagGroupName(), oldBizTagGroup.getTagGroupName()));
			}
			logStr.append(ComLogUtil.getLogTxt(" 标签名称", bizTag.getTagName(), oldBizTag.getTagName()));
			logStr.append(ComLogUtil.getLogTxt(" 拼音", bizTag.getPinyin(), oldBizTag.getPinyin()));
			logStr.append(ComLogUtil.getLogTxt(" 标签状态", "Y".equals(bizTag.getCancelFlag()) ? "【有效】" : "【无效】", "Y".equals(oldBizTag.getCancelFlag()) ? "【有效】" : "【无效】"));
			logStr.append(ComLogUtil.getLogTxt(" 排序值", bizTag.getSeq().toString(), oldBizTag.getSeq().toString()));
			logStr.append(ComLogUtil.getLogTxt(" 描述", bizTag.getMemo(), oldBizTag.getMemo()));
		}
		return logStr.toString();
	}

	/**
	 * 删除标签关联的产品与商品
	 */
	@RequestMapping(value = "/deleteProdTag")
	@ResponseBody
	public Object deleteProdTag(ProdTagVO prodTagVO, HttpServletRequest req) throws BusinessException {
		Long[] reIds = prodTagVO.getReIds();
		String[] productGoodsNames = prodTagVO.getProductGoodsNames().split(",");
		if (null == reIds || reIds.length <= 0) {
			return new ResultMessage("error", "请选择需要删除的信息");
		}
		ProdTag prodTag = null;
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < reIds.length; i++) {
			ResultHandleT<ProdTag> resultHandleT = prodTagClientService.findProdTagById(reIds[i]);
			if(resultHandleT == null || resultHandleT.isFail()){
				logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
				throw new BusinessException(resultHandleT.getMsg());
			}
			prodTag = resultHandleT.getReturnContent();
			if (prodTag != null) {
				if("PROD_PRODUCT".equalsIgnoreCase(prodTag.getObjectType())){
    				pushAdapterService.push(prodTag.getObjectId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_TAG,ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA); 		

    				sb.append(productGoodsNames[i]).append(";");
    			}else if("SUPP_GOODS".equalsIgnoreCase(prodTag.getObjectType())){
    				pushAdapterService.push(prodTag.getObjectId(), ComPush.OBJECT_TYPE.GOODS, ComPush.PUSH_CONTENT.PROD_TAG,ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA); 		

    				sb.append(productGoodsNames[i]).append(";");
    			}
			}
		}
		ResultHandleT<Integer> integerResultHandleT = prodTagClientService.deleteProdTag(reIds);
		if(integerResultHandleT == null || integerResultHandleT.isFail()){
			logger.error(integerResultHandleT == null ? "ResultHandleT is empty..." : integerResultHandleT.getMsg());
			throw new BusinessException(integerResultHandleT.getMsg());
		}
		int result = integerResultHandleT.getReturnContent() == null ? 0 : integerResultHandleT.getReturnContent();
		if (result != 0) {
			try {
				if (prodTag != null) {
					String objectType = "";
					if ("PROD_PRODUCT".equalsIgnoreCase(prodTag.getObjectType())) {
						objectType = "产品";
					} else if ("SUPP_GOODS".equalsIgnoreCase(prodTag.getObjectType())) {
						objectType = "商品";
					}
					lvmmLogClientService.sendLog(COM_LOG_OBJECT_TYPE.TAG, prodTag.getTagId(), prodTag.getTagId(),
							getLoginUser() != null ? getLoginUser().getUserName() : null,
							"删除了此标签关联的" + objectType + ": " + sb.toString().replace("-", ""),
							COM_LOG_LOG_TYPE.TAG_DELETE.name(), "删除" + objectType, null);
				}
			} catch (Exception e) {
				log.error("Record Log failure ！Log Type:" + COM_LOG_LOG_TYPE.TAG_DELETE.name());
				log.error(e.getMessage());
			}
		}
		return ResultMessage.DELETE_SUCCESS_RESULT;
	}

	/**
	 * 判断标签名称、小组名称、拼音是否存在
	 */
	@RequestMapping(value = "/tagGroupOrNameisExists")
	@ResponseBody
	public Object tagGroupOrNameisExists(BizTag bizTag) throws BusinessException {
		
		if (null != bizTag) {
			ResultHandleT<Boolean> result = tagClientService.tagGroupOrNameisExists(bizTag);
			if(!result.getReturnContent()) {
				return new ResultMessage("error", result.getMsg());
			}
			
		}
		return new ResultMessage("success", "不存在");
	}

	/**
	 * 必填项
	 */
	private ResultMessage validateRequired(BizTag bizTag) {
		
		if (null == bizTag) {
			return new ResultMessage("error", "参数错误");
		} else if (StringUtil.isEmptyString(bizTag.getTagName())) {
			return new ResultMessage("error", "标签名称不能为空");
		} else if (StringUtil.isEmptyString(bizTag.getTagName())) {
			return new ResultMessage("error", "标签拼音不能为空");
		}
		return null;
	}

	/**
	 * 检查VO有效性
	 * @param bizTagVO
	 * @return 错误信息
	 */
	private ResultMessage validateVO(BizTagVO bizTagVO) {
		if (null == bizTagVO) {
			return new ResultMessage("error", "参数错误");
		} else if(StringUtil.isEmptyString(bizTagVO.getTagGroup())
				&& StringUtil.isEmptyString(bizTagVO.getMemo()) && StringUtil.isEmptyString(bizTagVO.getCancelFlag())) {
			return new ResultMessage("error", EMPTY_COMMIT_FAIL);
		}
		return null;
	}
	
	/*
	 * 删除标签
	 */
	@RequestMapping(value = "/deleteTag", method = RequestMethod.POST)
	@ResponseBody
	public Object deleteTag(Long tagId) {
		BizTag bizTag = new BizTag();
		bizTag.setCancelFlag("N");
		bizTag.setTagId(tagId);
		ResultHandleT<Integer> resultHandleT = tagClientService.updateByCancelFlag(bizTag);
		if(resultHandleT == null || resultHandleT.isFail()){
			logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		ResultMessage result = (resultHandleT.getReturnContent() != null && resultHandleT.getReturnContent() > 0) ?
				ResultMessage.DELETE_SUCCESS_RESULT : ResultMessage.DELETE_FAIL_RESULT;
		// 删除标签对应的产品商品信息
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tagId", tagId);
		prodTagClientService.deleteProdTagByParams(params);
		lvmmLogClientService.sendLog(COM_LOG_OBJECT_TYPE.TAG,
				bizTag.getTagId(),bizTag.getTagId(),
				"标签ID:"+tagId,
				"删除标签ID："+tagId,
				COM_LOG_LOG_TYPE.TAG_DELETE.name(),
				"删除标签",null);
		return result;
	}

	/**
	 * 跳转到删除小组页面 by jeanhuang
	 */
	// TODO - Delete the method
	@RequestMapping(value = "/toDeleteGroupPage")
	public String toDeleteGroupPage() {
		// 查询小组名称
		
		ResultHandleT<List<BizTagGroup>> resultHandleT = tagGroupClientService.findTagGroupByConditons(new HashMap<String, Object>());
		if(resultHandleT == null || resultHandleT.isFail()){
			logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		List<BizTagGroup> tagGroups = resultHandleT.getReturnContent();
		HttpServletLocalThread.getModel().addAttribute("tagGroups", tagGroups);
		return "/biz/prodTag/bizGroupList";
	}

	/**
	 *
	 * 删除小组操作 by jeanhuang
	 */
	// TODO - Delete the method
	@RequestMapping(value = "/deleteGroup")
	@ResponseBody
	public ResultMessage deleteGroup(Model model, BizTag bizTag) {
		Map<String, Object> params = new HashMap<String, Object>();
		bizTag.setCancelFlag("N");
		ResultHandleT<Integer> resultHandleTCount = tagClientService.updateByCancelFlag(bizTag);
		if(resultHandleTCount == null || resultHandleTCount.isFail()){
			logger.error(resultHandleTCount == null ? "ResultHandleT is empty..." : resultHandleTCount.getMsg());
			throw new BusinessException(resultHandleTCount.getMsg());
		}
		int result = resultHandleTCount.getReturnContent() == null ? 0 : resultHandleTCount.getReturnContent();
		// 查询小组下的所有标签
		params.put("tagGroup", bizTag.getTagGroup());
		ResultHandleT<List<BizTag>> resultHandleT = tagClientService.findBizTagListByParams(params);
		if(resultHandleT == null || resultHandleT.isFail()){
			logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		List<BizTag> tags = resultHandleT.getReturnContent();
		// 删除小组下的标签所对应的产品商品信息
		params.clear();
		for (BizTag item : tags) {
			params.put("tagId", item.getTagId());
			prodTagClientService.deleteProdTagByParams(params);
		}
		return result > 0 ? ResultMessage.DELETE_SUCCESS_RESULT : ResultMessage.DELETE_FAIL_RESULT;
	}
	
	/**
	 * 跳转到批量修改标签页面
	 */
	@RequestMapping(value = "/batchUpdateBizTag")
	public String batchUpdateBizTag(Model model, BizTagVO bizTagVO) throws BusinessException {
		// 查询小组名称
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cancelFlag", "Y");
		ResultHandleT<List<BizTagGroup>> resultHandleT = tagGroupClientService.findTagGroupByConditons(new HashMap<String, Object>());
		if(resultHandleT == null || resultHandleT.isFail()){
			logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		List<BizTagGroup> tagGroups = resultHandleT.getReturnContent();
		model.addAttribute("tagGroups", tagGroups);
		model.addAttribute("bizTagVO", bizTagVO);

		return "/biz/prodTag/batchUpdateBizTag";
	}
	
	/**
	 * 批量修改标签保存
	 */
	@RequestMapping(value = "/saveBatchUpdateBizTag")
	@ResponseBody
	public Object saveBatchUpdateBizTag(BizTagVO bizTagVO) throws BusinessException {
		
		ResultMessage message = validateVO(bizTagVO);
		if (null == message) {						
			PermUser user = getLoginUser();
			Long[] objectIds = bizTagVO.getObjectIds();
			if (null != objectIds && objectIds.length > 0) {
				for (Long objectId : objectIds) {
					ResultHandleT<BizTag> resultHandleT = tagClientService.findBizTagById(objectId);
					if(resultHandleT == null || resultHandleT.isFail()){
						logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
						throw new BusinessException(resultHandleT.getMsg());
					}
					BizTag bizTag = resultHandleT.getReturnContent();
					if(bizTag != null) {
						BizTag oldBizTag = new BizTag();
						BeanUtils.copyProperties(bizTag, oldBizTag);
						
						//更新标签修改人
						if (null != user) {
							bizTag.setUpdateUser(user.getUserName());
						}
						
						if (bizTagVO.getTagGroupId() != null && bizTagVO.getTagGroupId() > 0L) {
							bizTag.setTagGroupId(bizTagVO.getTagGroupId());
						}
						//更新标签描述
						if(StringUtil.isNotEmptyString(bizTagVO.getMemo())) {
							bizTag.setMemo(bizTagVO.getMemo());
						}
						//更新标签状态
						if(StringUtil.isNotEmptyString(bizTagVO.getCancelFlag())) {
							bizTag.setCancelFlag(bizTagVO.getCancelFlag());							
						}
						try {
							ResultHandleT<Integer> integerResultHandleT = tagClientService.updateBizTag(bizTag);
							if(integerResultHandleT == null || integerResultHandleT.isFail()){
								logger.error(integerResultHandleT == null ? "ResultHandleT is empty..." : integerResultHandleT.getMsg());
								throw new BusinessException(integerResultHandleT.getMsg());
							}
							int result = integerResultHandleT.getReturnContent() == null ? 0 : integerResultHandleT.getReturnContent();
							if (result != 0) {
								if ("N".equals(bizTagVO.getCancelFlag())) {
									// 删除标签对应的产品商品信息
									Map<String, Object> params = new HashMap<String, Object>();
									params.put("tagId", objectId);
									prodTagClientService.deleteProdTagByParams(params);
								}
								
								// 获取操作日志
								String logContent = getTagChangeLog(oldBizTag, bizTag);
								//添加操作日志
								if(StringUtil.isNotEmptyString(logContent)) {
									lvmmLogClientService.sendLog(
											COM_LOG_OBJECT_TYPE.TAG,
											bizTag.getTagId(), bizTag.getTagId(),
											user != null ? user.getUserName() : null,
											"批量修改标签：【"+oldBizTag.getTagName()+"】，修改内容："+logContent, 
											COM_LOG_LOG_TYPE.TAG_UPDATE.name(), 
											"批量修改标签", null);									
								}
							}
						} catch (Exception e) {
							log.error("Record Log failure ！Log Type:" + COM_LOG_LOG_TYPE.TAG_UPDATE.name());
							log.error(e.getMessage());
						}
					}
				}
			}
			
			return ResultMessage.UPDATE_SUCCESS_RESULT;
		}
		else {
			return message;
		}		
	}
	
	
	/**
	 *显示设置 标签小组的页面
	 */
	@RequestMapping(value="/showSetTagGroup")
	public String showSetTagGroup(Model model,HttpServletRequest request){
		
		final Map<String, Object> params = new HashMap<String, Object>();
		params.put("_orderby", "SEQ");
		params.put("_order", "ASC");
		ResultHandleT<List<BizTagGroup>> resultHandleT = tagGroupClientService.findTagGroupByConditons(params);
		
		if(resultHandleT == null || resultHandleT.isFail()) {
			logger.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		
		List<BizTagGroup> tagGroups = resultHandleT.getReturnContent();
		model.addAttribute("tagGroups", tagGroups);
		return "/biz/prodTag/setTagGroupSeq";
	}
	
	
	/**
	 *保存或编辑 标签小组的页面
	 */
	@RequestMapping(value="/saveOrUpdateTagGroup")
	@ResponseBody
	public Object saveOrUpdateTagGroup(Model model, BizTagGroupVO bizTagGroup, HttpServletRequest request) {
		
		ResultMessage result = ResultMessage.ADD_FAIL_RESULT;
		final Map<String, Object> paraMap = new HashMap<String, Object>();
		String currentUser = Strings.EMPTY;
		
		boolean isEdit = bizTagGroup.getTagGroupId() != null && bizTagGroup.getTagGroupId() > 0L;
		String tagGroupName = bizTagGroup.getTagGroupName();
		BizTagGroup addedBizTagGroup = null;
		Integer numOfUpdate = 0;
		PermUser user = getLoginUser();
		if (user != null) {
			currentUser = user.getUserName();
		}
	
		if(StringUtils.isNotEmpty(tagGroupName)) {
			paraMap.put("tagGroupName", bizTagGroup.getTagGroupName());
			if(isEdit) {
					// 编辑
					BizTagGroup oldTagGroup = tagGroupClientService.findTagGroupByTagGroupId(bizTagGroup.getTagGroupId()).getReturnContent();
					bizTagGroup.setUpdateUser(currentUser);
					numOfUpdate = tagGroupClientService.updateBizTagGroup(bizTagGroup).getReturnContent();
					if(numOfUpdate > 0) {
						result = ResultMessage.UPDATE_SUCCESS_RESULT;
						lvmmLogClientService.sendLog(
								COM_LOG_OBJECT_TYPE.TAG_GROUP,
								bizTagGroup.getTagGroupId(),bizTagGroup.getTagGroupId(),
								user != null ? user.getUserName() : null,
								"修改标签组：[名称："+ oldTagGroup.getTagGroupName() +", SEQ："+ oldTagGroup.getSeq()+"] 为  [名称：" + bizTagGroup.getTagGroupName()+", SEQ: " + bizTagGroup.getSeq()+"]", 
								COM_LOG_LOG_TYPE.TAG_GROUP_UPDATE.name(), 
								"修改标签组", null);
					}
				} else {
					// 新增
					bizTagGroup.setCreateUser(currentUser);
					bizTagGroup.setUpdateUser(currentUser);
					ResultHandleT<BizTagGroup> addResultHandleT = tagGroupClientService.addBizTagGroup(bizTagGroup);
					if(addResultHandleT == null || addResultHandleT.isFail()){
						logger.error(addResultHandleT == null ? "ResultHandleT is empty..." : addResultHandleT.getMsg());
						throw new BusinessException(addResultHandleT.getMsg());
					} else {
						addedBizTagGroup = addResultHandleT.getReturnContent();
					}
					
					if(addedBizTagGroup != null) {
						result = ResultMessage.ADD_SUCCESS_RESULT;
						
						lvmmLogClientService.sendLog(
								COM_LOG_OBJECT_TYPE.TAG_GROUP,
								addedBizTagGroup.getTagGroupId(), addedBizTagGroup.getTagGroupId(),
								user != null ? user.getUserName() : null,
								"新增标签组：[名称："+ addedBizTagGroup.getTagGroupName() +", SEQ："+ addedBizTagGroup.getSeq()+"]", 
								COM_LOG_LOG_TYPE.TAG_GROUP_ADD.name(), 
								"新增标签组", null);
					}
				}
		} else {
			result = new ResultMessage(ResultMessage.ERROR, "小组名称不能为空");
		}
	    
	    
		return result;
	}
	
	
	/**
	 *删除 标签小组的页面
	 */
	@RequestMapping(value="/deleteTagGroup")
	@ResponseBody
	public Object deleteTagGroup(Model model,HttpServletRequest request, Long tagGroupId) {
		
		ResultMessage result = ResultMessage.DELETE_FAIL_RESULT;
		// 判断有没有关联标签
		boolean hasAssociatedBizTags = false;
		
		final Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("tagGroupId", tagGroupId);
		
		List<BizTag> associatedBizTags = tagClientService.findBizTagListByParams(paraMap).getReturnContent();
		hasAssociatedBizTags = associatedBizTags != null && associatedBizTags.size() > 0;
		
		if(!hasAssociatedBizTags) {
			int numOfDelete = tagGroupClientService.removeBizTagGroup(tagGroupId).getReturnContent();
			if( numOfDelete > 0 ) {
				result = ResultMessage.DELETE_SUCCESS_RESULT;
			}
		} else {
			result = new ResultMessage(ResultMessage.ERROR, "此小组标签无法删除");
		}
		return result;
	}
	
	@Override
	@InitBinder
	public void initBinder(WebDataBinder binder) {//不用BaseCommonAction父类方法，在这里重写   在bean属性中使用@DateTimeFormat注解
		
		binder.registerCustomEditor(Date.class, "updateTime", new CustomDateEditor(
				new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"), true));
		
		binder.registerCustomEditor(Date.class, "createTime", new CustomDateEditor(
				new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"), true));
		
		binder.registerCustomEditor(Date.class, "startTime", new CustomDateEditor(
				new SimpleDateFormat("yyyy-MM-dd"), true));
		
		binder.registerCustomEditor(Date.class, "endTime", new CustomDateEditor(
				new SimpleDateFormat("yyyy-MM-dd"), true));
	}

}