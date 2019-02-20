package com.lvmama.vst.back.biz.web;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletResponse;

import com.lvmama.vst.comm.utils.web.HttpServletLocalThread;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizDict;
import com.lvmama.vst.back.biz.po.BizDictDef;
import com.lvmama.vst.back.biz.po.BizDictProp;
import com.lvmama.vst.back.biz.po.BizDictPropDef;
import com.lvmama.vst.back.client.biz.service.DictDefClientService;
import com.lvmama.vst.back.biz.service.DictPropDefService;
import com.lvmama.vst.back.client.biz.service.DictPropClientService;
import com.lvmama.vst.back.biz.service.DictService;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.prod.po.ProdProductProp;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Constant.PROPERTY_INPUT_TYPE_ENUM;
import com.lvmama.vst.comm.vo.MemcachedEnum;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.back.utils.MiscUtils;
/**
 * 可换酒店字典处理器
 * 
 * @author xiexun
 */
@Controller
@RequestMapping("/biz/changeHotel")
public class ChangedHotelAction extends BaseActionSupport {
    
    private static final Log LOG = LogFactory.getLog(ChangedHotelAction.class);

	@Autowired
	private DictService dictService;

	@Autowired
	private DictDefClientService dictDefService;
	
	@Autowired
	private DictPropClientService dictPropService;

	@Autowired
	private ComLogClientService comLogService;
	
	@Autowired
	private DictPropDefService dictPropDefService;
	
	@Autowired
	private ProdProductService prodProductService;
	

	/**
	 * 编辑可换酒店页
	 */
	@RequestMapping(value = "/showUpdateChangeHotel")
	public String showUpdateChangeHotel(Model model, Long dictId,Long branchId, String requestSource) throws BusinessException {
		BizDict bizDict = null;
		BizDictDef bizDictDef = null;

		// 跳转编辑页
		if (dictId != null) {
			bizDict = dictService.findDictById(dictId);
			bizDictDef = MiscUtils.autoUnboxing(dictDefService.findDictDefById(bizDict.getDictDefId()));
		}
		
		model.addAttribute("requestSource", requestSource);
		model.addAttribute("bizDict", bizDict);
		model.addAttribute("dictDef", bizDictDef);
		model.addAttribute("branchId", branchId);
		
		//字典属性
		Map<String, Object> parameters = new HashMap<String, Object>();
		if(bizDictDef != null){
		    parameters.put("dictDefId", bizDictDef.getDictDefId());
		}
		parameters.put("dictId", dictId);
		parameters.put("cancelFlag", "Y");
		parameters.put("update", "Y");
		parameters.put("_orderby", " SEQ ASC ");
		
		//加载字典定义属性列表
		List<BizDictPropDef> dictPropDefList = dictPropDefService.findDictPropDefList(parameters);
		model.addAttribute("addValueTitle", ProdProductProp.PROP_ADD_VALUE_SPLIT);
		model.addAttribute("dictPropDefList", dictPropDefList);
		
		return "/biz/changeHotel/showUpdateChangeHotel";
	}
	
	/**
	 * 新增可换酒店页面
	 */
	@RequestMapping(value = "/showAddChangeHotel")
	public String showAddChangeHotel(Long productId,Long branchId) throws BusinessException {
		
		BizDictDef dictDef = null;
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("cancelFlag", "Y");
		parameters.put("dictCode", "changed_hotel");
		List<BizDictDef> bizDictDefList = MiscUtils.autoUnboxing(dictDefService.findDictDefList(parameters));
		if (null != bizDictDefList && bizDictDefList.size()>0) {
			dictDef = bizDictDefList.get(0);
		}
		HttpServletLocalThread.getModel().addAttribute("dictDef", dictDef);
		HttpServletLocalThread.getModel().addAttribute("productId", productId);
		HttpServletLocalThread.getModel().addAttribute("branchId", branchId);
		if(dictDef != null){
		    parameters.put("dictDefId", dictDef.getDictDefId());
		}
		parameters.put("cancelFlag", "Y");
		parameters.put("_orderby", " SEQ ASC ");
		//加载可换酒店属性列表
		List<BizDictPropDef> dictPropDefList = dictPropDefService.findDictPropDefList(parameters);
		HttpServletLocalThread.getModel().addAttribute("addValueTitle", ProdProductProp.PROP_ADD_VALUE_SPLIT);
		HttpServletLocalThread.getModel().addAttribute("dictPropDefList", dictPropDefList);
		return "/biz/changeHotel/showAddChangeHotel";
	}

	/**
	 * @param 编辑可换酒店
	 */
	@RequestMapping(value = "/updateChangeHotel")
	@ResponseBody
	public Object updateChangeHotel(BizDict bizDict,Long branchId) throws BusinessException {
		BizDict oldDict = dictService.findDictById(bizDict.getDictId());
		if (log.isDebugEnabled()) {
			log.debug("start method<updateDict>");
		}
		dictService.updateBizDict(bizDict);
		//清空酒店字典缓存
		MemcachedUtil.getInstance().remove(MemcachedEnum.BizBranchPropList.getKey() + branchId);
		MemcachedUtil.getInstance().remove(MemcachedEnum.BizDictdefList.getKey()+bizDict.getDictDefId());
		//编辑比较业务字典更改的字典基本信息和字典属性
		String dictLog = getDictChangeLog(bizDict, oldDict);
		//添加操作日志
		try {
			if(StringUtil.isNotEmptyString(dictLog)){
				comLogService.insert(COM_LOG_OBJECT_TYPE.DICT_BUSINESS, 
						bizDict.getDictDefId(), bizDict.getDictId(), 
						this.getLoginUser().getUserName(), 
						dictLog, 
						COM_LOG_LOG_TYPE.DICT_BUSINESS_SHIP_COMPANY.name(), 
						"修改【"+ bizDict.getDictName() + "】字典",null);
			}
			
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.DICT_BUSINESS_SHIP_COMPANY.name());
			log.error(e.getMessage());
		}
		JSONObject jo = new JSONObject();
		jo.put("code", ResultMessage.UPDATE_SUCCESS_RESULT.getCode());
		jo.put("message", ResultMessage.UPDATE_SUCCESS_RESULT.getMessage());
		jo.put("hotelId", bizDict.getDictId());
		jo.put("hotelName", bizDict.getDictName());
		return jo;
	}

	/**
	 * 
	 * 新增可换酒店
	 */
	@RequestMapping(value = "/addChangeHotel")
	@ResponseBody
	public Object addChangeHotel(BizDict bizDict,Long branchId) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<addDict>");
		}
		bizDict.setCancelFlag("Y");
		Long dictId = dictService.addBizDict(bizDict);
		//清空酒店字典缓存
		MemcachedUtil.getInstance().remove(MemcachedEnum.BizBranchPropList.getKey() + branchId);
		//添加操作日志
		try {
			comLogService.insert(COM_LOG_OBJECT_TYPE.DICT_BUSINESS, 
					bizDict.getDictDefId(), bizDict.getDictId(), 
					this.getLoginUser().getUserName(), 
					"新增【" + bizDict.getDictName()+ "】字典：【" + dictId + "】", 
					COM_LOG_LOG_TYPE.DICT_BUSINESS_SHIP_COMPANY.name(), 
					"新增【" + bizDict.getDictName()+ "】字典：【" + dictId + "】",null);
		} catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.DICT_BUSINESS_SHIP_COMPANY.name());
			log.error(e.getMessage());
		}
		JSONObject jo = new JSONObject();
		jo.put("code", ResultMessage.ADD_SUCCESS_RESULT.getCode());
		jo.put("message", ResultMessage.ADD_SUCCESS_RESULT.getMessage());
		jo.put("hotelId", dictId);
		jo.put("hotelName", bizDict.getDictName());
		return jo;
	}
	
	/**
	 * 根据行政区划名称酒店名称模糊查询列表数据
	 * @param search
	 * @param resp
	 */
	@RequestMapping(value = "/searchChangeHotelList")
	@ResponseBody
	public Object searchChangeHotelList(String search,String districtName,HttpServletResponse resp){
		if (log.isDebugEnabled()) {
			log.debug("start method<searchChangeHotelList>");
		}
		List<BizDict> list = null;
		JSONArray array = new JSONArray();
		try {
			Map<String, String> param = new HashMap<String, String>();
			param.put("search", search);
			districtName = java.net.URLDecoder.decode(districtName,"UTF-8"); 
			param.put("districtName", districtName);
			list = dictService.searchDictList(param);
			
			if(list != null && list.size() > 0){
				for(BizDict bizDict:list){
					JSONObject obj=new JSONObject();
					obj.put("id", bizDict.getDictId());
					obj.put("text", bizDict.getDictName());
					array.add(obj);
				}
			}
			
		} catch (UnsupportedEncodingException e) {
		    LOG.error(e.getMessage());
		}return array;
	}
	
	/**
	 * 根据酒店字典ID查询酒店属性列表数据
	 * @param dictId
	 * @param resp
	 */
	@RequestMapping(value = "/searchChangeHotelPropList")
	@ResponseBody
	public Object searchChangeHotelPropList(Long dictId,HttpServletResponse resp){
		if (log.isDebugEnabled()) {
			log.debug("start method<searchChangeHotelList>");
		}
		List<BizDictProp> list = null;
		JSONArray array = new JSONArray();
		if (null != dictId) {
			try {
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("dictId", dictId);
				long count = MiscUtils.autoUnboxing(dictPropService.queryDictPropTotalCount(param));
				Page pageParam = Page.page(count, 1000, 1);
				param.put("_start", pageParam.getStartRows());
				param.put("_end", pageParam.getEndRows());
				param.put("_orderby", "DICT_PROP_DEF_ID");
				param.put("_order", "ASC");
				list = MiscUtils.autoUnboxing(dictPropService.findDictPropList(param));
				array = JSONArray.fromObject(list);
			} catch (Exception e) {
			    LOG.error(e.getMessage());
			}
		}
		return array;
	}
	

	/**
	 * 编辑业务字典时 比较新旧字典基本信息和字典属性区别
	 */
	private String getDictChangeLog(BizDict newDict, BizDict oldDict) {
		StringBuilder log = new StringBuilder();

		if (newDict != null) {
			// 基本信息
			log.append(ComLogUtil.getLogTxt("字典名词", newDict.getDictName(),
					oldDict.getDictName()));
			log.append(ComLogUtil.getLogTxt("是否有效", newDict.getCancelFlag(),
					oldDict.getCancelFlag()));
			log.append(ComLogUtil.getLogTxt("是否可补充", newDict.getAddFlag(),
					oldDict.getAddFlag()));

			// 字典属性
			if (!newDict.getDictPropList().equals(oldDict.getDictPropList())) {
				Map<Long, BizDictProp> oldBizDictPropMap = new HashMap<Long, BizDictProp>();
				Map<Long, BizDictProp> newBizDictPropMap = new HashMap<Long, BizDictProp>();
				Map<Long, Map<String, String>> diffDictPropMap = new HashMap<Long, Map<String, String>>();

				ComLogUtil.setBizDictProp2Map(newDict.getDictPropList(),
						newBizDictPropMap);
				ComLogUtil.setBizDictProp2Map(oldDict.getDictPropList(),
						oldBizDictPropMap);
				ComLogUtil.diffBizDictPropMap(oldBizDictPropMap,
						newBizDictPropMap, diffDictPropMap);

				Map<String, Object> dictDefPropMap = new HashMap<String, Object>();
				dictDefPropMap.put("dictDefId", newDict.getDictDefId());
				List<BizDictPropDef> dictDefPropList = dictPropDefService
						.findDictPropDefList(dictDefPropMap);
				Map<Long, BizDictPropDef> dictPropDefMap = new HashMap<Long, BizDictPropDef>();
				for (BizDictPropDef dictPropDef : dictDefPropList) {
					dictPropDefMap.put(dictPropDef.getDictPropDefId(),
							dictPropDef);
				}

				Iterator itor = diffDictPropMap.entrySet().iterator();
				while (itor.hasNext()) {
					Map.Entry entry = (Entry) itor.next();
					Long key = (Long) entry.getKey();
					Map<String, String> values = (Map<String, String>) entry
							.getValue();

					String dictPropDefName = dictPropDefMap.get(key)
							.getDictPropDefName();

					if (PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_YESNO.name()
							.equals(dictPropDefMap.get(key).getInputType())) {
						String oldValue = ("Y".equals(values.get("oldValue")) ? "是"
								: "否");
						String newValue = ("Y".equals(values.get("newvalue")) ? "是"
								: "否");
						log.append(ComLogUtil.getLogTxt(dictPropDefName,
								newValue, oldValue));
					} else if (PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_CHECKBOX
							.name().equals(
									dictPropDefMap.get(key).getInputType())) {
						String newValue = values.get("newValue");
						String[] dictIdArray = newValue.split(",");
						if (dictIdArray.length != 0) {
							newValue = prodProductService
									.getDictCnValue(dictIdArray);
						} else {
							newValue = "";
						}
						log.append(ComLogUtil.getLogTxt(dictPropDefName,
								newValue, null));
					} else if (PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_SELECT
							.name().equals(
									dictPropDefMap.get(key).getInputType())) {
						String newValue = values.get("newValue");
						String[] dictIdArray = newValue.split(",");
						String oldValue = values.get("oldValue");
						String[] dictIdArray2 = oldValue.split(",");
						if (dictIdArray.length != 0) {
							newValue = prodProductService
									.getDictCnValue(dictIdArray);
						} else {
							newValue = "";
						}
						if (dictIdArray2.length != 0) {
							oldValue = prodProductService
									.getDictCnValue(dictIdArray2);
						} else {
							oldValue = "";
						}
						log.append(ComLogUtil.getLogTxt(dictPropDefName,
								newValue, oldValue));
					} else if (PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_TEXTAREA
							.name().equals(
									dictPropDefMap.get(key).getInputType())
							|| PROPERTY_INPUT_TYPE_ENUM.INPUT_TYPE_RICH.name()
									.equals(dictPropDefMap.get(key)
											.getInputType())) {
						String oldValue = values.get("oldValue");
						String newValue = values.get("newValue");
						if (null != newValue && !newValue.equals(oldValue)) {
							log.append(ComLogUtil.getLogTxt(dictPropDefName,
									newValue, oldValue));
						} else {
							log.append(ComLogUtil.getLogTxt(dictPropDefName,
									null, oldValue));
						}
					} else {
						log.append(ComLogUtil.getLogTxt(dictPropDefName,
								values.get("newValue"), values.get("oldValue")));
					}
				}

			}

		}

		return log.toString();
	}

}