package com.lvmama.vst.back.prod.web.hotel;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.lvmama.vst.comm.vo.MemcachedEnum;
import com.lvmama.vst.comm.utils.MemcachedUtil;
import com.lvmama.vst.comm.web.BaseActionSupport;

@Controller
@RequestMapping("/prod/cache")
public class ProdProductHotelCacheAction{

	@ResponseBody
    @RequestMapping(value= "/cacheQuery", produces = "application/json; charset=utf-8")
	public String queryCache(String key){
		try {
			Object memObject = MemcachedUtil.getInstance().get(key);
			if(memObject!=null){
				return "cache exists! (非开发人员请忽略后面)"+ new Gson().toJson(memObject);
			}else{
				return "cache doesnot exist!";
			}
		} catch (Exception e) {
			return "system error, please try again";
		}
	}
	
	@ResponseBody
    @RequestMapping(value= "/cacheClean", produces = "application/json; charset=utf-8")
	public String clearCache(String key){
		try {
			boolean bb = MemcachedUtil.getInstance().keyExists(key);
			if(bb){
				MemcachedUtil.getInstance().remove(key);
				return "cache clean success";
			}else{
				return "cache doesnot exist!";
			}
		} catch (Exception e) {
			return "system error, please try again";
		}
	}
	
	public static void main(String args[]){
		boolean s = MemcachedUtil.getInstance().set(MemcachedEnum.ProductVideoList.getKey() + "123456", MemcachedEnum.ProductVideoList.getSec(), "test");
		System.out.println(s);
	}
}
