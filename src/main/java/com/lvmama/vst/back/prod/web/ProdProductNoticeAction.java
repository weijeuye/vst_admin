package com.lvmama.vst.back.prod.web;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.supp.service.SuppSupplierClientService;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.prod.po.ProdNoticeGoods;
import com.lvmama.vst.back.prod.po.ProdProductNotice;
import com.lvmama.vst.back.prod.service.ProdProductNoticeService;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.supp.po.SuppSupplier;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.DateUtil;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

@Controller
@RequestMapping("/prod/productNotice")
public class ProdProductNoticeAction extends BaseActionSupport{

	private static final Log LOG = LogFactory.getLog(ProdProductNoticeAction.class);
	
	@Autowired
	private ProdProductNoticeService productNoticeService ;
	
	@Autowired 
	private SuppSupplierClientService suppSupplierService;
	
	@Autowired 
    SuppGoodsClientService suppGoodsService;
	
	@Autowired						
	private ProdProductClientService productClientService;
	@Autowired
	private ComLogClientService comLogService;

	@RequestMapping(value = "/findProductNoticeList")
	public String findProductNoticeList(Model model, Long productId,String noticeType, Integer page,String from, HttpServletRequest req) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<findProductNoticeList>");
		}
		Map<String, Object> paramProductNotice = new HashMap<String, Object>();
		try {
			Date today = DateUtil.accurateToDay(new Date());
			paramProductNotice.put("nowDate",today);
			model.addAttribute("today", today);
		} catch (Exception e) {
		    LOG.error(e.getMessage());
		}
		paramProductNotice.put("productId", productId);
		paramProductNotice.put("cancelFlag","Y" );
		paramProductNotice.put("noticeType", noticeType);
        //查询公告使用标志
		if("PRODUCT_All".equals(noticeType)){
			paramProductNotice.put("sign", "Y");
		}else{
			paramProductNotice.put("_orderby", "CREATE_TIME DESC");
		}
		int count = productNoticeService.findProductNoticeCount(paramProductNotice);

		int pagenum = page == null ? 1 : page;
		int pageSize = from == null ? 10 :count;
		pageSize = pageSize > 0 ? pageSize:10;
		Page pageParam = Page.page(count, pageSize, pagenum);
		pageParam.buildUrl(req);
		paramProductNotice.put("_start", pageParam.getStartRows());
		paramProductNotice.put("_end", pageParam.getEndRows());
		List<ProdProductNotice> productNoticeList = null;
		if("PRODUCT_All".equals(noticeType)){
			 productNoticeList=productNoticeService.selectAllNoticeSorted(paramProductNotice);
		}else{
			 productNoticeList = productNoticeService.findProductNoticeList(paramProductNotice);
		}
		pageParam.setItems(productNoticeList);
		model.addAttribute("productId", productId);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("productNoticeList", productNoticeList);
		model.addAttribute("noticeType", noticeType);
		model.addAttribute("from", from);
		
		return "prod/productNotice/findProductNoticeList";
	}

	/**
	 * 跳转到修改页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/showUpdateProductNotice")
	public String showUpdateProductNotice(Model model, Long noticeId,String noticeType) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showUpdateProductNotice>");
		}
		ProdProductNotice productNotice = productNoticeService.findProductNoticeById(noticeId);
		model.addAttribute("productNotice",productNotice );
		model.addAttribute("noticeType", noticeType);
		//判断是否礼品
		if(ProdProductNotice.NOTICE_TYPE.PRODUCT_GIFT.name().equals(noticeType))
		{
			StringBuffer gids = null;
			List<ProdNoticeGoods> prodNoticeGoodsList = productNoticeService.findProdNoticeGoodsByNoticeId(noticeId);
			String supplierName = "";
			if(null!=prodNoticeGoodsList)
			{   int count = 0;
				gids = new StringBuffer("");
				for (ProdNoticeGoods prodNoticeGoods : prodNoticeGoodsList) {
					count++;
					if(count==1)
					{
						SuppGoods suppGoods	= MiscUtils.autoUnboxing( suppGoodsService.findSuppGoodsById(prodNoticeGoods.getSuppGoodsId(), null, null) );
					    if(null!=suppGoods)
					    {
					    	if(null!=suppGoods.getSuppSupplier())
					    	{
						    	supplierName = suppGoods.getSuppSupplier().getSupplierName();
						    	model.addAttribute("supplierName",supplierName);
						    	model.addAttribute("supplierId",suppGoods.getSuppSupplier().getSupplierId());
					    	}
					    	
					    }
					}
					gids.append(prodNoticeGoods.getSuppGoodsId()+",");
				}
			}
			String strGids = "";
			if(null!=gids && !"".equals(gids.toString()))
			{
				strGids = gids.substring(0, gids.lastIndexOf(","));
				model.addAttribute("gids",strGids);
			}
		}

		return "prod/productNotice/showUpdateProductNotice";
	}

	/**
	 * 跳转到添加页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/showAddProductNotice")
	public String showAddProductNotice(Model model , Long productId ,String noticeType) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showAddProductNotice>");
		}
		List<SuppSupplier> suppSupplierList = MiscUtils.autoUnboxing( suppSupplierService.findSuppSupplierListByProductId(productId) );
		model.addAttribute("productId", productId);
		model.addAttribute("noticeType", noticeType);
		model.addAttribute("suppSupplierList", suppSupplierList);
		
		return "prod/productNotice/showAddProductNotice";
	}

	/**
	 * 更新
	 */
	@RequestMapping(value = "/updateProductNotice")
	@ResponseBody
	public Object updateProductNotice(ProdProductNotice productNotice,Long[] gids) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<updateProductNotice>");
		}
		
		SimpleDateFormat sFormat = new SimpleDateFormat("yyyy-MM-dd");
		ProdProductNotice oldProductNotice = null;
		try {
			oldProductNotice = productNoticeService.findProductNoticeById(productNotice.getNoticeId());
		} catch (Exception e) {
			log.error(e.getMessage());
		}
		if( productNotice.getStartTime() == null){
			try {
				productNotice.setStartTime(sFormat.parse(sFormat.format( new Date())));
			} catch (ParseException e) {
				LOG.error(ExceptionFormatUtil.getTrace(e));
			}
		}
		
		productNoticeService.updateProductNotice(productNotice);
		try {
			String logContent = this.getProdProductNoticeChangeLog(oldProductNotice,productNotice);
			if(null!=logContent && !"".equals(logContent)) {
				//添加操作日志
				if("PRODUCT_RECOMMEND".equals(oldProductNotice.getNoticeType())){
					comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_NOTICE, 
							productNotice.getProductId(), productNotice.getNoticeId(),
							this.getLoginUser().getUserName(),
							"修改了一句话推荐：【"+productNotice.getNoticeId()+"】。修改内容："+logContent, 
							COM_LOG_LOG_TYPE.PROD_PRODUCT_NOTICE_RECOMMEND_CHANGE.name(), 
							"修改一句话推荐",null);
				}else{
					comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_NOTICE, 
							productNotice.getProductId(), productNotice.getNoticeId(),
							this.getLoginUser().getUserName(),
							"修改了产品公告：【"+productNotice.getNoticeId()+"】。修改内容："+logContent, 
							COM_LOG_LOG_TYPE.PROD_PRODUCT_NOTICE_CHANGE.name(), 
							"修改产品公告",null);
				}
			}
		} catch (Exception e) {
				log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_NOTICE_CHANGE.name());
				log.error(e.getMessage());
		}
		Map<String,Object> params = new HashMap<String, Object>();
		params.put("noticeId", productNotice.getNoticeId());
		params.put("gids", gids);
		productNoticeService.updateProdNoticeGoods(params);		
		
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

	/**
	 * 新增
	 * 
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/addProductNotice")
	@ResponseBody
	public Object addProductNotice(ProdProductNotice productNotice,Long[] gids) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<addProductNotice>");
		}
		
		if (productNotice!=null) {
			Date date = new Date();
			productNotice.setCreateTime(date);
			productNotice.setCancelFlag("Y");
			SimpleDateFormat sFormat = new SimpleDateFormat("yyyy-MM-dd");	
			try {
				Date today = sFormat.parse(sFormat.format(date));
				if (null == productNotice.getStartTime()) {
					productNotice.setStartTime(today);
				}
			} catch (ParseException e) {
				LOG.error(ExceptionFormatUtil.getTrace(e));
			}
			
		   }
			long noticeId = productNoticeService.addProductNotice(productNotice);
			productNotice.setNoticeId(noticeId);
			try {
				if("PRODUCT_RECOMMEND".equals(productNotice.getNoticeType())){
					comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_NOTICE, 
							productNotice.getProductId(), productNotice.getNoticeId(), 
							this.getLoginUser().getUserName(), 
							"添加了产品编号为：【"+productNotice.getProductId()+"】的一句话推荐：【"+productNotice.getNoticeId()+"】", 
							COM_LOG_LOG_TYPE.PROD_PRODUCT_NOTICE_RECOMMEND_ADD.name(), 
							"添加一句话推荐",null);
				}else{
					comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_NOTICE, 
							productNotice.getProductId(), productNotice.getNoticeId(), 
							this.getLoginUser().getUserName(), 
							"添加了产品编号为：【"+productNotice.getProductId()+"】的产品公告：【"+productNotice.getNoticeId()+"】", 
							COM_LOG_LOG_TYPE.PROD_PRODUCT_NOTICE_ADD.name(), 
							"添加产品公告",null);
				}
				
				
			} catch (Exception e) {
				log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_NOTICE_ADD.name());
				log.error(e.getMessage());
			}
			Map<String,Object> params = new HashMap<String, Object>();
			params.put("noticeId", productNotice.getNoticeId());
			params.put("gids", gids);
			productNoticeService.updateProdNoticeGoods(params);			
			

		return ResultMessage.ADD_SUCCESS_RESULT;
	}

	/**
	 * 删除
	 * 
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/editFlag")
	@ResponseBody
	public Object editFlag(Long noticeId) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<editFlag>");
		}
		ProdProductNotice productNotice = new ProdProductNotice();
		productNotice.setCancelFlag("N");
		productNotice.setNoticeId(noticeId);
		productNoticeService.updateProductNotice(productNotice);
		//删除公告
		try {
			ProdProductNotice findProductNotice = productNoticeService.findProductNoticeById(noticeId);
			if(null != findProductNotice){
				if("PRODUCT_RECOMMEND".equals(findProductNotice.getNoticeType())){
					comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_NOTICE, 
							findProductNotice.getProductId(), noticeId, 
							this.getLoginUser().getUserName(),
							"删除了产品编号为：【"+findProductNotice.getProductId()+"】的一句话推荐：【"+noticeId+"】", 
							COM_LOG_LOG_TYPE.PROD_PRODUCT_NOTICE_RECOMMEND_CHANGE.name(),
							"删除一句话推荐",null);
				}else{
					comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_PRODUCT_NOTICE, 
						findProductNotice.getProductId(), noticeId, 
						this.getLoginUser().getUserName(),
						"删除了产品编号为：【"+findProductNotice.getProductId()+"】的产品公告：【"+noticeId+"】", 
						COM_LOG_LOG_TYPE.PROD_PRODUCT_NOTICE_CHANGE.name(),
						"删除产品公告",null);
					}
				}
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_PRODUCT_NOTICE_CHANGE.name());
			log.error(e.getMessage());
		}
		return ResultMessage.SET_SUCCESS_RESULT;
	}
	
	/**
	 * 获取产品公告(创建订单用)
	 * @param productId 产品ID
	 * @param startDate 开始时间
	 * @param endDate   结束时间
	 * @return
	 */
	@RequestMapping("/getProductNoticeByCondition.do")
	@ResponseBody
	public Object getProductNoticeByCondition(Long productId,Date startTime,Date endTime){
		ResultMessage msg = ResultMessage.createResultMessage();
		Map<String, Object> attributes = new HashMap<String, Object>();
		Map<String, Object> paramProductNotice = new HashMap<String, Object>();
		 try {
//				paramProductNotice.put("startTime",startTime);
//				paramProductNotice.put("endTime",endTime);
			 	paramProductNotice.put("searchTimeBegin",startTime);
				paramProductNotice.put("searchTimeEnd",endTime);
				paramProductNotice.put("productId", productId);
				paramProductNotice.put("cancelFlag","Y" );
				paramProductNotice.put("_orderby", "CREATE_TIME asc");
				
				List<ProdProductNotice> productNoticeList = productNoticeService.findProductNoticeList(paramProductNotice);
				attributes.put("productNoticeList", productNoticeList);
			 	msg.setAttributes(attributes);
				msg.setCode("success");
		} catch (Exception e) {
			// TODO: handle exception
			msg.setCode("error");
		}
		 return msg;
	}
	
	private String getProdProductNoticeChangeLog(ProdProductNotice oldProductNotice,ProdProductNotice newProductNotice){
		 StringBuilder logStr = new StringBuilder("");
		 if(null != newProductNotice && null != oldProductNotice) {
				 logStr.append(ComLogUtil.getLogTxtDate("开始时间",newProductNotice.getStartTime(),oldProductNotice.getStartTime()));
				 logStr.append(ComLogUtil.getLogTxtDate("结束时间",newProductNotice.getEndTime(),oldProductNotice.getEndTime()));
				 if("PRODUCT_RECOMMEND".equals(oldProductNotice.getNoticeType())){
					 logStr.append(ComLogUtil.getLogTxt("一句话推荐内容",newProductNotice.getContent(),oldProductNotice.getContent())); 
				 }else{
					 logStr.append(ComLogUtil.getLogTxt("公告内容",newProductNotice.getContent(),oldProductNotice.getContent()));
				 }
				 if(null != newProductNotice.getCancelFlag()){
					 logStr.append(ComLogUtil.getLogTxt("是否有效","Y".equals(newProductNotice.getCancelFlag())?"是":"否","Y".equals(oldProductNotice.getCancelFlag())?"是":"否"));
				 }
		 }
		 return logStr.toString();
	 }
}
