package com.lvmama.vst.back.goods.web;

import com.lvmama.dest.api.utils.DynamicRouterUtils;
import com.lvmama.vst.comm.web.BusinessException;
import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsGroupClientService;
import com.lvmama.vst.back.client.goods.service.SuppGoodsGroupStockClientService;
import com.lvmama.vst.back.client.pub.service.ComLogClientService;
import com.lvmama.vst.back.goods.adapter.SuppGoodsGroupAdapter;
import com.lvmama.vst.back.goods.po.SuppGoods;
import com.lvmama.vst.back.goods.po.SuppGoodsGroup;
import com.lvmama.vst.back.goods.po.SuppGoodsGroupStock;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.service.ProdProductQueryService;
import com.lvmama.vst.back.pub.po.ComLog;
import com.lvmama.vst.back.pub.po.ComLog.COM_LOG_OBJECT_TYPE;
import com.lvmama.vst.back.router.adapter.ProdProductHotelAdapterService;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.CalendarUtils;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.utils.StringUtil;
import com.lvmama.vst.comm.vo.Page;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

/**
 * 设置共享库存Action
 * 
 * @author
 * @date 2013-12-11
 */
@SuppressWarnings("serial")
@Controller
@RequestMapping("/goods/goodsGroup")
public class SuppGoodsGroupAction extends BaseActionSupport {
	private static final Log LOG = LogFactory.getLog(SuppGoodsGroupAction.class);

	@Autowired
	private SuppGoodsClientService suppGoodsService;

	@Autowired
	private SuppGoodsGroupClientService suppGoodsGroupService;

	@Autowired
	private SuppGoodsGroupStockClientService suppGroupStockService;

	@Autowired
	private ComLogClientService comLogService;
	
	@Autowired
	private ProdProductQueryService prodProductQueryService;

	@Autowired
	private ProdProductHotelAdapterService prodProductHotelAdapterService;

	@Autowired
	private SuppGoodsGroupAdapter suppGoodsGroupAdapter;
	/***
	 * 显示库存共享列表 根据产品id加载共享组列表， 加载规则如下： 
	 * 1.该产品下有共享组的商品以及和该商品所属同一个共享组的其它产品的商品；
	 * 2.按照所属共享组分组显示
	 * add by zhoudengyun
	 * @return
	 */
	@RequestMapping(value = "/showSuppInventorySharingList")
	public String showSuppInventorySharingList(Model model, Integer page, Long productId,Long categoryId, HttpServletRequest request) throws BusinessException {
		if (productId != null) {
			if(DynamicRouterUtils.getInstance().isHotelSystemOnlineEnabled()){
				return "redirect:http://super.lvmama.com/lvmm_dest_back/goods/goodsGroup/showSuppInventorySharingList.do?productId="+productId+"&categoryId="+categoryId;
			}
			// 获取产品信息
			ProdProduct product = prodProductHotelAdapterService.findProdProductByIdFromCache(productId);
			model.addAttribute("product", product);
			//构建分页查询
			long pagenum = page == null ? 1 : page;
			Page<SuppGoods> pageParam = Page.page(10, pagenum);
			pageParam.buildUrl(request);
			// 获取商品组以及组内商品信息
			List<SuppGoodsGroup> suppGoodsGroupList = suppGoodsGroupAdapter.findSuppGoodsGroupByProductId(pageParam,productId);
			if(CollectionUtils.isNotEmpty(suppGoodsGroupList)) {
				for (SuppGoodsGroup suppGoodsGroup : suppGoodsGroupList) {
					Page newpageParam = Page.page(suppGoodsGroup.getTotalCount(),10, pagenum);
					String groupName = suppGoodsGroup.getGroupName();
					newpageParam.buildUrl(request);
					String url = newpageParam.getUrl();
					if(StringUtil.isNotEmptyString(url))
					{
						String str1 = "showSuppInventorySharingList.do?";
						String str2 = "showSuppInventorySharingList.do?groupName="+groupName+"&";
						String newUrl = url.replaceAll(str1,str2);
						int location = newUrl.lastIndexOf("?");
						String lastUrl = removeCharAt(newUrl,location);
						newpageParam.setUrl(lastUrl);
					}
					suppGoodsGroup.setPage(newpageParam);
				}
			}
			model.addAttribute("suppGoodsGroupList", suppGoodsGroupList);
		}
		model.addAttribute("productId", productId);
		return "/goods/goodsGroup/findSuppInventorySharingListNew";
	}

	/***
	 * 	显示新增库存共享组页面 
	 * add by zhoudengyun 201504091324
	 * @param model
	 * @param productId
	 * @param groupId
	 * @return
	 * @throws BusinessException
	 */
	@RequestMapping(value = "/showCreateInventoryGroup")
	public String showCreateInventoryGroup(Model model, Long productId, Long groupId) throws BusinessException {
		model.addAttribute("productId", productId);
		model.addAttribute("groupId", groupId);

		return "/goods/goodsGroup/showCreateInventoryGroup";
	}

	/***
	 * 将商品加入共享组或者创建共享组；
	 * add by zhoudengyun201504091536
	 * @return
	 */
	@RequestMapping(value = "/AddInventorySharing")
	@ResponseBody
	public Object AddInventorySharing(Long[] goodsIds, Long groupId, Long productId) throws BusinessException {
		if (goodsIds != null && goodsIds.length > 0) {
			List<Long> suppGoodsIdList = Arrays.asList(goodsIds);

			// 删除ID为空的，并校验ID是否重复
			List<Long> suppGoodsIdAvailable = new ArrayList<Long>();
			for (Long id : suppGoodsIdList) {
				if (suppGoodsIdAvailable.contains(id)) {
					return new ResultMessage("ERROR", "商品ID或商品套餐ID重复");
				}
				if (id != null) {
					suppGoodsIdAvailable.add(id);
				}
			}

			// 判断共享组添加商品是否大于10
			if (suppGoodsIdAvailable.size() > 10) {
				return new ResultMessage("ERROR", "共享组内商品数量大于10");
			}

			String userName = this.getLoginUser() != null ? this.getLoginUser().getUserName() : "";
			try {
				if (groupId == null) {
					// 创建组
					suppGoodsGroupService.saveSuppGoodsGroup(suppGoodsIdAvailable, productId, userName);
				} else {
					// 添加商品
					suppGoodsGroupService.saveSuppGoods(suppGoodsIdAvailable, groupId, productId, userName);
				}
			} catch (Exception e) {
				LOG.info(e.getStackTrace());
				return new ResultMessage("ERROR", e.getMessage());
			}
		}

		return ResultMessage.ADD_SUCCESS_RESULT;
	}

	/***
	 * 显示更新库存共享页面  可以删除
	 * 
	 * @return
	 */
/*	@RequestMapping(value = "/showUpdateGoodsGroup")
	public String showUpdateGoodsGroup(Model model, SuppGoods suppGoods) throws BusinessException {
		if (LOG.isDebugEnabled()) {
			LOG.debug("start method<showUpdateGoodsGroup>");
		}
		model.addAttribute("groupId", suppGoods.getGroupId());
		suppGoods.setCancelFlag("Y");
		List<SuppGoods> suppGoodsList = suppGoodsGroupService.findSuppGoodsByGoods(suppGoods);
		model.addAttribute("suppGoodsList", suppGoodsList);
		model.addAttribute("supplierId", suppGoods.getSupplierId());
		return "/goods/goodsGroup/showUpdateInventorySharing";
	}*/

	/***
	 * 删除库存共享组中的商品
	 * add by zhoudengyun20150410
	 * @return
	 */
	@RequestMapping(value = "/deleteGoodsFromGroup")
	@ResponseBody
	public Object deleteGoodsFromGroup(Model model, Long goodsId) {
		String userName = this.getLoginUser() != null ? this.getLoginUser().getUserName() : "";
		ResultMessage rm = ResultMessage.DELETE_SUCCESS_RESULT;
		try {
			rm = MiscUtils.autoUnboxing( suppGoodsGroupService.deleteSuppGoodsFromGroup(goodsId, userName) );
		} catch (Exception e) {
			return new ResultMessage("ERROR", e.getMessage());
		}
		return rm;
	}

	/**
	 * 进入共享库存添加页面 add by zhoudengyun
	 * 
	 * @param groupId
	 * @return
	 */
	@RequestMapping("/showSuppGoodsGroupStock")
	public String showSuppGoodsGroupStock(Model model, Long groupId, String groupName, Long suppGoodsId) {
		model.addAttribute("groupId", groupId);
		model.addAttribute("groupName", groupName);
		SuppGoods suppGoods =  MiscUtils.autoUnboxing( suppGoodsService.findSuppGoodsById(suppGoodsId) );
		model.addAttribute("goodsName", suppGoods.getGoodsName());
		return "/goods/goodsGroup/showSuppGoodsGroupStock";
	}

	/**
	 * 加载共享组对应的当前月的库存列表
	 * add by zhoudengyun
	 * @param model
	 * @param groupId
	 * @param specDate
	 * @return
	 */
	@RequestMapping("/loadGroupStockData")
	@ResponseBody
	public Object showSuppGoodsGroupStock(Model model, Long groupId, Date specDate) {
		if (groupId == null || specDate == null) {
			return new Object();
		}
		Date beginDate = CalendarUtils.getFirstDayOfMonth(specDate);
		Date endDate = CalendarUtils.getLastDayOfMonth(specDate);
		List<SuppGoodsGroupStock> stockList = MiscUtils.autoUnboxing(
				suppGroupStockService.selectBySpecDateRangeAndGroupId(groupId, beginDate, endDate) );

		return stockList;
	}

	/**
	 * 保存新增的共享组库存 add by zhoudengyun20150412
	 * 
	 * @param groupId
	 * @return
	 */
	@RequestMapping("/addSuppGoodsGroupStock")
	@ResponseBody
	public Object addSuppGoodsGroupStock(Model model, SuppGoodsGroupStock goddsGroupStock, Date startDate, Date endDate, Integer[] weekDay) {
		if (startDate == null || endDate == null || weekDay == null) {
			return new ResultMessage("ERROR", "关键字段不允许为空，请选择");
		}
		if (goddsGroupStock.getStock() == null || goddsGroupStock.getStock() < 0) {
			return new ResultMessage("ERROR", "非法库存量，请重新设置");
		}

		List<Date> specDateList = CalendarUtils.getDates(startDate, endDate, Arrays.asList(weekDay));
		if (specDateList == null || specDateList.size() == 0) {
			return new ResultMessage("ERROR", "选择日期范围内不存在对应的星期");
		}

		String userName = this.getLoginUser() != null ? this.getLoginUser().getUserName() : "";
		ResultMessage rm = ResultMessage.ADD_SUCCESS_RESULT;
		try {
			rm = MiscUtils.autoUnboxing( suppGroupStockService.saveSuppGoodsGroupStock(goddsGroupStock, specDateList, userName) );
		} catch (Exception e) {
			return new ResultMessage("ERROR", e.getMessage());
		}

		return rm;
	}

	/**
	 * 根据共享组ID和日期删除当天库存 
	 * add by zhoudengyun
	 * @param model
	 * @param specDate
	 * @param groupId
	 * @return
	 */
	@RequestMapping("/deleteSuppGoodsGroupStock")
	@ResponseBody
	public Object deleteSuppGoodsGroupStock(Model model, String specDate, Long groupId) {
		ResultMessage rm = ResultMessage.DELETE_SUCCESS_RESULT;
		if (StringUtil.isEmptyString(specDate)) {
			return new ResultMessage("ERROR", "日期不允许为空");
		}
		try {
			Date specDateReal = CalendarUtils.getDateFormatDate(specDate, "yyyy-MM-dd");
			String userName = this.getLoginUser() != null ? this.getLoginUser().getUserName() : "";
			rm = MiscUtils.autoUnboxing( suppGroupStockService.deleteSuppGoodsGroupStock(specDateReal, groupId, userName) );
		} catch (Exception e) {
			LOG.error(ExceptionFormatUtil.getTrace(e));
			return new ResultMessage("ERROR", e.getMessage());
		}

		return rm;
	}

	/**
	 * 日志列表展示
	 * add by zhoudengyun
	 * @param groupId
	 * @return
	 */
	@RequestMapping("/showComLog")
	public String showComLog(Model model, Long groupId) {
		List<ComLog> comlogList = MiscUtils.autoUnboxing( comLogService.getComLogByObjectIdAndType(groupId, COM_LOG_OBJECT_TYPE.SUPP_GOODS_GROUP.name()) );
		model.addAttribute("comlogList", comlogList);
		return "/goods/goodsGroup/showComLog";
	}
	
	public String removeCharAt(String s, int pos) {
	      return s.substring(0, pos) + s.substring(pos + 1);
	   }
	
	@RequestMapping(value = "/showSuppInventorySharingListData")
	public String showSuppInventorySharingListData(Model model, Integer page, Long productId,HttpServletRequest request) throws BusinessException {
		if (productId != null) {
			// 获取产品信息
			ProdProduct product = prodProductQueryService.findProdProductSimpleById(productId);
			model.addAttribute("product", product);
			String groupName = request.getParameter("groupName");
			List<SuppGoods> suppGoodsList=null;
			String groupNameValue="";
			//构建分页查询
			long pagenum = page == null ? 1 : page;
			Page pageParam = Page.page(10, pagenum);
			pageParam.buildUrl(request);
			// 获取商品组以及组内商品信息
			List<SuppGoodsGroup> suppGoodsGroupList = suppGoodsGroupService.findSuppGoodsGroupByProductIdWithPage(pageParam,productId);
			if(suppGoodsGroupList !=null){
				for(int i=0;i< suppGoodsGroupList.size();i++){
					if(StringUtil.isNotEmptyString(groupName)){
						SuppGoodsGroup  suppGoodsGroup = suppGoodsGroupList.get(i);
					    groupNameValue = suppGoodsGroup.getGroupName();
					    if(!groupNameValue.equals(groupName)){
					    	suppGoodsGroupList.remove(i);
					         i--;
					    }else if(groupName.equals(groupNameValue)){
							Page newpageParam = Page.page(suppGoodsGroup.getTotalCount(),10, pagenum);
							newpageParam.buildUrl(request);
							suppGoodsGroup.setPage(newpageParam);
							suppGoodsList = suppGoodsGroup.getSuppGoodsList();
						}
				  }
				}
			}
			model.addAttribute("suppGoodsGroupList", suppGoodsGroupList);
			pageParam.setItems(suppGoodsList);
			model.addAttribute("groupName",groupNameValue);
			model.addAttribute("pageParam", pageParam);
		}
		model.addAttribute("productId", productId);
		return "/goods/goodsGroup/showSuppInventorySharingListData";
	}
	
	@RequestMapping(value = "/deleteGroupAndGoods")
	@ResponseBody
	public Object deleteGroupAndGoods(Model model, Long groupId) {
		String userName = this.getLoginUser() != null ? this.getLoginUser().getUserName() : "";
		ResultMessage rm = ResultMessage.DELETE_SUCCESS_RESULT;
		try {
			rm = suppGoodsGroupService.deleteGroupAndGoods(groupId, userName);
		} catch (Exception e) {
			return new ResultMessage("ERROR", e.getMessage());
		}
		return rm;
	}
}
