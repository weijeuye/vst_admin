package com.lvmama.vst.back.prod.preLockSeat;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.CollectionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.dubbo.common.utils.StringUtils;
import com.lvmama.comm.utils.MemcachedUtil;
import com.lvmama.vst.back.client.prod.service.ProdAdditionFlagClientService;
import com.lvmama.vst.back.prod.vo.ProdAdditionFlag;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.MemcachedEnum;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;

@Controller
@RequestMapping("/prod/preLockSeat")
public class PreLockSeatProdAction {
	
	private final Logger logger = LoggerFactory.getLogger(PreLockSeatProdAction.class);
	
	@Autowired
	private ProdAdditionFlagClientService prodAdditionFlagService;
	
	
	/**
	 * 查询支付前置产品设置
	 */
	@RequestMapping(value = "/findPreLockSeatProdList")
	public String findPreLockSeatProdList(Model model, Integer page,HttpServletRequest request,ProdAdditionFlag prodAdditionFlag,
			Long supplierId,String supplierName,String productIds,String redirectType,String categoryType) {
		model.addAttribute("prodAdditionFlag", prodAdditionFlag);
		model.addAttribute("productIds", productIds);
		model.addAttribute("supplierId", supplierId);
		model.addAttribute("supplierName", supplierName);
		model.addAttribute("redirectType", redirectType);
		if (page == null && StringUtil.isEmptyString(redirectType)) {
			model.addAttribute("redirectType", "1");
			return "/prod/preLockSeat/findPreLockSeatProdList";
		}
		
		Map<String, Object> params = new HashMap<String, Object>();
		if (StringUtils.isNotEmpty(productIds)) {
			List<Long> prodIds = new ArrayList<Long>();
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
				params.put("productIds", prodIds);
			}else {
				params.put("productIds", new Long[] { -1L });
			}
		}
		if (prodAdditionFlag != null) {
			if (StringUtils.isNotEmpty(prodAdditionFlag.getCancelFlag())) {
				params.put("cancelFlag", prodAdditionFlag.getCancelFlag());
			}
			if (StringUtils.isNotEmpty(prodAdditionFlag.getSaleFlag())) {
				params.put("saleFlag", prodAdditionFlag.getSaleFlag());
			}
		}
		params.put("supplierId", supplierId);
		
		int count = prodAdditionFlagService.selectPreLockSeasCountByParams(params);
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 50, pagenum);
		pageParam.buildUrl(request);
		params.put("_start", pageParam.getStartRows());
		params.put("_end", pageParam.getEndRows());
		params.put("categoryType", categoryType);
		List<ProdAdditionFlag> list = prodAdditionFlagService.selectPreLockSeasByParams(params);
		
		pageParam.setItems(list);
		model.addAttribute("pageParam", pageParam);
		return "/prod/preLockSeat/findPreLockSeatProdList";
	}
	
	
	/**
	 * 批量修改支付前置产品设置
	 * seatFlag: Y:设为前置  N:取消前置
	 */
	@RequestMapping(value = "/batchUpdatePreLockSeatProds")
	@ResponseBody
	public Object batchUpdatePreLockSeatProds(Model model,HttpServletRequest request,String seatFlag,String selectProductIds) {
		if (StringUtils.isEmpty(selectProductIds)) {
			logger.error("PreLockSeatProdAction#batchUpdatePreLockSeatProds error,selectProductIds is empty.");
			return new ResultMessage(ResultMessage.ERROR,"参数异常");
		}
		if (StringUtils.isEmpty(seatFlag)) {
			logger.error("PreLockSeatProdAction#batchUpdatePreLockSeatProds error,seatFlag is empty.");
			return new ResultMessage(ResultMessage.ERROR,"参数异常");
		}
		
		//获取修改产品列表
		List<Long> prodIds = new ArrayList<Long>();
		String[] strs = selectProductIds.split("\\D");
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
			for (Long productId : prodIds) {
				ProdAdditionFlag oldProdAdditionFlag = MiscUtils.autoUnboxing(prodAdditionFlagService.selectByProductId(productId));
				if (oldProdAdditionFlag == null) {
					ProdAdditionFlag newProdAdditionFlag = new ProdAdditionFlag();
					newProdAdditionFlag.setSeatFlag(seatFlag);
					newProdAdditionFlag.setProductId(productId);
					prodAdditionFlagService.insertProdAdditionFlag(newProdAdditionFlag);
				}else {
					if (seatFlag.equalsIgnoreCase(oldProdAdditionFlag.getSeatFlag())) {
						continue;
					}else {
						oldProdAdditionFlag.setSeatFlag(seatFlag);
						prodAdditionFlagService.updateProdAdditionFlagByPrimaryKey(oldProdAdditionFlag);
						MemcachedUtil.getInstance().remove(MemcachedEnum.selectLockUpPreById.getKey()+productId.toString());
					}
				}
				
			}
			
		}
		
		return new ResultMessage(ResultMessage.SUCCESS, "设置成功");
	}

}
