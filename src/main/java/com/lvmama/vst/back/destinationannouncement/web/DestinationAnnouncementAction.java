package com.lvmama.vst.back.destinationannouncement.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
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

import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.vst.back.biz.po.BizEnum.BIZ_CATEGORY_TYPE;
import com.lvmama.vst.back.client.destinationannouncement.service.Destinationannouncement2ClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.supp.service.SuppSupplierClientService;
import com.lvmama.vst.back.destinationannouncement.util.ContentExistsUtil;
import com.lvmama.vst.back.prod.adapter.ProdProductHotelAdapterClientService;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.pub.po.ComLog;
import com.lvmama.vst.back.router.adapter.ProdProductHotelAdapterService;
import com.lvmama.vst.back.supp.po.SuppSupplier;
import com.lvmama.vst.comm.enumeration.CommEnumSet;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.destinationannouncement.po.DestinationAnnouncement;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;

/**
 * Created by yangzhenzhong on 2016/10/10.
 */
@Controller
@RequestMapping("/prod/destinationAnnouncement")
public class DestinationAnnouncementAction  extends BaseActionSupport{

    private static final long serialVersionUID = -4995602225033805846L;

    private static final Log LOG = LogFactory.getLog(DestinationAnnouncementAction.class);
    private static final List<Long> bizCategoryIdArray = Arrays.asList(
			BIZ_CATEGORY_TYPE.category_hotel.getCategoryId(),
			BIZ_CATEGORY_TYPE.category_route_hotelcomb.getCategoryId(),
			BIZ_CATEGORY_TYPE.category_route_freedom.getCategoryId());

//    @Autowired
//    private DestinationAnnouncementService destinationAnnouncementService;
    
    @Autowired
    private Destinationannouncement2ClientService destinationannouncement2ClientServiceRemote;

    @Autowired
    private ProdProductClientService prodProductService;
    

    @Autowired
    private ComLogClientService comLogService;
    
    
	@Autowired
	private PermUserServiceAdapter permUserServiceAdapter;
	
	
	@Autowired
	private SuppSupplierClientService suppSupplierService;
	
    
    @Autowired
    private ProdProductHotelAdapterService prodProductHotelAdapterService;
    
    

    @RequestMapping(value = "/queryList")
    public String getAnnouncementList(Model model, Integer page,String announcementId, String announcementName, String productId, String isValid,HttpServletRequest req)
            throws BusinessException {

        Map<String, Object> params = new HashMap<String, Object>();
        if(announcementId!=null && !announcementId.isEmpty()) {
            params.put("id", announcementId);
        }
        if(announcementName!=null && !announcementName.isEmpty()){
            params.put("announcementName", announcementName);
        }
        if(productId!=null && !productId.isEmpty()){
            params.put("productId", productId);
        }
        if(isValid!=null && !isValid.isEmpty()){
            params.put("isValid", isValid);
        }

        //int count = destinationAnnouncementService.getTotalCount(params);

		ResultHandleT<Integer> resultHandleTCount = destinationannouncement2ClientServiceRemote.getTotalCount(params);
		if(resultHandleTCount == null || resultHandleTCount.isFail()){
			log.error(resultHandleTCount.getMsg());
			throw new BusinessException(resultHandleTCount.getMsg());
		}
		
		int count = resultHandleTCount.getReturnContent();
        
        int pagenum = page == null ? 1 : page;
        Page pageParam = Page.page(count, 15, pagenum);
        pageParam.buildUrl(req);
        params.put("_start", pageParam.getStartRowsMySql());
        params.put("_pageSize", pageParam.getPageSize());
        params.put("_orderby", "ID");
        params.put("_order", "DESC");

        //List<DestinationAnnouncement> resultList = destinationAnnouncementService.getList(params);
        
		ResultHandleT<List<DestinationAnnouncement>> resultHandle = destinationannouncement2ClientServiceRemote.getList(params);
		if(resultHandle == null || resultHandle.isFail()){
			log.error(resultHandle.getMsg());
			throw new BusinessException(resultHandle.getMsg());
		}
		
		List<DestinationAnnouncement> resultList = resultHandle.getReturnContent();

        pageParam.setItems(resultList);

        model.addAttribute("pageParam", pageParam);

        model.addAttribute("announcementId", announcementId);
        model.addAttribute("announcementName", announcementName);
        model.addAttribute("productId", productId);
        model.addAttribute("isValid", isValid);


        return "/prod/destinationAnnouncement/findAnnouncementList";
    }

    @RequestMapping(value = "/toAdd")
    public String toAddAnnouncement(Model model,HttpServletRequest req)
            throws BusinessException {


        model.addAttribute("channelList", DestinationAnnouncement.CHANNEL_TYPE.values());
        return "/prod/destinationAnnouncement/saveOrUpdateAnnouncement";
    }
    
    @RequestMapping(value = "/toEdit")
    public String toEditAnnouncement(Model model,Long id,HttpServletRequest req)
            throws BusinessException {

        //DestinationAnnouncement destinationAnnouncement = destinationAnnouncementService.getByPrimaryKey(id);
        
		ResultHandleT<DestinationAnnouncement> resultHandleT = destinationannouncement2ClientServiceRemote.getByPrimaryKey(id);
		if(resultHandleT == null || resultHandleT.isFail()){
			log.error(resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		DestinationAnnouncement destinationAnnouncement = resultHandleT.getReturnContent();
        

        model.addAttribute("announcement", destinationAnnouncement);
        model.addAttribute("channelList", DestinationAnnouncement.CHANNEL_TYPE.values());
        return "/prod/destinationAnnouncement/saveOrUpdateAnnouncement";
    }

    @RequestMapping(value = "/toBind")
    public String toBindAnnouncement(Model model,Long id,HttpServletRequest req)
            throws BusinessException {
        model.addAttribute("announcementId", id);
        model.addAttribute("filialeNameList", CommEnumSet.FILIALE_NAME.values()); // 子公司列表
        return "/prod/destinationAnnouncement/bindAnnouncement";
    }

    @RequestMapping(value = "/queryProductList")
    public String queryProductList(Model model,Integer page,String productId,String cancelFlag,String saleFlag,String productName,String categoryCode,String managerId,String subCompany,String supplierId,Long announcementId,HttpServletRequest req) throws BusinessException {
    	model.addAttribute("filialeNameList", CommEnumSet.FILIALE_NAME.values()); // 子公司列表
        Map<String, Object> paramProdProduct = new HashMap<String, Object>();
        if(productId!=null && !productId.equals("")){
            paramProdProduct.put("productId", productId); //产品ID
            model.addAttribute("productId", productId);
        }
        if(cancelFlag!=null && !cancelFlag.equals("")){
            paramProdProduct.put("cancelFlag", cancelFlag); //产品状态
            model.addAttribute("cancelFlag", cancelFlag);
        }
        if(saleFlag!=null && !saleFlag.equals("")){
            paramProdProduct.put("saleFlag", saleFlag); //是否可售
            model.addAttribute("saleFlag", saleFlag);
        }
        if(subCompany!=null && !subCompany.equals("")){
            paramProdProduct.put("subCompany", subCompany); //子公司
            model.addAttribute("subCompany", subCompany);
        }
        if(managerId!=null && !managerId.equals("")){
            paramProdProduct.put("productManagerId", managerId); //产品经理
            PermUser user = permUserServiceAdapter.getPermUserByUserId(Long.parseLong(managerId));
            if(user!=null){
            	model.addAttribute("productManagerId", managerId);
            	model.addAttribute("productManagerName", user.getRealName());
            }
            
        }
        if(supplierId!=null && !supplierId.equals("")){
            paramProdProduct.put("supplierId", supplierId); //供应商名称
            ResultHandleT<SuppSupplier> suppSupplierRT = suppSupplierService.findSuppSupplierById(Long.parseLong(supplierId));
            if(suppSupplierRT!=null){
            	SuppSupplier suppSupplier = suppSupplierRT.getReturnContent();
            	if(suppSupplier!=null){
                	model.addAttribute("supplierId", supplierId);
                	model.addAttribute("supplierName", suppSupplier.getSupplierName());
                }
            }
            
        }
        if(productName!=null && !productName.equals("")){
            paramProdProduct.put("productName", productName); //产品名称
            model.addAttribute("productName", productName);
        }
        //产品品类
		if(categoryCode != null && (BIZ_CATEGORY_TYPE.category_hotel.name().equalsIgnoreCase(categoryCode)
						|| BIZ_CATEGORY_TYPE.category_route_hotelcomb.name().equalsIgnoreCase(categoryCode)
						|| BIZ_CATEGORY_TYPE.category_route_freedom.name().equalsIgnoreCase(categoryCode))) {
        	if(BIZ_CATEGORY_TYPE.category_hotel.name().equalsIgnoreCase(categoryCode)){
        		paramProdProduct.put("bizCategoryId", BIZ_CATEGORY_TYPE.category_hotel.getCategoryId());
        	}else if(BIZ_CATEGORY_TYPE.category_route_hotelcomb.name().equalsIgnoreCase(categoryCode)){
        		paramProdProduct.put("bizCategoryId", BIZ_CATEGORY_TYPE.category_route_hotelcomb.getCategoryId());
        	}else if(BIZ_CATEGORY_TYPE.category_route_freedom.name().equalsIgnoreCase(categoryCode)){
        		paramProdProduct.put("bizCategoryId", BIZ_CATEGORY_TYPE.category_route_freedom.getCategoryId());
        	}
            model.addAttribute("categoryCode", categoryCode);
        }else{
        	 paramProdProduct.put("bizCategoryIdArray", bizCategoryIdArray);
        	 model.addAttribute("categoryCode", "");
        }
		
		int count = prodProductHotelAdapterService.findAndMergeProdProductCount(paramProdProduct);
        int pagenum = page == null ? 1 : page;
        Page pageParam = Page.page(count, 10, pagenum);
        pageParam.buildUrl(req);

        paramProdProduct.put("_start", pageParam.getStartRows());
        paramProdProduct.put("_end", pageParam.getEndRows());
        paramProdProduct.put("_orderby", "PRODUCT_ID");
        paramProdProduct.put("_order", "DESC");
        paramProdProduct.put("isneedmanager", "false");
        
        List<ProdProduct> list = prodProductHotelAdapterService.findAndMergeProdProductListSales(paramProdProduct);
        pageParam.setItems(list);
        model.addAttribute("pageParam", pageParam);
        model.addAttribute("announcementId", announcementId);

        return "prod/destinationAnnouncement/bindAnnouncement";
    }

    @RequestMapping(value = "/queryBindingProductList")
    public String queryBindingProductList(Model model,Integer page,Long announcementId,HttpServletRequest req) throws BusinessException {

        //DestinationAnnouncement destinationAnnouncement = destinationAnnouncementService.getByPrimaryKey(announcementId);
        
		ResultHandleT<DestinationAnnouncement> resultHandleT = destinationannouncement2ClientServiceRemote.getByPrimaryKey(announcementId);
		if(resultHandleT == null || resultHandleT.isFail()){
			log.error(resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}

		DestinationAnnouncement destinationAnnouncement = resultHandleT.getReturnContent();
        
        String productIds = destinationAnnouncement.getProductIds();
        List<Long> productIdList = new ArrayList<Long>();
        if(productIds!=null && !productIds.equals("")) {
            for(String productId:productIds.split(",")) {
            	if(StringUtil.isNotEmptyString(productId)){
            		 productIdList.add(new Long(productId));
            	}
            }
        }
        if(productIdList.size()==0) {
            List<ProdProduct> list = new ArrayList<ProdProduct>();
            int pagenum = page == null ? 1 : page;
            Page pageParam = Page.page(0, 10, pagenum);
            pageParam.setItems(list);
            model.addAttribute("pageParam", pageParam);

        }else {
            Map<String, Object> paramProdProduct = new HashMap<String, Object>();
            if(productIdList.size()>0){
                paramProdProduct.put("productIdLst", productIdList); //产品ID数组
            }
            paramProdProduct.put("bizCategoryIdArray", bizCategoryIdArray);//产品品类

            int count = prodProductHotelAdapterService.findAndMergeProdProductCount(paramProdProduct);
            int pagenum = page == null ? 1 : page;
            Page pageParam = Page.page(count, 10, pagenum);
            pageParam.buildUrl(req);

            paramProdProduct.put("_start", pageParam.getStartRows());
            paramProdProduct.put("_end", pageParam.getEndRows());
            paramProdProduct.put("_orderby", "PRODUCT_ID");
            paramProdProduct.put("_order", "DESC");
            paramProdProduct.put("isneedmanager", "false");

            List<ProdProduct> list = prodProductHotelAdapterService.findAndMergeProdProductListSales(paramProdProduct);
            pageParam.setItems(list);
            model.addAttribute("pageParam", pageParam);
        }
        model.addAttribute("announcementId", announcementId);
        return "prod/destinationAnnouncement/bindingProductList";
    }

    @RequestMapping(value = "/bindProduct")
    @ResponseBody
    public Object bindProduct(Model model,String productIds,Long announcementId,HttpServletRequest req)
            throws BusinessException {

        //DestinationAnnouncement dbDestinationAnnouncement = destinationAnnouncementService.getByPrimaryKey(announcementId);
        
		ResultHandleT<DestinationAnnouncement> resultHandleT = destinationannouncement2ClientServiceRemote.getByPrimaryKey(announcementId);
		if(resultHandleT == null || resultHandleT.isFail()){
			log.error(resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}

		DestinationAnnouncement dbDestinationAnnouncement = resultHandleT.getReturnContent();
        
        DestinationAnnouncement destinationAnnouncement = new DestinationAnnouncement();
        StringBuffer result = new StringBuffer();

        destinationAnnouncement.setId(dbDestinationAnnouncement.getId());
        int count=0;
        String newBindIds = "";
        if(dbDestinationAnnouncement.getProductIds()==null || dbDestinationAnnouncement.getProductIds().equals("")) {
            result.append(productIds);
            newBindIds=productIds;
        }else {
            String existProductIds = dbDestinationAnnouncement.getProductIds();
            result.append(existProductIds);
            for (String id : productIds.split(",")) {
                if (!ContentExistsUtil.isIdMatch(id, existProductIds)) {
                    result.append(",").append(id);
                    newBindIds = newBindIds +"," + id;
                } else {
                    count++;
                }
            }
        }
        if(count!=productIds.split(",").length){
            destinationAnnouncement.setProductIds(result.toString());
            //destinationAnnouncementService.update(destinationAnnouncement);
            destinationannouncement2ClientServiceRemote.update(destinationAnnouncement);
        }
        //添加操作日志
        comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.PROD_DESC_ANNOUNCEMENT,
                destinationAnnouncement.getId(), destinationAnnouncement.getId(),
                this.getLoginUser().getUserName(),
                "绑定了产品：【产品ID列表："+newBindIds+"】",
                ComLog.COM_LOG_LOG_TYPE.PROD_PRODUCT_PROMOTION_CHANGE.name(),
                "绑定产品",null);

        return ResultMessage.UPDATE_SUCCESS_RESULT;
    }

    @RequestMapping(value = "/deleteBindProduct")
    @ResponseBody
    public Object deleteBindProduct(Model model,String productIds,Long announcementId,HttpServletRequest req)
            throws BusinessException {

        //DestinationAnnouncement dbDestinationAnnouncement = destinationAnnouncementService.getByPrimaryKey(announcementId);
        
		ResultHandleT<DestinationAnnouncement> resultHandleT = destinationannouncement2ClientServiceRemote.getByPrimaryKey(announcementId);
		if(resultHandleT == null || resultHandleT.isFail()){
			log.error(resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		DestinationAnnouncement dbDestinationAnnouncement = resultHandleT.getReturnContent();
        
        DestinationAnnouncement destinationAnnouncement = new DestinationAnnouncement();

        destinationAnnouncement.setId(dbDestinationAnnouncement.getId());

        String result = dbDestinationAnnouncement.getProductIds();
        //删除了的产品IDS
        StringBuffer sb = new StringBuffer();
        if(result.equals(productIds)) {
            result = "";
            sb.append(productIds+",");
        }else {
            for (String deleteProductId : productIds.split(",")) {
                if(result.equals(deleteProductId)) {
                    result = "";
                    sb.append(deleteProductId+",");
                    break;
                }else {
                    if (ContentExistsUtil.isIdMatch(deleteProductId, result)) {
                    	sb.append(deleteProductId+",");
                    	result = ContentExistsUtil.removeId(deleteProductId, result);
                    }
                }
            }
        }
        destinationAnnouncement.setProductIds(result);
        //destinationAnnouncementService.update(destinationAnnouncement);
        destinationannouncement2ClientServiceRemote.update(destinationAnnouncement);

        //添加操作日志
        comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.PROD_DESC_ANNOUNCEMENT,
                destinationAnnouncement.getId(), destinationAnnouncement.getId(),
                this.getLoginUser().getUserName(),
                "解绑了产品：【产品ID列表："+sb.toString()+"】",
                ComLog.COM_LOG_LOG_TYPE.PROD_PRODUCT_PROMOTION_CHANGE.name(),
                "解绑产品",null);

        return ResultMessage.UPDATE_SUCCESS_RESULT;
    }

    @RequestMapping(value = "/setValid")
    @ResponseBody
    public Object updateAnnouncement(Model model, Long announcementId,String isValid,HttpServletRequest req)
            throws BusinessException {

        DestinationAnnouncement destinationAnnouncement = new DestinationAnnouncement();
        destinationAnnouncement.setId(announcementId);

        //DestinationAnnouncement dbDestinationAnnouncement = destinationAnnouncementService.getByPrimaryKey(announcementId);
        
		ResultHandleT<DestinationAnnouncement> resultHandleT = destinationannouncement2ClientServiceRemote.getByPrimaryKey(announcementId);
		if(resultHandleT == null || resultHandleT.isFail()){
			log.error(resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		DestinationAnnouncement dbDestinationAnnouncement = resultHandleT.getReturnContent();

        destinationAnnouncement.setIsValid(dbDestinationAnnouncement.getIsValid().equals("Y")?"N":"Y");

        //destinationAnnouncementService.update(destinationAnnouncement);
        destinationannouncement2ClientServiceRemote.update(destinationAnnouncement);

        String logContent = getLogContent(dbDestinationAnnouncement, destinationAnnouncement);

        //添加操作日志
        comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.PROD_DESC_ANNOUNCEMENT,
                destinationAnnouncement.getId(), destinationAnnouncement.getId(),
                this.getLoginUser().getUserName(),
                "修改了目的地产品公告：【"+logContent+"】",
                ComLog.COM_LOG_LOG_TYPE.PROD_PRODUCT_PROMOTION_CHANGE.name(),
                "修改了目的地产品公告",null);


        return ResultMessage.UPDATE_SUCCESS_RESULT;

    }
    @RequestMapping(value = "/toBatchBind")
    public String toBatchBind(Model model,Long announcementId,HttpServletRequest req)
            throws BusinessException {
        model.addAttribute("announcementId", announcementId);
        return "/prod/destinationAnnouncement/batchBind";
    }

    @RequestMapping(value = "/batchBind")
    @ResponseBody
    public Object batchBind(Model model, String productIds,Long announcementId,HttpServletRequest req)
            throws BusinessException {
    	ResultMessage msg = new ResultMessage(ResultMessage.SUCCESS, "操作成功");
    	
        //DestinationAnnouncement dbDestinationAnnouncement = destinationAnnouncementService.getByPrimaryKey(announcementId);
        
		ResultHandleT<DestinationAnnouncement> resultHandleT = destinationannouncement2ClientServiceRemote.getByPrimaryKey(announcementId);
		if(resultHandleT == null || resultHandleT.isFail()){
			log.error(resultHandleT.getMsg());
			throw new BusinessException(resultHandleT.getMsg());
		}
		DestinationAnnouncement dbDestinationAnnouncement = resultHandleT.getReturnContent();
        
        DestinationAnnouncement destinationAnnouncement = new DestinationAnnouncement();
        
        //传入的ID
        StringBuffer result = new StringBuffer();
        destinationAnnouncement.setId(dbDestinationAnnouncement.getId());
        productIds=ContentExistsUtil.formatStr(productIds);
        //返回消息
        String msgContent="";
        //已经存在ID
        String existProductIds = dbDestinationAnnouncement.getProductIds()==null?"":dbDestinationAnnouncement.getProductIds();
        //传入中已经存在的ID
        String sameProductIds = "";
        int sameCount=0;
        if(dbDestinationAnnouncement.getProductIds()==null || dbDestinationAnnouncement.getProductIds().equals("")) {
            result.append(productIds);
        }else {
            for (String id : productIds.split(",")) {
            	if(StringUtil.isNotEmptyString(id)){
            		if (ContentExistsUtil.isIdMatch(id, existProductIds)) {
                    	sameProductIds=sameProductIds+id+",";
                    	sameCount++;
                    }else{
                    	 result.append(",").append(id);
                    }
            	}
            }
            sameProductIds=ContentExistsUtil.formatStr(sameProductIds);
        }
        
        String batchProductIds = result.toString();
        batchProductIds=ContentExistsUtil.formatStr(batchProductIds);
        //过滤后能绑定的ID
        String batchBindProductIds = "";
        if(batchProductIds.length()>0){
        	//限制1000个产品id
        	String allIds = "";
        	if(existProductIds.equals("")){
        		allIds=batchProductIds;
        	}else{
        		allIds=existProductIds+","+batchProductIds;
        	}
        	if((allIds).split(",").length>1000){
        		msg.setCode(ResultMessage.ERROR);
        		msg.setMessage("产品id超过1000个");
        		return msg;
        	}
        	List<Long> productIdList = new ArrayList<Long>();
        	for(String id : batchProductIds.split(",")){
        		if(StringUtil.isNotEmptyString(id)){
        			productIdList.add(Long.parseLong(id));
        		}
        	}
        	//过滤
        	batchBindProductIds = fliterProductIds(productIdList);
        	batchBindProductIds = ContentExistsUtil.formatStr(batchBindProductIds);
        	if("".equals(batchBindProductIds)){
        		msg.setCode(ResultMessage.ERROR);
        		msg.setMessage("能绑定的产品ID为空，原因：输入的产品ID不符合要求");
        		return msg;
        	}
            if(!"".equals(existProductIds)){
        		destinationAnnouncement.setProductIds(existProductIds+","+batchBindProductIds);	
        	}else{
        		destinationAnnouncement.setProductIds(batchBindProductIds);
        	}
            //destinationAnnouncementService.update(destinationAnnouncement);
            destinationannouncement2ClientServiceRemote.update(destinationAnnouncement);
        }else if(sameCount>0){
    		msg.setCode(ResultMessage.ERROR);
    		msg.setMessage("能绑定的产品ID为空，原因：输入的产品ID已经绑定");
    		return msg;
        }else{
        	msg.setCode(ResultMessage.ERROR);
    		msg.setMessage("能绑定的产品ID为空，原因：输入的产品ID不符合要求");
    		return msg;
        }
        
        //无效的ID
        String noValidIds= productIds;
    	for(String inId : batchBindProductIds.split(",")){
    		if(ContentExistsUtil.isIdMatch(inId, noValidIds)){
    			noValidIds = ContentExistsUtil.removeId(inId, noValidIds);
    		}
    	}
    	if(sameCount>0){
    		for(String sameId : sameProductIds.split(",")){
        		if(ContentExistsUtil.isIdMatch(sameId, noValidIds)){
        			noValidIds = ContentExistsUtil.removeId(sameId, noValidIds);
        		}
        	}
    	}
    	
        int productIdsCount=productIds.split(",").length;
        int batchBindCount=batchBindProductIds.split(",").length;
        int noValidIdsCount=noValidIds.split(",").length;
        if(batchBindCount==productIdsCount){
        	msgContent="您已成功绑定"+batchBindCount+"个产品。";
        }else{
        	msgContent="您已成功绑定"+batchBindCount+"个产品，"+"绑定失败"+(productIdsCount-batchBindCount)+"个，";
        	msgContent=msgContent+"【已绑定*"+sameCount+"】："+sameProductIds+"，【无结果ID*"+noValidIdsCount+"】："+noValidIds;
        	if(productIdsCount!=(batchBindCount+sameCount+noValidIdsCount)){
        		msgContent=msgContent+"，【重复ID*"+(productIdsCount-(batchBindCount+sameCount+noValidIdsCount))+"】。";
        	}
        }
        if(!"".equals(msgContent)){
        	msg.setMessage(msgContent);
        }
        //添加操作日志
        comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.PROD_DESC_ANNOUNCEMENT,
                destinationAnnouncement.getId(), destinationAnnouncement.getId(),
                this.getLoginUser().getUserName(),
                "绑定了产品：【产品ID列表："+batchBindProductIds+"】",
                ComLog.COM_LOG_LOG_TYPE.PROD_PRODUCT_PROMOTION_CHANGE.name(),
                "绑定产品",null);

        return msg;

    }

    @RequestMapping(value = "/saveOrUpdate")
    @ResponseBody
    public Object updateAnnouncement(Model model, DestinationAnnouncement destinationAnnouncement,HttpServletRequest req)
            throws BusinessException {
    	
    	//设置渠道值
    	if(destinationAnnouncement.getChannelCode()!=null && destinationAnnouncement.getChannelCode().size()>0){
            StringBuffer sb = new StringBuffer();
            int index=0;
            for (String channelCode : destinationAnnouncement.getChannelCode()) {
                if (index > 0) {
                    sb.append(",");
                }
                sb.append(channelCode);
                index++;
            }
            destinationAnnouncement.setChannelList(sb.toString());
        }
    	//更新
        if(destinationAnnouncement.getId()!=null){

            //DestinationAnnouncement dbDestinationAnnouncement = destinationAnnouncementService.getByPrimaryKey(destinationAnnouncement.getId());

    		ResultHandleT<DestinationAnnouncement> resultHandleT = destinationannouncement2ClientServiceRemote.getByPrimaryKey(destinationAnnouncement.getId());
    		if(resultHandleT == null || resultHandleT.isFail()){
    			log.error(resultHandleT.getMsg());
    			throw new BusinessException(resultHandleT.getMsg());
    		}
    		DestinationAnnouncement dbDestinationAnnouncement = resultHandleT.getReturnContent();
    		
            String logContent = getLogContent(dbDestinationAnnouncement, destinationAnnouncement);
            
            copyProperties(destinationAnnouncement, dbDestinationAnnouncement);

            //destinationAnnouncementService.update(dbDestinationAnnouncement);
            destinationannouncement2ClientServiceRemote.update(dbDestinationAnnouncement);
            
            //添加操作日志
            comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.PROD_DESC_ANNOUNCEMENT,
                    destinationAnnouncement.getId(), destinationAnnouncement.getId(),
                    this.getLoginUser().getUserName(),
                    "修改了目的地产品公告：【"+logContent+"】",
                    ComLog.COM_LOG_LOG_TYPE.PROD_PRODUCT_PROMOTION_CHANGE.name(),
                    "修改了目的地产品公告",null);

        }else {
        	//新增
            //Long id=destinationAnnouncementService.add(destinationAnnouncement);

            ResultHandleT<Long> resultHandleT = destinationannouncement2ClientServiceRemote.add(destinationAnnouncement);
    		if(resultHandleT == null || resultHandleT.isFail()){
    			log.error(resultHandleT.getMsg());
    			throw new BusinessException(resultHandleT.getMsg());
    		}
    		Long id = resultHandleT.getReturnContent();
    		destinationAnnouncement.setId(id);
            //添加操作日志
            comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.PROD_DESC_ANNOUNCEMENT,
                    destinationAnnouncement.getId(), destinationAnnouncement.getId(),
                    this.getLoginUser().getUserName(),
                    "添加了目的地产品公告：【"+destinationAnnouncement.getId()+"，"+destinationAnnouncement.getAnnouncementName()+"】",
                    ComLog.COM_LOG_LOG_TYPE.PROD_PRODUCT_PROMOTION_CHANGE.name(),
                    "添加了目的地产品公告",null);
        }

        return new ResultMessage("success",destinationAnnouncement.getId().toString());

    }

    private void copyProperties(DestinationAnnouncement from, DestinationAnnouncement to) {

        to.setAnnouncementName(from.getAnnouncementName());
        to.setContent(from.getContent());
        to.setStartDate(from.getStartDate());
        to.setEndDate(from.getEndDate());
        to.setChannelCode(from.getChannelCode());
        to.setChannelList(from.getChannelList());
        to.setRank(from.getRank());
        to.setIsValid(from.getIsValid());
    }

    private String getLogContent(DestinationAnnouncement oldDestinationAnnouncement, DestinationAnnouncement newDestinationAnnouncement) {
        StringBuffer buffer = new StringBuffer();
        try {
        	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            

            if (newDestinationAnnouncement.getId() != null) {
                buffer.append("公告ID:["+newDestinationAnnouncement.getId()+"];");
            }
            if (newDestinationAnnouncement.getAnnouncementName() != null && !newDestinationAnnouncement.getAnnouncementName().equals("")
                    && !oldDestinationAnnouncement.getAnnouncementName().equals(newDestinationAnnouncement.getAnnouncementName())) {
                buffer.append("公告名称:[原来值:"+oldDestinationAnnouncement.getAnnouncementName()+",新值:"+newDestinationAnnouncement.getAnnouncementName()+"];");
            }
            if (newDestinationAnnouncement.getContent() != null && !newDestinationAnnouncement.equals("")
                    && !oldDestinationAnnouncement.getContent().equals(newDestinationAnnouncement.getContent())) {
                buffer.append("公告内容:[原来值:"+oldDestinationAnnouncement.getContent()+",新值:"+newDestinationAnnouncement.getContent()+"];");
            }
            if (newDestinationAnnouncement.getStartDate() != null && !oldDestinationAnnouncement.getStartDate().equals(newDestinationAnnouncement.getStartDate())) {

                buffer.append("公告开始展示时间:[原来值:"+format.format(oldDestinationAnnouncement.getStartDate())+",新值:"+format.format(newDestinationAnnouncement.getStartDate())+"];");
            }
            if (newDestinationAnnouncement.getEndDate() != null && !oldDestinationAnnouncement.getEndDate().equals(newDestinationAnnouncement.getEndDate())) {

                buffer.append("公告结束展示时间:[原来值:"+format.format(oldDestinationAnnouncement.getEndDate())+",新值:"+format.format(newDestinationAnnouncement.getEndDate()) + "];");
            }
            if (newDestinationAnnouncement.getIsValid()!= null && !newDestinationAnnouncement.getIsValid().equals("")
                    && !oldDestinationAnnouncement.getIsValid().equals(newDestinationAnnouncement.getIsValid())) {
                buffer.append("是否有效:[原来值:"+(oldDestinationAnnouncement.getIsValid().equals("Y")?"有效":"无效")+",新值:"+(newDestinationAnnouncement.getIsValid().equals("Y")?"有效":"无效")+"];");
            }

            if(newDestinationAnnouncement.getChannelList() !=null && !newDestinationAnnouncement.getChannelList().equals("") && newDestinationAnnouncement.getChannelCode()!=null
                    && newDestinationAnnouncement.getChannelCode().size()>0
                    && !oldDestinationAnnouncement.getChannelList().equals(newDestinationAnnouncement.getChannelList())){
                StringBuffer oldBuf = new StringBuffer();
                StringBuffer newBuf = new StringBuffer();
                String[] oldArray = oldDestinationAnnouncement.getChannelList().split(",");
                for(int i=0;i<oldArray.length;i++){
                    oldBuf.append(DestinationAnnouncement.CHANNEL_TYPE.getCnNameBycnCode(oldArray[i]));
                    oldBuf.append(",");
                }
                String oldValue = oldBuf.substring(0,oldBuf.length()-1);
                for(int i=0;i<newDestinationAnnouncement.getChannelCode().size();i++){
                    newBuf.append(DestinationAnnouncement.CHANNEL_TYPE.getCnNameBycnCode(newDestinationAnnouncement.getChannelCode().get(i)));
                    newBuf.append(",");
                }
                String newValue = newBuf.substring(0,newBuf.length()-1);
                if(!oldValue.equals(newValue)){
                    buffer.append("显示渠道:[原来值:"+oldValue+",新值:"+newValue+"];");
                }
            }
            if (newDestinationAnnouncement.getRank() != null && !newDestinationAnnouncement.getRank().equals(oldDestinationAnnouncement.getRank())) {
                buffer.append("公告排序:[原来值:"+oldDestinationAnnouncement.getRank()+",新值:"+newDestinationAnnouncement.getRank()+"];");

            }
		} catch (Exception e) {
			LOG.error("getLogContent error!msg:"+ e.getMessage());
			e.printStackTrace();
		}
        return buffer.toString();
    }
    /**
     * 找出目的地产品ID
     * @param productIdLst
     * @return
     */
    private String fliterProductIds(List<Long> productIdLst){
    	String result = "";
    	Map<String, Object> paramProdProduct = new HashMap<String, Object>();
        if(CollectionUtils.isEmpty(productIdLst)){
            return result;
        }
        paramProdProduct.put("productIdLst", productIdLst); //产品ID
        paramProdProduct.put("bizCategoryIdArray", bizCategoryIdArray);//产品品类
        paramProdProduct.put("isneedmanager", "false");
        List<ProdProduct> list = prodProductService.findProdProductListSales(paramProdProduct);
        if(CollectionUtils.isNotEmpty(list)){
        	for (ProdProduct prodProduct : list) {
            	result = result + prodProduct.getProductId() + ",";
    		}
        }
        return result;
    }
}
