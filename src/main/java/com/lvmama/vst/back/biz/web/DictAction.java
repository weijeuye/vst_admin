package com.lvmama.vst.back.biz.web;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;

import com.lvmama.vst.comm.utils.web.HttpServletLocalThread;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.biz.po.BizDict;
import com.lvmama.vst.back.biz.po.BizDictDef;
import com.lvmama.vst.back.biz.po.BizDictExtend;
import com.lvmama.vst.back.biz.po.BizDictProp;
import com.lvmama.vst.back.biz.po.BizDictPropDef;
import com.lvmama.vst.back.biz.service.DictService;
import com.lvmama.vst.back.client.biz.service.DictDefClientService;
import com.lvmama.vst.back.client.prod.service.ProdProductClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.prod.po.ProdProductProp;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.pub.po.ComIncreament;
import com.lvmama.vst.back.pub.po.ComPush;
import com.lvmama.vst.back.pub.service.PushAdapterServiceRemote;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.ComLogUtil;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Constant.PROPERTY_INPUT_TYPE_ENUM;
import com.lvmama.vst.comm.vo.MemcachedEnum;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

/**
 * 字典处理器
 * 
 * @author yuzhizeng
 */
@Controller
@RequestMapping("/biz/dict")
public class DictAction extends BaseActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -897631042644000380L;

	@Autowired
	private DictService dictService;

	@Autowired
	private DictDefClientService dictDefService;

	@Autowired
	private ComLogClientService comLogService;
	
	@Autowired
	private ProdProductClientService prodProductService;
	@Autowired
	PushAdapterServiceRemote pushAdapterService;
	
	@RequestMapping(value = "/findDictList")
	public String findDictList(Model model, Integer page, String dictName, String dictDefName, String cancelFlag, Long dictDefId, String dictType, HttpServletRequest req)
			throws BusinessException {

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("dictName", dictName);
		parameters.put("dictDefId", dictDefId);
		parameters.put("dictDefName", dictDefName);
		parameters.put("cancelFlag", cancelFlag);
		parameters.put("dictType", dictType);
		parameters.put("_orderby", "DICT_DEF_ID DESC , DICT_ID DESC");
		int count = dictService.queryBizDictExtendTotalCount(parameters);

		// 分页
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		parameters.put("_start", pageParam.getStartRows());
		parameters.put("_end", pageParam.getEndRows());
		List<BizDictExtend> list = dictService.findBizDictExtendList(parameters);

		// 页面赋值
		pageParam.setItems(list);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("dictName", dictName);
		model.addAttribute("cancelFlag", cancelFlag);
		model.addAttribute("dictDefId", dictDefId);
		model.addAttribute("dictDefName", dictDefName);
		model.addAttribute("dictType", dictType);
		model.addAttribute("page", pageParam.getPage().toString());

		return "/biz/dict/findDictList";
	}
	
	/**
	 * 通过业务定义Id查询业务字典列表
	 * @return
	 * @throws BusinessException
	 * "requestSource" : "productSelect",
			"dictDefId" : dataFrom,
			"cancelFlag" : "Y",
			"propId" : propId
	 */
	@RequestMapping(value = "/findSelectDictList")
	public String findSelectDictList(Model model, Integer page, String dictName, Long dictDefId, Long propId, HttpServletRequest req)throws BusinessException{
		model.addAttribute("dictDefId", dictDefId);
		model.addAttribute("dictName", dictName);
		
		if(page == null && dictName == null) {
			return "/biz/dict/findSelectDictList";
		}
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("dictDefId", dictDefId);
		parameters.put("cancelFlag", "Y");
		parameters.put("dictName", dictName);
		parameters.put("_orderby", "DICT_DEF_ID DESC , DICT_ID DESC");
		int count = dictService.queryBizDictExtendTotalCount(parameters);

		// 分页
		int pagenum = page == null ? 1 : page;
		Page pageParam = Page.page(count, 10, pagenum);
		pageParam.buildUrl(req);
		parameters.put("_start", pageParam.getStartRows());
		parameters.put("_end", pageParam.getEndRows());
		List<BizDictExtend> list = dictService.findBizDictExtendList(parameters);

		// 页面赋值
		pageParam.setItems(list);
		model.addAttribute("pageParam", pageParam);
		model.addAttribute("page", pageParam.getPage().toString());
		
		return "/biz/dict/findSelectDictList";
		
	}

	/**
	 * 编辑页跳转
	 */
	@RequestMapping(value = "/showUpdateDict")
	public String showUpdateDict(Model model, Long dictId, String requestSource,String dictCode) throws BusinessException {
		BizDict bizDict = null;
		BizDictDef bizDictDef = null;

		// 跳转编辑页
		if (dictId != null) {
			bizDict = dictService.findDictById(dictId);
			bizDictDef = MiscUtils.autoUnboxing( dictDefService.findDictDefById(bizDict.getDictDefId()) );
		}
		
		model.addAttribute("requestSource", requestSource);
		model.addAttribute("bizDict", bizDict);
		model.addAttribute("dictDef", bizDictDef);
		
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
		List<BizDictPropDef> dictPropDefList = MiscUtils.autoUnboxing( dictDefService.findDictDefPropList(parameters) );
		model.addAttribute("addValueTitle", ProdProductProp.PROP_ADD_VALUE_SPLIT);
		model.addAttribute("dictPropDefList", dictPropDefList);
		if(bizDictDef != null){
		    model.addAttribute("dictCode",bizDictDef.getDictCode());
		}
		
		return "/biz/dict/showUpdateDict";
	}
	
	/**
	 * 新增页跳转
	 */
	@RequestMapping(value = "/showAddDict")
	public String showAddDict(Long dictDefId,String dictCode) throws BusinessException {
		
		BizDictDef dictDef = null;
		//来自从test/index.do的新增字典请求
		if(dictDefId != null){
			dictDef = MiscUtils.autoUnboxing( dictDefService.findDictDefById(dictDefId) );
		}
		HttpServletLocalThread.getModel().addAttribute("dictDef", dictDef);
		
		//邮轮公司
		Map<String, Object> parameters = new HashMap<String, Object>();
		if(dictDef != null){
		    parameters.put("dictDefId", dictDef.getDictDefId());
		}
		parameters.put("cancelFlag", "Y");
		parameters.put("_orderby", " SEQ ASC ");
		
		//加载字典定义属性列表
		List<BizDictPropDef> dictPropDefList = MiscUtils.autoUnboxing(  dictDefService.findDictDefPropList(parameters) );
		HttpServletLocalThread.getModel().addAttribute("addValueTitle", ProdProductProp.PROP_ADD_VALUE_SPLIT);
		HttpServletLocalThread.getModel().addAttribute("dictPropDefList", dictPropDefList);
		HttpServletLocalThread.getModel().addAttribute("dictCode",dictCode);
		
		return "/biz/dict/showAddDict";
	}

	/**
	 * @param 编辑业务字典
	 */
	@RequestMapping(value = "/updateDict")
	@ResponseBody
	public Object updateDict(BizDict bizDict) throws BusinessException {
		
		BizDict oldDict = dictService.findDictById(bizDict.getDictId());
		
		if (log.isDebugEnabled()) {
			log.debug("start method<updateDict>");
		}
		
		dictService.updateBizDict(bizDict);
		
		//编辑比较业务字典更改的字典基本信息和字典属性
		String dictLog = getDictChangeLog(bizDict, oldDict);
		
		//添加操作日志
		try {
			pushAdapterService.push(bizDict.getDictDefId(), ComPush.OBJECT_TYPE.DICT, ComPush.PUSH_CONTENT.BIZ_DICT,ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
			if(StringUtil.isNotEmptyString(dictLog)){
				comLogService.insert(COM_LOG_OBJECT_TYPE.DICT_BUSINESS, 
						bizDict.getDictDefId(), bizDict.getDictId(), 
						this.getLoginUser().getUserName(), 
						dictLog, 
						bizDict.getComLogType().name(), 
						"修改【"+ bizDict.getDictName() + "】字典",null);
			}
			
		} catch (Exception e) {
			log.error(e.getMessage());
		}
		
		return ResultMessage.UPDATE_SUCCESS_RESULT;
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
				List<BizDictPropDef> dictDefPropList = MiscUtils.autoUnboxing( dictDefService
						.findDictDefPropList(dictDefPropMap) );
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
							newValue = MiscUtils.autoUnboxing( prodProductService
									.getDictCnValue(dictIdArray) );
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
							newValue = MiscUtils.autoUnboxing( prodProductService
									.getDictCnValue(dictIdArray) );
						} else {
							newValue = "";
						}
						if (dictIdArray2.length != 0) {
							oldValue = MiscUtils.autoUnboxing( prodProductService
									.getDictCnValue(dictIdArray2) );
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
	@RequestMapping(value = "/removeCache")
	@ResponseBody
	public Object removeCache() throws BusinessException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("cancelFlag", "Y");
		List<BizDictDef> list = MiscUtils.autoUnboxing( dictDefService.findDictDefList(param ) );
		if(list != null) {
			for(BizDictDef def: list) {
				MemcachedUtil.getInstance().remove(MemcachedEnum.BizDictdefList.getKey()+def.getDictDefId());
			}
		}
		return "Success";
	}
	
	/**
	 * 
	 * 新增业务字典和自定定义属性值
	 */
	@RequestMapping(value = "/addDict")
	@ResponseBody
	public Object addDict(BizDict bizDict) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<addDict>");
		}

		Long dictId = dictService.addBizDict(bizDict);
		
		//添加操作日志
		try {
			pushAdapterService.push(bizDict.getDictDefId(), ComPush.OBJECT_TYPE.DICT, ComPush.PUSH_CONTENT.BIZ_DICT,ComPush.OPERATE_TYPE.ADD, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
			
			comLogService.insert(COM_LOG_OBJECT_TYPE.DICT_BUSINESS, 
					bizDict.getDictDefId(), bizDict.getDictId(), 
					this.getLoginUser().getUserName(), 
					"新增【" + bizDict.getDictName()+ "】字典：【" + dictId + "】", 
					bizDict.getComLogType().name(), 
					"新增【" + bizDict.getDictName()+ "】字典：【" + dictId + "】",null);
		} catch (Exception e) {
			log.error(e.getMessage());
		}
		
		return ResultMessage.ADD_SUCCESS_RESULT;
	}
	
	@RequestMapping(value = "/editDictFlag")
	@ResponseBody
	public Object editDictFlag(Long dictId, String cancelFlag) throws BusinessException {
		if (log.isDebugEnabled()) {
			log.debug("start method<editDictFlag>");
		}

		dictService.editFlag(dictId, cancelFlag);
		//添加操作日志
		try {
			BizDict bizDict = this.dictService.findDictById(dictId);
			String log = "";
			if("Y".equalsIgnoreCase(cancelFlag)){
				log="有效";
			}else if("N".equalsIgnoreCase(cancelFlag)){
				log="无效";
			}
			pushAdapterService.push(bizDict.getDictDefId(), ComPush.OBJECT_TYPE.DICT, ComPush.PUSH_CONTENT.BIZ_DICT,ComPush.OPERATE_TYPE.UP, ComIncreament.DATA_SOURCE_TYPE.BUSNINESS_DATA);
			comLogService.insert(COM_LOG_OBJECT_TYPE.DICT_BUSINESS, 
					bizDict.getDictDefId(), bizDict.getDictId(), 
					this.getLoginUser().getUserName(), 
					"修改了状态为["+log+ "]", 
					bizDict.getComLogType().name(), 
					"修改有效状态",null);
		} catch (Exception e) {
			log.error(e.getMessage());
		}
		return ResultMessage.SET_SUCCESS_RESULT;
	}
}