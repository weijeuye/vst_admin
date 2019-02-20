package com.lvmama.vst.back.prod.vo;

import org.codehaus.jackson.annotate.JsonIgnoreProperties;

import com.lvmama.vst.back.prod.po.ProdGroupDate;
import com.lvmama.vst.back.prod.po.ProdProduct;
import com.lvmama.vst.back.prod.po.ProdRefund;

/*
 * 用于页面展示
 */
@JsonIgnoreProperties({"product", "prodGroupDate"})
public class ProdRefundExt extends ProdRefund {
	private static final long serialVersionUID = 4286600800588284876L;
	
	private ProdGroupDate prodGroupDate;
	
	private String aheadBookTimeStr;
	
	private String lowestSaledPriceStr;
	
	private ProdProduct product;
	
	public ProdGroupDate getProdGroupDate() {
		return prodGroupDate;
	}

	public void setProdGroupDate(ProdGroupDate prodGroupDate) {
		if (prodGroupDate == null) {
			return;
		}
		this.prodGroupDate = prodGroupDate;
		this.calAheadBookTimeStr();

		// 非多出发地才显示起价
		if (prodGroupDate != null && product != null && !"Y".equals(product.getMuiltDpartureFlag())) {
			this.lowestSaledPriceStr = prodGroupDate.getLowestSaledPriceYuan();
		}
	}

	public ProdRefundExt(ProdRefund prodRefund, ProdProduct product) {
		this.product = product;
		this.setCancelStrategy(prodRefund.getCancelStrategy());
		this.setEndDate(prodRefund.getEndDate());
		this.setGoodsRefundRules(prodRefund.getGoodsRefundRules());
		this.setProdRefundRules(prodRefund.getProdRefundRules());
		this.setProductId(prodRefund.getProductId());
		this.setRefundId(prodRefund.getRefundId());
		this.setSpecDate(prodRefund.getSpecDate());
		this.setSpecDates(prodRefund.getSpecDates());
		this.setStartDate(prodRefund.getStartDate());
		this.setWeekDay(prodRefund.getWeekDay());
		this.setAheadBookTime(prodRefund.getAheadBookTime());
		calAheadBookTimeStr();
	}

	
	private void calAheadBookTimeStr() {
		StringBuilder sb = new StringBuilder();
		//如果团期表有就使用团期的，否则使用退改规则上的设置
		Long realAheadBookTime = getAheadBookTime();
		if (this.prodGroupDate != null && prodGroupDate.getAheadBookTime() != null
				&& prodGroupDate.getAheadBookTime() != 0) {
			realAheadBookTime = prodGroupDate.getAheadBookTime();
		}
		if(realAheadBookTime != null && realAheadBookTime != 0) {
			if(realAheadBookTime < 0) {
				realAheadBookTime = - realAheadBookTime;
				//表示当天，显示为
				sb.append(0).append("天").append((int)(realAheadBookTime/60)).append("点").append(realAheadBookTime%60).append("分");
			} else {
				//必须要转换成double运算，不然小数为0
				int totalDays = (int)Math.ceil(realAheadBookTime/(24*60d));
				long minutes = totalDays * 24 *60 - realAheadBookTime;
				sb.append(totalDays).append("天").append((int)(minutes/60)).append("点").append(minutes%60).append("分");
			}
		}
		aheadBookTimeStr =  sb.toString();
	}

	public String getAheadBookTimeStr() {
		return aheadBookTimeStr;
	}

	public void setAheadBookTimeStr(String aheadBookTimeStr) {
		this.aheadBookTimeStr = aheadBookTimeStr;
	}

	public String getLowestSaledPriceStr() {
		return lowestSaledPriceStr;
	}

	public void setLowestSaledPriceStr(String lowestSaledPriceStr) {
		this.lowestSaledPriceStr = lowestSaledPriceStr;
	}

	public ProdProduct getProduct() {
		return product;
	}

	public void setProduct(ProdProduct product) {
		this.product = product;
	}
}
