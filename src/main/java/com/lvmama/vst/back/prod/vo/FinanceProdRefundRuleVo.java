package com.lvmama.vst.back.prod.vo;

import java.io.Serializable;
import java.util.List;

import com.lvmama.vst.back.prod.po.FinanceProdRefundRule;

public class FinanceProdRefundRuleVo implements Serializable {
	
	private static final long serialVersionUID = 56870789346546879L;
	
	private Long ruleId;
	
	private String cancelStrategy;
	
	private String ruleContent;
	// 产品退改规则
	private List<FinanceProdRefundRule> prodRefundRuleList;	
	
	public Long getRuleId() {
		return ruleId;
	}
	public void setRuleId(Long ruleId) {
		this.ruleId = ruleId;
	}
	public String getCancelStrategy() {
		return cancelStrategy;
	}
	public void setCancelStrategy(String cancelStrategy) {
		this.cancelStrategy = cancelStrategy;
	}
	public String getRuleContent() {
		return ruleContent;
	}
	public void setRuleContent(String ruleContent) {
		this.ruleContent = ruleContent;
	}
	public List<FinanceProdRefundRule> getProdRefundRuleList() {
		return prodRefundRuleList;
	}
	public void setProdRefundRuleList(List<FinanceProdRefundRule> prodRefundRuleList) {
		this.prodRefundRuleList = prodRefundRuleList;
	}
	
}
