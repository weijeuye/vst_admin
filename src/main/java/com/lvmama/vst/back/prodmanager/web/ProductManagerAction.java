package com.lvmama.vst.back.prodmanager.web;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.dubbo.common.utils.CollectionUtils;
import com.lvmama.comm.pet.vo.Page;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prodmanager.service.GoodsManagerService;
import com.lvmama.vst.back.prodmanager.service.ProductManagerService;
import com.lvmama.vst.back.supp.po.SuppGoodsShipBase;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 产品管理Action
 * 
 * @author 
 * @date 2013-10-11
 */
@Controller
@RequestMapping("/prod/prodmanager")
public class ProductManagerAction extends BaseActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = -6351446724576585206L;

	private static final Log LOG = LogFactory.getLog(ProductManagerAction.class);

	@Autowired
	private ProductManagerService productManagerService;
	
	@Autowired
	private GoodsManagerService goodsManagerService;
	
	@Autowired
	private ProdProductClientService prodProductService;
	
	@Autowired
	private SuppGoodsClientService suppGoodsService;
	
	
	
	/**
	 * 跳转到产品经理页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/viewProduct")
	public String viewProduct() {
		return "/prod/prodmanager/viewProduct";
	}
	
	/**
	 * 根据产品Id修改产品经理
	 * 
	 * @return
	 */
	@RequestMapping(value = "/updateProductBatchById")
	public String updateProductBatchById(Model model,String oldProductIdStr,Long newProductManagerId) throws BusinessException{
		if (oldProductIdStr != null && newProductManagerId != null) {
			try {
				List<Long> oldProductIds = new ArrayList<Long>();
				String[] oldProductIdArr = oldProductIdStr.split(",");
				for (int i = 0; i < oldProductIdArr.length; i++) {
					if (!(oldProductIdArr[i] == null || oldProductIdArr[i].equals(""))) {
						if (!oldProductIdArr[i].trim().equals("")) {
							Long oldProductId = Long.parseLong(oldProductIdArr[i].trim());
							oldProductIds.add(oldProductId);
						}
					}
				}
				if (oldProductIds.size()>0) {
					//SQL 语句in 子句中的LIST个数最长为1000
					int count = 1000;
					int idsLength = oldProductIds.size();
				    int size = idsLength % count;
				    if (size == 0) {
				        size = idsLength / count;
				    } else {
				        size = (idsLength / count) + 1;
				    }
				    int goodsTotalNum = 0;
				    int goodsShipTotalNum = 0;
				    int productTotalNum = 0;
				    for (int i = 0; i < size; i++) {
				    	int fromIndex = i * count;
				    	int toIndex = Math.min(fromIndex + count, idsLength);
				    	List<Long> subProductIds = oldProductIds.subList(fromIndex, toIndex);
				    	Map<String, Object> updateNumMap = goodsManagerService.updateProdManagerByProductId(subProductIds,newProductManagerId);
						Integer goodsNum = (Integer) updateNumMap.get("goodsNum");
						if (goodsNum != null && goodsNum != 0) {
							goodsTotalNum += goodsNum.intValue();
							log.info("时间：【"+new Date()+"】操作人:【"+this.getLoginUser().getUserName()+"】通过产品ID：【"+oldProductIds +
									"】修改supp_goods表，新产品经理ID：【"+newProductManagerId+"】修改条数：【"+goodsNum+"】");
						}
						Integer goodsShipNum = (Integer) updateNumMap.get("goodsShipNum");
						if (goodsShipNum != null && goodsShipNum != 0) {
							goodsShipTotalNum += goodsShipNum.intValue();
							log.info("时间：【"+new Date()+"】操作人:【"+this.getLoginUser().getUserName()+"】通过产品ID：【"+oldProductIds +
									"】修改supp_goods_ship_base表，新产品经理ID：【"+newProductManagerId+"】修改条数：【"+goodsShipNum+"】");
						}
						Integer productNum = (Integer) updateNumMap.get("productNum");
						if (productNum != null && productNum != 0) {
							productTotalNum += productNum.intValue();
							log.info("时间：【"+new Date()+"】操作人:【"+this.getLoginUser().getUserName()+"】通过产品ID：【"+oldProductIds +
									"】修改prod_product表，新产品经理ID：【"+newProductManagerId+"】修改条数：【"+productNum+"】");
						}
				    }
					model.addAttribute("goodsNum", goodsTotalNum);
					model.addAttribute("goodsShipNum", goodsShipTotalNum);
					model.addAttribute("productNum", productTotalNum);
				}
			} catch (Exception e) {
				LOG.error(ExceptionFormatUtil.getTrace(e));
			}
		}
		return "/prod/prodmanager/updateProductBatchById";
	}
	
	/**
	 * 根据姓名修改产品经理
	 * 
	 * @return
	 */
	@RequestMapping(value = "/updateProductBatchByName")
	public String updateProductBatchByName(Model model,Long oldProductManagerId,Long newProductManagerId) throws BusinessException{
		if (oldProductManagerId != null && newProductManagerId != null) {
			try {
				Set<Long> productIdSet = getTotalProductId(oldProductManagerId);
				if (productIdSet.size()>0) {
					List<Long> productIds = new ArrayList<Long>(productIdSet);
					//SQL 语句in 子句中的LIST个数最长为1000
					int count = 1000;
					int idsLength = productIds.size();
				    int size = idsLength % count;
				    if (size == 0) {
				        size = idsLength / count;
				    } else {
				        size = (idsLength / count) + 1;
				    }
				    int goodsTotalNum = 0;
				    int goodsShipTotalNum = 0;
				    int productTotalNum = 0;
				    for (int i = 0; i < size; i++) {
				    	int fromIndex = i * count;
				    	int toIndex = Math.min(fromIndex + count, idsLength);
				    	List<Long> subProductIds = productIds.subList(fromIndex, toIndex);
				    	Map<String, Object> updateNumMap = goodsManagerService.updateProdManagerByProductId(subProductIds,newProductManagerId);
						Integer goodsNum = (Integer) updateNumMap.get("goodsNum");
						if (goodsNum != null && goodsNum != 0) {
							goodsTotalNum += goodsNum.intValue();
							log.info("时间：【"+new Date()+"】操作人:【"+this.getLoginUser().getUserName()+"】修改supp_goods表的旧产品经理ID：【"+oldProductManagerId +
									"】为新产品经理ID：【"+newProductManagerId+"】修改条数：【"+goodsNum+"】");
						}
						Integer goodsShipNum = (Integer) updateNumMap.get("goodsShipNum");
						if (goodsShipNum != null && goodsShipNum != 0) {
							goodsShipTotalNum += goodsShipNum.intValue();
							log.info("时间：【"+new Date()+"】操作人:【"+this.getLoginUser().getUserName()+"】修改supp_goods_ship_base的旧产品经理ID：【"+oldProductManagerId +
									"】为新产品经理ID：【"+newProductManagerId+"】修改条数：【"+goodsShipNum+"】");
						}
						Integer productNum = (Integer) updateNumMap.get("productNum");
						if (productNum != null && productNum != 0) {
							productTotalNum += productNum.intValue();
							log.info("时间：【"+new Date()+"】操作人:【"+this.getLoginUser().getUserName()+"】修改prod_product表的旧产品经理ID：【"+oldProductManagerId +
									"】为新产品经理ID：【"+newProductManagerId+"】修改条数：【"+productNum+"】");
						}
				    	
				    }
					model.addAttribute("goodsNum", goodsTotalNum);
					model.addAttribute("goodsShipNum", goodsShipTotalNum);
					model.addAttribute("productNum", productTotalNum);
				}
			} catch (Exception e) {
				LOG.error(ExceptionFormatUtil.getTrace(e));
			}
		}
		return "/prod/prodmanager/updateProductBatchByName";
	}
	
	private Set<Long> getTotalProductId(Long oldProductManagerId) throws BusinessException{
		Set<Long> productIdSet = new HashSet<Long>();
		try {
			Map<String, Object> paramsProduct = new HashMap<String, Object>();
			paramsProduct.put("managerId", oldProductManagerId);
			ResultHandleT<Integer> countWrapper = prodProductService.findProdProductCount(paramsProduct);
			int productCount = countWrapper != null && countWrapper.isSuccess() ? countWrapper.getReturnContent() : 0;
			
			int pageSize = 1000;
			int productPageCount = productCount % pageSize;
			if (productPageCount == 0) {
				productPageCount = productCount / pageSize;
			} else {
				productPageCount = productCount / pageSize + 1;
			}
			int productPageNum = 0;
			for (int p = 0; p < productPageCount; p++) {
				productPageNum = p + 1;
				Page productPageParam = Page.page(productCount, pageSize, productPageNum);
				paramsProduct.put("_start", productPageParam.getStartRows());
				paramsProduct.put("_end", productPageParam.getEndRows());
                ResultHandleT<List<ProdProduct>> resultProduct = prodProductService.findProdProductList(paramsProduct);
                List<ProdProduct> productList = resultProduct != null && resultProduct.isSuccess() ? resultProduct.getReturnContent() : null;
                
                if (CollectionUtils.isNotEmpty(productList)) {
                	for (ProdProduct product : productList) {
                		if (product.getProductId() !=null && !product.getProductId().equals("")) {
                			productIdSet.add(product.getProductId());
                		}
                	}
                }
			}
			
			Map<String, Object> paramsSuppGoods = new HashMap<String, Object>();
			paramsSuppGoods.put("managerId", oldProductManagerId);
			ResultHandleT<Integer> resultCount = suppGoodsService.findSuppGoodsCount(paramsProduct);
			int suppGoodsCount = resultCount != null && resultCount.isSuccess() ? resultCount.getReturnContent() : null;
			int suppGoodsPageCount = suppGoodsCount % pageSize;
			if (suppGoodsPageCount == 0) {
				suppGoodsPageCount = suppGoodsCount / pageSize;
			} else {
				suppGoodsPageCount = suppGoodsCount / pageSize + 1;
			}
			int suppGoodsPageNum = 0;
			for (int s = 0; s < suppGoodsPageCount; s++) {
				suppGoodsPageNum = s + 1;
				Page suppGoodsPageParam = Page.page(suppGoodsCount, pageSize, suppGoodsPageNum);
				paramsSuppGoods.put("_start", suppGoodsPageParam.getStartRows());
				paramsSuppGoods.put("_end", suppGoodsPageParam.getEndRows());
				ResultHandleT<List<SuppGoods>> result = suppGoodsService.findSuppGoodsList(paramsSuppGoods);
                List<SuppGoods> suppGoodsList = result!= null && result.isSuccess() ?result.getReturnContent() : null;
                if (CollectionUtils.isNotEmpty(suppGoodsList)) {
                	for (SuppGoods suppGoods : suppGoodsList) {
                		if (suppGoods.getProductId() != null && !suppGoods.getProductId().equals("")) {
                			productIdSet.add(suppGoods.getProductId());
                		}
                	}
                }
			}
			
			Map<String, Object> paramsGoodsShip = new HashMap<String, Object>();
			paramsGoodsShip.put("managerId", oldProductManagerId);
			int goodsShipCount = goodsManagerService.getTotalSuppGoodsShipCount(paramsGoodsShip);
			int goodsShipPageCount = goodsShipCount % pageSize;
			if (goodsShipPageCount == 0) {
				goodsShipPageCount = goodsShipCount / pageSize;
			} else {
				goodsShipPageCount = goodsShipCount / pageSize + 1;
			}
			int goodsShipPageNum = 0;
			for (int gs = 0; gs < goodsShipPageCount; gs++) {
				goodsShipPageNum = gs + 1;
				Page goodsShipPageParam = Page.page(goodsShipCount, pageSize, goodsShipPageNum);
				paramsGoodsShip.put("_start", goodsShipPageParam.getStartRows());
				paramsGoodsShip.put("_end", goodsShipPageParam.getEndRows());
                List<SuppGoodsShipBase> goodsShipList = goodsManagerService.selectGoodsShipByParams(paramsGoodsShip);
                if (CollectionUtils.isNotEmpty(goodsShipList)) {
                	for (SuppGoodsShipBase suppGoodsShipBase : goodsShipList) {
                		if (suppGoodsShipBase.getProductId() != null && !suppGoodsShipBase.getProductId().equals("")) {
                			productIdSet.add(suppGoodsShipBase.getProductId());
                		}
                	}
                }
			}
			
		} catch (Exception e) {
			LOG.error(ExceptionFormatUtil.getTrace(e));
		}
		return productIdSet;
	}
	
}