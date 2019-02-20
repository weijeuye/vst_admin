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
import com.lvmama.vst.back.customized.po.CustomizedProdEnum;
import com.lvmama.vst.back.customized.po.CustomizedProdLineInfo;
import com.lvmama.vst.back.customized.po.CustomizedProduct;
import com.lvmama.vst.back.customized.service.CustomizedProdLineInfoService;
import com.lvmama.vst.back.customized.service.CustomizedProductService;
import com.lvmama.vst.back.prod.po.LineRouteEnum;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;

@Controller
@RequestMapping("/prod/customizedProdLineInfo")
public class CustomizedProdLineInfoAction extends BaseActionSupport {
	
	@Autowired
	private CustomizedProductService customizedProductService;
	
	@Autowired
	private CustomizedProdLineInfoService customizedProdLineInfoService;

	/**
	 *
	 */
	private static final long serialVersionUID = 8666698582623921400L;

	
	@RequestMapping(value="/showAddOrUpdateCustomizedProdLineInfo")
	public String showUpdateCustomizedProdLineInfo(Model model,Long productId,HttpServletRequest req) {
		
		CustomizedProduct customizedProduct = customizedProductService.findCustomizedProductByCustomizedProdId(productId);
		
		model.addAttribute("customizedProduct", customizedProduct);
		
		List<CustomizedProdLineInfo> customizedProdLineInfoList = customizedProdLineInfoService.findCustomizedProdLineInfoByCustomizedProdId(productId);
		
		model.addAttribute("customizedProdLineInfoList",customizedProdLineInfoList);
		model.addAttribute("trafficList", CustomizedProdEnum.TRAFFIC_TYPE.values());
		
		model.addAttribute("customizedProdLineInfo",new CustomizedProdLineInfo());
		
		return "/prod/customized/showAddOrUpdateCustomizedProdLineInfo";
	}
	
	@RequestMapping(value="addCustomizedProdLineInfo")
	@ResponseBody
	public Object addCustomizedProdLineInfo(Model model,CustomizedProduct customizedProduct,Long productId,HttpServletRequest req) {
		Map<String, Object> attributes = new HashMap<String, Object>();
		if(productId != null) {
			//先删除该产品下的所有产品详情，再添加
			customizedProdLineInfoService.deleteCustomizedProdLineInfoByCustomizedProdId(productId);
			for(CustomizedProdLineInfo customizedProdLineInfo : customizedProduct.getCustomizedProdLineInfoList()) {
				//这里需加入createuser
				customizedProdLineInfo.setCreateUser(this.getLoginUser().getUserName());
				customizedProdLineInfo.setCustomizedProdId(productId);
				customizedProdLineInfo.setCreateTime(new Date());
				Long id =customizedProdLineInfoService.addCustomizedProdLineInfo(customizedProdLineInfo);
				customizedProdLineInfo.setProdLineInfoId(id);
			}
			CustomizedProduct customizedProductParam = new CustomizedProduct();
			customizedProductParam.setCustomizedProdId(productId);
			customizedProductParam.setUpdateTime(new Date());
			customizedProductService.updateCustomizedProductByCustomizedProdId(customizedProductParam);
		} else {
			return new ResultMessage(attributes, "success", "产品Id为空");
		}
		
		return new ResultMessage(attributes, "success", "保存成功");
	}
}
