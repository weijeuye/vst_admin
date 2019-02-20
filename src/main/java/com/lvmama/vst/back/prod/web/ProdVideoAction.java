package com.lvmama.vst.back.prod.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.lvmama.vst.comm.utils.web.HttpServletLocalThread;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.prod.service.ProdPackageGroupClientService;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.goods.vo.ProdProductParam;
import com.lvmama.vst.back.prod.po.ProdPackageGroup;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProductVideo;
import com.lvmama.vst.back.prod.service.ProdProductService;
import com.lvmama.vst.back.prod.service.ProductVideoService;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.vo.Constant;
import com.lvmama.vst.comm.vo.MemcachedEnum;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.pet.adapter.UploadPicServiceAdapter;

@Controller
@RequestMapping("/prod/prodVideo")
public class ProdVideoAction extends BaseActionSupport {

	private static final long serialVersionUID = 2172865426226229104L;

	private static final Log LOG = LogFactory.getLog(ProdVideoAction.class);
	
	@Autowired
	private SuppGoodsClientService suppGoodsService;
	
	@Autowired
	private ProductVideoService productVideoService;
	
	@Autowired
	private UploadPicServiceAdapter uploadPicServiceRemote;

	@Autowired
	private ProdProductService prodProductService;
	
	@Autowired
	private ProdPackageGroupClientService prodPackageGroupService;
	
	/**
	 * 添加视频页面
	 * @param productId
	 * @param categoryId
	 * @return
	 */
	@RequestMapping(value = "/showProductVideo")
	public String showProductVideo(String productId, String categoryId) {
		HttpServletLocalThread.getModel().addAttribute("productId", productId);
		HttpServletLocalThread.getModel().addAttribute("categoryId", categoryId);
		boolean showErrorInfo = false;
		// 品类 17:酒店套餐 18:自由行
		if(categoryId.equalsIgnoreCase("17")){
			// BU
			SuppGoods suppGoods = suppGoodsService.findBaseSuppGoodsByProductId(Long.parseLong(productId));
			String bu = suppGoods.getBu();
			if(!bu.equalsIgnoreCase("DESTINATION_BU")){
				HttpServletLocalThread.getModel().addAttribute("showError", "17");
				showErrorInfo = true;
			}
		}
		
		if(categoryId.equalsIgnoreCase("18")){
			// 类别 国内游的条件
			ProdProductParam param = new ProdProductParam();
			param.setBizCategory(true);
			param.setBizDistrict(true);
			param.setProductProp(true);
			param.setProductPropValue(true);
			ProdProduct prodProduct = prodProductService.findProdProductById(Long.valueOf(productId),param);
			if(prodProduct != null && !prodProduct.getProductType().equalsIgnoreCase("INNERLINE")) {
				HttpServletLocalThread.getModel().addAttribute("showError", "18");
				showErrorInfo = true;
			}
			
			// 自主打包
			// 供应商打包不需要显示
			if(prodProduct.getPackageType().equalsIgnoreCase("LVMAMA")){
				String bu =prodProduct.getBu();
				if(!bu.equalsIgnoreCase("DESTINATION_BU")){
					HttpServletLocalThread.getModel().addAttribute("showError", "18");
					showErrorInfo = true;
				}
			}
		}
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("objectId", productId);
		params.put("bizCategoryId", categoryId);
		if(!showErrorInfo) {
			List<ProductVideo> prodVideoList = productVideoService.getProductVideo(params);
			for(int i =0;i< prodVideoList.size();i++){
				ProductVideo prodVideoItem = prodVideoList.get(i);
				if(prodVideoItem.getChildVideoId() != null) {
					prodVideoItem.setObjectId(prodVideoItem.getChildObjectId());
					prodVideoItem.setCategoryName(Constant.VST_CATEGORY.getCnNameByStatus(prodVideoList.get(i).getChildBizCategoryId().toString()));
				} else {
					prodVideoItem.setCategoryName(Constant.VST_CATEGORY.getCnNameByStatus(prodVideoList.get(i).getBizCategoryId().toString()));
				}
			}
			HttpServletLocalThread.getModel().addAttribute("prodVideoList", prodVideoList);
		}
		return "/prod/video/showProductVideo";
	}
	
	/**
	 * 国内添加视频页面
	 * @return
	 */
	@RequestMapping(value = "/showProductVideo_local")
	public String showProductVideo_local(Model model, String productId, String categoryId, String childVideo) {
		model.addAttribute("productId", productId);
		model.addAttribute("categoryId", categoryId);
		boolean showErrorInfo = false;
		ProdProduct prodProduct = prodProductService.getProdProductBy(Long.valueOf(productId));
		if (!(prodProduct != null
				&& "LOCAL_BU".equalsIgnoreCase(prodProduct.getBu()) 
				&& (prodProduct.getBizCategoryId() == 15L || prodProduct.getBizCategoryId() == 16L 
				|| (prodProduct.getBizCategoryId() == 18L && prodProduct.getSubCategoryId() == 182L)))) {
			showErrorInfo = true;
		}
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("objectId", productId);
		params.put("bizCategoryId", categoryId);
		if(!showErrorInfo) {
			List<ProductVideo> prodVideoList = productVideoService.getProductVideo(params);
			if("Y".equalsIgnoreCase(childVideo)){
				List<String> groupTypes = new ArrayList<String>();
				groupTypes.add(ProdPackageGroup.GROUPTYPE.LINE.name());
				groupTypes.add(ProdPackageGroup.GROUPTYPE.HOTEL.name());
				params.clear();
				params.put("productId", productId);
				params.put("groupTypes", groupTypes);
				List<Long> childIds = prodPackageGroupService.findProductIdsInPackageGroupByParams(params);
				if(CollectionUtils.isNotEmpty(childIds)){
					params.clear();
					params.put("objectIds", childIds);
					List<ProductVideo> childVideoList = productVideoService.selectBatchChildVideo(params);
					if(CollectionUtils.isNotEmpty(childVideoList)){
						for(ProductVideo video : childVideoList){
							video.setChildObjectId(video.getObjectId());
							video.setChildBizCategoryId(video.getBizCategoryId());
							video.setChildVideoId(video.getVideoID());
							video.setChildStatus("Y");
							video.setObjectId(Long.valueOf(productId));
							video.setBizCategoryId(Long.valueOf(categoryId));
							video.setVideoID(null);
						}
						prodVideoList.addAll(childVideoList);
					}
				}
			}
			if(CollectionUtils.isNotEmpty(prodVideoList)){
				for(ProductVideo productVideo : prodVideoList){
					if(productVideo.getChildVideoId() != null) {
						productVideo.setCategoryName(Constant.VST_CATEGORY.getCnNameByStatus(productVideo.getChildBizCategoryId().toString()));
					} else {
						productVideo.setCategoryName(Constant.VST_CATEGORY.getCnNameByStatus(productVideo.getBizCategoryId().toString()));
					}
				}
			}
			model.addAttribute("prodVideoList", prodVideoList);
		}
		return "/prod/video/showProductVideo_local";
	}
	
	/**
	 * 国内添加视频弹出框
	 * @return
	 */
	@RequestMapping(value = "/showAddProductVideo_local")
	public String showAddProductVideo_local(Model model, String productId, String categoryId) {
		model.addAttribute("productId", productId);
		model.addAttribute("categoryId", categoryId);
		return "/prod/video/showAddProductVideo_local";
	}
	
	/**
	 * 国内批量保存视频
	 * @return
	 * @throws IOException
	 */
	@RequestMapping(value = "/saveBatchVideo")
	@ResponseBody
	public Object saveBatchVideo(@Param("datajson")String datajson) {
		List<ProductVideo> productVideos = JSONObject.parseArray(datajson, ProductVideo.class);
		if(CollectionUtils.isNotEmpty(productVideos)){
			for(ProductVideo productVideo : productVideos){
				productVideo.setVideoCcId(productVideo.getVideoCcId().trim());
				if(productVideo.getVideoID() == null){
					productVideo.setObjectType(ProductVideo.OBJECT_TYPE.PRODUCT_ID.getName());
					productVideoService.addProductVideo(productVideo);
				}else{
					productVideoService.updateProductVideo(productVideo);
				}
			}
			MemcachedUtil.getInstance().remove(MemcachedEnum.ProductVideoList.getKey() + productVideos.get(0).getObjectId());
		}
		return new ResultMessage("success", "success");
	}
	
	/**
	 * 国内删除视频
	 * @param productVideo
	 * @param key
	 * @return
	 */
	@RequestMapping(value = "/updateProductVideo_local")
	@ResponseBody
	public Object updateProductVideo_local(ProductVideo productVideo, String fieldModify) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("videoID", productVideo.getVideoID());
		int result = 0;
		
		if (fieldModify.equals("status")) {
			result = productVideoService.deleteProductVideo(params);
			
			// -1 删除需要级联删除同时要清同步到的product 的cache
			if(productVideo.getStatus().equalsIgnoreCase("-1")) {
				params.clear();
				params.put("childVideoId", productVideo.getVideoID());
				
				// 缓存操作 必须先更新缓存，否则查询不到数据
				List<Long> updateStatusByChildVideoIDList = productVideoService.getUpdateStatusByChildVideoID(params);
				if(updateStatusByChildVideoIDList !=null && updateStatusByChildVideoIDList.size() > 0) {
					for(Long updateStatusByChildVideoID : updateStatusByChildVideoIDList) {
						MemcachedUtil.getInstance().remove(MemcachedEnum.ProductVideoList.getKey() + updateStatusByChildVideoID);
					}
				}
				
				// 表操作
				productVideoService.deleteByChildVideoID(params);
				
			}
		}
		
		// 清除缓存
		if (result == 1) {
			MemcachedUtil.getInstance().remove(MemcachedEnum.ProductVideoList.getKey() + productVideo.getObjectId());
			if(productVideo.getStatus()!=null && productVideo.getStatus().equalsIgnoreCase("-1")){
				return new ResultMessage("success", "删除成功");
			}else {
				return new ResultMessage("success", "修改成功");
			}
		} else {
			if(productVideo.getStatus()!=null && productVideo.getStatus().equalsIgnoreCase("-1")){
				return new ResultMessage("error", "删除失败");
			} else {
				return new ResultMessage("error", "修改失败");
			}
		}
	}
	
	
	/**
	 * 添加视频弹出框
	 * @param productId
	 * @param categoryId
	 * @return
	 */
	@RequestMapping(value = "/showAddProductVideo")
	public String showAddProductVideo(String productId, String categoryId) {
		HttpServletLocalThread.getModel().addAttribute("productId", productId);
		HttpServletLocalThread.getModel().addAttribute("categoryId", categoryId);
		return "/prod/video/showAddProductVideo";
	}

	/**
	 * 保存视频按钮
	 * @param productVideo
	 * @param photoUrlFile
	 * @return
	 * @throws IOException
	 */
	@RequestMapping(value = "/addProductVideo")
	@ResponseBody

	public Object AddProductVideo(ProductVideo productVideo) throws IOException {
	
			productVideo.setObjectType(ProductVideo.OBJECT_TYPE.PRODUCT_ID.getName());
			productVideo.setVideoCcId(productVideo.getVideoCcId().trim());
			if (productVideoService.addProductVideo(productVideo) == 1) {
				if(!productVideo.getSeq().equals("0")) {
					MemcachedUtil.getInstance().remove(MemcachedEnum.ProductVideoList.getKey() + productVideo.getObjectId());
				}
				return new ResultMessage("success", "添加成功");
			} else {
				return new ResultMessage("error", "添加失败");
			}

	}


	/**
	 * 更新视频&删除视频
	 * @param productVideo
	 * @param key
	 * @return
	 */
	@RequestMapping(value = "/updateProductVideo")
	@ResponseBody
	public Object updateProductVideo(ProductVideo productVideo, String fieldModify) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("videoID", productVideo.getVideoID());
		int result = 0;
		
		if (fieldModify.equals("status")) {
			params.put("status", productVideo.getStatus());
			result = productVideoService.updateStatus(params);
			
			// -1 删除需要级联删除同时要清同步到的product 的cache
			if(productVideo.getStatus().equalsIgnoreCase("-1")) {
				Map<String, Object> updateStatusByChildVideoIDParams = new HashMap<String, Object>();
				updateStatusByChildVideoIDParams.put("childVideoId", productVideo.getVideoID());
				
				// 缓存操作 必须先更新缓存，否则查询不到数据
				List<Long> updateStatusByChildVideoIDList = productVideoService.getUpdateStatusByChildVideoID(updateStatusByChildVideoIDParams);
				if(updateStatusByChildVideoIDList !=null && updateStatusByChildVideoIDList.size() > 0) {
					for(Long updateStatusByChildVideoID : updateStatusByChildVideoIDList) {
						MemcachedUtil.getInstance().remove(MemcachedEnum.ProductVideoList.getKey() + updateStatusByChildVideoID);
					}
				}
				
				// 表操作
				LOG.info("ProdVideoAction.updateProductVideo: Start----------删除视频开始");
				productVideoService.updateStatusByChildVideoID(updateStatusByChildVideoIDParams);
				LOG.info("ProdVideoAction.updateProductVideo: End----------删除视频结束");
				
			}
		} else if (fieldModify.equals("seq")) {
			params.put("seq", productVideo.getSeq());
			result = productVideoService.updateVideoSeq(params);
		} else if (fieldModify.equals("videoCcJscode")) {
			params.put("videoCcJscode", productVideo.getVideoCcJscode());
			result = productVideoService.updateVideoCcJscode(params);
		}
		
		// 清除缓存
		if (result == 1) {
			MemcachedUtil.getInstance().remove(MemcachedEnum.ProductVideoList.getKey() + productVideo.getObjectId());
			if(productVideo.getStatus()!=null && productVideo.getStatus().equalsIgnoreCase("-1")){
				return new ResultMessage("success", "删除成功");
			}else {
				return new ResultMessage("success", "修改成功");
			}
		} else {
			if(productVideo.getStatus()!=null && productVideo.getStatus().equalsIgnoreCase("-1")){
				return new ResultMessage("error", "删除失败");
			} else {
				return new ResultMessage("error", "修改失败");
			}
		}
	}
}
