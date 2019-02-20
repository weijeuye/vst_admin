package com.lvmama.vst.back.prod.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lvmama.vst.back.prod.po.ProdLineRoute;
import com.lvmama.vst.back.prod.po.ProdTrafficRouteRelation;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.map.HashedMap;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizDistrict;
import com.lvmama.vst.back.biz.po.BizDistrictSign;
import com.lvmama.vst.back.biz.po.BizFlight;
import com.lvmama.vst.back.biz.po.BizTrain;
import com.lvmama.vst.back.biz.po.BizTrainSeat;
import com.lvmama.vst.back.biz.po.BizTrainStop;
import com.lvmama.vst.back.biz.service.BizFlightService;
//import com.lvmama.vst.back.biz.service.BizTrainSeatService;
import com.lvmama.vst.back.biz.service.BizTrainService;
import com.lvmama.vst.back.biz.service.BizTrainStopService;
import com.lvmama.vst.back.client.biz.service.DistrictSignClientService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteClientService;
import com.lvmama.vst.back.client.prod.service.ProdTrafficClientService;
import com.lvmama.vst.back.prod.po.ProdTraffic;
import com.lvmama.vst.back.prod.po.ProdTrafficFlight;
import com.lvmama.vst.back.prod.po.ProdTrafficGroup;
/*import com.lvmama.vst.back.prod.service.ProdTrafficBusService;
import com.lvmama.vst.back.prod.service.ProdTrafficFlightService;
import com.lvmama.vst.back.prod.service.ProdTrafficGroupService;
import com.lvmama.vst.back.prod.service.ProdTrafficShipService;*/
import com.lvmama.vst.back.prod.service.ProdTrafficTrainService;
import com.lvmama.vst.back.prod.vo.ProdTrafficVO;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.pub.service.PushAdapterServiceRemote;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 交通插件Action 
 * @author yunghua.ma
 * @Date 2014-07-19
 */
@Controller
@RequestMapping("/prod/traffic")
public class ProdTrafficAction extends BaseActionSupport {

	private static final long serialVersionUID = -6198856582225829130L;
	
	private static final Log LOG = LogFactory.getLog(ProdTrafficAction.class);
	
	@Autowired
	private ProdTrafficClientService prodTrafficService;
	@Autowired
	private BizFlightService bizFlightService;
	@Autowired
	private BizTrainService bizTrainService;
	@Autowired
	private BizTrainStopService bizTrainStopService;
	@Autowired
	private DistrictSignClientService districtSignService;
	
	@Autowired
	private ProdTrafficTrainService prodTrafficTrainService;
	
	/*@Autowired
	private ProdTrafficGroupService prodTrafficGroupService;
	@Autowired
	private ProdTrafficFlightService prodTrafficFlightService;
	@Autowired
	private ProdTrafficBusService prodTrafficBusService;
	@Autowired
	private ProdTrafficShipService prodTrafficShipService;*/
	@Autowired
	private PushAdapterServiceRemote pushAdapterService;
	//@Autowired
	//private BizTrainSeatService bizTrainSeatService;
	@Autowired
	private ProdLineRouteClientService prodLineRouteService;

	/**
	 * 查询交通基本信息
	 */
	@RequestMapping(value = "/findProdTraffic")
	public String findProdTraffic(Model model,Long productId,HttpServletRequest req) throws BusinessException {
		try{
			if(productId!=null){
				String strCategoryId=req.getParameter("categoryId");
				Long categoryId=null;
				if(strCategoryId!=null && !"".equals(strCategoryId)){
					categoryId=Long.parseLong(strCategoryId);
				}
				model.addAttribute("categoryId",categoryId);
				
				List<ProdTrafficGroup> prodTrafficGroupList =  MiscUtils.autoUnboxing( prodTrafficService.selectProdTrafficGroupByProductId(productId) );
				if(prodTrafficGroupList!=null && prodTrafficGroupList.size()>0){
					for(ProdTrafficGroup ptg : prodTrafficGroupList){
						// 设置行程
						ptg.setProdLineRouteList(confirmSelectedLineRoute(productId,ptg.getGroupId()));
					}
				}
				
				/*HashMap<String,Object> params = new HashMap<String,Object>();
				params.put("productId", productId);
				List<ProdTrafficGroup> prodTrafficGroupList = prodTrafficGroupService.selectByParams(params);
				if(prodTrafficGroupList!=null && prodTrafficGroupList.size()>0){

					for(ProdTrafficGroup ptg : prodTrafficGroupList){

						// 设置行程
						ptg.setProdLineRouteList(confirmSelectedLineRoute(productId,ptg.getGroupId()));

						params.put("groupId", ptg.getGroupId());
						//查询飞机
						prepareFlight(params, ptg);
						//查询火车
						ptg.setProdTrafficTrainList(prodTrafficTrainService.selectByParams(params));
						if(ptg.getProdTrafficTrainList()!=null && ptg.getProdTrafficTrainList().size()>0){
							for(ProdTrafficTrain ptt : ptg.getProdTrafficTrainList()){
								//设置起始站的地标
								if(ptt!=null && ptt.getStartDistrict()!=null){
									BizDistrictSign bds = MiscUtils.autoUnboxing( districtSignService.findDistrictSignById(ptt.getStartDistrict()) );
									if(bds!=null){
										ptt.setStartDistrictString(bds.getSignName());
									}
								}
								if(ptt!=null && ptt.getEndDistrict()!=null){
									BizDistrictSign bds = MiscUtils.autoUnboxing( districtSignService.findDistrictSignById(ptt.getEndDistrict()) );
									if(bds!=null){
										ptt.setEndDistrictString(bds.getSignName());
									}
								}
							}
						}
						//查询汽车
						ptg.setProdTrafficBusList(prodTrafficBusService.selectByParams(params));
						//查询轮船
						ptg.setProdTrafficShipList(prodTrafficShipService.selectByParams(params));
					}
				} */
				model.addAttribute("prodTrafficGroupList", prodTrafficGroupList);
				ProdTraffic prodTraffic = MiscUtils.autoUnboxing( prodTrafficService.selectProdTrafficByProductId(productId) );
				model.addAttribute("prodTraffic", prodTraffic);
				
			}
			//设置交通类型
			model.addAttribute("trafficTypeList", ProdTraffic.TRAFFICTYPE.values());
			//设置飞机的舱位等级
			model.addAttribute("cabins", BizFlight.CABIN.values());
			//产品ID
			model.addAttribute("productId", productId);
			// 产品行程列表
			if(CollectionUtils.isNotEmpty(getLineRouteList(productId))){
				model.addAttribute("prodLineRouteList",getLineRouteList(productId));
			}
			//是否添加新的交通组信息页签
			model.addAttribute("addFlag", req.getParameter("addFlag"));
		}catch(Exception e){
			LOG.error(ExceptionFormatUtil.getTrace(e));
		}
		return "/prod/packageTour/traffic/findProdTraffic";
	}

	/**
	 * 标记已选的行程
	 * @param productId
	 * @param groupId
	 */
	private List<ProdLineRoute> confirmSelectedLineRoute(Long productId,Long groupId){

		// 获取所有行程
		List<ProdLineRoute> prodLineRouteList =getLineRouteList(productId);

		if(CollectionUtils.isEmpty(prodLineRouteList)){
			return prodLineRouteList;
		}

		List<ProdTrafficRouteRelation> relationList = prodTrafficService.findTrafficRouteRelationListByGroupId(groupId);
		if(CollectionUtils.isEmpty(relationList)){
			return prodLineRouteList;
		}

		List<Long> selectedLineRouteIds = new ArrayList<>();
		for(ProdTrafficRouteRelation relation:relationList){
			selectedLineRouteIds.add(relation.getLineRouteId());
		}

		for(ProdLineRoute lineRoute:prodLineRouteList){
			Long lineRoueId = lineRoute.getLineRouteId();
			if(selectedLineRouteIds.contains(lineRoueId)){
				lineRoute.setSelected(true);
			}
		}

		return prodLineRouteList;
	}

	/**
	 * 获取产品对应行程列表
	 * @param productId
	 * @return
	 */
	private List<ProdLineRoute> getLineRouteList(Long productId){
		// 获取所有行程
		List<ProdLineRoute> prodLineRouteList = null;
		try{
			Map<String, Object> par = new HashedMap();
			par.put("productId", productId);
			prodLineRouteList = MiscUtils.autoUnboxing( prodLineRouteService.findProdLineRouteByParamsSimple(par) );
		} catch(Exception e){
			LOG.error(e.getMessage(), e);
		}
		return prodLineRouteList;
	}

	@RequestMapping(value = "/getTrafficDetail")
	@ResponseBody
	public Object getTrafficDetail(Long productId) throws BusinessException {
		if(productId == null || productId == 0L){
			return new ResultMessage(ResultMessage.ERROR, "产品ID不能为空");
		}

		HashMap<String,Object> params = new HashMap<String,Object>();
		params.put("productId", productId);
		List<ProdTrafficGroup> prodTrafficGroupList = MiscUtils.autoUnboxing( prodTrafficService.selectProdTrafficGroupByProductId(productId) );
		if(prodTrafficGroupList != null) {
			for(ProdTrafficGroup ptg : prodTrafficGroupList){
				// 设置行程
				ptg.setProdLineRouteList(confirmSelectedLineRoute(productId,ptg.getGroupId()));
				ptg.setProdTrafficTrainList(prodTrafficTrainService.selectJoinCityByParams(params));
			}
		}
		/*List<ProdTrafficGroup> prodTrafficGroupList = prodTrafficGroupService.selectByParams(params);

		for(ProdTrafficGroup ptg : prodTrafficGroupList){

			// 设置行程
			ptg.setProdLineRouteList(confirmSelectedLineRoute(productId,ptg.getGroupId()));

			params.put("groupId", ptg.getGroupId());
			//查询飞机
			prepareFlight(params, ptg);
			//查询火车
			ptg.setProdTrafficTrainList(prodTrafficTrainService.selectJoinCityByParams(params));
			if(ptg.getProdTrafficTrainList()!=null && ptg.getProdTrafficTrainList().size()>0){
				for(ProdTrafficTrain ptt : ptg.getProdTrafficTrainList()){
					//设置起始站的地标
					if(ptt!=null && ptt.getStartDistrict()!=null){
						BizDistrictSign bds = MiscUtils.autoUnboxing( districtSignService.findDistrictSignById(ptt.getStartDistrict()) );
						if(bds!=null){
							ptt.setStartDistrictString(bds.getSignName());
						}
					}
					if(ptt!=null && ptt.getEndDistrict()!=null){
						BizDistrictSign bds = MiscUtils.autoUnboxing( districtSignService.findDistrictSignById(ptt.getEndDistrict()) );
						if(bds!=null){
							ptt.setEndDistrictString(bds.getSignName());
						}
					}
				}
			}
			//查询汽车
			ptg.setProdTrafficBusList(prodTrafficBusService.selectByParams(params));
			//查询轮船
			ptg.setProdTrafficShipList(prodTrafficShipService.selectByParams(params));
		}*/

		//查询基础信息
		ProdTraffic traffic = MiscUtils.autoUnboxing( prodTrafficService.selectProdTrafficByProductId(productId) );
		Map<String, Object> attributes = new HashMap<String, Object>();
		attributes.put("traffic", traffic);
		attributes.put("trafficGroupList", prodTrafficGroupList);
		return new ResultMessage(attributes, ResultMessage.SUCCESS, "成功获取信息");
	}

    private void prepareFlight(HashMap<String, Object> params, ProdTrafficGroup ptg) {
        List<ProdTrafficFlight> prodTrafficFlights = prodTrafficService.selectJoinCityByParams(params);
        HashMap<String, Object> flightNo = new HashMap<String, Object>(1);
        for(ProdTrafficFlight prodTrafficFlight : prodTrafficFlights){
            flightNo.put("flightNo", prodTrafficFlight.getFlightNo());
            List<BizFlight> bizFlights = bizFlightService.selectByParams(flightNo);
            if(null!=bizFlights && bizFlights.size()>0){
            	 BizFlight bizFlight = bizFlights.get(0);
                 prodTrafficFlight.setBizFlight(bizFlight);
            }
        }
        ptg.setProdTrafficFlightList(prodTrafficFlights);
    }
	
	/**
	 * 保存交通基本信息
	 */
	@RequestMapping(value = "/saveProdTraffic")
	@ResponseBody
	public String updateProdTraffic(Model model,ProdTraffic prodTraffic,HttpServletRequest req) throws BusinessException {
		ResultHandleT<Boolean> resultWrapper = prodTrafficService.saveProdTraffic(prodTraffic);
		
		//comment for split vst_admin by huang.gen in favor of client interface
		//首先判断基本信息是否已经存在，如果存在则直接返回.
		/*if(prodTraffic!=null && prodTraffic.getProductId()!=null){
			ProdTraffic tempTraffic = MiscUtils.autoUnboxing( prodTrafficService.selectProdTrafficByProductId(prodTraffic.getProductId()) );
			int rs = 0;
			if(tempTraffic!=null){
				rs = prodTrafficService.updateByPrimaryKey(prodTraffic);
				if(StringUtils.isBlank(tempTraffic.getBackType())){
					tempTraffic.setBackType("");
				}
				if(StringUtils.isBlank(tempTraffic.getToType())){
					tempTraffic.setToType("");
				}
				//去程交通或返程交通改变，删除交通组信息
				if( (tempTraffic.getBackType()!=null &&prodTraffic.getBackType()==null)
					||(tempTraffic.getBackType()==null &&prodTraffic.getBackType()!=null)
					||(tempTraffic.getToType()!=null && prodTraffic.getToType() ==null)
					||(tempTraffic.getToType()==null && prodTraffic.getToType() !=null)
					||(!tempTraffic.getBackType().equals(prodTraffic.getBackType()) 
					|| (!tempTraffic.getToType().equals(prodTraffic.getToType())))){
					HashMap<String,Object> params = new HashMap<String,Object>();
					params.put("productId", prodTraffic.getProductId());
					//删除交通组信息
					 List<ProdTrafficGroup>  ptgList = prodTrafficGroupService.selectByParams(params);
					 if(ptgList!=null && ptgList.size() >0){
						 for(ProdTrafficGroup ptg : ptgList){
							 prodTrafficGroupService.deleteByPrimaryKey(ptg.getGroupId());
						 }
					 }
				 }
			}else{
				rs = prodTrafficService.insert(prodTraffic);
			}

			if(rs == 1)
				return ResultMessage.SUCCESS;
		}*/
		
		return resultWrapper == null || resultWrapper.isFail() || resultWrapper.getReturnContent() == null || resultWrapper.getReturnContent() == false ?
				ResultMessage.ERROR : ResultMessage.SUCCESS;
	}
	
	/**
	 * 查询航班信息
	 */
	@RequestMapping(value = "/findFlight")
	@ResponseBody
	public Object findFlight(String flightNo) throws BusinessException {
		if (flightNo == null) {
			return new ResultMessage(ResultMessage.ERROR, "航班号不能为空");
		}

		flightNo = flightNo.trim();
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("flightNo", flightNo);
		params.put("cancelFlag", "Y");
		List<BizFlight> flightList = bizFlightService.selectFlightListByParams(params);

		if(CollectionUtils.isEmpty(flightList)){
			return new ResultMessage(ResultMessage.ERROR, "无该航班信息，请重新查询或手动录入");
		}

		Map<String, Object> attributes = new HashMap<String, Object>();
		attributes.put("flight", flightList.get(0));
		return new ResultMessage(attributes, ResultMessage.SUCCESS, "查询成功");
	}

	/**
	 * 查询火车信息
	 */
	@RequestMapping(value = "/findTrain")
	@ResponseBody
	public Object findTrain(String trainNo) throws BusinessException {
		if (StringUtils.isEmpty(trainNo)) {
			return new ResultMessage(ResultMessage.ERROR, "车次号不能为空");
		}

		trainNo = trainNo.trim();
		HashMap<String,Object> params = new HashMap<String,Object>();
		params.put("trainNo", trainNo);
		params.put("cancelFlag", "Y");
		List<BizTrain> trainList = bizTrainService.selectByParams(params);

		if(CollectionUtils.isEmpty(trainList)){
			return new ResultMessage(ResultMessage.ERROR, "未检测到该车次号对应的有效车次信息");
		}

		BizTrain train = trainList.get(0);

		//设置车型
		train.setTrainTypeString(BizTrain.TRAIN_TYPE.getCnName(Long.toString(train.getTrainType())));

		//查询火车停靠站信息
		List<BizTrainStop> trainStopList = bizTrainStopService.findTrainStopListByTrainId(train.getTrainId());

		if(CollectionUtils.isEmpty(trainStopList)){
			return new ResultMessage(ResultMessage.ERROR, "未检测到该车次号对应的停靠站信息");
		} else if (trainStopList.size() <= 1) {
			return new ResultMessage(ResultMessage.ERROR, "停靠站信息有误");
		}

		//查询坐席信息
		List<BizTrainSeat> trainSeatList = prodTrafficService.findTrainSeatListByByTrainNo(trainNo);

		if(CollectionUtils.isEmpty(trainSeatList)){
			return new ResultMessage(ResultMessage.ERROR, "未检测到该车次号对应的坐席信息");
		}

		//回传给页面的信息
		Map<String, Object> attributes = new HashMap<String, Object>();
		attributes.put("train", train);
		attributes.put("trainStopList", trainStopList);
		attributes.put("trainSeatList", trainSeatList);

		return new ResultMessage(attributes, ResultMessage.SUCCESS, "获取信息成功");
	}

	/**
	 * 模糊查询火车站
	 * @param search
	 * @param resp
	 */
	@RequestMapping(value = "/searchTrainStationList")
	@ResponseBody
	public Object searchDestList(String search,HttpServletResponse resp){
		if (log.isDebugEnabled()) {
			log.debug("start method<searchDestList>");
		}
		HashMap<String,Object> params = new HashMap<String,Object>();
		params.put("signName", search);
		params.put("signType", "2004");
		params.put("like", "Y");
		List<BizDistrictSign> list = null;
		list = MiscUtils.autoUnboxing( districtSignService.findDistrictSignList(params) );
		JSONArray array = new JSONArray();
		if(list != null && list.size() > 0){
			for(BizDistrictSign districtSign:list){
				JSONObject obj=new JSONObject();
				obj.put("id", districtSign.getSignId());
				obj.put("text", districtSign.getSignName());
				array.add(obj);
			}
		}
		return array;
	}
	
	/**
	 * 模糊查询航班号
	 * @param search
	 * @param resp
	 */
	@RequestMapping(value = "/searchFlightNoList")
	@ResponseBody
	public Object searchFlightNoList(String search,HttpServletResponse resp){
		if (log.isDebugEnabled()) {
			log.debug("start method<searchDestList>");
		}
		HashMap<String,Object> params = new HashMap<String,Object>();
		params.put("flightNo", search);
		params.put("like", "Y");
		List<BizFlight> flightList = bizFlightService.selectByParams(params);
		JSONArray array = new JSONArray();
		if(flightList != null && flightList.size() > 0){
			for(BizFlight flight : flightList){
				JSONObject obj=new JSONObject();
				obj.put("id", flight.getFlightId());
				obj.put("text", flight.getFlightNo());
				array.add(obj);
			}
		}
		return array;
	}

	/**
	 * 模糊查询火车班次
	 * @param search
	 * @param resp
	 */
	@RequestMapping(value = "/searchTrainNoList")
	@ResponseBody
	public Object searchTrainNoList(String search,HttpServletResponse resp){
		if (log.isDebugEnabled()) {
			log.debug("start method<searchDestList>");
		}
		HashMap<String,Object> params = new HashMap<String,Object>();
		params.put("trainNo", search);
		params.put("like", "Y");
		List<BizTrain> trainList = bizTrainService.selectByParams(params);
		JSONArray array = new JSONArray();
		if(trainList != null && trainList.size() > 0){
			for(BizTrain train : trainList){
				JSONObject obj=new JSONObject();
				obj.put("id",train.getTrainId());
				obj.put("text", train.getTrainNo());
				array.add(obj);
			}
		}
		return array;
	}

	/**
	 * 保存交通信息
	 */
	@RequestMapping(value = "/editProdTrafficDetail")
	@ResponseBody
	public Object editProdTrafficDetail(Model model,ProdTrafficVO prodTrafficDetailVO,HttpServletRequest req) throws BusinessException {
		try{
			if(prodTrafficDetailVO!=null){
				prodTrafficService.updateTrafficDetial(prodTrafficDetailVO);
				
				if(prodTrafficDetailVO.getProdTrafficGroupList() != null && prodTrafficDetailVO.getProdTrafficGroupList().size() > 0){
					this.pushAdapterService.push(prodTrafficDetailVO.getProdTrafficGroupList().get(0).getProductId(), ComPush.OBJECT_TYPE.PRODUCT, ComPush.PUSH_CONTENT.PROD_TRAFFIC, ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
				}
			}
		}catch(Exception e){
			return new ResultMessage("error", e.getMessage());
		}
		return new ResultMessage("success", "保存成功");
	}

	/**
	 * 删除交通信息
	 */
	@RequestMapping(value = "/deleteProdTrafficDetail")
	@ResponseBody
	public Object deleteProdTrafficDetail(Model model,Long id,String type,HttpServletRequest req) throws BusinessException {
		
		try{
			if(type==null || id==null){
				throw new BusinessException("类型或ID不能为空");
			}
			//删除火车信息
			if("TRAIN".equalsIgnoreCase(type)){
				//int rs = prodTrafficTrainService.deleteByPrimaryKey(id);
				int  rs = MiscUtils.autoUnboxing(prodTrafficService.deleteTrafficTrainByKey(id));
				if(rs==1)
					return ResultMessage.DELETE_SUCCESS_RESULT;
				else
					return ResultMessage.DELETE_FAIL_RESULT;
			}
			//删除飞机信息
			if("FLIGHT".equalsIgnoreCase(type)){
				//int rs = prodTrafficFlightService.deleteByPrimaryKey(id);
				int  rs = MiscUtils.autoUnboxing(prodTrafficService.deleteTrafficFlightByKey(id));
				if(rs==1)
					return ResultMessage.DELETE_SUCCESS_RESULT;
				else
					return ResultMessage.DELETE_FAIL_RESULT;
			}
			//删除汽车信息
			if("BUS".equalsIgnoreCase(type)){
				//int rs = prodTrafficBusService.deleteByPrimaryKey(id);
				int  rs = MiscUtils.autoUnboxing(prodTrafficService.deleteTrafficBusByKey(id));
				if(rs==1)
					return ResultMessage.DELETE_SUCCESS_RESULT;
				else
					return ResultMessage.DELETE_FAIL_RESULT;
			}
			//删除轮船信息
			if("SHIP".equalsIgnoreCase(type)){
				//int rs = prodTrafficShipService.deleteByPrimaryKey(id);
				int  rs = MiscUtils.autoUnboxing(prodTrafficService.deleteTrafficShipByKey(id));
				if(rs==1)
					return ResultMessage.DELETE_SUCCESS_RESULT;
				else
					return ResultMessage.DELETE_FAIL_RESULT;
			}
			//删除组信息
			if("TRAFFIC".equalsIgnoreCase(type)){
				//int rs = prodTrafficGroupService.deleteByPrimaryKey(id);
				int  rs = MiscUtils.autoUnboxing(prodTrafficService.deleteTrafficGroupByKey(id) );
				if(rs==1)
					return ResultMessage.DELETE_SUCCESS_RESULT;
				else
					return ResultMessage.DELETE_FAIL_RESULT;
			}


			
		}catch(Exception e){
			return ResultMessage.DELETE_FAIL_RESULT;
		}
		
		return ResultMessage.DELETE_FAIL_RESULT;
	}

	/**
     * 模糊查询机场
     * @param search
     * @param resp
     */
    @RequestMapping(value = "/searchAirportList")
    @ResponseBody
    public Object searchAirportList(String search, HttpServletResponse resp){
        if (log.isDebugEnabled()) {
            log.debug("start method<searchAirportList>");
        }
        HashMap<String,Object> params = new HashMap<String,Object>();
        params.put("signName", search);
        params.put("signType", "2003");
        params.put("like", "Y");
        List<BizDistrictSign> bizDistrictSigns = MiscUtils.autoUnboxing( districtSignService.findDistrictSignList(params) );
        JSONArray array = new JSONArray();
        if(bizDistrictSigns != null && bizDistrictSigns.size() > 0){
            for(BizDistrictSign bizDistrictSign : bizDistrictSigns){
                JSONObject obj=new JSONObject();
                obj.put("id", bizDistrictSign.getSignId());
                obj.put("text", bizDistrictSign.getSignName());
                array.add(obj);
            }
        }
        return array;
    }

	/**
	 * @param model
	 * @param page
	 * @param district
	 * @param uniqueTag input输入框的唯一标记
	 * @param trafficType 交通类型
	 * @param req
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/selectCityList")
	public String selectCityList(Model model, Integer page, BizDistrict district, String uniqueTag, String trafficType, HttpServletRequest req) throws BusinessException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("districtName", district.getDistrictName());
		params.put("districtType", district.getDistrictType());
		if (StringUtils.isNotEmpty(trafficType)) {
			//设置地理位置类型为飞机场
			if (ProdTraffic.TRAFFICTYPE.FLIGHT.name().equalsIgnoreCase(trafficType)) {
				params.put("signTypeAll", BizDistrictSign.DISTRICT_SIGN_TYPE.RAILWAY_STATION.getId());
			} else {//设置地理位置类型为火车站
				params.put("signTypeAll", BizDistrictSign.DISTRICT_SIGN_TYPE.AIRPORT.getId());
			}
		}
		params.put("cancelFlag", "Y");
		int count = districtSignService.findCityListCountForTraffic(params);

		int pagenum = page == null ? 1 : page;
		Page<BizDistrict> pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		params.put("_start", pageParam.getStartRows());
		params.put("_end", pageParam.getEndRows());
		params.put("_orderby", "DISTRICT_ID");
		params.put("_order", "DESC");
		List<BizDistrict> list = districtSignService.findCityListForTraffic(params);
		pageParam.setItems(list);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("uniqueTag", uniqueTag);
		model.addAttribute("districtName", district.getDistrictName());
		model.addAttribute("districtType", district.getDistrictType());
		model.addAttribute("districtTypeList", BizDistrict.DISTRICT_TYPE.values());
		model.addAttribute("page", pageParam.getPage().toString());

		return "/prod/packageTour/traffic/selectCityList";
	}
}