<form  id="dataForm">
    <table class="p_table form-inline">
        <tbody>
     		<input id="ruleId" type="hidden" name="ruleId" value="${bizInsurCatRule.ruleId!''}">
     		<input id="insurType" type="hidden" name="insurType" value="${bizInsurCatRule.insurType!''}">
     		<input id="categoryId1" type="hidden" name="categoryId1" value="${categoryId1!''}">
            <tr>
            	 <td width="60" class="e_label"><i class="cc1">*</i>产品品类：</td>
                 <td class="w18">
                	 <select name="categoryId" id="categoryId" required>
	    				<#list bizCategoryList as bizCategory> 
		                    <option value=${bizCategory.categoryId!''} <#if bizInsurCatRule.bizCategory!=null && bizInsurCatRule.bizCategory.categoryId == bizCategory.categoryId>selected</#if> >${bizCategory.categoryName!''}</option>
		                </#list>
		        	</select>
				 </td>
            </tr>
             <tr>
            	 <td  width="60" class="e_label"><i class="cc1">*</i>险种：</td>
                 <td class="w18">
               <div id = "div1">
               
	    			<#list insurTypeDictList as insurTypeDict>
	    				<input type="checkbox" id="insurTypeSec"  name="insurTypeSec" value="${insurTypeDict.dictId!''}" required <#if bizInsurCatRule.insurType?contains(insurTypeDict.dictId?string) >checked</#if> />${insurTypeDict.dictName!''}
		             </#list>
		            
               </div>
		             <div id="insurTypeSecError"></div>
				 </td>
            </tr>
             <tr>
				<td  width="60" class="e_label"><i class="cc1">*</i>是否考虑目的地：</td>
                <td>
                 	<span id="spandestFlagY"> <input type="radio"  name="destFlag"  value="Y" required <#if bizInsurCatRule.destFlag == 'Y'>checked</#if> 
                 	 /> 是</span>
		             <span id= "spandestFlagN"><input type="radio"  name="destFlag" id="destFlagN" value="N" required <#if bizInsurCatRule.destFlag == 'N'>checked</#if> 
                 	 /> 否 </span>
                 	 <div id="destFlagError"></div>
                </td>
            </tr>
            <tr>
            	 <td  width="60" class="e_label"><i class="cc1">*</i>是否考虑被保天数：</td>
                <td> 
                	<input type="radio"  name="daysFlag" value="Y" required <#if bizInsurCatRule.daysFlag == 'Y'>checked</#if> 
                 	 /> 是
		             <input type="radio"  name="daysFlag"  value="N" required <#if bizInsurCatRule.daysFlag == 'N'>checked</#if> 
                 	 /> 否  
                 	 <div id="daysFlagError"></div>
                 </td>
            </tr>
            <tr>
            	 <td  width="60" class="e_label"><i class="cc1">*</i></td>
                <td> 
					被保天数必须
                	<select name="daysType" required>
                		<#list daysTypeList as list>
                 	 		<option value="${list.code!''}" <#if list.code == bizInsurCatRule.daysType >selected</#if> >${list.cnName!''}</option>
		                </#list>
                	</select>
					行程天数
					<div id="daysTypeError"></div>
                 </td>
            </tr>
             <tr id="trLineFlag" <#if bizInsurCatRule.bizCategory.categoryId != 8 >style="display:none"</#if>>
            	 <td  width="60" class="e_label"><i class="cc1">*</i>是否考虑航线</td>
                <td> 
                	<input type="radio"  id ="lineFlag" name="lineFlag" value="Y" readOnly required checked
                 	 /> 是
                 	 <div id="daysFlagError"></div>
                 </td>
            </tr>
        </tbody>
    </table>
</form>

<button class="pbtn pbtn-small btn-ok" style="float:right;margin-top:20px;" id="saveButton">保存</button>
<script>

$(function() { 
	 if($("#categoryId option:selected").val() == 8) {
				$("#trLineFlag").show();
				$("#spandestFlagY").hide();
				//$("#spandestFlagN").show();
				$("#destFlagN").attr("checked","checked");
				$("#destFlagN").attr("readonly","readonly");
				$("[name='insurTypeSec']").attr("disabled",true);
				$("#lineFlag").attr("disabled",false);
		} else {
			$("#trLineFlag").hide();
			$("#spandestFlagY").show();
			$("[name='insurTypeSec']").attr("disabled",false);
			$("#lineFlag").attr("disabled",true);
			$("#destFlagN").attr("readonly",false);
		}
});

$("#categoryId").change(function(){
		//邮轮
		if($("#categoryId option:selected").val() == 8) {
				 $("[name='insurTypeSec']").each(function(){
	 			 	if($(this).val() == 734) {
	 			 		 $(this).attr("checked",true); 
	 			 		 //alert($(this).attr("checked"));
	 			 	} else {
	 			 		$(this).attr("checked",false); 
	 			 	}   
	 			 });
	 			$("[name='insurTypeSec']").attr("disabled",true);
				$("#trLineFlag").show();
				$("#spandestFlagY").hide();
				$("#destFlagN").attr("checked","checked");
				$("#destFlagN").attr("readonly","readonly");
				$("#lineFlag").attr("disabled",false);
		} else {
		 $("[name='insurTypeSec']").each(function(){
	 			  $(this).attr("checked",false); 
	 		});
			$("#trLineFlag").hide();
			$("[name='insurTypeSec']").attr("disabled",false);
			$("#spandestFlagY").show();
			$("#lineFlag").attr("disabled",true);
			//$("#destFlagN").attr("checked",false);
			$("#destFlagN").attr("readonly",false);
		}
	}
);

$("#saveButton").bind("click",function(){
	$(this).attr("disabled","disabled");
	
	var insurTypeStr=",";
	$("input[name='insurTypeSec']:checked").each(function(){
     	if($(this).val()!=""){
     		if(insurTypeStr == ","){
     			insurTypeStr = $(this).val();
     		}else{
     			insurTypeStr = insurTypeStr + "," + $(this).val();
     		}
     	}
	});
	$("#insurType").val(insurTypeStr);
	
	//验证
	if (!$("#dataForm").validate({
		}).form()) {
			$(this).removeAttr("disabled");
			return false;
		}
		//遮罩层
		var loading = pandora.loading("正在努力保存中...");
		$.ajax({
			url : "/vst_admin/insurance/InsurCatRule/saveInsurCatRule.do",
			type : "post",
			dataType : 'json',
			data : $("#dataForm").serialize(),
			success : function(result) {
				if (result.code == "success") {
					loading.close();
					pandora.dialog({wrapClass: "dialog-mini", content:result.message, mask:true,okValue:"确定",ok:function(){
						$("#saveButton").removeAttr("disabled");
						saveDialog.close();
						window.location.reload();
					}});
				} else {
					$.alert(result.message);
					loading.close();
					$("#saveButton").removeAttr("disabled");
				}
			},
			error : function() {
				loading.close();
				$("#saveButton").removeAttr("disabled");
			}
		});

	});
</script>
