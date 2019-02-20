<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
<#include "/base/BuGenerator.ftl"/>
</head>
<body>
<div class="iframe_header">
        <ul class="iframe_nav">
            <li><a href="#">线路</a> &gt;</li>
            <li><a href="#">商品维护</a> &gt;</li>
            <li class="active">供应商合同关联</li>
        </ul>
</div>

<#list qualifyTypeList as typeInfo>
<input type="hidden" name="qualifyTypeListInputHidden" code="${typeInfo.code!''}" value="${typeInfo.cnName!''}">
</#list>
<#list lvAccSubjectList as accSubjectInfo>
<input type="hidden" name="lvAccSubjectListInputHidden" code="${accSubjectInfo.code!''}" value="${accSubjectInfo.subName!''}">
</#list>
<div class="iframe_content mt10">
<#--
        <div class="tiptext tip-warning cc5"><span class="tip-icon tip-icon-warning"></span>友情提示：
            <p class="pl15"></p>
        </div>
        -->
        <div class="p_box box_info">
		<form action="/vst_admin/tour/goods/goods/updateSuppGoodsBase.do" method="post" id="dataForm">
		<input type="hidden" id="productId" name="productId" value="${prodProductId!''}">
		<input type="hidden" name="suppGoodsId" value="${suppGoods.suppGoodsId!''}">
        <input type="hidden" name="goodsName" value="${suppGoods.goodsName!''}">
        <input type="hidden" id="cancelFlag" name="cancelFlag" value="${suppGoods.cancelFlag!''}">
		<input type="hidden" id="categoryId" name="categoryId" value="${categoryId!''}">
		<input type="hidden" name="stockApiFlag" value="N">
        <table class="e_table form-inline">
            <tbody>
                <tr>
	                    <td width="150" class="e_label td_top"><i class="cc1">*</i>选择供应商：</td>
	                    <td class="w18" colspan='5'>
	                    <input type="text" placeholder="请输入供应商名称" class="w35 search"  name="suppSupplier.supplierName" required=true errorEle="supplier" id="supplierName" <#if suppGoods != null && suppGoods.suppSupplier != null>value="${suppGoods.suppSupplier.supplierName}" readonly=readonly</#if> >
                	    <input type="hidden"  name="supplierId" id="supplierId" value="${suppGoods.supplierId!''}" required=true>
                	    
	                    <!--<a class="btn btn_cc1" id="selectSupplierButton">选择供应商</a><span class="cc3">(仅针对供应商进行查询)</span>-->
	                    <div style="display:inline" id="supplierError"></div>
	                    <div style="display:inline" class='error' id="signMsg">
	                    <#if suppGoods??  && suppGoods.suppSupplier?? >
	                    <#if suppGoods.suppSupplier.subsidiaryFlag=='Y'>子公司</#if>
	                    
	                    <#if suppGoods.suppSupplier.qualifyType?? && suppGoods.suppSupplier.qualifyType!="">资质范围：
	                      <#list qualifyTypeList as  typeInfo>
				            <#if  suppGoods.suppSupplier.qualifyType?contains(typeInfo.code)>
				             ${typeInfo.cnName!''}&nbsp;
				            </#if>
			              </#list>
	                    </#if>
	                    </#if>
	                    </div>
                    	<div class="cc3"> 注：下面的内容维护人员、商品默认合同，添加新商品时均为默认值。 </div></td>
                </tr>
                <tr>
					<td class="e_label"><i class="cc1">*</i>商品合同：</td>
					<td colspan=2 class=" operate mt10">
						<input type="hidden"  name="companyType" id="companyTypeHidden" value="${suppGoods.companyType!''}"  />
						<input type="text" readonly="readonly" id="contractName" name="suppContract.contractName" <#if suppGoods?? && suppGoods.suppContract?? && suppGoods.suppContract.contractName!="">value="${suppGoods.suppContract.contractName}" </#if> required>
						<input type="hidden" id="contractIdUpdate" name="contractId" <#if suppGoods?? && suppGoods.suppContract?? && suppGoods.suppContract.contractName!="">value="${suppGoods.suppContract.contractId}" </#if>>
						<a id="change_button_contract" href="javascript:void(0);">[更改]</a>
						<i class="cc1">*</i>我方结算主体：
						 <span id="companyTypeNew" style="width:250px;">
						<#if (suppGoods!=null) && (suppGoods.companyType!=null)&&(suppGoods.companyType!="") >
						     <#assign lvCode="" />
							<#switch suppGoods.companyType>
                                  <#case "JOYU"> 
                                  	<#assign lvCode="DEFAULT" />
                                  <#break>
                                  <#case "GUOLV">
                                     <#assign lvCode="LVMAMA" />
                                  <#break>
                                  <#case "XINGLV">
                                       <#assign lvCode="LVMAMAXINGLV" />
                                  <#break>
                          </#switch>
                          <#list lvAccSubjectList as subjectInfo>
                          <#if subjectInfo.code==lvCode>
						      ${subjectInfo.subName!''}
                          </#if>
                          </#list>
						</#if>
						</span>
					    
						
						<#--
						<select name="companyType" required style="width:250px;" >
								<#list companyTypeMap?keys as key>
						  			<option value="${key}"<#if key == "${suppGoods.companyType}" >selected="selected"</#if> >${companyTypeMap[key]}</option>
							  	</#list>
							  	<option value="JOYU" <#if suppGoods.companyType == "JOYU">selected="selected"</#if> >上海景域文化传播股份有限公司</option>
					  	</select>
					  	<#if suppGoods.companyType == "JOYU">
					  		<span class='error'>!仅台湾产品用景域这项</span>
					  	</#if>
					  	-->
                   	</td>
                </tr>
				<#-- SETTLE_ENTITY_NEW_MARK start  -->
                <tr>
                    <td class="e_label"><i class="cc1">*</i>非预控自营/预控预存款结算对象：</td>
                    <td colspan=2 id="settlementEntityTd">
                        <input type="text" name="settlementEntityName" id="settlementEntityName" <#if suppGoods!=null && suppGoods.settlementEntity!=null> value="${suppGoods.settlementEntity.name}"</#if> >
                        <input type="hidden" name="settlementEntityCode" id="settlementEntityCode" <#if suppGoods!=null && suppGoods.settlementEntity!=null> value="${suppGoods.settlementEntity.code}"</#if> >
                        <input type="hidden" <#if suppGoods!=null && suppGoods.settlementEntity!=null> value="${suppGoods.settlementEntity.id}"</#if> name="settlementEntityId" id="settlementEntityId" >
                        <input type="hidden" name="settlementEntityBu" id="settlementEntityBu" <#if suppGoods!=null && suppGoods.settlementEntity!=null> value="${suppGoods.settlementEntity.cooperatedBuNostro}"</#if>>
                        <input type="hidden" name="settlementEntityType" id="settlementEntityType" <#if suppGoods!=null && suppGoods.settlementEntity!=null> value="${suppGoods.settlementEntity.settlementClasification}"</#if>>
						<span name="settlementEntityDesc" id="settlementEntityDesc">
					<#if suppGoods.settlementEntity!=null&&suppGoods.settlementEntity.code?? >
                        结算对象CODE: ${suppGoods.settlementEntity.code}
					</#if>
					<#if suppGoods.settlementEntity!=null&&suppGoods.settlementEntity.cooperatedBuNostroName??>
                        ,合作BU：${suppGoods.settlementEntity.cooperatedBuNostroName}
					</#if>
				</span>
                    </td>
                </tr>
				<tr>
                    <td class="e_label"><i class="cc1">*</i>预控自营/预控预存款结算对象：</td>
                    <td colspan=2 id="buyoutSettlementEntityTd">
                        <input type="text" name="buyoutSettlementEntityName" id="buyoutSettlementEntityName" <#if suppGoods!=null && suppGoods.buyoutSettlementEntity!=null> value="${suppGoods.buyoutSettlementEntity.name}"</#if> >
                        <input type="hidden" name="buyoutSettlementEntityCode" id="buyoutSettlementEntityCode" <#if suppGoods!=null && suppGoods.buyoutSettlementEntity!=null> value="${suppGoods.buyoutSettlementEntity.code}"</#if> >
                        <input type="hidden" <#if suppGoods!=null && suppGoods.buyoutSettlementEntity!=null> value="${suppGoods.buyoutSettlementEntity.id}"</#if> name="buyoutSettlementEntityId" id="buyoutSettlementEntityId" >
                        <input type="hidden" name="buyoutSettlementEntityBu" id="buyoutSettlementEntityBu" <#if suppGoods!=null && suppGoods.buyoutSettlementEntity!=null> value="${suppGoods.buyoutSettlementEntity.cooperatedBuNostro}"</#if>>
                        <input type="hidden" name="buyoutSettlementEntityType" id="buyoutSettlementEntityType" <#if suppGoods!=null && suppGoods.buyoutSettlementEntity!=null> value="${suppGoods.buyoutSettlementEntity.settlementClasification}"</#if>>
						<span name="buyoutSettlementEntityDesc" id="buyoutSettlementEntityDesc">
					<#if suppGoods.buyoutSettlementEntity!=null&&suppGoods.buyoutSettlementEntity.code?? >
                        结算对象CODE: ${suppGoods.buyoutSettlementEntity.code}
					</#if>
					<#if suppGoods.buyoutSettlementEntity!=null&&suppGoods.buyoutSettlementEntity.cooperatedBuNostroName??>
                        ,合作BU：${suppGoods.buyoutSettlementEntity.cooperatedBuNostroName}
					</#if>
				</span>
                    </td>
                </tr>
				<#-- SETTLE_ENTITY_NEW_MARK  end -->
               	<tr>
					<td class="e_label"><i class="cc1">*</i>内容维护人员：</td>
					<td colspan=2>
						<input type="text" name="contentManagerName" id="contentManagerName" value="${contentManagerName}" required=true>	
                    	<input type="hidden" value="${suppGoods.contentManagerId}" name="contentManagerId" id="contentManagerId" required=true>
                    <div class="cc3"> 注：对信息维护负责。 </div>
                   	</td>
                </tr>
                <tr>
					<td class="e_label"><i class="cc1">*</i>产品经理：</td>
					<td colspan=2>
						<input type="text" name="managerName" id="managerName" value="${suppGoods.managerName}" required=true>
                    	<input type="hidden" value="${suppGoods.managerId}" name="managerId" id="managerId" required=true>
                    	<div class="cc3"> 注：产品订单的跟进人员。 </div>
                   	</td>
                </tr>
                <tr>
                    <td class="e_label"><i class="cc1">*</i>是否仅组合销售：</td>
                    <td colspan=2>
                        <label class="radio"><input type="radio" class="typeSelect"  name="packageFlag" checked="checked" value="N"/>否</label>
                        <label class="radio"><input type="radio" class="typeSelect"  name="packageFlag" value="Y"  <#if suppGoods!=null && suppGoods.packageFlag=='Y'>checked=checked</#if>  />是</label>
                        <#if suppGoods?? && suppGoods.packageFlag=='Y'>
							<span id="tips" style="color:red;">注：仅组合销售选择“是”时，商品只能通过打包方式售卖</span>
						<#else>
							<span id="tips" style="display:none; color:red;">注：仅组合销售选择“是”时，商品只能通过打包方式售卖</span>
						</#if>
                    </td>
                </tr>
                 <tr>
					<td class="e_label"><i class="cc1">*</i>分公司：</td>
					<td colspan=2>
						<select name="filiale" class="filialeCombobox">
                    	 			<option value="">请选择</option>
		    				<#list filialeList as list>
			                    	<option value=${list.code!''} <#if suppGoods!=null && suppGoods.filiale==list.code>selected</#if> >${list.cnName!''}</option>
			                </#list>
			        	</select>
			        	<div class="cc3"> 注：订单跟进处理时使用。 </div>
                    </td>
                </tr>
                
                <tr>
					<td class="e_label"><i class="cc1">*</i>BU：</td>
					<td colspan=2>
						<#--
			        	<select name="bu" required>
		    	 			<option value="">请选择</option>
						<#list buList as list>
		                	<option value=${list.code!''}  <#if suppGoods!=null && suppGoods.bu==list.code>selected</#if>  >${list.cnName!''}</option>
			            </#list>
				    	</select>
				    	-->
				    	<#--http://ipm.lvmama.com/index.php?m=story&f=view&t=html&id=12992-->
				    	<#if suppGoods?? && suppGoods.bu??>
				    		<@BuGenerator buList suppGoods.bu categoryId prodProduct.subCategoryId!''/>
				    	<#else>
				    		<@BuGenerator buList "" categoryId prodProduct.subCategoryId!''/>
						</#if>
	                </td>
	            </tr>
                
	            
	            
                <tr>
					<td class="e_label"><i class="cc1">*</i>归属地：</td>
					<td colspan=2>
						<input type="text" name="attributionName" id="attributionName" value="${suppGoods.attributionName}"  readonly="readonly" required />
						<input type="hidden" name="attributionId" id="attributionId" value="${suppGoods.attributionId}" required />
                    </td>
                </tr>
                
                <tr>
					<td class="e_label"><i class="cc1">*</i>支付对象：</td>
					<td colspan=2>
							<select name="payTarget" required>
	                    	 			<option value="">请选择</option>
			    				<#list payTargetList as list>
				                    	<option value=${list.code!''} <#if suppGoods!=null && suppGoods.payTarget==list.code>selected</#if> <#if list.code!='PREPAID'>disabled=disabled</#if> >${list.cnName!''}</option>
				                </#list>
				        	</select>
                    </td>
                </tr>
                <tr>
					<td class="e_label"><i class="cc1">*</i>是否使用传真：</td>
					<td colspan=2>
						<input type="radio" name="faxFlag" value="Y"  <#if suppGoods?? && suppGoods.faxFlag=='Y'>checked=checked</#if>>是&nbsp;&nbsp;<span class="cc3">订单生成直接发送使用</span><br/>
						<input type="radio" name="faxFlag" value="N"  <#if suppGoods?? && suppGoods.faxFlag=='N'>checked=checked</#if>>否&nbsp;&nbsp;<span class="cc3"></span><br/>
	                	<label title="传真号码：<#if suppGoods??&&suppGoods.suppFaxRule??>${suppGoods.suppFaxRule.fax!''};</#if> 发送时间：<#if suppGoods??&&suppGoods.suppFaxRule??>${suppGoods.suppFaxRule.sendTime!''}</#if>" name="suppFaxRule.faxRuleName"><#if suppGoods?? && suppGoods.suppFaxRule?? && suppGoods.suppFaxRule.faxRuleName!="">${suppGoods.suppFaxRule.faxRuleName!''}</#if></label>
						<input type="hidden" id="faxRuleId" name="faxRuleId" <#if suppGoods?? && suppGoods.suppFaxRule?? && suppGoods.suppFaxRule.faxRuleId!="">value="${suppGoods.suppFaxRule.faxRuleId!''}"</#if>> 
						<a id="change_button_fax" href="#">[选择供应商传真名称]</a></br>
	                    <span class="cc3">若不使用传真，且不是二维码，则商品创建后，需要去ebk里面将商品添加到对应的供应商账户下。</span>
                    </td>
                </tr>
                <#if categoryId==17>
                <tr>
					<td class="e_label"><i class="cc1">*</i>成人数：</td>
					<td colspan=2>
						<select name="adult">
								<#list 1..100 as i>
	                            <option value="${i}" <#if i==suppGoods.adult>selected="selected"</#if>>${i}</option>
                                </#list>
						 </select>
                    </td>
                </tr>
                 <tr>
					<td class="e_label"><i class="cc1">*</i>儿童数：</td>
					<td colspan=2>
						<select name="child">
									<#list 0..100 as j>
		                            <option value="${j}" <#if j==suppGoods.child>selected="selected"</#if>>${j}</option>
                                    </#list>
						</select>
                    </td>
                </tr>
                </#if>
                <tr>
					<td class="e_label"><i class="cc1">*</i>结算币种：</td>
					<td colspan=2>
						<select name="currencyType" class="w10">
						<#list currencyTypeList as list>
		                      <option value=${list.code!''} <#if suppGoods!=null && suppGoods.currencyType==list.code>selected</#if>>${list.cnName!''}</option>
                        </#list>
						</select>
                    </td>
                </tr>
                <tr>
                    <td class="e_label"></td>
                    <td>
	                    <div class="fl operate">
		                    <a class="btn btn_cc1" id="save_button">保存</a>
							<a href="javascript:void(0);" style="margin-left:100px;" class="showLogDialog btn btn_cc1" param='objectId=${suppGoods.suppGoodsId}&objectType=SUPP_GOODS_GOODS&sysName=VST'>操作日志</a> 
						</div>
					</td>
                </tr>
            </tbody>
        </table>
</form>
</div>
</div>
<#include "/base/foot.ftl"/>
</body>
</html>

<#-- SETTLE_ENTITY_NEW_MARK  start -->
<script type="text/javascript" src="/vst_admin/js/vst_settlement_util.js?vsersion=201804121010"></script>
<#-- SETTLE_ENTITY_NEW_MARK  end -->
<script> 
vst_pet_util.superUserSuggest("#contentManagerName","input[name=contentManagerId]");
vst_pet_util.superUserSuggest("#managerName","input[name=managerId]");
vst_pet_util.commListSuggest("#supplierName", "#supplierId",'/vst_back/supp/supplier/searchSupplierList.do','${suppJsonList}',false,function(id){
	//获取供应商是否为子公司 和供应商的资质范围
    $.ajax({
            url : "/vst_back/supp/supplier/searchSupplierOperate.do",
			type : "post",
			dataType : 'json',
			data :{suppSupplierId:id},
			success : function(result) {
				    var html="";
					if(result["subsidiaryFlag"]=='Y'){
					 html+="子公司";
					}
					var qualifyType=result["qualifyType"];
					if(qualifyType!=null){
					   html+="&nbsp;资质范围：";
					$("input[name='qualifyTypeListInputHidden']").each(function(){
					  if(qualifyType.indexOf($(this).attr("code"))!=-1){
					  html+=$(this).val()+"&nbsp;";
					  }
					});
					}
					$("#signMsg").html(html);
			}
		});
});

<#-- SETTLE_ENTITY_NEW_MARK  start -->
vst_settlement_util.settleEntityCommListSuggest("#contractIdUpdate");
vst_settlement_util.settlementEntityNameBlur();
vst_settlement_util.settlementEntityNameFocus("#contractIdUpdate");
vst_settlement_util.buyoutSettleEntityCommListSuggest("#contractIdUpdate");
vst_settlement_util.buyoutSettlementEntityNameBlur();
vst_settlement_util.buyoutSettlementEntityNameFocus("#contractIdUpdate");
<#-- SETTLE_ENTITY_NEW_MARK  end -->
</script>

<script>
	$(function(){
		//提示公司主体为景域时文本显示
		$("select[name='companyType']").bind("change", function(){
			var companyTypeStr = $(this).val();
			if("JOYU" == companyTypeStr){
				var $span=$("<span class='error'>!仅台湾产品用景域这项</span>")
				$(this).parent().append($span);
			}else{
				$(this).parent().find(".error").remove();
			}
		});
	
		if('Y'==$("input[name='faxFlag'][checked]").val()){
				$("#change_button_fax").show();
		}else{
				$("#change_button_fax").hide();
		}	
	});
	
	  
	
	
		var selectContractDialog2;	
		var selectSuppFaxRule;
		//供应商合同回调函数
		function onSelectContract2(params){
			if(params!=null){
				$("input[name='suppContract.contractName']").val(params.contractName);
				$("input[id='contractIdUpdate']").val(params.contractId);
				var accCode =params.accSubject;
				//回调显示合同主体(取到合同的我方结算主体)
				var accSubjectCname='';
				$("input[name='lvAccSubjectListInputHidden']").each(function(){
					if(accCode==$(this).attr("code")){
					accSubjectCname=$(this).val();
					}
				
				});
                 $("#companyTypeHidden").val(lvSubjectCodeConvert(accCode));
                 $("#companyTypeNew").html(accSubjectCname);


			<#-- SETTLE_ENTITY_NEW_MARK  start -->
                vst_settlement_util.resetSelectSettleEntityNameInput();
                vst_settlement_util.buyoutResetSelectSettleEntityNameInput();
			<#-- SETTLE_ENTITY_NEW_MARK  end -->
			   
			}
			
			selectContractDialog2.close();
		}
		
		//供应商传真号回调函数
		function onSelectSuppFaxRule(params){
			if(params!=null){
				$("input[name='faxRuleId']").val(params.faxRuleId);
				$("label[name='suppFaxRule.faxRuleName']").text(params.faxRuleName);
				$("label[name='suppFaxRule.faxRuleName']").attr('title','传真号码：'+params.fax+'； 发送时间：'+params.sendTime);
			}
			selectSuppFaxRule.close();
		}
		
		//打开选择供应商合同列表
		$("#change_button_contract").click(function(){
		  
			if($("#supplierId").val()==""){
				$.alert("请选择供应商!");
				return;
			}
			selectContractDialog2 = new xDialog("/vst_back/supp/suppContract/selectContractListBySupplier.do?callback=onSelectContract2&supplierId="+$("#supplierId").val(),{},{title:"选择供应商合同",width:"600"});
		});
		
		//打开选择供应商传真号列表
		$("#change_button_fax").click(function(){
			selectSuppFaxRule = new xDialog("/vst_back/supp/fax/selectSuppFaxRuleList.do?callback=onSelectSuppFaxRule&supplierId="+$("#supplierId").val()+"&categoryId="+$("input[name='categoryId']").val(),{},{title:"选择供应商传真号",iframe:true,width:"800",height:"400"});
		});
		
		$("input[name='faxFlag']").change(function(){
			if('Y'==$(this).val()){
				$("#change_button_fax").show();
			}else{
				$("#change_button_fax").hide();
				$("input[name='faxRuleId']").val("");
				$("label[name='suppFaxRule.faxRuleName']").text("");
			}
			
		});
		var isSubmit = false;
		$("#save_button").click(function(){
		    debugger;
			if(isSubmit){
				return;
			}
            isSubmit = true;
			//验证
			var bFormValidation = $("#dataForm").validate().form();

            if($("#settlementEntityCode").val()=="" && $("#buyoutSettlementEntityCode").val()==""){
                $.alert("请绑定一个结算对象！");
                isSubmit = false;
                return false;
            }
            if($("#settlementEntityCode").val()!="" && $("#buyoutSettlementEntityCode").val()!="" && $("#settlementEntityBu").val() != $("#buyoutSettlementEntityBu").val()){
                $.alert("两个结算对象的合作BU不一致！");
                isSubmit = false;
                return false;
            }
			
			var filialeName = $("select.filialeCombobox").combobox("getValue");
			if(!filialeName) {
				var $combo = $("select.filialeCombobox").next();
				$("i[for=\"FILIALE\"]").remove();
				$combo.css('border-color', "red");
				$("<i for=\"FILIALE\" class=\"error\">该字段不能为空</i>").insertAfter($combo);
			}

			if(!bFormValidation || !filialeName){
                isSubmit = false;
				return false;
			}
			
			if($("input[name=faxFlag]:checked").size()==0){
				$.alert("请选择传真策略");
                isSubmit = false;
				return false;
			}
			
			if($("#contractIdUpdate").val()==""){
				$.alert("请选择供应商合同！");
                isSubmit = false;
				return false;
			}
			if('Y'==$("input:radio[name='faxFlag']:checked").val() && $("input[name='faxRuleId']").val()==""){
				$.alert("请选择供应商传真号！");
                isSubmit = false;
				return false;
			}
			
			var attrId = $("#attributionId").val();
			if("JOYU" == $("select[name='companyType']").val() 
				&& !("144" == attrId || "145" == attrId || "146" == attrId || "147" == attrId)) {
				$.confirm("合同主体和归属地不匹配。合同主体为景域，目前只适用于台湾；是否要断续保存？", function(){
					isSubmit = false;
					saveData();
				}, function(){
					isSubmit = false;
				});
			} else {
				isSubmit = false;
				saveData();
			}
		});
	
	//保存
	function saveData() {
		//遮罩层
		var loading = top.pandora.loading("正在努力保存中...");	
		$.ajax({
			url : "/vst_admin/tour/goods/goods/updateSuppGoodsBase.do",
			type : "post",
			dataType : 'json',
			data : $("#dataForm").serialize(),
			success : function(result) {
				loading.close();
				if(result.code == "success"){
					$.alert(result.message,function(){
						window.location = "/vst_admin/tour/goods/goods/showBaseSuppGoods.do?prodProductId="+$("#productId").val()+"&categoryId="+$("#categoryId").val();
					});
				}else {
					$.alert(result.message);
				}
                //isSubmit = false;
			},
			error : function(){
                //isSubmit = false;
				loading.close();
			}
		});
		
		
	}
	
    isView();
	
	$("#supplierName").change(function(){
		//取消合同
		$("#contractIdUpdate").val("");
		$("#contractName").val("");
		//取消传真
        var $browsers = $("input[name=faxFlag]");
        $browsers.attr("checked",false);
        $("#change_button_fax").hide();
        $("label[name='suppFaxRule.faxRuleName']").text("");
        $("#faxRuleId").val("");
	});
	
	
	var destSelectDialog;
	var markDest;
	var markDestId;
	//选择
	function onSelectDest(params){
		if(params!=null){
			$("#"+markDest).val(params.destName);
			$("#"+markDestId).val(params.destId);
		}
		destSelectDialog.close();
		$("#destError").hide();
	}

	//打开选择归属地窗口
	$("input[name=attributionName]").bind("click",function(){
		markDest = $(this).attr("id");
		markDestId = $("#attributionId").attr("id");
		var url = "/vst_admin/biz/attribution/selectAttributionList.do";
		destSelectDialog = new xDialog(url,{},{title:"选择归属地",iframe:true,width:"1000",height:"600"});
	});
	
	//提示add by zhoudengyun
	$("input[name=packageFlag]").bind('change',function(){
		var packageFlag = $(this).val();
		if(packageFlag=="Y"){
			$("#tips").show();
		}else{
			$("#tips").hide();
		}
	});

	$("select.filialeCombobox").combobox({
	    multiple:false,
	    width: 170,
	    filter:function(q,row){
			var opts=$(this).combobox("options");
			return row[opts.textField].indexOf(q) > -1;
		},
		onHidePanel: function () {
			var filialeName = $(this).combobox("getValue");
			if(!!filialeName) {
				$(".combo").css('border-color', "#abc");
				$("i[for=\"FILIALE\"]").css("display", "none");
			}
		}
	});
	
     //合同结算主体code转换 
	function lvSubjectCodeConvert(lvAccSubjectCode){
        var returnCode="";
        switch(lvAccSubjectCode){
			case "DEFAULT":
				returnCode="JOYU";
			break;        
        	case "LVMAMA":
				returnCode="GUOLV";
			break;  
			case "LVMAMAXINGLV":
				returnCode="XINGLV";
			break; 
			}
	   return returnCode;
	}
	
</script>
