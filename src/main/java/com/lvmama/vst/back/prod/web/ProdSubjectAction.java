package com.lvmama.vst.back.prod.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lvmama.vst.back.client.biz.service.SubjectClientService;
import com.lvmama.vst.back.client.prod.service.ProdSubjectClientService;
import com.lvmama.vst.comm.utils.web.HttpServletLocalThread;
import com.lvmama.vst.comm.vo.ResultHandleT;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizCategory;
import com.lvmama.vst.back.biz.po.BizDict;
import com.lvmama.vst.back.biz.po.BizEnum;
import com.lvmama.vst.back.biz.po.BizSubject;
import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.biz.service.DictService;
import com.lvmama.vst.back.prod.po.ProdSubject;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 产品与主题关联维护
 * @author LIULIANG
 * @Date 2014-07-19
 */
@Controller
@RequestMapping("/biz/prodSubject")
public class ProdSubjectAction extends BaseActionSupport {

	private static final long serialVersionUID = -6198856582225829130L;
	
	@Autowired
	private ProdSubjectClientService prodSubjectClientService;
	@Autowired
	private SubjectClientService subjectClientService;
	@Autowired
	private BizCategoryQueryService bizCategoryQueryService;
	
	@Autowired
	private DictService dictService;
	/**
	 * 查询产品与主题的关联信息
	 */
	@RequestMapping(value = "/findProdSubjectList")
	public String findProdSubjectList(Model model, ProdSubject prodSubject,HttpServletRequest req) throws BusinessException {
		if(null!=prodSubject){
			Map<String,Object> params = new HashMap<String, Object>();
		
			params.put("productId", prodSubject.getProductId());
			params.put("_orderby", "SEQ");
			params.put("_order", "ASC");
			String categoryId = req.getParameter("categoryId");
			List<ProdSubject> prodSubjects  = null;
			if(String.valueOf(BizEnum.BIZ_CATEGORY_TYPE.category_hotel.getCategoryId()).equals(categoryId)){
				ResultHandleT<List<ProdSubject>> resultHandleT = prodSubjectClientService.findProdSubjectOfHotelListByParams(params,true);
				if(resultHandleT == null || resultHandleT.isFail()){
					log.error(resultHandleT.getMsg());
					throw new BusinessException(resultHandleT.getMsg());
				}
				prodSubjects  = resultHandleT.getReturnContent();
			}else{
				prodSubjects = prodSubjectClientService.findProdSubjectListByParams(params,true);
			}
			model.addAttribute("prodSubjects", prodSubjects);
			model.addAttribute("prodSubject", prodSubject);
			model.addAttribute("categoryId",categoryId);
		}
		return "/biz/prodSubject/findProdSubjectList";
	}
	
	/**
	 * 新增主题与产品的关联信息
	 */
	@RequestMapping(value = "/saveProdSubject")
	@ResponseBody
	public Object saveProdSubject(ProdSubject prodSubject) throws BusinessException {
		if(null!=prodSubject){
			try {
				Long subjectId = prodSubject.getSubjectId();
				if(null==subjectId){
					return new ResultMessage("error","主题不存在");
				}
              	prodSubjectClientService.addProdSubject(prodSubject);
				HttpServletLocalThread.getModel().addAttribute("prodSubject", prodSubject);
			} catch (BusinessException e) {
				return new ResultMessage("error",e.getMessage());
			}
			return ResultMessage.ADD_SUCCESS_RESULT;
		}else{
			return new ResultMessage("error","参数错误");
		}
	}
	
	/**
	 * 新增主题与产品的关联信息
	 */
	@RequestMapping(value = "/saveProdSubjectForCustomizedProduct")
	@ResponseBody
	public Object saveProdSubjectForCustomizedProduct(ProdSubject prodSubject) throws BusinessException {
		if(null!=prodSubject){
			try {
				Long subjectId = prodSubject.getSubjectId();
				if(null==subjectId){
					return new ResultMessage("error","主题不存在");
				}
				prodSubject.setAddFlag("N");
				prodSubjectClientService.addProdSubjectForCustomizedProduct(prodSubject);
				HttpServletLocalThread.getModel().addAttribute("prodSubject", prodSubject);
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
			prodSubjectClientService.deleteProdSubjectById(reId);
			return ResultMessage.DELETE_SUCCESS_RESULT;
		}else{
			return new ResultMessage("error", "请选择需要删除的信息");
		}
	}
	/**
	 *批量删除酒店产品绑定的老的主题 
	 */
	@RequestMapping(value = "/bathDeleteProdSubject")
	@ResponseBody
	public Object  bathDeleteProdSubject(Long productId){
		if(log.isInfoEnabled()){
			log.info("ProdSubjectAction----bathDeleteProdSubject---start--productId:"+productId);
		}
		if(productId!=null){
			ProdSubject prodSubject  = new ProdSubject();
		
			prodSubject.setProductId(productId);
			try{
			prodSubjectClientService.bathDeleteSubject(prodSubject);
			return ResultMessage.DELETE_SUCCESS_RESULT;
			}catch (BusinessException e) {
				return new ResultMessage("error",e.getMessage());
			}
		}else{
			return new ResultMessage("error","参数错误");
		}
	}
	
	/**
	 * 设置主题排序
	 * @param firstReId 新设第一主题与产品关联ID
	 * @param oldReId 原有第一主题与产品关联ID
	 */
	@RequestMapping(value = "/updateProdSubjectSeq")
	@ResponseBody
	public Object updateProdSubjectSeq(Long firstReId,Long oldReId) throws BusinessException {
		if(null!=oldReId && null!=firstReId){
			// 查询新设第一主题与产品关联信息
			ResultHandleT<ProdSubject> resultHandleT = prodSubjectClientService.findProdSubjectById(firstReId);
			if(resultHandleT == null || resultHandleT.isFail()){
				log.error(resultHandleT.getMsg());
				throw new BusinessException(resultHandleT.getMsg());
			}
			ProdSubject prodSubject = resultHandleT.getReturnContent();
			if(null!=prodSubject){
				Long oldSeq = prodSubject.getSeq();// 原有排序号
				// 原有第一主题与产品关联信息
				ResultHandleT<ProdSubject> resultHandleTDto = prodSubjectClientService.findProdSubjectById(oldReId);
				if(resultHandleTDto == null || resultHandleTDto.isFail()){
					log.error(resultHandleTDto.getMsg());
					throw new BusinessException(resultHandleTDto.getMsg());
				}
				ProdSubject dto = resultHandleTDto.getReturnContent();
				if(null!=dto){
					dto.setSeq(oldSeq);
					// 新设原有第一主题与产品关联信息
					prodSubjectClientService.updateProdSubject(dto);
					prodSubject.setSeq(1L);
					prodSubjectClientService.updateProdSubject(prodSubject);
				}
			}
			return new ResultMessage("success", "设置成功");
		}else{
			return new ResultMessage("error", "设置错误");
		}
	}
	
	/**
	 * 查询主题信息{支持模糊查询}
	 * @param search 查询条件即主题名称
	 * @param res
	 */
	@RequestMapping(value = "/searchBizSubject")
	public String searchBizSubject(HttpServletRequest req,String search,Long categoryId, HttpServletResponse res,Model model,Integer page){
		if (log.isDebugEnabled()) {
			log.debug("start method<searchBizSubject>");
		}
		Map<String,Object> params = new HashMap<String, Object>();
		params.put("subjectName", search);
		params.put("cancelFlag", "Y");
		String subjectType = null;
		if(categoryId != null) {
			BizCategory cate = bizCategoryQueryService.getCategoryById(categoryId);
			if(cate != null){
    			if(cate.getParentId() ==null) {
    				subjectType = cate.getCategoryCode();
    			} else {
    				BizCategory cate1 = bizCategoryQueryService.getCategoryById(cate.getParentId());
    				if(cate1 != null && cate1.getParentId() ==null) {
    					subjectType = cate1.getCategoryCode();
    				}
    			}
			}
		}
		params.put("subjectType", subjectType );
		
		ResultHandleT<Integer> integerResultHandleT = subjectClientService.queryBizSubjectTotalCount(params);
		if(integerResultHandleT == null || integerResultHandleT.isFail()){
			log.error(integerResultHandleT.getMsg());
			throw new BusinessException(integerResultHandleT.getMsg());
		}
		int count = integerResultHandleT.getReturnContent() == null ? 0 : integerResultHandleT.getReturnContent();
		
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		params.put("_start", pageParam.getStartRowsMySql());
		params.put("_pageSize", pageParam.getPageSize());
		ResultHandleT<List<BizSubject>> listResultHandleT = subjectClientService.findBizSubjectListByParams(params);
		if(listResultHandleT == null || listResultHandleT.isFail()){
			log.error(listResultHandleT.getMsg());
			throw new BusinessException(listResultHandleT.getMsg());
		}
		List<BizSubject> list = listResultHandleT.getReturnContent();
		pageParam.setItems(list);
		
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("search",search);
		model.addAttribute("categoryId", categoryId);
		
		return "/biz/prodSubject/selectBizSubjectList";
	}
	@RequestMapping(value = "/searchSubjectOfHotel")
	public  String  getSubjectOfHotel(HttpServletRequest req,String search,Long dictDefId,String categoryId, HttpServletResponse res,Model model,Integer page){
		if(log.isInfoEnabled()){
			log.info("BizSubjectAction=====getSubjectOfHotel==start");
		}
		
		Map<String,Object> params = new HashMap<String, Object>();
		params.put("dictName", search);
		params.put("cancelFlag", "Y");
		params.put("dictDefId",dictDefId);
	    int count = dictService.findDictCount(params);
		
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		params.put("_start", pageParam.getStartRows());
		params.put("_end", pageParam.getEndRows());
		List<BizDict>  list =  dictService.findDictList(params);
		pageParam.setItems(list);

		model.addAttribute("pageParam", pageParam);
		model.addAttribute("search",search);
		model.addAttribute("categoryId", categoryId);
		
		return "/biz/prodSubject/selectBizSubjectListOfHotel";
	} 
	
}