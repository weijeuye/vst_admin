package com.lvmama.vst.back.dujia.group.route.web;

import static com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE.PROD_TRAVEL_DESIGN;
import static com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE.PROD_LINE_ROUTE;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.dujia.client.comm.route.service.ProdLineRouteDescriptionClientService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.goods.vo.ProdProductParam;
import com.lvmama.vst.back.prod.po.ProdLineRoute;
import com.lvmama.vst.back.prod.po.ProdLineRouteDetail;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteDetailClientService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteClientService;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.prod.service.ProdVisadocReService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.back.utils.MiscUtils;

@Controller
@RequestMapping("/dujia/group/route")
public class GroupRouteAction extends BaseActionSupport {

	private static final long serialVersionUID = 2904927957780389923L;

	@Autowired
	private ProdProductService prodProductService;

	@Autowired
	private ProdLineRouteClientService prodLineRouteService;

	@Autowired
	private ProdVisadocReService prodVisadocReService;

	@Autowired
	private ProdLineRouteDetailClientService prodLineRouteDetailService;

	@Autowired
	private ProdLineRouteDescriptionClientService prodLineRouteDescriptionService;

	@Autowired
	private ComLogClientService comLogService;

	/**
	 * 跳转到行程明細
	 */
	@RequestMapping(value = "/editProdRouteDetail")
	public String toEditProdRouteDetail(Long productId, Long lineRouteId,Model model) {
		ProdProductParam paramMap=new ProdProductParam();
		paramMap.setBizCategory(true);
		ProdProduct prodProduct = prodProductService.findProdProductById(productId,paramMap);
		model.addAttribute("prodProduct", prodProduct);
		model.addAttribute("packageType", ProdProduct.PACKAGETYPE.getCnName(prodProduct.getPackageType()));

		model.addAttribute("prodLineRoute", prodLineRouteService.findByProdLineRouteId(lineRouteId));

		List<ProdLineRouteDetail> prodLineRouteDeatilList=prodLineRouteDetailService.selectByProdLineRouteId(lineRouteId) ;
		model.addAttribute("prodLineRouteDeatilList", prodLineRouteDeatilList);
		return "/dujia/group/route/showRouteDetail";
	}

	/**
	 * 新增行程明细
	 */
	@RequestMapping(value = "/addProdLineRouteDetail")
	@ResponseBody
	public Object addProdLineRouteDetail(ProdLineRoute prodLineRoute) throws BusinessException {

		if(prodLineRoute.getProductId()==null||prodLineRoute.getLineRouteId()==null) return new ResultMessage( "error", "行程明细保存失败");

		List<ProdLineRouteDetail> newRouteDetailList=new ArrayList<ProdLineRouteDetail>();
		for(ProdLineRouteDetail detail:prodLineRoute.getProdLineRouteDetailList()){
			if(detail.getnDay()!=null&&detail.getnDay()!=0){
				newRouteDetailList.add(detail);
			}
		}
		prodLineRoute.setProdLineRouteDetailList(newRouteDetailList);
		prodLineRouteDetailService.saveProdLineRouteDetail(prodLineRoute);

		//重新构建费用包含信息（当 N早N正 改变时）
		prodLineRouteDescriptionService.rebuildCostInclude(prodLineRoute.getProductId(), prodLineRoute.getLineRouteId());

		//日志
		for(ProdLineRouteDetail prodLineRouteDetail : newRouteDetailList){
			logLineRouteOperate(prodLineRoute,"更新行程明细："+getProdLineRouteDetailLog(prodLineRouteDetail),"更新行程明细");
		}

		return new ResultMessage( "success", "行程明细保存成功");
	}

	/**
	 * 记录行程操作日志
	 */
	private void logLineRouteOperate(ProdLineRoute LineRoute, String logText, String logName) {
		try{
			ProdLineRoute pRoute=MiscUtils.autoUnboxing(prodLineRouteService.findByProdLineRouteId(LineRoute.getLineRouteId()));

			comLogService.insert(PROD_LINE_ROUTE, LineRoute.getProductId(), LineRoute.getLineRouteId(),
					this.getLoginUser().getUserName(), "【"+pRoute.getRouteName()+"】"+logText, PROD_TRAVEL_DESIGN.name(), logName, null);
		}catch(Exception e) {
			log.error("Record Log failure ！Log Type:" + PROD_TRAVEL_DESIGN.name());
			log.error(e.getMessage(), e);
		}
	}

	private String getProdLineRouteDetailLog(ProdLineRouteDetail prodLineRouteDetail){
		if(prodLineRouteDetail == null){
			return null;
		}
		StringBuffer trafficNameBF=new StringBuffer();
		String trafficType=prodLineRouteDetail.getTrafficType();
		if(trafficType!=null&&trafficType!=""&&trafficType.length()>0){
			String traffic[]=trafficType.split(",");
			List<String> trafficList= Arrays.asList(traffic);
			for(String s:trafficList){
				if("PLANE".equals(s)){
					trafficNameBF.append("飞机 ");
				}
				if("TRAIN".equals(s)){
					trafficNameBF.append("火车 ");
				}
				if("BARS".equals(s)){
					trafficNameBF.append("巴士 ");
				}
				if("BOAT".equals(s)){
					trafficNameBF.append("轮船");
				}
				if("OTHERS".equals(s)){
					trafficNameBF.append("其他 ");
				}
			}
		}
		
		
		String ret = "线路产品明细Id:"+(prodLineRouteDetail.getDetailId()==null?"":prodLineRouteDetail.getDetailId())
					+",关联行程Id:"+(prodLineRouteDetail.getRouteId()==null?"":prodLineRouteDetail.getRouteId())
					+",线路天数:"+(prodLineRouteDetail.getnDay()==null?"":prodLineRouteDetail.getnDay())
					+",目的地:"+(prodLineRouteDetail.getTitle()==null?"":prodLineRouteDetail.getTitle())
					+",行程描述:"+(prodLineRouteDetail.getContent()==null?"":prodLineRouteDetail.getContent())
					+",住宿类型:"+(prodLineRouteDetail.getStayType()==null?"":prodLineRouteDetail.getStayType())
					+",住宿描述:"+(prodLineRouteDetail.getStayDesc()==null?"":prodLineRouteDetail.getStayDesc())
					+",是否有早餐:"+(prodLineRouteDetail.getBreakfastFlag()==null?"":prodLineRouteDetail.getBreakfastFlag())
					+",早餐描述:"+(prodLineRouteDetail.getBreakfastDesc()==null?"":prodLineRouteDetail.getBreakfastDesc())
					+",是否有午餐:"+(prodLineRouteDetail.getLunchFlag()==null?"":prodLineRouteDetail.getLunchFlag())
					+",午餐描述:"+(prodLineRouteDetail.getLunchDesc()==null?"":prodLineRouteDetail.getLunchDesc())
					+",是否有晚餐:"+(prodLineRouteDetail.getDinnerFlag()==null?"":prodLineRouteDetail.getDinnerFlag())
					+",晚餐描述:"+(prodLineRouteDetail.getDinnerDesc()==null?"":prodLineRouteDetail.getDinnerDesc())
					+",交通工具类型:"+ trafficNameBF.toString();
		if(prodLineRouteDetail.getTrafficType()!=null && prodLineRouteDetail.getTrafficType().contains("OTHERS")){
			ret +=",其他交通:"+(prodLineRouteDetail.getTrafficOther()==null?"":prodLineRouteDetail.getTrafficOther());
		}
		return ret;
	}
}
