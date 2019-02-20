<#list lvAccSubjectList as accSubjectInfo>
<input type="hidden" name="lvAccSubjectListInputHidden" code="${accSubjectInfo.code!''}" value="${accSubjectInfo.subName!''}">
</#list>
<form action="/vst_admin/goods/traffic/addSuppGoods.do" method="post" id="dataForm" class="goodsForm">
		<input type="hidden" name="supplierId" value="${suppGoods.suppSupplier.supplierId}">
		<input type="hidden" name="productId" value="${suppGoods.prodProduct.productId}">   
		<input type="hidden" name="stockApiFlag" value="N">
		<input type="hidden" name="senisitiveFlag" value="N">
        <table class="p_table form-inline">
            <tbody>
                <tr>
                	<td class="p_label"><i class="cc1">*</i>所属规格：</td>
                	<td colspan=2>
                		<#if prodProductBranchList?size gt 0>
	                		<select name="productBranchId" required>
									  	<option value="">请选择</option>
									  	<#list prodProductBranchList as prodProductBranch>
						                    <option value="${prodProductBranch.productBranchId}" <#if suppGoods?? && suppGoods.prodProductBranch?? && suppGoods.prodProductBranch.productBranchId==prodProductBranch.productBranchId>selected</#if> >${prodProductBranch.branchName}</option>
									  	</#list>
		                	</select>
		                <#else>	
		                	<span class="notnull">请先创建产品规格!</span>
                		</#if>
                	</td>
                </tr>
				<tr>
                	<td class="p_label"><i class="cc1">*</i>商品名称：</td>
                    <td colspan=2>
                    	<input type="text" name="goodsName" style="width:260px" value="" required>
                    </td>
                </tr>
              <#if traffic??>
              
                <tr>
                	<td class="p_label"><i class="cc1">*</i><#if traffic??&&traffic.toBackType=='Y'>去程</#if>班次：</td>
                    <td colspan=2>
                    	<input type="text" name="suppGoodsBus.toNumberOfRuns" style="width:260px" value="" required  maxlength="20" >
                    </td>
                </tr>
                <tr>
                	<td class="p_label"><i class="cc1">*</i><#if traffic??&&traffic.toBackType=='Y'>去程</#if>出发时间：</td>
                    <td colspan=2>
                    	<input type="text" name="suppGoodsBus.toDepartureTime" errorEle="selectDate" class="Wdate" required=true   onClick="WdatePicker({readOnly:true, dateFmt:'HH:mm'})" />
                    </td>
                </tr>
                <tr>
                	<td class="p_label"><i class="cc1">*</i><#if traffic??&&traffic.toBackType=='Y'>去程</#if>行程时间(约)：</td>
                    <td colspan=2>
                    	<input type="text" name="suppGoodsBus.toTravelTime" style="width:260px" value="" required  maxlength="20" >
                    </td>
                </tr>
                  
                <#if traffic.toBackType=='Y'>
                <tr>
                	<td class="p_label"><i class="cc1">*</i>返程班次：</td>
                    <td colspan=2>
                    	<input type="text" name="suppGoodsBus.backNumberOfRuns" style="width:260px" value="" required  maxlength="20">
                    </td>
                </tr>
                <tr>
                	<td class="p_label"><i class="cc1">*</i>返程出发时间：</td>
                    <td colspan=2>
                    	<input type="text" name="suppGoodsBus.backDepartureTime" errorEle="selectDate" class="Wdate" required=true   onClick="WdatePicker({readOnly:true, dateFmt:'HH:mm'})" />
                    </td>
                </tr>
                <tr>
                	<td class="p_label"><i class="cc1">*</i>返程行程时间(约)：</td>
                    <td colspan=2>
                    	<input type="text" name="suppGoodsBus.backTravelTime" style="width:260px" value="" required  maxlength="20">
                    </td>
                </tr>
                </#if>
               </#if> 
               	<tr>
					<td class="p_label"><i class="cc1">*</i>内容维护人员：</td>
					<td colspan=2>
						<input type="text" name="contentManagerName" id="contentManagerName" value="${suppGoods.contentManagerName}" required=true>
                    	<input type="hidden" value="${suppGoods.contentManagerId}" name="contentManagerId" id="contentManagerId" required=true>
                   	</td>
                </tr>
                 <tr>
					<td class="p_label"><i class="cc1">*</i>产品经理：</td>
					<td colspan=2>
						<input type="text" name="managerName" id="managerName" value="${suppGoods.managerName}" required=true>
                    	<input type="hidden" value="${suppGoods.managerId}" name="managerId" id="managerId" required=true>
                   	</td>
                </tr>
                <tr>
					<td class="p_label"><i class="cc1">*</i>商品合同：</td>
					<td colspan=2 class=" operate mt10">
						<label id="contractNameAdd" name="contractName"> <#if suppGoods!=null && suppGoods.suppContract!=null>${suppGoods.suppContract.contractName}</#if></label>
						<input type="hidden" id="contractIdAdd" name="contractId" <#if suppGoods!=null && suppGoods.suppContract!=null> value="${suppGoods.suppContract.contractId}"</#if>>
						<a id="change_button_contract" href="javascript:void(0);">[更改]</a>
                   	</td>
                </tr>
                
                <#-- SETTLE_ENTITY_NEW_MARK start  -->
                <tr>
                    <td class="p_label"><i class="cc1">*</i>结算对象：</td>
                    <td colspan=2 id="settlementEntityTd">
                        <input type="text" name="settlementEntityName" id="settlementEntityName" <#if suppGoods!=null && suppGoods.settlementEntity!=null> value="${suppGoods.settlementEntity.name}"</#if> required=true>
                        <input type="hidden" name="settlementEntityCode" id="settlementEntityCode" <#if suppGoods!=null && suppGoods.settlementEntity!=null> value="${suppGoods.settlementEntity.code}"</#if> required=true>
                        <input type="hidden" <#if suppGoods!=null && suppGoods.settlementEntity!=null> value="${suppGoods.settlementEntity.id}"</#if> name="settlementEntityId" id="settlementEntityId" required=true>
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
                <#-- SETTLE_ENTITY_NEW_MARK  end -->
                
                <tr>
		        	 <td class="p_label"><i class="cc1">*</i>我方结算主体：</td>
		             <td>
						<#--<select name="companyType" required style="width:250px;">
							<#list companyTypeMap?keys as key>
					  			<option value="${key}"<#if key == "XINGLV" >selected="selected"</#if> >${companyTypeMap[key]}</option>
						  	</#list>
					  	</select> -->
                        
                        <input type="hidden"  name="companyType" id="companyTypeHidden" value="${suppGoods.companyType!''}"  />
                        
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
                        
		            </td>
		        </tr>
                <tr   style="display:none">
					<td class="p_label"><i class="cc1">*</i>支付对象：</td>
					<td colspan=2>
						<select name="payTarget" required=true>
                    	 			<option value="">请选择</option>
		    				<#list payTargetList as list>
			                    	<option value=${list.code!''} <#if list.code=='PREPAID'>selected="selected"</#if>>${list.cnName!''}</option>
			                </#list>
			        	</select>
                    </td>
                </tr>
                <tr>
					<td class="p_label"><i class="cc1">*</i>分公司：</td>
					<td colspan=2>
						<select name="filiale" class="filialeCombobox">
                    	 			<option value="">请选择</option>
		    				<#list filialeList as list>
			                    	<option value=${list.code!''}>${list.cnName!''}</option>
			                </#list>
			        	</select>
                    </td>
                </tr>
                
                <tr>
					<td class="p_label"><i class="cc1">*</i>BU：</td>
					<td colspan=2>
			        	<select name="bu" required>
		    	 			<option value="">请选择</option>
						<#list buList as list>
		                	<option value=${list.code!''}>${list.cnName!''}</option>
			            </#list>
				    	</select>
	                </td>
	            </tr>
                
                <tr>
					<td class="p_label"><i class="cc1">*</i>归属地：</td>
					<td colspan=2>
						<input type="text" name="attributionName" id="attributionName"  readonly = "readonly" required />
						<input type="hidden" name="attributionId" id="attributionId"  required />
                    </td>
                </tr>
	            
	            
                <tr>
					<td class="p_label"><i class="cc1">*</i>是否有效：</td>
					<td colspan=2>是
						<#--<select name="cancelFlag" required>-->
	                    	<#--<option value="Y" <#if suppGoods!=null && suppGoods.cancelFlag=='Y'>selected</#if>>是</option>-->
	                    	<#--<option value="N" <#if suppGoods!=null && suppGoods.cancelFlag=='N'>selected</#if>>否</option>-->
	                    <#--</select>-->
                    </td>
                </tr> 
                <tr>
					<td class="p_label"><i class="cc1">*</i>是否仅组合销售：</td>
					<td colspan=2>
						<input type="radio" name="packageFlag" value="Y" checked>是
	                	<input type="radio" name="packageFlag" value="N">否
                    </td>
                </tr>                  
                <tr>
					<td class="p_label"><i class="cc1">*</i>是否使用传真：</td>
					<td colspan=2>
						<input type="radio" name="faxFlag" value="N" >否&nbsp;&nbsp;<span class="cc3"></span><br/>
						<input type="radio" name="faxFlag" value="Y" checked>是&nbsp;&nbsp;<span class="cc3">订单生成直接发送使用</span><br/>
	                	<label name="suppFaxRule.faxRuleName" id="faxRuleName" <#if suppFaxRule!=null && suppFaxRule.faxRuleName!=null> value="${suppFaxRule.faxRuleName}"</#if>></label>
						<input type="hidden" name="faxRuleId" id="faxRuleId" <#if suppFaxRule!=null && suppFaxRule.faxRuleId!=null> value="${suppFaxRule.faxRuleId}"</#if>>
	                    <a id="change_button_fax" href="#">[选择供应商传真名称]</a></br>
	                    <span class="cc3">若不使用传真，且不是二维码，则商品创建后，需要去ebk里面将商品添加到对应的供应商账户下。</span>
                    </td>
                </tr>
                <tr>
					<td class="p_label"><i class="cc1">*</i>最少起订份数：</td>
					<td colspan=2>
						<input type="text" name="minQuantity"  min=0 max=999 required=true >
                    </td>
                </tr>
                <tr>
					<td class="p_label"><i class="cc1">*</i>最多订购份数：</td>
					<td colspan=2>
						<input type="text" name="maxQuantity" min=0 max=999 required=true>
                    </td>
                </tr>
                <tr>
					<td class="p_label"><i class="cc1">*</i>退改策略：</td>
					<td colspan=2>
						<input type="radio" name="cancelStrategy" value="UNRETREATANDCHANGE" checked/>不退不改</br>
						<input type="radio" name="cancelStrategy" value="MANUALCHANGE" />人工退改
                    </td>
                </tr>
				<#include "/base/showDistributorGoods.ftl"/>
            </tbody>
        </table>
</form>
<div class="p_box box_info clearfix mb20">
     <div class="fl operate" style="margin-top:20px;"><a class="btn btn_cc1" id="save">保存</a></div>
</div>
<#-- SETTLE_ENTITY_NEW_MARK  start -->
<script type="text/javascript" src="/vst_admin/js/vst_settlement_util.js"></script>
<#-- SETTLE_ENTITY_NEW_MARK  end -->
<script> 
vst_pet_util.superUserSuggest("#contentManagerName","input[name=contentManagerId]");
vst_pet_util.superUserSuggest("#managerName","input[name=managerId]");

<#-- SETTLE_ENTITY_NEW_MARK  start -->
vst_settlement_util.settleEntityCommListSuggest("#contractIdAdd");
vst_settlement_util.settlementEntityNameBlur();
vst_settlement_util.settlementEntityNameFocus("#contractIdAdd");
<#-- SETTLE_ENTITY_NEW_MARK  end -->
</script>

<script>
		var selectContractDialog2;
		var selectSuppFaxRule;
		//供应商合同回调函数
		function onSelectContract2(params){
			if(params!=null){
				$("#contractNameAdd").text(params.contractName);
				$("#contractIdAdd").val(params.contractId);
				
				<#-- SETTLE_ENTITY_NEW_MARK  start -->
                vst_settlement_util.resetSelectSettleEntityNameInput();
		        <#-- SETTLE_ENTITY_NEW_MARK  end -->
				
				var accCode =params.accSubject;
				//回调显示合同主体(取到合同的我方结算主体)
				var accSubjectCname='';
				$("input[name='lvAccSubjectListInputHidden']").each(function(){
					if(accCode == $(this).attr("code")){
					   accSubjectCname=$(this).val();
					}
				
				});
                 $("#companyTypeHidden").val(lvSubjectCodeConvert(accCode));
                 $("#companyTypeNew").html(accSubjectCname);
			}
			selectContractDialog2.close();
		}
		//供应商传真号回调函数
		function onSelectSuppFaxRule(params){
			if(params!=null){
				$("#faxRuleName").text(params.faxRuleName);
				$("#faxRuleId").val(params.faxRuleId);
			}
			selectSuppFaxRule.close();
		}
		
		//打开选择供应商合同列表
		$("#change_button_contract").click(function(){
			selectContractDialog2 = new xDialog("/vst_back/supp/suppContract/selectContractListBySupplier.do?callback=onSelectContract2&supplierId="+$("#supplierId").val(),{},{title:"选择供应商合同",width:"600"});
		});
		
		//打开选择供应商传真号列表
		$("#change_button_fax").click(function(){
			selectSuppFaxRule = new xDialog("/vst_back/supp/fax/selectSuppFaxRuleList.do?callback=onSelectSuppFaxRule&supplierId="+$("#supplierId").val()+"&categoryId="+$("input[name='prodProduct.bizCategory.categoryId']").val(),{},{title:"选择供应商传真号",iframe:true,width:"800",height:"400"});
		});
		$("input[name='faxFlag']").change(function(){
			if('Y'==$(this).val()){
				$("#change_button_fax").show();
			}else{
				$("#change_button_fax").hide();
			}
			
		});
		
		
		$("#save").bind("click",function(){
				
				//var distributorChecked = document.getElementById("distributorIds_4").checked;
				//if(distributorChecked){
				//	var distributorUserIds = $("input:checkbox[name='distributorUserIds']:checked").val();
				//	if(typeof(distributorUserIds) =="undefined"){
				//		alert("请选择super系统分销商.");
				//		return;
				//	}
				//}
				//var ids = '';
				//$("input:checkbox[name='distributorIds']").each(function(){
				//	 if($(this).attr('checked')=='checked'){
				//	 	  ids = $(this).val();
				//	 }
				//});
				//if(ids==''){
				//	alert('请选择适用渠道!!');
				//	return;
				//}
				//验证
				var bFormValidation = $("#dataForm").validate().form();
				
				var filialeName = $("select.filialeCombobox").combobox("getValue");
				if(!filialeName) {
					var $combo = $("select.filialeCombobox").next();
					$("i[for=\"FILIALE\"]").remove();
					$combo.css('border-color', "red");
					$("<i for=\"FILIALE\" class=\"error\">该字段不能为空</i>").insertAfter($combo);
				}
				if(!bFormValidation || !filialeName){return false;}
				
				if($("#contractIdAdd").val()==""){
					$.alert("请选择供应商合同！");
					return false;
				}
				if('Y'==$("input:radio[name='faxFlag']:checked").val() && $("input[name='faxRuleId']").val()==""){
					$.alert("请选择供应商传真号！");
					return false;
				}
				
				var msg = '确认保存吗 ？';	
				if(refreshSensitiveWord($(".goodsForm").find("input[type='text'],textarea"))){
					$("input[name=senisitiveFlag]").val("Y");
			 		msg = '内容含有敏感词,是否继续?';
			 	}else {
			 		$("input[name=senisitiveFlag]").val("N");
			 	}
			 	$("#save").hide();
				$.confirm(msg,function(){
					$.ajax({
						url : "/vst_admin/goods/traffic/addSuppGoods.do",
						type : "post",
						data : $(".dialog #dataForm").serialize(),
						success : function(result) {
							if (!(result.code == "success")) {
								$("#save").show(); 
							}
							confirmAndRefresh(result);
						},
						error : function(){
							$("#save").show(); 
						}
					})
				},function(){
					$("#save").show(); 
				});
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