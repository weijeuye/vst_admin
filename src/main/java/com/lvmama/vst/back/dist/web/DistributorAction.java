package com.lvmama.vst.back.dist.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.client.dist.service.DistributorClientService;
import com.lvmama.vst.back.dist.po.Distributor;
import com.lvmama.vst.back.dist.service.DistributorCachedService;
import com.lvmama.vst.comm.utils.ChineseToPinYin;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 分销商管理Action
 * 
 * @author qiujiehong
 * @date 2013-10-11
 */
@Controller
@RequestMapping("/dist/distributor")
public class DistributorAction {
	private static final Log LOG = LogFactory.getLog(DistributorAction.class);

	@Autowired
	private DistributorClientService distributorService;
	@Autowired
	private DistributorCachedService distributorCachedService;
	/**
	 * 获得分销商列表
	 * 
	 * @param model
	 * @param page
	 *            分页参数
	 * @param prodProduct
	 *            查询条件
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/findDistributorList")
	public String findDistributorList(Model model, Distributor distributor, Integer page, HttpServletRequest req) throws BusinessException {
		try{
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<findDistributorList>");
		}
		if(distributor == null || distributor.getDistributorName() == null) {
			return "/dist/distributor/findDistributorList";
		}
		Map<String, Object> paramDistributor = new HashMap<String, Object>();
		paramDistributor.put("distributorName", distributor.getDistributorName());
		paramDistributor.put("cancelFlag", distributor.getCancelFlag());

		int count = distributorService.findDistributorCount(paramDistributor).getReturnContent();

		int pagenum = page == null ? 1 : page;
		Page<Distributor> pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		paramDistributor.put("_start", pageParam.getStartRowsMySql());
		paramDistributor.put("_pageSize", pageParam.getPageSize());
		paramDistributor.put("_orderby", "DISTRIBUTOR_ID desc");
		paramDistributor.put("isShowPinTuan", "Y");
		List<Distributor> distributorList = distributorService.findDistributorList(paramDistributor).getReturnContent();
		pageParam.setItems(distributorList);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("distributorList", distributorList);
		}catch(Exception  e){
			LOG.error("Error on DistributorAction.findDistributorList", e);
	        model.addAttribute("errorMsg", "系统内部异常");
		}
		return "/dist/distributor/findDistributorList";
	}

	/**
	 * 跳转到修改页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/showUpdateDistributor")
	public String showUpdateDistributor(Model model, Long distributorId) throws BusinessException {
		
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showUpdateDistributor>");
		}
		try{	
			Distributor distributor = distributorCachedService.findDistributorById(distributorId).getReturnContent();
			model.addAttribute("distributor", distributor);
		}catch(Exception  e){
			LOG.error("Error on DistributorAction.showUpdateDistributor", e);
	        model.addAttribute("errorMsg", "系统内部异常");
		}
		return "/dist/distributor/showUpdateDistributor";
	}

	/**
	 * 跳转到添加页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/showAddDistributor")
	public String showAddDistributor(Model model) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showAddDistributor>");
		}

		return "/dist/distributor/showAddDistributor";
	}

	/**
	 * 更新分销商
	 */
	@RequestMapping(value = "/updateDistributor")
	@ResponseBody
	public Object updateDistributor(Distributor distributor) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<updateDistributor>");
		}
		distributorService.updateDistributor(distributor);
		distributorCachedService.deleteDistributorCachedById(distributor.getDistributorId());
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

	/**
	 * 新增分销商
	 * 
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/addDistributor")
	@ResponseBody
	public Object addDistributor(Distributor distributor) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<addDistributor>");
		}
		try{
			if (distributor!=null&&distributor.getDistributorName()!= null) {
				
				String pinyin =  ChineseToPinYin.getPingYin(distributor.getDistributorName());
				String key = distributorService.MD5(pinyin).getReturnContent();
				distributor.setDistributorKey(key);
				distributorService.addDistributor(distributor);
				//因为不知道新增的ID，所以清空所有本地缓存
				distributorCachedService.clearDistributorCached();
			}
		}catch(Exception  e){
			LOG.error("Error on DistributorAction.showUpdateDistributor", e);
			return ResultMessage.ADD_FAIL_RESULT;
		}
		return ResultMessage.ADD_SUCCESS_RESULT;
	}

	/**
	 * 设置禁用/开启
	 * 
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/editFlag")
	@ResponseBody
	public Object editFlag(Long distributorId, String cancelFlag) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<editFlag>");
		}
		distributorCachedService.deleteDistributorCachedById(distributorId);
		distributorService.editFlag(distributorId, cancelFlag);
		return ResultMessage.SET_SUCCESS_RESULT;
	}
	
	
	/**
	 * 获得所有分销商
	 * @param model
	 * @param req
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/selectDistributor")
	public String selectDistributor(Model model,HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<selectDistributor>");
		}
		 
		Map<String, Object> paramDistributor = new HashMap<String, Object>();
		

		try{
			List<Distributor> distributorList = distributorService.findDistributorList(paramDistributor).getReturnContent();
			model.addAttribute("distributorList", distributorList);
		}catch(Exception  e){
			LOG.error("Error on DistributorAction.selectDistributor", e);
	        model.addAttribute("errorMsg", "系统内部异常");
		}
		return "/dist/dialog/selectDistributor";
	}
}
