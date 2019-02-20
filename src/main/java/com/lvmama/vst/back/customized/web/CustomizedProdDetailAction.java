package com.lvmama.vst.back.customized.web;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.customized.po.CustomizedProdDetail;
import com.lvmama.vst.back.customized.po.CustomizedProduct;
import com.lvmama.vst.back.customized.service.CustomizedProdDetailService;
import com.lvmama.vst.back.customized.service.CustomizedProductService;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

@Controller
@RequestMapping("/prod/customizedProdDetail")
public class CustomizedProdDetailAction extends BaseActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1203066078982879552L;
	
	@Autowired
	CustomizedProdDetailService customizedProdDetailService;
	
	@Autowired
	CustomizedProductService customizedProductService;
	
	/**
	 * 跳转到新增或修改产品详情页面
	 * @param model
	 * @param req
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/showAddOrUpdateProductDetail")
	public String showAddProductDetail(Model model,Long productId,HttpServletRequest req) throws BusinessException {
		
		CustomizedProduct customizedProduct = customizedProductService.findCustomizedProductByCustomizedProdId(productId);
		
		model.addAttribute("customizedProduct", customizedProduct);
		
		List<CustomizedProdDetail> customizedProdDetailList = customizedProdDetailService.findCustomizedProdDetailByProdId(productId);
		
		model.addAttribute("customizedProdDetailList",customizedProdDetailList);
		
		return "/prod/customized/showAddOrUpdateProductDetail";
	}
	
	/**
	 * 新增产品详情
	 * @param model
	 * @param req
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/addCustomizedProdDetail")
	@ResponseBody
	public Object addCustomizedProdDetail(Model model,CustomizedProduct customizedProduct,Long productId,HttpServletRequest req) throws BusinessException {
		Map<String, Object> attributes = new HashMap<String, Object>();
		try {
			if(productId != null) {
				//先删除该产品下的所有产品详情，再添加
				customizedProdDetailService.deleteCustomizedProdDetailByProdId(productId);
				for(CustomizedProdDetail customizedProdDetail : customizedProduct.getCustomizedProdDetailList()) {
					//这里需加入createuser
					customizedProdDetail.setCustomizedProdId(productId);
					customizedProdDetail.setCreateTime(new Date());
					customizedProdDetail.setCreateUser(getLoginUserId());
					Long id = customizedProdDetailService.addCustomizedProdDetail(customizedProdDetail);
					customizedProdDetail.setCustomizedProdDetailId(id);
				}
				
				CustomizedProduct customizedProductParam = new CustomizedProduct();
				customizedProductParam.setCustomizedProdId(productId);
				customizedProductParam.setUpdateUser(getLoginUserId());
				customizedProductParam.setUpdateTime(new Date());
				customizedProductService.updateCustomizedProductByCustomizedProdId(customizedProductParam);
			} else {
				return new ResultMessage(attributes, "success", "产品Id为空");
			}
		} catch(Exception e) {
			return new ResultMessage(attributes, "success", "保存失败");
		}
		
		return new ResultMessage(attributes, "success", "保存成功");
	}
	
	/**
	 * 通过产品ID和产品详情ID删除产品详情
	 * @param model
	 * @param productId 产品ID
	 * @param customizedProdDetailId 产品详情ID
	 * @param req
	 * @return
	 */
	@RequestMapping(value="deleteCustomizedProdDetail")
	@ResponseBody
	public Object deleteCustomizedProdDetail(Model model,Long productId,Long customizedProdDetailId,HttpServletRequest req) {
		
		Map<String, Object> attributes = new HashMap<String, Object>();
		customizedProdDetailService.deleteCustomizedProdDetailByProdIdAndCustomizedProdDetailId(customizedProdDetailId,productId);
		
		CustomizedProduct customizedProductParam = new CustomizedProduct();
		customizedProductParam.setCustomizedProdId(productId);
		customizedProductParam.setUpdateUser(getLoginUserId());
		customizedProductParam.setUpdateTime(new Date());
		customizedProductService.updateCustomizedProductByCustomizedProdId(customizedProductParam);
		return new ResultMessage(attributes, "success", "删除成功");
	}

}
