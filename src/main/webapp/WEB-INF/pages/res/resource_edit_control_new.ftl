<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>新增预控</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/resource-add-control.css"/>
    <style>
 		.paging a {padding: 5px;}
	</style>
</head>
<body class="resource-add-control">

<div class="main">
    <form id="saveButton">
    
        <input type="hidden" name="id" value="${resPrecontrolPolicy.id}" />
    
        <dl class="clearfix">
            <dt>
                <label for="ControlName">
                    <span class="text-danger">*</span> 预控名称：
                </label>
            </dt>
            <dd>
                <div class="form-group col mr10">
                     <input name="name" id="ControlName" type="text" class="form-control w200 JS_pre_name" value="${resPrecontrolPolicy.name}"   data-validate="{required:true}"/>
                     <input id="id" name="id"  value="${resPrecontrolPolicy.id}" type="hidden" /> 
                      <input id="state" name="state"  value="${resPrecontrolPolicy.state}" type="hidden" /> 
                     <input id="leave"  name="leave"   value="${num}"  type="hidden"/>
                     <input id="changeSum"  name="changeSum" type="hidden"/>
                     <input id="changeLeave"  name="changeLeave" type="hidden"/>
                     <input id="isDeleted"  name="isDeleted" type="hidden"/>
                     <input type="hidden" name="isCanDelay" value="N" />
                </div>

                <span id="spanId" class="text-gray"></span>
            </dd>
            
            <dt>
                <label for="ProviderName">
                    <span class="text-danger">*</span> 供应商名称：
                </label>
            </dt>
            <dd>
                <div class="form-group">
                    <input name="supplierName" id="ProviderName" type="text" class="form-control search w200 JS_autocomplete_pn"
                        value="${resPrecontrolPolicy.supplierName}"   data-validate="{required:true}"/>
                    <input id="supplierId" name="supplierId" type="hidden"value="${resPrecontrolPolicy.supplierId}" class="JS_autocomplete_pn_hidden"/>
              
                </div>        
            </dd>
            
            <dt>
                <label>
                    <span class="text-danger">*</span> 预控方式：
                </label>
            </dt>
            <dd>
                <div class="JS_radio_switch_group form-group">
                    <div class="col w270 JS_radio_switch_box">
                        <span class="">
                        
                         <#if resPrecontrolPolicy.controlType == "amount">
                            <label>预控金额   <input name="controlType" class="JS_radio_switch " type="radio" value="amount" data-validate="{required:true}" checked="checked"/>
                       
                            </label>
                        <span class="form-group">                      
                            <input id="amounta" name="amount" type="text" class="form-control w110 JS_radio_disabled" data-validate="{required:true}" value="${resPrecontrolPolicy.originAmount}"  />
                        </span>
                                       
                        <#else>
                            <label>预控金额    <input name="controlType" class="JS_radio_switch" type="radio"   value="amount" data-validate="{required:true}"  />
                            </label>
                            <span class="form-group">
                                <input id="amounta" name="amount" type="text" class="form-control w110 JS_radio_disabled" data-validate="{required:true}" disabled="disabled"/>
                            </span>
                                   
                       </#if>   
                            </span>                                       
                     
                    </div>
                    <div class="col JS_radio_switch_box">
                        <span class="">
                        
                        <#if resPrecontrolPolicy.controlType == "inventory">
                            <label>预控库存   <input  name="controlType" class="JS_radio_switch" type="radio" value="inventory" checked="checked" data-validate="{required:true}" />
                            </label>
                            <span class="form-group">
                                <input id="amountb" name="amount" type="text" class="form-control w110 JS_radio_disabled" data-validate="{required:true}" value="${resPrecontrolPolicy.originAmount}"  />
                            </span>
                        <#else>
                            <label>预控库存     <input  name="controlType" class="JS_radio_switch" type="radio" value="inventory" data-validate="{required:true}"/>
                            </label>
                             <span class="form-group">
                                <input id="amountb" name="amount" type="text" class="form-control w110 JS_radio_disabled" data-validate="{required:true}" disabled="disabled"/>
                            </span>
                        </#if>
                   
                        </span>               
                    </div>
                </div>
            </dd>
            
            <dt>
                <label>
                    <span class="text-danger">*</span> 销售起止日期：
                </label>
            </dt>
            <dd>
                <span class="form-group">
                    <input name="saleEffectDate" type="text" placeholder="起始时间" class="form-control datetime w100 JS_sale_date"
                           data-validate="{required:true}" value="${resPrecontrolPolicy.saleEffectDate?string("yyyy-MM-dd")}"
                           readonly="readonly" data-validate-readonly="true"/>
                </span>
                -
                <span class="form-group">
                    <input name="saleExpiryDate"  type="text" placeholder="结束时间" class="form-control datetime w100 JS_sale_date"
                           data-validate="{required:true}"value="${resPrecontrolPolicy.saleExpiryDate?string("yyyy-MM-dd")}"
                           readonly="readonly" data-validate-readonly="true"/>
                </span>
            </dd>
            
            <dt>
                <label>
                    <span class="text-danger">*</span> 游玩起止日期：
                </label>
            </dt>
            <dd>
                <span class="form-group">
                    <input name="tradeEffectDate" type="text" placeholder="起始时间" class="form-control datetime w100 JS_play_date"
                           data-validate="{required:true}"value="${resPrecontrolPolicy.tradeEffectDate?string("yyyy-MM-dd")}"
                           readonly="readonly" data-validate-readonly="true"/>
                </span>
                -
                <span class="form-group">
                    <input name="tradeExpiryDate" type="text" placeholder="结束时间" class="form-control datetime w100 JS_play_date"
                           data-validate="{required:true}"value="${resPrecontrolPolicy.tradeExpiryDate?string("yyyy-MM-dd")}"
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
                                <input name="controlClassification" id="Daily" value="Daily" type="radio" data-validate="{required:true}" class="JS_control_type" checked="checked"/>
                                                                                按日预控
                            </label>
                        <#else>
                            <label>
                                <input name="controlClassification"id="Daily"  value="Daily" type="radio" data-validate="{required:true}" class="JS_control_type"/>
                                                                                按日预控
                            </label>
                        </#if>
                    </div>
                    <div class="col w90">
                        <#if resPrecontrolPolicy.controlClassification == "Cycle">
                            <label>
                                <input name="controlClassification" id="Cycle" value="Cycle" type="radio" data-validate="{required:true}" checked="checked" class="JS_control_type"/>
                                                                                按周期预控
                            </label>
                        <#else>
                            <label>
                                <input name="controlClassification" id="Cycle" value="Cycle" type="radio" data-validate="{required:true}" class="JS_control_type"/>
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
	                            <input name="isTest" type="radio" value="Y" data-validate="{required:true}"  <#if resPrecontrolPolicy.isTest=="Y">checked="checked"</#if> >
	                            是
	                        </label>
	                    </div>
	                    <div class="col w90">
	                        <label>
	                            <input name="isTest" type="radio" value="N" data-validate="{required:true}" <#if resPrecontrolPolicy.isTest=="N">checked="checked"</#if> >
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
            <#--<dt>
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
            <#--<dt>
                <label for="buCode">
                    <span class="text-danger">*</span> 所属BU：
                </label>
            </dt>
            <dd>
                <div class="form-group">
                    <select name="buCode" class="form-control" data-validate="{required:true}">
                        <option value="">请选择</option>
                        <option value="LOCAL_BU" <#if resPrecontrolPolicy.buCode == "LOCAL_BU">selected="selected"</#if> >国内游事业部</option>
                        <option value="OUTBOUND_BU" <#if resPrecontrolPolicy.buCode == "OUTBOUND_BU">selected="selected"</#if>>出境游事业部</option>
                        <option value="DESTINATION_BU" <#if resPrecontrolPolicy.buCode == "DESTINATION_BU">selected="selected"</#if>>目的地事业部</option>
                        <option value="TICKET_BU" <#if resPrecontrolPolicy.buCode == "TICKET_BU">selected="selected"</#if>>景区玩乐事业群</option>
                        <option value="BUSINESS_BU" <#if resPrecontrolPolicy.buCode == "BUSINESS_BU">selected="selected"</#if>>商旅定制事业部</option>
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
                        <option value="">请选择</option>
                        <option value="LOCAL_BU" <#if resPrecontrolPolicy.buCode == "LOCAL_BU">selected="selected"</#if> >国内游事业部</option>
                        <option value="OUTBOUND_BU" <#if resPrecontrolPolicy.buCode == "OUTBOUND_BU">selected="selected"</#if>>出境游事业部</option>
                        <option value="DESTINATION_BU" <#if resPrecontrolPolicy.buCode == "DESTINATION_BU">selected="selected"</#if>>目的地事业部</option>
                        <option value="TICKET_BU" <#if resPrecontrolPolicy.buCode == "TICKET_BU">selected="selected"</#if>>景区玩乐事业群</option>
                        <option value="BUSINESS_BU" <#if resPrecontrolPolicy.buCode == "BUSINESS_BU">selected="selected"</#if>>商旅定制事业部</option>
                    	<#-- <#if resPrecontrolPolicy.buCode == "">
	                    	<option value="">请选择BU</option>
	                    <#else>
	                     	<option value="${resPrecontrolPolicy.buCode}" selected="selected">${resPrecontrolPolicy.buCnName}</option>
	                    </#if> -->
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
 		<div id="daily">
 				<!--按日预控 开始-->
                    <p>
                        <label class="checkbox">
                            <input name="code" type="checkbox" value="everyday"/>
                            每天晚上24点整，发邮件提醒。
                        </label>
                    </p>
                     <p>
                        <label class="checkbox">
                            <input name="code" type="checkbox"  value="lossAll"/>
                            买断“金额/库存”全部消耗完时，发邮件提醒我。
                        </label>
                    </p>
                    <p>
                         <label class="checkbox">
                            <input name="code" type="checkbox" value="finish"/>
                          买断期结束时，发邮件提醒我。
                        </label>
                    </p>
                   <!--按日预控 结束-->
                   </div> 
					<div id="cycle">                    
                    <!--按周期预控 开始-->
                    <p>
                        <label class="checkbox">
                            <input name="code" type="checkbox" value="everyweek"/>
                            从起始时间算起，之后的每个周一，发邮件提醒。
                        </label>
                    </p>    

                    <p>
                        <label class="checkbox">
                            <input name="code" type="checkbox"  value="loss"/>
                            每当“金额/库存”减少
                            <select class="form-control" name="value">
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
                     <p>
                        <label class="checkbox">
                            <input name="code" type="checkbox" value="lossAll"/>
                            买断“金额/库存”全部消耗完时，发邮件提醒我。
                        </label>
                    </p>

                    <p>
                         <label class="checkbox">
                            <input name="code" type="checkbox" value="finish"/>
                            买断期结束时，发邮件提醒我。
                        </label>
                    </p>
                    <!--按周期预控 结束-->
                    </div>
                    <div id="initial">
            <#assign x="false"/>
               <div class="form-group">
               <#if resPrecontrolPolicy.controlClassification == "Daily">
                    <!--按日预控 开始-->
                    <#list resWarmRuleList as warm>
                    <#if warm.name=="everyday">
                    <p>
                        <label class="checkbox">
                            <input name="code"" type="checkbox" 
                                 value="everyday" checked="checked"/>
                            每天晚上24点整，发邮件提醒。
                        </label>
                        <#assign x="true"/>
                    </p>
                    </#if>
                    </#list>
                    <#if x=="false">
                        <p>
                        <label class="checkbox">
                            <input name="code"" type="checkbox"
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
                    <p>
                        <label class="checkbox">
                            <input name="code" type="checkbox" value="everyweek" checked="checked"
                                   />
                            从起始时间算起，之后的每个周一，发邮件提醒。
                        </label>
                        <#assign x="true"/>
                    </p>
                    </#if>
                    </#list>
                    <#if x=="false">
                    <p>
                        <label class="checkbox">
                            <input name="code" type="checkbox" value="everyweek"
                                   />
                            从起始时间算起，之后的每个周一，发邮件提醒。
                        </label>
                    </p>
                    </#if>
                    <#assign x="false"/>
                    <#list resWarmRuleList as warm>
                    <#if warm.name=="loss">
                    <p>
                        <label class="checkbox">
                            <input name="code" type="checkbox" value="loss" checked="checked"
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
                     <p>
                        <label class="checkbox">
                            <input name="code" type="checkbox" value="loss"
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
                            <input name="code" type="checkbox" value="lossAll" checked="checked"
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
                            <input name="code" type="checkbox" value="lossAll"
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
                            <input name="code" type="checkbox" value="finish" checked="checked"
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
                            <input name="code" type="checkbox" value="finish"
                                   />
                            买断期结束时，发邮件提醒我。
                        </label>
                    </p>
                    </#if>
                </div>
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
            <a class="btn JS_btn_cancel quxiao">取消</a>
        </div>
    </form>
</div>

<!--模板 开始-->
<div class="template">

    <!--抄送 开始-->
    <div class="col w150 cc JS_cc form-group">
        <input name="receiverName" type="text" class="form-control search w110 JS_autocomplete_cc" />
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
<script src="http://pic.lvmama.com/js/backstage/v1/resource-add-control.js"></script>
<script type="text/javascript" src="/vst_admin/js/res/resource_edit_control_new.js"></script>
<script>
</script>
</body>
</html>