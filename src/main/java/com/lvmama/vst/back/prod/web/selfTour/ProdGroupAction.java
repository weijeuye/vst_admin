package com.lvmama.vst.back.prod.web.selfTour;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.Assert;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.vst.back.client.biz.service.DestClientService;
import com.lvmama.vst.back.client.prod.service.ProdLineRouteClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.goods.vo.ProdProductParam;
import com.lvmama.vst.back.prod.po.GroupRouteStayInfoVO;
import com.lvmama.vst.back.prod.po.GroupRouteVO;
import com.lvmama.vst.back.prod.po.LittleProdProduct;
import com.lvmama.vst.back.prod.po.ProdDestRe;
import com.lvmama.vst.back.prod.po.ProdGroup;
import com.lvmama.vst.back.prod.po.ProdLineRoute;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProductGroupVO;
import com.lvmama.vst.back.prod.service.ProdGroupService;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.utils.TimeLog;
import com.lvmama.vst.comm.enumeration.CommEnumSet;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.Constant.VST_CATEGORY;
import com.lvmama.vst.comm.vo.MemcachedEnum;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;

/**
 * 产品关联组
 * @author luwei
 * @date 2015-08-18
 */
@Controller
@RequestMapping("/selfTour/prodGroup")
public class ProdGroupAction extends BaseActionSupport{
	private static final long serialVersionUID = -3157513300262758586L;
	private static final Log LOG = LogFactory.getLog(ProdGroupAction.class);
	/**
	 * 最多关联产品的大小
	 */
	private static final String PROD_GROUP_MAX_SIZE ="prodGroupMaxSize";
	private static final String PROD_GROUP_MESSAGE_UPDATE ="关联数据已更新,请刷新页面";
	private static final String PROD_GROUP_MESSAGE_EXISTS ="维护产品已被其它产品进行关联,请先取消";
	@Autowired
	private ProdGroupService prodGroupService;
	@Autowired
	private ComLogClientService comLogService;
	@Autowired
	private ProdLineRouteClientService 	prodLineRouteService;
	@Autowired
	ProdProductService prodProductService;
	@Autowired
	private PermUserServiceAdapter permUserServiceAdapter;
	@Autowired
	DestClientService destClientService;
	/**
	 * 产品关联
	 */
	@RequestMapping(value = "/findProdGroupList")
	public String findProdGroupList(Model model ,Long prodProductId, Long categoryId){
		LOG.info("ProdGroupAction.findProdGroupList start...");
		//是否能选择关联产品
		boolean isProductSelect =true;
		String errorMsg ="";
		try{
			TimeLog timeLog = new TimeLog(LOG);
			List<ProdGroup> prodGroupList = prodGroupService.selectByProductId(prodProductId, true);
			timeLog.logWrite("findProdGroupList.selectByProductId()", "size="+ prodGroupList.size());
			
			int maxSize =getProdGroupMaxSize();
			
			
			if(prodGroupList.size() >0 && prodGroupList.size() <maxSize){
				if(!isEqual(prodGroupList.get(0).getGroupId(), prodProductId)){
					isProductSelect =false;
					errorMsg =PROD_GROUP_MESSAGE_EXISTS;
				}
			}else if(prodGroupList.size() >= maxSize){
				errorMsg ="最多关联产品数目为" +maxSize;
				isProductSelect =false;
			}
			model.addAttribute("maxSize", maxSize -prodGroupList.size());
			model.addAttribute("prodProductId", prodProductId);
			model.addAttribute("categoryId", categoryId);
			model.addAttribute("prodGroupList", prodGroupList);
		}catch(Exception e){
			isProductSelect =false;
			errorMsg =e.getMessage();
			LOG.error(ExceptionFormatUtil.getTrace(e));
		}
		model.addAttribute("isProductSelect", isProductSelect);
		model.addAttribute("errorMsg", errorMsg);
		return "/prod/selfTour/product/findProdGroupList";
	}

	/**
	 * 加载关联产品数据
	 */
	@RequestMapping(value = "/selectReProductListRelated")
	public String selectReProductListForRelated(Model model,Integer page ,Long prodProductId ,HttpServletRequest req){
		LOG.info("ProdGroupAction.selectReProductList start...");
		Map<String, Object> params = new HashMap<String, Object>();
		try{
			
			params.put("prodProductId", prodProductId);
			ProdProduct product=prodProductService.findProdProductByProductId(prodProductId);
//			if(product.getProdLineRouteList().size()>1){
//				
//				model.addAttribute("line","1");
//				return "/prod/selfTour/product/selectReProductListForRelate";
//			}
			if(product!=null&&product.getBizDistrictId()!=null){
				params.put("bizDistrictId", product.getBizDistrictId());
				List<Long> ids=new ArrayList<Long>();
				for (ProdDestRe element : product.getProdDestReList()) {
					ids.add(element.getDestId());
				}
				//需修改
				params.put("prodDestReList", ids);
				
			}
			//加载参数
			loadParams(params, req, false);
			TimeLog timeLog = new TimeLog(LOG);
			params.put("bu", CommEnumSet.BU_NAME.LOCAL_BU.getCode());
			params.put("category", product.getBizCategoryId());
			params.put("abandonFlag", "N");
			//总数
			Long ct =prodGroupService.selectCountReProductByMapRelated(params);
			timeLog.logWrite("selectReProductList.selectCountReProductByMap()", "count="+ ct);
			int count =0;
			Page<ProdProduct> pageParam =null;
			if(ct != null){
				count =ct.intValue();
				int pagenum = page == null ? 1 : page;
				pageParam = Page.page(count, 10, pagenum);
				pageParam.buildUrl(req);
				params.put("_start", pageParam.getStartRows());
				params.put("_end", pageParam.getEndRows());
				
				//分页数据
				timeLog.afreshMillis();
				List<ProdProduct> prodProductList =prodGroupService.selectReProductByMapRelated(params);
				for (ProdProduct prodProduct : prodProductList) {
//					if(prodProduct.getProdLineRouteList().size()>1){
//						model.addAttribute("line","1");
//						return "/prod/selfTour/product/selectReProductListForRelate";
//					}
					if(StringUtil.isNotEmptyString(prodProduct.getToTraffic())){
						prodProduct.setToTraffic(Constant.LINE_TRAFFIC.getCnName(prodProduct.getToTraffic()));
					}
					if(StringUtil.isNotEmptyString(prodProduct.getBackTraffic())){
						prodProduct.setBackTraffic(Constant.LINE_TRAFFIC.getCnName(prodProduct.getBackTraffic()));
					}
					PermUser permUser = permUserServiceAdapter.getPermUserByUserId(prodProduct.getManagerId());
					prodProduct.setManagerName(permUser.getRealName());
				}
				timeLog.logWrite("selectReProductList.selectReProductByMap()", "size="+ prodProductList.size());
				pageParam.setItems(prodProductList);
			}
			model.addAttribute("pageParam", pageParam);
			model.addAttribute("prodProductId", prodProductId);
		}catch(Exception e){
			LOG.error(ExceptionFormatUtil.getTrace(e));
		
		}
		return "/prod/selfTour/product/selectReProductListForRelate";
	}
	
	/**
	 * 关联产品查询页面
	 */
	@RequestMapping(value = "/showSelectReProductList")
	public String showSelectReProductList(Model model,Long prodProductId, Long categoryId){
		model.addAttribute("prodProductId", prodProductId);
		model.addAttribute("categoryId", categoryId);
		return "/prod/selfTour/product/showSelectReProductList";
	}
	
	
	
	/**
	 * 加载关联产品数据
	 */
	@RequestMapping(value = "/selectReProductList")
	public String selectReProductList(Model model,Integer page ,Long prodProductId ,HttpServletRequest req){
		LOG.info("ProdGroupAction.selectReProductList start...");
		Map<String, Object> params = new HashMap<String, Object>();
		try{
			params.put("prodProductId", prodProductId);
			//加载参数
			loadParams(params, req, true);
			TimeLog timeLog = new TimeLog(LOG);
			//总数
			Long ct =prodGroupService.selectCountReProductByMap(params);
			timeLog.logWrite("selectReProductList.selectCountReProductByMap()", "count="+ ct);
			int count =0;
			Page<ProdProduct> pageParam =null;
			if(ct != null){
				count =ct.intValue();
				int pagenum = page == null ? 1 : page;
				pageParam = Page.page(count, 10, pagenum);
				pageParam.buildUrl(req);
				params.put("_start", pageParam.getStartRows());
				params.put("_end", pageParam.getEndRows());
				
				//分页数据
				timeLog.afreshMillis();
				List<ProdProduct> prodProductList =prodGroupService.selectReProductByMap(params);
				timeLog.logWrite("selectReProductList.selectReProductByMap()", "size="+ prodProductList.size());
				pageParam.setItems(prodProductList);
			}
			model.addAttribute("pageParam", pageParam);
			model.addAttribute("prodProductId", prodProductId);
		}catch(Exception e){
			LOG.error(ExceptionFormatUtil.getTrace(e));
		}
		return "/prod/selfTour/product/selectReProductList";
	}
	
	/**
	 * 添加关联
	 */
	@RequestMapping(value = "/saveProdGroupByRelate")
	@ResponseBody
	public ResultMessage saveProdGroupByRelate(Model model , HttpServletRequest req,Long prodProductId
			, Long categoryId, String dataArray, Integer seq){
		LOG.info("ProdGroupAction.saveProdGroupByRelate start...");
		
		try{
			TimeLog timeLog = new TimeLog(LOG);
			JSONArray jsonArray =validate(dataArray);
			//关联产品集合
			List<ProdGroup> batchList =new ArrayList<ProdGroup>();
	//		List<ProdGroup> list =validate(prodProductId, jsonArray);//获取关联产品
			List<ProdGroup> list =validate2(prodProductId,dataArray);
			Long groupId =0L;
			if(CollectionUtils.isEmpty(list)){
				//初始化添加该产品
				batchList.add(productToProdGroup(prodProductId, categoryId, seq));
				groupId =prodProductId;
			}else{
				groupId =list.get(0).getGroupId();
			}
			//写入日志
			logInfo(timeLog, prodProductId, groupId, "dataArray", dataArray);
			timeLog.logWrite("saveProdGroup.validate()", null);
			
			//添加关联产品集合
			timeLog.clear();
			ProdGroup prodGroup =null;
			for(int i =0; i<jsonArray.size(); i++){
				prodGroup =jsonToProdGroup(groupId, seq, jsonArray.getJSONObject(i));
				batchList.add(prodGroup);
				timeLog.append(" ").append(prodGroup.getProductId().toString());
			}
			StringBuilder logIds = new StringBuilder("[groupId=").append(groupId)
					.append(",productIds=").append(timeLog.getBulder());
			logIds.append("]");
			
			timeLog.afreshMillis();
			int result =prodGroupService.batchInsert(batchList);
			insertMembercacheGroupInfo(prodProductId,groupId);
			
			timeLog.logWrite("saveProdGroup.batchInsert()", result);
			//插入日志
			comLog(prodProductId, logIds, "添加关联");
			
			return new ResultMessage(ResultMessage.SUCCESS, "添加关联成功");
		}catch(Exception e){
			LOG.error(ExceptionFormatUtil.getTrace(e));
			return new ResultMessage(ResultMessage.ERROR, e.getMessage());
		}
	}

	
	/**
	 * 取消关联
	 */
	@RequestMapping(value = "/deleteProdGroupByRelate")
	@ResponseBody
	public ResultMessage deleteProdGroupByRelate(Model model ,HttpServletRequest request,
			Long prodProductId,Long productId,Long groupId){
		LOG.info("ProdGroupAction.deleteProdGroupByRelate start...");
		try{
			TimeLog timeLog = new TimeLog(LOG);
			//写入日志
			logInfo(timeLog, prodProductId, groupId,"productId", productId);
			List<ProdGroup> list =validate(prodProductId, groupId, productId);
			timeLog.logWrite("deleteProdGroup.validate()", null);
			
			//取消关联
			ProdGroup prodGroup =new ProdGroup();
			prodGroup.setGroupId(groupId);
			if(list.size() >1){
				prodGroup.setProductId(isEqual(productId, groupId)?prodProductId:productId);
			}
			timeLog.afreshMillis();
			int result =prodGroupService.deleteByProdGroup(prodGroup);
			timeLog.logWrite("deleteProdGroup.deleteByProdGroup()", result);
			//加入缓存
			//insertMembercacheGroupInfo(prodProductId,groupId);
			try{
				if(MemcachedUtil.getInstance().keyExists(MemcachedEnum.ProductIdForGroupId.getKey()+prodProductId)){
					MemcachedUtil.getInstance().remove(MemcachedEnum.ProductIdForGroupId.getKey()+prodProductId);
				}
				if(MemcachedUtil.getInstance().keyExists(MemcachedEnum.GroupIdForRouteProductsList.getKey()+groupId)){
					MemcachedUtil.getInstance().remove(MemcachedEnum.GroupIdForRouteProductsList.getKey()+groupId);
				}
			}catch(Exception e){
				LOG.error(ExceptionFormatUtil.getTrace(e));
			}
			insertMembercacheGroupInfo(prodProductId,groupId);
			//插入日志
			StringBuilder logIds = new StringBuilder("[groupId=").append(prodGroup.getGroupId());
			logIds.append(",productId=").append(prodGroup.getProductId()).append("]");
			comLog(prodProductId, logIds, "取消关联");
			
			return new ResultMessage(ResultMessage.SUCCESS, "取消关联成功");
		}catch(Exception e){
			LOG.error(ExceptionFormatUtil.getTrace(e));
			return new ResultMessage(ResultMessage.ERROR, e.getMessage());
		}
		
	}

	private void insertMembercacheGroupInfo(Long prodProductId,Long groupId) {
		Map<String, Object> params=new HashMap<String, Object>();
		params.put("productId", prodProductId);
		GroupRouteVO groupRouteVO=prodGroupService.queryGroupRouteStayInfoVOList(params);
		if(groupRouteVO!=null&&groupRouteVO.getGroupRouteStayInfoVO()!=null&&groupRouteVO.getGroupRouteStayInfoVO().size()>0){
			for (GroupRouteStayInfoVO groupRouteStayInfoVO : groupRouteVO.getGroupRouteStayInfoVO()) {
				for (ProdGroup ProdGroup : groupRouteStayInfoVO.getProdGroupList()) {
					if(StringUtil.isNotEmptyString(ProdGroup.getToTraffic())){
						ProdGroup.setToTraffic(Constant.LINE_TRAFFIC.getCnName(ProdGroup.getToTraffic()));
					}
					if(StringUtil.isNotEmptyString(ProdGroup.getBackTraffic())){
						ProdGroup.setBackTraffic(Constant.LINE_TRAFFIC.getCnName(ProdGroup.getBackTraffic()));
					}
					ProductGroupVO pgv=new ProductGroupVO();
					pgv.setGroupId(groupRouteVO.getProGroupAllId());
					pgv.setProductId(ProdGroup.getProdProduct().getProductId());
					MemcachedUtil.getInstance().set(MemcachedEnum.ProductIdForGroupId.getKey()+ProdGroup.getProdProduct().getProductId(), MemcachedEnum.ProductIdForGroupId.getSec(), pgv);
				}
			}
			//结果集放入缓存
			MemcachedUtil.getInstance().set(MemcachedEnum.GroupIdForRouteProductsList.getKey()+groupRouteVO.getProGroupAllId(), MemcachedEnum.GroupIdForRouteProductsList.getSec(), groupRouteVO);
		}else{
			try{
			if(MemcachedUtil.getInstance().keyExists(MemcachedEnum.ProductIdForGroupId.getKey()+prodProductId)){
				MemcachedUtil.getInstance().remove(MemcachedEnum.ProductIdForGroupId.getKey()+prodProductId);
			}
			if(MemcachedUtil.getInstance().keyExists(MemcachedEnum.GroupIdForRouteProductsList.getKey()+groupId)){
				MemcachedUtil.getInstance().remove(MemcachedEnum.GroupIdForRouteProductsList.getKey()+groupId);
			}
			}catch(Exception e){
				LOG.error(ExceptionFormatUtil.getTrace(e));
			}
		}
	}
	
	/**
	 * 添加关联
	 */
	@RequestMapping(value = "/saveProdGroup")
	@ResponseBody
	public ResultMessage saveProdGroup(Model model , HttpServletRequest req,Long prodProductId
			, Long categoryId, String dataArray, Integer seq){
		LOG.info("ProdGroupAction.saveProdGroup start...");
		try{
			TimeLog timeLog = new TimeLog(LOG);
			JSONArray jsonArray =validate(dataArray);
			//关联产品集合
			List<ProdGroup> batchList =new ArrayList<ProdGroup>();
			List<ProdGroup> list =validate(prodProductId, jsonArray);//获取关联产品
			Long groupId =0L;
			if(CollectionUtils.isEmpty(list)){
				//初始化添加该产品
				batchList.add(productToProdGroup(prodProductId, categoryId, seq));
				groupId =prodProductId;
			}else{
				groupId =list.get(0).getGroupId();
			}
			//写入日志
			logInfo(timeLog, prodProductId, groupId, "dataArray", dataArray);
			timeLog.logWrite("saveProdGroup.validate()", null);
			
			//添加关联产品集合
			timeLog.clear();
			ProdGroup prodGroup =null;
			for(int i =0; i<jsonArray.size(); i++){
				prodGroup =jsonToProdGroup(groupId, seq, jsonArray.getJSONObject(i));
				batchList.add(prodGroup);
				timeLog.append(" ").append(prodGroup.getProductId().toString());
			}
			StringBuilder logIds = new StringBuilder("[groupId=").append(groupId)
					.append(",productIds=").append(timeLog.getBulder());
			logIds.append("]");
			
			timeLog.afreshMillis();
			int result =prodGroupService.batchInsert(batchList);
			timeLog.logWrite("saveProdGroup.batchInsert()", result);
			
			//插入日志
			comLog(prodProductId, logIds, "添加关联");
			
			return new ResultMessage(ResultMessage.SUCCESS, "添加关联成功");
		}catch(Exception e){
			LOG.error(ExceptionFormatUtil.getTrace(e));
			return new ResultMessage(ResultMessage.ERROR, e.getMessage());
		}
	}
	
	/**
	 * 取消关联
	 */
	@RequestMapping(value = "/deleteProdGroup")
	@ResponseBody
	public ResultMessage deleteProdGroup(Model model ,HttpServletRequest request,
			Long prodProductId,Long productId,Long groupId){
		LOG.info("ProdGroupAction.deleteProdGroup start...");
		try{
			TimeLog timeLog = new TimeLog(LOG);
			//写入日志
			logInfo(timeLog, prodProductId, groupId,"productId", productId);
			List<ProdGroup> list =validate(prodProductId, groupId, productId);
			timeLog.logWrite("deleteProdGroup.validate()", null);
			
			//取消关联
			ProdGroup prodGroup =new ProdGroup();
			prodGroup.setGroupId(groupId);
			if(list.size() >1){
				prodGroup.setProductId(isEqual(productId, groupId)?prodProductId:productId);
			}
			timeLog.afreshMillis();
			int result =prodGroupService.deleteByProdGroup(prodGroup);
			timeLog.logWrite("deleteProdGroup.deleteByProdGroup()", result);
			
			//插入日志
			StringBuilder logIds = new StringBuilder("[groupId=").append(prodGroup.getGroupId());
			logIds.append(",productId=").append(prodGroup.getProductId()).append("]");
			comLog(prodProductId, logIds, "取消关联");
			
			return new ResultMessage(ResultMessage.SUCCESS, "取消关联成功");
		}catch(Exception e){
			LOG.error(ExceptionFormatUtil.getTrace(e));
			return new ResultMessage(ResultMessage.ERROR, e.getMessage());
		}
		
	}
	
	
	/**
	 * 设置关联级别
	 */
	@RequestMapping(value = "/setSeqRetu")
	@ResponseBody
	public ResultMessage setSeqRetu(Model model ,HttpServletRequest request,Long prodProductId
			,Long productId, Long groupId, Integer seq){
		LOG.info("ProdGroupAction.setSeq start...");
		try{
			validate(prodProductId, seq);
			TimeLog timeLog = new TimeLog(LOG);
			//写入日志
			logInfo(timeLog, prodProductId, groupId,"seq", seq);
			
			//设置关联级别
			ProdGroup prodGroup =new ProdGroup();
			prodGroup.setProductId(productId);
			prodGroup.setGroupId(groupId);
			prodGroup.setSeq(seq);
			
			timeLog.afreshMillis();
			int up =prodGroupService.updateSeq(prodGroup);
			timeLog.logWrite("setSeq.updateSeq()", up);
			if(up <= 0)
				throw new BusinessException(PROD_GROUP_MESSAGE_UPDATE);
			insertMembercacheGroupInfo(productId,groupId);
			//插入日志
			StringBuilder logIds = new StringBuilder("[groupId=").append(groupId);
			logIds.append(",productId=").append(productId);
			logIds.append(",seq=").append(seq).append("]");
			comLog(prodProductId, logIds, "设置关联级别");
			
			return new ResultMessage(ResultMessage.SUCCESS, "设置成功");
		}catch(Exception e){
			LOG.error(ExceptionFormatUtil.getTrace(e));
			return new ResultMessage(ResultMessage.ERROR, e.getMessage());
		}
		
	}
	
	/**
	 * 设置关联级别
	 */
	@RequestMapping(value = "/setSeq")
	@ResponseBody
	public ResultMessage setSeq(Model model ,HttpServletRequest request,Long prodProductId
			,Long productId, Long groupId, Integer seq){
		LOG.info("ProdGroupAction.setSeq start...");
		try{
			validate(prodProductId, seq);
			TimeLog timeLog = new TimeLog(LOG);
			//写入日志
			logInfo(timeLog, prodProductId, groupId,"seq", seq);
			
			//设置关联级别
			ProdGroup prodGroup =new ProdGroup();
			prodGroup.setProductId(productId);
			prodGroup.setGroupId(groupId);
			prodGroup.setSeq(seq);
			
			timeLog.afreshMillis();
			int up =prodGroupService.updateSeq(prodGroup);
			timeLog.logWrite("setSeq.updateSeq()", up);
			if(up <= 0)
				throw new BusinessException(PROD_GROUP_MESSAGE_UPDATE);
			
			//插入日志
			StringBuilder logIds = new StringBuilder("[groupId=").append(groupId);
			logIds.append(",productId=").append(productId);
			logIds.append(",seq=").append(seq).append("]");
			comLog(prodProductId, logIds, "设置关联级别");
			
			return new ResultMessage(ResultMessage.SUCCESS, "设置成功");
		}catch(Exception e){
			LOG.error(ExceptionFormatUtil.getTrace(e));
			return new ResultMessage(ResultMessage.ERROR, e.getMessage());
		}
		
	}
	
	/**
	 * 添加关联验证
	 */
	public List<ProdGroup> validate(Long prodProductId,JSONArray jsonArray){
		Assert.notNull(prodProductId, "prodProductId not is null");
		//验证组
		List<ProdGroup> list =prodGroupService.selectByProductId(prodProductId, false);
		if(CollectionUtils.isEmpty(list)) return list;
		
		//验证产品是否已被关联
		Long groupId =list.get(0).getGroupId();
		if(!isEqual(prodProductId, groupId))
			throw new BusinessException(PROD_GROUP_MESSAGE_EXISTS);
		
		//验证关联总数
		int maxSize =getNewProdGroupMaxSize();
		
		int size =list.size() + jsonArray.size();
		if(size >maxSize)
			throw new BusinessException("添加关联【产品总数不能大于限制总数】："+size+","+maxSize);
		
		return list;
	}
	
	/**
	 * 添加关联验证行两个产品的行程天数、交通方式是否相同
	 */
	public List<ProdGroup> validate2(Long prodProductId,String dataArray){
		Assert.notNull(prodProductId, "prodProductId not is null");
		//验证组
		List<ProdGroup> list =prodGroupService.selectInfoByProductId(prodProductId, false);
		
		ProdProductParam param=new ProdProductParam();
		param.setAddtion(true);
		param.setProdLineRoute(true);
		ProdProduct product=prodProductService.findProdProductById(prodProductId,param);
		//验证关联总数
		List<LittleProdProduct> prdlist=com.alibaba.fastjson.JSONArray.parseArray(dataArray, LittleProdProduct.class);
		if(product!=null){
			if(product.getProductAddtional() == null) {
				throw new BusinessException("请先计算productId=" + prodProductId + "的团期，只有prod_product_addtional表有值才能执行关联操作（为了校验行程和交通方式是否重复）");
			}
			LittleProdProduct lpp=new LittleProdProduct();
			lpp.setBackTraffic(product.getProductAddtional().getBackTraffic());
			lpp.setToTraffic(product.getProductAddtional().getBackTraffic());
			lpp.setProductId(product.getProductId());
			for (com.lvmama.vst.back.prod.vo.ProdLineRouteVO line:product.getProdLineRouteList()) {
				if(line.getRouteNum()==prdlist.get(0).getRouteNum())
					lpp.setRouteNum(prdlist.get(0).getRouteNum());
				if(line.getStayNum()==prdlist.get(0).getStayNum())
					lpp.setStayNum(prdlist.get(0).getStayNum());
			}
			prdlist.add(lpp);
		}
		int maxSize =getNewProdGroupMaxSize();
		int count=0;
		if(!CollectionUtils.isEmpty(list)){
			count=list.size();
		}
		int size =count + prdlist.size();
		if(size >maxSize)
			throw new BusinessException("添加关联【产品总数不能大于限制总数】："+size+","+maxSize);
		//验证产品行程天数和交通是否
		for (LittleProdProduct prodGroup : prdlist) {
			ProdProductParam param3=new ProdProductParam();
			param3.setAddtion(true);
			param3.setProdLineRoute(true);
			ProdProduct prodP=prodProductService.findProdProductById(prodGroup.getProductId(),param3);
			if(prodP.getProdLineRouteList().size()>1){
				throw new BusinessException("该产品为多行程："+prodP.getProductId());
			}
			//验证跟团游自由行关联含有大交通产品
			if(product.getBizCategoryId().intValue()!=16){
				ProdProductParam param2=new ProdProductParam();
				param2.setProductProp(true);
				param2.setProductPropValue(true);
				ProdProduct product2=prodProductService.findProdProductById(prodGroup.getProductId(),param2);
				Map<String, Object> propMap =product2.getPropValue();
				String traffic_flag = "N";
				if(propMap !=null){
					traffic_flag = (String)propMap.get("traffic_flag");
				}
				if(!"Y".equals(traffic_flag)){
					throw new BusinessException("跟团游，自由行关联需含有大交通："+prodGroup.getProductId());
				}	
			}
			for (LittleProdProduct prodGroup1 : prdlist) {
				if((prodGroup.getProductId()==prodProductId||prodGroup1.getProductId()==prodProductId)
						&&(prodGroup.getRouteNum()==0||prodGroup1.getRouteNum()==0)){
					continue;
				}
				if(prodGroup.getProductId()!=prodGroup1.getProductId()
					&&prodGroup.getRouteNum()==prodGroup1.getRouteNum()&&
					prodGroup.getStayNum()==prodGroup1.getStayNum()){
						prodGroup.setToTraffic(StringUtil.coverNullStrValue(prodGroup.getToTraffic()));
						prodGroup.setBackTraffic(StringUtil.coverNullStrValue(prodGroup.getBackTraffic()));
						prodGroup1.setToTraffic(StringUtil.coverNullStrValue(prodGroup1.getToTraffic()));
						prodGroup1.setBackTraffic(StringUtil.coverNullStrValue(prodGroup1.getBackTraffic()));
						//验证不通过
						if(Constant.LINE_TRAFFIC.getCnNameNoNull(prodGroup.getToTraffic()).equals(Constant.LINE_TRAFFIC.getCnNameNoNull(prodGroup1.getToTraffic()))
						&&Constant.LINE_TRAFFIC.getCnNameNoNull(prodGroup.getBackTraffic()).equals(Constant.LINE_TRAFFIC.getCnNameNoNull(prodGroup1.getBackTraffic()))){
							throw new BusinessException("行程天数和交通重复："+prodGroup1.getProductId());
						}
				}
			}
		}
		if(list!=null){
			if(product!=null){
				prdlist.remove(prdlist.size()-1);
			}
			for (ProdGroup prodGroup : list) {
				for (LittleProdProduct prodGroup1 : prdlist) {
					
					if(prodGroup.getRouteNum()==prodGroup1.getRouteNum()&&
							prodGroup.getStayNum()==prodGroup1.getStayNum()){
						prodGroup.setToTraffic(StringUtil.coverNullStrValue(prodGroup.getToTraffic()));
						prodGroup.setBackTraffic(StringUtil.coverNullStrValue(prodGroup.getBackTraffic()));
						prodGroup1.setToTraffic(StringUtil.coverNullStrValue(prodGroup1.getToTraffic()));
						prodGroup1.setBackTraffic(StringUtil.coverNullStrValue(prodGroup1.getBackTraffic()));
						//验证不通过
						if(Constant.LINE_TRAFFIC.getCnNameNoNull(prodGroup.getToTraffic()).equals(Constant.LINE_TRAFFIC.getCnNameNoNull(prodGroup1.getToTraffic()))
								&&Constant.LINE_TRAFFIC.getCnNameNoNull(prodGroup.getBackTraffic()).equals(Constant.LINE_TRAFFIC.getCnNameNoNull(prodGroup1.getBackTraffic()))){
									throw new BusinessException("行程天数和交通重复："+prodGroup1.getProductId());
								}
					}
				}
			}
		}
		if(CollectionUtils.isEmpty(list)) return list;
		//验证产品是否已被关联
		Long groupId =list.get(0).getGroupId();
		if(!isEqual(prodProductId, groupId))
			throw new BusinessException(PROD_GROUP_MESSAGE_EXISTS);
		return list;
	}
	private JSONArray validate(String dataArray){
		Assert.notNull(dataArray, "dataArray not is null");  //批量添加关联
		JSONArray jsonArray =JSONArray.fromObject(dataArray);
		if(jsonArray.size() <= 0)
			throw new BusinessException("添加关联【产品总数不能为空】,"+ jsonArray.size());
		return JSONArray.fromObject(dataArray);
	}
	
	/**
	 * 取消关联验证
	 */
	public List<ProdGroup> validate(Long prodProductId,Long groupId, Long productId){
		Assert.notNull(prodProductId, "prodProductId not is null");
		Assert.notNull(groupId, "groupId not is null");
		Assert.notNull(productId, "productId not is null");
		
		//验证组数据
		List<ProdGroup> list =prodGroupService.selectByProductId(productId, false);
		if(CollectionUtils.isEmpty(list))
			throw new BusinessException(PROD_GROUP_MESSAGE_UPDATE);
		//验证组是否一致
		Long gId =list.get(0).getGroupId();
		if(!isEqual(groupId, gId))
			throw new BusinessException(PROD_GROUP_MESSAGE_UPDATE);
		
		return list;
	}
	
	/**
	 * 设置级别验证
	 * @param prodProductId
	 * @param seq
	 */
	private void validate(Long prodProductId, Integer seq){
		Assert.notNull(prodProductId, "prodProductId not is null");
		Assert.notNull(seq, "seq not is null");
	}
	
	/**
	 * JSON转ProdGroup
	 * @param jsonObject
	 * @return
	 */
	private ProdGroup jsonToProdGroup(Long groupId, Integer seq,JSONObject jsonObject){
		ProdGroup prodGroup = new ProdGroup();
		prodGroup.setGroupId(groupId);
		prodGroup.setSeq(seq);//优先级
		prodGroup.setProductId(jsonObject.getLong("productId"));
		prodGroup.setCategoryId(jsonObject.getLong("categoryId"));
		prodGroup.setLineRouteId(jsonObject.getLong("lineRouteId"));
		prodGroup.setRouteNum(Short.valueOf(jsonObject.getString("routeNum")));
		prodGroup.setStayNum(Short.valueOf(jsonObject.getString("stayNum")));
		return prodGroup;
	}
	/**
	 * 产品对象转ProdGroup
	 * @param prodProductId
	 * @param seq
	 * @return
	 */
	private ProdGroup productToProdGroup(Long prodProductId,Long categoryId, Integer seq){
		ProdGroup prodGroup =new ProdGroup();
		prodGroup.setGroupId(prodProductId);
		prodGroup.setSeq(seq);
		prodGroup.setProductId(prodProductId);
		//加载产品有效行程信息
		Map<String, Object> params = new HashMap<String, Object>(2, 1f);
		params.put("productId", prodProductId);
//		params.put("cancleFlag", 'Y');
		List<ProdLineRoute> prodLineRouteList = prodLineRouteService.findProdLineRouteByParams(params);
		if(CollectionUtils.isEmpty(prodLineRouteList))
			throw new BusinessException("维护产品有效行程不能为空");
		
		prodGroup.setCategoryId(categoryId);
		prodGroup.setLineRouteId(prodLineRouteList.get(0).getLineRouteId());
		prodGroup.setRouteNum(prodLineRouteList.get(0).getRouteNum());
		prodGroup.setStayNum(prodLineRouteList.get(0).getStayNum());
		return prodGroup;
	}
	
	/**
	 * 注入form提交数据
	 * @param params
	 * @param req
	 * @param isDestLimit 是否限制目的地产品
	 */
	private void loadParams(Map<String, Object> params, HttpServletRequest req, Boolean isDestLimit){
		if(isDestLimit) loadDestParams(params);
		
		String productName =req.getParameter("productName");
		String productId =req.getParameter("productId");
		String routeNum =req.getParameter("routeNum");
		String stayNum =req.getParameter("stayNum");
		if(StringUtils.isNotBlank(productName)) params.put("productName", productName);
		if(StringUtils.isNotBlank(productId)) params.put("productId", productId);
		if(StringUtils.isNotBlank(routeNum)) params.put("routeNum", routeNum);
		if(StringUtils.isNotBlank(stayNum)) params.put("stayNum", stayNum);
	}
	
	/**
	 * 查询关联产品限制(目的地自主打包产品)
	 * @param params
	 */
	private void loadDestParams(Map<String, Object> params){
		params.put("bizCategoryId",  VST_CATEGORY.CATEGORY_ROUTE_FREEDOM.getCategoryId());
		params.put("productType", ProdProduct.PRODUCTTYPE.INNERLINE);
		params.put("packageType", ProdProduct.PACKAGETYPE.LVMAMA);
		params.put("bu", CommEnumSet.BU_NAME.DESTINATION_BU.getCode());
	}
	
	/**
	 * 获取关联产品的最大数目
	 * @return int
	 */
	private static int getProdGroupMaxSize(){
		String size =Constant.getInstance().getProperty(PROD_GROUP_MAX_SIZE);
		Assert.notNull(size, PROD_GROUP_MAX_SIZE +" not is null");
		return Integer.valueOf(size);
	}
	private static final short PROD_GROUP_MAX_SUM =10;
	private static int getNewProdGroupMaxSize(){
		Short size =PROD_GROUP_MAX_SUM;
		Assert.notNull(size, PROD_GROUP_MAX_SIZE +" not is null");
		return Integer.valueOf(size);
	}
	
	private boolean isEqual(Long long1, Long long2){
		return long1.intValue() == long2.intValue();
	}
	
	/**
	 * 写入日志
	 */
	private void logInfo(TimeLog timeLog, Long prodProductId, Long groupId, String objName, Object objId){
		timeLog.clear();
		timeLog.append("【prodProductId:").append(prodProductId);
		timeLog.append(",groupId：").append(groupId);
		timeLog.append(",").append(objName).append(":").append(objId).append("】");
		timeLog.logWrite(timeLog.getBulder().toString());
		timeLog.clear();
	}
	
	/**
	 * 插入日志数据
	 * @param prodProductId
	 * @param logIds
	 * @param title
	 */
	@Async
	private void comLog(Long prodProductId, StringBuilder logIds, String title){
		//设置日志
		try {
			comLogService.insert(COM_LOG_OBJECT_TYPE.PROD_GROUP, 
					prodProductId, prodProductId, 
					this.getLoginUser().getUserName(), 
					title+logIds.toString(), 
					COM_LOG_LOG_TYPE.PROD_GROUP.name(), 
					title,null);
		} catch (Exception e) {
			LOG.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.PROD_GROUP.name());
			LOG.error(e.getMessage());
		}	
	}
}
