package com.lvmama.vst.back.prod.scenicHotel;

import java.io.Serializable;

import com.lvmama.vst.back.prod.po.ScenicHotelCostExcludeVo;
import com.lvmama.vst.back.prod.po.ScenicHotelCostIncludeVo;

/**
 * 一个form提交两个vo ， 两个vo含有相同的属性会出现问题， 所以再wrap 一次
 */
public class ScenicHotelCostWrapperVo implements Serializable{
	private static final long serialVersionUID = 8513216037545602226L;
	
	private ScenicHotelCostIncludeVo include;
	private ScenicHotelCostExcludeVo exclude;
	public ScenicHotelCostIncludeVo getInclude() {
		return include;
	}
	public void setInclude(ScenicHotelCostIncludeVo include) {
		this.include = include;
	}
	public ScenicHotelCostExcludeVo getExclude() {
		return exclude;
	}
	public void setExclude(ScenicHotelCostExcludeVo exclude) {
		this.exclude = exclude;
	}
}
