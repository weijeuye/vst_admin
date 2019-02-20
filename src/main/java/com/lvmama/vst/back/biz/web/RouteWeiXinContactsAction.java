package com.lvmama.vst.back.biz.web;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.po.WeiXinContact;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.client.biz.service.RouteWeiXinContactsClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.comm.utils.WineSplitConstants;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

import static com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE.WEIXIN_CONTACT_OPERATE;
import static com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE.WEIXIN_CONTACT_ADD_OR_UPDATE;
/**
 * 线路微信联系人管理
 * @author huangjiahuan
 *
 */

@Controller
@RequestMapping("/biz/weiXinContacts")
public class RouteWeiXinContactsAction extends BaseActionSupport {


	@Autowired
	private RouteWeiXinContactsClientService routeWeiXinContactsClientService;
	
	@Autowired
	private ComLogClientService 	comLogService;
	
	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;
	
	
	/*
	 * 微信联系人页
	 */
	@RequestMapping(value = "/findWeiXinContacts")
	public String findWeiXinContacts(Model model, Integer page, HttpServletRequest req , String weiXinBuType) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<showWeiXinContacts>");
		}
		//菜单页进入，默认展示国内的数据
		Map<String, Object> param = new HashMap<String, Object>();
		if(weiXinBuType==null||"".endsWith(weiXinBuType)){
			param.put("weiXinBuType", "INNER");
			model.addAttribute("weiXinBuType", "INNER");
		}else{
			param.put("weiXinBuType", weiXinBuType);
			model.addAttribute("weiXinBuType", weiXinBuType);
		}
		ResultHandleT<List<WeiXinContact>> resultHandleT= routeWeiXinContactsClientService.findWeiXinContactByParams(param);
		if(resultHandleT!=null&&resultHandleT.isSuccess()){
			List<WeiXinContact> weiXinContactList=resultHandleT.getReturnContent();
			if(weiXinContactList!=null && weiXinContactList.size()>0){
				for(WeiXinContact weiXinContact : weiXinContactList){
					if(weiXinContact.getCategoryId()!=null){
						weiXinContact.setBizCategory(bizCategoryQueryService.getCategoryById(weiXinContact.getCategoryId()));
					}
					if(weiXinContact.getSubCategoryId()!=null){
						weiXinContact.setSubCategory(bizCategoryQueryService.getCategoryById(weiXinContact.getSubCategoryId()));
					}
				}
			}
			model.addAttribute("weiXinContactList", weiXinContactList);
		}else{
			log.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		
		return "/biz/routeWeixinContacts/showRouteWeiXinContacts";
	}	
	//新增数据页面
	@RequestMapping(value = "/addWeiXinContacts")
	public String showAddWeiXinContacts(Model model,String weiXinBuType)throws BusinessException {
		model.addAttribute("weiXinBuType", weiXinBuType);
		// 查询品类
		List<BizCategory> bizCategoryList = bizCategoryQueryService.getAllValidCategorys();
		//留下 线路+签证 游轮品类
		Iterator<BizCategory> bizCategory = bizCategoryList.iterator();
		while (bizCategory.hasNext()) {
		    BizCategory biz = bizCategory.next();
		    if("INNER".equals(weiXinBuType)){
		    	if(biz.getCategoryId().intValue()!=15 && biz.getCategoryId().intValue()!=16 && biz.getCategoryId().intValue()!=17&& biz.getCategoryId().intValue()!=18){
		    		 bizCategory.remove();
		    	}
		    }else{ 
		    	if(biz.getCategoryId().intValue()!=15 && biz.getCategoryId().intValue()!=16 && biz.getCategoryId().intValue()!=17&& biz.getCategoryId().intValue()!=18
		    		&& biz.getCategoryId().intValue()!=8&& biz.getCategoryId().intValue()!=4){
		        bizCategory.remove();
		    	}
	    	}
        }
		model.addAttribute("bizCategoryList", bizCategoryList);
		// 查询自由行子品类
		List<BizCategory> subCategoryList = bizCategoryQueryService.getBizCategorysByParentCategoryId(WineSplitConstants.ROUTE_FREEDOM);
		model.addAttribute("subCategoryList", subCategoryList);

		return "/biz/routeWeixinContacts/addWeiXinContacts";
	}
	
	//新增数据页面
		@RequestMapping(value = "/editWeiXinContacts")
		public String showEditWeiXinContacts(Model model,Long id)throws BusinessException {
			
			if(id!=null){
				ResultHandleT<WeiXinContact> resultHandleT =routeWeiXinContactsClientService.findWeiXinContactById(id);
				if(resultHandleT!=null &&resultHandleT.isSuccess()){
					WeiXinContact weiXinContact =resultHandleT.getReturnContent();
					if(weiXinContact!=null){
						if(weiXinContact.getCategoryId()!=null){
							weiXinContact.setBizCategory(bizCategoryQueryService.getCategoryById(weiXinContact.getCategoryId()));
						}
						if(weiXinContact.getSubCategoryId()!=null){
							weiXinContact.setSubCategory(bizCategoryQueryService.getCategoryById(weiXinContact.getSubCategoryId()));
						}
						model.addAttribute("weiXinContact", weiXinContact);
					}
				}else{
					log.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
					throw new BusinessException(resultHandleT.getMsg());
				}
			}
			return "/biz/routeWeixinContacts/editWeiXinContacts";
		}
	
	/*
	 * tab切换
	 */
	@RequestMapping(value = "/changeWeiXinContacts")
	public String changeWeiXinContacts(Model model,Integer page,HttpServletRequest req ,String weiXinBuType) throws BusinessException {
		
		model.addAttribute("weiXinBuType", weiXinBuType);
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("weiXinBuType", weiXinBuType);
		ResultHandleT<List<WeiXinContact>> resultHandleT= routeWeiXinContactsClientService.findWeiXinContactByParams(param);
		if(resultHandleT!=null &&resultHandleT.isSuccess()){
			List<WeiXinContact> weiXinContactList=resultHandleT.getReturnContent();
			if(weiXinContactList!=null && weiXinContactList.size()>0){
				for(WeiXinContact weiXinContact : weiXinContactList){
					if(weiXinContact.getCategoryId()!=null){
						weiXinContact.setBizCategory(bizCategoryQueryService.getCategoryById(weiXinContact.getCategoryId()));
					}
					if(weiXinContact.getSubCategoryId()!=null){
						weiXinContact.setSubCategory(bizCategoryQueryService.getCategoryById(weiXinContact.getSubCategoryId()));
					}
				}
			}
			model.addAttribute("weiXinContactList", weiXinContactList);
		}else{
			log.error(resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		return "/biz/routeWeixinContacts/weiXinContacts";
	}
	

	@RequestMapping(value = "/addOrUpdateContact")
	@ResponseBody
	public Object addOrUpdateContact(Long contactId,Long subCategoryId,Long categoryId,String weiXinBuType ,String contactsAccount,Long photoId, String photoUrl) throws BusinessException {
			try {
				if(contactId!= null){
					//update
					ResultHandleT<WeiXinContact> resultHandleT =routeWeiXinContactsClientService.findWeiXinContactById(contactId);
					if(resultHandleT!=null && resultHandleT.isSuccess()){
						WeiXinContact weiXinContact=resultHandleT.getReturnContent();
						String logStr="联系人微信号【原值："+weiXinContact.getContactsAccount()+"  新值："+contactsAccount+"】， photoId【原值："+weiXinContact.getPhotoId()+"  新值："+photoId+"】， photoUrl【原值："+weiXinContact.getPhotoUrl()+" 新值："+photoUrl+"】";
						weiXinContact.setContactsAccount(contactsAccount);
						weiXinContact.setPhotoUrl(photoUrl);
						weiXinContact.setPhotoId(photoId);
						ResultHandleT<Integer> resultHandleT2 =routeWeiXinContactsClientService.updateWeiXinContact(weiXinContact);
						if(resultHandleT2!=null && resultHandleT2.isSuccess()){
							int count =resultHandleT2.getReturnContent() == null ? 0 : resultHandleT2.getReturnContent();
							if(count!=0){
								//记录日志
								this.logLineRouteOperate(weiXinContact.getContactId(),logStr,"修改微信客服助手记录");
								return ResultMessage.UPDATE_SUCCESS_RESULT;
							}else{
								return  new ResultMessage("error","保存失败");
							}
						}else{
							return  new ResultMessage("error",resultHandleT2 == null ? "ResultHandleT is empty..." : resultHandleT2.getMsg());
						}
					}else{
						return  new ResultMessage("error",resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
					}
					
				}else{
					//insert(先查询是否有相同条件的数据)
					Map<String, Object> param = new HashMap<String, Object>();
					param.put("weiXinBuType", weiXinBuType);
					param.put("categoryId", categoryId);
					if(categoryId==18L){
						param.put("subCategoryId", subCategoryId);
					}
					ResultHandleT<List<WeiXinContact>> resultHandleT =routeWeiXinContactsClientService.findWeiXinContactByParams(param);
					if(resultHandleT!=null && resultHandleT.isSuccess()){
						if(resultHandleT.getReturnContent()!=null &&resultHandleT.getReturnContent().size()>0){
							return  new ResultMessage("error","该品类已存在");
						}
					}
					WeiXinContact weiXinContact =new WeiXinContact();
					weiXinContact.setWeiXinBuType(weiXinBuType);
					weiXinContact.setCategoryId(categoryId);
					if(categoryId==18L){
						weiXinContact.setSubCategoryId(subCategoryId);
					}
					weiXinContact.setContactsAccount(contactsAccount);
					weiXinContact.setPhotoId(photoId);
					weiXinContact.setPhotoUrl(photoUrl);
					ResultHandleT<Integer> resultHandleT2 =routeWeiXinContactsClientService.addWeiXinContact(weiXinContact);
					if(resultHandleT2!=null && resultHandleT2.isSuccess()){
						int count =resultHandleT2.getReturnContent() == null ? 0 : resultHandleT2.getReturnContent();
						if(count!=0){
							//记录日志
							String logStr ="新增 品类【"+categoryId+"】，子品类【"+subCategoryId+"】，联系人微信号：【"+contactsAccount+"】图片id【"+photoId+"】，图片url【"+photoUrl+"】";
							this.logLineRouteOperate((long) count,logStr,"新增微信客服助手记录");
							return ResultMessage.ADD_SUCCESS_RESULT;
						}else{
							return  new ResultMessage("error","新增失败");
						}
					}else{
						return  new ResultMessage("error",resultHandleT2 == null ? "ResultHandleT is empty..." : resultHandleT2.getMsg());
					}
					
				}
			} catch (Exception e) {
				log.error("addOrUpdateContact errror "+e.getMessage());
			}
		return new ResultMessage(ResultMessage.ERROR, "系统出现错误");
	}

	/*
	 * 
	 */
	@RequestMapping(value = "/delete")
	@ResponseBody
	public Object deleteWeiXinContact(Long id) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<deleteWeiXinContact>, Id=" + id);
		}
		try {
			if(id != null){
				ResultHandleT<Integer> resultHandleT =routeWeiXinContactsClientService.deleteById(id);
				if(resultHandleT!=null && resultHandleT.isSuccess()){
					int count =resultHandleT.getReturnContent() == null ? 0 : resultHandleT.getReturnContent();
					if(count!=0){
						return ResultMessage.DELETE_SUCCESS_RESULT;
					}
				}else{
					return  new ResultMessage("error",resultHandleT == null ? "ResultHandleT is empty..." : resultHandleT.getMsg());
				}
			}
			else{
				return new ResultMessage(ResultMessage.ERROR, "数据不存在");
			}
		} catch (Exception e) {
			log.error("deleteWeiXinContact error: id="+id, e);
		}
		return new ResultMessage(ResultMessage.ERROR, "系统出现错误");
	}
	
	/**
	 * 记录操作日志
	 */
	private void logLineRouteOperate(Long contactId, String logText, String logName) {
		try{
			PermUser operateUser = this.getLoginUser();
			comLogService.insert(WEIXIN_CONTACT_OPERATE, contactId, contactId,
					operateUser==null? "" : operateUser.getUserName(), logText, WEIXIN_CONTACT_ADD_OR_UPDATE.name(), logName, null);
		}catch(Exception e) {
			log.error("Record Log failure ！Log Type:" + WEIXIN_CONTACT_ADD_OR_UPDATE.name());
			log.error(e.getMessage(), e);
		}
	}
	

}