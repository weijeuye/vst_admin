package com.lvmama.vst.back.goods.web.show;

import com.alibaba.fastjson.JSONObject;
import com.lvmama.vst.back.biz.po.BizEnum;
import com.lvmama.vst.back.biz.po.BizEnum.PLAY_METHOD_PRODUCT_TYPE;
import com.lvmama.vst.back.client.goods.service.PlayMethodClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.goods.po.PlayMethod;
import com.lvmama.vst.back.goods.po.ProdPlayMethodRe;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.pub.service.PushAdapterServiceRemote;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

import java.util.*;

@SuppressWarnings("serial")
@Controller
@RequestMapping("/show/playMethod")
public class PlayMethodAction extends BaseActionSupport{
	
	private static final Log LOG = LogFactory.getLog(PlayMethodAction.class);
	private static final String CATEGORYID = "31";
	//演出展览
	private static final String  PLAYMETHODTYPE = "type_show_display";
	@Autowired
	private ComLogClientService comLogService;
//	@Autowired
//	private PlayMethodService playMethodService;
	@Autowired
	private PlayMethodClientService playMethodClientServiceRemote;

	@Autowired
	private ProdProductClientService prodProductService;
	
	@Autowired
	private PushAdapterServiceRemote pushAdapterService;
	

	/**
	 * 玩法设置
	 * @param model
	 * @param playMethod
	 * @param req
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/findPlayMethod")
	public String findPlayMethod(Model model,PlayMethod playMethod,HttpServletRequest req , Integer page) throws BusinessException{
		
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<findPlayMethod>");
		}
		
		List<BizEnum.BIZ_CATEGORY_TYPE> categoryList = this.getBizCategoryType();
		model.addAttribute("categoryList", categoryList);
		//封装搜索条件
		Map<String,Object> paramPlayMethod = new HashMap<String,Object>();

		//封装查询条件
		paramPlayMethod.put("name", playMethod.getName());
		paramPlayMethod.put("playMethodId", playMethod.getPlayMethodId());
		paramPlayMethod.put("categoryId", playMethod.getCategoryId());
		paramPlayMethod.put("validFlag", playMethod.getValidFlag());
		
		//分页
//		int count = playMethodService.findPlayMethodCount(paramPlayMethod);

		ResultHandleT<Integer> resultHandle = playMethodClientServiceRemote.findPlayMethodCount(paramPlayMethod);
		if(resultHandle == null || resultHandle.isFail()){
			log.error(resultHandle.getMsg());
			throw new BusinessException(resultHandle.getMsg());
		}
		int count = resultHandle.getReturnContent();

		int pagenum = page == null ? 1 : page;
		Page<PlayMethod> pageParam = Page.page(count,20, pagenum);
		pageParam.buildUrl(req);
		
		paramPlayMethod.put("_start", pageParam.getStartRows());
		paramPlayMethod.put("_end", pageParam.getEndRows());
		paramPlayMethod.put("_orderby", "PLAY_METHOD_TYPE_ID");
		paramPlayMethod.put("_order", "ASC");
		
		//List<PlayMethod> playMethodList = playMethodService.findPlayMethodListByParam(paramPlayMethod);
		ResultHandleT<List<PlayMethod>> resultHandle1 = playMethodClientServiceRemote.findPlayMethodListByParam(paramPlayMethod);
		if(resultHandle1 == null || resultHandle1.isFail()){
			log.error(resultHandle1.getMsg());
			throw new BusinessException(resultHandle1.getMsg());
		}
		List<PlayMethod> playMethodList = resultHandle1.getReturnContent();

		pageParam.setItems(playMethodList);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("page", pageParam.getPage().toString());
		
		model.addAttribute("show_playMethodId", playMethod.getPlayMethodId());
		model.addAttribute("show_name", playMethod.getName());
		model.addAttribute("show_validFlag", playMethod.getValidFlag());
		model.addAttribute("show_categoryId", playMethod.getCategoryId());
		model.addAttribute("playMethodList", playMethodList);
		return "/goods/show/playMethod/findPlayMethod";
	    }
	
	/**
	 *跳转添加玩法窗口
	 * @return
	 */
	@RequestMapping("/showAddPlayMethod")
	public String showAddPlayMethod(Model model) throws BusinessException{
		if (log.isDebugEnabled()) {
			log.debug("start method<showAddPlayMethod>");
		}
		List<BizEnum.BIZ_CATEGORY_TYPE> categoryList  = this.getBizCategoryType();
		model.addAttribute("categoryList", categoryList);
//		List<BizEnum.PLAY_METHOD_SUB_CATEGORY> subCategoryList=this.getSubCategory();
//		model.addAttribute("subCategoryList", subCategoryList);
		
		return "/goods/show/playMethod/showAddPlayMethod";
	}

	/**
	 * 添加玩法
	 */
	@RequestMapping("/addPlayMethod")
	@ResponseBody
	public Object addPlayMethod(PlayMethod playMethod) throws BusinessException{
		if (log.isDebugEnabled()) {
			log.debug("start method<addPlayMethod>");
		}
	   if(playMethod!=null){
		//用户选择其他票
		//具有 所属上级这一属性
		if(playMethod.getName().equals("") || playMethod.getName()==null){
			return new ResultMessage("error","请正确填写玩法名称后再提交！");
		}
		if(playMethod.getPinyin().equals("") || playMethod.getPinyin()==null){
			return new ResultMessage("error","请正确填写玩法拼音后再提交！");
		}
		  
		Date currentTime = new Date();
		//设置时间  
		playMethod.setCreateTime(currentTime);
		playMethod.setUpdateTime(currentTime);
		if(14 == playMethod.getCategoryId()){
			playMethod.setPlayMethodTypeId(1008L);
		}
		long playMethodId = playMethodClientServiceRemote.addPlayMethod(playMethod).getReturnContent();
		//playMethodService.addPlayMethod(playMethod);
		
		//添加操作日志
		try {
			comLogService.insert(COM_LOG_OBJECT_TYPE.TICKET_PLAY_METHOD, 
					playMethod.getPlayMethodId(), playMethodId,
					this.getLoginUser().getUserName(), 
					"添加了玩法：【"+playMethod.getName()+"】", 
					COM_LOG_LOG_TYPE.TICKET_PLAY_METHOD_CHANGE.name(), 
					"添加玩法",null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
			log.error(e.getMessage());
		}
		return ResultMessage.ADD_SUCCESS_RESULT;
	   }
	   return ResultMessage.ADD_FAIL_RESULT;
	}
	
	/**
	 * 跳转修改玩法窗口
	 */
	@RequestMapping("/showUpdatePlayMethod")
	public String showUpdatePlayMethod(Model model,Long playMethodId) throws BusinessException{
		if (log.isDebugEnabled()) {
			log.debug("start method<showUpdatePlayMethod>");
		}
//		Long playMethodId = paramPlayMethod.getPlayMethodId();
		//根据Id查询玩法
	    //PlayMethod playMethod = playMethodService.findPlayMethodById(playMethodId);
		ResultHandleT<PlayMethod> resultHandle = playMethodClientServiceRemote.findPlayMethodById(playMethodId);
		if(resultHandle == null || resultHandle.isFail()){
			log.error(resultHandle.getMsg());
			throw new BusinessException(resultHandle.getMsg());
		}

		PlayMethod playMethod = resultHandle.getReturnContent();

		model.addAttribute("playMethod",playMethod);
		model.addAttribute("playMethodId",playMethod.getPlayMethodId());
	
		//所属品类
		List<BizEnum.BIZ_CATEGORY_TYPE> categoryList  = this.getBizCategoryType();
		model.addAttribute("categoryList", categoryList);
		//所属上级
//		List<BizEnum.PLAY_METHOD_SUB_CATEGORY> subCategoryList=this.getSubCategory();
//		model.addAttribute("subCategoryList", subCategoryList);
		model.addAttribute("subCategoryId",playMethod.getSubCategoryId());
		model.addAttribute("validFlag",playMethod.getValidFlag());
		model.addAttribute("redFlag",playMethod.getRedFlag());
		model.addAttribute("categoryId",playMethod.getCategoryId());
		
		return "/goods/show/playMethod/showUpdatePlayMethod";
	}
	
	/**
	 * 更新玩法
	 * @param playMethod
	 * @return
	 */
	@RequestMapping("/updatePlayMethod")
	@ResponseBody
	public Object updatePlayMethod(PlayMethod playMethod) throws BusinessException{
		if (log.isDebugEnabled()) {
			log.debug("start method<updatePlayMethod>");
		}
	   
		if(null==playMethod){
			return new ResultMessage("error","请填写完表单后再提交！");
		}
		//用户选择其他票
		//具有 所属上级这一属性
		if(playMethod.getName().equals("") || playMethod.getName()==null){
			return new ResultMessage("error","请正确填写玩法名称后再提交！");
		}
		if(playMethod.getPinyin().equals("") || playMethod.getPinyin()==null){
			return new ResultMessage("error","请正确填写玩法拼音后再提交！");
		}
		//设置更新时间  
		playMethod.setUpdateTime(new Date());
		
		if(14 == playMethod.getCategoryId()){
			playMethod.setPlayMethodTypeId(1008L);
		}
		
		//获取旧玩法
		ResultHandleT<PlayMethod> resultHandle = playMethodClientServiceRemote.findPlayMethodById(playMethod.getPlayMethodId());
		if(resultHandle == null || resultHandle.isFail()){
			log.error(resultHandle.getMsg());
			throw new BusinessException(resultHandle.getMsg());
		}
		PlayMethod oldPlayMethod = resultHandle.getReturnContent();

		//playMethodService.savePlayMethod(playMethod);
		 long playMethodId = playMethodClientServiceRemote.savePlayMethod(playMethod).getReturnContent();
		
		//日志操作
		try {
			String logContent = getPlayMethodChangeLog(oldPlayMethod, playMethod);
			if(null!=logContent && !"".equals(logContent)) {
				comLogService.insert(COM_LOG_OBJECT_TYPE.TICKET_PLAY_METHOD, 
						playMethod.getPlayMethodId(), playMethodId,
						this.getLoginUser().getUserName(), 
						"修改了玩法：【"+playMethod.getName()+"】，修改内容："+logContent, 
						COM_LOG_LOG_TYPE.TICKET_PLAY_METHOD_CHANGE.name(), 
						"修改玩法",null);
			}
		} catch (Exception e) {
			log.error("Record Log failure ！Log Type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_PRODUCT_CHANGE.name());
			log.error(e.getMessage());
		}
		
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}
	
	/**
	 * 点击添加玩法
	 * 弹出选择玩法窗口
	 * 
	 */
	@RequestMapping("/showSelectPlayMethod")
	public String showSelectPlayMethod(Model model,Long productId,Integer page,PlayMethod playMethod,HttpServletRequest req) throws BusinessException{
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showSelectPlayMethod>");
		}
		if(null != productId && null != playMethod){

			//封装搜索条件
			Map<String,Object> playMethodParam = new HashMap<String,Object>();
			playMethodParam.put("playMethodTypeId", playMethod.getPlayMethodTypeId());
			playMethodParam.put("name", playMethod.getName());			
			//playMethodParam.put("playMethodId",playMethod.getPlayMethodId());
			playMethodParam.put("productId",productId);
			//分页
			//int count = playMethodService.findPlayMethodCount(playMethodParam);
			ResultHandleT<Integer> resultHandle = playMethodClientServiceRemote.findPlayMethodCount(playMethodParam);
			if(resultHandle == null || resultHandle.isFail()){
				log.error(resultHandle.getMsg());
				throw new BusinessException(resultHandle.getMsg());
			}
			int count = resultHandle.getReturnContent();

			int pagenum = page == null ? 1 : page;
			Page<PlayMethod> pageParam = Page.page(count,10, pagenum);
			pageParam.buildUrl(req);
			
			playMethodParam.put("_start", pageParam.getStartRows());
			playMethodParam.put("_end", pageParam.getEndRows());
			playMethodParam.put("_orderby", "pm.PLAY_METHOD_TYPE_ID");
			playMethodParam.put("_order", "ASC");
			//查询玩法列表
			ResultHandleT<List<PlayMethod>> resultHandle1 = playMethodClientServiceRemote.selectPlayMethodListByParam(playMethodParam);
			if(resultHandle1 == null || resultHandle1.isFail()){
				log.error(resultHandle1.getMsg());
				throw new BusinessException(resultHandle1.getMsg());
			}
			List<PlayMethod> playMethodList = resultHandle1.getReturnContent();
			//List<PlayMethod> playMethodList = playMethodService.selectPlayMethodListByParam(playMethodParam);
			pageParam.setItems(playMethodList);
			model.addAttribute("pageParam", pageParam);
			
			model.addAttribute("page", pageParam.getPage().toString());
			//玩法类型
			List<PLAY_METHOD_PRODUCT_TYPE> playMethodTypeList = this.getPlayMethodType();
			model.addAttribute("playMethodTypeList", playMethodTypeList);
			model.addAttribute("playMethodTypeId", playMethod.getPlayMethodTypeId());
			model.addAttribute("name", playMethod.getName());
			model.addAttribute("productId", productId);
			model.addAttribute("playMethodId", playMethod.getPlayMethodId());
			
		}
		return "/goods/show/playMethod/showSelectPlayMethod";
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
		
		if(null != prodPlayMethodRe && null != prodPlayMethodRe.getProductId() && stringArray.length > 0){
				ResultHandleT<ProdPlayMethodRe> resultHandle = playMethodClientServiceRemote.findMaxSeq(prodPlayMethodRe.getProductId());
				if(resultHandle == null || resultHandle.isFail()){
					log.error(resultHandle.getMsg());
					throw new BusinessException(resultHandle.getMsg());
				}
				ProdPlayMethodRe getProdPlayMethodRe = resultHandle.getReturnContent();

				//ProdPlayMethodRe getProdPlayMethodRe = playMethodService.findMaxSeq(prodPlayMethodRe.getProductId());
				if(null != getProdPlayMethodRe){
					Long maxSeq = getProdPlayMethodRe.getSeq();
					if(maxSeq >= 0){
						for(int i=0;i<stringArray.length;i++){
							Long playMehtodId = Long.valueOf(stringArray[i]);
							prodPlayMethodRe.setPlayMethodId(playMehtodId);
							prodPlayMethodRe.setSeq((long)i+1+maxSeq);
							prodPlayMethodRe.setUpdateTime(new Date());
							playMethodClientServiceRemote.saveSelectPlayMethod(prodPlayMethodRe);
							//playMethodService.saveSelectPlayMethod(prodPlayMethodRe);
						try {
							// 操作执行消息推送
							this.pushAdapterService
									.push(prodPlayMethodRe.getProductId(),
											ComPush.OBJECT_TYPE.PRODUCT,
											ComPush.PUSH_CONTENT.PROD_PLAY_METHOD_RE,
											ComPush.OPERATE_TYPE.ADD,
											ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
						} catch (Exception e) {
							log.error("perform push notification failure ！push type:"
									+ COM_LOG_LOG_TYPE.TAG_ADD.name());
							log.error(e.getMessage());
						}
							//绑定产品
							ResultHandleT<PlayMethod> resultHandle1 = playMethodClientServiceRemote.findPlayMethodById(playMehtodId);
							if(resultHandle1 == null || resultHandle1.isFail()){
								log.error(resultHandle1.getMsg());
								throw new BusinessException(resultHandle1.getMsg());
							}
							PlayMethod playMethod = resultHandle1.getReturnContent();
							//PlayMethod playMethod = playMethodService.findPlayMethodById(playMehtodId);
							Long count = playMethod.getProdBindCount();
						    if(null != count && count >= 0){
						    	//更新prodBindCount
						    	playMethod.setProdBindCount(count+1);
								playMethodClientServiceRemote.updateProdBindCount(playMethod);
						    	//playMethodService.updateProdBindCount(playMethod);
						    }else{
						    	playMethod.setProdBindCount((long)1);
								playMethodClientServiceRemote.updateProdBindCount(playMethod);
						    	//playMethodService.updateProdBindCount(playMethod);
						    }
						}
					}
				}else{
					for(int i=0;i<stringArray.length;i++){
						Long playMehtodId = Long.valueOf(stringArray[i]);
						prodPlayMethodRe.setPlayMethodId(playMehtodId);
						prodPlayMethodRe.setSeq((long)i+1);
						prodPlayMethodRe.setUpdateTime(new Date());
						playMethodClientServiceRemote.saveSelectPlayMethod(prodPlayMethodRe);
						//playMethodService.saveSelectPlayMethod(prodPlayMethodRe);
					try {
						// 操作执行消息推送
						this.pushAdapterService.push(
								prodPlayMethodRe.getProductId(),
								ComPush.OBJECT_TYPE.PRODUCT,
								ComPush.PUSH_CONTENT.PROD_PLAY_METHOD_RE,
								ComPush.OPERATE_TYPE.ADD,
								ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
					} catch (Exception e) {
						log.error("perform push notification failure ！push type:"
								+ COM_LOG_LOG_TYPE.TAG_ADD.name());
						log.error(e.getMessage());
					}
						//绑定产品
						ResultHandleT<PlayMethod> resultHandle2 = playMethodClientServiceRemote.findPlayMethodById(playMehtodId);
						if(resultHandle2 == null || resultHandle2.isFail()){
							log.error(resultHandle2.getMsg());
							throw new BusinessException(resultHandle2.getMsg());
						}
						PlayMethod playMethod = resultHandle2.getReturnContent();
						//PlayMethod playMethod = playMethodService.findPlayMethodById(playMehtodId);
						Long count = playMethod.getProdBindCount();
						
					    if(null != count && count >= 0){
					    	//更新prodBindCount
					    	playMethod.setProdBindCount(count+1);
							playMethodClientServiceRemote.updateProdBindCount(playMethod);
					    	//playMethodService.updateProdBindCount(playMethod);
					    }else{
					    	playMethod.setProdBindCount((long)1);
							playMethodClientServiceRemote.updateProdBindCount(playMethod);
					    	//playMethodService.updateProdBindCount(playMethod);
					    }
					}
				}
			//查询保存的数据显示出来
			ResultHandleT<List<PlayMethod>> resultHandle3 = playMethodClientServiceRemote.findPlayMethodByProductId(prodPlayMethodRe.getProductId());
			if(resultHandle3 == null || resultHandle3.isFail()){
				log.error(resultHandle3.getMsg());
				throw new BusinessException(resultHandle3.getMsg());
			}
			List<PlayMethod> playMethodList = resultHandle3.getReturnContent();
			//List<PlayMethod> playMethodList = playMethodService.findPlayMethodByProductId(prodPlayMethodRe.getProductId());
			List<PlayMethod> list = new ArrayList<PlayMethod>();
			List<PLAY_METHOD_PRODUCT_TYPE> playMethodTypeList = this.getPlayMethodType();
			for(PlayMethod pm : playMethodList){
				if(null != pm.getSeq() && pm.getSeq() > 0){
				for(PLAY_METHOD_PRODUCT_TYPE pt : playMethodTypeList){
					if(pt.getCategoryId().equals(pm.getPlayMethodTypeId())){
						pm.setPlayMethodTpyeName(pt.getCategoryName());
					}
				}
				list.add(pm);
				}
			}	
			return list;
		} else{
			return new ResultMessage("error", "系统出现异常！");
		}
	}
	
	/**
	 * 保存
	 * 保存用户设定的玩法、更新用户在弹框中选中的玩法
	 * @param prodPlayMethodRe
	 * @param tableValueArray
	 */
	@RequestMapping("/saveAllPlayMethod")
	@ResponseBody
	public Object saveAllPlayMethod(ProdPlayMethodRe prodPlayMethodRe,String tableValueArray,String sign) throws BusinessException{
		
		if(null != prodPlayMethodRe && null != prodPlayMethodRe.getProductId()){
			Long playMethodId = prodPlayMethodRe.getPlayMethodId();
			//将json格式解析成java数组
			List<Map> objectList=JSONObject.parseArray(tableValueArray, Map.class);
			Map<String,Object> param = new HashMap<String,Object>();
			param.put("productId", prodPlayMethodRe.getProductId());
			ResultHandleT<List<ProdPlayMethodRe>> resultHandle = playMethodClientServiceRemote.selectPlayMethodReByParams(param);
			if(resultHandle == null || resultHandle.isFail()){
				log.error(resultHandle.getMsg());
				throw new BusinessException(resultHandle.getMsg());
			}
			List<ProdPlayMethodRe> allPlayMethodReList = resultHandle.getReturnContent();
			//List<ProdPlayMethodRe> allPlayMethodReList = playMethodService.selectPlayMethodReByParams(param);
			//查询是否已保存主玩法
			ResultHandleT<List<ProdPlayMethodRe>> resultHandle2 = playMethodClientServiceRemote.findMainPlayMethod(param);
			if(resultHandle2 == null || resultHandle2.isFail()){
				log.error(resultHandle2.getMsg());
				throw new BusinessException(resultHandle2.getMsg());
			}
			List<ProdPlayMethodRe> prodPlayMethodReList = resultHandle2.getReturnContent();
			//List<ProdPlayMethodRe> prodPlayMethodReList = playMethodService.findMainPlayMethod(param);
			String mark = "N";
			ProdProduct product = null;
			Object selectProdProduct = this.selectProdProduct(prodPlayMethodRe.getProductId());
			if(null != selectProdProduct){
                product = (ProdProduct)selectProdProduct;
			}
			//有效产品
			if("Y".equals(product.getCancelFlag())){
				if(!CollectionUtils.isEmpty(objectList) && !CollectionUtils.isEmpty(allPlayMethodReList)){
					//更新次玩法
                    this.updatePlayMethodSeq(objectList,allPlayMethodReList,prodPlayMethodRe);
        			return ResultMessage.UPDATE_SUCCESS_RESULT;
				}
			}else{
			    //主玩法不存在
				if(CollectionUtils.isEmpty(prodPlayMethodReList)){
					//保存主玩法  
				    if(null != playMethodId){
				   		for(Map<String, Object> map :objectList){
							String playMethodIdStr = map.get("playMethodId").toString();
							if(StringUtil.isNotEmptyString(playMethodIdStr) && null != playMethodId
									&& playMethodIdStr.equals(playMethodId.toString())){
								//次玩法和主玩法相等
								mark = "Y";
							}
				        }
						if(!"Y".equals(mark)){
							prodPlayMethodRe.setSeq((long) 0);
					        prodPlayMethodRe.setUpdateTime(new Date());
							playMethodClientServiceRemote.saveSelectPlayMethod(prodPlayMethodRe);
					        //playMethodService.saveSelectPlayMethod(prodPlayMethodRe);
							LOG.info("saveSelectPlayMethod:"+ playMethodId);
							try {
								// 操作执行消息推送
								this.pushAdapterService.push(
										prodPlayMethodRe.getProductId(),
										ComPush.OBJECT_TYPE.PRODUCT,
										ComPush.PUSH_CONTENT.PROD_PLAY_METHOD_RE,
										ComPush.OPERATE_TYPE.ADD,
										ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
							} catch (Exception e) {
								log.error("perform push notification failure ！push type:"
										+ COM_LOG_LOG_TYPE.TAG_ADD.name());
								log.error(e.getMessage());
							}
							ResultHandleT<PlayMethod> resultHandle3 = playMethodClientServiceRemote.findPlayMethodById(playMethodId);
							if(resultHandle3 == null || resultHandle3.isFail()){
								log.error(resultHandle3.getMsg());
								throw new BusinessException(resultHandle3.getMsg());
							}
							PlayMethod playMethod = resultHandle3.getReturnContent();
							//PlayMethod playMethod = playMethodService.findPlayMethodById(playMethodId);
					        Long count = playMethod.getProdBindCount();
				            if(null != count && count >= 0){
							    //更新prodBindCount
							    playMethod.setProdBindCount(count+1);
								playMethodClientServiceRemote.updateProdBindCount(playMethod);
							    //playMethodService.updateProdBindCount(playMethod);
				            }else{
							    playMethod.setProdBindCount((long)1);
								playMethodClientServiceRemote.updateProdBindCount(playMethod);
								//playMethodService.updateProdBindCount(playMethod);
				            }
						}
				   }
				   //更新次玩法
				   if(!CollectionUtils.isEmpty(objectList) && !CollectionUtils.isEmpty(allPlayMethodReList)){
					  this.updatePlayMethodSeq(objectList,allPlayMethodReList,prodPlayMethodRe);
				   }
				   return ResultMessage.ADD_SUCCESS_RESULT;
				}
				//有主玩法
				if(null != prodPlayMethodReList && prodPlayMethodReList.size()==1){
					//更新主玩法
					if(null != playMethodId){
						for(Map<String, Object> map :objectList){
							String playMethodIdStr = map.get("playMethodId").toString();
							if(StringUtil.isNotEmptyString(playMethodIdStr) && null != playMethodId
									&& playMethodIdStr.equals(playMethodId.toString())){
								//次玩法和主玩法相等
								mark = "Y";
							}
				        }
						if(!"Y".equals(mark)){
						    ProdPlayMethodRe mainPlayMethod = prodPlayMethodReList.get(0);
							if(null != mainPlayMethod.getPlayMethodId() && null != playMethodId && 
									!mainPlayMethod.getPlayMethodId().equals(playMethodId)){
								prodPlayMethodRe.setSeq((long)0);
								prodPlayMethodRe.setUpdateTime(new Date());
								//更新主玩法 根据产品id、seq
								playMethodClientServiceRemote.updateMainPlayMethod(prodPlayMethodRe);
								//playMethodService.updateMainPlayMethod(prodPlayMethodRe);
								LOG.info("updateMainPlayMethod:old:"+ mainPlayMethod.getPlayMethodId() +",new:"+  playMethodId);
								try {
									// 操作执行消息推送
									this.pushAdapterService
											.push(prodPlayMethodRe.getProductId(),
													ComPush.OBJECT_TYPE.PRODUCT,
													ComPush.PUSH_CONTENT.PROD_PLAY_METHOD_RE,
													ComPush.OPERATE_TYPE.UP,
													ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
								} catch (Exception e) {
									log.error("perform push notification failure ！push type:"
											+ COM_LOG_LOG_TYPE.TAG_UPDATE.name());
									log.error(e.getMessage());
								}
								//产品与原来玩法解绑
								ResultHandleT<PlayMethod> resultHandle4 = playMethodClientServiceRemote.findPlayMethodById(mainPlayMethod.getPlayMethodId());
								if(resultHandle4 == null || resultHandle4.isFail()){
									log.error(resultHandle4.getMsg());
									throw new BusinessException(resultHandle4.getMsg());
								}
								PlayMethod oldPlayMethod = resultHandle4.getReturnContent();
								//PlayMethod oldPlayMethod = playMethodService.findPlayMethodById(mainPlayMethod.getPlayMethodId());
								Long count = oldPlayMethod.getProdBindCount();
								if(count >= 1){
									//更新prodBindCount
									oldPlayMethod.setProdBindCount(count-1);
									//playMethodService.updateProdBindCount(oldPlayMethod);
									playMethodClientServiceRemote.updateProdBindCount(oldPlayMethod);
								}else{
									oldPlayMethod.setProdBindCount((long)0);
									//playMethodService.updateProdBindCount(oldPlayMethod);
									playMethodClientServiceRemote.updateProdBindCount(oldPlayMethod);
								}
								//产品与新的玩法绑定
								ResultHandleT<PlayMethod> resultHandle5 = playMethodClientServiceRemote.findPlayMethodById(playMethodId);
								if(resultHandle5 == null || resultHandle5.isFail()){
									log.error(resultHandle5.getMsg());
									throw new BusinessException(resultHandle5.getMsg());
								}
								PlayMethod playMethod = resultHandle5.getReturnContent();
								//PlayMethod playMethod = playMethodService.findPlayMethodById(playMethodId);
								Long number = playMethod.getProdBindCount();
								if(null != number && number >= 0){
									//更新prodBindCount
									playMethod.setProdBindCount(number+1);
									playMethodClientServiceRemote.updateProdBindCount(oldPlayMethod);
									//playMethodService.updateProdBindCount(playMethod);
								}else{
									playMethod.setProdBindCount((long)1);
									playMethodClientServiceRemote.updateProdBindCount(playMethod);
									//playMethodService.updateProdBindCount(playMethod);
								}
							}
						}
					}
				 	//更新次玩法
				   if(!CollectionUtils.isEmpty(objectList) && !CollectionUtils.isEmpty(allPlayMethodReList)){
					  this.updatePlayMethodSeq(objectList,allPlayMethodReList,prodPlayMethodRe);
				   }
				   return ResultMessage.ADD_SUCCESS_RESULT;
			    }else{
			    	return new ResultMessage("error", "系统出现异常！");
			    }
			}
		}else{
			return new ResultMessage("error", "系统出现异常！");
		}
		return new ResultMessage("error", "系统出现异常！");
    }
	
	/**
	 * 根据productId和playMethodId删除玩法
	 * @param prodPlayMethodRe
	 * @return
	 */
	@RequestMapping("/deletePlayMethod")
	@ResponseBody
	public Object deletePlayMethod(ProdPlayMethodRe prodPlayMethodRe,String sign) throws BusinessException{
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<deletePlayMethod>");
		}
		
		if(null != prodPlayMethodRe){
			if(null != prodPlayMethodRe.getProductId() && null != prodPlayMethodRe.getPlayMethodId()){
				if(null != sign && "Y".equals(sign)){
					Map<String,Object> param = new HashMap<String,Object>();
					param.put("productId", prodPlayMethodRe.getProductId());
					ResultHandleT<List<ProdPlayMethodRe>> resultHandle = playMethodClientServiceRemote.findMainPlayMethod(param);
					if(resultHandle == null || resultHandle.isFail()){
						log.error(resultHandle.getMsg());
						throw new BusinessException(resultHandle.getMsg());
					}
					List<ProdPlayMethodRe> prodPlayMethodReList = resultHandle.getReturnContent();
					//List<ProdPlayMethodRe> prodPlayMethodReList = playMethodService.findMainPlayMethod(param);
					if(!CollectionUtils.isEmpty(prodPlayMethodReList) && prodPlayMethodReList.size()==1){
						//删除以前的主玩法，并将次玩法设置为主玩法(注意与产品的绑定关系)
						ProdPlayMethodRe mainProdPlayMethodRe = prodPlayMethodReList.get(0);
						param.put("playMethodId", mainProdPlayMethodRe.getPlayMethodId());
						//playMethodService.deletePlayMethod(param);
						playMethodClientServiceRemote.deletePlayMethod(param);
						try {
							// 操作执行消息推送
							this.pushAdapterService.push(
									prodPlayMethodRe.getProductId(),
									ComPush.OBJECT_TYPE.PRODUCT,
									ComPush.PUSH_CONTENT.PROD_PLAY_METHOD_RE,
									ComPush.OPERATE_TYPE.DEL,
									ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
						} catch (Exception e) {
							log.error("perform push notification failure ！push type:"
									+ COM_LOG_LOG_TYPE.TAG_DELETE.name());
							log.error(e.getMessage());
						}
						//删除玩法，解除绑定
						ResultHandleT<PlayMethod> resultHandle2 = playMethodClientServiceRemote.findPlayMethodById(mainProdPlayMethodRe.getPlayMethodId());
						if(resultHandle2 == null || resultHandle2.isFail()){
							log.error(resultHandle2.getMsg());
							throw new BusinessException(resultHandle2.getMsg());
						}
						PlayMethod playMethod = resultHandle2.getReturnContent();
						//PlayMethod playMethod = playMethodService.findPlayMethodById(mainProdPlayMethodRe.getPlayMethodId());
						Long count = playMethod.getProdBindCount();
						if(count >= 1){
							//更新prodBindCount
							playMethod.setProdBindCount(count-1);
							//playMethodService.updateProdBindCount(playMethod);
							playMethodClientServiceRemote.updateProdBindCount(playMethod);
						}else{
							playMethod.setProdBindCount((long)0);
							//playMethodService.updateProdBindCount(playMethod);
							playMethodClientServiceRemote.updateProdBindCount(playMethod);
						}
						prodPlayMethodRe.setSeq((long)0);
						prodPlayMethodRe.setUpdateTime(new Date());
						//更新主玩法 根据产品id、seq
						playMethodClientServiceRemote.updatePlayMethodSeq(prodPlayMethodRe);
						//playMethodService.updatePlayMethodSeq(prodPlayMethodRe);
	    				try {
	    					// 操作执行消息推送
	    					this.pushAdapterService
	    							.push(prodPlayMethodRe.getProductId(),
	    									ComPush.OBJECT_TYPE.PRODUCT,
	    									ComPush.PUSH_CONTENT.PROD_PLAY_METHOD_RE,
	    									ComPush.OPERATE_TYPE.UP,
	    									ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
	    				} catch (Exception e) {
	    					log.error("perform push notification failure ！push type:"
	    							+ COM_LOG_LOG_TYPE.TAG_UPDATE.name());
	    					log.error(e.getMessage());
	    				}
					}else if(CollectionUtils.isEmpty(prodPlayMethodReList)){
						//将次玩法设置为主玩法（没有绑定关系）
						prodPlayMethodRe.setSeq((long)0);
						prodPlayMethodRe.setUpdateTime(new Date());
						//更新主玩法 根据产品id、seq
						playMethodClientServiceRemote.updatePlayMethodSeq(prodPlayMethodRe);
						//playMethodService.updatePlayMethodSeq(prodPlayMethodRe);
	    				try {
	    					// 操作执行消息推送
	    					this.pushAdapterService
	    							.push(prodPlayMethodRe.getProductId(),
	    									ComPush.OBJECT_TYPE.PRODUCT,
	    									ComPush.PUSH_CONTENT.PROD_PLAY_METHOD_RE,
	    									ComPush.OPERATE_TYPE.UP,
	    									ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
	    				} catch (Exception e) {
	    					log.error("perform push notification failure ！push type:"
	    							+ COM_LOG_LOG_TYPE.TAG_UPDATE.name());
	    					log.error(e.getMessage());
	    				}
					}else{
						return new ResultMessage("error", "系统出现异常！");
					}
				}else{
					//删除次玩法
					Map<String,Object> param = new HashMap<String,Object>();
					param.put("productId", prodPlayMethodRe.getProductId());
					param.put("playMethodId", prodPlayMethodRe.getPlayMethodId());
					//执行删除操作
					playMethodClientServiceRemote.deletePlayMethod(param);
					//playMethodService.deletePlayMethod(param);
					try {
						// 操作执行消息推送
						this.pushAdapterService.push(
								prodPlayMethodRe.getProductId(),
								ComPush.OBJECT_TYPE.PRODUCT,
								ComPush.PUSH_CONTENT.PROD_PLAY_METHOD_RE,
								ComPush.OPERATE_TYPE.DEL,
								ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
					} catch (Exception e) {
						log.error("perform push notification failure ！push type:"
								+ COM_LOG_LOG_TYPE.TAG_DELETE.name());
						log.error(e.getMessage());
					}
					//删除玩法，解除绑定
					ResultHandleT<PlayMethod> resultHandle = playMethodClientServiceRemote.findPlayMethodById(prodPlayMethodRe.getPlayMethodId());
					if(resultHandle == null || resultHandle.isFail()){
						log.error(resultHandle.getMsg());
						throw new BusinessException(resultHandle.getMsg());
					}
					PlayMethod playMethod = resultHandle.getReturnContent();

					Long count = playMethod.getProdBindCount();
					if(count >= 1){
						//更新prodBindCount
						playMethod.setProdBindCount(count-1);
						//playMethodService.updateProdBindCount(playMethod);
						playMethodClientServiceRemote.updateProdBindCount(playMethod);
					}else{
						playMethod.setProdBindCount((long)0);
						//playMethodService.updateProdBindCount(playMethod);
						playMethodClientServiceRemote.updateProdBindCount(playMethod);
					}
				}
			    //玩法类型
				List<PLAY_METHOD_PRODUCT_TYPE> playMethodTypeList = this.getPlayMethodType();
				//回显数据
				ResultHandleT<List<PlayMethod>> resultHandle = playMethodClientServiceRemote.findPlayMethodByProductId(prodPlayMethodRe.getProductId());
				if(resultHandle == null || resultHandle.isFail()){
					log.error(resultHandle.getMsg());
					throw new BusinessException(resultHandle.getMsg());
				}
				List<PlayMethod> list = resultHandle.getReturnContent();
				//List<PlayMethod> list = playMethodService.findPlayMethodByProductId(prodPlayMethodRe.getProductId());
				List<PlayMethod> playMethodList = new ArrayList<PlayMethod>();
				for(PlayMethod pm : list){
					if(null != pm.getSeq() && pm.getSeq() > 0){
						for(PLAY_METHOD_PRODUCT_TYPE pt : playMethodTypeList){
							if(pt.getCategoryId().equals(pm.getPlayMethodTypeId())){
								pm.setPlayMethodTpyeName(pt.getCategoryName());
							}
						}
						playMethodList.add(pm);
					}
				}
				return playMethodList;
			}else{
				return new ResultMessage("error", "系统出现异常！");
			}
		}else{
			return new ResultMessage("error", "系统出现异常！");
		}
	}
	
	/**
	 * 操作主页面
	 * @param model
	 * @return
	 */
	@RequestMapping("/selectMainPlayMethodCategory")
	public Object findMainPlayMethodCategory(Model model,Long productId,Long categoryId) throws BusinessException{
        LOG.info("页面传来的参数=====productId：" + productId + "，categoryId：" + categoryId);
		if(null != productId){
			//玩法类型
			List<PLAY_METHOD_PRODUCT_TYPE> typeList = this.getPlayMethodType();
			//演出票只能选择
			if(CATEGORYID.equals(categoryId.toString())){
				for(PLAY_METHOD_PRODUCT_TYPE playMethodType : typeList){
					if(PLAYMETHODTYPE.equals(playMethodType.getCode())){
						List<PLAY_METHOD_PRODUCT_TYPE> playMethodTypeList = new ArrayList<PLAY_METHOD_PRODUCT_TYPE>();
						playMethodTypeList.add(playMethodType);
						LOG.info("玩法类型(演出展览)=====playMethodTypeList：" + playMethodTypeList);
						model.addAttribute("playMethodTypeList", playMethodTypeList);
					}
				}
			}
			//查询产品
			//ProdProduct product = this.prodProductService.getProdProductBy(productId);
			ResultHandleT<ProdProduct> prodProductBy = this.prodProductService.getProdProductBy(productId);
			if(prodProductBy != null){
			ProdProduct product = prodProductBy.getReturnContent();
			//有效产品的玩法
			model.addAttribute("cancelFlag", product.getCancelFlag());
			//回显玩法列表
			ResultHandleT<List<PlayMethod>> resultHandle = playMethodClientServiceRemote.findPlayMethodByProductId(productId);
			if(resultHandle == null || resultHandle.isFail()){
				log.error(resultHandle.getMsg());
				throw new BusinessException(resultHandle.getMsg());
			}
			List<PlayMethod> list = resultHandle.getReturnContent();
			//List<PlayMethod> list = playMethodService.findPlayMethodByProductId(productId);
			LOG.info("玩法列表=====list：" + list);
			List<PlayMethod> playMethodList = new ArrayList<PlayMethod>();
			if(list.size() > 0){
				for(PlayMethod pm : list){
					if(null != pm.getSeq() && pm.getSeq().equals(0L)){
						List<PlayMethod> allPlayMethodList = this.getPlayMethodList(pm.getPlayMethodTypeId());
						model.addAttribute("allPlayMethodList", allPlayMethodList);
						model.addAttribute("playMethodTypeId", pm.getPlayMethodTypeId());
						model.addAttribute("name", pm.getName());
						model.addAttribute("playMethodId", pm.getPlayMethodId());
					}else{
						for(PLAY_METHOD_PRODUCT_TYPE pt : typeList){
							if(pt.getCategoryId().equals(pm.getPlayMethodTypeId())){
								pm.setPlayMethodTpyeName(pt.getCategoryName());
							}
						}
						playMethodList.add(pm);
					}
				}
			}
			model.addAttribute("playMethodList", playMethodList);
			model.addAttribute("productId", productId);
			}
			
			return "/goods/show/playMethod/selectMainPlayMethodCategory";
			
		}
		return new ResultMessage("error", "系统出现异常！");
	}
	
	/**
	 * ajax获取玩法名称集合
	 * @param playMethodTypeId
	 * @return
	 */
	@RequestMapping("/ajaxRequest")
	@ResponseBody
    public Map<Object,Object> ajaxRequest(Long playMethodTypeId) throws BusinessException{
	   if(null != playMethodTypeId){
		    //演出展览
			if(playMethodTypeId == 1001){
				Map<Object, Object> playMethodMap = this.ajaxRequestFun(playMethodTypeId);
				return playMethodMap;
			}
			//美食
			if(playMethodTypeId == 1002){
				Map<Object, Object> playMethodMap = this.ajaxRequestFun(playMethodTypeId);
				return playMethodMap;
			}
			//购物
			if(playMethodTypeId == 1003){
				Map<Object, Object> playMethodMap = this.ajaxRequestFun(playMethodTypeId);
				return playMethodMap;
			}
			//休闲娱乐
			if(playMethodTypeId == 1004){
				Map<Object, Object> playMethodMap = this.ajaxRequestFun(playMethodTypeId);
				return playMethodMap;
			}
			//户外体验
			if(playMethodTypeId == 1005){
				Map<Object, Object> playMethodMap = this.ajaxRequestFun(playMethodTypeId);
				return playMethodMap;
			}
			//自驾服务
			if(playMethodTypeId == 1006){
				Map<Object, Object> playMethodMap = this.ajaxRequestFun(playMethodTypeId);
				return playMethodMap;
			}
			//交通接驳
			if(playMethodTypeId == 1007){
				Map<Object, Object> playMethodMap = this.ajaxRequestFun(playMethodTypeId);
				return playMethodMap;
			}
			return null;
		}
	   return null;	
	}
	
	/**
	 * 根据产品Id查询产品
	 */
	@RequestMapping("/selectProdProduct")
	@ResponseBody
	public Object selectProdProduct(Long productId) throws BusinessException{
		ResultHandleT<ProdProduct> prodProductBy = this.prodProductService.getProdProductBy(productId);
		if(prodProductBy != null){
			ProdProduct product = prodProductBy.getReturnContent();
			if(null != product){
				return product;
			}else{
				return null;
			}
		}else {
			return null;
		}
		
	}
	
	/**
	 * 查询主玩法
	 */
	@RequestMapping("/selectMainPlayMethod")
	@ResponseBody
	public ProdPlayMethodRe findMainPlayMethod(Long productId) throws BusinessException{
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("productId", productId);
		//查询已保存主玩法
		ResultHandleT<List<ProdPlayMethodRe>> resultHandle = playMethodClientServiceRemote.findMainPlayMethod(param);
		if(resultHandle == null || resultHandle.isFail()){
			log.error(resultHandle.getMsg());
			throw new BusinessException(resultHandle.getMsg());
		}
		List<ProdPlayMethodRe> prodPlayMethodReList = resultHandle.getReturnContent();
		//List<ProdPlayMethodRe> prodPlayMethodReList = playMethodService.findMainPlayMethod(param);
		if(!CollectionUtils.isEmpty(prodPlayMethodReList)){
			return prodPlayMethodReList.get(0);
		}
		return null;
	}
	
	/**
	 * 回显已选择玩法列表
	 */
	@RequestMapping("/addPlayMethodButton")
	public String addPlayMethodButton(Model model,Long productId) throws BusinessException{
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<addPlayMethodButton>");
		}
		
		if(null != productId && productId>0){
			//所属上级
//			List<BizEnum.PLAY_METHOD_SUB_CATEGORY> subCategoryList=this.getSubCategory();
//			model.addAttribute("subCategoryList", subCategoryList);
			ResultHandleT<List<PlayMethod>> resultHandle = playMethodClientServiceRemote.findPlayMethodByProductId(productId);
			if(resultHandle == null || resultHandle.isFail()){
				log.error(resultHandle.getMsg());
				throw new BusinessException(resultHandle.getMsg());
			}
			List<PlayMethod> playMethodList = resultHandle.getReturnContent();
			//List<PlayMethod> playMethodList = playMethodService.findPlayMethodByProductId(productId);
			if(!CollectionUtils.isEmpty(playMethodList)){
				model.addAttribute("playMethodList", playMethodList);
			}
			model.addAttribute("productId", productId);
		}else{
			model.addAttribute("error", "禁止访问！");
		}
		return "/goods/show/playMethod/addPlayMethodButton";
	}
	
	private String getPlayMethodChangeLog(PlayMethod oldPlayMethod,PlayMethod newPlayMethod){
		 StringBuilder logStr = new StringBuilder("");
		 String newCategoryName="";
		 String oldCategoryName="";
		 if(null!= newPlayMethod) {
			 //玩法名称
			 logStr.append(ComLogUtil.getLogTxt("玩法名称",newPlayMethod.getName(),oldPlayMethod.getName()));
			 logStr.append(ComLogUtil.getLogTxt("玩法拼音",newPlayMethod.getPinyin(),oldPlayMethod.getPinyin()));
			
			 //所属品类
			 List<BizEnum.BIZ_CATEGORY_TYPE> categoryList  = this.getBizCategoryType();

			 if(! newPlayMethod.getCategoryId().equals(oldPlayMethod.getCategoryId())){
				   for(BizEnum.BIZ_CATEGORY_TYPE category:categoryList){
				 		if(category.getCategoryId().equals(newPlayMethod.getCategoryId())){
				 			newCategoryName = category.getCnName();
				 		}
				 	}
				 	for(BizEnum.BIZ_CATEGORY_TYPE category:categoryList){
				 		if(category.getCategoryId().equals(oldPlayMethod.getCategoryId())){
				 			oldCategoryName = category.getCnName();
				 		}
				 	} 
				   logStr.append(ComLogUtil.getLogTxt("所属品类",newCategoryName,oldCategoryName));
			 }

			 logStr.append(ComLogUtil.getLogTxt("是否标红","Y".equals(newPlayMethod.getRedFlag())?"是":"否","Y".equals(oldPlayMethod.getRedFlag())?"是":"否"));
			 logStr.append(ComLogUtil.getLogTxt("是否有效","Y".equals(newPlayMethod.getValidFlag())?"是":"否","Y".equals(oldPlayMethod.getValidFlag())?"是":"否"));

		 }
		 return logStr.toString();
	 }
	
	private Map<Object, Object> ajaxRequestFun(Long playMethodTypeId){
		Map<Object, Object> map = new HashMap<Object, Object>();
		List<PlayMethod> playMethodTypeList = this.getPlayMethodList(playMethodTypeId);
		for(int i=0;i<playMethodTypeList.size();i++){
			map.put(playMethodTypeList.get(i).getPlayMethodId(), playMethodTypeList.get(i).getName());
		}
		return map;
	}
		
	/**获取玩法类型集合*/
	private List<BizEnum.PLAY_METHOD_PRODUCT_TYPE> getPlayMethodType(){
        return Arrays.asList(BizEnum.PLAY_METHOD_PRODUCT_TYPE.values());
	}
	
	/**获取玩法类型下的玩法名称集合 */
	private List<PlayMethod> getPlayMethodList(Long playMethodTypeId){
		//return playMethodService.findPlayMethodByPlayMethodTypeId(playMethodTypeId);
		ResultHandleT<List<PlayMethod>> resultHandle = playMethodClientServiceRemote.findPlayMethodByPlayMethodTypeId(playMethodTypeId);
		if(resultHandle == null || resultHandle.isFail()){
			log.error(resultHandle.getMsg());
			throw new BusinessException(resultHandle.getMsg());
		}
		List<PlayMethod> playMethodList = resultHandle.getReturnContent();
		return playMethodList;
	}
	
	/**获取所属品类集合*/
	private List<BizEnum.BIZ_CATEGORY_TYPE> getBizCategoryType() {
		List<BizEnum.BIZ_CATEGORY_TYPE> categoryList  = new ArrayList<BizEnum.BIZ_CATEGORY_TYPE>();
		categoryList.add(BizEnum.BIZ_CATEGORY_TYPE.category_route);
		categoryList.add(BizEnum.BIZ_CATEGORY_TYPE.category_ticket);
		categoryList.add(BizEnum.BIZ_CATEGORY_TYPE.category_other_ticket);
		categoryList.add(BizEnum.BIZ_CATEGORY_TYPE.category_other);
		return categoryList;
	 }

	/**更新次玩法*/
	private void updatePlayMethodSeq(List<Map> objectList,List<ProdPlayMethodRe> allPlayMethodReList,ProdPlayMethodRe prodPlayMethodRe){
		for(Map<String, Object> map :objectList){
			String seqStr=map.get("seq").toString();
			String playMethodIdStr = map.get("playMethodId").toString();
			for(ProdPlayMethodRe allProdPlayMethodRe : allPlayMethodReList){
				if(null != prodPlayMethodRe.getPlayMethodId()){
					if(playMethodIdStr.equals(allProdPlayMethodRe.getPlayMethodId().toString()) && !seqStr.equals(allProdPlayMethodRe.getSeq().toString())
							 && !playMethodIdStr.equals(prodPlayMethodRe.getPlayMethodId().toString())){
	    				prodPlayMethodRe.setSeq(Long.valueOf(seqStr));
	    				prodPlayMethodRe.setPlayMethodId(Long.valueOf(playMethodIdStr));
	    				prodPlayMethodRe.setUpdateTime(new Date());
	    				//playMethodService.updatePlayMethodSeq(prodPlayMethodRe);
						playMethodClientServiceRemote.updatePlayMethodSeq(prodPlayMethodRe);
	    				try {
	    					// 操作执行消息推送
	    					this.pushAdapterService
	    							.push(prodPlayMethodRe.getProductId(),
	    									ComPush.OBJECT_TYPE.PRODUCT,
	    									ComPush.PUSH_CONTENT.PROD_PLAY_METHOD_RE,
	    									ComPush.OPERATE_TYPE.UP,
	    									ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
	    				} catch (Exception e) {
	    					log.error("perform push notification failure ！push type:"
	    							+ COM_LOG_LOG_TYPE.TAG_UPDATE.name());
	    					log.error(e.getMessage());
	    				}
					}
				}else{
					if(playMethodIdStr.equals(allProdPlayMethodRe.getPlayMethodId().toString()) && !seqStr.equals(allProdPlayMethodRe.getSeq().toString())){
	    				prodPlayMethodRe.setSeq(Long.valueOf(seqStr));
	    				prodPlayMethodRe.setPlayMethodId(Long.valueOf(playMethodIdStr));
	    				prodPlayMethodRe.setUpdateTime(new Date());
	    				//playMethodService.updatePlayMethodSeq(prodPlayMethodRe);
						playMethodClientServiceRemote.updatePlayMethodSeq(prodPlayMethodRe);
	    				try {
	    					// 操作执行消息推送
	    					this.pushAdapterService
	    							.push(prodPlayMethodRe.getProductId(),
	    									ComPush.OBJECT_TYPE.PRODUCT,
	    									ComPush.PUSH_CONTENT.PROD_PLAY_METHOD_RE,
	    									ComPush.OPERATE_TYPE.UP,
	    									ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
	    				} catch (Exception e) {
	    					log.error("perform push notification failure ！push type:"
	    							+ COM_LOG_LOG_TYPE.TAG_UPDATE.name());
	    					log.error(e.getMessage());
	    				}
				    }
			    }
		    }
        }
	}

}
