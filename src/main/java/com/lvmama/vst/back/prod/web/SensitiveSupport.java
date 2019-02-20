package com.lvmama.vst.back.prod.web;

import java.util.HashMap;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.lvmama.vst.back.biz.service.BizCategoryQueryService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductBranchAdapterClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductBranchClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.hotel.adapter.client.ProdProductClientServiceHotelAdapter;
import com.lvmama.vst.back.hotel.adapter.client.SuppGoodsClientServiceHotelAdapter;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductBranch;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.vo.ResultMessage;

/**
 * 判断是否含有敏感词
 * @author luolihua
 *
 */
@Service
public class SensitiveSupport {

	private static final Log LOG = LogFactory.getLog(SensitiveSupport.class);

	
	@Autowired
	private ProdProductClientServiceHotelAdapter prodProductHotelAdapterService;
	
	
	@Autowired
	private SuppGoodsClientServiceHotelAdapter suppGoodsHotelAdapterService;
	
	
	@Autowired
	private ProdProductBranchAdapterClientService prodProductBranchAdapterService;
	
	/**
	 * 产品ID
	 * @param productId
	 * @return
	 */
	public ResultMessage findSensitiveFlag(Long productId) {
		if(LOG.isDebugEnabled()) {
			LOG.debug("start method<findSensitiveFlag>, productId = " + productId);
		}
		ResultMessage rm = null;
		//首先判断产品是否有敏感词
		if(productId != null){
			ProdProduct pp = MiscUtils.autoUnboxing( prodProductHotelAdapterService.findProdProductById(productId) );
			if(pp.getSenisitiveFlag() != null && "Y".equalsIgnoreCase(pp.getSenisitiveFlag())){
				rm = new ResultMessage("error", "产品:["+productId+"]包含敏感词。");
				return rm;
			}
			//判断规格是否有敏感词
			HashMap<String,Object> params = new HashMap<String,Object>();
			params.put("productId", productId);
			List<ProdProductBranch> ppbList = null; 
			try{
				ppbList = prodProductBranchAdapterService.findProdProductBranchList(params);
			}catch(Exception e) {
				LOG.error(e.getMessage(), e);
			}
			if(ppbList != null && ppbList.size() > 0){
				for(ProdProductBranch ppb : ppbList){
					if(ppb.getSenisitiveFlag() != null && "Y".equalsIgnoreCase(ppb.getSenisitiveFlag())){
						rm = new ResultMessage("error", "规格:["+ppb.getProductBranchId()+"]包含敏感词。");
						return rm;
					}
				}
			}
			//判断商品是否有敏感词
			 List<SuppGoods> goodsList = suppGoodsHotelAdapterService.findSuppGoodsByProductId(productId);
			 if(goodsList != null && goodsList.size() > 0){
				 for(SuppGoods sg : goodsList){
					 if(sg.getSenisitiveFlag() != null && "Y".equalsIgnoreCase(sg.getSenisitiveFlag())){
						 rm = new ResultMessage("error", "商品:["+sg.getSuppGoodsId()+"]包含敏感词。");
						return rm;
					 }
				 }
			 }
		}
		return new ResultMessage("success","");
	}

}
