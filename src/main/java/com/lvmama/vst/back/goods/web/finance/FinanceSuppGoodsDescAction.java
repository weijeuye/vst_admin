package com.lvmama.vst.back.goods.web.finance;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.visa.api.utils.BeanUtils;
import com.lvmama.vst.back.client.goods.service.FinanceSuppGoodsDescInfoClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.client.pub.service.ComPhotoClientService;
import com.lvmama.vst.back.goods.po.FinanceSuppGoodsDesc;
import com.lvmama.vst.back.goods.vo.FinancePhotosVo;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_LOG_TYPE;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.pub.po.ComPhoto;
import com.lvmama.vst.comm.web.BaseActionSupport;
@SuppressWarnings("serial")
@Controller
@RequestMapping("/finance/goods")
public class FinanceSuppGoodsDescAction extends BaseActionSupport{
	private static final Log LOG = LogFactory.getLog(FinanceSuppGoodsDescAction.class);
	
	//商品详情服务
	@Autowired
	private FinanceSuppGoodsDescInfoClientService financeSuppGoodsDescInfoClientService;
	
	//图片服务
	@Autowired
	private ComPhotoClientService comPhotoClientService;
	
	//日志服务
	@Autowired
	private ComLogClientService comLogService;
	
	
	
	
	/**
	 * 查询商品详情页面
	 * @param model
	 * @param goosId
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping("/showSuppGoodsDescMain")
	public String showSuppGoodsDescMain(Model model,Long goodsId,Long productId) throws Exception{
		try {
			List<FinanceSuppGoodsDesc> financeList = financeSuppGoodsDescInfoClientService.queryFinanceSuppGoodsDescByGoodsId(goodsId);
			model.addAttribute("financeList", financeList);
			model.addAttribute("goodsId", goodsId);
			model.addAttribute("productId", productId);
		} catch (Exception e) {
			// TODO: handle exception
			LOG.info("financeSuppGoodsDesc  Exception");
		}
			return "/goods/finance/financeGoodsDesc/financeSuppGoodsDesc";
	}
	
	/**
	 * 商品详情置顶
	 * @param goodsId
	 * @param goodsDescId
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("topSuppGoodsDesc")
	public String topSuppGoodsDesc(Long goodsId,Long goodsDescId,Long productId){
		//查询最大值
		try {
			financeSuppGoodsDescInfoClientService.topSuppGoodsDesc(goodsId, goodsDescId);
			comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
					productId, goodsDescId, 
					this.getLoginUser().getUserName(), 
					"置顶：【商品描述信息】", 
					COM_LOG_LOG_TYPE.FINANCE_SUPPGOODS_DESC_TOP.name(), 
					"置顶商品描述",null);
			
		} catch (Exception e) {
			// TODO: handle exception
			 LOG.error(e.getMessage());
		}
		return "redirect:/finance/goods/showSuppGoodsDescMain.do?goodsId="+goodsId;
	}
	
	/**
	 * 根据id查询商品详情图片URL
	 * @param goodsDescId
	 * @return
	 */
	@RequestMapping("/queryComphotoUrl")
	@ResponseBody
	public List<ComPhoto> queryComphotoUrl(Long goodsDescId){
		List<ComPhoto> comPhotoList = new ArrayList<ComPhoto>();
		try {
			Map<String, Object> parameters =new HashMap<String, Object>();
			parameters.put("objectId", goodsDescId.toString());
			parameters.put("objectType", "FINANCE_ID");
			comPhotoList = comPhotoClientService.selectAllByParam(parameters);
		} catch (Exception e) {
			// TODO: handle exception
			LOG.info("queryComphotoUrl exception!");
		}
		return comPhotoList;
		
	}
	
	/**
	 * 根据id删除商品详情
	 * @param goodsDescId
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/deleteSuppGoodsDesc")
	@ResponseBody
	public int deleteSuppGoodsDesc(Long goodsDescId,Long productId,Long goodsId) throws Exception{
		//1删除图库的书籍 2删除商品描述表的数据
		int deleteSuppGoodsDesc = 0;
		try {
			comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
					productId, goodsDescId, 
					this.getLoginUser().getUserName(), 
					"删除：【商品描述信息】", 
					COM_LOG_LOG_TYPE.FINANCE_SUPPGOODS_DESC_DETELE.name(), 
					"删除商品描述",null);
			deleteSuppGoodsDesc = financeSuppGoodsDescInfoClientService.deleteSuppGoodsDesc(goodsDescId,goodsId);
			
		} catch (Exception e) {
			// TODO: handle exception
			 LOG.error(e.getMessage());
		}
		return  deleteSuppGoodsDesc;
	}
	
	
	
	/**
	 * 保存OR修改商品详情
	 * @param model
	 * @param guideStrJpg
	 * @param guideStrDesc
	 * @param goodsDescId
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/saveSuppGoodsDesc")
	@ResponseBody
	public FinanceSuppGoodsDesc saveSuppGoodsDesc(Model model,String guideStrJpg,String guideStrDesc,Long goodsDescId,Long productId){
		Long fid =0l;
		FinanceSuppGoodsDesc financeSuppGoodsDesc= new FinanceSuppGoodsDesc();
		try {
		if (guideStrDesc!=null &&!"".equals(guideStrDesc)) {
			JSONArray array2 = JSONArray.fromObject(guideStrDesc);
			FinanceSuppGoodsDesc[] financeSuppGoodsD = (FinanceSuppGoodsDesc[]) JSONArray.toArray(array2, FinanceSuppGoodsDesc.class);
			if (financeSuppGoodsD!=null) {
				financeSuppGoodsDesc = financeSuppGoodsD[0];
				com.lvmama.vst.back.goods.po.FinanceSuppGoodsDesc fina =BeanUtils.copyProperties(financeSuppGoodsDesc, com.lvmama.vst.back.goods.po.FinanceSuppGoodsDesc.class);
				//获取到新增序列的商品描述ID
				if (guideStrJpg!=null &&!"".equals(guideStrJpg)) {
					JSONArray array1 = JSONArray.fromObject(guideStrJpg);
					FinancePhotosVo[] financePhotosVo =(FinancePhotosVo[]) JSONArray.toArray(array1, FinancePhotosVo.class);
					//ComPhoto[] comPhotos = null;
					List<ComPhoto> comPhotos =new ArrayList<ComPhoto>();
					if (financePhotosVo!=null) {
						for (int i = 0; i < financePhotosVo.length; i++) {
							ComPhoto comPhoto =new ComPhoto();
							comPhoto.setPhotoUrl(financePhotosVo[i].getImgurl().substring(22));
							comPhotos.add(comPhoto);
						}
					}
						fina.setGoodsDescId(goodsDescId);
						fid = financeSuppGoodsDescInfoClientService.saveOrUpdateFinanceSuppGoodsDesc(fina,comPhotos);//返回值ID
						if (fina.getGoodsDescId()==null) {
							//新增
							comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
									productId, fina.getGoodsId(), 
									this.getLoginUser().getUserName(), 
									"新增：【商品描述信息】", 
									COM_LOG_LOG_TYPE.FINANCE_SUPPGOODS_DESC.name(), 
									"新增商品描述",null);
						}else {
							//修改
							comLogService.insert(COM_LOG_OBJECT_TYPE.SUPP_GOODS_GOODS, 
									productId, fina.getGoodsDescId(), 
									this.getLoginUser().getUserName(), 
									"修改：【商品描述信息】", 
									COM_LOG_LOG_TYPE.FINANCE_SUPPGOODS_DESC_CHANGE.name(), 
									"修改商品描述",null);
							
						}
					
				}
			}
		}
		} 
		catch (Exception e) {
			log.error("Record Log failure ！Log type:"+COM_LOG_LOG_TYPE.FINANCE_SUPPGOODS_DESC.name());
			 LOG.error(e.getMessage());
		}
		if (fid>0) {
			financeSuppGoodsDesc.setGoodsDescId(fid);
		}
		return financeSuppGoodsDesc;
	}

}
