package com.lvmama.vst.back.prod.scenicHotel;

import com.lvmama.vst.back.dujia.comm.prod.po.ProdProductDescription;
import com.lvmama.vst.back.prod.po.ScenicHotelTravelAlertVo;

public class ScenicHotelTravelAlertWrapperVo {
	
	private ScenicHotelTravelAlertVo travelAlert;
	private ProdProductDescription productDesc;
	
	//产品的版本， 便于初始化
	private double modelVersion;
	
	public ScenicHotelTravelAlertVo getTravelAlert() {
		return travelAlert;
	}
	public void setTravelAlert(ScenicHotelTravelAlertVo travelAlert) {
		this.travelAlert = travelAlert;
	}
	public ProdProductDescription getProductDesc() {
		return productDesc;
	}
	public void setProductDesc(ProdProductDescription productDesc) {
		this.productDesc = productDesc;
	}
	
	public double getModelVersion() {
		return modelVersion;
	}
	public void setModelVersion(double modelVersion) {
		this.modelVersion = modelVersion;
	}
	
}
