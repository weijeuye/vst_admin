package com.lvmama.vst.back.prod.web;

import com.lvmama.vst.back.client.prod.service.ProdCalClientService;
import com.lvmama.vst.back.prod.service.IProdProductDataService;
import com.lvmama.vst.comm.utils.DateUtil;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by libing on 2015/10/28.
 */
@Controller
@RequestMapping("/prod/productData")
public class ProdProductDataAction extends BaseActionSupport {

    private static final Log LOG = LogFactory.getLog(ProdProductDataAction.class);

    @Autowired
    private IProdProductDataService prodProductDataService;

    @Autowired
    private ProdCalClientService prodCalClientService;

    @RequestMapping(value = "/flightService")
    @ResponseBody
    public Object updateProduct(HttpServletRequest req) throws BusinessException {
        ResultHandleT retObj = new ResultHandleT();
        try{
            String service = req.getParameter("service")==null?"":req.getParameter("service");
            Long productId = req.getParameter("productId")==null?null:Long.valueOf(req.getParameter("productId"));
            Long startDistrictId = req.getParameter("startDistrictId")==null?null:Long.valueOf(req.getParameter("startDistrictId"));
            Date selectDate = req.getParameter("selectDate")==null?null: DateUtil.toDate(req.getParameter("selectDate"), "yyyy-MM-dd");
            Long adultQuantity = req.getParameter("adultQuantity")==null?null:Long.valueOf(req.getParameter("adultQuantity"));
            Long childQuantity = req.getParameter("childQuantity")==null?null:Long.valueOf(req.getParameter("childQuantity"));
            Long quantity = req.getParameter("quantity")==null?null:Long.valueOf(req.getParameter("quantity"));
            Long distributorId = req.getParameter("distributorId")==null?null:Long.valueOf(req.getParameter("distributorId"));
            Long groupId = req.getParameter("groupId")==null?null:Long.valueOf(req.getParameter("groupId"));
            Date beginDate = req.getParameter("beginDate")==null?null: DateUtil.toDate(req.getParameter("beginDate"), "yyyy-MM-dd");
            Date endDate = req.getParameter("endDate")==null?null: DateUtil.toDate(req.getParameter("endDate"), "yyyy-MM-dd");
            String IS_DEBUG = req.getParameter("IS_DEBUG")==null?null: req.getParameter("IS_DEBUG").toString();

            Map<String, Object> pMap = new HashMap<String, Object>();
            pMap.put("startDistrictId", startDistrictId);
            pMap.put("adultQuantity", adultQuantity);
            pMap.put("childQuantity", childQuantity);
            pMap.put("selectDate", selectDate);
            pMap.put("distributorId", distributorId);
            pMap.put("groupId", groupId);
            pMap.put("beginDate", beginDate);
            pMap.put("endDate", endDate);
            pMap.put("IS_DEBUG", IS_DEBUG);
            pMap.put("quantity", quantity);
//            String startDistrictIdSt = req.getParameter("startDistrictIdSt")==null?null:req.getParameter("startDistrictIdSt");
//            if(startDistrictIdSt!=null){
//                pMap.put("startDistrictId", startDistrictIdSt);
//            }

            if("loadDefaultProductGoods".equalsIgnoreCase(service)){
                retObj = prodProductDataService.loadDefaultProductGoods(productId, pMap);
            }
            else if("loadChangeTrafficGoods".equalsIgnoreCase(service)){
                retObj = prodProductDataService.loadChangeTrafficGoods(productId, pMap);
            }
            else if("loadProductLowestPrice".equalsIgnoreCase(service)){
                retObj = prodProductDataService.loadProductLowestPrice(productId, pMap);
            }
            else if("loadProductGroupDate".equalsIgnoreCase(service)){
                retObj = prodProductDataService.loadProductGroupDate(productId, pMap);
            }
            else if("hasApiFlightGoods".equalsIgnoreCase(service)){
                retObj = prodProductDataService.hasApiFlightGoods(productId, pMap);
            }
            else if("getProdStartDistrictForSale".equalsIgnoreCase(service)){
                Map<String, Object> pMap1 = new HashMap<String, Object>();
                pMap1.put("productId", productId);
                retObj = prodCalClientService.getProdStartDistrictForSale(pMap1);
            }
            else{
                retObj.setMsg("Service ["+service+"] is not exist.");
            }
        }catch(Exception ex){
            retObj.setMsg(ex);
        }
        return retObj;
    }
}
