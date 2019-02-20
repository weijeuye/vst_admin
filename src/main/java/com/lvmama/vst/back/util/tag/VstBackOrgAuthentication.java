/**
 * 
 */
package com.lvmama.vst.back.util.tag;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.lvmama.vst.back.client.goods.service.SuppGoodsClientService;
import com.lvmama.vst.back.goods.po.SuppGoodsBaseTimePrice;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.tld.VstOrgAuthentication;
/**
 * vst_back组织鉴权类
 * 2015-09-24
 */
public class VstBackOrgAuthentication extends VstOrgAuthentication{

	@Autowired
	private SuppGoodsClientService suppGoodsService;
	
	public VstBackOrgAuthentication(Log LOG, HttpServletRequest req,
			HttpServletResponse resp) {
		super(LOG, req, resp);
	}

	/**
	 * 设置日历价格消息的vst组织权限
	 * @param list
	 */
	public void setPermission(List<?> list){
		
		//不走vst组织权限
		if(CollectionUtils.isEmpty(list) || !this.isAuthentication()) return;
		
		Map<Long, Boolean> permissionMap =new HashMap<Long, Boolean>();//商品-vst组织权限
		for (Object obj : list) {
			loadPermission((SuppGoodsBaseTimePrice)obj, permissionMap);
		}
		
	}
	private void loadPermission(SuppGoodsBaseTimePrice sbt, Map<Long, Boolean> permissionMap){
		try{
			if(null == this.getPermUser()){
				sbt.setPermission(false);
				return;
			}
			//取值
			if(permissionMap.containsKey(sbt.getSuppGoodsId())){
				sbt.setPermission(permissionMap.get(sbt.getSuppGoodsId()));
				return;
			}
			//只有商品经理才能查看到结算价
			HashMap<String, Object> params = new HashMap<String, Object>();
			params.put("suppGoodsId", sbt.getSuppGoodsId());
			WebApplicationContext context =WebApplicationContextUtils.getWebApplicationContext(req.getSession().getServletContext());
			suppGoodsService =(SuppGoodsClientService) context.getBean(SuppGoodsClientService.class);
			List<Long> mList =suppGoodsService.findSuppGoodsManagerIdList(params);
			
			//存值,鉴权
			permissionMap.put(sbt.getSuppGoodsId(), CollectionUtils.isNotEmpty(mList)?
					this.authentication(String.valueOf(mList.get(0))):false);
			sbt.setPermission(permissionMap.get(sbt.getSuppGoodsId()));
			
		}catch(Exception e){
			LOG.error(ExceptionFormatUtil.getTrace(e));
		}
	}
	
}
