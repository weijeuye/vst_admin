package com.lvmama.vst.back.goods.web.finance;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import scala.actors.threadpool.Arrays;

import com.lvmama.cmt.comm.vo.BusinessException;
import com.lvmama.pay.api.service.IPayDataDictionaryService;
import com.lvmama.pay.api.vo.PayDataDictionaryVO;
import com.lvmama.pay.api.vo.ProcessResult;
import com.lvmama.vst.back.client.goods.service.FinanceInterestsBonusClientService;
import com.lvmama.vst.back.client.goods.service.FinanceLableClientService;
import com.lvmama.vst.back.client.goods.service.FinanceLableTableClientService;
import com.lvmama.vst.back.client.goods.service.FinanceOtherInterestsBonusClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.goods.po.FinanceInterestsBonus;
import com.lvmama.vst.back.goods.po.FinanceOtherInterests;
import com.lvmama.vst.back.goods.vo.CategoryEnum;
import com.lvmama.vst.back.goods.vo.CategoryEnum.CATEGORY_PLACECODE;
import com.lvmama.vst.back.goods.vo.FinanceLableTableVO;
import com.lvmama.vst.back.goods.vo.FinanceLableVO;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.vo.ResultHandleT;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
@SuppressWarnings("serial")
@Controller
@RequestMapping("/finance/interestsBonus")
public class FinanceInterestsBonusAction extends BaseActionSupport{
	private static final Log LOG = LogFactory.getLog(FinanceInterestsBonusAction.class);
	//商品权益金服务
	@Autowired
	private FinanceInterestsBonusClientService financeInterestsBonusClientService;
	
	//商品其他权益服务
	@Autowired
	private FinanceOtherInterestsBonusClientService financeOtherInterestsBonusClientService;
	
	//查询账户类型服务
	@Autowired
	private IPayDataDictionaryService  iPayDataDictionaryService;
	
	//日志服务
	@Autowired 
	private ComLogClientService comLogService;
	
	
	@Autowired
	private FinanceLableTableClientService financeLableTableClientService;
	
	@Autowired
	private FinanceLableClientService financeLableClientService;
	
	/**
	 * 查询商品权益金其他权益详情
	 * @param model
	 * @param goodsId
	 * @param productId
	 * @return
	 */
	@RequestMapping("/showInterestsBonusMain")
	public String showInterestsBonusMain(Model model,Long productId,HttpServletRequest req){
		//查询品类
		Long goodsId = Long.valueOf(req.getParameter("goodsId"));
		CATEGORY_PLACECODE[] values = CategoryEnum.CATEGORY_PLACECODE.values();
		List<CATEGORY_PLACECODE> categoryList = Arrays.asList(values);
		FinanceInterestsBonus fInterestsBonus=null;
		try {
			//根据商品ID查询权益金表
			List<FinanceInterestsBonus> financeInterestsBonus = financeInterestsBonusClientService.selectFinanceInterestsBonusByGoodsId(goodsId);
			if (financeInterestsBonus!=null && financeInterestsBonus.size()>0) {
				fInterestsBonus = financeInterestsBonus.get(0);
				String banCategory = fInterestsBonus.getBanCategory();
				if (banCategory!=null &&!"".equals(banCategory)) {
					String[] split = banCategory.split(",");
					List<String> cateList = Arrays.asList(split);
					model.addAttribute("cateList", cateList);
				}
			}
			//根据商品ID查询其他权益表
			List<FinanceOtherInterests> financeOtherInterests = financeOtherInterestsBonusClientService.selectFinanceOtherInterestsByGoodsId(goodsId);
			model.addAttribute("financeOtherInterests", financeOtherInterests);
			if (LOG.isDebugEnabled()) {
				LOG.debug("start method<showSuppGoodsOrderRequired>");
			}
			model.addAttribute("suppGoodsId", goodsId);
			HashMap<String,Object> lableMap = new HashMap<String, Object>();
			lableMap.put("goodsId", goodsId);
			ResultHandleT<List<FinanceLableTableVO>> goodsLableListResult= financeLableTableClientService.findFinanceLableTableByParams(lableMap);
			if(goodsLableListResult!=null && goodsLableListResult.isSuccess()){
				List<FinanceLableTableVO> goodsLableList = goodsLableListResult.getReturnContent();
				if(goodsLableList!=null && goodsLableList.size()>0){
					List<FinanceLableVO> lableList = new ArrayList<FinanceLableVO>();
					for(FinanceLableTableVO financeLableTable :goodsLableList){
						lableMap.clear();
						lableMap.put("lableId", financeLableTable.getLableId());
						ResultHandleT<List<FinanceLableVO>> lableListResult = financeLableClientService.findFinanceLableByParams(lableMap);
						if(lableListResult!=null && lableListResult.isSuccess()){
							List<FinanceLableVO> financelableList = lableListResult.getReturnContent();
							if(financelableList!=null && financelableList.size()>0){
								lableList.add(financelableList.get(0));
							}
						}
						
					}
					model.addAttribute("lableList", lableList);
				}
				
			}
		//查询账户类型
		ProcessResult<List<PayDataDictionaryVO>> payResult = iPayDataDictionaryService.selectDataDictionaryByType("PRODUCT_CODE");
		if (payResult!=null) {
			List<PayDataDictionaryVO> accountTypeList = payResult.getData();
			model.addAttribute("accountType", accountTypeList);
		}
		} catch (Exception e) {
			// TODO: handle exception
			LOG.info("showInterestsBonusMain  exception！");
		}
			
		//商品id
		model.addAttribute("categoryList", categoryList);
		model.addAttribute("fInterestsBonus", fInterestsBonus);
		model.addAttribute("goodsId", goodsId);
		model.addAttribute("productId", productId);
		return "/goods/finance/interestsBonus/interestsBonus";
	}
	
	
	/**
	 * 保存or修改商品权益金and商品其他权益
	 * @param InterestsBonus
	 * @param otherInterestsBonus
	 * @param goodsId
	 * @param productId
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/saveInterestsBonus")
	@ResponseBody
	public int saveInterestsBonus(String InterestsBonus,String otherInterestsBonus,Long goodsId,Long productId) throws Exception{
		int rs =0;
		if (!"[]".equals(InterestsBonus)) {
			JSONArray bonusArray = JSONArray.fromObject(InterestsBonus);
			JSONArray otherbonusArray = JSONArray.fromObject(otherInterestsBonus);
			try {
				FinanceInterestsBonus[] Interests = (FinanceInterestsBonus[]) JSONArray.toArray(bonusArray, FinanceInterestsBonus.class);
				FinanceOtherInterests[] otherInterests = (FinanceOtherInterests[]) JSONArray.toArray(otherbonusArray, FinanceOtherInterests.class);
				FinanceInterestsBonus fBonus =null;
				//其他权益的集合
				List<FinanceOtherInterests>  fs= Arrays.asList(otherInterests);
				if (fs!=null &&fs.size()>0) {
					for (FinanceOtherInterests financeOtherInterests : fs) {
						if (financeOtherInterests!=null) {
							financeOtherInterests.setGoodsId(goodsId);
						}
					}
				}
				if (Interests.length>0) {
					fBonus= Interests[0];
					fBonus.setGoodsId(goodsId);
				}
				financeInterestsBonusClientService.saveOrUpdateFinanceInterestsBonus(fBonus, fs,goodsId);
				if (fBonus.getInterestsBonusId()==null) {
					comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
						productId, goodsId, 
						this.getLoginUser().getUserName(), 
						"新增：【商品权益金】", 
						COM_LOG_LOG_TYPE.FINANCE_INTERESTS_BONUS.name(), 
						"保存商品权益金",null);
				}else {
					comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
							productId, fBonus.getInterestsBonusId(), 
							this.getLoginUser().getUserName(), 
							"修改：【商品权益金】", 
							COM_LOG_LOG_TYPE.FINANCE_INTERESTS_BONUS_CHANGE.name(), 
							"修改商品权益金",null);
					//redisClusterPojoClient.remove(RedisEnum.KEY.SuppGoods_InterestsBonus_+fBonus.getInterestsBonusId().toString());
				}
				if (fs.size()>0 && fs!=null) {
					Long otherInterestsId = fs.get(0).getOtherInterestsId();
					if (otherInterestsId==null) {
						comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
								productId, goodsId, 
								this.getLoginUser().getUserName(), 
								"新增：【商品其他权益】", 
								COM_LOG_LOG_TYPE.FINANCE_OTHER_INTERESTS.name(), 
								"保存商品其他权益",null);
						
					}else {
						comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
								productId, goodsId, 
								this.getLoginUser().getUserName(), 
								"修改：【商品其他权益】", 
								COM_LOG_LOG_TYPE.FINANCE_OTHER_INTERESTS_CHANGE.name(), 
								"修改商品其他权益",null);
					}
				}
				rs = 1;
			} catch (Exception e) {
				 LOG.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.FINANCE_INTERESTS_BONUS.name());
				 LOG.error(e.getMessage());
				rs =0;
			}
		}else {
			rs=2;
		}
		return rs;
	}
	
	
	/**
	 * 置顶商品其他权益
	 * @param goodsId
	 * @param otherInterestsId
	 * @param productId
	 * @throws Exception
	 */
	@RequestMapping("topInterestsBonus")
	public void topSuppGoodsDesc(Long goodsId,Long otherInterestsId,Long productId) throws Exception{
		//查询最大值
		
		try {
			financeOtherInterestsBonusClientService.topSuppGoodsDesc(goodsId, otherInterestsId);
			comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
					productId, otherInterestsId, 
					this.getLoginUser().getUserName(), 
					"置顶：【商品其他权益】", 
					COM_LOG_LOG_TYPE.FINANCE_OTHER_INTERESTS_TOP.name(), 
					"置顶商品其他权益",null);
		} catch (Exception e) {
			// TODO: handle exception
			LOG.error("addFinanceLable error：suppGoodsId ="+goodsId+ExceptionFormatUtil.getTrace(e));
			LOG.error(e.getMessage());
		}
		
	}
	
	
	
	/**
	 * 添加标签
	 */
	@RequestMapping(value = "/addFinanceLable")
	@ResponseBody
	public Object addFinanceLable(String lableName,Long suppGoodsId) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<addFinanceLable>");
		}
		Long lableId = null;
		Map<String, Object> attributes = new HashMap<String, Object>();
		try {
			HashMap<String,Object> params = new HashMap<String, Object>();
			params.put("goodsId", suppGoodsId);
			ResultHandleT<List<FinanceLableTableVO>> resultT = financeLableTableClientService.findFinanceLableTableByParams(params);
			if(resultT!=null && resultT.isSuccess()){
				List<FinanceLableTableVO> financeLableTableList = resultT.getReturnContent();
				if(financeLableTableList!=null && financeLableTableList.size()>=5){
					return new ResultMessage(ResultMessage.ERROR, "标签数量超出5个");
				}
			}
			if(StringUtils.isNotEmpty(lableName)){
				Map<String, Object> para = new HashMap<String, Object>();
				para.put("lableName", lableName);
				ResultHandleT<List<FinanceLableVO>> finHandleT = financeLableClientService.findFinanceLableByParams(para);
				if (finHandleT!=null) {
					List<FinanceLableVO> fList = finHandleT.getReturnContent();
					if (fList.size()==0) {
						//没少到
						FinanceLableVO financeLableVO =new FinanceLableVO();
						financeLableVO.setLableName(lableName);
						lableId = financeLableClientService.saveFinanceLable(financeLableVO,suppGoodsId).longValue();
					}else {
						//找到了
						lableId = fList.get(0).getLableId();
					}
				}
			}
			if(lableId!=null){
				attributes.put("lableId", lableId);
				FinanceLableTableVO financeLableTableVO = new FinanceLableTableVO();
				financeLableTableVO.setGoodsId(suppGoodsId);
				financeLableTableVO.setLableId(lableId);
				financeLableTableClientService.saveFinanceLableTable(financeLableTableVO,suppGoodsId);
			}
		}catch (Exception e) {
			LOG.error("addFinanceLable error：suppGoodsId ="+suppGoodsId+ExceptionFormatUtil.getTrace(e));
			return new ResultMessage(ResultMessage.ERROR, "新增失败");
		}
		return new ResultMessage(attributes, ResultMessage.SUCCESS, "保存成功");
	}
	
	/**
	 * 编辑标签
	 */
	@RequestMapping(value = "/updateFinanceLable")
	@ResponseBody
	public Object updateFinanceLable(String lableName ,Long lableId,Long goodsId) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<updateFinanceLable>");
		}
		Map<String, Object> attributes = new HashMap<String, Object>();
		try {
			if(lableId!=null && lableName!=null){
				Map<String, Object> para = new HashMap<String, Object>();
				para.put("lableName", lableName);
				ResultHandleT<List<FinanceLableVO>> finHandleT = financeLableClientService.findFinanceLableByParams(para);
				if (finHandleT != null) {
					List<FinanceLableVO> fList = finHandleT.getReturnContent();
					if (fList.size()==0) {
						FinanceLableVO financeLableVO = new FinanceLableVO();
						financeLableVO.setLableId(lableId);
						financeLableVO.setLableName(lableName);
						financeLableClientService.updateFinanceLable(financeLableVO,goodsId);
						attributes.put("lableId", lableId);
					}else {
						//找到了
						Long newlableId = fList.get(0).getLableId();//新id
						//1 根据goodsID 和 lableid 找到是哪一条数据
						Map<String, Object> params = new HashMap<String, Object>();
						params.put("goodsId", goodsId);
						params.put("lableId", lableId);
						
						ResultHandleT<List<FinanceLableTableVO>> financeLaResultHandleT = financeLableTableClientService.findFinanceLableTableByParams(params);
						if (financeLaResultHandleT!=null) {
							List<FinanceLableTableVO> financeLableTableVOs = financeLaResultHandleT.getReturnContent();
							if (financeLableTableVOs!=null && financeLableTableVOs.size()>0) {
								FinanceLableTableVO financeLableTableVO = financeLableTableVOs.get(0);
								financeLableTableVO.setLableId(newlableId);
								Integer rs = financeLableTableClientService.updateFinanceLableTable(financeLableTableVO,goodsId);
								attributes.put("lableId", newlableId);
							}
						}
						
					}
					
				}
				
			}else{
				return new ResultMessage(ResultMessage.ERROR, "编辑失败，缺少lableId");
			}
		}catch (Exception e) {
			LOG.error("updateFinanceLable error：financeLableId ="+lableId+ExceptionFormatUtil.getTrace(e));
			return new ResultMessage(ResultMessage.ERROR, "编辑失败");
		}
		return new ResultMessage(attributes,ResultMessage.SUCCESS, "编辑成功");
	}
	
	/**
	 * 删除标签
	 */
	@RequestMapping(value = "/deleteFinanceLable")
	@ResponseBody
	public Object deleteFinanceLable(Long lableId,Long suppGoodsId) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<deleteFinanceLable>");
		}
		try {
			if(suppGoodsId !=null && lableId !=null){
				//financeLableClientService.deleteFinanceLable(lableId);
				FinanceLableTableVO financeLableTableVO = new FinanceLableTableVO();
				financeLableTableVO.setGoodsId(suppGoodsId);
				financeLableTableVO.setLableId(lableId);
				HashMap<String,Object> params = new HashMap<String, Object>();
				params.put("lableId", lableId);
				params.put("goodsId", suppGoodsId);
				financeLableTableClientService.deleteFinanceLableTableByParams(params);
			}else{
				return new ResultMessage(ResultMessage.ERROR, "删除失败，id为空");
			}
		}catch (Exception e) {
			LOG.error("deleteFinanceLable error：suppGoodsId ="+suppGoodsId+ExceptionFormatUtil.getTrace(e));
			return new ResultMessage(ResultMessage.ERROR, "删除失败");
		}
		return ResultMessage.DELETE_SUCCESS_RESULT;
	}
	
	
	
	@RequestMapping("/queryFinanceLable")
	@ResponseBody
	public List<FinanceLableVO>  queryFinanceLable(String name){
		List<FinanceLableVO> finVos = new ArrayList<FinanceLableVO>();
		try {
			if (name!=null && !"".equals(name)) {
				finVos = financeLableClientService.queryFinanceLable(name);
			}
			
		} catch (Exception e) {
			// TODO: handle exception
			LOG.info("queryFinanceLable Exception");
		}
		return finVos;
	}
	
	

}
