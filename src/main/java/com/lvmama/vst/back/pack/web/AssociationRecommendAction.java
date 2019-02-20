package com.lvmama.vst.back.pack.web;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.pack.vo.ProdAssociateRecommendListVo;
import com.lvmama.vst.back.pack.vo.ProdAssociateRecommendSearchVo;
import com.lvmama.vst.back.prod.po.ProdAssociationRecommend;
import com.lvmama.vst.back.prod.service.AssociationRecommendService;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;

@Controller
@RequestMapping("/associationRecommend")
public class AssociationRecommendAction {

	private static Logger logger = Logger.getLogger(AssociationRecommendAction.class);
	
	@Autowired
	private AssociationRecommendService associationRecommendService;

	@RequestMapping("/findAssociationRecommendList")
	public String findAssociationRecommendList(Model model,
			@RequestParam("prodProductId") Long master_product_id, Long categoryId, String bu) {
		if (logger.isDebugEnabled()) {
			logger.debug(String.format("findAssociationRecommendList(master_product_id:%d)",
					master_product_id));
		}

		List<ProdAssociateRecommendListVo> list = this.associationRecommendService
				.findAssociationRecommendList(master_product_id, categoryId);
		model.addAttribute("prodAssociateRecommendList", list);
		model.addAttribute("master_product_id", master_product_id);
		model.addAttribute("categoryId", categoryId);
		model.addAttribute("bu", bu);
		return "/pack/line/associateRecommendListShow";
	}

	@RequestMapping("/addAssociationRecommend")
	@ResponseBody
	public ResultMessage addAssociationRecommend(Long master_product_id, Long slave_product_id) {
		if (logger.isDebugEnabled()) {
			logger.debug(String.format("addAssociationRecommend(master_product_id:%d, slave_product_id:%d)",
					master_product_id, slave_product_id));
		}
		try {
			ProdAssociationRecommend ar = new ProdAssociationRecommend();
			ar.setCreateTime(new Date());
			ar.setMasterProductId(master_product_id);
			ar.setSlaveProductId(slave_product_id);
			ar.setRecommendOrder(1L);
			associationRecommendService.insert(ar);
			return ResultMessage.ADD_SUCCESS_RESULT;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return ResultMessage.ADD_FAIL_RESULT;
		}
	}

	@RequestMapping("/removeAssociationRecommend")
	@ResponseBody
	public ResultMessage removeAssociationRecommend(Long recommend_id, Long master_product_id) {
		if (logger.isDebugEnabled()) {
			logger.debug(String.format("removeAssociationRecommend(), recommend_id:%d", recommend_id));
		}
		try {
			ProdAssociationRecommend ar = new ProdAssociationRecommend();
			ar.setRecommendId(recommend_id);
			ar.setMasterProductId(master_product_id);
			this.associationRecommendService.deleteProdAssociationRecommend(ar);
			return ResultMessage.DELETE_SUCCESS_RESULT;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return ResultMessage.DELETE_FAIL_RESULT;
		}
	}
	
	@RequestMapping("/updateAssociationRecommend")
	@ResponseBody
	public ResultMessage updateAssociationRecommend(Long recommend_id, Long recommend_order, Long master_product_id) {
		if (logger.isDebugEnabled()) {
			logger.debug(String.format("updateAssociationRecommend(recommend_id:%d, recommend_order:%d)",
					recommend_id, recommend_order));
		}
		try {
			ProdAssociationRecommend ar = new ProdAssociationRecommend();
			ar.setRecommendId(recommend_id);
			ar.setRecommendOrder(recommend_order);
			ar.setMasterProductId(master_product_id);
			this.associationRecommendService.updateProdAssociationRecommend(ar);
			return ResultMessage.UPDATE_SUCCESS_RESULT;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return ResultMessage.UPDATE_FAIL_RESULT;
		}
	}

	
	@RequestMapping("/initAddAssociationRecommend")
	public String initAddAssociationRecommend(Model model, Long master_product_id, String bu, Long categoryId) {
		if (logger.isDebugEnabled()) {
			logger.debug(String.format("initAddAssociationRecommend(master_product_id:%d, categoryId:%d)", master_product_id,
					categoryId));
		}
		model.addAttribute("master_product_id", master_product_id);
		model.addAttribute("categoryId", categoryId);
		model.addAttribute("bu", bu);
		return "/pack/line/associateRecommendSearch";
	}

	@RequestMapping("/selectCandidateProduct")
	public String selectCandidateProduct(Model model,
			@RequestParam("master_product_id") Long master_product_id, String bu, Long categoryId,
			@RequestParam("slave_product_id") Long slave_product_id, String productName, Integer page,
			HttpServletRequest req) {
		if (logger.isDebugEnabled()) {
			logger.debug(String.format("selectCandidateProduct(categoryId:%d, productId:%d, productName:%s)",
					categoryId, slave_product_id, productName));
		}
		if ("LOCAL_BU".equals(bu) || "OUTBOUND_BU".equals(bu) || "DESTINATION_BU".equals(bu)) {
			long counts = associationRecommendService.selectArCandidateCount(master_product_id, bu,
					categoryId == 14 ? null : categoryId, slave_product_id, productName);
			int pagenum = page == null ? 1 : page;
			Page<ProdAssociateRecommendSearchVo> pageParam = Page.page(counts, 10, pagenum);
			pageParam.buildJSONUrl(req);
			List<ProdAssociateRecommendSearchVo> list = associationRecommendService.selectCandidateProduct(
					master_product_id, bu, categoryId == 14 ? null : categoryId, slave_product_id,
					productName, pageParam);
			if(list == null) {
				list = new ArrayList<ProdAssociateRecommendSearchVo>();
			}
			pageParam.setItems(list);

			model.addAttribute("pageParam", pageParam);
		}
		return "/pack/line/associateRecommendCandidateList";
	}
}
