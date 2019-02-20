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

import com.lvmama.vst.back.client.dist.service.DistributorGoodsClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.dist.po.DistDistributorGoods;
import com.lvmama.vst.back.dist.po.Distributor;
import com.lvmama.vst.back.dist.service.DistributorCachedService;
import com.lvmama.vst.back.dist.service.DistributorGoodsService;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdProductBranch;
import com.lvmama.vst.back.prod.service.ProdProductBranchService;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.pub.service.PushAdapterServiceRemote;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 分销商商品Action
 * 
 * @author mayonghua
 * @date 2013-11-5
 */

@Controller
@RequestMapping("/dist/distributorGoods")
public class DistributorGoodsAction {

	private static final Log LOG = LogFactory.getLog(DistributorGoodsAction.class);

	@Autowired
	private DistributorGoodsService distributorGoodsService;
	

	@Autowired
	private DistributorCachedService distributorService;
	
	@Autowired
	private ProdProductBranchService prodProductBranchService;
	
	
	@Autowired
	private ProdProductClientService prodProductService;
	
	
	@Autowired
	private SuppGoodsClientService suppGoodsService;
	
	@Autowired
	PushAdapterServiceRemote pushAdapterService;
	

	/**
	 * 获得分销商品列表
	 * 
	 * @param model
	 * @param page
	 *            分页参数
	 * @param prodProduct
	 *            查询条件
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/findDistributorGoodsList")
	public String findDistributorGoodsList(Model model, Integer page, DistDistributorGoods distDistributorGoods, Long distributorId, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<findDistributorGoodsList>");
		}
		Map<String, Object> parameters = new HashMap<String, Object>();
		
		ProdProduct product = null;
		ProdProductBranch productBranch = null;
		SuppGoods suppGoods = null;
		Distributor distributor = null;
		try{
		if (null != distributorId) {
			Distributor distributor1 = distributorService.findDistributorById(distributorId).getReturnContent();
			if ((distributor1 != null) && distributor1.getLvmamaFlag().equals("Y")) {
				parameters.put("distributorId", distributorId);
			}}
			
			else {
				if (distDistributorGoods.getProductId() != null) {
					parameters.put("productId", distDistributorGoods.getProductId());
				}

				if ((distDistributorGoods.getProduct()!= null) && (distDistributorGoods.getProduct().getProductName() != null) && (!"".equals(distDistributorGoods.getProduct().getProductName()))) {
					parameters.put("productName", distDistributorGoods.getProduct().getProductName());
				}
			}
		 	if(distDistributorGoods!=null&&distDistributorGoods.getDistributor()!=null){
			if ((distDistributorGoods.getDistributor().getDistributorName() != null) && (!"".equals(distDistributorGoods.getDistributor().getDistributorName()))) {
				parameters.put("distributorName", distDistributorGoods.getDistributor().getDistributorName());
			}
		 	}
		 	
			parameters.put("cancelFlag", "Y");
			int count = distributorGoodsService.findDistDistributorGoodsCount(parameters);

			int pagenum = page == null ? 1 : page;
			Page<DistDistributorGoods> pageParam = Page.page(count, 10, pagenum);
			pageParam.buildUrl(req);
			parameters.put("_start", pageParam.getStartRows());
			parameters.put("_end", pageParam.getEndRows());
			List<DistDistributorGoods> list = MiscUtils.autoUnboxing(distributorGoodsService.findDistDistributorGoodsList(parameters));;
			if(list!=null && list.size()>0){
				
				for (DistDistributorGoods distDistributorGoods2 : list) {
					distributor = distributorService.findDistributorById(distDistributorGoods2.getDistributorId()).getReturnContent();
					product = prodProductService.findProdProduct4FrontById(distDistributorGoods2.getProductId(), Boolean.FALSE, Boolean.FALSE);
					productBranch = prodProductBranchService.findProdProductBranchById(distDistributorGoods2.getProductBranchId(), Boolean.FALSE, Boolean.FALSE);

					distDistributorGoods2.setProduct(product);
					distDistributorGoods2.setProductBranch(productBranch);
				
					distDistributorGoods2.setDistributor(distributor);
					try{
						suppGoods = MiscUtils.autoUnboxing(suppGoodsService.findSuppGoodsById(distDistributorGoods2.getSuppGoodsId(), Boolean.FALSE, Boolean.FALSE));
						distDistributorGoods2.setSuppGoods(suppGoods);
					}catch(Exception e){
						LOG.error("distDistributorGoods ID:"+distDistributorGoods2.getDistGoodsId());
						LOG.error("Error on  findSuppGoodsById  SuppGoodsId"+distDistributorGoods2.getSuppGoodsId(), e);
						continue;
					}
				}
			}
				
			pageParam.setItems(list);
			model.addAttribute("pageParam", pageParam);
			model.addAttribute("distDistributorGoods", distDistributorGoods);
		}catch(Exception  e){
			LOG.error("Error on "+this.getClass().getName(), e);
	        model.addAttribute("errorMsg", "系统内部异常");
		}	
		return "/dist/distributorGoods/findDistributorGoodsList";
	}


	/**
	 * 跳转到修改页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/showUpdatebutorGoods")
	public String showUpdateDistributorGoods(Model model, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showUpdateDistributorGoods>");
		}
		
		return "/dist/distributorGoods/showUpdateDistributorGoods";
	}

	/**
	 * 跳转到添加
	 * 
	 * @return
	 */
	@RequestMapping(value = "/showAddDistributorGoods")
	public String showAddDistributorGoods(Model model, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showAddDistributorGoods>");
		}

		return "/dist/distributorGoods/showAddDistributorGoods";
	}

	/**
	 * 更新
	 */
	@RequestMapping(value = "/updateDistributorGoods")
	@ResponseBody
	public Object updateDistributorGoods() throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<updateDistributorGoods>");
		}
		return "";
	}

	/**
	 * 新增
	 * 
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/addDistributorGoods")
	@ResponseBody
	public Object addDistributorGoods() throws BusinessException {

		return null;
	}

	/**
	 * 删除
	 * 
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/editFlag")
	@ResponseBody
	public Object editFlag(Long distGoodsId) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<editFlag>");
		}
		DistDistributorGoods old = distributorGoodsService.findDistDistributorGoodsById(distGoodsId);
		DistDistributorGoods distDistributorGoods = new DistDistributorGoods();
		distDistributorGoods.setDistGoodsId(distGoodsId);
		distDistributorGoods.setCancelFlag("N");
		distributorGoodsService.editFlag(distDistributorGoods);
		pushAdapterService.push(old.getSuppGoodsId(), ComPush.OBJECT_TYPE.GOODS, ComPush.PUSH_CONTENT.DIST_DISTRIBUTOR_GOODS,ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
		return ResultMessage.SET_SUCCESS_RESULT;
	}

}
