<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>编辑预控</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/resource-edit-control.css"/>
    <style>
 		.paging a {padding: 5px;}
	</style>
</head>
<body class="resource-add-control">
<div class="main">
    <form id="saveButton">
        <input type="hidden" name="id" value="${resPrecontrolPolicy.id}" />
        <input type="hidden" id="resDate" value= "${resPrecontrolPolicy.tradeExpiryDate?string("yyyy-MM-dd")}"/>
        <input type="hidden" name="isCanDelay" value="N" />
       
        <dl class="clearfix">
            <dt>
                <label for="ControlName">
                    <span class="text-danger">*</span> 预控名称：
                </label>
            </dt>
            <dd>
                <div class="form-group col mr10">
                    <input name="ControlName" id="ControlName" type="text" class="form-control w200 JS_pre_name"
                           value="${resPrecontrolPolicy.name}"data-validate="{required:true}" disabled="disabled"/>
                     <input id="id" name="id"  value="${resPrecontrolPolicy.id}" type="hidden" /> 
                     <input id="controlType" name="controlType"  value="${resPrecontrolPolicy.controlType}" type="hidden"/>
                     <input id="amount" name="amount"  value="${resPrecontrolPolicy.amount}" type="hidden"/>
                     <input id="leave"  name="leave"   value="${num}"  type="hidden"/>
                     <input id="changeSum"  name="changeSum"     type="hidden"/>
                     <input id="changeLeave"  name="changeLeave"   type="hidden"/>
                     <input name="controlClassification" value="${resPrecontrolPolicy.controlClassification}" type="hidden"/>
                </div>

                <span class="text-gray"></span>
            </dd>
            <dt>
                <label for="ProviderName">
                    <span class="text-danger">*</span> 供应商名称：
                </label>
            </dt>
            <dd>
                <div class="form-group">
                    <input name="ProviderName" id="ProviderName" value="${resPrecontrolPolicy.supplierName}" type="text"
                           class="form-control search w200 JS_autocomplete_pn"
                           data-validate="{required:true}" disabled="disabled"/>
                    <input type="hidden" class="JS_autocomplete_pn_hidden"/>
                </div>
            </dd>
            <dt>
                <label>
                    <span class="text-danger">*</span> 预控方式：
                </label>
            </dt>
            <dd>
                <div class="JS_radio_switch_group">
                    <div class="col w270 JS_radio_switch_box">
                      
                        <label>
                        <#if resPrecontrolPolicy.controlType == "amount">
                            预控金额              
                            <input name="ControlMode" class="JS_radio_switch" type="radio"
                                   data-validate="{required:true}" checked="checked" disabled="disabled"/>
                                       
                        <span class="form-group">
                        <input type="text" class="form-control JS_control_money_origin w110 JS_radio_disabled" data-validate="{required:true}"
                               readonly="readonly" value="${resPrecontrolPolicy.originAmount}"/>
                        </span>
                                        
                        <#else>
                            <input name="ControlMode" class="JS_radio_switch" type="radio"
                                   data-validate="{required:true}"  disabled="disabled"/>
                                       
                        <span class="form-group">预控金额
                        <input type="text" class="form-control JS_control_money_origin w110 JS_radio_disabled" data-validate="{required:true}"
                               readonly="readonly" />
                        </span>
                                   
                                                 </#if>
                        </label>
                    
                      
                        
                    </div>
                    <div class="col w270 JS_radio_switch_box">
                    <#if resPrecontrolPolicy.controlType == "inventory">
                        <label>
                            <input name="ControlMode" class="JS_radio_switch" type="radio" checked="checked"
                                   data-validate="{required:true}" disabled="disabled"/>
                            预控库存
                        </label>
                        <span class="form-group">
                        <input type="text" class="form-control JS_control_stock_origin w110 JS_radio_disabled" data-validate="{required:true}"
                               value="${resPrecontrolPolicy.originAmount}" disabled="disabled"/>
                        </span>
                   <#else>
                        <label>
                            <input name="ControlMode" class="JS_radio_switch" type="radio"
                                   data-validate="{required:true}" disabled="disabled"/>
                          预控库存       
                        </label>
                         <span class="form-group">
                        <input type="text" class="form-control JS_control_stock_origin w110 JS_radio_disabled" data-validate="{required:true}"
                                disabled="disabled"/>
                        </span>
                   </#if>
                      
            </dd>
            <dt>
                <label>
                    <span class="text-danger">*</span> 销售起止日期：
                </label>
            </dt>
            <dd>
                <span class="form-group">
                    <input type="text" placeholder="起始时间" class="form-control datetime w100 JS_sale_date"
                           data-validate="{required:true}" value="${resPrecontrolPolicy.saleEffectDate?string("yyyy-MM-dd")}"
                           readonly="readonly" data-validate-readonly="true" disabled="disabled"/>
                </span>
                -
                <span class="form-group">
                    <input   type="text" placeholder="结束时间" class="form-control datetime w100 JS_sale_date"
                           data-validate="{required:true}" value="${resPrecontrolPolicy.saleExpiryDate?string("yyyy-MM-dd")}"
                           readonly="readonly" data-validate-readonly="true"  disabled="disabled" />
                </span>
            </dd>
            <dt>
                <label>
                    <span class="text-danger">*</span> 游玩起止日期：
                </label>
            </dt>
            <dd>
                <span class="form-group">
                    <input type="text" placeholder="起始时间" class="form-control datetime w100 JS_play_date"
                           data-validate="{required:true}" value="${resPrecontrolPolicy.tradeEffectDate?string("yyyy-MM-dd")}"
                           readonly="readonly" data-validate-readonly="true" disabled="disabled"/>
                </span>
                -
                <span class="form-group">
                    <input id="PreEndTime" name="tradeExpiryDate" type="text" placeholder="结束时间" class="form-control datetime w100 JS_play_date"
                           data-validate="{required:true}" value="${resPrecontrolPolicy.tradeExpiryDate?string("yyyy-MM-dd")}"
                           readonly="readonly" data-validate-readonly="true"/>
                </span>
            </dd>
            <dt>
                <label>
                    <span class="text-danger">*</span> 预控类型：
                </label>
            </dt>
            <dd>
                <div class="form-group">
                    <div class="col w90">
                        <#if resPrecontrolPolicy.controlClassification == "Daily">
                        <label>
                            <input name="controlClassification" value="Daily" type="radio"
                                   data-validate="{required:true}"
                                   class="JS_control_type" disabled="disabled" checked="checked"/>
                            按日预控
                        </label>
                        <#else>
                        <label>
                            <input name="controlClassification" value="Daily" type="radio"
                                   data-validate="{required:true}"
                                   class="JS_control_type" disabled="disabled"/>
                        按日预控
                        </label>
                        </#if>
                    </div>
                     <div class="form-group">
                    <div class="col w90">
                    
                    <#if resPrecontrolPolicy.controlClassification == "Cycle">
                        <label>
                            <input name="controlClassification" value="Cycle" type="radio"
                                   data-validate="{required:true}" checked="checked"
                                   class="JS_control_type" disabled="disabled"/>
                            按周期预控
                        </label>
                        <#else>
                         <label>
                            <input name="controlClassification" value="Cycle" type="radio"
                                   data-validate="{required:true}"
                                   class="JS_control_type" disabled="disabled"/>
                      按周期预控
                        </label>
                        </#if>
                    </div>
                </div>

            </dd>
            
            <dt>
                <label for="ControlName">
                    <span class="text-danger">*</span> 是否测试：
                </label>
            </dt>
            <dd>
                <div class="form-group">
	                <div class="form-group">
	                    <div class="col w90">
	                        <label>
	                            <input name="isTest" type="radio" value="Y" data-validate="{required:true}" <#if resPrecontrolPolicy.isTest=="Y"> checked="checked" </#if>/>
	                            是
	                        </label>
	                    </div>
	                    <div class="col w90">
	                        <label>
	                            <input name="isTest" type="radio" value="N" data-validate="{required:true}" <#if resPrecontrolPolicy.isTest=="N"> checked="checked" </#if>/>
	                            否
	                        </label>
	                    </div>
	                </div>
                </div>
            </dd>
            
            <dt>
                <label>
                    <span class="text-danger">*</span> 能否退还：
                </label>
            </dt>
            <dd>
                <div class="form-group">
                    <div class="col w90">
                    <#if resPrecontrolPolicy.isCanReturn=="Y">
                        <label>
                            <input name="isCanReturn" type="radio" value="Y" checked="checked" />
                            是
                        </label>
                      <#else>
                      <label>
                            <input name="isCanReturn" type="radio"  value="Y" />
                            是
                       </label>
                      </#if>
                    </div>
                     <div class="form-group">
                    <div class="col w90">
                      <#if resPrecontrolPolicy.isCanReturn == "N">
                        <label>
                            <input name="isCanReturn" type="radio"  value="N" checked="checked" />
                            否
                        </label>
                        <#else>
                         <label>
                            <input name="isCanReturn" type="radio" value="N" />
                            否
                        </label>
                        </#if>
                    </div>
                </div>
                <span class="text-gray">注：如果到期卖不完，能否退还给供应商</span>
            </dd>
           <#--  <dt>
                <label>
                    <span class="text-danger">*</span> 能否超卖：
                </label>
            </dt>
            <dd>
                <div class="form-group">
                    <div class="col w90">
                    <#if resPrecontrolPolicy.isCanDelay == "Y">
                        <label>
                            <input name="isCanDelay" type="radio" checked="checked"  value="Y"  />
                            是
                        </label>
                        <#else>
                        <label>
                        <input name="isCanDelay" type="radio" value="Y" />
                            是
                        </label>
                        </#if>
                    </div>
                    <div class="form-group">
                    <div class="col w90">
                      <#if resPrecontrolPolicy.isCanDelay == "N">
                        <label>
                            <input name="isCanDelay" type="radio" value="N"  checked="checked"  />
                            否
                        </label>
                        <#else>
                        <label>
                            <input name="isCanDelay" type="radio" value="N" />
                            否
                        </label>
                        </#if>
                    </div>
                </div>
            </dd>-->
           <#-- <dt>
                <label for="buCode">
                    <span class="text-danger">*</span> 所属BU：
                </label>
            </dt>
            <dd>
                <div class="form-group">
                    <select name="buCode" class="form-control" data-validate="{required:true}" disabled="disabled">
                        <option value="">请选择</option>
                        <option value="LOCAL_BU" <#if resPrecontrolPolicy.buCode == "LOCAL_BU">selected</#if> >国内游事业部</option>
                        <option value="OUTBOUND_BU" <#if resPrecontrolPolicy.buCode == "OUTBOUND_BU">selected</#if>>出境游事业部</option>
                        <option value="DESTINATION_BU" <#if resPrecontrolPolicy.buCode == "DESTINATION_BU">selected</#if>>目的地事业部</option>
                        <option value="TICKET_BU" <#if resPrecontrolPolicy.buCode == "TICKET_BU">selected</#if>>景区玩乐事业群</option>
                        <option value="BUSINESS_BU" <#if resPrecontrolPolicy.buCode == "BUSINESS_BU">selected</#if>>商旅定制事业部</option>
                    </select>
                </div>
            </dd>-->
            <dt>
                <label for="buCode">
                    <span class="text-danger">*</span> 所属BU：
                </label>
            </dt>
            <dd>
                <div class="form-group">
                    <select name="buCode" id="selBuCode" class="form-control" data-validate="{required:true}">
                    	<#if resPrecontrolPolicy.buCode == "">
	                    	<option value="">请选择BU</option>
	                    <#else>
	                     	<option value="${resPrecontrolPolicy.buCode}">${resPrecontrolPolicy.buCnName}</option>
	                    </#if>
				    </select>
			        所属大区
			        <select  name="area1" id="selArea1" class="form-control" >
			        	<#if resPrecontrolPolicy.area1 == null || resPrecontrolPolicy.area1 == "">
	                    	<option value="">请选择大区</option>
	                    <#else>
	                     	<option value="${resPrecontrolPolicy.area1}">${resPrecontrolPolicy.area1CnName}</option>
	                    </#if>
				    </select>
				    <#if resPrecontrolPolicy.area2 == "">
				    	<select class="form-control" name="area2" id="selArea2" style="display:none" >
							<option value="">请选择分区</option>
						</select>
				    <#else>
	                    <select class="form-control" name="area2" id="selArea2" style="display:inline" >
							<option value="${resPrecontrolPolicy.area2}">${resPrecontrolPolicy.area2CnName}</option>
						</select>
	                </#if>
                </div>
            </dd>
            <dt>
                <label>
                    <span class="text-danger">*</span>买断总成本：
                </label>
            </dt>
            <dd>
                <div class="form-group col mr10">
                    <input name="buyoutTotalCostStr" id="buyoutTotalCostStr" type="text" class="form-control w200 JS_buyoutTotalCost" value="${resPrecontrolPolicy.buyoutTotalCostYuanStr}"
                           data-validate="{required:true}"/>
                </div>
                <span id="spanBuyoutTotalCostStr" class="text-gray"></span>
            </dd>
            <dt>
                <label>
                    <span class="text-danger">*</span>预估营业额：
                </label>
            </dt>
            <dd>
                <div class="form-group col mr10">
                    <input name="forecastSalesStr" id="forecastSalesStr" type="text" class="form-control w200 JS_forecastSales" value="${resPrecontrolPolicy.forecastSalesYuanStr}"
                           data-validate="{required:true}"/>
                </div>
                <span id="spanForecastSalesStr" class="text-gray"></span>
            </dd>
            <dt>
                <label>
                    <span class="text-danger">*</span>押金：
                </label>
            </dt>
            <dd>
                <div class="form-group col mr10">
                    <input name="depositAmountStr" id="depositAmountStr" type="text" class="form-control w200 JS_depositAmount" value="${resPrecontrolPolicy.depositAmountYuanStr}"
                           data-validate="{required:true}"/>
                </div>
                <span class="text-gray">*提示：可填写0</span>
                <span id="spanDepositAmountStr" class="text-gray"></span>
            </dd>
            <dt>
                <label>
                    <span class="text-danger">*</span>冠名金额：
                </label>
            </dt>
            <dd>
                <div class="form-group col mr10">
                    <input name="nameAmountStr" id="nameAmountStr" type="text" class="form-control w200 JS_nameAmount" value="${resPrecontrolPolicy.nameAmountYuanStr}"
                           data-validate="{required:true}"/>
                </div>
                 <span class="text-gray">*提示：可填写0</span>
                 <span id="spanNameAmountStr" class="text-gray"></span>
            </dd>
            <dt>
                <label>
                    <span class="text-danger">*</span>项目性质：
                </label>
            </dt>
            <dd> 
                <div class="form-group">
                     <select name="projectNature" id="projectNature" class="form-control" data-validate="{required:true}">
                        <option value="">请选择</option>
                        <option value="buyout" <#if resPrecontrolPolicy.projectNature == "buyout">selected</#if>>买断</option>
                        <option value="predeposit" <#if resPrecontrolPolicy.projectNature == "predeposit">selected</#if>>预存款</option>
                        <option value="monthdeposit" <#if resPrecontrolPolicy.projectNature == "monthdeposit">selected</#if>>押金+月结</option>
                        <option value="depositpredeposit" <#if resPrecontrolPolicy.projectNature == "depositpredeposit">selected</#if>>押金+预存款</option>
                        <option value="name" <#if resPrecontrolPolicy.projectNature == "name">selected</#if>>冠名</option>
                        <option value="buyoutpredeposit" <#if resPrecontrolPolicy.projectNature == "buyoutpredeposit">selected</#if>>买断+预存款</option>
                    </select>
                </div>
            </dd>
            <dt>
                <label>
                    <span class="text-danger">*</span>付款方式：
                </label>
            </dt>
            <dd>
                <div class="form-group">
                    <div class="col w100">
                      <#if resPrecontrolPolicy.payWay == "one">
                        <label>
                            <input name="payWay" type="radio" value="one" checked="checked" data-validate="{required:true}"/>
                            一次全额付款
                        </label>
                      <#else>
                        <label>
                            <input name="payWay" type="radio" value="one" data-validate="{required:true}"/>
                            一次全额付款
                        </label>
                      </#if>
                    </div>
                    <div class="col w100">
                     <#if resPrecontrolPolicy.payWay == "more">
                        <label>
                            <input name="payWay" type="radio" value="more" checked="checked" data-validate="{required:true}"/>
                            多次付款
                        </label>
                     <#else>
                     <label>
                            <input name="payWay" type="radio" value="more" data-validate="{required:true}"/>
                            多次付款
                        </label>
                     </#if>
                    </div>
                </div>
                <span class="text-danger">注：多次付款，请备注说明每次付款时间和金额；</span>
            </dd>
            <dt>
                <label>
                    付款备注：
                </label>
            </dt>
            <dd>
                <div class="form-group col mr10">
                    <textarea id="payMemo" name="payMemo" maxlength=300 style="width:450px; height:70px;" class="form-control w200 JS_payMemo"/>${resPrecontrolPolicy.payMemo}</textarea>
                </div>
                <span id="spanPayMemo" class="text-gray"></span>
            </dd>
            
            <dt>
                <label for="ProductManager">
                    <span class="text-danger">*</span> 产品经理：
                </label>
            </dt>
            <dd>
                <div class="form-group">
                    <input name="productManagerName" id="ProductManager" type="text"
                           class="form-control search w110 JS_autocomplete_pm" value="${resPrecontrolPolicy.productManagerName}"
                           data-validate="{required:true} " />
                    <input name="productManagerId" type="hidden" class="JS_autocomplete_pm_hidden" id="ProductManagerId"
                           value="${resPrecontrolPolicy.productManagerId}" />
                    <input type="hidden" class="JS_autocomplete_pm_hidden_email" id="ProductManagerEmail"
                           name="ProductManagerEmail" value="${productManagerEmail}"/>
                           
                </div>
            </dd>
             <dt>
                <label for="buCode">
                    	 备注：
                </label>
            </dt>
            <dd>
                 <div class="form-group col mr10">
                    <textarea id="memo" name="memo"  maxlength=300 style="width:450px; height:70px;" class="form-control w200 JS_memo"/>${resPrecontrolPolicy.memo}</textarea>
                </div>
                <span id="spanMemo" class="text-gray"></span>
            </dd>
            <dt>
                <label>
                    <span class="text-danger">*</span> 提醒设置：
                </label>
            </dt>
            <dd>
            <#assign x="false"/>
               <div class="form-group">
               <#if resPrecontrolPolicy.controlClassification == "Daily">
                    <!--按日预控 开始-->
                    <#list resWarmRuleList as warm>
                    <#if warm.name=="everyday">
                    <p class="JS_control_type_item " data-type="DailyControl">
                        <label class="checkbox">
                            <input name="code"" type="checkbox" data-validate="{required:true}"
                                 value="everyday" checked="checked"/>
                            每天晚上24点整，发邮件提醒。
                        </label>
                        <#assign x="true"/>
                    </p>
                    </#if>
                    </#list>
                    <#if x=="false">
                        <p class="JS_control_type_item " data-type="DailyControl">
                        <label class="checkbox">
                            <input name="code"" type="checkbox" data-validate="{required:true}"
                                 value="everyday" />
                                    每天晚上24点整，发邮件提醒。
                        </label>
                    </p>
                    </#if>
                    <#assign x="false"/>
                    <!--按日预控 结束-->
                    <#else>
                    <!--按周期预控 开始-->
                    <#list resWarmRuleList as warm>
                    <#if warm.name=="everyweek">
                    <p class="JS_control_type_item " data-type="CycleControl" >
                        <label class="checkbox">
                            <input name="code" type="checkbox" data-validate="{required:true}" value="everyweek" checked="checked"
                                   />
                            从起始时间算起，之后的每个周一，发邮件提醒。
                        </label>
                        <#assign x="true"/>
                    </p>
                    </#if>
                    </#list>
                    <#if x=="false">
                    <p class="JS_control_type_item " data-type="CycleControl" >
                        <label class="checkbox">
                            <input name="code" type="checkbox" data-validate="{required:true}" value="everyweek"
                                   />
                            从起始时间算起，之后的每个周一，发邮件提醒。
                        </label>
                    </p>
                    </#if>
                    <#assign x="false"/>
                    <#list resWarmRuleList as warm>
                    <#if warm.name=="loss">
                    <p class="JS_control_type_item " data-type="CycleControl">
                        <label class="checkbox">
                            <input name="code" type="checkbox" data-validate="{required:true}" value="loss" checked="checked"
                                   />
                            每当“金额/库存”减少
                            
                            <select name ="value" class="form-control">
                              <#if warm.value=="10">
                                <option  value="10" selected = selected>10%</option>
                                <#else>
                                 <option  value="10">10%</option>
                                </#if>
                              <#if warm.value=="20">
                                <option  value="20" selected = selected>20%</option>
                                <#else>
                                <option  value="20">20%</option>
                              </#if> 
                              <#if warm.value=="30"> 
                                <option  value="30" selected = selected>30%</option>
                                <#else>
                                <option  value="30">30%</option>
                              </#if>
                              <#if warm.value=="40"> 
                                <option  value="40" selected = selected>40%</option>
                                <#else>
                                 <option value="40">40%</option>
                               </#if>
                               <#if warm.value=="50">
                                <option  value="50" selected = selected>50%</option>
                                <#else>
                                 <option   value="50">50%</option>
                                </#if>
                                <#if warm.value=="60">
                                <option  value="60" selected = selected>60%</option>
                                <#else>
                                <option value="60">60%</option>
                                </#if>
                                <#if warm.value=="70">
                                <option  value="70" selected = selected>70%</option>
                                <#else>
                                 <option  value="70">70%</option>
                                </#if>
                                <#if warm.value=="80">
                                <option  value="80" selected = selected>80%</option>
                                <#else>
                                 <option  value="80">80%</option>
                                </#if>
                                <#if warm.value=="90">
                                <option value="90" selected = selected>90%</option>
                                <#else>
                                <option  value="90">90%</option>
                                </#if>
                            </select>
                            发邮件提醒。
                        </label>
                        <#assign x="true"/>
                    </p>
                    </#if>
                    </#list>
                    <#if x=="false">
                     <p class="JS_control_type_item " data-type="CycleControl">
                        <label class="checkbox">
                            <input name="code" type="checkbox" data-validate="{required:true}" value="loss"
                                   />
                            每当“金额/库存”减少
                            <select name="value" class="form-control">
                                
                                <option  value="10">10%</option>
                                <option  value="20">20%</option>
                                <option  value="30">30%</option>
                                <option  value="40">40%</option>
                                <option  value="50">50%</option>
                                <option  value="60">60%</option>
                                <option  value="70">70%</option>
                                <option  value="80">80%</option>
                                <option  value="90">90%</option>
                            </select>
                            发邮件提醒。
                        </label>
                    </p>
                    </#if>
                    <#assign x="false"/>
                    <!--按周期预控 结束-->
                    </#if>
                    <#list resWarmRuleList as warm>
                    <#if warm.name=="lossAll">
                    <p>
                        <label class="checkbox">
                            <input name="code" type="checkbox" data-validate="{required:true}" value="lossAll" checked="checked"
                                   />
                            买断“金额/库存”全部消耗完时，发邮件提醒我。
                        </label>
                    </p>
                    <#assign x="true"/>
                    </#if>
                    </#list>
                    <#if x=="false">
                       <p>
                        <label class="checkbox">
                            <input name="code" type="checkbox" data-validate="{required:true}" value="lossAll"
                                   />
                            买断“金额/库存”全部消耗完时，发邮件提醒我。
                        </label>
                    </p>
                    </#if>
                    <#assign x="false"/>
                    <#list resWarmRuleList as warm>
                    <#if warm.name=="finish">
                    <p>
                        <label class="checkbox">
                            <input name="code" type="checkbox" data-validate="{required:true}" value="finish" checked="checked"
                                   />
                            买断期结束时，发邮件提醒我。
                        </label>
                        <#assign x="true"/>
                    </p>
                    </#if>
                    </#list>
                    <#if x=="false">
                        <p>
                        <label class="checkbox">
                            <input name="code" type="checkbox" data-validate="{required:true}" value="finish"
                                   />
                            买断期结束时，发邮件提醒我。
                        </label>
                    </p>
                    </#if>
                </div>
               
            </dd>
            <dt>   </dt>
				            <dd>
				                <div class="col w75">抄送其他人：</div>
				                 <div class="cc_box JS_cc_box clearfix">
				                <#list resPrecontrolWarmReceiverList as recList>
				               
				                    <div class="col w150 cc JS_cc form-group">
				                        <input name="receiverName" type="text"
				                               class="form-control search w110 JS_autocomplete_cc"
				                               data-validate="{required:true}" value="${recList.receiverName}"/>
				                        <input type="hidden" class="JS_autocomplete_cc_hidden" name="ids" value="${recList.receiverId}"/>
				                        <input type="hidden" class="JS_autocomplete_cc_hidden_email" name="email" value="${recList.email}"/>
				                        <a class="text-danger JS_cc_del">X</a>
				                    </div>
				                    
				               
				                </#list>
				                <div class="col cc JS_cc_add">
				                        <a>继续添加</a>
				                    </div>
				                 </div>
				            </dd>
        </dl>
        <!--子预控 start -->
        <div class="text-center">
             <label>
                 <span style="font-weight: bold;font-size: 16px;"> 子预控设置</span> 
             </label>
             <!-- 星云系统中维护 -->
             <#-- <div class="text-right mb5"> 
             	<#if resPrecontrolPolicy.state == "New" || resPrecontrolPolicy.state = "InUse">
             		 <a class="btn btn-primary JS_add_controlItem">新增</a>
             	<#else>
             	 	<a class="btn" disabled="true">新增</a>
            	</#if> 
              </div> -->
        </div>
        <div id="showPolicyItemDiv">
           <div class="resource-table" >
	        <table class="table table-border" style="text-align: center;">
	            <thead>
	                <tr>
	                	<th width="30%">子预控类型</th>
	                    <th width="40%">子预控<span class="text-success">库存</span>/<span class="text-danger">金额</span></th>
	                    <th width="30%">操作</th>
	                </tr>
	            </thead>
	
	        <#if pageParam?? && pageParam.items?? && pageParam.items?size &gt; 0>
	            <tbody>
	                <#list pageParam.items as rs>
	                    <tr>
	                    	<td>
	                            <#if rs.itemControlClass == "add">
	                                                                            追加</td>
	                            <#else>
	                                                                           减少</td>
	                            </#if>
                        	</td>
	                         <td>
	                            <#if rs.itemControlType == "amount">
	                             	<#if rs.itemControlClass == "add">
	                                  	<span class="text-danger">+${rs.quantity}</span>
	                                <#else> 
	                                	<span class="text-danger">-${rs.quantity}</span>
	                                </#if>
	                            <#else>
	                                <#if rs.itemControlClass == "add">
	                                  	<span class="text-success">+${rs.quantity}</span>
	                                <#else> 
	                                	<span class="text-success">-${rs.quantity}</span>
	                                </#if>
	                            </#if>
	                        </td>
	                        <td>
	                            <input name='policyItemId' type="hidden" class="JS_policyItemId" value="${rs.policyItemId}"/>
	                            <input name='itemControlType' type="hidden" class="JS_itemControlType" value="${rs.itemControlType}"/>
	                            <!-- 星云系统中维护 -->
	                            <#-- <a class="mr5 JS_edit_control" data-param="${rs.policyItemId}">修改</a>
	                            <a class="mr5 JS_delete_control" data-param="${rs.policyItemId}">删除</a> -->
	                            <a class="mr5 JS_show_log" data-param="${rs.policyItemId}">操作日志</a>
	                        </td>
	                    </tr>
	                </#list>
	            </tbody>
	        </#if>
	        </table>
	        
			<#if pageParam.items?size == 0>
		        <div class="hint">
		                <span class="icon icon-info"></span>暂无子预控数据
		        </div>
        	</#if>
	       <div class="text-center mt5">
	         	<#if pageParam.items?exists>
					<div class="paging">
					    ${pageParam.getPagination()}
					</div>
				</#if>
	       </div>
	
	    </div>
        
        </div>
		<!--子预控 end -->
		
        <div class="btn-group text-center">
            <#-- <a class="btn btn-primary JS_btn_save">保存</a> -->
            <a class="btn JS_btn_cancel  quxiao">取消</a>
        </div>
    </form>
</div>

<!--模板 开始-->
<div class="template">

    <!--抄送 开始-->
    <div class="col w150 cc JS_cc form-group">
        <input name="receiverName" type="text" class="form-control search w110 JS_autocomplete_cc" data-validate="{required:true}"/>
        <a class="text-danger JS_cc_del">X</a>
        <input type="hidden" class="JS_autocomplete_cc_hidden" name="ids"/>
        <input type="hidden" class="JS_autocomplete_cc_hidden_email" name="email"/>
    </div>
    <!--抄送 结束-->

</div>
<!--模板 结束-->

<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/pandora-calendar.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/resource-edit-control.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/resource-add-control.js"></script>
<script>
    var flag=true;
    var $document = $(document);
    $document.on("blur", ".w50", function() {
     var amount=$("#amount").val();
     var a=Number(amount);
     var sum=$("#leave").val();
     var ss=Number(sum);
     var type=$("#controlType").val();
     if(type=="amount"){
       var c=$("#cc").val();
       var cc=Number(c);
      var add=$("#aa").attr("style");
      if(add=="display: inline-block;"){
         var addLeave=ss+cc;
         var addAmount=a+cc;
         $("input[name='changeSum']").attr("value", addAmount);
         $("input[name='changeLeave']").attr("value", addLeave);
      }else{
         var lessLeave=ss-cc;
         var lessAmount=a-cc;
         if(lessLeave<0){
         alert("剩余量不足");
         flag=false;
         }else{
         $("input[name='changeSum']").attr("value", lessAmount);
         $("input[name='changeLeave']").attr("value", lessAmount);
         }
      }
      
     }else{
      var c=$("#c").val();
      var cc=Number(c);
      var add=$("#a").attr("style");
      if(add=="display: inline-block;"){
         var addLeave=ss+cc;
         var addAmount=a+cc;
         $("input[name='changeSum']").attr("value", addAmount);
         $("input[name='changeLeave']").attr("value", addLeave);
      }else{
         var lessLeave=ss-cc;
         var lessAmount=a-cc;
         if(lessLeave<0){
         alert("剩余量不足");
         flag=false;
         }else{
          $("input[name='changeSum']").attr("value", lessAmount);
         $("input[name='changeLeave']").attr("value", lessAmount);
         }
      }
   
     }
    });
/*
    //新增子预控
    $(function () {
        var $document = $(document);
        $document.on("click", ".JS_add_controlItem", viewRemainderHanlder);
        function viewRemainderHanlder() {
            var $this = $(this);
            var precontrolPolicyId=$("#id").val();
            var controlType=$("#controlType").val();
            var url = "/vst_admin/goods/recontrol/goToAddResControlItem/view.do?precontrolPolicyId="+precontrolPolicyId+"&controlType="+controlType;
             window.dialogViewOrder = backstage.dialog({
                width: 650,
                height: 200,
                title: "新增子预控",
                iframe: true,
                url: url
            });
        }
    });
*/    
/*   
     //修改子预控
    $(function() {
        var $document = $(document);
        $document.on("click", ".JS_edit_control", editPolicyItemHanlder);
        function editPolicyItemHanlder() {
            var $this = $(this);
            var policyItemId = $(this).attr("data-param");
            var url = "/vst_admin/goods/recontrol/goToEditResPrecontrolPolicyItem/view.do?policyItemId="+policyItemId;
              window.dialogViewOrder = backstage.dialog({
                width: 650,
                height: 200,
                title: "修改子预控",
                iframe: true,
                url: url
            });
        }
    }); */
    //子预控日志详情页
    $("a.JS_show_log").live("click",function(){
        var $this = $(this);
        var policyItemId = $(this).attr("data-param");
        var param='objectId='+policyItemId+'&objectType=RES_PRECONTROL_POLICY_POLICY_ITEM&sysName=VST';
        backstage.dialog({
            width: 750,
            height: 500,
            title: "日志详情页",
            iframe: true,
            url: "/lvmm_log/bizLog/showVersatileLogList?"+param
        });
    });
/*
    // 删除子预控
    $(function() {
        var $document = $(document);
        $(".JS_delete_control").click(function() {
                
            var thisTd = $(this);
            var policyItemId = $(this).attr("data-param");
            var precontrolPolicyId=$("#id").val();
            var url = "/vst_admin/goods/recontrol/deleteResouceControlItem.do?policyItemId=" + policyItemId;
          	backstage.confirm({
                    content: "确认删除吗？",
                    determineCallback: function () {
                        $.ajax({
                            url: url,
             				dataType:"json",
              				async : false,
                            success: function(callback) {
                             if (callback.code == 1){
                                backstage.alert({
                                    content:"删除成功"
                                });
                             	//thisTd.parent().parent().remove();
								window.location.href="/vst_admin/goods/recontrol/goToEditResPrecontrolPolicy/view.do?id="+precontrolPolicyId;
                             }else{
                              backstage.alert({
                                    content:"删除失败,"+callback.msg
                                });
                             }
                            }
                        })
                    }
                });
        });
    });
*/
    //预控名称blur事件
    $document.on("blur", ".JS_memo", function() {
    var name=$("#memo").val();
    var len=name.length;
    if(len>300){
         $("#spanMemo").html("*备注最多输入300字").css("color","red");
       }else{
         $("#spanMemo").html("");
       }
    });
      //校验输入的买断总成本是否是数字
      $document.on("blur", ".JS_buyoutTotalCost", function() {
	      var buyoutTotalCost=$("#buyoutTotalCostStr").val();
	      //校验非负数字（小数位不超过2位）
	      var tt=/^(([1-9][0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2}))|[0])$/;
		  if(!tt.test(buyoutTotalCost)){
			  $("#spanBuyoutTotalCostStr").html("*买断总成本请输入非负的数字(最多两位小数)").css("color","red");
			  var buyoutTotalCost=$("#buyoutTotalCostStr").val("");
          }else{
	         $("#spanBuyoutTotalCostStr").html("");
	      }
      });
       $document.on("blur", ".JS_forecastSales", function() {
	      var forecastSales=$("#forecastSalesStr").val();
	      var tt=/^(([1-9][0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2}))|[0])$/;
	      if(!tt.test(forecastSales)){
		      $("#spanForecastSalesStr").html("*预估营业额请输入非负的数字(最多两位小数)").css("color","red");
		      var forecastSales=$("#forecastSalesStr").val("");
      	  }else{
      	  	  $("#spanForecastSalesStr").html("");
      	  }
      });
      $document.on("blur", ".JS_depositAmount", function() {
	      var depositAmount=$("#depositAmountStr").val();
	      var tt=/^(([1-9][0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2}))|[0])$/;
	      if(!tt.test(depositAmount)){
		      $("#spanDepositAmountStr").html("*押金请输入非负的数字(最多两位小数)").css("color","red");
		      var depositAmount=$("#depositAmountStr").val("");
      	  }else{
      	      $("#spanDepositAmountStr").html("");
      	  }
      });
      $document.on("blur", ".JS_nameAmount", function() {
	      var nameAmount=$("#nameAmountStr").val();
	      var tt=/^(([1-9][0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2}))|[0])$/;
	      if(!tt.test(nameAmount)){
		      $("#spanNameAmountStr").html("*冠名金额请输入非负的数字(最多两位小数)").css("color","red");
		      var nameAmount=$("#nameAmountStr").val("");
      	  }else{
      	   	  $("#spanNameAmountStr").html("");
      	  }
      });
      
    $document.on("blur", ".JS_payMemo", function() {
    var name=$("#payMemo").val();
    var len=name.length;
    if(len>300){
         $("#spanPayMemo").html("*付款备注最多输入300字").css("color","red");
       }else{
         $("#spanPayMemo").html("");
       }
    });

    //TODO 开发维护
    $(function () {

        var $document = $(document);

        var $form = $(".main").find("form");
        var validateAdd = backstage.validate({
            $area: $form,
            REQUIRED: "不能为空",
            showError: true
        });

        validateAdd.watch();

        $document.on("click", ".JS_btn_save", function () {
            validateAdd.refresh();
            validateAdd.watch();
            validateAdd.test();
            if (validateAdd.getIsValidate()) {
                //TODO 提交表单
                console.log("提交表单");
       			var buyoutTotalCost=$("#buyoutTotalCostStr").val();
              	var forecastSales=$("#forecastSalesStr").val();
              	var depositAmount=$("#depositAmountStr").val();
              	var nameAmount=$("#nameAmountStr").val();
              	var memo=$("#memo").val();
              	var payMemo=$("#payMemo").val();
              	var payWay = $("input[name='payWay']:checked").val();
              	var buCode=$('#selBuCode option:selected').val();
              	var area1=$('#selArea1 option:selected').val();
              	var area2=$('#selArea2 option:selected').val();
              	if(buCode!="BUSINESS_BU"){
              	  if(area1==null||area1==""){
              	  	alert("对不起，请选择所属大区");
					return;
              	  }
              	}
              	if(buCode=="TICKET_BU"){
              	  if(area2==null||area2==""){
              	  	alert("对不起，请选择所属分区");
					return;
              	  }
              	}
              	//校验金额
				var tt=/^(([1-9][0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2}))|[0])$/;
              	if(!tt.test(buyoutTotalCost)){
					alert("对不起，买断总成本请输入非负的数字(最多两位小数)");
					return;
				}
				if(!tt.test(forecastSales)){
					alert("对不起，预估营业额请输入非负的数字(最多两位小数)");
					return;
			    }
			    if(!tt.test(depositAmount)){
					alert("对不起，押金请输入非负的数字(最多两位小数)");
					return;
			    }
			    if(!tt.test(nameAmount)){
					alert("对不起，冠名金额请输入非负的数字(最多两位小数)")
					return;
			    }
			    
				if(payWay=="more"){
					var lentrim=$.trim(payMemo).length;
					 if(lentrim==0){
						alert("多次付款方式，请填写付款备注说明")
						$("#spanPayMemo").html("");
						return;
					 }
				}
				var len=payMemo.length;
			    if(len>300){
			    	alert("付款备注最多输入300字!");
         			return;
			    }
                //校验备注长度
    			var len1=memo.length;
    			if(len1>300){
    			 	alert("备注最多输入300字!");
         			return;
       			}
                backstage.confirm({
                    content: "确认提交吗？",
                    determineCallback: function () {
                        $.ajax({
                            url: "/vst_admin/goods/recontrol/editResourceControl.do",
                            type: "POST",
                            cache: false,
                            data:$("#saveButton").serialize(),
                            success: function(result) {
                             if (result == "success"){
                                backstage.alert({
                                    content:"保存成功"
                                });
                             parent.location.href="/vst_admin/goods/recontrol/find/resPrecontrolPolicyList.do";
                             parent.dialogViewOrder.destroy();
                             }else{
                              backstage.alert({
                                    content:"保存失败"
                                });
                             }
                            }
                           

                        })
                    }
                });


            }
        });
        $document.on("click", ".quxiao", function() {
                parent.dialogViewOrder.destroy();
        });

    });

    //产品经理自动完成
    $(function () {
        backstage.autocomplete({
            "query": ".JS_autocomplete_pm",
            "fillData": fillData,
            "choice": choice,
            "clearData": clearData
        });
        function fillData(self) {
            var url = "/vst_admin/goods/recontrol/findMangement.do";
            var text = self.$input.val();
            self.loading();
            $.ajax({
                url: url,
                data: {name: text},
                success: function (json) {
                    var $ul = self.$menu.find("ul");
                    $ul.empty();
                    for (var i = 0; i < json.length; i++) {
                        var $li = $('<li data-email="'+json[i].email+'" data-id="' + json[i].id + '">' + json[i].name + '</li>');
                        $ul.append($li)
                    }

                    self.loaded();
                }
            });
        }

        function choice(self, $li) {

            var id = $li.attr("data-id");
            var $hidden = self.$input.parent().find(".JS_autocomplete_pm_hidden");
            var email = $li.attr("data-email");
            var $email = self.$input.parent().find(".JS_autocomplete_pm_hidden_email");
            $hidden.val(id);
            $email.val(email);
        }
        function clearData(self) {
            var $hidden = self.$input.parent().find(".JS_autocomplete_pm_hidden");
            var $email = self.$input.parent().find(".JS_autocomplete_pm_hidden_email");
            $email.val("");
            $hidden.val("");
        }
    });

    //抄送自动完成
    $(function () {
        backstage.autocomplete({
            "query": ".JS_autocomplete_cc",
            "fillData": fillData,
            "choice": choice,
            "clearData": clearData
        });
        function fillData(self) {
            var url = "/vst_admin/goods/recontrol/findSend.do";
            var text = self.$input.val();
            self.loading();
            $.ajax({
                url: url,
                data: {name: text},
                success: function (json) {
                    var $ul = self.$menu.find("ul");
                    $ul.empty();
                    for (var i = 0; i < json.length; i++) {
                        var $li = $('<li data-email="'+json[i].email+'" data-id="' + json[i].id + '">' + json[i].name + '</li>');
                        $ul.append($li)
                    }

                    self.loaded();
                }
            });
        }
        function choice(self, $li) {

            var id = $li.attr("data-id");
            var email = $li.attr("data-email");
            var $hidden = self.$input.parent().find(".JS_autocomplete_cc_hidden");
            var $hiddenEmail = self.$input.parent().find(".JS_autocomplete_cc_hidden_email");

            $hidden.val(id);
            $hiddenEmail.val(email);

        }
        function clearData(self) {
            var $hidden = self.$input.parent().find(".JS_autocomplete_cc_hidden");
            var $hiddenEmail = self.$input.parent().find(".JS_autocomplete_cc_hidden_email");
            $hidden.val("");
            $hiddenEmail.val("");
        }
    });
    
    $("#PreEndTime").change( function () { 
    var id = $("#id").val();
    var endTime = $("#PreEndTime").val();
    var flag = false;
    var newDate = Date.parse($("#PreEndTime").val());
    var ordDate = Date.parse($('#resDate').val());
    if(newDate<ordDate){
       $("#PreEndTime").val($('#resDate').val());
       alert("对不起，预控时间只能延迟不能提前");
       return;
    }
    $.ajax({
      type : "GET",
       url :"/vst_admin/goods/recontrol/findConflict.do?id="+id+"&endDate="+endTime,
       success:function(msg){
       flag = true; 
      // alert(msg);
       if(!msg){
       $("#PreEndTime").val($('#resDate').val());
       alert("对不起，预控时间冲突, 请重新选择时间");
       }
       },
       complete:function(){
        if(!flag){
         $("#PreEndTime").val($('#resDate').val());
         alert("服务器没有响应");
         }
       }
    });
    
    } 
    );


  $(function(){
  	areaDataJson=[
		    {"buid":"LOCAL_BU",
		     "buname":"国内游事业部",
		     "area1":[
		        {"aid":"bjbranch",
			 "aname":"北京分公司"
		        },
			{"aid":"cdbranch",
			 "aname":"成都分公司"
		        },
			{"aid":"gzbranch",
			 "aname":"广州分公司"
		        },
			{"aid":"shhead",
			 "aname":"上海总部"
		        }
		    ]},
		    {"buid":"OUTBOUND_BU",
		     "buname":"出境游事业部",
		     "area1":[
		        {"aid":"shout",
			 "aname":"上海出境"
		        },
			{"aid":"bjout",
			 "aname":"北京出境"
		        },
			{"aid":"gzout",
			 "aname":"广州出境"
		        },
			{"aid":"cdout",
			 "aname":"成都出境"
		        }
		    ]},
		    {"buid":"DESTINATION_BU",
		     "buname":"目的地事业部",
		     "area1":[
		        {"aid":"bjbranch",
			 "aname":"北京分公司"
		        },
			{"aid":"cdbranch",
			 "aname":"成都分公司"
		        },
			{"aid":"gzbranch",
			 "aname":"广州分公司"
		        },
			{"aid":"zenarea",
			 "aname":"浙东北大区"
		        },
			{"aid":"zwnarea",
			 "aname":"浙西南大区"
		        },
			{"aid":"scnarea",
			 "aname":"苏中北大区"
		        },
			{"aid":"snarea",
			 "aname":"苏南大区"
		        },
			{"aid":"sharea",
			 "aname":"上海大区"
		        },
			{"aid":"hbarea",
			 "aname":"湖北大区"
		        },
			{"aid":"aharea",
			 "aname":"安徽大区"
		        },
			{"aid":"jxarea",
			 "aname":"江西大区"
		        },
			{"aid":"outatea",
			 "aname":"境外大区"
		        },
			{"aid":"hnarea",
			 "aname":"海南大区"
		        }
		    ]},
		    {"buid":"TICKET_BU",
		     "buname":"景区玩乐事业群",
		     "area1":[
		        {"aid":"eastarea",
			 "aname":"东区",
		         "area2":[
		            {"pid":"shanghai","pname":"上海"},
		            {"pid":"jaingsu","pname":"江苏"},
			    {"pid":"zhejiang","pname":"浙江"},
			    {"pid":"jiangxi","pname":"江西"},
		            {"pid":"fujian","pname":"福建"}
		        ]},
			{"aid":"southarea",
			 "aname":"南区",
		         "area2":[
		            {"pid":"guangdong","pname":"广东"},
		            {"pid":"hunan","pname":"湖南"},
			    	{"pid":"guangxi","pname":"广西"},
			    	{"pid":"hainan","pname":"海南"}
		        ]},
			{"aid":"northarea",
			 "aname":"北区",
		         "area2":[
		            {"pid":"beijing","pname":"北京"},
		            {"pid":"tianjin","pname":"天津"},
			    {"pid":"hebei","pname":"河北"},
			    {"pid":"shandong","pname":"山东"},
			    {"pid":"heilongjiang","pname":"黑龙江"},
			    {"pid":"jilin","pname":"吉林"},
			    {"pid":"liaoning","pname":"辽宁"},
			    {"pid":"neimenggu","pname":"内蒙古"}
		        ]},
			{"aid":"westarea",
			 "aname":"西区",
		         "area2":[
		            {"pid":"chongqing","pname":"重庆"},
		            {"pid":"sichuan","pname":"四川"},
		            {"pid":"yunnan","pname":"云南"},
		            {"pid":"guizhou","pname":"贵州"},
		            {"pid":"xinjiang","pname":"新疆"},
		            {"pid":"gansu","pname":"甘肃"},
		            {"pid":"ningxia","pname":"宁夏"},
		            {"pid":"qinghai","pname":"青海"},
		            {"pid":"xizang","pname":"西藏"}
		        ]},
			{"aid":"centralarea",
			 "aname":"中区",
		         "area2":[
		            {"pid":"henan","pname":"河南"},
		            {"pid":"shanxi","pname":"陕西"},
		            {"pid":"anhui","pname":"安徽"},
		            {"pid":"hubei","pname":"湖北"},
		            {"pid":"shanxip","pname":"山西"}
		        ]},
			{"aid":"outboundarea",
			 "aname":"出境",
		         "area2":[
		            {"pid":"xinmayin","pname":"新马印"},
		            {"pid":"oumeiaofei","pname":"欧美澳非"},
		            {"pid":"taiyuejian","pname":"泰越柬"},
		            {"pid":"riben","pname":"日本"},
		            {"pid":"hanguo","pname":"韩国wifi"},
		            {"pid":"gangao","pname":"港澳"}
		        ]}
		    ]},
		    {"buid":"BUSINESS_BU",
		     "buname":"商旅定制事业部"
		    }
		];

            //初始化BU
            var bucode = function(){
                $.each(areaDataJson,function(i,bucode){
                    var option="<option value='"+bucode.buid+"'>"+bucode.buname+"</option>";
					 $("#selBuCode").append(option);
                });
                area1(2);
            };
            //赋值大区 changFlag 1:bu改变;2:初始化
            var area1 = function(changFlag){
				//$("#selArea2").css("display","none");
				//$("#selArea1 option:gt(0)").remove();
				var n1 = $("#selBuCode").get(0).selectedIndex;
				var n;
				//获取初始化的bu的位置
				if(n1==0 && changFlag==1){
					var obj = $("#selBuCode").get(0);
					var firstBu=obj.options[0].value;
		            for(var i = 0; i < obj.options.length; i++){
		                var tmp = obj.options[i].value;
		                if(i>0 && tmp == firstBu){
		                    n=i-1;
		                    break;
		                }
		            }
				}else{
					n = $("#selBuCode").get(0).selectedIndex-1;
				}
				
				if(typeof(areaDataJson[n].area1) != "undefined"){
				 	var option;
	                $.each(areaDataJson[n].area1,function(i,area1){
	                     option+="<option value='"+area1.aid+"'>"+area1.aname+"</option>";
	                });
	                $("#selArea1").html(option);
                }else{
                	$("#selArea1").html("<option value=''>请选择大区</option>");
                }
                area2(changFlag);
            };
            //赋值分区
            var area2 = function(changFlag){
				//$("#selArea2 option:gt(0)").remove(); 
                //var m = $("#selBuCode").get(0).selectedIndex-1;
                var m ;
                var n1 = $("#selBuCode").get(0).selectedIndex;
				if(n1==0 && changFlag==1){
					var obj = $("#selBuCode").get(0);
					var firstBu=obj.options[0].value;
		            for(var i = 0; i < obj.options.length; i++){
		                var tmp = obj.options[i].value;
		                if(i>0 && tmp == firstBu){
		                    m=i-1;
		                    break;
		                }
		            }
				}else{
					m = $("#selBuCode").get(0).selectedIndex-1;
				}
                var n =  $("#selArea1").get(0).selectedIndex;
                if(typeof(areaDataJson[m].area1[n].area2) != "undefined"){
                  $("#selArea2").css("display","inline");
                  var option;
                    $.each(areaDataJson[m].area1[n].area2,function(i,area2){
                         option+="<option value='"+area2.pid+"'>"+area2.pname+"</option>";
                    });
                    $("#selArea2").html(option);
                }else{
                 	$("#selArea2").css("display","none");
                };;
            };
            //选择省改变市
            $("#selBuCode").change(function(){
                area1(1);
            });
            //选择市改变县
             $("#selArea1").change(function(){
                area2(1);
            });
                bucode();
    });
</script>
</body>
</html>
