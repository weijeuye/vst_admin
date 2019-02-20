package com.lvmama.vst.back.play.connects.prod.web;

import com.alibaba.fastjson.JSONObject;
import com.lvmama.vst.back.biz.po.BizEnum;
import com.lvmama.vst.back.biz.po.BizEnum.PLAY_METHOD_PRODUCT_TYPE;
import com.lvmama.vst.back.client.goods.service.PlayMethodClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.goods.po.PlayMethod;
import com.lvmama.vst.back.goods.po.ProdPlayMethodRe;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.pub.service.PushAdapterServiceRemote;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

import java.util.*;

@SuppressWarnings("serial")
@Controller
@RequestMapping("/connects/prod/playMethod")
public class ConnectsPlayMethodAction extends BaseActionSupport {

	private static final Log LOG = LogFactory.getLog(ConnectsPlayMethodAction.class);

	@Autowired
	private ComLogClientService comLogService;

	@Autowired
	private PlayMethodClientService playMethodClientServiceRemote;
	@Autowired
	private PushAdapterServiceRemote pushAdapterService;


	/**
	 * 点击添加玩法 弹出选择玩法窗口
	 * 
	 */
	// 需要查询
	@RequestMapping("/showSelectPlayMethod")
	public String showSelectPlayMethod(Model model, Long productId, Integer page, PlayMethod playMethod,
			HttpServletRequest req ,Long categoryId) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showSelectPlayMethod>");
		}
		if (null != productId && productId > 0) {
			// 封装搜索条件
			Map<String, Object> playMethodParam = new HashMap<String, Object>();
			playMethodParam.put("playMethodTypeId", playMethod.getPlayMethodTypeId());
			playMethodParam.put("name", playMethod.getName());
			playMethodParam.put("productId", productId);
			playMethodParam.put("validFlag", "Y");//只查询有效的玩法
			// 分页
			//int count = playMethodService.findPlayMethodCount(playMethodParam);
			ResultHandleT<Integer> resultHandle = playMethodClientServiceRemote.findPlayMethodCount(playMethodParam);
			if(resultHandle == null || resultHandle.isFail()){
				log.error(resultHandle.getMsg());
				throw new BusinessException(resultHandle.getMsg());
			}
			int count = resultHandle.getReturnContent();
			int pagenum = page == null ? 1 : page;
			Page<PlayMethod> pageParam = Page.page(count, 10, pagenum);
			pageParam.buildUrl(req);
			playMethodParam.put("_start", pageParam.getStartRows());
			playMethodParam.put("_end", pageParam.getEndRows());
			playMethodParam.put("_orderby", "pm.PLAY_METHOD_TYPE_ID");
			playMethodParam.put("_order", "ASC");
			// 查询玩法列表
			//List<PlayMethod> playMethodList = playMethodService.selectPlayMethodListByParam(playMethodParam);
			ResultHandleT<List<PlayMethod>> resultHandle1 = playMethodClientServiceRemote.selectPlayMethodListByParam(playMethodParam);
			if(resultHandle1 == null || resultHandle1.isFail()){
				log.error(resultHandle1.getMsg());
				throw new BusinessException(resultHandle1.getMsg());
			}
			List<PlayMethod> playMethodList = resultHandle1.getReturnContent();
			//设置基础属性
			setModleBaseAttribute(model);
			pageParam.setItems(playMethodList);
			model.addAttribute("pageParam", pageParam);
			model.addAttribute("page", pageParam.getPage().toString());
			model.addAttribute("playMethod",playMethod);
			model.addAttribute("productId", productId);
			model.addAttribute("categoryId", categoryId);

		}
		if(categoryId == 41L){
			return "/prod/connects/product/showSelectPlayMethod";
		}
		return "/prod/selfTour/product/showSelectPlayMethod";
	}
	

	/**
	 * 保存playMethod和productId
	 * @param prodPlayMethodRe  product_id
	 * @param stringArray playMethodId数组
	 * @return
	 */
	@RequestMapping("/saveSelectPlayMethod")
	@ResponseBody
	public Object saveSelectPlayMethod(ProdPlayMethodRe prodPlayMethodRe,String[] stringArray) throws BusinessException{
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<saveSelectPlayMethod>");
		}
		if(null == prodPlayMethodRe || null == prodPlayMethodRe.getProductId() || stringArray.length <= 0){
			return new ResultMessage("error", "系统出现异常！");
		}
		//ProdPlayMethodRe getProdPlayMethodRe = playMethodService.findMaxSeq(prodPlayMethodRe.getProductId());
		ResultHandleT<ProdPlayMethodRe> resultHandle = playMethodClientServiceRemote.findMaxSeq(prodPlayMethodRe.getProductId());
		if(resultHandle == null || resultHandle.isFail()){
			log.error(resultHandle.getMsg());
			throw new BusinessException(resultHandle.getMsg());
		}
		ProdPlayMethodRe getProdPlayMethodRe = resultHandle.getReturnContent();
		for (int i = 0; i < stringArray.length; i++) {
			Long playMehtodId = Long.valueOf(stringArray[i]);
			prodPlayMethodRe.setPlayMethodId(playMehtodId);
			if (getProdPlayMethodRe != null && getProdPlayMethodRe.getSeq() >= 0) {
				prodPlayMethodRe.setSeq((long) i + 1 + getProdPlayMethodRe.getSeq());
			} else {
				prodPlayMethodRe.setSeq((long) i + 1);
			}
			//playMethodService.saveSelectPlayMethod(prodPlayMethodRe);
			playMethodClientServiceRemote.saveSelectPlayMethod(prodPlayMethodRe);
			try {
				// 操作执行消息推送
				this.pushAdapterService.push(prodPlayMethodRe.getProductId(), ComPush.OBJECT_TYPE.PRODUCT,
						ComPush.PUSH_CONTENT.PROD_PLAY_METHOD_RE, ComPush.OPERATE_TYPE.ADD,
						ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
			} catch (Exception e) {
				log.error("perform push notification failure ！push type:" + COM_LOG_LOG_TYPE.TAG_ADD.name());
				log.error(ExceptionFormatUtil.getTrace(e));
			}
			// 绑定产品
			updateProdBindCount(playMehtodId);

		}
		// 查询保存的数据显示出来
		List<PlayMethod> list = getPlayListById(prodPlayMethodRe.getProductId(),true);
		return list;
		 
	}

	/**
	 * 保存 保存用户设定的玩法、更新用户在弹框中选中的玩法
	 * 
	 * @param prodPlayMethodRe
	 * @param tableValueArray
	 */
	@RequestMapping("/saveAllPlayMethod")
	@ResponseBody
	public Object saveAllPlayMethod(ProdPlayMethodRe prodPlayMethodRe, String tableValueArray)
			throws BusinessException {
		if(null==prodPlayMethodRe.getProductId()){
			return new ResultMessage("error", "系统出现异常！");
		}
		List<Map> objectList = JSONObject.parseArray(tableValueArray, Map.class);
		StringBuffer mehtodIds = new StringBuffer();
		if (CollectionUtils.isNotEmpty(objectList)) {
			// 更新
			for (Map<String, Object> map : objectList) {
				String seqStr = map.get("seq").toString();
				prodPlayMethodRe.setSeq(Long.valueOf(seqStr));
				String playMethodIdStr = map.get("playMethodId").toString();
				prodPlayMethodRe.setPlayMethodId(Long.valueOf(playMethodIdStr));
				//playMethodService.updatePlayMethodSeq(prodPlayMethodRe);
				playMethodClientServiceRemote.updatePlayMethodSeq(prodPlayMethodRe);
				mehtodIds.append(playMethodIdStr + ",");
				try {
					// 操作执行消息推送
					this.pushAdapterService.push(prodPlayMethodRe.getProductId(), ComPush.OBJECT_TYPE.PRODUCT,
							ComPush.PUSH_CONTENT.PROD_PLAY_METHOD_RE, ComPush.OPERATE_TYPE.UP,
							ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
				} catch (Exception e) {
					log.error("perform push notification failure ！push type:" + COM_LOG_LOG_TYPE.TAG_UPDATE.name());
					log.error(ExceptionFormatUtil.getTrace(e));
				}

			}
			try {
				comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, prodPlayMethodRe.getProductId(),
						prodPlayMethodRe.getProductId(), this.getLoginUser().getUserName(),
						"添加了产品编号为：【" + prodPlayMethodRe.getProductId() + "】的玩法设置：【" + mehtodIds.toString() + "】",
						COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name(), "添加玩法设置", null);
			} catch (Exception e) {
				LOG.error(ExceptionFormatUtil.getTrace(e));
			}

		}
		return ResultMessage.ADD_SUCCESS_RESULT;

	
	}

	/**
	 * 根据productId和playMethodId删除玩法
	 * 
	 * @param prodPlayMethodRe
	 * @return
	 */
	@RequestMapping("/deletePlayMethod")
	@ResponseBody
	public Object deletePlayMethod(ProdPlayMethodRe prodPlayMethodRe, String sign) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<deletePlayMethod>");
		}
		if (null == prodPlayMethodRe || null == prodPlayMethodRe.getProductId() || null == prodPlayMethodRe.getPlayMethodId()) {
			return new ResultMessage("error", "系统出现异常！");
		}

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("productId", prodPlayMethodRe.getProductId());
		param.put("playMethodId", prodPlayMethodRe.getPlayMethodId());
		// 执行删除操作
		//playMethodService.deletePlayMethod(param);
		playMethodClientServiceRemote.deletePlayMethod(param);
		try {
			// 操作执行消息推送
			this.pushAdapterService.push(prodPlayMethodRe.getProductId(), ComPush.OBJECT_TYPE.PRODUCT,
					ComPush.PUSH_CONTENT.PROD_PLAY_METHOD_RE, ComPush.OPERATE_TYPE.DEL,
					ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
		} catch (Exception e) {
			log.error("perform push notification failure ！push type:" + COM_LOG_LOG_TYPE.TAG_DELETE.name());
			log.error(ExceptionFormatUtil.getTrace(e));
		}
		clearProdBindCount(prodPlayMethodRe.getPlayMethodId());
		// 回显数据
		List<PlayMethod> list = getPlayListById(prodPlayMethodRe.getProductId(),true);

		try {
			comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_PRODUCT, prodPlayMethodRe.getProductId(),
					prodPlayMethodRe.getPlayMethodId(),
					this.getLoginUser().getUserName(), "删除了产品编号为：【" + prodPlayMethodRe.getProductId() + "】的玩法设置：【"
							+ prodPlayMethodRe.getPlayMethodId() + "】",
					COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name(), "删除玩法设置", null);
		} catch (Exception e) {
			LOG.error(ExceptionFormatUtil.getTrace(e));
		}

		return list;
		
	}

	/**
	 * 操作主页面
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping("/selectMainPlayMethodCategory")
	public Object findMainPlayMethodCategory(Model model, Long productId, Long categoryId) throws BusinessException {
		LOG.info("页面传来的参数=====productId：" + productId + "，categoryId：" + categoryId);
		if (null == productId || productId < 0 || null == categoryId || categoryId < 0) {
			return new ResultMessage("error", "系统出现异常！");
		}
		
		// 回显玩法列表
		List<PlayMethod> list=getPlayListById(productId,false);
		LOG.info("玩法列表=====list：" + list);
		// 默认交通接驳
		if (categoryId == 41L) {
			model.addAttribute("playMethodTypeId", Long.valueOf(1007L));
		}
		PlayMethod mainPlayMethod=null;
		if(categoryId == 41L && CollectionUtils.isNotEmpty(list)){
			for(PlayMethod pm:list){
				if(null!=pm && null!=pm.getSeq() && pm.getSeq().equals(0L)){
					mainPlayMethod=pm;
					break;
				}
			}
			
		}
		if(mainPlayMethod!=null){
			list.remove(mainPlayMethod);
			model.addAttribute("mainPlayMethod",mainPlayMethod);
		}
		
		if (CollectionUtils.isNotEmpty(list)) {
			model.addAttribute("havePlayMethod", "true");
		}
		model.addAttribute("playMethodList", list);
		model.addAttribute("productId", productId);
		model.addAttribute("categoryId", categoryId);
		// 玩法类型
		setModleBaseAttribute(model);

		if (categoryId == 41L) {
			return "/prod/connects/product/selectMainPlayMethodCategory";
		}
		return "/prod/selfTour/product/selectMainPlayMethodCategory";
		
		
	}

	/**
	 * ajax获取玩法名称集合
	 * 
	 * @param playMethodTypeId
	 * @return
	 */
	@RequestMapping("/ajaxRequest")
	@ResponseBody
	public Map<Object, Object> ajaxRequest(Long playMethodTypeId) throws BusinessException {
		if (null != playMethodTypeId) {
			Map<Object, Object> playMethodMap = this.ajaxRequestFun(playMethodTypeId);
			return playMethodMap;
		}
		return null;
	}

	/**
	 * 查询主玩法
	 */
	@RequestMapping("/selectMainPlayMethod")
	@ResponseBody
	public ProdPlayMethodRe findMainPlayMethod(Long productId) throws BusinessException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("productId", productId);
		// 查询已保存主玩法
		//List<ProdPlayMethodRe> prodPlayMethodReList = playMethodService.findMainPlayMethod(param);
		ResultHandleT<List<ProdPlayMethodRe>> resultHandle = playMethodClientServiceRemote.findMainPlayMethod(param);
		if(resultHandle == null || resultHandle.isFail()){
			log.error(resultHandle.getMsg());
			throw new BusinessException(resultHandle.getMsg());
		}
		List<ProdPlayMethodRe> prodPlayMethodReList = resultHandle.getReturnContent();
		if (CollectionUtils.isNotEmpty(prodPlayMethodReList)) {
			return prodPlayMethodReList.get(0);
		}
		return null;
	}

	private Map<Object, Object> ajaxRequestFun(Long playMethodTypeId) {
		Map<Object, Object> map = new HashMap<Object, Object>();
		List<PlayMethod> playMethodTypeList = this.getPlayMethodList(playMethodTypeId);
		for (int i = 0; i < playMethodTypeList.size(); i++) {
			map.put(playMethodTypeList.get(i).getPlayMethodId(), playMethodTypeList.get(i).getName());
		}
		return map;
	}

	/** 获取玩法类型集合 */
	private List<BizEnum.PLAY_METHOD_PRODUCT_TYPE> getPlayMethodType() {
		return Arrays.asList(BizEnum.PLAY_METHOD_PRODUCT_TYPE.values());
	}

	/** 获取玩法类型下的玩法名称集合 */
	private List<PlayMethod> getPlayMethodList(Long playMethodTypeId) {
		//return playMethodService.findPlayMethodByPlayMethodTypeId(playMethodTypeId);
		ResultHandleT<List<PlayMethod>> resultHandle = playMethodClientServiceRemote.findPlayMethodByPlayMethodTypeId(playMethodTypeId);
		if(resultHandle == null || resultHandle.isFail()){
			log.error(resultHandle.getMsg());
			throw new BusinessException(resultHandle.getMsg());
		}
		List<PlayMethod> playMethodList = resultHandle.getReturnContent();

		return playMethodList;
	}
	/** 设置玩法类型 */
	private void setModleBaseAttribute(Model model){
		// 玩法类型
		List<PLAY_METHOD_PRODUCT_TYPE> playMethodTypeList = this.getPlayMethodType();
		model.addAttribute("playMethodTypeList", playMethodTypeList);
	}

	/** 根据产品ID查询玩法 */
	private List<PlayMethod> getPlayListById(Long productId,boolean filter) {
		ResultHandleT<List<PlayMethod>> resultHandle = playMethodClientServiceRemote.findPlayMethodByProductId(productId);
		if(resultHandle == null || resultHandle.isFail()){
			log.error(resultHandle.getMsg());
			throw new BusinessException(resultHandle.getMsg());
		}
		List<PlayMethod> playMethodList = resultHandle.getReturnContent();
		//List<PlayMethod> playMethodList = playMethodService.findPlayMethodByProductId(productId);
		List<PlayMethod> list = new ArrayList<PlayMethod>();
		List<PLAY_METHOD_PRODUCT_TYPE> playMethodTypeList = this.getPlayMethodType();
		for (PlayMethod pm : playMethodList) {
			if (filter && null != pm.getSeq() && pm.getSeq().equals(0L)) {
				continue;
			}
			for (PLAY_METHOD_PRODUCT_TYPE pt : playMethodTypeList) {
				if (null != pm.getSeq() && pt.getCategoryId().equals(pm.getPlayMethodTypeId())) {
					pm.setPlayMethodTpyeName(pt.getCategoryName());
				}

			}
			list.add(pm);

		}
		return list;
	}
	/** 更新玩法 BindCount*/
	private void  updateProdBindCount(Long playMehtodId){
		//PlayMethod playMethod = playMethodService.findPlayMethodById(playMehtodId);
		ResultHandleT<PlayMethod> resultHandle = playMethodClientServiceRemote.findPlayMethodById(playMehtodId);
		if(resultHandle == null || resultHandle.isFail()){
			log.error(resultHandle.getMsg());
			throw new BusinessException(resultHandle.getMsg());
		}

		PlayMethod playMethod = resultHandle.getReturnContent();

		Long count = playMethod.getProdBindCount();
		if (null != count && count >= 0) {
			// 更新prodBindCount
			playMethod.setProdBindCount(count + 1);
			//playMethodService.updateProdBindCount(playMethod);
			playMethodClientServiceRemote.updateProdBindCount(playMethod);
		} else {
			playMethod.setProdBindCount((long) 1);
			//playMethodService.updateProdBindCount(playMethod);
			playMethodClientServiceRemote.updateProdBindCount(playMethod);
		}
	}
	/**解除玩法 BindCount*/
	private void clearProdBindCount(Long playMehtodId){
		// 解除绑定
		//PlayMethod playMethod = playMethodService.findPlayMethodById(playMehtodId);
		ResultHandleT<PlayMethod> resultHandle = playMethodClientServiceRemote.findPlayMethodById(playMehtodId);
		if(resultHandle == null || resultHandle.isFail()){
			log.error(resultHandle.getMsg());
			throw new BusinessException(resultHandle.getMsg());
		}

		PlayMethod playMethod = resultHandle.getReturnContent();

		Long count = playMethod.getProdBindCount();
		if (count >= 1) {
			// 更新prodBindCount
			playMethod.setProdBindCount(count - 1);
			//playMethodService.updateProdBindCount(playMethod);
			playMethodClientServiceRemote.updateProdBindCount(playMethod);
		} else {
			playMethod.setProdBindCount((long) 0);
			//playMethodService.updateProdBindCount(playMethod);
			playMethodClientServiceRemote.updateProdBindCount(playMethod);
		}
	}
}
