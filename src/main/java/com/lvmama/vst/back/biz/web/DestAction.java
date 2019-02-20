package com.lvmama.vst.back.biz.web;

import com.lvmama.vst.back.biz.po.BizDest;
import com.lvmama.vst.back.biz.po.BizDest.DEST_TYPE;
import com.lvmama.vst.back.biz.po.BizDest.DEST_TYPE_CATEGORY;
import com.lvmama.vst.back.biz.po.BizDestSearch;
import com.lvmama.vst.back.client.biz.service.DestClientService;
import com.lvmama.vst.back.client.prod.service.ProdDestReClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComLog;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.pub.po.ComPush.OPERATE_TYPE;
import com.lvmama.vst.back.pub.service.PushAdapterServiceRemote;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.ChineseToPinYin;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * 目的地管理Action
 * 
 * @author xiexun
 */

@Controller
@RequestMapping("/biz/dest")
public class DestAction extends BaseActionSupport {

	/**
	 * 序列
	 */
	private static final long serialVersionUID = -2280456559494684030L;
	@Autowired
	private DestClientService destService;
	@Autowired
	PushAdapterServiceRemote pushAdapterService;
	@Autowired
	private ProdDestReClientService prodDestReService;
	@Autowired
	private ProdProductService prodProductService;
	@Autowired
	private ComLogClientService comLogService;


	/**
	 * 获得目的地列表
	 */
	@RequestMapping(value = "/findDestList")
	public String findDestList(Model model, Integer page, BizDest bizDest, String dictId, HttpServletRequest req) throws BusinessException {
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("destId", bizDest.getDestId());
		List<DEST_TYPE> destTypeList = new ArrayList<DEST_TYPE>();
		destTypeList.add(BizDest.DEST_TYPE.SCENIC);
		destTypeList.add(BizDest.DEST_TYPE.VIEWSPOT);
		if(!StringUtils.isEmpty(dictId)){
			model.addAttribute("destTypeList", destTypeList);
			if(!"".equals(bizDest.getDestType()) && bizDest.getDestType() != null){
				parameters.put("destType", bizDest.getDestType());
				model.addAttribute("destType", bizDest.getDestType());
			} else {
				parameters.put("destTypes", destTypeList);
			}
		} else {
			model.addAttribute("destTypeList", BizDest.DEST_TYPE.values());
			parameters.put("destType", bizDest.getDestType());
			model.addAttribute("destType", bizDest.getDestType());
		}
		parameters.put("destName", bizDest.getDestName());
		if(null==bizDest.getCancelFlag()){
			parameters.put("cancelFlag", "all");
			model.addAttribute("cancelFlag", "all");
		}else{
			parameters.put("cancelFlag", bizDest.getCancelFlag());
			model.addAttribute("cancelFlag", bizDest.getCancelFlag());
		}		
		int count = MiscUtils.autoUnboxing( destService.findDestCount(parameters) );

		int pagenum = page == null ? 1 : page;
		Page<BizDest> pageParam = Page.page(count, 20, pagenum);
		pageParam.buildUrl(req);
		parameters.put("_start", pageParam.getStartRows());
		parameters.put("_end", pageParam.getEndRows());
		parameters.put("_orderby", "DEST_ID");
		parameters.put("_order", "ASC");
		List<BizDest> list = MiscUtils.autoUnboxing( destService.findDestList(parameters) );
		destService.setParentsDestNameInfo(list,parameters);
		pageParam.setItems(list);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("destId", bizDest.getDestId());
		model.addAttribute("destName", bizDest.getDestName());
		model.addAttribute("page", pageParam.getPage().toString());
		model.addAttribute("dictId", dictId);
		return "/biz/dest/findDestList";
	}


	/**
	 * 跳转到修改页面
	 */
	@RequestMapping(value = "/showUpdateDest")
	public String showUpdateDest(Model model, Long destId) throws BusinessException {
		BizDest bizDest = destService.findDestDetailById(destId);
		model.addAttribute("dest", bizDest);
		model.addAttribute("destTypeList", BizDest.DEST_TYPE.values());
		model.addAttribute("destMarkList", BizDest.DEST_MARK.values());
		return "/biz/dest/showUpdateDest";
	}

	/**
	 * 跳转到添加页面
	 */
	@RequestMapping(value = "/showAddDest")
	public String showAddDest(Model model) {
		model.addAttribute("destTypeList", BizDest.DEST_TYPE.values());
		model.addAttribute("destMarkList", BizDest.DEST_MARK.values());
		return "/biz/dest/showAddDest";
	}

	@RequestMapping(value = "/showManageDestSearch")
	public String showManageDestSearch(Model model, BizDestSearch bizDestSearch){
		if(bizDestSearch != null && bizDestSearch.getDestId() != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("destId", bizDestSearch.getDestId());
			List<BizDestSearch> destSearchs = destService.findBizDestSearchList(params);
			if(CollectionUtils.isNotEmpty(destSearchs)){
				//修改
				model.addAttribute("bizDestSearch", destSearchs.get(0));
			}else{
				//新增
				model.addAttribute("bizDestSearch", bizDestSearch);
			}
		}
		return "/biz/dest/showEditDestSearch";
	}
	
	@RequestMapping(value = "/manageDestSearch")
	@ResponseBody
	public Object manageDestSearch(Model model, BizDestSearch bizDestSearch){
		try {
			if(bizDestSearch != null && bizDestSearch.getId() != null){
				//修改
				destService.updateBizDestSearch(bizDestSearch);
			}else{
				//新增
				destService.addBizDestSearch(bizDestSearch);
			}
			return new ResultMessage(ResultMessage.SUCCESS, "保存成功");
		}catch(Exception e){
			log.error(ExceptionFormatUtil.getTrace(e));
			return new ResultMessage(ResultMessage.ERROR, "保存失败");
		}
	}
	
	/**
	 * 添加目的地
	 * 
	 * @return 添加结果JSON
	 */
	@RequestMapping(value = "/addDest")
	@ResponseBody
	public Object addDest(BizDest bizDest) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<addDistrict>");
		}

		//如果目的地类型不是POI的话，进行去重判断
		if(BizDest.DEST_TYPE.getDestTypeByCode(bizDest.getDestType()).getCategory().compareTo(BizDest.DEST_TYPE_CATEGORY.POI)!=0){
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("districtId", bizDest.getDistrictId());
			param.put("isTypeDistrict", Boolean.TRUE);
			int count = MiscUtils.autoUnboxing( destService.findDestCount(param) );
			if(count>0){
				return new ResultMessage("error","该行政区划下已挂靠其他地区类目的地，请勿重复挂靠");
			}
		}
		
		if ((bizDest.getPinyin() == null) || "".equals(bizDest.getPinyin())) {
			bizDest.setPinyin(ChineseToPinYin.getPingYin(bizDest.getDestName()));
		}
		if ((bizDest.getShortPinyin() == null) || "".equals(bizDest.getShortPinyin())) {
			bizDest.setShortPinyin(ChineseToPinYin.getPinYinHeadChar(bizDest.getDestName()));
		}
		bizDest.setCancelFlag("N");
		destService.addBizDest(bizDest);
		//添加推送信息
		try {
			pushAdapterService.push(bizDest.getDestId(),
					ComPush.OBJECT_TYPE.DEST, ComPush.PUSH_CONTENT.BIZ_DEST,ComPush.OPERATE_TYPE.ADD, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
		} catch (Exception e) {
			log.error("Push info failure ！Push Type:"
					+ ComPush.OBJECT_TYPE.DEST.name() + " ID:"
					+ bizDest.getDestId() + "." + e.getMessage());
		}
		return ResultMessage.ADD_SUCCESS_RESULT;
	}
	
	/**
	 * 更新目的地
	 */
	@RequestMapping(value = "/updateDest")
	@ResponseBody
	public Object updateDest(BizDest bizDest) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<updateDest>");
		}
		if ((bizDest.getPinyin() == null) || "".equals(bizDest.getPinyin())) {
			bizDest.setPinyin(ChineseToPinYin.getPingYin(bizDest.getDestName()));
		}
		if ((bizDest.getShortPinyin() == null) || "".equals(bizDest.getShortPinyin())) {
			bizDest.setShortPinyin(ChineseToPinYin.getPinYinHeadChar(bizDest.getDestName()));
		}

		//修改酒店目的地行政区划的时候同步更改对应酒店的行政区划
		updateProductDistrictByDest(bizDest);

		BizDest oldDest = destService.findDestDetailById(bizDest.getDestId());

		destService.updateBizDest(bizDest);

		//增加酒店目的地修改日志
		addHotelBizDestLog(bizDest, oldDest);

		//添加推送信息
		try {
			pushAdapterService.push(bizDest.getDestId(),
					ComPush.OBJECT_TYPE.DEST, ComPush.PUSH_CONTENT.BIZ_DEST,ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
		} catch (Exception e) {
			log.error("Push info failure ！Push Type:"
					+ ComPush.OBJECT_TYPE.DEST.name() + " ID:"
					+ bizDest.getDestId() + "." + e.getMessage());
		}
		return ResultMessage.UPDATE_SUCCESS_RESULT;
	}

	/**
	 * 修改酒店目的地行政区划的时候同步更改对应酒店的行政区划
	 * @param bizDest
	 */
	private void updateProductDistrictByDest(BizDest bizDest){
		BizDest oldDest = destService.findDestDetailById(bizDest.getDestId());
		if(oldDest != null && "HOTEL".equals(oldDest.getDestType())){//酒店类型的目的地
			if(!oldDest.getDistrictId().equals(bizDest.getDistrictId())){
				Long productId = prodDestReService.findHotelProductIdByDestId(oldDest.getDestId());
				if(productId != null){
					ProdProduct prodProduct = new ProdProduct();
					prodProduct.setProductId(productId);
					prodProduct.setBizDistrictId(bizDest.getDistrictId());
					prodProductService.updateProdProduct(prodProduct);
				}

				/**  查询目的地的父级目的地 **/
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("isTypeDistrict", true);
				params.put("districtId", bizDest.getDistrictId());
				List<BizDest> dests = MiscUtils.autoUnboxing( destService.findDestList(params) );
				if (CollectionUtils.isNotEmpty(dests)) {
					bizDest.setParentId(dests.get(0).getDestId());
				}
			}
		}
	}

	/**
	 * 添加酒店目的地操作日志
	 * @param newDest
	 * @param oldDest
	 */
	private void addHotelBizDestLog(BizDest newDest, BizDest oldDest){
		try {
			if(newDest != null && oldDest != null && "HOTEL".equals(oldDest.getDestType())){
				StringBuffer logStr = new StringBuffer("");
				if(newDest.getDestName() != null){
					logStr.append(ComLogUtil.getLogTxt("酒店目的地名称", newDest.getDestName(), oldDest.getDestName()));
				}
				if(newDest.getDistrictId() != null){
					logStr.append(ComLogUtil.getLogTxt("酒店目的地所属行政关系", newDest.getDistrictId().toString(), oldDest.getDistrictId().toString()));
				}
				if(newDest.getCancelFlag() != null){
					logStr.append(ComLogUtil.getLogTxt("酒店目的地有效性", newDest.getCancelFlag(), oldDest.getCancelFlag()));
				}
				comLogService.insert(ComLog.COM_LOG_OBJECT_TYPE.BIZ_DEST_HOTEL, oldDest.getDestId(), oldDest.getDestId(), this.getLoginUser().getUserName(), "修改了酒店目的地：【" + oldDest.getDestName() + "】，修改内容：" + logStr.toString(),
						ComLog.COM_LOG_LOG_TYPE.BIZ_DEST_HOTEL_UPDATE.name(), "修改酒店目的地", null);
			}
		}catch (Exception e){
			log.error("Record Log failure ！Log type:" + ComLog.COM_LOG_LOG_TYPE.BIZ_DEST_HOTEL_UPDATE.name());
			log.error(e.getMessage());
		}
	}
	

	/**
	 * 设置目的地的有效性
	 */
	@RequestMapping(value = "/modiDestFlag")
	@ResponseBody
	public Object modiDestFlag(BizDest bizDest) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<modiDestFlag>");
		}
        //查询旧目的地信息
		BizDest oldDest = destService.findDestDetailById(bizDest.getDestId());

		destService.updateBizDestFlag(bizDest);
        //增加酒店目的地修改日志
		addHotelBizDestLog(bizDest, oldDest);

		//酒店类型的目的地修改有效性的时候修改对应酒店的有效性  add by lijuntao
		BizDest dest = destService.findDestDetailById(bizDest.getDestId());
		if(dest != null && DEST_TYPE.HOTEL.getCode().equals(dest.getDestType())){
			Long productId = prodDestReService.findHotelProductIdByDestId(dest.getDestId());
			if(productId != null){
				ProdProduct prodProduct = new ProdProduct();
				prodProduct.setProductId(productId);
				prodProduct.setCancelFlag(bizDest.getCancelFlag());
				prodProductService.updateCancelFlag(prodProduct);
			}
		}

		//添加推送信息
		try {
			OPERATE_TYPE delType = ComPush.OPERATE_TYPE.INVALID;
			if("Y".equals(bizDest.getCancelFlag())) {
				delType = ComPush.OPERATE_TYPE.VALID;
			}
			
			pushAdapterService.push(bizDest.getDestId(),
					ComPush.OBJECT_TYPE.DEST, ComPush.PUSH_CONTENT.BIZ_DEST,delType, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
		} catch (Exception e) {
			log.error("Push info failure ！Push Type:"
					+ ComPush.OBJECT_TYPE.DEST.name() + " ID:"
					+ bizDest.getDestId() + "." + e.getMessage());
		}
		return ResultMessage.SET_SUCCESS_RESULT;
	}

	/**
	 * 选择目的地
	 */
	@RequestMapping(value = "/selectDestList")
	public String selectDestList(Model model, Integer page, Long parentDestId,Long pdestId, BizDest bizDest, String type, Boolean isTypePOI, String parentDestName, String districtName,String selectDestTypeList, HttpServletRequest req) throws BusinessException {
		
		Map<String, Object> parameters = new HashMap<String, Object>();
		int pagenum = page == null ? 1 : page;
		parameters.put("destId", pdestId);
		parameters.put("districtName", districtName);
		parameters.put("parentDestName", parentDestName);
    	parameters.put("destName", bizDest.getDestName());
    	parameters.put("destType", bizDest.getDestType());
    	if(isTypePOI == null){
    	    model.addAttribute("destTypeList", BizDest.DEST_TYPE.values());
        } else if (isTypePOI){
            parameters.put("isTypePOI", true);
            model.addAttribute("destTypeList", DEST_TYPE.getObjectTypes(DEST_TYPE_CATEGORY.POI.name()));
        }

        //增加用于缩小destType范围的参数
		if(StringUtils.isNotBlank(selectDestTypeList)){
			model.addAttribute("selectDestTypeList",selectDestTypeList);
			String[] destTypeStrs = StringUtils.split(selectDestTypeList,',');
			List<DEST_TYPE> destList = new ArrayList<>();
			if(destTypeStrs!=null){
				for (String destTypeStr : destTypeStrs) {
					DEST_TYPE dt = DEST_TYPE.getDestTypeByCode(destTypeStr);
					if(dt!=null){
						destList.add(dt);
					}
				}
			}
			if(destList.size()>0){
				model.addAttribute("destTypeList", destList);
			}
		}
    	
    	model.addAttribute("destId", pdestId);
    	model.addAttribute("districtName", districtName);
    	model.addAttribute("parentDestName", parentDestName);
    	model.addAttribute("destName", bizDest.getDestName());
    	model.addAttribute("destType", bizDest.getDestType());
    	model.addAttribute("isTypePOI", isTypePOI);
		parameters.put("cancelFlag", "Y");
		int count = MiscUtils.autoUnboxing( destService.findDestCount(parameters) );

		Page<BizDest> pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		parameters.put("_start", pageParam.getStartRows());
		parameters.put("_end", pageParam.getEndRows());
		parameters.put("_orderby", "DEST_ID");
		parameters.put("_order", "DESC");
		List<BizDest> list = MiscUtils.autoUnboxing( destService.findDestList(parameters) );
		destService.setParentsDestNameInfo(list, parameters);
		pageParam.setItems(list);

		model.addAttribute("pageParam", pageParam);
		
		model.addAttribute("page", pageParam.getPage().toString());
        model.addAttribute("type", type);
        //父目的会变化，不能固死获取原结构
        //model.addAttribute("parentDestId", bizDest.getParentId());
        model.addAttribute("parentDestId", parentDestId);
        
        if(bizDest.getDestId() != null){
        	model.addAttribute("oneselfDestId", bizDest.getDestId());
        	
        	 //过滤当前直系子孙及它是次父子孙
            Set<Long> filterIdList = destService.selectAllSonsByParentDestId(bizDest.getDestId());
            if(filterIdList != null && filterIdList.size() > 0){
                StringBuffer filterDestIds = new StringBuffer();
                for(Long filterId : filterIdList){
                	if(filterId.intValue() != bizDest.getDestId().intValue()){
                		filterDestIds.append(filterId.toString()).append(",");
                	}
        		}
                model.addAttribute("filterDestIds", filterDestIds.toString());
            }
        }
        
        //已有的次父目的地
        StringBuffer oldOtherParentDestIds = new StringBuffer();
        for (BizDest destItem : bizDest.getParentDestList()) {
			oldOtherParentDestIds.append(destItem.getDestId());
			oldOtherParentDestIds.append(",");
		}
        if(oldOtherParentDestIds.length()>0){
        	oldOtherParentDestIds.replace(0, oldOtherParentDestIds.length(), oldOtherParentDestIds.substring(0, oldOtherParentDestIds.lastIndexOf(",")));
        }
        model.addAttribute("oldOtherParentDestIds",oldOtherParentDestIds.toString());
		String returnUrl ="";
		if("main".equals(type)){
			returnUrl = "/biz/dest/selectDestList";
		}else{
			returnUrl = "/biz/dest/selectOtherDestList";
		}
		return returnUrl;
	}
	
	/**
	 * 根据目的地名称模糊查询列表数据
	 * @param search
	 * @param resp
	 */
	@RequestMapping(value = "/searchDestList")
	@ResponseBody
	public Object searchDestList(String search,HttpServletResponse resp){
		if (log.isDebugEnabled()) {
			log.debug("start method<searchDestList>");
		}
		List<BizDest> list = null;
		list = destService.searchDestList(search);
		JSONArray array = new JSONArray();
		if(list != null && list.size() > 0){
			for(BizDest bizDest:list){
				JSONObject obj=new JSONObject();
				obj.put("id", bizDest.getDestId());
				obj.put("text", bizDest.getDestName()+"---"+bizDest.getDistrictName());
				array.add(obj);
			}
		}
		return array;
	}
	
	/**
     * 选择目的地
     * <br/><b>用于富文本上的弹出选择</b>
     */
    @RequestMapping(value = "/showDestList")
    public String showDestList(Model model, Integer page, BizDest bizDest, HttpServletRequest req) throws BusinessException {
        
        Map<String, Object> parameters = new HashMap<String, Object>();
        parameters.put("destName", bizDest.getDestName());
        parameters.put("cancelFlag", "Y");
        int count = MiscUtils.autoUnboxing( destService.findDestCount(parameters) );
        
        int pagenum = page == null ? 1 : page;
        Page<BizDest> pageParam = Page.page(count, 10, pagenum);
        pageParam.buildUrl(req);
        
        parameters.put("_start", pageParam.getStartRows());
        parameters.put("_end", pageParam.getEndRows());
        parameters.put("_orderby", "DEST_ID");
        parameters.put("_order", "DESC");
        List<BizDest> list = MiscUtils.autoUnboxing( destService.findDestList(parameters) );
        pageParam.setItems(list);

        model.addAttribute("pageParam", pageParam);
        model.addAttribute("destTypeList", BizDest.DEST_TYPE.values());
        model.addAttribute("page", pageParam.getPage().toString());
        
        return "/biz/dest/showDestList";
    }

    @RequestMapping("/queryDestPoi")
	@ResponseBody
    public Object queryDestPoi(String destType, String search){
    	ResultMessage resultMessage = ResultMessage.createResultMessage();
		Map<String, Object> params = new HashMap<>();
		params.put("destName", search);
		if(BizDest.DEST_TYPE.CITY.name().equalsIgnoreCase(destType)){
			params.put("isTypeDistrict", true);
		}else {
			params.put("destType", destType);
		}
		params.put("cancelFlag", "Y");
		params.put("_start", 1);
		params.put("_end", 10);
		params.put("_orderby", "DEST_ID");
		params.put("_order", "ASC");
		List<BizDest> list = MiscUtils.autoUnboxing(destService.queryDestPoi(params));
		resultMessage.addObject("dataArray",list);
    	return resultMessage;
	}
    
}